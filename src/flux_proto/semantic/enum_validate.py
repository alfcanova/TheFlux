from __future__ import annotations

import re
from dataclasses import fields as dataclass_fields

from flux_proto.parser.ast import (
    ASTNode,
    EnumDef,
    EnumVariant,
    EnumVariantPattern,
    StructDef,
    StructInit,
    StructPattern,
    IdentifierPattern,
    LiteralPattern,
    WildcardPattern,
)
from flux_proto.semantic.diagnostic import Diagnostic, Severity

_PASCAL = re.compile(r"^[A-Z][a-zA-Z0-9]*$")
_SNAKE = re.compile(r"^[a-z][a-z0-9]*(_[a-z0-9]+)*$")
_SCREAMING = re.compile(r"^[A-Z][A-Z0-9]*(_[A-Z0-9]+)*$")


def validate_enums(ast: ASTNode) -> list[Diagnostic]:
    diags: list[Diagnostic] = []
    enums, structs = _declared_types(ast)

    for name, edef in enums.items():
        if not _PASCAL.match(name):
            diags.append(_sug(f"enum name '{name}' should use PascalCase"))
        for m in edef.members:
            if not _PASCAL.match(m.name):
                diags.append(_sug(f"variant '{m.name}' of enum '{name}' should use PascalCase"))
            for f in m.fields:
                if not _SNAKE.match(f.name):
                    diags.append(_sug(f"field '{f.name}' of variant '{m.name}' should use snake_case"))

    for name, sdef in structs.items():
        if not _PASCAL.match(name):
            diags.append(_sug(f"struct name '{name}' should use PascalCase"))
        for f in sdef.fields:
            if f.mutable:
                if not _SNAKE.match(f.name):
                    diags.append(_sug(f"mutable field '{f.name}' of struct '{name}' should use snake_case"))
            else:
                if not _SCREAMING.match(f.name):
                    diags.append(_sug(f"immutable field '{f.name}' of struct '{name}' should use SCREAMING_SNAKE_CASE"))

    for node in _walk(ast):
        if isinstance(node, EnumVariant):
            _check_enum_construction(diags, enums, node)
        elif isinstance(node, StructInit):
            _check_struct_construction(diags, structs, node)
        elif isinstance(node, EnumVariantPattern):
            _check_enum_pattern(diags, enums, node)
        elif isinstance(node, StructPattern):
            _check_struct_pattern(diags, structs, node)
    return diags


def _declared_types(ast: ASTNode) -> tuple[dict[str, EnumDef], dict[str, StructDef]]:
    enums: dict[str, EnumDef] = {}
    structs: dict[str, StructDef] = {}
    for node in _walk(ast):
        if isinstance(node, EnumDef):
            enums[node.name] = node
        elif isinstance(node, StructDef):
            structs[node.name] = node
    for fdsl in getattr(ast, "imports", {}).values():
        if fdsl is None:
            continue
        for s in getattr(fdsl, "structs", []):
            structs[s.name] = s
        for e in getattr(fdsl, "enums", []):
            enums[e.name] = e
    return enums, structs


def _check_enum_construction(diags: list[Diagnostic], enums: dict[str, EnumDef], node: EnumVariant) -> None:
    edef = enums.get(node.enum_name)
    if edef is None:
        return
    member = next((m for m in edef.members if m.name == node.variant), None)
    if member is None:
        diags.append(_err(
            f"variant '{node.variant}' not found in enum '{node.enum_name}'"
        ))
        return
    declared = {f.name for f in member.fields}
    given = {f.name for f in node.fields}
    for name in sorted(given - declared):
        diags.append(_err(
            f"unknown field '{name}' for variant '{node.enum_name}::{node.variant}'"
        ))
    for name in sorted(declared - given):
        diags.append(_err(
            f"missing field '{name}' for variant '{node.enum_name}::{node.variant}'"
        ))


def _check_struct_construction(diags: list[Diagnostic], structs: dict, node: StructInit) -> None:
    sdef = structs.get(node.name)
    if sdef is None:
        return
    declared = {f.name for f in sdef.fields}
    given = {f.name for f in node.fields}
    for name in sorted(given - declared):
        diags.append(_err(f"unknown field '{name}' for struct '{node.name}'"))
    for name in sorted(declared - given):
        diags.append(_err(f"missing field '{name}' for struct '{node.name}'"))


def _check_enum_pattern(diags: list[Diagnostic], enums: dict[str, EnumDef], node: EnumVariantPattern) -> None:
    edef = enums.get(node.enum)
    if edef is None:
        diags.append(_err(f"enum '{node.enum}' not found in match pattern"))
        return
    member = next((m for m in edef.members if m.name == node.variant), None)
    if member is None:
        diags.append(_err(f"variant '{node.variant}' not found in enum '{node.enum}'"))
        return
    declared = {f.name for f in member.fields}
    for f in node.fields:
        if f.name not in declared:
            diags.append(_err(
                f"unknown field '{f.name}' for variant '{node.enum}::{node.variant}' in match pattern"
            ))


def _check_struct_pattern(diags: list[Diagnostic], structs: dict, node: StructPattern) -> None:
    sdef = structs.get(node.name)
    if sdef is None:
        diags.append(_err(f"struct '{node.name}' not found in match pattern"))
        return
    declared = {f.name for f in sdef.fields}
    for f in node.fields:
        if f.name not in declared:
            diags.append(_err(
                f"unknown field '{f.name}' for struct '{node.name}' in match pattern"
            ))


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


def _err(message: str) -> Diagnostic:
    return Diagnostic(code="ENM001", severity=Severity.ERROR, line=0, column=0, message=message)


def _sug(message: str) -> Diagnostic:
    return Diagnostic(code="SUG", severity=Severity.SUGGESTION, line=0, column=0, message=message)
