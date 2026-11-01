"""TheFlux Diagnostic Catalog Engine.

Provides zero-latency, in-memory O(1) diagnostic resolution, error catalog
lookups, and diagnostic factory methods.
"""
from __future__ import annotations

from dataclasses import dataclass, field
from typing import Any

from flux_proto.semantic.diagnostic import Diagnostic, Severity, SourceLocation


@dataclass(frozen=True)
class DiagnosticDef:
    code: str
    mnemonic: str
    category: str
    severity: str
    trigger: str
    message: str
    hint: str = ""
    example_bad: str = ""
    example_good: str = ""
    expected_type: str | None = None
    actual_type: str | None = None
    yaml_file: str = ""


# Try importing generated catalog_data; fall back to empty dicts if not yet generated.
try:
    from flux_proto.diagnostics.catalog_data import (
        ERRORS_BY_CODE,
        ERRORS_BY_MNEMONIC,
        TYPE_MISMATCH_MATRIX,
    )
except ImportError:
    ERRORS_BY_CODE: dict[str, DiagnosticDef] = {}
    ERRORS_BY_MNEMONIC: dict[str, DiagnosticDef] = {}
    TYPE_MISMATCH_MATRIX: dict[tuple[str, str], DiagnosticDef] = {}


def _normalize_type_category(t: str) -> str:
    """Normalizes specific type names to broad categories for mismatch lookup."""
    t = t.strip().lower()
    if t.startswith(("int", "uint")):
        return "int"
    if t.startswith("float"):
        return "float"
    if t.startswith("complex"):
        return "complex"
    if t in ("str", "string"):
        return "string"
    if t in ("bool", "boolean"):
        return "bool"
    if t.startswith("tensor"):
        return "tensor"
    if t.startswith("list"):
        return "list"
    if t.startswith("set"):
        return "set"
    if t.startswith("map"):
        return "map"
    return t


def get_diagnostic_def(key: str) -> DiagnosticDef | None:
    """Looks up a diagnostic definition by its code or mnemonic."""
    if not key:
        return None
    key_upper = key.strip().upper()
    return ERRORS_BY_CODE.get(key_upper) or ERRORS_BY_MNEMONIC.get(key_upper)


def get_type_mismatch_def(expected: str, actual: str) -> DiagnosticDef | None:
    """Looks up a specific type mismatch diagnostic from the AOT mismatch matrix."""
    exp_norm = _normalize_type_category(expected)
    act_norm = _normalize_type_category(actual)
    return TYPE_MISMATCH_MATRIX.get((exp_norm, act_norm))


def create_type_mismatch_diagnostic(
    expected: str,
    actual: str,
    line: int,
    column: int,
    related: list[SourceLocation] | None = None,
) -> Diagnostic:
    """Creates a canonical Diagnostic for a type mismatch.
    
    Resolves directional mismatch (e.g. expected int, got float -> TYP401;
    expected complex, got int -> TYP411).
    Falls back to generic TYP499 if not specifically mapped.
    """
    defn = get_type_mismatch_def(expected, actual)
    if defn:
        return Diagnostic(
            code=defn.code,
            severity=Severity.ERROR,
            line=line,
            column=column,
            message=defn.message,
            related=related or [],
            mnemonic=defn.mnemonic,
            hint=defn.hint,
        )
    # Generic fallback
    return Diagnostic(
        code="TYP499",
        severity=Severity.ERROR,
        line=line,
        column=column,
        message=f"Incompatibilidade de tipos: esperava '{expected}', mas recebeu '{actual}'",
        related=related or [],
        mnemonic="TYPE_MISMATCH_GENERIC",
        hint="Verifique a compatibilidade dos tipos ou utilize conversão explícita.",
    )


def create_diagnostic(
    code_or_mnemonic: str,
    line: int,
    column: int,
    custom_msg: str | None = None,
    related: list[SourceLocation] | None = None,
    hint: str | None = None,
) -> Diagnostic:
    """Creates a canonical Diagnostic from code or mnemonic."""
    defn = get_diagnostic_def(code_or_mnemonic)
    if defn:
        sev = Severity.ERROR
        if defn.severity.lower() == "warning":
            sev = Severity.WARNING
        elif defn.severity.lower() == "suggestion":
            sev = Severity.SUGGESTION
        return Diagnostic(
            code=defn.code,
            severity=sev,
            line=line,
            column=column,
            message=custom_msg or defn.message,
            related=related or [],
            mnemonic=defn.mnemonic,
            hint=hint if hint is not None else defn.hint,
        )
    return Diagnostic(
        code=code_or_mnemonic,
        severity=Severity.ERROR,
        line=line,
        column=column,
        message=custom_msg or "Erro de compilação não catalogado",
        related=related or [],
    )
