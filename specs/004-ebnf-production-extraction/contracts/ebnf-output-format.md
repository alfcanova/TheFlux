# Contract: EBNF Output Format

**File**: `docs/TheFlux.ebnf`
**Encoding**: ASCII 7-bit (per project constitution)
**Format**: ISO EBNF (ISO 14977)

## Structure

```
(* header comment block *)
(* version, source, extraction date *)

production_1 ::= body ;
production_2 ::= body
                continuation
                | alternative ;
...
```

## Rules

1. Each production is a single logical line: `name ::= body ;`
2. The header block uses EBNF comments `(* ... *)` to document version, source, and extraction metadata
3. Productions from section 14 (diagnostics) are included after section 12 productions
4. C-style comments (`/* ... */`) from the source are removed or converted to EBNF comments
5. EBNF special sequences (`?...?`) are preserved verbatim
6. No Markdown artifacts (headers `##`, tables `|`, lists `-`, rules `---`)
7. No narrative text (sentences, paragraphs)
8. ASCII 7-bit only — bytes >0x7F are replaced with `?`

## Validation

Consumers of the EBNF output can validate against:
- Production count >= 200
- Zero non-ASCII bytes
- Zero Markdown artifact patterns in output lines
