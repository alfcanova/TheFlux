# Research: Extract EBNF Grammar

**Phase**: 0 — Outline & Research
**Feature**: Extract EBNF Grammar (002-extract-ebnf-grammar)

## Unknowns Resolved

No NEEDS CLARIFICATION markers were present in the feature spec. The extraction task had clear requirements and scope.

## Technology Choices

### Extraction Approach

- **Decision**: Use PowerShell `Get-Content` with regex-based state-machine extraction
- **Rationale**: No external dependencies; PowerShell is available on the Windows development environment. The grammar.md has a consistent structure (EBNF productions in `/* ... */` blocks, sections 1-12)
- **Alternatives considered**:
  - Python script with `re` module — equivalent capability, would add Python dependency
  - Manual extraction — too error-prone for 209 productions

### EBNF Format

- **Decision**: ISO EBNF (`::=` separator, `|` alternatives, `{ }` repetition, `[ ]` optional, `" "` terminals, `? ?` special sequences, `(* *)` comments)
- **Rationale**: ISO 14977 standard — widely supported by parser generators and validators
- **Alternatives considered**: W3C EBNF notation, ABNF (RFC 5234) — ISO EBNF matches the original notation used in grammar.md

### Encoding

- **Decision**: ASCII 7-bit (0x00-0x7F)
- **Rationale**: Required by TheFlux constitution (encoding constraint) and FR-004

## Key Findings

1. grammar.md contains 209 EBNF productions across sections 1-12
2. Some productions span multiple lines (name on one line, `::=` on the next)
3. Some productions use C-style `/* ... */` comments for annotations — these must be converted to EBNF `(* ... *)` or removed
4. Special sequences (`?...?`) may span multiple lines and need careful handling
5. The `pending_line_operator`, `type_ref`, `index_or_slice_suffix`, and several other multi-line productions require special extraction logic
6. Productions like `ascii_printable_except_*` have names too long for simple regex matching — need flexible parsing
