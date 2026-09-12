# Contract: Diagnostic

## Interface

### `Diagnostic`

```python
@dataclass
class SourceLocation:
    line: int
    column: int
    file: str | None = None

class Severity(Enum):
    ERROR = auto()
    WARNING = auto()
    SUGGESTION = auto()

@dataclass
class Diagnostic:
    code: str
    severity: Severity
    line: int
    column: int
    message: str
    related: list[SourceLocation] = field(default_factory=list)
```

### `DiagnosticFormatter`

```python
class DiagnosticFormatter:
    @staticmethod
    def format(d: Diagnostic, file: str = "<unknown>") -> str: ...
        # Returns: "file:line,col -> [CODE]: message"
    @staticmethod
    def format_all(diags: list[Diagnostic], file: str) -> str: ...
        # Returns newline-separated formatted diagnostics
    @staticmethod
    def severity_label(s: Severity) -> str: ...
        # Returns "error", "warning", or "suggestion"
```

## Diagnostic Codes

| Code | Severity | Meaning |
|------|----------|---------|
| SEM001 | ERROR | Semantic error (type mismatch, unresolved ref, use-after-move, etc.) |
| SEM002 | WARNING | Semantic warning (unused import, dead code, unreachable emit, etc.) |
| SUG | SUGGESTION | Advisory (capitalization mismatch, style hint) |

## Output Format

```
file:line,col -> [SEM001]: type mismatch: expected int64 but got string
file:line,col -> [SEM001]: unresolved reference 'UndefinedAgent'
file:line,col -> [SUG]: variable 'MAX_VALOR' should use snake_case: 'max_valor'
```

Multiple diagnostics are separated by newlines. Related locations are formatted as additional lines with indentation:

```
file:line,col -> [SEM001]: use of moved variable 'x'
  --> file:other_line,other_col: value moved here
```

## Pre-conditions

- None — Diagnostic objects are standalone value types

## Post-conditions

- Every diagnostic produced during any phase is collectable, formattable, and propagatable to the CLI for display
- Diagnostics are non-blocking (except ERROR severity in terms of compilation continuation — SEM001 stops code generation but allows further analysis to collect more diagnostics)
