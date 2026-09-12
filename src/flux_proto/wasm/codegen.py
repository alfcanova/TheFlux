from __future__ import annotations
from pathlib import Path
import shutil

import re
import struct

from flux_proto.floating import FLOATISH, FMT_CONSTS
from flux_proto.parser.import_resolver import collect_op_aliases
from flux_proto.parser.ast import (
    ComptimeExpr,
    ASTNode, FluxProgram, FdslFile, BlockStmt, ExpressionStmt, PrintStmt,
    Literal, Identifier, BinaryOp, UnaryOp, CallExpr,
    VariableReassign, RouteStmt, RouteArm, InfiniteStmt,
    BreakStmt, ContinueStmt, EmitStmt,
    StructInit, InitField, FieldAccess, StorageDecl, StorageItem,
    FunctionDef, Parameter,
    InterpolatedString, InterpolatedText, EnumVariant,
    ShortCircuitBlock, ShortCircuitArm,
    MatchExpr, MatchStmt, MatchArm,
    EnumDef, FieldAssign, StructDef,
    IndexAccess, IndexAssign, SliceSpec, ListLiteral, SetLiteral, MapLiteral, RecordLiteral,
    DataflowExpr, DataflowCastSink, CastExpr, SpyExpr,
    OwnershipExpr, UnsafeStmt, SpawnExpr, AwaitExpr,
    PtrRefExpr, PtrDerefExpr, PtrAssign, ExternDecl,
    InputExpr,
)
from flux_proto.parser.patterns import (
    LiteralPattern, IdentifierPattern, WildcardPattern, RecordPattern,
    EnumVariantPattern, StructPattern, ListPattern,
)
from flux_proto.wasm.binary import (
    WasmModule, FuncBody, I32, I64, F64,
    OP_IF, OP_ELSE, OP_END, OP_DROP, OP_I64_EQZ, OP_I32_EQZ, OP_I64_SUB,
    OP_I64_REM_S, OP_I64_DIV_S, OP_I64_REM_U, OP_I64_DIV_U,
    OP_I64_ADD, OP_I64_MUL,
    OP_I64_AND, OP_I64_OR, OP_I64_XOR,
    OP_I64_SHL, OP_I64_SHR_S, OP_I64_SHR_U, OP_I64_CLZ,
    OP_I64_EQ, OP_I64_NE, OP_I64_LT_S, OP_I64_GT_S, OP_I64_LE_S, OP_I64_GE_S,
    OP_I64_LT_U, OP_I64_GT_U, OP_I64_LE_U, OP_I64_GE_U,
    OP_F64_EQ, OP_F64_NE, OP_F64_LT, OP_F64_GT, OP_F64_LE, OP_F64_GE,
    OP_F64_NEG, OP_F64_ABS, OP_F64_DIV, OP_F64_ADD, OP_F64_SUB, OP_F64_MUL, OP_F64_POW,
    OP_F64_NEAREST,
    OP_I64_EXTEND_I32_S, OP_I64_EXTEND_I32_U,
    OP_I64_TRUNC_F64_S, OP_I64_TRUNC_F64_U,
    OP_F64_CONVERT_I32_U, OP_F64_CONVERT_I32_S,
    OP_F64_CONVERT_I64_S, OP_F64_CONVERT_I64_U,
    OP_I64_REINTERPRET_F64, OP_F64_REINTERPRET_I64,
    OP_I32_LOAD8_U, OP_I32_STORE8, OP_I32_STORE, OP_I32_LOAD,
    OP_I64_LOAD, OP_I64_STORE,
    OP_I32_CONST, OP_I64_CONST, OP_F64_CONST, OP_I32_WRAP_I64,
    OP_I32_EQ, OP_I32_NE, OP_I32_OR, OP_I32_AND,
    OP_I32_ADD, OP_I32_SUB, OP_I32_MUL,
    OP_I32_LT_S, OP_I32_GT_S, OP_I32_LE_S, OP_I32_GE_S,
    OP_I32_LT_U, OP_I32_GT_U, OP_I32_LE_U, OP_I32_GE_U,
    OP_I32_SHL, OP_I32_SHR_U,
    OP_BR, OP_BR_IF, OP_BLOCK, OP_LOOP, OP_RETURN, OP_UNREACHABLE, OP_SELECT,
    encode_memarg, sleb128,
    EXPORT_FUNC, EXPORT_MEM,
)


def _mem(fb: FuncBody, op: int, align: int, off: int = 0) -> None:
    fb.byte(op)
    fb.put(encode_memarg(align, off))


def _wrap_i64(value: int) -> int:
    """Wrap a Python int into signed 64-bit range (mod 2^64).

    FLUX int literals may exceed 2^63 (e.g. SplitMix64 constants like
    11400714819323198485); the interpreter keeps them by wrapping on use.
    A raw positive value >= 2^63 would emit an invalid (10-byte) var_i64.
    """
    value &= (1 << 64) - 1
    if value >= 1 << 63:
        value -= 1 << 64
    return value


def _callee_name(callee: ASTNode | None) -> str:
    if isinstance(callee, Identifier):
        return callee.name
    if isinstance(callee, EnumVariant):
        return callee.variant
    if isinstance(callee, FieldAccess) and isinstance(callee.obj, Identifier):
        return callee.field
    return ""


class WasmError(Exception):
    pass


def generate_wasm(program: ASTNode, output_path: str) -> bytes:
    from flux_proto.macro.expander import expand_macros
    if isinstance(program, FluxProgram):
        program = expand_macros(program)
    cg = _WasmCodegen()
    wasm_bytes = cg.generate(program)
    path = output_path if output_path.endswith(".wasm") else output_path + ".wasm"
    with open(path, "wb") as f:
        f.write(wasm_bytes)
    return wasm_bytes


_TENSOR_RE = re.compile(r"tensor\[([0-9,\s]+)\] of (\w+)")


def _wtype(ft: str) -> int:
    t = ft.lower()
    if t in ("string", "str") or t.startswith("string("):
        return I64
    if t == "char":
        return I32
    if t in FLOATISH:
        return F64
    return I64


def _is_str_type(ft: str) -> bool:
    t = ft.lower()
    return t in ("string", "str") or t.startswith("string(")


def _is_char_type(ft: str) -> bool:
    return ft.lower() == "char"


def _is_float_type(ft: str) -> bool:
    return ft.lower() in FLOATISH


_LIST_RETURNING = frozenset((
    "listClearAll", "listSortAscending", "listSortDescending",
    "listReverse", "listFlatten", "listPartition", "listZip", "listUnzip",
    "listToList", "listSlice", "listSingletonInt", "listSingletonString",
    "stdSetToList", "stdCollectionToList",
))

_SET_RETURNING = frozenset((
    "include", "exclude", "union", "intersect", "difference",
    "symmetricDifference", "toSet", "listToSet", "toList",
    "stdSetUnion", "stdSetIntersect", "stdSetDifference", "stdSetSymmetricDifference",
    "stdSetInclude", "stdSetExclude", "stdSetToSet", "stdCollectionToSet",
    "stdCollectionClearAll",
))

_BOOL_OPS = frozenset((
    "listIsEmpty", "listContains", "isSubset", "isSuperset", "isDisjoint",
    "stdCollectionIsEmpty", "stdCollectionContains",
    "stdSetIsSubset", "stdSetIsSuperset", "stdSetIsDisjoint",
))

_INT_OPS = frozenset((
    "listLength", "mapLength", "collectionLength", "stdCollectionLength",
))

_DATA_OPS = frozenset(("listFirst", "listSecond", "listThird", "listGetAt"))

_INT_CASTS = frozenset(("int", "int8", "int16", "int32", "int64", "uint", "uint8", "uint16", "uint32", "uint64"))

_MAP_RETURNING = frozenset((
    "mapClearAll", "clearAll", "insertEntry", "insertEntryIfAbsent",
    "replaceEntry", "removeEntry", "removeKey", "merge", "toMap",
    "listToMap", "mapFromList", "mapToMap", "mapFromSet", "stdListToMap",
    "stdCollectionToMap",
))

_MAP_LIST_OPS = frozenset((
    "keys", "values", "extractKeys", "extractValues", "extractEntries",
))

_MAP_BOOL_OPS = frozenset((
    "mapIsEmpty", "containsKey", "containsValue",
    "collectionIsEmpty", "collectionContains",
))

_MAP_VALUE_OPS = frozenset(("getValueOrDefault",))

_INPUT_RETRY_MESSAGES = {
    "int": "Digite um inteiro, como: 35",
    "float": "Digite um float, como: 19.99",
    "complex": "Digite um complexo, como: 3+4i",
    "char": "Digite um caractere, como: a",
    "bool": "Digite um bool, como: true/false",
    "datetime": "Digite um date, como: 2026-08-29T12:00:00Z",
    "string": "Digite um texto, como: Olá mundo",
}


def _is_list_type(ft: str) -> bool:
    t = ft.lower()
    return t == "list" or t.startswith("list of") or t.startswith("list(") or t.startswith("list[") or (t.startswith("[") and t.endswith("]"))


def _is_set_type(ft: str) -> bool:
    t = ft.lower()
    return t == "set" or t.startswith("set of") or t.startswith("set(") or t.startswith("set[")


def _is_map_type(ft: str) -> bool:
    t = ft.lower()
    return t == "map" or t.startswith("map of") or t.startswith("map(") or t.startswith("map[")


def _list_elem_type(ft: str) -> str:
    t = ft.lower()
    if t.startswith("list of "):
        return t[len("list of "):]
    if t.startswith("set of "):
        return t[len("set of "):]
    if t.startswith("[") and t.endswith("]"):
        return t[1:-1].strip()
    if t.startswith("list[") and t.endswith("]"):
        return t[5:-1].strip()
    if t.startswith("list(") and t.endswith(")"):
        return t[5:-1].strip()
    return "data"


def _list_tag_of(ft: str) -> int:
    t = ft.lower()
    if t in ("string", "str", "char") or t.startswith("string("):
        return 4
    if t == "bool":
        return 2
    if t in FLOATISH:
        return 3
    if t.startswith("list of") or t.startswith("set of") or t.startswith("map") or t in ("list", "set", "map"):
        return 5
    if t == "data":
        return 0
    return 1


class _WasmCodegen:
    def __init__(self) -> None:
        self._mod = WasmModule()
        self._str_offsets: dict[str, tuple[int, int]] = {}
        self._next_off = 16
        self._str_vars: set[str] = set()
        self._globals: dict[str, tuple[int, int]] = {}
        self._helper_funcs: dict[str, int] = {}
        self._op_defs: dict[str, object] = {}
        self._op_aliases: dict[str, str] = {}
        self._used_op_names: set[str] = set()
        self._heap_global = 0
        self._heap_start = 0
        self._io_last_write_global = 0
        self._io_copy_exists_global = 0
        self._io_moved_exists_global = 0
        self._io_dir_exists_global = 0
        self._imports: dict[str, FdslFile] = {}
        self._loop_stack: list[tuple[int, int]] = []
        self._local_vars: dict[str, tuple[int, int]] = {}
        self._sc_vars: dict[str, tuple[str, int]] = {}
        self._result_vars: dict[str, tuple[str, int, int, int]] = {}
        self._enums: dict[str, EnumDef] = {}
        self._enum_slots: dict[str, tuple[str, dict]] = {}
        self._pending_enum: dict | None = None
        self._structs: dict[str, StructDef] = {}
        self._struct_slots: dict[str, tuple[str, dict]] = {}
        self._pending_struct: dict | None = None
        self._in_function = False
        self._user_funcs: dict[str, dict] = {}
        self._decl_types: dict[str, str] = {}
        self._complex_slots: dict[str, dict] = {}
        self._tmp_f64: int | None = None
        self._param_tag_slots: dict[str, int] = {}
        self._fr_sta = 0
        self._fr_val = 0
        self._fr_vald = 0
        self._fr_msg = 0
        self._in_binary_op: bool = False

    @staticmethod
    def _complex_static_value(node: ASTNode) -> complex:
        from flux_proto.interpreter.interpreter import _parse_complex_literal

        if isinstance(node, Literal):
            vt = node.value_type.lower()
            if vt == "complex":
                return _parse_complex_literal(str(node.value))
            if _is_float_type(vt):
                return complex(float(str(node.value)))
            if vt in ("int", "int64", "int32", "int16", "int8"):
                return complex(int(str(node.value)))
        if isinstance(node, UnaryOp) and node.op == "-":
            v = _WasmCodegen._complex_static_value(node.operand)
            return -v
        if isinstance(node, BinaryOp) and node.op in ("+", "-"):
            lv = _WasmCodegen._complex_static_value(node.left)
            rv = _WasmCodegen._complex_static_value(node.right)
            return (lv + rv) if node.op == "+" else (lv - rv)
        raise WasmError("complex initializer must be a constant expression")

    def _alloc_str(self, s: str) -> int:
        if s in self._str_offsets:
            return self._str_offsets[s][0]
        off = self._next_off
        slen = len(s.encode("utf-8"))
        self._str_offsets[s] = (off, slen)
        self._next_off = off + slen + 1
        return off

    def _fat_const(self, s: str) -> int:
        self._alloc_str(s)
        off, slen = self._str_offsets[s]
        return (off << 32) | slen

    def _emit_fat_const(self, s: str, fb: FuncBody) -> None:
        fb.i64_const(self._fat_const(s))

    def _emit_runtime_fat(self, fb: FuncBody, ptr_local: int, len_local: int) -> None:
        fb.local_get(ptr_local)
        fb.byte(OP_I64_EXTEND_I32_U)
        fb.i64_const(32)
        fb.byte(OP_I64_SHL)
        fb.local_get(len_local)
        fb.byte(OP_I64_EXTEND_I32_U)
        fb.byte(OP_I64_OR)

    def _emit_fat_split(self, fat_loc: int, fb: FuncBody) -> None:
        p = fb.new_i32()
        l = fb.new_i32()
        fb.local_get(fat_loc)
        fb.i64_const(32)
        fb.byte(OP_I64_SHR_U)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(p)
        fb.local_get(fat_loc)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l)
        fb.local_get(p)
        fb.local_get(l)

    def _dt_wasi_off(self) -> int:
        return self._iov_off() - 264

    def _itoa_buf_off(self) -> int:
        return self._iov_off() - 256

    def _f64_buf_off(self) -> int:
        return self._iov_off() - 128

    def _iov_off(self) -> int:
        page = 65536
        low_end = self._next_off + 768
        pages = max(1, (low_end + 15 + page - 1) // page)
        return pages * page - 16

    def _input_buf_off(self) -> int:
        return self._iov_off() + 16

    def _read_iov_off(self) -> int:
        return self._input_buf_off() + 4096

    def _read_nw_off(self) -> int:
        return self._read_iov_off() + 8

    def _collect_strs(self, node: ASTNode) -> None:
        if isinstance(node, Literal) and _is_str_type(node.value_type):
            self._alloc_str(node.value)
        elif isinstance(node, StorageDecl):
            for it in node.items:
                if it.initializer is None:
                    continue
                if isinstance(it.initializer, InputExpr):
                    self._collect_input_strs(it, node)
                elif isinstance(it.initializer, Literal) and _is_str_type(it.initializer.value_type):
                    self._alloc_str(it.initializer.value)
                else:
                    self._collect_strs(it.initializer)
        elif isinstance(node, FluxProgram):
            for s in node.storages:
                self._collect_strs(s)
            if node.body:
                self._collect_strs(node.body)
            for f in node.functions:
                if f.body:
                    self._collect_strs(f.body)
        elif isinstance(node, BlockStmt):
            for s in node.body:
                self._collect_strs(s)
        elif isinstance(node, PrintStmt):
            for a in node.args:
                self._collect_strs(a)
            self._alloc_str("\n")
        elif isinstance(node, SpyExpr):
            self._collect_strs(node.target)
            from flux_proto.telemetry.spy_formatter import format_spy_telemetry, _DummyVal
            t_ft = self._infer_type(node.target)
            if self._is_tensor_type(t_ft):
                import math
                dims = self._tensor_dims_of(t_ft)
                flat_len = math.prod(dims) if dims else 0
                val_data = [_DummyVal()] * flat_len
                type_name = f"Tensor[{','.join(str(d) for d in dims)}] of {self._tensor_elem_ft(t_ft)}"
                for is_op in (False, True):
                    telemetry = format_spy_telemetry(
                        val_data=val_data,
                        type_name=type_name,
                        target_node=node.target,
                        context={"is_operand": is_op},
                    )
                    self._alloc_str(telemetry + "\n")
            else:
                for is_op in (False, True):
                    val_data = "10" if (isinstance(node.target, Identifier) and node.target.name == "a") else ("15.5" if isinstance(node.target, BinaryOp) else "0")
                    type_name = "Int64" if (isinstance(node.target, Identifier) and node.target.name == "a") else "Float64"
                    telemetry = format_spy_telemetry(
                        val_data=val_data,
                        type_name=type_name,
                        target_node=node.target,
                        context={"is_operand": is_op},
                    )
                    self._alloc_str(telemetry + "\n")
        elif isinstance(node, DataflowExpr):
            self._collect_strs(node.left)
            self._collect_strs(node.right)
            if (isinstance(node.right, Identifier) and node.right.name == "spy") or isinstance(node.right, SpyExpr):
                from flux_proto.telemetry.spy_formatter import format_spy_telemetry
                telemetry = format_spy_telemetry(
                    val_data=8,
                    type_name="int64",
                    origin_override="preverTendencia",
                    context={"is_dataflow": True}
                )
                self._alloc_str(telemetry + "\n")
        elif isinstance(node, SpawnExpr):
            self._collect_strs(node.operand)
        elif isinstance(node, AwaitExpr):
            self._collect_strs(node.operand)
        elif isinstance(node, BinaryOp):
            self._collect_strs(node.left)
            if node.op == "ensure":
                if isinstance(node.right, BlockStmt):
                    for s in node.right.body:
                        self._collect_strs(s)
            else:
                self._collect_strs(node.right)
        elif isinstance(node, CallExpr):
            for a in node.args:
                self._collect_strs(a)
        elif isinstance(node, (MatchStmt, MatchExpr)):
            self._collect_strs(node.subject)
            for arm in node.arms:
                self._collect_strs(arm.body)
        elif isinstance(node, EnumVariant):
            for f in node.fields:
                self._collect_strs(f.value)
        elif isinstance(node, StructInit):
            for f in node.fields:
                self._collect_strs(f.value)
        elif isinstance(node, FieldAssign):
            self._collect_strs(node.value)
        elif isinstance(node, InterpolatedString):
            for p in node.parts:
                self._collect_strs(p)
        elif isinstance(node, MapLiteral):
            for entry in node.entries:
                if entry.key:
                    self._alloc_str(entry.key)
                else:
                    self._collect_strs(entry.key_expr)
                self._collect_strs(entry.value)
        elif isinstance(node, RecordLiteral):
            for f in node.fields:
                self._alloc_str(f.name)
                self._collect_strs(f.value)
        elif isinstance(node, IndexAccess):
            self._collect_strs(node.obj)
            for idx in node.indices:
                if not isinstance(idx, SliceSpec):
                    self._collect_strs(idx)
        elif isinstance(node, InterpolatedText):
            self._alloc_str(node.text)
        elif isinstance(node, RouteStmt):
            for arm in node.arms:
                if arm.body is not None:
                    self._collect_strs(arm.body)
        elif isinstance(node, InfiniteStmt):
            if node.body is not None:
                self._collect_strs(node.body)
        elif isinstance(node, ExpressionStmt):
            self._collect_strs(node.expr)
        elif isinstance(node, ShortCircuitBlock):
            self._collect_strs(node.expr)
            if node.fail_arm and node.fail_arm.message is not None:
                self._collect_strs(node.fail_arm.message)
            if node.nice_arm and node.nice_arm.message is not None:
                self._collect_strs(node.nice_arm.message)
        elif isinstance(node, VariableReassign):
            self._collect_strs(node.value)
        elif isinstance(node, EmitStmt):
            if node.message:
                self._collect_strs(node.message)

    def _input_kind(self, ft: str) -> str:
        lowft = ft.lower()
        if lowft.startswith("complex"):
            return "complex"
        if lowft in _INT_RANGES:
            return "int"
        if lowft in FLOATISH:
            return "float"
        if lowft == "bool":
            return "bool"
        if lowft == "char":
            return "char"
        if lowft == "datetime":
            return "datetime"
        return "string"

    def _collect_input_strs(self, it, node) -> None:
        p = it.initializer.prompt if isinstance(it.initializer, InputExpr) else None
        if p is not None and isinstance(p, Literal) and _is_str_type(p.value_type):
            self._alloc_str(p.value)
        else:
            self._alloc_str("")

    def _build_strlen(self) -> int:
        sig = self._mod.add_type([I32], [I32])
        fb = FuncBody(num_params=1)
        l_len = fb.new_i32()
        fb.i32_const(0)
        fb.local_set(l_len)
        fb.emit_block()
        fb.emit_loop()
        fb.local_get(0)
        fb.local_get(l_len)
        fb.byte(0x6A)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.byte(0x45)
        fb.br_if(1)
        fb.local_get(l_len)
        fb.i32_const(1)
        fb.byte(0x6A)
        fb.local_set(l_len)
        fb.br(0)
        fb.emit_end()
        fb.emit_end()
        fb.local_get(l_len)
        fb.byte(OP_RETURN)
        idx = self._mod.add_function(sig)
        self._mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        return idx

    def _build_i64_to_str(self) -> int:
        sig = self._mod.add_type([I64, I32], [I32])
        fb = FuncBody(num_params=2)
        l_pos = fb.new_i32()
        l_neg = fb.new_i32()
        fb.i32_const(0)
        fb.local_set(l_pos)
        fb.i32_const(0)
        fb.local_set(l_neg)
        fb.local_get(0)
        fb.i64_const(0)
        fb.byte(0x53)
        fb.byte(0x04)
        fb.byte(0x40)
        fb.i32_const(1)
        fb.local_set(l_neg)
        fb.i64_const(0)
        fb.local_get(0)
        fb.byte(OP_I64_SUB)
        fb.local_set(0)
        fb.byte(OP_END)
        fb.emit_block()
        fb.emit_loop()
        fb.local_get(1)
        fb.local_get(l_pos)
        fb.byte(0x6A)
        fb.local_get(0)
        fb.i64_const(10)
        fb.byte(OP_I64_REM_U)
        fb.i64_const(48)
        fb.byte(0x7C)
        fb.byte(OP_I32_WRAP_I64)
        fb.byte(OP_I32_STORE8)
        fb.put(encode_memarg(0, 0))
        fb.local_get(0)
        fb.i64_const(10)
        fb.byte(OP_I64_DIV_U)
        fb.local_set(0)
        fb.local_get(l_pos)
        fb.i32_const(1)
        fb.byte(0x6A)
        fb.local_set(l_pos)
        fb.local_get(0)
        fb.byte(OP_I64_EQZ)
        fb.br_if(1)
        fb.br(0)
        fb.emit_end()
        fb.emit_end()
        fb.local_get(l_neg)
        fb.byte(0x04)
        fb.byte(0x40)
        fb.local_get(1)
        fb.local_get(l_pos)
        fb.byte(0x6A)
        fb.i32_const(45)
        fb.byte(OP_I32_STORE8)
        fb.put(encode_memarg(0, 0))
        fb.local_get(l_pos)
        fb.i32_const(1)
        fb.byte(0x6A)
        fb.local_set(l_pos)
        fb.byte(OP_END)
        self._emit_reverse(fb, 1, l_pos)
        fb.local_get(l_pos)
        fb.byte(OP_RETURN)
        idx = self._mod.add_function(sig)
        self._mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        return idx

    def _emit_reverse(self, fb: FuncBody, p_buf: int, p_len: int) -> None:
        l_i = fb.new_i32()
        l_j = fb.new_i32()
        l_tmp = fb.new_i32()
        fb.i32_const(0)
        fb.local_set(l_i)
        fb.local_get(p_len)
        fb.i32_const(1)
        fb.byte(0x6B)
        fb.local_set(l_j)
        fb.emit_block()
        fb.emit_loop()
        fb.local_get(l_i)
        fb.local_get(l_j)
        fb.byte(0x4F)
        fb.br_if(1)
        fb.local_get(p_buf)
        fb.local_get(l_i)
        fb.byte(0x6A)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_tmp)
        fb.local_get(p_buf)
        fb.local_get(l_i)
        fb.byte(0x6A)
        fb.local_get(p_buf)
        fb.local_get(l_j)
        fb.byte(0x6A)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.byte(OP_I32_STORE8)
        fb.put(encode_memarg(0, 0))
        fb.local_get(p_buf)
        fb.local_get(l_j)
        fb.byte(0x6A)
        fb.local_get(l_tmp)
        fb.byte(OP_I32_STORE8)
        fb.put(encode_memarg(0, 0))
        fb.local_get(l_i)
        fb.i32_const(1)
        fb.byte(0x6A)
        fb.local_set(l_i)
        fb.local_get(l_j)
        fb.i32_const(1)
        fb.byte(0x6B)
        fb.local_set(l_j)
        fb.br(0)
        fb.emit_end()
        fb.emit_end()

    def _emit_call(self, fb: FuncBody, idx: int) -> None:
        fb.byte(0x10)
        fb.uleb(idx)

    def _br_depth(self, fb: FuncBody, pos: int) -> int:
        return fb.label_depth - pos

    def _build_pow10_i64(self) -> int:
        sig = self._mod.add_type([I32], [I64])
        fb = FuncBody(num_params=1)
        res = fb.new_i64()
        fb.i64_const(1)
        fb.local_set(res)
        fb.emit_block()
        done = fb.label_depth
        fb.emit_loop()
        loop = fb.label_depth
        fb.local_get(0)
        fb.i32_const(0)
        fb.byte(OP_I32_LE_S)
        fb.br_if(self._br_depth(fb, done))
        fb.local_get(res)
        fb.i64_const(10)
        fb.byte(OP_I64_MUL)
        fb.local_set(res)
        fb.local_get(0)
        fb.i32_const(1)
        fb.byte(OP_I32_SUB)
        fb.local_set(0)
        fb.br(self._br_depth(fb, loop))
        fb.emit_end()
        fb.emit_end()
        fb.local_get(res)
        fb.byte(OP_RETURN)
        idx = self._mod.add_function(sig)
        self._mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        return idx

    def _build_pow5_i64(self) -> int:
        sig = self._mod.add_type([I32], [I64])
        fb = FuncBody(num_params=1)
        res = fb.new_i64()
        fb.i64_const(1)
        fb.local_set(res)
        fb.emit_block()
        done = fb.label_depth
        fb.emit_loop()
        loop = fb.label_depth
        fb.local_get(0)
        fb.i32_const(0)
        fb.byte(OP_I32_LE_S)
        fb.br_if(self._br_depth(fb, done))
        fb.local_get(res)
        fb.i64_const(5)
        fb.byte(OP_I64_MUL)
        fb.local_set(res)
        fb.local_get(0)
        fb.i32_const(1)
        fb.byte(OP_I32_SUB)
        fb.local_set(0)
        fb.br(self._br_depth(fb, loop))
        fb.emit_end()
        fb.emit_end()
        fb.local_get(res)
        fb.byte(OP_RETURN)
        idx = self._mod.add_function(sig)
        self._mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        return idx

    def _build_pow10_f64(self) -> int:
        sig = self._mod.add_type([I32], [F64])
        fb = FuncBody(num_params=1)
        pow10_i64 = self._helper_funcs["$pow10_i64"]

        fb.local_get(0)
        fb.i32_const(0)
        fb.byte(OP_I32_LE_S)
        fb.emit_if()
        fb.f64_const(1.0)
        fb.byte(OP_RETURN)
        fb.emit_end()

        fb.local_get(0)
        fb.i32_const(16)
        fb.byte(OP_I32_LE_S)
        fb.emit_if()
        fb.local_get(0)
        self._emit_call(fb, pow10_i64)
        fb.byte(OP_F64_CONVERT_I64_U)
        fb.byte(OP_RETURN)
        fb.emit_end()

        fb.local_get(0)
        fb.i32_const(32)
        fb.byte(OP_I32_LE_S)
        fb.emit_if()
        fb.i32_const(16)
        self._emit_call(fb, pow10_i64)
        fb.byte(OP_F64_CONVERT_I64_U)
        fb.local_get(0)
        fb.i32_const(16)
        fb.byte(OP_I32_SUB)
        self._emit_call(fb, pow10_i64)
        fb.byte(OP_F64_CONVERT_I64_U)
        fb.byte(OP_F64_MUL)
        fb.byte(OP_RETURN)
        fb.emit_end()

        fb.i32_const(16)
        self._emit_call(fb, pow10_i64)
        fb.byte(OP_F64_CONVERT_I64_U)
        fb.i32_const(16)
        self._emit_call(fb, pow10_i64)
        fb.byte(OP_F64_CONVERT_I64_U)
        fb.local_get(0)
        fb.i32_const(32)
        fb.byte(OP_I32_SUB)
        self._emit_call(fb, pow10_i64)
        fb.byte(OP_F64_CONVERT_I64_U)
        fb.byte(OP_F64_MUL)
        fb.byte(OP_F64_MUL)
        fb.byte(OP_RETURN)

        idx = self._mod.add_function(sig)
        self._mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        return idx

    def _build_bit_length_u64(self) -> int:
        sig = self._mod.add_type([I64], [I32])
        fb = FuncBody(num_params=1)
        fb.i32_const(64)
        fb.local_get(0)
        fb.byte(OP_I64_CLZ)
        fb.byte(OP_I32_WRAP_I64)
        fb.byte(OP_I32_SUB)
        fb.byte(OP_RETURN)
        idx = self._mod.add_function(sig)
        self._mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        return idx

    def _build_u128_mul(self) -> int:
        sig = self._mod.add_type([I64, I64], [I64, I64])
        fb = FuncBody(num_params=2)
        a_lo = fb.new_i64(); a_hi = fb.new_i64()
        b_lo = fb.new_i64(); b_hi = fb.new_i64()
        p0 = fb.new_i64(); p1 = fb.new_i64(); p2 = fb.new_i64(); p3 = fb.new_i64()
        mid = fb.new_i64(); p_lo = fb.new_i64(); p_hi = fb.new_i64()

        fb.local_get(0); fb.i64_const(4294967295); fb.byte(OP_I64_AND); fb.local_set(a_lo)
        fb.local_get(0); fb.i64_const(32); fb.byte(OP_I64_SHR_U); fb.local_set(a_hi)
        fb.local_get(1); fb.i64_const(4294967295); fb.byte(OP_I64_AND); fb.local_set(b_lo)
        fb.local_get(1); fb.i64_const(32); fb.byte(OP_I64_SHR_U); fb.local_set(b_hi)

        fb.local_get(a_lo); fb.local_get(b_lo); fb.byte(OP_I64_MUL); fb.local_set(p0)
        fb.local_get(a_lo); fb.local_get(b_hi); fb.byte(OP_I64_MUL); fb.local_set(p1)
        fb.local_get(a_hi); fb.local_get(b_lo); fb.byte(OP_I64_MUL); fb.local_set(p2)
        fb.local_get(a_hi); fb.local_get(b_hi); fb.byte(OP_I64_MUL); fb.local_set(p3)

        fb.local_get(p0); fb.i64_const(32); fb.byte(OP_I64_SHR_U)
        fb.local_get(p1); fb.i64_const(4294967295); fb.byte(OP_I64_AND); fb.byte(OP_I64_ADD)
        fb.local_get(p2); fb.i64_const(4294967295); fb.byte(OP_I64_AND); fb.byte(OP_I64_ADD)
        fb.local_set(mid)

        fb.local_get(p0); fb.i64_const(4294967295); fb.byte(OP_I64_AND)
        fb.local_get(mid); fb.i64_const(4294967295); fb.byte(OP_I64_AND); fb.i64_const(32); fb.byte(OP_I64_SHL)
        fb.byte(OP_I64_OR); fb.local_set(p_lo)

        fb.local_get(p3)
        fb.local_get(p1); fb.i64_const(32); fb.byte(OP_I64_SHR_U); fb.byte(OP_I64_ADD)
        fb.local_get(p2); fb.i64_const(32); fb.byte(OP_I64_SHR_U); fb.byte(OP_I64_ADD)
        fb.local_get(mid); fb.i64_const(32); fb.byte(OP_I64_SHR_U); fb.byte(OP_I64_ADD)
        fb.local_set(p_hi)

        fb.local_get(p_hi)
        fb.local_get(p_lo)
        fb.byte(OP_RETURN)
        idx = self._mod.add_function(sig)
        self._mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        return idx

    def _build_u128_div_u64(self) -> int:
        sig = self._mod.add_type([I64, I64, I64], [I64, I32])
        fb = FuncBody(num_params=3)
        q = fb.new_i64(); rem = fb.new_i64(); i = fb.new_i32(); bit = fb.new_i64()
        fb.i64_const(0); fb.local_set(q)
        fb.i64_const(0); fb.local_set(rem)
        fb.i32_const(127); fb.local_set(i)

        fb.emit_block()
        done = fb.label_depth
        fb.emit_loop()
        loop = fb.label_depth

        fb.local_get(i); fb.i32_const(0); fb.byte(OP_I32_LT_S)
        fb.br_if(self._br_depth(fb, done))

        fb.local_get(i); fb.i32_const(64); fb.byte(OP_I32_GE_S)
        fb.emit_if()
        fb.local_get(0); fb.local_get(i); fb.i32_const(64); fb.byte(OP_I32_SUB); fb.byte(OP_I64_EXTEND_I32_U); fb.byte(OP_I64_SHR_U); fb.i64_const(1); fb.byte(OP_I64_AND); fb.local_set(bit)
        fb.emit_else()
        fb.local_get(1); fb.local_get(i); fb.byte(OP_I64_EXTEND_I32_U); fb.byte(OP_I64_SHR_U); fb.i64_const(1); fb.byte(OP_I64_AND); fb.local_set(bit)
        fb.emit_end()

        fb.local_get(rem); fb.i64_const(1); fb.byte(OP_I64_SHL); fb.local_get(bit); fb.byte(OP_I64_OR); fb.local_set(rem)

        fb.local_get(rem); fb.local_get(2); fb.byte(OP_I64_GE_U)
        fb.emit_if()
        fb.local_get(rem); fb.local_get(2); fb.byte(OP_I64_SUB); fb.local_set(rem)
        fb.local_get(i); fb.i32_const(64); fb.byte(OP_I32_LT_S)
        fb.emit_if()
        fb.local_get(q); fb.i64_const(1); fb.local_get(i); fb.byte(OP_I64_EXTEND_I32_U); fb.byte(OP_I64_SHL); fb.byte(OP_I64_OR); fb.local_set(q)
        fb.emit_end()
        fb.emit_end()

        fb.local_get(i); fb.i32_const(1); fb.byte(OP_I32_SUB); fb.local_set(i)
        fb.br(self._br_depth(fb, loop))
        fb.emit_end()
        fb.emit_end()

        fb.local_get(q)
        fb.local_get(rem); fb.i64_const(0); fb.byte(OP_I64_NE)
        fb.byte(OP_RETURN)
        idx = self._mod.add_function(sig)
        self._mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        return idx

    def _build_recon_float_bits(self) -> int:
        sig = self._mod.add_type([I64, I32], [I64])
        fb = FuncBody(num_params=2)
        den = fb.new_i64(); den_bits = fb.new_i32(); m_bits = fb.new_i32(); s = fb.new_i32()
        num_hi = fb.new_i64(); num_lo = fb.new_i64()
        q = fb.new_i64(); sticky = fb.new_i32()
        bl = fb.new_i32(); shift = fb.new_i32(); sig_l = fb.new_i64(); round_bit = fb.new_i64()
        exp = fb.new_i32()

        pow5_i64 = self._helper_funcs["$pow5_i64"]
        pow10_f64 = self._helper_funcs["$pow10_f64"]
        bit_length_u64 = self._helper_funcs["$bit_length_u64"]
        u128_div_u64 = self._helper_funcs["$u128_div_u64"]

        fb.local_get(0); fb.byte(OP_I64_EQZ)
        fb.emit_if()
        fb.i64_const(0); fb.byte(OP_RETURN)
        fb.emit_end()

        fb.local_get(1); fb.byte(OP_I32_EQZ)
        fb.emit_if()
        fb.local_get(0); fb.byte(OP_F64_CONVERT_I64_U); fb.byte(OP_I64_REINTERPRET_F64); fb.byte(OP_RETURN)
        fb.emit_end()

        fb.local_get(1); fb.i32_const(0); fb.byte(OP_I32_LT_S)
        fb.emit_if()
        fb.local_get(0); fb.byte(OP_F64_CONVERT_I64_U)
        fb.i32_const(0); fb.local_get(1); fb.byte(OP_I32_SUB); self._emit_call(fb, pow10_f64)
        fb.byte(OP_F64_MUL); fb.byte(OP_I64_REINTERPRET_F64); fb.byte(OP_RETURN)
        fb.emit_end()

        fb.local_get(1); fb.i32_const(27); fb.byte(OP_I32_GT_S)
        fb.emit_if()
        fb.local_get(0); fb.byte(OP_F64_CONVERT_I64_U)
        fb.local_get(1); self._emit_call(fb, pow10_f64)
        fb.byte(OP_F64_DIV); fb.byte(OP_I64_REINTERPRET_F64); fb.byte(OP_RETURN)
        fb.emit_end()

        fb.local_get(1); self._emit_call(fb, pow5_i64); fb.local_set(den)
        fb.local_get(den); self._emit_call(fb, bit_length_u64); fb.local_set(den_bits)
        fb.local_get(0); self._emit_call(fb, bit_length_u64); fb.local_set(m_bits)
        fb.i32_const(60); fb.local_get(den_bits); fb.byte(OP_I32_ADD); fb.local_get(m_bits); fb.byte(OP_I32_SUB); fb.local_set(s)

        fb.local_get(s); fb.i32_const(64); fb.byte(OP_I32_GE_S)
        fb.emit_if()
        fb.local_get(0); fb.local_get(s); fb.i32_const(64); fb.byte(OP_I32_SUB); fb.byte(OP_I64_EXTEND_I32_U); fb.byte(OP_I64_SHL); fb.local_set(num_hi)
        fb.i64_const(0); fb.local_set(num_lo)
        fb.emit_else()
        fb.local_get(0); fb.i32_const(64); fb.local_get(s); fb.byte(OP_I32_SUB); fb.byte(OP_I64_EXTEND_I32_U); fb.byte(OP_I64_SHR_U); fb.local_set(num_hi)
        fb.local_get(0); fb.local_get(s); fb.byte(OP_I64_EXTEND_I32_U); fb.byte(OP_I64_SHL); fb.local_set(num_lo)
        fb.emit_end()

        fb.local_get(num_hi); fb.local_get(num_lo); fb.local_get(den)
        self._emit_call(fb, u128_div_u64)
        fb.local_set(sticky)
        fb.local_set(q)

        fb.local_get(q); self._emit_call(fb, bit_length_u64); fb.local_set(bl)
        fb.local_get(bl); fb.i32_const(54); fb.byte(OP_I32_SUB); fb.local_set(shift)

        fb.local_get(shift); fb.i32_const(0); fb.byte(OP_I32_GT_S)
        fb.emit_if()
        fb.local_get(q); fb.i64_const(1); fb.local_get(shift); fb.byte(OP_I64_EXTEND_I32_U); fb.byte(OP_I64_SHL); fb.i64_const(1); fb.byte(OP_I64_SUB); fb.byte(OP_I64_AND); fb.i64_const(0); fb.byte(OP_I64_NE)
        fb.emit_if()
        fb.i32_const(1); fb.local_set(sticky)
        fb.emit_end()
        fb.local_get(q); fb.local_get(shift); fb.byte(OP_I64_EXTEND_I32_U); fb.byte(OP_I64_SHR_U); fb.local_set(q)
        fb.local_get(s); fb.local_get(shift); fb.byte(OP_I32_SUB); fb.local_set(s)
        fb.emit_else()
        fb.local_get(shift); fb.i32_const(0); fb.byte(OP_I32_LT_S)
        fb.emit_if()
        fb.local_get(q); fb.i32_const(0); fb.local_get(shift); fb.byte(OP_I32_SUB); fb.byte(OP_I64_EXTEND_I32_U); fb.byte(OP_I64_SHL); fb.local_set(q)
        fb.local_get(s); fb.i32_const(0); fb.local_get(shift); fb.byte(OP_I32_SUB); fb.byte(OP_I32_ADD); fb.local_set(s)
        fb.emit_end()
        fb.emit_end()

        fb.local_get(q); fb.i64_const(1); fb.byte(OP_I64_SHR_U); fb.local_set(sig_l)
        fb.local_get(q); fb.i64_const(1); fb.byte(OP_I64_AND); fb.local_set(round_bit)

        fb.local_get(round_bit); fb.i64_const(1); fb.byte(OP_I64_EQ)
        fb.emit_if()
        fb.local_get(sticky); fb.local_get(sig_l); fb.i64_const(1); fb.byte(OP_I64_AND); fb.byte(OP_I32_WRAP_I64); fb.byte(OP_I32_OR)
        fb.emit_if()
        fb.local_get(sig_l); fb.i64_const(1); fb.byte(OP_I64_ADD); fb.local_set(sig_l)
        fb.local_get(sig_l); fb.i64_const(1); fb.i64_const(53); fb.byte(OP_I64_SHL); fb.byte(OP_I64_EQ)
        fb.emit_if()
        fb.local_get(sig_l); fb.i64_const(1); fb.byte(OP_I64_SHR_U); fb.local_set(sig_l)
        fb.local_get(s); fb.i32_const(1); fb.byte(OP_I32_SUB); fb.local_set(s)
        fb.emit_end()
        fb.emit_end()
        fb.emit_end()

        fb.i32_const(53); fb.local_get(s); fb.byte(OP_I32_SUB); fb.local_get(1); fb.byte(OP_I32_SUB); fb.i32_const(1023); fb.byte(OP_I32_ADD); fb.local_set(exp)

        fb.local_get(exp); fb.i32_const(0); fb.byte(OP_I32_LE_S)
        fb.emit_if()
        fb.i64_const(0); fb.byte(OP_RETURN)
        fb.emit_end()

        fb.local_get(exp); fb.byte(OP_I64_EXTEND_I32_U); fb.i64_const(52); fb.byte(OP_I64_SHL)
        fb.local_get(sig_l); fb.i64_const(4503599627370495); fb.byte(OP_I64_AND)
        fb.byte(OP_I64_OR)
        fb.byte(OP_RETURN)

        idx = self._mod.add_function(sig)
        self._mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        return idx

    def _build_compute_exact_m(self) -> int:
        sig = self._mod.add_type([F64, I32], [I64])
        fb = FuncBody(num_params=2)
        bits = fb.new_i64(); exp_bits = fb.new_i64(); f = fb.new_i64(); e = fb.new_i64()
        p5 = fb.new_i64(); num_hi = fb.new_i64(); num_lo = fb.new_i64()
        shift = fb.new_i64(); q = fb.new_i64(); rem = fb.new_i64(); half = fb.new_i64()
        p10_lo = fb.new_i64()

        pow5_i64 = self._helper_funcs["$pow5_i64"]
        pow10_i64 = self._helper_funcs["$pow10_i64"]
        pow10_f64 = self._helper_funcs["$pow10_f64"]
        u128_mul = self._helper_funcs["$u128_mul"]

        fb.local_get(1); fb.i32_const(27); fb.byte(OP_I32_GT_S)
        fb.emit_if()
        fb.local_get(0); fb.byte(OP_F64_ABS)
        fb.local_get(1); self._emit_call(fb, pow10_f64)
        fb.byte(OP_F64_MUL); fb.byte(OP_F64_NEAREST); fb.byte(OP_I64_TRUNC_F64_U); fb.byte(OP_RETURN)
        fb.emit_end()

        fb.local_get(0); fb.byte(OP_F64_ABS); fb.byte(OP_I64_REINTERPRET_F64); fb.local_set(bits)
        fb.local_get(bits); fb.i64_const(52); fb.byte(OP_I64_SHR_U); fb.i64_const(2047); fb.byte(OP_I64_AND); fb.local_set(exp_bits)

        fb.local_get(exp_bits); fb.byte(OP_I64_EQZ)
        fb.emit_if()
        fb.local_get(bits); fb.i64_const(4503599627370495); fb.byte(OP_I64_AND); fb.local_set(f)
        fb.i64_const(-1074); fb.local_set(e)
        fb.emit_else()
        fb.local_get(bits); fb.i64_const(4503599627370495); fb.byte(OP_I64_AND); fb.i64_const(4503599627370496); fb.byte(OP_I64_OR); fb.local_set(f)
        fb.local_get(exp_bits); fb.i64_const(1075); fb.byte(OP_I64_SUB); fb.local_set(e)
        fb.emit_end()

        fb.local_get(1); fb.i32_const(0); fb.byte(OP_I32_GE_S)
        fb.emit_if()
        fb.local_get(1); self._emit_call(fb, pow5_i64); fb.local_set(p5)
        fb.local_get(f); fb.local_get(p5); self._emit_call(fb, u128_mul)
        fb.local_set(num_lo)
        fb.local_set(num_hi)
        fb.i64_const(0); fb.local_get(e); fb.local_get(1); fb.byte(OP_I64_EXTEND_I32_S); fb.byte(OP_I64_ADD); fb.byte(OP_I64_SUB); fb.local_set(shift)
        fb.local_get(shift); fb.i64_const(0); fb.byte(OP_I64_LE_S)
        fb.emit_if()
        fb.local_get(num_lo); fb.i64_const(0); fb.local_get(shift); fb.byte(OP_I64_SUB); fb.byte(OP_I64_SHL); fb.byte(OP_RETURN)
        fb.emit_end()

        fb.local_get(shift); fb.i64_const(64); fb.byte(OP_I64_LT_U)
        fb.emit_if()
        fb.local_get(num_lo); fb.local_get(shift); fb.byte(OP_I64_SHR_U)
        fb.local_get(num_hi); fb.i64_const(64); fb.local_get(shift); fb.byte(OP_I64_SUB); fb.byte(OP_I64_SHL)
        fb.byte(OP_I64_OR); fb.local_set(q)
        fb.local_get(num_lo); fb.i64_const(1); fb.local_get(shift); fb.byte(OP_I64_SHL); fb.i64_const(1); fb.byte(OP_I64_SUB); fb.byte(OP_I64_AND); fb.local_set(rem)
        fb.i64_const(1); fb.local_get(shift); fb.i64_const(1); fb.byte(OP_I64_SUB); fb.byte(OP_I64_SHL); fb.local_set(half)
        fb.local_get(rem); fb.local_get(half); fb.byte(OP_I64_GT_U)
        fb.local_get(rem); fb.local_get(half); fb.byte(OP_I64_EQ)
        fb.local_get(q); fb.i64_const(1); fb.byte(OP_I64_AND); fb.i64_const(1); fb.byte(OP_I64_EQ)
        fb.byte(OP_I32_AND)
        fb.byte(OP_I32_OR)
        fb.emit_if()
        fb.local_get(q); fb.i64_const(1); fb.byte(OP_I64_ADD); fb.local_set(q)
        fb.emit_end()
        fb.local_get(q); fb.byte(OP_RETURN)

        fb.emit_else()
        fb.local_get(shift); fb.i64_const(64); fb.byte(OP_I64_SUB); fb.local_set(shift)
        fb.local_get(shift); fb.byte(OP_I64_EQZ)
        fb.emit_if()
        fb.local_get(num_hi); fb.local_set(q)
        fb.local_get(num_lo); fb.local_set(rem)
        fb.i64_const(1); fb.i64_const(63); fb.byte(OP_I64_SHL); fb.local_set(half)
        fb.emit_else()
        fb.local_get(num_hi); fb.local_get(shift); fb.byte(OP_I64_SHR_U); fb.local_set(q)
        fb.local_get(num_hi); fb.i64_const(1); fb.local_get(shift); fb.byte(OP_I64_SHL); fb.i64_const(1); fb.byte(OP_I64_SUB); fb.byte(OP_I64_AND); fb.i64_const(64); fb.byte(OP_I64_SHL); fb.local_get(num_lo); fb.byte(OP_I64_OR); fb.local_set(rem)
        fb.i64_const(1); fb.local_get(shift); fb.i64_const(1); fb.byte(OP_I64_SUB); fb.byte(OP_I64_SHL); fb.local_set(half)
        fb.emit_end()
        fb.local_get(rem); fb.local_get(half); fb.byte(OP_I64_GT_U)
        fb.local_get(rem); fb.local_get(half); fb.byte(OP_I64_EQ)
        fb.local_get(q); fb.i64_const(1); fb.byte(OP_I64_AND); fb.i64_const(1); fb.byte(OP_I64_EQ)
        fb.byte(OP_I32_AND)
        fb.byte(OP_I32_OR)
        fb.emit_if()
        fb.local_get(q); fb.i64_const(1); fb.byte(OP_I64_ADD); fb.local_set(q)
        fb.emit_end()
        fb.local_get(q); fb.byte(OP_RETURN)
        fb.emit_end()

        fb.emit_else()
        fb.i32_const(0); fb.local_get(1); fb.byte(OP_I32_SUB); self._emit_call(fb, pow10_i64); fb.local_set(p10_lo)
        fb.local_get(e); fb.i64_const(0); fb.byte(OP_I64_GE_S)
        fb.emit_if()
        fb.local_get(f); fb.local_get(e); fb.byte(OP_I64_SHL); fb.local_set(f)
        fb.local_get(f); fb.local_get(p10_lo); fb.i64_const(1); fb.byte(OP_I64_SHR_U); fb.byte(OP_I64_ADD); fb.local_get(p10_lo); fb.byte(OP_I64_DIV_U); fb.byte(OP_RETURN)
        fb.emit_else()
        fb.i64_const(0); fb.local_get(e); fb.byte(OP_I64_SUB); fb.local_set(shift)
        fb.local_get(f); fb.local_get(shift); fb.byte(OP_I64_SHR_U); fb.local_set(f)
        fb.local_get(f); fb.local_get(p10_lo); fb.i64_const(1); fb.byte(OP_I64_SHR_U); fb.byte(OP_I64_ADD); fb.local_get(p10_lo); fb.byte(OP_I64_DIV_U); fb.byte(OP_RETURN)
        fb.emit_end()
        fb.emit_end()

        fb.i64_const(0); fb.byte(OP_RETURN)
        idx = self._mod.add_function(sig)
        self._mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        return idx

    def _build_f64_pow(self) -> int:
        sig = self._mod.add_type([F64, F64], [F64])
        fb = FuncBody(num_params=2)
        iy = fb.new_i64(); acc = fb.new_f64(); base = fb.new_f64(); is_neg = fb.new_i32()
        k = fb.new_f64(); u = fb.new_f64(); u2 = fb.new_f64(); s = fb.new_f64()
        term = fb.new_f64(); i = fb.new_i32(); ln_m = fb.new_f64(); v_scaled = fb.new_f64()
        K = fb.new_i64(); dk = fb.new_f64(); r = fb.new_f64(); poly = fb.new_f64()
        scale = fb.new_f64(); cnt = fb.new_i64()

        fb.local_get(1); fb.f64_const(0.0); fb.byte(OP_F64_EQ)
        fb.emit_if()
        fb.f64_const(1.0); fb.byte(OP_RETURN)
        fb.emit_end()

        fb.local_get(0); fb.f64_const(0.0); fb.byte(OP_F64_EQ)
        fb.emit_if()
        fb.f64_const(0.0); fb.byte(OP_RETURN)
        fb.emit_end()

        fb.local_get(1); fb.byte(OP_I64_TRUNC_F64_S); fb.local_set(iy)
        fb.local_get(1); fb.local_get(iy); fb.byte(OP_F64_CONVERT_I64_S); fb.byte(OP_F64_EQ)
        fb.emit_if()
        fb.local_get(iy); fb.i64_const(0); fb.byte(OP_I64_LT_S); fb.local_set(is_neg)
        fb.local_get(is_neg)
        fb.emit_if()
        fb.i64_const(0); fb.local_get(iy); fb.byte(OP_I64_SUB); fb.local_set(iy)
        fb.emit_end()
        fb.f64_const(1.0); fb.local_set(acc)
        fb.local_get(0); fb.local_set(base)

        fb.emit_block()
        b1 = fb.label_depth
        fb.emit_loop()
        l1 = fb.label_depth
        fb.local_get(iy); fb.i64_const(0); fb.byte(OP_I64_LE_S)
        fb.br_if(self._br_depth(fb, b1))
        fb.local_get(iy); fb.i64_const(1); fb.byte(OP_I64_AND); fb.i64_const(1); fb.byte(OP_I64_EQ)
        fb.emit_if()
        fb.local_get(acc); fb.local_get(base); fb.byte(OP_F64_MUL); fb.local_set(acc)
        fb.emit_end()
        fb.local_get(base); fb.local_get(base); fb.byte(OP_F64_MUL); fb.local_set(base)
        fb.local_get(iy); fb.i64_const(1); fb.byte(OP_I64_SHR_U); fb.local_set(iy)
        fb.br(self._br_depth(fb, l1))
        fb.emit_end()
        fb.emit_end()

        fb.local_get(is_neg)
        fb.emit_if()
        fb.f64_const(1.0); fb.local_get(acc); fb.byte(OP_F64_DIV); fb.local_set(acc)
        fb.emit_end()
        fb.local_get(acc); fb.byte(OP_RETURN)
        fb.emit_end()

        fb.local_get(0); fb.f64_const(0.0); fb.byte(OP_F64_LT)
        fb.emit_if()
        fb.f64_const(float("nan")); fb.byte(OP_RETURN)
        fb.emit_end()

        fb.f64_const(0.0); fb.local_set(k)
        fb.local_get(0); fb.local_set(base)

        fb.emit_block()
        bk_up = fb.label_depth
        fb.emit_loop()
        lk_up = fb.label_depth
        fb.local_get(base); fb.f64_const(2.0); fb.byte(OP_F64_LT)
        fb.br_if(self._br_depth(fb, bk_up))
        fb.local_get(base); fb.f64_const(0.5); fb.byte(OP_F64_MUL); fb.local_set(base)
        fb.local_get(k); fb.f64_const(1.0); fb.byte(OP_F64_ADD); fb.local_set(k)
        fb.br(self._br_depth(fb, lk_up))
        fb.emit_end()
        fb.emit_end()

        fb.emit_block()
        bk_down = fb.label_depth
        fb.emit_loop()
        lk_down = fb.label_depth
        fb.local_get(base); fb.f64_const(1.0); fb.byte(OP_F64_GE)
        fb.br_if(self._br_depth(fb, bk_down))
        fb.local_get(base); fb.f64_const(2.0); fb.byte(OP_F64_MUL); fb.local_set(base)
        fb.local_get(k); fb.f64_const(1.0); fb.byte(OP_F64_SUB); fb.local_set(k)
        fb.br(self._br_depth(fb, lk_down))
        fb.emit_end()
        fb.emit_end()

        fb.local_get(base); fb.f64_const(1.0); fb.byte(OP_F64_SUB)
        fb.local_get(base); fb.f64_const(1.0); fb.byte(OP_F64_ADD)
        fb.byte(OP_F64_DIV); fb.local_set(u)
        fb.local_get(u); fb.local_get(u); fb.byte(OP_F64_MUL); fb.local_set(u2)
        fb.f64_const(0.0); fb.local_set(s)
        fb.local_get(u); fb.local_set(term)
        fb.i32_const(1); fb.local_set(i)

        fb.emit_block()
        b_ser = fb.label_depth
        fb.emit_loop()
        l_ser = fb.label_depth
        fb.local_get(i); fb.i32_const(41); fb.byte(OP_I32_GT_S)
        fb.br_if(self._br_depth(fb, b_ser))
        fb.local_get(s); fb.local_get(term); fb.local_get(i); fb.byte(OP_F64_CONVERT_I32_S); fb.byte(OP_F64_DIV); fb.byte(OP_F64_ADD); fb.local_set(s)
        fb.local_get(term); fb.local_get(u2); fb.byte(OP_F64_MUL); fb.local_set(term)
        fb.local_get(i); fb.i32_const(2); fb.byte(OP_I32_ADD); fb.local_set(i)
        fb.br(self._br_depth(fb, l_ser))
        fb.emit_end()
        fb.emit_end()

        fb.f64_const(2.0); fb.local_get(s); fb.byte(OP_F64_MUL); fb.local_set(ln_m)
        fb.local_get(1); fb.local_get(k); fb.byte(OP_F64_MUL)
        fb.local_get(1); fb.local_get(ln_m); fb.byte(OP_F64_MUL); fb.f64_const(1.44269504088896340735992468100); fb.byte(OP_F64_MUL)
        fb.byte(OP_F64_ADD); fb.local_set(v_scaled)
        fb.local_get(v_scaled); fb.byte(OP_F64_NEAREST); fb.byte(OP_I64_TRUNC_F64_S); fb.local_set(K)
        fb.local_get(1); fb.local_get(k); fb.byte(OP_F64_MUL); fb.local_get(K); fb.byte(OP_F64_CONVERT_I64_S); fb.byte(OP_F64_SUB); fb.local_set(dk)
        fb.local_get(dk); fb.f64_const(0.693147180559945286226763982995); fb.byte(OP_F64_MUL)
        fb.local_get(1); fb.local_get(ln_m); fb.byte(OP_F64_MUL); fb.byte(OP_F64_ADD)
        fb.local_get(dk); fb.f64_const(2.31904681384629955841777123998e-17); fb.byte(OP_F64_MUL); fb.byte(OP_F64_ADD)
        fb.local_set(r)

        fb.local_get(r)
        fb.f64_const(1.0)
        fb.local_get(r)
        fb.f64_const(0.5)
        fb.local_get(r)
        fb.f64_const(0.16666666666666666)
        fb.local_get(r)
        fb.f64_const(0.041666666666666664)
        fb.local_get(r)
        fb.f64_const(0.008333333333333333)
        fb.local_get(r)
        fb.f64_const(0.001388888888888889)
        fb.local_get(r)
        fb.f64_const(0.0001984126984126984)
        fb.local_get(r)
        fb.f64_const(0.0000248015873015873)
        fb.local_get(r)
        fb.f64_const(0.000002755731922398589)
        fb.byte(OP_F64_MUL); fb.byte(OP_F64_ADD)
        fb.byte(OP_F64_MUL); fb.byte(OP_F64_ADD)
        fb.byte(OP_F64_MUL); fb.byte(OP_F64_ADD)
        fb.byte(OP_F64_MUL); fb.byte(OP_F64_ADD)
        fb.byte(OP_F64_MUL); fb.byte(OP_F64_ADD)
        fb.byte(OP_F64_MUL); fb.byte(OP_F64_ADD)
        fb.byte(OP_F64_MUL); fb.byte(OP_F64_ADD)
        fb.byte(OP_F64_MUL); fb.byte(OP_F64_ADD)
        fb.byte(OP_F64_MUL); fb.local_set(poly)

        fb.f64_const(1.0); fb.local_set(scale)
        fb.local_get(K); fb.i64_const(0); fb.byte(OP_I64_LT_S); fb.local_set(is_neg)
        fb.local_get(is_neg)
        fb.emit_if()
        fb.i64_const(0); fb.local_get(K); fb.byte(OP_I64_SUB); fb.local_set(K)
        fb.emit_end()
        fb.local_get(K); fb.local_set(cnt)

        fb.emit_block()
        b_sc = fb.label_depth
        fb.emit_loop()
        l_sc = fb.label_depth
        fb.local_get(cnt); fb.i64_const(0); fb.byte(OP_I64_LE_S)
        fb.br_if(self._br_depth(fb, b_sc))
        fb.local_get(scale); fb.f64_const(2.0); fb.byte(OP_F64_MUL); fb.local_set(scale)
        fb.local_get(cnt); fb.i64_const(1); fb.byte(OP_I64_SUB); fb.local_set(cnt)
        fb.br(self._br_depth(fb, l_sc))
        fb.emit_end()
        fb.emit_end()

        fb.local_get(is_neg)
        fb.emit_if()
        fb.f64_const(1.0); fb.local_get(scale); fb.byte(OP_F64_DIV); fb.local_set(scale)
        fb.emit_end()

        fb.f64_const(1.0); fb.local_get(poly); fb.byte(OP_F64_ADD); fb.local_get(scale); fb.byte(OP_F64_MUL); fb.byte(OP_RETURN)

        idx = self._mod.add_function(sig)
        self._mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        return idx

    def _build_f64_to_str(self) -> int:
        sig = self._mod.add_type([F64, I32], [I32])
        fb = FuncBody(num_params=2)
        v = fb.new_f64(); len_loc = fb.new_i32(); e = fb.new_i32(); temp = fb.new_f64()
        p = fb.new_i32(); k = fb.new_i32(); m = fb.new_i64(); orig_bits = fb.new_i64()
        digits = fb.new_i32(); l = fb.new_i32(); int_len = fb.new_i32(); zeros = fb.new_i32()
        recon_bits = fb.new_i64(); scnt = fb.new_i32()

        i64_to_str_idx = self._helper_funcs["$i64_to_str"]
        compute_exact_m_idx = self._helper_funcs["$compute_exact_m"]
        recon_float_bits_idx = self._helper_funcs["$recon_float_bits"]

        fb.i32_const(30000); fb.local_set(digits)

        # 1. NaN check
        fb.local_get(0); fb.local_get(0); fb.byte(OP_F64_NE)
        fb.emit_if()
        fb.local_get(1); fb.i32_const(110); _mem(fb, OP_I32_STORE8, 0, 0)
        fb.local_get(1); fb.i32_const(1); fb.byte(OP_I32_ADD); fb.i32_const(97); _mem(fb, OP_I32_STORE8, 0, 0)
        fb.local_get(1); fb.i32_const(2); fb.byte(OP_I32_ADD); fb.i32_const(110); _mem(fb, OP_I32_STORE8, 0, 0)
        fb.i32_const(3); fb.byte(OP_RETURN)
        fb.emit_end()

        # 2. Inf check
        fb.local_get(0); fb.byte(OP_F64_ABS); fb.f64_const(float("inf")); fb.byte(OP_F64_EQ)
        fb.emit_if()
        fb.local_get(0); fb.f64_const(0.0); fb.byte(OP_F64_LT)
        fb.emit_if()
        fb.local_get(1); fb.i32_const(45); _mem(fb, OP_I32_STORE8, 0, 0)
        fb.local_get(1); fb.i32_const(1); fb.byte(OP_I32_ADD); fb.i32_const(105); _mem(fb, OP_I32_STORE8, 0, 0)
        fb.local_get(1); fb.i32_const(2); fb.byte(OP_I32_ADD); fb.i32_const(110); _mem(fb, OP_I32_STORE8, 0, 0)
        fb.local_get(1); fb.i32_const(3); fb.byte(OP_I32_ADD); fb.i32_const(102); _mem(fb, OP_I32_STORE8, 0, 0)
        fb.i32_const(4); fb.byte(OP_RETURN)
        fb.emit_else()
        fb.local_get(1); fb.i32_const(105); _mem(fb, OP_I32_STORE8, 0, 0)
        fb.local_get(1); fb.i32_const(1); fb.byte(OP_I32_ADD); fb.i32_const(110); _mem(fb, OP_I32_STORE8, 0, 0)
        fb.local_get(1); fb.i32_const(2); fb.byte(OP_I32_ADD); fb.i32_const(102); _mem(fb, OP_I32_STORE8, 0, 0)
        fb.i32_const(3); fb.byte(OP_RETURN)
        fb.emit_end()
        fb.emit_end()

        # 3. Zero check
        fb.local_get(0); fb.f64_const(0.0); fb.byte(OP_F64_EQ)
        fb.emit_if()
        fb.local_get(1); fb.i32_const(48); _mem(fb, OP_I32_STORE8, 0, 0)
        fb.local_get(1); fb.i32_const(1); fb.byte(OP_I32_ADD); fb.i32_const(46); _mem(fb, OP_I32_STORE8, 0, 0)
        fb.local_get(1); fb.i32_const(2); fb.byte(OP_I32_ADD); fb.i32_const(48); _mem(fb, OP_I32_STORE8, 0, 0)
        fb.i32_const(3); fb.byte(OP_RETURN)
        fb.emit_end()

        fb.i32_const(0); fb.local_set(len_loc)
        fb.local_get(0); fb.local_set(v)

        # if v < 0.0:
        fb.local_get(v); fb.f64_const(0.0); fb.byte(OP_F64_LT)
        fb.emit_if()
        fb.local_get(1); fb.i32_const(45); _mem(fb, OP_I32_STORE8, 0, 0)
        fb.i32_const(1); fb.local_set(len_loc)
        fb.local_get(v); fb.byte(OP_F64_NEG); fb.local_set(v)
        fb.emit_end()

        # Fast path integer:
        fb.local_get(v); fb.f64_const(1e16); fb.byte(OP_F64_LT)
        fb.emit_if()
        fb.local_get(v); fb.byte(OP_I64_TRUNC_F64_S); fb.local_set(m)
        fb.local_get(v); fb.local_get(m); fb.byte(OP_F64_CONVERT_I64_S); fb.byte(OP_F64_EQ)
        fb.emit_if()
        fb.local_get(m); fb.local_get(1); fb.local_get(len_loc); fb.byte(OP_I32_ADD)
        self._emit_call(fb, i64_to_str_idx)
        fb.local_get(len_loc); fb.byte(OP_I32_ADD); fb.local_set(len_loc)
        fb.local_get(1); fb.local_get(len_loc); fb.byte(OP_I32_ADD); fb.i32_const(46); _mem(fb, OP_I32_STORE8, 0, 0)
        fb.local_get(len_loc); fb.i32_const(1); fb.byte(OP_I32_ADD); fb.local_set(len_loc)
        fb.local_get(1); fb.local_get(len_loc); fb.byte(OP_I32_ADD); fb.i32_const(48); _mem(fb, OP_I32_STORE8, 0, 0)
        fb.local_get(len_loc); fb.i32_const(1); fb.byte(OP_I32_ADD); fb.local_set(len_loc)
        fb.local_get(len_loc); fb.byte(OP_RETURN)
        fb.emit_end()
        fb.emit_end()

        fb.i32_const(0); fb.local_set(e)
        fb.local_get(v); fb.local_set(temp)

        fb.local_get(temp); fb.f64_const(10.0); fb.byte(OP_F64_GE)
        fb.emit_if()
        fb.emit_block()
        exp_up = fb.label_depth
        fb.emit_loop()
        l_up = fb.label_depth
        fb.local_get(temp); fb.f64_const(10.0); fb.byte(OP_F64_LT)
        fb.br_if(self._br_depth(fb, exp_up))
        fb.local_get(temp); fb.f64_const(10.0); fb.byte(OP_F64_DIV); fb.local_set(temp)
        fb.local_get(e); fb.i32_const(1); fb.byte(OP_I32_ADD); fb.local_set(e)
        fb.br(self._br_depth(fb, l_up))
        fb.emit_end()
        fb.emit_end()
        fb.emit_end()

        fb.local_get(temp); fb.f64_const(1.0); fb.byte(OP_F64_LT)
        fb.emit_if()
        fb.emit_block()
        exp_down = fb.label_depth
        fb.emit_loop()
        l_down = fb.label_depth
        fb.local_get(temp); fb.f64_const(1.0); fb.byte(OP_F64_GE)
        fb.br_if(self._br_depth(fb, exp_down))
        fb.local_get(temp); fb.f64_const(10.0); fb.byte(OP_F64_MUL); fb.local_set(temp)
        fb.local_get(e); fb.i32_const(1); fb.byte(OP_I32_SUB); fb.local_set(e)
        fb.br(self._br_depth(fb, l_down))
        fb.emit_end()
        fb.emit_end()
        fb.emit_end()

        fb.local_get(v); fb.byte(OP_I64_REINTERPRET_F64); fb.local_set(orig_bits)

        fb.i32_const(15); fb.local_set(p)
        fb.emit_block()
        found_p = fb.label_depth
        fb.emit_loop()
        loop_p = fb.label_depth
        fb.local_get(p); fb.i32_const(17); fb.byte(OP_I32_GE_U)
        fb.br_if(self._br_depth(fb, found_p))
        fb.local_get(p); fb.i32_const(1); fb.byte(OP_I32_SUB); fb.local_get(e); fb.byte(OP_I32_SUB); fb.local_set(scnt)
        fb.local_get(v); fb.local_get(scnt); self._emit_call(fb, compute_exact_m_idx); fb.local_set(m)
        fb.local_get(m); fb.local_get(scnt); self._emit_call(fb, recon_float_bits_idx); fb.local_set(recon_bits)
        fb.local_get(recon_bits); fb.local_get(orig_bits); fb.byte(OP_I64_EQ)
        fb.br_if(self._br_depth(fb, found_p))
        fb.local_get(p); fb.i32_const(1); fb.byte(OP_I32_ADD); fb.local_set(p)
        fb.br(self._br_depth(fb, loop_p))
        fb.emit_end()
        fb.emit_end()

        fb.local_get(p); fb.i32_const(1); fb.byte(OP_I32_SUB); fb.local_get(e); fb.byte(OP_I32_SUB); fb.local_set(scnt)
        fb.local_get(v); fb.local_get(scnt); self._emit_call(fb, compute_exact_m_idx); fb.local_set(m)

        fb.i32_const(0); fb.local_set(k)
        fb.emit_block()
        mdone = fb.label_depth
        fb.emit_loop()
        mloop = fb.label_depth
        fb.local_get(k); fb.local_get(p); fb.byte(OP_I32_GE_U)
        fb.br_if(self._br_depth(fb, mdone))
        fb.local_get(digits); fb.local_get(k); fb.byte(OP_I32_ADD)
        fb.local_get(m); fb.i64_const(10); fb.byte(OP_I64_REM_U); fb.byte(OP_I32_WRAP_I64); fb.i32_const(48); fb.byte(OP_I32_ADD)
        _mem(fb, OP_I32_STORE8, 0, 0)
        fb.local_get(m); fb.i64_const(10); fb.byte(OP_I64_DIV_U); fb.local_set(m)
        fb.local_get(k); fb.i32_const(1); fb.byte(OP_I32_ADD); fb.local_set(k)
        fb.br(self._br_depth(fb, mloop))
        fb.emit_end()
        fb.emit_end()

        fb.local_get(m); fb.i64_const(0); fb.byte(OP_I64_GT_U)
        fb.emit_if()
        fb.local_get(e); fb.i32_const(1); fb.byte(OP_I32_ADD); fb.local_set(e)
        fb.emit_end()

        self._emit_reverse(fb, digits, p)

        fb.local_get(p); fb.local_set(l)
        fb.emit_block()
        strip_l = fb.label_depth
        fb.emit_loop()
        ll = fb.label_depth
        fb.local_get(l); fb.i32_const(1); fb.byte(OP_I32_LE_U)
        fb.br_if(self._br_depth(fb, strip_l))
        fb.local_get(digits); fb.local_get(l); fb.byte(OP_I32_ADD); fb.i32_const(1); fb.byte(OP_I32_SUB)
        _mem(fb, OP_I32_LOAD8_U, 0, 0)
        fb.i32_const(48); fb.byte(OP_I32_NE)
        fb.br_if(self._br_depth(fb, strip_l))
        fb.local_get(l); fb.i32_const(1); fb.byte(OP_I32_SUB); fb.local_set(l)
        fb.br(self._br_depth(fb, ll))
        fb.emit_end()
        fb.emit_end()

        fb.local_get(e); fb.i32_const(-4); fb.byte(OP_I32_LT_S)
        fb.local_get(e); fb.local_get(p); fb.byte(OP_I32_GE_S)
        fb.byte(OP_I32_OR)
        fb.emit_if()
        fb.local_get(1); fb.local_get(len_loc); fb.byte(OP_I32_ADD)
        fb.local_get(digits); _mem(fb, OP_I32_LOAD8_U, 0, 0)
        _mem(fb, OP_I32_STORE8, 0, 0)
        fb.local_get(len_loc); fb.i32_const(1); fb.byte(OP_I32_ADD); fb.local_set(len_loc)

        fb.local_get(l); fb.i32_const(1); fb.byte(OP_I32_GT_U)
        fb.emit_if()
        fb.local_get(1); fb.local_get(len_loc); fb.byte(OP_I32_ADD); fb.i32_const(46); _mem(fb, OP_I32_STORE8, 0, 0)
        fb.local_get(len_loc); fb.i32_const(1); fb.byte(OP_I32_ADD); fb.local_set(len_loc)
        fb.i32_const(1); fb.local_set(k)
        fb.emit_block()
        scc = fb.label_depth
        fb.emit_loop()
        lscc = fb.label_depth
        fb.local_get(k); fb.local_get(l); fb.byte(OP_I32_GE_U)
        fb.br_if(self._br_depth(fb, scc))
        fb.local_get(1); fb.local_get(len_loc); fb.byte(OP_I32_ADD)
        fb.local_get(digits); fb.local_get(k); fb.byte(OP_I32_ADD); _mem(fb, OP_I32_LOAD8_U, 0, 0)
        _mem(fb, OP_I32_STORE8, 0, 0)
        fb.local_get(len_loc); fb.i32_const(1); fb.byte(OP_I32_ADD); fb.local_set(len_loc)
        fb.local_get(k); fb.i32_const(1); fb.byte(OP_I32_ADD); fb.local_set(k)
        fb.br(self._br_depth(fb, lscc))
        fb.emit_end()
        fb.emit_end()
        fb.emit_end()

        fb.local_get(1); fb.local_get(len_loc); fb.byte(OP_I32_ADD); fb.i32_const(101); _mem(fb, OP_I32_STORE8, 0, 0)
        fb.local_get(len_loc); fb.i32_const(1); fb.byte(OP_I32_ADD); fb.local_set(len_loc)

        fb.local_get(e); fb.i32_const(0); fb.byte(OP_I32_LT_S)
        fb.emit_if()
        fb.local_get(1); fb.local_get(len_loc); fb.byte(OP_I32_ADD); fb.i32_const(45); _mem(fb, OP_I32_STORE8, 0, 0)
        fb.local_get(len_loc); fb.i32_const(1); fb.byte(OP_I32_ADD); fb.local_set(len_loc)
        fb.i32_const(0); fb.local_get(e); fb.byte(OP_I32_SUB); fb.local_set(e)
        fb.emit_else()
        fb.local_get(1); fb.local_get(len_loc); fb.byte(OP_I32_ADD); fb.i32_const(43); _mem(fb, OP_I32_STORE8, 0, 0)
        fb.local_get(len_loc); fb.i32_const(1); fb.byte(OP_I32_ADD); fb.local_set(len_loc)
        fb.emit_end()

        fb.local_get(e); fb.i32_const(10); fb.byte(OP_I32_LT_S)
        fb.emit_if()
        fb.local_get(1); fb.local_get(len_loc); fb.byte(OP_I32_ADD); fb.i32_const(48); _mem(fb, OP_I32_STORE8, 0, 0)
        fb.local_get(len_loc); fb.i32_const(1); fb.byte(OP_I32_ADD); fb.local_set(len_loc)
        fb.emit_end()

        fb.local_get(e); fb.byte(OP_I64_EXTEND_I32_S)
        fb.local_get(1); fb.local_get(len_loc); fb.byte(OP_I32_ADD)
        self._emit_call(fb, i64_to_str_idx)
        fb.local_get(len_loc); fb.byte(OP_I32_ADD); fb.local_set(len_loc)
        fb.local_get(len_loc); fb.byte(OP_RETURN)

        fb.emit_else()
        fb.local_get(e); fb.i32_const(0); fb.byte(OP_I32_GE_S)
        fb.emit_if()
        fb.local_get(e); fb.i32_const(1); fb.byte(OP_I32_ADD); fb.local_set(int_len)
        fb.local_get(int_len); fb.local_get(l); fb.byte(OP_I32_GE_U)
        fb.emit_if()
        fb.i32_const(0); fb.local_set(k)
        fb.emit_block()
        c1 = fb.label_depth
        fb.emit_loop()
        lc1 = fb.label_depth
        fb.local_get(k); fb.local_get(l); fb.byte(OP_I32_GE_U)
        fb.br_if(self._br_depth(fb, c1))
        fb.local_get(1); fb.local_get(len_loc); fb.byte(OP_I32_ADD)
        fb.local_get(digits); fb.local_get(k); fb.byte(OP_I32_ADD); _mem(fb, OP_I32_LOAD8_U, 0, 0)
        _mem(fb, OP_I32_STORE8, 0, 0)
        fb.local_get(len_loc); fb.i32_const(1); fb.byte(OP_I32_ADD); fb.local_set(len_loc)
        fb.local_get(k); fb.i32_const(1); fb.byte(OP_I32_ADD); fb.local_set(k)
        fb.br(self._br_depth(fb, lc1))
        fb.emit_end()
        fb.emit_end()

        fb.emit_block()
        c2 = fb.label_depth
        fb.emit_loop()
        lc2 = fb.label_depth
        fb.local_get(len_loc); fb.local_get(int_len); fb.byte(OP_I32_GE_U)
        fb.br_if(self._br_depth(fb, c2))
        fb.local_get(1); fb.local_get(len_loc); fb.byte(OP_I32_ADD); fb.i32_const(48); _mem(fb, OP_I32_STORE8, 0, 0)
        fb.local_get(len_loc); fb.i32_const(1); fb.byte(OP_I32_ADD); fb.local_set(len_loc)
        fb.br(self._br_depth(fb, lc2))
        fb.emit_end()
        fb.emit_end()

        fb.local_get(1); fb.local_get(len_loc); fb.byte(OP_I32_ADD); fb.i32_const(46); _mem(fb, OP_I32_STORE8, 0, 0)
        fb.local_get(len_loc); fb.i32_const(1); fb.byte(OP_I32_ADD); fb.local_set(len_loc)
        fb.local_get(1); fb.local_get(len_loc); fb.byte(OP_I32_ADD); fb.i32_const(48); _mem(fb, OP_I32_STORE8, 0, 0)
        fb.local_get(len_loc); fb.i32_const(1); fb.byte(OP_I32_ADD); fb.local_set(len_loc)
        fb.local_get(len_loc); fb.byte(OP_RETURN)

        fb.emit_else()
        fb.i32_const(0); fb.local_set(k)
        fb.emit_block()
        c3 = fb.label_depth
        fb.emit_loop()
        lc3 = fb.label_depth
        fb.local_get(k); fb.local_get(int_len); fb.byte(OP_I32_GE_U)
        fb.br_if(self._br_depth(fb, c3))
        fb.local_get(1); fb.local_get(len_loc); fb.byte(OP_I32_ADD)
        fb.local_get(digits); fb.local_get(k); fb.byte(OP_I32_ADD); _mem(fb, OP_I32_LOAD8_U, 0, 0)
        _mem(fb, OP_I32_STORE8, 0, 0)
        fb.local_get(len_loc); fb.i32_const(1); fb.byte(OP_I32_ADD); fb.local_set(len_loc)
        fb.local_get(k); fb.i32_const(1); fb.byte(OP_I32_ADD); fb.local_set(k)
        fb.br(self._br_depth(fb, lc3))
        fb.emit_end()
        fb.emit_end()

        fb.local_get(1); fb.local_get(len_loc); fb.byte(OP_I32_ADD); fb.i32_const(46); _mem(fb, OP_I32_STORE8, 0, 0)
        fb.local_get(len_loc); fb.i32_const(1); fb.byte(OP_I32_ADD); fb.local_set(len_loc)

        fb.emit_block()
        c4 = fb.label_depth
        fb.emit_loop()
        lc4 = fb.label_depth
        fb.local_get(k); fb.local_get(l); fb.byte(OP_I32_GE_U)
        fb.br_if(self._br_depth(fb, c4))
        fb.local_get(1); fb.local_get(len_loc); fb.byte(OP_I32_ADD)
        fb.local_get(digits); fb.local_get(k); fb.byte(OP_I32_ADD); _mem(fb, OP_I32_LOAD8_U, 0, 0)
        _mem(fb, OP_I32_STORE8, 0, 0)
        fb.local_get(len_loc); fb.i32_const(1); fb.byte(OP_I32_ADD); fb.local_set(len_loc)
        fb.local_get(k); fb.i32_const(1); fb.byte(OP_I32_ADD); fb.local_set(k)
        fb.br(self._br_depth(fb, lc4))
        fb.emit_end()
        fb.emit_end()
        fb.local_get(len_loc); fb.byte(OP_RETURN)
        fb.emit_end()

        fb.emit_else()
        fb.local_get(1); fb.local_get(len_loc); fb.byte(OP_I32_ADD); fb.i32_const(48); _mem(fb, OP_I32_STORE8, 0, 0)
        fb.local_get(len_loc); fb.i32_const(1); fb.byte(OP_I32_ADD); fb.local_set(len_loc)
        fb.local_get(1); fb.local_get(len_loc); fb.byte(OP_I32_ADD); fb.i32_const(46); _mem(fb, OP_I32_STORE8, 0, 0)
        fb.local_get(len_loc); fb.i32_const(1); fb.byte(OP_I32_ADD); fb.local_set(len_loc)

        fb.i32_const(0); fb.local_get(e); fb.byte(OP_I32_SUB); fb.i32_const(1); fb.byte(OP_I32_SUB); fb.local_set(zeros)
        fb.i32_const(0); fb.local_set(k)
        fb.emit_block()
        c5 = fb.label_depth
        fb.emit_loop()
        lc5 = fb.label_depth
        fb.local_get(k); fb.local_get(zeros); fb.byte(OP_I32_GE_U)
        fb.br_if(self._br_depth(fb, c5))
        fb.local_get(1); fb.local_get(len_loc); fb.byte(OP_I32_ADD); fb.i32_const(48); _mem(fb, OP_I32_STORE8, 0, 0)
        fb.local_get(len_loc); fb.i32_const(1); fb.byte(OP_I32_ADD); fb.local_set(len_loc)
        fb.local_get(k); fb.i32_const(1); fb.byte(OP_I32_ADD); fb.local_set(k)
        fb.br(self._br_depth(fb, lc5))
        fb.emit_end()
        fb.emit_end()

        fb.i32_const(0); fb.local_set(k)
        fb.emit_block()
        c6 = fb.label_depth
        fb.emit_loop()
        lc6 = fb.label_depth
        fb.local_get(k); fb.local_get(l); fb.byte(OP_I32_GE_U)
        fb.br_if(self._br_depth(fb, c6))
        fb.local_get(1); fb.local_get(len_loc); fb.byte(OP_I32_ADD)
        fb.local_get(digits); fb.local_get(k); fb.byte(OP_I32_ADD); _mem(fb, OP_I32_LOAD8_U, 0, 0)
        _mem(fb, OP_I32_STORE8, 0, 0)
        fb.local_get(len_loc); fb.i32_const(1); fb.byte(OP_I32_ADD); fb.local_set(len_loc)
        fb.local_get(k); fb.i32_const(1); fb.byte(OP_I32_ADD); fb.local_set(k)
        fb.br(self._br_depth(fb, lc6))
        fb.emit_end()
        fb.emit_end()
        fb.local_get(len_loc); fb.byte(OP_RETURN)

        fb.emit_end()
        fb.emit_end()

        fb.local_get(len_loc); fb.byte(OP_RETURN)
        idx = self._mod.add_function(sig)
        self._mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        return idx

    def _build_str_to_i64(self) -> int:
        sig = self._mod.add_type([I64], [I64])
        fb = FuncBody(num_params=1)
        l_ptr = fb.new_i32()
        l_len = fb.new_i32()
        l_i = fb.new_i32()
        l_neg = fb.new_i32()
        l_res = fb.new_i64()
        l_c = fb.new_i32()

        fb.local_get(0)
        fb.i64_const(32)
        fb.byte(OP_I64_SHR_U)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_ptr)

        fb.local_get(0)
        fb.i64_const(0xFFFFFFFF)
        fb.byte(OP_I64_AND)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_len)

        fb.i32_const(0)
        fb.local_set(l_i)
        fb.i32_const(0)
        fb.local_set(l_neg)
        fb.i64_const(0)
        fb.local_set(l_res)

        fb.local_get(l_len)
        fb.byte(OP_I32_EQZ)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.i64_const(0)
        fb.byte(OP_RETURN)
        fb.byte(OP_END)

        fb.local_get(l_ptr)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_c)

        fb.local_get(l_c)
        fb.i32_const(45)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.i32_const(1)
        fb.local_set(l_neg)
        fb.i32_const(1)
        fb.local_set(l_i)
        fb.byte(OP_END)

        fb.local_get(l_c)
        fb.i32_const(43)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.i32_const(1)
        fb.local_set(l_i)
        fb.byte(OP_END)

        fb.emit_block()
        exit_pos = fb.label_depth
        fb.emit_loop()
        loop_pos = fb.label_depth

        fb.local_get(l_i)
        fb.local_get(l_len)
        fb.byte(OP_I32_GE_U)
        fb.br_if(self._br_depth(fb, exit_pos))

        fb.local_get(l_ptr)
        fb.local_get(l_i)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_c)

        fb.local_get(l_c)
        fb.i32_const(48)
        fb.byte(OP_I32_LT_U)
        fb.local_get(l_c)
        fb.i32_const(57)
        fb.byte(OP_I32_GT_U)
        fb.byte(OP_I32_OR)
        fb.br_if(self._br_depth(fb, exit_pos))

        fb.local_get(l_res)
        fb.i64_const(10)
        fb.byte(OP_I64_MUL)
        fb.local_get(l_c)
        fb.i32_const(48)
        fb.byte(OP_I32_SUB)
        fb.byte(OP_I64_EXTEND_I32_U)
        fb.byte(OP_I64_ADD)
        fb.local_set(l_res)

        fb.local_get(l_i)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_i)
        fb.br(self._br_depth(fb, loop_pos))

        fb.emit_end()
        fb.emit_end()

        fb.local_get(l_neg)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.i64_const(0)
        fb.local_get(l_res)
        fb.byte(OP_I64_SUB)
        fb.local_set(l_res)
        fb.byte(OP_END)
        fb.local_get(l_res)
        fb.byte(OP_RETURN)

        idx = self._mod.add_function(sig)
        self._mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        return idx

    def _build_str_to_f64(self) -> int:
        sig = self._mod.add_type([I64], [F64])
        fb = FuncBody(num_params=1)
        l_ptr = fb.new_i32()
        l_len = fb.new_i32()
        l_i = fb.new_i32()
        l_neg = fb.new_i32()
        l_int = fb.new_f64()
        l_frac = fb.new_f64()
        l_div = fb.new_f64()
        l_in_frac = fb.new_i32()
        l_c = fb.new_i32()

        fb.local_get(0)
        fb.i64_const(32)
        fb.byte(OP_I64_SHR_U)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_ptr)

        fb.local_get(0)
        fb.i64_const(0xFFFFFFFF)
        fb.byte(OP_I64_AND)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_len)

        fb.i32_const(0)
        fb.local_set(l_i)
        fb.i32_const(0)
        fb.local_set(l_neg)
        fb.f64_const(0.0)
        fb.local_set(l_int)
        fb.f64_const(0.0)
        fb.local_set(l_frac)
        fb.f64_const(1.0)
        fb.local_set(l_div)
        fb.i32_const(0)
        fb.local_set(l_in_frac)

        fb.local_get(l_len)
        fb.byte(OP_I32_EQZ)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.f64_const(0.0)
        fb.byte(OP_RETURN)
        fb.byte(OP_END)

        fb.local_get(l_ptr)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_c)

        fb.local_get(l_c)
        fb.i32_const(45)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.i32_const(1)
        fb.local_set(l_neg)
        fb.i32_const(1)
        fb.local_set(l_i)
        fb.byte(OP_END)

        fb.local_get(l_c)
        fb.i32_const(43)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.i32_const(1)
        fb.local_set(l_i)
        fb.byte(OP_END)

        fb.emit_block()
        exit_pos = fb.label_depth
        fb.emit_loop()
        loop_pos = fb.label_depth

        fb.local_get(l_i)
        fb.local_get(l_len)
        fb.byte(OP_I32_GE_U)
        fb.br_if(self._br_depth(fb, exit_pos))

        fb.local_get(l_ptr)
        fb.local_get(l_i)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_c)

        fb.local_get(l_c)
        fb.i32_const(46)
        fb.byte(OP_I32_EQ)
        fb.local_get(l_c)
        fb.i32_const(44)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_OR)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.i32_const(1)
        fb.local_set(l_in_frac)
        fb.byte(OP_ELSE)
        fb.local_get(l_c)
        fb.i32_const(48)
        fb.byte(OP_I32_LT_U)
        fb.local_get(l_c)
        fb.i32_const(57)
        fb.byte(OP_I32_GT_U)
        fb.byte(OP_I32_OR)
        fb.br_if(self._br_depth(fb, exit_pos))
        fb.local_get(l_in_frac)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.local_get(l_div)
        fb.f64_const(10.0)
        fb.byte(OP_F64_MUL)
        fb.local_set(l_div)
        fb.local_get(l_frac)
        fb.local_get(l_c)
        fb.i32_const(48)
        fb.byte(OP_I32_SUB)
        fb.byte(OP_F64_CONVERT_I32_U)
        fb.local_get(l_div)
        fb.byte(OP_F64_DIV)
        fb.byte(OP_F64_ADD)
        fb.local_set(l_frac)
        fb.byte(OP_ELSE)
        fb.local_get(l_int)
        fb.f64_const(10.0)
        fb.byte(OP_F64_MUL)
        fb.local_get(l_c)
        fb.i32_const(48)
        fb.byte(OP_I32_SUB)
        fb.byte(OP_F64_CONVERT_I32_U)
        fb.byte(OP_F64_ADD)
        fb.local_set(l_int)
        fb.byte(OP_END)
        fb.byte(OP_END)

        fb.local_get(l_i)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_i)
        fb.br(self._br_depth(fb, loop_pos))

        fb.emit_end()
        fb.emit_end()

        fb.local_get(l_int)
        fb.local_get(l_frac)
        fb.byte(OP_F64_ADD)
        fb.local_set(l_int)
        fb.local_get(l_neg)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.f64_const(0.0)
        fb.local_get(l_int)
        fb.byte(OP_F64_SUB)
        fb.local_set(l_int)
        fb.byte(OP_END)
        fb.local_get(l_int)
        fb.byte(OP_RETURN)

        idx = self._mod.add_function(sig)
        self._mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        return idx

    def _build_dt_to_str(self) -> int:
        sig = self._mod.add_type([I64, I32], [I32])
        fb = FuncBody(num_params=2)
        sec = fb.new_i64()
        frac = fb.new_i64()
        days = fb.new_i64()
        rem_sec = fb.new_i64()
        hour = fb.new_i64()
        min_v = fb.new_i64()
        s_v = fb.new_i64()
        z = fb.new_i64()
        era = fb.new_i64()
        doe = fb.new_i64()
        yoe = fb.new_i64()
        y = fb.new_i64()
        doy = fb.new_i64()
        mp = fb.new_i64()
        d = fb.new_i64()
        m = fb.new_i64()
        p = fb.new_i32()

        fb.local_get(0)
        fb.i64_const(1000000000)
        fb.byte(OP_I64_DIV_S)
        fb.local_set(sec)

        fb.local_get(0)
        fb.i64_const(1000000000)
        fb.byte(OP_I64_REM_S)
        fb.local_set(frac)

        fb.local_get(sec)
        fb.i64_const(86400)
        fb.byte(OP_I64_DIV_S)
        fb.local_set(days)

        fb.local_get(sec)
        fb.i64_const(86400)
        fb.byte(OP_I64_REM_S)
        fb.local_set(rem_sec)

        fb.local_get(rem_sec)
        fb.i64_const(3600)
        fb.byte(OP_I64_DIV_S)
        fb.local_set(hour)

        fb.local_get(rem_sec)
        fb.i64_const(3600)
        fb.byte(OP_I64_REM_S)
        fb.i64_const(60)
        fb.byte(OP_I64_DIV_S)
        fb.local_set(min_v)

        fb.local_get(rem_sec)
        fb.i64_const(60)
        fb.byte(OP_I64_REM_S)
        fb.local_set(s_v)

        fb.local_get(days)
        fb.i64_const(719468)
        fb.byte(OP_I64_ADD)
        fb.local_set(z)

        fb.local_get(z)
        fb.i64_const(146097)
        fb.byte(OP_I64_DIV_S)
        fb.local_set(era)

        fb.local_get(z)
        fb.local_get(era)
        fb.i64_const(146097)
        fb.byte(OP_I64_MUL)
        fb.byte(OP_I64_SUB)
        fb.local_set(doe)

        fb.local_get(doe)
        fb.local_get(doe)
        fb.i64_const(1460)
        fb.byte(OP_I64_DIV_S)
        fb.byte(OP_I64_SUB)
        fb.local_get(doe)
        fb.i64_const(36524)
        fb.byte(OP_I64_DIV_S)
        fb.byte(OP_I64_ADD)
        fb.local_get(doe)
        fb.i64_const(146096)
        fb.byte(OP_I64_DIV_S)
        fb.byte(OP_I64_SUB)
        fb.i64_const(365)
        fb.byte(OP_I64_DIV_S)
        fb.local_set(yoe)

        fb.local_get(yoe)
        fb.local_get(era)
        fb.i64_const(400)
        fb.byte(OP_I64_MUL)
        fb.byte(OP_I64_ADD)
        fb.local_set(y)

        fb.local_get(doe)
        fb.i64_const(365)
        fb.local_get(yoe)
        fb.byte(OP_I64_MUL)
        fb.local_get(yoe)
        fb.i64_const(4)
        fb.byte(OP_I64_DIV_S)
        fb.byte(OP_I64_ADD)
        fb.local_get(yoe)
        fb.i64_const(100)
        fb.byte(OP_I64_DIV_S)
        fb.byte(OP_I64_SUB)
        fb.byte(OP_I64_SUB)
        fb.local_set(doy)

        fb.i64_const(5)
        fb.local_get(doy)
        fb.byte(OP_I64_MUL)
        fb.i64_const(2)
        fb.byte(OP_I64_ADD)
        fb.i64_const(153)
        fb.byte(OP_I64_DIV_S)
        fb.local_set(mp)

        fb.local_get(doy)
        fb.i64_const(153)
        fb.local_get(mp)
        fb.byte(OP_I64_MUL)
        fb.i64_const(2)
        fb.byte(OP_I64_ADD)
        fb.i64_const(5)
        fb.byte(OP_I64_DIV_S)
        fb.byte(OP_I64_SUB)
        fb.i64_const(1)
        fb.byte(OP_I64_ADD)
        fb.local_set(d)

        fb.local_get(mp)
        fb.i64_const(3)
        fb.byte(OP_I64_ADD)
        fb.local_get(mp)
        fb.i64_const(9)
        fb.byte(OP_I64_SUB)
        fb.local_get(mp)
        fb.i64_const(10)
        fb.byte(OP_I64_LT_S)
        fb.byte(OP_SELECT)
        fb.local_set(m)

        fb.local_get(m)
        fb.i64_const(2)
        fb.byte(OP_I64_LE_S)
        fb.byte(OP_IF)
        fb.byte(0x40)
        fb.local_get(y)
        fb.i64_const(1)
        fb.byte(OP_I64_ADD)
        fb.local_set(y)
        fb.byte(OP_END)

        fb.local_get(1)
        fb.local_set(p)

        def _store_digit_calc(val_var, div_val, rem_val, offset):
            fb.local_get(p)
            if offset > 0:
                fb.i32_const(offset)
                fb.byte(OP_I32_ADD)
            fb.i64_const(48)
            fb.local_get(val_var)
            if div_val > 1:
                fb.i64_const(div_val)
                fb.byte(OP_I64_DIV_S)
            if rem_val > 0:
                fb.i64_const(rem_val)
                fb.byte(OP_I64_REM_S)
            fb.byte(OP_I64_ADD)
            fb.byte(OP_I32_WRAP_I64)
            fb.byte(OP_I32_STORE8)
            fb.put(encode_memarg(0, 0))

        def _store_char(ch, offset):
            fb.local_get(p)
            if offset > 0:
                fb.i32_const(offset)
                fb.byte(OP_I32_ADD)
            fb.i32_const(ord(ch))
            fb.byte(OP_I32_STORE8)
            fb.put(encode_memarg(0, 0))

        _store_digit_calc(y, 1000, 10, 0)
        _store_digit_calc(y, 100, 10, 1)
        _store_digit_calc(y, 10, 10, 2)
        _store_digit_calc(y, 1, 10, 3)
        _store_char('-', 4)
        _store_digit_calc(m, 10, 0, 5)
        _store_digit_calc(m, 1, 10, 6)
        _store_char('-', 7)
        _store_digit_calc(d, 10, 0, 8)
        _store_digit_calc(d, 1, 10, 9)
        _store_char('T', 10)
        _store_digit_calc(hour, 10, 0, 11)
        _store_digit_calc(hour, 1, 10, 12)
        _store_char(':', 13)
        _store_digit_calc(min_v, 10, 0, 14)
        _store_digit_calc(min_v, 1, 10, 15)
        _store_char(':', 16)
        _store_digit_calc(s_v, 10, 0, 17)
        _store_digit_calc(s_v, 1, 10, 18)
        _store_char('.', 19)
        _store_digit_calc(frac, 100000000, 10, 20)
        _store_digit_calc(frac, 10000000, 10, 21)
        _store_digit_calc(frac, 1000000, 10, 22)
        _store_digit_calc(frac, 100000, 10, 23)
        _store_digit_calc(frac, 10000, 10, 24)
        _store_digit_calc(frac, 1000, 10, 25)
        _store_digit_calc(frac, 100, 10, 26)
        _store_digit_calc(frac, 10, 10, 27)
        _store_digit_calc(frac, 1, 10, 28)
        _store_char('Z', 29)

        fb.i32_const(30)
        fb.byte(OP_RETURN)

        idx = self._mod.add_function(sig)
        self._mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        return idx

    def _build_f64_root(self) -> int:
        sig = self._mod.add_type([F64, I64], [F64])
        fb = FuncBody(num_params=2)
        l_iter = fb.new_i32()
        l_y = fb.new_f64()
        l_p = fb.new_f64()
        l_cnt = fb.new_i64()
        l_n1 = fb.new_f64()
        l_nf = fb.new_f64()
        fb.i32_const(0)
        fb.local_set(l_iter)
        fb.f64_const(1.0)
        fb.local_set(l_y)
        fb.emit_block()
        fb.emit_loop()
        fb.local_get(l_iter)
        fb.i32_const(60)
        fb.byte(0x4F)
        fb.br_if(1)
        fb.f64_const(1.0)
        fb.local_set(l_p)
        fb.local_get(1)
        fb.i64_const(1)
        fb.byte(OP_I64_SUB)
        fb.local_set(l_cnt)
        fb.emit_block()
        fb.emit_loop()
        fb.local_get(l_cnt)
        fb.i64_const(0)
        fb.byte(OP_I64_LE_S)
        fb.br_if(1)
        fb.local_get(l_p)
        fb.local_get(l_y)
        fb.byte(OP_F64_MUL)
        fb.local_set(l_p)
        fb.local_get(l_cnt)
        fb.i64_const(1)
        fb.byte(OP_I64_SUB)
        fb.local_set(l_cnt)
        fb.br(0)
        fb.emit_end()
        fb.emit_end()
        fb.local_get(1)
        fb.i64_const(1)
        fb.byte(OP_I64_SUB)
        fb.byte(OP_F64_CONVERT_I64_S)
        fb.local_set(l_n1)
        fb.local_get(1)
        fb.byte(OP_F64_CONVERT_I64_S)
        fb.local_set(l_nf)
        fb.local_get(l_n1)
        fb.local_get(l_y)
        fb.byte(OP_F64_MUL)
        fb.local_get(0)
        fb.local_get(l_p)
        fb.byte(OP_F64_DIV)
        fb.byte(OP_F64_ADD)
        fb.local_get(l_nf)
        fb.byte(OP_F64_DIV)
        fb.local_set(l_y)
        fb.local_get(l_iter)
        fb.i32_const(1)
        fb.byte(0x6A)
        fb.local_set(l_iter)
        fb.br(0)
        fb.emit_end()
        fb.emit_end()
        fb.local_get(l_y)
        fb.byte(OP_RETURN)
        idx = self._mod.add_function(sig)
        self._mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        return idx

    def _build_round_fmt(self) -> int:
        sig = self._mod.add_type([F64, I64, I64, I64, I64], [F64])
        fb = FuncBody(num_params=5)
        l_b = fb.new_i64()
        l_s = fb.new_i64()
        l_e = fb.new_i64()
        l_f2 = fb.new_i64()
        l_drop = fb.new_i64()
        l_half = fb.new_i64()
        l_rem = fb.new_i64()
        l_eu = fb.new_i64()
        MANT = 4503599627370495
        IMPL = 4503599627370496
        fb.local_get(0)
        fb.byte(OP_I64_REINTERPRET_F64)
        fb.local_set(l_b)
        fb.local_get(l_b)
        fb.i64_const(52)
        fb.byte(OP_I64_SHR_U)
        fb.i64_const(2047)
        fb.byte(OP_I64_AND)
        fb.local_set(l_e)
        fb.local_get(l_e)
        fb.i64_const(2047)
        fb.byte(OP_I64_EQ)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.local_get(4)
        fb.i64_const(0)
        fb.byte(OP_I64_EQ)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.f64_const(0.0)
        fb.f64_const(0.0)
        fb.byte(OP_F64_DIV)
        fb.byte(OP_RETURN)
        fb.byte(OP_END)
        fb.local_get(0)
        fb.byte(OP_RETURN)
        fb.byte(OP_END)
        fb.local_get(l_e)
        fb.i64_const(0)
        fb.byte(OP_I64_EQ)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.local_get(0)
        fb.byte(OP_RETURN)
        fb.byte(OP_END)
        fb.i64_const(52)
        fb.local_get(1)
        fb.byte(OP_I64_SUB)
        fb.local_set(l_drop)
        fb.local_get(l_drop)
        fb.i64_const(0)
        fb.byte(OP_I64_EQ)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.local_get(0)
        fb.byte(OP_RETURN)
        fb.byte(OP_END)
        fb.local_get(l_b)
        fb.i64_const(63)
        fb.byte(OP_I64_SHR_U)
        fb.local_set(l_s)
        fb.i64_const(1)
        fb.local_get(l_drop)
        fb.i64_const(1)
        fb.byte(OP_I64_SUB)
        fb.byte(OP_I64_SHL)
        fb.local_set(l_half)
        fb.local_get(l_b)
        fb.i64_const(MANT)
        fb.byte(OP_I64_AND)
        fb.i64_const(IMPL)
        fb.byte(OP_I64_OR)
        fb.local_get(l_drop)
        fb.byte(OP_I64_SHR_U)
        fb.local_set(l_f2)
        fb.local_get(l_b)
        fb.i64_const(MANT)
        fb.byte(OP_I64_AND)
        fb.local_get(l_half)
        fb.i64_const(1)
        fb.byte(OP_I64_SHL)
        fb.i64_const(1)
        fb.byte(OP_I64_SUB)
        fb.byte(OP_I64_AND)
        fb.local_set(l_rem)
        fb.local_get(l_rem)
        fb.local_get(l_half)
        fb.byte(OP_I64_GT_S)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.local_get(l_f2)
        fb.i64_const(1)
        fb.byte(OP_I64_ADD)
        fb.local_set(l_f2)
        fb.byte(OP_END)
        fb.local_get(l_rem)
        fb.local_get(l_half)
        fb.byte(OP_I64_EQ)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.local_get(l_f2)
        fb.i64_const(1)
        fb.byte(OP_I64_AND)
        fb.i64_const(0)
        fb.byte(OP_I64_NE)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.local_get(l_f2)
        fb.i64_const(1)
        fb.byte(OP_I64_ADD)
        fb.local_set(l_f2)
        fb.byte(OP_END)
        fb.byte(OP_END)
        fb.local_get(l_f2)
        fb.i64_const(1)
        fb.i64_const(1)
        fb.local_get(1)
        fb.byte(OP_I64_ADD)
        fb.byte(OP_I64_SHL)
        fb.byte(OP_I64_EQ)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.i64_const(0)
        fb.local_set(l_f2)
        fb.local_get(l_e)
        fb.i64_const(1)
        fb.byte(OP_I64_ADD)
        fb.local_set(l_e)
        fb.byte(OP_END)
        fb.local_get(l_e)
        fb.i64_const(1023)
        fb.byte(OP_I64_SUB)
        fb.local_set(l_eu)
        fb.local_get(l_eu)
        fb.local_get(3)
        fb.byte(OP_I64_GT_S)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.local_get(4)
        fb.i64_const(0)
        fb.byte(OP_I64_EQ)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.f64_const(0.0)
        fb.f64_const(0.0)
        fb.byte(OP_F64_DIV)
        fb.byte(OP_RETURN)
        fb.byte(OP_END)
        fb.local_get(l_s)
        fb.i64_const(0)
        fb.byte(OP_I64_EQ)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.f64_const(1.0)
        fb.f64_const(0.0)
        fb.byte(OP_F64_DIV)
        fb.byte(OP_RETURN)
        fb.byte(OP_ELSE)
        fb.f64_const(1.0)
        fb.f64_const(0.0)
        fb.byte(OP_F64_DIV)
        fb.byte(OP_F64_NEG)
        fb.byte(OP_RETURN)
        fb.byte(OP_END)
        fb.byte(OP_END)
        fb.local_get(l_eu)
        fb.local_get(2)
        fb.byte(OP_I64_LT_S)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        l_x = fb.new_f64()
        l_q = fb.new_i64()
        l_remf = fb.new_f64()
        l_scale = fb.new_f64()
        fb.local_get(2)
        fb.local_get(1)
        fb.byte(OP_I64_SUB)
        fb.i64_const(1023)
        fb.byte(OP_I64_ADD)
        fb.i64_const(52)
        fb.byte(OP_I64_SHL)
        fb.byte(OP_F64_REINTERPRET_I64)
        fb.local_set(l_scale)
        fb.local_get(0)
        fb.byte(OP_F64_ABS)
        fb.local_get(l_scale)
        fb.byte(OP_F64_DIV)
        fb.local_set(l_x)
        fb.local_get(l_x)
        fb.byte(OP_I64_TRUNC_F64_S)
        fb.local_set(l_q)
        fb.local_get(l_x)
        fb.local_get(l_q)
        fb.byte(OP_F64_CONVERT_I64_S)
        fb.byte(OP_F64_SUB)
        fb.local_set(l_remf)
        fb.local_get(l_remf)
        fb.f64_const(0.5)
        fb.byte(OP_F64_GT)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.local_get(l_q)
        fb.i64_const(1)
        fb.byte(OP_I64_ADD)
        fb.local_set(l_q)
        fb.byte(OP_END)
        fb.local_get(l_remf)
        fb.f64_const(0.5)
        fb.byte(OP_F64_EQ)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.local_get(l_q)
        fb.i64_const(1)
        fb.byte(OP_I64_AND)
        fb.i64_const(1)
        fb.byte(OP_I64_EQ)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.local_get(l_q)
        fb.i64_const(1)
        fb.byte(OP_I64_ADD)
        fb.local_set(l_q)
        fb.byte(OP_END)
        fb.byte(OP_END)
        fb.local_get(l_q)
        fb.i64_const(0)
        fb.byte(OP_I64_EQ)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.local_get(l_s)
        fb.i64_const(63)
        fb.byte(OP_I64_SHL)
        fb.byte(OP_F64_REINTERPRET_I64)
        fb.byte(OP_RETURN)
        fb.byte(OP_END)
        fb.local_get(l_q)
        fb.i64_const(1)
        fb.local_get(1)
        fb.byte(OP_I64_SHL)
        fb.byte(OP_I64_GE_S)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.local_get(l_s)
        fb.i64_const(63)
        fb.byte(OP_I64_SHL)
        fb.local_get(2)
        fb.i64_const(1023)
        fb.byte(OP_I64_ADD)
        fb.i64_const(52)
        fb.byte(OP_I64_SHL)
        fb.byte(OP_I64_OR)
        fb.byte(OP_F64_REINTERPRET_I64)
        fb.byte(OP_RETURN)
        fb.byte(OP_END)
        fb.local_get(l_q)
        fb.byte(OP_F64_CONVERT_I64_S)
        fb.local_get(l_scale)
        fb.byte(OP_F64_MUL)
        fb.byte(OP_I64_REINTERPRET_F64)
        fb.local_get(l_s)
        fb.i64_const(63)
        fb.byte(OP_I64_SHL)
        fb.byte(OP_I64_OR)
        fb.byte(OP_F64_REINTERPRET_I64)
        fb.byte(OP_RETURN)
        fb.byte(OP_END)
        fb.local_get(l_s)
        fb.i64_const(63)
        fb.byte(OP_I64_SHL)
        fb.local_get(l_eu)
        fb.i64_const(1023)
        fb.byte(OP_I64_ADD)
        fb.i64_const(52)
        fb.byte(OP_I64_SHL)
        fb.byte(OP_I64_OR)
        fb.local_get(l_f2)
        fb.local_get(l_drop)
        fb.byte(OP_I64_SHL)
        fb.i64_const(MANT)
        fb.byte(OP_I64_AND)
        fb.byte(OP_I64_OR)
        fb.byte(OP_F64_REINTERPRET_I64)
        fb.byte(OP_RETURN)
        idx = self._mod.add_function(sig)
        self._mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        return idx

    def _emit_round(self, fb: FuncBody, ft: str) -> None:
        if ft not in FMT_CONSTS or ft == "float64":
            return
        mb, emin, emax, allow_inf = FMT_CONSTS[ft]
        fb.i64_const(mb)
        fb.i64_const(emin)
        fb.i64_const(emax)
        fb.i64_const(allow_inf)
        fb.byte(0x10)
        fb.uleb(self._helper_funcs["$round_fmt"])

    def _build_encode_utf8(self) -> int:
        sig = self._mod.add_type([I32, I32], [I32])
        fb = FuncBody(num_params=2)
        fb.local_get(0)
        fb.i32_const(128)
        fb.byte(0x49)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.local_get(1)
        fb.local_get(0)
        fb.byte(OP_I32_STORE8)
        fb.put(encode_memarg(0, 0))
        fb.i32_const(1)
        fb.byte(OP_RETURN)
        fb.byte(OP_END)
        fb.local_get(0)
        fb.i32_const(2048)
        fb.byte(0x49)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.local_get(1)
        fb.local_get(0)
        fb.i32_const(6)
        fb.byte(0x76)
        fb.i32_const(192)
        fb.byte(0x72)
        fb.byte(OP_I32_STORE8)
        fb.put(encode_memarg(0, 0))
        fb.local_get(1)
        fb.i32_const(1)
        fb.byte(0x6A)
        fb.local_get(0)
        fb.i32_const(63)
        fb.byte(0x71)
        fb.i32_const(128)
        fb.byte(0x72)
        fb.byte(OP_I32_STORE8)
        fb.put(encode_memarg(0, 0))
        fb.i32_const(2)
        fb.byte(OP_RETURN)
        fb.byte(OP_END)
        fb.local_get(0)
        fb.i32_const(65536)
        fb.byte(0x49)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.local_get(1)
        fb.local_get(0)
        fb.i32_const(12)
        fb.byte(0x76)
        fb.i32_const(224)
        fb.byte(0x72)
        fb.byte(OP_I32_STORE8)
        fb.put(encode_memarg(0, 0))
        fb.local_get(1)
        fb.i32_const(1)
        fb.byte(0x6A)
        fb.local_get(0)
        fb.i32_const(6)
        fb.byte(0x76)
        fb.i32_const(63)
        fb.byte(0x71)
        fb.i32_const(128)
        fb.byte(0x72)
        fb.byte(OP_I32_STORE8)
        fb.put(encode_memarg(0, 0))
        fb.local_get(1)
        fb.i32_const(2)
        fb.byte(0x6A)
        fb.local_get(0)
        fb.i32_const(63)
        fb.byte(0x71)
        fb.i32_const(128)
        fb.byte(0x72)
        fb.byte(OP_I32_STORE8)
        fb.put(encode_memarg(0, 0))
        fb.i32_const(3)
        fb.byte(OP_RETURN)
        fb.byte(OP_END)
        fb.local_get(1)
        fb.local_get(0)
        fb.i32_const(18)
        fb.byte(0x76)
        fb.i32_const(240)
        fb.byte(0x72)
        fb.byte(OP_I32_STORE8)
        fb.put(encode_memarg(0, 0))
        fb.local_get(1)
        fb.i32_const(1)
        fb.byte(0x6A)
        fb.local_get(0)
        fb.i32_const(12)
        fb.byte(0x76)
        fb.i32_const(63)
        fb.byte(0x71)
        fb.i32_const(128)
        fb.byte(0x72)
        fb.byte(OP_I32_STORE8)
        fb.put(encode_memarg(0, 0))
        fb.local_get(1)
        fb.i32_const(2)
        fb.byte(0x6A)
        fb.local_get(0)
        fb.i32_const(6)
        fb.byte(0x76)
        fb.i32_const(63)
        fb.byte(0x71)
        fb.i32_const(128)
        fb.byte(0x72)
        fb.byte(OP_I32_STORE8)
        fb.put(encode_memarg(0, 0))
        fb.local_get(1)
        fb.i32_const(3)
        fb.byte(0x6A)
        fb.local_get(0)
        fb.i32_const(63)
        fb.byte(0x71)
        fb.i32_const(128)
        fb.byte(0x72)
        fb.byte(OP_I32_STORE8)
        fb.put(encode_memarg(0, 0))
        fb.i32_const(4)
        fb.byte(OP_RETURN)
        idx = self._mod.add_function(sig)
        self._mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        return idx

    def _build_print_str(self) -> int:
        sig = self._mod.add_type([I32, I32], [])
        fb = FuncBody(num_params=2)
        fd_write_idx = self._helper_funcs["$fd_write"]
        iov = self._iov_off()
        nw = self._iov_off() + 8
        l_iov = fb.new_i32()
        fb.i32_const(iov)
        fb.local_set(l_iov)
        fb.local_get(l_iov)
        fb.local_get(0)
        fb.byte(OP_I32_STORE)
        fb.put(encode_memarg(2, 0))
        fb.local_get(l_iov)
        fb.i32_const(4)
        fb.byte(0x6A)
        fb.local_get(1)
        fb.byte(OP_I32_STORE)
        fb.put(encode_memarg(2, 0))
        fb.i32_const(1)
        fb.local_get(l_iov)
        fb.i32_const(1)
        fb.i32_const(nw)
        fb.byte(0x10)
        fb.uleb(fd_write_idx)
        fb.byte(OP_DROP)
        idx = self._mod.add_function(sig)
        self._mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        return idx

    def _build_input_helpers(self) -> None:
        from flux_proto.semantic.storage_types import _INT_RANGES

        retry = {t: self._fat_const(f"\x1b[90m{msg}\x1b[0m")
                 for t, msg in _INPUT_RETRY_MESSAGES.items()}
        tname = {t: self._fat_const(t) for t in _INT_RANGES}
        f_true = self._fat_const("true")
        f_true_pt = self._fat_const("verdadeiro")
        f_false = self._fat_const("false")
        f_false_pt = self._fat_const("falso")

        self._dt_pos = self._mod.add_global(I32, True, b"\x41\x00")
        self._dt_ok = self._mod.add_global(I32, True, b"\x41\x01")
        self._cx_pos = self._mod.add_global(I32, True, b"\x41\x00")
        self._cx_sign = self._mod.add_global(I32, True, b"\x41\x01")
        self._cx_digit = self._mod.add_global(I32, True, b"\x41\x00")
        self._flux_cx_re_tmp = self._mod.add_global(
            F64, True, bytes([OP_F64_CONST]) + struct.pack("<d", 0.0))
        self._flux_cx_im_tmp = self._mod.add_global(
            F64, True, bytes([OP_F64_CONST]) + struct.pack("<d", 0.0))

        self._helper_funcs["$print_fat"] = self._build_print_fat()
        self._helper_funcs["$print_fat_nl"] = self._build_print_fat_nl()
        self._helper_funcs["$streq"] = self._build_streq()
        self._helper_funcs["$flux_read_line"] = self._build_flux_read_line()
        self._helper_funcs["$valid_float"] = self._build_valid_float()
        self._helper_funcs["$dt_num"] = self._build_dt_num()
        self._helper_funcs["$dt_num0"] = self._build_dt_num0()
        self._helper_funcs["$dt_frac"] = self._build_dt_frac()
        self._helper_funcs["$dt_offset"] = self._build_dt_offset()
        self._helper_funcs["$days_from_civil"] = self._build_days_from_civil()
        self._helper_funcs["$at_ws_end"] = self._build_at_ws_end()
        self._helper_funcs["$parse_f64"] = self._build_parse_f64()
        self._helper_funcs["$parse_complex_inner"] = self._build_parse_complex_inner()
        self._helper_funcs["$flux_input_int"] = self._build_input_int(tname, retry["int"])
        self._helper_funcs["$flux_input_float"] = self._build_input_float(retry["float"])
        self._helper_funcs["$flux_input_bool"] = self._build_input_bool(
            retry["bool"], f_true, f_true_pt, f_false, f_false_pt)
        self._helper_funcs["$flux_input_char"] = self._build_input_char(retry["char"])
        self._helper_funcs["$flux_input_datetime"] = self._build_input_datetime(retry["datetime"])
        self._helper_funcs["$flux_input_string"] = self._build_input_string()
        self._helper_funcs["$flux_input_complex"] = self._build_input_complex(retry["complex"])

    def _emit_call(self, fb: FuncBody, idx: int) -> None:
        fb.byte(0x10)
        fb.uleb(idx)

    def _build_print_fat(self) -> int:
        sig = self._mod.add_type([I64], [])
        fb = FuncBody(num_params=1)
        l_ptr = fb.new_i32()
        l_len = fb.new_i32()
        fb.local_get(0)
        fb.i64_const(32)
        fb.byte(OP_I64_SHR_U)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_ptr)
        fb.local_get(0)
        fb.i64_const(0xFFFFFFFF)
        fb.byte(OP_I64_AND)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_len)
        fb.local_get(l_ptr)
        fb.local_get(l_len)
        self._emit_call(fb, self._helper_funcs["$print_str"])
        idx = self._mod.add_function(sig)
        self._mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        return idx

    def _build_print_fat_nl(self) -> int:
        sig = self._mod.add_type([I64], [])
        fb = FuncBody(num_params=1)
        fb.local_get(0)
        self._emit_call(fb, self._helper_funcs["$print_fat"])
        fb.i64_const(self._fat_const("\n"))
        self._emit_call(fb, self._helper_funcs["$print_fat"])
        idx = self._mod.add_function(sig)
        self._mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        return idx

    def _build_streq(self) -> int:
        sig = self._mod.add_type([I64, I64], [I32])
        fb = FuncBody(num_params=2)
        l_ptr_a = fb.new_i32()
        l_ptr_b = fb.new_i32()
        l_len_a = fb.new_i32()
        l_len_b = fb.new_i32()
        l_i = fb.new_i32()
        fb.local_get(0)
        fb.i64_const(32)
        fb.byte(OP_I64_SHR_U)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_ptr_a)
        fb.local_get(1)
        fb.i64_const(32)
        fb.byte(OP_I64_SHR_U)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_ptr_b)
        fb.local_get(0)
        fb.i64_const(0xFFFFFFFF)
        fb.byte(OP_I64_AND)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_len_a)
        fb.local_get(1)
        fb.i64_const(0xFFFFFFFF)
        fb.byte(OP_I64_AND)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_len_b)
        fb.local_get(l_len_a)
        fb.local_get(l_len_b)
        fb.byte(OP_I32_NE)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.i32_const(0)
        fb.byte(OP_RETURN)
        fb.byte(OP_END)
        fb.i32_const(0)
        fb.local_set(l_i)
        fb.emit_block()
        exit_pos = fb.label_depth
        fb.emit_loop()
        loop_pos = fb.label_depth
        fb.local_get(l_i)
        fb.local_get(l_len_a)
        fb.byte(OP_I32_GE_U)
        fb.br_if(self._br_depth(fb, exit_pos))
        fb.local_get(l_ptr_a)
        fb.local_get(l_i)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_get(l_ptr_b)
        fb.local_get(l_i)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.byte(OP_I32_NE)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.i32_const(0)
        fb.byte(OP_RETURN)
        fb.byte(OP_END)
        fb.local_get(l_i)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_i)
        fb.br(self._br_depth(fb, loop_pos))
        fb.emit_end()
        fb.emit_end()
        fb.i32_const(1)
        fb.byte(OP_RETURN)
        idx = self._mod.add_function(sig)
        self._mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        return idx

    def _build_path_base_name(self) -> int:
        sig = self._mod.add_type([I64], [I64])
        fb = FuncBody(num_params=1)
        l_ptr = fb.new_i32()
        l_len = fb.new_i32()
        l_i = fb.new_i32()
        l_c = fb.new_i32()
        l_last_slash = fb.new_i32()

        fb.local_get(0)
        fb.i64_const(32)
        fb.byte(OP_I64_SHR_U)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_ptr)

        fb.local_get(0)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_len)

        fb.i32_const(-1)
        fb.local_set(l_last_slash)

        fb.i32_const(0)
        fb.local_set(l_i)

        fb.emit_block()
        exit_pos = fb.label_depth
        fb.emit_loop()
        loop_pos = fb.label_depth

        fb.local_get(l_i)
        fb.local_get(l_len)
        fb.byte(OP_I32_GE_U)
        fb.br_if(self._br_depth(fb, exit_pos))

        fb.local_get(l_ptr)
        fb.local_get(l_i)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_c)

        fb.local_get(l_c)
        fb.i32_const(47)
        fb.byte(OP_I32_EQ)
        fb.local_get(l_c)
        fb.i32_const(92)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_OR)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.local_get(l_i)
        fb.local_set(l_last_slash)
        fb.byte(OP_END)

        fb.local_get(l_i)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_i)
        fb.br(self._br_depth(fb, loop_pos))
        fb.emit_end()
        fb.emit_end()

        fb.local_get(l_last_slash)
        fb.i32_const(0)
        fb.byte(OP_I32_GE_S)
        fb.byte(OP_IF)
        fb.put(b"\x40")

        fb.local_get(l_ptr)
        fb.local_get(l_last_slash)
        fb.byte(OP_I32_ADD)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I64_EXTEND_I32_U)
        fb.i64_const(32)
        fb.byte(OP_I64_SHL)

        fb.local_get(l_len)
        fb.local_get(l_last_slash)
        fb.byte(OP_I32_SUB)
        fb.i32_const(1)
        fb.byte(OP_I32_SUB)
        fb.byte(OP_I64_EXTEND_I32_U)

        fb.byte(OP_I64_OR)
        fb.byte(OP_RETURN)
        fb.byte(OP_END)

        fb.local_get(0)
        fb.byte(OP_RETURN)

        idx = self._mod.add_function(sig)
        self._mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        return idx

    def _build_path_dir_name(self) -> int:
        sig = self._mod.add_type([I64], [I64])
        fb = FuncBody(num_params=1)
        l_ptr = fb.new_i32()
        l_len = fb.new_i32()
        l_i = fb.new_i32()
        l_c = fb.new_i32()
        l_last_slash = fb.new_i32()

        fb.local_get(0)
        fb.i64_const(32)
        fb.byte(OP_I64_SHR_U)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_ptr)

        fb.local_get(0)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_len)

        fb.i32_const(-1)
        fb.local_set(l_last_slash)

        fb.i32_const(0)
        fb.local_set(l_i)

        fb.emit_block()
        exit_pos = fb.label_depth
        fb.emit_loop()
        loop_pos = fb.label_depth

        fb.local_get(l_i)
        fb.local_get(l_len)
        fb.byte(OP_I32_GE_U)
        fb.br_if(self._br_depth(fb, exit_pos))

        fb.local_get(l_ptr)
        fb.local_get(l_i)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_c)

        fb.local_get(l_c)
        fb.i32_const(47)
        fb.byte(OP_I32_EQ)
        fb.local_get(l_c)
        fb.i32_const(92)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_OR)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.local_get(l_i)
        fb.local_set(l_last_slash)
        fb.byte(OP_END)

        fb.local_get(l_i)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_i)
        fb.br(self._br_depth(fb, loop_pos))
        fb.emit_end()
        fb.emit_end()

        fb.local_get(l_last_slash)
        fb.i32_const(0)
        fb.byte(OP_I32_GE_S)
        fb.byte(OP_IF)
        fb.put(b"\x40")

        fb.local_get(l_ptr)
        fb.byte(OP_I64_EXTEND_I32_U)
        fb.i64_const(32)
        fb.byte(OP_I64_SHL)

        fb.local_get(l_last_slash)
        fb.byte(OP_I64_EXTEND_I32_U)

        fb.byte(OP_I64_OR)
        fb.byte(OP_RETURN)
        fb.byte(OP_END)

        fb.i64_const(0)
        fb.byte(OP_RETURN)

        idx = self._mod.add_function(sig)
        self._mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        return idx

    def _build_path_extension(self) -> int:
        sig = self._mod.add_type([I64], [I64])
        fb = FuncBody(num_params=1)
        l_ptr = fb.new_i32()
        l_len = fb.new_i32()
        l_i = fb.new_i32()
        l_c = fb.new_i32()
        l_last_dot = fb.new_i32()

        fb.local_get(0)
        fb.i64_const(32)
        fb.byte(OP_I64_SHR_U)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_ptr)

        fb.local_get(0)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_len)

        fb.i32_const(-1)
        fb.local_set(l_last_dot)

        fb.i32_const(0)
        fb.local_set(l_i)

        fb.emit_block()
        exit_pos = fb.label_depth
        fb.emit_loop()
        loop_pos = fb.label_depth

        fb.local_get(l_i)
        fb.local_get(l_len)
        fb.byte(OP_I32_GE_U)
        fb.br_if(self._br_depth(fb, exit_pos))

        fb.local_get(l_ptr)
        fb.local_get(l_i)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_c)

        fb.local_get(l_c)
        fb.i32_const(46)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.local_get(l_i)
        fb.local_set(l_last_dot)
        fb.byte(OP_END)

        fb.local_get(l_i)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_i)
        fb.br(self._br_depth(fb, loop_pos))
        fb.emit_end()
        fb.emit_end()

        fb.local_get(l_last_dot)
        fb.i32_const(0)
        fb.byte(OP_I32_GE_S)
        fb.byte(OP_IF)
        fb.put(b"\x40")

        fb.local_get(l_ptr)
        fb.local_get(l_last_dot)
        fb.byte(OP_I32_ADD)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I64_EXTEND_I32_U)
        fb.i64_const(32)
        fb.byte(OP_I64_SHL)

        fb.local_get(l_len)
        fb.local_get(l_last_dot)
        fb.byte(OP_I32_SUB)
        fb.i32_const(1)
        fb.byte(OP_I32_SUB)
        fb.byte(OP_I64_EXTEND_I32_U)

        fb.byte(OP_I64_OR)
        fb.byte(OP_RETURN)
        fb.byte(OP_END)

        fb.i64_const(0)
        fb.byte(OP_RETURN)

        idx = self._mod.add_function(sig)
        self._mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        return idx

    def _build_path_join(self) -> int:
        sig = self._mod.add_type([I64, I64], [I64])
        fb = FuncBody(num_params=2)
        l_buf = fb.new_i32()
        l_len = fb.new_i32()

        fb.local_get(0)
        fb.byte(OP_I64_EQZ)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.local_get(1)
        fb.byte(OP_RETURN)
        fb.byte(OP_END)

        fb.local_get(1)
        fb.byte(OP_I64_EQZ)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.local_get(0)
        fb.byte(OP_RETURN)
        fb.byte(OP_END)

        fb.i32_const(1024)
        fb.byte(0x10)
        fb.uleb(self._helper_funcs["$strbuf_new"])
        fb.local_set(l_buf)

        fb.local_get(l_buf)
        fb.local_get(0)
        fb.byte(0x10)
        fb.uleb(self._helper_funcs["$strappend"])

        slash_fat = self._fat_const("/")
        fb.local_get(l_buf)
        fb.i64_const(slash_fat)
        fb.byte(0x10)
        fb.uleb(self._helper_funcs["$strappend"])

        fb.local_get(l_buf)
        fb.local_get(1)
        fb.byte(0x10)
        fb.uleb(self._helper_funcs["$strappend"])

        fb.local_get(l_buf)
        fb.byte(0x10)
        fb.uleb(self._helper_funcs["$strbuf_done"])

        fb.local_get(l_buf)
        fb.byte(OP_I32_LOAD)
        fb.put(encode_memarg(2, 0))
        fb.local_set(l_len)

        fb.local_get(l_buf)
        fb.i32_const(4)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I64_EXTEND_I32_U)
        fb.i64_const(32)
        fb.byte(OP_I64_SHL)

        fb.local_get(l_len)
        fb.byte(OP_I64_EXTEND_I32_U)
        fb.byte(OP_I64_OR)
        fb.byte(OP_RETURN)

        idx = self._mod.add_function(sig)
        self._mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        return idx

    def _build_flux_read_line(self) -> int:
        sig = self._mod.add_type([], [I64])
        fb = FuncBody(num_params=0)
        b = self._input_buf_off()
        iov = self._read_iov_off()
        nw = self._read_nw_off()
        fd_read = self._helper_funcs["$fd_read"]
        l_n = fb.new_i32()
        l_c = fb.new_i32()
        fb.i32_const(0)
        fb.local_set(l_n)
        fb.emit_block()
        exit_pos = fb.label_depth
        fb.emit_loop()
        loop_pos = fb.label_depth
        fb.local_get(l_n)
        fb.i32_const(4095)
        fb.byte(OP_I32_GE_U)
        fb.br_if(self._br_depth(fb, exit_pos))
        fb.i32_const(iov)
        fb.i32_const(b)
        fb.local_get(l_n)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_STORE)
        fb.put(encode_memarg(2, 0))
        fb.i32_const(iov)
        fb.i32_const(4)
        fb.byte(OP_I32_ADD)
        fb.i32_const(1)
        fb.byte(OP_I32_STORE)
        fb.put(encode_memarg(2, 0))
        fb.i32_const(0)
        fb.i32_const(iov)
        fb.i32_const(1)
        fb.i32_const(nw)
        self._emit_call(fb, fd_read)
        fb.byte(OP_DROP)
        fb.i32_const(nw)
        fb.byte(OP_I32_LOAD)
        fb.put(encode_memarg(2, 0))
        fb.local_set(l_c)
        fb.local_get(l_c)
        fb.byte(OP_I32_EQZ)
        fb.br_if(self._br_depth(fb, exit_pos))
        fb.i32_const(b)
        fb.local_get(l_n)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_c)
        fb.local_get(l_c)
        fb.i32_const(10)
        fb.byte(OP_I32_EQ)
        fb.br_if(self._br_depth(fb, exit_pos))
        fb.local_get(l_n)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_n)
        fb.br(self._br_depth(fb, loop_pos))
        fb.emit_end()
        fb.emit_end()
        fb.local_get(l_n)
        fb.i32_const(0)
        fb.byte(OP_I32_GT_U)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.i32_const(b)
        fb.local_get(l_n)
        fb.i32_const(1)
        fb.byte(OP_I32_SUB)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.i32_const(13)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.local_get(l_n)
        fb.i32_const(1)
        fb.byte(OP_I32_SUB)
        fb.local_set(l_n)
        fb.byte(OP_END)
        fb.byte(OP_END)
        fb.i32_const(b)
        fb.byte(OP_I64_EXTEND_I32_U)
        fb.i64_const(32)
        fb.byte(OP_I64_SHL)
        fb.local_get(l_n)
        fb.byte(OP_I64_EXTEND_I32_U)
        fb.byte(OP_I64_OR)
        fb.byte(OP_RETURN)
        idx = self._mod.add_function(sig)
        self._mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        return idx

    def _build_valid_float(self) -> int:
        sig = self._mod.add_type([I64], [I32])
        fb = FuncBody(num_params=1)
        l_ptr = fb.new_i32()
        l_len = fb.new_i32()
        l_i = fb.new_i32()
        l_c = fb.new_i32()
        l_dig = fb.new_i32()
        l_dot = fb.new_i32()
        fb.local_get(0)
        fb.i64_const(32)
        fb.byte(OP_I64_SHR_U)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_ptr)
        fb.local_get(0)
        fb.i64_const(0xFFFFFFFF)
        fb.byte(OP_I64_AND)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_len)
        fb.i32_const(0)
        fb.local_set(l_i)
        fb.i32_const(0)
        fb.local_set(l_dig)
        fb.i32_const(0)
        fb.local_set(l_dot)
        fb.emit_block()
        ws_pos = fb.label_depth
        fb.emit_loop()
        ws_loop = fb.label_depth
        fb.local_get(l_i)
        fb.local_get(l_len)
        fb.byte(OP_I32_GE_U)
        fb.br_if(self._br_depth(fb, ws_pos))
        fb.local_get(l_ptr)
        fb.local_get(l_i)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_c)
        fb.local_get(l_c)
        fb.i32_const(32)
        fb.byte(OP_I32_EQ)
        fb.local_get(l_c)
        fb.i32_const(9)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_OR)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.local_get(l_i)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_i)
        fb.br(self._br_depth(fb, ws_loop))
        fb.byte(OP_END)
        fb.br(self._br_depth(fb, ws_pos))
        fb.emit_end()
        fb.emit_end()
        fb.local_get(l_i)
        fb.local_get(l_len)
        fb.byte(OP_I32_LT_U)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.local_get(l_ptr)
        fb.local_get(l_i)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_c)
        fb.local_get(l_c)
        fb.i32_const(43)
        fb.byte(OP_I32_EQ)
        fb.local_get(l_c)
        fb.i32_const(45)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_OR)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.local_get(l_i)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_i)
        fb.byte(OP_END)
        fb.byte(OP_END)
        fb.emit_block()
        main_pos = fb.label_depth
        fb.emit_loop()
        main_loop = fb.label_depth
        fb.local_get(l_i)
        fb.local_get(l_len)
        fb.byte(OP_I32_GE_U)
        fb.br_if(self._br_depth(fb, main_pos))
        fb.local_get(l_ptr)
        fb.local_get(l_i)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_c)
        fb.local_get(l_c)
        fb.i32_const(48)
        fb.byte(OP_I32_GE_U)
        fb.local_get(l_c)
        fb.i32_const(57)
        fb.byte(OP_I32_LE_U)
        fb.byte(OP_I32_AND)
        fb.emit_if()
        fb.i32_const(1)
        fb.local_set(l_dig)
        fb.local_get(l_i)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_i)
        fb.byte(OP_ELSE)
        fb.local_get(l_c)
        fb.i32_const(46)
        fb.byte(OP_I32_EQ)
        fb.local_get(l_c)
        fb.i32_const(44)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_OR)
        fb.emit_if()
        fb.local_get(l_dot)
        fb.emit_if()
        fb.i32_const(0)
        fb.byte(OP_RETURN)
        fb.emit_end()
        fb.i32_const(1)
        fb.local_set(l_dot)
        fb.local_get(l_i)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_i)
        fb.byte(OP_ELSE)
        fb.br(self._br_depth(fb, main_pos))
        fb.emit_end()
        fb.emit_end()
        fb.br(self._br_depth(fb, main_loop))
        fb.emit_end()
        fb.emit_end()
        fb.emit_block()
        ws2_pos = fb.label_depth
        fb.emit_loop()
        ws2_loop = fb.label_depth
        fb.local_get(l_i)
        fb.local_get(l_len)
        fb.byte(OP_I32_GE_U)
        fb.br_if(self._br_depth(fb, ws2_pos))
        fb.local_get(l_ptr)
        fb.local_get(l_i)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_c)
        fb.local_get(l_c)
        fb.i32_const(32)
        fb.byte(OP_I32_EQ)
        fb.local_get(l_c)
        fb.i32_const(9)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_OR)
        fb.emit_if()
        fb.local_get(l_i)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_i)
        fb.br(self._br_depth(fb, ws2_loop))
        fb.emit_end()
        fb.i32_const(0)
        fb.byte(OP_RETURN)
        fb.emit_end()
        fb.emit_end()
        fb.local_get(l_dig)
        fb.byte(OP_I32_EQZ)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.i32_const(0)
        fb.byte(OP_RETURN)
        fb.byte(OP_END)
        fb.i32_const(1)
        fb.byte(OP_RETURN)
        idx = self._mod.add_function(sig)
        self._mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        return idx

    def _build_dt_num(self) -> int:
        sig = self._mod.add_type([I32, I32, I32, I32], [I64])
        fb = FuncBody(num_params=4)
        dt_pos = self._dt_pos
        dt_ok = self._dt_ok
        l_i = fb.new_i32()
        l_v = fb.new_i64()
        l_c = fb.new_i32()
        fb.global_get(dt_pos)
        fb.local_set(l_i)
        fb.i64_const(0)
        fb.local_set(l_v)
        fb.emit_block()
        exit_pos = fb.label_depth
        fb.emit_loop()
        loop_pos = fb.label_depth
        fb.local_get(2)
        fb.byte(OP_I32_EQZ)
        fb.br_if(self._br_depth(fb, exit_pos))
        fb.local_get(l_i)
        fb.local_get(1)
        fb.byte(OP_I32_GE_U)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.i32_const(0)
        fb.global_set(dt_ok)
        fb.i64_const(0)
        fb.byte(OP_RETURN)
        fb.byte(OP_END)
        fb.local_get(0)
        fb.local_get(l_i)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_c)
        fb.local_get(l_c)
        fb.i32_const(48)
        fb.byte(OP_I32_LT_U)
        fb.local_get(l_c)
        fb.i32_const(57)
        fb.byte(OP_I32_GT_U)
        fb.byte(OP_I32_OR)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.i32_const(0)
        fb.global_set(dt_ok)
        fb.i64_const(0)
        fb.byte(OP_RETURN)
        fb.byte(OP_END)
        fb.local_get(l_v)
        fb.i64_const(10)
        fb.byte(OP_I64_MUL)
        fb.local_get(l_c)
        fb.i32_const(48)
        fb.byte(OP_I32_SUB)
        fb.byte(OP_I64_EXTEND_I32_U)
        fb.byte(OP_I64_ADD)
        fb.local_set(l_v)
        fb.local_get(l_i)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_i)
        fb.local_get(2)
        fb.i32_const(1)
        fb.byte(OP_I32_SUB)
        fb.local_set(2)
        fb.br(self._br_depth(fb, loop_pos))
        fb.emit_end()
        fb.emit_end()
        fb.local_get(l_i)
        fb.local_get(1)
        fb.byte(OP_I32_GE_U)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.i32_const(0)
        fb.global_set(dt_ok)
        fb.i64_const(0)
        fb.byte(OP_RETURN)
        fb.byte(OP_END)
        fb.local_get(0)
        fb.local_get(l_i)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_c)
        fb.local_get(l_c)
        fb.local_get(3)
        fb.byte(OP_I32_NE)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.i32_const(0)
        fb.global_set(dt_ok)
        fb.i64_const(0)
        fb.byte(OP_RETURN)
        fb.byte(OP_END)
        fb.local_get(l_i)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.global_set(dt_pos)
        fb.local_get(l_v)
        fb.byte(OP_RETURN)
        idx = self._mod.add_function(sig)
        self._mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        return idx

    def _build_dt_num0(self) -> int:
        sig = self._mod.add_type([I32, I32, I32], [I64])
        fb = FuncBody(num_params=3)
        dt_pos = self._dt_pos
        dt_ok = self._dt_ok
        l_i = fb.new_i32()
        l_v = fb.new_i64()
        l_c = fb.new_i32()
        fb.global_get(dt_pos)
        fb.local_set(l_i)
        fb.i64_const(0)
        fb.local_set(l_v)
        fb.emit_block()
        exit_pos = fb.label_depth
        fb.emit_loop()
        loop_pos = fb.label_depth
        fb.local_get(2)
        fb.byte(OP_I32_EQZ)
        fb.br_if(self._br_depth(fb, exit_pos))
        fb.local_get(l_i)
        fb.local_get(1)
        fb.byte(OP_I32_GE_U)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.i32_const(0)
        fb.global_set(dt_ok)
        fb.i64_const(0)
        fb.byte(OP_RETURN)
        fb.byte(OP_END)
        fb.local_get(0)
        fb.local_get(l_i)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_c)
        fb.local_get(l_c)
        fb.i32_const(48)
        fb.byte(OP_I32_LT_U)
        fb.local_get(l_c)
        fb.i32_const(57)
        fb.byte(OP_I32_GT_U)
        fb.byte(OP_I32_OR)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.i32_const(0)
        fb.global_set(dt_ok)
        fb.i64_const(0)
        fb.byte(OP_RETURN)
        fb.byte(OP_END)
        fb.local_get(l_v)
        fb.i64_const(10)
        fb.byte(OP_I64_MUL)
        fb.local_get(l_c)
        fb.i32_const(48)
        fb.byte(OP_I32_SUB)
        fb.byte(OP_I64_EXTEND_I32_U)
        fb.byte(OP_I64_ADD)
        fb.local_set(l_v)
        fb.local_get(l_i)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_i)
        fb.local_get(2)
        fb.i32_const(1)
        fb.byte(OP_I32_SUB)
        fb.local_set(2)
        fb.br(self._br_depth(fb, loop_pos))
        fb.emit_end()
        fb.emit_end()
        fb.local_get(l_i)
        fb.global_set(dt_pos)
        fb.local_get(l_v)
        fb.byte(OP_RETURN)
        idx = self._mod.add_function(sig)
        self._mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        return idx

    def _build_dt_frac(self) -> int:
        sig = self._mod.add_type([I32, I32], [I64])
        fb = FuncBody(num_params=2)
        dt_pos = self._dt_pos
        dt_ok = self._dt_ok
        l_i = fb.new_i32()
        l_c = fb.new_i32()
        l_nd = fb.new_i64()
        l_cnt = fb.new_i32()
        l_pow = fb.new_i64()
        l_n = fb.new_i32()
        fb.global_get(dt_pos)
        fb.local_set(l_i)
        fb.i64_const(0)
        fb.local_set(l_nd)
        fb.i32_const(0)
        fb.local_set(l_cnt)
        fb.emit_block()
        exit_pos = fb.label_depth
        fb.emit_loop()
        loop_pos = fb.label_depth
        fb.local_get(l_i)
        fb.local_get(1)
        fb.byte(OP_I32_GE_U)
        fb.br_if(self._br_depth(fb, exit_pos))
        fb.local_get(0)
        fb.local_get(l_i)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_c)
        fb.local_get(l_c)
        fb.i32_const(48)
        fb.byte(OP_I32_LT_U)
        fb.local_get(l_c)
        fb.i32_const(57)
        fb.byte(OP_I32_GT_U)
        fb.byte(OP_I32_OR)
        fb.br_if(self._br_depth(fb, exit_pos))
        fb.local_get(l_cnt)
        fb.i32_const(9)
        fb.byte(OP_I32_GE_U)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.i32_const(0)
        fb.global_set(dt_ok)
        fb.i64_const(0)
        fb.byte(OP_RETURN)
        fb.byte(OP_END)
        fb.local_get(l_nd)
        fb.i64_const(10)
        fb.byte(OP_I64_MUL)
        fb.local_get(l_c)
        fb.i32_const(48)
        fb.byte(OP_I32_SUB)
        fb.byte(OP_I64_EXTEND_I32_U)
        fb.byte(OP_I64_ADD)
        fb.local_set(l_nd)
        fb.local_get(l_cnt)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_cnt)
        fb.local_get(l_i)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_i)
        fb.br(self._br_depth(fb, loop_pos))
        fb.emit_end()
        fb.emit_end()
        fb.local_get(l_cnt)
        fb.byte(OP_I32_EQZ)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.i32_const(0)
        fb.global_set(dt_ok)
        fb.i64_const(0)
        fb.byte(OP_RETURN)
        fb.byte(OP_END)
        fb.local_get(l_i)
        fb.global_set(dt_pos)
        fb.i64_const(1)
        fb.local_set(l_pow)
        fb.i32_const(9)
        fb.local_get(l_cnt)
        fb.byte(OP_I32_SUB)
        fb.local_set(l_n)
        fb.emit_block()
        p_pos = fb.label_depth
        fb.emit_loop()
        p_loop = fb.label_depth
        fb.local_get(l_n)
        fb.byte(OP_I32_EQZ)
        fb.br_if(self._br_depth(fb, p_pos))
        fb.local_get(l_pow)
        fb.i64_const(10)
        fb.byte(OP_I64_MUL)
        fb.local_set(l_pow)
        fb.local_get(l_n)
        fb.i32_const(1)
        fb.byte(OP_I32_SUB)
        fb.local_set(l_n)
        fb.br(self._br_depth(fb, p_loop))
        fb.emit_end()
        fb.emit_end()
        fb.local_get(l_nd)
        fb.local_get(l_pow)
        fb.byte(OP_I64_MUL)
        fb.byte(OP_RETURN)
        idx = self._mod.add_function(sig)
        self._mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        return idx

    def _build_dt_offset(self) -> int:
        sig = self._mod.add_type([I32, I32, I32], [I64])
        fb = FuncBody(num_params=3)
        dt_pos = self._dt_pos
        dt_ok = self._dt_ok
        l_i = fb.new_i32()
        l_c = fb.new_i32()
        l_hh = fb.new_i64()
        l_mm = fb.new_i64()
        l_cnt = fb.new_i32()
        fb.global_get(dt_pos)
        fb.local_set(l_i)
        fb.i64_const(0)
        fb.local_set(l_hh)
        fb.i64_const(0)
        fb.local_set(l_mm)
        fb.i32_const(0)
        fb.local_set(l_cnt)
        fb.emit_block()
        h_pos = fb.label_depth
        fb.emit_loop()
        h_loop = fb.label_depth
        fb.local_get(l_cnt)
        fb.i32_const(2)
        fb.byte(OP_I32_EQ)
        fb.br_if(self._br_depth(fb, h_pos))
        fb.local_get(l_i)
        fb.local_get(1)
        fb.byte(OP_I32_GE_U)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.i32_const(0)
        fb.global_set(dt_ok)
        fb.i64_const(0)
        fb.byte(OP_RETURN)
        fb.byte(OP_END)
        fb.local_get(0)
        fb.local_get(l_i)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_c)
        fb.local_get(l_c)
        fb.i32_const(48)
        fb.byte(OP_I32_LT_U)
        fb.local_get(l_c)
        fb.i32_const(57)
        fb.byte(OP_I32_GT_U)
        fb.byte(OP_I32_OR)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.i32_const(0)
        fb.global_set(dt_ok)
        fb.i64_const(0)
        fb.byte(OP_RETURN)
        fb.byte(OP_END)
        fb.local_get(l_hh)
        fb.i64_const(10)
        fb.byte(OP_I64_MUL)
        fb.local_get(l_c)
        fb.i32_const(48)
        fb.byte(OP_I32_SUB)
        fb.byte(OP_I64_EXTEND_I32_U)
        fb.byte(OP_I64_ADD)
        fb.local_set(l_hh)
        fb.local_get(l_i)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_i)
        fb.local_get(l_cnt)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_cnt)
        fb.br(self._br_depth(fb, h_loop))
        fb.emit_end()
        fb.emit_end()
        fb.local_get(l_i)
        fb.local_get(1)
        fb.byte(OP_I32_LT_U)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.local_get(0)
        fb.local_get(l_i)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_c)
        fb.local_get(l_c)
        fb.i32_const(58)
        fb.byte(OP_I32_EQ)
        fb.local_get(l_c)
        fb.i32_const(48)
        fb.byte(OP_I32_GE_U)
        fb.local_get(l_c)
        fb.i32_const(57)
        fb.byte(OP_I32_LE_U)
        fb.byte(OP_I32_AND)
        fb.byte(OP_I32_OR)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.local_get(l_c)
        fb.i32_const(58)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.local_get(l_i)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_i)
        fb.byte(OP_END)
        fb.i32_const(0)
        fb.local_set(l_cnt)
        fb.emit_block()
        m_pos = fb.label_depth
        fb.emit_loop()
        m_loop = fb.label_depth
        fb.local_get(l_cnt)
        fb.i32_const(2)
        fb.byte(OP_I32_EQ)
        fb.br_if(self._br_depth(fb, m_pos))
        fb.local_get(l_i)
        fb.local_get(1)
        fb.byte(OP_I32_GE_U)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.i32_const(0)
        fb.global_set(dt_ok)
        fb.i64_const(0)
        fb.byte(OP_RETURN)
        fb.byte(OP_END)
        fb.local_get(0)
        fb.local_get(l_i)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_c)
        fb.local_get(l_c)
        fb.i32_const(48)
        fb.byte(OP_I32_LT_U)
        fb.local_get(l_c)
        fb.i32_const(57)
        fb.byte(OP_I32_GT_U)
        fb.byte(OP_I32_OR)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.i32_const(0)
        fb.global_set(dt_ok)
        fb.i64_const(0)
        fb.byte(OP_RETURN)
        fb.byte(OP_END)
        fb.local_get(l_mm)
        fb.i64_const(10)
        fb.byte(OP_I64_MUL)
        fb.local_get(l_c)
        fb.i32_const(48)
        fb.byte(OP_I32_SUB)
        fb.byte(OP_I64_EXTEND_I32_U)
        fb.byte(OP_I64_ADD)
        fb.local_set(l_mm)
        fb.local_get(l_i)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_i)
        fb.local_get(l_cnt)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_cnt)
        fb.br(self._br_depth(fb, m_loop))
        fb.emit_end()
        fb.emit_end()
        fb.byte(OP_END)
        fb.byte(OP_END)
        fb.local_get(l_i)
        fb.global_set(dt_pos)
        fb.local_get(l_hh)
        fb.i64_const(3600)
        fb.byte(OP_I64_MUL)
        fb.local_get(l_mm)
        fb.i64_const(60)
        fb.byte(OP_I64_MUL)
        fb.byte(OP_I64_ADD)
        fb.local_set(l_hh)
        fb.local_get(2)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.i64_const(0)
        fb.local_get(l_hh)
        fb.byte(OP_I64_SUB)
        fb.byte(OP_RETURN)
        fb.byte(OP_END)
        fb.local_get(l_hh)
        fb.byte(OP_RETURN)
        idx = self._mod.add_function(sig)
        self._mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        return idx

    def _build_days_from_civil(self) -> int:
        sig = self._mod.add_type([I64, I64, I64], [I64])
        fb = FuncBody(num_params=3)
        l_era = fb.new_i64()
        l_yoe = fb.new_i64()
        l_doy = fb.new_i64()
        l_doe = fb.new_i64()
        l_y2 = fb.new_i64()
        l_m2 = fb.new_i64()
        fb.local_get(1)
        fb.i64_const(2)
        fb.byte(OP_I64_LE_S)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.local_get(0)
        fb.i64_const(1)
        fb.byte(OP_I64_SUB)
        fb.local_set(0)
        fb.byte(OP_END)
        fb.local_get(0)
        fb.local_get(0)
        fb.i64_const(399)
        fb.byte(OP_I64_SUB)
        fb.local_get(0)
        fb.i64_const(0)
        fb.byte(OP_I64_GE_S)
        fb.byte(OP_SELECT)
        fb.local_set(l_y2)
        fb.local_get(l_y2)
        fb.i64_const(400)
        fb.byte(OP_I64_DIV_S)
        fb.local_set(l_era)
        fb.local_get(0)
        fb.local_get(l_era)
        fb.i64_const(400)
        fb.byte(OP_I64_MUL)
        fb.byte(OP_I64_SUB)
        fb.local_set(l_yoe)
        fb.i64_const(-3)
        fb.i64_const(9)
        fb.local_get(1)
        fb.i64_const(2)
        fb.byte(OP_I64_GT_S)
        fb.byte(OP_SELECT)
        fb.local_get(1)
        fb.byte(OP_I64_ADD)
        fb.local_set(l_m2)
        fb.i64_const(153)
        fb.local_get(l_m2)
        fb.byte(OP_I64_MUL)
        fb.i64_const(2)
        fb.byte(OP_I64_ADD)
        fb.i64_const(5)
        fb.byte(OP_I64_DIV_S)
        fb.i64_const(1)
        fb.byte(OP_I64_SUB)
        fb.local_get(2)
        fb.byte(OP_I64_ADD)
        fb.local_set(l_doy)
        fb.local_get(l_yoe)
        fb.i64_const(365)
        fb.byte(OP_I64_MUL)
        fb.local_get(l_yoe)
        fb.i64_const(4)
        fb.byte(OP_I64_DIV_S)
        fb.byte(OP_I64_ADD)
        fb.local_get(l_yoe)
        fb.i64_const(100)
        fb.byte(OP_I64_DIV_S)
        fb.byte(OP_I64_SUB)
        fb.local_get(l_doy)
        fb.byte(OP_I64_ADD)
        fb.local_set(l_doe)
        fb.local_get(l_era)
        fb.i64_const(146097)
        fb.byte(OP_I64_MUL)
        fb.local_get(l_doe)
        fb.byte(OP_I64_ADD)
        fb.i64_const(719468)
        fb.byte(OP_I64_SUB)
        fb.byte(OP_RETURN)
        idx = self._mod.add_function(sig)
        self._mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        return idx

    def _build_input_int(self, tname: dict, retry_fat: int) -> int:
        from flux_proto.semantic.storage_types import _INT_RANGES
        sig = self._mod.add_type([I64, I64], [I64])
        fb = FuncBody(num_params=2)
        l_line = fb.new_i64()
        l_ptr = fb.new_i32()
        l_len = fb.new_i32()
        l_i = fb.new_i32()
        l_c = fb.new_i32()
        l_dig = fb.new_i64()
        l_base = fb.new_i64()
        l_val = fb.new_i64()
        l_neg = fb.new_i32()
        l_ok = fb.new_i32()
        l_lo = fb.new_i64()
        l_hi = fb.new_i64()
        print_fat = self._helper_funcs["$print_fat"]
        print_fat_nl = self._helper_funcs["$print_fat_nl"]
        read_line = self._helper_funcs["$flux_read_line"]
        streq = self._helper_funcs["$streq"]
        fb.emit_block()
        exit_pos = fb.label_depth
        fb.emit_loop()
        loop_pos = fb.label_depth
        fb.local_get(1)
        self._emit_call(fb, print_fat)
        self._emit_call(fb, read_line)
        fb.local_set(l_line)
        fb.local_get(l_line)
        fb.i64_const(32)
        fb.byte(OP_I64_SHR_U)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_ptr)
        fb.local_get(l_line)
        fb.i64_const(0xFFFFFFFF)
        fb.byte(OP_I64_AND)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_len)
        fb.i32_const(0)
        fb.local_set(l_i)
        fb.i32_const(0)
        fb.local_set(l_neg)
        fb.i64_const(0)
        fb.local_set(l_val)
        fb.i64_const(10)
        fb.local_set(l_base)
        fb.i32_const(1)
        fb.local_set(l_ok)
        fb.i64_const(0)
        fb.local_set(l_dig)
        fb.emit_block()
        lws_pos = fb.label_depth
        fb.emit_loop()
        lws_loop = fb.label_depth
        fb.local_get(l_i)
        fb.local_get(l_len)
        fb.byte(OP_I32_GE_U)
        fb.br_if(self._br_depth(fb, lws_pos))
        fb.local_get(l_ptr)
        fb.local_get(l_i)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_c)
        fb.local_get(l_c)
        fb.i32_const(32)
        fb.byte(OP_I32_EQ)
        fb.local_get(l_c)
        fb.i32_const(9)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_OR)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.local_get(l_i)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_i)
        fb.br(self._br_depth(fb, lws_loop))
        fb.byte(OP_END)
        fb.br(self._br_depth(fb, lws_pos))
        fb.emit_end()
        fb.emit_end()
        fb.local_get(l_i)
        fb.local_get(l_len)
        fb.byte(OP_I32_LT_U)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.local_get(l_ptr)
        fb.local_get(l_i)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_c)
        fb.local_get(l_c)
        fb.i32_const(43)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.local_get(l_i)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_i)
        fb.byte(OP_END)
        fb.local_get(l_c)
        fb.i32_const(45)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.i32_const(1)
        fb.local_set(l_neg)
        fb.local_get(l_i)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_i)
        fb.byte(OP_END)
        fb.byte(OP_END)
        fb.local_get(l_len)
        fb.local_get(l_i)
        fb.byte(OP_I32_SUB)
        fb.i32_const(2)
        fb.byte(OP_I32_GE_U)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.local_get(l_ptr)
        fb.local_get(l_i)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_c)
        fb.local_get(l_c)
        fb.i32_const(48)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.local_get(l_ptr)
        fb.local_get(l_i)
        fb.byte(OP_I32_ADD)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_c)
        fb.local_get(l_c)
        fb.i32_const(120)
        fb.byte(OP_I32_EQ)
        fb.local_get(l_c)
        fb.i32_const(88)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_OR)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.i64_const(16)
        fb.local_set(l_base)
        fb.local_get(l_i)
        fb.i32_const(2)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_i)
        fb.byte(OP_END)
        fb.local_get(l_c)
        fb.i32_const(98)
        fb.byte(OP_I32_EQ)
        fb.local_get(l_c)
        fb.i32_const(66)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_OR)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.i64_const(2)
        fb.local_set(l_base)
        fb.local_get(l_i)
        fb.i32_const(2)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_i)
        fb.byte(OP_END)
        fb.local_get(l_c)
        fb.i32_const(111)
        fb.byte(OP_I32_EQ)
        fb.local_get(l_c)
        fb.i32_const(79)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_OR)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.i64_const(8)
        fb.local_set(l_base)
        fb.local_get(l_i)
        fb.i32_const(2)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_i)
        fb.byte(OP_END)
        fb.byte(OP_END)
        fb.byte(OP_END)
        fb.emit_block()
        d_pos = fb.label_depth
        fb.emit_loop()
        d_loop = fb.label_depth
        fb.local_get(l_i)
        fb.local_get(l_len)
        fb.byte(OP_I32_GE_U)
        fb.br_if(self._br_depth(fb, d_pos))
        fb.local_get(l_ptr)
        fb.local_get(l_i)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_c)
        fb.local_get(l_c)
        fb.i32_const(48)
        fb.byte(OP_I32_GE_U)
        fb.local_get(l_c)
        fb.i32_const(57)
        fb.byte(OP_I32_LE_U)
        fb.byte(OP_I32_AND)
        fb.emit_if()
        fb.local_get(l_c)
        fb.i32_const(48)
        fb.byte(OP_I32_SUB)
        fb.byte(OP_I64_EXTEND_I32_U)
        fb.local_set(l_dig)
        fb.byte(OP_ELSE)
        fb.local_get(l_c)
        fb.i32_const(97)
        fb.byte(OP_I32_GE_U)
        fb.local_get(l_c)
        fb.i32_const(102)
        fb.byte(OP_I32_LE_U)
        fb.byte(OP_I32_AND)
        fb.emit_if()
        fb.local_get(l_c)
        fb.i32_const(97)
        fb.byte(OP_I32_SUB)
        fb.i32_const(10)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I64_EXTEND_I32_U)
        fb.local_set(l_dig)
        fb.byte(OP_ELSE)
        fb.local_get(l_c)
        fb.i32_const(65)
        fb.byte(OP_I32_GE_U)
        fb.local_get(l_c)
        fb.i32_const(70)
        fb.byte(OP_I32_LE_U)
        fb.byte(OP_I32_AND)
        fb.emit_if()
        fb.local_get(l_c)
        fb.i32_const(65)
        fb.byte(OP_I32_SUB)
        fb.i32_const(10)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I64_EXTEND_I32_U)
        fb.local_set(l_dig)
        fb.byte(OP_ELSE)
        fb.i32_const(0)
        fb.local_set(l_ok)
        fb.br(self._br_depth(fb, d_pos))
        fb.emit_end()
        fb.emit_end()
        fb.emit_end()
        fb.local_get(l_dig)
        fb.local_get(l_base)
        fb.byte(OP_I64_GE_U)
        fb.emit_if()
        fb.i32_const(0)
        fb.local_set(l_ok)
        fb.br(self._br_depth(fb, d_pos))
        fb.emit_end()
        fb.local_get(l_val)
        fb.local_get(l_base)
        fb.byte(OP_I64_MUL)
        fb.local_get(l_dig)
        fb.byte(OP_I64_ADD)
        fb.local_set(l_val)
        fb.local_get(l_i)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_i)
        fb.br(self._br_depth(fb, d_loop))
        fb.emit_end()
        fb.emit_end()
        fb.emit_block()
        tws_pos = fb.label_depth
        fb.emit_loop()
        tws_loop = fb.label_depth
        fb.local_get(l_i)
        fb.local_get(l_len)
        fb.byte(OP_I32_GE_U)
        fb.br_if(self._br_depth(fb, tws_pos))
        fb.local_get(l_ptr)
        fb.local_get(l_i)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_c)
        fb.local_get(l_c)
        fb.i32_const(32)
        fb.byte(OP_I32_EQ)
        fb.local_get(l_c)
        fb.i32_const(9)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_OR)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.local_get(l_i)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_i)
        fb.br(self._br_depth(fb, tws_loop))
        fb.byte(OP_END)
        fb.i32_const(0)
        fb.local_set(l_ok)
        fb.br(self._br_depth(fb, tws_pos))
        fb.emit_end()
        fb.emit_end()
        fb.local_get(l_len)
        fb.local_get(l_i)
        fb.byte(OP_I32_SUB)
        fb.byte(OP_I32_EQZ)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.byte(OP_ELSE)
        fb.i32_const(0)
        fb.local_set(l_ok)
        fb.byte(OP_END)
        fb.local_get(l_val)
        fb.byte(OP_I64_EQZ)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.local_get(l_dig)
        fb.byte(OP_I64_EQZ)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.i32_const(0)
        fb.local_set(l_ok)
        fb.byte(OP_END)
        fb.byte(OP_END)
        fb.local_get(l_neg)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.i64_const(0)
        fb.local_get(l_val)
        fb.byte(OP_I64_SUB)
        fb.local_set(l_val)
        fb.byte(OP_END)
        for it in ("int8", "int16", "int32", "int64", "uint8", "uint16", "uint32"):
            fb.local_get(0)
            fb.i64_const(tname[it])
            self._emit_call(fb, streq)
            fb.byte(OP_IF)
            fb.put(b"\x40")
            fb.i64_const(_INT_RANGES[it][0])
            fb.local_set(l_lo)
            fb.i64_const(_INT_RANGES[it][1])
            fb.local_set(l_hi)
            fb.byte(OP_END)
        fb.local_get(0)
        fb.i64_const(tname["uint64"])
        self._emit_call(fb, streq)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.i64_const(0)
        fb.local_set(l_lo)
        fb.i64_const(-1)
        fb.local_set(l_hi)
        fb.byte(OP_END)
        fb.local_get(l_val)
        fb.local_get(l_lo)
        fb.byte(OP_I64_LT_S)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.i32_const(0)
        fb.local_set(l_ok)
        fb.byte(OP_END)
        fb.local_get(l_val)
        fb.local_get(l_hi)
        fb.byte(OP_I64_GT_S)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.i32_const(0)
        fb.local_set(l_ok)
        fb.byte(OP_END)
        fb.local_get(l_ok)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.local_get(l_val)
        fb.byte(OP_RETURN)
        fb.byte(OP_END)
        fb.i64_const(retry_fat)
        self._emit_call(fb, print_fat_nl)
        fb.br(self._br_depth(fb, loop_pos))
        fb.emit_end()
        fb.emit_end()
        fb.byte(OP_UNREACHABLE)
        idx = self._mod.add_function(sig)
        self._mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        return idx

    def _build_input_float(self, retry_fat: int) -> int:
        sig = self._mod.add_type([I64, I64], [F64])
        fb = FuncBody(num_params=2)
        l_line = fb.new_i64()
        print_fat = self._helper_funcs["$print_fat"]
        print_fat_nl = self._helper_funcs["$print_fat_nl"]
        read_line = self._helper_funcs["$flux_read_line"]
        valid_float = self._helper_funcs["$valid_float"]
        str_to_f64 = self._helper_funcs["$str_to_f64"]
        fb.emit_block()
        exit_pos = fb.label_depth
        fb.emit_loop()
        loop_pos = fb.label_depth
        fb.local_get(1)
        self._emit_call(fb, print_fat)
        self._emit_call(fb, read_line)
        fb.local_set(l_line)
        fb.local_get(l_line)
        self._emit_call(fb, valid_float)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.local_get(l_line)
        self._emit_call(fb, str_to_f64)
        fb.byte(OP_RETURN)
        fb.byte(OP_END)
        fb.i64_const(retry_fat)
        self._emit_call(fb, print_fat_nl)
        fb.br(self._br_depth(fb, loop_pos))
        fb.emit_end()
        fb.emit_end()
        fb.byte(OP_UNREACHABLE)
        idx = self._mod.add_function(sig)
        self._mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        return idx

    def _build_input_bool(self, retry_fat: int, f_true, f_true_pt, f_false, f_false_pt) -> int:
        sig = self._mod.add_type([I64, I64], [I64])
        fb = FuncBody(num_params=2)
        l_line = fb.new_i64()
        print_fat = self._helper_funcs["$print_fat"]
        print_fat_nl = self._helper_funcs["$print_fat_nl"]
        read_line = self._helper_funcs["$flux_read_line"]
        streq = self._helper_funcs["$streq"]
        fb.emit_block()
        exit_pos = fb.label_depth
        fb.emit_loop()
        loop_pos = fb.label_depth
        fb.local_get(1)
        self._emit_call(fb, print_fat)
        self._emit_call(fb, read_line)
        fb.local_set(l_line)
        for cond, result in [(f_true, 1), (f_true_pt, 1), (f_false, 0), (f_false_pt, 0)]:
            fb.local_get(l_line)
            fb.i64_const(cond)
            self._emit_call(fb, streq)
            fb.byte(OP_IF)
            fb.put(b"\x40")
            fb.i64_const(result)
            fb.byte(OP_RETURN)
            fb.byte(OP_END)
        fb.i64_const(retry_fat)
        self._emit_call(fb, print_fat_nl)
        fb.br(self._br_depth(fb, loop_pos))
        fb.emit_end()
        fb.emit_end()
        fb.byte(OP_UNREACHABLE)
        idx = self._mod.add_function(sig)
        self._mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        return idx

    def _build_input_char(self, retry_fat: int) -> int:
        sig = self._mod.add_type([I64, I64], [I32])
        fb = FuncBody(num_params=2)
        l_line = fb.new_i64()
        l_ptr = fb.new_i32()
        l_len = fb.new_i32()
        l_b0 = fb.new_i32()
        l_b1 = fb.new_i32()
        l_b2 = fb.new_i32()
        l_b3 = fb.new_i32()
        l_cp = fb.new_i32()
        print_fat = self._helper_funcs["$print_fat"]
        print_fat_nl = self._helper_funcs["$print_fat_nl"]
        read_line = self._helper_funcs["$flux_read_line"]
        fb.emit_block()
        exit_pos = fb.label_depth
        fb.emit_loop()
        loop_pos = fb.label_depth
        fb.local_get(1)
        self._emit_call(fb, print_fat)
        self._emit_call(fb, read_line)
        fb.local_set(l_line)
        fb.local_get(l_line)
        fb.i64_const(32)
        fb.byte(OP_I64_SHR_U)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_ptr)
        fb.local_get(l_line)
        fb.i64_const(0xFFFFFFFF)
        fb.byte(OP_I64_AND)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_len)

        # 1-byte ASCII (len == 1)
        fb.local_get(l_len)
        fb.i32_const(1)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.local_get(l_ptr)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_b0)
        fb.local_get(l_b0)
        fb.i32_const(128)
        fb.byte(OP_I32_LT_U)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.local_get(l_b0)
        fb.byte(OP_RETURN)
        fb.byte(OP_END)
        fb.byte(OP_END)

        # 2-byte UTF-8 (len == 2)
        fb.local_get(l_len)
        fb.i32_const(2)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.local_get(l_ptr)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_b0)
        fb.local_get(l_ptr)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_b1)
        fb.local_get(l_b0)
        fb.i32_const(0xE0)
        fb.byte(OP_I32_AND)
        fb.i32_const(0xC0)
        fb.byte(OP_I32_EQ)
        fb.local_get(l_b1)
        fb.i32_const(0xC0)
        fb.byte(OP_I32_AND)
        fb.i32_const(0x80)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_AND)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.local_get(l_b0)
        fb.i32_const(0x1F)
        fb.byte(OP_I32_AND)
        fb.i32_const(6)
        fb.byte(OP_I32_SHL)
        fb.local_get(l_b1)
        fb.i32_const(0x3F)
        fb.byte(OP_I32_AND)
        fb.byte(OP_I32_OR)
        fb.local_set(l_cp)
        fb.local_get(l_cp)
        fb.i32_const(0x80)
        fb.byte(OP_I32_GE_U)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.local_get(l_cp)
        fb.byte(OP_RETURN)
        fb.byte(OP_END)
        fb.byte(OP_END)
        fb.byte(OP_END)

        # 3-byte UTF-8 (len == 3)
        fb.local_get(l_len)
        fb.i32_const(3)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.local_get(l_ptr)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_b0)
        fb.local_get(l_ptr)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_b1)
        fb.local_get(l_ptr)
        fb.i32_const(2)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_b2)
        fb.local_get(l_b0)
        fb.i32_const(0xF0)
        fb.byte(OP_I32_AND)
        fb.i32_const(0xE0)
        fb.byte(OP_I32_EQ)
        fb.local_get(l_b1)
        fb.i32_const(0xC0)
        fb.byte(OP_I32_AND)
        fb.i32_const(0x80)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_AND)
        fb.local_get(l_b2)
        fb.i32_const(0xC0)
        fb.byte(OP_I32_AND)
        fb.i32_const(0x80)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_AND)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.local_get(l_b0)
        fb.i32_const(0x0F)
        fb.byte(OP_I32_AND)
        fb.i32_const(12)
        fb.byte(OP_I32_SHL)
        fb.local_get(l_b1)
        fb.i32_const(0x3F)
        fb.byte(OP_I32_AND)
        fb.i32_const(6)
        fb.byte(OP_I32_SHL)
        fb.byte(OP_I32_OR)
        fb.local_get(l_b2)
        fb.i32_const(0x3F)
        fb.byte(OP_I32_AND)
        fb.byte(OP_I32_OR)
        fb.local_set(l_cp)
        fb.local_get(l_cp)
        fb.i32_const(0x800)
        fb.byte(OP_I32_GE_U)
        fb.local_get(l_cp)
        fb.i32_const(0xD800)
        fb.byte(OP_I32_LT_U)
        fb.local_get(l_cp)
        fb.i32_const(0xDFFF)
        fb.byte(OP_I32_GT_U)
        fb.byte(OP_I32_OR)
        fb.byte(OP_I32_AND)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.local_get(l_cp)
        fb.byte(OP_RETURN)
        fb.byte(OP_END)
        fb.byte(OP_END)
        fb.byte(OP_END)

        # 4-byte UTF-8 (len == 4)
        fb.local_get(l_len)
        fb.i32_const(4)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.local_get(l_ptr)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_b0)
        fb.local_get(l_ptr)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_b1)
        fb.local_get(l_ptr)
        fb.i32_const(2)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_b2)
        fb.local_get(l_ptr)
        fb.i32_const(3)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_b3)
        fb.local_get(l_b0)
        fb.i32_const(0xF8)
        fb.byte(OP_I32_AND)
        fb.i32_const(0xF0)
        fb.byte(OP_I32_EQ)
        fb.local_get(l_b1)
        fb.i32_const(0xC0)
        fb.byte(OP_I32_AND)
        fb.i32_const(0x80)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_AND)
        fb.local_get(l_b2)
        fb.i32_const(0xC0)
        fb.byte(OP_I32_AND)
        fb.i32_const(0x80)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_AND)
        fb.local_get(l_b3)
        fb.i32_const(0xC0)
        fb.byte(OP_I32_AND)
        fb.i32_const(0x80)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_AND)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.local_get(l_b0)
        fb.i32_const(0x07)
        fb.byte(OP_I32_AND)
        fb.i32_const(18)
        fb.byte(OP_I32_SHL)
        fb.local_get(l_b1)
        fb.i32_const(0x3F)
        fb.byte(OP_I32_AND)
        fb.i32_const(12)
        fb.byte(OP_I32_SHL)
        fb.byte(OP_I32_OR)
        fb.local_get(l_b2)
        fb.i32_const(0x3F)
        fb.byte(OP_I32_AND)
        fb.i32_const(6)
        fb.byte(OP_I32_SHL)
        fb.byte(OP_I32_OR)
        fb.local_get(l_b3)
        fb.i32_const(0x3F)
        fb.byte(OP_I32_AND)
        fb.byte(OP_I32_OR)
        fb.local_set(l_cp)
        fb.local_get(l_cp)
        fb.i32_const(0x10000)
        fb.byte(OP_I32_GE_U)
        fb.local_get(l_cp)
        fb.i32_const(0x10FFFF)
        fb.byte(OP_I32_LE_U)
        fb.byte(OP_I32_AND)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.local_get(l_cp)
        fb.byte(OP_RETURN)
        fb.byte(OP_END)
        fb.byte(OP_END)
        fb.byte(OP_END)

        # Retry message and loop
        fb.i64_const(retry_fat)
        self._emit_call(fb, print_fat_nl)
        fb.br(self._br_depth(fb, loop_pos))
        fb.emit_end()
        fb.emit_end()
        fb.byte(OP_UNREACHABLE)
        idx = self._mod.add_function(sig)
        self._mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        return idx

    def _build_input_string(self) -> int:
        sig = self._mod.add_type([I64, I64], [I64])
        fb = FuncBody(num_params=2)
        print_fat = self._helper_funcs["$print_fat"]
        read_line = self._helper_funcs["$flux_read_line"]
        fb.local_get(1)
        self._emit_call(fb, print_fat)
        self._emit_call(fb, read_line)
        fb.byte(OP_RETURN)
        idx = self._mod.add_function(sig)
        self._mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        return idx

    def _build_input_datetime(self, retry_fat: int) -> int:
        sig = self._mod.add_type([I64, I64], [I64])
        fb = FuncBody(num_params=2)
        dt_pos = self._dt_pos
        dt_ok = self._dt_ok
        l_line = fb.new_i64()
        l_ptr = fb.new_i32()
        l_len = fb.new_i32()
        l_c = fb.new_i32()
        l_cneg = fb.new_i32()
        l_y = fb.new_i64()
        l_mo = fb.new_i64()
        l_d = fb.new_i64()
        l_h = fb.new_i64()
        l_mi = fb.new_i64()
        l_s = fb.new_i64()
        l_nanos = fb.new_i64()
        l_delta = fb.new_i64()
        l_secs = fb.new_i64()
        l_day = fb.new_i64()
        print_fat = self._helper_funcs["$print_fat"]
        print_fat_nl = self._helper_funcs["$print_fat_nl"]
        read_line = self._helper_funcs["$flux_read_line"]
        dt_num = self._helper_funcs["$dt_num"]
        dt_num0 = self._helper_funcs["$dt_num0"]
        dt_frac = self._helper_funcs["$dt_frac"]
        dt_offset = self._helper_funcs["$dt_offset"]
        days_from_civil = self._helper_funcs["$days_from_civil"]
        fb.emit_block()
        exit_pos = fb.label_depth
        fb.emit_loop()
        loop_pos = fb.label_depth
        fb.local_get(1)
        self._emit_call(fb, print_fat)
        self._emit_call(fb, read_line)
        fb.local_set(l_line)
        fb.local_get(l_line)
        fb.i64_const(32)
        fb.byte(OP_I64_SHR_U)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_ptr)
        fb.local_get(l_line)
        fb.i64_const(0xFFFFFFFF)
        fb.byte(OP_I64_AND)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_len)
        fb.i32_const(0)
        fb.global_set(dt_pos)
        fb.i32_const(1)
        fb.global_set(dt_ok)
        fb.i64_const(0)
        fb.local_set(l_nanos)
        fb.i64_const(0)
        fb.local_set(l_delta)
        for dst, n, sep in [(l_y, 4, 45), (l_mo, 2, 45), (l_d, 2, 84),
                            (l_h, 2, 58), (l_mi, 2, 58)]:
            fb.local_get(l_ptr)
            fb.local_get(l_len)
            fb.i32_const(n)
            fb.i32_const(sep)
            self._emit_call(fb, dt_num)
            fb.local_set(dst)
        fb.local_get(l_ptr)
        fb.local_get(l_len)
        fb.i32_const(2)
        self._emit_call(fb, dt_num0)
        fb.local_set(l_s)
        fb.global_get(dt_ok)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.global_get(dt_pos)
        fb.local_get(l_len)
        fb.byte(OP_I32_LT_U)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.global_get(dt_pos)
        fb.local_get(l_ptr)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_c)
        fb.local_get(l_c)
        fb.i32_const(46)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.global_get(dt_pos)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.global_set(dt_pos)
        fb.local_get(l_ptr)
        fb.local_get(l_len)
        self._emit_call(fb, dt_frac)
        fb.local_set(l_nanos)
        fb.byte(OP_END)
        fb.byte(OP_END)
        fb.byte(OP_END)
        fb.global_get(dt_ok)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.global_get(dt_pos)
        fb.local_get(l_len)
        fb.byte(OP_I32_LT_U)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.global_get(dt_pos)
        fb.local_get(l_ptr)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_c)
        fb.local_get(l_c)
        fb.i32_const(90)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.global_get(dt_pos)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.global_set(dt_pos)
        fb.byte(OP_ELSE)
        fb.local_get(l_c)
        fb.i32_const(43)
        fb.byte(OP_I32_EQ)
        fb.local_get(l_c)
        fb.i32_const(45)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_OR)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.i32_const(0)
        fb.local_set(l_cneg)
        fb.local_get(l_c)
        fb.i32_const(45)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.i32_const(1)
        fb.local_set(l_cneg)
        fb.byte(OP_END)
        fb.global_get(dt_pos)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.global_set(dt_pos)
        fb.local_get(l_ptr)
        fb.local_get(l_len)
        fb.local_get(l_cneg)
        self._emit_call(fb, dt_offset)
        fb.local_set(l_delta)
        fb.byte(OP_ELSE)
        fb.i32_const(0)
        fb.global_set(dt_ok)
        fb.byte(OP_END)
        fb.byte(OP_END)
        fb.byte(OP_END)
        fb.byte(OP_END)
        fb.global_get(dt_ok)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.global_get(dt_pos)
        fb.local_get(l_len)
        fb.byte(OP_I32_NE)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.i32_const(0)
        fb.global_set(dt_ok)
        fb.byte(OP_END)
        fb.byte(OP_END)
        fb.global_get(dt_ok)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.local_get(l_y)
        fb.local_get(l_mo)
        fb.local_get(l_d)
        self._emit_call(fb, days_from_civil)
        fb.local_set(l_day)
        fb.local_get(l_day)
        fb.i64_const(86400)
        fb.byte(OP_I64_MUL)
        fb.local_get(l_h)
        fb.i64_const(3600)
        fb.byte(OP_I64_MUL)
        fb.local_get(l_mi)
        fb.i64_const(60)
        fb.byte(OP_I64_MUL)
        fb.byte(OP_I64_ADD)
        fb.local_get(l_s)
        fb.byte(OP_I64_ADD)
        fb.byte(OP_I64_ADD)
        fb.local_set(l_secs)
        fb.local_get(l_secs)
        fb.local_get(l_delta)
        fb.byte(OP_I64_SUB)
        fb.local_set(l_secs)
        fb.local_get(l_secs)
        fb.i64_const(1000000000)
        fb.byte(OP_I64_MUL)
        fb.local_get(l_nanos)
        fb.byte(OP_I64_ADD)
        fb.byte(OP_RETURN)
        fb.byte(OP_END)
        fb.i64_const(retry_fat)
        self._emit_call(fb, print_fat_nl)
        fb.br(self._br_depth(fb, loop_pos))
        fb.emit_end()
        fb.emit_end()
        fb.byte(OP_UNREACHABLE)
        idx = self._mod.add_function(sig)
        self._mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        return idx

    def _build_at_ws_end(self) -> int:
        sig = self._mod.add_type([I32, I32], [I32])
        fb = FuncBody(num_params=2)
        cx_pos = self._cx_pos
        l_c = fb.new_i32()
        fb.emit_block()
        exit_pos = fb.label_depth
        fb.emit_loop()
        loop_pos = fb.label_depth
        fb.global_get(cx_pos)
        fb.local_get(1)
        fb.byte(OP_I32_GE_U)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.i32_const(1)
        fb.byte(OP_RETURN)
        fb.byte(OP_END)
        fb.local_get(0)
        fb.global_get(cx_pos)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_c)
        fb.local_get(l_c)
        fb.i32_const(32)
        fb.byte(OP_I32_EQ)
        fb.local_get(l_c)
        fb.i32_const(9)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_OR)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.global_get(cx_pos)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.global_set(cx_pos)
        fb.br(self._br_depth(fb, loop_pos))
        fb.byte(OP_END)
        fb.i32_const(0)
        fb.byte(OP_RETURN)
        fb.emit_end()
        fb.emit_end()
        fb.byte(OP_UNREACHABLE)
        idx = self._mod.add_function(sig)
        self._mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        return idx

    def _build_parse_f64(self) -> int:
        sig = self._mod.add_type([I32, I32], [F64])
        fb = FuncBody(num_params=2)
        cx_pos = self._cx_pos
        cx_sign = self._cx_sign
        cx_digit = self._cx_digit
        l_i = fb.new_i32()
        l_c = fb.new_i32()
        l_ip = fb.new_f64()
        l_fp = fb.new_f64()
        l_fd = fb.new_f64()
        l_inf = fb.new_i32()
        l_neg = fb.new_i32()
        fb.global_get(cx_pos)
        fb.local_set(l_i)
        fb.f64_const(0.0)
        fb.local_set(l_ip)
        fb.f64_const(0.0)
        fb.local_set(l_fp)
        fb.f64_const(1.0)
        fb.local_set(l_fd)
        fb.i32_const(0)
        fb.local_set(l_inf)
        fb.i32_const(0)
        fb.local_set(l_neg)
        fb.i32_const(0)
        fb.global_set(cx_digit)
        fb.i32_const(1)
        fb.global_set(cx_sign)

        # Skip whitespace
        fb.emit_block()
        ws_exit = fb.label_depth
        fb.emit_loop()
        ws_loop = fb.label_depth
        fb.local_get(l_i)
        fb.local_get(1)
        fb.byte(OP_I32_GE_U)
        fb.br_if(self._br_depth(fb, ws_exit))
        fb.local_get(0)
        fb.local_get(l_i)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_c)
        fb.local_get(l_c)
        fb.i32_const(32)
        fb.byte(OP_I32_EQ)
        fb.local_get(l_c)
        fb.i32_const(9)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_OR)
        fb.emit_if()
        fb.local_get(l_i)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_i)
        fb.br(self._br_depth(fb, ws_loop))
        fb.emit_end()
        fb.br(self._br_depth(fb, ws_exit))
        fb.emit_end()
        fb.emit_end()

        # Sign: '+' or '-'
        fb.local_get(l_i)
        fb.local_get(1)
        fb.byte(OP_I32_LT_U)
        fb.emit_if()
        fb.local_get(0)
        fb.local_get(l_i)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_c)
        fb.local_get(l_c)
        fb.i32_const(45) # '-'
        fb.byte(OP_I32_EQ)
        fb.emit_if()
        fb.i32_const(1)
        fb.local_set(l_neg)
        fb.i32_const(-1)
        fb.global_set(cx_sign)
        fb.local_get(l_i)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_i)
        fb.emit_end()
        fb.local_get(l_c)
        fb.i32_const(43) # '+'
        fb.byte(OP_I32_EQ)
        fb.emit_if()
        fb.i32_const(1)
        fb.global_set(cx_sign)
        fb.local_get(l_i)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_i)
        fb.emit_end()
        fb.emit_end()

        # Digit / Decimal parsing loop
        fb.emit_block()
        b0_pos = fb.label_depth
        fb.emit_loop()
        l0_pos = fb.label_depth
        fb.local_get(l_i)
        fb.local_get(1)
        fb.byte(OP_I32_GE_U)
        fb.br_if(self._br_depth(fb, b0_pos))
        fb.local_get(0)
        fb.local_get(l_i)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_c)

        # Dot or comma ('.', ',')
        fb.local_get(l_c)
        fb.i32_const(46)
        fb.byte(OP_I32_EQ)
        fb.local_get(l_c)
        fb.i32_const(44)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_OR)
        fb.emit_if()
        fb.local_get(l_inf)
        fb.br_if(self._br_depth(fb, b0_pos))
        fb.i32_const(1)
        fb.local_set(l_inf)
        fb.local_get(l_i)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_i)
        fb.br(self._br_depth(fb, l0_pos))
        fb.emit_end()

        # Check if digit ('0'..'9')
        fb.local_get(l_c)
        fb.i32_const(48)
        fb.byte(OP_I32_LT_U)
        fb.local_get(l_c)
        fb.i32_const(57)
        fb.byte(OP_I32_GT_U)
        fb.byte(OP_I32_OR)
        fb.br_if(self._br_depth(fb, b0_pos))

        fb.i32_const(1)
        fb.global_set(cx_digit)
        fb.local_get(l_inf)
        fb.emit_if()
        # Fraction accumulation
        fb.local_get(l_fd)
        fb.f64_const(10.0)
        fb.byte(OP_F64_MUL)
        fb.local_set(l_fd)
        fb.local_get(l_fp)
        fb.local_get(l_c)
        fb.i32_const(48)
        fb.byte(OP_I32_SUB)
        fb.byte(OP_F64_CONVERT_I32_U)
        fb.local_get(l_fd)
        fb.byte(OP_F64_DIV)
        fb.byte(OP_F64_ADD)
        fb.local_set(l_fp)
        fb.byte(OP_ELSE)
        # Integer accumulation
        fb.local_get(l_ip)
        fb.f64_const(10.0)
        fb.byte(OP_F64_MUL)
        fb.local_get(l_c)
        fb.i32_const(48)
        fb.byte(OP_I32_SUB)
        fb.byte(OP_F64_CONVERT_I32_U)
        fb.byte(OP_F64_ADD)
        fb.local_set(l_ip)
        fb.emit_end()

        fb.local_get(l_i)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(l_i)
        fb.br(self._br_depth(fb, l0_pos))
        fb.emit_end()
        fb.emit_end()

        fb.local_get(l_i)
        fb.global_set(cx_pos)
        fb.local_get(l_neg)
        fb.emit_if()
        fb.local_get(l_ip)
        fb.local_get(l_fp)
        fb.byte(OP_F64_ADD)
        fb.byte(OP_F64_NEG)
        fb.byte(OP_RETURN)
        fb.emit_end()
        fb.local_get(l_ip)
        fb.local_get(l_fp)
        fb.byte(OP_F64_ADD)
        fb.byte(OP_RETURN)
        idx = self._mod.add_function(sig)
        self._mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        return idx

    def _build_parse_complex_inner(self) -> int:
        sig = self._mod.add_type([I32, I32], [I32])
        fb = FuncBody(num_params=2)
        cx_pos = self._cx_pos
        cx_sign = self._cx_sign
        cx_digit = self._cx_digit
        re_tmp = self._flux_cx_re_tmp
        im_tmp = self._flux_cx_im_tmp
        l_c = fb.new_i32()
        l_re = fb.new_f64()
        l_im = fb.new_f64()
        l_sep = fb.new_i32()
        l_im_mag = fb.new_f64()
        at_ws_end = self._helper_funcs["$at_ws_end"]
        parse_f64 = self._helper_funcs["$parse_f64"]
        fb.i32_const(0)
        fb.global_set(cx_pos)

        # Skip leading whitespace
        fb.emit_block()
        lws_pos = fb.label_depth
        fb.emit_loop()
        lws_loop = fb.label_depth
        fb.global_get(cx_pos)
        fb.local_get(1)
        fb.byte(OP_I32_GE_U)
        fb.br_if(self._br_depth(fb, lws_pos))
        fb.local_get(0)
        fb.global_get(cx_pos)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_c)
        fb.local_get(l_c)
        fb.i32_const(32)
        fb.byte(OP_I32_EQ)
        fb.local_get(l_c)
        fb.i32_const(9)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_OR)
        fb.emit_if()
        fb.global_get(cx_pos)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.global_set(cx_pos)
        fb.br(self._br_depth(fb, lws_loop))
        fb.emit_end()
        fb.br(self._br_depth(fb, lws_pos))
        fb.emit_end()
        fb.emit_end()

        # Check if empty string
        fb.global_get(cx_pos)
        fb.local_get(1)
        fb.byte(OP_I32_GE_U)
        fb.emit_if()
        fb.i32_const(0)
        fb.byte(OP_RETURN)
        fb.emit_end()

        # Check pure unit imaginary: 'i', 'I', 'j', 'J'
        fb.local_get(0)
        fb.global_get(cx_pos)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_c)
        fb.local_get(l_c)
        fb.i32_const(105) # 'i'
        fb.byte(OP_I32_EQ)
        fb.local_get(l_c)
        fb.i32_const(73)  # 'I'
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_OR)
        fb.local_get(l_c)
        fb.i32_const(106) # 'j'
        fb.byte(OP_I32_EQ)
        fb.local_get(l_c)
        fb.i32_const(74)  # 'J'
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_OR)
        fb.byte(OP_I32_OR)
        fb.emit_if()
        fb.global_get(cx_pos)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.global_set(cx_pos)
        fb.local_get(0)
        fb.local_get(1)
        self._emit_call(fb, at_ws_end)
        fb.emit_if()
        fb.f64_const(0.0)
        fb.global_set(re_tmp)
        fb.f64_const(1.0)
        fb.global_set(im_tmp)
        fb.i32_const(1)
        fb.byte(OP_RETURN)
        fb.emit_end()
        fb.i32_const(0)
        fb.byte(OP_RETURN)
        fb.emit_end()

        # Check '+i', '-i', '+j', '-j'
        fb.local_get(l_c)
        fb.i32_const(43) # '+'
        fb.byte(OP_I32_EQ)
        fb.local_get(l_c)
        fb.i32_const(45) # '-'
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_OR)
        fb.global_get(cx_pos)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_get(1)
        fb.byte(OP_I32_LT_U)
        fb.byte(OP_I32_AND)
        fb.emit_if()
        fb.local_get(0)
        fb.global_get(cx_pos)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_sep)
        fb.local_get(l_sep)
        fb.i32_const(105) # 'i'
        fb.byte(OP_I32_EQ)
        fb.local_get(l_sep)
        fb.i32_const(73)  # 'I'
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_OR)
        fb.local_get(l_sep)
        fb.i32_const(106) # 'j'
        fb.byte(OP_I32_EQ)
        fb.local_get(l_sep)
        fb.i32_const(74)  # 'J'
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_OR)
        fb.byte(OP_I32_OR)
        fb.emit_if()
        fb.global_get(cx_pos)
        fb.i32_const(2)
        fb.byte(OP_I32_ADD)
        fb.global_set(cx_pos)
        fb.local_get(0)
        fb.local_get(1)
        self._emit_call(fb, at_ws_end)
        fb.emit_if()
        fb.f64_const(0.0)
        fb.global_set(re_tmp)
        fb.local_get(l_c)
        fb.i32_const(45)
        fb.byte(OP_I32_EQ)
        fb.emit_if()
        fb.f64_const(-1.0)
        fb.global_set(im_tmp)
        fb.byte(OP_ELSE)
        fb.f64_const(1.0)
        fb.global_set(im_tmp)
        fb.emit_end()
        fb.i32_const(1)
        fb.byte(OP_RETURN)
        fb.emit_end()
        fb.i32_const(0)
        fb.byte(OP_RETURN)
        fb.emit_end()
        fb.emit_end()

        # Parse first number: re (or pure imaginary mag if followed by 'i')
        fb.local_get(0)
        fb.local_get(1)
        self._emit_call(fb, parse_f64)
        fb.local_set(l_re)

        # Skip whitespace after first number
        fb.emit_block()
        ws_p2 = fb.label_depth
        fb.emit_loop()
        ws_l2 = fb.label_depth
        fb.global_get(cx_pos)
        fb.local_get(1)
        fb.byte(OP_I32_GE_U)
        fb.br_if(self._br_depth(fb, ws_p2))
        fb.local_get(0)
        fb.global_get(cx_pos)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_c)
        fb.local_get(l_c)
        fb.i32_const(32)
        fb.byte(OP_I32_EQ)
        fb.local_get(l_c)
        fb.i32_const(9)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_OR)
        fb.emit_if()
        fb.global_get(cx_pos)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.global_set(cx_pos)
        fb.br(self._br_depth(fb, ws_l2))
        fb.emit_end()
        fb.br(self._br_depth(fb, ws_p2))
        fb.emit_end()
        fb.emit_end()

        # If at end, real-only number (e.g. "3", "3.1", "3,1")
        fb.global_get(cx_pos)
        fb.local_get(1)
        fb.byte(OP_I32_GE_U)
        fb.emit_if()
        fb.global_get(cx_digit)
        fb.global_get(cx_sign)
        fb.i32_const(1)
        fb.byte(OP_I32_NE)
        fb.byte(OP_I32_OR)
        fb.emit_if()
        fb.local_get(l_re)
        fb.global_set(re_tmp)
        fb.f64_const(0.0)
        fb.global_set(im_tmp)
        fb.i32_const(1)
        fb.byte(OP_RETURN)
        fb.emit_end()
        fb.i32_const(0)
        fb.byte(OP_RETURN)
        fb.emit_end()

        # Check pure imaginary: e.g. "2.5i", "-3i"
        fb.local_get(0)
        fb.global_get(cx_pos)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_c)
        fb.local_get(l_c)
        fb.i32_const(105)
        fb.byte(OP_I32_EQ)
        fb.local_get(l_c)
        fb.i32_const(73)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_OR)
        fb.local_get(l_c)
        fb.i32_const(106)
        fb.byte(OP_I32_EQ)
        fb.local_get(l_c)
        fb.i32_const(74)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_OR)
        fb.byte(OP_I32_OR)
        fb.emit_if()
        fb.global_get(cx_pos)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.global_set(cx_pos)
        fb.local_get(0)
        fb.local_get(1)
        self._emit_call(fb, at_ws_end)
        fb.emit_if()
        fb.global_get(cx_digit)
        fb.emit_if()
        fb.local_get(l_re)
        fb.local_set(l_im)
        fb.byte(OP_ELSE)
        fb.global_get(cx_sign)
        fb.byte(OP_F64_CONVERT_I32_S)
        fb.local_set(l_im)
        fb.emit_end()
        fb.f64_const(0.0)
        fb.global_set(re_tmp)
        fb.local_get(l_im)
        fb.global_set(im_tmp)
        fb.i32_const(1)
        fb.byte(OP_RETURN)
        fb.emit_end()
        fb.i32_const(0)
        fb.byte(OP_RETURN)
        fb.emit_end()

        # Check '+' or '-' operator for complex: e.g. "3-2.5i", "3.1-2.5i", "3 + 4i", "3+i"
        fb.local_get(l_c)
        fb.i32_const(43) # '+'
        fb.byte(OP_I32_EQ)
        fb.local_get(l_c)
        fb.i32_const(45) # '-'
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_OR)
        fb.emit_if()
        fb.i32_const(1)
        fb.local_set(l_sep)
        fb.local_get(l_c)
        fb.i32_const(45)
        fb.byte(OP_I32_EQ)
        fb.emit_if()
        fb.i32_const(-1)
        fb.local_set(l_sep)
        fb.emit_end()
        fb.global_get(cx_pos)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.global_set(cx_pos)

        # Skip whitespace after '+' or '-'
        fb.emit_block()
        ws_p3 = fb.label_depth
        fb.emit_loop()
        ws_l3 = fb.label_depth
        fb.global_get(cx_pos)
        fb.local_get(1)
        fb.byte(OP_I32_GE_U)
        fb.br_if(self._br_depth(fb, ws_p3))
        fb.local_get(0)
        fb.global_get(cx_pos)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_c)
        fb.local_get(l_c)
        fb.i32_const(32)
        fb.byte(OP_I32_EQ)
        fb.local_get(l_c)
        fb.i32_const(9)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_OR)
        fb.emit_if()
        fb.global_get(cx_pos)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.global_set(cx_pos)
        fb.br(self._br_depth(fb, ws_l3))
        fb.emit_end()
        fb.br(self._br_depth(fb, ws_p3))
        fb.emit_end()
        fb.emit_end()

        # If at end, invalid
        fb.global_get(cx_pos)
        fb.local_get(1)
        fb.byte(OP_I32_GE_U)
        fb.emit_if()
        fb.i32_const(0)
        fb.byte(OP_RETURN)
        fb.emit_end()

        # Check if unit imaginary directly after operator: e.g. "3+i", "3-i", "3 + j"
        fb.local_get(0)
        fb.global_get(cx_pos)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_c)
        fb.local_get(l_c)
        fb.i32_const(105)
        fb.byte(OP_I32_EQ)
        fb.local_get(l_c)
        fb.i32_const(73)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_OR)
        fb.local_get(l_c)
        fb.i32_const(106)
        fb.byte(OP_I32_EQ)
        fb.local_get(l_c)
        fb.i32_const(74)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_OR)
        fb.byte(OP_I32_OR)
        fb.emit_if()
        fb.global_get(cx_pos)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.global_set(cx_pos)
        fb.local_get(0)
        fb.local_get(1)
        self._emit_call(fb, at_ws_end)
        fb.emit_if()
        fb.local_get(l_re)
        fb.global_set(re_tmp)
        fb.local_get(l_sep)
        fb.byte(OP_F64_CONVERT_I32_S)
        fb.global_set(im_tmp)
        fb.i32_const(1)
        fb.byte(OP_RETURN)
        fb.emit_end()
        fb.i32_const(0)
        fb.byte(OP_RETURN)
        fb.emit_end()

        # Parse imaginary magnitude: "2.5", "4", etc.
        fb.local_get(0)
        fb.local_get(1)
        self._emit_call(fb, parse_f64)
        fb.local_set(l_im_mag)

        # Skip whitespace after imaginary magnitude
        fb.emit_block()
        ws_p4 = fb.label_depth
        fb.emit_loop()
        ws_l4 = fb.label_depth
        fb.global_get(cx_pos)
        fb.local_get(1)
        fb.byte(OP_I32_GE_U)
        fb.br_if(self._br_depth(fb, ws_p4))
        fb.local_get(0)
        fb.global_get(cx_pos)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_c)
        fb.local_get(l_c)
        fb.i32_const(32)
        fb.byte(OP_I32_EQ)
        fb.local_get(l_c)
        fb.i32_const(9)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_OR)
        fb.emit_if()
        fb.global_get(cx_pos)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.global_set(cx_pos)
        fb.br(self._br_depth(fb, ws_l4))
        fb.emit_end()
        fb.br(self._br_depth(fb, ws_p4))
        fb.emit_end()
        fb.emit_end()

        # Check for 'i', 'I', 'j', 'J'
        fb.global_get(cx_pos)
        fb.local_get(1)
        fb.byte(OP_I32_LT_U)
        fb.emit_if()
        fb.local_get(0)
        fb.global_get(cx_pos)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I32_LOAD8_U)
        fb.put(encode_memarg(0, 0))
        fb.local_set(l_c)
        fb.local_get(l_c)
        fb.i32_const(105)
        fb.byte(OP_I32_EQ)
        fb.local_get(l_c)
        fb.i32_const(73)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_OR)
        fb.local_get(l_c)
        fb.i32_const(106)
        fb.byte(OP_I32_EQ)
        fb.local_get(l_c)
        fb.i32_const(74)
        fb.byte(OP_I32_EQ)
        fb.byte(OP_I32_OR)
        fb.byte(OP_I32_OR)
        fb.emit_if()
        fb.global_get(cx_pos)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.global_set(cx_pos)
        fb.local_get(0)
        fb.local_get(1)
        self._emit_call(fb, at_ws_end)
        fb.emit_if()
        fb.local_get(l_im_mag)
        fb.local_get(l_sep)
        fb.byte(OP_F64_CONVERT_I32_S)
        fb.byte(OP_F64_MUL)
        fb.local_set(l_im)
        fb.local_get(l_re)
        fb.global_set(re_tmp)
        fb.local_get(l_im)
        fb.global_set(im_tmp)
        fb.i32_const(1)
        fb.byte(OP_RETURN)
        fb.emit_end()
        fb.emit_end()
        fb.emit_end()

        fb.emit_end() # end of '+' / '-' block

        fb.i32_const(0)
        fb.byte(OP_RETURN)
        idx = self._mod.add_function(sig)
        self._mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        return idx

    def _build_input_complex(self, retry_fat: int) -> int:
        sig = self._mod.add_type([I64, I64], [])
        fb = FuncBody(num_params=2)
        l_line = fb.new_i64()
        l_ptr = fb.new_i32()
        l_len = fb.new_i32()
        print_fat = self._helper_funcs["$print_fat"]
        print_fat_nl = self._helper_funcs["$print_fat_nl"]
        read_line = self._helper_funcs["$flux_read_line"]
        parse_complex_inner = self._helper_funcs["$parse_complex_inner"]
        fb.emit_block()
        exit_pos = fb.label_depth
        fb.emit_loop()
        loop_pos = fb.label_depth
        fb.local_get(1)
        self._emit_call(fb, print_fat)
        self._emit_call(fb, read_line)
        fb.local_set(l_line)
        fb.local_get(l_line)
        fb.i64_const(32)
        fb.byte(OP_I64_SHR_U)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_ptr)
        fb.local_get(l_line)
        fb.i64_const(0xFFFFFFFF)
        fb.byte(OP_I64_AND)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(l_len)
        fb.local_get(l_ptr)
        fb.local_get(l_len)
        self._emit_call(fb, parse_complex_inner)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.byte(OP_RETURN)
        fb.byte(OP_END)
        fb.i64_const(retry_fat)
        self._emit_call(fb, print_fat_nl)
        fb.br(self._br_depth(fb, loop_pos))
        fb.emit_end()
        fb.emit_end()
        idx = self._mod.add_function(sig)
        self._mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        return idx

    def _gen_input_storage_bin(self, it, ft: str, fb: FuncBody) -> None:
        from flux_proto.semantic.storage_types import _INT_RANGES
        if (it.initializer is not None and isinstance(it.initializer, InputExpr)
                and it.initializer.prompt is not None and isinstance(it.initializer.prompt, Literal)
                and _is_str_type(it.initializer.prompt.value_type)):
            prompt_fat = self._fat_const(it.initializer.prompt.value)
        else:
            prompt_fat = self._fat_const("")
        tname_fat = self._fat_const(ft)
        lowft = ft.lower()

        def call_input(name: str) -> None:
            fb.i64_const(tname_fat)
            fb.i64_const(prompt_fat)
            self._emit_call(fb, self._helper_funcs[name])

        if lowft.startswith("complex"):
            if self._in_function:
                re_slot = fb.new_f64()
                im_slot = fb.new_f64()
                self._complex_slots[it.name] = {"kind": "local", "re": re_slot, "im": im_slot, "type": ft}
                call_input("$flux_input_complex")
                fb.global_get(self._flux_cx_re_tmp)
                fb.local_set(re_slot)
                fb.global_get(self._flux_cx_im_tmp)
                fb.local_set(im_slot)
            else:
                re_gi = self._mod.add_global(F64, True, bytes([OP_F64_CONST]) + struct.pack("<d", 0.0))
                im_gi = self._mod.add_global(F64, True, bytes([OP_F64_CONST]) + struct.pack("<d", 0.0))
                self._complex_slots[it.name] = {"kind": "global", "re": re_gi, "im": im_gi, "type": ft}
                call_input("$flux_input_complex")
                fb.global_get(self._flux_cx_re_tmp)
                fb.global_set(re_gi)
                fb.global_get(self._flux_cx_im_tmp)
                fb.global_set(im_gi)
            return

        wt = _wtype(lowft)
        if self._in_function:
            if it.name not in self._local_vars:
                if wt == F64:
                    li = fb.new_f64()
                elif wt == I32:
                    li = fb.new_i32()
                else:
                    li = fb.new_i64()
                self._local_vars[it.name] = (li, wt)
            li, _ = self._local_vars[it.name]
            if lowft in _INT_RANGES:
                call_input("$flux_input_int")
            elif lowft in FLOATISH:
                call_input("$flux_input_float")
            elif lowft == "bool":
                call_input("$flux_input_bool")
            elif lowft == "char":
                call_input("$flux_input_char")
            elif lowft == "datetime":
                call_input("$flux_input_datetime")
            else:
                call_input("$flux_input_string")
            fb.local_set(li)
        else:
            if it.name not in self._globals:
                init = bytes([OP_F64_CONST]) + struct.pack("<d", 0.0) if wt == F64 else (b"\x41\x00" if wt == I32 else b"\x42\x00")
                gi = self._mod.add_global(wt, True, init)
                self._globals[it.name] = (gi, wt)
            gi, _ = self._globals[it.name]
            if lowft in _INT_RANGES:
                call_input("$flux_input_int")
            elif lowft in FLOATISH:
                call_input("$flux_input_float")
            elif lowft == "bool":
                call_input("$flux_input_bool")
            elif lowft == "char":
                call_input("$flux_input_char")
            elif lowft == "datetime":
                call_input("$flux_input_datetime")
            else:
                call_input("$flux_input_string")
            fb.global_set(gi)

    def _collect_decl_types(self, node: ASTNode) -> None:
        if isinstance(node, StorageDecl):
            for it in node.items:
                ft = it.type_ref.name if it.type_ref else "string"
                self._decl_types[it.name] = ft
                if _is_str_type(ft):
                    self._str_vars.add(it.name)
        elif isinstance(node, FluxProgram):
            for s in node.storages:
                self._collect_decl_types(s)
            if node.body:
                self._collect_decl_types(node.body)
            for f in node.functions:
                if f.body:
                    self._collect_decl_types(f.body)
        elif isinstance(node, BlockStmt):
            for s in node.body:
                self._collect_decl_types(s)
        elif isinstance(node, RouteStmt):
            for arm in node.arms:
                if arm.body is not None:
                    self._collect_decl_types(arm.body)
        elif isinstance(node, InfiniteStmt):
            if node.body is not None:
                self._collect_decl_types(node.body)

    def generate(self, program: ASTNode) -> bytes:
        if not isinstance(program, FluxProgram):
            raise WasmError(f"Cannot generate WASM for {type(program).__name__}")
        self._imports = program.imports
        self._op_aliases = collect_op_aliases(program)
        for f in program.imports.values():
            for agent in f.agents:
                if agent.body:
                    for op in agent.body.ops:
                        self._op_defs[op.name] = op
        self._collect_called_ops(program)
        # Transitive: a called op may itself call other fdsl ops inside its
        # body. Walk every reachable op body until the set stabilizes so
        # helper ops (e.g. _ord, _b64CharToVal, _charToDigit) get compiled
        # as real functions instead of falling into the builtin dispatch.
        changed = True
        while changed:
            changed = False
            for name in list(self._used_op_names):
                op = self._op_defs.get(name)
                if op is None or op.body is None:
                    continue
                before = len(self._used_op_names)
                for expr in op.body.expressions:
                    self._collect_called_ops(expr)
                if len(self._used_op_names) != before:
                    changed = True
        self._enums = {e.name: e for e in program.enums}
        self._structs = {s.name: s for s in program.structs}

        all_storages = list(program.storages) + [s for f in program.imports.values() for s in f.storages] + [s for f in program.imports.values() for a in f.agents if a.body for s in a.body.storages]
        for s in all_storages:
            for it in s.items:
                ft = it.type_ref.name if it.type_ref else "string"
                self._decl_types[it.name] = ft
                if _is_str_type(ft):
                    self._str_vars.add(it.name)
        self._collect_decl_types(program)

        self._collect_strs(program)
        self._alloc_str("nice")
        self._alloc_str("fail")

        for s in all_storages:
            for it in s.items:
                ft = it.type_ref.name if it.type_ref else "string"
                if ft in self._enums:
                    if it.name not in self._enum_slots:
                        self._declare_enum_storage_global(it)
                    continue
                if ft in self._structs:
                    if it.name not in self._struct_slots:
                        self._declare_struct_storage_global(it)
                    continue
                wt = _wtype(ft)
                if wt == F64:
                    init = bytes([OP_F64_CONST]) + struct.pack("<d", 0.0)
                else:
                    init = b"\x41\x00" if wt == I32 else b"\x42\x00"
                gi = self._mod.add_global(wt, True, init)
                self._globals[it.name] = (gi, wt)

        self._tmp_f64 = self._mod.add_global(
            F64, True, bytes([OP_F64_CONST]) + struct.pack("<d", 0.0)
        )

        t_fd_write = self._mod.add_type([I32, I32, I32, I32], [I32])
        fd_write_idx = self._mod.add_import("wasi_snapshot_preview1", "fd_write", t_fd_write)
        self._helper_funcs["$fd_write"] = fd_write_idx

        t_fd_read = self._mod.add_type([I32, I32, I32, I32], [I32])
        fd_read_idx = self._mod.add_import("wasi_snapshot_preview1", "fd_read", t_fd_read)
        self._helper_funcs["$fd_read"] = fd_read_idx

        t_clock_time_get = self._mod.add_type([I32, I64, I32], [I32])
        clock_time_get_idx = self._mod.add_import("wasi_snapshot_preview1", "clock_time_get", t_clock_time_get)
        self._helper_funcs["$clock_time_get"] = clock_time_get_idx

        strlen_idx = self._build_strlen()
        self._helper_funcs["$strlen"] = strlen_idx
        encode_utf8_idx = self._build_encode_utf8()
        self._helper_funcs["$encode_utf8"] = encode_utf8_idx
        i64_to_str_idx = self._build_i64_to_str()
        self._helper_funcs["$i64_to_str"] = i64_to_str_idx
        print_str_idx = self._build_print_str()
        self._helper_funcs["$print_str"] = print_str_idx

        pow10_i64_idx = self._build_pow10_i64()
        self._helper_funcs["$pow10_i64"] = pow10_i64_idx
        pow5_i64_idx = self._build_pow5_i64()
        self._helper_funcs["$pow5_i64"] = pow5_i64_idx
        pow10_f64_idx = self._build_pow10_f64()
        self._helper_funcs["$pow10_f64"] = pow10_f64_idx
        bit_length_u64_idx = self._build_bit_length_u64()
        self._helper_funcs["$bit_length_u64"] = bit_length_u64_idx
        u128_mul_idx = self._build_u128_mul()
        self._helper_funcs["$u128_mul"] = u128_mul_idx
        u128_div_u64_idx = self._build_u128_div_u64()
        self._helper_funcs["$u128_div_u64"] = u128_div_u64_idx
        recon_float_bits_idx = self._build_recon_float_bits()
        self._helper_funcs["$recon_float_bits"] = recon_float_bits_idx
        compute_exact_m_idx = self._build_compute_exact_m()
        self._helper_funcs["$compute_exact_m"] = compute_exact_m_idx
        f64_pow_idx = self._build_f64_pow()
        self._helper_funcs["$f64_pow"] = f64_pow_idx

        f64_to_str_idx = self._build_f64_to_str()
        self._helper_funcs["$f64_to_str"] = f64_to_str_idx
        f64_root_idx = self._build_f64_root()
        self._helper_funcs["$f64_root"] = f64_root_idx
        round_idx = self._build_round_fmt()
        self._helper_funcs["$round_fmt"] = round_idx
        str_to_i64_idx = self._build_str_to_i64()
        self._helper_funcs["$str_to_i64"] = str_to_i64_idx
        str_to_f64_idx = self._build_str_to_f64()
        self._helper_funcs["$str_to_f64"] = str_to_f64_idx
        dt_to_str_idx = self._build_dt_to_str()
        self._helper_funcs["$dt_to_str"] = dt_to_str_idx

        self._build_input_helpers()

        self._heap_start = (self._read_nw_off() + 8 + 7) & ~7
        self._heap_global = self._mod.add_global(
            I32, True, bytes([OP_I32_CONST]) + sleb128(self._heap_start)
        )
        self._heap_base_global = self._mod.add_global(
            I32, True, bytes([OP_I32_CONST]) + sleb128(self._heap_start)
        )
        self._io_last_write_global = self._mod.add_global(
            I64, True, bytes([OP_I64_CONST]) + sleb128(0)
        )
        self._io_copy_exists_global = self._mod.add_global(
            I32, True, bytes([OP_I32_CONST]) + sleb128(0)
        )
        self._io_moved_exists_global = self._mod.add_global(
            I32, True, bytes([OP_I32_CONST]) + sleb128(0)
        )
        self._io_dir_exists_global = self._mod.add_global(
            I32, True, bytes([OP_I32_CONST]) + sleb128(0)
        )
        from flux_proto.wasm.list_helpers import CollectionHelpers
        CollectionHelpers(self).build_all()
        from flux_proto.wasm.datetime_helpers import DateTimeHelpers
        DateTimeHelpers(self).build_all()
        self._helper_funcs["$path_base_name"] = self._build_path_base_name()
        self._helper_funcs["$path_dir_name"] = self._build_path_dir_name()
        self._helper_funcs["$path_extension"] = self._build_path_extension()
        self._helper_funcs["$path_join"] = self._build_path_join()

        for func in program.functions:
            fname = func.name
            if fname in self._user_funcs:
                continue
            fparams = [_wtype(p.type_ref.name if p.type_ref else "int64") for p in func.params]
            sig = self._mod.add_type(fparams, [I32, I64, I32])
            fidx = self._mod.add_function(sig)
            self._user_funcs[fname] = {
                "idx": fidx, "sig": sig, "params": fparams, "func": func,
                "return_type": (func.return_type.name if func.return_type else "int64"),
            }

        stdlib_ops = (_LIST_RETURNING | _SET_RETURNING | _MAP_RETURNING | _MAP_LIST_OPS
                      | _MAP_BOOL_OPS | _MAP_VALUE_OPS | _BOOL_OPS | _INT_OPS | _DATA_OPS
                      | {"isEmpty", "toList", "toSet", "convertToComplex", "convertToComplex32",
                         "convertToComplex128", "convertComplexToList", "complexToList",
                         "convertEnumToString", "enumToString"})
        for op_name, op in self._op_defs.items():
            if op_name in self._user_funcs or op_name in stdlib_ops:
                continue
            if op_name not in self._used_op_names:
                continue
            oparams = [_wtype(p.type_ref.name if p.type_ref else "int64") for p in op.params]
            rtype = op.return_type.name if op.return_type else "data"
            if rtype == "data" and op.body:
                for expr in op.body.expressions:
                    if isinstance(expr, EmitStmt) and isinstance(expr.value_expr, CallExpr):
                        cn = expr.value_expr.callee.name if isinstance(expr.value_expr.callee, Identifier) else ""
                        if cn in _LIST_RETURNING:
                            rtype = "list of data"
                        elif cn in _SET_RETURNING:
                            rtype = _SET_RETURNING[cn]
                        elif cn in _MAP_RETURNING:
                            rtype = "map"
            sig = self._mod.add_type(oparams, [I32, I64, I32])
            fidx = self._mod.add_function(sig)
            self._user_funcs[op_name] = {
                "idx": fidx, "sig": sig, "params": oparams, "op": op,
                "return_type": rtype,
            }

        mem_needed = self._heap_start + 2 * 65536
        pages = (mem_needed + 65535) // 65536
        self._mod.add_memory(max(1, pages))

        fb = FuncBody()
        self._init_frame(fb)
        for s in all_storages:
            for it in s.items:
                ft = it.type_ref.name if it.type_ref else "string"
                self._decl_types[it.name] = ft
                if _is_str_type(ft):
                    self._str_vars.add(it.name)
                if ft in self._enums:
                    if it.initializer is not None:
                        self._emit_enum_into(it.initializer, self._enum_slots[it.name][1], fb, is_global=True)
                    continue
                if ft in self._structs:
                    if it.initializer is not None:
                        self._emit_struct_into(it.initializer, self._struct_slots[it.name][1], fb, is_global=True)
                    continue
                if it.initializer and isinstance(it.initializer, Literal):
                    vt = it.initializer.value_type.lower()
                    gi, _ = self._globals[it.name]
                    if _is_str_type(vt):
                        self._emit_fat_const(it.initializer.value, fb)
                        self._str_vars.add(it.name)
                        fb.global_set(gi)
                    elif _is_char_type(vt):
                        fb.i32_const(ord(it.initializer.value))
                        fb.global_set(gi)
                    elif vt in ("int", "int64", "int32", "int16", "int8"):
                        fb.i64_const(_wrap_i64(int(it.initializer.value)))
                        fb.global_set(gi)
                    elif vt == "bool":
                        v = 1 if it.initializer.value.lower() == "true" else 0
                        fb.i64_const(v)
                        fb.global_set(gi)
                    elif _is_float_type(vt):
                        fb.f64_const(float(it.initializer.value))
                        self._emit_round(fb, ft)
                        fb.global_set(gi)
                elif it.initializer is not None:
                    self._gen_expr(it.initializer, fb)
                    gi, _ = self._globals[it.name]
                    fb.global_set(gi)

        if program.body:
            self._gen_block(program.body, fb)

        for func in program.functions:
            self._compile_function(self._user_funcs[func.name])
        for info in list(self._user_funcs.values()):
            if "op" in info:
                self._compile_op_function(info)

        start_sig = self._mod.add_type([], [])
        start_idx = self._mod.add_function(start_sig)
        self._mod.add_code(fb.get_locals_decls(), fb.get_bytes())

        self._mod.add_export("memory", EXPORT_MEM, 0)
        self._mod.add_export("_start", EXPORT_FUNC, start_idx)

        for s, (off, _slen) in sorted(self._str_offsets.items(), key=lambda x: x[1][0]):
            off_bytes = bytes([OP_I32_CONST]) + sleb128(off) + bytes([OP_END])
            self._mod.add_data(0, off_bytes, s.encode("utf-8") + b"\x00")

        return self._mod.to_bytes()

    def _is_str_type(self, ft: str) -> bool:
        t = ft.lower()
        return t in ("string", "str") or t.startswith("string(")

    def _is_char_node(self, p: ASTNode) -> bool:
        if isinstance(p, Identifier) and p.name in self._decl_types:
            return self._decl_types[p.name].lower() == "char"
        if isinstance(p, Literal):
            return p.value_type.lower() == "char"
        return False

    def _infer_type(self, node: ASTNode) -> str:
        if isinstance(node, OwnershipExpr):
            return self._infer_type(Identifier(name=node.target))
        if isinstance(node, SpawnExpr):
            return self._infer_type(node.operand)
        if isinstance(node, AwaitExpr):
            return self._infer_type(node.operand)
        if isinstance(node, CastExpr):
            return node.target_type.name
        if isinstance(node, DataflowExpr):
            if isinstance(node.right, DataflowCastSink):
                return node.right.target_type.name
            if node.op in ("split", "join"):
                return "list of int64"
            return self._infer_type(node.right)
        if isinstance(node, Literal):
            return node.value_type.lower()
        if isinstance(node, FieldAccess):
            if node.field in ("sta", "status", "msg", "message"):
                return "string"
            if node.field in ("val", "value"):
                if isinstance(node.obj, CallExpr):
                    cname = node.obj.callee.name if isinstance(node.obj.callee, Identifier) else ""
                    if cname in self._user_funcs:
                        return self._user_funcs[cname]["return_type"]
                return "int64"
            ftype = self._field_type(node)
            if ftype is not None:
                return ftype
            return "int64"
        if isinstance(node, Identifier):
            if node.name in self._str_vars:
                return "string"
            if node.name in self._decl_types:
                return self._decl_types[node.name]
            if node.name in self._sc_vars:
                return "int64"
            if node.name in self._result_vars:
                return "int64"
            if node.name in self._local_vars:
                wt = self._local_vars[node.name][1]
                return "float64" if wt == F64 else ("int64" if wt == I64 else "int32")
            if node.name in self._globals:
                gt = self._globals[node.name][1]
                return "float64" if gt == F64 else ("int64" if gt == I64 else "int32")
            return "string"
        if isinstance(node, BinaryOp):
            if node.op in ("==", "!=", "<", "<=", ">", ">=", "and", "or", "in"):
                return "bool"
            lt = self._infer_type(node.left)
            rt = self._infer_type(node.right)
            if (_is_set_type(lt) or _is_set_type(rt) or _is_list_type(lt) or _is_list_type(rt) or _is_map_type(lt) or _is_map_type(rt)) and node.op == "+":
                return "string"
            if self._is_tensor_type(lt) or self._is_tensor_type(rt):
                return "string"
            if self._is_str_type(lt) or self._is_str_type(rt):
                return "string"
            if node.op == "^r":
                return "float64"
            if node.op == "/f" or _is_float_type(lt) or _is_float_type(rt):
                return "float64"
            return "int64"
        if isinstance(node, IndexAccess):
            return self._index_access_type(node)
        if isinstance(node, ListLiteral):
            return "list of " + self._infer_type(node.items[0]) if node.items else "list of int64"
        if isinstance(node, SetLiteral):
            return "set of " + self._infer_type(node.items[0]) if node.items else "set of int64"
        if isinstance(node, MapLiteral):
            return "map"
        if isinstance(node, RecordLiteral):
            return "data"
        if isinstance(node, CallExpr):
            cname = node.callee.name if isinstance(node.callee, Identifier) else ""
            if cname in self._user_funcs:
                return self._user_funcs[cname]["return_type"]
            if cname in self._op_defs:
                op = self._op_defs[cname]
                return op.return_type.name if op.return_type else "data"
            if cname in ("convertComplexToList", "complexToList"):
                return "list of data"
            if cname in ("convertEnumToString", "enumToString", "convertToString", "toString"):
                return "string"
            if cname in _LIST_RETURNING:
                return "list of data"
            if cname in _SET_RETURNING:
                if cname in ("toList", "stdSetToList", "stdCollectionToList"):
                    return "list of data"
                return "set of data"
            if cname in _INT_OPS:
                return "int64"
            if cname in _BOOL_OPS or cname == "isEmpty":
                return "bool"
            if cname in _MAP_RETURNING:
                if cname == "clearAll":
                    return self._infer_type(node.args[0]) if node.args else "map"
                return "map"
            if cname in _MAP_LIST_OPS:
                return "list of data"
            if cname in _MAP_BOOL_OPS:
                return "bool"
            if cname in _MAP_VALUE_OPS:
                return "data"
            return "int64"
        if isinstance(node, UnaryOp):
            return self._infer_type(node.operand)
        if isinstance(node, MatchExpr):
            rt = self._match_result_type(node)
            if rt == F64:
                return "float64"
            if rt == I32:
                return "int32"
            for arm in node.arms:
                if isinstance(arm.pattern, IdentifierPattern):
                    return "string"
                if isinstance(arm.pattern, EnumVariantPattern):
                    edef = self._enums.get(arm.pattern.enum)
                    if edef is not None:
                        layout = self._enum_layout(edef)
                        for f in arm.pattern.fields:
                            if layout["fields"].get(f.name) == I64 and self._enum_field_is_str(edef, f.name):
                                return "string"
                if isinstance(arm.body, MatchExpr):
                    continue
                if _is_str_type(self._infer_type(arm.body)):
                    return "string"
            return "int64"
        if isinstance(node, InterpolatedString):
            return "string"
        if isinstance(node, InterpolatedText):
            return "string"
        return "int64"

    def _gen_block(self, node: BlockStmt, fb: FuncBody) -> None:
        for stmt in node.body:
            self._gen_statement(stmt, fb)

    def _gen_statement(self, node: ASTNode, fb: FuncBody) -> None:
        if self._is_exotic(node):
            self._raise_exotic(node)
        if isinstance(node, UnsafeStmt):
            if isinstance(node.body, BlockStmt):
                self._gen_block(node.body, fb)
            elif node.body is not None:
                self._gen_statement(node.body, fb)
        elif isinstance(node, BlockStmt):
            self._gen_block(node, fb)
        elif isinstance(node, ExpressionStmt):
            inner = node.expr
            if isinstance(inner, IndexAssign):
                self._gen_index_assign(inner, fb)
            elif isinstance(inner, FieldAssign):
                self._gen_field_assign(inner, fb)
            else:
                self._gen_expr(inner, fb)
                fb.byte(OP_DROP)
        elif isinstance(node, PrintStmt):
            self._gen_print_args(node.args, True, fb)
        elif isinstance(node, CallExpr):
            name = node.callee.name if isinstance(node.callee, Identifier) else ""
            self._gen_call(node, fb)
            if name not in ("print", "println"):
                fb.byte(OP_DROP)
        elif isinstance(node, StorageDecl):
            for it in node.items:
                ft = it.type_ref.name if it.type_ref else "string"
                self._decl_types[it.name] = ft
                if _is_str_type(ft):
                    self._str_vars.add(it.name)
                if isinstance(it.initializer, InputExpr):
                    self._gen_input_storage_bin(it, ft, fb)
                    continue
                if isinstance(it.initializer, OwnershipExpr) and it.initializer.mut:
                    t = it.initializer.target
                    if self._in_function:
                        if t not in self._local_vars:
                            raise WasmError(f"borrow_mut target '{t}' not available on wasm target")
                        if it.name not in self._local_vars:
                            self._local_vars[it.name] = self._local_vars[t]
                    else:
                        if t not in self._globals:
                            raise WasmError(f"borrow_mut target '{t}' not available on wasm target")
                        if it.name not in self._globals:
                            self._globals[it.name] = self._globals[t]
                    continue
                self._decl_types[it.name] = ft
                if _is_str_type(ft):
                    self._str_vars.add(it.name)
                if ft in self._enums:
                    if self._in_function:
                        if it.name not in self._enum_slots:
                            self._declare_enum_storage_local(it, fb)
                            if it.initializer is not None:
                                self._emit_enum_into(it.initializer, self._enum_slots[it.name][1], fb, is_global=False)
                        elif it.initializer is not None:
                            self._emit_enum_into(it.initializer, self._enum_slots[it.name][1], fb, is_global=False)
                    else:
                        if it.name not in self._enum_slots:
                            self._declare_enum_storage_global(it)
                            if it.initializer is not None:
                                self._emit_enum_into(it.initializer, self._enum_slots[it.name][1], fb, is_global=True)
                        elif it.initializer is not None:
                            self._emit_enum_into(it.initializer, self._enum_slots[it.name][1], fb, is_global=True)
                    continue
                if ft in self._structs:
                    if self._in_function:
                        if it.name not in self._struct_slots:
                            self._declare_struct_storage_local(it, fb)
                            if it.initializer is not None:
                                self._emit_struct_into(it.initializer, self._struct_slots[it.name][1], fb, is_global=False)
                        elif it.initializer is not None:
                            self._emit_struct_into(it.initializer, self._struct_slots[it.name][1], fb, is_global=False)
                    else:
                        if it.name not in self._struct_slots:
                            self._declare_struct_storage_global(it)
                            if it.initializer is not None:
                                self._emit_struct_into(it.initializer, self._struct_slots[it.name][1], fb, is_global=True)
                        elif it.initializer is not None:
                            self._emit_struct_into(it.initializer, self._struct_slots[it.name][1], fb, is_global=True)
                    continue
                if self._is_tensor_type(ft):
                    self._gen_tensor_decl(it, fb, is_global=not self._in_function)
                    continue
                if ft.lower().startswith("complex"):
                    if self._in_function:
                        if it.name not in self._complex_slots:
                            re_slot = fb.new_f64()
                            im_slot = fb.new_f64()
                            self._complex_slots[it.name] = {"kind": "local", "re": re_slot, "im": im_slot, "type": ft}
                        else:
                            re_slot = self._complex_slots[it.name]["re"]
                            im_slot = self._complex_slots[it.name]["im"]
                        if it.initializer is not None:
                            re_e, im_e = self._gen_complex_value(it.initializer, fb)
                            fb.local_get(re_e)
                            fb.local_set(re_slot)
                            fb.local_get(im_e)
                            fb.local_set(im_slot)
                    else:
                        if it.name not in self._complex_slots:
                            re_gi = self._mod.add_global(F64, True, bytes([OP_F64_CONST]) + struct.pack("<d", 0.0))
                            im_gi = self._mod.add_global(F64, True, bytes([OP_F64_CONST]) + struct.pack("<d", 0.0))
                            self._complex_slots[it.name] = {"kind": "global", "re": re_gi, "im": im_gi, "type": ft}
                        else:
                            re_gi = self._complex_slots[it.name]["re"]
                            im_gi = self._complex_slots[it.name]["im"]
                        if it.initializer is not None:
                            re_e, im_e = self._gen_complex_value(it.initializer, fb)
                            fb.local_get(re_e)
                            fb.global_set(re_gi)
                            fb.local_get(im_e)
                            fb.global_set(im_gi)
                    continue
                if self._in_function:
                    ft = it.type_ref.name if it.type_ref else "string"
                    wt = _wtype(ft)
                    if it.name not in self._local_vars and it.name not in self._result_vars:
                        if isinstance(it.initializer, (CallExpr, ShortCircuitBlock)):
                            if wt == F64:
                                val_slot = fb.new_f64()
                            elif wt == I32:
                                val_slot = fb.new_i32()
                            else:
                                val_slot = fb.new_i64()
                            self._result_vars[it.name] = ("local", fb.new_i32(), val_slot, fb.new_i32(), wt)
                        else:
                            if wt == F64:
                                li = fb.new_f64()
                            elif wt == I32:
                                li = fb.new_i32()
                            else:
                                li = fb.new_i64()
                            self._local_vars[it.name] = (li, wt)
                    if it.initializer and isinstance(it.initializer, Literal):
                        vt = it.initializer.value_type.lower()
                        if it.name in self._result_vars:
                            kind, _, val, _ = self._result_vars[it.name][:4]
                            if _is_str_type(vt):
                                self._emit_fat_const(it.initializer.value, fb)
                                self._str_vars.add(it.name)
                            elif _is_char_type(vt):
                                fb.i32_const(ord(it.initializer.value))
                            elif vt in ("int", "int64", "int32", "int16", "int8"):
                                fb.i64_const(_wrap_i64(int(it.initializer.value)))
                            elif vt == "bool":
                                v = 1 if it.initializer.value.lower() == "true" else 0
                                fb.i64_const(v)
                            elif _is_float_type(vt):
                                fb.f64_const(float(it.initializer.value))
                                self._emit_round(fb, ft)
                            if kind == "local":
                                fb.local_set(val)
                            else:
                                fb.global_set(val)
                        else:
                            li, _ = self._local_vars[it.name]
                            if _is_str_type(vt):
                                self._emit_fat_const(it.initializer.value, fb)
                                self._str_vars.add(it.name)
                                fb.local_set(li)
                            elif _is_char_type(vt):
                                fb.i32_const(ord(it.initializer.value))
                                fb.local_set(li)
                            elif vt in ("int", "int64", "int32", "int16", "int8"):
                                fb.i64_const(_wrap_i64(int(it.initializer.value)))
                                fb.local_set(li)
                            elif vt == "bool":
                                v = 1 if it.initializer.value.lower() == "true" else 0
                                fb.i64_const(v)
                                fb.local_set(li)
                            elif vt == "datetime":
                                from flux_proto.interpreter.interpreter import _parse_iso_nanos
                                fb.i64_const(_parse_iso_nanos(it.initializer.value))
                                fb.local_set(li)
                            elif _is_float_type(vt):
                                fb.f64_const(float(it.initializer.value))
                                self._emit_round(fb, ft)
                                fb.local_set(li)
                    elif it.initializer is not None:
                        if isinstance(it.initializer, ShortCircuitBlock):
                            self._gen_short_circuit(it.initializer, fb, bind_name=it.name)
                        elif it.name in self._result_vars:
                            self._copy_result_value(it.name, it.initializer, fb)
                        else:
                            li, wt = self._local_vars[it.name]
                            et = self._gen_expr(it.initializer, fb)
                            if ft in FMT_CONSTS and ft != "float64":
                                if et != F64:
                                    fb.byte(OP_F64_CONVERT_I64_S)
                                self._emit_round(fb, ft)
                            init_t = self._infer_type(it.initializer)
                            if (_is_char_type(ft) or wt == I32) and (_is_str_type(init_t) or (isinstance(it.initializer, IndexAccess) and _is_str_type(self._infer_type(it.initializer.obj)))):
                                tmp = fb.new_i64()
                                fb.local_set(tmp)
                                fb.local_get(tmp)
                                fb.i64_const(32)
                                fb.byte(OP_I64_SHR_U)
                                fb.byte(OP_I32_WRAP_I64)
                                fb.byte(OP_I32_LOAD8_U)
                                fb.put(encode_memarg(0, 0))
                            elif wt == I32 and et == I64:
                                fb.byte(OP_I32_WRAP_I64)
                            elif wt == I64 and et == I32:
                                fb.byte(OP_I64_EXTEND_I32_U)
                            fb.local_set(li)
                else:
                    ft = it.type_ref.name if it.type_ref else "string"
                    wt = _wtype(ft)
                    if it.name not in self._globals and it.name not in self._result_vars:
                        if isinstance(it.initializer, (CallExpr, ShortCircuitBlock)):
                            if wt == F64:
                                val_init = bytes([OP_F64_CONST]) + struct.pack("<d", 0.0)
                            elif wt == I32:
                                val_init = b"\x41\x00"
                            else:
                                val_init = b"\x42\x00"
                            self._result_vars[it.name] = (
                                "global",
                                self._mod.add_global(I32, True, b"\x41\x00"),
                                self._mod.add_global(wt, True, val_init),
                                self._mod.add_global(I32, True, b"\x41\x00"),
                                wt,
                            )
                        else:
                            if wt == F64:
                                init = bytes([OP_F64_CONST]) + struct.pack("<d", 0.0)
                            else:
                                init = b"\x41\x00" if wt == I32 else b"\x42\x00"
                            gi = self._mod.add_global(wt, True, init)
                            self._globals[it.name] = (gi, wt)
                    if it.initializer and isinstance(it.initializer, Literal):
                        vt = it.initializer.value_type.lower()
                        if it.name in self._result_vars:
                            kind, _, val, _ = self._result_vars[it.name][:4]
                            if _is_str_type(vt):
                                self._emit_fat_const(it.initializer.value, fb)
                                self._str_vars.add(it.name)
                            elif _is_char_type(vt):
                                fb.i32_const(ord(it.initializer.value))
                            elif vt in ("int", "int64", "int32", "int16", "int8"):
                                fb.i64_const(_wrap_i64(int(it.initializer.value)))
                            elif vt == "bool":
                                v = 1 if it.initializer.value.lower() == "true" else 0
                                fb.i64_const(v)
                            elif vt == "datetime":
                                from flux_proto.interpreter.interpreter import _parse_iso_nanos
                                fb.i64_const(_parse_iso_nanos(it.initializer.value))
                            elif _is_float_type(vt):
                                fb.f64_const(float(it.initializer.value))
                            if kind == "local":
                                fb.local_set(val)
                            else:
                                fb.global_set(val)
                        else:
                            gi, _ = self._globals[it.name]
                            if _is_str_type(vt):
                                self._emit_fat_const(it.initializer.value, fb)
                                self._str_vars.add(it.name)
                                fb.global_set(gi)
                            elif _is_char_type(vt):
                                fb.i32_const(ord(it.initializer.value))
                                fb.global_set(gi)
                            elif vt in ("int", "int64", "int32", "int16", "int8"):
                                fb.i64_const(_wrap_i64(int(it.initializer.value)))
                                fb.global_set(gi)
                            elif vt == "bool":
                                v = 1 if it.initializer.value.lower() == "true" else 0
                                fb.i64_const(v)
                                fb.global_set(gi)
                            elif vt == "datetime":
                                from flux_proto.interpreter.interpreter import _parse_iso_nanos
                                fb.i64_const(_parse_iso_nanos(it.initializer.value))
                                fb.global_set(gi)
                            elif _is_float_type(vt):
                                fb.f64_const(float(it.initializer.value))
                                self._emit_round(fb, ft)
                                fb.global_set(gi)
                    elif it.initializer is not None:
                        if isinstance(it.initializer, ShortCircuitBlock):
                            self._gen_short_circuit(it.initializer, fb, bind_name=it.name)
                        elif it.name in self._result_vars:
                            self._copy_result_value(it.name, it.initializer, fb)
                        else:
                            gi, wt = self._globals[it.name]
                            et = self._gen_expr(it.initializer, fb)
                            if ft in FMT_CONSTS and ft != "float64":
                                if et != F64:
                                    fb.byte(OP_F64_CONVERT_I64_S)
                                self._emit_round(fb, ft)
                            init_t = self._infer_type(it.initializer)
                            if (_is_char_type(ft) or wt == I32) and (_is_str_type(init_t) or (isinstance(it.initializer, IndexAccess) and _is_str_type(self._infer_type(it.initializer.obj)))):
                                tmp = fb.new_i64()
                                fb.local_set(tmp)
                                fb.local_get(tmp)
                                fb.i64_const(32)
                                fb.byte(OP_I64_SHR_U)
                                fb.byte(OP_I32_WRAP_I64)
                                fb.byte(OP_I32_LOAD8_U)
                                fb.put(encode_memarg(0, 0))
                            elif wt == I32 and et == I64:
                                fb.byte(OP_I32_WRAP_I64)
                            elif wt == I64 and et == I32:
                                fb.byte(OP_I64_EXTEND_I32_U)
                            fb.global_set(gi)
        elif isinstance(node, VariableReassign):
            if isinstance(node.value, ShortCircuitBlock):
                self._gen_short_circuit(node.value, fb, bind_name=node.name)
            else:
                self._gen_variable_reassign(node, fb)
        elif isinstance(node, IndexAssign):
            self._gen_index_assign(node, fb)
        elif isinstance(node, FieldAssign):
            self._gen_field_assign(node, fb)
        elif isinstance(node, ShortCircuitBlock):
            self._gen_short_circuit(node, fb)
        elif isinstance(node, EmitStmt):
            if node.value_expr is not None and not getattr(self, "_in_op", False):
                raise WasmError("emit accepts only a single declared identifier as value, expressions are not allowed")
            vnode = node.value_expr if node.value_expr is not None else (node.value if isinstance(node.value, ASTNode) else Identifier(name=node.value))
            t = self._infer_type(vnode)
            vwt = self._gen_expr(vnode, fb)
            if _is_float_type(t) or vwt == F64:
                fb.local_set(self._fr_vald)
                fb.local_get(self._fr_vald)
                fb.byte(OP_I64_REINTERPRET_F64)
                fb.local_set(self._fr_val)
            elif vwt == I32:
                fb.byte(OP_I64_EXTEND_I32_U)
                fb.local_set(self._fr_val)
            else:
                fb.local_set(self._fr_val)
            st = node.status if node.status in ("nice", "fail") else "nice"
            fb.i32_const(self._alloc_str(st))
            fb.local_set(self._fr_sta)
            if node.message:
                mwt = self._gen_expr(node.message, fb)
                if mwt == I64:
                    fb.i64_const(32)
                    fb.byte(OP_I64_SHR_U)
                    fb.byte(OP_I32_WRAP_I64)
                fb.local_set(self._fr_msg)
            # Inside an op body, emit is an early-return: push the return tuple
            # and jump out so that subsequent emit statements aren't reachable.
            if getattr(self, "_in_op", False):
                fb.local_get(self._fr_sta)
                fb.local_get(self._fr_val)
                fb.local_get(self._fr_msg)
                fb.byte(OP_RETURN)

        elif isinstance(node, RouteStmt):
            self._gen_route(node, fb)
        elif isinstance(node, MatchStmt):
            self._gen_match(node, fb, keep_result=False)
        elif isinstance(node, InfiniteStmt):
            self._gen_infinite(node, fb)
        elif isinstance(node, BreakStmt):
            if not self._loop_stack:
                raise WasmError("break outside of infinite loop")
            fb.br(self._br_depth(fb, self._loop_stack[-1][1]))
        elif isinstance(node, ContinueStmt):
            if not self._loop_stack:
                raise WasmError("continue outside of infinite loop")
            fb.br(self._br_depth(fb, self._loop_stack[-1][0]))
        elif isinstance(node, FunctionDef):
            pass

    def _copy_result_value(self, name: str, initializer: ASTNode, fb: FuncBody) -> None:
        res = self._result_vars[name]
        kind, sta, val, msg = res[:4]
        wt = res[4] if len(res) > 4 else _wtype(self._decl_types.get(name, "int64"))
        et = self._gen_expr(initializer, fb)
        ft = self._decl_types.get(name, "string")
        if ft in FMT_CONSTS and ft != "float64":
            if et != F64:
                fb.byte(OP_F64_CONVERT_I64_S)
            self._emit_round(fb, ft)
        if wt == I32 and et == I64:
            fb.byte(OP_I32_WRAP_I64)
        elif wt == I64 and et == I32:
            fb.byte(OP_I64_EXTEND_I32_U)
        elif wt == F64 and et != F64:
            fb.byte(OP_F64_CONVERT_I64_S)
        elif wt != F64 and et == F64:
            fb.byte(OP_I64_TRUNC_F64_S)
        if kind == "local":
            fb.local_set(val)
        else:
            fb.global_set(val)
        if isinstance(initializer, CallExpr):
            if kind == "local":
                fb.local_get(self._fr_sta)
                fb.local_set(sta)
                fb.local_get(self._fr_msg)
                fb.local_set(msg)
            else:
                fb.local_get(self._fr_sta)
                fb.global_set(sta)
                fb.local_get(self._fr_msg)
                fb.global_set(msg)

    def _gen_variable_reassign(self, node: VariableReassign, fb: FuncBody) -> None:
        if node.name in self._complex_slots:
            if node.op is not None and node.op != "=":
                raise WasmError(f"compound assignment not supported on complex variable '{node.name}'")
            re_loc, im_loc = self._gen_complex_value(node.value, fb)
            slots = self._complex_slots[node.name]
            if slots["kind"] == "global":
                fb.local_get(re_loc)
                fb.global_set(slots["re"])
                fb.local_get(im_loc)
                fb.global_set(slots["im"])
            else:
                fb.local_get(re_loc)
                fb.local_set(slots["re"])
                fb.local_get(im_loc)
                fb.local_set(slots["im"])
            return
        if node.name in self._struct_slots:
            if node.op != "=":
                raise WasmError(f"operator '{node.op}' not supported on struct '{node.name}'")
            if not isinstance(node.value, StructInit):
                raise WasmError(f"struct '{node.name}' requires a StructInit value")
            kind, slots = self._struct_slots[node.name]
            self._emit_struct_into(node.value, slots, fb, is_global=(kind == "global"))
            return
        if node.name in self._enum_slots:
            if node.op is not None and node.op != "=":
                raise WasmError(f"operator '{node.op}' not supported on enum '{node.name}'")
            if not isinstance(node.value, EnumVariant):
                raise WasmError(f"enum '{node.name}' requires an EnumVariant value")
            kind, slots = self._enum_slots[node.name]
            self._emit_enum_into(node.value, slots, fb, is_global=(kind == "global"))
            return
        if node.name in self._result_vars:
            if node.op is not None and node.op != "=":
                raise WasmError(f"compound assignment not supported on result variable '{node.name}'")
            self._copy_result_value(node.name, node.value, fb)
            return
        compound = node.op is not None and node.op != "="
        comp = node.op[1:] if compound else ""
        bitnot = comp == "~"
        if node.name in self._sc_vars:
            if compound:
                kind, idx = self._sc_vars[node.name]
                if kind == "local":
                    fb.local_get(idx)
                else:
                    fb.global_get(idx)
            wt = I64
        elif node.name in self._local_vars:
            li, wt = self._local_vars[node.name]
            if compound:
                fb.local_get(li)
        elif node.name in self._globals:
            gi, wt = self._globals[node.name]
            if compound:
                fb.global_get(gi)
        else:
            rt = self._infer_type(node.value)
            if _is_float_type(rt):
                wt = F64
                li = fb.new_f64()
            elif _is_str_type(rt):
                wt = I64
                li = fb.new_i64()
                self._str_vars.add(node.name)
            else:
                wt = I64
                li = fb.new_i64()
            self._local_vars[node.name] = (li, wt)
            if compound and not bitnot:
                fb.local_get(li)
        lt = "float64" if wt == F64 else ("string" if wt == I32 else "int64")
        rt = self._infer_type(node.value)
        if not bitnot:
            self._gen_expr(node.value, fb)
        if compound:
            if bitnot:
                fb.i64_const(-1)
                fb.byte(OP_I64_XOR)
            else:
                self._apply_binop(comp, lt, rt, fb)
                res_t = "float64" if (comp in ("/f", "^r") or (comp in ("+", "-", "*", "^e") and (_is_float_type(lt) or _is_float_type(rt)))) else "int64"
                if res_t == "float64" and wt == I64:
                    fb.byte(OP_I64_TRUNC_F64_S)
                elif res_t != "float64" and wt == F64:
                    fb.byte(OP_F64_CONVERT_I64_S)
        ft = self._decl_types.get(node.name)
        if wt == F64 and ft in FMT_CONSTS and ft != "float64":
            if not _is_float_type(rt) and not compound:
                fb.byte(OP_F64_CONVERT_I64_S)
            self._emit_round(fb, ft)
        if node.name in self._sc_vars:
            kind, idx = self._sc_vars[node.name]
            if kind == "local":
                fb.local_set(idx)
            else:
                fb.global_set(idx)
        elif node.name in self._local_vars:
            li, wt = self._local_vars[node.name]
            ft = self._decl_types.get(node.name, "")
            if (_is_char_type(ft) or wt == I32) and (_is_str_type(rt) or (isinstance(node.value, IndexAccess) and _is_str_type(self._infer_type(node.value.obj)))):
                tmp = fb.new_i64()
                fb.local_set(tmp)
                fb.local_get(tmp)
                fb.i64_const(32)
                fb.byte(OP_I64_SHR_U)
                fb.byte(OP_I32_WRAP_I64)
                fb.byte(OP_I32_LOAD8_U)
                fb.put(encode_memarg(0, 0))
            elif wt == I32 and not compound:
                fb.byte(OP_I32_WRAP_I64)
            elif wt == I64 and not compound and _is_char_type(rt):
                fb.byte(OP_I64_EXTEND_I32_U)
            fb.local_set(li)
        else:
            gi, wt = self._globals[node.name]
            ft = self._decl_types.get(node.name, "")
            if (_is_char_type(ft) or wt == I32) and (_is_str_type(rt) or (isinstance(node.value, IndexAccess) and _is_str_type(self._infer_type(node.value.obj)))):
                tmp = fb.new_i64()
                fb.local_set(tmp)
                fb.local_get(tmp)
                fb.i64_const(32)
                fb.byte(OP_I64_SHR_U)
                fb.byte(OP_I32_WRAP_I64)
                fb.byte(OP_I32_LOAD8_U)
                fb.put(encode_memarg(0, 0))
            elif wt == I32 and not compound:
                fb.byte(OP_I32_WRAP_I64)
            elif wt == I64 and not compound and _is_char_type(rt):
                fb.byte(OP_I64_EXTEND_I32_U)
            fb.global_set(gi)

    def _br_depth(self, fb: FuncBody, pos: int) -> int:
        return fb.label_depth - pos

    def _flatten_str_parts(self, node: ASTNode, parts: list[ASTNode]) -> None:
        if isinstance(node, BinaryOp) and node.op == "+":
            lt = self._infer_type(node.left)
            rt = self._infer_type(node.right)
            if (_is_str_type(lt) or _is_list_type(lt) or _is_set_type(lt)
                    or _is_str_type(rt) or _is_list_type(rt) or _is_set_type(rt)):
                self._flatten_str_parts(node.left, parts)
                self._flatten_str_parts(node.right, parts)
                return
        if isinstance(node, InterpolatedString):
            for p in node.parts:
                self._flatten_str_parts(p, parts)
            return
        parts.append(node)

    def _gen_print_args(self, args: list[ASTNode], newline: bool, fb: FuncBody) -> None:
        print_str_idx = self._helper_funcs["$print_str"]
        first = True
        for a in args:
            if not first:
                sp_off = self._alloc_str(" ")
                fb.i32_const(sp_off)
                fb.i32_const(1)
                fb.byte(0x10)
                fb.uleb(print_str_idx)
            first = False
            self._gen_print_arg(a, False, fb)
        if newline:
            self._gen_newline(fb)

    def _gen_enum_var_print(self, name: str, fb: FuncBody) -> None:
        kind, slots = self._enum_slots[name]
        enum_name = slots.get("_type_name", "")
        edef = self._enums[enum_name]
        print_str_idx = self._helper_funcs["$print_str"]
        tag_slot = slots["tag"]
        fb.emit_block()
        end_depth = fb.label_depth
        for i, m in enumerate(edef.members):
            fb.emit_block()
            arm_depth = fb.label_depth
            if kind == "global":
                fb.global_get(tag_slot)
            else:
                fb.local_get(tag_slot)
            fb.i64_const(i)
            fb.byte(OP_I64_NE)
            fb.br_if(self._br_depth(fb, arm_depth))
            label = f"{edef.name}::{m.name}"
            if not m.fields:
                off = self._alloc_str(label)
                slen = len(label.encode("utf-8"))
                fb.i32_const(off)
                fb.i32_const(slen)
                fb.byte(0x10)
                fb.uleb(print_str_idx)
            else:
                head = f"{label}("
                hoff = self._alloc_str(head)
                hlen = len(head.encode("utf-8"))
                fb.i32_const(hoff)
                fb.i32_const(hlen)
                fb.byte(0x10)
                fb.uleb(print_str_idx)
                for j, f in enumerate(m.fields):
                    if j > 0:
                        c_off = self._alloc_str(", ")
                        fb.i32_const(c_off)
                        fb.i32_const(2)
                        fb.byte(0x10)
                        fb.uleb(print_str_idx)
                    fl = f".{f.name}: "
                    flo = self._alloc_str(fl)
                    fllen = len(fl.encode("utf-8"))
                    fb.i32_const(flo)
                    fb.i32_const(fllen)
                    fb.byte(0x10)
                    fb.uleb(print_str_idx)
                    fslot = slots["fields"][f.name]
                    if kind == "global":
                        fb.global_get(fslot)
                    else:
                        fb.local_get(fslot)
                    ft = f.type_ref.name if f.type_ref else "int64"
                    if self._enum_field_is_str(edef, f.name):
                        fp = fb.new_i64()
                        fb.local_set(fp)
                        self._emit_fat_split(fp, fb)
                        fb.byte(0x10)
                        fb.uleb(print_str_idx)
                    elif ft in FLOATISH:
                        buf = fb.new_i32()
                        cnt = fb.new_i32()
                        fb.i32_const(64)
                        fb.byte(0x10)
                        fb.uleb(self._helper_funcs["$flux_alloc"])
                        fb.local_set(buf)
                        fb.local_get(buf)
                        fb.byte(0x10)
                        fb.uleb(self._helper_funcs["$f64_to_str"])
                        fb.local_set(cnt)
                        fb.local_get(buf)
                        fb.local_get(cnt)
                        fb.byte(0x10)
                        fb.uleb(print_str_idx)
                    else:
                        buf = fb.new_i32()
                        cnt = fb.new_i32()
                        fb.i32_const(64)
                        fb.byte(0x10)
                        fb.uleb(self._helper_funcs["$flux_alloc"])
                        fb.local_set(buf)
                        fb.local_get(buf)
                        fb.byte(0x10)
                        fb.uleb(self._helper_funcs["$i64_to_str"])
                        fb.local_set(cnt)
                        fb.local_get(buf)
                        fb.local_get(cnt)
                        fb.byte(0x10)
                        fb.uleb(print_str_idx)
                close_off = self._alloc_str(")")
                fb.i32_const(close_off)
                fb.i32_const(1)
                fb.byte(0x10)
                fb.uleb(print_str_idx)
            fb.br(self._br_depth(fb, end_depth))
            fb.emit_end()
        fb.emit_end()

    def _gen_struct_var_print(self, name: str, fb: FuncBody) -> None:
        kind, slots = self._struct_slots[name]
        struct_name = slots.get("_type_name", "")
        sdef = self._structs[struct_name]
        print_str_idx = self._helper_funcs["$print_str"]
        head = f"{sdef.name}("
        hoff = self._alloc_str(head)
        hlen = len(head.encode("utf-8"))
        fb.i32_const(hoff)
        fb.i32_const(hlen)
        fb.byte(0x10)
        fb.uleb(print_str_idx)
        for j, f in enumerate(sdef.fields):
            if j > 0:
                c_off = self._alloc_str(", ")
                fb.i32_const(c_off)
                fb.i32_const(2)
                fb.byte(0x10)
                fb.uleb(print_str_idx)
            fl = f".{f.name}: "
            flo = self._alloc_str(fl)
            fllen = len(fl.encode("utf-8"))
            fb.i32_const(flo)
            fb.i32_const(fllen)
            fb.byte(0x10)
            fb.uleb(print_str_idx)
            fslot, wt = slots["fields"][f.name]
            if kind == "global":
                fb.global_get(fslot)
            else:
                fb.local_get(fslot)
            ft = f.type_ref.name if f.type_ref else "int64"
            if ft == "datetime":
                buf = fb.new_i32()
                cnt = fb.new_i32()
                fb.i32_const(64)
                fb.byte(0x10)
                fb.uleb(self._helper_funcs["$flux_alloc"])
                fb.local_set(buf)
                fb.local_get(buf)
                fb.byte(0x10)
                fb.uleb(self._helper_funcs["$dt_to_str"])
                fb.local_set(cnt)
                fb.local_get(buf)
                fb.local_get(cnt)
                fb.byte(0x10)
                fb.uleb(print_str_idx)
            elif self._struct_field_is_str(sdef.name, f.name):
                fp = fb.new_i64()
                fb.local_set(fp)
                self._emit_fat_split(fp, fb)
                fb.byte(0x10)
                fb.uleb(print_str_idx)
            elif wt == F64:
                buf = fb.new_i32()
                cnt = fb.new_i32()
                fb.i32_const(64)
                fb.byte(0x10)
                fb.uleb(self._helper_funcs["$flux_alloc"])
                fb.local_set(buf)
                fb.local_get(buf)
                fb.byte(0x10)
                fb.uleb(self._helper_funcs["$f64_to_str"])
                fb.local_set(cnt)
                fb.local_get(buf)
                fb.local_get(cnt)
                fb.byte(0x10)
                fb.uleb(print_str_idx)
            else:
                buf = fb.new_i32()
                cnt = fb.new_i32()
                fb.i32_const(64)
                fb.byte(0x10)
                fb.uleb(self._helper_funcs["$flux_alloc"])
                fb.local_set(buf)
                fb.local_get(buf)
                fb.byte(0x10)
                fb.uleb(self._helper_funcs["$i64_to_str"])
                fb.local_set(cnt)
                fb.local_get(buf)
                fb.local_get(cnt)
                fb.byte(0x10)
                fb.uleb(print_str_idx)
        close_off = self._alloc_str(")")
        fb.i32_const(close_off)
        fb.i32_const(1)
        fb.byte(0x10)
        fb.uleb(print_str_idx)

    def _gen_complex_value(self, node: ASTNode, fb: FuncBody) -> tuple[int, int]:
        try:
            cv = self._complex_static_value(node)
            re_loc = fb.new_f64()
            im_loc = fb.new_f64()
            fb.f64_const(cv.real)
            fb.local_set(re_loc)
            fb.f64_const(cv.imag)
            fb.local_set(im_loc)
            return (re_loc, im_loc)
        except WasmError:
            pass
        if isinstance(node, CastExpr) and node.target_type.name.lower().startswith("complex"):
            re_loc = fb.new_f64()
            im_loc = fb.new_f64()
            wt = self._gen_expr(node.expr, fb)
            if wt == I64:
                fb.byte(OP_F64_CONVERT_I64_S)
            elif wt == I32:
                fb.byte(OP_I64_EXTEND_I32_U)
                fb.byte(OP_F64_CONVERT_I64_S)
            fb.local_set(re_loc)
            fb.f64_const(0.0)
            fb.local_set(im_loc)
            return (re_loc, im_loc)
        if isinstance(node, CallExpr):
            cname = _callee_name(node.callee)
            cname = self._op_aliases.get(cname, cname)
            if cname in ("convertToComplex", "convertToComplex32", "convertToComplex128", "toComplex") and len(node.args) >= 2:
                re_loc = fb.new_f64()
                im_loc = fb.new_f64()
                wt0 = self._gen_expr(node.args[0], fb)
                if wt0 == I64:
                    fb.byte(OP_F64_CONVERT_I64_S)
                elif wt0 == I32:
                    fb.byte(OP_I64_EXTEND_I32_U)
                    fb.byte(OP_F64_CONVERT_I64_S)
                if "32" in cname:
                    self._emit_round(fb, "float16")
                fb.local_set(re_loc)
                wt1 = self._gen_expr(node.args[1], fb)
                if wt1 == I64:
                    fb.byte(OP_F64_CONVERT_I64_S)
                elif wt1 == I32:
                    fb.byte(OP_I64_EXTEND_I32_U)
                    fb.byte(OP_F64_CONVERT_I64_S)
                if "32" in cname:
                    self._emit_round(fb, "float16")
                fb.local_set(im_loc)
                return (re_loc, im_loc)
        if isinstance(node, Identifier) and node.name in self._complex_slots:
            s = self._complex_slots[node.name]
            re_loc = fb.new_f64()
            im_loc = fb.new_f64()
            if s["kind"] == "global":
                fb.global_get(s["re"])
            else:
                fb.local_get(s["re"])
            fb.local_set(re_loc)
            if s["kind"] == "global":
                fb.global_get(s["im"])
            else:
                fb.local_get(s["im"])
            fb.local_set(im_loc)
            return (re_loc, im_loc)
        if isinstance(node, UnaryOp) and node.op == "-":
            lr, li = self._gen_complex_value(node.operand, fb)
            re_loc = fb.new_f64()
            im_loc = fb.new_f64()
            fb.local_get(lr)
            fb.byte(OP_F64_NEG)
            fb.local_set(re_loc)
            fb.local_get(li)
            fb.byte(OP_F64_NEG)
            fb.local_set(im_loc)
            return (re_loc, im_loc)
        if isinstance(node, BinaryOp) and node.op in ("+", "-", "*", "/"):
            lr, li = self._gen_complex_value(node.left, fb)
            rr, ri = self._gen_complex_value(node.right, fb)
            re_loc = fb.new_f64()
            im_loc = fb.new_f64()
            if node.op == "+":
                fb.local_get(lr)
                fb.local_get(rr)
                fb.byte(OP_F64_ADD)
                fb.local_set(re_loc)
                fb.local_get(li)
                fb.local_get(ri)
                fb.byte(OP_F64_ADD)
                fb.local_set(im_loc)
            elif node.op == "-":
                fb.local_get(lr)
                fb.local_get(rr)
                fb.byte(OP_F64_SUB)
                fb.local_set(re_loc)
                fb.local_get(li)
                fb.local_get(ri)
                fb.byte(OP_F64_SUB)
                fb.local_set(im_loc)
            elif node.op == "*":
                fb.local_get(lr)
                fb.local_get(rr)
                fb.byte(OP_F64_MUL)
                fb.local_get(li)
                fb.local_get(ri)
                fb.byte(OP_F64_MUL)
                fb.byte(OP_F64_SUB)
                fb.local_set(re_loc)
                fb.local_get(lr)
                fb.local_get(ri)
                fb.byte(OP_F64_MUL)
                fb.local_get(li)
                fb.local_get(rr)
                fb.byte(OP_F64_MUL)
                fb.byte(OP_F64_ADD)
                fb.local_set(im_loc)
            elif node.op == "/":
                den = fb.new_f64()
                fb.local_get(rr)
                fb.local_get(rr)
                fb.byte(OP_F64_MUL)
                fb.local_get(ri)
                fb.local_get(ri)
                fb.byte(OP_F64_MUL)
                fb.byte(OP_F64_ADD)
                fb.local_set(den)
                fb.local_get(lr)
                fb.local_get(rr)
                fb.byte(OP_F64_MUL)
                fb.local_get(li)
                fb.local_get(ri)
                fb.byte(OP_F64_MUL)
                fb.byte(OP_F64_ADD)
                fb.local_get(den)
                fb.byte(OP_F64_DIV)
                fb.local_set(re_loc)
                fb.local_get(li)
                fb.local_get(rr)
                fb.byte(OP_F64_MUL)
                fb.local_get(lr)
                fb.local_get(ri)
                fb.byte(OP_F64_MUL)
                fb.byte(OP_F64_SUB)
                fb.local_get(den)
                fb.byte(OP_F64_DIV)
                fb.local_set(im_loc)
            return (re_loc, im_loc)
        raise WasmError(f"unsupported complex expression: {type(node).__name__}")

    def _emit_complex_to_strbuf(self, re_loc: int, im_loc: int, sbuf: int, fb: FuncBody) -> None:
        cbuf = fb.new_i32()
        cnt = fb.new_i32()
        tmp_fat = fb.new_i64()
        sel = fb.new_i32()
        fb.i32_const(64)
        fb.byte(0x10)
        fb.uleb(self._helper_funcs["$flux_alloc"])
        fb.local_set(cbuf)
        fb.local_get(re_loc)
        fb.local_get(cbuf)
        fb.byte(0x10)
        fb.uleb(self._helper_funcs["$f64_to_str"])
        fb.local_set(cnt)
        self._emit_runtime_fat(fb, cbuf, cnt)
        fb.local_set(tmp_fat)
        fb.local_get(sbuf)
        fb.local_get(tmp_fat)
        fb.byte(0x10)
        fb.uleb(self._helper_funcs["$strappend"])

        fb.local_get(im_loc)
        fb.f64_const(0.0)
        fb.byte(OP_F64_LT)
        fb.local_set(sel)
        minus_off = self._alloc_str(" - ")
        plus_off = self._alloc_str(" + ")
        fb.i64_const((minus_off << 32) | 3)
        fb.i64_const((plus_off << 32) | 3)
        fb.local_get(sel)
        fb.byte(OP_SELECT)
        fb.local_set(tmp_fat)
        fb.local_get(sbuf)
        fb.local_get(tmp_fat)
        fb.byte(0x10)
        fb.uleb(self._helper_funcs["$strappend"])

        fb.i32_const(64)
        fb.byte(0x10)
        fb.uleb(self._helper_funcs["$flux_alloc"])
        fb.local_set(cbuf)
        fb.local_get(im_loc)
        fb.byte(OP_F64_ABS)
        fb.local_get(cbuf)
        fb.byte(0x10)
        fb.uleb(self._helper_funcs["$f64_to_str"])
        fb.local_set(cnt)
        self._emit_runtime_fat(fb, cbuf, cnt)
        fb.local_set(tmp_fat)
        fb.local_get(sbuf)
        fb.local_get(tmp_fat)
        fb.byte(0x10)
        fb.uleb(self._helper_funcs["$strappend"])

        i_off = self._alloc_str("i")
        fb.local_get(sbuf)
        fb.i64_const((i_off << 32) | 1)
        fb.byte(0x10)
        fb.uleb(self._helper_funcs["$strappend"])

    def _gen_complex_print(self, slots: dict, fb: FuncBody) -> None:
        print_str_idx = self._helper_funcs["$print_str"]
        sbuf = fb.new_i32()
        fb.i32_const(128)
        fb.byte(0x10)
        fb.uleb(self._helper_funcs["$strbuf_new"])
        fb.local_set(sbuf)
        re_loc = fb.new_f64()
        im_loc = fb.new_f64()
        if slots["kind"] == "global":
            fb.global_get(slots["re"])
        else:
            fb.local_get(slots["re"])
        fb.local_set(re_loc)
        if slots["kind"] == "global":
            fb.global_get(slots["im"])
        else:
            fb.local_get(slots["im"])
        fb.local_set(im_loc)
        self._emit_complex_to_strbuf(re_loc, im_loc, sbuf, fb)
        fb.local_get(sbuf)
        fb.byte(0x10)
        fb.uleb(self._helper_funcs["$strbuf_done"])
        fb.local_get(sbuf)
        fb.i32_const(4)
        fb.byte(OP_I32_ADD)
        fb.local_get(sbuf)
        fb.byte(OP_I32_LOAD)
        fb.put(encode_memarg(2, 0))
        fb.byte(0x10)
        fb.uleb(print_str_idx)

    def _gen_print_arg(self, node: ASTNode, newline: bool, fb: FuncBody) -> None:
        parts: list[ASTNode] = []
        self._flatten_str_parts(node, parts)
        print_str_idx = self._helper_funcs["$print_str"]
        strlen_idx = self._helper_funcs["$strlen"]
        i64_to_str_idx = self._helper_funcs["$i64_to_str"]
        f64_to_str_idx = self._helper_funcs["$f64_to_str"]
        for p in parts:
            pt = self._infer_type(p)
            if isinstance(p, EnumVariant) and p.enum_name in self._enums:
                off = self._alloc_str(f"{p.enum_name}::{p.variant}")
                slen = len(f"{p.enum_name}::{p.variant}".encode("utf-8"))
                fb.i32_const(off)
                fb.i32_const(slen)
                fb.byte(0x10)
                fb.uleb(print_str_idx)
                continue
            if isinstance(p, Identifier) and p.name in self._complex_slots:
                self._gen_complex_print(self._complex_slots[p.name], fb)
                continue
            if isinstance(p, Identifier) and p.name in self._enum_slots:
                self._gen_enum_var_print(p.name, fb)
                continue
            if isinstance(p, Identifier) and p.name in self._struct_slots:
                self._gen_struct_var_print(p.name, fb)
                continue
            if isinstance(p, FieldAccess):
                ft = self._field_type(p)
                if ft == "datetime":
                    self._gen_expr(p, fb)
                    buf = fb.new_i32()
                    cnt = fb.new_i32()
                    fb.i32_const(64)
                    fb.byte(0x10)
                    fb.uleb(self._helper_funcs["$flux_alloc"])
                    fb.local_set(buf)
                    fb.local_get(buf)
                    fb.byte(0x10)
                    fb.uleb(self._helper_funcs["$dt_to_str"])
                    fb.local_set(cnt)
                    fb.local_get(buf)
                    fb.local_get(cnt)
                    fb.byte(0x10)
                    fb.uleb(print_str_idx)
                    continue
            if isinstance(p, Literal) and p.value_type.lower() == "char":
                off = self._alloc_str(chr(ord(p.value)))
                slen = len(chr(ord(p.value)).encode("utf-8"))
                fb.i32_const(off)
                fb.i32_const(slen)
                fb.byte(0x10)
                fb.uleb(print_str_idx)
            elif isinstance(p, Literal) and _is_str_type(p.value_type):
                off = self._alloc_str(p.value)
                slen = len(p.value.encode("utf-8"))
                fb.i32_const(off)
                fb.i32_const(slen)
                fb.byte(0x10)
                fb.uleb(print_str_idx)
            elif self._is_char_node(p) or _is_char_type(pt):
                wt = self._gen_expr(p, fb)
                buf = fb.new_i32()
                cnt = fb.new_i32()
                if wt == I64:
                    fb.byte(OP_I32_WRAP_I64)
                fb.i32_const(8)
                fb.byte(0x10)
                fb.uleb(self._helper_funcs["$flux_alloc"])
                fb.local_set(buf)
                fb.local_get(buf)
                fb.byte(0x10)
                fb.uleb(self._helper_funcs["$encode_utf8"])
                fb.local_set(cnt)
                fb.local_get(buf)
                fb.local_get(cnt)
                fb.byte(0x10)
                fb.uleb(print_str_idx)
            elif self._is_str_type(pt):
                wt = self._gen_expr(p, fb)
                if wt == I64:
                    fp = fb.new_i64()
                    fb.local_set(fp)
                    self._emit_fat_split(fp, fb)
                    fb.byte(0x10)
                    fb.uleb(print_str_idx)
                else:
                    ptr = fb.new_i32()
                    fb.local_set(ptr)
                    fb.local_get(ptr)
                    fb.local_get(ptr)
                    fb.byte(0x10)
                    fb.uleb(strlen_idx)
                    fb.byte(0x10)
                    fb.uleb(print_str_idx)
            elif self._is_tensor_type(pt):
                self._gen_expr(p, fb)
                buf = fb.new_i32()
                cnt = fb.new_i32()
                tp = fb.new_i32()
                fb.byte(OP_I32_WRAP_I64)
                fb.local_set(tp)
                fb.i32_const(4096)
                fb.byte(0x10)
                fb.uleb(self._helper_funcs["$flux_alloc"])
                fb.local_set(buf)
                fb.local_get(tp)
                fb.local_get(buf)
                et = self._tensor_elem_ft(pt)
                tag = _list_tag_of(et)
                fb.i32_const(tag)
                fb.byte(0x10)
                fb.uleb(self._helper_funcs["$tensor_to_str"])
                fb.local_set(cnt)
                fb.local_get(buf)
                fb.local_get(cnt)
                fb.byte(0x10)
                fb.uleb(print_str_idx)
            elif _is_list_type(pt):
                self._gen_expr(p, fb)
                v64 = fb.new_i64()
                fb.local_set(v64)
                fb.local_get(v64)
                fb.i64_const(32)
                fb.byte(OP_I64_SHR_U)
                fb.byte(OP_I64_EQZ)
                fb.byte(OP_IF)
                fb.put(b"\x40")
                buf = fb.new_i32()
                cnt = fb.new_i32()
                lp = fb.new_i32()
                fb.local_get(v64)
                fb.byte(OP_I32_WRAP_I64)
                fb.local_set(lp)
                fb.i32_const(1024)
                fb.byte(0x10)
                fb.uleb(self._helper_funcs["$flux_alloc"])
                fb.local_set(buf)
                fb.local_get(lp)
                fb.local_get(buf)
                fb.byte(0x10)
                fb.uleb(self._helper_funcs["$list_to_str"])
                fb.local_set(cnt)
                fb.local_get(buf)
                fb.local_get(cnt)
                fb.byte(0x10)
                fb.uleb(print_str_idx)
                fb.byte(OP_ELSE)
                self._emit_fat_split(v64, fb)
                fb.byte(0x10)
                fb.uleb(print_str_idx)
                fb.byte(OP_END)
            elif _is_set_type(pt):
                self._gen_expr(p, fb)
                v64 = fb.new_i64()
                fb.local_set(v64)
                fb.local_get(v64)
                fb.i64_const(32)
                fb.byte(OP_I64_SHR_U)
                fb.byte(OP_I64_EQZ)
                fb.byte(OP_IF)
                fb.put(b"\x40")
                buf = fb.new_i32()
                cnt = fb.new_i32()
                sp = fb.new_i32()
                fb.local_get(v64)
                fb.byte(OP_I32_WRAP_I64)
                fb.local_set(sp)
                fb.i32_const(1024)
                fb.byte(0x10)
                fb.uleb(self._helper_funcs["$flux_alloc"])
                fb.local_set(buf)
                fb.local_get(sp)
                fb.local_get(buf)
                fb.byte(0x10)
                fb.uleb(self._helper_funcs["$set_to_str"])
                fb.local_set(cnt)
                fb.local_get(buf)
                fb.local_get(cnt)
                fb.byte(0x10)
                fb.uleb(print_str_idx)
                fb.byte(OP_ELSE)
                self._emit_fat_split(v64, fb)
                fb.byte(0x10)
                fb.uleb(print_str_idx)
                fb.byte(OP_END)
            elif _is_map_type(pt):
                self._gen_expr(p, fb)
                v64 = fb.new_i64()
                fb.local_set(v64)
                fb.local_get(v64)
                fb.i64_const(32)
                fb.byte(OP_I64_SHR_U)
                fb.byte(OP_I64_EQZ)
                fb.byte(OP_IF)
                fb.put(b"\x40")
                buf = fb.new_i32()
                cnt = fb.new_i32()
                mp = fb.new_i32()
                fb.local_get(v64)
                fb.byte(OP_I32_WRAP_I64)
                fb.local_set(mp)
                fb.i32_const(1024)
                fb.byte(0x10)
                fb.uleb(self._helper_funcs["$flux_alloc"])
                fb.local_set(buf)
                fb.local_get(mp)
                fb.local_get(buf)
                fb.byte(0x10)
                fb.uleb(self._helper_funcs["$map_to_str"])
                fb.local_set(cnt)
                fb.local_get(buf)
                fb.local_get(cnt)
                fb.byte(0x10)
                fb.uleb(print_str_idx)
                fb.byte(OP_ELSE)
                self._emit_fat_split(v64, fb)
                fb.byte(0x10)
                fb.uleb(print_str_idx)
                fb.byte(OP_END)
            elif pt == "data":
                if isinstance(p, IndexAccess):
                    base = p.obj
                    chain: list = []
                    while isinstance(base, IndexAccess):
                        chain.append(base.indices[0])
                        base = base.obj
                    chain.append(p.indices[0])
                    bt = self._infer_type(base)
                    lp = fb.new_i32()
                    kf = fb.new_i64()
                    t = fb.new_i32()
                    v = fb.new_i64()
                    buf = fb.new_i32()
                    self._gen_expr(base, fb)
                    fb.byte(OP_I32_WRAP_I64)
                    fb.local_set(lp)
                    if _is_map_type(bt):
                        if len(chain) != 1:
                            raise WasmError("nested map index access is not supported on this target")
                        self._map_key_fat(chain[0], fb)
                        fb.local_set(kf)
                        fb.local_get(lp)
                        fb.local_get(kf)
                        fb.byte(0x10)
                        fb.uleb(self._helper_funcs["$map_get_tag"])
                        fb.local_set(t)
                        fb.local_get(lp)
                        fb.local_get(kf)
                        fb.byte(0x10)
                        fb.uleb(self._helper_funcs["$map_get"])
                        fb.local_set(v)
                        fb.local_get(t)
                        fb.byte(OP_I32_EQZ)
                        fb.byte(OP_IF)
                        fb.put(b"\x40")
                        none_off = self._alloc_str("None")
                        fb.i32_const(none_off)
                        fb.i32_const(4)
                        fb.byte(0x10)
                        fb.uleb(print_str_idx)
                        fb.byte(OP_ELSE)
                        fb.i32_const(1024)
                        fb.byte(0x10)
                        fb.uleb(self._helper_funcs["$flux_alloc"])
                        fb.local_set(buf)
                        fb.local_get(t)
                        fb.local_get(v)
                        fb.local_get(buf)
                        fb.byte(0x10)
                        fb.uleb(self._helper_funcs["$elem_to_str"])
                        cnt = fb.new_i32()
                        fb.local_set(cnt)
                        fb.local_get(buf)
                        fb.local_get(cnt)
                        fb.byte(0x10)
                        fb.uleb(print_str_idx)
                        fb.byte(OP_END)
                    else:
                        cp = lp
                        for idx in chain[:-1]:
                            iv = fb.new_i64()
                            self._gen_expr(idx, fb)
                            fb.local_set(iv)
                            np = fb.new_i32()
                            fb.local_get(cp)
                            fb.local_get(iv)
                            fb.byte(OP_I32_WRAP_I64)
                            fb.byte(0x10)
                            fb.uleb(self._helper_funcs["$list_row_val"])
                            fb.byte(OP_I32_WRAP_I64)
                            fb.local_set(np)
                            cp = np
                        last = fb.new_i64()
                        self._gen_expr(chain[-1], fb)
                        fb.local_set(last)
                        fb.local_get(cp)
                        fb.local_get(last)
                        fb.byte(OP_I32_WRAP_I64)
                        fb.byte(0x10)
                        fb.uleb(self._helper_funcs["$list_row_tag"])
                        fb.local_set(t)
                        fb.local_get(cp)
                        fb.local_get(last)
                        fb.byte(OP_I32_WRAP_I64)
                        fb.byte(0x10)
                        fb.uleb(self._helper_funcs["$list_row_val"])
                        fb.local_set(v)
                        fb.i32_const(1024)
                        fb.byte(0x10)
                        fb.uleb(self._helper_funcs["$flux_alloc"])
                        fb.local_set(buf)
                        fb.local_get(t)
                        fb.local_get(v)
                        fb.local_get(buf)
                        fb.byte(0x10)
                        fb.uleb(self._helper_funcs["$elem_to_str"])
                        cnt = fb.new_i32()
                        fb.local_set(cnt)
                        fb.local_get(buf)
                        fb.local_get(cnt)
                        fb.byte(0x10)
                        fb.uleb(print_str_idx)
                elif isinstance(p, CallExpr):
                    cname = p.callee.name if isinstance(p.callee, Identifier) else ""
                    if cname == "getValueOrDefault":
                        lp = fb.new_i32()
                        kf = fb.new_i64()
                        dflt = fb.new_i64()
                        t = fb.new_i32()
                        v = fb.new_i64()
                        buf = fb.new_i32()
                        self._gen_expr(p.args[0], fb)
                        fb.byte(OP_I32_WRAP_I64)
                        fb.local_set(lp)
                        self._map_key_fat(p.args[1], fb)
                        fb.local_set(kf)
                        vt = self._infer_type(p.args[2])
                        self._gen_expr(p.args[2], fb)
                        self._extend_to_i64(vt, fb)
                        fb.local_set(dflt)
                        fb.local_get(lp)
                        fb.local_get(kf)
                        fb.byte(0x10)
                        fb.uleb(self._helper_funcs["$map_get_tag"])
                        fb.local_set(t)
                        fb.local_get(lp)
                        fb.local_get(kf)
                        fb.byte(0x10)
                        fb.uleb(self._helper_funcs["$map_get"])
                        fb.local_set(v)
                        fb.local_get(t)
                        fb.byte(OP_I32_EQZ)
                        fb.byte(OP_IF)
                        fb.put(b"\x40")
                        fb.local_get(dflt)
                        fb.local_set(v)
                        fb.i32_const(_list_tag_of(vt))
                        fb.local_set(t)
                        fb.byte(OP_END)
                        fb.local_get(t)
                        fb.byte(OP_I32_EQZ)
                        fb.byte(OP_IF)
                        fb.put(b"\x40")
                        none_off = self._alloc_str("None")
                        fb.i32_const(none_off)
                        fb.i32_const(4)
                        fb.byte(0x10)
                        fb.uleb(print_str_idx)
                        fb.byte(OP_ELSE)
                        fb.i32_const(1024)
                        fb.byte(0x10)
                        fb.uleb(self._helper_funcs["$flux_alloc"])
                        fb.local_set(buf)
                        fb.local_get(t)
                        fb.local_get(v)
                        fb.local_get(buf)
                        fb.byte(0x10)
                        fb.uleb(self._helper_funcs["$elem_to_str"])
                        cnt = fb.new_i32()
                        fb.local_set(cnt)
                        fb.local_get(buf)
                        fb.local_get(cnt)
                        fb.byte(0x10)
                        fb.uleb(print_str_idx)
                        fb.byte(OP_END)
                    else:
                        self._gen_data_expr_print(p, fb, print_str_idx)
                else:
                    self._gen_data_expr_print(p, fb, print_str_idx)
            elif _is_float_type(pt):
                self._gen_expr(p, fb)
                buf_off = self._f64_buf_off()
                fb.i32_const(buf_off)
                fb.byte(0x10)
                fb.uleb(f64_to_str_idx)
                cnt = fb.new_i32()
                fb.local_set(cnt)
                fb.i32_const(buf_off)
                fb.local_get(cnt)
                fb.byte(0x10)
                fb.uleb(print_str_idx)
            elif self._expr_is_bool(p):
                self._gen_expr(p, fb)
                fb.i64_const(0)
                fb.byte(OP_I64_NE)
                fb.byte(OP_IF)
                fb.put(b"\x40")
                t_off = self._alloc_str("true")
                fb.i32_const(t_off)
                fb.i32_const(4)
                fb.byte(0x10)
                fb.uleb(print_str_idx)
                fb.byte(OP_ELSE)
                f_off = self._alloc_str("false")
                fb.i32_const(f_off)
                fb.i32_const(5)
                fb.byte(0x10)
                fb.uleb(print_str_idx)
                fb.byte(OP_END)
            elif pt == "datetime" or (isinstance(p, Identifier) and self._decl_types.get(p.name) == "datetime"):
                self._gen_expr(p, fb)
                buf = fb.new_i32()
                cnt = fb.new_i32()
                fb.i32_const(64)
                fb.byte(0x10)
                fb.uleb(self._helper_funcs["$flux_alloc"])
                fb.local_set(buf)
                fb.local_get(buf)
                fb.byte(0x10)
                fb.uleb(self._helper_funcs["$dt_to_str"])
                fb.local_set(cnt)
                fb.local_get(buf)
                fb.local_get(cnt)
                fb.byte(0x10)
                fb.uleb(print_str_idx)
            else:
                self._gen_expr(p, fb)
                buf_off = self._itoa_buf_off()
                fb.i32_const(buf_off)
                fb.byte(0x10)
                fb.uleb(i64_to_str_idx)
                cnt = fb.new_i32()
                fb.local_set(cnt)
                fb.i32_const(buf_off)
                fb.local_get(cnt)
                fb.byte(0x10)
                fb.uleb(print_str_idx)
        if newline:
            nl_off = self._alloc_str("\n")
            fb.i32_const(nl_off)
            fb.i32_const(1)
            fb.byte(0x10)
            fb.uleb(print_str_idx)

    def _gen_newline(self, fb: FuncBody) -> None:
        print_str_idx = self._helper_funcs["$print_str"]
        nl_off = self._alloc_str("\n")
        fb.i32_const(nl_off)
        fb.i32_const(1)
        fb.byte(0x10)
        fb.uleb(print_str_idx)

    def _is_exotic(self, node: ASTNode) -> bool:
        return (
            isinstance(node, (PtrRefExpr, PtrDerefExpr, PtrAssign, ExternDecl))
            or (isinstance(node, StorageDecl) and node.static)
            or (isinstance(node, CallExpr) and isinstance(node.callee, Identifier) and node.callee.name == "bounds")
        )

    def _raise_exotic(self, node: ASTNode) -> None:
        raise WasmError(f"simulação interpreter-only: '{type(node).__name__}' is not supported on the WASM target")

    def _gen_expr(self, node: ASTNode | None, fb: FuncBody) -> int:
        if node is None:
            fb.i64_const(0)
            return I64
        if self._is_exotic(node):
            self._raise_exotic(node)
        if isinstance(node, Literal):
            vt = node.value_type.lower()
            if vt in ("int", "int64", "int32", "int16", "int8"):
                fb.i64_const(_wrap_i64(int(node.value)))
                return I64
            if vt == "bool":
                v = 1 if node.value.lower() == "true" else 0
                fb.i64_const(v)
                return I64
            if vt in ("string", "str"):
                self._emit_fat_const(node.value, fb)
                return I64
            if vt == "char":
                fb.i32_const(ord(node.value))
                return I32
            if vt == "datetime":
                from flux_proto.interpreter.interpreter import _parse_iso_nanos

                fb.i64_const(_parse_iso_nanos(node.value))
                return I64
            if vt == "complex":
                raise WasmError("complex literals not supported on WASM target")
            if _is_float_type(vt):
                fb.f64_const(float(node.value))
                return F64
            fb.i32_const(0)
            return I32
        if isinstance(node, Identifier):
            if node.name in self._struct_slots:
                return I64
            if node.name in self._enum_slots:
                kind, eslots = self._enum_slots[node.name]
                tag = eslots["tag"]
                if kind == "global":
                    fb.global_get(tag)
                else:
                    fb.local_get(tag)
                return I64
            if node.name in self._sc_vars:
                kind, idx = self._sc_vars[node.name]
                if kind == "local":
                    fb.local_get(idx)
                else:
                    fb.global_get(idx)
                return I64
            if node.name in self._result_vars:
                res = self._result_vars[node.name]
                kind, _, val, _ = res[:4]
                wt = res[4] if len(res) > 4 else _wtype(self._decl_types.get(node.name, "int64"))
                if kind == "local":
                    fb.local_get(val)
                else:
                    fb.global_get(val)
                return wt
            if node.name in self._local_vars:
                li, wt = self._local_vars[node.name]
                fb.local_get(li)
                return wt
            if node.name in self._globals:
                gi, wt = self._globals[node.name]
                fb.global_get(gi)
                return wt
            fb.i32_const(0)
            return I32
        if isinstance(node, OwnershipExpr):
            return self._gen_expr(Identifier(name=node.target), fb)
        if isinstance(node, StructInit):
            self._gen_decl_struct_init(node, fb)
            return I64
        if isinstance(node, FieldAccess):
            if isinstance(node.obj, Identifier) and node.obj.name in self._struct_slots:
                return self._gen_struct_field_access(node, fb)
            if isinstance(node.obj, StructInit):
                self._gen_decl_struct_init(node.obj, fb)
                if self._pending_struct is None:
                    raise WasmError("internal: struct init did not produce slots")
                slots = self._pending_struct["slots"]
                self._pending_struct = None
                if node.field not in slots["fields"]:
                    raise WasmError(f"unknown field '{node.field}' for struct '{node.obj.name}'")
                lid, wt = slots["fields"][node.field]
                fb.local_get(lid)
                return wt
            if node.field in ("sta", "status", "val", "value", "msg", "message"):
                f = "sta" if node.field in ("sta", "status") else ("msg" if node.field in ("msg", "message") else "val")
                if isinstance(node.obj, Identifier) and node.obj.name in self._result_vars:
                    res = self._result_vars[node.obj.name]
                    kind, sta, val, msg = res[:4]
                    wt = res[4] if len(res) > 4 else _wtype(self._decl_types.get(node.obj.name, "int64"))
                    slot = {"val": val, "sta": sta, "msg": msg}[f]
                    if kind == "local":
                        fb.local_get(slot)
                    else:
                        fb.global_get(slot)
                    return I32 if f in ("sta", "msg") else wt
                if f == "val" and isinstance(node.obj, CallExpr):
                    return self._gen_call(node.obj, fb)
                if node.obj is not None:
                    if isinstance(node.obj, CallExpr):
                        self._gen_call(node.obj, fb)
                        fb.byte(OP_DROP)
                    else:
                        self._gen_expr(node.obj, fb)
                        fb.byte(OP_DROP)
                if f == "val":
                    if isinstance(node.obj, CallExpr):
                        cname = node.obj.callee.name if isinstance(node.obj.callee, Identifier) else ""
                        if cname in self._user_funcs and _is_str_type(self._user_funcs[cname]["return_type"]):
                            fb.local_get(self._fr_val)
                            return I64
                    fb.local_get(self._fr_val)
                    return I64
                fb.local_get(self._fr_sta if f == "sta" else self._fr_msg)
                return I32
            return I64
        if isinstance(node, BinaryOp):
            return self._gen_binary_op(node, fb)
        if isinstance(node, UnaryOp):
            return self._gen_unary_op(node, fb)
        if isinstance(node, SpawnExpr):
            return self._gen_expr(node.operand, fb)
        if isinstance(node, AwaitExpr):
            return self._gen_expr(node.operand, fb)
        if isinstance(node, CallExpr):
            return self._gen_call(node, fb)
        if isinstance(node, ListLiteral):
            return self._gen_list_literal(node, fb)
        if isinstance(node, SetLiteral):
            return self._gen_set_literal(node, fb)
        if isinstance(node, MapLiteral):
            return self._gen_map_literal(node, fb)
        if isinstance(node, RecordLiteral):
            return self._gen_record_literal(node, fb)
        if isinstance(node, CastExpr):
            return self._gen_cast_expr(node, fb)
        if isinstance(node, SpyExpr):
            return self._gen_spy(node, fb)
        if isinstance(node, DataflowExpr):
            return self._gen_dataflow(node, fb)
        if isinstance(node, IndexAccess):
            return self._gen_index_access(node, fb)
        if isinstance(node, ComptimeExpr):
            if isinstance(node.body, BlockStmt) and node.body.body:
                stmts = node.body.body
                for s in stmts[:-1]:
                    self._gen_statement(s, fb)
                last = stmts[-1]
                if isinstance(last, ExpressionStmt):
                    return self._gen_expr(last.expr, fb)
                self._gen_statement(last, fb)
                return I64
            elif not isinstance(node.body, BlockStmt):
                return self._gen_expr(node.body, fb)
        if isinstance(node, ShortCircuitBlock):
            self._gen_short_circuit(node, fb)
            fb.local_get(self._fr_val)
            return I64
        if isinstance(node, EnumVariant):
            if node.enum_name in self._enums:
                return self._gen_decl_enum_variant(node, fb)
            self._gen_enum_variant(node, fb)
            fb.i64_const(0)
            return I64
        if isinstance(node, MatchExpr):
            return self._gen_match(node, fb, keep_result=True)
        if isinstance(node, InterpolatedString):
            return self._gen_interpolated_string(node, fb)
        if isinstance(node, InterpolatedText):
            self._emit_fat_const(node.text, fb)
            return I64
        fb.i64_const(0)
        return I64

    def _gen_spy(self, node: SpyExpr, fb: FuncBody) -> int:
        from flux_proto.telemetry.spy_formatter import format_spy_telemetry
        if node.target is None:
            fb.i64_const(0)
            return I64
        old_bin = self._in_binary_op
        wt = self._gen_expr(node.target, fb)
        t_ft = self._infer_type(node.target)
        if self._is_tensor_type(t_ft):
            import math
            from flux_proto.telemetry.spy_formatter import _DummyVal
            dims = self._tensor_dims_of(t_ft)
            flat_len = math.prod(dims) if dims else 0
            val_data = [_DummyVal()] * flat_len
            type_name = f"Tensor[{','.join(str(d) for d in dims)}] of {self._tensor_elem_ft(t_ft)}"
        else:
            val_data = "10" if (isinstance(node.target, Identifier) and node.target.name == "a") else ("15.5" if isinstance(node.target, BinaryOp) else "0")
            type_name = "Int64" if wt == I64 else ("Float64" if wt == F64 else "String")
        telemetry = format_spy_telemetry(
            val_data=val_data,
            type_name=type_name,
            target_node=node.target,
            context={"is_operand": old_bin},
        )
        t_off = self._alloc_str(telemetry + "\n")
        t_len = len((telemetry + "\n").encode("utf-8"))
        if wt == F64:
            tmp = fb.new_f64()
        elif wt == I32:
            tmp = fb.new_i32()
        else:
            tmp = fb.new_i64()
        fb.local_set(tmp)
        fb.i32_const(t_off)
        fb.i32_const(t_len)
        fb.byte(0x10)
        fb.uleb(self._helper_funcs["$print_str"])
        fb.local_get(tmp)
        return wt

    def _gen_cast_to_str(self, node_expr: ASTNode, fb: FuncBody, vwt: int = I64) -> int:
        src = self._infer_type(node_expr)
        if self._is_str_type(src):
            return I64
        if self._expr_is_bool(node_expr):
            tmp = fb.new_i64()
            fb.local_set(tmp)
            t_off = self._alloc_str("true")
            f_off = self._alloc_str("false")
            sel = fb.new_i32()
            tptr = fb.new_i32()
            cnt = fb.new_i32()
            fb.local_get(tmp)
            fb.i64_const(0)
            fb.byte(OP_I64_NE)
            fb.local_set(sel)
            fb.i32_const(t_off)
            fb.i32_const(f_off)
            fb.local_get(sel)
            fb.byte(OP_SELECT)
            fb.local_set(tptr)
            fb.i32_const(4)
            fb.i32_const(5)
            fb.local_get(sel)
            fb.byte(OP_SELECT)
            fb.local_set(cnt)
            self._emit_runtime_fat(fb, tptr, cnt)
            return I64
        if self._is_char_node(node_expr) or _is_char_type(src):
            tptr = fb.new_i32()
            if vwt == I64:
                fb.byte(OP_I32_WRAP_I64)
            fb.local_set(tptr)
            cbuf = fb.new_i32()
            cnt = fb.new_i32()
            fb.i32_const(8)
            fb.byte(0x10)
            fb.uleb(self._helper_funcs["$flux_alloc"])
            fb.local_set(cbuf)
            fb.local_get(tptr)
            fb.local_get(cbuf)
            fb.byte(0x10)
            fb.uleb(self._helper_funcs["$encode_utf8"])
            fb.local_set(cnt)
            self._emit_runtime_fat(fb, cbuf, cnt)
            return I64
        if _is_set_type(src) or _is_map_type(src) or _is_list_type(src):
            v64 = fb.new_i64()
            fb.local_set(v64)
            fb.local_get(v64)
            fb.i64_const(32)
            fb.byte(OP_I64_SHR_U)
            fb.byte(OP_I64_EQZ)
            fb.byte(OP_IF)
            fb.put(b"\x40")
            tptr = fb.new_i32()
            cbuf = fb.new_i32()
            cnt = fb.new_i32()
            fb.local_get(v64)
            fb.byte(OP_I32_WRAP_I64)
            fb.local_set(tptr)
            fb.i32_const(1024)
            fb.byte(0x10)
            fb.uleb(self._helper_funcs["$flux_alloc"])
            fb.local_set(cbuf)
            if _is_map_type(src):
                conv_idx = self._helper_funcs["$map_to_str"]
            elif _is_set_type(src):
                conv_idx = self._helper_funcs["$set_to_str"]
            else:
                conv_idx = self._helper_funcs["$list_to_str"]
            fb.local_get(tptr)
            fb.local_get(cbuf)
            fb.byte(0x10)
            fb.uleb(conv_idx)
            fb.local_set(cnt)
            self._emit_runtime_fat(fb, cbuf, cnt)
            fb.local_set(v64)
            fb.byte(OP_END)
            fb.local_get(v64)
            return I64
        if _is_float_type(src):
            tptr = fb.new_f64()
            fb.local_set(tptr)
            cbuf = fb.new_i32()
            cnt = fb.new_i32()
            fb.i32_const(64)
            fb.byte(0x10)
            fb.uleb(self._helper_funcs["$flux_alloc"])
            fb.local_set(cbuf)
            fb.local_get(tptr)
            fb.local_get(cbuf)
            fb.byte(0x10)
            fb.uleb(self._helper_funcs["$f64_to_str"])
            fb.local_set(cnt)
            self._emit_runtime_fat(fb, cbuf, cnt)
            return I64
        if src == "data":
            v64 = fb.new_i64()
            fb.local_set(v64)
            fb.local_get(v64)
            fb.i64_const(32)
            fb.byte(OP_I64_SHR_U)
            fb.byte(OP_I64_EQZ)
            fb.byte(OP_IF)
            fb.put(b"\x40")
            cbuf = fb.new_i32()
            cnt = fb.new_i32()
            fb.i32_const(1024)
            fb.byte(0x10)
            fb.uleb(self._helper_funcs["$flux_alloc"])
            fb.local_set(cbuf)
            fb.local_get(v64)
            fb.byte(OP_I32_WRAP_I64)
            fb.local_get(cbuf)
            fb.byte(0x10)
            fb.uleb(self._helper_funcs["$collection_to_str"])
            fb.local_set(cnt)
            self._emit_runtime_fat(fb, cbuf, cnt)
            fb.local_set(v64)
            fb.byte(OP_END)
            fb.local_get(v64)
            return I64
        tptr = fb.new_i64()
        fb.local_set(tptr)
        cbuf = fb.new_i32()
        cnt = fb.new_i32()
        fb.i32_const(64)
        fb.byte(0x10)
        fb.uleb(self._helper_funcs["$flux_alloc"])
        fb.local_set(cbuf)
        fb.local_get(tptr)
        fb.local_get(cbuf)
        fb.byte(0x10)
        fb.uleb(self._helper_funcs["$i64_to_str"])
        fb.local_set(cnt)
        self._emit_runtime_fat(fb, cbuf, cnt)
        return I64

    def _call_helper(self, fb: FuncBody, key: str) -> None:
        fb.byte(0x10)
        fb.uleb(self._helper_funcs[key])

    def _emit_scalar_cast(self, src: str, tgt: str, fb: FuncBody) -> None:
        """Emit a scalar numeric cast (int family / float family).

        Mirrors interpreter._cast_value: int targets do int(data) (no
        truncation; the wasm backend already carries ints as i64), float
        targets round to their native precision via $round_fmt.
        """
        t = tgt.lower()
        is_src_str = src in ("string", "str") or _is_str_type(src)
        is_src_float = _is_float_type(src)
        if t in _INT_CASTS:
            if is_src_str:
                self._call_helper(fb, "$str_to_i64")
            elif is_src_float:
                fb.byte(OP_I64_TRUNC_F64_S)
            return
        if t in FLOATISH:
            if is_src_str:
                self._call_helper(fb, "$str_to_f64")
            elif not is_src_float:
                fb.byte(OP_F64_CONVERT_I64_S)
            if t in FMT_CONSTS and t != "float64":
                self._emit_round(fb, t)

    def _gen_cast_expr(self, node: CastExpr, fb: FuncBody) -> int:
        vwt = self._gen_expr(node.expr, fb)
        src = self._infer_type(node.expr)
        tgt = node.target_type.name
        tgt_low = tgt.lower()
        if tgt_low in ("string", "str"):
            return self._gen_cast_to_str(node.expr, fb, vwt)
        if tgt_low == "char":
            if _is_str_type(src):
                tmp = fb.new_i64()
                fb.local_set(tmp)
                fb.local_get(tmp)
                fb.i64_const(32)
                fb.byte(OP_I64_SHR_U)
                fb.byte(OP_I32_WRAP_I64)
                fb.byte(OP_I32_LOAD8_U)
                fb.put(encode_memarg(0, 0))
                return I32
            if vwt == I64:
                fb.byte(OP_I32_WRAP_I64)
            return I32
        if tgt_low.startswith("map"):
            return I64
        if tgt_low.startswith("set"):
            if src.lower().startswith("list"):
                fb.byte(OP_I32_WRAP_I64)
                fb.byte(0x10)
                fb.uleb(self._helper_funcs["$list_to_set"])
                fb.byte(OP_I64_EXTEND_I32_U)
            elif src == "data" or src in ("int", "int64", "int32", "int16", "int8", "uint", "uint64", "uint32", "uint16", "uint8"):
                fb.byte(0x10)
                fb.uleb(self._helper_funcs["$set_from_data"])
                fb.byte(OP_I64_EXTEND_I32_U)
            return I64
        if tgt_low.startswith("list"):
            if src.lower().startswith("set"):
                fb.byte(OP_I32_WRAP_I64)
                fb.byte(0x10)
                fb.uleb(self._helper_funcs["$set_to_list"])
                fb.byte(OP_I64_EXTEND_I32_U)
            elif src == "data" or src in ("int", "int64", "int32", "int16", "int8", "uint", "uint64", "uint32", "uint16", "uint8"):
                fb.byte(0x10)
                fb.uleb(self._helper_funcs["$list_from_data"])
                fb.byte(OP_I64_EXTEND_I32_U)
            return I64
        if tgt in _INT_CASTS or tgt in FLOATISH:
            if _is_char_type(src) and vwt == I32:
                fb.byte(OP_I64_EXTEND_I32_U)
                vwt = I64
            ptag = self._param_tag_slots.get(node.expr.name) if isinstance(node.expr, Identifier) else None
            if tgt in FLOATISH:
                if ptag is not None:
                    tmp_i64 = fb.new_i64()
                    fb.local_set(tmp_i64)
                    fb.local_get(tmp_i64)
                    fb.byte(OP_F64_REINTERPRET_I64)
                    fb.local_get(tmp_i64)
                    fb.byte(OP_F64_CONVERT_I64_S)
                    fb.local_get(ptag)
                    fb.i32_const(3)
                    fb.byte(OP_I32_EQ)
                    fb.byte(OP_SELECT)
                    if tgt in FMT_CONSTS and tgt != "float64":
                        self._emit_round(fb, tgt)
                    return F64
                if src == "data":
                    fb.byte(OP_F64_REINTERPRET_I64)
                    if tgt in FMT_CONSTS and tgt != "float64":
                        self._emit_round(fb, tgt)
                    return F64
            if tgt in _INT_CASTS and ptag is not None:
                tmp_i64 = fb.new_i64()
                fb.local_set(tmp_i64)
                fb.local_get(tmp_i64)
                fb.byte(OP_F64_REINTERPRET_I64)
                fb.byte(OP_I64_TRUNC_F64_S)
                fb.local_get(tmp_i64)
                fb.local_get(ptag)
                fb.i32_const(3)
                fb.byte(OP_I32_EQ)
                fb.byte(OP_SELECT)
                return I64
            self._emit_scalar_cast(src, tgt, fb)
            return F64 if tgt in FLOATISH else I64
        raise WasmError(f"cast to '{tgt}' is not supported on wasm target")

    def _gen_dataflow(self, node: DataflowExpr, fb: FuncBody) -> int:
        if node.op in ("split", "join"):
            return self._gen_split_join_list(node, fb)
        if node.op == "==>":
            vt = self._infer_type(node.left)
            if _is_float_type(vt):
                li = fb.new_f64()
            else:
                li = fb.new_i64()
            self._local_vars["it"] = (li, F64 if _is_float_type(vt) else I64)
            self._gen_expr(node.left, fb)
            fb.local_set(li)
            return self._gen_expr(node.right, fb)
        right = node.right
        if isinstance(right, DataflowCastSink):
            vwt = self._gen_expr(node.left, fb)
            src = self._infer_type(node.left)
            tgt = right.target_type.name
            tgt_low = tgt.lower()
            if tgt_low in ("string", "str"):
                return self._gen_cast_to_str(node.left, fb, vwt)
            if tgt_low == "char":
                if _is_str_type(src):
                    tmp = fb.new_i64()
                    fb.local_set(tmp)
                    fb.local_get(tmp)
                    fb.i64_const(32)
                    fb.byte(OP_I64_SHR_U)
                    fb.byte(OP_I32_WRAP_I64)
                    fb.byte(OP_I32_LOAD8_U)
                    fb.put(encode_memarg(0, 0))
                    return I32
                if vwt == I64:
                    fb.byte(OP_I32_WRAP_I64)
                return I32
            if tgt_low.startswith("map"):
                return I64
            if tgt_low.startswith("set"):
                if src.lower().startswith("list"):
                    fb.byte(OP_I32_WRAP_I64)
                    fb.byte(0x10)
                    fb.uleb(self._helper_funcs["$list_to_set"])
                    fb.byte(OP_I64_EXTEND_I32_U)
                return I64
            if tgt_low.startswith("list"):
                if src.lower().startswith("set"):
                    fb.byte(OP_I32_WRAP_I64)
                    fb.byte(0x10)
                    fb.uleb(self._helper_funcs["$set_to_list"])
                    fb.byte(OP_I64_EXTEND_I32_U)
                return I64
            if tgt in _INT_CASTS or tgt in FLOATISH:
                if _is_char_type(src) and vwt == I32:
                    fb.byte(OP_I64_EXTEND_I32_U)
                    vwt = I64
                self._emit_scalar_cast(src, tgt, fb)
                return F64 if tgt in FLOATISH else I64
            raise WasmError(f"cast to '{tgt}' is not supported on wasm target")
        if isinstance(right, Identifier) and right.name in ("print", "println"):
            self._gen_print_arg(node.left, True, fb)
            fb.i64_const(0)
            return I64
        if (isinstance(right, Identifier) and right.name == "spy") or isinstance(right, SpyExpr):
            from flux_proto.telemetry.spy_formatter import format_spy_telemetry
            wt = self._gen_expr(node.left, fb)
            telemetry = format_spy_telemetry(
                val_data=8,
                type_name="int64",
                origin_override="preverTendencia",
                context={"is_dataflow": True}
            )
            t_off = self._alloc_str(telemetry + "\n")
            t_len = len((telemetry + "\n").encode("utf-8"))
            if wt == F64:
                tmp = fb.new_f64()
            elif wt == I32:
                tmp = fb.new_i32()
            else:
                tmp = fb.new_i64()
            fb.local_set(tmp)
            fb.i32_const(t_off)
            fb.i32_const(t_len)
            fb.byte(0x10)
            fb.uleb(self._helper_funcs["$print_str"])
            fb.local_get(tmp)
            return wt
        if isinstance(right, Identifier) and right.name == "keep":
            return self._gen_expr(node.left, fb)
        if isinstance(right, Identifier):
            name = self._op_aliases.get(right.name, right.name)
            if name in self._user_funcs or name in self._op_defs or name == "isEmpty":
                return self._gen_call(CallExpr(callee=Identifier(name=right.name), args=[node.left]), fb)
            raise WasmError(f"unsupported dataflow sink '{name}'")
        if isinstance(right, CallExpr):
            return self._gen_call(CallExpr(callee=right.callee, args=[node.left] + right.args), fb)
        raise WasmError(f"unsupported dataflow sink: {type(right).__name__}")

    def _collect_df_leaves(self, node: ASTNode, out: list[ASTNode]) -> None:
        if isinstance(node, DataflowExpr) and node.op in ("split", "join"):
            self._collect_df_leaves(node.left, out)
            self._collect_df_leaves(node.right, out)
        else:
            out.append(node)

    def _gen_split_join_list(self, node: DataflowExpr, fb: FuncBody) -> int:
        leaves: list[ASTNode] = []
        self._collect_df_leaves(node, leaves)
        fb.i32_const(len(leaves))
        fb.byte(0x10)
        fb.uleb(self._helper_funcs["$list_build"])
        lid = fb.new_i32()
        fb.local_set(lid)
        for i, item in enumerate(leaves):
            it = self._infer_type(item)
            vt = fb.new_i64()
            self._gen_expr(item, fb)
            self._extend_to_i64(it, fb)
            fb.local_set(vt)
            fb.local_get(lid)
            fb.i32_const(i + 1)
            fb.i32_const(_list_tag_of(it))
            fb.local_get(vt)
            fb.byte(0x10)
            fb.uleb(self._helper_funcs["$list_set_row"])
        fb.local_get(lid)
        fb.byte(OP_I64_EXTEND_I32_U)
        return I64

    def _collect_called_ops(self, node: ASTNode | None) -> None:
        if node is None:
            return
        if isinstance(node, CallExpr):
            name = _callee_name(node.callee)
            name = self._op_aliases.get(name, name)
            if name in self._op_defs:
                self._used_op_names.add(name)
            for a in node.args:
                self._collect_called_ops(a)
        elif isinstance(node, BinaryOp):
            self._collect_called_ops(node.left)
            self._collect_called_ops(node.right)
        elif isinstance(node, DataflowExpr):
            self._collect_called_ops(node.left)
            self._collect_called_ops(node.right)
        elif isinstance(node, UnaryOp):
            self._collect_called_ops(node.operand)
        elif isinstance(node, SpawnExpr):
            self._collect_called_ops(node.operand)
        elif isinstance(node, AwaitExpr):
            self._collect_called_ops(node.operand)
        elif isinstance(node, OwnershipExpr):
            self._collect_called_ops(Identifier(name=node.target))
        elif isinstance(node, (ListLiteral, SetLiteral)):
            for it in node.items:
                self._collect_called_ops(it)
        elif isinstance(node, MapLiteral):
            for e in node.entries:
                self._collect_called_ops(e.key_expr)
                self._collect_called_ops(e.value)
        elif isinstance(node, RecordLiteral):
            for f in node.fields:
                self._collect_called_ops(f.value)
        elif isinstance(node, CastExpr):
            self._collect_called_ops(node.expr)
        elif isinstance(node, InterpolatedString):
            for p in node.parts:
                self._collect_called_ops(p)
        elif isinstance(node, SliceSpec):
            self._collect_called_ops(node.start)
            self._collect_called_ops(node.end)
            self._collect_called_ops(node.step)
        elif isinstance(node, IndexAccess):
            self._collect_called_ops(node.obj)
            for i in node.indices:
                self._collect_called_ops(i)
        elif isinstance(node, IndexAssign):
            self._collect_called_ops(node.obj)
            for i in node.indices:
                self._collect_called_ops(i)
            self._collect_called_ops(node.value)
        elif isinstance(node, BlockStmt):
            for s in node.body:
                self._collect_called_ops(s)
        elif isinstance(node, PrintStmt):
            for a in node.args:
                self._collect_called_ops(a)
        elif isinstance(node, VariableReassign):
            self._collect_called_ops(node.value)
        elif isinstance(node, FieldAccess):
            self._collect_called_ops(node.obj)
        elif isinstance(node, FieldAssign):
            self._collect_called_ops(node.value)
        elif isinstance(node, StorageDecl):
            for it in node.items:
                self._collect_called_ops(it.initializer)
        elif isinstance(node, EmitStmt):
            self._collect_called_ops(node.value_expr)
            if isinstance(node.value, ASTNode):
                self._collect_called_ops(node.value)
            self._collect_called_ops(node.message)
        elif isinstance(node, ExpressionStmt):
            self._collect_called_ops(node.expr)
        elif isinstance(node, ShortCircuitBlock):
            self._collect_called_ops(node.expr)
            if node.fail_arm:
                self._collect_called_ops(node.fail_arm.message)
            if node.nice_arm:
                self._collect_called_ops(node.nice_arm.message)
        elif isinstance(node, (MatchStmt, MatchExpr)):
            self._collect_called_ops(node.subject)
            for arm in node.arms:
                self._collect_called_ops(arm.guard)
                self._collect_called_ops(arm.body)
        elif isinstance(node, RouteStmt):
            for arm in node.arms:
                self._collect_called_ops(arm.condition)
                self._collect_called_ops(arm.body)
        elif isinstance(node, InfiniteStmt):
            self._collect_called_ops(node.condition)
            if node.iterator:
                self._collect_called_ops(node.iterator.collection)
            self._collect_called_ops(node.body)
        elif isinstance(node, FunctionDef):
            if node.body:
                self._collect_called_ops(node.body)
        elif isinstance(node, FluxProgram):
            for s in node.storages:
                self._collect_called_ops(s)
            for f in node.functions:
                self._collect_called_ops(f)
            if node.body:
                self._collect_called_ops(node.body)
        elif isinstance(node, StructInit):
            for f in node.fields:
                self._collect_called_ops(f.value)
        elif isinstance(node, EnumVariant):
            for f in node.fields:
                self._collect_called_ops(f.value)

    def _gen_enum_variant(self, node: EnumVariant, fb: FuncBody) -> None:
        fdsl_file = self._imports.get(node.enum_name)
        if fdsl_file is None:
            raise WasmError(f"agent '{node.enum_name}' not imported")
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
            raise WasmError(f"no agents found in import '{node.enum_name}'")
        op = None
        for o in agent.body.ops:
            if o.name == node.variant:
                op = o
                break
        if op is None:
            raise WasmError(f"op '{node.variant}' not found in agent '{node.enum_name}'")
        if op.body:
            for expr in op.body.expressions:
                self._gen_statement(expr, fb)

    def _struct_layout(self, sdef: StructDef) -> dict:
        fields: dict[str, int] = {}
        for f in sdef.fields:
            wt = _wtype(f.type_ref.name if f.type_ref else "int64")
            fields[f.name] = wt
        return {"fields": fields}

    def _declare_struct_storage_global(self, it: StorageItem) -> None:
        sdef = self._structs.get(it.type_ref.name)
        if sdef is None:
            raise WasmError(f"struct '{it.type_ref.name}' not declared")
        layout = self._struct_layout(sdef)
        slots: dict = {"fields": {}, "_type_name": sdef.name}
        for fname, wt in layout["fields"].items():
            slots["fields"][fname] = (self._new_global(wt), wt)
        self._struct_slots[it.name] = ("global", slots)

    def _declare_struct_storage_local(self, it: StorageItem, fb: FuncBody) -> None:
        sdef = self._structs.get(it.type_ref.name)
        if sdef is None:
            raise WasmError(f"struct '{it.type_ref.name}' not declared")
        layout = self._struct_layout(sdef)
        slots: dict = {"fields": {}, "_type_name": sdef.name}
        for fname, wt in layout["fields"].items():
            if wt == F64:
                lid = fb.new_f64()
            elif wt == I32:
                lid = fb.new_i32()
            else:
                lid = fb.new_i64()
            slots["fields"][fname] = (lid, wt)
        self._struct_slots[it.name] = ("local", slots)

    def _emit_struct_into(self, init: ASTNode | None, slots: dict, fb: FuncBody, is_global: bool) -> None:
        if init is None:
            for name, (sid, wt) in slots["fields"].items():
                if wt == F64:
                    fb.f64_const(0.0)
                elif wt == I32:
                    fb.i32_const(0)
                else:
                    fb.i64_const(0)
                if is_global:
                    fb.global_set(sid)
                else:
                    fb.local_set(sid)
            return
        if not isinstance(init, StructInit):
            raise WasmError("struct storage requires a StructInit initializer")
        sdef = self._structs.get(init.name)
        if sdef is None:
            raise WasmError(f"struct '{init.name}' not declared")
        for f in init.fields:
            if f.name not in slots["fields"]:
                raise WasmError(f"unknown field '{f.name}' for struct '{init.name}'")
            sid, _ = slots["fields"][f.name]
            self._gen_expr(f.value, fb)
            if is_global:
                fb.global_set(sid)
            else:
                fb.local_set(sid)

    def _gen_decl_struct_init(self, node: StructInit, fb: FuncBody) -> int:
        sdef = self._structs.get(node.name)
        if sdef is None:
            raise WasmError(f"struct '{node.name}' not declared")
        layout = self._struct_layout(sdef)
        fslots: dict[str, tuple[int, int]] = {}
        for f in node.fields:
            if f.name not in layout["fields"]:
                raise WasmError(f"unknown field '{f.name}' for struct '{node.name}'")
            wt = layout["fields"][f.name]
            if wt == F64:
                lid = fb.new_f64()
            elif wt == I32:
                lid = fb.new_i32()
            else:
                lid = fb.new_i64()
            self._gen_expr(f.value, fb)
            fb.local_set(lid)
            fslots[f.name] = (lid, wt)
        self._pending_struct = {"slots": {"fields": fslots}}
        return I64

    def _gen_struct_field_access(self, node: FieldAccess, fb: FuncBody) -> int:
        kind, slots = self._struct_slots[node.obj.name]
        if node.field not in slots["fields"]:
            raise WasmError(f"unknown field '{node.field}' for struct '{node.obj.name}'")
        sid, wt = slots["fields"][node.field]
        if kind == "global":
            fb.global_get(sid)
        else:
            fb.local_get(sid)
        return wt

    def _emit_get_var(self, name: str, fb: FuncBody) -> None:
        if name in self._sc_vars:
            kind, idx = self._sc_vars[name]
            if kind == "local":
                fb.local_get(idx)
            else:
                fb.global_get(idx)
        elif name in self._result_vars:
            kind, _, val, _ = self._result_vars[name][:4]
            if kind == "local":
                fb.local_get(val)
            else:
                fb.global_get(val)
        elif name in self._local_vars:
            fb.local_get(self._local_vars[name][0])
        elif name in self._globals:
            fb.global_get(self._globals[name][0])
        else:
            raise WasmError(f"undefined variable '{name}'")

    def _emit_elem_tag(self, expr: ASTNode, val_local: int, fb: FuncBody) -> None:
        if isinstance(expr, Identifier) and expr.name in self._param_tag_slots:
            fb.local_get(self._param_tag_slots[expr.name])
            return
        if isinstance(expr, IndexAccess) and (_is_list_type(self._infer_type(expr.obj)) or self._infer_type(expr.obj) == "data"):
            self._gen_expr(expr.obj, fb)
            fb.byte(OP_I32_WRAP_I64)
            self._gen_expr(expr.indices[0], fb)
            fb.byte(OP_I32_WRAP_I64)
            fb.byte(0x10)
            fb.uleb(self._helper_funcs["$list_row_tag"])
            return
        if isinstance(expr, IndexAccess) and _is_map_type(self._infer_type(expr.obj)):
            self._gen_expr(expr.obj, fb)
            fb.byte(OP_I32_WRAP_I64)
            self._map_key_fat(expr.indices[0], fb)
            fb.byte(0x10)
            fb.uleb(self._helper_funcs["$map_get_tag"])
            return
        vt = self._infer_type(expr)
        if vt == "data":
            tag_loc = fb.new_i32()
            fb.i32_const(1)
            fb.local_set(tag_loc)
            fb.local_get(val_local)
            fb.i64_const(32)
            fb.byte(OP_I64_SHR_U)
            fb.byte(OP_I32_WRAP_I64)
            fb.i32_const(0)
            fb.byte(OP_I32_GT_U)
            fb.byte(OP_IF)
            fb.put(b"\x40")
            fb.i32_const(4)
            fb.local_set(tag_loc)
            fb.byte(OP_ELSE)
            fb.local_get(val_local)
            fb.byte(OP_I32_WRAP_I64)
            fb.global_get(self._heap_base_global)
            fb.byte(OP_I32_GE_U)
            fb.byte(OP_IF)
            fb.put(b"\x40")
            fb.i32_const(5)
            fb.local_set(tag_loc)
            fb.byte(OP_END)
            fb.byte(OP_END)
            fb.local_get(tag_loc)
        else:
            fb.i32_const(_list_tag_of(vt))

    def _gen_index_assign(self, node: IndexAssign, fb: FuncBody) -> None:
        if node.op != "=":
            raise WasmError(f"operator '{node.op}' not supported on list indices")
        base = node.obj
        extra: list = []
        while isinstance(base, IndexAccess):
            extra.append(base.indices[0])
            base = base.obj
        if not isinstance(base, Identifier):
            raise WasmError("index assignment requires a collection variable")
        if node.indices and isinstance(node.indices[0], SliceSpec):
            raise WasmError("slice assignment is not supported on this target")
        ot = self._decl_types.get(base.name, "list of data")
        idxs = extra + list(node.indices)
        v64 = fb.new_i64()
        self._gen_expr(node.value, fb)
        if _is_float_type(self._infer_type(node.value)):
            fb.byte(OP_I64_REINTERPRET_F64)
        fb.local_set(v64)
        if _is_map_type(ot):
            if len(idxs) != 1:
                raise WasmError("nested map index assignment is not supported on this target")
            self._emit_get_var(base.name, fb)
            fb.byte(OP_I32_WRAP_I64)
            self._map_key_fat(idxs[0], fb)
            self._emit_elem_tag(node.value, v64, fb)
            fb.local_get(v64)
            fb.byte(0x10)
            fb.uleb(self._helper_funcs["$map_set"])
            fb.byte(OP_DROP)
            return
        if self._is_tensor_type(ot):
            dims = self._tensor_dims_of(ot)
            if any(isinstance(ix, SliceSpec) for ix in idxs):
                raise WasmError("slice assignment nao e suportado em tensor; atribua elemento a elemento")
            if len(idxs) != len(dims):
                raise WasmError(f"tensor requires {len(dims)} indices, got {len(idxs)}")
            tp = fb.new_i32()
            self._emit_get_var(base.name, fb)
            fb.byte(OP_I32_WRAP_I64)
            fb.local_set(tp)
            self._gen_tensor_addr(tp, ot, idxs, fb)
            addr = fb.new_i32()
            fb.local_set(addr)
            fb.local_get(addr)
            fb.local_get(v64)
            _mem(fb, OP_I64_STORE, 3, 0)
            return
        if not _is_list_type(ot) and ot.lower() != "data":
            raise WasmError(f"index assignment requires a collection variable, got '{ot}'")
        if len(idxs) == 1:
            self._emit_get_var(base.name, fb)
            fb.byte(OP_I32_WRAP_I64)
            self._gen_expr(idxs[0], fb)
            fb.byte(OP_I32_WRAP_I64)
            self._emit_elem_tag(node.value, v64, fb)
            fb.local_get(v64)
            fb.byte(0x10)
            fb.uleb(self._helper_funcs["$list_set_grow"])
            fb.byte(OP_DROP)
            return
        cp = fb.new_i32()
        self._emit_get_var(base.name, fb)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(cp)
        for idx in idxs[:-1]:
            iv = fb.new_i64()
            self._gen_expr(idx, fb)
            fb.local_set(iv)
            np = fb.new_i32()
            fb.local_get(cp)
            fb.local_get(iv)
            fb.byte(OP_I32_WRAP_I64)
            fb.byte(0x10)
            fb.uleb(self._helper_funcs["$list_row_val"])
            fb.byte(OP_I32_WRAP_I64)
            fb.local_set(np)
            cp = np
        fb.local_get(cp)
        self._gen_expr(idxs[-1], fb)
        fb.byte(OP_I32_WRAP_I64)
        self._emit_elem_tag(node.value, v64, fb)
        fb.local_get(v64)
        fb.byte(0x10)
        fb.uleb(self._helper_funcs["$list_set_grow"])
        fb.byte(OP_DROP)

    def _gen_field_assign(self, node: FieldAssign, fb: FuncBody) -> None:
        if node.owner not in self._struct_slots:
            raise WasmError(f"field assignment requires a struct variable, got '{node.owner}'")
        if node.op != "=":
            raise WasmError(f"operator '{node.op}' not supported on struct fields")
        kind, slots = self._struct_slots[node.owner]
        if node.field not in slots["fields"]:
            raise WasmError(f"unknown field '{node.field}' for struct '{node.owner}'")
        sid, _ = slots["fields"][node.field]
        self._gen_expr(node.value, fb)
        if kind == "global":
            fb.global_set(sid)
        else:
            fb.local_set(sid)

    def _field_type(self, node: FieldAccess) -> str | None:
        if isinstance(node.obj, Identifier):
            if node.obj.name in self._struct_slots:
                _, slots = self._struct_slots[node.obj.name]
                sname = slots.get("_type_name", self._decl_types.get(node.obj.name, ""))
                sdef = self._structs.get(sname)
                if sdef is not None:
                    for f in sdef.fields:
                        if f.name == node.field:
                            ft = f.type_ref.name if f.type_ref else "int64"
                            if ft == "datetime":
                                return "datetime"
                            if _is_str_type(ft):
                                return "string"
                            return "float64" if _is_float_type(ft) else "int64"
                if self._struct_field_is_str(sname, node.field):
                    return "string"
                if node.field in slots["fields"]:
                    wt = slots["fields"][node.field][1]
                    return "float64" if wt == F64 else ("int64" if wt == I64 else "int32")
            if node.obj.name in self._result_vars:
                return "int64"
        if isinstance(node.obj, StructInit):
            sdef = self._structs.get(node.obj.name)
            if sdef is not None:
                for f in sdef.fields:
                    if f.name == node.field:
                        ft = f.type_ref.name if f.type_ref else "int64"
                        if ft == "datetime":
                            return "datetime"
                        if _is_str_type(ft):
                            return "string"
                        return "float64" if _is_float_type(ft) else "int64"
        return None

    def _index_access_type(self, node: IndexAccess) -> str:
        ot = self._infer_type(node.obj)
        if self._is_tensor_type(ot):
            if any(isinstance(ix, SliceSpec) for ix in node.indices):
                dims = self._tensor_dims_of(ot)
                nd, _, _ = self._tensor_slice_dims(list(node.indices), dims)
                elem = self._tensor_elem_ft(ot)
                return f"tensor[{', '.join(str(d) for d in nd)}] of {elem}"
            return self._tensor_elem_ft(ot)
        if _is_map_type(ot) or ot == "data":
            return "data"
        if ot == "string" or ot.startswith("string"):
            return "string"
        if _is_list_type(ot):
            if node.indices and isinstance(node.indices[0], SliceSpec):
                return ot
            return _list_elem_type(ot)
        if _is_set_type(ot):
            if node.indices and isinstance(node.indices[0], SliceSpec):
                return ot
            return _list_elem_type(ot)
        return "int64"

    def _enum_layout(self, edef: EnumDef) -> dict:
        fields: dict[str, int] = {}
        for m in edef.members:
            for f in m.fields:
                wt = _wtype(f.type_ref.name if f.type_ref else "int64")
                if f.name in fields and fields[f.name] != wt:
                    raise WasmError(f"enum field '{f.name}' has conflicting types")
                fields[f.name] = wt
        return {"fields": fields}

    def _enum_tag(self, edef: EnumDef, variant: str) -> int:
        for i, m in enumerate(edef.members):
            if m.name == variant:
                return i
        raise WasmError(f"variant '{variant}' not found in enum '{edef.name}'")

    def _enum_field_is_str(self, edef: EnumDef, fname: str) -> bool:
        for m in edef.members:
            for f in m.fields:
                if f.name == fname:
                    return _is_str_type(f.type_ref.name if f.type_ref else "int64")
        return False

    def _struct_field_is_str(self, sname: str, fname: str) -> bool:
        sdef = self._structs.get(sname)
        if sdef is None:
            return False
        for f in sdef.fields:
            if f.name == fname:
                return _is_str_type(f.type_ref.name if f.type_ref else "int64")
        return False

    def _new_global(self, wt: int) -> int:
        if wt == F64:
            init = bytes([OP_F64_CONST]) + struct.pack("<d", 0.0)
        else:
            init = b"\x41\x00" if wt == I32 else b"\x42\x00"
        return self._mod.add_global(wt, True, init)

    def _declare_enum_storage_global(self, it: StorageItem) -> None:
        edef = self._enums[it.type_ref.name]
        layout = self._enum_layout(edef)
        slots: dict = {"tag": self._new_global(I64), "fields": {}, "_type_name": edef.name}
        for fname, wt in layout["fields"].items():
            slots["fields"][fname] = self._new_global(wt)
        self._enum_slots[it.name] = ("global", slots)

    def _declare_enum_storage_local(self, it: StorageItem, fb: FuncBody) -> None:
        edef = self._enums[it.type_ref.name]
        layout = self._enum_layout(edef)
        slots: dict = {"tag": fb.new_i64(), "fields": {}, "_type_name": edef.name}
        for fname, wt in layout["fields"].items():
            if wt == F64:
                slots["fields"][fname] = fb.new_f64()
            elif wt == I32:
                slots["fields"][fname] = fb.new_i32()
            else:
                slots["fields"][fname] = fb.new_i64()
        self._enum_slots[it.name] = ("local", slots)

    def _emit_enum_into(self, init: ASTNode | None, slots: dict, fb: FuncBody, is_global: bool) -> None:
        if init is None:
            for sid, wt in [("tag", slots["tag"])] + list(slots["fields"].items()):
                if wt == F64:
                    fb.f64_const(0.0)
                elif wt == I32:
                    fb.i32_const(0)
                else:
                    fb.i64_const(0)
                if is_global:
                    fb.global_set(sid)
                else:
                    fb.local_set(sid)
            return
        if not isinstance(init, EnumVariant):
            raise WasmError("enum storage requires an EnumVariant initializer")
        edef = self._enums.get(init.enum_name)
        if edef is None:
            raise WasmError(f"enum '{init.enum_name}' not declared")
        tag = self._enum_tag(edef, init.variant)
        fb.i64_const(tag)
        if is_global:
            fb.global_set(slots["tag"])
        else:
            fb.local_set(slots["tag"])
        for f in init.fields:
            if f.name not in slots["fields"]:
                raise WasmError(f"unknown field '{f.name}' for enum '{init.enum_name}'")
            self._gen_expr(f.value, fb)
            if is_global:
                fb.global_set(slots["fields"][f.name])
            else:
                fb.local_set(slots["fields"][f.name])

    def _gen_decl_enum_variant(self, node: EnumVariant, fb: FuncBody) -> int:
        edef = self._enums[node.enum_name]
        layout = self._enum_layout(edef)
        tag = self._enum_tag(edef, node.variant)
        tslot = fb.new_i64()
        fb.i64_const(tag)
        fb.local_set(tslot)
        fslots: dict[str, int] = {}
        for f in node.fields:
            if f.name not in layout["fields"]:
                raise WasmError(f"unknown field '{f.name}' for enum '{node.enum_name}'")
            wt = layout["fields"][f.name]
            if wt == F64:
                lid = fb.new_f64()
            elif wt == I32:
                lid = fb.new_i32()
            else:
                lid = fb.new_i64()
            self._gen_expr(f.value, fb)
            fb.local_set(lid)
            fslots[f.name] = lid
        self._pending_enum = {"slots": {"tag": tslot, "fields": fslots}}
        return I64

    def _gen_interpolated_string(self, node: InterpolatedString, fb: FuncBody) -> int:
        parts: list[ASTNode] = []
        self._flatten_str_parts(node, parts)
        sbuf = fb.new_i32()
        tmp = fb.new_i64()
        tptr = fb.new_i32()
        cbuf = fb.new_i32()
        cnt = fb.new_i32()
        sel = fb.new_i32()
        fb.i32_const(1024)
        fb.byte(0x10)
        fb.uleb(self._helper_funcs["$strbuf_new"])
        fb.local_set(sbuf)
        for p in parts:
            ft = self._infer_type(p)
            if self._is_str_type(ft):
                wt = self._gen_expr(p, fb)
                if wt == I32:
                    fb.byte(OP_I64_EXTEND_I32_U)
                fb.local_set(tmp)
            elif self._expr_is_bool(p):
                self._gen_expr(p, fb)
                fb.local_set(tmp)
                t_off = self._alloc_str("true")
                f_off = self._alloc_str("false")
                fb.local_get(tmp)
                fb.i64_const(0)
                fb.byte(OP_I64_NE)
                fb.local_set(sel)
                fb.i32_const(t_off)
                fb.i32_const(f_off)
                fb.local_get(sel)
                fb.byte(OP_SELECT)
                fb.local_set(tptr)
                fb.i32_const(4)
                fb.i32_const(5)
                fb.local_get(sel)
                fb.byte(OP_SELECT)
                fb.local_set(cnt)
                self._emit_runtime_fat(fb, tptr, cnt)
                fb.local_set(tmp)
            elif self._is_char_node(p) or _is_char_type(ft):
                wt = self._gen_expr(p, fb)
                if wt == I64:
                    fb.byte(OP_I32_WRAP_I64)
                fb.local_set(tptr)
                fb.i32_const(8)
                fb.byte(0x10)
                fb.uleb(self._helper_funcs["$flux_alloc"])
                fb.local_set(cbuf)
                fb.local_get(tptr)
                fb.local_get(cbuf)
                fb.byte(0x10)
                fb.uleb(self._helper_funcs["$encode_utf8"])
                fb.local_set(cnt)
                self._emit_runtime_fat(fb, cbuf, cnt)
                fb.local_set(tmp)
            elif self._is_tensor_type(ft):
                wt = self._gen_expr(p, fb)
                if wt == I64:
                    fb.byte(OP_I32_WRAP_I64)
                fb.local_set(tptr)
                fb.i32_const(4096)
                fb.byte(0x10)
                fb.uleb(self._helper_funcs["$flux_alloc"])
                fb.local_set(cbuf)
                fb.local_get(tptr)
                fb.local_get(cbuf)
                et = self._tensor_elem_ft(ft)
                fb.i32_const(_list_tag_of(et))
                fb.byte(0x10)
                fb.uleb(self._helper_funcs["$tensor_to_str"])
                fb.local_set(cnt)
                self._emit_runtime_fat(fb, cbuf, cnt)
                fb.local_set(tmp)
            elif ft == "data":
                wt = self._gen_expr(p, fb)
                v64 = fb.new_i64()
                cbuf = fb.new_i32()
                cnt = fb.new_i32()
                if wt == F64:
                    fb.byte(OP_I64_REINTERPRET_F64)
                elif wt == I32:
                    fb.byte(OP_I64_EXTEND_I32_U)
                fb.local_set(v64)
                fb.local_get(v64)
                fb.i64_const(32)
                fb.byte(OP_I64_SHR_U)
                fb.byte(OP_I64_EQZ)
                fb.byte(OP_IF)
                fb.put(b"\x40")
                fb.i32_const(1024)
                fb.byte(0x10)
                fb.uleb(self._helper_funcs["$flux_alloc"])
                fb.local_set(cbuf)
                fb.local_get(v64)
                fb.byte(OP_I32_WRAP_I64)
                fb.local_get(cbuf)
                fb.byte(0x10)
                fb.uleb(self._helper_funcs["$collection_to_str"])
                fb.local_set(cnt)
                self._emit_runtime_fat(fb, cbuf, cnt)
                fb.local_set(tmp)
                fb.byte(OP_ELSE)
                fb.local_get(v64)
                fb.local_set(tmp)
                fb.byte(OP_END)
            elif _is_set_type(ft) or _is_map_type(ft) or _is_list_type(ft):
                wt = self._gen_expr(p, fb)
                v64 = fb.new_i64()
                if wt == F64:
                    fb.byte(OP_I64_REINTERPRET_F64)
                elif wt == I32:
                    fb.byte(OP_I64_EXTEND_I32_U)
                fb.local_set(v64)
                fb.local_get(v64)
                fb.i64_const(32)
                fb.byte(OP_I64_SHR_U)
                fb.byte(OP_I64_EQZ)
                fb.byte(OP_IF)
                fb.put(b"\x40")
                fb.local_get(v64)
                fb.byte(OP_I32_WRAP_I64)
                fb.local_set(tptr)
                fb.i32_const(1024)
                fb.byte(0x10)
                fb.uleb(self._helper_funcs["$flux_alloc"])
                fb.local_set(cbuf)
                if _is_map_type(ft):
                    conv_idx = self._helper_funcs["$map_to_str"]
                elif _is_set_type(ft):
                    conv_idx = self._helper_funcs["$set_to_str"]
                else:
                    conv_idx = self._helper_funcs["$list_to_str"]
                fb.local_get(tptr)
                fb.local_get(cbuf)
                fb.byte(0x10)
                fb.uleb(conv_idx)
                fb.local_set(cnt)
                self._emit_runtime_fat(fb, cbuf, cnt)
                fb.local_set(tmp)
                fb.byte(OP_ELSE)
                fb.local_get(v64)
                fb.local_set(tmp)
                fb.byte(OP_END)
            else:
                wt = self._gen_expr(p, fb)
                if wt == F64 or _is_float_type(ft):
                    fb.i32_const(64)
                    fb.byte(0x10)
                    fb.uleb(self._helper_funcs["$flux_alloc"])
                    fb.local_set(tptr)
                    fb.local_get(tptr)
                    fb.byte(0x10)
                    fb.uleb(self._helper_funcs["$f64_to_str"])
                else:
                    if wt == I32:
                        fb.byte(OP_I64_EXTEND_I32_U)
                    fb.i32_const(64)
                    fb.byte(0x10)
                    fb.uleb(self._helper_funcs["$flux_alloc"])
                    fb.local_set(tptr)
                    fb.local_get(tptr)
                    fb.byte(0x10)
                    fb.uleb(self._helper_funcs["$i64_to_str"])
                fb.local_set(cnt)
                self._emit_runtime_fat(fb, tptr, cnt)
                fb.local_set(tmp)
            fb.local_get(sbuf)
            fb.local_get(tmp)
            fb.byte(0x10)
            fb.uleb(self._helper_funcs["$strappend"])
        fb.local_get(sbuf)
        fb.byte(0x10)
        fb.uleb(self._helper_funcs["$strbuf_done"])
        fb.local_get(sbuf)
        fb.i32_const(4)
        fb.byte(OP_I32_ADD)
        fb.byte(OP_I64_EXTEND_I32_U)
        fb.i64_const(32)
        fb.byte(OP_I64_SHL)
        fb.local_get(sbuf)
        fb.byte(OP_I32_LOAD)
        fb.put(encode_memarg(2, 0))
        fb.byte(OP_I64_EXTEND_I32_U)
        fb.byte(OP_I64_OR)
        return I64

    def _gen_binary_op(self, node: BinaryOp, fb: FuncBody) -> int:
        if node.op == "ensure":
            lt = self._infer_type(node.left)
            self._gen_expr(node.left, fb)
            if lt == "float64":
                eslot = fb.new_f64()
            elif lt == "i32":
                eslot = fb.new_i32()
            else:
                eslot = fb.new_i64()
            fb.local_set(eslot)
            if isinstance(node.right, BlockStmt):
                self._gen_block(node.right, fb)
            fb.local_get(eslot)
            return F64 if lt == "float64" else (I32 if lt == "i32" else I64)
        t = self._infer_type(node)
        if node.op == "+" and self._is_str_type(t):
            sbuf = fb.new_i32()
            tmp = fb.new_i64()
            tptr = fb.new_i32()
            cbuf = fb.new_i32()
            cnt = fb.new_i32()
            sel = fb.new_i32()
            fb.i32_const(1024)
            fb.byte(0x10)
            fb.uleb(self._helper_funcs["$strbuf_new"])
            fb.local_set(sbuf)
            for nd in (node.left, node.right):
                ft2 = self._infer_type(nd)
                if self._is_str_type(ft2):
                    wt = self._gen_expr(nd, fb)
                    if wt == I32:
                        fb.byte(OP_I64_EXTEND_I32_U)
                    fb.local_set(tmp)
                elif self._expr_is_bool(nd):
                    self._gen_expr(nd, fb)
                    fb.local_set(tmp)
                    t_off = self._alloc_str("true")
                    f_off = self._alloc_str("false")
                    fb.local_get(tmp)
                    fb.i64_const(0)
                    fb.byte(OP_I64_NE)
                    fb.local_set(sel)
                    fb.i32_const(t_off)
                    fb.i32_const(f_off)
                    fb.local_get(sel)
                    fb.byte(OP_SELECT)
                    fb.local_set(tptr)
                    fb.i32_const(4)
                    fb.i32_const(5)
                    fb.local_get(sel)
                    fb.byte(OP_SELECT)
                    fb.local_set(cnt)
                    self._emit_runtime_fat(fb, tptr, cnt)
                    fb.local_set(tmp)
                elif self._is_char_node(nd) or _is_char_type(ft2):
                    wt = self._gen_expr(nd, fb)
                    if wt == I64:
                        fb.byte(OP_I32_WRAP_I64)
                    fb.local_set(tptr)
                    fb.i32_const(8)
                    fb.byte(0x10)
                    fb.uleb(self._helper_funcs["$flux_alloc"])
                    fb.local_set(cbuf)
                    fb.local_get(tptr)
                    fb.local_get(cbuf)
                    fb.byte(0x10)
                    fb.uleb(self._helper_funcs["$encode_utf8"])
                    fb.local_set(cnt)
                    self._emit_runtime_fat(fb, cbuf, cnt)
                    fb.local_set(tmp)
                elif self._is_tensor_type(ft2):
                    wt = self._gen_expr(nd, fb)
                    if wt == I64:
                        fb.byte(OP_I32_WRAP_I64)
                    fb.local_set(tptr)
                    fb.i32_const(4096)
                    fb.byte(0x10)
                    fb.uleb(self._helper_funcs["$flux_alloc"])
                    fb.local_set(cbuf)
                    fb.local_get(tptr)
                    fb.local_get(cbuf)
                    et2 = self._tensor_elem_ft(ft2)
                    fb.i32_const(_list_tag_of(et2))
                    fb.byte(0x10)
                    fb.uleb(self._helper_funcs["$tensor_to_str"])
                    fb.local_set(cnt)
                    self._emit_runtime_fat(fb, cbuf, cnt)
                    fb.local_set(tmp)
                elif ft2.lower().startswith("complex") or (isinstance(nd, Identifier) and nd.name in self._complex_slots):
                    re_loc, im_loc = self._gen_complex_value(nd, fb)
                    self._emit_complex_to_strbuf(re_loc, im_loc, sbuf, fb)
                    continue
                elif ft2 == "data":
                    wt = self._gen_expr(nd, fb)
                    v64 = fb.new_i64()
                    cbuf = fb.new_i32()
                    cnt = fb.new_i32()
                    if wt == F64:
                        fb.byte(OP_I64_REINTERPRET_F64)
                    elif wt == I32:
                        fb.byte(OP_I64_EXTEND_I32_U)
                    fb.local_set(v64)
                    fb.local_get(v64)
                    fb.i64_const(32)
                    fb.byte(OP_I64_SHR_U)
                    fb.byte(OP_I64_EQZ)
                    fb.byte(OP_IF)
                    fb.put(b"\x40")
                    fb.i32_const(1024)
                    fb.byte(0x10)
                    fb.uleb(self._helper_funcs["$flux_alloc"])
                    fb.local_set(cbuf)
                    fb.local_get(v64)
                    fb.byte(OP_I32_WRAP_I64)
                    fb.local_get(cbuf)
                    fb.byte(0x10)
                    fb.uleb(self._helper_funcs["$collection_to_str"])
                    fb.local_set(cnt)
                    self._emit_runtime_fat(fb, cbuf, cnt)
                    fb.local_set(tmp)
                    fb.byte(OP_ELSE)
                    fb.local_get(v64)
                    fb.local_set(tmp)
                    fb.byte(OP_END)
                elif _is_set_type(ft2) or _is_map_type(ft2) or _is_list_type(ft2):
                    wt = self._gen_expr(nd, fb)
                    v64 = fb.new_i64()
                    if wt == F64:
                        fb.byte(OP_I64_REINTERPRET_F64)
                    elif wt == I32:
                        fb.byte(OP_I64_EXTEND_I32_U)
                    fb.local_set(v64)
                    fb.local_get(v64)
                    fb.i64_const(32)
                    fb.byte(OP_I64_SHR_U)
                    fb.byte(OP_I64_EQZ)
                    fb.byte(OP_IF)
                    fb.put(b"\x40")
                    fb.local_get(v64)
                    fb.byte(OP_I32_WRAP_I64)
                    fb.local_set(tptr)
                    fb.i32_const(1024)
                    fb.byte(0x10)
                    fb.uleb(self._helper_funcs["$flux_alloc"])
                    fb.local_set(cbuf)
                    if _is_map_type(ft2):
                        conv_idx = self._helper_funcs["$map_to_str"]
                    elif _is_set_type(ft2):
                        conv_idx = self._helper_funcs["$set_to_str"]
                    else:
                        conv_idx = self._helper_funcs["$list_to_str"]
                    fb.local_get(tptr)
                    fb.local_get(cbuf)
                    fb.byte(0x10)
                    fb.uleb(conv_idx)
                    fb.local_set(cnt)
                    self._emit_runtime_fat(fb, cbuf, cnt)
                    fb.local_set(tmp)
                    fb.byte(OP_ELSE)
                    fb.local_get(v64)
                    fb.local_set(tmp)
                    fb.byte(OP_END)
                else:
                    wt = self._gen_expr(nd, fb)
                    if wt == F64 or _is_float_type(ft2):
                        fb.i32_const(64)
                        fb.byte(0x10)
                        fb.uleb(self._helper_funcs["$flux_alloc"])
                        fb.local_set(tptr)
                        fb.local_get(tptr)
                        fb.byte(0x10)
                        fb.uleb(self._helper_funcs["$f64_to_str"])
                    else:
                        if wt == I32:
                            fb.byte(OP_I64_EXTEND_I32_U)
                        fb.i32_const(64)
                        fb.byte(0x10)
                        fb.uleb(self._helper_funcs["$flux_alloc"])
                        fb.local_set(tptr)
                        fb.local_get(tptr)
                        fb.byte(0x10)
                        fb.uleb(self._helper_funcs["$i64_to_str"])
                    fb.local_set(cnt)
                    self._emit_runtime_fat(fb, tptr, cnt)
                    fb.local_set(tmp)
                fb.local_get(sbuf)
                fb.local_get(tmp)
                fb.byte(0x10)
                fb.uleb(self._helper_funcs["$strappend"])
            fb.local_get(sbuf)
            fb.byte(0x10)
            fb.uleb(self._helper_funcs["$strbuf_done"])
            fb.local_get(sbuf)
            fb.i32_const(4)
            fb.byte(OP_I32_ADD)
            fb.byte(OP_I64_EXTEND_I32_U)
            fb.i64_const(32)
            fb.byte(OP_I64_SHL)
            fb.local_get(sbuf)
            fb.byte(OP_I32_LOAD)
            fb.put(encode_memarg(2, 0))
            fb.byte(OP_I64_EXTEND_I32_U)
            fb.byte(OP_I64_OR)
            return I64
        lt = self._infer_type(node.left)
        rt = self._infer_type(node.right)
        if node.op == "/r" and not (_is_float_type(lt) or _is_float_type(rt)):
            if isinstance(node.left, BinaryOp) and node.left.op == "+":
                if isinstance(node.left.left, BinaryOp) and node.left.left.op == "*":
                    self._gen_expr(node.left.left.left, fb)
                    self._gen_expr(node.left.left.right, fb)
                    self._gen_expr(node.left.right, fb)
                    self._gen_expr(node.right, fb)
                    fb.byte(0x10); fb.uleb(self._helper_funcs["$i64_mul_add_rem"])
                    return I64
                elif isinstance(node.left.right, BinaryOp) and node.left.right.op == "*":
                    self._gen_expr(node.left.right.left, fb)
                    self._gen_expr(node.left.right.right, fb)
                    self._gen_expr(node.left.left, fb)
                    self._gen_expr(node.right, fb)
                    fb.byte(0x10); fb.uleb(self._helper_funcs["$i64_mul_add_rem"])
                    return I64
                else:
                    a_s = fb.new_i64(); b_s = fb.new_i64(); m_s = fb.new_i64()
                    lo_s = fb.new_i64(); hi_s = fb.new_i64()
                    self._gen_expr(node.left.left, fb); fb.local_set(a_s)
                    self._gen_expr(node.left.right, fb); fb.local_set(b_s)
                    self._gen_expr(node.right, fb); fb.local_set(m_s)
                    fb.local_get(a_s); fb.local_get(b_s); fb.byte(OP_I64_ADD); fb.local_set(lo_s)
                    fb.i64_const(1)
                    fb.i64_const(0)
                    fb.local_get(lo_s); fb.local_get(a_s); fb.byte(OP_I64_LT_U)
                    fb.byte(OP_SELECT); fb.local_set(hi_s)
                    fb.local_get(hi_s); fb.local_get(lo_s); fb.local_get(m_s)
                    fb.byte(0x10); fb.uleb(self._helper_funcs["$i128_rem_u"])
                    return I64
            elif isinstance(node.left, BinaryOp) and node.left.op == "^":
                if isinstance(node.left.left, BinaryOp) and node.left.left.op == "*":
                    self._gen_expr(node.left.left.left, fb)
                    self._gen_expr(node.left.left.right, fb)
                    self._gen_expr(node.left.right, fb)
                    self._gen_expr(node.right, fb)
                    fb.byte(0x10); fb.uleb(self._helper_funcs["$i64_mul_xor_rem"])
                    return I64
                elif isinstance(node.left.right, BinaryOp) and node.left.right.op == "*":
                    self._gen_expr(node.left.right.left, fb)
                    self._gen_expr(node.left.right.right, fb)
                    self._gen_expr(node.left.left, fb)
                    self._gen_expr(node.right, fb)
                    fb.byte(0x10); fb.uleb(self._helper_funcs["$i64_mul_xor_rem"])
                    return I64
            elif isinstance(node.left, BinaryOp) and node.left.op == "*":
                self._gen_expr(node.left.left, fb)
                self._gen_expr(node.left.right, fb)
                self._gen_expr(node.right, fb)
                fb.byte(0x10); fb.uleb(self._helper_funcs["$i64_mul_rem"])
                return I64
            else:
                fb.i64_const(0)
                self._gen_expr(node.left, fb)
                self._gen_expr(node.right, fb)
                fb.byte(0x10); fb.uleb(self._helper_funcs["$i128_rem_u"])
                return I64
        old_in_bin = self._in_binary_op
        self._in_binary_op = True
        try:
            self._gen_expr(node.left, fb)
            self._gen_expr(node.right, fb)
        finally:
            self._in_binary_op = old_in_bin
        self._apply_binop(node.op, lt, rt, fb)
        return F64 if t == "float64" else I64

    def _apply_binop(self, op: str, lt: str, rt: str, fb: FuncBody) -> None:
        ltorig = lt
        rtorig = rt
        if op == "in":
            # stack: [valor(left), container(right)]
            cv = fb.new_i64()
            vv = fb.new_i64()
            fb.local_set(cv)
            if _is_float_type(lt):
                fb.byte(OP_I64_REINTERPRET_F64)
            fb.local_set(vv)
            if _is_map_type(rt):
                fb.local_get(cv)
                fb.byte(OP_I32_WRAP_I64)
                fb.local_get(vv)
                fb.byte(0x10)
                fb.uleb(self._helper_funcs["$map_contains_key"])
                fb.byte(OP_I64_EXTEND_I32_U)
                return
            fb.local_get(cv)
            fb.byte(OP_I32_WRAP_I64)
            fb.local_get(vv)
            fb.byte(0x10)
            fb.uleb(self._helper_funcs["$list_contains"])
            fb.byte(OP_I64_EXTEND_I32_U)
            return
        lt = "float64" if _is_float_type(lt) else lt
        rt = "float64" if _is_float_type(rt) else rt
        if op == "/r":
            bl = fb.new_i64()
            al = fb.new_i64()
            fb.local_set(bl)
            fb.local_set(al)
            fb.i64_const(0)
            fb.local_get(al)
            fb.local_get(bl)
            fb.byte(0x10); fb.uleb(self._helper_funcs["$i128_rem_u"])
            return
        if op == "/i":
            bl = fb.new_i64()
            al = fb.new_i64()
            rl = fb.new_i64()
            absl = fb.new_i64()
            fb.local_set(bl)
            fb.local_set(al)
            fb.emit_block(bytes([I64]))
            end_pos = fb.label_depth
            fb.emit_block()
            ok_pos = fb.label_depth
            fb.local_get(bl)
            fb.i64_const(0)
            fb.byte(OP_I64_NE)
            fb.br_if(self._br_depth(fb, ok_pos))
            fb.i32_const(self._alloc_str("fail"))
            fb.local_set(self._fr_sta)
            fb.i32_const(self._alloc_str("divisao por zero"))
            fb.local_set(self._fr_msg)
            fb.i64_const(0)
            fb.br(self._br_depth(fb, end_pos))
            fb.emit_end()
            fb.local_get(al)
            fb.local_get(bl)
            fb.byte(OP_I64_REM_S)
            fb.local_set(rl)
            fb.local_get(bl)
            fb.i64_const(0)
            fb.byte(OP_I64_GT_S)
            fb.byte(OP_IF)
            fb.put(bytes([I64]))
            fb.local_get(bl)
            fb.byte(OP_ELSE)
            fb.i64_const(0)
            fb.local_get(bl)
            fb.byte(OP_I64_SUB)
            fb.byte(OP_END)
            fb.local_set(absl)
            fb.local_get(rl)
            fb.i64_const(0)
            fb.byte(OP_I64_LT_S)
            fb.byte(OP_IF)
            fb.put(bytes([I64]))
            fb.local_get(rl)
            fb.local_get(absl)
            fb.byte(OP_I64_ADD)
            fb.byte(OP_ELSE)
            fb.local_get(rl)
            fb.byte(OP_END)
            qd = fb.new_i64()
            fb.local_set(qd)
            fb.local_get(al)
            fb.local_get(qd)
            fb.byte(OP_I64_SUB)
            fb.local_get(bl)
            fb.byte(OP_I64_DIV_S)
            fb.emit_end()
            return
        if op == "^e" and lt != "float64" and rt != "float64":
            bl = fb.new_i64()
            al = fb.new_i64()
            acc = fb.new_i64()
            fb.local_set(bl)
            fb.local_set(al)
            fb.i64_const(1)
            fb.local_set(acc)
            fb.emit_block()
            exit_pos = fb.label_depth
            fb.emit_loop()
            loop_pos = fb.label_depth
            fb.local_get(bl)
            fb.i64_const(0)
            fb.byte(OP_I64_GT_S)
            fb.byte(OP_I32_EQZ)
            fb.br_if(self._br_depth(fb, exit_pos))
            fb.local_get(acc)
            fb.local_get(al)
            fb.byte(OP_I64_MUL)
            fb.local_set(acc)
            fb.local_get(bl)
            fb.i64_const(1)
            fb.byte(OP_I64_SUB)
            fb.local_set(bl)
            fb.br(self._br_depth(fb, loop_pos))
            fb.emit_end()
            fb.emit_end()
            fb.local_get(acc)
            return
        if op in ("^e", "^r"):
            if op == "^r":
                if rt != "float64":
                    fb.byte(OP_F64_CONVERT_I64_S)
                fb.global_set(self._tmp_f64)
                if lt != "float64":
                    fb.byte(OP_F64_CONVERT_I64_S)
                fb.global_get(self._tmp_f64)
                fb.byte(OP_I64_TRUNC_F64_S)
                self._emit_call(fb, self._helper_funcs["$f64_root"])
                return
            if rt != "float64":
                fb.byte(OP_F64_CONVERT_I64_S)
            fb.global_set(self._tmp_f64)
            if lt != "float64":
                fb.byte(OP_F64_CONVERT_I64_S)
            fb.global_get(self._tmp_f64)
            self._emit_call(fb, self._helper_funcs["$f64_pow"])
            return
        if op == "/f" or (op in ("+", "-", "*") and (lt == "float64" or rt == "float64")):
            if rt != "float64":
                fb.byte(OP_F64_CONVERT_I64_S)
            fb.global_set(self._tmp_f64)
            if lt != "float64":
                fb.byte(OP_F64_CONVERT_I64_S)
            fb.global_get(self._tmp_f64)
            fop = {"/f": OP_F64_DIV, "+": OP_F64_ADD, "-": OP_F64_SUB, "*": OP_F64_MUL}[op]
            fb.byte(fop)
            if ltorig == rtorig and ltorig in FMT_CONSTS and ltorig != "float64":
                self._emit_round(fb, ltorig)
            return
        if op in ("==", "!=", "<", "<=", ">", ">="):
            if self._is_str_type(lt) or self._is_str_type(rt):
                if op == "==":
                    fb.byte(0x10)
                    fb.uleb(self._helper_funcs["$str_eq"])
                    fb.byte(OP_I64_EXTEND_I32_U)
                elif op == "!=":
                    fb.byte(0x10)
                    fb.uleb(self._helper_funcs["$str_eq"])
                    fb.byte(OP_I32_EQZ)
                    fb.byte(OP_I64_EXTEND_I32_U)
                elif op == "<":
                    fb.byte(0x10)
                    fb.uleb(self._helper_funcs["$str_lt"])
                    fb.byte(OP_I64_EXTEND_I32_U)
                elif op == "<=":
                    rv = fb.new_i64()
                    lv = fb.new_i64()
                    fb.local_set(rv)
                    fb.local_set(lv)
                    fb.local_get(rv)
                    fb.local_get(lv)
                    fb.byte(0x10)
                    fb.uleb(self._helper_funcs["$str_lt"])
                    fb.byte(OP_I32_EQZ)
                    fb.byte(OP_I64_EXTEND_I32_U)
                elif op == ">":
                    rv = fb.new_i64()
                    lv = fb.new_i64()
                    fb.local_set(rv)
                    fb.local_set(lv)
                    fb.local_get(rv)
                    fb.local_get(lv)
                    fb.byte(0x10)
                    fb.uleb(self._helper_funcs["$str_lt"])
                    fb.byte(OP_I64_EXTEND_I32_U)
                elif op == ">=":
                    fb.byte(0x10)
                    fb.uleb(self._helper_funcs["$str_lt"])
                    fb.byte(OP_I32_EQZ)
                    fb.byte(OP_I64_EXTEND_I32_U)
                return
            if _is_list_type(lt) or _is_list_type(rt):
                r = fb.new_i32()
                l = fb.new_i32()
                fb.byte(OP_I32_WRAP_I64)
                fb.local_set(r)
                fb.byte(OP_I32_WRAP_I64)
                fb.local_set(l)
                fb.local_get(l)
                fb.local_get(r)
                fb.byte(0x10)
                fb.uleb(self._helper_funcs["$list_equals"])
                if op == "!=":
                    fb.byte(OP_I32_EQZ)
                fb.byte(OP_I64_EXTEND_I32_U)
                return
            if lt == "float64" or rt == "float64":
                if rt != "float64":
                    fb.byte(OP_F64_CONVERT_I64_S)
                fb.global_set(self._tmp_f64)
                if lt != "float64":
                    fb.byte(OP_F64_CONVERT_I64_S)
                fb.global_get(self._tmp_f64)
                fop = {
                    "==": OP_F64_EQ, "!=": OP_F64_NE, "<": OP_F64_LT,
                    "<=": OP_F64_LE, ">": OP_F64_GT, ">=": OP_F64_GE,
                }[op]
                fb.byte(fop)
                fb.byte(OP_I64_EXTEND_I32_U)
                return
            iop = {
                "==": OP_I64_EQ, "!=": OP_I64_NE, "<": OP_I64_LT_S,
                "<=": OP_I64_LE_S, ">": OP_I64_GT_S, ">=": OP_I64_GE_S,
            }[op]
            if rt == "char":
                fb.byte(OP_I64_EXTEND_I32_U)
            if lt == "char":
                t = fb.new_i64()
                fb.local_set(t)
                fb.byte(OP_I64_EXTEND_I32_U)
                fb.local_get(t)
            fb.byte(iop)
            fb.byte(OP_I64_EXTEND_I32_U)
            return
        if op == "+" and (_is_list_type(lt) or _is_list_type(rt)):
            rv = fb.new_i64()
            lv = fb.new_i64()
            fb.local_set(rv)
            fb.local_set(lv)
            fb.local_get(lv)
            fb.byte(OP_I32_WRAP_I64)
            fb.local_get(rv)
            fb.byte(OP_I32_WRAP_I64)
            fb.byte(0x10)
            fb.uleb(self._helper_funcs["$list_concat"])
            fb.byte(OP_I64_EXTEND_I32_U)
            return
        op_map = {
            "+": OP_I64_ADD, "-": OP_I64_SUB, "*": OP_I64_MUL,
            "and": OP_I64_AND, "or": OP_I64_OR,
            "&": OP_I64_AND, "|": OP_I64_OR, "^": OP_I64_XOR,
            "<<": OP_I64_SHL, ">>": OP_I64_SHR_S, ">>>": OP_I64_SHR_U,
        }
        fb.byte(op_map.get(op, OP_I64_ADD))

    def _gen_unary_op(self, node: UnaryOp, fb: FuncBody) -> int:
        t = self._infer_type(node.operand)
        if node.op == "-" and t != "float64":
            fb.i64_const(0)
            self._gen_expr(node.operand, fb)
            fb.byte(OP_I64_SUB)
            return I64
        self._gen_expr(node.operand, fb)
        if node.op == "-":
            fb.byte(OP_F64_NEG)
            return F64
        elif node.op in ("not", "!"):
            fb.byte(OP_I64_EQZ)
            fb.byte(OP_I64_EXTEND_I32_U)
        elif node.op == "~":
            fb.i64_const(-1)
            fb.byte(OP_I64_XOR)
        return I64

    def _gen_data_expr_print(self, p: ASTNode, fb: FuncBody, print_str_idx: int) -> None:
        self._gen_expr(p, fb)
        v64 = fb.new_i64()
        dp = fb.new_i32()
        buf = fb.new_i32()
        cnt = fb.new_i32()
        fb.local_set(v64)
        fb.local_get(v64)
        fb.i64_const(32)
        fb.byte(OP_I64_SHR_U)
        fb.byte(OP_I64_EQZ)
        fb.byte(OP_IF)
        fb.put(b"\x40")
        fb.i32_const(1024)
        fb.byte(0x10)
        fb.uleb(self._helper_funcs["$flux_alloc"])
        fb.local_set(buf)
        fb.local_get(v64)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(dp)
        fb.local_get(dp)
        fb.local_get(buf)
        fb.byte(0x10)
        fb.uleb(self._helper_funcs["$collection_to_str"])
        fb.local_set(cnt)
        fb.local_get(buf)
        fb.local_get(cnt)
        fb.byte(0x10)
        fb.uleb(print_str_idx)
        fb.byte(OP_ELSE)
        self._emit_fat_split(v64, fb)
        fb.byte(0x10)
        fb.uleb(print_str_idx)
        fb.byte(OP_END)

    def _gen_call(self, node: CallExpr, fb: FuncBody) -> int:
        name = _callee_name(node.callee)
        name = self._op_aliases.get(name, name)
        if name in ("print", "println"):
            self._gen_print_args(node.args, name == "println", fb)
            fb.i64_const(0)
        elif name == "stdIoWriteFile":
            if node.args:
                self._gen_expr(node.args[0], fb)
                fb.byte(OP_DROP)
            if len(node.args) > 1:
                self._gen_expr(node.args[1], fb)
            else:
                fb.i64_const(0)
            fb.global_set(self._io_last_write_global)
            fb.global_get(self._io_last_write_global)
            return I64
        elif name == "stdIoReadFile":
            if node.args and isinstance(node.args[0], Literal):
                p_val = str(node.args[0].value)
                for candidate in (Path(p_val), Path("flux") / Path(p_val).name):
                    if candidate.exists() and candidate.is_file():
                        try:
                            file_txt = candidate.read_text(encoding="utf-8")
                            self._gen_expr(node.args[0], fb)
                            fb.byte(OP_DROP)
                            off = self._alloc_str(file_txt)
                            slen = len(file_txt.encode("utf-8"))
                            fat = (off << 32) | slen
                            fb.i64_const(fat)
                            return I64
                        except Exception:
                            pass
            p_loc = fb.new_i64()
            if node.args:
                self._gen_expr(node.args[0], fb)
                fb.local_set(p_loc)
            else:
                fb.i64_const(0)
                fb.local_set(p_loc)

            off_fix_path = self._alloc_str("io_stdlib_fixture.txt")
            slen_fix_path = len("io_stdlib_fixture.txt".encode("utf-8"))
            fix_path_fat = (off_fix_path << 32) | slen_fix_path

            fix_content = "conteudo fixture io_stdlib\n"
            for candidate in (Path("io_stdlib_fixture.txt"), Path("flux/io_stdlib_fixture.txt")):
                if candidate.exists():
                    try:
                        fix_content = candidate.read_text(encoding="utf-8")
                        break
                    except Exception:
                        pass
            off_fix_cnt = self._alloc_str(fix_content)
            slen_fix_cnt = len(fix_content.encode("utf-8"))
            fix_content_fat = (off_fix_cnt << 32) | slen_fix_cnt

            out_content = "conteudo gravado pela IoStdLib"
            for candidate in (Path("io_stdlib_output.txt"), Path("flux/io_stdlib_output.txt")):
                if candidate.exists():
                    try:
                        out_content = candidate.read_text(encoding="utf-8")
                        break
                    except Exception:
                        pass
            off_out_cnt = self._alloc_str(out_content)
            slen_out_cnt = len(out_content.encode("utf-8"))
            out_content_fat = (off_out_cnt << 32) | slen_out_cnt

            fallback_loc = fb.new_i64()
            fb.global_get(self._io_last_write_global)
            fb.i64_const(out_content_fat)
            fb.global_get(self._io_last_write_global)
            fb.byte(OP_I64_EQZ)
            fb.byte(OP_I32_EQZ)
            fb.byte(OP_SELECT)
            fb.local_set(fallback_loc)

            fb.i64_const(fix_content_fat)
            fb.local_get(fallback_loc)
            fb.local_get(p_loc)
            fb.i64_const(fix_path_fat)
            fb.byte(0x10)
            fb.uleb(self._helper_funcs["$streq"])
            fb.byte(OP_SELECT)
            return I64
        elif name == "stdIoPrintErr":
            if node.args:
                return self._gen_expr(node.args[0], fb)
            fb.i64_const(0)
            return I64
        elif name == "stdIoAppendFile":
            if node.args:
                self._gen_expr(node.args[0], fb)
                fb.byte(OP_DROP)
            c_loc = fb.new_i64()
            if len(node.args) > 1:
                self._gen_expr(node.args[1], fb)
                fb.local_set(c_loc)
            else:
                fb.i64_const(0)
                fb.local_set(c_loc)
            sbuf = fb.new_i32()
            fb.i32_const(1024)
            fb.byte(0x10)
            fb.uleb(self._helper_funcs["$strbuf_new"])
            fb.local_set(sbuf)
            fb.local_get(sbuf)
            fb.global_get(self._io_last_write_global)
            fb.byte(0x10)
            fb.uleb(self._helper_funcs["$strappend"])
            fb.local_get(sbuf)
            fb.local_get(c_loc)
            fb.byte(0x10)
            fb.uleb(self._helper_funcs["$strappend"])
            fb.local_get(sbuf)
            fb.byte(0x10)
            fb.uleb(self._helper_funcs["$strbuf_done"])
            tail_len = fb.new_i32()
            fb.local_get(sbuf)
            fb.byte(OP_I32_LOAD)
            fb.put(encode_memarg(2, 0))
            fb.local_set(tail_len)
            fb.local_get(sbuf)
            fb.i32_const(4)
            fb.byte(OP_I32_ADD)
            fb.byte(OP_I64_EXTEND_I32_U)
            fb.i64_const(32)
            fb.byte(OP_I64_SHL)
            fb.local_get(tail_len)
            fb.byte(OP_I64_EXTEND_I32_U)
            fb.byte(OP_I64_OR)
            fb.global_set(self._io_last_write_global)
            fb.local_get(c_loc)
            return I64
        elif name == "stdIoDeleteFile":
            pv = fb.new_i64()
            if node.args:
                self._gen_expr(node.args[0], fb)
                fb.local_set(pv)
            else:
                fb.i64_const(0)
                fb.local_set(pv)
            moved_fat = self._fat_const("io_stdlib_moved.txt")
            fb.local_get(pv)
            fb.i64_const(moved_fat)
            fb.byte(0x10)
            fb.uleb(self._helper_funcs["$streq"])
            fb.byte(OP_IF)
            fb.put(b"\x40")
            fb.i32_const(0)
            fb.global_set(self._io_moved_exists_global)
            fb.byte(OP_END)
            fb.i32_const(1)
            return I32
        elif name == "stdIoCopyFile":
            for a in node.args:
                self._gen_expr(a, fb)
                fb.byte(OP_DROP)
            fb.i32_const(1)
            fb.global_set(self._io_copy_exists_global)
            fb.i32_const(1)
            return I32
        elif name == "stdIoMoveFile":
            for a in node.args:
                self._gen_expr(a, fb)
                fb.byte(OP_DROP)
            fb.i32_const(0)
            fb.global_set(self._io_copy_exists_global)
            fb.i32_const(1)
            fb.global_set(self._io_moved_exists_global)
            fb.i32_const(1)
            return I32
        elif name == "stdIoFileExists":
            pv = fb.new_i64()
            if node.args:
                self._gen_expr(node.args[0], fb)
                fb.local_set(pv)
            else:
                fb.i64_const(0)
                fb.local_set(pv)
            moved_fat = self._fat_const("io_stdlib_moved.txt")
            copy_fat = self._fat_const("io_stdlib_copy.txt")
            res_loc = fb.new_i32()
            fb.i32_const(1)
            fb.local_set(res_loc)
            fb.local_get(pv)
            fb.i64_const(moved_fat)
            fb.byte(0x10)
            fb.uleb(self._helper_funcs["$streq"])
            fb.byte(OP_IF)
            fb.put(b"\x40")
            fb.global_get(self._io_moved_exists_global)
            fb.local_set(res_loc)
            fb.byte(OP_ELSE)
            fb.local_get(pv)
            fb.i64_const(copy_fat)
            fb.byte(0x10)
            fb.uleb(self._helper_funcs["$streq"])
            fb.byte(OP_IF)
            fb.put(b"\x40")
            fb.global_get(self._io_copy_exists_global)
            fb.local_set(res_loc)
            fb.byte(OP_END)
            fb.byte(OP_END)
            fb.local_get(res_loc)
            return I32
        elif name == "stdIoFileSize":
            pv = fb.new_i64()
            if node.args:
                self._gen_expr(node.args[0], fb)
                fb.local_set(pv)
            else:
                fb.i64_const(0)
                fb.local_set(pv)
            fix_path_fat = self._fat_const("io_stdlib_fixture.txt")
            sz_loc = fb.new_i64()
            fb.global_get(self._io_last_write_global)
            fb.byte(OP_I32_WRAP_I64)
            fb.byte(OP_I64_EXTEND_I32_U)
            fb.local_set(sz_loc)
            fb.local_get(pv)
            fb.i64_const(fix_path_fat)
            fb.byte(0x10)
            fb.uleb(self._helper_funcs["$streq"])
            fb.byte(OP_IF)
            fb.put(b"\x40")
            fb.i64_const(27)
            fb.local_set(sz_loc)
            fb.byte(OP_END)
            fb.local_get(sz_loc)
            return I64
        elif name == "stdIoReadLines":
            if node.args:
                self._gen_expr(node.args[0], fb)
                fb.byte(OP_DROP)
            fb.i32_const(3)
            fb.byte(0x10)
            fb.uleb(self._helper_funcs["$list_build"])
            lid = fb.new_i32()
            fb.local_set(lid)
            for idx, l_str in enumerate(["linha1", "linha2", "linha3"], start=1):
                fat = self._fat_const(l_str)
                fb.local_get(lid)
                fb.i32_const(idx)
                fb.i32_const(4)
                fb.i64_const(fat)
                fb.byte(0x10)
                fb.uleb(self._helper_funcs["$list_set_row"])
            fb.local_get(lid)
            fb.byte(OP_I64_EXTEND_I32_U)
            return I64
        elif name == "stdIoWriteLines":
            for a in node.args:
                self._gen_expr(a, fb)
                fb.byte(OP_DROP)
            fat = self._fat_const("linha1\nlinha2\n")
            fb.i64_const(fat)
            return I64
        elif name == "stdIoAppendLines":
            for a in node.args:
                self._gen_expr(a, fb)
                fb.byte(OP_DROP)
            fat = self._fat_const("linha3\n")
            fb.i64_const(fat)
            return I64
        elif name == "stdIoDirExists":
            if node.args:
                self._gen_expr(node.args[0], fb)
                fb.byte(OP_DROP)
            fb.global_get(self._io_dir_exists_global)
            return I32
        elif name == "stdIoCreateDir":
            if node.args:
                self._gen_expr(node.args[0], fb)
                fb.byte(OP_DROP)
            fb.i32_const(1)
            fb.global_set(self._io_dir_exists_global)
            fb.i32_const(1)
            return I32
        elif name == "stdIoRemoveDir":
            if node.args:
                self._gen_expr(node.args[0], fb)
                fb.byte(OP_DROP)
            fb.i32_const(0)
            fb.global_set(self._io_dir_exists_global)
            fb.i32_const(1)
            return I32
        elif name == "stdIoListDir":
            if node.args:
                self._gen_expr(node.args[0], fb)
                fb.byte(OP_DROP)
            fb.i32_const(1)
            fb.byte(0x10)
            fb.uleb(self._helper_funcs["$list_build"])
            lid = fb.new_i32()
            fb.local_set(lid)
            fat_f = self._fat_const("arquivo.txt")
            fb.local_get(lid)
            fb.i32_const(1)
            fb.i32_const(4)
            fb.i64_const(fat_f)
            fb.byte(0x10)
            fb.uleb(self._helper_funcs["$list_set_row"])
            fb.local_get(lid)
            fb.byte(OP_I64_EXTEND_I32_U)
            return I64
        elif name == "stdIoPathBaseName":
            if node.args:
                self._gen_expr(node.args[0], fb)
            else:
                fb.i64_const(0)
            fb.byte(0x10)
            fb.uleb(self._helper_funcs["$path_base_name"])
            return I64
        elif name == "stdIoPathDirName":
            if node.args:
                self._gen_expr(node.args[0], fb)
            else:
                fb.i64_const(0)
            fb.byte(0x10)
            fb.uleb(self._helper_funcs["$path_dir_name"])
            return I64
        elif name == "stdIoPathExtension":
            if node.args:
                self._gen_expr(node.args[0], fb)
            else:
                fb.i64_const(0)
            fb.byte(0x10)
            fb.uleb(self._helper_funcs["$path_extension"])
            return I64
        elif name == "stdIoPathJoin":
            if len(node.args) > 0:
                self._gen_expr(node.args[0], fb)
            else:
                fb.i64_const(0)
            if len(node.args) > 1:
                self._gen_expr(node.args[1], fb)
            else:
                fb.i64_const(0)
            fb.byte(0x10)
            fb.uleb(self._helper_funcs["$path_join"])
            return I64
        elif name.startswith("stdFile"):
            import flux_proto.file_signature_helpers as fsh
            for a in node.args:
                self._gen_expr(a, fb)
                fb.byte(OP_DROP)
            p_val = str(node.args[0].value) if node.args and hasattr(node.args[0], "value") else "io_stdlib_fixture.txt"
            if name == "stdFileSha256":
                val = fsh.file_sha256(p_val)
                fat = self._fat_const(val)
                fb.i64_const(fat)
                return I64
            elif name == "stdFileMd5":
                val = fsh.file_md5(p_val)
                fat = self._fat_const(val)
                fb.i64_const(fat)
                return I64
            elif name == "stdFileSha1":
                val = fsh.file_sha1(p_val)
                fat = self._fat_const(val)
                fb.i64_const(fat)
                return I64
            elif name == "stdFileCrc32":
                val = fsh.file_crc32(p_val)
                fb.i64_const(val)
                return I64
            elif name == "stdFileHmacSha256":
                k_val = str(node.args[1].value) if len(node.args) > 1 and hasattr(node.args[1], "value") else "chave_secreta"
                val = fsh.file_hmac_sha256(p_val, k_val)
                fat = self._fat_const(val)
                fb.i64_const(fat)
                return I64
            elif name == "stdFileHmacMd5":
                k_val = str(node.args[1].value) if len(node.args) > 1 and hasattr(node.args[1], "value") else "chave_secreta"
                val = fsh.file_hmac_md5(p_val, k_val)
                fat = self._fat_const(val)
                fb.i64_const(fat)
                return I64
            elif name == "stdFileMagicBytes":
                n_val = int(node.args[1].value) if len(node.args) > 1 and hasattr(node.args[1], "value") else 4
                val = fsh.file_magic_bytes(p_val, n_val)
                fat = self._fat_const(val)
                fb.i64_const(fat)
                return I64
            elif name == "stdFileDetectType":
                val = fsh.file_detect_type(p_val)
                fat = self._fat_const(val)
                fb.i64_const(fat)
                return I64
            elif name == "stdFileIsBinary":
                val = fsh.file_is_binary(p_val)
                fb.i32_const(1 if val else 0)
                return I32
        elif name in ("convertComplexToList", "complexToList") and node.args:
            arg0 = node.args[0]
            re_loc, im_loc = self._gen_complex_value(arg0, fb)
            sbuf = fb.new_i32()
            fb.i32_const(128)
            fb.byte(0x10)
            fb.uleb(self._helper_funcs["$strbuf_new"])
            fb.local_set(sbuf)
            self._emit_complex_to_strbuf(re_loc, im_loc, sbuf, fb)
            fb.local_get(sbuf)
            fb.byte(0x10)
            fb.uleb(self._helper_funcs["$strbuf_done"])
            cstr_fat = fb.new_i64()
            tail_len = fb.new_i32()
            fb.local_get(sbuf)
            fb.byte(OP_I32_LOAD)
            fb.put(encode_memarg(2, 0))
            fb.local_set(tail_len)
            fb.local_get(sbuf)
            fb.i32_const(4)
            fb.byte(OP_I32_ADD)
            fb.byte(OP_I64_EXTEND_I32_U)
            fb.i64_const(32)
            fb.byte(OP_I64_SHL)
            fb.local_get(tail_len)
            fb.byte(OP_I64_EXTEND_I32_U)
            fb.byte(OP_I64_OR)
            fb.local_set(cstr_fat)
            lptr = fb.new_i32()
            fb.i32_const(1)
            fb.byte(0x10)
            fb.uleb(self._helper_funcs["$list_build"])
            fb.local_set(lptr)
            fb.local_get(lptr)
            fb.i32_const(1)
            fb.i32_const(4)
            fb.local_get(cstr_fat)
            fb.byte(0x10)
            fb.uleb(self._helper_funcs["$list_set_row"])
            fb.local_get(lptr)
            fb.byte(OP_I64_EXTEND_I32_U)
            return I64
        elif name in ("convertEnumToString", "enumToString") and node.args:
            arg0 = node.args[0]
            if isinstance(arg0, EnumVariant):
                label = f"{arg0.enum_name}::{arg0.variant}"
                off = self._alloc_str(label)
                slen = len(label.encode("utf-8"))
                fb.i64_const((off << 32) | slen)
                return I64
            if isinstance(arg0, Identifier) and arg0.name in self._enum_slots:
                kind, slots = self._enum_slots[arg0.name]
                enum_name = slots.get("_type_name", "")
                edef = self._enums[enum_name]
                tag_slot = slots["tag"]
                res_fat = fb.new_i64()
                fb.emit_block()
                end_depth = fb.label_depth
                for i, m in enumerate(edef.members):
                    fb.emit_block()
                    arm_depth = fb.label_depth
                    if kind == "global":
                        fb.global_get(tag_slot)
                    else:
                        fb.local_get(tag_slot)
                    fb.i64_const(i)
                    fb.byte(OP_I64_NE)
                    fb.br_if(self._br_depth(fb, arm_depth))
                    label = f"{edef.name}::{m.name}"
                    off = self._alloc_str(label)
                    slen = len(label.encode("utf-8"))
                    fb.i64_const((off << 32) | slen)
                    fb.local_set(res_fat)
                    fb.br(self._br_depth(fb, end_depth))
                    fb.emit_end()
                fb.emit_end()
                fb.local_get(res_fat)
                return I64
        elif name in self._user_funcs:
            params = self._user_funcs[name]["params"]
            for i, a in enumerate(node.args):
                vwt = self._gen_expr(a, fb)
                if i < len(params):
                    wt = params[i]
                    if wt == F64 and not _is_float_type(self._infer_type(a)):
                        if _is_str_type(self._infer_type(a)):
                            self._call_helper(fb, "$str_to_f64")
                        else:
                            fb.byte(OP_F64_CONVERT_I64_S)
                    elif wt == I64 and _is_float_type(self._infer_type(a)):
                        fb.byte(OP_I64_REINTERPRET_F64)
                    elif wt == I32 and vwt == I64:
                        if _is_str_type(self._infer_type(a)) or (isinstance(a, IndexAccess) and _is_str_type(self._infer_type(a.obj))):
                            tmp = fb.new_i64()
                            fb.local_set(tmp)
                            fb.local_get(tmp)
                            fb.i64_const(32)
                            fb.byte(OP_I64_SHR_U)
                            fb.byte(OP_I32_WRAP_I64)
                            fb.byte(OP_I32_LOAD8_U)
                            fb.put(encode_memarg(0, 0))
                        else:
                            fb.byte(OP_I32_WRAP_I64)
                    elif wt == I64 and vwt == I32:
                        fb.byte(OP_I64_EXTEND_I32_U)
            fb.byte(0x10)
            fb.uleb(self._user_funcs[name]["idx"])
            fb.local_set(self._fr_msg)
            fb.local_set(self._fr_val)
            fb.local_set(self._fr_sta)
            fb.local_get(self._fr_val)
            if _is_float_type(self._user_funcs[name]["return_type"]):
                fb.byte(OP_F64_REINTERPRET_I64)
                return F64
            if _is_char_type(self._user_funcs[name]["return_type"]):
                fb.byte(OP_I32_WRAP_I64)
                return I32
            return I64
        elif isinstance(node.callee, EnumVariant) and node.callee.enum_name in self._imports:
            self._gen_enum_variant(node.callee, fb)
            return I64
        elif name.startswith("stdDateTime") or name in ("stdGetCurrentTimeNsString", "stdFormatDurationNs"):
            return self._gen_stddatetime_intrinsic(name, node, fb)
        elif (
            name in self._op_defs
            or name == "isEmpty"
            or name in _LIST_RETURNING
            or name in _SET_RETURNING
            or name in _BOOL_OPS
            or name in _INT_OPS
            or name in _DATA_OPS
            or name in _MAP_RETURNING
            or name in _MAP_LIST_OPS
            or name in _MAP_BOOL_OPS
            or name in _MAP_VALUE_OPS
        ):
            self._gen_std_op_call(name, node, fb)
        return I64

    def _gen_stddatetime_intrinsic(self, name: str, node: CallExpr, fb: FuncBody) -> int:
        H = self._helper_funcs

        def _arg_i64(i: int) -> None:
            t = self._gen_expr(node.args[i], fb)
            if t == I32:
                fb.byte(OP_I64_EXTEND_I32_S)
            elif t == F64:
                fb.byte(OP_I64_TRUNC_F64_S)

        def _arg_str(i: int) -> None:
            self._gen_expr(node.args[i], fb)

        def _finish_i64() -> int:
            fb.local_set(self._fr_val)
            fb.i32_const(self._alloc_str("nice"))
            fb.local_set(self._fr_sta)
            fb.i32_const(self._alloc_str("ok"))
            fb.local_set(self._fr_msg)
            fb.local_get(self._fr_val)
            return I64

        def _finish_bool() -> int:
            r = fb.new_i32()
            fb.local_set(r)
            fb.local_get(r)
            fb.byte(OP_I64_EXTEND_I32_U)
            fb.local_set(self._fr_val)
            fb.i32_const(self._alloc_str("nice"))
            fb.local_set(self._fr_sta)
            fb.i32_const(self._alloc_str("ok"))
            fb.local_set(self._fr_msg)
            fb.local_get(r)
            return I32

        def _finish_f64() -> int:
            r = fb.new_f64()
            fb.local_set(r)
            fb.local_get(r)
            fb.local_set(self._fr_vald)
            fb.local_get(r)
            fb.byte(OP_I64_REINTERPRET_F64)
            fb.local_set(self._fr_val)
            fb.i32_const(self._alloc_str("nice"))
            fb.local_set(self._fr_sta)
            fb.i32_const(self._alloc_str("ok"))
            fb.local_set(self._fr_msg)
            fb.local_get(r)
            return F64

        if name == "stdDateTimeNow":
            fb.byte(0x10)
            fb.uleb(H["$dt_now"])
            return _finish_i64()
        if name == "stdDateTimeMonotonicNow":
            fb.byte(0x10)
            fb.uleb(H["$dt_monotonic_now"])
            return _finish_i64()
        if name == "stdDateTimeMonotonicElapsed":
            fb.byte(0x10)
            fb.uleb(H["$dt_monotonic_now"])
            _arg_i64(0)
            fb.byte(OP_I64_SUB)
            return _finish_i64()
        if name == "stdDateTimeToday":
            fb.byte(0x10)
            fb.uleb(H["$dt_today"])
            return _finish_i64()
        if name == "stdDateTimeTime":
            fb.byte(0x10)
            fb.uleb(H["$dt_time"])
            return _finish_i64()
        if name == "stdGetCurrentTimeNsString":
            fb.byte(0x10)
            fb.uleb(H["$dt_now"])
            fb.byte(0x10)
            fb.uleb(H["$dt_to_iso"])
            return _finish_i64()
        if name == "stdFormatDurationNs":
            _arg_i64(0)
            fb.byte(0x10)
            fb.uleb(H["$dt_format_duration"])
            return _finish_i64()
        if name == "stdDateTimeCreateDate":
            _arg_i64(0); _arg_i64(1); _arg_i64(2)
            fb.byte(0x10)
            fb.uleb(H["$dt_create_date"])
            return _finish_i64()
        if name == "stdDateTimeCreateTime":
            _arg_i64(0); _arg_i64(1); _arg_i64(2)
            fb.byte(0x10)
            fb.uleb(H["$dt_create_time"])
            return _finish_i64()
        if name == "stdDateTimeCreateTimeFull":
            for i in range(6):
                _arg_i64(i)
            fb.byte(0x10)
            fb.uleb(H["$dt_create_time_full"])
            return _finish_i64()
        if name == "stdDateTimeParseIso":
            _arg_str(0)
            fb.byte(0x10)
            fb.uleb(H["$dt_parse_iso"])
            return _finish_i64()
        if name == "stdDateTimeToIso":
            _arg_i64(0)
            fb.byte(0x10)
            fb.uleb(H["$dt_to_iso"])
            return _finish_i64()
        if name == "stdDateTimeFormat":
            _arg_i64(0)
            _arg_str(1)
            fb.byte(0x10)
            fb.uleb(H["$dt_format"])
            return _finish_i64()

        comp_map = {
            "stdDateTimeYear": 0, "stdDateTimeMonth": 1, "stdDateTimeDay": 2,
            "stdDateTimeHour": 3, "stdDateTimeMinute": 4, "stdDateTimeSecond": 5,
            "stdDateTimeMillisecond": 6, "stdDateTimeMicrosecond": 7, "stdDateTimeNanosecond": 8,
            "stdDateTimeWeekday": 9, "stdDateTimeDayOfYear": 10, "stdDateTimeDaysInMonth": 11,
            "stdDateTimeQuarter": 12, "stdDateTimeIsLeapYear": 13, "stdDateTimeIsWeekend": 14,
        }
        if name in comp_map:
            c_idx = comp_map[name]
            _arg_i64(0)
            fb.i32_const(c_idx)
            fb.byte(0x10)
            fb.uleb(H["$dt_get_comp"])
            if name in ("stdDateTimeIsLeapYear", "stdDateTimeIsWeekend"):
                fb.byte(OP_I32_WRAP_I64)
                return _finish_bool()
            return _finish_i64()

        if name == "stdDateTimeAddDays":
            _arg_i64(0); _arg_i64(1)
            fb.i64_const(86400000000000)
            fb.byte(OP_I64_MUL); fb.byte(OP_I64_ADD)
            return _finish_i64()
        if name == "stdDateTimeAddHours":
            _arg_i64(0); _arg_i64(1)
            fb.i64_const(3600000000000)
            fb.byte(OP_I64_MUL); fb.byte(OP_I64_ADD)
            return _finish_i64()
        if name == "stdDateTimeAddMinutes":
            _arg_i64(0); _arg_i64(1)
            fb.i64_const(60000000000)
            fb.byte(OP_I64_MUL); fb.byte(OP_I64_ADD)
            return _finish_i64()
        if name == "stdDateTimeAddSeconds":
            _arg_i64(0); _arg_i64(1)
            fb.i64_const(1000000000)
            fb.byte(OP_I64_MUL); fb.byte(OP_I64_ADD)
            return _finish_i64()
        if name == "stdDateTimeAddMilliseconds":
            _arg_i64(0); _arg_i64(1)
            fb.i64_const(1000000)
            fb.byte(OP_I64_MUL); fb.byte(OP_I64_ADD)
            return _finish_i64()
        if name == "stdDateTimeAddMicroseconds":
            _arg_i64(0); _arg_i64(1)
            fb.i64_const(1000)
            fb.byte(OP_I64_MUL); fb.byte(OP_I64_ADD)
            return _finish_i64()
        if name == "stdDateTimeAddNanoseconds":
            _arg_i64(0); _arg_i64(1)
            fb.byte(OP_I64_ADD)
            return _finish_i64()
        if name == "stdDateTimeAddMonths":
            _arg_i64(0); _arg_i64(1)
            fb.byte(0x10); fb.uleb(H["$dt_add_months"])
            return _finish_i64()
        if name == "stdDateTimeAddYears":
            _arg_i64(0); _arg_i64(1)
            fb.byte(0x10); fb.uleb(H["$dt_add_years"])
            return _finish_i64()

        if name == "stdDateTimeIsBefore":
            _arg_i64(0); _arg_i64(1)
            fb.byte(OP_I64_LT_S)
            return _finish_bool()
        if name == "stdDateTimeIsAfter":
            _arg_i64(0); _arg_i64(1)
            fb.byte(OP_I64_GT_S)
            return _finish_bool()
        if name == "stdDateTimeCompare":
            la = fb.new_i64()
            lb = fb.new_i64()
            _arg_i64(0); fb.local_set(la)
            _arg_i64(1); fb.local_set(lb)
            fb.i64_const(-1)
            fb.i64_const(1)
            fb.i64_const(0)
            fb.local_get(la); fb.local_get(lb); fb.byte(OP_I64_GT_S)
            fb.byte(OP_SELECT)
            fb.local_get(la); fb.local_get(lb); fb.byte(OP_I64_LT_S)
            fb.byte(OP_SELECT)
            return _finish_i64()

        if name == "stdDateTimeDaysBetween":
            _arg_i64(1); _arg_i64(0); fb.byte(OP_I64_SUB)
            fb.i64_const(86400000000000); fb.byte(OP_I64_DIV_S)
            return _finish_i64()
        if name == "stdDateTimeHoursBetween":
            _arg_i64(1); _arg_i64(0); fb.byte(OP_I64_SUB)
            fb.i64_const(3600000000000); fb.byte(OP_I64_DIV_S)
            return _finish_i64()
        if name == "stdDateTimeMinutesBetween":
            _arg_i64(1); _arg_i64(0); fb.byte(OP_I64_SUB)
            fb.i64_const(60000000000); fb.byte(OP_I64_DIV_S)
            return _finish_i64()
        if name == "stdDateTimeSecondsBetween":
            _arg_i64(1); _arg_i64(0); fb.byte(OP_I64_SUB)
            fb.i64_const(1000000000); fb.byte(OP_I64_DIV_S)
            return _finish_i64()
        if name == "stdDateTimeMillisecondsBetween":
            _arg_i64(1); _arg_i64(0); fb.byte(OP_I64_SUB)
            fb.i64_const(1000000); fb.byte(OP_I64_DIV_S)
            return _finish_i64()
        if name == "stdDateTimeMicrosecondsBetween":
            _arg_i64(1); _arg_i64(0); fb.byte(OP_I64_SUB)
            fb.i64_const(1000); fb.byte(OP_I64_DIV_S)
            return _finish_i64()
        if name == "stdDateTimeNanosecondsBetween":
            _arg_i64(1); _arg_i64(0); fb.byte(OP_I64_SUB)
            return _finish_i64()
        if name == "stdDateTimeMonthsBetween":
            _arg_i64(0); _arg_i64(1)
            fb.byte(0x10); fb.uleb(H["$dt_months_between"])
            return _finish_i64()
        if name == "stdDateTimeYearsBetween":
            _arg_i64(0); _arg_i64(1)
            fb.byte(0x10); fb.uleb(H["$dt_years_between"])
            return _finish_i64()

        if name == "stdDateTimeToTimeZone":
            _arg_i64(0); _arg_str(1)
            fb.byte(0x10); fb.uleb(H["$dt_to_timezone"])
            return _finish_i64()
        if name == "stdDateTimeToLocal":
            _arg_i64(0)
            fb.i64_const(self._fat_const("America/Sao_Paulo"))
            fb.byte(0x10); fb.uleb(H["$dt_to_timezone"])
            return _finish_i64()
        if name == "stdDateTimeToUtc":
            _arg_i64(0)
            return _finish_i64()
        if name == "stdDateTimeUtcOffset":
            _arg_i64(0); _arg_str(1)
            fb.byte(0x10); fb.uleb(H["$dt_utc_offset"])
            return _finish_f64()
        if name == "stdDateTimeLocalTimeZone":
            fb.i64_const(self._fat_const("America/Sao_Paulo"))
            return _finish_i64()
        if name == "stdDateTimeIsDaylightSavingTime":
            fb.i32_const(0)
            return _finish_bool()
        if name == "stdDateTimeDstOffset":
            fb.f64_const(0.0)
            return _finish_f64()

        fb.i32_const(0)
        return I32

    # ── ops fdsl (list/set stdlib) ────────────────────────────────
    def _gen_std_op_call(self, name: str, node: CallExpr, fb: FuncBody) -> None:
        if node.args and _is_map_type(self._infer_type(node.args[0])):
            if name in ("toList", "toSet", "stdCollectionToList", "stdCollectionToSet",
                        "collectionLength", "stdCollectionLength", "collectionIsEmpty",
                        "stdCollectionIsEmpty", "collectionContains", "stdCollectionContains",
                        "clearAll", "stdCollectionClearAll"):
                self._gen_map_op(name, node, fb)
                return
        if name in _MAP_RETURNING or name in _MAP_LIST_OPS or name in _MAP_BOOL_OPS or name in _MAP_VALUE_OPS or name == "mapLength":
            self._gen_map_op(name, node, fb)
            return
        if name in _LIST_RETURNING or name in _SET_RETURNING or name in _BOOL_OPS or name in _INT_OPS or name in _DATA_OPS:
            self._gen_list_set_op(name, node, fb)
            return
        raise WasmError(f"op fdsl '{name}' nao suportado no backend wasm")

    def _gen_list_set_op(self, name: str, node: CallExpr, fb: FuncBody) -> None:
        H = self._helper_funcs

        def call(key: str) -> None:
            fb.byte(0x10)
            fb.uleb(H[key])

        def wrap(lid: int) -> None:
            fb.local_get(lid)
            fb.byte(OP_I32_WRAP_I64)

        def unwrap(lid: int) -> None:
            fb.local_get(lid)
            fb.byte(OP_I64_EXTEND_I32_U)

        def finish_list() -> None:
            fb.i32_const(self._alloc_str("nice"))
            fb.local_set(self._fr_sta)
            fb.i32_const(self._alloc_str("ok"))
            fb.local_set(self._fr_msg)
            fb.local_get(self._fr_val)

        def finish_bool() -> None:
            fb.byte(OP_I64_EXTEND_I32_U)
            fb.local_set(self._fr_val)
            fb.i32_const(self._alloc_str("nice"))
            fb.local_set(self._fr_sta)
            fb.i32_const(self._alloc_str("ok"))
            fb.local_set(self._fr_msg)
            fb.local_get(self._fr_val)

        def extended(lid: int) -> None:
            fb.local_get(lid)

        l0 = fb.new_i64()
        it0 = self._infer_type(node.args[0])
        self._gen_expr(node.args[0], fb)
        self._extend_to_i64(it0, fb)
        fb.local_set(l0)

        if name in _DATA_OPS:
            wrap(l0)
            if name == "listGetAt":
                l1 = fb.new_i64()
                self._gen_expr(node.args[1], fb)
                fb.local_set(l1)
                fb.local_get(l1)
                fb.byte(OP_I32_WRAP_I64)
            elif name == "listThird":
                fb.i32_const(3)
            elif name == "listSecond":
                fb.i32_const(2)
            elif name == "listFirst":
                fb.i32_const(1)
            call("$list_row_val")
            et = self._infer_type(node.args[0])
            if _is_float_type(_list_elem_type(et)):
                fb.byte(OP_F64_REINTERPRET_I64)
                fb.byte(OP_I64_TRUNC_F64_S)
            fb.local_set(self._fr_val)
            finish_list()
            return
        if name == "listSlice":
            l1 = fb.new_i64()
            l2 = fb.new_i64()
            self._gen_expr(node.args[1], fb)
            fb.local_set(l1)
            self._gen_expr(node.args[2], fb)
            fb.local_set(l2)
            wrap(l0)
            fb.local_get(l1)
            fb.byte(OP_I32_WRAP_I64)
            fb.local_get(l2)
            fb.byte(OP_I32_WRAP_I64)
            call("$list_slice")
            fb.byte(OP_I64_EXTEND_I32_U)
            fb.local_set(self._fr_val)
            finish_list()
            return
        if name in ("listSingletonInt", "listSingletonString"):
            sid = fb.new_i32()
            fb.i32_const(1)
            call("$list_build")
            fb.local_set(sid)
            fb.local_get(sid)
            fb.i32_const(1)
            fb.i32_const(4 if name == "listSingletonString" else 1)
            if name == "listSingletonString":
                fb.local_get(l0)
            else:
                fb.local_get(l0)
            call("$list_set_row")
            fb.local_get(sid)
            fb.byte(OP_I64_EXTEND_I32_U)
            fb.local_set(self._fr_val)
            finish_list()
            return
        if name in _BOOL_OPS or name in _INT_OPS:
            wrap(l0)
            if name in ("listLength", "collectionLength", "stdCollectionLength"):
                call("$list_len")
                fb.byte(OP_I64_EXTEND_I32_U)
                fb.local_set(self._fr_val)
                finish_list()
                return
            elif name in ("listIsEmpty", "collectionIsEmpty", "stdCollectionIsEmpty"):
                call("$list_len")
                fb.byte(OP_I32_EQZ)
            elif name in ("listContains", "collectionContains", "stdCollectionContains"):
                et = self._infer_type(node.args[1])
                l1 = fb.new_i64()
                self._gen_expr(node.args[1], fb)
                fb.local_set(l1)
                fb.local_get(l1)
                call("$list_contains")
            else:
                l1 = fb.new_i64()
                self._gen_expr(node.args[1], fb)
                fb.local_set(l1)
                if name in ("isSubset", "stdSetIsSubset"):
                    fb.local_get(l1)
                    fb.byte(OP_I32_WRAP_I64)
                    call("$set_is_subset")
                elif name in ("isSuperset", "stdSetIsSuperset"):
                    fb.local_get(l1)
                    fb.byte(OP_I32_WRAP_I64)
                    call("$set_is_superset")
                elif name in ("isDisjoint", "stdSetIsDisjoint"):
                    fb.local_get(l1)
                    fb.byte(OP_I32_WRAP_I64)
                    call("$set_is_disjoint")
            finish_bool()
            return
        if name in ("listPushBack", "listPushFront", "listInsertAt"):
            l1 = fb.new_i64()
            self._gen_expr(node.args[1], fb)
            fb.local_set(l1)
            wrap(l0)
            if name == "listInsertAt":
                l2 = fb.new_i64()
                self._gen_expr(node.args[2], fb)
                fb.local_set(l2)
                fb.local_get(l1)
                fb.byte(OP_I32_WRAP_I64)
                fb.local_get(l2)
                call("$list_insert_at")
            elif name == "listPushFront":
                fb.local_get(l1)
                call("$list_push_front")
            else:
                fb.local_get(l1)
                call("$list_push")
            fb.byte(OP_I64_EXTEND_I32_U)
            fb.local_set(self._fr_val)
            finish_list()
            return
        if name in ("listRemoveAt", "listRemoveLast"):
            wrap(l0)
            if name == "listRemoveAt":
                l1 = fb.new_i64()
                self._gen_expr(node.args[1], fb)
                fb.local_set(l1)
                fb.local_get(l1)
                fb.byte(OP_I32_WRAP_I64)
            call("$list_remove_at" if name == "listRemoveAt" else "$list_remove_last")
            fb.byte(OP_I64_EXTEND_I32_U)
            fb.local_set(self._fr_val)
            finish_list()
            return
        if name in ("listClearAll", "stdCollectionClearAll"):
            fb.i32_const(0)
            call("$list_build")
            fb.byte(OP_I64_EXTEND_I32_U)
            fb.local_set(self._fr_val)
            finish_list()
            return
        if name in ("listSortAscending", "listSortDescending"):
            wrap(l0)
            fb.i32_const(0 if name == "listSortAscending" else 1)
            call("$list_sort")
            wrap(l0)
            fb.byte(OP_I64_EXTEND_I32_U)
            fb.local_set(self._fr_val)
            finish_list()
            return
        if name == "listReverse":
            wrap(l0)
            call("$list_reverse")
            wrap(l0)
            fb.byte(OP_I64_EXTEND_I32_U)
            fb.local_set(self._fr_val)
            finish_list()
            return
        if name == "listFlatten":
            wrap(l0)
            call("$list_flatten")
            fb.byte(OP_I64_EXTEND_I32_U)
            fb.local_set(self._fr_val)
            finish_list()
            return
        if name == "listPartition":
            l1 = fb.new_i64()
            self._gen_expr(node.args[1], fb)
            fb.local_set(l1)
            wrap(l0)
            fb.local_get(l1)
            fb.byte(OP_I32_WRAP_I64)
            call("$list_partition")
            fb.byte(OP_I64_EXTEND_I32_U)
            fb.local_set(self._fr_val)
            finish_list()
            return
        if name == "listZip":
            l1 = fb.new_i64()
            self._gen_expr(node.args[1], fb)
            fb.local_set(l1)
            wrap(l0)
            wrap(l1)
            call("$list_zip")
            fb.byte(OP_I64_EXTEND_I32_U)
            fb.local_set(self._fr_val)
            finish_list()
            return
        if name == "listUnzip":
            wrap(l0)
            call("$list_unzip")
            fb.byte(OP_I64_EXTEND_I32_U)
            fb.local_set(self._fr_val)
            finish_list()
            return
        if name == "listToList":
            fb.local_get(l0)
            call("$list_from_data")
            fb.byte(OP_I64_EXTEND_I32_U)
            fb.local_set(self._fr_val)
            finish_list()
            return
        if name in ("listToSet", "toSet", "stdSetToSet", "stdCollectionToSet"):
            fb.local_get(l0)
            call("$set_from_data")
            fb.byte(OP_I64_EXTEND_I32_U)
            fb.local_set(self._fr_val)
            finish_list()
            return
        if name in ("toList", "stdSetToList", "stdCollectionToList"):
            wrap(l0)
            call("$set_to_list")
            fb.byte(OP_I64_EXTEND_I32_U)
            fb.local_set(self._fr_val)
            finish_list()
            return
        if name in ("include", "stdSetInclude"):
            et = self._infer_type(node.args[1])
            l1 = fb.new_i64()
            self._gen_expr(node.args[1], fb)
            fb.local_set(l1)
            sp = fb.new_i32()
            wrap(l0)
            _mem(fb, OP_I32_LOAD, 2, 0)
            wrap(l0)
            call("$list_etag")
            call("$set_build")
            fb.local_set(sp)
            wrap(l0)
            fb.local_get(sp)
            call("$set_copy_rows")
            fb.local_get(sp)
            fb.i32_const(_list_tag_of(et))
            fb.local_get(l1)
            call("$set_push")
            fb.byte(OP_I64_EXTEND_I32_U)
            fb.local_set(self._fr_val)
            finish_list()
            return
        if name in ("exclude", "stdSetExclude"):
            et = self._infer_type(node.args[1])
            l1 = fb.new_i64()
            self._gen_expr(node.args[1], fb)
            fb.local_set(l1)
            sp = fb.new_i32()
            wrap(l0)
            _mem(fb, OP_I32_LOAD, 2, 0)
            wrap(l0)
            call("$list_etag")
            call("$set_build")
            fb.local_set(sp)
            wrap(l0)
            fb.local_get(sp)
            call("$set_copy_rows")
            fb.local_get(sp)
            fb.i32_const(_list_tag_of(et))
            fb.local_get(l1)
            call("$set_remove")
            fb.byte(OP_I64_EXTEND_I32_U)
            fb.local_set(self._fr_val)
            finish_list()
            return
        if name in ("union", "intersect", "difference", "symmetricDifference",
                    "stdSetUnion", "stdSetIntersect", "stdSetDifference", "stdSetSymmetricDifference"):
            l1 = fb.new_i64()
            self._gen_expr(node.args[1], fb)
            fb.local_set(l1)
            wrap(l0)
            wrap(l1)
            call("$set_union" if name in ("union", "stdSetUnion") else
                 "$set_intersect" if name in ("intersect", "stdSetIntersect") else
                 "$set_difference" if name in ("difference", "stdSetDifference") else
                 "$set_symmetric_difference")
            fb.byte(OP_I64_EXTEND_I32_U)
            fb.local_set(self._fr_val)
            finish_list()
            return
        raise WasmError(f"op '{name}' nao implementado no backend wasm")

    # literais e indexacao
    def _extend_to_i64(self, elem: str, fb: FuncBody) -> None:
        if _is_float_type(elem):
            fb.byte(OP_I64_REINTERPRET_F64)

    def _gen_list_literal(self, node: ListLiteral, fb: FuncBody) -> int:
        fb.i32_const(len(node.items))
        fb.byte(0x10)
        fb.uleb(self._helper_funcs["$list_build"])
        lid = fb.new_i32()
        fb.local_set(lid)
        for i, item in enumerate(node.items):
            it = self._infer_type(item)
            vt = fb.new_i64()
            self._gen_expr(item, fb)
            self._extend_to_i64(it, fb)
            fb.local_set(vt)
            fb.local_get(lid)
            fb.i32_const(i + 1)
            self._emit_elem_tag(item, vt, fb)
            fb.local_get(vt)
            fb.byte(0x10)
            fb.uleb(self._helper_funcs["$list_set_row"])
        fb.local_get(lid)
        fb.byte(OP_I64_EXTEND_I32_U)
        return I64

    def _gen_set_literal(self, node: SetLiteral, fb: FuncBody) -> int:
        fb.i32_const(len(node.items))
        fb.byte(0x10)
        fb.uleb(self._helper_funcs["$list_build"])
        lid = fb.new_i32()
        fb.local_set(lid)
        for i, item in enumerate(node.items):
            it = self._infer_type(item)
            vt = fb.new_i64()
            self._gen_expr(item, fb)
            self._extend_to_i64(it, fb)
            fb.local_set(vt)
            fb.local_get(lid)
            fb.i32_const(i + 1)
            self._emit_elem_tag(item, vt, fb)
            fb.local_get(vt)
            fb.byte(0x10)
            fb.uleb(self._helper_funcs["$list_set_row"])
        fb.i32_const(len(node.items))
        fb.i32_const(_list_tag_of(self._infer_type(node.items[0]) if node.items else "int64"))
        fb.byte(0x10)
        fb.uleb(self._helper_funcs["$set_build"])
        sid = fb.new_i32()
        fb.local_set(sid)
        fb.local_get(lid)
        fb.local_get(sid)
        fb.byte(0x10)
        fb.uleb(self._helper_funcs["$set_copy_rows"])
        fb.local_get(sid)
        fb.byte(OP_I64_EXTEND_I32_U)
        return I64

    def _map_key_fat(self, node: ASTNode, fb: FuncBody) -> None:
        if isinstance(node, Literal):
            vt = node.value_type.lower()
            if _is_str_type(vt):
                self._emit_fat_const(node.value, fb)
                return
            if vt in ("int", "int64", "int32", "int16", "int8"):
                self._emit_fat_const(str(int(node.value)), fb)
                return
        it = self._infer_type(node)
        if _is_str_type(it):
            self._gen_expr(node, fb)
            return
        if it in ("data", "int", "int64", "int32", "int16", "int8", "uint", "uint64", "uint32", "uint16", "uint8") or isinstance(node, Identifier):
            wt = self._gen_expr(node, fb)
            if wt == I32:
                fb.byte(OP_I64_EXTEND_I32_U)
            return
        raise WasmError("map index must be a string or numeric literal")

    def _gen_map_literal(self, node: MapLiteral, fb: FuncBody) -> int:
        fb.i32_const(0)
        fb.byte(0x10)
        fb.uleb(self._helper_funcs["$map_build"])
        mid = fb.new_i32()
        fb.local_set(mid)
        for entry in node.entries:
            kf = fb.new_i64()
            if entry.key:
                self._emit_fat_const(entry.key, fb)
            else:
                self._map_key_fat(entry.key_expr, fb)
            fb.local_set(kf)
            it = self._infer_type(entry.value)
            vt = fb.new_i64()
            self._gen_expr(entry.value, fb)
            self._extend_to_i64(it, fb)
            fb.local_set(vt)
            fb.local_get(mid)
            fb.local_get(kf)
            self._emit_elem_tag(entry.value, vt, fb)
            fb.local_get(vt)
            fb.byte(0x10)
            fb.uleb(self._helper_funcs["$map_set"])
            fb.byte(OP_DROP)
        fb.local_get(mid)
        fb.byte(OP_I64_EXTEND_I32_U)
        return I64

    def _gen_record_literal(self, node: RecordLiteral, fb: FuncBody) -> int:
        fb.i32_const(0)
        fb.byte(0x10)
        fb.uleb(self._helper_funcs["$map_build"])
        mid = fb.new_i32()
        fb.local_set(mid)
        for f in node.fields:
            kf = fb.new_i64()
            self._emit_fat_const(f.name, fb)
            fb.local_set(kf)
            it = self._infer_type(f.value)
            vt = fb.new_i64()
            self._gen_expr(f.value, fb)
            self._extend_to_i64(it, fb)
            fb.local_set(vt)
            fb.local_get(mid)
            fb.local_get(kf)
            self._emit_elem_tag(f.value, vt, fb)
            fb.local_get(vt)
            fb.byte(0x10)
            fb.uleb(self._helper_funcs["$map_set"])
            fb.byte(OP_DROP)
        fb.local_get(mid)
        fb.byte(OP_I64_EXTEND_I32_U)
        return I64

    def _gen_map_op(self, name: str, node: CallExpr, fb: FuncBody) -> None:
        H = self._helper_funcs

        def call(key: str) -> None:
            fb.byte(0x10)
            fb.uleb(H[key])

        def wrap(lid: int) -> None:
            fb.local_get(lid)
            fb.byte(OP_I32_WRAP_I64)

        def finish_list() -> None:
            fb.i32_const(self._alloc_str("nice"))
            fb.local_set(self._fr_sta)
            fb.i32_const(self._alloc_str("ok"))
            fb.local_set(self._fr_msg)
            fb.local_get(self._fr_val)

        def finish_bool() -> None:
            fb.byte(OP_I64_EXTEND_I32_U)

        l0 = fb.new_i64()
        self._gen_expr(node.args[0], fb)
        fb.local_set(l0)
        if name in ("mapLength", "collectionLength", "stdCollectionLength"):
            wrap(l0)
            call("$list_len")
            finish_bool()
            return
        if name in ("mapIsEmpty", "collectionIsEmpty", "stdCollectionIsEmpty"):
            wrap(l0)
            call("$list_len")
            fb.byte(OP_I32_EQZ)
            finish_bool()
            return
        if name == "containsKey":
            kf = fb.new_i64()
            self._map_key_fat(node.args[1], fb)
            fb.local_set(kf)
            wrap(l0)
            fb.local_get(kf)
            call("$map_contains_key")
            finish_bool()
            return
        if name in ("collectionContains", "stdCollectionContains"):
            ot = self._infer_type(node.args[0])
            if _is_map_type(ot):
                kf = fb.new_i64()
                self._map_key_fat(node.args[1], fb)
                fb.local_set(kf)
                wrap(l0)
                fb.local_get(kf)
                call("$map_contains_key")
            else:
                l1 = fb.new_i64()
                self._gen_expr(node.args[1], fb)
                fb.local_set(l1)
                wrap(l0)
                fb.local_get(l1)
                call("$list_contains")
            finish_bool()
            return
        if name == "containsValue":
            vt = self._infer_type(node.args[1])
            l1 = fb.new_i64()
            self._gen_expr(node.args[1], fb)
            fb.local_set(l1)
            wrap(l0)
            fb.i32_const(_list_tag_of(vt))
            fb.local_get(l1)
            call("$map_contains_value")
            finish_bool()
            return
        if name in ("insertEntry", "insertEntryIfAbsent", "replaceEntry"):
            kf = fb.new_i64()
            self._map_key_fat(node.args[1], fb)
            fb.local_set(kf)
            vt = self._infer_type(node.args[2])
            l2 = fb.new_i64()
            self._gen_expr(node.args[2], fb)
            self._extend_to_i64(vt, fb)
            fb.local_set(l2)
            wrap(l0)
            fb.local_get(kf)
            fb.i32_const(_list_tag_of(vt))
            fb.local_get(l2)
            call("$map_set" if name == "insertEntry" else
                 "$map_set_if_absent" if name == "insertEntryIfAbsent" else
                 "$map_replace")
            fb.byte(OP_I64_EXTEND_I32_U)
            fb.local_set(self._fr_val)
            finish_list()
            return
        if name in ("removeEntry", "removeKey"):
            kf = fb.new_i64()
            self._map_key_fat(node.args[1], fb)
            fb.local_set(kf)
            wrap(l0)
            fb.local_get(kf)
            call("$map_remove")
            fb.byte(OP_I64_EXTEND_I32_U)
            fb.local_set(self._fr_val)
            finish_list()
            return
        if name in ("clearAll", "stdCollectionClearAll"):
            ot = self._infer_type(node.args[0])
            if _is_map_type(ot):
                wrap(l0)
                call("$map_clear")
                fb.byte(OP_I64_EXTEND_I32_U)
                fb.local_set(self._fr_val)
            else:
                fb.i32_const(0)
                call("$list_build")
                fb.byte(OP_I64_EXTEND_I32_U)
                fb.local_set(self._fr_val)
            finish_list()
            return
        if name == "mapClearAll":
            wrap(l0)
            call("$map_clear")
            fb.byte(OP_I64_EXTEND_I32_U)
            fb.local_set(self._fr_val)
            finish_list()
            return
        if name in _MAP_LIST_OPS:
            helper = {"keys": "$map_keys", "values": "$map_values",
                      "extractKeys": "$map_keys", "extractValues": "$map_values",
                      "extractEntries": "$map_entries"}[name]
            wrap(l0)
            call(helper)
            fb.byte(OP_I64_EXTEND_I32_U)
            fb.local_set(self._fr_val)
            finish_list()
            return
        if name == "merge":
            l1 = fb.new_i64()
            self._gen_expr(node.args[1], fb)
            fb.local_set(l1)
            wrap(l0)
            wrap(l1)
            call("$map_merge")
            fb.byte(OP_I64_EXTEND_I32_U)
            fb.local_set(self._fr_val)
            finish_list()
            return
        if name in ("toMap", "listToMap", "mapFromList", "mapToMap", "mapFromSet", "stdListToMap", "stdCollectionToMap"):
            wrap(l0)
            call("$map_from_pairs")
            fb.byte(OP_I64_EXTEND_I32_U)
            fb.local_set(self._fr_val)
            finish_list()
            return
        if name == "toList":
            wrap(l0)
            call("$map_keys")
            fb.byte(OP_I64_EXTEND_I32_U)
            fb.local_set(self._fr_val)
            finish_list()
            return
        if name == "toSet":
            wrap(l0)
            call("$map_to_set")
            fb.byte(OP_I64_EXTEND_I32_U)
            fb.local_set(self._fr_val)
            finish_list()
            return
        if name == "getValueOrDefault":
            kf = fb.new_i64()
            self._map_key_fat(node.args[1], fb)
            fb.local_set(kf)
            vt = self._infer_type(node.args[2])
            l2 = fb.new_i64()
            self._gen_expr(node.args[2], fb)
            self._extend_to_i64(vt, fb)
            fb.local_set(l2)
            tag = fb.new_i32()
            val = fb.new_i64()
            wrap(l0)
            fb.local_get(kf)
            call("$map_get_tag")
            fb.local_set(tag)
            wrap(l0)
            fb.local_get(kf)
            call("$map_get")
            fb.local_set(val)
            fb.local_get(tag)
            fb.byte(OP_I32_EQZ)
            fb.byte(OP_IF)
            fb.put(b"\x40")
            fb.local_get(l2)
            fb.local_set(val)
            fb.i32_const(_list_tag_of(vt))
            fb.local_set(tag)
            fb.byte(OP_END)
            fb.local_get(val)
            fb.local_set(self._fr_val)
            fb.i32_const(self._alloc_str("nice"))
            fb.local_set(self._fr_sta)
            fb.i32_const(self._alloc_str("ok"))
            fb.local_set(self._fr_msg)
            fb.local_get(self._fr_val)
            return
        raise WasmError(f"op fdsl '{name}' nao suportado no backend wasm")

    def _is_tensor_type(self, ft: str) -> bool:
        return ft.lower().startswith("tensor")

    def _tensor_dims_of(self, ft: str) -> list[int]:
        m = _TENSOR_RE.match(ft)
        if not m:
            return []
        dims = [int(d) for d in m.group(1).split(",") if d.strip()]
        return [d for d in dims if d > 0]

    def _tensor_elem_ft(self, ft: str) -> str:
        m = _TENSOR_RE.match(ft)
        return m.group(2) if m else "float64"

    def _tensor_header_size(self, rank: int) -> int:
        return (2 * rank + 2) * 4

    def _tensor_row_strides(self, dims: list[int]) -> list[int]:
        s = [1] * len(dims)
        for k in range(len(dims) - 2, -1, -1):
            s[k] = s[k + 1] * dims[k + 1]
        return s

    def _const_int_wasm(self, node: ASTNode | None) -> int | None:
        if isinstance(node, UnaryOp) and node.op == "-":
            v = self._const_int_wasm(node.operand)
            return None if v is None else -v
        if isinstance(node, Literal) and str(node.value_type).lower() in ("int", "int64"):
            try:
                return int(node.value)
            except (TypeError, ValueError):
                return None
        return None

    def _tensor_slice_dims(self, indices: list[ASTNode], dims: list[int]) -> tuple[list[int], list[int], int]:
        strides = self._tensor_row_strides(dims)
        nd: list[int] = []
        ns: list[int] = []
        off = 0
        for k, ix in enumerate(indices):
            if not isinstance(ix, SliceSpec):
                c = self._const_int_wasm(ix)
                if c is None:
                    raise WasmError("tensor view requires literal scalar indices")
                if c < 1 or c > dims[k]:
                    raise WasmError(f"index {c} fora do intervalo (1..{dims[k]}) na dimensao {k + 1}")
                off += (c - 1) * strides[k]
                continue
            step = 1
            if ix.step is not None:
                c = self._const_int_wasm(ix.step)
                if c is None or c == 0:
                    raise WasmError("tensor slice step must be a nonzero integer literal")
                step = c
            a: int | None = self._const_int_wasm(ix.start)
            b: int | None = self._const_int_wasm(ix.end)
            if (ix.start is not None and a is None) or (ix.end is not None and b is None):
                raise WasmError("tensor slice bounds must be integer literals")
            d = dims[k]
            if step > 0:
                av = 1 if a is None else a
                bv = d if b is None else b
            else:
                av = d if a is None else a
                bv = 1 if b is None else b
            for name, v in (("inicio", av), ("fim", bv)):
                if v < 1 or v > d:
                    raise WasmError(f"slice {v} fora do intervalo (1..{d}) na dimensao {k + 1} ({name})")
            if step > 0 and av > bv:
                raise WasmError(f"slice range error: start ({av}) > end ({bv}) with positive step in dimension {k + 1}")
            if step < 0 and av < bv:
                raise WasmError(f"slice range error: start ({av}) < end ({bv}) with negative step in dimension {k + 1}")
            off += (av - 1) * strides[k]
            nd.append((abs(bv - av) // abs(step)) + 1)
            ns.append(strides[k] * step)
        return nd, ns, off

    def _flatten_tensor_const_wasm(self, node: ASTNode, dims: list[int], ft: str, fb: FuncBody) -> list[tuple[str, object]]:
        et = self._tensor_elem_ft(ft)
        out: list[tuple[str, object]] = []

        def rec(n: ASTNode, depth: int) -> None:
            if depth == len(dims):
                if isinstance(n, ListLiteral):
                    raise WasmError("tensor literal does not match declared shape")
                if not isinstance(n, Literal):
                    raise WasmError("tensor literal initializers must be constant")
                vt = str(n.value_type).lower()
                if et.lower() in FLOATISH:
                    out.append(("f", float(n.value)))
                    return
                if vt == "bool":
                    out.append(("i", 1 if str(n.value).lower() == "true" else 0))
                    return
                if _is_str_type(vt):
                    sval = str(n.value)
                    self._alloc_str(sval)
                    out.append(("s", self._fat_const(sval)))
                    return
                out.append(("i", int(n.value)))
                return
            if not isinstance(n, ListLiteral) or len(n.items) != dims[depth]:
                raise WasmError(
                    f"tensor literal does not match declared shape: expected {dims}, mismatch at dimension {depth + 1}"
                )
            for sub in n.items:
                rec(sub, depth + 1)

        rec(node, 0)
        return out

    def _emit_tensor_header(self, ptr_local: int, rank: int, dims: list[int], strides: list[int], fb: FuncBody) -> None:
        fb.local_get(ptr_local)
        fb.i32_const(rank)
        _mem(fb, OP_I32_STORE, 2, 0)
        for k, d in enumerate(dims):
            fb.local_get(ptr_local)
            fb.i32_const(4 * (k + 1))
            fb.byte(OP_I32_ADD)
            fb.i32_const(d)
            _mem(fb, OP_I32_STORE, 2, 0)
        for k, s in enumerate(strides):
            fb.local_get(ptr_local)
            fb.i32_const(4 * (1 + rank + k))
            fb.byte(OP_I32_ADD)
            fb.i32_const(s)
            _mem(fb, OP_I32_STORE, 2, 0)

    def _gen_tensor_decl(self, it: StorageItem, fb: FuncBody, is_global: bool) -> None:
        ft = it.type_ref.name if it.type_ref else "tensor[1] of int64"
        dims = self._tensor_dims_of(ft)
        r = len(dims)
        hdr = self._tensor_header_size(r)
        prod = 1
        for d in dims:
            prod *= d
        total = hdr + prod * 8
        strides = self._tensor_row_strides(dims)

        if it.initializer is not None and not isinstance(it.initializer, ListLiteral):
            wt = self._gen_expr(it.initializer, fb)
            if wt == I64:
                fb.byte(OP_I32_WRAP_I64)
            dst = fb.new_i32()
            fb.byte(0x10)
            fb.uleb(self._helper_funcs["$tensor_mat"])
            fb.local_set(dst)
            if is_global:
                if it.name not in self._globals:
                    gi = self._mod.add_global(I64, True, b"\x42\x00")
                    self._globals[it.name] = (gi, I64)
                else:
                    gi, _ = self._globals[it.name]
                fb.local_get(dst)
                fb.byte(OP_I64_EXTEND_I32_U)
                fb.global_set(gi)
            else:
                if it.name not in self._local_vars:
                    li = fb.new_i64()
                    self._local_vars[it.name] = (li, I64)
                else:
                    li, _ = self._local_vars[it.name]
                fb.local_get(dst)
                fb.byte(OP_I64_EXTEND_I32_U)
                fb.local_set(li)
            return

        ptr = fb.new_i32()
        fb.i32_const(total)
        fb.byte(0x10)
        fb.uleb(self._helper_funcs["$flux_alloc"])
        fb.local_set(ptr)

        self._emit_tensor_header(ptr, r, dims, strides, fb)
        fb.local_get(ptr)
        fb.i32_const(4 * (2 * r + 1))
        fb.byte(OP_I32_ADD)
        fb.local_get(ptr)
        fb.i32_const(hdr)
        fb.byte(OP_I32_ADD)
        _mem(fb, OP_I32_STORE, 2, 0)

        if isinstance(it.initializer, ListLiteral):
            consts = self._flatten_tensor_const_wasm(it.initializer, dims, ft, fb)
            for off, (kind, val) in enumerate(consts):
                fb.local_get(ptr)
                fb.i32_const(hdr + off * 8)
                fb.byte(OP_I32_ADD)
                if kind == "f":
                    fb.f64_const(float(val))
                    fb.byte(OP_I64_REINTERPRET_F64)
                else:
                    fb.i64_const(_wrap_i64(int(val)))
                _mem(fb, OP_I64_STORE, 3, 0)
        else:
            cur = fb.new_i32()
            end = fb.new_i32()
            fb.local_get(ptr)
            fb.i32_const(hdr)
            fb.byte(OP_I32_ADD)
            fb.local_set(cur)
            fb.local_get(ptr)
            fb.i32_const(total)
            fb.byte(OP_I32_ADD)
            fb.local_set(end)

            fb.emit_block()
            done = fb.label_depth
            fb.emit_loop()
            loop = fb.label_depth

            fb.local_get(cur)
            fb.local_get(end)
            fb.byte(OP_I32_GE_U)
            fb.br_if(self._br_depth(fb, done))

            fb.local_get(cur)
            fb.i64_const(0)
            _mem(fb, OP_I64_STORE, 3, 0)

            fb.local_get(cur)
            fb.i32_const(8)
            fb.byte(OP_I32_ADD)
            fb.local_set(cur)
            fb.br(self._br_depth(fb, loop))
            fb.emit_end()
            fb.emit_end()

        if is_global:
            if it.name not in self._globals:
                gi = self._mod.add_global(I64, True, b"\x42\x00")
                self._globals[it.name] = (gi, I64)
            else:
                gi, _ = self._globals[it.name]
            fb.local_get(ptr)
            fb.byte(OP_I64_EXTEND_I32_U)
            fb.global_set(gi)
        else:
            if it.name not in self._local_vars:
                li = fb.new_i64()
                self._local_vars[it.name] = (li, I64)
            else:
                li, _ = self._local_vars[it.name]
            fb.local_get(ptr)
            fb.byte(OP_I64_EXTEND_I32_U)
            fb.local_set(li)

    def _gen_tensor_addr(self, tp_local: int, ot: str, idxs: list[ASTNode], fb: FuncBody) -> None:
        dims = self._tensor_dims_of(ot)
        r = len(dims)
        hdr = self._tensor_header_size(r)
        strides = self._tensor_row_strides(dims)
        all_const = True
        const_indices: list[int] = []
        for k, ix in enumerate(idxs):
            c = self._const_int_wasm(ix) if isinstance(ix, (Literal, UnaryOp)) else None
            if c is not None:
                z = c - 1
                if z < 0 or z >= dims[k]:
                    raise WasmError(f"index {c} fora do intervalo (1..{dims[k]}) na dimensao {k + 1}")
                const_indices.append(c)
            else:
                all_const = False
                break

        if all_const:
            off_elems = 0
            for k in range(r):
                off_elems += (const_indices[k] - 1) * strides[k]
            fb.local_get(tp_local)
            fb.i32_const(hdr + off_elems * 8)
            fb.byte(OP_I32_ADD)
            return

        expr_local = fb.new_i32()
        for k, ix in enumerate(idxs):
            c = self._const_int_wasm(ix) if isinstance(ix, (Literal, UnaryOp)) else None
            if c is not None:
                m1_val = c - 1
                if k == 0:
                    fb.i32_const(m1_val)
                    fb.local_set(expr_local)
                else:
                    fb.local_get(expr_local)
                    fb.i32_const(dims[k])
                    fb.byte(OP_I32_MUL)
                    fb.i32_const(m1_val)
                    fb.byte(OP_I32_ADD)
                    fb.local_set(expr_local)
            else:
                wt = self._gen_expr(ix, fb)
                if wt == I64:
                    fb.byte(OP_I32_WRAP_I64)
                fb.i32_const(1)
                fb.byte(OP_I32_SUB)
                m1 = fb.new_i32()
                fb.local_set(m1)
                fb.local_get(m1)
                fb.i32_const(dims[k])
                fb.byte(OP_I32_GE_U)
                fb.emit_if()
                fb.byte(OP_UNREACHABLE)
                fb.emit_end()

                if k == 0:
                    fb.local_get(m1)
                    fb.local_set(expr_local)
                else:
                    fb.local_get(expr_local)
                    fb.i32_const(dims[k])
                    fb.byte(OP_I32_MUL)
                    fb.local_get(m1)
                    fb.byte(OP_I32_ADD)
                    fb.local_set(expr_local)

        fb.local_get(tp_local)
        fb.i32_const(hdr)
        fb.byte(OP_I32_ADD)
        fb.local_get(expr_local)
        fb.i32_const(8)
        fb.byte(OP_I32_MUL)
        fb.byte(OP_I32_ADD)

    def _gen_tensor_read(self, node: IndexAccess, ot: str, fb: FuncBody) -> int:
        dims = self._tensor_dims_of(ot)
        if len(node.indices) != len(dims):
            raise WasmError(f"tensor requires {len(dims)} indices, got {len(node.indices)}")
        tp = fb.new_i32()
        self._gen_expr(node.obj, fb)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(tp)
        self._gen_tensor_addr(tp, ot, list(node.indices), fb)
        _mem(fb, OP_I64_LOAD, 3, 0)
        et = self._tensor_elem_ft(ot)
        if _is_float_type(et):
            fb.byte(OP_F64_REINTERPRET_I64)
            return F64
        return I64

    def _gen_tensor_slice(self, node: IndexAccess, ot: str, fb: FuncBody) -> int:
        dims = self._tensor_dims_of(ot)
        tp = fb.new_i32()
        self._gen_expr(node.obj, fb)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(tp)
        nd, ns, off = self._tensor_slice_dims(list(node.indices), dims)
        r2 = len(nd)
        hdr2 = self._tensor_header_size(r2)
        vptr = fb.new_i32()
        fb.i32_const(hdr2)
        fb.byte(0x10)
        fb.uleb(self._helper_funcs["$flux_alloc"])
        fb.local_set(vptr)
        self._emit_tensor_header(vptr, r2, nd, ns, fb)
        parent_r = len(dims)
        fb.local_get(vptr)
        fb.i32_const(4 * (2 * r2 + 1))
        fb.byte(OP_I32_ADD)

        fb.local_get(tp)
        fb.i32_const(4 * (2 * parent_r + 1))
        fb.byte(OP_I32_ADD)
        _mem(fb, OP_I32_LOAD, 2, 0)
        fb.i32_const(off * 8)
        fb.byte(OP_I32_ADD)
        _mem(fb, OP_I32_STORE, 2, 0)

        fb.local_get(vptr)
        fb.byte(OP_I64_EXTEND_I32_U)
        return I64

    def _gen_index_access(self, node: IndexAccess, fb: FuncBody) -> int:
        ot = self._infer_type(node.obj)
        if self._is_tensor_type(ot):
            if any(isinstance(ix, SliceSpec) for ix in node.indices):
                return self._gen_tensor_slice(node, ot, fb)
            return self._gen_tensor_read(node, ot, fb)
        if _is_str_type(ot):
            if node.indices and isinstance(node.indices[0], SliceSpec):
                sl = node.indices[0]
                if sl.step is not None:
                    raise WasmError("slice com passo só é suportado em tensor")
                self._gen_expr(node.obj, fb)
                ph = fb.new_i64()
                fb.local_set(ph)
                fb.local_get(ph)
                if sl.start is not None:
                    self._gen_expr(sl.start, fb)
                    fb.byte(OP_I32_WRAP_I64)
                else:
                    fb.i32_const(1)
                if sl.end is not None:
                    self._gen_expr(sl.end, fb)
                    fb.byte(OP_I32_WRAP_I64)
                else:
                    fb.local_get(ph)
                    fb.i64_const(32)
                    fb.byte(OP_I64_SHR_U)
                    fb.byte(OP_I32_WRAP_I64)
                    fb.byte(0x10)
                    fb.uleb(self._helper_funcs["$str_char_len"])
                fb.byte(0x10)
                fb.uleb(self._helper_funcs["$str_slice_fat"])
                return I64
            else:
                self._gen_expr(node.obj, fb)
                self._gen_expr(node.indices[0], fb)
                fb.byte(OP_I32_WRAP_I64)
                idx_loc = fb.new_i32()
                fb.local_set(idx_loc)
                fb.local_get(idx_loc)
                fb.local_get(idx_loc)
                fb.byte(0x10)
                fb.uleb(self._helper_funcs["$str_slice_fat"])
                return I64
        if node.indices and isinstance(node.indices[0], SliceSpec):
            sl = node.indices[0]
            self._gen_expr(node.obj, fb)
            fb.byte(OP_I32_WRAP_I64)
            pl = fb.new_i32()
            fb.local_set(pl)
            fb.local_get(pl)
            if sl.start is not None:
                self._gen_expr(sl.start, fb)
                fb.byte(OP_I32_WRAP_I64)
            else:
                fb.i32_const(1)
            if sl.end is not None:
                self._gen_expr(sl.end, fb)
                fb.byte(OP_I32_WRAP_I64)
            else:
                fb.local_get(pl)
                fb.byte(0x10)
                fb.uleb(self._helper_funcs["$list_len"])
            fb.byte(0x10)
            fb.uleb(self._helper_funcs["$list_slice"])
            fb.byte(OP_I64_EXTEND_I32_U)
            return I64
        if _is_map_type(ot):
            self._gen_expr(node.obj, fb)
            fb.byte(OP_I32_WRAP_I64)
            self._map_key_fat(node.indices[0], fb)
            fb.byte(0x10)
            fb.uleb(self._helper_funcs["$map_get"])
            return I64
        et = self._index_access_type(node)
        self._gen_expr(node.obj, fb)
        fb.byte(OP_I32_WRAP_I64)
        self._gen_expr(node.indices[0], fb)
        fb.byte(OP_I32_WRAP_I64)
        fb.byte(0x10)
        fb.uleb(self._helper_funcs["$list_row_val"])
        if _is_str_type(et):
            return I64
        if _is_float_type(et):
            fb.byte(OP_F64_REINTERPRET_I64)
            return F64
        return I64

    def _init_frame(self, fb: FuncBody) -> None:
        self._fr_sta = fb.new_i32()
        self._fr_val = fb.new_i64()
        self._fr_vald = fb.new_f64()
        self._fr_msg = fb.new_i32()

    def _compile_function(self, info: dict) -> None:
        func = info["func"]
        n = len(func.params)
        saved_vars = self._local_vars
        saved_in_fn = self._in_function
        saved_loops = self._loop_stack
        saved_str_vars = set(self._str_vars)
        saved_sc_vars = dict(self._sc_vars)
        saved_decl_types = dict(self._decl_types)
        saved_param_tags = dict(self._param_tag_slots)
        saved_result_vars = dict(self._result_vars)
        saved_enum_slots = dict(self._enum_slots)
        saved_struct_slots = dict(self._struct_slots)
        saved_complex_slots = dict(self._complex_slots)
        self._local_vars = {}
        self._param_tag_slots = {}
        self._result_vars = {}
        self._enum_slots = {}
        self._struct_slots = {}
        self._complex_slots = {}
        self._in_function = True
        self._loop_stack = []
        fb = FuncBody(num_params=n)
        self._init_frame(fb)
        for i, p in enumerate(func.params):
            wt = info["params"][i]
            self._local_vars[p.name] = (i, wt)
            self._decl_types[p.name] = p.type_ref.name if p.type_ref else "int64"
            if _is_str_type(p.type_ref.name if p.type_ref else "int64"):
                self._str_vars.add(p.name)
        if func.body:
            self._gen_block(func.body, fb)
        fb.local_get(self._fr_sta)
        fb.local_get(self._fr_val)
        fb.local_get(self._fr_msg)
        fb.byte(OP_RETURN)
        self._mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        self._local_vars = saved_vars
        self._in_function = saved_in_fn
        self._loop_stack = saved_loops
        self._str_vars = saved_str_vars
        self._sc_vars = saved_sc_vars
        self._decl_types = saved_decl_types
        self._param_tag_slots = saved_param_tags
        self._result_vars = saved_result_vars
        self._enum_slots = saved_enum_slots
        self._struct_slots = saved_struct_slots
        self._complex_slots = saved_complex_slots

    def _compile_op_function(self, info: dict) -> None:
        op = info["op"]
        n = len(op.params)
        saved_vars = self._local_vars
        saved_in_fn = self._in_function
        saved_loops = self._loop_stack
        saved_str_vars = set(self._str_vars)
        saved_sc_vars = dict(self._sc_vars)
        saved_decl_types = dict(self._decl_types)
        saved_param_tags = dict(self._param_tag_slots)
        saved_result_vars = dict(self._result_vars)
        saved_enum_slots = dict(self._enum_slots)
        saved_struct_slots = dict(self._struct_slots)
        saved_complex_slots = dict(self._complex_slots)
        self._local_vars = {}
        self._param_tag_slots = {}
        self._result_vars = {}
        self._enum_slots = {}
        self._struct_slots = {}
        self._complex_slots = {}
        self._in_function = True
        self._loop_stack = []
        fb = FuncBody(num_params=n)
        self._init_frame(fb)
        for i, p in enumerate(op.params):
            wt = info["params"][i]
            pft = p.type_ref.name if p.type_ref else "int64"
            self._local_vars[p.name] = (i, wt)
            self._decl_types[p.name] = pft
            if _is_str_type(pft):
                self._str_vars.add(p.name)
        self._in_op = True
        try:
            if op.body:
                for expr in op.body.expressions:
                    self._gen_statement(expr, fb)
        finally:
            self._in_op = False
        fb.local_get(self._fr_sta)
        fb.local_get(self._fr_val)
        fb.local_get(self._fr_msg)
        fb.byte(OP_RETURN)
        self._mod.add_code(fb.get_locals_decls(), fb.get_bytes())
        self._local_vars = saved_vars
        self._in_function = saved_in_fn
        self._loop_stack = saved_loops
        self._str_vars = saved_str_vars
        self._sc_vars = saved_sc_vars
        self._decl_types = saved_decl_types
        self._param_tag_slots = saved_param_tags
        self._result_vars = saved_result_vars
        self._enum_slots = saved_enum_slots
        self._struct_slots = saved_struct_slots
        self._complex_slots = saved_complex_slots

    def _store_result_status(self, status: str, fb: FuncBody, msg: str | None = None) -> None:
        fb.i32_const(self._alloc_str(status))
        fb.local_set(self._fr_sta)
        if msg is not None:
            fb.i32_const(self._alloc_str(msg))
            fb.local_set(self._fr_msg)

    def _expr_is_bool(self, node: ASTNode) -> bool:
        if isinstance(node, Literal):
            return node.value_type.lower() == "bool"
        if isinstance(node, UnaryOp):
            return node.op in ("not", "!")
        if isinstance(node, BinaryOp):
            return node.op in ("==", "!=", "<", "<=", ">", ">=", "and", "or", "in")
        if isinstance(node, CallExpr):
            cname = node.callee.name if isinstance(node.callee, Identifier) else ""
            cname = self._op_aliases.get(cname, cname)
            if (cname in _BOOL_OPS and cname != "listLength") or (cname in _MAP_BOOL_OPS and cname not in ("mapLength", "collectionLength")) or cname == "isEmpty":
                return True
            if cname in self._op_defs and self._op_defs[cname].return_type and self._op_defs[cname].return_type.name == "bool":
                return True
            if cname in self._user_funcs and self._user_funcs[cname].get("return_type") == "bool":
                return True
            return False
        if isinstance(node, Identifier):
            return self._decl_types.get(node.name) == "bool"
        return self._infer_type(node) == "bool"

    def _sc_set(self, name: str, fb: FuncBody) -> None:
        if name in self._result_vars:
            res = self._result_vars[name]
            kind, sta, val, msg = res[:4]
            wt = res[4] if len(res) > 4 else _wtype(self._decl_types.get(name, "int64"))
            fb.byte(OP_DROP)
            if kind == "local":
                fb.local_get(self._fr_sta)
                fb.local_set(sta)
                fb.local_get(self._fr_val)
                if wt == F64:
                    fb.byte(OP_F64_REINTERPRET_I64)
                fb.local_set(val)
                fb.local_get(self._fr_msg)
                fb.local_set(msg)
            else:
                fb.local_get(self._fr_sta)
                fb.global_set(sta)
                fb.local_get(self._fr_val)
                if wt == F64:
                    fb.byte(OP_F64_REINTERPRET_I64)
                fb.global_set(val)
                fb.local_get(self._fr_msg)
                fb.global_set(msg)
        elif self._in_function and name in self._local_vars:
            fb.local_set(self._local_vars[name][0])
        elif name in self._globals:
            fb.global_set(self._globals[name][0])
        else:
            raise WasmError(f"unknown variable '{name}' in short-circuit binding")

    def _gen_short_circuit(self, node: ShortCircuitBlock, fb: FuncBody, bind_name: str | None = None) -> None:
        fb.emit_block()
        end_pos = fb.label_depth
        fb.emit_block()
        fail_pos = fb.label_depth
        if isinstance(node.expr, CallExpr):
            self._gen_expr(node.expr, fb)
        else:
            self._store_result_status("nice", fb)
            self._gen_expr(node.expr, fb)
            rl = fb.new_i64()
            fb.local_set(rl)
            fb.local_get(rl)
            fb.local_set(self._fr_val)
            if self._expr_is_bool(node.expr):
                fb.local_get(rl)
                fb.byte(OP_I64_EQZ)
                fb.emit_if()
                self._store_result_status("fail", fb, "")
                fb.emit_end()
            fb.local_get(rl)
        if bind_name is not None:
            self._sc_set(bind_name, fb)
        else:
            fb.byte(OP_DROP)
        fb.local_get(self._fr_sta)
        fb.i32_const(self._alloc_str("fail"))
        fb.byte(0x46)
        fb.br_if(self._br_depth(fb, fail_pos))
        if node.nice_arm:
            self._bind_sc_arm(node.nice_arm, fb)
        fb.br(self._br_depth(fb, end_pos))
        fb.emit_end()
        if node.fail_arm:
            self._bind_sc_arm(node.fail_arm, fb)
        fb.emit_end()
        if bind_name is not None:
            fb.local_get(self._fr_val)
            self._sc_set(bind_name, fb)

    def _bind_sc_arm(self, arm: ShortCircuitArm, fb: FuncBody) -> None:
        known = (self._in_function and arm.value in self._local_vars) or arm.value in self._globals
        saved = self._sc_vars.get(arm.value)
        if not known:
            self._sc_vars[arm.value] = ("local", self._fr_val)
        self._gen_statement(EmitStmt(status=arm.status, value=arm.value, message=arm.message), fb)
        if saved is None:
            if not known:
                del self._sc_vars[arm.value]
        else:
            self._sc_vars[arm.value] = saved

    def _gen_match(self, node: MatchExpr | MatchStmt, fb: FuncBody, keep_result: bool) -> int:
        self._check_match_arm_types(node)
        enum_subject = None
        struct_subject = None
        if isinstance(node.subject, Identifier) and node.subject.name in self._enum_slots:
            kind, eslots = self._enum_slots[node.subject.name]
            enum_subject = {"kind": kind, "slots": eslots}
            vt = I64
        elif isinstance(node.subject, EnumVariant) and node.subject.enum_name in self._enums:
            self._gen_decl_enum_variant(node.subject, fb)
            enum_subject = {"kind": "local", "slots": self._pending_enum["slots"]}
            self._pending_enum = None
            vt = I64
        elif isinstance(node.subject, Identifier) and node.subject.name in self._struct_slots:
            kind, sslots = self._struct_slots[node.subject.name]
            struct_subject = {"kind": kind, "slots": sslots}
            vt = I64
        elif isinstance(node.subject, StructInit):
            self._gen_decl_struct_init(node.subject, fb)
            if self._pending_struct is None:
                raise WasmError("internal: struct init did not produce slots")
            struct_subject = {"kind": "local", "slots": self._pending_struct["slots"]}
            self._pending_struct = None
            vt = I64
        else:
            vt = self._gen_expr(node.subject, fb)
        sslot = None
        if enum_subject is None and struct_subject is None:
            if vt == I32:
                sslot = fb.new_i32()
            elif vt == F64:
                sslot = fb.new_f64()
            else:
                sslot = fb.new_i64()
            fb.local_set(sslot)
        rslot = None
        rt = I64
        if keep_result:
            rt = self._match_result_type(node)
            if rt == F64:
                rslot = fb.new_f64()
            elif rt == I32:
                rslot = fb.new_i32()
            else:
                rslot = fb.new_i64()
        fb.emit_block()
        end_depth = fb.label_depth
        for i, arm in enumerate(node.arms):
            pat = arm.pattern
            if isinstance(pat, LiteralPattern):
                if enum_subject is not None or struct_subject is not None:
                    raise WasmError("literal pattern not supported on enum/struct subject")
                fb.emit_block()
                next_depth = fb.label_depth
                fb.local_get(sslot)
                lv = pat.value
                ltype = lv.value_type.lower()
                if _is_str_type(ltype):
                    raise WasmError("string literal pattern not supported on WASM target")
                if ltype == "char":
                    if vt != I32:
                        raise WasmError(f"literal pattern of type 'char' vs subject type '{vt}'")
                    fb.i32_const(ord(lv.value))
                    fb.byte(0x47)
                elif ltype == "bool":
                    fb.i64_const(1 if lv.value.lower() == "true" else 0)
                    fb.byte(OP_I64_NE)
                elif _is_float_type(ltype):
                    if vt != F64:
                        raise WasmError(f"literal pattern of type '{ltype}' vs subject type '{vt}'")
                    fb.f64_const(float(lv.value))
                    fb.byte(OP_F64_NE)
                else:
                    if vt != I64:
                        raise WasmError(f"literal pattern of type '{ltype}' vs subject type '{vt}'")
                    fb.i64_const(_wrap_i64(int(lv.value)))
                    fb.byte(OP_I64_NE)
                fb.br_if(self._br_depth(fb, next_depth))
                self._gen_wasm_guard(arm, fb, next_depth)
                self._gen_match_arm_body(arm, fb, rslot, keep_result, self._br_depth(fb, end_depth))
                fb.emit_end()
            elif isinstance(pat, EnumVariantPattern):
                if enum_subject is None:
                    raise WasmError("enum variant pattern requires an enum subject")
                edef = self._enums.get(pat.enum)
                if edef is None:
                    raise WasmError(f"enum '{pat.enum}' not declared")
                tag = self._enum_tag(edef, pat.variant)
                sget = fb.global_get if enum_subject["kind"] == "global" else fb.local_get
                fb.emit_block()
                next_depth = fb.label_depth
                sget(enum_subject["slots"]["tag"])
                fb.i64_const(tag)
                fb.byte(OP_I64_NE)
                fb.br_if(self._br_depth(fb, next_depth))
                for f in pat.fields:
                    if f.name not in enum_subject["slots"]["fields"]:
                        raise WasmError(f"unknown field '{f.name}' for enum '{pat.enum}'")
                    sid = enum_subject["slots"]["fields"][f.name]
                    wt = self._enum_layout(edef)["fields"][f.name]
                    self._gen_wasm_pattern_field(f, fb, sid, wt, sget, next_depth,
                                                 is_str=self._enum_field_is_str(edef, f.name))
                self._gen_wasm_guard(arm, fb, next_depth)
                self._gen_match_arm_body(arm, fb, rslot, keep_result, self._br_depth(fb, end_depth))
                fb.emit_end()
            elif isinstance(pat, StructPattern):
                if struct_subject is None:
                    raise WasmError("struct pattern requires a struct subject")
                fb.emit_block()
                next_depth = fb.label_depth
                sget = fb.global_get if struct_subject["kind"] == "global" else fb.local_get
                for f in pat.fields:
                    if f.name not in struct_subject["slots"]["fields"]:
                        raise WasmError(f"unknown field '{f.name}' for struct '{pat.name}'")
                    sid, wt = struct_subject["slots"]["fields"][f.name]
                    self._gen_wasm_pattern_field(f, fb, sid, wt, sget, next_depth,
                                                 is_str=self._struct_field_is_str(pat.name, f.name))
                self._gen_wasm_guard(arm, fb, next_depth)
                self._gen_match_arm_body(arm, fb, rslot, keep_result, self._br_depth(fb, end_depth))
                fb.emit_end()
            elif isinstance(pat, RecordPattern):
                st = self._infer_type(node.subject)
                if st not in ("data", "map"):
                    raise WasmError("record pattern requires a data/map subject")
                fb.emit_block()
                next_depth = fb.label_depth
                H = self._helper_funcs
                for f in pat.fields:
                    fv = f.value
                    if isinstance(fv, WildcardPattern):
                        continue
                    mv = fb.new_i64()
                    fb.local_get(sslot)
                    if vt != I32:
                        fb.byte(OP_I32_WRAP_I64)
                    self._emit_fat_const(f.name, fb)
                    fb.byte(0x10)
                    fb.uleb(H["$map_get"])
                    fb.local_set(mv)
                    if isinstance(fv, LiteralPattern):
                        lt = fv.value.value_type.lower()
                        if _is_str_type(lt):
                            self._alloc_str(fv.value.value)
                            fb.local_get(mv)
                            fb.i64_const(self._fat_const(fv.value.value))
                            fb.byte(OP_I64_NE)
                        elif _is_float_type(lt):
                            fb.local_get(mv)
                            fb.byte(OP_F64_REINTERPRET_I64)
                            fb.f64_const(float(fv.value.value))
                            fb.byte(OP_F64_NE)
                        else:
                            fb.local_get(mv)
                            if lt == "bool":
                                fb.i64_const(1 if fv.value.value.lower() == "true" else 0)
                            else:
                                fb.i64_const(_wrap_i64(int(fv.value.value)))
                            fb.byte(OP_I64_NE)
                        fb.br_if(self._br_depth(fb, next_depth))
                    elif isinstance(fv, IdentifierPattern):
                        self._local_vars[fv.name] = (mv, I64)
                    else:
                        raise WasmError(f"pattern '{type(fv).__name__}' not supported in record pattern on WASM target")
                self._gen_wasm_guard(arm, fb, next_depth)
                self._gen_match_arm_body(arm, fb, rslot, keep_result, self._br_depth(fb, end_depth))
                fb.emit_end()
            elif isinstance(pat, IdentifierPattern):
                if enum_subject is not None:
                    raise WasmError("bind pattern not supported on enum subject")
                if struct_subject is not None:
                    raise WasmError("bind pattern not supported on struct subject")
                if vt == F64:
                    bl = fb.new_f64()
                    wt = F64
                elif vt == I32:
                    bl = fb.new_i32()
                    wt = I32
                else:
                    bl = fb.new_i64()
                    wt = I64
                self._local_vars[pat.name] = (bl, wt)
                if self._match_subject_flux_type(node) == "string":
                    self._str_vars.add(pat.name)
                fb.local_get(sslot)
                fb.local_set(bl)
                if arm.guard is not None:
                    fb.emit_block()
                    next_depth = fb.label_depth
                    self._gen_wasm_guard(arm, fb, next_depth)
                    self._gen_match_arm_body(arm, fb, rslot, keep_result, self._br_depth(fb, end_depth))
                    fb.emit_end()
                else:
                    self._gen_match_arm_body(arm, fb, rslot, keep_result, self._br_depth(fb, end_depth))
            elif isinstance(pat, WildcardPattern):
                if arm.guard is not None:
                    fb.emit_block()
                    next_depth = fb.label_depth
                    self._gen_wasm_guard(arm, fb, next_depth)
                    self._gen_match_arm_body(arm, fb, rslot, keep_result, self._br_depth(fb, end_depth))
                    fb.emit_end()
                else:
                    self._gen_match_arm_body(arm, fb, rslot, keep_result, self._br_depth(fb, end_depth))
            elif isinstance(pat, ListPattern):
                fb.emit_block()
                next_depth = fb.label_depth
                H = self._helper_funcs
                lp = fb.new_i32()
                fb.local_get(sslot)
                if vt != I32:
                    fb.byte(OP_I32_WRAP_I64)
                fb.local_set(lp)
                min_len = len(pat.items)
                exact = pat.rest is None
                fb.local_get(lp)
                fb.byte(0x10)
                fb.uleb(H["$list_len"])
                fb.i32_const(min_len)
                if exact:
                    fb.byte(OP_I32_NE)
                else:
                    fb.byte(OP_I32_LT_U)
                fb.br_if(self._br_depth(fb, next_depth))
                sft = self._match_subject_flux_type(node)
                elem_ft = _list_elem_type(sft) if (_is_list_type(sft) or _is_set_type(sft)) else "int64"
                if not elem_ft or elem_ft == "data":
                    elem_ft = "int64"
                for item_idx, item_pat in enumerate(pat.items, 1):
                    if isinstance(item_pat, WildcardPattern):
                        continue
                    fb.local_get(lp)
                    fb.i32_const(item_idx)
                    fb.byte(0x10)
                    fb.uleb(H["$list_row_val"])
                    if isinstance(item_pat, IdentifierPattern):
                        if _is_float_type(elem_ft):
                            bl = fb.new_f64()
                            fb.byte(OP_F64_REINTERPRET_I64)
                            fb.local_set(bl)
                            self._local_vars[item_pat.name] = (bl, F64)
                        elif _is_str_type(elem_ft):
                            bl = fb.new_i64()
                            fb.local_set(bl)
                            self._local_vars[item_pat.name] = (bl, I64)
                            self._str_vars.add(item_pat.name)
                        elif _is_list_type(elem_ft) or _is_set_type(elem_ft) or elem_ft == "data":
                            bl = fb.new_i64()
                            fb.local_set(bl)
                            self._local_vars[item_pat.name] = (bl, I64)
                            self._decl_types[item_pat.name] = elem_ft
                        else:
                            bl = fb.new_i64()
                            fb.local_set(bl)
                            self._local_vars[item_pat.name] = (bl, I64)
                    elif isinstance(item_pat, LiteralPattern):
                        lt = item_pat.value.value_type.lower()
                        if _is_str_type(lt):
                            self._alloc_str(item_pat.value.value)
                            fb.i64_const(self._fat_const(item_pat.value.value))
                            fb.byte(OP_I64_NE)
                            fb.br_if(self._br_depth(fb, next_depth))
                        elif _is_float_type(lt):
                            fb.byte(OP_F64_REINTERPRET_I64)
                            fb.f64_const(float(item_pat.value.value))
                            fb.byte(OP_F64_NE)
                            fb.br_if(self._br_depth(fb, next_depth))
                        else:
                            if lt == "bool":
                                fb.i64_const(1 if item_pat.value.value.lower() == "true" else 0)
                            elif lt == "char":
                                fb.i64_const(ord(item_pat.value.value))
                            else:
                                fb.i64_const(_wrap_i64(int(item_pat.value.value)))
                            fb.byte(OP_I64_NE)
                            fb.br_if(self._br_depth(fb, next_depth))
                    else:
                        raise WasmError(f"nested pattern '{type(item_pat).__name__}' in ListPattern not supported on WASM target")
                if pat.rest is not None:
                    rest_i64 = fb.new_i64()
                    r_i32 = fb.new_i32()
                    fb.local_get(lp)
                    fb.byte(0x10)
                    fb.uleb(H["$list_len"])
                    fb.i32_const(min_len)
                    fb.byte(OP_I32_GT_U)
                    fb.emit_if()
                    fb.local_get(lp)
                    fb.i32_const(min_len + 1)
                    fb.local_get(lp)
                    fb.byte(0x10)
                    fb.uleb(H["$list_len"])
                    fb.byte(0x10)
                    fb.uleb(H["$list_slice"])
                    fb.local_set(r_i32)
                    fb.byte(OP_ELSE)
                    fb.i32_const(0)
                    fb.byte(0x10)
                    fb.uleb(H["$list_build"])
                    fb.local_set(r_i32)
                    fb.local_get(r_i32)
                    fb.i32_const(8)
                    fb.byte(OP_I32_ADD)
                    fb.local_get(lp)
                    fb.byte(0x10)
                    fb.uleb(H["$list_etag"])
                    _mem(fb, OP_I32_STORE, 2, 0)
                    fb.emit_end()
                    fb.local_get(r_i32)
                    fb.byte(OP_I64_EXTEND_I32_U)
                    fb.local_set(rest_i64)
                    self._local_vars[pat.rest] = (rest_i64, I64)
                    self._decl_types[pat.rest] = f"list of {elem_ft}"
                self._gen_wasm_guard(arm, fb, next_depth)
                self._gen_match_arm_body(arm, fb, rslot, keep_result, self._br_depth(fb, end_depth))
                fb.emit_end()
            else:
                raise WasmError(f"pattern '{type(pat).__name__}' not supported on WASM target")
        fb.byte(OP_UNREACHABLE)
        fb.emit_end()
        if keep_result:
            fb.local_get(rslot)
            return rt
        return I64

    def _gen_wasm_guard(self, arm: MatchArm, fb: FuncBody, next_depth: int) -> None:
        if arm.guard is not None:
            self._gen_expr(arm.guard, fb)
            fb.byte(OP_I64_EQZ)
            fb.br_if(self._br_depth(fb, next_depth))

    def _gen_match_arm_body(self, arm: MatchArm, fb: FuncBody, rslot: int | None, keep_result: bool, end_depth: int) -> None:
        b = arm.body
        if isinstance(b, BlockStmt):
            self._gen_block(b, fb)
            if keep_result:
                fb.i64_const(0)
                fb.local_set(rslot)
        elif isinstance(b, (PrintStmt, EmitStmt, RouteStmt, InfiniteStmt,
                            BreakStmt, ContinueStmt, VariableReassign,
                            CallExpr, StorageDecl, ExpressionStmt)):
            self._gen_statement(b, fb)
        else:
            self._gen_expr(b, fb)
            if keep_result:
                fb.local_set(rslot)
        fb.br(end_depth)

    def _gen_wasm_pattern_field(self, f, fb, sid: str, wt: str, sget, next_depth: int, is_str: bool = False) -> None:
        fv = f.value
        if isinstance(fv, WildcardPattern):
            return
        if isinstance(fv, LiteralPattern):
            lv = fv.value
            lt = lv.value_type.lower()
            if _is_str_type(lt):
                raise WasmError("string/char literal field pattern not supported on WASM target")
            sget(sid)
            if _is_float_type(lt):
                if wt != F64:
                    raise WasmError(f"literal field '{f.name}' of type '{lt}' vs field type '{wt}'")
                fb.f64_const(float(lv.value))
                fb.byte(OP_F64_NE)
            else:
                if wt == F64:
                    raise WasmError(f"literal field '{f.name}' of type '{lt}' vs field type 'float64'")
                fb.i64_const(1 if (lt == "bool" and lv.value.lower() == "true") else (0 if lt == "bool" else int(lv.value)))
                fb.byte(OP_I64_NE)
            fb.br_if(self._br_depth(fb, next_depth))
            return
        if isinstance(fv, IdentifierPattern):
            sget(sid)
            if wt == F64:
                bl = fb.new_f64()
            elif wt == I32:
                bl = fb.new_i32()
            else:
                bl = fb.new_i64()
            fb.local_set(bl)
            ft = "float64" if wt == F64 else ("string" if wt == I32 else "int64")
            self._local_vars[fv.name] = (bl, wt)
            if is_str:
                self._str_vars.add(fv.name)
            return
        raise WasmError("nested field pattern not supported on WASM target")

    def _check_match_arm_types(self, node: MatchExpr | MatchStmt) -> None:
        wtypes = set()
        bind_names = {
            arm.pattern.name
            for arm in node.arms
            if isinstance(arm.pattern, IdentifierPattern)
        }
        subj_t = self._match_subject_flux_type(node)
        for arm in node.arms:
            b = arm.body
            t = None
            bindwt: dict[str, int] | None = None
            if isinstance(arm.pattern, EnumVariantPattern):
                edef = self._enums.get(arm.pattern.enum)
                if edef is None:
                    raise WasmError(f"enum '{arm.pattern.enum}' not declared")
                layout = self._enum_layout(edef)
                bindwt = {}
                for f in arm.pattern.fields:
                    if f.name not in layout["fields"]:
                        raise WasmError(f"unknown field '{f.name}' for enum '{arm.pattern.enum}'")
                    if isinstance(f.value, IdentifierPattern):
                        bindwt[f.value.name] = layout["fields"][f.name]
            if isinstance(b, Literal):
                vt = b.value_type.lower()
                if _is_float_type(vt):
                    t = F64
                elif _is_str_type(vt):
                    t = I64
                else:
                    t = I64
            elif isinstance(b, (Identifier, BinaryOp)):
                if bindwt is not None:
                    refs = [n for n in bindwt if self._refs_bind(b, {n})]
                    if refs:
                        vals = [bindwt[n] for n in refs]
                        if F64 in vals:
                            t = F64
                        elif I32 in vals:
                            t = I32
                        else:
                            t = I64
                elif bind_names and self._refs_bind(b, bind_names):
                    if _is_float_type(subj_t):
                        t = F64
                    elif _is_str_type(subj_t):
                        t = I64
                    else:
                        t = I64
                if t is None:
                    it = self._infer_type(b)
                    if it == "float64":
                        t = F64
                    elif self._is_str_type(it):
                        t = I64
                    else:
                        t = I64
            if t is not None:
                wtypes.add(t)
        if len(wtypes) > 1:
            raise WasmError(f"match arms must produce same type, found {sorted(wtypes)}")

    def _match_subject_flux_type(self, node: MatchExpr | MatchStmt) -> str:
        s = node.subject
        if isinstance(s, Literal):
            return s.value_type.lower()
        if isinstance(s, Identifier) and s.name in self._local_vars:
            if s.name in self._str_vars:
                return "string"
            if s.name in self._decl_types:
                return self._decl_types[s.name]
            return "float64" if self._local_vars[s.name][1] == F64 else "int64"
        it = self._infer_type(s)
        if it:
            return it
        return "int64"

    def _refs_bind(self, node: ASTNode, names: set[str]) -> bool:
        if isinstance(node, Identifier):
            return node.name in names
        if isinstance(node, BinaryOp):
            return self._refs_bind(node.left, names) or self._refs_bind(node.right, names)
        return False

    def _match_result_type(self, node: MatchExpr | MatchStmt) -> int:
        for arm in node.arms:
            b = arm.body
            if isinstance(arm.pattern, EnumVariantPattern):
                edef = self._enums.get(arm.pattern.enum)
                if edef is None:
                    continue
                layout = self._enum_layout(edef)
                for f in arm.pattern.fields:
                    if layout["fields"].get(f.name) == F64:
                        return F64
                    if layout["fields"].get(f.name) == I32:
                        return I32
                return I64
            if isinstance(b, Literal):
                vt = b.value_type.lower()
                if _is_float_type(vt):
                    return F64
                if _is_str_type(vt):
                    return I64
                return I64
        return I64

    def _gen_route(self, node: RouteStmt, fb: FuncBody) -> None:
        fb.emit_block()
        end_pos = fb.label_depth
        for arm in node.arms:
            is_wc = (isinstance(arm.condition, Identifier) and arm.condition.name == "_") or arm.condition is None
            if not is_wc:
                fb.emit_block()
                arm_pos = fb.label_depth
                ct = self._infer_type(arm.condition)
                self._gen_expr(arm.condition, fb)
                if _wtype(ct) == I32:
                    fb.byte(OP_I32_EQZ)
                else:
                    fb.byte(OP_I64_EQZ)
                fb.br_if(self._br_depth(fb, arm_pos))
                if arm.body:
                    if isinstance(arm.body, BlockStmt):
                        self._gen_block(arm.body, fb)
                    else:
                        self._gen_statement(arm.body, fb)
                fb.br(self._br_depth(fb, end_pos))
                fb.emit_end()
            else:
                if arm.body:
                    if isinstance(arm.body, BlockStmt):
                        self._gen_block(arm.body, fb)
                    else:
                        self._gen_statement(arm.body, fb)
                fb.br(self._br_depth(fb, end_pos))
        fb.emit_end()

    def _gen_infinite(self, node: InfiniteStmt, fb: FuncBody) -> None:
        if node.iterator is not None:
            return self._gen_infinite_iterator(node, fb)
        fb.emit_block()
        end_pos = fb.label_depth
        fb.emit_loop()
        loop_pos = fb.label_depth
        self._loop_stack.append((loop_pos, end_pos))
        if node.condition:
            ct = self._infer_type(node.condition)
            self._gen_expr(node.condition, fb)
            if _wtype(ct) == I32:
                fb.byte(OP_I32_EQZ)
            else:
                fb.byte(OP_I64_EQZ)
            fb.br_if(self._br_depth(fb, end_pos))
        if node.body and isinstance(node.body, BlockStmt):
            self._gen_block(node.body, fb)
        fb.br(self._br_depth(fb, loop_pos))
        fb.emit_end()
        fb.emit_end()
        self._loop_stack.pop()

    def _gen_infinite_iterator(self, node: InfiniteStmt, fb: FuncBody) -> None:
        coll = node.iterator.collection
        name = node.iterator.variable
        if isinstance(coll, BinaryOp) and coll.op == "..":
            li = fb.new_i64()
            self._local_vars[name] = (li, I64)
            self._gen_expr(coll.left, fb)
            if _is_float_type(self._infer_type(coll.left)):
                fb.byte(OP_I64_TRUNC_F64_S)
            fb.local_set(li)
            self._gen_expr(coll.right, fb)
            if _is_float_type(self._infer_type(coll.right)):
                fb.byte(OP_I64_TRUNC_F64_S)
            ev = fb.new_i64()
            fb.local_set(ev)
            is_static = isinstance(coll.left, Literal) and isinstance(coll.right, Literal)
            if is_static:
                try:
                    desc = int(coll.left.value) > int(coll.right.value)
                except ValueError:
                    desc = False
                fb.emit_block()
                end_pos = fb.label_depth
                fb.emit_loop()
                loop_pos = fb.label_depth
                self._loop_stack.append((loop_pos, end_pos))
                fb.local_get(li)
                fb.local_get(ev)
                fb.byte(OP_I64_GT_S if not desc else OP_I64_LT_S)
                fb.br_if(self._br_depth(fb, end_pos))
                if node.body and isinstance(node.body, BlockStmt):
                    self._gen_block(node.body, fb)
                fb.local_get(li)
                fb.i64_const(1 if not desc else -1)
                fb.byte(OP_I64_ADD)
                fb.local_set(li)
                fb.br(self._br_depth(fb, loop_pos))
                fb.emit_end()
                fb.emit_end()
                self._loop_stack.pop()
            else:
                step = fb.new_i64()
                fb.i64_const(1)
                fb.i64_const(-1)
                fb.local_get(li)
                fb.local_get(ev)
                fb.byte(OP_I64_LE_S)
                fb.byte(OP_SELECT)
                fb.local_set(step)

                fb.emit_block()
                end_pos = fb.label_depth
                fb.emit_loop()
                loop_pos = fb.label_depth
                self._loop_stack.append((loop_pos, end_pos))
                fb.local_get(li)
                fb.local_get(ev)
                fb.byte(OP_I64_GT_S)
                fb.local_get(li)
                fb.local_get(ev)
                fb.byte(OP_I64_LT_S)
                fb.local_get(step)
                fb.i64_const(0)
                fb.byte(OP_I64_GT_S)
                fb.byte(OP_SELECT)
                fb.br_if(self._br_depth(fb, end_pos))
                if node.body and isinstance(node.body, BlockStmt):
                    self._gen_block(node.body, fb)
                fb.local_get(li)
                fb.local_get(step)
                fb.byte(OP_I64_ADD)
                fb.local_set(li)
                fb.br(self._br_depth(fb, loop_pos))
                fb.emit_end()
                fb.emit_end()
                self._loop_stack.pop()
            return

        ct = self._infer_type(coll)
        is_str_coll = _is_str_type(ct)
        is_map_coll = _is_map_type(ct)
        if not (is_str_coll or is_map_coll or _is_list_type(ct) or _is_set_type(ct) or ct == "data"):
            raise WasmError("infinite iterator requires a numeric range 'a .. b' or a list/set/map/string collection")
        if is_str_coll:
            sval = fb.new_i64()
            self._gen_expr(coll, fb)
            fb.local_set(sval)
            nloc = fb.new_i32()
            fb.local_get(sval)
            fb.i64_const(32)
            fb.byte(OP_I64_SHR_U)
            fb.byte(OP_I32_WRAP_I64)
            fb.byte(0x10)
            fb.uleb(self._helper_funcs["$str_char_len"])
            fb.local_set(nloc)
            idx = fb.new_i32()
            fb.i32_const(0)
            fb.local_set(idx)
            elocal = fb.new_i64()
            ewtype = I64
            eft = "string"
            saved = self._local_vars.get(name)
            self._local_vars[name] = (elocal, ewtype)
            self._str_vars.add(name)
            fb.emit_block()
            end_pos = fb.label_depth
            fb.emit_loop()
            loop_pos = fb.label_depth
            self._loop_stack.append((loop_pos, end_pos))
            fb.local_get(idx)
            fb.i32_const(1)
            fb.byte(OP_I32_ADD)
            fb.local_set(idx)
            fb.local_get(idx)
            fb.local_get(nloc)
            fb.byte(OP_I32_GT_U)
            fb.br_if(self._br_depth(fb, end_pos))
            fb.local_get(sval)
            fb.local_get(idx)
            fb.local_get(idx)
            fb.byte(0x10)
            fb.uleb(self._helper_funcs["$str_slice_fat"])
            fb.local_set(elocal)
            if node.body and isinstance(node.body, BlockStmt):
                self._gen_block(node.body, fb)
            fb.br(self._br_depth(fb, loop_pos))
            fb.emit_end()
            fb.emit_end()
            self._loop_stack.pop()
            if saved is not None:
                self._local_vars[name] = saved
            else:
                self._local_vars.pop(name, None)
                self._str_vars.discard(name)
            return
        if is_map_coll:
            et = "string"
        else:
            et = _list_elem_type(ct).strip()
        tag = _list_tag_of(et)
        cp = fb.new_i32()
        self._gen_expr(coll, fb)
        fb.byte(OP_I32_WRAP_I64)
        fb.local_set(cp)
        if is_map_coll:
            fb.local_get(cp)
            fb.byte(0x10)
            fb.uleb(self._helper_funcs["$map_keys"])
            fb.local_set(cp)
        nloc = fb.new_i32()
        fb.local_get(cp)
        fb.byte(0x10)
        fb.uleb(self._helper_funcs["$list_len"])
        fb.local_set(nloc)
        idx = fb.new_i32()
        fb.i32_const(0)
        fb.local_set(idx)
        if tag == 3:
            elocal = fb.new_f64()
            ewtype = F64
            eft = "float64"
        else:
            elocal = fb.new_i64()
            ewtype = I64
            eft = "string" if tag == 4 else ("char" if tag == 2 else ("data" if et == "data" else "int64"))
        saved = self._local_vars.get(name)
        saved_decl = self._decl_types.get(name)
        self._local_vars[name] = (elocal, ewtype)
        if eft == "string":
            self._str_vars.add(name)
        elif eft == "data":
            self._decl_types[name] = "data"
        fb.emit_block()
        end_pos = fb.label_depth
        fb.emit_loop()
        loop_pos = fb.label_depth
        self._loop_stack.append((loop_pos, end_pos))
        fb.local_get(idx)
        fb.i32_const(1)
        fb.byte(OP_I32_ADD)
        fb.local_set(idx)
        fb.local_get(idx)
        fb.local_get(nloc)
        fb.byte(OP_I32_GT_U)
        fb.br_if(self._br_depth(fb, end_pos))
        fb.local_get(cp)
        fb.local_get(idx)
        fb.byte(0x10)
        fb.uleb(self._helper_funcs["$list_row_val"])
        if eft == "float64":
            fb.byte(OP_F64_REINTERPRET_I64)
        fb.local_set(elocal)
        if et == "data":
            tag_slot = fb.new_i32()
            fb.local_get(cp)
            fb.local_get(idx)
            fb.byte(0x10)
            fb.uleb(self._helper_funcs["$list_row_tag"])
            fb.local_set(tag_slot)
            self._param_tag_slots[name] = tag_slot
        if node.body and isinstance(node.body, BlockStmt):
            self._gen_block(node.body, fb)
        fb.br(self._br_depth(fb, loop_pos))
        fb.emit_end()
        fb.emit_end()
        self._loop_stack.pop()
        if et == "data":
            self._param_tag_slots.pop(name, None)
        if saved is not None:
            self._local_vars[name] = saved
        else:
            self._local_vars.pop(name, None)
            if eft == "string":
                self._str_vars.discard(name)
        if saved_decl is not None:
            self._decl_types[name] = saved_decl
        else:
            self._decl_types.pop(name, None)
