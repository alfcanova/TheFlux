# Quickstart: Extract EBNF Grammar

**Phase**: 1 — Design & Contracts
**Feature**: Extract EBNF Grammar (002-extract-ebnf-grammar)

## Prerequisites

- Windows PowerShell 5.1+ or PowerShell 7+
- Source file: `docs/grammar.md` (must exist with grammar sections 1-12)

## Setup

No setup required. Extraction is done directly from `docs/grammar.md`.

## Validation Scenarios

### Scenario 1: Verify Production Count

**Command**:
```powershell
$count = (Select-String -Pattern "::=" "TheFlux.ebnf").Count
Write-Host "Productions: $count (expected: 209)"
```

**Expected**: Output shows 209 productions.

### Scenario 2: Verify No Markdown Artifacts

**Command**:
```powershell
$bad = Select-String -Pattern "##|-\s|\|.*\|" "TheFlux.ebnf"
if ($bad) { Write-Host "FAIL: Markdown artifacts found" } else { Write-Host "PASS: No Markdown artifacts" }
```

**Expected**: PASS — No Markdown artifacts.

### Scenario 3: Verify ASCII Encoding

**Command**:
```powershell
$bytes = Get-Content "TheFlux.ebnf" -Encoding Byte
$bad = $bytes | Where-Object { $_ -gt 127 }
if ($bad.Count -gt 0) { Write-Host "FAIL: Non-ASCII bytes found" } else { Write-Host "PASS: ASCII 7-bit only" }
```

**Expected**: PASS — ASCII 7-bit only.

### Scenario 4: Verify All Expected Productions

**Command**:
```powershell
$expected = @("type_ref", "index_or_slice_suffix", "pending_line_operator",
              "implemented_integer_type", "implemented_float_type",
              "implemented_numeric_type", "expr", "literal", "keyword",
              "flux_file", "fdsl_file", "diagnostic_code")
$content = Get-Content "TheFlux.ebnf" -Raw
$missing = $expected | Where-Object { $content -notmatch "(?m)^$_\s" }
if ($missing.Count -gt 0) { Write-Host "MISSING: $($missing -join ', ')" } else { Write-Host "PASS: All key productions present" }
```

**Expected**: PASS — All key productions present.

### Scenario 5: End-to-End Validation

Run all checks above sequentially:

```powershell
Write-Host "=== TheFlux.ebnf Validation ==="
$lines = Get-Content "TheFlux.ebnf"
Write-Host "File size: $((Get-Item 'TheFlux.ebnf').Length) bytes"
Write-Host "Total lines: $($lines.Count)"
$prods = ($lines | Where-Object { $_ -match '::=' }).Count
Write-Host "Productions: $prods"

# Check every production ends with ;
$incomplete = @()
$i = 0
while ($i -lt $lines.Count) {
    $t = $lines[$i].Trim()
    if ($t -match '^[\w_]+\s+::=' -and $t -notmatch ';\s*$') {
        $j = $i + 1
        $foundEnd = $false
        while ($j -lt $lines.Count) {
            if ($lines[$j].Trim() -match ';\s*$') { $foundEnd = $true; break }
            if ($lines[$j].Trim() -match '^[\w_]+\s+::=') { break }
            $j++
        }
        if (-not $foundEnd) { $incomplete += $t }
    }
    $i++
}
if ($incomplete.Count -gt 0) { Write-Host "WARNING: $($incomplete.Count) incomplete productions" }
else { Write-Host "PASS: All productions properly terminated" }
```

## Expected Outcomes

- `TheFlux.ebnf` exists at project root
- Contains 209 EBNF productions from grammar.md sections 1-12
- All productions are valid ISO EBNF syntax
- No Markdown, HTML, or ASCII table artifacts
- ASCII 7-bit encoded
- Production names use the `name ::= definition ;` format

## References

- [Feature Spec](spec.md)
- [Data Model](data-model.md)
- Source grammar: `docs/grammar.md` (1735 lines, Snapshot RC: 2026-07-20)
