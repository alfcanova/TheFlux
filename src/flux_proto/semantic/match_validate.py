from __future__ import annotations

from dataclasses import fields as dataclass_fields

from flux_proto.parser.ast import (
    ASTNode,
    BlockStmt,
    EnumDef,
    EnumVariant,
    EnumVariantPattern,
    FunctionDef,
    Literal,
    MatchExpr,
    MatchStmt,
    Parameter,
    StorageDecl,
    WildcardPattern,
)
from flux_proto.semantic.diagnostic import Diagnostic, Severity


def validate_match(ast: ASTNode) -> list[Diagnostic]:
    diags: list[Diagnostic] = []
    enums = _declared_enums(ast)
    var_types = _variable_types(ast)
    for node in _walk(ast):
        if isinstance(node, (MatchStmt, MatchExpr)):
            _check_match(diags, enums, var_types, node)
    return diags


def _declared_enums(ast: ASTNode) -> dict[str, EnumDef]:
    enums: dict[str, EnumDef] = {}
    for node in _walk(ast):
        if isinstance(node, EnumDef):
            enums[node.name] = node
    return enums


def _variable_types(ast: ASTNode) -> dict[str, str]:
    var_types: dict[str, str] = {}
    for node in _walk(ast):
        if isinstance(node, StorageDecl):
            for item in node.items:
                t = _enum_of_type_ref(item.type_ref)
                if t is None and isinstance(item.initializer, EnumVariant):
                    t = item.initializer.enum_name
                if t is not None:
                    var_types[item.name] = t
        elif isinstance(node, FunctionDef):
            for p in node.params:
                t = _enum_of_type_ref(p.type_ref)
                if t is not None:
                    var_types[p.name] = t
    return var_types


def _enum_of_type_ref(type_ref: ASTNode | None) -> str | None:
    if type_ref is None:
        return None
    name = getattr(type_ref, "name", "")
    return name if name else None


def _subject_enum(node: MatchExpr | MatchStmt, var_types: dict[str, str]) -> str | None:
    subj = node.subject
    name = getattr(subj, "name", None)
    if name is None:
        return None
    return var_types.get(name)


def _check_match(
    diags: list[Diagnostic],
    enums: dict[str, EnumDef],
    var_types: dict[str, str],
    node: MatchExpr | MatchStmt,
) -> None:
    subj_enum = _subject_enum(node, var_types)
    covered: set[str] = set()
    saw_wildcard = False
    for arm in node.arms:
        pat = arm.pattern
        if saw_wildcard:
            diags.append(_err(
                "MAT002",
                f"unreachable arm in match: arm after a wildcard arm can never be selected",
            ))
            continue
        if (
            isinstance(pat, EnumVariantPattern)
            and subj_enum is not None
            and pat.enum == subj_enum
        ):
            if pat.variant in covered and arm.guard is None:
                diags.append(_err(
                    "MAT002",
                    f"unreachable arm in match: variant '{subj_enum}::{pat.variant}' already covered by an earlier arm",
                ))
            if arm.guard is None:
                covered.add(pat.variant)
        if isinstance(pat, WildcardPattern) and arm.guard is None:
            saw_wildcard = True
    if subj_enum is not None and not saw_wildcard:
        edef = enums.get(subj_enum)
        if edef is not None:
            missing = {m.name for m in edef.members} - covered
            if missing:
                diags.append(_err(
                    "MAT001",
                    f"match not exhaustive for enum '{subj_enum}': missing variant(s) {sorted(missing)}",
                ))
    _check_arm_types(diags, node)


def _check_arm_types(diags: list[Diagnostic], node: MatchExpr | MatchStmt) -> None:
    wtypes: set[str] = set()
    for arm in node.arms:
        b = arm.body
        if isinstance(b, Literal):
            wtypes.add(b.value_type)
        elif isinstance(b, BlockStmt):
            last = _last_literal(b)
            if last is not None:
                wtypes.add(last)
    if len(wtypes) > 1:
        diags.append(_err(
            "MAT003",
            f"match arms must produce the same type, found {sorted(wtypes)}",
        ))


def _last_literal(block: BlockStmt) -> str | None:
    for stmt in reversed(block.body):
        expr = getattr(stmt, "expr", None)
        if isinstance(expr, Literal):
            return expr.value_type
    return None


def _walk(node: ASTNode) -> list[ASTNode]:
    result: list[ASTNode] = [node]
    for f in dataclass_fields(node):
        v = getattr(node, f.name)
        if isinstance(v, ASTNode):
            result.extend(_walk(v))
        elif isinstance(v, list):
            for item in v:
                if isinstance(item, ASTNode):
                    result.extend(_walk(item))
    return result


def _err(code: str, message: str) -> Diagnostic:
    return Diagnostic(code=code, severity=Severity.ERROR, line=0, column=0, message=message)
