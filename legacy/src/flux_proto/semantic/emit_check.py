from __future__ import annotations

from dataclasses import fields

from flux_proto.parser.ast import (
    FunctionDef, BlockStmt, EmitStmt, ExpressionStmt,
    RouteStmt, RouteArm, MatchStmt, MatchArm, MatchExpr,
    InfiniteStmt, InfiniteIterator, BreakStmt, ContinueStmt, UnsafeStmt,
    StorageDecl, VariableReassign, FieldAccess,
    Identifier, CallExpr, StructDef, EnumVariant,
    ShortCircuitBlock, ShortCircuitArm,
    ASTNode,
)
from flux_proto.semantic.diagnostic import Diagnostic, Severity

_RESULT_FIELDS = {"sta", "val", "msg"}


def check_emit_terminals(functions: list[FunctionDef]) -> list[Diagnostic]:
    diags: list[Diagnostic] = []
    for func in functions:
        if func.body is None:
            if func.return_type is not None:
                diags.append(_diag("SEM001", _line_of(func), _col_of(func),
                                   f"function '{func.name}' has return type but no body"))
            continue

        _emit_integrity(func, diags)

        if not _path_emits(func.body):
            if func.return_type is not None:
                diags.append(_error(
                    "EMC100", _line_of(func), _col_of(func),
                    f"function '{func.name}' has code path without emit",
                ))
            continue

        if func.return_type is None:
            diags.append(_error(
                "EMC103", _line_of(func), _col_of(func),
                f"function '{func.name}' emits but declares no return type ('as <tipo>' required)",
            ))
    return diags


def _emit_nodes(node: ASTNode | None) -> list[EmitStmt]:
    found: list[EmitStmt] = []
    if node is None:
        return found
    if isinstance(node, EmitStmt):
        return [node]
    for child in _children(node):
        found.extend(_emit_nodes(child))
    return found


def _children(node: ASTNode) -> list[ASTNode]:
    kids: list[ASTNode] = []
    for f in fields(node):
        val = getattr(node, f.name)
        if isinstance(val, ASTNode):
            kids.append(val)
        elif isinstance(val, list):
            kids.extend(v for v in val if isinstance(v, ASTNode))
    return kids


def _walk(node: ASTNode | None, fn) -> None:
    if node is None:
        return
    fn(node)
    for child in _children(node):
        _walk(child, fn)


def _declared_names(func: FunctionDef) -> set[str]:
    names: set[str] = {p.name for p in func.params}
    if func.body is None:
        return names

    def collect(n: ASTNode) -> None:
        if isinstance(n, StorageDecl):
            for it in n.items:
                names.add(it.name)
        elif isinstance(n, VariableReassign):
            names.add(n.name)
        elif isinstance(n, InfiniteIterator):
            if n.variable:
                names.add(n.variable)

    _walk(func.body, collect)
    return names


def _emit_integrity(func: FunctionDef, diags: list[Diagnostic]) -> None:
    if func.body is None:
        return
    declared = _declared_names(func)
    for emit in _emit_nodes(func.body):
        if emit.status not in ("nice", "fail"):
            diags.append(_error(
                "EMC101", _line_of(emit), _col_of(emit),
                "emit status must be the keyword 'nice' or 'fail'",
            ))
        if emit.value_expr is not None:
            diags.append(_error(
                "EMC101", _line_of(emit), _col_of(emit),
                "emit accepts only a single declared identifier as value, expressions are not allowed",
            ))
        elif not emit.value:
            diags.append(_error(
                "EMC101", _line_of(emit), _col_of(emit),
                "emit requires a single value identifier",
            ))
        elif emit.value not in declared:
            diags.append(_error(
                "EMC104", _line_of(emit), _col_of(emit),
                f"emit value '{emit.value}' is not declared",
            ))
        if emit.message is None:
            diags.append(_error(
                "EMC102", _line_of(emit), _col_of(emit),
                "emit requires a message (string literal or interpolated string)",
            ))
    for arm in _sc_arms(func.body):
        if not arm.value:
            diags.append(_error(
                "EMC101", _line_of(arm), _col_of(arm),
                "short-circuit arm requires a single value identifier",
            ))
        elif arm.value not in declared:
            diags.append(_error(
                "EMC104", _line_of(arm), _col_of(arm),
                f"emit value '{arm.value}' is not declared",
            ))
        if arm.message is None:
            diags.append(_error(
                "EMC102", _line_of(arm), _col_of(arm),
                "short-circuit arm requires a message (string literal or interpolated string)",
            ))


def _sc_arms(node: ASTNode | None) -> list[ShortCircuitArm]:
    found: list[ShortCircuitArm] = []
    if node is None:
        return found
    if isinstance(node, ShortCircuitBlock):
        if node.fail_arm is not None:
            found.append(node.fail_arm)
        if node.nice_arm is not None:
            found.append(node.nice_arm)
        return found
    for child in _children(node):
        found.extend(_sc_arms(child))
    return found


def check_result_field_access(root: ASTNode) -> list[Diagnostic]:
    result_vars = _collect_result_vars(root)
    user_fields = _collect_user_field_names(root)
    diags: list[Diagnostic] = []

    def check(n: ASTNode) -> None:
        if not isinstance(n, FieldAccess):
            return
        if n.field not in _RESULT_FIELDS:
            return
        if _is_result_value(n.obj, result_vars):
            return
        if n.field in user_fields:
            return
        diags.append(_error(
            "EMC105", _line_of(n), _col_of(n),
            f"field '{n.field}' is only available on a function result (sta/val/msg)",
        ))

    _walk(root, check)
    return diags


def _collect_user_field_names(root: ASTNode) -> set[str]:
    names: set[str] = set()

    def collect(n: ASTNode) -> None:
        if isinstance(n, (StructDef, EnumVariant)):
            for f in getattr(n, "fields", []):
                fname = getattr(f, "name", "")
                if fname:
                    names.add(fname)

    _walk(root, collect)
    return names


def _is_result_value(obj: ASTNode | None, result_vars: set[str]) -> bool:
    if isinstance(obj, CallExpr):
        return True
    if isinstance(obj, FieldAccess):
        return True
    if isinstance(obj, Identifier):
        return obj.name in result_vars
    return False


def _collect_result_vars(root: ASTNode) -> set[str]:
    names: set[str] = set()

    def collect(n: ASTNode) -> None:
        if isinstance(n, StorageDecl):
            for it in n.items:
                if it.initializer and isinstance(it.initializer, CallExpr):
                    names.add(it.name)
        elif isinstance(n, VariableReassign):
            if isinstance(n.value, CallExpr):
                names.add(n.name)

    _walk(root, collect)
    return names


# --- caminhos terminais (preservado) ---

def _path_emits(node: ASTNode | None) -> bool:
    if node is None:
        return False

    if isinstance(node, EmitStmt):
        return True

    if isinstance(node, BlockStmt):
        return _block_emits(node.body)

    if isinstance(node, RouteStmt):
        return _route_emits(node.arms)

    if isinstance(node, MatchStmt):
        return _arms_emit(node.arms)

    if isinstance(node, MatchExpr):
        return _arms_emit(node.arms)

    if isinstance(node, InfiniteStmt):
        return True

    if isinstance(node, (BreakStmt, ContinueStmt)):
        return True

    if isinstance(node, UnsafeStmt):
        return _path_emits(node.body)

    if isinstance(node, ExpressionStmt):
        return isinstance(node.expr, (ShortCircuitBlock, MatchExpr))

    if isinstance(node, StorageDecl):
        return any(
            it.initializer is not None and isinstance(it.initializer, ShortCircuitBlock)
            for it in node.items
        )

    if isinstance(node, VariableReassign):
        return isinstance(node.value, ShortCircuitBlock) and (node.op is None or node.op == "=")

    return False


def _block_emits(stmts: list[ASTNode]) -> bool:
    for stmt in stmts:
        if _path_emits(stmt):
            return True
    return False


def _route_emits(arms: list[RouteArm]) -> bool:
    if not arms:
        return False
    return all(_arm_emits(arm) for arm in arms)


def _arms_emit(arms: list[MatchArm]) -> bool:
    if not arms:
        return False
    return all(_arm_emits(arm) for arm in arms)


def _arm_emits(arm: RouteArm | MatchArm) -> bool:
    return _path_emits(arm.body)


def _error(code: str, line: int, column: int, message: str) -> Diagnostic:
    return Diagnostic(code=code, severity=Severity.ERROR, line=line, column=column, message=message)


def _line_of(node: ASTNode) -> int:
    return getattr(node, "line", 0)


def _col_of(node: ASTNode) -> int:
    return getattr(node, "column", 0)