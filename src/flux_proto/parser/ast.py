from __future__ import annotations

from dataclasses import dataclass, field, asdict
from typing import Any


@dataclass
class ASTNode:
    children: list["ASTNode"] = field(default_factory=list)


@dataclass
class Literal(ASTNode):
    value_type: str = ""
    value: str = ""


@dataclass
class Identifier(ASTNode):
    name: str = ""


@dataclass
class BinaryOp(ASTNode):
    op: str = ""
    left: ASTNode | None = None
    right: ASTNode | None = None


@dataclass
class UnaryOp(ASTNode):
    op: str = ""
    operand: ASTNode | None = None


@dataclass
class CallExpr(ASTNode):
    callee: ASTNode | None = None
    args: list[ASTNode] = field(default_factory=list)


@dataclass
class NamedArg(ASTNode):
    name: str = ""
    value: ASTNode | None = None


@dataclass
class FieldAccess(ASTNode):
    obj: ASTNode | None = None
    field: str = ""


@dataclass
class IndexAccess(ASTNode):
    obj: ASTNode | None = None
    indices: list[ASTNode] = field(default_factory=list)


@dataclass
class SliceSpec(ASTNode):
    start: ASTNode | None = None
    end: ASTNode | None = None
    step: ASTNode | None = None


@dataclass
class IndexAssign(ASTNode):
    obj: ASTNode | None = None
    indices: list[ASTNode] = field(default_factory=list)
    op: str = "="
    value: ASTNode | None = None


@dataclass
class ListLiteral(ASTNode):
    items: list[ASTNode] = field(default_factory=list)


@dataclass
class SetLiteral(ASTNode):
    items: list[ASTNode] = field(default_factory=list)


@dataclass
class RecordLiteral(ASTNode):
    fields: list[InitField] = field(default_factory=list)


@dataclass
class MapEntry(ASTNode):
    key: str = ""
    key_type: ASTNode | None = None
    value: ASTNode | None = None
    value_type: ASTNode | None = None
    key_expr: ASTNode | None = None


@dataclass
class MapLiteral(ASTNode):
    entries: list[MapEntry] = field(default_factory=list)


@dataclass
class InitField(ASTNode):
    name: str = ""
    value: ASTNode | None = None


@dataclass
class StructInit(ASTNode):
    name: str = ""
    fields: list[InitField] = field(default_factory=list)


@dataclass
class FieldAssign(ASTNode):
    owner: str = ""
    field: str = ""
    op: str = "="
    value: ASTNode | None = None
    line: int = 0
    column: int = 0


@dataclass
class EnumVariant(ASTNode):
    enum_name: str = ""
    variant: str = ""
    fields: list[InitField] = field(default_factory=list)


@dataclass
class DataflowExpr(ASTNode):
    op: str = ""
    left: ASTNode | None = None
    right: ASTNode | None = None


@dataclass
class CastExpr(ASTNode):
    expr: ASTNode | None = None
    target_type: ASTNode | None = None


@dataclass
class PtrRefExpr(ASTNode):
    op: str = "&"
    target: ASTNode | None = None


@dataclass
class PtrDerefExpr(ASTNode):
    op: str = "*"
    ptr: ASTNode | None = None


@dataclass
class PtrAssign(ASTNode):
    ptr: ASTNode | None = None
    value: ASTNode | None = None


@dataclass
class ExternDecl(ASTNode):
    lang: str = "C"
    functions: list[FunctionDef] = field(default_factory=list)


@dataclass
class ErrorExpr(ASTNode):
    code: ASTNode | None = None
    message: ASTNode | None = None
    recovery: ASTNode | None = None


@dataclass
class ShortCircuitArm(ASTNode):
    status: str = ""
    value: str = ""
    message: ASTNode | None = None


@dataclass
class ShortCircuitBlock(ASTNode):
    expr: ASTNode | None = None
    fail_arm: ShortCircuitArm | None = None
    nice_arm: ShortCircuitArm | None = None


@dataclass
class InputExpr(ASTNode):
    prompt: ASTNode | None = None


@dataclass
class SpyExpr(ASTNode):
    target: ASTNode | None = None


@dataclass
class ComptimeExpr(ASTNode):
    body: ASTNode | None = None


@dataclass
class QuoteExpr(ASTNode):
    body: ASTNode | None = None


@dataclass
class UnquoteExpr(ASTNode):
    expr: ASTNode | None = None


@dataclass
class OwnershipExpr(ASTNode):
    op: str = ""
    target: str = ""
    mut: bool = False


@dataclass
class SpawnExpr(ASTNode):
    operand: ASTNode | None = None


@dataclass
class AwaitExpr(ASTNode):
    operand: ASTNode | None = None


@dataclass
class DataflowCastSink(ASTNode):
    target_type: ASTNode | None = None


@dataclass
class InterpolatedText(ASTNode):
    text: str = ""


@dataclass
class InterpolatedString(ASTNode):
    parts: list[ASTNode] = field(default_factory=list)


@dataclass
class MatchInlineExpr(ASTNode):
    subject: ASTNode | None = None
    arms: list["MatchArm"] = field(default_factory=list)


@dataclass
class MatchArm(ASTNode):
    pattern: ASTNode | None = None
    guard: ASTNode | None = None
    body: ASTNode | None = None


@dataclass
class MatchExpr(ASTNode):
    subject: ASTNode | None = None
    arms: list[MatchArm] = field(default_factory=list)


@dataclass
class LambdaExpr(ASTNode):
    params: list["Parameter"] = field(default_factory=list)
    body: ASTNode | None = None


@dataclass
class Parameter(ASTNode):
    name: str = ""
    type_ref: "TypeRef | None" = None
    mutable: bool = False


@dataclass
class PrimitiveType(ASTNode):
    name: str = ""


@dataclass
class UserType(ASTNode):
    name: str = ""


@dataclass
class TypeRef:
    pass


@dataclass
class Pattern(ASTNode):
    pass


@dataclass
class WildcardPattern(Pattern):
    pass


@dataclass
class LiteralPattern(Pattern):
    value: ASTNode | None = None


@dataclass
class IdentifierPattern(Pattern):
    name: str = ""


@dataclass
class ListPattern(Pattern):
    items: list[ASTNode] = field(default_factory=list)
    rest: str | None = None


@dataclass
class RecordPattern(Pattern):
    fields: list[InitField] = field(default_factory=list)


@dataclass
class StructPattern(Pattern):
    name: str = ""
    fields: list[InitField] = field(default_factory=list)


@dataclass
class EnumVariantPattern(Pattern):
    enum: str = ""
    variant: str = ""
    fields: list[InitField] = field(default_factory=list)


@dataclass
class DataPattern(Pattern):
    pass


@dataclass
class UseGroupItem(ASTNode):
    name: str = ""
    alias: str | None = None
    agent: str = ""


@dataclass
class UseAgent(ASTNode):
    name: str = ""
    alias: str | None = None


@dataclass
class UseOp(ASTNode):
    agent: str = ""
    op: str = ""
    alias: str = ""


@dataclass
class UseGroup(ASTNode):
    agent: str = ""
    items: list[UseGroupItem] = field(default_factory=list)


@dataclass
class UseDecl(ASTNode):
    target: ASTNode | None = None


@dataclass
class StructField(ASTNode):
    name: str = ""
    type_ref: ASTNode | None = None
    mutable: bool = True


@dataclass
class StructDef(ASTNode):
    name: str = ""
    fields: list[StructField] = field(default_factory=list)
    docstring: str | None = None


@dataclass
class EnumMember(ASTNode):
    name: str = ""
    fields: list[StructField] = field(default_factory=list)


@dataclass
class EnumDef(ASTNode):
    name: str = ""
    members: list[EnumMember] = field(default_factory=list)
    docstring: str | None = None


@dataclass
class ContractOpSig(ASTNode):
    name: str = ""
    params: list[Parameter] = field(default_factory=list)
    return_type: ASTNode | None = None


@dataclass
class ContractDef(ASTNode):
    name: str = ""
    op_signatures: list[ContractOpSig] = field(default_factory=list)
    docstring: str | None = None


@dataclass
class OpBody(ASTNode):
    expressions: list[ASTNode] = field(default_factory=list)
    storages: list[ASTNode] = field(default_factory=list)


@dataclass
class OpDecl(ASTNode):
    name: str = ""
    left_type: ASTNode | None = None
    right_type: ASTNode | None = None
    return_type: ASTNode | None = None
    body: OpBody | None = None
    params: list["Parameter"] = field(default_factory=list)
    docstring: str | None = None


@dataclass
class ImplDef(ASTNode):
    name: str = ""
    for_type: str | None = None
    items: list[ASTNode] = field(default_factory=list)
    docstring: str | None = None


@dataclass
class AgentBody(ASTNode):
    storages: list[ASTNode] = field(default_factory=list)
    functions: list["FunctionDef"] = field(default_factory=list)
    ops: list[OpDecl] = field(default_factory=list)


@dataclass
class AgentDef(ASTNode):
    name: str = ""
    body: AgentBody | None = None
    impl_contracts: list[str] = field(default_factory=list)
    docstring: str | None = None


@dataclass
class MacroDef(ASTNode):
    name: str = ""
    params: list[Parameter] = field(default_factory=list)
    body: ASTNode | None = None
    docstring: str | None = None


@dataclass
class StorageItem(ASTNode):
    name: str = ""
    type_ref: ASTNode | None = None
    initializer: ASTNode | None = None
    mutable: bool = True
    line: int = 0
    column: int = 0


@dataclass
class StorageDecl(ASTNode):
    items: list[StorageItem] = field(default_factory=list)
    static: bool = False


@dataclass
class VariableReassign(ASTNode):
    name: str = ""
    op: str = ""
    value: ASTNode | None = None
    line: int = 0
    column: int = 0


@dataclass
class ExpressionStmt(ASTNode):
    expr: ASTNode | None = None


@dataclass
class BreakStmt(ASTNode):
    pass


@dataclass
class ContinueStmt(ASTNode):
    pass


@dataclass
class PrintStmt(ASTNode):
    args: list[ASTNode] = field(default_factory=list)


@dataclass
class InfiniteIterator(ASTNode):
    variable: str = ""
    collection: ASTNode | None = None


@dataclass
class InfiniteStmt(ASTNode):
    condition: ASTNode | None = None
    iterator: InfiniteIterator | None = None
    body: ASTNode | None = None


@dataclass
class RouteArm(ASTNode):
    condition: ASTNode | None = None
    body: ASTNode | None = None


@dataclass
class RouteStmt(ASTNode):
    subjects: list[ASTNode] = field(default_factory=list)
    arms: list[RouteArm] = field(default_factory=list)


@dataclass
class MatchStmt(ASTNode):
    subject: ASTNode | None = None
    arms: list[MatchArm] = field(default_factory=list)


@dataclass
class EmitStmt(ASTNode):
    status: str = ""
    value: str = ""
    value_expr: ASTNode | None = None
    message: ASTNode | None = None


@dataclass
class FailStmt(ASTNode):
    message: ASTNode | None = None


@dataclass
class UnsafeStmt(ASTNode):
    body: ASTNode | None = None


@dataclass
class BlockStmt(ASTNode):
    body: list[ASTNode] = field(default_factory=list)


@dataclass
class FunctionDef(ASTNode):
    name: str = ""
    params: list[Parameter] = field(default_factory=list)
    return_type: ASTNode | None = None
    body: BlockStmt | None = None
    docstring: str | None = None
    is_async: bool = False


@dataclass
class FluxProgram(ASTNode):
    name: str = ""
    use_decls: list[UseDecl] = field(default_factory=list)
    macros: list[MacroDef] = field(default_factory=list)
    structs: list[StructDef] = field(default_factory=list)
    enums: list[EnumDef] = field(default_factory=list)
    contracts: list[ContractDef] = field(default_factory=list)
    storages: list[StorageDecl] = field(default_factory=list)
    functions: list[FunctionDef] = field(default_factory=list)
    body: BlockStmt | None = None
    imports: dict[str, FdslFile] = field(default_factory=dict)


@dataclass
class FdslFile(ASTNode):
    agents: list[AgentDef] = field(default_factory=list)
    use_decls: list[UseDecl] = field(default_factory=list)
    macros: list[MacroDef] = field(default_factory=list)
    structs: list[StructDef] = field(default_factory=list)
    enums: list[EnumDef] = field(default_factory=list)
    contracts: list[ContractDef] = field(default_factory=list)
    storages: list[StorageDecl] = field(default_factory=list)
    functions: list[FunctionDef] = field(default_factory=list)


_NODE_TYPE_MAP: dict[type, str] = {}


def _register(cls: type) -> type:
    _NODE_TYPE_MAP[cls] = cls.__name__
    return cls


for _cls in list(globals().values()):
    if isinstance(_cls, type) and issubclass(_cls, ASTNode) and _cls is not ASTNode:
        _register(_cls)


def ast_to_dict(node: ASTNode) -> dict[str, Any]:
    if node is None:
        return {}
    typename = _NODE_TYPE_MAP.get(type(node), type(node).__name__)
    result: dict[str, Any] = {"node_type": typename}
    for field_name in [f.name for f in type(node).__dataclass_fields__.values()]:
        val = getattr(node, field_name)
        if val is None or (isinstance(val, list) and not val):
            continue
        if isinstance(val, ASTNode):
            result[field_name] = ast_to_dict(val)
        elif isinstance(val, list):
            result[field_name] = [_ast_to_dict_item(v) for v in val if v is not None]
        elif isinstance(val, str):
            result[field_name] = val
        else:
            result[field_name] = val
    return result


def _ast_to_dict_item(v: Any) -> Any:
    if isinstance(v, ASTNode):
        return ast_to_dict(v)
    if isinstance(v, list):
        return [_ast_to_dict_item(x) for x in v if x is not None]
    return v
