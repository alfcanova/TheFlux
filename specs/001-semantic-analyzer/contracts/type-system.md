# Contract: Type System

## Interface

### `Type` Hierarchy

```python
@dataclass
class Type: ...

@dataclass
class PrimitiveType(Type):
    name: str  # int8|int16|int32|int64|uint8|...|data

@dataclass
class ListType(Type):
    element_type: Type

@dataclass
class SetType(Type):
    element_type: Type

@dataclass
class MapType(Type):
    value_type: Type

@dataclass
class TensorType(Type):
    shape: list[int]
    element_type: Type

@dataclass
class StructType(Type):
    name: str
    fields: dict[str, Type]

@dataclass
class EnumType(Type):
    name: str
    base: PrimitiveType | None
    variants: list[str]

@dataclass
class FunctionType(Type):
    params: list[Type]
    return_type: Type | None

@dataclass
class TypeVar(Type):
    name: str  # unused/variable for inference
```

### `TypeChecker`

```python
class TypeChecker:
    def __init__(self, symbol_table: SymbolTable) -> None: ...
    def check_type_compatibility(self, actual: Type, expected: Type, node: ASTNode) -> Diagnostic | None: ...
    def infer_type(self, node: ASTNode) -> Type: ...
    def check_tensor_indices(self, tensor_type: TensorType, index_count: int, node: ASTNode) -> Diagnostic | None: ...
    def diagnostics(self) -> list[Diagnostic]: ...
```

## Pre-conditions

- Symbol table is fully populated (Phase 1 complete)
- Capitalization validation complete (Phase 2)

## Post-conditions

- Every expression node in the AST has a resolved type annotation (or diagnostics if type inference fails)
- Type incompatibilities are reported
- Tensor index mismatches are reported
- The decorated AST contains `resolved_type` for each expression and declaration node

## Compatibility Rules

| Actual | Expected | Action |
|--------|----------|--------|
| int8–int64 | int8–int64 (any width) | Widening allowed (int8→int16→int32→int64, no narrowing) |
| uint8–uint64 | uint8–uint64 | Widening allowed within unsigned family |
| intX | floatY | Implicit conversion to float (int→float always safe) |
| floatX | floatY | Widening allowed |
| TypeVar (unresolved) | Anything | Constraint recorded, solved later |
| literal int | Type | Constrain type from context |
| struct A | struct A (same name) | Nominal match |
| enum A::Variant | enum A | Nominal match |
| tensor[N, M] of T | tensor[N, M] of T | Shape and element type must match exactly |
| Any | Any | Valid (data type) |
| Cast expression | Explicit conversion | Valid if cast defined in stdlib or SEM001 |
