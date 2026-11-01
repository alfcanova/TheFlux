from typing import Generator

from flux_proto.token import Token, TokenType
from flux_proto.lexer.reader import CharacterReader, LexicalError


class InterpolationLexer:
    def __init__(self, reader: CharacterReader):
        self._reader = reader

    def tokenize(self) -> Generator[Token, None, None]:
        reader = self._reader
        line = reader.line
        col = reader.column
        saved_allow = reader._allow_non_ascii
        reader._allow_non_ascii = True
        try:
            reader.advance()

            yield Token(TokenType.INTERPOLATED_STRING_START, '"', line, col)

            text_buffer: list[str] = []

            while not reader.is_eof():
                ch = reader.peek()

                if ch == '"':
                    reader.advance()
                    if text_buffer:
                        yield Token(TokenType.INTERPOLATED_TEXT, "".join(text_buffer), line, col)
                    yield Token(TokenType.INTERPOLATED_STRING_END, '"', reader.line, reader.column - 1)
                    return

                if ch == "#" and reader.peek(1) == "{":
                    if text_buffer:
                        yield Token(TokenType.INTERPOLATED_TEXT, "".join(text_buffer), line, col)
                        text_buffer = []
                    reader.advance()
                    reader.advance()
                    yield Token(TokenType.INTERPOLATION_OPEN, "#{", reader.line, reader.column - 2)
                    yield from self._tokenize_expression()
                    continue

                if ch == "\\":
                    text_buffer.append(_read_interp_escape(reader))
                elif ch == "\n" or ch == "\r":
                    raise LexicalError(
                        "LexicalError", reader.line, reader.column,
                        "Unterminated interpolated string \u2014 newline before closing quote"
                    )
                else:
                    text_buffer.append(reader.advance())

            raise LexicalError(
                "LexicalError", reader.line, reader.column,
                "Unterminated interpolated string \u2014 unexpected end of file"
            )
        finally:
            reader._allow_non_ascii = saved_allow

    def _tokenize_expression(self) -> Generator[Token, None, None]:
        reader = self._reader
        brace_depth = 1

        from flux_proto.lexer.lexer import _dispatch_token

        while not reader.is_eof() and brace_depth > 0:
            ch = reader.peek()

            if ch == "\n" or ch == "\r":
                reader.advance()
                continue

            if ch == " ":
                reader.advance()
                continue

            if ch == "{":
                reader.advance()
                brace_depth += 1
                yield Token(TokenType.LBRACE, "{", reader.line, reader.column - 1)
                continue

            if ch == "}":
                reader.advance()
                brace_depth -= 1
                if brace_depth == 0:
                    yield Token(TokenType.INTERPOLATION_CLOSE, "}", reader.line, reader.column - 1)
                    return
                yield Token(TokenType.RBRACE, "}", reader.line, reader.column - 1)
                continue

            result = _dispatch_token(reader)
            if result is None:
                continue
            if isinstance(result, Token):
                yield result
            else:
                yield from result

        if brace_depth > 0:
            raise LexicalError(
                "LexicalError", reader.line, reader.column,
                "Unterminated interpolation expression \u2014 unbalanced braces"
            )


def _read_interp_escape(reader: CharacterReader) -> str:
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
