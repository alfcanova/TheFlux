---

description: "Task list for EBNF Spec Analysis feature"

---

# Tasks: EBNF Spec Analysis

**Input**: Design documents from `/specs/003-ebnf-spec-analysis/`

**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: Test tasks are included for the extraction script validation.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- **Single project**: All paths relative to project root `D:\Projetos\TheFlux`
- **Extraction script**: `specs/003-ebnf-spec-analysis/extract_ebnf.py`
- **Output file**: `docs/TheFlux.ebnf`
- **Source grammar**: `docs/grammar.md`

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Prepare extraction script infrastructure

- [x] T001 Create extraction directory `specs/003-ebnf-spec-analysis/` with Python venv-ready structure
- [x] T002 [P] Add validation helper functions to extract_ebnf.py (production count, ASCII check, markdown artifact detection)
- [x] T003 Add ASCII 7-bit encoding enforcement to extract_ebnf.py output writer

**Checkpoint**: Extraction script runs, produces valid ASCII output.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Extraction engine that MUST be complete before analysis tasks begin

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [x] T004 Build core extraction engine in specs/003-ebnf-spec-analysis/extract_ebnf.py that parses grammar.md sections 1-12 and isolates EBNF productions from narrative text
- [x] T005 [P] Handle multi-line production formats in extract_ebnf.py: (a) name+`::=` on same line, (b) name on separate line from `::=`
- [x] T006 [P] Handle continuation lines in extract_ebnf.py (indented alternatives, `|` operator across lines)
- [x] T007 [P] Convert C-style comments `/* ... */` to EBNF-style `(* ... *)` in extract_ebnf.py
- [x] T008 [P] Strip Markdown artifacts (section headers, bullet lists, tables) from EBNF output
- [x] T009 Add production count verification to extract_ebnf.py (assert >= 200 productions after extraction)
- [x] T010 Run extraction and validate output in docs/TheFlux.ebnf (ASCII encoding, production count)

**Checkpoint**: Extraction engine complete — `docs/TheFlux.ebnf` generated with 209 productions, clean of artifacts.

---

## Phase 3: User Story 1 - Documented EBNF Grammar Structure (Priority: P1) 🎯 MVP

**Goal**: Produce the analysis document categorizing all grammar constructs by domain with purpose descriptions.

**Independent Test**: Cross-reference each entry in the analysis against grammar.md sections 1-12 to verify complete coverage.

### Tests for User Story 1

> **NOTE: Write these tests FIRST, ensure they FAIL before implementation**

- [x] T011 [P] [US1] Test analysis coverage: verify all 7 grammar domains are listed in the analysis
- [x] T012 [P] [US1] Test production count: assert all 209 productions from TheFlux.ebnf are referenced in the analysis

### Implementation for User Story 1

- [x] T013 [US1] Create grammar analysis document in specs/003-ebnf-spec-analysis/grammar-analysis.md with domain-organized table of all 209 productions
- [x] T014 [P] [US1] Document Lexical domain productions (characters, identifiers, keywords, operators, comments, ~60 prods) in grammar-analysis.md
- [x] T015 [P] [US1] Document Types domain productions (scalar, tensor, type_ref, ~14 prods) in grammar-analysis.md
- [x] T016 [P] [US1] Document Expressions domain productions (precedence hierarchy, primaries, patterns, ~33 prods) in grammar-analysis.md
- [x] T017 [P] [US1] Document Statements domain productions (control flow, route, infinite, emit, ~14 prods) in grammar-analysis.md
- [x] T018 [P] [US1] Document Declarations domain productions (struct, enum, contract, agent, function, variable, macro, ~35 prods) in grammar-analysis.md
- [x] T019 [P] [US1] Document Module Structure domain productions (flux_file, fdsl_file, documented_*, ~12 prods) in grammar-analysis.md
- [x] T020 [P] [US1] Document Diagnostics domain productions (diagnostic format, error codes, ~7 prods) in grammar-analysis.md
- [x] T021 [US1] Add semantic constraint annotations to grammar-analysis.md (mark productions enforced outside grammar)
- [x] T022 [US1] Add core vs. auxiliary classification to each production entry in grammar-analysis.md
- [x] T023 [US1] Cross-reference each production with grammar.md section and line numbers in grammar-analysis.md

**Checkpoint**: Grammar analysis document complete — all 209 productions documented by domain with purpose, constraints, and cross-references.

---

## Phase 4: User Story 2 - Grammar Domain Map (Priority: P2)

**Goal**: Create a quick-reference domain map organized by language feature category.

**Independent Test**: Each grammar domain maps to grammar.md sections — verify by section cross-reference.

### Tests for User Story 2

- [x] T024 [P] [US2] Test domain map includes all 7 grammar domains
- [x] T025 [P] [US2] Test each domain entry cross-references the correct grammar.md sections

### Implementation for User Story 2

- [x] T026 [US2] Create domain map section in grammar-analysis.md with navigation table (domain → sections → production count → key productions)
- [x] T027 [P] [US2] Add production dependency graph showing which productions reference which others across domains in grammar-analysis.md
- [x] T028 [US2] Add quick-reference tables for operators (math, relation, bitwise, assignment, dataflow) in grammar-analysis.md
- [x] T029 [US2] Add quick-reference table for all 53 keywords grouped by category in grammar-analysis.md
- [x] T030 [US2] Final review: verify grammar-analysis.md covers all FR-001 through FR-005 requirements

**Checkpoint**: Domain map complete — grammar-analysis.md provides navigable reference organized by domain.

---

## Phase 5: Polish & Cross-Cutting Concerns

**Purpose**: Validation, refinement, and documentation

- [x] T031 [P] Run full validation suite from quickstart.md against docs/TheFlux.ebnf
- [x] T032 Update extract_ebnf.py header comment with version and extraction date
- [x] T033 [P] Add unit tests for extraction edge cases (multi-line, special sequences, embedded comments)
- [x] T034 Verify all 12 grammar.md sections are represented in the extraction output
- [x] T035 Add change-log entry at the end of grammar-analysis.md documenting analysis version

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion — BLOCKS all user stories
- **User Stories (Phase 3+)**: All depend on Foundational phase completion
  - US1 (P1) runs first (MVP)
  - US2 (P2) runs after US1
- **Polish (Phase 5)**: Depends on all user stories being complete

### User Story Dependencies

- **US1 (P1)**: Can start after Foundational — independent
- **US2 (P2)**: Can start after US1 complete — adds domain map onto analysis

### Within Each User Story

- Tests FIRST (write failing test, implement, test passes)
- Domain documentation before cross-cutting annotations
- Story complete before moving to next priority

### Parallel Opportunities

- T002, T003 (setup helpers) can run in parallel
- T005-T008 (extraction features) can run in parallel
- T011-T012 (US1 tests) can run in parallel
- T014-T020 (domain documentation) can run in parallel
- T024-T025 (US2 tests) can run in parallel

---

## Parallel Example: User Story 1

```bash
# Launch all domain documentation tasks together:
Task: "Document Lexical domain in specs/003-ebnf-spec-analysis/grammar-analysis.md"
Task: "Document Types domain in specs/003-ebnf-spec-analysis/grammar-analysis.md"
Task: "Document Expressions domain in specs/003-ebnf-spec-analysis/grammar-analysis.md"
Task: "Document Statements domain in specs/003-ebnf-spec-analysis/grammar-analysis.md"
Task: "Document Declarations domain in specs/003-ebnf-spec-analysis/grammar-analysis.md"
Task: "Document Module Structure domain in specs/003-ebnf-spec-analysis/grammar-analysis.md"
Task: "Document Diagnostics domain in specs/003-ebnf-spec-analysis/grammar-analysis.md"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (extraction engine)
3. Complete Phase 3: User Story 1 (grammar analysis document)
4. **STOP and VALIDATE**: Run validation suite, verify docs/TheFlux.ebnf is clean
5. Deliver MVP — grammar analysis document with all 209 productions categorized

### Incremental Delivery

1. Setup + Foundational → Extraction engine complete, EBNF file generated
2. Add US1 → Grammar analysis with all domains documented (MVP!)
3. Add US2 → Domain map with quick-reference tables
4. Polish → Validation, edge case tests, documentation

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story
- All paths relative to `D:\Projetos\TheFlux`
- Extraction script uses Python 3 (stdlib only — `re`, `pathlib`)
- Output file `docs/TheFlux.ebnf` must be ASCII 7-bit per constitution
- Verify tests fail before implementing
- Commit after each task or logical group
