# Quickstart: EBNF Production Extraction

## Prerequisites

- Python 3.x (in PATH, per project constitution)
- Source file `docs/grammar.md` exists and is readable

## Setup

```powershell
# Navigate to project root
cd D:\Projetos\TheFlux

# Verify Python is available
python --version
```

## Run Extraction

```powershell
# Run the extraction script
python specs/004-ebnf-production-extraction/extract_ebnf.py

# Expected output:
#   Extraction complete: XXX lines, YYY productions
#   Output: docs/TheFlux.ebnf
```

## Validate Output

```powershell
# Check production count
python -c "import re; e=open('docs/TheFlux.ebnf').read(); p=len(re.findall(r'::=', e)); print(f'Productions: {p}'); assert p >= 200, 'Too few productions'"

# Check ASCII encoding
python -c "d=open('docs/TheFlux.ebnf','rb').read(); b=[x for x in d if x>127]; print(f'Non-ASCII: {len(b)}'); assert len(b)==0, 'Non-ASCII found'"

# Check for Markdown artifacts
python -c "lines=open('docs/TheFlux.ebnf').readlines(); bad=[l for l in lines if l.strip().startswith('##') or (l.strip().startswith('|') and l.strip().endswith('|'))]; print(f'Markdown artifacts: {len(bad)}'); assert len(bad)==0, 'Markdown artifacts found'"
```

## Verify Cross-Reference

```powershell
# Count unique productions
python -c "import re; e=open('docs/TheFlux.ebnf').read(); p=set(re.findall(r'^(\w+)\s*::=', e, re.M)); print(f'Unique productions: {len(p)}')"
```

## Expected Outcomes

| Check | Expected | On Failure |
|-------|----------|------------|
| Production count | >= 200 productions | Extractor missed productions — check section range and skip logic |
| ASCII encoding | 0 non-ASCII bytes | Source has non-ASCII characters — check grammar.md encoding |
| Markdown artifacts | 0 artifacts | Skip patterns need updating — check new markdown constructs |
| Complete productions | No truncated entries | Semicolon detection failing — check multi-line handling |
