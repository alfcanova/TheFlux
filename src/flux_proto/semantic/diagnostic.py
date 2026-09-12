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


class DiagnosticFormatter:
    @staticmethod
    def format(d: Diagnostic, file: str = "<unknown>") -> str:
        base = f"{file}:{d.line},{d.column} -> [{d.code}]: {d.message}"
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
