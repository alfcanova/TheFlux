# Grammar Analysis: TheFlux v0.5

**Version**: 1.0.0  
**Date**: 2026-07-22  
**Source**: `docs/grammar.md` (Snapshot RC 2026-07-20)  
**EBNF Output**: `docs/TheFlux.ebnf` (224 lines, 218 productions across sections 1-12 and 14)  
**Author**: Automated extraction via `specs/004-ebnf-production-extraction/extract_ebnf.py`

## 1. Domain Overview

| # | Domain | Sections | Productions | Core | Auxiliary | Description |
|---|--------|----------|-------------|------|-----------|-------------|
| 1 | Lexical | 1-7 | 62 | 18 | 44 | Characters, identifiers, comments, structural lexing, keywords, operators, literals |
| 2 | Types | 8 | 14 | 5 | 9 | Built-in scalar types, tensor types, type references |
| 3 | Expressions | 9 | 53 | 8 | 45 | Precedence hierarchy, primaries, patterns, postfix operators |
| 4 | Statements | 10 | 21 | 10 | 11 | Block structure, control flow, route, infinite, emit, unsafe |
| 5 | Declarations | 11 | 40 | 10 | 30 | Struct, enum, macro, variable, function, contract, agent, op, program, use |
| 6 | Module Structure | 12 | 12 | 7 | 5 | File-level organization, documented declarations |
| 7 | Diagnostics | 14 | 16 | 2 | 14 | Diagnostic format, error codes, message structure |

**Total**: 218 productions (60 core, 158 auxiliary)

## 2. Domain 1: Lexical (62 productions)

**Source**: grammar.md sections 1-7  
**Description**: Character sets, identifier conventions, comment/docstring syntax, structural lexing tokens, keyword/operator definitions, and literal formats.

### Characters and Identifiers (Section 1)

| Production | Type | Purpose |
|------------|------|---------|
| `digit` | auxiliary | Single decimal digit 0-4 |
| `nonzero_digit` | auxiliary | Single nonzero digit 1-5 |
| `lower_letter` | auxiliary | Lowercase ASCII letter a-f |
| `upper_letter` | auxiliary | Uppercase ASCII letter A-F |
| `letter` | auxiliary | Any ASCII letter |
| `identifier` | core | Any valid identifier |
| `IDENT_LOWER` | auxiliary | Lowercase-only identifier |
| `IDENT_UPPER` | auxiliary | Uppercase-only identifier |
| `IDENT_MIXED` | auxiliary | Mixed-case identifier |
| `snake_case_identifier` | core | Semantic alias for IDENT_LOWER |
| `screaming_snake_identifier` | core | Semantic alias for IDENT_UPPER |
| `camel_case_identifier` | core | Mixed starting lowercase |
| `pascal_case_identifier` | core | Mixed starting uppercase |

### Character Sets (Section 2)

| Production | Type | Purpose |
|------------|------|---------|
| `line_break` | auxiliary | Line termination |
| `any_ascii_char` | auxiliary | Any 7-bit ASCII char |
| `any_comment_char` | auxiliary | ASCII except control chars |
| `any_char_except_line_break` | auxiliary | Alias for any_comment_char |
| `any_char_except_block_end` | auxiliary | Char inside block comment |
| `doc_char` | auxiliary | Char inside docstring |
| `ascii_printable` | auxiliary | Printable ASCII 0x20-0x7E |
| `ascii_printable_except_single_quote_backslash_line_break` | auxiliary | Printable minus quote, backslash |
| `ascii_printable_except_double_quote_backslash_line_break` | auxiliary | Printable minus double-quote, backslash |

### Comments and Documentation (Section 3)

| Production | Type | Purpose |
|------------|------|---------|
| `line_comment` | core | `#L` line comment |
| `block_comment` | core | `#B...B#` block comment |
| `DOCSTRING` | core | `#D...D#` docstring token |

### Structural Lexing (Section 4)

| Production | Type | Purpose |
|------------|------|---------|
| `NEWLINE` | core | Logical line terminator token |
| `INDENT` | core | Indentation increase token |
| `DEDENT` | core | Indentation decrease token |
| `EOF` | core | End-of-file token |

### Keywords and Operators (Section 6)

| Production | Type | Purpose |
|------------|------|---------|
| `keyword` | core | 53 reserved keywords |
| `math_operator` | auxiliary | `+ - * /f /i /r ^e ^r` |
| `relation_operator` | auxiliary | `== != < > <= >=` |
| `error_operator` | auxiliary | `?` propagation |
| `not_operator` | auxiliary | `not` |
| `bang_operator` | auxiliary | `!` |
| `bitwise_operator` | auxiliary | `& | ^ ~ << >> >>>` |
| `assignment_operator` | auxiliary | `=` |
| `dataflow_operator` | auxiliary | `--> split join` |
| `lambda_operator` | auxiliary | `==>` |
| `access_operator` | auxiliary | `[ ] .. . ::` |
| `delimiter` | auxiliary | `( ) { } : ,` |
| `pending_line_operator` | auxiliary | Forces pending line continuation |

### Literals (Section 7)

| Production | Type | Purpose |
|------------|------|---------|
| `unsigned_integer` | auxiliary | Non-negative integer |
| `integer_literal` | core | Signed integer |
| `fraction` | auxiliary | Fractional part |
| `exponent` | auxiliary | Scientific notation |
| `float_literal` | core | Floating-point literal |
| `imaginary_literal` | core | Imaginary with `i` suffix |
| `datetime_literal` | core | ISO 8601 with UTC Z |
| `escape` | auxiliary | Escape sequences |
| `char_literal` | core | Single-quoted char |
| `string_literal` | core | Double-quoted string |
| `interpolated_string` | core | String with interpolation |
| `boolean_literal` | core | `true` or `false` |
| `literal` | core | Any literal value |

## 3. Domain 2: Types (14 productions)

**Source**: grammar.md section 8

| Production | Type | Purpose |
|------------|------|---------|
| `signed_integer_type` | auxiliary | `int8/int16/int32/int64` |
| `unsigned_integer_type` | auxiliary | `uint8/uint16/uint32/uint64` |
| `implemented_integer_type` | auxiliary | Union of signed/unsigned |
| `implemented_float_type` | auxiliary | `float16/float32/float64` |
| `implemented_complex_type` | auxiliary | `complex16/complex32/complex64` |
| `implemented_numeric_type` | auxiliary | Union of all numeric types |
| `scalar_builtin_type` | auxiliary | Numeric + char/string/bool/datetime |
| `static_shape` | auxiliary | Tensor shape dimensions |
| `tensor_type` | core | Tensor with shape + numeric type |
| `type_ref` | core | Any type reference |

## 4. Domain 3: Expressions (53 productions)

**Source**: grammar.md section 9

### Precedence Chain

| Production | Type | Purpose |
|------------|------|---------|
| `expression` | core | Top-level expression |
| `assignment_expr` | core | Assignment (right-assoc) |
| `recovery_expr` | auxiliary | `catch`/`fallback` recovery |
| `dataflow_expr` | auxiliary | `-->` `split` `join` `==>` |
| `or_expr` | auxiliary | Logical OR |
| `and_expr` | auxiliary | Logical AND |
| `bit_or_expr` | auxiliary | Bitwise OR |
| `bit_xor_expr` | auxiliary | Bitwise XOR |
| `bit_and_expr` | auxiliary | Bitwise AND |
| `equality_expr` | auxiliary | Relational comparisons |
| `membership_expr` | auxiliary | `in` membership |
| `range_expr` | auxiliary | `..` range |
| `shift_expr` | auxiliary | `<<` `>>` `>>>` |
| `additive_expr` | auxiliary | `+` `-` |
| `multiplicative_expr` | auxiliary | `*` `/f` `/i` `/r` |
| `power_expr` | auxiliary | `^e` `^r` |
| `prefix_expr` | auxiliary | Prefix operators |

### Async/Spawn/Ownership

| Production | Type | Purpose |
|------------|------|---------|
| `async_expr` | core | Async evaluation |
| `spawn_expr` | core | Spawn concurrent execution |
| `await_expr` | core | Await async result |
| `ownership_expr` | auxiliary | `move`/`borrow`/`keep` |
| `move_expr` | core | Move ownership |
| `borrow_expr` | core | Borrow ownership |
| `keep_expr` | core | Keep ownership |

### Primaries, Postfix, Special

| Production | Type | Purpose |
|------------|------|---------|
| `primary_postfix_expr` | auxiliary | Primary with postfix |
| `postfix_op` | auxiliary | Postfix operators |
| `primary_expr` | core | Primary expression |
| `comptime_expr` | core | Compile-time block |
| `quote_expr` | core | Quotation |
| `unquote_expr` | core | Unquote |
| `error_expr` | core | Error construction |
| `panic_expr` | core | Panic |
| `match_expr` | core | Pattern matching |

### Patterns

| Production | Type | Purpose |
|------------|------|---------|
| `match_arm` | auxiliary | Match arm |
| `pattern` | core | Pattern alternatives |
| `list_pattern` | auxiliary | List destructuring |
| `record_pattern` | auxiliary | Record destructuring |
| `struct_pattern` | auxiliary | Struct destructuring |
| `enum_variant_pattern` | auxiliary | Enum variant destructuring |
| `data_pattern` | auxiliary | Data block destructuring |
| `pattern_field` | auxiliary | Named field in pattern |

### Call, Access, Sinks, Literals

| Production | Type | Purpose |
|------------|------|---------|
| `call_suffix` | auxiliary | Function call |
| `call_args` | auxiliary | Call arguments |
| `positional_args` | auxiliary | Positional args |
| `named_args` | auxiliary | Named args |
| `named_arg` | auxiliary | Single named arg |
| `field_suffix` | auxiliary | Field access |
| `namespace_suffix` | auxiliary | Namespace access |
| `ensure_suffix` | core | Postcondition block |
| `cast_suffix` | core | Type cast |
| `struct_init_expr` | core | Struct init |
| `struct_init_field` | auxiliary | Struct init field |
| `enum_variant_expr` | core | Enum variant construction |
| `enum_variant_init_field` | auxiliary | Enum variant init field |
| `index_or_slice_suffix` | auxiliary | Index/slice |
| `slice_spec` | auxiliary | Slice spec |
| `input_expr` | core | Input expression |
| `spy_expr` | core | Debug spy |
| `spy_sink` | auxiliary | Spy data sink |
| `print_sink` | auxiliary | Print data sink |
| `keep_sink` | auxiliary | Keep data sink |
| `dataflow_cast_sink` | auxiliary | Dataflow cast sink |
| `list_literal` | core | List literal |
| `brace_literal` | auxiliary | Brace literal |
| `set_literal` | core | Set literal |
| `record_literal` | core | Record literal |
| `record_field` | auxiliary | Record field |
| `map_literal` | core | Map literal |
| `data_literal` | core | Data literal |
| `data_field` | auxiliary | Data field |

## 5. Domain 4: Statements (21 productions)

**Source**: grammar.md section 10

| Production | Type | Purpose |
|------------|------|---------|
| `block_body` | core | Indented code block |
| `indented_block_body` | auxiliary | Block with INDENT/DEDENT |
| `top_statement` | core | File-level statement |
| `block_statement` | core | Block-body statement |
| `statement_end` | core | NEWLINE or EOF |
| `print_stmt` | core | Print expression |
| `route_stmt` | core | Route/dataflow construct |
| `route_subjects` | auxiliary | Route subjects |
| `route_body` | auxiliary | Route body |
| `indented_route_body` | auxiliary | Indented route body |
| `inline_route_body` | auxiliary | Inline route body |
| `route_arm` | auxiliary | Route arm |
| `route_condition` | auxiliary | Route condition |
| `route_positional_condition` | auxiliary | Positional route |
| `infinite_stmt` | core | Infinite loop |
| `infinite_arg` | auxiliary | Loop argument |
| `break_stmt` | core | Break |
| `continue_stmt` | core | Continue |
| `emit_stmt` | core | Terminal emit |
| `unsafe_stmt` | core | Unsafe block |
| `expression_stmt` | core | Expression as statement |

## 6. Domain 5: Declarations (40 productions)

**Source**: grammar.md section 11

### Use Declarations

| Production | Type | Purpose |
|------------|------|---------|
| `use_decl` | core | Use declaration |
| `use_agent_decl` | core | Import agent |
| `use_operation_decl` | core | Import operation |
| `use_group_decl` | core | Import group |
| `use_group_item` | auxiliary | Group item |

### Struct, Enum, Macro

| Production | Type | Purpose |
|------------|------|---------|
| `struct_decl` | core | Struct type |
| `struct_body` | auxiliary | Struct body |
| `indented_struct_body` | auxiliary | Indented struct body |
| `inline_struct_body` | auxiliary | Inline struct body |
| `struct_field` | auxiliary | Struct field |
| `mutable_struct_field` | auxiliary | Mutable field |
| `immutable_struct_field` | auxiliary | Immutable field |
| `enum_decl` | core | Enum type |
| `enum_body` | auxiliary | Enum body |
| `indented_enum_body` | auxiliary | Indented enum body |
| `inline_enum_body` | auxiliary | Inline enum body |
| `enum_variant` | auxiliary | Enum variant |
| `enum_variant_fields` | auxiliary | Variant field list |
| `enum_variant_field` | auxiliary | Typed variant field |
| `macro_decl` | core | Macro declaration |
| `macro_body` | auxiliary | Macro body |
| `macro_params` | auxiliary | Macro params |

### Variables, Functions, Ops

| Production | Type | Purpose |
|------------|------|---------|
| `variable_decl` | core | Variable declaration |
| `map_schema` | auxiliary | Map type schema |
| `map_schema_field` | auxiliary | Map schema entry |
| `mutable_decl` | core | Mutable variable |
| `immutable_decl` | core | Immutable variable |
| `function_decl` | core | Function declaration |
| `function_params` | auxiliary | Function params |
| `function_param` | auxiliary | Single param |
| `program_decl` | core | Program entry point |
| `op_decl` | core | Operation declaration |

### Contract, Agent

| Production | Type | Purpose |
|------------|------|---------|
| `contract_decl` | core | Contract interface |
| `contract_body` | auxiliary | Contract body |
| `indented_contract_body` | auxiliary | Indented contract body |
| `inline_contract_body` | auxiliary | Inline contract body |
| `contract_op` | auxiliary | Contract operation |
| `agent_decl` | core | Agent declaration |
| `agent_body` | auxiliary | Agent body |
| `indented_agent_body` | auxiliary | Indented agent body |
| `inline_agent_body` | auxiliary | Inline agent body |

## 7. Domain 6: Module Structure (12 productions)

**Source**: grammar.md section 12

| Production | Type | Purpose |
|------------|------|---------|
| `flux_file` | core | .flux file structure |
| `fdsl_file` | core | .fdsl file structure |
| `documented_use_decl` | auxiliary | Use with docstring |
| `documented_struct_decl` | auxiliary | Struct with docstring |
| `documented_enum_decl` | auxiliary | Enum with docstring |
| `documented_contract_decl` | auxiliary | Contract with docstring |
| `documented_macro_decl` | auxiliary | Macro with docstring |
| `documented_type_macro_decl` | auxiliary | Union of struct/enum/macro |
| `documented_variable_decl` | auxiliary | Variable with docstring |
| `documented_function_decl` | auxiliary | Function with docstring |
| `documented_program_decl` | auxiliary | Program with docstring |
| `documented_agent_decl` | auxiliary | Agent with docstring |

## 8. Domain 7: Diagnostics (16 productions)

**Source**: grammar.md section 14

| Production | Type | Purpose |
|------------|------|---------|
| `diagnostic` | core | Diagnostic message format |
| `source_name` | auxiliary | Source file or `<stdin>` |
| `filename` | auxiliary | Source filename |
| `filename_char` | auxiliary | Filename character |
| `line` | auxiliary | Line number or `?` |
| `column` | auxiliary | Column number or `?` |
| `message` | auxiliary | Diagnostic message |
| `message_char` | auxiliary | Message character |
| `diagnostic_code` | core | Error code enumeration |

## 9. Semantic Constraints

| Constraint | Domain | Enforcement |
|------------|--------|-------------|
| Naming case conventions | Lexical | Semantic analysis |
| TAB forbidden (TabulationError) | Lexical | Lexer |
| NEWLINE suppression inside `()` and `[]` | Lexical | Lexer |
| 9-digit nanosecond precision in datetime | Literal | Parser |
| UTC `Z` suffix required in datetime | Literal | Parser |
| Tensor shape element count verified | Types | Semantic analysis |
| Match exhaustiveness | Expressions | Semantic analysis |
| `emit` terminal in functions with return type | Statements | Semantic analysis |
| `break`/`continue` only in `infinite` | Statements | Semantic analysis |
| Variable naming: mutable=snake_case | Declarations | Semantic analysis |
| Agent `impl` contract verification | Declarations | Semantic analysis |
| `.flux` vs `.fdsl` file structure | Module | Semantic analysis |

## 10. Core vs. Auxiliary Classification

| Domain | Core | Auxiliary | Total |
|--------|------|-----------|-------|
| Lexical | 18 | 44 | 62 |
| Types | 5 | 9 | 14 |
| Expressions | 8 | 45 | 53 |
| Statements | 10 | 11 | 21 |
| Declarations | 10 | 30 | 40 |
| Module Structure | 7 | 5 | 12 |
| Diagnostics | 2 | 14 | 16 |
| **Total** | **60** | **158** | **218** |

## 11. Cross-Reference: grammar.md Section Coverage

| Section | Title | Productions | Domain |
|---------|-------|-------------|--------|
| 1 | CARACTERES E IDENTIFICADORES | 13 | Lexical |
| 2 | CONJUNTOS DE CARACTERES | 9 | Lexical |
| 3 | COMENTARIOS E DOCUMENTACAO | 3 | Lexical |
| 4 | LEXING ESTRUTURAL | 4 | Lexical |
| 5 | PRIORIDADE DE TOKENS DO LEXER | 0 | Lexical (narrative) |
| 6 | PALAVRAS-CHAVE E OPERADORES | 13 | Lexical |
| 7 | LITERAIS | 14 | Lexical |
| 8 | TIPOS | 10 | Types |
| 9 | EXPRESSOES POR PRECEDENCIA | 52 | Expressions |
| 10 | BLOCOS E COMANDOS | 21 | Statements |
| 11 | DECLARACOES | 40 | Declarations |
| 12 | ESTRUTURA DO MODULO | 12 | Module Structure |
| 14 | CONTRATO DE DIAGNOSTICO | 9 | Diagnostics |

## Changelog

| Version | Date | Description |
|---------|------|-------------|
| 1.0.0 | 2026-07-22 | Initial grammar analysis — 218 productions across 7 domains |
