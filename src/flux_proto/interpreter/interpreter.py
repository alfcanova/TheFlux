from __future__ import annotations

import re
from datetime import datetime as _dt, timedelta as _td, timezone as _tz
from typing import Any

from flux_proto import input_utils
from flux_proto.floating import FLOAT_FORMATS, round_value
from flux_proto.interpreter.environment import DEFAULT_VALUES, FSet, Environment, Value
from flux_proto.parser.import_resolver import collect_op_aliases
from flux_proto.parser.ast import (
    ASTNode, FluxProgram, FdslFile, FunctionDef, BlockStmt,
    Literal, Identifier, BinaryOp, UnaryOp, CallExpr,
    PrintStmt, ExpressionStmt, RouteStmt, RouteArm,
    MatchStmt, MatchArm, MatchExpr, InfiniteStmt, BreakStmt, ContinueStmt,
    StructInit, InitField, FieldAccess,
    EmitStmt, OwnershipExpr, UnsafeStmt, SpawnExpr, AwaitExpr,
    PtrRefExpr, PtrDerefExpr, ExternDecl, PtrAssign,
    VariableReassign, Parameter, PrimitiveType, CastExpr, FieldAssign,
    IndexAccess, IndexAssign, SliceSpec, LambdaExpr,
    DataflowExpr, DataflowCastSink, StorageDecl, StorageItem,
    MatchInlineExpr,
    ShortCircuitBlock, ShortCircuitArm, InputExpr, SpyExpr,
    ComptimeExpr, QuoteExpr, UnquoteExpr,
    ErrorExpr,
    InterpolatedString, InterpolatedText, EnumVariant,
    ListLiteral, SetLiteral, MapLiteral, MapEntry, RecordLiteral,
    WildcardPattern, LiteralPattern, IdentifierPattern,
    StructPattern, EnumVariantPattern, RecordPattern, DataPattern, ListPattern,
)


class InterpreterError(Exception):
    pass


_VIRT_ARENA = bytearray()


def _virt_alloc(nbytes: int) -> int:
    idx = len(_VIRT_ARENA)
    _VIRT_ARENA.extend(b"\x00" * nbytes)
    return idx


def _virt_read_i64(addr: int) -> int:
    raw = bytes(_VIRT_ARENA[addr:addr + 8])
    return int.from_bytes(raw, byteorder="little", signed=True)


def _virt_write_i64(addr: int, value: int) -> None:
    _VIRT_ARENA[addr:addr + 8] = int(value).to_bytes(8, byteorder="little", signed=True)


class _SinkValue:
    def __init__(self, value: "Value") -> None:
        self.value = value


_INT_TYPES = {
    "int8", "int16", "int32", "int64",
    "uint8", "uint16", "uint32", "uint64",
}

_INT_FORMATS = _INT_TYPES

_COMPLEX_COMPONENTS = {
    "complex32": "float16",
    "complex64": "float32",
    "complex128": "float64",
}

_DATETIME_RE = re.compile(
    r"^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})(?:\.(\d{1,9}))?(Z|[+-]\d{2}(?::?\d{2})?)?$"
)

_TENSOR_RE = re.compile(r"tensor\[([0-9,\s]+)\] of (\w+)")


def _tensor_dims(tname: str) -> list[int]:
    m = _TENSOR_RE.match(tname)
    if m is None:
        return []
    dims = [int(d) for d in m.group(1).split(",") if d.strip()]
    return [d for d in dims if d > 0]


def _nested_zeros(dims: list[int]) -> list:
    if not dims:
        return []
    if len(dims) == 1:
        return [0] * dims[0]
    return [_nested_zeros(dims[1:]) for _ in range(dims[0])]


def _tensor_strides(dims: list[int]) -> list[int]:
    s = [1] * len(dims)
    for k in range(len(dims) - 2, -1, -1):
        s[k] = s[k + 1] * dims[k + 1]
    return s


def _tensor_flat_len(dims: list[int]) -> int:
    n = 1
    for d in dims:
        n *= d
    return n


def _tensor_elem_type(tname: str) -> str:
    m = _TENSOR_RE.match(tname)
    return m.group(2) if m else "float64"


class TensorView:
    """Janela de leitura/escrita sobre o buffer flat de um tensor.

    Compartilha memória com o tensor pai via strides/offset.
    Fórmula linear (0-based): off = offset + Σ kᵢ·sᵢ
    Conversão inversa (linear L → coords): kᵢ = ⌊L / sᵢ⌋ mod dᵢ
    """

    def __init__(self, base: "Value", shape: list[int], strides: list[int], offset: int, elem_type: str) -> None:
        self.base = base
        self.shape = list(shape)
        self.strides = list(strides)
        self.offset = offset
        self.elem_type = elem_type

    @property
    def type_name(self) -> str:
        return f"tensor[{', '.join(str(d) for d in self.shape)}] of {self.elem_type}"

    @property
    def data(self) -> list:
        return self.base.data


def _resolve_slice(idx: SliceSpec, d: int, ev) -> tuple[int, int, int]:
    step = 1 if idx.step is None else ev(idx.step).data
    if not isinstance(step, int) or isinstance(step, bool):
        raise InterpreterError(f"tensor slice step must be an integer, got '{step}'")
    if step == 0:
        raise InterpreterError("tensor slice step cannot be zero")
    if step > 0:
        a = 1 if idx.start is None else ev(idx.start).data
        b = d if idx.end is None else ev(idx.end).data
    else:
        a = d if idx.start is None else ev(idx.start).data
        b = 1 if idx.end is None else ev(idx.end).data
    for name, v in (("início", a), ("fim", b)):
        if not isinstance(v, int) or isinstance(v, bool) or v < 1 or v > d:
            raise InterpreterError(f"slice {v} fora do intervalo (1..{d}) na dimensão ({name})")
    if step > 0 and a > b:
        raise InterpreterError(f"slice range error: start ({a}) > end ({b}) with positive step")
    if step < 0 and a < b:
        raise InterpreterError(f"slice range error: start ({a}) < end ({b}) with negative step")
    count = (abs(b - a) // abs(step)) + 1
    return count, step, a - 1


def _materialize_tensor(tv: TensorView) -> "Value":
    def rec(dim: int, off: int) -> list:
        if dim == len(tv.shape) - 1:
            st = tv.strides[dim]
            return [tv.base.data[off + j * st] for j in range(tv.shape[dim])]
        return [rec(dim + 1, off + j * tv.strides[dim]) for j in range(tv.shape[dim])]

    nested = rec(0, tv.offset)
    return Value(type_name=tv.type_name, data=_flatten_tensor_literal(nested, tv.shape))


def _check_tensor_shape(data: Any, dims: list[int], depth: int = 0) -> None:
    if depth >= len(dims):
        if isinstance(data, list):
            raise InterpreterError("tensor literal nests deeper than declared dimensions")
        return
    if not isinstance(data, list):
        raise InterpreterError(f"tensor shape mismatch: expected {dims}, literal is not nested enough")
    if len(data) != dims[depth]:
        raise InterpreterError(
            f"tensor shape mismatch: expected {dims}, dimension {depth + 1} has {len(data)} elements"
        )
    for item in data:
        _check_tensor_shape(item, dims, depth + 1)


def _flatten_tensor_literal(data: Any, dims: list[int]) -> list:
    out: list = []

    def rec(node: Any, k: int) -> None:
        if k == len(dims) - 1:
            out.extend(node)
        else:
            for sub in node:
                rec(sub, k + 1)

    if dims:
        rec(data, 0)
    return out


def _parse_complex_literal(s: str) -> complex:
    return complex(s[:-1] + "j") if s.endswith("i") else complex(s)


def _parse_iso_nanos(s: str) -> int:
    m = _DATETIME_RE.match(s)
    if m is None:
        raise InterpreterError(f"invalid datetime literal '{s}'")
    y, mo, d, h, mi, sec, frac, off = m.groups()
    frac = (frac or "") + "000000000"
    nanos = int(frac[:9])
    if not off or off == "Z":
        delta = _td(0)
    else:
        sign = 1 if off[0] == "+" else -1
        body = off[1:]
        if ":" in body:
            oh, om = int(body[:2]), int(body[3:5])
        elif len(body) == 4:
            oh, om = int(body[:2]), int(body[2:4])
        else:
            oh, om = int(body[:2]), 0
        delta = _td(hours=sign * oh, minutes=sign * om)
    utc = _dt(int(y), int(mo), int(d), int(h), int(mi), int(sec), tzinfo=_tz.utc) - delta
    return int(utc.timestamp()) * 1_000_000_000 + nanos


def _format_iso_nanos(nanos: int) -> str:
    base = _dt.fromtimestamp(nanos // 1_000_000_000, tz=_tz.utc)
    frac = nanos % 1_000_000_000
    return f"{base.strftime('%Y-%m-%dT%H:%M:%S')}.{frac:09d}Z"


def _round_complex(val: complex, tname: str) -> complex:
    comp = _COMPLEX_COMPONENTS.get(tname)
    if comp is None:
        return val
    return complex(round_value(val.real, comp), round_value(val.imag, comp))


def _euclid_rem(a: int, b: int) -> int:
    r = a % b
    if r < 0:
        r += abs(b)
    return r

def _euclid_div(a: int, b: int) -> int:
    r = _euclid_rem(a, b)
    return (a - r) // b

def _pow_e(a: Any, b: Any) -> Any:
    if isinstance(a, int) and isinstance(b, int):
        if b >= 0:
            return a ** b
        return 1
    return float(a) ** float(b)

def _pow_r(a: Any, b: Any) -> float:
    return float(a) ** (1.0 / float(b))

_BINOP = {
    "+": lambda a, b: a + b, "-": lambda a, b: a - b,
    "*": lambda a, b: a * b,
    "/i": lambda a, b: _euclid_div(a, b),
    "/f": lambda a, b: a / b,
    "/r": lambda a, b: _euclid_rem(a, b),
    "^e": _pow_e,
    "^r": _pow_r,
    "&": lambda a, b: a & b, "|": lambda a, b: a | b,
    "^": lambda a, b: a ^ b,
    "<<": lambda a, b: a << b,
    ">>": lambda a, b: a >> b,
    ">>>": lambda a, b: (a & 0xFFFFFFFFFFFFFFFF) >> b,
    "==": lambda a, b: a == b, "!=": lambda a, b: a != b,
    "<": lambda a, b: a < b, "<=": lambda a, b: a <= b,
    ">": lambda a, b: a > b, ">=": lambda a, b: a >= b,
    "and": lambda a, b: a and b, "or": lambda a, b: a or b,
    "in": lambda a, b: a in b,
}

_COLLECTION_TYPES = ("list", "set", "map", "data")


def _is_collection(tname: str) -> bool:
    return tname in _COLLECTION_TYPES or tname.startswith("tensor")


def _wrap_elem(item: Value) -> Any:
    return item.data if _is_collection(item.type_name) else item


def _sort_key(el: Any) -> tuple:
    if isinstance(el, Value):
        t, d = el.type_name, el.data
        if t.startswith(("int", "uint")):
            return (0, d)
        if t.startswith("float") or t in ("fp8_e4m3", "fp8_e5m2", "bf16_e8m7", "tf32_e8m10"):
            return (1, d)
        if t == "bool":
            return (2, int(d))
        if t == "string":
            return (3, d)
        return (9, repr(d))
    return (8, 0)


def _std_list_length(interp: "Interpreter", args: list[Value]) -> Value:
    return Value(type_name="int64", data=len(args[0].data))


def _std_list_is_empty(interp: "Interpreter", args: list[Value]) -> Value:
    return Value(type_name="bool", data=len(args[0].data) == 0)


def _std_list_contains(interp: "Interpreter", args: list[Value]) -> Value:
    return Value(type_name="bool", data=args[1] in args[0].data)


def _std_list_clear_all(interp: "Interpreter", args: list[Value]) -> Value:
    v = args[0]
    return Value(type_name=v.type_name, data=[])


def _std_list_push_back(interp: "Interpreter", args: list[Value]) -> Value:
    items, item = args
    items.data.append(_wrap_elem(item))
    return items


def _std_list_push_front(interp: "Interpreter", args: list[Value]) -> Value:
    items, item = args
    items.data.insert(0, _wrap_elem(item))
    return items


def _std_list_insert_at(interp: "Interpreter", args: list[Value]) -> Value:
    items, index, item = args
    idx = index.data
    if idx < 1 or idx > len(items.data) + 1:
        raise InterpreterError(f"index {idx} out of range (1..{len(items.data) + 1})")
    items.data.insert(idx - 1, _wrap_elem(item))
    return items


def _std_list_remove_at(interp: "Interpreter", args: list[Value]) -> Value:
    items, index = args
    idx = index.data
    if idx < 1 or idx > len(items.data):
        raise InterpreterError(f"index {idx} out of range (1..{len(items.data)})")
    items.data.pop(idx - 1)
    return items


def _std_list_remove_last(interp: "Interpreter", args: list[Value]) -> Value:
    items = args[0]
    if not items.data:
        raise InterpreterError("cannot removeLast from empty list")
    items.data.pop()
    return items


def _std_list_sort_ascending(interp: "Interpreter", args: list[Value]) -> Value:
    items = args[0]
    items.data.sort(key=_sort_key)
    return items


def _std_list_sort_descending(interp: "Interpreter", args: list[Value]) -> Value:
    items = args[0]
    items.data.sort(key=_sort_key, reverse=True)
    return items


def _std_list_reverse(interp: "Interpreter", args: list[Value]) -> Value:
    items = args[0]
    items.data.reverse()
    return items


def _std_list_flatten(interp: "Interpreter", args: list[Value]) -> Value:
    items = args[0]
    out: list[Any] = []
    for el in items.data:
        if isinstance(el, list):
            out.extend(el)
        else:
            out.append(el)
    return Value(type_name="list", data=out)


def _std_list_partition(interp: "Interpreter", args: list[Value]) -> Value:
    items, size = args
    n = size.data
    if n <= 0:
        raise InterpreterError(f"partition size must be positive, got {n}")
    out = [items.data[i:i + n] for i in range(0, len(items.data), n)]
    return Value(type_name="list", data=out)


def _std_list_zip(interp: "Interpreter", args: list[Value]) -> Value:
    left, right = args
    n = min(len(left.data), len(right.data))
    out = [[left.data[i], right.data[i]] for i in range(n)]
    return Value(type_name="list", data=out)


def _std_list_unzip(interp: "Interpreter", args: list[Value]) -> Value:
    pairs = args[0]
    left: list[Any] = []
    right: list[Any] = []
    for p in pairs.data:
        if not isinstance(p, list) or len(p) != 2:
            raise InterpreterError("unzip expects a list of 2-element pairs")
        left.append(p[0])
        right.append(p[1])
    return Value(type_name="list", data=[left, right])


def _std_list_to_list(interp: "Interpreter", args: list[Value]) -> Value:
    v = args[0]
    if v.type_name == "list":
        return v
    return Value(type_name="list", data=[v])


def _std_list_to_set(interp: "Interpreter", args: list[Value]) -> Value:
    v = args[0]
    s = FSet()
    for el in v.data:
        key = el.data if isinstance(el, Value) else el
        try:
            s[key] = None
        except TypeError:
            raise InterpreterError("cannot convert unhashable element to set")
    return Value(type_name="set", data=s)


def _raw_to_value(raw: Any) -> Any:
    if isinstance(raw, bool):
        return Value(type_name="bool", data=raw)
    if isinstance(raw, int):
        return Value(type_name="int64", data=raw)
    if isinstance(raw, float):
        return Value(type_name="float64", data=raw)
    if isinstance(raw, str):
        return Value(type_name="string", data=raw)
    return raw


def _std_set_value(items: Any) -> Value:
    out = FSet()
    for el in items:
        key = el.data if isinstance(el, Value) else el
        try:
            out[key] = None
        except TypeError:
            raise InterpreterError("cannot convert unhashable element to set")
    return Value(type_name="set", data=out)


def _std_set_include(interp: "Interpreter", args: list[Value]) -> Value:
    value, item = args
    key = item.data if isinstance(item, Value) else item
    out = FSet(value.data)
    try:
        out[key] = None
    except TypeError:
        raise InterpreterError("cannot add unhashable element to set")
    return Value(type_name="set", data=out)


def _std_set_exclude(interp: "Interpreter", args: list[Value]) -> Value:
    value, item = args
    key = item.data if isinstance(item, Value) else item
    out = FSet(value.data)
    if key in out:
        del out[key]
    return Value(type_name="set", data=out)


def _std_set_union(interp: "Interpreter", args: list[Value]) -> Value:
    lhs, rhs = args
    out = FSet(lhs.data)
    for k in rhs.data:
        out.setdefault(k, None)
    return Value(type_name="set", data=out)


def _std_set_intersect(interp: "Interpreter", args: list[Value]) -> Value:
    lhs, rhs = args
    out = FSet(k for k in lhs.data if k in rhs.data)
    return Value(type_name="set", data=out)


def _std_set_difference(interp: "Interpreter", args: list[Value]) -> Value:
    lhs, rhs = args
    out = FSet(k for k in lhs.data if k not in rhs.data)
    return Value(type_name="set", data=out)


def _std_set_symmetric_difference(interp: "Interpreter", args: list[Value]) -> Value:
    lhs, rhs = args
    order = [k for k in lhs.data if k not in rhs.data] + [k for k in rhs.data if k not in lhs.data]
    out = FSet(order)
    return Value(type_name="set", data=out)


def _std_set_is_subset(interp: "Interpreter", args: list[Value]) -> Value:
    lhs, rhs = args
    return Value(type_name="bool", data=all(k in rhs.data for k in lhs.data))


def _std_set_is_superset(interp: "Interpreter", args: list[Value]) -> Value:
    lhs, rhs = args
    return Value(type_name="bool", data=all(k in lhs.data for k in rhs.data))


def _std_set_is_disjoint(interp: "Interpreter", args: list[Value]) -> Value:
    lhs, rhs = args
    return Value(type_name="bool", data=not any(k in rhs.data for k in lhs.data))


def _std_set_to_list(interp: "Interpreter", args: list[Value]) -> Value:
    value = args[0]
    return Value(type_name="list", data=[_raw_to_value(k) for k in value.data])


def _std_set_to_set(interp: "Interpreter", args: list[Value]) -> Value:
    value = args[0]
    if value.type_name in ("list", "data", "set"):
        items = value.data
    else:
        items = [value.data]
    return _std_set_value(items)


def _std_list_to_map(interp: "Interpreter", args: list[Value]) -> Value:
    v = args[0]
    items = v.data if isinstance(v, Value) else v
    m: dict[Any, Any] = {}
    for raw_el in items:
        el = raw_el.data if isinstance(raw_el, Value) and isinstance(raw_el.data, (list, tuple)) else raw_el
        if not isinstance(el, (list, tuple)) or len(el) != 2:
            raise InterpreterError("toMap expects a list of 2-element pairs")
        k = el[0]
        kd = k.data if isinstance(k, Value) else k
        m[kd] = el[1]
    return Value(type_name="map", data=m)


def _wrap_raw(raw: Any) -> Value:
    if isinstance(raw, Value):
        return raw
    if isinstance(raw, dict):
        return Value(type_name="map", data=raw)
    if isinstance(raw, FSet):
        return Value(type_name="set", data=raw)
    if isinstance(raw, list):
        return Value(type_name="list", data=raw)
    return _raw_to_value(raw)


def _std_collection_length(interp: "Interpreter", args: list[Value]) -> Value:
    v = args[0]
    data = v.data if isinstance(v, Value) else v
    return Value(type_name="int64", data=len(data))


def _std_collection_is_empty(interp: "Interpreter", args: list[Value]) -> Value:
    v = args[0]
    data = v.data if isinstance(v, Value) else v
    return Value(type_name="bool", data=len(data) == 0)


def _std_collection_contains(interp: "Interpreter", args: list[Value]) -> Value:
    coll, item = args
    data = coll.data if isinstance(coll, Value) else coll
    key = item.data if isinstance(item, Value) else item
    if isinstance(data, dict):
        return Value(type_name="bool", data=key in data)
    return Value(type_name="bool", data=key in data)


def _std_collection_clear_all(interp: "Interpreter", args: list[Value]) -> Value:
    v = args[0]
    if isinstance(v, Value) and v.type_name == "map":
        v.data.clear()
        return v
    if isinstance(v, Value) and (v.type_name == "set" or isinstance(v.data, (set, FSet))):
        return Value(type_name="set", data=FSet())
    return Value(type_name="list", data=[])


def _std_collection_keys(interp: "Interpreter", args: list[Value]) -> Value:
    record = args[0]
    return Value(type_name="list", data=list(record.data.keys()))


def _std_collection_values(interp: "Interpreter", args: list[Value]) -> Value:
    record = args[0]
    return Value(type_name="list", data=list(record.data.values()))


def _std_collection_to_list(interp: "Interpreter", args: list[Value]) -> Value:
    v = args[0]
    data = v.data if isinstance(v, Value) else v
    if isinstance(data, dict):
        return Value(type_name="list", data=list(data.keys()))
    if isinstance(data, FSet):
        return Value(type_name="list", data=[_wrap_raw(k) for k in data])
    return Value(type_name="list", data=list(data))


def _std_collection_to_set(interp: "Interpreter", args: list[Value]) -> Value:
    v = args[0]
    data = v.data if isinstance(v, Value) else v
    if isinstance(data, dict):
        items = list(data.keys())
    elif isinstance(data, FSet):
        items = list(data)
    else:
        items = list(data)
    out = FSet()
    for el in items:
        key = el.data if isinstance(el, Value) else el
        try:
            out[key] = None
        except TypeError:
            raise InterpreterError("cannot convert unhashable element to set")
    return Value(type_name="set", data=out)


def _std_collection_to_map(interp: "Interpreter", args: list[Value]) -> Value:
    return _std_list_to_map(interp, args)


def _std_map_clear_all(interp: "Interpreter", args: list[Value]) -> Value:
    record = args[0]
    record.data.clear()
    return record


def _std_map_insert_entry(interp: "Interpreter", args: list[Value]) -> Value:
    record, key, value = args
    kd = key.data if isinstance(key, Value) else key
    record.data[kd] = value
    return record


def _std_map_insert_entry_if_absent(interp: "Interpreter", args: list[Value]) -> Value:
    record, key, value = args
    kd = key.data if isinstance(key, Value) else key
    if kd not in record.data:
        record.data[kd] = value
    return record


def _std_map_replace_entry(interp: "Interpreter", args: list[Value]) -> Value:
    record, key, value = args
    kd = key.data if isinstance(key, Value) else key
    record.data[kd] = value
    return record


def _std_map_remove_entry(interp: "Interpreter", args: list[Value]) -> Value:
    record, key = args
    kd = key.data if isinstance(key, Value) else key
    record.data.pop(kd, None)
    return record


def _std_map_length(interp: "Interpreter", args: list[Value]) -> Value:
    record = args[0]
    return Value(type_name="int64", data=len(record.data))


def _std_map_is_empty(interp: "Interpreter", args: list[Value]) -> Value:
    record = args[0]
    return Value(type_name="bool", data=len(record.data) == 0)


def _std_map_entries(interp: "Interpreter", args: list[Value]) -> Value:
    record = args[0]
    out = [[k, v] for k, v in record.data.items()]
    return Value(type_name="list", data=out)


def _std_map_keys(interp: "Interpreter", args: list[Value]) -> Value:
    record = args[0]
    return Value(type_name="list", data=list(record.data.keys()))


def _std_map_values(interp: "Interpreter", args: list[Value]) -> Value:
    record = args[0]
    return Value(type_name="list", data=list(record.data.values()))


def _std_map_contains_key(interp: "Interpreter", args: list[Value]) -> Value:
    record, key = args
    kd = key.data if isinstance(key, Value) else key
    return Value(type_name="bool", data=kd in record.data)


def _std_map_contains_value(interp: "Interpreter", args: list[Value]) -> Value:
    record, value = args
    vd = value.data if isinstance(value, Value) else value
    return Value(type_name="bool", data=any(
        (el.data if isinstance(el, Value) else el) == vd for el in record.data.values()
    ))


def _std_map_get_value_or_default(interp: "Interpreter", args: list[Value]) -> Value:
    record, key, default = args
    kd = key.data if isinstance(key, Value) else key
    if kd in record.data:
        return record.data[kd]
    return default


def _std_map_merge(interp: "Interpreter", args: list[Value]) -> Value:
    left, right = args
    out = dict(left.data)
    out.update(right.data)
    return Value(type_name="map", data=out)


_STDLIST = {
    "stdListLength": _std_list_length,
    "stdListIsEmpty": _std_list_is_empty,
    "stdListContains": _std_list_contains,
    "stdListClearAll": _std_list_clear_all,
    "stdListPushBack": _std_list_push_back,
    "stdListPushFront": _std_list_push_front,
    "stdListInsertAt": _std_list_insert_at,
    "stdListRemoveAt": _std_list_remove_at,
    "stdListRemoveLast": _std_list_remove_last,
    "stdListSortAscending": _std_list_sort_ascending,
    "stdListSortDescending": _std_list_sort_descending,
    "stdListReverse": _std_list_reverse,
    "stdListFlatten": _std_list_flatten,
    "stdListPartition": _std_list_partition,
    "stdListZip": _std_list_zip,
    "stdListUnzip": _std_list_unzip,
    "stdListToList": _std_list_to_list,
    "stdListToSet": _std_list_to_set,
    "stdListToMap": _std_list_to_map,
    "stdSetInclude": _std_set_include,
    "stdSetExclude": _std_set_exclude,
    "stdSetUnion": _std_set_union,
    "stdSetIntersect": _std_set_intersect,
    "stdSetDifference": _std_set_difference,
    "stdSetSymmetricDifference": _std_set_symmetric_difference,
    "stdSetIsSubset": _std_set_is_subset,
    "stdSetIsSuperset": _std_set_is_superset,
    "stdSetIsDisjoint": _std_set_is_disjoint,
    "stdSetToList": _std_set_to_list,
    "stdSetToSet": _std_set_to_set,
    "stdCollectionLength": _std_collection_length,
    "stdCollectionIsEmpty": _std_collection_is_empty,
    "stdCollectionContains": _std_collection_contains,
    "stdCollectionClearAll": _std_collection_clear_all,
    "stdCollectionKeys": _std_collection_keys,
    "stdCollectionValues": _std_collection_values,
    "stdCollectionToList": _std_collection_to_list,
    "stdCollectionToSet": _std_collection_to_set,
    "stdCollectionToMap": _std_collection_to_map,
    "stdMapClearAll": _std_map_clear_all,
    "stdMapInsertEntry": _std_map_insert_entry,
    "stdMapInsertEntryIfAbsent": _std_map_insert_entry_if_absent,
    "stdMapReplaceEntry": _std_map_replace_entry,
    "stdMapRemoveEntry": _std_map_remove_entry,
    "stdMapLength": _std_map_length,
    "stdMapIsEmpty": _std_map_is_empty,
    "stdMapEntries": _std_map_entries,
    "stdMapKeys": _std_map_keys,
    "stdMapValues": _std_map_values,
    "stdMapContainsKey": _std_map_contains_key,
    "stdMapContainsValue": _std_map_contains_value,
    "stdMapGetValueOrDefault": _std_map_get_value_or_default,
    "stdMapMerge": _std_map_merge,
}


class RefHandle:
    """Mutable borrow_mut(x) write-through reference into an environment binding.

    reads/writes delegate to the owner variable's binding, mirroring exclusive
    mutable borrow semantics from the YAML keyword spec.
    """

    __slots__ = ("owner", "env")

    def __init__(self, owner: str, env: Environment) -> None:
        self.owner = owner
        self.env = env

    def read(self) -> Value:
        val = self.env.get(self.owner)
        if val is None:
            raise InterpreterError(f"undefined variable '{self.owner}'")
        return val

    def write(self, value: Value) -> None:
        if not self.env.set(self.owner, value):
            self.env.declare(self.owner, value)


def interpret(program: ASTNode) -> Any:
    from flux_proto.macro.expander import expand_macros
    if isinstance(program, FluxProgram):
        program = expand_macros(program)
    interp = Interpreter()
    return interp.run(program)


class Interpreter:
    def __init__(self) -> None:
        self._env = Environment()
        self._result: Any = None
        self._imports: dict[str, FdslFile] = {}
        self._op_aliases: dict[str, str] = {}
        self._str_caps: dict[str, int] = {}
        self._in_op: bool = False
        self._in_binary_op: bool = False

    def run(self, node: ASTNode) -> Any:
        if isinstance(node, FluxProgram):
            self._load_program(node)
            for s in node.storages:
                self._exec(s)
            if node.body:
                self._exec_block(node.body)
            return self._result
        if isinstance(node, FdslFile):
            self._load_program(node)
            return self._result
        raise InterpreterError(f"Cannot run {type(node).__name__}")

    def _load_program(self, node: FluxProgram | FdslFile) -> None:
        for s in node.structs:
            self._env.register_struct(s)
        for e in node.enums:
            self._env.register_enum(e)
        for f in node.functions:
            self._env.register_function(f)
        if isinstance(node, FluxProgram):
            self._imports = node.imports
            self._op_aliases = collect_op_aliases(node)
            for fdsl_file in node.imports.values():
                if fdsl_file is None:
                    continue
                for s in getattr(fdsl_file, "structs", []):
                    self._env.register_struct(s)
                for e in getattr(fdsl_file, "enums", []):
                    self._env.register_enum(e)
                for f in getattr(fdsl_file, "functions", []):
                    self._env.register_function(f)
                for agent in fdsl_file.agents:
                    if agent.body:
                        for sdecl in agent.body.storages:
                            if isinstance(sdecl, StorageDecl):
                                for item in sdecl.items:
                                    if item.initializer is not None:
                                        val = self._eval(item.initializer)
                                        self._env.declare_global(item.name, val)

    def _eval(self, node: ASTNode | None) -> Value:
        if node is None:
            return Value(type_name="void", data=None)

        if isinstance(node, _SinkValue):
            return node.value
        if isinstance(node, Literal):
            return self._eval_literal(node)
        if isinstance(node, Identifier):
            return self._eval_identifier(node)
        if isinstance(node, BinaryOp):
            return self._eval_binary_op(node)
        if isinstance(node, UnaryOp):
            return self._eval_unary_op(node)
        if isinstance(node, CallExpr):
            return self._eval_call(node)
        if isinstance(node, StructInit):
            return self._eval_struct_init(node)
        if isinstance(node, FieldAccess):
            return self._eval_field_access(node)
        if isinstance(node, CastExpr):
            return self._cast_value(self._eval(node.expr), node.target_type.name)
        if isinstance(node, DataflowExpr):
            return self._eval_dataflow(node)
        if isinstance(node, OwnershipExpr):
            return self._eval_ownership(node)
        if isinstance(node, SpawnExpr):
            return self._eval(node.operand)
        if isinstance(node, AwaitExpr):
            return self._eval(node.operand)
        if isinstance(node, InterpolatedString):
            result = ""
            for part in node.parts:
                if isinstance(part, InterpolatedText):
                    result += part.text
                else:
                    val = self._eval(part)
                    result += str(self._fmt(val))
            return Value(type_name="string", data=result)
        if isinstance(node, InterpolatedText):
            return Value(type_name="string", data=node.text)

        if isinstance(node, EnumVariant):
            return self._eval_enum_variant(node)
        if isinstance(node, ComptimeExpr):
            return self._eval_comptime(node)
        if isinstance(node, ShortCircuitBlock):
            return self._eval_short_circuit(node)
        if isinstance(node, MatchExpr):
            return self._eval_match(node)
        if isinstance(node, ListLiteral):
            data = []
            for i in node.items:
                v = self._eval(i)
                if v.type_name in ("list", "set", "map", "data", "tensor"):
                    data.append(v.data)
                else:
                    data.append(v)
            return Value(type_name="list", data=data)
        if isinstance(node, RecordLiteral):
            data = {}
            for f in node.fields:
                data[f.name] = self._eval(f.value)
            return Value(type_name="data", data=data)
        if isinstance(node, SetLiteral):
            return Value(type_name="set", data=FSet.fromkeys(v.data for v in (self._eval(i) for i in node.items)))
        if isinstance(node, MapLiteral):
            return self._eval_map_literal(node)
        if isinstance(node, IndexAccess):
            return self._eval_index_access(node)
        if isinstance(node, IndexAssign):
            return self._exec_index_assign(node)
        if isinstance(node, PtrRefExpr):
            return self._eval_ptr_ref(node)
        if isinstance(node, PtrDerefExpr):
            return self._eval_ptr_deref(node)
        if isinstance(node, SpyExpr):
            return self._eval_spy(node)
        if isinstance(node, InputExpr):
            return self._eval_input_expr(node, "string")

        raise InterpreterError(f"unsupported expression node: {type(node).__name__}")

    def _check_string_cap(self, name: str, val: Value, cap: int) -> None:
        data = val.data if not isinstance(val.data, Value) else val.data.data
        if isinstance(data, str) and len(data.encode("utf-8")) > cap:
            raise InterpreterError(
                f"string value of {len(data.encode('utf-8'))} bytes exceeds capacity {cap} of '{name}'"
            )

    def _eval_spy(self, node: SpyExpr) -> Value:
        from flux_proto.telemetry.spy_formatter import format_spy_telemetry
        if node.target is None:
            return Value(type_name="void", data=None)
        val = self._eval(node.target)
        val_to_use = val.data if not isinstance(val.data, Value) else val.data.data
        type_to_use = val.value_type or val.type_name
        telemetry = format_spy_telemetry(
            val_data=val_to_use,
            type_name=type_to_use,
            target_node=node.target,
            context={"is_operand": self._in_binary_op},
        )
        print(telemetry)
        return val

    def _fmt(self, val: Value) -> Any:
        if val.type_name == "bool" or isinstance(val.data, bool):
            return "true" if val.data else "false"
        if val.type_name in ("nice", "fail", "emit"):
            if isinstance(val.data, Value):
                return self._fmt(val.data)
            if val.value_type:
                return self._fmt(Value(type_name=val.value_type, data=val.data))
            if isinstance(val.data, (list, set, dict, FSet)):
                return self._fmt_collection(val.data)
            return val.data
        if val.type_name == "datetime" and isinstance(val.data, int):
            return _format_iso_nanos(val.data)
        if val.type_name.startswith("complex") and isinstance(val.data, complex):
            real, imag = val.data.real, val.data.imag
            if imag >= 0:
                return f"{real} + {imag}i"
            return f"{real} - {-imag}i"
        if isinstance(val, TensorView):
            return self._fmt_tensor_view(val)
        if val.type_name.startswith("tensor"):
            dims = _tensor_dims(val.type_name)
            return self._fmt_tensor_rec(val.data, 0, dims, _tensor_strides(dims))
        if (
            val.type_name.startswith("tensor")
            or val.type_name.startswith("list")
            or val.type_name.startswith("set")
            or val.type_name.startswith("map")
            or val.type_name in ("list", "data", "set", "map")
        ):
            return self._fmt_collection(val.data)
        if isinstance(val.data, dict) and "::" in val.type_name:
            return self._fmt_enum_value(val)
        if isinstance(val.data, dict) and self._env.get_struct(val.type_name) is not None:
            return self._fmt_struct_value(val)
        if isinstance(val.data, Value):
            return self._fmt(val.data)
        return val.data

    def _fmt_enum_value(self, val: Value) -> str:
        if not val.data:
            return val.type_name
        fields = ", ".join(f".{k}: {self._fmt(v)}" for k, v in val.data.items())
        return f"{val.type_name}({fields})"

    def _fmt_struct_value(self, val: Value) -> str:
        sdef = self._env.get_struct(val.type_name)
        ftypes = {f.name: (f.type_ref.name if f.type_ref else "") for f in sdef.fields}
        parts = []
        for k, v in val.data.items():
            if ftypes.get(k) == "datetime" and isinstance(v, int):
                shown = _format_iso_nanos(v)
            else:
                shown = self._fmt_coll_item(v)
            parts.append(f".{k}: {shown}")
        return f"{val.type_name}({', '.join(parts)})"

    def _fmt_tensor_value(self, val: Value) -> str:
        dims = _tensor_dims(val.type_name)
        return self._fmt_tensor_rec(val.data, 0, dims, _tensor_strides(dims))

    def _fmt_tensor_view(self, tv: TensorView) -> str:
        return self._fmt_tensor_rec(tv.base.data, tv.offset, tv.shape, tv.strides)

    def _fmt_tensor_rec(self, flat: Any, off: int, dims: list[int], strides: list[int]) -> str:
        if len(dims) <= 1:
            st = strides[0] if strides else 1
            return "[" + ", ".join(
                self._fmt_coll_item(flat[off + j * st]) for j in range(dims[0] if dims else 0)
            ) + "]"
        return "[" + ", ".join(
            self._fmt_tensor_rec(flat, off + i * strides[0], dims[1:], strides[1:])
            for i in range(dims[0])
        ) + "]"

    def _fmt_collection(self, data: Any) -> Any:
        if isinstance(data, FSet):
            return "{" + ", ".join(self._fmt_coll_item(v) for v in data) + "}"
        if isinstance(data, dict):
            return "{" + ", ".join(f"{k}: {self._fmt_coll_item(v)}" for k, v in data.items()) + "}"
        if isinstance(data, set):
            return "{" + ", ".join(self._fmt_coll_item(v) for v in data) + "}"
        if isinstance(data, (list, tuple)):
            return "[" + ", ".join(self._fmt_coll_item(v) for v in data) + "]"
        return data

    def _fmt_coll_item(self, v: Any) -> str:
        if isinstance(v, Value):
            return str(self._fmt(v))
        if isinstance(v, bool):
            return "true" if v else "false"
        if isinstance(v, (list, tuple, set, dict)):
            return str(self._fmt_collection(v))
        return str(v)

    def _eval_enum_variant(self, node: EnumVariant) -> Value:
        edef = self._env.get_enum(node.enum_name)
        if edef is not None:
            member = next((m for m in edef.members if m.name == node.variant), None)
            if member is None:
                raise InterpreterError(
                    f"variant '{node.variant}' not found in enum '{node.enum_name}'"
                )
            given = {f.name for f in node.fields}
            declared = {f.name for f in member.fields}
            unknown = given - declared
            if unknown:
                raise InterpreterError(
                    f"unknown field '{sorted(unknown)[0]}' for variant '{node.enum_name}::{node.variant}'"
                )
            missing = declared - given
            if missing:
                raise InterpreterError(
                    f"missing field '{sorted(missing)[0]}' for variant '{node.enum_name}::{node.variant}'"
                )
            payload: dict[str, Value] = {}
            for f in node.fields:
                payload[f.name] = self._eval(f.value)
            return Value(
                type_name=f"{node.enum_name}::{node.variant}",
                data=payload,
            )
        fdsl_file = self._imports.get(node.enum_name)
        if fdsl_file is None:
            raise InterpreterError(f"agent '{node.enum_name}' not imported (use it with 'use ... as {node.enum_name}')")
        agent = None
        for a in fdsl_file.agents:
            if a.name == node.enum_name:
                agent = a
                break
        if agent is None:
            for a in fdsl_file.agents:
                agent = a
                break
        if agent is None or agent.body is None:
            raise InterpreterError(f"no agents found in import '{node.enum_name}'")
        op = None
        for o in agent.body.ops:
            if o.name == node.variant:
                op = o
                break
        if op is None:
            raise InterpreterError(f"op '{node.variant}' not found in agent '{node.enum_name}'")
        if op.body:
            for expr in op.body.expressions:
                self._exec(expr)
        return Value(type_name="void")

    def _eval_literal(self, node: Literal) -> Value:
        vt = node.value_type.lower()
        if vt == "int":
            return Value(type_name="int64", data=int(node.value))
        if vt == "float":
            return Value(type_name="float64", data=float(node.value))
        if vt == "bool":
            return Value(type_name="bool", data=node.value.lower() == "true")
        if vt == "complex":
            return Value(type_name="complex64", data=_parse_complex_literal(node.value))
        if vt == "datetime":
            return Value(type_name="datetime", data=_parse_iso_nanos(node.value))
        if vt == "char":
            return Value(type_name="char", data=node.value)
        if vt == "string":
            return Value(type_name="string", data=node.value)
        return Value(type_name="string", data=node.value)

    def _eval_map_literal(self, node: MapLiteral) -> Value:
        data: dict[str, Any] = {}
        for entry in node.entries:
            if entry.key:
                key = entry.key.strip('"')
                data[key] = self._eval(entry.value)
            else:
                key_val = self._eval(entry.key_expr)
                if key_val.type_name != "string":
                    raise InterpreterError("map keys must be string literals or '.key: value' entries")
                data[key_val.data] = self._eval(entry.value)
        return Value(type_name="map", data=data)

    def _eval_index_access(self, node: IndexAccess) -> Value:
        obj = self._eval(node.obj)
        tname = obj.type_name
        if isinstance(obj, TensorView) or tname.startswith("tensor"):
            if isinstance(obj, TensorView):
                shape, strides, off0, et = obj.shape, obj.strides, obj.offset, obj.elem_type
            else:
                shape = _tensor_dims(tname)
                strides = _tensor_strides(shape)
                off0, et = 0, _tensor_elem_type(tname)
            data: Any = obj.data
            if len(node.indices) != len(shape):
                raise InterpreterError(f"tensor requires {len(shape)} indices, got {len(node.indices)}")
            has_slice = any(isinstance(i, SliceSpec) for i in node.indices)
            off = off0
            ndims: list[int] = []
            nstrides: list[int] = []
            for k, ix in enumerate(node.indices):
                if isinstance(ix, SliceSpec):
                    cnt, stp, first = _resolve_slice(ix, shape[k], self._eval)
                    off += first * strides[k]
                    ndims.append(cnt)
                    nstrides.append(strides[k] * stp)
                else:
                    i = self._eval(ix).data
                    if i < 1 or i > shape[k]:
                        raise InterpreterError(f"index {i} out of range (1..{shape[k]}) on dimension {k + 1}")
                    off += (i - 1) * strides[k]
            if not has_slice:
                raw = data[off]
                if isinstance(raw, Value):
                    return raw
                return Value(type_name=et, data=raw)
            return TensorView(
                base=obj.base if isinstance(obj, TensorView) else obj,
                shape=ndims,
                strides=nstrides,
                offset=off,
                elem_type=et,
            )
        if tname in ("nice", "fail", "emit"):
            if isinstance(obj.data, str) or (obj.value_type and obj.value_type.startswith("string")):
                tname = "string"
            elif isinstance(obj.data, list) or (obj.value_type and obj.value_type.startswith("list")):
                tname = "list"
            elif isinstance(obj.data, dict) or (obj.value_type and obj.value_type.startswith("map")):
                tname = "map"
        if tname == "string" or tname.startswith("string"):
            idx = node.indices[0]
            if isinstance(idx, SliceSpec):
                if idx.step is not None:
                    raise InterpreterError("slice com passo só é suportado em tensor")
                s = self._eval(idx.start).data if idx.start is not None else 1
                e = len(obj.data) if idx.end is None else self._eval(idx.end).data
                if not isinstance(s, int) or not isinstance(e, int):
                    raise InterpreterError("slice de string requer limites inteiros")
                if s < 1 or e > len(obj.data) or s > e:
                    raise InterpreterError(f"slice {s}..{e} out of range (1..{len(obj.data)})")
                return Value(type_name="string", data=obj.data[s - 1:e])
            i = self._eval(idx).data
            if not isinstance(i, int) or isinstance(i, bool):
                raise InterpreterError("índice de string requer número inteiro")
            if i < 1 or i > len(obj.data):
                raise InterpreterError(f"index {i} out of range (1..{len(obj.data)})")
            return Value(type_name="string", data=obj.data[i - 1])
        if (tname in ("list", "data") or tname.startswith("list")) and isinstance(obj.data, list):
            idx = node.indices[0]
            items = obj.data
            if isinstance(idx, SliceSpec):
                if idx.step is not None:
                    raise InterpreterError("slice com passo só é suportado em tensor")
                start = 1 if idx.start is None else self._eval(idx.start).data
                end = len(items) if idx.end is None else self._eval(idx.end).data
                if start < 1 or end > len(items) or start > end:
                    raise InterpreterError(f"slice {start}..{end} out of range (1..{len(items)})")
                return Value(type_name=tname, data=items[start - 1:end])
            i = self._eval(idx).data
            if i < 1 or i > len(items):
                raise InterpreterError(f"index {i} out of range (1..{len(items)})")
            return _wrap_raw(items[i - 1])
        if tname == "map" or tname.startswith("map") or (tname == "data" and isinstance(obj.data, dict)):
            key = self._eval(node.indices[0]).data
            if key in obj.data:
                return obj.data[key]
            # Design decision: missing map key returns none (not an error).
            # This is intentional language behavior, not a stub.
            return Value(type_name="none", data=None)
        raise InterpreterError(f"cannot index value of type '{tname}'")

    def _exec_index_assign(self, node: IndexAssign) -> Value:
        base = node.obj
        extra: list[ASTNode] = []
        if isinstance(base, IndexAccess):
            extra = list(base.indices)
            base = base.obj
        obj = self._env.get(base.name)
        if obj is None:
            raise InterpreterError(f"undefined variable '{base.name}'")
        idxs = extra + list(node.indices)
        val = self._eval(node.value)
        obj_type = obj.type_name
        if obj_type in ("nice", "fail", "emit"):
            if isinstance(obj.data, list) or (obj.value_type and obj.value_type.startswith("list")):
                obj_type = "list"
            elif isinstance(obj.data, dict) or (obj.value_type and obj.value_type.startswith("map")):
                obj_type = "map"
        if obj_type.startswith("tensor"):
            dims = _tensor_dims(obj_type)
            if any(isinstance(x, SliceSpec) for x in idxs):
                raise InterpreterError("slice assignment não é suportado em tensor; atribua elemento a elemento")
            target = obj.data
            if len(idxs) != len(dims):
                raise InterpreterError(f"tensor requires {len(dims)} indices, got {len(idxs)}")
            off = 0
            strides = _tensor_strides(dims)
            for k, idx in enumerate(idxs):
                i = self._eval(idx).data
                if i < 1 or i > dims[k]:
                    raise InterpreterError(f"index {i} out of range (1..{dims[k]}) on dimension {k + 1}")
                off += (i - 1) * strides[k]
            target[off] = val.data
        elif obj_type in ("list", "data") or obj_type.startswith("list"):
            if any(isinstance(x, SliceSpec) for x in idxs):
                raise InterpreterError("slice assignment is not supported")
            target = obj.data
            for idx in idxs[:-1]:
                i = self._eval(idx).data
                if i < 1 or i > len(target):
                    raise InterpreterError(f"index {i} out of range (1..{len(target)})")
                nxt = target[i - 1]
                if isinstance(nxt, Value):
                    if nxt.type_name not in ("list", "data") and not nxt.type_name.startswith("list"):
                        raise InterpreterError("cannot index into non-collection value")
                    target = nxt.data
                elif isinstance(nxt, list):
                    target = nxt
                else:
                    raise InterpreterError("cannot index into non-collection value")
            last = self._eval(idxs[-1]).data
            if last < 1 or last > len(target) + 1:
                raise InterpreterError(f"index {last} out of range (1..{len(target)})")
            elem_to_store = _wrap_elem(val)
            if last == len(target) + 1:
                target.append(elem_to_store)
            else:
                target[last - 1] = elem_to_store
        elif obj_type == "map" or obj_type.startswith("map"):
            key = self._eval(idxs[0]).data
            obj.data[key] = val
        else:
            raise InterpreterError(f"cannot index-assign value of type '{obj.type_name}'")
        return val

    def _eval_identifier(self, node: Identifier) -> Value:
        val = self._env.get(node.name)
        if val is None:
            raise InterpreterError(f"undefined variable '{node.name}'")
        if val.type_name == "ref" and isinstance(val.data, RefHandle):
            return val.data.read()
        return val

    def _eval_binary_op(self, node: BinaryOp) -> Value:
        if node.op == "ensure":
            left = self._eval(node.left)
            if isinstance(node.right, BlockStmt):
                self._env.enter_scope()
                try:
                    self._exec_block(node.right)
                finally:
                    self._env.exit_scope()
            return left
        old_in_binop = self._in_binary_op
        self._in_binary_op = True
        try:
            left = self._eval(node.left)
            right = self._eval(node.right)
        finally:
            self._in_binary_op = old_in_binop
        if node.op == "+" and (
            left.type_name == "string" or right.type_name == "string"
            or _is_collection(left.type_name) or _is_collection(right.type_name)
        ):
            return Value(
                type_name="string",
                data=str(self._fmt(left)) + str(self._fmt(right)),
            )
        op_fn = _BINOP.get(node.op)
        if op_fn is None:
            raise InterpreterError(f"unknown operator '{node.op}'")
        try:
            result = op_fn(left.data, right.data)
        except ZeroDivisionError:
            if node.op in ("/i", "/r"):
                return Value(
                    type_name="fail", data=right.data,
                    message="divisao por zero", value_type=left.type_name,
                )
            raise
        if node.op == "^r":
            rtype = "float64"
        elif node.op == "^e" and (left.type_name == "float64" or right.type_name == "float64"):
            rtype = "float64"
        elif left.type_name in _COMPLEX_COMPONENTS or right.type_name in _COMPLEX_COMPONENTS:
            rtype = left.type_name if left.type_name in _COMPLEX_COMPONENTS else right.type_name
            if isinstance(result, complex):
                result = _round_complex(result, rtype)
        elif left.type_name == "float64" or right.type_name == "float64":
            rtype = "float64"
        elif isinstance(result, bool) or node.op in ("==", "!=", "<", "<=", ">", ">=", "and", "or", "in"):
            rtype = "bool"
        else:
            rtype = left.type_name
        if rtype in FLOAT_FORMATS and rtype != "float64" and left.type_name == right.type_name:
            result = round_value(result, rtype)
        return Value(type_name=rtype, data=result)

    def _eval_unary_op(self, node: UnaryOp) -> Value:
        operand = self._eval(node.operand)
        if node.op == "-":
            return Value(type_name=operand.type_name, data=-operand.data)
        if node.op in ("not", "!"):
            return Value(type_name="bool", data=not operand.data)
        if node.op == "~":
            return Value(type_name=operand.type_name, data=~operand.data)
        return operand

    def _eval_dataflow(self, node: DataflowExpr) -> Value:
        if node.op in ("split", "join"):
            return self._eval_split_join(node)
        if node.op == "==>":
            value = self._eval(node.left)
            self._env.enter_scope()
            try:
                self._env.declare("it", value)
                return self._eval(node.right)
            finally:
                self._env.exit_scope()
        value = self._eval(node.left)
        right = node.right
        if isinstance(right, DataflowCastSink):
            return self._cast_value(value, right.target_type.name)
        if isinstance(right, DataflowExpr):
            return self._eval_dataflow(right)
        if isinstance(right, Identifier):
            name = right.name
            if name in ("print", "println"):
                print(*(self._fmt(value) for _ in [0]), end="\n")
                return Value(type_name="void")
            if name == "spy":
                from flux_proto.telemetry.spy_formatter import format_spy_telemetry
                val_to_use = value.data if not isinstance(value.data, Value) else value.data.data
                type_to_use = value.value_type or value.type_name
                telemetry = format_spy_telemetry(
                    val_data=val_to_use,
                    type_name=type_to_use,
                    origin_override="preverTendencia",
                    context={"is_dataflow": True}
                )
                print(telemetry)
                return value
            if name == "keep":
                return value
            func = self._env.get_function(name)
            if func:
                return self._exec_function(func, [_SinkValue(value)])
            if name in _STDLIST:
                return _STDLIST[name](self, [_SinkValue(value)])
            op_ctx = self._resolve_agent_op(name)
            if op_ctx is not None:
                return self._exec_agent_op(op_ctx, [_SinkValue(value)])
            raise InterpreterError(f"undefined function '{name}'")
        if isinstance(right, CallExpr) and isinstance(right.callee, Identifier):
            name = right.callee.name
            args = [_SinkValue(value)] + right.args
            func = self._env.get_function(name)
            if func:
                return self._exec_function(func, args)
            if name in ("print", "println"):
                print(*(self._fmt(a) for a in args), end="\n")
                return Value(type_name="void")
            if name in _STDLIST:
                return _STDLIST[name](self, args)
            op_ctx = self._resolve_agent_op(name)
            if op_ctx is not None:
                return self._exec_agent_op(op_ctx, args)
        if isinstance(right, SpyExpr):
            from flux_proto.telemetry.spy_formatter import format_spy_telemetry
            val_to_use = value.data if not isinstance(value.data, Value) else value.data.data
            type_to_use = value.value_type or value.type_name
            telemetry = format_spy_telemetry(
                val_data=val_to_use,
                type_name=type_to_use,
                origin_override="preverTendencia",
                context={"is_dataflow": True}
            )
            print(telemetry)
            return value
        raise InterpreterError(f"unsupported dataflow sink: {type(right).__name__}")

    def _eval_split_join(self, node: DataflowExpr) -> Value:
        left = self._eval(node.left)
        right = self._eval(node.right)
        if left.type_name in ("list", "data") and isinstance(left.data, list):
            items = list(left.data)
        else:
            items = [left]
        if right.type_name in ("list", "data") and isinstance(right.data, list):
            items.extend(right.data)
        else:
            items.append(right)
        return Value(type_name="list", data=items)

    def _cast_value(self, val: Value, target: str | None) -> Value:
        t = (target or "").lower()
        if t in _INT_FORMATS:
            data = int(val.data) if not isinstance(val.data, str) else int(val.data)
            return Value(type_name=t, data=data)
        if t in FLOAT_FORMATS:
            data = float(val.data) if not isinstance(val.data, str) else float(val.data)
            return Value(type_name=t, data=round_value(data, t))
        if t == "string":
            return Value(type_name="string", data=str(self._fmt(val)))
        if t.startswith("set"):
            raw = val.data if isinstance(val.data, (list, tuple, set, FSet)) else [val.data]
            s_data = FSet.fromkeys((x.data if isinstance(x, Value) else x) for x in raw)
            return Value(type_name="set", data=s_data)
        if t.startswith("list"):
            raw = val.data if isinstance(val.data, (list, tuple, set, FSet)) else [val.data]
            l_data = [x if isinstance(x, Value) else Value(type_name="data", data=x) for x in raw]
            return Value(type_name="list", data=l_data)
        if t.startswith("map"):
            if isinstance(val.data, dict):
                return Value(type_name="map", data=val.data)
            return Value(type_name="map", data={})
        return val

    def _eval_input_expr(self, node: InputExpr, expected_type: str) -> Value:
        tname = (expected_type or "string").lower()
        prompt = ""
        if node.prompt is not None:
            pv = self._eval(node.prompt)
            prompt = str(self._fmt(pv))
        while True:
            try:
                raw = input(prompt)
            except EOFError:
                data = DEFAULT_VALUES.get(tname, None)
                if tname == "string":
                    data = ""
                return Value(type_name=tname, data=data)
            ok, data = input_utils.parse_input(raw, tname)
            if ok:
                return Value(type_name=tname, data=data)
            print(input_utils.retry_message(tname), flush=True)

    def _eval_call(self, node: CallExpr) -> Value:
        name = ""
        agent_qual = ""
        if isinstance(node.callee, Identifier):
            name = node.callee.name
        elif isinstance(node.callee, EnumVariant):
            agent_qual = node.callee.enum_name
            name = node.callee.variant
        elif isinstance(node.callee, FieldAccess) and isinstance(node.callee.obj, Identifier):
            agent_qual = node.callee.obj.name
            name = node.callee.field
        if name:
            func = self._env.get_function(name)
            if func and not agent_qual:
                return self._exec_function(func, node.args)
            if name == "print":
                args = [self._eval(a) for a in node.args]
                print(*(self._fmt(a) for a in args), end="")
                return Value(type_name="void")
            if name == "println":
                args = [self._eval(a) for a in node.args]
                print(*(self._fmt(a) for a in args))
                return Value(type_name="void")
            if name == "bounds":
                largs = [self._eval(a) for a in node.args]
                if len(largs) != 2:
                    raise InterpreterError("bounds() expects (collection, index)")
                coll = largs[0]
                idx = int(largs[1].data)
                if coll.type_name not in ("list", "tensor"):
                    raise InterpreterError(f"bounds() called on '{coll.type_name}': expected list or tensor")
                if idx < 1 or idx > len(coll.data):
                    raise InterpreterError(
                        f"index out of bounds: {idx} not in [1, {len(coll.data)}]"
                    )
                return Value(type_name="bool", data=True)
            std = _STDLIST.get(name)
            if std and not agent_qual:
                return std(self, [self._eval(a) for a in node.args])
            if name == "stdIoReadFile":
                args = [self._eval(a) for a in node.args]
                path = str(args[0].data if args else "")
                try:
                    with open(path, "r", encoding="utf-8") as f:
                        content = f.read()
                except Exception:
                    content = ""
                return Value(type_name="string", data=content)
            if name == "stdIoWriteFile":
                args = [self._eval(a) for a in node.args]
                path = str(args[0].data if len(args) > 0 else "")
                content = str(args[1].data if len(args) > 1 else "")
                try:
                    with open(path, "w", encoding="utf-8", newline="") as f:
                        f.write(content)
                except Exception:
                    pass
                return Value(type_name="string", data=content)
            if name == "stdIoAppendFile":
                args = [self._eval(a) for a in node.args]
                path = str(args[0].data if len(args) > 0 else "")
                content = str(args[1].data if len(args) > 1 else "")
                try:
                    with open(path, "a", encoding="utf-8", newline="") as f:
                        f.write(content)
                except Exception:
                    pass
                return Value(type_name="string", data=content)
            if name == "stdIoDeleteFile":
                args = [self._eval(a) for a in node.args]
                path = str(args[0].data if args else "")
                ok = False
                import os
                try:
                    if os.path.isfile(path) or os.path.exists(path):
                        os.remove(path)
                        ok = True
                except Exception:
                    ok = False
                return Value(type_name="bool", data=ok)
            if name == "stdIoCopyFile":
                args = [self._eval(a) for a in node.args]
                src = str(args[0].data if len(args) > 0 else "")
                dst = str(args[1].data if len(args) > 1 else "")
                import shutil
                ok = False
                try:
                    shutil.copyfile(src, dst)
                    ok = True
                except Exception:
                    ok = False
                return Value(type_name="bool", data=ok)
            if name == "stdIoMoveFile":
                args = [self._eval(a) for a in node.args]
                src = str(args[0].data if len(args) > 0 else "")
                dst = str(args[1].data if len(args) > 1 else "")
                import shutil
                ok = False
                try:
                    shutil.move(src, dst)
                    ok = True
                except Exception:
                    ok = False
                return Value(type_name="bool", data=ok)
            if name == "stdIoFileExists":
                args = [self._eval(a) for a in node.args]
                path = str(args[0].data if args else "")
                import os
                return Value(type_name="bool", data=os.path.isfile(path))
            if name == "stdIoFileSize":
                args = [self._eval(a) for a in node.args]
                path = str(args[0].data if args else "")
                import os
                sz = 0
                try:
                    if os.path.isfile(path):
                        sz = os.path.getsize(path)
                except Exception:
                    sz = 0
                return Value(type_name="int64", data=sz)
            if name == "stdIoReadLines":
                args = [self._eval(a) for a in node.args]
                path = str(args[0].data if args else "")
                lines_val = []
                try:
                    with open(path, "r", encoding="utf-8") as f:
                        lines = f.read().splitlines()
                    lines_val = [Value(type_name="string", data=l) for l in lines]
                except Exception:
                    lines_val = []
                return Value(type_name="list", data=lines_val)
            if name == "stdIoWriteLines":
                args = [self._eval(a) for a in node.args]
                path = str(args[0].data if len(args) > 0 else "")
                raw_lines = args[1].data if len(args) > 1 and isinstance(args[1].data, list) else []
                items = [str(item.data if isinstance(item, Value) else item) for item in raw_lines]
                content = "\n".join(items) + ("\n" if items else "")
                try:
                    with open(path, "w", encoding="utf-8") as f:
                        f.write(content)
                except Exception:
                    pass
                return Value(type_name="string", data=content)
            if name == "stdIoAppendLines":
                args = [self._eval(a) for a in node.args]
                path = str(args[0].data if len(args) > 0 else "")
                raw_lines = args[1].data if len(args) > 1 and isinstance(args[1].data, list) else []
                items = [str(item.data if isinstance(item, Value) else item) for item in raw_lines]
                content = "\n".join(items) + ("\n" if items else "")
                try:
                    with open(path, "a", encoding="utf-8") as f:
                        f.write(content)
                except Exception:
                    pass
                return Value(type_name="string", data=content)
            if name == "stdIoDirExists":
                args = [self._eval(a) for a in node.args]
                path = str(args[0].data if args else "")
                import os
                return Value(type_name="bool", data=os.path.isdir(path))
            if name == "stdIoCreateDir":
                args = [self._eval(a) for a in node.args]
                path = str(args[0].data if args else "")
                import os
                ok = False
                try:
                    os.makedirs(path, exist_ok=True)
                    ok = True
                except Exception:
                    ok = False
                return Value(type_name="bool", data=ok)
            if name == "stdIoRemoveDir":
                args = [self._eval(a) for a in node.args]
                path = str(args[0].data if args else "")
                import os
                ok = False
                try:
                    if os.path.isdir(path):
                        os.rmdir(path)
                        ok = True
                except Exception:
                    ok = False
                return Value(type_name="bool", data=ok)
            if name == "stdIoListDir":
                args = [self._eval(a) for a in node.args]
                path = str(args[0].data if args else "")
                import os
                items = []
                try:
                    if os.path.isdir(path):
                        items = [Value(type_name="string", data=f) for f in sorted(os.listdir(path))]
                except Exception:
                    items = []
                return Value(type_name="list", data=items)
            if name == "stdIoPathBaseName":
                args = [self._eval(a) for a in node.args]
                path = str(args[0].data if args else "")
                norm = path.replace("\\", "/").rstrip("/")
                res = norm.rsplit("/", 1)[-1] if "/" in norm else norm
                return Value(type_name="string", data=res)
            if name == "stdIoPathDirName":
                args = [self._eval(a) for a in node.args]
                path = str(args[0].data if args else "")
                norm = path.replace("\\", "/").rstrip("/")
                res = norm.rsplit("/", 1)[0] if "/" in norm else ""
                return Value(type_name="string", data=res)
            if name == "stdIoPathExtension":
                args = [self._eval(a) for a in node.args]
                path = str(args[0].data if args else "")
                norm = path.replace("\\", "/").rstrip("/")
                base = norm.rsplit("/", 1)[-1] if "/" in norm else norm
                res = base.rsplit(".", 1)[-1] if "." in base else ""
                return Value(type_name="string", data=res)
            if name == "stdIoPathJoin":
                args = [self._eval(a) for a in node.args]
                d = str(args[0].data if len(args) > 0 else "").replace("\\", "/").rstrip("/")
                f = str(args[1].data if len(args) > 1 else "").replace("\\", "/").lstrip("/")
                res = f"{d}/{f}" if d and f else (d or f)
                return Value(type_name="string", data=res)
            if name == "stdIoPrintErr":
                args = [self._eval(a) for a in node.args]
                val = args[0] if args else Value(type_name="data", data="")
                import sys
                sys.stderr.write(str(val.data) + "\n")
                sys.stderr.flush()
                return val
            if name.startswith("stdDateTime") or name in ("stdGetCurrentTimeNsString", "stdFormatDurationNs"):
                return self._eval_datetime_intrinsic(name, node.args)
            if name.startswith("stdFile"):
                return self._eval_file_signature_intrinsic(name, node.args)
            if name.startswith("stdOs"):
                return self._eval_os_intrinsic(name, node.args)
            if name.startswith("stdNet"):
                return self._eval_net_intrinsic(name, node.args)
            op_ctx = self._resolve_agent_op(name, agent_qual)
            if op_ctx is not None:
                return self._exec_agent_op(op_ctx, node.args)
        if node.callee:
            self._eval(node.callee)
        raise InterpreterError(f"undefined function '{name}'")

    def _eval_datetime_intrinsic(self, name: str, raw_args: list[ASTNode]) -> Value:
        import flux_proto.datetime_helpers as dth
        args = [self._eval(a) for a in raw_args]
        if name == "stdDateTimeNow":
            return Value("datetime", dth.dt_now())
        if name == "stdDateTimeMonotonicNow":
            return Value("int64", dth.dt_monotonic_now())
        if name == "stdDateTimeMonotonicElapsed":
            return Value("int64", dth.dt_monotonic_elapsed(int(args[0].data)))
        if name == "stdDateTimeToday":
            return Value("datetime", dth.dt_today())
        if name == "stdDateTimeTime":
            return Value("datetime", dth.dt_time())
        if name == "stdGetCurrentTimeNsString":
            return Value("string", dth.dt_now_formatted())
        if name == "stdFormatDurationNs":
            return Value("string", dth.dt_format_duration(int(args[0].data)))
        if name == "stdDateTimeCreateDate":
            return Value("datetime", dth.dt_create_date(int(args[0].data), int(args[1].data), int(args[2].data)))
        if name == "stdDateTimeCreateTime":
            return Value("datetime", dth.dt_create_time(int(args[0].data), int(args[1].data), int(args[2].data)))
        if name == "stdDateTimeCreateTimeFull":
            return Value("datetime", dth.dt_create_time_full(int(args[0].data), int(args[1].data), int(args[2].data), int(args[3].data), int(args[4].data), int(args[5].data)))
        if name == "stdDateTimeParseIso":
            return Value("datetime", dth.dt_parse_iso(str(args[0].data)))
        if name == "stdDateTimeToIso":
            return Value("string", dth.dt_to_iso(int(args[0].data)))
        if name == "stdDateTimeFormat":
            return Value("string", dth.dt_format(int(args[0].data), str(args[1].data)))
        if name == "stdDateTimeYear":
            return Value("int64", dth.dt_year(int(args[0].data)))
        if name == "stdDateTimeMonth":
            return Value("int64", dth.dt_month(int(args[0].data)))
        if name == "stdDateTimeDay":
            return Value("int64", dth.dt_day(int(args[0].data)))
        if name == "stdDateTimeHour":
            return Value("int64", dth.dt_hour(int(args[0].data)))
        if name == "stdDateTimeMinute":
            return Value("int64", dth.dt_minute(int(args[0].data)))
        if name == "stdDateTimeSecond":
            return Value("int64", dth.dt_second(int(args[0].data)))
        if name == "stdDateTimeMillisecond":
            return Value("int64", dth.dt_millisecond(int(args[0].data)))
        if name == "stdDateTimeMicrosecond":
            return Value("int64", dth.dt_microsecond(int(args[0].data)))
        if name == "stdDateTimeNanosecond":
            return Value("int64", dth.dt_nanosecond(int(args[0].data)))
        if name == "stdDateTimeWeekday":
            return Value("int64", dth.dt_weekday(int(args[0].data)))
        if name == "stdDateTimeDayOfYear":
            return Value("int64", dth.dt_day_of_year(int(args[0].data)))
        if name == "stdDateTimeDaysInMonth":
            return Value("int64", dth.dt_days_in_month(int(args[0].data)))
        if name == "stdDateTimeQuarter":
            return Value("int64", dth.dt_quarter(int(args[0].data)))
        if name == "stdDateTimeIsLeapYear":
            return Value("bool", dth.dt_is_leap_year(int(args[0].data)))
        if name == "stdDateTimeIsWeekend":
            return Value("bool", dth.dt_is_weekend(int(args[0].data)))
        if name == "stdDateTimeAddDays":
            return Value("datetime", dth.dt_add_days(int(args[0].data), int(args[1].data)))
        if name == "stdDateTimeAddHours":
            return Value("datetime", dth.dt_add_hours(int(args[0].data), int(args[1].data)))
        if name == "stdDateTimeAddMinutes":
            return Value("datetime", dth.dt_add_minutes(int(args[0].data), int(args[1].data)))
        if name == "stdDateTimeAddSeconds":
            return Value("datetime", dth.dt_add_seconds(int(args[0].data), int(args[1].data)))
        if name == "stdDateTimeAddMilliseconds":
            return Value("datetime", dth.dt_add_milliseconds(int(args[0].data), int(args[1].data)))
        if name == "stdDateTimeAddMicroseconds":
            return Value("datetime", dth.dt_add_microseconds(int(args[0].data), int(args[1].data)))
        if name == "stdDateTimeAddNanoseconds":
            return Value("datetime", dth.dt_add_nanoseconds(int(args[0].data), int(args[1].data)))
        if name == "stdDateTimeAddMonths":
            return Value("datetime", dth.dt_add_months(int(args[0].data), int(args[1].data)))
        if name == "stdDateTimeAddYears":
            return Value("datetime", dth.dt_add_years(int(args[0].data), int(args[1].data)))
        if name == "stdDateTimeIsBefore":
            return Value("bool", dth.dt_is_before(int(args[0].data), int(args[1].data)))
        if name == "stdDateTimeIsAfter":
            return Value("bool", dth.dt_is_after(int(args[0].data), int(args[1].data)))
        if name == "stdDateTimeCompare":
            return Value("int64", dth.dt_compare(int(args[0].data), int(args[1].data)))
        if name == "stdDateTimeDaysBetween":
            return Value("int64", dth.dt_days_between(int(args[0].data), int(args[1].data)))
        if name == "stdDateTimeHoursBetween":
            return Value("int64", dth.dt_hours_between(int(args[0].data), int(args[1].data)))
        if name == "stdDateTimeMinutesBetween":
            return Value("int64", dth.dt_minutes_between(int(args[0].data), int(args[1].data)))
        if name == "stdDateTimeSecondsBetween":
            return Value("int64", dth.dt_seconds_between(int(args[0].data), int(args[1].data)))
        if name == "stdDateTimeMillisecondsBetween":
            return Value("int64", dth.dt_milliseconds_between(int(args[0].data), int(args[1].data)))
        if name == "stdDateTimeMicrosecondsBetween":
            return Value("int64", dth.dt_microseconds_between(int(args[0].data), int(args[1].data)))
        if name == "stdDateTimeNanosecondsBetween":
            return Value("int64", dth.dt_nanoseconds_between(int(args[0].data), int(args[1].data)))
        if name == "stdDateTimeMonthsBetween":
            return Value("int64", dth.dt_months_between(int(args[0].data), int(args[1].data)))
        if name == "stdDateTimeYearsBetween":
            return Value("int64", dth.dt_years_between(int(args[0].data), int(args[1].data)))
        if name == "stdDateTimeToTimeZone":
            return Value("string", dth.dt_to_timezone(int(args[0].data), str(args[1].data)))
        if name == "stdDateTimeToLocal":
            return Value("string", dth.dt_to_local(int(args[0].data)))
        if name == "stdDateTimeToUtc":
            return Value("datetime", dth.dt_to_utc(int(args[0].data)))
        if name == "stdDateTimeUtcOffset":
            return Value("float64", dth.dt_utc_offset(int(args[0].data), str(args[1].data)))
        if name == "stdDateTimeLocalTimeZone":
            return Value("string", dth.dt_local_timezone())
        if name == "stdDateTimeIsDaylightSavingTime":
            return Value("bool", dth.dt_is_daylight_saving_time(int(args[0].data), str(args[1].data)))
        if name == "stdDateTimeDstOffset":
            return Value("float64", dth.dt_dst_offset(int(args[0].data), str(args[1].data)))
        raise InterpreterError(f"unknown datetime intrinsic '{name}'")

    def _eval_file_signature_intrinsic(self, name: str, raw_args: list[ASTNode]) -> Value:
        import flux_proto.file_signature_helpers as fsh
        args = [self._eval(a) for a in raw_args]
        p = str(args[0].data if args else "")
        if name == "stdFileSha256":
            return Value("string", fsh.file_sha256(p))
        if name == "stdFileMd5":
            return Value("string", fsh.file_md5(p))
        if name == "stdFileSha1":
            return Value("string", fsh.file_sha1(p))
        if name == "stdFileCrc32":
            return Value("int64", fsh.file_crc32(p))
        if name == "stdFileHmacSha256":
            key = str(args[1].data if len(args) > 1 else "")
            return Value("string", fsh.file_hmac_sha256(p, key))
        if name == "stdFileHmacMd5":
            key = str(args[1].data if len(args) > 1 else "")
            return Value("string", fsh.file_hmac_md5(p, key))
        if name == "stdFileMagicBytes":
            n = int(args[1].data if len(args) > 1 else 0)
            return Value("string", fsh.file_magic_bytes(p, n))
        if name == "stdFileDetectType":
            return Value("string", fsh.file_detect_type(p))
        if name == "stdFileIsBinary":
            return Value("bool", fsh.file_is_binary(p))
        raise InterpreterError(f"unknown file signature intrinsic '{name}'")

    def _eval_os_intrinsic(self, name: str, raw_args: list[ASTNode]) -> Value:
        import flux_proto.os_helpers as osh
        args = [self._eval(a) for a in raw_args]
        # OsEnvContract
        if name == "stdOsGetEnv":
            return Value("string", osh.os_get_env(str(args[0].data if args else "")))
        if name == "stdOsGetEnvOrDefault":
            n = str(args[0].data if len(args) > 0 else "")
            d = str(args[1].data if len(args) > 1 else "")
            return Value("string", osh.os_get_env_or_default(n, d))
        if name == "stdOsSetEnv":
            n = str(args[0].data if len(args) > 0 else "")
            v = str(args[1].data if len(args) > 1 else "")
            return Value("bool", osh.os_set_env(n, v))
        if name == "stdOsHasEnv":
            return Value("bool", osh.os_has_env(str(args[0].data if args else "")))
        if name == "stdOsUnsetEnv":
            return Value("bool", osh.os_unset_env(str(args[0].data if args else "")))
        if name == "stdOsListEnv":
            keys = [Value("string", k) for k in osh.os_list_env()]
            return Value("list", keys)

        # OsInfoContract
        if name == "stdOsPlatform":
            return Value("string", osh.os_platform())
        if name == "stdOsArch":
            return Value("string", osh.os_arch())
        if name == "stdOsFamily":
            return Value("string", osh.os_family())
        if name == "stdOsHostname":
            return Value("string", osh.os_hostname())
        if name == "stdOsLineSeparator":
            return Value("string", osh.os_line_separator())
        if name == "stdOsPathSeparator":
            return Value("string", osh.os_path_separator())
        if name == "stdOsDirSeparator":
            return Value("string", osh.os_dir_separator())

        # OsProcessContract
        if name == "stdOsGetPid":
            return Value("int64", osh.os_get_pid())
        if name == "stdOsGetParentPid":
            return Value("int64", osh.os_get_parent_pid())
        if name == "stdOsCwd":
            return Value("string", osh.os_cwd())
        if name == "stdOsChdir":
            return Value("bool", osh.os_chdir(str(args[0].data if args else "")))
        if name == "stdOsExec":
            return Value("int64", osh.os_exec(str(args[0].data if args else "")))
        if name == "stdOsExecOutput":
            return Value("string", osh.os_exec_output(str(args[0].data if args else "")))
        if name == "stdOsSleep":
            return Value("bool", osh.os_sleep(int(args[0].data if args else 0)))

        # OsSystemContract
        if name == "stdOsUserName":
            return Value("string", osh.os_user_name())
        if name == "stdOsHomeDir":
            return Value("string", osh.os_home_dir())
        if name == "stdOsTempDir":
            return Value("string", osh.os_temp_dir())
        if name == "stdOsCpuCount":
            return Value("int64", osh.os_cpu_count())
        if name == "stdOsUptime":
            return Value("int64", osh.os_uptime())
        if name == "stdOsMemoryTotal":
            return Value("int64", osh.os_memory_total())
        if name == "stdOsMemoryFree":
            return Value("int64", osh.os_memory_free())
        raise InterpreterError(f"unknown os intrinsic '{name}'")

    def _eval_net_intrinsic(self, name: str, raw_args: list[ASTNode]) -> Value:
        import flux_proto.net_helpers as neth
        args = [self._eval(a) for a in raw_args]
        # NetUrlContract
        if name == "stdNetUrlGetScheme":
            return Value("string", neth.net_url_get_scheme(str(args[0].data if args else "")))
        if name == "stdNetUrlGetHost":
            return Value("string", neth.net_url_get_host(str(args[0].data if args else "")))
        if name == "stdNetUrlGetPort":
            return Value("int64", neth.net_url_get_port(str(args[0].data if args else "")))
        if name == "stdNetUrlGetPath":
            return Value("string", neth.net_url_get_path(str(args[0].data if args else "")))
        if name == "stdNetUrlGetQuery":
            return Value("string", neth.net_url_get_query(str(args[0].data if args else "")))
        if name == "stdNetUrlGetFragment":
            return Value("string", neth.net_url_get_fragment(str(args[0].data if args else "")))
        if name == "stdNetUrlEncode":
            return Value("string", neth.net_url_encode(str(args[0].data if args else "")))
        if name == "stdNetUrlDecode":
            return Value("string", neth.net_url_decode(str(args[0].data if args else "")))
        if name == "stdNetUrlIsValid":
            return Value("bool", neth.net_url_is_valid(str(args[0].data if args else "")))
        if name == "stdNetUrlJoin":
            b = str(args[0].data if len(args) > 0 else "")
            r = str(args[1].data if len(args) > 1 else "")
            return Value("string", neth.net_url_join(b, r))

        # NetIpContract
        if name == "stdNetIpIsValid":
            return Value("bool", neth.net_ip_is_valid(str(args[0].data if args else "")))
        if name == "stdNetIpIsV4":
            return Value("bool", neth.net_ip_is_v4(str(args[0].data if args else "")))
        if name == "stdNetIpIsV6":
            return Value("bool", neth.net_ip_is_v6(str(args[0].data if args else "")))
        if name == "stdNetIpIsLoopback":
            return Value("bool", neth.net_ip_is_loopback(str(args[0].data if args else "")))
        if name == "stdNetIpIsPrivate":
            return Value("bool", neth.net_ip_is_private(str(args[0].data if args else "")))
        if name == "stdNetResolveHost":
            return Value("string", neth.net_resolve_host(str(args[0].data if args else "")))
        if name == "stdNetResolveIp":
            return Value("string", neth.net_resolve_ip(str(args[0].data if args else "")))

        # NetHttpContract
        if name == "stdNetHttpGet":
            return Value("string", neth.net_http_get(str(args[0].data if args else "")))
        if name == "stdNetHttpGetStatus":
            return Value("int64", neth.net_http_get_status(str(args[0].data if args else "")))
        if name == "stdNetHttpPost":
            u = str(args[0].data if len(args) > 0 else "")
            b = str(args[1].data if len(args) > 1 else "")
            c = str(args[2].data if len(args) > 2 else "")
            return Value("string", neth.net_http_post(u, b, c))
        if name == "stdNetHttpPut":
            u = str(args[0].data if len(args) > 0 else "")
            b = str(args[1].data if len(args) > 1 else "")
            c = str(args[2].data if len(args) > 2 else "")
            return Value("string", neth.net_http_put(u, b, c))
        if name == "stdNetHttpDelete":
            return Value("int64", neth.net_http_delete(str(args[0].data if args else "")))
        if name == "stdNetHttpStatusText":
            return Value("string", neth.net_http_status_text(int(args[0].data if args else 0)))

        # NetSocketContract
        if name == "stdNetTcpPing":
            h = str(args[0].data if len(args) > 0 else "")
            p = int(args[1].data if len(args) > 1 else 0)
            t = int(args[2].data if len(args) > 2 else 1000)
            return Value("bool", neth.net_tcp_ping(h, p, t))
        if name == "stdNetLocalIp":
            return Value("string", neth.net_local_ip())
        if name == "stdNetPortIsAvailable":
            return Value("bool", neth.net_port_is_available(int(args[0].data if args else 0)))
        if name == "stdNetPing":
            return Value("bool", neth.net_ping(str(args[0].data if args else "")))
        raise InterpreterError(f"unknown net intrinsic '{name}'")

    def _resolve_agent_op(self, name: str, agent_qual: str = "") -> tuple[Any, Any] | None:
        real = self._op_aliases.get(name, name)
        if agent_qual:
            fdsl_file = self._imports.get(agent_qual)
            if fdsl_file is not None:
                for a in fdsl_file.agents:
                    if a.body is None:
                        continue
                    for o in a.body.ops:
                        if o.name == real or o.name == name:
                            return (a, o)
        for fdsl_file in self._imports.values():
            if fdsl_file is None:
                continue
            for a in fdsl_file.agents:
                if a.body is None:
                    continue
                for o in a.body.ops:
                    if o.name == real:
                        return (a, o)
        return None

    def _exec_agent_op(self, ctx: tuple[Any, Any], args: list[ASTNode]) -> Value:
        _, op = ctx
        arg_vals = [self._eval(a) for a in args]
        self._env.enter_scope()
        old_in_op = self._in_op
        self._in_op = True
        try:
            for i, p in enumerate(op.params):
                arg_val = arg_vals[i] if i < len(arg_vals) else Value(type_name="void")
                self._env.declare(p.name, arg_val)
            result: Any = None
            if op.body:
                for expr in op.body.expressions:
                    r = self._exec(expr)
                    if r is not None:
                        result = r
                        break
        finally:
            self._in_op = old_in_op
            self._env.exit_scope()
        if isinstance(result, Value) and result.type_name in ("nice", "fail", "emit"):
            return Value(
                type_name=result.type_name,
                data=result.data,
                message=result.message,
                value_type=result.value_type,
            )
        return result if isinstance(result, Value) else Value(type_name="void")

    def _exec_function(self, func: FunctionDef, args: list[ASTNode]) -> Value:
        arg_vals = [self._eval(a) for a in args]
        self._env.enter_scope()
        for i, param in enumerate(func.params):
            arg_val = arg_vals[i] if i < len(arg_vals) else Value(type_name="void")
            self._env.declare(param.name, arg_val)
        result: Any = None
        if func.body:
            result = self._exec_block(func.body)
        self._env.exit_scope()
        if isinstance(result, Value) and result.type_name in ("nice", "fail", "emit"):
            result.value_type = result.value_type or getattr(func.return_type, "name", "")
        return result if isinstance(result, Value) else Value(type_name="void")

    def _exec_block(self, block: BlockStmt) -> Any:
        last: ASTNode | None = None
        for stmt in block.body:
            r = self._exec(stmt)
            if r is not None:
                return r
            last = stmt
        if isinstance(last, StorageDecl) and last.items:
            tail = last.items[-1]
            if isinstance(tail.initializer, ShortCircuitBlock):
                return self._env.get(tail.name)
        if isinstance(last, VariableReassign) and isinstance(last.value, ShortCircuitBlock) and (not last.op or last.op == "="):
            return self._env.get(last.name)
        if isinstance(last, ExpressionStmt) and isinstance(last.expr, ShortCircuitBlock):
            return self._eval(last.expr)
        return None

    def _exec(self, stmt: ASTNode) -> Any:
        if isinstance(stmt, ExpressionStmt):
            self._eval(stmt.expr)
            return None
        if isinstance(stmt, CallExpr):
            self._eval_call(stmt)
            return None
        if isinstance(stmt, PrintStmt):
            vals = [self._eval(a) for a in stmt.args]
            print(*(self._fmt(v) for v in vals))
            return None
        if isinstance(stmt, BlockStmt):
            self._env.enter_scope()
            r = self._exec_block(stmt)
            self._env.exit_scope()
            return r
        if isinstance(stmt, StorageDecl):
            for item in stmt.items:
                if item.initializer:
                    tname = item.type_ref.name if item.type_ref else ""
                    if isinstance(item.initializer, InputExpr):
                        val = self._eval_input_expr(item.initializer, tname)
                    elif isinstance(item.initializer, ShortCircuitBlock):
                        val = self._eval_short_circuit(item.initializer, bind_name=item.name)
                    else:
                        val = self._eval(item.initializer)
                    if tname in FLOAT_FORMATS and tname != "float64":
                        val = Value(type_name=tname, data=round_value(val.data, tname))
                    elif tname in _COMPLEX_COMPONENTS:
                        val = Value(type_name=tname, data=_round_complex(val.data, tname))
                    elif tname.startswith("tensor"):
                        dims = _tensor_dims(tname)
                        if isinstance(val, TensorView):
                            if val.shape != dims:
                                raise InterpreterError(
                                    f"tensor shape mismatch: declared {dims}, view has {val.shape}"
                                )
                            val = Value(type_name=tname, data=list(_materialize_tensor(val).data))
                        elif isinstance(val.data, list):
                            _check_tensor_shape(val.data, dims)
                            val = Value(type_name=tname, data=_flatten_tensor_literal(val.data, dims))
                else:
                    tname = item.type_ref.name if item.type_ref else ""
                    data = DEFAULT_VALUES.get(tname, None)
                    if tname.startswith("string("):
                        data = ""
                    if tname.startswith("tensor"):
                        dims = _tensor_dims(tname)
                        if dims:
                            et = _tensor_elem_type(tname)
                            data = [DEFAULT_VALUES.get(et, 0)] * _tensor_flat_len(dims)
                    val = Value(type_name=tname, data=data)
                if stmt.static:
                    self._env.declare_global(item.name, val)
                else:
                    self._env.declare(item.name, val)
                if tname.startswith("string("):
                    cap = int(tname[7:-1])
                    self._str_caps[item.name] = cap
                    self._check_string_cap(item.name, val, cap)
            return None
        if isinstance(stmt, ExternDecl):
            return None
        if isinstance(stmt, PtrAssign):
            self._exec_ptr_assign(stmt)
            return None
        if isinstance(stmt, VariableReassign):
            cur = self._env.get(stmt.name)
            ref_handle: RefHandle | None = None
            if cur is not None and cur.type_name == "ref" and isinstance(cur.data, RefHandle):
                ref_handle = cur.data
                cur = ref_handle.read()
            if isinstance(stmt.value, ShortCircuitBlock) and (not stmt.op or stmt.op == "="):
                val = self._eval_short_circuit(stmt.value, bind_name=stmt.name)
            else:
                val = self._eval(stmt.value)
                if isinstance(val, TensorView):
                    val = _materialize_tensor(val)
                if stmt.op and stmt.op != "=":
                    comp = stmt.op[1:]  # "=+" -> "+", "=/i" -> "/i"
                    if comp == "~":
                        if cur is None:
                            raise InterpreterError(f"undefined variable '{stmt.name}'")
                        val = Value(type_name=cur.type_name, data=~cur.data)
                    elif comp in _BINOP:
                        if cur is None:
                            raise InterpreterError(f"undefined variable '{stmt.name}'")
                        try:
                            result = _BINOP[comp](cur.data, val.data)
                            if cur.type_name in FLOAT_FORMATS and cur.type_name != "float64":
                                result = round_value(result, cur.type_name)
                            val = Value(type_name=cur.type_name, data=result)
                        except ZeroDivisionError:
                            if comp in ("/i", "/r"):
                                val = Value(
                                    type_name="fail", data=val.data,
                                    message="divisao por zero", value_type=cur.type_name,
                                )
                            else:
                                raise
                else:
                    if cur is not None and cur.type_name in FLOAT_FORMATS and cur.type_name != "float64":
                        val = Value(type_name=cur.type_name, data=round_value(val.data, cur.type_name))
            if stmt.name in self._str_caps:
                self._check_string_cap(stmt.name, val, self._str_caps[stmt.name])
            if ref_handle is not None:
                ref_handle.write(val)
            elif not self._env.set(stmt.name, val):
                self._env.declare(stmt.name, val)
            return None
        if isinstance(stmt, FieldAssign):
            obj = self._env.get(stmt.owner)
            if obj is None:
                raise InterpreterError(f"undefined variable '{stmt.owner}'")
            if not isinstance(obj.data, dict):
                raise InterpreterError(f"cannot assign field on {obj.type_name}")
            if stmt.field not in obj.data:
                raise InterpreterError(f"field '{stmt.field}' not found in {obj.type_name}")
            sdef = self._env.get_struct(obj.type_name)
            if sdef is not None:
                for fdef in sdef.fields:
                    if fdef.name == stmt.field and not fdef.mutable:
                        raise InterpreterError(f"field '{stmt.field}' is immutable")
            val = self._eval(stmt.value)
            obj.data[stmt.field] = val.data
            return None
        if isinstance(stmt, RouteStmt):
            return self._exec_route(stmt)
        if isinstance(stmt, MatchStmt):
            return self._exec_match(stmt)
        if isinstance(stmt, UnsafeStmt):
            body = stmt.body
            if body is None:
                return None
            if isinstance(body, BlockStmt):
                self._env.enter_scope()
                try:
                    return self._exec_block(body)
                finally:
                    self._env.exit_scope()
            return self._exec(body)
        if isinstance(stmt, InfiniteStmt):
            return self._exec_infinite(stmt)
        if isinstance(stmt, EmitStmt):
            return self._exec_emit(stmt)
        if isinstance(stmt, BreakStmt):
            return BreakStmt()
        if isinstance(stmt, ContinueStmt):
            return ContinueStmt()
        return None

    def _exec_route(self, stmt: RouteStmt) -> Any:
        for arm in stmt.arms:
            if isinstance(arm.condition, Identifier) and arm.condition.name == "_":
                cond_val = True
            elif arm.condition is None:
                cond_val = True
            else:
                cond = self._eval(arm.condition)
                cond_val = bool(cond.data) if cond.data else False
            if cond_val:
                if arm.body:
                    if isinstance(arm.body, BlockStmt):
                        self._env.enter_scope()
                        r = self._exec_block(arm.body)
                        self._env.exit_scope()
                        return r
                    return self._exec(arm.body)
                return None
        return None

    def _exec_match(self, stmt: MatchStmt) -> Any:
        subject = self._eval(stmt.subject)
        for arm in stmt.arms:
            binds = self._match_pattern(arm.pattern, subject)
            if binds is None:
                continue
            self._env.enter_scope()
            try:
                for name, val in binds.items():
                    self._env.declare(name, val)
                if arm.guard is not None:
                    g = self._eval(arm.guard)
                    if not g.data:
                        continue
                if isinstance(arm.body, BlockStmt):
                    return self._exec_block(arm.body)
                return self._exec(arm.body)
            finally:
                self._env.exit_scope()
        return None

    def _eval_match(self, node: MatchExpr) -> Value:
        subject = self._eval(node.subject)
        for arm in node.arms:
            binds = self._match_pattern(arm.pattern, subject)
            if binds is None:
                continue
            self._env.enter_scope()
            try:
                for name, val in binds.items():
                    self._env.declare(name, val)
                if arm.guard is not None:
                    g = self._eval(arm.guard)
                    if not g.data:
                        continue
                if isinstance(arm.body, BlockStmt):
                    r = self._exec_block(arm.body)
                else:
                    r = self._eval(arm.body)
            finally:
                self._env.exit_scope()
            if isinstance(r, Value):
                return r
            raise InterpreterError("match arm must produce a value")
        raise InterpreterError("no pattern matched the subject")

    def _match_pattern(self, pattern: ASTNode, subject: Value) -> dict[str, Value] | None:
        if isinstance(pattern, WildcardPattern):
            return {}
        if isinstance(pattern, RecordPattern):
            if not isinstance(subject.data, dict):
                return None
            if not pattern.fields:
                return {}
            return self._match_field_list(pattern.fields, subject.data)
        if isinstance(pattern, LiteralPattern):
            return self._match_literal_pattern(pattern, subject)
        if isinstance(pattern, IdentifierPattern):
            return {pattern.name: subject}
        if isinstance(pattern, StructPattern):
            if subject.type_name != pattern.name:
                return None
            if not pattern.fields:
                return {}
            if not isinstance(subject.data, dict):
                return None
            return self._match_field_list(pattern.fields, subject.data)
        if isinstance(pattern, EnumVariantPattern):
            if subject.type_name != f"{pattern.enum}::{pattern.variant}":
                return None
            if not pattern.fields:
                return {}
            if not isinstance(subject.data, dict):
                return None
            return self._match_field_list(pattern.fields, subject.data)
        if isinstance(pattern, DataPattern):
            return {} if subject.type_name == "data" else None
        if isinstance(pattern, ListPattern):
            return self._match_list_pattern(pattern, subject)
        raise InterpreterError(f"unsupported pattern: {type(pattern).__name__}")

    def _match_field_list(self, fields: list[InitField], data: dict) -> dict[str, Value] | None:
        binds: dict[str, Value] = {}
        for f in fields:
            if f.name not in data:
                return None
            raw = data[f.name]
            val = raw if isinstance(raw, Value) else self._wrap_raw_field(raw)
            fv = f.value
            if isinstance(fv, WildcardPattern):
                continue
            if isinstance(fv, LiteralPattern):
                if self._match_literal_pattern(fv, val) is None:
                    return None
                continue
            if isinstance(fv, IdentifierPattern):
                binds[fv.name] = val
                continue
            sub = self._match_pattern(fv, val)
            if sub is None:
                return None
            binds.update(sub)
        return binds

    def _match_list_pattern(self, pattern: ListPattern, subject: Value) -> dict[str, Value] | None:
        if not isinstance(subject.data, list):
            return None
        items = subject.data
        binds: dict[str, Value] = {}
        idx = 0
        for it in pattern.items:
            if idx >= len(items):
                return None
            raw = items[idx]
            val = raw if isinstance(raw, Value) else self._wrap_raw_field(raw)
            idx += 1
            if isinstance(it, WildcardPattern):
                continue
            if isinstance(it, LiteralPattern):
                if self._match_literal_pattern(it, val) is None:
                    return None
                continue
            if isinstance(it, IdentifierPattern):
                binds[it.name] = val
                continue
            sub = self._match_pattern(it, val)
            if sub is None:
                return None
            binds.update(sub)
        if pattern.rest:
            binds[pattern.rest] = Value(type_name="list", data=items[idx:])
        return binds

    def _wrap_raw_field(self, raw) -> Value:
        if isinstance(raw, bool):
            return Value(type_name="bool", data=raw)
        if isinstance(raw, int):
            return Value(type_name="int64", data=raw)
        if isinstance(raw, float):
            return Value(type_name="float64", data=raw)
        return Value(type_name="string", data=raw)

    def _match_literal_pattern(self, pattern: LiteralPattern, subject: Value) -> dict[str, Value] | None:
        lit = pattern.value
        if lit.value_type == "INT":
            if subject.type_name not in _INT_TYPES or not isinstance(subject.data, int):
                return None
            return {} if subject.data == int(lit.value) else None
        if lit.value_type == "FLOAT":
            return {} if isinstance(subject.data, float) and subject.data == float(lit.value) else None
        if lit.value_type in ("STRING", "CHAR"):
            return {} if isinstance(subject.data, str) and subject.data == lit.value else None
        if lit.value_type == "BOOL":
            return {} if isinstance(subject.data, bool) and subject.data == (lit.value.lower() == "true") else None
        return None

    def _exec_infinite(self, stmt: InfiniteStmt) -> None:
        if stmt.iterator is not None:
            return self._exec_infinite_iterator(stmt)
        while True:
            if stmt.condition:
                cond = self._eval(stmt.condition)
                if not cond.data:
                    break
            if stmt.body:
                if isinstance(stmt.body, BlockStmt):
                    self._env.enter_scope()
                    for s in stmt.body.body:
                        r = self._exec(s)
                        if isinstance(r, BreakStmt):
                            self._env.exit_scope()
                            return None
                        if isinstance(r, ContinueStmt):
                            break
                        if (isinstance(r, Value) and r.type_name in ("nice", "fail", "emit")) or isinstance(r, EmitStmt):
                            self._env.exit_scope()
                            return r
                    self._env.exit_scope()
                else:
                    r = self._exec(stmt.body)
                    if isinstance(r, (BreakStmt, EmitStmt)):
                        return None
                    if isinstance(r, Value) and r.type_name in ("nice", "fail", "emit"):
                        return r

    def _exec_infinite_iterator(self, stmt: InfiniteStmt) -> None:
        coll = stmt.iterator.collection
        is_range = isinstance(coll, BinaryOp) and coll.op == ".."
        if is_range:
            lo = self._eval(coll.left).data
            hi = self._eval(coll.right).data
            step = 1 if lo <= hi else -1
        else:
            seq = self._eval(coll)
            tname = seq.type_name
            if tname in ("nice", "fail", "emit"):
                if isinstance(seq.data, str) or (seq.value_type and seq.value_type.startswith("string")):
                    tname = "string"
                elif isinstance(seq.data, list) or (seq.value_type and seq.value_type.startswith("list")):
                    tname = "list"
                elif isinstance(seq.data, dict) or (seq.value_type and seq.value_type.startswith("map")):
                    tname = "map"
                elif isinstance(seq.data, FSet) or (seq.value_type and seq.value_type.startswith("set")):
                    tname = "set"
            is_map = isinstance(seq.data, dict) and (tname in ("map", "data") or tname.startswith("map"))
            if is_map:
                items = [Value(type_name="string", data=k) for k in seq.data]
            elif isinstance(seq.data, str) or tname.startswith("string"):
                items = [Value(type_name="string", data=c) for c in seq.data]
            elif not isinstance(seq.data, (list, tuple, FSet)):
                raise InterpreterError(f"cannot iterate over '{seq.type_name}'")
            else:
                items = list(seq.data)
        while True:
            if is_range:
                if (step > 0 and lo > hi) or (step < 0 and lo < hi):
                    break
                item: Any = lo
                lo = lo + step
                itype = "int64"
            else:
                if not items:
                    break
                item = items.pop(0)
                if isinstance(item, Value):
                    itype = item.type_name
                    item = item.data
                else:
                    itype = "list"
            self._env.enter_scope()
            self._env.declare(stmt.iterator.variable, Value(type_name=itype, data=item))
            if stmt.body and isinstance(stmt.body, BlockStmt):
                for s in stmt.body.body:
                    r = self._exec(s)
                    if isinstance(r, BreakStmt):
                        self._env.exit_scope()
                        return None
                    if isinstance(r, ContinueStmt):
                        break
                    if (isinstance(r, Value) and r.type_name in ("nice", "fail", "emit")) or isinstance(r, EmitStmt):
                        self._env.exit_scope()
                        return r
                self._env.exit_scope()
            else:
                self._env.exit_scope()
                r = self._exec(stmt.body)
                if isinstance(r, (BreakStmt, EmitStmt)):
                    return None

    def _exec_emit(self, stmt: EmitStmt) -> Value:
        if stmt.value_expr is not None:
            if not self._in_op:
                raise InterpreterError("emit accepts only a single declared identifier as value, expressions are not allowed")
            val = self._eval(stmt.value_expr)
            msg = self._eval(stmt.message) if stmt.message else Value(type_name="string", data="")
            return Value(
                type_name=stmt.status or "emit",
                data=val.data,
                message=str(msg.data) if msg.data is not None else "",
                value_type=val.type_name,
            )
        val = self._env.get(stmt.value)
        if val is None:
            raise InterpreterError(f"undefined variable '{stmt.value}'")
        msg = self._eval(stmt.message) if stmt.message else Value(type_name="string", data="")
        return Value(
            type_name=stmt.status or "emit",
            data=val.data,
            message=str(msg.data) if msg.data is not None else "",
            value_type=val.value_type or val.type_name,
        )

    def _is_fail_status(self, val: Value) -> bool:
        if val.type_name == "fail":
            return True
        if val.type_name == "bool":
            return not bool(val.data)
        if isinstance(val.data, bool):
            return not val.data
        return False

    def _eval_comptime(self, node: ComptimeExpr) -> Value:
        if node.body is None:
            return Value(type_name="none", data=None)
        if isinstance(node.body, BlockStmt):
            self._env.enter_scope()
            last_val = Value(type_name="none", data=None)
            try:
                for stmt in node.body.body:
                    res = self._exec(stmt)
                    if res is not None and isinstance(res, Value):
                        last_val = res
                    elif isinstance(stmt, ExpressionStmt):
                        last_val = self._eval(stmt.expr)
            finally:
                self._env.exit_scope()
            return last_val
        return self._eval(node.body)

    def _eval_short_circuit(self, node: ShortCircuitBlock, bind_name: str | None = None) -> Value:
        raw = self._eval(node.expr)
        if bind_name is not None:
            if not self._env.set(bind_name, raw):
                self._env.declare(bind_name, raw)
        arm: ShortCircuitArm | None = node.fail_arm if self._is_fail_status(raw) else node.nice_arm
        if arm is None:
            raise InterpreterError("short-circuit block requires both 'fail' and 'nice' arms")
        val = self._env.get(arm.value)
        if val is None:
            raise InterpreterError(f"undefined variable '{arm.value}'")
        msg = self._eval(arm.message) if arm.message else Value(type_name="string", data="")
        return Value(
            type_name=arm.status,
            data=val.data,
            message=str(msg.data) if msg.data is not None else "",
            value_type=val.value_type,
        )

    def _eval_struct_init(self, node: StructInit) -> Value:
        sdef = self._env.get_struct(node.name)
        if sdef is None:
            raise InterpreterError(f"undefined struct '{node.name}'")
        given = {f.name for f in node.fields}
        declared = {f.name for f in sdef.fields}
        unknown = given - declared
        if unknown:
            raise InterpreterError(
                f"unknown field '{sorted(unknown)[0]}' for struct '{node.name}'"
            )
        missing = declared - given
        if missing:
            raise InterpreterError(
                f"missing field '{sorted(missing)[0]}' for struct '{node.name}'"
            )
        fields: dict[str, Any] = {}
        for init_f in node.fields:
            val = self._eval(init_f.value)
            fields[init_f.name] = val.data
        return Value(type_name=node.name, data=fields)

    def _eval_field_access(self, node: FieldAccess) -> Value:
        obj = self._eval(node.obj)
        if isinstance(obj, Value) and obj.type_name in ("nice", "fail", "emit"):
            if node.field == "sta":
                return Value(type_name="string", data=obj.type_name)
            if node.field == "val":
                return Value(type_name=obj.value_type or obj.type_name, data=obj.data)
            if node.field == "msg":
                return Value(type_name="string", data=obj.message)
            raise InterpreterError(
                f"field '{node.field}' not found on function result (expected sta, val or msg)"
            )
        if isinstance(obj.data, dict):
            fval = obj.data.get(node.field)
            if fval is None:
                raise InterpreterError(f"field '{node.field}' not found in {obj.type_name}")
            ftype = ""
            sdef = self._env.get_struct(obj.type_name)
            if sdef is not None:
                for f in sdef.fields:
                    if f.name == node.field and f.type_ref is not None:
                        ftype = f.type_ref.name
                        break
            return Value(type_name=ftype or node.field, data=fval)
        raise InterpreterError(f"cannot access field on {obj.type_name}")

    def _eval_ownership(self, node: OwnershipExpr) -> Value:
        val = self._env.get(node.target)
        if val is None:
            raise InterpreterError(f"undefined variable '{node.target}'")
        if node.mut:
            return Value(type_name="ref", data=RefHandle(node.target, self._env),
                         value_type=val.type_name)
        return val

    def _eval_ptr_ref(self, node: PtrRefExpr) -> Value:
        val = self._eval(node.target)
        if val.type_name not in _INT_TYPES:
            raise InterpreterError(
                f"cannot take raw pointer of '{val.type_name}': only integer-scalar "
                f"targets are supported (virtual arena)"
            )
        addr = _virt_alloc(8)
        _virt_write_i64(addr, int(val.data))
        return Value(type_name="ptr", data=addr, value_type=val.type_name)

    def _eval_ptr_deref(self, node: PtrDerefExpr) -> Value:
        pv = self._eval(node.ptr)
        if pv.type_name != "ptr":
            raise InterpreterError("dereference of a non-pointer value")
        return Value(type_name=pv.value_type or "int64", data=_virt_read_i64(int(pv.data)))

    def _exec_ptr_assign(self, stmt: PtrAssign) -> None:
        target = stmt.ptr.ptr if isinstance(stmt.ptr, PtrDerefExpr) else stmt.ptr
        pv = self._eval(target)
        if pv.type_name != "ptr":
            raise InterpreterError("assignment through a non-pointer value")
        val = self._eval(stmt.value)
        _virt_write_i64(int(pv.data), int(val.data))
