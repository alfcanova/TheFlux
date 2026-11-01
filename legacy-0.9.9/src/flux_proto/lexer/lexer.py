from typing import Generator

import re

from flux_proto.token import Token, TokenType
from flux_proto.lexer.reader import CharacterReader, LexicalError
from flux_proto.lexer.keywords import classify
from flux_proto.lexer.operators import longest_match, is_operator_start
from flux_proto.lexer.indent import IndentTracker
from flux_proto.lexer.interpolation import InterpolationLexer


def lex(source: str) -> Generator[Token, None, None]:
    reader = CharacterReader(source)
    indent_tracker = IndentTracker()
    token_gen = _tokenize(reader, indent_tracker)
    yield from token_gen
    line = max(reader.line, 1)
    col = reader.column if not reader.is_eof() else 1
    yield Token(TokenType.EOF, "", line, col)


def _tokenize(reader: CharacterReader, indent: IndentTracker) -> Generator[Token, None, None]:
    while not reader.is_eof():
        ch = reader.peek()

        if ch == "\n":
            reader.advance()
            yield Token(TokenType.EOL, "\n", reader.line - 1, 1)
            if indent.bracket_depth == 0:
                indent.set_line_start(True)
            continue

        if ch == "\r":
            reader.advance()
            yield Token(TokenType.EOL, "\n", reader.line - 1, 1)
            if indent.bracket_depth == 0:
                indent.set_line_start(True)
            continue

        if indent.at_line_start:
            if indent.bracket_depth == 0:
                spaces = _count_leading_spaces(reader)
                if reader.is_eof() or reader.peek() in ("\n", "\r"):
                    indent.set_line_start(False)
                    continue
                old_level = indent._levels[-1]
                indent.measure_indent(spaces, reader.line, max(reader.column - spaces, 1))
                if indent._levels[-1] > old_level:
                    yield Token(TokenType.INDENT, "", reader.line, 1)
                while indent.pop_dedent():
                    yield Token(TokenType.DEDENT, "", reader.line, 1)
            indent.set_line_start(False)
            continue

        result = _dispatch_token(reader)
        if result is None:
            continue
        if isinstance(result, Token):
            if result.type in (TokenType.LPAREN, TokenType.LBRACKET):
                indent.on_bracket_open()
            elif result.type in (TokenType.RPAREN, TokenType.RBRACKET):
                indent.on_bracket_close()
            yield result
        else:
            for t in result:
                if t.type in (TokenType.LPAREN, TokenType.LBRACKET):
                    indent.on_bracket_open()
                elif t.type in (TokenType.RPAREN, TokenType.RBRACKET):
                    indent.on_bracket_close()
                yield t

    return


def _dispatch_token(reader: CharacterReader) -> Token | Generator[Token, None, None] | None:
    ch = reader.peek()

    if ch == " ":
        reader.advance()
        return None

    if ch == "#":
        return _handle_hash(reader)

    if ch == '"':
        if _has_interpolation(reader):
            interp = InterpolationLexer(reader)
            return interp.tokenize()
        return _handle_string(reader)

    if ch == "'":
        return _handle_char(reader)

    if ch.isdigit():
        if _is_datetime_start(reader):
            return _handle_datetime(reader)
        return _handle_number(reader)

    if ch in ("+", "-"):
        nxt = reader.peek(1)
        if nxt is not None and (nxt.isdigit() or nxt == "."):
            return _handle_number(reader)

    if ch == ".":
        nxt = reader.peek(1)
        if nxt is not None and nxt.isdigit():
            return _handle_number(reader)

    if ch.isalpha() or ch == "_":
        return _handle_identifier_or_keyword(reader)

    if is_operator_start(ch):
        toktype, lexeme = longest_match(reader._source, reader.position)
        if toktype is not None:
            for _ in lexeme:
                reader.advance()
            return Token(toktype, lexeme, reader.line, reader.column - len(lexeme))

    reader.advance()
    return None


def _has_interpolation(reader: CharacterReader) -> bool:
    saved_pos = reader.position
    saved_line = reader.line
    saved_col = reader.column
    saved_allow = reader._allow_non_ascii
    reader._allow_non_ascii = True
    reader.advance()
    result = False
    while not reader.is_eof():
        ch = reader.peek()
        if ch == '"':
            break
        if ch == "#" and reader.peek(1) == "{":
            result = True
            break
        if ch == "\\":
            reader.advance()
            if not reader.is_eof():
                reader.advance()
        elif ch == "\n" or ch == "\r":
            break
        else:
            reader.advance()
    reader._pos = saved_pos
    reader._line = saved_line
    reader._col = saved_col
    reader._allow_non_ascii = saved_allow
    return result


def _count_leading_spaces(reader: CharacterReader) -> int:
    count = 0
    while not reader.is_eof() and reader.peek() == " ":
        reader.advance()
        count += 1
    return count


def _handle_hash(reader: CharacterReader) -> Generator[Token, None, None]:
    line = reader.line
    col = reader.column
    reader.advance()
    ch = reader.peek()

    if ch == "L":
        reader.advance()
        content = reader.read_line(allow_non_ascii=True)
        return _single_or_gen(Token(TokenType.LINE_COMMENT, content, line, col))

    if ch == "B":
        reader.advance()
        parts: list[str] = []
        while not reader.is_eof():
            if reader.peek() == "B" and reader.peek(1) == "#":
                reader.advance()
                reader.advance()
                break
            c = reader.advance()
            parts.append(c)
        else:
            raise LexicalError(
                "LexicalError", reader.line, reader.column,
                "Unterminated block comment \u2014 expected B#"
            )
        return _single_or_gen(Token(TokenType.BLOCK_COMMENT, "".join(parts), line, col))

    if ch == "D":
        reader.advance()
        if reader.peek() == "\n" or reader.peek() == "\r":
            reader.consume_newline()
        parts: list[str] = []
        while not reader.is_eof():
            if reader.peek() == "D" and reader.peek(1) == "#":
                reader.advance()
                reader.advance()
                break
            c = reader.advance()
            parts.append(c)
        else:
            raise LexicalError(
                "LexicalError", reader.line, reader.column,
                "Unterminated docstring \u2014 expected D#"
            )
        content = "".join(parts)
        return _single_or_gen(Token(TokenType.DOCSTRING, content, line, col))

    raise LexicalError(
        "LEX001", line, col,
        "Invalid '#' - expected '#L' line comment, '#B...B#' block comment or '#D...D#' docstring"
    )


class _SingleTokenGen:
    def __init__(self, token: Token):
        self._token = token
        self._done = False

    def __iter__(self):
        return self

    def __next__(self):
        if self._done:
            raise StopIteration
        self._done = True
        return self._token


class _EmptyGen:
    def __iter__(self):
        return self

    def __next__(self):
        raise StopIteration


def _single_or_gen(token: Token) -> Generator[Token, None, None]:
    return _SingleTokenGen(token)


def _empty_gen() -> Generator[Token, None, None]:
    return _EmptyGen()


def _handle_string(reader: CharacterReader) -> Generator[Token, None, None]:
    line = reader.line
    col = reader.column
    saved_allow = reader._allow_non_ascii
    reader._allow_non_ascii = True
    reader.advance()
    parts: list[str] = []
    try:
        while not reader.is_eof():
            ch = reader.peek()
            if ch == '"':
                reader.advance()
                return _single_or_gen(Token(TokenType.STRING_LIT, "".join(parts), line, col))
            if ch == "\\":
                parts.append(_read_escape(reader))
            elif ch == "\n" or ch == "\r":
                raise LexicalError(
                    "LexicalError", reader.line, reader.column,
                    "Unterminated string literal \u2014 newline before closing quote"
                )
            else:
                parts.append(reader.advance())
        raise LexicalError(
            "LexicalError", reader.line, reader.column,
            "Unterminated string literal \u2014 unexpected end of file"
        )
    finally:
        reader._allow_non_ascii = saved_allow


def _read_escape(reader: CharacterReader) -> str:
    reader.advance()
    if reader.is_eof():
        raise LexicalError(
            "LexicalError", reader.line, reader.column,
            "Incomplete escape sequence at end of file"
        )
    ch = reader.advance()
    escape_map = {
        "'": "'",
        '"': '"',
        "\\": "\\",
        "n": "\n",
        "t": "\t",
        "r": "\r",
        "0": "\0",
    }
    if ch in escape_map:
        return escape_map[ch]
    if ch == "u":
        if reader.is_eof() or reader.peek() != "{":
            raise LexicalError(
                "LexicalError", reader.line, reader.column,
                "Invalid escape sequence: \\u — expected '{'"
            )
        reader.advance()
        digits = []
        while not reader.is_eof() and reader.peek() != "}":
            digits.append(reader.advance())
        if not digits or reader.is_eof():
            raise LexicalError(
                "LexicalError", reader.line, reader.column,
                "Invalid escape sequence: \\u — expected hexadecimal code point"
            )
        reader.advance()
        try:
            cp = int("".join(digits), 16)
        except ValueError:
            raise LexicalError(
                "LexicalError", reader.line, reader.column,
                "Invalid escape sequence: \\u — non-hexadecimal code point"
            )
        if cp > 0x10FFFF or 0xD800 <= cp <= 0xDFFF:
            raise LexicalError(
                "LexicalError", reader.line, reader.column,
                f"Invalid escape sequence: \\u — code point U+{cp:04X} out of range"
            )
        return chr(cp)
    if ord(ch) > 0x7F:
        raise LexicalError(
            "LEX001", reader.line, reader.column,
            f"Non-ASCII byte 0x{ord(ch):02X} in escape sequence"
        )
    raise LexicalError(
        "LexicalError", reader.line, reader.column,
        f"Invalid escape sequence: \\{ch}"
    )


def _handle_char(reader: CharacterReader) -> Token:
    line = reader.line
    col = reader.column
    saved_allow = reader._allow_non_ascii
    reader._allow_non_ascii = True
    try:
        reader.advance()
        if reader.is_eof():
            raise LexicalError(
                "LexicalError", reader.line, reader.column,
                "Unterminated char literal \u2014 unexpected end of file"
            )
        ch = reader.peek()
        if ch == "\\":
            val = _read_escape(reader)
        elif ch == "'":
            raise LexicalError(
                "LexicalError", reader.line, reader.column,
                "Empty char literal"
            )
        else:
            val = reader.advance()
        if reader.is_eof() or reader.peek() != "'":
            raise LexicalError(
                "LexicalError", reader.line, reader.column,
                "Unterminated char literal \u2014 expected closing single quote"
            )
        reader.advance()
        return Token(TokenType.CHAR_LIT, val, line, col)
    finally:
        reader._allow_non_ascii = saved_allow


_DATETIME_RE = re.compile(
    r"\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(?:\.\d{1,9})?(?:Z|[+-]\d{2}(?::?\d{2})?)?"
)


def _is_datetime_start(reader: CharacterReader) -> bool:
    src = reader._source
    p = reader.position
    if p + 16 > len(src):
        return False
    return (
        src[p:p + 4].isdigit() and src[p + 4] == "-"
        and src[p + 5:p + 7].isdigit() and src[p + 7] == "-"
        and src[p + 8:p + 10].isdigit() and src[p + 10] == "T"
        and src[p + 11:p + 13].isdigit() and src[p + 13] == ":"
        and src[p + 14:p + 16].isdigit()
    )


def _handle_datetime(reader: CharacterReader) -> Token:
    line = reader.line
    col = reader.column
    match = _DATETIME_RE.match(reader._source, reader.position)
    if match is None:
        return _handle_number(reader)
    lexeme = match.group(0)
    for _ in lexeme:
        reader.advance()
    return Token(TokenType.DATETIME_LIT, lexeme, line, col)


def _handle_number(reader: CharacterReader) -> Token:
    line = reader.line
    col = reader.column
    neg = False
    if reader.peek() in ("+", "-"):
        sign = reader.advance()
        neg = sign == "-"

    start = reader.position
    _scan_integer(reader)
    is_float = False

    if reader.peek() == ".":
        p1 = reader.peek(1)
        if p1 is not None and (p1.isdigit() or p1 in ("e", "E")):
            is_float = True
            reader.advance()
            if p1.isdigit():
                _scan_digits(reader)
        elif p1 is None or not (p1.isalnum() or p1 == "_" or p1 == "."):
            is_float = True
            reader.advance()

    if reader.peek() in ("e", "E"):
        is_float = True
        reader.advance()
        if reader.peek() in ("+", "-"):
            reader.advance()
        _scan_digits(reader)

    lexeme = ("" if not neg else "-") + reader._source[start : reader.position]

    if reader.peek() in ("i", "j"):
        reader.advance()
        raw = reader._source[start : reader.position]
        lexeme = ("-" if neg else "") + raw
        return Token(TokenType.COMPLEX_LIT, lexeme, line, col)

    if is_float:
        return Token(TokenType.FLOAT_LIT, lexeme, line, col)
    return Token(TokenType.INT_LIT, lexeme, line, col)


def _scan_integer(reader: CharacterReader) -> str:
    parts: list[str] = []
    if reader.peek() == "0":
        parts.append(reader.advance())
        return "0"
    while not reader.is_eof() and reader.peek().isdigit():
        parts.append(reader.advance())
    return "".join(parts)


def _scan_digits(reader: CharacterReader) -> str:
    parts: list[str] = []
    while not reader.is_eof() and reader.peek().isdigit():
        parts.append(reader.advance())
    if not parts:
        raise LexicalError(
            "LexicalError", reader.line, reader.column,
            "Expected digit"
        )
    return "".join(parts)


def _handle_identifier_or_keyword(reader: CharacterReader) -> Token:
    line = reader.line
    col = reader.column
    start = reader.position
    while not reader.is_eof():
        ch = reader.peek()
        if ch.isalnum() or ch == "_":
            reader.advance()
        else:
            break
    word = reader._source[start : reader.position]
    toktype = classify(word)
    return Token(toktype, word, line, col)
