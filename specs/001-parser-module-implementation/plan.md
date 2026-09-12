# Implementation Plan: Parser Module Implementation

**Branch**: `001-parser-module-implementation` | **Date**: 2026-07-27 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/001-parser-module-implementation/spec.md`

## Summary

Implement the recursive-descent parser for TheFlux at `src/flux_proto/parser/`. The parser consumes the lexer token stream via a `TokenStream` wrapper, builds a single AST per the grammar rules (17-level operator precedence, declarations, statements, patterns, interpolation), attaches docstrings to declarations, enforces `.flux` vs `.fdsl` file-topology rules, and emits error diagnostics (PAR001). A single AST feeds all five backends — no target-specific parser logic.

## Technical Context

**Language/Version**: Python 3.12+ (confirmed per constitution — Python is the host language for compiler, CLI, and test suite). Auxiliary toolchains Zig, Rust, Go available on PATH for future performance-critical components but NOT needed for the parser.

**Primary Dependencies**: None beyond Python stdlib for the parser itself. Existing `flux_proto.lexer` module provides `lex()`, `Token`, `TokenType`. Test suite uses pytest (confirmed). WASM validation uses wasmer.exe + WABT suite (both on PATH — confirmed by user).

**Storage**: N/A — parser is a pure function: token stream in, AST out. No persistent storage.

**Testing**: pytest for unit/integration/regression tests. Positive, negative, false-positive, false-negative categories per constitution. Ensure lexer regression tests remain passing (77 current tests).

**Target Platform**: Windows (current dev host) + cross-platform (AST is data; all five backends consume it identically).

**Project Type**: Compiler front-end — language development tool. Specifically the parsing phase of a multi-target compiler pipeline.

**Performance Goals**: ≥10,000 tokens/second for typical programs (<10k lines). Sufficient for development iteration; optimization deferred.

**Constraints**: Recursive-descent with one function per grammar production. No external parser generators. TokenStream abstraction isolates parser from lexer mechanics. No backend-specific branches in parser code. ParseError (PAR001) with location-accurate diagnostics. Indentation-aware block parsing via INDENT/DEDENT tokens.

**Scale/Scope**: Single parser package at `src/flux_proto/parser/`. Public surface: `parse(tokens, source_path) -> ASTNode` function and `ParseError` exception. Internal sub-modules for token stream, expressions (17 levels), statements, declarations, patterns, and AST node definitions. Follows the same modular pattern as the existing lexer module.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Gate | Status | Justification |
|------|--------|---------------|
| **I. Multi-Target Synchronization** | ✅ PASS | Parser produces a single AST. No target-specific branches. All five backends (interpreter, VM bytecode, LLVM, WAT, WASM) consume the same AST. |
| **II. Zero-Regression Automated Testing** | ✅ PASS | Comprehensive pytest suite covering positive, negative, false-positive, false-negative categories. Lexer regression tests (77) must remain passing. |
| **III. Modular Compilation & Test Infrastructure** | ✅ PASS | Parser is a standalone module with clear public interface (`parse()` / `ParseError`). Internal sub-modules (expressions, statements, declarations, patterns, token stream, AST) are cohesive. Follows established lexer pattern. |
| **IV. Cross-Target Feature Parity** | ✅ PASS | All syntax constructs parse the same way regardless of target. Backend-specific constructs do not exist at the syntax level. |
| **V. Dataflow & Agent-Oriented Architecture** | ✅ PASS | Parser is encoding-agnostic to dataflow semantics — it only builds AST nodes. `-->` / `==>` operators, `agent`/`op` keywords are parsed as AST nodes; semantic enforcement is downstream. |

**No violations found. No complexity tracking needed.**

## Project Structure

### Documentation (this feature)

```text
specs/001-parser-module-implementation/
├── plan.md              # This file
├── research.md          # Phase 0 — technical decisions
├── data-model.md        # Phase 1 — AST node model, error model, module decomposition
├── quickstart.md        # Phase 1 — validation guide
├── contracts/           # Phase 1 — TokenProvider contract
│   └── token-provider.md
├── checklists/
│   └── requirements.md  # Spec quality checklist
└── tasks.md             # Phase 2 — task breakdown (created by /speckit.tasks)
```

### Source Code (repository root)

```text
src/flux_proto/
├── __init__.py
├── __main__.py
├── cli.py               # Already imports from flux_proto.parser once it exists
├── token.py             # TokenType enum + Token namedtuple (pre-existing)
├── lexer/               # Pre-existing lexer module
└── parser/
    ├── __init__.py      # Re-exports parse() and ParseError
    ├── ast.py           # AST node definitions (dataclasses for all node types)
    ├── token_stream.py  # TokenStream wrapper around lexer generator
    ├── expressions.py   # Expression parsing (17 precedence levels)
    ├── statements.py    # Statement and block-body parsing
    ├── declarations.py  # Top-level declaration parsing (program, agent, function, etc.)
    ├── patterns.py      # Pattern parsing (match arms)
    └── parser.py        # Main parse() orchestrator — dispatches by file extension

src/flux_tests/
└── parser/
    ├── __init__.py
    ├── test_expressions.py    # Expression precedence and associativity
    ├── test_statements.py     # Statement and block parsing
    ├── test_declarations.py   # Top-level declaration parsing
    ├── test_patterns.py       # Pattern parsing (match/route arms)
    ├── test_integration.py    # Full-program parsing, --emit-ast
    └── test_errors.py         # PAR001 diagnostics (negative tests)

tests/
├── t_general/
│   ├── positive/              # Valid programs — parser must accept
│   ├── negative/              # Invalid programs — parser must reject
│   ├── positive_false/        # Edge cases near boundaries
│   └── negative_false/        # Valid-looking but syntactically wrong constructs
├── t_llvm/
├── t_wasm-1.0/
├── t_wasm-2.0/
└── t_wasm-3.0/
```

**Structure Decision**: Single Python package (`flux_proto`) with a modular `parser/` sub-package. Each internal concern (token stream, expression parsing, statement parsing, declaration parsing, pattern parsing, AST nodes) is a separate file. Test suite mirrors the module structure with both unit tests (per sub-module) and integration tests (full-program parsing). This exactly matches the existing lexer module pattern ([plan.md](plan.md) from spec 005).

## Complexity Tracking

*Not needed — all Constitution gates pass with no violations.*
