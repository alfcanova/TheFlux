# Contract: Symbol Table

## Interface

The symbol table module exposes the following API to the semantic orchestrator and other sub-modules:

### `SymbolTable`

```python
class SymbolTable:
    def __init__(self, file_path: str) -> None: ...
    def enter_scope(self, kind: ScopeKind) -> Scope: ...
    def exit_scope(self) -> Scope | None: ...
    def declare(self, name: str, kind: SymbolKind, node: ASTNode, mutable: bool = True) -> Symbol | Diagnostic: ...
    def resolve(self, name: str) -> Symbol | None: ...
    def resolve_qualified(self, module_path: list[str]) -> Symbol | None: ...
    def add_import(self, name: str, binding: ImportBinding) -> Diagnostic | None: ...
    def get_scope(self) -> Scope: ...
    def diagnostics(self) -> list[Diagnostic]: ...
```

### `Scope`

```python
@dataclass
class Scope:
    parent: Scope | None
    symbols: dict[str, Symbol]
    kind: ScopeKind

class ScopeKind(Enum):
    GLOBAL = auto()
    FUNCTION = auto()
    BLOCK = auto()
    LOOP = auto()
    ROUTE_ARM = auto()
    MATCH_ARM = auto()
    AGENT = auto()
    UNSAFE = auto()
```

### `Symbol`

```python
@dataclass
class Symbol:
    name: str
    kind: SymbolKind
    decl_node: ASTNode
    type_ref: Type | None = None
    mutable: bool = True
    capitalization: CapitalizationKind | None = None
    initialized: bool = False
    module_path: str | None = None

class SymbolKind(Enum):
    VARIABLE = auto()
    CONSTANT = auto()
    FUNCTION = auto()
    STRUCT = auto()
    ENUM = auto()
    AGENT = auto()
    CONTRACT = auto()
    OP = auto()
    MACRO = auto()
    TYPE_ALIAS = auto()

class CapitalizationKind(Enum):
    SNAKE = auto()        # mutable variables
    SCREAMING_SNAKE = auto()  # immutable constants
    CAMEL = auto()        # functions, ops, aliases
    PASCAL = auto()       # agents, contracts, programs
    WILDCARD = auto()     # system wildcard identifiers
```

## Pre-conditions

- AST must be fully expanded (macro expansion Phase 4 must have run)
- AST must pass parser validation (no PAR001 errors)

## Post-conditions

- Every identifier reference in the AST has an associated Symbol (or a diagnostic is emitted for unresolved references)
- Diagnostics are collected and available via `diagnostics()`
- The symbol table is fully populated for use by subsequent phases (capitalization, type checking, etc.)

## Validation Rules

| Rule | Condition | Diagnostic |
|------|-----------|------------|
| Duplicate name | `declare()` called with name already in current scope | SEM001 error: "Duplicate declaration of 'name'" |
| Unresolved reference | `resolve()` returns None | SEM001 error: "Unresolved reference 'name'" |
| Shadowing | Inner scope name matches outer scope name | Allowed (lexical shadowing) — no diagnostic |
| Use alias resolves | `resolve()` traverses `ImportBinding` chain | Must resolve to concrete agent/op, or SEM001 |
