# Research: EBNF Production Extraction

**Phase**: 0 — Outline & Research
**Date**: 2026-07-22

## Overview

All technical context items from the implementation plan have clear defaults based on the project constitution and existing codebase. No NEEDS CLARIFICATION markers were required.

## Decisions

| Decision | Choice | Rationale | Alternatives Considered |
|----------|--------|-----------|------------------------|
| Implementation language | Python 3 (stdlib) | Per constitution: Python interpreter in PATH, used for all tooling | Native Windows (PowerShell, cmd) — rejected as less maintainable for state-machine parsing |
| Output path | `docs/TheFlux.ebnf` | Per spec FR-001 and user instruction | N/A — explicitly specified |
| Semicolon termination | State-machine approach tracking `;` as terminator | Productions span multiple lines; line-by-line split would truncate productions | Line-by-line extraction — rejected because multi-line productions would be split incorrectly |
| ASCII enforcement | `encode('ascii', errors='replace')` on output | Per constitution: ASCII 7-bit only | UTF-8 — rejected per constitution LEX001 rule |
| Section range | Sections 1-12 (primary grammar) + section 14 (diagnostics) | Spec FR-001; section 14 contains diagnostic format productions | Sections 1-12 only — would miss diagnostic format |
| Input format | `docs/grammar.md` (Markdown with C-style comment delimiters) | Existing project artifact | N/A — fixed input |

## Key Findings

1. The `;` character is the definitive production terminator — no production body should extend past a `;`.
2. Production names may appear on a separate line from `::=` — the extractor must join them.
3. Multi-line production bodies continue across newlines with indented continuation lines.
4. C-style comments (`/* ... */`) appear in grammar.md as section headers and annotations; they must be stripped or converted.
5. EBNF special sequences (`?...?`) must be preserved verbatim.
6. Section 14 (CONTRATO DE DIAGNOSTICO) contains 9 diagnostic productions that are not in sections 1-12.
