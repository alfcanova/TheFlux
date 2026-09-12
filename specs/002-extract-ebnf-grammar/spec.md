# Feature Specification: Extract EBNF Grammar

**Feature Branch**: `002-extract-ebnf-grammar`

**Created**: 2026-07-22

**Status**: Draft

**Input**: User description: "leia o arquivo grammar.md e faça a extração do arquivo EBNF para TheFlux.ebnf"

## User Scenarios & Testing

### User Story 1 - Standalone EBNF File for Tooling and Reference (Priority: P1)

As a developer working with the TheFlux language, I want a standalone `TheFlux.ebnf` file containing only the EBNF grammar rules extracted from `docs/grammar.md`, so that I can use it with parser generators, validators, and as a concise reference.

**Why this priority**: This is the core deliverable — without the standalone EBNF file, the feature has no value.

**Independent Test**: The `TheFlux.ebnf` file can be validated by checking that all EBNF productions from grammar.md (sections 1-12) are present and syntactically well-formed.

**Acceptance Scenarios**:

1. **Given** the `docs/grammar.md` file with 1735 lines of grammar documentation, **When** the extraction script runs, **Then** a `TheFlux.ebnf` file is generated containing only EBNF productions.
2. **Given** the `TheFlux.ebnf` file, **When** inspected, **Then** no Markdown, comments, implementation notes, or ASCII tables are present — only EBNF production rules and EBNF-style comments (`(* ... *)`).
3. **Given** the `TheFlux.ebnf` file, **When** compared against the original grammar.md, **Then** every EBNF production from the original is present in the standalone file.
4. **Given** the `TheFlux.ebnf` file, **When** parsed by an EBNF validator, **Then** all productions conform to ISO EBNF syntax.

---

### Edge Cases

- What happens when a production spans multiple lines in the original Markdown?
- How does the extraction handle productions with embedded implementation notes (comment blocks inside `/* ... */`)?
- How are productions with alternative definitions separated by `|` across multiple lines handled?

## Requirements

### Functional Requirements

- **FR-001**: The extracted `TheFlux.ebnf` MUST contain all EBNF productions from `docs/grammar.md` sections 1-12.
- **FR-002**: Productions MUST be formatted as valid ISO EBNF (`::=` separator, `|` for alternatives, `{ }` for repetition, `[ ]` for optional, `" "` for literals).
- **FR-003**: EBNF comments (`(* ... *)`) MUST be preserved for semantic annotations while Markdown-specific formatting MUST be removed.
- **FR-004**: The file MUST be ASCII 7-bit encoded (matching the language encoding constraint).
- **FR-005**: The file MUST be placed at the project root as `TheFlux.ebnf`.

### Key Entities

- **EBNF Production**: A grammar rule in the form `name ::= expression ;`
- **EBNF Expression**: A combination of terminals, non-terminals, and operators

## Success Criteria

### Measurable Outcomes

- **SC-001**: All EBNF productions from grammar.md sections 1-12 are present in TheFlux.ebnf (zero omissions).
- **SC-002**: The file is parsable as valid ISO EBNF syntax.
- **SC-003**: Zero Markdown artifacts remain in the output (no `##`, `- ` bullet lists, HTML comments, or ASCII tables).
- **SC-004**: The file compiles/validates with a standard EBNF parser without syntax errors.

## Assumptions

- The EBNF extraction is a one-time manual extraction from the existing grammar.md, not a live sync from source code.
- The `TheFlux.ebnf` file will be maintained as a reference artifact and may need manual updates when the grammar changes.
- EBNF-style comments `(* ... *)` are preferred over C-style `/* ... */` for the output.
- Implementation notes, pipeline descriptions, ASCII tables, and Markdown formatting from grammar.md should NOT be included in the EBNF file.
