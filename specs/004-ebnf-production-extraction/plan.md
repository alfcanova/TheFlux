# Implementation Plan: EBNF Production Extraction

**Branch**: `004-ebnf-production-extraction` | **Date**: 2026-07-22 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/004-ebnf-production-extraction/spec.md`

## Summary

Extract all EBNF grammar productions from `docs/grammar.md` (sections 1-12 and 14) into a standalone `docs/TheFlux.ebnf` file, using `;` as the definitive production terminator. Productions may span multiple lines; the extractor accumulates body text across newlines until a `;` is found. Output must be ASCII 7-bit encoded with zero Markdown artifacts.

## Technical Context

**Language/Version**: Python 3.x (interpreter in PATH per constitution)

**Primary Dependencies**: None (stdlib only — `re` for regex, `pathlib` for file ops)

**Storage**: N/A — single file output at `docs/TheFlux.ebnf`

**Testing**: Manual validation via production count check (>= 200), ASCII encoding check, and artifact detection

**Target Platform**: Windows 10/11 (development environment)

**Project Type**: Documentation artifact extraction script

**Performance Goals**: N/A (single-pass extraction, < 2s)

**Constraints**: ASCII 7-bit encoding only; output must be valid ISO EBNF; zero Markdown artifacts

**Scale/Scope**: Single file extraction from `docs/grammar.md` (1735 lines, ~209 EBNF productions across sections 1-12 plus section 14 diagnostics)

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
specs/004-ebnf-production-extraction/
├── plan.md              # This file (/speckit.plan command output)
├── research.md          # Phase 0 output (/speckit.plan command)
├── data-model.md        # Phase 1 output (/speckit.plan command)
├── quickstart.md        # Phase 1 output (/speckit.plan command)
├── contracts/           # Phase 1 output (/speckit.plan command)
└── tasks.md             # Phase 2 output (/speckit.tasks command)
```

### Source Code (repository root)

```text
docs/
├── grammar.md           # Source grammar documentation (1735 lines)
└── TheFlux.ebnf         # Extracted EBNF grammar (target output)
```

**Structure Decision**: Single extracted file under `docs/` alongside the source `grammar.md`. The extraction script lives in the spec directory as part of the feature implementation.

## Complexity Tracking

> No constitution violations to justify.
