# Contract: TokenProvider

## Purpose

Defines the interface between the lexer (producer) and the parser (consumer). The lexer transforms raw source text into an ordered stream of `Token` values that the parser can consume to build the AST.

## Public Interface

### `lex(source: str) -> Generator[Token, None, None]`

The sole public entry point of the lexer module.

**Input**: A string containing the full source code of a `.flux` or `.fdsl` file. Must be pre-decoded from bytes using `latin-1` (by the CLI layer) — the lexer validates strict ASCII internally.

**Output**: A generator that yields `Token` namedtuples in source order.

**Raises**: `LexicalError` on the first unrecoverable error (LEX001, TabulationError, unterminated construct, etc.). After raising, the generator is exhausted.

**Contract obligations**:

| Obligation | Producer (Lexer) | Consumer (Parser) |
|------------|------------------|-------------------|
| Token order | MUST yield tokens in source order, left-to-right, top-to-bottom | MUST consume tokens sequentially; seeking/rewinding is not supported |
| EOL placement | MUST emit EOL after every complete logical line, except where suppressed (inside `()`, `[]`, after infix operators) | MUST accept EOL as a statement terminator |
| INDENT/DEDENT | MUST emit INDENT before the first token of an indented block; MUST emit DEDENT when block ends | MUST use INDENT/DEDENT to delimit block boundaries |
| EOF | MUST emit EOF as the final token, after all other tokens | MUST stop consuming after EOF |
| Token identity | MUST set `type` to the correct `TokenType` enum member per the language grammar | MUST match `type` against expected grammar productions |
| Lexeme fidelity | MUST set `lexeme` to the exact source substring matched | MUST use `lexeme` for identifier names, literal values, and error messages |
| Error reporting | MUST raise `LexicalError` with `.code`, `.line`, `.column`, `.message` | MUST propagate `LexicalError` to the CLI layer for user-facing diagnostics |

### `LexicalError(Exception)`

Exception class for fatal lexical errors.

**Fields**:
- `code: str` — Diagnostic code (`"LEX001"`, `"TabulationError"`, or `"LexicalError"`)
- `line: int` — 1-based line number
- `column: int` — 1-based column number
- `message: str` — Human-readable error description

**Usage by CLI** (from `cli.py`):
```python
try:
    tokens = list(lex(source))
except LexicalError as e:
    print(f"{filename}:{e.line},{e.column} -> [{e.code}]: {e.message}")
    sys.exit(1)
```

## Module Layout

```text
src/flux_proto/lexer/
├── __init__.py          # from .lexer import lex, LexicalError
├── lexer.py             # def lex(source) — main generator
├── reader.py            # internal: character stream, ASCII validation, line/col
├── keywords.py          # internal: KEYWORD_MAP dict, is_keyword(), classify_identifier()
├── operators.py         # internal: OPERATOR_TRIE, longest_match()
├── indent.py            # internal: IndentTracker class
└── interpolation.py     # internal: InterpolationLexer class
```

## Versioning

This contract is version 1.0. The public API surface (`lex()` and `LexicalError`) is stable. Internal sub-modules may change without notice.

## Test Double

For parser tests that need a token stream without invoking the full lexer, a stub `TokenProvider` can be constructed from a list of `(TokenType, lexeme, line, column)` tuples:

```python
def stub_token_stream(tokens: list[tuple[TokenType, str, int, int]]) -> list[Token]:
    return [Token(typ, lex, line, col) for typ, lex, line, col in tokens]
```
