from flux_proto.token import TokenType


KEYWORD_MAP: dict[str, TokenType] = {
    "_": TokenType.WILDCARD,
    "mut": TokenType.MUT,
    "imut": TokenType.IMUT,
    "true": TokenType.TRUE,
    "false": TokenType.FALSE,
    "True": TokenType.TRUE,
    "False": TokenType.FALSE,
    "struct": TokenType.STRUCT,
    "enum": TokenType.ENUM,
    "contract": TokenType.CONTRACT,
    "impl": TokenType.IMPL,
    "function": TokenType.FUNCTION,
    "and": TokenType.AND_KEYWORD,
    "or": TokenType.OR_KEYWORD,
    "not": TokenType.NOT_KEYWORD,
    "in": TokenType.IN,
    "break": TokenType.BREAK,
    "continue": TokenType.CONTINUE,
    "match": TokenType.MATCH,
    "error": TokenType.ERROR,
    "catch": TokenType.CATCH,
    "ensure": TokenType.ENSURE,
    "fallback": TokenType.FALLBACK,
    "program": TokenType.PROGRAM,
    "emit": TokenType.EMIT,
    "nice": TokenType.NICE,
    "fail": TokenType.FAIL,
    "route": TokenType.ROUTE,
    "infinite": TokenType.INFINITE,
    "split": TokenType.SPLIT,
    "join": TokenType.JOIN,
    "agent": TokenType.AGENT,
    "op": TokenType.OP,
    "use": TokenType.USE,
    "of": TokenType.OF,
    "comptime": TokenType.COMPTIME,
    "macro": TokenType.MACRO,
    "quote": TokenType.QUOTE,
    "unquote": TokenType.UNQUOTE,
    "async": TokenType.ASYNC,
    "spawn": TokenType.SPAWN,
    "await": TokenType.AWAIT,
    "meta": TokenType.MACRO,
    "lift": TokenType.QUOTE,
    "lower": TokenType.UNQUOTE,
    "keep": TokenType.KEEP,
    "move": TokenType.MOVE,
    "borrow": TokenType.BORROW,
    "borrow_mut": TokenType.BORROW_MUT,
    "unsafe": TokenType.UNSAFE,
    "static": TokenType.STATIC,
    "extern": TokenType.EXTERN,
    "fn": TokenType.FUNCTION,
    "print": TokenType.PRINT,
    "input": TokenType.INPUT,
    "spy": TokenType.SPY,
    "data": TokenType.DATA,
    "map": TokenType.MAP,
    "set": TokenType.SET,
    "list": TokenType.LIST,
    "as": TokenType.AS,
}


TYPE_KEYWORDS: set[str] = {
    "int8", "int16", "int32", "int64",
    "uint8", "uint16", "uint32", "uint64",
    "float16", "float32", "float64",
    "fp8_e4m3", "fp8_e5m2",
    "bf16_e8m7", "tf32_e8m10",
    "complex32", "complex64", "complex128",
    "datetime",
    "char", "string", "bool", "data",
    "tensor", "list", "set", "map",
}


def classify(word: str) -> TokenType:
    if word in KEYWORD_MAP:
        return KEYWORD_MAP[word]
    if word in TYPE_KEYWORDS:
        return TokenType.IDENTIFIER
    return TokenType.IDENTIFIER


def is_keyword(word: str) -> bool:
    return word in KEYWORD_MAP
