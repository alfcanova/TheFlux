from __future__ import annotations

from dataclasses import dataclass, field
from typing import Any

from flux_proto.parser.ast import ASTNode


@dataclass
class SemanticAnnotation:
    resolved_type: Any = None
    symbol: Any = None
    ownership_before: dict[str, Any] | None = None
    ownership_after: dict[str, Any] | None = None
    diagnostics: list = field(default_factory=list)


class ASTDecorator:
    def __init__(self) -> None:
        self._annotations: dict[int, SemanticAnnotation] = {}

    def annotate(self, node: ASTNode) -> SemanticAnnotation:
        node_id = id(node)
        if node_id not in self._annotations:
            self._annotations[node_id] = SemanticAnnotation()
        return self._annotations[node_id]

    def get_annotation(self, node: ASTNode) -> SemanticAnnotation | None:
        return self._annotations.get(id(node))

    def get_resolved_type(self, node: ASTNode) -> Any:
        ann = self.get_annotation(node)
        return ann.resolved_type if ann else None

    def set_resolved_type(self, node: ASTNode, t: Any) -> None:
        self.annotate(node).resolved_type = t

    def get_symbol(self, node: ASTNode) -> Any:
        ann = self.get_annotation(node)
        return ann.symbol if ann else None

    def set_symbol(self, node: ASTNode, sym: Any) -> None:
        self.annotate(node).symbol = sym

    def add_diagnostic(self, node: ASTNode, diag: Any) -> None:
        self.annotate(node).diagnostics.append(diag)

    def get_diagnostics(self, node: ASTNode) -> list:
        ann = self.get_annotation(node)
        return list(ann.diagnostics) if ann else []

    def all_diagnostics(self) -> list:
        result: list = []
        for ann in self._annotations.values():
            result.extend(ann.diagnostics)
        return result

    def set_ownership_before(self, node: ASTNode, state: dict[str, Any]) -> None:
        self.annotate(node).ownership_before = state

    def set_ownership_after(self, node: ASTNode, state: dict[str, Any]) -> None:
        self.annotate(node).ownership_after = state
