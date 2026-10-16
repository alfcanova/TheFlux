from __future__ import annotations

from __future__ import annotations

from dataclasses import fields as dataclass_fields

from flux_proto.parser.ast import (
    ASTNode, FluxProgram, StorageDecl, StorageItem, PrimitiveType,
    StructDef, FieldAssign, VariableReassign,
)
from flux_proto.semantic.diagnostic import Diagnostic, Severity
from flux_proto.semantic.symbol_table import SymbolTable


_COLLECTION_PREFIXES = ("list of ", "set of ", "map of ", "tensor of ")


def validate_mutability(st: SymbolTable, ast: ASTNode) -> list[Diagnostic]:
    diags: list[Diagnostic] = []
    _check_symbols(st, diags)
    _check_ast_collections(ast, st, diags)
    _check_struct_field_assigns(ast, st, diags)
    _check_reassigns(ast, st, diags)
    return diags


def _check_reassigns(ast: ASTNode, st: SymbolTable, diags: list[Diagnostic]) -> None:
    storage_mutability: dict[str, bool] = {}
    for sd in _walk_nodes(ast, StorageDecl):
        for item in sd.items:
            storage_mutability[item.name] = item.mutable

    for ra in _walk_nodes(ast, VariableReassign):
        is_mut = storage_mutability.get(ra.name)
        sym = st.resolve(ra.name)
        if is_mut is None and sym is None:
            from flux_proto.diagnostics.catalog import create_diagnostic
            diags.append(
                create_diagnostic(
                    code_or_mnemonic="SEM303",
                    line=getattr(ra, "line", 0),
                    column=getattr(ra, "column", 0),
                    custom_msg=f"identificador não declarado: a variável '{ra.name}' precisa ser declarada com 'mut' ou 'imut'",
                )
            )
            continue
        if is_mut is False:
            from flux_proto.diagnostics.catalog import create_diagnostic
            diags.append(
                create_diagnostic(
                    code_or_mnemonic="OWN501",
                    line=getattr(ra, "line", 0),
                    column=getattr(ra, "column", 0),
                    custom_msg=f"cannot reassign immutable variable '{ra.name}'",
                )
            )
            continue
        if sym is not None and not sym.mutable:
            from flux_proto.diagnostics.catalog import create_diagnostic
            diags.append(
                create_diagnostic(
                    code_or_mnemonic="OWN501",
                    line=getattr(ra, "line", 0),
                    column=getattr(ra, "column", 0),
                    custom_msg=f"cannot reassign immutable variable '{ra.name}'",
                )
            )


def _check_struct_field_assigns(ast: ASTNode, st: SymbolTable, diags: list[Diagnostic]) -> None:
    structs = {s.name: s for s in _walk_nodes(ast, StructDef)}
    for fdsl in getattr(ast, "imports", {}).values():
        if fdsl is None:
            continue
        for s in getattr(fdsl, "structs", []):
            structs[s.name] = s
    var_types: dict[str, str] = {}
    for sd in _walk_nodes(ast, StorageDecl):
        for item in sd.items:
            tname = getattr(getattr(item, "type_ref", None), "name", None)
            if tname:
                var_types[item.name] = tname
    for fa in _walk_nodes(ast, FieldAssign):
        sdef = structs.get(var_types.get(fa.owner, ""))
        if sdef is None:
            continue
        fdef = next((f for f in sdef.fields if f.name == fa.field), None)
        if fdef is not None and not fdef.mutable:
            from flux_proto.diagnostics.catalog import create_diagnostic
            diags.append(
                create_diagnostic(
                    code_or_mnemonic="OWN502",
                    line=getattr(fa, "line", 0),
                    column=getattr(fa, "column", 0),
                    custom_msg=f"cannot assign to immutable field '{fa.field}' of struct '{sdef.name}'",
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


def _check_symbols(st: SymbolTable, diags: list[Diagnostic]) -> None:
    for sym in st.all_symbols():
        if not sym.mutable and not sym.initialized:
            from flux_proto.diagnostics.catalog import create_diagnostic
            diags.append(
                create_diagnostic(
                    code_or_mnemonic="SEM305",
                    line=getattr(sym.decl_node, "line", 0),
                    column=getattr(sym.decl_node, "column", 0),
                    custom_msg=f"immutable declaration '{sym.name}' requires an initializer",
                )
            )


def _check_ast_collections(ast: ASTNode, st: SymbolTable, diags: list[Diagnostic]) -> None:
    for sd in _walk_nodes(ast, StorageDecl):
        _check_storage_decl(sd, st, diags)


def _check_storage_decl(sd: StorageDecl, st: SymbolTable, diags: list[Diagnostic]) -> None:
    for item in sd.items:
        if not item.mutable and item.type_ref is not None:
            type_name = _type_name(item.type_ref)
            if type_name and type_name.startswith(_COLLECTION_PREFIXES):
                from flux_proto.diagnostics.catalog import create_diagnostic
                diags.append(
                    create_diagnostic(
                        code_or_mnemonic="OWN505",
                        line=getattr(item, "line", 0),
                        column=getattr(item, "column", 0),
                        custom_msg=f"immutable declaration '{item.name}' cannot have collection type '{type_name}'",
                    )
                )


def _type_name(node: ASTNode) -> str | None:
    if isinstance(node, PrimitiveType):
        return node.name
    return getattr(node, "name", None)
