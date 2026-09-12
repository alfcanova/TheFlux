<!--
  Sync Impact Report
  ==================
  Version change: 0.6.0 → 0.7.0 — MINOR bump
  Modified principles: N/A
  Added sections:
    - Project Structure section (canonical directory layout)
  Removed sections: N/A
  Templates requiring updates:
    - .specify/templates/plan-template.md: ✅ Already generic — no changes needed
    - .specify/templates/spec-template.md: ✅ Already generic — no changes needed
    - .specify/templates/tasks-template.md: ✅ Already generic — no changes needed
    - .specify/templates/checklist-template.md: ✅ Already generic — no changes needed
  Follow-up TODOs: None — all placeholders filled
-->

# TheFlux Constitution

## Core Principles

### I. Multi-Target Synchronization (NON-NEGOTIABLE)

All four execution trees — native interpreter (.flux/.fdsl), bytecode VM (.fvmbc),
WebAssembly (.wat/.wasm), and LLVM native (.exe/.dll) — MUST produce semantically
equivalent results for the same source program. Any feature added to the language
MUST be implemented across all targets simultaneously. Cross-target regression is
FORBIDDEN; every change MUST include compliance verification across all backends.

### II. Zero-Regression Automated Testing

A comprehensive pytest-based test suite covering positive, negative, false-positive,
false-negative, compliance-matrix, regression-matrix, and fuzzy test categories MUST
exist and MUST pass before any feature is accepted. Tests are organized per target
and per category. No commit may introduce a regression; regression detection triggers
an immediate block.

### III. Modular Compilation & Test Infrastructure

Both the compilation pipeline and the test suite MUST be maximally modularized.
The compilation suite — spanning lexical analysis, parsing, semantic analysis, IR
generation, and each backend (bytecode VM, WASM, LLVM) — MUST be organized into
independent, cohesive modules with clear interfaces. The test suite MUST be
modularized per target and per test category. Two separate CLI entry points MUST
exist: one for the compilation pipeline and one for the test suite. New modules
MUST follow the established modular pattern.

### IV. Cross-Target Feature Parity

Every new syntax construct, stdlib function, or language feature MUST be supported
identically across all four execution backends. Partial implementation across a
subset of targets is NOT permitted. Feature parity is verified by the compliance
matrix on every change.

### V. Dataflow & Agent-Oriented Architecture

The language is built on dataflow orientation and context agent isolation. Variables
are streams/channels. Agents encapsulate state and communicate only via I/O ports.
Immutability is the default; mutations create new instances. Ownership tracking
(move/borrow/keep) ensures memory safety. Indices are 1-based; slices are inclusive.

## Development Constraints

- ASCII 7-bit encoding ONLY. Any byte >0x7F → LEX001 fatal error.
- Strict identifier capitalization:
  SCREAMING_SNAKE for immutable variables, snake_case for mutable,
  camelCase for functions/ops, PascalCase for agents/contracts/programs.
- Escapes limited to: `\'`, `\"`, `\\`, `\n`, `\t`, `\r`, `\0`.
- 6-space indentation units. Tabs prohibited.
- Immutability by default. Data flowing through streams is immutable.
- Agent isolation: no direct memory access between agents — all communication
  passes through I/O ports.

## Technology Stack

- **Host language**: Python (interpreter in PATH) — used for the compiler,
  CLI tooling, and test suite (pytest).
- **Native compilation**: LLVM/clang — generates native executables (.exe/.dll).
- **Auxiliary toolchains** (available on system PATH when needed):
  Go, Zig, Rust — MAY be used for performance-critical native components,
  FFI bindings, or auxiliary build tooling.

## Project Structure

```
├── docs/                         # Documentation (white paper, grammar, keywords, HTML help)
├── fdsl/                         # Source files (.fdsl) for program libraries
├── flux/                         # Source files (.flux) for programs
├── intermediates/                # Intermediate analysis and compiler debug files
│   ├── ast/                      # Abstract Syntax Tree (--emit-ast)
│   ├── ddg/                      # Data Dependency Graph (--emit-ddg)
│   ├── lexer/                    # Token stream (--emit-lexer)
│   ├── llvm/                     # LLVM IR output (--emit-llvm)
│   ├── parser/                   # Concrete Syntax Tree / CST (--emit-parser)
│   ├── semantic/                 # Symbol table and type checking (--emit-semantic)
│   └── wat/                      # WASM symbol table (--emit-wat)
├── runtime/                      # Runtime libraries if needed
├── temp/                         # Temporary files (scripts, python, etc.)
├── src/                          # Root for compilation and test suites
│   ├── flux_proto/               # CLI and all language development modules
│   │   ├── ast/                  # AST generator
│   │   ├── ddg/                  # Graph generator
│   │   ├── lexer/                # Lexer generator
│   │   ├── llvm/                 # LLVM .ll object generator
│   │   ├── parser/               # Parser generator
│   │   ├── semantic/             # Semantic analyzer
│   │   ├── vm/                   # Bytecode VM
│   │   ├── wasm/                 # WASM backend
│   │   └── wat/                  # WAT symbol table (--emit-wat)
│   └── flux_tests/               # Test CLI — covers all test categories
├── stdlib/                       # Standard library source files (.fdsl)
├── t_llvm/                       # LLVM native target — generation, validation, tests
├── t_wasm-1.0/                   # WebAssembly 1.0 target — .wat/.wasm, validation, tests
├── t_wasm-2.0/                   # WebAssembly 2.0 target — .wat/.wasm, validation, tests
├── t_wasm-3.0/                   # WebAssembly 3.0 target — .wat/.wasm, validation, tests
├── t_benchmarks/                 # Benchmark metrics
└── t_general/                    # QA validation suites
    ├── matrices/                 # Quality control matrices
    │   ├── rtm.csv               # Requirements Traceability Matrix
    │   ├── coverage.csv          # Test coverage matrix
    │   ├── defects.csv           # Defect matrix
    │   └── test_cases.csv        # Test case matrix
    ├── metrics/                  # Performance and quality tracking
    │   └── metrics.json          # Coverage %, success rate, density, defects/sprint, MTTR, regression rate
    ├── negative/                 # Negative tests
    ├── negative_false/           # False negative tests
    ├── positive/                 # Positive tests
    ├── positive_false/           # False positive tests
    └── regression/               # Regression scenarios
```

## Testing & Quality Infrastructure

- Test framework: pytest (Python).
- Test categories per target: positive, negative, false positive, false negative.
- Compliance matrix: verifies every language feature across all 4 targets.
- Regression matrix: ensures no feature breaks across targets on any change.
- Fuzzy testing: random/corner-case inputs for all targets.
- Two separate CLI entry points: one for the compilation pipeline and one for the
  test suite.
- The compilation pipeline (lexer, parser, semantic analysis, IR, all backends)
  MUST be modularized into independent, cohesive modules.
- All tests MUST pass before merge. Regression = block.

## Governance

This constitution supersedes all other project practices. Amendments require
documented proposal, approval, and migration plan.

Versioning follows MAJOR.MINOR.PATCH:
- MAJOR: backward-incompatible governance/principle removals or redefinitions.
- MINOR: new principles or materially expanded guidance.
- PATCH: clarifications, wording fixes, non-semantic refinements.

Every feature implementation MUST include a Constitution Compliance Check.
Compliance is verified by the test suite and code review.

Use `.specify/memory/constitution.md` for runtime governance guidance.

**Version**: 0.7.0 | **Ratified**: 2026-07-20 | **Last Amended**: 2026-07-21
