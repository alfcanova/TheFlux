from __future__ import annotations

import re
from dataclasses import dataclass, field
from typing import Any

from flux_proto.parser.ast import (
    ASTNode,
    Literal,
    Identifier,
    BinaryOp,
    UnaryOp,
    CastExpr,
    CallExpr,
    SpawnExpr,
    AwaitExpr,
    FieldAccess,
    StructInit,
    EnumVariant,
    IndexAccess,
    InterpolatedString,
    StorageDecl,
    StorageItem,
    ComptimeExpr,
    BlockStmt,
    ExpressionStmt,
    IndexAssign,
    FieldAssign,
    SliceSpec,
    FunctionDef,
    OpDecl,
    PrintStmt,
    SpyExpr,
)
from flux_proto.semantic.diagnostic import Diagnostic, Severity
from flux_proto.semantic.symbol_table import SymbolKind


@dataclass
class Type:
    pass


@dataclass
class PrimitiveType(Type):
    name: str


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
    variants: list[str] = field(default_factory=list)


@dataclass
class FunctionType(Type):
    params: list[Type] = field(default_factory=list)
    return_type: Type | None = None


@dataclass
class TypeVar(Type):
    name: str = ""


_BUILTIN_TYPE_NAMES = {
    "int8", "int16", "int32", "int64",
    "uint8", "uint16", "uint32", "uint64",
    "float16", "float32", "float64",
    "fp8_e4m3", "fp8_e5m2", "bf16_e8m7", "tf32_e8m10",
    "complex32", "complex64", "complex128",
    "char", "string", "bool", "datetime", "data",
}

_INT_TYPES = {"int8", "int16", "int32", "int64"}
_UINT_TYPES = {"uint8", "uint16", "uint32", "uint64"}
_FLOAT_TYPES = {"float16", "float32", "float64", "fp8_e4m3", "fp8_e5m2", "bf16_e8m7", "tf32_e8m10"}

_INT_WIDENING = {"int8": "int16", "int16": "int32", "int32": "int64", "int64": "int64"}
_UINT_WIDENING = {"uint8": "uint16", "uint16": "uint32", "uint32": "uint64", "uint64": "uint64"}
_FLOAT_WIDENING = {"float16": "float32", "float32": "float64", "float64": "float64"}

_SKIP_ARITY_CHECK: set[str] = {"print", "println"}


def _call_callee_name(node: CallExpr) -> str:
    callee = node.callee
    if isinstance(callee, Identifier):
        return callee.name
    if isinstance(callee, FieldAccess):
        return callee.field
    if isinstance(callee, EnumVariant):
        return callee.variant
    return ""


def _decl_param_count(decl: Any) -> int:
    if isinstance(decl, FunctionDef):
        return len(decl.params)
    if isinstance(decl, OpDecl):
        if decl.params:
            return len(decl.params)
        count = 0
        if decl.left_type is not None:
            count += 1
        if decl.right_type is not None:
            count += 1
        return count
    return -1

_COLLECTION_KINDS = {"list", "set", "map", "tensor"}

_COLLECTION_NAME_TO_TYPE = {
    "list": ListType,
    "set": SetType,
    "map": MapType,
}

_ALLOWED_CASTS: set[tuple[str, str]] = {
    ("int8", "int16"), ("int8", "int32"), ("int8", "int64"),
    ("int16", "int32"), ("int16", "int64"), ("int32", "int64"),
    ("uint8", "uint16"), ("uint8", "uint32"), ("uint8", "uint64"),
    ("uint16", "uint32"), ("uint16", "uint64"), ("uint32", "uint64"),
    ("float16", "float32"), ("float16", "float64"), ("float32", "float64"),
    ("int8", "float16"), ("int8", "float32"), ("int8", "float64"),
    ("int16", "float16"), ("int16", "float32"), ("int16", "float64"),
    ("int32", "float16"), ("int32", "float32"), ("int32", "float64"),
    ("int64", "float16"), ("int64", "float32"), ("int64", "float64"),
    ("uint8", "float16"), ("uint8", "float32"), ("uint8", "float64"),
    ("uint16", "float16"), ("uint16", "float32"), ("uint16", "float64"),
    ("uint32", "float16"), ("uint32", "float32"), ("uint32", "float64"),
    ("uint64", "float16"), ("uint64", "float32"), ("uint64", "float64"),
    ("bool", "int64"), ("bool", "string"),
    ("string", "int64"), ("string", "float64"), ("string", "bool"),
    ("char", "string"),
    ("int64", "string"),
    ("float64", "string"),
}


def is_collection_type(t: Type) -> bool:
    return isinstance(t, (ListType, SetType, MapType, TensorType))


def is_numeric_type(t: Type) -> bool:
    if isinstance(t, PrimitiveType):
        return t.name in _INT_TYPES | _UINT_TYPES | _FLOAT_TYPES
    return False


def type_name(t: Type | None) -> str:
    if isinstance(t, PrimitiveType):
        return t.name
    if isinstance(t, ListType):
        return f"list of {type_name(t.element_type)}"
    if isinstance(t, SetType):
        return f"set of {type_name(t.element_type)}"
    if isinstance(t, MapType):
        return f"map of {type_name(t.value_type)}"
    if isinstance(t, TensorType):
        return f"tensor[{','.join(str(s) for s in t.shape)}] of {type_name(t.element_type)}"
    if isinstance(t, StructType):
        return t.name
    if isinstance(t, EnumType):
        return t.name
    if isinstance(t, FunctionType):
        params = ", ".join(type_name(p) for p in t.params)
        ret = type_name(t.return_type) if t.return_type else "void"
        return f"({params}) as {ret}"
    if isinstance(t, TypeVar):
        return f"<infer:{t.name}>"
    return "?"


class TypeChecker:
    def __init__(self, symbol_table: Any = None, decorator: Any = None) -> None:
        self._symbol_table = symbol_table
        self._decorator = decorator
        self._diagnostics: list[Diagnostic] = []
        self._local_types: list[dict[str, Type]] = [{}]

    def infer_type(self, node: ASTNode) -> Type:
        t = self._infer(node)
        if self._decorator is not None:
            self._decorator.set_resolved_type(node, t)
        return t

    def _infer(self, node: ASTNode) -> Type:
        if node is None:
            return TypeVar("?")
        if isinstance(node, Literal):
            return self._infer_literal(node)
        if isinstance(node, Identifier):
            return self._infer_identifier(node)
        if isinstance(node, BinaryOp):
            return self._infer_binary_op(node)
        if isinstance(node, UnaryOp):
            return self._infer_unary_op(node)
        if isinstance(node, SpawnExpr):
            return self._infer_spawn(node)
        if isinstance(node, AwaitExpr):
            return self._infer_await(node)
        if isinstance(node, CastExpr):
            return self._infer_cast(node)
        if isinstance(node, CallExpr):
            return self._infer_call(node)
        if isinstance(node, InterpolatedString):
            return PrimitiveType("string")
        if isinstance(node, StorageDecl):
            for item in node.items:
                self._infer(item)
            return TypeVar("?")
        if isinstance(node, StorageItem):
            expected = self._infer_type_ref(node.type_ref) if node.type_ref else None
            if expected and not isinstance(expected, TypeVar):
                self._local_types[-1][node.name] = expected
                if node.initializer:
                    actual = self._infer(node.initializer)
                    diag = self.check_type_compatibility(actual, expected, node)
                    if diag is not None:
                        self._diagnostics.append(diag)
                return expected
            if node.initializer:
                actual = self._infer(node.initializer)
                self._local_types[-1][node.name] = actual
                return actual
            return TypeVar("?")
        if isinstance(node, IndexAssign):
            target_t = self._infer(node.obj) if node.obj else TypeVar("?")
            elem_t = target_t.element_type if isinstance(target_t, (TensorType, ListType)) else (target_t.value_type if isinstance(target_t, MapType) else TypeVar("?"))
            val_t = self._infer(node.value) if node.value else TypeVar("?")
            if not isinstance(elem_t, TypeVar) and not isinstance(val_t, TypeVar):
                diag = self.check_type_compatibility(val_t, elem_t, node)
                if diag is not None:
                    self._diagnostics.append(diag)
            return elem_t
        if isinstance(node, FieldAssign):
            val_t = self._infer(node.value) if node.value else TypeVar("?")
            return val_t
        if isinstance(node, ComptimeExpr):
            if node.body:
                return self._infer(node.body)
            return TypeVar("?")
        if isinstance(node, BlockStmt):
            self._local_types.append({})
            last_t = TypeVar("?")
            if node.body:
                for stmt in node.body:
                    last_t = self._infer(stmt)
            self._local_types.pop()
            return last_t
        if isinstance(node, ExpressionStmt):
            if node.expr:
                return self._infer(node.expr)
            return TypeVar("?")
        if isinstance(node, SpyExpr):
            if node.target:
                return self._infer(node.target)
            return TypeVar("?")
        if isinstance(node, PrintStmt):
            for arg in node.args:
                self._infer(arg)
            return TypeVar("?")
        if isinstance(node, IndexAccess):
            target_t = self._infer(node.obj) if node.obj else TypeVar("?")
            has_slice = any(isinstance(idx, SliceSpec) for idx in getattr(node, "indices", []))
            if has_slice:
                if isinstance(target_t, (MapType, SetType)):
                    self._diagnostics.append(Diagnostic(
                        code="SEM002", severity=Severity.ERROR,
                        line=_line(node), column=_col(node),
                        message=f"slice is not supported on type '{target_t}' (only list, string, and tensor)",
                    ))
                return target_t
            if isinstance(target_t, TensorType):
                return target_t.element_type
            if isinstance(target_t, ListType):
                return target_t.element_type
            if isinstance(target_t, MapType):
                return target_t.value_type
            if isinstance(target_t, PrimitiveType) and target_t.name in ("string", "str"):
                return PrimitiveType("char")
            if isinstance(target_t, PrimitiveType) and target_t.name == "data":
                return PrimitiveType("data")
            return TypeVar("?")
        return TypeVar("?")

    def _infer_literal(self, node: Literal) -> Type:
        vt = str(node.value_type).lower() if node.value_type else ""
        if vt in ("int", "int64"):
            return PrimitiveType("int64")
        if vt in ("float", "float64"):
            return PrimitiveType("float64")
        if vt in ("bool", "boolean"):
            return PrimitiveType("bool")
        if vt in ("string", "str"):
            return PrimitiveType("string")
        if vt in ("char", "chr"):
            return PrimitiveType("char")
        if vt.startswith("complex"):
            return PrimitiveType("complex128")
        return PrimitiveType(vt if vt else "string")

    def _infer_identifier(self, node: Identifier) -> Type:
        for scope in reversed(self._local_types):
            if node.name in scope:
                return scope[node.name]
        if self._symbol_table is not None:
            sym = self._symbol_table.resolve(node.name)
            if sym is not None:
                if sym.type_ref is not None:
                    if isinstance(sym.type_ref, Type):
                        return sym.type_ref
                    if isinstance(sym.type_ref, ASTNode) or hasattr(sym.type_ref, "name"):
                        return self._infer_type_ref(sym.type_ref)
                if getattr(sym, "decl_node", None) is not None:
                    decl = sym.decl_node
                    if isinstance(decl, StorageItem) and decl.type_ref:
                        return self._infer_type_ref(decl.type_ref)
        return TypeVar("?")

    def _infer_binary_op(self, node: BinaryOp) -> Type:
        if node.op == "ensure":
            return self._infer(node.left) if node.left else TypeVar("?")
        if node.op in ("==", "!=", "<", ">", "<=", ">="):
            if node.left:
                self._infer(node.left)
            if node.right:
                self._infer(node.right)
            return PrimitiveType("bool")
        if node.op in ("and", "or"):
            if node.left:
                self._infer(node.left)
            if node.right:
                self._infer(node.right)
            return PrimitiveType("bool")
        if node.op == "/f":
            if node.left:
                self._infer(node.left)
            if node.right:
                self._infer(node.right)
            return PrimitiveType("float64")
        if node.op == "/i":
            if node.left:
                self._infer(node.left)
            if node.right:
                self._infer(node.right)
            return PrimitiveType("int64")

        left = self._infer(node.left) if node.left else TypeVar("?")
        right = self._infer(node.right) if node.right else TypeVar("?")
        inferred = self._common_type(left, right)
        return inferred

    def _infer_unary_op(self, node: UnaryOp) -> Type:
        if node.op in ("not", "!"):
            if node.operand:
                self._infer(node.operand)
            return PrimitiveType("bool")
        if node.operand:
            return self._infer(node.operand)
        return TypeVar("?")

    def _infer_spawn(self, node: SpawnExpr) -> Type:
        if node.operand:
            return self._infer(node.operand)
        return TypeVar("?")

    def _infer_await(self, node: AwaitExpr) -> Type:
        if node.operand:
            return self._infer(node.operand)
        return TypeVar("?")

    def _infer_cast(self, node: CastExpr) -> Type:
        target = self._infer_type_ref(node.target_type) if node.target_type else TypeVar("?")
        actual = self._infer(node.expr) if node.expr else TypeVar("?")
        if not isinstance(target, TypeVar):
            diag = self.check_cast(actual, target, node)
            if diag is not None:
                self._diagnostics.append(diag)
        return target

    def _infer_call(self, node: CallExpr) -> Type:
        for arg in node.args:
            self._infer(arg)
        callee_type = self._infer(node.callee) if node.callee else None
        self._check_call_arity(node)
        if isinstance(callee_type, FunctionType):
            return callee_type.return_type or TypeVar("?")
        return TypeVar("?")

    def _check_call_arity(self, node: CallExpr) -> None:
        name = _call_callee_name(node)
        if not name or name in _SKIP_ARITY_CHECK:
            return
        if self._symbol_table is None:
            return
        sym = self._symbol_table.resolve(name)
        if sym is None:
            return
        if sym.kind not in (SymbolKind.FUNCTION, SymbolKind.OP):
            return
        decl = sym.decl_node
        param_count = _decl_param_count(decl)
        if param_count < 0:
            return
        arg_count = len(node.args)
        if arg_count != param_count:
            self._diagnostics.append(Diagnostic(
                code="SEM003", severity=Severity.ERROR,
                line=getattr(node, "line", 0), column=getattr(node, "column", 0),
                message=f"arity mismatch for '{name}': expected {param_count} args, got {arg_count}",
            ))

    def _infer_type_ref(self, node: ASTNode) -> Type:
        name = getattr(node, "name", "") or ""
        if name in _BUILTIN_TYPE_NAMES:
            return PrimitiveType(name)
        for prefix, cls in _COLLECTION_NAME_TO_TYPE.items():
            if name.startswith(prefix + " of "):
                elem_name = name[len(prefix) + 4:].strip()
                elem_type = PrimitiveType(elem_name) if elem_name in _BUILTIN_TYPE_NAMES else TypeVar(elem_name)
                return cls(elem_type)
            if name.startswith(prefix + "["):
                return cls(TypeVar("?"))
        if name.startswith("tensor"):
            m = re.match(r"tensor(?:\[|\()([0-9,\s]+)(?:\]|\))\s+of\s+(\w+)", name)
            if m:
                dims = [int(d) for d in m.group(1).split(",") if d.strip()]
                elem_type = PrimitiveType(m.group(2)) if m.group(2) in _BUILTIN_TYPE_NAMES else TypeVar(m.group(2))
                return TensorType(dims, elem_type)
            return TensorType([], TypeVar("?"))
        return TypeVar(name)

    def _common_type(self, a: Type, b: Type) -> Type:
        if not isinstance(a, PrimitiveType) or not isinstance(b, PrimitiveType):
            return a if not isinstance(a, TypeVar) else b
        if a.name == b.name:
            return a
        if a.name in _INT_TYPES and b.name in _INT_TYPES:
            order = ["int8", "int16", "int32", "int64"]
            ia = order.index(a.name) if a.name in order else -1
            ib = order.index(b.name) if b.name in order else -1
            return PrimitiveType(order[max(ia, ib)])
        if a.name in _UINT_TYPES and b.name in _UINT_TYPES:
            order = ["uint8", "uint16", "uint32", "uint64"]
            ia = order.index(a.name) if a.name in order else -1
            ib = order.index(b.name) if b.name in order else -1
            return PrimitiveType(order[max(ia, ib)])
        if a.name in _FLOAT_TYPES and b.name in _FLOAT_TYPES:
            order = ["float16", "float32", "float64"]
            ia = order.index(a.name) if a.name in order else -1
            ib = order.index(b.name) if b.name in order else -1
            return PrimitiveType(order[max(ia, ib)])
        if a.name in (_INT_TYPES | _UINT_TYPES) and b.name in _FLOAT_TYPES:
            return b
        if a.name in _FLOAT_TYPES and b.name in (_INT_TYPES | _UINT_TYPES):
            return a
        return a

    def check_type_compatibility(self, actual: Type, expected: Type, node: ASTNode) -> Diagnostic | None:
        if isinstance(actual, TypeVar) or isinstance(expected, TypeVar):
            return None
        if isinstance(actual, PrimitiveType) and isinstance(expected, PrimitiveType):
            return self._check_primitive_compat(actual, expected, node)
        if type(actual) is not type(expected):
            return self._make_type_mismatch(actual, expected, node)
        if isinstance(actual, StructType) and isinstance(expected, StructType):
            return self._check_struct_compat(actual, expected, node)
        if isinstance(actual, EnumType) and isinstance(expected, EnumType):
            return self._check_enum_compat(actual, expected, node)
        if isinstance(actual, TensorType) and isinstance(expected, TensorType):
            return self._check_tensor_compat(actual, expected, node)
        if isinstance(actual, FunctionType) and isinstance(expected, FunctionType):
            return self._check_function_compat(actual, expected, node)
        if isinstance(actual, ListType) and isinstance(expected, ListType):
            return self.check_type_compatibility(actual.element_type, expected.element_type, node)
        if isinstance(actual, SetType) and isinstance(expected, SetType):
            return self.check_type_compatibility(actual.element_type, expected.element_type, node)
        if isinstance(actual, MapType) and isinstance(expected, MapType):
            return self.check_type_compatibility(actual.value_type, expected.value_type, node)
        return self._make_type_mismatch(actual, expected, node)

    def _check_primitive_compat(self, actual: PrimitiveType, expected: PrimitiveType, node: ASTNode) -> Diagnostic | None:
        if actual.name == expected.name:
            return None
        if actual.name == "data" or expected.name == "data":
            return None
        # Complex compatibility
        complex_order = ["complex32", "complex64", "complex128"]
        if expected.name in complex_order:
            init_node = getattr(node, "initializer", node)
            if actual.name in _INT_TYPES | _UINT_TYPES | _FLOAT_TYPES or actual.name in complex_order:
                return None
            if isinstance(init_node, (Literal, BinaryOp)):
                return None
            return self._make_type_mismatch(actual, expected, node)
        # Check if node is an integer literal initializer that fits the expected integer range
        from flux_proto.semantic.storage_types import _INT_RANGES
        if expected.name in _INT_RANGES:
            init_node = getattr(node, "initializer", node)
            is_neg = False
            if isinstance(init_node, UnaryOp) and init_node.op == "-":
                is_neg = True
                init_node = init_node.operand
            if isinstance(init_node, Literal) and str(init_node.value_type).lower() in ("int", "int64", "uint", "uint64", "hex", "bin", "oct"):
                try:
                    val = int(init_node.value, 0) if isinstance(init_node.value, str) and init_node.value.startswith(("0x", "0b", "0o")) else int(init_node.value)
                    if is_neg:
                        val = -val
                    lo, hi = _INT_RANGES[expected.name]
                    if lo <= val <= hi:
                        return None
                except (ValueError, TypeError):
                    pass
        # Check if node is a float literal initializer for float types
        if expected.name in _FLOAT_TYPES:
            init_node = getattr(node, "initializer", node)
            if isinstance(init_node, UnaryOp) and init_node.op == "-":
                init_node = init_node.operand
            if isinstance(init_node, Literal) and str(init_node.value_type).lower() in ("float", "float64", "int", "int64"):
                return None
        if actual.name in _INT_TYPES and expected.name in _INT_TYPES:
            order = ["int8", "int16", "int32", "int64"]
            if order.index(actual.name) <= order.index(expected.name):
                return None
            return self._make_type_mismatch(actual, expected, node)
        if actual.name in _UINT_TYPES and expected.name in _UINT_TYPES:
            order = ["uint8", "uint16", "uint32", "uint64"]
            if order.index(actual.name) <= order.index(expected.name):
                return None
            return self._make_type_mismatch(actual, expected, node)
        if actual.name in _INT_TYPES | _UINT_TYPES and expected.name in _FLOAT_TYPES:
            return None
        if actual.name in _FLOAT_TYPES and expected.name in _FLOAT_TYPES:
            order = ["float16", "float32", "float64"]
            if actual.name in order and expected.name in order:
                if order.index(actual.name) <= order.index(expected.name):
                    return None
            return self._make_type_mismatch(actual, expected, node)
        return self._make_type_mismatch(actual, expected, node)

    def _check_struct_compat(self, actual: StructType, expected: StructType, node: ASTNode) -> Diagnostic | None:
        if actual.name != expected.name:
            return self._make_type_mismatch(actual, expected, node)
        for fn in actual.fields:
            if fn not in expected.fields:
                return self._make_type_mismatch(actual, expected, node)
            d = self.check_type_compatibility(actual.fields[fn], expected.fields[fn], node)
            if d is not None:
                return d
        return None

    def _check_enum_compat(self, actual: EnumType, expected: EnumType, node: ASTNode) -> Diagnostic | None:
        if actual.name != expected.name:
            return self._make_type_mismatch(actual, expected, node)
        return None

    def _check_tensor_compat(self, actual: TensorType, expected: TensorType, node: ASTNode) -> Diagnostic | None:
        if actual.shape and expected.shape and actual.shape != expected.shape:
            return Diagnostic(
                code="SEM001", severity=Severity.ERROR,
                line=_line(node), column=_col(node),
                message=f"tensor shape mismatch: expected {expected.shape}, got {actual.shape}",
            )
        return self.check_type_compatibility(actual.element_type, expected.element_type, node)

    def _check_function_compat(self, actual: FunctionType, expected: FunctionType, node: ASTNode) -> Diagnostic | None:
        if len(actual.params) != len(expected.params):
            return self._make_type_mismatch(actual, expected, node)
        for i, (ap, ep) in enumerate(zip(actual.params, expected.params)):
            d = self.check_type_compatibility(ap, ep, node)
            if d is not None:
                return d
        return self.check_type_compatibility(actual.return_type, expected.return_type, node)

    def check_tensor_indices(self, tensor_type: TensorType, index_count: int, node: ASTNode) -> Diagnostic | None:
        if tensor_type.shape:
            expected = len(tensor_type.shape)
            if index_count != expected:
                return Diagnostic(
                    code="SEM001", severity=Severity.ERROR,
                    line=_line(node), column=_col(node),
                    message=f"tensor requires {expected} indices, got {index_count}",
                )
        return None

    def check_cast(self, actual: Type, target: Type, node: ASTNode) -> Diagnostic | None:
        if isinstance(actual, TypeVar) or isinstance(target, TypeVar):
            return None
        if isinstance(actual, (ListType, SetType)) and isinstance(target, (ListType, SetType)):
            return None
        if (isinstance(actual, PrimitiveType) and actual.name == "data") or (isinstance(target, PrimitiveType) and target.name == "data"):
            return None
        if isinstance(actual, PrimitiveType) and isinstance(target, PrimitiveType):
            if actual.name == target.name:
                return None
            if is_numeric_type(actual) and is_numeric_type(target):
                return None
            if is_numeric_type(actual) and target.name == "string":
                return None
            if (actual.name, target.name) in _ALLOWED_CASTS:
                return None
            return Diagnostic(
                code="SEM001", severity=Severity.ERROR,
                line=_line(node), column=_col(node),
                message=f"invalid cast from '{type_name(actual)}' to '{type_name(target)}'",
            )
        return Diagnostic(
            code="SEM001", severity=Severity.ERROR,
            line=_line(node), column=_col(node),
            message=f"invalid cast from '{type_name(actual)}' to '{type_name(target)}'",
        )

    def diagnostics(self) -> list[Diagnostic]:
        return list(self._diagnostics)

    def _make_type_mismatch(self, actual: Type, expected: Type, node: ASTNode) -> Diagnostic:
        return Diagnostic(
            code="SEM001", severity=Severity.ERROR,
            line=_line(node), column=_col(node),
            message=f"type mismatch: expected '{type_name(expected)}', got '{type_name(actual)}'",
        )


def _line(node: ASTNode) -> int:
    return getattr(node, "line", 0)


def _col(node: ASTNode) -> int:
    return getattr(node, "column", 0)
