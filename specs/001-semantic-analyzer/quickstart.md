# Quickstart: Semantic Analyzer Validation

## Prerequisites

- Python 3.12+ in PATH
- `pytest` installed (`pip install pytest`)
- Lexer + parser modules fully implemented and passing (Phase 2–3)
- Lexer test suite passes: `pytest src/flux_tests/lexer/`
- Parser test suite passes: `pytest src/flux_tests/parser/`
- Wasmer and WABT on PATH (for WASM/WAT downstream validation — not needed for semantic phase itself)

## Setup

```bash
# Run all semantic tests (after implementation)
pytest src/flux_tests/semantic/ -v

# Run specific test categories
pytest src/flux_tests/semantic/test_scope.py -v
pytest src/flux_tests/semantic/test_types.py -v
pytest src/flux_tests/semantic/test_ownership.py -v
```

## Validation Scenarios

### Scenario 1: Simple program — zero diagnostics

**File**: `flux/samples/hello.flux`

```flux
use StdIo as io

function (saudar) (nome: string) as string
    emit(nice, (nome), "Ola, {nome}!")

program (HelloFlux)
    mut as string: nome = "Mundo"
    saudar(nome) --> print
```

**Command**:
```bash
python -m flux_proto check flux/samples/hello.flux
```

**Expected output**: `SUCCESS — zero diagnostics`

**Validation**: Lex → Parse → Semantic analysis produces decorated AST with all types resolved, no SEM001/SUG diagnostics. This verifies FR-001 through FR-012 on a correct program.

---

### Scenario 2: Capitalization violation — SUGGESTION emitted

**File**: `test_cap.flux`

```flux
program (Teste)
    mut as int64: MAX_VALOR = 42
```

**Command**:
```bash
python -m flux_proto check test_cap.flux
```

**Expected output**:
```
test_cap.flux:2,col -> [SUG]: variable 'MAX_VALOR' should use snake_case: 'max_valor'
```

**Validation**: Verifies FR-004 — capitalization rules for mutable variables.

---

### Scenario 3: Type mismatch — SEM001 emitted

**File**: `test_type.flux`

```flux
program (Teste)
    mut as int64: x = "hello"
```

**Command**:
```bash
python -m flux_proto check test_type.flux
```

**Expected output**:
```
test_type.flux:2,col -> [SEM001]: type mismatch: expected int64 but got string
```

**Validation**: Verifies FR-007 — type compatibility checking.

---

### Scenario 4: Duplicate declaration — SEM001 emitted

**File**: `test_dup.flux`

```flux
struct (Ponto)
    mut: .x: int64
    mut: .y: int64

struct (Ponto)
    mut: .x: float64
```

**Command**:
```bash
python -m flux_proto check test_dup.flux
```

**Expected output**:
```
test_dup.flux:1,col -> [SEM001]: duplicate declaration of struct 'Ponto'
test_dup.flux:5,col -> [SEM001]: duplicate declaration of struct 'Ponto'
```

**Validation**: Verifies FR-002 — duplicate detection.

---

### Scenario 5: Use-after-move — SEM001 emitted

**File**: `test_move.flux`

```flux
program (Teste)
    mut as int64: x = 42
    move(x)
    print(x)
```

**Command**:
```bash
python -m flux_proto check test_move.flux
```

**Expected output**:
```
test_move.flux:4,col -> [SEM001]: use of moved variable 'x'
  --> test_move.flux:3,col: value moved here
```

**Validation**: Verifies FR-009 — ownership tracking.

---

### Scenario 6: Contract-agent verification — missing op

**File**: `test_contract.fdsl`

```fdsl
contract (Validador)
    op validar(documento: data) as bool
    op auditar(registro: data) as void

agent (MeuServico)
    mut as int64: contagem = 0
    function (validar) (documento: data) as bool
        emit(nice, (), "valido")
```

**Command**:
```bash
python -m flux_proto check test_contract.fdsl --emit-semantic
```

**Expected output**:
```
test_contract.fdsl:6,col -> [SEM001]: missing op implementation: 'auditar(documento: data) as void'
```

**Validation**: Verifies FR-011 — contract-agent implementation verification.

---

### Scenario 7: Missing emit terminal — SEM001 emitted

**File**: `test_emit.flux`

```flux
program (Teste)
    function (calcular) (x: int64) as int64
        route
            x > 0 ==> { emit(nice, (x), "positivo") }
            _ ==> { print("negativo") }
```

**Command**:
```bash
python -m flux_proto check test_emit.flux
```

**Expected output**:
```
test_emit.flux:5,col -> [SEM001]: function 'calcular' has a code path without emit
```

**Validation**: Verifies FR-012 — emit terminal path analysis.

---

### Scenario 8: Imut requires initializer

**File**: `test_imut.flux`

```flux
program (Teste)
    imut as int64: X
```

**Command**:
```bash
python -m flux_proto check test_imut.flux
```

**Expected output**:
```
test_imut.flux:2,col -> [SEM001]: immutable declaration 'X' requires an initializer
```

**Validation**: Verifies FR-005.

---

### Scenario 9: Parse-then-analyze integration — zero regression

**Command**:
```bash
# All parser-passing files must also pass semantic analysis
for f in flux/samples/*.flux fdsl/samples/*.fdsl; do
    python -m flux_proto check "$f" && echo "PASS: $f" || echo "FAIL: $f"
done
```

**Expected output**: All `.flux` and `.fdsl` files pass semantic analysis with zero diagnostics.

**Validation**: Verifies SC-004 — zero false-positive diagnostics on parser test suite.
