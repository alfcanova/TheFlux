# Quickstart: Lexer Module Validation Guide

## Prerequisites

- Python 3.12+ in PATH
- pytest installed (`pip install pytest`)
- (Optional) Wasmer + WABT suite on PATH for WASM integration tests
- Source files: `.flux` or `.fdsl` samples in `flux/` and `fdsl/`

## Setup

No build step needed — the lexer is pure Python. From repository root:

```powershell
# Verify imports work
python -c "from flux_proto.lexer.lexer import lex, LexicalError; print('OK')"
```

## Validation Scenarios

### 1. Basic Tokenization (smoke test)

**Command**:
```powershell
python -m flux_proto "flux/samples/hello.flux" --emit-lexer
```

**Expected outcome**: A JSON file is written to `intermediates/lexer/hello.json` containing an array of token objects with `type`, `lexeme`, `line`, `col` fields. The last token has type `EOF`.

**Sample input** (`flux/samples/minimal.flux`):
```
program (Main)
{
      imut as string: SAUDAÇÃO = "Olá"
      print(SAUDAÇÃO)
}
```

**Note**: Replace `flux/samples/minimal.flux` with a valid ASCII-only `.flux` file during initial validation. The sample above contains non-ASCII characters which should trigger LEX001 — use it for error-path validation instead.

**Valid sample** (`flux/samples/hello.flux`):
```
program (Main)
{
      print("Hello, World!")
}
```

**Lexer output** (expected token sequence):
```
PROGRAM(program), LPAREN, IDENTIFIER(Main), RPAREN, LBRACE, EOL,
INDENT, IDENTIFIER(print), LPAREN, STRING_LIT("Hello, World!"), RPAREN, EOL,
DEDENT, RBRACE, EOL, EOF
```

### 2. ASCII Validation Rejection

**Command**:
```powershell
# Create a file with a non-ASCII byte
echo "program (Main)`n{`n      print(""café"")`n}" > temp/test_lex001.flux
python -m flux_proto "temp/test_lex001.flux"
```

**Expected outcome**: Error message:
```
temp/test_lex001.flux:3,14 -> [LEX001]: Non-ASCII byte 0xE9 at position ...
```

### 3. Indentation Validation

**Command**:
```powershell
# Create a properly indented file
@"
program (Main)
{
      mut as int64: x = 1
      mut as int64: y = 2
}
"@ > temp/test_indent.flux
python -m flux_proto "temp/test_indent.flux" --emit-lexer
```

**Expected outcome**: Lexer succeeds. Inspect `intermediates/lexer/test_indent.json` — INDENT token appears before `mut` on line 3, DEDENT appears before `}` on line 6.

**Negative test — tab rejection**:
```powershell
# File with tab
python -c "
open('temp/test_tab.flux', 'w').write('program (Main)\n{\n\tprint(1)\n}')
"
python -m flux_proto "temp/test_tab.flux"
```

**Expected outcome**: `TabulationError` raised with line/column of the tab character.

### 4. Keyword Recognition

**Command**:
```powershell
python -c "
from flux_proto.lexer.lexer import lex
from flux_proto.token import TokenType
tokens = list(lex('function (calcTotal) (x: int64) as int64 { emit(nice, x, \"done\") }'))
keyword_tokens = [t for t in tokens if t.type in {
    TokenType.FUNCTION, TokenType.AS, TokenType.INT64,
    TokenType.EMIT, TokenType.NICE, TokenType.EOF
}]
print(f'Matched {len(keyword_tokens)} keyword tokens')
for t in keyword_tokens:
    print(f'  {t.type.name:20} {t.lexeme}')
"
```

**Expected outcome**: All keywords recognized with correct TokenType.

### 5. Longest-Match Operators

**Command**:
```powershell
python -c "
from flux_proto.lexer.lexer import lex
source = 'a --> b ==> c >>> d .. e :: f'
tokens = list(lex(source))
for t in tokens:
    if t.type.name not in ('IDENTIFIER',):
        print(f'{t.type.name:20} {repr(t.lexeme)}')
"
```

**Expected outcome**:
```
DATAFLOW             '-->'
DATAFLOW_MAP         '==>'
SHIFT_ARITH          '>>>'
RANGE                '..'
DOUBLE_COLON         '::'
EOF                  ''
```

### 6. String Interpolation

**Command**:
```powershell
python -c "
from flux_proto.lexer.lexer import lex
source = '"Value: #{x + 1}"'
tokens = list(lex(source))
for t in tokens:
    print(f'{t.type.name:30} {repr(t.lexeme)}')
"
```

**Expected outcome**:
```
INTERPOLATED_STRING_START      '\"'
INTERPOLATED_TEXT              'Value: '
INTERPOLATION_OPEN             '#{'
IDENTIFIER                     'x'
PLUS                           '+'
INT_LIT                        '1'
INTERPOLATION_CLOSE            '}'
INTERPOLATED_STRING_END        '\"'
EOF                            ''
```

### 7. Block Comment and Docstring

**Command**:
```powershell
python -c "
from flux_proto.lexer.lexer import lex
source = '#B This is a block comment B#\n#D\nDocumentation\nD#\nfunction (foo) () {}'
tokens = list(lex(source))
for t in tokens:
    if t.type.name in ('BLOCK_COMMENT', 'DOCSTRING', 'FUNCTION'):
        print(f'{t.type.name:20} {repr(t.lexeme[:50])}')
"
```

**Expected outcome**:
```
BLOCK_COMMENT        'This is a block comment'
DOCSTRING            'Documentation'
FUNCTION             'function'
```

### 8. Multi-Target Consistency (Integration)

**Command**:
```powershell
# Lex once, verify all backends can consume the AST
python -m flux_proto "flux/samples/hello.flux" --target run
python -m flux_proto "flux/samples/hello.flux" --target vmbc -o temp/hello
python -m flux_proto "flux/samples/hello.flux" --target wat -o temp/hello
python -m flux_proto "flux/samples/hello.flux" --target wasm -o temp/hello
python -m flux_proto "flux/samples/hello.flux" --target llvm -o temp/hello
```

**Expected outcome**: All five commands succeed (no errors). The `.fvmbc`, `.wat`, `.wasm`, and LLVM output files are created.

### 9. pytest Test Suite

**Command**:
```powershell
# Run all lexer tests
pytest src/flux_tests/lexer/ -v

# Run with coverage (optional)
pytest src/flux_tests/lexer/ -v --cov=src/flux_proto/lexer
```

**Expected outcome**: All tests pass. Coverage report shows high coverage of all sub-modules.

## Test Categories

Per the constitution, tests are organized as:

| Category | Purpose | Example |
|----------|---------|---------|
| Positive | Valid programs must lex correctly | `test_positive.py` |
| Negative | Invalid programs must raise errors | `test_negative.py` — non-ASCII, tabs, unterminated strings |
| False positive | Edge cases that look invalid but are valid | `test_positive_false.py` — empty docstring, zero-length interpolations |
| False negative | Constructs that look valid but are invalid | `test_negative_false.py` — reserved word as identifier |
| Regression | Previously fixed bugs must stay fixed | `test_regression.py` |
| Compliance | Feature parity across all backends | `test_compliance.py` — same source, same result across all 4 trees |
| Fuzzy | Random/corner-case inputs | `test_fuzzy.py` — generated random valid/invalid sources |

## Reference

- [Spec document](spec.md)
- [Data model](data-model.md)
- [TokenProvider contract](contracts/token-provider.md)
- [Constitution](../../.specify/memory/constitution.md)
- [Grammar reference](../../docs/grammar.md)
- [EBNF grammar](../../docs/TheFlux.ebnf)
