---

description: "Task list for Project Directory Structure feature"

---

# Tasks: Project Directory Structure

**Input**: Design documents from `specs/001-project-directory-structure/`

**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md

**Tests**: Test tasks are included — scaffold validation is part of the feature spec.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- **Single project**: All paths relative to project root `D:\Projetos\TheFlux`
- **Scaffold script**: `scaffold.ps1` at project root

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Create the canonical TheFlux directory structure via PowerShell scaffold

- [X] T001 Create `scaffold.ps1` with root-level directories: docs/, fdsl/, flux/, intermediates/, runtime/, temp/, src/, stdlib/, t_llvm/, t_wasm-1.0/, t_wasm-2.0/, t_wasm-3.0/, t_benchmarks/, t_general/
- [X] T002 [P] Add intermediates subdirectories to scaffold.ps1: ast/, ddg/, lexer/, llvm/, parser/, semantic/, wat/
- [X] T003 [P] Add src subdirectories to scaffold.ps1: flux_proto/, flux_proto/ast/, flux_proto/ddg/, flux_proto/lexer/, flux_proto/llvm/, flux_proto/parser/, flux_proto/semantic/, flux_proto/vm/, flux_proto/wasm/, flux_proto/wat/, flux_tests/
- [X] T004 [P] Add t_general QA subdirectories to scaffold.ps1: matrices/, metrics/, negative/, negative_false/, positive/, positive_false/, regression/
- [X] T005 Add placeholder files (.gitkeep) to every empty directory for git tracking
- [X] T006 Add idempotency guard to scaffold.ps1 (use `-Force` on New-Item) — re-running MUST NOT error or overwrite

**Checkpoint**: Scaffold creates all ~30 directories in under 5 seconds, idempotently.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Validation and testing infrastructure for the scaffold

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [X] T007 Create validation script `tests/validate-scaffold.ps1` using Test-Path to verify every expected directory exists
- [X] T008 [P] Add directory count check to validation script (expect >= 30 directories)
- [X] T009 Add idempotency test to validation (run scaffold twice, assert zero errors)

**Checkpoint**: Foundation ready — scaffold is validated and repeatable.

---

## Phase 3: User Story 1 - Initialize Canonical Directory Layout (Priority: P1) 🎯 MVP

**Goal**: The scaffold script creates the complete canonical directory tree and is verified by the validation suite.

**Independent Test**: Run `.\scaffold.ps1`, then run `tests\validate-scaffold.ps1` — all checks pass.

### Tests for User Story 1

> **NOTE: Write these tests FIRST, ensure they FAIL before implementation**

- [X] T010 [P] [US1] Test root directories exist in tests/validate-scaffold.ps1 (assert on each: docs, fdsl, flux, intermediates, runtime, temp, src, stdlib, t_llvm, t_wasm-1.0, t_wasm-2.0, t_wasm-3.0, t_benchmarks, t_general)
- [X] T011 [P] [US1] Test intermediates subdirectories exist (ast, ddg, lexer, llvm, parser, semantic, wat)
- [X] T012 [P] [US1] Test src subdirectories exist (flux_proto, flux_proto/ast, flux_proto/ddg, flux_proto/lexer, flux_proto/llvm, flux_proto/parser, flux_proto/semantic, flux_proto/vm, flux_proto/wasm, flux_proto/wat, flux_tests)
- [X] T013 [P] [US1] Test t_general QA subdirectories exist (matrices, metrics, negative, negative_false, positive, positive_false, regression)
- [X] T014 [P] [US1] Test idempotency — run scaffold twice and verify identical state

### Implementation for User Story 1

- [X] T015 [US1] Implement scaffold.ps1 — all root directories using New-Item -ItemType Directory -Force
- [X] T016 [P] [US1] Add intermediate subdirectory creation to scaffold.ps1
- [X] T017 [P] [US1] Add src subdirectory creation to scaffold.ps1
- [X] T018 [P] [US1] Add t_general QA subdirectory creation to scaffold.ps1
- [X] T019 [US1] Add .gitkeep placeholder files to all empty directories in scaffold.ps1
- [X] T020 [US1] Add performance timer to scaffold.ps1 (Write-Host duration, verify < 5s per SC-001)

**Checkpoint**: US1 is complete — scaffold creates all directories, validation suite passes, idempotency confirmed.

---

## Phase 4: User Story 2 - Add New Compilation Modules (Priority: P2)

**Goal**: The scaffold supports adding new compiler modules under `src/flux_proto/` via a parameter or separate function.

**Independent Test**: Call `.\scaffold.ps1 -AddModule "backend"` and verify `src/flux_proto/backend/` is created.

### Tests for User Story 2

- [X] T021 [P] [US2] Test that -AddModule parameter creates the module directory in tests/validate-scaffold.ps1
- [X] T022 [P] [US2] Test that -AddModule creates a .gitkeep in the new module directory

### Implementation for User Story 2

- [X] T023 [US2] Add -AddModule parameter to scaffold.ps1: `param([string[]]$AddModule)`
- [X] T024 [P] [US2] Implement Add-Module function in scaffold.ps1: create `src/flux_proto/<name>/`, add .gitkeep
- [X] T025 [US2] Add help comment to scaffold.ps1 documenting the -AddModule parameter

**Checkpoint**: US2 complete — new modules can be added via CLI parameter.

---

## Phase 5: User Story 3 - Create Target Directories for New Backends (Priority: P3)

**Goal**: The scaffold supports creating new target directories (e.g., `t_wasm-4.0/`) via a parameter.

**Independent Test**: Call `.\scaffold.ps1 -AddTarget "wasm-4.0"` and verify `t_wasm-4.0/` is created.

### Tests for User Story 3

- [X] T026 [P] [US3] Test that -AddTarget parameter creates the target directory
- [X] T027 [P] [US3] Test that -AddTarget creates a .gitkeep in the new target directory

### Implementation for User Story 3

- [X] T028 [US3] Add -AddTarget parameter to scaffold.ps1
- [X] T029 [P] [US3] Implement Add-Target function: create `t_<name>/` at root, add .gitkeep
- [X] T030 [US3] Add help comment to scaffold.ps1 documenting the -AddTarget parameter

**Checkpoint**: US3 complete — new targets can be added via CLI parameter.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Documentation, validation, and quality assurance

- [X] T031 [P] Add SC-002 idempotency test in tests/validate-scaffold.ps1 (run scaffold 3 times, assert identical state)
- [X] T032 [P] Add SC-004 placeholder test check in tests/validate-scaffold.ps1 (each test category dir has at least one file)
- [X] T033 Create example placeholder test files in t_general/ positive/, negative/, etc. (e.g., test_placeholder.py with doc comment showing expected format)
- [X] T034 Add sample matrix headers to t_general/matrices/*.csv files (rtm.csv, coverage.csv, defects.csv, test_cases.csv)
- [X] T035 Add initial metrics template to t_general/metrics/metrics.json
- [X] T036 Run quickstart.md validation steps manually and document results

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion — BLOCKS all user stories
- **User Stories (Phase 3+)**: All depend on Foundational phase completion
  - US1 (P1) runs first (MVP)
  - US2 (P2) and US3 (P3) can run in parallel after US1
- **Polish (Phase 6)**: Depends on all user stories being complete

### User Story Dependencies

- **US1 (P1)**: Can start after Foundational — independent
- **US2 (P2)**: Can start after US1 complete — adds optional parameter to scaffold
- **US3 (P3)**: Can start after US1 complete — adds optional parameter to scaffold

### Within Each User Story

- Tests FIRST (TDD: write failing test, implement, test passes)
- Core implementation before integration
- Story complete before moving to next priority

### Parallel Opportunities

- T002, T003, T004 (directory blocks) can run in parallel
- T010-T014 (tests for US1) can run in parallel
- T016-T018 (directory implementations) can run in parallel
- T021-T022 (US2 tests) can run in parallel
- T024 (US2 implement) depends on T023
- T026-T027 (US3 tests) can run in parallel
- T029 (US3 implement) depends on T028
- All Polish tasks (T031-T036) can run in parallel

---

## Parallel Example: User Story 1

```powershell
# Launch all tests for User Story 1 together:
Task: "Test root directories exist in tests/validate-scaffold.ps1"
Task: "Test intermediates subdirectories exist"
Task: "Test src subdirectories exist"
Task: "Test t_general QA subdirectories exist"
Task: "Test idempotency"

# Launch all implementations for User Story 1 together:
Task: "Add intermediate subdirectory creation to scaffold.ps1"
Task: "Add src subdirectory creation to scaffold.ps1"
Task: "Add t_general QA subdirectory creation to scaffold.ps1"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup (T001-T006)
2. Complete Phase 2: Foundational (T007-T009)
3. Complete Phase 3: User Story 1 (T010-T020)
4. **STOP and VALIDATE**: Run scaffold.ps1 + validate-scaffold.ps1
5. Deliver MVP — project structure is ready

### Incremental Delivery

1. Setup + Foundational → Structure initialized and validated
2. Add US1 → Complete scaffold with all directories (MVP!)
3. Add US2 → Module management (compile-time productivity)
4. Add US3 → Target management (new backend support)
5. Polish → Matrices, metrics, documentation

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story
- All paths relative to `D:\Projetos\TheFlux`
- Scaffold uses native PowerShell (`New-Item`), no external dependencies
- Verify tests fail before implementing
- Commit after each task or logical group
