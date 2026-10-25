from flux_proto.token import Token, TokenType as T
from flux_proto.parser.token_stream import TokenStream, ParseError
from flux_proto.parser.ast import (
    ASTNode, BlockStmt, ExpressionStmt, PrintStmt, BreakStmt, ContinueStmt,
    EmitStmt, UnsafeStmt, InfiniteStmt, InfiniteIterator,
    RouteStmt, RouteArm, MatchStmt, MatchArm, VariableReassign, FieldAssign,
    Identifier, Literal, ExternDecl, PtrDerefExpr, PtrAssign,
)


def parse_statement(ts: TokenStream) -> ASTNode:
    tok = ts.peek(0)
    if tok is None:
        _err(ts, "Unexpected end of input, expected statement")

    if _peek_type(ts) in (T.EOL, T.INDENT, T.DEDENT, T.DOCSTRING):
        ts.advance()
        return parse_statement(ts)

    if _peek_type(ts) == T.PRINT:
        return parse_print_stmt(ts)

    if _peek_type(ts) == T.BREAK:
        ts.advance()
        return BreakStmt()

    if _peek_type(ts) == T.CONTINUE:
        ts.advance()
        return ContinueStmt()

    if _peek_type(ts) == T.EMIT:
        return parse_emit_stmt(ts)

    if _peek_type(ts) == T.UNSAFE:
        return parse_unsafe_stmt(ts)

    if _peek_type(ts) == T.STATIC:
        from flux_proto.parser.declarations import parse_storage_decl
        ts.advance()
        sd = parse_storage_decl(ts)
        sd.static = True
        return sd

    if _peek_type(ts) == T.EXTERN:
        return parse_extern_decl(ts)

    if _peek_type(ts) == T.INFINITE:
        return parse_infinite_stmt(ts)

    if _peek_type(ts) == T.ROUTE:
        return parse_route_stmt(ts)

    if _peek_type(ts) == T.MATCH:
        return parse_match_stmt(ts)

    if _peek_type(ts) in (T.MUT, T.IMUT):
        from flux_proto.parser.declarations import parse_storage_decl
        return parse_storage_decl(ts)

    return parse_expression_or_reassign_stmt(ts)


def parse_block_body(ts: TokenStream) -> BlockStmt:
    stmts: list[ASTNode] = []
    while _peek_type(ts) not in (T.RBRACE, T.DEDENT, T.EOF, None):
        if _peek_type(ts) in (T.EOL, T.INDENT):
            ts.advance()
            continue
        stmt = parse_statement(ts)
        stmts.append(stmt)
        while _peek_type(ts) == T.EOL:
            ts.advance()
    return BlockStmt(body=stmts)


def parse_indented_block_body(ts: TokenStream) -> ASTNode:
    stmts: list[ASTNode] = []
    while _peek_type(ts) not in (T.RBRACE, T.EOF, None):
        if _peek_type(ts) in (T.EOL, T.INDENT):
            ts.advance()
            continue
        if _peek_type(ts) == T.DEDENT:
            ts.advance()
            break
        stmt = parse_statement(ts)
        stmts.append(stmt)
        while _peek_type(ts) == T.EOL:
            ts.advance()
    if len(stmts) == 1:
        return stmts[0]
    return BlockStmt(body=stmts)


def parse_print_stmt(ts: TokenStream) -> PrintStmt:
    ts.advance()
    args: list[ASTNode] = []
    if _peek_type(ts) == T.LPAREN:
        ts.advance()
        if _peek_type(ts) != T.RPAREN:
            args = _parse_print_args(ts)
        ts.expect(T.RPAREN)
    if _peek_type(ts) == T.EOL:
        ts.advance()
    return PrintStmt(args=args)


def _parse_print_args(ts: TokenStream) -> list[ASTNode]:
    from flux_proto.parser.expressions import parse_expression
    ts.skip_eols()
    args: list[ASTNode] = [parse_expression(ts)]
    while ts.match(T.COMMA):
        ts.skip_eols()
        args.append(parse_expression(ts))
    return args


def parse_emit_stmt(ts: TokenStream) -> EmitStmt:
    ts.advance()
    ts.expect(T.LPAREN)
    status_tok = ts.peek(0)
    if status_tok is None or status_tok.type not in (T.NICE, T.FAIL):
        _err(ts, "emit status must be 'nice' or 'fail'")
    status = ts.advance().lexeme
    ts.expect(T.COMMA)
    from flux_proto.parser.expressions import parse_expression
    peek0 = ts.peek(0)
    peek1 = ts.peek(1) if peek0 else None
    value = ""
    value_expr = None
    if peek0 is not None and peek0.type == T.IDENTIFIER and peek1 is not None and peek1.type in (T.COMMA, T.RPAREN):
        value = ts.advance().lexeme
    else:
        value_expr = parse_expression(ts)
    ts.expect(T.COMMA)
    message = parse_expression(ts)
    ts.expect(T.RPAREN)
    if _peek_type(ts) == T.EOL:
        ts.advance()
    return EmitStmt(status=status, value=value, value_expr=value_expr, message=message)


def parse_unsafe_stmt(ts: TokenStream) -> UnsafeStmt:
    ts.advance()
    body = parse_block(ts)
    return UnsafeStmt(body=body)


def parse_extern_decl(ts: TokenStream) -> ExternDecl:
    from flux_proto.parser.declarations import parse_function_decl
    ts.expect(T.EXTERN)
    lang = "C"
    if _peek_type(ts) == T.STRING_LIT:
        lang_tok = ts.advance()
        lang = lang_tok.lexeme.strip('"')
    functions: list[ASTNode] = []
    if _peek_type(ts) == T.LBRACE:
        ts.advance()
        while _peek_type(ts) in (T.EOL, T.INDENT):
            ts.advance()
        while _peek_type(ts) not in (T.RBRACE, T.DEDENT, None):
            if _peek_type(ts) in (T.EOL, T.INDENT, T.DEDENT):
                ts.advance()
                continue
            if _peek_type(ts) == T.FUNCTION:
                functions.append(parse_function_decl(ts))
            else:
                fmt = _peek_type(ts)
                _err(ts, f"Expected 'fn' function declaration inside extern block, got {fmt}")
        if _peek_type(ts) == T.DEDENT:
            ts.advance()
        ts.expect(T.RBRACE)
    return ExternDecl(lang=lang, functions=functions)


def parse_block(ts: TokenStream) -> ASTNode:
    from flux_proto.parser.expressions import parse_expression
    ts.expect(T.LBRACE)
    body = parse_indented_block_body(ts)
    ts.expect(T.RBRACE)
    return body if isinstance(body, BlockStmt) else BlockStmt(body=[body])


def parse_infinite_stmt(ts: TokenStream) -> InfiniteStmt:
    ts.advance()
    condition: ASTNode | None = None
    iterator: InfiniteIterator | None = None

    if _peek_type(ts) == T.LPAREN:
        ts.advance()
        if _peek_type(ts) == T.IDENTIFIER and _peek_next_type(ts) == T.IN:
            var_tok = ts.advance()
            ts.advance()
            from flux_proto.parser.expressions import parse_expression
            collection = parse_expression(ts)
            iterator = InfiniteIterator(variable=var_tok.lexeme, collection=collection)
        elif _peek_type(ts) != T.RPAREN:
            from flux_proto.parser.expressions import parse_expression
            condition = parse_expression(ts)
        ts.expect(T.RPAREN)
    elif _peek_type(ts) == T.IDENTIFIER:
        var_tok = ts.advance()
        ts.expect(T.IN)
        from flux_proto.parser.expressions import parse_expression
        collection = parse_expression(ts)
        iterator = InfiniteIterator(variable=var_tok.lexeme, collection=collection)

    body = parse_block(ts)
    return InfiniteStmt(condition=condition, iterator=iterator, body=body)


def parse_route_stmt(ts: TokenStream) -> RouteStmt:
    ts.advance()
    subjects: list[ASTNode] = []
    if _peek_type(ts) == T.LPAREN:
        ts.advance()
        ts.skip_eols()
        if _peek_type(ts) != T.RPAREN:
            from flux_proto.parser.expressions import parse_expression
            subjects.append(parse_expression(ts))
            while ts.match(T.COMMA):
                ts.skip_eols()
                subjects.append(parse_expression(ts))
        ts.skip_eols()
        ts.expect(T.RPAREN)

    arms: list[RouteArm] = []
    ts.expect(T.LBRACE)
    while ts.peek(0) is not None and ts.peek(0).type in (T.EOL, T.INDENT, T.DEDENT):
        ts.advance()
    while ts.peek(0) is not None and ts.peek(0).type not in (T.RBRACE, T.EOF):
        condition: ASTNode | None = None
        if ts.peek(0).type == T.WILDCARD:
            ts.advance()
            condition = Identifier(name="_")
        else:
            from flux_proto.parser.expressions import parse_expression
            condition = parse_expression(ts, stop_at_dataflow=True)
        if _peek_type(ts) == T.DATAFLOW:
            tok = ts.peek(0)
            raise ParseError(
                "PAR001", tok.line, tok.column,
                "Route arms require '==>' between the condition and its body; "
                "'-->' is the dataflow pipeline operator and is not valid here"
            )
        ts.expect(T.DATAFLOW_MAP)
        ts.expect(T.LBRACE)
        body = parse_indented_block_body(ts)
        ts.expect(T.RBRACE)
        arms.append(RouteArm(condition=condition, body=body))
        while ts.peek(0) is not None and ts.peek(0).type in (T.EOL, T.INDENT, T.DEDENT):
            ts.advance()
    ts.expect(T.RBRACE)
    return RouteStmt(subjects=subjects, arms=arms)


def parse_match_stmt(ts: TokenStream) -> MatchStmt:
    ts.advance()
    from flux_proto.parser.expressions import parse_expression
    if _peek_type(ts) == T.LPAREN:
        ts.advance()
        subject = parse_expression(ts)
        ts.expect(T.RPAREN)
    else:
        subject = parse_expression(ts)
    ts.expect(T.LBRACE)
    while _peek_type(ts) in (T.EOL, T.INDENT, T.DEDENT):
        ts.advance()
    arms: list[MatchArm] = []
    while _peek_type(ts) not in (T.RBRACE, None, T.EOF):
        from flux_proto.parser.patterns import parse_match_arm
        arms.append(parse_match_arm(ts))
        while _peek_type(ts) in (T.EOL, T.INDENT, T.DEDENT):
            ts.advance()
        if _peek_type(ts) == T.COMMA:
            ts.advance()
            while _peek_type(ts) in (T.EOL, T.INDENT, T.DEDENT):
                ts.advance()
    ts.expect(T.RBRACE)
    return MatchStmt(subject=subject, arms=arms)


def parse_expression_or_reassign_stmt(ts: TokenStream) -> ASTNode:
    from flux_proto.parser.expressions import parse_expression, parse_assignment_expr
    from flux_proto.parser.expressions import PtrDerefExpr
    tok = ts.peek(0)
    if tok is None:
        _err(ts, "Expected expression or assignment")

    if tok.type == T.STAR and ts.peek(1) is not None and ts.peek(1).type == T.LPAREN:
        ts.advance()
        from flux_proto.parser.expressions import parse_parenthesized_expression
        inner = parse_parenthesized_expression(ts)
        if _peek_type(ts) == T.EQ:
            ts.advance()
            value = parse_assignment_expr(ts)
            if _peek_type(ts) == T.EOL:
                ts.advance()
            return PtrAssign(ptr=PtrDerefExpr(ptr=inner), value=value)
        return ExpressionStmt(expr=PtrDerefExpr(ptr=inner))

    if tok.type == T.IDENTIFIER:
        peek_next = ts.peek(1)
        if peek_next is not None and _is_assign_op(peek_next.type):
            name_tok = ts.advance()
            op_tok = ts.advance()
            value = parse_assignment_expr(ts)
            if _peek_type(ts) == T.EOL:
                ts.advance()
            return VariableReassign(name=name_tok.lexeme, op=op_tok.lexeme, value=value,
                                    line=name_tok.line, column=name_tok.column)
        if peek_next is not None and peek_next.type == T.DOT:
            field_tok = ts.peek(2)
            if field_tok is not None and field_tok.type == T.IDENTIFIER:
                op_tok = ts.peek(3)
                if op_tok is not None and _is_assign_op(op_tok.type):
                    name_tok = ts.advance()
                    dot_tok = ts.advance()
                    field_name_tok = ts.advance()
                    op_tok = ts.advance()
                    if op_tok.type != T.EQ:
                        _err(ts, f"Expected '=' for field assignment, got '{op_tok.lexeme}'")
                    value = parse_assignment_expr(ts)
                    if _peek_type(ts) == T.EOL:
                        ts.advance()
                    return FieldAssign(owner=name_tok.lexeme, field=field_name_tok.lexeme, op="=", value=value,
                                       line=name_tok.line, column=name_tok.column)

    expr = parse_expression(ts)
    if _peek_type(ts) == T.EOL:
        ts.advance()
    return ExpressionStmt(expr=expr)


def _is_assign_op(tt: T) -> bool:
    return tt in {
        T.EQ, T.ASSIGN_ADD, T.ASSIGN_SUB, T.ASSIGN_MUL,
        T.ASSIGN_DIVF, T.ASSIGN_DIVI, T.ASSIGN_DIVR,
        T.ASSIGN_POWE, T.ASSIGN_POWR,
        T.ASSIGN_AND, T.ASSIGN_OR, T.ASSIGN_XOR, T.ASSIGN_NOT,
        T.ASSIGN_SHL, T.ASSIGN_SHR, T.ASSIGN_SHRA,
    }


def _peek_type(ts: TokenStream) -> T | None:
    tok = ts.peek(0)
    return tok.type if tok is not None else None


def _peek_next_type(ts: TokenStream) -> T | None:
    tok = ts.peek(1)
    return tok.type if tok is not None else None


def _err(ts: TokenStream, msg: str) -> None:
    tok = ts.peek(0)
    if tok is not None:
        raise ParseError("PAR001", tok.line, tok.column, msg)
    raise ParseError("PAR001", 0, 0, msg)
