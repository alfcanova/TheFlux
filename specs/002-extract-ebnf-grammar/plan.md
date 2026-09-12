# Implementation Plan: Extract EBNF Grammar

**Branch**: `002-extract-ebnf-grammar` | **Date**: 2026-07-22 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/002-extract-ebnf-grammar/spec.md`

## Summary

Extract all EBNF productions from `docs/grammar.md` (sections 1-12) into a standalone `TheFlux.ebnf` file at the project root. The extraction must produce valid ISO EBNF syntax with ASCII 7-bit encoding, removing all Markdown formatting, implementation notes, and narrative text while preserving EBNF-style comments `(* ... *)`.

## Technical Context

**Language/Version**: PowerShell (available on system) / Python 3.x (interpreter in PATH per constitution)

**Primary Dependencies**: None (file parsing is done with built-in language stdlib)

**Storage**: N/A — single file output at project root `TheFlux.ebnf`

**Testing**: Manual verification against grammar.md — count productions, validate ISO EBNF syntax, check ASCII encoding

**Target Platform**: Windows (development environment)

**Project Type**: Documentation artifact generation

**Performance Goals**: N/A (single-pass extraction, < 1s)

**Constraints**: ASCII 7-bit encoding only; output must be valid ISO EBNF; zero Markdown artifacts

**Scale/Scope**: Single file extraction from grammar.md (1735 lines, 209 EBNF productions)

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Relevant Principles

| Principle | Impact on this feature |
|-----------|----------------------|
| I. Multi-Target Synchronization | Not applicable — this is a documentation artifact, not a language feature |
| II. Zero-Regression Automated Testing | Partially applicable — the EBNF file should be validated (production count, syntax check) |
| III. Modular Compilation & Test Infrastructure | Not applicable |
| IV. Cross-Target Feature Parity | Not applicable |
| V. Dataflow & Agent-Oriented Architecture | Not applicable |

### Encoding Constraint

- **ASCII 7-bit ONLY**: The EBNF file MUST use ASCII 7-bit encoding (0x00-0x7F). Any non-ASCII byte is prohibited. This is aligned with FR-004 and the constitution's encoding constraint.

### Governance

- **Versioning**: The EBNF file should reference the SPEC version it was extracted from (v0.5).
- **Constitution Compliance Check**: This feature is a documentation task with no impact on language semantics or runtime behavior. All relevant constitution constraints are satisfied.

### Gate Assessment

✅ **PASS** — No constitutional violations. The feature is a documentation extraction task with no impact on language runtime, test infrastructure, or cross-target compatibility.

## Project Structure

### Documentation (this feature)

```text
specs/002-extract-ebnf-grammar/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/           # Phase 1 output
└── tasks.md             # Phase 2 output (/speckit.tasks command)
```

### Source Code (repository root)

```text
# No source code changes — single extracted artifact
TheFlux.ebnf             # Extracted EBNF grammar (target output)
```

**Structure Decision**: Single extracted file at project root. No source code modifications needed.

## Complexity Tracking

> No constitution violations to justify.
