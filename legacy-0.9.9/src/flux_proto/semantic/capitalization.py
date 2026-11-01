from __future__ import annotations

import re

from flux_proto.semantic.diagnostic import Diagnostic, Severity
from flux_proto.semantic.symbol_table import (
    CapitalizationKind,
    Symbol,
    SymbolTable,
)


_PATTERNS: dict[CapitalizationKind, re.Pattern] = {
    CapitalizationKind.SNAKE: re.compile(r"^[a-z][a-z0-9]*(_[a-z0-9]+)*$"),
    CapitalizationKind.SCREAMING_SNAKE: re.compile(r"^[A-Z][A-Z0-9]*(_[A-Z0-9]+)*$"),
    CapitalizationKind.CAMEL: re.compile(r"^[a-z][a-zA-Z0-9]*$"),
    CapitalizationKind.PASCAL: re.compile(r"^[A-Z][a-zA-Z0-9]*$"),
}


def validate_capitalization(st: SymbolTable) -> list[Diagnostic]:
    diags: list[Diagnostic] = []
    for sym in st.all_symbols():
        d = _check_symbol(sym)
        if d is not None:
            diags.append(d)
    return diags


def _check_symbol(sym: Symbol) -> Diagnostic | None:
    cap = sym.capitalization
    if cap is None or cap == CapitalizationKind.WILDCARD:
        return None
    pattern = _PATTERNS.get(cap)
    if pattern is None:
        return None
    if pattern.match(sym.name):
        return None
    suggested = _suggest_case(sym.name, cap)
    node = sym.decl_node
    diag = Diagnostic(
        code="SUG",
        severity=Severity.SUGGESTION,
        line=getattr(node, "line", 0),
        column=getattr(node, "column", 0),
        message=(
            f"'{sym.name}' should use "
            f"{_case_label(cap)}: '{suggested}'"
        ),
    )
    return diag


def _case_label(kind: CapitalizationKind) -> str:
    return {
        CapitalizationKind.SNAKE: "snake_case",
        CapitalizationKind.SCREAMING_SNAKE: "SCREAMING_SNAKE",
        CapitalizationKind.CAMEL: "camelCase",
        CapitalizationKind.PASCAL: "PascalCase",
    }.get(kind, str(kind))


def _suggest_case(name: str, kind: CapitalizationKind) -> str:
    words = _split_words(name)
    if kind == CapitalizationKind.SNAKE:
        return "_".join(w.lower() for w in words)
    if kind == CapitalizationKind.SCREAMING_SNAKE:
        return "_".join(w.upper() for w in words)
    if kind == CapitalizationKind.CAMEL:
        if not words:
            return name
        return words[0].lower() + "".join(w.capitalize() for w in words[1:])
    if kind == CapitalizationKind.PASCAL:
        return "".join(w.capitalize() for w in words)
    return name


def _split_words(name: str) -> list[str]:
    if "_" in name:
        return [w for w in name.split("_") if w]
    result: list[str] = []
    buf = []
    for ch in name:
        if ch.isupper() and buf:
            result.append("".join(buf))
            buf = [ch]
        else:
            buf.append(ch)
    if buf:
        result.append("".join(buf))
    return result or [name]
