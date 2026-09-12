from typing import Generator

from flux_proto.token import Token, TokenType


class TokenStream:
    def __init__(self, tokens: Generator[Token, None, None]):
        self._buffer: list[Token] = []
        self._generator = tokens
        self._pos = 0

    def _fill(self, n: int) -> None:
        while len(self._buffer) <= self._pos + n:
            try:
                tok = next(self._generator)
            except StopIteration:
                break
            if tok.type in (TokenType.LINE_COMMENT, TokenType.BLOCK_COMMENT):
                continue
            self._buffer.append(tok)

    def peek(self, n: int = 0) -> Token | None:
        self._fill(n)
        idx = self._pos + n
        if idx >= len(self._buffer):
            return None
        return self._buffer[idx]

    def advance(self) -> Token | None:
        tok = self.peek(0)
        if tok is not None:
            self._pos += 1
        return tok

    def expect(self, *types: TokenType) -> Token:
        tok = self.peek(0)
        if tok is None:
            raise ParseError("PAR001", 0, 0, f"Unexpected end of input, expected one of: {[t.name for t in types]}")
        if tok.type not in types:
            raise ParseError(
                "PAR001", tok.line, tok.column,
                f"Expected {[t.name for t in types]}, got {tok.type.name} ('{tok.lexeme}')"
            )
        return self.advance()

    def match(self, *types: TokenType) -> bool:
        tok = self.peek(0)
        if tok is not None and tok.type in types:
            self.advance()
            return True
        return False

    def skip_eols(self, include_indent: bool = False) -> None:
        while True:
            tok = self.peek(0)
            if tok is None:
                return
            if include_indent and tok.type in (TokenType.INDENT, TokenType.DEDENT):
                self.advance()
                continue
            if tok.type == TokenType.EOL:
                self.advance()
                continue
            return

    @property
    def position(self) -> int:
        return self._pos

    def set_position(self, pos: int) -> None:
        self._pos = pos

    @property
    def current(self) -> Token | None:
        return self.peek(0)


class ParseError(Exception):
    def __init__(self, code: str, line: int, column: int, message: str):
        self.code = code
        self.line = line
        self.column = column
        self.message = message
        super().__init__(f"[{code}] L{line}:{column} {message}")
