from __future__ import annotations

from dataclasses import dataclass, field
from enum import Enum, auto
from typing import Any

from flux_proto.parser.ast import ASTNode
from flux_proto.semantic.diagnostic import Diagnostic, Severity, SourceLocation


class ScopeKind(Enum):
    GLOBAL = auto()
    FUNCTION = auto()
    BLOCK = auto()
    LOOP = auto()
    ROUTE_ARM = auto()
    MATCH_ARM = auto()
    AGENT = auto()
    UNSAFE = auto()


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
    SNAKE = auto()
    SCREAMING_SNAKE = auto()
    CAMEL = auto()
    PASCAL = auto()
    WILDCARD = auto()


@dataclass
class Symbol:
    name: str
    kind: SymbolKind
    decl_node: ASTNode
    type_ref: Any = None
    mutable: bool = True
    capitalization: CapitalizationKind | None = None
    initialized: bool = False
    module_path: str | None = None


@dataclass
class Scope:
    parent: Scope | None
    symbols: dict[str, Symbol]
    kind: ScopeKind


@dataclass
class ImportBinding:
    source_path: str
    alias: str


class SymbolTable:
    def __init__(self) -> None:
        self._global = Scope(parent=None, symbols={}, kind=ScopeKind.GLOBAL)
        self._scope_stack: list[Scope] = [self._global]
        self._imports: dict[str, ImportBinding] = {}
        self._diagnostics: list[Diagnostic] = []

    def enter_scope(self, kind: ScopeKind) -> Scope:
        new_scope = Scope(parent=self.current_scope, symbols={}, kind=kind)
        self._scope_stack.append(new_scope)
        return new_scope

    def exit_scope(self) -> Scope | None:
        if len(self._scope_stack) <= 1:
            return None
        return self._scope_stack.pop()

    @property
    def current_scope(self) -> Scope:
        return self._scope_stack[-1]

    def declare(self, name: str, kind: SymbolKind, node: ASTNode, mutable: bool = True, type_ref: Any = None) -> Symbol | Diagnostic:
        scope = self.current_scope
        if name in scope.symbols:
            existing = scope.symbols[name]
            diag = Diagnostic(
                code="SEM001", severity=Severity.ERROR,
                line=_line_of(node), column=_col_of(node),
                message=f"Duplicate declaration of '{name}'",
                related=[SourceLocation(line=getattr(existing.decl_node, 'line', 0), column=0)]
            )
            return diag
        cap = _capitalization_for(kind)
        sym = Symbol(
            name=name, kind=kind, decl_node=node,
            type_ref=type_ref, mutable=mutable, capitalization=cap
        )
        scope.symbols[name] = sym
        return sym

    def resolve(self, name: str) -> Symbol | None:
        if name in self._imports:
            binding = self._imports[name]
            for sym in self._walk_all_symbols():
                if sym.module_path and binding.source_path in sym.module_path:
                    return sym
        for scope in reversed(self._scope_stack):
            if name in scope.symbols:
                return scope.symbols[name]
        return None

    def resolve_qualified(self, parts: list[str]) -> Symbol | None:
        if len(parts) < 2:
            return None
        agent_name = parts[0]
        op_name = parts[1]
        agent_sym = self.resolve(agent_name)
        if agent_sym is None:
            return None
        if agent_sym.kind != SymbolKind.AGENT:
            return None
        for scope in reversed(self._scope_stack):
            if op_name in scope.symbols:
                sym = scope.symbols[op_name]
                if sym.kind == SymbolKind.OP:
                    return sym
        return None

    def add_import(self, alias: str, source_path: str) -> Diagnostic | None:
        if alias in self.current_scope.symbols:
            return Diagnostic(
                code="SEM001", severity=Severity.ERROR,
                line=0, column=0,
                message=f"Duplicate import alias '{alias}'"
            )
        self._imports[alias] = ImportBinding(source_path=source_path, alias=alias)
        sym = Symbol(name=alias, kind=SymbolKind.TYPE_ALIAS, decl_node=None)
        self.current_scope.symbols[alias] = sym
        return None

    def diagnostics(self) -> list[Diagnostic]:
        return self._diagnostics + [d for d in self._collect_diagnostics()]

    def _collect_diagnostics(self) -> list[Diagnostic]:
        return []

    def all_symbols(self) -> list[Symbol]:
        result: list[Symbol] = []
        for scope in self._scope_stack:
            result.extend(scope.symbols.values())
        return result

    def _walk_all_symbols(self) -> list[Symbol]:
        return self.all_symbols()


def _line_of(node: ASTNode) -> int:
    return getattr(node, "line", 0)


def _col_of(node: ASTNode) -> int:
    return getattr(node, "column", 0)


def _capitalization_for(kind: SymbolKind) -> CapitalizationKind:
    mapping = {
        SymbolKind.VARIABLE: CapitalizationKind.SNAKE,
        SymbolKind.CONSTANT: CapitalizationKind.SCREAMING_SNAKE,
        SymbolKind.FUNCTION: CapitalizationKind.CAMEL,
        SymbolKind.OP: CapitalizationKind.CAMEL,
        SymbolKind.STRUCT: CapitalizationKind.CAMEL,
        SymbolKind.ENUM: CapitalizationKind.PASCAL,
        SymbolKind.AGENT: CapitalizationKind.PASCAL,
        SymbolKind.CONTRACT: CapitalizationKind.PASCAL,
        SymbolKind.MACRO: CapitalizationKind.CAMEL,
        SymbolKind.TYPE_ALIAS: CapitalizationKind.WILDCARD,
    }
    return mapping.get(kind, CapitalizationKind.WILDCARD)
