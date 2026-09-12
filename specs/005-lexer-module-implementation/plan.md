# Implementation Plan: Lexer Module Implementation

**Branch**: `005-lexer-module-implementation` | **Date**: 2026-07-27 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/005-lexer-module-implementation/spec.md`

## Summary

Implement the first-phase lexical analyzer for TheFlux language at `src/flux_proto/lexer/`. The lexer reads 7-bit ASCII `.flux`/`.fdsl` source, validates encoding, tracks indentation (6-space units), tokenizes keywords/operators/literals via longest-match, handles comments/docstrings/string interpolation with stateful lexing, and emits a token stream consumed by a single parser whose AST feeds all five backends (interpreter, VM bytecode, LLVM, WAT, WASM).

## Technical Context

**Language/Version**: Python 3.12+ (confirmed per constitution: Python is the host language for compiler, CLI, and test suite)

**Primary Dependencies**: None beyond Python stdlib for the lexer itself. Test suite uses pytest (confirmed). Wasmer (wasmer.exe on PATH) for WASM validation; WABT suite (wat2wasm, wasm-interp, etc. on PATH) for WAT/WASM round-trip validation during integration tests.

**Storage**: N/A — lexer is a pure function: source in, token stream out. No persistent storage.

**Testing**: pytest for unit/integration/regression tests. Positive, negative, false-positive, false-negative categories per constitution. Separate test CLI entry point per constitution.

**Target Platform**: Windows (current dev host) + cross-platform (WASM runs anywhere; LLVM targets native OS; interpreter runs on any host with Python).

**Project Type**: Compiler front-end — language development tool. Specifically the lexing phase of a multi-target compiler pipeline.

**Performance Goals**: ≥10,000 tokens/second for typical programs (<10k lines). Sufficient for development iteration; optimization deferred.

**Constraints**: ASCII 7-bit only (no UTF-8/Unicode anywhere). 6-space indentation exclusively (tabs forbidden). Single-pass sequential lexing with no backtracking beyond 1-2 character lookahead. Stateful lexing for interpolated strings with balanced `{}` tracking.

**Scale/Scope**: Single lexer package at `src/flux_proto/lexer/`. Public surface: `lex(source: str) -> Iterator[Token]` generator and `LexicalError` exception. Internal sub-modules for character reader, keyword matcher, operator dispatcher, indent tracker, interpolation state machine. No NEEDS CLARIFICATION — all technical decisions grounded in grammar.md, TheFlux.ebnf, constitution.md.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Gate | Status | Justification |
|------|--------|---------------|
| **I. Multi-Target Synchronization** | ✅ PASS | Lexer is single implementation producing one token stream → parser → one AST → all four backends. No per-target branching in lexer. |
| **II. Zero-Regression Automated Testing** | ✅ PASS | Lexer tests organized per category (positive/negative/false-positive/false-negative) in pytest. Regression detection is part of CI. |
| **III. Modular Compilation & Test Infrastructure** | ✅ PASS | Lexer is a standalone module with clear public interface (`lex()` / `LexicalError`). Internal sub-modules are cohesive. Two CLI entry points plan: compiler CLI (existing `cli.py`) and test CLI (planned). |
| **IV. Cross-Target Feature Parity** | ✅ PASS | Lexer covers the full language syntax. No syntax is target-specific. All features lexed uniformly. |
| **V. Dataflow & Agent-Oriented Architecture** | ✅ PASS | Lexer is encoding-agnostic to dataflow semantics — it only tokenizes. The `-->` / `==>` operators and `agent`/`op` keywords are lexed as tokens; semantic enforcement is downstream. |
| **ASCII 7-bit only** | ✅ PASS | FR-001 enforces strict ASCII validation. LEX001 for bytes >0x7F. |
| **Identifier capitalization rules** | ✅ PASS | Lexer emits IDENTIFIER for all styles; style validation is semantic-phase responsibility. |
| **6-space indentation / no tabs** | ✅ PASS | FR-004 + FR-003 enforce indent rules and tab rejection. |
| **Escape sequences** | ✅ PASS | FR-011 limits escapes to `\'`, `\"`, `\\`, `\n`, `\t`, `\r`, `\0`. |

**No violations found. No complexity tracking needed.**

## Project Structure

### Documentation (this feature)

```text
specs/005-lexer-module-implementation/
├── plan.md              # This file
├── research.md          # Phase 0 — technical decisions
├── data-model.md        # Phase 1 — token model, error model, module decomposition
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
├── cli.py               # Already imports from flux_proto.lexer.lexer
├── token.py             # TokenType enum + Token namedtuple (already exists)
└── lexer/
    ├── __init__.py      # Re-exports lex() and LexicalError
    ├── lexer.py         # Main lex() generator — orchestrates sub-modules
    ├── reader.py        # Character reader: file I/O, line/col tracking, ASCII validation
    ├── keywords.py      # Keyword map (str -> TokenType) + identifier classification
    ├── operators.py     # Longest-match operator dispatcher
    ├── indent.py        # Indentation tracker: INDENT/DEDENT emission, tab rejection
    └── interpolation.py # Stateful interpolated string lexer (balance tracking)

src/flux_tests/
└── lexer/
    ├── __init__.py
    ├── test_reader.py
    ├── test_keywords.py
    ├── test_operators.py
    ├── test_indent.py
    ├── test_interpolation.py
    ├── test_integration.py    # Full-program lexing
    └── test_errors.py         # LEX001, TabulationError, unterminated constructs

tests/                         # Target-specific integration tests (per constitution)
├── t_general/
│   ├── positive/              # Valid programs — lexer must accept
│   ├── negative/              # Invalid programs — lexer must reject
│   ├── positive_false/        # Edge cases near boundaries
│   └── negative_false/        # Valid-looking but semantically wrong constructs
├── t_llvm/
├── t_wasm-1.0/
├── t_wasm-2.0/
└── t_wasm-3.0/
```

**Structure Decision**: Single Python package (`flux_proto`) with a modular `lexer/` sub-package. Each internal concern (character reading, keyword matching, operator dispatch, indent tracking, interpolation state machine) is a separate file. Test suite mirrors the module structure with both unit tests (per sub-module) and integration tests (full-program lexing). This matches the existing codebase pattern (empty module directories already exist).

## Complexity Tracking

*Not needed — all Constitution gates pass with no violations.*
