# TheFlux Language Specification (v0.5)

Este documento contém a especificação formal completa da linguagem **TheFlux** (versão 0.5), estruturada de acordo com o padrão internacional **ISO/IEC 14977 (EBNF)** e enriquecida com as extensões **UTF-8 / Unicode**, guia de tipos numéricos especializados para IA/ML, regras operacionais de execução e organização modular da suíte de compilação.

---

## 1. Visão Geral da Arquitetura & Especificação

- **Versão da Especificação**: TheFlux Specification v0.5 (Snapshot RC: 2026-07-20).
- **Encoding de Código-Fonte**: **UTF-8 estrito**. Identificadores, palavras-chave e operadores utilizam a faixa ASCII de 7 bits; caracteres Unicode (U+0080..U+10FFFF) são aceitos em strings, caracteres (`char`), comentários e docstrings.
- **Estrutura Modular de Arquivos**:
  - Arquivos `.flux`: Ponto de entrada executável contendo declarações de módulo e finalizando obrigatoriamente com o bloco `program (<NomePascalCase>) { ... }`.
  - Arquivos `.fdsl`: Módulos de domínio de agentes inteligentes contendo `agent`, `contract`, `impl` e funções auxiliares (proibido o uso de `program`).

---

## 2. Tabela Oficial de Precedência de Operadores

A avaliação de expressões em TheFlux segue 17 níveis estritos de precedência:

| Nível | Associatividade | Categoria | Operadores |
| :---: | :---: | :--- | :--- |
| **1** | R &rarr; L | Atribuição simples e composta | `=`, `=+`, `=-`, `=*`, `=/f`, `=/i`, `=/r`, `=^e`, `=^r`, `=^`, `=\|`, `=^`, `=~`, `=<<`, `=>>`, `=>>>` |
| **2** | L &rarr; R | Recuperação e fallback | `catch`, `fallback` |
| **3** | L &rarr; R | Dataflow e bifurcação | `-->`, `==>`, `split`, `join` |
| **4** | L &rarr; R | Disjunção lógica | `or` |
| **5** | L &rarr; R | Conjunção lógica | `and` |
| **6** | L &rarr; R | Bitwise OR | `\|` |
| **7** | L &rarr; R | Bitwise XOR | `^` |
| **8** | L &rarr; R | Bitwise AND | `&` |
| **9** | L &rarr; R | Comparação relacional | `==`, `!=`, `<`, `>`, `<=`, `>=` |
| **10** | L &rarr; R | Pertinência / iteração | `in` |
| **11** | L &rarr; R | Intervalo (range) | `..` |
| **12** | L &rarr; R | Deslocamento de bits (shift) | `<<`, `>>`, `>>>` |
| **13** | L &rarr; R | Aritmética aditiva | `+`, `-` |
| **14** | L &rarr; R | Aritmética multiplicativa | `*`, `/f` *(divisão real)*, `/i` *(divisão inteira)*, `/r` *(resto)* |
| **15** | R &rarr; L | Potenciação e radiciação | `^e` *(potência)*, `^r` *(raiz n-ésima)* |
| **16** | &mdash; | Unário / Prefixo | `+`, `-`, `not`, `!`, `~`, `unquote`, `spawn`, `await`, `move()`, `borrow()`, `keep()` |
| **17** | &mdash; | Pós-fixo e chamadas *(maior)* | `()`, `[]`, `.`, `::`, `ensure { }`, `as`, `?` *(short-circuit)* |

> [!NOTE]
> Parênteses `( expressão )` possuem a maior precedência possível e forçam a avaliação antecipada de qualquer subexpressão.

---

## 3. Especificação Formal ISO/IEC 14977 (EBNF)

```ebnf
(* ================================================================== *)
(* EBNF (ISO/IEC 14977) - TheFlux v0.5 Specification                  *)
(* Gramatica Formal Padrao da Linguagem TheFlux                       *)
(* ================================================================== *)

(*
EBNF:PRECEDENCIA - Tabela de precedencia de operadores (da menor para a maior)

    Nivel  Assoc  Categoria             Operadores
    1      R->L   Atribuicao            = =+ =- =* =/f =/i =/r =^e =^r =& =| =^ =~ =<< =>> =>>>
    2      L->R   Recuperacao           catch fallback
    3      L->R   Dataflow              --> ==> split join
    4      L->R   Disjuncao logica      or
    5      L->R   Conjuncao logica      and
    6      L->R   Bitwise OR            |
    7      L->R   Bitwise XOR           ^
    8      L->R   Bitwise AND           &
    9      L->R   Relacional            == != < > <= >=
    10     L->R   Pertinencia           in
    11     L->R   Range                 ..
    12     L->R   Shift                 << >> >>>
    13     L->R   Aditivo               + -
    14     L->R   Multiplicativo        * /f /i /r
    15     R->L   Potencia              ^e ^r
    16     -      Prefixo / unario      + - not ! ~ unquote spawn await move() borrow() keep()
    17     -      Pos-fixo              () [] . :: ensure { } as ? (maior precedencia)

    Parenteses "(" expression ")" tem a maior precedencia possivel.
    Expressoes entre parenteses forcam avaliacao antecipada.
*)

    (* ========================================== *)
    (*     BLOCO 1: CONVENÇÃO E IDENTIFICADORES   *)
    (* ========================================== *)

(* --- Camada 1: Unidades Léxicas de Suporte --- *)
lower_letter  = "a" | "b" | "c" | "d" | "e" | "f" | "g" | "h" | "i" | "j" | "k" | "l" | "m" 
              | "n" | "o" | "p" | "q" | "r" | "s" | "t" | "u" | "v" | "w" | "x" | "y" | "z" ;

upper_letter  = "A" | "B" | "C" | "D" | "E" | "F" | "G" | "H" | "I" | "J" | "K" | "L" | "M" 
              | "N" | "O" | "P" | "Q" | "R" | "S" | "T" | "U" | "V" | "W" | "X" | "Y" | "Z" ;

nonzero_digit = "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" ;
digit         = "0" | nonzero_digit ;
hex_digit     = digit | "a" | "b" | "c" | "d" | "e" | "f" | "A" | "B" | "C" | "D" | "E" | "F" ;

(* --- Camada 2: Formas Léxicas de Expressão de Estilos --- *)

(* Padrão 1: snake_case (variáveis mutáveis, campos mutáveis, funções, parâmetros) *)
style_snake_case = lower_letter , { lower_letter | digit | "_" } ;

(* Padrão 2: camelCase (funções, operações) *)
style_camel_case = lower_letter , { lower_letter | digit } , { upper_letter , { lower_letter | digit } } ;

(* Padrão 3: PascalCase (tipos compostos, contratos, agentes, programas, enums) *)
style_pascal_case = upper_letter , { lower_letter | digit } , { upper_letter , { lower_letter | digit } } ;

(* Padrão 4: SCREAMING_SNAKE_CASE (constantes imutáveis, campos imutáveis de struct) *)
style_screaming_snake = upper_letter , { upper_letter | digit | "_" } ;

(* Regra: Palavras Reservadas da Linguagem. Usado via set subtraction em identificadores *)
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

(* --- Camada 3: Filtros de Identificadores (Ordem Otimizada e Protegida) --- *)

(* Identificador Minúsculo Estrito: snake_case e camelCase excluindo keywords *)
generic_lower_identifier = ( style_snake_case | style_camel_case ) - keyword ;

(* Identificador Maiúsculo Estrito: Tipos, contratos, enums, agentes e programas (PascalCase) *)
generic_upper_identifier = style_pascal_case - keyword ;

(* Identificador de Constantes: Constantes imutáveis (SCREAMING_SNAKE_CASE) *)
constant_identifier = style_screaming_snake - keyword ;

(* Identificador Universal Raiz / Wildcard *)
system_wildcard_identifier = ( "_" , { lower_letter | upper_letter | digit | "_" } ) - keyword ;

(* Regra Unificada Final de Identificação *)
identifier = generic_lower_identifier | generic_upper_identifier | constant_identifier | system_wildcard_identifier ;

    (* ========================================== *)
    (*     SUBLOCO: CARACTERES BASE E FILTROS     *)
    (* ========================================== *)

(* Regra: Quebras de Linha Nativas *)
line_break = "
" | "

" | "
" ;

(* Regra: Qualquer Caractere Imprimível ou Espaço na Tabela ASCII e Code Points Unicode UTF-8 *)
any_ascii_char = line_break | ? caractere ASCII imprimivel ou espaco (codigo 0x20 a 0x7E) ? ;

(* Regra: Base para Comentários de Linha e Bloco (7 bits + Unicode) *)
any_comment_char = ? caractere ASCII de 7 bits (codigo 0x00 a 0x7F) ou code point Unicode (U+0080..U+10FFFF), exceto TAB (0x09), \n e \r ? ;

(* Regra: Atalho Semântico para Caracteres em Linha Única *)
any_char_except_line_break = any_comment_char ;

(* Regra: Caractere Seguro em Bloco de Comentário (evita fechamento acidental B#) *)
any_char_except_block_end = ? any_comment_char com a restricao de que a sequencia "B#" nao seja formada ? ;

(* Regra: Caracteres Permitidos em Documentações Automáticas (Docstrings) *)
doc_char = ? caractere ASCII imprimivel ou espaco em branco, ou code point Unicode, exceto a sequencia "D#" ? | line_break ;

(* Regra: Caractere Imprimível Padrão para Validação de Strings e Chars (inclui Unicode UTF-8) *)
ascii_printable = ? caractere imprimivel ASCII (codigo 0x20 a 0x7E: espaco a tilde) ou code point Unicode (U+0080..U+10FFFF) ? ;

(* Regra: Filtro Especial para Impedir Aspas Simples Soltas em Literais Char *)
ascii_printable_except_single_quote_backslash_line_break = ascii_printable - ( "'" | "\" | "
" | "
" ) ;

(* Regra: Filtro Especial para Strings Delimitadas por Aspas Duplas *)
ascii_printable_except_double_quote_backslash_line_break = ascii_printable - ( '"' | "\" | "
" | "
" ) ;

    (* ========================================== *)
    (*     SUBLOCO: COMENTÁRIOS E CONTROLE        *)
    (* ========================================== *)

(* Regra: Comentário de Linha Única Iniciado com #L *)
line_comment = "#L" , { any_char_except_line_break } , ( line_break | ? fim de arquivo ? ) ;

(* Regra: Comentário em Bloco com Delimitadores Herméticos #B e B# *)
block_comment = "#B" , { any_char_except_block_end } , "B#" ;

(* Regra: Comentário Geral *)
comment = line_comment | block_comment ;

(* Regra: Docstring Integrada para Documentação de Tipos, Funções e Agentes (#D ... D#) *)
docstring = "#D" , { doc_char } , "D#" ;

(* Regra: Espaços em Branco Puros *)
pure_whitespace = " " ;
ws = { pure_whitespace } ;

(* Regra: Fim de Linha Estrutural *)
eol = ws , [ comment ] , line_break , { ws , ( line_break | comment ) } ;

(* Regra: Fim de Arquivo Físico *)
eof = ? fim do fluxo de caracteres de entrada (EOF) ? ;


    (* ========================================== *)
    (*          BLOCO 2: NÚMEROS E LITERAIS       *)
    (* ========================================== *)

(* Regra: Literais Numéricos Inteiros em Base Decimal *)
integer_literal = "0" | ( nonzero_digit , { digit } ) ;

(* Regra: Literais de Ponto Flutuante (Notação Padrão e Científica) *)
float_literal = integer_literal , "." , { digit } , [ ( "e" | "E" ) , [ "+" | "-" ] , digit , { digit } ]
              | "." , digit , { digit } , [ ( "e" | "E" ) , [ "+" | "-" ] , digit , { digit } ]
              | integer_literal , ( "e" | "E" ) , [ "+" | "-" ] , digit , { digit } ;

(* Regra: Sufixo de Número Imaginário *)
imaginary_suffix = "i" | "j" ;

(* Regra: Literal Imaginário Puro *)
imaginary_literal = ( float_literal | integer_literal ) , imaginary_suffix ;

(* Regra: Literal de Número Complexo Completo *)
complex_literal = [ ( float_literal | integer_literal ) , ( "+" | "-" ) ] , imaginary_literal ;

(* Regra: Literais Booleanos (PascalCase canônico True/False ou minúsculo true/false) *)
boolean_literal = "True" | "False" | "true" | "false" ;

    (* --- DATA E HORA ISO 8601 COM NANOSSEGUNDOS --- *)
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

    (* --- SUPORTE A TEXTO E CARACTERES --- *)

(* Sequências de escape clássicas e Unicode \u{XXXX} *)
escape_sequence = "\" , ( "'" | '"' | "\" | "n" | "t" | "r" | "0" ) 
                | "\u{" , hex_digit , { hex_digit } , "}" ;

(* Regra: Literal de Caractere Único (code point Unicode) *)
char_literal = "'" , ( ascii_printable_except_single_quote_backslash_line_break | escape_sequence ) , "'" ;

(* Regra: Literal de String/Texto Estático (UTF-8) *)
string_literal = '"' , { ascii_printable_except_double_quote_backslash_line_break | escape_sequence } , '"' ;

(* Regra: Interpolação de Strings #{ expr } *)
string_interpolation = "#{" , expression , "}" ;
interpolated_string  = '"' , { ascii_printable_except_double_quote_backslash_line_break | escape_sequence | string_interpolation } , '"' ;

(* Regra Unificada de Literais *)
literal = datetime_literal
        | complex_literal
        | float_literal
        | integer_literal
        | boolean_literal
        | char_literal
        | string_literal
        | interpolated_string ;


    (* ========================================== *)
    (*          BLOCO 3: TIPOS PRIMITIVOS         *)
    (* ========================================== *)

(* Tipos Inteiros com Sinal e Sem Sinal de Largura Fixa *)
signed_int_type   = "int8" | "int16" | "int32" | "int64" ;
unsigned_int_type = "uint8" | "uint16" | "uint32" | "uint64" ;
integer_type      = signed_int_type | unsigned_int_type ;

(* Tipos de Ponto Flutuante IEEE 754 e Especiais para IA/ML *)
standard_float_type = "float16" | "float32" | "float64" ;
ai_float_type       = "fp8_e4m3" | "fp8_e5m2" | "bf16_e8m7" | "tf32_e8m10" ;
float_type          = standard_float_type | ai_float_type ;

(* Tipos Complexos *)
complex_type = "complex32" | "complex64" | "complex128" ;

(* Tipos Numéricos e Temporais *)
numeric_type         = integer_type | float_type | complex_type ;
datetime_type        = "datetime" ;
numeric_or_time_type = numeric_type | datetime_type ;

(* Tipos Escalares Primitivos *)
char_type    = "char" ;
string_type  = "string" , [ "(" , integer_literal , ")" ] ;
boolean_type = "bool" ;

primitive_scalar_type = numeric_or_time_type | char_type | string_type | boolean_type ;
primitive_type        = primitive_scalar_type ;

(* Tipos de Coleção Dinâmica e Tipada *)
data_type = "data" ;
map_type  = "map" ;
list_type = "list" , "of" , type_reference ;
set_type  = "set" , "of" , type_reference ;

(* Tipo Tensor Multidimensional *)
tensor_dimensions = "[" , integer_literal , { "," , integer_literal } , "]" ;
tensor_type       = "tensor" , tensor_dimensions , "of" , primitive_type ;

(* Referência Completa a Tipos *)
user_type      = generic_upper_identifier ;
type_reference = primitive_type | tensor_type | data_type | map_type | list_type | set_type | user_type ;


    (* ========================================== *)
    (*          BLOCO 4: DECLARAÇÕES BASE         *)
    (* ========================================== *)

(* Declaração de Variável Mutável: mut as <tipo>: <id> [= <expr>] *)
variable_item        = generic_lower_identifier , [ "=" , expression ] ;
variable_list        = variable_item , { "," , variable_item } ;
mutable_declaration  = "mut" , "as" , type_reference , ":" , variable_list , eol ;

(* Declaração de Constante Imutável: imut as <tipo>: <id> = <expr> *)
constant_item         = ( generic_lower_identifier | constant_identifier ) , "=" , expression ;
constant_list         = constant_item , { "," , constant_item } ;
immutable_declaration = "imut" , "as" , type_reference , ":" , constant_list , eol ;

storage_declaration = mutable_declaration | immutable_declaration ;

    (* --- OPERADORES E COMANDOS DE ATRIBUIÇÃO --- *)

assignment_operator = "="   | "=+"  | "=-"  | "=*"  | "=/f" | "=/i" | "=/r" | "=^e" | "=^r" 
                    | "=&"  | "=|"  | "=^"  | "=~"  | "=<<" | "=>>" | "=>>>" ;

variable_reassignment = ( generic_lower_identifier | postfix_expr ) , assignment_operator , expression , eol ;


    (* ========================================== *)
    (*             BLOCO 5: EXPRESSÕES            *)
    (* ========================================== *)

(* Operadores Unários e Primários *)
primary_expr = literal
             | identifier
             | "(" , expression , ")"
             | collection_literal ;

collection_literal = list_literal | set_literal | map_literal | data_literal ;
list_literal       = "[" , [ expression , { "," , expression } ] , "]" ;
set_literal        = "{" , [ expression , { "," , expression } ] , "}" ;
map_literal        = "{" , [ "." , identifier , ":" , expression , { "," , "." , identifier , ":" , expression } ] , "}" ;
data_literal       = "{" , [ "." , identifier , ":" , expression , { "," , "." , identifier , ":" , expression } ] , "}" ;

(* Operações Pós-Fixas (Acesso a Campo, Chamada, Indexação, Fatiamento, Cast, Short-Circuit) *)
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

(* Operadores por Nível de Precedência *)
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

(* Dataflow e Lambda *)
dataflow_op   = "-->" | "==>" | "split" | "join" ;
dataflow_expr = logical_or_expr , { dataflow_op , logical_or_expr } ;

(* Recuperação e Tratamento de Erros *)
recovery_op   = "catch" | "fallback" ;
recovery_expr = dataflow_expr , { recovery_op , ( dataflow_expr | block_body ) } ;

expression = recovery_expr ;


    (* ========================================== *)
    (*    BLOCO 6: FUNÇÕES, ESTRUTURAS E FLUXO    *)
    (* ========================================== *)

(* --- 1. COMANDO DE IMPORTAÇÃO (USE) --- *)
use_alias       = "as" , ( generic_upper_identifier | generic_lower_identifier ) ;
use_op_item     = generic_lower_identifier , [ use_alias ] ;
use_group       = "::" , "{" , use_op_item , { "," , use_op_item } , "}" ;
use_target      = generic_upper_identifier , [ use_group | ( "::" , generic_lower_identifier , [ use_alias ] ) | use_alias ] ;
use_declaration = "use" , use_target , eol ;

(* --- 2. SISTEMA DE SAÍDA E TELEMETRIA (BUILT-INS) --- *)
print_statement = "print" , "(" , expression , ")" ;
input_statement = "input" , "(" , [ string_literal ] , ")" ;
spy_statement   = "spy" ;

(* --- 3. CONTROLE DE LAÇOS (BREAK / CONTINUE / INFINITE) --- *)
break_statement    = "break" , eol ;
continue_statement = "continue" , eol ;

infinite_condition = expression | ( identifier , "in" , ( range_expr | expression ) ) ;
infinite_statement = "infinite" , [ "(" , infinite_condition , ")" ] , block_body , eol ;

(* --- 4. ROTEAMENTO CONDICIONAL (ROUTE) --- *)
route_arm       = ( expression | "_" | ".." ) , ( "-->" | "==>" ) , block_body , eol ;
route_statement = "route" , [ "(" , expression , ")" ] , "{" , eol , { route_arm } , "}" ;

(* --- 5. CASAMENTO DE PADRÕES (MATCH) --- *)
match_pattern   = literal | ( generic_upper_identifier , [ "::" , generic_upper_identifier ] , [ "(" , [ argument_list ] , ")" ] ) | "_" ;
match_arm       = match_pattern , [ "if" , expression ] , "==>" , ( expression | block_body ) , eol ;
match_statement = "match" , expression , "{" , eol , { match_arm } , "}" ;

(* --- 6. OPERADOR SHORT-CIRCUIT '?' --- *)
short_circuit_fail_arm = "==>" , ( emit_statement | block_body ) , eol ;
short_circuit_nice_arm = "==>" , ( emit_statement | block_body ) , eol ;
short_circuit_block    = "{" , eol , short_circuit_fail_arm , short_circuit_nice_arm , "}" ;

(* --- 7. CLEANUP E GARANTIA (ENSURE) --- *)
ensure_block = "ensure" , block_body ;

(* --- 8. CONTRATOS E IMPLEMENTAÇÕES (CONTRACT / IMPL / OP) --- *)
contract_op_sig      = [ "op" ] , generic_lower_identifier , "(" , [ parameter_list ] , ")" , [ ( "as" | ":" ) , type_reference ] , eol ;
contract_body        = "{" , eol , { contract_op_sig } , "}" ;
contract_declaration = "contract" , "(" , generic_upper_identifier , ")" , contract_body , eol ;

op_declaration = "op" , generic_lower_identifier , "(" , [ parameter_list ] , ")" , [ ( "as" | ":" ) , type_reference ] , [ "==>" ] , block_body , eol ;

impl_body        = "{" , eol , { op_declaration | function_declaration } , "}" ;
impl_declaration = "impl" , "(" , generic_upper_identifier , ")" , [ "for" , "(" , generic_upper_identifier , ")" ] , impl_body , eol ;

(* --- 9. MODELO DE AGENTES (AGENT) --- *)
agent_body        = "{" , eol , { storage_declaration | function_declaration | op_declaration } , "}" ;
agent_declaration = "agent" , "(" , generic_upper_identifier , ")" , [ "impl" , generic_upper_identifier ] , agent_body , eol ;

(* --- 10. DECLARAÇÃO DE FUNÇÕES COM RETORNO OBRIGATÓRIO (FUNCTION / EMIT) --- *)
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

(* --- 11. PONTO DE ENTRADA DO PROGRAMA (PROGRAM) --- *)
program_statement   = storage_declaration | use_declaration | function_declaration | variable_reassignment | print_statement , eol | route_statement , eol | match_statement , eol | infinite_statement , eol ;
program_body        = "{" , eol , { program_statement } , "}" ;
program_declaration = "program" , "(" , generic_upper_identifier , ")" , program_body , eol ;

(* --- 12. DECLARAÇÃO DE ESTRUTURAS (STRUCT / ENUM) --- *)
enum_member_field = [ ( "mut" | "imut" ) ] , [ ":" ] , "." , generic_lower_identifier , ":" , type_reference ;
enum_member       = generic_upper_identifier , [ "(" , enum_member_field , { "," , enum_member_field } , ")" ] , eol ;
enum_body         = "{" , eol , enum_member , { enum_member } , "}" ;
enum_declaration  = "enum" , "(" , generic_upper_identifier , ")" , [ "as" , primitive_type ] , enum_body , eol ;

struct_field       = ( "mut" | "imut" ) , [ ":" ] , "." , ( generic_lower_identifier | generic_upper_identifier ) , ":" , type_reference , eol ;
struct_body        = "{" , eol , struct_field , { struct_field } , "}" ;
struct_declaration = "struct" , "(" , ( generic_lower_identifier | generic_upper_identifier ) , ")" , struct_body , eol ;


    (* ========================================== *)
    (*          BLOCO 7: PONTOS DE ENTRADA        *)
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

(* Arquivo Principal de Execução (.flux) *)
flux_file = { eol } 
          , { documented_use_declaration } 
          , { documented_type_declaration } 
          , { documented_variable_declaration } 
          , { documented_function_declaration } 
          , documented_program_declaration 
          , { eol } , eof ;

(* Arquivo de Definição de Domínio / Agentes (.fdsl) *)
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
    (*     BLOCO 8: MENSAGENS E DIAGNÓSTICO       *)
    (* ========================================== *)

filename_char = ? qualquer caractere de nome-fonte exceto dois-pontos ? ;
filename      = filename_char , { filename_char } ;
source_name   = filename | "<stdin>" ;
line          = integer_literal | "?" ;
column        = integer_literal | "?" ;
message_char  = ? qualquer caractere de texto de diagnostico ? ;
message       = message_char , { message_char } ;

diagnostic_code = "LEX001" | "LEX002" | "LEX003" | "LEX004" | "LEX005" | "LEX006" | "LEX007"
                | "PAR001" | "PAR002" | "PAR003" | "PAR004" | "PAR005" | "PAR006" | "PAR007" | "PAR008"
                | "SEM001" | "SEM002" | "SEM003" | "SEM004" | "SEM005" | "SEM006" | "SEM007" | "SEM008"
                | "SEM009" | "SEM010" | "SEM011" | "SEM012" | "SEM013" | "SEM014" | "SEM015"
                | "SUG001" ;
```

---

## 4. Guia de Implementação e Semântica

### 4.1. Sistema de Tipos e Quantização para IA/ML
1. **Tipos de Ponto Flutuante**: Além de `float16`, `float32` e `float64`, o compilador implementa os formatos modernos de aprendizado de máquina:
   - `fp8_e4m3` (4 bits expoente, 3 bits mantissa) e `fp8_e5m2` (5 bits expoente, 2 bits mantissa).
   - `bf16_e8m7` (Bfloat16 com mesma faixa dinâmica de float32).
   - `tf32_e8m10` (TensorFloat-32 com precisão ampliada).
2. **Números Complexos**: Suporte nativo a `complex32` (2x float16), `complex64` (2x float32) e `complex128` (2x float64) com sufixo `i` ou `j`.
3. **Data e Hora**: O tipo `datetime` segue a norma ISO 8601 com suporte a nanossegundos e fusos horários explícitos (sufixo `Z` ou `±HH:MM`).
4. **Coleções e Tensores**: Coleções são fortemente tipadas através do operador `of`: `list of <tipo>`, `set of <tipo>`, `tensor[dim1, dim2, ...] of <tipo_numérico>`.

### 4.2. Contrato de Retorno e Tratamento Estatal (`emit` / `?`)
Toda função com tipo de retorno declarado finaliza obrigatoriamente com o comando terminal `emit(status, identificador, mensagem)`:
- O resultado é materializado em uma estrutura contendo `.sta` ("nice" ou "fail"), `.val` (valor tipado) e `.msg` (mensagem explicativa).
- O operador pós-fixo short-circuit `?` avalia o resultado e despacha para o braço de falha ou sucesso sem necessidade de reavaliar a expressão.

---

## 5. Referências e Documentos Relacionados
- [`TheFlux.ebnf`](file:///D:/Projetos/TheFlux/docs/TheFlux.ebnf): Arquivo puro de gramática EBNF ISO/IEC 14977.
- [`grammar.md`](file:///D:/Projetos/TheFlux/docs/grammar.md): Manual técnico de engenharia com contrato de diagnósticos (`LEX`/`PAR`/`SEM`) e lowering para múltiplos backends.
- [`keywords/`](file:///D:/Projetos/TheFlux/docs/keywords): Catálogo documentado em YAML das palavras-chave em Português e Inglês.
