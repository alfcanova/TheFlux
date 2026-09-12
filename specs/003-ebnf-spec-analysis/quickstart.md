# Quickstart: EBNF Spec Analysis

**Phase**: 1 — Design & Contracts
**Feature**: EBNF Spec Analysis (003-ebnf-spec-analysis)

## Prerequisites

- Python 3.x (interpreter in PATH)
- Source file: `docs/grammar.md`

## Extraction

Run the Python extraction script:

```powershell
python specs/003-ebnf-spec-analysis/extract_ebnf.py
```

This generates `docs/TheFlux.ebnf`.

## Validation Scenarios

### Scenario 1: Verify Production Count

```powershell
python -c "
import re
with open('docs/TheFlux.ebnf', 'r') as f:
    count = len(re.findall(r'::=', f.read()))
print(f'Productions: {count} (expected: ~209)')
"
```

### Scenario 2: Verify No Markdown Artifacts

```powershell
python -c "
with open('docs/TheFlux.ebnf', 'r') as f:
    content = f.read()
bad = [m for m in ['##', '---', '|'] if m in content]
print('PASS' if not bad else f'FAIL: found {bad}')
"
```

### Scenario 3: Verify ASCII Encoding

```powershell
python -c "
with open('docs/TheFlux.ebnf', 'rb') as f:
    bad = [b for b in f.read() if b > 127]
print('PASS' if not bad else f'FAIL: {len(bad)} non-ASCII bytes')
"
```

### Scenario 4: Verify Key Productions Present

```powershell
python -c "
with open('docs/TheFlux.ebnf', 'r') as f:
    content = f.read()
expected = ['type_ref', 'expression', 'literal', 'keyword', 'flux_file', 'fdsl_file']
missing = [e for e in expected if not re.search(r'^' + e + r'\s', content, re.MULTILINE)]
print('PASS' if not missing else f'MISSING: {missing}')
"
```

## Expected Outcomes

- `docs/TheFlux.ebnf` exists
- Contains ~209 EBNF productions from grammar.md sections 1-12
- All productions valid ISO EBNF syntax
- No Markdown/HTML/ASCII table artifacts
- ASCII 7-bit encoded

## References

- [Feature Spec](spec.md)
- [Data Model](data-model.md)
- [Grammar Contract](contracts/ebnf-grammar.md)
- Source: `docs/grammar.md`
