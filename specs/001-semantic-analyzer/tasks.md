# Tasks: Semantic Analyzer

**Input**: Design documents from `/specs/001-semantic-analyzer/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/

**Tests**: Included per constitution's Zero-Regression Automated Testing mandate (SC-007).

**Organization**: Tasks grouped by user story for independent implementation and testing.

## Format

- `[P]` = can run in parallel (different files, no dependencies)
- `[US#]` = maps to user story from spec.md
- Exact file paths in descriptions

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Initialize semantic package, test package, and core shared types

- [ ] T001 Create semantic package `__init__.py` at `src/flux_proto/semantic/__init__.py` — re-export `analyze()` and `SemanticError`
- [ ] T002 Create semantic test package `__init__.py` at `src/flux_tests/semantic/__init__.py`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core types that every user story depends on — Diagnostic, Type hierarchy, AST decorator

**CRITICAL**: No user story work can begin until this phase is complete

- [ ] T003 [P] Implement `Diagnostic` dataclass and `DiagnosticFormatter` in `src/flux_proto/semantic/diagnostic.py` — codes SEM001/SEM002/SUG, severity enum, unified format `file:line,col -> [CODE]: message`
- [ ] T004 [P] Implement Type hierarchy in `src/flux_proto/semantic/types.py` — `Type`, `PrimitiveType`, `ListType`, `SetType`, `MapType`, `TensorType`, `StructType`, `EnumType`, `FunctionType`, `TypeVar`; compatibility checking and widening rules per `contracts/type-system.md`
- [ ] T005 [P] Implement `ASTDecorator` in `src/flux_proto/semantic/ast_decorator.py` — attach `semantics` dict to ASTNode, store `SemanticAnnotation` (resolved_type, symbol, ownership_before, ownership_after, diagnostics)
- [ ] T006 Write foundational tests in `src/flux_tests/semantic/test_diagnostics.py` — Diagnostic creation, formatting, severity labels

**Checkpoint**: Foundation ready — user story implementation can begin

---

## Phase 3: User Story 1 — Symbol Table and Scope Resolution (Priority: P1) 🎯 MVP

**Goal**: Build hierarchical symbol table from AST, resolve `use` imports, detect duplicates and unresolved references.

**Independent Test**: `python -c "from flux_proto.lexer import lex; from flux_proto.parser import parse; from flux_proto.semantic import analyze; tokens = lex('use Sensor as S\\nprogram (Main)\\n    S::read --> print'); ast = parse(tokens, 'test.flux'); result = analyze(ast, 'test.flux'); print(len(result.diagnostics))"` — must print 0 if refs resolve or print SEM001 count if unresolved

- [ ] T007 [US1] Implement `Scenario` and `SymbolTable` classes in `src/flux_proto/semantic/symbol_table.py` — `Scope` stack with parent pointer, `Symbol` dataclass (name, kind, decl_node, type_ref, mutable, capitalization), `ScopeKind`/`SymbolKind`/`CapitalizationKind` enums
- [ ] T008 [US1] Implement `enter_scope()` / `exit_scope()` in `src/flux_proto/semantic/symbol_table.py` — push/pop scope stack, track ScopeKind per block type
- [ ] T009 [US1] Implement `declare()` in `src/flux_proto/semantic/symbol_table.py` — insert name into current scope, detect duplicates in same scope, return Symbol or Diagnostic
- [ ] T010 [US1] Implement `resolve()` in `src/flux_proto/semantic/symbol_table.py` — walk scope chain (inner to outer), return Symbol or None; `resolve_qualified()` for `Agent::op` paths
- [ ] T011 [US1] Implement `add_import()` in `src/flux_proto/semantic/symbol_table.py` — resolve `use Agent as Alias`, `use Agent::op as alias`, `use Agent::{ items }` — store `ImportBinding` with source path and alias
- [ ] T012 [P] [US1] Write scope resolution positive tests in `src/flux_tests/semantic/test_scope.py` — simple declarations, shadowing, qualified access, use imports
- [ ] T013 [P] [US1] Write scope resolution negative tests in `src/flux_tests/semantic/test_scope.py` — duplicate names, unresolved references, invalid use paths

**Checkpoint**: US1 complete — `SymbolTable` resolves all names and reports accurate scope diagnostics

---

## Phase 4: User Story 2 — Capitalization & Mutability Validation (Priority: P1)

**Goal**: Validate identifier capitalization against context (snake_case for mut, SCREAMING_SNAKE for imut, camelCase for functions/ops, PascalCase for agents/contracts/programs). Enforce mutability rules (imut requires =expr, collections cannot be imut).

**Independent Test**: `python -c "from flux_proto.parser import parse; from flux_proto.semantic import analyze; ast = ...; result = analyze(ast, 'test.flux'); assert any(d.code == 'SUG' for d in result.diagnostics)"` — SUGGESTION emitted for wrong capitalization

- [ ] T014 [US2] Implement capitalization validation pass in `src/flux_proto/semantic/capitalization.py` — `validate_capitalization(symbol_table) -> list[Diagnostic]` — check each Symbol name against its `CapitalizationKind` using regex patterns for snake_case, SCREAMING_SNAKE, camelCase, PascalCase
- [ ] T015 [US2] Implement mutability validation pass in `src/flux_proto/semantic/mutability.py` — `validate_mutability(symbol_table, ast) -> list[Diagnostic]` — check imut declarations have initializer, reject `imut` for list/set/map/tensor types
- [ ] T016 [P] [US2] Write capitalization tests in `src/flux_tests/semantic/test_capitalization.py` — all 4 case patterns: correct (no diagnostic), wrong capitalization (SUG), agent/function/struct boundary tests
- [ ] T017 [P] [US2] Write mutability tests in `src/flux_tests/semantic/test_mutability.py` — imut with init (pass), imut without init (SEM001), imut list/set/map/tensor (SEM001)

**Checkpoint**: US2 complete — capitalization and mutability rules enforced with correct diagnostics

---

## Phase 5: User Story 3 — Type Checking & Inference (Priority: P1)

**Goal**: After scope resolution, validate type compatibility across assignments, function calls, operators, struct/enum init, route conditions, tensor indices, and casts. Infer types for unannotated expressions via constraint solving.

**Independent Test**: `python -c "from flux_proto.semantic import analyze; ast = ...; result = analyze(ast, 'test.flux'); assert any('type mismatch' in d.message for d in result.diagnostics)"` — type mismatch caught

- [ ] T018 [US3] Implement `TypeChecker` in `src/flux_proto/semantic/types.py` — `infer_type(node) -> Type`, `check_compatibility(actual, expected, node) -> Diagnostic | None` — walks sub-expressions, propagates declared types, collects and solves constraints
- [ ] T019 [US3] Implement type compatibility rules in `src/flux_proto/semantic/types.py` — widening for int/uint families, int→float promotion, nominal struct/enum matching, exact tensor shape match, FunctionType parameter matching
- [ ] T020 [US3] Implement tensor index validation in `src/flux_proto/semantic/types.py` — `check_tensor_indices(tensor_type, index_count, node)` — compare against shape length
- [ ] T021 [US3] Implement cast validation in `src/flux_proto/semantic/types.py` — validate `as type_reference` expressions: reject invalid casts (e.g., string→tensor), pass known conversions (int→float, int→string via stdlib)
- [ ] T022 [US3] Integrate `TypeChecker` into the analysis pipeline in `src/flux_proto/semantic/analyzer.py` — run after symbol table + capitalization + mutability, attach `resolved_type` to each AST node's semantics
- [ ] T023 [P] [US3] Write type checking positive tests in `src/flux_tests/semantic/test_types.py` — correct assignments, widening, struct/enum init, valid casts
- [ ] T024 [P] [US3] Write type checking negative tests in `src/flux_tests/semantic/test_types.py` — type mismatches, invalid casts, tensor shape errors

**Checkpoint**: US3 complete — all type constraints validated with accurate diagnostics

---

## Phase 6: User Story 4 — Ownership & Lifetime Tracking (Priority: P2)

**Goal**: Track ownership state (Owned/Moved/Borrowed/BorrowedMut/Kept) per variable across sequential statements and branch merge points. Report use-after-move, borrow conflicts. Silence within `unsafe` blocks.

**Independent Test**: `python -c "from flux_proto.semantic import analyze; ast = ...; result = analyze(ast, 'test.flux'); assert any('use of moved' in d.message for d in result.diagnostics)"` — use-after-move caught

- [ ] T025 [US4] Implement `OwnershipTracker` in `src/flux_proto/semantic/ownership.py` — `OwnershipState` enum (Owned/Moved/Borrowed/BorrowedMut/Kept), state vector per scope (`dict[str, OwnershipState]`), state transition table per statement type
- [ ] T026 [US4] Implement statement-level ownership tracking in `src/flux_proto/semantic/ownership.py` — `track_ownership(scope_state, stmt) -> (new_state, list[Diagnostic])` — handle `move(x)`, `borrow(x)`, `keep(x)`, assignment `x = expr`, function call arguments
- [ ] T027 [US4] Implement branch merge logic in `src/flux_proto/semantic/ownership.py` — `merge_branch_states(states: list[dict]) -> dict` — conservative union: moved-in-any-branch → moved, conflict if borrowed-in-one/moved-in-another
- [ ] T028 [US4] Implement `unsafe` scope handling in `src/flux_proto/semantic/ownership.py` — when entering `unsafe { }`, all ownership checks are skipped (state transitions are NoChange); restore state on exit
- [ ] T029 [US4] Integrate `OwnershipTracker` into analyzer pipeline in `src/flux_proto/semantic/analyzer.py` — run after type checking, annotate each node with `ownership_before`/`ownership_after`
- [ ] T030 [P] [US4] Write ownership positive tests in `src/flux_tests/semantic/test_ownership.py` — move/borrow/keep in sequence, unsafe silence, borrow scope end
- [ ] T031 [P] [US4] Write ownership negative tests in `src/flux_tests/semantic/test_ownership.py` — use-after-move, exclusive borrow conflict, borrow outliving source

**Checkpoint**: US4 complete — ownership tracked correctly through all control flow

---

## Phase 7: User Story 5 — Contract-Agent Verification (Priority: P2)

**Goal**: Verify that every `impl Contract for Agent` implements all ops with matching signatures. Agents may have extra ops. Report missing or mismatched implementations.

**Independent Test**: `python -c "from flux_proto.semantic import analyze; ast = ...; result = analyze(ast, 'project.fdsl'); assert any('missing op' in d.message for d in result.diagnostics)"` — missing op caught

- [ ] T032 [US5] Implement contract-agent verification in `src/flux_proto/semantic/contracts.py` — `verify_contract_agent(symbol_table, ast) -> list[Diagnostic]` — for each `ImplDef`, find corresponding `ContractDef` by name, match each `ContractOpSig` against `OpDecl` in the impl body
- [ ] T033 [US5] Implement signature matching in `src/flux_proto/semantic/contracts.py` — compare op name, parameter types, return type; report mismatch with expected vs actual signatures
- [ ] T034 [US5] Implement extra op tolerance in `src/flux_proto/semantic/contracts.py` — agent ops beyond the contract signature set do not produce diagnostics
- [ ] T035 [P] [US5] Write contract-agent positive tests in `src/flux_tests/semantic/test_contracts.py` — complete impl, extra ops allowed, avulso agent (no impl)
- [ ] T036 [P] [US5] Write contract-agent negative tests in `src/flux_tests/semantic/test_contracts.py` — missing ops, mismatched param types, mismatched return type

**Checkpoint**: US5 complete — contract-agent compliance verified

---

## Phase 8: User Story 6 — Emit Terminal Validation (Priority: P3)

**Goal**: Verify that functions with declared return types have an `emit(nice/fail, ...)` on every non-loop code path.

**Independent Test**: `python -c "from flux_proto.semantic import analyze; ast = ...; result = analyze(ast, 'test.flux'); assert any('without emit' in d.message for d in result.diagnostics)"` — missing emit caught

- [ ] T037 [US6] Implement emit terminal path analysis in `src/flux_proto/semantic/emit_check.py` — `check_emit_terminals(symbol_table, ast) -> list[Diagnostic]` — for each `FunctionDef` with return type, walk statement tree: classify statements as "definitely emits" (emit), "conditionally emits" (route/match), "never emits" (expression, break, continue)
- [ ] T038 [US6] Implement branch-aware path walking in `src/flux_proto/semantic/emit_check.py` — for route arms/match arms, check each arm independently; if any arm lacks emit and it's not a non-terminating loop, report missing terminal
- [ ] T039 [US6] Implement infinite loop exemption in `src/flux_proto/semantic/emit_check.py` — infinite loops do not require emit (they may never terminate); code after infinite loop is unreachable and does not affect the check
- [ ] T040 [P] [US6] Write emit terminal positive tests in `src/flux_tests/semantic/test_emit_terminal.py` — functions with emit on all paths, void functions (no return type), infinite loop without emit
- [ ] T041 [P] [US6] Write emit terminal negative tests in `src/flux_tests/semantic/test_emit_terminal.py` — functions with path missing emit, route with one arm missing emit

**Checkpoint**: US6 complete — emit terminal requirements enforced

---

## Phase 9: Orchestrator, Integration & Polish

**Purpose**: Wire all sub-modules together in the main `analyze()` entry point, write integration tests, edge case hardening, and quickstart validation

- [ ] T042 Implement `analyze()` orchestrator in `src/flux_proto/semantic/analyzer.py` — run all 7 phases in dependency order, collect diagnostics, produce `SemanticResult` (decorated AST + diagnostics)
- [ ] T043 Implement `SemanticError` exception in `src/flux_proto/semantic/analyzer.py` — for critical failures (e.g., internal consistency errors), inherits from `Exception`
- [ ] T044 Write full-program integration tests in `src/flux_tests/semantic/test_integration.py` — lex + parse + analyze `flux/samples/hello.flux` and `fdsl/samples/agent_test.fdsl`, verify zero diagnostics for correct programs
- [ ] T045 Write error integration tests in `src/flux_tests/semantic/test_integration.py` — programs with capitalization errors, type mismatches, ownership violations, contract mismatches, missing emits — verify SEM001/SUG diagnostics
- [ ] T046 Write regression tests in `src/flux_tests/semantic/test_regression.py` — all parser-passing test inputs must pass semantic analysis with zero false-positive diagnostics (SC-004)
- [ ] T047 [P] Write edge-case tests in `src/flux_tests/semantic/test_edge_cases.py` — empty program, comment-only file, deeply nested scopes, mutually recursive functions, large programs (>1000 LOC)
- [ ] T048 [P] Write false-positive tests in `src/flux_tests/semantic/test_positive_false.py` — constructs that look invalid but are valid (correct use of `unsafe`, valid casts, valid ownership chains)
- [ ] T049 [P] Write false-negative tests in `src/flux_tests/semantic/test_negative_false.py` — constructs that look valid but are invalid (ownership violation inside async expression, type mismatch in dataflow pipeline)
- [ ] T050 Run the quickstart validation guide from `specs/001-semantic-analyzer/quickstart.md` — verify all 9 validation scenarios pass

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — start immediately
- **Foundational (Phase 2)**: Depends on Setup — BLOCKS all user stories
- **US1 (Phase 3)**: Depends on Foundational — symbol table is the foundation of all semantic checks
- **US2 (Phase 4)**: Depends on US1 — capitalization and mutability validation use the symbol table
- **US3 (Phase 5)**: Depends on US1 + US2 — type checking needs resolved symbols and mutability info
- **US4 (Phase 6)**: Depends on US1 + US3 — ownership tracking needs symbol table and type info
- **US5 (Phase 7)**: Depends on US1 + US3 — contract verification needs symbol table and type info
- **US6 (Phase 8)**: Depends on US1 + US3 — emit terminal analysis needs symbol table and type info
- **Polish (Phase 9)**: Depends on all user stories

### User Story Dependencies

- **US1 (P1)**: After Foundational — no other story dependencies
- **US2 (P1)**: After US1 (needs symbol table)
- **US3 (P1)**: After US1 + US2 (needs symbol table + mutability info)
- **US4 (P2)**: After US1 + US3 (needs symbol table + type info for ownership tracking)
- **US5 (P2)**: After US1 + US3 (needs symbol table + type info for signature matching)
- **US6 (P3)**: After US1 + US3 (needs symbol table + type info for return type check)

### Within Each User Story

- Tests before implementation (TDD: write failing tests first)
- Core data structures before logic
- Logic before integration into orchestrator
- Story complete before moving to next priority

### Parallel Opportunities

- T003, T004, T005 can run in parallel (diagnostic.py + types.py + ast_decorator.py are independent)
- T012 and T013 can run in parallel (positive + negative scope tests)
- T016 and T017 can run in parallel (capitalization + mutability tests)
- T023 and T024 can run in parallel (positive + negative type tests)
- T030 and T031 can run in parallel (positive + negative ownership tests)
- T035 and T036 can run in parallel (positive + negative contract tests)
- T040 and T041 can run in parallel (positive + negative emit terminal tests)
- T047, T048, T049 can run in parallel (edge case, false-positive, false-negative tests)

---

## Parallel Example: User Story 1

```bash
# Launch tests first:
Task: "Write scope resolution positive tests in src/flux_tests/semantic/test_scope.py"
Task: "Write scope resolution negative tests in src/flux_tests/semantic/test_scope.py"

# Then launch implementation files:
Task: "Implement SymbolTable with scope stack, declare, resolve in src/flux_proto/semantic/symbol_table.py"
Task: "Implement use import resolution in src/flux_proto/semantic/symbol_table.py"
```

---

## Implementation Strategy

### MVP First (Phases 1-3)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (diagnostic.py, types.py, ast_decorator.py)
3. Complete Phase 3: US1 Symbol Table & Scope Resolution
4. **STOP and VALIDATE**: `python -c "from flux_proto.lexer import lex; from flux_proto.parser import parse; from flux_proto.semantic import analyze; tokens = lex('program (Main)'); ast = parse(tokens, 'test.flux'); result = analyze(ast, 'test.flux'); print(len(result.diagnostics))"`

### Incremental Delivery

1. Phase 1-3 → Symbol table + scope + diagnostics working → MVP!
2. Phase 4 → Capitalization + mutability → identifier rules enforced
3. Phase 5 → Type checking → full type safety
4. Phase 6 → Ownership tracking → memory safety
5. Phase 7 → Contract verification → agent/contract compliance
6. Phase 8 → Emit terminal → function return safety
7. Phase 9 → Integration, edge cases, regression → polished

---

## Phase 6: User Story 4 — Ownership & Lifetime Tracking (Priority: P2)

**Goal**: Track ownership state (Owned/Moved/Borrowed/BorrowedMut/Kept) per variable across sequential statements and branch merge points. Report use-after-move, borrow conflicts. Silence within `unsafe` blocks.

**Independent Test**: `python -c "from flux_proto.semantic import analyze; ast = ...; result = analyze(ast, 'test.flux'); assert any('use of moved' in d.message for d in result.diagnostics)"` — use-after-move caught

- [X] T051 [P] [US4] Implement `OwnershipState` enum (Owned/Moved/Borrowed/BorrowedMut/Kept) + state transition table in `src/flux_proto/semantic/ownership.py`
- [X] T052 [P] [US4] Implement `OwnershipTracker` class — state vector per scope, `track_ownership(scope_state, stmt) -> (new_state, list[Diagnostic])` in `src/flux_proto/semantic/ownership.py`
- [X] T053 [US4] Implement branch merge logic — `merge_branch_states(states: list[dict]) -> dict` in `src/flux_proto/semantic/ownership.py`
- [X] T054 [US4] Implement `unsafe` scope handling — skip ownership checks, restore state on exit in `src/flux_proto/semantic/ownership.py`
- [X] T055 [US4] Integrate `OwnershipTracker` into analyzer pipeline in `src/flux_proto/semantic/analyzer.py` — annotate each node with `ownership_before`/`ownership_after`
- [X] T056 [P] [US4] Write ownership positive tests in `src/flux_tests/semantic/test_ownership.py` — move/borrow/keep in sequence, unsafe silence, borrow scope end
- [X] T057 [P] [US4] Write ownership negative tests in `src/flux_tests/semantic/test_ownership.py` — use-after-move, exclusive borrow conflict, borrow outliving source
- [X] T058 [P] [US4] Write ownership edge-case tests in `src/flux_tests/semantic/test_ownership.py` — nested unsafe, branch merge conflicts

**Checkpoint**: US4 complete — ownership tracked correctly through all control flow

---

## Phase 7: User Story 5 — Contract-Agent Verification (Priority: P2)

**Goal**: Verify that every `impl Contract for Agent` implements all ops with matching signatures. Agents may have extra ops. Report missing or mismatched implementations.

**Independent Test**: `python -c "from flux_proto.semantic import analyze; ast = ...; result = analyze(ast, 'project.fdsl'); assert any('missing op' in d.message for d in result.diagnostics)"` — missing op caught

- [X] T059 [US5] Implement `verify_contract_agent(symbol_table, ast) -> list[Diagnostic]` in `src/flux_proto/semantic/contracts.py` — for each `ImplDef`, find corresponding `ContractDef` by name, match each `ContractOpSig` against `OpDecl` in the impl body
- [X] T060 [US5] Implement signature matching in `src/flux_proto/semantic/contracts.py` — compare op name, parameter types, return type; report mismatch with expected vs actual signatures
- [X] T061 [US5] Implement extra op tolerance in `src/flux_proto/semantic/contracts.py` — agent ops beyond the contract signature set do not produce diagnostics
- [X] T062 [P] [US5] Write contract-agent positive tests in `src/flux_tests/semantic/test_contracts.py` — complete impl, extra ops allowed, avulso agent (no impl)
- [X] T063 [P] [US5] Write contract-agent negative tests in `src/flux_tests/semantic/test_contracts.py` — missing ops, mismatched param types, mismatched return type

**Checkpoint**: US5 complete — contract-agent compliance verified

---

## Phase 8: User Story 6 — Emit Terminal Validation (Priority: P3)

**Goal**: Verify that functions with declared return types have an `emit(nice/fail, ...)` on every non-loop code path.

**Independent Test**: `python -c "from flux_proto.semantic import analyze; ast = ...; result = analyze(ast, 'test.flux'); assert any('without emit' in d.message for d in result.diagnostics)"` — missing emit caught

- [ ] T064 [US6] Implement emit terminal path analysis in `src/flux_proto/semantic/emit_check.py` — `check_emit_terminals(symbol_table, ast) -> list[Diagnostic]` — for each `FunctionDef` with return type, walk statement tree: classify statements as "definitely emits" (emit), "conditionally emits" (route/match), "never emits" (expression, break, continue)
- [ ] T065 [US6] Implement branch-aware path walking in `src/flux_proto/semantic/emit_check.py` — for route arms/match arms, check each arm independently; if any arm lacks emit and it's not a non-terminating loop, report missing terminal
- [ ] T066 [US6] Implement infinite loop exemption in `src/flux_proto/semantic/emit_check.py` — infinite loops do not require emit (they may never terminate); code after infinite loop is unreachable and does not affect the check
- [ ] T067 [P] [US6] Write emit terminal positive tests in `src/flux_tests/semantic/test_emit_terminal.py` — functions with emit on all paths, void functions (no return type), infinite loop without emit
- [ ] T068 [P] [US6] Write emit terminal negative tests in `src/flux_tests/semantic/test_emit_terminal.py` — functions with path missing emit, route with one arm missing emit

**Checkpoint**: US6 complete — emit terminal requirements enforced

---

## Phase 9: Integration US4–US6 & Polish

**Purpose**: Wire ownership, contracts, emit terminal into orchestrator, write integration tests, run quickstart validation

- [ ] T069 Wire US4–US6 into `analyze()` orchestrator in `src/flux_proto/semantic/analyzer.py` — dependency order: ownership after type checking, contracts after symbol table, emit after type checking
- [ ] T070 [P] Write full-program integration tests for US4–US6 in `src/flux_tests/semantic/test_integration.py` — lex+parse+analyze programs with ownership, contracts, emit
- [ ] T071 [P] Write regression tests in `src/flux_tests/semantic/test_regression.py` — all parser-passing inputs must pass with zero false positives (SC-004)
- [ ] T072 Run quickstart validation — verify all scenarios from `specs/001-semantic-analyzer/quickstart.md` pass

**Checkpoint**: All semantic phases 5a–5g complete. 100% of grammar.md §13 Phase 5 implemented.

---

## Phase 10: CLI Fix + Macro Expansion

**Purpose**: Unblock the pipeline (fix wrong import in cli.py) and implement macro expansion (Phase 4 of the pipeline from grammar.md)

- [ ] T073 Fix CLI import — change `cli.py:46` from `from flux_proto.ast.nodes import FluxProgram` to `from flux_proto.parser.ast import FluxProgram`
- [ ] T074 [P] Test CLI with `python flux_in.py flux/samples/hello.flux` — must lex, parse, and reach backend dispatch
- [ ] T075 Implement macro expansion in `src/flux_proto/semantic/macro.py` — `MacroDef` expansion with `quote`/`unquote`, max 64 nesting levels, CMP001 on overflow (Phase 4 of pipeline from grammar.md)

**Checkpoint**: Pipeline unblocked. Macros expand before semantic analysis.

---

## Phase 11: DDG — Data Dependency Graph (Phase 6 of pipeline from grammar.md)

**Purpose**: Build data/control flow edges between AST nodes. Used by VM compiler for slot allocation.

- [ ] T076 [P] Implement `DataDependencyGraph` class in `src/flux_proto/ddg/graph.py` — nodes = AST node IDs, edges = data flow + control flow
- [ ] T077 [P] Implement metadata tagging — route arms, catch-all, loop_body, iterator in `src/flux_proto/ddg/graph.py`
- [ ] T078 [P] Implement `build_ddg(decorated_ast) -> DataDependencyGraph` in `src/flux_proto/ddg/graph.py`
- [ ] T079 Write DDG tests in `src/flux_tests/ddg/test_graph.py` — linear flow, branching, nested loops

**Checkpoint**: DDG available for VM compiler and analysis tools.

---

## Phase 12: Interpreter Backend (--target run)

**Goal**: `python flux_in.py hello.flux` actually executes the program.

- [ ] T080 [P] Implement `Environment` class in `src/flux_proto/interpreter/environment.py` — runtime scope: variables, functions, agents, structs
- [ ] T081 [P] Implement `Interpreter.visit_Literal`, `visit_Identifier`, `visit_BinaryOp`, `visit_UnaryOp` in `src/flux_proto/interpreter/interpreter.py`
- [ ] T082 [P] Implement `visit_PrintStmt`, `visit_ExpressionStmt`, `visit_BlockStmt` in `src/flux_proto/interpreter/interpreter.py`
- [ ] T083 [P] Implement `visit_FunctionDef`, `visit_CallExpr`, `visit_Return` in `src/flux_proto/interpreter/interpreter.py`
- [ ] T084 [P] Implement `visit_RouteStmt`, `visit_RouteArm`, `visit_MatchStmt` in `src/flux_proto/interpreter/interpreter.py`
- [ ] T085 [P] Implement `visit_InfiniteStmt`, `visit_InfiniteIterator` in `src/flux_proto/interpreter/interpreter.py`
- [ ] T086 [P] Implement `visit_StructInit`, `visit_FieldAccess`, `visit_EmitStmt`, `visit_FailStmt` in `src/flux_proto/interpreter/interpreter.py`
- [ ] T087 Write interpreter tests in `src/flux_tests/interpreter/test_interpreter.py` — hello world, arithmetic, route, infinite, struct init, emit

**Checkpoint**: `python flux_in.py samples/hello.flux` prints correct output.

---

## Phase 13: Bytecode VM (--target vmbc)

**Goal**: `python flux_vm.py hello.flux` generates `.fvmbc` and executes it.

- [ ] T088 [P] Implement `Opcode` enum in `src/flux_proto/vm/opcodes.py` — PUSH, LOAD, STORE, CALL, I64.ADD, F64.MUL, PIPE_DISPATCH, STRUCT_ALLOC, VARIANT_ALLOC, RET, JUMP, JUMP_IF_FALSE, ITER_INIT/NEXT/END, TASK_INIT/SPAWN/JOIN, DROP, NOP
- [ ] T089 [P] Implement `Compiler.compile(program, ddg) -> list[Opcode]` in `src/flux_proto/vm/compiler.py` — AST + DDG → linear bytecode
- [ ] T090 [P] Implement `Verifier.verify(bytecode) -> list[Diagnostic]` in `src/flux_proto/vm/verifier.py` — jump targets, stack balance, type-opcode consistency; BC001 on error
- [ ] T091 [P] Implement `VM` class in `src/flux_proto/vm/runtime.py` — stack, call frames, program counter, dispatch loop
- [ ] T092 [P] Implement VM arithmetic, control flow, struct alloc, function calls in `src/flux_proto/vm/runtime.py`
- [ ] T093 [P] Implement `execute_bytecode(bytecode) -> Any` entry point in `src/flux_proto/vm/runtime.py`
- [ ] T094 Write VM tests in `src/flux_tests/vm/test_compiler.py` + `test_runtime.py` — compile + execute round-trip

**Checkpoint**: `python flux_vm.py samples/hello.flux` writes `.fvmbc` and runs it.

---

## Phase 14: WAT Codegen (--target wat, --emit-wat)

**Goal**: `python flux_wat.py hello.flux` generates valid `.wat` file, validated by WABT (wat2wasm on PATH).

- [ ] T095 [P] Implement `generate_wat(program, output_path)` in `src/flux_proto/wat/codegen.py` — walk AST, produce WAT string
- [ ] T096 [P] Implement WAT module structure — `(module ...)` with `flux_main` export, `memory` export, `flux.host_print` import in `src/flux_proto/wat/codegen.py`
- [ ] T097 [P] Implement WAT codegen for int64/float64 literals, identifiers, binary ops, unary ops in `src/flux_proto/wat/codegen.py`
- [ ] T098 [P] Implement WAT codegen for print, infinite/route, function calls in `src/flux_proto/wat/codegen.py`
- [ ] T099 [P] Validate generated WAT — `wat2wasm` on PATH, verify no errors
- [ ] T100 Write WAT tests in `src/flux_tests/wat/test_codegen.py` — generate + validate with WABT

**Checkpoint**: `python flux_wat.py samples/hello.flux` produces valid `.wat`.

---

## Phase 15: WASM Codegen (--target wasm)

**Goal**: `python flux_wasm.py hello.flux` generates binary `.wasm` executable, runnable via `wasmer` (on PATH).

- [ ] T101 [P] Implement WASM binary writer in `src/flux_proto/wasm/binary.py` — sections (Type, Function, Memory, Export, Import, Code), LEB128 encoding
- [ ] T102 [P] Implement `generate_wasm(program, output_path)` in `src/flux_proto/wasm/codegen.py` — AST → binary sections
- [ ] T103 [P] Implement WASM codegen for int64/float64, arithmetic, print (via host import), infinite/route in `src/flux_proto/wasm/codegen.py`
- [ ] T104 [P] Validate generated WASM — `wasmer validate` on PATH, verify no structural errors
- [ ] T105 [P] Execute generated WASM — `wasmer run` on PATH, verify stdout matches expected
- [ ] T106 Write WASM tests in `src/flux_tests/wasm/test_codegen.py` — generate + validate + execute round-trip

**Checkpoint**: `python flux_wasm.py samples/hello.flux` produces valid `.wasm` that runs via `wasmer`.

---

## Phase 16: LLVM Codegen (--target llvm, --emit-llvm)

**Goal**: `python flux_lv.py hello.flux` generates a native `.exe`.

- [ ] T107 [P] Implement LLVM IR writer in `src/flux_proto/llvm/ir_writer.py` — module, function declarations, basic blocks, instructions
- [ ] T108 [P] Implement `generate_llvm(program, output_path)` in `src/flux_proto/llvm/codegen.py` — AST → `.ll` IR text
- [ ] T109 [P] Implement LLVM codegen for int64/float64, arithmetic, print (via @printf), infinite/route, function calls in `src/flux_proto/llvm/codegen.py`
- [ ] T110 [P] Implement LLVM codegen for struct init, field access, emit/fail in `src/flux_proto/llvm/codegen.py`
- [ ] T111 [P] Compile `.ll` → `.exe` — try `clang`, fall back to `zig build-exe` or `rustc`, produce native binary
- [ ] T112 [P] Execute compiled `.exe` — verify stdout matches expected
- [ ] T113 Write LLVM tests in `src/flux_tests/llvm/test_codegen.py` — generate + compile + execute round-trip

**Checkpoint**: `python flux_lv.py samples/hello.flux` produces an `.exe` that runs correctly.

---

## Phase 17: Cross-Target Validation Harness

**Goal**: Constitution Principle I — all 5 backends produce semantically identical results.

- [ ] T114 Create cross-target test infrastructure in `src/flux_tests/cross_target/__init__.py` — harness that runs same `.flux` file through all 5 backends, captures stdout
- [ ] T115 [P] Implement `run_all_targets(source_path) -> dict[str, str]` that calls interpreter → VM → WAT → WASM → LLVM and returns stdout per target
- [ ] T116 [P] Write compliance matrix test in `src/flux_tests/cross_target/test_compliance.py` — for each construct (literal, arithmetic, route, infinite, struct, function call), verify identical stdout across all 5 backends
- [ ] T117 [P] Write regression matrix test in `src/flux_tests/cross_target/test_regression.py` — all prior test inputs must pass on all 5 backends
- [ ] T118 [P] Add `run_all_tests.ps1` script at repo root that runs `pytest` on all modules
- [ ] T119 [P] Add CI config (if applicable) — zero-regression gate, blocks on any target failure
- [ ] T120 Document cross-target workflow in `docs/cross-target.md`

**Checkpoint**: `.\run_all_tests.ps1` passes on all 5 backends with identical output.

---

## Phase 18: Polish & Documentation

**Purpose**: Clean up project structure, remove stubs, final validation.

- [ ] T121 [P] Update architecture documentation — current pipeline diagram (lexer → parser → semantic → DDG → 5 backends)
- [ ] T122 [P] Add docstrings to all public module entry points (`cli.main()`, `interpret()`, `compile_to_bytecode()`, `generate_wat()`, `generate_wasm()`, `generate_llvm()`)
- [ ] T123 [P] Remove all `.gitkeep` files from backend directories (replaced by real modules)
- [ ] T124 [P] Final validation — run `pytest src/flux_tests/` and confirm zero failures

**Checkpoint**: Project is documented, clean, and fully tested.

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1–5**: Complete (semantic setup + US1-3) — already implemented
- **Phase 6 (US4)**: Depends on Phase 1–5 — ownership needs symbol table + type info
- **Phase 7 (US5)**: Depends on Phase 1–5 — contracts need symbol table + type info
- **Phase 8 (US6)**: Depends on Phase 1–5 — emit terminal needs symbol table + type info
- **Phase 9 (Integration)**: Depends on Phase 6–8
- **Phase 10 (CLI+Macro)**: Can start after Phase 9
- **Phase 11 (DDG)**: Depends on Phase 9 (needs decorated AST)
- **Phase 12 (Interpreter)**: Can start after Phase 10 (needs working CLI + parser)
- **Phase 13 (VM)**: Depends on Phase 11 (needs DDG)
- **Phase 14 (WAT)**: Can start after Phase 10
- **Phase 15 (WASM)**: Can start after Phase 10
- **Phase 16 (LLVM)**: Can start after Phase 10
- **Phase 17 (Cross-Target)**: Depends on Phase 12–16
- **Phase 18 (Polish)**: Depends on all phases

### Within Each Phase

- Tests before implementation (TDD: write failing tests first)
- Core data structures before logic
- Logic before integration into orchestrator
- Phase complete before moving to next

### Parallel Opportunities

- T051+T052: ownership state enum and tracker class (different concerns, same file but can be sequential)
- T056+T057+T058: positive/negative/edge tests for ownership
- T062+T063: positive/negative contract tests
- T067+T068: positive/negative emit terminal tests
- T080–T086: interpreter visitor methods (mostly independent)
- T095–T099: WAT codegen (independent files)
- T101–T105: WASM codegen (independent files)
- T107–T112: LLVM codegen (independent files)
- T115+T116+T117: cross-target harness (same infrastructure)

### Implementation Strategy

#### Order of Execution

1. Phase 6: US4 Ownership (complete semantic gap)
2. Phase 7: US5 Contract-Agent (complete semantic gap)
3. Phase 8: US6 Emit Terminal (complete semantic gap)
4. Phase 9: Integration + Polish (wire everything)
5. Phase 10: CLI Fix + Macro Expansion (unblock pipeline)
6. Phase 12: Interpreter (simplest backend)
7. Phase 14: WAT (text-based, WABT validates)
8. Phase 16: LLVM (text-based IR, compiles to native)
9. Phase 15: WASM (binary format, wasmer validates)
10. Phase 11: DDG (needed by VM)
11. Phase 13: VM (most complex, needs DDG)
12. Phase 17: Cross-Target (verify all backends)
13. Phase 18: Polish (final cleanup)

---

## Notes

- [P] tasks = different files, no dependencies
- [US#] maps to spec.md user stories
- Each user story independently completable and testable
- Write tests first, ensure they fail, then implement
- Commit after each task or logical group
- Stop at any checkpoint to validate
- All 7 sub-phases (5a–5g) from grammar.md §13 are covered
