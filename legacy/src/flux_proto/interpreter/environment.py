from __future__ import annotations

from dataclasses import dataclass, field
from typing import Any

from flux_proto.parser.ast import FunctionDef, StructDef, EnumDef


def _fset_key(x: Any) -> Any:
    if hasattr(x, "data") and not isinstance(x, (dict, list, tuple)):
        x = x.data
    if isinstance(x, (list, tuple)):
        return tuple(_fset_key(i) for i in x)
    if isinstance(x, dict) and not isinstance(x, FSet):
        return tuple(sorted((k, _fset_key(v)) for k, v in x.items()))
    return x


class FSet(dict):
    """Insertion-ordered set backed by a dict (dedup: first occurrence wins)."""
    def __init__(self, *args, **kwargs):
        if args and not kwargs:
            arg = args[0]
            if isinstance(arg, (dict, FSet)):
                super().__init__({_fset_key(k): v for k, v in arg.items()})
            else:
                super().__init__({_fset_key(k): None for k in arg})
        else:
            super().__init__(*args, **kwargs)

    @classmethod
    def fromkeys(cls, iterable, value=None):
        return cls({_fset_key(k): value for k in iterable})

    def __contains__(self, key: Any) -> bool:
        return super().__contains__(_fset_key(key))


DEFAULT_VALUES: dict[str, Any] = {
    "int64": 0, "int32": 0, "int16": 0, "int8": 0,
    "uint64": 0, "uint32": 0, "uint16": 0, "uint8": 0,
    "float64": 0.0, "float32": 0.0, "float16": 0.0,
    "fp8_e4m3": 0.0, "fp8_e5m2": 0.0,
    "bf16_e8m7": 0.0, "tf32_e8m10": 0.0,
    "complex32": 0j, "complex64": 0j, "complex128": 0j,
    "bool": False,
    "datetime": 0,
    "char": "\0",
    "string": "",
    "list": [], "set": FSet(), "map": {}, "data": [],
    "none": None,
}


@dataclass
class Value:
    type_name: str = ""
    data: Any = None
    message: str = ""
    value_type: str = ""


class Environment:
    def __init__(self) -> None:
        self._scopes: list[dict[str, Value]] = [{}]
        self._functions: dict[str, FunctionDef] = {}
        self._structs: dict[str, StructDef] = {}
        self._enums: dict[str, EnumDef] = {}

    def enter_scope(self) -> None:
        self._scopes.append({})

    def exit_scope(self) -> None:
        if len(self._scopes) > 1:
            self._scopes.pop()

    def declare(self, name: str, value: Value) -> None:
        self._scopes[-1][name] = value

    def declare_global(self, name: str, value: Value) -> None:
        self._scopes[0][name] = value

    def set(self, name: str, value: Value) -> bool:
        for scope in reversed(self._scopes):
            if name in scope:
                scope[name] = value
                return True
        return False

    def get(self, name: str) -> Value | None:
        for scope in reversed(self._scopes):
            if name in scope:
                return scope[name]
        return None

    def register_function(self, func: FunctionDef) -> None:
        self._functions[func.name] = func

    def get_function(self, name: str) -> FunctionDef | None:
        return self._functions.get(name)

    def register_struct(self, struct: StructDef) -> None:
        self._structs[struct.name] = struct

    def get_struct(self, name: str) -> StructDef | None:
        return self._structs.get(name)

    def register_enum(self, enum: EnumDef) -> None:
        self._enums[enum.name] = enum

    def get_enum(self, name: str) -> EnumDef | None:
        return self._enums.get(name)

    def has(self, name: str) -> bool:
        return self.get(name) is not None
