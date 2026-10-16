# TheFlux Language Specification (v0.75)

This document contains the formal specification of **TheFlux** programming language (version 0.75), structured in accordance with the international standard **ISO/IEC 14977 (EBNF)** and enriched with **UTF-8 / Unicode** extensions, specialized numeric types for AI/ML, operational execution rules, and modular compilation suite layout.

---

## 1. Architecture & Specification Overview

- **Specification Version**: TheFlux Specification v0.75 (Snapshot RC: 2026-10-16).
- **Source Code Encoding**: **Strict UTF-8**. Identifiers, keywords, and operators use the 7-bit ASCII range; Unicode characters (U+0080..U+10FFFF) are permitted exclusively within strings, characters (`char`), comments, and docstrings.
- **Modular File Structure**:
  - `.flux` files: Executable entry points containing module declarations and terminating with an obligatory entry block `program (<PascalCaseName>) { ... }`.
  - `.fdsl` files: Intelligent agent domain modules containing `agent`, `contract`, `impl`, and auxiliary operations (usage of `program` is forbidden).

---

## 2. Official Operator Precedence Table

Expression evaluation in TheFlux follows 17 strict precedence levels:

| Level | Associativity | Category | Operators |
| :---: | :---: | :--- | :--- |
| **1** | R &rarr; L | Simple and compound assignment | `=`, `=+`, `=-`, `=*`, `=/f`, `=/i`, `=/r`, `=^e`, `=^r`, `=^`, `=\|`, `=^`, `=~`, `=<<`, `=>>`, `=>>>` |
| **2** | L &rarr; R | Error recovery and fallback | `catch`, `fallback` |
| **3** | L &rarr; R | Dataflow and bifurcation | `-->`, `==>`, `split`, `join` |
| **4** | L &rarr; R | Logical disjunction | `or` |
| **5** | L &rarr; R | Logical conjunction | `and` |
| **6** | L &rarr; R | Bitwise OR | `\|` |
| **7** | L &rarr; R | Bitwise XOR | `^` |
| **8** | L &rarr; R | Bitwise AND | `&` |
| **9** | L &rarr; R | Relational comparison | `==`, `!=`, `<`, `>`, `<=`, `>=` |
| **10** | L &rarr; R | Membership / iteration | `in` |
| **11** | L &rarr; R | Range / interval | `..` |
| **12** | L &rarr; R | Bitwise shift | `<<`, `>>`, `>>>` |
| **13** | L &rarr; R | Additive arithmetic | `+`, `-` |
| **14** | L &rarr; R | Multiplicative arithmetic | `*`, `/f` *(real division)*, `/i` *(integer division)*, `/r` *(remainder)* |
| **15** | R &rarr; L | Power and root | `^e` *(power)*, `^r` *(n-th root)* |
| **16** | &mdash; | Unary / Prefix | `+`, `-`, `not`, `!`, `~`, `unquote`, `spawn`, `await`, `move()`, `borrow()`, `keep()` |
| **17** | &mdash; | Postfix and calls *(highest)* | `()`, `[]`, `.`, `::`, `ensure { }`, `as`, `?` *(short-circuit)* |

> [!NOTE]
> Parentheses `( expression )` have the highest possible precedence and force early evaluation of any subexpression.

---

## 3. Formal Specification ISO/IEC 14977 (EBNF)

```ebnf
(* ================================================================== *)
(* EBNF (ISO/IEC 14977) - TheFlux v0.75 Specification                 *)
(* Standard Formal Grammar of TheFlux Programming Language            *)
(* ================================================================== *)

(*
EBNF:PRECEDENCE - Operator precedence table (from lowest to highest)

    Level  Assoc  Category              Operators
    1      R->L   Assignment            = =+ =- =* =/f =/i =/r =^e =^r =& =| =^ =~ =<< =>> =>>>
    2      L->R   Recovery              catch fallback
    3      L->R   Dataflow              --> ==> split join
    4      L->R   Logical Disjunction   or
    5      L->R   Logical Conjunction   and
    6      L->R   Bitwise OR            |
    7      L->R   Bitwise XOR           ^
    8      L->R   Bitwise AND           &
    9      L->R   Relational            == != < > <= >=
    10     L->R   Membership            in
    11     L->R   Range                 ..
    12     L->R   Shift                 << >> >>>
    13     L->R   Additive              + -
    14     L->R   Multiplicative        * /f /i /r
    15     R->L   Power/Root            ^e ^r
    16     -      Unary / Prefix        + - not ! ~ unquote spawn await move() borrow() keep()
    17     -      Postfix               () [] . :: ensure { } as ? (highest precedence)

    Parentheses "(" expression ")" have the highest possible precedence.
    Expressions in parentheses force early evaluation.
*)

    (* ========================================== *)
    (*     BLOCK 1: CONVENTIONS AND IDENTIFIERS   *)
    (* ========================================== *)

(* --- Layer 1: Supporting Lexical Units --- *)
lower_letter  = "a" | "b" | "c" | "d" | "e" | "f" | "g" | "h" | "i" | "j" | "k" | "l" | "m" 
              | "n" | "o" | "p" | "q" | "r" | "s" | "t" | "u" | "v" | "w" | "x" | "y" | "z" ;

upper_letter  = "A" | "B" | "C" | "D" | "E" | "F" | "G" | "H" | "I" | "J" | "K" | "L" | "M" 
              | "N" | "O" | "P" | "Q" | "R" | "S" | "T" | "U" | "V" | "W" | "X" | "Y" | "Z" ;

nonzero_digit = "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" ;
digit         = "0" | nonzero_digit ;
hex_digit     = digit | "a" | "b" | "c" | "d" | "e" | "f" | "A" | "B" | "C" | "D" | "E" | "F" ;

(* --- Layer 2: Lexical Style Patterns --- *)

(* Pattern 1: snake_case (mutable variables, mutable fields, functions, parameters) *)
style_snake_case = lower_letter , { lower_letter | digit | "_" } ;

(* Pattern 2: camelCase (functions, operations) *)
style_camel_case = lower_letter , { lower_letter | digit } , { upper_letter , { lower_letter | digit } } ;

(* Pattern 3: PascalCase (composite types, contracts, agents, programs, enums) *)
style_pascal_case = upper_letter , { lower_letter | digit } , { upper_letter , { lower_letter | digit } } ;

(* Pattern 4: SCREAMING_SNAKE_CASE (immutable constants, immutable struct fields) *)
style_screaming_snake = upper_letter , { upper_letter | digit | "_" } ;

(* Rule: Reserved Language Keywords. Used via set subtraction in identifiers *)
keyword = "_" | "mut" | "imut" | "true" | "false" | "True" | "False" | "struct" | "enum" 
        | "contract" | "impl" | "function" | "and" | "or" | "not"
        | "in" | "break" | "continue" | "match" | "error" | "catch" 
        | "ensure" | "fallback" | "program" | "emit" 
        | "nice" | "fail" | "route" | "infinite" | "split" | "join"
        | "agent" | "op" | "use" | "of" | "comptime" | "macro" 
        | "quote" | "unquote" | "spawn" | "async" | "await" 
        | "keep" | "move" | "borrow" | "unsafe" 
        | "print" | "input" | "spy"
        | "data" | "map" | "set" | "list" | "as" ;

(* --- Layer 3: Identifier Filters (Optimized and Protected Order) --- *)

(* Strict Lowercase Identifier: snake_case and camelCase excluding keywords *)
generic_lower_identifier = ( style_snake_case | style_camel_case ) - keyword ;

(* Strict Uppercase Identifier: Types, contracts, enums, agents, and programs (PascalCase) *)
generic_upper_identifier = style_pascal_case - keyword ;

(* Constant Identifier: Immutable constants (SCREAMING_SNAKE_CASE) *)
constant_identifier = style_screaming_snake - keyword ;

(* Universal Root / Wildcard Identifier *)
system_wildcard_identifier = ( "_" , { lower_letter | upper_letter | digit | "_" } ) - keyword ;

(* Final Unified Identification Rule *)
identifier = generic_lower_identifier | generic_upper_identifier | constant_identifier | system_wildcard_identifier ;

    (* ========================================== *)
    (*     SUB-BLOCK: BASE CHARACTERS AND FILTERS     *)
    (* ========================================== *)

(* Rule: Native Line Breaks *)
line_break = "
" | "

" | "
" ;

(* Regra: Qualquer Caractere Imprimível ou Espaço na Tabela ASCII e Code Points Unicode UTF-8 *)
any_ascii_char = line_break | ? printable ASCII character or space (code 0x20 to 0x7E) ? ;

(* Regra: Base para Comentários de Linha e Bloco (7 bits + Unicode) *)
any_comment_char = ? 7-bit ASCII character (code 0x00 to 0x7F) or Unicode code point (U+0080..U+10FFFF), except TAB (0x09), \n and \r ? ;

(* Rule: Semantic Shortcut for Single-Line Characters *)
any_char_except_line_break = any_comment_char ;

(* Rule: Safe Character in Block Comment (prevents accidental B# termination) *)
any_char_except_block_end = ? any_comment_char with the restriction that sequence "B#" is not formed ? ;

(* Rule: Allowed Characters in Integrated Docstrings *)
doc_char = ? printable ASCII character or whitespace, or Unicode code point, except sequence "D#" ? | line_break ;

(* Rule: Standard Printable Character for String and Char Validation (includes Unicode UTF-8) *)
ascii_printable = ? printable ASCII character (code 0x20 to 0x7E: space to tilde) or Unicode code point (U+0080..U+10FFFF) ? ;

(* Rule: Special Filter to Prevent Stray Single Quotes in Char Literals *)
ascii_printable_except_single_quote_backslash_line_break = ascii_printable - ( "'" | "\" | "
" | "
" ) ;

(* Rule: Special Filter for Double-Quoted Strings *)
ascii_printable_except_double_quote_backslash_line_break = ascii_printable - ( '"' | "\" | "
" | "
" ) ;

    (* ========================================== *)
    (*     SUB-BLOCK: COMMENTS AND CONTROL        *)
    (* ========================================== *)

(* Rule: Single-Line Comment Starting with #L *)
line_comment = "#L" , { any_char_except_line_break } , ( line_break | ? end of file ? ) ;

(* Rule: Block Comment with Hermetic Delimiters #B and B# *)
block_comment = "#B" , { any_char_except_block_end } , "B#" ;

(* Rule: General Comment *)
comment = line_comment | block_comment ;

(* Rule: Integrated Docstring for Documenting Types, Functions, and Agents (#D ... D#) *)
docstring = "#D" , { doc_char } , "D#" ;

(* Rule: Pure Whitespace *)
pure_whitespace = " " ;
ws = { pure_whitespace } ;

(* Rule: Structural End of Line *)
eol = ws , [ comment ] , line_break , { ws , ( line_break | comment ) } ;

(* Rule: Physical End of File *)
eof = ? end of input character stream (EOF) ? ;


    (* ========================================== *)
    (*          BLOCK 2: NUMBERS AND LITERALS       *)
    (* ========================================== *)

(* Rule: Integer Numeric Literals in Decimal Base *)
integer_literal = "0" | ( nonzero_digit , { digit } ) ;

(* Rule: Floating-Point Literals (Standard and Scientific Notation) *)
float_literal = integer_literal , "." , { digit } , [ ( "e" | "E" ) , [ "+" | "-" ] , digit , { digit } ]
              | "." , digit , { digit } , [ ( "e" | "E" ) , [ "+" | "-" ] , digit , { digit } ]
              | integer_literal , ( "e" | "E" ) , [ "+" | "-" ] , digit , { digit } ;

(* Rule: Imaginary Number Suffix *)
imaginary_suffix = "i" | "j" ;

(* Rule: Pure Imaginary Literal *)
imaginary_literal = ( float_literal | integer_literal ) , imaginary_suffix ;

(* Rule: Full Complex Number Literal *)
complex_literal = [ ( float_literal | integer_literal ) , ( "+" | "-" ) ] , imaginary_literal ;

(* Rule: Boolean Literals (Canonical PascalCase True/False or lowercase true/false) *)
boolean_literal = "True" | "False" | "true" | "false" ;

    (* --- ISO 8601 DATE AND TIME WITH NANOSECONDS --- *)
date_year   = digit , digit , digit , digit ;
date_month  = digit , digit ;
date_day    = digit , digit ;
time_hour   = digit , digit ;
time_minute = digit , digit ;
time_second = digit , digit ;

tz_hour_offset   = ( "+" | "-" ) , digit , digit ;
tz_minute_offset = digit , digit ;
tz_compact       = tz_hour_offset , tz_minute_offset ;
tz_formatted     = tz_hour_offset , ":" , tz_minute_offset ;
tz_offset        = tz_hour_offset | tz_compact | tz_formatted ;
time_timezone    = "Z" | tz_offset ;

second_fraction  = "." , digit , { digit } ;

datetime_literal = date_year , "-" , date_month , "-" , date_day , "T" 
                 , time_hour , ":" , time_minute , ":" , time_second 
                 , [ second_fraction ] , [ time_timezone ] ;

    (* --- TEXT AND CHARACTER SUPPORT --- *)

(* Classic escape sequences and Unicode \u{XXXX} *)
escape_sequence = "\" , ( "'" | '"' | "\" | "n" | "t" | "r" | "0" ) 
                | "\u{" , hex_digit , { hex_digit } , "}" ;

(* Rule: Single Character Literal (Unicode code point) *)
char_literal = "'" , ( ascii_printable_except_single_quote_backslash_line_break | escape_sequence ) , "'" ;

(* Rule: Static String/Text Literal (UTF-8) *)
string_literal = '"' , { ascii_printable_except_double_quote_backslash_line_break | escape_sequence } , '"' ;

(* Rule: String Interpolation #{ expr } *)
string_interpolation = "#{" , expression , "}" ;
interpolated_string  = '"' , { ascii_printable_except_double_quote_backslash_line_break | escape_sequence | string_interpolation } , '"' ;

(* Rule: Unified Literals Rule *)
literal = datetime_literal
        | complex_literal
        | float_literal
        | integer_literal
        | boolean_literal
        | char_literal
        | string_literal
        | interpolated_string ;


    (* ========================================== *)
    (*          BLOCK 3: PRIMITIVE TYPES         *)
    (* ========================================== *)

(* Fixed-Width Signed and Unsigned Integer Types *)
signed_int_type   = "int8" | "int16" | "int32" | "int64" ;
unsigned_int_type = "uint8" | "uint16" | "uint32" | "uint64" ;
integer_type      = signed_int_type | unsigned_int_type ;

(* IEEE 754 Floating-Point Types and Special ML Formats *)
standard_float_type = "float16" | "float32" | "float64" ;
ai_float_type       = "fp8_e4m3" | "fp8_e5m2" | "bf16_e8m7" | "tf32_e8m10" ;
float_type          = standard_float_type | ai_float_type ;

(* Complex Types *)
complex_type = "complex32" | "complex64" | "complex128" ;

(* Numeric and Temporal Types *)
numeric_type         = integer_type | float_type | complex_type ;
datetime_type        = "datetime" ;
numeric_or_time_type = numeric_type | datetime_type ;

(* Primitive Scalar Types *)
char_type    = "char" ;
string_type  = "string" , [ "(" , integer_literal , ")" ] ;
boolean_type = "bool" ;

primitive_scalar_type = numeric_or_time_type | char_type | string_type | boolean_type ;
primitive_type        = primitive_scalar_type ;

(* Dynamic and Typed Collection Types *)
data_type = "data" ;
map_type  = "map" ;
list_type = "list" , "of" , type_reference ;
set_type  = "set" , "of" , type_reference ;

(* Multidimensional Tensor Type *)
tensor_dimensions = "[" , integer_literal , { "," , integer_literal } , "]" ;
tensor_type       = "tensor" , tensor_dimensions , "of" , primitive_type ;

(* Full Type Reference *)
user_type      = generic_upper_identifier ;
type_reference = primitive_type | tensor_type | data_type | map_type | list_type | set_type | user_type ;


    (* ========================================== *)
    (*          BLOCK 4: BASE DECLARATIONS         *)
    (* ========================================== *)

(* Mutable Variable Declaration: mut as <type>: <id> [= <expr>] *)
variable_item        = generic_lower_identifier , [ "=" , expression ] ;
variable_list        = variable_item , { "," , variable_item } ;
mutable_declaration  = "mut" , "as" , type_reference , ":" , variable_list , eol ;

(* Immutable Constant Declaration: imut as <type>: <id> = <expr> *)
constant_item         = ( generic_lower_identifier | constant_identifier ) , "=" , expression ;
constant_list         = constant_item , { "," , constant_item } ;
immutable_declaration = "imut" , "as" , type_reference , ":" , constant_list , eol ;

storage_declaration = mutable_declaration | immutable_declaration ;

    (* --- ASSIGNMENT OPERATORS AND STATEMENTS --- *)

assignment_operator = "="   | "=+"  | "=-"  | "=*"  | "=/f" | "=/i" | "=/r" | "=^e" | "=^r" 
                    | "=&"  | "=|"  | "=^"  | "=~"  | "=<<" | "=>>" | "=>>>" ;

variable_reassignment = ( generic_lower_identifier | postfix_expr ) , assignment_operator , expression , eol ;


    (* ========================================== *)
    (*             BLOCK 5: EXPRESSIONS            *)
    (* ========================================== *)

(* Unary and Primary Operators *)
primary_expr = literal
             | identifier
             | "(" , expression , ")"
             | collection_literal ;

collection_literal = list_literal | set_literal | map_literal | data_literal ;
list_literal       = "[" , [ expression , { "," , expression } ] , "]" ;
set_literal        = "{" , [ expression , { "," , expression } ] , "}" ;
map_literal        = "{" , [ "." , identifier , ":" , expression , { "," , "." , identifier , ":" , expression } ] , "}" ;
data_literal       = "{" , [ "." , identifier , ":" , expression , { "," , "." , identifier , ":" , expression } ] , "}" ;

(* Postfix Operations (Field Access, Call, Indexing, Slicing, Cast, Short-Circuit) *)
postfix_expr = primary_expr , { postfix_op } ;
postfix_op   = "." , identifier
             | "::" , identifier
             | "(" , [ argument_list ] , ")"
             | "[" , slice_or_index , "]"
             | "as" , type_reference
             | "?" , short_circuit_block ;

slice_or_index = [ expression ] , ".." , [ expression ]
               | expression ;

argument_list = argument_item , { "," , argument_item } ;
argument_item = [ "." , identifier , ":" ] , expression ;

(* Operators by Precedence Level *)
unary_op   = "+" | "-" | "not" | "!" | "~" | "unquote" | "spawn" | "await" | "move" | "borrow" | "keep" ;
unary_expr = { unary_op } , postfix_expr ;

power_expr          = unary_expr , [ ( "^e" | "^r" ) , power_expr ] ;
multiplicative_expr = power_expr , { ( "*" | "/f" | "/i" | "/r" ) , power_expr } ;
additive_expr       = multiplicative_expr , { ( "+" | "-" ) , multiplicative_expr } ;
shift_expr          = additive_expr , { ( "<<" | ">>" | ">>>" ) , additive_expr } ;
range_expr          = shift_expr , [ ".." , shift_expr ] ;
relational_op       = "==" | "!=" | "<" | ">" | "<=" | ">=" | "in" ;
relational_expr     = range_expr , { relational_op , range_expr } ;
bitwise_and_expr    = relational_expr , { "&" , relational_expr } ;
bitwise_xor_expr    = bitwise_and_expr , { "^" , bitwise_and_expr } ;
bitwise_or_expr     = bitwise_xor_expr , { "|" , bitwise_xor_expr } ;
logical_and_expr    = bitwise_or_expr , { "and" , bitwise_or_expr } ;
logical_or_expr     = logical_and_expr , { "or" , logical_and_expr } ;

(* Dataflow and Lambda *)
dataflow_op   = "-->" | "==>" | "split" | "join" ;
dataflow_expr = logical_or_expr , { dataflow_op , logical_or_expr } ;

(* Error Recovery and Handling *)
recovery_op   = "catch" | "fallback" ;
recovery_expr = dataflow_expr , { recovery_op , ( dataflow_expr | block_body ) } ;

expression = recovery_expr ;


    (* ========================================== *)
    (*    BLOCK 6: FUNCTIONS, STRUCTURES AND CONTROL FLOW    *)
    (* ========================================== *)

(* --- 1. IMPORT DECLARATION (USE) --- *)
use_alias       = "as" , ( generic_upper_identifier | generic_lower_identifier ) ;
use_op_item     = generic_lower_identifier , [ use_alias ] ;
use_group       = "::" , "{" , use_op_item , { "," , use_op_item } , "}" ;
use_target      = generic_upper_identifier , [ use_group | ( "::" , generic_lower_identifier , [ use_alias ] ) | use_alias ] ;
use_declaration = "use" , use_target , eol ;

(* --- 2. OUTPUT AND TELEMETRY SYSTEM (BUILT-INS) --- *)
print_statement = "print" , "(" , expression , ")" ;
input_statement = "input" , "(" , [ string_literal ] , ")" ;
spy_statement   = "spy" ;

(* --- 3. LOOP CONTROL (BREAK / CONTINUE / INFINITE) --- *)
break_statement    = "break" , eol ;
continue_statement = "continue" , eol ;

infinite_condition = expression | ( identifier , "in" , ( range_expr | expression ) ) ;
infinite_statement = "infinite" , [ "(" , infinite_condition , ")" ] , block_body , eol ;

(* --- 4. CONDITIONAL ROUTING (ROUTE) --- *)
route_arm       = ( expression | "_" | ".." ) , ( "-->" | "==>" ) , block_body , eol ;
route_statement = "route" , [ "(" , expression , ")" ] , "{" , eol , { route_arm } , "}" ;

(* --- 5. PATTERN MATCHING (MATCH) --- *)
match_pattern   = literal | ( generic_upper_identifier , [ "::" , generic_upper_identifier ] , [ "(" , [ argument_list ] , ")" ] ) | "_" ;
match_arm       = match_pattern , [ "if" , expression ] , "==>" , ( expression | block_body ) , eol ;
match_statement = "match" , expression , "{" , eol , { match_arm } , "}" ;

(* --- 6. SHORT-CIRCUIT OPERATOR '?' --- *)
short_circuit_fail_arm = "==>" , ( emit_statement | block_body ) , eol ;
short_circuit_nice_arm = "==>" , ( emit_statement | block_body ) , eol ;
short_circuit_block    = "{" , eol , short_circuit_fail_arm , short_circuit_nice_arm , "}" ;

(* --- 7. CLEANUP AND GUARANTEE (ENSURE) --- *)
ensure_block = "ensure" , block_body ;

(* --- 8. CONTRACTS AND IMPLEMENTATIONS (CONTRACT / IMPL / OP) --- *)
contract_op_sig      = [ "op" ] , generic_lower_identifier , "(" , [ parameter_list ] , ")" , [ ( "as" | ":" ) , type_reference ] , eol ;
contract_body        = "{" , eol , { contract_op_sig } , "}" ;
contract_declaration = "contract" , "(" , generic_upper_identifier , ")" , contract_body , eol ;

op_declaration = "op" , generic_lower_identifier , "(" , [ parameter_list ] , ")" , [ ( "as" | ":" ) , type_reference ] , [ "==>" ] , block_body , eol ;

impl_body        = "{" , eol , { op_declaration | function_declaration } , "}" ;
impl_declaration = "impl" , "(" , generic_upper_identifier , ")" , [ "for" , "(" , generic_upper_identifier , ")" ] , impl_body , eol ;

(* --- 9. AGENT MODEL (AGENT) --- *)
agent_body        = "{" , eol , { storage_declaration | function_declaration | op_declaration } , "}" ;
agent_declaration = "agent" , "(" , generic_upper_identifier , ")" , [ "impl" , generic_upper_identifier ] , agent_body , eol ;

(* --- 10. FUNCTION DECLARATIONS WITH MANDATORY RETURN (FUNCTION / EMIT) --- *)
emit_status    = "nice" | "fail" ;
emit_statement = "emit" , "(" , emit_status , "," , identifier , "," , ( string_literal | interpolated_string ) , ")" ;

parameter_item = [ "mut" | "imut" ] , [ "as" ] , type_reference , ":" , generic_lower_identifier ;
parameter_list = parameter_item , { "," , parameter_item } ;

function_statement = storage_declaration 
                   | variable_reassignment 
                   | print_statement , eol
                   | input_statement , eol
                   | spy_statement , eol
                   | match_statement , eol
                   | route_statement , eol
                   | infinite_statement , eol
                   | break_statement
                   | continue_statement
                   | short_circuit_block , eol
                   | emit_statement , eol ;

block_body    = "{" , eol , { function_statement } , "}" ;
function_body = "{" , eol , { function_statement } , [ emit_statement , eol ] , "}" ;

function_declaration = [ "async" ] , "function" , "(" , generic_lower_identifier , ")" , "(" , [ parameter_list ] , ")" , [ "as" , type_reference ] , function_body , eol ;

(* --- 11. PROGRAM ENTRY POINT (PROGRAM) --- *)
program_statement   = storage_declaration | use_declaration | function_declaration | variable_reassignment | print_statement , eol | route_statement , eol | match_statement , eol | infinite_statement , eol ;
program_body        = "{" , eol , { program_statement } , "}" ;
program_declaration = "program" , "(" , generic_upper_identifier , ")" , program_body , eol ;

(* --- 12. STRUCTURE DECLARATIONS (STRUCT / ENUM) --- *)
enum_member_field = [ ( "mut" | "imut" ) ] , [ ":" ] , "." , generic_lower_identifier , ":" , type_reference ;
enum_member       = generic_upper_identifier , [ "(" , enum_member_field , { "," , enum_member_field } , ")" ] , eol ;
enum_body         = "{" , eol , enum_member , { enum_member } , "}" ;
enum_declaration  = "enum" , "(" , generic_upper_identifier , ")" , [ "as" , primitive_type ] , enum_body , eol ;

struct_field       = ( "mut" | "imut" ) , [ ":" ] , "." , ( generic_lower_identifier | generic_upper_identifier ) , ":" , type_reference , eol ;
struct_body        = "{" , eol , struct_field , { struct_field } , "}" ;
struct_declaration = "struct" , "(" , ( generic_lower_identifier | generic_upper_identifier ) , ")" , struct_body , eol ;


    (* ========================================== *)
    (*          BLOCK 7: ENTRY POINTS        *)
    (* ========================================== *)

documented_use_declaration      = { docstring , eol } , use_declaration ;
documented_struct_declaration   = { docstring , eol } , struct_declaration ;
documented_enum_declaration     = { docstring , eol } , enum_declaration ;
documented_type_declaration      = documented_struct_declaration | documented_enum_declaration ;
documented_variable_declaration = { docstring , eol } , storage_declaration ;
documented_function_declaration = { docstring , eol } , function_declaration ;
documented_contract_declaration = { docstring , eol } , contract_declaration ;
documented_impl_declaration     = { docstring , eol } , impl_declaration ;
documented_program_declaration  = { docstring , eol } , program_declaration ;
documented_agent_declaration    = { docstring , eol } , agent_declaration ;

(* Main Execution File (.flux) *)
flux_file = { eol } 
          , { documented_use_declaration } 
          , { documented_type_declaration } 
          , { documented_variable_declaration } 
          , { documented_function_declaration } 
          , documented_program_declaration 
          , { eol } , eof ;

(* Domain / Agent Definition File (.fdsl) *)
fdsl_file = { eol } 
          , { documented_use_declaration } 
          , { documented_type_declaration } 
          , { documented_variable_declaration } 
          , { documented_contract_declaration }
          , { documented_impl_declaration }
          , { documented_function_declaration } 
          , documented_agent_declaration , { eol , documented_agent_declaration } 
          , { eol } , eof ;


    (* ========================================== *)
    (*     BLOCK 8: MESSAGES AND DIAGNOSTICS       *)
    (* ========================================== *)

filename_char = ? any source-name character except colon ? ;
filename      = filename_char , { filename_char } ;
source_name   = filename | "<stdin>" ;
line          = integer_literal | "?" ;
column        = integer_literal | "?" ;
message_char  = ? any diagnostic text character ? ;
message       = message_char , { message_char } ;

diagnostic_code = "LEX001" | "LEX002" | "LEX003" | "LEX004" | "LEX005" | "LEX006" | "LEX007"
                | "PAR001" | "PAR002" | "PAR003" | "PAR004" | "PAR005" | "PAR006" | "PAR007" | "PAR008"
                | "SEM001" | "SEM002" | "SEM003" | "SEM004" | "SEM005" | "SEM006" | "SEM007" | "SEM008"
                | "SEM009" | "SEM010" | "SEM011" | "SEM012" | "SEM013" | "SEM014" | "SEM015"
                | "SUG001" ;
```

---

## 4. Implementation Guide and Semantics

### 4.1. Type System and AI/ML Quantization
1. **Floating-Point Types**: In addition to `float16`, `float32`, and `float64`, the compiler provides hardware-aligned ML formats:
   - `fp8_e4m3` (4-bit exponent, 3-bit mantissa) and `fp8_e5m2` (5-bit exponent, 2-bit mantissa).
   - `bf16_e8m7` (Bfloat16 with identical dynamic range to float32).
   - `tf32_e8m10` (TensorFloat-32 with enhanced precision).
2. **Complex Numbers**: Native support for `complex32` (2x float16), `complex64` (2x float32), and `complex128` (2x float64) with `i` or `j` literal suffix.
3. **Date and Time**: The `datetime` type strictly follows ISO 8601 with nanosecond precision and explicit timezones (`Z` or `±HH:MM`).
4. **Collections and Tensors**: Collections are strongly typed via the `of` keyword: `list of <type>`, `set of <type>`, `tensor[dim1, dim2, ...] of <numeric_type>`.

### 4.2. Return Contract and State Handling (`emit` / `?`)
Every function with a declared return type must terminate with a terminal `emit(status, value, message)` command:
- The result materializes into a Result Frame containing `.sta` ("nice" or "fail"), `.val` (typed value), and `.msg` (explanatory message).
- The postfix short-circuit operator `?` inspects the Result Frame, dispatching early to the failure branch or continuing with the success value.

---

## 5. References and Related Documents
- [`TheFlux.ebnf`](file:///D:/Projetos/TheFlux/docs/TheFlux.ebnf): Pure ISO/IEC 14977 EBNF grammar file.
- [`pt/keywords/`](file:///D:/Projetos/TheFlux/docs/pt/keywords): Portuguese YAML keyword catalog.
- [`en/keywords/`](file:///D:/Projetos/TheFlux/docs/en/keywords): English YAML keyword catalog.
- [`site/index.html`](file:///D:/Projetos/TheFlux/docs/site/index.html): Interactive Bilingual Documentation Portal.
- [`Errors.md`](file:///D:/Projetos/TheFlux/docs/en/Errors.md): Official Diagnostic and Error Catalog.
