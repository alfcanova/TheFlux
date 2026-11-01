class LexicalError(Exception):
    def __init__(self, code: str, line: int, column: int, message: str):
        self.code = code
        self.line = line
        self.column = column
        self.message = message
        super().__init__(f"[{code}] L{line}:{column} {message}")


class CharacterReader:
    def __init__(self, source: str):
        self._source = source
        self._pos = 0
        self._line = 1
        self._col = 1
        self._length = len(source)
        self._allow_non_ascii = False

    @property
    def line(self) -> int:
        return self._line

    @property
    def column(self) -> int:
        return self._col

    @property
    def position(self) -> int:
        return self._pos

    def is_eof(self) -> bool:
        return self._pos >= self._length

    def peek(self, offset: int = 0) -> str | None:
        idx = self._pos + offset
        if idx >= self._length:
            return None
        return self._source[idx]

    def peek_multi(self, count: int) -> str:
        end = min(self._pos + count, self._length)
        return self._source[self._pos : end]

    def advance(self) -> str:
        if self._pos >= self._length:
            raise LexicalError("LEX001", self._line, self._col, "Unexpected end of input")

        ch = self._source[self._pos]

        if ord(ch) > 0x7F and not self._allow_non_ascii:
            raise LexicalError(
                "LEX001", self._line, self._col,
                f"Non-ASCII byte 0x{ord(ch):02X} at position {self._pos}"
            )

        if ch == "\t":
            raise LexicalError(
                "TabulationError", self._line, self._col,
                "Tab character prohibited; use 6 spaces for indentation"
            )

        self._pos += 1

        if ch == "\r":
            if self._pos < self._length and self._source[self._pos] == "\n":
                self._pos += 1
            self._line += 1
            self._col = 1
            return "\n"

        if ch == "\n":
            self._line += 1
            self._col = 1
            return "\n"

        self._col += 1
        return ch

    def skip_whitespace(self):
        while not self.is_eof():
            ch = self.peek()
            if ch == " ":
                self.advance()
            elif ch == "\n":
                return
            elif ch == "\r":
                c2 = self.peek(1)
                if c2 is not None and ord(c2) > 0x7F:
                    raise LexicalError(
                        "LEX001", self._line, self._col,
                        f"Non-ASCII byte 0x{ord(c2):02X}"
                    )
                self.advance()
            else:
                break

    def skip_whitespace_except_newline(self):
        while not self.is_eof():
            ch = self.peek()
            if ch == " ":
                self.advance()
            elif ch in ("\n", "\r"):
                break
            else:
                break

    def read_line(self, allow_non_ascii: bool = False) -> str:
        start = self._pos
        while not self.is_eof():
            ch = self.peek()
            if ch in ("\n", "\r"):
                break
            if ord(ch) > 0x7F:
                if not allow_non_ascii:
                    raise LexicalError(
                        "LEX001", self._line, self._col,
                        f"Non-ASCII byte 0x{ord(ch):02X}"
                    )
                self._pos += 1
                self._col += 1
                continue
            self.advance()
        return self._source[start : self._pos]

    def consume_newline(self) -> bool:
        if self.is_eof():
            return False
        ch = self.peek()
        if ch == "\n":
            self.advance()
            return True
        if ch == "\r":
            self.advance()
            return True
        return False

    def expect_char(self, expected: str) -> bool:
        if not self.is_eof() and self.peek() == expected:
            self.advance()
            return True
        return False
