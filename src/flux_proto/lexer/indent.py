from flux_proto.token import TokenType
from flux_proto.lexer.reader import LexicalError


class IndentTracker:
    INDENT_WIDTH = 6

    def __init__(self):
        self._levels: list[int] = [0]
        self._pending_dedents: int = 0
        self._bracket_depth: int = 0
        self._line_start: bool = True

    @property
    def at_line_start(self) -> bool:
        return self._line_start

    def set_line_start(self, value: bool):
        self._line_start = value

    @property
    def bracket_depth(self) -> int:
        return self._bracket_depth

    def on_bracket_open(self):
        self._bracket_depth += 1

    def on_bracket_close(self):
        if self._bracket_depth > 0:
            self._bracket_depth -= 1

    def is_tracking_indent(self) -> bool:
        return self._line_start and self._bracket_depth == 0

    def measure_indent(self, spaces: int, reader_line: int, reader_col: int):
        current = self._levels[-1]

        if spaces == current:
            self._pending_dedents = 0
            return

        if spaces > current:
            delta = spaces - current
            if delta % self.INDENT_WIDTH != 0:
                raise LexicalError(
                    "TabulationError", reader_line, reader_col,
                    f"Invalid indentation: expected multiples of {self.INDENT_WIDTH} spaces, got {delta}"
                )
            steps = delta // self.INDENT_WIDTH
            if steps != 1:
                raise LexicalError(
                    "TabulationError", reader_line, reader_col,
                    f"Indentation jump of {delta} spaces ({steps} levels) — only single-level increments allowed"
                )
            self._levels.append(spaces)
            return

        if spaces < current:
            delta = current - spaces
            if delta % self.INDENT_WIDTH != 0:
                raise LexicalError(
                    "TabulationError", reader_line, reader_col,
                    f"Invalid dedentation: expected multiples of {self.INDENT_WIDTH} spaces, got {delta}"
                )
            steps = delta // self.INDENT_WIDTH
            for _ in range(steps):
                self._levels.pop()
            self._pending_dedents = steps
            return

    def pop_dedent(self) -> bool:
        if self._pending_dedents > 0:
            self._pending_dedents -= 1
            return True
        return False

    def reset(self):
        self._levels = [0]
        self._pending_dedents = 0
        self._bracket_depth = 0
        self._line_start = True
