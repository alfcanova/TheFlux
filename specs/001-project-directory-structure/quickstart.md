# Quickstart: Project Directory Structure

## Prerequisites

- Windows with PowerShell 7+
- Project root at `D:\Projetos\TheFlux`

## Setup

No dependencies. The scaffold script uses only built-in PowerShell cmdlets.

## Running the Scaffold

```powershell
# From the project root
.\scaffold.ps1
```

Expected output: All directories created silently (no errors).

## Validation

### Verify root directories exist

```powershell
$roots = @(
  'docs', 'fdsl', 'flux', 'intermediates', 'runtime', 'temp',
  'src', 'stdlib', 't_llvm', 't_wasm-1.0', 't_wasm-2.0',
  't_wasm-3.0', 't_benchmarks', 't_general'
)
$roots | ForEach-Object {
  $ok = Test-Path $_
  Write-Host "$_ : $(if ($ok) { 'OK' } else { 'MISSING' })"
}
```

### Verify intermediates subdirectories

```powershell
$subs = @('ast','ddg','lexer','llvm','parser','semantic','wat')
$subs | ForEach-Object {
  $ok = Test-Path "intermediates/$_"
  Write-Host "intermediates/$_ : $(if ($ok) { 'OK' } else { 'MISSING' })"
}
```

### Verify QA subdirectories

```powershell
$qa = @('matrices','metrics','negative','negative_false','positive','positive_false','regression')
$qa | ForEach-Object {
  $ok = Test-Path "t_general/$_"
  Write-Host "t_general/$_ : $(if ($ok) { 'OK' } else { 'MISSING' })"
}
```

### Verify total directory count

```powershell
$count = (Get-ChildItem -Directory -Recurse -Depth 3).Count
Write-Host "Total directories: $count (expected >= 30)"
```

### Idempotency test

```powershell
# Run scaffold again — must produce zero errors
.\scaffold.ps1
Write-Host "Second run completed without errors — idempotent"
```

## Expected Outcomes

- All ~30 directories exist after first run
- Second run completes silently without errors (idempotent)
- Every empty directory contains a `.gitkeep` file
- All errors produce clear PowerShell error messages
