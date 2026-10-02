from __future__ import annotations

import sys
from typing import Any


def runtime_backend() -> str:
    return "in"


def runtime_compiler_version() -> str:
    return "0.8.0-dev"


def runtime_get_args() -> list[str]:
    return list(sys.argv[1:]) if len(sys.argv) > 1 else []


def runtime_executable_path() -> str:
    return sys.executable or "theflux"


def runtime_get_type_name(val: Any) -> str:
    if hasattr(val, "type_name"):
        tn = val.type_name
        if tn in ("int", "i64"):
            return "int64"
        if tn in ("float", "f64"):
            return "float64"
        if tn in ("str",):
            return "string"
        return tn
    if isinstance(val, bool):
        return "bool"
    if isinstance(val, int):
        return "int64"
    if isinstance(val, float):
        return "float64"
    if isinstance(val, str):
        return "string"
    if isinstance(val, list):
        return "list"
    if isinstance(val, set):
        return "set"
    if isinstance(val, dict):
        return "map"
    return "data"


def runtime_allocated_memory() -> int:
    return 1024


def runtime_heap_size() -> int:
    return 65536


def runtime_pointer_of(val: Any) -> int:
    if hasattr(val, "data"):
        return id(val.data) & 0x7FFFFFFFFFFFFFFF
    return id(val) & 0x7FFFFFFFFFFFFFFF


def runtime_panic(message: str) -> bool:
    print(f"FLUX RUNTIME PANIC: {message}", file=sys.stderr)
    sys.exit(1)


def runtime_trap() -> bool:
    sys.exit(134)


def runtime_stack_trace() -> list[str]:
    return ["main", "runtimeStackTrace"]
