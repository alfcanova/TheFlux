# Research: Parser Module Implementation

**Phase**: 0 — Design Decisions & Technical Research

## 1. Parsing Strategy

- **Decision**: Hand-written recursive-descent parser
- **Rationale**: TheFlux grammar has 17 operator precedence levels, indentation-aware blocks, pattern matching, interpolation, and comptime constructs. A hand-written parser gives full control over error messages, backtracking for struct_init vs call_suffix disambiguation (2-token lookahead), and indentation handling. No parser generator (ANTLR, Lark, etc.) is needed — the grammar is deterministic with at most 2 tokens of lookahead.
- **Alternatives considered**: ANTLR4 (requires grammar in ANTLR format, generates code in target language, complicates build), Lark (external dependency, less control over error messages), PEG parsing (requires different grammar formulation). Rejected because the EBNF is already in informal PEG-like form and adapting to a generator would add friction.

## 2. Operator Precedence Encoding

- **Decision**: One parsing function per precedence level (17 levels), each calling the next level, following the classic Pratt-like top-down approach but without a Pratt binding-power table — each level is explicit.
- **Rationale**: 17 levels is manageable with explicit functions. Each function handles its own operator(s) and associativity. This makes precedence easy to audit against the EBNF table. The alternative (Pratt parser with binding-power table) would reduce code but is less self-documenting for a first implementation.
- **Alternatives considered**: Pratt parser with binding powers (more compact but opaque), shunting-yard (requires two passes, poor error location). Explicit functions chosen for clarity and debuggability.

## 3. AST Representation

- **Decision**: `dataclass` hierarchy with a common `ASTNode` base class. Each node type is a separate dataclass with typed fields. JSON serialization via custom encoder.
- **Rationale**: Dataclasses provide immutable-by-default, automatically generated `__repr__`/`__eq__`, and easy field access. Typed fields catch structural errors early. This matches Python idioms and keeps dependencies at zero.
- **Alternatives considered**: Dictionary-based AST (no type safety, fragile), custom classes with `__slots__` (faster but more boilerplate), namedtuples (immutable but no default values/types). Dataclasses win on balance.

## 4. Error Reporting

- **Decision**: `ParseError` exception carrying `code="PAR001"`, `line`, `column`, `message`, and optional `expected` list of `TokenType`. Fail-fast (stop at first error) for initial implementation.
- **Rationale**: The lexer already uses `LexicalError` with this pattern. Matching it gives users a consistent diagnostic experience (`file:line,col -> [CODE]: message`). Fail-fast is simpler and sufficient for v0.5; error recovery can be added later.
- **Alternatives considered**: Error recovery with token-sync (needs panic-mode or follow-set synchronization — adds complexity for v0.5). Deferred.

## 5. TokenStream Abstraction

- **Decision**: Class wrapping the lexer generator, buffer of up to 2 lookahead tokens, methods `peek()`, `peek(n)`, `advance()`, `expect(type)`, `match(type)`, `position`, `set_position()`.
- **Rationale**: 2-token lookahead suffices for all grammar disambiguation (struct_init vs call_suffix, infinite conditional vs iteration). Position saves/restores needed for speculative parsing. The class decouples parser logic from generator mechanics.
- **Alternatives considered**: Direct iterator consumption (can't peek or backtrack), infinite buffering (memory waste for large files). 2-token buffer is the minimum needed.

## 6. Indentation Handling in Parser

- **Decision**: Parser consumes `INDENT`/`DEDENT` tokens from the token stream. Block boundaries are defined by these tokens. The lexer already handles indentation measurement and suppression within `()`/`[]`.
- **Rationale**: The lexer emits `INDENT`/`DEDENT` structure. The parser merely matches them to delimit `indented_block_body`. The lexer's `IndentTracker` already handles 6-space units, multi-level jump rejection, bracket suppression, and eol concatenation after infix operators. Parser logic stays simple.
- **Alternatives considered**: Having the parser also handle indentation (would duplicate lexer logic). Rejected — keep indentation logic in the lexer where it belongs.

## 7. Docstring Attachment

- **Decision**: Parser accumulates `DOCSTRING` tokens encountered before a declaration and attaches them as metadata on the following declaration AST node.
- **Rationale**: Docstrings are meaningful only in relation to the declaration they document. The lexer emits them in the token stream; the parser must associate them. This is a syntactic binding (not semantic) and therefore belongs in the parser.
- **Alternatives considered**: Semantic-phase docstring attachment (would require the parser to pass docstrings through as separate statements — awkward and fragile). Parser-side binding is the standard approach.

## 8. .flux vs .fdsl Differentiation

- **Decision**: The `parse()` entry point takes the source file path (or extension), dispatches to `flux_file()` or `fdsl_file()` production. `flux_file` requires exactly one `program` declaration (last). `fdsl_file` requires one or more `agent` declarations, no `program`.
- **Rationale**: The grammar explicitly defines two top-level rules. The parser enforces the distinction syntactically — no semantic analysis needed.
- **Alternatives considered**: Single entry point with post-parse validation (would catch errors later, less clear). Separate entry points are cleaner.

## 9. Interpolation Parsing

- **Decision**: The lexer already emits `INTERPOLATED_STRING_START`, `INTERPOLATED_TEXT`, `INTERPOLATION_OPEN`, `INTERPOLATION_CLOSE`, `INTERPOLATED_STRING_END`. The parser assembles these into `InterpolatedString` AST nodes with alternating `InterpolatedText` (string) and expression children.
- **Rationale**: The lexer's `InterpolationLexer` already handles brace balancing. The parser just restructures the token sequence into the AST. Expression parsing inside `INTERPOLATION_OPEN`/`INTERPOLATION_CLOSE` delegates to the expression parser.
- **Alternatives considered**: Full interpolation handling in parser (would require re-doing brace counting — wasted effort). Keep lexer's work.

## 10. Backend-Neutral AST

- **Decision**: Zero backend-specific fields, branches, or special cases in the parser. All lowering/transformation happens in backend-specific phases (bytecode codegen, LLVM IR gen, WAT gen, WASM gen).
- **Rationale**: Constitution mandates a single parser feeding all backends. Any backend-specific parser logic would violate Multi-Target Synchronization (Principle I).
- **Alternatives considered**: Per-target parser variants (rejected — violates constitution). Parser extensions for target-specific syntax (no target-specific syntax exists in TheFlux).

## 11. Testing with WASM/WABT

- **Decision**: Integration tests shell out to wasmer.exe and WABT tools (`wat2wasm`, `wasm-interp`) for WASM validation of parsed AST that includes backend lowering. These are integration-only tests, not parser unit tests.
- **Rationale**: Parser correctness is verified by positive/negative parsing tests. WASM round-trip tests validate end-to-end lowering, not parsing. Using the confirmed-on-PATH tooling (wasmer.exe + WABT) prevents bitrot.
- **Alternatives considered**: Mocking wasmer/WABT (wouldn't catch real WASM breakage). Deferred to integration test layer.

## 12. Build Dependencies

- **Decision**: Zero external dependencies for the parser. Pytest for testing. Optional `orjson` for faster JSON serialization of AST dumps (stdlib `json` is sufficient).
- **Rationale**: The parser is a pure-Python module with no I/O beyond receiving tokens. External dependencies add risk and maintenance burden. Stdlib suffices.
- **Alternatives considered**: `lark` for parser generation (rejected — hand-written chosen). `pydantic` for AST (heavy, adds dependency). Stdlib dataclasses are sufficient.
