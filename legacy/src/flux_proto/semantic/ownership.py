from __future__ import annotations

from enum import Enum
from copy import deepcopy

from flux_proto.parser.ast import (
    ASTNode, OwnershipExpr, ExpressionStmt, BlockStmt,
    RouteStmt, RouteArm, MatchStmt, MatchArm, MatchExpr,
    UnsafeStmt, VariableReassign, CallExpr, Identifier,
    InfiniteStmt, BreakStmt, ContinueStmt, EmitStmt,
)
from flux_proto.semantic.diagnostic import Diagnostic, Severity, SourceLocation


class OwnershipState(Enum):
    OWNED = "owned"
    MOVED = "moved"
    BORROWED = "borrowed"
    BORROWED_MUT = "borrowed_mut"
    KEPT = "kept"


_MOVE_OPS = {"move"}
_BORROW_OPS = {"borrow"}
_BORROW_MUT_OPS = {"borrow_mut"}
_KEEP_OPS = {"keep"}

StateDict = dict[str, OwnershipState]


class OwnershipTracker:
    def initial_state(self, var_names: list[str]) -> StateDict:
        return {name: OwnershipState.OWNED for name in var_names}

    def track_ownership(
        self, state: StateDict, stmt: ASTNode
    ) -> tuple[StateDict, list[Diagnostic]]:
        diags: list[Diagnostic] = []

        if isinstance(stmt, OwnershipExpr):
            return self._track_ownership_expr(state, stmt)

        if isinstance(stmt, UnsafeStmt):
            return self._track_unsafe(state, stmt)

        if isinstance(stmt, RouteStmt):
            return self._track_route(state, stmt, diags)

        if isinstance(stmt, MatchStmt):
            return self._track_match(state, stmt, diags)

        if isinstance(stmt, BlockStmt):
            return self._track_block(state, stmt, diags)

        if isinstance(stmt, VariableReassign):
            return self._track_reassign(state, stmt)

        if isinstance(stmt, CallExpr):
            return self._track_call(state, stmt)

        if isinstance(stmt, ExpressionStmt):
            return self._track_expression(state, stmt, diags)

        if isinstance(stmt, (InfiniteStmt, BreakStmt, ContinueStmt)):
            return deepcopy(state), diags

        if isinstance(stmt, EmitStmt):
            return deepcopy(state), diags

        return deepcopy(state), diags

    def _track_ownership_expr(
        self, state: StateDict, stmt: OwnershipExpr
    ) -> tuple[StateDict, list[Diagnostic]]:
        diags: list[Diagnostic] = []
        new_state = deepcopy(state)
        target = stmt.target
        if not target or target not in new_state:
            return new_state, diags

        current = new_state[target]
        op = stmt.op

        if op in _MOVE_OPS:
            if current in (OwnershipState.MOVED, OwnershipState.BORROWED, OwnershipState.BORROWED_MUT):
                diag = Diagnostic(
                    code="SEM001", severity=Severity.ERROR,
                    line=_line_of(stmt), column=_col_of(stmt),
                    message=f"cannot move '{target}': {current.value}",
                )
                diags.append(diag)
            new_state[target] = OwnershipState.MOVED

        elif op in _BORROW_MUT_OPS:
            if current != OwnershipState.OWNED:
                diag = Diagnostic(
                    code="SEM001", severity=Severity.ERROR,
                    line=_line_of(stmt), column=_col_of(stmt),
                    message=f"cannot borrow_mut '{target}': {current.value}",
                )
                diags.append(diag)
            new_state[target] = OwnershipState.BORROWED_MUT

        elif op in _BORROW_OPS:
            if current == OwnershipState.MOVED:
                diag = Diagnostic(
                    code="SEM001", severity=Severity.ERROR,
                    line=_line_of(stmt), column=_col_of(stmt),
                    message=f"cannot borrow '{target}': {current.value}",
                )
                diags.append(diag)
            elif current == OwnershipState.BORROWED_MUT:
                diag = Diagnostic(
                    code="SEM001", severity=Severity.ERROR,
                    line=_line_of(stmt), column=_col_of(stmt),
                    message=f"cannot borrow '{target}': borrowed_mut (exclusive borrow active)",
                )
                diags.append(diag)
            new_state[target] = OwnershipState.BORROWED

        elif op in _KEEP_OPS:
            if current == OwnershipState.MOVED:
                diag = Diagnostic(
                    code="SEM001", severity=Severity.ERROR,
                    line=_line_of(stmt), column=_col_of(stmt),
                    message=f"cannot keep '{target}': moved value is dead",
                )
                diags.append(diag)
            new_state[target] = OwnershipState.KEPT

        return new_state, diags

    def _track_unsafe(
        self, state: StateDict, stmt: UnsafeStmt
    ) -> tuple[StateDict, list[Diagnostic]]:
        body = stmt.body
        if body is None:
            return deepcopy(state), []
        if isinstance(body, BlockStmt):
            cur = deepcopy(state)
            for child in body.body:
                cur, _ = self.track_ownership(cur, child)
            return cur, []
        new_state, _ = self.track_ownership(deepcopy(state), body)
        return new_state, []

    def _track_route(
        self, state: StateDict, stmt: RouteStmt, _diags: list[Diagnostic]
    ) -> tuple[StateDict, list[Diagnostic]]:
        diags: list[Diagnostic] = []
        if not stmt.arms:
            return deepcopy(state), diags
        branch_states: list[StateDict] = []
        for arm in stmt.arms:
            arm_state, arm_diags = self._track_arm_body(state, arm)
            branch_states.append(arm_state)
            diags.extend(arm_diags)
        merged = self.merge_branch_states(branch_states)
        return merged, diags

    def _track_match(
        self, state: StateDict, stmt: MatchStmt, _diags: list[Diagnostic]
    ) -> tuple[StateDict, list[Diagnostic]]:
        diags: list[Diagnostic] = []
        if not stmt.arms:
            return deepcopy(state), diags
        branch_states: list[StateDict] = []
        for arm in stmt.arms:
            arm_state, arm_diags = self._track_arm_body(state, arm)
            branch_states.append(arm_state)
            diags.extend(arm_diags)
        merged = self.merge_branch_states(branch_states)
        return merged, diags

    def _track_arm_body(
        self, state: StateDict, arm: ASTNode
    ) -> tuple[StateDict, list[Diagnostic]]:
        diags: list[Diagnostic] = []
        body = getattr(arm, "body", None)
        if body is None:
            return deepcopy(state), diags
        if isinstance(body, BlockStmt):
            cur = deepcopy(state)
            for child in body.body:
                cur, child_diags = self.track_ownership(cur, child)
                diags.extend(child_diags)
            return cur, diags
        return self.track_ownership(deepcopy(state), body)

    def _track_block(
        self, state: StateDict, stmt: BlockStmt, _diags: list[Diagnostic]
    ) -> tuple[StateDict, list[Diagnostic]]:
        diags: list[Diagnostic] = []
        cur = deepcopy(state)
        for child in stmt.body:
            cur, child_diags = self.track_ownership(cur, child)
            diags.extend(child_diags)
        return cur, diags

    def _track_reassign(
        self, state: StateDict, stmt: VariableReassign
    ) -> tuple[StateDict, list[Diagnostic]]:
        diags: list[Diagnostic] = []
        new_state = deepcopy(state)
        name = stmt.name
        if name:
            if name in new_state and new_state[name] == OwnershipState.BORROWED_MUT:
                diags.append(
                    Diagnostic(
                        code="SEM001", severity=Severity.ERROR,
                        line=_line_of(stmt), column=_col_of(stmt),
                        message=f"cannot write '{name}': borrowed_mut (exclusive borrow active)",
                    )
                )
            new_state[name] = OwnershipState.OWNED
        return new_state, diags

    def _track_call(
        self, state: StateDict, stmt: CallExpr
    ) -> tuple[StateDict, list[Diagnostic]]:
        diags: list[Diagnostic] = []
        new_state = deepcopy(state)
        for arg in stmt.args:
            if isinstance(arg, Identifier) and arg.name:
                _check_read(new_state, arg.name, arg, diags)
        return new_state, diags

    def _track_expression(
        self, state: StateDict, stmt: ExpressionStmt, _diags: list[Diagnostic]
    ) -> tuple[StateDict, list[Diagnostic]]:
        diags: list[Diagnostic] = []
        expr = stmt.expr
        if isinstance(expr, Identifier):
            _check_read(state, expr.name, expr, diags)
        elif isinstance(expr, MatchExpr):
            new_state = deepcopy(state)
            if isinstance(expr.subject, Identifier) and expr.subject.name:
                _check_read(new_state, expr.subject.name, expr.subject, diags)
            if expr.arms:
                branch_states: list[StateDict] = []
                for arm in expr.arms:
                    arm_state, arm_diags = self._track_arm_body(new_state, arm)
                    branch_states.append(arm_state)
                    diags.extend(arm_diags)
                new_state = self.merge_branch_states(branch_states)
            return new_state, diags
        return deepcopy(state), diags

    def merge_branch_states(self, branch_states: list[StateDict]) -> StateDict:
        if not branch_states:
            return {}
        result = deepcopy(branch_states[0])
        for bs in branch_states[1:]:
            for var in list(result.keys()):
                if var in bs:
                    if result[var] == OwnershipState.MOVED or bs[var] == OwnershipState.MOVED:
                        result[var] = OwnershipState.MOVED
                    elif result[var] != bs[var]:
                        result[var] = OwnershipState.OWNED
                else:
                    del result[var]
            for var in bs:
                if var not in result:
                    result[var] = bs[var]
        return result


def _check_read(
    state: StateDict, name: str, node: ASTNode, diags: list[Diagnostic]
) -> None:
    if name in state and state[name] == OwnershipState.MOVED:
        diags.append(
            Diagnostic(
                code="SEM001", severity=Severity.ERROR,
                line=_line_of(node), column=_col_of(node),
                message=f"use of moved value '{name}'",
            )
        )
    elif name in state and state[name] == OwnershipState.BORROWED_MUT:
        diags.append(
            Diagnostic(
                code="SEM001", severity=Severity.ERROR,
                line=_line_of(node), column=_col_of(node),
                message=f"cannot read '{name}': borrowed_mut (exclusive borrow active)",
            )
        )


def _line_of(node: ASTNode) -> int:
    return getattr(node, "line", 0)


def _col_of(node: ASTNode) -> int:
    return getattr(node, "column", 0)
