from flux_proto.token import Token, TokenType as T
from flux_proto.parser.token_stream import TokenStream, ParseError
from flux_proto.parser.ast import (
    ASTNode, BinaryOp, UnaryOp, Literal, Identifier, CallExpr, NamedArg,
    FieldAccess, IndexAccess, IndexAssign, SliceSpec, StructInit, InitField,
    EnumVariant, DataflowExpr, CastExpr, ErrorExpr, ShortCircuitBlock,
    ShortCircuitArm, InputExpr, SpyExpr, ComptimeExpr, QuoteExpr,
    UnquoteExpr, OwnershipExpr, SpawnExpr, AwaitExpr,
    PtrRefExpr, PtrDerefExpr, PtrAssign,
    LambdaExpr, DataflowCastSink, InterpolatedString, InterpolatedText,
    MatchExpr, MatchArm, BlockStmt, Pattern,
    ListLiteral, SetLiteral, RecordLiteral, MapEntry, MapLiteral,
)


def parse_expression(ts: TokenStream, stop_at_dataflow: bool = False) -> ASTNode:
    return parse_assignment_expr(ts, stop_at_dataflow)


def _skip_continuation(ts: TokenStream) -> None:
    while True:
        tok = ts.peek(0)
        if tok is None:
            return
        if tok.type in (T.EOL, T.INDENT):
            ts.advance()
            continue
        return


def parse_assignment_expr(ts: TokenStream, stop_at_dataflow: bool = False) -> ASTNode:
    left = parse_recovery_expr(ts, stop_at_dataflow)
    if _is_assignment_operator(ts.peek(0)):
        op_tok = ts.advance()
        _skip_continuation(ts)
        right = parse_assignment_expr(ts, stop_at_dataflow)
        if isinstance(left, IndexAccess):
            return IndexAssign(obj=left.obj, indices=left.indices, op=op_tok.lexeme, value=right)
        return BinaryOp(op=op_tok.lexeme, left=left, right=right)
    return left


def parse_recovery_expr(ts: TokenStream, stop_at_dataflow: bool = False) -> ASTNode:
    left = parse_dataflow_expr(ts, stop_at_dataflow)
    while _peek_type(ts) in (T.CATCH, T.FALLBACK):
        op_tok = ts.advance()
        _skip_continuation(ts)
        right = parse_dataflow_expr(ts, stop_at_dataflow)
        left = BinaryOp(op=op_tok.lexeme, left=left, right=right)
    return left


def parse_dataflow_expr(ts: TokenStream, stop_at_dataflow: bool = False) -> ASTNode:
    left = parse_or_expr(ts)
    while _peek_type(ts) in (T.DATAFLOW, T.DATAFLOW_MAP, T.SPLIT, T.JOIN):
        if stop_at_dataflow and _peek_type(ts) in (T.DATAFLOW, T.DATAFLOW_MAP):
            break
        if _peek_type(ts) == T.DATAFLOW_MAP and _peek_next_type(ts) == T.LBRACE:
            break
        op_tok = ts.advance()
        _skip_continuation(ts)
        if _peek_type(ts) == T.LPAREN and _peek_next_type(ts) == T.AS:
            ts.advance()
            ts.advance()
            target_type = parse_type_reference(ts)
            ts.expect(T.RPAREN)
            right = DataflowCastSink(target_type=target_type)
        else:
            right = parse_or_expr(ts)
        left = DataflowExpr(op=op_tok.lexeme, left=left, right=right)
    return left


def parse_or_expr(ts: TokenStream) -> ASTNode:
    left = parse_and_expr(ts)
    while _peek_type(ts) == T.OR_KEYWORD:
        op_tok = ts.advance()
        _skip_continuation(ts)
        right = parse_and_expr(ts)
        left = BinaryOp(op=op_tok.lexeme, left=left, right=right)
    return left


def parse_and_expr(ts: TokenStream) -> ASTNode:
    left = parse_bit_or_expr(ts)
    while _peek_type(ts) == T.AND_KEYWORD:
        op_tok = ts.advance()
        _skip_continuation(ts)
        right = parse_bit_or_expr(ts)
        left = BinaryOp(op=op_tok.lexeme, left=left, right=right)
    return left


def parse_bit_or_expr(ts: TokenStream) -> ASTNode:
    left = parse_bit_xor_expr(ts)
    while _peek_type(ts) == T.OR:
        op_tok = ts.advance()
        _skip_continuation(ts)
        right = parse_bit_xor_expr(ts)
        left = BinaryOp(op=op_tok.lexeme, left=left, right=right)
    return left


def parse_bit_xor_expr(ts: TokenStream) -> ASTNode:
    left = parse_bit_and_expr(ts)
    while _peek_type(ts) == T.XOR:
        op_tok = ts.advance()
        _skip_continuation(ts)
        right = parse_bit_and_expr(ts)
        left = BinaryOp(op=op_tok.lexeme, left=left, right=right)
    return left


def parse_bit_and_expr(ts: TokenStream) -> ASTNode:
    left = parse_equality_expr(ts)
    while _peek_type(ts) == T.AND:
        op_tok = ts.advance()
        _skip_continuation(ts)
        right = parse_equality_expr(ts)
        left = BinaryOp(op=op_tok.lexeme, left=left, right=right)
    return left


def parse_equality_expr(ts: TokenStream) -> ASTNode:
    left = parse_membership_expr(ts)
    while _peek_type(ts) in (T.EQEQ, T.NEQ, T.LT, T.GT, T.LTE, T.GTE):
        op_tok = ts.advance()
        _skip_continuation(ts)
        right = parse_membership_expr(ts)
        left = BinaryOp(op=op_tok.lexeme, left=left, right=right)
    return left


def parse_membership_expr(ts: TokenStream) -> ASTNode:
    left = parse_range_expr(ts)
    while _peek_type(ts) == T.IN:
        op_tok = ts.advance()
        _skip_continuation(ts)
        right = parse_range_expr(ts)
        left = BinaryOp(op=op_tok.lexeme, left=left, right=right)
    return left


def parse_range_expr(ts: TokenStream) -> ASTNode:
    left = parse_shift_expr(ts)
    if _peek_type(ts) == T.RANGE:
        op_tok = ts.advance()
        _skip_continuation(ts)
        right = parse_shift_expr(ts)
        left = BinaryOp(op=op_tok.lexeme, left=left, right=right)
    return left


def parse_shift_expr(ts: TokenStream) -> ASTNode:
    left = parse_additive_expr(ts)
    while _peek_type(ts) in (T.SHIFT_LEFT, T.SHIFT_RIGHT, T.SHIFT_LOGICAL):
        op_tok = ts.advance()
        _skip_continuation(ts)
        right = parse_additive_expr(ts)
        left = BinaryOp(op=op_tok.lexeme, left=left, right=right)
    return left


def parse_additive_expr(ts: TokenStream) -> ASTNode:
    left = parse_multiplicative_expr(ts)
    while _peek_type(ts) in (T.PLUS, T.MINUS):
        op_tok = ts.advance()
        _skip_continuation(ts)
        right = parse_multiplicative_expr(ts)
        left = BinaryOp(op=op_tok.lexeme, left=left, right=right)
    return left


def parse_multiplicative_expr(ts: TokenStream) -> ASTNode:
    left = parse_power_expr(ts)
    while _peek_type(ts) in (T.STAR, T.DIV_FLOOR, T.DIV_INT, T.DIV_REM):
        op_tok = ts.advance()
        _skip_continuation(ts)
        right = parse_power_expr(ts)
        left = BinaryOp(op=op_tok.lexeme, left=left, right=right)
    return left


def parse_power_expr(ts: TokenStream) -> ASTNode:
    left = parse_prefix_expr(ts)
    if _peek_type(ts) in (T.POW_REAL, T.POW_RCP):
        op_tok = ts.advance()
        _skip_continuation(ts)
        right = parse_power_expr(ts)
        left = BinaryOp(op=op_tok.lexeme, left=left, right=right)
    return left


def parse_prefix_expr(ts: TokenStream) -> ASTNode:
    tok = ts.peek(0)
    if tok is None:
        _err(ts, "Unexpected end of input in expression")

    if _peek_type(ts) in (T.PLUS, T.MINUS, T.NOT_KEYWORD, T.NOT, T.TILDE, T.UNQUOTE):
        op_tok = ts.advance()
        operand = parse_prefix_expr(ts)
        return UnaryOp(op=op_tok.lexeme, operand=operand)

    if _peek_type(ts) == T.KEEP and _peek_next_type(ts) != T.LPAREN:
        ts.advance()
        return Identifier(name="keep")

    if _peek_type(ts) in (T.MOVE, T.BORROW, T.BORROW_MUT, T.KEEP):
        op_tok = ts.advance()
        ts.expect(T.LPAREN)
        target = ts.expect(T.IDENTIFIER)
        ts.expect(T.RPAREN)
        return OwnershipExpr(op=op_tok.lexeme, target=target.lexeme,
                             mut=op_tok.type == T.BORROW_MUT)

    if _peek_type(ts) == T.AND and _peek_next_type(ts) == T.LPAREN:
        ts.advance()
        inner = parse_parenthesized_expression(ts)
        return PtrRefExpr(target=inner)

    if _peek_type(ts) == T.STAR and _peek_next_type(ts) == T.LPAREN:
        ts.advance()
        inner = parse_parenthesized_expression(ts)
        return PtrDerefExpr(ptr=inner)

    if _peek_type(ts) == T.SPAWN:
        ts.advance()
        return SpawnExpr(operand=parse_primary_postfix_expr(ts))

    if _peek_type(ts) == T.AWAIT:
        ts.advance()
        return AwaitExpr(operand=parse_primary_postfix_expr(ts))

    return parse_primary_postfix_expr(ts)


def parse_primary_postfix_expr(ts: TokenStream) -> ASTNode:
    node = parse_cast_expression(ts)
    while True:
        tok = ts.peek(0)
        if tok is None:
            break
        if _peek_type(ts) == T.DOT:
            ts.advance()
            field = ts.expect(T.IDENTIFIER)
            node = FieldAccess(obj=node, field=field.lexeme)
        elif _peek_type(ts) == T.DOUBLE_COLON:
            ts.advance()
            member = ts.expect(T.IDENTIFIER)
            node = FieldAccess(obj=node, field=member.lexeme)
        elif _peek_type(ts) == T.LPAREN:
            node = parse_call_suffix(ts, node)
        elif _peek_type(ts) == T.LBRACKET:
            node = parse_index_suffix(ts, node)
        elif _peek_type(ts) == T.ENSURE:
            ts.advance()
            ts.expect(T.LBRACE)
            body = __parse_indented_block_body(ts)
            ts.expect(T.RBRACE)
            node = BinaryOp(op="ensure", left=node, right=BlockStmt(body=[body]))
        elif _peek_type(ts) == T.AS:
            ts.advance()
            target_type = parse_type_reference(ts)
            node = CastExpr(expr=node, target_type=target_type)
        elif _peek_type(ts) == T.QUESTION:
            node = parse_short_circuit_suffix(ts, node)
        else:
            break
    return node


def parse_cast_expression(ts: TokenStream) -> ASTNode:
    node = parse_primary_expression(ts)
    while _peek_type(ts) == T.AS:
        ts.advance()
        target_type = parse_type_reference(ts)
        node = CastExpr(expr=node, target_type=target_type)
    return node


def parse_primary_expression(ts: TokenStream) -> ASTNode:
    tok = ts.peek(0)
    if tok is None:
        _err(ts, "Unexpected end of input in primary expression")

    tt = tok.type

    if tt == T.LPAREN:
        return parse_parenthesized_expression(ts)

    if tt == T.LBRACKET:
        return parse_list_literal(ts)

    if tt == T.LBRACE:
        if _peek_non_trivia_type(ts, 1) == T.DOT:
            return parse_record_literal(ts)
        return parse_set_literal(ts)

    if tt == T.MAP:
        return parse_map_literal(ts)

    if tt in (T.INT_LIT, T.FLOAT_LIT, T.COMPLEX_LIT, T.DATETIME_LIT, T.STRING_LIT,
              T.CHAR_LIT, T.TRUE, T.FALSE):
        return parse_literal(ts)

    if tt == T.INTERPOLATED_STRING_START:
        return parse_interpolated_string(ts)

    if tt == T.IDENTIFIER:
        return parse_identifier_or_special(ts)

    if tt == T.MATCH:
        return parse_match_expression(ts)

    if tt == T.ROUTE:
        _err(ts, "'route' so e valido como statement")

    if tt == T.COMPTIME:
        ts.advance()
        if _peek_type(ts) == T.LBRACE:
            from flux_proto.parser.statements import parse_block
            body = parse_block(ts)
            return ComptimeExpr(body=body)
        expr = parse_expression(ts)
        return ComptimeExpr(body=expr)

    if tt == T.QUOTE:
        ts.advance()
        ts.expect(T.LBRACE)
        body = __parse_indented_block_body(ts)
        ts.expect(T.RBRACE)
        return QuoteExpr(body=body)

    if tt == T.ERROR:
        return parse_error_expression(ts)

    if tt == T.INPUT:
        return parse_input_expr(ts)

    if tt == T.SPY:
        return parse_spy_expression(ts)

    if tt == T.PRINT:
        ts.advance()
        if _peek_type(ts) == T.LPAREN:
            return parse_call_suffix(ts, Identifier(name="print"))
        return Identifier(name="print")

    if tt == T.WILDCARD:
        ts.advance()
        return Identifier(name="_")

    _err(ts, f"Unexpected token in expression: {tok.type.name}")


def parse_parenthesized_expression(ts: TokenStream) -> ASTNode:
    ts.expect(T.LPAREN)
    node = parse_expression(ts)
    ts.expect(T.RPAREN)
    return node


def parse_list_literal(ts: TokenStream) -> ASTNode:
    ts.expect(T.LBRACKET)
    items: list[ASTNode] = []
    ts.skip_eols(include_indent=True)
    if _peek_type(ts) != T.RBRACKET:
        items.append(parse_expression(ts))
        while ts.match(T.COMMA):
            ts.skip_eols(include_indent=True)
            if _peek_type(ts) in (T.RBRACKET, None):
                break
            items.append(parse_expression(ts))
    ts.skip_eols(include_indent=True)
    ts.expect(T.RBRACKET)
    return ListLiteral(items=items)


def parse_map_literal(ts: TokenStream) -> ASTNode:
    ts.expect(T.MAP)
    ts.expect(T.LBRACE)
    entries: list[MapEntry] = []
    ts.skip_eols(include_indent=True)
    while _peek_type(ts) not in (T.RBRACE, None):
        value_type: ASTNode | None = None
        peek = ts.peek(0)
        is_dot_key = (peek is not None and peek.type == T.DOT) or (
            peek is not None
            and peek.type in (T.INT_LIT, T.FLOAT_LIT)
            and peek.lexeme.startswith(".")
        )
        if is_dot_key:
            if peek.type == T.DOT:
                ts.advance()
                key_tok = ts.advance()
            else:
                key_tok = ts.advance()
            if key_tok is None or key_tok.type not in (T.IDENTIFIER, T.INT_LIT, T.FLOAT_LIT):
                _err(ts, "Expected identifier or number after '.' in map key")
            key_type: ASTNode | None = None
            if _peek_type(ts) == T.OF:
                ts.advance()
                key_type = parse_type_reference(ts)
            ts.expect(T.COLON)
            value = parse_expression(ts)
            if _peek_type(ts) == T.OF:
                ts.advance()
                value_type = parse_type_reference(ts)
            entries.append(MapEntry(
                key=key_tok.lexeme.lstrip('.'),
                key_type=key_type,
                value=value,
                value_type=value_type,
            ))
        else:
            key = parse_expression(ts)
            ts.expect(T.COLON)
            value = parse_expression(ts)
            if _peek_type(ts) == T.OF:
                ts.advance()
                value_type = parse_type_reference(ts)
            entries.append(MapEntry(key="", key_type=None, value=value, value_type=value_type, key_expr=key))
        if not ts.match(T.COMMA):
            break
        ts.skip_eols(include_indent=True)
    ts.skip_eols(include_indent=True)
    ts.expect(T.RBRACE)
    return MapLiteral(entries=entries)


def parse_set_literal(ts: TokenStream) -> ASTNode:
    ts.expect(T.LBRACE)
    items: list[ASTNode] = []
    ts.skip_eols(include_indent=True)
    if _peek_type(ts) != T.RBRACE:
        items.append(parse_expression(ts))
        while ts.match(T.COMMA):
            ts.skip_eols(include_indent=True)
            if _peek_type(ts) in (T.RBRACE, None):
                break
            items.append(parse_expression(ts))
    ts.skip_eols(include_indent=True)
    ts.expect(T.RBRACE)
    return SetLiteral(items=items)


def parse_record_literal(ts: TokenStream) -> ASTNode:
    ts.expect(T.LBRACE)
    fields: list[InitField] = []
    ts.skip_eols(include_indent=True)
    while _peek_type(ts) not in (T.RBRACE, None):
        ts.expect(T.DOT)
        field_tok = ts.expect(T.IDENTIFIER)
        ts.expect(T.COLON)
        value = parse_expression(ts)
        fields.append(InitField(name=field_tok.lexeme, value=value))
        ts.skip_eols(include_indent=True)
        if not ts.match(T.COMMA):
            break
        ts.skip_eols(include_indent=True)
    ts.expect(T.RBRACE)
    return RecordLiteral(fields=fields)


def _peek_non_trivia_type(ts: TokenStream, start: int = 0) -> T | None:
    i = start
    while True:
        tok = ts.peek(i)
        if tok is None:
            return None
        if tok.type not in (T.EOL, T.INDENT, T.DEDENT):
            return tok.type
        i += 1


def parse_literal(ts: TokenStream) -> ASTNode:
    tok = ts.advance()
    if tok is None:
        _err(ts, "Expected literal")
    if tok.type == T.TRUE:
        return Literal(value_type="BOOL", value="true")
    if tok.type == T.FALSE:
        return Literal(value_type="BOOL", value="false")
    mapping = {
        T.INT_LIT: "INT",
        T.FLOAT_LIT: "FLOAT",
        T.COMPLEX_LIT: "COMPLEX",
        T.DATETIME_LIT: "DATETIME",
        T.STRING_LIT: "STRING",
        T.CHAR_LIT: "CHAR",
    }
    vt = mapping.get(tok.type, "STRING")
    return Literal(value_type=vt, value=tok.lexeme)


def parse_interpolated_string(ts: TokenStream) -> ASTNode:
    ts.advance()
    parts: list[ASTNode] = []
    while _peek_type(ts) != T.INTERPOLATED_STRING_END:
        if _peek_type(ts) == T.INTERPOLATED_TEXT:
            tok = ts.advance()
            parts.append(InterpolatedText(text=tok.lexeme))
        elif _peek_type(ts) == T.INTERPOLATION_OPEN:
            ts.advance()
            expr = parse_expression(ts)
            ts.expect(T.INTERPOLATION_CLOSE)
            parts.append(expr)
        else:
            _err(ts, f"Unexpected token in interpolated string: {ts.peek(0).type.name}")
    ts.advance()
    return InterpolatedString(parts=parts)


def parse_identifier_or_special(ts: TokenStream) -> ASTNode:
    tok = ts.peek(0)
    if tok is None:
        _err(ts, "Expected identifier")

    if _peek_next_type(ts) == T.DOUBLE_COLON:
        return parse_enum_variant_or_namespace(ts)

    name_tok = ts.advance()
    node: ASTNode = Identifier(name=name_tok.lexeme)
    return node


def _is_enum_init_after_lparen(ts: TokenStream) -> bool:
    idx = 1
    while True:
        tok = ts.peek(idx)
        if tok is None:
            return False
        if tok.type in (T.EOL, T.INDENT, T.DEDENT):
            idx += 1
            continue
        if tok.type == T.DOT:
            return True
        return False


def parse_enum_variant_or_namespace(ts: TokenStream) -> ASTNode:
    first = ts.advance()
    ts.expect(T.DOUBLE_COLON)
    second = ts.expect(T.IDENTIFIER)

    if _peek_type(ts) == T.LPAREN and _is_enum_init_after_lparen(ts):
        node = EnumVariant(enum_name=first.lexeme, variant=second.lexeme)
        ts.advance()
        ts.skip_eols()
        if _peek_type(ts) != T.RPAREN:
            node.fields = _parse_init_fields(ts)
            ts.skip_eols()
        ts.expect(T.RPAREN)
        return node

    return EnumVariant(enum_name=first.lexeme, variant=second.lexeme)


def parse_init_fields(ts: TokenStream) -> list[InitField]:
    return _parse_init_fields(ts)


def _parse_init_fields(ts: TokenStream) -> list[InitField]:
    fields: list[InitField] = []
    ts.skip_eols()
    while _peek_type(ts) == T.DOT:
        fields.append(_parse_init_field(ts))
        ts.skip_eols()
        if _peek_type(ts) == T.COMMA:
            ts.advance()
            ts.skip_eols()
    return fields


def _parse_init_field(ts: TokenStream) -> InitField:
    ts.expect(T.DOT)
    name_tok = ts.expect(T.IDENTIFIER)
    ts.expect(T.COLON)
    value = parse_expression(ts)
    return InitField(name=name_tok.lexeme, value=value)


def parse_call_suffix(ts: TokenStream, callee: ASTNode) -> ASTNode:
    ts.expect(T.LPAREN)
    if isinstance(callee, Identifier):
        save = ts.position
        ts.skip_eols()
        if _peek_type(ts) == T.DOT:
            fields = _parse_init_fields(ts)
            ts.skip_eols()
            ts.expect(T.RPAREN)
            return StructInit(name=callee.name, fields=fields)
        ts.set_position(save)
        spec = _try_parse_slice_args(ts)
        if spec is not None:
            return IndexAccess(obj=callee, indices=[spec])
    args: list[ASTNode] = []
    ts.skip_eols()
    if _peek_type(ts) != T.RPAREN:
        args = _parse_call_args(ts)
    ts.skip_eols()
    ts.expect(T.RPAREN)
    return CallExpr(callee=callee, args=args)


def _try_parse_slice_args(ts: TokenStream) -> SliceSpec | None:
    save = ts.position
    ts.skip_eols()
    start: ASTNode | None = None
    if _peek_type(ts) == T.RANGE:
        ts.advance()
    else:
        try:
            start = parse_shift_expr(ts)
        except Exception:
            ts.set_position(save)
            return None
        if _peek_type(ts) != T.RANGE:
            ts.set_position(save)
            return None
        ts.advance()
    end: ASTNode | None = None
    step: ASTNode | None = None
    if _peek_type(ts) not in (T.RPAREN,):
        end = parse_shift_expr(ts)
        if _peek_type(ts) == T.RANGE:
            ts.advance()
            step = parse_shift_expr(ts)
    ts.skip_eols()
    ts.expect(T.RPAREN)
    return SliceSpec(start=start, end=end, step=step)


def _parse_call_args(ts: TokenStream) -> list[ASTNode]:
    args: list[ASTNode] = []
    ts.skip_eols()
    first = parse_expression(ts)
    if _peek_type(ts) == T.COMMA:
        ts.advance()
        args.append(first)
        while _peek_type(ts) not in (T.RPAREN, None):
            ts.skip_eols()
            if _peek_type(ts) in (T.RPAREN, None):
                break
            args.append(parse_expression(ts))
            if not ts.match(T.COMMA):
                break
    elif _peek_type(ts) == T.COLON:
        ts.advance()
        val = parse_expression(ts)
        args.append(NamedArg(name=first, value=val))
        while ts.match(T.COMMA):
            ts.skip_eols()
            n = ts.expect(T.IDENTIFIER)
            ts.expect(T.COLON)
            v = parse_expression(ts)
            args.append(NamedArg(name=n.lexeme, value=v))
    else:
        args = [first]
    return args


def _parse_slice_or_index(ts: TokenStream) -> ASTNode:
    start: ASTNode | None = None
    if _peek_type(ts) == T.RANGE:
        ts.advance()
    else:
        start = parse_shift_expr(ts)
        if _peek_type(ts) != T.RANGE:
            return start
        ts.advance()
    end: ASTNode | None = None
    if _peek_type(ts) not in (T.RANGE, T.COMMA, T.RBRACKET):
        end = parse_shift_expr(ts)
    step: ASTNode | None = None
    if _peek_type(ts) == T.RANGE:
        ts.advance()
        step = parse_shift_expr(ts)
    return SliceSpec(start=start, end=end, step=step)


def parse_index_suffix(ts: TokenStream, obj: ASTNode) -> ASTNode:
    ts.expect(T.LBRACKET)
    ts.skip_eols()
    indices: list[ASTNode] = [_parse_slice_or_index(ts)]
    while ts.match(T.COMMA):
        ts.skip_eols()
        indices.append(_parse_slice_or_index(ts))
    ts.skip_eols()
    ts.expect(T.RBRACKET)
    if len(indices) == 1 and not isinstance(indices[0], SliceSpec):
        return IndexAccess(obj=obj, indices=indices)
    return IndexAccess(obj=obj, indices=indices)


def parse_type_reference(ts: TokenStream) -> ASTNode:
    from flux_proto.parser.declarations import parse_type_reference as _parse_type
    return _parse_type(ts)


def parse_short_circuit_suffix(ts: TokenStream, node: ASTNode) -> ASTNode:
    from flux_proto.parser.statements import parse_emit_stmt
    ts.expect(T.QUESTION)
    if _peek_type(ts) == T.EOL:
        ts.advance()
    ts.expect(T.LBRACE)
    while ts.peek(0) is not None and ts.peek(0).type in (T.EOL, T.INDENT, T.DEDENT):
        ts.advance()
    fail_emit = _parse_sc_arm(ts, T.FAIL)
    nice_emit = _parse_sc_arm(ts, T.NICE)
    while ts.peek(0) is not None and ts.peek(0).type in (T.EOL, T.INDENT, T.DEDENT):
        ts.advance()
    ts.expect(T.RBRACE)
    return ShortCircuitBlock(
        expr=node,
        fail_arm=ShortCircuitArm(
            status=fail_emit.status, value=fail_emit.value, message=fail_emit.message
        ),
        nice_arm=ShortCircuitArm(
            status=nice_emit.status, value=nice_emit.value, message=nice_emit.message
        ),
    )


def _parse_sc_arm(ts: TokenStream, status_type: T):
    from flux_proto.parser.statements import parse_emit_stmt
    while ts.peek(0) is not None and ts.peek(0).type in (T.EOL, T.INDENT, T.DEDENT):
        ts.advance()
    ts.expect(T.DATAFLOW_MAP)
    emit = parse_emit_stmt(ts)
    if emit.status != status_type.name.lower():
        _err(ts, f"short-circuit arm must be '==> emit({status_type.name.lower()}, ...)'")
    return emit


def parse_error_expression(ts: TokenStream) -> ASTNode:
    ts.advance()
    ts.expect(T.LPAREN)
    code = parse_expression(ts)
    msg = None
    recovery = None
    if _peek_type(ts) == T.COMMA:
        ts.advance()
        msg = parse_expression(ts)
    if _peek_type(ts) == T.COMMA:
        ts.advance()
        recovery = parse_expression(ts)
    ts.expect(T.RPAREN)
    return ErrorExpr(code=code, message=msg, recovery=recovery)


def parse_input_expr(ts: TokenStream) -> ASTNode:
    ts.advance()
    ts.expect(T.LPAREN)
    prompt = None
    if _peek_type(ts) != T.RPAREN:
        prompt = parse_expression(ts)
    ts.expect(T.RPAREN)
    return InputExpr(prompt=prompt)


def parse_spy_expression(ts: TokenStream) -> ASTNode:
    ts.advance()
    if _peek_type(ts) != T.LPAREN:
        return SpyExpr()
    ts.expect(T.LPAREN)
    target = parse_expression(ts)
    ts.expect(T.RPAREN)
    return SpyExpr(target=target)


def parse_match_expression(ts: TokenStream) -> ASTNode:
    from flux_proto.parser import patterns as _patterns_mod
    ts.advance()
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
        arms.append(_patterns_mod.parse_match_arm(ts))
        while _peek_type(ts) in (T.EOL, T.INDENT, T.DEDENT):
            ts.advance()
        if _peek_type(ts) == T.COMMA:
            ts.advance()
            while _peek_type(ts) in (T.EOL, T.INDENT, T.DEDENT):
                ts.advance()
    ts.expect(T.RBRACE)
    return MatchExpr(subject=subject, arms=arms)


def _is_assignment_operator(tok: Token | None) -> bool:
    if tok is None:
        return False
    assign_ops = {
        T.EQ, T.ASSIGN_ADD, T.ASSIGN_SUB, T.ASSIGN_MUL,
        T.ASSIGN_DIVF, T.ASSIGN_DIVI, T.ASSIGN_DIVR,
        T.ASSIGN_POWE, T.ASSIGN_POWR,
        T.ASSIGN_AND, T.ASSIGN_OR, T.ASSIGN_XOR, T.ASSIGN_NOT,
        T.ASSIGN_SHL, T.ASSIGN_SHR, T.ASSIGN_SHRA,
    }
    return tok.type in assign_ops


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


def __parse_indented_block_body(ts: TokenStream) -> ASTNode:
    from flux_proto.parser.statements import parse_indented_block_body as _fn
    return _fn(ts)

