from __future__ import annotations

import re

from flux_proto.parser.ast import ASTNode, FluxProgram, FdslFile, StorageDecl, StorageItem, Literal, UnaryOp
from flux_proto.semantic.diagnostic import Diagnostic, Severity
from flux_proto.semantic.symbol_table import SymbolKind, SymbolTable
from flux_proto.semantic.types import _BUILTIN_TYPE_NAMES


_INT_RANGES: dict[str, tuple[int, int]] = {
    "int8": (-(2 ** 7), 2 ** 7 - 1),
    "int16": (-(2 ** 15), 2 ** 15 - 1),
    "int32": (-(2 ** 31), 2 ** 31 - 1),
    "int64": (-(2 ** 63), 2 ** 63 - 1),
    "uint8": (0, 2 ** 8 - 1),
    "uint16": (0, 2 ** 16 - 1),
    "uint32": (0, 2 ** 32 - 1),
    "uint64": (0, 2 ** 64 - 1),
}

_FLOAT_TYPES = {
    "float16", "float32", "float64",
    "fp8_e4m3", "fp8_e5m2", "bf16_e8m7", "tf32_e8m10",
}

_COMPLEX_TYPES = {"complex32", "complex64", "complex128"}

_COLLECTION_TYPES = {"list", "set", "map", "data"}


def check_storage_types(ast: ASTNode, st: SymbolTable) -> list[Diagnostic]:
    diags: list[Diagnostic] = []
    for sd in _collect_storages(ast):
        for item in sd.items:
            _check_storage_item(item, st, diags)
    return diags


def _collect_storages(ast: ASTNode):
    from flux_proto.semantic.mutability import _walk_nodes
    return _walk_nodes(ast, StorageDecl)


def _check_storage_item(item: StorageItem, st: SymbolTable, diags: list[Diagnostic]) -> None:
    type_ref = item.type_ref
    name = getattr(type_ref, "name", "") or ""
    if not name:
        return

    base = _collection_base(name)
    if base is not None:
        _check_collection_item(item, name, base, diags)
        return

    if name in _INT_RANGES:
        _check_int_range(item, name, diags)
        return

    if name in _FLOAT_TYPES or name in _COMPLEX_TYPES or name in ("char", "string", "bool", "datetime"):
        return

    if name.startswith("string("):
        _check_string_cap(item, name, diags)
        return

    if name.startswith("tensor"):
        _check_tensor_item(item, name, st, diags)
        return

    sym = st.resolve(name)
    if sym is None or sym.kind not in (SymbolKind.STRUCT, SymbolKind.ENUM):
        diags.append(
            Diagnostic(
                code="SEM001",
                severity=Severity.ERROR,
                line=getattr(item, "line", 0),
                column=getattr(item, "column", 0),
                message=f"unknown type '{name}' in declaration of '{item.name}'",
            )
        )


def _collection_base(name: str) -> str | None:
    for prefix in ("list of ", "set of ", "map of "):
        if name.startswith(prefix):
            return prefix[:-4]
    if name in _COLLECTION_TYPES:
        return name
    return None


def _check_collection_item(item: StorageItem, name: str, base: str, diags: list[Diagnostic]) -> None:
    if base in ("list", "set"):
        elem = name[len(base) + 4:]
        if elem not in _BUILTIN_TYPE_NAMES and _collection_base(elem) is None:
            diags.append(
                Diagnostic(
                    code="SEM001",
                    severity=Severity.ERROR,
                    line=getattr(item, "line", 0),
                    column=getattr(item, "column", 0),
                    message=f"unknown element type '{elem}' in '{name}' declaration of '{item.name}'",
                )
            )


def _check_tensor_item(item: StorageItem, name: str, st: SymbolTable, diags: list[Diagnostic]) -> None:
    match = re.match(r"tensor\[([0-9,\s]+)\] of (\w+)", name)
    if match is None:
        diags.append(
            Diagnostic(
                code="SEM001",
                severity=Severity.ERROR,
                line=getattr(item, "line", 0),
                column=getattr(item, "column", 0),
                message=f"invalid tensor type '{name}' in declaration of '{item.name}': "
                        f"expected 'tensor[<dim1>, <dim2>, ...] of <tipo>' with static dimensions",
            )
        )
        return
    dims = [int(d) for d in match.group(1).split(",") if d.strip()]
    if not dims or any(d <= 0 for d in dims):
        diags.append(
            Diagnostic(
                code="SEM001",
                severity=Severity.ERROR,
                line=getattr(item, "line", 0),
                column=getattr(item, "column", 0),
                message=f"tensor dimensions must be positive integers in declaration of '{item.name}'",
            )
        )
        return
    elem = match.group(2)
    if elem not in _BUILTIN_TYPE_NAMES:
        diags.append(
            Diagnostic(
                code="SEM001",
                severity=Severity.ERROR,
                line=getattr(item, "line", 0),
                column=getattr(item, "column", 0),
                message=f"unknown tensor element type '{elem}' in declaration of '{item.name}'",
            )
        )


def _check_string_cap(item: StorageItem, name: str, diags: list[Diagnostic]) -> None:
    match = re.match(r"string\((\d+)\)", name)
    if match is None:
        diags.append(
            Diagnostic(
                code="SEM001",
                severity=Severity.ERROR,
                line=getattr(item, "line", 0),
                column=getattr(item, "column", 0),
                message=f"invalid string type '{name}' in declaration of '{item.name}': "
                        f"expected 'string(<tamanho>)' with a positive size in bytes",
            )
        )
        return
    cap = int(match.group(1))
    if cap <= 0:
        diags.append(
            Diagnostic(
                code="SEM001",
                severity=Severity.ERROR,
                line=getattr(item, "line", 0),
                column=getattr(item, "column", 0),
                message=f"string capacity must be positive in declaration of '{item.name}'",
            )
        )
        return
    init = item.initializer
    if init is None:
        return
    if isinstance(init, UnaryOp):
        init = init.operand
    if not isinstance(init, Literal) or init.value_type not in ("STRING", "CHAR"):
        return
    size = len(init.value.encode("utf-8"))
    if size > cap:
        diags.append(
            Diagnostic(
                code="SEM001",
                severity=Severity.ERROR,
                line=getattr(item, "line", 0),
                column=getattr(item, "column", 0),
                message=f"string literal of {size} bytes exceeds capacity {cap} of '{item.name}'",
            )
        )


def _check_int_range(item: StorageItem, type_name: str, diags: list[Diagnostic]) -> None:
    init = item.initializer
    if init is None:
        return
    negative = False
    if isinstance(init, UnaryOp) and init.op == "-":
        negative = True
        init = init.operand
    if not isinstance(init, Literal) or init.value_type not in ("INT", "FLOAT"):
        return
    try:
        value = float(init.value) if init.value_type == "FLOAT" else int(init.value)
    except ValueError:
        return
    if init.value_type == "FLOAT":
        return
    if negative:
        value = -value
    lo, hi = _INT_RANGES[type_name]
    if value < lo or value > hi:
        diags.append(
            Diagnostic(
                code="SEM001",
                severity=Severity.ERROR,
                line=getattr(item, "line", 0),
                column=getattr(item, "column", 0),
                message=f"value {value} is out of range for '{type_name}' in declaration of '{item.name}' "
                        f"(allowed {lo}..{hi})",
            )
        )
