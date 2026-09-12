# Feature Specification: EBNF Spec Analysis

**Feature Branch**: `003-ebnf-spec-analysis`

**Created**: 2026-07-22

**Status**: Draft

**Input**: User description: "leia o arquivo grammar.md, faça um análise e determine o que pode compor a especificação EBNF da linguagem TheFlux"

## User Scenarios & Testing

### User Story 1 - Documented EBNF Grammar Structure for TheFlux (Priority: P1)

As a language designer or compiler developer working with TheFlux, I want a complete, documented analysis of all grammar constructs that form the EBNF specification, so that I can understand the language syntax structure and use it as reference for parser implementation.

**Why this priority**: This is the core deliverable — without the grammar analysis document, the feature has no value.

**Independent Test**: The analysis document can be validated by cross-referencing each identified grammar construct against the source `docs/grammar.md` to ensure complete coverage.

**Acceptance Scenarios**:

1. **Given** the `docs/grammar.md` file with all EBNF productions, **When** the analysis is complete, **Then** every grammar construct is categorized by domain (lexical, types, expressions, declarations, etc.).
2. **Given** the analysis document, **When** reviewed, **Then** each construct includes its EBNF production name, purpose, and usage context.
3. **Given** the analysis, **When** compared against the existing `TheFlux.ebnf` file, **Then** all extracted productions are accounted for in the analysis.

---

### User Story 2 - Grammar Domain Map (Priority: P2)

As a developer new to TheFlux, I want a domain-organized map of all grammar rules, so that I can quickly find which EBNF productions are relevant to a specific language feature.

**Why this priority**: Improves navigability of the grammar reference.

**Independent Test**: Each grammar domain maps to a section in grammar.md — coverage can be verified by section-cross-reference.

**Acceptance Scenarios**:

1. **Given** the grammar domains identified, **When** a developer searches for a specific construct (e.g., "expressions"), **Then** the domain map shows all relevant productions.
2. **Given** the domain map, **When** validated against grammar.md, **Then** all sections 1-12 are represented.

---

### Edge Cases

- How are productions that span multiple sections categorized?
- How are productions that belong to multiple domains (e.g., `literal` is both a lexical and expression construct) handled?
- What about productions documented in implementation notes but not formally part of the grammar?

## Requirements

### Functional Requirements

- **FR-001**: The analysis MUST identify and list all EBNF productions from `docs/grammar.md` sections 1-12.
- **FR-002**: Productions MUST be organized into logical domains: Lexical, Types, Expressions, Statements, Declarations, Module Structure, Diagnostics.
- **FR-003**: Each production MUST include: name, EBNF definition, purpose description, and cross-reference to grammar.md line number.
- **FR-004**: The analysis MUST identify which productions are core (essential for language) vs. auxiliary (sugar, syntactic conveniences).
- **FR-005**: The analysis MUST note productions that have semantic constraints enforced outside the grammar (e.g., capitalization rules, ownership rules).

### Key Entities

- **Grammar Production**: A single EBNF rule `name ::= definition ;`
- **Grammar Domain**: A logical grouping of related productions (e.g., "Expression", "Type System")
- **Semantic Constraint**: A rule enforced by semantic analysis, not by the grammar itself

## Success Criteria

### Measurable Outcomes

- **SC-001**: All 209 EBNF productions from sections 1-12 are identified and categorized in the analysis.
- **SC-002**: Each production is assigned to exactly one primary domain (with secondary cross-references where needed).
- **SC-003**: Productions with semantic-only constraints (not syntax) are clearly marked.
- **SC-004**: The analysis document is structured for quick reference by domain.

## Assumptions

- The analysis is based on grammar.md Snapshot RC: 2026-07-20 (SPEC 0.5, CLI 0.5.0).
- The existing `TheFlux.ebnf` extracted file is the reference for production count (209 productions).
- Production categorization follows language design conventions (lexer → parser → semantic → codegen pipeline order).
- Implementation notes within grammar.md that describe future/planned features are noted but not included in the core grammar.
