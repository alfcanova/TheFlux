# Research: Semantic Analyzer Design

## Unknowns Resolved

### 1. Decorated AST Mechanism

**Decision**: Use a separate `SemanticAnnotation` dict attached to each AST node via a `semantics` attribute, rather than subclassing AST nodes or creating a parallel tree.

**Rationale**: The AST node dataclasses are fixed (defined in `parser/ast.py`). Adding a mutable `semantics: dict[str, Any] = field(default_factory=dict)` field to `ASTNode` allows the semantic analyzer to attach arbitrary metadata (resolved type, symbol reference, ownership state) without changing the node hierarchy. This keeps the parser clean and the semantic layer loosely coupled.

**Alternatives considered**: 
- Parallel tree of `DecoratedNode` wrappers — adds complexity for traversal and node identity
- Subclassing each AST node — violates Open/Closed principle, requires changes to parser
- External map `id(node) -> SemanticInfo` — fragile, breaks with AST cloning

### 2. Symbol Table Implementation

**Decision**: Stack-based scope chain with `Scope` objects containing a `dict[str, Symbol]` and a parent pointer. Use declarations resolved eagerly at symbol table construction.

**Rationale**: Lexical scoping matches the parser's INDENT/DEDENT structure. Each scope push/pop corresponds to block entry/exit. Symbol stores: name, kind (variable, function, struct, agent, contract, op, enum, macro), declaration AST node reference, type if declared, capitalization category, and mutability flag.

**Alternatives considered**:
- Single flat table with mangled names — loses scope nesting information needed for ownership tracking
- Tree of scopes as separate data structure — equivalent complexity, adds indirection

### 3. Type Inference Strategy

**Decision**: Bidirectional type checking (propagation + inference) with a constraint-based fallback. Declared types are propagated downward; uninferred types are solved via unification constraints collected during the pass.

**Rationale**: The grammar has explicit type annotations on storage declarations, struct fields, function parameters, and return types. Most types are declared. For cases without annotations (e.g., literals, expressions in generic contexts), the analyzer collects type constraints and solves them in a second pass.

**Alternatives considered**:
- Full Hindley-Milner — overkill for a language with mandatory type annotations on declarations
- Pure top-down propagation — fails for expressions like `x = y` where `y` type is inferred from `x`'s context
- AST visitor with separate pass ordering — pattern used in Rust's compiler, matches our phase separation

### 4. Flow-Sensitive Ownership Tracking

**Decision**: State vector per variable at each statement boundary, propagated forward. At branch merge points (route arms, if/else, match arms), the resulting state is the union of all branch end-states with conflicts flagged.

**Rationale**: Ownership is a linear property — a variable goes through states (Owned → Moved, Owned → Borrowed, Borrowed → Accessed, etc.). Tracking state per statement is straightforward for a recursive-descent analysis. Branch merge uses a conservative "moved in any branch" rule: if any branch moves a variable, it's considered moved after the merge.

**Alternatives considered**:
- SSA form — more complex transformation, not needed until bytecode generation
- Algebraic effects — non-standard, adds runtime cost
- Single static assignment of ownership per scope — too conservative, blocks valid programs

### 5. Diagnostic Severity Levels

**Decision**: Three severity levels — `ERROR` (SEM001, blocks compilation), `WARNING` (SEM002, non-fatal), `SUGGESTION` (SUG code, advisory only).

**Rationale**: Matches grammar.md's terminology (SEM001 for errors, SUGGESTION for capitalization hints). Warnings fill the gap between blocking errors and advisory suggestions (e.g., unused imports).

**Alternatives considered**:
- Two-level (error/warning) — insufficient granularity for SUGGESTION
- Five-level (critical/error/warning/notice/suggestion) — over-engineered for v1

### 6. Branch Merge for Ownership States

**Decision**: At control-flow merge points (route arm end, match arm end), compute the union of variable ownership states across all branches. A variable is `Moved` after the merge if any branch moved it; `Borrowed` if any branch borrowed it and it wasn't moved; otherwise `Owned`. Conflicts (borrow vs. move in different branches) are flagged.

**Rationale**: Conservative approximation that guarantees soundness. The route/match structure makes this straightforward: the analyzer visits each arm independently with a copy of the pre-branch state, then merges results.

**Alternatives considered**:
- Intersection (pessimistic) — marks variables as unavailable unless all branches keep them
- Lattice-based — correct but more complex implementation

### 7. Emit Terminal Path Analysis

**Decision**: Simple reachability walk of the statement tree per function body. Each statement type is classified as: (a) definitely emits (emit statement), (b) conditionally emits (route — some arms may emit), (c) never emits (break, continue, expression statements). The walk reports "function has path without emit" if any path reaches the end of the function body without encountering an emit.

**Rationale**: The language has no unstructured control flow (no goto). Route/match are the only branching constructs. A DFS or recursive walk covers all paths. Infinite loops are considered non-terminating and don't require an emit.

**Alternatives considered**:
- Control-flow graph (CFG) — needed for the DDG phase anyway, but premature for emit checking alone
- Linear analysis — insufficient for code with branching

### 8. Toolchain Availability

**Decision**: Use Python-only implementation for the semantic analyzer. Wasmer/WABT (for WASM verification), Zig, Rust, and Go are available on PATH but are not needed — the analysis phase is purely symbolic and operates on in-memory AST.

**Rationale**: The constitution states Python is the host language for the compiler. WASM/backend-specific concerns are downstream (Phases 8–10). The semantic analyzer's output is plain AST + diagnostics.

## Technology Choices

| Concern | Choice | Rationale |
|---------|--------|-----------|
| Type representation | `Type` hierarchy (dataclasses) | Matches existing AST pattern, no external dep |
| Symbol table | `Scope` stack with `dict[str, Symbol]` | Simple, matches lexical scoping |
| Diagnostic format | `dataclass Diagnostic` | Structured for programmatic use, serializes for CLI |
| Ownership tracking | Linear state vector per scope | Sound approximation, straightforward implementation |
| Branch merge | Conservative (union + conflict flag) | Sound, no false negatives |
| Emit check | Recursive reachability walk | Matches language structure (no goto) |
