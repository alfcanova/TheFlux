# Implementation Plan: EBNF Spec Analysis

**Branch**: `003-ebnf-spec-analysis` | **Date**: 2026-07-22 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/003-ebnf-spec-analysis/spec.md`

## Summary

Analyze `docs/grammar.md` to identify and categorize all EBNF productions that form the TheFlux language grammar specification. Extract the productions into a standalone `docs/TheFlux.ebnf` file using Python, organized by grammar domain (lexical, types, expressions, statements, declarations, module structure, diagnostics).

## Technical Context

**Language/Version**: Python 3.x (interpreter in PATH per constitution)

**Primary Dependencies**: None (stdlib only — `re` for regex, `pathlib` for file ops)

**Storage**: N/A — single file output at `docs/TheFlux.ebnf`

**Testing**: Manual validation via production count check, ASCII encoding check, and cross-reference against grammar.md sections 1-12

**Target Platform**: Windows 10/11 (development environment)

**Project Type**: Documentation artifact extraction and analysis

**Performance Goals**: N/A (single-pass extraction, < 2s)

**Constraints**: ASCII 7-bit encoding only; output must be valid ISO EBNF; zero Markdown artifacts

**Scale/Scope**: Single file extraction from grammar.md (1735 lines, ~209 EBNF productions across sections 1-12)

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Impact |
|-----------|--------|
| I. Multi-Target Synchronization | Not applicable — documentation artifact |
| II. Zero-Regression Automated Testing | Partially applicable — output file should be validated |
| III. Modular Compilation & Test Infrastructure | Not applicable |
| IV. Cross-Target Feature Parity | Not applicable |
| V. Dataflow & Agent-Oriented Architecture | Not applicable |
| **ASCII 7-bit encoding** | MUST be enforced — FR-004 and constitution alignment |
| **Governance** | EBNF file must reference SPEC version (v0.5) |

**Gate Assessment**: ✅ PASS — No constitutional violations. Documentation task with no impact on language runtime, test infrastructure, or cross-target compatibility.

## Project Structure

### Documentation (this feature)

```text
specs/003-ebnf-spec-analysis/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/           # Phase 1 output
└── tasks.md             # Phase 2 output (/speckit.tasks command)
```

### Source Code (repository root)

```text
docs/
├── grammar.md           # Source grammar documentation (1735 lines)
└── TheFlux.ebnf         # Extracted EBNF grammar (target output)
```

**Structure Decision**: Single extracted file under `docs/` alongside the source `grammar.md`.

## Complexity Tracking

> No constitution violations to justify.
