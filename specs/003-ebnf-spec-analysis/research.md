# Research: EBNF Spec Analysis

**Phase**: 0 — Outline & Research
**Feature**: EBNF Spec Analysis (003-ebnf-spec-analysis)

## Unknowns Resolved

No NEEDS CLARIFICATION markers were present in the feature spec. All requirements were well-defined.

## Technology Choices

### Extraction Approach

- **Decision**: Python 3 script using `re` module for state-machine extraction
- **Rationale**: Python is the project's host language per constitution (interpreter in PATH). The `re` module provides robust regex capabilities for parsing EBNF productions embedded in Markdown/C-comment syntax. PowerShell was also available but Python offers more reliable text processing for this task.
- **Alternatives considered**:
  - PowerShell regex — works but has quirks with multiline matching
  - Manual extraction — error-prone for 209 productions
  - PEG parser — overkill for a one-time extraction

### EBNF Format

- **Decision**: ISO EBNF (ISO 14977) — `::=` separator, `|` for alternatives, `{ }` repetition, `[ ]` optional, `" "` terminals, `? ?` special sequences, `(* *)` comments
- **Rationale**: Matches the notation used in grammar.md; widely supported by parser generators
- **Alternatives considered**: W3C EBNF, ABNF (RFC 5234)

### Output Location

- **Decision**: `docs/TheFlux.ebnf` (co-located with source `docs/grammar.md`)
- **Rationale**: Puts the EBNF alongside the grammar source it was extracted from

## Key Findings

1. grammar.md has 209 EBNF productions across sections 1-12
2. Productions are embedded within `/* ... */` C-style comment blocks mixed with narrative text
3. Multi-line productions have two formats: (a) name on same line as `::=`, (b) name on separate line from `::=`
4. Continuation lines use `|` operator or indented text
5. Some productions contain C-style comments (`/* ... */`) that must be converted to EBNF-style `(* ... *)`
6. The file has no structured delimiter between EBNF and narrative — extraction requires section-aware parsing
7. Special sequences (`?...?`) may span multiple lines
8. The grammar references semantic constraints (capitalization, ownership) that are enforced outside the grammar
