╔══════════════════════════════════════════════════════════════════╗
║        DOCUMENTO DE SUGESTÕES — MENSAGENS DE ERRO FLUX         ║
║                Catálogo completo de sugestões disponíveis       ║
╚══════════════════════════════════════════════════════════════════╝

====================================================================
 SUMARIO
====================================================================

Este documento lista todas as mensagens de erro que incluem sugestoes
acionaveis no compilador FLUX. As sugestoes sao geradas por 6 mecanismos:

  Categoria                         | Arquivo fonte             | # Erros
  ----------------------------------+---------------------------+---------
  A. Símbolos indefinidos (fuzzy)   | scope.py                  |   1
  B. Type mismatch / conversão      | checker.py, inference.py  |   7
  C. Ownership                      | ownership.py, inference.py|   5
  D. Nomenclatura                   | declarations.py, imports  |  14
  E. Struct field access (fuzzy)    | inference.py              |   1
  F. Keywords estrangeiras          | errors/base.py            |  29
  ----------------------------------+---------------------------+---------
  Total                             |                           |  57

====================================================================
 A. SÍMBOLOS INDEFINIDOS — FUZZY MATCH
====================================================================

┌─────────────────────────────────────────────────────────────────────┐
│ Arquivo:  src/flux_proto/semantic/scope.py                          │
│ Helper:   suggest_similar_name() + format_similar_names()           │
│ Método:   difflib.get_close_matches(cutoff=0.4, max_suggestions=3) │
└─────────────────────────────────────────────────────────────────────┘

  Erro                       | Exemplo de sugestão
  ---------------------------+---------------------------------------
  undefined symbol 'X'       | "did you mean 'myResult'?"
                              | "did you mean 'myResult' or 'MY_VAR'?"

  Obs: Coleta nomes de todos os escopos na cadeia (atual + pais).


====================================================================
 B. TYPE MISMATCH / CONVERSÃO
====================================================================

┌─────────────────────────────────────────────────────────────────────┐
│ Helper:   suggest_cast_targets(source_tag, valid_targets_map)      │
│           suggest_assignable_conversion(source_type, target_type)   │
│ Arquivos: src/flux_proto/semantic/checker.py                       │
│           src/flux_proto/semantic/inference.py                     │
└─────────────────────────────────────────────────────────────────────┘

B.1 Cast inválido
──────────────────────────────────────────────────────────────────────

  Arquivo:  checker.py (metodo _validate_cast)
  Helper:   suggest_cast_targets()

  Erro                                          | Sugestão
  ----------------------------------------------+---------------------------
  cannot cast X to Y                            | "valid cast targets: int64,
                                                  float32, float64, bool, ..."

B.2 Operador requer operando numérico
──────────────────────────────────────────────────────────────────────

  Arquivo:  checker.py (metodo _require_numeric)
  Helper:   suggest_assignable_conversion()

  Erro                                          | Sugestão
  ----------------------------------------------+---------------------------
  operator requires numeric operand, got X      | Depende dos tipos:
                                                  "use 'as int64' to cast
                                                  bool to integer"

B.3 Tipo inteiro esperado
──────────────────────────────────────────────────────────────────────

  Arquivo:  checker.py (metodo _require_integer)
  Helper:   suggest_assignable_conversion()

  Erro                                          | Sugestão
  ----------------------------------------------+---------------------------
  expected integer, got X                       | "use 'trunc()' or 'round()'
                                                  to convert float to integer"

B.4 Tipo bool esperado
──────────────────────────────────────────────────────────────────────

  Arquivo:  checker.py (metodo _require_bool)
  Helper:   suggest_assignable_conversion()

  Erro                                          | Sugestão
  ----------------------------------------------+---------------------------
  expected bool, got X                          | "use 'as bool' to cast
                                                  integer to bool"

B.5 Atribuição com tipo incompatível
──────────────────────────────────────────────────────────────────────

  Arquivo:  inference.py (metodo _infer_assignment)
  Helper:   suggest_assignable_conversion()

  Erro                                          | Sugestão
  ----------------------------------------------+---------------------------
  cannot assign X to Y                          | Depende dos tipos:
                                                  "use 'as int64' to cast bool
                                                  to integer"
                                                  "consider using 'parse_int()'
                                                  for string-to-integer
                                                  conversion"

B.6 Parâmetro de função com tipo incompatível
──────────────────────────────────────────────────────────────────────

  Arquivo:  inference.py (metodo _validate_call_args)
  Helper:   suggest_assignable_conversion()

  Erro                                          | Sugestão
  ----------------------------------------------+---------------------------
  cannot pass X to parameter of type Y          | (mesmas sugestões de
                                                  conversão que B.5)

B.7 Operador lógico com operandos não-bool
──────────────────────────────────────────────────────────────────────

  Arquivo:  inference.py (operador AND/OR)
  Helper:   suggest_assignable_conversion()

  Erro                                          | Sugestão
  ----------------------------------------------+---------------------------
  logical operators require bool operands       | "use 'as bool' to cast
                                                  integer to bool"

  Mapa completo de conversões suportadas:

  Origem     | Alvo       | Sugestão
  -----------+------------+------------------------------------------
  integer    | float      | "use 'as {target}' to cast explicitly"
  float      | integer    | "use 'trunc()' or 'round()' to convert"
  string     | integer    | "consider using 'parse_int()' for conversion"
  string     | float      | "consider using 'parse_float()' for conversion"
  bool       | integer    | "use 'as int64' to cast bool to integer"
  integer    | bool       | "use 'as bool' to cast integer to bool"
  string     | bool       | "use 'as bool' to cast string to bool"


====================================================================
 C. OWNERSHIP
====================================================================

┌─────────────────────────────────────────────────────────────────────┐
│ Helper:   suggest_ownership_fix(error_type, symbol_name, access)   │
│ Arquivos: src/flux_proto/semantic/ownership.py                     │
│           src/flux_proto/semantic/inference.py                     │
└─────────────────────────────────────────────────────────────────────┘

C.1 Use after move
──────────────────────────────────────────────────────────────────────

  Arquivo:  ownership.py (metodo _require_identifier_available)
  Tipo:     "use_after_move"

  Erro                                          | Sugestão
  ----------------------------------------------+---------------------------
  use after move: symbol 'X' was consumed       | "symbol 'X' was consumed
                                                  by a previous move; use
                                                  'borrow' to read without
                                                  consuming, or 'keep' to
                                                  retain ownership"

C.2 Mutable borrow conflict
──────────────────────────────────────────────────────────────────────

  Arquivo:  ownership.py (metodo _require_identifier_available)
  Tipo:     "mutable_borrow_conflict"

  Erro                                          | Sugestão
  ----------------------------------------------+---------------------------
  cannot {read/write} symbol 'X' while          | "symbol 'X' has an active
  a mutable borrow is active                     | mutable borrow; the borrow
                                                  ends when its scope closes"

  Arquivo:  inference.py (metodo _infer_expr - BorrowExpr handler)
  Tipo:     "mutable_borrow_conflict"

  Erro                                          | Sugestão
  ----------------------------------------------+---------------------------
  mutable borrow requires exclusive access      | "symbol 'X' has an active
  to symbol 'X'                                  | mutable borrow; the borrow
                                                  ends when its scope closes"

C.3 Atribuição a símbolo imutável
──────────────────────────────────────────────────────────────────────

  Arquivo:  inference.py (metodo _infer_assignment)
  Tipo:     "immutable_assign"

  Erro                                          | Sugestão
  ----------------------------------------------+---------------------------
  cannot assign to immutable symbol 'X'         | "symbol 'X' was declared
                                                  immutable with 'imut as
                                                  Type:'; use 'mut as Type:'
                                                  to make it mutable"

  cannot assign through immutable symbol 'X'    | (mesma sugestão)

C.4 Atribuição a campo de struct imutável
──────────────────────────────────────────────────────────────────────

  Arquivo:  inference.py (metodo _infer_assignment)
  Tipo:     "immutable_field_assign"

  Erro                                          | Sugestão
  ----------------------------------------------+---------------------------
  cannot assign to immutable struct field 'X'   | "struct field 'X' is
                                                  immutable; declare the field
                                                  with 'mut:' in the struct
                                                  definition to make it mutable"

C.5 Keyword de ownership espera identificador
──────────────────────────────────────────────────────────────────────

  Arquivo:  ownership.py (metodo _ownership_identifier)
  Tipo:     "non_identifier"

  Erro                                          | Sugestão
  ----------------------------------------------+---------------------------
  {move/borrow/keep} expects an identifier      | "'move' expects a simple
                                                  variable name, not an
                                                  expression; assign the
                                                  expression to a variable
                                                  first"


====================================================================
 D. NOMENCLATURA
====================================================================

┌─────────────────────────────────────────────────────────────────────┐
│ Helper:   suggest_naming_fix(name, convention)                     │
│ Arquivos: src/flux_proto/semantic/declarations.py (12 erros)       │
│           src/flux_proto/semantic/imports.py (2 erros)             │
│ Conversões: camelCase, PascalCase, snake_case, SCREAMING_SNAKE    │
└─────────────────────────────────────────────────────────────────────┘

D.1 Nome de struct (deve ser camelCase)
──────────────────────────────────────────────────────────────────────

  Arquivo:  declarations.py (metodo _analyze_struct_decl)

  Erro                              | Entrada     | Sugestão
  ----------------------------------+-------------+-----------------------
  struct name must use camelCase    | "MyStruct"  | "try 'myStruct' instead
                                                     of 'MyStruct'"

D.2 Campo mutável de struct (deve ser snake_case)
──────────────────────────────────────────────────────────────────────

  Arquivo:  declarations.py (metodo _analyze_struct_decl)

  Erro                              | Entrada     | Sugestão
  ----------------------------------+-------------+-----------------------
  mutable struct field must use     | "myField"   | "try 'my_field' instead
  snake_case                        |             | of 'myField'"

D.3 Campo imutável de struct (deve ser SCREAMING_SNAKE)
──────────────────────────────────────────────────────────────────────

  Arquivo:  declarations.py (metodo _analyze_struct_decl)

  Erro                              | Entrada     | Sugestão
  ----------------------------------+-------------+-----------------------
  immutable struct field must use   | "myField"   | "try 'MY_FIELD' instead
  SCREAMING_SNAKE                   |             | of 'myField'"

D.4 Nome de enum (deve ser PascalCase)
──────────────────────────────────────────────────────────────────────

  Arquivo:  declarations.py (metodo _analyze_enum_decl)

  Erro                              | Entrada     | Sugestão
  ----------------------------------+-------------+-----------------------
  enum name must use PascalCase     | "myEnum"    | "try 'MyEnum' instead
                                                     of 'myEnum'"

D.5 Nome de contrato (deve ser PascalCase)
──────────────────────────────────────────────────────────────────────

  Arquivo:  declarations.py (metodo _analyze_contract_decl)

  Erro                              | Entrada     | Sugestão
  ----------------------------------+-------------+-----------------------
  contract name must use PascalCase | "myContract"| "try 'MyContract' instead
                                                     of 'myContract'"

D.6 Nome de operação em contrato (deve ser camelCase)
──────────────────────────────────────────────────────────────────────

  Arquivo:  declarations.py (metodo _analyze_contract_decl)

  Erro                              | Entrada     | Sugestão
  ----------------------------------+-------------+-----------------------
  contract operation name must use  | "MyOp"      | "try 'myOp' instead
  camelCase                         |             | of 'MyOp'"

D.7 Identificador mutável (deve ser snake_case)
──────────────────────────────────────────────────────────────────────

  Arquivo:  declarations.py (metodo _analyze_var_decl)
  Declaração: mut as Type: <snake_case>

  NOTA: A forma abreviada 'mut: var: Type' foi REMOVIDA.
  Apenas 'mut as Type: var1, ..., varN' é aceita.
  'mut: var: Type' agora causa erro de parser:
  "expected 'as' after 'mut'".

  Erro                              | Entrada     | Sugestão
  ----------------------------------+-------------+-----------------------
  mutable identifier must use       | "myVar"     | "try 'my_var' instead
  snake_case                        |             | of 'myVar'"

D.8 Identificador imutável (deve ser SCREAMING_SNAKE)
──────────────────────────────────────────────────────────────────────

  Arquivo:  declarations.py (metodo _analyze_var_decl)
  Declaração: imut as Type: <SCREAMING_SNAKE>

  NOTA: A forma abreviada 'imut: VALOR: Type' foi REMOVIDA.
  Apenas 'imut as Type: VAR1, ..., VARN = expr' é aceita.
  imut REQUER inicializador: 'imut as int64: X' sem '= expr'
  causa erro "immutable declaration requires an initializer".

  Erro                              | Entrada     | Sugestão
  ----------------------------------+-------------+-----------------------
  immutable identifier must use     | "myVar"     | "try 'MY_VAR' instead
  SCREAMING_SNAKE                   |             | of 'myVar'"

D.9 Nome de função (deve ser camelCase)
──────────────────────────────────────────────────────────────────────

  Arquivo:  declarations.py (metodo _analyze_function)

  Erro                              | Entrada       | Sugestão
  ----------------------------------+---------------+-----------------------
  function name must use camelCase  | "do_something"| "try 'doSomething'
                                                       instead of
                                                       'do_something'"

D.10 Nome de op (deve ser camelCase)
──────────────────────────────────────────────────────────────────────

  Arquivo:  declarations.py (metodo _analyze_op_decl)

  Erro                              | Entrada     | Sugestão
  ----------------------------------+-------------+-----------------------
  op name must use camelCase        | "my_op"     | "try 'myOp' instead
                                                     of 'my_op'"

D.11 Nome de program (deve ser PascalCase)
──────────────────────────────────────────────────────────────────────

  Arquivo:  declarations.py (metodo _analyze_program)

  Erro                              | Entrada     | Sugestão
  ----------------------------------+-------------+-----------------------
  program name must use PascalCase  | "mainProg"  | "try 'MainProg' instead
                                                     of 'mainProg'"

D.12 Nome de agent (deve ser PascalCase)
──────────────────────────────────────────────────────────────────────

  Arquivo:  declarations.py (metodo _analyze_agent)

  Erro                              | Entrada     | Sugestão
  ----------------------------------+-------------+-----------------------
  agent name must use PascalCase    | "myAgent"   | "try 'MyAgent' instead
                                                     of 'myAgent'"

D.13 Alias de agent em use (deve ser PascalCase)
──────────────────────────────────────────────────────────────────────

  Arquivo:  imports.py (metodo _analyze_use)

  Erro                              | Entrada     | Sugestão
  ----------------------------------+-------------+-----------------------
  agent alias must use PascalCase   | "myLib"     | "try 'MyLib' instead
                                                     of 'myLib'"

D.14 Alias de op em use (deve ser camelCase)
──────────────────────────────────────────────────────────────────────

  Arquivo:  imports.py (metodo _analyze_use)

  Erro                              | Entrada     | Sugestão
  ----------------------------------+-------------+-----------------------
  op alias must use camelCase       | "MyOp"      | "try 'myOp' instead
                                                     of 'MyOp'"


====================================================================
 E. STRUCT FIELD ACCESS — FUZZY MATCH
====================================================================

┌─────────────────────────────────────────────────────────────────────┐
│ Helper:   suggest_field_access(struct_name, bad_field, fields)    │
│ Arquivo:  src/flux_proto/semantic/inference.py                    │
│           (handler de Attribute expr)                              │
│ Método:   difflib.get_close_matches(cutoff=0.5, max=1)           │
└─────────────────────────────────────────────────────────────────────┘

  Erro                                | Exemplo de sugestão
  ------------------------------------+-------------------------------
  struct 'person' has no field 'NAAME'| "struct 'person' has no field
                                        'NAAME', did you mean 'NAME'?"


====================================================================
 F. KEYWORDS ESTRANGEIRAS → FLUX EQUIVALENTE
====================================================================

┌─────────────────────────────────────────────────────────────────────┐
│ Fonte:    SAFE_SUGGESTIONS em src/flux_proto/errors/base.py        │
│ Método:   suggestion_for_message() — fallback quando suggestion=   │
│            não é fornecido explicitamente                          │
│ Gatilho:  Mensagem contém 'keyword' ou " keyword " (case-insensitive)│
└─────────────────────────────────────────────────────────────────────┘

  Keyword estrangeira   | Sugestão FLUX
  ----------------------+-----------------------------------------------
  func                  | "use 'function'"
  return                | "use 'emit'"
  class                 | "use 'Struct'"
  def                   | "use 'function'"
  lambda                | "use '==>' to create a lambda"
  catch                 | "FLUX uses 'catch' as a recovery operator
                          (e.g., 'error(msg) catch handler')"
  throw                 | "use 'emit(fail, ...)' to signal errors"
  try                   | "use 'catch' or 'fallback' for error recovery,
                          or 'ensure' for cleanup"
  finally               | "use 'ensure' for cleanup blocks"
  for                   | "use 'infinite (x in iterable)' for iteration"
  while                 | "use 'infinite (condition)' for conditional loops"
  do                    | "use 'infinite' with a block for loop constructs"
  switch                | "use 'route' for conditional branching"
  case                  | "use 'route' arms for pattern matching"
  import                | "use 'use' for importing agents"
  from                  | "use 'use X as Y' for selective imports"
  export                | "FLUX exports all top-level items by default"
  extends               | "use 'impl' for contract implementation"
  implements            | "use 'impl' for contract implementation"
  interface             | "use 'contract' for defining interfaces"
  type                  | "use 'Struct' or 'Enum' for type definitions"
  let                   | "use 'mut as Type:' or 'imut as Type:'
                          | for variable declarations"
  const                 | "use 'imut as Type:' for immutable declarations"
  var                   | "use 'mut as Type:' for mutable declarations"


====================================================================
 G. TENSOR — ERROS ESPECÍFICOS
====================================================================

  Tensor tem regras próprias de parser e semântica. Os erros abaixo
  NÃO passam pelo sistema de sugestões — são capturados no parser
  ou na semântica antes da geração de sugestões:

G.1 Erros de parser
──────────────────────────────────────────────────────────────────────

  Arquivo:  src/flux_proto/parser/types.py (_finish_type, _parse_shape)

  Erro                                                   | Causa
  -------------------------------------------------------+-------------
  "Tensor type requires a shape, for example             | 'as Tensor:'
   tensor[3,3] of float64"                                | sem colchetes
  "Tensor type requires 'of <numeric type>', for         | 'as Tensor[3]:'
   example tensor[3] of float64"                          | sem 'of Type'
  "cannot mix '?' and fixed dimensions in                | 'as Tensor[?,2]:'
   tensor shape"                                          | shape mista

G.2 Erros semânticos
──────────────────────────────────────────────────────────────────────

  Arquivo:  src/flux_proto/semantic/declarations.py (_analyze_var_decl)

  Erro                                                   | Causa
  -------------------------------------------------------+-------------
  "tensor declaration with dynamic shape '?' requires   | 'mut as Tensor[?]
   an initializer"                                        | of int64: x'
                                                          | sem '= expr'
  "tensor element type must be a numeric type (int/     | 'Tensor[3] of
   float/complex)"                                        | string'

  NOTA: Como o Tensor exige 'of <numeric type>' no parser,
  o erro de elemento não numérico só ocorre se o tipo passado
  não for um tipo numérico válido (ex: string, bool, data).


====================================================================
 H. LIST/SET — ERROS ESPECÍFICOS
====================================================================

  List e set têm regras próprias de parser e semântica. Os erros abaixo
  NÃO passam pelo sistema de sugestões — são capturados no parser
  ou na semântica antes da geração de sugestões:

H.1 Erros de parser
──────────────────────────────────────────────────────────────────────

  Arquivo:  src/flux_proto/parser/types.py (_finish_type)

  Erro                                                   | Causa
  -------------------------------------------------------+-------------
  "list type requires 'of <element type>', for          | 'as list:'
   example 'list of int64'"                               | sem 'of Type'
  "set type requires 'of <element type>', for           | 'as set:'
   example 'set of int64'"                                | sem 'of Type'

  NOTA: 'list' e 'set' não aceitam shape (colchetes). Apenas
  'list of Type' e 'set of Type' são válidos sintaticamente.

H.2 Erros semânticos
──────────────────────────────────────────────────────────────────────

  Arquivo:  src/flux_proto/semantic/declarations.py (_analyze_var_decl)

  Erro                                                   | Causa
  -------------------------------------------------------+-------------
  "list and set types cannot be immutable; use          | 'imut as list of
   'mut' instead of 'imut'"                              | int64: XS = []'
                                                         | list/set com imut


====================================================================
 I. ARQUIVOS ENVOLVIDOS
====================================================================

  src/flux_proto/errors/base.py              — FluxError, SAFE_SUGGESTIONS
  src/flux_proto/semantic/suggestions.py      — 6 helpers de sugestão
  src/flux_proto/semantic/scope.py             — fuzzy match undefined symbol
  src/flux_proto/semantic/checker.py           — cast + type validation
  src/flux_proto/semantic/inference.py         — assignment + call + ownership
  src/flux_proto/semantic/declarations.py      — naming conventions (12x)
  src/flux_proto/parser/types.py               — parsing de Tensor shape/of
  src/flux_proto/parser/declarations.py        — parsing de mut/imut
  src/flux_proto/semantic/imports.py           — naming conventions (2x)
  src/flux_proto/semantic/ownership.py         — ownership errors (3x)
  tests/unit/test_semantic_errors.py           — 23 testes de sugestão


====================================================================
 J. TESTES
====================================================================

  Arquivo:  tests/unit/test_semantic_errors.py (23 testes)

  Testes de sugestão de tipo:
  ├── test_undefined_symbol_fuzzy_match
  ├── test_undefined_symbol_no_suggestion_for_very_different
  ├── test_invalid_cast_includes_valid_targets
  ├── test_assign_string_to_int_suggests_parse
  ├── test_assign_bool_to_int_suggests_cast
  ├── test_expected_integer_suggests_conversion
  ├── test_expected_bool_via_infer_binary
  ├── test_struct_field_fuzzy_suggestion
  ├── test_suggestion_for_func_keyword
  ├── test_suggestion_for_import_keyword
  ├── test_suggestion_for_let_keyword

  Testes de nomenclatura (helpers):
  ├── test_suggest_naming_fix_camel_case
  ├── test_suggest_naming_fix_snake_case
  ├── test_suggest_naming_fix_screaming_snake
  ├── test_suggest_naming_fix_pascal_case
  ├── test_suggest_naming_fix_snake_to_camel
  ├── test_suggest_naming_fix_already_correct

  Testes de ownership:
  ├── test_use_after_move_suggestion
  ├── test_immutable_assign_suggestion
  ├── test_immutable_struct_field_assign_suggestion
  ├── test_move_expects_identifier_suggestion
  ├── test_mutable_borrow_conflict_suggestion
  ├── test_assign_through_immutable_symbol_suggestion


====================================================================
 FIM DO DOCUMENTO
====================================================================
