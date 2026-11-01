# TokenProvider Contract

**Contract between**: Lexer module (producer) → Parser module (consumer)

## Interface

```python
def lex(source: str) -> Generator[Token, None, None]:
    """Yield tokens from source string.

    Args:
        source: The Flux/FDSL source code as a single ASCII string.

    Yields:
        Token namedtuples in source order, ending with EOF.

    Raises:
        LexicalError (LEX001) on non-ASCII bytes or tab characters.
    """
```

## Token Guarantees

| Property | Guarantee |
|----------|-----------|
| **Order** | Tokens are yielded in strict source order. The `TokenStream` parser wrapper may reorder via buffering for lookahead, but the underlying generator is sequential. |
| **Completeness** | Every meaningful character in the source corresponds to at least one token. Comments are preserved (`LINE_COMMENT`, `BLOCK_COMMENT`). Whitespace (beyond indentation) is discarded. |
| **Structural tokens** | `EOL`, `INDENT`, `DEDENT`, `EOF` are emitted at appropriate positions. `EOL` within `()`/`[]` is suppressed. `INDENT`/`DEDENT` bracket `block_body` boundaries. |
| **Determinism** | Same source always produces the same token sequence (lexer is a pure function). |
| **Last token** | The final yielded token is always `TokenType.EOF`. |

## Token Types Consumed by Parser

The parser consumes tokens of the following types. Any token not listed here that appears in an unexpected position will trigger `ParseError`.

### Structural
`EOL`, `INDENT`, `DEDENT`, `EOF`

### Keywords (52)
`WILDCARD`, `MUT`, `IMUT`, `TRUE`, `FALSE`, `STRUCT`, `ENUM`, `CONTRACT`, `IMPL`,
`FUNCTION`, `AND_KEYWORD`, `OR_KEYWORD`, `NOT_KEYWORD`, `IN`, `BREAK`, `CONTINUE`,
`MATCH`, `ERROR`, `CATCH`, `ENSURE`, `FALLBACK`, `PROGRAM`, `EMIT`, `NICE`, `FAIL`,
`ROUTE`, `INFINITE`, `SPLIT`, `JOIN`, `AGENT`, `OP`, `USE`, `OF`, `COMPTIME`,
`MACRO`, `QUOTE`, `UNQUOTE`, `SPAWN`, `ASYNC`, `AWAIT`, `KEEP`, `MOVE`, `BORROW`,
`UNSAFE`, `PRINT`, `INPUT`, `SPY`, `DATA`, `MAP`, `SET`, `LIST`, `AS`

### Operators — Arithmetic
`PLUS`, `MINUS`, `STAR`, `DIV_FLOOR`, `DIV_INT`, `DIV_REM`

### Operators — Power
`POW_REAL`, `POW_RCP`

### Operators — Bitwise
`AND`, `OR`, `XOR`, `TILDE`, `SHIFT_LEFT`, `SHIFT_RIGHT`, `SHIFT_ARITH`

### Operators — Relational
`EQEQ`, `NEQ`, `LT`, `GT`, `LTE`, `GTE`

### Operators — Range
`RANGE`

### Operators — Dataflow
`DATAFLOW`, `DATAFLOW_MAP`

### Operators — Prefix
`QUESTION`, `NOT`

### Operators — Postfix
`DOT`, `DOUBLE_COLON`

### Assignment Operators
`EQ`, `ASSIGN_ADD`, `ASSIGN_SUB`, `ASSIGN_MUL`,
`ASSIGN_DIVF`, `ASSIGN_DIVI`, `ASSIGN_DIVR`,
`ASSIGN_POWE`, `ASSIGN_POWR`,
`ASSIGN_AND`, `ASSIGN_OR`, `ASSIGN_XOR`, `ASSIGN_NOT`,
`ASSIGN_SHL`, `ASSIGN_SHR`, `ASSIGN_SHRA`

### Delimiters
`LPAREN`, `RPAREN`, `LBRACE`, `RBRACE`, `LBRACKET`, `RBRACKET`,
`COMMA`, `COLON`

### Comments & Docstrings
`LINE_COMMENT`, `BLOCK_COMMENT`, `DOCSTRING`

### Literals
`INT_LIT`, `FLOAT_LIT`, `COMPLEX_LIT`, `DATETIME_LIT`,
`STRING_LIT`, `CHAR_LIT`

### Interpolation
`INTERPOLATED_STRING_START`, `INTERPOLATION_OPEN`, `INTERPOLATION_CLOSE`,
`INTERPOLATED_STRING_END`, `INTERPOLATED_TEXT`

### Identifiers
`IDENTIFIER`

## Expected Behavior

1. The parser calls `lex(source)` to obtain a token generator.
2. The parser wraps the generator in `TokenStream` for buffered access.
3. The parser consumes tokens sequentially via `peek()`/`advance()`.
4. On EOF, `TokenStream.peek()` returns the EOF token repeatedly; `advance()` returns EOF once.
5. The parser never modifies the lexer or its state.
6. The contract is one-way: lexer → parser. No callbacks or reverse communication.

## Error Handling

- Lexer errors (`LexicalError`) propagate as-is to the caller — the parser does not catch them.
- Parser errors (`ParseError`) are distinct from lexer errors and carry code `PAR001`.
