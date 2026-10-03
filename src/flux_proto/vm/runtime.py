from __future__ import annotations

import sys

from flux_proto.floating import FLOAT_FORMATS, round_value
from flux_proto import input_utils
from flux_proto.interpreter.environment import FSet
from flux_proto.interpreter.interpreter import _format_iso_nanos, _round_complex
import flux_proto.datetime_helpers as _dth
import flux_proto.file_signature_helpers as _fsh
import flux_proto.os_helpers as _osh
import flux_proto.net_helpers as _neth
import flux_proto.simd_helpers as _simdh
import flux_proto.runtime_helpers as _rth
import flux_proto.db_helpers as _dbh
import flux_proto.dsl_helpers as _dslh
import flux_proto.thread_helpers as _thh
import flux_proto.gfx_helpers as _gfxh
import flux_proto.compress_helpers as _ch
import flux_proto.archive_helpers as _ah
import flux_proto.io_binary_helpers as _iobh


class RuntimeError(Exception):
    pass


class _Ref:
    __slots__ = ("owner", "scopes")

    def __init__(self, owner: str, scopes: list) -> None:
        self.owner = owner
        self.scopes = scopes

    def resolve(self) -> object:
        for scope in reversed(self.scopes):
            if self.owner in scope:
                v = scope[self.owner]
                return v.resolve() if isinstance(v, _Ref) else v
        raise RuntimeError(f"undefined variable '{self.owner}'")

    def assign(self, value: object) -> None:
        for scope in reversed(self.scopes):
            if self.owner in scope:
                scope[self.owner] = value
                return
        raise RuntimeError(f"undefined variable '{self.owner}'")


class _DT:
    __slots__ = ("nanos",)

    def __init__(self, nanos: int) -> None:
        self.nanos = nanos

    def __str__(self) -> str:
        return _format_iso_nanos(self.nanos)

    def __int__(self) -> int:
        return self.nanos

    def __eq__(self, other: object) -> bool:
        if isinstance(other, _DT):
            return self.nanos == other.nanos
        if isinstance(other, (int, float)):
            return self.nanos == int(other)
        return False

    def __lt__(self, other: object) -> bool:
        if isinstance(other, _DT):
            return self.nanos < other.nanos
        if isinstance(other, (int, float)):
            return self.nanos < int(other)
        return NotImplemented

    def __le__(self, other: object) -> bool:
        if isinstance(other, _DT):
            return self.nanos <= other.nanos
        if isinstance(other, (int, float)):
            return self.nanos <= int(other)
        return NotImplemented

    def __gt__(self, other: object) -> bool:
        if isinstance(other, _DT):
            return self.nanos > other.nanos
        if isinstance(other, (int, float)):
            return self.nanos > int(other)
        return NotImplemented

    def __ge__(self, other: object) -> bool:
        if isinstance(other, _DT):
            return self.nanos >= other.nanos
        if isinstance(other, (int, float)):
            return self.nanos >= int(other)
        return NotImplemented

    def __hash__(self) -> int:
        return hash(self.nanos)


def _dt_nanos(x: object) -> int:
    return x.nanos if isinstance(x, _DT) else int(x)


class _Chr:
    __slots__ = ("cp",)

    def __init__(self, cp: int) -> None:
        self.cp = cp

    def __str__(self) -> str:
        return chr(self.cp)

    def __int__(self) -> int:
        return self.cp

    def __eq__(self, other: object) -> bool:
        if isinstance(other, _Chr):
            return self.cp == other.cp
        if isinstance(other, str) and len(other) == 1:
            return self.cp == ord(other)
        if isinstance(other, int):
            return self.cp == other
        return False

    def __lt__(self, other: object) -> bool:
        if isinstance(other, _Chr):
            return self.cp < other.cp
        if isinstance(other, str) and len(other) == 1:
            return self.cp < ord(other)
        if isinstance(other, int):
            return self.cp < other
        return NotImplemented

    def __gt__(self, other: object) -> bool:
        if isinstance(other, _Chr):
            return self.cp > other.cp
        if isinstance(other, str) and len(other) == 1:
            return self.cp > ord(other)
        if isinstance(other, int):
            return self.cp > other
        return NotImplemented

    def __hash__(self) -> int:
        return hash(self.cp)


class TensorVal:
    __slots__ = ("dims", "data", "offset", "_strides")

    def __init__(self, dims: list, data: list, offset: int = 0, strides: list | None = None) -> None:
        self.dims = list(dims)
        self.data = data
        self.offset = offset
        if strides is not None:
            self._strides = list(strides)
        else:
            s = [1] * len(self.dims)
            for k in range(len(self.dims) - 2, -1, -1):
                s[k] = s[k + 1] * self.dims[k + 1]
            self._strides = s

    def strides(self) -> list:
        return self._strides

    def flat_index(self, idxs: list) -> int:
        if len(idxs) != len(self.dims):
            raise RuntimeError(
                f"tensor requires {len(self.dims)} indices, got {len(idxs)}"
            )
        off = self.offset
        st = self._strides
        for k, (i, d) in enumerate(zip(idxs, self.dims)):
            if not isinstance(i, int) or isinstance(i, bool) or i < 1 or i > d:
                raise RuntimeError(f"index {i} out of range (1..{d}) on dimension {k + 1}")
            off += (i - 1) * st[k]
        return off

    def slice_view(self, specs: list, scalars: list) -> "TensorVal":
        """specs: por dimensão ["i"] (escalar) ou ["s", a|None, b|None, step].
        scalars: valores dos índices escalares na ordem em que aparecem."""
        st = self._strides
        nd: list = []
        ns: list = []
        off = self.offset
        si = 0
        for k, d in enumerate(self.dims):
            sp = specs[k]
            if sp[0] == "s":
                _, a, b, step = sp
                if step > 0:
                    a = 1 if a is None else a
                    b = d if b is None else b
                else:
                    a = d if a is None else a
                    b = 1 if b is None else b
                for name, v in (("início", a), ("fim", b)):
                    if not isinstance(v, int) or isinstance(v, bool) or v < 1 or v > d:
                        raise RuntimeError(f"slice {v} fora do intervalo (1..{d}) na dimensão {k + 1} ({name})")
                off += (a - 1) * st[k]
                nd.append((abs(b - a) // abs(step)) + 1)
                ns.append(st[k] * step)
            else:
                i = scalars[si]
                si += 1
                if not isinstance(i, int) or isinstance(i, bool) or i < 1 or i > d:
                    raise RuntimeError(f"index {i} out of range (1..{d}) on dimension {k + 1}")
                off += (i - 1) * st[k]
        return TensorVal(nd, self.data, off, ns)

    def materialize(self) -> "TensorVal":
        def rec(off: int, k: int) -> list:
            if k == len(self.dims) - 1:
                st = self._strides[k]
                return [self.data[off + j * st] for j in range(self.dims[k])]
            return [rec(off + j * self._strides[k], k + 1) for j in range(self.dims[k])]

        nested = rec(self.offset, 0)
        flat: list = []

        def flatten(node: list, k: int) -> None:
            if k == len(self.dims) - 1:
                flat.extend(node)
            else:
                for sub in node:
                    flatten(sub, k + 1)

        if self.dims:
            flatten(nested, 0)
        return TensorVal(list(self.dims), flat)


def _fmt(v: object) -> object:
    if isinstance(v, bool):
        return "true" if v else "false"
    if isinstance(v, _Chr):
        return chr(v.cp)
    if isinstance(v, dict) and "sta" in v:
        return _fmt(v["val"])
    if isinstance(v, _DT):
        return str(v)
    if isinstance(v, dict) and "flux_type" in v:
        return _fmt_enum(v)
    if isinstance(v, dict) and "__flux_type__" in v:
        return _fmt_struct(v)
    if isinstance(v, complex):
        real, imag = v.real, v.imag
        if imag >= 0:
            return f"{real} + {imag}i"
        return f"{real} - {-imag}i"
    if isinstance(v, TensorVal):
        return _fmt_tensor(v)
    if isinstance(v, FSet):
        return "{" + ", ".join(str(_fmt(x)) for x in v) + "}"
    if isinstance(v, dict):
        return "{" + ", ".join(f"{k}: {_fmt(x)}" for k, x in v.items()) + "}"
    if isinstance(v, (list, tuple)):
        return "[" + ", ".join(str(_fmt(x)) for x in v) + "]"
    if isinstance(v, set):
        return "{" + ", ".join(str(_fmt(x)) for x in v) + "}"
    return v


def _fmt_tensor(v: TensorVal) -> str:
    def rec(off: int, dims: list, strides: list) -> str:
        if len(dims) <= 1:
            st = strides[0] if strides else 1
            return "[" + ", ".join(
                str(_fmt(v.data[off + j * st])) for j in range(dims[0] if dims else 0)
            ) + "]"
        return "[" + ", ".join(
            rec(off + i * strides[0], dims[1:], strides[1:]) for i in range(dims[0])
        ) + "]"

    return rec(v.offset, v.dims, v.strides())


def _fmt_enum(v: dict) -> str:
    name = v["flux_type"]
    payload = v.get("payload") or {}
    if not payload:
        return name
    fields = ", ".join(f".{k}: {_fmt(x)}" for k, x in payload.items())
    return f"{name}({fields})"


def _fmt_struct(v: dict) -> str:
    name = v["__flux_type__"]
    fields = ", ".join(
        f".{k}: {_fmt(x)}" for k, x in v.items() if k != "__flux_type__"
    )
    return f"{name}({fields})"


def _euclid_rem(a: object, b: object) -> object:
    r = a % b
    if r < 0:
        r += abs(b)
    return r


def _euclid_div(a: object, b: object) -> object:
    r = _euclid_rem(a, b)
    return (a - r) // b


def _unwrap_val(v: Any) -> Any:
    while isinstance(v, dict) and "sta" in v and "val" in v:
        v = v["val"]
    return v


def _revive(obj: object) -> object:
    if isinstance(obj, list):
        if len(obj) == 2 and obj[0] == "#dt" and isinstance(obj[1], int):
            return _DT(obj[1])
        if len(obj) == 2 and obj[0] == "#chr" and isinstance(obj[1], int):
            return _Chr(obj[1])
        if len(obj) == 3 and obj[0] == "#c":
            return complex(obj[1], obj[2])
        if len(obj) == 5 and obj[0] == "#tensor":
            return TensorVal(
                [int(d) for d in obj[1]],
                [_revive(x) for x in obj[2]],
                int(obj[3]),
                [int(s) for s in obj[4]],
            )
        if len(obj) == 3 and obj[0] == "#tensor":
            return TensorVal([int(d) for d in obj[1]], [_revive(x) for x in obj[2]])
        return [_revive(x) for x in obj]
    return obj


def execute_bytecode(bc: list) -> None:
    bc = _revive(bc)
    vm = VM(bc)
    vm.run()


class VM:
    def __init__(self, bc: list) -> None:
        self._bc = bc
        self._stack: list = []
        self._scopes: list[dict[str, object]] = [{}]
        self._ip = 0
        self._call_stack: list[int] = []
        self._str_caps: dict[str, int] = {}

    def run(self) -> None:
        while self._ip < len(self._bc):
            instr = self._bc[self._ip]
            self._ip += 1
            op = instr[0]
            args = instr[1:]
            getattr(self, f"_op_{op.lower()}")(*args)

    def _push(self, v: object) -> None:
        self._stack.append(v)

    def _pop(self) -> object:
        if not self._stack:
            raise RuntimeError("stack underflow")
        return self._stack.pop()

    # --- scope ---

    def _op_scope_enter(self) -> None:
        self._scopes.append({})

    def _op_scope_exit(self) -> None:
        if len(self._scopes) > 1:
            self._scopes.pop()

    # --- stack ops ---

    def _op_push(self, value: object) -> None:
        self._push(_revive(value))

    def _op_load(self, name: str) -> None:
        for scope in reversed(self._scopes):
            if name in scope:
                v = scope[name]
                if isinstance(v, _Ref):
                    v = v.resolve()
                self._push(v)
                return
        raise RuntimeError(f"undefined variable '{name}'")

    def _op_make_ref(self, owner: str) -> None:
        self._push(_Ref(owner, self._scopes))

    def _op_store(self, name: str) -> None:
        val = self._pop()
        cap = self._str_caps.get(name)
        if cap is not None and isinstance(val, str) and len(val.encode("utf-8")) > cap:
            raise RuntimeError(
                f"string value of {len(val.encode('utf-8'))} bytes exceeds capacity {cap} of '{name}'"
            )
        for scope in reversed(self._scopes):
            if name in scope:
                if isinstance(scope[name], _Ref):
                    scope[name].assign(val)
                else:
                    scope[name] = val
                return
        self._scopes[-1][name] = val

    def _op_declare(self, name: str, type_name: str = "") -> None:
        if type_name.startswith("string("):
            self._str_caps[name] = int(type_name[7:-1])
        val = self._pop()
        cap = self._str_caps.get(name)
        if cap is not None and isinstance(val, str) and len(val.encode("utf-8")) > cap:
            raise RuntimeError(
                f"string value of {len(val.encode('utf-8'))} bytes exceeds capacity {cap} of '{name}'"
            )
        self._scopes[-1][name] = val

    # --- arithmetic ---

    def _op_add(self) -> None:
        b, a = _unwrap_val(self._pop()), _unwrap_val(self._pop())
        if isinstance(a, str) or isinstance(b, str) or isinstance(a, _Chr) or isinstance(b, _Chr) or isinstance(a, (list, FSet, dict, set, TensorVal)) or isinstance(b, (list, FSet, dict, set, TensorVal)):
            self._push(str(_fmt(a)) + str(_fmt(b)))
            return
        self._push(a + b)

    def _op_sub(self) -> None:
        b, a = _unwrap_val(self._pop()), _unwrap_val(self._pop())
        self._push(a - b)

    def _op_mul(self) -> None:
        b, a = _unwrap_val(self._pop()), _unwrap_val(self._pop())
        self._push(a * b)

    def _op_div(self) -> None:
        b, a = _unwrap_val(self._pop()), _unwrap_val(self._pop())
        self._push(a / b)

    def _op_idiv(self) -> None:
        b, a = _unwrap_val(self._pop()), _unwrap_val(self._pop())
        if b == 0:
            self._push({"sta": "fail", "val": b, "msg": "divisao por zero"})
            return
        self._push(_euclid_div(a, b))

    def _op_rem(self) -> None:
        b, a = _unwrap_val(self._pop()), _unwrap_val(self._pop())
        if b == 0:
            self._push({"sta": "fail", "val": b, "msg": "divisao por zero"})
            return
        self._push(_euclid_rem(a, b))

    def _op_pow_e(self) -> None:
        b, a = _unwrap_val(self._pop()), _unwrap_val(self._pop())
        if isinstance(a, int) and isinstance(b, int):
            if b >= 0:
                result = 1
                base = a
                e = b
                while e > 0:
                    result *= base
                    e -= 1
                self._push(result)
                return
            self._push(1)
            return
        self._push(float(a) ** float(b))

    def _op_pow_r(self) -> None:
        b, a = _unwrap_val(self._pop()), _unwrap_val(self._pop())
        self._push(float(a) ** (1.0 / float(b)))

    def _op_dup(self) -> None:
        self._push(self._stack[-1])

    def _op_pop(self) -> None:
        self._pop()

    def _op_neg(self) -> None:
        self._push(-_unwrap_val(self._pop()))

    def _op_not(self) -> None:
        self._push(not _unwrap_val(self._pop()))

    def _op_to_string(self) -> None:
        val = self._pop()
        self._push(str(_fmt(val)))

    # --- comparison ---

    def _op_eq(self) -> None:
        b, a = _unwrap_val(self._pop()), _unwrap_val(self._pop())
        self._push(a == b)

    def _op_ne(self) -> None:
        b, a = _unwrap_val(self._pop()), _unwrap_val(self._pop())
        self._push(a != b)

    def _op_lt(self) -> None:
        b, a = _unwrap_val(self._pop()), _unwrap_val(self._pop())
        self._push(a < b)

    def _op_le(self) -> None:
        b, a = _unwrap_val(self._pop()), _unwrap_val(self._pop())
        self._push(a <= b)

    def _op_gt(self) -> None:
        b, a = _unwrap_val(self._pop()), _unwrap_val(self._pop())
        self._push(a > b)

    def _op_ge(self) -> None:
        b, a = _unwrap_val(self._pop()), _unwrap_val(self._pop())
        self._push(a >= b)

    def _op_and(self) -> None:
        b, a = _unwrap_val(self._pop()), _unwrap_val(self._pop())
        self._push(a and b)

    def _op_or(self) -> None:
        b, a = _unwrap_val(self._pop()), _unwrap_val(self._pop())
        self._push(a or b)

    # --- bitwise ---

    def _op_band(self) -> None:
        b, a = _unwrap_val(self._pop()), _unwrap_val(self._pop())
        self._push(a & b)

    def _op_bor(self) -> None:
        b, a = _unwrap_val(self._pop()), _unwrap_val(self._pop())
        self._push(a | b)

    def _op_bxor(self) -> None:
        b, a = _unwrap_val(self._pop()), _unwrap_val(self._pop())
        self._push(a ^ b)

    def _op_bshl(self) -> None:
        b, a = _unwrap_val(self._pop()), _unwrap_val(self._pop())
        self._push(a << b)

    def _op_bshr(self) -> None:
        b, a = _unwrap_val(self._pop()), _unwrap_val(self._pop())
        self._push(a >> b)

    def _op_bshru(self) -> None:
        b, a = _unwrap_val(self._pop()), _unwrap_val(self._pop())
        self._push((a & 0xFFFFFFFFFFFFFFFF) >> b)

    def _op_bnot(self) -> None:
        self._push(~_unwrap_val(self._pop()))

    # --- I/O ---

    def _op_print(self, count: int = 1) -> None:
        vals = [self._pop() for _ in range(count)]
        vals = [v["val"] if isinstance(v, dict) and "sta" in v else v for v in vals]
        print(*[_fmt(v) for v in reversed(vals)], end="")

    def _op_println(self, count: int = 1) -> None:
        vals = [self._pop() for _ in range(count)]
        vals = [v["val"] if isinstance(v, dict) and "sta" in v else v for v in vals]
        print(*[_fmt(v) for v in reversed(vals)])

    def _op_spy(self, meta: dict | None = None) -> None:
        from flux_proto.telemetry.spy_formatter import format_spy_telemetry
        if not self._stack:
            return
        val = self._stack[-1]
        val_unwrapped = _unwrap_val(val)
        meta = meta or {}
        target_kind = meta.get("target_kind", "")
        type_name = meta.get("type_name", "")
        if not type_name:
            if isinstance(val_unwrapped, bool):
                type_name = "bool"
            elif isinstance(val_unwrapped, int):
                type_name = "int64"
            elif isinstance(val_unwrapped, float):
                type_name = "float64"
            elif isinstance(val_unwrapped, str):
                type_name = "string"
            elif isinstance(val_unwrapped, TensorVal):
                shape_str = ",".join(str(d) for d in val_unwrapped.dims)
                type_name = f"Tensor[{shape_str}] of int64"
            else:
                type_name = "data"
        if isinstance(val_unwrapped, TensorVal):
            from flux_proto.telemetry.spy_formatter import _DummyVal
            val_unwrapped = [_DummyVal()] * len(val_unwrapped.data)

        target_node = None
        if target_kind == "Identifier":
            from flux_proto.parser.ast import Identifier
            target_node = Identifier(name=meta.get("target_name", "a"))
        elif target_kind == "BinaryOp":
            from flux_proto.parser.ast import BinaryOp, Identifier
            target_node = BinaryOp(
                op=meta.get("target_op", "+"),
                left=Identifier(name=meta.get("left_name", "a")),
                right=Identifier(name="b"),
            )

        telemetry = format_spy_telemetry(
            val_data=val_unwrapped,
            type_name=type_name,
            target_node=target_node,
            origin_override=meta.get("origin"),
            context={
                "is_operand": meta.get("is_operand", False),
                "is_dataflow": meta.get("is_dataflow", False),
            },
        )
        print(telemetry)

    def _op_input(self, type_name: str = "string", prompt: str = "") -> None:
        while True:
            try:
                raw = input(prompt)
            except EOFError:
                raw = ""
            ok, data = input_utils.parse_input(raw, type_name)
            if ok:
                if type_name in input_utils._INT_TYPES:
                    self._push(data)
                elif type_name in input_utils._FLOAT_TYPES:
                    self._push(data)
                elif type_name in input_utils._COMPLEX_TYPES:
                    self._push(data)
                elif type_name == "char":
                    self._push(_Chr(ord(data)))
                elif type_name == "bool":
                    self._push(data)
                elif type_name == "datetime":
                    self._push(_DT(data))
                else:
                    self._push(data)
                return
            print(input_utils.retry_message(type_name), flush=True)

    # --- control flow ---

    def _op_jmp(self, target: int) -> None:
        self._ip = target

    def _op_jz(self, target: int) -> None:
        if not _unwrap_val(self._pop()):
            self._ip = target

    def _op_jnz(self, target: int) -> None:
        if _unwrap_val(self._pop()):
            self._ip = target

    # --- functions ---

    def _op_call(self, arg: object) -> None:
        if isinstance(arg, int):
            self._call_stack.append((self._ip, len(self._scopes)))
            self._ip = arg
            return
        if isinstance(arg, str):
            entry = _BUILTINS.get(arg)
            if entry is not None:
                n, fn = entry
                args = [self._pop() for _ in range(n)]
                args.reverse()
                args = [_unwrap_val(a) for a in args]
                self._push(fn(*args))
                return
        raise RuntimeError(f"undefined function '{arg}'")

    def _op_ret(self) -> None:
        if self._call_stack:
            saved = self._call_stack.pop()
            if isinstance(saved, tuple):
                self._ip, scope_len = saved
                if len(self._scopes) > scope_len:
                    self._scopes = self._scopes[:scope_len]
            else:
                self._ip = saved

    # --- emit/fail ---

    def _op_emit(self, status: str) -> None:
        message = self._pop() if self._stack else ""
        value = _unwrap_val(self._pop())
        self._push({"sta": status, "val": value, "msg": message})

    def _op_is_fail(self) -> None:
        val = self._pop()
        if isinstance(val, dict) and val.get("sta") == "fail":
            self._push(True)
            return
        if isinstance(val, bool):
            self._push(not val)
            return
        self._push(False)

    # --- structs ---

    def _op_make_struct(self, name: str, field_names: list) -> None:
        vals = [self._pop() for _ in range(len(field_names))]
        vals.reverse()
        fields = dict(zip(field_names, vals))
        fields["__flux_type__"] = name
        self._push(fields)

    def _op_field_access(self, field: str) -> None:
        obj = self._pop()
        if isinstance(obj, dict):
            if "sta" in obj:
                if field == "val":
                    self._push(obj.get("val"))
                    return
                elif field in ("sta", "status"):
                    self._push(obj.get("sta"))
                    return
                elif field in ("msg", "message"):
                    self._push(obj.get("msg", ""))
                    return
            if "sta" in obj and isinstance(obj.get("val"), dict):
                val = obj["val"].get(field)
            else:
                val = obj.get(field)
            if val is not None:
                self._push(val)
                return
            raise RuntimeError(f"field '{field}' not found")
        raise RuntimeError(f"cannot access field on non-struct value")

    def _op_field_set(self, field: str) -> None:
        value = self._pop()
        obj = self._pop()
        if not isinstance(obj, dict):
            raise RuntimeError(f"cannot assign field on non-struct value")
        obj[field] = value
        self._push(obj)

    # --- match ---

    def _op_jump_if_not_match(self, target: int) -> None:
        if not self._pop():
            self._ip = target

    def _op_jump_if_not_match_drop(self, depth: int, target: int) -> None:
        if not self._pop():
            for _ in range(depth):
                self._pop()
            self._ip = target

    def _op_match_bind(self, name: str) -> None:
        self._scopes[-1][name] = self._pop()

    def _op_enum_new(self, enum_name: str, variant: str, tag: int, field_names: list) -> None:
        vals = [self._pop() for _ in range(len(field_names))]
        vals.reverse()
        payload = dict(zip(field_names, vals))
        self._push({"flux_type": f"{enum_name}::{variant}", "tag": tag, "payload": payload})

    def _op_enum_tag(self) -> None:
        self._push(self._pop()["tag"])

    def _op_enum_field(self, name: str) -> None:
        self._push(self._pop()["payload"][name])

    def _op_field_get(self, name: str) -> None:
        obj = self._pop()
        if isinstance(obj, dict):
            if obj.get("__flux_type__") == "data":
                fields = obj.get("fields")
                if isinstance(fields, dict) and name in fields:
                    self._push(fields[name])
                    return
                raise RuntimeError(f"field '{name}' not found")
            if name in obj:
                self._push(obj[name])
                return
            raise RuntimeError(f"field '{name}' not found")
        raise RuntimeError("cannot access field on non-struct value")

    def _op_struct_match(self, name: str) -> None:
        obj = self._pop()
        if isinstance(obj, dict) and obj.get("__flux_type__") == name:
            self._push(True)
            return
        self._push(False)

    def _op_match_fail(self) -> None:
        raise RuntimeError("no pattern matched the subject")

    def _op_round(self, fmt: str) -> None:
        v = self._pop()
        self._push(round_value(v, fmt))

    def _op_round_complex(self, fmt: str) -> None:
        c = self._pop()
        self._push(_round_complex(c, fmt))

    def _op_index(self) -> None:
        idx = _unwrap_val(self._pop())
        obj = _unwrap_val(self._pop())
        if isinstance(obj, TensorVal):
            raise RuntimeError("tensor requires all indices in a single access")
        if isinstance(obj, dict):
            self._push(obj.get(idx))
            return
        if isinstance(obj, list):
            if not isinstance(idx, int) or idx < 1 or idx > len(obj):
                raise RuntimeError(f"index {idx} out of range (1..{len(obj)})")
            self._push(obj[idx - 1])
            return
        if isinstance(obj, str):
            if not isinstance(idx, int) or idx < 1 or idx > len(obj):
                raise RuntimeError(f"index {idx} out of range (1..{len(obj)})")
            self._push(obj[idx - 1])
            return
        raise RuntimeError(f"cannot index value of type {type(obj).__name__}")

    def _op_index_assign(self) -> None:
        val = _unwrap_val(self._pop())
        idx = _unwrap_val(self._pop())
        obj = _unwrap_val(self._pop())
        if isinstance(obj, TensorVal):
            raise RuntimeError("tensor requires all indices in a single access")
        if isinstance(obj, dict):
            obj[idx] = val
            self._push(val)
            return
        if isinstance(obj, list):
            if not isinstance(idx, int) or idx < 1 or idx > len(obj) + 1:
                raise RuntimeError(f"index {idx} out of range (1..{len(obj)})")
            if idx == len(obj) + 1:
                obj.append(val)
            else:
                obj[idx - 1] = val
            self._push(val)
            return
        raise RuntimeError(f"cannot index-assign value of type {type(obj).__name__}")

    def _op_slice(self) -> None:
        end = _unwrap_val(self._pop())
        start = _unwrap_val(self._pop())
        obj = _unwrap_val(self._pop())
        if isinstance(obj, str):
            n = len(obj)
            if start is None:
                start = 1
            e = n if end is None else end
            if not isinstance(start, int) or not isinstance(e, int) or start < 1 or e > n or start > e:
                raise RuntimeError(f"slice {start}..{e} out of range (1..{n})")
            self._push(obj[start - 1 : e])
            return
        if not isinstance(obj, list):
            raise RuntimeError(f"cannot slice value of type {type(obj).__name__}")
        s = 1 if start is None else start
        e = len(obj) if end is None else end
        if not isinstance(s, int) or not isinstance(e, int) or s < 1 or e > len(obj) or s > e:
            raise RuntimeError(f"slice {s}..{e} out of range (1..{len(obj)})")
        self._push(obj[s - 1 : e])

    def _op_in(self) -> None:
        coll = _unwrap_val(self._pop())
        elem = _unwrap_val(self._pop())
        self._push(elem in coll)

    def _op_make_list(self, count: int) -> None:
        items = [self._pop() for _ in range(count)]
        items.reverse()
        self._push(items)

    def _op_tensor_pack(self, dims: list) -> None:
        nested = self._pop()

        def check(node: object, ds: list, depth: int) -> None:
            if depth >= len(ds):
                if isinstance(node, list):
                    raise RuntimeError("tensor literal nests deeper than declared dimensions")
                return
            if not isinstance(node, list):
                raise RuntimeError(f"tensor shape mismatch: expected {ds}, literal is not nested enough")
            if len(node) != ds[depth]:
                raise RuntimeError(
                    f"tensor shape mismatch: expected {ds}, dimension {depth + 1} has {len(node)} elements"
                )
            for item in node:
                check(item, ds, depth + 1)

        def flatten(node: list, k: int, out: list) -> None:
            if k == len(dims) - 1:
                out.extend(node)
            else:
                for sub in node:
                    flatten(sub, k + 1, out)

        check(nested, dims, 0)
        flat: list = []
        if dims:
            flatten(nested, 0, flat)
        self._push(TensorVal(list(dims), flat))

    def _op_tget(self, rank: int) -> None:
        idxs = [self._pop() for _ in range(rank)]
        idxs.reverse()
        obj = self._pop()
        if not isinstance(obj, TensorVal):
            raise RuntimeError(f"cannot index value of type {type(obj).__name__} as tensor")
        self._push(obj.data[obj.flat_index(idxs)])

    def _op_tset(self, rank: int) -> None:
        val = self._pop()
        idxs = [self._pop() for _ in range(rank)]
        idxs.reverse()
        obj = self._pop()
        if not isinstance(obj, TensorVal):
            raise RuntimeError(f"cannot index-assign value of type {type(obj).__name__} as tensor")
        if isinstance(val, dict) and "sta" in val:
            val = val["val"]
        obj.data[obj.flat_index(idxs)] = val
        self._push(val)

    def _op_tslice(self, spec: list) -> None:
        scalars = [self._pop() for _ in range(sum(1 for s in spec if s[0] == "i"))]
        scalars.reverse()
        obj = self._pop()
        if not isinstance(obj, TensorVal):
            raise RuntimeError(f"cannot slice value of type {type(obj).__name__} as tensor")
        self._push(obj.slice_view(spec, scalars))

    def _op_tmat(self) -> None:
        obj = self._pop()
        if not isinstance(obj, TensorVal):
            raise RuntimeError(f"cannot materialize value of type {type(obj).__name__} as tensor")
        self._push(obj.materialize())

    def _op_split(self) -> None:
        right = _unwrap_val(self._pop())
        left = _unwrap_val(self._pop())
        items = list(left) if isinstance(left, (list, tuple)) else [left]
        if isinstance(right, (list, tuple)):
            items.extend(right)
        else:
            items.append(right)
        self._push(items)

    def _op_join(self) -> None:
        right = _unwrap_val(self._pop())
        left = _unwrap_val(self._pop())
        items = list(left) if isinstance(left, (list, tuple)) else [left]
        if isinstance(right, (list, tuple)):
            items.extend(right)
        else:
            items.append(right)
        self._push(items)

    def _op_round(self, fmt: str) -> None:
        v = _unwrap_val(self._pop())
        self._push(round_value(v, fmt))

    def _op_round_complex(self, fmt: str) -> None:
        c = _unwrap_val(self._pop())
        if not isinstance(c, complex):
            self._push(c)
            return
        self._push(_round_complex(c, fmt))

    def _op_cast(self, tname: str) -> None:
        val = _unwrap_val(self._pop())
        t = tname.lower()
        if t in ("int", "int64", "int32", "int16", "int8", "uint64", "uint32", "uint16", "uint8"):
            if isinstance(val, bool):
                self._push(1 if val else 0)
            else:
                self._push(int(val))
        elif t in FLOAT_FORMATS or t in ("float", "float64", "float32", "float16"):
            self._push(round_value(float(val), t))
        elif t.startswith("complex"):
            if isinstance(val, complex):
                self._push(val)
            else:
                self._push(complex(float(val), 0.0))
        elif t.startswith("set"):
            if isinstance(val, FSet):
                self._push(FSet(val))
            elif isinstance(val, (list, tuple, set)):
                self._push(FSet.fromkeys(val))
            elif isinstance(val, dict):
                self._push(FSet.fromkeys(val.keys()))
            else:
                self._push(FSet.fromkeys([val]))
        elif t.startswith("list"):
            if isinstance(val, FSet):
                self._push(list(val.keys()))
            elif isinstance(val, (list, tuple, set)):
                self._push(list(val))
            elif isinstance(val, dict):
                self._push(list(val.keys()))
            else:
                self._push([val])
        elif t in ("string", "str"):
            self._push(str(val))
        elif t == "char":
            if isinstance(val, _Chr):
                self._push(val)
            elif isinstance(val, str) and len(val) == 1:
                self._push(_Chr(ord(val)))
            elif isinstance(val, int):
                self._push(_Chr(val))
            else:
                self._push(val)
        else:
            self._push(val)

    def _op_make_set(self, count: int) -> None:
        items = [self._pop() for _ in range(count)]
        items.reverse()
        self._push(FSet.fromkeys(items))

    def _op_iter_new(self) -> None:
        coll = _unwrap_val(self._pop())
        if isinstance(coll, list):
            items = list(coll)
        elif isinstance(coll, (FSet, set)):
            items = list(coll)
        elif isinstance(coll, dict):
            items = list(coll)
        elif isinstance(coll, str):
            items = list(coll)
        else:
            raise RuntimeError(f"cannot iterate over value of type {type(coll).__name__}")
        self._push([items, 0])

    def _op_iter_next(self) -> None:
        it = self._stack[-1]
        items, idx = it[0], it[1]
        if idx >= len(items):
            self._push(False)
            return
        it[1] = idx + 1
        self._push(items[idx])
        self._push(True)

    def _op_unwrap_nice(self) -> None:
        v = self._pop()
        if isinstance(v, dict) and v.get("sta") == "nice":
            v = v["val"]
        self._push(v)

    def _op_make_map(self, count: int) -> None:
        pairs = [self._pop() for _ in range(count * 2)]
        pairs.reverse()
        data = {}
        for i in range(0, len(pairs), 2):
            data[pairs[i]] = pairs[i + 1]
        self._push(data)

    def _op_make_record(self, count: int) -> None:
        pairs = [self._pop() for _ in range(count * 2)]
        pairs.reverse()
        data = {}
        for i in range(0, len(pairs), 2):
            data[pairs[i]] = pairs[i + 1]
        self._push({"__flux_type__": "data", "fields": data})

    def _op_record_match(self) -> None:
        obj = self._pop()
        if isinstance(obj, dict) and obj.get("__flux_type__") == "data":
            self._push(True)
            return
        self._push(False)

    def _op_record_field(self, name: str) -> None:
        self._push(self._pop()["fields"][name])

    def _op_list_match(self, min_len: int, exact: bool) -> None:
        obj = _unwrap_val(self._pop())
        if not isinstance(obj, list):
            self._push(False)
            return
        if exact:
            self._push(len(obj) == min_len)
        else:
            self._push(len(obj) >= min_len)

    def _op_list_item(self, idx: int) -> None:
        self._push(_unwrap_val(self._pop())[idx])

    def _op_list_rest(self, start: int) -> None:
        self._push(_unwrap_val(self._pop())[start:])

    def _op_halt(self) -> None:
        self._ip = len(self._bc)


def _sort_key_raw(el: object) -> tuple:
    if isinstance(el, bool):
        return (2, int(el))
    if isinstance(el, (int, float)):
        return (1, el)
    if isinstance(el, _Chr):
        return (3, chr(el.cp))
    if isinstance(el, str):
        return (3, el)
    if isinstance(el, (list, FSet, dict)):
        return (8, 0)
    return (9, 0)


def _flatten_one(seq: list) -> list:
    out = []
    for el in seq:
        if isinstance(el, list):
            out.extend(el)
        else:
            out.append(el)
    return out


def _partition(seq: list, size: int) -> list:
    if size <= 0:
        return []
    return [seq[i : i + size] for i in range(0, len(seq), size)]


def _zip(ls: list, rs: list) -> list:
    return [[l, r] for l, r in zip(ls, rs)]


def _unzip(pairs: list) -> list:
    ls: list = []
    rs: list = []
    for p in pairs:
        l, r = p[0], p[1]
        ls.append(l)
        rs.append(r)
    return [ls, rs]


def _push_back(seq: list, item: object) -> object:
    seq.append(item)
    return seq


def _push_front(seq: list, item: object) -> object:
    seq.insert(0, item)
    return seq


def _insert_at(seq: list, index: int, item: object) -> object:
    if not isinstance(index, int) or index < 1 or index > len(seq) + 1:
        raise RuntimeError(f"index {index} out of range (1..{len(seq) + 1})")
    seq.insert(index - 1, item)
    return seq


def _remove_at(seq: list, index: int) -> object:
    if not isinstance(index, int) or index < 1 or index > len(seq):
        raise RuntimeError(f"index {index} out of range (1..{len(seq)})")
    seq.pop(index - 1)
    return seq


def _to_map(pairs: list) -> object:
    data = {}
    for p in pairs:
        data[p[0]] = p[1]
    return data


def _set_include(s: FSet, item: object) -> FSet:
    out = FSet(s)
    out[item] = None
    return out


def _set_exclude(s: FSet, item: object) -> FSet:
    out = FSet(s)
    out.pop(item, None)
    return out


def _set_union(l: FSet, r: FSet) -> FSet:
    out = FSet(l)
    for k in r:
        out.setdefault(k, None)
    return out


def _set_intersect(l: FSet, r: FSet) -> FSet:
    return FSet(k for k in l if k in r)


def _set_difference(l: FSet, r: FSet) -> FSet:
    return FSet(k for k in l if k not in r)


def _set_symmetric_difference(l: FSet, r: FSet) -> FSet:
    order = [k for k in l if k not in r] + [k for k in r if k not in l]
    return FSet(order)


def _set_is_subset(l: FSet, r: FSet) -> bool:
    return all(k in r for k in l)


def _set_is_superset(l: FSet, r: FSet) -> bool:
    return all(k in l for k in r)


def _set_is_disjoint(l: FSet, r: FSet) -> bool:
    return not any(k in r for k in l)


def _set_to_list(s: FSet) -> list:
    if isinstance(s, (list, tuple)):
        return list(s)
    if isinstance(s, (FSet, set)):
        return [k for k in s]
    if isinstance(s, dict):
        return list(s.keys())
    return [s]


def _set_to_set(v: object) -> FSet:
    items = v if isinstance(v, (list, FSet)) else [v]
    return FSet.fromkeys(items)


def _to_set(items: list) -> object:
    return FSet.fromkeys(items)


def _to_list(v: object) -> object:
    return v if isinstance(v, list) else [v]


def _remove_last(seq: list) -> object:
    if not seq:
        raise RuntimeError("cannot remove last from empty list")
    seq.pop()
    return seq


def _map_insert(m: dict, k: object, v: object) -> dict:
    m[k] = v
    return m


def _map_insert_if_absent(m: dict, k: object, v: object) -> dict:
    m.setdefault(k, v)
    return m


def _map_remove(m: dict, k: object) -> dict:
    m.pop(k, None)
    return m


def _map_entries(m: dict) -> list:
    return [[k, v] for k, v in m.items()]


def _coll_to_set(v: object) -> FSet:
    if isinstance(v, dict):
        items = list(v)
    elif isinstance(v, FSet):
        items = list(v)
    else:
        items = list(v)
    return FSet.fromkeys(items)


def _coll_to_list(v: object) -> object:
    if isinstance(v, dict):
        return list(v)
    if isinstance(v, FSet):
        return [k for k in v]
    return v


def _std_io_read_file(path: str) -> str:
    try:
        with open(str(path), "r", encoding="utf-8") as f:
            return f.read()
    except Exception:
        return ""


def _std_io_write_file(path: str, content: str) -> str:
    try:
        with open(str(path), "w", encoding="utf-8", newline="") as f:
            f.write(str(content))
    except Exception:
        pass
    return str(content)


def _std_io_append_file(path: str, content: str) -> str:
    try:
        with open(str(path), "a", encoding="utf-8", newline="") as f:
            f.write(str(content))
    except Exception:
        pass
    return str(content)


def _std_io_delete_file(path: str) -> bool:
    import os
    try:
        p = str(path)
        if os.path.isfile(p) or os.path.exists(p):
            os.remove(p)
            return True
    except Exception:
        pass
    return False


def _std_io_copy_file(src: str, dst: str) -> bool:
    import shutil
    try:
        shutil.copyfile(str(src), str(dst))
        return True
    except Exception:
        return False


def _std_io_move_file(src: str, dst: str) -> bool:
    import shutil
    try:
        shutil.move(str(src), str(dst))
        return True
    except Exception:
        return False


def _std_io_file_exists(path: str) -> bool:
    import os
    return os.path.isfile(str(path))


def _std_io_file_size(path: str) -> int:
    import os
    try:
        p = str(path)
        if os.path.isfile(p):
            return os.path.getsize(p)
    except Exception:
        pass
    return 0


def _std_io_read_lines(path: str) -> list:
    try:
        with open(str(path), "r", encoding="utf-8") as f:
            return f.read().splitlines()
    except Exception:
        return []


def _std_io_write_lines(path: str, lines: list) -> str:
    raw = lines if isinstance(lines, list) else []
    items = [str(l) for l in raw]
    content = "\n".join(items) + ("\n" if items else "")
    try:
        with open(str(path), "w", encoding="utf-8") as f:
            f.write(content)
    except Exception:
        pass
    return content


def _std_io_append_lines(path: str, lines: list) -> str:
    raw = lines if isinstance(lines, list) else []
    items = [str(l) for l in raw]
    content = "\n".join(items) + ("\n" if items else "")
    try:
        with open(str(path), "a", encoding="utf-8") as f:
            f.write(content)
    except Exception:
        pass
    return content


def _std_io_dir_exists(path: str) -> bool:
    import os
    return os.path.isdir(str(path))


def _std_io_create_dir(path: str) -> bool:
    import os
    try:
        os.makedirs(str(path), exist_ok=True)
        return True
    except Exception:
        return False


def _std_io_remove_dir(path: str) -> bool:
    import os
    try:
        if os.path.isdir(str(path)):
            os.rmdir(str(path))
            return True
    except Exception:
        pass
    return False


def _std_io_list_dir(path: str) -> list:
    import os
    try:
        if os.path.isdir(str(path)):
            return sorted(os.listdir(str(path)))
    except Exception:
        pass
    return []


def _std_io_path_base_name(path: str) -> str:
    norm = str(path).replace("\\", "/").rstrip("/")
    return norm.rsplit("/", 1)[-1] if "/" in norm else norm


def _std_io_path_dir_name(path: str) -> str:
    norm = str(path).replace("\\", "/").rstrip("/")
    return norm.rsplit("/", 1)[0] if "/" in norm else ""


def _std_io_path_extension(path: str) -> str:
    norm = str(path).replace("\\", "/").rstrip("/")
    base = norm.rsplit("/", 1)[-1] if "/" in norm else norm
    return base.rsplit(".", 1)[-1] if "." in base else ""


def _std_io_path_join(dir: str, file: str) -> str:
    d = str(dir).replace("\\", "/").rstrip("/")
    f = str(file).replace("\\", "/").lstrip("/")
    return f"{d}/{f}" if d and f else (d or f)


def _std_io_print_err(value: object) -> object:
    import sys
    sys.stderr.write(str(value) + "\n")
    sys.stderr.flush()
    return value


_BUILTINS: dict[str, tuple[int, object]] = {
    "stdListLength": (1, len),
    "stdListIsEmpty": (1, lambda s: len(s) == 0),
    "stdListContains": (2, lambda s, i: i in s),
    "stdListClearAll": (1, lambda s: []),
    "stdListPushBack": (2, _push_back),
    "stdListPushFront": (2, _push_front),
    "stdListInsertAt": (3, _insert_at),
    "stdListRemoveAt": (2, _remove_at),
    "stdListRemoveLast": (1, _remove_last),
    "stdListSortAscending": (1, lambda s: _sorted(s, False)),
    "stdListSortDescending": (1, lambda s: _sorted(s, True)),
    "stdListReverse": (1, lambda s: _reversed(s)),
    "stdListFlatten": (1, _flatten_one),
    "stdListPartition": (2, _partition),
    "stdListZip": (2, _zip),
    "stdListUnzip": (1, _unzip),
    "stdListToList": (1, _to_list),
    "stdListToSet": (1, _to_set),
    "stdListToMap": (1, _to_map),
    "stdSetInclude": (2, _set_include),
    "stdSetExclude": (2, _set_exclude),
    "stdSetUnion": (2, _set_union),
    "stdSetIntersect": (2, _set_intersect),
    "stdSetDifference": (2, _set_difference),
    "stdSetSymmetricDifference": (2, _set_symmetric_difference),
    "stdSetIsSubset": (2, _set_is_subset),
    "stdSetIsSuperset": (2, _set_is_superset),
    "stdSetIsDisjoint": (2, _set_is_disjoint),
    "stdSetToList": (1, _set_to_list),
    "stdSetToSet": (1, _set_to_set),
    "stdCollectionLength": (1, len),
    "stdCollectionIsEmpty": (1, lambda s: len(s) == 0),
    "stdCollectionContains": (2, lambda c, i: i in c),
    "stdCollectionClearAll": (1, lambda v: FSet() if isinstance(v, (set, FSet)) else ((v.clear(), v)[1] if isinstance(v, dict) else [])),
    "stdCollectionKeys": (1, lambda m: list(m)),
    "stdCollectionValues": (1, lambda m: list(m.values())),
    "stdCollectionToList": (1, _coll_to_list),
    "stdCollectionToSet": (1, _coll_to_set),
    "stdCollectionToMap": (1, _to_map),
    "stdMapClearAll": (1, lambda m: m.clear() or m),
    "stdMapInsertEntry": (3, _map_insert),
    "stdMapInsertEntryIfAbsent": (3, _map_insert_if_absent),
    "stdMapReplaceEntry": (3, _map_insert),
    "stdMapRemoveEntry": (2, _map_remove),
    "stdMapLength": (1, len),
    "stdMapIsEmpty": (1, lambda m: len(m) == 0),
    "stdMapEntries": (1, _map_entries),
    "stdMapKeys": (1, lambda m: list(m)),
    "stdMapValues": (1, lambda m: list(m.values())),
    "stdMapContainsKey": (2, lambda m, k: k in m),
    "stdMapContainsValue": (2, lambda m, v: v in m.values()),
    "stdMapGetValueOrDefault": (3, lambda m, k, d: m.get(k, d)),
    "stdMapMerge": (2, lambda a, b: {**a, **b}),
    "stdIoReadFile": (1, _std_io_read_file),
    "stdIoWriteFile": (2, _std_io_write_file),
    "stdIoAppendFile": (2, _std_io_append_file),
    "stdIoDeleteFile": (1, _std_io_delete_file),
    "stdIoCopyFile": (2, _std_io_copy_file),
    "stdIoMoveFile": (2, _std_io_move_file),
    "stdIoFileExists": (1, _std_io_file_exists),
    "stdIoFileSize": (1, _std_io_file_size),
    "stdIoReadLines": (1, _std_io_read_lines),
    "stdIoWriteLines": (2, _std_io_write_lines),
    "stdIoAppendLines": (2, _std_io_append_lines),
    "stdIoDirExists": (1, _std_io_dir_exists),
    "stdIoCreateDir": (1, _std_io_create_dir),
    "stdIoRemoveDir": (1, _std_io_remove_dir),
    "stdIoListDir": (1, _std_io_list_dir),
    "stdIoPathBaseName": (1, _std_io_path_base_name),
    "stdIoPathDirName": (1, _std_io_path_dir_name),
    "stdIoPathExtension": (1, _std_io_path_extension),
    "stdIoPathJoin": (2, _std_io_path_join),
    "stdIoPrintErr": (1, _std_io_print_err),
    # FileSignatureStdLib intrinsics
    "stdFileSha256": (1, lambda p: _fsh.file_sha256(str(p))),
    "stdFileMd5": (1, lambda p: _fsh.file_md5(str(p))),
    "stdFileSha1": (1, lambda p: _fsh.file_sha1(str(p))),
    "stdFileCrc32": (1, lambda p: _fsh.file_crc32(str(p))),
    "stdFileHmacSha256": (2, lambda p, k: _fsh.file_hmac_sha256(str(p), str(k))),
    "stdFileHmacMd5": (2, lambda p, k: _fsh.file_hmac_md5(str(p), str(k))),
    "stdFileMagicBytes": (2, lambda p, n: _fsh.file_magic_bytes(str(p), int(n))),
    "stdFileDetectType": (1, lambda p: _fsh.file_detect_type(str(p))),
    "stdFileIsBinary": (1, lambda p: _fsh.file_is_binary(str(p))),
    # OsStdLib intrinsics
    "stdOsGetEnv": (1, lambda n: _osh.os_get_env(str(n))),
    "stdOsGetEnvOrDefault": (2, lambda n, d: _osh.os_get_env_or_default(str(n), str(d))),
    "stdOsSetEnv": (2, lambda n, v: _osh.os_set_env(str(n), str(v))),
    "stdOsHasEnv": (1, lambda n: _osh.os_has_env(str(n))),
    "stdOsUnsetEnv": (1, lambda n: _osh.os_unset_env(str(n))),
    "stdOsListEnv": (0, _osh.os_list_env),
    "stdOsPlatform": (0, _osh.os_platform),
    "stdOsArch": (0, _osh.os_arch),
    "stdOsFamily": (0, _osh.os_family),
    "stdOsHostname": (0, _osh.os_hostname),
    "stdOsLineSeparator": (0, _osh.os_line_separator),
    "stdOsPathSeparator": (0, _osh.os_path_separator),
    "stdOsDirSeparator": (0, _osh.os_dir_separator),
    "stdOsGetPid": (0, _osh.os_get_pid),
    "stdOsGetParentPid": (0, _osh.os_get_parent_pid),
    "stdOsCwd": (0, _osh.os_cwd),
    "stdOsChdir": (1, lambda p: _osh.os_chdir(str(p))),
    "stdOsExec": (1, lambda c: _osh.os_exec(str(c))),
    "stdOsExecOutput": (1, lambda c: _osh.os_exec_output(str(c))),
    "stdOsSleep": (1, lambda ms: _osh.os_sleep(int(ms))),
    "stdOsUserName": (0, _osh.os_user_name),
    "stdOsHomeDir": (0, _osh.os_home_dir),
    "stdOsTempDir": (0, _osh.os_temp_dir),
    "stdOsCpuCount": (0, _osh.os_cpu_count),
    "stdOsUptime": (0, _osh.os_uptime),
    "stdOsMemoryTotal": (0, _osh.os_memory_total),
    "stdOsMemoryFree": (0, _osh.os_memory_free),
    # NetStdLib intrinsics
    # NetUrlContract
    "stdNetUrlGetScheme": (1, lambda u: _neth.net_url_get_scheme(str(u))),
    "stdNetUrlGetHost": (1, lambda u: _neth.net_url_get_host(str(u))),
    "stdNetUrlGetPort": (1, lambda u: _neth.net_url_get_port(str(u))),
    "stdNetUrlGetPath": (1, lambda u: _neth.net_url_get_path(str(u))),
    "stdNetUrlGetQuery": (1, lambda u: _neth.net_url_get_query(str(u))),
    "stdNetUrlGetFragment": (1, lambda u: _neth.net_url_get_fragment(str(u))),
    "stdNetUrlEncode": (1, lambda t: _neth.net_url_encode(str(t))),
    "stdNetUrlDecode": (1, lambda t: _neth.net_url_decode(str(t))),
    "stdNetUrlIsValid": (1, lambda u: _neth.net_url_is_valid(str(u))),
    "stdNetUrlJoin": (2, lambda b, r: _neth.net_url_join(str(b), str(r))),
    # NetIpContract
    "stdNetIpIsValid": (1, lambda ip: _neth.net_ip_is_valid(str(ip))),
    "stdNetIpIsV4": (1, lambda ip: _neth.net_ip_is_v4(str(ip))),
    "stdNetIpIsV6": (1, lambda ip: _neth.net_ip_is_v6(str(ip))),
    "stdNetIpIsLoopback": (1, lambda ip: _neth.net_ip_is_loopback(str(ip))),
    "stdNetIpIsPrivate": (1, lambda ip: _neth.net_ip_is_private(str(ip))),
    "stdNetResolveHost": (1, lambda h: _neth.net_resolve_host(str(h))),
    "stdNetResolveIp": (1, lambda ip: _neth.net_resolve_ip(str(ip))),
    # NetHttpContract
    "stdNetHttpGet": (1, lambda u: _neth.net_http_get(str(u))),
    "stdNetHttpGetStatus": (1, lambda u: _neth.net_http_get_status(str(u))),
    "stdNetHttpPost": (3, lambda u, b, c: _neth.net_http_post(str(u), str(b), str(c))),
    "stdNetHttpPut": (3, lambda u, b, c: _neth.net_http_put(str(u), str(b), str(c))),
    "stdNetHttpDelete": (1, lambda u: _neth.net_http_delete(str(u))),
    "stdNetHttpStatusText": (1, lambda c: _neth.net_http_status_text(int(c))),
    # NetSocketContract
    "stdNetTcpPing": (3, lambda h, p, t: _neth.net_tcp_ping(str(h), int(p), int(t))),
    "stdNetLocalIp": (0, _neth.net_local_ip),
    "stdNetPortIsAvailable": (1, lambda p: _neth.net_port_is_available(int(p))),
    "stdNetPing": (1, lambda h: _neth.net_ping(str(h))),
    # DateTimeStdLib intrinsics
    "stdDateTimeNow": (0, lambda: _DT(_dth.dt_now())),
    "stdDateTimeMonotonicNow": (0, _dth.dt_monotonic_now),
    "stdDateTimeMonotonicElapsed": (1, lambda start: _dth.dt_monotonic_elapsed(int(start))),
    "stdDateTimeToday": (0, lambda: _DT(_dth.dt_today())),
    "stdDateTimeTime": (0, lambda: _DT(_dth.dt_time())),
    "stdGetCurrentTimeNsString": (0, _dth.dt_now_formatted),
    "stdFormatDurationNs": (1, lambda ns: _dth.dt_format_duration(int(ns))),
    "stdDateTimeCreateDate": (3, lambda y, m, d: _DT(_dth.dt_create_date(int(y), int(m), int(d)))),
    "stdDateTimeCreateTime": (3, lambda h, m, s: _DT(_dth.dt_create_time(int(h), int(m), int(s)))),
    "stdDateTimeCreateTimeFull": (6, lambda h, m, s, ms, us, ns: _DT(_dth.dt_create_time_full(int(h), int(m), int(s), int(ms), int(us), int(ns)))),
    "stdDateTimeParseIso": (1, lambda s: _DT(_dth.dt_parse_iso(str(s)))),
    "stdDateTimeToIso": (1, lambda dt: _dth.dt_to_iso(_dt_nanos(dt))),
    "stdDateTimeFormat": (2, lambda dt, pat: _dth.dt_format(_dt_nanos(dt), str(pat))),
    "stdDateTimeYear": (1, lambda dt: _dth.dt_year(_dt_nanos(dt))),
    "stdDateTimeMonth": (1, lambda dt: _dth.dt_month(_dt_nanos(dt))),
    "stdDateTimeDay": (1, lambda dt: _dth.dt_day(_dt_nanos(dt))),
    "stdDateTimeHour": (1, lambda dt: _dth.dt_hour(_dt_nanos(dt))),
    "stdDateTimeMinute": (1, lambda dt: _dth.dt_minute(_dt_nanos(dt))),
    "stdDateTimeSecond": (1, lambda dt: _dth.dt_second(_dt_nanos(dt))),
    "stdDateTimeMillisecond": (1, lambda dt: _dth.dt_millisecond(_dt_nanos(dt))),
    "stdDateTimeMicrosecond": (1, lambda dt: _dth.dt_microsecond(_dt_nanos(dt))),
    "stdDateTimeNanosecond": (1, lambda dt: _dth.dt_nanosecond(_dt_nanos(dt))),
    "stdDateTimeWeekday": (1, lambda dt: _dth.dt_weekday(_dt_nanos(dt))),
    "stdDateTimeDayOfYear": (1, lambda dt: _dth.dt_day_of_year(_dt_nanos(dt))),
    "stdDateTimeDaysInMonth": (1, lambda dt: _dth.dt_days_in_month(_dt_nanos(dt))),
    "stdDateTimeQuarter": (1, lambda dt: _dth.dt_quarter(_dt_nanos(dt))),
    "stdDateTimeIsLeapYear": (1, lambda dt: _dth.dt_is_leap_year(_dt_nanos(dt))),
    "stdDateTimeIsWeekend": (1, lambda dt: _dth.dt_is_weekend(_dt_nanos(dt))),
    "stdDateTimeAddDays": (2, lambda dt, amt: _DT(_dth.dt_add_days(_dt_nanos(dt), int(amt)))),
    "stdDateTimeAddHours": (2, lambda dt, amt: _DT(_dth.dt_add_hours(_dt_nanos(dt), int(amt)))),
    "stdDateTimeAddMinutes": (2, lambda dt, amt: _DT(_dth.dt_add_minutes(_dt_nanos(dt), int(amt)))),
    "stdDateTimeAddSeconds": (2, lambda dt, amt: _DT(_dth.dt_add_seconds(_dt_nanos(dt), int(amt)))),
    "stdDateTimeAddMilliseconds": (2, lambda dt, amt: _DT(_dth.dt_add_milliseconds(_dt_nanos(dt), int(amt)))),
    "stdDateTimeAddMicroseconds": (2, lambda dt, amt: _DT(_dth.dt_add_microseconds(_dt_nanos(dt), int(amt)))),
    "stdDateTimeAddNanoseconds": (2, lambda dt, amt: _DT(_dth.dt_add_nanoseconds(_dt_nanos(dt), int(amt)))),
    "stdDateTimeAddMonths": (2, lambda dt, amt: _DT(_dth.dt_add_months(_dt_nanos(dt), int(amt)))),
    "stdDateTimeAddYears": (2, lambda dt, amt: _DT(_dth.dt_add_years(_dt_nanos(dt), int(amt)))),
    "stdDateTimeIsBefore": (2, lambda l, r: _dth.dt_is_before(_dt_nanos(l), _dt_nanos(r))),
    "stdDateTimeIsAfter": (2, lambda l, r: _dth.dt_is_after(_dt_nanos(l), _dt_nanos(r))),
    "stdDateTimeCompare": (2, lambda l, r: _dth.dt_compare(_dt_nanos(l), _dt_nanos(r))),
    "stdDateTimeDaysBetween": (2, lambda l, r: _dth.dt_days_between(_dt_nanos(l), _dt_nanos(r))),
    "stdDateTimeHoursBetween": (2, lambda l, r: _dth.dt_hours_between(_dt_nanos(l), _dt_nanos(r))),
    "stdDateTimeMinutesBetween": (2, lambda l, r: _dth.dt_minutes_between(_dt_nanos(l), _dt_nanos(r))),
    "stdDateTimeSecondsBetween": (2, lambda l, r: _dth.dt_seconds_between(_dt_nanos(l), _dt_nanos(r))),
    "stdDateTimeMillisecondsBetween": (2, lambda l, r: _dth.dt_milliseconds_between(_dt_nanos(l), _dt_nanos(r))),
    "stdDateTimeMicrosecondsBetween": (2, lambda l, r: _dth.dt_microseconds_between(_dt_nanos(l), _dt_nanos(r))),
    "stdDateTimeNanosecondsBetween": (2, lambda l, r: _dth.dt_nanoseconds_between(_dt_nanos(l), _dt_nanos(r))),
    "stdDateTimeMonthsBetween": (2, lambda l, r: _dth.dt_months_between(_dt_nanos(l), _dt_nanos(r))),
    "stdDateTimeYearsBetween": (2, lambda l, r: _dth.dt_years_between(_dt_nanos(l), _dt_nanos(r))),
    "stdDateTimeToTimeZone": (2, lambda dt, tz: _dth.dt_to_timezone(_dt_nanos(dt), str(tz))),
    "stdDateTimeToLocal": (1, lambda dt: _dth.dt_to_local(_dt_nanos(dt))),
    "stdDateTimeToUtc": (1, lambda dt: _DT(_dth.dt_to_utc(_dt_nanos(dt)))),
    "stdDateTimeUtcOffset": (2, lambda dt, tz: _dth.dt_utc_offset(_dt_nanos(dt), str(tz))),
    "stdDateTimeLocalTimeZone": (0, _dth.dt_local_timezone),
    "stdDateTimeIsDaylightSavingTime": (2, lambda dt, tz: _dth.dt_is_daylight_saving_time(_dt_nanos(dt), str(tz))),
    "stdDateTimeDstOffset": (2, lambda dt, tz: _dth.dt_dst_offset(_dt_nanos(dt), str(tz))),
    # SimdStdLib intrinsics
    "stdSimdVectorAddF32": (2, _simdh.simd_vector_add_f32),
    "stdSimdVectorSubF32": (2, _simdh.simd_vector_sub_f32),
    "stdSimdVectorMulF32": (2, _simdh.simd_vector_mul_f32),
    "stdSimdVectorDivF32": (2, _simdh.simd_vector_div_f32),
    "stdSimdVectorAddF64": (2, _simdh.simd_vector_add_f64),
    "stdSimdVectorSubF64": (2, _simdh.simd_vector_sub_f64),
    "stdSimdVectorMulF64": (2, _simdh.simd_vector_mul_f64),
    "stdSimdVectorDivF64": (2, _simdh.simd_vector_div_f64),
    "stdSimdDotProductF32": (2, _simdh.simd_dot_product_f32),
    "stdSimdDotProductF64": (2, _simdh.simd_dot_product_f64),
    "stdSimdVectorSumF32": (1, _simdh.simd_vector_sum_f32),
    "stdSimdVectorSumF64": (1, _simdh.simd_vector_sum_f64),
    "stdSimdMatrixMul2DF32": (2, _simdh.simd_matrix_mul_2d_f32),
    "stdSimdMatrixMul2DF64": (2, _simdh.simd_matrix_mul_2d_f64),
    "stdSimdVectorClampF32": (3, _simdh.simd_vector_clamp_f32),
    "stdSimdVectorClampF64": (3, _simdh.simd_vector_clamp_f64),
    "stdSimdSelectF32": (3, _simdh.simd_select_f32),
    "stdSimdSelectF64": (3, _simdh.simd_select_f64),
    # RuntimeStdLib intrinsics
    "stdRuntimeBackend": (0, lambda: "vm"),
    "stdRuntimeCompilerVersion": (0, _rth.runtime_compiler_version),
    "stdRuntimeGetArgs": (0, _rth.runtime_get_args),
    "stdRuntimeExecutablePath": (0, _rth.runtime_executable_path),
    "stdRuntimeGetTypeName": (1, _rth.runtime_get_type_name),
    "stdRuntimeAllocatedMemory": (0, _rth.runtime_allocated_memory),
    "stdRuntimeHeapSize": (0, _rth.runtime_heap_size),
    "stdRuntimePointerOf": (1, _rth.runtime_pointer_of),
    "stdRuntimePanic": (1, lambda msg: _rth.runtime_panic(str(msg))),
    "stdRuntimeTrap": (0, _rth.runtime_trap),
    "stdRuntimeStackTrace": (0, _rth.runtime_stack_trace),
    # DbStdLib intrinsics
    "stdDbSqlOpen": (1, lambda p: _dbh.db_sql_open(str(p))),
    "stdDbSqlExecute": (3, lambda h, sql, params: _dbh.db_sql_execute(int(h), str(sql), params if isinstance(params, list) else ([params] if params is not None else []))),
    "stdDbSqlQuery": (3, lambda h, sql, params: _dbh.db_sql_query(int(h), str(sql), params if isinstance(params, list) else ([params] if params is not None else []))),
    "stdDbSqlBegin": (1, lambda h: _dbh.db_sql_begin(int(h))),
    "stdDbSqlCommit": (1, lambda h: _dbh.db_sql_commit(int(h))),
    "stdDbSqlRollback": (1, lambda h: _dbh.db_sql_rollback(int(h))),
    "stdDbSqlLastInsertId": (1, lambda h: _dbh.db_sql_last_insert_id(int(h))),
    "stdDbSqlChanges": (1, lambda h: _dbh.db_sql_changes(int(h))),
    "stdDbSqlTableExists": (2, lambda h, t: _dbh.db_sql_table_exists(int(h), str(t))),
    "stdDbSqlClose": (1, lambda h: _dbh.db_sql_close(int(h))),
    "stdDbKvOpen": (2, lambda e, p: _dbh.db_kv_open(str(e), str(p))),
    "stdDbKvPut": (3, lambda h, k, v: _dbh.db_kv_put(int(h), str(k), str(v))),
    "stdDbKvGet": (2, lambda h, k: _dbh.db_kv_get(int(h), str(k))),
    "stdDbKvDelete": (2, lambda h, k: _dbh.db_kv_delete(int(h), str(k))),
    "stdDbKvExists": (2, lambda h, k: _dbh.db_kv_exists(int(h), str(k))),
    "stdDbKvClose": (1, lambda h: _dbh.db_kv_close(int(h))),
    "stdDbDocOpen": (1, lambda p: _dbh.db_doc_open(str(p))),
    "stdDbDocStore": (3, lambda h, c, d: _dbh.db_doc_store(int(h), str(c), d)),
    "stdDbDocFetch": (3, lambda h, c, doc_id: _dbh.db_doc_fetch(int(h), str(c), str(doc_id))),
    "stdDbDocDelete": (3, lambda h, c, doc_id: _dbh.db_doc_delete(int(h), str(c), str(doc_id))),
    "stdDbDocQuery": (4, lambda h, c, k, v: _dbh.db_doc_query(int(h), str(c), str(k), str(v))),
    "stdDbDocCount": (2, lambda h, c: _dbh.db_doc_count(int(h), str(c))),
    "stdDbDocClose": (1, lambda h: _dbh.db_doc_close(int(h))),
    "stdDbColumnOpen": (1, lambda p: _dbh.db_column_open(str(p))),
    "stdDbColumnExecute": (2, lambda h, sql: _dbh.db_column_execute(int(h), str(sql))),
    "stdDbColumnQuery": (2, lambda h, sql: _dbh.db_column_query(int(h), str(sql))),
    "stdDbColumnRowCount": (2, lambda h, t: _dbh.db_column_row_count(int(h), str(t))),
    "stdDbColumnScalar": (2, lambda h, sql: _dbh.db_column_scalar(int(h), str(sql))),
    "stdDbColumnClose": (1, lambda h: _dbh.db_column_close(int(h))),
    "stdDbGraphOpen": (1, lambda p: _dbh.db_graph_open(str(p))),
    "stdDbGraphExecute": (2, lambda h, cypher: _dbh.db_graph_execute(int(h), str(cypher))),
    "stdDbGraphQuery": (2, lambda h, cypher: _dbh.db_graph_query(int(h), str(cypher))),
    "stdDbGraphNodeCount": (2, lambda h, nt: _dbh.db_graph_node_count(int(h), str(nt))),
    "stdDbGraphRelCount": (2, lambda h, rt: _dbh.db_graph_rel_count(int(h), str(rt))),
    "stdDbGraphClose": (1, lambda h: _dbh.db_graph_close(int(h))),
    "stdDbVectorOpen": (3, lambda p, d, m: _dbh.db_vector_open(str(p), int(d), str(m))),
    "stdDbVectorInsert": (4, lambda h, vid, emb, meta: _dbh.db_vector_insert(int(h), int(vid), emb, str(meta))),
    "stdDbVectorSearch": (3, lambda h, q, k: _dbh.db_vector_search(int(h), q, int(k))),
    "stdDbVectorDelete": (2, lambda h, vid: _dbh.db_vector_delete(int(h), int(vid))),
    "stdDbVectorCount": (1, lambda h: _dbh.db_vector_count(int(h))),
    "stdDbVectorClose": (1, lambda h: _dbh.db_vector_close(int(h))),
    "stdDbIsValidRecord": (2, lambda rec, sch: _dbh.db_is_valid_record(rec, sch)),
    "stdDbSanitizeIdentifier": (1, lambda s: _dbh.db_sanitize_identifier(str(s))),
    "stdDbEscapeString": (1, lambda s: _dbh.db_escape_string(str(s))),
    # DslStdLib intrinsics
    "stdDslCreateLexer": (1, lambda m: _dslh.dsl_create_lexer(m if isinstance(m, dict) else {})),
    "stdDslTokenize": (2, lambda lid, code: _dslh.dsl_tokenize(int(lid), str(code))),
    "stdDslGetLexerTokens": (1, lambda lid: _dslh.dsl_get_lexer_tokens(int(lid))),
    "stdDslCreateParser": (2, lambda lid, rules: _dslh.dsl_create_parser(int(lid), rules if isinstance(rules, dict) else {})),
    "stdDslIsValidSyntax": (2, lambda pid, code: _dslh.dsl_is_valid_syntax(int(pid), str(code))),
    "stdDslGetErrors": (2, lambda pid, code: _dslh.dsl_get_errors(int(pid), str(code))),
    "stdDslFormatErrors": (2, lambda errs, code: _dslh.dsl_format_errors(errs if isinstance(errs, list) else [], str(code))),
    "stdDslGenerateAst": (2, lambda pid, code: _dslh.dsl_generate_ast(int(pid), str(code))),
    "stdDslDumpAst": (1, lambda ast: _dslh.dsl_dump_ast(ast if isinstance(ast, dict) else {})),
    "stdDslFindAstNodes": (2, lambda ast, nt: _dslh.dsl_find_ast_nodes(ast if isinstance(ast, dict) else {}, str(nt))),
    "stdDslTransformAst": (2, lambda ast, rules: _dslh.dsl_transform_ast(ast if isinstance(ast, dict) else {}, rules if isinstance(rules, dict) else {})),
    "stdDslCompile": (2, lambda ast, target: _dslh.dsl_compile(ast if isinstance(ast, dict) else {}, str(target))),
    "stdDslExecuteInline": (3, lambda pid, code, ctx: _dslh.dsl_execute_inline(int(pid), str(code), ctx if isinstance(ctx, dict) else {})),
    "stdDslGetAsmEngine": (1, lambda arch: _dslh.dsl_get_asm_engine(str(arch))),
    "stdDslAsmAssemble": (2, lambda aid, code: _dslh.dsl_asm_assemble(int(aid), str(code))),
    "stdDslAsmDisassemble": (2, lambda aid, mc: _dslh.dsl_asm_disassemble(int(aid), mc if isinstance(mc, list) else [])),
    "stdDslAsmValidateRegisters": (2, lambda aid, regs: _dslh.dsl_asm_validate_registers(int(aid), regs if isinstance(regs, list) else [])),
    "stdDslAsmGetRegisterMap": (1, lambda aid: _dslh.dsl_asm_get_register_map(int(aid))),
    "stdDslSetTimeout": (2, lambda eid, ms: _dslh.dsl_set_timeout(int(eid), int(ms))),
    "stdDslSetInstructionLimit": (2, lambda eid, ops: _dslh.dsl_set_instruction_limit(int(eid), int(ops))),
    "stdDslSetMemoryLimit": (2, lambda eid, b: _dslh.dsl_set_memory_limit(int(eid), int(b))),
    # ThreadStdLib intrinsics
    "stdChannelCreate": (0, lambda: _thh.channel_create(0)),
    "stdChannelCreateWithCapacity": (1, lambda cap: _thh.channel_create_with_capacity(int(cap))),
    "stdChannelSend": (2, lambda port, msg: _thh.channel_send(port, msg)),
    "stdChannelRecv": (1, lambda port: _thh.channel_recv(port)),
    "stdChannelTrySend": (2, lambda port, msg: _thh.channel_try_send(port, msg)),
    "stdChannelTryRecv": (1, lambda port: _thh.channel_try_recv(port)),
    "stdChannelClose": (1, lambda port: _thh.channel_close(port)),
    "stdChannelIsClosed": (1, lambda port: _thh.channel_is_closed(port)),
    "stdChannelIsEmpty": (1, lambda port: _thh.channel_is_empty(port)),
    "stdChannelLength": (1, lambda port: _thh.channel_length(port)),
    "stdChannelCapacity": (1, lambda port: _thh.channel_capacity(port)),
    "stdThreadMutexCreate": (0, _thh.mutex_create),
    "stdThreadMutexLock": (1, lambda mid: _thh.mutex_lock(int(mid))),
    "stdThreadMutexUnlock": (1, lambda mid: _thh.mutex_unlock(int(mid))),
    "stdThreadMutexTryLock": (1, lambda mid: _thh.mutex_try_lock(int(mid))),
    "stdThreadMutexDestroy": (1, lambda mid: _thh.mutex_destroy(int(mid))),
    "stdThreadAtomicCreate": (1, lambda val: _thh.atomic_create(int(val))),
    "stdThreadAtomicGet": (1, lambda aid: _thh.atomic_get(int(aid))),
    "stdThreadAtomicSet": (2, lambda aid, val: _thh.atomic_set(int(aid), int(val))),
    "stdThreadAtomicAdd": (2, lambda aid, d: _thh.atomic_add(int(aid), int(d))),
    "stdThreadAtomicCas": (3, lambda aid, exp, des: _thh.atomic_cas(int(aid), int(exp), int(des))),
    "stdThreadAtomicDestroy": (1, lambda aid: _thh.atomic_destroy(int(aid))),
    "stdThreadWaitGroupCreate": (0, _thh.wait_group_create),
    "stdThreadWaitGroupAdd": (2, lambda wgid, d: _thh.wait_group_add(int(wgid), int(d))),
    "stdThreadWaitGroupDone": (1, lambda wgid: _thh.wait_group_done(int(wgid))),
    "stdThreadWaitGroupWait": (1, lambda wgid: _thh.wait_group_wait(int(wgid))),
    "stdThreadWaitGroupDestroy": (1, lambda wgid: _thh.wait_group_destroy(int(wgid))),
    "stdThreadSpawn": (3, lambda ag, op, pl: _thh.thread_spawn(str(ag), str(op), pl)),
    "stdThreadJoin": (1, lambda tid: _thh.thread_join(int(tid))),
    "stdThreadIsAlive": (1, lambda tid: _thh.thread_is_alive(int(tid))),
    "stdThreadCurrentId": (0, _thh.thread_current_id),
    "stdThreadDetach": (1, lambda tid: _thh.thread_detach(int(tid))),
    "stdThreadHardwareConcurrency": (0, _thh.thread_hardware_concurrency),
    "stdThreadSleep": (1, lambda ms: _thh.thread_sleep(int(ms))),
    "stdThreadSleepMs": (1, lambda ms: _thh.thread_sleep_ms(int(ms))),
    "stdThreadYield": (0, _thh.thread_yield),
    # NativeGfxStdLib intrinsics
    "stdGfxWindowCreate": (3, lambda w, h, title: _gfxh.gfx_window_create(int(w), int(h), str(title))),
    "stdGfxWindowClose": (1, lambda wid: bool(_gfxh.gfx_window_close(int(wid)))),
    "stdGfxWindowWait": (2, lambda wid, ms: bool(_gfxh.gfx_window_wait(int(wid), int(ms)))),
    "stdGfxWindowFlush": (1, lambda wid: bool(_gfxh.gfx_window_flush(int(wid)))),
    "stdGfxClear": (4, lambda wid, r, g, b: bool(_gfxh.gfx_clear(int(wid), int(r), int(g), int(b)))),
    "stdGfxFillRect": (8, lambda wid, x, y, w, h, r, g, b: bool(_gfxh.gfx_fill_rect(int(wid), int(x), int(y), int(w), int(h), int(r), int(g), int(b)))),
    "stdGfxDrawRect": (8, lambda wid, x, y, w, h, r, g, b: bool(_gfxh.gfx_draw_rect(int(wid), int(x), int(y), int(w), int(h), int(r), int(g), int(b)))),
    "stdGfxDrawLine": (8, lambda wid, x1, y1, x2, y2, r, g, b: bool(_gfxh.gfx_draw_line(int(wid), int(x1), int(y1), int(x2), int(y2), int(r), int(g), int(b)))),
    "stdGfxDrawCircle": (7, lambda wid, cx, cy, rad, r, g, b: bool(_gfxh.gfx_draw_circle(int(wid), int(cx), int(cy), int(rad), int(r), int(g), int(b)))),
    "stdGfxFillCircle": (7, lambda wid, cx, cy, rad, r, g, b: bool(_gfxh.gfx_fill_circle(int(wid), int(cx), int(cy), int(rad), int(r), int(g), int(b)))),
    "stdGfxDrawText": (7, lambda wid, x, y, txt, r, g, b: bool(_gfxh.gfx_draw_text(int(wid), int(x), int(y), str(txt), int(r), int(g), int(b)))),
    "stdGfxEventPoll": (1, lambda wid: _gfxh.gfx_event_poll(int(wid))),
    "stdGfxEventX": (0, lambda: _gfxh.gfx_event_x()),
    "stdGfxEventY": (0, lambda: _gfxh.gfx_event_y()),
    "stdGfxEventKey": (0, lambda: _gfxh.gfx_event_key()),
    "stdGfxWindowClosed": (1, lambda wid: bool(_gfxh.gfx_window_closed(int(wid)))),
    "stdGfxWindowWidth": (1, lambda wid: _gfxh.gfx_window_width(int(wid))),
    "stdGfxWindowHeight": (1, lambda wid: _gfxh.gfx_window_height(int(wid))),
    "stdGfxExportHtml": (2, lambda wid, path: bool(_gfxh.export_html5_canvas(int(wid), str(path)))),
    # CompressStdLib intrinsics
    "stdCompressDeflate": (1, lambda s: _ch.compress_deflate(str(s))),
    "stdCompressDeflateLevel": (2, lambda s, l: _ch.compress_deflate_level(str(s), int(l))),
    "stdDecompressDeflate": (1, lambda s: _ch.decompress_deflate(str(s))),
    "stdDecompressDeflateSafe": (2, lambda s, q: _ch.decompress_deflate_safe(str(s), q)),
    "stdCompressIsDeflate": (1, lambda s: _ch.compress_is_deflate(str(s))),
    "stdCompressZlib": (1, lambda s: _ch.compress_zlib(str(s))),
    "stdCompressZlibLevel": (2, lambda s, l: _ch.compress_zlib_level(str(s), int(l))),
    "stdDecompressZlib": (1, lambda s: _ch.decompress_zlib(str(s))),
    "stdDecompressZlibSafe": (2, lambda s, q: _ch.decompress_zlib_safe(str(s), q)),
    "stdCompressIsZlib": (1, lambda s: _ch.compress_is_zlib(str(s))),
    "stdCompressZlibAdler32": (1, lambda s: _ch.compress_zlib_adler32(str(s))),
    "stdCompressGzip": (1, lambda s: _ch.compress_gzip(str(s))),
    "stdCompressGzipLevel": (2, lambda s, l: _ch.compress_gzip_level(str(s), int(l))),
    "stdDecompressGzip": (1, lambda s: _ch.decompress_gzip(str(s))),
    "stdDecompressGzipSafe": (2, lambda s, q: _ch.decompress_gzip_safe(str(s), q)),
    "stdCompressIsGzip": (1, lambda s: _ch.compress_is_gzip(str(s))),
    "stdCompressGzipCrc32": (1, lambda s: _ch.compress_gzip_crc32(str(s))),
    "stdCompressGzipTimestamp": (1, lambda s: _ch.compress_gzip_timestamp(str(s))),
    "stdCompressBzip2": (1, lambda s: _ch.compress_bzip2(str(s))),
    "stdCompressBzip2Level": (2, lambda s, l: _ch.compress_bzip2_level(str(s), int(l))),
    "stdDecompressBzip2": (1, lambda s: _ch.decompress_bzip2(str(s))),
    "stdDecompressBzip2Safe": (2, lambda s, q: _ch.decompress_bzip2_safe(str(s), q)),
    "stdCompressIsBzip2": (1, lambda s: _ch.compress_is_bzip2(str(s))),
    "stdCompressLzma": (1, lambda s: _ch.compress_lzma(str(s))),
    "stdCompressLzmaLevel": (2, lambda s, l: _ch.compress_lzma_level(str(s), int(l))),
    "stdDecompressLzma": (1, lambda s: _ch.decompress_lzma(str(s))),
    "stdDecompressLzmaSafe": (2, lambda s, q: _ch.decompress_lzma_safe(str(s), q)),
    "stdCompressIsLzma": (1, lambda s: _ch.compress_is_lzma(str(s))),
    "stdCompressLzma2": (1, lambda s: _ch.compress_lzma2(str(s))),
    "stdCompressLzma2Level": (2, lambda s, l: _ch.compress_lzma2_level(str(s), int(l))),
    "stdDecompressLzma2": (1, lambda s: _ch.decompress_lzma2(str(s))),
    "stdDecompressLzma2Safe": (2, lambda s, q: _ch.decompress_lzma2_safe(str(s), q)),
    "stdCompressXz": (1, lambda s: _ch.compress_xz(str(s))),
    "stdCompressXzLevel": (2, lambda s, l: _ch.compress_xz_level(str(s), int(l))),
    "stdDecompressXz": (1, lambda s: _ch.decompress_xz(str(s))),
    "stdDecompressXzSafe": (2, lambda s, q: _ch.decompress_xz_safe(str(s), q)),
    "stdCompressIsXz": (1, lambda s: _ch.compress_is_xz(str(s))),
    "stdCompressZstd": (1, lambda s: _ch.compress_zstd(str(s))),
    "stdCompressZstdLevel": (2, lambda s, l: _ch.compress_zstd_level(str(s), int(l))),
    "stdDecompressZstd": (1, lambda s: _ch.decompress_zstd(str(s))),
    "stdDecompressZstdSafe": (2, lambda s, q: _ch.decompress_zstd_safe(str(s), q)),
    "stdCompressIsZstd": (1, lambda s: _ch.compress_is_zstd(str(s))),
    "stdCompressZstdFrameSize": (1, lambda s: _ch.compress_zstd_frame_size(str(s))),
    "stdCompressEstimateDecompressedSize": (1, lambda s: _ch.compress_estimate_decompressed_size(str(s))),
    "stdCompressDetectFormat": (1, lambda s: _ch.compress_detect_format(str(s))),
    "stdCompressStats": (2, lambda u, c: _ch.compress_stats(str(u), str(c))),
    "stdDecompressAuto": (1, lambda s: _ch.decompress_auto(str(s))),
    "stdCompressIsEffective": (2, lambda u, c: _ch.compress_is_effective(str(u), str(c))),
    "stdCompressIsFormatSupported": (1, lambda f: _ch.compress_is_format_supported(str(f))),
    # IoArchiveContract intrinsics
    "stdArchiveZip": (2, lambda s, d: _ah.archive_zip(str(s), str(d))),
    "stdArchiveUnzip": (2, lambda s, d: _ah.archive_unzip(str(s), str(d))),
    "stdArchiveTar": (2, lambda s, d: _ah.archive_tar(str(s), str(d))),
    "stdArchiveExtractTar": (2, lambda s, d: _ah.archive_extract_tar(str(s), str(d))),
    "stdArchiveTarGz": (2, lambda s, d: _ah.archive_tar_gz(str(s), str(d))),
    "stdArchiveExtractTarGz": (2, lambda s, d: _ah.archive_extract_tar_gz(str(s), str(d))),
    "stdArchiveTarBz2": (2, lambda s, d: _ah.archive_tar_bz2(str(s), str(d))),
    "stdArchiveExtractTarBz2": (2, lambda s, d: _ah.archive_extract_tar_bz2(str(s), str(d))),
    "stdArchiveTarXz": (2, lambda s, d: _ah.archive_tar_xz(str(s), str(d))),
    "stdArchiveExtractTarXz": (2, lambda s, d: _ah.archive_extract_tar_xz(str(s), str(d))),
    "stdArchiveTarZst": (2, lambda s, d: _ah.archive_tar_zst(str(s), str(d))),
    "stdArchiveExtractTarZst": (2, lambda s, d: _ah.archive_extract_tar_zst(str(s), str(d))),
    "stdArchiveCreate7z": (2, lambda s, d: _ah.archive_create_7z(str(s), str(d))),
    "stdArchiveExtract7z": (2, lambda s, d: _ah.archive_extract_7z(str(s), str(d))),
    "stdArchiveExtractRar": (2, lambda s, d: _ah.archive_extract_rar(str(s), str(d))),
    "stdArchiveListFiles": (1, lambda s: _ah.archive_list_files(str(s))),
    "stdArchiveExtractFile": (3, lambda a, e, d: _ah.archive_extract_file(str(a), str(e), str(d))),
    "stdArchiveIsArchive": (1, lambda s: _ah.archive_is_archive(str(s))),
    "stdArchiveDetectFormat": (1, lambda s: _ah.archive_detect_format(str(s))),
    # IoBinaryFileContract intrinsics
    "stdIoReadBinaryFile": (1, lambda p: _iobh.io_read_binary_file(str(p))),
    "stdIoWriteBinaryFile": (2, lambda p, c: _iobh.io_write_binary_file(str(p), str(c))),
    "stdIoReadHexFile": (1, lambda p: _iobh.io_read_hex_file(str(p))),
    "stdIoWriteHexFile": (2, lambda p, c: _iobh.io_write_hex_file(str(p), str(c))),
    "stdIoReadBase64File": (1, lambda p: _iobh.io_read_base64_file(str(p))),
    "stdIoWriteBase64File": (2, lambda p, c: _iobh.io_write_base64_file(str(p), str(c))),
}

BUILTIN_NAMES = frozenset(_BUILTINS)


def _sorted(seq: list, desc: bool) -> list:
    seq.sort(key=_sort_key_raw, reverse=desc)
    return seq


def _reversed(seq: list) -> list:
    seq.reverse()
    return seq
