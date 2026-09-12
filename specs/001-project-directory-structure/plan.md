# Implementation Plan: Project Directory Structure

**Branch**: `001-project-directory-structure` | **Date**: 2026-07-21 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/001-project-directory-structure/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command; its definition describes the execution workflow.

## Summary

Create the canonical TheFlux project directory structure using native Windows PowerShell
tooling. The scaffold script (`scaffold.ps1`) creates all root-level directories, compiler
phase modules, intermediate artifact folders, target workspaces, and QA suites as defined
in the constitution's Project Structure section. Idempotent — safe to re-run.

## Technical Context

**Language/Version**: PowerShell 7+ (native Windows shell)

**Primary Dependencies**: None (uses built-in `New-Item` cmdlet only)

**Storage**: File system only — directories and empty placeholder files

**Testing**: Manual verification via `Test-Path` or `Get-ChildItem` after scaffold run;
automated validation via `tests/` in future phase

**Target Platform**: Windows (PowerShell 7+)

**Project Type**: compiler frontend/backend toolchain scaffolding

**Performance Goals**: Scaffold completes in under 5 seconds

**Constraints**: Idempotent — no errors or overwrites on re-run; .gitkeep files to
track empty directories in git; all paths relative to project root

**Scale/Scope**: 14 root directories + 15+ subdirectories = ~30 total directories;
no source code generation at this stage

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **Principle I (Multi-Target Synchronization)**: Not directly applicable —
  directory structure enables target organization but doesn't create execution trees.
  ✅ PASS
- **Principle II (Zero-Regression Testing)**: The `t_general/` layout with positive,
  negative, false-positive, false-negative, and regression subdirectories directly
  enables this principle. ✅ PASS
- **Principle III (Modular Compilation & Test Infrastructure)**: `src/flux_proto/`
  with per-phase subdirectories and `src/flux_tests/` as test CLI implement this
  principle. Two separate CLI entry points are structurally enabled. ✅ PASS
- **Principle IV (Cross-Target Feature Parity)**: `t_llvm/`, `t_wasm-1.0/`,
  `t_wasm-2.0/`, `t_wasm-3.0/` provide target workspaces for parity testing. ✅ PASS
- **Principle V (Dataflow & Agent Architecture)**: Not directly applicable at
  scaffold stage. ✅ PASS

**Gates**: No violations. Proceed to Phase 0.

## Project Structure

### Documentation (this feature)

```text
specs/001-project-directory-structure/
├── plan.md              # This file (/speckit.plan command output)
├── research.md          # Phase 0 output (/speckit.plan command)
├── data-model.md        # Phase 1 output (/speckit.plan command)
├── quickstart.md        # Phase 1 output (/speckit.plan command)
├── contracts/           # Phase 1 output (/speckit.plan command)
└── tasks.md             # Phase 2 output (/speckit.tasks command)
```

### Source Code (repository root)

```text
# Single project layout — canonical TheFlux directory tree
docs/
fdsl/
flux/
intermediates/
├── ast/
├── ddg/
├── lexer/
├── llvm/
├── parser/
├── semantic/
└── wat/
runtime/
temp/
src/
├── flux_proto/
│   ├── ast/
│   ├── ddg/
│   ├── lexer/
│   ├── llvm/
│   ├── parser/
│   ├── semantic/
│   ├── vm/
│   ├── wasm/
│   └── wat/
└── flux_tests/
stdlib/
t_llvm/
t_wasm-1.0/
t_wasm-2.0/
t_wasm-3.0/
t_benchmarks/
t_general/
├── matrices/
├── metrics/
├── negative/
├── negative_false/
├── positive/
├── positive_false/
└── regression/
```

**Structure Decision**: Canonical layout as defined in the constitution's Project
Structure section. All directories are created by `scaffold.ps1`. New compiler
phases added under `src/flux_proto/` follow the same pattern.

## Complexity Tracking

No constitution violations — Complexity Tracking section not required.

## Research (Phase 0)

No technical unknowns to resolve. Native Windows PowerShell with `New-Item -ItemType
Directory` is the standard approach. All directories and their purposes are fully
specified in the spec and constitution.

## Data Model (Phase 1)

No application data entities at this stage. The scaffold operates purely on the
file system. Key "entities" are directories, documented in the spec:

| Directory | Purpose |
|-----------|---------|
| `docs/` | Documentation (white paper, grammar, keywords, HTML help) |
| `fdsl/` | Source files (.fdsl) for program libraries |
| `flux/` | Source files (.flux) for programs |
| `intermediates/` | Intermediate analysis and compiler debug files |
| `runtime/` | Runtime libraries if needed |
| `temp/` | Temporary script artifacts |
| `src/flux_proto/` | Compiler CLI and all language development modules |
| `src/flux_tests/` | Test CLI — all test categories |
| `stdlib/` | Standard library source files (.fdsl) |
| `t_llvm/` | LLVM native target — generation, validation, tests |
| `t_wasm-1.0/` | WASM 1.0 target — .wat/.wasm, validation, tests |
| `t_wasm-2.0/` | WASM 2.0 target — .wat/.wasm, validation, tests |
| `t_wasm-3.0/` | WASM 3.0 target — .wat/.wasm, validation, tests |
| `t_benchmarks/` | Benchmark metrics |
| `t_general/` | QA validation suites (matrices, metrics, test categories) |

## Contracts

No external interfaces at this stage. The scaffold is an internal developer tool.

## Quickstart

See [quickstart.md](quickstart.md) for validation scenarios.
