from flux_proto.token import TokenType


_LEAF = "__LEAF__"


def _build_trie(pairs: list[tuple[str, TokenType]]) -> dict:
    root: dict = {}
    for text, toktype in pairs:
        node = root
        for ch in text:
            if ch not in node:
                node[ch] = {}
            node = node[ch]
        node[_LEAF] = toktype
    return root


_OPERATOR_PAIRS: list[tuple[str, TokenType]] = [
    # Assignment operators (longest first)
    ("=>>>", TokenType.ASSIGN_SHRA),
    ("=>>", TokenType.ASSIGN_SHR),
    ("=<<", TokenType.ASSIGN_SHL),
    ("=~", TokenType.ASSIGN_NOT),
    ("=^e", TokenType.ASSIGN_POWE),
    ("=^r", TokenType.ASSIGN_POWR),
    ("=^", TokenType.ASSIGN_XOR),
    ("=|", TokenType.ASSIGN_OR),
    ("=&", TokenType.ASSIGN_AND),
    ("=/f", TokenType.ASSIGN_DIVF),
    ("=/i", TokenType.ASSIGN_DIVI),
    ("=/r", TokenType.ASSIGN_DIVR),
    ("=*", TokenType.ASSIGN_MUL),
    ("=+", TokenType.ASSIGN_ADD),
    ("=-", TokenType.ASSIGN_SUB),
    ("=", TokenType.EQ),
    # Dataflow
    ("-->", TokenType.DATAFLOW),
    ("==>", TokenType.DATAFLOW_MAP),
    # Shift
    (">>>", TokenType.SHIFT_LOGICAL),
    (">>", TokenType.SHIFT_RIGHT),
    ("<<", TokenType.SHIFT_LEFT),
    # Relational
    ("==", TokenType.EQEQ),
    ("!=", TokenType.NEQ),
    ("<=", TokenType.LTE),
    (">=", TokenType.GTE),
    ("<", TokenType.LT),
    (">", TokenType.GT),
    # Range
    ("..", TokenType.RANGE),
    # Power
    ("^e", TokenType.POW_REAL),
    ("^r", TokenType.POW_RCP),
    # Bitwise
    ("|", TokenType.OR),
    ("^", TokenType.XOR),
    ("&", TokenType.AND),
    ("~", TokenType.TILDE),
    # Arithmetic
    ("+", TokenType.PLUS),
    ("-", TokenType.MINUS),
    ("*", TokenType.STAR),
    ("/f", TokenType.DIV_FLOOR),
    ("/i", TokenType.DIV_INT),
    ("/r", TokenType.DIV_REM),
    # Postfix
    (".", TokenType.DOT),
    ("::", TokenType.DOUBLE_COLON),
    # Delimiters
    ("(", TokenType.LPAREN),
    (")", TokenType.RPAREN),
    ("{", TokenType.LBRACE),
    ("}", TokenType.RBRACE),
    ("[", TokenType.LBRACKET),
    ("]", TokenType.RBRACKET),
    (",", TokenType.COMMA),
    (":", TokenType.COLON),
    (";", TokenType.SEMICOLON),
    # Prefix
    ("?", TokenType.QUESTION),
    ("!", TokenType.NOT),
]

_OPERATOR_TRIE: dict = _build_trie(_OPERATOR_PAIRS)


def longest_match(source: str, start: int) -> tuple[TokenType | None, str]:
    if start >= len(source):
        return None, ""
    node = _OPERATOR_TRIE
    matched_type: TokenType | None = None
    matched_len = 0
    pos = start
    while pos < len(source) and source[pos] in node:
        ch = source[pos]
        node = node[ch]
        pos += 1
        if _LEAF in node:
            matched_type = node[_LEAF]
            matched_len = pos - start
    if matched_type is not None:
        return matched_type, source[start : start + matched_len]
    return None, ""


def is_operator_start(ch: str) -> bool:
    return ch in _OPERATOR_TRIE
