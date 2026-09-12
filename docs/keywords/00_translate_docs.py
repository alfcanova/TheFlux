"""Translate all KW_*.yaml documentation files from Portuguese to English.
Output is written to docs/en/ preserving the same filenames.
"""
import os
import glob
import yaml
import re

DOCS_DIR = os.path.dirname(os.path.abspath(__file__))
EN_DIR = os.path.join(DOCS_DIR, "en")

# ── Category translations ──────────────────────────────────────────
CATEGORY_MAP = {
    "Declaração de Tipo": "Type Declaration",
    "Declaração de Variável": "Variable Declaration",
    "Declaração de Variável Imutável": "Immutable Variable Declaration",
    "Declaração de Função": "Function Declaration",
    "Declaração de Funcao": "Function Declaration",
    "Declaração de Operação": "Operation Declaration",
    "Declaração de Operacao": "Operation Declaration",
    "Declaração de Contrato": "Contract Declaration",
    "Declaração de Agente": "Agent Declaration",
    "Implementação de Contrato": "Contract Implementation",
    "Implementacao de Contrato": "Contract Implementation",
    "Ponto de Entrada": "Entry Point",
    "Declaração de Importação": "Import Declaration",
    "Declaração de Importacao": "Import Declaration",
    "Estrutura de Loop": "Loop Structure",
    "Estrutura Condicional": "Conditional Structure",
    "Controle de Loop": "Loop Control",
    "Controle de Fluxo Condicional": "Conditional Flow Control",
    "Controle de Fluxo": "Flow Control",
    "Pattern Matching": "Pattern Matching",
    "Instrução de Saída": "Output Instruction",
    "Instrução de Saida": "Output Instruction",
    "Instrucao de Saida": "Output Instruction",
    "Instrução de Retorno": "Return Instruction",
    "Instrucao de Retorno": "Return Instruction",
    "Status de Retorno": "Return Status",
    "Entrada de Dados": "Data Input",
    "Tipo Numérico - Inteiro": "Numeric Type - Integer",
    "Tipo Numérico - Ponto Flutuante": "Numeric Type - Floating Point",
    "Tipo Numérico - Complexo": "Numeric Type - Complex",
    "Tipo Escalar Primitivo": "Primitive Scalar Type",
    "Tipo Caractere": "Character Type",
    "Tipo String": "String Type",
    "Tipo de Coleção": "Collection Type",
    "Tipo de Colecao": "Collection Type",
    "Tipo de Coleção - Data": "Collection Type - Data",
    "Tipo de Coleção - List": "Collection Type - List",
    "Tipo de Coleção - Map": "Collection Type - Map",
    "Tipo de Coleção - Set": "Collection Type - Set",
    "Tipo Tensor": "Tensor Type",
    "Tipo de Tensor": "Tensor Type",
    "Erro Fatal": "Fatal Error",
    "Expressão de Erro": "Error Expression",
    "Expressao de Erro": "Error Expression",
    "Recuperação de Erro": "Error Recovery",
    "Recuperacao de Erro": "Error Recovery",
    "Execução Garantida": "Guaranteed Execution",
    "Execucao Garantida": "Guaranteed Execution",
    "Propagação de Erro": "Error Propagation",
    "Propagacao de Erro": "Error Propagation",
    "Tratamento Condicional Estatal": "Stateful Conditional Handling",
    "Operador Aritmético": "Arithmetic Operator",
    "Operador Aritmetico": "Arithmetic Operator",
    "Operador de Atribuição Aritmética": "Arithmetic Assignment Operator",
    "Operador de Atribuicao Aritmetica": "Arithmetic Assignment Operator",
    "Operador de Atribuição Bitwise": "Bitwise Assignment Operator",
    "Operador de Atribuicao Bitwise": "Bitwise Assignment Operator",
    "Operador de Comparação": "Comparison Operator",
    "Operador de Comparacao": "Comparison Operator",
    "Operador Lógico": "Logical Operator",
    "Operador Logico": "Logical Operator",
    "Operador Bitwise": "Bitwise Operator",
    "Operador de Atribuição": "Assignment Operator",
    "Operador de Atribuicao": "Assignment Operator",
    "Operador de Dataflow": "Dataflow Operator",
    "Operador de Range / Slice": "Range / Slice Operator",
    "Operador de Acesso": "Access Operator",
    "Operador de Cast": "Cast Operator",
    "Operador de Cast / Alias de Importação": "Cast Operator / Import Alias",
    "Tarefas Assíncronas": "Asynchronous Tasks",
    "Tarefas Assincronas": "Asynchronous Tasks",
    "Ownership (Propriedade)": "Ownership",
    "Bloco Inseguro": "Unsafe Block",
    "Metaprogramação (Compile-time)": "Metaprogramming (Compile-time)",
    "Metaprogramacao (Compile-time)": "Metaprogramming (Compile-time)",
    "Metaprogramação (Macro)": "Metaprogramming (Macro)",
    "Metaprogramacao (Macro)": "Metaprogramming (Macro)",
    "Metaprogramação (AST)": "Metaprogramming (AST)",
    "Metaprogramacao (AST)": "Metaprogramming (AST)",
    "Iteração": "Iteration",
    "Iteracao": "Iteration",
    "Telemetria/Debug": "Telemetry/Debug",
    "Literal": "Literal",
    "Literal Booleano": "Boolean Literal",
    "Literal de Data/Hora": "Datetime Literal",
    "Literal Numérico": "Numeric Literal",
    "Literal Numerico": "Numeric Literal",
    "Token Especial - Wildcard": "Special Token - Wildcard",
    "Comentário / Documentação": "Comment / Documentation",
    "Comentário / Documentacao": "Comment / Documentation",
    "Comentario / Documentacao": "Comment / Documentation",
    "Interpolação de String": "String Interpolation",
    "Interpolacao de String": "String Interpolation",
    "Composição de Tipo": "Type Composition",
    "Composicao de Tipo": "Type Composition",
    "Outros": "Others",
}

# ── Common Portuguese → English phrase translations ───────────────
# These handle recurring descriptions, usage names, and restrictions
PHRASE_MAP = {
    # General
    "Declara uma variável mutável.": "Declares a mutable variable.",
    "Declara uma variável imutável.": "Declares an immutable variable.",
    "O identificador deve estar em snake_case.": "The identifier must be in snake_case.",
    "Pode ser declarada com ou sem tipo explícito e com ou sem valor inicial.": "Can be declared with or without an explicit type and with or without an initial value.",
    "Pode ser declarada com ou sem tipo explícito.": "Can be declared with or without an explicit type.",
    "snake_case (tudo minúsculo com underscores).": "snake_case (all lowercase with underscores).",
    "tudo minúsculo": "all lowercase",
    "minúsculo": "lowercase",
    "maiúsculo": "uppercase",
    "obrigatório": "required",
    "obrigatória": "required",
    "opcional": "optional",
    "O dois-pontos após": "The colon after",
    "é opcional.": "is optional.",
    "é obrigatório": "is required",
    "na declaração": "in the declaration",
    "na inicialização": "during initialization",
    "no uso": "when used",

    # Struct
    "Declara um tipo struct (registro) com campos nomeados.": "Declares a struct type (record) with named fields.",
    "Os campos podem ser mutáveis (mut) ou imutáveis (imut).": "Fields can be mutable (mut) or immutable (imut).",
    "O nome da struct deve estar em camelCase.": "The struct name must be in camelCase.",
    "A struct é inicializada com sintaxe de função nome(tipo) usando .campo: valor.": "The struct is initialized with function-like syntax using .field: value.",
    "Campos mutáveis usam snake_case.": "Mutable fields use snake_case.",
    "Campos imutáveis usam SCREAMING_SNAKE_CASE.": "Immutable fields use SCREAMING_SNAKE_CASE.",
    "O ponto (.) antes do nome do campo na declaração é opcional, mas obrigatório na inicialização.": "The dot (.) before the field name in declarations is optional, but required during initialization.",
    "Struct com campos mutáveis e imutáveis": "Struct with mutable and immutable fields",
    "Inicialização de struct": "Struct initialization",
    "Acesso a campos": "Field access",
    "Acessa campos da struct usando a notação de ponto.": "Accesses struct fields using dot notation.",

    # Enum
    "Declara um tipo enum (discriminado) que pode assumir diferentes variantes com ou sem dados associados.": "Declares an enum type (discriminated union) that can assume different variants with or without associated data.",
    "O nome do enum deve estar em PascalCase.": "The enum name must be in PascalCase.",
    "Enum com variantes tipadas": "Enum with typed variants",
    "Enum com variantes simples": "Enum with simple variants",

    # Contract
    "Declara um contrato (interface) que especifica um conjunto de operações que um agente deve implementar.": "Declares a contract (interface) specifying a set of operations an agent must implement.",
    "O nome do contrato deve estar em PascalCase.": "The contract name must be in PascalCase.",
    "Implementação de contrato": "Contract implementation",
    "Implementa um contrato existente em um agente.": "Implements an existing contract in an agent.",

    # Function
    "Declara uma função nomeada que pode receber parâmetros e retornar um valor.": "Declares a named function that can receive parameters and return a value.",
    "Parâmetros são declarados como <nome>: <tipo>.": "Parameters are declared as <name>: <type>.",
    "Função com retorno": "Function with return",
    "Função sem retorno (void)": "Function without return (void)",

    # Program
    "Declara o ponto de entrada de um programa .flux.": "Declares the entry point of a .flux program.",
    "Programa mínimo": "Minimal program",
    "Programa com print": "Program with print",

    # Agent
    "Declara um agente que pode implementar contratos e expor operações.": "Declares an agent that can implement contracts and expose operations.",
    "Agente com implementação": "Agent with implementation",
    "Agente sem contrato": "Agent without contract",

    # Use
    "Importa símbolos de outros módulos ou arquivos .fdsl.": "Imports symbols from other modules or .fdsl files.",
    "Importação de módulo completo": "Full module import",
    "Importação seletiva com alias": "Selective import with alias",
    "Importação de operação específica": "Specific operation import",

    # Route
    "Estrutura condicional multi-braço que direciona fluxo baseado em condições.": "Multi-branch conditional structure that directs flow based on conditions.",
    "route com sujeito": "route with subject",
    "route sem sujeito": "route without subject",
    "route com fallthrough": "route with fallthrough",

    # Match
    "Realiza casamento de padrão (pattern matching) contra variantes de um Enum.": "Performs pattern matching against Enum variants.",
    "Match com Enum discriminado": "Match with discriminated Enum",
    "Match com valor padrão": "Match with default value",

    # Error handling
    "Cria um valor de erro que pode ser recuperado com catch.": "Creates an error value that can be recovered with catch.",
    "Recupera de um erro, fornecendo um valor padrão.": "Recovers from an error by providing a default value.",
    "Garante que um bloco de código seja executado, independentemente de erro.": "Ensures a block of code is executed regardless of errors.",
    "Fornece um valor padrão caso a expressão anterior falhe.": "Provides a default value if the previous expression fails.",
    "Encerra o programa imediatamente com uma mensagem de erro.": "Terminates the program immediately with an error message.",

    # Loop
    "Estrutura de iteração infinita (laço) que executa um bloco repetidamente.": "Infinite loop structure that executes a block repeatedly.",
    "Infinite com condição": "Infinite with condition",
    "Infinite com iteração": "Infinite with iteration",
    "Interrompe a execução do laço mais interno.": "Breaks out of the innermost loop.",
    "Pula para a próxima iteração do laço.": "Skips to the next iteration of the loop.",

    # Print / Input / Spy
    "Imprime valores na saída padrão.": "Prints values to standard output.",
    "Lê uma linha da entrada padrão como string.": "Reads a line from standard input as a string.",
    "Exibe informações de depuração sobre uma expressão.": "Displays debugging information about an expression.",
    "Spy de variável": "Variable spy",
    "Spy de expressão": "Expression spy",

    # Emit / Nice / Fail
    "Retorna um valor com status de sucesso (nice).": "Returns a value with success status (nice).",
    "Retorna um valor com status de falha (fail).": "Returns a value with failure status (fail).",
    "Retorna um valor da função com status explícito.": "Returns a value from a function with explicit status.",

    # Async
    "Modificador que transforma uma função em uma operação não-bloqueante que retorna um Future.": "Modifier that turns a function into a non-blocking operation that returns a Future.",
    "Gatilho de execução assíncrona: autoriza e despacha um nó ou o caminho do dataflow para o runtime.": "Asynchronous execution trigger: authorizes and dispatches a node or the dataflow path to the runtime.",
    "Ponto de sincronização linear que suspende a pipeline síncrona até a resolução de um Future.": "Linear synchronization point that suspends the synchronous pipeline until a Future resolves.",

    # Ownership
    "Transfere a posse de um valor (invalida a origem).": "Transfers ownership of a value (invalidates the source).",
    "Empresta uma referência mutável exclusiva.": "Borrows a unique mutable reference.",
    "Preserva a posse durante uma operação.": "Preserves ownership during an operation.",
    "Desativa verificações estáticas de ownership em um bloco.": "Disables static ownership checks in a block.",

    # Types
    "Tipos inteiros com e sem sinal de largura fixa.": "Signed and unsigned fixed-width integer types.",
    "Os tipos com sinal (intN) usam complemento de dois.": "Signed types (intN) use two's complement.",
    "Os tipos sem sinal (uintN) aceitam apenas valores não-negativos.": "Unsigned types (uintN) accept only non-negative values.",
    "O tipo genérico int/uint é resolvido como int64/uint64.": "The generic int/uint types resolve to int64/uint64.",
    "Tipos de ponto flutuante com precisão fixa e formatos especiais.": "Floating-point types with fixed precision and special formats.",
    "Tipos numéricos complexos com parte real e imaginária.": "Complex numeric types with real and imaginary parts.",
    "Tipos escalares primitivos.": "Primitive scalar types.",
    "Tipos de coleção para agrupar múltiplos valores.": "Collection types for grouping multiple values.",
    "Tipo tensor multidimensional (matriz, vetor).": "Multidimensional tensor type (matrix, vector).",

    # Literals
    "Literais numéricos inteiros na base decimal.": "Integer numeric literals in decimal base.",
    "São formados por sequências de dígitos de 0 a 9.": "They are formed by sequences of digits 0 through 9.",
    "O sinal negativo é um operador unário prefixo, não parte do literal.": "The negative sign is a prefix unary operator, not part of the literal.",
    "O tipo padrão inferido é int64, a menos que a declaração explicite outro tipo inteiro.": "The default inferred type is int64, unless the declaration specifies another integer type.",
    "Literais numéricos de ponto flutuante.": "Floating-point numeric literals.",
    "Literais numéricos imaginários (complexos com parte imaginária).": "Imaginary numeric literals (complex with imaginary part).",
    "Representam números imaginários puros com o sufixo i.": "Represent pure imaginary numbers with the i suffix.",
    "Literais caractere ASCII entre aspas simples.": "ASCII character literals between single quotes.",
    "Sequências de caracteres entre aspas duplas.": "Character sequences between double quotes.",
    "O valor nulo none.": "The none null value.",
    "Retornado em acesso a chave/campo ausente.": "Returned when accessing a missing key/field.",
    "Usado como sink em pipelines dataflow (print como terminal).": "Used as sink in dataflow pipelines (print as terminal).",

    # Operators
    "Operadores aritméticos da linguagem.": "Arithmetic operators of the language.",
    "Diferencia divisão decimal (/f), divisão inteira (/i) e resto de divisão (/r).": "Distinguishes decimal division (/f), integer division (/i), and remainder (/r).",
    "Operadores de comparação.": "Comparison operators.",
    "Operadores lógicos para booleanos.": "Logical operators for booleans.",
    "Operadores bitwise para manipulação de bits.": "Bitwise operators for bit manipulation.",
    "Operadores de atribuição compostos.": "Compound assignment operators.",
    "Operadores de dataflow para pipelines.": "Dataflow operators for pipelines.",
    "Operador de propagação de erro ?.": "Error propagation operator ?.",
    "Operador de range (..) para fatias e intervalos.": "Range operator (..) for slices and intervals.",
    "Operadores de acesso a campos, métodos e namespace.": "Field, method, and namespace access operators.",

    # Restrictions
    "Valores fora da faixa do tipo são rejeitados em tempo de compilação.": "Values outside the type's range are rejected at compile time.",
    "Não há sufixo de tipo": "There is no type suffix",
    "o tipo vem da declaração": "the type comes from the declaration",
    "Apenas base decimal é suportada": "Only decimal base is supported",
    "sem hex, bin ou oct": "no hex, bin, or oct",
    "Não há suporte para herança.": "There is no support for inheritance.",
    "Contratos não podem ser instanciados diretamente.": "Contracts cannot be instantiated directly.",
    "O tipo do parâmetro deve corresponder ao declarado.": "The parameter type must match the declared type.",

    # Miscellaneous
    "comportamento indefinido": "undefined behavior",
    "em tempo de compilação": "at compile time",
    "em tempo de execução": "at runtime",
    "não é permitido": "is not allowed",
    "não são permitidos": "are not allowed",
    "não pode ser usado": "cannot be used",
    "pode ser usado": "can be used",
    "deve ser": "must be",
    "devem ser": "must be",
    "Variáveis mutáveis podem ser reatribuídas": "Mutable variables can be reassigned",
    "Variáveis imutáveis não podem ser reatribuídas": "Immutable variables cannot be reassigned",
    "Suporta operadores de atribuição composta": "Supports compound assignment operators",
    "com alias": "with alias",
    "Exemplo clássico": "Classic example",
}


# ── Full Term Replacements (ordered by length) ─────────────────────
WORD_REPLACEMENTS = [
    # Complex phrases
    ("múltiplos empréstimos simultâneos são permitidos", "multiple simultaneous borrows are allowed"),
    ("múltiplos borrows imutáveis simultâneos são permitidos", "multiple simultaneous immutable borrows are allowed"),
    ("bloqueia outros borrows, moves e escritas", "blocks other borrows, moves, and writes"),
    ("bloqueia outros borrows, moves e escritas por referência externa", "blocks other borrows, moves, and external writes"),
    ("sem transferir a sua posse (ownership)", "without transferring its ownership"),
    ("Empréstimo dos valores de um identificador", "Borrowing the values of an identifier"),
    ("Operações em referências não alteram o valor original", "Operations on references do not modify the original value"),
    ("Leitura de variável em borrow_mut por referência diferente → erro", "Reading a variable under borrow_mut via a different reference → error"),
    ("Reatribuição de ref via borrow_mut() é permitida", "Reassigning ref via borrow_mut() is allowed"),
    ("Após move(x), x fica MOVED até nova atribuição", "After move(x), x remains MOVED until reassigned"),
    ("Leitura de x após move sem reatribuição → erro SEM001", "Reading x after move without reassignment → error SEM001"),
    ("Revivificação: x = novo_valor torna x válido novamente", "Revivification: x = new_value makes x valid again"),
    ("Move é verificado estaticamente pelo borrow checker", "Move is statically verified by the borrow checker"),
    ("Use unsafe { } para desabilitar a verificação", "Use unsafe { } to disable verification"),
    ("A declaração de tipo é obrigatória", "Type declaration is mandatory"),
    ("A verificação de tipagem ocorre somente depois de pressionar Enter", "Type checking occurs only after pressing Enter"),
    ("volta ao prompt com", "returns to prompt with"),
    ("Se o tipo digitado for incompatível com o tipo declarado, o prompt volta e escreve em cinza", "If the typed value is incompatible with the declared type, the prompt returns and writes in gray"),
    ("O valor lido é compatível com o tipo da variável; pode ser convertido para outros tipos usando as (cast)", "The read value is compatible with the variable type; it can be cast to other types using as"),
    ("Lê um inteiro. Após Enter, valida que o valor é int64; se não for, volta ao prompt com", "Reads an integer. After Enter, validates that the value is int64; if not, returns to prompt with"),
    ("Lê um texto. Qualquer valor digitado é aceito como string", "Reads text. Any typed value is accepted as a string"),
    ("O tipo declarado define o tipo esperado; outros builtins funcionam da mesma forma", "The declared type defines the expected type; other builtins work the same way"),
    ("Input tipado como int64", "Input typed as int64"),
    ("Input tipado como string", "Input typed as string"),
    ("Input tipado com outros builtins", "Input typed with other builtins"),
    ("Lê uma linha da entrada padrão (stdin) e atribui à variável declarada", "Reads a line from standard input (stdin) and assigns it to the declared variable"),
    ("Exibe um prompt opcional antes da leitura", "Displays an optional prompt before reading"),
    ("No TheFlux, a declaração de tipo é obrigatória; o tipo declarado na variável define o tipo esperado do valor digitado", "In TheFlux, type declaration is mandatory; the declared variable type defines the expected type of the typed value"),
    ("A verificação de tipagem ocorre somente depois de pressionar Enter. Se o valor digitado for incompatível com o tipo declarado, o prompt volta e escreve em cinza \"Digite um <tipo>\"", "Type checking occurs only after pressing Enter. If the typed value is incompatible with the declared type, the prompt returns and writes in gray \"Enter a <type>\""),

    # Match / Enums / Structs phrases
    ("Match com literais", "Match with literals"),
    ("Match com enum", "Match with enum"),
    ("Match com struct", "Match with struct"),
    ("Match com registro", "Match with record"),
    ("Match com guard", "Match with guard"),
    ("Match aninhado", "Nested match"),
    ("Enum com variantes unitárias", "Enum with unit variants"),
    ("Enum com payload", "Enum with payload"),
    ("Inicialização de variantes", "Variant initialization"),
    ("Pattern matching", "Pattern matching"),
    ("Struct com campos mutáveis e imutáveis", "Struct with mutable and immutable fields"),
    ("Inicialização de struct", "Struct initialization"),
    ("Acesso aos campos", "Field access"),
    ("Tipos complexos com partes real e imaginária", "Complex types with real and imaginary parts"),
    ("Parte imaginária pura", "Pure imaginary part"),
    ("Inferência de tipo", "Type inference"),
    ("Inferência de tipo padrão", "Default type inference"),
    ("Padrão em dataflow", "Pattern in dataflow"),
    ("Booleanos como condição direta de route", "Booleans as direct route condition"),
    ("Declaração com tipos float de precisão definida", "Declaration with float types of defined precision"),
    ("Sem tipo explícito, o literal float é float64", "Without explicit type, float literal is float64"),
    ("Sem tipo complexo explícito, o tipo inferido é complex64", "Without explicit complex type, inferred type is complex64"),
    ("Sem tipo explícito, o literal é int64", "Without explicit type, literal is int64"),
    ("Valores inteiros não-negativos", "Non-negative integer values"),

    # Common terms
    ("em tempo de compilação", "at compile time"),
    ("em tempo de execução", "at runtime"),
    ("em tempo de execucao", "at runtime"),
    ("tempo de compilação", "compile time"),
    ("tempo de execução", "runtime"),
    ("tempo de execucao", "runtime"),
    ("comportamento indefinido", "undefined behavior"),
    ("verificação estática", "static check"),
    ("verificações estáticas", "static checks"),
    ("não é permitido", "is not allowed"),
    ("não é permitida", "is not allowed"),
    ("não são permitidos", "are not allowed"),
    ("não são permitidas", "are not allowed"),
    ("não pode ser usado", "cannot be used"),
    ("não pode ser usada", "cannot be used"),
    ("não podem ser usados", "cannot be used"),
    ("não podem ser usadas", "cannot be used"),
    ("não pode ser", "cannot be"),
    ("não podem ser", "cannot be"),
    ("não deve ser", "should not be"),
    ("não devem ser", "should not be"),
    ("não há suporte", "there is no support"),
    ("não há", "there is no"),
    ("é obrigatório", "is required"),
    ("é obrigatória", "is required"),
    ("são obrigatórios", "are required"),
    ("são obrigatórias", "are required"),
    ("é opcional", "is optional"),
    ("são opcionais", "are optional"),
    ("deve ser", "must be"),
    ("devem ser", "must be"),
    ("pode ser", "can be"),
    ("podem ser", "can be"),
    ("retorna", "returns"),
    ("retornam", "return"),
    ("recebe", "receives"),
    ("recebem", "receive"),
    ("executa", "executes"),
    ("executam", "execute"),
    ("avalia", "evaluates"),
    ("avaliam", "evaluate"),
    ("produz", "produces"),
    ("produzem", "produce"),
    ("gera erro", "generates error"),
    ("geram erro", "generate error"),
    ("resulta em", "results in"),
    ("resultam em", "result in"),
    ("pertence a", "belongs to"),
    ("pertencem a", "belong to"),
    ("somente leitura", "read-only"),
    ("leitura e escrita", "read-write"),
    ("saída padrão", "standard output"),
    ("saida padrao", "standard output"),
    ("entrada padrão", "standard input"),
    ("entrada padrao", "standard input"),
    ("dois-pontos", "colon"),
    ("ponto e vírgula", "semicolon"),
    ("vírgula", "comma"),
    ("virgula", "comma"),
    ("ponto", "dot"),
    ("aspas simples", "single quotes"),
    ("aspas duplas", "double quotes"),
    ("parênteses", "parentheses"),
    ("parenteses", "parentheses"),
    ("colchetes", "brackets"),
    ("chaves", "braces"),
    ("função", "function"),
    ("funções", "functions"),
    ("funcao", "function"),
    ("funcoes", "functions"),
    ("variável", "variable"),
    ("variáveis", "variables"),
    ("variavel", "variable"),
    ("variaveis", "variables"),
    ("mutável", "mutable"),
    ("mutáveis", "mutable"),
    ("mutavel", "mutable"),
    ("mutaveis", "mutable"),
    ("imutável", "immutable"),
    ("imutáveis", "immutable"),
    ("imutavel", "immutable"),
    ("imutaveis", "immutable"),
    ("declaração", "declaration"),
    ("declarações", "declarations"),
    ("declaracao", "declaration"),
    ("declaracoes", "declarations"),
    ("expressão", "expression"),
    ("expressões", "expressions"),
    ("expressao", "expression"),
    ("expressoes", "expressions"),
    ("condição", "condition"),
    ("condições", "conditions"),
    ("condicao", "condition"),
    ("condicoes", "conditions"),
    ("atribuição", "assignment"),
    ("atribuições", "assignments"),
    ("atribuicao", "assignment"),
    ("atribuicoes", "assignments"),
    ("padrão", "pattern"),
    ("padrões", "patterns"),
    ("padrao", "pattern"),
    ("padroes", "patterns"),
    ("número", "number"),
    ("números", "numbers"),
    ("numero", "number"),
    ("numeros", "numbers"),
    ("inteiro", "integer"),
    ("inteiros", "integers"),
    ("caractere", "character"),
    ("caracteres", "characters"),
    ("cadeia", "string"),
    ("cadeias", "strings"),
    ("operação", "operation"),
    ("operações", "operations"),
    ("operacao", "operation"),
    ("operacoes", "operations"),
    ("operador", "operator"),
    ("operadores", "operators"),
    ("parâmetro", "parameter"),
    ("parâmetros", "parameters"),
    ("parametro", "parameter"),
    ("parametros", "parameters"),
    ("argumento", "argument"),
    ("argumentos", "arguments"),
    ("retorno", "return"),
    ("retornos", "returns"),
    ("escopo", "scope"),
    ("escopos", "scopes"),
    ("bloco", "block"),
    ("blocos", "blocks"),
    ("corpo", "body"),
    ("corpos", "bodies"),
    ("tipo", "type"),
    ("tipos", "types"),
    ("valor", "value"),
    ("valores", "values"),
    ("campo", "field"),
    ("campos", "fields"),
    ("variante", "variant"),
    ("variantes", "variants"),
    ("módulo", "module"),
    ("módulos", "modules"),
    ("modulo", "module"),
    ("modulos", "modules"),
    ("arquivo", "file"),
    ("arquivos", "files"),
    ("programa", "program"),
    ("programas", "programs"),
    ("agente", "agent"),
    ("agentes", "agents"),
    ("contrato", "contract"),
    ("contratos", "contracts"),
    ("posse", "ownership"),
    ("empréstimo", "borrow"),
    ("emprestimo", "borrow"),
    ("exclusivo", "exclusive"),
    ("compartilhado", "shared"),
    ("identificador", "identifier"),
    ("identificadores", "identifiers"),
    ("sujeito", "subject"),
    ("sujeitos", "subjects"),
    ("guarda", "guard"),
    ("guardas", "guards"),
    ("braço", "branch"),
    ("braços", "branches"),
    ("braco", "branch"),
    ("bracos", "branches"),
    ("laço", "loop"),
    ("laços", "loops"),
    ("laco", "loop"),
    ("lacos", "loops"),
    ("iteração", "iteration"),
    ("iteracao", "iteration"),
    ("falha", "failure"),
    ("sucesso", "success"),
    ("erro", "error"),
    ("erros", "errors"),
    ("aviso", "warning"),
    ("avisos", "warnings"),
    ("tamanho", "size"),
    ("largura", "width"),
    ("dimensão", "dimension"),
    ("dimensões", "dimensions"),
    ("dimensao", "dimension"),
    ("dimensoes", "dimensions"),
    ("comprimento", "length"),
    ("índice", "index"),
    ("índices", "indices"),
    ("indice", "index"),
    ("indices", "indices"),
    ("fatia", "slice"),
    ("fatias", "slices"),
    ("faixa", "range"),
    ("faixas", "ranges"),
    ("intervalo", "interval"),
    ("intervalos", "intervals"),
    ("exemplo", "example"),
    ("exemplos", "examples"),
    ("uso", "usage"),
    ("usos", "usages"),
    ("restrição", "restriction"),
    ("restrições", "restrictions"),
    ("restricao", "restriction"),
    ("restricoes", "restrictions"),
]

# Sort by length descending for greedy replacement
WORD_REPLACEMENTS.sort(key=lambda x: -len(x[0]))


def translate_category(cat):
    """Translate a category name."""
    return CATEGORY_MAP.get(cat, translate_text(cat))


def translate_text(text, depth=0):
    """Translate a Portuguese text string to English using phrase map + rules."""
    if not text or not isinstance(text, str):
        return text

    t = text.strip()
    if t in PHRASE_MAP:
        return PHRASE_MAP[t]

    if text.endswith("."):
        stripped = text[:-1]
        if stripped in PHRASE_MAP:
            return PHRASE_MAP[stripped] + "."

    return _generic_translate(text)


def _generic_translate(text):
    """Generic translation: apply known phrase and word replacements."""
    result = text
    # First apply PHRASE_MAP
    replacements = sorted(PHRASE_MAP.items(), key=lambda x: -len(x[0]))
    for pt, en in replacements:
        if pt in result:
            result = result.replace(pt, en)
    
    # Then apply WORD_REPLACEMENTS
    for pt, en in WORD_REPLACEMENTS:
        if pt in result:
            result = result.replace(pt, en)
        elif pt.capitalize() in result:
            result = result.replace(pt.capitalize(), en.capitalize())
        elif pt.upper() in result:
            result = result.replace(pt.upper(), en.upper())

    return result


def translate_syntax(syntax_str):
    if not syntax_str or not isinstance(syntax_str, str):
        return syntax_str
    s = syntax_str
    s = s.replace("<tipo>", "<type>")
    s = s.replace("<variável>", "<variable>")
    s = s.replace("<variavel>", "<variable>")
    s = s.replace("<nome>", "<name>")
    s = s.replace("<expressão>", "<expression>")
    s = s.replace("<expressao>", "<expression>")
    s = s.replace("<expressão_prompt>", "<prompt_expression>")
    s = s.replace("<condição>", "<condition>")
    s = s.replace("<condicao>", "<condition>")
    s = s.replace("<valor>", "<value>")
    s = s.replace("<módulo>", "<module>")
    s = s.replace("<modulo>", "<module>")
    s = s.replace("<identificador>", "<identifier>")
    s = s.replace("<tamanho>", "<size>")
    s = s.replace("<sujeito>", "<subject>")
    s = s.replace("<padrao>", "<pattern>")
    s = s.replace("<padrão>", "<pattern>")
    s = s.replace("<corpo>", "<body>")
    s = s.replace("<variante>", "<variant>")
    s = s.replace("<campo>", "<field>")
    s = s.replace("<origem>", "<source>")
    s = s.replace("<destino>", "<destination>")
    return s


def translate_pseudocode(pc_str):
    if not pc_str or not isinstance(pc_str, str):
        return pc_str
    lines = pc_str.split("\n")
    out = []
    for line in lines:
        l = line
        l = re.sub(r"\bLER\b", "READ", l)
        l = re.sub(r"\bIMPRIME\b", "PRINT", l)
        l = re.sub(r"\bIMPRIMIR\b", "PRINT", l)
        l = re.sub(r"\bESCREVER\b", "WRITE", l)
        l = re.sub(r"\bRETORNA\b", "RETURN", l)
        l = re.sub(r"\bRETORNAR\b", "RETURN", l)
        l = re.sub(r"\bEMPRESTAR_MUT\b", "BORROW_MUT", l)
        l = re.sub(r"\bEMPRESTAR\b", "BORROW", l)
        l = re.sub(r"\bMOVER\b", "MOVE", l)
        l = re.sub(r"\bCASO\b", "CASE", l)
        l = re.sub(r"\bSE\b", "IF", l)
        l = re.sub(r"\bSENAO\b", "ELSE", l)
        l = re.sub(r"\bSENÃO\b", "ELSE", l)
        l = re.sub(r"\bENQUANTO\b", "WHILE", l)
        l = re.sub(r"\bPARA\b", "FOR", l)
        l = re.sub(r"\bRE-PERGUNTA\b", "RE-ASK", l)
        if "//" in l:
            code_part, comment_part = l.split("//", 1)
            cp = translate_text(comment_part)
            l = code_part + "// " + cp.strip()
        out.append(l)
    return "\n".join(out)


def translate_entry(data):
    """Translate a single YAML entry from Portuguese to English."""
    result = {}

    # Copy keyword as-is
    result["keyword"] = data.get("keyword", "")

    # Translate category
    cat = data.get("category", "")
    result["category"] = translate_category(cat)

    # Translate description
    desc = data.get("description", "")
    result["description"] = translate_text(desc)

    # Translate syntax
    if "syntax" in data:
        result["syntax"] = translate_syntax(data["syntax"])

    # Translate pseudocode
    if "pseudocode" in data:
        result["pseudocode"] = translate_pseudocode(data["pseudocode"])

    # Translate usages
    usages = data.get("usages", [])
    translated_usages = []
    for usage in usages:
        if isinstance(usage, dict):
            tu = {}
            tu["name"] = translate_text(usage.get("name", ""))
            tu["description"] = translate_text(usage.get("description", ""))
            tu["examples"] = usage.get("examples", [])  # code stays as-is
            translated_usages.append(tu)
    result["usages"] = translated_usages

    # Translate restrictions
    restrictions = data.get("restrictions", [])
    translated_restrictions = []
    for r in restrictions:
        if isinstance(r, str):
            translated_restrictions.append(translate_text(r))
        elif isinstance(r, dict):
            for k, v in r.items():
                translated_restrictions.append(f"{translate_text(str(k))}: {translate_text(str(v))}")
    result["restrictions"] = translated_restrictions

    # Any other keys
    for k in data:
        if k not in result:
            result[k] = data[k]

    return result


def main():
    # Create output directory
    os.makedirs(EN_DIR, exist_ok=True)

    # Find all KW_*.yaml files (excluding KW_index.yaml)
    files = sorted(glob.glob(os.path.join(DOCS_DIR, "KW_*.yaml")))
    count = 0

    for fpath in files:
        fname = os.path.basename(fpath)
        if fname == "KW_index.yaml":
            continue

        with open(fpath, "r", encoding="utf-8") as f:
            data = yaml.safe_load(f)

        if not data or "keyword" not in data:
            continue

        translated = translate_entry(data)

        out_path = os.path.join(EN_DIR, fname)
        with open(out_path, "w", encoding="utf-8") as f:
            yaml.dump(translated, f, allow_unicode=True,
                      default_flow_style=False, sort_keys=False, width=120)

        count += 1

    print(f"Traduzidos {count} arquivos para {EN_DIR}")


if __name__ == "__main__":
    main()

