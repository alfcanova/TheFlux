from typing import Generator

from flux_proto.token import Token, TokenType as T
from flux_proto.parser.token_stream import TokenStream, ParseError
from flux_proto.parser.expressions import parse_expression
from flux_proto.parser.statements import parse_block, parse_block_body, parse_indented_block_body, parse_statement
from flux_proto.parser.declarations import (
    parse_use_decl, parse_struct_decl, parse_enum_decl,
    parse_contract_decl, parse_agent_decl,
    parse_function_decl, parse_macro_decl, parse_storage_decl,
)
from flux_proto.parser.ast import (
    ASTNode, FluxProgram, FdslFile, UseDecl, MacroDef,
    StructDef, EnumDef, ContractDef, StorageDecl,
    FunctionDef, AgentDef, BlockStmt,
)


def parse(tokens: Generator[Token, None, None], source_path: str) -> ASTNode:
    ts = TokenStream(tokens)
    if source_path.endswith(".fdsl"):
        return parse_fdsl_file(ts)
    return parse_flux_file(ts)


def parse_flux_file(ts: TokenStream) -> FluxProgram:
    result = FluxProgram()
    _skip_eols(ts)
    while ts.peek(0) is not None and ts.peek(0).type != T.EOF:
        _skip_eols(ts)
        docstring = _collect_pending_docstring(ts)
        _skip_eols(ts)
        tok = ts.peek(0)
        if tok is None or tok.type == T.EOF:
            break
        if tok.type == T.USE:
            decl = parse_use_decl(ts)
            result.use_decls.append(decl)
        elif tok.type == T.STRUCT:
            decl = parse_struct_decl(ts)
            decl.docstring = docstring
            result.structs.append(decl)
        elif tok.type == T.ENUM:
            decl = parse_enum_decl(ts)
            decl.docstring = docstring
            result.enums.append(decl)
        elif tok.type == T.CONTRACT:
            decl = parse_contract_decl(ts)
            decl.docstring = docstring
            result.contracts.append(decl)
        elif tok.type == T.MUT or tok.type == T.IMUT:
            decl = parse_storage_decl(ts)
            decl.docstring = docstring
            result.storages.append(decl)
        elif tok.type in (T.FUNCTION, T.ASYNC):
            decl = parse_function_decl(ts)
            decl.docstring = docstring
            result.functions.append(decl)
        elif tok.type == T.MACRO:
            decl = parse_macro_decl(ts)
            decl.docstring = docstring
            result.macros.append(decl)
        elif tok.type == T.PROGRAM:
            result.name = _parse_program_name(ts)
            _skip_eols(ts)
            result.body = parse_block(ts)
            _skip_eols(ts)
            if ts.peek(0) is not None and ts.peek(0).type != T.EOF:
                _err(ts, "Unexpected declarations after program body")
            break
        else:
            stmts: list[ASTNode] = []
            while ts.peek(0) is not None and ts.peek(0).type != T.EOF:
                _skip_eols(ts)
                if ts.peek(0) is None or ts.peek(0).type == T.EOF:
                    break
                stmts.append(parse_statement(ts))
            result.body = BlockStmt(body=stmts) if len(stmts) != 1 else (stmts[0] if isinstance(stmts[0], BlockStmt) else BlockStmt(body=stmts))
            break
    return result


def parse_fdsl_file(ts: TokenStream) -> FdslFile:
    result = FdslFile()
    _skip_eols(ts)
    while ts.peek(0) is not None and ts.peek(0).type != T.EOF:
        docstring = _collect_pending_docstring(ts)
        _skip_eols(ts)
        tok = ts.peek(0)
        if tok is None or tok.type == T.EOF:
            break
        if tok.type == T.USE:
            decl = parse_use_decl(ts)
            result.use_decls.append(decl)
        elif tok.type == T.STRUCT:
            decl = parse_struct_decl(ts)
            decl.docstring = docstring
            result.structs.append(decl)
        elif tok.type == T.ENUM:
            decl = parse_enum_decl(ts)
            decl.docstring = docstring
            result.enums.append(decl)
        elif tok.type == T.CONTRACT:
            decl = parse_contract_decl(ts)
            decl.docstring = docstring
            result.contracts.append(decl)
        elif tok.type == T.MUT or tok.type == T.IMUT:
            decl = parse_storage_decl(ts)
            decl.docstring = docstring
            result.storages.append(decl)
        elif tok.type in (T.FUNCTION, T.ASYNC):
            decl = parse_function_decl(ts)
            decl.docstring = docstring
            result.functions.append(decl)
        elif tok.type == T.AGENT:
            decl = parse_agent_decl(ts)
            decl.docstring = docstring
            result.agents.append(decl)
        elif tok.type == T.PROGRAM:
            _err(ts, "program declaration not allowed in .fdsl file")
        else:
            _err(ts, f"Unexpected token in fdsl file: {tok.type.name}")
    if not result.agents:
        _err(ts, "fdsl file must contain at least one agent declaration")
    return result


def _parse_program_name(ts: TokenStream) -> str:
    ts.expect(T.PROGRAM)
    ts.expect(T.LPAREN)
    name_tok = ts.expect(T.IDENTIFIER)
    ts.expect(T.RPAREN)
    return name_tok.lexeme


def _collect_pending_docstring(ts: TokenStream) -> str | None:
    parts: list[str] = []
    while True:
        tok = ts.peek(0)
        if tok is None or tok.type != T.DOCSTRING:
            break
        ts.advance()
        parts.append(tok.lexeme)
    return "".join(parts) if parts else None


def _skip_eols(ts: TokenStream) -> None:
    while ts.match(T.EOL):
        pass


def _err(ts: TokenStream, msg: str) -> None:
    tok = ts.peek(0)
    if tok is not None:
        raise ParseError("PAR001", tok.line, tok.column, msg)
    raise ParseError("PAR001", 0, 0, msg)
