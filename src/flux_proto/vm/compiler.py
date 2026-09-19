from __future__ import annotations

from flux_proto.parser.ast import (
    ComptimeExpr,
    ASTNode, FluxProgram, FdslFile, BlockStmt, ExpressionStmt, PrintStmt,
    Literal, Identifier, BinaryOp, UnaryOp, CallExpr,
    VariableReassign, RouteStmt, RouteArm, InfiniteStmt,
    BreakStmt, ContinueStmt, EmitStmt,
    UnsafeStmt, OwnershipExpr, SpawnExpr, AwaitExpr,
    PtrRefExpr, PtrDerefExpr, PtrAssign, ExternDecl,
    ShortCircuitBlock, ShortCircuitArm, InputExpr,
    StructInit, InitField, FieldAccess, StorageDecl,
    FunctionDef, Parameter,
    InterpolatedString, InterpolatedText, EnumVariant,
    MatchExpr, MatchStmt, MatchArm,
    WildcardPattern, LiteralPattern, IdentifierPattern,
    RecordPattern, EnumDef, EnumVariantPattern, FieldAssign,
    StructPattern, StructDef, ListPattern,
    ListLiteral, SetLiteral, MapLiteral, RecordLiteral, IndexAccess, IndexAssign, SliceSpec,
    DataflowExpr, DataflowCastSink, CastExpr, SpyExpr,
)
from flux_proto.floating import FLOAT_FORMATS
from flux_proto.interpreter.environment import DEFAULT_VALUES
from flux_proto.parser.import_resolver import collect_op_aliases
from flux_proto.interpreter.interpreter import (
    _COMPLEX_COMPONENTS, _nested_zeros, _parse_complex_literal, _parse_iso_nanos,
    _tensor_dims, _tensor_flat_len,
)
from flux_proto.vm.opcodes import Op
from flux_proto.vm.runtime import _Chr, _DT, BUILTIN_NAMES, TensorVal


def _const_int(node: ASTNode | None) -> int | None:
    if isinstance(node, UnaryOp):
        v = _const_int(node.operand)
        return None if v is None else -v
    if isinstance(node, Literal) and str(node.value_type).lower() in ("int", "int64"):
        try:
            return int(node.value)
        except (TypeError, ValueError):
            return None
    return None
class CompileError(Exception):
    pass


CompilerError = CompileError


def _callee_name(callee: ASTNode | None) -> str:
    if isinstance(callee, Identifier):
        return callee.name
    if isinstance(callee, EnumVariant):
        return callee.variant
    if isinstance(callee, FieldAccess) and isinstance(callee.obj, Identifier):
        return callee.field
    return ""


def _is_print_call(node: ASTNode) -> bool:
    if isinstance(node, CallExpr):
        return _callee_name(node.callee) in ("print", "println")
    return False


def _input_prompt_text(node: InputExpr) -> str:
    if isinstance(node.prompt, Literal) and str(node.prompt.value_type).lower() == "string":
        return node.prompt.value
    return ""


def _is_void_op_call(node: ASTNode, op_aliases: dict[str, str], void_op_names: set[str]) -> bool:
    if isinstance(node, CallExpr):
        name = _callee_name(node.callee)
        name = op_aliases.get(name, name)
        return name in void_op_names
    return False


def compile_to_bytecode(program: ASTNode) -> list:
    from flux_proto.macro.expander import expand_macros
    if isinstance(program, FluxProgram):
        program = expand_macros(program)
    c = Compiler()
    return c.compile(program)


class Compiler:
    def __init__(self) -> None:
        self._instrs: list = []
        self._labels: dict[str, int] = {}
        self._patches: list[tuple[int, str]] = []
        self._loop_break: str | None = None
        self._loop_continue: str | None = None
        self._imports: dict[str, FdslFile] = {}
        self._op_aliases: dict[str, str] = {}
        self._function_names: set[str] = set()
        self._op_names: set[str] = set()
        self._void_op_names: set[str] = set()
        self._enums: dict[str, EnumDef] = {}
        self._in_binary_op: bool = False
        self._structs: dict[str, StructDef] = {}
        self._vartypes: dict[str, str] = {}
        self._in_op: bool = False
        self._scope_depth: int = 0
        self._loop_scope_depth: int = 0

    def compile(self, node: ASTNode) -> list:
        if isinstance(node, FluxProgram):
            self._imports = node.imports
            self._op_aliases = collect_op_aliases(node)
            self._function_names = {f.name for f in node.functions}
            self._op_names = set()
            self._void_op_names = set()
            for fdsl_file in node.imports.values():
                if fdsl_file is None:
                    continue
                for agent in fdsl_file.agents:
                    if agent.body is None:
                        continue
                    for op in agent.body.ops:
                        self._op_names.add(op.name)
                        if op.return_type is None:
                            self._void_op_names.add(op.name)
            self._enums = {e.name: e for e in node.enums}
            self._structs = {s.name: s for s in node.structs}
            for fdsl_file in node.imports.values():
                if fdsl_file is None:
                    continue
                for agent in fdsl_file.agents:
                    if agent.body:
                        for s in agent.body.storages:
                            self._compile_storage(s)
            for s in node.storages:
                self._compile_storage(s)
            if node.body:
                self._compile_block(node.body)
            self._emit(Op.HALT)
            for func in node.functions:
                self._compile_function(func)
            for fdsl_file in node.imports.values():
                if fdsl_file is None:
                    continue
                for agent in fdsl_file.agents:
                    if agent.body is None:
                        continue
                    for op in agent.body.ops:
                        self._compile_op(op)
            self._resolve_labels()
            return self._instrs
        raise CompileError(f"Cannot compile {type(node).__name__}")

    def _emit(self, op: Op, *args: object) -> None:
        self._instrs.append([op.value, *args])

    def _label(self, name: str) -> None:
        self._labels[name] = len(self._instrs)

    def _patch_at(self, label: str) -> None:
        self._patches.append((len(self._instrs) - 1, label))

    def _emit_jmp(self, target_label: str) -> None:
        self._emit(Op.JMP, 0)
        self._patch_at(target_label)

    def _emit_jz(self, target_label: str) -> None:
        self._emit(Op.JZ, 0)
        self._patch_at(target_label)

    def _emit_jnz(self, target_label: str) -> None:
        self._emit(Op.JNZ, 0)
        self._patch_at(target_label)

    def _resolve_labels(self) -> None:
        for idx, label in self._patches:
            self._instrs[idx][-1] = self._labels.get(label, 0)

    def _compile_storage(self, node: StorageDecl) -> None:
        for item in node.items:
            tname = item.type_ref.name if item.type_ref else ""
            if isinstance(item.initializer, ShortCircuitBlock):
                self._compile_short_circuit(item.initializer, bind_name=item.name, declare=True)
            elif item.initializer:
                if isinstance(item.initializer, InputExpr):
                    self._emit(Op.INPUT, tname, _input_prompt_text(item.initializer))
                else:
                    self._compile_expr(item.initializer)
                    if tname.startswith("tensor"):
                        dims = _tensor_dims(tname)
                        if isinstance(item.initializer, ListLiteral):
                            if dims:
                                self._emit(Op.TENSOR_PACK, list(dims))
                        else:
                            self._emit(Op.TMAT)
                    self._emit_round(tname)
                self._emit(Op.DECLARE, item.name, tname)
            else:
                self._emit(Op.PUSH, self._default_value(tname))
                self._emit(Op.DECLARE, item.name, tname)
            self._vartypes[item.name] = tname

    def _default_value(self, tname: str) -> object:
        if tname.startswith("string("):
            return ""
        if tname.startswith("tensor"):
            dims = _tensor_dims(tname)
            if dims:
                return TensorVal(list(dims), [0] * _tensor_flat_len(dims))
        if tname == "datetime":
            return _DT(0)
        if tname in DEFAULT_VALUES:
            return DEFAULT_VALUES[tname]
        return 0

    def _emit_round(self, tname: str) -> None:
        if tname in FLOAT_FORMATS and tname != "float64":
            self._emit(Op.ROUND, tname)
        elif tname in _COMPLEX_COMPONENTS:
            self._emit(Op.ROUND_COMPLEX, tname)

    def _expr_type(self, node: ASTNode | None) -> str:
        if isinstance(node, Literal):
            return {
                "int": "int64", "INT": "int64", "float": "float64", "FLOAT": "float64",
                "complex": "complex64", "COMPLEX": "complex64",
                "datetime": "datetime", "DATETIME": "datetime",
                "bool": "bool", "BOOL": "bool", "char": "char", "string": "string",
            }.get(node.value_type.lower(), "string")
        if isinstance(node, Identifier):
            return self._vartypes.get(node.name, "int64")
        if isinstance(node, UnaryOp):
            return self._expr_type(node.operand)
        if isinstance(node, BinaryOp):
            lt = self._expr_type(node.left)
            rt = self._expr_type(node.right)
            if node.op == "+" and (lt == "string" or rt == "string"):
                return "string"
            if node.op == "^r":
                return "float64"
            if lt in _COMPLEX_COMPONENTS or rt in _COMPLEX_COMPONENTS:
                return lt if lt in _COMPLEX_COMPONENTS else rt
            if lt == "float64" or rt == "float64":
                return "float64"
            if lt in FLOAT_FORMATS and lt == rt:
                return lt
            if lt in FLOAT_FORMATS:
                return lt
            return "int64"
        if isinstance(node, IndexAccess):
            tname = self._expr_type(node.obj)
            for prefix in ("list of ", "set of ", "data", "tensor"):
                if tname.startswith(prefix):
                    elem = tname[len(prefix):]
                    if " of " in elem:
                        return elem.split(" of ")[1]
                    if prefix == "data":
                        return "string"
                    return elem
            return "int64"
        return "int64"

    def _tensor_slice_spec(self, indices: list) -> list:
        spec: list = []
        for ix in indices:
            if isinstance(ix, SliceSpec):
                step = 1
                if ix.step is not None:
                    c = _const_int(ix.step)
                    if c is None or c == 0:
                        raise CompileError("tensor slice step must be a nonzero integer literal")
                    step = c
                spec.append([
                    "s",
                    None if ix.start is None else _const_int(ix.start),
                    None if ix.end is None else _const_int(ix.end),
                    step,
                ])
                if (ix.start is not None and spec[-1][1] is None) or (
                    ix.end is not None and spec[-1][2] is None
                ):
                    raise CompileError("tensor slice bounds must be integer literals")
            else:
                spec.append(["i"])
        return spec

    def _compile_block(self, node: BlockStmt) -> None:
        self._scope_depth += 1
        self._emit(Op.SCOPE_ENTER)
        for stmt in node.body:
            self._compile_statement(stmt)
        self._emit(Op.SCOPE_EXIT)
        self._scope_depth -= 1

    def _compile_statement(self, node: ASTNode, keep_result: bool = False) -> None:
        if self._is_exotic(node):
            self._raise_exotic(node)
        if isinstance(node, ExpressionStmt):
            self._compile_expr(node.expr)
            void_call = _is_void_op_call(node.expr, self._op_aliases, self._void_op_names)
            if not keep_result and not isinstance(node.expr, EnumVariant) and not _is_print_call(node.expr) and not void_call and not isinstance(node.expr, DataflowExpr):
                self._emit(Op.POP)
            return
        if isinstance(node, PrintStmt):
            for a in node.args:
                self._compile_expr(a)
            self._emit(Op.PRINTLN, len(node.args))
            return
        if isinstance(node, StorageDecl):
            self._compile_storage(node)
            return
        if isinstance(node, VariableReassign):
            if isinstance(node.value, ShortCircuitBlock) and (not node.op or node.op == "="):
                self._compile_short_circuit(node.value, bind_name=node.name)
                return
            if node.op and node.op != "=":
                comp = node.op[1:]
                if comp == "~":
                    self._emit(Op.LOAD, node.name)
                    self._emit(Op.BNOT)
                else:
                    self._emit(Op.LOAD, node.name)
                    self._compile_expr(node.value)
                    self._emit(_binop_to_op(comp))
            else:
                self._compile_expr(node.value)
                if (
                    self._vartypes.get(node.name, "").startswith("tensor")
                    and self._expr_type(node.value).startswith("tensor")
                ):
                    self._emit(Op.TMAT)
            self._emit_round(self._vartypes.get(node.name, ""))
            self._emit(Op.STORE, node.name)
            return
        if isinstance(node, FieldAssign):
            self._emit(Op.LOAD, node.owner)
            self._compile_expr(node.value)
            self._emit(Op.FIELD_SET, node.field)
            self._emit(Op.POP)
            return
        if isinstance(node, CallExpr):
            self._compile_expr(node)
            if not keep_result and not _is_print_call(node):
                self._emit(Op.POP)
            return
        if isinstance(node, RouteStmt):
            self._compile_route(node)
            return
        if isinstance(node, MatchStmt):
            self._compile_match(node, keep_result=keep_result)
            return
        if isinstance(node, InfiniteStmt):
            self._compile_infinite(node)
            return
        if isinstance(node, UnsafeStmt):
            body = node.body
            if body is None:
                return
            if isinstance(body, BlockStmt):
                self._compile_block(body)
            else:
                self._compile_statement(body)
            return
        if isinstance(node, EmitStmt):
            if node.value_expr is not None:
                if not self._in_op:
                    raise CompilerError("emit accepts only a single declared identifier as value, expressions are not allowed")
                self._compile_expr(node.value_expr)
            else:
                self._compile_expr(Identifier(name=node.value))
            if node.message:
                self._compile_expr(node.message)
            self._emit(Op.EMIT, node.status)
            if self._in_op:
                self._emit(Op.RET)
            return
        if isinstance(node, BreakStmt):
            for _ in range(self._scope_depth - self._loop_scope_depth):
                self._emit(Op.SCOPE_EXIT)
            if self._loop_break:
                self._emit_jmp(self._loop_break)
            return
        if isinstance(node, ContinueStmt):
            for _ in range(self._scope_depth - self._loop_scope_depth):
                self._emit(Op.SCOPE_EXIT)
            if self._loop_continue:
                self._emit_jmp(self._loop_continue)
            return

    def _compile_route(self, node: RouteStmt) -> None:
        end_label = f"r_{len(self._instrs)}"
        for i, arm in enumerate(node.arms):
            next_label = f"r_{len(self._instrs)}_{i}"
            if arm.condition:
                if isinstance(arm.condition, Identifier) and arm.condition.name == "_":
                    pass
                else:
                    self._compile_expr(arm.condition)
                    self._emit_jz(next_label)
            if arm.body:
                if isinstance(arm.body, BlockStmt):
                    self._compile_block(arm.body)
                else:
                    self._compile_statement(arm.body)
            self._emit_jmp(end_label)
            self._label(next_label)
        self._label(end_label)

    def _compile_match(self, node: MatchExpr | MatchStmt, keep_result: bool = False) -> None:
        prefix = f"m_{len(self._instrs)}"
        end_label = f"{prefix}_end"
        self._emit(Op.SCOPE_ENTER)
        self._compile_expr(node.subject)
        for i, arm in enumerate(node.arms):
            next_label = f"{prefix}_{i}"
            pop_subject = arm.guard is None
            self._compile_pattern_match(arm.pattern, next_label, pop_subject=pop_subject)
            self._compile_guard(arm, next_label)
            if arm.body:
                if isinstance(arm.body, BlockStmt):
                    self._compile_block(arm.body)
                elif keep_result:
                    self._compile_expr(arm.body)
                else:
                    self._compile_statement(arm.body)
            if arm.guard is not None:
                self._emit(Op.POP)
            self._emit_jmp(end_label)
            self._label(next_label)
        self._emit(Op.POP)
        self._emit(Op.MATCH_FAIL)
        self._label(end_label)

    def _compile_pattern_match(
        self, pattern: ASTNode, next_label: str, depth: int = 0, pop_subject: bool = True
    ) -> None:
        if isinstance(pattern, WildcardPattern):
            if pop_subject:
                self._emit(Op.POP)
        elif isinstance(pattern, LiteralPattern):
            self._emit(Op.DUP)
            self._compile_literal(pattern.value)
            self._emit(Op.EQ)
            if depth:
                self._emit(Op.JUMP_IF_NOT_MATCH_DROP, depth, 0)
            else:
                self._emit(Op.JUMP_IF_NOT_MATCH, 0)
            self._patch_at(next_label)
            if pop_subject:
                self._emit(Op.POP)
        elif isinstance(pattern, IdentifierPattern):
            if not pop_subject:
                self._emit(Op.DUP)
            self._emit(Op.MATCH_BIND, pattern.name)
        elif isinstance(pattern, EnumVariantPattern):
            edef = self._enums.get(pattern.enum)
            if edef is None:
                raise CompileError(
                    f"enum '{pattern.enum}' not found in match pattern"
                )
            tag = -1
            for i, m in enumerate(edef.members):
                if m.name == pattern.variant:
                    tag = i
                    break
            if tag < 0:
                raise CompileError(
                    f"variant '{pattern.variant}' not found in enum '{pattern.enum}'"
                )
            self._emit(Op.DUP)
            self._emit(Op.ENUM_TAG)
            self._emit(Op.PUSH, tag)
            self._emit(Op.EQ)
            if depth:
                self._emit(Op.JUMP_IF_NOT_MATCH_DROP, depth, 0)
            else:
                self._emit(Op.JUMP_IF_NOT_MATCH, 0)
            self._patch_at(next_label)
            self._compile_pattern_fields(pattern.fields, Op.ENUM_FIELD, next_label, depth)
            if pop_subject:
                self._emit(Op.POP)
        elif isinstance(pattern, StructPattern):
            sdef = self._structs.get(pattern.name)
            if sdef is None:
                raise CompileError(
                    f"struct '{pattern.name}' not found in match pattern"
                )
            self._emit(Op.DUP)
            self._emit(Op.STRUCT_MATCH, pattern.name)
            if depth:
                self._emit(Op.JUMP_IF_NOT_MATCH_DROP, depth, 0)
            else:
                self._emit(Op.JUMP_IF_NOT_MATCH, 0)
            self._patch_at(next_label)
            self._compile_pattern_fields(pattern.fields, Op.FIELD_GET, next_label, depth)
            if pop_subject:
                self._emit(Op.POP)
        elif isinstance(pattern, RecordPattern):
            self._emit(Op.DUP)
            self._emit(Op.RECORD_MATCH)
            if depth:
                self._emit(Op.JUMP_IF_NOT_MATCH_DROP, depth, 0)
            else:
                self._emit(Op.JUMP_IF_NOT_MATCH, 0)
            self._patch_at(next_label)
            self._compile_pattern_fields(pattern.fields, Op.RECORD_FIELD, next_label, depth)
            if pop_subject:
                self._emit(Op.POP)
        elif isinstance(pattern, ListPattern):
            min_len = len(pattern.items)
            exact = pattern.rest is None
            self._emit(Op.DUP)
            self._emit(Op.LIST_MATCH, min_len, exact)
            if depth:
                self._emit(Op.JUMP_IF_NOT_MATCH_DROP, depth, 0)
            else:
                self._emit(Op.JUMP_IF_NOT_MATCH, 0)
            self._patch_at(next_label)
            for idx, item_pat in enumerate(pattern.items):
                self._emit(Op.DUP)
                self._emit(Op.LIST_ITEM, idx)
                self._compile_pattern_match(item_pat, next_label, depth + 1, pop_subject=True)
            if pattern.rest is not None:
                self._emit(Op.DUP)
                self._emit(Op.LIST_REST, min_len)
                self._emit(Op.MATCH_BIND, pattern.rest)
            if pop_subject:
                self._emit(Op.POP)
        else:
            raise CompileError(
                f"pattern '{type(pattern).__name__}' not supported on VM target"
            )

    def _compile_guard(self, arm: MatchArm, next_label: str) -> None:
        if arm.guard is not None:
            self._compile_expr(arm.guard)
            self._emit(Op.JZ, 0)
            self._patch_at(next_label)

    def _compile_pattern_fields(self, fields: list[InitField], field_op: Op, next_label: str, depth: int = 0) -> None:
        for f in fields:
            fv = f.value
            if isinstance(fv, WildcardPattern):
                continue
            if isinstance(fv, LiteralPattern):
                self._emit(Op.DUP)
                self._emit(field_op, f.name)
                self._compile_literal(fv.value)
                self._emit(Op.EQ)
                if depth:
                    self._emit(Op.JUMP_IF_NOT_MATCH_DROP, depth, 0)
                else:
                    self._emit(Op.JUMP_IF_NOT_MATCH, 0)
                self._patch_at(next_label)
                continue
            if isinstance(fv, IdentifierPattern):
                self._emit(Op.DUP)
                self._emit(field_op, f.name)
                self._emit(Op.MATCH_BIND, fv.name)
                continue
            self._emit(Op.DUP)
            self._emit(field_op, f.name)
            self._compile_pattern_match(fv, next_label, depth + 1)

    def _compile_infinite(self, node: InfiniteStmt) -> None:
        if node.iterator is not None:
            return self._compile_infinite_iterator(node)
        prefix = f"l_{len(self._instrs)}"
        loop_label = f"{prefix}_loop"
        end_label = f"{prefix}_end"

        saved_break = self._loop_break
        saved_continue = self._loop_continue
        saved_loop_scope_depth = self._loop_scope_depth
        self._loop_break = end_label
        self._loop_continue = loop_label
        self._loop_scope_depth = self._scope_depth

        self._label(loop_label)
        if node.condition:
            self._compile_expr(node.condition)
            self._emit_jz(end_label)

        if node.body and isinstance(node.body, BlockStmt):
            self._compile_block(node.body)

        self._emit_jmp(loop_label)
        self._label(end_label)

        self._loop_break = saved_break
        self._loop_continue = saved_continue
        self._loop_scope_depth = saved_loop_scope_depth

    def _compile_infinite_iterator(self, node: InfiniteStmt) -> None:
        coll = node.iterator.collection
        if not (isinstance(coll, BinaryOp) and coll.op == ".."):
            return self._compile_infinite_collection(node)
        name = node.iterator.variable
        prefix = f"l_{len(self._instrs)}"
        loop_label = f"{prefix}_loop"
        end_label = f"{prefix}_end"
        asc_label = f"{prefix}_asc"
        body_label = f"{prefix}_body"
        inc_asc = f"{prefix}_inc_asc"
        inc_label = f"{prefix}_inc"

        dir_var = f"__iter_dir_{prefix}"
        self._compile_expr(coll.left)
        self._emit(Op.DECLARE, name)
        self._compile_expr(coll.left)
        self._compile_expr(coll.right)
        self._emit(Op.GT)
        self._emit(Op.DECLARE, dir_var)

        saved_break = self._loop_break
        saved_continue = self._loop_continue
        saved_loop_scope_depth = self._loop_scope_depth
        self._loop_break = end_label
        self._loop_continue = inc_label
        self._loop_scope_depth = self._scope_depth

        self._label(loop_label)
        self._emit(Op.LOAD, dir_var)
        self._emit_jz(asc_label)
        self._emit(Op.LOAD, name)
        self._compile_expr(coll.right)
        self._emit(Op.LT)
        self._emit_jnz(end_label)
        self._emit_jmp(body_label)
        self._label(asc_label)
        self._emit(Op.LOAD, name)
        self._compile_expr(coll.right)
        self._emit(Op.GT)
        self._emit_jnz(end_label)

        self._label(body_label)
        if node.body and isinstance(node.body, BlockStmt):
            self._compile_block(node.body)

        self._label(inc_label)
        self._emit(Op.LOAD, dir_var)
        self._emit_jz(inc_asc)
        self._emit(Op.LOAD, name)
        self._emit(Op.PUSH, 1)
        self._emit(Op.SUB)
        self._emit(Op.STORE, name)
        self._emit_jmp(loop_label)
        self._label(inc_asc)
        self._emit(Op.LOAD, name)
        self._emit(Op.PUSH, 1)
        self._emit(Op.ADD)
        self._emit(Op.STORE, name)
        self._emit_jmp(loop_label)
        self._label(end_label)
        self._loop_break = saved_break
        self._loop_continue = saved_continue
        self._loop_scope_depth = saved_loop_scope_depth

    def _compile_infinite_collection(self, node: InfiniteStmt) -> None:
        name = node.iterator.variable
        prefix = f"l_{len(self._instrs)}"
        loop_label = f"{prefix}_loop"
        end_label = f"{prefix}_end"

        self._compile_expr(node.iterator.collection)
        self._emit(Op.ITER_NEW)

        saved_break = self._loop_break
        saved_continue = self._loop_continue
        saved_loop_scope_depth = self._loop_scope_depth
        self._loop_break = end_label
        self._loop_continue = loop_label
        self._loop_scope_depth = self._scope_depth

        self._label(loop_label)
        self._emit(Op.ITER_NEXT)
        self._emit_jz(end_label)
        self._emit(Op.DECLARE, name)

        if node.body and isinstance(node.body, BlockStmt):
            self._compile_block(node.body)

        self._emit_jmp(loop_label)
        self._label(end_label)
        self._emit(Op.POP)

        self._loop_break = saved_break
        self._loop_continue = saved_continue
        self._loop_scope_depth = saved_loop_scope_depth

    def _is_exotic(self, node: ASTNode) -> bool:
        return (
            isinstance(node, (PtrRefExpr, PtrDerefExpr, PtrAssign, ExternDecl))
            or (isinstance(node, StorageDecl) and node.static)
            or (isinstance(node, CallExpr) and isinstance(node.callee, Identifier) and node.callee.name == "bounds")
        )

    def _raise_exotic(self, node: ASTNode) -> None:
        raise CompileError(f"simulação interpreter-only: '{type(node).__name__}' is not supported on the VM target")

    def _compile_expr(self, node: ASTNode | None) -> None:
        if node is None:
            raise CompileError("expression is None (unsupported node)")
        if self._is_exotic(node):
            self._raise_exotic(node)
        if isinstance(node, Literal):
            self._compile_literal(node)
        elif isinstance(node, Identifier):
            self._emit(Op.LOAD, node.name)
        elif isinstance(node, OwnershipExpr):
            if node.mut:
                self._emit(Op.MAKE_REF, node.target)
            else:
                self._emit(Op.LOAD, node.target)
        elif isinstance(node, SpawnExpr):
            self._compile_expr(node.operand)
        elif isinstance(node, AwaitExpr):
            self._compile_expr(node.operand)
        elif isinstance(node, BinaryOp):
            if node.op == "ensure":
                self._compile_expr(node.left)
                if isinstance(node.right, BlockStmt):
                    self._compile_block(node.right)
            else:
                old_in_bin = self._in_binary_op
                self._in_binary_op = True
                try:
                    self._compile_expr(node.left)
                    self._compile_expr(node.right)
                finally:
                    self._in_binary_op = old_in_bin
                self._emit(_binop_to_op(node.op))
                if node.op in ("+", "-", "*", "/f", "^e", "^r"):
                    self._emit_round(self._expr_type(node))
        elif isinstance(node, SpyExpr):
            if node.target:
                self._compile_expr(node.target)
                target_type = self._expr_type(node.target)
                left_name = ""
                if isinstance(node.target, BinaryOp) and isinstance(node.target.left, Identifier):
                    left_name = node.target.left.name
                meta = {
                    "target_kind": type(node.target).__name__,
                    "target_name": getattr(node.target, "name", ""),
                    "target_op": getattr(node.target, "op", ""),
                    "left_name": left_name,
                    "type_name": target_type,
                    "is_operand": self._in_binary_op,
                }
                self._emit(Op.SPY, meta)
        elif isinstance(node, UnaryOp):
            self._compile_expr(node.operand)
            if node.op == "-":
                self._emit(Op.NEG)
            elif node.op == "~":
                self._emit(Op.BNOT)
            else:
                self._emit(Op.NOT)
        elif isinstance(node, CastExpr):
            self._compile_expr(node.expr)
            self._emit(Op.CAST, node.target_type.name)
        elif isinstance(node, DataflowExpr):
            self._compile_dataflow(node)
        elif isinstance(node, CallExpr):
            self._compile_call(node)
        elif isinstance(node, StructInit):
            self._compile_struct_init(node)
        elif isinstance(node, FieldAccess):
            self._compile_expr(node.obj)
            self._emit(Op.FIELD_ACCESS, node.field)
        elif isinstance(node, InterpolatedString):
            for i, part in enumerate(node.parts):
                if isinstance(part, InterpolatedText):
                    self._emit(Op.PUSH, part.text)
                else:
                    self._compile_expr(part)
                    self._emit(Op.TO_STRING)
                if i > 0:
                    self._emit(Op.ADD)
        elif isinstance(node, InterpolatedText):
            self._emit(Op.PUSH, node.text)
        elif isinstance(node, EnumVariant):
            self._compile_enum_variant(node)
        elif isinstance(node, ComptimeExpr):
            if isinstance(node.body, BlockStmt) and node.body.body:
                self._emit(Op.SCOPE_ENTER)
                stmts = node.body.body
                for s in stmts[:-1]:
                    self._compile_statement(s)
                last = stmts[-1]
                if isinstance(last, ExpressionStmt):
                    self._compile_expr(last.expr)
                else:
                    self._compile_statement(last)
                self._emit(Op.SCOPE_EXIT)
            elif not isinstance(node.body, BlockStmt):
                self._compile_expr(node.body)
        elif isinstance(node, ShortCircuitBlock):
            self._compile_short_circuit(node)
        elif isinstance(node, MatchExpr):
            self._compile_match(node, keep_result=True)
        elif isinstance(node, ListLiteral):
            for i in node.items:
                self._compile_expr(i)
            self._emit(Op.MAKE_LIST, len(node.items))
        elif isinstance(node, SetLiteral):
            for i in node.items:
                self._compile_expr(i)
            self._emit(Op.MAKE_SET, len(node.items))
        elif isinstance(node, MapLiteral):
            for e in node.entries:
                if e.key:
                    self._emit(Op.PUSH, e.key.strip('"'))
                else:
                    self._compile_expr(e.key_expr)
                self._compile_expr(e.value)
            self._emit(Op.MAKE_MAP, len(node.entries))
        elif isinstance(node, RecordLiteral):
            for f in node.fields:
                self._emit(Op.PUSH, f.name)
                self._compile_expr(f.value)
            self._emit(Op.MAKE_RECORD, len(node.fields))
        elif isinstance(node, IndexAccess):
            tname = self._expr_type(node.obj)
            if tname.startswith("tensor"):
                dims = _tensor_dims(tname)
                if any(isinstance(i, SliceSpec) for i in node.indices):
                    spec = self._tensor_slice_spec(node.indices)
                    self._compile_expr(node.obj)
                    for ix in node.indices:
                        if not isinstance(ix, SliceSpec):
                            self._compile_expr(ix)
                    self._emit(Op.TSLICE, spec)
                    return
                if len(node.indices) == len(dims):
                    self._compile_expr(node.obj)
                    for idx in node.indices:
                        self._compile_expr(idx)
                    self._emit(Op.TGET, len(dims))
                    return
            self._compile_expr(node.obj)
            for idx in node.indices:
                if isinstance(idx, SliceSpec):
                    if idx.step is not None:
                        raise CompileError("slice com passo só é suportado em tensor")
                    if idx.start is not None:
                        self._compile_expr(idx.start)
                    else:
                        self._emit(Op.PUSH, None)
                    if idx.end is not None:
                        self._compile_expr(idx.end)
                    else:
                        self._emit(Op.PUSH, None)
                    self._emit(Op.SLICE)
                else:
                    self._compile_expr(idx)
                    self._emit(Op.INDEX)
        elif isinstance(node, IndexAssign):
            tname = self._expr_type(node.obj)
            dims = _tensor_dims(tname) if tname.startswith("tensor") else []
            if dims and len(node.indices) == len(dims) and not any(isinstance(i, SliceSpec) for i in node.indices):
                self._compile_expr(node.obj)
                for idx in node.indices:
                    self._compile_expr(idx)
                self._compile_expr(node.value)
                self._emit(Op.TSET, len(dims))
                return
            self._compile_expr(node.obj)
            for idx in node.indices[:-1]:
                self._compile_expr(idx)
                self._emit(Op.INDEX)
            self._compile_expr(node.indices[-1])
            self._compile_expr(node.value)
            self._emit(Op.INDEX_ASSIGN)
        else:
            raise CompileError(f"unsupported expression node '{type(node).__name__}'")

    def _compile_enum_variant(self, node: EnumVariant) -> None:
        edef = self._enums.get(node.enum_name)
        if edef is not None:
            tag = -1
            for i, m in enumerate(edef.members):
                if m.name == node.variant:
                    tag = i
                    break
            if tag < 0:
                raise CompileError(
                    f"variant '{node.variant}' not found in enum '{node.enum_name}'"
                )
            member = edef.members[tag]
            self._check_construction_fields(node.fields, member.fields,
                                            f"{node.enum_name}::{node.variant}")
            ordered = self._order_by_declaration(node.fields, member.fields)
            for f in ordered:
                self._compile_expr(f.value)
            self._emit(Op.ENUM_NEW, node.enum_name, node.variant, tag, [f.name for f in ordered])
            return
        fdsl_file = self._imports.get(node.enum_name)
        if fdsl_file is None:
            raise CompileError(f"agent '{node.enum_name}' not imported")
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
            raise CompileError(f"no agents found in import '{node.enum_name}'")
        op = None
        for o in agent.body.ops:
            if o.name == node.variant:
                op = o
                break
        if op is None:
            raise CompileError(f"op '{node.variant}' not found in agent '{node.enum_name}'")
        if op.body:
            for expr in op.body.expressions:
                self._compile_statement(expr)

    def _compile_literal(self, node: Literal) -> None:
        vt = node.value_type
        if vt == "int" or vt == "INT":
            self._emit(Op.PUSH, int(node.value))
        elif vt == "float" or vt == "FLOAT":
            self._emit(Op.PUSH, float(node.value))
        elif vt == "bool" or vt == "BOOL":
            self._emit(Op.PUSH, node.value.lower() == "true")
        elif vt == "complex" or vt == "COMPLEX":
            self._emit(Op.PUSH, _parse_complex_literal(node.value))
        elif vt == "datetime" or vt == "DATETIME":
            self._emit(Op.PUSH, _DT(_parse_iso_nanos(node.value)))
        elif vt == "char" or vt == "CHAR":
            self._emit(Op.PUSH, _Chr(ord(node.value)))
        else:
            self._emit(Op.PUSH, node.value)

    def _compile_dataflow(self, node: DataflowExpr) -> None:
        if node.op in ("split", "join"):
            self._compile_expr(node.left)
            self._compile_expr(node.right)
            self._emit(Op.SPLIT if node.op == "split" else Op.JOIN)
            return
        if node.op == "==>":
            self._compile_expr(node.left)
            self._emit(Op.STORE, "it")
            self._compile_expr(node.right)
            return
        right = node.right
        if isinstance(right, DataflowCastSink):
            self._compile_expr(node.left)
            self._emit(Op.CAST, right.target_type.name)
            return
        if isinstance(right, Identifier) and right.name in ("print", "println"):
            self._compile_expr(node.left)
            self._emit(Op.PRINTLN, 1)
            return
        if (isinstance(right, Identifier) and right.name == "spy") or isinstance(right, SpyExpr):
            self._compile_expr(node.left)
            meta = {
                "target_kind": "Dataflow",
                "origin": "preverTendencia",
                "is_dataflow": True,
            }
            self._emit(Op.SPY, meta)
            return
        if isinstance(right, Identifier) and right.name in self._function_names:
            self._compile_expr(node.left)
            self._emit(Op.CALL, 0)
            self._patch_at(f"f_{right.name}")
            return
        if isinstance(right, Identifier) and right.name == "keep":
            self._compile_expr(node.left)
            return
        if isinstance(right, CallExpr):
            self._compile_expr(node.left)
            self._compile_call(right)
            return
        raise CompileError(f"unsupported dataflow sink '{type(right).__name__}'")

    def _compile_call(self, node: CallExpr) -> None:
        name = _callee_name(node.callee)
        name = self._op_aliases.get(name, name)
        for a in node.args:
            self._compile_expr(a)
        if name == "print":
            self._emit(Op.PRINT, len(node.args))
        elif name == "println":
            self._emit(Op.PRINTLN, len(node.args))
        elif name in self._function_names:
            self._emit(Op.CALL, 0)
            self._patch_at(f"f_{name}")
        elif name in BUILTIN_NAMES:
            self._emit(Op.CALL, name)
        elif name in self._op_names:
            self._emit(Op.CALL, 0)
            self._patch_at(f"f_{name}")
        else:
            self._emit(Op.CALL, name)

    def _compile_function(self, func: FunctionDef) -> None:
        self._label(f"f_{func.name}")
        self._emit(Op.SCOPE_ENTER)
        for p in reversed(func.params):
            self._emit(Op.DECLARE, p.name)
        if func.body:
            for i, stmt in enumerate(func.body.body):
                is_tail = i == len(func.body.body) - 1
                keep = is_tail and isinstance(stmt, ExpressionStmt) and isinstance(stmt.expr, ShortCircuitBlock)
                self._compile_statement(stmt, keep_result=keep)
            tail = func.body.body[-1] if func.body.body else None
            if isinstance(tail, StorageDecl) and tail.items:
                last_item = tail.items[-1]
                if isinstance(last_item.initializer, ShortCircuitBlock):
                    self._emit(Op.LOAD, last_item.name)
            elif isinstance(tail, VariableReassign) and isinstance(tail.value, ShortCircuitBlock) and (not tail.op or tail.op == "="):
                self._emit(Op.LOAD, tail.name)
        self._emit(Op.SCOPE_EXIT)
        self._emit(Op.RET)

    def _compile_op(self, op) -> None:
        old_in_op = self._in_op
        self._in_op = True
        try:
            self._label(f"f_{op.name}")
            self._emit(Op.SCOPE_ENTER)
            for p in reversed(op.params):
                self._emit(Op.DECLARE, p.name)
            if op.body:
                for expr in op.body.expressions:
                    self._compile_statement(expr)
            self._emit(Op.SCOPE_EXIT)
            self._emit(Op.RET)
        finally:
            self._in_op = old_in_op

    def _compile_short_circuit(self, node: ShortCircuitBlock, bind_name: str | None = None, declare: bool = False) -> None:
        nice_label = f"sc_n_{len(self._instrs)}"
        end_label = f"sc_end_{len(self._instrs)}"

        self._compile_expr(node.expr)
        if bind_name is not None:
            self._emit(Op.DUP)
            self._emit(Op.DECLARE if declare else Op.STORE, bind_name)
        self._emit(Op.IS_FAIL)
        self._emit_jz(nice_label)

        self._compile_sc_arm(node.fail_arm)
        self._emit_jmp(end_label)

        self._label(nice_label)
        self._compile_sc_arm(node.nice_arm)

        self._label(end_label)
        if bind_name is not None:
            self._emit(Op.DECLARE if declare else Op.STORE, bind_name)

    def _compile_sc_arm(self, arm: ShortCircuitArm | None) -> None:
        if arm is None:
            raise CompileError("short-circuit block requires both 'fail' and 'nice' arms")
        self._compile_expr(Identifier(name=arm.value))
        if arm.message:
            self._compile_expr(arm.message)
        self._emit(Op.EMIT, arm.status)

    def _compile_struct_init(self, node: StructInit) -> None:
        sdef = self._structs.get(node.name)
        if sdef is not None:
            self._check_construction_fields(node.fields, sdef.fields, node.name)
            ordered = self._order_by_declaration(node.fields, sdef.fields)
        else:
            ordered = node.fields
        for f in ordered:
            self._compile_expr(f.value)
        self._emit(Op.MAKE_STRUCT, node.name, [f.name for f in ordered])

    def _order_by_declaration(self, given: list[InitField], declared: list) -> list[InitField]:
        order = {f.name: i for i, f in enumerate(declared)}
        return sorted(given, key=lambda f: order.get(f.name, len(order)))

    def _check_construction_fields(self, given: list[InitField], declared: list, owner: str) -> None:
        given_names = {f.name for f in given}
        declared_names = {f.name for f in declared}
        unknown = given_names - declared_names
        if unknown:
            raise CompileError(f"unknown field '{sorted(unknown)[0]}' for '{owner}'")
        missing = declared_names - given_names
        if missing:
            raise CompileError(f"missing field '{sorted(missing)[0]}' for '{owner}'")


def _binop_to_op(op: str) -> Op:
    return {
        "+": Op.ADD, "-": Op.SUB, "*": Op.MUL,
        "/i": Op.IDIV, "/f": Op.DIV, "/r": Op.REM,
        "^e": Op.POW_E, "^r": Op.POW_R,
        "&": Op.BAND, "|": Op.BOR, "^": Op.BXOR,
        "<<": Op.BSHL, ">>": Op.BSHR, ">>>": Op.BSHRU,
        "==": Op.EQ, "!=": Op.NE,
        "<": Op.LT, "<=": Op.LE, ">": Op.GT, ">=": Op.GE,
        "and": Op.AND, "or": Op.OR,
        "in": Op.IN,
    }.get(op, Op.ADD)
