# Data Model: Lexer Module

## Entities

### Token

The atomic output unit of the lexer. Defined in `src/flux_proto/token.py`.

| Field | Type | Description |
|-------|------|-------------|
| type | TokenType (enum) | The classification of the token (keyword, operator, literal, structural, etc.) |
| lexeme | str | The exact source text matched for this token |
| line | int | 1-based line number where the token starts |
| column | int | 1-based column number where the token starts |

**Validation rules**:
- `type` must be a member of `TokenType` enum
- `lexeme` must contain only ASCII characters (0x00-0x7F)
- `line` and `column` must be > 0

### TokenType (Enum)

Defines all 70+ token categories. Grouped into:

| Group | Members | Source |
|-------|---------|--------|
| Structural | EOL, INDENT, DEDENT, EOF | `grammar.md` §4 |
| Keywords (59) | WILDCARD, MUT, IMUT, TRUE, FALSE, STRUCT, ENUM, CONTRACT, IMPL, FUNCTION, AND_KEYWORD, OR_KEYWORD, NOT_KEYWORD, IN, BREAK, CONTINUE, MATCH, ERROR, CATCH, ENSURE, FALLBACK, PROGRAM, EMIT, NICE, FAIL, ROUTE, INFINITE, SPLIT, JOIN, AGENT, OP, USE, OF, COMPTIME, MACRO, QUOTE, UNQUOTE, SPAWN, ASYNC, AWAIT, KEEP, MOVE, BORROW, UNSAFE, PRINT, INPUT, SPY, DATA, MAP, SET, LIST, AS | `TheFlux.ebnf` keyword set |
| Arithmetic operators | PLUS, MINUS, STAR, DIV_FLOOR, DIV_INT, DIV_REM | `grammar.md` §6 |
| Power operators | POW_REAL, POW_RCP | `grammar.md` §9 |
| Bitwise operators | AND, OR, XOR, TILDE, SHIFT_LEFT, SHIFT_RIGHT, SHIFT_ARITH | `grammar.md` §9 |
| Relational operators | EQEQ, NEQ, LT, GT, LTE, GTE | `grammar.md` §9 |
| Range | RANGE | `grammar.md` §9 |
| Dataflow | DATAFLOW, DATAFLOW_MAP | `grammar.md` §9 |
| Prefix | QUESTION, NOT | `grammar.md` §9 |
| Postfix | DOT, DOUBLE_COLON | `grammar.md` §9 |
| Assignment (17) | EQ, ASSIGN_ADD, ASSIGN_SUB, ASSIGN_MUL, ASSIGN_DIVF, ASSIGN_DIVI, ASSIGN_DIVR, ASSIGN_POWE, ASSIGN_POWR, ASSIGN_AND, ASSIGN_OR, ASSIGN_XOR, ASSIGN_NOT, ASSIGN_SHL, ASSIGN_SHR, ASSIGN_SHRA | `grammar.md` §6 |
| Delimiters | LPAREN, RPAREN, LBRACE, RBRACE, LBRACKET, RBRACKET, COMMA, COLON | `grammar.md` §9 |
| Comments/docs | LINE_COMMENT, BLOCK_COMMENT, DOCSTRING | `grammar.md` §3 |
| Literals | INT_LIT, FLOAT_LIT, COMPLEX_LIT, DATETIME_LIT, STRING_LIT, CHAR_LIT, INTERPOLATED_STRING_START, INTERPOLATION_OPEN, INTERPOLATION_CLOSE, INTERPOLATED_STRING_END, INTERPOLATED_TEXT | `grammar.md` §7 |
| Identifier | IDENTIFIER | `grammar.md` §1 |

### LexicalError

The diagnostic structure raised by the lexer on unrecoverable errors.

| Field | Type | Description |
|-------|------|-------------|
| code | str | Diagnostic code: `"LEX001"` for non-ASCII bytes, `"TabulationError"` for tabs, `"LexicalError"` for other malformed input |
| line | int | 1-based line number where the error occurred |
| column | int | 1-based column number where the error occurred |
| message | str | Human-readable description of the error |

**Error code mapping**:

| Condition | Code | Source |
|-----------|------|--------|
| Byte > 0x7F anywhere in source | LEX001 | Constitution + FR-001 |
| Tab character encountered | TabulationError | Constitution + FR-003 |
| Unterminated string literal | LexicalError | FR-021 |
| Unterminated block comment (#B without B#) | LexicalError | FR-021 |
| Unterminated docstring (#D without D#) | LexicalError | FR-021 |
| Indentation jump > 1 level | TabulationError | FR-026 |
| Invalid escape sequence | LexicalError | FR-011 |
| Unbalanced braces in interpolation | LexicalError | FR-013 |

### Indentation Level Stack

Internal state maintained by the indent tracker.

| Field | Type | Description |
|-------|------|-------------|
| levels | list[int] | Stack of indentation widths (in spaces) encountered so far. Always starts with `[0]`. |
| pending_dedents | int | Number of DEDENT tokens to emit before the next line's first token |
| inside_brackets | int | Depth of `()` / `[]` nesting — when > 0, indentation tracking is suspended |

**State transitions**:
- Line start: count leading spaces → compare with `levels[-1]`
  - Equal: no structural change
  - +6: push to `levels`, emit INDENT
  - -6: pop from `levels`, increment `pending_dedents`
  - Other delta: raise TabulationError
- Enter `(` or `[`: increment `inside_brackets`
- Exit `)` or `]`: decrement `inside_brackets`

### Interpolation State Machine

Internal state for interpolated string lexing.

| Field | Type | Description |
|-------|------|-------------|
| mode | enum | `NORMAL`, `IN_INTERPOLATED_STRING`, `IN_INTERPOLATION_EXPR` |
| brace_depth | int | Current `{}` nesting depth inside the interpolation expression |
| text_buffer | list[str] | Accumulated literal text between interpolation blocks |

**State transitions**:
- `NORMAL` → `IN_INTERPOLATED_STRING`: on `"` when string interpolation is detected (non-raw string)
- `IN_INTERPOLATED_STRING` → `IN_INTERPOLATION_EXPR`: on `#{`, emit INTERPOLATED_TEXT with buffer, emit INTERPOLATION_OPEN, brace_depth = 1
- `IN_INTERPOLATION_EXPR`: on `{` → brace_depth++; on `}` → brace_depth--; if brace_depth == 0 → emit INTERPOLATION_CLOSE, back to `IN_INTERPOLATED_STRING`
- `IN_INTERPOLATED_STRING` → `NORMAL`: on closing `"`, emit INTERPOLATED_STRING_END

### Operator Trie (Internal)

A prefix-tree structure used for longest-match operator scanning.

| Element | Type | Description |
|---------|------|-------------|
| root | dict | Nested dict: character → sub-dict or leaf. Leaf nodes carry the TokenType for the completed operator. |

**Structure**: `{ '>': { '>': { '>': LEAF(SHIFT_ARITH), _: LEAF(SHIFT_RIGHT) }, _: LEAF(GT) }, '-' ... }`

## Relationships

```text
SourceFile (bytes)
    │
    ▼
CharacterReader ───→ ASCII validation (LEX001)
    │
    ▼
Dispatcher (lexer.py orchestrator)
    ├── Line start? ──→ IndentTracker ──→ (INDENT/DEDENT/EOL)
    ├── '#'? ─────────→ Comment/Docstring dispatcher → (LINE_COMMENT/BLOCK_COMMENT/DOCSTRING)
    ├── '"'? ─────────→ InterpolationStateMachine ──→ (INTERPOLATED_* tokens)
    ├── Digit/'+'/'-'? → Number literal parser → (INT_LIT/FLOAT_LIT/COMPLEX_LIT/DATETIME_LIT)
    ├── "'"? ─────────→ Char literal parser → (CHAR_LIT)
    ├── Operator char? → OperatorTrie → (operator/delimiter TokenType)
    └── Letter/'_'? ──→ KeywordMap/Identifier matcher → (keyword TokenType or IDENTIFIER)
    │
    ▼
Token stream → Parser
```
