# Tasks: Lexer Module Implementation

**Input**: Design documents from `specs/005-lexer-module-implementation/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/token-provider.md

**Tests**: Included per constitution's Zero-Regression Automated Testing mandate.

**Organization**: Tasks grouped by user story for independent implementation and testing.

## Format

- `[P]` = can run in parallel (different files, no dependencies)
- `[US#]` = maps to user story from spec.md
- Exact file paths in descriptions

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Initialize lexer/lexer `__init__.py` and test package structure

- [X] T001 Create lexer package `__init__.py` at `src/flux_proto/lexer/__init__.py`
- [X] T002 Create test package `__init__.py` at `src/flux_tests/lexer/__init__.py`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Character reader — lowest-level component every sub-module depends on

**CRITICAL**: No user story work can begin until this phase is complete

- [X] T003 Implement CharacterReader class in `src/flux_proto/lexer/reader.py` — byte-level source access, line/column tracking, line ending normalization (`\r\n`, `\r` → `\n`), strict ASCII 7-bit validation (byte > 0x7F → LEX001), TAB detection (→ TabulationError)

**Checkpoint**: Foundation ready — character reader with ASCII enforcement exists

---

## Phase 3: User Story 1 — Core Tokenization (Priority: P1)

**Goal**: The primary lexer skeleton that tokenizes identifiers, keywords, all operators, delimiters, number literals, string/char literals, and comments. This is the core tokenizer that every other story extends.

**Independent Test**: `python -c "from flux_proto.lexer.lexer import lex; tokens = list(lex('mut as int64: x = 42')); print(len(tokens))"` — should produce 10+ tokens ending with EOF

- [X] T004 [P] Implement keyword map and identifier classifier in `src/flux_proto/lexer/keywords.py` — maps all 59 keyword strings to their TokenType, classifies identifier style (snake_case/camelCase/PascalCase/SCREAMING_SNAKE), exposes `classify(word) -> TokenType`
- [X] T005 [P] Implement operator longest-match trie in `src/flux_proto/lexer/operators.py` — builds prefix-tree from all operator/delimiter strings, exposes `longest_match(reader) -> (TokenType, str)` prioritizing multi-char over single-char
- [X] T006 [US1] Implement main `lex()` generator in `src/flux_proto/lexer/lexer.py` — orchestrates reader/keywords/operators to tokenize identifiers (generic_lower, generic_upper, constant, system_wildcard), keywords, all operators, delimiters, number literals (integer, float, complex with i/j), string literals (basic `"..."` with escape handling), char literals (`'...'`), line/block comments, and emits EOL/EOF
- [ ] T007 [P] [US1] Write unit tests for keywords in `src/flux_tests/lexer/test_keywords.py`
- [ ] T008 [P] [US1] Write unit tests for operators in `src/flux_tests/lexer/test_operators.py`
- [ ] T009 [US1] Write integration test for full-program lexing in `src/flux_tests/lexer/test_integration.py` — lex valid `.flux` programs, verify token sequence matches expectations

**Checkpoint**: US1 complete — `lex()` handles all core token types for any valid `.flux`/`.fdsl` program

---

## Phase 4: User Story 3 — Structural Lexing with Indentation (Priority: P1)

**Goal**: Indentation tracking: emit INDENT/DEDENT based on 6-space units, suppress within `()` `[]`, reject tabs and multi-level jumps.

**Independent Test**: `python -c "from flux_proto.lexer.lexer import lex; tokens = list(lex('program (A)\n{\n      x = 1\n}'))"` — verify INDENT appears before `x`, DEDENT before `}`

- [X] T010 [P] [US3] Implement IndentTracker class in `src/flux_proto/lexer/indent.py` — stack-based level tracking, 6-space unit enforcement, `()/[]` bracket-depth suspension, multi-level jump rejection (TabulationError)
- [X] T011 [US3] Integrate IndentTracker into `lex()` in `src/flux_proto/lexer/lexer.py` — at line start, consult IndentTracker before dispatching first token; pass bracket tokens to IndentTracker to track suspension depth
- [X] T012 [P] [US3] Write indentation unit tests in `src/flux_tests/lexer/test_indent.py`

**Checkpoint**: US3 complete — lexer handles significant indentation, tab rejection, bracket suppression

---

## Phase 5: User Story 2 — Strict ASCII Enforcement (Priority: P1)

**Goal**: Comprehensive testing and edge-case hardening of ASCII validation. Reader already enforces ASCII (T003); this phase adds systematic tests covering all paths.

**Independent Test**: `python -c "from flux_proto.lexer.lexer import lex; list(lex('caf\u00e9'))"` — must raise LexicalError with code LEX001

- [ ] T013 [US2] Write negative tests for LEX001 in `src/flux_tests/lexer/test_errors.py` — non-ASCII in identifiers, strings, comments, docstrings, operators — all must raise LexicalError with `code='LEX001'`
- [ ] T014 [P] [US2] Write negative tests for TabulationError in `src/flux_tests/lexer/test_errors.py` — tab at line start, tab in string, tab in comment — all must raise TabulationError
- [ ] T015 [US2] Write negative tests for unterminated constructs in `src/flux_tests/lexer/test_errors.py` — unterminated string, unterminated `#B` comment, unterminated `#D` docstring — all must raise LexicalError

**Checkpoint**: US2 complete — all encoding and structural error paths tested

---

## Phase 6: User Story 4 — String Interpolation Support (Priority: P2)

**Goal**: Stateful interpolation lexer for `"Hello #{name}"` — emit INTERPOLATED_STRING_START, INTERPOLATED_TEXT, INTERPOLATION_OPEN, INTERPOLATION_CLOSE, INTERPOLATED_STRING_END with balanced `{}` tracking.

**Independent Test**: `python -c "from flux_proto.lexer.lexer import lex; tokens = list(lex('\"x = #{1 + 2}\"')); assert any(t.type.name == 'INTERPOLATION_OPEN' for t in tokens)"`

- [ ] T016 [P] [US4] Implement InterpolationLexer state machine in `src/flux_proto/lexer/interpolation.py` — tracks NORMAL/IN_INTERPOLATED_STRING/IN_INTERPOLATION_EXPR modes, brace-depth counter, text buffer; emits INTERPOLATED_* tokens
- [ ] T017 [US4] Integrate InterpolationLexer into `lex()` in `src/flux_proto/lexer/lexer.py` — on `"` before string content, delegate to InterpolationLexer until closing `"`
- [ ] T018 [US4] Write interpolation unit tests in `src/flux_tests/lexer/test_interpolation.py` — simple interpolation, nested braces, empty interpolation `"#{ }"`, unterminated interpolation

**Checkpoint**: US4 complete — interpolated strings lexed with correct token sequence

---

## Phase 7: User Story 5 — Docstring Attachment (Priority: P2)

**Goal**: `#D ... D#` docstrings lexed and emitted as DOCSTRING tokens with key-value field extraction.

**Independent Test**: `python -c "from flux_proto.lexer.lexer import lex; tokens = list(lex('#D\nDoc\nD#\nfunction (f) () {}')); assert any(t.type.name == 'DOCSTRING' for t in tokens)"`

- [ ] T019 [US5] Implement docstring parsing in `src/flux_proto/lexer/lexer.py` — handle `#D` trigger, accumulate content until `D#`, emit DOCSTRING token with content, extract key-value fields from bullet lines
- [ ] T020 [US5] Write docstring unit tests in `src/flux_tests/lexer/test_docstring.py` — basic docstring, docstring with key-value fields, zero-length docstring `#D\nD#`, unterminated docstring, docstring before function/struct/agent declarations

**Checkpoint**: US5 complete — docstrings lexed and attached to subsequent declarations

---

## Phase 8: User Story 6 — Multi-Target Token Stream Consistency (Priority: P2)

**Goal**: Verify the same token stream feeds all five backend targets without re-lexing. Integration tests shell out to wasmer/wabt for WASM validation.

**Independent Test**: `python -m flux_proto "flux/samples/hello.flux" --target run && python -m flux_proto "flux/samples/hello.flux" --target vmbc -o temp/hello` — both succeed

- [ ] T021 [US6] Create sample valid `.flux` programs in `flux/samples/` — `hello.flux`, `math.flux`, `agent_test.fdsl`
- [ ] T022 [US6] Write multi-target integration tests in `src/flux_tests/lexer/test_multitarget.py` — lex once, verify parser/AST consumption works for all five targets (interpreter, VM, LLVM, WAT, WASM)
- [ ] T023 [P] [US6] Add compliance matrix tests in `tests/t_general/matrices/` — verify every major token type appears in at least one test case (coverage for SC-002)
- [ ] T024 [US6] Verify `--emit-lexer` CLI flag works end-to-end in `src/flux_tests/lexer/test_multitarget.py` — lex a file, write JSON to `intermediates/lexer/`, verify JSON structure matches expected format

**Checkpoint**: US6 complete — single lexer pass feeds all five backends

---

## Phase 9: Polish & Cross-Cutting Concerns

**Purpose**: Edge-case hardening, performance baseline, and documentation updates

- [ ] T025 [P] Add edge-case positive tests: empty file, whitespace-only file, comment-only file, deeply nested indentation (50 levels), sequential operator edge cases (`-->>`, `====`, `.....`) in `src/flux_tests/lexer/test_edge_cases.py`
- [ ] T026 [P] Add false-positive tests: constructs that look invalid but are valid (empty docstring, lone `-` as MINUS operator, `D` without `#` inside docstring) in `src/flux_tests/lexer/test_positive_false.py`
- [ ] T027 [P] Add false-negative tests: constructs that look valid but are invalid (keyword as identifier, multi-level indent jump) in `src/flux_tests/lexer/test_negative_false.py`
- [ ] T028 Run the quickstart validation guide from `specs/005-lexer-module-implementation/quickstart.md` — verify all 9 validation scenarios pass

**Checkpoint**: Lexer implementation complete — all tasks done

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — start immediately
- **Foundational (Phase 2)**: Depends on Setup — BLOCKS all user stories
- **US1 (Phase 3)**: Depends on Foundational — core skeleton
- **US3 (Phase 4)**: Depends on US1 — IndentTracker integrates into `lex()` orchestrator
- **US2 (Phase 5)**: Depends on Foundational — tests reader.py; can run in parallel with US1 non-test tasks
- **US4 (Phase 6)**: Depends on US1 — InterpolationLexer integrates into `lex()` string handling
- **US5 (Phase 7)**: Depends on US1 — docstring parsing is part of `lex()` dispatcher
- **US6 (Phase 8)**: Depends on US1 + sample files — integration validation
- **Polish (Phase 9)**: Depends on all user stories

### User Story Dependencies

- **US1 (P1)**: Core — after Foundational
- **US3 (P1)**: After US1 (needs lexer skeleton for integration)
- **US2 (P1)**: After Foundational — can parallel with US1
- **US4 (P2)**: After US1 — needs string handling in place
- **US5 (P2)**: After US1
- **US6 (P2)**: After all P1 stories

### Within Each User Story

- Tests and implementation are separate tasks
- Models before integration
- Implementation before tests-in-the-same-phase

### Parallel Opportunities

- T004 and T005 can run in parallel (keywords.py + operators.py)
- T007 and T008 can run in parallel (keyword tests + operator tests)
- T010, T013, T014, T016 can run in parallel (indent.py + error tests + interpolation.py)
- T025, T026, T027 can run in parallel (edge case tests)

---

## Parallel Example: User Story 1

```bash
# Launch keyword map + operator trie together:
Task: "Implement keyword map in keywords.py"
Task: "Implement operator trie in operators.py"

# Launch keyword tests + operator tests together:
Task: "Write keyword unit tests"
Task: "Write operator unit tests"
```

---

## Implementation Strategy

### MVP First (Phases 1-3)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (reader.py)
3. Complete Phase 3: US1 Core Tokenization
4. **STOP and VALIDATE**: `python -m flux_proto "flux/samples/hello.flux" --emit-lexer`

### Incremental Delivery

1. Phase 1-3 → Core lexer working → MVP!
2. Phase 4 → Indentation (US3) → structural lexing complete
3. Phase 5 → ASCII error tests (US2) → error hardening
4. Phase 6 → Interpolation (US4) → advanced string support
5. Phase 7 → Docstrings (US5) → documentation support
6. Phase 8 → Multi-target (US6) → integration validation
7. Phase 9 → Polish → edge cases and performance

---

## Notes

- [P] tasks = different files, no dependencies
- [US#] maps to spec.md user stories
- Each user story independently completable and testable
- Commit after each task or logical group
- Stop at any checkpoint to validate
