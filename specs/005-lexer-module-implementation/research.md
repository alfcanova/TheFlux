# Research: Lexer Module Implementation

## Overview

No NEEDS CLARIFICATION markers were present in the feature spec — all technical decisions are directly grounded in the constitution.md, grammar.md, and TheFlux.ebnf reference documents. This research document consolidates the rationale for each architectural choice and the alternatives considered.

---

## 1. Host Language: Python

**Decision**: Python 3.12+

**Rationale**: Explicitly mandated by the constitution ("Host language: Python (interpreter in PATH) — used for the compiler, CLI tooling, and test suite (pytest).")

**Alternatives considered**: Go, Zig, Rust — all designated as auxiliary toolchains only. Using any of them for the lexer would violate constitution Section III (Modular Compilation Infrastructure) by introducing cross-language dependencies in the front-end.

---

## 2. Module Structure: Sub-module Decomposition

**Decision**: Decompose `src/flux_proto/lexer/` into six internal sub-modules:
- `reader.py` — character-level I/O, ASCII validation, line/column tracking
- `keywords.py` — keyword map + identifier classification
- `operators.py` — longest-match operator dispatch table
- `indent.py` — indentation level tracker, INDENT/DEDENT emission
- `interpolation.py` — stateful interpolated string lexer with brace balancing
- `lexer.py` — orchestrator: public `lex()` generator

**Rationale**: FR-022 requires modularity. Each concern has distinct state and complexity. Character reader handles encoding validation; keyword matcher handles a 59-entry keyword set with style prefix detection; operator dispatcher handles longest-match across 50+ operator tokens; indent tracker maintains a stack of levels; interpolation state machine maintains a brace-depth counter. Separating them avoids a monolithic lexer with entangled state machines.

**Alternatives considered**:
- Single monolithic `lexer.py` — simpler initially but harder to test, maintain, and extend with new operators/keywords.
- Class-based state machine — suitable for interpolation but over-engineering for the other sub-modules which are stateless or have minimal state.
- Parser-generator approach (e.g., PLY, ANTLR) — rejected because the language has significant-whitespace, stateful string interpolation, and complex longest-match rules that are easier to express in hand-written code.

---

## 3. Token Model

**Decision**: Use the existing `TokenType` enum and `Token` namedtuple from `src/flux_proto/token.py` (160 lines, already defined). No changes needed.

**Rationale**: The token type set was already defined to cover all 59 keywords, all operators (arithmetic, bitwise, relational, assignment, dataflow), delimiters, structural tokens (EOL, INDENT, DEDENT, EOF), comment/docstring types, and all literal types (INT, FLOAT, COMPLEX, DATETIME, STRING, CHAR, INTERPOLATED_*). The Token namedtuple carries (type, lexeme, line, column) — sufficient for error reporting and parser consumption.

**Alternatives considered**:
- Dataclass for Token — more overhead, no benefit for a simple 4-field value type.
- Plain tuple — less readable, no named access.

---

## 4. Longest-Match Operator Resolution

**Decision**: Prefix-tree (trie) over multi-character operator strings, scanning from the current position and matching the longest possible operator before falling back to single-character operators or identifiers.

**Rationale**: The grammar.md Section 5 specifies exact longest-match priorities: `-->` before `-`, `==>` before `==` before `=`, `>>>` before `>>`, `..` before `.`, `::` before `:`. A trie structure ensures O(k) matching where k is operator length, and the ordering of insertion guarantees longest-match when the full trie path is walked.

**Alternatives considered**:
- Sorted list of operator strings checked by length descending — O(n * k) where n = number of operators. Works for 50 operators but slower.
- Char-by-char dispatch with nested if/elif — workable but less maintainable.
- Regex union — ambiguous for longest-match (alternation order-dependent).

---

## 5. Indentation Tracking

**Decision**: Maintain a stack of indentation levels (number of leading spaces on non-blank, non-comment lines). Only spaces count; tabs are rejected before indentation analysis. A jump of exactly +6 emits INDENT; a jump of -6 emits DEDENT; any other delta (including +12, +3, -3, 0 with spaces mismatch) is a TabulationError. Inside `()` and `[]`, indentation tracking is suspended.

**Rationale**: The grammar.md Section 4 specifies "1 nivel = exatamente 6 espacos", "Saltos > 1 nivel sao rejeitados", "eol/indent/dedent suprimidos dentro de () e []". The constitution prohibits tabs.

**Alternatives considered**:
- Flexible indentation width (like Python) — rejected by constitution (exactly 6 spaces).
- Using a counter instead of a stack — insufficient for multi-level dedent.

---

## 6. String Interpolation

**Decision**: Stateful lexer with a brace-depth counter. When `"` is encountered after a lexeme that should trigger string mode, enter `INTERPOLATED_STRING_START`. Emit `INTERPOLATED_TEXT` for literal text until `#{` is found. On `#{`, emit `INTERPOLATION_OPEN` and increment brace depth, then continue in expression-lexing mode tracking `{`/`}` balance. On reaching balance (depth back to zero), emit `INTERPOLATION_CLOSE`. Continue until closing `"` emits `INTERPOLATED_STRING_END`.

**Rationale**: FR-013 + grammar.md Section 7 defines the interpolation token sequence. Balanced `{}` tracking is essential because `#{if x > 0 then {1}}` contains nested braces.

**Alternatives considered**:
- Regex-based extraction — impossible to correctly balance `{}` in general.
- Recursive descent — too heavy for the lexer; parser handles expression nesting.
- Simple scan for `#{` and `}` — insufficient for `{` inside strings or nested braces.

---

## 7. Error Reporting

**Decision**: `LexicalError` exception carrying `.code` (e.g. `"LEX001"`), `.line`, `.column`, `.message` strings. The `lex()` generator yields tokens incrementally; on encountering a fatal error, it raises `LexicalError` and stops. Recovery modes (error tokens, skipping) are deferred.

**Rationale**: Fatal error on first invalid byte/construct is safer than error recovery for a language compiler. The constitution mandates "LEX001 fatal error" for any byte >0x7F. The existing cli.py already catches `LexicalError` and formats the diagnostic.

**Alternatives considered**:
- Yield error tokens — would allow partial parsing but violates the "fatal error" principle for encoding violations.
- Accumulate errors and continue — risky for encoding; subsequent errors cascade.

---

## 8. Auxiliary Toolchain Integration (WASM / WABT / Wasmer)

**Decision**: During pytest integration tests, shell out to:
- `wasmer` for executing `.wasm` files and verifying output matches interpreter/VM results
- `wat2wasm` from WABT for assembling `.wat` → `.wasm`
- `wasm-interp` from WABT for deterministic WASM interpretation in test assertions

**Rationale**: These tools (confirmed on PATH by user) provide cross-target validation without embedding a WASM runtime in Python. The lexer itself does not depend on them — they are test infrastructure only.

**Alternatives considered**:
- Embed wasmer Python bindings — possible but adds build dependency; shell-out suffices for CI.
- Skip WASM validation — violates constitution's Multi-Target Synchronization principle.

---

## 9. LLVM / Clang Integration

**Decision**: LLVM output is generated by the downstream LLVM backend (separate module). The lexer does not interact with LLVM. The `cli.py` entry point for `--target llvm` calls into `flux_proto.llvm.codegen` after lexing+parsing. No direct dependency.

**Rationale**: The lexer's responsibility ends at the token stream. LLVM interaction is strictly a backend concern.

---

## 10. Zig / Rust / Go Availability

**Decision**: These auxiliary toolchains are reserved for:
- **Rust**: Potential WASM polyfill or native component that bridges performance gaps (currently no need in lexer)
- **Zig**: Potential cross-compilation helper for LLVM backend (out of scope)
- **Go**: Potential CLI tooling or build system integration (out of scope)
The lexer itself is pure Python.

**Rationale**: Per constitution Section III, these are auxiliary toolchains. The lexer is a straightforward character-processing task well within Python's performance envelope.

## Decision Summary

| # | Domain | Decision | Source |
|---|--------|----------|--------|
| 1 | Host language | Python 3.12+ | Constitution §Technology Stack |
| 2 | Module decomposition | 6 sub-modules (reader, keywords, operators, indent, interpolation, lexer) | FR-022 + modularity principle |
| 3 | Token model | Existing TokenType enum + Token namedtuple | `token.py` (already defined) |
| 4 | Operator matching | Prefix-tree (trie) over operator strings | grammar.md §5 priority rules |
| 5 | Indentation | Stack-based, 6-space units, tabs rejected | grammar.md §4 + constitution |
| 6 | String interpolation | Stateful brace-depth counter + expression-mode delegation | FR-013 + grammar.md §7 |
| 7 | Error handling | LexicalError exception with code/line/col/message | Constitution LEX001 + cli.py pattern |
| 8 | WASM validation | wasmer.exe + wabt (PATH) via pytest shell-out | User confirmation |
| 9 | LLVM interaction | None (lexer is front-end only) | Architecture boundary |
| 10 | Zig/Rust/Go | Reserved for future performance-critical components | Constitution §Auxiliary toolchains |
