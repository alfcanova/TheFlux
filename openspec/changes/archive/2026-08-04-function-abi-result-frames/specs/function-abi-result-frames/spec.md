## ADDED Requirements

### Requirement: Frame de resultado por chamada
Toda chamada de função nos backends VM, LLVM, WAT e WASM SHALL materializar um frame de resultado `{sta, val, msg}` próprio daquela invocação, devolvido ao chamador exatamente uma vez por chamada. O frame de uma chamada SHALL permanecer válido enquanto o resultado é consumido pelo chamador, independentemente de outras chamadas executadas nesse intervalo.

#### Scenario: chamadas aninhadas preservam resultados
- **WHEN** uma função `g` chama `f(x)` e, depois de receber o frame de `f`, executa mais código que chama outra função `h` antes de emitir o próprio resultado
- **THEN** o frame que `g` recebeu de `f` não é alterado pela execução de `h`, e `g` observa `.sta/.val/.msg` idênticos ao que `f` emitiu

#### Scenario: resultado consumido uma única vez
- **WHEN** uma chamada `r = f(x)` atribui o resultado a uma variável
- **THEN** `r` carrega o frame completo e os campos podem ser lidos múltiplas vezes (`r.sta`, `r.val`, `r.msg`) com o mesmo valor

### Requirement: Recursão com frames independentes
Uma função SHALL poder chamar a si mesma (recursão direta) ou participar de chamadas mutuamente recursivas (recursão indireta) nos backends VM, LLVM, WAT e WASM, com cada nível de recursão mantendo seu próprio frame de resultado sem corromper os níveis anteriores.

#### Scenario: recursão direta
- **WHEN** `function (fatorial) (n: int64) as int64` chama `fatorial(n - 1)` internamente
- **THEN** cada nível devolve seu próprio frame e `fatorial(5).val` é calculado corretamente, idêntico ao interpreter

#### Scenario: recursão com leitura de campos após retorno
- **WHEN** uma função recursiva lê `.val` do frame da chamada recursiva antes de emitir o próprio resultado
- **THEN** o valor lido corresponde ao frame daquele nível, não ao da chamada interna

### Requirement: Campos observáveis idênticos ao interpreter
Os backends VM, LLVM, WAT e WASM SHALL expor `.sta`, `.val` e `.msg` com o mesmo conteúdo que o interpreter para o mesmo programa: `.sta` é `"nice"` ou `"fail"` conforme o status do `emit`, `.val` é o valor do identificador emitido com tipo derivado do `as <tipo>` da função, e `.msg` é a mensagem do `emit`.

#### Scenario: paridade do `.val` tipado
- **WHEN** uma função declara `as int64` e emite uma variável inteira, e o resultado é usado em expressão aritmética
- **THEN** `r.val` participa da expressão como `int64` com o mesmo valor em todos os backends

#### Scenario: frame `fail` carregando `.val`
- **WHEN** uma função termina com `emit(fail, err, "msg")`
- **THEN** `.sta == "fail"` e `.val` é igual a `err` nos 5 backends

### Requirement: Erro explícito no lugar de placeholder
Nenhum backend SHALL mascarar um resultado com valor sintético para caminho não implementado: `Value("void")` no interpreter, `PUSH 0` no compiler VM, `("0","i64")` no LLVM e `i32/i64.const 0` no WAT/WASM para nós não suportados SHALL ser substituídos por erro explícito com identificação do ponto de falha. Globals de resultado (`@__flux_result_*`, `$__flux_result_*`) SHALL ser removidos.

#### Scenario: node não suportado é erro
- **WHEN** um backend encontra um nó de AST sem geração implementada
- **THEN** a compilação/execução falha com erro indicando o tipo de nó, em vez de produzir um resultado falsamente válido

#### Scenario: ausência de globals de resultado
- **WHEN** o IR LLVM ou o módulo WAT/WASM de uma função com `emit` é inspecionado
- **THEN** não há símbolos `__flux_result_*` nem leituras/escritas de global de resultado; o resultado trafega pelo retorno da função

### Requirement: Divisão por zero devolve frame `fail` observável
Nos backends LLVM, WAT e WASM, a divisão por zero dentro de uma função SHALL devolver ao chamador um frame com `.sta == "fail"` e `.val` igual ao divisor, sem trap nem valor sintético, coincidindo com o comportamento do interpreter.

#### Scenario: `fail` capturável pelo short-circuit
- **WHEN** uma função executa divisão por zero e o chamador consome o resultado com `? f(x) { fail(v) ==> {...} }`
- **THEN** o braço `fail` é executado com `v.val` igual ao divisor, em todos os backends

### Requirement: Paridade no gate de compliance
O gate de paridade SHALL executar um programa com chamadas aninhadas, `.val` tipado, divisão por zero capturada e recursão, e exigir saída idêntica nos 5 backends (interpreter, VM, LLVM, WAT, WASM).

#### Scenario: gate verde com função de aninhamento e recursão
- **WHEN** o exemplo de paridade de função é executado por `backend_compliance.py` e `flux_verify.py`
- **THEN** as saídas dos 5 backends coincidem integralmente
