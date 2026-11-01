from __future__ import annotations

from dataclasses import fields as dataclass_fields

from flux_proto.parser.ast import ASTNode, MapLiteral, MapEntry
from flux_proto.semantic.diagnostic import Diagnostic, Severity
from flux_proto.semantic.types import _BUILTIN_TYPE_NAMES


_NUMERIC_TYPES = {
    "int8", "int16", "int32", "int64",
    "uint8", "uint16", "uint32", "uint64",
    "float16", "float32", "float64",
}

_COLLECTION_PREFIXES = ("list of ", "set of ", "map of ", "tensor")


def check_map_literals(ast: ASTNode) -> list[Diagnostic]:
    diags: list[Diagnostic] = []
    for ml in _walk_nodes(ast, MapLiteral):
        for entry in ml.entries:
            _check_entry(entry, diags)
    return diags


def _check_entry(entry: MapEntry, diags: list[Diagnostic]) -> None:
    if entry.key_type is not None:
        _check_key_type(entry, diags)
    if entry.value_type is not None:
        _check_value_type(entry, diags)


def _check_key_type(entry: MapEntry, diags: list[Diagnostic]) -> None:
    kt = getattr(entry.key_type, "name", "") or ""
    if kt in _NUMERIC_TYPES or kt == "string":
        return
    diags.append(
        Diagnostic(
            code="SEM001",
            severity=Severity.ERROR,
            line=0,
            column=0,
            message=f"invalid map key type '{kt}': expected 'string' or a numeric type",
        )
    )


def _check_value_type(entry: MapEntry, diags: list[Diagnostic]) -> None:
    vt = getattr(entry.value_type, "name", "") or ""
    if vt in _BUILTIN_TYPE_NAMES:
        return
    if vt.startswith(_COLLECTION_PREFIXES):
        return
    diags.append(
        Diagnostic(
            code="SEM001",
            severity=Severity.ERROR,
            line=0,
            column=0,
            message=f"unknown map value type '{vt}' in entry for key '{entry.key}'",
        )
    )


def _walk_nodes(node: ASTNode, kind: type) -> list:
    result = []
    if isinstance(node, kind):
        result.append(node)
    for f in dataclass_fields(node):
        v = getattr(node, f.name)
        if isinstance(v, ASTNode):
            result.extend(_walk_nodes(v, kind))
        elif isinstance(v, list):
            for item in v:
                if isinstance(item, ASTNode):
                    result.extend(_walk_nodes(item, kind))
    return result