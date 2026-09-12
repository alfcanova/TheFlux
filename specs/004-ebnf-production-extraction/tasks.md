---

description: "Task list for EBNF Production Extraction feature"

---

# Tasks: EBNF Production Extraction

**Input**: Design documents from `/specs/004-ebnf-production-extraction/`

**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: Test tasks are included for the extraction script validation.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- **Single project**: All paths relative to project root `D:\Projetos\TheFlux`
- **Extraction script**: `specs/004-ebnf-production-extraction/extract_ebnf.py`
- **Output file**: `docs/TheFlux.ebnf`
- **Source grammar**: `docs/grammar.md`

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Prepare extraction script infrastructure

- [x] T001 Create extraction script at `specs/004-ebnf-production-extraction/extract_ebnf.py` with module docstring, `__main__` entry point, and argument parsing for source/output paths
- [x] T002 [P] Add helper functions for file I/O (read grammar.md, write EBNF output, mkdir output parent) in `extract_ebnf.py`
- [x] T003 Add section boundary detection functions (find sections 1-12 and 14) in `extract_ebnf.py`

**Checkpoint**: Script skeleton exists and runs without errors.

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core semicolon-terminated extraction engine — MUST be complete before any user story

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

- [x] T004 Build core state-machine extraction engine in `extract_ebnf.py` that parses grammar.md using `;` as the definitive production terminator, accumulating body text across newlines until `;` is found
- [x] T005 [P] Handle production names on separate lines from `::=` — join name to `::=` when they appear on consecutive lines in `extract_ebnf.py`
- [x] T006 [P] Handle continuation lines (indented alternatives, `|` operator across lines) as part of the same production in `extract_ebnf.py`
- [x] T007 [P] Strip C-style comments (`/* ... */`) from production bodies and section headers in `extract_ebnf.py`
- [x] T008 [P] Exclude Markdown artifacts (section headers `##`, table rows `|`, bullet lists `-`, horizontal rules `---`) in `extract_ebnf.py`
- [x] T009 [P] Exclude narrative text (sentences, paragraphs, explanations) that does not match production syntax in `extract_ebnf.py`
- [x] T010 [P] Preserve EBNF special sequences (`?...?`) verbatim in output in `extract_ebnf.py`
- [x] T011 Extend extraction range to include section 14 (CONTRATO DE DIAGNOSTICO) in addition to sections 1-12 in `extract_ebnf.py`
- [x] T012 Add header comment block to output with version, source path, and extraction date in `extract_ebnf.py`

**Checkpoint**: Core extraction engine complete — runs against grammar.md and produces `docs/TheFlux.ebnf` with production output.

---

## Phase 3: User Story 1 - Extract EBNF Productions from grammar.md (Priority: P1) 🎯 MVP

**Goal**: Produce a complete, clean EBNF extraction file with all productions properly semicolon-terminated and free of artifacts.

**Independent Test**: Run the extractor and verify the output contains complete productions (each ending with `;`), no truncated multi-line entries, and no narrative text or Markdown artifacts.

### Tests for User Story 1

> **NOTE**: Write these tests FIRST, ensure they FAIL before implementation

- [x] T013 [P] [US1] Test single-line production: verify `letter ::= lower_letter | upper_letter ;` is extracted as a single complete line with `;` terminator
- [x] T014 [P] [US1] Test multi-line production: verify `nonzero_digit ::= "1" | ...` spanning 2+ lines is accumulated into one complete production ending with `;`
- [x] T015 [P] [US1] Test no narrative text: verify sentences and bullet lists are excluded from output
- [x] T016 [P] [US1] Test no Markdown artifacts: verify section headers, table rows, horizontal rules are excluded

### Implementation for User Story 1

- [x] T017 [US1] Integrate all extraction features into a single `extract_ebnf()` function in `extract_ebnf.py`: section boundary detection, semicolon-terminated parsing, name joining, comment stripping, artifact exclusion, special sequence preservation
- [x] T018 [US1] Run extraction against `docs/grammar.md` and validate output in `docs/TheFlux.ebnf` — manual review of first 20 and last 10 productions for correct termination

**Checkpoint**: `docs/TheFlux.ebnf` generated with complete, artifact-free productions.

---

## Phase 4: User Story 2 - Validate Extracted Output (Priority: P1)

**Goal**: Validate that the extracted EBNF file is clean, complete, and conforms to project standards.

**Independent Test**: Run the validation suite against `docs/TheFlux.ebnf`. Confirm ASCII encoding, production count >= 200, and zero Markdown artifacts.

### Tests for User Story 2

> **NOTE**: Write these tests FIRST, ensure they FAIL before implementation

- [x] T019 [P] [US2] Test ASCII encoding validator: verify it detects non-ASCII bytes in a crafted test file
- [x] T020 [P] [US2] Test production count validator: verify it fails when count < 200 in a crafted test file
- [x] T021 [P] [US2] Test Markdown artifact detector: verify it catches `##`, table rows, and list markers in a crafted test file

### Implementation for User Story 2

- [x] T022 [P] [US2] Add `validate_production_count()` function to `extract_ebnf.py` — counts `::=` occurrences, asserts >= 200
- [x] T023 [P] [US2] Add `validate_ascii_encoding()` function to `extract_ebnf.py` — scans for bytes > 0x7F
- [x] T024 [P] [US2] Add `validate_no_markdown_artifacts()` function to `extract_ebnf.py` — checks for `##`, `| table`, `---`, `- `, `* ` patterns
- [x] T025 [US2] Add `run_all_validations()` orchestrator to `extract_ebnf.py` that runs all three validations and reports PASS/FAIL
- [x] T026 [US2] Run full extraction + validation and confirm all three checks pass

**Checkpoint**: Validation suite integrated — extraction produces PASS on all checks.

---

## Phase 5: User Story 3 - Grammar Analysis Document (Priority: P2)

**Goal**: Produce a domain-organized analysis document listing all extracted productions with purpose descriptions and cross-references.

**Independent Test**: Verify the analysis document references every production from `docs/TheFlux.ebnf` at least once, grouped by domain.

### Tests for User Story 3

> **NOTE**: Write these tests FIRST, ensure they FAIL before implementation

- [x] T027 [P] [US3] Test domain coverage: verify all 7 grammar domains are listed in the analysis
- [x] T028 [P] [US3] Test production coverage: assert all N productions from `docs/TheFlux.ebnf` are referenced in the analysis

### Implementation for User Story 3

- [x] T029 [US3] Create grammar analysis document at `specs/004-ebnf-production-extraction/grammar-analysis.md` with domain-organized table of all productions
- [x] T030 [P] [US3] Document Lexical domain (characters, identifiers, keywords, operators, comments, literals) in `grammar-analysis.md`
- [x] T031 [P] [US3] Document Types domain (scalar, tensor, type_ref) in `grammar-analysis.md`
- [x] T032 [P] [US3] Document Expressions domain (precedence hierarchy, primaries, patterns, postfix) in `grammar-analysis.md`
- [x] T033 [P] [US3] Document Statements domain (control flow, route, infinite, emit, unsafe) in `grammar-analysis.md`
- [x] T034 [P] [US3] Document Declarations domain (struct, enum, contract, agent, function, variable, macro) in `grammar-analysis.md`
- [x] T035 [P] [US3] Document Module Structure domain (flux_file, fdsl_file, documented_*) in `grammar-analysis.md`
- [x] T036 [P] [US3] Document Diagnostics domain (diagnostic format, error codes) in `grammar-analysis.md`
- [x] T037 [US3] Add semantic constraint annotations for productions enforced outside formal grammar in `grammar-analysis.md`
- [x] T038 [US3] Cross-reference each production with grammar.md section and line numbers in `grammar-analysis.md`

**Checkpoint**: Grammar analysis document complete — all productions documented by domain with purpose, constraints, and cross-references.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Validation, refinement, and documentation

- [x] T039 [P] Run full validation suite from `quickstart.md` against `docs/TheFlux.ebnf`
- [x] T040 Update `extract_ebnf.py` header comment with version and extraction date
- [x] T041 [P] Add unit tests for extraction edge cases (multi-line, special sequences, embedded comments) in `extract_ebnf.py`
- [x] T042 Verify all 12 grammar.md sections (1-12) plus section 14 are represented in the extraction output
- [x] T043 Add change-log entry at the end of `grammar-analysis.md` documenting analysis version

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion — BLOCKS all user stories
- **User Stories (Phase 3+)**: All depend on Foundational phase completion
  - US1 (P1) runs first (MVP)
  - US2 (P1) runs after US1 (needs output to validate)
  - US3 (P2) runs after US2 (needs validated output)
- **Polish (Phase 6)**: Depends on all user stories being complete

### User Story Dependencies

- **US1 (P1)**: Can start after Foundational — independent
- **US2 (P1)**: Can start after US1 — validates US1's output
- **US3 (P2)**: Can start after US2 — uses validated EBNF as source

### Within Each User Story

- Tests FIRST (write failing test, implement, test passes)
- Core implementation before refinement
- Story complete before moving to next priority

### Parallel Opportunities

- T002, T003 (setup helpers) can run in parallel
- T005-T010 (extraction features) can run in parallel
- T013-T016 (US1 tests) can run in parallel
- T019-T021 (US2 tests) can run in parallel
- T022-T024 (US2 validators) can run in parallel
- T027-T028 (US3 tests) can run in parallel
- T030-T036 (domain documentation) can run in parallel
- T039, T041 (polish) can run in parallel

---

## Parallel Example: User Story 1

```bash
# Launch all tests for User Story 1 together:
Task: "Test single-line production in extract_ebnf.py"
Task: "Test multi-line production in extract_ebnf.py"
Task: "Test no narrative text in extract_ebnf.py"
Task: "Test no Markdown artifacts in extract_ebnf.py"
```

## Parallel Example: User Story 3

```bash
# Launch all domain documentation tasks together:
Task: "Document Lexical domain in grammar-analysis.md"
Task: "Document Types domain in grammar-analysis.md"
Task: "Document Expressions domain in grammar-analysis.md"
Task: "Document Statements domain in grammar-analysis.md"
Task: "Document Declarations domain in grammar-analysis.md"
Task: "Document Module Structure domain in grammar-analysis.md"
Task: "Document Diagnostics domain in grammar-analysis.md"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (extraction engine)
3. Complete Phase 3: User Story 1 (full extraction)
4. **STOP and VALIDATE**: Run quickstart validation, verify docs/TheFlux.ebnf is clean
5. Deliver MVP — extraction script produces clean EBNF output

### Incremental Delivery

1. Setup + Foundational → Core extraction engine complete
2. Add US1 → Full extraction with all edge cases (MVP!)
3. Add US2 → Validation suite ensures quality
4. Add US3 → Grammar analysis document
5. Polish → Validation, edge case tests, documentation

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story
- All paths relative to `D:\Projetos\TheFlux`
- Extraction script uses Python 3 (stdlib only — `re`, `pathlib`)
- Output file `docs/TheFlux.ebnf` must be ASCII 7-bit per constitution
- Verify tests fail before implementing
- Commit after each task or logical group
