# Grammar Contract: TheFlux EBNF

## Contract Type

Formal grammar specification — ISO EBNF (ISO 14977)

## File

`docs/TheFlux.ebnf`

## Purpose

Defines the complete syntax of the TheFlux language. This is the authoritative grammar reference for parser implementations (Python prototype, Rust production parser, etc.).

## Format Rules

| Rule | Specification |
|------|---------------|
| Encoding | ASCII 7-bit (0x00-0x7F) |
| Production separator | `::=` |
| Terminator | `;` |
| Alternatives | `\|` |
| Repetition (0+) | `{ }` |
| Option | `[ ]` |
| Grouping | `( )` |
| Terminal | `"text"` |
| Special sequence | `?text?` |
| Comment | `(* text *)` |
| Exclusion | `A - B` |

## Consumers

- Parser implementation (`src/flux_proto/parser/`)
- Lexer implementation (`src/flux_proto/lexer/`)
- Grammar documentation readers
- Parser generator tooling

## Versioning

The EBNF file header includes the SPEC version it was extracted from.
