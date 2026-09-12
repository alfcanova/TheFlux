# Data Model: Semantic Analyzer

## Entities

### SymbolTable

The top-level symbol table for a single compilation unit (.flux or .fdsl file).

| Field | Type | Description |
|-------|------|-------------|
| `scopes` | `list[Scope]` | Scope stack (innermost last) |
| `imports` | `dict[str, ImportBinding]` | Resolved use declarations |
| `errors` | `list[Diagnostic]` | Diagnostics collected during analysis |

**Relationships**: Contains 1+ `Scope` objects. Each file gets one `SymbolTable`.

---

### Scope

A lexical scope corresponding to a block (program body, function body, agent body, route arm, etc.).

| Field | Type | Description |
|-------|------|-------------|
| `parent` | `Scope \| None` | Enclosing scope (None for global/module scope) |
| `symbols` | `dict[str, Symbol]` | Names declared in this scope |
| `kind` | `ScopeKind` | Enum: GLOBAL, FUNCTION, BLOCK, LOOP, ROUTE_ARM, MATCH_ARM, AGENT, UNSAFE |

**Relationships**: Each scope has a parent (except global). Each scope contains 0+ `Symbol` entries.

**Validation rules**:
- Duplicate name within the same scope → SEM001 error
- Inner scope name shadows outer scope name silently (per lexical scoping rules)
- `unsafe` scope silences ownership/mutability checks but does not affect scope resolution

---

### Symbol

Represents a single declaration or definition.

| Field | Type | Description |
|-------|------|-------------|
| `name` | `str` | Identifier text |
| `kind` | `SymbolKind` | Enum: VARIABLE, CONSTANT, FUNCTION, STRUCT, ENUM, AGENT, CONTRACT, OP, MACRO, TYPE_ALIAS |
| `decl_node` | `ASTNode` | Reference to the declaration AST node |
| `type_ref` | `Type \| None` | Resolved type (None before type checking pass) |
| `mutable` | `bool` | Whether the symbol can be mutated |
| `capitalization` | `CapitalizationKind` | Expected style: SNAKE, SCREAMING_SNAKE, CAMEL, PASCAL, WILDCARD |
| `initialized` | `bool` | Whether declaration includes initializer (= expression) |
| `module_path` | `str \| None` | Full dotted path if imported via use (e.g., "Sensor::read") |

**Relationships**: Belongs to exactly one `Scope`. May reference a `Type`.

**Validation rules**:
- Capitalization must match `capitalization` category → SUGGESTION on violation
- If `initialized` is False and `kind` is CONSTANT → SEM001 error (imut requires = expression)
- If `mutable` is True and `type_ref` is a collection type declared as imut → SEM001 error

---

### Type

Hierarchy of types supported by the language.

| Variant | Fields | Description |
|---------|--------|-------------|
| `PrimitiveType` | `name: str` | int8–int64, uint8–uint64, float16–float64, fp8_e4m3, fp8_e5m2, bf16_e8m7, tf32_e8m10, complex32–128, char, string, bool, datetime, data |
| `ListType` | `element_type: Type` | `list of <primitive_type>` |
| `SetType` | `element_type: Type` | `set of <primitive_type>` |
| `MapType` | `value_type: Type` | `map of <primitive_type>` |
| `TensorType` | `shape: list[int]`, `element_type: Type` | `tensor[shape] of <primitive_type>` |
| `StructType` | `name: str`, `fields: dict[str, Type]` | User-defined struct |
| `EnumType` | `name: str`, `base: PrimitiveType \| None`, `variants: list[str]` | User-defined enum |
| `FunctionType` | `params: list[Type]`, `return_type: Type \| None` | Function signature |
| `TypeVar` | `name: str` | Placeholder for type inference (solved during constraint pass) |

**Validation rules**:
- Compatibility checking follows structural typing for primitives (int64 compatible with int32 via implicit widening)
- Struct/enum types use nominal typing (name-based)
- Tensor index count must match shape length (FR-008)
- Cast compatibility is defined by the stdlib (FR-007)

---

### OwnershipState

Per-variable ownership tracking.

| Variant | Description |
|---------|-------------|
| `Owned` | Variable holds its value; can be read, moved, borrowed |
| `Moved` | Value has been moved away; any subsequent use is an error |
| `Borrowed` | Value is currently borrowed (immutably); reads allowed, moves blocked |
| `BorrowedMut` | Value is currently mutably borrowed; reads and writes blocked |
| `Kept` | Value has been kept (ownership retained); normal access |

**State transitions**:
- `Owned` → `Moved` on `move(x)`
- `Owned` → `Borrowed` on `borrow(x)`
- `Owned` → `BorrowedMut` on mutable borrow (implicit in calling `=&` or similar)
- `Borrowed` → `Owned` when borrow scope ends
- `BorrowedMut` → `Owned` when mutable borrow scope ends
- `Owned` → `Kept` on `keep(x)` (future borrows still allowed)
- Any → NoChange on access within `unsafe` block

**Validation rules**:
- Use of `Moved` variable → SEM001 error with both move and use locations
- Simultaneous `Borrowed` + `BorrowedMut` to same variable → SEM001 conflict
- All checks silenced within `unsafe` blocks (FR-010)

---

### Diagnostic

Structured error/warning/suggestion.

| Field | Type | Description |
|-------|------|-------------|
| `code` | `str` | Diagnostic code: SEM001 (error), SEM002 (warning), or SUG (suggestion) |
| `severity` | `Severity` | Enum: ERROR, WARNING, SUGGESTION |
| `line` | `int` | Source line (1-based) |
| `column` | `int` | Source column (1-based) |
| `message` | `str` | Human-readable description |
| `related` | `list[SourceLocation]` | Additional locations (e.g., move site for use-after-move) |

**Format**: `file:line,col -> [CODE]: message`

---

### DecoratedAST

Wrapper around the original AST with semantic annotations.

| Field | Type | Description |
|-------|------|-------------|
| `original_ast` | `ASTNode` | Root of the parser AST |
| `symbol_table` | `SymbolTable` | Resolved symbol table for the file |
| `annotations` | `dict[int, SemanticAnnotation]` | Map: `id(node)` → annotation |

**SemanticAnnotation**:

| Field | Type | Description |
|-------|------|-------------|
| `resolved_type` | `Type \| None` | Type inferred/checked for this node |
| `symbol` | `Symbol \| None` | Resolved symbol if node is an identifier reference |
| `ownership_before` | `dict[str, OwnershipState]` | Ownership state before this node executes |
| `ownership_after` | `dict[str, OwnershipState]` | Ownership state after this node executes |
| `diagnostics` | `list[Diagnostic]` | Diagnostics associated specifically with this node |

---

## State Transitions

### Analysis Pipeline (Per File)

```
Phase 3 AST
    │
    ▼
[1] Symbol Table Construction     ← FR-001, FR-002, FR-003
    │  - Walk top-level declarations
    │  - Resolve use imports
    │  - Build Scope hierarchy
    │  - Insert symbols per scope
    │  - Report duplicates, unresolved
    │
    ▼
[2] Capitalization Validation     ← FR-004
    │  - Check each symbol name against capitalization category
    │  - Emit SUGGESTION on mismatch
    │
    ▼
[3] Mutability Validation         ← FR-005, FR-006
    │  - Check imut decls have initializer
    │  - Check collection types not imut
    │
    ▼
[4] Type Checking & Inference     ← FR-007, FR-008
    │  - Propagate declared types
    │  - Collect and solve type constraints
    │  - Validate compatibility at assignments, params, operators, casts
    │  - Validate tensor indices
    │
    ▼
[5] Ownership Tracking            ← FR-009, FR-010
    │  - Walk each function body linearly
    │  - Track state per variable
    │  - Merge at branch points
    │  - Report use-after-move, borrow conflicts
    │  - Silence in unsafe blocks
    │
    ▼
[6] Contract-Agent Verification   ← FR-011
    │  - For each impl, match ops against contract signatures
    │  - Report missing or mismatched ops
    │
    ▼
[7] Emit Terminal Path Analysis   ← FR-012
    │  - Walk function body paths
    │  - Report paths without emit
    │
    ▼
Decorated AST → Phases 6+ (DDG, bytecode, LLVM, WAT, WASM)
```

### Dependency Flow Between Sub-Modules

```
semantic/analyzer.py  (orchestrator)
    ├── symbol_table.py      (Phase 1: scopes + symbols)
    ├── capitalization.py    (Phase 2: name validation)
    ├── mutability.py        (Phase 3: mut/imut rules)
    ├── types.py             (Phase 4: type system + checking)
    ├── ownership.py         (Phase 5: ownership tracking)
    ├── contracts.py         (Phase 6: contract-agent verification)
    ├── emit_check.py        (Phase 7: emit terminal validation)
    ├── diagnostic.py        (shared: Diagnostic types + formatting)
    └── ast_decorator.py     (shared: Annotation attachment)
```

Each sub-module depends only on `ast_decorator.py`, `diagnostic.py`, and the preceding sub-modules in the pipeline.
