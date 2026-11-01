## ADDED Requirements

### Requirement: Sintaxe do emit como terminal único
O statement `emit` SHALL ter exatamente a forma `emit(status, value, message)`, onde `status` é restrito aos tokens `nice` ou `fail`, `value` é um único identificador (variável já declarada, sem expressão), e `message` é um literal string ou string interpolada obrigatório. Nenhuma das três posições pode ser omitida, deixada vazia ou aceitar identificador para valor/status não-keyword.

#### Scenario: emit válido completo
- **WHEN** o fonte contém `emit(nice, x, "ok")` dentro de uma função com `x` declarada
- **THEN** o statement é aceito pelo parser

#### Scenario: mensagem ausente é erro
- **WHEN** o fonte é `emit(nice, x)` sem o terceiro argumento
- **THEN** o parser ou o semântico não aceita o programa, com mensagem apontando a mensagem obrigatória

#### Scenario: multiterm exames
- **WHEN** o fonte é `emit(nice, x, y, "ok")` (lista de variáveis)
- **THEN** o programa é recusado — o slot `value` aceita um único identificador

#### Scenario: status como expressão
- **WHEN** o fonte é `emit(foo, x, "ok")` onde `foo` é um identificador
- **THEN** o programa é recusado — `status` é obrigatoriamente token `nice`/`fail`

### Requirement: Retorno como struct implícito de sistema
Toda chamada de função que termina em `emit` SHALL devolver um struct implícito de sistema com três campos sempre definidos e não vazios: `.sta` (string `"nice"` ou `"fail"`), `.msg` (string do emit), e `.val` (o valor do identificador emitido, com tipo estático igual ao tipo de retorno declarado `as <tipo>` da função). O struct é materializado uma única vez por chamada e não reevalua a função.

#### Scenario: campos acessíveis após chamada
- **WHEN** `function (calc) (x: int64) as int64 { emit(nice, x, "ok") }` é chamada com `r = calc(5)`
- **THEN** `r.sta` vale `"nice"`, `r.val` vale `5`, `r.msg` vale `"ok"`

#### Scenario: falha também carrega os três campos
- **WHEN** uma função termina com `emit(fail, err, "erro de validacao")`
- **THEN** o resultado tem `.sta == "fail"`, `.val` igual a `err` e `.msg == "erro de validacao"`

#### Scenario: `.val` tipado pela função
- **WHEN** a função declara `as int64` e emite uma variável inteira
- **THEN** `.val` pode ser usado onde `int64` é aceito

### Requirement: Acesso nomeado aos campos
O sistema SHALL permitir ler os campos do struct de resultado pelo operador de acesso por campo `.` com os nomes `sta`, `val` e `msg`. Qualquer outro campo sobre um resultado SHALL ser rejeitado. O caminho inteiro do resultado também SHALL estar disponível via variável (ex.: `r = calc(5)`).

#### Scenario: campo inválido sobre resultado
- **WHEN** o fonte é `calc(5).inexistente`
- **THEN** o sistema reporta erro de campo inexistente para resultado

#### Scenario: acesso ao struct inteiro
- **WHEN** uma chamada é atribuída a `r = calc(5)`
- **THEN** `r` carrega sta, val e msg e seus campos são lidos individualmente (ex.: `print(r.sta)`, `print(r.val)`, `print(r.msg)`)

### Requirement: Bloco `?` short-circuit preservado
O bloco `? <call> { fail(v) ==> {...} nice(n) ==> {...} }` SHALL continuar consumindo o struct de resultado sem reavaliar a chamada: o braço `fail` é executado quando `.sta == "fail"` e o (braço) nice quando `.sta == "nice"`, ligando o struct inteiro na variável do braço.

#### Scenario: ramo fail
- **WHEN** a chamada retorna status `"fail"`
- **THEN** o braço `fail(v)` é executado, com `v` carregando o struct completo (sta, val, msg)

#### Scenario: ramo nice
- **WHEN** a chamada retorna status `"nice"`
- **THEN** o braço `nice(n)` é executado, com `n` carregando o struct completo

### Requirement: Diagnósticos semânticos de integridade
O semântico SHALL emitir diagnóstico quando a integridade do resultado estiver comprometida: função que termina em `emit` sem `as <tipo>` declarado (impossível tipar `.val`); `val` apontando para identificador não declarado; `msg` ausente; e acessos `.sta/.val/.msg` sobre valores que não sejam resultado de chamada de função.

#### Scenario: função sem tipo de retorno
- **WHEN** uma função que termina em `emit` não declara `as <tipo>`
- **THEN** o semântico emite erro exigindo o tipo de retorno

#### Scenario: valor não declarado
- **WHEN** `emit(nice, naoExiste, "ok")` referencia variável inexistente
- **THEN** o semântico sinaliza identificador não declarado

#### Scenario: acesso de campo em não-resultado
- **WHEN** `.sta` é usado sobre uma variável que não é resultado de função
- **THEN** o semântico reporta acesso de regra inválido

### Requirement: Consistência entre backends
Os backends Interpreter, VM, LLVM, WAT e WASM SHALL expor os mesmos três campos (`.sta`, `.val`, `.msg`) para uma chamada que termina em `emit`, com valores coincidentes entre si para o mesmo programa de teste.

#### Scenario: paridade interpreter/VM
- **WHEN** o mesmo programa emite `emit(nice, q, "msg")` e é executado no interpreter e na VM
- **THEN** `.sta`, `.val` e `.msg` coincidem

#### Scenario: paridade LLVM/WAT/WASM
- **WHEN** o mesmo programa termina em `emit` e é compilado para LLVM/WAT/WASM
- **THEN** as saídas impressas a partir dos campos são as mesmas do interpreter