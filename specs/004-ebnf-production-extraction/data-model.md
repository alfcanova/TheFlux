# Data Model: EBNF Production Extraction

**Phase**: 1 — Design & Contracts
**Date**: 2026-07-22

## Entities

### Production

Represents a single EBNF grammar rule.

| Field | Type | Description |
|-------|------|-------------|
| `name` | `string` | Left-hand side identifier (e.g., `expression`, `literal`) |
| `body` | `string` | Right-hand side content (terminals, non-terminals, operators, sequences) |
| `terminator` | `";"` | Production end marker (semicolon) |
| `source_section` | `int` | grammar.md section number where the production is defined |
| `domain` | `GrammarDomain` | Logical grouping domain |
| `classification` | `"core"|"auxiliary"` | Whether the production is syntactically required (core) or a helper/abstraction (auxiliary) |
| `constraints` | `string[]` | Semantic constraints enforced outside the formal grammar |

**Validation Rules**:
- `name` must match `[a-z_][a-z0-9_]*` (lowercase/snake_case EBNF convention)
- `body` must not contain unpaired `;` (semicolons inside string literals or special sequences are allowed)
- Production must end with `;`

### GrammarDomain

| Value | Description | Sections | Approx. Production Count |
|-------|-------------|----------|--------------------------|
| `Lexical` | Characters, identifiers, comments, lexing, keywords, operators, literals | 1-7 | ~60 |
| `Types` | Scalar types, tensor types, type references | 8 | ~14 |
| `Expressions` | Precedence hierarchy, primaries, patterns, postfix | 9 | ~53 |
| `Statements` | Block structure, control flow, route, emit, unsafe | 10 | ~21 |
| `Declarations` | Struct, enum, macro, variable, function, contract, agent, op | 11 | ~40 |
| `ModuleStructure` | File-level organization, documented declarations | 12 | ~12 |
| `Diagnostics` | Diagnostic format, error codes, message structure | 14 | ~9 |

### SourceSection

Represents a numbered section in `docs/grammar.md`.

| Field | Type | Description |
|-------|------|-------------|
| `number` | `int` | Section number (1-15) |
| `title` | `string` | Section title |
| `start_line` | `int` | Approximate starting line in grammar.md |
| `has_productions` | `bool` | Whether the section contains EBNF productions |
| `domain` | `GrammarDomain` | Domain assigned to this section's productions |

## State Machine

The extraction process follows a simple state machine:

```
INITIAL → IN_PRODUCTION → COLLECTING → TERMINATED
```

1. **INITIAL**: Scanning for production start (name line or `name ::=` pattern)
2. **IN_PRODUCTION**: Name identified, expecting `::=` or body
3. **COLLECTING**: Accumulating body text across lines
4. **TERMINATED**: `;` found — production is complete, emit to output

Transitions:
- INITIAL → IN_PRODUCTION: When a line matches `^[a-z_]+$` or `^[a-z_]+ ::=`
- IN_PRODUCTION → COLLECTING: When `::=` is seen
- COLLECTING → TERMINATED: When `;` is found in body
- Any state → INITIAL: When narrative text, Markdown artifact, or section header is detected
