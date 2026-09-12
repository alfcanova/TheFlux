# Data Model: Extract EBNF Grammar

**Phase**: 1 — Design & Contracts
**Feature**: Extract EBNF Grammar (002-extract-ebnf-grammar)

## Entities

### EBNF Production

The core entity of the grammar. Each production is a named grammar rule.

| Field | Type | Description | Constraints |
|-------|------|-------------|-------------|
| `name` | Identifier | Production name (snake_case) | Must be unique within the grammar |
| `definition` | Expression | Right-hand side of `::=` | Must be valid ISO EBNF |
| `terminator` | Token | `;` | Required at end of each production |

### EBNF Expression

The right-hand side of a production.

| Type | Syntax | Example |
|------|--------|---------|
| Terminal | `"text"` | `"mut"` |
| Non-terminal | `identifier` | `expression` |
| Alternative | `A \| B` | `"int8" \| "int16"` |
| Repetition | `{ A }` | `{ digit }` |
| Optional | `[ A ]` | `[ "::" type_ref ]` |
| Group | `( A )` | `( "+" \| "-" )` |
| Special sequence | `?text?` | `? ASCII printable ?` |
| Exclusion | `A - B` | `ascii_printable - ( "'" \| "\\" )` |
| Comment | `(* text *)` | `(* struct *)` |

### Source Mapping

Relationship between grammar.md content and the extracted EBNF.

| Element | Source Format | Target Format |
|---------|--------------|---------------|
| Production definition | `name ::= ... ;` | `name ::= ... ;` (preserved) |
| Semantic annotation | `/* ... */` (C-style) | `(* ... *)` (EBNF-style) or removed |
| Multi-line production | Name on separate line from `::=` | Joined into single production |
| Continuation lines | Indented `\|` alternatives | Preserved as EBNF alternatives |
| Section headers | `## Section Title` | Removed |
| Implementation notes | `/* NOTA DE IMPLEMENTACAO ... */` | Removed |
| ASCII tables | Markdown table | Removed |

## Validation Rules

| Rule | Description | Requirement |
|------|-------------|-------------|
| V-001 | Every production must end with `;` | FR-002 |
| V-002 | All non-terminals must reference defined productions | FR-001 |
| V-003 | File must be ASCII 7-bit | FR-004 |
| V-004 | No Markdown formatting artifacts | FR-003 |
| V-005 | File must be at project root as `TheFlux.ebnf` | FR-005 |
