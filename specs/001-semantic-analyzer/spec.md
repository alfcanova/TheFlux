# Feature Specification: Semantic Analyzer

**Feature Branch**: `001-semantic-analyzer`

**Created**: 2026-07-27

**Status**: Draft

**Input**: User description: "Implement semantic analysis for TheFlux language — symbol table, type checking, capitalization rules, mutability, ownership, contract-agent verification, emit terminal validation. Modular design targeting all five backends: interpreter, VM bytecode, LLVM native, WAT, WASM."

## User Scenarios & Testing *(mandatory)*

### User Story 1 — Symbol Table and Scope Resolution (Priority: P1)

A developer writes a `.flux` or `.fdsl` file with `use` declarations and references across multiple modules. The semantic analyzer must resolve each reference to its definition, detect duplicate names in the same scope, and report unresolved references with precise diagnostics.

**Why this priority**: All downstream phases (type checking, ownership, code generation) depend on knowing what each name refers to. Without scope resolution no other semantic check can proceed.

**Independent Test**: Can be fully tested by parsing a file with `use Agent as Alias`, then a function referencing `Alias::op`, and verifying the symbol table contains the resolved binding with correct source location.

**Acceptance Scenarios**:

1. **Given** a source file containing `use Sensor as S` and a function calling `S::read`, **When** semantic analysis runs, **Then** the symbol table shows `S` resolved to the `Sensor` agent with full path.
2. **Given** a source file declaring two structs with the same name, **When** semantic analysis runs, **Then** a duplicate name diagnostic (SEM001) is emitted with both declaration locations.
3. **Given** a source file referencing `UndefinedAgent::op`, **When** semantic analysis runs, **Then** an unresolved reference diagnostic (SEM001) is emitted with the exact line and column.
4. **Given** a source file with nested scopes (function body, infinite loop body, route arm body), **When** semantic analysis runs, **Then** inner scope names shadow outer scope names correctly without false positives.
5. **Given** a `.fdsl` file with `use Group::{item1 as a1, item2 as a2}`, **When** semantic analysis runs, **Then** each alias is resolved independently and unused aliases are reported as warnings.

---

### User Story 2 — Capitalization and Identifier Validation (Priority: P1)

The language enforces strict capitalization rules: SCREAMING_SNAKE for immutable constants, snake_case for mutable variables, camelCase for functions/ops/aliases, PascalCase for agents/contracts/programs. The semantic analyzer must validate every identifier against its context.

**Why this priority**: Capitalization is a core language design constraint preventing naming ambiguity. Violations degrade readability and may cause confusion during code review. Early detection via SUGGESTION diagnostics improves code quality.

**Independent Test**: Can be tested by writing a function with a PascalCase name and verifying a SUGGESTION diagnostic is emitted with the corrected camelCase form.

**Acceptance Scenarios**:

1. **Given** a mutable variable declared with SCREAMING_SNAKE (`MAX_VALOR`), **When** semantic analysis runs, **Then** a SUGGESTION diagnostic suggests `max_valor`.
2. **Given** a function declared with snake_case (`calcular_total`), **When** semantic analysis runs, **Then** a SUGGESTION diagnostic suggests `calcularTotal`.
3. **Given** an agent declared with camelCase (`meuServico`), **When** semantic analysis runs, **Then** a SUGGESTION diagnostic suggests `MeuServico`.
4. **Given** all identifiers in a file follow their correct capitalization rules, **When** semantic analysis runs, **Then** no capitalization diagnostics are emitted.
5. **Given** an immutable constant declared with snake_case (`pi`), **When** semantic analysis runs, **Then** a SUGGESTION diagnostic suggests `PI`.

---

### User Story 3 — Type Checking and Mutability Validation (Priority: P1)

After scope resolution, the semantic analyzer validates type compatibility across assignments, function calls, operator applications, struct/enum initialization, match/route conditions, tensor indexing, and cast expressions. It also enforces mutability rules: immutable declarations must have an initializer; list/set types cannot be declared immutable.

**Why this priority**: Type safety is the foundation of reliable execution across all five backends. A single type mismatch caught at this stage prevents runtime faults in all targets simultaneously (per Multi-Target Synchronization principle).

**Independent Test**: Can be tested by writing a function that assigns a string to an int64-typed storage slot and verifying a type mismatch diagnostic.

**Acceptance Scenarios**:

1. **Given** a `mut as int64: x = "hello"` declaration, **When** semantic analysis runs, **Then** a type mismatch diagnostic (SEM001) is emitted.
2. **Given** a struct field of type `int64` initialized with a float literal, **When** semantic analysis runs, **Then** a type mismatch diagnostic is emitted unless an implicit cast is defined.
3. **Given** an `imut` declaration without `= expression`, **When** semantic analysis runs, **Then** a diagnostic reminds that immutable declarations require an initializer.
4. **Given** a `list of int64` declared as `imut`, **When** semantic analysis runs, **Then** a diagnostic rejects mutable-typed collections under immutability.
5. **Given** a route condition expression that evaluates to a non-bool type, **When** semantic analysis runs, **Then** a type incompatibility diagnostic is emitted.
6. **Given** a tensor index expression with dimension count mismatching the tensor shape, **When** semantic analysis runs, **Then** a diagnostic reports the shape mismatch.
7. **Given** a `cast` expression from `int64` to `string`, **When** semantic analysis runs, **Then** either the cast is accepted (if defined in stdlib) or a diagnostic reports an invalid cast.

---

### User Story 4 — Ownership and Lifetime Validation (Priority: P2)

Ownership tracking verifies that `move`, `borrow`, and `keep` semantics are respected: no use-after-move, exclusive borrows have no concurrent access, and `unsafe` blocks silence ownership checks. This ensures memory safety across all execution backends.

**Why this priority**: Ownership safety directly impacts correctness across all targets, but the basic parser already enforces syntactic ownership. The semantic layer adds cross-block tracking. P2 because initial MVP can run with conservative ownership assumptions.

**Independent Test**: Can be tested by a program that moves a variable then reads it, verifying a use-after-move diagnostic.

**Acceptance Scenarios**:

1. **Given** a variable accessed after `move(x)`, **When** semantic analysis runs, **Then** a use-after-move diagnostic (SEM001) is emitted with the location of the move and the subsequent use.
2. **Given** a borrow that outlives its source scope, **When** semantic analysis runs, **Then** a lifetime diagnostic is emitted.
3. **Given** a `unsafe { }` block containing a use-after-move, **When** semantic analysis runs, **Then** no ownership diagnostic is emitted within the unsafe block.
4. **Given** a `keep(x)` followed by continued use of `x`, **When** semantic analysis runs, **Then** no diagnostic is emitted (keep preserves ownership).

---

### User Story 5 — Contract-Agent Implementation Verification (Priority: P2)

Contracts define op signatures; agents implement them. The semantic analyzer must verify that for every `impl Contract for Agent`, all required ops are implemented with matching signatures (name, parameter types, return type). Agents may have extra ops beyond the contract.

**Why this priority**: Contract-agent compliance is a core architectural guarantee of the dataflow/agent-oriented paradigm. P2 because the MVP can run agents without contract enforcement.

**Independent Test**: Can be tested by writing an `impl Validador for MeuServico` where one op signature is missing, and verifying a diagnostic listing the missing signature.

**Acceptance Scenarios**:

1. **Given** a contract with three op signatures and an `impl` that implements only two, **When** semantic analysis runs, **Then** a diagnostic lists the missing op implementation.
2. **Given** an op implementation with mismatched parameter types versus the contract signature, **When** semantic analysis runs, **Then** a signature mismatch diagnostic is emitted.
3. **Given** an `impl` that implements all required signatures correctly, **When** semantic analysis runs, **Then** no contract-related diagnostics are emitted.
4. **Given** an agent with extra ops beyond the contract signature set, **When** semantic analysis runs, **Then** no diagnostic is emitted (extra ops are allowed).

---

### User Story 6 — Emit Terminal Validation (Priority: P3)

Functions with declared return types must have an `emit(nice/fail, ...)` statement on every possible execution path (excluding infinite loops). This guarantees that functions cannot fall off the end without producing a result.

**Why this priority**: Important for correctness but initial targets can treat missing emit as a runtime error rather than a compile-time diagnostic. P3 because downstream backends handle missing terminals gracefully in MVP.

**Independent Test**: Can be tested by a function with a return type that has a code path without `emit`, verifying a terminal diagnostic.

**Acceptance Scenarios**:

1. **Given** a function with return type `int64` containing a route with two arms but only one arm has an `emit`, **When** semantic analysis runs, **Then** a diagnostic reports a code path without terminal emit.
2. **Given** a function with return type and an `infinite` loop containing no `emit`, **When** semantic analysis runs, **Then** no diagnostic is emitted (loops are not guaranteed to terminate).
3. **Given** a function with return type where all code paths end with `emit`, **When** semantic analysis runs, **Then** no terminal diagnostics are emitted.

---

### Edge Cases

- What happens when a file has zero declarations (empty program)?
- How does the analyzer handle mutually recursive function calls?
- What happens when `use` imports a name that shadows a built-in type?
- How does type inference work with dataflow pipelines (`-->`, `==>`)?
- How are tensor shapes validated when initialized from literals?
- What happens with `op` declarations inside an agent that has no `impl` (avulso agent)?
- How does ownership tracking handle branches (route arms)?
- What happens when `emit` is used outside a function body?

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The semantic analyzer MUST build a hierarchical symbol table from the AST, resolving each identifier reference to its declaration site including `use` imports.
- **FR-002**: The analyzer MUST detect and report duplicate declarations within the same scope (SEM001).
- **FR-003**: The analyzer MUST detect and report unresolved references (SEM001) with precise source location.
- **FR-004**: The analyzer MUST validate identifier capitalization against the context: mut variables → snake_case, imut constants → SCREAMING_SNAKE, functions/ops → camelCase, agents/programs/contracts → PascalCase. Violations emit SUGGESTION diagnostics.
- **FR-005**: The analyzer MUST validate that `imut` declarations include an initializer (`= expression`).
- **FR-006**: The analyzer MUST reject `imut` declarations for collection types (`list`, `set`, `map`, `tensor`).
- **FR-007**: The analyzer MUST validate type compatibility across assignments, function parameters and return types, operator operands, struct/enum field initialization, route conditions, match arms, and cast expressions.
- **FR-008**: The analyzer MUST validate tensor index count against declared tensor dimensions.
- **FR-009**: The analyzer MUST track ownership (`move`, `borrow`, `keep`) across statement boundaries and detect use-after-move, exclusive-borrow conflicts, and lifetime violations.
- **FR-010**: The analyzer MUST silence ownership/lifetime/mutability checks within `unsafe` blocks.
- **FR-011**: The analyzer MUST verify that every `impl ContractName for AgentName` implements all ops from the contract with matching signatures, reporting missing or mismatched implementations.
- **FR-012**: The analyzer MUST verify that functions with declared return types have an `emit` statement on every non-loop code path, reporting missing terminals.
- **FR-013**: The analyzer MUST produce a decorated AST with attached semantic metadata (resolved types, symbol references, ownership states) for all downstream phases (DDG, bytecode, LLVM, WASM).
- **FR-014**: The analyzer MUST output diagnostics in the unified format: `file:line,col -> [SEM001]: message`.
- **FR-015**: The analyzer MUST operate modularly as an independent pipeline phase, consuming the AST (from Phase 3) and producing the decorated AST (for Phase 6+). It must NOT depend on any specific backend.

### Key Entities *(include if feature involves data)*

- **Symbol Table**: A hierarchical mapping from identifier names to their declarations, scoped by blocks (function bodies, route arms, infinite loop bodies, agent bodies). Supports shadowing and cross-module resolution via `use` imports.
- **Type**: The type representation system supporting primitives (int8–int64, uint8–uint64, float16–float64, fp8, bf16, tf32, complex32–128, char, string, bool, datetime, data), collections (list, set, map, tensor with shape), user-defined structs and enums, and function signatures.
- **Ownership State**: Per-variable tracking of whether a value has been moved, borrowed (mutably or immutably), kept, or is in its original owning scope. Maintained across sequential statements and branch merges.
- **Diagnostic**: A structured error/warning/suggestion with code (SEM001 or SUGGESTION), severity (error, warning, suggestion), source location (file, line, column), and human-readable message. Follows the format defined in grammar.md §14.
- **Decorated AST**: The original AST augmented with semantic metadata — each node annotated with its resolved type, symbol table reference, ownership state before/after, and any diagnostic associations.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A `.flux` file with correct use declarations, capitalization, types, ownership, and emit terminals passes semantic analysis with zero diagnostics across all 5 targets.
- **SC-002**: A `.flux` file with a single capitalization violation produces exactly one SUGGESTION diagnostic at the correct location — identical output regardless of whether the target is interpreter, VM, LLVM, WAT, or WASM.
- **SC-003**: A `.flux` file with a type mismatch in a dataflow pipeline produces a SEM001 diagnostic under 100ms for files up to 1000 lines of code.
- **SC-004**: Zero false-positive diagnostics on all positive test cases from the parser test suite (lexer + parser passing files must also pass semantic analysis).
- **SC-005**: Contract-agent verification completes in under 200ms for contracts with up to 50 op signatures.
- **SC-006**: The decorated AST produced by the semantic analyzer is consumed identically by all downstream phases (DDG, bytecode, LLVM, WAT, WASM) without requiring per-backend modifications.
- **SC-007**: 100% of the semantic rules documented in grammar.md §13 (items 5a–5g) are implemented and covered by automated tests across positive, negative, false-positive, and false-negative categories.

## Assumptions

- The AST produced by the parser (Phase 3) is complete and correct — the semantic analyzer does not re-parse.
- Macro expansion (Phase 4) runs before semantic analysis — the semantic analyzer receives the fully expanded AST.
- The symbol table design uses a stack of scopes (lexical scoping) matching the indent/dedent structure of the parser.
- Type inference follows a unification-based approach: the analyzer collects type constraints from expressions and solves them (or reports incompatibility).
- Ownership tracking is flow-sensitive within a function body and flow-insensitive across function boundaries (each function is analyzed independently).
- The five backends (interpreter, VM, LLVM, WAT, WASM) all consume the same decorated AST format — no backend-specific semantic passes are needed.
- The `SUGGESTION` diagnostic level is non-fatal: compilation may proceed, and backends produce output regardless of SUGGESTION diagnostics.
- For v1, tensor shape validation is limited to static dimensions (dynamic shapes deferred).
- The analyzer operates on a single file at a time; cross-file `use` resolution uses file path conventions (`.fdsl` files define agents available for import).
