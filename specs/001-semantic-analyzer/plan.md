# Implementation Plan: Semantic Analyzer

**Branch**: `001-semantic-analyzer` | **Date**: 2026-07-27 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/001-semantic-analyzer/spec.md`

## Summary

Implement a modular semantic analysis phase (Phase 5 of the TheFlux compilation pipeline) that consumes the expanded AST from the parser (Phase 3) + macro expansion (Phase 4) and produces a decorated AST with attached semantic metadata — symbol table, resolved types, ownership states, and diagnostics. The analyzer covers all 7 sub-phases from grammar.md §13 (5a–5g): scope resolution, capitalization validation, mutability, type checking, ownership tracking, contract-agent verification, and emit terminal validation. It operates identically for all five backends (interpreter, VM bytecode, LLVM native, WAT, WASM) per the Multi-Target Synchronization principle.

## Technical Context

**Language/Version**: Python 3.12+ (host language for the semantic analyzer module)

**Primary Dependencies**: None external — the analyzer uses built-in Python types (`dataclasses`, `enum`, `typing`) and consumes the existing AST from `src/flux_proto/parser/ast.py`. The lexer and parser modules are also available for token-level context.

**Storage**: N/A — the semantic analyzer is an in-memory pipeline phase. No persistence. No database.

**Testing**: pytest (as mandated by constitution §II). Test categories: positive, negative, false-positive, false-negative, regression, compliance per target.

**Target Platform**: Language-agnostic — the analyzer outputs a decorated AST consumed by DDG (Phase 6), bytecode (Phase 7), LLVM (Phase 8), WAT (Phase 9), and WASM (Phase 10). All five backends receive identical semantic metadata.

**Project Type**: Compiler pipeline phase — an independent module that reads AST and writes decorated AST + diagnostics.

**Performance Goals**: <100ms for 1000 LOC files (SC-003). Contract-agent verification <200ms for 50 signatures (SC-005).

**Constraints**: 
- Multi-Target Synchronization: decorated AST format must be backend-agnostic (FR-015, SC-006)
- Must produce diagnostics in unified format: `file:line,col -> [CODE]: message` (FR-014)
- SUGGESTION diagnostics are non-fatal — compilation proceeds (per assumptions)
- Zero-regression: all parser-passing files must also pass semantic analysis with zero false positives (SC-004)

**Scale/Scope**: Single-file analysis. Cross-file use resolution via file path conventions. Up to ~10K lines per file in v1.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Status | Rationale |
|-----------|--------|-----------|
| **I. Multi-Target Synchronization** | ✅ PASS | FR-013/FR-015 enforce backend-agnostic decorated AST. SC-006 verifies identical consumption by all 5 backends. |
| **II. Zero-Regression Testing** | ✅ PASS | SC-007 mandates tests across all categories. SC-004 ensures zero false positives. |
| **III. Modular Compilation** | ✅ PASS | FR-015 requires independent module with clear interface. No backend dependencies. |
| **IV. Cross-Target Feature Parity** | ✅ PASS | All 7 sub-phases (5a–5g) apply equally to all targets. No per-backend checks. |
| **V. Dataflow/Agent Architecture** | ✅ PASS | US2 enforces capitalization per role. US4 tracks ownership. US5 verifies contract-agent compliance. |

**No violations.** All gates pass.

## Project Structure

### Documentation (this feature)

```
specs/001-semantic-analyzer/
├── plan.md              # This file
├── spec.md              # Feature specification
├── research.md          # Phase 0 — design research and decisions
├── data-model.md        # Phase 1 — entity definitions and relationships
├── quickstart.md        # Phase 1 — validation scenarios
├── contracts/           # Phase 1 — interface contracts
│   ├── symbol-table.md
│   ├── type-system.md
│   └── diagnostic.md
├── tasks.md             # Phase 2 — implementation tasks
└── checklists/
    ├── requirements.md  # Spec quality checklist
    └── (future task checklists)
```

### Source Code (repository root)

```
src/
├── flux_proto/
│   ├── lexer/           # Pre-existing — Phase 2
│   ├── parser/          # Pre-existing — Phase 3
│   │   ├── ast.py       # AST node definitions (shared with semantic)
│   │   ├── token_stream.py
│   │   ├── expressions.py
│   │   ├── statements.py
│   │   ├── declarations.py
│   │   ├── patterns.py
│   │   └── parser.py
│   ├── semantic/        # NEW — Phase 5 semantic analyzer
│   │   ├── __init__.py
│   │   ├── analyzer.py        # Main orchestrator
│   │   ├── symbol_table.py    # Scope and symbol resolution
│   │   ├── types.py           # Type representation and unification
│   │   ├── ownership.py       # Ownership and lifetime tracking
│   │   ├── capitalization.py  # Identifier capitalization rules
│   │   ├── mutability.py      # Mutability constraints
│   │   ├── contracts.py       # Contract-agent verification
│   │   ├── emit_check.py      # Emit terminal path analysis
│   │   ├── diagnostic.py      # Diagnostic types and formatting
│   │   └── ast_decorator.py   # Decorated AST metadata attachment
│   ├── ddg/             # Future — Phase 6
│   ├── vm/              # Future — Phase 7
│   ├── llvm/            # Future — Phase 8
│   ├── wat/             # Future — Phase 9
│   ├── wasm/            # Future — Phase 10
│   └── ...
└── flux_tests/
    ├── parser/          # Pre-existing parser tests
    ├── semantic/        # NEW — semantic analyzer tests
    │   ├── __init__.py
    │   ├── test_scope.py
    │   ├── test_capitalization.py
    │   ├── test_types.py
    │   ├── test_ownership.py
    │   ├── test_mutability.py
    │   ├── test_contracts.py
    │   ├── test_emit_terminal.py
    │   ├── test_diagnostics.py
    │   ├── test_integration.py
    │   └── test_regression.py
    └── ...
```

**Structure Decision**: The semantic analyzer follows the existing modular pattern of `src/flux_proto/parser/` — one cohesive module with sub-modules per concern. Each sub-module is independently testable. The `__init__.py` re-exports the main `analyze()` entry point and `SemanticError` exception.

## Complexity Tracking

No constitution violations — not applicable.
