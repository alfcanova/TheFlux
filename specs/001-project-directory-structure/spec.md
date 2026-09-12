# Feature Specification: Project Directory Structure

**Feature Branch**: `001-project-directory-structure`

**Created**: 2026-07-21

**Status**: Draft

**Input**: User description: "vamos criar, quando e se necessario, a Estrutura da Pasta de Desenvolvimento da linguagem TheFlux"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Initialize Canonical Directory Layout (Priority: P1)

As a developer setting up the TheFlux project, I want to create the complete canonical directory structure so that all source code, documentation, intermediate artifacts, test suites, and quality matrices have a predefined home.

**Why this priority**: The directory layout is the foundation for all subsequent development. Without it, modules have no standard location, and the modularity required by the constitution cannot be enforced.

**Independent Test**: Can be fully tested by running the scaffold script and verifying every expected directory exists and is empty.

**Acceptance Scenarios**:

1. **Given** an empty repository root, **When** the scaffold script is executed, **Then** all root-level directories are created: `docs/`, `fdsl/`, `flux/`, `intermediates/`, `runtime/`, `temp/`, `src/`, `stdlib/`, `t_llvm/`, `t_wasm-1.0/`, `t_wasm-2.0/`, `t_wasm-3.0/`, `t_benchmarks/`, `t_general/`
2. **Given** the scaffold script has run, **When** I inspect `src/`, **Then** `src/flux_proto/` and `src/flux_tests/` exist
3. **Given** the scaffold script has run, **When** I inspect `intermediates/`, **Then** `ast/`, `ddg/`, `lexer/`, `llvm/`, `parser/`, `semantic/`, `wat/` subdirectories exist
4. **Given** the scaffold script has run, **When** I inspect `t_general/`, **Then** `matrices/`, `metrics/`, `negative/`, `negative_false/`, `positive/`, `positive_false/`, `regression/` subdirectories exist

---

### User Story 2 - Add New Compilation Modules (Priority: P2)

As a compiler developer, I want to add new modules under `src/flux_proto/` (e.g., `vm/`, `wasm/`, `backend/`, `frontend/`) so that each compiler phase is independently developed and tested per the modularity principle.

**Why this priority**: Modular compilation is a constitutional requirement. New backends and phases must have a clear place without disrupting existing structure.

**Independent Test**: Can be tested by creating a new module directory under `src/flux_proto/` and verifying it is recognized by the compilation CLI.

**Acceptance Scenarios**:

1. **Given** the project structure is initialized, **When** a new module `vm/` is added under `src/flux_proto/`, **Then** the compilation CLI discovers and includes it
2. **Given** a new module is added, **When** it follows the modular pattern, **Then** it can be independently tested via the test suite CLI

---

### User Story 3 - Create Target Directories for New Backends (Priority: P3)

As a build engineer, I want to create target directories (e.g., `t_wasm-4.0/`) when new WASM spec versions or backends are added so that each target has its own generation, validation, and test space.

**Why this priority**: New backends should follow the same pattern as existing `t_*` directories without manual structural decisions.

**Independent Test**: Can be tested by adding a new `t_*` directory and verifying the target CLI entries and test matrices recognize it.

**Acceptance Scenarios**:

1. **Given** a new WASM spec version is targeted, **When** a `t_wasm-4.0/` directory is created, **Then** it mirrors the structure of existing `t_wasm-*` directories

---

### Edge Cases

- What happens when a directory already exists? Scaffold script MUST be idempotent (no overwrite, no error).
- How does the system handle symbolic links or junctions in the directory tree?
- How are temp files cleaned up from `temp/`?

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: A scaffold script SHALL create the complete canonical directory tree from the project root.
- **FR-002**: The scaffold script MUST be idempotent — running it multiple times MUST NOT produce errors or overwrite existing content.
- **FR-003**: All source modules under `src/flux_proto/` MUST follow the modular pattern defined in the constitution.
- **FR-004**: Each `t_*` target directory MUST be self-contained for generation, validation, and testing of its respective backend.
- **FR-005**: The `t_general/` quality suite MUST include matrices (RTM, coverage, defects, test cases), metrics tracking (metrics.json), and test category subdirectories (positive, negative, false positive, false negative, regression).
- **FR-006**: The `intermediates/` directory MUST store debug output from compiler flags (`--emit-ast`, `--emit-dd g`, `--emit-lexer`, `--emit-llvm`, `--emit-parser`, `--emit-semantic`, `--emit-wat`), each in its own subdirectory.
- **FR-007**: The `temp/` directory MUST be used for all temporary script artifacts and MAY be cleaned at any time.

### Key Entities

- **Project Root**: Top-level container for all TheFlux project artifacts.
- **Source Module** (`src/flux_proto/*`): Independent compiler phase (lexer, parser, semantic, AST, DDG, VM, WASM, LLVM backend, etc.).
- **Target Directory** (`t_*`): Self-contained workspace for a specific compilation target's artifacts, validation, and tests.
- **Quality Matrix** (`t_general/matrices/*.csv`): Structured data files for traceability, coverage, defects, and test case management.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: The scaffold script creates all 14+ root directories and 15+ subdirectories in under 5 seconds.
- **SC-002**: Idempotency verified — running the scaffold 3 times sequentially produces zero errors and identical directory state.
- **SC-003**: Each `src/flux_proto/` module can be independently imported and tested without loading unrelated modules.
- **SC-004**: All `t_general/` test category subdirectories contain at least one placeholder test file demonstrating the expected test format.

## Assumptions

- The scaffold script uses native Windows tools (PowerShell cmdlets: `New-Item`) and lives at the project root (`scaffold.ps1`).
- New modules added to `src/flux_proto/` require a minimum `__init__.py` to be Python packages.
- The `.gitkeep` or `.gitignore` pattern is used to track empty directories in version control.
- Target WASM versions (1.0, 2.0, 3.0) reflect the current WebAssembly specification milestones available for TheFlux.
