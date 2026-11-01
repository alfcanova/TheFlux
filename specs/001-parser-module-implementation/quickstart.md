# Quickstart Validation Guide: Parser Module Implementation

## Prerequisites

- Python 3.12+ on PATH
- Pytest (install via `pip install pytest` if needed)
- The lexer module at `src/flux_proto/lexer/` must be operational (77 tests passing)
- Sample programs at `flux/samples/` and `fdsl/samples/`

## Setup

```powershell
cd D:\Projetos\TheFlux
$env:PYTHONPATH = "src"
```

## Validation Scenarios

### Scenario 1: Parse a Complete .flux Program

```powershell
python -m flux_proto "flux/samples/hello.flux" --emit-ast
```

**Expected**: AST JSON written to `intermediates/ast/hello.json`. File contains valid JSON with `"node_type": "FluxProgram"` as root, `"node_type": "PrintStmt"` inside the body.

### Scenario 2: Parse a Complete .fdsl File

```powershell
python -m flux_proto "fdsl/samples/agent_test.fdsl" --emit-ast
```

**Expected**: AST JSON written to `intermediates/ast/agent_test.json`. Root `"node_type": "FdslFile"` with one `"node_type": "AgentDef"` child.

### Scenario 3: Syntax Error on Missing Parenthesis

```powershell
python -c "
from flux_proto.lexer import lex
from flux_proto.parser import parse
tokens = lex('program (Main) { print(\"hello\" }')
try:
    ast = parse(tokens, 'test.flux')
except Exception as e:
    print(e)
"
```

**Expected**: `ParseError` with code `PAR001`, line 1, column pointing at `}`, message indicating expected `)`.

### Scenario 4: Expression Precedence

```powershell
python -c "
from flux_proto.lexer import lex
from flux_proto.parser import parse
tokens = lex('mut as int64: x = a + b * c ^e d')
ast = parse(tokens, 'test.flux')
# AST should show: Assign(+, Identifier('a'), BinaryOp(*, Identifier('b'), BinaryOp(^e, Identifier('c'), Identifier('d'))))
print(ast)
"
```

**Expected**: AST reflects operator precedence (power before multiplication before addition).

### Scenario 5: docstring Attachment

```powershell
python -c "
from flux_proto.lexer import lex
from flux_proto.parser import parse
tokens = lex('#D\nA function\nD#\nfunction (f) () {}')
ast = parse(tokens, 'test.flux')
print(ast)
"
```

**Expected**: The `FunctionDef` node has `docstring` field containing `"A function\n"`.

### Scenario 6: Interpolated String

```powershell
python -c "
from flux_proto.lexer import lex
from flux_proto.parser import parse
tokens = lex('mut as string: msg = \"Hello #{name}!\"')
ast = parse(tokens, 'test.flux')
print(ast)
"
```

**Expected**: The expression contains an `InterpolatedString` node with `InterpolatedText("Hello ")`, `Identifier("name")`, `InterpolatedText("!")`.

### Scenario 7: Invalid .flux — Missing Program

```powershell
python -c "
from flux_proto.lexer import lex
from flux_proto.parser import parse
tokens = lex('function (f) () {}')
try:
    ast = parse(tokens, 'test.flux')
except Exception as e:
    print(e)
"
```

**Expected**: `ParseError` — `.flux` file must contain a `program` declaration.

### Scenario 8: Invalid .fdsl — Contains Program

```powershell
python -c "
from flux_proto.lexer import lex
from flux_proto.parser import parse
tokens = lex('program (Main) {}')
try:
    ast = parse(tokens, 'test.fdsl')
except Exception as e:
    print(e)
"
```

**Expected**: `ParseError` — `.fdsl` file must not contain `program`.

### Scenario 9: Run Full Test Suite

```powershell
python -m pytest src/flux_tests/parser/ -v
```

**Expected**: All parser tests pass. All existing lexer tests (77) still pass.

## Test Commands

| Category | Command |
|----------|---------|
| All parser tests | `python -m pytest src/flux_tests/parser/ -v` |
| Expression tests | `python -m pytest src/flux_tests/parser/test_expressions.py -v` |
| Declaration tests | `python -m pytest src/flux_tests/parser/test_declarations.py -v` |
| Statement tests | `python -m pytest src/flux_tests/parser/test_statements.py -v` |
| Pattern tests | `python -m pytest src/flux_tests/parser/test_patterns.py -v` |
| Integration tests | `python -m pytest src/flux_tests/parser/test_integration.py -v` |
| Error tests | `python -m pytest src/flux_tests/parser/test_errors.py -v` |
| Lexer regression | `python -m pytest src/flux_tests/lexer/ -v` |
| All tests | `python -m pytest src/flux_tests/ -v` |

## Output Locations

| Artifact | Path |
|----------|------|
| AST JSON (via CLI) | `intermediates/ast/<filename>.json` |
| Parser test reports | pytest stdout |
| Coverage | `coverage xml` (if configured) |
