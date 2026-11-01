# Tasks: Parser Module Implementation

**Input**: Design documents from `/specs/001-parser-module-implementation/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/token-provider.md

**Tests**: Included per constitution's Zero-Regression Automated Testing mandate.

**Organization**: Tasks grouped by user story for independent implementation and testing.

## Format

- `[P]` = can run in parallel (different files, no dependencies)
- `[US#]` = maps to user story from spec.md
- Exact file paths in descriptions

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Initialize parser package `__init__.py` and test package structure

- [ ] T001 Create parser package `__init__.py` at `src/flux_proto/parser/__init__.py`
- [ ] T002 Create test package `__init__.py` at `src/flux_tests/parser/__init__.py`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core types that every user story depends on — TokenStream, AST base classes, ParseError

**CRITICAL**: No user story work can begin until this phase is complete

- [ ] T003 Implement `ParseError` exception class in `src/flux_proto/parser/parser.py` — code="PAR001", line, column, message, expected
- [ ] T004 [P] Implement `TokenStream` class in `src/flux_proto/parser/token_stream.py` — wraps lexer generator, peek(n)/advance/expect/match/position/set_position, 2-token lookahead buffer
- [ ] T005 [P] Implement AST node base class and all concrete dataclass nodes in `src/flux_proto/parser/ast.py` — ASTNode base, programs (FluxProgram, FdslFile), declarations (FunctionDef, OpDecl, StructDef, EnumDef, ContractDef, ImplDef, AgentDef, MacroDef, UseDecl, StorageDecl), statements (BlockStmt, PrintStmt, InfiniteStmt, RouteStmt, MatchStmt, BreakStmt, ContinueStmt, EmitStmt, FailStmt, UnsafeStmt, VariableReassign, ExpressionStmt), expressions (BinaryOp, UnaryOp, Literal, Identifier, CallExpr, FieldAccess, IndexAccess, SliceSpec, StructInit, EnumVariant, MatchExpr, DataflowExpr, CastExpr, ErrorExpr, ShortCircuitBlock, InputExpr, SpyExpr, ComptimeExpr, QuoteExpr, UnquoteExpr, OwnershipExpr, AsyncExpr, SpawnExpr, AwaitExpr, LambdaExpr, DataflowCastSink, InterpolatedString, RouteExpr, MatchInlineExpr), patterns (WildcardPattern, LiteralPattern, IdentifierPattern, ListPattern, RecordPattern, StructPattern, EnumVariantPattern, DataPattern), support (Parameter, TypeRef, OpBody)
- [ ] T006 [P] Implement JSON serializer for AST nodes in `src/flux_proto/parser/ast.py` — `ast_to_dict(node) -> dict` for `--emit-ast` output

**Checkpoint**: Foundation ready — user story implementation can begin

---

## Phase 3: User Story 1 — Core Expression Parsing (Priority: P1) 🎯 MVP

**Goal**: Complete expression parser handling all 17 precedence levels, prefix/postfix operators, literals, identifiers, function calls, field access, indexing/slicing, struct init, enum variant, interpolation, and compile-time expressions.

**Independent Test**: `python -c "from flux_proto.lexer import lex; from flux_proto.parser import parse; tokens = lex('a + b * c ^e d'); ast = parse(tokens, 'test.flux'); print(ast)"` — AST must show correct precedence: `BinaryOp(+, a, BinaryOp(*, b, BinaryOp(^e, c, d)))`

- [ ] T007 [US1] Implement expression entry point and assignment/precedence dispatch in `src/flux_proto/parser/expressions.py` — `parse_expression(ts)`, `parse_assignment_expr`, `parse_recovery_expr`
- [ ] T008 [US1] Implement dataflow expression parsing in `src/flux_proto/parser/expressions.py` — `parse_dataflow_expr` handling `-->`, `==>`, `split`, `join`
- [ ] T009 [P] [US1] Implement logical expression parsing (or, and) in `src/flux_proto/parser/expressions.py` — `parse_or_expr`, `parse_and_expr`
- [ ] T010 [P] [US1] Implement bitwise expression parsing (|, ^, &) in `src/flux_proto/parser/expressions.py` — `parse_bit_or_expr`, `parse_bit_xor_expr`, `parse_bit_and_expr`
- [ ] T011 [P] [US1] Implement relational and membership expression parsing in `src/flux_proto/parser/expressions.py` — `parse_equality_expr`, `parse_membership_expr`
- [ ] T012 [P] [US1] Implement range, shift, additive, multiplicative, and power expression parsing in `src/flux_proto/parser/expressions.py` — `parse_range_expr`, `parse_shift_expr`, `parse_additive_expr`, `parse_multiplicative_expr`, `parse_power_expr`
- [ ] T013 [US1] Implement prefix/primary/postfix expression parsing in `src/flux_proto/parser/expressions.py` — `parse_prefix_expr`, `parse_primary_postfix_expr`, `parse_primary_expr` covering unary operators, async/spawn/await/ownership, literals, identifiers, parenthesized expressions, call_suffix, field_suffix, index_or_slice_suffix, namespace_suffix, ensure_suffix, cast_suffix
- [ ] T014 [US1] Implement literal parsing in `src/flux_proto/parser/expressions.py` — integers, floats, complex, datetime, strings (including interpolated), chars, booleans, lists, sets, maps, tensors
- [ ] T015 [US1] Implement interpolation expression handling in `src/flux_proto/parser/expressions.py` — assemble `INTERPOLATED_STRING_START`/`INTERPOLATED_TEXT`/`INTERPOLATION_OPEN`/`expression`/`INTERPOLATION_CLOSE`/`INTERPOLATED_STRING_END` into `InterpolatedString` AST node
- [ ] T016 [P] [US1] Write expression positive tests in `src/flux_tests/parser/test_expressions.py` — each precedence level, literals, interpolation, prefix/postfix, calls, struct init
- [ ] T017 [P] [US1] Write expression negative tests in `src/flux_tests/parser/test_expressions.py` — incomplete expressions, missing operands, unbalanced delimiters

**Checkpoint**: US1 complete — `parse_expression()` handles all expression types with correct precedence

---

## Phase 4: User Story 3 — Statement & Block Parsing (Priority: P1)

**Goal**: Parse block bodies with all statement types — print, infinite loops, route/match branching, emit/fail, break/continue, unsafe blocks, variable reassignment, expression statements. Consume INDENT/DEDENT tokens for block boundaries.

**Independent Test**: `python -c "from flux_proto.lexer import lex; from flux_proto.parser import parse; tokens = lex('program (Main)\n{\n      print(\"hello\")\n}'); ast = parse(tokens, 'test.flux'); print(ast)"` — AST must contain `FluxProgram` with `BlockStmt` containing `PrintStmt`

- [ ] T018 [US3] Implement block body parsing in `src/flux_proto/parser/statements.py` — `parse_block_body(ts)`, `parse_indented_block_body(ts)`, handle INDENT/DEDENT tokens, statement_end (EOL/eof/dedent)
- [ ] T019 [P] [US3] Implement statement dispatch in `src/flux_proto/parser/statements.py` — `parse_statement(ts)`, `parse_block_statement(ts)`, dispatch to all statement types
- [ ] T020 [P] [US3] Implement `parse_print_stmt` in `src/flux_proto/parser/statements.py` — `print(args...)`
- [ ] T021 [P] [US3] Implement `parse_infinite_stmt` in `src/flux_proto/parser/statements.py` — `infinite { }`, `infinite (expr) { }`, `infinite (item in collection) { }`
- [ ] T022 [P] [US3] Implement `parse_route_stmt` in `src/flux_proto/parser/statements.py` — `route { arm ==> body }`, subjects, route_body (indented/inline)
- [ ] T023 [P] [US3] Implement `parse_match_stmt` in `src/flux_proto/parser/statements.py` — `match (expr) { pattern ==> body }`
- [ ] T024 [P] [US3] Implement `parse_emit_stmt` and `parse_fail_stmt` in `src/flux_proto/parser/statements.py` — `emit(nice/fail, vars, message)`, `fail(message)`
- [ ] T025 [P] [US3] Implement `parse_break_stmt`, `parse_continue_stmt`, `parse_unsafe_stmt` in `src/flux_proto/parser/statements.py`
- [ ] T026 [US3] Implement `parse_variable_reassignment` and `parse_expression_stmt` in `src/flux_proto/parser/statements.py`
- [ ] T027 [P] [US3] Write statement positive tests in `src/flux_tests/parser/test_statements.py` — each statement type, indented blocks, nested blocks
- [ ] T028 [P] [US3] Write statement negative tests in `src/flux_tests/parser/test_statements.py` — missing indent, missing dedent, misplaced break/continue, invalid route/match

**Checkpoint**: US3 complete — all statement types parse correctly with indentation-aware blocks

---

## Phase 5: User Story 2 — Declaration Parsing (Priority: P1)

**Goal**: Parse all top-level declarations — program, function, agent, op, struct, enum, contract, impl, macro, use, storage — with docstring attachment and `.flux`/`.fdsl` topology enforcement.

**Independent Test**: `python -c "from flux_proto.lexer import lex; from flux_proto.parser import parse; tokens = lex('program (Main) {}'); ast = parse(tokens, 'test.flux'); assert ast.node_type == 'FluxProgram'"`

- [ ] T029 [US2] Implement the main `parse(tokens, source_path)` entry point in `src/flux_proto/parser/parser.py` — dispatch to `parse_flux_file` or `parse_fdsl_file` by extension
- [ ] T030 [US2] Implement `parse_flux_file` in `src/flux_proto/parser/parser.py` — consume use/struct/enum/contract/storage/function declarations, then require exactly one `program` declaration (last)
- [ ] T031 [US2] Implement `parse_fdsl_file` in `src/flux_proto/parser/parser.py` — consume use/struct/enum/contract/storage/function declarations, then require one or more `agent` declarations, reject `program`
- [ ] T032 [P] [US2] Implement structural declaration parsing in `src/flux_proto/parser/declarations.py` — `parse_struct_decl`, `parse_enum_decl` with fields/members, body delimiters
- [ ] T033 [P] [US2] Implement `parse_use_decl` in `src/flux_proto/parser/declarations.py` — `use Agent as Alias`, `use Agent::op as alias`, `use Agent::{ items }`
- [ ] T034 [P] [US2] Implement `parse_storage_decl` in `src/flux_proto/parser/declarations.py` — `mut as type: var = expr`, `imut as type: CONST = expr`
- [ ] T035 [US2] Implement `parse_function_decl` in `src/flux_proto/parser/declarations.py` — `function (name) (params) as ret_type block_body`
- [ ] T036 [P] [US2] Implement `parse_op_decl` in `src/flux_proto/parser/declarations.py` — `op (name) (type, type) as ret_type op_body`
- [ ] T037 [P] [US2] Implement `parse_contract_decl` and `parse_impl_decl` in `src/flux_proto/parser/declarations.py`
- [ ] T038 [P] [US2] Implement `parse_agent_decl` in `src/flux_proto/parser/declarations.py` — `agent (Name) { storage | function | op }`
- [ ] T039 [P] [US2] Implement `parse_macro_decl` in `src/flux_proto/parser/declarations.py` — `macro (name) (params) block_body`
- [ ] T040 [US2] Implement docstring attachment in `src/flux_proto/parser/parser.py` — accumulate DOCSTRING tokens before each declaration, attach as `docstring` field on the AST node
- [ ] T041 [P] [US2] Write declaration positive tests in `src/flux_tests/parser/test_declarations.py` — program, agent, function, struct, enum, contract, impl, use, storage, macro — each with docstring variants
- [ ] T042 [P] [US2] Write declaration negative tests in `src/flux_tests/parser/test_declarations.py` — invalid topology (.flux missing program, .fdsl with program), malformed declarations

**Checkpoint**: US2 complete — full `.flux` and `.fdsl` files parse to AST with docstrings attached

---

## Phase 6: User Story 4 — Pattern & Match Parsing (Priority: P2)

**Goal**: Parse match-arm patterns (wildcard, literal, identifier, list, record, struct, enum-variant, data) and the match expression construct. Integrate with expression parser for match subject and arm bodies.

**Independent Test**: `python -c "from flux_proto.lexer import lex; from flux_proto.parser import parse; tokens = lex('match (x) { _ ==> 42 }'); ast = parse(tokens, 'test.flux'); print(ast)"` — AST must contain `MatchExpr` with `WildcardPattern`

- [ ] T043 [US4] Implement pattern dispatch in `src/flux_proto/parser/patterns.py` — `parse_pattern(ts)` with lookahead disambiguation
- [ ] T044 [P] [US4] Implement wildcard, literal, and identifier patterns in `src/flux_proto/parser/patterns.py`
- [ ] T045 [P] [US4] Implement list and rest patterns in `src/flux_proto/parser/patterns.py` — `[pattern, ..rest]`
- [ ] T046 [P] [US4] Implement record, struct, enum-variant, and data patterns in `src/flux_proto/parser/patterns.py` — `.field: pattern` syntax
- [ ] T047 [US4] Integrate pattern parsing into match statement/expression parsing in `src/flux_proto/parser/statements.py` and `src/flux_proto/parser/expressions.py` — match arms use patterns, route arms use expressions or wildcard
- [ ] T048 [P] [US4] Write pattern positive tests in `src/flux_tests/parser/test_patterns.py` — each pattern variant, nested patterns, rest patterns
- [ ] T049 [P] [US4] Write pattern negative tests in `src/flux_tests/parser/test_patterns.py` — malformed patterns, missing fields

**Checkpoint**: US4 complete — match expressions with all pattern variants parse correctly

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: CLI integration (`--emit-ast`), full-program integration tests, edge-case hardening, and quickstart validation

- [ ] T050 Implement `--emit-ast` CLI flag in `src/flux_proto/cli.py` — serialize AST to JSON, write to `intermediates/ast/<filename>.json`
- [ ] T051 Write full-program integration tests in `src/flux_tests/parser/test_integration.py` — lex + parse `flux/samples/hello.flux` and `fdsl/samples/agent_test.fdsl`, verify AST structure
- [ ] T052 Write error integration tests in `src/flux_tests/parser/test_errors.py` — PAR001 diagnostics across all grammar productions
- [ ] T053 [P] Add edge-case positive tests: empty file, comment-only file, whitespace-only file, deeply nested expressions in `src/flux_tests/parser/test_edge_cases.py`
- [ ] T054 [P] Add false-positive tests: constructs that look invalid but are valid (empty struct, empty function body with emit-only, nested `()`, `#{ }` empty interpolation) in `src/flux_tests/parser/test_positive_false.py`
- [ ] T055 [P] Add false-negative tests: constructs that look valid but are invalid (keyword as identifier, dataflow operator without right operand) in `src/flux_tests/parser/test_negative_false.py`
- [ ] T056 Update `src/flux_proto/parser/__init__.py` to re-export `parse()` and `ParseError`
- [ ] T057 Run the quickstart validation guide from `specs/001-parser-module-implementation/quickstart.md` — verify all 9 validation scenarios pass

**Checkpoint**: Parser implementation complete — all tasks done

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — start immediately
- **Foundational (Phase 2)**: Depends on Setup — BLOCKS all user stories
- **US1 (Phase 3)**: Depends on Foundational — expressions are the foundation of all parsing
- **US3 (Phase 4)**: Depends on US1 — statements embed expressions in their bodies
- **US2 (Phase 5)**: Depends on US1 + US3 — declarations use expressions (storage init, params) and statements (function/agent/macro bodies)
- **US4 (Phase 6)**: Depends on US1 — patterns use expressions in match bodies; match statements depend on US3
- **Polish (Phase 7)**: Depends on all user stories

### User Story Dependencies

- **US1 (P1)**: Core — after Foundational
- **US3 (P1)**: After US1 (needs expressions for statement bodies)
- **US2 (P1)**: After US1 + US3 (needs expressions + statements for declaration bodies)
- **US4 (P2)**: After US1 (needs expressions for match arms; match statement depends on US3)
- US5 (Error Recovery) is satisfied as a cross-cutting concern of the ParseError exception class and TokenStream.expect() — no separate phase needed

### Within Each User Story

- Models before parsing logic
- Core implementation before tests
- Implementation before tests-in-the-same-phase
- Story complete before moving to next priority

### Parallel Opportunities

- T004, T005, T006 can run in parallel (token_stream.py + ast.py + JSON serializer)
- T009, T010, T011, T012 can run in parallel (expression levels share no state)
- T016 and T017 can run in parallel (positive + negative expression tests)
- T019-T025 can run in parallel (statement types are independent)
- T027 and T028 can run in parallel (positive + negative statement tests)
- T032, T033, T034, T036, T037, T038, T039 can run in parallel (declaration types)
- T041 and T042 can run in parallel (positive + negative declaration tests)
- T044, T045, T046 can run in parallel (pattern variants)
- T048 and T049 can run in parallel (positive + negative pattern tests)
- T053, T054, T055 can run in parallel (edge case tests)

---

## Parallel Example: User Story 1

```bash
# Launch expression level functions together:
Task: "Implement logical expressions in src/flux_proto/parser/expressions.py"
Task: "Implement bitwise expressions in src/flux_proto/parser/expressions.py"
Task: "Implement relational expressions in src/flux_proto/parser/expressions.py"
Task: "Implement range/shift/additive/multiplicative/power in src/flux_proto/parser/expressions.py"

# Launch tests together:
Task: "Write expression positive tests"
Task: "Write expression negative tests"
```

---

## Implementation Strategy

### MVP First (Phases 1-3)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (ast.py, token_stream.py)
3. Complete Phase 3: US1 Core Expression Parsing
4. **STOP and VALIDATE**: `python -c "from flux_proto.lexer import lex; from flux_proto.parser import parse; ..."`

### Incremental Delivery

1. Phase 1-3 → Expression parsing working → MVP!
2. Phase 4 → Statements (US3) → blocks and control flow
3. Phase 5 → Declarations (US2) → full program parsing
4. Phase 6 → Patterns (US4) → match expressions
5. Phase 7 → Polish → CLI integration, edge cases, quickstart

---

## Notes

- [P] tasks = different files, no dependencies
- [US#] maps to spec.md user stories
- Each user story independently completable and testable
- Commit after each task or logical group
- Stop at any checkpoint to validate
