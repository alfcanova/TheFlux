/* ==================================================================
   GRAMATICA DA IMPLEMENTACAO ATUAL - TheFlux v0.5
   EBNF consolidada gerada a partir dos modulos lexer/parser
   src/flux_proto/*_flux.py.

   Snapshot RC: 2026-07-20.
   Versoes: SPEC 0.5, CLI 0.5.0, fvmbc version 1,
   instruction_version 3, stdlib 0.5.0, WASM native lowering v0.5.

   ENCODING:
   - Codigo fonte em UTF-8. Identificadores, palavras-chave,
     operadores e delimitadores sao ASCII 7-bit; bytes fora da
     faixa ASCII (codigo > 0x7F) sao aceitos apenas em strings,
     chars, comentarios e docstrings.
   - string e codificada em UTF-8; len() conta bytes UTF-8.
   - char representa exatamente um code point Unicode
     (U+0000..U+10FFFF), armazenado como valor de 32 bits
     (UTF-32) nos backends compilados (llvm/wat/wasm); a
     conversao para UTF-8 (1-4 bytes) acontece apenas na
     impressao/concatencao com string.
   - O escape_sequence classico (\\', \\", \\\\, \\n, \\t, \\r, \\0)
     e suportado em strings e chars, alem de \\u{XXXX} (1-6 hex,
     sem surrogates, max U+10FFFF) para code points Unicode.
   - Bytes nao-ASCII fora de strings/chars/comentarios/docstrings
     resultam em erro de leitura (LEX001).

   - Descreve a sintaxe atualmente aceita pelo prototipo Python.
   - Tokens reservados sao listados, com comentarios marcando
     constructos que sao rejeitados cedo ou falham explicitamente
     quando as semanticas de runtime estao indisponiveis.
   - Restricoes semanticas como regras de capitalizacao, mutabilidade,
     verificacoes numericas de elementos tensor, e exclusividade de
     arquivo funcao/agent sao documentadas aqui como restricoes
     do lado da gramatica.
   ================================================================== */


/* ================================================================
   0. CONVENCOES EBNF
   ================================================================ */

/*
   "x"        texto literal fonte
   A | B      alternativa
   [ A ]      opcional
   { A }      repeticao, zero ou mais
   A - B      exclusao informal

    Tokens artificiais emitidos pelo lexer:
    eol, indent, dedent, eof, docstring.
*/


/* ================================================================
   1. CARACTERES E IDENTIFICADORES
   ================================================================ */

digit                ::= "0" | nonzero_digit ;

nonzero_digit        ::= "1" | "2" | "3" | "4" | "5"
                        | "6" | "7" | "8" | "9" ;

hex_digit            ::= digit | "a" | "b" | "c" | "d" | "e" | "f"
                        | "A" | "B" | "C" | "D" | "E" | "F" ;

lower_letter         ::= "a" | "b" | "c" | "d" | "e" | "f"
                        | "g" | "h" | "i" | "j" | "k" | "l"
                        | "m" | "n" | "o" | "p" | "q" | "r"
                        | "s" | "t" | "u" | "v" | "w" | "x"
                        | "y" | "z" ;

upper_letter         ::= "A" | "B" | "C" | "D" | "E" | "F"
                        | "G" | "H" | "I" | "J" | "K" | "L"
                        | "M" | "N" | "O" | "P" | "Q" | "R"
                        | "S" | "T" | "U" | "V" | "W" | "X"
                        | "Y" | "Z" ;

style_snake_case     ::= lower_letter { lower_letter | digit | "_" } ;

style_camel_case     ::= lower_letter { lower_letter | digit }
                         { upper_letter { lower_letter | digit } } ;

style_pascal_case    ::= upper_letter { lower_letter | digit }
                         { upper_letter { lower_letter | digit } } ;

style_screaming_snake
                       ::= upper_letter { upper_letter | digit | "_" } ;

/* Restrição:
   Identificadores não podem coincidir com keywords.
   O filtro é aplicado via set subtraction (- keyword) nas
   produções generic_lower_identifier, generic_upper_identifier,
   constant_identifier e system_wildcard_identifier.
*/

generic_lower_identifier
                       ::= ( style_snake_case | style_camel_case )
                           - keyword ;

generic_upper_identifier
                       ::= style_pascal_case - keyword ;

constant_identifier
                       ::= style_screaming_snake - keyword ;

system_wildcard_identifier
                       ::= ( "_" { lower_letter | upper_letter | digit | "_" } )
                           - keyword ;

identifier           ::= generic_lower_identifier
                         | generic_upper_identifier
                         | constant_identifier
                         | system_wildcard_identifier ;

/*
   Capitalizacao imposta pelo parser/analise semantica:

   Categoria               | Producao                  | Exemplo
   ------------------------|---------------------------|--------------------
   Variavel imutavel       | constant_identifier       | MAX_VALOR, PI
   Variavel mutavel        | generic_lower_identifier  | minha_variavel
   Iterador infinite       | generic_lower_identifier  | item, valor
   Funcao / op / alias     | generic_lower_identifier  | calcularTotal
   Struct / init (callee)  | generic_lower_identifier  | meuPonto / ponto()
   Enum / variante         | generic_lower_identifier  | status / ativo
   Agent / alias           | generic_upper_identifier  | MeuServico
   Contract                | generic_upper_identifier  | Validador
   Program                 | generic_upper_identifier  | MeuPrograma

   Violacoes emitem SUGGESTION com a capitalizacao correta.

   Nota sobre alias:
   "alias" na tabela acima e um conceito - o nome apelidado
   via a palavra-chave "as". Nao ha keyword "alias" em Flux.
   As formas concretas de alias sao as clausulas "as" em
    use_declaration (Secao 11):
     use Agent as Alias          (* alias de agente *)
     use Agent::op as alias      (* alias de operacao *)
     use Agent::{ op as alias }  (* alias em grupo *)
   A capitalizacao exigida segue a categoria do alias:
     - camelCase para alias de funcao/op (calcularTotal)
     - PascalCase para alias de agent (MeuServico)
*/


/* ================================================================
   2. CONJUNTOS DE CARACTERES (usados em producoes posteriores)
   ================================================================ */

/*
   Notacao: producoes com prefixo "any_ascii_" abrangem caracteres
   validos em codigo fonte (imprimiveis 0x20–0x7E + line_break).
   Producoes com prefixo "any_comment_" abrangem o espectro completo
   0x00–0x7F (exceto TAB), usadas exclusivamente em comentarios.
   Producoes com prefixo "ascii_" abrangem subconjuntos
   (ex: imprimiveis 0x20–0x7E). Definicoes usam ?...? (ISO 14977)
   para faixas.
*/

line_break           ::= "\n" | "\r\n" | "\r" ;

any_ascii_char       ::= line_break
                       | ? caractere ASCII imprimivel ou espaco
                           (codigo 0x20–0x7E) ? ;

any_comment_char     ::= ? caractere ASCII de 7 bits
                            (codigo 0x00–0x7F) ou qualquer code point
                            Unicode (U+0080..U+10FFFF),
                            exceto TAB (0x09),
                            "\n" e "\r" ? ;

any_char_except_line_break
                      ::= any_comment_char ;

/*
   any_char_except_block_end: qualquer caractere ASCII, exceto "B"
   quando seguido por "#", para evitar fechamento prematuro de
   block_comment.

   NOTA DE IMPLEMENTACAO - Lookahead (1 char):
   Quando o caractere atual e "B", o lexer da peek no proximo:
     - Se "#": "B#" fecha o block_comment; "B" NAO e incluido.
     - Senao: "B" e incluido no conteudo.
   Sem backtracking.
*/
any_char_except_block_end
                      ::= ? any_comment_char com a restricao
                            de que a sequencia "B#" nao seja formada ? ;

/*
   doc_char: caractere valido dentro de docstring. Exclui "D#".

   NOTA DE IMPLEMENTACAO - Lookahead (1 char, mesmo padrao):
   Quando o caractere atual e "D", o lexer da peek no proximo:
      - Se "#": "D#" fecha a docstring; "D" NAO e incluido.
      - Senao: "D" e incluido no conteudo.
*/
doc_char             ::= ? qualquer caractere ASCII imprimivel ou
                            espaco em branco, ou code point Unicode,
                            exceto a sequencia "D#" ?
                        | line_break ;

/* ──── printable - usado em string_literal / char_literal ──── */

ascii_printable      ::= ? caractere imprimivel ASCII
                            (codigo 0x20–0x7E: espaco a tilde) ou
                            code point Unicode
                            (U+0080..U+10FFFF, sem surrogates) -
                            strings e chars literais ? ;

ascii_printable_except_single_quote_backslash_line_break
                      ::= ascii_printable
                          - ( "'" | "\\") ;

ascii_printable_except_double_quote_backslash_line_break
                      ::= ascii_printable
                          - ( '"' | "\\") ;


/* ================================================================
   3. COMENTARIOS E DOCUMENTACAO
   ================================================================ */

line_comment         ::= "#L" { any_char_except_line_break } [ line_break ] ;

block_comment        ::= "#B" { any_char_except_block_end } "B#" ;

docstring            ::= "#D" [ line_break ] { doc_char } "D#" ;

/*
   O conteudo de docstring e preservado pelo lexer e anexado a
   declaracao/statement seguinte. O lexer extrai campos com bullet
   ("-", "*", "+") contendo "key: value". Block comments e docstrings
   nao sao aninhados.
*/


/* ================================================================
   4. LEXING ESTRUTURAL
   ================================================================ */

eol                  ::= /* emitido ao final de linha logica */ ;
indent               ::= /* emitido quando a indentacao aumenta em 6 espacos */ ;
dedent               ::= /* emitido quando a indentacao diminui */ ;
eof                  ::= /* fim do arquivo */ ;
indent_open          ::= { eol } indent ;
indent_close         ::= dedent { eol } ;

/*
   Regras de indentacao:
   - Um nivel = exatamente 6 espacos. TABs proibidos (TabulationError).
   - Saltos > 1 nivel sao rejeitados.
   - Linhas vazias ou so de comentario nao alteram indentacao.
   - eol/indent/dedent suprimidos dentro de () e []. Chaves {} nao suprimem eol.
   - Linha terminando em dataflow_operator ou operador infixo e concatenada
      com a proxima - eol suprimido.
   - Whitespace entre tokens e ignorado (apenas espaco 0x20 valido).
*/

/*
   NOTA DE IMPLEMENTACAO - Continuacao de linha:
   O lexer usa lookback de 1 token: ao encontrar eol, verifica
   se o ultimo token significativo e um operador infixo.
   Se for, o eol e SUPRIMIDO (linha fisica seguinte e concatenada).
   eol dentro de () e [] e SEMPRE suprimido, independente.
*/


/* ================================================================
   5. PRIORIDADE DE TOKENS DO LEXER
   ================================================================ */

/*
   O lexer prototipo usa a seguinte prioridade efetiva:

   1. tratamento de indentacao no inicio da linha fora de () e []
   2. comentarios: #L, #B...B#
   3. docstrings: #D [ line_break ] ... D#
   4. strings, chars, datetime literals
   5. numeros e literais imaginarios
   6. operadores/delimitadores por longest match
   7. identificadores:
      - bool literals primeiro
      - nomes de tipo reservados
      - operadores palavra: and/or/not/in/split/join
      - palavras-chave
      - tokens de formato de identificador

   Casos importantes de longest-match:
*/

/*
   NOTA DE IMPLEMENTACAO - Continuacao de linha:
   O lexer usa lookback de 1 token: ao encontrar eol, verifica
   se o ultimo token significativo e um operador infixo.
   Se for, o eol e SUPRIMIDO (linha fisica seguinte e concatenada).
   eol dentro de () e [] e SEMPRE suprimido, independente.
*/


/* ================================================================
   5. PRIORIDADE DE TOKENS DEL LEXER
   ================================================================ */

/*
   O lexer prototipo usa a seguinte prioridade efetiva:

   1. tratamento de indentacao no inicio da linha fora de () e []
   2. comentarios: #L, #B...B#
   3. docstrings: #D [ line_break ] ... D#
   4. strings, chars, datetime literals
   5. numeros e literais imaginarios
   6. operadores/delimitadores por longest match
   7. identificadores:
      - bool literals primeiro
      - nomes de tipo reservados
      - operadores palavra: and/or/not/in/split/join
      - palavras-chave
      - tokens de formato de identificador

   Casos importantes de longest-match:
      - --> antes de -
      - ==> antes de == antes de =
      - =/f, =/i, =/r antes de =
      - =^e, =^r antes de =^
      - =>>> antes de =>> antes de =
      - >>> antes de >>
      - .. antes de .
      - :: antes de :
*/


/* ================================================================
   6. PALAVRAS-CHAVE E OPERADORES
   ================================================================ */

keyword              ::= "_"
                        | "mut" | "imut" | "true" | "false" | "True" | "False"
                        | "struct" | "enum" | "contract" | "impl"
                        | "function" | "and" | "or" | "not"
                        | "in" | "break" | "continue"
                        | "match" | "error" | "catch" | "ensure"
                        | "fallback"
                        | "program" | "emit" | "nice" | "fail"
                        | "route" | "infinite" | "split" | "join"
                        | "agent" | "op" | "use" | "of"
                        | "comptime" | "macro" | "quote" | "unquote"
                        | "spawn" | "async" | "await"
| "keep" | "move" | "borrow" | "borrow_mut" | "unsafe"
                        | "static" | "extern"
                        | "print" | "input" | "spy"
                        | "data" | "map" | "set" | "list"
                        | "as" ;
   - keep/move/borrow/unsafe/borrow_mut: ownership e lifetime
   - static/extern: sublinguagem unsafe exotica (interpreter-only)
    - error/catch/ensure/fallback: erro estruturado
   - split/join: controle de fluxo

   Nao sao keywords em v0.5: module, export, pub, test.
   Estas sao identificadores comuns e nao disparam PAR001.
*/

assignment_operator  ::= "="
                        | "=+" | "=-" | "=*"
                        | "=/f" | "=/i" | "=/r"
                        | "=^e" | "=^r"
                        | "=&" | "=|" | "=^" | "=~"
                        | "=<<" | "=>>" | "=>>>" ;

dataflow_operator    ::= "-->" | "==>" | "split" | "join" ;


/* ================================================================
   7. LITERAIS
   ================================================================ */

unsigned_integer     ::= ( "0" | nonzero_digit { digit } ) [ exponent ] ;
integer_literal      ::= [ "+" | "-" ] unsigned_integer ;

/*
   NOTA DE IMPLEMENTACAO - Literais hexadecimais (0x...), octais (0o...)
   e binarios (0b...) nao sao suportados nativamente.
   Conversao entre bases e fornecida pela stdlib
   (hex(), oct(), bin()) em tempo de execucao.
*/

exponent             ::= ( "e" | "E" ) [ "+" | "-" ] digit { digit } ;

unsigned_float       ::= ( "0" | nonzero_digit { digit } )
                          "." digit { digit } [ exponent ] ;

float_literal        ::= [ "+" | "-" ] unsigned_float ;

imaginary_unit       ::= "i" | "j" ;

unsigned_complex     ::= ( unsigned_integer | unsigned_float ) imaginary_unit ;

complex_literal      ::= unsigned_complex ;

/*
   NOTA SOBRE DATETIME:
   timezone_suffix aceita "Z" (UTC), offsets curtos (+03),
   compactos (+0300) ou completos (+03:00).
   datetime_fraction aceita 1 a 9 digitos (milissegundos a nanossegundos).
   Ambos sao opcionais.
*/

timezone_suffix      ::= "Z"
                        | ( "+" | "-" ) digit digit
                          [ [ ":" ] digit digit ] ;

datetime_fraction    ::= "." digit { digit } ;

datetime_literal     ::= digit digit digit digit "-"
                          digit digit "-"
                          digit digit
                          "T"
                          digit digit ":"
                          digit digit ":"
                          digit digit
                          [ datetime_fraction ]
                          [ timezone_suffix ] ;

escape_sequence      ::= "\\" ( "'" | '"' | "\\" | "n" | "t" | "r" | "0" )
                       | "\\u{" hex_digit { hex_digit } "}" ;

char_literal         ::= "'"
                         ( ascii_printable_except_single_quote_backslash_line_break
                         | escape_sequence )
                         "'" ;

string_literal       ::= '"'
                         { ascii_printable_except_double_quote_backslash_line_break
                         | escape_sequence }
                         '"' ;

interpolated_string_start ::= /* emitido ao abrir uma string interpolada */ ;
interpolation_open       ::= /* emitido ao iniciar a expressao de interpolacao */ ;
interpolation_close      ::= /* emitido ao fechar a expressao de interpolacao */ ;
interpolated_string_end  ::= /* emitido ao fechar a string interpolada */ ;
interpolated_text        ::= /* texto puro sem interpolacao entre blocos de expressao */ ;

interpolation_block      ::= interpolation_open
                              expression
                              interpolation_close ;

interpolated_string      ::= interpolated_string_start
                              { interpolated_text | interpolation_block }
                              interpolated_string_end ;

boolean_literal      ::= "True" | "False" | "true" | "false" ;

literal              ::= integer_literal
                        | float_literal
                        | complex_literal
                        | datetime_literal
                        | string_literal
                        | interpolated_string
                        | char_literal
                        | boolean_literal
                        | list_literal
                        | set_literal
                        | map_literal
                        | tensor_literal ;


/* ================================================================
   8. TIPOS
   ================================================================ */

primitive_int_type   ::= "int8" | "int16" | "int32" | "int64" ;

primitive_uint_type  ::= "uint8" | "uint16" | "uint32" | "uint64" ;

integer_type         ::= primitive_int_type | primitive_uint_type ;

float_type           ::= "float16" | "float32" | "float64"
                        | "fp8_e4m3" | "fp8_e5m2"
                        | "bf16_e8m7" | "tf32_e8m10" ;

complex_type         ::= "complex32" | "complex64"
                        | "complex128" ;

numeric_type         ::= integer_type | float_type | complex_type ;

datetime_type        ::= "datetime" ;

numeric_or_time_type ::= numeric_type | datetime_type ;

char_type            ::= "char" ;

string_type          ::= "string" ;

bool_type            ::= "bool" ;

data_type            ::= "data" ;

base_type            ::= numeric_or_time_type
                        | char_type
                        | string_type
                        | bool_type
                        | data_type ;

tensor_dimensions    ::= "["
                          unsigned_integer
                          { "," unsigned_integer }
                          "]" ;

/*
   Forma canonica: "tensor" shape "of" element_type.
   shape e SEMPRE obrigatorio - nao existe "tensor" sem colchetes.
   Apenas shapes estaticos (dimensoes fixas em tempo de compilacao).
   Shapes dinamicos ou mistos sao rejeitados.
*/

tensor_type          ::= "tensor" tensor_dimensions "of" primitive_type ;

list_type            ::= "list" "of" primitive_type ;

set_type             ::= "set" "of" primitive_type ;

map_type             ::= "map" "of" primitive_type ;

collection_type      ::= list_type | set_type | map_type | tensor_type ;

primitive_type       ::= base_type | collection_type ;

type_reference       ::= primitive_type | generic_upper_identifier ;

/* Aliases de compatibilidade (substituidos nas fases 5-6) */



/* ================================================================
    9. EXPRESSOES POR PRECEDENCIA
    ================================================================ */

/*
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
*/

expression           ::= assignment_expr ;

assignment_expr      ::= recovery_expr
                         [ assignment_operator assignment_expr ] ;

/*
   Atribuicao composta (=+, =-, =*) suporta apenas identificadores
   como alvo. "=" suporta identificador, campo, indice e multi-indice.
*/

recovery_expr        ::= dataflow_expr
                         { ( "catch" | "fallback" ) dataflow_expr } ;

/*
   error/catch/fallback/ensure:
   - error() cria valor de erro recuperavel
   - target catch recovery e target fallback recovery recuperam
   - ensure { block } e sufixo pos-fixo (sempre executa), preserva
     o valor e o tipo do alvo; falha do alvo ou do bloco propaga apos
     o bloco
*/

dataflow_expr        ::= or_expr
                          { dataflow_operator or_expr } ;

/*
   --> despacha value para funcao/op. ==> avalia expression em
   escopo filho com it vinculado a value. split/join sao operadores
   de topologia de branch.

   it nao e palavra reservada - e identificador snake_case comum,
   vinculado implicitamente por ==>. Shadowing lexical padrao:
   escopo filho sombreia o it do escopo pai.
*/

or_expr              ::= and_expr { "or" and_expr } ;

and_expr             ::= bit_or_expr { "and" bit_or_expr } ;

bit_or_expr          ::= bit_xor_expr { "|" bit_xor_expr } ;

bit_xor_expr         ::= bit_and_expr { "^" bit_and_expr } ;

bit_and_expr         ::= equality_expr { "&" equality_expr } ;

equality_expr        ::= membership_expr
                          { ( "==" | "!=" | "<" | ">" | "<=" | ">=" ) membership_expr } ;

membership_expr      ::= range_expr { "in" range_expr } ;

range_expr           ::= shift_expr [ ".." shift_expr ] ;

shift_expr           ::= additive_expr
                         { ( "<<" | ">>" | ">>>" ) additive_expr } ;

additive_expr        ::= multiplicative_expr
                         { ( "+" | "-" ) multiplicative_expr } ;

multiplicative_expr  ::= power_expr
                         { ( "*" | "/f" | "/i" | "/r" ) power_expr } ;

power_expr           ::= prefix_expr
                         [ ( "^e" | "^r" ) power_expr ] ;

prefix_expr          ::= primary_postfix_expr
                         | ( "+" | "-" | "not" | "!" | "~" | "unquote" )
                           prefix_expr
                         | spawn_expr
                         | await_expr
                         | ownership_expr ;

/*
   ? e o operador pos-fixo de propagacao de erro (short-circuit): consome o
   struct transparente da expressao a esquerda (emit) ou um valor booleano
   sem reavaliar a expressao.

   ! e not sao operadores unarios de negacao logica.
   Ambos equivalentes - ! e o atalho simbolico, not e a
   forma verbosa.

   unquote e operador prefixo de metaprogramacao: escapa da
   quoted AST para insercao de expressao em tempo de compilacao.

   async e modificador de declaracao de funcao (em vez de prefixo de
   expressao): marca a funcao como operacao nao-bloqueante que retorna
   um Future. spawn/await sao prefixos de expressao: spawn despacha um
   no/caminho do dataflow para o runtime como green thread, e await
   suspende a pipeline sincrona ate a resolucao de um Future.
   Ownership (move/borrow/keep) reduz a expressoes
   de identidade runtime apos validacao estatica.
*/

async_modifier       ::= "async" ;   (* aplicado a function_declaration *)
spawn_expr           ::= "spawn" prefix_expr ;
await_expr           ::= "await" prefix_expr ;

ownership_expr       ::= move_expr | borrow_expr | borrow_mut_expr | keep_expr ;
move_expr            ::= "move" "(" identifier ")" ;
borrow_expr          ::= "borrow" "(" identifier ")" ;
borrow_mut_expr      ::= "borrow_mut" "(" identifier ")" ;
keep_expr            ::= "keep" "(" identifier ")" ;

raw_ptr_prefix_expr  ::= "&" "(" prefix_expr ")"          /* so em unsafe */
                       | "*" "(" prefix_expr ")"          /* so em unsafe */
                       | "*" "(" prefix_expr ")" assign_operator prefix_expr ;

primary_postfix_expr ::= primary_expr { postfix_op } ;

postfix_op           ::= call_suffix
                        | index_or_slice_suffix
                        | field_suffix
                        | namespace_suffix
                        | ensure_suffix
                        | cast_suffix
                        | short_circuit_suffix ;

primary_expr         ::= literal
                        | comptime_expr
                        | quote_expr
                        | unquote_expr
                        | match_expr
                         | error_expr
                         | input_expr
                        | spy_expr
                        | spy_sink
                        | print_sink
                        | keep_sink
                        | struct_init_expr
                        | enum_variant_expr
                        | identifier
                        | "(" expression ")"
                        | dataflow_cast_sink ;

/*
   NOTA DE IMPLEMENTACAO - comptime_expr:
   Apos "comptime", se o proximo token for "{" → bloco;
   caso contrario → expression inline. 1 token de lookahead.
*/
comptime_expr        ::= "comptime"
                         (
                             "{"
                             block_body
                             "}"
                           | expression
                         ) ;

quote_expr           ::= "quote" "{" block_body "}" ;
unquote_expr         ::= "unquote" "(" expression ")" ;

error_expr           ::= "error"
                          "("
                          expression
                          [ "," expression [ "," expression ] ]
                          ")" ;

/*
   Short-circuit pos-fixo: braco fail primeiro, braco nice segundo
   (ambos obrigatorios). Cada braco e "==>" seguido de emit anonimo
   (emit_stmt) com o status correspondente.
*/
short_circuit_suffix ::= "?"
                          eol
                          "{"
                          short_circuit_arm
                          short_circuit_arm
                          "}" ;

short_circuit_arm    ::= "==>" emit_stmt eol ;

match_expr           ::= "match"
                         expression
                         "{"
                         match_arm
                         { statement_end match_arm }
                         [ statement_end ]
                         "}" ;

match_arm            ::= pattern "==>" expression ;

pattern              ::= "_"
                        | literal
                        | generic_lower_identifier
                        | list_pattern
                        | record_pattern
                        | struct_pattern
                        | data_pattern
                        | enum_variant_pattern ;

list_pattern         ::= "["
                        [ list_pattern_items ]
                        "]" ;
list_pattern_items   ::= rest_pattern
                        | pattern_sequence [ "," ] [ rest_pattern ] ;
pattern_sequence     ::= pattern { "," pattern } ;
rest_pattern         ::= ".." [ generic_lower_identifier ] ;

/*
   NOTA (divergencia intencional): list_pattern esta na gramatica, mas o
   parser rejeita no runtime atual com PAR001 ("list pattern requires list
   runtime (not implemented yet)"). A producao fica reservada para quando
   houver runtime de listas.
*/

record_pattern       ::= "{"
                         "}" ;

struct_pattern       ::= generic_lower_identifier
                          "("
                          ")" ;

enum_variant_pattern ::= generic_lower_identifier
                          "::"
                          generic_lower_identifier
                          [ "(" ")" ] ;

data_pattern         ::= "data" "{"
                         "}" ;


/*
   Match arms reduzem para JUMP_IF_NOT_MATCH, MATCH_BIND, DROP
   e MATCH_FAIL. Padroes Struct/Enum usam STRUCT_ACCESS com
   ownership emprestada e liveness parent-retention no DDG.
*/

call_suffix          ::= "(" [ call_args ] ")" ;
call_args            ::= positional_args
                       | named_args ;

positional_args      ::= expression { "," expression }
                         [ "," named_args ] ;
named_args           ::= named_arg { "," named_arg } [ "," ] ;
named_arg            ::= "." identifier ":" expression ;

field_suffix         ::= "." identifier ;
namespace_suffix     ::= "::" identifier ;
ensure_suffix        ::= "ensure" "{" block_body "}" ;

/*
   ensure_suffix — semantica:
   - Expressao alvo avaliada UMA unica vez, no contexto atual.
   - Bloco cleanup executa SEMPRE, apos a avaliacao do alvo
     (sucesso ou falha).
   - Resultado da expressao = valor do alvo, mesmo tipo estatico.
   - Bloco nao contribui com tipo; apenas efeito colateral.
   - Falha (sta == "fail") do alvo propaga apos o bloco;
     falha nao tratada dentro do bloco propaga.
*/
cast_suffix          ::= "as" type_reference ;

/*
   Struct init: chamada especial quando callee e camelCase e
   primeiro token apos "(" e ".":

     ponto(.x: 1, .y: 2)

   Cada campo possui seu proprio inicializador ".campo: expression".
   Nao ha valor padrao para campos omitidos - todos devem ser
   explicitamente inicializados. Ordem livre, cada campo uma vez.

   NOTA DE IMPLEMENTACAO - Lookahead:
   Requer 2 tokens apos "(" para distinguir struct_init_expr
   (".campo") de call_suffix (expression ou named_args).
   Ambos struct_init_expr e call_suffix com named_args usam
   ".campo:" - a desambiguacao e semantica: se o callee
   for um struct, e struct_init_expr; caso contrario,
   e call_suffix com argumento nomeado. Mesmo padrao para
   enum_variant_expr.
*/
struct_init_expr     ::= generic_lower_identifier
                          "("
                          struct_init_field
                          { "," struct_init_field }
                          [ "," ]
                          ")" ;

struct_init_field    ::= "."
                         identifier
                         ":"
                         expression ;

enum_variant_expr    ::= generic_lower_identifier
                          "::"
                          generic_lower_identifier
                          [ "(" enum_variant_init_field { "," enum_variant_init_field } [ "," ] ")" ] ;

enum_variant_init_field ::= "."
                            identifier
                            ":"
                            expression ;

input_expr           ::= "input" "(" [ expression ] ")" ;
spy_expr             ::= "spy" "(" expression ")" ;

/*
   print/spy/keep: o parser tenta a forma com "()" primeiro.
   Se nao houver "(", recua para sink bare (alvo de dataflow).
*/
spy_sink             ::= "spy" ;
print_sink           ::= "print" ;
keep_sink            ::= "keep" ;

/*
   dataflow_cast_sink: alvo de dataflow para conversao de tipo.
   Usado como sink de --> para converter o valor pipegado
   para o tipo especificado:

     valor --> (as int64)
     valor --> (as float32)

    O tipo deve ser um type_reference valido. Equivalente a
   "valor as Tipo", mas adequado para cadeias de dataflow.
   O sink e valido apenas como alvo de -->; usado fora
   de contexto de dataflow produz erro semantico.
*/
dataflow_cast_sink   ::= "(" "as" type_reference ")" ;

collection_element_list  ::= expression { "," expression } ;

list_literal             ::= "("
                              [ collection_element_list [ "," ] ]
                              ")" ;

set_literal              ::= "{"
                              [ collection_element_list [ "," ] ]
                              "}" ;

/*
   map_literal: sintaxe de dicionario com colchetes.
   Chave em PascalCase, valor apos ":". Exemplo: [Nome: "Alice"].
*/
map_pair                 ::= generic_upper_identifier
                              ":"
                              expression ;

map_pair_list            ::= map_pair { "," map_pair } ;

map_literal              ::= "["
                              [ map_pair_list [ "," ] ]
                              "]" ;

tensor_literal           ::= "("
                              additive_expr { " " additive_expr }
                              ")" ;

/*
   index_or_slice_suffix: apos "[", desambigua entre:
     - ".." → slice_spec (range)
     - expression → indice unico ou multi-indice
   Se apos expression vier ".." → slice com inicio.
   2 tokens de lookahead.

   Indices sao 1-based (human-like). O runtime converte
   transparentemente: machine_index = human_index - 1.
   list[length+1] = value faz append automatico.
   slices sao fechados/inclusivos: [x..y], [..y], [x..], [..].

   None e valor interno de runtime (nao ha literal sintatico):
   indices inexistentes, chaves ausentes, slices vazios.

   map.data e rejeitado semanticamente - use map["data"].
   slice set/map rejeitado. slice list/string/tensor/data valido.
*/
index_or_slice_suffix
                     ::= "["
                         (
                             slice_spec
                           | expression { "," expression }
                         )
                         "]" ;

slice_spec           ::= ".." [ expression ]
                        | expression ".." [ expression ] ;

/* ================================================================
   10. BLOCOS E COMANDOS
   ================================================================ */

block_body           ::= indented_block_body ;

indented_block_body  ::= indent_open
                         { eol | block_statement statement_end }
                         indent_close ;

top_statement        ::= { docstring statement_end }
                          (
                              use_declaration
                            | struct_declaration
                            | enum_declaration
                            | contract_declaration
                            | program_declaration
                            | agent_declaration
                            | function_declaration
                            | macro_declaration
                            | impl_declaration
                            | storage_declaration
                          ) ;

block_statement      ::= { docstring statement_end }
                           (
                               print_stmt
                             | infinite_stmt
                             | route_stmt
                             | break_stmt
                             | continue_stmt
                              | emit_stmt
                              | unsafe_stmt
                             | storage_declaration
                             | variable_reassignment
                             | expression_stmt
                           ) ;

statement_end        ::= eol | eof ;

/*
   Token: Fim de Declaracao Pending (sem quebra de linha).
   Declaracao terminada sem eol, seguida por outra na mesma linha.
*/
pending_line         ::= ? fim de declaracao sem quebra de linha ? ;

/*
   NOTA DE IMPLEMENTACAO - Terminadores implicitos:
   } e dedent tambem sao aceitos como terminadores de statement
   (regras do parser, nao da EBNF). Quando encontrados onde um
   statement_end e esperado, o statement e consumido como completo
   e o bloco e encerrado.
*/

print_stmt           ::= "print"
                          "("
                          expression
                          { "," expression }
                          ")" ;

route_stmt           ::= "route"
                         [ "(" route_subjects ")" ]
                         "{"
                         route_body
                         "}" ;

route_subjects       ::= expression { "," expression } [ "," ] ;
route_body           ::= indented_route_body | inline_route_body ;

indented_route_body  ::= indent_open
                         { eol | route_arm statement_end }
                         indent_close ;

inline_route_body    ::= { eol | route_arm } ;

route_arm            ::= ( "_" | route_condition ) "==>" "{" block_body "}" ;

route_condition      ::= expression
                       | route_positional_condition
                         { ( "and" | "or" ) route_positional_condition } ;
/* route_positional_condition valida apenas com subjects */

route_positional_condition
                       ::= ".."
                        | literal
                        | ( "==" | "!=" | "<" | ">" | "<=" | ">=" ) expression ;

/*
   Route: despacho condicional multi-arm (if/elsif/else).
   - "_" e braco coringa (else), deve ser o ultimo se presente.
   - "route (subj1, subj2, ...)" reduz verbosidade: cada condicao
     posicional mapeia para o sujeito correspondente:
     ".." -> true, literal -> "subject == literal",
      operador relacional + expr -> "subject op expr".
   - Condicoes posicionais conectadas por "and"/"or".
*/

infinite_stmt        ::= "infinite"
                         [ "(" infinite_arg ")" ]
                         "{"
                         block_body
                         "}" ;

/*
   infinite_arg: desambigua entre expression (condicional) e
   generic_lower_identifier "in" expression (iteracao).
    Se o primeiro token for generic_lower_identifier E o proximo
   for "in": iteracao. Senao: condicional. 2 tokens lookahead.

   Tres formas:
   1. infinite { ... } - loop infinito (break explicito)
   2. infinite (expr) { ... } - loop condicional (while)
   3. infinite (item in colecao) { ... } - iteracao sobre
      range, list, set, string, map (chaves), data (chaves), tensor
   break interrompe, continue pula iteracao.
   Validos apenas dentro de infinite_stmt.
*/
infinite_arg         ::= expression
                        | generic_lower_identifier "in" expression ;

break_stmt           ::= "break" ;
continue_stmt        ::= "continue" ;

emit_stmt           ::= "emit"
                          "("
                          emit_status
                          ","
                          identifier
                          ","
                          ( string_literal | interpolated_string )
                          ")" ;

emit_status         ::= "nice" | "fail" ;

unsafe_stmt         ::= "unsafe" "{" block_body "}" ;

extern_decl         ::= "extern" string_literal "{" { "fn" identifier "(" extern_params ")" ( "as" type_expr )? } "}" ;
extern_params       ::= [ extern_param { "," extern_param } ] ;
extern_param        ::= "as" pointer_type ":" identifier ;
pointer_type        ::= "*" ( "const" | "mut" )? type_expr ;
static_decl         ::= "static" ( "mut" | "imut" ) "as" type_expr ":" identifier ( "=" prefix_expr )? ;
bounds_call         ::= "bounds" "(" identifier "," prefix_expr ")" ;

/*
   Exotico unsafe (interpreter-only, v0.6): verificacoes:
   - extern_decl, static_decl, raw_ptr_prefix_expr e bounds_call so existem
     DENTRO de "unsafe". Colocados fora -> SEM002.
   - Backends VM/LLVM/WAT/WASM reportam "simulacao interpreter-only" com
     erro claro de compilacao (nao geram artefato).
   - pointer de valores inteiros escalares: arena virtual 64-bit only.
   - bounds(): indices sao 1-based, como list/tensor.
*/

/*
   emit(nice/fail, identifier, message) termina a funcao e devolve um struct
   implicito de resultado de tres campos (.sta, .val, .msg). O objeto inteiro
   fica disponivel via variavel (r = calc(5)) e os campos sao lidos via acesso
   nomeado: print(r.sta); print(r.val); print(r.msg).
   O slot `value` e um unico identificador (sem lista, sem expressao).
   Funcoes com tipo de retorno devem ter emit terminal em
   todo caminho (loops nao contam).
   O bloco '?' propaga fail como TRY_FAIL/END_TRY_FAIL/PROPAGATE_FAIL em bytecode.
*/

expression_stmt      ::= expression ;

/*
   Restricoes semanticas:
   - route conditions devem ser bool
   - break/continue validos apenas dentro de infinite
   - emit valido apenas dentro de funcao
   - unsafe silencia verificacoes de ownership/lifetime/mutabilidade
   - op valido apenas dentro de agent_body (.fdsl), nao aninhado
   - top_statement define decls exclusivas do nivel superior do modulo
     (rejeitadas dentro de block_body sintaticamente)
*/

/* ================================================================
   11. DECLARACOES
   ================================================================ */

use_declaration      ::= "use"
                          ( use_agent_clause | use_op_clause | use_group_clause )
                          ( eol | pending_line ) ;

use_agent_clause     ::= generic_upper_identifier
                          [ "as" generic_upper_identifier ] ;

use_op_clause        ::= generic_upper_identifier
                          "::"
                          generic_lower_identifier
                          "as"
                          generic_lower_identifier ;

use_group_clause     ::= generic_upper_identifier
                          "::"
                          "{"
                          use_group_item
                          { "," use_group_item }
                          [ "," ]
                          "}" ;

use_group_item       ::= generic_lower_identifier
                          [ "as" generic_lower_identifier ] ;

struct_declaration   ::= "struct"
                           "("
                           generic_lower_identifier
                           ")"
                           "{"
                           eol
                           { struct_field eol }
                           "}" ;

/*
   struct: dados puros, sem metodos. Comportamento e expresso
   via funcoes avulsas (camelCase) ou agents com contracts.
   Nao ha "impl Struct { op ... }" - structs sao tipos de
   dados, nao objetos.
*/

struct_field         ::= mutable_struct_field
                        | immutable_struct_field ;

mutable_struct_field ::= "mut"
                          ":"
                          "."
                          generic_lower_identifier
                          ":"
                          type_reference ;

immutable_struct_field ::= "imut"
                            ":"
                            "."
                            generic_upper_identifier
                            ":"
                            type_reference ;

enum_declaration     ::= "enum"
                          "("
                          generic_upper_identifier
                          ")"
                          [ "as" primitive_type ]
                          "{"
                          eol
                          enum_member
                          { enum_member }
                          "}" ;

enum_member          ::= generic_upper_identifier
                          [ "=" literal ]
                          eol ;

/*
   Enum: uniao discriminada estilo Rust.
   Variantes unitarias (Estado::Aberto). Discriminante ordinal
   interno estavel por ordem de declaracao.
*/

macro_declaration    ::= "macro"
                          "("
                          generic_lower_identifier
                          ")"
                          "("
                          [ parameter_list ]
                          ")"
                          block_body
                          eol ;

variable_item        ::= generic_lower_identifier
                          [ "=" expression ] ;

variable_list        ::= variable_item
                          { "," variable_item } ;


break_stmt           ::= "break" ;
continue_stmt        ::= "continue" ;

emit_stmt           ::= "emit"
                          "("
                          emit_status
                          ","
                          identifier
                          ","
                          ( string_literal | interpolated_string )
                          ")" ;

emit_status         ::= "nice" | "fail" ;

unsafe_stmt         ::= "unsafe" "{" block_body "}" ;

/*
   emit(nice/fail, identifier, message) termina a funcao e devolve um struct
   implicito de resultado de tres campos (.sta, .val, .msg). O objeto inteiro
   fica disponivel via variavel (r = calc(5)) e os campos sao lidos via acesso
   nomeado: print(r.sta); print(r.val); print(r.msg).
   O slot `value` e um unico identificador (sem lista, sem expressao).
   Funcoes com tipo de retorno devem ter emit terminal em
   todo caminho (loops nao contam).
   O bloco '?' propaga fail como TRY_FAIL/END_TRY_FAIL/PROPAGATE_FAIL em bytecode.
*/

expression_stmt      ::= expression ;

/*
   Restricoes semanticas:
   - route conditions devem ser bool
   - break/continue validos apenas dentro de infinite
   - emit valido apenas dentro de funcao
   - unsafe silencia verificacoes de ownership/lifetime/mutabilidade
   - op valido apenas dentro de agent_body (.fdsl), nao aninhado
   - top_statement define decls exclusivas do nivel superior do modulo
     (rejeitadas dentro de block_body sintaticamente)
*/

/* ================================================================
   11. DECLARACOES
   ================================================================ */

use_declaration      ::= "use"
                          ( use_agent_clause | use_op_clause | use_group_clause )
                          ( eol | pending_line ) ;

use_agent_clause     ::= generic_upper_identifier
                          [ "as" generic_upper_identifier ] ;

use_op_clause        ::= generic_upper_identifier
                          "::"
                          generic_lower_identifier
                          "as"
                          generic_lower_identifier ;

use_group_clause     ::= generic_upper_identifier
                          "::"
                          "{"
                          use_group_item
                          { "," use_group_item }
                          [ "," ]
                          "}" ;

use_group_item       ::= generic_lower_identifier
                          [ "as" generic_lower_identifier ] ;

struct_declaration   ::= "struct"
                           "("
                           generic_lower_identifier
                           ")"
                           "{"
                           eol
                           { struct_field eol }
                           "}" ;

/*
   struct: dados puros, sem metodos. Comportamento e expresso
   via funcoes avulsas (camelCase) ou agents com contracts.
   Nao ha "impl Struct { op ... }" - structs sao tipos de
   dados, nao objetos.
*/

struct_field         ::= mutable_struct_field
                        | immutable_struct_field ;

mutable_struct_field ::= "mut"
                          ":"
                          "."
                          generic_lower_identifier
                          ":"
                          type_reference ;

immutable_struct_field ::= "imut"
                            ":"
                            "."
                            generic_upper_identifier
                            ":"
                            type_reference ;

enum_declaration     ::= "enum"
                          "("
                          generic_upper_identifier
                          ")"
                          [ "as" primitive_type ]
                          "{"
                          eol
                          enum_member
                          { enum_member }
                          "}" ;

enum_member          ::= generic_upper_identifier
                          [ "=" literal ]
                          eol ;

/*
   Enum: uniao discriminada estilo Rust.
   Variantes unitarias (Estado::Aberto). Discriminante ordinal
   interno estavel por ordem de declaracao.
*/

macro_declaration    ::= "macro"
                          "("
                          generic_lower_identifier
                          ")"
                          "("
                          [ parameter_list ]
                          ")"
                          block_body
                          eol ;

variable_item        ::= generic_lower_identifier
                          [ "=" expression ] ;

variable_list        ::= variable_item
                          { "," variable_item } ;

constant_item        ::= constant_identifier
                          "="
                          expression ;

constant_list        ::= constant_item
                          { "," constant_item } ;

mutable_declaration  ::= "mut"
                           "as"
                           type_reference
                           ":"
                           variable_list
                           eol ;

immutable_declaration ::= "imut"
                           "as"
                           type_reference
                           ":"
                           constant_list
                           eol ;

storage_declaration  ::= mutable_declaration
                         | immutable_declaration ;

variable_reassignment ::= generic_lower_identifier
                           assignment_operator
                           expression ;

parameter_definition ::= [ "mut" "as" | "imut" "as" | "as" ]
                          type_reference
                          ":"
                          generic_lower_identifier
                        | generic_lower_identifier
                          ":"
                          type_reference ;

parameter_list       ::= parameter_definition
                          { "," parameter_definition } ;

function_declaration ::= [ "async" ]
                         "function"
                         "("
                         generic_lower_identifier
                         ")"
                           "("
                           [ parameter_list ]
                           ")"
                           [ "as" type_reference ]
                           block_body
                           eol ;

program_declaration  ::= "program"
                           "("
                           generic_upper_identifier
                           ")"
                           block_body
                           eol ;

op_declaration       ::= "op"
                           generic_lower_identifier
                           [ "(" [ parameter_list ] ")" ]
                           [ "as" type_reference ]
                           [ "==>" ]
                           block_body
                           eol ;

contract_declaration ::= "contract"
                           "("
                           generic_upper_identifier
                           ")"
                           contract_body
                           eol ;

contract_body        ::= "{"
                          eol
                          { contract_op_signature }
                          "}" ;

contract_op_signature ::= "op"
                            generic_lower_identifier
                            [ "(" [ parameter_list ] ")" ]
                            [ "as" type_reference | ":" type_reference ]
                            eol ;

impl_body            ::= "{"
                          eol
                          { op_declaration | function_declaration }
                          "}" ;

impl_declaration     ::= "impl"
                           "("
                           generic_upper_identifier
                           ")"
                           [ "for" "(" generic_upper_identifier ")" ]
                           impl_body
                           eol ;

agent_declaration    ::= "agent"
                           "("
                           generic_upper_identifier
                           ")"
                           [ "impl" generic_upper_identifier ]
                           agent_body
                           eol ;

agent_body           ::= "{"
                          eol
                          { storage_declaration
                          | function_declaration
                          | op_declaration }
                          "}" ;

/*
   op_declaration valida apenas dentro de agent_body (.fdsl):
   Nao aninhada em outro op.

   Contract ↔ Agent (validacao semantica):
   contract_op_signature = assinatura (sem corpo), op_declaration = implementacao
   (com corpo). Ligacao semantica, nao sintatica.

   impl_declaration exige que todos os contract_op_signature sejam
   implementados como op_declaration (mesmo id, params, retorno).
   Sem impl: agente avulso. Agente pode ter ops extras.
   Erro se contract_op_signature faltar.

   "impl" e reservado exclusivamente para agent implementar
   contract. Nao ha "impl Struct { }" - structs sao dados
   puros (Secao 11). A separacao entre dados (struct) e
   comportamento (agent/contract/funcao) e intencional no
   ================================================================ */

flux_file            ::= { eol }
                          { documented_use_declaration statement_end }
                          { documented_type_macro_declaration statement_end }
                          { documented_contract_declaration statement_end }
                          { documented_storage_declaration statement_end }
                          { documented_function_declaration statement_end }
                          documented_program_declaration
                          statement_end
                          { eol }
                          eof ;

fdsl_file            ::= { eol }
                          { documented_use_declaration statement_end }
                          { documented_type_macro_declaration statement_end }
                          { documented_contract_declaration statement_end }
                          { documented_storage_declaration statement_end }
                          { documented_function_declaration statement_end }
                          documented_agent_declaration
                          { statement_end documented_agent_declaration }
                          { eol }
                          eof ;

/*
   documented_*_declaration: cada declaracao pode ser precedida por
   docstring statement_end. Padrao unico:
   Aplica-se a: use, struct, enum, contract, macro, storage,
   function, program, agent, impl.
*/
documented_use_declaration      ::= { docstring statement_end } use_declaration ;
documented_struct_declaration   ::= { docstring statement_end } struct_declaration ;
documented_enum_declaration     ::= { docstring statement_end } enum_declaration ;
documented_contract_declaration ::= { docstring statement_end } contract_declaration ;
documented_macro_declaration    ::= { docstring statement_end } macro_declaration ;
documented_type_macro_declaration ::= documented_struct_declaration
                                     | documented_enum_declaration
                                     | documented_macro_declaration ;
documented_storage_declaration  ::= { docstring statement_end } storage_declaration ;
documented_function_declaration ::= { docstring statement_end } function_declaration ;
documented_program_declaration  ::= { docstring statement_end } program_declaration ;
documented_agent_declaration    ::= { docstring statement_end } agent_declaration ;

/*
   .flux: program obrigatorio, ultimo, exatamente 1.
   .fdsl: 1+ agent obrigatorio, program rejeitado.
   Ordem de declaracoes fixa conforme definido acima.
*/


/* ================================================================
   13. FLUXO DE COMPILACAO
   ================================================================ */

/*
    Pipeline de fases sequenciais do compilador TheFlux:

    Fase   | De                | Para             | Diagnosticos
    -------|-------------------|------------------|---------------------
    0. CLI | args CLI          | config compilação| CLI001
    1. Pre | stream bytes      | chars ASCII      | LEX001, TabulationError
    2. Lex | chars             | tokens           | LEX001, TabulationError
    3. Par | tokens            | AST              | PAR001
    4. Mac | AST c/ MacroDecl  | AST expandido    | CMP001
    5. Sem | AST expandido     | AST decorado     | SEM001, SEM002
    6. DDG | AST decorado      | DDG              | -
    7. BC  | AST + DDG         | bytecode FVMBC   | BC001
    8. LLVM| AST (subconj.)    | .exe             | LLVM001
    9. WAT | AST (subconj.)    | .wat             | WATM001
   10. WASM| AST (subconj.)    | .wasm            | WASM001
   11. Run | bytecode / .wasm  | stdout           | RUN001, VM001
   12. Diag| -                 | diagnosticos     | -


    ──── FASE 0: CLI ────

    Parsing de argumentos da linha de comando (flux check, flux run,
    flux build, flags --emit-llvm, --emit-wasm, --vm, --dbg, etc.).
    CLI001 se argumento invalido ou contradictorio.


    ──── FASE 1: PRE-PROCESSAMENTO ────

    Leitura de .flux / .fdsl. Bytes > 0x7F → LEX001. TAB → TabulationError.
    Normalizacao \r\n, \r → \n.


    ──── FASE 2: LEXING ────

   Tokens conforme lexing estrutural e prioridade de tokens do lexer.
   Emite eol, indent, dedent, eof, docstring.
   Indentacao: 6 espacos/nivel; saltos >1 rejeitados.
   eol/indent/dedent suprimidos dentro de () e [].
   docstring (#D ... D#) anexado a declaracao seguinte.
   Strings interpoladas #{...} com contagem balanceada de {}.


    ──── FASE 3: PARSING ────

   Parser recursivo descendente implementando as EBNF (secoes 1–12).
   Nos AST: FluxProgram, FunctionDef, OpDecl, StructDef, EnumDef,
   ContractDef, AgentDef, UseDecl, BlockStmt, etc.
   Comandos: PrintStmt, InfiniteStmt, RouteStmt, BreakStmt,
   ContinueStmt, EmitStmt, UnsafeStmt, VariableDecl, ExpressionStmt.
   Expressoes: BinaryOp, UnaryOp, Literal, Identifier, CallExpr,
   FieldAccess, IndexAccess, StructInit, EnumVariant, MatchExpr,
   LambdaExpr, DataflowExpr, CastExpr, ErrorExpr, PanicExpr,
   InputExpr, SpyExpr, ListLiteral, RecordLiteral, MapLiteral,
   DataLiteral, OwnershipExpr, CompTimeExpr, QuoteExpr, UnquoteExpr,
   AsyncExpr, SpawnExpr, AwaitExpr.
   Padroes: MatchArm, Pattern (Wildcard, Literal, List, Record,
   Struct, EnumVariant, Data).
   Separacao sintatica top_statement vs block_statement.
   Balanceamento de () [] {}.


    ──── FASE 4: EXPANSAO DE MACROS ────

    Expansao de macro_declaration no nivel superior. Substituicao de
   unquote(...) por AST dos parametros. Injecao de quote { ... }
   no local da chamada. Max 64 niveis.
   CMP001 se excedido.


    ──── FASE 5: ANALISE SEMANTICA ────

     5a. Escopo: tabela de simbolos, resolucao de use_declaration, duplicidades.
    5b. Capitalizacao: mut→snake_case; imut→SCREAMING_SNAKE;
        funcao/op/alias→camelCase; agent/program→PascalCase.
        Violacoes → SUGGESTION.
    5c. Mutabilidade: imut requer =expr; list/set nao aceitam imut;
        borrow mutavel com exclusividade.
    5d. Tipos: inferencia, compatibilidade em atribuicoes/params/ops,
        match/route, indices tensor, struct/enum init, casts.
    5e. Ownership/lifetime: use-after-move, exclusividade borrow,
        unsafe silencia.
     5f. Contract↔Agent: verificacao de implementacao (op_declaration vs
         contract_op_signature).
    5g. Emit terminal: funcoes com retorno devem ter caminho com emit.


    ──── FASE 6: DDG (DATA DEPENDENCY GRAPH) ────

   Arestas de fluxo de dados e controle entre nos da AST.
   Metadados: route, catch-all, loop_body, iterator.
   Usado pelo bytecode para alocacao de slots, lifetime e DROP.


    ──── FASE 7: BYTECODE (FVMBC) ────

   Reducao de cada no AST para opcodes: PUSH, LOAD, STORE, CALL,
   I64.ADD, F64.MUL, ITER_INIT/NEXT/END, JUMP_IF_FALSE, JUMP,
   PIPE_DISPATCH, TRY_FAIL, RET, STRUCT_ALLOC, VARIANT_ALLOC,
   TASK_INIT/SPAWN/JOIN, etc.
   Verifier checa jump targets, stack linear, tipos vs opcode.
   Serializado como JSON (.fvmbc).
   BC001 em erro.


    ──── FASE 8: LLVM (--emit-llvm) ────

   Reducao direta de subconjunto AST para LLVM IR, sem passar pelo
   bytecode FVMBC. Gera .ll (IR textual) e opcionalmente .bc (bitcode).
   Cobertura v0.5: escalares int64/float64, atribuicoes, print,
   infinite/route sobre inteiros, aritmetica basica, chamadas.
   LLVM001 se fora do subconjunto.


    ──── FASE 9: WAT NATIVO (--emit-wat) ────

   Reducao direta de subconjunto AST para WebAssembly representado na forma textual (sem FVMBC).
   Cobertura v0.5: escalares int64/float64, atribuicoes, print,
   infinite/route sobre inteiros, aritmetica basica.
   Exporta flux_main e memory. Importa flux.host_print.
   WATM001 se fora do subconjunto.


    ──── FASE 10: WASM NATIVO (--emit-wasm) ────

   Reducao direta de subconjunto AST para WebAssembly binário (sem FVMBC).
   Cobertura v0.5: escalares int64/float64, atribuicoes, print,
   infinite/route sobre inteiros, aritmetica basica.
   Exporta flux_main e memory. Importa flux.host_print.
   WASM001 se fora do subconjunto.


    ──── FASE 11: EXECUCAO ────

    a) Interpretador (flux run): bytecode em Python.
    b) VM (flux run --vm): bytecode na flux_vm com diagnostico VM001.
    c) LLVM nativo (flux run --llvm): .ll/.bc compilado e executado.
    d) WAT nativo (flux run --wat): .wat (subconjunto v0.5).
    e) WASM nativo (flux run --wasm): .wasm (subconjunto v0.5).


    ──── FASE 12: DIAGNOSTICO ────

   Formato unificado: file:line,col -> [CODE]: message
   Diagnosticos por fase listados na tabela acima.


   ──── FLUXO DE CHAMADA CLI ────

    flux check <file>             Fases 0–5 (validacao apenas)
    flux run <file>               Fases 0–7 → executa (11a)
    flux run --dbg <file>         Pipeline com verbose de cada fase
    flux run --vmbc <file>        Fases 0–7 → executa (11b)
    flux run --llvm <file>        Fases 0–5,8 → executa (11c)
    flux run --wat <file>         Fases 0–5,9 → executa (11d)
    flux run --wasm <file>        Fases 0–5,9 → executa (11e)
    flux build --emit-vmbc <file> Fases 0–7 → .fvmbc
    flux build --emit-wat <file>  Fases 0–5,9 → .wat
    flux build --emit-wasm <file> Fases 0–5,9 → .wasm
    flux build --emit-llvm <file> Fases 0–5,8 → .ll/.bc
*/


/* ================================================================
   14. CONTRATO DE DIAGNOSTICO
   ================================================================ */

diagnostic           ::= source_name ":" line "," column " -> "
                         "[" diagnostic_code "]" ":" message ;

source_name          ::= filename | "<stdin>" ;
filename             ::= filename_char { filename_char } ;
filename_char        ::= ? qualquer caractere de nome-fonte exceto ":" ? ;
line                 ::= integer_literal | "?" ;
column               ::= integer_literal | "?" ;
message              ::= message_char { message_char } ;
message_char         ::= ? qualquer caractere de texto de diagnostico ? ;

diagnostic_code      ::= "LEX001"
                       | "PAR001"
                       | "SEM001"
                       | "CMP001"
                       | "RUN001"
                       | "BC001"
                       | "VM001"
                       | "LLVM001"
                       | "WATM001"
                       | "WASM001"
                       | "CLI001" ;

/*
   Todos os novos diagnostics de protecao seguem:
   file:line,column -> [CODE]: description
*/


/* ================================================================
   15. TABELA ASCII COMPLETA - ENCODING INTERNO
   ================================================================ */

/*
   Tabela de todos os 128 codigos ASCII de 7 bits reconhecidos
   pelo lexer, com sua classificacao sintatica.

   ATENCAO: A sintaxe da linguagem (identificadores, palavras-chave,
   operadores, delimitadores) e estritamente ASCII. O suporte a
   Unicode (UTF-8 no codigo fonte) se restringe a strings, chars,
   comentarios e docstrings: um byte com codigo > 0x7F fora desses
   contextos resulta em erro de leitura (LEX001).

   char e um code point Unicode (U+0000..U+10FFFF) de 32 bits
   (UTF-32) em backends compilados; string e UTF-8 (len em bytes).

   Decimal  Hex  Caractere  Classificacao
   -------  ---  ---------  --------------------------------------
      0     00   NUL        aceito em line_comment e block_comment
      1     01   SOH        aceito em line_comment e block_comment
      2     02   STX        aceito em line_comment e block_comment
      3     03   ETX        aceito em line_comment e block_comment
      4     04   EOT        aceito em line_comment e block_comment
      5     05   ENQ        aceito em line_comment e block_comment
      6     06   ACK        aceito em line_comment e block_comment
      7     07   BEL        aceito em line_comment e block_comment
      8     08   BS         aceito em line_comment e block_comment
      9     09   HT (tab)   TAB - proibido, produz TabulationError
     10     0A   LF         line_break - nova linha (\n)
     11     0B   VT         aceito em line_comment e block_comment
     12     0C   FF         aceito em line_comment e block_comment
     13     0D   CR         line_break - retorno de carro (\r)
     14     0E   SO         aceito em line_comment e block_comment
     15     0F   SI         aceito em line_comment e block_comment
     16     10   DLE        aceito em line_comment e block_comment
     17     11   DC1        aceito em line_comment e block_comment
     18     12   DC2        aceito em line_comment e block_comment
     19     13   DC3        aceito em line_comment e block_comment
     20     14   DC4        aceito em line_comment e block_comment
     21     15   NAK        aceito em line_comment e block_comment
     22     16   SYN        aceito em line_comment e block_comment
     23     17   ETB        aceito em line_comment e block_comment
     24     18   CAN        aceito em line_comment e block_comment
     25     19   EM         aceito em line_comment e block_comment
     26     1A   SUB        aceito em line_comment e block_comment
     27     1B   ESC        aceito em line_comment e block_comment
     28     1C   FS         aceito em line_comment e block_comment
     29     1D   GS         aceito em line_comment e block_comment
     30     1E   RS         aceito em line_comment e block_comment
     31     1F   US         aceito em line_comment e block_comment
     32     20   ESPACO     space - caractere de indentacao
     33     21   !          operador unario de negacao (prefix_expr)
     34     22   "          delimitador de string_literal e interpolated_string
     35     23   #          inicio de comentario (#L, #B, #D)
     36     24   $          aceito em line_comment e block_comment
     37     25   %          aceito em line_comment e block_comment
      38     26   &          operador bitwise AND "&"
     39     27   '          delimitador de char_literal
     40     28   (          delimiter "("
     41     29   )          delimiter ")"
      42     2A   *          operador multiplicativo "*"
      43     2B   +          operador aditivo "+"
     44     2C   ,          delimiter ","
      45     2D   -          operador aditivo "-" (inicio de -->, ==>)
      46     2E   .          operador "." (inicio de ..)
     47     2F   /          inicio de /f, /i, /r
     48     30   0          digit
     49     31   1          digit
     50     32   2          digit
     51     33   3          digit
     52     34   4          digit
     53     35   5          digit
     54     36   6          digit
     55     37   7          digit
     56     38   8          digit
     57     39   9          digit
     58     3A   :          delimiter ":" (inicio de ::)
     59     3B   ;          aceito em line_comment e block_comment
      60     3C   <          operador relacional "<" (inicio de <<)
     61     3D   =          inicio de ==, assignment operators
      62     3E   >          operador relacional ">" (inicio de >>, >>>)
       63     3F   ?          operador de propagacao de erro "?" (pos-fixo)
     64     40   @          aceito em line_comment e block_comment
     65     41   A          upper_letter
     66     42   B          upper_letter
     67     43   C          upper_letter
     68     44   D          upper_letter
     69     45   E          upper_letter
     70     46   F          upper_letter
     71     47   G          upper_letter
     72     48   H          upper_letter
     73     49   I          upper_letter
     74     4A   J          upper_letter
     75     4B   K          upper_letter
     76     4C   L          upper_letter
     77     4D   M          upper_letter
     78     4E   N          upper_letter
     79     4F   O          upper_letter
     80     50   P          upper_letter
     81     51   Q          upper_letter
     82     52   R          upper_letter
     83     53   S          upper_letter
     84     54   T          upper_letter
     85     55   U          upper_letter
     86     56   V          upper_letter
     87     57   W          upper_letter
     88     58   X          upper_letter
     89     59   Y          upper_letter
     90     5A   Z          upper_letter
      91     5B   [          operador de acesso "["
     92     5C   \          escape_sequence (inicio de sequencias \', \", etc.)
      93     5D   ]          operador de acesso "]"
      94     5E   ^          operador bitwise XOR "^" (inicio de ^e, ^r)
     95     5F   _          underscore - parte de identificadores
     96     60   `          aceito em line_comment e block_comment
     97     61   a          lower_letter
     98     62   b          lower_letter
     99     63   c          lower_letter
    100     64   d          lower_letter
    101     65   e          lower_letter
    102     66   f          lower_letter
    103     67   g          lower_letter
    104     68   h          lower_letter
    105     69   i          lower_letter
    106     6A   j          lower_letter
    107     6B   k          lower_letter
    108     6C   l          lower_letter
    109     6D   m          lower_letter
    110     6E   n          lower_letter
    111     6F   o          lower_letter
    112     70   p          lower_letter
    113     71   q          lower_letter
    114     72   r          lower_letter
    115     73   s          lower_letter
    116     74   t          lower_letter
    117     75   u          lower_letter
    118     76   v          lower_letter
    119     77   w          lower_letter
    120     78   x          lower_letter
    121     79   y          lower_letter
    122     7A   z          lower_letter
    123     7B   {          delimiter "{"
     124     7C   |          operador bitwise OR "|"
    125     7D   }          delimiter "}"
     126     7E   ~          operador bitwise NOT "~"
    127     7F   DEL        aceito em line_comment e block_comment

    Legenda das classificacoes:
    - "reconhecido" - caractere faz parte de um token valido
    - "aceito em line_comment e block_comment" - caractere nao faz parte
      de nenhum token, mas e aceito em comentarios de linha (#L ...)
      e comentarios de bloco (#B ... B#); fora desses contextos o
      lexer emite erro (LEX001)
    - "proibido - TabulationError" - TAB (0x09) e detectado e
      rejeitado com erro especifico

   A classificacao segue as producoes definidas nas secoes 1-5
   desta gramatica. Operadores de mais de um caractere (-->, ==>, ==,
   etc.) sao resolvidos por longest match conforme a Seção 5.
*/