from flux_proto.token import Token, TokenType as T
from flux_proto.parser.token_stream import TokenStream, ParseError
from flux_proto.parser.ast import (
    ASTNode, Parameter, PrimitiveType, UserType,
    UseDecl, UseGroup, UseGroupItem, UseAgent, UseOp,
    StructDef, StructField, EnumDef, EnumMember,
    ContractDef, ContractOpSig, ImplDef,
    AgentDef, AgentBody, OpDecl, OpBody,
    FunctionDef, MacroDef,
    StorageDecl, StorageItem, BlockStmt, ExpressionStmt,
    Identifier,
)


def parse_type_reference(ts: TokenStream) -> ASTNode:
    tok = ts.peek(0)
    if tok is None:
        _err(ts, "Expected type reference")

    if _peek_type(ts) in (T.LIST, T.SET):
        kw_tok = ts.advance()
        ts.expect(T.OF)
        elem = parse_type_reference(ts)
        return UserType(name=f"{kw_tok.lexeme} of {_type_name(elem)}")

    if _peek_type(ts) == T.MAP:
        ts.advance()
        return UserType(name="map")

    if _peek_type(ts) == T.DATA:
        ts.advance()
        return UserType(name="data")

    if _peek_type(ts) == T.IDENTIFIER:
        name_tok = ts.advance()
        name = name_tok.lexeme
        if name == "string" and _peek_type(ts) == T.LPAREN:
            ts.advance()
            size_tok = ts.expect(T.INT_LIT)
            ts.expect(T.RPAREN)
            return UserType(name=f"string({size_tok.lexeme})")
        if _peek_type(ts) == T.DOUBLE_COLON:
            ts.advance()
            member_tok = ts.expect(T.IDENTIFIER)
            return UserType(name=f"{name}::{member_tok.lexeme}")
        if name in ("tensor", "Tensor") and _peek_type(ts) == T.LBRACKET:
            ts.advance()
            dims: list[str] = []
            while _peek_type(ts) != T.RBRACKET:
                dim_tok = ts.expect(T.INT_LIT)
                dims.append(dim_tok.lexeme)
                if not ts.match(T.COMMA):
                    break
            ts.expect(T.RBRACKET)
            elem: ASTNode | None = None
            if _peek_type(ts) == T.OF:
                ts.advance()
                elem = parse_type_reference(ts)
            elem_name = _type_name(elem) if elem is not None else "?"
            return UserType(name=f"tensor[{','.join(dims)}] of {elem_name}")
        return UserType(name=name)

    if _peek_type(ts) == T.LBRACKET:
        ts.advance()
        dims: list[str] = []
        while _peek_type(ts) != T.RBRACKET:
            dim_tok = ts.expect(T.INT_LIT)
            dims.append(dim_tok.lexeme)
            if not ts.match(T.COMMA):
                break
        ts.expect(T.RBRACKET)
        elem: ASTNode | None = None
        if _peek_type(ts) == T.OF:
            ts.advance()
            elem = parse_type_reference(ts)
        elem_name = _type_name(elem) if elem is not None else "?"
        return UserType(name=f"tensor[{','.join(dims)}] of {elem_name}")

    if _peek_type(ts) == T.STAR:
        ts.advance()
        qual = ""
        if _peek_type(ts) == T.IDENTIFIER and ts.peek(0).lexeme in ("const", "mut"):
            qual = ts.advance().lexeme
        inner = parse_type_reference(ts)
        prefix = f"*{qual} " if qual else "*"
        return UserType(name=f"{prefix}{_type_name(inner)}")

    if _peek_type(ts) == T.LBRACKET:
        ts.advance()
        elem = parse_type_reference(ts)
        ts.expect(T.RBRACKET)
        return UserType(name=f"[{_type_name(elem)}]")

    if _peek_type(ts) == T.MUT:
        ts.advance()
        inner = parse_type_reference(ts)
        return UserType(name=f"mut {_type_name(inner)}")

    if _peek_type(ts) == T.IMUT:
        ts.advance()
        inner = parse_type_reference(ts)
        return UserType(name=f"imut {_type_name(inner)}")

    _err(ts, f"Unexpected token in type reference: {tok.type.name}")


def _type_name(node: ASTNode) -> str:
    if isinstance(node, PrimitiveType):
        return node.name
    if isinstance(node, UserType):
        return node.name
    if isinstance(node, Identifier):
        return node.name
    return "?"


def parse_parameters(ts: TokenStream, require_as: bool = False) -> list[Parameter]:
    params: list[Parameter] = []
    ts.expect(T.LPAREN)
    ts.skip_eols()
    while _peek_type(ts) not in (T.RPAREN, None):
        param = _parse_parameter(ts, require_as=require_as)
        params.append(param)
        if not ts.match(T.COMMA):
            break
        ts.skip_eols()
    ts.skip_eols()
    ts.expect(T.RPAREN)
    return params


def _expect_param_colon(ts: TokenStream) -> None:
    if _peek_type(ts) == T.COLON:
        ts.advance()
        return
    tok = ts.peek(0)
    found = f"{tok.type.name} ('{tok.lexeme}')" if tok is not None else "end of input"
    line = tok.line if tok is not None else 0
    column = tok.column if tok is not None else 0
    raise ParseError(
        "PAR001", line, column,
        f"Expected ':' between the parameter type and its name "
        f"(e.g. 'as int64: nome'); found {found}"
    )


def _parse_function_params(ts: TokenStream) -> list[Parameter]:
    ts.expect(T.LPAREN)
    ts.skip_eols()
    params: list[Parameter] = []
    while _peek_type(ts) not in (T.RPAREN, None):
        head = _parse_parameter(ts, require_as=True)
        params.append(head)
        ts.skip_eols()
        while True:
            if not ts.match(T.COMMA):
                break
            ts.skip_eols()
            nxt = _peek_type(ts)
            if nxt == T.IDENTIFIER:
                tok = ts.advance()
                params.append(Parameter(name=tok.lexeme, type_ref=head.type_ref,
                                        mutable=head.mutable))
                ts.skip_eols()
                if _peek_type(ts) in (T.MUT, T.IMUT, T.AS):
                    after = ts.peek(0)
                    raise ParseError(
                        "PAR001", after.line if after else 0, after.column if after else 0,
                        f"Parameter '{tok.lexeme} {after.lexeme} ...' is not valid: declare "
                        f"each typed parameter as 'as <type>: <name>' (e.g. 'as int64: "
                        f"{tok.lexeme}'), optionally prefixed with 'mut' or 'imut'; placing "
                        f"'as <type>' after the name is not valid"
                    )
                continue
            if nxt in (T.MUT, T.IMUT, T.AS):
                break
            if nxt == T.RPAREN or nxt is None:
                tok = ts.peek(0)
                raise ParseError(
                    "PAR001", tok.line if tok else 0, tok.column if tok else 0,
                    "Unexpected ',' before ')': trailing separators are not allowed in "
                    "the parameter list"
                )
            tok = ts.peek(0)
            raise ParseError(
                "PAR001", tok.line if tok else 0, tok.column if tok else 0,
                f"Expected a parameter name continuing the group of type "
                f"'{_type_name(head.type_ref)}', or 'as'/'mut'/'imut' starting a new "
                f"group; found {tok.type.name} ('{tok.lexeme}')"
            )
        if not ts.match(T.SEMICOLON):
            continue
        ts.skip_eols()
        nxt = _peek_type(ts)
        if nxt is None:
            raise ParseError("PAR001", 0, 0,
                             "Unexpected end of input after ';' in the parameter list")
        if nxt == T.RPAREN:
            tok = ts.peek(0)
            raise ParseError(
                "PAR001", tok.line, tok.column,
                "Unexpected ';' before ')': trailing separators are not allowed in "
                "the parameter list"
            )
        if nxt not in (T.MUT, T.IMUT, T.AS):
            tok = ts.peek(0)
            raise ParseError(
                "PAR001", tok.line, tok.column,
                f"Expected '[mut | imut | as] <type>: <name>' starting a new parameter "
                f"group after ';'; found {tok.type.name} ('{tok.lexeme}')"
            )
    ts.skip_eols()
    ts.expect(T.RPAREN)
    return params


def _parse_parameter(ts: TokenStream, require_as: bool = False) -> Parameter:
    if _peek_type(ts) == T.MUT:
        ts.advance()
        ts.expect(T.AS)
        type_ref = parse_type_reference(ts)
        _expect_param_colon(ts)
        name_tok = ts.expect(T.IDENTIFIER)
        return Parameter(name=name_tok.lexeme, type_ref=type_ref, mutable=True)
    if _peek_type(ts) == T.IMUT:
        ts.advance()
        ts.expect(T.AS)
        type_ref = parse_type_reference(ts)
        _expect_param_colon(ts)
        name_tok = ts.expect(T.IDENTIFIER)
        return Parameter(name=name_tok.lexeme, type_ref=type_ref, mutable=False)
    if _peek_type(ts) == T.AS:
        ts.advance()
        type_ref = parse_type_reference(ts)
        _expect_param_colon(ts)
        name_tok = ts.expect(T.IDENTIFIER)
        return Parameter(name=name_tok.lexeme, type_ref=type_ref, mutable=False)
    if require_as:
        tok = ts.peek(0)
        if tok is not None:
            raise ParseError(
                "PAR001", tok.line, tok.column,
                f"Parameter '{tok.lexeme}' is missing 'as <type>': parameters must be declared as "
                f"'as <type>: <name>' (e.g. 'as int64: dividendo'), optionally prefixed with "
                f"'mut' or 'imut'; placing 'as <type>' after the name is not valid"
            )
    name_tok = ts.expect(T.IDENTIFIER)
    type_ref: ASTNode | None = None
    if _peek_type(ts) == T.COLON:
        ts.advance()
        type_ref = parse_type_reference(ts)
    return Parameter(name=name_tok.lexeme, type_ref=type_ref)


def parse_use_decl(ts: TokenStream) -> UseDecl:
    ts.expect(T.USE)
    if _peek_type(ts) == T.LBRACE:
        return _parse_use_group(ts)

    target = _parse_use_target(ts)
    return UseDecl(target=target)


def _parse_use_group(ts: TokenStream, agent: str = "") -> ASTNode:
    ts.expect(T.LBRACE)
    items: list[ASTNode] = []
    while _peek_type(ts) not in (T.RBRACE, None):
        while _peek_type(ts) in (T.EOL, T.INDENT, T.DEDENT):
            ts.advance()
        if _peek_type(ts) in (T.RBRACE, None):
            break
        target = _parse_use_target(ts)
        items.append(target)
        while _peek_type(ts) in (T.EOL, T.INDENT, T.DEDENT):
            ts.advance()
        if not ts.match(T.COMMA):
            break
    ts.expect(T.RBRACE)
    group = UseGroup(agent=agent, items=[_to_group_item(x) for x in items])
    if agent:
        for it in group.items:
            it.agent = agent
    return UseDecl(target=group) if not agent else group


def _parse_use_target(ts: TokenStream) -> ASTNode:
    segments: list[str] = []
    segments.append(ts.expect(T.IDENTIFIER).lexeme)
    while _peek_type(ts) == T.DOUBLE_COLON:
        ts.advance()
        if _peek_type(ts) == T.LBRACE:
            return _parse_use_group(ts, agent=segments[0])
        segments.append(ts.expect(T.IDENTIFIER).lexeme)

    alias = None
    if _peek_type(ts) == T.AS:
        ts.advance()
        alias = ts.expect(T.IDENTIFIER).lexeme

    if len(segments) == 1:
        return UseAgent(name=segments[0], alias=alias)
    return UseOp(agent=segments[0], op=segments[1], alias=alias or "")


def _to_group_item(node: ASTNode) -> UseGroupItem:
    if isinstance(node, UseAgent):
        return UseGroupItem(name=node.name, alias=node.alias)
    if isinstance(node, UseOp):
        return UseGroupItem(name=node.op, alias=node.alias or None, agent=node.agent)
    return UseGroupItem(name="")


def parse_struct_decl(ts: TokenStream) -> StructDef:
    ts.expect(T.STRUCT)
    ts.expect(T.LPAREN)
    name_tok = ts.expect(T.IDENTIFIER)
    ts.expect(T.RPAREN)
    fields: list[StructField] = []
    if _peek_type(ts) == T.LBRACE:
        ts.advance()
        while _peek_type(ts) not in (T.RBRACE, None):
            if _peek_type(ts) in (T.EOL, T.INDENT, T.DEDENT):
                ts.advance()
                continue
            fields.append(_parse_struct_field(ts, require_mut=True))
        ts.expect(T.RBRACE)
    _validate_struct_decl(fields, name_tok)
    return StructDef(name=name_tok.lexeme, fields=fields)


def _validate_struct_decl(fields: list[StructField], name_tok: Token) -> None:
    if not fields:
        raise ParseError("PAR001", name_tok.line, name_tok.column,
                         f"struct '{name_tok.lexeme}' must have at least one field")
    seen: set[str] = set()
    for f in fields:
        if f.name in seen:
            raise ParseError("PAR001", name_tok.line, name_tok.column,
                             f"duplicate field '{f.name}' in struct '{name_tok.lexeme}'")
        seen.add(f.name)


def _parse_struct_field(ts: TokenStream, require_mut: bool = False) -> StructField:
    mutable = True
    if _peek_type(ts) == T.MUT:
        ts.advance()
        mutable = True
    elif _peek_type(ts) == T.IMUT:
        ts.advance()
        mutable = False
    else:
        if require_mut:
            _err(ts, "Expected mut or imut for struct field")
    if _peek_type(ts) == T.COLON:
        ts.advance()
    if _peek_type(ts) != T.DOT:
        _err(ts, "Expected '.' before field name")
    ts.advance()
    name_tok = ts.expect(T.IDENTIFIER)
    ts.expect(T.COLON)
    type_ref = parse_type_reference(ts)
    if _peek_type(ts) == T.EOL:
        ts.advance()
    return StructField(name=name_tok.lexeme, type_ref=type_ref, mutable=mutable)


def parse_enum_decl(ts: TokenStream) -> EnumDef:
    ts.expect(T.ENUM)
    ts.expect(T.LPAREN)
    name_tok = ts.expect(T.IDENTIFIER)
    ts.expect(T.RPAREN)
    if _peek_type(ts) == T.AS:
        _err(ts, "explicit enum discriminants ('as <tipo>') are not supported")
    members: list[EnumMember] = []
    if _peek_type(ts) == T.LBRACE:
        ts.advance()
        while _peek_type(ts) in (T.EOL, T.INDENT):
            ts.advance()
        while _peek_type(ts) not in (T.RBRACE, T.DEDENT, None):
            if _peek_type(ts) in (T.EOL, T.INDENT, T.DEDENT):
                ts.advance()
                continue
            members.append(_parse_enum_member(ts))
        if _peek_type(ts) == T.DEDENT:
            ts.advance()
        ts.expect(T.RBRACE)
    _validate_enum_decl(members, name_tok)
    return EnumDef(name=name_tok.lexeme, members=members)


def _validate_enum_decl(members: list[EnumMember], name_tok: Token) -> None:
    if not members:
        raise ParseError("PAR001", name_tok.line, name_tok.column,
                         f"enum '{name_tok.lexeme}' must have at least one variant")
    seen: set[str] = set()
    for m in members:
        if m.name in seen:
            raise ParseError("PAR001", name_tok.line, name_tok.column,
                             f"duplicate variant '{m.name}' in enum '{name_tok.lexeme}'")
        seen.add(m.name)
        fseen: set[str] = set()
        for fld in m.fields:
            if fld.name in fseen:
                raise ParseError("PAR001", name_tok.line, name_tok.column,
                                 f"duplicate field '{fld.name}' in variant '{m.name}'")
            fseen.add(fld.name)


def _parse_enum_member(ts: TokenStream) -> EnumMember:
    name_tok = ts.expect(T.IDENTIFIER)
    fields: list[StructField] = []
    if _peek_type(ts) == T.LPAREN:
        ts.advance()
        ts.skip_eols()
        while _peek_type(ts) == T.DOT:
            fields.append(_parse_struct_field(ts))
            ts.skip_eols()
        ts.expect(T.RPAREN)
    if _peek_type(ts) == T.EOL:
        ts.advance()
    return EnumMember(name=name_tok.lexeme, fields=fields)


def parse_contract_decl(ts: TokenStream) -> ContractDef:
    ts.expect(T.CONTRACT)
    if _peek_type(ts) == T.LPAREN:
        ts.advance()
        name_tok = ts.expect(T.IDENTIFIER)
        ts.expect(T.RPAREN)
    else:
        name_tok = ts.expect(T.IDENTIFIER)
    op_sigs: list[ContractOpSig] = []
    if _peek_type(ts) == T.LBRACE:
        ts.advance()
        if _peek_type(ts) == T.EOL:
            ts.advance()
        while _peek_type(ts) not in (T.RBRACE, None):
            if _peek_type(ts) in (T.EOL, T.INDENT, T.DEDENT):
                ts.advance()
                continue
            op_sigs.append(_parse_op_signature(ts))
        ts.expect(T.RBRACE)
    return ContractDef(name=name_tok.lexeme, op_signatures=op_sigs)


def _parse_op_signature(ts: TokenStream) -> ContractOpSig:
    if _peek_type(ts) == T.OP:
        ts.advance()
    name_tok = ts.expect(T.IDENTIFIER)
    params = []
    if _peek_type(ts) == T.LPAREN:
        ts.expect(T.LPAREN)
        while _peek_type(ts) not in (T.RPAREN, None):
            params.append(_parse_parameter(ts))
            if not ts.match(T.COMMA):
                break
        ts.expect(T.RPAREN)
    return_type: ASTNode | None = None
    if _peek_type(ts) == T.AS:
        ts.advance()
        return_type = parse_type_reference(ts)
    elif _peek_type(ts) in (T.COLON, T.DATAFLOW_MAP):
        ts.advance()
        return_type = parse_type_reference(ts)
    if _peek_type(ts) == T.EOL:
        ts.advance()
    return ContractOpSig(name=name_tok.lexeme, params=params, return_type=return_type)


def parse_impl_decl(ts: TokenStream) -> ImplDef:
    ts.expect(T.IMPL)
    for_type: str | None = None
    name: str = ""

    if _peek_type(ts) == T.IDENTIFIER:
        name_tok = ts.advance()
        name = name_tok.lexeme

    if _peek_type(ts) == T.FOR:
        ts.advance()
        for_tok = ts.expect(T.IDENTIFIER)
        for_type = for_tok.lexeme

    items: list[ASTNode] = []
    if _peek_type(ts) == T.LBRACE:
        ts.advance()
        if _peek_type(ts) == T.EOL:
            ts.advance()
        while _peek_type(ts) not in (T.RBRACE, None):
            if _peek_type(ts) == T.FUNCTION:
                items.append(parse_function_decl(ts))
            elif _peek_type(ts) == T.OP:
                items.append(parse_op_decl(ts))
            else:
                _err(ts, f"Unexpected token in impl block: {ts.peek(0).type.name}")
        ts.expect(T.RBRACE)
    return ImplDef(name=name, for_type=for_type, items=items)


def parse_op_decl(ts: TokenStream) -> OpDecl:
    ts.expect(T.OP)
    name_tok = ts.expect(T.IDENTIFIER)
    left_type: ASTNode | None = None
    right_type: ASTNode | None = None
    return_type: ASTNode | None = None
    body: OpBody | None = None
    params: list[Parameter] = []

    if _peek_type(ts) == T.LPAREN:
        ts.advance()
        ts.skip_eols()
        while _peek_type(ts) not in (T.RPAREN, None):
            params.append(_parse_parameter(ts))
            ts.skip_eols()
            if not ts.match(T.COMMA):
                break
            ts.skip_eols()
        ts.expect(T.RPAREN)

    if _peek_type(ts) == T.AS:
        ts.advance()
        return_type = parse_type_reference(ts)
    elif _peek_type(ts) == T.COLON:
        ts.advance()
        return_type = parse_type_reference(ts)
    elif _peek_type(ts) == T.DATAFLOW_MAP:
        if ts.peek(1) is not None and ts.peek(1).type != T.LBRACE:
            ts.advance()
            return_type = parse_type_reference(ts)

    if _peek_type(ts) == T.DATAFLOW_MAP:
        ts.advance()

    if _peek_type(ts) == T.LBRACE:
        body = _parse_op_body(ts)

    return OpDecl(name=name_tok.lexeme, left_type=left_type, right_type=right_type,
                  return_type=return_type, body=body, params=params)


def _parse_op_body(ts: TokenStream) -> OpBody:
    from flux_proto.parser.statements import parse_indented_block_body
    ts.expect(T.LBRACE)
    body = parse_indented_block_body(ts)
    ts.expect(T.RBRACE)
    if isinstance(body, BlockStmt):
        return OpBody(expressions=body.body)
    return OpBody(expressions=[body])


def parse_agent_decl(ts: TokenStream) -> AgentDef:
    ts.expect(T.AGENT)
    if _peek_type(ts) == T.LPAREN:
        ts.advance()
        name_tok = ts.expect(T.IDENTIFIER)
        ts.expect(T.RPAREN)
    else:
        name_tok = ts.expect(T.IDENTIFIER)
    impl_names: list[str] = []
    if _peek_type(ts) == T.IMPL:
        ts.advance()
        impl_names.append(ts.expect(T.IDENTIFIER).lexeme)
        while _peek_type(ts) == T.COMMA:
            ts.advance()
            impl_names.append(ts.expect(T.IDENTIFIER).lexeme)
    body: AgentBody | None = None
    if _peek_type(ts) == T.LBRACE:
        body = _parse_agent_body(ts)
    return AgentDef(name=name_tok.lexeme, body=body, impl_contracts=impl_names)


def _parse_agent_body(ts: TokenStream) -> AgentBody:
    ts.expect(T.LBRACE)
    while _peek_type(ts) in (T.EOL, T.INDENT):
        ts.advance()
    storages: list[ASTNode] = []
    functions: list[FunctionDef] = []
    ops: list[OpDecl] = []
    while _peek_type(ts) not in (T.RBRACE, T.DEDENT, None):
        if _peek_type(ts) in (T.MUT, T.IMUT):
            storages.append(parse_storage_decl(ts))
        elif _peek_type(ts) == T.FUNCTION:
            functions.append(parse_function_decl(ts))
        elif _peek_type(ts) == T.OP:
            ops.append(parse_op_decl(ts))
        elif _peek_type(ts) in (T.EOL, T.INDENT, T.DEDENT):
            ts.advance()
        else:
            _err(ts, f"Unexpected token in agent body: {ts.peek(0).type.name}")
    if _peek_type(ts) == T.DEDENT:
        ts.advance()
    ts.expect(T.RBRACE)
    return AgentBody(storages=storages, functions=functions, ops=ops)


def parse_function_decl(ts: TokenStream) -> FunctionDef:
    is_async = False
    if _peek_type(ts) == T.ASYNC:
        ts.advance()
        is_async = True
    ts.expect(T.FUNCTION)
    if _peek_type(ts) == T.LPAREN:
        ts.advance()
        name_tok = ts.expect(T.IDENTIFIER)
        ts.expect(T.RPAREN)
    else:
        name_tok = ts.expect(T.IDENTIFIER)
    params = _parse_function_params(ts)
    return_type: ASTNode | None = None
    if _peek_type(ts) == T.COLON:
        tok = ts.peek(0)
        raise ParseError(
            "PAR001", tok.line if tok else 0, tok.column if tok else 0,
            f"Function '({name_tok.lexeme})': return type must use 'as <type>' after the "
            f"parameter list (e.g. ') as int64 {{'); found ':' — the old ': <type>' form is not valid"
        )
    if _peek_type(ts) == T.AS:
        ts.advance()
        return_type = parse_type_reference(ts)
    elif _peek_type(ts) == T.DATAFLOW_MAP:
        ts.advance()
        return_type = parse_type_reference(ts)
    body: BlockStmt | None = None
    if _peek_type(ts) == T.LBRACE:
        body = _parse_function_body(ts)
    return FunctionDef(name=name_tok.lexeme, params=params, return_type=return_type, body=body, is_async=is_async)


def _parse_function_body(ts: TokenStream) -> BlockStmt:
    from flux_proto.parser.statements import parse_indented_block_body
    ts.expect(T.LBRACE)
    body = parse_indented_block_body(ts)
    ts.expect(T.RBRACE)
    return BlockStmt(body=[body]) if not isinstance(body, BlockStmt) else body


def parse_macro_decl(ts: TokenStream) -> MacroDef:
    ts.expect(T.MACRO)
    name_tok = ts.expect(T.IDENTIFIER)
    params: list[Parameter] = []
    if _peek_type(ts) == T.LPAREN:
        ts.expect(T.LPAREN)
        ts.skip_eols()
        while _peek_type(ts) not in (T.RPAREN, None):
            params.append(_parse_parameter(ts))
            if not ts.match(T.COMMA):
                break
            ts.skip_eols()
        ts.skip_eols()
        ts.expect(T.RPAREN)
    body: ASTNode | None = None
    if _peek_type(ts) == T.LBRACE:
        from flux_proto.parser.statements import parse_indented_block_body
        ts.expect(T.LBRACE)
        body = parse_indented_block_body(ts)
        ts.expect(T.RBRACE)
    return MacroDef(name=name_tok.lexeme, params=params, body=body)


def parse_storage_decl(ts: TokenStream) -> StorageDecl:
    kw_tok = ts.advance()
    mutable = kw_tok.type == T.MUT
    items: list[StorageItem] = []
    if _peek_type(ts) == T.AS:
        ts.advance()
        type_ref = parse_type_reference(ts)
        ts.expect(T.COLON)
        name_tok = ts.expect(T.IDENTIFIER)
        names = [(name_tok.lexeme, name_tok.line, name_tok.column)]
        while _peek_type(ts) == T.COMMA:
            ts.advance()
            name_tok = ts.expect(T.IDENTIFIER)
            names.append((name_tok.lexeme, name_tok.line, name_tok.column))
        init: ASTNode | None = None
        if _peek_type(ts) == T.EQ:
            ts.advance()
            init = _parse_storage_init(ts)
            if _peek_type(ts) == T.COMMA:
                _err(ts, "Per-variable initializers not supported: use separate declarations")
        if _peek_type(ts) == T.EOL:
            ts.advance()
        items.extend(
            StorageItem(name=name, type_ref=type_ref, initializer=init, mutable=mutable,
                        line=line, column=column)
            for name, line, column in names
        )
    else:
        _err(ts, f"Expected 'as <type>' after '{kw_tok.lexeme}': type is mandatory")
    return StorageDecl(items=items)


def _parse_storage_init(ts: TokenStream) -> ASTNode:
    from flux_proto.parser.expressions import parse_expression
    return parse_expression(ts)


def _peek_type(ts: TokenStream) -> T | None:
    tok = ts.peek(0)
    return tok.type if tok is not None else None


def _err(ts: TokenStream, msg: str) -> None:
    tok = ts.peek(0)
    if tok is not None:
        raise ParseError("PAR001", tok.line, tok.column, msg)
    raise ParseError("PAR001", 0, 0, msg)
