from flux_proto.token import Token, TokenType as T
from flux_proto.parser.token_stream import TokenStream, ParseError
from flux_proto.parser.ast import (
    ASTNode, Pattern, WildcardPattern, LiteralPattern, IdentifierPattern,
    RecordPattern, StructPattern, EnumVariantPattern, ListPattern,
    DataPattern, Literal, InitField,
)


def parse_pattern(ts: TokenStream) -> ASTNode:
    tok = ts.peek(0)
    if tok is None:
        _err(ts, "Unexpected end of input in pattern")

    if _peek_type(ts) == T.WILDCARD:
        ts.advance()
        return WildcardPattern()

    if _peek_type(ts) in (T.INT_LIT, T.FLOAT_LIT, T.STRING_LIT, T.CHAR_LIT,
                          T.TRUE, T.FALSE):
        lit = ts.advance()
        vt = {T.INT_LIT: "INT", T.FLOAT_LIT: "FLOAT", T.STRING_LIT: "STRING",
              T.CHAR_LIT: "CHAR", T.TRUE: "BOOL", T.FALSE: "BOOL"}.get(lit.type, "STRING")
        val = lit.lexeme if lit.type != T.TRUE else "true"
        if lit.type == T.FALSE:
            val = "false"
        return LiteralPattern(value=Literal(value_type=vt, value=val))

    if _peek_type(ts) == T.LBRACKET:
        return parse_list_pattern(ts)

    if _peek_type(ts) == T.LBRACE:
        return parse_record_pattern(ts)

    if _peek_type(ts) == T.DATA:
        ts.advance()
        ts.expect(T.LBRACE)
        ts.expect(T.RBRACE)
        return DataPattern()

    if _peek_type(ts) == T.IDENTIFIER:
        return parse_identifier_or_structured_pattern(ts)

    _err(ts, f"Unexpected token in pattern: {tok.type.name}")


def parse_record_pattern(ts: TokenStream) -> ASTNode:
    ts.expect(T.LBRACE)
    fields: list[InitField] = []
    ts.skip_eols(include_indent=True)
    while _peek_type(ts) == T.DOT:
        ts.expect(T.DOT)
        field_tok = ts.expect(T.IDENTIFIER)
        ts.expect(T.COLON)
        ts.skip_eols(include_indent=True)
        fields.append(InitField(name=field_tok.lexeme, value=parse_pattern(ts)))
        ts.skip_eols(include_indent=True)
        if _peek_type(ts) == T.COMMA:
            ts.advance()
            ts.skip_eols(include_indent=True)
    ts.expect(T.RBRACE)
    return RecordPattern(fields=fields)


def parse_list_pattern(ts: TokenStream) -> ASTNode:
    ts.expect(T.LBRACKET)
    items: list[ASTNode] = []
    rest: str | None = None
    ts.skip_eols(include_indent=True)
    while _peek_type(ts) not in (T.RBRACKET, None):
        if _peek_type(ts) == T.RANGE:
            ts.advance()
            rest = ts.expect(T.IDENTIFIER).lexeme
            break
        if _peek_type(ts) == T.DOT and _peek_next_type(ts) == T.DOT:
            ts.advance()
            ts.advance()
            rest = ts.expect(T.IDENTIFIER).lexeme
            break
        items.append(parse_pattern(ts))
        ts.skip_eols(include_indent=True)
        if not ts.match(T.COMMA):
            break
        ts.skip_eols(include_indent=True)
    ts.expect(T.RBRACKET)
    return ListPattern(items=items, rest=rest)


def parse_identifier_or_structured_pattern(ts: TokenStream) -> ASTNode:
    first = ts.expect(T.IDENTIFIER)

    if _peek_type(ts) == T.DOUBLE_COLON:
        ts.advance()
        variant = ts.expect(T.IDENTIFIER)
        fields: list[InitField] = []
        if _peek_type(ts) == T.LPAREN:
            save = ts.position
            ts.advance()
            ts.skip_eols()
            if _peek_type(ts) in (T.DOT, T.RPAREN):
                if _peek_type(ts) != T.RPAREN:
                    while True:
                        ts.expect(T.DOT)
                        field_tok = ts.expect(T.IDENTIFIER)
                        ts.expect(T.COLON)
                        ts.skip_eols(include_indent=True)
                        fields.append(InitField(name=field_tok.lexeme, value=parse_pattern(ts)))
                        ts.skip_eols(include_indent=True)
                        if _peek_type(ts) == T.COMMA:
                            ts.advance()
                            ts.skip_eols(include_indent=True)
                        if _peek_type(ts) != T.DOT:
                            break
                ts.expect(T.RPAREN)
            else:
                ts.set_position(save)
        return EnumVariantPattern(enum=first.lexeme, variant=variant.lexeme, fields=fields)

    if _peek_type(ts) == T.LPAREN:
        save = ts.position
        ts.advance()
        ts.skip_eols()
        if _peek_type(ts) in (T.DOT, T.RPAREN):
            if _peek_type(ts) != T.RPAREN:
                fields: list[InitField] = []
                while True:
                    ts.expect(T.DOT)
                    field_tok = ts.expect(T.IDENTIFIER)
                    ts.expect(T.COLON)
                    ts.skip_eols(include_indent=True)
                    fields.append(InitField(name=field_tok.lexeme, value=parse_pattern(ts)))
                    ts.skip_eols(include_indent=True)
                    if _peek_type(ts) == T.COMMA:
                        ts.advance()
                        ts.skip_eols(include_indent=True)
                    if _peek_type(ts) != T.DOT:
                        break
                ts.expect(T.RPAREN)
            else:
                fields = []
                ts.advance()
            return StructPattern(name=first.lexeme, fields=fields)
        ts.set_position(save)
        return IdentifierPattern(name=first.lexeme)

    return IdentifierPattern(name=first.lexeme)


def parse_match_arm(ts: TokenStream) -> ASTNode:
    from flux_proto.parser.ast import MatchArm
    from flux_proto.parser.expressions import parse_expression as _pe
    pat = parse_pattern(ts)
    guard = None
    if _peek_type(ts) == T.LPAREN:
        guard = _pe(ts, stop_at_dataflow=True)
    ts.expect(T.DATAFLOW_MAP)
    if _peek_type(ts) == T.LBRACE:
        ts.advance()
        body = _parse_single_arm_body(ts)
        ts.expect(T.RBRACE)
    else:
        body = _pe(ts)
    return MatchArm(pattern=pat, guard=guard, body=body)


def _parse_single_arm_body(ts: TokenStream) -> ASTNode:
    from flux_proto.parser.statements import parse_indented_block_body
    if _peek_type(ts) in (T.LBRACE, T.EOL, T.INDENT):
        return parse_indented_block_body(ts)
    from flux_proto.parser.expressions import parse_expression as _pe
    return _pe(ts)


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
