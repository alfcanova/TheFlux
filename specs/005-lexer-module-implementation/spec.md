# Feature Specification: Lexer Module Implementation for TheFlux

**Feature Branch**: `005-lexer-module-implementation`

**Created**: 2026-07-27

**Status**: Draft

**Input**: User description: "Relembrando os princípios da constitution.md e utilizando o grammar.md e TheFlux.ebnf como fonte de verdade planeje a implementação do lexer.py da linguagem TheFlux. Certifique-se que o projeto seja modular e que contemple os cinco targets pretendidos: interpretado via código fonte (.flux/.fdsl), máquina virtual de bytecode nativo (.fvmbc) .exe (via llvm), .wat (web assembly textual) e .wasm (web assembly binario)."

## User Scenarios & Testing

### User Story 1 - Lexing a Valid .flux Program for All Targets (Priority: P1)

A language user writes a `.flux` program using the full syntax of TheFlux (storage declarations, functions, expressions, comments, docstrings, string interpolation). The lexer must consistently convert this source text into a token stream regardless of which target backend will consume the parsed AST.

**Why this priority**: The lexer is the gateway to every downstream phase — parsing, semantic analysis, and all five backends. Without correct lexing, no target can produce output. Every other user story depends on this.

**Independent Test**: Can be fully tested by providing any valid `.flux` program, running the lexer in isolation (`--emit-lexer`), and verifying that every token in the output matches the expected type and lexeme for each character sequence.

**Acceptance Scenarios**:

1. **Given** a valid `.flux` file containing `mut as int64: x = 42`, **When** the lexer processes it, **Then** tokens MUT, AS, INT64, COLON, IDENTIFIER(x), EQ, INT_LIT(42), EOL are emitted in order.
2. **Given** a valid `.fdsl` file with an agent declaration, **When** the lexer processes it, **Then** tokens AGENT, LPAREN, IDENTIFIER(agent name), RPAREN, LBRACE, EOL are emitted with correct indent tracking.
3. **Given** a source file with `#L` line comment and `#B ... B#` block comment, **When** the lexer processes it, **Then** the comment tokens are produced correctly and comments are skipped or preserved as LINE_COMMENT/BLOCK_COMMENT tokens, with no impact on the structural token stream.

---

### User Story 2 - Lexing with Strict ASCII Enforcement (Priority: P1)

The language spec requires 7-bit ASCII exclusively. Any byte above `0x7F` in source code, strings, comments, or docstrings must be rejected with a fatal error (LEX001).

**Why this priority**: This is a non-negotiable language constraint from the constitution. Violations could silently corrupt downstream compilation or produce incorrect results across targets.

**Independent Test**: Can be fully tested by feeding the lexer a file containing a single non-ASCII byte and asserting that a `LexicalError` with code `LEX001` is raised, with no tokens emitted.

**Acceptance Scenarios**:

1. **Given** a source file containing a UTF-8 character like `ç` or `á` (byte > 0x7F), **When** the lexer encounters it, **Then** a `LEX001` error is raised with the exact line and column of the offending byte.
2. **Given** a string literal containing `\x80` escape, **When** the lexer processes it, **Then** `LEX001` error is raised (only `\'`, `\"`, `\\`, `\n`, `\t`, `\r`, `\0` are valid escapes).
3. **Given** a block comment containing non-ASCII bytes, **When** the lexer processes it, **Then** `LEX001` error is raised.

---

### User Story 3 - Structural Lexing with Indentation Tracking (Priority: P1)

TheFlux uses significant indentation (6 spaces per level, tabs prohibited) to delimit blocks. The lexer must emit `INDENT`/`DEDENT` tokens based on indentation changes and suppress EOL within parentheses `()` and brackets `[]`.

**Why this priority**: Indentation-based block structure is core to the language syntax. The parser depends entirely on correct indent/dedent tokens to build the AST. Without this, no backend can work.

**Independent Test**: Can be fully tested with a minimal `.flux` file containing nested indented blocks, verifying that the sequence of INDENT/DEDENT tokens matches the expected nesting depth changes.

**Acceptance Scenarios**:

1. **Given** a source file where indentation increases by exactly 6 spaces, **When** the lexer reaches the indented line, **Then** an `INDENT` token is emitted before the first token of the line.
2. **Given** a source file where indentation decreases, **When** the lexer encounters the dedented line, **Then** one or more `DEDENT` tokens are emitted (one per level removed).
3. **Given** a source file containing a tab character, **When** the lexer processes it, **Then** a `TabulationError` is raised before any tokens are emitted.
4. **Given** a source file where indentation jumps by more than 6 spaces (e.g., 12 to 18 without encountering 12 first), **When** the lexer processes it, **Then** a `TabulationError` is raised.

---

### User Story 4 - String Interpolation Support (Priority: P2)

TheFlux supports interpolated strings (`"Hello #{name}"`). The lexer must use a stateful mode to emit `INTERPOLATED_STRING_START`, `INTERPOLATION_OPEN`, `INTERPOLATION_CLOSE`, `INTERPOLATED_STRING_END`, and `INTERPOLATED_TEXT` tokens, with balanced `{}` tracking inside interpolation blocks.

**Why this priority**: String interpolation is a commonly used language feature that affects how source code is tokenized. While not all programs use it, those that do depend on correct lexing to avoid confusing the parser.

**Independent Test**: Can be fully tested by providing a source file containing interpolated string expressions and verifying that the emitted interpolation token sequence is correct and balanced.

**Acceptance Scenarios**:

1. **Given** a source file with `"Value: #{x + 1}"`, **When** the lexer processes it, **Then** the token sequence is: INTERPOLATED_STRING_START, INTERPOLATED_TEXT("Value: "), INTERPOLATION_OPEN, (expression tokens for x + 1), INTERPOLATION_CLOSE, INTERPOLATED_STRING_END.
2. **Given** a source file with nested braces inside interpolation like `"#{if x > 0 then {1}}"`, **When** the lexer processes it, **Then** brace nesting is balanced and the interpolation block correctly closes.

---

### User Story 5 - Docstring Attachment to Declarations (Priority: P2)

Docstrings (`#D ... D#`) must be preserved by the lexer and attached to the subsequent declaration. The lexer must also extract key-value fields from docstring content.

**Why this priority**: Docstrings serve as the language's documentation mechanism. Correct attachment is essential for tooling (IDE support, documentation generation) that works consistently across all five backends.

**Independent Test**: Can be fully tested by providing a source file with a docstring followed by a struct/function/agent declaration and verifying that a DOCSTRING token is emitted before the declaration's first token.

**Acceptance Scenarios**:

1. **Given** a source file with `#D\nDocumentation\nD#` followed by a function declaration, **When** the lexer processes it, **Then** a `DOCSTRING` token is emitted with the text "Documentation" immediately preceding the FUNCTION token.
2. **Given** a docstring containing bullet-key fields (`- author: name`), **When** the lexer processes it, **Then** the DOCSTRING token payload includes identified key-value pairs.

---

### User Story 6 - Multi-Target Token Stream Consistency (Priority: P2)

The same source file, lexed once, must produce a token stream that feeds all five downstream backends without re-lexing. Each backend (interpreter, VM bytecode, LLVM, WAT, WASM) consumes the same AST produced from the same token stream.

**Why this priority**: Per the constitution, all four execution trees must produce semantically equivalent results. A single lexer pass feeding a shared AST is the foundation of cross-target consistency.

**Independent Test**: Can be fully tested by lexing a representative `.flux` program, parsing the tokens, and then verifying that the resulting AST can be consumed by all five backend entry points without modification or re-lexing.

**Acceptance Scenarios**:

1. **Given** a valid `.flux` program, **When** the lexer produces a token stream and the parser produces an AST, **Then** each backend (interpreter, bytecode compiler, LLVM codegen, WAT codegen, WASM codegen) must accept the same AST without errors.
2. **Given** a `.fdsl` agent library file, **When** lexed and parsed, **Then** the resulting AST must be valid input for all applicable backends (at minimum interpreter and bytecode VM).

---

### Edge Cases

- What happens when a source file contains only whitespace and comments? (Should produce only structural tokens: EOL + EOF, no semantic tokens)
- How does the lexer handle an opening `#D` without a closing `D#`? (Should raise a `LexicalError` — unterminated docstring)
- How does the lexer handle an opening `#B` without a closing `B#`? (Should raise a `LexicalError` — unterminated block comment)
- How does the lexer handle an unterminated string literal (missing closing quote)? (Should raise a `LexicalError`)
- How does the lexer handle an empty interpolated string like `"#{ }"`? (Should emit balanced INTERPOLATION_OPEN/CLOSE with no expression tokens)
- How does the lexer handle an incomplete integer like a lone `-` or `+` followed by EOL? (Should treat `-` as MINUS operator, not as part of a literal)
- How does the lexer handle sequential operators like `-->>`? (Longest-match: `-->` then `>` — the `>` is not part of `-->`)
- How does the lexer handle `#L` comment at EOF with no trailing line break? (Should still produce LINE_COMMENT token followed by EOF)
- How does the lexer handle very deep nesting (30+ levels of indentation)? (Should handle without stack overflow)
- How does the lexer handle zero-length docstring `#D\nD#`? (Should emit DOCSTRING token with empty content)
- How does the lexer handle carriage return `\r` and `\r\n` line endings? (Should normalize all to `\n` before lexing)
- How does the lexer handle a file with only a `#B ... B#` block comment spanning multiple lines? (Should produce BLOCK_COMMENT token with the full content)
- What happens when `D` appears but is not followed by `#` inside a docstring? (Should include `D` as content and continue; `D#` is the only closing sequence)

## Requirements

### Functional Requirements

- **FR-001**: Lexer MUST read source bytes, validate that all bytes are within 0x00-0x7F (ASCII), and reject any byte > 0x7F with a `LEX001` fatal error.
- **FR-002**: Lexer MUST normalize line endings (`\r\n`, `\r`) to `\n` before further processing.
- **FR-003**: Lexer MUST reject tab characters with a `TabulationError` regardless of context.
- **FR-004**: Lexer MUST emit structural tokens `EOL`, `INDENT`, `DEDENT`, `EOF` based on the language's indentation rules (6 spaces per level, no multi-level jumps).
- **FR-005**: Lexer MUST suppress `EOL`, `INDENT`, and `DEDENT` tokens within matching parentheses `()` and brackets `[]`.
- **FR-006**: Lexer MUST apply line continuation: suppress `EOL` when the previous meaningful token is a dataflow operator (`-->`, `==>`) or an infix operator, concatenating the next physical line.
- **FR-007**: Lexer MUST recognize line comments (`#L ...`), block comments (`#B ... B#`), and docstrings (`#D ... D#`) and emit corresponding tokens (LINE_COMMENT, BLOCK_COMMENT, DOCSTRING).
- **FR-008**: Lexer MUST enforce that block comments and docstrings use lookahead-based closing detection: `B#` closes block comment, `D#` closes docstring, and the `B`/`D` character is not consumed as content when followed by `#`.
- **FR-009**: Lexer MUST emit docstring token content including extracted key-value fields (bullet lines with `- key: value` pattern).
- **FR-010**: Lexer MUST tokenize integer, float, complex (with i/j suffix), and datetime (ISO 8601) literals according to the EBNF grammar.
- **FR-011**: Lexer MUST tokenize string literals (`"..."`) with escape sequence handling (`\'`, `\"`, `\\`, `\n`, `\t`, `\r`, `\0`) and reject any other escapes or non-ASCII bytes.
- **FR-012**: Lexer MUST tokenize char literals (`'...'`) with the same escape rules as strings.
- **FR-013**: Lexer MUST support interpolated strings with stateful lexing: emit `INTERPOLATED_STRING_START`, `INTERPOLATED_TEXT`, `INTERPOLATION_OPEN`, `INTERPOLATION_CLOSE`, and `INTERPOLATED_STRING_END` tokens, with balanced `{}` tracking.
- **FR-014**: Lexer MUST apply longest-match rules for multi-character operators: `-->` before `-`, `==>` before `==` before `=`, `=>`/`=>`/`=>` before `=`, `>>>` before `>>`, `..` before `.`, `::` before `:`, etc.
- **FR-015**: Lexer MUST recognize all keywords from the keyword set (59 keywords including `_` wildcard) and emit the corresponding keyword token type rather than a generic IDENTIFIER.
- **FR-016**: Lexer MUST recognize identifier styles (snake_case, camelCase, PascalCase, SCREAMING_SNAKE) but emit all as a single `IDENTIFIER` token type, leaving style validation to the semantic phase.
- **FR-017**: Lexer MUST recognize all assignment operators (`=`, `=+`, `=-`, `=*`, `=/f`, `=/i`, `=/r`, `=^e`, `=^r`, `=&`, `=|`, `=^`, `=~`, `=<<`, `=>>`, `=>>>`) and emit the correct token type.
- **FR-018**: Lexer MUST recognize dataflow operators (`-->`, `==>`) as DATAFLOW and DATAFLOW_MAP tokens respectively.
- **FR-019**: Lexer MUST recognize all arithmetic, bitwise, relational, range, and prefix operators and emit their correct token types.
- **FR-020**: Lexer MUST recognize delimiters `()`, `{}`, `[]`, `,`, `:` and emit the corresponding token types.
- **FR-021**: Lexer MUST produce a `LexicalError` with the diagnostic code, line, column, and a human-readable message for any malformed input.
- **FR-022**: Lexer module MUST be internally modular: the character reader/validator, keyword matcher, operator longest-match dispatcher, indent tracker, and stateful interpolation lexer SHOULD be organized as separate cohesive sub-modules or classes within the lexer package.
- **FR-023**: Lexer MUST produce a token stream that, when parsed once, feeds all five target backends (interpreter/.flux, VM/.fvmbc, LLVM/.exe, WAT/.wat, WASM/.wasm) without re-lexing.
- **FR-024**: Lexer MUST support the `--emit-lexer` CLI flag, writing the token stream to `intermediates/lexer/<filename>.json` in a structured format (token type, lexeme, line, column).
- **FR-025**: Lexer MUST handle `.flux` and `.fdsl` file extensions identically, as the file type distinction is semantic (program vs agent requirement), not lexical.
- **FR-026**: Lexer MUST reject source with indentation jumps greater than one level (e.g., skipping from 0 to 18 spaces) with a `TabulationError`.

### Key Entities

- **Token**: The atomic unit produced by the lexer. Carries a type (from TokenType enum), lexeme (the matched source text), line number, and column number.
- **LexicalError**: A diagnostic structure produced when the lexer encounters an unrecoverable error. Carries an error code (LEX001 or TabulationError), line, column, and human-readable message.
- **Token Stream**: An ordered sequence of Tokens consumed by the parser. Includes structural tokens (EOL, INDENT, DEDENT, EOF) that define block boundaries.
- **Source File**: A `.flux` or `.fdsl` file read as raw bytes. Must be 7-bit ASCII. Can contain the full range of language constructs: declarations, expressions, comments, docstrings, and all literal types.
- **Module (Lexer package)**: The internal organization of the lexer into cohesive components: character reader, token dispatcher, indent tracker, keyword map, string interpolation state machine, and operator longest-match resolver.

## Success Criteria

### Measurable Outcomes

- **SC-001**: Any valid `.flux` or `.fdsl` program from the language test suite can be lexed to completion without errors, producing a non-empty token stream.
- **SC-002**: All token types defined in the `TokenType` enum are produced by at least one test case in the lexer test suite.
- **SC-003**: 100% of parser test inputs can be lexed without `LexicalError` — the lexer never rejects valid programs.
- **SC-004**: All known malformed inputs (non-ASCII bytes, tabs, unterminated strings, unterminated comments, multi-level indent jumps) are caught by the lexer and reported with the correct error code (LEX001 or TabulationError).
- **SC-005**: The token stream produced by the lexer is consumed identically by all five backend pipelines — the parser produces the same AST from the same token stream regardless of the intended target.
- **SC-006**: Interpolated string token sequences are balanced in every test case — the count of `INTERPOLATION_OPEN` equals the count of `INTERPOLATION_CLOSE` for every `INTERPOLATED_STRING_START`/`INTERPOLATED_STRING_END` pair.
- **SC-007**: The lexer processes source files at a rate of at least 10,000 tokens per second on reference hardware for typical program sizes (under 10,000 lines).
- **SC-008**: Indentation tracking correctly handles at least 50 levels of nesting without stack overflow or performance degradation exceeding 2x over flat files of the same length.
- **SC-009**: Longest-match operator resolution is unambiguous — no valid source file produces a different token sequence under alternative operator interpretations.

## Assumptions

- **Encoding**: Source files are assumed to be 7-bit ASCII. The `latin-1` decoding in the existing CLI is a transport detail; the lexer must validate strict ASCII internally.
- **File types**: `.flux` and `.fdsl` are the only recognized source file extensions; the lexer treats them identically.
- **Indentation**: 6 spaces per level is fixed. Tabs are unconditionally rejected. The lexer does not attempt auto-detection or configuration of indentation width.
- **Operator grammar**: The longest-match rules from `grammar.md` Section 5 are the definitive source of operator tokenization; no additional operator/token ambiguities are expected beyond those documented.
- **Keyword set**: The keyword list in `TheFlux.ebnf` (59 keywords) is definitive. No keywords are added or removed as part of this feature.
- **Target scope**: This feature covers the lexer only. Parser, semantic analysis, backend codegen, and runtime execution are separate features with their own specifications.
- **Docstring extraction**: Key-value field extraction from docstrings uses the pattern of bullet lines (`-`, `*`, `+`) containing `key: value` — this is a best-effort parse, not a strict validation.
- **Existing infrastructure**: The `token.py` definitions and `cli.py` import structure are already in place and will not be altered by this feature.
- **Module structure**: The lexer module at `src/flux_proto/lexer/` will contain multiple internal files as needed for modularity; the public API is `lex(source: str) -> Iterator[Token]` and the `LexicalError` exception class.
- **Performance**: Lexer throughput is secondary to correctness in the initial implementation. Optimization is deferred to a future performance feature.
