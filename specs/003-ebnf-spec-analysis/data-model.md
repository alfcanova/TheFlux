# Data Model: EBNF Spec Analysis

**Phase**: 1 — Design & Contracts
**Feature**: EBNF Spec Analysis (003-ebnf-spec-analysis)

## Entities

### Grammar Domain

A logical grouping of related EBNF productions.

| Domain | Sections in grammar.md | Production Count | Description |
|--------|----------------------|-----------------|-------------|
| Lexical | 1-6 | ~60 | Characters, identifiers, keywords, operators, comments, literals |
| Types | 8 | ~14 | Built-in types, tensor types, type references |
| Expressions | 9 | ~33 | Operator precedence hierarchy, primary expressions, patterns |
| Statements | 10 | ~14 | Control flow, routing, iteration, emit, unsafe blocks |
| Declarations | 11 | ~35 | Struct, enum, contract, agent, function, variable, macro, use |
| Module Structure | 12 | ~12 | `.flux` and `.fdsl` file structure, documented declarations |
| Diagnostics | 14 | ~7 | Error codes and diagnostic format |

### EBNF Production

| Field | Type | Description |
|-------|------|-------------|
| `name` | Identifier | Production name (snake_case) |
| `definition` | Expression | Right-hand side of `::=` |
| `domain` | GrammarDomain | Primary domain assignment |
| `is_core` | Boolean | Core language construct vs. syntactic sugar |
| `has_semantic_constraint` | Boolean | Has constraints enforced outside grammar |
| `line_start` | Integer | Starting line in grammar.md |
| `section` | Integer | Section number in grammar.md |

### Semantic Constraint

Rules enforced by semantic analysis, not by the parser.

| Constraint | Scope | Enforced By |
|------------|-------|-------------|
| Capitalization rules | Identifiers | Semantic analysis (SUGGESTION diagnostic) |
| 6-space indentation | All blocks | Lexer (TabulationError) |
| ASCII 7-bit | All source | Pre-processor (LEX001) |
| Ownership (move/borrow/keep) | Variables | Semantic analysis |
| Contract↔Agent binding | Declarations | Semantic analysis |
| `emit` terminal path | Functions | Semantic analysis |
| `break`/`continue` scope | Statements | Semantic analysis |
| `op` nesting | Agent body | Semantic analysis |

## Validation Rules

| Rule | Description | Source |
|------|-------------|--------|
| V-001 | Every EBNF production must end with `;` | ISO EBNF standard |
| V-002 | All non-terminals referenced must have a defining production | Grammar completeness |
| V-003 | Output file must be ASCII 7-bit | Constitution / FR-004 |
| V-004 | No Markdown or C-comment artifacts in output | FR-003 |
| V-005 | Output file path: `docs/TheFlux.ebnf` | User specification |
