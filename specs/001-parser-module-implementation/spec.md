# Parser Module Implementation

**Feature**: Build the recursive-descent parser that consumes the token stream from the lexer and produces a single Abstract Syntax Tree for the TheFlux language.

## User Stories

### US1 — Core Expression Parsing
Users write complex expressions with infix operators at 17 precedence levels, prefix/postfix operators, and function calls; the parser must correctly build AST nodes reflecting precedence and associativity.

### US2 — Declaration Parsing
Users define programs, functions, agents, structs, enums, contracts, impls, macros, storage variables, and use-imports; the parser validates syntactic correctness and produces declaration AST nodes.

### US3 — Statement & Block Parsing
Users write block bodies with print, infinite loops, route/match branching, emit/fail, break/continue, unsafe blocks, variable reassignment, and expression statements; the parser enforces statement-ending rules (EOL, dedent, `}`).

### US4 — Pattern & Match Parsing
Users write match expressions with wildcard, literal, list, record, struct, enum-variant, and data patterns; the parser validates pattern syntax and binds variables.

### US5 — Error Recovery & Diagnostics
Users receive clear, location-accurate syntax error messages (PAR001) with the offending token, expected tokens, and source position; the parser may optionally recover to report multiple errors.

## Functional Requirements

### FR1 — Recursive Descent Parsing
The parser MUST be a hand-written recursive-descent parser with one function per grammar production, consuming tokens from the lexer via a `TokenStream` abstraction.

### FR2 — Operator Precedence
Expressions MUST parse according to the 17-level precedence table defined in the EBNF (assignment → recovery → dataflow → logical OR/AND → bitwise OR/XOR/AND → relational → membership → range → shift → additive → multiplicative → power → prefix → postfix). Each level MUST be a separate parsing function.

### FR3 — AST Production
The parser MUST produce a single AST (Abstract Syntax Tree) consumed by all five backends (interpreter, VM bytecode, LLVM, WAT, WASM). AST nodes MUST include at minimum:
- **Programs/Declarations**: `FluxProgram`, `FdslFile`, `FunctionDef`, `OpDecl`, `StructDef`, `EnumDef`, `ContractDef`, `ImplDef`, `AgentDef`, `MacroDef`, `UseDecl`, `StorageDecl`
- **Statements**: `BlockStmt`, `PrintStmt`, `InfiniteStmt`, `RouteStmt`, `MatchStmt`, `BreakStmt`, `ContinueStmt`, `EmitStmt`, `FailStmt`, `UnsafeStmt`, `ExpressionStmt`, `VariableReassign`
- **Expressions**: `BinaryOp`, `UnaryOp`, `Literal`, `Identifier`, `CallExpr`, `FieldAccess`, `IndexAccess`, `SliceSpec`, `StructInit`, `EnumVariant`, `MatchExpr`, `LambdaExpr`, `DataflowExpr`, `CastExpr`, `ErrorExpr`, `InputExpr`, `SpyExpr`, `ComptimeExpr`, `QuoteExpr`, `UnquoteExpr`, `OwnershipExpr`, `AsyncExpr`, `SpawnExpr`, `AwaitExpr`
- **Patterns**: `Pattern` (Wildcard, Literal, List, Record, Struct, EnumVariant, Data variants)

### FR4 — TokenStream Abstraction
The parser MUST wrap the lexer generator in a `TokenStream` class providing `peek()`, `advance()`, `expect(TokenType)`, `match(TokenType)`, and position backtracking if needed. This decouples parser logic from lexer iteration mechanics.

### FR5 — Module Structure
The parser MUST be organized into coherent sub-modules mirroring the lexer pattern:
- `parser/ast.py` — AST node definitions (dataclasses or similar)
- `parser/token_stream.py` — TokenStream wrapper
- `parser/expressions.py` — expression parsing functions (all 17 levels)
- `parser/statements.py` — statement and block parsing
- `parser/declarations.py` — top-level declaration parsing
- `parser/patterns.py` — pattern parsing (match arms)
- `parser/parser.py` — main `parse()` orchestrator
- `parser/__init__.py` — re-exports `parse()` and `ParseError`

### FR6 — Diagnostic Error Reporting
On invalid syntax, the parser MUST raise `ParseError` with:
- Error code `PAR001`
- Source line and column
- A human-readable message describing what was expected vs what was found
- Optionally: expected token types for richer diagnostics

### FR7 — Five-Backend Compliance
The parser MUST NOT contain any backend-specific logic. The same AST feeds all five targets. No branches or special cases for interpreter vs VM vs LLVM vs WAT vs WASM.

### FR8 — File Extension Differentiation
The parser MUST distinguish `.flux` (program required, exactly one `program` declaration, last) from `.fdsl` (one or more `agent` declarations, no `program`). This is checked at the top-level `flux_file` vs `fdsl_file` rules.

### FR9 — Docstring Attachment
Docstrings (`#D...#D`) preceding declarations MUST be attached to the following declaration's AST node as metadata. The parser collects docstrings from the token stream and associates them.

### FR10 — Interpolation Handling
Interpolated strings (`"Hello #{expr}"`) produce `InterpolatedString` AST nodes containing alternating `InterpolatedText` and expression child nodes.

### FR11 — Indentation-Aware Block Parsing
The parser MUST consume `INDENT`/`DEDENT` tokens to delimit block boundaries. `EOL` within `()` and `[]` is suppressed (done by lexer). `EOL` after a dataflow operator or infix operator is suppressed via lookback (lexer responsibility).

### FR12 — Immediate Values (Comptime)
`comptime` blocks and `quote { ... }`/`unquote(...)` expressions must be parsed into dedicated AST nodes for compile-time evaluation.

## Success Criteria

| Criterion | How Measured |
|-----------|-------------|
| All valid `.flux`/`.fdsl` programs in the sample suite parse without error | CLI `--emit-ast` produces valid JSON for every file in `flux/samples/` and `fdsl/samples/` |
| All invalid syntax variants produce a PAR001 error with correct line/column | Negative test suite covering every grammar production's error paths |
| AST JSON output is deterministic (same source → same AST every time) | Hash comparison across 10 consecutive parses of the same file |
| AST contains zero backend-specific branches or fields | Code review + `grep` for target-specific pattern exclusion |
| Parser handles at least 10,000 tokens/second on typical programs | `time` measurement on a ~1,000 line program |
| All previously passing lexer-only tests remain passing | Full lexer test suite execution |
| Test suite covers positive, negative, false-positive, and false-negative categories per constitution | Category counts in pytest output |
| Docstring metadata is correctly attached to the subsequent declaration in the AST | Integration tests with `#D\n...D#` before each declaration type |

## Key Entities

### TokenStream
Wraps the lexer generator. Provides `peek()`, `advance()`, `expect(type)`, `match(type)`, `position`, `set_position()`. Tracks current and lookahead tokens. May buffer tokens for backtracking.

### ASTNode (base)
All AST nodes inherit from a common base with `node_type`, `start_token`, `end_token`, and `children` (list of child nodes) or specific typed fields for each variant.

### ParseError
Exception carrying `code` (`"PAR001"`), `line`, `column`, `message`, and optional `expected` (list of `TokenType` the parser was expecting).

### Parser Module
The `parse(tokens: Generator[Token], source_path: str) -> ASTNode` entry point. Dispatches to `flux_file` or `fdsl_file` based on extension. Recursive descent through all grammar productions.

## User Scenarios & Testing

### Scenario 1: Parsing a Complete Program
**Given** a valid `hello.flux` file with a `program` declaration, function, storage, and print statement
**When** the parser processes the token stream
**Then** it produces an AST with `FluxProgram` as root, containing `StorageDecl`, `FunctionDef`, and `PrintStmt` children
**And** `--emit-ast` writes the AST as valid JSON to `intermediates/ast/hello.json`

### Scenario 2: Error on Malformed Syntax
**Given** a `.flux` file with a missing closing parenthesis in a function call
**When** the parser processes the token stream
**Then** it raises `ParseError` with code `PAR001`, correct line/column, and a message indicating the expected token
**And** the error is displayed to the user in the format `file:line,col -> [PAR001]: message`

### Scenario 3: Agent Declaration Parsing
**Given** a valid `agent_test.fdsl` with an agent containing storage, function, and op declarations
**When** the parser processes the token stream
**Then** it produces an AST with `FdslFile` as root, containing one or more `AgentDef` nodes, each with `StorageDecl`, `FunctionDef`, and `OpDecl` children

### Scenario 4: Expression Precedence
**Given** a complex expression like `a + b * c ^e d`
**When** the parser processes it
**Then** the AST reflects correct precedence: `BinaryOp(+, a, BinaryOp(*, b, BinaryOp(^e, c, d)))`

### Scenario 5: Error Recovery (If Implemented)
**Given** a file with two independent syntax errors on separate lines
**When** the parser processes it
**Then** it reports both errors, not stopping at the first one

### Test Categories

**Positive tests**: Every language construct defined in the grammar ends up in an AST node. Sample programs from `flux/samples/` and `fdsl/samples/` must parse to valid AST.

**Negative tests**: Invalid syntax for each production raises PAR001. Tests cover: missing required tokens, wrong delimiter type, invalid indentation recovery, incomplete expressions, unterminated blocks.

**False-positive tests**: Constructs that look invalid but are valid: empty function bodies (if emit-only), empty struct bodies, nested `()` in expressions, `::` namespace chains, `#{ }` empty interpolation.

**False-negative tests**: Constructs that look valid but are invalid: keyword used as identifier, dataflow operator without right operand, assignment to non-lvalue.

## Assumptions

- The lexer `lex()` generator is already implemented, tested, and stable (77 passing tests).
- The parser receives the full token stream; it does not re-lex.
- Error recovery is deferred to a follow-up iteration if scope permits; the initial implementation stops at the first error (fail-fast).
- AST nodes are simple dataclass objects stored in memory; serialization to JSON is a separate concern.
- The parser does not perform semantic validation (capitalization, mutability, type checking) — that is the semantic analyzer's responsibility in the next pipeline phase.
- Operator associativity follows the precedence table: most levels are left-to-right; assignment and power are right-to-left.
- Block bodies are delimited by `INDENT`/`DEDENT` tokens, not by braces (though braces `{}` may be used for inline blocks where the lexer supresses indent tracking).
- The parser does not handle WASM-specific constructs; all WASM lowering happens in the backend phase.
- The parser does not need to handle comptime macro expansion — that is Phase 4 (macro expansion).
