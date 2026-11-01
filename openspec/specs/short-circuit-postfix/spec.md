# short-circuit-postfix

## Purpose

Define o operador short-circuit pós-fixado `<expressão> ? { ==> emit(fail, ...) ==> emit(nice, ...) }` da linguagem TheFlux, com despacho por status do struct de resultado, sem reavaliar a expressão, e com comportamento consistente entre os cinco backends. O `?` pré-fixado é removido e passa a ser erro de sintaxe.

## Requirements

### Requirement: Sintaxe pós-fixada do bloco short-circuit

O operador short-circuit SHALL ser pós-fixado, na forma `<expressão> "?" "{" <braço_fail> <braço_nice> "}"`, com os braços anônimos `==> emit(fail, identificador, mensagem)` e `==> emit(nice, identificador, mensagem)`, nesta ordem (fail antes de nice), ambos obrigatórios, onde `identificador` é uma variável do escopo visível e `mensagem` é string literal ou interpolada. O token `?` no início de expressão SHALL ser rejeitado como erro de sintaxe.

#### Scenario: forma pós-fixada aceita

- **WHEN** o fonte contém `validar(10) ? { ==> emit(fail, err, "negativo") ==> emit(nice, v, "ok") }`
- **THEN** o parser produz um nó short-circuit cuja expressão é `validar(10)`, sem reavaliar

#### Scenario: `?` prefixo rejeitado

- **WHEN** o fonte é `? validar(10) { ... }`
- **THEN** o parser reporta erro de sintaxe

#### Scenario: braços obrigatórios e ordenados

- **WHEN** o bloco omite o braço `fail`, omite o braço `nice`, ou os coloca na ordem inversa
- **THEN** o parser reporta erro

### Requirement: Despacho por status da expressão

O bloco `?` SHALL classificar o valor da expressão em status e executar o braço correspondente, avaliando a expressão uma única vez: (1) struct de resultado de `emit` com `.sta == "fail"` ou valor booleano `false` ou resultado de operação matemática inválida → braço `fail`; (2) struct com `.sta == "nice"` ou booleano `true` → braço `nice`; (3) qualquer outro valor → braço `nice`. A expressão não SHALL ser reavaliada.

#### Scenario: struct fail despacha para fail

- **WHEN** a expressão do `?` retorna struct com `.sta == "fail"`
- **THEN** o braço `==> emit(fail, ...)` é executado

#### Scenario: booleano false despacha para fail

- **WHEN** a expressão do `?` avalia para `false`
- **THEN** o braço `==> emit(fail, ...)` é executado

#### Scenario: booleano true despacha para nice

- **WHEN** a expressão do `?` avalia para `true`
- **THEN** o braço `==> emit(nice, ...)` é executado

#### Scenario: valor aritmético válido despacha para nice

- **WHEN** a expressão do `?` avalia para um inteiro válido (sem status fail)
- **THEN** o braço `==> emit(nice, ...)` é executado

### Requirement: Operações matemáticas inválidas geram status fail

Toda operação matemática inválida SHALL produzir status `fail` por injeção de código nos backends, em vez de abortar a execução: divisão inteira por zero (`/i`) e resto por zero (`/r`) avaliam para o status fail com dados do denominador e mensagem `"divisao por zero"`. Isso SHALL valer dentro ou fora de um bloco `?`.

#### Scenario: divisão por zero dentro do `?`

- **WHEN** o operando do `?` contém `10 /i 0`
- **THEN** o status é fail e o braço `==> emit(fail, ...)` é executado, sem crash do programa

#### Scenario: divisão por zero fora do `?`

- **WHEN** uma atribuição como `r = 10 /i 0` ocorre fora de bloco `?`
- **THEN** `r` recebe struct com `.sta == "fail"`, `.val` igual ao denominador e `.msg == "divisao por zero"`, sem abortar

### Requirement: Braços anônimos e valor do bloco

Os braços do bloco `?` SHALL ser statements `emit` anônimos (sem variável de braço e sem corpo próprio): o bloco SHALL avaliar para o struct de resultado do `emit` do braço selecionado, com `.sta`, `.val` e `.msg` acessíveis conforme a semântica de resultado de `emit`.

#### Scenario: bloco avalia para o emit do braço

- **WHEN** o braço `fail` contém `==> emit(fail, x, "msg")` e é selecionado
- **THEN** o valor do bloco é o struct `{ .sta: "fail", .val: x, .msg: "msg" }`

#### Scenario: campos acessíveis após atribuição

- **WHEN** `r = validar(15) ? { ==> emit(fail, 15, "menor") ==> emit(nice, 15, "ok") }` com `validar` emitindo fail
- **THEN** `r.sta` vale `"fail"`, `r.val` vale `15` e `r.msg` vale `"menor"`

### Requirement: Ligação da variável alvo na atribuição

Quando o bloco `?` é o lado direito de uma atribuição a um identificador (`V = <expr> ? { ... }`), o valor da expressão SHALL ser ligado a `V` antes da avaliação dos braços, permitindo que os braços referenciem `V`; ao final, o struct de resultado do braço selecionado SHALL ser atribuído a `V`.

#### Scenario: braço nice reemite a variável alvo

- **WHEN** o fonte é `mut as int64: resultado = (dividendo /i divisor) ? { ==> emit(fail, divisor, "divisao por zero") ==> emit(nice, resultado, "divisao executada") }` com `dividir(10, 2)`
- **THEN** o braço nice é executado com `resultado` valendo o quociente, e `resultado` recebe struct `{ .sta: "nice", .val: 5, .msg: "divisao executada" }`

#### Scenario: braço fail na mesma forma

- **WHEN** a mesma atribuição é avaliada com `dividir(10, 0)`
- **THEN** o braço fail é executado e `resultado` recebe struct `{ .sta: "fail", .val: 0, .msg: "divisao por zero" }`, sem crash

### Requirement: Consistência entre backends

Os backends Interpreter, VM, LLVM, WAT e WASM SHALL produzir o mesmo comportamento para o bloco `?` pós-fixado e para a divisão por zero, com saídas coincidentes para o mesmo programa.

#### Scenario: paridade do exemplo

- **WHEN** `flux/ExampleOfShortCircuit.flux` é executado nos cinco backends
- **THEN** as saídas impressas coincidem entre todos

#### Scenario: paridade do despacho booleano

- **WHEN** um bloco `?` com expressão booleana é executado nos cinco backends
- **THEN** o braço selecionado e o struct resultante coincidem
