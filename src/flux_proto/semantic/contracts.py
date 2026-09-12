from __future__ import annotations

from flux_proto.parser.ast import (
    ASTNode, ContractDef, ContractOpSig, ImplDef, OpDecl,
    Parameter, PrimitiveType,
)
from flux_proto.semantic.diagnostic import Diagnostic, Severity
from flux_proto.semantic.symbol_table import SymbolTable, SymbolKind


def verify_contract_agent(st: SymbolTable, impl: ImplDef) -> list[Diagnostic]:
    diags: list[Diagnostic] = []

    contract_sym = st.resolve(impl.name)
    if contract_sym is None or contract_sym.kind != SymbolKind.CONTRACT:
        return diags

    contract_node = contract_sym.decl_node
    if not isinstance(contract_node, ContractDef):
        return diags

    required_sigs = contract_node.op_signatures

    impl_ops: dict[str, OpDecl] = {}
    for item in impl.items:
        if isinstance(item, OpDecl):
            impl_ops[item.name] = item

    for sig in required_sigs:
        impl_op = impl_ops.get(sig.name)
        if impl_op is None:
            diags.append(
                Diagnostic(
                    code="SEM001", severity=Severity.ERROR,
                    line=_line_of(impl), column=_col_of(impl),
                    message=f"missing op '{sig.name}' in impl '{impl.name}' for '{impl.for_type}'",
                )
            )
            continue

        match_diag = _match_signature(sig, impl_op, impl)
        if match_diag is not None:
            diags.append(match_diag)

    return diags


def _match_signature(sig: ContractOpSig, op: OpDecl, impl: ImplDef) -> Diagnostic | None:
    if len(sig.params) != _param_count(op):
        return Diagnostic(
            code="SEM001", severity=Severity.ERROR,
            line=_line_of(impl), column=_col_of(impl),
            message=f"parameter count mismatch for op '{sig.name}' in impl '{impl.name}': "
                    f"expected {len(sig.params)}, got {_param_count(op)}",
        )

    for i, sig_param in enumerate(sig.params):
        op_type = _param_type_at(op, i)
        sig_type = sig_param.type_ref
        if sig_type is not None and op_type is not None:
            if _type_name(sig_type) != _type_name(op_type):
                return Diagnostic(
                    code="SEM001", severity=Severity.ERROR,
                    line=_line_of(impl), column=_col_of(impl),
                    message=f"parameter type mismatch for op '{sig.name}' in impl '{impl.name}': "
                            f"expected '{_type_name(sig_type)}', got '{_type_name(op_type)}'",
                )

    if _return_type_name(sig) != _return_type_name(op):
        return Diagnostic(
            code="SEM001", severity=Severity.ERROR,
            line=_line_of(impl), column=_col_of(impl),
            message=f"return type mismatch for op '{sig.name}' in impl '{impl.name}': "
                    f"expected '{_return_type_name(sig)}', got '{_return_type_name(op)}'",
        )

    return None


def _param_count(op: OpDecl) -> int:
    if op.params:
        return len(op.params)
    count = 0
    if op.left_type is not None:
        count += 1
    if op.right_type is not None:
        count += 1
    return count


def _param_type_at(op: OpDecl, index: int) -> ASTNode | None:
    if op.params:
        if 0 <= index < len(op.params):
            return op.params[index].type_ref
        return None
    if index == 0:
        return op.left_type
    if index == 1:
        return op.right_type
    return None


def _type_name(node: ASTNode | None) -> str:
    if node is None:
        return "void"
    name = getattr(node, "name", None) or ""
    if name:
        return name
    return getattr(node, "value_type", None) or str(type(node).__name__)


def _return_type_name(node: ContractOpSig | OpDecl) -> str:
    rt = getattr(node, "return_type", None)
    if rt is None:
        return "void"
    return _type_name(rt)


def _line_of(node: ASTNode) -> int:
    return getattr(node, "line", 0)


def _col_of(node: ASTNode) -> int:
    return getattr(node, "column", 0)
