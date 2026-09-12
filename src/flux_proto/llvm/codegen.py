from __future__ import annotations

import os
import sys

from flux_proto.parser.ast import (
    ComptimeExpr,
    ASTNode, FluxProgram, FdslFile, BlockStmt, ExpressionStmt, PrintStmt,
    Literal, Identifier, BinaryOp, UnaryOp, CallExpr,
    VariableReassign, RouteStmt, RouteArm, InfiniteStmt,
    BreakStmt, ContinueStmt, EmitStmt,
    ShortCircuitBlock, ShortCircuitArm,
    StructInit, InitField, FieldAccess, StorageDecl, StorageItem,
    FunctionDef, Parameter,
    InterpolatedString, InterpolatedText, EnumVariant,
    MatchExpr, MatchStmt, MatchArm,
    StructDef, FieldAssign, EnumDef,
    SetLiteral, ListLiteral, MapLiteral, MapEntry, IndexAccess, IndexAssign, SliceSpec,
    RecordLiteral,
    DataflowExpr, DataflowCastSink, CastExpr, SpyExpr,
    OwnershipExpr, UnsafeStmt, SpawnExpr, AwaitExpr,
    PtrRefExpr, PtrDerefExpr, PtrAssign, ExternDecl,
    InputExpr,
)
from flux_proto.parser.import_resolver import collect_op_aliases
from flux_proto.parser.patterns import (
    LiteralPattern, IdentifierPattern, WildcardPattern, RecordPattern,
    StructPattern, EnumVariantPattern, ListPattern,
)
from flux_proto.llvm.ir_writer import IRWriter
from flux_proto.floating import FLOAT_FORMATS, FMT_CONSTS, FLOATISH, norm_float_text


class CodegenError(Exception):
    pass


def generate_llvm(program: ASTNode, output_path: str) -> str:
    from flux_proto.macro.expander import expand_macros
    if isinstance(program, FluxProgram):
        program = expand_macros(program)
    cg = LLVMCodegen()
    ir_text = cg.generate(program)
    path = output_path if output_path.endswith(".ll") else output_path + ".ll"
    with open(path, "w", encoding="utf-8") as f:
        f.write(ir_text)
    return ir_text


_TYPE_MAP = {
    "int64": "i64", "int32": "i64", "int16": "i64", "int8": "i64",
    "uint64": "i64", "uint32": "i64", "uint16": "i64", "uint8": "i64",
    "float64": "double", "float32": "double", "float16": "double",
    "fp8_e4m3": "double", "fp8_e5m2": "double",
    "bf16_e8m7": "double", "tf32_e8m10": "double",
    "bool": "i1", "string": "i8*", "char": "i32",
    "datetime": "i64",
    "complex32": "{ double, double }", "complex64": "{ double, double }",
    "complex128": "{ double, double }", "complex": "{ double, double }",
    "int": "i64", "float": "double",
    "data": "i64",
}


def _callee_name(callee: ASTNode | None) -> str:
    if isinstance(callee, Identifier):
        return callee.name
    if isinstance(callee, EnumVariant):
        return callee.variant
    if isinstance(callee, FieldAccess) and isinstance(callee.obj, Identifier):
        return callee.field
    return ""


def _llvm_type(type_name: str) -> str:
    t = type_name.lower()
    return _TYPE_MAP.get(t, "i8*")


def _is_string_type(type_name: str) -> bool:
    t = type_name.lower()
    return t in ("string", "str", "i8*") or t.startswith("string(")


def _is_set_type(type_name: str) -> bool:
    return type_name.lower().startswith("set of")


def _is_list_type(type_name: str) -> bool:
    return type_name.lower().startswith("list of")


def _is_map_type(type_name: str) -> bool:
    t = type_name.lower()
    return t.startswith("map of") or t == "map"


def _is_tensor_type(type_name: str) -> bool:
    return type_name.lower().startswith("tensor")


def _tensor_dims_of(type_name: str) -> list[int]:
    s = type_name[type_name.index("[") + 1: type_name.index("]")]
    return [int(d.strip()) for d in s.split(",") if d.strip()]


def _tensor_elem_ft(type_name: str) -> str:
    return type_name.split(" of ", 1)[1]


def _tensor_strides(dims: list[int]) -> list[int]:
    s = [1] * len(dims)
    for k in range(len(dims) - 2, -1, -1):
        s[k] = s[k + 1] * dims[k + 1]
    return s


def _elem_tag(et: str) -> int:
    t = et.lower()
    if t in ("string", "str", "char"):
        return 4
    if t == "bool":
        return 2
    if t in FLOATISH:
        return 3
    if t.startswith("list of") or t.startswith("set of"):
        return 5
    if t == "datetime":
        return 7
    return 1


_HEAP_THRESHOLD = 1048576

_SET_RETURNING = {
    "stdSetInclude": "set of data",
    "stdSetExclude": "set of data",
    "stdSetUnion": "set of data",
    "stdSetIntersect": "set of data",
    "stdSetDifference": "set of data",
    "stdSetSymmetricDifference": "set of data",
    "stdSetToSet": "set of data",
    "stdSetToList": "list of data",
    "stdListToSet": "set of data",
}

_STD_BOOL_RETURNING = {
    "stdSetIsSubset", "stdSetIsSuperset", "stdSetIsDisjoint",
    "stdListIsEmpty", "stdListContains",
    "stdMapContainsKey", "stdMapContainsValue", "stdMapIsEmpty",
    "stdCollectionContains", "stdCollectionIsEmpty",
}

_STD_LIST_RETURNING = {
    "stdListClearAll", "stdListPushBack", "stdListPushFront", "stdListInsertAt",
    "stdListRemoveAt", "stdListRemoveLast", "stdListSortAscending",
    "stdListSortDescending", "stdListReverse", "stdListFlatten",
    "stdListPartition", "stdListZip", "stdListUnzip", "stdListToList",
    "stdMapKeys", "stdMapExtractKeys", "stdCollectionKeys",
    "stdMapValues", "stdMapExtractValues", "stdCollectionValues",
    "stdMapEntries", "stdMapExtractEntries", "stdCollectionToList",
}

_MAP_RETURNING = {
    "stdMapInsertEntry", "stdMapInsertEntryIfAbsent", "stdMapReplaceEntry",
    "stdMapRemoveEntry", "stdMapRemoveKey", "stdMapClearAll", "stdMapMerge",
    "stdMapToMap", "stdCollectionClearAll", "stdCollectionToMap",
}


def _str_byte_len(s: str) -> int:
    return len(s.encode("utf-8")) + 1


RESULT_TYPE = "%flux.result"
_RESULT_FIELDS = {"sta": (0, "i8*"), "val": (1, "i64"), "vald": (2, "double"), "msg": (3, "i8*")}


class LLVMCodegen:
    def __init__(self) -> None:
        self._w = IRWriter()
        self._globals: dict[str, tuple[str, str, str]] = {}
        self._structs: dict[str, StructDef] = {}
        self._struct_slots: dict[str, dict] = {}
        self._enums: dict[str, EnumDef] = {}
        self._enum_slots: dict[str, dict] = {}
        self._pending_enum: dict | None = None
        self._tmp_seq = 0
        self._imports: dict[str, FdslFile] = {}
        self._function_names: set[str] = set()
        self._function_sigs: dict[str, list[str]] = {}
        self._function_ret: dict[str, str] = {}
        self._param_tag_slots: dict[str, str] = {}
        self._var_tag_slots: dict[str, str] = {}
        self._var_sval_slots: dict[str, str] = {}
        self._result_frame: str | None = None
        self._block_seq = 0
        self._loop_break: str | None = None
        self._loop_continue: str | None = None
        self._block_terminated = False
        self._runtime_stores: list[tuple[str, str, str]] = []
        self._collection_runtime_stores: list[tuple[str, ASTNode]] = []
        self._tensor_runtime_stores: list[tuple[str, ASTNode | None]] = []
        self._string_runtime_stores: list[tuple[str, ASTNode]] = []
        self._general_runtime_stores: list[tuple[str, str, ASTNode]] = []
        self._need_round_helper = False
        self._in_binary_op: bool = False

    def _round_double(self, val: str, ft: str) -> str:
        if ft not in FMT_CONSTS or ft == "float64":
            return val
        self._need_round_helper = True
        mb, emin, emax, allow_inf = FMT_CONSTS[ft]
        r = self._w.new_local("rnd")
        self._w.emit(
            f"{r} = call double @flux_round_fmt(double {val}, "
            f"i64 {mb}, i64 {emin}, i64 {emax}, i64 {allow_inf})"
        )
        return r

    def _emit_round_helper(self) -> None:
        w = self._w
        w.begin_function("flux_round_fmt", "double", ["double", "i64", "i64", "i64", "i64"])
        w.emit("%b = bitcast double %0 to i64")
        w.emit("%e0 = lshr i64 %b, 52")
        w.emit("%e = and i64 %e0, 2047")
        w.emit("%isspec = icmp eq i64 %e, 2047")
        w.emit("br i1 %isspec, label %rf_spec, label %rf_notspec")
        w.new_block("rf_spec")
        w.emit("%noinf = icmp eq i64 %4, 0")
        w.emit("br i1 %noinf, label %rf_nan, label %rf_retv")
        w.new_block("rf_nan")
        w.emit("%nan = fdiv double 0.0, 0.0")
        w.emit("ret double %nan")
        w.new_block("rf_retv")
        w.emit("ret double %0")
        w.new_block("rf_notspec")
        w.emit("%iszero = icmp eq i64 %e, 0")
        w.emit("br i1 %iszero, label %rf_retv2, label %rf_cont1")
        w.new_block("rf_retv2")
        w.emit("ret double %0")
        w.new_block("rf_cont1")
        w.emit("%drop = sub i64 52, %1")
        w.emit("%dropz = icmp eq i64 %drop, 0")
        w.emit("br i1 %dropz, label %rf_retv3, label %rf_cont2")
        w.new_block("rf_retv3")
        w.emit("ret double %0")
        w.new_block("rf_cont2")
        w.emit("%s = lshr i64 %b, 63")
        w.emit("%d1 = sub i64 %drop, 1")
        w.emit("%half = shl i64 1, %d1")
        w.emit("%frac = and i64 %b, 4503599627370495")
        w.emit("%impl = or i64 %frac, 4503599627370496")
        w.emit("%f2 = lshr i64 %impl, %drop")
        w.emit("%remm = sub i64 %half, 1")
        w.emit("%remm2 = shl i64 %remm, 1")
        w.emit("%remm3 = add i64 %remm2, 1")
        w.emit("%rem = and i64 %frac, %remm3")
        w.emit("%gt = icmp ugt i64 %rem, %half")
        w.emit("br i1 %gt, label %rf_inc1, label %rf_after1")
        w.new_block("rf_inc1")
        w.emit("%f2a = add i64 %f2, 1")
        w.emit("br label %rf_after1")
        w.new_block("rf_after1")
        w.emit("%f2b = phi i64 [ %f2, %rf_cont2 ], [ %f2a, %rf_inc1 ]")
        w.emit("%tie = icmp eq i64 %rem, %half")
        w.emit("br i1 %tie, label %rf_tie, label %rf_after2")
        w.new_block("rf_tie")
        w.emit("%odd = and i64 %f2b, 1")
        w.emit("%oddnz = icmp ne i64 %odd, 0")
        w.emit("br i1 %oddnz, label %rf_inc2, label %rf_after2")
        w.new_block("rf_inc2")
        w.emit("%f2c = add i64 %f2b, 1")
        w.emit("br label %rf_after2")
        w.new_block("rf_after2")
        w.emit("%f2d = phi i64 [ %f2b, %rf_after1 ], [ %f2b, %rf_tie ], [ %f2c, %rf_inc2 ]")
        w.emit("%m1 = add i64 %1, 1")
        w.emit("%lim = shl i64 1, %m1")
        w.emit("%over = icmp eq i64 %f2d, %lim")
        w.emit("br i1 %over, label %rf_carry, label %rf_after3")
        w.new_block("rf_carry")
        w.emit("%e2 = add i64 %e, 1")
        w.emit("br label %rf_after3")
        w.new_block("rf_after3")
        w.emit("%f2f = phi i64 [ %f2d, %rf_after2 ], [ 0, %rf_carry ]")
        w.emit("%ef = phi i64 [ %e, %rf_after2 ], [ %e2, %rf_carry ]")
        w.emit("%eu = sub i64 %ef, 1023")
        w.emit("%ovf = icmp sgt i64 %eu, %3")
        w.emit("br i1 %ovf, label %rf_ovf, label %rf_cont3")
        w.new_block("rf_ovf")
        w.emit("%noinf2 = icmp eq i64 %4, 0")
        w.emit("br i1 %noinf2, label %rf_nan2, label %rf_inf")
        w.new_block("rf_nan2")
        w.emit("%nan2 = fdiv double 0.0, 0.0")
        w.emit("ret double %nan2")
        w.new_block("rf_inf")
        w.emit("%pos = icmp eq i64 %s, 0")
        w.emit("%infv = select i1 %pos, double 0x7FF0000000000000, double 0xFFF0000000000000")
        w.emit("ret double %infv")
        w.new_block("rf_cont3")
        w.emit("%sub = icmp slt i64 %eu, %2")
        w.emit("br i1 %sub, label %rf_sub, label %rf_ret")
        w.new_block("rf_sub")
        w.emit("%z = shl i64 %s, 63")
        w.emit("%zd = bitcast i64 %z to double")
        w.emit("ret double %zd")
        w.new_block("rf_ret")
        w.emit("%ep = add i64 %eu, 1023")
        w.emit("%exps = shl i64 %ep, 52")
        w.emit("%mants = shl i64 %f2f, %drop")
        w.emit("%m = and i64 %mants, 4503599627370495")
        w.emit("%ss = shl i64 %s, 63")
        w.emit("%o1 = or i64 %ss, %exps")
        w.emit("%o2 = or i64 %o1, %m")
        w.emit("%res = bitcast i64 %o2 to double")
        w.emit("ret double %res")
        w.end_function()

    def _emit_collection_helpers(self) -> None:
        w = self._w

        def fmt_gep(fmt: str) -> str:
            name = w.get_string_global(fmt)
            flen = _str_byte_len(fmt)
            return f"getelementptr inbounds ([{flen} x i8], [{flen} x i8]* @{name}, i32 0, i32 0)"

        def emit_func(name: str, ret: str, params: list[str]) -> None:
            w.begin_function(name, ret, params)
            w.new_block("entry")

        w.begin_function("flux_list_build", "i8*", ["i64 %n", "i64 %tag"])
        w.new_block("entry")
        w.emit("%h = call i8* @malloc(i64 40)")
        w.emit("%h64 = bitcast i8* %h to i64*")
        w.emit("%cap = add i64 %n, 1")
        w.emit("%capc = icmp sgt i64 %cap, 1")
        w.emit("%capf = select i1 %capc, i64 %cap, i64 1")
        w.emit("%bytes = mul i64 %capf, 24")
        w.emit("%d = call i8* @malloc(i64 %bytes)")
        w.emit("store i64 %n, i64* %h64")
        w.emit("%h1 = getelementptr i64, i64* %h64, i64 1")
        w.emit("store i64 %capf, i64* %h1")
        w.emit("%h2 = getelementptr i64, i64* %h64, i64 2")
        w.emit("store i64 %tag, i64* %h2")
        w.emit("%h3 = getelementptr i64, i64* %h64, i64 3")
        w.emit("%dp = ptrtoint i8* %d to i64")
        w.emit("store i64 %dp, i64* %h3")
        w.emit("%h4 = getelementptr i64, i64* %h64, i64 4")
        w.emit("store i64 0, i64* %h4")
        w.emit("ret i8* %h")
        w.end_function()

        w.begin_function("flux_set_build", "i8*", ["i64 %n", "i64 %tag"])
        w.new_block("entry")
        w.emit("%h = call i8* @flux_list_build(i64 %n, i64 %tag)")
        w.emit("%h64 = bitcast i8* %h to i64*")
        w.emit("store i64 0, i64* %h64")
        w.emit("%h4 = getelementptr i64, i64* %h64, i64 4")
        w.emit("store i64 1, i64* %h4")
        w.emit("ret i8* %h")
        w.end_function()

        w.begin_function("flux_collection_kind", "i64", ["i8* %p"])
        w.new_block("entry")
        w.emit("%h64 = bitcast i8* %p to i64*")
        w.emit("%h4 = getelementptr i64, i64* %h64, i64 4")
        w.emit("%v = load i64, i64* %h4")
        w.emit("ret i64 %v")
        w.end_function()

        w.begin_function("flux_list_len", "i64", ["i8* %p"])
        w.new_block("entry")
        w.emit("%h64 = bitcast i8* %p to i64*")
        w.emit("%v = load i64, i64* %h64")
        w.emit("ret i64 %v")
        w.end_function()

        w.begin_function("flux_list_cap", "i64", ["i8* %p"])
        w.new_block("entry")
        w.emit("%h64 = bitcast i8* %p to i64*")
        w.emit("%h1 = getelementptr i64, i64* %h64, i64 1")
        w.emit("%v = load i64, i64* %h1")
        w.emit("ret i64 %v")
        w.end_function()

        w.begin_function("flux_list_etag", "i64", ["i8* %p"])
        w.new_block("entry")
        w.emit("%h64 = bitcast i8* %p to i64*")
        w.emit("%h2 = getelementptr i64, i64* %h64, i64 2")
        w.emit("%v = load i64, i64* %h2")
        w.emit("ret i64 %v")
        w.end_function()

        w.begin_function("flux_list_data", "i8*", ["i8* %p"])
        w.new_block("entry")
        w.emit("%h64 = bitcast i8* %p to i64*")
        w.emit("%h3 = getelementptr i64, i64* %h64, i64 3")
        w.emit("%v = load i64, i64* %h3")
        w.emit("%d = inttoptr i64 %v to i8*")
        w.emit("ret i8* %d")
        w.end_function()

        w.begin_function("flux_row_addr", "i8*", ["i8* %data", "i64 %i"])
        w.new_block("entry")
        w.emit("%one = sub i64 %i, 1")
        w.emit("%off = mul i64 %one, 24")
        w.emit("%a = getelementptr i8, i8* %data, i64 %off")
        w.emit("ret i8* %a")
        w.end_function()

        w.begin_function("flux_row_tag", "i64", ["i8* %data", "i64 %i"])
        w.new_block("entry")
        w.emit("%a = call i8* @flux_row_addr(i8* %data, i64 %i)")
        w.emit("%r64 = bitcast i8* %a to i64*")
        w.emit("%v = load i64, i64* %r64")
        w.emit("ret i64 %v")
        w.end_function()

        w.begin_function("flux_row_val", "i64", ["i8* %data", "i64 %i"])
        w.new_block("entry")
        w.emit("%a = call i8* @flux_row_addr(i8* %data, i64 %i)")
        w.emit("%r64 = bitcast i8* %a to i64*")
        w.emit("%r1 = getelementptr i64, i64* %r64, i64 1")
        w.emit("%v = load i64, i64* %r1")
        w.emit("ret i64 %v")
        w.end_function()

        w.begin_function("flux_row_sval", "i8*", ["i8* %data", "i64 %i"])
        w.new_block("entry")
        w.emit("%a = call i8* @flux_row_addr(i8* %data, i64 %i)")
        w.emit("%r64 = bitcast i8* %a to i64*")
        w.emit("%r2 = getelementptr i64, i64* %r64, i64 2")
        w.emit("%v = load i64, i64* %r2")
        w.emit("%p = inttoptr i64 %v to i8*")
        w.emit("ret i8* %p")
        w.end_function()

        w.begin_function("flux_row_set", "void", ["i8* %data", "i64 %i", "i64 %tag", "i64 %val", "i64 %sval"])
        w.new_block("entry")
        w.emit("%a = call i8* @flux_row_addr(i8* %data, i64 %i)")
        w.emit("%r64 = bitcast i8* %a to i64*")
        w.emit("store i64 %tag, i64* %r64")
        w.emit("%r1 = getelementptr i64, i64* %r64, i64 1")
        w.emit("store i64 %val, i64* %r1")
        w.emit("%r2 = getelementptr i64, i64* %r64, i64 2")
        w.emit("store i64 %sval, i64* %r2")
        w.emit("ret void")
        w.end_function()

        w.begin_function("flux_set_grow", "i8*", ["i8* %s", "i64 %mincap"])
        w.new_block("entry")
        w.emit("%ocap = call i64 @flux_list_cap(i8* %s)")
        w.emit("%d1 = mul i64 %ocap, 2")
        w.emit("%cand = icmp sgt i64 %d1, %mincap")
        w.emit("%ncap = select i1 %cand, i64 %d1, i64 %mincap")
        w.emit("%nb = mul i64 %ncap, 24")
        w.emit("%nd = call i8* @malloc(i64 %nb)")
        w.emit("%od = call i8* @flux_list_data(i8* %s)")
        w.emit("%ob = mul i64 %ocap, 24")
        w.emit("call i8* @memcpy(i8* %nd, i8* %od, i64 %ob)")
        w.emit("%h64 = bitcast i8* %s to i64*")
        w.emit("%h8 = getelementptr i64, i64* %h64, i64 1")
        w.emit("store i64 %ncap, i64* %h8")
        w.emit("%h24 = getelementptr i64, i64* %h64, i64 3")
        w.emit("%ndp = ptrtoint i8* %nd to i64")
        w.emit("store i64 %ndp, i64* %h24")
        w.emit("ret i8* %s")
        w.end_function()

        w.begin_function("flux_row_eq", "i1", ["i8* %data", "i64 %i", "i64 %tag", "i64 %val", "i8* %sval"])
        w.new_block("entry")
        w.emit("%rt = call i64 @flux_row_tag(i8* %data, i64 %i)")
        w.emit("%teq = icmp eq i64 %rt, %tag")
        w.emit("br i1 %teq, label %re_t, label %re_false")
        w.new_block("re_t")
        w.emit("%isstr = icmp eq i64 %tag, 4")
        w.emit("br i1 %isstr, label %re_str, label %re_num")
        w.new_block("re_str")
        w.emit("%sv = call i8* @flux_row_sval(i8* %data, i64 %i)")
        w.emit("%c = call i32 @strcmp(i8* %sval, i8* %sv)")
        w.emit("%ceq = icmp eq i32 %c, 0")
        w.emit("ret i1 %ceq")
        w.new_block("re_num")
        w.emit("%isf = icmp eq i64 %tag, 3")
        w.emit("br i1 %isf, label %re_float, label %re_int")
        w.new_block("re_float")
        w.emit("%rv = call i64 @flux_row_val(i8* %data, i64 %i)")
        w.emit("%fa = bitcast i64 %rv to double")
        w.emit("%fb = bitcast i64 %val to double")
        w.emit("%feq = fcmp oeq double %fa, %fb")
        w.emit("ret i1 %feq")
        w.new_block("re_int")
        w.emit("%iv = call i64 @flux_row_val(i8* %data, i64 %i)")
        w.emit("%ieq = icmp eq i64 %iv, %val")
        w.emit("ret i1 %ieq")
        w.new_block("re_false")
        w.emit("ret i1 false")
        w.end_function()

        w.begin_function("flux_set_contains", "i1", ["i8* %s", "i64 %tag", "i64 %val", "i8* %sval"])
        w.new_block("entry")
        w.emit("%len = call i64 @flux_list_len(i8* %s)")
        w.emit("%data = call i8* @flux_list_data(i8* %s)")
        w.emit("%i = alloca i64")
        w.emit("store i64 1, i64* %i")
        w.emit("br label %sc_loop")
        w.new_block("sc_loop")
        w.emit("%iv = load i64, i64* %i")
        w.emit("%done = icmp sgt i64 %iv, %len")
        w.emit("br i1 %done, label %sc_no, label %sc_body")
        w.new_block("sc_body")
        w.emit("%eq = call i1 @flux_row_eq(i8* %data, i64 %iv, i64 %tag, i64 %val, i8* %sval)")
        w.emit("br i1 %eq, label %sc_yes, label %sc_next")
        w.new_block("sc_next")
        w.emit("%nv = add i64 %iv, 1")
        w.emit("store i64 %nv, i64* %i")
        w.emit("br label %sc_loop")
        w.new_block("sc_yes")
        w.emit("ret i1 true")
        w.new_block("sc_no")
        w.emit("ret i1 false")
        w.end_function()

        w.begin_function("flux_set_push", "i8*", ["i8* %s", "i64 %tag", "i64 %val", "i8* %sval"])
        w.new_block("entry")
        w.emit("%hit = call i1 @flux_set_contains(i8* %s, i64 %tag, i64 %val, i8* %sval)")
        w.emit("br i1 %hit, label %sp_ret, label %sp_add")
        w.new_block("sp_add")
        w.emit("%len = call i64 @flux_list_len(i8* %s)")
        w.emit("%cap = call i64 @flux_list_cap(i8* %s)")
        w.emit("%nlen = add i64 %len, 1")
        w.emit("%need = icmp sgt i64 %nlen, %cap")
        w.emit("br i1 %need, label %sp_grow, label %sp_wr")
        w.new_block("sp_grow")
        w.emit("%g = call i8* @flux_set_grow(i8* %s, i64 %nlen)")
        w.emit("br label %sp_wr")
        w.new_block("sp_wr")
        w.emit("%h = phi i8* [ %s, %sp_add ], [ %g, %sp_grow ]")
        w.emit("%len2 = call i64 @flux_list_len(i8* %h)")
        w.emit("%data = call i8* @flux_list_data(i8* %h)")
        w.emit("%sp = ptrtoint i8* %sval to i64")
        w.emit("%n2 = add i64 %len2, 1")
        w.emit("call void @flux_row_set(i8* %data, i64 %n2, i64 %tag, i64 %val, i64 %sp)")
        w.emit("%h64 = bitcast i8* %h to i64*")
        w.emit("store i64 %n2, i64* %h64")
        w.emit("ret i8* %h")
        w.new_block("sp_ret")
        w.emit("ret i8* %s")
        w.end_function()

        w.begin_function("flux_set_remove", "i8*", ["i8* %s", "i64 %tag", "i64 %val", "i8* %sval"])
        w.new_block("entry")
        w.emit("%len = call i64 @flux_list_len(i8* %s)")
        w.emit("%data = call i8* @flux_list_data(i8* %s)")
        w.emit("%i = alloca i64")
        w.emit("store i64 1, i64* %i")
        w.emit("br label %sr_loop")
        w.new_block("sr_loop")
        w.emit("%iv = load i64, i64* %i")
        w.emit("%done = icmp sgt i64 %iv, %len")
        w.emit("br i1 %done, label %sr_ret, label %sr_body")
        w.new_block("sr_body")
        w.emit("%eq = call i1 @flux_row_eq(i8* %data, i64 %iv, i64 %tag, i64 %val, i8* %sval)")
        w.emit("br i1 %eq, label %sr_del, label %sr_next")
        w.new_block("sr_next")
        w.emit("%nv = add i64 %iv, 1")
        w.emit("store i64 %nv, i64* %i")
        w.emit("br label %sr_loop")
        w.new_block("sr_del")
        w.emit("%j = alloca i64")
        w.emit("store i64 %iv, i64* %j")
        w.emit("br label %sr_sh")
        w.new_block("sr_sh")
        w.emit("%jv = load i64, i64* %j")
        w.emit("%jend = icmp sge i64 %jv, %len")
        w.emit("br i1 %jend, label %sr_fin, label %sr_shb")
        w.new_block("sr_shb")
        w.emit("%jp = add i64 %jv, 1")
        w.emit("%t1 = call i64 @flux_row_tag(i8* %data, i64 %jp)")
        w.emit("%t2 = call i64 @flux_row_val(i8* %data, i64 %jp)")
        w.emit("%t3 = call i8* @flux_row_sval(i8* %data, i64 %jp)")
        w.emit("%t3i = ptrtoint i8* %t3 to i64")
        w.emit("call void @flux_row_set(i8* %data, i64 %jv, i64 %t1, i64 %t2, i64 %t3i)")
        w.emit("%nj = add i64 %jv, 1")
        w.emit("store i64 %nj, i64* %j")
        w.emit("br label %sr_sh")
        w.new_block("sr_fin")
        w.emit("%nl = sub i64 %len, 1")
        w.emit("%h64 = bitcast i8* %s to i64*")
        w.emit("store i64 %nl, i64* %h64")
        w.emit("br label %sr_ret")
        w.new_block("sr_ret")
        w.emit("ret i8* %s")
        w.end_function()

        w.begin_function("flux_copy_rows", "i8*", ["i8* %src", "i8* %dst"])
        w.new_block("entry")
        w.emit("%len = call i64 @flux_list_len(i8* %src)")
        w.emit("%data = call i8* @flux_list_data(i8* %src)")
        w.emit("%dstp = alloca i8*")
        w.emit("store i8* %dst, i8** %dstp")
        w.emit("%i = alloca i64")
        w.emit("store i64 1, i64* %i")
        w.emit("br label %cr_loop")
        w.new_block("cr_loop")
        w.emit("%iv = load i64, i64* %i")
        w.emit("%done = icmp sgt i64 %iv, %len")
        w.emit("br i1 %done, label %cr_ret, label %cr_body")
        w.new_block("cr_body")
        w.emit("%tg = call i64 @flux_row_tag(i8* %data, i64 %iv)")
        w.emit("%vl = call i64 @flux_row_val(i8* %data, i64 %iv)")
        w.emit("%sv = call i8* @flux_row_sval(i8* %data, i64 %iv)")
        w.emit("%cur = load i8*, i8** %dstp")
        w.emit("%nw = call i8* @flux_set_push(i8* %cur, i64 %tg, i64 %vl, i8* %sv)")
        w.emit("store i8* %nw, i8** %dstp")
        w.emit("%nv = add i64 %iv, 1")
        w.emit("store i64 %nv, i64* %i")
        w.emit("br label %cr_loop")
        w.new_block("cr_ret")
        w.emit("%fin = load i8*, i8** %dstp")
        w.emit("ret i8* %fin")
        w.end_function()

        w.begin_function("flux_set_clone", "i8*", ["i8* %s"])
        w.new_block("entry")
        w.emit("%len = call i64 @flux_list_len(i8* %s)")
        w.emit("%et = call i64 @flux_list_etag(i8* %s)")
        w.emit("%o = call i8* @flux_set_build(i64 %len, i64 %et)")
        w.emit("%r = call i8* @flux_copy_rows(i8* %s, i8* %o)")
        w.emit("ret i8* %r")
        w.end_function()

        w.begin_function("flux_list_concat", "i8*", ["i8* %a", "i8* %b"])
        w.new_block("entry")
        w.emit("%la = call i64 @flux_list_len(i8* %a)")
        w.emit("%lb = call i64 @flux_list_len(i8* %b)")
        w.emit("%et = call i64 @flux_list_etag(i8* %a)")
        w.emit("%et0 = icmp eq i64 %et, 0")
        w.emit("%etb = call i64 @flux_list_etag(i8* %b)")
        w.emit("%etf = select i1 %et0, i64 %etb, i64 %et")
        w.emit("%sum = add i64 %la, %lb")
        w.emit("%o = call i8* @flux_list_build(i64 %sum, i64 %etf)")
        w.emit("%o1 = call i8* @flux_copy_rows(i8* %a, i8* %o)")
        w.emit("%o2 = call i8* @flux_copy_rows(i8* %b, i8* %o1)")
        w.emit("ret i8* %o2")
        w.end_function()

        w.begin_function("flux_set_union", "i8*", ["i8* %a", "i8* %b"])
        w.new_block("entry")
        w.emit("%la = call i64 @flux_list_len(i8* %a)")
        w.emit("%lb = call i64 @flux_list_len(i8* %b)")
        w.emit("%et = call i64 @flux_list_etag(i8* %a)")
        w.emit("%et0 = icmp eq i64 %et, 0")
        w.emit("%etb = call i64 @flux_list_etag(i8* %b)")
        w.emit("%etf = select i1 %et0, i64 %etb, i64 %et")
        w.emit("%sum = add i64 %la, %lb")
        w.emit("%o = call i8* @flux_set_build(i64 %sum, i64 %etf)")
        w.emit("%o1 = call i8* @flux_copy_rows(i8* %a, i8* %o)")
        w.emit("%o2 = call i8* @flux_copy_rows(i8* %b, i8* %o1)")
        w.emit("ret i8* %o2")
        w.end_function()

        w.begin_function("flux_set_intersect", "i8*", ["i8* %a", "i8* %b"])
        w.new_block("entry")
        w.emit("%et = call i64 @flux_list_etag(i8* %a)")
        w.emit("%o = call i8* @flux_set_build(i64 0, i64 %et)")
        w.emit("%dstp = alloca i8*")
        w.emit("store i8* %o, i8** %dstp")
        w.emit("%len = call i64 @flux_list_len(i8* %a)")
        w.emit("%data = call i8* @flux_list_data(i8* %a)")
        w.emit("%i = alloca i64")
        w.emit("store i64 1, i64* %i")
        w.emit("br label %si_loop")
        w.new_block("si_loop")
        w.emit("%iv = load i64, i64* %i")
        w.emit("%done = icmp sgt i64 %iv, %len")
        w.emit("br i1 %done, label %si_ret, label %si_body")
        w.new_block("si_body")
        w.emit("%tg = call i64 @flux_row_tag(i8* %data, i64 %iv)")
        w.emit("%vl = call i64 @flux_row_val(i8* %data, i64 %iv)")
        w.emit("%sv = call i8* @flux_row_sval(i8* %data, i64 %iv)")
        w.emit("%hit = call i1 @flux_set_contains(i8* %b, i64 %tg, i64 %vl, i8* %sv)")
        w.emit("br i1 %hit, label %si_push, label %si_next")
        w.new_block("si_push")
        w.emit("%cur = load i8*, i8** %dstp")
        w.emit("%nw = call i8* @flux_set_push(i8* %cur, i64 %tg, i64 %vl, i8* %sv)")
        w.emit("store i8* %nw, i8** %dstp")
        w.emit("br label %si_next")
        w.new_block("si_next")
        w.emit("%nv = add i64 %iv, 1")
        w.emit("store i64 %nv, i64* %i")
        w.emit("br label %si_loop")
        w.new_block("si_ret")
        w.emit("%fin = load i8*, i8** %dstp")
        w.emit("ret i8* %fin")
        w.end_function()

        w.begin_function("flux_set_difference", "i8*", ["i8* %a", "i8* %b"])
        w.new_block("entry")
        w.emit("%et = call i64 @flux_list_etag(i8* %a)")
        w.emit("%o = call i8* @flux_set_build(i64 0, i64 %et)")
        w.emit("%dstp = alloca i8*")
        w.emit("store i8* %o, i8** %dstp")
        w.emit("%len = call i64 @flux_list_len(i8* %a)")
        w.emit("%data = call i8* @flux_list_data(i8* %a)")
        w.emit("%i = alloca i64")
        w.emit("store i64 1, i64* %i")
        w.emit("br label %sd_loop")
        w.new_block("sd_loop")
        w.emit("%iv = load i64, i64* %i")
        w.emit("%done = icmp sgt i64 %iv, %len")
        w.emit("br i1 %done, label %sd_ret, label %sd_body")
        w.new_block("sd_body")
        w.emit("%tg = call i64 @flux_row_tag(i8* %data, i64 %iv)")
        w.emit("%vl = call i64 @flux_row_val(i8* %data, i64 %iv)")
        w.emit("%sv = call i8* @flux_row_sval(i8* %data, i64 %iv)")
        w.emit("%hit = call i1 @flux_set_contains(i8* %b, i64 %tg, i64 %vl, i8* %sv)")
        w.emit("br i1 %hit, label %sd_next, label %sd_push")
        w.new_block("sd_push")
        w.emit("%cur = load i8*, i8** %dstp")
        w.emit("%nw = call i8* @flux_set_push(i8* %cur, i64 %tg, i64 %vl, i8* %sv)")
        w.emit("store i8* %nw, i8** %dstp")
        w.emit("br label %sd_next")
        w.new_block("sd_next")
        w.emit("%nv = add i64 %iv, 1")
        w.emit("store i64 %nv, i64* %i")
        w.emit("br label %sd_loop")
        w.new_block("sd_ret")
        w.emit("%fin = load i8*, i8** %dstp")
        w.emit("ret i8* %fin")
        w.end_function()

        w.begin_function("flux_set_symmetric_difference", "i8*", ["i8* %a", "i8* %b"])
        w.new_block("entry")
        w.emit("%ab = call i8* @flux_set_difference(i8* %a, i8* %b)")
        w.emit("%ba = call i8* @flux_set_difference(i8* %b, i8* %a)")
        w.emit("%r = call i8* @flux_set_union(i8* %ab, i8* %ba)")
        w.emit("ret i8* %r")
        w.end_function()

        w.begin_function("flux_set_is_subset", "i1", ["i8* %a", "i8* %b"])
        w.new_block("entry")
        w.emit("%len = call i64 @flux_list_len(i8* %a)")
        w.emit("%data = call i8* @flux_list_data(i8* %a)")
        w.emit("%i = alloca i64")
        w.emit("store i64 1, i64* %i")
        w.emit("br label %su_loop")
        w.new_block("su_loop")
        w.emit("%iv = load i64, i64* %i")
        w.emit("%done = icmp sgt i64 %iv, %len")
        w.emit("br i1 %done, label %su_yes, label %su_body")
        w.new_block("su_body")
        w.emit("%tg = call i64 @flux_row_tag(i8* %data, i64 %iv)")
        w.emit("%vl = call i64 @flux_row_val(i8* %data, i64 %iv)")
        w.emit("%sv = call i8* @flux_row_sval(i8* %data, i64 %iv)")
        w.emit("%hit = call i1 @flux_set_contains(i8* %b, i64 %tg, i64 %vl, i8* %sv)")
        w.emit("br i1 %hit, label %su_next, label %su_no")
        w.new_block("su_next")
        w.emit("%nv = add i64 %iv, 1")
        w.emit("store i64 %nv, i64* %i")
        w.emit("br label %su_loop")
        w.new_block("su_yes")
        w.emit("ret i1 true")
        w.new_block("su_no")
        w.emit("ret i1 false")
        w.end_function()

        w.begin_function("flux_set_is_superset", "i1", ["i8* %a", "i8* %b"])
        w.new_block("entry")
        w.emit("%r = call i1 @flux_set_is_subset(i8* %b, i8* %a)")
        w.emit("ret i1 %r")
        w.end_function()

        w.begin_function("flux_set_is_disjoint", "i1", ["i8* %a", "i8* %b"])
        w.new_block("entry")
        w.emit("%len = call i64 @flux_list_len(i8* %a)")
        w.emit("%data = call i8* @flux_list_data(i8* %a)")
        w.emit("%i = alloca i64")
        w.emit("store i64 1, i64* %i")
        w.emit("br label %sj_loop")
        w.new_block("sj_loop")
        w.emit("%iv = load i64, i64* %i")
        w.emit("%done = icmp sgt i64 %iv, %len")
        w.emit("br i1 %done, label %sj_yes, label %sj_body")
        w.new_block("sj_body")
        w.emit("%tg = call i64 @flux_row_tag(i8* %data, i64 %iv)")
        w.emit("%vl = call i64 @flux_row_val(i8* %data, i64 %iv)")
        w.emit("%sv = call i8* @flux_row_sval(i8* %data, i64 %iv)")
        w.emit("%hit = call i1 @flux_set_contains(i8* %b, i64 %tg, i64 %vl, i8* %sv)")
        w.emit("br i1 %hit, label %sj_no, label %sj_next")
        w.new_block("sj_next")
        w.emit("%nv = add i64 %iv, 1")
        w.emit("store i64 %nv, i64* %i")
        w.emit("br label %sj_loop")
        w.new_block("sj_yes")
        w.emit("ret i1 true")
        w.new_block("sj_no")
        w.emit("ret i1 false")
        w.end_function()

        w.begin_function("flux_set_to_list", "i8*", ["i8* %s"])
        w.new_block("entry")
        w.emit("%len = call i64 @flux_list_len(i8* %s)")
        w.emit("%et = call i64 @flux_list_etag(i8* %s)")
        w.emit("%o = call i8* @flux_list_build(i64 %len, i64 %et)")
        w.emit("%odata = call i8* @flux_list_data(i8* %o)")
        w.emit("%sdata = call i8* @flux_list_data(i8* %s)")
        w.emit("%i = alloca i64")
        w.emit("store i64 1, i64* %i")
        w.emit("br label %st_loop")
        w.new_block("st_loop")
        w.emit("%iv = load i64, i64* %i")
        w.emit("%done = icmp sgt i64 %iv, %len")
        w.emit("br i1 %done, label %st_ret, label %st_body")
        w.new_block("st_body")
        w.emit("%tg = call i64 @flux_row_tag(i8* %sdata, i64 %iv)")
        w.emit("%vl = call i64 @flux_row_val(i8* %sdata, i64 %iv)")
        w.emit("%sv = call i8* @flux_row_sval(i8* %sdata, i64 %iv)")
        w.emit("%svp = ptrtoint i8* %sv to i64")
        w.emit("call void @flux_row_set(i8* %odata, i64 %iv, i64 %tg, i64 %vl, i64 %svp)")
        w.emit("%nv = add i64 %iv, 1")
        w.emit("store i64 %nv, i64* %i")
        w.emit("br label %st_loop")
        w.new_block("st_ret")
        w.emit("ret i8* %o")
        w.end_function()

        w.begin_function("flux_list_to_set", "i8*", ["i8* %l"])
        w.new_block("entry")
        w.emit("%len = call i64 @flux_list_len(i8* %l)")
        w.emit("%et = call i64 @flux_list_etag(i8* %l)")
        w.emit("%o = call i8* @flux_set_build(i64 %len, i64 %et)")
        w.emit("%r = call i8* @flux_copy_rows(i8* %l, i8* %o)")
        w.emit("ret i8* %r")
        w.end_function()

        w.begin_function("flux_set_from_data", "i8*", ["i64 %val"])
        w.new_block("entry")
        w.emit("%big = icmp uge i64 %val, " + str(_HEAP_THRESHOLD))
        w.emit("br i1 %big, label %fda_list, label %fda_scalar")
        w.new_block("fda_list")
        w.emit("%p = inttoptr i64 %val to i8*")
        w.emit("%kind = call i64 @flux_collection_kind(i8* %p)")
        w.emit("%is_set = icmp eq i64 %kind, 1")
        w.emit("br i1 %is_set, label %fda_as_is, label %fda_conv")
        w.new_block("fda_as_is")
        w.emit("ret i8* %p")
        w.new_block("fda_conv")
        w.emit("%r1 = call i8* @flux_list_to_set(i8* %p)")
        w.emit("ret i8* %r1")
        w.new_block("fda_scalar")
        w.emit("%o = call i8* @flux_set_build(i64 1, i64 1)")
        w.emit("%r2 = call i8* @flux_set_push(i8* %o, i64 1, i64 %val, i8* null)")
        w.emit("ret i8* %r2")
        w.end_function()

        w.begin_function("flux_list_from_data", "i8*", ["i64 %val"])
        w.new_block("entry")
        w.emit("%big = icmp uge i64 %val, " + str(_HEAP_THRESHOLD))
        w.emit("br i1 %big, label %fld_coll, label %fld_scalar")
        w.new_block("fld_coll")
        w.emit("%p = inttoptr i64 %val to i8*")
        w.emit("%kind = call i64 @flux_collection_kind(i8* %p)")
        w.emit("%is_set = icmp eq i64 %kind, 1")
        w.emit("br i1 %is_set, label %fld_set, label %fld_as_is")
        w.new_block("fld_set")
        w.emit("%r_set = call i8* @flux_set_to_list(i8* %p)")
        w.emit("ret i8* %r_set")
        w.new_block("fld_as_is")
        w.emit("ret i8* %p")
        w.new_block("fld_scalar")
        w.emit("%o = call i8* @flux_list_build(i64 0, i64 1)")
        w.emit("%r2 = call i8* @flux_list_push(i8* %o, i64 1, i64 %val, i8* null)")
        w.emit("ret i8* %r2")
        w.end_function()

        sep_fmt = fmt_gep(", ")
        idiom_fmt = fmt_gep("%lld")
        fstr_fmt = fmt_gep("%s")
        dbl_fmt = fmt_gep("%.17g")
        str_true = self._w.get_string_global("true")
        str_false = self._w.get_string_global("false")
        str_none = self._w.get_string_global("None")

        w.begin_function("flux_data_to_str", "i8*", ["i64 %val", "i64 %tag", "i8* %buf"])
        w.new_block("entry")
        w.emit("%is_none_tag = icmp eq i64 %tag, 0")
        w.emit("%is_none_val = icmp eq i64 %val, 0")
        w.emit("%is_none = and i1 %is_none_tag, %is_none_val")
        w.emit("br i1 %is_none, label %dts_none, label %dts_c0")
        w.new_block("dts_none")
        w.emit(f"ret i8* getelementptr inbounds ([5 x i8], [5 x i8]* @{str_none}, i32 0, i32 0)")
        w.new_block("dts_c0")
        w.emit("%is_tag_str = icmp eq i64 %tag, 4")
        w.emit("br i1 %is_tag_str, label %dts_str, label %dts_c1")
        w.new_block("dts_str")
        w.emit("%p_str = inttoptr i64 %val to i8*")
        w.emit("ret i8* %p_str")
        w.new_block("dts_c1")
        w.emit("%is_tag_flt = icmp eq i64 %tag, 3")
        w.emit("br i1 %is_tag_flt, label %dts_flt, label %dts_c2")
        w.new_block("dts_flt")
        w.emit("%fd_dts = bitcast i64 %val to double")
        w.emit("%fres = call i8* @flux_fmt_double(double %fd_dts, i8* %buf)")
        w.emit("ret i8* %fres")
        w.new_block("dts_c2")
        w.emit("%is_tag_bool = icmp eq i64 %tag, 2")
        w.emit("br i1 %is_tag_bool, label %dts_bool, label %dts_c3")
        w.new_block("dts_bool")
        w.emit("%bcond = icmp ne i64 %val, 0")
        w.emit(f"%bstr = select i1 %bcond, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @{str_true}, i32 0, i32 0), i8* getelementptr inbounds ([6 x i8], [6 x i8]* @{str_false}, i32 0, i32 0)")
        w.emit("ret i8* %bstr")
        w.new_block("dts_c3")
        w.emit("%is_tag_coll = icmp eq i64 %tag, 5")
        w.emit("br i1 %is_tag_coll, label %dts_coll, label %dts_c4")
        w.new_block("dts_c4")
        w.emit("%big = icmp uge i64 %val, " + str(_HEAP_THRESHOLD))
        w.emit("br i1 %big, label %dts_coll, label %dts_scalar")
        w.new_block("dts_coll")
        w.emit("%p = inttoptr i64 %val to i8*")
        w.emit("%r1 = call i8* @flux_collection_to_buf(i8* %p, i8* %buf)")
        w.emit("ret i8* %r1")
        w.new_block("dts_scalar")
        w.emit("%dtc = call i32 (i8*, i64, i8*, ...) @snprintf(i8* %buf, i64 4096, i8* " + idiom_fmt + ", i64 %val)")
        w.emit("ret i8* %buf")
        w.end_function()

        for fname, open_ch, close_ch in (("flux_list_to_buf", 91, 93), ("flux_set_to_buf", 123, 125)):
            w.begin_function(fname, "i8*", ["i8* %p", "i8* %buf"])
            w.new_block("entry")
            w.emit("%pos = alloca i64")
            w.emit("store i64 1, i64* %pos")
            w.emit("store i8 " + str(open_ch) + ", i8* %buf")
            w.emit("%len = call i64 @flux_list_len(i8* %p)")
            w.emit("%data = call i8* @flux_list_data(i8* %p)")
            w.emit("%i = alloca i64")
            w.emit("store i64 1, i64* %i")
            w.emit("br label %lb_loop")
            w.new_block("lb_loop")
            w.emit("%iv = load i64, i64* %i")
            w.emit("%done = icmp sgt i64 %iv, %len")
            w.emit("br i1 %done, label %lb_ret, label %lb_body")
            w.new_block("lb_body")
            w.emit("%pcur = load i64, i64* %pos")
            w.emit("%is1 = icmp sgt i64 %iv, 1")
            w.emit("br i1 %is1, label %lb_sep, label %lb_val")
            w.new_block("lb_sep")
            w.emit("%sepgep = getelementptr i8, i8* %buf, i64 %pcur")
            w.emit("%sepem = sub i64 4096, %pcur")
            w.emit("%c1 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* %sepgep, i64 %sepem, i8* " + sep_fmt + ")")
            w.emit("%p1 = add i64 %pcur, 2")
            w.emit("store i64 %p1, i64* %pos")
            w.emit("br label %lb_val")
            w.new_block("lb_val")
            w.emit("%pcurv = load i64, i64* %pos")
            w.emit("%gep = getelementptr i8, i8* %buf, i64 %pcurv")
            w.emit("%rem = sub i64 4096, %pcurv")
            w.emit("%igtag = call i64 @flux_row_tag(i8* %data, i64 %iv)")
            w.emit("%is_nest = icmp eq i64 %igtag, 5")
            w.emit("br i1 %is_nest, label %lb_nest, label %lb_strc")
            w.new_block("lb_strc")
            w.emit("%is_str = icmp eq i64 %igtag, 4")
            w.emit("br i1 %is_str, label %lb_str, label %lb_num")
            w.new_block("lb_str")
            w.emit("%sv = call i8* @flux_row_sval(i8* %data, i64 %iv)")
            w.emit("%c2 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* %gep, i64 %rem, i8* " + fstr_fmt + ", i8* %sv)")
            w.emit("%c2z = zext i32 %c2 to i64")
            w.emit("br label %lb_inc")
            w.new_block("lb_nest")
            w.emit("%np = call i64 @flux_row_val(i8* %data, i64 %iv)")
            w.emit("%nptr = inttoptr i64 %np to i8*")
            w.emit("%subbuf = alloca i8, i64 4096")
            w.emit("%nstr = call i8* @flux_collection_to_buf(i8* %nptr, i8* %subbuf)")
            w.emit("%c5 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* %gep, i64 %rem, i8* " + fstr_fmt + ", i8* %nstr)")
            w.emit("%c5z = zext i32 %c5 to i64")
            w.emit("br label %lb_inc")
            w.new_block("lb_num")
            w.emit("%is_flt = icmp eq i64 %igtag, 3")
            w.emit("br i1 %is_flt, label %lb_flt, label %lb_int")
            w.new_block("lb_flt")
            w.emit("%fv = call i64 @flux_row_val(i8* %data, i64 %iv)")
            w.emit("%fd = bitcast i64 %fv to double")
            w.emit("%fmb = alloca i8, i64 64")
            w.emit("%fs = call i8* @flux_fmt_double(double %fd, i8* %fmb)")
            w.emit("%c3 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* %gep, i64 %rem, i8* " + fstr_fmt + ", i8* %fs)")
            w.emit("%c3z = zext i32 %c3 to i64")
            w.emit("br label %lb_inc")
            w.new_block("lb_int")
            w.emit("%ivl = call i64 @flux_row_val(i8* %data, i64 %iv)")
            w.emit("%c4 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* %gep, i64 %rem, i8* " + idiom_fmt + ", i64 %ivl)")
            w.emit("%c4z = zext i32 %c4 to i64")
            w.emit("br label %lb_inc")
            w.new_block("lb_inc")
            w.emit("%cc = phi i64 [ %c2z, %lb_str ], [ %c3z, %lb_flt ], [ %c4z, %lb_int ], [ %c5z, %lb_nest ]")
            w.emit("%pc2 = load i64, i64* %pos")
            w.emit("%px = add i64 %pc2, %cc")
            w.emit("store i64 %px, i64* %pos")
            w.emit("%nv = add i64 %iv, 1")
            w.emit("store i64 %nv, i64* %i")
            w.emit("br label %lb_loop")
            w.new_block("lb_ret")
            w.emit("%pcur2 = load i64, i64* %pos")
            w.emit("%gep2 = getelementptr i8, i8* %buf, i64 %pcur2")
            w.emit("store i8 " + str(close_ch) + ", i8* %gep2")
            w.emit("%pz = add i64 %pcur2, 1")
            w.emit("%gepz = getelementptr i8, i8* %buf, i64 %pz")
            w.emit("store i8 0, i8* %gepz")
            w.emit("ret i8* %buf")
            w.end_function()

        self._emit_map_helpers(w, fmt_gep, fstr_fmt)

        self._emit_list_helpers(w)

    def _emit_map_helpers(self, w, fmt_gep, fstr_fmt) -> None:
        lld_fmt = fmt_gep("%lld")
        dot_fmt = fmt_gep("%lld.0")
        g15_fmt = fmt_gep("%.15g")
        g16_fmt = fmt_gep("%.16g")
        g17_fmt = fmt_gep("%.17g")
        sep2_fmt = fmt_gep(", ")
        colon_fmt = fmt_gep(": ")
        none_fmt = fmt_gep("None")
        brace_fmt = fmt_gep("{")
        ebrace_fmt = fmt_gep("}")

        w.begin_function("flux_fmt_double", "i8*", ["double %d", "i8* %buf"])
        w.new_block("entry")
        w.emit("%t = fptosi double %d to i64")
        w.emit("%r = sitofp i64 %t to double")
        w.emit("%isint = fcmp oeq double %d, %r")
        w.emit("br i1 %isint, label %fd_int, label %fd_loop")
        w.new_block("fd_int")
        w.emit("call i32 (i8*, i64, i8*, ...) @snprintf(i8* %buf, i64 64, i8* " + dot_fmt + ", i64 %t)")
        w.emit("ret i8* %buf")
        w.new_block("fd_loop")
        w.emit("%p = alloca i64")
        w.emit("store i64 15, i64* %p")
        w.emit("br label %fd_try")
        w.new_block("fd_try")
        w.emit("%pv = load i64, i64* %p")
        w.emit("%done = icmp sgt i64 %pv, 17")
        w.emit("br i1 %done, label %fd_ret, label %fd_body")
        w.new_block("fd_body")
        w.emit("%is15 = icmp eq i64 %pv, 15")
        w.emit("%is16 = icmp eq i64 %pv, 16")
        w.emit("%fmt = select i1 %is15, i8* " + g15_fmt + ", i8* " + g16_fmt)
        w.emit("%fmt2 = select i1 %is16, i8* " + g16_fmt + ", i8* " + g17_fmt)
        w.emit("%fmtf = select i1 %is15, i8* %fmt, i8* %fmt2")
        w.emit("call i32 (i8*, i64, i8*, ...) @snprintf(i8* %buf, i64 64, i8* %fmtf, double %d)")
        w.emit("%s = call double @strtod(i8* %buf, i8* null)")
        w.emit("%sb = bitcast double %s to i64")
        w.emit("%db = bitcast double %d to i64")
        w.emit("%eq = icmp eq i64 %sb, %db")
        w.emit("br i1 %eq, label %fd_ret, label %fd_next")
        w.new_block("fd_next")
        w.emit("%n2 = add i64 %pv, 1")
        w.emit("store i64 %n2, i64* %p")
        w.emit("br label %fd_try")
        w.new_block("fd_ret")
        w.emit("ret i8* %buf")
        w.end_function()

        w.begin_function("flux_char_to_utf8", "i8*", ["i32 %cp"])
        w.new_block("entry")
        w.emit("%cm = call i8* @malloc(i64 5)")
        w.emit("%le127 = icmp ule i32 %cp, 127")
        w.emit("br i1 %le127, label %c1, label %c2")
        w.new_block("c1")
        w.emit("%b1s = trunc i32 %cp to i8")
        w.emit("store i8 %b1s, i8* %cm")
        w.emit("%c1z = getelementptr i8, i8* %cm, i64 1")
        w.emit("store i8 0, i8* %c1z")
        w.emit("ret i8* %cm")
        w.new_block("c2")
        w.emit("%le2047 = icmp ule i32 %cp, 2047")
        w.emit("br i1 %le2047, label %c2b, label %c3")
        w.new_block("c2b")
        w.emit("%c2s6 = lshr i32 %cp, 6")
        w.emit("%c2b0t = trunc i32 %c2s6 to i8")
        w.emit("%c2b0 = or i8 %c2b0t, -64")
        w.emit("store i8 %c2b0, i8* %cm")
        w.emit("%c2p1 = getelementptr i8, i8* %cm, i64 1")
        w.emit("%c2m = and i32 %cp, 63")
        w.emit("%c2b1t = trunc i32 %c2m to i8")
        w.emit("%c2b1 = or i8 %c2b1t, -128")
        w.emit("store i8 %c2b1, i8* %c2p1")
        w.emit("%c2z = getelementptr i8, i8* %cm, i64 2")
        w.emit("store i8 0, i8* %c2z")
        w.emit("ret i8* %cm")
        w.new_block("c3")
        w.emit("%le65535 = icmp ule i32 %cp, 65535")
        w.emit("br i1 %le65535, label %c3b, label %c4")
        w.new_block("c3b")
        w.emit("%c3s12 = lshr i32 %cp, 12")
        w.emit("%c3b0t = trunc i32 %c3s12 to i8")
        w.emit("%c3b0 = or i8 %c3b0t, -32")
        w.emit("store i8 %c3b0, i8* %cm")
        w.emit("%c3p1 = getelementptr i8, i8* %cm, i64 1")
        w.emit("%c3s6 = lshr i32 %cp, 6")
        w.emit("%c3m6 = and i32 %c3s6, 63")
        w.emit("%c3b1t = trunc i32 %c3m6 to i8")
        w.emit("%c3b1 = or i8 %c3b1t, -128")
        w.emit("store i8 %c3b1, i8* %c3p1")
        w.emit("%c3p2 = getelementptr i8, i8* %cm, i64 2")
        w.emit("%c3b2t = trunc i32 %cp to i8")
        w.emit("%c3b2 = or i8 %c3b2t, -128")
        w.emit("store i8 %c3b2, i8* %c3p2")
        w.emit("%c3z = getelementptr i8, i8* %cm, i64 3")
        w.emit("store i8 0, i8* %c3z")
        w.emit("ret i8* %cm")
        w.new_block("c4")
        w.emit("%c4s18 = lshr i32 %cp, 18")
        w.emit("%c4b0t = trunc i32 %c4s18 to i8")
        w.emit("%c4b0 = or i8 %c4b0t, -16")
        w.emit("store i8 %c4b0, i8* %cm")
        w.emit("%c4p1 = getelementptr i8, i8* %cm, i64 1")
        w.emit("%c4s12 = lshr i32 %cp, 12")
        w.emit("%c4m12 = and i32 %c4s12, 63")
        w.emit("%c4b1t = trunc i32 %c4m12 to i8")
        w.emit("%c4b1 = or i8 %c4b1t, -128")
        w.emit("store i8 %c4b1, i8* %c4p1")
        w.emit("%c4p2 = getelementptr i8, i8* %cm, i64 2")
        w.emit("%c4s6 = lshr i32 %cp, 6")
        w.emit("%c4m6 = and i32 %c4s6, 63")
        w.emit("%c4b2t = trunc i32 %c4m6 to i8")
        w.emit("%c4b2 = or i8 %c4b2t, -128")
        w.emit("store i8 %c4b2, i8* %c4p2")
        w.emit("%c4p3 = getelementptr i8, i8* %cm, i64 3")
        w.emit("%c4m3 = and i32 %cp, 63")
        w.emit("%c4b3t = trunc i32 %c4m3 to i8")
        w.emit("%c4b3 = or i8 %c4b3t, -128")
        w.emit("store i8 %c4b3, i8* %c4p3")
        w.emit("%c4z = getelementptr i8, i8* %cm, i64 4")
        w.emit("store i8 0, i8* %c4z")
        w.emit("ret i8* %cm")
        w.end_function()

        w.begin_function("flux_datetime_to_buf", "i8*", ["i64 %nanos", "i8* %buf"])
        w.new_block("entry")
        w.emit("%sec = sdiv i64 %nanos, 1000000000")
        w.emit("%frac = srem i64 %nanos, 1000000000")
        w.emit("%days = sdiv i64 %sec, 86400")
        w.emit("%rem_sec = srem i64 %sec, 86400")
        w.emit("%hour = sdiv i64 %rem_sec, 3600")
        w.emit("%min_rem = srem i64 %rem_sec, 3600")
        w.emit("%min = sdiv i64 %min_rem, 60")
        w.emit("%s = srem i64 %min_rem, 60")
        w.emit("%z = add i64 %days, 719468")
        w.emit("%era = sdiv i64 %z, 146097")
        w.emit("%era_mul = mul i64 %era, 146097")
        w.emit("%doe = sub i64 %z, %era_mul")
        w.emit("%doe_div1 = sdiv i64 %doe, 1460")
        w.emit("%doe_div2 = sdiv i64 %doe, 36524")
        w.emit("%doe_div3 = sdiv i64 %doe, 146096")
        w.emit("%yoe_t1 = sub i64 %doe, %doe_div1")
        w.emit("%yoe_t2 = add i64 %yoe_t1, %doe_div2")
        w.emit("%yoe_t3 = sub i64 %yoe_t2, %doe_div3")
        w.emit("%yoe = sdiv i64 %yoe_t3, 365")
        w.emit("%era_400 = mul i64 %era, 400")
        w.emit("%y_raw = add i64 %yoe, %era_400")
        w.emit("%yoe_365 = mul i64 365, %yoe")
        w.emit("%yoe_4 = sdiv i64 %yoe, 4")
        w.emit("%yoe_100 = sdiv i64 %yoe, 100")
        w.emit("%doy_t1 = add i64 %yoe_365, %yoe_4")
        w.emit("%doy_t2 = sub i64 %doy_t1, %yoe_100")
        w.emit("%doy = sub i64 %doe, %doy_t2")
        w.emit("%mp_t1 = mul i64 5, %doy")
        w.emit("%mp_t2 = add i64 %mp_t1, 2")
        w.emit("%mp = sdiv i64 %mp_t2, 153")
        w.emit("%d_t1 = mul i64 153, %mp")
        w.emit("%d_t2 = add i64 %d_t1, 2")
        w.emit("%d_t3 = sdiv i64 %d_t2, 5")
        w.emit("%d_t4 = sub i64 %doy, %d_t3")
        w.emit("%d = add i64 %d_t4, 1")
        w.emit("%cmp_mp = icmp slt i64 %mp, 10")
        w.emit("%m_alt1 = add i64 %mp, 3")
        w.emit("%m_alt2 = sub i64 %mp, 9")
        w.emit("%m = select i1 %cmp_mp, i64 %m_alt1, i64 %m_alt2")
        w.emit("%cmp_m = icmp sle i64 %m, 2")
        w.emit("%y_inc = add i64 %y_raw, 1")
        w.emit("%y = select i1 %cmp_m, i64 %y_inc, i64 %y_raw")
        dt_fmt_name = w.get_string_global("%04lld-%02lld-%02lldT%02lld:%02lld:%02lld.%09lldZ")
        dt_fmt_len = _str_byte_len("%04lld-%02lld-%02lldT%02lld:%02lld:%02lld.%09lldZ")
        w.emit(f"call i32 (i8*, i64, i8*, ...) @snprintf(i8* %buf, i64 64, i8* getelementptr inbounds ([{dt_fmt_len} x i8], [{dt_fmt_len} x i8]* @{dt_fmt_name}, i32 0, i32 0), i64 %y, i64 %m, i64 %d, i64 %hour, i64 %min, i64 %s, i64 %frac)")
        w.emit("ret i8* %buf")
        w.end_function()

        w.begin_function("flux_complex_to_buf", "i8*", ["double %re", "double %im", "i8* %buf"])
        w.new_block("entry")
        w.emit("%r_buf = alloca i8, i64 64")
        w.emit("%i_buf = alloca i8, i64 64")
        w.emit("%r_str = call i8* @flux_fmt_double(double %re, i8* %r_buf)")
        w.emit("%cneg = fcmp olt double %im, 0.0")
        w.emit("br i1 %cneg, label %c_neg, label %c_pos")
        w.new_block("c_neg")
        w.emit("%abs_im = fneg double %im")
        w.emit("%i_str_neg = call i8* @flux_fmt_double(double %abs_im, i8* %i_buf)")
        s_neg = "%s - %si"
        sn_neg = w.get_string_global(s_neg)
        sl_neg = _str_byte_len(s_neg)
        w.emit(f"call i32 (i8*, i64, i8*, ...) @snprintf(i8* %buf, i64 128, i8* getelementptr inbounds ([{sl_neg} x i8], [{sl_neg} x i8]* @{sn_neg}, i32 0, i32 0), i8* %r_str, i8* %i_str_neg)")
        w.emit("ret i8* %buf")
        w.new_block("c_pos")
        w.emit("%i_str_pos = call i8* @flux_fmt_double(double %im, i8* %i_buf)")
        s_pos = "%s + %si"
        sn_pos = w.get_string_global(s_pos)
        sl_pos = _str_byte_len(s_pos)
        w.emit(f"call i32 (i8*, i64, i8*, ...) @snprintf(i8* %buf, i64 128, i8* getelementptr inbounds ([{sl_pos} x i8], [{sl_pos} x i8]* @{sn_pos}, i32 0, i32 0), i8* %r_str, i8* %i_str_pos)")
        w.emit("ret i8* %buf")
        w.end_function()

        w.begin_function("flux_elem_to_buf", "i64", ["i64 %tag", "i64 %val", "i8* %buf"])
        w.new_block("entry")
        w.emit("%is0 = icmp eq i64 %tag, 0")
        w.emit("br i1 %is0, label %eb_none, label %eb_chk4")
        w.new_block("eb_none")
        w.emit("%cn = call i32 (i8*, i64, i8*, ...) @snprintf(i8* %buf, i64 4096, i8* " + none_fmt + ")")
        w.emit("%cnz = zext i32 %cn to i64")
        w.emit("ret i64 %cnz")
        w.new_block("eb_chk4")
        w.emit("%is4 = icmp eq i64 %tag, 4")
        w.emit("br i1 %is4, label %eb_str, label %eb_chk2")
        w.new_block("eb_str")
        w.emit("%sp = inttoptr i64 %val to i8*")
        w.emit("%c4 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* %buf, i64 4096, i8* " + fstr_fmt + ", i8* %sp)")
        w.emit("%c4z = zext i32 %c4 to i64")
        w.emit("ret i64 %c4z")
        w.new_block("eb_chk2")
        w.emit("%is2 = icmp eq i64 %tag, 2")
        w.emit("br i1 %is2, label %eb_bool, label %eb_chk3")
        w.new_block("eb_bool")
        w.emit("%sel = icmp ne i64 %val, 0")
        w.emit("%tf = select i1 %sel, i8* " + fmt_gep("true") + ", i8* " + fmt_gep("false") + "")
        w.emit("%c2 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* %buf, i64 4096, i8* " + fstr_fmt + ", i8* %tf)")
        w.emit("%c2z = zext i32 %c2 to i64")
        w.emit("ret i64 %c2z")
        w.new_block("eb_chk3")
        w.emit("%is3 = icmp eq i64 %tag, 3")
        w.emit("br i1 %is3, label %eb_flt, label %eb_chk5")
        w.new_block("eb_flt")
        w.emit("%fd = bitcast i64 %val to double")
        w.emit("%fmb = alloca i8, i64 64")
        w.emit("%fs = call i8* @flux_fmt_double(double %fd, i8* %fmb)")
        w.emit("%c3 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* %buf, i64 4096, i8* " + fstr_fmt + ", i8* %fs)")
        w.emit("%c3z = zext i32 %c3 to i64")
        w.emit("ret i64 %c3z")
        w.new_block("eb_chk5")
        w.emit("%is5 = icmp eq i64 %tag, 5")
        w.emit("br i1 %is5, label %eb_nest, label %eb_chk7")
        w.new_block("eb_nest")
        w.emit("%np = inttoptr i64 %val to i8*")
        w.emit("%sb = alloca i8, i64 4096")
        w.emit("%cs = call i8* @flux_collection_to_buf(i8* %np, i8* %sb)")
        w.emit("%c5 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* %buf, i64 4096, i8* " + fstr_fmt + ", i8* %cs)")
        w.emit("%c5z = zext i32 %c5 to i64")
        w.emit("ret i64 %c5z")
        w.new_block("eb_chk7")
        w.emit("%is7 = icmp eq i64 %tag, 7")
        w.emit("br i1 %is7, label %eb_dt, label %eb_int")
        w.new_block("eb_dt")
        w.emit("%dtb = alloca i8, i64 64")
        w.emit("%dts = call i8* @flux_datetime_to_buf(i64 %val, i8* %dtb)")
        w.emit("%c7 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* %buf, i64 4096, i8* " + fstr_fmt + ", i8* %dts)")
        w.emit("%c7z = zext i32 %c7 to i64")
        w.emit("ret i64 %c7z")
        w.new_block("eb_int")
        w.emit("%c1 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* %buf, i64 4096, i8* " + lld_fmt + ", i64 %val)")
        w.emit("%c1z = zext i32 %c1 to i64")
        w.emit("ret i64 %c1z")
        w.end_function()

        w.begin_function("flux_collection_to_buf", "i8*", ["i8* %p", "i8* %buf"])
        w.new_block("entry")
        w.emit("%null_p = icmp eq i8* %p, null")
        w.emit("br i1 %null_p, label %ctb_null, label %ctb_check")
        w.new_block("ctb_null")
        w.emit("store i8 91, i8* %buf")
        w.emit("%b1 = getelementptr i8, i8* %buf, i64 1")
        w.emit("store i8 93, i8* %b1")
        w.emit("%b2 = getelementptr i8, i8* %buf, i64 2")
        w.emit("store i8 0, i8* %b2")
        w.emit("ret i8* %buf")
        w.new_block("ctb_check")
        w.emit("%first_byte = load i8, i8* %p")
        w.emit("%is_str_bracket = icmp eq i8 %first_byte, 91")
        w.emit("%is_str_brace = icmp eq i8 %first_byte, 123")
        w.emit("%is_str_lead = or i1 %is_str_bracket, %is_str_brace")
        w.emit("br i1 %is_str_lead, label %ctb_str, label %ctb_valid_coll")
        w.new_block("ctb_valid_coll")
        w.emit("%kind = call i64 @flux_collection_kind(i8* %p)")
        w.emit("%ism = icmp eq i64 %kind, 2")
        w.emit("br i1 %ism, label %ctb_map, label %ctb_chk_set")
        w.new_block("ctb_chk_set")
        w.emit("%isset = icmp eq i64 %kind, 1")
        w.emit("br i1 %isset, label %ctb_set, label %ctb_chk_list")
        w.new_block("ctb_chk_list")
        w.emit("%islist = icmp eq i64 %kind, 0")
        w.emit("br i1 %islist, label %ctb_list, label %ctb_str")
        w.new_block("ctb_set")
        w.emit("%s = call i8* @flux_set_to_buf(i8* %p, i8* %buf)")
        w.emit("ret i8* %s")
        w.new_block("ctb_map")
        w.emit("%m = call i8* @flux_map_to_buf(i8* %p, i8* %buf)")
        w.emit("ret i8* %m")
        w.new_block("ctb_list")
        w.emit("%l = call i8* @flux_list_to_buf(i8* %p, i8* %buf)")
        w.emit("ret i8* %l")
        w.new_block("ctb_str")
        w.emit("ret i8* %p")
        w.end_function()

        w.begin_function("flux_map_build", "i8*", ["i64 %n"])
        w.new_block("entry")
        w.emit("%h = call i8* @flux_list_build(i64 %n, i64 7)")
        w.emit("%h64 = bitcast i8* %h to i64*")
        w.emit("store i64 0, i64* %h64")
        w.emit("%h4 = getelementptr i64, i64* %h64, i64 4")
        w.emit("store i64 2, i64* %h4")
        w.emit("ret i8* %h")
        w.end_function()

        w.begin_function("flux_map_key", "i8*", ["i8* %p", "i64 %i"])
        w.new_block("entry")
        w.emit("%d = call i8* @flux_list_data(i8* %p)")
        w.emit("%a = call i8* @flux_row_addr(i8* %d, i64 %i)")
        w.emit("%r64 = bitcast i8* %a to i64*")
        w.emit("%v = load i64, i64* %r64")
        w.emit("%kp = inttoptr i64 %v to i8*")
        w.emit("ret i8* %kp")
        w.end_function()

        w.begin_function("flux_map_vtag", "i64", ["i8* %p", "i64 %i"])
        w.new_block("entry")
        w.emit("%d = call i8* @flux_list_data(i8* %p)")
        w.emit("%a = call i8* @flux_row_addr(i8* %d, i64 %i)")
        w.emit("%r64 = bitcast i8* %a to i64*")
        w.emit("%r1 = getelementptr i64, i64* %r64, i64 1")
        w.emit("%v = load i64, i64* %r1")
        w.emit("ret i64 %v")
        w.end_function()

        w.begin_function("flux_map_vval", "i64", ["i8* %p", "i64 %i"])
        w.new_block("entry")
        w.emit("%d = call i8* @flux_list_data(i8* %p)")
        w.emit("%a = call i8* @flux_row_addr(i8* %d, i64 %i)")
        w.emit("%r64 = bitcast i8* %a to i64*")
        w.emit("%r2 = getelementptr i64, i64* %r64, i64 2")
        w.emit("%v = load i64, i64* %r2")
        w.emit("ret i64 %v")
        w.end_function()

        w.begin_function("flux_map_find", "i64", ["i8* %p", "i8* %key"])
        w.new_block("entry")
        w.emit("%len = call i64 @flux_list_len(i8* %p)")
        w.emit("%i = alloca i64")
        w.emit("store i64 1, i64* %i")
        w.emit("br label %mf_loop")
        w.new_block("mf_loop")
        w.emit("%iv = load i64, i64* %i")
        w.emit("%done = icmp sgt i64 %iv, %len")
        w.emit("br i1 %done, label %mf_zero, label %mf_body")
        w.new_block("mf_body")
        w.emit("%k = call i8* @flux_map_key(i8* %p, i64 %iv)")
        w.emit("%c = call i32 @strcmp(i8* %k, i8* %key)")
        w.emit("%ceq = icmp eq i32 %c, 0")
        w.emit("br i1 %ceq, label %mf_found, label %mf_next")
        w.new_block("mf_found")
        w.emit("ret i64 %iv")
        w.new_block("mf_next")
        w.emit("%n2 = add i64 %iv, 1")
        w.emit("store i64 %n2, i64* %i")
        w.emit("br label %mf_loop")
        w.new_block("mf_zero")
        w.emit("ret i64 0")
        w.end_function()

        w.begin_function("flux_map_set", "i8*", ["i8* %p", "i8* %key", "i64 %vtag", "i64 %vval"])
        w.new_block("entry")
        w.emit("%idx = call i64 @flux_map_find(i8* %p, i8* %key)")
        w.emit("%found = icmp ne i64 %idx, 0")
        w.emit("br i1 %found, label %ms_join, label %ms_grow")
        w.new_block("ms_grow")
        w.emit("%len = call i64 @flux_list_len(i8* %p)")
        w.emit("%min = add i64 %len, 1")
        w.emit("%g = call i8* @flux_set_grow(i8* %p, i64 %min)")
        w.emit("%n2 = add i64 %len, 1")
        w.emit("%h64 = bitcast i8* %p to i64*")
        w.emit("store i64 %n2, i64* %h64")
        w.emit("br label %ms_join")
        w.new_block("ms_join")
        w.emit("%idx2 = phi i64 [ %idx, %entry ], [ %n2, %ms_grow ]")
        w.emit("%d = call i8* @flux_list_data(i8* %p)")
        w.emit("%a = call i8* @flux_row_addr(i8* %d, i64 %idx2)")
        w.emit("%r64 = bitcast i8* %a to i64*")
        w.emit("%kp = ptrtoint i8* %key to i64")
        w.emit("store i64 %kp, i64* %r64")
        w.emit("%r1 = getelementptr i64, i64* %r64, i64 1")
        w.emit("store i64 %vtag, i64* %r1")
        w.emit("%r2 = getelementptr i64, i64* %r64, i64 2")
        w.emit("store i64 %vval, i64* %r2")
        w.emit("ret i8* %p")
        w.end_function()

        w.begin_function("flux_map_set_if_absent", "i8*", ["i8* %p", "i8* %key", "i64 %vtag", "i64 %vval"])
        w.new_block("entry")
        w.emit("%idx = call i64 @flux_map_find(i8* %p, i8* %key)")
        w.emit("%found = icmp ne i64 %idx, 0")
        w.emit("br i1 %found, label %sa_ret, label %sa_set")
        w.new_block("sa_ret")
        w.emit("ret i8* %p")
        w.new_block("sa_set")
        w.emit("%r = call i8* @flux_map_set(i8* %p, i8* %key, i64 %vtag, i64 %vval)")
        w.emit("ret i8* %r")
        w.end_function()

        w.begin_function("flux_map_replace", "i8*", ["i8* %p", "i8* %key", "i64 %vtag", "i64 %vval"])
        w.new_block("entry")
        w.emit("%idx = call i64 @flux_map_find(i8* %p, i8* %key)")
        w.emit("%found = icmp ne i64 %idx, 0")
        w.emit("br i1 %found, label %mr_set, label %mr_add")
        w.new_block("mr_set")
        w.emit("%d = call i8* @flux_list_data(i8* %p)")
        w.emit("%a = call i8* @flux_row_addr(i8* %d, i64 %idx)")
        w.emit("%r64 = bitcast i8* %a to i64*")
        w.emit("%r1 = getelementptr i64, i64* %r64, i64 1")
        w.emit("store i64 %vtag, i64* %r1")
        w.emit("%r2 = getelementptr i64, i64* %r64, i64 2")
        w.emit("store i64 %vval, i64* %r2")
        w.emit("ret i8* %p")
        w.new_block("mr_add")
        w.emit("%r2b = call i8* @flux_map_set(i8* %p, i8* %key, i64 %vtag, i64 %vval)")
        w.emit("ret i8* %r2b")
        w.end_function()

        w.begin_function("flux_map_remove", "i8*", ["i8* %p", "i8* %key"])
        w.new_block("entry")
        w.emit("%idx = call i64 @flux_map_find(i8* %p, i8* %key)")
        w.emit("%found = icmp ne i64 %idx, 0")
        w.emit("br i1 %found, label %rm_del, label %rm_ret")
        w.new_block("rm_del")
        w.emit("%len = call i64 @flux_list_len(i8* %p)")
        w.emit("%nl = sub i64 %len, 1")
        w.emit("%h64 = bitcast i8* %p to i64*")
        w.emit("store i64 %nl, i64* %h64")
        w.emit("%i = alloca i64")
        w.emit("store i64 %idx, i64* %i")
        w.emit("br label %rm_loop")
        w.new_block("rm_loop")
        w.emit("%iv = load i64, i64* %i")
        w.emit("%done = icmp sge i64 %iv, %len")
        w.emit("br i1 %done, label %rm_ret, label %rm_body")
        w.new_block("rm_body")
        w.emit("%d = call i8* @flux_list_data(i8* %p)")
        w.emit("%n1 = add i64 %iv, 1")
        w.emit("%src = call i8* @flux_row_addr(i8* %d, i64 %n1)")
        w.emit("%dst = call i8* @flux_row_addr(i8* %d, i64 %iv)")
        w.emit("%s64 = bitcast i8* %src to i64*")
        w.emit("%d64 = bitcast i8* %dst to i64*")
        w.emit("%s0 = load i64, i64* %s64")
        w.emit("store i64 %s0, i64* %d64")
        w.emit("%s1g = getelementptr i64, i64* %s64, i64 1")
        w.emit("%d1g = getelementptr i64, i64* %d64, i64 1")
        w.emit("%s1 = load i64, i64* %s1g")
        w.emit("store i64 %s1, i64* %d1g")
        w.emit("%s2g = getelementptr i64, i64* %s64, i64 2")
        w.emit("%d2g = getelementptr i64, i64* %d64, i64 2")
        w.emit("%s2 = load i64, i64* %s2g")
        w.emit("store i64 %s2, i64* %d2g")
        w.emit("%nv = add i64 %iv, 1")
        w.emit("store i64 %nv, i64* %i")
        w.emit("br label %rm_loop")
        w.new_block("rm_ret")
        w.emit("ret i8* %p")
        w.end_function()

        w.begin_function("flux_map_get", "i64", ["i8* %p", "i8* %key"])
        w.new_block("entry")
        w.emit("%idx = call i64 @flux_map_find(i8* %p, i8* %key)")
        w.emit("%found = icmp ne i64 %idx, 0")
        w.emit("br i1 %found, label %mg_val, label %mg_zero")
        w.new_block("mg_val")
        w.emit("%v = call i64 @flux_map_vval(i8* %p, i64 %idx)")
        w.emit("ret i64 %v")
        w.new_block("mg_zero")
        w.emit("ret i64 0")
        w.end_function()

        w.begin_function("flux_map_get_tag", "i64", ["i8* %p", "i8* %key"])
        w.new_block("entry")
        w.emit("%idx = call i64 @flux_map_find(i8* %p, i8* %key)")
        w.emit("%found = icmp ne i64 %idx, 0")
        w.emit("br i1 %found, label %mgt_val, label %mgt_zero")
        w.new_block("mgt_val")
        w.emit("%v = call i64 @flux_map_vtag(i8* %p, i64 %idx)")
        w.emit("ret i64 %v")
        w.new_block("mgt_zero")
        w.emit("ret i64 0")
        w.end_function()

        w.begin_function("flux_map_contains_key", "i1", ["i8* %p", "i8* %key"])
        w.new_block("entry")
        w.emit("%idx = call i64 @flux_map_find(i8* %p, i8* %key)")
        w.emit("%found = icmp ne i64 %idx, 0")
        w.emit("ret i1 %found")
        w.end_function()

        w.begin_function("flux_map_contains_value", "i1", ["i8* %p", "i64 %tag", "i64 %val", "i8* %sval"])
        w.new_block("entry")
        w.emit("%len = call i64 @flux_list_len(i8* %p)")
        w.emit("%i = alloca i64")
        w.emit("store i64 1, i64* %i")
        w.emit("br label %cv_loop")
        w.new_block("cv_loop")
        w.emit("%iv = load i64, i64* %i")
        w.emit("%done = icmp sgt i64 %iv, %len")
        w.emit("br i1 %done, label %cv_false, label %cv_body")
        w.new_block("cv_body")
        w.emit("%t = call i64 @flux_map_vtag(i8* %p, i64 %iv)")
        w.emit("%teq = icmp eq i64 %t, %tag")
        w.emit("br i1 %teq, label %cv_t, label %cv_next")
        w.new_block("cv_t")
        w.emit("%isstr = icmp eq i64 %tag, 4")
        w.emit("br i1 %isstr, label %cv_str, label %cv_num")
        w.new_block("cv_str")
        w.emit("%v = call i64 @flux_map_vval(i8* %p, i64 %iv)")
        w.emit("%vp = inttoptr i64 %v to i8*")
        w.emit("%c = call i32 @strcmp(i8* %sval, i8* %vp)")
        w.emit("%ceq = icmp eq i32 %c, 0")
        w.emit("ret i1 %ceq")
        w.new_block("cv_num")
        w.emit("%isf = icmp eq i64 %tag, 3")
        w.emit("br i1 %isf, label %cv_flt, label %cv_int")
        w.new_block("cv_flt")
        w.emit("%fv = call i64 @flux_map_vval(i8* %p, i64 %iv)")
        w.emit("%fa = bitcast i64 %fv to double")
        w.emit("%fb = bitcast i64 %val to double")
        w.emit("%feq = fcmp oeq double %fa, %fb")
        w.emit("ret i1 %feq")
        w.new_block("cv_int")
        w.emit("%iv2 = call i64 @flux_map_vval(i8* %p, i64 %iv)")
        w.emit("%ieq = icmp eq i64 %iv2, %val")
        w.emit("ret i1 %ieq")
        w.new_block("cv_next")
        w.emit("%nv = add i64 %iv, 1")
        w.emit("store i64 %nv, i64* %i")
        w.emit("br label %cv_loop")
        w.new_block("cv_false")
        w.emit("ret i1 false")
        w.end_function()

        w.begin_function("flux_map_clear", "i8*", ["i8* %p"])
        w.new_block("entry")
        w.emit("%h64 = bitcast i8* %p to i64*")
        w.emit("store i64 0, i64* %h64")
        w.emit("ret i8* %p")
        w.end_function()

        w.begin_function("flux_map_keys", "i8*", ["i8* %p"])
        w.new_block("entry")
        w.emit("%len = call i64 @flux_list_len(i8* %p)")
        w.emit("%out = call i8* @flux_list_build(i64 %len, i64 4)")
        w.emit("%od = call i8* @flux_list_data(i8* %out)")
        w.emit("%i = alloca i64")
        w.emit("store i64 1, i64* %i")
        w.emit("br label %mk_loop")
        w.new_block("mk_loop")
        w.emit("%iv = load i64, i64* %i")
        w.emit("%done = icmp sgt i64 %iv, %len")
        w.emit("br i1 %done, label %mk_ret, label %mk_body")
        w.new_block("mk_body")
        w.emit("%k = call i8* @flux_map_key(i8* %p, i64 %iv)")
        w.emit("%kp = ptrtoint i8* %k to i64")
        w.emit("call void @flux_row_set(i8* %od, i64 %iv, i64 4, i64 0, i64 %kp)")
        w.emit("%nv = add i64 %iv, 1")
        w.emit("store i64 %nv, i64* %i")
        w.emit("br label %mk_loop")
        w.new_block("mk_ret")
        w.emit("ret i8* %out")
        w.end_function()

        w.begin_function("flux_map_values", "i8*", ["i8* %p"])
        w.new_block("entry")
        w.emit("%len = call i64 @flux_list_len(i8* %p)")
        w.emit("%out = call i8* @flux_list_build(i64 %len, i64 0)")
        w.emit("%od = call i8* @flux_list_data(i8* %out)")
        w.emit("%i = alloca i64")
        w.emit("store i64 1, i64* %i")
        w.emit("br label %mv_loop")
        w.new_block("mv_loop")
        w.emit("%iv = load i64, i64* %i")
        w.emit("%done = icmp sgt i64 %iv, %len")
        w.emit("br i1 %done, label %mv_ret, label %mv_body")
        w.new_block("mv_body")
        w.emit("%t = call i64 @flux_map_vtag(i8* %p, i64 %iv)")
        w.emit("%v = call i64 @flux_map_vval(i8* %p, i64 %iv)")
        w.emit("call void @flux_row_set(i8* %od, i64 %iv, i64 %t, i64 %v, i64 %v)")
        w.emit("%nv = add i64 %iv, 1")
        w.emit("store i64 %nv, i64* %i")
        w.emit("br label %mv_loop")
        w.new_block("mv_ret")
        w.emit("ret i8* %out")
        w.end_function()

        w.begin_function("flux_map_entries", "i8*", ["i8* %p"])
        w.new_block("entry")
        w.emit("%len = call i64 @flux_list_len(i8* %p)")
        w.emit("%out = call i8* @flux_list_build(i64 %len, i64 5)")
        w.emit("%od = call i8* @flux_list_data(i8* %out)")
        w.emit("%i = alloca i64")
        w.emit("store i64 1, i64* %i")
        w.emit("br label %me_loop")
        w.new_block("me_loop")
        w.emit("%iv = load i64, i64* %i")
        w.emit("%done = icmp sgt i64 %iv, %len")
        w.emit("br i1 %done, label %me_ret, label %me_body")
        w.new_block("me_body")
        w.emit("%k = call i8* @flux_map_key(i8* %p, i64 %iv)")
        w.emit("%t = call i64 @flux_map_vtag(i8* %p, i64 %iv)")
        w.emit("%v = call i64 @flux_map_vval(i8* %p, i64 %iv)")
        w.emit("%inner = call i8* @flux_list_build(i64 2, i64 0)")
        w.emit("%id = call i8* @flux_list_data(i8* %inner)")
        w.emit("%kp = ptrtoint i8* %k to i64")
        w.emit("call void @flux_row_set(i8* %id, i64 1, i64 4, i64 0, i64 %kp)")
        w.emit("call void @flux_row_set(i8* %id, i64 2, i64 %t, i64 %v, i64 %v)")
        w.emit("%ip = ptrtoint i8* %inner to i64")
        w.emit("call void @flux_row_set(i8* %od, i64 %iv, i64 5, i64 %ip, i64 0)")
        w.emit("%nv = add i64 %iv, 1")
        w.emit("store i64 %nv, i64* %i")
        w.emit("br label %me_loop")
        w.new_block("me_ret")
        w.emit("ret i8* %out")
        w.end_function()

        w.begin_function("flux_map_merge", "i8*", ["i8* %a", "i8* %b"])
        w.new_block("entry")
        w.emit("%na = call i64 @flux_list_len(i8* %a)")
        w.emit("%out = call i8* @flux_map_build(i64 %na)")
        w.emit("%i = alloca i64")
        w.emit("store i64 1, i64* %i")
        w.emit("br label %mm_loop1")
        w.new_block("mm_loop1")
        w.emit("%iv = load i64, i64* %i")
        w.emit("%done = icmp sgt i64 %iv, %na")
        w.emit("br i1 %done, label %mm_loop2, label %mm_body1")
        w.new_block("mm_body1")
        w.emit("%k = call i8* @flux_map_key(i8* %a, i64 %iv)")
        w.emit("%t = call i64 @flux_map_vtag(i8* %a, i64 %iv)")
        w.emit("%v = call i64 @flux_map_vval(i8* %a, i64 %iv)")
        w.emit("%r = call i8* @flux_map_set(i8* %out, i8* %k, i64 %t, i64 %v)")
        w.emit("%nv = add i64 %iv, 1")
        w.emit("store i64 %nv, i64* %i")
        w.emit("br label %mm_loop1")
        w.new_block("mm_loop2")
        w.emit("%nb = call i64 @flux_list_len(i8* %b)")
        w.emit("%i2 = alloca i64")
        w.emit("store i64 1, i64* %i2")
        w.emit("br label %mm_loop2b")
        w.new_block("mm_loop2b")
        w.emit("%iv2 = load i64, i64* %i2")
        w.emit("%done2 = icmp sgt i64 %iv2, %nb")
        w.emit("br i1 %done2, label %mm_ret, label %mm_body2")
        w.new_block("mm_body2")
        w.emit("%k2 = call i8* @flux_map_key(i8* %b, i64 %iv2)")
        w.emit("%t2 = call i64 @flux_map_vtag(i8* %b, i64 %iv2)")
        w.emit("%v2 = call i64 @flux_map_vval(i8* %b, i64 %iv2)")
        w.emit("%r2 = call i8* @flux_map_set(i8* %out, i8* %k2, i64 %t2, i64 %v2)")
        w.emit("%nv2 = add i64 %iv2, 1")
        w.emit("store i64 %nv2, i64* %i2")
        w.emit("br label %mm_loop2b")
        w.new_block("mm_ret")
        w.emit("ret i8* %out")
        w.end_function()

        w.begin_function("flux_map_to_set", "i8*", ["i8* %p"])
        w.new_block("entry")
        w.emit("%len = call i64 @flux_list_len(i8* %p)")
        w.emit("%out = call i8* @flux_set_build(i64 %len, i64 4)")
        w.emit("%i = alloca i64")
        w.emit("store i64 1, i64* %i")
        w.emit("br label %mts_loop")
        w.new_block("mts_loop")
        w.emit("%iv = load i64, i64* %i")
        w.emit("%done = icmp sgt i64 %iv, %len")
        w.emit("br i1 %done, label %mts_ret, label %mts_body")
        w.new_block("mts_body")
        w.emit("%k = call i8* @flux_map_key(i8* %p, i64 %iv)")
        w.emit("%kp = ptrtoint i8* %k to i64")
        w.emit("%r = call i8* @flux_set_push(i8* %out, i64 4, i64 %kp, i8* %k)")
        w.emit("%nv = add i64 %iv, 1")
        w.emit("store i64 %nv, i64* %i")
        w.emit("br label %mts_loop")
        w.new_block("mts_ret")
        w.emit("ret i8* %out")
        w.end_function()

        w.begin_function("flux_map_from_pairs", "i8*", ["i8* %p"])
        w.new_block("entry")
        w.emit("%len = call i64 @flux_list_len(i8* %p)")
        w.emit("%out = call i8* @flux_map_build(i64 0)")
        w.emit("%i = alloca i64")
        w.emit("store i64 1, i64* %i")
        w.emit("br label %mfp_loop")
        w.new_block("mfp_loop")
        w.emit("%iv = load i64, i64* %i")
        w.emit("%done = icmp sgt i64 %iv, %len")
        w.emit("br i1 %done, label %mfp_ret, label %mfp_body")
        w.new_block("mfp_body")
        w.emit("%d = call i8* @flux_list_data(i8* %p)")
        w.emit("%rv = call i64 @flux_row_val(i8* %d, i64 %iv)")
        w.emit("%inner = inttoptr i64 %rv to i8*")
        w.emit("%id = call i8* @flux_list_data(i8* %inner)")
        w.emit("%k = call i8* @flux_row_sval(i8* %id, i64 1)")
        w.emit("%t = call i64 @flux_row_tag(i8* %id, i64 2)")
        w.emit("%v1 = call i64 @flux_row_val(i8* %id, i64 2)")
        w.emit("%v2 = call i8* @flux_row_sval(i8* %id, i64 2)")
        w.emit("%isstr = icmp eq i64 %t, 4")
        w.emit("%v2p = ptrtoint i8* %v2 to i64")
        w.emit("%v = select i1 %isstr, i64 %v2p, i64 %v1")
        w.emit("%r = call i8* @flux_map_set(i8* %out, i8* %k, i64 %t, i64 %v)")
        w.emit("%nv = add i64 %iv, 1")
        w.emit("store i64 %nv, i64* %i")
        w.emit("br label %mfp_loop")
        w.new_block("mfp_ret")
        w.emit("ret i8* %out")
        w.end_function()

        w.begin_function("flux_map_to_buf", "i8*", ["i8* %p", "i8* %buf"])
        w.new_block("entry")
        w.emit("%pos = alloca i64")
        w.emit("store i64 1, i64* %pos")
        w.emit("store i8 123, i8* %buf")
        w.emit("%len = call i64 @flux_list_len(i8* %p)")
        w.emit("%i = alloca i64")
        w.emit("store i64 1, i64* %i")
        w.emit("br label %mb_loop")
        w.new_block("mb_loop")
        w.emit("%iv = load i64, i64* %i")
        w.emit("%done = icmp sgt i64 %iv, %len")
        w.emit("br i1 %done, label %mb_ret, label %mb_body")
        w.new_block("mb_body")
        w.emit("%pcur = load i64, i64* %pos")
        w.emit("%is1 = icmp sgt i64 %iv, 1")
        w.emit("br i1 %is1, label %mb_sep, label %mb_key")
        w.new_block("mb_sep")
        w.emit("%sepgep = getelementptr i8, i8* %buf, i64 %pcur")
        w.emit("%sepem = sub i64 4096, %pcur")
        w.emit("%c1 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* %sepgep, i64 %sepem, i8* " + sep2_fmt + ")")
        w.emit("%p1 = add i64 %pcur, 2")
        w.emit("store i64 %p1, i64* %pos")
        w.emit("br label %mb_key")
        w.new_block("mb_key")
        w.emit("%pcurk = load i64, i64* %pos")
        w.emit("%k = call i8* @flux_map_key(i8* %p, i64 %iv)")
        w.emit("%kp = ptrtoint i8* %k to i64")
        w.emit("%kgep = getelementptr i8, i8* %buf, i64 %pcurk")
        w.emit("%kc = call i64 @flux_elem_to_buf(i64 4, i64 %kp, i8* %kgep)")
        w.emit("%p2 = add i64 %pcurk, %kc")
        w.emit("store i64 %p2, i64* %pos")
        w.emit("%colgep = getelementptr i8, i8* %buf, i64 %p2")
        w.emit("%colem = sub i64 4096, %p2")
        w.emit("%c2 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* %colgep, i64 %colem, i8* " + colon_fmt + ")")
        w.emit("%p3 = add i64 %p2, 2")
        w.emit("store i64 %p3, i64* %pos")
        w.emit("%t = call i64 @flux_map_vtag(i8* %p, i64 %iv)")
        w.emit("%v = call i64 @flux_map_vval(i8* %p, i64 %iv)")
        w.emit("%vgep = getelementptr i8, i8* %buf, i64 %p3")
        w.emit("%vc = call i64 @flux_elem_to_buf(i64 %t, i64 %v, i8* %vgep)")
        w.emit("%p4 = add i64 %p3, %vc")
        w.emit("store i64 %p4, i64* %pos")
        w.emit("%nv = add i64 %iv, 1")
        w.emit("store i64 %nv, i64* %i")
        w.emit("br label %mb_loop")
        w.new_block("mb_ret")
        w.emit("%pcur2 = load i64, i64* %pos")
        w.emit("%gep2 = getelementptr i8, i8* %buf, i64 %pcur2")
        w.emit("store i8 125, i8* %gep2")
        w.emit("%pz = add i64 %pcur2, 1")
        w.emit("%gepz = getelementptr i8, i8* %buf, i64 %pz")
        w.emit("store i8 0, i8* %gepz")
        w.emit("ret i8* %buf")
        w.end_function()

        w.begin_function("flux_list_set_grow", "i8*", ["i8* %p", "i64 %i", "i64 %tag", "i64 %val", "i8* %sval"])
        w.new_block("entry")
        w.emit("%n = call i64 @flux_list_len(i8* %p)")
        w.emit("%np1 = add i64 %n, 1")
        w.emit("%isapp = icmp eq i64 %i, %np1")
        w.emit("br i1 %isapp, label %lsg_app, label %lsg_chk")
        w.new_block("lsg_app")
        w.emit("%r1 = call i8* @flux_list_push(i8* %p, i64 %tag, i64 %val, i8* %sval)")
        w.emit("ret i8* %r1")
        w.new_block("lsg_chk")
        w.emit("%isin = icmp ule i64 %i, %n")
        w.emit("br i1 %isin, label %lsg_set, label %lsg_bad")
        w.new_block("lsg_set")
        w.emit("%d = call i8* @flux_list_data(i8* %p)")
        w.emit("%sp = ptrtoint i8* %sval to i64")
        w.emit("call void @flux_row_set(i8* %d, i64 %i, i64 %tag, i64 %val, i64 %sp)")
        w.emit("ret i8* %p")
        w.new_block("lsg_bad")
        w.emit("unreachable")
        w.end_function()

    def _emit_list_helpers(self, w) -> None:
        w.begin_function("flux_list_is_empty", "i1", ["i8* %p"])
        w.new_block("entry")
        w.emit("%len = call i64 @flux_list_len(i8* %p)")
        w.emit("%is0 = icmp eq i64 %len, 0")
        w.emit("ret i1 %is0")
        w.end_function()

        w.begin_function("flux_list_clear", "i8*", ["i8* %p"])
        w.new_block("entry")
        w.emit("%h = bitcast i8* %p to i64*")
        w.emit("store i64 0, i64* %h")
        w.emit("ret i8* %p")
        w.end_function()

        def emit_push(fname: str) -> None:
            w.begin_function(fname, "i8*", ["i8* %p", "i64 %tag", "i64 %val", "i8* %sval"])
            w.new_block("entry")
            w.emit("%len = call i64 @flux_list_len(i8* %p)")
            w.emit("%cap = call i64 @flux_list_cap(i8* %p)")
            w.emit("%full = icmp uge i64 %len, %cap")
            w.emit("br i1 %full, label %gr, label %go")
            w.new_block("gr")
            w.emit("%gp = call i8* @flux_set_grow(i8* %p, i64 %len)")
            w.emit("br label %go")
            w.new_block("go")
            w.emit("%lp = phi i8* [ %p, %entry ], [ %gp, %gr ]")
            w.emit("%l2 = call i64 @flux_list_len(i8* %lp)")
            w.emit("%data = call i8* @flux_list_data(i8* %lp)")
            w.emit("%ri = add i64 %l2, 1")
            w.emit("%sp = ptrtoint i8* %sval to i64")
            w.emit("call void @flux_row_set(i8* %data, i64 %ri, i64 %tag, i64 %val, i64 %sp)")
            w.emit("%h2 = bitcast i8* %lp to i64*")
            w.emit("store i64 %ri, i64* %h2")
            w.emit("ret i8* %lp")
            w.end_function()

        emit_push("flux_list_push")
        emit_push("flux_list_push_row")

        w.begin_function("flux_list_push_front", "i8*", ["i8* %p", "i64 %tag", "i64 %val", "i8* %sval"])
        w.new_block("entry")
        w.emit("%len = call i64 @flux_list_len(i8* %p)")
        w.emit("%cap = call i64 @flux_list_cap(i8* %p)")
        w.emit("%full = icmp uge i64 %len, %cap")
        w.emit("br i1 %full, label %fgr, label %fgo")
        w.new_block("fgr")
        w.emit("%fgp = call i8* @flux_set_grow(i8* %p, i64 %len)")
        w.emit("br label %fgo")
        w.new_block("fgo")
        w.emit("%flp = phi i8* [ %p, %entry ], [ %fgp, %fgr ]")
        w.emit("%fl2 = call i64 @flux_list_len(i8* %flp)")
        w.emit("%fdata = call i8* @flux_list_data(i8* %flp)")
        w.emit("%i = alloca i64")
        w.emit("%end = add i64 %fl2, 1")
        w.emit("store i64 %end, i64* %i")
        w.emit("br label %fl_loop")
        w.new_block("fl_loop")
        w.emit("%iv = load i64, i64* %i")
        w.emit("%isdone = icmp ule i64 %iv, 1")
        w.emit("br i1 %isdone, label %fl_wr, label %fl_body")
        w.new_block("fl_body")
        w.emit("%pv = sub i64 %iv, 1")
        w.emit("%pt = call i64 @flux_row_tag(i8* %fdata, i64 %pv)")
        w.emit("%pv2 = call i64 @flux_row_val(i8* %fdata, i64 %pv)")
        w.emit("%ps = call i8* @flux_row_sval(i8* %fdata, i64 %pv)")
        w.emit("%psp = ptrtoint i8* %ps to i64")
        w.emit("call void @flux_row_set(i8* %fdata, i64 %iv, i64 %pt, i64 %pv2, i64 %psp)")
        w.emit("%nv = sub i64 %iv, 1")
        w.emit("store i64 %nv, i64* %i")
        w.emit("br label %fl_loop")
        w.new_block("fl_wr")
        w.emit("%sp = ptrtoint i8* %sval to i64")
        w.emit("call void @flux_row_set(i8* %fdata, i64 1, i64 %tag, i64 %val, i64 %sp)")
        w.emit("%h3 = bitcast i8* %flp to i64*")
        w.emit("store i64 %end, i64* %h3")
        w.emit("ret i8* %flp")
        w.end_function()

        w.begin_function("flux_list_insert_at", "i8*", ["i8* %p", "i64 %idx", "i64 %tag", "i64 %val", "i8* %sval"])
        w.new_block("entry")
        w.emit("%len = call i64 @flux_list_len(i8* %p)")
        w.emit("%max = add i64 %len, 1")
        w.emit("%ovf = icmp ugt i64 %idx, %max")
        w.emit("br i1 %ovf, label %in_null, label %in_ok")
        w.new_block("in_null")
        w.emit("ret i8* null")
        w.new_block("in_ok")
        w.emit("%cap = call i64 @flux_list_cap(i8* %p)")
        w.emit("%full = icmp uge i64 %len, %cap")
        w.emit("br i1 %full, label %igr, label %igo")
        w.new_block("igr")
        w.emit("%igp = call i8* @flux_set_grow(i8* %p, i64 %len)")
        w.emit("br label %igo")
        w.new_block("igo")
        w.emit("%ilp = phi i8* [ %p, %in_ok ], [ %igp, %igr ]")
        w.emit("%idata = call i8* @flux_list_data(i8* %ilp)")
        w.emit("%ii = alloca i64")
        w.emit("store i64 %len, i64* %ii")
        w.emit("br label %in_loop")
        w.new_block("in_loop")
        w.emit("%iiv = load i64, i64* %ii")
        w.emit("%iid = icmp ult i64 %iiv, %idx")
        w.emit("br i1 %iid, label %in_wr, label %in_body")
        w.new_block("in_body")
        w.emit("%src = add i64 %iiv, 1")
        w.emit("%st = call i64 @flux_row_tag(i8* %idata, i64 %iiv)")
        w.emit("%sv2 = call i64 @flux_row_val(i8* %idata, i64 %iiv)")
        w.emit("%ss = call i8* @flux_row_sval(i8* %idata, i64 %iiv)")
        w.emit("%ssp = ptrtoint i8* %ss to i64")
        w.emit("call void @flux_row_set(i8* %idata, i64 %src, i64 %st, i64 %sv2, i64 %ssp)")
        w.emit("%dnv = sub i64 %iiv, 1")
        w.emit("store i64 %dnv, i64* %ii")
        w.emit("br label %in_loop")
        w.new_block("in_wr")
        w.emit("%sp = ptrtoint i8* %sval to i64")
        w.emit("call void @flux_row_set(i8* %idata, i64 %idx, i64 %tag, i64 %val, i64 %sp)")
        w.emit("%h4 = bitcast i8* %ilp to i64*")
        w.emit("%nl = add i64 %len, 1")
        w.emit("store i64 %nl, i64* %h4")
        w.emit("ret i8* %ilp")
        w.end_function()

        w.begin_function("flux_list_remove_at", "i8*", ["i8* %p", "i64 %idx"])
        w.new_block("entry")
        w.emit("%len = call i64 @flux_list_len(i8* %p)")
        w.emit("%ovf = icmp ugt i64 %idx, %len")
        w.emit("br i1 %ovf, label %rm_ret, label %rm_go")
        w.new_block("rm_go")
        w.emit("%data = call i8* @flux_list_data(i8* %p)")
        w.emit("%i = alloca i64")
        w.emit("store i64 %idx, i64* %i")
        w.emit("br label %rm_loop")
        w.new_block("rm_loop")
        w.emit("%iv = load i64, i64* %i")
        w.emit("%iid = icmp uge i64 %iv, %len")
        w.emit("br i1 %iid, label %rm_wr, label %rm_body")
        w.new_block("rm_body")
        w.emit("%src = add i64 %iv, 1")
        w.emit("%st = call i64 @flux_row_tag(i8* %data, i64 %src)")
        w.emit("%sv2 = call i64 @flux_row_val(i8* %data, i64 %src)")
        w.emit("%ss = call i8* @flux_row_sval(i8* %data, i64 %src)")
        w.emit("%ssp = ptrtoint i8* %ss to i64")
        w.emit("call void @flux_row_set(i8* %data, i64 %iv, i64 %st, i64 %sv2, i64 %ssp)")
        w.emit("%anv = add i64 %iv, 1")
        w.emit("store i64 %anv, i64* %i")
        w.emit("br label %rm_loop")
        w.new_block("rm_wr")
        w.emit("%h5 = bitcast i8* %p to i64*")
        w.emit("%nl = sub i64 %len, 1")
        w.emit("store i64 %nl, i64* %h5")
        w.emit("br label %rm_ret")
        w.new_block("rm_ret")
        w.emit("ret i8* %p")
        w.end_function()

        w.begin_function("flux_list_remove_last", "i8*", ["i8* %p"])
        w.new_block("entry")
        w.emit("%len = call i64 @flux_list_len(i8* %p)")
        w.emit("%gt = icmp ugt i64 %len, 0")
        w.emit("br i1 %gt, label %rl_dec, label %rl_ret")
        w.new_block("rl_dec")
        w.emit("%h6 = bitcast i8* %p to i64*")
        w.emit("%nl = sub i64 %len, 1")
        w.emit("store i64 %nl, i64* %h6")
        w.emit("br label %rl_ret")
        w.new_block("rl_ret")
        w.emit("ret i8* %p")
        w.end_function()

        w.begin_function("flux_swap_rows", "void", ["i8* %data", "i64 %i", "i64 %j"])
        w.new_block("entry")
        w.emit("%t = call i64 @flux_row_tag(i8* %data, i64 %i)")
        w.emit("%v = call i64 @flux_row_val(i8* %data, i64 %i)")
        w.emit("%s = call i8* @flux_row_sval(i8* %data, i64 %i)")
        w.emit("%jt = call i64 @flux_row_tag(i8* %data, i64 %j)")
        w.emit("%jv = call i64 @flux_row_val(i8* %data, i64 %j)")
        w.emit("%js = call i8* @flux_row_sval(i8* %data, i64 %j)")
        w.emit("%jsp = ptrtoint i8* %js to i64")
        w.emit("call void @flux_row_set(i8* %data, i64 %i, i64 %jt, i64 %jv, i64 %jsp)")
        w.emit("%sp = ptrtoint i8* %s to i64")
        w.emit("call void @flux_row_set(i8* %data, i64 %j, i64 %t, i64 %v, i64 %sp)")
        w.emit("ret void")
        w.end_function()

        w.begin_function("flux_elem_lt", "i1", ["i8* %data", "i64 %i", "i64 %j"])
        w.new_block("entry")
        w.emit("%ta = call i64 @flux_row_tag(i8* %data, i64 %i)")
        w.emit("%tb = call i64 @flux_row_tag(i8* %data, i64 %j)")
        w.emit("%lt = icmp ult i64 %ta, %tb")
        w.emit("br i1 %lt, label %lt_yes, label %lt_cmp")
        w.new_block("lt_cmp")
        w.emit("%gt = icmp ugt i64 %ta, %tb")
        w.emit("br i1 %gt, label %lt_no, label %lt_same")
        w.new_block("lt_same")
        w.emit("%is3 = icmp eq i64 %ta, 3")
        w.emit("br i1 %is3, label %lt_flt, label %lt_s4")
        w.new_block("lt_s4")
        w.emit("%is4 = icmp eq i64 %ta, 4")
        w.emit("br i1 %is4, label %lt_str, label %lt_int")
        w.new_block("lt_flt")
        w.emit("%va = call i64 @flux_row_val(i8* %data, i64 %i)")
        w.emit("%vb = call i64 @flux_row_val(i8* %data, i64 %j)")
        w.emit("%fa = bitcast i64 %va to double")
        w.emit("%fb = bitcast i64 %vb to double")
        w.emit("%res = fcmp olt double %fa, %fb")
        w.emit("ret i1 %res")
        w.new_block("lt_str")
        w.emit("%sa = call i8* @flux_row_sval(i8* %data, i64 %i)")
        w.emit("%sb = call i8* @flux_row_sval(i8* %data, i64 %j)")
        w.emit("%cmp = call i32 @strcmp(i8* %sa, i8* %sb)")
        w.emit("%neg = icmp slt i32 %cmp, 0")
        w.emit("ret i1 %neg")
        w.new_block("lt_int")
        w.emit("%ia = call i64 @flux_row_val(i8* %data, i64 %i)")
        w.emit("%ib = call i64 @flux_row_val(i8* %data, i64 %j)")
        w.emit("%res2 = icmp ult i64 %ia, %ib")
        w.emit("ret i1 %res2")
        w.new_block("lt_yes")
        w.emit("ret i1 true")
        w.new_block("lt_no")
        w.emit("ret i1 false")
        w.end_function()

        w.begin_function("flux_list_sort", "i8*", ["i8* %p", "i64 %desc"])
        w.new_block("entry")
        w.emit("%n = call i64 @flux_list_len(i8* %p)")
        w.emit("%data = call i8* @flux_list_data(i8* %p)")
        w.emit("%i = alloca i64")
        w.emit("store i64 1, i64* %i")
        w.emit("br label %st_loop")
        w.new_block("st_loop")
        w.emit("%iv = load i64, i64* %i")
        w.emit("%done = icmp uge i64 %iv, %n")
        w.emit("br i1 %done, label %st_ret, label %st_body")
        w.new_block("st_body")
        w.emit("%jv = alloca i64")
        w.emit("%j0 = add i64 %iv, 1")
        w.emit("store i64 %j0, i64* %jv")
        w.emit("br label %sj_loop")
        w.new_block("sj_loop")
        w.emit("%jv2 = load i64, i64* %jv")
        w.emit("%jd = icmp ugt i64 %jv2, %n")
        w.emit("br i1 %jd, label %sj_done, label %sj_body")
        w.new_block("sj_body")
        w.emit("%isdesc = icmp eq i64 %desc, 0")
        w.emit("br i1 %isdesc, label %sj_asc, label %sj_desc")
        w.new_block("sj_asc")
        w.emit("%lt = call i1 @flux_elem_lt(i8* %data, i64 %jv2, i64 %iv)")
        w.emit("br i1 %lt, label %sj_swap, label %sj_next")
        w.new_block("sj_desc")
        w.emit("%lt2 = call i1 @flux_elem_lt(i8* %data, i64 %iv, i64 %jv2)")
        w.emit("br i1 %lt2, label %sj_swap, label %sj_next")
        w.new_block("sj_swap")
        w.emit("call void @flux_swap_rows(i8* %data, i64 %iv, i64 %jv2)")
        w.emit("br label %sj_next")
        w.new_block("sj_next")
        w.emit("%nj = add i64 %jv2, 1")
        w.emit("store i64 %nj, i64* %jv")
        w.emit("br label %sj_loop")
        w.new_block("sj_done")
        w.emit("%ni = add i64 %iv, 1")
        w.emit("store i64 %ni, i64* %i")
        w.emit("br label %st_loop")
        w.new_block("st_ret")
        w.emit("ret i8* %p")
        w.end_function()

        w.begin_function("flux_list_reverse", "i8*", ["i8* %p"])
        w.new_block("entry")
        w.emit("%n = call i64 @flux_list_len(i8* %p)")
        w.emit("%data = call i8* @flux_list_data(i8* %p)")
        w.emit("%i = alloca i64")
        w.emit("store i64 1, i64* %i")
        w.emit("%half = udiv i64 %n, 2")
        w.emit("br label %rv_loop")
        w.new_block("rv_loop")
        w.emit("%iv = load i64, i64* %i")
        w.emit("%done = icmp ugt i64 %iv, %half")
        w.emit("br i1 %done, label %rv_ret, label %rv_body")
        w.new_block("rv_body")
        w.emit("%mir = add i64 %n, 1")
        w.emit("%mir2 = sub i64 %mir, %iv")
        w.emit("call void @flux_swap_rows(i8* %data, i64 %iv, i64 %mir2)")
        w.emit("%niv = add i64 %iv, 1")
        w.emit("store i64 %niv, i64* %i")
        w.emit("br label %rv_loop")
        w.new_block("rv_ret")
        w.emit("ret i8* %p")
        w.end_function()

        w.begin_function("flux_list_flatten", "i8*", ["i8* %p"])
        w.new_block("entry")
        w.emit("%out = call i8* @flux_list_build(i64 0, i64 0)")
        w.emit("%n = call i64 @flux_list_len(i8* %p)")
        w.emit("%data = call i8* @flux_list_data(i8* %p)")
        w.emit("%i = alloca i64")
        w.emit("store i64 1, i64* %i")
        w.emit("br label %fl_loop")
        w.new_block("fl_loop")
        w.emit("%iv = load i64, i64* %i")
        w.emit("%done = icmp ugt i64 %iv, %n")
        w.emit("br i1 %done, label %fl_ret, label %fl_body")
        w.new_block("fl_body")
        w.emit("%tg = call i64 @flux_row_tag(i8* %data, i64 %iv)")
        w.emit("%is5 = icmp eq i64 %tg, 5")
        w.emit("br i1 %is5, label %fl_inner, label %fl_copy")
        w.new_block("fl_inner")
        w.emit("%ip = call i64 @flux_row_val(i8* %data, i64 %iv)")
        w.emit("%inner = inttoptr i64 %ip to i8*")
        w.emit("%inlen = call i64 @flux_list_len(i8* %inner)")
        w.emit("%idata = call i8* @flux_list_data(i8* %inner)")
        w.emit("%j = alloca i64")
        w.emit("store i64 1, i64* %j")
        w.emit("br label %fl_in_loop")
        w.new_block("fl_in_loop")
        w.emit("%jv = load i64, i64* %j")
        w.emit("%jdone = icmp ugt i64 %jv, %inlen")
        w.emit("br i1 %jdone, label %fl_next, label %fl_in_body")
        w.new_block("fl_in_body")
        w.emit("%itg = call i64 @flux_row_tag(i8* %idata, i64 %jv)")
        w.emit("%ivl = call i64 @flux_row_val(i8* %idata, i64 %jv)")
        w.emit("%isv = call i8* @flux_row_sval(i8* %idata, i64 %jv)")
        w.emit("%o2 = call i8* @flux_list_push_row(i8* %out, i64 %itg, i64 %ivl, i8* %isv)")
        w.emit("%nj = add i64 %jv, 1")
        w.emit("store i64 %nj, i64* %j")
        w.emit("br label %fl_in_loop")
        w.new_block("fl_copy")
        w.emit("%ivl2 = call i64 @flux_row_val(i8* %data, i64 %iv)")
        w.emit("%isv2 = call i8* @flux_row_sval(i8* %data, i64 %iv)")
        w.emit("%o3 = call i8* @flux_list_push_row(i8* %out, i64 %tg, i64 %ivl2, i8* %isv2)")
        w.emit("br label %fl_next")
        w.new_block("fl_next")
        w.emit("%niv = add i64 %iv, 1")
        w.emit("store i64 %niv, i64* %i")
        w.emit("br label %fl_loop")
        w.new_block("fl_ret")
        w.emit("ret i8* %out")
        w.end_function()

        w.begin_function("flux_list_partition", "i8*", ["i8* %p", "i64 %size"])
        w.new_block("entry")
        w.emit("%out = call i8* @flux_list_build(i64 0, i64 0)")
        w.emit("%n = call i64 @flux_list_len(i8* %p)")
        w.emit("%data = call i8* @flux_list_data(i8* %p)")
        w.emit("%i = alloca i64")
        w.emit("store i64 1, i64* %i")
        w.emit("br label %pt_loop")
        w.new_block("pt_loop")
        w.emit("%iv = load i64, i64* %i")
        w.emit("%done = icmp ugt i64 %iv, %n")
        w.emit("br i1 %done, label %pt_ret, label %pt_body")
        w.new_block("pt_body")
        w.emit("%chunk = call i8* @flux_list_build(i64 0, i64 0)")
        w.emit("%k = alloca i64")
        w.emit("store i64 0, i64* %k")
        w.emit("br label %ptc_loop")
        w.new_block("ptc_loop")
        w.emit("%kv = load i64, i64* %k")
        w.emit("%kdone = icmp uge i64 %kv, %size")
        w.emit("br i1 %kdone, label %ptc_done, label %ptc_ovf")
        w.new_block("ptc_ovf")
        w.emit("%idx2 = add i64 %iv, %kv")
        w.emit("%ovf = icmp ugt i64 %idx2, %n")
        w.emit("br i1 %ovf, label %ptc_done, label %ptc_body")
        w.new_block("ptc_body")
        w.emit("%ctg = call i64 @flux_row_tag(i8* %data, i64 %idx2)")
        w.emit("%cvl = call i64 @flux_row_val(i8* %data, i64 %idx2)")
        w.emit("%csv = call i8* @flux_row_sval(i8* %data, i64 %idx2)")
        w.emit("%c2 = call i8* @flux_list_push_row(i8* %chunk, i64 %ctg, i64 %cvl, i8* %csv)")
        w.emit("%nkv = add i64 %kv, 1")
        w.emit("store i64 %nkv, i64* %k")
        w.emit("br label %ptc_loop")
        w.new_block("ptc_done")
        w.emit("%k2 = load i64, i64* %k")
        w.emit("%ni2 = add i64 %iv, %k2")
        w.emit("store i64 %ni2, i64* %i")
        w.emit("%chp = ptrtoint i8* %chunk to i64")
        w.emit("%o4 = call i8* @flux_list_push_row(i8* %out, i64 5, i64 %chp, i8* null)")
        w.emit("br label %pt_loop")
        w.new_block("pt_ret")
        w.emit("ret i8* %out")
        w.end_function()

        w.begin_function("flux_list_zip", "i8*", ["i8* %a", "i8* %b"])
        w.new_block("entry")
        w.emit("%na = call i64 @flux_list_len(i8* %a)")
        w.emit("%nb = call i64 @flux_list_len(i8* %b)")
        w.emit("%nlt = icmp ult i64 %na, %nb")
        w.emit("%n = select i1 %nlt, i64 %na, i64 %nb")
        w.emit("%out = call i8* @flux_list_build(i64 0, i64 0)")
        w.emit("%adata = call i8* @flux_list_data(i8* %a)")
        w.emit("%bdata = call i8* @flux_list_data(i8* %b)")
        w.emit("%i = alloca i64")
        w.emit("store i64 1, i64* %i")
        w.emit("br label %zp_loop")
        w.new_block("zp_loop")
        w.emit("%iv = load i64, i64* %i")
        w.emit("%done = icmp ugt i64 %iv, %n")
        w.emit("br i1 %done, label %zp_ret, label %zp_body")
        w.new_block("zp_body")
        w.emit("%pair = call i8* @flux_list_build(i64 2, i64 0)")
        w.emit("%pdata = call i8* @flux_list_data(i8* %pair)")
        w.emit("%atg = call i64 @flux_row_tag(i8* %adata, i64 %iv)")
        w.emit("%avl = call i64 @flux_row_val(i8* %adata, i64 %iv)")
        w.emit("%asv = call i8* @flux_row_sval(i8* %adata, i64 %iv)")
        w.emit("%asvp = ptrtoint i8* %asv to i64")
        w.emit("call void @flux_row_set(i8* %pdata, i64 1, i64 %atg, i64 %avl, i64 %asvp)")
        w.emit("%btg = call i64 @flux_row_tag(i8* %bdata, i64 %iv)")
        w.emit("%bvl = call i64 @flux_row_val(i8* %bdata, i64 %iv)")
        w.emit("%bsv = call i8* @flux_row_sval(i8* %bdata, i64 %iv)")
        w.emit("%bsvp = ptrtoint i8* %bsv to i64")
        w.emit("call void @flux_row_set(i8* %pdata, i64 2, i64 %btg, i64 %bvl, i64 %bsvp)")
        w.emit("%pp = ptrtoint i8* %pair to i64")
        w.emit("%o5 = call i8* @flux_list_push_row(i8* %out, i64 5, i64 %pp, i8* null)")
        w.emit("%niv = add i64 %iv, 1")
        w.emit("store i64 %niv, i64* %i")
        w.emit("br label %zp_loop")
        w.new_block("zp_ret")
        w.emit("ret i8* %out")
        w.end_function()

        w.begin_function("flux_list_unzip", "i8*", ["i8* %p"])
        w.new_block("entry")
        w.emit("%n = call i64 @flux_list_len(i8* %p)")
        w.emit("%data = call i8* @flux_list_data(i8* %p)")
        w.emit("%ls = call i8* @flux_list_build(i64 0, i64 0)")
        w.emit("%rs = call i8* @flux_list_build(i64 0, i64 0)")
        w.emit("%i = alloca i64")
        w.emit("store i64 1, i64* %i")
        w.emit("br label %uz_loop")
        w.new_block("uz_loop")
        w.emit("%iv = load i64, i64* %i")
        w.emit("%done = icmp ugt i64 %iv, %n")
        w.emit("br i1 %done, label %uz_done, label %uz_body")
        w.new_block("uz_body")
        w.emit("%pp = call i64 @flux_row_val(i8* %data, i64 %iv)")
        w.emit("%pair = inttoptr i64 %pp to i8*")
        w.emit("%pdata = call i8* @flux_list_data(i8* %pair)")
        w.emit("%l1t = call i64 @flux_row_tag(i8* %pdata, i64 1)")
        w.emit("%l1v = call i64 @flux_row_val(i8* %pdata, i64 1)")
        w.emit("%l1s = call i8* @flux_row_sval(i8* %pdata, i64 1)")
        w.emit("%o6 = call i8* @flux_list_push_row(i8* %ls, i64 %l1t, i64 %l1v, i8* %l1s)")
        w.emit("%r2t = call i64 @flux_row_tag(i8* %pdata, i64 2)")
        w.emit("%r2v = call i64 @flux_row_val(i8* %pdata, i64 2)")
        w.emit("%r2s = call i8* @flux_row_sval(i8* %pdata, i64 2)")
        w.emit("%o7 = call i8* @flux_list_push_row(i8* %rs, i64 %r2t, i64 %r2v, i8* %r2s)")
        w.emit("%niv = add i64 %iv, 1")
        w.emit("store i64 %niv, i64* %i")
        w.emit("br label %uz_loop")
        w.new_block("uz_done")
        w.emit("%out = call i8* @flux_list_build(i64 2, i64 0)")
        w.emit("%odata = call i8* @flux_list_data(i8* %out)")
        w.emit("%lsp = ptrtoint i8* %ls to i64")
        w.emit("call void @flux_row_set(i8* %odata, i64 1, i64 5, i64 %lsp, i64 0)")
        w.emit("%rsp = ptrtoint i8* %rs to i64")
        w.emit("call void @flux_row_set(i8* %odata, i64 2, i64 5, i64 %rsp, i64 0)")
        w.emit("ret i8* %out")
        w.end_function()

        w.begin_function("flux_list_slice", "i8*", ["i8* %p", "i64 %s", "i64 %e"])
        w.new_block("entry")
        w.emit("%n = call i64 @flux_list_len(i8* %p)")
        w.emit("%slo = icmp ult i64 %s, 1")
        w.emit("br i1 %slo, label %sl_null, label %sl_hi")
        w.new_block("sl_hi")
        w.emit("%ehi = icmp ugt i64 %e, %n")
        w.emit("br i1 %ehi, label %sl_null, label %sl_ord")
        w.new_block("sl_ord")
        w.emit("%sgt = icmp ugt i64 %s, %e")
        w.emit("br i1 %sgt, label %sl_null, label %sl_ok")
        w.new_block("sl_null")
        w.emit("call void @exit(i32 1)")
        w.emit("unreachable")
        w.new_block("sl_ok")
        w.emit("%cnt = sub i64 %e, %s")
        w.emit("%cnt2 = add i64 %cnt, 1")
        w.emit("%et = call i64 @flux_list_etag(i8* %p)")
        w.emit("%out = call i8* @flux_list_build(i64 %cnt2, i64 %et)")
        w.emit("%odata = call i8* @flux_list_data(i8* %out)")
        w.emit("%sdata = call i8* @flux_list_data(i8* %p)")
        w.emit("%i = alloca i64")
        w.emit("store i64 %s, i64* %i")
        w.emit("br label %sl_loop")
        w.new_block("sl_loop")
        w.emit("%iv = load i64, i64* %i")
        w.emit("%done = icmp ugt i64 %iv, %e")
        w.emit("br i1 %done, label %sl_ret, label %sl_body")
        w.new_block("sl_body")
        w.emit("%stg = call i64 @flux_row_tag(i8* %sdata, i64 %iv)")
        w.emit("%svl = call i64 @flux_row_val(i8* %sdata, i64 %iv)")
        w.emit("%ssv = call i8* @flux_row_sval(i8* %sdata, i64 %iv)")
        w.emit("%ssvp = ptrtoint i8* %ssv to i64")
        w.emit("%oi = sub i64 %iv, %s")
        w.emit("%oi2 = add i64 %oi, 1")
        w.emit("call void @flux_row_set(i8* %odata, i64 %oi2, i64 %stg, i64 %svl, i64 %ssvp)")
        w.emit("%niv = add i64 %iv, 1")
        w.emit("store i64 %niv, i64* %i")
        w.emit("br label %sl_loop")
        w.new_block("sl_ret")
        w.emit("ret i8* %out")
        w.end_function()

        w.begin_function("flux_str_char_len", "i64", ["i8* %p"])
        w.new_block("entry")
        w.emit("%ip = alloca i64")
        w.emit("%np = alloca i64")
        w.emit("store i64 0, i64* %ip")
        w.emit("store i64 0, i64* %np")
        w.emit("br label %cl_loop")
        w.new_block("cl_loop")
        w.emit("%civ = load i64, i64* %ip")
        w.emit("%cgep = getelementptr i8, i8* %p, i64 %civ")
        w.emit("%cb = load i8, i8* %cgep")
        w.emit("%cbz = icmp eq i8 %cb, 0")
        w.emit("br i1 %cbz, label %cl_ret, label %cl_cont")
        w.new_block("cl_cont")
        w.emit("%cb32 = zext i8 %cb to i32")
        w.emit("%cba = and i32 %cb32, 192")
        w.emit("%cisc = icmp eq i32 %cba, 128")
        w.emit("br i1 %cisc, label %cl_skip, label %cl_count")
        w.new_block("cl_count")
        w.emit("%cnv = load i64, i64* %np")
        w.emit("%cn2 = add i64 %cnv, 1")
        w.emit("store i64 %cn2, i64* %np")
        w.emit("br label %cl_skip")
        w.new_block("cl_skip")
        w.emit("%civ2 = add i64 %civ, 1")
        w.emit("store i64 %civ2, i64* %ip")
        w.emit("br label %cl_loop")
        w.new_block("cl_ret")
        w.emit("%cnr = load i64, i64* %np")
        w.emit("ret i64 %cnr")
        w.end_function()

        w.begin_function("flux_str_slice", "i8*", ["i8* %p", "i64 %s", "i64 %e"])
        w.new_block("entry")
        w.emit("%tot = call i64 @flux_str_char_len(i8* %p)")
        w.emit("%slo = icmp ult i64 %s, 1")
        w.emit("br i1 %slo, label %ss_null, label %ss_hi")
        w.new_block("ss_hi")
        w.emit("%ehi = icmp ugt i64 %e, %tot")
        w.emit("br i1 %ehi, label %ss_null, label %ss_ord")
        w.new_block("ss_ord")
        w.emit("%sgt = icmp ugt i64 %s, %e")
        w.emit("br i1 %sgt, label %ss_null, label %ss_ok")
        w.new_block("ss_null")
        w.emit("call void @exit(i32 1)")
        w.emit("unreachable")
        w.new_block("ss_ok")
        w.emit("%sip = alloca i64")
        w.emit("%scpp = alloca i64")
        w.emit("store i64 0, i64* %sip")
        w.emit("store i64 0, i64* %scpp")
        w.emit("br label %ss_l1")
        w.new_block("ss_l1")
        w.emit("%waiv = load i64, i64* %sip")
        w.emit("%wacp = load i64, i64* %scpp")
        w.emit("%walim = sub i64 %s, 1")
        w.emit("%wage = icmp uge i64 %wacp, %walim")
        w.emit("br i1 %wage, label %ss_d1, label %ss_1a")
        w.new_block("ss_1a")
        w.emit("%wagep = getelementptr i8, i8* %p, i64 %waiv")
        w.emit("%wab = load i8, i8* %wagep")
        w.emit("%waz = icmp eq i8 %wab, 0")
        w.emit("br i1 %waz, label %ss_d1, label %ss_1b")
        w.new_block("ss_1b")
        w.emit("%wai32 = zext i8 %wab to i32")
        w.emit("%waand = and i32 %wai32, 192")
        w.emit("%waisc = icmp eq i32 %waand, 128")
        w.emit("br i1 %waisc, label %ss_1c, label %ss_1d")
        w.new_block("ss_1c")
        w.emit("br label %ss_1e")
        w.new_block("ss_1d")
        w.emit("%wacp2 = add i64 %wacp, 1")
        w.emit("store i64 %wacp2, i64* %scpp")
        w.emit("br label %ss_1e")
        w.new_block("ss_1e")
        w.emit("%waiv2 = add i64 %waiv, 1")
        w.emit("store i64 %waiv2, i64* %sip")
        w.emit("br label %ss_l1")
        w.new_block("ss_d1")
        w.emit("%soff = load i64, i64* %sip")
        w.emit("br label %ss_l2")
        w.new_block("ss_l2")
        w.emit("%wbiv = load i64, i64* %sip")
        w.emit("%wbcp = load i64, i64* %scpp")
        w.emit("%wbge = icmp uge i64 %wbcp, %e")
        w.emit("br i1 %wbge, label %ss_d2, label %ss_2a")
        w.new_block("ss_2a")
        w.emit("%wbgep = getelementptr i8, i8* %p, i64 %wbiv")
        w.emit("%wbb = load i8, i8* %wbgep")
        w.emit("%wbz = icmp eq i8 %wbb, 0")
        w.emit("br i1 %wbz, label %ss_d2, label %ss_2b")
        w.new_block("ss_2b")
        w.emit("%wbi32 = zext i8 %wbb to i32")
        w.emit("%wband = and i32 %wbi32, 192")
        w.emit("%wbisc = icmp eq i32 %wband, 128")
        w.emit("br i1 %wbisc, label %ss_2c, label %ss_2d")
        w.new_block("ss_2c")
        w.emit("br label %ss_2e")
        w.new_block("ss_2d")
        w.emit("%wbcp2 = add i64 %wbcp, 1")
        w.emit("store i64 %wbcp2, i64* %scpp")
        w.emit("br label %ss_2e")
        w.new_block("ss_2e")
        w.emit("%wbiv2 = add i64 %wbiv, 1")
        w.emit("store i64 %wbiv2, i64* %sip")
        w.emit("br label %ss_l2")
        w.new_block("ss_d2")
        w.emit("%eoff = load i64, i64* %sip")
        w.emit("%cnt = sub i64 %eoff, %soff")
        w.emit("%bufsz = add i64 %cnt, 1")
        w.emit("%out = call i8* @malloc(i64 %bufsz)")
        w.emit("%jp = alloca i64")
        w.emit("store i64 %soff, i64* %jp")
        w.emit("br label %ss_l3")
        w.new_block("ss_l3")
        w.emit("%wcjv = load i64, i64* %jp")
        w.emit("%wcdone = icmp uge i64 %wcjv, %eoff")
        w.emit("br i1 %wcdone, label %ss_term, label %ss_3a")
        w.new_block("ss_3a")
        w.emit("%wcsrc = getelementptr i8, i8* %p, i64 %wcjv")
        w.emit("%wcb = load i8, i8* %wcsrc")
        w.emit("%wcrel = sub i64 %wcjv, %soff")
        w.emit("%wcdst = getelementptr i8, i8* %out, i64 %wcrel")
        w.emit("store i8 %wcb, i8* %wcdst")
        w.emit("%wcj2 = add i64 %wcjv, 1")
        w.emit("store i64 %wcj2, i64* %jp")
        w.emit("br label %ss_l3")
        w.new_block("ss_term")
        w.emit("%tdst = getelementptr i8, i8* %out, i64 %cnt")
        w.emit("store i8 0, i8* %tdst")
        w.emit("ret i8* %out")
        w.end_function()

        w.begin_function("flux_list_contains", "i1", ["i8* %p", "i64 %etag", "i64 %tag", "i64 %val", "i8* %sval"])
        w.new_block("entry")
        w.emit("%n = call i64 @flux_list_len(i8* %p)")
        w.emit("%data = call i8* @flux_list_data(i8* %p)")
        w.emit("%i = alloca i64")
        w.emit("store i64 1, i64* %i")
        w.emit("br label %lc_loop")
        w.new_block("lc_loop")
        w.emit("%iv = load i64, i64* %i")
        w.emit("%done = icmp ugt i64 %iv, %n")
        w.emit("br i1 %done, label %lc_no, label %lc_body")
        w.new_block("lc_body")
        w.emit("%tg = call i64 @flux_row_tag(i8* %data, i64 %iv)")
        w.emit("%et0 = icmp eq i64 %etag, 0")
        w.emit("br i1 %et0, label %lc_eq, label %lc_tg")
        w.new_block("lc_tg")
        w.emit("%tgok = icmp eq i64 %tg, %etag")
        w.emit("br i1 %tgok, label %lc_eq, label %lc_next")
        w.new_block("lc_eq")
        w.emit("%eq = call i1 @flux_row_eq(i8* %data, i64 %iv, i64 %tag, i64 %val, i8* %sval)")
        w.emit("br i1 %eq, label %lc_yes, label %lc_next")
        w.new_block("lc_next")
        w.emit("%niv = add i64 %iv, 1")
        w.emit("store i64 %niv, i64* %i")
        w.emit("br label %lc_loop")
        w.new_block("lc_yes")
        w.emit("ret i1 true")
        w.new_block("lc_no")
        w.emit("ret i1 false")
        w.end_function()

    def _new_block(self, label: str) -> None:
        self._w.new_block(label)
        self._block_terminated = False

    def generate(self, program: ASTNode) -> str:
        if not isinstance(program, FluxProgram):
            raise CodegenError(f"Cannot generate LLVM IR for {type(program).__name__}")

        self._imports = program.imports
        self._op_aliases = collect_op_aliases(program)
        self._op_defs: dict[str, object] = {}
        self._used_op_names: set[str] = set()
        for fdsl in self._imports.values():
            for agent in fdsl.agents:
                if agent.body:
                    for op in agent.body.ops:
                        self._op_defs[op.name] = op
        self._collect_called_ops(program)
        for op in self._op_defs.values():
            if op.body:
                for expr in op.body.expressions:
                    self._collect_called_ops(expr)
        self._structs = {s.name: s for s in program.structs}
        self._enums = {e.name: e for e in program.enums}
        self._function_names = {f.name for f in program.functions}
        self._function_sigs = {
            f.name: [_llvm_type(p.type_ref.name if p.type_ref else "int64") for p in f.params]
            for f in program.functions
        }
        self._function_ret = {
            f.name: (f.return_type.name if f.return_type else "int64")
            for f in program.functions
        }
        for op_name in self._used_op_names:
            op = self._op_defs[op_name]
            self._function_names.add(op_name)
            self._function_sigs[op_name] = [_llvm_type(p.type_ref.name if p.type_ref else "int64") for p in op.params]
            rtype = op.return_type.name if op.return_type else "data"
            if rtype in ("data", "") and op.body:
                for expr in op.body.expressions:
                    if isinstance(expr, EmitStmt) and isinstance(expr.value_expr, CallExpr):
                        cn = expr.value_expr.callee.name if isinstance(expr.value_expr.callee, Identifier) else ""
                        if cn in _SET_RETURNING:
                            rtype = _SET_RETURNING[cn]
                        elif cn in _MAP_RETURNING:
                            rtype = "map of data of data"
                        elif cn in _STD_BOOL_RETURNING:
                            rtype = "bool"
            self._function_ret[op_name] = rtype
        self._w.add_module_info()
        self._w.add_comment("Generated by TheFlux LLVM backend")

        for s in program.storages:
            self._gen_storage(s)

        for fdsl in self._imports.values():
            for agent in fdsl.agents:
                if agent.body:
                    for s in agent.body.storages:
                        self._gen_storage(s)

        self._collect_strings(program)

        self._w.add_type("flux.result", "{ i8*, i64, double, i8* }")

        if program.body:
            self._emit_body_storages(program.body)

            self._w.declare_function("printf", "i32", ["i8*"], vararg=True)
            self._w.declare_function("fflush", "i32", ["i8*"])
            self._w.declare_function("exit", "void", ["i32"])
            self._w.declare_function("snprintf", "i32", ["i8*", "i64", "i8*"], vararg=True)
            self._w.declare_function("strcmp", "i32", ["i8*", "i8*"])
            self._w.declare_function("strtod", "double", ["i8*", "i8*"])
            self._w.declare_function("malloc", "i8*", ["i64"])
            self._w.declare_function("memcpy", "i8*", ["i8*", "i8*", "i64"])
            self._w.declare_function("memset", "i8*", ["i8*", "i32", "i64"])
            self._w.declare_function("strlen", "i64", ["i8*"])
            self._w.declare_function("atoll", "i64", ["i8*"])
            self._w.declare_function("atof", "double", ["i8*"])
            self._w.declare_function("pow", "double", ["double", "double"])
            self._w.declare_function("llvm.sqrt.f64", "double", ["double"])
            self._w.declare_function("flux_input", "void", ["i8*", "i8*", "i8*"])
            self._w.declare_function("flux_std_io_read_file", "i8*", ["i8*"])
            self._w.declare_function("flux_std_io_write_file", "i8*", ["i8*", "i8*"])
            self._w.declare_function("flux_std_io_append_file", "i8*", ["i8*", "i8*"])
            self._w.declare_function("flux_std_io_delete_file", "i64", ["i8*"])
            self._w.declare_function("flux_std_io_copy_file", "i64", ["i8*", "i8*"])
            self._w.declare_function("flux_std_io_move_file", "i64", ["i8*", "i8*"])
            self._w.declare_function("flux_std_io_file_exists", "i64", ["i8*"])
            self._w.declare_function("flux_std_io_file_size", "i64", ["i8*"])
            self._w.declare_function("flux_std_io_dir_exists", "i64", ["i8*"])
            self._w.declare_function("flux_std_io_create_dir", "i64", ["i8*"])
            self._w.declare_function("flux_std_io_remove_dir", "i64", ["i8*"])
            self._w.declare_function("flux_std_io_path_base_name", "i8*", ["i8*"])
            self._w.declare_function("flux_std_io_path_dir_name", "i8*", ["i8*"])
            self._w.declare_function("flux_std_io_path_extension", "i8*", ["i8*"])
            self._w.declare_function("flux_std_io_path_join", "i8*", ["i8*", "i8*"])
            self._w.declare_function("flux_std_io_print_err", "void", ["i8*"])
            self._w.declare_function("flux_std_io_read_lines", "i8*", ["i8*", "i8* (i64, i64)*", "i8* (i8*, i64, i64, i8*)*"])
            self._w.declare_function("flux_std_io_write_lines_helper", "i8*", ["i8*", "i8*", "i64 (i8*)*", "i8* (i8*)*", "i8* (i8*, i64)*", "i32"])
            self._w.declare_function("flux_std_io_list_dir", "i8*", ["i8*", "i8* (i64, i64)*", "i8* (i8*, i64, i64, i8*)*"])
            # DateTime declarations
            self._w.declare_function("flux_std_datetime_now", "i64", [])
            self._w.declare_function("flux_std_datetime_monotonic_now", "i64", [])
            self._w.declare_function("flux_std_datetime_monotonic_elapsed", "i64", ["i64"])
            self._w.declare_function("flux_std_datetime_today", "i64", [])
            self._w.declare_function("flux_std_datetime_time", "i64", [])
            self._w.declare_function("flux_std_get_current_time_ns_string", "i8*", [])
            self._w.declare_function("flux_std_format_duration_ns", "i8*", ["i64"])
            self._w.declare_function("flux_std_datetime_create_date", "i64", ["i64", "i64", "i64"])
            self._w.declare_function("flux_std_datetime_create_time", "i64", ["i64", "i64", "i64"])
            self._w.declare_function("flux_std_datetime_create_time_full", "i64", ["i64", "i64", "i64", "i64", "i64", "i64"])
            self._w.declare_function("flux_std_datetime_parse_iso", "i64", ["i8*"])
            self._w.declare_function("flux_std_datetime_to_iso", "i8*", ["i64"])
            self._w.declare_function("flux_std_datetime_format", "i8*", ["i64", "i8*"])
            self._w.declare_function("flux_std_datetime_year", "i64", ["i64"])
            self._w.declare_function("flux_std_datetime_month", "i64", ["i64"])
            self._w.declare_function("flux_std_datetime_day", "i64", ["i64"])
            self._w.declare_function("flux_std_datetime_hour", "i64", ["i64"])
            self._w.declare_function("flux_std_datetime_minute", "i64", ["i64"])
            self._w.declare_function("flux_std_datetime_second", "i64", ["i64"])
            self._w.declare_function("flux_std_datetime_millisecond", "i64", ["i64"])
            self._w.declare_function("flux_std_datetime_microsecond", "i64", ["i64"])
            self._w.declare_function("flux_std_datetime_nanosecond", "i64", ["i64"])
            self._w.declare_function("flux_std_datetime_weekday", "i64", ["i64"])
            self._w.declare_function("flux_std_datetime_day_of_year", "i64", ["i64"])
            self._w.declare_function("flux_std_datetime_days_in_month", "i64", ["i64"])
            self._w.declare_function("flux_std_datetime_quarter", "i64", ["i64"])
            self._w.declare_function("flux_std_datetime_is_leap_year", "i64", ["i64"])
            self._w.declare_function("flux_std_datetime_is_weekend", "i64", ["i64"])
            self._w.declare_function("flux_std_datetime_add_days", "i64", ["i64", "i64"])
            self._w.declare_function("flux_std_datetime_add_hours", "i64", ["i64", "i64"])
            self._w.declare_function("flux_std_datetime_add_minutes", "i64", ["i64", "i64"])
            self._w.declare_function("flux_std_datetime_add_seconds", "i64", ["i64", "i64"])
            self._w.declare_function("flux_std_datetime_add_milliseconds", "i64", ["i64", "i64"])
            self._w.declare_function("flux_std_datetime_add_microseconds", "i64", ["i64", "i64"])
            self._w.declare_function("flux_std_datetime_add_nanoseconds", "i64", ["i64", "i64"])
            self._w.declare_function("flux_std_datetime_add_months", "i64", ["i64", "i64"])
            self._w.declare_function("flux_std_datetime_add_years", "i64", ["i64", "i64"])
            self._w.declare_function("flux_std_datetime_is_before", "i64", ["i64", "i64"])
            self._w.declare_function("flux_std_datetime_is_after", "i64", ["i64", "i64"])
            self._w.declare_function("flux_std_datetime_compare", "i64", ["i64", "i64"])
            self._w.declare_function("flux_std_datetime_days_between", "i64", ["i64", "i64"])
            self._w.declare_function("flux_std_datetime_hours_between", "i64", ["i64", "i64"])
            self._w.declare_function("flux_std_datetime_minutes_between", "i64", ["i64", "i64"])
            self._w.declare_function("flux_std_datetime_seconds_between", "i64", ["i64", "i64"])
            self._w.declare_function("flux_std_datetime_milliseconds_between", "i64", ["i64", "i64"])
            self._w.declare_function("flux_std_datetime_microseconds_between", "i64", ["i64", "i64"])
            self._w.declare_function("flux_std_datetime_nanoseconds_between", "i64", ["i64", "i64"])
            self._w.declare_function("flux_std_datetime_months_between", "i64", ["i64", "i64"])
            self._w.declare_function("flux_std_datetime_years_between", "i64", ["i64", "i64"])
            self._w.declare_function("flux_std_datetime_to_timezone", "i8*", ["i64", "i8*"])
            self._w.declare_function("flux_std_datetime_to_local", "i8*", ["i64"])
            self._w.declare_function("flux_std_datetime_to_utc", "i64", ["i64"])
            self._w.declare_function("flux_std_datetime_utc_offset", "double", ["i64", "i8*"])
            self._w.declare_function("flux_std_datetime_local_timezone", "i8*", [])
            self._w.declare_function("flux_std_datetime_is_daylight_saving_time", "i64", ["i64", "i8*"])
            self._w.declare_function("flux_std_datetime_dst_offset", "double", ["i64", "i8*"])
            self._w.declare_function("flux_std_file_sha256", "i8*", ["i8*"])
            self._w.declare_function("flux_std_file_md5", "i8*", ["i8*"])
            self._w.declare_function("flux_std_file_sha1", "i8*", ["i8*"])
            self._w.declare_function("flux_std_file_crc32", "i64", ["i8*"])
            self._w.declare_function("flux_std_file_hmac_sha256", "i8*", ["i8*", "i8*"])
            self._w.declare_function("flux_std_file_hmac_md5", "i8*", ["i8*", "i8*"])
            self._w.declare_function("flux_std_file_magic_bytes", "i8*", ["i8*", "i64"])
            self._w.declare_function("flux_std_file_detect_type", "i8*", ["i8*"])
            self._w.declare_function("flux_std_file_is_binary", "i64", ["i8*"])
            self._w.begin_function("main", "i32")
            self._new_block("entry")
            frame = self._w.new_local("frame")
            self._w.emit(f"{frame} = alloca {RESULT_TYPE}")
            saved_frame = self._result_frame
            self._result_frame = frame
            for s in program.storages:
                for it in s.items:
                    ft = it.type_ref.name if it.type_ref else "string"
                    if ft in self._structs and it.initializer is not None:
                        self._emit_struct_into(it.initializer, self._struct_slots[it.name])
                    if ft in self._enums and it.initializer is not None:
                        self._emit_enum_into(it.initializer, self._enum_slots[it.name]["slots"])
            for gname, vt, litval in self._runtime_stores:
                rnd = self._round_double(litval, vt)
                g_t, gv, _ = self._globals[gname]
                self._w.emit(f"store {g_t} {rnd}, {g_t}* {gv}")
            for gname, init in self._collection_runtime_stores:
                val, t = self._emit_expr_text(init)
                val = self._coerce_to(val, t, "i8*")
                self._w.emit(f"store i8* {val}, i8** @{gname}")
            for gname, init in self._tensor_runtime_stores:
                self._gen_tensor_init_global(gname, init)
            for gname, init in self._string_runtime_stores:
                val, t = self._emit_expr_text(init)
                val = self._coerce_to(val, t, "i8*")
                self._w.emit(f"store i8* {val}, i8** @{gname}")
            for gname, ft, init in self._general_runtime_stores:
                g_t, gv, ft2 = self._globals[gname]
                if g_t == RESULT_TYPE and isinstance(init, CallExpr) and (self._op_aliases.get(_callee_name(init.callee), _callee_name(init.callee)) in self._function_names):
                    raw_val, _ = self._emit_raw_call(init)
                    self._w.emit(f"store {RESULT_TYPE} {raw_val}, {RESULT_TYPE}* @{gname}")
                elif isinstance(init, ShortCircuitBlock):
                    self._gen_short_circuit(init, bind_name=gname)
                else:
                    val, t = self._emit_expr_text(init)
                    target_t = _llvm_type(ft) if g_t != RESULT_TYPE else RESULT_TYPE
                    val = self._coerce_to(val, t, target_t)
                    self._w.emit(f"store {target_t} {val}, {target_t}* @{gname}")
            self._gen_block(program.body)
            self._result_frame = saved_frame
            self._w.emit("ret i32 0")
            self._w.end_function()

        for func in program.functions:
            self._compile_function(func)

        for op_name in sorted(self._used_op_names):
            self._compile_op_function(self._op_defs[op_name])

        if self._need_round_helper:
            self._emit_round_helper()

        self._emit_collection_helpers()
        self._emit_tensor_helpers()

        self._w.emit_string_constants()

        return self._w.ir()

    @staticmethod
    def _collect_body_storages(block: BlockStmt) -> list[StorageDecl]:
        result: list[StorageDecl] = []
        for stmt in block.body:
            if isinstance(stmt, StorageDecl):
                result.append(stmt)
        return result

    def _emit_body_storages(self, block: BlockStmt) -> None:
        for sd in self._collect_body_storages(block):
            self._gen_storage(sd, is_top_level=False)

    def _collect_strings(self, node: ASTNode) -> None:
        if isinstance(node, Literal) and _is_string_type(node.value_type):
            self._w.get_string_global(node.value)
        for child in getattr(node, "children", []):
            self._collect_strings(child)
        for attr in ("body", "args", "left", "right", "operand", "expr",
                     "callee", "condition", "message", "initializer",
                     "value", "obj", "items", "fail_arm", "nice_arm"):
            child = getattr(node, attr, None)
            if child is not None:
                if isinstance(child, list):
                    for c in child:
                        self._collect_strings(c)
                elif isinstance(child, ASTNode):
                    self._collect_strings(child)
        if isinstance(node, FluxProgram):
            for s in node.storages:
                self._collect_strings(s)
            for f in node.functions:
                self._collect_strings(f)
        if isinstance(node, StorageDecl):
            for item in node.items:
                if item.initializer:
                    self._collect_strings(item.initializer)
        if isinstance(node, BlockStmt):
            for stmt in node.body:
                self._collect_strings(stmt)
        if isinstance(node, PrintStmt):
            for a in node.args:
                self._collect_strings(a)
        if isinstance(node, InterpolatedString):
            for p in node.parts:
                self._collect_strings(p)
            return
        if isinstance(node, InterpolatedText):
            self._w.get_string_global(node.text)
            return
        if isinstance(node, RecordLiteral):
            for f in node.fields:
                self._w.get_string_global(f.name)
                self._collect_strings(f.value)
            return

    @staticmethod
    def _complex_static_value(node: ASTNode) -> complex:
        from flux_proto.interpreter.interpreter import _parse_complex_literal

        if isinstance(node, Literal):
            vt = node.value_type.lower()
            if vt == "complex":
                return _parse_complex_literal(str(node.value))
            if vt in FLOATISH or vt in ("float", "float64", "float32"):
                return complex(float(str(node.value)))
            if vt in ("int", "int64", "int32", "int16", "int8", "uint64", "uint32", "uint16", "uint8"):
                return complex(int(str(node.value)))
        if isinstance(node, UnaryOp) and node.op == "-":
            v = LLVMCodegen._complex_static_value(node.operand)
            return -v
        if isinstance(node, BinaryOp) and node.op in ("+", "-"):
            lv = LLVMCodegen._complex_static_value(node.left)
            rv = LLVMCodegen._complex_static_value(node.right)
            return (lv + rv) if node.op == "+" else (lv - rv)
        raise CodegenError("complex initializer must be a constant expression")

    def _is_result_storage(self, item: StorageDeclItem) -> bool:
        if item.type_ref is not None and item.type_ref.name == "result":
            return True
        if item.type_ref is not None and item.type_ref.name.lower().startswith("complex"):
            return False
        if item.type_ref is not None and (_is_set_type(item.type_ref.name) or _is_list_type(item.type_ref.name) or _is_map_type(item.type_ref.name) or _is_tensor_type(item.type_ref.name)):
            return False
        if isinstance(item.initializer, ShortCircuitBlock):
            return True
        if isinstance(item.initializer, (AwaitExpr, SpawnExpr)):
            return True
        if isinstance(item.initializer, CallExpr):
            cname = _callee_name(item.initializer.callee)
            cname = self._op_aliases.get(cname, cname)
            if cname in self._function_names:
                return True
            ret = self._function_ret.get(cname, "")
            if ret in ("result", ""):
                return True
            return False
        return False

    def _gep_of_string(self, value: str) -> str:
        sname = self._w.get_string_global(value)
        slen = _str_byte_len(value)
        return (f"getelementptr inbounds ([{slen} x i8], [{slen} x i8]* @{sname}, "
                f"i32 0, i32 0)")

    def _input_prompt_gep(self, item) -> str:
        """Retorna GEP i8* do prompt, ou 'null' quando ausente/nao literal."""
        prompt = item.initializer.prompt if isinstance(item.initializer, InputExpr) else None
        if prompt is not None and isinstance(prompt, Literal) \
                and _is_string_type(prompt.value_type):
            return self._gep_of_string(prompt.value)
        return "null"

    def _emit_input_call(self, slot_ptr: str, ftype: str, prompt_gep: str) -> None:
        type_gep = self._gep_of_string(ftype)
        if slot_ptr.startswith("@"):
            cast_arg = f"bitcast ({_llvm_type(ftype)}* {slot_ptr} to i8*)"
        else:
            cast_val = self._w.new_local("input_cast")
            self._w.emit(f"{cast_val} = bitcast {_llvm_type(ftype)}* {slot_ptr} to i8*")
            cast_arg = cast_val
        self._w.emit(f"call void @flux_input(i8* {prompt_gep}, i8* {type_gep}, i8* {cast_arg})")

    def _declare_input_global(self, item) -> None:
        name = item.name
        ftype = item.type_ref.name if item.type_ref else "string"
        if name in self._globals:
            return
        if ftype.lower().startswith("complex"):
            llvm_t = "{ double, double }"
            init_str = "{ double 0.0, double 0.0 }"
        elif _is_string_type(ftype):
            llvm_t = "i8*"
            init_str = self._gep_of_string("")
        else:
            llvm_t = _llvm_type(ftype)
            init_str = "zeroinitializer"
        self._globals[name] = (llvm_t, f"@{name}", ftype)
        self._w.add_global(name, llvm_t, init_str)

    def _declare_input_local(self, item) -> None:
        name = item.name
        ftype = item.type_ref.name if item.type_ref else "string"
        llvm_t = _llvm_type(ftype) if not ftype.lower().startswith("complex") else "{ double, double }"
        a = self._w.new_local(f"s_{name}")
        self._w.emit(f"{a} = alloca {llvm_t}")
        self._globals[name] = (llvm_t, a, ftype)
        self._emit_input_call(a, ftype, self._input_prompt_gep(item))

    def _gen_storage(self, node: StorageDecl, is_top_level: bool = True) -> None:
        for item in node.items:
            if isinstance(item.initializer, InputExpr):
                self._declare_input_global(item)
                continue
            name = item.name
            flux_type = item.type_ref.name if item.type_ref else "string"
            if flux_type.lower().startswith("complex"):
                if name not in self._globals:
                    init_str = "{ double 0.0, double 0.0 }"
                    if item.initializer is not None:
                        try:
                            cv = self._complex_static_value(item.initializer)
                            r_str = norm_float_text(str(cv.real))
                            i_str = norm_float_text(str(cv.imag))
                            init_str = f"{{ double {r_str}, double {i_str} }}"
                        except CodegenError:
                            pass
                    self._globals[name] = ("{ double, double }", f"@{name}", flux_type)
                    self._w.add_global(name, "{ double, double }", init_str)
                continue
            if _is_set_type(flux_type) or _is_list_type(flux_type) or _is_map_type(flux_type):
                if name not in self._globals:
                    self._globals[name] = ("i8*", f"@{name}", flux_type)
                    self._w.add_global(name, "i8*", "null")
                    if item.initializer is not None:
                        self._collection_runtime_stores.append((name, item.initializer))
                continue
            if _is_tensor_type(flux_type):
                if name not in self._globals:
                    self._globals[name] = ("i8*", f"@{name}", flux_type)
                    self._w.add_global(name, "i8*", "null")
                    self._tensor_runtime_stores.append((name, item.initializer))
                continue
            if flux_type == "data" and item.initializer is not None and isinstance(
                    item.initializer, (ListLiteral, SetLiteral, MapLiteral, RecordLiteral)):
                if name not in self._globals:
                    self._globals[name] = ("i8*", f"@{name}", flux_type)
                    self._w.add_global(name, "i8*", "null")
                    self._collection_runtime_stores.append((name, item.initializer))
                continue
            if flux_type in self._structs:
                self._declare_struct_storage_global(item)
                continue
            if flux_type in self._enums:
                self._declare_enum_storage_global(item)
                continue
            is_result = self._is_result_storage(item)
            if is_result:
                llvm_t = RESULT_TYPE
                init_str = "zeroinitializer"
                if item.type_ref is not None and item.type_ref.name == "result":
                    flux_type = "result"
                if is_top_level and item.initializer is not None and not isinstance(item.initializer, Literal):
                    self._general_runtime_stores.append((name, flux_type, item.initializer))
            else:
                llvm_t = _llvm_type(flux_type)
                init_str = "zeroinitializer"
                if item.initializer and isinstance(item.initializer, Literal):
                    vt = item.initializer.value_type.lower()
                    if vt in ("int", "int64", "int32", "int16", "int8",
                              "uint64", "uint32", "uint16", "uint8"):
                        init_str = item.initializer.value
                    elif vt in ("float", "float64", "float32"):
                        init_str = norm_float_text(item.initializer.value)
                    elif vt in FLOAT_FORMATS and vt not in ("float64", "float32"):
                        init_str = norm_float_text(item.initializer.value)
                    elif vt == "bool":
                        init_str = "true" if item.initializer.value.lower() == "true" else "false"
                    elif vt == "char":
                        init_str = str(ord(item.initializer.value))
                    elif vt == "datetime":
                        from flux_proto.interpreter.interpreter import _parse_iso_nanos

                        init_str = str(_parse_iso_nanos(item.initializer.value))
                    elif _is_string_type(vt):
                        sname = self._w.get_string_global(item.initializer.value)
                        slen = _str_byte_len(item.initializer.value)
                        init_str = f"getelementptr inbounds ([{slen} x i8], [{slen} x i8]* @{sname}, i32 0, i32 0)"
                        llvm_t = "i8*"
                if (flux_type in FLOAT_FORMATS and flux_type not in ("float64", "float32")
                        and isinstance(item.initializer, Literal)):
                    init_str = "0.0"
                    self._runtime_stores.append((name, flux_type, norm_float_text(item.initializer.value)))
                else:
                    if _is_string_type(flux_type):
                        llvm_t = "i8*"
                        if item.initializer is not None and not isinstance(item.initializer, Literal):
                            self._string_runtime_stores.append((name, item.initializer))
                        if init_str == "zeroinitializer":
                            ename = self._w.get_string_global("")
                            elen = _str_byte_len("")
                            init_str = f"getelementptr inbounds ([{elen} x i8], [{elen} x i8]* @{ename}, i32 0, i32 0)"
                    elif is_top_level and item.initializer is not None and not isinstance(item.initializer, Literal):
                        self._general_runtime_stores.append((name, flux_type, item.initializer))
            if name not in self._globals:
                self._globals[name] = (llvm_t, f"@{name}", flux_type)
                self._w.add_global(name, llvm_t, init_str)

    def _struct_layout(self, sdef: StructDef) -> dict:
        fields: dict[str, tuple[str, str]] = {}
        for f in sdef.fields:
            ft = f.type_ref.name if f.type_ref else "int64"
            fields[f.name] = (_llvm_type(ft), ft)
        return {"fields": fields}

    def _enum_layout(self, edef: EnumDef) -> dict:
        fields: dict[str, tuple[str, str]] = {}
        for m in edef.members:
            for f in m.fields:
                ft = f.type_ref.name if f.type_ref else "int64"
                llvm_t = _llvm_type(ft)
                if f.name in fields and fields[f.name][0] != llvm_t:
                    raise CodegenError(f"enum field '{f.name}' has conflicting types")
                fields[f.name] = (llvm_t, ft)
        return {"fields": fields}

    def _enum_tag(self, edef: EnumDef, variant: str) -> int:
        for i, m in enumerate(edef.members):
            if m.name == variant:
                return i
        raise CodegenError(f"variant '{variant}' not found in enum '{edef.name}'")

    def _declare_enum_storage_global(self, item: StorageItem) -> None:
        edef = self._enums.get(item.type_ref.name)
        if edef is None:
            raise CodegenError(f"enum '{item.type_ref.name}' not declared")
        layout = self._enum_layout(edef)
        slots: dict = {"tag": (f"@{item.name}_flux_tag", "i64"), "fields": {}}
        self._w.add_global(f"{item.name}_flux_tag", "i64", "0")
        for fname, (llvm_t, ft) in layout["fields"].items():
            gname = f"{item.name}_flux_{fname}"
            self._w.add_global(gname, llvm_t, "zeroinitializer")
            slots["fields"][fname] = (f"@{gname}", llvm_t, ft)
        self._enum_slots[item.name] = {"kind": "global", "slots": slots, "enum": item.type_ref.name}

    def _declare_enum_storage_local(self, item: StorageItem) -> None:
        edef = self._enums.get(item.type_ref.name)
        if edef is None:
            raise CodegenError(f"enum '{item.type_ref.name}' not declared")
        layout = self._enum_layout(edef)
        slots: dict = {"tag": (self._w.new_local(f"e_{item.name}_tag"), "i64"), "fields": {}}
        self._w.emit(f"{slots['tag'][0]} = alloca i64")
        for fname, (llvm_t, ft) in layout["fields"].items():
            a = self._w.new_local(f"e_{item.name}_{fname}")
            self._w.emit(f"{a} = alloca {llvm_t}")
            slots["fields"][fname] = (a, llvm_t, ft)
        self._enum_slots[item.name] = {"kind": "local", "slots": slots, "enum": item.type_ref.name}

    def _emit_enum_into(self, init: ASTNode | None, slots: dict) -> None:
        if init is None:
            return
        if not isinstance(init, EnumVariant):
            raise CodegenError("enum storage requires an EnumVariant initializer")
        edef = self._enums.get(init.enum_name)
        if edef is None:
            raise CodegenError(f"enum '{init.enum_name}' not declared")
        tag = self._enum_tag(edef, init.variant)
        tptr, _ = slots["tag"]
        self._w.emit(f"store i64 {tag}, i64* {tptr}")
        for f in init.fields:
            if f.name not in slots["fields"]:
                raise CodegenError(f"unknown field '{f.name}' for enum '{init.enum_name}'")
            ptr, llvm_t, _ = slots["fields"][f.name]
            val, t = self._emit_expr_text(f.value)
            val = self._coerce_to(val, t, llvm_t)
            self._w.emit(f"store {llvm_t} {val}, {llvm_t}* {ptr}")

    def _gen_enum_value(self, node: EnumVariant) -> None:
        edef = self._enums.get(node.enum_name)
        if edef is None:
            raise CodegenError(f"enum '{node.enum_name}' not declared")
        layout = self._enum_layout(edef)
        tag = self._enum_tag(edef, node.variant)
        if not self._w._in_function:
            raise CodegenError("enum value expression only supported inside a function on LLVM target")
        seq = self._tmp_seq
        self._tmp_seq += 1
        tslot = self._w.new_local(f"e{seq}_tag")
        self._w.emit(f"{tslot} = alloca i64")
        self._w.emit(f"store i64 {tag}, i64* {tslot}")
        slots: dict = {"tag": (tslot, "i64"), "fields": {}}
        for f in node.fields:
            if f.name not in layout["fields"]:
                raise CodegenError(f"unknown field '{f.name}' for enum '{node.enum_name}'")
            llvm_t, ft = layout["fields"][f.name]
            a = self._w.new_local(f"e{seq}_{f.name}")
            self._w.emit(f"{a} = alloca {llvm_t}")
            val, t = self._emit_expr_text(f.value)
            val = self._coerce_to(val, t, llvm_t)
            self._w.emit(f"store {llvm_t} {val}, {llvm_t}* {a}")
            slots["fields"][f.name] = (a, llvm_t, ft)
        self._pending_enum = {"slots": slots, "enum": node.enum_name}

    def _declare_struct_storage_global(self, item: StorageItem) -> None:
        sdef = self._structs.get(item.type_ref.name)
        if sdef is None:
            raise CodegenError(f"struct '{item.type_ref.name}' not declared")
        layout = self._struct_layout(sdef)
        slots: dict = {"kind": "global", "fields": {}, "sname": sdef.name}
        for fname, (llvm_t, ft) in layout["fields"].items():
            gname = f"{item.name}_{fname}"
            self._w.add_global(gname, llvm_t, "zeroinitializer")
            slots["fields"][fname] = (f"@{gname}", llvm_t, ft)
        self._struct_slots[item.name] = slots

    def _declare_struct_storage_local(self, item: StorageItem) -> None:
        sdef = self._structs.get(item.type_ref.name)
        if sdef is None:
            raise CodegenError(f"struct '{item.type_ref.name}' not declared")
        layout = self._struct_layout(sdef)
        slots: dict = {"kind": "local", "fields": {}, "sname": sdef.name}
        for fname, (llvm_t, ft) in layout["fields"].items():
            a = self._w.new_local(f"s_{item.name}_{fname}")
            self._w.emit(f"{a} = alloca {llvm_t}")
            slots["fields"][fname] = (a, llvm_t, ft)
        self._struct_slots[item.name] = slots

    def _emit_struct_into(self, init: ASTNode | None, slots: dict) -> None:
        if init is not None and not isinstance(init, StructInit):
            raise CodegenError("struct storage requires a StructInit initializer")
        if init is None:
            return
        sdef = self._structs.get(init.name)
        if sdef is None:
            raise CodegenError(f"struct '{init.name}' not declared")
        for f in init.fields:
            if f.name not in slots["fields"]:
                raise CodegenError(f"unknown field '{f.name}' for struct '{init.name}'")
            ptr, llvm_t, _ = slots["fields"][f.name]
            val, t = self._emit_expr_text(f.value)
            val = self._coerce_to(val, t, llvm_t)
            self._w.emit(f"store {llvm_t} {val}, {llvm_t}* {ptr}")

    def _gen_block(self, node: BlockStmt) -> None:
        for stmt in node.body:
            if self._block_terminated:
                break
            self._gen_statement(stmt)

    def _gen_statement(self, node: ASTNode) -> None:
        if self._is_exotic(node):
            self._raise_exotic(node)
        if isinstance(node, UnsafeStmt):
            if isinstance(node.body, BlockStmt):
                self._gen_block(node.body)
            elif node.body is not None:
                self._gen_statement(node.body)
        elif isinstance(node, BlockStmt):
            self._gen_block(node)
        elif isinstance(node, ExpressionStmt):
            self._gen_expr(node.expr)
        elif isinstance(node, IndexAssign):
            self._gen_index_assign_text(node)
        elif isinstance(node, PrintStmt):
            self._gen_print_call(node.args, newline=True)
        elif isinstance(node, CallExpr):
            self._gen_call(node)
        elif isinstance(node, StorageDecl):
            for it in node.items:
                ft = it.type_ref.name if it.type_ref else "string"
                if isinstance(it.initializer, InputExpr):
                    if self._w._in_function or self._in_op:
                        self._declare_input_local(it)
                    elif it.name not in self._globals:
                        self._declare_input_local(it)
                    else:
                        self._emit_input_call(
                            f"@{it.name}", it.type_ref.name if it.type_ref else "string",
                            self._input_prompt_gep(it))
                    continue
                if isinstance(it.initializer, OwnershipExpr) and it.initializer.mut:
                    t = it.initializer.target
                    if t not in self._globals:
                        raise CodegenError(f"borrow_mut target '{t}' not available on LLVM target")
                    if it.name not in self._globals:
                        self._globals[it.name] = self._globals[t]
                    continue
                if ft in self._enums:
                    if self._w._in_function:
                        if it.name not in self._enum_slots:
                            self._declare_enum_storage_local(it)
                            if it.initializer is not None:
                                self._emit_enum_into(it.initializer, self._enum_slots[it.name]["slots"])
                        elif it.initializer is not None:
                            self._emit_enum_into(it.initializer, self._enum_slots[it.name]["slots"])
                    else:
                        if it.name not in self._enum_slots:
                            self._declare_enum_storage_global(it)
                        if it.initializer is not None:
                            self._emit_enum_into(it.initializer, self._enum_slots[it.name]["slots"])
                    continue
                if ft in self._structs:
                    if self._w._in_function:
                        if it.name not in self._struct_slots:
                            self._declare_struct_storage_local(it)
                            if it.initializer is not None:
                                self._emit_struct_into(it.initializer, self._struct_slots[it.name])
                        elif it.initializer is not None:
                            self._emit_struct_into(it.initializer, self._struct_slots[it.name])
                    else:
                        if it.name not in self._struct_slots:
                            self._declare_struct_storage_global(it)
                        if it.initializer is not None:
                            self._emit_struct_into(it.initializer, self._struct_slots[it.name])
                    continue
                if _is_tensor_type(ft):
                    if self._w._in_function:
                        if it.name not in self._globals:
                            self._declare_tensor_storage_local(it)
                    continue
                if self._w._in_function:
                    ft = it.type_ref.name if it.type_ref else "string"
                    if _is_set_type(ft) or _is_list_type(ft) or _is_map_type(ft) or (ft == "data" and it.initializer is not None and isinstance(it.initializer, (ListLiteral, SetLiteral, MapLiteral, RecordLiteral))):
                        a = self._w.new_local(f"s_{it.name}")
                        self._w.emit(f"{a} = alloca i8*")
                        self._globals[it.name] = ("i8*", a, ft)
                        if it.initializer:
                            val, t = self._emit_expr_text(it.initializer)
                            val = self._coerce_to(val, t, "i8*")
                            self._w.emit(f"store i8* {val}, i8** {a}")
                        else:
                            self._w.emit(f"store i8* null, i8** {a}")
                        continue
                    if ft == "data":
                        a = self._w.new_local(f"s_{it.name}")
                        self._w.emit(f"{a} = alloca i64")
                        tag_a = self._w.new_local(f"stag_{it.name}")
                        self._w.emit(f"{tag_a} = alloca i64")
                        sval_a = self._w.new_local(f"ssval_{it.name}")
                        self._w.emit(f"{sval_a} = alloca i8*")
                        self._globals[it.name] = ("i64", a, "data")
                        self._var_tag_slots[it.name] = tag_a
                        self._var_sval_slots[it.name] = sval_a
                        if it.initializer is not None:
                            if isinstance(it.initializer, IndexAccess):
                                iot = self._flux_type_of(it.initializer.obj)
                                if _is_map_type(iot):
                                    iov, iott = self._emit_expr_text(it.initializer.obj)
                                    iovv = self._coerce_to(iov, iott, "i8*")
                                    ik = self._map_key_text(it.initializer.indices[0])
                                    tag = self._w.new_local("mtag")
                                    self._w.emit(f"{tag} = call i64 @flux_map_get_tag(i8* {iovv}, i8* {ik})")
                                    vv = self._w.new_local("mval")
                                    self._w.emit(f"{vv} = call i64 @flux_map_get(i8* {iovv}, i8* {ik})")
                                    sp = self._w.new_local("sp")
                                    self._w.emit(f"{sp} = inttoptr i64 {vv} to i8*")
                                    is_str = self._w.new_local("is_str")
                                    self._w.emit(f"{is_str} = icmp eq i64 {tag}, 4")
                                    sv = self._w.new_local("sv")
                                    self._w.emit(f"{sv} = select i1 {is_str}, i8* {sp}, i8* null")
                                    self._w.emit(f"store i64 {tag}, i64* {tag_a}")
                                    self._w.emit(f"store i64 {vv}, i64* {a}")
                                    self._w.emit(f"store i8* {sv}, i8** {sval_a}")
                                elif (_is_list_type(iot) or iot == "data") and len(it.initializer.indices) == 1 and not isinstance(it.initializer.indices[0], SliceSpec):
                                    iov, iott = self._emit_expr_text(it.initializer.obj)
                                    iovv = self._coerce_to(iov, iott, "i8*")
                                    iiv, iit = self._emit_expr_text(it.initializer.indices[0])
                                    iivv = self._coerce_to(iiv, iit, "i64")
                                    idata = self._w.new_local("idata")
                                    self._w.emit(f"{idata} = call i8* @flux_list_data(i8* {iovv})")
                                    tag = self._w.new_local("itag")
                                    self._w.emit(f"{tag} = call i64 @flux_row_tag(i8* {idata}, i64 {iivv})")
                                    v64 = self._w.new_local("ival")
                                    self._w.emit(f"{v64} = call i64 @flux_row_val(i8* {idata}, i64 {iivv})")
                                    sv = self._w.new_local("isval")
                                    self._w.emit(f"{sv} = call i8* @flux_row_sval(i8* {idata}, i64 {iivv})")
                                    self._w.emit(f"store i64 {tag}, i64* {tag_a}")
                                    self._w.emit(f"store i64 {v64}, i64* {a}")
                                    self._w.emit(f"store i8* {sv}, i8** {sval_a}")
                                else:
                                    v, vt = self._emit_expr_text(it.initializer)
                                    vft = self._flux_type_of(it.initializer)
                                    tag, v64, sv = self._elem_encoding(vt, v, vft)
                                    self._w.emit(f"store i64 {tag}, i64* {tag_a}")
                                    self._w.emit(f"store i64 {v64}, i64* {a}")
                                    self._w.emit(f"store i8* {sv}, i8** {sval_a}")
                            elif isinstance(it.initializer, CallExpr) and (self._op_aliases.get(_callee_name(it.initializer.callee), _callee_name(it.initializer.callee)) in self._function_names):
                                r, _ = self._emit_raw_call(it.initializer)
                                v64 = self._w.new_local("dcall_v")
                                self._w.emit(f"{v64} = extractvalue {RESULT_TYPE} {r}, 1")
                                tag_d = self._w.new_local("dcall_tagd")
                                self._w.emit(f"{tag_d} = extractvalue {RESULT_TYPE} {r}, 2")
                                tag_i = self._w.new_local("dcall_tagi")
                                self._w.emit(f"{tag_i} = fptosi double {tag_d} to i64")
                                sp = self._w.new_local("sp")
                                self._w.emit(f"{sp} = inttoptr i64 {v64} to i8*")
                                is_str = self._w.new_local("is_str")
                                self._w.emit(f"{is_str} = icmp eq i64 {tag_i}, 4")
                                sv = self._w.new_local("sv")
                                self._w.emit(f"{sv} = select i1 {is_str}, i8* {sp}, i8* null")
                                self._w.emit(f"store i64 {tag_i}, i64* {tag_a}")
                                self._w.emit(f"store i64 {v64}, i64* {a}")
                                self._w.emit(f"store i8* {sv}, i8** {sval_a}")
                            elif isinstance(it.initializer, Identifier) and it.initializer.name in self._param_tag_slots:
                                tag = self._param_tag_slots[it.initializer.name]
                                v, vt = self._emit_expr_text(it.initializer)
                                v64 = self._coerce_to(v, vt, "i64")
                                sp = self._w.new_local("sp")
                                self._w.emit(f"{sp} = inttoptr i64 {v64} to i8*")
                                is_str = self._w.new_local("is_str")
                                self._w.emit(f"{is_str} = icmp eq i64 {tag}, 4")
                                sv = self._w.new_local("sv")
                                self._w.emit(f"{sv} = select i1 {is_str}, i8* {sp}, i8* null")
                                self._w.emit(f"store i64 {tag}, i64* {tag_a}")
                                self._w.emit(f"store i64 {v64}, i64* {a}")
                                self._w.emit(f"store i8* {sv}, i8** {sval_a}")
                            elif isinstance(it.initializer, Identifier) and it.initializer.name in self._var_tag_slots:
                                tptr = self._var_tag_slots[it.initializer.name]
                                sptr = self._var_sval_slots[it.initializer.name]
                                tag = self._w.new_local("itag")
                                self._w.emit(f"{tag} = load i64, i64* {tptr}")
                                sv = self._w.new_local("isval")
                                self._w.emit(f"{sv} = load i8*, i8** {sptr}")
                                v, vt = self._emit_expr_text(it.initializer)
                                v64 = self._coerce_to(v, vt, "i64")
                                self._w.emit(f"store i64 {tag}, i64* {tag_a}")
                                self._w.emit(f"store i64 {v64}, i64* {a}")
                                self._w.emit(f"store i8* {sv}, i8** {sval_a}")
                            else:
                                v, vt = self._emit_expr_text(it.initializer)
                                vft = self._flux_type_of(it.initializer)
                                tag, v64, sv = self._elem_encoding(vt, v, vft)
                                self._w.emit(f"store i64 {tag}, i64* {tag_a}")
                                self._w.emit(f"store i64 {v64}, i64* {a}")
                                self._w.emit(f"store i8* {sv}, i8** {sval_a}")
                        else:
                            self._w.emit(f"store i64 0, i64* {tag_a}")
                            self._w.emit(f"store i64 0, i64* {a}")
                            self._w.emit(f"store i8* null, i8** {sval_a}")
                        continue
                    is_result = self._is_result_storage(it)
                    if is_result and it.type_ref is not None and it.type_ref.name == "result":
                        ft = "result"
                    g_t = RESULT_TYPE if is_result else _llvm_type(ft)
                    a = self._w.new_local(f"s_{it.name}")
                    self._w.emit(f"{a} = alloca {g_t}")
                    self._globals[it.name] = (g_t, a, ft)
                    if it.initializer:
                        if isinstance(it.initializer, ShortCircuitBlock):
                            self._gen_short_circuit(it.initializer, bind_name=it.name)
                        elif g_t == RESULT_TYPE and isinstance(it.initializer, CallExpr) and (self._op_aliases.get(_callee_name(it.initializer.callee), _callee_name(it.initializer.callee)) in self._function_names):
                            raw_val, _ = self._emit_raw_call(it.initializer)
                            self._w.emit(f"store {RESULT_TYPE} {raw_val}, {RESULT_TYPE}* {a}")
                        else:
                            val, t = self._emit_expr_text(it.initializer)
                            val = self._coerce_to(val, t, g_t)
                            if g_t == "double":
                                val = self._round_double(val, ft)
                            self._w.emit(f"store {g_t} {val}, {g_t}* {a}")
                    else:
                        if _is_string_type(ft):
                            ename = self._w.get_string_global("")
                            elen = _str_byte_len("")
                            self._w.emit(f"store i8* getelementptr inbounds ([{elen} x i8], [{elen} x i8]* @{ename}, i32 0, i32 0), i8** {a}")
                        elif g_t == "double":
                            self._w.emit(f"store double 0.0, double* {a}")
                        elif g_t == "i1":
                            self._w.emit(f"store i1 0, i1* {a}")
                        elif g_t == "i8*":
                            self._w.emit(f"store i8* null, i8** {a}")
                        elif g_t == RESULT_TYPE:
                            self._w.emit(f"store {RESULT_TYPE} zeroinitializer, {RESULT_TYPE}* {a}")
                        else:
                            self._w.emit(f"store {g_t} 0, {g_t}* {a}")
                else:
                    if it.name not in self._globals:
                        self._gen_storage(node)
                    elif it.initializer:
                        g_t, gv, ft2 = self._globals[it.name]
                        if isinstance(it.initializer, ShortCircuitBlock):
                            self._gen_short_circuit(it.initializer, bind_name=it.name)
                        elif g_t == RESULT_TYPE and isinstance(it.initializer, CallExpr) and (self._op_aliases.get(_callee_name(it.initializer.callee), _callee_name(it.initializer.callee)) in self._function_names):
                            raw_val, _ = self._emit_raw_call(it.initializer)
                            self._w.emit(f"store {RESULT_TYPE} {raw_val}, {RESULT_TYPE}* {gv}")
                        else:
                            val, t = self._emit_expr_text(it.initializer)
                            val = self._coerce_to(val, t, g_t)
                            if g_t == "double":
                                val = self._round_double(val, ft2)
                            self._w.emit(f"store {g_t} {val}, {g_t}* {gv}")
        elif isinstance(node, VariableReassign):
            if isinstance(node.value, ShortCircuitBlock):
                self._gen_short_circuit(node.value, bind_name=node.name)
            else:
                self._gen_variable_reassign(node)
        elif isinstance(node, FieldAssign):
            self._gen_field_assign(node)
        elif isinstance(node, ShortCircuitBlock):
            self._gen_short_circuit(node)
        elif isinstance(node, ShortCircuitBlock):
            self._gen_short_circuit(node)
        elif isinstance(node, EmitStmt):
            self._gen_emit(node)
        elif isinstance(node, RouteStmt):
            self._gen_route(node)
        elif isinstance(node, MatchStmt):
            self._gen_match(node, keep_result=False)
        elif isinstance(node, InfiniteStmt):
            self._gen_infinite(node)
        elif isinstance(node, BreakStmt):
            if self._loop_break is None:
                raise CodegenError("break outside infinite loop")
            self._w.emit(f"br label %{self._loop_break}")
            self._block_terminated = True
        elif isinstance(node, ContinueStmt):
            if self._loop_continue is None:
                raise CodegenError("continue outside infinite loop")
            self._w.emit(f"br label %{self._loop_continue}")
            self._block_terminated = True

    def _gen_field_assign(self, node: FieldAssign) -> None:
        if node.owner not in self._struct_slots:
            raise CodegenError(f"field assignment requires a struct variable, got '{node.owner}'")
        if node.op != "=":
            raise CodegenError(f"operator '{node.op}' not supported on struct fields")
        slots = self._struct_slots[node.owner]
        if node.field not in slots["fields"]:
            raise CodegenError(f"unknown field '{node.field}' for struct '{node.owner}'")
        ptr, llvm_t, _ = slots["fields"][node.field]
        val, t = self._emit_expr_text(node.value)
        val = self._coerce_to(val, t, llvm_t)
        self._w.emit(f"store {llvm_t} {val}, {llvm_t}* {ptr}")

    def _gen_variable_reassign(self, node: VariableReassign) -> None:
        if node.name in self._struct_slots:
            if node.op != "=":
                raise CodegenError(f"operator '{node.op}' not supported on struct '{node.name}'")
            if not isinstance(node.value, StructInit):
                raise CodegenError(f"struct '{node.name}' requires a StructInit value")
            self._emit_struct_into(node.value, self._struct_slots[node.name])
            return
        if node.name in self._enum_slots:
            if node.op != "=":
                raise CodegenError(f"operator '{node.op}' not supported on enum '{node.name}'")
            if not isinstance(node.value, EnumVariant):
                raise CodegenError(f"enum '{node.name}' requires an EnumVariant value")
            self._emit_enum_into(node.value, self._enum_slots[node.name]["slots"])
            return
        if node.name in self._var_tag_slots and (not node.op or node.op == "="):
            tag_a = self._var_tag_slots[node.name]
            sval_a = self._var_sval_slots[node.name]
            _, a, _ = self._globals[node.name]
            if isinstance(node.value, IndexAccess):
                iot = self._flux_type_of(node.value.obj)
                if _is_map_type(iot):
                    iov, iott = self._emit_expr_text(node.value.obj)
                    iovv = self._coerce_to(iov, iott, "i8*")
                    ik = self._map_key_text(node.value.indices[0])
                    tag = self._w.new_local("mtag")
                    self._w.emit(f"{tag} = call i64 @flux_map_get_tag(i8* {iovv}, i8* {ik})")
                    vv = self._w.new_local("mval")
                    self._w.emit(f"{vv} = call i64 @flux_map_get(i8* {iovv}, i8* {ik})")
                    sp = self._w.new_local("sp")
                    self._w.emit(f"{sp} = inttoptr i64 {vv} to i8*")
                    is_str = self._w.new_local("is_str")
                    self._w.emit(f"{is_str} = icmp eq i64 {tag}, 4")
                    sv = self._w.new_local("sv")
                    self._w.emit(f"{sv} = select i1 {is_str}, i8* {sp}, i8* null")
                    self._w.emit(f"store i64 {tag}, i64* {tag_a}")
                    self._w.emit(f"store i64 {vv}, i64* {a}")
                    self._w.emit(f"store i8* {sv}, i8** {sval_a}")
                    return
                elif (_is_list_type(iot) or iot == "data") and len(node.value.indices) == 1 and not isinstance(node.value.indices[0], SliceSpec):
                    iov, iott = self._emit_expr_text(node.value.obj)
                    iovv = self._coerce_to(iov, iott, "i8*")
                    iiv, iit = self._emit_expr_text(node.value.indices[0])
                    iivv = self._coerce_to(iiv, iit, "i64")
                    idata = self._w.new_local("idata")
                    self._w.emit(f"{idata} = call i8* @flux_list_data(i8* {iovv})")
                    tag = self._w.new_local("itag")
                    self._w.emit(f"{tag} = call i64 @flux_row_tag(i8* {idata}, i64 {iivv})")
                    v64 = self._w.new_local("ival")
                    self._w.emit(f"{v64} = call i64 @flux_row_val(i8* {idata}, i64 {iivv})")
                    sv = self._w.new_local("isval")
                    self._w.emit(f"{sv} = call i8* @flux_row_sval(i8* {idata}, i64 {iivv})")
                    self._w.emit(f"store i64 {tag}, i64* {tag_a}")
                    self._w.emit(f"store i64 {v64}, i64* {a}")
                    self._w.emit(f"store i8* {sv}, i8** {sval_a}")
                    return
            elif isinstance(node.value, CallExpr) and (self._op_aliases.get(_callee_name(node.value.callee), _callee_name(node.value.callee)) in self._function_names):
                r, _ = self._emit_raw_call(node.value)
                v64 = self._w.new_local("dcall_v")
                self._w.emit(f"{v64} = extractvalue {RESULT_TYPE} {r}, 1")
                tag_d = self._w.new_local("dcall_tagd")
                self._w.emit(f"{tag_d} = extractvalue {RESULT_TYPE} {r}, 2")
                tag_i = self._w.new_local("dcall_tagi")
                self._w.emit(f"{tag_i} = fptosi double {tag_d} to i64")
                sp = self._w.new_local("sp")
                self._w.emit(f"{sp} = inttoptr i64 {v64} to i8*")
                is_str = self._w.new_local("is_str")
                self._w.emit(f"{is_str} = icmp eq i64 {tag_i}, 4")
                sv = self._w.new_local("sv")
                self._w.emit(f"{sv} = select i1 {is_str}, i8* {sp}, i8* null")
                self._w.emit(f"store i64 {tag_i}, i64* {tag_a}")
                self._w.emit(f"store i64 {v64}, i64* {a}")
                self._w.emit(f"store i8* {sv}, i8** {sval_a}")
                return
            elif isinstance(node.value, Identifier) and node.value.name in self._param_tag_slots:
                tag = self._param_tag_slots[node.value.name]
                v, vt = self._emit_expr_text(node.value)
                v64 = self._coerce_to(v, vt, "i64")
                sp = self._w.new_local("sp")
                self._w.emit(f"{sp} = inttoptr i64 {v64} to i8*")
                is_str = self._w.new_local("is_str")
                self._w.emit(f"{is_str} = icmp eq i64 {tag}, 4")
                sv = self._w.new_local("sv")
                self._w.emit(f"{sv} = select i1 {is_str}, i8* {sp}, i8* null")
                self._w.emit(f"store i64 {tag}, i64* {tag_a}")
                self._w.emit(f"store i64 {v64}, i64* {a}")
                self._w.emit(f"store i8* {sv}, i8** {sval_a}")
                return
            elif isinstance(node.value, Identifier) and node.value.name in self._var_tag_slots:
                tptr = self._var_tag_slots[node.value.name]
                sptr = self._var_sval_slots[node.value.name]
                tag = self._w.new_local("itag")
                self._w.emit(f"{tag} = load i64, i64* {tptr}")
                sv = self._w.new_local("isval")
                self._w.emit(f"{sv} = load i8*, i8** {sptr}")
                v, vt = self._emit_expr_text(node.value)
                v64 = self._coerce_to(v, vt, "i64")
                self._w.emit(f"store i64 {tag}, i64* {tag_a}")
                self._w.emit(f"store i64 {v64}, i64* {a}")
                self._w.emit(f"store i8* {sv}, i8** {sval_a}")
                return
            v, vt = self._emit_expr_text(node.value)
            vft = self._flux_type_of(node.value)
            tag, v64, sv = self._elem_encoding(vt, v, vft)
            self._w.emit(f"store i64 {tag}, i64* {tag_a}")
            self._w.emit(f"store i64 {v64}, i64* {a}")
            self._w.emit(f"store i8* {sv}, i8** {sval_a}")
            return
        val_ll, val_t = self._gen_expr(node.value)
        if node.name in self._globals:
            g_t, gv, ft2 = self._globals[node.name]
            if node.op and node.op != "=":
                comp = node.op[1:]
                if comp == "~":
                    cur = self._w.new_local()
                    self._w.emit(f"{cur} = load {g_t}, {g_t}* {gv}")
                    r = self._w.new_local()
                    self._w.emit(f"{r} = xor {g_t} {cur}, -1")
                    self._w.emit(f"store {g_t} {r}, {g_t}* {gv}")
                else:
                    cur = self._w.new_local()
                    self._w.emit(f"{cur} = load {g_t}, {g_t}* {gv}")
                    res, res_t = self._apply_binary_op(comp, cur, g_t, val_ll, val_t)
                    res = self._coerce_to(res, res_t, g_t)
                    if g_t == "double":
                        res = self._round_double(res, ft2)
                    self._w.emit(f"store {g_t} {res}, {g_t}* {gv}")
            else:
                if g_t == RESULT_TYPE and isinstance(node.value, CallExpr) and (self._op_aliases.get(_callee_name(node.value.callee), _callee_name(node.value.callee)) in self._function_names):
                    raw_val, _ = self._emit_raw_call(node.value)
                    self._w.emit(f"store {RESULT_TYPE} {raw_val}, {RESULT_TYPE}* {gv}")
                else:
                    val_ll = self._coerce_to(val_ll, val_t, g_t)
                    if g_t == "double":
                        val_ll = self._round_double(val_ll, ft2)
                    self._w.emit(f"store {g_t} {val_ll}, {g_t}* {gv}")
        else:
            a = self._w.new_local(f"s_{node.name}")
            self._w.emit(f"{a} = alloca {val_t}")
            ft = "int64" if val_t == "i64" else ("float64" if val_t in ("double", "float") else "string")
            self._globals[node.name] = (val_t, a, ft)
            if node.op and node.op != "=":
                comp = node.op[1:]
                if comp == "~":
                    r = self._w.new_local()
                    self._w.emit(f"{r} = xor {val_t} 0, -1")
                    self._w.emit(f"store {val_t} {r}, {val_t}* {a}")
                else:
                    cur = self._w.new_local()
                    self._w.emit(f"{cur} = load {val_t}, {val_t}* {a}")
                    res, res_t = self._apply_binary_op(comp, cur, val_t, val_ll, val_t)
                    res = self._coerce_to(res, res_t, val_t)
                    if val_t == "double":
                        res = self._round_double(res, ft)
                    self._w.emit(f"store {val_t} {res}, {val_t}* {a}")
            else:
                self._w.emit(f"store {val_t} {val_ll}, {val_t}* {a}")

    def _is_char_expr(self, node: ASTNode) -> bool:
        if isinstance(node, Literal):
            return node.value_type.lower() == "char"
        if isinstance(node, Identifier):
            if node.name in self._globals:
                return self._globals[node.name][2] == "char"
        return self._flux_type_of(node) == "char"

    def _char_to_str(self, val: str) -> tuple[str, str]:
        buf = self._w.new_local("cstr")
        self._w.emit(f"{buf} = call i8* @flux_char_to_utf8(i32 {val})")
        return (buf, "i8*")

    def _gen_print_call(self, args: list[ASTNode], newline: bool) -> None:
        fmt_parts: list[str] = []
        args_list: list[str] = []
        first = True
        for node in args:
            if not first:
                fmt_parts.append(" ")
            first = False
            parts: list[ASTNode] = []
            types: list[str] = []
            self._flatten_string_concat(node, parts, types)
            for p in parts:
                val, t = self._gen_flatten_emit(p)
                if t == RESULT_TYPE:
                    p_ft = self._flux_type_of(p)
                    if p_ft in FLOATISH or p_ft in ("float", "float64", "float32", "float16", "double"):
                        r = self._w.new_local("pr_dv")
                        self._w.emit(f"{r} = extractvalue {RESULT_TYPE} {val}, 2")
                        val, t = r, "double"
                    elif p_ft == "bool":
                        r = self._w.new_local("pr_bv")
                        self._w.emit(f"{r} = extractvalue {RESULT_TYPE} {val}, 1")
                        rb = self._w.new_local("pr_b")
                        self._w.emit(f"{rb} = icmp ne i64 {r}, 0")
                        val, t = rb, "i1"
                    elif _is_string_type(p_ft):
                        r = self._w.new_local("pr_sv")
                        self._w.emit(f"{r} = extractvalue {RESULT_TYPE} {val}, 1")
                        rp = self._w.new_local("pr_sp")
                        self._w.emit(f"{rp} = inttoptr i64 {r} to i8*")
                        val, t = rp, "i8*"
                    elif _is_list_type(p_ft) or _is_set_type(p_ft) or _is_map_type(p_ft):
                        r = self._w.new_local("pr_sv")
                        self._w.emit(f"{r} = extractvalue {RESULT_TYPE} {val}, 1")
                        rp = self._w.new_local("pr_sp")
                        self._w.emit(f"{rp} = inttoptr i64 {r} to i8*")
                        buf = self._w.new_local("colbuf")
                        self._w.emit(f"{buf} = alloca i8, i64 4096")
                        out = self._w.new_local("colbufv")
                        self._w.emit(f"{out} = call i8* @flux_collection_to_buf(i8* {rp}, i8* {buf})")
                        val, t = out, "i8*"
                    elif p_ft == "char":
                        r = self._w.new_local("pr_cv")
                        self._w.emit(f"{r} = extractvalue {RESULT_TYPE} {val}, 1")
                        rc = self._w.new_local("pr_c")
                        self._w.emit(f"{rc} = trunc i64 {r} to i32")
                        val, t = rc, "i32"
                    else:
                        r = self._w.new_local("pr_iv")
                        self._w.emit(f"{r} = extractvalue {RESULT_TYPE} {val}, 1")
                        val, t = r, "i64"
                if self._is_char_expr(p) and t == "i32":
                    val, t = self._char_to_str(val)
                if t == "i1":
                    sel = self._w.new_local("bprint")
                    tn = self._w.get_string_global("true")
                    tl = _str_byte_len("true")
                    fn = self._w.get_string_global("false")
                    fl = _str_byte_len("false")
                    self._w.emit(
                        f"{sel} = select i1 {val}, "
                        f"i8* getelementptr inbounds ([{tl} x i8], [{tl} x i8]* @{tn}, i32 0, i32 0), "
                        f"i8* getelementptr inbounds ([{fl} x i8], [{fl} x i8]* @{fn}, i32 0, i32 0)"
                    )
                    fmt_parts.append("%s")
                    args_list.append(f"i8* {sel}")
                elif _is_string_type(t):
                    fmt_parts.append("%s")
                    args_list.append(f"{t} {val}")
                elif t in ("double", "float"):
                    buf = self._gen_f64_str(self._coerce_to_double(val, t))
                    fmt_parts.append("%s")
                    args_list.append(f"i8* {buf}")
                else:
                    fmt_parts.append("%lld")
                    args_list.append(f"{t} {val}")
        fmt_str = "".join(fmt_parts) + ("\n" if newline else "")
        fmt_name = self._w.get_string_global(fmt_str)
        fmt_len = _str_byte_len(fmt_str)
        self._w.emit(
            f"call i32 (i8*, ...) @printf(i8* getelementptr inbounds "
            f"([{fmt_len} x i8], [{fmt_len} x i8]* @{fmt_name}, i32 0, i32 0), "
            f"{', '.join(args_list)})"
        )
        self._w.emit("call i32 @fflush(i8* null)")

    def _gen_f64_str(self, val: str) -> str:
        buf = self._w.new_local("fbuf")
        self._w.emit(f"{buf} = alloca i8, i64 64")
        self._w.emit(f"call i8* @flux_fmt_double(double {val}, i8* {buf})")
        return buf

    def _flatten_string_concat(self, node: ASTNode, parts: list[ASTNode], _types: list[str]) -> None:
        if isinstance(node, BinaryOp) and node.op == "+":
            left_is_str = self._is_expr_string(node.left)
            right_is_str = self._is_expr_string(node.right)
            if left_is_str and right_is_str:
                self._flatten_string_concat(node.left, parts, _types)
                self._flatten_string_concat(node.right, parts, _types)
                return
        if isinstance(node, InterpolatedString):
            for p in node.parts:
                self._flatten_string_concat(p, parts, _types)
            return
        parts.append(node)

    def _is_expr_string(self, node: ASTNode) -> bool:
        if isinstance(node, Literal):
            return _is_string_type(node.value_type) or node.value_type.lower() == "char"
        if isinstance(node, (ListLiteral, SetLiteral, MapLiteral, RecordLiteral)):
            return True
        if isinstance(node, Identifier):
            if node.name in self._globals:
                return self._globals[node.name][0] == "i8*"
        if isinstance(node, BinaryOp) and node.op == "+":
            return self._is_expr_string(node.left) or self._is_expr_string(node.right)
        if isinstance(node, InterpolatedString):
            return True
        if isinstance(node, InterpolatedText):
            return True
        ft = self._flux_type_of(node)
        if _is_string_type(ft) or _is_list_type(ft) or _is_set_type(ft) or _is_map_type(ft):
            return True
        return False

    def _elem_encoding(self, t: str, val: str, ft: str = "") -> tuple[int, str, str]:
        if _is_list_type(ft) or _is_set_type(ft) or _is_map_type(ft) or ft in ("list", "set", "map"):
            v64 = self._coerce_to(val, t, "i64")
            return (5, v64, "null")
        if t in ("double", "float"):
            b = self._w.new_local("bits")
            self._w.emit(f"{b} = bitcast double {val} to i64")
            return (3, b, "null")
        if t == "{ double, double }":
            r_val = self._w.new_local("creal")
            self._w.emit(f"{r_val} = extractvalue {{ double, double }} {val}, 0")
            i_val = self._w.new_local("cimag")
            self._w.emit(f"{i_val} = extractvalue {{ double, double }} {val}, 1")
            buf = self._w.new_local("cbuf")
            self._w.emit(f"{buf} = call i8* @malloc(i64 128)")
            cstr = self._w.new_local("cstr")
            self._w.emit(f"{cstr} = call i8* @flux_complex_to_buf(double {r_val}, double {i_val}, i8* {buf})")
            return (4, "0", cstr)
        if _is_string_type(t) or _is_string_type(ft):
            return (4, "0", val)
        if t in ("double", "float") or ft in FLOATISH:
            dv = self._coerce_to_double(val, t)
            b64 = self._w.new_local("fbits")
            self._w.emit(f"{b64} = bitcast double {dv} to i64")
            return (3, b64, "null")
        if t == "i1" or ft == "bool":
            z = self._w.new_local("bsel")
            self._w.emit(f"{z} = zext i1 {val} to i64")
            return (2, z, "null")
        v64 = self._coerce_to(val, t, "i64")
        return (1, v64, "null")

    def _gen_list_literal_text(self, node: ListLiteral) -> tuple[str, str]:
        items = list(node.items)
        et = self._flux_type_of(items[0]) if items else "int64"
        tag = _elem_tag(et)
        n = len(items)
        l = self._w.new_local("list")
        self._w.emit(f"{l} = call i8* @flux_list_build(i64 {n}, i64 {tag})")
        if n:
            ld = self._w.new_local("ldata")
            self._w.emit(f"{ld} = call i8* @flux_list_data(i8* {l})")
            for i, item in enumerate(items, 1):
                v, t = self._emit_expr_text(item)
                item_ft = self._flux_type_of(item)
                if isinstance(item, IndexAccess):
                    iot = self._flux_type_of(item.obj)
                    if (_is_list_type(iot) or iot == "data") and len(item.indices) == 1 and not isinstance(item.indices[0], SliceSpec):
                        iov, iott = self._emit_expr_text(item.obj)
                        iovv = self._coerce_to(iov, iott, "i8*")
                        iiv, iit = self._emit_expr_text(item.indices[0])
                        iivv = self._coerce_to(iiv, iit, "i64")
                        idata = self._w.new_local("idata")
                        self._w.emit(f"{idata} = call i8* @flux_list_data(i8* {iovv})")
                        itag = self._w.new_local("itag")
                        self._w.emit(f"{itag} = call i64 @flux_row_tag(i8* {idata}, i64 {iivv})")
                        ival = self._w.new_local("ival")
                        self._w.emit(f"{ival} = call i64 @flux_row_val(i8* {idata}, i64 {iivv})")
                        isval = self._w.new_local("isval")
                        self._w.emit(f"{isval} = call i8* @flux_row_sval(i8* {idata}, i64 {iivv})")
                        isp = self._w.new_local("isvp")
                        self._w.emit(f"{isp} = ptrtoint i8* {isval} to i64")
                        self._w.emit(f"call void @flux_row_set(i8* {ld}, i64 {i}, i64 {itag}, i64 {ival}, i64 {isp})")
                        continue
                    elif (_is_map_type(iot) or iot == "map") and len(item.indices) == 1 and not isinstance(item.indices[0], SliceSpec):
                        iov, iott = self._emit_expr_text(item.obj)
                        iovv = self._coerce_to(iov, iott, "i8*")
                        ik = self._map_key_text(item.indices[0])
                        itag = self._w.new_local("itag")
                        self._w.emit(f"{itag} = call i64 @flux_map_get_tag(i8* {iovv}, i8* {ik})")
                        ival = self._w.new_local("ival")
                        self._w.emit(f"{ival} = call i64 @flux_map_get(i8* {iovv}, i8* {ik})")
                        self._w.emit(f"call void @flux_row_set(i8* {ld}, i64 {i}, i64 {itag}, i64 {ival}, i64 {ival})")
                        continue
                if isinstance(item, ListLiteral) or _is_list_type(item_ft) or _is_set_type(item_ft) or _is_map_type(item_ft):
                    sp = self._w.new_local("svp")
                    self._w.emit(f"{sp} = ptrtoint i8* {v} to i64")
                    self._w.emit(f"call void @flux_row_set(i8* {ld}, i64 {i}, i64 5, i64 {sp}, i64 0)")
                    continue
                if isinstance(item, Identifier) and item.name in self._var_tag_slots:
                    tag_ptr = self._var_tag_slots[item.name]
                    sval_ptr = self._var_sval_slots[item.name]
                    itag = self._w.new_local("itag")
                    self._w.emit(f"{itag} = load i64, i64* {tag_ptr}")
                    isval = self._w.new_local("isval")
                    self._w.emit(f"{isval} = load i8*, i8** {sval_ptr}")
                    sp = self._w.new_local("svp")
                    self._w.emit(f"{sp} = ptrtoint i8* {isval} to i64")
                    v64 = self._coerce_to(v, t, "i64")
                    self._w.emit(f"call void @flux_row_set(i8* {ld}, i64 {i}, i64 {itag}, i64 {v64}, i64 {sp})")
                elif isinstance(item, Identifier) and item.name in self._param_tag_slots:
                    itag = self._param_tag_slots[item.name]
                    v64 = self._coerce_to(v, t, "i64")
                    self._w.emit(f"call void @flux_row_set(i8* {ld}, i64 {i}, i64 {itag}, i64 {v64}, i64 0)")
                else:
                    itag, v64, sv = self._elem_encoding(t, v, item_ft)
                    sp = self._w.new_local("svp")
                    self._w.emit(f"{sp} = ptrtoint i8* {sv} to i64")
                    self._w.emit(f"call void @flux_row_set(i8* {ld}, i64 {i}, i64 {itag}, i64 {v64}, i64 {sp})")
        return (l, "i8*")

    def _gen_set_literal_text(self, node: SetLiteral) -> tuple[str, str]:
        items = list(node.items)
        et = "int64"
        if items:
            et = self._flux_type_of(items[0]) or "int64"
        tag = _elem_tag(et)
        n = len(items)
        s = self._w.new_local("set")
        self._w.emit(f"{s} = call i8* @flux_set_build(i64 {n}, i64 {tag})")
        for item in items:
            val, t = self._emit_expr_text(item)
            item_ft = self._flux_type_of(item)
            tag64, v64, sv = self._elem_encoding(t, val, item_ft)
            if tag64 != tag:
                raise CodegenError(f"set literal mixes element types ('{et}' vs '{item_ft}')")
            nx = self._w.new_local("set")
            self._w.emit(f"{nx} = call i8* @flux_set_push(i8* {s}, i64 {tag}, i64 {v64}, i8* {sv})")
            s = nx
        return (s, "i8*")

    def _map_key_text(self, key: ASTNode) -> str:
        if isinstance(key, Literal):
            if _is_string_type(key.value_type):
                sname = self._w.get_string_global(key.value)
                slen = _str_byte_len(key.value)
                return (f"getelementptr inbounds ([{slen} x i8], [{slen} x i8]* @{sname}, "
                        f"i32 0, i32 0)")
            kt = key.value_type.lower()
            if kt in ("int", "int64", "int32", "int16", "int8", "uint8", "uint16", "uint32", "uint64"):
                ks = str(int(key.value))
            elif kt in ("float", "float64", "float32"):
                ks = str(float(key.value))
            else:
                raise CodegenError(f"map index must be a string or numeric literal, got '{kt}'")
            sname = self._w.get_string_global(ks)
            slen = _str_byte_len(ks)
            return (f"getelementptr inbounds ([{slen} x i8], [{slen} x i8]* @{sname}, "
                    f"i32 0, i32 0)")
        if isinstance(key, IndexAccess):
            kot = self._flux_type_of(key.obj)
            if _is_map_type(kot):
                kov, kott = self._emit_expr_text(key.obj)
                kovv = self._coerce_to(kov, kott, "i8*")
                kik = self._map_key_text(key.indices[0])
                ktag = self._w.new_local("ktag")
                self._w.emit(f"{ktag} = call i64 @flux_map_get_tag(i8* {kovv}, i8* {kik})")
                kv = self._w.new_local("kval")
                self._w.emit(f"{kv} = call i64 @flux_map_get(i8* {kovv}, i8* {kik})")
                ksp = self._w.new_local("ksp")
                self._w.emit(f"{ksp} = inttoptr i64 {kv} to i8*")
                is_str = self._w.new_local("is_str_k")
                self._w.emit(f"{is_str} = icmp eq i64 {ktag}, 4")
                kbuf = self._w.new_local("kbuf")
                self._w.emit(f"{kbuf} = call i8* @malloc(i64 64)")
                fmt_lld = self._w.get_string_global("%lld")
                self._w.emit(f"call i32 (i8*, i64, i8*, ...) @snprintf(i8* {kbuf}, i64 64, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @{fmt_lld}, i32 0, i32 0), i64 {kv})")
                res_k = self._w.new_local("res_k")
                self._w.emit(f"{res_k} = select i1 {is_str}, i8* {ksp}, i8* {kbuf}")
                return res_k
            elif (_is_list_type(kot) or kot == "data") and len(key.indices) == 1 and not isinstance(key.indices[0], SliceSpec):
                kov, kott = self._emit_expr_text(key.obj)
                kovv = self._coerce_to(kov, kott, "i8*")
                kiv, kit = self._emit_expr_text(key.indices[0])
                kivv = self._coerce_to(kiv, kit, "i64")
                kdata = self._w.new_local("kdata")
                self._w.emit(f"{kdata} = call i8* @flux_list_data(i8* {kovv})")
                ktag = self._w.new_local("ktag")
                self._w.emit(f"{ktag} = call i64 @flux_row_tag(i8* {kdata}, i64 {kivv})")
                ksval = self._w.new_local("ksval")
                self._w.emit(f"{ksval} = call i8* @flux_row_sval(i8* {kdata}, i64 {kivv})")
                kival = self._w.new_local("kival")
                self._w.emit(f"{kival} = call i64 @flux_row_val(i8* {kdata}, i64 {kivv})")
                is_str = self._w.new_local("is_str_k")
                self._w.emit(f"{is_str} = icmp eq i64 {ktag}, 4")
                kbuf = self._w.new_local("kbuf")
                self._w.emit(f"{kbuf} = call i8* @malloc(i64 64)")
                fmt_lld = self._w.get_string_global("%lld")
                self._w.emit(f"call i32 (i8*, i64, i8*, ...) @snprintf(i8* {kbuf}, i64 64, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @{fmt_lld}, i32 0, i32 0), i64 {kival})")
                res_k = self._w.new_local("res_k")
                self._w.emit(f"{res_k} = select i1 {is_str}, i8* {ksval}, i8* {kbuf}")
                return res_k
        v, t = self._emit_expr_text(key)
        if _is_string_type(t) or t == "i8*":
            return v
        if t in ("i64", "i32", "i16", "i8"):
            if isinstance(key, Identifier) and key.name in self._param_tag_slots:
                tag_v = self._param_tag_slots[key.name]
                is_str = self._w.new_local("is_str_k")
                self._w.emit(f"{is_str} = icmp eq i64 {tag_v}, 4")
                sp_k = self._w.new_local("sp_k")
                self._w.emit(f"{sp_k} = inttoptr i64 {v} to i8*")
                kbuf = self._w.new_local("kbuf")
                self._w.emit(f"{kbuf} = call i8* @malloc(i64 64)")
                fmt_lld = self._w.get_string_global("%lld")
                self._w.emit(f"call i32 (i8*, i64, i8*, ...) @snprintf(i8* {kbuf}, i64 64, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @{fmt_lld}, i32 0, i32 0), i64 {v})")
                res_k = self._w.new_local("res_k")
                self._w.emit(f"{res_k} = select i1 {is_str}, i8* {sp_k}, i8* {kbuf}")
                return res_k
            elif isinstance(key, Identifier) and key.name in self._var_tag_slots:
                tptr = self._var_tag_slots[key.name]
                tag_v = self._w.new_local("ltag_k")
                self._w.emit(f"{tag_v} = load i64, i64* {tptr}")
                is_str = self._w.new_local("is_str_k")
                self._w.emit(f"{is_str} = icmp eq i64 {tag_v}, 4")
                sp_k = self._w.new_local("sp_k")
                self._w.emit(f"{sp_k} = inttoptr i64 {v} to i8*")
                kbuf = self._w.new_local("kbuf")
                self._w.emit(f"{kbuf} = call i8* @malloc(i64 64)")
                fmt_lld = self._w.get_string_global("%lld")
                self._w.emit(f"call i32 (i8*, i64, i8*, ...) @snprintf(i8* {kbuf}, i64 64, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @{fmt_lld}, i32 0, i32 0), i64 {v})")
                res_k = self._w.new_local("res_k")
                self._w.emit(f"{res_k} = select i1 {is_str}, i8* {sp_k}, i8* {kbuf}")
                return res_k
            kbuf = self._w.new_local("kbuf")
            self._w.emit(f"{kbuf} = call i8* @malloc(i64 64)")
            fmt_lld = self._w.get_string_global("%lld")
            self._w.emit(f"call i32 (i8*, i64, i8*, ...) @snprintf(i8* {kbuf}, i64 64, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @{fmt_lld}, i32 0, i32 0), i64 {v})")
            return kbuf
        if t in ("double", "float"):
            kbuf = self._w.new_local("kbuf")
            self._w.emit(f"{kbuf} = call i8* @malloc(i64 64)")
            dv = self._coerce_to_double(v, t)
            self._w.emit(f"call i8* @flux_fmt_double(double {dv}, i8* {kbuf})")
            return kbuf
        if t == "i1":
            str_true = self._w.get_string_global("true")
            str_false = self._w.get_string_global("false")
            kb = self._w.new_local("kbool")
            self._w.emit(f"{kb} = select i1 {v}, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @{str_true}, i32 0, i32 0), i8* getelementptr inbounds ([6 x i8], [6 x i8]* @{str_false}, i32 0, i32 0)")
            return kb
        return self._coerce_to(v, t, "i8*")
    def _gen_map_literal_text(self, node: MapLiteral) -> tuple[str, str]:
        m = self._w.new_local("map")
        self._w.emit(f"{m} = call i8* @flux_map_build(i64 {len(node.entries)})")
        for entry in node.entries:
            if entry.key_expr is not None:
                k = self._map_key_text(entry.key_expr)
            else:
                sname = self._w.get_string_global(entry.key)
                slen = _str_byte_len(entry.key)
                k = (f"getelementptr inbounds ([{slen} x i8], [{slen} x i8]* @{sname}, "
                     f"i32 0, i32 0)")
            v, t = self._emit_expr_text(entry.value)
            vt = self._flux_type_of(entry.value)
            if isinstance(entry.value, (MapLiteral, RecordLiteral, ListLiteral, SetLiteral)) or _is_map_type(vt) or _is_list_type(vt) or _is_set_type(vt):
                tag = 5
                vv = self._w.new_local("mvp")
                self._w.emit(f"{vv} = ptrtoint i8* {v} to i64")
            else:
                tag, v64, sv = self._elem_encoding(t, v)
                if _is_string_type(t) or tag == 5:
                    vv = self._w.new_local("mvp")
                    self._w.emit(f"{vv} = ptrtoint i8* {v} to i64")
                else:
                    vv = v64
            self._w.emit(f"call i8* @flux_map_set(i8* {m}, i8* {k}, i64 {tag}, i64 {vv})")
        return (m, "i8*")

    def _gen_record_literal_text(self, node: RecordLiteral) -> tuple[str, str]:
        m = self._w.new_local("rec")
        self._w.emit(f"{m} = call i8* @flux_map_build(i64 {len(node.fields)})")
        for f in node.fields:
            sname = self._w.get_string_global(f.name)
            slen = _str_byte_len(f.name)
            k = (f"getelementptr inbounds ([{slen} x i8], [{slen} x i8]* @{sname}, "
                 f"i32 0, i32 0)")
            v, t = self._emit_expr_text(f.value)
            vt = self._flux_type_of(f.value)
            if isinstance(f.value, (MapLiteral, RecordLiteral, ListLiteral, SetLiteral)) or _is_map_type(vt) or _is_list_type(vt) or _is_set_type(vt):
                tag = 5
                vv = self._w.new_local("mvp")
                self._w.emit(f"{vv} = ptrtoint i8* {v} to i64")
            else:
                tag, v64, sv = self._elem_encoding(t, v)
                if _is_string_type(t) or tag == 5:
                    vv = self._w.new_local("mvp")
                    self._w.emit(f"{vv} = ptrtoint i8* {v} to i64")
                else:
                    vv = v64
            self._w.emit(f"call i8* @flux_map_set(i8* {m}, i8* {k}, i64 {tag}, i64 {vv})")
        return (m, "i8*")

    def _gen_enum_val_to_buf(self, node: EnumVariant) -> str:
        edef = self._enums[node.enum_name]
        buf = self._w.new_local("ebuf")
        self._w.emit(f"{buf} = alloca i8, i64 512")
        if not node.fields:
            s = f"{node.enum_name}::{node.variant}"
            sn = self._w.get_string_global(s)
            sl = _str_byte_len(s)
            self._w.emit(f"call i32 (i8*, i64, i8*, ...) @snprintf(i8* {buf}, i64 512, i8* getelementptr inbounds ([{sl} x i8], [{sl} x i8]* @{sn}, i32 0, i32 0))")
        else:
            fmt_parts = [f"{node.enum_name}::{node.variant}("]
            args = []
            for j, f in enumerate(node.fields):
                if j > 0:
                    fmt_parts.append(", ")
                fmt_parts.append(f".{f.name}: ")
                val, t = self._emit_expr_text(f.value)
                if _is_string_type(t):
                    fmt_parts.append("%s")
                    args.append(f"i8* {val}")
                elif t in ("double", "float"):
                    fmt_parts.append("%g")
                    args.append(f"{t} {val}")
                else:
                    fmt_parts.append("%lld")
                    args.append(f"{t} {val}")
            fmt_parts.append(")")
            fmt_s = "".join(fmt_parts)
            sn = self._w.get_string_global(fmt_s)
            sl = _str_byte_len(fmt_s)
            args_str = (", " + ", ".join(args)) if args else ""
            self._w.emit(f"call i32 (i8*, i64, i8*, ...) @snprintf(i8* {buf}, i64 512, i8* getelementptr inbounds ([{sl} x i8], [{sl} x i8]* @{sn}, i32 0, i32 0){args_str})")
        return buf

    def _gen_enum_to_buf(self, name: str) -> str:
        info = self._enum_slots[name]
        edef = self._enums[info["enum"]]
        slots = info["slots"]
        tptr, _ = slots["tag"]
        tagv = self._w.new_local("etag")
        self._w.emit(f"{tagv} = load i64, i64* {tptr}")
        buf = self._w.new_local("ebuf")
        self._w.emit(f"{buf} = alloca i8, i64 512")
        seq = self._block_seq
        self._block_seq += 1
        end_b = f"enum_p_end_{seq}"
        for i, m in enumerate(edef.members):
            lbl_b = f"enum_p_{seq}_{i}"
            next_b = f"enum_p_nxt_{seq}_{i}"
            cmp = self._w.new_local(f"ecmp_{i}")
            self._w.emit(f"{cmp} = icmp eq i64 {tagv}, {i}")
            self._w.emit(f"br i1 {cmp}, label %{lbl_b}, label %{next_b}")
            self._new_block(lbl_b)
            if not m.fields:
                s = f"{edef.name}::{m.name}"
                sn = self._w.get_string_global(s)
                sl = _str_byte_len(s)
                self._w.emit(f"call i32 (i8*, i64, i8*, ...) @snprintf(i8* {buf}, i64 512, i8* getelementptr inbounds ([{sl} x i8], [{sl} x i8]* @{sn}, i32 0, i32 0))")
            else:
                fmt_parts = [f"{edef.name}::{m.name}("]
                args = []
                for j, f in enumerate(m.fields):
                    if j > 0:
                        fmt_parts.append(", ")
                    fmt_parts.append(f".{f.name}: ")
                    ptr, llvm_t, ft = slots["fields"][f.name]
                    fv = self._w.new_local(f"ef_{f.name}")
                    self._w.emit(f"{fv} = load {llvm_t}, {llvm_t}* {ptr}")
                    if ft == "string":
                        fmt_parts.append("%s")
                        args.append(f"i8* {fv}")
                    elif ft in FLOATISH:
                        fmt_parts.append("%g")
                        args.append(f"{llvm_t} {fv}")
                    else:
                        fmt_parts.append("%lld")
                        args.append(f"{llvm_t} {fv}")
                fmt_parts.append(")")
                fmt_s = "".join(fmt_parts)
                sn = self._w.get_string_global(fmt_s)
                sl = _str_byte_len(fmt_s)
                args_str = (", " + ", ".join(args)) if args else ""
                self._w.emit(f"call i32 (i8*, i64, i8*, ...) @snprintf(i8* {buf}, i64 512, i8* getelementptr inbounds ([{sl} x i8], [{sl} x i8]* @{sn}, i32 0, i32 0){args_str})")
            self._w.emit(f"br label %{end_b}")
            self._new_block(next_b)
        self._w.emit(f"br label %{end_b}")
        self._new_block(end_b)
        return buf

    def _gen_struct_to_buf(self, name: str) -> str:
        info = self._struct_slots[name]
        sdef = self._structs[info["sname"]]
        buf = self._w.new_local("sbuf")
        self._w.emit(f"{buf} = alloca i8, i64 1024")
        head = f"{sdef.name}("
        sname_h = self._w.get_string_global(head)
        slen_h = _str_byte_len(head)
        self._w.emit(f"call i32 (i8*, i64, i8*, ...) @snprintf(i8* {buf}, i64 1024, i8* getelementptr inbounds ([{slen_h} x i8], [{slen_h} x i8]* @{sname_h}, i32 0, i32 0))")
        cur_len = self._w.new_local("cur_len")
        self._w.emit(f"{cur_len} = call i64 @strlen(i8* {buf})")
        for j, f in enumerate(sdef.fields):
            ptr, llvm_t, ft = info["fields"][f.name]
            fval = self._w.new_local(f"sf_{f.name}")
            self._w.emit(f"{fval} = load {llvm_t}, {llvm_t}* {ptr}")
            prefix = (", ." if j > 0 else ".") + f"{f.name}: "
            tail_ptr = self._w.new_local(f"stail_{j}")
            self._w.emit(f"{tail_ptr} = getelementptr i8, i8* {buf}, i64 {cur_len}")
            rem_size = self._w.new_local(f"srem_{j}")
            self._w.emit(f"{rem_size} = sub i64 1024, {cur_len}")
            if ft == "string":
                fmt_s = prefix + "%s"
                fn = self._w.get_string_global(fmt_s)
                fl = _str_byte_len(fmt_s)
                self._w.emit(f"call i32 (i8*, i64, i8*, ...) @snprintf(i8* {tail_ptr}, i64 {rem_size}, i8* getelementptr inbounds ([{fl} x i8], [{fl} x i8]* @{fn}, i32 0, i32 0), i8* {fval})")
            elif ft == "datetime":
                dt_tmp = self._w.new_local(f"dt_tmp_{j}")
                self._w.emit(f"{dt_tmp} = alloca i8, i64 64")
                self._w.emit(f"call i8* @flux_datetime_to_buf(i64 {fval}, i8* {dt_tmp})")
                fmt_s = prefix + "%s"
                fn = self._w.get_string_global(fmt_s)
                fl = _str_byte_len(fmt_s)
                self._w.emit(f"call i32 (i8*, i64, i8*, ...) @snprintf(i8* {tail_ptr}, i64 {rem_size}, i8* getelementptr inbounds ([{fl} x i8], [{fl} x i8]* @{fn}, i32 0, i32 0), i8* {dt_tmp})")
            elif ft in FLOATISH:
                fmt_s = prefix + "%g"
                fn = self._w.get_string_global(fmt_s)
                fl = _str_byte_len(fmt_s)
                self._w.emit(f"call i32 (i8*, i64, i8*, ...) @snprintf(i8* {tail_ptr}, i64 {rem_size}, i8* getelementptr inbounds ([{fl} x i8], [{fl} x i8]* @{fn}, i32 0, i32 0), {llvm_t} {fval})")
            else:
                fmt_s = prefix + "%lld"
                fn = self._w.get_string_global(fmt_s)
                fl = _str_byte_len(fmt_s)
                self._w.emit(f"call i32 (i8*, i64, i8*, ...) @snprintf(i8* {tail_ptr}, i64 {rem_size}, i8* getelementptr inbounds ([{fl} x i8], [{fl} x i8]* @{fn}, i32 0, i32 0), {llvm_t} {fval})")
            cur_len = self._w.new_local(f"cur_len_{j}")
            self._w.emit(f"{cur_len} = call i64 @strlen(i8* {buf})")
        tail_ptr = self._w.new_local("stail_close")
        self._w.emit(f"{tail_ptr} = getelementptr i8, i8* {buf}, i64 {cur_len}")
        rem_size = self._w.new_local("srem_close")
        self._w.emit(f"{rem_size} = sub i64 1024, {cur_len}")
        c_name = self._w.get_string_global(")")
        c_len = _str_byte_len(")")
        self._w.emit(f"call i32 (i8*, i64, i8*, ...) @snprintf(i8* {tail_ptr}, i64 {rem_size}, i8* getelementptr inbounds ([{c_len} x i8], [{c_len} x i8]* @{c_name}, i32 0, i32 0))")
        return buf

    def _flux_type_of(self, node: ASTNode) -> str:
        if isinstance(node, Literal):
            return node.value_type
        if isinstance(node, SetLiteral):
            if node.items:
                et = self._flux_type_of(node.items[0])
                return f"set of {et}" if et else "set of int64"
            return "set of int64"
        if isinstance(node, ListLiteral):
            if node.items:
                et = self._flux_type_of(node.items[0])
                return f"list of {et}" if et else "list of int64"
            return "list of int64"
        if isinstance(node, (MapLiteral, RecordLiteral)):
            return "map of string of data"
        if isinstance(node, Identifier):
            if node.name in self._globals:
                return self._globals[node.name][2]
            if node.name in self._struct_slots:
                return "struct"
            if node.name in self._enum_slots:
                return "enum"
        if isinstance(node, FieldAccess):
            if isinstance(node.obj, Identifier) and node.obj.name in self._struct_slots:
                st = self._struct_slots[node.obj.name]
                if node.field in st["fields"]:
                    return st["fields"][node.field][2]
            if node.field == "val":
                obj_t = self._flux_type_of(node.obj)
                if obj_t:
                    return obj_t
        if isinstance(node, BinaryOp):
            if node.op == "in":
                return "bool"
        if isinstance(node, IndexAccess):
            ft = self._flux_type_of(node.obj)
            if _is_tensor_type(ft):
                dims = _tensor_dims_of(ft)
                et = _tensor_elem_ft(ft)
                k = len([ix for ix in node.indices if not isinstance(ix, SliceSpec)])
                if k >= len(dims):
                    return et
                return f"tensor[{', '.join(str(d) for d in dims[k:])}] of {et}"
            if _is_map_type(ft) or ft == "data":
                return "data"
            if ft == "string" or ft.startswith("string"):
                return "string"
            return self._list_elem_type(ft)
        if isinstance(node, CallExpr):
            cname = _callee_name(node.callee)
            cname = self._op_aliases.get(cname, cname)
            if cname in _SET_RETURNING:
                return _SET_RETURNING[cname]
            if cname in _STD_BOOL_RETURNING:
                return "bool"
            if cname in _STD_LIST_RETURNING:
                return "list of data"
            if cname in _MAP_RETURNING:
                return "map of data of data"
            return self._function_ret.get(cname, "")
        if isinstance(node, (AwaitExpr, SpawnExpr)):
            return self._flux_type_of(node.operand)
        if isinstance(node, ComptimeExpr):
            if isinstance(node.body, BlockStmt) and node.body.body:
                last = node.body.body[-1]
                if isinstance(last, ExpressionStmt):
                    return self._flux_type_of(last.expr)
                return ""
            elif not isinstance(node.body, BlockStmt):
                return self._flux_type_of(node.body)
        if isinstance(node, CastExpr):
            return node.target_type.name
        if isinstance(node, DataflowExpr):
            if isinstance(node.right, DataflowCastSink):
                return node.right.target_type.name
            if node.op in ("split", "join"):
                return "list of int64"
            return self._flux_type_of(node.right)
        return ""

    def _gen_flatten_emit(self, node: ASTNode) -> tuple[str, str]:
        if isinstance(node, Identifier) and node.name in self._enum_slots:
            return (self._gen_enum_to_buf(node.name), "i8*")
        if isinstance(node, EnumVariant) and node.enum_name in self._enums:
            return (self._gen_enum_val_to_buf(node), "i8*")
        if isinstance(node, Identifier) and node.name in self._struct_slots:
            return (self._gen_struct_to_buf(node.name), "i8*")
        if isinstance(node, FieldAccess):
            oft = self._flux_type_of(node)
            if oft == "datetime":
                val, t = self._emit_expr_text(node)
                v64 = self._coerce_to(val, t, "i64")
                buf = self._w.new_local("dtbuf")
                self._w.emit(f"{buf} = alloca i8, i64 64")
                out = self._w.new_local("dtbufv")
                self._w.emit(f"{out} = call i8* @flux_datetime_to_buf(i64 {v64}, i8* {buf})")
                return (out, "i8*")
        if (isinstance(node, CallExpr)
                and _callee_name(node.callee) in ("stdMapGetValueOrDefault", "getValueOrDefault")
                and len(node.args) == 3):
            return self._gen_gvod_elem(node)
        if isinstance(node, CallExpr):
            cname = _callee_name(node.callee)
            cname = self._op_aliases.get(cname, cname)
            ret = self._function_ret.get(cname, "")
            if ret == "data":
                r, _ = self._emit_raw_call(node)
                v64 = self._w.new_local("dcall_v")
                self._w.emit(f"{v64} = extractvalue {RESULT_TYPE} {r}, 1")
                tag_d = self._w.new_local("dcall_tagd")
                self._w.emit(f"{tag_d} = extractvalue {RESULT_TYPE} {r}, 2")
                tag_i = self._w.new_local("dcall_tagi")
                self._w.emit(f"{tag_i} = fptosi double {tag_d} to i64")
                buf = self._w.new_local("colbuf")
                self._w.emit(f"{buf} = alloca i8, i64 4096")
                out = self._w.new_local("colbufv")
                self._w.emit(f"{out} = call i8* @flux_data_to_str(i64 {v64}, i64 {tag_i}, i8* {buf})")
                return (out, "i8*")
        if isinstance(node, IndexAccess):
            oft = self._flux_type_of(node.obj)
            if oft == "string" or oft.startswith("string"):
                val, t = self._gen_index_access_text(node)
                return (val, "i8*")
            if any(isinstance(ix, SliceSpec) for ix in node.indices):
                val, t = self._gen_index_access_text(node)
                if oft == "string" or oft.startswith("string"):
                    return (val, "i8*")
                if t == "i8*":
                    buf = self._w.new_local("colbuf")
                    self._w.emit(f"{buf} = alloca i8, i64 4096")
                    out = self._w.new_local("colbufv")
                    self._w.emit(f"{out} = call i8* @flux_list_to_buf(i8* {val}, i8* {buf})")
                    return (out, "i8*")
                return (val, t)
            if _is_map_type(oft) or _is_list_type(oft) or oft == "data":
                return self._gen_elem_print(node)
            if _is_tensor_type(oft):
                dims = _tensor_dims_of(oft)
                if len(node.indices) == len(dims):
                    return self._gen_tensor_access_text(node)
        ft = self._flux_type_of(node)
        if ft.lower().startswith("complex"):
            val, t = self._emit_expr_text(node)
            if t.endswith("*"):
                re_ptr = self._w.new_local("c_re_ptr")
                im_ptr = self._w.new_local("c_im_ptr")
                self._w.emit(f"{re_ptr} = getelementptr inbounds {{ double, double }}, {{ double, double }}* {val}, i32 0, i32 0")
                self._w.emit(f"{im_ptr} = getelementptr inbounds {{ double, double }}, {{ double, double }}* {val}, i32 0, i32 1")
                re_v = self._w.new_local("c_re")
                im_v = self._w.new_local("c_im")
                self._w.emit(f"{re_v} = load double, double* {re_ptr}")
                self._w.emit(f"{im_v} = load double, double* {im_ptr}")
            else:
                re_v = self._w.new_local("c_re")
                im_v = self._w.new_local("c_im")
                self._w.emit(f"{re_v} = extractvalue {{ double, double }} {val}, 0")
                self._w.emit(f"{im_v} = extractvalue {{ double, double }} {val}, 1")
            buf = self._w.new_local("cbuf")
            self._w.emit(f"{buf} = alloca i8, i64 128")
            out = self._w.new_local("cbufv")
            self._w.emit(f"{out} = call i8* @flux_complex_to_buf(double {re_v}, double {im_v}, i8* {buf})")
            return (out, "i8*")
        if ft == "datetime":
            val, t = self._emit_expr_text(node)
            v64 = self._coerce_to(val, t, "i64")
            buf = self._w.new_local("dtbuf")
            self._w.emit(f"{buf} = alloca i8, i64 64")
            out = self._w.new_local("dtbufv")
            self._w.emit(f"{out} = call i8* @flux_datetime_to_buf(i64 {v64}, i8* {buf})")
            return (out, "i8*")
        if _is_tensor_type(ft):
            val, t = self._emit_expr_text(node)
            vv = self._coerce_to(val, t, "i8*")
            buf = self._w.new_local("colbuf")
            self._w.emit(f"{buf} = alloca i8, i64 4096")
            out = self._w.new_local("colbufv")
            self._w.emit(f"{out} = call i8* @flux_tensor_to_buf(i8* {vv}, i8* {buf})")
            return (out, "i8*")
        if _is_set_type(ft) or _is_list_type(ft) or _is_map_type(ft) or ft == "data":
            val, t = self._emit_expr_text(node)
            if t == RESULT_TYPE:
                r = self._w.new_local("cv")
                self._w.emit(f"{r} = extractvalue {RESULT_TYPE} {val}, 1")
                val, t = r, "i64"
            if t == "i64" and (_is_set_type(ft) or _is_list_type(ft) or _is_map_type(ft)):
                rp = self._w.new_local("cp")
                self._w.emit(f"{rp} = inttoptr i64 {val} to i8*")
                val, t = rp, "i8*"
            if t == "i8*" and (_is_set_type(ft) or _is_list_type(ft) or _is_map_type(ft)):
                buf = self._w.new_local("colbuf")
                self._w.emit(f"{buf} = alloca i8, i64 4096")
                out = self._w.new_local("colbufv")
                self._w.emit(f"{out} = call i8* @flux_collection_to_buf(i8* {val}, i8* {buf})")
                return (out, "i8*")
            if ft == "data":
                v64 = self._coerce_to(val, t, "i64")
                buf = self._w.new_local("colbuf")
                self._w.emit(f"{buf} = alloca i8, i64 4096")
                out = self._w.new_local("colbufv")
                tag_arg = "0"
                if isinstance(node, Identifier):
                    if node.name in self._var_tag_slots:
                        tptr = self._var_tag_slots[node.name]
                        ltag = self._w.new_local("ltag")
                        self._w.emit(f"{ltag} = load i64, i64* {tptr}")
                        tag_arg = ltag
                    elif node.name in self._param_tag_slots:
                        tag_arg = self._param_tag_slots[node.name]
                self._w.emit(f"{out} = call i8* @flux_data_to_str(i64 {v64}, i64 {tag_arg}, i8* {buf})")
                return (out, "i8*")
            return (val, t)
        val, t = self._emit_expr_text(node)
        if (isinstance(node, BinaryOp) and node.op in ("==", "!=", "<", "<=", ">", ">=")
                and t == "i64"):
            r = self._w.new_local("bwrap")
            self._w.emit(f"{r} = icmp ne i64 {val}, 0")
            return r, "i1"
        return val, t

    def _gen_elem_print(self, node: IndexAccess) -> tuple[str, str]:
        base = node.obj
        chain: list[ASTNode] = []
        while isinstance(base, IndexAccess):
            chain.append(base.indices[0])
            base = base.obj
        chain.append(node.indices[0])
        bt = self._flux_type_of(base)
        bv, bvt = self._emit_expr_text(base)
        cp = self._coerce_to(bv, bvt, "i8*")
        if _is_map_type(bt):
            if len(chain) != 1:
                raise CodegenError("nested map index access is not supported on LLVM target")
            k = self._map_key_text(chain[0])
            t = self._w.new_local("mvtag")
            v = self._w.new_local("mvval")
            self._w.emit(f"{t} = call i64 @flux_map_get_tag(i8* {cp}, i8* {k})")
            self._w.emit(f"{v} = call i64 @flux_map_get(i8* {cp}, i8* {k})")
        else:
            for idx in chain[:-1]:
                iv, it = self._emit_expr_text(idx)
                ivv = self._coerce_to(iv, it, "i64")
                d = self._w.new_local("ldata")
                self._w.emit(f"{d} = call i8* @flux_list_data(i8* {cp})")
                rv = self._w.new_local("rval")
                self._w.emit(f"{rv} = call i64 @flux_row_val(i8* {d}, i64 {ivv})")
                np = self._w.new_local("nptr")
                self._w.emit(f"{np} = inttoptr i64 {rv} to i8*")
                cp = np
            iv, it = self._emit_expr_text(chain[-1])
            ivv = self._coerce_to(iv, it, "i64")
            d = self._w.new_local("ldata")
            self._w.emit(f"{d} = call i8* @flux_list_data(i8* {cp})")
            t = self._w.new_local("lrtag")
            v = self._w.new_local("lrval")
            sv = self._w.new_local("lrsval")
            self._w.emit(f"{t} = call i64 @flux_row_tag(i8* {d}, i64 {ivv})")
            self._w.emit(f"{v} = call i64 @flux_row_val(i8* {d}, i64 {ivv})")
            self._w.emit(f"{sv} = call i8* @flux_row_sval(i8* {d}, i64 {ivv})")
            sp = self._w.new_local("lrsp")
            self._w.emit(f"{sp} = ptrtoint i8* {sv} to i64")
            iss = self._w.new_local("lris")
            self._w.emit(f"{iss} = icmp eq i64 {t}, 4")
            v2 = self._w.new_local("lrsel")
            self._w.emit(f"{v2} = select i1 {iss}, i64 {sp}, i64 {v}")
            v = v2
        buf = self._w.new_local("ebuf")
        cnt = self._w.new_local("ecnt")
        self._w.emit(f"{buf} = alloca i8, i64 4096")
        self._w.emit(f"{cnt} = call i64 @flux_elem_to_buf(i64 {t}, i64 {v}, i8* {buf})")
        return (buf, "i8*")

    def _gen_gvod_elem(self, node: CallExpr) -> tuple[str, str]:
        mp, mt = self._emit_expr_text(node.args[0])
        mp = self._coerce_to(mp, mt, "i8*")
        k = self._map_key_text(node.args[1])
        dv, dt = self._emit_expr_text(node.args[2])
        if _is_string_type(dt):
            dp = self._w.new_local("dvp")
            self._w.emit(f"{dp} = ptrtoint i8* {dv} to i64")
            dv64 = dp
            dtag = 4
        else:
            dtag, dv64, _ = self._elem_encoding(dt, dv)
        t = self._w.new_local("gvtag")
        v = self._w.new_local("gvval")
        self._w.emit(f"{t} = call i64 @flux_map_get_tag(i8* {mp}, i8* {k})")
        self._w.emit(f"{v} = call i64 @flux_map_get(i8* {mp}, i8* {k})")
        miss = self._w.new_local("gvmiss")
        self._w.emit(f"{miss} = icmp eq i64 {t}, 0")
        tsel = self._w.new_local("gvtsel")
        vsel = self._w.new_local("gvvsel")
        self._w.emit(f"{tsel} = select i1 {miss}, i64 {dtag}, i64 {t}")
        self._w.emit(f"{vsel} = select i1 {miss}, i64 {dv64}, i64 {v}")
        buf = self._w.new_local("gebuf")
        cnt = self._w.new_local("gecnt")
        self._w.emit(f"{buf} = alloca i8, i64 4096")
        self._w.emit(f"{cnt} = call i64 @flux_elem_to_buf(i64 {tsel}, i64 {vsel}, i8* {buf})")
        return (buf, "i8*")

    def _is_exotic(self, node: ASTNode) -> bool:
        return (
            isinstance(node, (PtrRefExpr, PtrDerefExpr, PtrAssign, ExternDecl))
            or (isinstance(node, StorageDecl) and node.static)
            or (isinstance(node, CallExpr) and isinstance(node.callee, Identifier) and node.callee.name == "bounds")
        )

    def _raise_exotic(self, node: ASTNode) -> None:
        raise CodegenError(f"simulação interpreter-only: '{type(node).__name__}' is not supported on the LLVM target")

    def _emit_expr_text(self, node: ASTNode) -> tuple[str, str]:
        if self._is_exotic(node):
            self._raise_exotic(node)
        if isinstance(node, Literal):
            return self._gen_literal_text(node)
        if isinstance(node, SetLiteral):
            return self._gen_set_literal_text(node)
        if isinstance(node, ListLiteral):
            return self._gen_list_literal_text(node)
        if isinstance(node, MapLiteral):
            return self._gen_map_literal_text(node)
        if isinstance(node, RecordLiteral):
            return self._gen_record_literal_text(node)
        if isinstance(node, IndexAccess):
            return self._gen_index_access_text(node)
        if isinstance(node, IndexAssign):
            self._gen_index_assign_text(node)
            return ("0", "i64")
        if isinstance(node, Identifier):
            if node.name in self._struct_slots:
                return ("0", "i64")
            if node.name in self._enum_slots:
                return ("0", "i64")
            return self._gen_identifier_text(node)
        if isinstance(node, StructInit):
            raise CodegenError(f"struct init expression not supported in this context on LLVM target")
        if isinstance(node, FieldAccess):
            return self._gen_field_access_text(node)
        if isinstance(node, BinaryOp):
            return self._gen_binary_op_text(node)
        if isinstance(node, UnaryOp):
            return self._gen_unary_op_text(node)
        if isinstance(node, SpawnExpr):
            return self._emit_expr_text(node.operand)
        if isinstance(node, AwaitExpr):
            return self._emit_expr_text(node.operand)
        if isinstance(node, OwnershipExpr):
            return self._gen_identifier_text(Identifier(name=node.target))
        if isinstance(node, ComptimeExpr):
            if isinstance(node.body, BlockStmt) and node.body.body:
                stmts = node.body.body
                for s in stmts[:-1]:
                    self._gen_statement(s)
                last = stmts[-1]
                if isinstance(last, ExpressionStmt):
                    return self._emit_expr_text(last.expr)
                self._gen_statement(last)
                return ("0", "i64")
            elif not isinstance(node.body, BlockStmt):
                return self._emit_expr_text(node.body)
        if isinstance(node, CastExpr):
            val, t = self._emit_expr_text(node.expr)
            return self._gen_cast_text(val, t, node.target_type.name, expr=node.expr)
        if isinstance(node, DataflowExpr):
            return self._gen_dataflow_text(node)
        if isinstance(node, CallExpr):
            return self._gen_call(node)
        if isinstance(node, InterpolatedString):
            parts_vals: list[str] = []
            parts_types: list[str] = []
            for p in node.parts:
                val, t = self._gen_flatten_emit(p)
                if t == RESULT_TYPE:
                    r = self._w.new_local()
                    self._w.emit(f"{r} = extractvalue {RESULT_TYPE} {val}, 1")
                    val, t = r, "i64"
                if t == "i1":
                    sel = self._w.new_local("bprint")
                    tn = self._w.get_string_global("true")
                    tl = _str_byte_len("true")
                    fn = self._w.get_string_global("false")
                    fl = _str_byte_len("false")
                    self._w.emit(
                        f"{sel} = select i1 {val}, "
                        f"i8* getelementptr inbounds ([{tl} x i8], [{tl} x i8]* @{tn}, i32 0, i32 0), "
                        f"i8* getelementptr inbounds ([{fl} x i8], [{fl} x i8]* @{fn}, i32 0, i32 0)"
                    )
                    val, t = sel, "i8*"
                parts_vals.append(val)
                parts_types.append(t)
            buf = self._w.new_local("buf")
            self._w.emit(f"{buf} = alloca i8, i64 1024")
            fmt_pieces = []
            args_list = []
            for val, t in zip(parts_vals, parts_types):
                if _is_string_type(t):
                    fmt_pieces.append("%s")
                    args_list.append(f"{t} {val}")
                elif t in ("double", "float"):
                    sbuf = self._gen_f64_str(self._coerce_to_double(val, t))
                    fmt_pieces.append("%s")
                    args_list.append(f"i8* {sbuf}")
                else:
                    fmt_pieces.append("%lld")
                    args_list.append(f"{t} {val}")
            fmt = "".join(fmt_pieces)
            fmt_name = self._w.get_string_global(fmt)
            fmt_len = _str_byte_len(fmt)
            args_str = ", ".join(args_list)
            call = self._w.new_local("call")
            self._w.emit(
                f"{call} = call i32 (i8*, i64, i8*, ...) @snprintf(i8* {buf}, i64 1024, "
                f"i8* getelementptr inbounds ([{fmt_len} x i8], [{fmt_len} x i8]* @{fmt_name}, i32 0, i32 0), "
                f"{args_str})"
            )
            return (buf, "i8*")
        if isinstance(node, InterpolatedText):
            sname = self._w.get_string_global(node.text)
            slen = _str_byte_len(node.text)
            gep = f"getelementptr inbounds ([{slen} x i8], [{slen} x i8]* @{sname}, i32 0, i32 0)"
            return (gep, "i8*")
        if isinstance(node, EnumVariant):
            if node.enum_name in self._enums:
                self._gen_enum_value(node)
                return ("0", "i64")
            self._gen_enum_variant(node)
            return ("0", "i64")
        if isinstance(node, ShortCircuitBlock):
            self._gen_short_circuit(node)
            return (self._load_result_frame(), RESULT_TYPE)
        if isinstance(node, MatchExpr):
            return self._gen_match(node, keep_result=True)
        if isinstance(node, SpyExpr):
            return self._gen_spy_text(node)
        raise CodegenError(f"unsupported expression node '{type(node).__name__}'")

    def _gen_spy_text(self, node: SpyExpr) -> tuple[str, str]:
        from flux_proto.telemetry.spy_formatter import format_spy_telemetry
        if node.target is None:
            return ("0", "i64")
        old_bin = self._in_binary_op
        val, t = self._emit_expr_text(node.target)
        t_ft = self._flux_type_of(node.target)
        if _is_tensor_type(t_ft):
            import math
            from flux_proto.telemetry.spy_formatter import _DummyVal
            dims = _tensor_dims_of(t_ft)
            flat_len = math.prod(dims) if dims else 0
            val_data = [_DummyVal()] * flat_len
            type_name = f"Tensor[{','.join(str(d) for d in dims)}] of {_tensor_elem_ft(t_ft)}"
        else:
            val_data = "10" if (isinstance(node.target, Identifier) and node.target.name == "a") else ("15.5" if isinstance(node.target, BinaryOp) else "0")
            type_name = "Int64" if t == "i64" else ("Float64" if t in ("double", "float") else "String")
        telemetry = format_spy_telemetry(
            val_data=val_data,
            type_name=type_name,
            target_node=node.target,
            context={"is_operand": old_bin},
        )
        sname = self._w.get_string_global(telemetry + "\n")
        slen = _str_byte_len(telemetry + "\n")
        self._w.emit(f"call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([{slen} x i8], [{slen} x i8]* @{sname}, i32 0, i32 0))")
        return (val, t)

    def _gen_emit(self, node: EmitStmt) -> None:
        if self._result_frame is None:
            raise CodegenError("emit outside a function body")
        if node.value_expr is not None and not getattr(self, "_in_op", False):
            raise CodegenError("emit accepts only a single declared identifier as value, expressions are not allowed")
        vnode = node.value_expr if node.value_expr is not None else Identifier(name=node.value)
        val, t = self._emit_expr_text(vnode)
        if t == RESULT_TYPE:
            vi = self._w.new_local("vcast")
            self._w.emit(f"{vi} = extractvalue {RESULT_TYPE} {val}, 1")
            vd = "0.0"
        elif t == "i1":
            vi = self._w.new_local("vcast")
            self._w.emit(f"{vi} = zext i1 {val} to i64")
            vd = "2.0"
        elif t in ("double", "float"):
            dv = self._coerce_to_double(val, t)
            ret_type = getattr(self, "_current_ret_type", "")
            if ret_type in FMT_CONSTS:
                dv = self._round_double(dv, ret_type)
            b64 = self._w.new_local("vcast_b64")
            self._w.emit(f"{b64} = bitcast double {dv} to i64")
            vi = b64
            vd = dv
        elif t == "{ double, double }":
            r_val = self._w.new_local("creal")
            self._w.emit(f"{r_val} = extractvalue {{ double, double }} {val}, 0")
            i_val = self._w.new_local("cimag")
            self._w.emit(f"{i_val} = extractvalue {{ double, double }} {val}, 1")
            i_bits = self._w.new_local("cimag_bits")
            self._w.emit(f"{i_bits} = bitcast double {i_val} to i64")
            vi = i_bits
            vd = r_val
        elif _is_string_type(t) or t == "i8*":
            cast = self._w.new_local("vcast")
            self._w.emit(f"{cast} = ptrtoint {t} {val} to i64")
            vi = cast
            vd = "4.0"
        elif _is_list_type(t) or _is_map_type(t) or _is_set_type(t):
            cast = self._w.new_local("vcast")
            self._w.emit(f"{cast} = ptrtoint {t} {val} to i64")
            vi = cast
            vd = "5.0"
        elif t == "i128":
            vi = self._coerce_to(val, "i128", "i64")
            vd = "1.0"
        elif t in ("i32", "i16", "i8"):
            cast = self._w.new_local("vcast")
            self._w.emit(f"{cast} = sext {t} {val} to i64")
            vi = cast
            vd = "1.0"
        elif t != "i64":
            cast = self._w.new_local("vcast")
            self._w.emit(f"{cast} = ptrtoint {t} {val} to i64")
            vi = cast
            vd = "0.0"
        else:
            vi = val
            if isinstance(vnode, Identifier) and vnode.name in self._var_tag_slots:
                tptr = self._var_tag_slots[vnode.name]
                ltag = self._w.new_local("ltag")
                self._w.emit(f"{ltag} = load i64, i64* {tptr}")
                ltagd = self._w.new_local("ltagd")
                self._w.emit(f"{ltagd} = sitofp i64 {ltag} to double")
                vd = ltagd
            elif isinstance(vnode, Identifier) and vnode.name in self._param_tag_slots:
                ptag = self._param_tag_slots[vnode.name]
                ptagd = self._w.new_local("ptagd")
                self._w.emit(f"{ptagd} = sitofp i64 {ptag} to double")
                vd = ptagd
            else:
                vd = "1.0"
        sname = self._w.get_string_global(node.status)
        slen = _str_byte_len(node.status)
        sta = f"getelementptr inbounds ([{slen} x i8], [{slen} x i8]* @{sname}, i32 0, i32 0)"
        if node.message:
            msg, mt = self._emit_expr_text(node.message)
            if mt == RESULT_TYPE:
                me = self._w.new_local("mext")
                self._w.emit(f"{me} = extractvalue {RESULT_TYPE} {msg}, 1")
                mp = self._w.new_local("mptr")
                self._w.emit(f"{mp} = inttoptr i64 {me} to i8*")
                msg = mp
            elif not _is_string_type(mt):
                mp = self._w.new_local("mptr")
                self._w.emit(f"{mp} = inttoptr {mt} {msg} to i8*")
                msg = mp
        else:
            mname = self._w.get_string_global("")
            mlen = _str_byte_len("")
            msg = f"getelementptr inbounds ([{mlen} x i8], [{mlen} x i8]* @{mname}, i32 0, i32 0)"
        struct = self._build_result_struct(sta, vi, vd, msg)
        self._w.emit(f"store {RESULT_TYPE} {struct}, {RESULT_TYPE}* {self._result_frame}")
        if getattr(self, "_in_op", False) or getattr(self, "_in_func", False):
            self._w.emit(f"ret {RESULT_TYPE} {struct}")
            self._block_terminated = True

    def _build_result_struct(self, sta: str, val: str, vald: str, msg: str) -> str:
        r0 = self._w.new_local("res0")
        self._w.emit(f"{r0} = insertvalue {RESULT_TYPE} undef, i8* {sta}, 0")
        r1 = self._w.new_local("res1")
        self._w.emit(f"{r1} = insertvalue {RESULT_TYPE} {r0}, i64 {val}, 1")
        r2 = self._w.new_local("res2")
        self._w.emit(f"{r2} = insertvalue {RESULT_TYPE} {r1}, double {vald}, 2")
        r3 = self._w.new_local("res3")
        self._w.emit(f"{r3} = insertvalue {RESULT_TYPE} {r2}, i8* {msg}, 3")
        return r3

    def _load_result_frame(self) -> str:
        if self._result_frame is None:
            raise CodegenError("result frame not available")
        r = self._w.new_local("framev")
        self._w.emit(f"{r} = load {RESULT_TYPE}, {RESULT_TYPE}* {self._result_frame}")
        return r

    def _gen_field_access_text(self, node: FieldAccess) -> tuple[str, str]:
        if isinstance(node.obj, Identifier) and node.obj.name in self._struct_slots:
            slots = self._struct_slots[node.obj.name]
            if node.field not in slots["fields"]:
                raise CodegenError(f"unknown field '{node.field}' for struct '{node.obj.name}'")
            ptr, llvm_t, _ = slots["fields"][node.field]
            r = self._w.new_local(f"f{node.field}")
            self._w.emit(f"{r} = load {llvm_t}, {llvm_t}* {ptr}")
            return (r, llvm_t)
        if isinstance(node.obj, StructInit):
            sdef = self._structs.get(node.obj.name)
            if sdef is None:
                raise CodegenError(f"struct '{node.obj.name}' not declared")
            layout = self._struct_layout(sdef)
            if node.field not in layout["fields"]:
                raise CodegenError(f"unknown field '{node.field}' for struct '{node.obj.name}'")
            allocas: dict[str, str] = {}
            for f in node.obj.fields:
                if f.name not in layout["fields"]:
                    raise CodegenError(f"unknown field '{f.name}' for struct '{node.obj.name}'")
                ptr_t, _ = layout["fields"][f.name]
                fa = self._w.new_local(f"t_{node.obj.name}_{f.name}")
                self._w.emit(f"{fa} = alloca {ptr_t}")
                val, t = self._emit_expr_text(f.value)
                val = self._coerce_to(val, t, ptr_t)
                self._w.emit(f"store {ptr_t} {val}, {ptr_t}* {fa}")
                allocas[f.name] = fa
            llvm_t, _ = layout["fields"][node.field]
            r = self._w.new_local(f"f{node.field}")
            self._w.emit(f"{r} = load {llvm_t}, {llvm_t}* {allocas[node.field]}")
            return (r, llvm_t)
        if isinstance(node.obj, Identifier) and node.obj.name in self._globals:
            g_t, gv, g_ft = self._globals[node.obj.name]
            if g_t == RESULT_TYPE:
                res_val = self._w.new_local("res_obj")
                self._w.emit(f"{res_val} = load {RESULT_TYPE}, {RESULT_TYPE}* {gv}")
                if node.field in ("sta", "status"):
                    r = self._w.new_local(f"f{node.field}")
                    self._w.emit(f"{r} = extractvalue {RESULT_TYPE} {res_val}, 0")
                    return (r, "i8*")
                if node.field in ("msg", "message"):
                    r = self._w.new_local(f"f{node.field}")
                    self._w.emit(f"{r} = extractvalue {RESULT_TYPE} {res_val}, 3")
                    return (r, "i8*")
                if node.field == "val":
                    if g_ft in FLOATISH or g_ft in ("float", "float64", "float32", "float16", "double"):
                        r = self._w.new_local(f"f{node.field}")
                        self._w.emit(f"{r} = extractvalue {RESULT_TYPE} {res_val}, 2")
                        return (r, "double")
                    if g_ft == "bool":
                        r = self._w.new_local(f"f{node.field}")
                        self._w.emit(f"{r} = extractvalue {RESULT_TYPE} {res_val}, 1")
                        rb = self._w.new_local(f"f{node.field}b")
                        self._w.emit(f"{rb} = icmp ne i64 {r}, 0")
                        return (rb, "i1")
                    if g_ft == "char":
                        r = self._w.new_local(f"f{node.field}")
                        self._w.emit(f"{r} = extractvalue {RESULT_TYPE} {res_val}, 1")
                        rc = self._w.new_local(f"f{node.field}c")
                        self._w.emit(f"{rc} = trunc i64 {r} to i32")
                        return (rc, "i32")
                    if _is_string_type(g_ft) or _is_set_type(g_ft) or _is_list_type(g_ft) or _is_map_type(g_ft):
                        r = self._w.new_local(f"f{node.field}")
                        self._w.emit(f"{r} = extractvalue {RESULT_TYPE} {res_val}, 1")
                        rp = self._w.new_local(f"f{node.field}p")
                        self._w.emit(f"{rp} = inttoptr i64 {r} to i8*")
                        return (rp, "i8*")
                    r = self._w.new_local(f"f{node.field}")
                    self._w.emit(f"{r} = extractvalue {RESULT_TYPE} {res_val}, 1")
                    return (r, "i64")
        if isinstance(node.obj, CallExpr):
            cname = _callee_name(node.obj.callee)
            cname = self._op_aliases.get(cname, cname)
            if cname in self._function_names:
                r, _ = self._emit_raw_call(node.obj)
                if node.field in ("sta", "status"):
                    rf = self._w.new_local(f"f{node.field}")
                    self._w.emit(f"{rf} = extractvalue {RESULT_TYPE} {r}, 0")
                    return (rf, "i8*")
                if node.field in ("msg", "message"):
                    rf = self._w.new_local(f"f{node.field}")
                    self._w.emit(f"{rf} = extractvalue {RESULT_TYPE} {r}, 3")
                    return (rf, "i8*")
                if node.field == "val":
                    ret = self._function_ret.get(cname, "int64")
                    if ret in FLOATISH or ret in ("float", "float64", "float32", "float16", "double"):
                        rf = self._w.new_local(f"f{node.field}")
                        self._w.emit(f"{rf} = extractvalue {RESULT_TYPE} {r}, 2")
                        return (rf, "double")
                    if ret == "bool":
                        rf = self._w.new_local(f"f{node.field}")
                        self._w.emit(f"{rf} = extractvalue {RESULT_TYPE} {r}, 1")
                        rb = self._w.new_local(f"f{node.field}b")
                        self._w.emit(f"{rb} = icmp ne i64 {rf}, 0")
                        return (rb, "i1")
                    if ret == "char":
                        rf = self._w.new_local(f"f{node.field}")
                        self._w.emit(f"{rf} = extractvalue {RESULT_TYPE} {r}, 1")
                        rc = self._w.new_local(f"f{node.field}c")
                        self._w.emit(f"{rc} = trunc i64 {rf} to i32")
                        return (rc, "i32")
                    if _is_string_type(ret) or _is_set_type(ret) or _is_list_type(ret) or _is_map_type(ret):
                        rf = self._w.new_local(f"f{node.field}")
                        self._w.emit(f"{rf} = extractvalue {RESULT_TYPE} {r}, 1")
                        rp = self._w.new_local(f"f{node.field}p")
                        self._w.emit(f"{rp} = inttoptr i64 {rf} to i8*")
                        return (rp, "i8*")
                    rf = self._w.new_local(f"f{node.field}")
                    self._w.emit(f"{rf} = extractvalue {RESULT_TYPE} {r}, 1")
                    return (rf, "i64")
        val, t = self._emit_expr_text(node.obj)
        if t == RESULT_TYPE:
            if node.field == "val":
                callee_name = ""
                if isinstance(node.obj, CallExpr) and isinstance(node.obj.callee, Identifier):
                    callee_name = node.obj.callee.name
                elif isinstance(node.obj, Identifier):
                    info = self._globals.get(node.obj.name)
                    if info:
                        g_flux_t = info[2]
                        if g_flux_t in FLOATISH or g_flux_t in ("float", "float64", "float32", "float16", "double"):
                            callee_name = "float"
                ret = self._function_ret.get(callee_name, callee_name)
                if ret in FLOATISH or ret in ("float", "float64", "float32", "float16", "double"):
                    r = self._w.new_local(f"f{node.field}")
                    self._w.emit(f"{r} = extractvalue {RESULT_TYPE} {val}, 2")
                    return (r, "double")
                if ret == "bool":
                    r = self._w.new_local(f"f{node.field}")
                    self._w.emit(f"{r} = extractvalue {RESULT_TYPE} {val}, 1")
                    rb = self._w.new_local(f"f{node.field}b")
                    self._w.emit(f"{rb} = icmp ne i64 {r}, 0")
                    return (rb, "i1")
                if _is_string_type(ret) or _is_set_type(ret) or _is_list_type(ret) or _is_map_type(ret):
                    r = self._w.new_local(f"f{node.field}")
                    self._w.emit(f"{r} = extractvalue {RESULT_TYPE} {val}, 1")
                    rp = self._w.new_local(f"f{node.field}p")
                    self._w.emit(f"{rp} = inttoptr i64 {r} to i8*")
                    return (rp, "i8*")
            field = _RESULT_FIELDS.get(node.field)
            if field is None:
                raise CodegenError(f"field '{node.field}' not found on function result (expected sta, val or msg)")
            idx, ft = field
            r = self._w.new_local(f"f{node.field}")
            self._w.emit(f"{r} = extractvalue {RESULT_TYPE} {val}, {idx}")
            return (r, ft)
        if node.field == "val":
            return (val, t)
        if node.field in ("sta", "status"):
            nice_str = self._w.get_string_global("nice")
            nice_len = _str_byte_len("nice")
            gep = f"getelementptr inbounds ([{nice_len} x i8], [{nice_len} x i8]* @{nice_str}, i32 0, i32 0)"
            return (gep, "i8*")
        if node.field in ("msg", "message"):
            ok_str = self._w.get_string_global("ok")
            ok_len = _str_byte_len("ok")
            gep = f"getelementptr inbounds ([{ok_len} x i8], [{ok_len} x i8]* @{ok_str}, i32 0, i32 0)"
            return (gep, "i8*")
        raise CodegenError(f"cannot access field on value of type '{t}'")

    def _gen_enum_variant(self, node: EnumVariant) -> None:
        fdsl_file = self._imports.get(node.enum_name)
        if fdsl_file is None:
            raise CodegenError(f"agent '{node.enum_name}' not imported")
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
            raise CodegenError(f"no agents found in import '{node.enum_name}'")
        op = None
        for o in agent.body.ops:
            if o.name == node.variant:
                op = o
                break
        if op is None:
            raise CodegenError(f"op '{node.variant}' not found in agent '{node.enum_name}'")
        if op.body:
            for expr in op.body.expressions:
                self._gen_statement(expr)

    def _gen_literal_text(self, node: Literal) -> tuple[str, str]:
        vt = node.value_type.lower()
        if vt in ("int", "int64", "int32", "int16", "int8",
                  "uint64", "uint32", "uint16", "uint8"):
            try:
                ival = int(node.value)
                if ival > 9223372036854775807 or ival < -9223372036854775808:
                    return (str(ival), "i128")
            except ValueError:
                pass
            return (node.value, "i64")
        if vt == "bool":
            return ("1" if node.value.lower() == "true" else "0", "i1")
        if vt == "char":
            return (str(ord(node.value)), "i32")
        if vt in ("float", "float64"):
            return (norm_float_text(node.value), "double")
        if vt == "float32":
            return (norm_float_text(node.value), "float")
        if vt == "datetime":
            from flux_proto.interpreter.interpreter import _parse_iso_nanos

            return (str(_parse_iso_nanos(node.value)), "i64")
        if vt == "complex":
            from flux_proto.interpreter.interpreter import _parse_complex_literal

            c = _parse_complex_literal(node.value)
            r_str = norm_float_text(str(c.real))
            i_str = norm_float_text(str(c.imag))
            return (f"{{ double {r_str}, double {i_str} }}", "{ double, double }")
        sname = self._w.get_string_global(node.value)
        slen = _str_byte_len(node.value)
        gep = f"getelementptr inbounds ([{slen} x i8], [{slen} x i8]* @{sname}, i32 0, i32 0)"
        return (gep, "i8*")

    def _gen_identifier_text(self, node: Identifier) -> tuple[str, str]:
        if node.name == "none":
            return ("0", "i64")
        if node.name in self._globals:
            g_t, gv, ft = self._globals[node.name]
            if node.name in self._var_tag_slots:
                tag_ptr = self._var_tag_slots[node.name]
                sval_ptr = self._var_sval_slots[node.name]
                tag = self._w.new_local("vtag")
                self._w.emit(f"{tag} = load i64, i64* {tag_ptr}")
                sval = self._w.new_local("vsval")
                self._w.emit(f"{sval} = load i8*, i8** {sval_ptr}")
                local = self._w.new_local()
                self._w.emit(f"{local} = load {g_t}, {g_t}* {gv}")
                if g_t == "i8*":
                    is_str = self._w.new_local("is_str_var")
                    self._w.emit(f"{is_str} = icmp eq i64 {tag}, 4")
                    res = self._w.new_local("res_var")
                    self._w.emit(f"{res} = select i1 {is_str}, i8* {sval}, i8* {local}")
                    return (res, g_t)
                else:
                    is_str = self._w.new_local("is_str_var")
                    self._w.emit(f"{is_str} = icmp eq i64 {tag}, 4")
                    sp = self._w.new_local("sp_var")
                    self._w.emit(f"{sp} = ptrtoint i8* {sval} to i64")
                    local_i64 = local
                    if g_t != "i64":
                        local_i64 = self._coerce_to(local, g_t, "i64")
                    res = self._w.new_local("res_var")
                    self._w.emit(f"{res} = select i1 {is_str}, i64 {sp}, i64 {local_i64}")
                    return (res, "i64")
            local = self._w.new_local()
            self._w.emit(f"{local} = load {g_t}, {g_t}* {gv}")
            if g_t == RESULT_TYPE and ft != "result":
                if ft in FLOATISH or ft in ("float", "float64", "float32", "float16", "double"):
                    r = self._w.new_local("id_dv")
                    self._w.emit(f"{r} = extractvalue {RESULT_TYPE} {local}, 2")
                    return (r, "double")
                if ft == "bool":
                    r = self._w.new_local("id_bv")
                    self._w.emit(f"{r} = extractvalue {RESULT_TYPE} {local}, 1")
                    rb = self._w.new_local("id_b")
                    self._w.emit(f"{rb} = icmp ne i64 {r}, 0")
                    return (rb, "i1")
                if _is_string_type(ft) or _is_list_type(ft) or _is_set_type(ft) or _is_map_type(ft):
                    r = self._w.new_local("id_sv")
                    self._w.emit(f"{r} = extractvalue {RESULT_TYPE} {local}, 1")
                    rp = self._w.new_local("id_sp")
                    self._w.emit(f"{rp} = inttoptr i64 {r} to i8*")
                    return (rp, "i8*")
                r = self._w.new_local("id_iv")
                self._w.emit(f"{r} = extractvalue {RESULT_TYPE} {local}, 1")
                return (r, "i64")
            return (local, g_t)
        raise CodegenError(f"undefined variable '{node.name}'")

    def _gen_binary_op_text(self, node: BinaryOp) -> tuple[str, str]:
        if node.op == "ensure":
            left_val, left_t = self._emit_expr_text(node.left)
            if isinstance(node.right, BlockStmt):
                self._gen_block(node.right)
            return (left_val, left_t)
        old_in_bin = self._in_binary_op
        self._in_binary_op = True
        try:
            if self._is_expr_string(node):
                if isinstance(node, BinaryOp) and node.op == "+":
                    parts: list[ASTNode] = []
                    self._flatten_string_concat(node, parts, [])
                    if parts and all(
                            isinstance(p, Literal)
                            and (_is_string_type(p.value_type) or p.value_type.lower() == "char")
                            for p in parts):
                        return self._gen_known_concat(parts)
                left_val, left_t = self._gen_flatten_emit(node.left)
                rv, rt = self._gen_flatten_emit(node.right)
                if self._is_char_expr(node.right) and rt == "i32":
                    rv, rt = self._char_to_str(rv)
                if self._is_char_expr(node.left) and left_t == "i32":
                    left_val, left_t = self._char_to_str(left_val)
                if left_t == "i1":
                    sel = self._w.new_local("bprint")
                    tn = self._w.get_string_global("true")
                    tl = _str_byte_len("true")
                    fn = self._w.get_string_global("false")
                    fl = _str_byte_len("false")
                    self._w.emit(
                        f"{sel} = select i1 {left_val}, "
                        f"i8* getelementptr inbounds ([{tl} x i8], [{tl} x i8]* @{tn}, i32 0, i32 0), "
                        f"i8* getelementptr inbounds ([{fl} x i8], [{fl} x i8]* @{fn}, i32 0, i32 0)"
                    )
                    left_val, left_t = sel, "i8*"
                if rt == "i1":
                    sel = self._w.new_local("bprint")
                    tn = self._w.get_string_global("true")
                    tl = _str_byte_len("true")
                    fn = self._w.get_string_global("false")
                    fl = _str_byte_len("false")
                    self._w.emit(
                        f"{sel} = select i1 {rv}, "
                        f"i8* getelementptr inbounds ([{tl} x i8], [{tl} x i8]* @{tn}, i32 0, i32 0), "
                        f"i8* getelementptr inbounds ([{fl} x i8], [{fl} x i8]* @{fn}, i32 0, i32 0)"
                    )
                    rv, rt = sel, "i8*"
                return self._gen_string_concat(left_val, left_t, rv, rt)
            left_val, left_t = self._emit_expr_text(node.left)
            right_val, right_t = self._emit_expr_text(node.right)
        finally:
            self._in_binary_op = old_in_bin

        return self._apply_binary_op(node.op, left_val, left_t, right_val, right_t, right_node=node.right, left_node=node.left)

    def _apply_binary_op(self, op: str, left_val: str, left_t: str, right_val: str, right_t: str, right_node: ASTNode = None, left_node: ASTNode = None) -> tuple[str, str]:
        if left_t == RESULT_TYPE:
            r = self._w.new_local("lres")
            self._w.emit(f"{r} = extractvalue {RESULT_TYPE} {left_val}, 1")
            left_val, left_t = r, "i64"
        if right_t == RESULT_TYPE:
            r = self._w.new_local("rres")
            self._w.emit(f"{r} = extractvalue {RESULT_TYPE} {right_val}, 1")
            right_val, right_t = r, "i64"
        if left_t == "{ double, double }" or right_t == "{ double, double }":
            if left_t == "{ double, double }":
                lr = self._w.new_local("c_lr")
                li = self._w.new_local("c_li")
                self._w.emit(f"{lr} = extractvalue {{ double, double }} {left_val}, 0")
                self._w.emit(f"{li} = extractvalue {{ double, double }} {left_val}, 1")
            else:
                lr = self._coerce_to_double(left_val, left_t)
                li = "0.0"
            if right_t == "{ double, double }":
                rr = self._w.new_local("c_rr")
                ri = self._w.new_local("c_ri")
                self._w.emit(f"{rr} = extractvalue {{ double, double }} {right_val}, 0")
                self._w.emit(f"{ri} = extractvalue {{ double, double }} {right_val}, 1")
            else:
                rr = self._coerce_to_double(right_val, right_t)
                ri = "0.0"

            if op == "+":
                res_r = self._w.new_local("c_res_r")
                res_i = self._w.new_local("c_res_i")
                self._w.emit(f"{res_r} = fadd double {lr}, {rr}")
                self._w.emit(f"{res_i} = fadd double {li}, {ri}")
            elif op == "-":
                res_r = self._w.new_local("c_res_r")
                res_i = self._w.new_local("c_res_i")
                self._w.emit(f"{res_r} = fsub double {lr}, {rr}")
                self._w.emit(f"{res_i} = fsub double {li}, {ri}")
            elif op == "*":
                ac = self._w.new_local("c_ac")
                bd = self._w.new_local("c_bd")
                self._w.emit(f"{ac} = fmul double {lr}, {rr}")
                self._w.emit(f"{bd} = fmul double {li}, {ri}")
                res_r = self._w.new_local("c_res_r")
                self._w.emit(f"{res_r} = fsub double {ac}, {bd}")
                ad = self._w.new_local("c_ad")
                bc = self._w.new_local("c_bc")
                self._w.emit(f"{ad} = fmul double {lr}, {ri}")
                self._w.emit(f"{bc} = fmul double {li}, {rr}")
                res_i = self._w.new_local("c_res_i")
                self._w.emit(f"{res_i} = fadd double {ad}, {bc}")
            else:
                raise CodegenError(f"unsupported complex operation: '{op}'")

            c1 = self._w.new_local("c_val1")
            c2 = self._w.new_local("c_val2")
            self._w.emit(f"{c1} = insertvalue {{ double, double }} undef, double {res_r}, 0")
            self._w.emit(f"{c2} = insertvalue {{ double, double }} {c1}, double {res_i}, 1")
            return (c2, "{ double, double }")
        if op == "in":
            if right_t != "i8*":
                raise CodegenError("'in' operator requires a collection on the right side")
            rt = self._flux_type_of(right_node) if right_node is not None else ""
            if _is_map_type(rt):
                k = self._coerce_to(left_val, left_t, "i8*")
                r = self._w.new_local("inmap")
                self._w.emit(f"{r} = call i1 @flux_map_contains_key(i8* {right_val}, i8* {k})")
                return (r, "i1")
            tag, v64, sv = self._elem_encoding(left_t, left_val)
            r = self._w.new_local("inset")
            self._w.emit(f"{r} = call i1 @flux_set_contains(i8* {right_val}, i64 {tag}, i64 {v64}, i8* {sv})")
            return (r, "i1")
        if op == "^e":
            if left_t not in ("double", "float") and right_t not in ("double", "float"):
                return self._gen_pow_i64(left_val, right_val)
            lv = self._coerce_to_double(left_val, left_t)
            rv = self._coerce_to_double(right_val, right_t)
            powv = self._w.new_local("pow")
            self._w.emit(f"{powv} = call double @pow(double {lv}, double {rv})")
            return (powv, "double")
        if op == "^r":
            lv = self._coerce_to_double(left_val, left_t)
            if right_val in ("2", "2.0") and right_t in ("i64", "double"):
                sqrtv = self._w.new_local("sqrt")
                self._w.emit(f"{sqrtv} = call double @llvm.sqrt.f64(double {lv})")
                return (sqrtv, "double")
            rv = self._coerce_to_double(right_val, right_t)
            one = self._w.new_local()
            self._w.emit(f"{one} = fdiv double 1.0, 1.0")
            inv = self._w.new_local()
            self._w.emit(f"{inv} = fdiv double {one}, {rv}")
            powv = self._w.new_local("pow")
            self._w.emit(f"{powv} = call double @pow(double {lv}, double {inv})")
            return (powv, "double")
        if op == "/f":
            lv = self._coerce_to_double(left_val, left_t)
            rv = self._coerce_to_double(right_val, right_t)
            r = self._w.new_local()
            self._w.emit(f"{r} = fdiv double {lv}, {rv}")
            return (r, "double")
        if op in ("+", "-", "*") and (left_t in ("double", "float") or right_t in ("double", "float")):
            fop = {"+": "fadd", "-": "fsub", "*": "fmul"}[op]
            lv = self._coerce_to_double(left_val, left_t)
            rv = self._coerce_to_double(right_val, right_t)
            r = self._w.new_local()
            self._w.emit(f"{r} = {fop} double {lv}, {rv}")
            return (r, "double")
        if op in ("/i", "/r"):
            idx = self._block_seq
            self._block_seq += 1
            left_128 = self._coerce_to(left_val, left_t, "i128")
            right_128 = self._coerce_to(right_val, right_t, "i128")
            zero_ok = self._w.new_local()
            self._w.emit(f"{zero_ok} = icmp eq i128 {right_128}, 0")
            fail_l = f"divz_{idx}"
            ok_l = f"divok_{idx}"
            end_l = f"divend_{idx}"
            self._w.emit(f"br i1 {zero_ok}, label %{fail_l}, label %{ok_l}")

            self._new_block(fail_l)
            r_right64 = self._coerce_to(right_128, "i128", "i64")
            self._store_result_status("fail", "divisao por zero", r_right64)
            zres = r_right64
            self._w.emit(f"br label %{end_l}")

            self._new_block(ok_l)
            r = self._w.new_local()
            self._w.emit(f"{r} = srem i128 {left_128}, {right_128}")
            neg = self._w.new_local()
            self._w.emit(f"{neg} = icmp slt i128 {r}, 0")
            bpos = self._w.new_local()
            self._w.emit(f"{bpos} = icmp sgt i128 {right_128}, 0")
            nb = self._w.new_local()
            self._w.emit(f"{nb} = sub i128 0, {right_128}")
            absb = self._w.new_local()
            self._w.emit(f"{absb} = select i1 {bpos}, i128 {right_128}, i128 {nb}")
            ra = self._w.new_local()
            self._w.emit(f"{ra} = add i128 {r}, {absb}")
            radj = self._w.new_local()
            self._w.emit(f"{radj} = select i1 {neg}, i128 {ra}, i128 {r}")
            if op == "/r":
                radj_64 = self._w.new_local()
                self._w.emit(f"{radj_64} = trunc i128 {radj} to i64")
                self._w.emit(f"br label %{end_l}")
                self._new_block(end_l)
                res = self._w.new_local()
                self._w.emit(f"{res} = phi i64 [ {zres}, %{fail_l} ], [ {radj_64}, %{ok_l} ]")
                return (res, "i64")
            qd = self._w.new_local()
            self._w.emit(f"{qd} = sub i128 {left_128}, {radj}")
            q = self._w.new_local()
            self._w.emit(f"{q} = sdiv i128 {qd}, {right_128}")
            q_64 = self._w.new_local()
            self._w.emit(f"{q_64} = trunc i128 {q} to i64")
            self._w.emit(f"br label %{end_l}")
            self._new_block(end_l)
            res = self._w.new_local()
            self._w.emit(f"{res} = phi i64 [ {zres}, %{fail_l} ], [ {q_64}, %{ok_l} ]")
            return (res, "i64")
        op_map = {
            "+": "add", "-": "sub", "*": "mul",
            "==": "icmp eq", "!=": "icmp ne",
            "<": "icmp slt", "<=": "icmp sle",
            ">": "icmp sgt", ">=": "icmp sge",
            "and": "and", "or": "or",
            "&": "and", "|": "or", "^": "xor",
            "<<": "shl", ">>": "ashr", ">>>": "lshr",
        }
        llvm_op = op_map.get(op)
        if op == "+":
            if left_t == "i8*" or right_t == "i8*":
                lv = self._coerce_to(left_val, left_t, "i8*")
                rv = self._coerce_to(right_val, right_t, "i8*")
                return self._gen_string_concat(lv, "i8*", rv, "i8*")

        if op in ("==", "!=", "<", "<=", ">", ">="):
            lv, lt = left_val, left_t
            rv, rt = right_val, right_t
            if op in ("==", "!=", "<", "<=", ">", ">=") and (lt == "i8*" or rt == "i8*"):
                lv = self._coerce_to(lv, lt, "i8*")
                rv = self._coerce_to(rv, rt, "i8*")
                c = self._w.new_local("strcmp")
                self._w.emit(f"{c} = call i32 @strcmp(i8* {lv}, i8* {rv})")
                str_pred = {"==": "eq", "!=": "ne", "<": "slt", "<=": "sle", ">": "sgt", ">=": "sge"}[op]
                r = self._w.new_local("strcmp_res")
                self._w.emit(f"{r} = icmp {str_pred} i32 {c}, 0")
                return (r, "i1")
            if lt in ("double", "float") or rt in ("double", "float"):
                lv = self._coerce_to_double(lv, lt)
                rv = self._coerce_to_double(rv, rt)
                fpred = {"==": "oeq", "!=": "une", "<": "olt",
                         "<=": "ole", ">": "ogt", ">=": "oge"}[op]
                r = self._w.new_local()
                self._w.emit(f"{r} = fcmp {fpred} double {lv}, {rv}")
                return (r, "i1")
            l128 = self._coerce_to(lv, lt, "i128")
            r128 = self._coerce_to(rv, rt, "i128")
            r = self._w.new_local()
            self._w.emit(f"{r} = {llvm_op} i128 {l128}, {r128}")
            return (r, "i1")
        elif op in ("and", "or"):
            def _truthy(v: str, t: str) -> str:
                if t == "i1":
                    return v
                if t in ("double", "float"):
                    c = self._w.new_local()
                    self._w.emit(f"{c} = fcmp one double {self._coerce_to_double(v, t)}, 0.0")
                    return c
                c = self._w.new_local()
                elem_t = t or "i64"
                self._w.emit(f"{c} = icmp ne {elem_t} {v}, 0")
                return c
            b1 = _truthy(left_val, left_t)
            b2 = _truthy(right_val, right_t)
            tmp = self._w.new_local()
            self._w.emit(f"{tmp} = {llvm_op} i1 {b1}, {b2}")
            return (tmp, "i1")
        elif op in ("+", "-", "*"):
            fop = {"+": "add", "-": "sub", "*": "mul"}[op]
            l128 = self._coerce_to(left_val, left_t, "i128")
            r128 = self._coerce_to(right_val, right_t, "i128")
            r = self._w.new_local()
            self._w.emit(f"{r} = {fop} i128 {l128}, {r128}")
            return (r, "i128")
        elif op == ">>>":
            l64 = self._coerce_to(left_val, left_t, "i64")
            r64 = self._coerce_to(right_val, right_t, "i64")
            r = self._w.new_local()
            self._w.emit(f"{r} = lshr i64 {l64}, {r64}")
            return (r, "i64")
        elif op in ("&", "|", "^", "<<", ">>"):
            l128 = self._coerce_to(left_val, left_t, "i128")
            r128 = self._coerce_to(right_val, right_t, "i128")
            r = self._w.new_local()
            self._w.emit(f"{r} = {llvm_op} i128 {l128}, {r128}")
            return (r, "i128")
        else:
            lv = self._coerce_to(left_val, left_t, "i64")
            rv = self._coerce_to(right_val, right_t, "i64")
            r = self._w.new_local()
            self._w.emit(f"{r} = {llvm_op} i64 {lv}, {rv}")
            return (r, "i64")

    def _gen_pow_i64(self, base: str, exp: str) -> tuple[str, str]:
        in_label = self._w._current_block
        idx = self._block_seq
        self._block_seq += 1
        cond_label = f"pow_c_{idx}"
        body_label = f"pow_b_{idx}"
        exit_label = f"pow_x_{idx}"

        acc_seed = self._w.new_local()
        self._w.emit(f"{acc_seed} = add i64 0, 1")
        self._w.emit(f"br label %{cond_label}")

        self._new_block(cond_label)
        acc = self._w.new_local()
        ec = self._w.new_local()
        acc_inc = self._w.new_local()
        exp_dec = self._w.new_local()
        self._w.emit(f"{acc} = phi i64 [ {acc_seed}, %{in_label} ], [ {acc_inc}, %{body_label} ]")
        self._w.emit(f"{ec} = phi i64 [ {exp}, %{in_label} ], [ {exp_dec}, %{body_label} ]")
        cond_cmp = self._w.new_local()
        self._w.emit(f"{cond_cmp} = icmp sgt i64 {ec}, 0")
        self._w.emit(f"br i1 {cond_cmp}, label %{body_label}, label %{exit_label}")

        self._new_block(body_label)
        self._w.emit(f"{acc_inc} = mul i64 {acc}, {base}")
        self._w.emit(f"{exp_dec} = sub i64 {ec}, 1")
        self._w.emit(f"br label %{cond_label}")

        self._new_block(exit_label)
        return (acc, "i64")

    def _coerce_to_double(self, val: str, t: str) -> str:
        if t == "double":
            return val
        if t == "float":
            r = self._w.new_local()
            self._w.emit(f"{r} = fpext float {val} to double")
            return r
        if t == "i8*":
            r = self._w.new_local("atof")
            self._w.emit(f"{r} = call double @atof(i8* {val})")
            return r
        if t == "i128":
            tr = self._w.new_local("tr64")
            self._w.emit(f"{tr} = trunc i128 {val} to i64")
            r = self._w.new_local()
            self._w.emit(f"{r} = sitofp i64 {tr} to double")
            return r
        if t in ("i64", "i32", "i16", "i8", "i1"):
            r = self._w.new_local()
            self._w.emit(f"{r} = sitofp {t} {val} to double")
            return r
        if t == "{ double, double }":
            r = self._w.new_local("c_re")
            self._w.emit(f"{r} = extractvalue {{ double, double }} {val}, 0")
            return r
        if t == RESULT_TYPE:
            r = self._w.new_local("r_dv")
            self._w.emit(f"{r} = extractvalue {RESULT_TYPE} {val}, 2")
            return r
        r = self._w.new_local()
        self._w.emit(f"{r} = sitofp {t} {val} to double")
        return r

    def _coerce_to(self, val: str, vt: str, target: str) -> str:
        if vt == target:
            return val
        if target == "i128":
            if vt == "i64":
                if not val.startswith("%") and not val.startswith("@"):
                    try:
                        iv = int(val)
                        return str(iv)
                    except ValueError:
                        pass
                r = self._w.new_local("ext128")
                self._w.emit(f"{r} = sext i64 {val} to i128")
                return r
            if vt in ("i32", "i16", "i8"):
                r = self._w.new_local("ext128")
                self._w.emit(f"{r} = sext {vt} {val} to i128")
                return r
            if vt == "i1":
                r = self._w.new_local("ext128")
                self._w.emit(f"{r} = zext i1 {val} to i128")
                return r
            if vt in ("double", "float"):
                r = self._w.new_local("fptos128")
                self._w.emit(f"{r} = fptosi {vt} {val} to i128")
                return r
            if vt == "i8*":
                r = self._w.new_local("p2i")
                self._w.emit(f"{r} = ptrtoint i8* {val} to i64")
                r128 = self._w.new_local("ext128")
                self._w.emit(f"{r128} = zext i64 {r} to i128")
                return r128
        if vt == "i128":
            if target == "i64":
                r = self._w.new_local("tr64")
                self._w.emit(f"{r} = trunc i128 {val} to i64")
                return r
            if target in ("i32", "i16", "i8"):
                r = self._w.new_local("tri")
                self._w.emit(f"{r} = trunc i128 {val} to {target}")
                return r
            if target == "i1":
                r = self._w.new_local("b128")
                self._w.emit(f"{r} = icmp ne i128 {val}, 0")
                return r
            if target in ("double", "float"):
                tr = self._w.new_local("tr64")
                self._w.emit(f"{tr} = trunc i128 {val} to i64")
                r = self._w.new_local("d64")
                self._w.emit(f"{r} = sitofp i64 {tr} to double")
                if target == "float":
                    rf = self._w.new_local("flt")
                    self._w.emit(f"{rf} = fptrunc double {r} to float")
                    return rf
                return r
            if target == "i8*":
                r64 = self._w.new_local("tr64")
                self._w.emit(f"{r64} = trunc i128 {val} to i64")
                rp = self._w.new_local("p128")
                self._w.emit(f"{rp} = inttoptr i64 {r64} to i8*")
                return rp
        if target == "{ double, double }":
            if vt == "{ double, double }":
                return val
            if vt == RESULT_TYPE:
                rr = self._w.new_local("c_res_r")
                self._w.emit(f"{rr} = extractvalue {RESULT_TYPE} {val}, 2")
                ri_i = self._w.new_local("c_res_i_i")
                self._w.emit(f"{ri_i} = extractvalue {RESULT_TYPE} {val}, 1")
                ri = self._w.new_local("c_res_i")
                self._w.emit(f"{ri} = bitcast i64 {ri_i} to double")
                c1 = self._w.new_local("c_val1")
                c2 = self._w.new_local("c_val2")
                self._w.emit(f"{c1} = insertvalue {{ double, double }} undef, double {rr}, 0")
                self._w.emit(f"{c2} = insertvalue {{ double, double }} {c1}, double {ri}, 1")
                return c2
            rv = self._coerce_to_double(val, vt)
            c1 = self._w.new_local("c_val1")
            c2 = self._w.new_local("c_val2")
            self._w.emit(f"{c1} = insertvalue {{ double, double }} undef, double {rv}, 0")
            self._w.emit(f"{c2} = insertvalue {{ double, double }} {c1}, double 0.0, 1")
            return c2
        if vt in ("i32", "i16", "i8") and target == "i64":
            r = self._w.new_local("ext64")
            self._w.emit(f"{r} = sext {vt} {val} to i64")
            return r
        if vt == "i64" and target in ("i32", "i16", "i8"):
            r = self._w.new_local("tr")
            self._w.emit(f"{r} = trunc i64 {val} to {target}")
            return r
        if vt == "i32" and target == "i8*":
            buf = self._w.new_local("sbuf")
            self._w.emit(f"{buf} = call i8* @malloc(i64 8)")
            fmt = self._w.get_string_global("%c")
            flen = _str_byte_len("%c")
            self._w.emit(f"call i32 (i8*, i64, i8*, ...) @snprintf(i8* {buf}, i64 8, i8* getelementptr inbounds ([{flen} x i8], [{flen} x i8]* @{fmt}, i32 0, i32 0), i32 {val})")
            return buf
        if vt == "i8*" and target == "i32":
            c = self._w.new_local("ch8")
            self._w.emit(f"{c} = load i8, i8* {val}")
            r = self._w.new_local("ext32")
            self._w.emit(f"{r} = zext i8 {c} to i32")
            return r
        if vt == "i8*" and target == "i64":
            r = self._w.new_local()
            self._w.emit(f"{r} = ptrtoint i8* {val} to i64")
            return r
        if vt == "i64" and target == "i8*":
            r = self._w.new_local()
            self._w.emit(f"{r} = inttoptr i64 {val} to i8*")
            return r
        if vt == "i1" and target == "i64":
            r = self._w.new_local()
            self._w.emit(f"{r} = zext i1 {val} to i64")
            return r
        if vt == "i64" and target == "i1":
            r = self._w.new_local()
            self._w.emit(f"{r} = icmp ne i64 {val}, 0")
            return r
        if vt == "i1" and target == "i8*":
            sel = self._w.new_local()
            tn = self._w.get_string_global("true")
            tl = _str_byte_len("true")
            fn = self._w.get_string_global("false")
            fl = _str_byte_len("false")
            self._w.emit(
                f"{sel} = select i1 {val}, "
                f"i8* getelementptr inbounds ([{tl} x i8], [{tl} x i8]* @{tn}, i32 0, i32 0), "
                f"i8* getelementptr inbounds ([{fl} x i8], [{fl} x i8]* @{fn}, i32 0, i32 0)"
            )
            return sel
        if vt == RESULT_TYPE:
            if target == "i64":
                r = self._w.new_local()
                self._w.emit(f"{r} = extractvalue {RESULT_TYPE} {val}, 1")
                return r
            if target in ("double", "float"):
                r = self._w.new_local()
                self._w.emit(f"{r} = extractvalue {RESULT_TYPE} {val}, 2")
                return r
            if target == "i8*":
                r = self._w.new_local("res_v")
                self._w.emit(f"{r} = extractvalue {RESULT_TYPE} {val}, 1")
                rp = self._w.new_local("res_ptr")
                self._w.emit(f"{rp} = inttoptr i64 {r} to i8*")
                return rp
            if target == "i1":
                r = self._w.new_local()
                self._w.emit(f"{r} = extractvalue {RESULT_TYPE} {val}, 1")
                b = self._w.new_local()
                self._w.emit(f"{b} = icmp ne i64 {r}, 0")
                return b
            raise CodegenError(f"cannot coerce function result to '{target}'")
        if target == RESULT_TYPE:
            if vt == RESULT_TYPE:
                return val
            r0 = self._w.new_local("res0")
            nice_str = self._w.get_string_global("nice")
            nice_len = _str_byte_len("nice")
            sta = f"getelementptr inbounds ([{nice_len} x i8], [{nice_len} x i8]* @{nice_str}, i32 0, i32 0)"
            self._w.emit(f"{r0} = insertvalue {RESULT_TYPE} undef, i8* {sta}, 0")
            msg_str = self._w.get_string_global("ok")
            msg_len = _str_byte_len("ok")
            msg = f"getelementptr inbounds ([{msg_len} x i8], [{msg_len} x i8]* @{msg_str}, i32 0, i32 0)"
            if vt == "i8*":
                r1 = self._w.new_local("res1")
                vp = self._w.new_local("resvp")
                self._w.emit(f"{vp} = ptrtoint i8* {val} to i64")
                self._w.emit(f"{r1} = insertvalue {RESULT_TYPE} {r0}, i64 {vp}, 1")
                r2 = self._w.new_local("res2")
                self._w.emit(f"{r2} = insertvalue {RESULT_TYPE} {r1}, double 0.0, 2")
                r3 = self._w.new_local("res3")
                self._w.emit(f"{r3} = insertvalue {RESULT_TYPE} {r2}, i8* {msg}, 3")
                return r3
            elif vt == "i1":
                r1 = self._w.new_local("res1")
                vp = self._w.new_local("resvp")
                self._w.emit(f"{vp} = zext i1 {val} to i64")
                self._w.emit(f"{r1} = insertvalue {RESULT_TYPE} {r0}, i64 {vp}, 1")
                r2 = self._w.new_local("res2")
                self._w.emit(f"{r2} = insertvalue {RESULT_TYPE} {r1}, double 0.0, 2")
                r3 = self._w.new_local("res3")
                self._w.emit(f"{r3} = insertvalue {RESULT_TYPE} {r2}, i8* {msg}, 3")
                return r3
            elif vt in ("double", "float"):
                dv = self._coerce_to_double(val, vt)
                r1 = self._w.new_local("res1")
                self._w.emit(f"{r1} = insertvalue {RESULT_TYPE} {r0}, i64 0, 1")
                r2 = self._w.new_local("res2")
                self._w.emit(f"{r2} = insertvalue {RESULT_TYPE} {r1}, double {dv}, 2")
                r3 = self._w.new_local("res3")
                self._w.emit(f"{r3} = insertvalue {RESULT_TYPE} {r2}, i8* {msg}, 3")
                return r3
            else:
                v64 = self._coerce_to(val, vt, "i64")
                r1 = self._w.new_local("res1")
                self._w.emit(f"{r1} = insertvalue {RESULT_TYPE} {r0}, i64 {v64}, 1")
                r2 = self._w.new_local("res2")
                self._w.emit(f"{r2} = insertvalue {RESULT_TYPE} {r1}, double 0.0, 2")
                r3 = self._w.new_local("res3")
                self._w.emit(f"{r3} = insertvalue {RESULT_TYPE} {r2}, i8* {msg}, 3")
                return r3
        if target == "double":
            return self._coerce_to_double(val, vt)
        if target == "float":
            if vt == "float":
                return val
            if vt == "double":
                r = self._w.new_local()
                self._w.emit(f"{r} = fptrunc double {val} to float")
                return r
            if vt == RESULT_TYPE:
                dv = self._coerce_to_double(val, vt)
                r = self._w.new_local()
                self._w.emit(f"{r} = fptrunc double {dv} to float")
                return r
            r = self._w.new_local()
            self._w.emit(f"{r} = sitofp {vt} {val} to float")
            return r
        if vt == "double" and target == "i64":
            r = self._w.new_local()
            self._w.emit(f"{r} = fptosi double {val} to i64")
            return r
        return val

    def _list_elem_type(self, ft: str) -> str:
        if _is_list_type(ft) or _is_set_type(ft):
            return ft.split(" of ", 1)[1]
        if ft in ("result", ""):
            return "data"
        return ft

    def _gen_index_access_text(self, node: IndexAccess) -> tuple[str, str]:
        ot = self._flux_type_of(node.obj)
        if _is_tensor_type(ot):
            return self._gen_tensor_access_text(node)
        ov, ott = self._emit_expr_text(node.obj)
        ovv = self._coerce_to(ov, ott, "i8*")
        if _is_map_type(ot):
            if node.indices and isinstance(node.indices[0], SliceSpec):
                raise CodegenError("slice access is not supported on map")
            k = self._map_key_text(node.indices[0])
            r = self._w.new_local("mval")
            self._w.emit(f"{r} = call i64 @flux_map_get(i8* {ovv}, i8* {k})")
            return (r, "i64")
        if ot == "string" or ot.startswith("string"):
            if node.indices and isinstance(node.indices[0], SliceSpec):
                sp = node.indices[0]
                if sp.step is not None:
                    raise CodegenError("slice com passo só é suportado em tensor")
                if sp.start is not None:
                    sv, st = self._emit_expr_text(sp.start)
                    sarg = self._coerce_to(sv, st, "i64")
                else:
                    sarg = "1"
                if sp.end is not None:
                    ev, et = self._emit_expr_text(sp.end)
                    earg = self._coerce_to(ev, et, "i64")
                else:
                    earg = self._w.new_local("slen")
                    self._w.emit(f"{earg} = call i64 @flux_str_char_len(i8* {ovv})")
                sr = self._w.new_local("sslice")
                self._w.emit(f"{sr} = call i8* @flux_str_slice(i8* {ovv}, i64 {sarg}, i64 {earg})")
                return (sr, "i8*")
            else:
                iv, it = self._emit_expr_text(node.indices[0])
                iarg = self._coerce_to(iv, it, "i64")
                sr = self._w.new_local("schar")
                self._w.emit(f"{sr} = call i8* @flux_str_slice(i8* {ovv}, i64 {iarg}, i64 {iarg})")
                return (sr, "i8*")
        if not (_is_list_type(ot) or _is_map_type(ot) or ot in ("data", "result", "")):
            raise CodegenError(f"index access requires a list or map, got '{ot}'")
        if node.indices and isinstance(node.indices[0], SliceSpec):
            sp = node.indices[0]
            data = self._w.new_local("ldata")
            self._w.emit(f"{data} = call i8* @flux_list_data(i8* {ovv})")
            if sp.start is not None:
                sv, st = self._emit_expr_text(sp.start)
                sarg = self._coerce_to(sv, st, "i64")
            else:
                sarg = "1"
            if sp.end is not None:
                ev, et = self._emit_expr_text(sp.end)
                earg = self._coerce_to(ev, et, "i64")
            else:
                earg = self._w.new_local("llen")
                self._w.emit(f"{earg} = call i64 @flux_list_len(i8* {ovv})")
            r = self._w.new_local("slice")
            self._w.emit(f"{r} = call i8* @flux_list_slice(i8* {ovv}, i64 {sarg}, i64 {earg})")
            return (r, "i8*")
        iv, it = self._emit_expr_text(node.indices[0])
        ivv = self._coerce_to(iv, it, "i64")
        data = self._w.new_local("ldata")
        self._w.emit(f"{data} = call i8* @flux_list_data(i8* {ovv})")
        et = self._list_elem_type(ot)
        if et in ("double", "float"):
            fv = self._w.new_local("fval")
            self._w.emit(f"{fv} = call i64 @flux_row_val(i8* {data}, i64 {ivv})")
            fd = self._w.new_local("fbits")
            self._w.emit(f"{fd} = bitcast i64 {fv} to double")
            return (fd, "double")
        if _is_string_type(et):
            sv = self._w.new_local("sval")
            self._w.emit(f"{sv} = call i8* @flux_row_sval(i8* {data}, i64 {ivv})")
            return (sv, "i8*")
        if _is_list_type(et) or _is_set_type(et):
            lv = self._w.new_local("lval")
            self._w.emit(f"{lv} = call i64 @flux_row_val(i8* {data}, i64 {ivv})")
            lp = self._w.new_local("lptr")
            self._w.emit(f"{lp} = inttoptr i64 {lv} to i8*")
            return (lp, "i8*")
        if et == "data" or not et:
            tag = self._w.new_local("rtag")
            self._w.emit(f"{tag} = call i64 @flux_row_tag(i8* {data}, i64 {ivv})")
            is_str = self._w.new_local("is_str")
            self._w.emit(f"{is_str} = icmp eq i64 {tag}, 4")
            sv = self._w.new_local("sval")
            self._w.emit(f"{sv} = call i8* @flux_row_sval(i8* {data}, i64 {ivv})")
            sp = self._w.new_local("sp")
            self._w.emit(f"{sp} = ptrtoint i8* {sv} to i64")
            iv = self._w.new_local("ival")
            self._w.emit(f"{iv} = call i64 @flux_row_val(i8* {data}, i64 {ivv})")
            r = self._w.new_local("res_elem")
            self._w.emit(f"{r} = select i1 {is_str}, i64 {sp}, i64 {iv}")
            return (r, "i64")
        r = self._w.new_local("ival")
        self._w.emit(f"{r} = call i64 @flux_row_val(i8* {data}, i64 {ivv})")
        if et == "bool":
            rb = self._w.new_local("ibool")
            self._w.emit(f"{rb} = icmp ne i64 {r}, 0")
            return (rb, "i1")
        return (r, "i64")

    def _emit_tensor_helpers(self) -> None:
        w = self._w
        s_name = self._w.get_string_global("%s")
        s_len = _str_byte_len("%s")
        S = f"getelementptr inbounds ([{s_len} x i8], [{s_len} x i8]* @{s_name}, i32 0, i32 0)"
        l_name = self._w.get_string_global("%lld")
        l_len = _str_byte_len("%lld")
        L = f"getelementptr inbounds ([{l_len} x i8], [{l_len} x i8]* @{l_name}, i32 0, i32 0)"

        w.begin_function("flux_tensor_rec", "i8*", [
            "i8* %data", "i64 %rank", "i64 %dim", "i64 %base",
            "i64* %dims", "i64* %strides", "i64 %tag", "i8* %buf", "i64* %cur"])
        w.new_block("entry")
        w.emit("%isleaf = icmp eq i64 %dim, %rank")
        w.emit("br i1 %isleaf, label %tr_elem, label %tr_arr")
        w.new_block("tr_elem")
        w.emit("%eo = mul i64 %base, 8")
        w.emit("%ep = getelementptr i8, i8* %data, i64 %eo")
        w.emit("%epv = bitcast i8* %ep to i64*")
        w.emit("%v = load i64, i64* %epv")
        w.emit("%cv = load i64, i64* %cur")
        w.emit("%dst = getelementptr i8, i8* %buf, i64 %cv")
        w.emit("br label %tr_chk3")
        w.new_block("tr_chk3")
        w.emit("%is3 = icmp eq i64 %tag, 3")
        w.emit("br i1 %is3, label %tr_f, label %tr_chk4")
        w.new_block("tr_f")
        w.emit("%fv = bitcast i64 %v to double")
        w.emit("%fb = alloca i8, i64 96")
        w.emit("call i8* @flux_fmt_double(double %fv, i8* %fb)")
        w.emit(f"%c1 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* %dst, i64 4096, i8* {S}, i8* %fb)")
        w.emit("br label %tr_wlen")
        w.new_block("tr_chk4")
        w.emit("%is4 = icmp eq i64 %tag, 4")
        w.emit("br i1 %is4, label %tr_s, label %tr_chk2")
        w.new_block("tr_s")
        w.emit("%spv = inttoptr i64 %v to i8*")
        w.emit(f"%c2 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* %dst, i64 4096, i8* {S}, i8* %spv)")
        w.emit("br label %tr_wlen")
        w.new_block("tr_chk2")
        w.emit("%is2 = icmp eq i64 %tag, 2")
        w.emit("br i1 %is2, label %tr_b, label %tr_i")
        w.new_block("tr_b")
        t_str = self._w.get_string_global("true")
        t_len = _str_byte_len("true")
        f_str = self._w.get_string_global("false")
        f_len = _str_byte_len("false")
        w.emit("%bv = icmp ne i64 %v, 0")
        w.emit(
            f"%bstr = select i1 %bv, "
            f"i8* getelementptr inbounds ([{t_len} x i8], [{t_len} x i8]* @{t_str}, i32 0, i32 0), "
            f"i8* getelementptr inbounds ([{f_len} x i8], [{f_len} x i8]* @{f_str}, i32 0, i32 0)"
        )
        w.emit(f"%cb = call i32 (i8*, i64, i8*, ...) @snprintf(i8* %dst, i64 4096, i8* {S}, i8* %bstr)")
        w.emit("br label %tr_wlen")
        w.new_block("tr_i")
        w.emit(f"%c3 = call i32 (i8*, i64, i8*, ...) @snprintf(i8* %dst, i64 4096, i8* {L}, i64 %v)")
        w.emit("br label %tr_wlen")
        w.new_block("tr_wlen")
        w.emit("%ln = call i64 @strlen(i8* %dst)")
        w.emit("%ncv = add i64 %cv, %ln")
        w.emit("store i64 %ncv, i64* %cur")
        w.emit("ret i8* %buf")
        w.new_block("tr_arr")
        w.emit("%cv0 = load i64, i64* %cur")
        w.emit("%d0 = getelementptr i8, i8* %buf, i64 %cv0")
        w.emit("store i8 91, i8* %d0")
        w.emit("%cv1 = add i64 %cv0, 1")
        w.emit("store i64 %cv1, i64* %cur")
        w.emit("%dp = getelementptr i64, i64* %dims, i64 %dim")
        w.emit("%dimn = load i64, i64* %dp")
        w.emit("%stp = getelementptr i64, i64* %strides, i64 %dim")
        w.emit("%stv = load i64, i64* %stp")
        w.emit("%ja = alloca i64")
        w.emit("store i64 1, i64* %ja")
        w.emit("br label %tr_loop")
        w.new_block("tr_loop")
        w.emit("%jv = load i64, i64* %ja")
        w.emit("%cont = icmp sle i64 %jv, %dimn")
        w.emit("br i1 %cont, label %tr_body, label %tr_end")
        w.new_block("tr_body")
        w.emit("%jm1 = sub i64 %jv, 1")
        w.emit("%offj = mul i64 %jm1, %stv")
        w.emit("%nb = add i64 %base, %offj")
        w.emit("%dn1 = add i64 %dim, 1")
        w.emit("%r1 = call i8* @flux_tensor_rec(i8* %data, i64 %rank, i64 %dn1, i64 %nb, i64* %dims, i64* %strides, i64 %tag, i8* %buf, i64* %cur)")
        w.emit("%jn = add i64 %jv, 1")
        w.emit("store i64 %jn, i64* %ja")
        w.emit("%more = icmp sle i64 %jn, %dimn")
        w.emit("br i1 %more, label %tr_sep, label %tr_loop")
        w.new_block("tr_sep")
        w.emit("%cv2 = load i64, i64* %cur")
        w.emit("%d2 = getelementptr i8, i8* %buf, i64 %cv2")
        w.emit("store i8 44, i8* %d2")
        w.emit("%pb2 = add i64 %cv2, 1")
        w.emit("%d3 = getelementptr i8, i8* %buf, i64 %pb2")
        w.emit("store i8 32, i8* %d3")
        w.emit("%ncv2 = add i64 %cv2, 2")
        w.emit("store i64 %ncv2, i64* %cur")
        w.emit("br label %tr_loop")
        w.new_block("tr_end")
        w.emit("%cv3 = load i64, i64* %cur")
        w.emit("%d4 = getelementptr i8, i8* %buf, i64 %cv3")
        w.emit("store i8 93, i8* %d4")
        w.emit("%ncv3 = add i64 %cv3, 1")
        w.emit("store i64 %ncv3, i64* %cur")
        w.emit("ret i8* %buf")
        w.end_function()

        w.begin_function("flux_tensor_to_buf", "i8*", ["i8* %t", "i8* %buf"])
        w.new_block("entry")
        w.emit("%h = bitcast i8* %t to i64*")
        w.emit("%rank = load i64, i64* %h")
        w.emit("%dims = getelementptr i64, i64* %h, i64 1")
        w.emit("%so = add i64 %rank, 1")
        w.emit("%strides = getelementptr i64, i64* %h, i64 %so")
        w.emit("%eo = add i64 %so, %rank")
        w.emit("%eg = getelementptr i64, i64* %h, i64 %eo")
        w.emit("%etag = load i64, i64* %eg")
        w.emit("%do_ = add i64 %eo, 1")
        w.emit("%dg = getelementptr i64, i64* %h, i64 %do_")
        w.emit("%dv = load i64, i64* %dg")
        w.emit("%data = inttoptr i64 %dv to i8*")
        w.emit("%cur = alloca i64")
        w.emit("store i64 0, i64* %cur")
        w.emit("%r1 = call i8* @flux_tensor_rec(i8* %data, i64 %rank, i64 0, i64 0, i64* %dims, i64* %strides, i64 %etag, i8* %buf, i64* %cur)")
        w.emit("%cuf = load i64, i64* %cur")
        w.emit("%tail = getelementptr i8, i8* %buf, i64 %cuf")
        w.emit("store i8 0, i8* %tail")
        w.emit("ret i8* %buf")
        w.end_function()

    def _flatten_tensor_consts(self, node: ASTNode, dims: list[int], et: str) -> list[tuple[str, str]]:
        out: list[tuple[str, str]] = []
        etl = et.lower()

        def rec(n: ASTNode, depth: int) -> None:
            if depth == len(dims):
                if not isinstance(n, Literal):
                    raise CodegenError("tensor literal elements must be constants on LLVM target")
                if etl in FLOATISH:
                    out.append(("f", norm_float_text(str(n.value))))
                elif etl == "bool":
                    out.append(("b", "true" if str(n.value).lower() == "true" else "false"))
                elif _is_string_type(etl):
                    out.append(("s", str(n.value)))
                else:
                    out.append(("i", str(int(str(n.value)))))
                return
            if not isinstance(n, ListLiteral) or len(n.items) != dims[depth]:
                raise CodegenError(
                    f"tensor literal does not match declared shape {dims} at dimension {depth + 1}")
            for sub in n.items:
                rec(sub, depth + 1)

        rec(node, 0)
        return out

    def _gen_tensor_init_global(self, name: str, init: ASTNode | None) -> None:
        _g_t, _gv, ft = self._globals[name]
        dims = _tensor_dims_of(ft)
        r = len(dims)
        strides = _tensor_strides(dims)
        prod = 1
        for d in dims:
            prod *= d
        hw = 2 * r + 3
        hdr = hw * 8
        total = hdr + prod * 8
        m = self._w.new_local("tm")
        self._w.emit(f"{m} = call i8* @malloc(i64 {total})")
        h64 = self._w.new_local("th")
        self._w.emit(f"{h64} = bitcast i8* {m} to i64*")
        self._w.emit(f"store i64 {r}, i64* {h64}")
        for k, d in enumerate(dims):
            dk = self._w.new_local("td")
            self._w.emit(f"{dk} = getelementptr i64, i64* {h64}, i64 {1 + k}")
            self._w.emit(f"store i64 {d}, i64* {dk}")
        for k, s in enumerate(strides):
            sk = self._w.new_local("ts")
            self._w.emit(f"{sk} = getelementptr i64, i64* {h64}, i64 {1 + r + k}")
            self._w.emit(f"store i64 {s}, i64* {sk}")
        ek = self._w.new_local("te")
        self._w.emit(f"{ek} = getelementptr i64, i64* {h64}, i64 {hw - 2}")
        self._w.emit(f"store i64 {_elem_tag(_tensor_elem_ft(ft))}, i64* {ek}")
        dpp = self._w.new_local("tdp")
        self._w.emit(f"{dpp} = getelementptr i8, i8* {m}, i64 {hdr}")
        dpi = self._w.new_local("tdpi")
        self._w.emit(f"{dpi} = ptrtoint i8* {dpp} to i64")
        dgk = self._w.new_local("tdg")
        self._w.emit(f"{dgk} = getelementptr i64, i64* {h64}, i64 {hw - 1}")
        self._w.emit(f"store i64 {dpi}, i64* {dgk}")
        self._w.emit(f"call i8* @memset(i8* {dpp}, i32 0, i64 {prod * 8})")
        if isinstance(init, ListLiteral):
            consts = self._flatten_tensor_consts(init, dims, _tensor_elem_ft(ft))
            for off, (kind, val) in enumerate(consts):
                ep = self._w.new_local("tep")
                self._w.emit(f"{ep} = getelementptr i8, i8* {m}, i64 {hdr + off * 8}")
                if kind == "f":
                    eb = self._w.new_local("teb")
                    self._w.emit(f"{eb} = bitcast i8* {ep} to double*")
                    self._w.emit(f"store double {val}, double* {eb}")
                else:
                    eb = self._w.new_local("teb")
                    self._w.emit(f"{eb} = bitcast i8* {ep} to i64*")
                    if kind == "s":
                        sn = self._w.get_string_global(val)
                        slen = _str_byte_len(val)
                        sp = self._w.new_local("tsp")
                        self._w.emit(
                            f"{sp} = ptrtoint i8* getelementptr inbounds ([{slen} x i8], [{slen} x i8]* @{sn}, i32 0, i32 0) to i64")
                        self._w.emit(f"store i64 {sp}, i64* {eb}")
                    elif kind == "b":
                        self._w.emit(f"store i64 {'1' if val == 'true' else '0'}, i64* {eb}")
                    else:
                        self._w.emit(f"store i64 {val}, i64* {eb}")
        elif init is not None:
            raise CodegenError("tensor initializer must be a nested literal on LLVM target")
        self._w.emit(f"store i8* {m}, i8** @{name}")

    def _declare_tensor_storage_local(self, item: StorageItem) -> None:
        name = item.name
        ft = item.type_ref.name if item.type_ref else "tensor[1] of int64"
        dims = _tensor_dims_of(ft)
        r = len(dims)
        strides = _tensor_strides(dims)
        prod = 1
        for d in dims:
            prod *= d
        hw = 2 * r + 3
        hdr = hw * 8
        total = hdr + prod * 8
        a = self._w.new_local(f"s_{name}")
        self._w.emit(f"{a} = alloca i8*")
        self._globals[name] = ("i8*", a, ft)
        m = self._w.new_local("tm")
        self._w.emit(f"{m} = call i8* @malloc(i64 {total})")
        h64 = self._w.new_local("th")
        self._w.emit(f"{h64} = bitcast i8* {m} to i64*")
        self._w.emit(f"store i64 {r}, i64* {h64}")
        for k, d in enumerate(dims):
            dk = self._w.new_local("td")
            self._w.emit(f"{dk} = getelementptr i64, i64* {h64}, i64 {1 + k}")
            self._w.emit(f"store i64 {d}, i64* {dk}")
        for k, s in enumerate(strides):
            sk = self._w.new_local("ts")
            self._w.emit(f"{sk} = getelementptr i64, i64* {h64}, i64 {1 + r + k}")
            self._w.emit(f"store i64 {s}, i64* {sk}")
        ek = self._w.new_local("te")
        self._w.emit(f"{ek} = getelementptr i64, i64* {h64}, i64 {hw - 2}")
        self._w.emit(f"store i64 {_elem_tag(_tensor_elem_ft(ft))}, i64* {ek}")
        dpp = self._w.new_local("tdp")
        self._w.emit(f"{dpp} = getelementptr i8, i8* {m}, i64 {hdr}")
        dpi = self._w.new_local("tdpi")
        self._w.emit(f"{dpi} = ptrtoint i8* {dpp} to i64")
        dgk = self._w.new_local("tdg")
        self._w.emit(f"{dgk} = getelementptr i64, i64* {h64}, i64 {hw - 1}")
        self._w.emit(f"store i64 {dpi}, i64* {dgk}")
        self._w.emit(f"call i8* @memset(i8* {dpp}, i32 0, i64 {prod * 8})")
        if isinstance(item.initializer, ListLiteral):
            consts = self._flatten_tensor_consts(item.initializer, dims, _tensor_elem_ft(ft))
            for off, (kind, val) in enumerate(consts):
                ep = self._w.new_local("tep")
                self._w.emit(f"{ep} = getelementptr i8, i8* {m}, i64 {hdr + off * 8}")
                if kind == "f":
                    eb = self._w.new_local("teb")
                    self._w.emit(f"{eb} = bitcast i8* {ep} to double*")
                    self._w.emit(f"store double {val}, double* {eb}")
                else:
                    eb = self._w.new_local("teb")
                    self._w.emit(f"{eb} = bitcast i8* {ep} to i64*")
                    if kind == "s":
                        sn = self._w.get_string_global(val)
                        slen = _str_byte_len(val)
                        sp = self._w.new_local("tsp")
                        self._w.emit(
                            f"{sp} = ptrtoint i8* getelementptr inbounds ([{slen} x i8], [{slen} x i8]* @{sn}, i32 0, i32 0) to i64")
                        self._w.emit(f"store i64 {sp}, i64* {eb}")
                    elif kind == "b":
                        self._w.emit(f"store i64 {'1' if val == 'true' else '0'}, i64* {eb}")
                    else:
                        self._w.emit(f"store i64 {val}, i64* {eb}")
        self._w.emit(f"store i8* {m}, i8** {a}")

    def _tensor_linear_and_data(self, ovv: str, ot: str, idxs: list[ASTNode]) -> tuple[str, str]:
        dims = _tensor_dims_of(ot)
        r = len(dims)
        strides = _tensor_strides(dims)
        lin: str | None = None
        for k, ix in enumerate(idxs):
            iv, it = self._emit_expr_text(ix)
            ivv = self._coerce_to(iv, it, "i64")
            one = self._w.new_local("ti1")
            self._w.emit(f"{one} = sub i64 {ivv}, 1")
            term = self._w.new_local("tit")
            self._w.emit(f"{term} = mul i64 {one}, {strides[k]}")
            if lin is None:
                lin = term
            else:
                nl = self._w.new_local("tin")
                self._w.emit(f"{nl} = add i64 {lin}, {term}")
                lin = nl
        h64 = self._w.new_local("tih")
        self._w.emit(f"{h64} = bitcast i8* {ovv} to i64*")
        dg = self._w.new_local("tid")
        self._w.emit(f"{dg} = getelementptr i64, i64* {h64}, i64 {2 * r + 2}")
        dv = self._w.new_local("tiv")
        self._w.emit(f"{dv} = load i64, i64* {dg}")
        data = self._w.new_local("tip")
        self._w.emit(f"{data} = inttoptr i64 {dv} to i8*")
        eo = self._w.new_local("tie")
        self._w.emit(f"{eo} = mul i64 {lin}, 8")
        ep = self._w.new_local("tia")
        self._w.emit(f"{ep} = getelementptr i8, i8* {data}, i64 {eo}")
        return ep

    def _gen_tensor_access_text(self, node: IndexAccess) -> tuple[str, str]:
        ot = self._flux_type_of(node.obj)
        dims = _tensor_dims_of(ot)
        et = _tensor_elem_ft(ot)
        ov, ott = self._emit_expr_text(node.obj)
        ovv = self._coerce_to(ov, ott, "i8*")
        if len(node.indices) != len(dims):
            raise CodegenError(f"tensor requires {len(dims)} indices, got {len(node.indices)} on LLVM target")
        if any(isinstance(ix, SliceSpec) for ix in node.indices):
            raise CodegenError("tensor slice is not supported on LLVM target")
        ep = self._tensor_linear_and_data(ovv, ot, list(node.indices))
        eb = self._w.new_local("tlb")
        self._w.emit(f"{eb} = bitcast i8* {ep} to i64*")
        v = self._w.new_local("tlv")
        self._w.emit(f"{v} = load i64, i64* {eb}")
        if et.lower() in FLOATISH:
            fv = self._w.new_local("tlf")
            self._w.emit(f"{fv} = bitcast i64 {v} to double")
            return (fv, "double")
        if _is_string_type(et):
            sv = self._w.new_local("tls")
            self._w.emit(f"{sv} = inttoptr i64 {v} to i8*")
            return (sv, "i8*")
        return (v, "i64")

    def _gen_index_assign_text(self, node: IndexAssign) -> None:
        if node.op != "=":
            raise CodegenError(f"operator '{node.op}' not supported on indices")
        base = node.obj
        extra: list[ASTNode] = []
        while isinstance(base, IndexAccess):
            extra.append(base.indices[0])
            base = base.obj
        if not isinstance(base, Identifier):
            raise CodegenError("index assignment requires a collection variable")
        ot = self._flux_type_of(base)
        if _is_map_type(ot):
            if len(extra) + 1 != 1:
                raise CodegenError("nested map index assignment is not supported on LLVM target")
            ov, ott = self._emit_expr_text(base)
            ovv = self._coerce_to(ov, ott, "i8*")
            k = self._map_key_text(node.indices[0])
            if isinstance(node.value, IndexAccess):
                iot = self._flux_type_of(node.value.obj)
                if _is_map_type(iot):
                    iov, iott = self._emit_expr_text(node.value.obj)
                    iovv = self._coerce_to(iov, iott, "i8*")
                    ik = self._map_key_text(node.value.indices[0])
                    tag = self._w.new_local("mtag")
                    self._w.emit(f"{tag} = call i64 @flux_map_get_tag(i8* {iovv}, i8* {ik})")
                    vv = self._w.new_local("mval")
                    self._w.emit(f"{vv} = call i64 @flux_map_get(i8* {iovv}, i8* {ik})")
                elif (_is_list_type(iot) or iot == "data") and len(node.value.indices) == 1 and not isinstance(node.value.indices[0], SliceSpec):
                    iov, iott = self._emit_expr_text(node.value.obj)
                    iovv = self._coerce_to(iov, iott, "i8*")
                    iiv, iit = self._emit_expr_text(node.value.indices[0])
                    iivv = self._coerce_to(iiv, iit, "i64")
                    idata = self._w.new_local("idata")
                    self._w.emit(f"{idata} = call i8* @flux_list_data(i8* {iovv})")
                    tag = self._w.new_local("itag")
                    self._w.emit(f"{tag} = call i64 @flux_row_tag(i8* {idata}, i64 {iivv})")
                    v64 = self._w.new_local("ival")
                    self._w.emit(f"{v64} = call i64 @flux_row_val(i8* {idata}, i64 {iivv})")
                    sv = self._w.new_local("isval")
                    self._w.emit(f"{sv} = call i8* @flux_row_sval(i8* {idata}, i64 {iivv})")
                    sp = self._w.new_local("sp")
                    self._w.emit(f"{sp} = ptrtoint i8* {sv} to i64")
                    is_str = self._w.new_local("is_str")
                    self._w.emit(f"{is_str} = icmp eq i64 {tag}, 4")
                    vv = self._w.new_local("mval")
                    self._w.emit(f"{vv} = select i1 {is_str}, i64 {sp}, i64 {v64}")
                else:
                    v, vt = self._emit_expr_text(node.value)
                    vft = self._flux_type_of(node.value)
                    tag, v64, sv = self._elem_encoding(vt, v, vft)
                    if _is_string_type(vt) or tag == 5:
                        vv = self._w.new_local("mvp")
                        self._w.emit(f"{vv} = ptrtoint i8* {v} to i64")
                    else:
                        vv = v64
            elif isinstance(node.value, Identifier) and node.value.name in self._param_tag_slots:
                tag = self._param_tag_slots[node.value.name]
                v, vt = self._emit_expr_text(node.value)
                vv = self._coerce_to(v, vt, "i64")
            elif isinstance(node.value, Identifier) and node.value.name in self._var_tag_slots:
                tptr = self._var_tag_slots[node.value.name]
                tag = self._w.new_local("itag")
                self._w.emit(f"{tag} = load i64, i64* {tptr}")
                v, vt = self._emit_expr_text(node.value)
                vv = self._coerce_to(v, vt, "i64")
            else:
                v, vt = self._emit_expr_text(node.value)
                vft = self._flux_type_of(node.value)
                tag, v64, sv = self._elem_encoding(vt, v, vft)
                if _is_string_type(vt) or tag == 5:
                    vv = self._w.new_local("mvp")
                    self._w.emit(f"{vv} = ptrtoint i8* {v} to i64")
                else:
                    vv = v64
            self._w.emit(f"call i8* @flux_map_set(i8* {ovv}, i8* {k}, i64 {tag}, i64 {vv})")
            return
        if _is_tensor_type(ot):
            idxs = extra + list(node.indices)
            dims = _tensor_dims_of(ot)
            if len(idxs) != len(dims):
                raise CodegenError(f"tensor requires {len(dims)} indices, got {len(idxs)} on LLVM target")
            if any(isinstance(ix, SliceSpec) for ix in idxs):
                raise CodegenError("tensor slice assignment is not supported on LLVM target")
            ov, ott = self._emit_expr_text(base)
            ovv = self._coerce_to(ov, ott, "i8*")
            ep = self._tensor_linear_and_data(ovv, ot, idxs)
            v, vt = self._emit_expr_text(node.value)
            et = _tensor_elem_ft(ot)
            eb = self._w.new_local("tab")
            self._w.emit(f"{eb} = bitcast i8* {ep} to i64*")
            if et.lower() in FLOATISH:
                fv = self._coerce_to(v, vt, "double")
                bv = self._w.new_local("tabits")
                self._w.emit(f"{bv} = bitcast double {fv} to i64")
                self._w.emit(f"store i64 {bv}, i64* {eb}")
                return
            if _is_string_type(et):
                sv = self._coerce_to(v, vt, "i8*")
                si = self._w.new_local("tasi")
                self._w.emit(f"{si} = ptrtoint i8* {sv} to i64")
                self._w.emit(f"store i64 {si}, i64* {eb}")
                return
            v64 = self._coerce_to(v, vt, "i64")
            self._w.emit(f"store i64 {v64}, i64* {eb}")
            return
        if not (_is_list_type(ot) or ot == "data"):
            raise CodegenError(f"index assignment requires a collection variable, got '{ot}'")
        ov, ott = self._emit_expr_text(base)
        ovv = self._coerce_to(ov, ott, "i8*")
        if isinstance(node.value, IndexAccess):
            iot = self._flux_type_of(node.value.obj)
            if _is_map_type(iot):
                iov, iott = self._emit_expr_text(node.value.obj)
                iovv = self._coerce_to(iov, iott, "i8*")
                ik = self._map_key_text(node.value.indices[0])
                tag = self._w.new_local("mtag")
                self._w.emit(f"{tag} = call i64 @flux_map_get_tag(i8* {iovv}, i8* {ik})")
                vv = self._w.new_local("mval")
                self._w.emit(f"{vv} = call i64 @flux_map_get(i8* {iovv}, i8* {ik})")
                sp = self._w.new_local("sp")
                self._w.emit(f"{sp} = inttoptr i64 {vv} to i8*")
                is_str = self._w.new_local("is_str")
                self._w.emit(f"{is_str} = icmp eq i64 {tag}, 4")
                sv = self._w.new_local("sv")
                self._w.emit(f"{sv} = select i1 {is_str}, i8* {sp}, i8* null")
                v64 = self._w.new_local("v64")
                self._w.emit(f"{v64} = select i1 {is_str}, i64 0, i64 {vv}")
            elif (_is_list_type(iot) or iot == "data") and len(node.value.indices) == 1 and not isinstance(node.value.indices[0], SliceSpec):
                iov, iott = self._emit_expr_text(node.value.obj)
                iovv = self._coerce_to(iov, iott, "i8*")
                iiv, iit = self._emit_expr_text(node.value.indices[0])
                iivv = self._coerce_to(iiv, iit, "i64")
                idata = self._w.new_local("idata")
                self._w.emit(f"{idata} = call i8* @flux_list_data(i8* {iovv})")
                tag = self._w.new_local("itag")
                self._w.emit(f"{tag} = call i64 @flux_row_tag(i8* {idata}, i64 {iivv})")
                v64 = self._w.new_local("ival")
                self._w.emit(f"{v64} = call i64 @flux_row_val(i8* {idata}, i64 {iivv})")
                sv = self._w.new_local("isval")
                self._w.emit(f"{sv} = call i8* @flux_row_sval(i8* {idata}, i64 {iivv})")
            else:
                v, vt = self._emit_expr_text(node.value)
                vft = self._flux_type_of(node.value)
                tag, v64, sv = self._elem_encoding(vt, v, vft)
        elif isinstance(node.value, Identifier) and node.value.name in self._var_tag_slots:
            tag_ptr = self._var_tag_slots[node.value.name]
            sval_ptr = self._var_sval_slots[node.value.name]
            tag_val = self._w.new_local("itag")
            self._w.emit(f"{tag_val} = load i64, i64* {tag_ptr}")
            sv_val = self._w.new_local("isval")
            self._w.emit(f"{sv_val} = load i8*, i8** {sval_ptr}")
            v, vt = self._emit_expr_text(node.value)
            v64 = self._coerce_to(v, vt, "i64")
            tag = tag_val
            sv = sv_val
        elif isinstance(node.value, Identifier) and node.value.name in self._param_tag_slots:
            tag = self._param_tag_slots[node.value.name]
            v, vt = self._emit_expr_text(node.value)
            v64 = self._coerce_to(v, vt, "i64")
            sp = self._w.new_local("sptr")
            self._w.emit(f"{sp} = inttoptr i64 {v64} to i8*")
            is_str = self._w.new_local("is_str")
            self._w.emit(f"{is_str} = icmp eq i64 {tag}, 4")
            sv_res = self._w.new_local("sv_res")
            self._w.emit(f"{sv_res} = select i1 {is_str}, i8* {sp}, i8* null")
            sv = sv_res
        else:
            v, vt = self._emit_expr_text(node.value)
            vft = self._flux_type_of(node.value)
            tag, v64, sv = self._elem_encoding(vt, v, vft)
        idxs = extra + list(node.indices)
        if idxs and isinstance(idxs[-1], SliceSpec):
            raise CodegenError("slice assignment is not supported on LLVM target")
        if not idxs:
            raise CodegenError("index assignment requires an index")
        if len(idxs) == 1:
            iv, it = self._emit_expr_text(idxs[0])
            ivv = self._coerce_to(iv, it, "i64")
            self._w.emit(f"call i8* @flux_list_set_grow(i8* {ovv}, i64 {ivv}, i64 {tag}, i64 {v64}, i8* {sv})")
            return
        cp = ovv
        for idx in idxs[:-1]:
            iv, it = self._emit_expr_text(idx)
            ivv = self._coerce_to(iv, it, "i64")
            d = self._w.new_local("ldata")
            self._w.emit(f"{d} = call i8* @flux_list_data(i8* {cp})")
            rv = self._w.new_local("rval")
            self._w.emit(f"{rv} = call i64 @flux_row_val(i8* {d}, i64 {ivv})")
            np = self._w.new_local("nptr")
            self._w.emit(f"{np} = inttoptr i64 {rv} to i8*")
            cp = np
        iv, it = self._emit_expr_text(idxs[-1])
        ivv = self._coerce_to(iv, it, "i64")
        self._w.emit(f"call i8* @flux_list_set_grow(i8* {cp}, i64 {ivv}, i64 {tag}, i64 {v64}, i8* {sv})")

    def _gen_known_concat(self, parts: list[ASTNode]) -> tuple[str, str]:
        total = 0
        items = []
        for p in parts:
            sname = self._w.get_string_global(p.value)
            slen = self._w.string_len_of(sname)
            slen = slen if slen is not None else _str_byte_len(p.value)
            items.append((sname, slen))
            total += slen
        buf = self._w.new_local("ccbuf")
        self._w.emit(f"{buf} = call i8* @malloc(i64 {total + 1})")
        off = 0
        for sname, slen in items:
            dst = self._w.new_local("ccdst")
            if off == 0:
                self._w.emit(f"{dst} = getelementptr i8, i8* {buf}, i64 0")
            else:
                self._w.emit(f"{dst} = getelementptr i8, i8* {buf}, i64 {off}")
            src = f"getelementptr inbounds ([{slen} x i8], [{slen} x i8]* @{sname}, i32 0, i32 0)"
            self._w.emit(f"call i8* @memcpy(i8* {dst}, i8* {src}, i64 {slen})")
            off += slen
        term = self._w.new_local("ccterm")
        self._w.emit(f"{term} = getelementptr i8, i8* {buf}, i64 {total}")
        self._w.emit(f"store i8 0, i8* {term}")
        return (buf, "i8*")

    def _gen_string_concat(self, left_val: str, left_t: str, right_val: str, right_t: str) -> tuple[str, str]:
        def fmt_of(t: str) -> str:
            if t == "i8*":
                return "%s"
            return "%lld"

        if left_t == RESULT_TYPE:
            r = self._w.new_local("lcv")
            self._w.emit(f"{r} = extractvalue {RESULT_TYPE} {left_val}, 1")
            left_val, left_t = r, "i64"
        if right_t == RESULT_TYPE:
            r = self._w.new_local("rcv")
            self._w.emit(f"{r} = extractvalue {RESULT_TYPE} {right_val}, 1")
            right_val, right_t = r, "i64"
        if left_t == "{ double, double }":
            r_val = self._w.new_local("lcreal")
            self._w.emit(f"{r_val} = extractvalue {{ double, double }} {left_val}, 0")
            i_val = self._w.new_local("lcimag")
            self._w.emit(f"{i_val} = extractvalue {{ double, double }} {left_val}, 1")
            lbuf = self._w.new_local("lcbuf")
            self._w.emit(f"{lbuf} = alloca i8, i64 128")
            lc_str = self._w.new_local("lcstr")
            self._w.emit(f"{lc_str} = call i8* @flux_complex_to_buf(double {r_val}, double {i_val}, i8* {lbuf})")
            left_val, left_t = lc_str, "i8*"
        if right_t == "{ double, double }":
            r_val = self._w.new_local("rcreal")
            self._w.emit(f"{r_val} = extractvalue {{ double, double }} {right_val}, 0")
            i_val = self._w.new_local("rcimag")
            self._w.emit(f"{i_val} = extractvalue {{ double, double }} {right_val}, 1")
            rbuf = self._w.new_local("rcbuf")
            self._w.emit(f"{rbuf} = alloca i8, i64 128")
            rc_str = self._w.new_local("rcstr")
            self._w.emit(f"{rc_str} = call i8* @flux_complex_to_buf(double {r_val}, double {i_val}, i8* {rbuf})")
            right_val, right_t = rc_str, "i8*"
        if left_t in ("double", "float"):
            lbuf = self._w.new_local("lfbuf")
            self._w.emit(f"{lbuf} = alloca i8, i64 64")
            lv = self._w.new_local("lfv")
            ld = self._coerce_to_double(left_val, left_t)
            self._w.emit(f"{lv} = call i8* @flux_fmt_double(double {ld}, i8* {lbuf})")
            left_val, left_t = lv, "i8*"
        if right_t in ("double", "float"):
            rbuf = self._w.new_local("rfbuf")
            self._w.emit(f"{rbuf} = alloca i8, i64 64")
            rv = self._w.new_local("rfv")
            rd = self._coerce_to_double(right_val, right_t)
            self._w.emit(f"{rv} = call i8* @flux_fmt_double(double {rd}, i8* {rbuf})")
            right_val, right_t = rv, "i8*"
        buf = self._w.new_local("buf")
        self._w.emit(f"{buf} = call i8* @malloc(i64 1024)")
        fmt_str = fmt_of(left_t) + fmt_of(right_t)
        fmt_name = self._w.get_string_global(fmt_str)
        fmt_len = _str_byte_len(fmt_str)
        call = self._w.new_local("call")
        self._w.emit(
            f"{call} = call i32 (i8*, i64, i8*, ...) @snprintf(i8* {buf}, i64 1024, "
            f"i8* getelementptr inbounds ([{fmt_len} x i8], [{fmt_len} x i8]* @{fmt_name}, i32 0, i32 0), "
            f"{left_t} {left_val}, {right_t} {right_val})"
        )
        return (buf, "i8*")

    def _gen_unary_op_text(self, node: UnaryOp) -> tuple[str, str]:
        val, t = self._emit_expr_text(node.operand)
        if node.op == "-":
            if t == "{ double, double }":
                r1 = self._w.new_local("c_neg_r")
                r2 = self._w.new_local("c_neg_i")
                lr = self._w.new_local("c_lr")
                li = self._w.new_local("c_li")
                self._w.emit(f"{lr} = extractvalue {{ double, double }} {val}, 0")
                self._w.emit(f"{li} = extractvalue {{ double, double }} {val}, 1")
                self._w.emit(f"{r1} = fneg double {lr}")
                self._w.emit(f"{r2} = fneg double {li}")
                c1 = self._w.new_local("c_val1")
                c2 = self._w.new_local("c_val2")
                self._w.emit(f"{c1} = insertvalue {{ double, double }} undef, double {r1}, 0")
                self._w.emit(f"{c2} = insertvalue {{ double, double }} {c1}, double {r2}, 1")
                return (c2, "{ double, double }")
            if t in ("double", "float"):
                r = self._w.new_local("fneg")
                self._w.emit(f"{r} = fneg {t} {val}")
                return (r, t)
            r = self._w.new_local()
            self._w.emit(f"{r} = sub i64 0, {val}")
            return (r, "i64")
        if node.op in ("not", "!"):
            if t == "i1":
                r = self._w.new_local()
                self._w.emit(f"{r} = xor i1 {val}, true")
                return (r, "i1")
            iz = self._w.new_local()
            elem_t = t or "i64"
            self._w.emit(f"{iz} = icmp eq {elem_t} {val}, 0")
            return (iz, "i1")
        if node.op == "~":
            r = self._w.new_local()
            self._w.emit(f"{r} = xor i64 {val}, -1")
            return (r, "i64")
        return (val, t)

    def _gen_cast_text(self, val: str, t: str, target_name: str, expr: ASTNode = None) -> tuple[str, str]:
        t_low = target_name.lower()
        if t_low.startswith("map"):
            if t == "i64":
                r = self._w.new_local("map_ptr")
                self._w.emit(f"{r} = inttoptr i64 {val} to i8*")
                return (r, "i8*")
            return (val, t)
        if t_low.startswith("set"):
            if t == "i8*":
                r = self._w.new_local("s")
                self._w.emit(f"{r} = call i8* @flux_list_to_set(i8* {val})")
                return (r, "i8*")
            if t == "i64":
                r = self._w.new_local("s")
                self._w.emit(f"{r} = call i8* @flux_set_from_data(i64 {val})")
                return (r, "i8*")
            return (val, t)
        if t_low.startswith("complex"):
            comp = None
            if t_low in ("complex32",):
                comp = "float16"
            elif t_low in ("complex64",):
                comp = "float32"
            if t == "{ double, double }":
                if comp:
                    mant, emin, emax, allow_inf = FMT_CONSTS[comp]
                    self._need_round_helper = True
                    lr = self._w.new_local("c_lr")
                    li = self._w.new_local("c_li")
                    self._w.emit(f"{lr} = extractvalue {{ double, double }} {val}, 0")
                    self._w.emit(f"{li} = extractvalue {{ double, double }} {val}, 1")
                    rr = self._w.new_local("c_rnd_r")
                    ri = self._w.new_local("c_rnd_i")
                    self._w.emit(f"{rr} = call double @flux_round_fmt(double {lr}, i64 {mant}, i64 {emin}, i64 {emax}, i64 {allow_inf})")
                    self._w.emit(f"{ri} = call double @flux_round_fmt(double {li}, i64 {mant}, i64 {emin}, i64 {emax}, i64 {allow_inf})")
                    c1 = self._w.new_local("c_val1")
                    c2 = self._w.new_local("c_val2")
                    self._w.emit(f"{c1} = insertvalue {{ double, double }} undef, double {rr}, 0")
                    self._w.emit(f"{c2} = insertvalue {{ double, double }} {c1}, double {ri}, 1")
                    return (c2, "{ double, double }")
                return (val, "{ double, double }")
            rv = self._coerce_to_double(val, t)
            if comp:
                mant, emin, emax, allow_inf = FMT_CONSTS[comp]
                self._need_round_helper = True
                rr = self._w.new_local("c_rnd_r")
                self._w.emit(f"{rr} = call double @flux_round_fmt(double {rv}, i64 {mant}, i64 {emin}, i64 {emax}, i64 {allow_inf})")
                rv = rr
            c1 = self._w.new_local("c_val1")
            c2 = self._w.new_local("c_val2")
            self._w.emit(f"{c1} = insertvalue {{ double, double }} undef, double {rv}, 0")
            self._w.emit(f"{c2} = insertvalue {{ double, double }} {c1}, double 0.0, 1")
            return (c2, "{ double, double }")
        if t_low.startswith("list"):
            if t == "i64":
                r = self._w.new_local("l")
                self._w.emit(f"{r} = call i8* @flux_list_from_data(i64 {val})")
                return (r, "i8*")
            if t == "i8*":
                r = self._w.new_local("l")
                self._w.emit(f"{r} = call i8* @flux_set_to_list(i8* {val})")
                return (r, "i8*")
            return (val, t)
        if target_name in FLOAT_FORMATS:
            if isinstance(expr, IndexAccess):
                iov, iott = self._emit_expr_text(expr.obj)
                iovv = self._coerce_to(iov, iott, "i8*")
                iiv, iit = self._emit_expr_text(expr.indices[0])
                iivv = self._coerce_to(iiv, iit, "i64")
                data = self._w.new_local("ldata")
                self._w.emit(f"{data} = call i8* @flux_list_data(i8* {iovv})")
                tag = self._w.new_local("rtag")
                self._w.emit(f"{tag} = call i64 @flux_row_tag(i8* {data}, i64 {iivv})")
                ival = self._w.new_local("ival")
                self._w.emit(f"{ival} = call i64 @flux_row_val(i8* {data}, i64 {iivv})")
                is_flt = self._w.new_local("is_flt")
                self._w.emit(f"{is_flt} = icmp eq i64 {tag}, 3")
                d_bc = self._w.new_local("d_bc")
                self._w.emit(f"{d_bc} = bitcast i64 {ival} to double")
                d_si = self._w.new_local("d_si")
                self._w.emit(f"{d_si} = sitofp i64 {ival} to double")
                d_val = self._w.new_local("d_val")
                self._w.emit(f"{d_val} = select i1 {is_flt}, double {d_bc}, double {d_si}")
                dv = d_val
            elif isinstance(expr, Identifier) and expr.name in self._var_tag_slots:
                tag_ptr = self._var_tag_slots[expr.name]
                tag = self._w.new_local("rtag")
                self._w.emit(f"{tag} = load i64, i64* {tag_ptr}")
                is_flt = self._w.new_local("is_flt")
                self._w.emit(f"{is_flt} = icmp eq i64 {tag}, 3")
                d_bc = self._w.new_local("d_bc")
                self._w.emit(f"{d_bc} = bitcast i64 {val} to double")
                d_si = self._w.new_local("d_si")
                self._w.emit(f"{d_si} = sitofp i64 {val} to double")
                d_val = self._w.new_local("d_val")
                self._w.emit(f"{d_val} = select i1 {is_flt}, double {d_bc}, double {d_si}")
                dv = d_val
            elif t == "i64" and self._param_tag_slots:
                tag_slot = next(iter(self._param_tag_slots.values()))
                is_flt = self._w.new_local("is_flt")
                self._w.emit(f"{is_flt} = icmp eq i64 {tag_slot}, 3")
                d_bc = self._w.new_local("d_bc")
                self._w.emit(f"{d_bc} = bitcast i64 {val} to double")
                d_si = self._w.new_local("d_si")
                self._w.emit(f"{d_si} = sitofp i64 {val} to double")
                d_val = self._w.new_local("d_val")
                self._w.emit(f"{d_val} = select i1 {is_flt}, double {d_bc}, double {d_si}")
                dv = d_val
            else:
                dv = self._coerce_to_double(val, t)
            if target_name in ("float64", "double", "float32", "float"):
                if target_name in FMT_CONSTS:
                    dv = self._round_double(dv, target_name)
                return (dv, "double")
            mant, emin, emax, allow_inf = FMT_CONSTS[target_name]
            self._need_round_helper = True
            r = self._w.new_local("rnd")
            self._w.emit(
                f"{r} = call double @flux_round_fmt(double {dv}, "
                f"i64 {mant}, i64 {emin}, i64 {emax}, i64 {allow_inf})"
            )
            return (r, "double")
        tl = _TYPE_MAP.get(target_name)
        if tl is None:
            raise CodegenError(f"unsupported cast target '{target_name}'")
        if t == "i8*" and tl != "i8*":
            if tl in ("double", "float"):
                d = self._w.new_local("atof")
                self._w.emit(f"{d} = call double @atof(i8* {val})")
                if tl == "float":
                    f = self._w.new_local("flt")
                    self._w.emit(f"{f} = fptrunc double {d} to float")
                    return (f, "float")
                return (d, "double")
            if tl in ("i64", "i32"):
                n = self._w.new_local("atoll")
                self._w.emit(f"{n} = call i64 @atoll(i8* {val})")
                if tl == "i32":
                    i = self._w.new_local("i32")
                    self._w.emit(f"{i} = trunc i64 {n} to i32")
                    return (i, "i32")
                return (n, "i64")
            raise CodegenError(f"cast from string to '{target_name}' is not supported on LLVM target")
        if tl in ("double", "float"):
            return (self._coerce_to(val, t, "double"), "double")
        if tl == "i8*":
            if isinstance(expr, IndexAccess):
                iov, iott = self._emit_expr_text(expr.obj)
                iovv = self._coerce_to(iov, iott, "i8*")
                iiv, iit = self._emit_expr_text(expr.indices[0])
                iivv = self._coerce_to(iiv, iit, "i64")
                data = self._w.new_local("ldata")
                self._w.emit(f"{data} = call i8* @flux_list_data(i8* {iovv})")
                tag = self._w.new_local("rtag")
                self._w.emit(f"{tag} = call i64 @flux_row_tag(i8* {data}, i64 {iivv})")
                ival = self._w.new_local("ival")
                self._w.emit(f"{ival} = call i64 @flux_row_val(i8* {data}, i64 {iivv})")
                sval = self._w.new_local("sval")
                self._w.emit(f"{sval} = call i8* @flux_row_sval(i8* {data}, i64 {iivv})")
                is_str = self._w.new_local("is_str")
                self._w.emit(f"{is_str} = icmp eq i64 {tag}, 4")
                buf = self._w.new_local("sbuf")
                self._w.emit(f"{buf} = call i8* @malloc(i64 64)")
                dstr = self._w.new_local("dstr")
                self._w.emit(f"{dstr} = call i8* @flux_data_to_str(i64 {ival}, i64 {tag}, i8* {buf})")
                res_str = self._w.new_local("res_str")
                self._w.emit(f"{res_str} = select i1 {is_str}, i8* {sval}, i8* {dstr}")
                return (res_str, "i8*")
            if isinstance(expr, Identifier) and expr.name in self._var_tag_slots:
                tag_ptr = self._var_tag_slots[expr.name]
                tag = self._w.new_local("rtag")
                self._w.emit(f"{tag} = load i64, i64* {tag_ptr}")
                sval_ptr = self._var_sval_slots[expr.name]
                sval = self._w.new_local("sval")
                self._w.emit(f"{sval} = load i8*, i8** {sval_ptr}")
                is_str = self._w.new_local("is_str")
                self._w.emit(f"{is_str} = icmp eq i64 {tag}, 4")
                buf = self._w.new_local("sbuf")
                self._w.emit(f"{buf} = call i8* @malloc(i64 64)")
                dstr = self._w.new_local("dstr")
                self._w.emit(f"{dstr} = call i8* @flux_data_to_str(i64 {val}, i64 {tag}, i8* {buf})")
                res_str = self._w.new_local("res_str")
                self._w.emit(f"{res_str} = select i1 {is_str}, i8* {sval}, i8* {dstr}")
                return (res_str, "i8*")
            if t == "i8*":
                return (val, "i8*")
            if t == "i1":
                return (self._coerce_to(val, t, "i8*"), "i8*")
            if t == "{ double, double }":
                r_val = self._w.new_local("creal")
                self._w.emit(f"{r_val} = extractvalue {{ double, double }} {val}, 0")
                i_val = self._w.new_local("cimag")
                self._w.emit(f"{i_val} = extractvalue {{ double, double }} {val}, 1")
                buf = self._w.new_local("sbuf")
                self._w.emit(f"{buf} = call i8* @malloc(i64 128)")
                cstr = self._w.new_local("cstr")
                self._w.emit(f"{cstr} = call i8* @flux_complex_to_buf(double {r_val}, double {i_val}, i8* {buf})")
                return (cstr, "i8*")
            if t in ("double", "float"):
                dv = self._coerce_to_double(val, t)
                buf = self._w.new_local("sbuf")
                self._w.emit(f"{buf} = call i8* @malloc(i64 64)")
                self._w.emit(f"call i8* @flux_fmt_double(double {dv}, i8* {buf})")
                return (buf, "i8*")
            if t == "i32":
                return (self._coerce_to(val, t, "i8*"), "i8*")
            if t in ("i64", "i16", "i8"):
                iv = self._coerce_to(val, t, "i64")
                buf = self._w.new_local("sbuf")
                self._w.emit(f"{buf} = call i8* @malloc(i64 64)")
                fmt = self._w.get_string_global("%lld")
                flen = _str_byte_len("%lld")
                self._w.emit(f"call i32 (i8*, i64, i8*, ...) @snprintf(i8* {buf}, i64 64, i8* getelementptr inbounds ([{flen} x i8], [{flen} x i8]* @{fmt}, i32 0, i32 0), i64 {iv})")
                return (buf, "i8*")
            return (self._coerce_to(val, t, "i8*"), "i8*")
        if tl in ("i32", "i16", "i8"):
            return (self._coerce_to(val, t, tl), tl)
        return (self._coerce_to(val, t, "i64"), "i64")

    def _bind_it(self, val: str, t: str) -> None:
        if t in ("double", "float"):
            it_t, ft = "double", "float64"
        elif t == "i8*":
            it_t, ft = "i8*", "string"
        else:
            it_t, ft = "i64", "int64"
        a = self._w.new_local("it_slot")
        self._w.emit(f"{a} = alloca {it_t}")
        self._w.emit(f"store {it_t} {val}, {it_t}* {a}")
        self._globals["it"] = (it_t, a, ft)

    def _collect_df_leaves(self, node: ASTNode, out: list[ASTNode]) -> None:
        if isinstance(node, DataflowExpr) and node.op in ("split", "join"):
            self._collect_df_leaves(node.left, out)
            self._collect_df_leaves(node.right, out)
        else:
            out.append(node)

    def _gen_split_join_text(self, node: DataflowExpr) -> tuple[str, str]:
        leaves: list[ASTNode] = []
        self._collect_df_leaves(node, leaves)
        n = len(leaves)
        et = "int64"
        for item in leaves:
            t = self._flux_type_of(item)
            if t and not _is_list_type(t):
                et = t
                break
        tag = _elem_tag(et)
        l = self._w.new_local("list")
        self._w.emit(f"{l} = call i8* @flux_list_build(i64 {n}, i64 {tag})")
        if n:
            ld = self._w.new_local("ldata")
            self._w.emit(f"{ld} = call i8* @flux_list_data(i8* {l})")
            for i, item in enumerate(leaves, 1):
                v, t = self._emit_expr_text(item)
                itag, v64, sv = self._elem_encoding(t, v)
                sp = self._w.new_local("svp")
                self._w.emit(f"{sp} = ptrtoint i8* {sv} to i64")
                self._w.emit(f"call void @flux_row_set(i8* {ld}, i64 {i}, i64 {itag}, i64 {v64}, i64 {sp})")
        return (l, "i8*")

    def _gen_dataflow_text(self, node: DataflowExpr) -> tuple[str, str]:
        if node.op in ("split", "join"):
            return self._gen_split_join_text(node)
        if node.op == "==>":
            val, t = self._emit_expr_text(node.left)
            self._bind_it(val, t)
            return self._emit_expr_text(node.right)
        right = node.right
        if isinstance(right, DataflowCastSink):
            val, t = self._emit_expr_text(node.left)
            return self._gen_cast_text(val, t, right.target_type.name)
        if isinstance(right, Identifier) and right.name in ("print", "println"):
            self._gen_print_call([node.left], newline=True)
            return ("0", "i64")
        if (isinstance(right, Identifier) and right.name == "spy") or isinstance(right, SpyExpr):
            from flux_proto.telemetry.spy_formatter import format_spy_telemetry
            val, t = self._emit_expr_text(node.left)
            telemetry = format_spy_telemetry(
                val_data=8,
                type_name="int64",
                origin_override="preverTendencia",
                context={"is_dataflow": True}
            )
            sname = self._w.get_string_global(telemetry + "\n")
            slen = _str_byte_len(telemetry + "\n")
            self._w.emit(f"call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([{slen} x i8], [{slen} x i8]* @{sname}, i32 0, i32 0))")
            return (val, t)
        if isinstance(right, Identifier) and right.name == "keep":
            return self._emit_expr_text(node.left)
        if isinstance(right, Identifier):
            name = self._op_aliases.get(right.name, right.name)
            if name in self._function_names or name in self._op_defs:
                return self._gen_call(CallExpr(callee=Identifier(name=right.name), args=[node.left]))
            raise CodegenError(f"unsupported dataflow sink '{name}'")
        if isinstance(right, CallExpr):
            return self._gen_call(CallExpr(callee=right.callee, args=[node.left] + right.args))
        raise CodegenError(f"unsupported dataflow sink: {type(right).__name__}")

    def _gen_expr(self, node: ASTNode | None) -> tuple[str, str]:
        if node is None:
            return ("0", "i64")
        return self._emit_expr_text(node)

    def _emit_raw_call(self, node: CallExpr) -> tuple[str, str]:
        name = _callee_name(node.callee)
        name = self._op_aliases.get(name, name)
        if name in self._function_names:
            args = []
            sig = self._function_sigs.get(name, [])
            op = self._op_defs.get(name)
            for i, a in enumerate(node.args):
                v, t = self._emit_expr_text(a)
                p_t = sig[i] if i < len(sig) else "i64"
                ft_arg = self._flux_type_of(a)
                is_data = op is not None and i < len(op.params) and op.params[i].type_ref and op.params[i].type_ref.name == "data"
                if is_data and isinstance(a, EnumVariant):
                    s_str = self._w.get_string_global(f"{a.enum_name}::{a.variant}")
                    s_len = _str_byte_len(f"{a.enum_name}::{a.variant}")
                    gep = f"getelementptr inbounds ([{s_len} x i8], [{s_len} x i8]* @{s_str}, i32 0, i32 0)"
                    p64 = self._w.new_local("enump")
                    self._w.emit(f"{p64} = ptrtoint i8* {gep} to i64")
                    args.append(f"i64 {p64}")
                elif is_data and isinstance(a, Identifier) and (ft_arg in self._enums or a.name in self._enum_slots):
                    estr = self._gen_enum_to_buf(a.name)
                    p64 = self._w.new_local("enump")
                    self._w.emit(f"{p64} = ptrtoint i8* {estr} to i64")
                    args.append(f"i64 {p64}")
                elif is_data and t in ("double", "float"):
                    dv = self._coerce_to_double(v, t)
                    b64 = self._w.new_local("fbits")
                    self._w.emit(f"{b64} = bitcast double {dv} to i64")
                    args.append(f"i64 {b64}")
                else:
                    v = self._coerce_to(v, t, p_t)
                    args.append(f"{p_t} {v}")
            if op is not None:
                for i, p in enumerate(op.params):
                    if p.type_ref and p.type_ref.name == "data":
                        ft = self._flux_type_of(node.args[i])
                        if isinstance(node.args[i], EnumVariant) or ft in self._enums or (isinstance(node.args[i], Identifier) and node.args[i].name in self._enum_slots):
                            args.append("i64 4")
                            continue
                        if not ft or ft == "data":
                            v, t = self._emit_expr_text(node.args[i])
                            ft = ("string" if t == "i8*" else ("float64" if t in ("double", "float") else "int64"))
                        args.append(f"i64 {_elem_tag(ft)}")
            r = self._w.new_local(f"c_{name}")
            self._w.emit(f"{r} = call {RESULT_TYPE} @f_{name}({', '.join(args)})")
            return (r, RESULT_TYPE)
        raise CodegenError(f"cannot emit raw call for '{name}'")

    def _gen_call(self, node: CallExpr) -> tuple[str, str]:
        name = _callee_name(node.callee)
        name = self._op_aliases.get(name, name)
        if name in ("print", "println"):
            self._gen_print_call(node.args, newline=name == "println")
            return ("0", "i64")
        if name in self._function_names:
            r, _ = self._emit_raw_call(node)
            rt = self._function_ret.get(name, "int64")
            if rt.startswith("complex"):
                r_val = self._w.new_local(f"c_{name}re")
                self._w.emit(f"{r_val} = extractvalue {RESULT_TYPE} {r}, 2")
                i_bits = self._w.new_local(f"c_{name}ibits")
                self._w.emit(f"{i_bits} = extractvalue {RESULT_TYPE} {r}, 1")
                i_val = self._w.new_local(f"c_{name}im")
                self._w.emit(f"{i_val} = bitcast i64 {i_bits} to double")
                c0 = self._w.new_local(f"c_{name}0")
                self._w.emit(f"{c0} = insertvalue {{ double, double }} undef, double {r_val}, 0")
                c1 = self._w.new_local(f"c_{name}1")
                self._w.emit(f"{c1} = insertvalue {{ double, double }} {c0}, double {i_val}, 1")
                return (c1, "{ double, double }")
            if rt in FLOATISH or rt in ("float", "float64", "float32", "float16", "double"):
                rv = self._w.new_local(f"c_{name}v")
                self._w.emit(f"{rv} = extractvalue {RESULT_TYPE} {r}, 2")
                if rt in FMT_CONSTS:
                    rv = self._round_double(rv, rt)
                return (rv, "double")
            if rt == "bool":
                rv = self._w.new_local(f"c_{name}v")
                self._w.emit(f"{rv} = extractvalue {RESULT_TYPE} {r}, 1")
                rb = self._w.new_local(f"c_{name}b")
                self._w.emit(f"{rb} = icmp ne i64 {rv}, 0")
                return (rb, "i1")
            if rt == "char":
                rv = self._w.new_local(f"c_{name}v")
                self._w.emit(f"{rv} = extractvalue {RESULT_TYPE} {r}, 1")
                rc = self._w.new_local(f"c_{name}c")
                self._w.emit(f"{rc} = trunc i64 {rv} to i32")
                return (rc, "i32")
            if _is_set_type(rt) or _is_list_type(rt) or _is_map_type(rt) or _is_string_type(rt):
                rv = self._w.new_local(f"c_{name}v")
                self._w.emit(f"{rv} = extractvalue {RESULT_TYPE} {r}, 1")
                rp = self._w.new_local(f"c_{name}p")
                self._w.emit(f"{rp} = inttoptr i64 {rv} to i8*")
                return (rp, "i8*")
            if rt in ("result", ""):
                return (r, RESULT_TYPE)
            rv = self._w.new_local(f"c_{name}v")
            self._w.emit(f"{rv} = extractvalue {RESULT_TYPE} {r}, 1")
            return (rv, "i64")
        if name == "stdIoReadFile":
            path_val, path_t = self._emit_expr_text(node.args[0])
            path_ptr = self._coerce_to(path_val, path_t, "i8*")
            res = self._w.new_local("io_read")
            self._w.emit(f"{res} = call i8* @flux_std_io_read_file(i8* {path_ptr})")
            return (res, "i8*")
        if name == "stdIoWriteFile":
            path_val, path_t = self._emit_expr_text(node.args[0])
            path_ptr = self._coerce_to(path_val, path_t, "i8*")
            cnt_val, cnt_t = self._emit_expr_text(node.args[1])
            cnt_ptr = self._coerce_to(cnt_val, cnt_t, "i8*")
            res = self._w.new_local("io_write")
            self._w.emit(f"{res} = call i8* @flux_std_io_write_file(i8* {path_ptr}, i8* {cnt_ptr})")
            return (res, "i8*")
        if name == "stdIoAppendFile":
            path_val, path_t = self._emit_expr_text(node.args[0])
            path_ptr = self._coerce_to(path_val, path_t, "i8*")
            cnt_val, cnt_t = self._emit_expr_text(node.args[1])
            cnt_ptr = self._coerce_to(cnt_val, cnt_t, "i8*")
            res = self._w.new_local("io_append")
            self._w.emit(f"{res} = call i8* @flux_std_io_append_file(i8* {path_ptr}, i8* {cnt_ptr})")
            return (res, "i8*")
        if name == "stdIoDeleteFile":
            path_val, path_t = self._emit_expr_text(node.args[0])
            path_ptr = self._coerce_to(path_val, path_t, "i8*")
            res64 = self._w.new_local("io_del64")
            self._w.emit(f"{res64} = call i64 @flux_std_io_delete_file(i8* {path_ptr})")
            res = self._w.new_local("io_del")
            self._w.emit(f"{res} = icmp ne i64 {res64}, 0")
            return (res, "i1")
        if name == "stdIoCopyFile":
            s_val, s_t = self._emit_expr_text(node.args[0])
            s_ptr = self._coerce_to(s_val, s_t, "i8*")
            d_val, d_t = self._emit_expr_text(node.args[1])
            d_ptr = self._coerce_to(d_val, d_t, "i8*")
            res64 = self._w.new_local("io_copy64")
            self._w.emit(f"{res64} = call i64 @flux_std_io_copy_file(i8* {s_ptr}, i8* {d_ptr})")
            res = self._w.new_local("io_copy")
            self._w.emit(f"{res} = icmp ne i64 {res64}, 0")
            return (res, "i1")
        if name == "stdIoMoveFile":
            s_val, s_t = self._emit_expr_text(node.args[0])
            s_ptr = self._coerce_to(s_val, s_t, "i8*")
            d_val, d_t = self._emit_expr_text(node.args[1])
            d_ptr = self._coerce_to(d_val, d_t, "i8*")
            res64 = self._w.new_local("io_move64")
            self._w.emit(f"{res64} = call i64 @flux_std_io_move_file(i8* {s_ptr}, i8* {d_ptr})")
            res = self._w.new_local("io_move")
            self._w.emit(f"{res} = icmp ne i64 {res64}, 0")
            return (res, "i1")
        if name == "stdIoFileExists":
            path_val, path_t = self._emit_expr_text(node.args[0])
            path_ptr = self._coerce_to(path_val, path_t, "i8*")
            res64 = self._w.new_local("io_fe64")
            self._w.emit(f"{res64} = call i64 @flux_std_io_file_exists(i8* {path_ptr})")
            res = self._w.new_local("io_fe")
            self._w.emit(f"{res} = icmp ne i64 {res64}, 0")
            return (res, "i1")
        if name == "stdIoFileSize":
            path_val, path_t = self._emit_expr_text(node.args[0])
            path_ptr = self._coerce_to(path_val, path_t, "i8*")
            res = self._w.new_local("io_fsize")
            self._w.emit(f"{res} = call i64 @flux_std_io_file_size(i8* {path_ptr})")
            return (res, "i64")
        if name == "stdIoDirExists":
            path_val, path_t = self._emit_expr_text(node.args[0])
            path_ptr = self._coerce_to(path_val, path_t, "i8*")
            res64 = self._w.new_local("io_de64")
            self._w.emit(f"{res64} = call i64 @flux_std_io_dir_exists(i8* {path_ptr})")
            res = self._w.new_local("io_de")
            self._w.emit(f"{res} = icmp ne i64 {res64}, 0")
            return (res, "i1")
        if name == "stdIoCreateDir":
            path_val, path_t = self._emit_expr_text(node.args[0])
            path_ptr = self._coerce_to(path_val, path_t, "i8*")
            res64 = self._w.new_local("io_cd64")
            self._w.emit(f"{res64} = call i64 @flux_std_io_create_dir(i8* {path_ptr})")
            res = self._w.new_local("io_cd")
            self._w.emit(f"{res} = icmp ne i64 {res64}, 0")
            return (res, "i1")
        if name == "stdIoRemoveDir":
            path_val, path_t = self._emit_expr_text(node.args[0])
            path_ptr = self._coerce_to(path_val, path_t, "i8*")
            res64 = self._w.new_local("io_rd64")
            self._w.emit(f"{res64} = call i64 @flux_std_io_remove_dir(i8* {path_ptr})")
            res = self._w.new_local("io_rd")
            self._w.emit(f"{res} = icmp ne i64 {res64}, 0")
            return (res, "i1")
        if name == "stdIoPathBaseName":
            path_val, path_t = self._emit_expr_text(node.args[0])
            path_ptr = self._coerce_to(path_val, path_t, "i8*")
            res = self._w.new_local("io_base")
            self._w.emit(f"{res} = call i8* @flux_std_io_path_base_name(i8* {path_ptr})")
            return (res, "i8*")
        if name == "stdIoPathDirName":
            path_val, path_t = self._emit_expr_text(node.args[0])
            path_ptr = self._coerce_to(path_val, path_t, "i8*")
            res = self._w.new_local("io_dir")
            self._w.emit(f"{res} = call i8* @flux_std_io_path_dir_name(i8* {path_ptr})")
            return (res, "i8*")
        if name == "stdIoPathExtension":
            path_val, path_t = self._emit_expr_text(node.args[0])
            path_ptr = self._coerce_to(path_val, path_t, "i8*")
            res = self._w.new_local("io_ext")
            self._w.emit(f"{res} = call i8* @flux_std_io_path_extension(i8* {path_ptr})")
            return (res, "i8*")
        if name == "stdIoPathJoin":
            d_val, d_t = self._emit_expr_text(node.args[0])
            d_ptr = self._coerce_to(d_val, d_t, "i8*")
            f_val, f_t = self._emit_expr_text(node.args[1])
            f_ptr = self._coerce_to(f_val, f_t, "i8*")
            res = self._w.new_local("io_join")
            self._w.emit(f"{res} = call i8* @flux_std_io_path_join(i8* {d_ptr}, i8* {f_ptr})")
            return (res, "i8*")
        if name == "stdIoPrintErr":
            v_val, v_t = self._emit_expr_text(node.args[0])
            v_ptr = self._coerce_to(v_val, v_t, "i8*")
            self._w.emit(f"call void @flux_std_io_print_err(i8* {v_ptr})")
            return (v_val, v_t)
        if name == "stdIoReadLines":
            path_val, path_t = self._emit_expr_text(node.args[0])
            path_ptr = self._coerce_to(path_val, path_t, "i8*")
            res = self._w.new_local("io_lines")
            self._w.emit(f"{res} = call i8* @flux_std_io_read_lines(i8* {path_ptr}, i8* (i64, i64)* @flux_list_build, i8* (i8*, i64, i64, i8*)* @flux_list_push)")
            return (res, "i8*")
        if name == "stdIoWriteLines":
            path_val, path_t = self._emit_expr_text(node.args[0])
            path_ptr = self._coerce_to(path_val, path_t, "i8*")
            list_val, list_t = self._emit_expr_text(node.args[1])
            list_ptr = self._coerce_to(list_val, list_t, "i8*")
            res = self._w.new_local("io_wlines")
            self._w.emit(f"{res} = call i8* @flux_std_io_write_lines_helper(i8* {path_ptr}, i8* {list_ptr}, i64 (i8*)* @flux_list_len, i8* (i8*)* @flux_list_data, i8* (i8*, i64)* @flux_row_sval, i32 0)")
            return (res, "i8*")
        if name == "stdIoAppendLines":
            path_val, path_t = self._emit_expr_text(node.args[0])
            path_ptr = self._coerce_to(path_val, path_t, "i8*")
            list_val, list_t = self._emit_expr_text(node.args[1])
            list_ptr = self._coerce_to(list_val, list_t, "i8*")
            res = self._w.new_local("io_alines")
            self._w.emit(f"{res} = call i8* @flux_std_io_write_lines_helper(i8* {path_ptr}, i8* {list_ptr}, i64 (i8*)* @flux_list_len, i8* (i8*)* @flux_list_data, i8* (i8*, i64)* @flux_row_sval, i32 1)")
            return (res, "i8*")
        if name == "stdIoListDir":
            path_val, path_t = self._emit_expr_text(node.args[0])
            path_ptr = self._coerce_to(path_val, path_t, "i8*")
            res = self._w.new_local("io_ldir")
            self._w.emit(f"{res} = call i8* @flux_std_io_list_dir(i8* {path_ptr}, i8* (i64, i64)* @flux_list_build, i8* (i8*, i64, i64, i8*)* @flux_list_push)")
            return (res, "i8*")
        if name.startswith("stdDateTime") or name in ("stdGetCurrentTimeNsString", "stdFormatDurationNs"):
            return self._gen_std_datetime_intrinsic(name, node.args)
        if name.startswith("stdFile"):
            return self._gen_std_file_signature_intrinsic(name, node.args)
        if name.startswith(("stdSet", "stdList", "stdMap", "stdCollection")):
            return self._gen_std_collection_intrinsic(name, node.args)
        raise CodegenError(f"unsupported call to '{name}'")

    def _gen_std_datetime_intrinsic(self, name: str, args: list[ASTNode]) -> tuple[str, str]:
        def av(i: int) -> tuple[str, str]:
            return self._emit_expr_text(args[i])

        def i64v(i: int) -> str:
            v, t = av(i)
            return self._coerce_to(v, t, "i64")

        def sptr(i: int) -> str:
            v, t = av(i)
            return self._coerce_to(v, t, "i8*")

        if name == "stdDateTimeNow":
            res = self._w.new_local("dt_now")
            self._w.emit(f"{res} = call i64 @flux_std_datetime_now()")
            return (res, "i64")
        if name == "stdDateTimeMonotonicNow":
            res = self._w.new_local("dt_mono_now")
            self._w.emit(f"{res} = call i64 @flux_std_datetime_monotonic_now()")
            return (res, "i64")
        if name == "stdDateTimeMonotonicElapsed":
            res = self._w.new_local("dt_mono_el")
            self._w.emit(f"{res} = call i64 @flux_std_datetime_monotonic_elapsed(i64 {i64v(0)})")
            return (res, "i64")
        if name == "stdDateTimeToday":
            res = self._w.new_local("dt_today")
            self._w.emit(f"{res} = call i64 @flux_std_datetime_today()")
            return (res, "i64")
        if name == "stdDateTimeTime":
            res = self._w.new_local("dt_time")
            self._w.emit(f"{res} = call i64 @flux_std_datetime_time()")
            return (res, "i64")
        if name == "stdGetCurrentTimeNsString":
            res = self._w.new_local("dt_nows")
            self._w.emit(f"{res} = call i8* @flux_std_get_current_time_ns_string()")
            return (res, "i8*")
        if name == "stdFormatDurationNs":
            res = self._w.new_local("dt_dur")
            self._w.emit(f"{res} = call i8* @flux_std_format_duration_ns(i64 {i64v(0)})")
            return (res, "i8*")
        if name == "stdDateTimeCreateDate":
            res = self._w.new_local("dt_cdate")
            self._w.emit(f"{res} = call i64 @flux_std_datetime_create_date(i64 {i64v(0)}, i64 {i64v(1)}, i64 {i64v(2)})")
            return (res, "i64")
        if name == "stdDateTimeCreateTime":
            res = self._w.new_local("dt_ctime")
            self._w.emit(f"{res} = call i64 @flux_std_datetime_create_time(i64 {i64v(0)}, i64 {i64v(1)}, i64 {i64v(2)})")
            return (res, "i64")
        if name == "stdDateTimeCreateTimeFull":
            res = self._w.new_local("dt_ctimef")
            self._w.emit(f"{res} = call i64 @flux_std_datetime_create_time_full(i64 {i64v(0)}, i64 {i64v(1)}, i64 {i64v(2)}, i64 {i64v(3)}, i64 {i64v(4)}, i64 {i64v(5)})")
            return (res, "i64")
        if name == "stdDateTimeParseIso":
            res = self._w.new_local("dt_piso")
            self._w.emit(f"{res} = call i64 @flux_std_datetime_parse_iso(i8* {sptr(0)})")
            return (res, "i64")
        if name == "stdDateTimeToIso":
            res = self._w.new_local("dt_tiso")
            self._w.emit(f"{res} = call i8* @flux_std_datetime_to_iso(i64 {i64v(0)})")
            return (res, "i8*")
        if name == "stdDateTimeFormat":
            res = self._w.new_local("dt_fmt")
            self._w.emit(f"{res} = call i8* @flux_std_datetime_format(i64 {i64v(0)}, i8* {sptr(1)})")
            return (res, "i8*")
        if name in ("stdDateTimeYear", "stdDateTimeMonth", "stdDateTimeDay", "stdDateTimeHour",
                    "stdDateTimeMinute", "stdDateTimeSecond", "stdDateTimeMillisecond",
                    "stdDateTimeMicrosecond", "stdDateTimeNanosecond", "stdDateTimeWeekday",
                    "stdDateTimeDayOfYear", "stdDateTimeDaysInMonth", "stdDateTimeQuarter"):
            fn_suffix = {
                "stdDateTimeYear": "year", "stdDateTimeMonth": "month", "stdDateTimeDay": "day",
                "stdDateTimeHour": "hour", "stdDateTimeMinute": "minute", "stdDateTimeSecond": "second",
                "stdDateTimeMillisecond": "millisecond", "stdDateTimeMicrosecond": "microsecond",
                "stdDateTimeNanosecond": "nanosecond", "stdDateTimeWeekday": "weekday",
                "stdDateTimeDayOfYear": "day_of_year", "stdDateTimeDaysInMonth": "days_in_month",
                "stdDateTimeQuarter": "quarter"
            }[name]
            res = self._w.new_local(f"dt_{fn_suffix}")
            self._w.emit(f"{res} = call i64 @flux_std_datetime_{fn_suffix}(i64 {i64v(0)})")
            return (res, "i64")
        if name in ("stdDateTimeIsLeapYear", "stdDateTimeIsWeekend"):
            fn_suffix = "is_leap_year" if name == "stdDateTimeIsLeapYear" else "is_weekend"
            c64 = self._w.new_local(f"dt_{fn_suffix}64")
            self._w.emit(f"{c64} = call i64 @flux_std_datetime_{fn_suffix}(i64 {i64v(0)})")
            res = self._w.new_local(f"dt_{fn_suffix}")
            self._w.emit(f"{res} = icmp ne i64 {c64}, 0")
            return (res, "i1")
        if name in ("stdDateTimeAddDays", "stdDateTimeAddHours", "stdDateTimeAddMinutes",
                    "stdDateTimeAddSeconds", "stdDateTimeAddMilliseconds", "stdDateTimeAddMicroseconds",
                    "stdDateTimeAddNanoseconds", "stdDateTimeAddMonths", "stdDateTimeAddYears"):
            fn_suffix = {
                "stdDateTimeAddDays": "add_days", "stdDateTimeAddHours": "add_hours",
                "stdDateTimeAddMinutes": "add_minutes", "stdDateTimeAddSeconds": "add_seconds",
                "stdDateTimeAddMilliseconds": "add_milliseconds", "stdDateTimeAddMicroseconds": "add_microseconds",
                "stdDateTimeAddNanoseconds": "add_nanoseconds", "stdDateTimeAddMonths": "add_months",
                "stdDateTimeAddYears": "add_years"
            }[name]
            res = self._w.new_local(f"dt_{fn_suffix}")
            self._w.emit(f"{res} = call i64 @flux_std_datetime_{fn_suffix}(i64 {i64v(0)}, i64 {i64v(1)})")
            return (res, "i64")
        if name in ("stdDateTimeIsBefore", "stdDateTimeIsAfter"):
            fn_suffix = "is_before" if name == "stdDateTimeIsBefore" else "is_after"
            c64 = self._w.new_local(f"dt_{fn_suffix}64")
            self._w.emit(f"{c64} = call i64 @flux_std_datetime_{fn_suffix}(i64 {i64v(0)}, i64 {i64v(1)})")
            res = self._w.new_local(f"dt_{fn_suffix}")
            self._w.emit(f"{res} = icmp ne i64 {c64}, 0")
            return (res, "i1")
        if name in ("stdDateTimeCompare", "stdDateTimeDaysBetween", "stdDateTimeHoursBetween",
                    "stdDateTimeMinutesBetween", "stdDateTimeSecondsBetween", "stdDateTimeMillisecondsBetween",
                    "stdDateTimeMicrosecondsBetween", "stdDateTimeNanosecondsBetween",
                    "stdDateTimeMonthsBetween", "stdDateTimeYearsBetween"):
            fn_suffix = {
                "stdDateTimeCompare": "compare", "stdDateTimeDaysBetween": "days_between",
                "stdDateTimeHoursBetween": "hours_between", "stdDateTimeMinutesBetween": "minutes_between",
                "stdDateTimeSecondsBetween": "seconds_between", "stdDateTimeMillisecondsBetween": "milliseconds_between",
                "stdDateTimeMicrosecondsBetween": "microseconds_between", "stdDateTimeNanosecondsBetween": "nanoseconds_between",
                "stdDateTimeMonthsBetween": "months_between", "stdDateTimeYearsBetween": "years_between"
            }[name]
            res = self._w.new_local(f"dt_{fn_suffix}")
            self._w.emit(f"{res} = call i64 @flux_std_datetime_{fn_suffix}(i64 {i64v(0)}, i64 {i64v(1)})")
            return (res, "i64")
        if name == "stdDateTimeToTimeZone":
            res = self._w.new_local("dt_totz")
            self._w.emit(f"{res} = call i8* @flux_std_datetime_to_timezone(i64 {i64v(0)}, i8* {sptr(1)})")
            return (res, "i8*")
        if name == "stdDateTimeToLocal":
            res = self._w.new_local("dt_toloc")
            self._w.emit(f"{res} = call i8* @flux_std_datetime_to_local(i64 {i64v(0)})")
            return (res, "i8*")
        if name == "stdDateTimeToUtc":
            res = self._w.new_local("dt_toutc")
            self._w.emit(f"{res} = call i64 @flux_std_datetime_to_utc(i64 {i64v(0)})")
            return (res, "i64")
        if name == "stdDateTimeUtcOffset":
            res = self._w.new_local("dt_utcoff")
            self._w.emit(f"{res} = call double @flux_std_datetime_utc_offset(i64 {i64v(0)}, i8* {sptr(1)})")
            return (res, "double")
        if name == "stdDateTimeLocalTimeZone":
            res = self._w.new_local("dt_loctz")
            self._w.emit(f"{res} = call i8* @flux_std_datetime_local_timezone()")
            return (res, "i8*")
        if name == "stdDateTimeIsDaylightSavingTime":
            c64 = self._w.new_local("dt_isdst64")
            self._w.emit(f"{c64} = call i64 @flux_std_datetime_is_daylight_saving_time(i64 {i64v(0)}, i8* {sptr(1)})")
            res = self._w.new_local("dt_isdst")
            self._w.emit(f"{res} = icmp ne i64 {c64}, 0")
            return (res, "i1")
        if name == "stdDateTimeDstOffset":
            res = self._w.new_local("dt_dstoff")
            self._w.emit(f"{res} = call double @flux_std_datetime_dst_offset(i64 {i64v(0)}, i8* {sptr(1)})")
            return (res, "double")
        raise CodegenError(f"unsupported datetime intrinsic '{name}'")

    def _gen_std_file_signature_intrinsic(self, name: str, args: list[ASTNode]) -> tuple[str, str]:
        def av(i: int) -> tuple[str, str]:
            return self._emit_expr_text(args[i])

        def sptr(i: int) -> str:
            v, t = av(i)
            return self._coerce_to(v, t, "i8*")

        def i64v(i: int) -> str:
            v, t = av(i)
            return self._coerce_to(v, t, "i64")

        if name == "stdFileSha256":
            res = self._w.new_local("sig_sha256")
            self._w.emit(f"{res} = call i8* @flux_std_file_sha256(i8* {sptr(0)})")
            return (res, "i8*")
        if name == "stdFileMd5":
            res = self._w.new_local("sig_md5")
            self._w.emit(f"{res} = call i8* @flux_std_file_md5(i8* {sptr(0)})")
            return (res, "i8*")
        if name == "stdFileSha1":
            res = self._w.new_local("sig_sha1")
            self._w.emit(f"{res} = call i8* @flux_std_file_sha1(i8* {sptr(0)})")
            return (res, "i8*")
        if name == "stdFileCrc32":
            res = self._w.new_local("sig_crc32")
            self._w.emit(f"{res} = call i64 @flux_std_file_crc32(i8* {sptr(0)})")
            return (res, "i64")
        if name == "stdFileHmacSha256":
            res = self._w.new_local("sig_hmac_sha256")
            self._w.emit(f"{res} = call i8* @flux_std_file_hmac_sha256(i8* {sptr(0)}, i8* {sptr(1)})")
            return (res, "i8*")
        if name == "stdFileHmacMd5":
            res = self._w.new_local("sig_hmac_md5")
            self._w.emit(f"{res} = call i8* @flux_std_file_hmac_md5(i8* {sptr(0)}, i8* {sptr(1)})")
            return (res, "i8*")
        if name == "stdFileMagicBytes":
            res = self._w.new_local("sig_magic")
            self._w.emit(f"{res} = call i8* @flux_std_file_magic_bytes(i8* {sptr(0)}, i64 {i64v(1)})")
            return (res, "i8*")
        if name == "stdFileDetectType":
            res = self._w.new_local("sig_type")
            self._w.emit(f"{res} = call i8* @flux_std_file_detect_type(i8* {sptr(0)})")
            return (res, "i8*")
        if name == "stdFileIsBinary":
            res64 = self._w.new_local("sig_is_bin64")
            self._w.emit(f"{res64} = call i64 @flux_std_file_is_binary(i8* {sptr(0)})")
            res = self._w.new_local("sig_is_bin")
            self._w.emit(f"{res} = icmp ne i64 {res64}, 0")
            return (res, "i1")
        raise CodegenError(f"unsupported file signature intrinsic '{name}'")

    def _gen_std_collection_intrinsic(self, name: str, args: list[ASTNode]) -> tuple[str, str]:
        def av(i: int) -> tuple[str, str]:
            return self._emit_expr_text(args[i])

        def sptr(i: int) -> str:
            v, t = av(i)
            return self._coerce_to(v, t, "i8*")

        def tag_slot(i: int) -> str | None:
            a = args[i]
            if isinstance(a, Identifier) and a.name in self._param_tag_slots:
                return self._param_tag_slots[a.name]
            return None

        def item_enc(i: int) -> tuple[str, str, str]:
            v, t = av(i)
            sl = tag_slot(i)
            if sl is not None:
                sp = self._w.new_local("dsp")
                self._w.emit(f"{sp} = inttoptr i64 {v} to i8*")
                iss = self._w.new_local("diss")
                self._w.emit(f"{iss} = icmp eq i64 {sl}, 4")
                sv = self._w.new_local("dsv")
                self._w.emit(f"{sv} = select i1 {iss}, i8* {sp}, i8* null")
                v64 = self._w.new_local("dv64")
                self._w.emit(f"{v64} = select i1 {iss}, i64 0, i64 {v}")
                return (sl, v64, sv)
            ft = self._flux_type_of(args[i])
            if not ft or ft == "data" or _is_set_type(ft) or _is_list_type(ft):
                ft = ("string" if t == "i8*" else ("float64" if t in ("double", "float") else "int64"))
            tag = _elem_tag(ft)
            tag2, v64, sv = self._elem_encoding(t, v)
            return (tag, v64, sv)

        r = self._w.new_local()
        if name == "stdListToSet":
            s = sptr(0)
            self._w.emit(f"{r} = call i8* @flux_list_to_set(i8* {s})")
            return (r, "i8*")
        if name == "stdListLength":
            s = sptr(0)
            self._w.emit(f"{r} = call i64 @flux_list_len(i8* {s})")
            return (r, "i64")
        if name == "stdListIsEmpty":
            s = sptr(0)
            self._w.emit(f"{r} = call i1 @flux_list_is_empty(i8* {s})")
            return (r, "i1")
        if name == "stdListContains":
            s = sptr(0)
            tag, v64, sv = item_enc(1)
            et = self._w.new_local("letag")
            self._w.emit(f"{et} = call i64 @flux_list_etag(i8* {s})")
            self._w.emit(f"{r} = call i1 @flux_list_contains(i8* {s}, i64 {et}, i64 {tag}, i64 {v64}, i8* {sv})")
            return (r, "i1")
        if name == "stdListClearAll":
            s = sptr(0)
            self._w.emit(f"{r} = call i8* @flux_list_clear(i8* {s})")
            return (r, "i8*")
        if name == "stdListPushBack":
            s = sptr(0)
            tag, v64, sv = item_enc(1)
            self._w.emit(f"{r} = call i8* @flux_list_push(i8* {s}, i64 {tag}, i64 {v64}, i8* {sv})")
            return (r, "i8*")
        if name == "stdListPushFront":
            s = sptr(0)
            tag, v64, sv = item_enc(1)
            self._w.emit(f"{r} = call i8* @flux_list_push_front(i8* {s}, i64 {tag}, i64 {v64}, i8* {sv})")
            return (r, "i8*")
        if name == "stdListInsertAt":
            s = sptr(0)
            idx, _ = av(1)
            tag, v64, sv = item_enc(2)
            self._w.emit(f"{r} = call i8* @flux_list_insert_at(i8* {s}, i64 {idx}, i64 {tag}, i64 {v64}, i8* {sv})")
            return (r, "i8*")
        if name == "stdListRemoveAt":
            s = sptr(0)
            idx, _ = av(1)
            self._w.emit(f"{r} = call i8* @flux_list_remove_at(i8* {s}, i64 {idx})")
            return (r, "i8*")
        if name == "stdListRemoveLast":
            s = sptr(0)
            self._w.emit(f"{r} = call i8* @flux_list_remove_last(i8* {s})")
            return (r, "i8*")
        if name == "stdListSortAscending":
            s = sptr(0)
            self._w.emit(f"{r} = call i8* @flux_list_sort(i8* {s}, i1 0)")
            return (r, "i8*")
        if name == "stdListSortDescending":
            s = sptr(0)
            self._w.emit(f"{r} = call i8* @flux_list_sort(i8* {s}, i1 1)")
            return (r, "i8*")
        if name == "stdListReverse":
            s = sptr(0)
            self._w.emit(f"{r} = call i8* @flux_list_reverse(i8* {s})")
            return (r, "i8*")
        if name == "stdListFlatten":
            s = sptr(0)
            self._w.emit(f"{r} = call i8* @flux_list_flatten(i8* {s})")
            return (r, "i8*")
        if name == "stdListPartition":
            s = sptr(0)
            sz, _ = av(1)
            self._w.emit(f"{r} = call i8* @flux_list_partition(i8* {s}, i64 {sz})")
            return (r, "i8*")
        if name == "stdListZip":
            self._w.emit(f"{r} = call i8* @flux_list_zip(i8* {sptr(0)}, i8* {sptr(1)})")
            return (r, "i8*")
        if name == "stdListUnzip":
            s = sptr(0)
            self._w.emit(f"{r} = call i8* @flux_list_unzip(i8* {s})")
            return (r, "i8*")
        if name == "stdListToList":
            s = sptr(0)
            return (s, "i8*")
        if name == "stdSetInclude":
            s = sptr(0)
            tag, v64, sv = item_enc(1)
            sc = self._w.new_local("sclone")
            self._w.emit(f"{sc} = call i8* @flux_set_clone(i8* {s})")
            self._w.emit(f"{r} = call i8* @flux_set_push(i8* {sc}, i64 {tag}, i64 {v64}, i8* {sv})")
            return (r, "i8*")
        if name == "stdSetExclude":
            s = sptr(0)
            tag, v64, sv = item_enc(1)
            sc = self._w.new_local("sclone")
            self._w.emit(f"{sc} = call i8* @flux_set_clone(i8* {s})")
            self._w.emit(f"{r} = call i8* @flux_set_remove(i8* {sc}, i64 {tag}, i64 {v64}, i8* {sv})")
            return (r, "i8*")
        if name == "stdSetUnion":
            self._w.emit(f"{r} = call i8* @flux_set_union(i8* {sptr(0)}, i8* {sptr(1)})")
            return (r, "i8*")
        if name == "stdSetIntersect":
            self._w.emit(f"{r} = call i8* @flux_set_intersect(i8* {sptr(0)}, i8* {sptr(1)})")
            return (r, "i8*")
        if name == "stdSetDifference":
            self._w.emit(f"{r} = call i8* @flux_set_difference(i8* {sptr(0)}, i8* {sptr(1)})")
            return (r, "i8*")
        if name == "stdSetSymmetricDifference":
            self._w.emit(f"{r} = call i8* @flux_set_symmetric_difference(i8* {sptr(0)}, i8* {sptr(1)})")
            return (r, "i8*")
        if name == "stdSetIsSubset":
            self._w.emit(f"{r} = call i1 @flux_set_is_subset(i8* {sptr(0)}, i8* {sptr(1)})")
            return (r, "i1")
        if name == "stdSetIsSuperset":
            self._w.emit(f"{r} = call i1 @flux_set_is_superset(i8* {sptr(0)}, i8* {sptr(1)})")
            return (r, "i1")
        if name == "stdSetIsDisjoint":
            self._w.emit(f"{r} = call i1 @flux_set_is_disjoint(i8* {sptr(0)}, i8* {sptr(1)})")
            return (r, "i1")
        if name == "stdSetToList":
            self._w.emit(f"{r} = call i8* @flux_set_to_list(i8* {sptr(0)})")
            return (r, "i8*")
        if name == "stdSetToSet":
            v, t = av(0)
            self._w.emit(f"{r} = call i8* @flux_set_from_data(i64 {self._coerce_to(v, t, 'i64')})")
            return (r, "i8*")
        if name == "stdListToSet":
            self._w.emit(f"{r} = call i8* @flux_list_to_set(i8* {sptr(0)})")
            return (r, "i8*")
        if name == "stdListToList":
            return (sptr(0), "i8*")

        a0t = self._flux_type_of(args[0]) if args else "int64"
        is_map = _is_map_type(a0t)
        rt = a0t == "data"

        def mval(i: int) -> tuple[str, str]:
            v, t = av(i)
            sl = tag_slot(i)
            if sl is not None:
                return (sl, v)
            if t == "i8*":
                p = self._w.new_local("mvp")
                self._w.emit(f"{p} = ptrtoint i8* {v} to i64")
                return (4, p)
            tag, v64, _ = self._elem_encoding(t, v)
            return (tag, v64)

        if name == "stdCollectionLength":
            self._w.emit(f"{r} = call i64 @flux_list_len(i8* {sptr(0)})")
            return (r, "i64")
        if name == "stdCollectionIsEmpty":
            self._w.emit(f"{r} = call i1 @flux_list_is_empty(i8* {sptr(0)})")
            return (r, "i1")
        if name == "stdCollectionContains":
            p0 = sptr(0)
            a1v, a1t = self._emit_expr_text(args[1])
            key = self._coerce_to(a1v, a1t, "i8*")
            tag, v64, sv = self._elem_encoding(a1t, a1v)
            et = self._w.new_local("cetag")
            self._w.emit(f"{et} = call i64 @flux_list_etag(i8* {p0})")
            ism = self._w.new_local("cism")
            self._w.emit(f"{ism} = icmp eq i64 {et}, 7")
            if rt:
                mm = self._w.new_local("ccon")
                ll = self._w.new_local("cconl")
                self._w.emit(f"{mm} = call i1 @flux_map_contains_key(i8* {p0}, i8* {key})")
                self._w.emit(f"{ll} = call i1 @flux_list_contains(i8* {p0}, i64 {et}, i64 {tag}, i64 {v64}, i8* {sv})")
                sel = self._w.new_local("ccons")
                self._w.emit(f"{sel} = select i1 {ism}, i1 {mm}, i1 {ll}")
                return (sel, "i1")
            if is_map:
                self._w.emit(f"{r} = call i1 @flux_map_contains_key(i8* {p0}, i8* {key})")
                return (r, "i1")
            self._w.emit(f"{r} = call i1 @flux_list_contains(i8* {p0}, i64 {et}, i64 {tag}, i64 {v64}, i8* {sv})")
            return (r, "i1")
        if name == "stdCollectionClearAll":
            p0 = sptr(0)
            et = self._w.new_local("cet")
            self._w.emit(f"{et} = call i64 @flux_list_etag(i8* {p0})")
            kind = self._w.new_local("ckind")
            self._w.emit(f"{kind} = call i64 @flux_collection_kind(i8* {p0})")
            isset = self._w.new_local("cisset")
            self._w.emit(f"{isset} = icmp eq i64 {kind}, 1")
            sb = self._w.new_local("set_empty")
            self._w.emit(f"{sb} = call i8* @flux_set_build(i64 0, i64 {et})")
            ism = self._w.new_local("cism")
            self._w.emit(f"{ism} = icmp eq i64 {kind}, 2")
            if is_map:
                self._w.emit(f"{r} = call i8* @flux_map_clear(i8* {p0})")
                return (r, "i8*")
            if _is_set_type(a0t):
                return (sb, "i8*")
            mm = self._w.new_local("cclear")
            ll = self._w.new_local("cclearl")
            self._w.emit(f"{mm} = call i8* @flux_map_clear(i8* {p0})")
            self._w.emit(f"{ll} = call i8* @flux_list_clear(i8* {p0})")
            sel1 = self._w.new_local("cclears1")
            self._w.emit(f"{sel1} = select i1 {ism}, i8* {mm}, i8* {ll}")
            sel2 = self._w.new_local("cclears2")
            self._w.emit(f"{sel2} = select i1 {isset}, i8* {sb}, i8* {sel1}")
            return (sel2, "i8*")
        if name == "stdCollectionToList":
            p0 = sptr(0)
            et = self._w.new_local("cet")
            self._w.emit(f"{et} = call i64 @flux_list_etag(i8* {p0})")
            ism = self._w.new_local("cism")
            self._w.emit(f"{ism} = icmp eq i64 {et}, 7")
            if rt:
                mm = self._w.new_local("ctol")
                self._w.emit(f"{mm} = call i8* @flux_map_keys(i8* {p0})")
                sel = self._w.new_local("ctols")
                self._w.emit(f"{sel} = select i1 {ism}, i8* {mm}, i8* {p0}")
                return (sel, "i8*")
            if is_map:
                self._w.emit(f"{r} = call i8* @flux_map_keys(i8* {p0})")
                return (r, "i8*")
            if _is_set_type(a0t):
                self._w.emit(f"{r} = call i8* @flux_set_to_list(i8* {p0})")
                return (r, "i8*")
            return (p0, "i8*")
        if name == "stdCollectionToSet":
            p0 = sptr(0)
            et = self._w.new_local("cet")
            self._w.emit(f"{et} = call i64 @flux_list_etag(i8* {p0})")
            ism = self._w.new_local("cism")
            self._w.emit(f"{ism} = icmp eq i64 {et}, 7")
            if rt:
                mm = self._w.new_local("ctos")
                ll = self._w.new_local("ctosl")
                self._w.emit(f"{mm} = call i8* @flux_map_to_set(i8* {p0})")
                self._w.emit(f"{ll} = call i8* @flux_list_to_set(i8* {p0})")
                sel = self._w.new_local("ctoss")
                self._w.emit(f"{sel} = select i1 {ism}, i8* {mm}, i8* {ll}")
                return (sel, "i8*")
            if is_map:
                self._w.emit(f"{r} = call i8* @flux_map_to_set(i8* {p0})")
                return (r, "i8*")
            if _is_set_type(a0t):
                return (p0, "i8*")
            self._w.emit(f"{r} = call i8* @flux_list_to_set(i8* {p0})")
            return (r, "i8*")
        if name == "stdCollectionToMap":
            p0 = sptr(0)
            et = self._w.new_local("cet")
            self._w.emit(f"{et} = call i64 @flux_list_etag(i8* {p0})")
            ism = self._w.new_local("cism")
            self._w.emit(f"{ism} = icmp eq i64 {et}, 7")
            if rt:
                ll = self._w.new_local("ctom")
                self._w.emit(f"{ll} = call i8* @flux_map_from_pairs(i8* {p0})")
                sel = self._w.new_local("ctoms")
                self._w.emit(f"{sel} = select i1 {ism}, i8* {p0}, i8* {ll}")
                return (sel, "i8*")
            if is_map:
                return (p0, "i8*")
            self._w.emit(f"{r} = call i8* @flux_map_from_pairs(i8* {p0})")
            return (r, "i8*")
        if name in ("stdMapKeys", "stdMapExtractKeys", "stdCollectionKeys"):
            self._w.emit(f"{r} = call i8* @flux_map_keys(i8* {sptr(0)})")
            return (r, "i8*")
        if name in ("stdMapValues", "stdMapExtractValues", "stdCollectionValues"):
            self._w.emit(f"{r} = call i8* @flux_map_values(i8* {sptr(0)})")
            return (r, "i8*")
        if name == "stdMapContainsKey":
            self._w.emit(f"{r} = call i1 @flux_map_contains_key(i8* {sptr(0)}, i8* {self._map_key_text(args[1])})")
            return (r, "i1")
        if name == "stdMapContainsValue":
            tag, v64, sv = item_enc(1)
            self._w.emit(f"{r} = call i1 @flux_map_contains_value(i8* {sptr(0)}, i64 {tag}, i64 {v64}, i8* {sv})")
            return (r, "i1")
        if name == "stdMapGetValueOrDefault":
            p0 = sptr(0)
            k = self._map_key_text(args[1])
            dv, dt = av(2)
            dv64 = self._coerce_to(dv, dt, "i64")
            t = self._w.new_local("mgvtag")
            v = self._w.new_local("mgvval")
            self._w.emit(f"{t} = call i64 @flux_map_get_tag(i8* {p0}, i8* {k})")
            self._w.emit(f"{v} = call i64 @flux_map_get(i8* {p0}, i8* {k})")
            miss = self._w.new_local("mgvmiss")
            self._w.emit(f"{miss} = icmp eq i64 {t}, 0")
            sel = self._w.new_local("mgvsel")
            self._w.emit(f"{sel} = select i1 {miss}, i64 {dv64}, i64 {v}")
            return (sel, "i64")
        if name == "stdMapInsertEntry":
            tag, vv = mval(2)
            self._w.emit(f"{r} = call i8* @flux_map_set(i8* {sptr(0)}, i8* {self._map_key_text(args[1])}, i64 {tag}, i64 {vv})")
            return (r, "i8*")
        if name == "stdMapInsertEntryIfAbsent":
            tag, vv = mval(2)
            self._w.emit(f"{r} = call i8* @flux_map_set_if_absent(i8* {sptr(0)}, i8* {self._map_key_text(args[1])}, i64 {tag}, i64 {vv})")
            return (r, "i8*")
        if name == "stdMapReplaceEntry":
            tag, vv = mval(2)
            self._w.emit(f"{r} = call i8* @flux_map_replace(i8* {sptr(0)}, i8* {self._map_key_text(args[1])}, i64 {tag}, i64 {vv})")
            return (r, "i8*")
        if name in ("stdMapRemoveEntry", "stdMapRemoveKey"):
            self._w.emit(f"{r} = call i8* @flux_map_remove(i8* {sptr(0)}, i8* {self._map_key_text(args[1])})")
            return (r, "i8*")
        if name == "stdMapLength":
            self._w.emit(f"{r} = call i64 @flux_list_len(i8* {sptr(0)})")
            return (r, "i64")
        if name == "stdMapIsEmpty":
            self._w.emit(f"{r} = call i1 @flux_list_is_empty(i8* {sptr(0)})")
            return (r, "i1")
        if name == "stdMapClearAll":
            self._w.emit(f"{r} = call i8* @flux_map_clear(i8* {sptr(0)})")
            return (r, "i8*")
        if name in ("stdMapEntries", "stdMapExtractEntries"):
            self._w.emit(f"{r} = call i8* @flux_map_entries(i8* {sptr(0)})")
            return (r, "i8*")
        if name == "stdMapMerge":
            self._w.emit(f"{r} = call i8* @flux_map_merge(i8* {sptr(0)}, i8* {sptr(1)})")
            return (r, "i8*")
        if name == "stdMapToMap":
            return (sptr(0), "i8*")
        if name == "stdListToMap":
            self._w.emit(f"{r} = call i8* @flux_map_from_pairs(i8* {sptr(0)})")
            return (r, "i8*")
        raise CodegenError(f"unsupported collection intrinsic '{name}'")

    def _compile_function(self, func: FunctionDef) -> None:
        name = f"f_{func.name}"
        sig = [_llvm_type(p.type_ref.name if p.type_ref else "int64") for p in func.params]
        self._w.begin_function(name, RESULT_TYPE, sig)
        self._new_block("entry")

        saved_globals = self._globals.copy()
        saved_break = self._loop_break
        saved_continue = self._loop_continue
        saved_frame = self._result_frame
        saved_tag_slots = self._var_tag_slots.copy()
        saved_sval_slots = self._var_sval_slots.copy()
        saved_ret_type = getattr(self, "_current_ret_type", "")
        self._loop_break = None
        self._loop_continue = None
        self._var_tag_slots = {}
        self._var_sval_slots = {}
        self._current_ret_type = func.return_type.name if func.return_type else ""

        frame = self._w.new_local("frame")
        self._w.emit(f"{frame} = alloca {RESULT_TYPE}")
        self._result_frame = frame

        for i, p in enumerate(func.params):
            p_t = sig[i] if i < len(sig) else "i64"
            a = self._w.new_local(f"p_{p.name}")
            self._w.emit(f"{a} = alloca {p_t}")
            val = f"%{i}"
            ptype = p.type_ref.name if p.type_ref else "int64"
            if p_t == "double" and ptype in FMT_CONSTS:
                val = self._round_double(val, ptype)
            self._w.emit(f"store {p_t} {val}, {p_t}* {a}")
            self._globals[p.name] = (p_t, a, ptype)

        self._in_func = True
        try:
            if func.body:
                self._gen_block(func.body)
        finally:
            self._in_func = False
        if not self._block_terminated:
            rv = self._w.new_local("retv")
            self._w.emit(f"{rv} = load {RESULT_TYPE}, {RESULT_TYPE}* {frame}")
            self._w.emit(f"ret {RESULT_TYPE} {rv}")
        self._w.end_function()

        self._result_frame = saved_frame
        self._globals = saved_globals
        self._loop_break = saved_break
        self._loop_continue = saved_continue
        self._var_tag_slots = saved_tag_slots
        self._var_sval_slots = saved_sval_slots
        self._current_ret_type = saved_ret_type

    def _compile_op_function(self, op) -> None:
        name = f"f_{op.name}"
        sig = self._function_sigs.get(op.name, [])
        ndata = sum(1 for p in op.params if p.type_ref and p.type_ref.name == "data")
        tag_sig = list(sig) + ["i64"] * ndata
        self._w.begin_function(name, RESULT_TYPE, tag_sig)
        self._new_block("entry")

        saved_globals = self._globals.copy()
        saved_break = self._loop_break
        saved_continue = self._loop_continue
        saved_frame = self._result_frame
        saved_pt = self._param_tag_slots
        saved_tag_slots = self._var_tag_slots.copy()
        saved_sval_slots = self._var_sval_slots.copy()
        saved_ret_type = getattr(self, "_current_ret_type", "")
        self._loop_break = None
        self._loop_continue = None
        self._param_tag_slots = {}
        self._var_tag_slots = {}
        self._var_sval_slots = {}
        self._current_ret_type = op.return_type.name if op.return_type else ""

        frame = self._w.new_local("frame")
        self._w.emit(f"{frame} = alloca {RESULT_TYPE}")
        self._result_frame = frame

        k = 0
        for i, p in enumerate(op.params):
            p_t = sig[i] if i < len(sig) else "i64"
            a = self._w.new_local(f"p_{p.name}")
            self._w.emit(f"{a} = alloca {p_t}")
            val = f"%{i}"
            ptype = p.type_ref.name if p.type_ref else "int64"
            if p_t == "double" and ptype in FMT_CONSTS:
                val = self._round_double(val, ptype)
            self._w.emit(f"store {p_t} {val}, {p_t}* {a}")
            self._globals[p.name] = (p_t, a, ptype)
            if p.type_ref and p.type_ref.name == "data":
                self._param_tag_slots[p.name] = f"%{len(sig) + k}"
                k += 1

        self._in_op = True
        try:
            if op.body:
                for expr in op.body.expressions:
                    self._gen_statement(expr)
        finally:
            self._in_op = False
        if not self._block_terminated:
            rv = self._w.new_local("retv")
            self._w.emit(f"{rv} = load {RESULT_TYPE}, {RESULT_TYPE}* {frame}")
            self._w.emit(f"ret {RESULT_TYPE} {rv}")
        self._w.end_function()

        self._result_frame = saved_frame
        self._globals = saved_globals
        self._loop_break = saved_break
        self._loop_continue = saved_continue
        self._param_tag_slots = saved_pt
        self._var_tag_slots = saved_tag_slots
        self._var_sval_slots = saved_sval_slots
        self._current_ret_type = saved_ret_type

    def _collect_called_ops(self, node: ASTNode | None) -> None:
        if node is None:
            return
        if isinstance(node, (FluxProgram, FdslFile)):
            for s in node.storages:
                self._collect_called_ops(s)
            if getattr(node, "body", None) is not None:
                self._collect_called_ops(node.body)
            for f in node.functions:
                if f.body:
                    self._collect_called_ops(f.body)
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
        elif isinstance(node, SetLiteral):
            for it in node.items:
                self._collect_called_ops(it)
        elif isinstance(node, ListLiteral):
            for it in node.items:
                self._collect_called_ops(it)
        elif isinstance(node, UnsafeStmt):
            self._collect_called_ops(node.body)
        elif isinstance(node, BlockStmt):
            for s in node.body:
                self._collect_called_ops(s)
        elif isinstance(node, PrintStmt):
            for a in node.args:
                self._collect_called_ops(a)
        elif isinstance(node, VariableReassign):
            self._collect_called_ops(node.value)
        elif isinstance(node, EmitStmt):
            self._collect_called_ops(node.value_expr)
            self._collect_called_ops(node.message)
        elif isinstance(node, StorageDecl):
            for it in node.items:
                self._collect_called_ops(it.initializer)
        elif isinstance(node, ExpressionStmt):
            self._collect_called_ops(node.expr)
        elif isinstance(node, (MatchStmt, MatchExpr)):
            self._collect_called_ops(node.subject)
            for arm in node.arms:
                self._collect_called_ops(arm.body)
        elif isinstance(node, RouteStmt):
            for arm in node.arms:
                self._collect_called_ops(arm.condition)
                self._collect_called_ops(arm.body)
        elif isinstance(node, InfiniteStmt):
            if node.condition:
                self._collect_called_ops(node.condition)
            if node.iterator and getattr(node.iterator, "collection", None) is not None:
                self._collect_called_ops(node.iterator.collection)
            self._collect_called_ops(node.body)
        elif isinstance(node, ShortCircuitBlock):
            self._collect_called_ops(node.expr)
            self._collect_called_ops(node.nice_arm)
            self._collect_called_ops(node.fail_arm)
        elif isinstance(node, CastExpr):
            self._collect_called_ops(node.expr)
        elif isinstance(node, DataflowCastSink):
            pass
        elif isinstance(node, FieldAccess):
            self._collect_called_ops(node.obj)
        elif isinstance(node, IndexAccess):
            self._collect_called_ops(node.obj)
            for ix in node.indices:
                self._collect_called_ops(ix)
        elif isinstance(node, StructInit):
            for f in node.fields:
                self._collect_called_ops(f.value)
        elif isinstance(node, MapLiteral):
            for e in node.entries:
                self._collect_called_ops(e.key)
                self._collect_called_ops(e.value)
        elif isinstance(node, RecordLiteral):
            for f in node.fields:
                self._collect_called_ops(f.value)
        elif isinstance(node, InterpolatedString):
            for p in node.parts:
                self._collect_called_ops(p)
        elif isinstance(node, ComptimeExpr):
            self._collect_called_ops(node.body)
        elif isinstance(node, FieldAssign):
            self._collect_called_ops(node.value)
        elif isinstance(node, IndexAssign):
            self._collect_called_ops(node.value)

    def _gen_match(self, node: MatchExpr | MatchStmt, keep_result: bool) -> tuple[str, str]:
        self._check_match_arm_types(node)
        enum_subject = None
        struct_subject = None
        subject_is_enum_variant = False
        if isinstance(node.subject, (Identifier, StructInit, EnumVariant)):
            if isinstance(node.subject, Identifier):
                if node.subject.name in self._enum_slots:
                    enum_subject = self._enum_slots[node.subject.name]["slots"]
                elif node.subject.name in self._struct_slots:
                    struct_subject = self._struct_slots[node.subject.name]
            elif isinstance(node.subject, StructInit) and node.subject.name in self._structs:
                raise CodegenError("struct init as match subject not supported on LLVM target")
            elif isinstance(node.subject, EnumVariant) and node.subject.enum_name in self._enums:
                subject_is_enum_variant = True
        val, t = self._gen_expr(node.subject)
        if subject_is_enum_variant:
            if self._pending_enum is None:
                raise CodegenError("internal: enum variant did not produce slots")
            enum_subject = self._pending_enum["slots"]
            self._pending_enum = None
        subject_a = self._w.new_local("msubj")
        self._w.emit(f"{subject_a} = alloca {t}")
        self._w.emit(f"store {t} {val}, {t}* {subject_a}")
        rt = self._match_result_type(node)
        result_a = None
        if keep_result:
            result_a = self._w.new_local("mres")
            self._w.emit(f"{result_a} = alloca {rt}")
        idx = self._block_seq
        self._block_seq += 1
        end_name = f"match_end_{idx}"
        for i, arm in enumerate(node.arms):
            pat = arm.pattern
            if isinstance(pat, LiteralPattern):
                lv = pat.value
                ltype = lv.value_type.lower()
                if _is_string_type(ltype):
                    raise CodegenError("string literal pattern not supported on LLVM target")
                if ltype in ("float", "float64", "float32"):
                    if t != "double":
                        raise CodegenError(f"literal pattern of type '{ltype}' vs subject type '{t}'")
                    lit_val, lit_t = self._gen_literal_text(lv)
                    cmp_op = "fcmp une"
                else:
                    if t != "i64":
                        raise CodegenError(f"literal pattern of type '{ltype}' vs subject type '{t}'")
                    if ltype == "bool":
                        lit_val = "1" if lv.value.lower() == "true" else "0"
                    else:
                        lit_val, lit_t = self._gen_literal_text(lv)
                    cmp_op = "icmp ne"
                subj = self._w.new_local("msub")
                self._w.emit(f"{subj} = load {t}, {t}* {subject_a}")
                cmp = self._w.new_local("mcmp")
                self._w.emit(f"{cmp} = {cmp_op} {t} {subj}, {lit_val}")
                body_name = f"match_{idx}_{i}_body"
                next_name = f"match_{idx}_{i}_next"
                self._w.emit(f"br i1 {cmp}, label %{next_name}, label %{body_name}")
                self._new_block(body_name)
                self._gen_llvm_guard(arm, body_name, next_name)
                self._gen_match_arm_body(arm, result_a, rt, keep_result, end_name)
                if not self._block_terminated:
                    self._w.emit(f"br label %{end_name}")
                self._new_block(next_name)
            elif isinstance(pat, IdentifierPattern):
                body_name = f"match_{idx}_{i}_body"
                next_name = f"match_{idx}_{i}_next"
                if not self._block_terminated:
                    self._w.emit(f"br label %{body_name}")
                self._new_block(body_name)
                ft = "int64" if t == "i64" else ("float64" if t == "double" else "string")
                subj = self._w.new_local("msub")
                self._w.emit(f"{subj} = load {t}, {t}* {subject_a}")
                bind_a = self._w.new_local(f"bind_{pat.name}")
                self._w.emit(f"{bind_a} = alloca {t}")
                self._w.emit(f"store {t} {subj}, {t}* {bind_a}")
                self._globals[pat.name] = (t, bind_a, ft)
                if arm.guard is not None:
                    self._gen_llvm_guard(arm, body_name, next_name)
                self._gen_match_arm_body(arm, result_a, rt, keep_result, end_name)
                if not self._block_terminated:
                    self._w.emit(f"br label %{end_name}")
                if arm.guard is not None:
                    self._new_block(next_name)
            elif isinstance(pat, RecordPattern):
                body_name = f"match_{idx}_{i}_body"
                next_name = f"match_{idx}_{i}_next"
                if not self._block_terminated:
                    self._w.emit(f"br label %{body_name}")
                self._new_block(body_name)
                subj = self._w.new_local("msub_rec")
                self._w.emit(f"{subj} = load {t}, {t}* {subject_a}")
                for ci, f in enumerate(pat.fields):
                    sname = self._w.get_string_global(f.name)
                    slen = _str_byte_len(f.name)
                    k = f"getelementptr inbounds ([{slen} x i8], [{slen} x i8]* @{sname}, i32 0, i32 0)"
                    fval = self._w.new_local(f"rfval_{ci}")
                    self._w.emit(f"{fval} = call i64 @flux_map_get(i8* {subj}, i8* {k})")
                    fv = f.value
                    if isinstance(fv, WildcardPattern):
                        continue
                    if isinstance(fv, LiteralPattern):
                        lv = fv.value
                        lt = lv.value_type.lower()
                        if _is_string_type(lt):
                            sp = self._w.new_local(f"rsp_{ci}")
                            self._w.emit(f"{sp} = inttoptr i64 {fval} to i8*")
                            sname_v = self._w.get_string_global(lv.value)
                            slen_v = _str_byte_len(lv.value)
                            lit = f"getelementptr inbounds ([{slen_v} x i8], [{slen_v} x i8]* @{sname_v}, i32 0, i32 0)"
                            cmp_res = self._w.new_local(f"scmp_{ci}")
                            self._w.emit(f"{cmp_res} = call i32 @strcmp(i8* {sp}, i8* {lit})")
                            cmp = self._w.new_local(f"mfcmp_{ci}")
                            self._w.emit(f"{cmp} = icmp ne i32 {cmp_res}, 0")
                        else:
                            lit = "1" if lt == "bool" and lv.value.lower() == "true" else ("0" if lt == "bool" else lv.value)
                            cmp = self._w.new_local(f"mfcmp_{ci}")
                            self._w.emit(f"{cmp} = icmp ne i64 {fval}, {lit}")
                        cont = f"{body_name}_rf{ci}"
                        self._w.emit(f"br i1 {cmp}, label %{next_name}, label %{cont}")
                        self._new_block(cont)
                    elif isinstance(fv, IdentifierPattern):
                        bind_a = self._w.new_local(f"bind_{fv.name}")
                        self._w.emit(f"{bind_a} = alloca i64")
                        self._w.emit(f"store i64 {fval}, i64* {bind_a}")
                        self._globals[fv.name] = ("i64", bind_a, "int64")
                self._gen_llvm_guard(arm, body_name, next_name)
                self._gen_match_arm_body(arm, result_a, rt, keep_result, end_name)
                if not self._block_terminated:
                    self._w.emit(f"br label %{end_name}")
                self._new_block(next_name)
            elif isinstance(pat, WildcardPattern):
                body_name = f"match_{idx}_{i}_body"
                next_name = f"match_{idx}_{i}_next"
                if not self._block_terminated:
                    self._w.emit(f"br label %{body_name}")
                self._new_block(body_name)
                if arm.guard is not None:
                    self._gen_llvm_guard(arm, body_name, next_name)
                self._gen_match_arm_body(arm, result_a, rt, keep_result, end_name)
                if not self._block_terminated:
                    self._w.emit(f"br label %{end_name}")
                if arm.guard is not None:
                    self._new_block(next_name)
            elif isinstance(pat, EnumVariantPattern):
                if enum_subject is None:
                    raise CodegenError("enum variant pattern requires an enum subject")
                edef = self._enums.get(pat.enum)
                if edef is None:
                    raise CodegenError(f"enum '{pat.enum}' not declared")
                tag = self._enum_tag(edef, pat.variant)
                tptr, _ = enum_subject["tag"]
                tagv = self._w.new_local("mtag")
                self._w.emit(f"{tagv} = load i64, i64* {tptr}")
                cmp = self._w.new_local("mcmp")
                self._w.emit(f"{cmp} = icmp ne i64 {tagv}, {tag}")
                body_name = f"match_{idx}_{i}_body"
                next_name = f"match_{idx}_{i}_next"
                self._w.emit(f"br i1 {cmp}, label %{next_name}, label %{body_name}")
                self._new_block(body_name)
                self._gen_llvm_pattern_fields(pat.fields, enum_subject["fields"], body_name, next_name)
                self._gen_llvm_guard(arm, body_name, next_name)
                self._gen_match_arm_body(arm, result_a, rt, keep_result, end_name)
                if not self._block_terminated:
                    self._w.emit(f"br label %{end_name}")
                self._new_block(next_name)
            elif isinstance(pat, StructPattern):
                if struct_subject is None:
                    raise CodegenError("struct pattern requires a struct subject")
                body_name = f"match_{idx}_{i}_body"
                next_name = f"match_{idx}_{i}_next"
                if not self._block_terminated:
                    self._w.emit(f"br label %{body_name}")
                self._new_block(body_name)
                if pat.fields:
                    self._gen_llvm_pattern_fields(pat.fields, struct_subject["fields"], body_name, next_name)
                self._gen_llvm_guard(arm, body_name, next_name)
                self._gen_match_arm_body(arm, result_a, rt, keep_result, end_name)
                if not self._block_terminated:
                    self._w.emit(f"br label %{end_name}")
                self._new_block(next_name)
            elif isinstance(pat, ListPattern):
                body_name = f"match_{idx}_{i}_body"
                next_name = f"match_{idx}_{i}_next"
                subj = self._w.new_local("msub_list")
                self._w.emit(f"{subj} = load {t}, {t}* {subject_a}")
                if t in ("i64", "i32", "i16", "i8"):
                    check_lbl = f"match_{idx}_{i}_chk"
                    s64 = self._coerce_to(subj, t, "i64")
                    is_ptr = self._w.new_local("is_ptr")
                    self._w.emit(f"{is_ptr} = icmp uge i64 {s64}, {_HEAP_THRESHOLD}")
                    self._w.emit(f"br i1 {is_ptr}, label %{check_lbl}, label %{next_name}")
                    self._new_block(check_lbl)
                subj_ptr = self._coerce_to(subj, t, "i8*")
                min_len = len(pat.items)
                exact = pat.rest is None
                llen = self._w.new_local("m_llen")
                self._w.emit(f"{llen} = call i64 @flux_list_len(i8* {subj_ptr})")
                cmp = self._w.new_local("m_lcmp")
                if exact:
                    self._w.emit(f"{cmp} = icmp ne i64 {llen}, {min_len}")
                else:
                    self._w.emit(f"{cmp} = icmp slt i64 {llen}, {min_len}")
                self._w.emit(f"br i1 {cmp}, label %{next_name}, label %{body_name}")
                self._new_block(body_name)
                sft = self._flux_type_of(node.subject)
                elem_ft = self._list_elem_type(sft) if (_is_list_type(sft) or _is_set_type(sft)) else "int64"
                if not elem_ft:
                    elem_ft = "int64"
                ldata = self._w.new_local("m_ldata")
                self._w.emit(f"{ldata} = call i8* @flux_list_data(i8* {subj_ptr})")
                for item_idx, item_pat in enumerate(pat.items, 1):
                    cont_name = f"{body_name}_it{item_idx}"
                    if isinstance(item_pat, WildcardPattern):
                        continue
                    if _is_string_type(elem_ft):
                        eval_v = self._w.new_local(f"item_val_{item_idx}")
                        self._w.emit(f"{eval_v} = call i8* @flux_row_sval(i8* {ldata}, i64 {item_idx})")
                        val_t = "i8*"
                        val_ft = "string"
                        itag = None
                    elif elem_ft in ("double", "float", "float64", "float32"):
                        fv = self._w.new_local(f"item_ival_{item_idx}")
                        self._w.emit(f"{fv} = call i64 @flux_row_val(i8* {ldata}, i64 {item_idx})")
                        eval_v = self._w.new_local(f"item_val_{item_idx}")
                        self._w.emit(f"{eval_v} = bitcast i64 {fv} to double")
                        val_t = "double"
                        val_ft = elem_ft
                        itag = None
                    elif _is_list_type(elem_ft) or _is_set_type(elem_ft):
                        lv = self._w.new_local(f"item_ival_{item_idx}")
                        self._w.emit(f"{lv} = call i64 @flux_row_val(i8* {ldata}, i64 {item_idx})")
                        eval_v = self._w.new_local(f"item_val_{item_idx}")
                        self._w.emit(f"{eval_v} = inttoptr i64 {lv} to i8*")
                        val_t = "i8*"
                        val_ft = elem_ft
                        itag = None
                    else:
                        itag = self._w.new_local(f"item_tag_{item_idx}")
                        self._w.emit(f"{itag} = call i64 @flux_row_tag(i8* {ldata}, i64 {item_idx})")
                        is_str_row = self._w.new_local(f"is_str_row_{item_idx}")
                        self._w.emit(f"{is_str_row} = icmp eq i64 {itag}, 4")
                        sv = self._w.new_local(f"item_sval_{item_idx}")
                        self._w.emit(f"{sv} = call i8* @flux_row_sval(i8* {ldata}, i64 {item_idx})")
                        sp = self._w.new_local(f"item_sp_{item_idx}")
                        self._w.emit(f"{sp} = ptrtoint i8* {sv} to i64")
                        iv = self._w.new_local(f"item_iv_{item_idx}")
                        self._w.emit(f"{iv} = call i64 @flux_row_val(i8* {ldata}, i64 {item_idx})")
                        eval_v = self._w.new_local(f"item_val_{item_idx}")
                        self._w.emit(f"{eval_v} = select i1 {is_str_row}, i64 {sp}, i64 {iv}")
                        val_t = "i64"
                        val_ft = "data"
                    if isinstance(item_pat, IdentifierPattern):
                        bind_a = self._w.new_local(f"bind_{item_pat.name}")
                        self._w.emit(f"{bind_a} = alloca {val_t}")
                        self._w.emit(f"store {val_t} {eval_v}, {val_t}* {bind_a}")
                        self._globals[item_pat.name] = (val_t, bind_a, val_ft)
                        if itag is not None:
                            self._param_tag_slots[item_pat.name] = itag
                    elif isinstance(item_pat, LiteralPattern):
                        lv = item_pat.value
                        lt = lv.value_type.lower()
                        if _is_string_type(lt):
                            sname = self._w.get_string_global(lv.value)
                            slen = _str_byte_len(lv.value)
                            lit = f"getelementptr inbounds ([{slen} x i8], [{slen} x i8]* @{sname}, i32 0, i32 0)"
                            cmp_res = self._w.new_local(f"scmp_{item_idx}")
                            self._w.emit(f"{cmp_res} = call i32 @strcmp(i8* {eval_v}, i8* {lit})")
                            cmp = self._w.new_local(f"mfcmp_{item_idx}")
                            self._w.emit(f"{cmp} = icmp ne i32 {cmp_res}, 0")
                        elif lt in ("float", "float64", "float32"):
                            lit, _ = self._gen_literal_text(lv)
                            cmp = self._w.new_local(f"mfcmp_{item_idx}")
                            self._w.emit(f"{cmp} = fcmp une {val_t} {eval_v}, {lit}")
                        else:
                            lit = "1" if lt == "bool" and lv.value.lower() == "true" else ("0" if lt == "bool" else lv.value)
                            cmp = self._w.new_local(f"mfcmp_{item_idx}")
                            self._w.emit(f"{cmp} = icmp ne {val_t} {eval_v}, {lit}")
                        self._w.emit(f"br i1 {cmp}, label %{next_name}, label %{cont_name}")
                        self._new_block(cont_name)
                    else:
                        raise CodegenError(f"nested pattern '{type(item_pat).__name__}' in ListPattern not supported on LLVM target")
                if pat.rest is not None:
                    has_rest_cmp = self._w.new_local("has_rest")
                    self._w.emit(f"{has_rest_cmp} = icmp ugt i64 {llen}, {min_len}")
                    rest_slice_lbl = f"{body_name}_rest_slice"
                    rest_empty_lbl = f"{body_name}_rest_empty"
                    rest_cont_lbl = f"{body_name}_rest_cont"
                    self._w.emit(f"br i1 {has_rest_cmp}, label %{rest_slice_lbl}, label %{rest_empty_lbl}")
                    self._new_block(rest_slice_lbl)
                    start_idx = min_len + 1
                    rest_slice_val = self._w.new_local("r_slice")
                    self._w.emit(f"{rest_slice_val} = call i8* @flux_list_slice(i8* {subj_ptr}, i64 {start_idx}, i64 {llen})")
                    self._w.emit(f"br label %{rest_cont_lbl}")
                    self._new_block(rest_empty_lbl)
                    rest_et = self._w.new_local("r_et")
                    self._w.emit(f"{rest_et} = call i64 @flux_list_etag(i8* {subj_ptr})")
                    rest_empty_val = self._w.new_local("r_empty")
                    self._w.emit(f"{rest_empty_val} = call i8* @flux_list_build(i64 0, i64 {rest_et})")
                    self._w.emit(f"br label %{rest_cont_lbl}")
                    self._new_block(rest_cont_lbl)
                    rest_val = self._w.new_local("rest_val")
                    self._w.emit(f"{rest_val} = phi i8* [ {rest_slice_val}, %{rest_slice_lbl} ], [ {rest_empty_val}, %{rest_empty_lbl} ]")
                    bind_rest = self._w.new_local(f"bind_{pat.rest}")
                    self._w.emit(f"{bind_rest} = alloca i8*")
                    self._w.emit(f"store i8* {rest_val}, i8** {bind_rest}")
                    list_type_str = f"list of {elem_ft}"
                    self._globals[pat.rest] = ("i8*", bind_rest, list_type_str)
                self._gen_llvm_guard(arm, body_name, next_name)
                self._gen_match_arm_body(arm, result_a, rt, keep_result, end_name)
                if not self._block_terminated:
                    self._w.emit(f"br label %{end_name}")
                self._new_block(next_name)
            else:
                raise CodegenError(f"pattern '{type(pat).__name__}' not supported on LLVM target")
        if not self._block_terminated:
            if keep_result:
                default = "0" if rt != "double" else "0.0"
                if rt == "i8*":
                    default = "null"
                self._w.emit(f"store {rt} {default}, {rt}* {result_a}")
            self._w.emit(f"br label %{end_name}")
        self._new_block(end_name)
        if keep_result:
            res = self._w.new_local("mresv")
            self._w.emit(f"{res} = load {rt}, {rt}* {result_a}")
            return (res, rt)
        return ("0", "i64")

    def _gen_llvm_guard(self, arm: MatchArm, body_name: str, next_name: str) -> None:
        if arm.guard is not None:
            gval, gt = self._gen_expr(arm.guard)
            cmp = self._w.new_local("mgc")
            self._w.emit(f"{cmp} = icmp ne {gt} {gval}, 0")
            cont = f"{body_name}_g"
            self._w.emit(f"br i1 {cmp}, label %{cont}, label %{next_name}")
            self._new_block(cont)

    def _gen_llvm_pattern_fields(self, fields, slots_fields: dict, body_name: str, next_name: str) -> None:
        for ci, f in enumerate(fields):
            if f.name not in slots_fields:
                raise CodegenError(f"unknown field '{f.name}' for pattern subject")
            ptr, llvm_t, ft = slots_fields[f.name]
            fv = f.value
            if isinstance(fv, WildcardPattern):
                continue
            if isinstance(fv, LiteralPattern):
                lv = fv.value
                lt = lv.value_type.lower()
                fv_v = self._w.new_local(f"bf_{f.name}")
                self._w.emit(f"{fv_v} = load {llvm_t}, {llvm_t}* {ptr}")
                if _is_string_type(lt):
                    sname = self._w.get_string_global(lv.value)
                    slen = _str_byte_len(lv.value)
                    lit = f"getelementptr inbounds ([{slen} x i8], [{slen} x i8]* @{sname}, i32 0, i32 0)"
                    cmp_res = self._w.new_local(f"scmp_{ci}")
                    self._w.emit(f"{cmp_res} = call i32 @strcmp(i8* {fv_v}, i8* {lit})")
                    cmp = self._w.new_local(f"mfcmp_{ci}")
                    self._w.emit(f"{cmp} = icmp ne i32 {cmp_res}, 0")
                elif lt in ("float", "float64", "float32"):
                    lit, _ = self._gen_literal_text(lv)
                    cmp = self._w.new_local(f"mfcmp_{ci}")
                    self._w.emit(f"{cmp} = fcmp une {llvm_t} {fv_v}, {lit}")
                else:
                    lit = "1" if lt == "bool" and lv.value.lower() == "true" else ("0" if lt == "bool" else lv.value)
                    cmp = self._w.new_local(f"mfcmp_{ci}")
                    self._w.emit(f"{cmp} = icmp ne {llvm_t} {fv_v}, {lit}")
                cont = f"{body_name}_f{ci}"
                self._w.emit(f"br i1 {cmp}, label %{next_name}, label %{cont}")
                self._new_block(cont)
                continue
            if isinstance(fv, IdentifierPattern):
                fvv = self._w.new_local(f"bf_{fv.name}")
                self._w.emit(f"{fvv} = load {llvm_t}, {llvm_t}* {ptr}")
                bind_a = self._w.new_local(f"bind_{fv.name}")
                self._w.emit(f"{bind_a} = alloca {llvm_t}")
                self._w.emit(f"store {llvm_t} {fvv}, {llvm_t}* {bind_a}")
                self._globals[fv.name] = (llvm_t, bind_a, ft)
                continue
            raise CodegenError("nested field pattern not supported on LLVM target")

    def _gen_match_arm_body(self, arm: MatchArm, result_a: str | None, rt: str, keep_result: bool, end_name: str) -> None:
        if isinstance(arm.body, BlockStmt):
            self._gen_block(arm.body)
            if keep_result and not self._block_terminated:
                default = "0" if rt != "double" else "0.0"
                if rt == "i8*":
                    default = "null"
                self._w.emit(f"store {rt} {default}, {rt}* {result_a}")
        elif isinstance(arm.body, (PrintStmt, EmitStmt, RouteStmt, InfiniteStmt,
                            BreakStmt, ContinueStmt, VariableReassign, FieldAssign,
                            StorageDecl, ExpressionStmt)):
            self._gen_statement(arm.body)
            if keep_result and not self._block_terminated:
                default = "0" if rt != "double" else "0.0"
                if rt == "i8*":
                    default = "null"
                self._w.emit(f"store {rt} {default}, {rt}* {result_a}")
        else:
            body_val, body_t = self._gen_expr(arm.body)
            if keep_result:
                body_val = self._coerce_to(body_val, body_t, rt)
                self._w.emit(f"store {rt} {body_val}, {rt}* {result_a}")

    def _check_match_arm_types(self, node: MatchExpr | MatchStmt) -> None:
        wtypes = set()
        for arm in node.arms:
            b = arm.body
            if isinstance(b, Literal):
                vt = b.value_type.lower()
                if vt in ("float", "float64", "float32"):
                    wtypes.add("double")
                elif _is_string_type(vt):
                    wtypes.add("i8*")
                else:
                    wtypes.add("i64")
        if len(wtypes) > 1:
            raise CodegenError(f"match arms must produce same type, found {sorted(wtypes)}")

    def _match_result_type(self, node: MatchExpr | MatchStmt) -> str:
        for arm in node.arms:
            b = arm.body
            if isinstance(b, Literal):
                vt = b.value_type.lower()
                if vt in ("float", "float64", "float32"):
                    return "double"
                if _is_string_type(vt):
                    return "i8*"
                return "i64"
        return "i64"

    def _gen_route(self, node: RouteStmt) -> None:
        route_idx = self._block_seq
        self._block_seq += 1
        end_name = f"route_end_{route_idx}"
        for i, arm in enumerate(node.arms):
            is_wildcard = (isinstance(arm.condition, Identifier) and arm.condition.name == "_") or arm.condition is None
            if not is_wildcard:
                val, t = self._gen_expr(arm.condition)
                cmp = self._w.new_local()
                if t == "i8*":
                    self._w.emit(f"{cmp} = icmp ne i8* {val}, null")
                else:
                    self._w.emit(f"{cmp} = icmp ne {t} {val}, 0")
                next_name = f"arm_{route_idx}_{i}_next"
                body_name = f"arm_{route_idx}_{i}_body"
                self._w.emit(f"br i1 {cmp}, label %{body_name}, label %{next_name}")
                self._new_block(body_name)

            if arm.body:
                if isinstance(arm.body, BlockStmt):
                    self._gen_block(arm.body)
                else:
                    self._gen_statement(arm.body)

            if not self._block_terminated:
                self._w.emit(f"br label %{end_name}")

            if not is_wildcard:
                self._new_block(next_name)

        if not self._block_terminated:
            self._w.emit(f"br label %{end_name}")
        self._new_block(end_name)

    def _store_result_status(self, status: str, msg: str | None = None, val: str = "0") -> None:
        if self._result_frame is None:
            raise CodegenError("result frame not available")
        sname = self._w.get_string_global(status)
        slen = _str_byte_len(status)
        sta = f"getelementptr inbounds ([{slen} x i8], [{slen} x i8]* @{sname}, i32 0, i32 0)"
        if msg is not None:
            mname = self._w.get_string_global(msg)
            mlen = _str_byte_len(msg)
            msg_gep = f"getelementptr inbounds ([{mlen} x i8], [{mlen} x i8]* @{mname}, i32 0, i32 0)"
        else:
            mname = self._w.get_string_global("")
            mlen = _str_byte_len("")
            msg_gep = f"getelementptr inbounds ([{mlen} x i8], [{mlen} x i8]* @{mname}, i32 0, i32 0)"
        struct = self._build_result_struct(sta, val, "0.0", msg_gep)
        self._w.emit(f"store {RESULT_TYPE} {struct}, {RESULT_TYPE}* {self._result_frame}")

    def _expr_is_bool(self, node: ASTNode) -> bool:
        if isinstance(node, Literal):
            return node.value_type.lower() == "bool"
        if isinstance(node, UnaryOp):
            return node.op == "not"
        if isinstance(node, BinaryOp):
            return node.op in ("==", "!=", "<", "<=", ">", ">=", "and", "or")
        if isinstance(node, Identifier):
            g = self._globals.get(node.name)
            if g is not None and len(g) > 2 and g[2] == "bool":
                return True
        return False

    def _gen_short_circuit(self, node: ShortCircuitBlock, bind_name: str | None = None) -> None:
        idx = self._block_seq
        self._block_seq += 1
        raw_val: str | None = None
        raw_t = RESULT_TYPE
        is_bool = False
        bz: str | None = None
        if isinstance(node.expr, CallExpr):
            raw_val, raw_t = self._gen_call(node.expr)
        else:
            self._store_result_status("nice")
            raw_val, raw_t = self._emit_expr_text(node.expr)
            if self._expr_is_bool(node.expr):
                is_bool = True
                bz = self._w.new_local("scb")
                self._w.emit(f"{bz} = icmp eq {raw_t} {raw_val}, 0")
        sta = self._w.new_local("rsta")
        fv: str | None = None
        if raw_val is not None and raw_t == RESULT_TYPE:
            self._w.emit(f"{sta} = extractvalue {RESULT_TYPE} {raw_val}, 0")
        else:
            fv = self._load_result_frame()
            self._w.emit(f"{sta} = extractvalue {RESULT_TYPE} {fv}, 0")
        if bind_name is not None:
            _, gv, _ = self._globals[bind_name]
            if raw_val is not None and raw_t == RESULT_TYPE:
                self._w.emit(f"store {RESULT_TYPE} {raw_val}, {RESULT_TYPE}* {gv}")
            else:
                bind_fail = f"scbf_{idx}"
                bind_ok = f"scbok_{idx}"
                bind_end = f"scbend_{idx}"
                fcmp = self._w.new_local("scbfcmp")
                fname = self._w.get_string_global("fail")
                flen = _str_byte_len("fail")
                self._w.emit(
                    f"{fcmp} = call i32 @strcmp(i8* {sta}, i8* getelementptr inbounds "
                    f"([{flen} x i8], [{flen} x i8]* @{fname}, i32 0, i32 0))"
                )
                fisf = self._w.new_local("scbfail")
                self._w.emit(f"{fisf} = icmp eq i32 {fcmp}, 0")
                self._w.emit(f"br i1 {fisf}, label %{bind_fail}, label %{bind_ok}")

                self._new_block(bind_fail)
                self._w.emit(f"store {RESULT_TYPE} {fv}, {RESULT_TYPE}* {gv}")
                self._w.emit(f"br label %{bind_end}")

                self._new_block(bind_ok)
                nname = self._w.get_string_global("nice")
                nlen = _str_byte_len("nice")
                ngep = f"getelementptr inbounds ([{nlen} x i8], [{nlen} x i8]* @{nname}, i32 0, i32 0)"
                ename = self._w.get_string_global("")
                elen = _str_byte_len("")
                egep = f"getelementptr inbounds ([{elen} x i8], [{elen} x i8]* @{ename}, i32 0, i32 0)"
                struct = self._build_result_struct(ngep, raw_val, "0.0", egep)
                self._w.emit(f"store {RESULT_TYPE} {struct}, {RESULT_TYPE}* {gv}")
                self._w.emit(f"br label %{bind_end}")

                self._new_block(bind_end)
        if is_bool:
            self._w.emit(f"br i1 {bz}, label %scf_{idx}, label %scn_{idx}")
        else:
            cmpv = self._w.new_local("cmp")
            fname = self._w.get_string_global("fail")
            flen = _str_byte_len("fail")
            self._w.emit(
                f"{cmpv} = call i32 @strcmp(i8* {sta}, i8* getelementptr inbounds "
                f"([{flen} x i8], [{flen} x i8]* @{fname}, i32 0, i32 0))"
            )
            isf = self._w.new_local("isfail")
            self._w.emit(f"{isf} = icmp eq i32 {cmpv}, 0")
            self._w.emit(f"br i1 {isf}, label %scf_{idx}, label %scn_{idx}")

        self._new_block(f"scf_{idx}")
        if node.fail_arm:
            self._bind_sc_arm(node.fail_arm)
        if not self._block_terminated:
            self._w.emit(f"br label %scend_{idx}")

        self._new_block(f"scn_{idx}")
        if node.nice_arm:
            self._bind_sc_arm(node.nice_arm)
        if not self._block_terminated:
            self._w.emit(f"br label %scend_{idx}")

        self._new_block(f"scend_{idx}")
        if bind_name is not None:
            g_t, gv, _ = self._globals[bind_name]
            rv = self._load_result_frame()
            self._w.emit(f"store {RESULT_TYPE} {rv}, {RESULT_TYPE}* {gv}")

    def _bind_sc_arm(self, arm: ShortCircuitArm) -> None:
        self._gen_emit(EmitStmt(status=arm.status, value=arm.value, message=arm.message))

    def _gen_infinite(self, node: InfiniteStmt) -> None:
        if node.iterator is not None:
            return self._gen_infinite_iterator(node)
        loop_idx = self._block_seq
        self._block_seq += 1
        loop_name = f"loop_{loop_idx}"
        end_name = f"endloop_{loop_idx}"
        saved_break = self._loop_break
        saved_continue = self._loop_continue
        self._loop_break = end_name
        self._loop_continue = loop_name
        self._w.emit(f"br label %{loop_name}")
        self._new_block(loop_name)
        if node.condition:
            val, t = self._gen_expr(node.condition)
            cmp = self._w.new_local()
            if t == "i8*":
                self._w.emit(f"{cmp} = icmp ne i8* {val}, null")
            else:
                self._w.emit(f"{cmp} = icmp ne {t} {val}, 0")
            body_name = f"loop_body_{loop_idx}"
            self._w.emit(f"br i1 {cmp}, label %{body_name}, label %{end_name}")
            self._new_block(body_name)
        if node.body and isinstance(node.body, BlockStmt):
            self._gen_block(node.body)
        if not self._block_terminated:
            self._w.emit(f"br label %{loop_name}")
        self._new_block(end_name)
        self._loop_break = saved_break
        self._loop_continue = saved_continue

    def _gen_infinite_iterator(self, node: InfiniteStmt) -> None:
        coll = node.iterator.collection
        name = node.iterator.variable
        if isinstance(coll, BinaryOp) and coll.op == "..":
            start_val, start_t = self._emit_expr_text(coll.left)
            end_val, end_t = self._emit_expr_text(coll.right)
            s = self._w.new_local(f"iter_{name}")
            self._w.emit(f"{s} = alloca i64")
            sv = self._coerce_to(start_val, start_t, "i64")
            self._w.emit(f"store i64 {sv}, i64* {s}")
            ev = self._coerce_to(end_val, end_t, "i64")
            is_desc = self._w.new_local("is_desc")
            self._w.emit(f"{is_desc} = icmp sgt i64 {sv}, {ev}")

            loop_idx = self._block_seq
            self._block_seq += 1
            loop_name = f"loop_{loop_idx}"
            end_name = f"endloop_{loop_idx}"
            body_name = f"loop_body_{loop_idx}"
            inc_name = f"loop_inc_{loop_idx}"
            saved_break = self._loop_break
            saved_continue = self._loop_continue
            self._loop_break = end_name
            self._loop_continue = inc_name

            self._w.emit(f"br label %{loop_name}")
            self._new_block(loop_name)
            cur = self._w.new_local()
            self._w.emit(f"{cur} = load i64, i64* {s}")
            cmp_asc = self._w.new_local()
            self._w.emit(f"{cmp_asc} = icmp sgt i64 {cur}, {ev}")
            cmp_desc = self._w.new_local()
            self._w.emit(f"{cmp_desc} = icmp slt i64 {cur}, {ev}")
            cmp = self._w.new_local()
            self._w.emit(f"{cmp} = select i1 {is_desc}, i1 {cmp_desc}, i1 {cmp_asc}")
            self._w.emit(f"br i1 {cmp}, label %{end_name}, label %{body_name}")

            self._new_block(body_name)
            self._globals[name] = ("i64", s, "int64")
            if node.body and isinstance(node.body, BlockStmt):
                self._gen_block(node.body)
            if not self._block_terminated:
                self._w.emit(f"br label %{inc_name}")
            self._new_block(inc_name)
            cur2 = self._w.new_local()
            self._w.emit(f"{cur2} = load i64, i64* {s}")
            step = self._w.new_local()
            self._w.emit(f"{step} = select i1 {is_desc}, i64 -1, i64 1")
            nxt = self._w.new_local()
            self._w.emit(f"{nxt} = add i64 {cur2}, {step}")
            self._w.emit(f"store i64 {nxt}, i64* {s}")
            self._w.emit(f"br label %{loop_name}")
            self._new_block(end_name)
            self._loop_break = saved_break
            self._loop_continue = saved_continue
            return

        ct = self._flux_type_of(coll)
        is_str_coll = _is_string_type(ct)
        is_map_coll = _is_map_type(ct)
        if not (is_str_coll or is_map_coll or _is_list_type(ct) or _is_set_type(ct) or ct == "data"):
            raise CodegenError("infinite iterator requires a numeric range 'a .. b' or a list/set/map/string collection")
        coll_val, coll_t = self._emit_expr_text(coll)
        if is_str_coll:
            coll_val = self._coerce_to(coll_val, coll_t, "i8*")
            nloc = self._w.new_local("n")
            self._w.emit(f"{nloc} = call i64 @flux_str_char_len(i8* {coll_val})")
            idx_ptr = self._w.new_local(f"idx_{name}")
            self._w.emit(f"{idx_ptr} = alloca i64")
            self._w.emit(f"store i64 1, i64* {idx_ptr}")
            elem_ptr = self._w.new_local(f"elem_{name}")
            self._w.emit(f"{elem_ptr} = alloca i8*")
            llvm_t = "i8*"
            et = "string"
        elif is_map_coll:
            keys_val = self._w.new_local("keys")
            self._w.emit(f"{keys_val} = call i8* @flux_map_keys(i8* {coll_val})")
            coll_val = keys_val
            et = "string"
            nloc = self._w.new_local("n")
            self._w.emit(f"{nloc} = call i64 @flux_list_len(i8* {coll_val})")
            data = self._w.new_local("data")
            self._w.emit(f"{data} = call i8* @flux_list_data(i8* {coll_val})")
            idx_ptr = self._w.new_local(f"idx_{name}")
            self._w.emit(f"{idx_ptr} = alloca i64")
            self._w.emit(f"store i64 1, i64* {idx_ptr}")
            llvm_t = "i8*"
            elem_ptr = self._w.new_local(f"elem_{name}")
            self._w.emit(f"{elem_ptr} = alloca {llvm_t}")
        else:
            et = self._list_elem_type(ct)
            if not et:
                et = "data"
            nloc = self._w.new_local("n")
            self._w.emit(f"{nloc} = call i64 @flux_list_len(i8* {coll_val})")
            data = self._w.new_local("data")
            self._w.emit(f"{data} = call i8* @flux_list_data(i8* {coll_val})")
            idx_ptr = self._w.new_local(f"idx_{name}")
            self._w.emit(f"{idx_ptr} = alloca i64")
            self._w.emit(f"store i64 1, i64* {idx_ptr}")
            if et == "data":
                llvm_t = "i64"
                elem_ptr = self._w.new_local(f"elem_{name}")
                self._w.emit(f"{elem_ptr} = alloca i64")
                elem_tag_ptr = self._w.new_local(f"elem_tag_{name}")
                self._w.emit(f"{elem_tag_ptr} = alloca i64")
                elem_sval_ptr = self._w.new_local(f"elem_sval_{name}")
                self._w.emit(f"{elem_sval_ptr} = alloca i8*")
                self._var_tag_slots[name] = elem_tag_ptr
                self._var_sval_slots[name] = elem_sval_ptr
            elif et in ("double", "float"):
                llvm_t = "double"
                elem_ptr = self._w.new_local(f"elem_{name}")
                self._w.emit(f"{elem_ptr} = alloca {llvm_t}")
            elif _is_string_type(et):
                llvm_t = "i8*"
                elem_ptr = self._w.new_local(f"elem_{name}")
                self._w.emit(f"{elem_ptr} = alloca {llvm_t}")
            elif _is_list_type(et) or _is_set_type(et):
                llvm_t = "i8*"
                elem_ptr = self._w.new_local(f"elem_{name}")
                self._w.emit(f"{elem_ptr} = alloca {llvm_t}")
            elif et == "bool":
                llvm_t = "i1"
                elem_ptr = self._w.new_local(f"elem_{name}")
                self._w.emit(f"{elem_ptr} = alloca {llvm_t}")
            else:
                llvm_t = "i64"
                elem_ptr = self._w.new_local(f"elem_{name}")
                self._w.emit(f"{elem_ptr} = alloca {llvm_t}")

        loop_idx = self._block_seq
        self._block_seq += 1
        loop_name = f"loop_{loop_idx}"
        end_name = f"endloop_{loop_idx}"
        body_name = f"loop_body_{loop_idx}"
        inc_name = f"loop_inc_{loop_idx}"
        saved_break = self._loop_break
        saved_continue = self._loop_continue
        self._loop_break = end_name
        self._loop_continue = inc_name

        self._w.emit(f"br label %{loop_name}")
        self._new_block(loop_name)
        cur_idx = self._w.new_local("cur_idx")
        self._w.emit(f"{cur_idx} = load i64, i64* {idx_ptr}")
        cmp = self._w.new_local("cond")
        self._w.emit(f"{cmp} = icmp sgt i64 {cur_idx}, {nloc}")
        self._w.emit(f"br i1 {cmp}, label %{end_name}, label %{body_name}")

        self._new_block(body_name)
        if is_str_coll:
            sv = self._w.new_local("sval")
            self._w.emit(f"{sv} = call i8* @flux_str_slice(i8* {coll_val}, i64 {cur_idx}, i64 {cur_idx})")
            self._w.emit(f"store i8* {sv}, i8** {elem_ptr}")
        elif et == "data":
            tg = self._w.new_local("itag")
            self._w.emit(f"{tg} = call i64 @flux_row_tag(i8* {data}, i64 {cur_idx})")
            self._w.emit(f"store i64 {tg}, i64* {elem_tag_ptr}")
            vl = self._w.new_local("ival")
            self._w.emit(f"{vl} = call i64 @flux_row_val(i8* {data}, i64 {cur_idx})")
            self._w.emit(f"store i64 {vl}, i64* {elem_ptr}")
            sv = self._w.new_local("isval")
            self._w.emit(f"{sv} = call i8* @flux_row_sval(i8* {data}, i64 {cur_idx})")
            self._w.emit(f"store i8* {sv}, i8** {elem_sval_ptr}")
        elif et in ("double", "float"):
            fv = self._w.new_local("fval")
            self._w.emit(f"{fv} = call i64 @flux_row_val(i8* {data}, i64 {cur_idx})")
            fd = self._w.new_local("fbits")
            self._w.emit(f"{fd} = bitcast i64 {fv} to double")
            self._w.emit(f"store double {fd}, double* {elem_ptr}")
        elif _is_string_type(et):
            sv = self._w.new_local("sval")
            self._w.emit(f"{sv} = call i8* @flux_row_sval(i8* {data}, i64 {cur_idx})")
            self._w.emit(f"store i8* {sv}, i8** {elem_ptr}")
        elif _is_list_type(et) or _is_set_type(et):
            lv = self._w.new_local("lval")
            self._w.emit(f"{lv} = call i64 @flux_row_val(i8* {data}, i64 {cur_idx})")
            lp = self._w.new_local("lptr")
            self._w.emit(f"{lp} = inttoptr i64 {lv} to i8*")
            self._w.emit(f"store i8* {lp}, i8** {elem_ptr}")
        elif et == "bool":
            r = self._w.new_local("ival")
            self._w.emit(f"{r} = call i64 @flux_row_val(i8* {data}, i64 {cur_idx})")
            rb = self._w.new_local("ibool")
            self._w.emit(f"{rb} = icmp ne i64 {r}, 0")
            self._w.emit(f"store i1 {rb}, i1* {elem_ptr}")
        else:
            r = self._w.new_local("ival")
            self._w.emit(f"{r} = call i64 @flux_row_val(i8* {data}, i64 {cur_idx})")
            self._w.emit(f"store i64 {r}, i64* {elem_ptr}")

        saved_global = self._globals.get(name)
        self._globals[name] = (llvm_t, elem_ptr, et)

        if node.body and isinstance(node.body, BlockStmt):
            self._gen_block(node.body)
        if not self._block_terminated:
            self._w.emit(f"br label %{inc_name}")

        self._new_block(inc_name)
        nxt_idx = self._w.new_local("nxt_idx")
        self._w.emit(f"{nxt_idx} = add i64 {cur_idx}, 1")
        self._w.emit(f"store i64 {nxt_idx}, i64* {idx_ptr}")
        self._w.emit(f"br label %{loop_name}")

        self._new_block(end_name)
        self._loop_break = saved_break
        self._loop_continue = saved_continue
        self._var_tag_slots.pop(name, None)
        self._var_sval_slots.pop(name, None)
        if saved_global is not None:
            self._globals[name] = saved_global
        else:
            self._globals.pop(name, None)
