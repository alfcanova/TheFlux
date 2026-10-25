from dataclasses import dataclass, field
from enum import Enum, auto


class Severity(Enum):
    ERROR = auto()
    WARNING = auto()
    SUGGESTION = auto()


@dataclass
class SourceLocation:
    line: int
    column: int
    file: str | None = None


@dataclass
class Diagnostic:
    code: str
    severity: Severity
    line: int
    column: int
    message: str
    related: list[SourceLocation] = field(default_factory=list)
    mnemonic: str | None = None
    hint: str | None = None


class DiagnosticFormatter:
    @staticmethod
    def format(d: Diagnostic, file: str = "<unknown>") -> str:
        mnem = f" - {d.mnemonic}" if d.mnemonic else ""
        loc = f" (linha {d.line}, coluna {d.column})" if (d.line > 0 or d.column > 0) else ""
        base = f"{file}:{d.line},{d.column} -> [{d.code}{mnem}]: {d.message}{loc}"
        if d.hint:
            base += f"\n  💡 Dica: {d.hint}"
        for rel in d.related:
            rf = rel.file or file
            base += f"\n  --> {rf}:{rel.line},{rel.column}"
        return base

    @staticmethod
    def format_all(diags: list[Diagnostic], file: str = "<unknown>") -> str:
        return "\n".join(DiagnosticFormatter.format(d, file) for d in diags)

    @staticmethod
    def severity_label(s: Severity) -> str:
        return {Severity.ERROR: "error", Severity.WARNING: "warning", Severity.SUGGESTION: "suggestion"}[s]
