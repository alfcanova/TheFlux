# Data Model: Parser Module Implementation

## 1. Core Types

### Token (pre-existing, from `flux_proto/token.py`)

```
Token = namedtuple("Token", ["type": TokenType, "lexeme": str, "line": int, "column": int])
TokenType = Enum with 77 variants (EOL, INDENT, DEDENT, EOF, keywords, operators, delimiters, literals, etc.)
```

### ASTNode (base class)

```
@dataclass
class ASTNode:
    node_type: str              # discriminator, matches class name
    children: list["ASTNode"]   # ordered child nodes (if applicable)
    start_token: Token          # first token of this construct
    end_token: Token            # last token of this construct
```

### ParseError (exception)

```
class ParseError(Exception):
    code: str = "PAR001"        # fixed parser error code
    line: int                   # source line
    column: int                 # source column
    message: str                # human-readable description
    expected: list[TokenType]   # what the parser expected (optional)
```

### TokenStream

```
class TokenStream:
    def __init__(self, tokens: Generator[Token]): ...
    def peek(self, n: int = 0) -> Token: ...        # lookahead (0 = current)
    def advance(self) -> Token: ...                  # consume and return current
    def expect(self, *types: TokenType) -> Token: ... # advance or raise PAR001
    def match(self, *types: TokenType) -> bool: ...   # peek and advance if match
    @property
    def position(self) -> int: ...                    # current index
    def set_position(self, pos: int): ...             # restore (for speculative parse)
```

## 2. AST Node Hierarchy

### Programs / Files

```
FluxProgram(name: str, use_decls: list[UseDecl], macros: list[MacroDef],
            structs: list[StructDef], enums: list[EnumDef],
            contracts: list[ContractDef], storages: list[StorageDecl],
            functions: list[FunctionDef], body: BlockStmt)
    └── Top-level `.flux` — exactly one `program` declaration per file

FdslFile(agents: list[AgentDef], use_decls: list[UseDecl],
         macros: list[MacroDef], structs: list[StructDef],
         enums: list[EnumDef], contracts: list[ContractDef],
         storages: list[StorageDecl], functions: list[FunctionDef])
    └── Top-level `.fdsl` — one or more `agent` declarations
```

### Declarations

```
FunctionDef(name: str, params: list[Parameter], return_type: TypeRef | None,
            body: BlockStmt, docstring: str | None)

OpDecl(name: str, left_type: TypeRef, right_type: TypeRef,
       return_type: TypeRef | None, body: OpBody, docstring: str | None)

StructDef(name: str, fields: list[StructField], docstring: str | None)
    ├── StructField(name: str, type_ref: TypeRef, mutable: bool)

EnumDef(name: str, base_type: TypeRef | None, members: list[EnumMember], docstring: str | None)
    ├── EnumMember(name: str, value: Literal | None)

ContractDef(name: str, op_signatures: list[ContractOpSig], docstring: str | None)
    ├── ContractOpSig(name: str, params: list[Parameter], return_type: TypeRef)

ImplDef(name: str, for_type: str | None, items: list[OpDecl | FunctionDef], docstring: str | None)

AgentDef(name: str, body: AgentBody, docstring: str | None)
    ├── AgentBody(storages: list[StorageDecl], functions: list[FunctionDef],
    │             ops: list[OpDecl])

MacroDef(name: str, params: list[Parameter], body: BlockStmt, docstring: str | None)

UseDecl(target: UseTarget)
    ├── UseTarget = UseAgent(name: str, alias: str | None)
    │             | UseOp(agent: str, op: str, alias: str)
    │             | UseGroup(agent: str, items: list[UseGroupItem])
    └── UseGroupItem(name: str, alias: str | None)

StorageDecl(items: list[StorageItem])
    ├── StorageItem(name: str, type_ref: TypeRef, initializer: Expr | None)
    ├── mutable: bool  # True if `mut`, False if `imut`
    └── constant: bool # True if SCREAMING_SNAKE
```

### Statements

```
BlockStmt(body: list[Stmt])
    └── Stmt = PrintStmt
            | InfiniteStmt
            | RouteStmt
            | MatchStmt
            | BreakStmt
            | ContinueStmt
            | EmitStmt
            | FailStmt
            | UnsafeStmt
            | StorageDecl
            | VariableReassign
            | ExpressionStmt

PrintStmt(args: list[Expr])

InfiniteStmt(condition: Expr | None, iterator: InfiniteIterator | None, body: BlockStmt)
    ├── InfiniteIterator(variable: str, collection: Expr)

RouteStmt(subjects: list[Expr], arms: list[RouteArm])
    ├── RouteArm(condition: Expr | None, body: BlockStmt)

MatchStmt(subject: Expr, arms: list[MatchArm])
    ├── MatchArm(pattern: Pattern, body: Expr)

BreakStmt()                     # no fields
ContinueStmt()                  # no fields

EmitStmt(status: str, variables: list[str], message: Expr)
FailStmt(message: Expr)

UnsafeStmt(body: BlockStmt)

VariableReassign(name: str, op: TokenType, value: Expr)

ExpressionStmt(expr: Expr)
```

### Expressions

```
Expr = BinaryOp
     | UnaryOp
     | Literal
     | Identifier
     | CallExpr
     | FieldAccess
     | IndexAccess
     | SliceSpec
     | StructInit
     | EnumVariant
     | MatchExpr
     | DataflowExpr
     | CastExpr
     | ErrorExpr
     | ShortCircuitBlock
     | InputExpr
     | SpyExpr
     | ComptimeExpr
     | QuoteExpr
     | UnquoteExpr
     | OwnershipExpr
     | AsyncExpr
     | SpawnExpr
     | AwaitExpr
     | LambdaExpr
     | DataflowCastSink
     | InterpolatedString
     | RouteExpr
     | MatchInlineExpr

BinaryOp(left: Expr, op: TokenType, right: Expr)
UnaryOp(op: TokenType, operand: Expr)

Literal(value_type: LiteralType, value: str)
    ├── LiteralType = INT | FLOAT | COMPLEX | DATETIME | STRING | CHAR | BOOL
    │                | LIST | SET | MAP | TENSOR

Identifier(name: str)

CallExpr(callee: Expr, args: list[Expr | NamedArg])
    ├── NamedArg(name: str, value: Expr)

FieldAccess(obj: Expr, field: str)
IndexAccess(obj: Expr, indices: list[Expr | Slice])

SliceSpec(start: Expr | None, end: Expr | None, step: Expr | None)
    └── Used inside IndexAccess for range syntax [start..end]

StructInit(name: str, fields: list[InitField])
    ├── InitField(name: str, value: Expr)

EnumVariant(enum_name: str, variant: str, fields: list[InitField])

DataflowExpr(left: Expr, op: TokenType, right: Expr)
    └── op in {"-->", "==>", "split", "join"}

CastExpr(expr: Expr, target_type: TypeRef)

MatchExpr(subject: Expr, arms: list[MatchArm])

ErrorExpr(code: Expr, message: Expr | None, recovery: Expr | None)

ShortCircuitBlock(expr: Expr, fail_arm: ShortCircuitArm, nice_arm: ShortCircuitArm)
    ├── ShortCircuitArm(var: str, body: BlockStmt)

InputExpr(prompt: Expr | None)
SpyExpr(target: Expr)

ComptimeExpr(body: BlockStmt | Expr)
    └── comptime { block } or comptime expression

QuoteExpr(body: BlockStmt)
UnquoteExpr(expr: Expr)

OwnershipExpr(op: str, target: str)
    └── op in {"move", "borrow", "keep"}

AsyncExpr(expr: Expr)
SpawnExpr(expr: Expr)
AwaitExpr(expr: Expr)

DataflowCastSink(target_type: TypeRef)

InterpolatedString(parts: list[InterpolatedText | Expr])
    ├── InterpolatedText(text: str)

RouteExpr(arms: list[RouteExprArm])
    ├── RouteExprArm(condition: Expr | None, body: Expr)

MatchInlineExpr(subject: Expr, arms: list[MatchInlineArm])
    ├── MatchInlineArm(pattern: Pattern, body: Expr)
```

### Patterns

```
Pattern = WildcardPattern
        | LiteralPattern
        | IdentifierPattern
        | ListPattern
        | RecordPattern
        | StructPattern
        | EnumVariantPattern
        | DataPattern

WildcardPattern()               # _
LiteralPattern(value: Literal)
IdentifierPattern(name: str)    # binds variable
ListPattern(items: list[Pattern], rest: str | None)
RecordPattern(fields: list[PatternField])
StructPattern(name: str, fields: list[PatternField])
EnumVariantPattern(enum: str, variant: str, fields: list[PatternField])
DataPattern(fields: list[PatternField])

PatternField(name: str, pattern: Pattern)
```

### Supporting Types

```
Parameter(name: str, type_ref: TypeRef)
TypeRef = PrimitiveType(name: str) | UserType(name: str)
    ├── PrimitiveType: int8, int16, int32, int64, uint8..uint64,
    │                  float16..tf32_e8m10, complex32..complex128,
    │                  datetime, char, string, bool, data,
    │                  list of T, set of T, map of T,
    │                  tensor[dim1, dim2, ...] of T
    └── UserType: PascalCase identifier (struct, enum, contract, agent)

OpBody(expressions: list[Expr], storages: list[StorageDecl])
```

## 3. Validation Rules (Parser-Level)

| Rule | Production | Error Condition |
|------|-----------|-----------------|
| `.flux` requires program | `flux_file` | `program` declaration missing → PAR001 |
| `.flux` program is last | `flux_file` | Any declaration after `program` → PAR001 |
| `.fdsl` requires agent(s) | `fdsl_file` | No `agent` declaration → PAR001 |
| `.fdsl` forbids program | `fdsl_file` | `program` declaration present → PAR001 |
| Balanced delimiters | all | Unmatched `()`, `[]`, `{}` → PAR001 |
| Expected token | `expect()` | Token mismatch → PAR001 with expected list |
| Statement end required | `statement_end` | Missing EOL/EOF/dedent after statement → PAR001 |
| Block body requires indent | `indented_block_body` | Missing INDENT → PAR001 |
| Block body requires dedent | `indented_block_body` | Missing DEDENT → PAR001 |
| Op requires 2 type params | `op_declaration` | Missing `(type, type)` → PAR001 |
| Emit requires status + message | `emit_stmt` | Missing `(nice/fail, ...)` → PAR001 |
| Function return type | `function_declaration` | `as type` after `)` is optional — no error |
| Pattern fields | all patterns | Malformed `.field: pattern` → PAR001 |
| Route catch-all is last | `route_arm` | `_` arm followed by another arm → PAR001 (semantic) |

## 4. State Transitions

The parser does not maintain persistent state beyond the `TokenStream` cursor and a recursion stack for nested constructs. Key transitions:

```
lex() tokens → TokenStream → parse(source_path) → ASTNode
                                  ├── .flux → flux_file() → FluxProgram
                                  └── .fdsl → fdsl_file() → FdslFile
```

Each parsing function consumes tokens and returns an AST node. On error, `ParseError` is raised immediately (fail-fast). No parser state survives across files.
