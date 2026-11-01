"""Static macro expander for TheFlux (meta, lift, lower).

Transforms AST at compile time by inlining meta-functions (macros)
and substituting lower(...) parameters into lift { ... } templates.
"""
from copy import deepcopy
from flux_proto.parser.ast import (
    ASTNode, FluxProgram, MacroDef, QuoteExpr, UnquoteExpr, UnaryOp,
    Identifier, CallExpr, ExpressionStmt, StorageDecl, ComptimeExpr, BlockStmt
)


def _expand_ast_node(node: ASTNode, macros: dict[str, MacroDef], depth: int = 0) -> ASTNode:
    if depth > 64:
        raise RuntimeError("Max macro expansion depth (64) exceeded: potential infinite macro recursion")
    if node is None:
        return None

    # Handle macro invocation
    if isinstance(node, CallExpr) and isinstance(node.callee, Identifier) and node.callee.name in macros:
        m = macros[node.callee.name]
        param_names = [p.name for p in m.params]
        arg_map = {}
        for idx, p_name in enumerate(param_names):
            if idx < len(node.args):
                arg_map[p_name] = node.args[idx]

        template = m.body
        if isinstance(template, ExpressionStmt) and isinstance(template.expr, QuoteExpr):
            template = template.expr.body
        elif isinstance(template, QuoteExpr):
            template = template.body

        cloned = deepcopy(template)

        def _subst(n: ASTNode) -> ASTNode:
            if n is None:
                return None
            if isinstance(n, UnaryOp) and n.op in ("lower", "unquote") and isinstance(n.operand, Identifier) and n.operand.name in arg_map:
                return deepcopy(arg_map[n.operand.name])
            if isinstance(n, UnquoteExpr) and isinstance(n.expr, Identifier) and n.expr.name in arg_map:
                return deepcopy(arg_map[n.expr.name])

            for field_name in getattr(n, "__dataclass_fields__", {}):
                val = getattr(n, field_name)
                if isinstance(val, list):
                    setattr(n, field_name, [_subst(item) if isinstance(item, ASTNode) else item for item in val])
                elif isinstance(val, ASTNode):
                    setattr(n, field_name, _subst(val))
            return n

        expanded_body = _subst(cloned)

        if isinstance(expanded_body, StorageDecl):
            last_name = expanded_body.items[-1].name
            result_expr = ComptimeExpr(body=BlockStmt(body=[
                expanded_body,
                ExpressionStmt(expr=Identifier(name=last_name))
            ]))
            return _expand_ast_node(result_expr, macros, depth + 1)
        elif isinstance(expanded_body, BlockStmt):
            result_expr = ComptimeExpr(body=expanded_body)
            return _expand_ast_node(result_expr, macros, depth + 1)
        elif isinstance(expanded_body, ExpressionStmt):
            return _expand_ast_node(expanded_body.expr, macros, depth + 1)
        else:
            return _expand_ast_node(expanded_body, macros, depth + 1)

    # Recursive traversal over generic dataclass node
    for field_name in getattr(node, "__dataclass_fields__", {}):
        val = getattr(node, field_name)
        if isinstance(val, list):
            setattr(node, field_name, [_expand_ast_node(item, macros, depth) if isinstance(item, ASTNode) else item for item in val])
        elif isinstance(val, ASTNode):
            setattr(node, field_name, _expand_ast_node(val, macros, depth))

    return node


def expand_macros(ast: FluxProgram) -> FluxProgram:
    """Expands all meta macro invocations in the given AST."""
    macros = {m.name: m for m in getattr(ast, "macros", [])}
    if not macros:
        return ast
    return _expand_ast_node(ast, macros, 0)
