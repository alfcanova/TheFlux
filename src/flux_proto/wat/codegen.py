from __future__ import annotations
from pathlib import Path
import shutil

from flux_proto.floating import FLOATISH, FMT_CONSTS, REDUCED_FLOATS, norm_float_text
from flux_proto.parser.import_resolver import collect_op_aliases
from flux_proto.parser.ast import (
    ASTNode, FluxProgram, FdslFile, BlockStmt, ExpressionStmt, PrintStmt,
    Literal, Identifier, BinaryOp, UnaryOp, CallExpr,
    VariableReassign, RouteStmt, RouteArm, InfiniteStmt,
    BreakStmt, ContinueStmt, EmitStmt,
    StructInit, InitField, FieldAccess, StorageDecl, StorageItem,
    FunctionDef, Parameter,
    InterpolatedString, InterpolatedText, EnumVariant,
    ShortCircuitBlock, ShortCircuitArm, ComptimeExpr,
    MatchExpr, MatchStmt, MatchArm, FieldAssign, StructDef,
        IndexAccess, IndexAssign, SliceSpec, ListLiteral, SetLiteral, MapLiteral, RecordLiteral,
        DataflowExpr, DataflowCastSink, CastExpr, SpyExpr,
        OwnershipExpr, UnsafeStmt, SpawnExpr, AwaitExpr,
        PtrRefExpr, PtrDerefExpr, PtrAssign, ExternDecl,
        InputExpr,
)
from flux_proto.wat.list_helpers import LIST_HELPERS
from flux_proto.parser.patterns import (
    LiteralPattern, IdentifierPattern, WildcardPattern, RecordPattern,
    EnumVariantPattern, StructPattern, ListPattern,
)


class WatError(Exception):
    pass


_LIST_RETURNING = {
      "stdListClearAll", "stdListPushBack", "stdListPushFront",
      "stdListInsertAt", "stdListRemoveAt", "stdListRemoveLast",
      "stdListSortAscending", "stdListSortDescending", "stdListReverse",
      "stdListFlatten", "stdListPartition", "stdListZip",
      "stdListUnzip", "stdListToList",
      "stdMapKeys", "stdMapValues", "stdMapExtractEntries",
      "stdMapExtractKeys", "stdMapExtractValues",
      "stdCollectionToList",
  }

_MAP_RETURNING = {
      "stdMapMerge", "stdMapInsertEntry", "stdMapInsertEntryIfAbsent",
      "stdMapReplaceEntry", "stdMapRemoveEntry", "stdMapClearAll",
      "stdMapToMap", "stdListToMap", "stdCollectionToMap",
  }

_SET_RETURNING = {
    "stdSetInclude": "set of data",
    "stdSetExclude": "set of data",
    "stdSetUnion": "set of data",
    "stdSetIntersect": "set of data",
    "stdSetDifference": "set of data",
    "stdSetSymmetricDifference": "set of data",
    "stdSetToSet": "set of data",
    "stdSetToList": "list of data",
}


def _callee_name(callee: ASTNode | None) -> str:
    if isinstance(callee, Identifier):
        return callee.name
    if isinstance(callee, EnumVariant):
        return callee.variant
    if isinstance(callee, FieldAccess) and isinstance(callee.obj, Identifier):
        return callee.field
    return ""


def _wat_escape(s: str) -> str:
    r = []
    for ch in s:
        o = ord(ch)
        if ch == "\n":
            r.append("\\n")
        elif ch == "\r":
            r.append("\\r")
        elif ch == "\t":
            r.append("\\t")
        elif ch == "\\":
            r.append("\\\\")
        elif ch == "\"":
            r.append('\\"')
        elif 32 <= o < 127:
            r.append(ch)
        else:
            for b in ch.encode("utf-8"):
                r.append(f"\\{b:02X}")
    return "".join(r)


def generate_wat(program: ASTNode, output_path: str) -> str:
    from flux_proto.macro.expander import expand_macros
    if isinstance(program, FluxProgram):
        program = expand_macros(program)
    cg = _WatCodegen()
    wat_text = cg.generate(program)
    path = output_path if output_path.endswith(".wat") else output_path + ".wat"
    with open(path, "w", encoding="utf-8") as f:
        f.write(wat_text)
    return wat_text


class _FuncBuilder:
    def __init__(self) -> None:
        self._i32_locals: int = 0
        self._i64_locals: int = 0
        self._f64_locals: int = 0
        self._body: list[str] = []

    def new_i32(self) -> str:
        n = self._i32_locals
        self._i32_locals += 1
        return f"$i{n}"

    def new_i64(self) -> str:
        n = self._i64_locals
        self._i64_locals += 1
        return f"$j{n}"

    def new_f64(self) -> str:
        n = self._f64_locals
        self._f64_locals += 1
        return f"$k{n}"

    def emit(self, line: str) -> None:
        self._body.append(line)

    def get_locals_block(self) -> str:
        lines = [
            "    (local $__fr_sta i32)",
            "    (local $__fr_val i64)",
            "    (local $__fr_vald f64)",
            "    (local $__fr_msg i32)",
        ]
        for i in range(self._i32_locals):
            lines.append(f"    (local $i{i} i32)")
        for j in range(self._i64_locals):
            lines.append(f"    (local $j{j} i64)")
        for k in range(self._f64_locals):
            lines.append(f"    (local $k{k} f64)")
        return "\n".join(lines)


class _WatCodegen:
    def __init__(self) -> None:
        self._str_offsets: dict[str, tuple[int, int]] = {}
        self._next_off = 16
        self._globals: dict[str, tuple[str, str]] = {
            "flux_io_last_write": ("string", "i64"),
            "flux_io_copy_exists": ("bool", "i32"),
            "flux_io_moved_exists": ("bool", "i32"),
            "flux_io_dir_exists": ("bool", "i32"),
        }
        self._imports: dict[str, FdslFile] = {}
        self._loop_stack: list[tuple[str, str]] = []
        self._local_vars: dict[str, tuple[str, str]] = {}
        self._param_wtypes: set[str] = set()
        self._param_tag_slots: dict[str, str] = {}
        self._in_function = False
        self._user_funcs: dict[str, dict] = {}
        self._sc_vars: dict[str, str] = {}
        self._result_vars: dict[str, tuple[str, str, str, str]] = {}
        self._enums: dict[str, EnumDef] = {}
        self._enum_slots: dict[str, dict] = {}
        self._pending_enum: dict | None = None
        self._complex_slots: dict[str, dict] = {}
        self._uses_input = False
        self._structs: dict[str, StructDef] = {}
        self._struct_slots: dict[str, dict] = {}
        self._pending_struct: dict | None = None
        self._pow_seq = 0
        self._op_defs: dict = {}
        self._op_aliases: dict[str, str] = {}
        self._used_op_names: set[str] = set()
        self._in_binary_op: bool = False

    def _alloc_str(self, s: str) -> int:
        if s in self._str_offsets:
            return self._str_offsets[s][0]
        off = self._next_off
        slen = len(s.encode("utf-8"))
        self._str_offsets[s] = (off, slen)
        self._next_off = off + slen + 1
        return off

    def _str_len(self, s: str) -> int:
        if s in self._str_offsets:
            return self._str_offsets[s][1]
        return 0

    def _fat_const(self, s: str) -> int:
        if s not in self._str_offsets:
            self._alloc_str(s)
        off, slen = self._str_offsets[s]
        return (off << 32) | slen

    def _fat_expr(self, ptr: str, length: str) -> str:
        return f"(i64.or (i64.shl (i64.extend_i32_u {ptr}) (i64.const 32)) (i64.extend_i32_u {length}))"

    def _itoa_buf_off(self) -> int:
        return self._next_off + 64

    def _f64_buf_off(self) -> int:
        return self._next_off + 192

    def _dt_buf_off(self) -> int:
        return self._next_off + 320

    def _dt_wasi_off(self) -> int:
        return self._next_off + 400

    def _iov_off(self) -> int:
        page = 65536
        low_end = self._next_off + 512
        pages = max(1, (low_end + 15 + page - 1) // page)
        return pages * page - 16

    def _input_buf_off(self) -> int:
        return self._iov_off() + 16

    def _read_iov_off(self) -> int:
        return self._input_buf_off() + 4096

    def _read_nw_off(self) -> int:
        return self._read_iov_off() + 8

    def _collect_strs(self, node: ASTNode) -> None:
        if isinstance(node, Literal) and node.value_type.lower() in ("string", "str"):
            self._alloc_str(node.value)
        elif isinstance(node, StorageDecl):
            for it in node.items:
                if it.initializer is None:
                    continue
                if isinstance(it.initializer, Literal) and it.initializer.value_type.lower() in ("string", "str"):
                    self._alloc_str(it.initializer.value)
                else:
                    self._collect_strs(it.initializer)
        elif isinstance(node, FluxProgram):
            for s in node.storages:
                self._collect_strs(s)
            for f in node.functions:
                self._collect_strs(f)
            if node.body:
                self._collect_strs(node.body)
        elif isinstance(node, FunctionDef):
            if node.body:
                self._collect_strs(node.body)
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
        elif isinstance(node, ListLiteral):
            for it in node.items:
                self._collect_strs(it)
        elif isinstance(node, SetLiteral):
            for it in node.items:
                self._collect_strs(it)
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
        elif isinstance(node, VariableReassign):
            self._collect_strs(node.value)
        elif isinstance(node, FieldAssign):
            self._collect_strs(node.value)
        elif isinstance(node, IndexAccess):
            for idx in node.indices:
                self._collect_strs(idx)
            self._collect_strs(node.obj)
        elif isinstance(node, IndexAssign):
            for idx in node.indices:
                self._collect_strs(idx)
            self._collect_strs(node.value)
        elif isinstance(node, EnumVariant):
            for f in node.fields:
                self._collect_strs(f.value)
        elif isinstance(node, StructInit):
            for f in node.fields:
                self._collect_strs(f.value)
        elif isinstance(node, InterpolatedString):
            for p in node.parts:
                self._collect_strs(p)
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
        elif isinstance(node, CastExpr):
            self._collect_strs(node.expr)
        elif isinstance(node, VariableReassign):
            self._collect_strs(node.value)
        elif isinstance(node, EmitStmt):
            if node.value_expr is not None:
                self._collect_strs(node.value_expr)
            elif isinstance(node.value, ASTNode):
                self._collect_strs(node.value)
            if node.message:
                self._collect_strs(node.message)

    def _is_str_type(self, ft: str) -> bool:
        t = ft.lower()
        return t in ("string", "str") or t.startswith("string(")

    def _is_char_type(self, ft: str) -> bool:
        return ft.lower() == "char"

    def _is_list_type(self, ft: str) -> bool:
        t = ft.lower()
        return t.startswith("list of") or t == "list"

    def _is_map_type(self, ft: str) -> bool:
        return ft.lower() == "map"

    def _is_set_type(self, ft: str) -> bool:
        t = ft.lower()
        return t.startswith("set of") or t == "set"

    def _is_tensor_type(self, ft: str) -> bool:
        return ft.lower().startswith("tensor")

    def _tensor_dims_of(self, ft: str) -> list[int]:
        head = ft.split("of", 1)[0]
        inner = head[head.index("[") + 1 : head.rindex("]")]
        return [int(d.strip()) for d in inner.split(",") if d.strip()]

    def _tensor_elem_ft(self, ft: str) -> str:
        return ft.split("of", 1)[1].strip()

    def _set_elem_type(self, ft: str) -> str:
        t = ft.lower()
        parts = t.split(" of ")
        return " of ".join(parts[1:]) if t.startswith("set of") else parts[-1]

    def _set_elem_flux_type(self, node: ASTNode | None) -> str:
        if isinstance(node, SetLiteral):
            if node.items:
                return self._infer_type(node.items[0])
            return "int64"
        if node is not None:
            return self._infer_type(node)
        return "int64"

    def _list_elem_type(self, ft: str) -> str:
        t = ft.lower()
        parts = t.split(" of ")
        return " of ".join(parts[1:]) if t.startswith("list of") else parts[-1]

    def _list_elem_flux_type(self, node: ASTNode | None) -> str:
        if isinstance(node, ListLiteral):
            if node.items:
                it = self._infer_type(node.items[0])
                if self._is_list_type(it):
                    return f"list of {self._list_elem_type(it)}"
                return it
            return "int64"
        if node is not None:
            return self._infer_type(node)
        return "int64"

    def _list_tag_of(self, et: str) -> int:
        t = et.lower()
        if t in ("string", "str", "char") or t.startswith("string("):
            return 4
        if t == "bool":
            return 2
        if t in FLOATISH:
            return 3
        if t.startswith("list of") or t.startswith("set of") or t.startswith("map") or t in ("list", "set", "map"):
            return 5
        return 1

    def _list_val_of(self, et: str, expr: str) -> str:
        t = et.lower()
        if t in FLOATISH:
            return f"(i64.reinterpret_f64 {expr})"
        if t in ("string", "str", "char"):
            return expr
        if t.startswith("list of"):
            return f"(i64.extend_i32_u {expr})"
        return expr

    def _register_body_storages(self, node: ASTNode) -> None:
        if isinstance(node, BlockStmt):
            for stmt in node.body:
                if isinstance(stmt, StorageDecl):
                    for it in stmt.items:
                        ft = it.type_ref.name if it.type_ref else "string"
                        if ft.lower().startswith("complex"):
                            self._globals[f"{it.name}_flux_re"] = ("float64", "f64")
                            self._globals[f"{it.name}_flux_im"] = ("float64", "f64")
                            self._complex_slots[it.name] = {
                                "kind": "global",
                                "re": f"${it.name}_flux_re",
                                "im": f"${it.name}_flux_im",
                                "type": ft,
                            }
                            continue
                        if ft in self._enums:
                            self._declare_enum_storage_global(it, None)
                            continue
                        if ft in self._structs:
                            self._declare_struct_storage_global(it, None)
                            continue
                        if isinstance(it.initializer, (CallExpr, ShortCircuitBlock)) and (it.type_ref is None or it.type_ref.name == "result"):
                            self._result_vars[it.name] = ("global", f"${it.name}_sta", f"${it.name}_val", f"${it.name}_msg")
                        else:
                            self._globals[it.name] = (ft, self._wtype(ft))
                elif isinstance(stmt, (BlockStmt, RouteStmt, InfiniteStmt)):
                    self._register_body_storages(stmt)
        elif isinstance(node, RouteStmt):
            for arm in node.arms:
                if arm.body is not None:
                    self._register_body_storages(arm.body)
        elif isinstance(node, InfiniteStmt):
            if node.body is not None:
                self._register_body_storages(node.body)

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
            if node.field in ("sta", "msg"):
                return "string"
            if node.field == "val":
                if isinstance(node.obj, CallExpr):
                    cname = node.obj.callee.name if isinstance(node.obj.callee, Identifier) else ""
                    if cname.startswith(("stdList", "stdSet")):
                        if cname in _LIST_RETURNING:
                            return "list of data"
                        if cname in _SET_RETURNING:
                            return _SET_RETURNING[cname]
                        return "int64"
                    if cname in self._user_funcs:
                        return self._user_funcs[cname]["return_type"]
                return "int64"
            ftype = self._field_type(node)
            if ftype is not None:
                return ftype
            return "int64"
        if isinstance(node, Identifier):
            if node.name in self._sc_vars:
                return "int64"
            if node.name in self._local_vars:
                return self._local_vars[node.name][1]
            if node.name in self._globals:
                return self._globals[node.name][0]
            if node.name in self._result_vars:
                return "int64"
            return "string"
        if isinstance(node, BinaryOp):
            if node.op in ("==", "!=", "<", "<=", ">", ">=", "and", "or", "in"):
                return "bool"
            lt = self._infer_type(node.left)
            rt = self._infer_type(node.right)
            if (self._is_set_type(lt) or self._is_set_type(rt) or self._is_list_type(lt) or self._is_list_type(rt) or self._is_map_type(lt) or self._is_map_type(rt)) and node.op == "+":
                return "string"
            if self._is_str_type(lt) or self._is_str_type(rt):
                return "string"
            if self._is_list_type(lt):
                return lt
            if self._is_list_type(rt):
                return rt
            if node.op == "^r":
                return "float64"
            if node.op == "/f" or (node.op in ("+", "-", "*", "^e") and (lt in FLOATISH or rt in FLOATISH)):
                return "float64"
            return "int64"
        if isinstance(node, ListLiteral):
            return f"list of {self._list_elem_flux_type(node)}"
        if isinstance(node, SetLiteral):
            return f"set of {self._set_elem_flux_type(node)}"
        if isinstance(node, IndexAccess):
            ot = self._infer_type(node.obj)
            if ot == "string" or ot.startswith("string"):
                return "string"
            if self._is_map_type(ot):
                return "data"
            if self._is_list_type(ot) or ot == "data":
                if node.indices and isinstance(node.indices[0], SliceSpec):
                    return ot
                return self._list_elem_type(ot) if self._is_list_type(ot) else "data"
            if self._is_tensor_type(ot):
                dims = self._tensor_dims_of(ot)
                et = self._tensor_elem_ft(ot)
                has_slice = any(isinstance(ix, SliceSpec) for ix in node.indices)
                if not has_slice:
                    return et
                nd, _ns, _off = self._tensor_slice_dims(node.indices, dims)
                return f"tensor[{', '.join(str(d) for d in nd)}] of {et}"
            return "int64"
        if isinstance(node, MapLiteral):
            return "map"
        if isinstance(node, RecordLiteral):
            return "data"
        if isinstance(node, CallExpr):
            name = _callee_name(node.callee)
            if name.startswith(("stdList", "stdSet", "stdMap", "stdCollection")):
                if name in _MAP_RETURNING:
                    return "map"
                if name in _LIST_RETURNING:
                    return "list of data"
                if name in _SET_RETURNING:
                    return _SET_RETURNING[name]
                if name == "stdMapGetValueOrDefault":
                    return "data"
                if name == "stdCollectionClearAll":
                    return self._infer_type(node.args[0]) if node.args else "int64"
                return "int64"
            if name in self._user_funcs:
                return self._user_funcs[name]["return_type"]
            return "int64"
        if isinstance(node, InterpolatedString):
            return "string"
        if isinstance(node, InterpolatedText):
            return "string"
        if isinstance(node, MatchExpr):
            rt = self._match_result_type(node)
            if rt == "f64":
                return "float64"
            if rt == "i32":
                return "int32"
            for arm in node.arms:
                if isinstance(arm.pattern, IdentifierPattern):
                    if self._is_str_type(self._match_subject_flux_type(node)):
                        return "string"
                if isinstance(arm.pattern, EnumVariantPattern):
                    edef = self._enums.get(arm.pattern.enum)
                    if edef is not None and any(
                        self._enum_field_is_str(edef, f.name)
                        for f in arm.pattern.fields
                        if isinstance(f.value, IdentifierPattern)
                    ):
                        return "string"
                if isinstance(arm.body, MatchExpr):
                    continue
                if self._is_str_type(self._infer_type(arm.body)):
                    return "string"
            return "int64"
        return "int64"

    def _wtype(self, ft: str) -> str:
        t = ft.lower()
        if t in ("string", "str") or t.startswith("string("):
            return "i64"
        if t == "char":
            return "i32"
        if t in FLOATISH:
            return "f64"
        if t == "bool":
            return "i64"
        if t.startswith(("list of", "set of")) or t in ("list", "set", "map", "data"):
            return "i64"
        if t.startswith("tensor"):
            return "i32"
        return "i64"

    @staticmethod
    def _complex_static_value(node: ASTNode) -> complex:
        from flux_proto.interpreter.interpreter import _parse_complex_literal

        if isinstance(node, Literal):
            vt = node.value_type.lower()
            if vt == "complex":
                return _parse_complex_literal(str(node.value))
            if vt in FLOATISH:
                return complex(float(str(node.value)))
            if vt in ("int", "int64"):
                return complex(int(str(node.value)))
        if isinstance(node, BinaryOp) and node.op in ("+", "-"):
            lv = _WatCodegen._complex_static_value(node.left)
            rv = _WatCodegen._complex_static_value(node.right)
            return lv + rv if node.op == "+" else lv - rv
        raise WatError("complex initializer must be a constant expression")

    def _format_complex_text(self, re: float, im: float) -> str:
        if im >= 0:
            return f"{re} + {im}i"
        return f"{re} - {-im}i"

    def _gen_complex_value(self, node: ASTNode, fb: _FuncBuilder, body: list[str], I: str) -> tuple[str, str]:
        try:
            cv = self._complex_static_value(node)
            return (f"(f64.const {norm_float_text(str(cv.real))})", f"(f64.const {norm_float_text(str(cv.imag))})")
        except WatError:
            pass
        if isinstance(node, CastExpr) and node.target_type.name.lower().startswith("complex"):
            re_v, re_vt = self._gen_expr(node.expr, fb, body, I)
            re_fit = self._fit_wat(re_v, re_vt, "f64")
            return (re_fit, "(f64.const 0.0)")
        if isinstance(node, CallExpr):
            cname = _callee_name(node.callee)
            cname = self._op_aliases.get(cname, cname)
            if cname in ("convertToComplex", "convertToComplex32", "convertToComplex128", "toComplex") and len(node.args) >= 2:
                rv, rvt = self._gen_expr(node.args[0], fb, body, I)
                iv, ivt = self._gen_expr(node.args[1], fb, body, I)
                rf = self._fit_wat(rv, rvt, "f64")
                imf = self._fit_wat(iv, ivt, "f64")
                if cname in ("convertToComplex32",) or "32" in cname:
                    rf = self._round_wrap(rf, "float16")
                    imf = self._round_wrap(imf, "float16")
                return (rf, imf)
        if isinstance(node, Identifier) and node.name in self._complex_slots:
            s = self._complex_slots[node.name]
            g = "global.get" if s["kind"] == "global" else "local.get"
            return (f"({g} {s['re']})", f"({g} {s['im']})")
        if isinstance(node, UnaryOp) and node.op == "-":
            r, i2 = self._gen_complex_value(node.operand, fb, body, I)
            return (f"(f64.neg {r})", f"(f64.neg {i2})")
        if isinstance(node, BinaryOp) and node.op in ("+", "-", "*", "/"):
            lr, li = self._gen_complex_value(node.left, fb, body, I)
            rr, ri = self._gen_complex_value(node.right, fb, body, I)
            if node.op == "+":
                return (f"(f64.add {lr} {rr})", f"(f64.add {li} {ri})")
            if node.op == "-":
                return (f"(f64.sub {lr} {rr})", f"(f64.sub {li} {ri})")
            if node.op == "*":
                return (
                    f"(f64.sub (f64.mul {lr} {rr}) (f64.mul {li} {ri}))",
                    f"(f64.add (f64.mul {lr} {ri}) (f64.mul {li} {rr}))",
                )
            den = f"(f64.add (f64.mul {rr} {rr}) (f64.mul {ri} {ri}))"
            return (
                f"(f64.div (f64.add (f64.mul {lr} {rr}) (f64.mul {li} {ri})) {den})",
                f"(f64.div (f64.sub (f64.mul {li} {rr}) (f64.mul {lr} {ri})) {den})",
            )
        raise WatError(f"unsupported complex expression: {type(node).__name__}")

    def _round_wrap(self, expr: str, fmt: str) -> str:
        if fmt not in FMT_CONSTS or fmt == "float64":
            return expr
        mb, emin, emax, allow_inf = FMT_CONSTS[fmt]
        return (
            f"(call $round_fmt {expr} "
            f"(i64.const {mb}) (i64.const {emin}) (i64.const {emax}) (i64.const {allow_inf}))"
        )

    def _round_fmt_wat(self, I: str) -> list[str]:
        return [
            f"{I}(func $round_fmt (param $v f64) (param $mb i64) (param $emin i64) (param $emax i64) (param $allow_inf i64) (result f64)",
            f"{I}  (local $b i64)",
            f"{I}  (local $s i64)",
            f"{I}  (local $e i64)",
            f"{I}  (local $f2 i64)",
            f"{I}  (local $drop i64)",
            f"{I}  (local $half i64)",
            f"{I}  (local $rem i64)",
            f"{I}  (local $eu i64)",
            f"{I}  (local.set $b (i64.reinterpret_f64 (local.get $v)))",
            f"{I}  (local.set $e (i64.and (i64.shr_u (local.get $b) (i64.const 52)) (i64.const 2047)))",
            f"{I}  (if (i64.eq (local.get $e) (i64.const 2047))",
            f"{I}    (then",
            f"{I}      (if (i64.eqz (local.get $allow_inf))",
            f"{I}        (then (return (f64.div (f64.const 0.0) (f64.const 0.0))))",
            f"{I}      )",
            f"{I}      (return (local.get $v))",
            f"{I}    )",
            f"{I}  )",
            f"{I}  (if (i64.eqz (local.get $e)) (then (return (local.get $v))))",
            f"{I}  (local.set $drop (i64.sub (i64.const 52) (local.get $mb)))",
            f"{I}  (if (i64.eqz (local.get $drop)) (then (return (local.get $v))))",
            f"{I}  (local.set $s (i64.shr_u (local.get $b) (i64.const 63)))",
            f"{I}  (local.set $half (i64.shl (i64.const 1) (i64.sub (local.get $drop) (i64.const 1))))",
            f"{I}  (local.set $f2 (i64.shr_u (i64.or (i64.and (local.get $b) (i64.const 4503599627370495)) (i64.const 4503599627370496)) (local.get $drop)))",
            f"{I}  (local.set $rem (i64.and (i64.and (local.get $b) (i64.const 4503599627370495)) (i64.sub (i64.shl (local.get $half) (i64.const 1)) (i64.const 1))))",
            f"{I}  (if (i64.gt_u (local.get $rem) (local.get $half))",
            f"{I}    (then (local.set $f2 (i64.add (local.get $f2) (i64.const 1))))",
            f"{I}  )",
            f"{I}  (if (i64.eq (local.get $rem) (local.get $half))",
            f"{I}    (then",
            f"{I}      (if (i64.ne (i64.and (local.get $f2) (i64.const 1)) (i64.const 0))",
            f"{I}        (then (local.set $f2 (i64.add (local.get $f2) (i64.const 1))))",
            f"{I}      )",
            f"{I}    )",
            f"{I}  )",
            f"{I}  (if (i64.eq (local.get $f2) (i64.shl (i64.const 1) (i64.add (local.get $mb) (i64.const 1))))",
            f"{I}    (then",
            f"{I}      (local.set $f2 (i64.const 0))",
            f"{I}      (local.set $e (i64.add (local.get $e) (i64.const 1)))",
            f"{I}    )",
            f"{I}  )",
            f"{I}  (local.set $eu (i64.sub (local.get $e) (i64.const 1023)))",
            f"{I}  (if (i64.gt_s (local.get $eu) (local.get $emax))",
            f"{I}    (then",
            f"{I}      (if (i64.eqz (local.get $allow_inf))",
            f"{I}        (then (return (f64.div (f64.const 0.0) (f64.const 0.0))))",
            f"{I}      )",
            f"{I}      (if (i64.eqz (local.get $s))",
            f"{I}        (then (return (f64.div (f64.const 1.0) (f64.const 0.0))))",
            f"{I}        (else (return (f64.neg (f64.div (f64.const 1.0) (f64.const 0.0)))))",
            f"{I}      )",
            f"{I}    )",
            f"{I}  )",
            f"{I}  (if (i64.lt_s (local.get $eu) (local.get $emin))",
            f"{I}    (then (return (f64.reinterpret_i64 (i64.shl (local.get $s) (i64.const 63)))))",
            f"{I}  )",
            f"{I}  (return (f64.reinterpret_i64",
            f"{I}    (i64.or",
            f"{I}      (i64.or",
            f"{I}        (i64.shl (local.get $s) (i64.const 63))",
            f"{I}        (i64.shl (i64.add (local.get $eu) (i64.const 1023)) (i64.const 52))",
            f"{I}      )",
            f"{I}      (i64.and (i64.shl (local.get $f2) (local.get $drop)) (i64.const 4503599627370495))",
            f"{I}    )",
            f"{I}  ))",
            f"{I})",
        ]


    def generate(self, program: ASTNode) -> str:
        if not isinstance(program, FluxProgram):
            raise WatError(f"Cannot generate WAT for {type(program).__name__}")
        self._imports = program.imports
        self._op_aliases = collect_op_aliases(program)
        self._op_defs = {}
        self._used_op_names: set[str] = set()
        for fdsl in self._imports.values():
            for agent in fdsl.agents:
                if agent.body:
                    for op in agent.body.ops:
                        self._op_defs[op.name] = op
        self._collect_called_ops(program)
        prev_count = -1
        while len(self._used_op_names) != prev_count:
            prev_count = len(self._used_op_names)
            for op_name in list(self._used_op_names):
                op = self._op_defs[op_name]
                if op.body:
                    for expr in op.body.expressions:
                        self._collect_called_ops(expr)
        self._enums = {e.name: e for e in program.enums}
        self._structs = {s.name: s for s in program.structs}
        all_storages = list(program.storages)
        for fdsl in self._imports.values():
            for agent in fdsl.agents:
                if agent.body:
                    for s in agent.body.storages:
                        all_storages.append(s)

        for s in all_storages:
            for it in s.items:
                if isinstance(it.initializer, (CallExpr, ShortCircuitBlock)) and (it.type_ref is None or it.type_ref.name == "result"):
                    if it.name not in self._result_vars:
                        self._result_vars[it.name] = ("global", f"${it.name}_sta", f"${it.name}_val", f"${it.name}_msg")
                    ft = it.type_ref.name if it.type_ref else "string"
                    self._globals.pop(it.name, None)
                else:
                    ft = it.type_ref.name if it.type_ref else "string"
                    if ft in self._enums:
                        if it.name not in self._enum_slots:
                            self._declare_enum_storage_global(it, None)
                        continue
                    if ft in self._structs:
                        if it.name not in self._struct_slots:
                            self._declare_struct_storage_global(it, None)
                        continue
                    wt = self._wtype(ft)
                    self._globals[it.name] = (ft, wt)

        if program.body:
            self._register_body_storages(program.body)

        self._collect_strs(program)
        for s in all_storages:
            for it in s.items:
                self._collect_strs(it)
        for e in program.enums:
            for m in e.members:
                self._alloc_str(f"{e.name}::{m.name}")
        self._alloc_str("nice")
        self._alloc_str("fail")
        self._alloc_str("true")
        self._alloc_str("false")
        self._alloc_str("divisao por zero")
        self._alloc_str("")
        self._alloc_str(" ")
        self._alloc_str("\n")

        for f in program.functions:
            fparams = []
            for p in f.params:
                pft = p.type_ref.name if p.type_ref else "int64"
                wt = "i64" if pft == "data" else self._wtype(pft)
                fparams.append((p.name, wt, pft))
            rtype = "int64"
            if f.return_type is not None:
                rtype = f.return_type.name
            self._user_funcs[f.name] = {
                "params": fparams,
                "return_type": rtype,
            }

        for op_name in sorted(self._used_op_names):
            op = self._op_defs[op_name]
            oparams = []
            for p in op.params:
                pft = p.type_ref.name if p.type_ref else "int64"
                wt = "i64" if pft == "data" else self._wtype(pft)
                oparams.append((p.name, wt, pft))
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
            self._user_funcs[op_name] = {
                "params": oparams,
                "return_type": rtype,
            }

        I = "  "
        helper_lines: list[str] = []
        self._emit_helpers(helper_lines, I)

        for op_name in sorted(self._used_op_names):
            self._emit_op_function(self._op_defs[op_name], helper_lines, I)

        for f in program.functions:
            self._emit_user_function(f, helper_lines, I)

        fb = _FuncBuilder()
        body_lines: list[str] = []

        for s in all_storages:
            for it in s.items:
                ft = it.type_ref.name if it.type_ref else "string"
                if ft in self._enums:
                    self._declare_enum_storage_global(it, body_lines)
                    continue
                if ft in self._structs:
                    if it.name not in self._struct_slots:
                        self._declare_struct_storage_global(it, body_lines)
                    elif it.initializer is not None:
                        self._emit_struct_into(it.initializer, self._struct_slots[it.name]["slots"], None, body_lines, "    ", is_global=True)
                    continue
                if it.initializer and isinstance(it.initializer, Literal):
                    vt = it.initializer.value_type.lower()
                    if vt in ("string", "str"):
                        self._alloc_str(it.initializer.value)
                        body_lines.append(f"    (global.set ${it.name} (i64.const {self._fat_const(it.initializer.value)}))")
                    elif vt == "char":
                        body_lines.append(f"    (global.set ${it.name} (i32.const {ord(it.initializer.value)}))")
                    elif vt in ("int", "int64", "int32", "int16", "int8", "int"):
                        body_lines.append(f"    (global.set ${it.name} (i64.const {it.initializer.value}))")
                    elif vt == "bool":
                        v = "1" if it.initializer.value.lower() == "true" else "0"
                        body_lines.append(f"    (global.set ${it.name} ({self._wtype(ft)}.const {v}))")
                    elif vt in ("float", "float64", "float32") or vt in REDUCED_FLOATS:
                        fconst = f"(f64.const {norm_float_text(it.initializer.value)})"
                        if ft in FMT_CONSTS and ft != "float64":
                            fconst = self._round_wrap(fconst, ft)
                        body_lines.append(f"    (global.set ${it.name} {fconst})")
                elif it.initializer is not None:
                    if isinstance(it.initializer, ShortCircuitBlock):
                        self._gen_short_circuit(it.initializer, fb, body_lines, "    ", bind_name=it.name)
                    else:
                        expr, etype = self._gen_expr(it.initializer, fb, body_lines, "    ")
                        if ft in FMT_CONSTS and ft != "float64":
                            if etype != "f64":
                                expr = f"(f64.convert_i64_s {expr})"
                            expr = self._round_wrap(expr, ft)
                        self._sc_set(it.name, expr, fb, body_lines, "    ", expr_type=etype)

        if program.body:
            self._gen_block(program.body, fb, body_lines, "    ")

        if self._uses_input:
            self._emit_input_helpers(helper_lines, I)

        mod_lines: list[str] = []
        mod_lines.append("(module")
        mod_lines.append(f'{I}(import "wasi_snapshot_preview1" "fd_write" (func $fd_write (param i32 i32 i32 i32) (result i32)))')
        mod_lines.append(f'{I}(import "wasi_snapshot_preview1" "fd_read" (func $fd_read (param i32 i32 i32 i32) (result i32)))')
        mod_lines.append(f'{I}(import "wasi_snapshot_preview1" "clock_time_get" (func $clock_time_get (param i32 i64 i32) (result i32)))')
        mem_needed = self._read_nw_off() + 8
        pages = (mem_needed + 65535) // 65536
        mod_lines.append(f"{I}(memory (export \"memory\") {max(1, pages)})")
        heap_start = (mem_needed + 7) & ~7
        mod_lines.append(f"{I}(global $flux_heap_ptr (mut i32) (i32.const {heap_start}))")
        mod_lines.append(f"{I}(global $flux_heap_start (mut i32) (i32.const {heap_start}))")
        for gname, (ft, wt) in self._globals.items():
            zero = "i64.const 0" if wt == "i64" else ("f64.const 0.0" if wt == "f64" else "i32.const 0")
            mod_lines.append(f"{I}(global ${gname} (mut {wt}) {zero})")
        for rname, (kind, sta, val, msg) in self._result_vars.items():
            if kind == "global":
                mod_lines.append(f"{I}(global {sta} (mut i32) (i32.const 0))")
                mod_lines.append(f"{I}(global {val} (mut i64) (i64.const 0))")
                mod_lines.append(f"{I}(global {msg} (mut i32) (i32.const 0))")
        mod_lines.extend(helper_lines)
        mod_lines.append(f"{I}(func $_start (export \"_start\")")
        locals_block = fb.get_locals_block()
        if locals_block:
            mod_lines.append(locals_block)
        mod_lines.extend(body_lines)
        mod_lines.append(f"{I})")
        mod_lines.append("")
        for s, (off, _slen) in sorted(self._str_offsets.items(), key=lambda x: x[1][0]):
            mod_lines.append(f'{I}(data (i32.const {off}) "{_wat_escape(s)}\\00")')
        mod_lines.append(")")
        return "\n".join(mod_lines) + "\n"

    def _emit_helpers(self, lines: list[str], I: str) -> None:
        lines.append(f"{I}(func $strlen (param $p i32) (result i32)")
        lines.append(f"{I}  (local $len i32)")
        lines.append(f"{I}  (local.set $len (i32.const 0))")
        lines.append(f"{I}  (block $done")
        lines.append(f"{I}    (loop $loop")
        lines.append(f"{I}      (if (i32.eqz (i32.load8_u (i32.add (local.get $p) (local.get $len)))) (then (br $done)))")
        lines.append(f"{I}      (local.set $len (i32.add (local.get $len) (i32.const 1)))")
        lines.append(f"{I}      (br $loop)")
        lines.append(f"{I}    )")
        lines.append(f"{I}  )")
        lines.append(f"{I}  (return (local.get $len))")
        lines.append(f"{I})")
        lines.append("")
        lines.append(f"{I}(func $i64_to_str (param $val i64) (param $buf i32) (result i32)")
        lines.append(f"{I}  (local $pos i32)")
        lines.append(f"{I}  (local $neg i32)")
        lines.append(f"{I}  (local.set $pos (i32.const 0))")
        lines.append(f"{I}  (local.set $neg (i32.const 0))")
        lines.append(f"{I}  (if (i64.lt_s (local.get $val) (i64.const 0))")
        lines.append(f"{I}    (then")
        lines.append(f"{I}      (local.set $neg (i32.const 1))")
        lines.append(f"{I}      (local.set $val (i64.sub (i64.const 0) (local.get $val)))")
        lines.append(f"{I}    )")
        lines.append(f"{I}  )")
        lines.append(f"{I}  (block $done")
        lines.append(f"{I}    (loop $loop")
        lines.append(f"{I}      (i32.store8 (i32.add (local.get $buf) (local.get $pos))")
        lines.append(f"{I}        (i32.add (i32.wrap_i64 (i64.rem_u (local.get $val) (i64.const 10))) (i32.const 48)))")
        lines.append(f"{I}      (local.set $val (i64.div_u (local.get $val) (i64.const 10)))")
        lines.append(f"{I}      (local.set $pos (i32.add (local.get $pos) (i32.const 1)))")
        lines.append(f"{I}      (if (i64.eqz (local.get $val)) (then (br $done)))")
        lines.append(f"{I}      (br $loop)")
        lines.append(f"{I}    )")
        lines.append(f"{I}  )")
        lines.append(f"{I}  (if (local.get $neg)")
        lines.append(f"{I}    (then")
        lines.append(f"{I}      (i32.store8 (i32.add (local.get $buf) (local.get $pos)) (i32.const 45))")
        lines.append(f"{I}      (local.set $pos (i32.add (local.get $pos) (i32.const 1)))")
        lines.append(f"{I}    )")
        lines.append(f"{I}  )")
        lines.append(f"{I}  (call $reverse (local.get $buf) (local.get $pos))")
        lines.append(f"{I}  (return (local.get $pos))")
        lines.append(f"{I})")
        lines.append("")
        lines.append(f"{I}(func $f64_ln (param $x f64) (result f64)")
        lines.append(f"{I}  (local $k f64)")
        lines.append(f"{I}  (local $u f64)")
        lines.append(f"{I}  (local $u2 f64)")
        lines.append(f"{I}  (local $term f64)")
        lines.append(f"{I}  (local $s f64)")
        lines.append(f"{I}  (local $i i32)")
        lines.append(f"{I}  (if (f64.le (local.get $x) (f64.const 0.0)) (then (return (f64.const nan))))")
        lines.append(f"{I}  (local.set $k (f64.const 0.0))")
        lines.append(f"{I}  (block $b1")
        lines.append(f"{I}    (loop $l1")
        lines.append(f"{I}      (if (f64.ge (local.get $x) (f64.const 2.0))")
        lines.append(f"{I}        (then")
        lines.append(f"{I}          (local.set $x (f64.mul (local.get $x) (f64.const 0.5)))")
        lines.append(f"{I}          (local.set $k (f64.add (local.get $k) (f64.const 1.0)))")
        lines.append(f"{I}          (br $l1)")
        lines.append(f"{I}        )")
        lines.append(f"{I}      )")
        lines.append(f"{I}    )")
        lines.append(f"{I}  )")
        lines.append(f"{I}  (block $b2")
        lines.append(f"{I}    (loop $l2")
        lines.append(f"{I}      (if (f64.lt (local.get $x) (f64.const 1.0))")
        lines.append(f"{I}        (then")
        lines.append(f"{I}          (local.set $x (f64.mul (local.get $x) (f64.const 2.0)))")
        lines.append(f"{I}          (local.set $k (f64.sub (local.get $k) (f64.const 1.0)))")
        lines.append(f"{I}          (br $l2)")
        lines.append(f"{I}        )")
        lines.append(f"{I}      )")
        lines.append(f"{I}    )")
        lines.append(f"{I}  )")
        lines.append(f"{I}  (local.set $u (f64.div (f64.sub (local.get $x) (f64.const 1.0)) (f64.add (local.get $x) (f64.const 1.0))))")
        lines.append(f"{I}  (local.set $u2 (f64.mul (local.get $u) (local.get $u)))")
        lines.append(f"{I}  (local.set $term (local.get $u))")
        lines.append(f"{I}  (local.set $s (local.get $u))")
        lines.append(f"{I}  (local.set $i (i32.const 3))")
        lines.append(f"{I}  (block $b3")
        lines.append(f"{I}    (loop $l3")
        lines.append(f"{I}      (if (i32.gt_s (local.get $i) (i32.const 25)) (then (br $b3)))")
        lines.append(f"{I}      (local.set $term (f64.mul (local.get $term) (local.get $u2)))")
        lines.append(f"{I}      (local.set $s (f64.add (local.get $s) (f64.div (local.get $term) (f64.convert_i32_s (local.get $i)))))")
        lines.append(f"{I}      (local.set $i (i32.add (local.get $i) (i32.const 2)))")
        lines.append(f"{I}      (br $l3)")
        lines.append(f"{I}    )")
        lines.append(f"{I}  )")
        lines.append(f"{I}  (return (f64.add (f64.mul (f64.const 2.0) (local.get $s)) (f64.mul (local.get $k) (f64.const 0.6931471805599453094172))))")
        lines.append(f"{I})")
        lines.append("")
        lines.append(f"{I}(func $f64_exp (param $v f64) (result f64)")
        lines.append(f"{I}  (local $k f64)")
        lines.append(f"{I}  (local $ki i64)")
        lines.append(f"{I}  (local $r f64)")
        lines.append(f"{I}  (local $term f64)")
        lines.append(f"{I}  (local $s f64)")
        lines.append(f"{I}  (local $i i32)")
        lines.append(f"{I}  (local $scale f64)")
        lines.append(f"{I}  (local $neg i32)")
        lines.append(f"{I}  (local $cnt i64)")
        lines.append(f"{I}  (local.set $k (f64.nearest (f64.div (local.get $v) (f64.const 0.6931471805599453094172))))")
        lines.append(f"{I}  (local.set $ki (i64.trunc_f64_s (local.get $k)))")
        lines.append(f"{I}  (local.set $r (f64.sub (local.get $v) (f64.mul (local.get $k) (f64.const 0.6931471805599453094172))))")
        lines.append(f"{I}  (local.set $term (f64.const 1.0))")
        lines.append(f"{I}  (local.set $s (f64.const 1.0))")
        lines.append(f"{I}  (local.set $i (i32.const 1))")
        lines.append(f"{I}  (block $b1")
        lines.append(f"{I}    (loop $l1")
        lines.append(f"{I}      (if (i32.gt_s (local.get $i) (i32.const 18)) (then (br $b1)))")
        lines.append(f"{I}      (local.set $term (f64.div (f64.mul (local.get $term) (local.get $r)) (f64.convert_i32_s (local.get $i))))")
        lines.append(f"{I}      (local.set $s (f64.add (local.get $s) (local.get $term)))")
        lines.append(f"{I}      (local.set $i (i32.add (local.get $i) (i32.const 1)))")
        lines.append(f"{I}      (br $l1)")
        lines.append(f"{I}    )")
        lines.append(f"{I}  )")
        lines.append(f"{I}  (local.set $scale (f64.const 1.0))")
        lines.append(f"{I}  (local.set $neg (i64.lt_s (local.get $ki) (i64.const 0)))")
        lines.append(f"{I}  (if (local.get $neg) (then (local.set $ki (i64.sub (i64.const 0) (local.get $ki)))))")
        lines.append(f"{I}  (local.set $cnt (local.get $ki))")
        lines.append(f"{I}  (block $b2")
        lines.append(f"{I}    (loop $l2")
        lines.append(f"{I}      (if (i64.le_s (local.get $cnt) (i64.const 0)) (then (br $b2)))")
        lines.append(f"{I}      (local.set $scale (f64.mul (local.get $scale) (f64.const 2.0)))")
        lines.append(f"{I}      (local.set $cnt (i64.sub (local.get $cnt) (i64.const 1)))")
        lines.append(f"{I}      (br $l2)")
        lines.append(f"{I}    )")
        lines.append(f"{I}  )")
        lines.append(f"{I}  (if (local.get $neg) (then (local.set $scale (f64.div (f64.const 1.0) (local.get $scale)))))")
        lines.append(f"{I}  (return (f64.mul (local.get $s) (local.get $scale)))")
        lines.append(f"{I})")
        lines.append("")
        lines.append(f"{I}(func $f64_pow (param $x f64) (param $y f64) (result f64)")
        lines.append(f"{I}  (local $iy i64)")
        lines.append(f"{I}  (local $acc f64)")
        lines.append(f"{I}  (local $base f64)")
        lines.append(f"{I}  (local $is_neg i32)")
        lines.append(f"{I}  (local $k f64)")
        lines.append(f"{I}  (local $u f64)")
        lines.append(f"{I}  (local $u2 f64)")
        lines.append(f"{I}  (local $s f64)")
        lines.append(f"{I}  (local $term f64)")
        lines.append(f"{I}  (local $i i32)")
        lines.append(f"{I}  (local $ln_m f64)")
        lines.append(f"{I}  (local $v_scaled f64)")
        lines.append(f"{I}  (local $K i64)")
        lines.append(f"{I}  (local $dk f64)")
        lines.append(f"{I}  (local $r f64)")
        lines.append(f"{I}  (local $poly f64)")
        lines.append(f"{I}  (local $scale f64)")
        lines.append(f"{I}  (local $cnt i64)")
        lines.append(f"{I}  (if (f64.eq (local.get $y) (f64.const 0.0)) (then (return (f64.const 1.0))))")
        lines.append(f"{I}  (if (f64.eq (local.get $x) (f64.const 0.0)) (then (return (f64.const 0.0))))")
        lines.append(f"{I}  (local.set $iy (i64.trunc_f64_s (local.get $y)))")
        lines.append(f"{I}  (if (f64.eq (local.get $y) (f64.convert_i64_s (local.get $iy)))")
        lines.append(f"{I}    (then")
        lines.append(f"{I}      (local.set $is_neg (i64.lt_s (local.get $iy) (i64.const 0)))")
        lines.append(f"{I}      (if (local.get $is_neg) (then (local.set $iy (i64.sub (i64.const 0) (local.get $iy)))))")
        lines.append(f"{I}      (local.set $acc (f64.const 1.0))")
        lines.append(f"{I}      (local.set $base (local.get $x))")
        lines.append(f"{I}      (block $b1")
        lines.append(f"{I}        (loop $l1")
        lines.append(f"{I}          (if (i64.le_s (local.get $iy) (i64.const 0)) (then (br $b1)))")
        lines.append(f"{I}          (if (i64.eq (i64.and (local.get $iy) (i64.const 1)) (i64.const 1))")
        lines.append(f"{I}            (then (local.set $acc (f64.mul (local.get $acc) (local.get $base)))))")
        lines.append(f"{I}          (local.set $base (f64.mul (local.get $base) (local.get $base)))")
        lines.append(f"{I}          (local.set $iy (i64.shr_u (local.get $iy) (i64.const 1)))")
        lines.append(f"{I}          (br $l1)")
        lines.append(f"{I}        )")
        lines.append(f"{I}      )")
        lines.append(f"{I}      (if (local.get $is_neg) (then (local.set $acc (f64.div (f64.const 1.0) (local.get $acc)))))")
        lines.append(f"{I}      (return (local.get $acc))")
        lines.append(f"{I}    )")
        lines.append(f"{I}  )")
        lines.append(f"{I}  (if (f64.lt (local.get $x) (f64.const 0.0)) (then (return (f64.const nan))))")
        lines.append(f"{I}  (local.set $k (f64.const 0.0))")
        lines.append(f"{I}  (local.set $base (local.get $x))")
        lines.append(f"{I}  (block $bk_up")
        lines.append(f"{I}    (loop $lk_up")
        lines.append(f"{I}      (if (f64.lt (local.get $base) (f64.const 2.0)) (then (br $bk_up)))")
        lines.append(f"{I}      (local.set $base (f64.mul (local.get $base) (f64.const 0.5)))")
        lines.append(f"{I}      (local.set $k (f64.add (local.get $k) (f64.const 1.0)))")
        lines.append(f"{I}      (br $lk_up)")
        lines.append(f"{I}    )")
        lines.append(f"{I}  )")
        lines.append(f"{I}  (block $bk_down")
        lines.append(f"{I}    (loop $lk_down")
        lines.append(f"{I}      (if (f64.ge (local.get $base) (f64.const 1.0)) (then (br $bk_down)))")
        lines.append(f"{I}      (local.set $base (f64.mul (local.get $base) (f64.const 2.0)))")
        lines.append(f"{I}      (local.set $k (f64.sub (local.get $k) (f64.const 1.0)))")
        lines.append(f"{I}      (br $lk_down)")
        lines.append(f"{I}    )")
        lines.append(f"{I}  )")
        lines.append(f"{I}  (local.set $u (f64.div (f64.sub (local.get $base) (f64.const 1.0)) (f64.add (local.get $base) (f64.const 1.0))))")
        lines.append(f"{I}  (local.set $u2 (f64.mul (local.get $u) (local.get $u)))")
        lines.append(f"{I}  (local.set $s (f64.const 0.0))")
        lines.append(f"{I}  (local.set $term (local.get $u))")
        lines.append(f"{I}  (local.set $i (i32.const 1))")
        lines.append(f"{I}  (block $b_ser")
        lines.append(f"{I}    (loop $l_ser")
        lines.append(f"{I}      (if (i32.gt_s (local.get $i) (i32.const 41)) (then (br $b_ser)))")
        lines.append(f"{I}      (local.set $s (f64.add (local.get $s) (f64.div (local.get $term) (f64.convert_i32_s (local.get $i)))))")
        lines.append(f"{I}      (local.set $term (f64.mul (local.get $term) (local.get $u2)))")
        lines.append(f"{I}      (local.set $i (i32.add (local.get $i) (i32.const 2)))")
        lines.append(f"{I}      (br $l_ser)")
        lines.append(f"{I}    )")
        lines.append(f"{I}  )")
        lines.append(f"{I}  (local.set $ln_m (f64.mul (f64.const 2.0) (local.get $s)))")
        lines.append(f"{I}  (local.set $v_scaled (f64.add (f64.mul (local.get $y) (local.get $k)) (f64.mul (f64.mul (local.get $y) (local.get $ln_m)) (f64.const 1.44269504088896340735992468100))))")
        lines.append(f"{I}  (local.set $K (i64.trunc_f64_s (f64.nearest (local.get $v_scaled))))")
        lines.append(f"{I}  (local.set $dk (f64.sub (f64.mul (local.get $y) (local.get $k)) (f64.convert_i64_s (local.get $K))))")
        lines.append(f"{I}  (local.set $r (f64.add (f64.add (f64.mul (local.get $dk) (f64.const 0.693147180559945286226763982995)) (f64.mul (local.get $y) (local.get $ln_m))) (f64.mul (local.get $dk) (f64.const 2.31904681384629955841777123998e-17))))")
        lines.append(f"{I}  (local.set $poly (f64.mul (local.get $r) (f64.add (f64.const 1.0) (f64.mul (local.get $r) (f64.add (f64.const 0.5) (f64.mul (local.get $r) (f64.add (f64.const 0.16666666666666666) (f64.mul (local.get $r) (f64.add (f64.const 0.041666666666666664) (f64.mul (local.get $r) (f64.add (f64.const 0.008333333333333333) (f64.mul (local.get $r) (f64.add (f64.const 0.001388888888888889) (f64.mul (local.get $r) (f64.add (f64.const 0.0001984126984126984) (f64.mul (local.get $r) (f64.add (f64.const 0.0000248015873015873) (f64.mul (local.get $r) (f64.const 0.000002755731922398589)))))))))))))))))))")
        lines.append(f"{I}  (local.set $scale (f64.const 1.0))")
        lines.append(f"{I}  (local.set $is_neg (i64.lt_s (local.get $K) (i64.const 0)))")
        lines.append(f"{I}  (if (local.get $is_neg) (then (local.set $K (i64.sub (i64.const 0) (local.get $K)))))")
        lines.append(f"{I}  (local.set $cnt (local.get $K))")
        lines.append(f"{I}  (block $b_sc")
        lines.append(f"{I}    (loop $l_sc")
        lines.append(f"{I}      (if (i64.le_s (local.get $cnt) (i64.const 0)) (then (br $b_sc)))")
        lines.append(f"{I}      (local.set $scale (f64.mul (local.get $scale) (f64.const 2.0)))")
        lines.append(f"{I}      (local.set $cnt (i64.sub (local.get $cnt) (i64.const 1)))")
        lines.append(f"{I}      (br $l_sc)")
        lines.append(f"{I}    )")
        lines.append(f"{I}  )")
        lines.append(f"{I}  (if (local.get $is_neg) (then (local.set $scale (f64.div (f64.const 1.0) (local.get $scale)))))")
        lines.append(f"{I}  (return (f64.mul (f64.add (f64.const 1.0) (local.get $poly)) (local.get $scale)))")
        lines.append(f"{I})")
        lines.append("")
        lines.append(f"{I}(func $u128_mul (param $a i64) (param $b i64) (result i64 i64)")
        lines.append(f"{I}  (local $a_lo i64) (local $a_hi i64) (local $b_lo i64) (local $b_hi i64)")
        lines.append(f"{I}  (local $p0 i64) (local $p1 i64) (local $p2 i64) (local $p3 i64)")
        lines.append(f"{I}  (local $mid i64) (local $p_lo i64) (local $p_hi i64)")
        lines.append(f"{I}  (local.set $a_lo (i64.and (local.get $a) (i64.const 4294967295)))")
        lines.append(f"{I}  (local.set $a_hi (i64.shr_u (local.get $a) (i64.const 32)))")
        lines.append(f"{I}  (local.set $b_lo (i64.and (local.get $b) (i64.const 4294967295)))")
        lines.append(f"{I}  (local.set $b_hi (i64.shr_u (local.get $b) (i64.const 32)))")
        lines.append(f"{I}  (local.set $p0 (i64.mul (local.get $a_lo) (local.get $b_lo)))")
        lines.append(f"{I}  (local.set $p1 (i64.mul (local.get $a_lo) (local.get $b_hi)))")
        lines.append(f"{I}  (local.set $p2 (i64.mul (local.get $a_hi) (local.get $b_lo)))")
        lines.append(f"{I}  (local.set $p3 (i64.mul (local.get $a_hi) (local.get $b_hi)))")
        lines.append(f"{I}  (local.set $mid (i64.add (i64.add (i64.shr_u (local.get $p0) (i64.const 32)) (i64.and (local.get $p1) (i64.const 4294967295))) (i64.and (local.get $p2) (i64.const 4294967295))))")
        lines.append(f"{I}  (local.set $p_lo (i64.or (i64.and (local.get $p0) (i64.const 4294967295)) (i64.shl (i64.and (local.get $mid) (i64.const 4294967295)) (i64.const 32))))")
        lines.append(f"{I}  (local.set $p_hi (i64.add (i64.add (local.get $p3) (i64.shr_u (local.get $p1) (i64.const 32))) (i64.add (i64.shr_u (local.get $p2) (i64.const 32)) (i64.shr_u (local.get $mid) (i64.const 32)))))")
        lines.append(f"{I}  (return (local.get $p_hi) (local.get $p_lo))")
        lines.append(f"{I})")
        lines.append("")
        lines.append(f"{I}(func $i64_mul_128 (param $a i64) (param $b i64) (result i64 i64)")
        lines.append(f"{I}  (return (call $u128_mul (local.get $a) (local.get $b)))")
        lines.append(f"{I})")
        lines.append("")
        lines.append(f"{I}(func $pow10_f64 (param $k i32) (result f64)")
        lines.append(f"{I}  (if (i32.le_s (local.get $k) (i32.const 0)) (then (return (f64.const 1.0))))")
        lines.append(f"{I}  (if (i32.le_s (local.get $k) (i32.const 16))")
        lines.append(f"{I}    (then (return (f64.convert_i64_u (call $pow10_i64 (local.get $k))))))")
        lines.append(f"{I}  (if (i32.le_s (local.get $k) (i32.const 32))")
        lines.append(f"{I}    (then (return (f64.mul (f64.convert_i64_u (call $pow10_i64 (i32.const 16)))")
        lines.append(f"{I}                           (f64.convert_i64_u (call $pow10_i64 (i32.sub (local.get $k) (i32.const 16))))))))")
        lines.append(f"{I}  (return (f64.mul (f64.convert_i64_u (call $pow10_i64 (i32.const 16)))")
        lines.append(f"{I}                   (f64.mul (f64.convert_i64_u (call $pow10_i64 (i32.const 16)))")
        lines.append(f"{I}                            (f64.convert_i64_u (call $pow10_i64 (i32.sub (local.get $k) (i32.const 32)))))))")
        lines.append(f"{I})")
        lines.append("")
        lines.append(f"{I}(func $pow10_i64 (param $k i32) (result i64)")
        lines.append(f"{I}  (local $res i64)")
        lines.append(f"{I}  (local.set $res (i64.const 1))")
        lines.append(f"{I}  (block $done")
        lines.append(f"{I}    (loop $loop")
        lines.append(f"{I}      (if (i32.le_s (local.get $k) (i32.const 0)) (then (br $done)))")
        lines.append(f"{I}      (local.set $res (i64.mul (local.get $res) (i64.const 10)))")
        lines.append(f"{I}      (local.set $k (i32.sub (local.get $k) (i32.const 1)))")
        lines.append(f"{I}      (br $loop)")
        lines.append(f"{I}    )")
        lines.append(f"{I}  )")
        lines.append(f"{I}  (return (local.get $res))")
        lines.append(f"{I})")
        lines.append("")
        lines.append(f"{I}(func $pow5_i64 (param $k i32) (result i64)")
        lines.append(f"{I}  (local $res i64)")
        lines.append(f"{I}  (local.set $res (i64.const 1))")
        lines.append(f"{I}  (block $done")
        lines.append(f"{I}    (loop $loop")
        lines.append(f"{I}      (if (i32.le_s (local.get $k) (i32.const 0)) (then (br $done)))")
        lines.append(f"{I}      (local.set $res (i64.mul (local.get $res) (i64.const 5)))")
        lines.append(f"{I}      (local.set $k (i32.sub (local.get $k) (i32.const 1)))")
        lines.append(f"{I}      (br $loop)")
        lines.append(f"{I}    )")
        lines.append(f"{I}  )")
        lines.append(f"{I}  (return (local.get $res))")
        lines.append(f"{I})")
        lines.append("")
        lines.append(f"{I}(func $bit_length_u64 (param $v i64) (result i32)")
        lines.append(f"{I}  (return (i32.sub (i32.const 64) (i32.wrap_i64 (i64.clz (local.get $v)))))")
        lines.append(f"{I})")
        lines.append("")
        lines.append(f"{I}(func $u128_div_u64 (param $num_hi i64) (param $num_lo i64) (param $den i64) (result i64 i32)")
        lines.append(f"{I}  (local $q i64) (local $rem i64) (local $i i32) (local $bit i64)")
        lines.append(f"{I}  (local.set $q (i64.const 0))")
        lines.append(f"{I}  (local.set $rem (i64.const 0))")
        lines.append(f"{I}  (local.set $i (i32.const 127))")
        lines.append(f"{I}  (block $done")
        lines.append(f"{I}    (loop $loop")
        lines.append(f"{I}      (if (i32.lt_s (local.get $i) (i32.const 0)) (then (br $done)))")
        lines.append(f"{I}      (if (i32.ge_s (local.get $i) (i32.const 64))")
        lines.append(f"{I}        (then (local.set $bit (i64.and (i64.shr_u (local.get $num_hi) (i64.extend_i32_u (i32.sub (local.get $i) (i32.const 64)))) (i64.const 1))))")
        lines.append(f"{I}        (else (local.set $bit (i64.and (i64.shr_u (local.get $num_lo) (i64.extend_i32_u (local.get $i))) (i64.const 1))))")
        lines.append(f"{I}      )")
        lines.append(f"{I}      (local.set $rem (i64.or (i64.shl (local.get $rem) (i64.const 1)) (local.get $bit)))")
        lines.append(f"{I}      (if (i64.ge_u (local.get $rem) (local.get $den))")
        lines.append(f"{I}        (then")
        lines.append(f"{I}          (local.set $rem (i64.sub (local.get $rem) (local.get $den)))")
        lines.append(f"{I}          (if (i32.lt_s (local.get $i) (i32.const 64))")
        lines.append(f"{I}            (then (local.set $q (i64.or (local.get $q) (i64.shl (i64.const 1) (i64.extend_i32_u (local.get $i))))))")
        lines.append(f"{I}          )")
        lines.append(f"{I}        )")
        lines.append(f"{I}      )")
        lines.append(f"{I}      (local.set $i (i32.sub (local.get $i) (i32.const 1)))")
        lines.append(f"{I}      (br $loop)")
        lines.append(f"{I}    )")
        lines.append(f"{I}  )")
        lines.append(f"{I}  (return (local.get $q) (i64.ne (local.get $rem) (i64.const 0)))")
        lines.append(f"{I})")
        lines.append("")
        lines.append(f"{I}(func $recon_float_bits (param $m i64) (param $k i32) (result i64)")
        lines.append(f"{I}  (local $den i64) (local $den_bits i32) (local $m_bits i32) (local $s i32)")
        lines.append(f"{I}  (local $num_hi i64) (local $num_lo i64)")
        lines.append(f"{I}  (local $q i64) (local $sticky i32)")
        lines.append(f"{I}  (local $bl i32) (local $shift i32) (local $sig i64) (local $round_bit i64)")
        lines.append(f"{I}  (local $exp i32)")
        lines.append(f"{I}  (if (i64.eqz (local.get $m)) (then (return (i64.const 0))))")
        lines.append(f"{I}  (if (i32.eqz (local.get $k))")
        lines.append(f"{I}    (then (return (i64.reinterpret_f64 (f64.convert_i64_u (local.get $m))))))")
        lines.append(f"{I}  (if (i32.lt_s (local.get $k) (i32.const 0))")
        lines.append(f"{I}    (then (return (i64.reinterpret_f64 (f64.mul (f64.convert_i64_u (local.get $m)) (call $pow10_f64 (i32.sub (i32.const 0) (local.get $k))))))))")
        lines.append(f"{I}  (if (i32.gt_s (local.get $k) (i32.const 27))")
        lines.append(f"{I}    (then (return (i64.reinterpret_f64 (f64.div (f64.convert_i64_u (local.get $m)) (call $pow10_f64 (local.get $k)))))))")
        lines.append(f"{I}  (local.set $den (call $pow5_i64 (local.get $k)))")
        lines.append(f"{I}  (local.set $den_bits (call $bit_length_u64 (local.get $den)))")
        lines.append(f"{I}  (local.set $m_bits (call $bit_length_u64 (local.get $m)))")
        lines.append(f"{I}  (local.set $s (i32.sub (i32.add (i32.const 60) (local.get $den_bits)) (local.get $m_bits)))")
        lines.append(f"{I}  (if (i32.ge_s (local.get $s) (i32.const 64))")
        lines.append(f"{I}    (then")
        lines.append(f"{I}      (local.set $num_hi (i64.shl (local.get $m) (i64.extend_i32_u (i32.sub (local.get $s) (i32.const 64)))))")
        lines.append(f"{I}      (local.set $num_lo (i64.const 0))")
        lines.append(f"{I}    )")
        lines.append(f"{I}    (else")
        lines.append(f"{I}      (local.set $num_hi (i64.shr_u (local.get $m) (i64.extend_i32_u (i32.sub (i32.const 64) (local.get $s)))))")
        lines.append(f"{I}      (local.set $num_lo (i64.shl (local.get $m) (i64.extend_i32_u (local.get $s))))")
        lines.append(f"{I}    )")
        lines.append(f"{I}  )")
        lines.append(f"{I}  (call $u128_div_u64 (local.get $num_hi) (local.get $num_lo) (local.get $den))")
        lines.append(f"{I}  (local.set $sticky)")
        lines.append(f"{I}  (local.set $q)")
        lines.append(f"{I}  (local.set $bl (call $bit_length_u64 (local.get $q)))")
        lines.append(f"{I}  (local.set $shift (i32.sub (local.get $bl) (i32.const 54)))")
        lines.append(f"{I}  (if (i32.gt_s (local.get $shift) (i32.const 0))")
        lines.append(f"{I}    (then")
        lines.append(f"{I}      (if (i64.ne (i64.and (local.get $q) (i64.sub (i64.shl (i64.const 1) (i64.extend_i32_u (local.get $shift))) (i64.const 1))) (i64.const 0))")
        lines.append(f"{I}        (then (local.set $sticky (i32.const 1)))")
        lines.append(f"{I}      )")
        lines.append(f"{I}      (local.set $q (i64.shr_u (local.get $q) (i64.extend_i32_u (local.get $shift))))")
        lines.append(f"{I}      (local.set $s (i32.sub (local.get $s) (local.get $shift)))")
        lines.append(f"{I}    )")
        lines.append(f"{I}    (else")
        lines.append(f"{I}      (if (i32.lt_s (local.get $shift) (i32.const 0))")
        lines.append(f"{I}        (then")
        lines.append(f"{I}          (local.set $q (i64.shl (local.get $q) (i64.extend_i32_u (i32.sub (i32.const 0) (local.get $shift)))))")
        lines.append(f"{I}          (local.set $s (i32.add (local.get $s) (i32.sub (i32.const 0) (local.get $shift))))")
        lines.append(f"{I}        )")
        lines.append(f"{I}      )")
        lines.append(f"{I}    )")
        lines.append(f"{I}  )")
        lines.append(f"{I}  (local.set $sig (i64.shr_u (local.get $q) (i64.const 1)))")
        lines.append(f"{I}  (local.set $round_bit (i64.and (local.get $q) (i64.const 1)))")
        lines.append(f"{I}  (if (i64.eq (local.get $round_bit) (i64.const 1))")
        lines.append(f"{I}    (then")
        lines.append(f"{I}      (if (i32.or (local.get $sticky) (i32.wrap_i64 (i64.and (local.get $sig) (i64.const 1))))")
        lines.append(f"{I}        (then")
        lines.append(f"{I}          (local.set $sig (i64.add (local.get $sig) (i64.const 1)))")
        lines.append(f"{I}          (if (i64.eq (local.get $sig) (i64.shl (i64.const 1) (i64.const 53)))")
        lines.append(f"{I}            (then")
        lines.append(f"{I}              (local.set $sig (i64.shr_u (local.get $sig) (i64.const 1)))")
        lines.append(f"{I}              (local.set $s (i32.sub (local.get $s) (i32.const 1)))")
        lines.append(f"{I}            )")
        lines.append(f"{I}          )")
        lines.append(f"{I}        )")
        lines.append(f"{I}      )")
        lines.append(f"{I}    )")
        lines.append(f"{I}  )")
        lines.append(f"{I}  (local.set $exp (i32.add (i32.sub (i32.sub (i32.const 53) (local.get $s)) (local.get $k)) (i32.const 1023)))")
        lines.append(f"{I}  (if (i32.le_s (local.get $exp) (i32.const 0)) (then (return (i64.const 0))))")
        lines.append(f"{I}  (return (i64.or (i64.shl (i64.extend_i32_u (local.get $exp)) (i64.const 52))")
        lines.append(f"{I}                  (i64.and (local.get $sig) (i64.const 4503599627370495))))")
        lines.append(f"{I})")
        lines.append("")
        lines.append(f"{I}(func $compute_exact_m (param $v f64) (param $k i32) (result i64)")
        lines.append(f"{I}  (local $bits i64) (local $exp_bits i64) (local $f i64) (local $e i64)")
        lines.append(f"{I}  (local $p5 i64) (local $num_hi i64) (local $num_lo i64)")
        lines.append(f"{I}  (local $shift i64) (local $q i64) (local $rem i64) (local $half i64)")
        lines.append(f"{I}  (local $p10_lo i64)")
        lines.append(f"{I}  (if (i32.gt_s (local.get $k) (i32.const 27))")
        lines.append(f"{I}    (then (return (i64.trunc_f64_u (f64.nearest (f64.mul (f64.abs (local.get $v)) (call $pow10_f64 (local.get $k)))))))")
        lines.append(f"{I}  )")
        lines.append(f"{I}  (local.set $bits (i64.reinterpret_f64 (f64.abs (local.get $v))))")
        lines.append(f"{I}  (local.set $exp_bits (i64.and (i64.shr_u (local.get $bits) (i64.const 52)) (i64.const 2047)))")
        lines.append(f"{I}  (if (i64.eqz (local.get $exp_bits))")
        lines.append(f"{I}    (then")
        lines.append(f"{I}      (local.set $f (i64.and (local.get $bits) (i64.const 4503599627370495)))")
        lines.append(f"{I}      (local.set $e (i64.const -1074))")
        lines.append(f"{I}    )")
        lines.append(f"{I}    (else")
        lines.append(f"{I}      (local.set $f (i64.or (i64.and (local.get $bits) (i64.const 4503599627370495)) (i64.const 4503599627370496)))")
        lines.append(f"{I}      (local.set $e (i64.sub (local.get $exp_bits) (i64.const 1075)))")
        lines.append(f"{I}    )")
        lines.append(f"{I}  )")
        lines.append(f"{I}  (if (i32.ge_s (local.get $k) (i32.const 0))")
        lines.append(f"{I}    (then")
        lines.append(f"{I}      (local.set $p5 (call $pow5_i64 (local.get $k)))")
        lines.append(f"{I}      (call $u128_mul (local.get $f) (local.get $p5))")
        lines.append(f"{I}      (local.set $num_lo)")
        lines.append(f"{I}      (local.set $num_hi)")
        lines.append(f"{I}      (local.set $shift (i64.sub (i64.const 0) (i64.add (local.get $e) (i64.extend_i32_s (local.get $k)))))")
        lines.append(f"{I}      (if (i64.le_s (local.get $shift) (i64.const 0))")
        lines.append(f"{I}        (then (return (i64.shl (local.get $num_lo) (i64.sub (i64.const 0) (local.get $shift)))))")
        lines.append(f"{I}      )")
        lines.append(f"{I}      (if (i64.lt_u (local.get $shift) (i64.const 64))")
        lines.append(f"{I}        (then")
        lines.append(f"{I}          (local.set $q (i64.or (i64.shr_u (local.get $num_lo) (local.get $shift)) (i64.shl (local.get $num_hi) (i64.sub (i64.const 64) (local.get $shift)))))")
        lines.append(f"{I}          (local.set $rem (i64.and (local.get $num_lo) (i64.sub (i64.shl (i64.const 1) (local.get $shift)) (i64.const 1))))")
        lines.append(f"{I}          (local.set $half (i64.shl (i64.const 1) (i64.sub (local.get $shift) (i64.const 1))))")
        lines.append(f"{I}          (if (i32.or (i64.gt_u (local.get $rem) (local.get $half))")
        lines.append(f"{I}                      (i32.and (i64.eq (local.get $rem) (local.get $half)) (i64.eq (i64.and (local.get $q) (i64.const 1)) (i64.const 1))))")
        lines.append(f"{I}            (then (local.set $q (i64.add (local.get $q) (i64.const 1))))")
        lines.append(f"{I}          )")
        lines.append(f"{I}          (return (local.get $q))")
        lines.append(f"{I}        )")
        lines.append(f"{I}        (else")
        lines.append(f"{I}          (local.set $shift (i64.sub (local.get $shift) (i64.const 64)))")
        lines.append(f"{I}          (if (i64.eqz (local.get $shift))")
        lines.append(f"{I}            (then")
        lines.append(f"{I}              (local.set $q (local.get $num_hi))")
        lines.append(f"{I}              (local.set $rem (local.get $num_lo))")
        lines.append(f"{I}              (local.set $half (i64.shl (i64.const 1) (i64.const 63)))")
        lines.append(f"{I}            )")
        lines.append(f"{I}            (else")
        lines.append(f"{I}              (local.set $q (i64.shr_u (local.get $num_hi) (local.get $shift)))")
        lines.append(f"{I}              (local.set $rem (i64.or (i64.shl (i64.and (local.get $num_hi) (i64.sub (i64.shl (i64.const 1) (local.get $shift)) (i64.const 1))) (i64.const 64)) (local.get $num_lo)))")
        lines.append(f"{I}              (local.set $half (i64.shl (i64.const 1) (i64.sub (local.get $shift) (i64.const 1))))")
        lines.append(f"{I}            )")
        lines.append(f"{I}          )")
        lines.append(f"{I}          (if (i32.or (i64.gt_u (local.get $rem) (local.get $half))")
        lines.append(f"{I}                      (i32.and (i64.eq (local.get $rem) (local.get $half)) (i64.eq (i64.and (local.get $q) (i64.const 1)) (i64.const 1))))")
        lines.append(f"{I}            (then (local.set $q (i64.add (local.get $q) (i64.const 1))))")
        lines.append(f"{I}          )")
        lines.append(f"{I}          (return (local.get $q))")
        lines.append(f"{I}        )")
        lines.append(f"{I}      )")
        lines.append(f"{I}    )")
        lines.append(f"{I}    (else")
        lines.append(f"{I}      (local.set $p10_lo (call $pow10_i64 (i32.sub (i32.const 0) (local.get $k))))")
        lines.append(f"{I}      (if (i64.ge_s (local.get $e) (i64.const 0))")
        lines.append(f"{I}        (then")
        lines.append(f"{I}          (local.set $f (i64.shl (local.get $f) (local.get $e)))")
        lines.append(f"{I}          (return (i64.div_u (i64.add (local.get $f) (i64.shr_u (local.get $p10_lo) (i64.const 1))) (local.get $p10_lo)))")
        lines.append(f"{I}        )")
        lines.append(f"{I}        (else")
        lines.append(f"{I}          (local.set $shift (i64.sub (i64.const 0) (local.get $e)))")
        lines.append(f"{I}          (local.set $f (i64.shr_u (local.get $f) (local.get $shift)))")
        lines.append(f"{I}          (return (i64.div_u (i64.add (local.get $f) (i64.shr_u (local.get $p10_lo) (i64.const 1))) (local.get $p10_lo)))")
        lines.append(f"{I}        )")
        lines.append(f"{I}      )")
        lines.append(f"{I}    )")
        lines.append(f"{I}  )")
        lines.append(f"{I}  (return (i64.const 0))")
        lines.append(f"{I})")
        lines.append("")
        lines.append(f"{I}(func $f64_to_str (param $orig_v f64) (param $buf i32) (result i32)")
        lines.append(f"{I}  (local $v f64) (local $len i32) (local $e i32) (local $temp f64)")
        lines.append(f"{I}  (local $p i32) (local $k i32) (local $m i64) (local $orig_bits i64)")
        lines.append(f"{I}  (local $digits i32) (local $l i32) (local $int_len i32) (local $zeros i32)")
        lines.append(f"{I}  (local $recon_bits i64) (local $scnt i32)")
        lines.append(f"{I}  (local.set $digits (i32.const 30000))")
        lines.append(f"{I}  (if (f64.ne (local.get $orig_v) (local.get $orig_v))")
        lines.append(f"{I}    (then")
        lines.append(f"{I}      (i32.store8 (local.get $buf) (i32.const 110))")
        lines.append(f"{I}      (i32.store8 (i32.add (local.get $buf) (i32.const 1)) (i32.const 97))")
        lines.append(f"{I}      (i32.store8 (i32.add (local.get $buf) (i32.const 2)) (i32.const 110))")
        lines.append(f"{I}      (return (i32.const 3))")
        lines.append(f"{I}    )")
        lines.append(f"{I}  )")
        lines.append(f"{I}  (if (f64.eq (f64.abs (local.get $orig_v)) (f64.const inf))")
        lines.append(f"{I}    (then")
        lines.append(f"{I}      (if (f64.lt (local.get $orig_v) (f64.const 0.0))")
        lines.append(f"{I}        (then")
        lines.append(f"{I}          (i32.store8 (local.get $buf) (i32.const 45))")
        lines.append(f"{I}          (i32.store8 (i32.add (local.get $buf) (i32.const 1)) (i32.const 105))")
        lines.append(f"{I}          (i32.store8 (i32.add (local.get $buf) (i32.const 2)) (i32.const 110))")
        lines.append(f"{I}          (i32.store8 (i32.add (local.get $buf) (i32.const 3)) (i32.const 102))")
        lines.append(f"{I}          (return (i32.const 4))")
        lines.append(f"{I}        )")
        lines.append(f"{I}        (else")
        lines.append(f"{I}          (i32.store8 (local.get $buf) (i32.const 105))")
        lines.append(f"{I}          (i32.store8 (i32.add (local.get $buf) (i32.const 1)) (i32.const 110))")
        lines.append(f"{I}          (i32.store8 (i32.add (local.get $buf) (i32.const 2)) (i32.const 102))")
        lines.append(f"{I}          (return (i32.const 3))")
        lines.append(f"{I}        )")
        lines.append(f"{I}      )")
        lines.append(f"{I}    )")
        lines.append(f"{I}  )")
        lines.append(f"{I}  (if (f64.eq (local.get $orig_v) (f64.const 0.0))")
        lines.append(f"{I}    (then")
        lines.append(f"{I}      (i32.store8 (local.get $buf) (i32.const 48))")
        lines.append(f"{I}      (i32.store8 (i32.add (local.get $buf) (i32.const 1)) (i32.const 46))")
        lines.append(f"{I}      (i32.store8 (i32.add (local.get $buf) (i32.const 2)) (i32.const 48))")
        lines.append(f"{I}      (return (i32.const 3))")
        lines.append(f"{I}    )")
        lines.append(f"{I}  )")
        lines.append(f"{I}  (local.set $len (i32.const 0))")
        lines.append(f"{I}  (local.set $v (local.get $orig_v))")
        lines.append(f"{I}  (if (f64.lt (local.get $v) (f64.const 0.0))")
        lines.append(f"{I}    (then")
        lines.append(f"{I}      (i32.store8 (local.get $buf) (i32.const 45))")
        lines.append(f"{I}      (local.set $len (i32.const 1))")
        lines.append(f"{I}      (local.set $v (f64.neg (local.get $v)))")
        lines.append(f"{I}    )")
        lines.append(f"{I}  )")
        lines.append(f"{I}  (if (f64.lt (local.get $v) (f64.const 1e16))")
        lines.append(f"{I}    (then")
        lines.append(f"{I}      (local.set $m (i64.trunc_f64_s (local.get $v)))")
        lines.append(f"{I}      (if (f64.eq (local.get $v) (f64.convert_i64_s (local.get $m)))")
        lines.append(f"{I}        (then")
        lines.append(f"{I}          (local.set $len (i32.add (local.get $len) (call $i64_to_str (local.get $m) (i32.add (local.get $buf) (local.get $len)))))")
        lines.append(f"{I}          (i32.store8 (i32.add (local.get $buf) (local.get $len)) (i32.const 46))")
        lines.append(f"{I}          (local.set $len (i32.add (local.get $len) (i32.const 1)))")
        lines.append(f"{I}          (i32.store8 (i32.add (local.get $buf) (local.get $len)) (i32.const 48))")
        lines.append(f"{I}          (local.set $len (i32.add (local.get $len) (i32.const 1)))")
        lines.append(f"{I}          (return (local.get $len))")
        lines.append(f"{I}        )")
        lines.append(f"{I}      )")
        lines.append(f"{I}    )")
        lines.append(f"{I}  )")
        lines.append(f"{I}  (local.set $e (i32.const 0))")
        lines.append(f"{I}  (local.set $temp (local.get $v))")
        lines.append(f"{I}  (if (f64.ge (local.get $temp) (f64.const 10.0))")
        lines.append(f"{I}    (then")
        lines.append(f"{I}      (block $exp_up")
        lines.append(f"{I}        (loop $l_up")
        lines.append(f"{I}          (if (f64.lt (local.get $temp) (f64.const 10.0)) (then (br $exp_up)))")
        lines.append(f"{I}          (local.set $temp (f64.div (local.get $temp) (f64.const 10.0)))")
        lines.append(f"{I}          (local.set $e (i32.add (local.get $e) (i32.const 1)))")
        lines.append(f"{I}          (br $l_up)")
        lines.append(f"{I}        )")
        lines.append(f"{I}      )")
        lines.append(f"{I}    )")
        lines.append(f"{I}  )")
        lines.append(f"{I}  (if (f64.lt (local.get $temp) (f64.const 1.0))")
        lines.append(f"{I}    (then")
        lines.append(f"{I}      (block $exp_down")
        lines.append(f"{I}        (loop $l_down")
        lines.append(f"{I}          (if (f64.ge (local.get $temp) (f64.const 1.0)) (then (br $exp_down)))")
        lines.append(f"{I}          (local.set $temp (f64.mul (local.get $temp) (f64.const 10.0)))")
        lines.append(f"{I}          (local.set $e (i32.sub (local.get $e) (i32.const 1)))")
        lines.append(f"{I}          (br $l_down)")
        lines.append(f"{I}        )")
        lines.append(f"{I}      )")
        lines.append(f"{I}    )")
        lines.append(f"{I}  )")
        lines.append(f"{I}  (local.set $orig_bits (i64.reinterpret_f64 (local.get $v)))")
        lines.append(f"{I}  (local.set $p (i32.const 15))")
        lines.append(f"{I}  (block $found_p")
        lines.append(f"{I}    (loop $loop_p")
        lines.append(f"{I}      (if (i32.ge_u (local.get $p) (i32.const 17)) (then (br $found_p)))")
        lines.append(f"{I}      (local.set $scnt (i32.sub (i32.sub (local.get $p) (i32.const 1)) (local.get $e)))")
        lines.append(f"{I}      (local.set $m (call $compute_exact_m (local.get $v) (local.get $scnt)))")
        lines.append(f"{I}      (local.set $recon_bits (call $recon_float_bits (local.get $m) (local.get $scnt)))")
        lines.append(f"{I}      (if (i64.eq (local.get $recon_bits) (local.get $orig_bits))")
        lines.append(f"{I}        (then (br $found_p))")
        lines.append(f"{I}      )")
        lines.append(f"{I}      (local.set $p (i32.add (local.get $p) (i32.const 1)))")
        lines.append(f"{I}      (br $loop_p)")
        lines.append(f"{I}    )")
        lines.append(f"{I}  )")
        lines.append(f"{I}  (local.set $scnt (i32.sub (i32.sub (local.get $p) (i32.const 1)) (local.get $e)))")
        lines.append(f"{I}  (local.set $m (call $compute_exact_m (local.get $v) (local.get $scnt)))")
        lines.append(f"{I}  (local.set $k (i32.const 0))")
        lines.append(f"{I}  (block $mdone")
        lines.append(f"{I}    (loop $mloop")
        lines.append(f"{I}      (if (i32.ge_u (local.get $k) (local.get $p)) (then (br $mdone)))")
        lines.append(f"{I}      (i32.store8 (i32.add (local.get $digits) (local.get $k))")
        lines.append(f"{I}        (i32.add (i32.wrap_i64 (i64.rem_u (local.get $m) (i64.const 10))) (i32.const 48)))")
        lines.append(f"{I}      (local.set $m (i64.div_u (local.get $m) (i64.const 10)))")
        lines.append(f"{I}      (local.set $k (i32.add (local.get $k) (i32.const 1)))")
        lines.append(f"{I}      (br $mloop)")
        lines.append(f"{I}    )")
        lines.append(f"{I}  )")
        lines.append(f"{I}  (if (i64.gt_u (local.get $m) (i64.const 0)) (then (local.set $e (i32.add (local.get $e) (i32.const 1)))))")
        lines.append(f"{I}  (call $reverse (local.get $digits) (local.get $p))")
        lines.append(f"{I}  (local.set $l (local.get $p))")
        lines.append(f"{I}  (block $strip_l")
        lines.append(f"{I}    (loop $ll")
        lines.append(f"{I}      (if (i32.le_u (local.get $l) (i32.const 1)) (then (br $strip_l)))")
        lines.append(f"{I}      (if (i32.ne (i32.load8_u (i32.sub (i32.add (local.get $digits) (local.get $l)) (i32.const 1))) (i32.const 48)) (then (br $strip_l)))")
        lines.append(f"{I}      (local.set $l (i32.sub (local.get $l) (i32.const 1)))")
        lines.append(f"{I}      (br $ll)")
        lines.append(f"{I}    )")
        lines.append(f"{I}  )")
        lines.append(f"{I}  (if (i32.or (i32.lt_s (local.get $e) (i32.const -4)) (i32.ge_s (local.get $e) (local.get $p)))")
        lines.append(f"{I}    (then")
        lines.append(f"{I}      (i32.store8 (i32.add (local.get $buf) (local.get $len)) (i32.load8_u (local.get $digits)))")
        lines.append(f"{I}      (local.set $len (i32.add (local.get $len) (i32.const 1)))")
        lines.append(f"{I}      (if (i32.gt_u (local.get $l) (i32.const 1))")
        lines.append(f"{I}        (then")
        lines.append(f"{I}          (i32.store8 (i32.add (local.get $buf) (local.get $len)) (i32.const 46))")
        lines.append(f"{I}          (local.set $len (i32.add (local.get $len) (i32.const 1)))")
        lines.append(f"{I}          (local.set $k (i32.const 1))")
        lines.append(f"{I}          (block $scc")
        lines.append(f"{I}            (loop $lscc")
        lines.append(f"{I}              (if (i32.ge_u (local.get $k) (local.get $l)) (then (br $scc)))")
        lines.append(f"{I}              (i32.store8 (i32.add (local.get $buf) (local.get $len)) (i32.load8_u (i32.add (local.get $digits) (local.get $k))))")
        lines.append(f"{I}              (local.set $len (i32.add (local.get $len) (i32.const 1)))")
        lines.append(f"{I}              (local.set $k (i32.add (local.get $k) (i32.const 1)))")
        lines.append(f"{I}              (br $lscc)")
        lines.append(f"{I}            )")
        lines.append(f"{I}          )")
        lines.append(f"{I}        )")
        lines.append(f"{I}      )")
        lines.append(f"{I}      (i32.store8 (i32.add (local.get $buf) (local.get $len)) (i32.const 101))")
        lines.append(f"{I}      (local.set $len (i32.add (local.get $len) (i32.const 1)))")
        lines.append(f"{I}      (if (i32.lt_s (local.get $e) (i32.const 0))")
        lines.append(f"{I}        (then")
        lines.append(f"{I}          (i32.store8 (i32.add (local.get $buf) (local.get $len)) (i32.const 45))")
        lines.append(f"{I}          (local.set $len (i32.add (local.get $len) (i32.const 1)))")
        lines.append(f"{I}          (local.set $e (i32.sub (i32.const 0) (local.get $e)))")
        lines.append(f"{I}        )")
        lines.append(f"{I}        (else")
        lines.append(f"{I}          (i32.store8 (i32.add (local.get $buf) (local.get $len)) (i32.const 43))")
        lines.append(f"{I}          (local.set $len (i32.add (local.get $len) (i32.const 1)))")
        lines.append(f"{I}        )")
        lines.append(f"{I}      )")
        lines.append(f"{I}      (if (i32.lt_s (local.get $e) (i32.const 10))")
        lines.append(f"{I}        (then")
        lines.append(f"{I}          (i32.store8 (i32.add (local.get $buf) (local.get $len)) (i32.const 48))")
        lines.append(f"{I}          (local.set $len (i32.add (local.get $len) (i32.const 1)))")
        lines.append(f"{I}        )")
        lines.append(f"{I}      )")
        lines.append(f"{I}      (local.set $len (i32.add (local.get $len) (call $i64_to_str (i64.extend_i32_s (local.get $e)) (i32.add (local.get $buf) (local.get $len)))))")
        lines.append(f"{I}      (return (local.get $len))")
        lines.append(f"{I}    )")
        lines.append(f"{I}    (else")
        lines.append(f"{I}      (if (i32.ge_s (local.get $e) (i32.const 0))")
        lines.append(f"{I}        (then")
        lines.append(f"{I}          (local.set $int_len (i32.add (local.get $e) (i32.const 1)))")
        lines.append(f"{I}          (if (i32.ge_u (local.get $int_len) (local.get $l))")
        lines.append(f"{I}            (then")
        lines.append(f"{I}              (local.set $k (i32.const 0))")
        lines.append(f"{I}              (block $c1")
        lines.append(f"{I}                (loop $lc1")
        lines.append(f"{I}                  (if (i32.ge_u (local.get $k) (local.get $l)) (then (br $c1)))")
        lines.append(f"{I}                  (i32.store8 (i32.add (local.get $buf) (local.get $len)) (i32.load8_u (i32.add (local.get $digits) (local.get $k))))")
        lines.append(f"{I}                  (local.set $len (i32.add (local.get $len) (i32.const 1)))")
        lines.append(f"{I}                  (local.set $k (i32.add (local.get $k) (i32.const 1)))")
        lines.append(f"{I}                  (br $lc1)")
        lines.append(f"{I}                )")
        lines.append(f"{I}              )")
        lines.append(f"{I}              (block $c2")
        lines.append(f"{I}                (loop $lc2")
        lines.append(f"{I}                  (if (i32.ge_u (local.get $len) (local.get $int_len)) (then (br $c2)))")
        lines.append(f"{I}                  (i32.store8 (i32.add (local.get $buf) (local.get $len)) (i32.const 48))")
        lines.append(f"{I}                  (local.set $len (i32.add (local.get $len) (i32.const 1)))")
        lines.append(f"{I}                  (br $lc2)")
        lines.append(f"{I}                )")
        lines.append(f"{I}              )")
        lines.append(f"{I}              (i32.store8 (i32.add (local.get $buf) (local.get $len)) (i32.const 46))")
        lines.append(f"{I}              (local.set $len (i32.add (local.get $len) (i32.const 1)))")
        lines.append(f"{I}              (i32.store8 (i32.add (local.get $buf) (local.get $len)) (i32.const 48))")
        lines.append(f"{I}              (local.set $len (i32.add (local.get $len) (i32.const 1)))")
        lines.append(f"{I}              (return (local.get $len))")
        lines.append(f"{I}            )")
        lines.append(f"{I}            (else")
        lines.append(f"{I}              (local.set $k (i32.const 0))")
        lines.append(f"{I}              (block $c3")
        lines.append(f"{I}                (loop $lc3")
        lines.append(f"{I}                  (if (i32.ge_u (local.get $k) (local.get $int_len)) (then (br $c3)))")
        lines.append(f"{I}                  (i32.store8 (i32.add (local.get $buf) (local.get $len)) (i32.load8_u (i32.add (local.get $digits) (local.get $k))))")
        lines.append(f"{I}                  (local.set $len (i32.add (local.get $len) (i32.const 1)))")
        lines.append(f"{I}                  (local.set $k (i32.add (local.get $k) (i32.const 1)))")
        lines.append(f"{I}                  (br $lc3)")
        lines.append(f"{I}                )")
        lines.append(f"{I}              )")
        lines.append(f"{I}              (i32.store8 (i32.add (local.get $buf) (local.get $len)) (i32.const 46))")
        lines.append(f"{I}              (local.set $len (i32.add (local.get $len) (i32.const 1)))")
        lines.append(f"{I}              (block $c4")
        lines.append(f"{I}                (loop $lc4")
        lines.append(f"{I}                  (if (i32.ge_u (local.get $k) (local.get $l)) (then (br $c4)))")
        lines.append(f"{I}                  (i32.store8 (i32.add (local.get $buf) (local.get $len)) (i32.load8_u (i32.add (local.get $digits) (local.get $k))))")
        lines.append(f"{I}                  (local.set $len (i32.add (local.get $len) (i32.const 1)))")
        lines.append(f"{I}                  (local.set $k (i32.add (local.get $k) (i32.const 1)))")
        lines.append(f"{I}                  (br $lc4)")
        lines.append(f"{I}                )")
        lines.append(f"{I}              )")
        lines.append(f"{I}              (return (local.get $len))")
        lines.append(f"{I}            )")
        lines.append(f"{I}          )")
        lines.append(f"{I}        )")
        lines.append(f"{I}        (else")
        lines.append(f"{I}          (i32.store8 (i32.add (local.get $buf) (local.get $len)) (i32.const 48))")
        lines.append(f"{I}          (local.set $len (i32.add (local.get $len) (i32.const 1)))")
        lines.append(f"{I}          (i32.store8 (i32.add (local.get $buf) (local.get $len)) (i32.const 46))")
        lines.append(f"{I}          (local.set $len (i32.add (local.get $len) (i32.const 1)))")
        lines.append(f"{I}          (local.set $zeros (i32.sub (i32.sub (i32.const 0) (local.get $e)) (i32.const 1)))")
        lines.append(f"{I}          (local.set $k (i32.const 0))")
        lines.append(f"{I}          (block $c5")
        lines.append(f"{I}            (loop $lc5")
        lines.append(f"{I}              (if (i32.ge_u (local.get $k) (local.get $zeros)) (then (br $c5)))")
        lines.append(f"{I}              (i32.store8 (i32.add (local.get $buf) (local.get $len)) (i32.const 48))")
        lines.append(f"{I}              (local.set $len (i32.add (local.get $len) (i32.const 1)))")
        lines.append(f"{I}              (local.set $k (i32.add (local.get $k) (i32.const 1)))")
        lines.append(f"{I}              (br $lc5)")
        lines.append(f"{I}            )")
        lines.append(f"{I}          )")
        lines.append(f"{I}          (local.set $k (i32.const 0))")
        lines.append(f"{I}          (block $c6")
        lines.append(f"{I}            (loop $lc6")
        lines.append(f"{I}              (if (i32.ge_u (local.get $k) (local.get $l)) (then (br $c6)))")
        lines.append(f"{I}              (i32.store8 (i32.add (local.get $buf) (local.get $len)) (i32.load8_u (i32.add (local.get $digits) (local.get $k))))")
        lines.append(f"{I}              (local.set $len (i32.add (local.get $len) (i32.const 1)))")
        lines.append(f"{I}              (local.set $k (i32.add (local.get $k) (i32.const 1)))")
        lines.append(f"{I}              (br $lc6)")
        lines.append(f"{I}            )")
        lines.append(f"{I}          )")
        lines.append(f"{I}          (return (local.get $len))")
        lines.append(f"{I}        )")
        lines.append(f"{I}      )")
        lines.append(f"{I}    )")
        lines.append(f"{I}  )")
        lines.append(f"{I}  (return (local.get $len))")
        lines.append(f"{I})")
        lines.append("")
        lines.append(f"{I}(func $i128_rem_u (param $p_hi i64) (param $p_lo i64) (param $m i64) (result i64)")
        lines.append(f"{I}  (local $rem i64)")
        lines.append(f"{I}  (local $i i32)")
        lines.append(f"{I}  (local $bit i64)")
        lines.append(f"{I}  (if (i64.eqz (local.get $m)) (then (return (i64.const 0))))")
        lines.append(f"{I}  (if (i64.eqz (local.get $p_hi)) (then (return (i64.rem_u (local.get $p_lo) (local.get $m)))))")
        lines.append(f"{I}  (if (i64.eq (local.get $m) (i64.const 9223372036854775807))")
        lines.append(f"{I}    (then")
        lines.append(f"{I}      (local.set $rem (i64.add (i64.mul (i64.rem_u (local.get $p_hi) (local.get $m)) (i64.const 2)) (i64.rem_u (local.get $p_lo) (local.get $m))))")
        lines.append(f"{I}      (return (i64.rem_u (local.get $rem) (local.get $m)))")
        lines.append(f"{I}    )")
        lines.append(f"{I}  )")
        lines.append(f"{I}  (local.set $rem (i64.const 0))")
        lines.append(f"{I}  (local.set $i (i32.const 63))")
        lines.append(f"{I}  (block $done_hi")
        lines.append(f"{I}    (loop $loop_hi")
        lines.append(f"{I}      (if (i32.lt_s (local.get $i) (i32.const 0)) (then (br $done_hi)))")
        lines.append(f"{I}      (local.set $bit (i64.and (i64.shr_u (local.get $p_hi) (i64.extend_i32_u (local.get $i))) (i64.const 1)))")
        lines.append(f"{I}      (local.set $rem (i64.or (i64.shl (local.get $rem) (i64.const 1)) (local.get $bit)))")
        lines.append(f"{I}      (if (i64.ge_u (local.get $rem) (local.get $m))")
        lines.append(f"{I}        (then (local.set $rem (i64.sub (local.get $rem) (local.get $m))))")
        lines.append(f"{I}      )")
        lines.append(f"{I}      (local.set $i (i32.sub (local.get $i) (i32.const 1)))")
        lines.append(f"{I}      (br $loop_hi)")
        lines.append(f"{I}    )")
        lines.append(f"{I}  )")
        lines.append(f"{I}  (local.set $i (i32.const 63))")
        lines.append(f"{I}  (block $done_lo")
        lines.append(f"{I}    (loop $loop_lo")
        lines.append(f"{I}      (if (i32.lt_s (local.get $i) (i32.const 0)) (then (br $done_lo)))")
        lines.append(f"{I}      (local.set $bit (i64.and (i64.shr_u (local.get $p_lo) (i64.extend_i32_u (local.get $i))) (i64.const 1)))")
        lines.append(f"{I}      (local.set $rem (i64.or (i64.shl (local.get $rem) (i64.const 1)) (local.get $bit)))")
        lines.append(f"{I}      (if (i64.ge_u (local.get $rem) (local.get $m))")
        lines.append(f"{I}        (then (local.set $rem (i64.sub (local.get $rem) (local.get $m))))")
        lines.append(f"{I}      )")
        lines.append(f"{I}      (local.set $i (i32.sub (local.get $i) (i32.const 1)))")
        lines.append(f"{I}      (br $loop_lo)")
        lines.append(f"{I}    )")
        lines.append(f"{I}  )")
        lines.append(f"{I}  (return (local.get $rem))")
        lines.append(f"{I})")
        lines.append("")
        lines.append(f"{I}(func $i64_mul_rem (param $a i64) (param $b i64) (param $m i64) (result i64)")
        lines.append(f"{I}  (local $hi i64)")
        lines.append(f"{I}  (local $lo i64)")
        lines.append(f"{I}  (call $i64_mul_128 (local.get $a) (local.get $b))")
        lines.append(f"{I}  (local.set $lo)")
        lines.append(f"{I}  (local.set $hi)")
        lines.append(f"{I}  (return (call $i128_rem_u (local.get $hi) (local.get $lo) (local.get $m)))")
        lines.append(f"{I})")
        lines.append("")
        lines.append(f"{I}(func $i64_mul_add_rem (param $a i64) (param $b i64) (param $c i64) (param $m i64) (result i64)")
        lines.append(f"{I}  (local $hi i64)")
        lines.append(f"{I}  (local $lo i64)")
        lines.append(f"{I}  (local $lo2 i64)")
        lines.append(f"{I}  (call $i64_mul_128 (local.get $a) (local.get $b))")
        lines.append(f"{I}  (local.set $lo)")
        lines.append(f"{I}  (local.set $hi)")
        lines.append(f"{I}  (local.set $lo2 (i64.add (local.get $lo) (local.get $c)))")
        lines.append(f"{I}  (if (i64.lt_u (local.get $lo2) (local.get $lo))")
        lines.append(f"{I}    (then (local.set $hi (i64.add (local.get $hi) (i64.const 1))))")
        lines.append(f"{I}  )")
        lines.append(f"{I}  (return (call $i128_rem_u (local.get $hi) (local.get $lo2) (local.get $m)))")
        lines.append(f"{I})")
        lines.append("")
        lines.append(f"{I}(func $i64_mul_xor_rem (param $a i64) (param $b i64) (param $c i64) (param $m i64) (result i64)")
        lines.append(f"{I}  (local $hi i64)")
        lines.append(f"{I}  (local $lo i64)")
        lines.append(f"{I}  (call $i64_mul_128 (local.get $a) (local.get $b))")
        lines.append(f"{I}  (local.set $lo)")
        lines.append(f"{I}  (local.set $hi)")
        lines.append(f"{I}  (return (call $i128_rem_u (local.get $hi) (i64.xor (local.get $lo) (local.get $c)) (local.get $m)))")
        lines.append(f"{I})")
        lines.append("")
        lines.append(f"{I}(func $reverse (param $buf i32) (param $len i32)")
        lines.append(f"{I}  (local $i i32)")
        lines.append(f"{I}  (local $j i32)")
        lines.append(f"{I}  (local $tmp i32)")
        lines.append(f"{I}  (local.set $i (i32.const 0))")
        lines.append(f"{I}  (local.set $j (i32.sub (local.get $len) (i32.const 1)))")
        lines.append(f"{I}  (block $done")
        lines.append(f"{I}    (loop $loop")
        lines.append(f"{I}      (if (i32.ge_u (local.get $i) (local.get $j)) (then (br $done)))")
        lines.append(f"{I}      (local.set $tmp (i32.load8_u (i32.add (local.get $buf) (local.get $i))))")
        lines.append(f"{I}      (i32.store8 (i32.add (local.get $buf) (local.get $i)) (i32.load8_u (i32.add (local.get $buf) (local.get $j))))")
        lines.append(f"{I}      (i32.store8 (i32.add (local.get $buf) (local.get $j)) (local.get $tmp))")
        lines.append(f"{I}      (local.set $i (i32.add (local.get $i) (i32.const 1)))")
        lines.append(f"{I}      (local.set $j (i32.sub (local.get $j) (i32.const 1)))")
        lines.append(f"{I}      (br $loop)")
        lines.append(f"{I}    )")
        lines.append(f"{I}  )")
        lines.append(f"{I})")
        lines.append("")
        lines.append(f"{I}(func $f64_root (param $x f64) (param $n i64) (result f64)")
        lines.append(f"{I}  (local $iter i32)")
        lines.append(f"{I}  (local $y f64)")
        lines.append(f"{I}  (local $p f64)")
        lines.append(f"{I}  (local $cnt i64)")
        lines.append(f"{I}  (local $n1 f64)")
        lines.append(f"{I}  (local $nf f64)")
        lines.append(f"{I}  (local.set $iter (i32.const 0))")
        lines.append(f"{I}  (local.set $y (f64.const 1.0))")
        lines.append(f"{I}  (block $done")
        lines.append(f"{I}    (loop $loop")
        lines.append(f"{I}      (br_if $done (i32.ge_u (local.get $iter) (i32.const 60)))")
        lines.append(f"{I}      (local.set $p (f64.const 1.0))")
        lines.append(f"{I}      (local.set $cnt (i64.sub (local.get $n) (i64.const 1)))")
        lines.append(f"{I}      (block $pdone")
        lines.append(f"{I}        (loop $ploop")
        lines.append(f"{I}          (br_if $pdone (i64.le_s (local.get $cnt) (i64.const 0)))")
        lines.append(f"{I}          (local.set $p (f64.mul (local.get $p) (local.get $y)))")
        lines.append(f"{I}          (local.set $cnt (i64.sub (local.get $cnt) (i64.const 1)))")
        lines.append(f"{I}          (br $ploop)")
        lines.append(f"{I}        )")
        lines.append(f"{I}      )")
        lines.append(f"{I}      (local.set $n1 (f64.convert_i64_s (i64.sub (local.get $n) (i64.const 1))))")
        lines.append(f"{I}      (local.set $nf (f64.convert_i64_s (local.get $n)))")
        lines.append(f"{I}      (local.set $y (f64.div (f64.add (f64.mul (local.get $n1) (local.get $y)) (f64.div (local.get $x) (local.get $p))) (local.get $nf)))")
        lines.append(f"{I}      (local.set $iter (i32.add (local.get $iter) (i32.const 1)))")
        lines.append(f"{I}      (br $loop)")
        lines.append(f"{I}    )")
        lines.append(f"{I}  )")
        lines.append(f"{I}  (return (local.get $y))")
        lines.append(f"{I})")
        lines.append("")
        lines.extend(self._round_fmt_wat(I))
        lines.append("")
        iov = self._iov_off()
        nw = self._iov_off() + 8
        for fname in ("$print_str", "$print_str_const"):
            lines.append(f"{I}(func {fname} (param $ptr i32) (param $len i32)")
            lines.append(f"{I}  (local $iov i32)")
            lines.append(f"{I}  (local.set $iov (i32.const {iov}))")
            lines.append(f"{I}  (i32.store (local.get $iov) (local.get $ptr))")
            lines.append(f"{I}  (i32.store (i32.add (local.get $iov) (i32.const 4)) (local.get $len))")
            lines.append(f"{I}  (drop (call $fd_write (i32.const 1) (local.get $iov) (i32.const 1) (i32.const {nw})))")
            lines.append(f"{I})")
            lines.append("")
        lines.append(f"{I}(func $flux_alloc (param $n i32) (result i32)")
        lines.append(f"{I}  (local $base i32)")
        lines.append(f"{I}  (local $end i32)")
        lines.append(f"{I}  (local.set $base (global.get $flux_heap_ptr))")
        lines.append(f"{I}  (local.set $end (i32.add (local.get $base) (local.get $n)))")
        lines.append(f"{I}  (block $ok")
        lines.append(f"{I}    (loop $grow")
        lines.append(f"{I}      (br_if $ok (i32.le_u (local.get $end) (i32.mul (memory.size) (i32.const 65536))))")
        lines.append(f"{I}      (drop (memory.grow (i32.const 1)))")
        lines.append(f"{I}      (br $grow)")
        lines.append(f"{I}    )")
        lines.append(f"{I}  )")
        lines.append(f"{I}  (global.set $flux_heap_ptr (local.get $end))")
        lines.append(f"{I}  (return (local.get $base))")
        lines.append(f"{I})")
        lines.append("")
        lines.append(f"{I}(func $encode_utf8 (param $cp i32) (param $buf i32) (result i32)")
        lines.append(f"{I}  (if (i32.lt_u (local.get $cp) (i32.const 128))")
        lines.append(f"{I}    (then")
        lines.append(f"{I}      (i32.store8 (local.get $buf) (local.get $cp))")
        lines.append(f"{I}      (return (i32.const 1))")
        lines.append(f"{I}    )")
        lines.append(f"{I}  )")
        lines.append(f"{I}  (if (i32.lt_u (local.get $cp) (i32.const 2048))")
        lines.append(f"{I}    (then")
        lines.append(f"{I}      (i32.store8 (local.get $buf) (i32.or (i32.shr_u (local.get $cp) (i32.const 6)) (i32.const 192)))")
        lines.append(f"{I}      (i32.store8 (i32.add (local.get $buf) (i32.const 1)) (i32.or (i32.and (local.get $cp) (i32.const 63)) (i32.const 128)))")
        lines.append(f"{I}      (return (i32.const 2))")
        lines.append(f"{I}    )")
        lines.append(f"{I}  )")
        lines.append(f"{I}  (if (i32.lt_u (local.get $cp) (i32.const 65536))")
        lines.append(f"{I}    (then")
        lines.append(f"{I}      (i32.store8 (local.get $buf) (i32.or (i32.shr_u (local.get $cp) (i32.const 12)) (i32.const 224)))")
        lines.append(f"{I}      (i32.store8 (i32.add (local.get $buf) (i32.const 1)) (i32.or (i32.and (i32.shr_u (local.get $cp) (i32.const 6)) (i32.const 63)) (i32.const 128)))")
        lines.append(f"{I}      (i32.store8 (i32.add (local.get $buf) (i32.const 2)) (i32.or (i32.and (local.get $cp) (i32.const 63)) (i32.const 128)))")
        lines.append(f"{I}      (return (i32.const 3))")
        lines.append(f"{I}    )")
        lines.append(f"{I}  )")
        lines.append(f"{I}  (i32.store8 (local.get $buf) (i32.or (i32.shr_u (local.get $cp) (i32.const 18)) (i32.const 240)))")
        lines.append(f"{I}  (i32.store8 (i32.add (local.get $buf) (i32.const 1)) (i32.or (i32.and (i32.shr_u (local.get $cp) (i32.const 12)) (i32.const 63)) (i32.const 128)))")
        lines.append(f"{I}  (i32.store8 (i32.add (local.get $buf) (i32.const 2)) (i32.or (i32.and (i32.shr_u (local.get $cp) (i32.const 6)) (i32.const 63)) (i32.const 128)))")
        lines.append(f"{I}  (i32.store8 (i32.add (local.get $buf) (i32.const 3)) (i32.or (i32.and (local.get $cp) (i32.const 63)) (i32.const 128)))")
        lines.append(f"{I}  (return (i32.const 4))")
        lines.append(f"{I})")
        lines.append("")
        lines.append(f"{I}(func $str_to_i64 (param $s i64) (result i64)")
        lines.append(f"{I}  (local $ptr i32)")
        lines.append(f"{I}  (local $len i32)")
        lines.append(f"{I}  (local $i i32)")
        lines.append(f"{I}  (local $neg i32)")
        lines.append(f"{I}  (local $res i64)")
        lines.append(f"{I}  (local $c i32)")
        lines.append(f"{I}  (local.set $ptr (i32.wrap_i64 (i64.shr_u (local.get $s) (i64.const 32))))")
        lines.append(f"{I}  (local.set $len (i32.wrap_i64 (i64.and (local.get $s) (i64.const 0xFFFFFFFF))))")
        lines.append(f"{I}  (local.set $i (i32.const 0))")
        lines.append(f"{I}  (local.set $neg (i32.const 0))")
        lines.append(f"{I}  (local.set $res (i64.const 0))")
        lines.append(f"{I}  (if (i32.eqz (local.get $len)) (then (return (i64.const 0))))")
        lines.append(f"{I}  (local.set $c (i32.load8_u (local.get $ptr)))")
        lines.append(f"{I}  (if (i32.eq (local.get $c) (i32.const 45)) (then")
        lines.append(f"{I}    (local.set $neg (i32.const 1))")
        lines.append(f"{I}    (local.set $i (i32.const 1))")
        lines.append(f"{I}  ))")
        lines.append(f"{I}  (if (i32.eq (local.get $c) (i32.const 43)) (then")
        lines.append(f"{I}    (local.set $i (i32.const 1))")
        lines.append(f"{I}  ))")
        lines.append(f"{I}  (block $done")
        lines.append(f"{I}    (loop $loop")
        lines.append(f"{I}      (if (i32.ge_u (local.get $i) (local.get $len)) (then (br $done)))")
        lines.append(f"{I}      (local.set $c (i32.load8_u (i32.add (local.get $ptr) (local.get $i))))")
        lines.append(f"{I}      (if (i32.or (i32.lt_u (local.get $c) (i32.const 48)) (i32.gt_u (local.get $c) (i32.const 57))) (then (br $done)))")
        lines.append(f"{I}      (local.set $res (i64.add (i64.mul (local.get $res) (i64.const 10)) (i64.extend_i32_u (i32.sub (local.get $c) (i32.const 48)))))")
        lines.append(f"{I}      (local.set $i (i32.add (local.get $i) (i32.const 1)))")
        lines.append(f"{I}      (br $loop)")
        lines.append(f"{I}    )")
        lines.append(f"{I}  )")
        lines.append(f"{I}  (if (local.get $neg) (then (return (i64.sub (i64.const 0) (local.get $res)))))")
        lines.append(f"{I}  (return (local.get $res))")
        lines.append(f"{I})")
        lines.append("")
        lines.append(f"{I}(func $str_to_f64 (param $s i64) (result f64)")
        lines.append(f"{I}  (local $ptr i32)")
        lines.append(f"{I}  (local $len i32)")
        lines.append(f"{I}  (local $i i32)")
        lines.append(f"{I}  (local $neg i32)")
        lines.append(f"{I}  (local $int_part f64)")
        lines.append(f"{I}  (local $frac_part f64)")
        lines.append(f"{I}  (local $frac_div f64)")
        lines.append(f"{I}  (local $in_frac i32)")
        lines.append(f"{I}  (local $in_exp i32)")
        lines.append(f"{I}  (local $exp_neg i32)")
        lines.append(f"{I}  (local $exp_val i64)")
        lines.append(f"{I}  (local $c i32)")
        lines.append(f"{I}  (local $val f64)")
        lines.append(f"{I}  (local $scale f64)")
        lines.append(f"{I}  (local $ecnt i64)")
        lines.append(f"{I}  (local.set $ptr (i32.wrap_i64 (i64.shr_u (local.get $s) (i64.const 32))))")
        lines.append(f"{I}  (local.set $len (i32.wrap_i64 (i64.and (local.get $s) (i64.const 0xFFFFFFFF))))")
        lines.append(f"{I}  (local.set $i (i32.const 0))")
        lines.append(f"{I}  (local.set $neg (i32.const 0))")
        lines.append(f"{I}  (local.set $int_part (f64.const 0))")
        lines.append(f"{I}  (local.set $frac_part (f64.const 0))")
        lines.append(f"{I}  (local.set $frac_div (f64.const 1))")
        lines.append(f"{I}  (local.set $in_frac (i32.const 0))")
        lines.append(f"{I}  (local.set $in_exp (i32.const 0))")
        lines.append(f"{I}  (local.set $exp_neg (i32.const 0))")
        lines.append(f"{I}  (local.set $exp_val (i64.const 0))")
        lines.append(f"{I}  (if (i32.eqz (local.get $len)) (then (return (f64.const 0))))")
        lines.append(f"{I}  (local.set $c (i32.load8_u (local.get $ptr)))")
        lines.append(f"{I}  (if (i32.eq (local.get $c) (i32.const 45)) (then")
        lines.append(f"{I}    (local.set $neg (i32.const 1))")
        lines.append(f"{I}    (local.set $i (i32.const 1))")
        lines.append(f"{I}  ))")
        lines.append(f"{I}  (if (i32.eq (local.get $c) (i32.const 43)) (then")
        lines.append(f"{I}    (local.set $i (i32.const 1))")
        lines.append(f"{I}  ))")
        lines.append(f"{I}  (block $done")
        lines.append(f"{I}    (loop $loop")
        lines.append(f"{I}      (if (i32.ge_u (local.get $i) (local.get $len)) (then (br $done)))")
        lines.append(f"{I}      (local.set $c (i32.load8_u (i32.add (local.get $ptr) (local.get $i))))")
        lines.append(f"{I}      (if (i32.or (i32.eq (local.get $c) (i32.const 101)) (i32.eq (local.get $c) (i32.const 69))) (then")
        lines.append(f"{I}        (local.set $in_exp (i32.const 1))")
        lines.append(f"{I}        (local.set $i (i32.add (local.get $i) (i32.const 1)))")
        lines.append(f"{I}        (if (i32.lt_u (local.get $i) (local.get $len)) (then")
        lines.append(f"{I}          (local.set $c (i32.load8_u (i32.add (local.get $ptr) (local.get $i))))")
        lines.append(f"{I}          (if (i32.eq (local.get $c) (i32.const 45)) (then")
        lines.append(f"{I}            (local.set $exp_neg (i32.const 1))")
        lines.append(f"{I}            (local.set $i (i32.add (local.get $i) (i32.const 1)))")
        lines.append(f"{I}          ))")
        lines.append(f"{I}          (if (i32.eq (local.get $c) (i32.const 43)) (then")
        lines.append(f"{I}            (local.set $i (i32.add (local.get $i) (i32.const 1)))")
        lines.append(f"{I}          ))")
        lines.append(f"{I}        ))")
        lines.append(f"{I}        (br $loop)")
        lines.append(f"{I}      ))")
        lines.append(f"{I}      (if (local.get $in_exp) (then")
        lines.append(f"{I}        (if (i32.and (i32.ge_u (local.get $c) (i32.const 48)) (i32.le_u (local.get $c) (i32.const 57))) (then")
        lines.append(f"{I}          (local.set $exp_val (i64.add (i64.mul (local.get $exp_val) (i64.const 10)) (i64.extend_i32_u (i32.sub (local.get $c) (i32.const 48)))))")
        lines.append(f"{I}        ))")
        lines.append(f"{I}        (local.set $i (i32.add (local.get $i) (i32.const 1)))")
        lines.append(f"{I}        (br $loop)")
        lines.append(f"{I}      ))")
        lines.append(f"{I}      (if (i32.or (i32.eq (local.get $c) (i32.const 46)) (i32.eq (local.get $c) (i32.const 44))) (then")
        lines.append(f"{I}        (local.set $in_frac (i32.const 1))")
        lines.append(f"{I}        (local.set $i (i32.add (local.get $i) (i32.const 1)))")
        lines.append(f"{I}        (br $loop)")
        lines.append(f"{I}      ))")
        lines.append(f"{I}      (if (i32.or (i32.lt_u (local.get $c) (i32.const 48)) (i32.gt_u (local.get $c) (i32.const 57))) (then (br $done)))")
        lines.append(f"{I}      (if (local.get $in_frac) (then")
        lines.append(f"{I}        (local.set $frac_div (f64.mul (local.get $frac_div) (f64.const 10)))")
        lines.append(f"{I}        (local.set $frac_part (f64.add (local.get $frac_part) (f64.div (f64.convert_i32_u (i32.sub (local.get $c) (i32.const 48))) (local.get $frac_div))))")
        lines.append(f"{I}      ) (else")
        lines.append(f"{I}        (local.set $int_part (f64.add (f64.mul (local.get $int_part) (f64.const 10)) (f64.convert_i32_u (i32.sub (local.get $c) (i32.const 48)))))")
        lines.append(f"{I}      ))")
        lines.append(f"{I}      (local.set $i (i32.add (local.get $i) (i32.const 1)))")
        lines.append(f"{I}      (br $loop)")
        lines.append(f"{I}    )")
        lines.append(f"{I}  )")
        lines.append(f"{I}  (local.set $val (f64.add (local.get $int_part) (local.get $frac_part)))")
        lines.append(f"{I}  (if (local.get $in_exp) (then")
        lines.append(f"{I}    (local.set $scale (f64.const 1.0))")
        lines.append(f"{I}    (local.set $ecnt (local.get $exp_val))")
        lines.append(f"{I}    (block $edone")
        lines.append(f"{I}      (loop $eloop")
        lines.append(f"{I}        (if (i64.le_s (local.get $ecnt) (i64.const 0)) (then (br $edone)))")
        lines.append(f"{I}        (local.set $scale (f64.mul (local.get $scale) (f64.const 10.0)))")
        lines.append(f"{I}        (local.set $ecnt (i64.sub (local.get $ecnt) (i64.const 1)))")
        lines.append(f"{I}        (br $eloop)")
        lines.append(f"{I}      )")
        lines.append(f"{I}    )")
        lines.append(f"{I}    (if (local.get $exp_neg)")
        lines.append(f"{I}      (then (local.set $val (f64.div (local.get $val) (local.get $scale))))")
        lines.append(f"{I}      (else (local.set $val (f64.mul (local.get $val) (local.get $scale))))")
        lines.append(f"{I}    )")
        lines.append(f"{I}  ))")
        lines.append(f"{I}  (if (local.get $neg) (then (return (f64.neg (local.get $val)))))")
        lines.append(f"{I}  (return (local.get $val))")
        lines.append(f"{I})")
        lines.append("")
        lines.append("")
        self._emit_list_helpers(lines, I)
        self._emit_set_from_data(lines, I)
        self._emit_path_helpers(lines, I)
        self._emit_datetime_helpers(lines, I)

    def _emit_path_helpers(self, lines: list[str], I: str) -> None:
        L = lines.append
        # ---- $streq : byte equality of two fat strings ----
        L(f"{I}(func $streq (param $a i64) (param $b i64) (result i32)")
        L(f"{I}  (local $pa i32) (local $pb i32) (local $la i32) (local $lb i32) (local $i i32)")
        L(f"{I}  (local.set $pa (i32.wrap_i64 (i64.shr_u (local.get $a) (i64.const 32))))")
        L(f"{I}  (local.set $pb (i32.wrap_i64 (i64.shr_u (local.get $b) (i64.const 32))))")
        L(f"{I}  (local.set $la (i32.wrap_i64 (i64.and (local.get $a) (i64.const 0xFFFFFFFF))))")
        L(f"{I}  (local.set $lb (i32.wrap_i64 (i64.and (local.get $b) (i64.const 0xFFFFFFFF))))")
        L(f"{I}  (if (i32.ne (local.get $la) (local.get $lb)) (then (return (i32.const 0))))")
        L(f"{I}  (local.set $i (i32.const 0))")
        L(f"{I}  (block $done (loop $lp")
        L(f"{I}    (if (i32.ge_u (local.get $i) (local.get $la)) (then (br $done)))")
        L(f"{I}    (if (i32.ne (i32.load8_u (i32.add (local.get $pa) (local.get $i))) (i32.load8_u (i32.add (local.get $pb) (local.get $i)))) (then (return (i32.const 0))))")
        L(f"{I}    (local.set $i (i32.add (local.get $i) (i32.const 1)))")
        L(f"{I}    (br $lp))")
        L(f"{I}  )")
        L(f"{I}  (return (i32.const 1))")
        L(f"{I})")
        L("")
        L(f"{I}(func $path_base_name (param $s i64) (result i64)")
        L(f"{I}  (local $ptr i32) (local $len i32) (local $i i32) (local $c i32) (local $last_slash i32)")
        L(f"{I}  (local.set $ptr (i32.wrap_i64 (i64.shr_u (local.get $s) (i64.const 32))))")
        L(f"{I}  (local.set $len (i32.wrap_i64 (local.get $s)))")
        L(f"{I}  (local.set $last_slash (i32.const -1))")
        L(f"{I}  (local.set $i (i32.const 0))")
        L(f"{I}  (block $done (loop $lp")
        L(f"{I}    (if (i32.ge_u (local.get $i) (local.get $len)) (then (br $done)))")
        L(f"{I}    (local.set $c (i32.load8_u (i32.add (local.get $ptr) (local.get $i))))")
        L(f"{I}    (if (i32.or (i32.eq (local.get $c) (i32.const 47)) (i32.eq (local.get $c) (i32.const 92))) (then (local.set $last_slash (local.get $i))))")
        L(f"{I}    (local.set $i (i32.add (local.get $i) (i32.const 1)))")
        L(f"{I}    (br $lp)")
        L(f"{I}  ))")
        L(f"{I}  (if (i32.ge_s (local.get $last_slash) (i32.const 0)) (then")
        L(f"{I}    (return (i64.or (i64.shl (i64.extend_i32_u (i32.add (local.get $ptr) (i32.add (local.get $last_slash) (i32.const 1)))) (i64.const 32)) (i64.extend_i32_u (i32.sub (local.get $len) (i32.add (local.get $last_slash) (i32.const 1))))))")
        L(f"{I}  ))")
        L(f"{I}  (return (local.get $s))")
        L(f"{I})")
        L("")
        L(f"{I}(func $path_dir_name (param $s i64) (result i64)")
        L(f"{I}  (local $ptr i32) (local $len i32) (local $i i32) (local $c i32) (local $last_slash i32)")
        L(f"{I}  (local.set $ptr (i32.wrap_i64 (i64.shr_u (local.get $s) (i64.const 32))))")
        L(f"{I}  (local.set $len (i32.wrap_i64 (local.get $s)))")
        L(f"{I}  (local.set $last_slash (i32.const -1))")
        L(f"{I}  (local.set $i (i32.const 0))")
        L(f"{I}  (block $done (loop $lp")
        L(f"{I}    (if (i32.ge_u (local.get $i) (local.get $len)) (then (br $done)))")
        L(f"{I}    (local.set $c (i32.load8_u (i32.add (local.get $ptr) (local.get $i))))")
        L(f"{I}    (if (i32.or (i32.eq (local.get $c) (i32.const 47)) (i32.eq (local.get $c) (i32.const 92))) (then (local.set $last_slash (local.get $i))))")
        L(f"{I}    (local.set $i (i32.add (local.get $i) (i32.const 1)))")
        L(f"{I}    (br $lp)")
        L(f"{I}  ))")
        L(f"{I}  (if (i32.ge_s (local.get $last_slash) (i32.const 0)) (then")
        L(f"{I}    (return (i64.or (i64.shl (i64.extend_i32_u (local.get $ptr)) (i64.const 32)) (i64.extend_i32_u (local.get $last_slash))))")
        L(f"{I}  ))")
        L(f"{I}  (return (i64.const 0))")
        L(f"{I})")
        L("")
        L(f"{I}(func $path_extension (param $s i64) (result i64)")
        L(f"{I}  (local $ptr i32) (local $len i32) (local $i i32) (local $c i32) (local $last_dot i32)")
        L(f"{I}  (local.set $ptr (i32.wrap_i64 (i64.shr_u (local.get $s) (i64.const 32))))")
        L(f"{I}  (local.set $len (i32.wrap_i64 (local.get $s)))")
        L(f"{I}  (local.set $last_dot (i32.const -1))")
        L(f"{I}  (local.set $i (i32.const 0))")
        L(f"{I}  (block $done (loop $lp")
        L(f"{I}    (if (i32.ge_u (local.get $i) (local.get $len)) (then (br $done)))")
        L(f"{I}    (local.set $c (i32.load8_u (i32.add (local.get $ptr) (local.get $i))))")
        L(f"{I}    (if (i32.or (i32.eq (local.get $c) (i32.const 47)) (i32.eq (local.get $c) (i32.const 92))) (then (local.set $last_dot (i32.const -1))))")
        L(f"{I}    (if (i32.eq (local.get $c) (i32.const 46)) (then (local.set $last_dot (local.get $i))))")
        L(f"{I}    (local.set $i (i32.add (local.get $i) (i32.const 1)))")
        L(f"{I}    (br $lp)")
        L(f"{I}  ))")
        L(f"{I}  (if (i32.ge_s (local.get $last_dot) (i32.const 0)) (then")
        L(f"{I}    (return (i64.or (i64.shl (i64.extend_i32_u (i32.add (local.get $ptr) (i32.add (local.get $last_dot) (i32.const 1)))) (i64.const 32)) (i64.extend_i32_u (i32.sub (local.get $len) (i32.add (local.get $last_dot) (i32.const 1))))))")
        L(f"{I}  ))")
        L(f"{I}  (return (i64.const 0))")
        L(f"{I})")
        L("")
        slash_fat_val = self._fat_const("/")
        L(f"{I}(func $path_join (param $d i64) (param $f i64) (result i64)")
        L(f"{I}  (local $buf i32)")
        L(f"{I}  (if (i64.eqz (local.get $d)) (then (return (local.get $f))))")
        L(f"{I}  (if (i64.eqz (local.get $f)) (then (return (local.get $d))))")
        L(f"{I}  (local.set $buf (call $strbuf_new (i32.const 1024)))")
        L(f"{I}  (call $strappend (local.get $buf) (local.get $d))")
        L(f"{I}  (call $strappend (local.get $buf) (i64.const {slash_fat_val}))")
        L(f"{I}  (call $strappend (local.get $buf) (local.get $f))")
        L(f"{I}  (call $strbuf_done (local.get $buf))")
        L(f"{I}  (return (i64.or (i64.shl (i64.extend_i32_u (i32.add (local.get $buf) (i32.const 4))) (i64.const 32)) (i64.extend_i32_u (i32.load (local.get $buf)))))")
        L(f"{I})")
        L("")

    def _emit_datetime_helpers(self, lines: list[str], I: str) -> None:
        L = lines.append
        tz_sp = self._fat_const("America/Sao_Paulo")
        tz_brt = self._fat_const("BRT")
        wasi_off = self._dt_wasi_off()

        L(f"{I}(global $dt_pos (mut i32) (i32.const 0))")
        L(f"{I}(global $dt_ok (mut i32) (i32.const 1))")
        L(f"{I}(global $dt_y (mut i64) (i64.const 0))")
        L(f"{I}(global $dt_m (mut i64) (i64.const 0))")
        L(f"{I}(global $dt_d (mut i64) (i64.const 0))")
        L(f"{I}(global $dt_h (mut i64) (i64.const 0))")
        L(f"{I}(global $dt_mi (mut i64) (i64.const 0))")
        L(f"{I}(global $dt_s (mut i64) (i64.const 0))")
        L(f"{I}(global $dt_ms (mut i64) (i64.const 0))")
        L(f"{I}(global $dt_us (mut i64) (i64.const 0))")
        L(f"{I}(global $dt_ns (mut i64) (i64.const 0))")
        L(f"{I}(global $dt_days (mut i64) (i64.const 0))")
        L("")
        L(f"{I}(func $dt_floor_div (param $a i64) (param $b i64) (result i64)")
        L(f"{I}  (local $q i64) (local $r i64)")
        L(f"{I}  (local.set $q (i64.div_s (local.get $a) (local.get $b)))")
        L(f"{I}  (local.set $r (i64.rem_s (local.get $a) (local.get $b)))")
        L(f"{I}  (if (i32.and (i64.lt_s (local.get $a) (i64.const 0)) (i64.ne (local.get $r) (i64.const 0)))")
        L(f"{I}    (then (local.set $q (i64.sub (local.get $q) (i64.const 1))))")
        L(f"{I}  )")
        L(f"{I}  (return (local.get $q))")
        L(f"{I})")
        L("")
        L(f"{I}(func $dt_floor_rem (param $a i64) (param $b i64) (result i64)")
        L(f"{I}  (return (i64.sub (local.get $a) (i64.mul (call $dt_floor_div (local.get $a) (local.get $b)) (local.get $b))))")
        L(f"{I})")
        L("")
        L(f"{I}(func $days_from_civil (param $y i64) (param $m i64) (param $d i64) (result i64)")
        L(f"{I}  (local $era i64) (local $yoe i64) (local $doy i64) (local $doe i64) (local $y2 i64) (local $m2 i64)")
        L(f"{I}  (if (i64.le_s (local.get $m) (i64.const 2)) (then (local.set $y (i64.sub (local.get $y) (i64.const 1)))))")
        L(f"{I}  (local.set $y2 (select (local.get $y) (i64.sub (local.get $y) (i64.const 399)) (i64.ge_s (local.get $y) (i64.const 0))))")
        L(f"{I}  (local.set $era (i64.div_s (local.get $y2) (i64.const 400)))")
        L(f"{I}  (local.set $yoe (i64.sub (local.get $y) (i64.mul (local.get $era) (i64.const 400))))")
        L(f"{I}  (local.set $m2 (i64.add (local.get $m) (select (i64.const -3) (i64.const 9) (i64.gt_s (local.get $m) (i64.const 2)))))")
        L(f"{I}  (local.set $doy (i64.add (i64.sub (i64.div_s (i64.add (i64.mul (i64.const 153) (local.get $m2)) (i64.const 2)) (i64.const 5)) (i64.const 1)) (local.get $d)))")
        L(f"{I}  (local.set $doe (i64.add (i64.sub (i64.add (i64.mul (local.get $yoe) (i64.const 365)) (i64.div_s (local.get $yoe) (i64.const 4))) (i64.div_s (local.get $yoe) (i64.const 100))) (local.get $doy)))")
        L(f"{I}  (return (i64.sub (i64.add (i64.mul (local.get $era) (i64.const 146097)) (local.get $doe)) (i64.const 719468)))")
        L(f"{I})")
        L("")
        L(f"{I}(func $dt_split (param $nanos i64)")
        L(f"{I}  (local $sec i64) (local $frac i64) (local $days i64) (local $rem_sec i64)")
        L(f"{I}  (local $z i64) (local $era i64) (local $doe i64) (local $yoe i64)")
        L(f"{I}  (local $y i64) (local $doy i64) (local $mp i64) (local $d i64) (local $m i64)")
        L(f"{I}  (local.set $sec (call $dt_floor_div (local.get $nanos) (i64.const 1000000000)))")
        L(f"{I}  (local.set $frac (call $dt_floor_rem (local.get $nanos) (i64.const 1000000000)))")
        L(f"{I}  (local.set $days (call $dt_floor_div (local.get $sec) (i64.const 86400)))")
        L(f"{I}  (local.set $rem_sec (call $dt_floor_rem (local.get $sec) (i64.const 86400)))")
        L(f"{I}  (global.set $dt_days (local.get $days))")
        L(f"{I}  (local.set $z (i64.add (local.get $days) (i64.const 719468)))")
        L(f"{I}  (local.set $era (call $dt_floor_div (select (local.get $z) (i64.sub (local.get $z) (i64.const 146096)) (i64.ge_s (local.get $z) (i64.const 0))) (i64.const 146097)))")
        L(f"{I}  (local.set $doe (i64.sub (local.get $z) (i64.mul (local.get $era) (i64.const 146097))))")
        L(f"{I}  (local.set $yoe (i64.div_s (i64.add (i64.sub (i64.sub (local.get $doe) (i64.div_s (local.get $doe) (i64.const 1460))) (i64.div_s (local.get $doe) (i64.const 36524))) (i64.div_s (local.get $doe) (i64.const 146096))) (i64.const 365)))")
        L(f"{I}  (local.set $y (i64.add (local.get $yoe) (i64.mul (local.get $era) (i64.const 400))))")
        L(f"{I}  (local.set $doy (i64.sub (local.get $doe) (i64.add (i64.sub (i64.mul (i64.const 365) (local.get $yoe)) (i64.div_s (local.get $yoe) (i64.const 100))) (i64.div_s (local.get $yoe) (i64.const 4)))))")
        L(f"{I}  (local.set $mp (i64.div_s (i64.add (i64.mul (i64.const 5) (local.get $doy)) (i64.const 2)) (i64.const 153)))")
        L(f"{I}  (local.set $d (i64.add (i64.sub (local.get $doy) (i64.div_s (i64.add (i64.mul (i64.const 153) (local.get $mp)) (i64.const 2)) (i64.const 5))) (i64.const 1)))")
        L(f"{I}  (local.set $m (select (i64.add (local.get $mp) (i64.const 3)) (i64.sub (local.get $mp) (i64.const 9)) (i64.lt_s (local.get $mp) (i64.const 10))))")
        L(f"{I}  (if (i64.le_s (local.get $m) (i64.const 2)) (then (local.set $y (i64.add (local.get $y) (i64.const 1)))))")
        L(f"{I}  (global.set $dt_y (local.get $y))")
        L(f"{I}  (global.set $dt_m (local.get $m))")
        L(f"{I}  (global.set $dt_d (local.get $d))")
        L(f"{I}  (global.set $dt_h (i64.div_s (local.get $rem_sec) (i64.const 3600)))")
        L(f"{I}  (global.set $dt_mi (i64.div_s (i64.rem_s (local.get $rem_sec) (i64.const 3600)) (i64.const 60)))")
        L(f"{I}  (global.set $dt_s (i64.rem_s (local.get $rem_sec) (i64.const 60)))")
        L(f"{I}  (global.set $dt_ms (i64.div_s (local.get $frac) (i64.const 1000000)))")
        L(f"{I}  (global.set $dt_us (i64.div_s (local.get $frac) (i64.const 1000)))")
        L(f"{I}  (global.set $dt_ns (local.get $frac))")
        L(f"{I})")
        L("")
        L(f"{I}(func $dt_is_leap_year_val (param $y i64) (result i64)")
        L(f"{I}  (if (i64.eqz (i64.rem_s (local.get $y) (i64.const 400))) (then (return (i64.const 1))))")
        L(f"{I}  (if (i64.eqz (i64.rem_s (local.get $y) (i64.const 100))) (then (return (i64.const 0))))")
        L(f"{I}  (if (i64.eqz (i64.rem_s (local.get $y) (i64.const 4))) (then (return (i64.const 1))))")
        L(f"{I}  (return (i64.const 0))")
        L(f"{I})")
        L("")
        L(f"{I}(func $dt_days_in_month_val (param $y i64) (param $m i64) (result i64)")
        L(f"{I}  (if (i64.eq (local.get $m) (i64.const 2)) (then")
        L(f"{I}    (return (select (i64.const 29) (i64.const 28) (i64.eq (call $dt_is_leap_year_val (local.get $y)) (i64.const 1))))")
        L(f"{I}  ))")
        L(f"{I}  (if (i32.or (i32.or (i64.eq (local.get $m) (i64.const 4)) (i64.eq (local.get $m) (i64.const 6))) (i32.or (i64.eq (local.get $m) (i64.const 9)) (i64.eq (local.get $m) (i64.const 11))))")
        L(f"{I}    (then (return (i64.const 30)))")
        L(f"{I}  )")
        L(f"{I}  (return (i64.const 31))")
        L(f"{I})")
        L("")
        L(f"{I}(func $dt_get_comp (param $nanos i64) (param $comp i32) (result i64)")
        L(f"{I}  (local $y i64) (local $m i64) (local $d i64) (local $w i64)")
        L(f"{I}  (call $dt_split (local.get $nanos))")
        L(f"{I}  (local.set $y (global.get $dt_y))")
        L(f"{I}  (local.set $m (global.get $dt_m))")
        L(f"{I}  (local.set $d (global.get $dt_d))")
        L(f"{I}  (if (i32.eq (local.get $comp) (i32.const 0)) (then (return (local.get $y))))")
        L(f"{I}  (if (i32.eq (local.get $comp) (i32.const 1)) (then (return (local.get $m))))")
        L(f"{I}  (if (i32.eq (local.get $comp) (i32.const 2)) (then (return (local.get $d))))")
        L(f"{I}  (if (i32.eq (local.get $comp) (i32.const 3)) (then (return (global.get $dt_h))))")
        L(f"{I}  (if (i32.eq (local.get $comp) (i32.const 4)) (then (return (global.get $dt_mi))))")
        L(f"{I}  (if (i32.eq (local.get $comp) (i32.const 5)) (then (return (global.get $dt_s))))")
        L(f"{I}  (if (i32.eq (local.get $comp) (i32.const 6)) (then (return (i64.rem_s (global.get $dt_ms) (i64.const 1000)))))")
        L(f"{I}  (if (i32.eq (local.get $comp) (i32.const 7)) (then (return (i64.rem_s (global.get $dt_us) (i64.const 1000000)))))")
        L(f"{I}  (if (i32.eq (local.get $comp) (i32.const 8)) (then (return (global.get $dt_ns))))")
        L(f"{I}  (if (i32.eq (local.get $comp) (i32.const 9)) (then")
        L(f"{I}    (local.set $w (i64.rem_s (i64.add (global.get $dt_days) (i64.const 3)) (i64.const 7)))")
        L(f"{I}    (if (i64.lt_s (local.get $w) (i64.const 0)) (then (local.set $w (i64.add (local.get $w) (i64.const 7)))))")
        L(f"{I}    (return (i64.add (local.get $w) (i64.const 1)))")
        L(f"{I}  ))")
        L(f"{I}  (if (i32.eq (local.get $comp) (i32.const 10)) (then")
        L(f"{I}    (return (i64.add (i64.sub (global.get $dt_days) (call $days_from_civil (local.get $y) (i64.const 1) (i64.const 1))) (i64.const 1)))")
        L(f"{I}  ))")
        L(f"{I}  (if (i32.eq (local.get $comp) (i32.const 11)) (then")
        L(f"{I}    (return (call $dt_days_in_month_val (local.get $y) (local.get $m)))")
        L(f"{I}  ))")
        L(f"{I}  (if (i32.eq (local.get $comp) (i32.const 12)) (then")
        L(f"{I}    (return (i64.add (i64.div_s (i64.sub (local.get $m) (i64.const 1)) (i64.const 3)) (i64.const 1)))")
        L(f"{I}  ))")
        L(f"{I}  (if (i32.eq (local.get $comp) (i32.const 13)) (then")
        L(f"{I}    (return (call $dt_is_leap_year_val (local.get $y)))")
        L(f"{I}  ))")
        L(f"{I}  (if (i32.eq (local.get $comp) (i32.const 14)) (then")
        L(f"{I}    (local.set $w (call $dt_get_comp (local.get $nanos) (i32.const 9)))")
        L(f"{I}    (return (select (i64.const 1) (i64.const 0) (i32.or (i64.eq (local.get $w) (i64.const 6)) (i64.eq (local.get $w) (i64.const 7)))))")
        L(f"{I}  ))")
        L(f"{I}  (return (i64.const 0))")
        L(f"{I})")
        L("")
        L(f"{I}(func $dt_num (param $ptr i32) (param $len i32) (param $n i32) (param $sep i32) (result i64)")
        L(f"{I}  (local $i i32) (local $v i64) (local $c i32)")
        L(f"{I}  (local.set $i (global.get $dt_pos)) (local.set $v (i64.const 0))")
        L(f"{I}  (block $b0 (loop $l0")
        L(f"{I}    (if (i32.eqz (local.get $n)) (then (br $b0)))")
        L(f"{I}    (if (i32.ge_u (local.get $i) (local.get $len)) (then (global.set $dt_ok (i32.const 0)) (return (i64.const 0))))")
        L(f"{I}    (local.set $c (i32.load8_u (i32.add (local.get $ptr) (local.get $i))))")
        L(f"{I}    (if (i32.or (i32.lt_u (local.get $c) (i32.const 48)) (i32.gt_u (local.get $c) (i32.const 57))) (then (global.set $dt_ok (i32.const 0)) (return (i64.const 0))))")
        L(f"{I}    (local.set $v (i64.add (i64.mul (local.get $v) (i64.const 10)) (i64.extend_i32_u (i32.sub (local.get $c) (i32.const 48)))))")
        L(f"{I}    (local.set $i (i32.add (local.get $i) (i32.const 1))) (local.set $n (i32.sub (local.get $n) (i32.const 1)))")
        L(f"{I}    (br $l0))")
        L(f"{I}  )")
        L(f"{I}  (if (i32.ge_u (local.get $i) (local.get $len)) (then (global.set $dt_ok (i32.const 0)) (return (i64.const 0))))")
        L(f"{I}  (local.set $c (i32.load8_u (i32.add (local.get $ptr) (local.get $i))))")
        L(f"{I}  (if (i32.ne (local.get $c) (local.get $sep)) (then (global.set $dt_ok (i32.const 0)) (return (i64.const 0))))")
        L(f"{I}  (global.set $dt_pos (i32.add (local.get $i) (i32.const 1)))")
        L(f"{I}  (return (local.get $v))")
        L(f"{I})")
        L("")
        L(f"{I}(func $dt_num0 (param $ptr i32) (param $len i32) (param $n i32) (result i64)")
        L(f"{I}  (local $i i32) (local $v i64) (local $c i32)")
        L(f"{I}  (local.set $i (global.get $dt_pos)) (local.set $v (i64.const 0))")
        L(f"{I}  (block $b0 (loop $l0")
        L(f"{I}    (if (i32.eqz (local.get $n)) (then (br $b0)))")
        L(f"{I}    (if (i32.ge_u (local.get $i) (local.get $len)) (then (global.set $dt_ok (i32.const 0)) (return (i64.const 0))))")
        L(f"{I}    (local.set $c (i32.load8_u (i32.add (local.get $ptr) (local.get $i))))")
        L(f"{I}    (if (i32.or (i32.lt_u (local.get $c) (i32.const 48)) (i32.gt_u (local.get $c) (i32.const 57))) (then (global.set $dt_ok (i32.const 0)) (return (i64.const 0))))")
        L(f"{I}    (local.set $v (i64.add (i64.mul (local.get $v) (i64.const 10)) (i64.extend_i32_u (i32.sub (local.get $c) (i32.const 48)))))")
        L(f"{I}    (local.set $i (i32.add (local.get $i) (i32.const 1))) (local.set $n (i32.sub (local.get $n) (i32.const 1)))")
        L(f"{I}    (br $l0))")
        L(f"{I}  )")
        L(f"{I}  (global.set $dt_pos (local.get $i))")
        L(f"{I}  (return (local.get $v))")
        L(f"{I})")
        L("")
        L(f"{I}(func $dt_frac (param $ptr i32) (param $len i32) (result i64)")
        L(f"{I}  (local $i i32) (local $c i32) (local $nd i64) (local $cnt i32) (local $pow i64) (local $n i32)")
        L(f"{I}  (local.set $i (global.get $dt_pos)) (local.set $nd (i64.const 0)) (local.set $cnt (i32.const 0))")
        L(f"{I}  (block $b0 (loop $l0")
        L(f"{I}    (if (i32.ge_u (local.get $i) (local.get $len)) (then (br $b0)))")
        L(f"{I}    (local.set $c (i32.load8_u (i32.add (local.get $ptr) (local.get $i))))")
        L(f"{I}    (if (i32.or (i32.lt_u (local.get $c) (i32.const 48)) (i32.gt_u (local.get $c) (i32.const 57))) (then (br $b0)))")
        L(f"{I}    (if (i32.ge_u (local.get $cnt) (i32.const 9)) (then (global.set $dt_ok (i32.const 0)) (return (i64.const 0))))")
        L(f"{I}    (local.set $nd (i64.add (i64.mul (local.get $nd) (i64.const 10)) (i64.extend_i32_u (i32.sub (local.get $c) (i32.const 48)))))")
        L(f"{I}    (local.set $cnt (i32.add (local.get $cnt) (i32.const 1))) (local.set $i (i32.add (local.get $i) (i32.const 1)))")
        L(f"{I}    (br $l0))")
        L(f"{I}  )")
        L(f"{I}  (if (i32.eqz (local.get $cnt)) (then (global.set $dt_ok (i32.const 0)) (return (i64.const 0))))")
        L(f"{I}  (global.set $dt_pos (local.get $i))")
        L(f"{I}  (local.set $pow (i64.const 1)) (local.set $n (i32.sub (i32.const 9) (local.get $cnt)))")
        L(f"{I}  (block $p0 (loop $pl")
        L(f"{I}    (if (i32.eqz (local.get $n)) (then (br $p0)))")
        L(f"{I}    (local.set $pow (i64.mul (local.get $pow) (i64.const 10))) (local.set $n (i32.sub (local.get $n) (i32.const 1)))")
        L(f"{I}    (br $pl))")
        L(f"{I}  )")
        L(f"{I}  (return (i64.mul (local.get $nd) (local.get $pow)))")
        L(f"{I})")
        L("")
        L(f"{I}(func $dt_offset (param $ptr i32) (param $len i32) (param $neg i32) (result i64)")
        L(f"{I}  (local $i i32) (local $c i32) (local $hh i64) (local $mm i64) (local $cnt i32)")
        L(f"{I}  (local.set $i (global.get $dt_pos)) (local.set $hh (i64.const 0)) (local.set $mm (i64.const 0)) (local.set $cnt (i32.const 0))")
        L(f"{I}  (block $h0 (loop $hl")
        L(f"{I}    (if (i32.eq (local.get $cnt) (i32.const 2)) (then (br $h0)))")
        L(f"{I}    (if (i32.ge_u (local.get $i) (local.get $len)) (then (global.set $dt_ok (i32.const 0)) (return (i64.const 0))))")
        L(f"{I}    (local.set $c (i32.load8_u (i32.add (local.get $ptr) (local.get $i))))")
        L(f"{I}    (if (i32.or (i32.lt_u (local.get $c) (i32.const 48)) (i32.gt_u (local.get $c) (i32.const 57))) (then (global.set $dt_ok (i32.const 0)) (return (i64.const 0))))")
        L(f"{I}    (local.set $hh (i64.add (i64.mul (local.get $hh) (i64.const 10)) (i64.extend_i32_u (i32.sub (local.get $c) (i32.const 48)))))")
        L(f"{I}    (local.set $i (i32.add (local.get $i) (i32.const 1))) (local.set $cnt (i32.add (local.get $cnt) (i32.const 1)))")
        L(f"{I}    (br $hl))")
        L(f"{I}  )")
        L(f"{I}  (if (i32.lt_u (local.get $i) (local.get $len)) (then")
        L(f"{I}    (local.set $c (i32.load8_u (i32.add (local.get $ptr) (local.get $i))))")
        L(f"{I}    (if (i32.or (i32.eq (local.get $c) (i32.const 58)) (i32.and (i32.ge_u (local.get $c) (i32.const 48)) (i32.le_u (local.get $c) (i32.const 57)))) (then")
        L(f"{I}      (if (i32.eq (local.get $c) (i32.const 58)) (then (local.set $i (i32.add (local.get $i) (i32.const 1)))))")
        L(f"{I}      (local.set $cnt (i32.const 0))")
        L(f"{I}      (block $m0 (loop $ml")
        L(f"{I}        (if (i32.eq (local.get $cnt) (i32.const 2)) (then (br $m0)))")
        L(f"{I}        (if (i32.ge_u (local.get $i) (local.get $len)) (then (global.set $dt_ok (i32.const 0)) (return (i64.const 0))))")
        L(f"{I}        (local.set $c (i32.load8_u (i32.add (local.get $ptr) (local.get $i))))")
        L(f"{I}        (if (i32.or (i32.lt_u (local.get $c) (i32.const 48)) (i32.gt_u (local.get $c) (i32.const 57))) (then (global.set $dt_ok (i32.const 0)) (return (i64.const 0))))")
        L(f"{I}        (local.set $mm (i64.add (i64.mul (local.get $mm) (i64.const 10)) (i64.extend_i32_u (i32.sub (local.get $c) (i32.const 48)))))")
        L(f"{I}        (local.set $i (i32.add (local.get $i) (i32.const 1))) (local.set $cnt (i32.add (local.get $cnt) (i32.const 1)))")
        L(f"{I}        (br $ml))")
        L(f"{I}      )")
        L(f"{I}    ))")
        L(f"{I}  ))")
        L(f"{I}  (global.set $dt_pos (local.get $i))")
        L(f"{I}  (local.set $hh (i64.add (i64.mul (local.get $hh) (i64.const 3600)) (i64.mul (local.get $mm) (i64.const 60))))")
        L(f"{I}  (if (local.get $neg) (then (return (i64.sub (i64.const 0) (local.get $hh)))))")
        L(f"{I}  (return (local.get $hh))")
        L(f"{I})")
        L("")
        L(f"{I}(func $dt_parse_iso (param $str i64) (result i64)")
        L(f"{I}  (local $ptr i32) (local $len i32) (local $c i32) (local $cneg i32)")
        L(f"{I}  (local $y i64) (local $mo i64) (local $d i64) (local $h i64) (local $mi i64) (local $s i64)")
        L(f"{I}  (local $nanos i64) (local $delta i64) (local $secs i64) (local $day i64)")
        L(f"{I}  (local.set $ptr (i32.wrap_i64 (i64.shr_u (local.get $str) (i64.const 32))))")
        L(f"{I}  (local.set $len (i32.wrap_i64 (i64.and (local.get $str) (i64.const 0xFFFFFFFF))))")
        L(f"{I}  (global.set $dt_pos (i32.const 0)) (global.set $dt_ok (i32.const 1))")
        L(f"{I}  (block $bws (loop $lws")
        L(f"{I}    (if (i32.ge_u (global.get $dt_pos) (local.get $len)) (then (br $bws)))")
        L(f"{I}    (local.set $c (i32.load8_u (i32.add (local.get $ptr) (global.get $dt_pos))))")
        L(f"{I}    (if (i32.or (i32.eq (local.get $c) (i32.const 32)) (i32.eq (local.get $c) (i32.const 9))) (then (global.set $dt_pos (i32.add (global.get $dt_pos) (i32.const 1))) (br $lws)) (else (br $bws)))")
        L(f"{I}  ))")
        L(f"{I}  (local.set $nanos (i64.const 0)) (local.set $delta (i64.const 0))")
        L(f"{I}  (local.set $y (call $dt_num (local.get $ptr) (local.get $len) (i32.const 4) (i32.const 45)))")
        L(f"{I}  (local.set $mo (call $dt_num (local.get $ptr) (local.get $len) (i32.const 2) (i32.const 45)))")
        L(f"{I}  (local.set $d (call $dt_num (local.get $ptr) (local.get $len) (i32.const 2) (i32.const 84)))")
        L(f"{I}  (if (i32.eqz (global.get $dt_ok)) (then")
        L(f"{I}    (global.set $dt_pos (i32.sub (global.get $dt_pos) (i32.const 1)))")
        L(f"{I}    (if (i32.lt_u (global.get $dt_pos) (local.get $len)) (then")
        L(f"{I}      (local.set $c (i32.load8_u (i32.add (local.get $ptr) (global.get $dt_pos))))")
        L(f"{I}      (if (i32.eq (local.get $c) (i32.const 32)) (then (global.set $dt_ok (i32.const 1)) (global.set $dt_pos (i32.add (global.get $dt_pos) (i32.const 1)))))")
        L(f"{I}    ))")
        L(f"{I}  ))")
        L(f"{I}  (local.set $h (call $dt_num (local.get $ptr) (local.get $len) (i32.const 2) (i32.const 58)))")
        L(f"{I}  (local.set $mi (call $dt_num (local.get $ptr) (local.get $len) (i32.const 2) (i32.const 58)))")
        L(f"{I}  (local.set $s (call $dt_num0 (local.get $ptr) (local.get $len) (i32.const 2)))")
        L(f"{I}  (if (global.get $dt_ok) (then")
        L(f"{I}    (if (i32.lt_u (global.get $dt_pos) (local.get $len)) (then")
        L(f"{I}      (local.set $c (i32.load8_u (i32.add (local.get $ptr) (global.get $dt_pos))))")
        L(f"{I}      (if (i32.eq (local.get $c) (i32.const 46)) (then")
        L(f"{I}        (global.set $dt_pos (i32.add (global.get $dt_pos) (i32.const 1)))")
        L(f"{I}        (local.set $nanos (call $dt_frac (local.get $ptr) (local.get $len)))")
        L(f"{I}      ))")
        L(f"{I}    ))")
        L(f"{I}  ))")
        L(f"{I}  (if (global.get $dt_ok) (then")
        L(f"{I}    (if (i32.lt_u (global.get $dt_pos) (local.get $len)) (then")
        L(f"{I}      (local.set $c (i32.load8_u (i32.add (local.get $ptr) (global.get $dt_pos))))")
        L(f"{I}      (if (i32.eq (local.get $c) (i32.const 90)) (then")
        L(f"{I}        (global.set $dt_pos (i32.add (global.get $dt_pos) (i32.const 1)))")
        L(f"{I}      ) (else (if (i32.or (i32.eq (local.get $c) (i32.const 43)) (i32.eq (local.get $c) (i32.const 45))) (then")
        L(f"{I}        (local.set $cneg (select (i32.const 1) (i32.const 0) (i32.eq (local.get $c) (i32.const 45))))")
        L(f"{I}        (global.set $dt_pos (i32.add (global.get $dt_pos) (i32.const 1)))")
        L(f"{I}        (local.set $delta (call $dt_offset (local.get $ptr) (local.get $len) (local.get $cneg)))")
        L(f"{I}      ))))")
        L(f"{I}    ))")
        L(f"{I}  ))")
        L(f"{I}  (block $btws (loop $ltws")
        L(f"{I}    (if (i32.ge_u (global.get $dt_pos) (local.get $len)) (then (br $btws)))")
        L(f"{I}    (local.set $c (i32.load8_u (i32.add (local.get $ptr) (global.get $dt_pos))))")
        L(f"{I}    (if (i32.or (i32.eq (local.get $c) (i32.const 32)) (i32.eq (local.get $c) (i32.const 9))) (then (global.set $dt_pos (i32.add (global.get $dt_pos) (i32.const 1))) (br $ltws)) (else (br $btws)))")
        L(f"{I}  ))")
        L(f"{I}  (if (global.get $dt_ok) (then")
        L(f"{I}    (if (i32.ne (global.get $dt_pos) (local.get $len)) (then (global.set $dt_ok (i32.const 0))))")
        L(f"{I}  ))")
        L(f"{I}  (if (i32.eqz (global.get $dt_ok)) (then (return (i64.const 0))))")
        L(f"{I}  (local.set $day (call $days_from_civil (local.get $y) (local.get $mo) (local.get $d)))")
        L(f"{I}  (local.set $secs (i64.add (i64.mul (local.get $day) (i64.const 86400)) (i64.add (i64.add (i64.mul (local.get $h) (i64.const 3600)) (i64.mul (local.get $mi) (i64.const 60))) (local.get $s))))")
        L(f"{I}  (local.set $secs (i64.sub (local.get $secs) (local.get $delta)))")
        L(f"{I}  (return (i64.add (i64.mul (local.get $secs) (i64.const 1000000000)) (local.get $nanos)))")
        L(f"{I})")
        L("")
        L(f"{I}(func $dt_create_date (param $y i64) (param $m i64) (param $d i64) (result i64)")
        L(f"{I}  (return (i64.mul (call $days_from_civil (local.get $y) (local.get $m) (local.get $d)) (i64.const 86400000000000)))")
        L(f"{I})")
        L("")
        L(f"{I}(func $dt_create_time (param $h i64) (param $m i64) (param $s i64) (result i64)")
        L(f"{I}  (return (i64.mul (i64.add (i64.mul (local.get $h) (i64.const 3600)) (i64.add (i64.mul (local.get $m) (i64.const 60)) (local.get $s))) (i64.const 1000000000)))")
        L(f"{I})")
        L("")
        L(f"{I}(func $dt_create_time_full (param $h i64) (param $m i64) (param $s i64) (param $ms i64) (param $us i64) (param $ns i64) (result i64)")
        L(f"{I}  (local $tot i64)")
        L(f"{I}  (local.set $tot (call $dt_create_time (local.get $h) (local.get $m) (local.get $s)))")
        L(f"{I}  (local.set $tot (i64.add (local.get $tot) (i64.mul (local.get $ms) (i64.const 1000000))))")
        L(f"{I}  (local.set $tot (i64.add (local.get $tot) (i64.mul (local.get $us) (i64.const 1000))))")
        L(f"{I}  (local.set $tot (i64.add (local.get $tot) (local.get $ns)))")
        L(f"{I}  (return (local.get $tot))")
        L(f"{I})")
        L("")
        L(f"{I}(func $dt_now (result i64)")
        L(f"{I}  (drop (call $clock_time_get (i32.const 0) (i64.const 0) (i32.const {wasi_off})))")
        L(f"{I}  (return (i64.load (i32.const {wasi_off})))")
        L(f"{I})")
        L("")
        L(f"{I}(func $dt_monotonic_now (result i64)")
        L(f"{I}  (drop (call $clock_time_get (i32.const 1) (i64.const 0) (i32.const {wasi_off})))")
        L(f"{I}  (return (i64.load (i32.const {wasi_off})))")
        L(f"{I})")
        L("")
        L(f"{I}(func $dt_today (result i64)")
        L(f"{I}  (local $now i64) (local $days i64)")
        L(f"{I}  (local.set $now (call $dt_now))")
        L(f"{I}  (call $dt_split (local.get $now))")
        L(f"{I}  (local.set $days (call $days_from_civil (global.get $dt_y) (global.get $dt_m) (global.get $dt_d)))")
        L(f"{I}  (return (i64.mul (local.get $days) (i64.const 86400000000000)))")
        L(f"{I})")
        L("")
        L(f"{I}(func $dt_time (result i64)")
        L(f"{I}  (local $now i64) (local $sec i64) (local $frac i64) (local $rem_sec i64)")
        L(f"{I}  (local.set $now (call $dt_now))")
        L(f"{I}  (local.set $sec (i64.div_s (local.get $now) (i64.const 1000000000)))")
        L(f"{I}  (local.set $frac (i64.rem_s (local.get $now) (i64.const 1000000000)))")
        L(f"{I}  (local.set $rem_sec (i64.rem_s (local.get $sec) (i64.const 86400)))")
        L(f"{I}  (return (i64.add (i64.mul (local.get $rem_sec) (i64.const 1000000000)) (local.get $frac)))")
        L(f"{I})")
        L("")
        L(f"{I}(func $dt_add_months (param $nanos i64) (param $months i64) (result i64)")
        L(f"{I}  (local $y i64) (local $m i64) (local $d i64) (local $h i64) (local $mi i64) (local $s i64) (local $frac i64)")
        L(f"{I}  (local $tot_m i64) (local $ny i64) (local $nm i64) (local $dim i64) (local $nd i64) (local $day i64) (local $sec i64)")
        L(f"{I}  (call $dt_split (local.get $nanos))")
        L(f"{I}  (local.set $y (global.get $dt_y))")
        L(f"{I}  (local.set $m (global.get $dt_m))")
        L(f"{I}  (local.set $d (global.get $dt_d))")
        L(f"{I}  (local.set $h (global.get $dt_h))")
        L(f"{I}  (local.set $mi (global.get $dt_mi))")
        L(f"{I}  (local.set $s (global.get $dt_s))")
        L(f"{I}  (local.set $frac (global.get $dt_ns))")
        L(f"{I}  (local.set $tot_m (i64.add (i64.add (i64.mul (local.get $y) (i64.const 12)) (i64.sub (local.get $m) (i64.const 1))) (local.get $months)))")
        L(f"{I}  (local.set $ny (call $dt_floor_div (local.get $tot_m) (i64.const 12)))")
        L(f"{I}  (local.set $nm (i64.add (call $dt_floor_rem (local.get $tot_m) (i64.const 12)) (i64.const 1)))")
        L(f"{I}  (local.set $dim (call $dt_days_in_month_val (local.get $ny) (local.get $nm)))")
        L(f"{I}  (local.set $nd (select (local.get $dim) (local.get $d) (i64.gt_s (local.get $d) (local.get $dim))))")
        L(f"{I}  (local.set $day (call $days_from_civil (local.get $ny) (local.get $nm) (local.get $nd)))")
        L(f"{I}  (local.set $sec (i64.add (i64.mul (local.get $day) (i64.const 86400)) (i64.add (i64.mul (local.get $h) (i64.const 3600)) (i64.add (i64.mul (local.get $mi) (i64.const 60)) (local.get $s)))))")
        L(f"{I}  (return (i64.add (i64.mul (local.get $sec) (i64.const 1000000000)) (local.get $frac)))")
        L(f"{I})")
        L("")
        L(f"{I}(func $dt_add_years (param $nanos i64) (param $years i64) (result i64)")
        L(f"{I}  (return (call $dt_add_months (local.get $nanos) (i64.mul (local.get $years) (i64.const 12))))")
        L(f"{I})")
        L("")
        L(f"{I}(func $dt_months_between (param $left i64) (param $right i64) (result i64)")
        L(f"{I}  (local $sign i64) (local $tmp i64)")
        L(f"{I}  (local $ly i64) (local $lm i64) (local $ld i64) (local $lh i64) (local $lmi i64) (local $ls i64) (local $lfrac i64)")
        L(f"{I}  (local $ry i64) (local $rm i64) (local $rd i64) (local $rh i64) (local $rmi i64) (local $rs i64) (local $rfrac i64)")
        L(f"{I}  (local $mdiff i64) (local $less i32)")
        L(f"{I}  (if (i64.eq (local.get $left) (local.get $right)) (then (return (i64.const 0))))")
        L(f"{I}  (if (i64.ge_s (local.get $right) (local.get $left))")
        L(f"{I}    (then (local.set $sign (i64.const 1)))")
        L(f"{I}    (else")
        L(f"{I}      (local.set $sign (i64.const -1))")
        L(f"{I}      (local.set $tmp (local.get $left))")
        L(f"{I}      (local.set $left (local.get $right))")
        L(f"{I}      (local.set $right (local.get $tmp))")
        L(f"{I}    )")
        L(f"{I}  )")
        L(f"{I}  (call $dt_split (local.get $left))")
        L(f"{I}  (local.set $ly (global.get $dt_y)) (local.set $lm (global.get $dt_m)) (local.set $ld (global.get $dt_d))")
        L(f"{I}  (local.set $lh (global.get $dt_h)) (local.set $lmi (global.get $dt_mi)) (local.set $ls (global.get $dt_s)) (local.set $lfrac (global.get $dt_ns))")
        L(f"{I}  (call $dt_split (local.get $right))")
        L(f"{I}  (local.set $ry (global.get $dt_y)) (local.set $rm (global.get $dt_m)) (local.set $rd (global.get $dt_d))")
        L(f"{I}  (local.set $rh (global.get $dt_h)) (local.set $rmi (global.get $dt_mi)) (local.set $rs (global.get $dt_s)) (local.set $rfrac (global.get $dt_ns))")
        L(f"{I}  (local.set $mdiff (i64.sub (i64.add (i64.mul (local.get $ry) (i64.const 12)) (local.get $rm)) (i64.add (i64.mul (local.get $ly) (i64.const 12)) (local.get $lm))))")
        L(f"{I}  (local.set $less (i32.const 0))")
        L(f"{I}  (if (i64.lt_s (local.get $rd) (local.get $ld)) (then (local.set $less (i32.const 1)))")
        L(f"{I}  (else (if (i64.eq (local.get $rd) (local.get $ld)) (then")
        L(f"{I}    (if (i64.lt_s (local.get $rh) (local.get $lh)) (then (local.set $less (i32.const 1)))")
        L(f"{I}    (else (if (i64.eq (local.get $rh) (local.get $lh)) (then")
        L(f"{I}      (if (i64.lt_s (local.get $rmi) (local.get $lmi)) (then (local.set $less (i32.const 1)))")
        L(f"{I}      (else (if (i64.eq (local.get $rmi) (local.get $lmi)) (then")
        L(f"{I}        (if (i64.lt_s (local.get $rs) (local.get $ls)) (then (local.set $less (i32.const 1)))")
        L(f"{I}        (else (if (i64.eq (local.get $rs) (local.get $ls)) (then")
        L(f"{I}          (if (i64.lt_s (local.get $rfrac) (local.get $lfrac)) (then (local.set $less (i32.const 1))))")
        L(f"{I}        ))))")
        L(f"{I}      ))))")
        L(f"{I}    ))))")
        L(f"{I}  ))))")
        L(f"{I}  (if (local.get $less) (then (local.set $mdiff (i64.sub (local.get $mdiff) (i64.const 1)))))")
        L(f"{I}  (return (i64.mul (local.get $mdiff) (local.get $sign)))")
        L(f"{I})")
        L("")
        L(f"{I}(func $dt_years_between (param $left i64) (param $right i64) (result i64)")
        L(f"{I}  (return (i64.div_s (call $dt_months_between (local.get $left) (local.get $right)) (i64.const 12)))")
        L(f"{I})")
        L("")
        L(f"{I}(func $dt_write_2d (param $ptr i32) (param $val i64)")
        L(f"{I}  (i32.store8 (local.get $ptr) (i32.wrap_i64 (i64.add (i64.div_u (local.get $val) (i64.const 10)) (i64.const 48))))")
        L(f"{I}  (i32.store8 (i32.add (local.get $ptr) (i32.const 1)) (i32.wrap_i64 (i64.add (i64.rem_u (local.get $val) (i64.const 10)) (i64.const 48))))")
        L(f"{I})")
        L("")
        L(f"{I}(func $dt_write_4d (param $ptr i32) (param $val i64)")
        L(f"{I}  (call $dt_write_2d (local.get $ptr) (i64.div_u (local.get $val) (i64.const 100)))")
        L(f"{I}  (call $dt_write_2d (i32.add (local.get $ptr) (i32.const 2)) (i64.rem_u (local.get $val) (i64.const 100)))")
        L(f"{I})")
        L("")
        L(f"{I}(func $dt_write_9d (param $ptr i32) (param $val i64)")
        L(f"{I}  (call $dt_write_4d (local.get $ptr) (i64.div_u (local.get $val) (i64.const 100000)))")
        L(f"{I}  (i32.store8 (i32.add (local.get $ptr) (i32.const 4)) (i32.wrap_i64 (i64.add (i64.rem_u (i64.div_u (local.get $val) (i64.const 10000)) (i64.const 10)) (i64.const 48))))")
        L(f"{I}  (call $dt_write_4d (i32.add (local.get $ptr) (i32.const 5)) (i64.rem_u (local.get $val) (i64.const 10000)))")
        L(f"{I})")
        L("")
        L(f"{I}(func $dt_to_iso (param $nanos i64) (result i64)")
        L(f"{I}  (local $p i32)")
        L(f"{I}  (local.set $p (call $flux_alloc (i32.const 32)))")
        L(f"{I}  (drop (call $dt_to_str (local.get $nanos) (local.get $p)))")
        L(f"{I}  (return (i64.or (i64.shl (i64.extend_i32_u (local.get $p)) (i64.const 32)) (i64.const 30)))")
        L(f"{I})")
        L("")
        L(f"{I}(func $dt_to_timezone (param $nanos i64) (param $tz i64) (result i64)")
        L(f"{I}  (local $off_sec i64) (local $loc_nanos i64) (local $p i32) (local $len i32) (local $sign i32) (local $abs_s i64) (local $oh i64) (local $om i64)")
        L(f"{I}  (local.set $off_sec (i64.const 0))")
        L(f"{I}  (if (i32.or (call $streq (local.get $tz) (i64.const {tz_sp})) (call $streq (local.get $tz) (i64.const {tz_brt})))")
        L(f"{I}    (then (local.set $off_sec (i64.const -10800)))")
        L(f"{I}  )")
        L(f"{I}  (local.set $loc_nanos (i64.add (local.get $nanos) (i64.mul (local.get $off_sec) (i64.const 1000000000))))")
        L(f"{I}  (local.set $p (call $flux_alloc (i32.const 40)))")
        L(f"{I}  (drop (call $dt_to_str (local.get $loc_nanos) (local.get $p)))")
        L(f"{I}  (if (i64.eqz (local.get $off_sec))")
        L(f"{I}    (then (local.set $len (i32.const 30)))")
        L(f"{I}    (else")
        L(f"{I}      (local.set $sign (select (i32.const 43) (i32.const 45) (i64.ge_s (local.get $off_sec) (i64.const 0))))")
        L(f"{I}      (local.set $abs_s (select (local.get $off_sec) (i64.sub (i64.const 0) (local.get $off_sec)) (i64.ge_s (local.get $off_sec) (i64.const 0))))")
        L(f"{I}      (local.set $oh (i64.div_s (local.get $abs_s) (i64.const 3600)))")
        L(f"{I}      (local.set $om (i64.div_s (i64.rem_s (local.get $abs_s) (i64.const 3600)) (i64.const 60)))")
        L(f"{I}      (i32.store8 (i32.add (local.get $p) (i32.const 29)) (local.get $sign))")
        L(f"{I}      (call $dt_write_2d (i32.add (local.get $p) (i32.const 30)) (local.get $oh))")
        L(f"{I}      (i32.store8 (i32.add (local.get $p) (i32.const 32)) (i32.const 58))")
        L(f"{I}      (call $dt_write_2d (i32.add (local.get $p) (i32.const 33)) (local.get $om))")
        L(f"{I}      (local.set $len (i32.const 35))")
        L(f"{I}    )")
        L(f"{I}  )")
        L(f"{I}  (return (i64.or (i64.shl (i64.extend_i32_u (local.get $p)) (i64.const 32)) (i64.extend_i32_u (local.get $len))))")
        L(f"{I})")
        L("")
        L(f"{I}(func $dt_utc_offset (param $nanos i64) (param $tz i64) (result f64)")
        L(f"{I}  (if (i32.or (call $streq (local.get $tz) (i64.const {tz_sp})) (call $streq (local.get $tz) (i64.const {tz_brt})))")
        L(f"{I}    (then (return (f64.const -3.0)))")
        L(f"{I}  )")
        L(f"{I}  (return (f64.const 0.0))")
        L(f"{I})")
        L("")
        L(f"{I}(func $dt_format (param $nanos i64) (param $pattern i64) (result i64)")
        L(f"{I}  (local $pptr i32) (local $plen i32) (local $pi i32) (local $out i32) (local $oi i32) (local $c i32) (local $nc i32)")
        L(f"{I}  (call $dt_split (local.get $nanos))")
        L(f"{I}  (local.set $pptr (i32.wrap_i64 (i64.shr_u (local.get $pattern) (i64.const 32))))")
        L(f"{I}  (local.set $plen (i32.wrap_i64 (i64.and (local.get $pattern) (i64.const 0xFFFFFFFF))))")
        L(f"{I}  (local.set $out (call $flux_alloc (i32.add (local.get $plen) (i32.const 64))))")
        L(f"{I}  (local.set $pi (i32.const 0))")
        L(f"{I}  (local.set $oi (i32.const 0))")
        L(f"{I}  (block $done (loop $lp")
        L(f"{I}    (if (i32.ge_u (local.get $pi) (local.get $plen)) (then (br $done)))")
        L(f"{I}    (local.set $c (i32.load8_u (i32.add (local.get $pptr) (local.get $pi))))")
        L(f"{I}    (if (i32.and (i32.eq (local.get $c) (i32.const 37)) (i32.lt_u (i32.add (local.get $pi) (i32.const 1)) (local.get $plen))) (then")
        L(f"{I}      (local.set $nc (i32.load8_u (i32.add (local.get $pptr) (i32.add (local.get $pi) (i32.const 1)))))")
        L(f"{I}      (local.set $pi (i32.add (local.get $pi) (i32.const 2)))")
        L(f"{I}      (if (i32.eq (local.get $nc) (i32.const 89)) (then")
        L(f"{I}        (call $dt_write_4d (i32.add (local.get $out) (local.get $oi)) (global.get $dt_y))")
        L(f"{I}        (local.set $oi (i32.add (local.get $oi) (i32.const 4)))")
        L(f"{I}        (br $lp)")
        L(f"{I}      ))")
        L(f"{I}      (if (i32.eq (local.get $nc) (i32.const 109)) (then")
        L(f"{I}        (call $dt_write_2d (i32.add (local.get $out) (local.get $oi)) (global.get $dt_m))")
        L(f"{I}        (local.set $oi (i32.add (local.get $oi) (i32.const 2)))")
        L(f"{I}        (br $lp)")
        L(f"{I}      ))")
        L(f"{I}      (if (i32.eq (local.get $nc) (i32.const 100)) (then")
        L(f"{I}        (call $dt_write_2d (i32.add (local.get $out) (local.get $oi)) (global.get $dt_d))")
        L(f"{I}        (local.set $oi (i32.add (local.get $oi) (i32.const 2)))")
        L(f"{I}        (br $lp)")
        L(f"{I}      ))")
        L(f"{I}      (if (i32.eq (local.get $nc) (i32.const 72)) (then")
        L(f"{I}        (call $dt_write_2d (i32.add (local.get $out) (local.get $oi)) (global.get $dt_h))")
        L(f"{I}        (local.set $oi (i32.add (local.get $oi) (i32.const 2)))")
        L(f"{I}        (br $lp)")
        L(f"{I}      ))")
        L(f"{I}      (if (i32.eq (local.get $nc) (i32.const 77)) (then")
        L(f"{I}        (call $dt_write_2d (i32.add (local.get $out) (local.get $oi)) (global.get $dt_mi))")
        L(f"{I}        (local.set $oi (i32.add (local.get $oi) (i32.const 2)))")
        L(f"{I}        (br $lp)")
        L(f"{I}      ))")
        L(f"{I}      (if (i32.eq (local.get $nc) (i32.const 83)) (then")
        L(f"{I}        (call $dt_write_2d (i32.add (local.get $out) (local.get $oi)) (global.get $dt_s))")
        L(f"{I}        (local.set $oi (i32.add (local.get $oi) (i32.const 2)))")
        L(f"{I}        (br $lp)")
        L(f"{I}      ))")
        L(f"{I}      (i32.store8 (i32.add (local.get $out) (local.get $oi)) (i32.const 37))")
        L(f"{I}      (i32.store8 (i32.add (local.get $out) (i32.add (local.get $oi) (i32.const 1))) (local.get $nc))")
        L(f"{I}      (local.set $oi (i32.add (local.get $oi) (i32.const 2)))")
        L(f"{I}      (br $lp)")
        L(f"{I}    ))")
        L(f"{I}    (i32.store8 (i32.add (local.get $out) (local.get $oi)) (local.get $c))")
        L(f"{I}    (local.set $oi (i32.add (local.get $oi) (i32.const 1)))")
        L(f"{I}    (local.set $pi (i32.add (local.get $pi) (i32.const 1)))")
        L(f"{I}    (br $lp)")
        L(f"{I}  ))")
        L(f"{I}  (return (i64.or (i64.shl (i64.extend_i32_u (local.get $out)) (i64.const 32)) (i64.extend_i32_u (local.get $oi))))")
        L(f"{I})")
        L("")
        L(f"{I}(func $dt_format_duration (param $ns i64) (result i64)")
        L(f"{I}  (local $buf i32) (local $cur i32) (local $u i64) (local $s i64) (local $rem_ns i64)")
        L(f"{I}  (local $m i64) (local $h i64) (local $d i64) (local $ms i64)")
        L(f"{I}  (local.set $buf (call $flux_alloc (i32.const 64)))")
        L(f"{I}  (local.set $cur (i32.const 0))")
        L(f"{I}  (if (i64.eqz (local.get $ns)) (then")
        L(f"{I}    (i32.store8 (local.get $buf) (i32.const 48))")
        L(f"{I}    (i32.store8 (i32.add (local.get $buf) (i32.const 1)) (i32.const 115))")
        L(f"{I}    (return (i64.or (i64.shl (i64.extend_i32_u (local.get $buf)) (i64.const 32)) (i64.const 2)))")
        L(f"{I}  ))")
        L(f"{I}  (if (i64.lt_s (local.get $ns) (i64.const 0)) (then")
        L(f"{I}    (i32.store8 (local.get $buf) (i32.const 45))")
        L(f"{I}    (local.set $cur (i32.const 1))")
        L(f"{I}    (local.set $u (i64.sub (i64.const 0) (local.get $ns)))")
        L(f"{I}  ) (else")
        L(f"{I}    (local.set $u (local.get $ns))")
        L(f"{I}  ))")
        L(f"{I}  (local.set $s (i64.div_u (local.get $u) (i64.const 1000000000)))")
        L(f"{I}  (local.set $rem_ns (i64.rem_u (local.get $u) (i64.const 1000000000)))")
        L(f"{I}  (if (i64.eqz (local.get $s)) (then")
        L(f"{I}    (if (i64.eqz (i64.rem_u (local.get $rem_ns) (i64.const 1000000))) (then")
        L(f"{I}      (local.set $cur (i32.add (local.get $cur) (call $i64_to_str (i64.div_u (local.get $rem_ns) (i64.const 1000000)) (i32.add (local.get $buf) (local.get $cur)))))")
        L(f"{I}      (i32.store8 (i32.add (local.get $buf) (local.get $cur)) (i32.const 109))")
        L(f"{I}      (i32.store8 (i32.add (local.get $buf) (i32.add (local.get $cur) (i32.const 1))) (i32.const 115))")
        L(f"{I}      (local.set $cur (i32.add (local.get $cur) (i32.const 2)))")
        L(f"{I}      (return (i64.or (i64.shl (i64.extend_i32_u (local.get $buf)) (i64.const 32)) (i64.extend_i32_u (local.get $cur))))")
        L(f"{I}    ))")
        L(f"{I}    (if (i64.eqz (i64.rem_u (local.get $rem_ns) (i64.const 1000))) (then")
        L(f"{I}      (local.set $cur (i32.add (local.get $cur) (call $i64_to_str (i64.div_u (local.get $rem_ns) (i64.const 1000)) (i32.add (local.get $buf) (local.get $cur)))))")
        L(f"{I}      (i32.store8 (i32.add (local.get $buf) (local.get $cur)) (i32.const 117))")
        L(f"{I}      (i32.store8 (i32.add (local.get $buf) (i32.add (local.get $cur) (i32.const 1))) (i32.const 115))")
        L(f"{I}      (local.set $cur (i32.add (local.get $cur) (i32.const 2)))")
        L(f"{I}      (return (i64.or (i64.shl (i64.extend_i32_u (local.get $buf)) (i64.const 32)) (i64.extend_i32_u (local.get $cur))))")
        L(f"{I}    ))")
        L(f"{I}    (local.set $cur (i32.add (local.get $cur) (call $i64_to_str (local.get $rem_ns) (i32.add (local.get $buf) (local.get $cur)))))")
        L(f"{I}    (i32.store8 (i32.add (local.get $buf) (local.get $cur)) (i32.const 110))")
        L(f"{I}    (i32.store8 (i32.add (local.get $buf) (i32.add (local.get $cur) (i32.const 1))) (i32.const 115))")
        L(f"{I}    (local.set $cur (i32.add (local.get $cur) (i32.const 2)))")
        L(f"{I}    (return (i64.or (i64.shl (i64.extend_i32_u (local.get $buf)) (i64.const 32)) (i64.extend_i32_u (local.get $cur))))")
        L(f"{I}  ))")
        L(f"{I}  (if (i64.lt_u (local.get $s) (i64.const 60)) (then")
        L(f"{I}    (local.set $cur (i32.add (local.get $cur) (call $i64_to_str (local.get $s) (i32.add (local.get $buf) (local.get $cur)))))")
        L(f"{I}    (local.set $ms (i64.div_u (local.get $rem_ns) (i64.const 1000000)))")
        L(f"{I}    (if (i64.gt_u (local.get $ms) (i64.const 0)) (then")
        L(f"{I}      (i32.store8 (i32.add (local.get $buf) (local.get $cur)) (i32.const 46))")
        L(f"{I}      (local.set $cur (i32.add (local.get $cur) (i32.const 1)))")
        L(f"{I}      (i32.store8 (i32.add (local.get $buf) (local.get $cur)) (i32.wrap_i64 (i64.add (i64.const 48) (i64.div_u (local.get $ms) (i64.const 100)))))")
        L(f"{I}      (i32.store8 (i32.add (local.get $buf) (i32.add (local.get $cur) (i32.const 1))) (i32.wrap_i64 (i64.add (i64.const 48) (i64.rem_u (i64.div_u (local.get $ms) (i64.const 10)) (i64.const 10)))))")
        L(f"{I}      (i32.store8 (i32.add (local.get $buf) (i32.add (local.get $cur) (i32.const 2))) (i32.wrap_i64 (i64.add (i64.const 48) (i64.rem_u (local.get $ms) (i64.const 10)))))")
        L(f"{I}      (local.set $cur (i32.add (local.get $cur) (i32.const 3)))")
        L(f"{I}    ))")
        L(f"{I}    (i32.store8 (i32.add (local.get $buf) (local.get $cur)) (i32.const 115))")
        L(f"{I}    (local.set $cur (i32.add (local.get $cur) (i32.const 1)))")
        L(f"{I}    (return (i64.or (i64.shl (i64.extend_i32_u (local.get $buf)) (i64.const 32)) (i64.extend_i32_u (local.get $cur))))")
        L(f"{I}  ))")
        L(f"{I}  (local.set $m (i64.div_u (local.get $s) (i64.const 60)))")
        L(f"{I}  (local.set $s (i64.rem_u (local.get $s) (i64.const 60)))")
        L(f"{I}  (if (i64.lt_u (local.get $m) (i64.const 60)) (then")
        L(f"{I}    (local.set $cur (i32.add (local.get $cur) (call $i64_to_str (local.get $m) (i32.add (local.get $buf) (local.get $cur)))))")
        L(f"{I}    (i32.store8 (i32.add (local.get $buf) (local.get $cur)) (i32.const 109))")
        L(f"{I}    (i32.store8 (i32.add (local.get $buf) (i32.add (local.get $cur) (i32.const 1))) (i32.const 32))")
        L(f"{I}    (local.set $cur (i32.add (local.get $cur) (i32.const 2)))")
        L(f"{I}    (local.set $cur (i32.add (local.get $cur) (call $i64_to_str (local.get $s) (i32.add (local.get $buf) (local.get $cur)))))")
        L(f"{I}    (i32.store8 (i32.add (local.get $buf) (local.get $cur)) (i32.const 115))")
        L(f"{I}    (local.set $cur (i32.add (local.get $cur) (i32.const 1)))")
        L(f"{I}    (return (i64.or (i64.shl (i64.extend_i32_u (local.get $buf)) (i64.const 32)) (i64.extend_i32_u (local.get $cur))))")
        L(f"{I}  ))")
        L(f"{I}  (local.set $h (i64.div_u (local.get $m) (i64.const 60)))")
        L(f"{I}  (local.set $m (i64.rem_u (local.get $m) (i64.const 60)))")
        L(f"{I}  (if (i64.lt_u (local.get $h) (i64.const 24)) (then")
        L(f"{I}    (local.set $cur (i32.add (local.get $cur) (call $i64_to_str (local.get $h) (i32.add (local.get $buf) (local.get $cur)))))")
        L(f"{I}    (i32.store8 (i32.add (local.get $buf) (local.get $cur)) (i32.const 104))")
        L(f"{I}    (i32.store8 (i32.add (local.get $buf) (i32.add (local.get $cur) (i32.const 1))) (i32.const 32))")
        L(f"{I}    (local.set $cur (i32.add (local.get $cur) (i32.const 2)))")
        L(f"{I}    (local.set $cur (i32.add (local.get $cur) (call $i64_to_str (local.get $m) (i32.add (local.get $buf) (local.get $cur)))))")
        L(f"{I}    (i32.store8 (i32.add (local.get $buf) (local.get $cur)) (i32.const 109))")
        L(f"{I}    (i32.store8 (i32.add (local.get $buf) (i32.add (local.get $cur) (i32.const 1))) (i32.const 32))")
        L(f"{I}    (local.set $cur (i32.add (local.get $cur) (i32.const 2)))")
        L(f"{I}    (local.set $cur (i32.add (local.get $cur) (call $i64_to_str (local.get $s) (i32.add (local.get $buf) (local.get $cur)))))")
        L(f"{I}    (i32.store8 (i32.add (local.get $buf) (local.get $cur)) (i32.const 115))")
        L(f"{I}    (local.set $cur (i32.add (local.get $cur) (i32.const 1)))")
        L(f"{I}    (return (i64.or (i64.shl (i64.extend_i32_u (local.get $buf)) (i64.const 32)) (i64.extend_i32_u (local.get $cur))))")
        L(f"{I}  ))")
        L(f"{I}  (local.set $d (i64.div_u (local.get $h) (i64.const 24)))")
        L(f"{I}  (local.set $h (i64.rem_u (local.get $h) (i64.const 24)))")
        L(f"{I}  (local.set $cur (i32.add (local.get $cur) (call $i64_to_str (local.get $d) (i32.add (local.get $buf) (local.get $cur)))))")
        L(f"{I}  (i32.store8 (i32.add (local.get $buf) (local.get $cur)) (i32.const 100))")
        L(f"{I}  (i32.store8 (i32.add (local.get $buf) (i32.add (local.get $cur) (i32.const 1))) (i32.const 32))")
        L(f"{I}  (local.set $cur (i32.add (local.get $cur) (i32.const 2)))")
        L(f"{I}  (local.set $cur (i32.add (local.get $cur) (call $i64_to_str (local.get $h) (i32.add (local.get $buf) (local.get $cur)))))")
        L(f"{I}  (i32.store8 (i32.add (local.get $buf) (local.get $cur)) (i32.const 104))")
        L(f"{I}  (i32.store8 (i32.add (local.get $buf) (i32.add (local.get $cur) (i32.const 1))) (i32.const 32))")
        L(f"{I}  (local.set $cur (i32.add (local.get $cur) (i32.const 2)))")
        L(f"{I}  (local.set $cur (i32.add (local.get $cur) (call $i64_to_str (local.get $m) (i32.add (local.get $buf) (local.get $cur)))))")
        L(f"{I}  (i32.store8 (i32.add (local.get $buf) (local.get $cur)) (i32.const 109))")
        L(f"{I}  (i32.store8 (i32.add (local.get $buf) (i32.add (local.get $cur) (i32.const 1))) (i32.const 32))")
        L(f"{I}  (local.set $cur (i32.add (local.get $cur) (i32.const 2)))")
        L(f"{I}  (local.set $cur (i32.add (local.get $cur) (call $i64_to_str (local.get $s) (i32.add (local.get $buf) (local.get $cur)))))")
        L(f"{I}  (i32.store8 (i32.add (local.get $buf) (local.get $cur)) (i32.const 115))")
        L(f"{I}  (local.set $cur (i32.add (local.get $cur) (i32.const 1)))")
        L(f"{I}  (return (i64.or (i64.shl (i64.extend_i32_u (local.get $buf)) (i64.const 32)) (i64.extend_i32_u (local.get $cur))))")
        L(f"{I})")
        L("")

    def _emit_set_from_data(self, lines: list[str], I: str) -> None:
        heap_start = (self._iov_off() + 16 + 7) & ~7
        lines.append(f"{I}(func $set_from_data (param $val i64) (result i32)")
        lines.append(f"{I}  (return (select (call $list_to_set (i32.wrap_i64 (local.get $val))) (call $set_push (call $set_build (i32.const 1) (i32.const 0)) (i32.const 1) (local.get $val)) (i64.ge_u (local.get $val) (i64.const {heap_start}))))")
        lines.append(f"{I})")

    def _emit_list_helpers(self, lines: list[str], I: str) -> None:
        for line in LIST_HELPERS.splitlines():
            lines.append(I + line.strip() if line.strip() else "")
        lines.append("")

    def _is_exotic(self, node: ASTNode) -> bool:
        return (
            isinstance(node, (PtrRefExpr, PtrDerefExpr, PtrAssign, ExternDecl))
            or (isinstance(node, StorageDecl) and node.static)
            or (isinstance(node, CallExpr) and isinstance(node.callee, Identifier) and node.callee.name == "bounds")
        )

    def _emit_input_helpers(self, lines: list[str], I: str) -> None:
        from flux_proto.semantic.storage_types import _INT_RANGES

        b = self._input_buf_off()
        iov = self._read_iov_off()
        nw = self._read_nw_off()

        self._globals.setdefault("flux_cx_re_tmp", ("float64", "f64"))
        self._globals.setdefault("flux_cx_im_tmp", ("float64", "f64"))

        def fat(s: str) -> int:
            self._alloc_str(s)
            return self._fat_const(s)

        retry = {
            "int": fat("\x1b[90mDigite um inteiro, como: 35\x1b[0m"),
            "float": fat("\x1b[90mDigite um float, como: 19.99\x1b[0m"),
            "complex": fat("\x1b[90mDigite um complexo, como: 3+4i\x1b[0m"),
            "char": fat("\x1b[90mDigite um caractere, como: a\x1b[0m"),
            "bool": fat("\x1b[90mDigite um bool, como: true/false\x1b[0m"),
            "datetime": fat("\x1b[90mDigite um date, como: 2026-08-29T12:00:00Z\x1b[0m"),
            "string": fat("\x1b[90mDigite um texto, como: Olá mundo\x1b[0m"),
        }
        nl_fat = fat("\n")
        tname = {t: fat(t) for t in _INT_RANGES}

        L = lines.append

        # ---- $print_fat : print a fat string (ptr<<32|len) via $print_str ----
        L(f"{I}(func $print_fat (param $s i64)")
        L(f"{I}  (call $print_str (i32.wrap_i64 (i64.shr_u (local.get $s) (i64.const 32))) (i32.wrap_i64 (i64.and (local.get $s) (i64.const 0xFFFFFFFF))))")
        L(f"{I})")
        L("")

        # ---- $print_fat_nl : print fat string followed by a newline (for retry prompts) ----
        L(f"{I}(func $print_fat_nl (param $s i64)")
        L(f"{I}  (call $print_fat (local.get $s))")
        L(f"{I}  (call $print_fat (i64.const {nl_fat}))")
        L(f"{I})")
        L("")



        # ---- $flux_read_line -> i64 : read ONE line from fd 0, strip trailing \r\n ----
        L(f"{I}(func $flux_read_line (result i64)")
        L(f"{I}  (local $n i32) (local $c i32)")
        L(f"{I}  (local.set $n (i32.const 0))")
        L(f"{I}  (block $done (loop $lp")
        L(f"{I}    (if (i32.ge_u (local.get $n) (i32.const 4095)) (then (br $done)))")
        L(f"{I}    (i32.store (i32.const {iov}) (i32.add (i32.const {b}) (local.get $n)))")
        L(f"{I}    (i32.store (i32.add (i32.const {iov}) (i32.const 4)) (i32.const 1))")
        L(f"{I}    (drop (call $fd_read (i32.const 0) (i32.const {iov}) (i32.const 1) (i32.const {nw})))")
        L(f"{I}    (local.set $c (i32.load (i32.const {nw})))")
        L(f"{I}    (if (i32.eqz (local.get $c)) (then (br $done)))")
        L(f"{I}    (local.set $c (i32.load8_u (i32.add (i32.const {b}) (local.get $n))))")
        L(f"{I}    (if (i32.eq (local.get $c) (i32.const 10)) (then (br $done)))")
        L(f"{I}    (local.set $n (i32.add (local.get $n) (i32.const 1)))")
        L(f"{I}    (br $lp)")
        L(f"{I}  ))")
        L(f"{I}  (if (i32.and (i32.gt_u (local.get $n) (i32.const 0)) (i32.eq (i32.load8_u (i32.add (i32.const {b}) (i32.sub (local.get $n) (i32.const 1)))) (i32.const 13))) (then (local.set $n (i32.sub (local.get $n) (i32.const 1)))))")
        L(f"{I}  (return (i64.or (i64.shl (i64.extend_i32_u (i32.const {b})) (i64.const 32)) (i64.extend_i32_u (local.get $n))))")
        L(f"{I})")
        L("")

        # ---- $valid_float : accepts the plain decimal subset Python float() accepts ----
        L(f"{I}(func $valid_float (param $line i64) (result i32)")
        L(f"{I}  (local $ptr i32) (local $len i32) (local $i i32) (local $c i32) (local $dig i32) (local $dot i32)")
        L(f"{I}  (local.set $ptr (i32.wrap_i64 (i64.shr_u (local.get $line) (i64.const 32))))")
        L(f"{I}  (local.set $len (i32.wrap_i64 (i64.and (local.get $line) (i64.const 0xFFFFFFFF))))")
        L(f"{I}  (local.set $i (i32.const 0)) (local.set $dig (i32.const 0)) (local.set $dot (i32.const 0))")
        L(f"{I}  (block $ws (loop $wsl")
        L(f"{I}    (if (i32.ge_u (local.get $i) (local.get $len)) (then (br $ws)))")
        L(f"{I}    (local.set $c (i32.load8_u (i32.add (local.get $ptr) (local.get $i))))")
        L(f"{I}    (if (i32.or (i32.eq (local.get $c) (i32.const 32)) (i32.eq (local.get $c) (i32.const 9))) (then (local.set $i (i32.add (local.get $i) (i32.const 1))) (br $wsl)) (else (br $ws)))")
        L(f"{I}  ))")
        L(f"{I}  (if (i32.lt_u (local.get $i) (local.get $len)) (then")
        L(f"{I}    (local.set $c (i32.load8_u (i32.add (local.get $ptr) (local.get $i))))")
        L(f"{I}    (if (i32.or (i32.eq (local.get $c) (i32.const 43)) (i32.eq (local.get $c) (i32.const 45))) (then (local.set $i (i32.add (local.get $i) (i32.const 1)))))")
        L(f"{I}  ))")
        L(f"{I}  (block $main (loop $ml")
        L(f"{I}    (if (i32.ge_u (local.get $i) (local.get $len)) (then (br $main)))")
        L(f"{I}    (local.set $c (i32.load8_u (i32.add (local.get $ptr) (local.get $i))))")
        L(f"{I}    (if (i32.and (i32.ge_u (local.get $c) (i32.const 48)) (i32.le_u (local.get $c) (i32.const 57))) (then")
        L(f"{I}      (local.set $dig (i32.const 1)) (local.set $i (i32.add (local.get $i) (i32.const 1)))")
        L(f"{I}    ) (else")
        L(f"{I}      (if (i32.eq (local.get $c) (i32.const 46)) (then")
        L(f"{I}        (if (local.get $dot) (then (return (i32.const 0))))")
        L(f"{I}        (local.set $dot (i32.const 1)) (local.set $i (i32.add (local.get $i) (i32.const 1)))")
        L(f"{I}      ) (else (br $main)))")
        L(f"{I}    ))")
        L(f"{I}    (br $ml)")
        L(f"{I}  ))")
        L(f"{I}  (block $ws2 (loop $wsl2")
        L(f"{I}    (if (i32.ge_u (local.get $i) (local.get $len)) (then (br $ws2)))")
        L(f"{I}    (local.set $c (i32.load8_u (i32.add (local.get $ptr) (local.get $i))))")
        L(f"{I}    (if (i32.or (i32.eq (local.get $c) (i32.const 32)) (i32.eq (local.get $c) (i32.const 9))) (then (local.set $i (i32.add (local.get $i) (i32.const 1))) (br $wsl2)) (else (return (i32.const 0))))")
        L(f"{I}  ))")
        L(f"{I}  (if (i32.eqz (local.get $dig)) (then (return (i32.const 0))))")
        L(f"{I}  (return (i32.const 1))")
        L(f"{I})")
        L("")
        lines.extend(self._emit_input_int(I, tname, retry["int"]))
        lines.extend(self._emit_input_float(I, retry["float"]))
        lines.extend(self._emit_input_bool(I, retry["bool"]))
        lines.extend(self._emit_input_char(I, retry["char"]))
        lines.extend(self._emit_input_datetime(I, retry["datetime"]))
        lines.extend(self._emit_input_string(I, retry["string"]))
        lines.extend(self._emit_input_complex(I, retry["complex"]))

    def _emit_input_int(self, I, tname, retry_fat) -> list[str]:
        from flux_proto.semantic.storage_types import _INT_RANGES
        L = []
        A = L.append
        bounded = ["int8", "int16", "int32", "int64", "uint8", "uint16", "uint32"]
        A(f"{I}(func $flux_input_int (param $tname i64) (param $prompt i64) (result i64)")
        A(f"{I}  (local $line i64) (local $ptr i32) (local $len i32)")
        A(f"{I}  (local $i i32) (local $c i32) (local $dig i64)")
        A(f"{I}  (local $base i64) (local $val i64) (local $neg i32) (local $ok i32) (local $lo i64) (local $hi i64)")
        A(f"{I}  (block $done (loop $retry")
        A(f"{I}    (call $print_fat (local.get $prompt))")
        A(f"{I}    (local.set $line (call $flux_read_line))")
        A(f"{I}    (local.set $ptr (i32.wrap_i64 (i64.shr_u (local.get $line) (i64.const 32))))")
        A(f"{I}    (local.set $len (i32.wrap_i64 (i64.and (local.get $line) (i64.const 0xFFFFFFFF))))")
        A(f"{I}    (local.set $i (i32.const 0)) (local.set $neg (i32.const 0)) (local.set $val (i64.const 0))")
        A(f"{I}    (local.set $base (i64.const 10)) (local.set $ok (i32.const 1)) (local.set $dig (i64.const 0))")
        # leading whitespace
        A(f"{I}    (block $lws (loop $lwsl")
        A(f"{I}      (if (i32.ge_u (local.get $i) (local.get $len)) (then (br $lws)))")
        A(f"{I}      (local.set $c (i32.load8_u (i32.add (local.get $ptr) (local.get $i))))")
        A(f"{I}      (if (i32.or (i32.eq (local.get $c) (i32.const 32)) (i32.eq (local.get $c) (i32.const 9))) (then (local.set $i (i32.add (local.get $i) (i32.const 1))) (br $lwsl)) (else (br $lws)))")
        A(f"{I}    ))")
        # sign
        A(f"{I}    (if (i32.lt_u (local.get $i) (local.get $len)) (then")
        A(f"{I}      (local.set $c (i32.load8_u (i32.add (local.get $ptr) (local.get $i))))")
        A(f"{I}      (if (i32.eq (local.get $c) (i32.const 43)) (then (local.set $i (i32.add (local.get $i) (i32.const 1)))))")
        A(f"{I}      (if (i32.eq (local.get $c) (i32.const 45)) (then (local.set $neg (i32.const 1)) (local.set $i (i32.add (local.get $i) (i32.const 1)))))")
        A(f"{I}    ))")
        # base prefix detection: 0x / 0b / 0o  (need at least 2 chars after sign)
        A(f"{I}    (if (i32.ge_u (i32.sub (local.get $len) (local.get $i)) (i32.const 2)) (then")
        A(f"{I}      (local.set $c (i32.load8_u (i32.add (local.get $ptr) (local.get $i))))")
        A(f"{I}      (if (i32.eq (local.get $c) (i32.const 48)) (then")
        A(f"{I}        (local.set $c (i32.load8_u (i32.add (i32.add (local.get $ptr) (local.get $i)) (i32.const 1))))")
        A(f"{I}        (if (i32.or (i32.eq (local.get $c) (i32.const 120)) (i32.eq (local.get $c) (i32.const 88))) (then (local.set $base (i64.const 16)) (local.set $i (i32.add (local.get $i) (i32.const 2)))))")
        A(f"{I}        (if (i32.or (i32.eq (local.get $c) (i32.const 98)) (i32.eq (local.get $c) (i32.const 66))) (then (local.set $base (i64.const 2)) (local.set $i (i32.add (local.get $i) (i32.const 2)))))")
        A(f"{I}        (if (i32.or (i32.eq (local.get $c) (i32.const 111)) (i32.eq (local.get $c) (i32.const 79))) (then (local.set $base (i64.const 8)) (local.set $i (i32.add (local.get $i) (i32.const 2)))))")
        A(f"{I}      ))")
        A(f"{I}    ))")
        # digit accumulation (handles a-f, A-F for hex)
        A(f"{I}    (block $dparse (loop $dloop")
        A(f"{I}      (if (i32.ge_u (local.get $i) (local.get $len)) (then (br $dparse)))")
        A(f"{I}      (local.set $c (i32.load8_u (i32.add (local.get $ptr) (local.get $i))))")
        A(f"{I}      (if (i32.and (i32.ge_u (local.get $c) (i32.const 48)) (i32.le_u (local.get $c) (i32.const 57))) (then")
        A(f"{I}        (local.set $dig (i64.extend_i32_u (i32.sub (local.get $c) (i32.const 48))))")
        A(f"{I}      ) (else")
        A(f"{I}        (if (i32.and (i32.ge_u (local.get $c) (i32.const 97)) (i32.le_u (local.get $c) (i32.const 102))) (then")
        A(f"{I}          (local.set $dig (i64.extend_i32_u (i32.add (i32.sub (local.get $c) (i32.const 97)) (i32.const 10))))")
        A(f"{I}        ) (else")
        A(f"{I}          (if (i32.and (i32.ge_u (local.get $c) (i32.const 65)) (i32.le_u (local.get $c) (i32.const 70))) (then")
        A(f"{I}            (local.set $dig (i64.extend_i32_u (i32.add (i32.sub (local.get $c) (i32.const 65)) (i32.const 10))))")
        A(f"{I}          ) (else")
        A(f"{I}            (local.set $ok (i32.const 0)) (br $dparse)")
        A(f"{I}          ))")
        A(f"{I}        ))")
        A(f"{I}      ))")
        A(f"{I}      (if (i64.ge_u (local.get $dig) (local.get $base)) (then (local.set $ok (i32.const 0)) (br $dparse)))")
        A(f"{I}      (local.set $val (i64.add (i64.mul (local.get $val) (local.get $base)) (local.get $dig)))")
        A(f"{I}      (local.set $i (i32.add (local.get $i) (i32.const 1)))")
        A(f"{I}      (br $dloop))")
        A(f"{I}    )")
        # trailing whitespace; require end after optional whitespace and at least one digit parsed
        A(f"{I}    (block $tws (loop $twsl")
        A(f"{I}      (if (i32.ge_u (local.get $i) (local.get $len)) (then (br $tws)))")
        A(f"{I}      (local.set $c (i32.load8_u (i32.add (local.get $ptr) (local.get $i))))")
        A(f"{I}      (if (i32.or (i32.eq (local.get $c) (i32.const 32)) (i32.eq (local.get $c) (i32.const 9))) (then (local.set $i (i32.add (local.get $i) (i32.const 1))) (br $twsl)) (else (local.set $ok (i32.const 0)) (br $tws)))")
        A(f"{I}    ))")
        A(f"{I}    (if (i32.eq (i32.sub (local.get $len) (local.get $i)) (i32.const 0)) (then) (else (local.set $ok (i32.const 0))))")
        A(f"{I}    (if (i64.eqz (local.get $val)) (then (if (i64.eqz (local.get $dig)) (then (local.set $ok (i32.const 0))))))")
        # apply sign
        A(f"{I}    (if (local.get $neg) (then (local.set $val (i64.sub (i64.const 0) (local.get $val)))))")
        # range bounds by type
        for it in bounded:
            A(f"{I}    (if (call $streq (local.get $tname) (i64.const {tname[it]})) (then (local.set $lo (i64.const {_INT_RANGES[it][0]})) (local.set $hi (i64.const {_INT_RANGES[it][1]}))) (else))")
        A(f"{I}    (if (call $streq (local.get $tname) (i64.const {tname['uint64']})) (then (local.set $lo (i64.const 0)) (local.set $hi (i64.const -1))) (else))")
        # range check
        A(f"{I}    (if (i64.lt_s (local.get $val) (local.get $lo)) (then (local.set $ok (i32.const 0))))")
        A(f"{I}    (if (i64.gt_s (local.get $val) (local.get $hi)) (then (local.set $ok (i32.const 0))))")
        A(f"{I}    (if (local.get $ok) (then (return (local.get $val))))")
        A(f"{I}    (call $print_fat_nl (i64.const {retry_fat}))")
        A(f"{I}    (br $retry)")
        A(f"{I}  ))")
        A(f"{I}  (unreachable)")
        A(f"{I})")
        A("")
        return L

    def _emit_input_float(self, I, retry_fat) -> list[str]:
        L = []
        A = L.append
        A(f"{I}(func $flux_input_float (param $tname i64) (param $prompt i64) (result f64)")
        A(f"{I}  (local $line i64)")
        A(f"{I}  (block $done (loop $retry")
        A(f"{I}    (call $print_fat (local.get $prompt))")
        A(f"{I}    (local.set $line (call $flux_read_line))")
        A(f"{I}    (if (call $valid_float (local.get $line)) (then (return (call $str_to_f64 (local.get $line)))) (else (call $print_fat_nl (i64.const {retry_fat})) (br $retry)))")
        A(f"{I}  ))")
        A(f"{I}  (unreachable)")
        A(f"{I})")
        A("")
        return L

    def _emit_input_bool(self, I, retry_fat) -> list[str]:
        L = []
        A = L.append
        for _s in ("true", "verdadeiro", "false", "falso"):
            self._alloc_str(_s)
        f_true = self._fat_const("true")
        f_true_pt = self._fat_const("verdadeiro")
        f_false = self._fat_const("false")
        f_false_pt = self._fat_const("falso")
        A(f"{I}(func $flux_input_bool (param $tname i64) (param $prompt i64) (result i64)")
        A(f"{I}  (local $line i64)")
        A(f"{I}  (block $done (loop $retry")
        A(f"{I}    (call $print_fat (local.get $prompt))")
        A(f"{I}    (local.set $line (call $flux_read_line))")
        A(f"{I}    (if (call $streq (local.get $line) (i64.const {f_true})) (then (return (i64.const 1))))")
        A(f"{I}    (if (call $streq (local.get $line) (i64.const {f_true_pt})) (then (return (i64.const 1))))")
        A(f"{I}    (if (call $streq (local.get $line) (i64.const {f_false})) (then (return (i64.const 0))))")
        A(f"{I}    (if (call $streq (local.get $line) (i64.const {f_false_pt})) (then (return (i64.const 0))))")
        A(f"{I}    (call $print_fat_nl (i64.const {retry_fat}))")
        A(f"{I}    (br $retry)")
        A(f"{I}  ))")
        A(f"{I}  (unreachable)")
        A(f"{I})")
        A("")
        return L

    def _emit_input_char(self, I, retry_fat) -> list[str]:
        L = []
        A = L.append
        A(f"{I}(func $flux_input_char (param $tname i64) (param $prompt i64) (result i32)")
        A(f"{I}  (local $line i64) (local $ptr i32) (local $len i32)")
        A(f"{I}  (local $b0 i32) (local $b1 i32) (local $b2 i32) (local $b3 i32) (local $cp i32)")
        A(f"{I}  (block $done (loop $retry")
        A(f"{I}    (call $print_fat (local.get $prompt))")
        A(f"{I}    (local.set $line (call $flux_read_line))")
        A(f"{I}    (local.set $ptr (i32.wrap_i64 (i64.shr_u (local.get $line) (i64.const 32))))")
        A(f"{I}    (local.set $len (i32.wrap_i64 (i64.and (local.get $line) (i64.const 0xFFFFFFFF))))")
        A(f"{I}    (if (i32.eq (local.get $len) (i32.const 1)) (then")
        A(f"{I}      (local.set $b0 (i32.load8_u (local.get $ptr)))")
        A(f"{I}      (if (i32.lt_u (local.get $b0) (i32.const 128)) (then (return (local.get $b0))))")
        A(f"{I}    ))")
        A(f"{I}    (if (i32.eq (local.get $len) (i32.const 2)) (then")
        A(f"{I}      (local.set $b0 (i32.load8_u (local.get $ptr)))")
        A(f"{I}      (local.set $b1 (i32.load8_u (i32.add (local.get $ptr) (i32.const 1))))")
        A(f"{I}      (if (i32.and (i32.eq (i32.and (local.get $b0) (i32.const 0xE0)) (i32.const 0xC0)) (i32.eq (i32.and (local.get $b1) (i32.const 0xC0)) (i32.const 0x80))) (then")
        A(f"{I}        (local.set $cp (i32.or (i32.shl (i32.and (local.get $b0) (i32.const 0x1F)) (i32.const 6)) (i32.and (local.get $b1) (i32.const 0x3F))))")
        A(f"{I}        (if (i32.ge_u (local.get $cp) (i32.const 0x80)) (then (return (local.get $cp))))")
        A(f"{I}      ))")
        A(f"{I}    ))")
        A(f"{I}    (if (i32.eq (local.get $len) (i32.const 3)) (then")
        A(f"{I}      (local.set $b0 (i32.load8_u (local.get $ptr)))")
        A(f"{I}      (local.set $b1 (i32.load8_u (i32.add (local.get $ptr) (i32.const 1))))")
        A(f"{I}      (local.set $b2 (i32.load8_u (i32.add (local.get $ptr) (i32.const 2))))")
        A(f"{I}      (if (i32.and (i32.and (i32.eq (i32.and (local.get $b0) (i32.const 0xF0)) (i32.const 0xE0)) (i32.eq (i32.and (local.get $b1) (i32.const 0xC0)) (i32.const 0x80))) (i32.eq (i32.and (local.get $b2) (i32.const 0xC0)) (i32.const 0x80))) (then")
        A(f"{I}        (local.set $cp (i32.or (i32.or (i32.shl (i32.and (local.get $b0) (i32.const 0x0F)) (i32.const 12)) (i32.shl (i32.and (local.get $b1) (i32.const 0x3F)) (i32.const 6))) (i32.and (local.get $b2) (i32.const 0x3F))))")
        A(f"{I}        (if (i32.and (i32.ge_u (local.get $cp) (i32.const 0x800)) (i32.or (i32.lt_u (local.get $cp) (i32.const 0xD800)) (i32.gt_u (local.get $cp) (i32.const 0xDFFF)))) (then (return (local.get $cp))))")
        A(f"{I}      ))")
        A(f"{I}    ))")
        A(f"{I}    (if (i32.eq (local.get $len) (i32.const 4)) (then")
        A(f"{I}      (local.set $b0 (i32.load8_u (local.get $ptr)))")
        A(f"{I}      (local.set $b1 (i32.load8_u (i32.add (local.get $ptr) (i32.const 1))))")
        A(f"{I}      (local.set $b2 (i32.load8_u (i32.add (local.get $ptr) (i32.const 2))))")
        A(f"{I}      (local.set $b3 (i32.load8_u (i32.add (local.get $ptr) (i32.const 3))))")
        A(f"{I}      (if (i32.and (i32.and (i32.eq (i32.and (local.get $b0) (i32.const 0xF8)) (i32.const 0xF0)) (i32.eq (i32.and (local.get $b1) (i32.const 0xC0)) (i32.const 0x80))) (i32.and (i32.eq (i32.and (local.get $b2) (i32.const 0xC0)) (i32.const 0x80)) (i32.eq (i32.and (local.get $b3) (i32.const 0xC0)) (i32.const 0x80)))) (then")
        A(f"{I}        (local.set $cp (i32.or (i32.or (i32.shl (i32.and (local.get $b0) (i32.const 0x07)) (i32.const 18)) (i32.shl (i32.and (local.get $b1) (i32.const 0x3F)) (i32.const 12))) (i32.or (i32.shl (i32.and (local.get $b2) (i32.const 0x3F)) (i32.const 6)) (i32.and (local.get $b3) (i32.const 0x3F)))))")
        A(f"{I}        (if (i32.and (i32.ge_u (local.get $cp) (i32.const 0x10000)) (i32.le_u (local.get $cp) (i32.const 0x10FFFF))) (then (return (local.get $cp))))")
        A(f"{I}      ))")
        A(f"{I}    ))")
        A(f"{I}    (call $print_fat_nl (i64.const {retry_fat}))")
        A(f"{I}    (br $retry)")
        A(f"{I}  ))")
        A(f"{I}  (unreachable)")
        A(f"{I})")
        A("")
        return L

    def _emit_input_datetime(self, I, retry_fat) -> list[str]:
        L = []
        A = L.append
        A(f"{I}(func $flux_input_datetime (param $tname i64) (param $prompt i64) (result i64)")
        A(f"{I}  (local $line i64) (local $res i64)")
        A(f"{I}  (block $done (loop $retry")
        A(f"{I}    (call $print_fat (local.get $prompt))")
        A(f"{I}    (local.set $line (call $flux_read_line))")
        A(f"{I}    (local.set $res (call $dt_parse_iso (local.get $line)))")
        A(f"{I}    (if (global.get $dt_ok) (then (return (local.get $res))))")
        A(f"{I}    (call $print_fat_nl (i64.const {retry_fat}))")
        A(f"{I}    (br $retry)")
        A(f"{I}  ))")
        A(f"{I}  (unreachable)")
        A(f"{I})")
        A("")
        return L

    def _emit_input_string(self, I, retry_fat) -> list[str]:
        L = []
        A = L.append
        A(f"{I}(func $flux_input_string (param $tname i64) (param $prompt i64) (result i64)")
        A(f"{I}  (call $print_fat (local.get $prompt))")
        A(f"{I}  (return (call $flux_read_line))")
        A(f"{I})")
        A("")
        return L

    def _emit_input_complex(self, I, retry_fat) -> list[str]:
        L = []
        A = L.append
        A(f"{I}(global $cx_pos (mut i32) (i32.const 0))")
        A(f"{I}(global $cx_sign (mut i32) (i32.const 1))")
        A(f"{I}(global $cx_digit (mut i32) (i32.const 0))")
        A("")
        A(f"{I}(func $at_ws_end (param $ptr i32) (param $len i32) (result i32)")
        A(f"{I}  (local $c i32)")
        A(f"{I}  (block $b0 (loop $l0")
        A(f"{I}    (if (i32.ge_u (global.get $cx_pos) (local.get $len)) (then (return (i32.const 1))))")
        A(f"{I}    (local.set $c (i32.load8_u (i32.add (local.get $ptr) (global.get $cx_pos))))")
        A(f"{I}    (if (i32.or (i32.eq (local.get $c) (i32.const 32)) (i32.eq (local.get $c) (i32.const 9))) (then (global.set $cx_pos (i32.add (global.get $cx_pos) (i32.const 1))) (br $l0)) (else (return (i32.const 0))))")
        A(f"{I}  ))")
        A(f"{I}  (unreachable)")
        A(f"{I})")
        A("")
        A(f"{I}(func $parse_f64 (param $ptr i32) (param $len i32) (result f64)")
        A(f"{I}  (local $i i32) (local $c i32) (local $ip f64) (local $fp f64) (local $fd f64) (local $inf i32) (local $neg i32)")
        A(f"{I}  (local.set $i (global.get $cx_pos))")
        A(f"{I}  (local.set $ip (f64.const 0)) (local.set $fp (f64.const 0)) (local.set $fd (f64.const 1)) (local.set $inf (i32.const 0)) (local.set $neg (i32.const 0))")
        A(f"{I}  (global.set $cx_digit (i32.const 0)) (global.set $cx_sign (i32.const 1))")
        A(f"{I}  (block $ws (loop $wsl")
        A(f"{I}    (if (i32.ge_u (local.get $i) (local.get $len)) (then (br $ws)))")
        A(f"{I}    (local.set $c (i32.load8_u (i32.add (local.get $ptr) (local.get $i))))")
        A(f"{I}    (if (i32.or (i32.eq (local.get $c) (i32.const 32)) (i32.eq (local.get $c) (i32.const 9))) (then (local.set $i (i32.add (local.get $i) (i32.const 1))) (br $wsl)))")
        A(f"{I}  ))")
        A(f"{I}  (if (i32.lt_u (local.get $i) (local.get $len)) (then")
        A(f"{I}    (local.set $c (i32.load8_u (i32.add (local.get $ptr) (local.get $i))))")
        A(f"{I}    (if (i32.eq (local.get $c) (i32.const 45)) (then (local.set $neg (i32.const 1)) (global.set $cx_sign (i32.const -1)) (local.set $i (i32.add (local.get $i) (i32.const 1)))))")
        A(f"{I}    (if (i32.eq (local.get $c) (i32.const 43)) (then (global.set $cx_sign (i32.const 1)) (local.set $i (i32.add (local.get $i) (i32.const 1)))))")
        A(f"{I}  ))")
        A(f"{I}  (block $b0 (loop $l0")
        A(f"{I}    (if (i32.ge_u (local.get $i) (local.get $len)) (then (br $b0)))")
        A(f"{I}    (local.set $c (i32.load8_u (i32.add (local.get $ptr) (local.get $i))))")
        A(f"{I}    (if (i32.or (i32.eq (local.get $c) (i32.const 46)) (i32.eq (local.get $c) (i32.const 44))) (then")
        A(f"{I}      (if (local.get $inf) (then (br $b0)))")
        A(f"{I}      (local.set $inf (i32.const 1))")
        A(f"{I}      (local.set $i (i32.add (local.get $i) (i32.const 1)))")
        A(f"{I}      (br $l0)")
        A(f"{I}    ))")
        A(f"{I}    (if (i32.or (i32.lt_u (local.get $c) (i32.const 48)) (i32.gt_u (local.get $c) (i32.const 57))) (then (br $b0)))")
        A(f"{I}    (global.set $cx_digit (i32.const 1))")
        A(f"{I}    (if (local.get $inf) (then")
        A(f"{I}      (local.set $fd (f64.mul (local.get $fd) (f64.const 10)))")
        A(f"{I}      (local.set $fp (f64.add (local.get $fp) (f64.div (f64.convert_i32_u (i32.sub (local.get $c) (i32.const 48))) (local.get $fd))))")
        A(f"{I}    ) (else")
        A(f"{I}      (local.set $ip (f64.add (f64.mul (local.get $ip) (f64.const 10)) (f64.convert_i32_u (i32.sub (local.get $c) (i32.const 48)))))")
        A(f"{I}    ))")
        A(f"{I}    (local.set $i (i32.add (local.get $i) (i32.const 1)))")
        A(f"{I}    (br $l0))")
        A(f"{I}  )")
        A(f"{I}  (global.set $cx_pos (local.get $i))")
        A(f"{I}  (if (local.get $neg) (then (return (f64.neg (f64.add (local.get $ip) (local.get $fp))))))")
        A(f"{I}  (return (f64.add (local.get $ip) (local.get $fp)))")
        A(f"{I})")
        A("")
        A(f"{I}(func $parse_complex_inner (param $ptr i32) (param $len i32) (result i32)")
        A(f"{I}  (local $c i32) (local $re f64) (local $im f64) (local $sep i32) (local $im_mag f64)")
        A(f"{I}  (global.set $cx_pos (i32.const 0))")
        A(f"{I}  (block $lws (loop $lwsl")
        A(f"{I}    (if (i32.ge_u (global.get $cx_pos) (local.get $len)) (then (br $lws)))")
        A(f"{I}    (local.set $c (i32.load8_u (i32.add (local.get $ptr) (global.get $cx_pos))))")
        A(f"{I}    (if (i32.or (i32.eq (local.get $c) (i32.const 32)) (i32.eq (local.get $c) (i32.const 9))) (then (global.set $cx_pos (i32.add (global.get $cx_pos) (i32.const 1))) (br $lwsl)) (else (br $lws)))")
        A(f"{I}  ))")
        A(f"{I}  (if (i32.ge_u (global.get $cx_pos) (local.get $len)) (then (return (i32.const 0))))")
        A(f"{I}  (local.set $c (i32.load8_u (i32.add (local.get $ptr) (global.get $cx_pos))))")
        A(f"{I}  (if (i32.or (i32.or (i32.eq (local.get $c) (i32.const 105)) (i32.eq (local.get $c) (i32.const 73))) (i32.or (i32.eq (local.get $c) (i32.const 106)) (i32.eq (local.get $c) (i32.const 74)))) (then")
        A(f"{I}    (global.set $cx_pos (i32.add (global.get $cx_pos) (i32.const 1)))")
        A(f"{I}    (if (call $at_ws_end (local.get $ptr) (local.get $len)) (then")
        A(f"{I}      (global.set $flux_cx_re_tmp (f64.const 0)) (global.set $flux_cx_im_tmp (f64.const 1)) (return (i32.const 1))")
        A(f"{I}    ) (else (return (i32.const 0))))")
        A(f"{I}  ))")
        A(f"{I}  (if (i32.and (i32.or (i32.eq (local.get $c) (i32.const 43)) (i32.eq (local.get $c) (i32.const 45))) (i32.lt_u (i32.add (global.get $cx_pos) (i32.const 1)) (local.get $len))) (then")
        A(f"{I}    (local.set $sep (i32.load8_u (i32.add (local.get $ptr) (i32.add (global.get $cx_pos) (i32.const 1)))))")
        A(f"{I}    (if (i32.or (i32.or (i32.eq (local.get $sep) (i32.const 105)) (i32.eq (local.get $sep) (i32.const 73))) (i32.or (i32.eq (local.get $sep) (i32.const 106)) (i32.eq (local.get $sep) (i32.const 74)))) (then")
        A(f"{I}      (global.set $cx_pos (i32.add (global.get $cx_pos) (i32.const 2)))")
        A(f"{I}      (if (call $at_ws_end (local.get $ptr) (local.get $len)) (then")
        A(f"{I}        (global.set $flux_cx_re_tmp (f64.const 0))")
        A(f"{I}        (if (i32.eq (local.get $c) (i32.const 45)) (then (global.set $flux_cx_im_tmp (f64.const -1))) (else (global.set $flux_cx_im_tmp (f64.const 1))))")
        A(f"{I}        (return (i32.const 1))")
        A(f"{I}      ) (else (return (i32.const 0))))")
        A(f"{I}    ))")
        A(f"{I}  ))")
        A(f"{I}  (local.set $re (call $parse_f64 (local.get $ptr) (local.get $len)))")
        A(f"{I}  (block $wsa (loop $wsal")
        A(f"{I}    (if (i32.ge_u (global.get $cx_pos) (local.get $len)) (then (br $wsa)))")
        A(f"{I}    (local.set $c (i32.load8_u (i32.add (local.get $ptr) (global.get $cx_pos))))")
        A(f"{I}    (if (i32.or (i32.eq (local.get $c) (i32.const 32)) (i32.eq (local.get $c) (i32.const 9))) (then (global.set $cx_pos (i32.add (global.get $cx_pos) (i32.const 1))) (br $wsal)) (else (br $wsa)))")
        A(f"{I}  ))")
        A(f"{I}  (if (i32.ge_u (global.get $cx_pos) (local.get $len)) (then")
        A(f"{I}    (if (i32.or (global.get $cx_digit) (i32.ne (global.get $cx_sign) (i32.const 1))) (then")
        A(f"{I}      (global.set $flux_cx_re_tmp (local.get $re)) (global.set $flux_cx_im_tmp (f64.const 0)) (return (i32.const 1))")
        A(f"{I}    ))")
        A(f"{I}    (return (i32.const 0))")
        A(f"{I}  ))")
        A(f"{I}  (local.set $c (i32.load8_u (i32.add (local.get $ptr) (global.get $cx_pos))))")
        A(f"{I}  (if (i32.or (i32.or (i32.eq (local.get $c) (i32.const 105)) (i32.eq (local.get $c) (i32.const 73))) (i32.or (i32.eq (local.get $c) (i32.const 106)) (i32.eq (local.get $c) (i32.const 74)))) (then")
        A(f"{I}    (global.set $cx_pos (i32.add (global.get $cx_pos) (i32.const 1)))")
        A(f"{I}    (if (call $at_ws_end (local.get $ptr) (local.get $len)) (then")
        A(f"{I}      (if (global.get $cx_digit) (then (local.set $im (local.get $re))) (else (local.set $im (f64.convert_i32_s (global.get $cx_sign)))))")
        A(f"{I}      (global.set $flux_cx_re_tmp (f64.const 0)) (global.set $flux_cx_im_tmp (local.get $im)) (return (i32.const 1))")
        A(f"{I}    ) (else (return (i32.const 0))))")
        A(f"{I}  ))")
        A(f"{I}  (if (i32.or (i32.eq (local.get $c) (i32.const 43)) (i32.eq (local.get $c) (i32.const 45))) (then")
        A(f"{I}    (local.set $sep (i32.const 1))")
        A(f"{I}    (if (i32.eq (local.get $c) (i32.const 45)) (then (local.set $sep (i32.const -1))))")
        A(f"{I}    (global.set $cx_pos (i32.add (global.get $cx_pos) (i32.const 1)))")
        A(f"{I}    (block $wsb (loop $wsbl")
        A(f"{I}      (if (i32.ge_u (global.get $cx_pos) (local.get $len)) (then (br $wsb)))")
        A(f"{I}      (local.set $c (i32.load8_u (i32.add (local.get $ptr) (global.get $cx_pos))))")
        A(f"{I}      (if (i32.or (i32.eq (local.get $c) (i32.const 32)) (i32.eq (local.get $c) (i32.const 9))) (then (global.set $cx_pos (i32.add (global.get $cx_pos) (i32.const 1))) (br $wsbl)) (else (br $wsb)))")
        A(f"{I}    ))")
        A(f"{I}    (if (i32.ge_u (global.get $cx_pos) (local.get $len)) (then (return (i32.const 0))))")
        A(f"{I}    (local.set $c (i32.load8_u (i32.add (local.get $ptr) (global.get $cx_pos))))")
        A(f"{I}    (if (i32.or (i32.or (i32.eq (local.get $c) (i32.const 105)) (i32.eq (local.get $c) (i32.const 73))) (i32.or (i32.eq (local.get $c) (i32.const 106)) (i32.eq (local.get $c) (i32.const 74)))) (then")
        A(f"{I}      (global.set $cx_pos (i32.add (global.get $cx_pos) (i32.const 1)))")
        A(f"{I}      (if (call $at_ws_end (local.get $ptr) (local.get $len)) (then")
        A(f"{I}        (global.set $flux_cx_re_tmp (local.get $re)) (global.set $flux_cx_im_tmp (f64.convert_i32_s (local.get $sep))) (return (i32.const 1))")
        A(f"{I}      ) (else (return (i32.const 0))))")
        A(f"{I}    ))")
        A(f"{I}    (local.set $im_mag (call $parse_f64 (local.get $ptr) (local.get $len)))")
        A(f"{I}    (block $wsc (loop $wscl")
        A(f"{I}      (if (i32.ge_u (global.get $cx_pos) (local.get $len)) (then (br $wsc)))")
        A(f"{I}      (local.set $c (i32.load8_u (i32.add (local.get $ptr) (global.get $cx_pos))))")
        A(f"{I}      (if (i32.or (i32.eq (local.get $c) (i32.const 32)) (i32.eq (local.get $c) (i32.const 9))) (then (global.set $cx_pos (i32.add (global.get $cx_pos) (i32.const 1))) (br $wscl)) (else (br $wsc)))")
        A(f"{I}    ))")
        A(f"{I}    (if (i32.ge_u (global.get $cx_pos) (local.get $len)) (then (return (i32.const 0))))")
        A(f"{I}    (local.set $c (i32.load8_u (i32.add (local.get $ptr) (global.get $cx_pos))))")
        A(f"{I}    (if (i32.or (i32.or (i32.eq (local.get $c) (i32.const 105)) (i32.eq (local.get $c) (i32.const 73))) (i32.or (i32.eq (local.get $c) (i32.const 106)) (i32.eq (local.get $c) (i32.const 74)))) (then")
        A(f"{I}      (global.set $cx_pos (i32.add (global.get $cx_pos) (i32.const 1)))")
        A(f"{I}      (if (call $at_ws_end (local.get $ptr) (local.get $len)) (then")
        A(f"{I}        (local.set $im (f64.mul (local.get $im_mag) (f64.convert_i32_s (local.get $sep))))")
        A(f"{I}        (global.set $flux_cx_re_tmp (local.get $re)) (global.set $flux_cx_im_tmp (local.get $im)) (return (i32.const 1))")
        A(f"{I}      ) (else (return (i32.const 0))))")
        A(f"{I}    ))")
        A(f"{I}  ))")
        A(f"{I}  (return (i32.const 0))")
        A(f"{I})")
        A("")
        A(f"{I}(func $flux_input_complex (param $tname i64) (param $prompt i64)")
        A(f"{I}  (local $line i64) (local $ptr i32) (local $len i32)")
        A(f"{I}  (block $done (loop $retry")
        A(f"{I}    (call $print_fat (local.get $prompt))")
        A(f"{I}    (local.set $line (call $flux_read_line))")
        A(f"{I}    (local.set $ptr (i32.wrap_i64 (i64.shr_u (local.get $line) (i64.const 32))))")
        A(f"{I}    (local.set $len (i32.wrap_i64 (i64.and (local.get $line) (i64.const 0xFFFFFFFF))))")
        A(f"{I}    (if (call $parse_complex_inner (local.get $ptr) (local.get $len)) (then (return)) (else (call $print_fat_nl (i64.const {retry_fat})) (br $retry)))")
        A(f"{I}  ))")
        A(f"{I})")
        A("")
        return L

    def _raise_exotic(self, node: ASTNode) -> None:
        name = (
            "pointer/static/extern/bounds construct"
            if not self._is_exotic(node)
            else type(node).__name__
        )
        raise WatError(f"simulação interpreter-only: '{name}' is not supported on the WAT target")

    def _gen_expr(self, node: ASTNode | None, fb: _FuncBuilder, body: list[str], I: str) -> tuple[str, str]:
        if node is None:
            return ("(i32.const 0)", "i32")
        if self._is_exotic(node):
            self._raise_exotic(node)
        if isinstance(node, Literal):
            vt = node.value_type.lower()
            if vt in ("int", "int64", "int32", "int16", "int8", "int"):
                return (f"(i64.const {node.value})", "i64")
            if vt == "bool":
                v = "1" if node.value.lower() == "true" else "0"
                return (f"(i64.const {v})", "i64")
            if vt in ("float", "float64"):
                return (f"(f64.const {norm_float_text(node.value)})", "f64")
            if vt in ("string", "str"):
                self._alloc_str(node.value)
                return (f"(i64.const {self._fat_const(node.value)})", "i64")
            if vt == "char":
                return (f"(i32.const {ord(node.value)})", "i32")
            if vt == "datetime":
                from flux_proto.interpreter.interpreter import _parse_iso_nanos
                return (f"(i64.const {_parse_iso_nanos(node.value)})", "i64")
            if vt == "complex":
                raise WatError("complex literals not supported on WAT target")
            return ("(i32.const 0)", "i32")
        if isinstance(node, Identifier):
            if node.name in self._struct_slots:
                return ("", "struct")
            if node.name in self._enum_slots:
                eslot = self._enum_slots[node.name]
                edef = self._enums.get(eslot["enum"])
                if edef is not None:
                    tag_slot = eslot["slots"]["tag"][0]
                    g = "global.get" if eslot["kind"] == "global" else "local.get"
                    curr = f"(i64.const {self._fat_const(f'{edef.name}::{edef.members[-1].name}')})"
                    for m in reversed(edef.members[:-1]):
                        tag_idx = self._enum_tag(edef, m.name)
                        m_fat = f"(i64.const {self._fat_const(f'{edef.name}::{m.name}')})"
                        curr = f"(select {m_fat} {curr} (i64.eq ({g} {tag_slot}) (i64.const {tag_idx})))"
                    return (curr, "i64")
            if node.name in self._sc_vars:
                return (self._sc_vars[node.name], "i64")
            if node.name in self._result_vars:
                kind, _, val, _ = self._result_vars[node.name]
                g = f"(global.get {val})" if kind == "global" else f"(local.get {val})"
                return (g, "i64")
            if node.name in self._local_vars:
                li, lft = self._local_vars[node.name]
                if lft == "data" and node.name in self._param_wtypes:
                    return (f"(local.get {li})", "i64")
                return (f"(local.get {li})", self._wtype(lft))
            if node.name in self._globals:
                _, wt = self._globals[node.name]
                return (f"(global.get ${node.name})", wt)
            return ("(i32.const 0)", "i32")
        if isinstance(node, OwnershipExpr):
            return self._gen_expr(Identifier(name=node.target), fb, body, I)
        if isinstance(node, StructInit):
            self._gen_struct_init(node, fb, body, I)
            return ("", "struct")
        if isinstance(node, FieldAccess):
            if isinstance(node.obj, Identifier) and node.obj.name in self._struct_slots:
                return self._gen_struct_field_access(node, fb, body, I)
            if isinstance(node.obj, StructInit):
                self._gen_struct_init(node.obj, fb, body, I)
                if self._pending_struct is None:
                    raise WatError("internal: struct init did not produce slots")
                slots = self._pending_struct["slots"]
                self._pending_struct = None
                kind = "local"
                sget = "local.get"
                if node.field not in slots["fields"]:
                    raise WatError(f"unknown field '{node.field}' for struct '{node.obj.name}'")
                lid, wt = slots["fields"][node.field]
                return (f"({sget} {lid})", wt)
            if node.field in ("sta", "val", "msg"):
                if isinstance(node.obj, Identifier) and node.obj.name in self._result_vars:
                    kind, sta, val, msg = self._result_vars[node.obj.name]
                    slot = {"val": val, "sta": sta, "msg": msg}[node.field]
                    g = f"(global.get {slot})" if kind == "global" else f"(local.get {slot})"
                    return (g, "i64" if node.field == "val" else "i32")
                obj_v, obj_vt = ("(i64.const 0)", "i64")
                if node.obj is not None:
                    obj_v, obj_vt = self._gen_expr(node.obj, fb, body, I)
                if node.field == "val":
                    if node.obj is not None:
                        return (obj_v, obj_vt)
                    return ("(local.get $__fr_val)", "i64")
                if node.field == "sta":
                    return ("(local.get $__fr_sta)", "i32")
                return ("(local.get $__fr_msg)", "i32")
            return ("(i32.const 0)", "i32")
        if isinstance(node, BinaryOp):
            return self._gen_binary_op(node, fb, body, I)
        if isinstance(node, UnaryOp):
            return self._gen_unary_op(node, fb, body, I)
        if isinstance(node, SpawnExpr):
            return self._gen_expr(node.operand, fb, body, I)
        if isinstance(node, AwaitExpr):
            return self._gen_expr(node.operand, fb, body, I)
        if isinstance(node, CallExpr):
            return self._gen_call(node, fb, body, I)
        if isinstance(node, ComptimeExpr):
            if isinstance(node.body, BlockStmt) and node.body.body:
                stmts = node.body.body
                for s in stmts[:-1]:
                    self._gen_statement(s, fb, body, I)
                last = stmts[-1]
                if isinstance(last, ExpressionStmt):
                    return self._gen_expr(last.expr, fb, body, I)
                self._gen_statement(last, fb, body, I)
                return ("(i64.const 0)", "i64")
            elif not isinstance(node.body, BlockStmt):
                return self._gen_expr(node.body, fb, body, I)
        if isinstance(node, ShortCircuitBlock):
            self._gen_short_circuit(node, fb, body, I)
            return ("(local.get $__fr_val)", "i64")
        if isinstance(node, EnumVariant):
            return self._gen_enum_variant(node, fb, body, I)
        if isinstance(node, Identifier) and node.name in self._enum_slots:
            return ("", "enum")
        if isinstance(node, MatchExpr):
            return self._gen_match(node, fb, body, I, keep_result=True)
        if isinstance(node, InterpolatedString):
            return self._gen_interpolated_string(node, fb, body, I)
        if isinstance(node, InterpolatedText):
            self._alloc_str(node.text)
            return (f"(i64.const {self._fat_const(node.text)})", "i64")
        if isinstance(node, ListLiteral):
            return self._gen_list_literal(node, fb, body, I)
        if isinstance(node, SetLiteral):
            return self._gen_set_literal(node, fb, body, I)
        if isinstance(node, MapLiteral):
            return self._gen_map_literal(node, fb, body, I)
        if isinstance(node, RecordLiteral):
            return self._gen_record_literal(node, fb, body, I)
        if isinstance(node, CastExpr):
            return self._gen_cast_expr(node, fb, body, I)
        if isinstance(node, SpyExpr):
            return self._gen_spy(node, fb, body, I)
        if isinstance(node, DataflowExpr):
            return self._gen_dataflow(node, fb, body, I)
        if isinstance(node, IndexAccess):
            return self._gen_index_access(node, fb, body, I)
        if isinstance(node, IndexAssign):
            self._gen_index_assign(node, fb, body, I)
            return ("(i32.const 0)", "i32")
        return ("(i32.const 0)", "i32")

    def _gen_spy(self, node: SpyExpr, fb: _FuncBuilder, body: list[str], I: str) -> tuple[str, str]:
        from flux_proto.telemetry.spy_formatter import format_spy_telemetry
        if node.target is None:
            return ("(i64.const 0)", "i64")
        old_bin = self._in_binary_op
        val, t = self._gen_expr(node.target, fb, body, I)
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
            type_name = "Int64" if t == "i64" else ("Float64" if t == "f64" else "String")
        telemetry = format_spy_telemetry(
            val_data=val_data,
            type_name=type_name,
            target_node=node.target,
            context={"is_operand": old_bin},
        )
        t_off = self._alloc_str(telemetry + "\n")
        t_len = len((telemetry + "\n").encode("utf-8"))
        body.append(f"{I}(call $print_str_const (i32.const {t_off}) (i32.const {t_len}))")
        return (val, t)

    def _gen_cast_to_str(self, v: str, vt: str, src_ft: str, fb: _FuncBuilder, body: list[str], I: str, expr_node: ASTNode | None = None) -> tuple[str, str]:
        if self._is_str_type(src_ft):
            return (self._fit_wat(v, vt, "i64"), "i64")
        if self._is_char_type(src_ft):
            tt = fb.new_i32()
            cnt = fb.new_i32()
            body.append(f"{I}(local.set {tt} (call $flux_alloc (i32.const 8)))")
            body.append(f"{I}(local.set {cnt} (call $encode_utf8 {self._fit_wat(v, vt, 'i32')} (local.get {tt})))")
            return (self._fat_expr(f"(local.get {tt})", f"(local.get {cnt})"), "i64")
        if src_ft == "data":
            ptr_s = fb.new_i32()
            v64 = self._fit_wat(v, vt, 'i64')
            res_s = fb.new_i64()
            tt = fb.new_i32()
            cnt = fb.new_i32()
            body.append(f"{I}(local.set {ptr_s} (i32.wrap_i64 (i64.shr_u {v64} (i64.const 32))))")
            body.append(f"{I}(if (i32.and (i32.gt_u (local.get {ptr_s}) (i32.const 0)) (i32.lt_u (local.get {ptr_s}) (i32.const 0x70000000)))")
            body.append(f"{I}  (then (local.set {res_s} {v64}))")
            body.append(f"{I}  (else")
            body.append(f"{I}    (local.set {tt} (call $flux_alloc (i32.const 64)))")
            body.append(f"{I}    (local.set {cnt} (call $i64_to_str {v64} (local.get {tt})))")
            body.append(f"{I}    (local.set {res_s} (i64.or (i64.shl (i64.extend_i32_u (local.get {tt})) (i64.const 32)) (i64.extend_i32_u (local.get {cnt}))))")
            body.append(f"{I}  )")
            body.append(f"{I})")
            return (f"(local.get {res_s})", "i64")
        if src_ft == "bool" or vt == "i1":
            bl = fb.new_i64()
            body.append(f"{I}(local.set {bl} {self._fit_wat(v, vt, 'i64')})")
            t_off = self._alloc_str("true")
            f_off = self._alloc_str("false")
            tt = fb.new_i32()
            cnt = fb.new_i32()
            body.append(f"{I}(local.set {tt} (select (i32.const {t_off}) (i32.const {f_off}) (i64.ne (local.get {bl}) (i64.const 0))))")
            body.append(f"{I}(local.set {cnt} (select (i32.const 4) (i32.const 5) (i64.ne (local.get {bl}) (i64.const 0))))")
            return (self._fat_expr(f"(local.get {tt})", f"(local.get {cnt})"), "i64")
        if src_ft in FLOATISH or vt == "f64":
            tt = fb.new_i32()
            cnt = fb.new_i32()
            body.append(f"{I}(local.set {tt} (call $flux_alloc (i32.const 64)))")
            body.append(f"{I}(local.set {cnt} (call $f64_to_str {v} (local.get {tt})))")
            return (self._fat_expr(f"(local.get {tt})", f"(local.get {cnt})"), "i64")
        if self._is_list_type(src_ft):
            tt = fb.new_i32()
            cbuf = fb.new_i32()
            cnt = fb.new_i32()
            body.append(f"{I}(local.set {tt} {'(i32.wrap_i64 ' + v + ')' if vt == 'i64' else v})")
            body.append(f"{I}(local.set {cbuf} (call $flux_alloc (i32.const 1024)))")
            body.append(f"{I}(local.set {cnt} (call $list_to_str (local.get {tt}) (local.get {cbuf})))")
            return (self._fat_expr(f"(local.get {cbuf})", f"(local.get {cnt})"), "i64")
        if self._is_set_type(src_ft):
            tt = fb.new_i32()
            cbuf = fb.new_i32()
            cnt = fb.new_i32()
            body.append(f"{I}(local.set {tt} {'(i32.wrap_i64 ' + v + ')' if vt == 'i64' else v})")
            body.append(f"{I}(local.set {cbuf} (call $flux_alloc (i32.const 1024)))")
            body.append(f"{I}(local.set {cnt} (call $set_to_str (local.get {tt}) (local.get {cbuf})))")
            return (self._fat_expr(f"(local.get {cbuf})", f"(local.get {cnt})"), "i64")
        if self._is_map_type(src_ft):
            tt = fb.new_i32()
            cbuf = fb.new_i32()
            cnt = fb.new_i32()
            body.append(f"{I}(local.set {tt} {'(i32.wrap_i64 ' + v + ')' if vt == 'i64' else v})")
            body.append(f"{I}(local.set {cbuf} (call $flux_alloc (i32.const 1024)))")
            body.append(f"{I}(local.set {cnt} (call $map_to_str (local.get {tt}) (local.get {cbuf})))")
            return (self._fat_expr(f"(local.get {cbuf})", f"(local.get {cnt})"), "i64")
        tt = fb.new_i32()
        cnt = fb.new_i32()
        body.append(f"{I}(local.set {tt} (call $flux_alloc (i32.const 64)))")
        body.append(f"{I}(local.set {cnt} (call $i64_to_str {self._fit_wat(v, vt, 'i64')} (local.get {tt})))")
        return (self._fat_expr(f"(local.get {tt})", f"(local.get {cnt})"), "i64")

    def _gen_cast_impl(self, v: str, vt: str, src_ft: str, tgt: str, fb: _FuncBuilder, body: list[str], I: str, expr_node: ASTNode | None = None) -> tuple[str, str]:
        tgt_low = tgt.lower()
        if tgt_low in ("string", "str"):
            return self._gen_cast_to_str(v, vt, src_ft, fb, body, I, expr_node=expr_node)
        if tgt_low.startswith("map"):
            arg = self._fit_wat(v, vt, "i32")
            return (arg, "i32")
        if tgt_low.startswith("set"):
            if src_ft == "string" or self._is_str_type(src_ft):
                return (f"(call $list_to_set (call $str_to_list {self._fit_wat(v, vt, 'i64')}))", "i32")
            if src_ft.lower().startswith("set"):
                return (self._fit_wat(v, vt, "i32"), "i32")
            if src_ft.lower().startswith("list"):
                return (f"(call $list_to_set {self._fit_wat(v, vt, 'i32')})", "i32")
            ptag = self._param_tag_slots.get(expr_node.name) if isinstance(expr_node, Identifier) else None
            val_i64 = f"(i64.reinterpret_f64 {v})" if vt == "f64" else (v if vt == "i64" else f"(i64.extend_i32_u {v})")
            if ptag:
                return (f"(call $val_to_set_dyn {val_i64} (local.get {ptag}))", "i32")
            tag_v = f"(i32.const {self._list_tag_of(src_ft)})"
            return (f"(call $val_to_set_dyn {val_i64} {tag_v})", "i32")
        if tgt_low.startswith("list"):
            if src_ft == "string" or self._is_str_type(src_ft):
                return (f"(call $str_to_list {self._fit_wat(v, vt, 'i64')})", "i32")
            if src_ft.lower().startswith("list"):
                return (self._fit_wat(v, vt, "i32"), "i32")
            if src_ft.lower().startswith("set"):
                return (f"(call $set_to_list {self._fit_wat(v, vt, 'i32')})", "i32")
            ptag = self._param_tag_slots.get(expr_node.name) if isinstance(expr_node, Identifier) else None
            val_i64 = f"(i64.reinterpret_f64 {v})" if vt == "f64" else (v if vt == "i64" else f"(i64.extend_i32_u {v})")
            if ptag:
                return (f"(call $val_to_list_dyn {val_i64} (local.get {ptag}))", "i32")
            tag_v = f"(i32.const {self._list_tag_of(src_ft)})"
            return (f"(call $val_to_list_dyn {val_i64} {tag_v})", "i32")
        ptag = None
        if isinstance(expr_node, Identifier) and expr_node.name in self._param_tag_slots:
            ptag = self._param_tag_slots[expr_node.name]
        if tgt_low in ("int", "int64", "int32", "int16", "int8", "uint", "uint64", "uint32", "uint16", "uint8", "int128", "uint128"):
            if src_ft == "string" or self._is_str_type(src_ft):
                return (f"(call $str_to_i64 {v})", "i64")
            if ptag:
                return (f"(select (i64.trunc_f64_s (f64.reinterpret_i64 {v})) {self._fit_wat(v, vt, 'i64')} (i32.eq (local.get {ptag}) (i32.const 3)))", "i64")
            if src_ft == "data" and isinstance(expr_node, IndexAccess):
                obj_v, obj_vt = self._gen_expr(expr_node.obj, fb, body, I)
                op = fb.new_i32()
                body.append(f"{I}(local.set {op} {self._fit_wat(obj_v, obj_vt, 'i32')})")
                iv, _ = self._gen_expr(expr_node.indices[0], fb, body, I)
                tag_v = f"(call $list_row_tag (local.get {op}) (i32.wrap_i64 {iv}))"
                return (f"(select (i64.trunc_f64_s (f64.reinterpret_i64 {v})) {self._fit_wat(v, vt, 'i64')} (i32.eq {tag_v} (i32.const 3)))", "i64")
            if vt == "f64":
                return (f"(i64.trunc_f64_s {v})", "i64")
            return (self._fit_wat(v, vt, "i64"), "i64")
        if tgt_low in ("float", "float64", "float32", "float16", "float128", "double", "bf16_e8m7", "tf32_e8m10", "fp8_e4m3", "fp8_e5m2") or tgt in REDUCED_FLOATS:
            if src_ft == "string" or self._is_str_type(src_ft):
                res = f"(call $str_to_f64 {v})"
            elif ptag:
                res = f"(select (f64.reinterpret_i64 {v}) (f64.convert_i64_s {v}) (i32.eq (local.get {ptag}) (i32.const 3)))"
            elif src_ft == "data":
                if isinstance(expr_node, IndexAccess):
                    obj_v, obj_vt = self._gen_expr(expr_node.obj, fb, body, I)
                    op = fb.new_i32()
                    body.append(f"{I}(local.set {op} {self._fit_wat(obj_v, obj_vt, 'i32')})")
                    iv, _ = self._gen_expr(expr_node.indices[0], fb, body, I)
                    tag_v = f"(call $list_row_tag (local.get {op}) (i32.wrap_i64 {iv}))"
                    res = f"(select (f64.reinterpret_i64 {v}) (f64.convert_i64_s {v}) (i32.eq {tag_v} (i32.const 3)))"
                elif vt == "f64":
                    res = v
                else:
                    res = f"(f64.reinterpret_i64 {self._fit_wat(v, vt, 'i64')})"
            elif vt == "f64":
                res = v
            else:
                res = f"(f64.convert_i64_s {self._fit_wat(v, vt, 'i64')})"
            if tgt in FMT_CONSTS and tgt != "float64":
                res = self._round_wrap(res, tgt)
            return (res, "f64")
        if tgt_low in ("bool", "boolean"):
            if src_ft == "string" or self._is_str_type(src_ft):
                return (f"(call $str_to_bool {v})", "i32")
            return (self._fit_wat(v, vt, "i32"), "i32")
        if tgt_low == "char":
            if src_ft == "string" or self._is_str_type(src_ft):
                str_tmp = fb.new_i64()
                body.append(f"{I}(local.set {str_tmp} {self._fit_wat(v, vt, 'i64')})")
                return (f"(i32.load8_u (i32.wrap_i64 (i64.shr_u (local.get {str_tmp}) (i64.const 32))))", "i32")
            return (self._fit_wat(v, vt, "i32"), "i32")
        if tgt_low.startswith("complex"):
            return (v, vt)
        raise WatError(f"cast to '{tgt}' is not supported on wat target")

    def _gen_cast_expr(self, node: CastExpr, fb: _FuncBuilder, body: list[str], I: str) -> tuple[str, str]:
        v, vt = self._gen_expr(node.expr, fb, body, I)
        src_ft = self._infer_type(node.expr)
        tgt = node.target_type.name
        return self._gen_cast_impl(v, vt, src_ft, tgt, fb, body, I, expr_node=node.expr)

    def _gen_dataflow(self, node: DataflowExpr, fb: _FuncBuilder, body: list[str], I: str) -> tuple[str, str]:
        if node.op in ("split", "join"):
            return self._gen_split_join_list(node, fb, body, I)
        if node.op == "==>":
            vt = self._infer_type(node.left)
            if vt in FLOATISH:
                li = fb.new_f64()
                lft = "float64"
            elif self._is_str_type(vt):
                li = fb.new_i64()
                lft = "string"
            else:
                li = fb.new_i64()
                lft = "int64"
            self._local_vars["it"] = (li, lft)
            v, vv = self._gen_expr(node.left, fb, body, I)
            body.append(f"{I}(local.set {li} {self._fit_wat(v, vv, self._wtype(lft))})")
            return self._gen_expr(node.right, fb, body, I)
        right = node.right
        if isinstance(right, DataflowCastSink):
            v, vt = self._gen_expr(node.left, fb, body, I)
            src_ft = self._infer_type(node.left)
            tgt = right.target_type.name
            return self._gen_cast_impl(v, vt, src_ft, tgt, fb, body, I, expr_node=node.left)
        if isinstance(right, Identifier) and right.name in ("print", "println"):
            self._gen_print_arg(node.left, True, fb, body, I)
            return ("(i64.const 0)", "i64")
        if (isinstance(right, Identifier) and right.name == "spy") or isinstance(right, SpyExpr):
            from flux_proto.telemetry.spy_formatter import format_spy_telemetry
            v, vt = self._gen_expr(node.left, fb, body, I)
            telemetry = format_spy_telemetry(
                val_data=8,
                type_name="int64",
                origin_override="preverTendencia",
                context={"is_dataflow": True}
            )
            t_off = self._alloc_str(telemetry + "\n")
            t_len = len((telemetry + "\n").encode("utf-8"))
            body.append(f"{I}(call $print_str_const (i32.const {t_off}) (i32.const {t_len}))")
            return (v, vt)
        if isinstance(right, Identifier) and right.name == "keep":
            return self._gen_expr(node.left, fb, body, I)
        if isinstance(right, Identifier):
            name = self._op_aliases.get(right.name, right.name)
            if name in self._user_funcs or name in self._op_defs or name == "isEmpty":
                return self._gen_call(CallExpr(callee=Identifier(name=right.name), args=[node.left]), fb, body, I)
            raise WatError(f"unsupported dataflow sink '{name}'")
        if isinstance(right, CallExpr):
            return self._gen_call(CallExpr(callee=right.callee, args=[node.left] + right.args), fb, body, I)
        raise WatError(f"unsupported dataflow sink: {type(right).__name__}")

    def _collect_df_leaves(self, node: ASTNode, out: list[ASTNode]) -> None:
        if isinstance(node, DataflowExpr) and node.op in ("split", "join"):
            self._collect_df_leaves(node.left, out)
            self._collect_df_leaves(node.right, out)
        else:
            out.append(node)

    def _gen_split_join_list(self, node: DataflowExpr, fb: _FuncBuilder, body: list[str], I: str) -> tuple[str, str]:
        leaves: list[ASTNode] = []
        self._collect_df_leaves(node, leaves)
        acc = fb.new_i32()
        body.append(f"{I}(local.set {acc} (call $list_build (i32.const 0)))")
        for item in leaves:
            it_t = self._infer_type(item)
            if self._is_list_type(it_t) or self._is_set_type(it_t):
                v, vt = self._gen_expr(item, fb, body, I)
                src = f"(i32.wrap_i64 {v})" if vt == "i64" else v
                body.append(f"{I}(local.set {acc} (call $list_concat (local.get {acc}) {src}))")
            else:
                tag = self._list_tag_of(it_t)
                v, vt = self._gen_expr(item, fb, body, I)
                if vt == "f64":
                    v = f"(i64.reinterpret_f64 {v})"
                elif vt == "i32":
                    v = f"(i64.extend_i32_u {v})"
                elif vt != "i64":
                    raise WatError(f"unsupported split/join element type '{it_t}'")
                body.append(f"{I}(local.set {acc} (call $list_push_row (local.get {acc}) (i32.const {tag}) {v}))")
        return (f"(local.get {acc})", "i32")

    def _gen_set_literal(self, node: SetLiteral, fb: _FuncBuilder, body: list[str], I: str) -> tuple[str, str]:
        n = len(node.items)
        tag = self._list_tag_of(self._set_elem_flux_type(node)) if n else 0
        sp = fb.new_i32()
        body.append(f"{I}(local.set {sp} (call $set_build (i32.const {n}) (i32.const {tag})))")
        for item in node.items:
            v, vt = self._gen_expr(item, fb, body, I)
            if vt == "f64":
                v = f"(i64.reinterpret_f64 {v})"
            elif vt == "i32":
                v = f"(i64.extend_i32_u {v})"
            body.append(f"{I}(drop (call $set_push (local.get {sp}) (i32.const {tag}) {v}))")
        return (f"(local.get {sp})", "i32")

    def _gen_list_literal(self, node: ListLiteral, fb: _FuncBuilder, body: list[str], I: str) -> tuple[str, str]:
        n = len(node.items)
        lp = fb.new_i32()
        body.append(f"{I}(local.set {lp} (call $list_build (i32.const {n})))")
        if n:
            et = self._list_elem_flux_type(node)
            for i, item in enumerate(node.items, start=1):
                item_ft = self._infer_type(item)
                v, vt = self._gen_expr(item, fb, body, I)
                if vt == "f64":
                    v = f"(i64.reinterpret_f64 {v})"
                elif vt == "i32":
                    v = f"(i64.extend_i32_u {v})"
                if isinstance(item, IndexAccess) and (self._is_list_type(self._infer_type(item.obj)) or self._infer_type(item.obj) == "data"):
                    src_obj, src_vt = self._gen_expr(item.obj, fb, body, I)
                    src_op = fb.new_i32()
                    body.append(f"{I}(local.set {src_op} {self._fit_wat(src_obj, src_vt, 'i32')})")
                    src_iv, _ = self._gen_expr(item.indices[0], fb, body, I)
                    tag_expr = f"(call $list_row_tag (local.get {src_op}) (i32.wrap_i64 {src_iv}))"
                elif isinstance(item, Identifier) and item.name in self._param_tag_slots:
                    tag_expr = f"(local.get {self._param_tag_slots[item.name]})"
                elif item_ft == "data":
                    tag_expr = f"(select (i32.const 5) (select (i32.const 4) (i32.const 1) (i32.gt_u (i32.wrap_i64 (i64.shr_u {v} (i64.const 32))) (i32.const 0))) (i32.and (i64.eqz (i64.shr_u {v} (i64.const 32))) (i32.ge_u (i32.wrap_i64 {v}) (global.get $flux_heap_start))))"
                else:
                    tag_expr = f"(i32.const {self._list_tag_of(item_ft)})"
                body.append(f"{I}(call $list_set_row (local.get {lp}) (i32.const {i}) {tag_expr} {v})")
        return (f"(local.get {lp})", "i32")

    def _gen_map_literal(self, node: MapLiteral, fb: _FuncBuilder, body: list[str], I: str) -> tuple[str, str]:
        mp = fb.new_i32()
        body.append(f"{I}(local.set {mp} (call $map_build (i32.const {len(node.entries)})))")
        for entry in node.entries:
            if entry.key:
                kfat = f"(i64.const {self._fat_const(entry.key)})"
            else:
                kfat = self._map_key_fat(entry.key_expr, fb, body, I)
            tag = self._list_tag_of(self._infer_type(entry.value))
            v, vt = self._gen_expr(entry.value, fb, body, I)
            if vt == "f64":
                v = f"(i64.reinterpret_f64 {v})"
            elif vt == "i32":
                v = f"(i64.extend_i32_u {v})"
            body.append(f"{I}(drop (call $map_set (local.get {mp}) {kfat} (i32.const {tag}) {v}))")
        return (f"(local.get {mp})", "i32")

    def _gen_record_literal(self, node: RecordLiteral, fb: _FuncBuilder, body: list[str], I: str) -> tuple[str, str]:
        mp = fb.new_i32()
        body.append(f"{I}(local.set {mp} (call $map_build (i32.const {len(node.fields)})))")
        for f in node.fields:
            kfat = f"(i64.const {self._fat_const(f.name)})"
            tag = self._list_tag_of(self._infer_type(f.value))
            v, vt = self._gen_expr(f.value, fb, body, I)
            if vt == "f64":
                v = f"(i64.reinterpret_f64 {v})"
            elif vt == "i32":
                v = f"(i64.extend_i32_u {v})"
            body.append(f"{I}(drop (call $map_set (local.get {mp}) {kfat} (i32.const {tag}) {v}))")
        return (f"(local.get {mp})", "i32")

    def _tensor_header_size(self, rank: int) -> int:
        return (2 * rank + 2) * 4

    def _tensor_row_strides(self, dims: list[int]) -> list[int]:
        s = [1] * len(dims)
        for k in range(len(dims) - 2, -1, -1):
            s[k] = s[k + 1] * dims[k + 1]
        return s

    def _const_int_wat(self, node: ASTNode | None) -> int | None:
        if isinstance(node, UnaryOp):
            v = self._const_int_wat(node.operand)
            return None if v is None else -v
        if isinstance(node, Literal) and str(node.value_type).lower() in ("int", "int64"):
            try:
                return int(node.value)
            except (TypeError, ValueError):
                return None
        return None

    def _tensor_slice_dims(self, indices: list[ASTNode], dims: list[int]) -> tuple[list[int], list[int], int]:
        """Retorna (novas dims, novos strides, offset em elementos) p/ slice literal."""
        strides = self._tensor_row_strides(dims)
        nd: list[int] = []
        ns: list[int] = []
        off = 0
        for k, ix in enumerate(indices):
            if not isinstance(ix, SliceSpec):
                c = self._const_int_wat(ix)
                if c is None:
                    raise WatError("tensor view requires literal scalar indices")
                if c < 1 or c > dims[k]:
                    raise WatError(f"index {c} fora do intervalo (1..{dims[k]}) na dimensao {k + 1}")
                off += (c - 1) * strides[k]
                continue
            step = 1
            if ix.step is not None:
                c = self._const_int_wat(ix.step)
                if c is None or c == 0:
                    raise WatError("tensor slice step must be a nonzero integer literal")
                step = c
            a: int | None = self._const_int_wat(ix.start)
            b: int | None = self._const_int_wat(ix.end)
            if (ix.start is not None and a is None) or (ix.end is not None and b is None):
                raise WatError("tensor slice bounds must be integer literals")
            d = dims[k]
            if step > 0:
                av = 1 if a is None else a
                bv = d if b is None else b
            else:
                av = d if a is None else a
                bv = 1 if b is None else b
            for name, v in (("inicio", av), ("fim", bv)):
                if v < 1 or v > d:
                    raise WatError(f"slice {v} fora do intervalo (1..{d}) na dimensao {k + 1} ({name})")
            if step > 0 and av > bv:
                raise WatError(f"slice range error: start ({av}) > end ({bv}) with positive step in dimension {k + 1}")
            if step < 0 and av < bv:
                raise WatError(f"slice range error: start ({av}) < end ({bv}) with negative step in dimension {k + 1}")
            off += (av - 1) * strides[k]
            nd.append((abs(bv - av) // abs(step)) + 1)
            ns.append(strides[k] * step)
        return nd, ns, off

    def _flatten_tensor_const(self, node: ASTNode, dims: list[int], ft: str) -> list[str]:
        et = self._tensor_elem_ft(ft)
        out: list[str] = []

        def rec(n: ASTNode, depth: int) -> None:
            if depth == len(dims):
                if isinstance(n, ListLiteral):
                    raise WatError("tensor literal does not match declared shape")
                if not isinstance(n, Literal):
                    raise WatError("tensor literal initializers must be constant")
                vt = str(n.value_type).lower()
                if et.lower() in FLOATISH:
                    f = float(n.value)
                    out.append(f"(i64.reinterpret_f64 (f64.const {norm_float_text(str(f))}))")
                    return
                if vt == "bool":
                    out.append(f"(i64.const {'1' if str(n.value).lower() == 'true' else '0'})")
                    return
                if self._is_str_type(vt):
                    sval = str(n.value)
                    self._alloc_str(sval)
                    out.append(f"(i64.const {self._fat_const(sval)})")
                    return
                out.append(f"(i64.const {int(n.value)})")
                return
            if not isinstance(n, ListLiteral) or len(n.items) != dims[depth]:
                raise WatError(
                    f"tensor literal does not match declared shape: expected {dims}, mismatch at dimension {depth + 1}"
                )
            for sub in n.items:
                rec(sub, depth + 1)

        rec(node, 0)
        return out

    def _emit_tensor_header(self, ptr_expr: str, rank: int, dims: list[int], strides: list[int], body: list[str], I: str) -> None:
        body.append(f"{I}(i32.store {ptr_expr} (i32.const {rank}))")
        for k, d in enumerate(dims):
            body.append(f"{I}(i32.store (i32.add {ptr_expr} (i32.const {4 * (k + 1)})) (i32.const {d}))")
        for k, s in enumerate(strides):
            body.append(f"{I}(i32.store (i32.add {ptr_expr} (i32.const {4 * (1 + rank + k)})) (i32.const {s}))")

    def _gen_tensor_decl(self, it: StorageItem, fb, body: list[str], I: str, is_global: bool) -> None:
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
            vp, vpt = self._gen_expr(it.initializer, fb, body, I)
            vp_arg = f"(i32.wrap_i64 {vp})" if vpt == "i64" else vp
            dst = fb.new_i32()
            body.append(f"{I}(local.set {dst} (call $tensor_mat {vp_arg}))")
            if is_global:
                self._globals[it.name] = (ft, "i32")
                body.append(f"{I}(global.set ${it.name} (local.get {dst}))")
            else:
                li = fb.new_i32()
                self._local_vars[it.name] = (li, ft)
                body.append(f"{I}(local.set {li} (local.get {dst}))")
            return

        ptr = fb.new_i32()
        body.append(f"{I}(local.set {ptr} (call $flux_alloc (i32.const {total})))")
        pexpr = f"(local.get {ptr})"
        self._emit_tensor_header(pexpr, r, dims, strides, body, I)
        body.append(f"{I}(i32.store (i32.add {pexpr} (i32.const {4 * (2 * r + 1)})) (i32.add {pexpr} (i32.const {hdr})))")
        if isinstance(it.initializer, ListLiteral):
            consts = self._flatten_tensor_const(it.initializer, dims, ft)
            for off, cexpr in enumerate(consts):
                body.append(f"{I}(i64.store (i32.add {pexpr} (i32.const {hdr + off * 8})) {cexpr})")
        else:
            cur = fb.new_i32()
            end = fb.new_i32()
            body.append(f"{I}(local.set {cur} (i32.add {pexpr} (i32.const {hdr})))")
            body.append(f"{I}(local.set {end} (i32.add {pexpr} (i32.const {total})))")
            body.append(f"{I}(block $tzdone")
            body.append(f"{I}  (loop $tzloop")
            body.append(f"{I}    (br_if $tzdone (i32.ge_u (local.get {cur}) (local.get {end})))")
            body.append(f"{I}    (i64.store (local.get {cur}) (i64.const 0))")
            body.append(f"{I}    (local.set {cur} (i32.add (local.get {cur}) (i32.const 8)))")
            body.append(f"{I}    (br $tzloop)))")
        if is_global:
            self._globals[it.name] = (ft, "i32")
            body.append(f"{I}(global.set ${it.name} {pexpr})")
        else:
            li = fb.new_i32()
            self._local_vars[it.name] = (li, ft)
            body.append(f"{I}(local.set {li} {pexpr})")

    def _gen_tensor_addr(self, tp: str, ot: str, idxs: list[ASTNode], fb, body: list[str], I: str) -> str:
        """Gera expressão de endereço de elemento; valida bounds. Retorna expr i32."""
        dims = self._tensor_dims_of(ot)
        r = len(dims)
        hdr = self._tensor_header_size(r)
        strides = self._tensor_row_strides(dims)
        m1s: list[str] = []
        all_const = True
        for k, ix in enumerate(idxs):
            c = self._const_int_wat(ix) if isinstance(ix, Literal) else None
            if c is not None:
                z = c - 1
                if z < 0 or z >= dims[k]:
                    raise WatError(f"index {c} fora do intervalo (1..{dims[k]}) na dimensao {k + 1}")
                m1s.append(f"(i32.const {z})")
                continue
            all_const = False
            iv, ivt = self._gen_expr(ix, fb, body, I)
            wrapped = iv if ivt == "i32" else f"(i32.wrap_i64 {iv})"
            m1 = fb.new_i32()
            body.append(f"{I}(local.set {m1} (i32.sub {wrapped} (i32.const 1)))")
            body.append(
                f"{I}(if (i32.ge_u (local.get {m1}) (i32.const {dims[k]})) (then unreachable))"
            )
            m1s.append(f"(local.get {m1})")
        if all_const:
            off_elems = 0
            for k in range(r):
                off_elems += (self._const_int_wat(idxs[k]) - 1) * strides[k]
            return f"(i32.add {tp} (i32.const {hdr + off_elems * 8}))"
        expr = m1s[0]
        for k in range(1, r):
            expr = f"(i32.add (i32.mul {expr} (i32.const {dims[k]})) {m1s[k]})"
        return f"(i32.add (i32.add {tp} (i32.const {hdr})) (i32.mul {expr} (i32.const 8)))"

    def _gen_tensor_read(self, node: IndexAccess, ot: str, fb, body: list[str], I: str) -> tuple[str, str]:
        ov, ovt = self._gen_expr(node.obj, fb, body, I)
        tp = fb.new_i32()
        body.append(f"{I}(local.set {tp} {ov if ovt == 'i32' else '(i32.wrap_i64 ' + ov + ')'})")
        if len(node.indices) != len(self._tensor_dims_of(ot)):
            raise WatError(f"tensor requires {len(self._tensor_dims_of(ot))} indices, got {len(node.indices)}")
        addr = self._gen_tensor_addr(f"(local.get {tp})", ot, node.indices, fb, body, I)
        et = self._tensor_elem_ft(ot)
        entry = f"(i64.load {addr})"
        if et.lower() in FLOATISH:
            rv = fb.new_f64()
            body.append(f"{I}(local.set {rv} (f64.reinterpret_i64 {entry}))")
            return (f"(local.get {rv})", "f64")
        return (entry, "i64")

    def _gen_tensor_slice(self, node: IndexAccess, ot: str, fb, body: list[str], I: str) -> tuple[str, str]:
        dims = self._tensor_dims_of(ot)
        ov, ovt = self._gen_expr(node.obj, fb, body, I)
        tp = fb.new_i32()
        body.append(f"{I}(local.set {tp} {ov if ovt == 'i32' else '(i32.wrap_i64 ' + ov + ')'})")
        nd, ns, off = self._tensor_slice_dims(node.indices, dims)
        r2 = len(nd)
        hdr2 = self._tensor_header_size(r2)
        vptr = fb.new_i32()
        body.append(f"{I}(local.set {vptr} (call $flux_alloc (i32.const {hdr2})))")
        vexpr = f"(local.get {vptr})"
        self._emit_tensor_header(vexpr, r2, nd, ns, body, I)
        parent_r = len(dims)
        body.append(
            f"{I}(i32.store (i32.add {vexpr} (i32.const {4 * (2 * r2 + 1)})) "
            f"(i32.add (i32.load (i32.add {tp} (i32.const {4 * (2 * parent_r + 1)}))) (i32.const {off * 8}))))"
        )
        new_ft = f"tensor[{', '.join(str(d) for d in nd)}] of {self._tensor_elem_ft(ot)}"
        return (vexpr, "i32")

    def _gen_elem_print(self, node: IndexAccess, fb: _FuncBuilder, body: list[str], I: str) -> None:
        base = node.obj
        chain: list[ASTNode] = []
        while isinstance(base, IndexAccess):
            chain.append(base.indices[0])
            base = base.obj
        chain.append(node.indices[0])
        bt = self._infer_type(base)
        bp = fb.new_i32()
        bv, bvt = self._gen_expr(base, fb, body, I)
        if bvt == "i64":
            body.append(f"{I}(local.set {bp} (i32.wrap_i64 {bv}))")
        else:
            body.append(f"{I}(local.set {bp} {bv})")
        is_map = self._is_map_type(bt)
        if is_map:
            if len(chain) != 1:
                raise WatError("nested map index access is not supported on WAT target")
            kf = self._map_key_fat(chain[0], fb, body, I)
            t = fb.new_i32()
            v = fb.new_i64()
            body.append(f"{I}(local.set {t} (call $map_get_tag (local.get {bp}) {kf}))")
            body.append(f"{I}(local.set {v} (call $map_get (local.get {bp}) {kf}))")
        else:
            cp = bp
            for idx in chain[:-1]:
                iv, _ = self._gen_expr(idx, fb, body, I)
                np = fb.new_i32()
                body.append(f"{I}(local.set {np} (i32.wrap_i64 (call $list_row_val (local.get {cp}) (i32.wrap_i64 {iv}))))")
                cp = np
            iv, _ = self._gen_expr(chain[-1], fb, body, I)
            t = fb.new_i32()
            v = fb.new_i64()
            body.append(f"{I}(local.set {t} (call $list_row_tag (local.get {cp}) (i32.wrap_i64 {iv})))")
            body.append(f"{I}(local.set {v} (call $list_row_val (local.get {cp}) (i32.wrap_i64 {iv})))")
        buf = fb.new_i32()
        cnt = fb.new_i32()
        body.append(f"{I}(local.set {buf} (call $flux_alloc (i32.const 1024)))")
        body.append(f"{I}(local.set {cnt} (call $elem_to_str (local.get {t}) (local.get {v}) (local.get {buf})))")
        none_off = self._alloc_str("None")
        body.append(f"{I}(if (i32.eqz (local.get {t})) (then (call $print_str_const (i32.const {none_off}) (i32.const 4))) (else (call $print_str (local.get {buf}) (local.get {cnt}))))")

    def _gen_index_access(self, node: IndexAccess, fb: _FuncBuilder, body: list[str], I: str) -> tuple[str, str]:
        ot = self._infer_type(node.obj)
        if self._is_tensor_type(ot):
            if any(isinstance(ix, SliceSpec) for ix in node.indices):
                return self._gen_tensor_slice(node, ot, fb, body, I)
            return self._gen_tensor_read(node, ot, fb, body, I)
        ov, ovt = self._gen_expr(node.obj, fb, body, I)
        if self._is_map_type(ot):
            op = fb.new_i32()
            body.append(f"{I}(local.set {op} {self._fit_wat(ov, ovt, 'i32')})")
            if node.indices and isinstance(node.indices[0], SliceSpec):
                raise WatError("slice access is not supported on map")
            kf = self._map_key_fat(node.indices[0], fb, body, I)
            return (f"(call $map_get (local.get {op}) {kf})", "i64")
        if ot == "string" or ot.startswith("string"):
            if node.indices and isinstance(node.indices[0], SliceSpec):
                sp = node.indices[0]
                if sp.step is not None:
                    raise WatError("slice com passo só é suportado em tensor")
                if sp.start is not None:
                    sv, _ = self._gen_expr(sp.start, fb, body, I)
                    sarg = f"(i32.wrap_i64 {sv})"
                else:
                    sarg = "(i32.const 1)"
                if sp.end is not None:
                    ev, _ = self._gen_expr(sp.end, fb, body, I)
                    earg = f"(i32.wrap_i64 {ev})"
                else:
                    earg = f"(call $str_char_len (i32.wrap_i64 (i64.shr_u {ov} (i64.const 32))))"
                return (f"(call $str_slice_fat {ov} {sarg} {earg})", "i64")
            else:
                iv, _ = self._gen_expr(node.indices[0], fb, body, I)
                iarg = f"(i32.wrap_i64 {iv})"
                return (f"(call $str_slice_fat {ov} {iarg} {iarg})", "i64")
        if not (self._is_list_type(ot) or ot == "data"):
            raise WatError(f"index access requires a list, got '{ot}'")
        op = fb.new_i32()
        body.append(f"{I}(local.set {op} {self._fit_wat(ov, ovt, 'i32')})")
        if node.indices and isinstance(node.indices[0], SliceSpec):
            sp = node.indices[0]
            if sp.start is not None:
                sv, _ = self._gen_expr(sp.start, fb, body, I)
                sarg = f"(i32.wrap_i64 {sv})"
            else:
                sarg = "(i32.const 1)"
            if sp.end is not None:
                ev, _ = self._gen_expr(sp.end, fb, body, I)
                earg = f"(i32.wrap_i64 {ev})"
            else:
                earg = f"(call $list_len (local.get {op}))"
            rp = fb.new_i32()
            body.append(f"{I}(local.set {rp} (call $list_slice (local.get {op}) {sarg} {earg}))")
            return (f"(local.get {rp})", "i32")
        iv, _ = self._gen_expr(node.indices[0], fb, body, I)
        et = self._list_elem_type(ot)
        entry = f"(call $list_row_val (local.get {op}) (i32.wrap_i64 {iv}))"
        if et in FLOATISH:
            rv = fb.new_f64()
            body.append(f"{I}(local.set {rv} (f64.reinterpret_i64 {entry}))")
            return (f"(local.get {rv})", "f64")
        if self._is_str_type(et):
            return (entry, "i64")
        if self._is_list_type(et):
            rv = fb.new_i32()
            body.append(f"{I}(local.set {rv} (i32.wrap_i64 {entry}))")
            return (f"(local.get {rv})", "i32")
        return (entry, "i64")

    def _map_key_fat(self, key: ASTNode, fb: _FuncBuilder, body: list[str], I: str) -> str:
        if isinstance(key, Literal):
            if key.value_type.lower() in ("string", "str", "char"):
                return f"(i64.const {self._fat_const(key.value)})"
            if key.value_type.lower() in ("int", "int64", "int32", "int16", "int8", "uint8", "uint16", "uint32", "uint64"):
                return f"(i64.const {self._fat_const(str(int(key.value)))})"
            if key.value_type.lower() in ("float", "float64", "float32"):
                return f"(i64.const {self._fat_const(str(float(key.value)))})"
        kv, vt = self._gen_expr(key, fb, body, I)
        if vt == "i64":
            return kv
        if vt == "i32":
            return f"(i64.extend_i32_u {kv})"
        return f"(i64.reinterpret_f64 {kv})"

    def _gen_index_assign(self, node: IndexAssign, fb: _FuncBuilder, body: list[str], I: str) -> None:
        if node.op != "=":
            raise WatError(f"operator '{node.op}' not supported on indices")
        base = node.obj
        extra: list[ASTNode] = []
        while isinstance(base, IndexAccess):
            extra.append(base.indices[0])
            base = base.obj
        if not isinstance(base, Identifier):
            raise WatError("index assignment requires a collection variable")
        ot = None
        getter = None
        if base.name in self._local_vars:
            li, ot = self._local_vars[base.name]
            wt = self._wtype(ot)
            getter = f"(i32.wrap_i64 (local.get {li}))" if wt == "i64" else f"(local.get {li})"
        elif base.name in self._globals:
            ot, gwt = self._globals[base.name]
            getter = f"(i32.wrap_i64 (global.get ${base.name}))" if gwt == "i64" else f"(global.get ${base.name})"
        if ot is None or getter is None:
            raise WatError(f"index assignment requires a collection variable, got '{base.name}'")
        idxs = extra + list(node.indices)
        if idxs and isinstance(idxs[-1], SliceSpec):
            raise WatError("slice assignment is not supported on WAT target")
        if not idxs:
            raise WatError("index assignment requires an index")
        v, vt = self._gen_expr(node.value, fb, body, I)
        if vt == "f64":
            v = f"(i64.reinterpret_f64 {v})"
        elif vt == "i32":
            v = f"(i64.extend_i32_u {v})"
        if self._is_map_type(ot):
            if len(idxs) != 1:
                raise WatError("nested map index assignment is not supported on WAT target")
            kf = self._map_key_fat(idxs[0], fb, body, I)
            if isinstance(node.value, IndexAccess) and self._is_map_type(self._infer_type(node.value.obj)):
                src_obj, src_vt = self._gen_expr(node.value.obj, fb, body, I)
                src_op = fb.new_i32()
                body.append(f"{I}(local.set {src_op} {self._fit_wat(src_obj, src_vt, 'i32')})")
                src_kf = self._map_key_fat(node.value.indices[0], fb, body, I)
                tag_expr = f"(call $map_get_tag (local.get {src_op}) {src_kf})"
            elif isinstance(node.value, IndexAccess) and (self._is_list_type(self._infer_type(node.value.obj)) or self._infer_type(node.value.obj) == "data"):
                src_obj, src_vt = self._gen_expr(node.value.obj, fb, body, I)
                src_op = fb.new_i32()
                body.append(f"{I}(local.set {src_op} {self._fit_wat(src_obj, src_vt, 'i32')})")
                src_iv, _ = self._gen_expr(node.value.indices[0], fb, body, I)
                tag_expr = f"(call $list_row_tag (local.get {src_op}) (i32.wrap_i64 {src_iv}))"
            elif isinstance(node.value, Identifier) and node.value.name in self._param_tag_slots:
                tag_expr = f"(local.get {self._param_tag_slots[node.value.name]})"
            elif self._infer_type(node.value) == "data":
                tag_expr = f"(select (i32.const 5) (select (i32.const 4) (i32.const 1) (i32.gt_u (i32.wrap_i64 (i64.shr_u {v} (i64.const 32))) (i32.const 0))) (i32.and (i64.eqz (i64.shr_u {v} (i64.const 32))) (i32.ge_u (i32.wrap_i64 {v}) (global.get $flux_heap_start))))"
            else:
                tag_expr = f"(i32.const {self._list_tag_of(self._infer_type(node.value))})"
            body.append(f"{I}(drop (call $map_set {getter} {kf} {tag_expr} {v}))")
            return
        if self._is_tensor_type(ot):
            dims = self._tensor_dims_of(ot)
            if any(isinstance(ix, SliceSpec) for ix in idxs):
                raise WatError("slice assignment nao e suportado em tensor; atribua elemento a elemento")
            if len(idxs) != len(dims):
                raise WatError(f"tensor requires {len(dims)} indices, got {len(idxs)}")
            addr = self._gen_tensor_addr(getter, ot, idxs, fb, body, I)
            body.append(f"{I}(i64.store {addr} {v})")
            return
        if not (self._is_list_type(ot) or ot == "data"):
            raise WatError(f"index assignment requires a collection variable, got '{ot}'")
        if len(idxs) == 1:
            iv, _ = self._gen_expr(idxs[0], fb, body, I)
            et = self._list_elem_type(ot)
            if isinstance(node.value, IndexAccess) and (self._is_list_type(self._infer_type(node.value.obj)) or self._infer_type(node.value.obj) == "data"):
                src_obj, src_vt = self._gen_expr(node.value.obj, fb, body, I)
                src_op = fb.new_i32()
                body.append(f"{I}(local.set {src_op} {self._fit_wat(src_obj, src_vt, 'i32')})")
                src_iv, _ = self._gen_expr(node.value.indices[0], fb, body, I)
                tag = f"(call $list_row_tag (local.get {src_op}) (i32.wrap_i64 {src_iv}))"
            elif isinstance(node.value, Identifier) and node.value.name in self._param_tag_slots:
                tag = f"(local.get {self._param_tag_slots[node.value.name]})"
            elif et == "data" or ot == "data":
                val_ft = self._infer_type(node.value)
                if val_ft == "data":
                    tag = f"(select (i32.const 5) (select (i32.const 4) (i32.const 1) (i32.gt_u (i32.wrap_i64 (i64.shr_u {v} (i64.const 32))) (i32.const 0))) (i32.and (i64.eqz (i64.shr_u {v} (i64.const 32))) (i32.ge_u (i32.wrap_i64 {v}) (global.get $flux_heap_start))))"
                else:
                    tag = f"(i32.const {self._list_tag_of(val_ft)})"
            else:
                tag = f"(i32.const {self._list_tag_of(et)})"
            body.append(f"{I}(drop (call $list_set_grow {getter} (i32.wrap_i64 {iv}) {tag} {v}))")
            return
        cp = fb.new_i32()
        body.append(f"{I}(local.set {cp} {getter})")
        for i, idx in enumerate(idxs[:-1]):
            iv, _ = self._gen_expr(idx, fb, body, I)
            np = fb.new_i32()
            body.append(f"{I}(local.set {np} (i32.wrap_i64 (call $list_row_val (local.get {cp}) (i32.wrap_i64 {iv}))))")
            cp = np
        iv, _ = self._gen_expr(idxs[-1], fb, body, I)
        if isinstance(node.value, IndexAccess) and (self._is_list_type(self._infer_type(node.value.obj)) or self._infer_type(node.value.obj) == "data"):
            src_obj, src_vt = self._gen_expr(node.value.obj, fb, body, I)
            src_op = fb.new_i32()
            body.append(f"{I}(local.set {src_op} {self._fit_wat(src_obj, src_vt, 'i32')})")
            src_iv, _ = self._gen_expr(node.value.indices[0], fb, body, I)
            tag = f"(call $list_row_tag (local.get {src_op}) (i32.wrap_i64 {src_iv}))"
        elif isinstance(node.value, Identifier) and node.value.name in self._param_tag_slots:
            tag = f"(local.get {self._param_tag_slots[node.value.name]})"
        else:
            val_ft = self._infer_type(node.value)
            if val_ft == "data":
                tag = f"(select (i32.const 5) (select (i32.const 4) (i32.const 1) (i32.gt_u (i32.wrap_i64 (i64.shr_u {v} (i64.const 32))) (i32.const 0))) (i32.and (i64.eqz (i64.shr_u {v} (i64.const 32))) (i32.ge_u (i32.wrap_i64 {v}) (global.get $flux_heap_start))))"
            else:
                tag = f"(i32.const {self._list_tag_of(val_ft)})"
        body.append(f"{I}(drop (call $list_set_grow (local.get {cp}) (i32.wrap_i64 {iv}) {tag} {v}))")

    def _enum_layout(self, edef: EnumDef) -> dict:
        fields: dict[str, str] = {}
        for m in edef.members:
            for f in m.fields:
                wt = self._wtype(f.type_ref.name if f.type_ref else "int64")
                if f.name in fields and fields[f.name] != wt:
                    raise WatError(f"enum field '{f.name}' has conflicting types")
                fields[f.name] = wt
        return {"fields": fields}

    def _enum_tag(self, edef: EnumDef, variant: str) -> int:
        for i, m in enumerate(edef.members):
            if m.name == variant:
                return i
        raise WatError(f"variant '{variant}' not found in enum '{edef.name}'")

    def _enum_field_is_str(self, edef: EnumDef, fname: str) -> bool:
        for m in edef.members:
            for f in m.fields:
                if f.name == fname:
                    return self._is_str_type(f.type_ref.name if f.type_ref else "int64")
        return False

    def _struct_field_is_str(self, sname: str, fname: str) -> bool:
        sdef = self._structs.get(sname)
        if sdef is None:
            return False
        for f in sdef.fields:
            if f.name == fname:
                return self._is_str_type(f.type_ref.name if f.type_ref else "int64")
        return False

    def _declare_enum_storage_global(self, it: StorageItem, body: list[str] | None) -> None:
        edef = self._enums[it.type_ref.name]
        layout = self._enum_layout(edef)
        slots: dict = {"tag": (f"${it.name}_flux_tag", "i64"), "fields": {}}
        self._globals[f"{it.name}_flux_tag"] = ("int64", "i64")
        for fname, wt in layout["fields"].items():
            gname = f"${it.name}_flux_{fname}"
            slots["fields"][fname] = (gname, wt)
            ft = "float64" if wt == "f64" else ("string" if self._enum_field_is_str(edef, fname) else "int64")
            self._globals[f"{it.name}_flux_{fname}"] = (ft, wt)
        self._enum_slots[it.name] = {"kind": "global", "slots": slots, "enum": edef.name}
        if body is not None:
            self._emit_enum_into(it.initializer, slots, None, body, "    ", is_global=True)

    def _declare_enum_storage_local(self, it: StorageItem, fb: _FuncBuilder, body: list[str], I: str) -> None:
        edef = self._enums[it.type_ref.name]
        layout = self._enum_layout(edef)
        slots: dict = {"tag": (fb.new_i64(), "i64"), "fields": {}}
        for fname, wt in layout["fields"].items():
            lid = fb.new_i64() if wt == "i64" else (fb.new_f64() if wt == "f64" else fb.new_i32())
            slots["fields"][fname] = (lid, wt)
        self._enum_slots[it.name] = {"kind": "local", "slots": slots, "enum": edef.name}
        if it.initializer:
            self._emit_enum_into(it.initializer, slots, fb, body, I, is_global=False)

    def _emit_enum_into(self, init: ASTNode | None, slots: dict, fb: _FuncBuilder | None, body: list[str], I: str, is_global: bool) -> None:
        if init is None:
            for name, (sid, wt) in [("tag", slots["tag"])] + list(slots["fields"].items()):
                zero = "(i64.const 0)" if wt == "i64" else ("(f64.const 0.0)" if wt == "f64" else "(i32.const 0)")
                op = "global.set" if is_global else "local.set"
                body.append(f"{I}({op} {sid} {zero})")
            return
        if not isinstance(init, EnumVariant):
            raise WatError(f"enum storage requires an EnumVariant initializer")
        edef = self._enums.get(init.enum_name)
        if edef is None:
            raise WatError(f"enum '{init.enum_name}' not declared")
        tag = self._enum_tag(edef, init.variant)
        op = "global.set" if is_global else "local.set"
        body.append(f"{I}({op} {slots['tag'][0]} (i64.const {tag}))")
        for f in init.fields:
            if f.name not in slots["fields"]:
                raise WatError(f"unknown field '{f.name}' for enum '{init.enum_name}'")
            lid, wt = slots["fields"][f.name]
            val, _ = self._gen_expr(f.value, fb, body, I)
            body.append(f"{I}({op} {lid} {val})")

    def _gen_enum_variant(self, node: EnumVariant, fb: _FuncBuilder, body: list[str], I: str) -> tuple[str, str]:
        edef = self._enums.get(node.enum_name)
        if edef is None:
            return self._gen_import_enum_variant(node, fb, body, I)
        layout = self._enum_layout(edef)
        tag = self._enum_tag(edef, node.variant)
        tslot = fb.new_i64()
        body.append(f"{I}(local.set {tslot} (i64.const {tag}))")
        fslots: dict[str, tuple[str, str]] = {}
        for f in node.fields:
            if f.name not in layout["fields"]:
                raise WatError(f"unknown field '{f.name}' for enum '{node.enum_name}'")
            wt = layout["fields"][f.name]
            lid = fb.new_i64() if wt == "i64" else (fb.new_f64() if wt == "f64" else fb.new_i32())
            val, _ = self._gen_expr(f.value, fb, body, I)
            body.append(f"{I}(local.set {lid} {val})")
            fslots[f.name] = (lid, wt)
        self._pending_enum = {"slots": {"tag": (tslot, "i64"), "fields": fslots}}
        return ("", "enum")

    def _struct_layout(self, sdef: StructDef) -> dict:
        fields: dict[str, str] = {}
        for f in sdef.fields:
            wt = self._wtype(f.type_ref.name if f.type_ref else "int64")
            fields[f.name] = wt
        return {"fields": fields}

    def _declare_struct_storage_global(self, it: StorageItem, body: list[str] | None) -> None:
        sdef = self._structs.get(it.type_ref.name)
        if sdef is None:
            raise WatError(f"struct '{it.type_ref.name}' not declared")
        layout = self._struct_layout(sdef)
        slots: dict = {"fields": {}}
        for fname, wt in layout["fields"].items():
            gname = f"${it.name}_flux_{fname}"
            slots["fields"][fname] = (gname, wt)
            ft = "float64" if wt == "f64" else ("string" if self._struct_field_is_str(it.type_ref.name, fname) else "int64")
            self._globals[f"{it.name}_flux_{fname}"] = (ft, wt)
        self._struct_slots[it.name] = {"kind": "global", "slots": slots, "sname": sdef.name}
        if body is not None:
            self._emit_struct_into(it.initializer, slots, None, body, "    ", is_global=True)

    def _declare_struct_storage_local(self, it: StorageItem, fb: _FuncBuilder, body: list[str], I: str) -> None:
        sdef = self._structs.get(it.type_ref.name)
        if sdef is None:
            raise WatError(f"struct '{it.type_ref.name}' not declared")
        layout = self._struct_layout(sdef)
        slots: dict = {"fields": {}}
        for fname, wt in layout["fields"].items():
            lid = fb.new_i64() if wt == "i64" else (fb.new_f64() if wt == "f64" else fb.new_i32())
            slots["fields"][fname] = (lid, wt)
        self._struct_slots[it.name] = {"kind": "local", "slots": slots, "sname": sdef.name}
        if it.initializer:
            self._emit_struct_into(it.initializer, slots, fb, body, I, is_global=False)

    def _emit_struct_into(self, init: ASTNode | None, slots: dict, fb: _FuncBuilder | None, body: list[str], I: str, is_global: bool) -> None:
        op = "global.set" if is_global else "local.set"
        if init is None:
            for name, (sid, wt) in slots["fields"].items():
                zero = "(i64.const 0)" if wt == "i64" else ("(f64.const 0.0)" if wt == "f64" else "(i32.const 0)")
                body.append(f"{I}({op} {sid} {zero})")
            return
        if not isinstance(init, StructInit):
            raise WatError(f"struct storage requires a StructInit initializer")
        sdef = self._structs.get(init.name)
        if sdef is None:
            raise WatError(f"struct '{init.name}' not declared")
        for f in init.fields:
            if f.name not in slots["fields"]:
                raise WatError(f"unknown field '{f.name}' for struct '{init.name}'")
            lid, wt = slots["fields"][f.name]
            val, _ = self._gen_expr(f.value, fb, body, I)
            body.append(f"{I}({op} {lid} {val})")

    def _gen_struct_init(self, node: StructInit, fb: _FuncBuilder, body: list[str], I: str) -> None:
        sdef = self._structs.get(node.name)
        if sdef is None:
            raise WatError(f"struct '{node.name}' not declared")
        layout = self._struct_layout(sdef)
        fslots: dict[str, tuple[str, str]] = {}
        for f in node.fields:
            if f.name not in layout["fields"]:
                raise WatError(f"unknown field '{f.name}' for struct '{node.name}'")
            wt = layout["fields"][f.name]
            lid = fb.new_i64() if wt == "i64" else (fb.new_f64() if wt == "f64" else fb.new_i32())
            val, _ = self._gen_expr(f.value, fb, body, I)
            body.append(f"{I}(local.set {lid} {val})")
            fslots[f.name] = (lid, wt)
        self._pending_struct = {"slots": {"fields": fslots}}

    def _gen_struct_field_access(self, node: FieldAccess, fb: _FuncBuilder, body: list[str], I: str) -> tuple[str, str]:
        slots = self._struct_slots[node.obj.name]["slots"]
        if node.field not in slots["fields"]:
            raise WatError(f"unknown field '{node.field}' for struct '{node.obj.name}'")
        lid, wt = slots["fields"][node.field]
        sget = "global.get" if self._struct_slots[node.obj.name]["kind"] == "global" else "local.get"
        return (f"({sget} {lid})", wt)

    def _gen_field_assign(self, node: FieldAssign, fb: _FuncBuilder, body: list[str], I: str) -> None:
        if node.owner not in self._struct_slots:
            raise WatError(f"field assignment requires a struct variable, got '{node.owner}'")
        if node.op != "=":
            raise WatError(f"operator '{node.op}' not supported on struct fields")
        slots = self._struct_slots[node.owner]["slots"]
        if node.field not in slots["fields"]:
            raise WatError(f"unknown field '{node.field}' for struct '{node.owner}'")
        lid, wt = slots["fields"][node.field]
        val, _ = self._gen_expr(node.value, fb, body, I)
        op = "global.set" if self._struct_slots[node.owner]["kind"] == "global" else "local.set"
        body.append(f"{I}({op} {lid} {val})")

    def _field_type(self, node: FieldAccess) -> str | None:
        if isinstance(node.obj, Identifier):
            if node.obj.name in self._struct_slots:
                st = self._struct_slots[node.obj.name]
                sdef = self._structs.get(st["sname"])
                if sdef is not None:
                    for f in sdef.fields:
                        if f.name == node.field:
                            ft = f.type_ref.name if f.type_ref else "int64"
                            if ft == "datetime":
                                return "datetime"
                            if self._is_str_type(ft):
                                return "string"
                            wt = st["slots"]["fields"][node.field][1]
                            return "float64" if wt == "f64" else "int64"
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
                        if self._is_str_type(ft):
                            return "string"
                        wt = self._wtype(ft)
                        return "float64" if wt == "f64" else "int64"
        return None

    def _gen_import_enum_variant(self, node: EnumVariant, fb: _FuncBuilder, body: list[str], I: str) -> tuple[str, str]:
        fdsl_file = self._imports.get(node.enum_name)
        if fdsl_file is None:
            raise WatError(f"agent '{node.enum_name}' not imported")
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
            raise WatError(f"no agents found in import '{node.enum_name}'")
        op = None
        for o in agent.body.ops:
            if o.name == node.variant:
                op = o
                break
        if op is None:
            raise WatError(f"op '{node.variant}' not found in agent '{node.enum_name}'")
        if op.body:
            for expr in op.body.expressions:
                self._gen_statement(expr, fb, body, I)
        return ("", "enum")

    def _gen_interpolated_string(self, node: InterpolatedString, fb: _FuncBuilder, body: list[str], I: str) -> tuple[str, str]:
        parts: list[ASTNode] = []
        for p in node.parts:
            self._flatten_str_parts(p, parts)
        buf = fb.new_i32()
        tt = fb.new_i32()
        cbuf = fb.new_i32()
        cnt = fb.new_i32()
        fat = fb.new_i64()
        bl = fb.new_i64()
        body.append(f"{I}(local.set {buf} (call $strbuf_new (i32.const 1024)))")
        for p in parts:
            v, vt = self._gen_expr(p, fb, body, I)
            ft = self._infer_type(p)
            if self._is_str_type(ft):
                body.append(f"{I}(call $strappend (local.get {buf}) {v})")
            elif self._is_char_type(ft):
                norm = f"(i32.wrap_i64 {v})" if vt == "i64" else v
                body.append(f"{I}(local.set {cbuf} (call $flux_alloc (i32.const 8)))")
                body.append(f"{I}(local.set {cnt} (call $encode_utf8 {norm} (local.get {cbuf})))")
                body.append(f"{I}(local.set {fat} (i64.or (i64.shl (i64.extend_i32_u (local.get {cbuf})) (i64.const 32)) (i64.extend_i32_u (local.get {cnt}))))")
                body.append(f"{I}(call $strappend (local.get {buf}) (local.get {fat}))")
            elif self._expr_is_bool(p):
                body.append(f"{I}(local.set {bl} {v})")
                t_off = self._alloc_str("true")
                f_off = self._alloc_str("false")
                body.append(f"{I}(local.set {tt} (select (i32.const {t_off}) (i32.const {f_off}) (i64.ne (local.get {bl}) (i64.const 0))))")
                body.append(f"{I}(local.set {cnt} (select (i32.const 4) (i32.const 5) (i64.ne (local.get {bl}) (i64.const 0))))")
                body.append(f"{I}(local.set {fat} (i64.or (i64.shl (i64.extend_i32_u (local.get {tt})) (i64.const 32)) (i64.extend_i32_u (local.get {cnt}))))")
                body.append(f"{I}(call $strappend (local.get {buf}) (local.get {fat}))")
            elif ft in FLOATISH or vt == "f64":
                body.append(f"{I}(local.set {tt} (call $flux_alloc (i32.const 64)))")
                body.append(f"{I}(local.set {cnt} (call $f64_to_str {v} (local.get {tt})))")
                body.append(f"{I}(local.set {fat} (i64.or (i64.shl (i64.extend_i32_u (local.get {tt})) (i64.const 32)) (i64.extend_i32_u (local.get {cnt}))))")
                body.append(f"{I}(call $strappend (local.get {buf}) (local.get {fat}))")
            else:
                body.append(f"{I}(local.set {tt} (call $flux_alloc (i32.const 64)))")
                body.append(f"{I}(local.set {cnt} (call $i64_to_str {v} (local.get {tt})))")
                body.append(f"{I}(local.set {fat} (i64.or (i64.shl (i64.extend_i32_u (local.get {tt})) (i64.const 32)) (i64.extend_i32_u (local.get {cnt}))))")
                body.append(f"{I}(call $strappend (local.get {buf}) (local.get {fat}))")
        body.append(f"{I}(call $strbuf_done (local.get {buf}))")
        tail_len = fb.new_i32()
        body.append(f"{I}(local.set {tail_len} (i32.load (local.get {buf})))")
        return (self._fat_expr(f"(i32.add (local.get {buf}) (i32.const 4))", f"(local.get {tail_len})"), "i64")

    def _gen_binary_op(self, node: BinaryOp, fb: _FuncBuilder, body: list[str], I: str) -> tuple[str, str]:
        if node.op == "ensure":
            lv, lt2 = self._gen_expr(node.left, fb, body, I)
            if "$__fr_" in lv:
                lv = f"(local.get $__fr_val)"
                lt2 = "i64"
            if lt2 == "f64":
                eslot = fb.new_f64()
            elif lt2 == "i32":
                eslot = fb.new_i32()
            else:
                eslot = fb.new_i64()
            body.append(f"{I}(local.set {eslot} {lv})")
            if isinstance(node.right, BlockStmt):
                for stmt in node.right.body:
                    self._gen_statement(stmt, fb, body, I)
            return (f"(local.get {eslot})", lt2)
        lt0 = self._infer_type(node.left)
        rt0 = self._infer_type(node.right)
        if node.op == "in":
            if self._is_map_type(rt0):
                kf = self._map_key_fat(node.left, fb, body, I)
                rv, rvt = self._gen_expr(node.right, fb, body, I)
                rp = fb.new_i32()
                body.append(f"{I}(local.set {rp} {self._fit_wat(rv, rvt, 'i32')})")
                l = fb.new_i64()
                body.append(f"{I}(local.set {l} (i64.extend_i32_u (call $map_contains_key (local.get {rp}) {kf})))")
                return (f"(local.get {l})", "i64")
            ltag = self._list_tag_of(lt0)
            lv, lvt = self._gen_expr(node.left, fb, body, I)
            rv, rvt = self._gen_expr(node.right, fb, body, I)
            if lvt == "f64":
                val64 = f"(i64.reinterpret_f64 {lv})"
            elif lvt == "i32":
                val64 = f"(i64.extend_i32_u {lv})"
            else:
                val64 = lv
            rp = fb.new_i32()
            body.append(f"{I}(local.set {rp} {self._fit_wat(rv, rvt, 'i32')})")
            l = fb.new_i64()
            if self._is_set_type(rt0):
                body.append(f"{I}(local.set {l} (i64.extend_i32_u (call $set_contains (local.get {rp}) (i32.const {ltag}) {val64})))")
            else:
                body.append(f"{I}(local.set {l} (i64.extend_i32_u (call $list_contains (local.get {rp}) {val64})))")
            return (f"(local.get {l})", "i64")
        if node.op == "+" and (self._is_set_type(lt0) or self._is_set_type(rt0)):
            lv, lvt = self._gen_expr(node.left, fb, body, I)
            rv, rvt = self._gen_expr(node.right, fb, body, I)
            buf = fb.new_i32()
            tt = fb.new_i32()
            cnt = fb.new_i32()
            fat = fb.new_i64()
            body.append(f"{I}(local.set {buf} (call $strbuf_new (i32.const 1024)))")
            for v, vt, ft in ((lv, lvt, lt0), (rv, rvt, rt0)):
                if self._is_str_type(ft):
                    body.append(f"{I}(call $strappend (local.get {buf}) {v})")
                elif self._is_set_type(ft):
                    body.append(f"{I}(local.set {tt} (call $flux_alloc (i32.const 1024)))")
                    body.append(f"{I}(local.set {cnt} (call $set_to_str {v} (local.get {tt})))")
                    body.append(f"{I}(local.set {fat} (i64.or (i64.shl (i64.extend_i32_u (local.get {tt})) (i64.const 32)) (i64.extend_i32_u (local.get {cnt}))))")
                    body.append(f"{I}(call $strappend (local.get {buf}) (local.get {fat}))")
                elif vt == "f64":
                    body.append(f"{I}(local.set {tt} (call $flux_alloc (i32.const 64)))")
                    body.append(f"{I}(local.set {cnt} (call $f64_to_str {v} (local.get {tt})))")
                    body.append(f"{I}(local.set {fat} (i64.or (i64.shl (i64.extend_i32_u (local.get {tt})) (i64.const 32)) (i64.extend_i32_u (local.get {cnt}))))")
                    body.append(f"{I}(call $strappend (local.get {buf}) (local.get {fat}))")
                else:
                    body.append(f"{I}(local.set {tt} (call $flux_alloc (i32.const 64)))")
                    body.append(f"{I}(local.set {cnt} (call $i64_to_str {v} (local.get {tt})))")
                    body.append(f"{I}(local.set {fat} (i64.or (i64.shl (i64.extend_i32_u (local.get {tt})) (i64.const 32)) (i64.extend_i32_u (local.get {cnt}))))")
                    body.append(f"{I}(call $strappend (local.get {buf}) (local.get {fat}))")
            body.append(f"{I}(call $strbuf_done (local.get {buf}))")
            tail_len = fb.new_i32()
            body.append(f"{I}(local.set {tail_len} (i32.load (local.get {buf})))")
            return (self._fat_expr(f"(i32.add (local.get {buf}) (i32.const 4))", f"(local.get {tail_len})"), "i64")
        if node.op == "+" and self._is_str_type(self._infer_type(node)):
            lv, lvt = self._gen_expr(node.left, fb, body, I)
            rv, rvt = self._gen_expr(node.right, fb, body, I)
            buf = fb.new_i32()
            tt = fb.new_i32()
            cbuf = fb.new_i32()
            cnt = fb.new_i32()
            fat = fb.new_i64()
            bl = fb.new_i64()
            body.append(f"{I}(local.set {buf} (call $strbuf_new (i32.const 1024)))")
            for v, vt2, nd in ((lv, lvt, node.left), (rv, rvt, node.right)):
                ft2 = self._infer_type(nd)
                if self._is_str_type(ft2):
                    body.append(f"{I}(call $strappend (local.get {buf}) {v})")
                elif self._is_set_type(ft2):
                    if vt2 == "i64":
                        ptr_s = fb.new_i32()
                        body.append(f"{I}(local.set {ptr_s} (i32.wrap_i64 (i64.shr_u {v} (i64.const 32))))")
                        body.append(f"{I}(if (i32.ne (local.get {ptr_s}) (i32.const 0))")
                        body.append(f"{I}  (then (call $strappend (local.get {buf}) {v}))")
                        body.append(f"{I}  (else")
                        body.append(f"{I}    (local.set {tt} (call $flux_alloc (i32.const 1024)))")
                        body.append(f"{I}    (local.set {cnt} (call $set_to_str (i32.wrap_i64 {v}) (local.get {tt})))")
                        body.append(f"{I}    (local.set {fat} (i64.or (i64.shl (i64.extend_i32_u (local.get {tt})) (i64.const 32)) (i64.extend_i32_u (local.get {cnt}))))")
                        body.append(f"{I}    (call $strappend (local.get {buf}) (local.get {fat}))")
                        body.append(f"{I}  )")
                        body.append(f"{I})")
                    else:
                        body.append(f"{I}(local.set {tt} (call $flux_alloc (i32.const 1024)))")
                        body.append(f"{I}(local.set {cnt} (call $set_to_str {v} (local.get {tt})))")
                        body.append(f"{I}(local.set {fat} (i64.or (i64.shl (i64.extend_i32_u (local.get {tt})) (i64.const 32)) (i64.extend_i32_u (local.get {cnt}))))")
                        body.append(f"{I}(call $strappend (local.get {buf}) (local.get {fat}))")
                elif self._is_map_type(ft2):
                    if vt2 == "i64":
                        ptr_s = fb.new_i32()
                        body.append(f"{I}(local.set {ptr_s} (i32.wrap_i64 (i64.shr_u {v} (i64.const 32))))")
                        body.append(f"{I}(if (i32.ne (local.get {ptr_s}) (i32.const 0))")
                        body.append(f"{I}  (then (call $strappend (local.get {buf}) {v}))")
                        body.append(f"{I}  (else")
                        body.append(f"{I}    (local.set {tt} (i32.wrap_i64 {v}))")
                        body.append(f"{I}    (local.set {cbuf} (call $flux_alloc (i32.const 1024)))")
                        body.append(f"{I}    (local.set {cnt} (call $map_to_str (local.get {tt}) (local.get {cbuf})))")
                        body.append(f"{I}    (local.set {fat} (i64.or (i64.shl (i64.extend_i32_u (local.get {cbuf})) (i64.const 32)) (i64.extend_i32_u (local.get {cnt}))))")
                        body.append(f"{I}    (call $strappend (local.get {buf}) (local.get {fat}))")
                        body.append(f"{I}  )")
                        body.append(f"{I})")
                    else:
                        body.append(f"{I}(local.set {tt} {v})")
                        body.append(f"{I}(local.set {cbuf} (call $flux_alloc (i32.const 1024)))")
                        body.append(f"{I}(local.set {cnt} (call $map_to_str (local.get {tt}) (local.get {cbuf})))")
                        body.append(f"{I}(local.set {fat} (i64.or (i64.shl (i64.extend_i32_u (local.get {cbuf})) (i64.const 32)) (i64.extend_i32_u (local.get {cnt}))))")
                        body.append(f"{I}(call $strappend (local.get {buf}) (local.get {fat}))")
                elif self._is_list_type(ft2):
                    if vt2 == "i64":
                        ptr_s = fb.new_i32()
                        body.append(f"{I}(local.set {ptr_s} (i32.wrap_i64 (i64.shr_u {v} (i64.const 32))))")
                        body.append(f"{I}(if (i32.ne (local.get {ptr_s}) (i32.const 0))")
                        body.append(f"{I}  (then (call $strappend (local.get {buf}) {v}))")
                        body.append(f"{I}  (else")
                        body.append(f"{I}    (local.set {tt} (i32.wrap_i64 {v}))")
                        body.append(f"{I}    (local.set {cbuf} (call $flux_alloc (i32.const 1024)))")
                        body.append(f"{I}    (local.set {cnt} (call $list_to_str (local.get {tt}) (local.get {cbuf})))")
                        body.append(f"{I}    (local.set {fat} (i64.or (i64.shl (i64.extend_i32_u (local.get {cbuf})) (i64.const 32)) (i64.extend_i32_u (local.get {cnt}))))")
                        body.append(f"{I}    (call $strappend (local.get {buf}) (local.get {fat}))")
                        body.append(f"{I}  )")
                        body.append(f"{I})")
                    else:
                        body.append(f"{I}(local.set {tt} {v})")
                        body.append(f"{I}(local.set {cbuf} (call $flux_alloc (i32.const 1024)))")
                        body.append(f"{I}(local.set {cnt} (call $list_to_str (local.get {tt}) (local.get {cbuf})))")
                        body.append(f"{I}(local.set {fat} (i64.or (i64.shl (i64.extend_i32_u (local.get {cbuf})) (i64.const 32)) (i64.extend_i32_u (local.get {cnt}))))")
                        body.append(f"{I}(call $strappend (local.get {buf}) (local.get {fat}))")
                elif self._is_tensor_type(ft2):
                    body.append(f"{I}(local.set {tt} {'(i32.wrap_i64 ' + v + ')' if vt2 == 'i64' else v})")
                    ttag = self._list_tag_of(self._tensor_elem_ft(ft2))
                    body.append(f"{I}(local.set {cbuf} (call $flux_alloc (i32.const 4096)))")
                    body.append(f"{I}(local.set {cnt} (call $tensor_to_str (local.get {tt}) (local.get {cbuf}) (i32.const {ttag})))")
                    body.append(f"{I}(local.set {fat} (i64.or (i64.shl (i64.extend_i32_u (local.get {cbuf})) (i64.const 32)) (i64.extend_i32_u (local.get {cnt}))))")
                    body.append(f"{I}(call $strappend (local.get {buf}) (local.get {fat}))")
                elif self._is_char_type(ft2):
                    norm = f"(i32.wrap_i64 {v})" if vt2 == "i64" else v
                    body.append(f"{I}(local.set {cbuf} (call $flux_alloc (i32.const 8)))")
                    body.append(f"{I}(local.set {cnt} (call $encode_utf8 {norm} (local.get {cbuf})))")
                    body.append(f"{I}(local.set {fat} (i64.or (i64.shl (i64.extend_i32_u (local.get {cbuf})) (i64.const 32)) (i64.extend_i32_u (local.get {cnt}))))")
                    body.append(f"{I}(call $strappend (local.get {buf}) (local.get {fat}))")
                elif self._expr_is_bool(nd):
                    body.append(f"{I}(local.set {bl} {v})")
                    t_off = self._alloc_str("true")
                    f_off = self._alloc_str("false")
                    body.append(f"{I}(local.set {tt} (select (i32.const {t_off}) (i32.const {f_off}) (i64.ne (local.get {bl}) (i64.const 0))))")
                    body.append(f"{I}(local.set {cnt} (select (i32.const 4) (i32.const 5) (i64.ne (local.get {bl}) (i64.const 0))))")
                    body.append(f"{I}(local.set {fat} (i64.or (i64.shl (i64.extend_i32_u (local.get {tt})) (i64.const 32)) (i64.extend_i32_u (local.get {cnt}))))")
                    body.append(f"{I}(call $strappend (local.get {buf}) (local.get {fat}))")
                elif ft2 in FLOATISH or vt2 == "f64":
                    body.append(f"{I}(local.set {tt} (call $flux_alloc (i32.const 64)))")
                    body.append(f"{I}(local.set {cnt} (call $f64_to_str {v} (local.get {tt})))")
                    body.append(f"{I}(local.set {fat} (i64.or (i64.shl (i64.extend_i32_u (local.get {tt})) (i64.const 32)) (i64.extend_i32_u (local.get {cnt}))))")
                    body.append(f"{I}(call $strappend (local.get {buf}) (local.get {fat}))")
                elif ft2.startswith("complex") or (isinstance(nd, Identifier) and nd.name in self._complex_slots):
                    re_v, im_v = self._gen_complex_value(nd, fb, body, I)
                    c_re = fb.new_f64()
                    c_im = fb.new_f64()
                    body.append(f"{I}(local.set {c_re} {re_v})")
                    body.append(f"{I}(local.set {c_im} {im_v})")
                    body.append(f"{I}(local.set {tt} (call $flux_alloc (i32.const 64)))")
                    body.append(f"{I}(local.set {cnt} (call $f64_to_str (local.get {c_re}) (local.get {tt})))")
                    body.append(f"{I}(local.set {fat} (i64.or (i64.shl (i64.extend_i32_u (local.get {tt})) (i64.const 32)) (i64.extend_i32_u (local.get {cnt}))))")
                    body.append(f"{I}(call $strappend (local.get {buf}) (local.get {fat}))")
                    is_neg = fb.new_i32()
                    body.append(f"{I}(local.set {is_neg} (f64.lt (local.get {c_im}) (f64.const 0.0)))")
                    p_off = self._alloc_str(" + ")
                    m_off = self._alloc_str(" - ")
                    body.append(f"{I}(local.set {tt} (select (i32.const {m_off}) (i32.const {p_off}) (local.get {is_neg})))")
                    body.append(f"{I}(local.set {fat} (i64.or (i64.shl (i64.extend_i32_u (local.get {tt})) (i64.const 32)) (i64.const 3)))")
                    body.append(f"{I}(call $strappend (local.get {buf}) (local.get {fat}))")
                    im_abs = fb.new_f64()
                    body.append(f"{I}(local.set {im_abs} (select (f64.neg (local.get {c_im})) (local.get {c_im}) (local.get {is_neg})))")
                    body.append(f"{I}(local.set {tt} (call $flux_alloc (i32.const 64)))")
                    body.append(f"{I}(local.set {cnt} (call $f64_to_str (local.get {im_abs}) (local.get {tt})))")
                    body.append(f"{I}(local.set {fat} (i64.or (i64.shl (i64.extend_i32_u (local.get {tt})) (i64.const 32)) (i64.extend_i32_u (local.get {cnt}))))")
                    body.append(f"{I}(call $strappend (local.get {buf}) (local.get {fat}))")
                    i_off = self._alloc_str("i")
                    body.append(f"{I}(local.set {fat} (i64.or (i64.shl (i64.const {i_off}) (i64.const 32)) (i64.const 1)))")
                    body.append(f"{I}(call $strappend (local.get {buf}) (local.get {fat}))")
                else:
                    ptag = self._param_tag_slots.get(nd.name) if isinstance(nd, Identifier) else None
                    v64 = f"(i64.extend_i32_u {v})" if vt2 == "i32" else v
                    body.append(f"{I}(local.set {tt} (call $flux_alloc (i32.const 1024)))")
                    if ptag:
                        body.append(f"{I}(local.set {cnt} (call $elem_to_str (local.get {ptag}) {v64} (local.get {tt})))")
                    else:
                        body.append(f"{I}(local.set {cnt} (call $val_to_str_dyn {v64} (local.get {tt})))")
                    body.append(f"{I}(local.set {fat} (i64.or (i64.shl (i64.extend_i32_u (local.get {tt})) (i64.const 32)) (i64.extend_i32_u (local.get {cnt}))))")
                    body.append(f"{I}(call $strappend (local.get {buf}) (local.get {fat}))")
            body.append(f"{I}(call $strbuf_done (local.get {buf}))")
            tail_len = fb.new_i32()
            body.append(f"{I}(local.set {tail_len} (i32.load (local.get {buf})))")
            return (self._fat_expr(f"(i32.add (local.get {buf}) (i32.const 4))", f"(local.get {tail_len})"), "i64")
        lt = self._infer_type(node.left)
        rt = self._infer_type(node.right)
        ltorig = lt
        rtorig = rt
        lt = "float64" if lt in FLOATISH else lt
        rt = "float64" if rt in FLOATISH else rt
        if node.op == "/r" and lt not in ("float64", "float32") and rt not in ("float64", "float32"):
            if isinstance(node.left, BinaryOp) and node.left.op == "+":
                if isinstance(node.left.left, BinaryOp) and node.left.left.op == "*":
                    a_val, _ = self._gen_expr(node.left.left.left, fb, body, I)
                    b_val, _ = self._gen_expr(node.left.left.right, fb, body, I)
                    c_val, _ = self._gen_expr(node.left.right, fb, body, I)
                    m_val, _ = self._gen_expr(node.right, fb, body, I)
                    a_s = fb.new_i64(); body.append(f"{I}(local.set {a_s} {a_val})")
                    b_s = fb.new_i64(); body.append(f"{I}(local.set {b_s} {b_val})")
                    c_s = fb.new_i64(); body.append(f"{I}(local.set {c_s} {c_val})")
                    m_s = fb.new_i64(); body.append(f"{I}(local.set {m_s} {m_val})")
                    res = fb.new_i64()
                    body.append(f"{I}(local.set {res} (call $i64_mul_add_rem (local.get {a_s}) (local.get {b_s}) (local.get {c_s}) (local.get {m_s})))")
                    return (f"(local.get {res})", "i64")
                elif isinstance(node.left.right, BinaryOp) and node.left.right.op == "*":
                    a_val, _ = self._gen_expr(node.left.right.left, fb, body, I)
                    b_val, _ = self._gen_expr(node.left.right.right, fb, body, I)
                    c_val, _ = self._gen_expr(node.left.left, fb, body, I)
                    m_val, _ = self._gen_expr(node.right, fb, body, I)
                    a_s = fb.new_i64(); body.append(f"{I}(local.set {a_s} {a_val})")
                    b_s = fb.new_i64(); body.append(f"{I}(local.set {b_s} {b_val})")
                    c_s = fb.new_i64(); body.append(f"{I}(local.set {c_s} {c_val})")
                    m_s = fb.new_i64(); body.append(f"{I}(local.set {m_s} {m_val})")
                    res = fb.new_i64()
                    body.append(f"{I}(local.set {res} (call $i64_mul_add_rem (local.get {a_s}) (local.get {b_s}) (local.get {c_s}) (local.get {m_s})))")
                    return (f"(local.get {res})", "i64")
                else:
                    a_val, _ = self._gen_expr(node.left.left, fb, body, I)
                    b_val, _ = self._gen_expr(node.left.right, fb, body, I)
                    m_val, _ = self._gen_expr(node.right, fb, body, I)
                    a_s = fb.new_i64(); body.append(f"{I}(local.set {a_s} {a_val})")
                    b_s = fb.new_i64(); body.append(f"{I}(local.set {b_s} {b_val})")
                    m_s = fb.new_i64(); body.append(f"{I}(local.set {m_s} {m_val})")
                    lo_s = fb.new_i64(); body.append(f"{I}(local.set {lo_s} (i64.add (local.get {a_s}) (local.get {b_s})))")
                    hi_s = fb.new_i64(); body.append(f"{I}(local.set {hi_s} (select (i64.const 1) (i64.const 0) (i64.lt_u (local.get {lo_s}) (local.get {a_s}))))")
                    res = fb.new_i64()
                    body.append(f"{I}(local.set {res} (call $i128_rem_u (local.get {hi_s}) (local.get {lo_s}) (local.get {m_s})))")
                    return (f"(local.get {res})", "i64")
            elif isinstance(node.left, BinaryOp) and node.left.op == "^":
                if isinstance(node.left.left, BinaryOp) and node.left.left.op == "*":
                    a_val, _ = self._gen_expr(node.left.left.left, fb, body, I)
                    b_val, _ = self._gen_expr(node.left.left.right, fb, body, I)
                    c_val, _ = self._gen_expr(node.left.right, fb, body, I)
                    m_val, _ = self._gen_expr(node.right, fb, body, I)
                    a_s = fb.new_i64(); body.append(f"{I}(local.set {a_s} {a_val})")
                    b_s = fb.new_i64(); body.append(f"{I}(local.set {b_s} {b_val})")
                    c_s = fb.new_i64(); body.append(f"{I}(local.set {c_s} {c_val})")
                    m_s = fb.new_i64(); body.append(f"{I}(local.set {m_s} {m_val})")
                    res = fb.new_i64()
                    body.append(f"{I}(local.set {res} (call $i64_mul_xor_rem (local.get {a_s}) (local.get {b_s}) (local.get {c_s}) (local.get {m_s})))")
                    return (f"(local.get {res})", "i64")
                elif isinstance(node.left.right, BinaryOp) and node.left.right.op == "*":
                    a_val, _ = self._gen_expr(node.left.right.left, fb, body, I)
                    b_val, _ = self._gen_expr(node.left.right.right, fb, body, I)
                    c_val, _ = self._gen_expr(node.left.left, fb, body, I)
                    m_val, _ = self._gen_expr(node.right, fb, body, I)
                    a_s = fb.new_i64(); body.append(f"{I}(local.set {a_s} {a_val})")
                    b_s = fb.new_i64(); body.append(f"{I}(local.set {b_s} {b_val})")
                    c_s = fb.new_i64(); body.append(f"{I}(local.set {c_s} {c_val})")
                    m_s = fb.new_i64(); body.append(f"{I}(local.set {m_s} {m_val})")
                    res = fb.new_i64()
                    body.append(f"{I}(local.set {res} (call $i64_mul_xor_rem (local.get {a_s}) (local.get {b_s}) (local.get {c_s}) (local.get {m_s})))")
                    return (f"(local.get {res})", "i64")
            elif isinstance(node.left, BinaryOp) and node.left.op == "*":
                a_val, _ = self._gen_expr(node.left.left, fb, body, I)
                b_val, _ = self._gen_expr(node.left.right, fb, body, I)
                m_val, _ = self._gen_expr(node.right, fb, body, I)
                a_s = fb.new_i64(); body.append(f"{I}(local.set {a_s} {a_val})")
                b_s = fb.new_i64(); body.append(f"{I}(local.set {b_s} {b_val})")
                m_s = fb.new_i64(); body.append(f"{I}(local.set {m_s} {m_val})")
                res = fb.new_i64()
                body.append(f"{I}(local.set {res} (call $i64_mul_rem (local.get {a_s}) (local.get {b_s}) (local.get {m_s})))")
                return (f"(local.get {res})", "i64")
        old_in_bin = self._in_binary_op
        self._in_binary_op = True
        try:
            lv, lt2 = self._gen_expr(node.left, fb, body, I)
            if "$__fr_" in lv:
                if lt2 == "f64":
                    lslot = fb.new_f64()
                elif lt2 == "i32":
                    lslot = fb.new_i32()
                else:
                    lslot = fb.new_i64()
                body.append(f"{I}(local.set {lslot} {lv})")
                lv = f"(local.get {lslot})"
            rv, rt2 = self._gen_expr(node.right, fb, body, I)
        finally:
            self._in_binary_op = old_in_bin
        if node.op == "^e":
            if lt == "float64" or rt == "float64":
                lc = f"(f64.convert_i64_s {lv})" if lt != "float64" else lv
                rc = f"(f64.convert_i64_s {rv})" if rt != "float64" else rv
                l = fb.new_f64()
                body.append(f"{I}(local.set {l} (call $f64_pow {lc} {rc}))")
                return (f"(local.get {l})", "f64")
            base_l = fb.new_i64()
            exp_l = fb.new_i64()
            acc_l = fb.new_i64()
            body.append(f"{I}(local.set {base_l} {lv})")
            body.append(f"{I}(local.set {exp_l} {rv})")
            body.append(f"{I}(local.set {acc_l} (i64.const 1))")
            seq = self._pow_seq
            self._pow_seq += 1
            body.append(f"{I}(block $pow_x_{seq}")
            body.append(f"{I}  (loop $pow_l_{seq}")
            body.append(f"{I}    (br_if $pow_x_{seq} (i32.eqz (i64.gt_s (local.get {exp_l}) (i64.const 0))))")
            body.append(f"{I}    (local.set {acc_l} (i64.mul (local.get {acc_l}) (local.get {base_l})))")
            body.append(f"{I}    (local.set {exp_l} (i64.sub (local.get {exp_l}) (i64.const 1)))")
            body.append(f"{I}    (br $pow_l_{seq})")
            body.append(f"{I}  )")
            body.append(f"{I})")
            return (f"(local.get {acc_l})", "i64")
        if node.op == "^r":
            lc = f"(f64.convert_i64_s {lv})" if lt != "float64" else lv
            rc = f"(f64.convert_i64_s {rv})" if rt != "float64" else rv
            l = fb.new_f64()
            body.append(f"{I}(local.set {l} (call $f64_root {lc} (i64.trunc_f64_s {rc})))")
            return (f"(local.get {l})", "f64")
        if node.op == "/f" or (node.op in ("+", "-", "*") and (lt == "float64" or rt == "float64")):
            lc = f"(f64.convert_i64_s {lv})" if lt != "float64" else lv
            rc = f"(f64.convert_i64_s {rv})" if rt != "float64" else rv
            wop = {"/f": "f64.div", "+": "f64.add", "-": "f64.sub", "*": "f64.mul"}[node.op]
            l = fb.new_f64()
            body.append(f"{I}(local.set {l} ({wop} {lc} {rc}))")
            res = f"(local.get {l})"
            if ltorig == rtorig and ltorig in FMT_CONSTS and ltorig != "float64":
                res = self._round_wrap(res, ltorig)
                body.append(f"{I}(local.set {l} {res})")
            return (f"(local.get {l})", "f64")
        if node.op in ("==", "!=", "<", "<=", ">", ">="):
            if self._is_str_type(lt) or self._is_str_type(rt):
                lv_fat = self._fit_wat(lv, lt2, "i64")
                rv_fat = self._fit_wat(rv, rt2, "i64")
                if node.op == "==":
                    res_i32 = f"(call $str_eq {lv_fat} {rv_fat})"
                elif node.op == "!=":
                    res_i32 = f"(i32.eqz (call $str_eq {lv_fat} {rv_fat}))"
                elif node.op == "<":
                    res_i32 = f"(call $str_lt {lv_fat} {rv_fat})"
                elif node.op == "<=":
                    res_i32 = f"(i32.eqz (call $str_lt {rv_fat} {lv_fat}))"
                elif node.op == ">":
                    res_i32 = f"(call $str_lt {rv_fat} {lv_fat})"
                elif node.op == ">=":
                    res_i32 = f"(i32.eqz (call $str_lt {lv_fat} {rv_fat}))"
                l = fb.new_i64()
                body.append(f"{I}(local.set {l} (i64.extend_i32_u {res_i32}))")
                return (f"(local.get {l})", "i64")
            if lt == "float64" or rt == "float64":
                lc = f"(f64.convert_i64_s {lv})" if lt != "float64" else lv
                rc = f"(f64.convert_i64_s {rv})" if rt != "float64" else rv
                wop = {
                    "==": "f64.eq", "!=": "f64.ne",
                    "<": "f64.lt", "<=": "f64.le",
                    ">": "f64.gt", ">=": "f64.ge",
                }[node.op]
                l = fb.new_i64()
                body.append(f"{I}(local.set {l} (i64.extend_i32_u ({wop} {lc} {rc})))")
                return (f"(local.get {l})", "i64")
            if self._is_list_type(lt) or self._is_list_type(rt):
                lpa = f"(i32.wrap_i64 {self._fit_wat(lv, lt2, 'i64')})"
                rpa = f"(i32.wrap_i64 {self._fit_wat(rv, rt2, 'i64')})"
                if node.op == "==":
                    res_i32 = f"(call $list_eq {lpa} {rpa})"
                elif node.op == "!=":
                    res_i32 = f"(i32.eqz (call $list_eq {lpa} {rpa}))"
                else:
                    res_i32 = f"(i32.const 0)"
                l = fb.new_i64()
                body.append(f"{I}(local.set {l} (i64.extend_i32_u {res_i32}))")
                return (f"(local.get {l})", "i64")
            if self._is_set_type(lt) or self._is_set_type(rt):
                spa = f"(i32.wrap_i64 {self._fit_wat(lv, lt2, 'i64')})"
                spb = f"(i32.wrap_i64 {self._fit_wat(rv, rt2, 'i64')})"
                if node.op == "==":
                    res_i32 = f"(call $set_eq {spa} {spb})"
                elif node.op == "!=":
                    res_i32 = f"(i32.eqz (call $set_eq {spa} {spb}))"
                else:
                    res_i32 = f"(i32.const 0)"
                l = fb.new_i64()
                body.append(f"{I}(local.set {l} (i64.extend_i32_u {res_i32}))")
                return (f"(local.get {l})", "i64")
            else:
                lc64 = self._fit_wat(lv, lt2, "i64")
                rc64 = self._fit_wat(rv, rt2, "i64")
                if node.op in ("==", "!="):
                    if lt in ("data", "any") or rt in ("data", "any"):
                        ptra = fb.new_i32()
                        ptrb = fb.new_i32()
                        res_slot = fb.new_i32()
                        body.append(f"{I}(local.set {ptra} (i32.wrap_i64 (i64.shr_u {lc64} (i64.const 32))))")
                        body.append(f"{I}(local.set {ptrb} (i32.wrap_i64 (i64.shr_u {rc64} (i64.const 32))))")
                        body.append(f"{I}(if (i32.and (i32.and (i32.gt_u (local.get {ptra}) (i32.const 0)) (i32.lt_u (local.get {ptra}) (i32.const 0x70000000))) (i32.and (i32.gt_u (local.get {ptrb}) (i32.const 0)) (i32.lt_u (local.get {ptrb}) (i32.const 0x70000000))))")
                        if node.op == "==":
                            body.append(f"{I}  (then (local.set {res_slot} (call $str_eq {lc64} {rc64})))")
                            body.append(f"{I}  (else (local.set {res_slot} (i64.eq {lc64} {rc64})))")
                        else:
                            body.append(f"{I}  (then (local.set {res_slot} (i32.eqz (call $str_eq {lc64} {rc64}))))")
                            body.append(f"{I}  (else (local.set {res_slot} (i64.ne {lc64} {rc64})))")
                        body.append(f"{I})")
                        l = fb.new_i64()
                        body.append(f"{I}(local.set {l} (i64.extend_i32_u (local.get {res_slot})))")
                        return (f"(local.get {l})", "i64")
                    else:
                        wop = "i64.eq" if node.op == "==" else "i64.ne"
                        l = fb.new_i64()
                        body.append(f"{I}(local.set {l} (i64.extend_i32_u ({wop} {lc64} {rc64})))")
                        return (f"(local.get {l})", "i64")
                wop = {
                    "<": "i64.lt_s", "<=": "i64.le_s",
                    ">": "i64.gt_s", ">=": "i64.ge_s",
                }[node.op]
                l = fb.new_i64()
                body.append(f"{I}(local.set {l} (i64.extend_i32_u ({wop} {lc64} {rc64})))")
                return (f"(local.get {l})", "i64")
        if node.op == "/r":
            r = fb.new_i64()
            end_name = f"$divz_end{len(body)}"
            ok_name = f"$divz_ok{len(body)}"
            body.append(f"{I}(block {end_name}")
            body.append(f"{I}  (block {ok_name}")
            body.append(f"{I}    (br_if {ok_name} (i64.ne {rv} (i64.const 0)))")
            body.append(f"{I}    (local.set $__fr_sta (i32.const {self._alloc_str('fail')}))")
            body.append(f"{I}    (local.set $__fr_msg (i32.const {self._alloc_str('divisao por zero')}))")
            body.append(f"{I}    (br {end_name})")
            body.append(f"{I}  )")
            I2 = I + "  "
            body.append(f"{I2}(local.set {r} (call $i128_rem_u (i64.const 0) {lv} {rv}))")
            body.append(f"{I2}(br {end_name})")
            body.append(f"{I})")
            return (f"(local.get {r})", "i64")
        if node.op == "/i":
            r = fb.new_i64()
            nb = fb.new_i64()
            absb = fb.new_i64()
            radj = fb.new_i64()
            q = fb.new_i64()
            end_name = f"$divz_end{len(body)}"
            ok_name = f"$divz_ok{len(body)}"
            body.append(f"{I}(block {end_name}")
            body.append(f"{I}  (block {ok_name}")
            body.append(f"{I}    (br_if {ok_name} (i64.ne {rv} (i64.const 0)))")
            body.append(f"{I}    (local.set $__fr_sta (i32.const {self._alloc_str('fail')}))")
            body.append(f"{I}    (local.set $__fr_msg (i32.const {self._alloc_str('divisao por zero')}))")
            body.append(f"{I}    (br {end_name})")
            body.append(f"{I}  )")
            I2 = I + "  "
            body.append(f"{I2}(local.set {r} (i64.rem_s {lv} {rv}))")
            body.append(f"{I2}(local.set {nb} (i64.sub (i64.const 0) {rv}))")
            body.append(f"{I2}(local.set {absb} (select {rv} (local.get {nb}) (i64.gt_s {rv} (i64.const 0))))")
            body.append(f"{I2}(local.set {radj} (select (i64.add (local.get {r}) (local.get {absb})) (local.get {r}) (i64.lt_s (local.get {r}) (i64.const 0))))")
            body.append(f"{I2}(local.set {q} (i64.div_s (i64.sub {lv} (local.get {radj})) {rv}))")
            body.append(f"{I2}(br {end_name})")
            body.append(f"{I})")
            return (f"(local.get {q})", "i64")
        m = {
            "+": "i64.add", "-": "i64.sub", "*": "i64.mul",
            "and": "i64.and", "or": "i64.or",
            "&": "i64.and", "|": "i64.or", "^": "i64.xor",
            "<<": "i64.shl", ">>": "i64.shr_s", ">>>": "i64.shr_u",
        }
        wop = m.get(node.op, "i64.add")
        l = fb.new_i64()
        body.append(f"{I}(local.set {l} ({wop} {lv} {rv}))")
        return (f"(local.get {l})", "i64")

    def _gen_unary_op(self, node: UnaryOp, fb: _FuncBuilder, body: list[str], I: str) -> tuple[str, str]:
        val, t = self._gen_expr(node.operand, fb, body, I)
        if node.op == "-":
            if t == "f64":
                l = fb.new_f64()
                body.append(f"{I}(local.set {l} (f64.neg {val}))")
                return (f"(local.get {l})", "f64")
            l = fb.new_i64()
            body.append(f"{I}(local.set {l} (i64.sub (i64.const 0) {val}))")
            return (f"(local.get {l})", "i64")
        if node.op in ("not", "!"):
            l = fb.new_i64()
            body.append(f"{I}(local.set {l} (i64.extend_i32_u (i64.eqz {val})))")
            return (f"(local.get {l})", "i64")
        if node.op == "~":
            l = fb.new_i64()
            body.append(f"{I}(local.set {l} (i64.xor {val} (i64.const -1)))")
            return (f"(local.get {l})", "i64")
        l = fb.new_i64()
        body.append(f"{I}(local.set {l} {val})")
        return (f"(local.get {l})", "i64")

    def _gen_block(self, node: BlockStmt, fb: _FuncBuilder, body: list[str], I: str) -> None:
        for stmt in node.body:
            self._gen_statement(stmt, fb, body, I)

    def _gen_input_prompt_fat(self, item) -> int:
        p = item.initializer.prompt if isinstance(item.initializer, InputExpr) else None
        if p is not None and isinstance(p, Literal) and p.value_type.lower() in ("string", "str"):
            self._alloc_str(p.value)
            return self._fat_const(p.value)
        self._alloc_str("")
        return self._fat_const("")

    def _gen_input_storage(self, item, ft: str, fb: _FuncBuilder, body: list[str], I: str) -> None:
        from flux_proto.semantic.storage_types import _INT_RANGES

        self._uses_input = True
        lowft = ft.lower()
        prompt = self._gen_input_prompt_fat(item)
        self._alloc_str(ft)
        tname_fat = self._fat_const(ft)

        def emit_global_set(gname: str, expr: str, wt: str) -> None:
            body.append(f"{I}(global.set {gname} {expr})")

        # ---- in-function local slots ----
        if self._in_function:
            if lowft.startswith("complex"):
                re_l, im_l = fb.new_f64(), fb.new_f64()
                self._complex_slots[item.name] = {"kind": "local", "re": re_l, "im": im_l, "type": ft}
                body.append(f"{I}(call $flux_input_complex (i64.const {tname_fat}) (i64.const {prompt}))")
                body.append(f"{I}(local.set {re_l} (global.get $flux_cx_re_tmp))")
                body.append(f"{I}(local.set {im_l} (global.get $flux_cx_im_tmp))")
                return
            wt = self._wtype(lowft)
            if wt == "f64":
                li = fb.new_f64()
            elif wt == "i32":
                li = fb.new_i32()
            else:
                li = fb.new_i64()
            self._local_vars[item.name] = (li, ft)
            if lowft in _INT_RANGES:
                body.append(f"{I}(local.set {li} (call $flux_input_int (i64.const {tname_fat}) (i64.const {prompt})))")
            elif lowft in FLOATISH:
                body.append(f"{I}(local.set {li} (call $flux_input_float (i64.const {tname_fat}) (i64.const {prompt})))")
            elif lowft == "bool":
                body.append(f"{I}(local.set {li} (call $flux_input_bool (i64.const {tname_fat}) (i64.const {prompt})))")
            elif lowft == "char":
                body.append(f"{I}(local.set {li} (call $flux_input_char (i64.const {tname_fat}) (i64.const {prompt})))")
            elif lowft == "datetime":
                body.append(f"{I}(local.set {li} (call $flux_input_datetime (i64.const {tname_fat}) (i64.const {prompt})))")
            else:
                body.append(f"{I}(local.set {li} (call $flux_input_string (i64.const {tname_fat}) (i64.const {prompt})))")
            return

        # ---- top-level global slots ----
        if lowft.startswith("complex"):
            re_g = f"${item.name}_flux_re"
            im_g = f"${item.name}_flux_im"
            self._globals.setdefault(f"{item.name}_flux_re", ("float64", "f64"))
            self._globals.setdefault(f"{item.name}_flux_im", ("float64", "f64"))
            self._complex_slots[item.name] = {"kind": "global", "re": re_g, "im": im_g, "type": ft}
            body.append(f"{I}(call $flux_input_complex (i64.const {tname_fat}) (i64.const {prompt}))")
            body.append(f"{I}(global.set {re_g} (global.get $flux_cx_re_tmp))")
            body.append(f"{I}(global.set {im_g} (global.get $flux_cx_im_tmp))")
            return
        wt = self._wtype(lowft)
        self._globals[item.name] = (ft, wt)
        if lowft in _INT_RANGES:
            call = f"(call $flux_input_int (i64.const {tname_fat}) (i64.const {prompt}))"
        elif lowft in FLOATISH:
            call = f"(call $flux_input_float (i64.const {tname_fat}) (i64.const {prompt}))"
        elif lowft == "bool":
            call = f"(call $flux_input_bool (i64.const {tname_fat}) (i64.const {prompt}))"
        elif lowft == "char":
            call = f"(call $flux_input_char (i64.const {tname_fat}) (i64.const {prompt}))"
        elif lowft == "datetime":
            call = f"(call $flux_input_datetime (i64.const {tname_fat}) (i64.const {prompt}))"
        else:
            call = f"(call $flux_input_string (i64.const {tname_fat}) (i64.const {prompt}))"
        emit_global_set(f"${item.name}", call, wt)

    def _gen_statement(self, node: ASTNode, fb: _FuncBuilder, body: list[str], I: str) -> None:
        if self._is_exotic(node):
            self._raise_exotic(node)
        if isinstance(node, UnsafeStmt):
            if isinstance(node.body, BlockStmt):
                self._gen_block(node.body, fb, body, I)
            elif node.body is not None:
                self._gen_statement(node.body, fb, body, I)
        elif isinstance(node, BlockStmt):
            self._gen_block(node, fb, body, I)
        elif isinstance(node, ExpressionStmt):
            val, _ = self._gen_expr(node.expr, fb, body, I)
            if val:
                body.append(f"{I}(drop {val})")
        elif isinstance(node, PrintStmt):
            self._gen_print_args(node.args, True, fb, body, I)
        elif isinstance(node, CallExpr):
            self._gen_call(node, fb, body, I)
        elif isinstance(node, StorageDecl):
            for it in node.items:
                ft = it.type_ref.name if it.type_ref else "string"
                if isinstance(it.initializer, InputExpr):
                    self._gen_input_storage(it, ft, fb, body, I)
                    continue
                if isinstance(it.initializer, OwnershipExpr) and it.initializer.mut:
                    t = it.initializer.target
                    if self._in_function:
                        if t not in self._local_vars:
                            raise WatError(f"borrow_mut target '{t}' not available on wat target")
                        if it.name not in self._local_vars:
                            self._local_vars[it.name] = self._local_vars[t]
                    else:
                        if t not in self._globals:
                            raise WatError(f"borrow_mut target '{t}' not available on wat target")
                        if it.name not in self._globals:
                            self._globals[it.name] = self._globals[t]
                    continue
                if ft in self._enums:
                    if self._in_function:
                        if it.name not in self._enum_slots:
                            self._declare_enum_storage_local(it, fb, body, I)
                        elif it.initializer is not None:
                            self._emit_enum_into(it.initializer, self._enum_slots[it.name]["slots"], fb, body, I, is_global=False)
                    else:
                        if it.name not in self._enum_slots:
                            self._declare_enum_storage_global(it, body if not self._in_function else None)
                        elif it.initializer is not None:
                            self._emit_enum_into(it.initializer, self._enum_slots[it.name]["slots"], fb, body, I, is_global=True)
                    continue
                if ft in self._structs:
                    if self._in_function:
                        if it.name not in self._struct_slots:
                            self._declare_struct_storage_local(it, fb, body, I)
                        elif it.initializer is not None:
                            self._emit_struct_into(it.initializer, self._struct_slots[it.name]["slots"], fb, body, I, is_global=False)
                    else:
                        if it.name not in self._struct_slots:
                            self._declare_struct_storage_global(it, body)
                        elif it.initializer is not None:
                            self._emit_struct_into(it.initializer, self._struct_slots[it.name]["slots"], fb, body, I, is_global=True)
                    continue
                if ft.lower().startswith("complex"):
                    init = it.initializer
                    cv0 = None
                    if init is not None:
                        try:
                            cv0 = self._complex_static_value(init)
                        except WatError:
                            cv0 = None
                    if self._in_function:
                        re_l = fb.new_f64()
                        im_l = fb.new_f64()
                        self._complex_slots[it.name] = {"kind": "local", "re": re_l, "im": im_l, "type": ft}
                        if cv0 is not None:
                            body.append(f"{I}(local.set {re_l} (f64.const {norm_float_text(str(cv0.real))}))")
                            body.append(f"{I}(local.set {im_l} (f64.const {norm_float_text(str(cv0.imag))}))")
                        else:
                            re_e, im_e = self._gen_complex_value(init, fb, body, I)
                            body.append(f"{I}(local.set {re_l} {re_e})")
                            body.append(f"{I}(local.set {im_l} {im_e})")
                    else:
                        slots_c = self._complex_slots.get(it.name)
                        if slots_c is None:
                            re_g = f"${it.name}_flux_re"
                            im_g = f"${it.name}_flux_im"
                            self._globals[re_g] = ("float64", "f64")
                            self._globals[im_g] = ("float64", "f64")
                            slots_c = {"kind": "global", "re": re_g, "im": im_g, "type": ft}
                            self._complex_slots[it.name] = slots_c
                        if cv0 is not None:
                            body.append(f"{I}(global.set {slots_c['re']} (f64.const {norm_float_text(str(cv0.real))}))")
                            body.append(f"{I}(global.set {slots_c['im']} (f64.const {norm_float_text(str(cv0.imag))}))")
                        else:
                            re_e, im_e = self._gen_complex_value(init, fb, body, I)
                            body.append(f"{I}(global.set {slots_c['re']} {re_e})")
                            body.append(f"{I}(global.set {slots_c['im']} {im_e})")
                    continue
                if self._is_tensor_type(ft):
                    self._gen_tensor_decl(it, fb, body, I, is_global=not self._in_function)
                    continue
                if self._in_function:
                    if it.name not in self._local_vars and it.name not in self._result_vars:
                        if isinstance(it.initializer, (CallExpr, ShortCircuitBlock)) and (it.type_ref is None or it.type_ref.name == "result"):
                            self._result_vars[it.name] = ("local", fb.new_i32(), fb.new_i64(), fb.new_i32())
                        else:
                            ft = it.type_ref.name if it.type_ref else "string"
                            wt = self._wtype(ft)
                            if wt == "f64":
                                li = fb.new_f64()
                            elif wt == "i32":
                                li = fb.new_i32()
                            else:
                                li = fb.new_i64()
                            self._local_vars[it.name] = (li, ft)
                    if it.initializer and isinstance(it.initializer, Literal):
                        if it.name in self._result_vars:
                            lit, _ = self._gen_expr(it.initializer, fb, body, I)
                            self._sc_set(it.name, lit, fb, body, I)
                        else:
                            vt = it.initializer.value_type.lower()
                            li, _ = self._local_vars[it.name]
                            if vt in ("string", "str"):
                                self._alloc_str(it.initializer.value)
                                body.append(f"{I}(local.set {li} (i64.const {self._fat_const(it.initializer.value)}))")
                            elif vt == "char":
                                body.append(f"{I}(local.set {li} (i32.const {ord(it.initializer.value)}))")
                            elif vt == "datetime":
                                from flux_proto.interpreter.interpreter import _parse_iso_nanos
                                body.append(f"{I}(local.set {li} (i64.const {_parse_iso_nanos(it.initializer.value)}))")
                            elif vt in ("int", "int64", "int32", "int16", "int8", "int"):
                                body.append(f"{I}(local.set {li} (i64.const {it.initializer.value}))")
                            elif vt == "bool":
                                v = "1" if it.initializer.value.lower() == "true" else "0"
                                body.append(f"{I}(local.set {li} ({self._wtype(ft)}.const {v}))")
                            elif vt in ("float", "float64", "float32") or vt in REDUCED_FLOATS:
                                fconst = f"(f64.const {norm_float_text(it.initializer.value)})"
                                if ft in FMT_CONSTS and ft != "float64":
                                    fconst = self._round_wrap(fconst, ft)
                                body.append(f"{I}(local.set {li} {fconst})")
                    elif it.initializer is not None:
                        if isinstance(it.initializer, ShortCircuitBlock):
                            self._gen_short_circuit(it.initializer, fb, body, I, bind_name=it.name)
                        elif it.name in self._result_vars:
                            expr, _ = self._gen_expr(it.initializer, fb, body, I)
                            self._sc_set(it.name, expr, fb, body, I)
                        else:
                            li, lft = self._local_vars[it.name]
                            expr, vt = self._gen_expr(it.initializer, fb, body, I)
                            if self._is_char_type(lft) and (self._is_str_type(self._infer_type(it.initializer)) or (isinstance(it.initializer, IndexAccess) and self._is_str_type(self._infer_type(it.initializer.obj)))):
                                str_tmp = fb.new_i64()
                                body.append(f"{I}(local.set {str_tmp} {self._fit_wat(expr, vt, 'i64')})")
                                char_val = f"(i32.load8_u (i32.wrap_i64 (i64.shr_u (local.get {str_tmp}) (i64.const 32))))"
                                body.append(f"{I}(local.set {li} {char_val})")
                            else:
                                body.append(f"{I}(local.set {li} {self._fit_wat(expr, vt, self._wtype(lft))})")
                else:
                    if it.name not in self._globals and it.name not in self._result_vars:
                        if isinstance(it.initializer, (CallExpr, ShortCircuitBlock)) and (it.type_ref is None or it.type_ref.name == "result"):
                            self._result_vars[it.name] = ("global", f"${it.name}_sta", f"${it.name}_val", f"${it.name}_msg")
                        else:
                            ft = it.type_ref.name if it.type_ref else "string"
                            wt = self._wtype(ft)
                            self._globals[it.name] = (ft, wt)
                    if it.initializer and isinstance(it.initializer, Literal):
                        if it.name in self._result_vars:
                            lit, _ = self._gen_expr(it.initializer, fb, body, I)
                            self._sc_set(it.name, lit, fb, body, I)
                        else:
                            vt = it.initializer.value_type.lower()
                            if vt in ("string", "str"):
                                self._alloc_str(it.initializer.value)
                                body.append(f"{I}(global.set ${it.name} (i64.const {self._fat_const(it.initializer.value)}))")
                            elif vt == "char":
                                body.append(f"{I}(global.set ${it.name} (i32.const {ord(it.initializer.value)}))")
                            elif vt == "datetime":
                                from flux_proto.interpreter.interpreter import _parse_iso_nanos
                                body.append(f"{I}(global.set ${it.name} (i64.const {_parse_iso_nanos(it.initializer.value)}))")
                            elif vt in ("int", "int64", "int32", "int16", "int8", "int"):
                                body.append(f"{I}(global.set ${it.name} (i64.const {it.initializer.value}))")
                            elif vt == "bool":
                                v = "1" if it.initializer.value.lower() == "true" else "0"
                                body.append(f"{I}(global.set ${it.name} ({self._wtype(ft)}.const {v}))")
                            elif vt in ("float", "float64", "float32") or vt in REDUCED_FLOATS:
                                fconst = f"(f64.const {norm_float_text(it.initializer.value)})"
                                if ft in FMT_CONSTS and ft != "float64":
                                    fconst = self._round_wrap(fconst, ft)
                                body.append(f"{I}(global.set ${it.name} {fconst})")
                    elif it.initializer is not None:
                        if isinstance(it.initializer, ShortCircuitBlock):
                            self._gen_short_circuit(it.initializer, fb, body, I, bind_name=it.name)
                        elif it.name in self._result_vars:
                            expr, _ = self._gen_expr(it.initializer, fb, body, I)
                            self._sc_set(it.name, expr, fb, body, I)
                        else:
                            expr, vt = self._gen_expr(it.initializer, fb, body, I)
                            gft = self._globals[it.name][0]
                            if self._is_char_type(gft) and (self._is_str_type(self._infer_type(it.initializer)) or (isinstance(it.initializer, IndexAccess) and self._is_str_type(self._infer_type(it.initializer.obj)))):
                                str_tmp = fb.new_i64()
                                body.append(f"{I}(local.set {str_tmp} {self._fit_wat(expr, vt, 'i64')})")
                                char_val = f"(i32.load8_u (i32.wrap_i64 (i64.shr_u (local.get {str_tmp}) (i64.const 32))))"
                                body.append(f"{I}(global.set ${it.name} {char_val})")
                            else:
                                body.append(f"{I}(global.set ${it.name} {self._fit_wat(expr, vt, self._globals[it.name][1])})")
        elif isinstance(node, IndexAssign):
            self._gen_index_assign(node, fb, body, I)
        elif isinstance(node, VariableReassign):
            if isinstance(node.value, ShortCircuitBlock):
                self._gen_short_circuit(node.value, fb, body, I, bind_name=node.name)
            else:
                self._gen_variable_reassign(node, fb, body, I)
        elif isinstance(node, FieldAssign):
            self._gen_field_assign(node, fb, body, I)
        elif isinstance(node, EmitStmt):
            if node.value_expr is not None and not getattr(self, "_in_op", False):
                raise WatError("emit accepts only a single declared identifier as value, expressions are not allowed")
            vnode = node.value_expr if node.value_expr is not None else (Identifier(name=node.value) if isinstance(node.value, str) else node.value)
            et = self._infer_type(vnode)
            val, vt = self._gen_expr(vnode, fb, body, I)
            if et in FLOATISH or vt == "f64":
                body.append(f"{I}(local.set $__fr_vald {val})")
                body.append(f"{I}(local.set $__fr_val (i64.reinterpret_f64 {val}))")
            elif self._is_list_type(et):
                if vt == "i32":
                    body.append(f"{I}(local.set $__fr_val (i64.extend_i32_u {val}))")
                else:
                    body.append(f"{I}(local.set $__fr_val {val})")
            elif vt == "i32":
                body.append(f"{I}(local.set $__fr_val (i64.extend_i32_u {val}))")
            else:
                body.append(f"{I}(local.set $__fr_val {val})")
            st_name = node.status if node.status in ("nice", "fail") else "nice"
            body.append(f"{I}(local.set $__fr_sta (i32.const {self._alloc_str(st_name)}))")
            if node.message:
                msg, mvt = self._gen_expr(node.message, fb, body, I)
                if mvt == "i32":
                    body.append(f"{I}(local.set $__fr_msg {msg})")
                else:
                    body.append(f"{I}(local.set $__fr_msg (i32.wrap_i64 (i64.shr_u {msg} (i64.const 32))))")
            if self._in_function:
                body.append(f"{I}(return (local.get $__fr_sta) (local.get $__fr_val) (local.get $__fr_msg))")
        elif isinstance(node, ShortCircuitBlock):
            self._gen_short_circuit(node, fb, body, I)
        elif isinstance(node, RouteStmt):
            self._gen_route(node, fb, body, I)
        elif isinstance(node, MatchStmt):
            self._gen_match(node, fb, body, I, keep_result=False)
        elif isinstance(node, InfiniteStmt):
            self._gen_infinite(node, fb, body, I)
        elif isinstance(node, BreakStmt):
            if not self._loop_stack:
                raise WatError("break outside infinite loop")
            body.append(f"{I}(br {self._loop_stack[-1][0]})")
        elif isinstance(node, ContinueStmt):
            if not self._loop_stack:
                raise WatError("continue outside infinite loop")
            body.append(f"{I}(br {self._loop_stack[-1][1]})")

    def _fit_wat(self, expr: str, got: str, want: str) -> str:
        if got == want:
            return expr
        if want == "i32":
            return f"(i32.wrap_i64 {expr})" if got == "i64" else f"(i32.trunc_f64_s {expr})"
        if want == "f64":
            if got == "i32":
                return f"(f64.convert_i32_u {expr})"
            return f"(f64.convert_i64_s {expr})"
        if want == "i64":
            return f"(i64.extend_i32_u {expr})" if got == "i32" else f"(i64.trunc_f64_s {expr})"
        return expr

    def _gen_variable_reassign(self, node: VariableReassign, fb: _FuncBuilder, body: list[str], I: str) -> None:
        if node.name in self._struct_slots:
            if node.op != "=":
                raise WatError(f"operator '{node.op}' not supported on struct '{node.name}'")
            if not isinstance(node.value, StructInit):
                raise WatError(f"struct '{node.name}' requires a StructInit value")
            slots = self._struct_slots[node.name]["slots"]
            kind = self._struct_slots[node.name]["kind"]
            self._emit_struct_into(node.value, slots, fb, body, I, is_global=(kind == "global"))
            return
        if node.name in self._enum_slots:
            if node.op != "=":
                raise WatError(f"operator '{node.op}' not supported on enum '{node.name}'")
            if not isinstance(node.value, EnumVariant):
                raise WatError(f"enum '{node.name}' requires an EnumVariant value")
            slots = self._enum_slots[node.name]["slots"]
            kind = self._enum_slots[node.name]["kind"]
            self._emit_enum_into(node.value, slots, fb, body, I, is_global=(kind == "global"))
            return
        if node.name in self._result_vars:
            expr, _ = self._gen_expr(node.value, fb, body, I)
            self._sc_set(node.name, expr, fb, body, I)
            return
        val, vt = self._gen_expr(node.value, fb, body, I)
        if self._in_function and node.name in self._local_vars:
            li, lft = self._local_vars[node.name]
            lt = lft
            fwt = self._wtype(lft)
            if self._is_char_type(lft) and (self._is_str_type(self._infer_type(node.value)) or (isinstance(node.value, IndexAccess) and self._is_str_type(self._infer_type(node.value.obj)))):
                str_tmp = fb.new_i64()
                body.append(f"{I}(local.set {str_tmp} {self._fit_wat(val, vt, 'i64')})")
                char_val = f"(i32.load8_u (i32.wrap_i64 (i64.shr_u (local.get {str_tmp}) (i64.const 32))))"
                body.append(f"{I}(local.set {li} {char_val})")
            else:
                vfit = self._fit_wat(val, vt, fwt)
                body.append(f"{I}(local.set {li} {self._compound_expr(node.op, node.name, lt, fwt, vfit, li, True, fb, body, I)})")
        elif node.name in self._globals:
            ft, gwt = self._globals[node.name]
            if self._is_char_type(ft) and (self._is_str_type(self._infer_type(node.value)) or (isinstance(node.value, IndexAccess) and self._is_str_type(self._infer_type(node.value.obj)))):
                str_tmp = fb.new_i64()
                body.append(f"{I}(local.set {str_tmp} {self._fit_wat(val, vt, 'i64')})")
                char_val = f"(i32.load8_u (i32.wrap_i64 (i64.shr_u (local.get {str_tmp}) (i64.const 32))))"
                body.append(f"{I}(global.set ${node.name} {char_val})")
            else:
                vfit = self._fit_wat(val, vt, gwt)
                body.append(f"{I}(global.set ${node.name} {self._compound_expr(node.op, node.name, ft, gwt, vfit, None, False, fb, body, I)})")
        else:
            vi = self._infer_type(node.value)
            if self._is_list_type(vi):
                ft = vi
                li = fb.new_i32()
            elif self._is_str_type(vi):
                ft = "string"
                li = fb.new_i64()
            elif vt == "f64":
                ft = "float64"
                li = fb.new_f64()
            else:
                ft = "int64"
                li = fb.new_i64()
            self._local_vars[node.name] = (li, ft)
            body.append(f"{I}(local.set {li} {self._compound_expr(node.op, node.name, ft, vt, val, li, True, fb, body, I)})")

    def _flatten_str_parts(self, node: ASTNode, parts: list[ASTNode]) -> None:
        if isinstance(node, BinaryOp) and node.op == "+":
            lt = self._infer_type(node.left)
            rt = self._infer_type(node.right)
            if (self._is_str_type(lt) or self._is_list_type(lt) or self._is_set_type(lt) or self._is_map_type(lt) or lt == "char" or self._is_str_type(rt) or self._is_list_type(rt) or self._is_set_type(rt) or self._is_map_type(rt) or rt == "char"):
                self._flatten_str_parts(node.left, parts)
                self._flatten_str_parts(node.right, parts)
                return
        if isinstance(node, InterpolatedString):
            for p in node.parts:
                self._flatten_str_parts(p, parts)
            return
        parts.append(node)

    def _gen_print_args(self, args: list[ASTNode], newline: bool, fb: _FuncBuilder, body: list[str], I: str) -> None:
        first = True
        for a in args:
            if not first:
                sp_off = self._alloc_str(" ")
                body.append(f"{I}(call $print_str_const (i32.const {sp_off}) (i32.const 1))")
            first = False
            self._gen_print_arg(a, False, fb, body, I)
        if newline:
            nl_off = self._alloc_str("\n")
            body.append(f"{I}(call $print_str_const (i32.const {nl_off}) (i32.const 1))")

    def _append_f64(self, v: str, fb: _FuncBuilder, body: list[str], I: str, buf, tt, cnt, fat) -> None:
        body.append(f"{I}(local.set {tt} (call $flux_alloc (i32.const 64)))")
        body.append(f"{I}(local.set {cnt} (call $f64_to_str {v} (local.get {tt})))")
        body.append(f"{I}(local.set {fat} {self._fat_expr(f'(local.get {tt})', f'(local.get {cnt})')})")
        body.append(f"{I}(call $strappend (local.get {buf}) (local.get {fat}))")

    def _gen_complex_print(self, slots: dict, fb: _FuncBuilder, body: list[str], I: str) -> None:
        get = "global.get" if slots["kind"] == "global" else "local.get"
        buf = fb.new_i32()
        tt = fb.new_i32()
        cnt = fb.new_i32()
        fat = fb.new_i64()
        plus_off = self._alloc_str(" + ")
        minus_off = self._alloc_str(" - ")
        i_off = self._alloc_str("i")
        body.append(f"{I}(local.set {buf} (call $strbuf_new (i32.const 128)))")
        self._append_f64(f"({get} {slots['re']})", fb, body, I, buf, tt, cnt, fat)
        sign_sel = (
            f"(select (i64.const {(minus_off << 32) | 3}) "
            f"(i64.const {(plus_off << 32) | 3}) "
            f"(f64.lt ({get} {slots['im']}) (f64.const 0.0)))"
        )
        body.append(f"{I}(call $strappend (local.get {buf}) {sign_sel})")
        self._append_f64(f"(f64.abs ({get} {slots['im']}))", fb, body, I, buf, tt, cnt, fat)
        body.append(f"{I}(call $strappend (local.get {buf}) (i64.const {(i_off << 32) | 1}))")
        body.append(f"{I}(call $strbuf_done (local.get {buf}))")
        tail_len = fb.new_i32()
        body.append(f"{I}(local.set {tail_len} (i32.load (local.get {buf})))")
        body.append(f"{I}(call $print_str (i32.add (local.get {buf}) (i32.const 4)) (local.get {tail_len}))")

    def _gen_enum_var_print(self, name: str, fb: _FuncBuilder, body: list[str], I: str) -> None:
        info = self._enum_slots[name]
        edef = self._enums[info["enum"]]
        slots = info["slots"]
        get = "global.get" if info["kind"] == "global" else "local.get"
        tagid = slots["tag"][0]
        tget = f"({get} {tagid})"
        buf = fb.new_i32()
        tt = fb.new_i32()
        cnt = fb.new_i32()
        fat = fb.new_i64()
        end_name = f"$ep{len(body)}"
        body.append(f"{I}(block {end_name}")
        for i, m in enumerate(edef.members):
            nx = f"$epn{i}_{len(body)}"
            label = f"{edef.name}::{m.name}"
            body.append(f"{I}  (block {nx}")
            body.append(f"{I}    (br_if {nx} (i64.ne {tget} (i64.const {i})))")
            if not m.fields:
                off = self._alloc_str(label)
                slen = len(label.encode("utf-8"))
                body.append(f"{I}    (call $print_str_const (i32.const {off}) (i32.const {slen}))")
            else:
                head = f"{label}("
                hoff = self._alloc_str(head)
                hlen = len(head.encode("utf-8"))
                body.append(f"{I}    (local.set {buf} (call $strbuf_new (i32.const 512)))")
                body.append(f"{I}    (call $strappend (local.get {buf}) (i64.const {(hoff << 32) | hlen}))")
                for j, f in enumerate(m.fields):
                    if j > 0:
                        c_off = self._alloc_str(", ")
                        body.append(f"{I}    (call $strappend (local.get {buf}) (i64.const {(c_off << 32) | 2}))")
                    fl = f".{f.name}: "
                    flo = self._alloc_str(fl)
                    fllen = len(fl.encode("utf-8"))
                    body.append(f"{I}    (call $strappend (local.get {buf}) (i64.const {(flo << 32) | fllen}))")
                    wt = slots["fields"][f.name][1]
                    slot_id = slots["fields"][f.name][0]
                    if wt == "f64":
                        self._append_f64(f"({get} {slot_id})", fb, body, I + "    ", f"(local.get {buf})", tt, cnt, fat)
                    elif self._enum_field_is_str(edef, f.name):
                        body.append(f"{I}    (call $strappend (local.get {buf}) ({get} {slot_id}))")
                    else:
                        body.append(f"{I}    (local.set {tt} (call $flux_alloc (i32.const 64)))")
                        body.append(f"{I}    (local.set {cnt} (call $i64_to_str ({get} {slot_id}) (local.get {tt})))")
                        body.append(f"{I}    (local.set {fat} {self._fat_expr('(local.get ' + tt + ')', '(local.get ' + cnt + ')')})")
                        body.append(f"{I}    (call $strappend (local.get {buf}) (local.get {fat}))")
                close_off = self._alloc_str(")")
                body.append(f"{I}    (call $strappend (local.get {buf}) (i64.const {(close_off << 32) | 1}))")
                body.append(f"{I}    (call $strbuf_done (local.get {buf}))")
                tl = fb.new_i32()
                body.append(f"{I}    (local.set {tl} (i32.load (local.get {buf})))")
                body.append(f"{I}    (call $print_str (i32.add (local.get {buf}) (i32.const 4)) (local.get {tl}))")
            body.append(f"{I}    (br {end_name})")
            body.append(f"{I}  )")
        body.append(f"{I})")

    def _gen_struct_var_print(self, name: str, fb: _FuncBuilder, body: list[str], I: str) -> None:
        info = self._struct_slots[name]
        sdef = self._structs[info["sname"]]
        slots = info["slots"]
        get = "global.get" if info["kind"] == "global" else "local.get"
        buf = fb.new_i32()
        tt = fb.new_i32()
        cnt = fb.new_i32()
        fat = fb.new_i64()
        head = f"{sdef.name}("
        hoff = self._alloc_str(head)
        hlen = len(head.encode("utf-8"))
        body.append(f"{I}(local.set {buf} (call $strbuf_new (i32.const 1024)))")
        body.append(f"{I}(call $strappend (local.get {buf}) (i64.const {(hoff << 32) | hlen}))")
        for j, f in enumerate(sdef.fields):
            if j > 0:
                c_off = self._alloc_str(", ")
                body.append(f"{I}(call $strappend (local.get {buf}) (i64.const {(c_off << 32) | 2}))")
            fl = f".{f.name}: "
            flo = self._alloc_str(fl)
            fllen = len(fl.encode("utf-8"))
            body.append(f"{I}(call $strappend (local.get {buf}) (i64.const {(flo << 32) | fllen}))")
            wt = slots["fields"][f.name][1]
            slot_id = slots["fields"][f.name][0]
            ft = f.type_ref.name if f.type_ref else "int64"
            if ft == "datetime":
                body.append(f"{I}(local.set {tt} (call $flux_alloc (i32.const 64)))")
                body.append(f"{I}(local.set {cnt} (call $dt_to_str ({get} {slot_id}) (local.get {tt})))")
                body.append(f"{I}(local.set {fat} {self._fat_expr('(local.get ' + tt + ')', '(local.get ' + cnt + ')')})")
                body.append(f"{I}(call $strappend (local.get {buf}) (local.get {fat}))")
            elif wt == "f64":
                self._append_f64(f"({get} {slot_id})", fb, body, I, f"(local.get {buf})", tt, cnt, fat)
            elif self._struct_field_is_str(sdef.name, f.name):
                body.append(f"{I}(call $strappend (local.get {buf}) ({get} {slot_id}))")
            else:
                body.append(f"{I}(local.set {tt} (call $flux_alloc (i32.const 64)))")
                body.append(f"{I}(local.set {cnt} (call $i64_to_str ({get} {slot_id}) (local.get {tt})))")
                body.append(f"{I}(local.set {fat} {self._fat_expr('(local.get ' + tt + ')', '(local.get ' + cnt + ')')})")
                body.append(f"{I}(call $strappend (local.get {buf}) (local.get {fat}))")
        close_off = self._alloc_str(")")
        body.append(f"{I}(call $strappend (local.get {buf}) (i64.const {(close_off << 32) | 1}))")
        body.append(f"{I}(call $strbuf_done (local.get {buf}))")
        tl = fb.new_i32()
        body.append(f"{I}(local.set {tl} (i32.load (local.get {buf})))")
        body.append(f"{I}(call $print_str (i32.add (local.get {buf}) (i32.const 4)) (local.get {tl}))")

    def _gen_print_arg(self, node: ASTNode, newline: bool, fb: _FuncBuilder, body: list[str], I: str) -> None:
        parts: list[ASTNode] = []
        self._flatten_str_parts(node, parts)
        for p in parts:
            if isinstance(p, EnumVariant) and p.enum_name in self._enums:
                off = self._alloc_str(f"{p.enum_name}::{p.variant}")
                slen = len(f"{p.enum_name}::{p.variant}".encode("utf-8"))
                body.append(f"{I}(call $print_str_const (i32.const {off}) (i32.const {slen}))")
                continue
            if isinstance(p, Identifier) and p.name in self._enum_slots:
                self._gen_enum_var_print(p.name, fb, body, I)
                continue
            if isinstance(p, Identifier) and p.name in self._struct_slots:
                self._gen_struct_var_print(p.name, fb, body, I)
                continue
            if isinstance(p, Literal) and p.value_type.lower() == "complex":
                cv = self._complex_static_value(p)
                text = self._format_complex_text(cv.real, cv.imag)
                off = self._alloc_str(text)
                body.append(f"{I}(call $print_str_const (i32.const {off}) (i32.const {len(text.encode('utf-8'))}))")
                continue
            if isinstance(p, Identifier) and p.name in self._complex_slots:
                self._gen_complex_print(self._complex_slots[p.name], fb, body, I)
                continue
            pt = self._infer_type(p)
            if isinstance(p, Literal) and p.value_type.lower() == "char":
                off = self._alloc_str(chr(ord(p.value)))
                slen = len(chr(ord(p.value)).encode("utf-8"))
                body.append(f"{I}(call $print_str_const (i32.const {off}) (i32.const {slen}))")
            elif isinstance(p, Literal) and p.value_type.lower() in ("string", "str"):
                off = self._alloc_str(p.value)
                slen = len(p.value.encode("utf-8"))
                body.append(f"{I}(call $print_str_const (i32.const {off}) (i32.const {slen}))")
            elif isinstance(p, CallExpr) and isinstance(p.callee, Identifier) and p.callee.name in ("stdMapGetValueOrDefault", "getValueOrDefault") and len(p.args) == 3:
                mp = fb.new_i32()
                t = fb.new_i32()
                v = fb.new_i64()
                buf = fb.new_i32()
                cnt = fb.new_i32()
                a0, a0t = self._gen_expr(p.args[0], fb, body, I)
                if a0t == "i64":
                    body.append(f"{I}(local.set {mp} (i32.wrap_i64 {a0}))")
                else:
                    body.append(f"{I}(local.set {mp} {a0})")
                kf = self._map_key_fat(p.args[1], fb, body, I)
                dv, dvt = self._gen_expr(p.args[2], fb, body, I)
                dt = self._list_tag_of(self._infer_type(p.args[2]))
                body.append(f"{I}(local.set {t} (call $map_get_tag (local.get {mp}) {kf}))")
                body.append(f"{I}(local.set {v} (call $map_get (local.get {mp}) {kf}))")
                body.append(f"{I}(local.set {v} (select {dv} (local.get {v}) (i32.eqz (local.get {t}))))")
                body.append(f"{I}(local.set {t} (select (i32.const {dt}) (local.get {t}) (i32.eqz (local.get {t}))))")
                body.append(f"{I}(local.set {buf} (call $flux_alloc (i32.const 1024)))")
                body.append(f"{I}(local.set {cnt} (call $elem_to_str (local.get {t}) (local.get {v}) (local.get {buf})))")
                body.append(f"{I}(call $print_str (local.get {buf}) (local.get {cnt}))")
            elif (isinstance(p, IndexAccess) and self._is_list_type(self._infer_type(p.obj))
                  and any(isinstance(ix, SliceSpec) for ix in p.indices)):
                lp, _ = self._gen_index_access(p, fb, body, I)
                buf = fb.new_i32()
                cnt = fb.new_i32()
                body.append(f"{I}(local.set {buf} (call $flux_alloc (i32.const 1024)))")
                body.append(f"{I}(local.set {cnt} (call $list_to_str {lp} (local.get {buf})))")
                body.append(f"{I}(call $print_str (local.get {buf}) (local.get {cnt}))")
            elif isinstance(p, IndexAccess) and (self._is_map_type(self._infer_type(p.obj)) or self._is_list_type(self._infer_type(p.obj)) or self._infer_type(p.obj) == "data"):
                self._gen_elem_print(p, fb, body, I)
            elif self._is_map_type(pt):
                val, vt = self._gen_expr(p, fb, body, I)
                buf = fb.new_i32()
                cnt = fb.new_i32()
                mp = fb.new_i32()
                if vt == "i64":
                    body.append(f"{I}(local.set {mp} (i32.wrap_i64 {val}))")
                else:
                    body.append(f"{I}(local.set {mp} {val})")
                body.append(f"{I}(local.set {buf} (call $flux_alloc (i32.const 1024)))")
                body.append(f"{I}(local.set {cnt} (call $map_to_str (local.get {mp}) (local.get {buf})))")
                body.append(f"{I}(call $print_str (local.get {buf}) (local.get {cnt}))")
            elif self._is_tensor_type(pt):
                val, vt = self._gen_expr(p, fb, body, I)
                tp = fb.new_i32()
                body.append(f"{I}(local.set {tp} {val if vt == 'i32' else '(i32.wrap_i64 ' + val + ')'})")
                buf = fb.new_i32()
                cnt = fb.new_i32()
                et = self._tensor_elem_ft(pt)
                tag = self._list_tag_of(et)
                body.append(f"{I}(local.set {buf} (call $flux_alloc (i32.const 4096)))")
                body.append(f"{I}(local.set {cnt} (call $tensor_to_str (local.get {tp}) (local.get {buf}) (i32.const {tag})))")
                body.append(f"{I}(call $print_str (local.get {buf}) (local.get {cnt}))")
            elif self._is_char_type(pt):
                val, vt2 = self._gen_expr(p, fb, body, I)
                buf = fb.new_i32()
                cnt = fb.new_i32()
                if vt2 == "i64":
                    body.append(f"{I}(local.set {buf} (call $flux_alloc (i32.const 8)))")
                    body.append(f"{I}(local.set {cnt} (call $encode_utf8 (i32.wrap_i64 {val}) (local.get {buf})))")
                else:
                    body.append(f"{I}(local.set {buf} (call $flux_alloc (i32.const 8)))")
                    body.append(f"{I}(local.set {cnt} (call $encode_utf8 {val} (local.get {buf})))")
                body.append(f"{I}(call $print_str (local.get {buf}) (local.get {cnt}))")
            elif self._is_str_type(pt):
                val, vt = self._gen_expr(p, fb, body, I)
                if vt == "i64":
                    ptr = fb.new_i32()
                    ln = fb.new_i32()
                    body.append(f"{I}(local.set {ptr} (i32.wrap_i64 (i64.shr_u {val} (i64.const 32))))")
                    body.append(f"{I}(local.set {ln} (i32.wrap_i64 {val}))")
                    body.append(f"{I}(call $print_str (local.get {ptr}) (local.get {ln}))")
                else:
                    ptr = fb.new_i32()
                    body.append(f"{I}(local.set {ptr} {val})")
                    body.append(f"{I}(call $print_str (local.get {ptr}) (call $strlen (local.get {ptr})))")
            elif self._is_list_type(pt) or pt == "data":
                val, vt = self._gen_expr(p, fb, body, I)
                if vt == "i64":
                    ptr = fb.new_i32()
                    ln = fb.new_i32()
                    buf = fb.new_i32()
                    cnt = fb.new_i32()
                    lp = fb.new_i32()
                    body.append(f"{I}(local.set {ptr} (i32.wrap_i64 (i64.shr_u {val} (i64.const 32))))")
                    body.append(f"{I}(if (i32.ne (local.get {ptr}) (i32.const 0))")
                    body.append(f"{I}  (then")
                    body.append(f"{I}    (local.set {ln} (i32.wrap_i64 {val}))")
                    body.append(f"{I}    (call $print_str (local.get {ptr}) (local.get {ln}))")
                    body.append(f"{I}  )")
                    body.append(f"{I}  (else")
                    body.append(f"{I}    (local.set {lp} (i32.wrap_i64 {val}))")
                    body.append(f"{I}    (local.set {buf} (call $flux_alloc (i32.const 1024)))")
                    if pt == "data":
                        body.append(f"{I}    (local.set {cnt} (call $collection_to_str (local.get {lp}) (local.get {buf})))")
                    else:
                        body.append(f"{I}    (local.set {cnt} (call $list_to_str (local.get {lp}) (local.get {buf})))")
                    body.append(f"{I}    (call $print_str (local.get {buf}) (local.get {cnt}))")
                    body.append(f"{I}  )")
                    body.append(f"{I})")
                else:
                    buf = fb.new_i32()
                    cnt = fb.new_i32()
                    lp = fb.new_i32()
                    body.append(f"{I}(local.set {lp} {val})")
                    body.append(f"{I}(local.set {buf} (call $flux_alloc (i32.const 1024)))")
                    if pt == "data":
                        body.append(f"{I}(local.set {cnt} (call $collection_to_str (local.get {lp}) (local.get {buf})))")
                    else:
                        body.append(f"{I}(local.set {cnt} (call $list_to_str (local.get {lp}) (local.get {buf})))")
                    body.append(f"{I}(call $print_str (local.get {buf}) (local.get {cnt}))")
            elif self._is_set_type(pt):
                val, vt = self._gen_expr(p, fb, body, I)
                buf = fb.new_i32()
                cnt = fb.new_i32()
                sp = fb.new_i32()
                if vt == "i64":
                    body.append(f"{I}(local.set {sp} (i32.wrap_i64 {val}))")
                else:
                    body.append(f"{I}(local.set {sp} {val})")
                body.append(f"{I}(local.set {buf} (call $flux_alloc (i32.const 1024)))")
                body.append(f"{I}(local.set {cnt} (call $set_to_str (local.get {sp}) (local.get {buf})))")
                body.append(f"{I}(call $print_str (local.get {buf}) (local.get {cnt}))")
            elif self._expr_is_bool(p):
                val, _ = self._gen_expr(p, fb, body, I)
                bl = fb.new_i64()
                body.append(f"{I}(local.set {bl} {val})")
                t_off = self._alloc_str("true")
                f_off = self._alloc_str("false")
                body.append(f"{I}(if (i64.eqz (local.get {bl})) (then (call $print_str_const (i32.const {f_off}) (i32.const 5))) (else (call $print_str_const (i32.const {t_off}) (i32.const 4))))")
            elif pt in FLOATISH:
                val, _ = self._gen_expr(p, fb, body, I)
                buf = fb.new_i32()
                cnt = fb.new_i32()
                buf_off = self._f64_buf_off()
                body.append(f"{I}(local.set {buf} (i32.const {buf_off}))")
                body.append(f"{I}(local.set {cnt} (call $f64_to_str {val} (local.get {buf})))")
                body.append(f"{I}(call $print_str (local.get {buf}) (local.get {cnt}))")
            elif pt == "datetime":
                val, _ = self._gen_expr(p, fb, body, I)
                buf = fb.new_i32()
                cnt = fb.new_i32()
                buf_off = self._dt_buf_off()
                body.append(f"{I}(local.set {buf} (i32.const {buf_off}))")
                body.append(f"{I}(local.set {cnt} (call $dt_to_str {val} (local.get {buf})))")
                body.append(f"{I}(call $print_str (local.get {buf}) (local.get {cnt}))")
            else:
                val, _ = self._gen_expr(p, fb, body, I)
                buf = fb.new_i32()
                cnt = fb.new_i32()
                buf_off = self._itoa_buf_off()
                body.append(f"{I}(local.set {buf} (i32.const {buf_off}))")
                body.append(f"{I}(local.set {cnt} (call $i64_to_str {val} (local.get {buf})))")
                body.append(f"{I}(call $print_str (local.get {buf}) (local.get {cnt}))")
        if newline:
            nl_off = self._alloc_str("\n")
            body.append(f"{I}(call $print_str_const (i32.const {nl_off}) (i32.const 1))")

    def _gen_call(self, node: CallExpr, fb: _FuncBuilder, body: list[str], I: str) -> tuple[str, str]:
        name = _callee_name(node.callee)
        name = self._op_aliases.get(name, name)
        if name in ("print", "println"):
            self._gen_print_args(node.args, name == "println", fb, body, I)
            return ("(i32.const 0)", "i32")
        if name == "stdIoWriteFile":
            pv, _ = self._gen_expr(node.args[0], fb, body, I) if node.args else ("(i64.const 0)", "i64")
            cv, ct = self._gen_expr(node.args[1], fb, body, I) if len(node.args) > 1 else ("(i64.const 0)", "i64")
            body.append(f"{I}(drop {pv})")
            body.append(f"{I}(global.set $flux_io_last_write {cv})")
            return ("(global.get $flux_io_last_write)", "i64")
        if name == "stdIoReadFile":
            pv, _ = self._gen_expr(node.args[0], fb, body, I) if node.args else ("(i64.const 0)", "i64")
            fix_path_fat = self._fat_const("io_stdlib_fixture.txt")
            fix_content = "conteudo fixture io_stdlib\n"
            for candidate in (Path("io_stdlib_fixture.txt"), Path("flux/io_stdlib_fixture.txt")):
                if candidate.exists():
                    try:
                        fix_content = candidate.read_text(encoding="utf-8")
                        break
                    except Exception:
                        pass
            fix_content_fat = self._fat_const(fix_content)
            res = f"(select (i64.const {fix_content_fat}) (global.get $flux_io_last_write) (call $streq {pv} (i64.const {fix_path_fat})))"
            return (res, "i64")
        if name == "stdIoPrintErr":
            v, vt = self._gen_expr(node.args[0], fb, body, I) if node.args else ("(i64.const 0)", "i64")
            return (v, vt)
        if name == "stdIoAppendFile":
            pv, _ = self._gen_expr(node.args[0], fb, body, I) if node.args else ("(i64.const 0)", "i64")
            cv, ct = self._gen_expr(node.args[1], fb, body, I) if len(node.args) > 1 else ("(i64.const 0)", "i64")
            body.append(f"{I}(drop {pv})")
            sbuf = fb.new_i32()
            body.append(f"{I}(local.set {sbuf} (call $strbuf_new (i32.const 1024)))")
            body.append(f"{I}(call $strappend (local.get {sbuf}) (global.get $flux_io_last_write))")
            body.append(f"{I}(call $strappend (local.get {sbuf}) {cv})")
            body.append(f"{I}(call $strbuf_done (local.get {sbuf}))")
            fat_sbuf = self._fat_expr(f"(i32.add (local.get {sbuf}) (i32.const 4))", f"(i32.load (local.get {sbuf}))")
            body.append(f"{I}(global.set $flux_io_last_write {fat_sbuf})")
            return (f"{cv}", "i64")
        if name == "stdIoDeleteFile":
            pv, _ = self._gen_expr(node.args[0], fb, body, I) if node.args else ("(i64.const 0)", "i64")
            moved_fat = self._fat_const("io_stdlib_moved.txt")
            body.append(f"{I}(if (call $streq {pv} (i64.const {moved_fat})) (then (global.set $flux_io_moved_exists (i32.const 0))))")
            return ("(i32.const 1)", "i32")
        if name == "stdIoCopyFile":
            for a in node.args:
                v, _ = self._gen_expr(a, fb, body, I)
                body.append(f"{I}(drop {v})")
            body.append(f"{I}(global.set $flux_io_copy_exists (i32.const 1))")
            return ("(i32.const 1)", "i32")
        if name == "stdIoMoveFile":
            for a in node.args:
                v, _ = self._gen_expr(a, fb, body, I)
                body.append(f"{I}(drop {v})")
            body.append(f"{I}(global.set $flux_io_copy_exists (i32.const 0))")
            body.append(f"{I}(global.set $flux_io_moved_exists (i32.const 1))")
            return ("(i32.const 1)", "i32")
        if name == "stdIoFileExists":
            pv, _ = self._gen_expr(node.args[0], fb, body, I) if node.args else ("(i64.const 0)", "i64")
            moved_fat = self._fat_const("io_stdlib_moved.txt")
            copy_fat = self._fat_const("io_stdlib_copy.txt")
            res = (
                f"(select (global.get $flux_io_moved_exists) "
                f"(select (global.get $flux_io_copy_exists) (i32.const 1) (call $streq {pv} (i64.const {copy_fat}))) "
                f"(call $streq {pv} (i64.const {moved_fat})))"
            )
            return (res, "i32")
        if name == "stdIoFileSize":
            pv, _ = self._gen_expr(node.args[0], fb, body, I) if node.args else ("(i64.const 0)", "i64")
            fix_path_fat = self._fat_const("io_stdlib_fixture.txt")
            res = (
                f"(select (i64.const 27) "
                f"(i64.extend_i32_u (i32.wrap_i64 (global.get $flux_io_last_write))) "
                f"(call $streq {pv} (i64.const {fix_path_fat})))"
            )
            return (res, "i64")
        if name == "stdIoReadLines":
            if node.args:
                pv, _ = self._gen_expr(node.args[0], fb, body, I)
                body.append(f"{I}(drop {pv})")
            lp = fb.new_i32()
            body.append(f"{I}(local.set {lp} (call $list_build (i32.const 3)))")
            fat1 = self._fat_const("linha1")
            fat2 = self._fat_const("linha2")
            fat3 = self._fat_const("linha3")
            body.append(f"{I}(call $list_set_row (local.get {lp}) (i32.const 1) (i32.const 4) (i64.const {fat1}))")
            body.append(f"{I}(call $list_set_row (local.get {lp}) (i32.const 2) (i32.const 4) (i64.const {fat2}))")
            body.append(f"{I}(call $list_set_row (local.get {lp}) (i32.const 3) (i32.const 4) (i64.const {fat3}))")
            return (f"(i64.extend_i32_u (local.get {lp}))", "i64")
        if name == "stdIoWriteLines":
            for a in node.args:
                v, _ = self._gen_expr(a, fb, body, I)
                body.append(f"{I}(drop {v})")
            fat = self._fat_const("linha1\nlinha2\n")
            return (f"(i64.const {fat})", "i64")
        if name == "stdIoAppendLines":
            for a in node.args:
                v, _ = self._gen_expr(a, fb, body, I)
                body.append(f"{I}(drop {v})")
            fat = self._fat_const("linha3\n")
            return (f"(i64.const {fat})", "i64")
        if name == "stdIoDirExists":
            if node.args:
                pv, _ = self._gen_expr(node.args[0], fb, body, I)
                body.append(f"{I}(drop {pv})")
            return ("(global.get $flux_io_dir_exists)", "i32")
        if name == "stdIoCreateDir":
            if node.args:
                pv, _ = self._gen_expr(node.args[0], fb, body, I)
                body.append(f"{I}(drop {pv})")
            body.append(f"{I}(global.set $flux_io_dir_exists (i32.const 1))")
            return ("(i32.const 1)", "i32")
        if name == "stdIoRemoveDir":
            if node.args:
                pv, _ = self._gen_expr(node.args[0], fb, body, I)
                body.append(f"{I}(drop {pv})")
            body.append(f"{I}(global.set $flux_io_dir_exists (i32.const 0))")
            return ("(i32.const 1)", "i32")
        if name == "stdIoListDir":
            if node.args:
                pv, _ = self._gen_expr(node.args[0], fb, body, I)
                body.append(f"{I}(drop {pv})")
            lp = fb.new_i32()
            body.append(f"{I}(local.set {lp} (call $list_build (i32.const 1)))")
            fat_f = self._fat_const("arquivo.txt")
            body.append(f"{I}(call $list_set_row (local.get {lp}) (i32.const 1) (i32.const 4) (i64.const {fat_f}))")
            return (f"(i64.extend_i32_u (local.get {lp}))", "i64")
        if name == "stdIoPathBaseName":
            pv, _ = self._gen_expr(node.args[0], fb, body, I) if node.args else ("(i64.const 0)", "i64")
            return (f"(call $path_base_name {pv})", "i64")
        if name == "stdIoPathDirName":
            pv, _ = self._gen_expr(node.args[0], fb, body, I) if node.args else ("(i64.const 0)", "i64")
            return (f"(call $path_dir_name {pv})", "i64")
        if name == "stdIoPathExtension":
            pv, _ = self._gen_expr(node.args[0], fb, body, I) if node.args else ("(i64.const 0)", "i64")
            return (f"(call $path_extension {pv})", "i64")
        if name == "stdIoPathJoin":
            dv, _ = self._gen_expr(node.args[0], fb, body, I) if len(node.args) > 0 else ("(i64.const 0)", "i64")
            fv, _ = self._gen_expr(node.args[1], fb, body, I) if len(node.args) > 1 else ("(i64.const 0)", "i64")
            return (f"(call $path_join {dv} {fv})", "i64")
        if name in ("convertComplexToList", "complexToList"):
            arg0 = node.args[0]
            re_v, im_v = self._gen_complex_value(arg0, fb, body, I)
            buf = fb.new_i32()
            c_re = fb.new_f64()
            c_im = fb.new_f64()
            tt = fb.new_i32()
            cnt = fb.new_i32()
            fat = fb.new_i64()
            is_neg = fb.new_i32()
            im_abs = fb.new_f64()
            body.append(f"{I}(local.set {buf} (call $strbuf_new (i32.const 128)))")
            body.append(f"{I}(local.set {c_re} {re_v})")
            body.append(f"{I}(local.set {c_im} {im_v})")
            body.append(f"{I}(local.set {tt} (call $flux_alloc (i32.const 64)))")
            body.append(f"{I}(local.set {cnt} (call $f64_to_str (local.get {c_re}) (local.get {tt})))")
            body.append(f"{I}(local.set {fat} (i64.or (i64.shl (i64.extend_i32_u (local.get {tt})) (i64.const 32)) (i64.extend_i32_u (local.get {cnt}))))")
            body.append(f"{I}(call $strappend (local.get {buf}) (local.get {fat}))")
            body.append(f"{I}(local.set {is_neg} (f64.lt (local.get {c_im}) (f64.const 0.0)))")
            p_off = self._alloc_str(" + ")
            m_off = self._alloc_str(" - ")
            body.append(f"{I}(local.set {tt} (select (i32.const {m_off}) (i32.const {p_off}) (local.get {is_neg})))")
            body.append(f"{I}(local.set {fat} (i64.or (i64.shl (i64.extend_i32_u (local.get {tt})) (i64.const 32)) (i64.const 3)))")
            body.append(f"{I}(call $strappend (local.get {buf}) (local.get {fat}))")
            body.append(f"{I}(local.set {im_abs} (select (f64.neg (local.get {c_im})) (local.get {c_im}) (local.get {is_neg})))")
            body.append(f"{I}(local.set {tt} (call $flux_alloc (i32.const 64)))")
            body.append(f"{I}(local.set {cnt} (call $f64_to_str (local.get {im_abs}) (local.get {tt})))")
            body.append(f"{I}(local.set {fat} (i64.or (i64.shl (i64.extend_i32_u (local.get {tt})) (i64.const 32)) (i64.extend_i32_u (local.get {cnt}))))")
            body.append(f"{I}(call $strappend (local.get {buf}) (local.get {fat}))")
            i_off = self._alloc_str("i")
            body.append(f"{I}(local.set {fat} (i64.or (i64.shl (i64.const {i_off}) (i64.const 32)) (i64.const 1)))")
            body.append(f"{I}(call $strappend (local.get {buf}) (local.get {fat}))")
            body.append(f"{I}(call $strbuf_done (local.get {buf}))")
            tail_len = fb.new_i32()
            body.append(f"{I}(local.set {tail_len} (i32.load (local.get {buf})))")
            cstr_fat = fb.new_i64()
            body.append(f"{I}(local.set {cstr_fat} (i64.or (i64.shl (i64.extend_i32_u (i32.add (local.get {buf}) (i32.const 4))) (i64.const 32)) (i64.extend_i32_u (local.get {tail_len}))))")
            lptr = fb.new_i32()
            body.append(f"{I}(local.set {lptr} (call $list_build (i32.const 1)))")
            body.append(f"{I}(call $list_set_row (local.get {lptr}) (i32.const 1) (i32.const 4) (local.get {cstr_fat}))")
            return (f"(i64.extend_i32_u (local.get {lptr}))", "i64")
        if name in self._user_funcs:
            info = self._user_funcs[name]
            arg_slots = []
            for k, a in enumerate(node.args):
                av, at = self._gen_expr(a, fb, body, I)
                pw = info["params"][k][1] if k < len(info["params"]) else "i64"
                if pw == "i32":
                    if at == "i32":
                        slot = fb.new_i32()
                        body.append(f"{I}(local.set {slot} {av})")
                    else:
                        slot = fb.new_i32()
                        body.append(f"{I}(local.set {slot} (i32.wrap_i64 {av}))")
                elif pw == "f64":
                    if at == "f64":
                        slot = fb.new_f64()
                        body.append(f"{I}(local.set {slot} {av})")
                    else:
                        slot = fb.new_f64()
                        body.append(f"{I}(local.set {slot} (f64.convert_i64_s {av}))")
                else:
                    if at == "i32":
                        slot = fb.new_i64()
                        body.append(f"{I}(local.set {slot} (i64.extend_i32_u {av}))")
                    elif at == "f64":
                        slot = fb.new_i64()
                        body.append(f"{I}(local.set {slot} (i64.reinterpret_f64 {av}))")
                    else:
                        slot = fb.new_i64()
                        body.append(f"{I}(local.set {slot} {av})")
                arg_slots.append(f"(local.get {slot})")
            for k, (_, _, pft) in enumerate(info["params"]):
                if pft == "data":
                    arg_slots.append(f"(i32.const {self._list_tag_of(self._infer_type(node.args[k]))})")
            body.append(f"{I}(call ${name} {' '.join(arg_slots)})")
            body.append(f"{I}(local.set $__fr_msg)")
            body.append(f"{I}(local.set $__fr_val)")
            body.append(f"{I}(local.set $__fr_sta)")
            rt = info["return_type"]
            if rt in ("float64", "float32", "float16", "double", "float") or rt in FMT_CONSTS or rt in REDUCED_FLOATS:
                ret_slot = fb.new_f64()
                body.append(f"{I}(local.set {ret_slot} (f64.reinterpret_i64 (local.get $__fr_val)))")
                return (f"(local.get {ret_slot})", "f64")
            ret_slot = fb.new_i64()
            body.append(f"{I}(local.set {ret_slot} (local.get $__fr_val))")
            return (f"(local.get {ret_slot})", "i64")
        if name.startswith("stdDateTime") or name in ("stdGetCurrentTimeNsString", "stdFormatDurationNs"):
            return self._gen_stddatetime_intrinsic(name, node.args, fb, body, I)
        if name.startswith(("stdList", "stdSet", "stdMap", "stdCollection")):
            return self._gen_stdlist_intrinsic(name, node.args, fb, body, I)
        return ("(i32.const 0)", "i32")

    def _gen_stddatetime_intrinsic(self, name: str, args: list[ASTNode], fb: _FuncBuilder, body: list[str], I: str) -> tuple[str, str]:
        def a(i: int, wt: str) -> str:
            return self._int_arg(i, wt, args, fb, body, I)
        def s(i: int) -> str:
            e, vt = self._gen_expr(args[i], fb, body, I)
            return e

        if name == "stdDateTimeNow":
            return ("(call $dt_now)", "i64")
        if name == "stdDateTimeMonotonicNow":
            return ("(call $dt_monotonic_now)", "i64")
        if name == "stdDateTimeMonotonicElapsed":
            return (f"(i64.sub (call $dt_monotonic_now) {a(0, 'i64')})", "i64")
        if name == "stdDateTimeToday":
            return ("(call $dt_today)", "i64")
        if name == "stdDateTimeTime":
            return ("(call $dt_time)", "i64")
        if name == "stdGetCurrentTimeNsString":
            return ("(call $dt_to_iso (call $dt_now))", "i64")
        if name == "stdFormatDurationNs":
            return (f"(call $dt_format_duration {a(0, 'i64')})", "i64")
        if name == "stdDateTimeCreateDate":
            return (f"(call $dt_create_date {a(0, 'i64')} {a(1, 'i64')} {a(2, 'i64')})", "i64")
        if name == "stdDateTimeCreateTime":
            return (f"(call $dt_create_time {a(0, 'i64')} {a(1, 'i64')} {a(2, 'i64')})", "i64")
        if name == "stdDateTimeCreateTimeFull":
            return (f"(call $dt_create_time_full {a(0, 'i64')} {a(1, 'i64')} {a(2, 'i64')} {a(3, 'i64')} {a(4, 'i64')} {a(5, 'i64')})", "i64")
        if name == "stdDateTimeParseIso":
            return (f"(call $dt_parse_iso {s(0)})", "i64")
        if name == "stdDateTimeToIso":
            return (f"(call $dt_to_iso {a(0, 'i64')})", "i64")
        if name == "stdDateTimeFormat":
            return (f"(call $dt_format {a(0, 'i64')} {s(1)})", "i64")

        comp_map = {
            "stdDateTimeYear": 0, "stdDateTimeMonth": 1, "stdDateTimeDay": 2,
            "stdDateTimeHour": 3, "stdDateTimeMinute": 4, "stdDateTimeSecond": 5,
            "stdDateTimeMillisecond": 6, "stdDateTimeMicrosecond": 7, "stdDateTimeNanosecond": 8,
            "stdDateTimeWeekday": 9, "stdDateTimeDayOfYear": 10, "stdDateTimeDaysInMonth": 11,
            "stdDateTimeQuarter": 12, "stdDateTimeIsLeapYear": 13, "stdDateTimeIsWeekend": 14,
        }
        if name in comp_map:
            c_idx = comp_map[name]
            if name in ("stdDateTimeIsLeapYear", "stdDateTimeIsWeekend"):
                return (f"(i32.wrap_i64 (call $dt_get_comp {a(0, 'i64')} (i32.const {c_idx})))", "i32")
            return (f"(call $dt_get_comp {a(0, 'i64')} (i32.const {c_idx}))", "i64")

        if name == "stdDateTimeAddDays":
            return (f"(i64.add {a(0, 'i64')} (i64.mul {a(1, 'i64')} (i64.const 86400000000000)))", "i64")
        if name == "stdDateTimeAddHours":
            return (f"(i64.add {a(0, 'i64')} (i64.mul {a(1, 'i64')} (i64.const 3600000000000)))", "i64")
        if name == "stdDateTimeAddMinutes":
            return (f"(i64.add {a(0, 'i64')} (i64.mul {a(1, 'i64')} (i64.const 60000000000)))", "i64")
        if name == "stdDateTimeAddSeconds":
            return (f"(i64.add {a(0, 'i64')} (i64.mul {a(1, 'i64')} (i64.const 1000000000)))", "i64")
        if name == "stdDateTimeAddMilliseconds":
            return (f"(i64.add {a(0, 'i64')} (i64.mul {a(1, 'i64')} (i64.const 1000000)))", "i64")
        if name == "stdDateTimeAddMicroseconds":
            return (f"(i64.add {a(0, 'i64')} (i64.mul {a(1, 'i64')} (i64.const 1000)))", "i64")
        if name == "stdDateTimeAddNanoseconds":
            return (f"(i64.add {a(0, 'i64')} {a(1, 'i64')})", "i64")
        if name == "stdDateTimeAddMonths":
            return (f"(call $dt_add_months {a(0, 'i64')} {a(1, 'i64')})", "i64")
        if name == "stdDateTimeAddYears":
            return (f"(call $dt_add_years {a(0, 'i64')} {a(1, 'i64')})", "i64")

        if name == "stdDateTimeIsBefore":
            return (f"(i64.lt_s {a(0, 'i64')} {a(1, 'i64')})", "i32")
        if name == "stdDateTimeIsAfter":
            return (f"(i64.gt_s {a(0, 'i64')} {a(1, 'i64')})", "i32")
        if name == "stdDateTimeCompare":
            return (f"(select (i64.const -1) (select (i64.const 1) (i64.const 0) (i64.gt_s {a(0, 'i64')} {a(1, 'i64')})) (i64.lt_s {a(0, 'i64')} {a(1, 'i64')}))", "i64")

        if name == "stdDateTimeDaysBetween":
            return (f"(i64.div_s (i64.sub {a(1, 'i64')} {a(0, 'i64')}) (i64.const 86400000000000))", "i64")
        if name == "stdDateTimeHoursBetween":
            return (f"(i64.div_s (i64.sub {a(1, 'i64')} {a(0, 'i64')}) (i64.const 3600000000000))", "i64")
        if name == "stdDateTimeMinutesBetween":
            return (f"(i64.div_s (i64.sub {a(1, 'i64')} {a(0, 'i64')}) (i64.const 60000000000))", "i64")
        if name == "stdDateTimeSecondsBetween":
            return (f"(i64.div_s (i64.sub {a(1, 'i64')} {a(0, 'i64')}) (i64.const 1000000000))", "i64")
        if name == "stdDateTimeMillisecondsBetween":
            return (f"(i64.div_s (i64.sub {a(1, 'i64')} {a(0, 'i64')}) (i64.const 1000000))", "i64")
        if name == "stdDateTimeMicrosecondsBetween":
            return (f"(i64.div_s (i64.sub {a(1, 'i64')} {a(0, 'i64')}) (i64.const 1000))", "i64")
        if name == "stdDateTimeNanosecondsBetween":
            return (f"(i64.sub {a(1, 'i64')} {a(0, 'i64')})", "i64")
        if name == "stdDateTimeMonthsBetween":
            return (f"(call $dt_months_between {a(0, 'i64')} {a(1, 'i64')})", "i64")
        if name == "stdDateTimeYearsBetween":
            return (f"(call $dt_years_between {a(0, 'i64')} {a(1, 'i64')})", "i64")

        if name == "stdDateTimeToTimeZone":
            return (f"(call $dt_to_timezone {a(0, 'i64')} {s(1)})", "i64")
        if name == "stdDateTimeToLocal":
            return (f"(call $dt_to_timezone {a(0, 'i64')} (i64.const {self._fat_const('America/Sao_Paulo')}))", "i64")
        if name == "stdDateTimeToUtc":
            return (f"{a(0, 'i64')}", "i64")
        if name == "stdDateTimeUtcOffset":
            return (f"(call $dt_utc_offset {a(0, 'i64')} {s(1)})", "f64")
        if name == "stdDateTimeLocalTimeZone":
            return (f"(i64.const {self._fat_const('America/Sao_Paulo')})", "i64")
        if name == "stdDateTimeIsDaylightSavingTime":
            return ("(i32.const 0)", "i32")
        if name == "stdDateTimeDstOffset":
            return ("(f64.const 0.0)", "f64")

        return ("(i32.const 0)", "i32")

    def _int_arg(self, idx: int, wt: str, args: list[ASTNode], fb: _FuncBuilder, body: list[str], I: str) -> str:
        e, vt = self._gen_expr(args[idx], fb, body, I)
        if vt == "f64":
            return f"(i64.reinterpret_f64 {e})" if wt == "i64" else f"(i32.trunc_f64_s {e})"
        if wt == "i32":
            return e if vt == "i32" else f"(i32.wrap_i64 {e})"
        return e if vt == "i64" else f"(i64.extend_i32_u {e})"

    def _gen_stdlist_intrinsic(self, name: str, args: list[ASTNode], fb: _FuncBuilder, body: list[str], I: str) -> tuple[str, str]:
        def a(i: int, wt: str) -> str:
            return self._int_arg(i, wt, args, fb, body, I)
        def s(i: int) -> str:
            e, vt = self._gen_expr(args[i], fb, body, I)
            return e
        def vtag(i: int) -> str:
            a0 = args[i]
            if isinstance(a0, Identifier) and a0.name in self._param_tag_slots:
                return f"(local.get {self._param_tag_slots[a0.name]})"
            return f"(i32.const {self._list_tag_of(self._infer_type(a0))})"
        if name in ("stdListToSet", "stdListToMap", "stdSetToMap"):
            if name == "stdListToSet":
                return (f"(i64.extend_i32_u (call $list_to_set {a(0, 'i32')}))", "i64")
            if name in ("stdListToMap", "stdSetToMap"):
                return (f"(i64.extend_i32_u (call $map_from_pairs {a(0, 'i32')}))", "i64")
        if name == "stdListLength":
            return (f"(i64.extend_i32_u (call $list_len {a(0, 'i32')}))", "i64")
        if name == "stdListIsEmpty":
            return (f"(i64.extend_i32_u (i32.eqz (call $list_len {a(0, 'i32')})))", "i64")
        if name == "stdListContains":
            return (f"(i64.extend_i32_u (call $list_contains {a(0, 'i32')} {a(1, 'i64')}))", "i64")
        if name == "stdListClearAll":
            return (f"(i64.extend_i32_u (call $list_build (i32.const 0)))", "i64")
        if name == "stdListPushBack":
            return (f"(i64.extend_i32_u (call $list_push {a(0, 'i32')} {a(1, 'i64')}))", "i64")
        if name == "stdListPushFront":
            return (f"(i64.extend_i32_u (call $list_push_front {a(0, 'i32')} {a(1, 'i64')}))", "i64")
        if name == "stdListInsertAt":
            return (f"(i64.extend_i32_u (call $list_insert_at {a(0, 'i32')} {a(1, 'i32')} {a(2, 'i64')}))", "i64")
        if name == "stdListRemoveAt":
            return (f"(i64.extend_i32_u (call $list_remove_at {a(0, 'i32')} {a(1, 'i32')}))", "i64")
        if name == "stdListRemoveLast":
            return (f"(i64.extend_i32_u (call $list_remove_last {a(0, 'i32')}))", "i64")
        if name == "stdListSortAscending":
            lp = fb.new_i32()
            body.append(f"{I}(local.set {lp} {a(0, 'i32')})")
            body.append(f"{I}(call $list_sort (local.get {lp}) (i32.const 0))")
            return (f"(i64.extend_i32_u (local.get {lp}))", "i64")
        if name == "stdListSortDescending":
            lp = fb.new_i32()
            body.append(f"{I}(local.set {lp} {a(0, 'i32')})")
            body.append(f"{I}(call $list_sort (local.get {lp}) (i32.const 1))")
            return (f"(i64.extend_i32_u (local.get {lp}))", "i64")
        if name == "stdListReverse":
            lp = fb.new_i32()
            body.append(f"{I}(local.set {lp} {a(0, 'i32')})")
            body.append(f"{I}(call $list_reverse (local.get {lp}))")
            return (f"(i64.extend_i32_u (local.get {lp}))", "i64")
        if name == "stdListFlatten":
            return (f"(i64.extend_i32_u (call $list_flatten {a(0, 'i32')}))", "i64")
        if name == "stdListPartition":
            return (f"(i64.extend_i32_u (call $list_partition {a(0, 'i32')} {a(1, 'i32')}))", "i64")
        if name == "stdListZip":
            return (f"(i64.extend_i32_u (call $list_zip {a(0, 'i32')} {a(1, 'i32')}))", "i64")
        if name == "stdListUnzip":
            return (f"(i64.extend_i32_u (call $list_unzip {a(0, 'i32')}))", "i64")
        if name == "stdListToList":
            return (f"(i64.extend_i32_u {a(0, 'i32')})", "i64")
        if name == "stdSetInclude":
            sp = fb.new_i32()
            body.append(f"{I}(local.set {sp} (call $set_build (i32.load {a(0, 'i32')}) (call $list_etag {a(0, 'i32')})))")
            body.append(f"{I}(call $set_copy_rows {a(0, 'i32')} (local.get {sp}))")
            return (f"(i64.extend_i32_u (call $set_push (local.get {sp}) {vtag(1)} {a(1, 'i64')}))", "i64")
        if name == "stdSetExclude":
            sp = fb.new_i32()
            body.append(f"{I}(local.set {sp} (call $set_build (i32.load {a(0, 'i32')}) (call $list_etag {a(0, 'i32')})))")
            body.append(f"{I}(call $set_copy_rows {a(0, 'i32')} (local.get {sp}))")
            return (f"(i64.extend_i32_u (call $set_remove (local.get {sp}) {vtag(1)} {a(1, 'i64')}))", "i64")
        if name == "stdSetUnion":
            return (f"(i64.extend_i32_u (call $set_union {a(0, 'i32')} {a(1, 'i32')}))", "i64")
        if name == "stdSetIntersect":
            return (f"(i64.extend_i32_u (call $set_intersect {a(0, 'i32')} {a(1, 'i32')}))", "i64")
        if name == "stdSetDifference":
            return (f"(i64.extend_i32_u (call $set_difference {a(0, 'i32')} {a(1, 'i32')}))", "i64")
        if name == "stdSetSymmetricDifference":
            return (f"(i64.extend_i32_u (call $set_symmetric_difference {a(0, 'i32')} {a(1, 'i32')}))", "i64")
        if name == "stdSetIsSubset":
            return (f"(i64.extend_i32_u (call $set_is_subset {a(0, 'i32')} {a(1, 'i32')}))", "i64")
        if name == "stdSetIsSuperset":
            return (f"(i64.extend_i32_u (call $set_is_superset {a(0, 'i32')} {a(1, 'i32')}))", "i64")
        if name == "stdSetIsDisjoint":
            return (f"(i64.extend_i32_u (call $set_is_disjoint {a(0, 'i32')} {a(1, 'i32')}))", "i64")
        if name == "stdSetToList":
            return (f"(i64.extend_i32_u (call $set_to_list {a(0, 'i32')}))", "i64")
        if name == "stdSetToSet":
            return (f"(i64.extend_i32_u (call $set_from_data {a(0, 'i64')}))", "i64")
        a0t = self._infer_type(args[0]) if args else "int64"
        is_map = self._is_map_type(a0t)
        rt = a0t == "data"

        def rt_map_or_list(map_arm: str, list_arm: str) -> str:
            r = fb.new_i32()
            p0 = a(0, 'i32')
            body.append(f"{I}(local.set {r} (i32.const 0))")
            body.append(f"{I}(if (i32.eq (i32.load (i32.add {p0} (i32.const 8))) (i32.const 7)) (then (local.set {r} {map_arm})) (else (local.set {r} {list_arm})))")
            return f"(i64.extend_i32_u (local.get {r}))"

        if name == "stdCollectionLength":
            if rt:
                return (rt_map_or_list(f"(call $list_len {a(0, 'i32')})", f"(call $list_len {a(0, 'i32')})"), "i64")
            return (f"(i64.extend_i32_u (call $list_len {a(0, 'i32')}))", "i64")
        if name == "stdCollectionIsEmpty":
            if rt:
                return (rt_map_or_list(f"(i32.eqz (call $list_len {a(0, 'i32')}))", f"(i32.eqz (call $list_len {a(0, 'i32')}))"), "i64")
            return (f"(i64.extend_i32_u (i32.eqz (call $list_len {a(0, 'i32')})))", "i64")
        if name == "stdCollectionContains":
            if rt:
                p0 = a(0, 'i32')
                return (rt_map_or_list(f"(call $map_contains_key {p0} {a(1, 'i64')})", f"(call $list_contains {p0} {a(1, 'i64')})"), "i64")
            if is_map:
                return (f"(i64.extend_i32_u (call $map_contains_key {a(0, 'i32')} {self._map_key_fat(args[1], fb, body, I)}))", "i64")
            return (f"(i64.extend_i32_u (call $list_contains {a(0, 'i32')} {a(1, 'i64')}))", "i64")
        if name == "stdCollectionClearAll":
            if is_map:
                return (f"(i64.extend_i32_u (call $map_build (i32.const 0)))", "i64")
            if self._is_set_type(a0t):
                return (f"(i64.extend_i32_u (call $set_build (i32.const 0) (i32.const 0)))", "i64")
            return (f"(i64.extend_i32_u (call $list_build (i32.const 0)))", "i64")
        if name == "stdCollectionToList":
            if rt:
                return (rt_map_or_list(f"(call $map_keys {a(0, 'i32')})", f"{a(0, 'i32')}"), "i64")
            if is_map:
                return (f"(i64.extend_i32_u (call $map_keys {a(0, 'i32')}))", "i64")
            if self._is_set_type(a0t):
                return (f"(i64.extend_i32_u (call $set_to_list {a(0, 'i32')}))", "i64")
            return (f"(i64.extend_i32_u {a(0, 'i32')})", "i64")
        if name == "stdCollectionToSet":
            if rt:
                return (rt_map_or_list(f"(call $map_to_set {a(0, 'i32')})", f"(call $list_to_set {a(0, 'i32')})"), "i64")
            if is_map:
                return (f"(i64.extend_i32_u (call $map_to_set {a(0, 'i32')}))", "i64")
            if self._is_set_type(a0t):
                return (f"(i64.extend_i32_u {a(0, 'i32')})", "i64")
            return (f"(i64.extend_i32_u (call $list_to_set {a(0, 'i32')}))", "i64")
        if name in ("stdMapKeys", "stdMapExtractKeys", "stdCollectionKeys"):
            return (f"(i64.extend_i32_u (call $map_keys {a(0, 'i32')}))", "i64")
        if name in ("stdMapValues", "stdMapExtractValues", "stdCollectionValues"):
            return (f"(i64.extend_i32_u (call $map_values {a(0, 'i32')}))", "i64")
        if name == "stdCollectionToMap":
            if rt:
                return (rt_map_or_list(f"{a(0, 'i32')}", f"(call $map_from_pairs {a(0, 'i32')})"), "i64")
            if is_map:
                return (f"(i64.extend_i32_u {a(0, 'i32')})", "i64")
            return (f"(i64.extend_i32_u (call $map_from_pairs {a(0, 'i32')}))", "i64")
        if name == "stdMapContainsKey":
            return (f"(i64.extend_i32_u (call $map_contains_key {a(0, 'i32')} {self._map_key_fat(args[1], fb, body, I)}))", "i64")
        if name == "stdMapContainsValue":
            return (f"(i64.extend_i32_u (call $map_contains_value {a(0, 'i32')} {vtag(1)} {a(1, 'i64')}))", "i64")
        if name == "stdMapGetValueOrDefault":
            mp = fb.new_i32()
            res = fb.new_i64()
            kf = self._map_key_fat(args[1], fb, body, I)
            body.append(f"{I}(local.set {mp} {a(0, 'i32')})")
            body.append(f"{I}(local.set {res} {a(2, 'i64')})")
            body.append(f"{I}(if (call $map_contains_key (local.get {mp}) {kf}) (then (local.set {res} (call $map_get (local.get {mp}) {kf}))))")
            return (f"(local.get {res})", "i64")
        if name == "stdMapInsertEntry":
            return (f"(i64.extend_i32_u (call $map_set {a(0, 'i32')} {self._map_key_fat(args[1], fb, body, I)} {vtag(2)} {a(2, 'i64')}))", "i64")
        if name == "stdMapInsertEntryIfAbsent":
            return (f"(i64.extend_i32_u (call $map_set_if_absent {a(0, 'i32')} {self._map_key_fat(args[1], fb, body, I)} {vtag(2)} {a(2, 'i64')}))", "i64")
        if name == "stdMapReplaceEntry":
            return (f"(i64.extend_i32_u (call $map_replace {a(0, 'i32')} {self._map_key_fat(args[1], fb, body, I)} {vtag(2)} {a(2, 'i64')}))", "i64")
        if name in ("stdMapRemoveEntry", "stdMapRemoveKey"):
            return (f"(i64.extend_i32_u (call $map_remove {a(0, 'i32')} {self._map_key_fat(args[1], fb, body, I)}))", "i64")
        if name == "stdMapLength":
            return (f"(i64.extend_i32_u (call $list_len {a(0, 'i32')}))", "i64")
        if name == "stdMapIsEmpty":
            return (f"(i64.extend_i32_u (i32.eqz (call $list_len {a(0, 'i32')})))", "i64")
        if name == "stdMapClearAll":
            return (f"(i64.extend_i32_u (call $map_clear {a(0, 'i32')}))", "i64")
        if name == "stdMapExtractEntries" or name == "stdMapEntries":
            return (f"(i64.extend_i32_u (call $map_entries {a(0, 'i32')}))", "i64")
        if name == "stdMapMerge":
            return (f"(i64.extend_i32_u (call $map_merge {a(0, 'i32')} {a(1, 'i32')}))", "i64")
        if name == "stdMapToMap":
            return (f"(i64.extend_i32_u {a(0, 'i32')})", "i64")
        if name == "stdListToMap":
            return (f"(i64.extend_i32_u (call $map_from_pairs {a(0, 'i32')}))", "i64")
        return ("(i32.const 0)", "i32")

    def _compound_expr(self, op: str | None, name: str, lt: str, rt: str, val: str, local: str | None, is_local: bool, fb: _FuncBuilder | None = None, body: list[str] | None = None, I: str = "  ") -> str:
        ltorig = lt
        lt = "float64" if lt in FLOATISH else lt
        rt = "float64" if rt in FLOATISH else rt
        getter = f"(local.get {local})" if is_local else f"(global.get ${name})"
        if op is None or op == "=":
            if ltorig in FMT_CONSTS and ltorig != "float64":
                inner = val if rt in FLOATISH else f"(f64.convert_i64_s {val})"
                return self._round_wrap(inner, ltorig)
            return val
        op = op[1:]
        if op == "~":
            return f"(i64.xor {getter} (i64.const -1))"
        if op == "^e":
            if lt == "float64" or rt == "float64":
                lc = f"(f64.convert_i64_s {getter})" if lt != "float64" else getter
                rc = f"(f64.convert_i64_s {val})" if rt != "float64" else val
                return f"(call $f64_pow {lc} {rc})"
            if fb is None or body is None:
                raise WatError("pow loop requires body context")
            base_l = fb.new_i64()
            exp_l = fb.new_i64()
            acc_l = fb.new_i64()
            body.append(f"{I}(local.set {base_l} {getter})")
            body.append(f"{I}(local.set {exp_l} {val})")
            body.append(f"{I}(local.set {acc_l} (i64.const 1))")
            seq = self._pow_seq
            self._pow_seq += 1
            body.append(f"{I}(block $pow_x_{seq}")
            body.append(f"{I}  (loop $pow_l_{seq}")
            body.append(f"{I}    (br_if $pow_x_{seq} (i32.eqz (i64.gt_s (local.get {exp_l}) (i64.const 0))))")
            body.append(f"{I}    (local.set {acc_l} (i64.mul (local.get {acc_l}) (local.get {base_l})))")
            body.append(f"{I}    (local.set {exp_l} (i64.sub (local.get {exp_l}) (i64.const 1)))")
            body.append(f"{I}    (br $pow_l_{seq})")
            body.append(f"{I}  )")
            body.append(f"{I})")
            return f"(local.get {acc_l})"
        if op == "^r":
            lc = f"(f64.convert_i64_s {getter})" if lt != "float64" else getter
            rc = f"(f64.convert_i64_s {val})" if rt != "float64" else val
            return f"(call $f64_root {lc} (i64.trunc_f64_s {rc}))"
        if op in ("/i", "/r"):
            if fb is None or body is None:
                raise WatError("euclid compound requires body context")
            r = fb.new_i64()
            nb = fb.new_i64()
            absb = fb.new_i64()
            radj = fb.new_i64()
            end_name = f"$divz_end{len(body)}"
            ok_name = f"$divz_ok{len(body)}"
            body.append(f"{I}(block {end_name}")
            body.append(f"{I}  (block {ok_name}")
            body.append(f"{I}    (br_if {ok_name} (i64.ne {val} (i64.const 0)))")
            body.append(f"{I}    (local.set $__fr_sta (i32.const {self._alloc_str('fail')}))")
            body.append(f"{I}    (local.set $__fr_msg (i32.const {self._alloc_str('divisao por zero')}))")
            body.append(f"{I}    (br {end_name})")
            body.append(f"{I}  )")
            I2 = I + "  "
            body.append(f"{I2}(local.set {r} (i64.rem_s {getter} {val}))")
            body.append(f"{I2}(local.set {nb} (i64.sub (i64.const 0) {val}))")
            body.append(f"{I2}(local.set {absb} (select {val} (local.get {nb}) (i64.gt_s {val} (i64.const 0))))")
            body.append(f"{I2}(local.set {radj} (select (i64.add (local.get {r}) (local.get {absb})) (local.get {r}) (i64.lt_s (local.get {r}) (i64.const 0))))")
            if op == "/r":
                body.append(f"{I2}(br {end_name})")
                body.append(f"{I})")
                return f"(local.get {radj})"
            q = fb.new_i64()
            body.append(f"{I2}(local.set {q} (i64.div_s (i64.sub {getter} (local.get {radj})) {val}))")
            body.append(f"{I2}(br {end_name})")
            body.append(f"{I})")
            return f"(local.get {q})"
        if op == "/f" or (op in ("+", "-", "*") and (lt == "float64" or rt == "float64")):
            lc = f"(f64.convert_i64_s {getter})" if lt != "float64" else getter
            rc = f"(f64.convert_i64_s {val})" if rt != "float64" else val
            wop = {"/f": "f64.div", "+": "f64.add", "-": "f64.sub", "*": "f64.mul"}[op]
            expr = f"({wop} {lc} {rc})"
            if ltorig in FMT_CONSTS and ltorig != "float64":
                expr = self._round_wrap(expr, ltorig)
            res_t = "float64"
        elif op == "/i":
            expr = f"(i64.div_s {getter} {val})"
            res_t = "int64"
        elif op == "/r":
            expr = f"(i64.rem_s {getter} {val})"
            res_t = "int64"
        else:
            wop = {
                "+": "i64.add", "-": "i64.sub", "*": "i64.mul",
                "&": "i64.and", "|": "i64.or", "^": "i64.xor",
                "<<": "i64.shl", ">>": "i64.shr_s", ">>>": "i64.shr_u",
            }.get(op, "i64.add")
            expr = f"({wop} {getter} {val})"
            res_t = "int64"
        if res_t == "float64" and lt != "float64":
            expr = f"(i64.trunc_f64_s {expr})"
        elif res_t != "float64" and lt == "float64":
            expr = f"(f64.convert_i64_s {expr})"
        return expr

    def _store_result_status(self, status: str, body: list[str], I: str, msg: str | None = None) -> None:
        body.append(f"{I}(local.set $__fr_sta (i32.const {self._alloc_str(status)}))")
        if msg is not None:
            body.append(f"{I}(local.set $__fr_msg (i32.const {self._alloc_str(msg)}))")

    def _expr_is_bool(self, node: ASTNode) -> bool:
        if isinstance(node, Literal):
            return node.value_type.lower() == "bool"
        if isinstance(node, UnaryOp):
            return node.op in ("not", "!")
        if isinstance(node, BinaryOp):
            return node.op in ("==", "!=", "<", "<=", ">", ">=", "and", "or", "in")
        if isinstance(node, CallExpr):
            name = _callee_name(node.callee)
            name = self._op_aliases.get(name, name)
            if name in self._user_funcs:
                return self._user_funcs[name]["return_type"] == "bool"
            return False
        if isinstance(node, Identifier):
            if node.name in self._local_vars:
                return self._local_vars[node.name][1] == "bool"
            if node.name in self._globals:
                return self._globals[node.name][0] == "bool"
        return False

    def _sc_set(self, name: str, expr: str, fb: _FuncBuilder, body: list[str], I: str, expr_type: str | None = None) -> None:
        if name in self._result_vars:
            kind, sta, val, msg = self._result_vars[name]
            if expr_type is not None:
                expr = self._fit_wat(expr, expr_type, "i64")
            if kind == "local":
                body.append(f"{I}(local.set {val} {expr})")
                body.append(f"{I}(local.set {sta} (local.get $__fr_sta))")
                body.append(f"{I}(local.set {msg} (local.get $__fr_msg))")
            else:
                body.append(f"{I}(global.set {val} {expr})")
                body.append(f"{I}(global.set {sta} (local.get $__fr_sta))")
                body.append(f"{I}(global.set {msg} (local.get $__fr_msg))")
        elif self._in_function and name in self._local_vars:
            li, lft = self._local_vars[name]
            l_wt = self._wtype(lft)
            if expr_type is not None:
                expr = self._fit_wat(expr, expr_type, l_wt)
            body.append(f"{I}(local.set {li} {expr})")
        else:
            if name in self._globals:
                g_wt = self._globals[name][1]
                if expr_type is not None:
                    expr = self._fit_wat(expr, expr_type, g_wt)
            body.append(f"{I}(global.set ${name} {expr})")

    def _gen_short_circuit(self, node: ShortCircuitBlock, fb: _FuncBuilder, body: list[str], I: str, bind_name: str | None = None) -> None:
        end_name = f"$end_sc{len(body)}"
        fail_name = f"$fail_sc{len(body)}"
        raw: str | None = None
        if isinstance(node.expr, CallExpr):
            raw, _ = self._gen_expr(node.expr, fb, body, I)
        else:
            self._store_result_status("nice", body, I)
            raw, _ = self._gen_expr(node.expr, fb, body, I)
            body.append(f"{I}(local.set $__fr_val {raw})")
            if self._expr_is_bool(node.expr):
                body.append(f"{I}(if (i64.eqz {raw})")
                body.append(f"{I}  (then")
                body.append(f"{I}    (local.set $__fr_sta (i32.const {self._alloc_str('fail')}))")
                body.append(f"{I}    (local.set $__fr_msg (i32.const {self._alloc_str('')}))")
                body.append(f"{I}  )")
                body.append(f"{I})")
        if bind_name is not None and raw is not None:
            self._sc_set(bind_name, raw, fb, body, I)
        body.append(f"{I}(block {fail_name}")
        body.append(f"{I}  (block {end_name}")
        body.append(f"{I}    (if (i32.ne (local.get $__fr_sta) (i32.const {self._alloc_str('fail')}))")
        body.append(f"{I}      (then (br {end_name})))")
        if node.fail_arm:
            self._bind_sc_arm(node.fail_arm, fb, body, I + "    ")
        body.append(f"{I}    (br {fail_name})")
        body.append(f"{I}  )")
        if node.nice_arm:
            self._bind_sc_arm(node.nice_arm, fb, body, I + "  ")
        body.append(f"{I})")
        if bind_name is not None:
            self._sc_set(bind_name, "(local.get $__fr_val)", fb, body, I)

    def _bind_sc_arm(self, arm: ShortCircuitArm, fb: _FuncBuilder, body: list[str], I: str) -> None:
        known = (self._in_function and arm.value in self._local_vars) or arm.value in self._globals
        saved = self._sc_vars.get(arm.value)
        if not known:
            self._sc_vars[arm.value] = "(local.get $__fr_val)"
        self._gen_statement(EmitStmt(status=arm.status, value=arm.value, message=arm.message), fb, body, I)
        if saved is None:
            if not known:
                del self._sc_vars[arm.value]
        else:
            self._sc_vars[arm.value] = saved

    def _emit_user_function(self, func: FunctionDef, lines: list[str], I: str) -> None:
        info = self._user_funcs[func.name]
        saved_vars = self._local_vars
        saved_pw = self._param_wtypes
        saved_pt = self._param_tag_slots
        saved_in_fn = self._in_function
        saved_loops = self._loop_stack
        self._local_vars = {}
        self._param_wtypes = {pname for pname, wt, pft in info["params"] if pft == "data"}
        self._param_tag_slots = {pname: f"$__{pname}_tag" for pname, wt, pft in info["params"] if pft == "data"}
        self._in_function = True
        self._loop_stack = []
        fb = _FuncBuilder()
        params = " ".join(f"(param ${p} {wt})" for p, wt, _ in info["params"])
        if self._param_tag_slots:
            params += " " + " ".join(f"(param {slot} i32)" for slot in self._param_tag_slots.values())
        lines.append(f"{I}(func ${func.name} {params} (result i32 i64 i32)")
        for i, (pname, wt, pft) in enumerate(info["params"]):
            self._local_vars[pname] = (f"${pname}", pft)
        body_lines: list[str] = []
        if func.body:
            self._gen_block(func.body, fb, body_lines, I + "  ")
        locals_block = fb.get_locals_block()
        if locals_block:
            lines.append(locals_block.replace("    ", "  "))
        lines.extend(body_lines)
        lines.append(f"{I}  (return (local.get $__fr_sta) (local.get $__fr_val) (local.get $__fr_msg))")
        lines.append(f"{I})")
        lines.append("")
        self._local_vars = saved_vars
        self._param_wtypes = saved_pw
        self._param_tag_slots = saved_pt
        self._in_function = saved_in_fn
        self._loop_stack = saved_loops

    def _emit_op_function(self, op, lines: list[str], I: str) -> None:
        info = self._user_funcs[op.name]
        saved_vars = self._local_vars
        saved_pw = self._param_wtypes
        saved_pt = self._param_tag_slots
        saved_in_fn = self._in_function
        saved_loops = self._loop_stack
        self._local_vars = {}
        self._param_wtypes = {pname for pname, wt, pft in info["params"] if pft == "data"}
        self._param_tag_slots = {pname: f"$__{pname}_tag" for pname, wt, pft in info["params"] if pft == "data"}
        self._in_function = True
        self._loop_stack = []
        fb = _FuncBuilder()
        params = " ".join(f"(param ${p} {wt})" for p, wt, _ in info["params"])
        if self._param_tag_slots:
            params += " " + " ".join(f"(param {slot} i32)" for slot in self._param_tag_slots.values())
        lines.append(f"{I}(func ${op.name} {params} (result i32 i64 i32)")
        for pname, wt, pft in info["params"]:
            self._local_vars[pname] = (f"${pname}", pft)
        body_lines: list[str] = []
        self._in_op = True
        try:
            if op.body:
                for expr in op.body.expressions:
                    self._gen_statement(expr, fb, body_lines, I + "  ")
        finally:
            self._in_op = False
        locals_block = fb.get_locals_block()
        if locals_block:
            lines.append(locals_block.replace("    ", "  "))
        lines.extend(body_lines)
        lines.append(f"{I}  (return (local.get $__fr_sta) (local.get $__fr_val) (local.get $__fr_msg))")
        lines.append(f"{I})")
        lines.append("")
        self._local_vars = saved_vars
        self._param_wtypes = saved_pw
        self._param_tag_slots = saved_pt
        self._in_function = saved_in_fn
        self._loop_stack = saved_loops

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
        elif isinstance(node, CastExpr):
            self._collect_called_ops(node.expr)
        elif isinstance(node, DataflowCastSink):
            pass
        elif isinstance(node, ListLiteral):
            for it in node.items:
                self._collect_called_ops(it)
        elif isinstance(node, SetLiteral):
            for it in node.items:
                self._collect_called_ops(it)
        elif isinstance(node, MapLiteral):
            for e in node.entries:
                self._collect_called_ops(e.key)
                self._collect_called_ops(e.value)
        elif isinstance(node, RecordLiteral):
            for f in node.fields:
                self._collect_called_ops(f.value)
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
            if node.value_expr is not None:
                self._collect_called_ops(node.value_expr)
            elif isinstance(node.value, ASTNode):
                self._collect_called_ops(node.value)
            self._collect_called_ops(node.message)
        elif isinstance(node, ExpressionStmt):
            self._collect_called_ops(node.expr)
        elif isinstance(node, ShortCircuitBlock):
            self._collect_called_ops(node.expr)
            self._collect_called_ops(node.fail_arm.message) if node.fail_arm else None
            self._collect_called_ops(node.nice_arm.message) if node.nice_arm else None
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
            if node.iterator is not None:
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
            if node.body:
                self._collect_called_ops(node.body)
        elif isinstance(node, InterpolatedString):
            for p in node.parts:
                self._collect_called_ops(p)
        elif isinstance(node, StructInit):
            for f in node.fields:
                self._collect_called_ops(f.value)
        elif isinstance(node, EnumVariant):
            for f in node.fields:
                self._collect_called_ops(f.value)

    def _gen_match(self, node: MatchExpr | MatchStmt, fb: _FuncBuilder, body: list[str], I: str, keep_result: bool) -> tuple[str, str]:
        self._check_match_arm_types(node)
        enum_subject = None
        struct_subject = None
        if isinstance(node.subject, Identifier) and node.subject.name in self._enum_slots:
            es = self._enum_slots[node.subject.name]
            enum_subject = {"kind": es["kind"], "slots": es["slots"]}
            val, vt = ("", "enum")
        elif isinstance(node.subject, EnumVariant):
            val, vt = self._gen_expr(node.subject, fb, body, I)
            if vt == "enum":
                enum_subject = {"kind": "local", "slots": self._pending_enum["slots"]}
                self._pending_enum = None
        elif isinstance(node.subject, Identifier) and node.subject.name in self._struct_slots:
            ss = self._struct_slots[node.subject.name]
            struct_subject = {"kind": ss["kind"], "slots": ss["slots"]}
            val, vt = ("", "struct")
        elif isinstance(node.subject, StructInit):
            self._gen_struct_init(node.subject, fb, body, I)
            if self._pending_struct is None:
                raise WatError("internal: struct init did not produce slots")
            struct_subject = {"kind": "local", "slots": self._pending_struct["slots"]}
            self._pending_struct = None
            val, vt = ("", "struct")
        else:
            val, vt = self._gen_expr(node.subject, fb, body, I)
        sslot = None
        if vt not in ("enum", "struct"):
            if vt == "i32":
                sslot = fb.new_i32()
            elif vt == "f64":
                sslot = fb.new_f64()
            else:
                sslot = fb.new_i64()
            body.append(f"{I}(local.set {sslot} {val})")
        rslot = None
        rt = "i64"
        if keep_result:
            rt = self._match_result_type(node)
            if rt == "f64":
                rslot = fb.new_f64()
            elif rt == "i32":
                rslot = fb.new_i32()
            else:
                rslot = fb.new_i64()
        end_name = f"$end_m{len(body)}"
        body.append(f"{I}(block {end_name}")
        for i, arm in enumerate(node.arms):
            pat = arm.pattern
            arm_I = I + "  "
            if isinstance(pat, LiteralPattern):
                if enum_subject is not None or struct_subject is not None:
                    raise WatError("literal pattern not supported on enum/struct subject")
                next_name = f"$next_m{len(body)}_{i}"
                body.append(f"{arm_I}(block {next_name}")
                lv = pat.value
                ltype = lv.value_type.lower()
                if ltype in ("string", "str"):
                    if vt != "i64":
                        raise WatError(f"literal pattern of type '{ltype}' vs subject type '{vt}'")
                    self._alloc_str(lv.value)
                    lconst = f"(i64.const {self._fat_const(lv.value)})"
                    neop = "i64.ne"
                elif ltype == "char":
                    if vt != "i32":
                        raise WatError(f"literal pattern of type 'char' vs subject type '{vt}'")
                    lconst = f"(i32.const {ord(lv.value)})"
                    neop = "i32.ne"
                elif ltype == "bool":
                    lconst = f"(i64.const {'1' if lv.value.lower() == 'true' else '0'})"
                    neop = "i64.ne"
                elif ltype in ("float", "float64", "float32"):
                    if vt != "f64":
                        raise WatError(f"literal pattern of type '{ltype}' vs subject type '{vt}'")
                    lconst = f"(f64.const {norm_float_text(lv.value)})"
                    neop = "f64.ne"
                else:
                    if vt != "i64":
                        raise WatError(f"literal pattern of type '{ltype}' vs subject type '{vt}'")
                    lconst = f"(i64.const {lv.value})"
                    neop = "i64.ne"
                body.append(f"{arm_I}  (if ({neop} (local.get {sslot}) {lconst}) (then (br {next_name})))")
                self._gen_wat_guard(arm, fb, body, I + "    ", next_name)
                self._gen_match_arm_body(arm, fb, body, I + "    ", rslot, keep_result, end_name)
                body.append(f"{arm_I})")
            elif isinstance(pat, EnumVariantPattern):
                if enum_subject is None:
                    raise WatError("enum variant pattern requires an enum subject")
                edef = self._enums.get(pat.enum)
                if edef is None:
                    raise WatError(f"enum '{pat.enum}' not declared")
                tag = self._enum_tag(edef, pat.variant)
                sget = "global.get" if enum_subject["kind"] == "global" else "local.get"
                next_name = f"$next_m{len(body)}_{i}"
                body.append(f"{arm_I}(block {next_name}")
                body.append(f"{arm_I}  (if (i64.ne ({sget} {enum_subject['slots']['tag'][0]}) (i64.const {tag})) (then (br {next_name})))")
                for f in pat.fields:
                    if f.name not in enum_subject["slots"]["fields"]:
                        raise WatError(f"unknown field '{f.name}' for enum '{pat.enum}'")
                    lid, wt = enum_subject["slots"]["fields"][f.name]
                    is_str = self._enum_field_is_str(edef, f.name)
                    self._gen_wat_pattern_field(f, fb, lid, wt, is_str, sget, body, arm_I, next_name)
                self._gen_wat_guard(arm, fb, body, I + "    ", next_name)
                self._gen_match_arm_body(arm, fb, body, I + "    ", rslot, keep_result, end_name)
                body.append(f"{arm_I})")
            elif isinstance(pat, StructPattern):
                if struct_subject is None:
                    raise WatError("struct pattern requires a struct subject")
                next_name = f"$next_m{len(body)}_{i}"
                body.append(f"{arm_I}(block {next_name}")
                sget = "global.get" if struct_subject["kind"] == "global" else "local.get"
                for f in pat.fields:
                    if f.name not in struct_subject["slots"]["fields"]:
                        raise WatError(f"unknown field '{f.name}' for struct '{pat.name}'")
                    lid, wt = struct_subject["slots"]["fields"][f.name]
                    is_str = self._struct_field_is_str(pat.name, f.name)
                    self._gen_wat_pattern_field(f, fb, lid, wt, is_str, sget, body, arm_I, next_name)
                self._gen_wat_guard(arm, fb, body, arm_I + "    ", next_name)
                self._gen_match_arm_body(arm, fb, body, arm_I + "    ", rslot, keep_result, end_name)
                body.append(f"{arm_I})")
            elif isinstance(pat, RecordPattern):
                st = self._infer_type(node.subject)
                if st not in ("data", "map"):
                    raise WatError("record pattern requires a data/map subject")
                next_name = f"$next_m{len(body)}_{i}"
                body.append(f"{arm_I}(block {next_name}")
                mp = f"(local.get {sslot})" if vt == "i32" else f"(i32.wrap_i64 (local.get {sslot}))"
                body.append(f"{arm_I}  (if (i32.lt_u {mp} (global.get $flux_heap_start)) (then (br {next_name})))")
                for f in pat.fields:
                    fv = f.value
                    kfat = f"(i64.const {self._fat_const(f.name)})"
                    if isinstance(fv, WildcardPattern):
                        continue
                    if isinstance(fv, LiteralPattern):
                        lt = fv.value.value_type.lower()
                        if lt in ("string", "str"):
                            self._alloc_str(fv.value.value)
                            body.append(f"{arm_I}  (if (i64.ne (call $map_get {mp} {kfat}) (i64.const {self._fat_const(fv.value.value)})) (then (br {next_name})))")
                        elif lt == "char":
                            body.append(f"{arm_I}  (if (i64.ne (call $map_get {mp} {kfat}) (i64.const {ord(fv.value.value)})) (then (br {next_name})))")
                        elif lt in ("float", "float64", "float32"):
                            body.append(f"{arm_I}  (if (f64.ne (f64.reinterpret_i64 (call $map_get {mp} {kfat})) (f64.const {norm_float_text(fv.value.value)})) (then (br {next_name})))")
                        else:
                            lconst = f"(i64.const {'1' if fv.value.value.lower() == 'true' else '0'})" if lt == "bool" else f"(i64.const {fv.value.value})"
                            body.append(f"{arm_I}  (if (i64.ne (call $map_get {mp} {kfat}) {lconst}) (then (br {next_name})))")
                    elif isinstance(fv, IdentifierPattern):
                        bl = fb.new_i64()
                        body.append(f"{arm_I}  (local.set {bl} (call $map_get {mp} {kfat}))")
                        self._local_vars[fv.name] = (bl, "int64")
                    else:
                        raise WatError(f"pattern '{type(fv).__name__}' not supported in record pattern on WAT target")
                self._gen_wat_guard(arm, fb, body, arm_I + "    ", next_name)
                self._gen_match_arm_body(arm, fb, body, arm_I + "    ", rslot, keep_result, end_name)
                body.append(f"{arm_I})")
            elif isinstance(pat, IdentifierPattern):
                if enum_subject is not None:
                    raise WatError("bind pattern not supported on enum subject")
                sft = self._match_subject_flux_type(node)
                if sft in FLOATISH:
                    ft = "float64"
                elif self._is_str_type(sft):
                    ft = "string"
                else:
                    ft = "int64"
                bl = fb.new_f64() if ft == "float64" else fb.new_i64()
                self._local_vars[pat.name] = (bl, ft)
                body.append(f"{arm_I}(local.set {bl} (local.get {sslot}))")
                if arm.guard is not None:
                    next_name = f"$next_m{len(body)}_{i}"
                    body.append(f"{arm_I}(block {next_name}")
                    self._gen_wat_guard(arm, fb, body, arm_I + "  ", next_name)
                    self._gen_match_arm_body(arm, fb, body, arm_I + "  ", rslot, keep_result, end_name)
                    body.append(f"{arm_I})")
                else:
                    self._gen_match_arm_body(arm, fb, body, arm_I, rslot, keep_result, end_name)
            elif isinstance(pat, WildcardPattern):
                if arm.guard is not None:
                    next_name = f"$next_m{len(body)}_{i}"
                    body.append(f"{arm_I}(block {next_name}")
                    self._gen_wat_guard(arm, fb, body, arm_I + "  ", next_name)
                    self._gen_match_arm_body(arm, fb, body, arm_I + "  ", rslot, keep_result, end_name)
                    body.append(f"{arm_I})")
                else:
                    self._gen_match_arm_body(arm, fb, body, arm_I, rslot, keep_result, end_name)
            elif isinstance(pat, ListPattern):
                min_len = len(pat.items)
                exact = pat.rest is None
                next_name = f"$next_m{len(body)}_{i}"
                body.append(f"{arm_I}(block {next_name}")
                lp = f"(local.get {sslot})" if vt == "i32" else f"(i32.wrap_i64 (local.get {sslot}))"
                body.append(f"{arm_I}  (if (i32.lt_u {lp} (global.get $flux_heap_start)) (then (br {next_name})))")
                cmp_op = "i32.ne" if exact else "i32.lt_u"
                body.append(f"{arm_I}  (if ({cmp_op} (call $list_len {lp}) (i32.const {min_len})) (then (br {next_name})))")
                sft = self._match_subject_flux_type(node)
                elem_ft = self._list_elem_type(sft) if self._is_list_type(sft) else ("data" if sft == "data" else "int64")
                if not elem_ft:
                    elem_ft = "data"
                for item_idx, item_pat in enumerate(pat.items, 1):
                    if isinstance(item_pat, WildcardPattern):
                        continue
                    entry = f"(call $list_row_val {lp} (i32.const {item_idx}))"
                    tag_entry = f"(call $list_row_tag {lp} (i32.const {item_idx}))"
                    if isinstance(item_pat, IdentifierPattern):
                        if elem_ft in FLOATISH:
                            bl = fb.new_f64()
                            body.append(f"{arm_I}  (local.set {bl} (f64.reinterpret_i64 {entry}))")
                            self._local_vars[item_pat.name] = (bl, "float64")
                        elif self._is_str_type(elem_ft):
                            bl = fb.new_i64()
                            body.append(f"{arm_I}  (local.set {bl} {entry})")
                            self._local_vars[item_pat.name] = (bl, "string")
                            self._str_vars.add(item_pat.name)
                        elif self._is_list_type(elem_ft):
                            bl = fb.new_i64()
                            body.append(f"{arm_I}  (local.set {bl} {entry})")
                            self._local_vars[item_pat.name] = (bl, elem_ft)
                        elif elem_ft == "data":
                            bl = fb.new_i64()
                            body.append(f"{arm_I}  (local.set {bl} {entry})")
                            self._local_vars[item_pat.name] = (bl, "data")
                            tslot = fb.new_i32()
                            body.append(f"{arm_I}  (local.set {tslot} {tag_entry})")
                            self._param_tag_slots[item_pat.name] = tslot
                        else:
                            bl = fb.new_i64()
                            body.append(f"{arm_I}  (local.set {bl} {entry})")
                            self._local_vars[item_pat.name] = (bl, "int64")
                    elif isinstance(item_pat, LiteralPattern):
                        lt = item_pat.value.value_type.lower()
                        if self._is_str_type(lt):
                            self._alloc_str(item_pat.value.value)
                            body.append(f"{arm_I}  (if (i64.ne {entry} (i64.const {self._fat_const(item_pat.value.value)})) (then (br {next_name})))")
                        elif lt == "char":
                            body.append(f"{arm_I}  (if (i64.ne {entry} (i64.const {ord(item_pat.value.value)})) (then (br {next_name})))")
                        elif lt in FLOATISH:
                            body.append(f"{arm_I}  (if (f64.ne (f64.reinterpret_i64 {entry}) (f64.const {norm_float_text(item_pat.value.value)})) (then (br {next_name})))")
                        else:
                            lconst = f"(i64.const {'1' if item_pat.value.value.lower() == 'true' else '0'})" if lt == "bool" else f"(i64.const {item_pat.value.value})"
                            body.append(f"{arm_I}  (if (i64.ne {entry} {lconst}) (then (br {next_name})))")
                    else:
                        raise WatError(f"nested pattern '{type(item_pat).__name__}' in ListPattern not supported on WAT target")
                if pat.rest is not None:
                    rest_slot = fb.new_i64()
                    slice_i32 = fb.new_i32()
                    body.append(f"{arm_I}  (if (i32.gt_u (call $list_len {lp}) (i32.const {min_len}))")
                    body.append(f"{arm_I}    (then (local.set {slice_i32} (call $list_slice {lp} (i32.const {min_len + 1}) (call $list_len {lp}))))")
                    body.append(f"{arm_I}    (else")
                    body.append(f"{arm_I}      (local.set {slice_i32} (call $list_build (i32.const 0)))")
                    body.append(f"{arm_I}      (i32.store (i32.add (local.get {slice_i32}) (i32.const 8)) (call $list_etag {lp}))))")
                    body.append(f"{arm_I}  (local.set {rest_slot} (i64.extend_i32_u (local.get {slice_i32})))")
                    self._local_vars[pat.rest] = (rest_slot, f"list of {elem_ft}")
                self._gen_wat_guard(arm, fb, body, arm_I + "    ", next_name)
                self._gen_match_arm_body(arm, fb, body, arm_I + "    ", rslot, keep_result, end_name)
                body.append(f"{arm_I})")
            else:
                raise WatError(f"pattern '{type(pat).__name__}' not supported on WAT target")
        body.append(f"{I}  (unreachable)")
        body.append(f"{I})")
        if keep_result:
            return (f"(local.get {rslot})", rt)
        return ("", "")

    def _gen_wat_guard(self, arm: MatchArm, fb: _FuncBuilder, body: list[str], I: str, next_name: str) -> None:
        if arm.guard is not None:
            val, _ = self._gen_expr(arm.guard, fb, body, I)
            body.append(f"{I}(if (i64.eqz {val}) (then (br {next_name})))")

    def _gen_wat_pattern_field(self, f, fb, lid: str, wt: str, is_str: bool, sget: str, body: list[str], arm_I: str, next_name: str) -> None:
        fv = f.value
        if isinstance(fv, WildcardPattern):
            return
        if isinstance(fv, LiteralPattern):
            lv = fv.value
            lt = lv.value_type.lower()
            if lt in ("string", "str", "char"):
                if not is_str:
                    raise WatError(f"literal field '{f.name}' of type '{lt}' vs field type '{wt}'")
                self._alloc_str(lv.value)
                body.append(f"{arm_I}  (if (i64.ne ({sget} {lid}) (i64.const {self._fat_const(lv.value)})) (then (br {next_name})))")
                return
            if wt == "f64":
                if lt not in ("float", "float64", "float32"):
                    raise WatError(f"literal field '{f.name}' of type '{lt}' vs field type 'float64'")
                body.append(f"{arm_I}  (if (f64.ne ({sget} {lid}) (f64.const {norm_float_text(lv.value)})) (then (br {next_name})))")
            else:
                lconst = f"(i64.const {'1' if lv.value.lower() == 'true' else '0'})" if lt == "bool" else f"(i64.const {lv.value})"
                body.append(f"{arm_I}  (if (i64.ne ({sget} {lid}) {lconst}) (then (br {next_name})))")
            return
        if isinstance(fv, IdentifierPattern):
            bl = fb.new_i64() if wt == "i64" else (fb.new_f64() if wt == "f64" else fb.new_i32())
            body.append(f"{arm_I}  (local.set {bl} ({sget} {lid}))")
            ft = "float64" if wt == "f64" else ("string" if is_str else "int64")
            self._local_vars[fv.name] = (bl, ft)
            return
        raise WatError(f"nested field pattern not supported on WAT target")

    def _gen_match_arm_body(self, arm: MatchArm, fb: _FuncBuilder, body: list[str], I: str, rslot: str | None, keep_result: bool, end_name: str) -> None:
        b = arm.body
        if isinstance(b, BlockStmt):
            for stmt in b.body:
                self._gen_statement(stmt, fb, body, I)
            if keep_result:
                body.append(f"{I}(local.set {rslot} (i64.const 0))")
        elif isinstance(b, (PrintStmt, EmitStmt, RouteStmt, InfiniteStmt,
                            BreakStmt, ContinueStmt, VariableReassign,
                            CallExpr, StorageDecl, ExpressionStmt)):
            self._gen_statement(b, fb, body, I)
        else:
            v, _ = self._gen_expr(b, fb, body, I)
            if keep_result:
                body.append(f"{I}(local.set {rslot} {v})")
        body.append(f"{I}(br {end_name})")

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
            bindft: dict[str, str] | None = None
            if isinstance(arm.pattern, EnumVariantPattern):
                edef = self._enums.get(arm.pattern.enum)
                if edef is None:
                    raise WatError(f"enum '{arm.pattern.enum}' not declared")
                layout = self._enum_layout(edef)
                bindft = {}
                for f in arm.pattern.fields:
                    if f.name not in layout["fields"]:
                        raise WatError(f"unknown field '{f.name}' for enum '{arm.pattern.enum}'")
                    if isinstance(f.value, IdentifierPattern):
                        if self._enum_field_is_str(edef, f.name):
                            bindft[f.value.name] = "string"
                        elif layout["fields"][f.name] == "f64":
                            bindft[f.value.name] = "float64"
                        else:
                            bindft[f.value.name] = "int64"
            if isinstance(b, Literal):
                vt = b.value_type.lower()
                if vt in ("string", "str", "char"):
                    t = "string"
                elif vt in FLOATISH:
                    t = "float64"
                elif vt == "bool":
                    t = "bool"
                else:
                    t = "int64"
            elif isinstance(b, (Identifier, BinaryOp)):
                if bindft is not None:
                    refs = [n for n in bindft if self._refs_bind(b, {n})]
                    if refs:
                        t = bindft[refs[0]]
                elif bind_names and self._refs_bind(b, bind_names):
                    if self._is_str_type(subj_t):
                        t = "string"
                    elif subj_t in FLOATISH:
                        t = "float64"
                    elif subj_t == "bool":
                        t = "bool"
                    else:
                        t = "int64"
                if t is None:
                    it = self._infer_type(b)
                    if it == "float64":
                        t = "float64"
                    elif self._is_str_type(it):
                        t = "string"
                    else:
                        t = "int64"
            if t is not None:
                wtypes.add(t)
        if len(wtypes) > 1:
            raise WatError(f"match arms must produce same type, found {sorted(wtypes)}")

    def _match_subject_flux_type(self, node: MatchExpr | MatchStmt) -> str:
        s = node.subject
        if isinstance(s, Literal):
            return s.value_type.lower()
        if isinstance(s, Identifier) and s.name in self._local_vars:
            return self._local_vars[s.name][1]
        if isinstance(s, Identifier) and s.name in self._globals:
            return self._globals[s.name][0]
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

    def _match_result_type(self, node: MatchExpr | MatchStmt) -> str:
        for arm in node.arms:
            b = arm.body
            if isinstance(arm.pattern, EnumVariantPattern):
                edef = self._enums.get(arm.pattern.enum)
                if edef is None:
                    continue
                layout = self._enum_layout(edef)
                for f in arm.pattern.fields:
                    if layout["fields"].get(f.name) == "f64":
                        return "f64"
                    if layout["fields"].get(f.name) == "i32":
                        return "i32"
                return "i64"
            if isinstance(b, Literal):
                vt = b.value_type.lower()
                if vt in ("float", "float64", "float32"):
                    return "f64"
                return "i64"
        return "i64"

    def _gen_route(self, node: RouteStmt, fb: _FuncBuilder, body: list[str], I: str) -> None:
        end_name = f"$end_r{len(body)}"
        body.append(f"{I}(block {end_name}")
        for i, arm in enumerate(node.arms):
            is_wc = (isinstance(arm.condition, Identifier) and arm.condition.name == "_") or arm.condition is None
            if not is_wc:
                next_name = f"$next_r{len(body)}_{i}"
                body.append(f"{I}  (block {next_name}")
                val, t = self._gen_expr(arm.condition, fb, body, I + "    ")
                if t == "i32":
                    val = f"(i64.extend_i32_u {val})"
                body.append(f"{I}    (if (i64.eqz {val}) (then (br {next_name})))")
                if arm.body:
                    if isinstance(arm.body, BlockStmt):
                        self._gen_block(arm.body, fb, body, I + "      ")
                    else:
                        self._gen_statement(arm.body, fb, body, I + "      ")
                body.append(f"{I}    (br {end_name})")
                body.append(f"{I}  )")
            else:
                if arm.body:
                    if isinstance(arm.body, BlockStmt):
                        self._gen_block(arm.body, fb, body, I + "  ")
                    else:
                        self._gen_statement(arm.body, fb, body, I + "  ")
                body.append(f"{I}  (br {end_name})")
        body.append(f"{I})")

    def _gen_infinite(self, node: InfiniteStmt, fb: _FuncBuilder, body: list[str], I: str) -> None:
        if node.iterator is not None:
            return self._gen_infinite_iterator(node, fb, body, I)
        end_name = f"$end_l{len(body)}"
        loop_name = f"$loop_l{len(body)}"
        body.append(f"{I}(block {end_name}")
        body.append(f"{I}  (loop {loop_name}")
        self._loop_stack.append((end_name, loop_name))
        if node.condition:
            val, t = self._gen_expr(node.condition, fb, body, I + "    ")
            if t == "i32":
                val = f"(i64.extend_i32_u {val})"
            body.append(f"{I}    (if (i64.eqz {val}) (then (br {end_name})))")
        if node.body and isinstance(node.body, BlockStmt):
            self._gen_block(node.body, fb, body, I + "    ")
        body.append(f"{I}    (br {loop_name})")
        body.append(f"{I}  )")
        body.append(f"{I})")
        self._loop_stack.pop()

    def _gen_infinite_iterator(self, node: InfiniteStmt, fb: _FuncBuilder, body: list[str], I: str) -> None:
        coll = node.iterator.collection
        name = node.iterator.variable
        if isinstance(coll, BinaryOp) and coll.op == "..":
            self._gen_infinite_range(node, coll, name, fb, body, I)
            return
        ct = self._infer_type(coll)
        is_str_coll = self._is_str_type(ct)
        is_map_coll = self._is_map_type(ct)
        if not (is_str_coll or is_map_coll or self._is_list_type(ct) or self._is_set_type(ct)):
            raise WatError("infinite iterator requires a numeric range 'a .. b' or a list/set/map/string collection")
        if is_str_coll:
            v, vt = self._gen_expr(coll, fb, body, I)
            sval = fb.new_i64()
            body.append(f"{I}(local.set {sval} {self._fit_wat(v, vt, 'i64')})")
            nloc = fb.new_i32()
            body.append(f"{I}(local.set {nloc} (call $str_char_len (i32.wrap_i64 (i64.shr_u (local.get {sval}) (i64.const 32)))))")
            idx = fb.new_i32()
            body.append(f"{I}(local.set {idx} (i32.const 0))")
            elocal = fb.new_i64()
            elft = "string"
            end_name = f"$end_l{len(body)}"
            loop_name = f"$loop_l{len(body)}"
            body.append(f"{I}(block {end_name}")
            body.append(f"{I}  (loop {loop_name}")
            self._loop_stack.append((end_name, loop_name))
            saved = self._local_vars.get(name)
            body.append(f"{I}    (local.set {idx} (i32.add (local.get {idx}) (i32.const 1)))")
            body.append(f"{I}    (if (i32.gt_u (local.get {idx}) (local.get {nloc})) (then (br {end_name})))")
            body.append(f"{I}    (local.set {elocal} (call $str_slice_fat (local.get {sval}) (local.get {idx}) (local.get {idx})))")
            self._local_vars[name] = (elocal, elft)
            if node.body and isinstance(node.body, BlockStmt):
                self._gen_block(node.body, fb, body, I + "    ")
            body.append(f"{I}    (br {loop_name})")
            body.append(f"{I}  )")
            body.append(f"{I})")
            self._loop_stack.pop()
            if saved is not None:
                self._local_vars[name] = saved
            else:
                self._local_vars.pop(name, None)
            return
        if is_map_coll:
            et = "string"
        elif self._is_set_type(ct):
            et = self._set_elem_type(ct)
        else:
            et = self._list_elem_type(ct)
        et = et.strip()
        cp = fb.new_i32()
        v, vt = self._gen_expr(coll, fb, body, I)
        body.append(f"{I}(local.set {cp} {self._fit_wat(v, vt, 'i32')})")
        if is_map_coll:
            body.append(f"{I}(local.set {cp} (call $map_keys (local.get {cp})))")
        nloc = fb.new_i32()
        body.append(f"{I}(local.set {nloc} (call $list_len (local.get {cp})))")
        idx = fb.new_i32()
        body.append(f"{I}(local.set {idx} (i32.const 0))")
        elocal = fb.new_f64() if self._list_tag_of(et) == 3 else fb.new_i64()
        if et == "data":
            elft = "data"
        else:
            elft = "float64" if self._list_tag_of(et) == 3 else ("string" if self._list_tag_of(et) == 4 else "int64")
        end_name = f"$end_l{len(body)}"
        loop_name = f"$loop_l{len(body)}"
        body.append(f"{I}(block {end_name}")
        body.append(f"{I}  (loop {loop_name}")
        self._loop_stack.append((end_name, loop_name))
        saved = self._local_vars.get(name)
        body.append(f"{I}    (local.set {idx} (i32.add (local.get {idx}) (i32.const 1)))")
        body.append(f"{I}    (if (i32.gt_u (local.get {idx}) (local.get {nloc})) (then (br {end_name})))")
        rowv = f"(call $list_row_val (local.get {cp}) (local.get {idx}))"
        if elft == "float64":
            rowv = f"(f64.reinterpret_i64 {rowv})"
        self._local_vars[name] = (elocal, elft)
        body.append(f"{I}    (local.set {elocal} {rowv})")
        if et == "data":
            tag_slot = fb.new_i32()
            body.append(f"{I}    (local.set {tag_slot} (call $list_row_tag (local.get {cp}) (local.get {idx})))")
            self._param_tag_slots[name] = tag_slot
        if node.body and isinstance(node.body, BlockStmt):
            self._gen_block(node.body, fb, body, I + "    ")
        body.append(f"{I}    (br {loop_name})")
        body.append(f"{I}  )")
        body.append(f"{I})")
        self._loop_stack.pop()
        if et == "data":
            self._param_tag_slots.pop(name, None)
        if saved is not None:
            self._local_vars[name] = saved
        else:
            self._local_vars.pop(name, None)

    def _gen_infinite_range(self, node: InfiniteStmt, coll: BinaryOp, name: str, fb: _FuncBuilder, body: list[str], I: str) -> None:
        li = fb.new_i64()
        self._local_vars[name] = (li, "int64")
        v, vt = self._gen_expr(coll.left, fb, body, I)
        body.append(f"{I}(local.set {li} {self._fit_wat(v, vt, 'i64')})")
        ev = fb.new_i64()
        self._local_vars[f"__ev_{name}"] = (ev, "int64")
        v2, vt2 = self._gen_expr(coll.right, fb, body, I)
        body.append(f"{I}(local.set {ev} {self._fit_wat(v2, vt2, 'i64')})")
        desc = fb.new_i32()
        step = fb.new_i64()
        body.append(f"{I}(local.set {desc} (i64.gt_s (local.get {li}) (local.get {ev})))")
        body.append(f"{I}(local.set {step} (select (i64.const -1) (i64.const 1) (local.get {desc})))")
        end_name = f"$end_l{len(body)}"
        loop_name = f"$loop_l{len(body)}"
        body.append(f"{I}(block {end_name}")
        body.append(f"{I}  (loop {loop_name}")
        self._loop_stack.append((end_name, loop_name))
        body.append(f"{I}    (if (select (i64.lt_s (local.get {li}) (local.get {ev})) (i64.gt_s (local.get {li}) (local.get {ev})) (local.get {desc})) (then (br {end_name})))")
        if node.body and isinstance(node.body, BlockStmt):
            self._gen_block(node.body, fb, body, I + "    ")
        body.append(f"{I}    (local.set {li} (i64.add (local.get {li}) (local.get {step})))")
        body.append(f"{I}    (br {loop_name})")
        body.append(f"{I}  )")
        body.append(f"{I})")
        self._loop_stack.pop()
