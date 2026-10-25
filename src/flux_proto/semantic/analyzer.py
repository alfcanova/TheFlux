from __future__ import annotations

from dataclasses import dataclass, fields
from typing import Any

from flux_proto.parser.ast import (
    ASTNode,
    FluxProgram,
    FdslFile,
    FunctionDef,
    BlockStmt,
    StorageDecl,
    StorageItem,
    StructDef,
    EnumDef,
    ContractDef,
    AgentDef,
    ImplDef,
    MacroDef,
    UseDecl,
    UseAgent,
    UseOp,
    UseGroup,
    Identifier,
    OpDecl,
    Parameter,
    UnsafeStmt,
    PtrRefExpr,
    PtrDerefExpr,
    PtrAssign,
    ExternDecl,
    CallExpr,
)
from flux_proto.semantic.ast_decorator import ASTDecorator
from flux_proto.semantic.capitalization import validate_capitalization
from flux_proto.semantic.diagnostic import Diagnostic
from flux_proto.semantic.mutability import validate_mutability
from flux_proto.semantic.symbol_table import (
    CapitalizationKind,
    ScopeKind,
    SymbolKind,
    SymbolTable,
)
from flux_proto.semantic.contracts import verify_contract_agent
from flux_proto.semantic.emit_check import check_emit_terminals, check_result_field_access
from flux_proto.semantic.enum_validate import validate_enums
from flux_proto.semantic.match_validate import validate_match
from flux_proto.semantic.map_literals import check_map_literals
from flux_proto.semantic.ownership import OwnershipTracker
from flux_proto.semantic.storage_types import check_storage_types
from flux_proto.semantic.types import TypeChecker


class SemanticError(Exception):
    pass


@dataclass
class SemanticResult:
    decorated_ast: Any = None
    diagnostics: list = None


def analyze(ast: ASTNode, file_path: str = "<unknown>") -> SemanticResult:
    from flux_proto.macro.expander import expand_macros
    if isinstance(ast, FluxProgram):
        ast = expand_macros(ast)
    decorator = ASTDecorator()
    st = SymbolTable()
    all_diags: list[Diagnostic] = []

    _build_symbol_table(ast, st, all_diags)

    cap_diags = validate_capitalization(st)
    all_diags.extend(cap_diags)

    mut_diags = validate_mutability(st, ast)
    all_diags.extend(mut_diags)

    storage_diags = check_storage_types(ast, st)
    all_diags.extend(storage_diags)

    map_diags = check_map_literals(ast)
    all_diags.extend(map_diags)

    tc = TypeChecker(symbol_table=st, decorator=decorator)
    _infer_types(ast, tc)

    all_diags.extend(tc.diagnostics())

    own_diags = _track_ownership(ast, st)
    all_diags.extend(own_diags)

    unsafe_diags = _check_unsafe_exotic(ast)
    all_diags.extend(unsafe_diags)

    contract_diags = _check_contracts(ast, st)
    all_diags.extend(contract_diags)

    emit_diags = _check_emit(ast)
    all_diags.extend(emit_diags)

    enum_diags = validate_enums(ast)
    all_diags.extend(enum_diags)

    match_diags = validate_match(ast)
    all_diags.extend(match_diags)

    return SemanticResult(decorated_ast=ast, diagnostics=all_diags)


def _build_symbol_table(ast: ASTNode, st: SymbolTable, diags: list[Diagnostic]) -> None:
    if isinstance(ast, FluxProgram):
        seen_imports = set()
        for imp in getattr(ast, "imports", {}).values():
            if imp is None or id(imp) in seen_imports:
                continue
            seen_imports.add(id(imp))
            for s in getattr(imp, "structs", []):
                _declare_struct(s, st, diags)
            for e in getattr(imp, "enums", []):
                _declare_enum(e, st, diags)
        for sd in ast.storages:
            _declare_storage_items(sd, st, diags)
        for s in ast.structs:
            _declare_struct(s, st, diags)
        for e in ast.enums:
            _declare_enum(e, st, diags)
        for c in ast.contracts:
            _declare_contract(c, st, diags)
        for f in ast.functions:
            _process_function_signature(f, st, diags)
            if f.body:
                st.enter_scope(ScopeKind.FUNCTION)
                _build_symbol_table(f.body, st, diags)
                st.exit_scope()
        if ast.body:
            _build_symbol_table(ast.body, st, diags)
        return
    if isinstance(ast, FdslFile):
        seen_imports = set()
        for imp in getattr(ast, "imports", {}).values():
            if imp is None or id(imp) in seen_imports:
                continue
            seen_imports.add(id(imp))
            for s in getattr(imp, "structs", []):
                _declare_struct(s, st, diags)
            for e in getattr(imp, "enums", []):
                _declare_enum(e, st, diags)
        for sd in ast.storages:
            _declare_storage_items(sd, st, diags)
        for s in ast.structs:
            _declare_struct(s, st, diags)
        for e in ast.enums:
            _declare_enum(e, st, diags)
        for c in ast.contracts:
            _declare_contract(c, st, diags)
        for a in ast.agents:
            _declare_agent(a, st, diags)
        for f in ast.functions:
            _process_function_signature(f, st, diags)
        for m in ast.macros:
            _declare_macro(m, st, diags)
        return
    if isinstance(ast, StorageDecl):
        _declare_storage_items(ast, st, diags)
        return
    if isinstance(ast, BlockStmt):
        st.enter_scope(ScopeKind.BLOCK)
        for child in ast.body:
            _build_symbol_table(child, st, diags)
        st.exit_scope()
        return
    for child in getattr(ast, "children", []):
        _build_symbol_table(child, st, diags)


def _declare_storage_items(sd: StorageDecl, st: SymbolTable, diags: list[Diagnostic]) -> None:
    for item in sd.items:
        kind = SymbolKind.CONSTANT if not item.mutable else SymbolKind.VARIABLE
        sym = st.declare(item.name, kind, item, type_ref=item.type_ref, mutable=item.mutable)
        if isinstance(sym, Diagnostic):
            diags.append(sym)
        elif item.initializer is not None:
            sym.initialized = True


def _declare_struct(s: StructDef, st: SymbolTable, diags: list[Diagnostic]) -> None:
    sym = st.declare(s.name, SymbolKind.STRUCT, s)
    if isinstance(sym, Diagnostic):
        diags.append(sym)


def _declare_enum(e: EnumDef, st: SymbolTable, diags: list[Diagnostic]) -> None:
    sym = st.declare(e.name, SymbolKind.ENUM, e)
    if isinstance(sym, Diagnostic):
        diags.append(sym)


def _declare_contract(c: ContractDef, st: SymbolTable, diags: list[Diagnostic]) -> None:
    sym = st.declare(c.name, SymbolKind.CONTRACT, c)
    if isinstance(sym, Diagnostic):
        diags.append(sym)


def _declare_agent(a: AgentDef, st: SymbolTable, diags: list[Diagnostic]) -> None:
    sym = st.declare(a.name, SymbolKind.AGENT, a)
    if isinstance(sym, Diagnostic):
        diags.append(sym)


def _declare_macro(m: MacroDef, st: SymbolTable, diags: list[Diagnostic]) -> None:
    sym = st.declare(m.name, SymbolKind.MACRO, m)
    if isinstance(sym, Diagnostic):
        diags.append(sym)


def _process_function_signature(f: FunctionDef, st: SymbolTable, diags: list[Diagnostic]) -> None:
    sym = st.declare(f.name, SymbolKind.FUNCTION, f)
    if isinstance(sym, Diagnostic):
        diags.append(sym)


def _infer_types(node: ASTNode, tc: TypeChecker) -> None:
    if isinstance(node, FluxProgram):
        for sd in node.storages:
            tc.infer_type(sd)
        for f in node.functions:
            _infer_function_types(f, tc)
        if node.body:
            for stmt in node.body.body:
                tc.infer_type(stmt)
        return
    if isinstance(node, FdslFile):
        for sd in node.storages:
            tc.infer_type(sd)
        for f in node.functions:
            _infer_function_types(f, tc)
        return
    for child in getattr(node, "children", []):
        _infer_types(child, tc)


def _infer_function_types(f: FunctionDef, tc: TypeChecker) -> None:
    if f.body:
        for stmt in f.body.body:
            tc.infer_type(stmt)


def _track_ownership(ast: ASTNode, st: SymbolTable) -> list[Diagnostic]:
    diags: list[Diagnostic] = []
    ot = OwnershipTracker()
    funcs = _get_functions(ast)
    for func in funcs:
        var_names = _get_variable_names_in_scope(st)
        state = ot.initial_state(var_names)
        if func.body:
            _, func_diags = ot.track_ownership(state, func.body)
            diags.extend(func_diags)
    return diags


def _get_functions(ast: ASTNode) -> list[FunctionDef]:
    if isinstance(ast, FluxProgram):
        return ast.functions
    if isinstance(ast, FdslFile):
        return ast.functions
    return []


def _get_variable_names_in_scope(st: SymbolTable) -> list[str]:
    names: list[str] = []
    for sym in st.all_symbols():
        if sym.kind in (SymbolKind.VARIABLE, SymbolKind.CONSTANT, SymbolKind.OP):
            names.append(sym.name)
    return names


def _check_contracts(ast: ASTNode, st: SymbolTable) -> list[Diagnostic]:
    diags: list[Diagnostic] = []
    impls = _get_impls(ast)
    for impl in impls:
        d = verify_contract_agent(st, impl)
        diags.extend(d)
    return diags


def _check_unsafe_exotic(ast: ASTNode) -> list[Diagnostic]:
    diags: list[Diagnostic] = []
    _walk_exotic(ast, in_unsafe=False, diags=diags)
    return diags


def _walk_exotic(node: ASTNode, in_unsafe: bool, diags: list[Diagnostic]) -> None:
    if isinstance(node, UnsafeStmt):
        in_unsafe = True
    if not in_unsafe:
        if isinstance(node, PtrRefExpr):
            _exotic_err(diags, node, "raw pointer '&(...)' is only allowed inside 'unsafe' blocks")
        if isinstance(node, PtrDerefExpr):
            _exotic_err(diags, node, "raw pointer dereference '*(...)' is only allowed inside 'unsafe' blocks")
        if isinstance(node, PtrAssign):
            _exotic_err(diags, node, "raw pointer assignment is only allowed inside 'unsafe' blocks")
        if isinstance(node, ExternDecl):
            _exotic_err(diags, node, "'extern' declarations are only allowed inside 'unsafe' blocks")
        if isinstance(node, StorageDecl) and node.static:
            _exotic_err(diags, node, "'static' storage declarations are only allowed inside 'unsafe' blocks")
        if isinstance(node, CallExpr) and isinstance(node.callee, Identifier) and node.callee.name == "bounds":
            _exotic_err(diags, node, "'bounds()' is only allowed inside 'unsafe' blocks")
    for kid in _node_children(node):
        if kid is not None:
            _walk_exotic(kid, in_unsafe, diags)


def _node_children(node: ASTNode) -> list[Any]:
    kids: list[Any] = []
    for f in fields(type(node)):
        v = getattr(node, f.name)
        if isinstance(v, ASTNode):
            kids.append(v)
        elif isinstance(v, list):
            kids.extend(x for x in v if isinstance(x, ASTNode))
    return kids


def _exotic_err(diags: list[Diagnostic], node: ASTNode, msg: str) -> None:
    from flux_proto.semantic.diagnostic import Severity
    diags.append(Diagnostic(
        code="SEM002",
        severity=Severity.ERROR,
        line=getattr(node, "line", 0),
        column=getattr(node, "column", 0),
        message=msg,
    ))


def _get_impls(node: ASTNode) -> list[ImplDef]:
    if isinstance(node, FdslFile):
        result: list[ImplDef] = []
        for agent in node.agents:
            for cname in agent.impl_contracts:
                impl = ImplDef(
                    name=cname,
                    for_type=agent.name,
                    items=list(agent.body.ops) if agent.body else [],
                )
                result.append(impl)
        return result
    return []



def _check_emit(ast: ASTNode) -> list[Diagnostic]:
    funcs = _get_functions(ast)
    diags = list(check_emit_terminals(funcs))
    diags.extend(check_result_field_access(ast))
    return diags
