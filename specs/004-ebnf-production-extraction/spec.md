# Feature Specification: EBNF Production Extraction

**Feature Branch**: `004-ebnf-production-extraction`

**Created**: 2026-07-22

**Status**: Draft

**Input**: User description: "leia o aruivos grammar.md e prepare a extração das regras ebnf para a linguagem TheFlux. Uma linha do arquivo terminar ao encontrar o caractere ';', observe: 'letter               ::= lower_letter | upper_letter ;' enquanto que 'nonzero_digit        ::= "1" | "2" | "3" | "4" | "5"' não encerrou e abaixo temos '                       | "6" | "7" | "8" | "9" ;' que finaliza a linha"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Extract EBNF Productions from grammar.md (Priority: P1)

A developer or documentation maintainer wants to extract all EBNF grammar productions from `docs/grammar.md` into a standalone, machine-readable EBNF file. The extractor must recognize that each production is terminated by `;` and may span multiple lines. The core challenge is distinguishing production bodies from narrative text, C-style comments, and Markdown formatting.

**Why this priority**: This is the foundational capability — without proper extraction, no downstream analysis or tooling can work.

**Independent Test**: Run the extractor against grammar.md. Verify that the output file contains all productions where each entry is a complete `name ::= body ;` form, with no truncated multi-line productions and no narrative text artifacts.

**Acceptance Scenarios**:

1. **Given** a production defined on a single line, **When** the extractor processes it, **Then** the output contains the complete production with its terminating `;`.
2. **Given** a production spanning multiple lines, **When** the extractor processes it, **Then** the output contains the complete production body accumulated up to the terminating `;`.
3. **Given** narrative text, Markdown tables, or section headers, **When** the extractor encounters them, **Then** they are excluded from the output.

---

### User Story 2 - Validate Extracted Output (Priority: P1)

A quality assurance engineer needs to verify that the extracted EBNF file is clean, complete, and conforms to project standards before it can be used as a reference artifact.

**Why this priority**: Validation ensures the extraction is trustworthy for documentation, code generation, or analysis.

**Independent Test**: Run the validation suite against the extracted EBNF output. Confirm ASCII encoding, production count above minimum threshold, and absence of Markdown artifacts.

**Acceptance Scenarios**:

1. **Given** the extracted EBNF file, **When** checked for ASCII 7-bit encoding, **Then** zero non-ASCII bytes are found.
2. **Given** the extracted EBNF file, **When** production count is verified, **Then** at least 200 productions are present.
3. **Given** the extracted EBNF file, **When** scanned for Markdown artifacts, **Then** no section headers, table rows, or list markers are present.

---

### User Story 3 - Grammar Analysis Document (Priority: P2)

A language designer or technical writer wants a domain-organized analysis of all extracted productions, classified by grammar domain with purpose descriptions and cross-references to source locations.

**Why this priority**: The analysis provides a navigable reference that makes the grammar accessible to contributors and consumers.

**Independent Test**: Create the analysis document and verify that all extracted productions are referenced at least once, grouped by domain, and cross-referenced to grammar.md sections.

**Acceptance Scenarios**:

1. **Given** the analysis document, **When** checked for domain coverage, **Then** all 7 grammar domains (Lexical, Types, Expressions, Statements, Declarations, Module Structure, Diagnostics) are documented.
2. **Given** the analysis document, **When** checked for production references, **Then** all productions from the EBNF output are referenced.
3. **Given** the analysis document, **When** reviewed for semantic constraints, **Then** constraints enforced outside the formal grammar are annotated.

---

### Edge Cases

- What happens when a production name appears on a separate line from its `::=` token? The extractor must join them.
- What happens when a production body contains embedded C-style comments (`/* ... */`)? They must be converted to EBNF comments (`(* ... *)`) or stripped.
- What happens when a production uses special EBNF sequences (`?...?`)? They must be preserved in the output.
- What happens when a production terminates with `;` inside a string literal? The `;` inside quotes must not be treated as a terminator.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The extractor MUST read `docs/grammar.md` and identify all EBNF productions within sections 1-12 (and optionally section 14).
- **FR-002**: The extractor MUST treat the `;` character as the production terminator — production parsing continues across newlines until `;` is found.
- **FR-003**: The extractor MUST join production names and their `::=` token when they appear on separate lines.
- **FR-004**: The output MUST be ASCII 7-bit encoded per the project constitution.
- **FR-005**: The output MUST contain at least 200 productions.
- **FR-006**: The extractor MUST exclude Markdown artifacts (section headers, table rows, bullet lists, horizontal rules) from the output.
- **FR-007**: The extractor MUST exclude narrative text (sentences, paragraphs, explanations) from the output.
- **FR-008**: The extractor MUST handle continuation lines (indented alternatives, `|` operator across lines) as part of the same production.
- **FR-009**: The extractor MUST preserve EBNF special sequences (`?...?`) in the output.
- **FR-010**: The extractor MUST provide validation helpers: production count verification, ASCII encoding check, and Markdown artifact detection.
- **FR-011**: A grammar analysis document MUST be generated listing all extracted productions organized by domain with purpose descriptions and cross-references.

### Key Entities *(include if feature involves data)*

- **Production**: A single EBNF rule consisting of a name, `::=` separator, body (alternatives, sequences, terminals, non-terminals), and `;` terminator.
- **Production Name**: The left-hand side identifier of a production (e.g., `expression`, `literal`, `type_ref`).
- **Production Body**: The right-hand side of a production, containing terminals, non-terminals, operators, and special sequences.
- **Domain**: A logical grouping of related productions (Lexical, Types, Expressions, Statements, Declarations, Module Structure, Diagnostics).
- **Narrative Text**: Explanatory prose, comments, or documentation in grammar.md that is not part of any EBNF production.
- **Markdown Artifact**: Section headers, table rows, list items, and horizontal rules from the source Markdown file.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: The extracted EBNF file contains exactly 209 (or more) complete productions with no truncated multi-line entries.
- **SC-002**: The output file contains zero non-ASCII bytes.
- **SC-003**: The output file contains zero Markdown artifacts (table rows, section headers, bullet lists).
- **SC-004**: The extraction completes in under 5 seconds for a 1700+ line input file.
- **SC-005**: The analysis document references every extracted production at least once across all defined domains.
- **SC-006**: A developer can identify which grammar.md section defines any given production within 30 seconds using the analysis document.

## Assumptions

- The source file `docs/grammar.md` exists and contains sections 1-12 (grammar body) followed by narrative sections (13+).
- Productions follow the pattern `name ::= body ;` where `;` is the definitive line terminator.
- Productions may contain C-style block comments (`/* ... */`) that should be converted to or replaced by EBNF-style comments.
- The `;` character only appears as a production terminator, not inside production bodies or terminal strings.
- The project requires ASCII 7-bit encoding for all source artifacts per the project constitution.
- The extractor implementation uses Python 3 with standard library only (no external dependencies).

## Notes

- This feature focuses on correct `;`-terminated multi-line production parsing, which is the key insight from the user description. The previous EBNF analysis feature (003) assumed line-by-line extraction; this specification clarifies the semicolon-termination semantics.
