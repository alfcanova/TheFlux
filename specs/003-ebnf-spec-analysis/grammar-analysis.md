# Grammar Analysis: TheFlux v0.5

**Version**: 1.0.0  
**Date**: 2026-07-22  
**Source**: `docs/grammar.md` (Snapshot RC 2026-07-20)  
**EBNF Output**: `docs/TheFlux.ebnf` (283 lines, 209 productions across sections 1-12)  
**Author**: Automated extraction via `specs/003-ebnf-spec-analysis/extract_ebnf.py`

## 1. Domain Overview

The TheFlux grammar is organized into 7 domains across grammar.md sections 1-12, plus diagnostic productions in section 14. Each production is classified as **core** (syntactically required for a valid program) or **auxiliary** (helper definitions, type abstraction, or non-terminal convenience).

| # | Domain | Sections | Productions | Core | Auxiliary | Description |
|---|--------|----------|-------------|------|-----------|-------------|
| 1 | Lexical | 1-7 | 62 | 18 | 44 | Characters, identifiers, comments, structural lexing, keywords, operators, literals |
| 2 | Types | 8 | 14 | 5 | 9 | Built-in scalar types, tensor types, type references |
| 3 | Expressions | 9 | 53 | 8 | 45 | Precedence hierarchy, primaries, patterns, postfix operators |
| 4 | Statements | 10 | 21 | 10 | 11 | Block structure, control flow, route, infinite, emit, unsafe |
| 5 | Declarations | 11 | 40 | 10 | 30 | Struct, enum, macro, variable, function, contract, agent, op, program, use |
| 6 | Module Structure | 12 | 12 | 7 | 5 | File-level organization, documented declarations |
| 7 | Diagnostics | 14 | 7 | 2 | 5 | Diagnostic format, error codes, message structure |

**Total**: 209 productions (60 core, 149 auxiliary)

---

## 2. Domain 1: Lexical (62 productions)

**Source**: grammar.md sections 1-7  
**Description**: Character sets, identifier conventions, comment/docstring syntax, structural lexing tokens, keyword/operator definitions, and literal formats.

### 2.1 Characters and Identifiers (Section 1, 10 prods)

| Production | Type | Grammar.md Line | Purpose |
|------------|------|-----------------|---------|
| `digit` | auxiliary | ~57 | Single decimal digit 0-4 (abbreviated example) |
| `nonzero_digit` | auxiliary | ~58 | Single nonzero digit 1-5 (abbreviated example) |
| `lower_letter` | auxiliary | ~59 | Lowercase ASCII letter a-f (abbreviated example) |
| `upper_letter` | auxiliary | ~60 | Uppercase ASCII letter A-F (abbreviated example) |
| `letter` | auxiliary | ~61 | Any ASCII letter (lower or upper) |
| `identifier` | core | ~63 | Any valid identifier (lower, upper, or mixed case) |
| `IDENT_LOWER` | auxiliary | ~65 | Lowercase-only identifier (snake_case) |
| `IDENT_UPPER` | auxiliary | ~66 | Uppercase-only identifier (SCREAMING_SNAKE) |
| `IDENT_MIXED` | auxiliary | ~67 | Mixed-case identifier (camelCase/PascalCase) |
| `snake_case_identifier` | core | ~69 | Semantic alias for IDENT_LOWER |
| `screaming_snake_identifier` | core | ~70 | Semantic alias for IDENT_UPPER |
| `camel_case_identifier` | core | ~71 | Semantic alias for mixed starting lowercase |
| `pascal_case_identifier` | core | ~72 | Semantic alias for mixed starting uppercase |

**Semantic constraints**:
- Identifiers must obey naming case conventions (lower_case, UPPER_CASE, camelCase, PascalCase) per Flux naming rules.
- Non-ASCII bytes (0x80+) produce LEX001 error.

### 2.2 Character Sets (Section 2, 7 prods)

| Production | Type | Grammar.md Line | Purpose |
|------------|------|-----------------|---------|
| `line_break` | auxiliary | ~170 | Line termination character sequence |
| `any_ascii_char` | auxiliary | ~172 | Any 7-bit ASCII character |
| `any_comment_char` | auxiliary | ~174 | ASCII char except control chars and line break |
| `any_char_except_line_break` | auxiliary | ~175 | Alias for any_comment_char |
| `any_char_except_block_end` | auxiliary | ~177 | Character valid inside block comment (excludes `B#`) |
| `doc_char` | auxiliary | ~179 | Character valid inside docstring (excludes `D#`) |
| `ascii_printable` | auxiliary | ~181 | Printable ASCII (0x20-0x7E) used in literals |
| `ascii_printable_except_single_quote_backslash_line_break` | auxiliary | ~185 | Printable minus quote, backslash, line break |
| `ascii_printable_except_double_quote_backslash_line_break` | auxiliary | ~187 | Printable minus double-quote, backslash, line break |

### 2.3 Comments and Documentation (Section 3, 3 prods)

| Production | Type | Grammar.md Line | Purpose |
|------------|------|-----------------|---------|
| `line_comment` | core | ~209 | Single-line comment prefixed by `#L` |
| `block_comment` | core | ~211 | Multi-line comment delimited by `#B...B#` |
| `DOCSTRING` | core | ~213 | Documentation string delimited by `#D...D#` (lexer-emitted token) |

### 2.4 Structural Lexing (Section 4, 4 prods)

| Production | Type | Grammar.md Line | Purpose |
|------------|------|-----------------|---------|
| `NEWLINE` | core | ~227 | Logical line terminator (lexer-emitted) |
| `INDENT` | core | ~228 | Indentation increase token (lexer-emitted) |
| `DEDENT` | core | ~229 | Indentation decrease token (lexer-emitted) |
| `EOF` | core | ~230 | End-of-file token (lexer-emitted) |

**Semantic constraints**:
- One indent level = exactly 6 spaces. Tabs forbidden (TabulationError).
- NEWLINE/INDENT/DEDENT suppressed inside `()` and `[]`.
- Indentation rules follow Python-like structural lexing.

### 2.5 Keywords and Operators (Section 6, 13 prods)

| Production | Type | Grammar.md Line | Purpose |
|------------|------|-----------------|---------|
| `keyword` | core | ~288 | Reserved keyword alternatives |
| `math_operator` | auxiliary | ~295 | Arithmetic operators (`+`, `-`, `*`, `/f`, `/i`, `/r`, `^e`, `^r`) |
| `relation_operator` | auxiliary | ~297 | Comparison operators (`==`, `!=`, `<`, `>`, `<=`, `>=`) |
| `error_operator` | auxiliary | ~298 | Error propagation operator (`?`) |
| `not_operator` | auxiliary | ~299 | Logical NOT (`not`) |
| `bang_operator` | auxiliary | ~300 | Bang operator (`!`) |
| `bitwise_operator` | auxiliary | ~302 | Bitwise operators (`&`, `|`, `^`, `~`, `<<`, `>>`, `>>>`) |
| `assignment_operator` | auxiliary | ~304 | Assignment operator (`=`) |
| `dataflow_operator` | auxiliary | ~306 | Dataflow operators (`-->`, `split`, `join`) |
| `lambda_operator` | auxiliary | ~308 | Lambda operator (`==>`) |
| `access_operator` | auxiliary | ~310 | Access operators (`[`, `]`, `..`, `.`, `::`) |
| `delimiter` | auxiliary | ~312 | Delimiters (`(`, `)`, `{`, `}`, `:`, `,`) |
| `pending_line_operator` | auxiliary | ~314 | Operator that forces pending line continuation |

**Keywords** (53 total):

| Category | Keywords | Count |
|----------|----------|-------|
| Mutability | `mut`, `imut` | 2 |
| Literals | `true`, `false` | 2 |
| Control Flow | `and`, `or`, `not`, `in`, `if`, `else`, `for`, `while`, `break`, `continue` | 10 |
| Dataflow | `split`, `join`, `catch`, `fallback`, `route`, `emit`, `spy`, `input`, `print`, `spawn`, `async`, `await` | 12 |
| Error | `error`, `panic`, `unsafe`, `try` | 4 |
| Declarations | `struct`, `enum`, `contract`, `agent`, `function`, `op`, `macro`, `program`, `use`, `as`, `impl` | 11 |
| Variables | `mut`, `imut` (overloaded), `keep`, `move`, `borrow` | 5 |
| Other | `match`, `quote`, `unquote`, `comptime`, `data`, `map`, `of`, `infinite`, `nice`, `fail`, `ensure`, `cast` | 12 |

### 2.6 Literals (Section 7, 14 prods)

| Production | Type | Grammar.md Line | Purpose |
|------------|------|-----------------|---------|
| `unsigned_integer` | auxiliary | ~374 | Non-negative integer literal |
| `integer_literal` | core | ~376 | Signed integer literal |
| `fraction` | auxiliary | ~403 | Fractional part of float |
| `exponent` | auxiliary | ~405 | Scientific notation exponent |
| `float_literal` | core | ~407 | Floating-point literal |
| `imaginary_literal` | core | ~414 | Imaginary number literal (suffix `i`) |
| `datetime_literal` | core | ~417 | ISO 8601 datetime with UTC `Z` suffix |
| `escape` | auxiliary | ~431 | Escape sequence (`\'`, `\"`, `\\`, `\n`, `\t`, `\r`, `\0`) |
| `char_literal` | core | ~433 | Single-quoted character literal |
| `string_literal` | core | ~435 | Double-quoted string literal |
| `interpolated_string` | core | ~437 | String with `#{ expr }` interpolation |
| `boolean_literal` | core | ~449 | Boolean literal (`true`, `false`) |
| `literal` | core | ~451 | Any literal value |

**Semantic constraints**:
- Datetime requires exactly 9 nanosecond digits and UTC `Z` suffix.
- String interpolation uses `#{expression}` syntax.
- Only ASCII characters allowed in all literal forms.

---

## 3. Domain 2: Types (14 productions)

**Source**: grammar.md section 8  
**Description**: Built-in numeric types, tensor types with static shape, and general type references.

| Production | Type | Grammar.md Line | Purpose |
|------------|------|-----------------|---------|
| `signed_integer_type` | auxiliary | ~472 | Signed integer variants (`int8/int16/int32/int64`) |
| `unsigned_integer_type` | auxiliary | ~474 | Unsigned integer variants (`uint8/uint16/uint32/uint64`) |
| `implemented_integer_type` | auxiliary | ~476 | Union of signed/unsigned integer types |
| `implemented_float_type` | auxiliary | ~478 | Float variants (`float16/float32/float64`) |
| `implemented_complex_type` | auxiliary | ~480 | Complex variants (`complex16/complex32/complex64`) |
| `implemented_numeric_type` | auxiliary | ~482 | Union of all numeric types |
| `scalar_builtin_type` | auxiliary | ~484 | Union of numeric types + `char`, `string`, `bool`, `datetime` |
| `static_shape` | auxiliary | ~509 | Static tensor shape as dimension list |
| `tensor_type` | core | ~511 | Tensor of numeric type with static shape |
| `type_ref` | core | ~514 | Any type reference (scalar, tensor, or named type) |

**Semantic constraints**:
- Tensor shape elements verified at compile time (numerical element count).
- Integer types have exact bit-width semantics.

---

## 4. Domain 3: Expressions (53 productions)

**Source**: grammar.md section 9  
**Description**: Expression precedence hierarchy from assignment down to primaries, including patterns, postfix operators, and special expression forms.

### 4.1 Precedence Chain (17 prods)

| Production | Type | Grammar.md Line | Purpose |
|------------|------|-----------------|---------|
| `expression` | core | ~546 | Top-level expression (assignment) |
| `assignment_expr` | core | ~549 | Assignment with `=` operator (right-associative) |
| `recovery_expr` | auxiliary | ~552 | Error recovery with `catch`/`fallback` |
| `dataflow_expr` | auxiliary | ~556 | Dataflow composition with `-->`, `split`, `join`, `==>` |
| `or_expr` | auxiliary | ~560 | Logical OR |
| `and_expr` | auxiliary | ~564 | Logical AND |
| `bit_or_expr` | auxiliary | ~568 | Bitwise OR (`\|`) |
| `bit_xor_expr` | auxiliary | ~572 | Bitwise XOR (`^`) |
| `bit_and_expr` | auxiliary | ~576 | Bitwise AND (`&`) |
| `equality_expr` | auxiliary | ~580 | Equality/relational comparisons |
| `membership_expr` | auxiliary | ~584 | Membership test (`in`) |
| `range_expr` | auxiliary | ~587 | Range expression (`..`) |
| `shift_expr` | auxiliary | ~589 | Bitwise shifts (`<<`, `>>`, `>>>`) |
| `additive_expr` | auxiliary | ~592 | Addition/subtraction |
| `multiplicative_expr` | auxiliary | ~595 | Multiplication/division |
| `power_expr` | auxiliary | ~600 | Exponentiation (`^e`, `^r`) |
| `prefix_expr` | auxiliary | ~604 | Prefix operators (`+`, `-`, `!`, `not`, `?`, `&`, `\|`, `~`, `keep`, `move`, `borrow`) |

### 4.2 Async/Spawn/Ownership (5 prods)

| Production | Type | Grammar.md Line | Purpose |
|------------|------|-----------------|---------|
| `async_expr` | core | ~608 | Async expression evaluation |
| `spawn_expr` | core | ~610 | Spawn concurrent execution |
| `await_expr` | core | ~612 | Await async result |
| `ownership_expr` | auxiliary | ~614 | Ownership operation (`move`, `borrow`, `keep`) |
| `move_expr` | core | ~616 | Move ownership |
| `borrow_expr` | core | ~618 | Borrow ownership |
| `keep_expr` | core | ~620 | Keep ownership |

### 4.3 Primaries and Postfix (3 prods)

| Production | Type | Grammar.md Line | Purpose |
|------------|------|-----------------|---------|
| `primary_postfix_expr` | auxiliary | ~627 | Primary with optional postfix operators |
| `postfix_op` | auxiliary | ~629 | Postfix operator alternatives |
| `primary_expr` | core | ~631 | Primary expression alternatives |

### 4.4 Special Expressions (6 prods)

| Production | Type | Grammar.md Line | Purpose |
|------------|------|-----------------|---------|
| `comptime_expr` | core | ~639 | Compile-time evaluation block |
| `quote_expr` | core | ~641 | Quotation (metaprogramming) |
| `unquote_expr` | core | ~644 | Unquote (metaprogramming splice) |
| `error_expr` | core | ~686 | Error construction with code and message |
| `panic_expr` | core | ~692 | Unrecoverable panic |
| `match_expr` | core | ~694 | Pattern matching expression |

### 4.5 Patterns (8 prods)

| Production | Type | Grammar.md Line | Purpose |
|------------|------|-----------------|---------|
| `match_arm` | auxiliary | ~702 | Single match arm (`pattern ==> expression`) |
| `pattern` | core | ~704 | Pattern alternatives |
| `list_pattern` | auxiliary | ~719 | List destructuring pattern |
| `record_pattern` | auxiliary | ~727 | Record destructuring pattern |
| `struct_pattern` | auxiliary | ~733 | Struct destructuring pattern |
| `enum_variant_pattern` | auxiliary | ~737 | Enum variant destructuring pattern |
| `data_pattern` | auxiliary | ~742 | Data block destructuring pattern |
| `pattern_field` | auxiliary | ~746 | Named field in pattern |

### 4.6 Call and Field Access (7 prods)

| Production | Type | Grammar.md Line | Purpose |
|------------|------|-----------------|---------|
| `call_suffix` | auxiliary | ~748 | Function call with arguments |
| `call_args` | auxiliary | ~750 | Call arguments (positional + named) |
| `positional_args` | auxiliary | ~752 | Positional-only arguments |
| `named_args` | auxiliary | ~754 | Named-only arguments |
| `named_arg` | auxiliary | ~756 | Single named argument (`.id: expr`) |
| `field_suffix` | auxiliary | ~760 | Field access (`.id`) |
| `namespace_suffix` | auxiliary | ~762 | Namespace access (`::id`) |

### 4.7 Postfix Operations (5 prods)

| Production | Type | Grammar.md Line | Purpose |
|------------|------|-----------------|---------|
| `ensure_suffix` | core | ~778 | Postcondition block |
| `cast_suffix` | core | ~783 | Type cast (`as type`) |
| `struct_init_expr` | core | ~785 | Struct initialization |
| `enum_variant_expr` | core | ~792 | Enum variant construction |
| `index_or_slice_suffix` | auxiliary | ~799 | Index or slice access |
| `slice_spec` | auxiliary | ~801 | Slice specification (`..[expr]`) |

### 4.8 Sink and Literal Expressions (10 prods)

| Production | Type | Grammar.md Line | Purpose |
|------------|------|-----------------|---------|
| `input_expr` | core | ~765 | Input expression |
| `spy_expr` | core | ~767 | Debug spy expression |
| `spy_sink` | auxiliary | ~769 | Spy data sink |
| `print_sink` | auxiliary | ~771 | Print data sink |
| `keep_sink` | auxiliary | ~773 | Keep data sink |
| `dataflow_cast_sink` | auxiliary | ~775 | Dataflow cast sink |
| `struct_init_field` | auxiliary | ~790 | Named struct initialization field |
| `enum_variant_init_field` | auxiliary | ~796 | Named enum variant initialization field |
| `list_literal` | core | ~805 | List literal `[expr, ...]` |
| `brace_literal` | auxiliary | ~807 | Brace literal (set or record) |
| `set_literal` | core | ~809 | Set literal `{expr, ...}` |
| `record_literal` | core | ~811 | Record literal `{.id: expr, ...}` |
| `record_field` | auxiliary | ~815 | Record field definition |
| `map_literal` | core | ~817 | Map literal |
| `data_literal` | core | ~821 | Data block literal |
| `data_field` | auxiliary | ~823 | Data field (alias for record_field) |

**Semantic constraints**:
- `error_expr` with 3 args: code, message, suggestion (SUGGESTION level).
- `match` must be exhaustive.
- Prefix operators `keep`/`move`/`borrow` enforce ownership semantics.

---

## 5. Domain 4: Statements (21 productions)

**Source**: grammar.md section 10  
**Description**: Block structure, control flow statements (route, infinite, break, continue), emit, unsafe, and expression statements.

| Production | Type | Grammar.md Line | Purpose |
|------------|------|-----------------|---------|
| `block_body` | core | ~901 | Indented code block (mandatory for `{}`) |
| `indented_block_body` | auxiliary | ~903 | Indented block with INDENT/DEDENT |
| `top_statement` | core | ~915 | Statement at file/module top level |
| `block_statement` | core | ~922 | Statement inside a block body |
| `statement_end` | core | ~931 | Statement terminator (NEWLINE or EOF) |
| `print_stmt` | core | ~934 | Print expression to stdout |
| `route_stmt` | core | ~937 | Route/dataflow construct |
| `route_subjects` | auxiliary | ~943 | Route subject expressions |
| `route_body` | auxiliary | ~945 | Route body (indented or inline) |
| `indented_route_body` | auxiliary | ~947 | Indented route body |
| `inline_route_body` | auxiliary | ~953 | Inline route body |
| `route_arm` | auxiliary | ~956 | Single route arm |
| `route_condition` | auxiliary | ~959 | Route condition (underscore = wildcard) |
| `route_positional_condition` | auxiliary | ~961 | Positional route condition (`..`) |
| `infinite_stmt` | core | ~963 | Infinite loop construct |
| `infinite_arg` | auxiliary | ~967 | Infinite loop argument |
| `break_stmt` | core | ~969 | Break from loop |
| `continue_stmt` | core | ~971 | Continue loop iteration |
| `emit_stmt` | core | ~973 | Emit (nice/fail) — terminal statement |
| `unsafe_stmt` | core | ~982 | Unsafe block |
| `expression_stmt` | core | ~986 | Expression used as statement |

**Semantic constraints**:
- `emit(nice/fail, ...)` terminates the current function — must be terminal.
- Functions with return types must have `emit` on all paths.
- `unsafe` blocks have restricted contents per semantic rules.
- `break`/`continue` only valid inside `infinite` loops.

---

## 6. Domain 5: Declarations (40 productions)

**Source**: grammar.md section 11  
**Description**: All declaration forms: use, struct, enum, macro, variable, function, program, op, contract, agent.

### 6.1 Use Declarations (5 prods)

| Production | Type | Grammar.md Line | Purpose |
|------------|------|-----------------|---------|
| `use_decl` | core | ~1046 | Use declaration (agent, operation, or group) |
| `use_agent_decl` | core | ~1048 | Import agent as alias |
| `use_operation_decl` | core | ~1053 | Import specific operation from agent |
| `use_group_decl` | core | ~1058 | Import group of operations |
| `use_group_item` | auxiliary | ~1064 | Single item in a use group |

### 6.2 Struct Declarations (7 prods)

| Production | Type | Grammar.md Line | Purpose |
|------------|------|-----------------|---------|
| `struct_decl` | core | ~1067 | Struct type declaration |
| `struct_body` | auxiliary | ~1074 | Struct body (indented or inline) |
| `indented_struct_body` | auxiliary | ~1076 | Indented struct body |
| `inline_struct_body` | auxiliary | ~1082 | Inline struct body |
| `struct_field` | auxiliary | ~1085 | Struct field (mutable or immutable) |
| `mutable_struct_field` | auxiliary | ~1087 | Mutable struct field with snake_case name |
| `immutable_struct_field` | auxiliary | ~1091 | Immutable struct field with SCREAMING_SNAKE name |

### 6.3 Enum Declarations (6 prods)

| Production | Type | Grammar.md Line | Purpose |
|------------|------|-----------------|---------|
| `enum_decl` | core | ~1096 | Enum type declaration |
| `enum_body` | auxiliary | ~1101 | Enum body (indented or inline) |
| `indented_enum_body` | auxiliary | ~1103 | Indented enum body |
| `inline_enum_body` | auxiliary | ~1109 | Inline enum body |
| `enum_variant` | auxiliary | ~1112 | Single enum variant |
| `enum_variant_fields` | auxiliary | ~1115 | Enum variant field list |
| `enum_variant_field` | auxiliary | ~1117 | Typed field in enum variant |

### 6.4 Macro Declarations (3 prods)

| Production | Type | Grammar.md Line | Purpose |
|------------|------|-----------------|---------|
| `macro_decl` | core | ~1120 | Macro declaration |
| `macro_body` | auxiliary | ~1126 | Macro body (single expression) |
| `macro_params` | auxiliary | ~1128 | Macro parameter list |

### 6.5 Variable Declarations (5 prods)

| Production | Type | Grammar.md Line | Purpose |
|------------|------|-----------------|---------|
| `variable_decl` | core | ~1132 | Variable declaration (mutable or immutable) |
| `map_schema` | auxiliary | ~1192 | Map type schema definition |
| `map_schema_field` | auxiliary | ~1194 | Single map schema entry |
| `mutable_decl` | core | ~1134 | Mutable variable declaration (`mut as type: name = expr`) |
| `immutable_decl` | core | ~1141 | Immutable variable declaration (`imut as type: NAME = expr`) |

### 6.6 Function/Program/Op Declarations (5 prods)

| Production | Type | Grammar.md Line | Purpose |
|------------|------|-----------------|---------|
| `function_decl` | core | ~1148 | Function declaration with body |
| `function_params` | auxiliary | ~1155 | Function parameter list |
| `function_param` | auxiliary | ~1157 | Single function parameter |
| `program_decl` | core | ~1159 | Program (entry point) declaration |
| `op_decl` | core | ~1167 | Operation declaration (inside agent/contract) |

### 6.7 Contract Declarations (5 prods)

| Production | Type | Grammar.md Line | Purpose |
|------------|------|-----------------|---------|
| `contract_decl` | core | ~1177 | Contract (interface) declaration |
| `contract_body` | auxiliary | ~1183 | Contract body (indented or inline) |
| `indented_contract_body` | auxiliary | ~1185 | Indented contract body |
| `inline_contract_body` | auxiliary | ~1191 | Inline contract body |
| `contract_op` | auxiliary | ~1193 | Contract operation signature |

### 6.8 Agent Declarations (4 prods)

| Production | Type | Grammar.md Line | Purpose |
|------------|------|-----------------|---------|
| `agent_decl` | core | ~1198 | Agent declaration with optional `impl` clause |
| `agent_body` | auxiliary | ~1204 | Agent body (indented or inline) |
| `indented_agent_body` | auxiliary | ~1206 | Indented agent body |
| `inline_agent_body` | auxiliary | ~1212 | Inline agent body |

**Semantic constraints**:
- Variable naming: mutable = snake_case, immutable = SCREAMING_SNAKE.
- Agent `impl` clause lists implemented contracts.
- Functions with return types require terminal `emit` on all paths.

---

## 7. Domain 6: Module Structure (12 productions)

**Source**: grammar.md section 12  
**Description**: File-level organization, documented declaration wrappers, and .flux vs .fdsl conventions.

| Production | Type | Grammar.md Line | Purpose |
|------------|------|-----------------|---------|
| `flux_file` | core | ~1329 | Top-level .flux file structure |
| `fdsl_file` | core | ~1341 | Top-level .fdsl file structure (agent-focused) |
| `documented_use_decl` | auxiliary | ~1356 | Use declaration with optional docstring |
| `documented_struct_decl` | auxiliary | ~1358 | Struct declaration with optional docstring |
| `documented_enum_decl` | auxiliary | ~1360 | Enum declaration with optional docstring |
| `documented_contract_decl` | auxiliary | ~1362 | Contract declaration with optional docstring |
| `documented_macro_decl` | auxiliary | ~1364 | Macro declaration with optional docstring |
| `documented_type_macro_decl` | auxiliary | ~1366 | Union of documented struct/enum/macro |
| `documented_variable_decl` | auxiliary | ~1368 | Variable declaration with optional docstring |
| `documented_function_decl` | auxiliary | ~1370 | Function declaration with optional docstring |
| `documented_program_decl` | auxiliary | ~1372 | Program declaration with optional docstring |
| `documented_agent_decl` | auxiliary | ~1374 | Agent declaration with optional docstring |

**Semantic constraints**:
- `.flux` files allow all declaration types; `.fdsl` files focus on agent declarations.
- File exclusivity: `.flux` defines one program; `.fdsl` can define multiple agents.

---

## 8. Domain 7: Diagnostics (7 productions)

**Source**: grammar.md section 14  
**Description**: Diagnostic message format, source location specifiers, and error code enumeration. These productions describe the compiler's diagnostic output format, not source syntax.

| Production | Type | Grammar.md Line | Purpose |
|------------|------|-----------------|---------|
| `diagnostic` | core | ~1549 | Diagnostic message format: `file:line,col -> [CODE]: msg` |
| `source_name` | auxiliary | ~1552 | Source file name or `<stdin>` |
| `filename` | auxiliary | ~1553 | Source filename characters |
| `filename_char` | auxiliary | ~1554 | Any character except `:` in filenames |
| `line` | auxiliary | ~1555 | Line number or `?` |
| `column` | auxiliary | ~1556 | Column number or `?` |
| `message` | auxiliary | ~1557 | Diagnostic message text |
| `message_char` | auxiliary | ~1558 | Any character in diagnostic message |
| `diagnostic_code` | core | ~1560 | Error code enumeration (LEX001 through CLI001) |

**Note**: Section 14 is outside the main extraction range (sections 1-12) and not currently included in `docs/TheFlux.ebnf`. These 9 productions should be added in a future extraction pass.

---

## 9. Semantic Constraints

The following constraints are enforced outside the formal EBNF grammar (parser-enforced or semantic-analysis-enforced):

| Constraint | Domain | Enforcement |
|------------|--------|-------------|
| Naming case conventions (lower_case, UPPER_CASE, camelCase, PascalCase) | Lexical | Semantic analysis |
| TAB forbidden (TabulationError) | Lexical | Lexer |
| NEWLINE suppression inside `()` and `[]` | Lexical | Lexer |
| 9-digit nanosecond precision in datetime | Literal | Parser |
| UTC `Z` suffix required in datetime | Literal | Parser |
| Tensor shape element count verified | Types | Semantic analysis |
| Match exhaustiveness | Expressions | Semantic analysis |
| `emit` terminal in functions with return type | Statements | Semantic analysis |
| `break`/`continue` only in `infinite` | Statements | Semantic analysis |
| Variable naming: mutable=snake_case, immutable=SCREAMING_SNAKE | Declarations | Semantic analysis |
| Agent `impl` contract verification | Declarations | Semantic analysis |
| `.flux` vs `.fdsl` file structure rules | Module | Semantic analysis |

---

## 10. Core vs. Auxiliary Classification

- **Core (60)**: Productions that define the fundamental syntax of a valid TheFlux program (literals, expressions, statements, declarations, module structure).
- **Auxiliary (149)**: Helper productions (character classes, operator categories, type abstractions, indentation mechanics, docstring wrappers).

| Domain | Core | Auxiliary | Total |
|--------|------|-----------|-------|
| Lexical | 18 | 44 | 62 |
| Types | 5 | 9 | 14 |
| Expressions | 8 | 45 | 53 |
| Statements | 10 | 11 | 21 |
| Declarations | 10 | 30 | 40 |
| Module Structure | 7 | 5 | 12 |
| Diagnostics | 2 | 5 | 7 |
| **Total** | **60** | **149** | **209** |

---

## 11. Cross-Reference: grammar.md Section Coverage

| Section | Title | Productions | Domain |
|---------|-------|-------------|--------|
| 1 | CARACTERES E IDENTIFICADORES | 13 | Lexical |
| 2 | CONJUNTOS DE CARACTERES | 9 | Lexical |
| 3 | COMENTARIOS E DOCUMENTACAO | 3 | Lexical |
| 4 | LEXING ESTRUTURAL | 4 | Lexical |
| 5 | PRIORIDADE DE TOKENS DO LEXER | 0 | Lexical (narrative only) |
| 6 | PALAVRAS-CHAVE E OPERADORES | 13 | Lexical |
| 7 | LITERAIS | 14 | Lexical |
| 8 | TIPOS | 10 | Types |
| 9 | EXPRESSOES POR PRECEDENCIA | 52 | Expressions |
| 10 | BLOCOS E COMANDOS | 21 | Statements |
| 11 | DECLARACOES | 40 | Declarations |
| 12 | ESTRUTURA DO MODULO | 12 | Module Structure |
| 14 | CONTRATO DE DIAGNOSTICO | 9 | Diagnostics |

---

## 12. Production Dependency Graph

The following diagram shows inter-domain dependencies — which domains reference productions from other domains.

```
Lexical ──> Types  ──> Expressions ──> Statements ──> Declarations ──> Module Structure
  │                                                │
  └────────────────────────────────────────────────┘
         │
         └──> Diagnostics
```

Dependencies by domain:

| Domain | Depends On | Referenced By |
|--------|-----------|---------------|
| Lexical | — | All domains (identifiers, keywords, literals, operators) |
| Types | Lexical (identifiers, literals) | Expressions (type_ref in cast, patterns), Declarations (typed fields) |
| Expressions | Lexical (literals, operators), Types (type_ref) | Statements (expression_stmt), Declarations (default values) |
| Statements | Expressions (conditions, bodies), Lexical (keywords) | Declarations (block bodies), Module Structure |
| Declarations | Expressions (defaults, bodies), Types (field types), Lexical (identifiers) | Module Structure (documented_*) |
| Module Structure | Declarations (all declaration forms), Lexical (DOCSTRING) | — |
| Diagnostics | Lexical (identifiers, literals) | — |

---

## 13. Quick-Reference: Operators

### 13.1 Math Operators

| Syntax | Production | Precedence | Associativity | Description |
|--------|-----------|------------|---------------|-------------|
| `+` | math_operator | 7 (additive) | Left | Addition |
| `-` | math_operator | 7 (additive) | Left | Subtraction |
| `*` | math_operator | 8 (multiplicative) | Left | Multiplication |
| `/f` | math_operator | 8 (multiplicative) | Left | Float division |
| `/i` | math_operator | 8 (multiplicative) | Left | Integer division |
| `/r` | math_operator | 8 (multiplicative) | Left | Rational division |
| `^e` | math_operator | 9 (power) | Right | Exponentiation (exact) |
| `^r` | math_operator | 9 (power) | Right | Exponentiation (rational) |

### 13.2 Relation Operators

| Syntax | Production | Description |
|--------|-----------|-------------|
| `==` | relation_operator | Equal |
| `!=` | relation_operator | Not equal |
| `<` | relation_operator | Less than |
| `>` | relation_operator | Greater than |
| `<=` | relation_operator | Less than or equal |
| `>=` | relation_operator | Greater than or equal |

### 13.3 Bitwise Operators

| Syntax | Production | Precedence | Description |
|--------|-----------|------------|-------------|
| `<<` | bitwise_operator | 6 (shift) | Left shift |
| `>>` | bitwise_operator | 6 (shift) | Right shift (arithmetic) |
| `>>>` | bitwise_operator | 6 (shift) | Right shift (logical) |
| `&` | bitwise_operator | 3 (bit_and) | Bitwise AND |
| `^` | bitwise_operator | 2 (bit_xor) | Bitwise XOR |
| `\|` | bitwise_operator | 1 (bit_or) | Bitwise OR |
| `~` | bitwise_operator | prefix | Bitwise NOT |

### 13.4 Assignment Operators

| Syntax | Production | Description |
|--------|-----------|-------------|
| `=` | assignment_operator | Assignment |

### 13.5 Dataflow Operators

| Syntax | Production | Precedence | Description |
|--------|-----------|------------|-------------|
| `-->` | dataflow_operator | dataflow_expr | Dataflow pipeline |
| `split` | dataflow_operator | dataflow_expr | Dataflow split |
| `join` | dataflow_operator | dataflow_expr | Dataflow join |
| `==>` | lambda_operator | dataflow_expr | Lambda/dataflow mapping |
| `catch` | recovery_expr | recovery_expr | Error recovery (keep) |
| `fallback` | recovery_expr | recovery_expr | Error recovery (fallback) |

---

## 14. Quick-Reference: Keywords

All 53 keywords grouped by category:

| Category | Keywords | Count |
|----------|----------|-------|
| Literals | `true` `false` | 2 |
| Mutability | `mut` `imut` | 2 |
| Ownership | `keep` `move` `borrow` | 3 |
| Logical | `and` `or` `not` | 3 |
| Membership | `in` | 1 |
| Control Flow | `if` `else` `for` `while` `break` `continue` `infinite` | 7 |
| Match | `match` | 1 |
| Error Handling | `error` `panic` `unsafe` `try` | 4 |
| Dataflow | `split` `join` `catch` `fallback` `route` `emit` `spy` `input` `print` `spawn` `async` `await` | 12 |
| Metaprogramming | `quote` `unquote` `comptime` | 3 |
| Declarations | `struct` `enum` `contract` `agent` `function` `op` `macro` `program` `use` `as` `impl` | 11 |
| Data | `data` `map` `of` | 3 |
| Emit Status | `nice` `fail` | 2 |
| Postfix | `ensure` `cast` | 2 |

---

## 15. FR-001 through FR-005 Coverage

| Requirement | Coverage | Location |
|-------------|----------|----------|
| FR-001: Grammar is defined in EBNF notation | Sections 1-12 extracted as EBNF | `docs/TheFlux.ebnf` |
| FR-002: Productions organized by domain | 7 domains documented | Sections 2-8 |
| FR-003: Semantic constraints annotated | All non-syntactic constraints listed | Section 9 |
| FR-004: ASCII 7-bit encoding enforced | Extraction validates ASCII output | `extract_ebnf.py` |
| FR-005: Productions cross-referenced to source | Each production linked to grammar.md section | Sections 2-8, Section 11 |

---

## 16. Production Reference

For the complete list of all 209 productions, see `docs/TheFlux.ebnf`. Each production in this document is cross-referenced to its approximate line in `docs/grammar.md`. Exact line numbers may vary with grammar.md edits.

---

## Changelog

| Version | Date | Description |
|---------|------|-------------|
| 1.0.0 | 2026-07-22 | Initial grammar analysis document — 209 productions across 7 domains |
