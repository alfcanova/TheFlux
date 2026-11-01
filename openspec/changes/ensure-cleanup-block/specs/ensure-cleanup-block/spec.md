## ADDED Requirements

### Requirement: Cláusula ensure com bloco de cleanup
A expressão `expr ensure { bloco }` SHALL ser aceita como operador pós-fixo, onde `expr` é qualquer expressão e `bloco` é um corpo de statements entre `{` e `}`. A forma inline sem bloco (`ensure <expressão>`) SHALL ser rejeitada.

#### Scenario: forma de bloco válida
- **WHEN** o fonte contém `conteudo = arquivo.lerTexto() ensure { arquivo.fechar() }`
- **THEN** o programa é aceito e `conteudo` recebe o valor retornado por `lerTexto()`

#### Scenario: forma inline sem bloco rejeitada
- **WHEN** o fonte contém `buscar() ensure fechar()`
- **THEN** o programa é rejeitado pelo parser ou semântico (esperado `{` após `ensure`)

### Requirement: Preservação do valor e do tipo do alvo
O resultado da expressão `expr ensure { bloco }` SHALL ser o valor produzido por `expr` (avaliada uma única vez), com o mesmo tipo estático de `expr`. O bloco SHALL executar após a avaliação de `expr` e NÃO SHALL alterar o valor ou o tipo do resultado.

#### Scenario: valor preservado após cleanup
- **WHEN** `x = (5 + 3) ensure { print("cleanup") }` é avaliado
- **THEN** `x` vale `8` e "cleanup" é impresso antes da atribuição ser concluída

#### Scenario: alvo avaliado uma única vez
- **WHEN** `f() ensure { print("fim") }` roda com `f` contando chamadas
- **THEN** `f` é invocada exatamente uma vez

#### Scenario: tipo do resultado é o tipo do alvo
- **WHEN** `expr` tem tipo `int64` e o bloco contém statements sem valor
- **THEN** a expressão `ensure` inteira tem tipo `int64`

### Requirement: Execução garantida do bloco em falha
Quando a avaliação de `expr` produz falha (ABI `{ sta, val, msg }` com `sta == "fail"`), o bloco SHALL executar mesmo assim, e a falha SHALL ser propagada como resultado da expressão após a execução do bloco. Falha não tratada lançada dentro do bloco SHALL ser propagada.

#### Scenario: bloco roda quando o alvo falha
- **WHEN** `abrirArquivo("x") ensure { fecharTudo() }` falha ao abrir
- **THEN** `fecharTudo()` executa e o resultado continua sendo a falha original

#### Scenario: falha do bloco propaga
- **WHEN** o bloco de `ok() ensure { erro() }` lança falha
- **THEN** a falha do bloco é o resultado final (não é engolida)

### Requirement: Backends executam a semântica
Todos os runtimes (Interpreter, VM, LLVM, WAT, WASM) SHALL executar `ensure` conforme as regras acima, sem simplificação silenciosa (sem ignorar o bloco ou o valor do alvo).

#### Scenario: interpreter e VM
- **WHEN** um programa com `ensure` roda no Interpreter e na VM
- **THEN** ambos preservam o valor do alvo e executam o bloco (saída observável idêntica)

#### Scenario: backends compilados
- **WHEN** o mesmo programa é compilado por LLVM, WAT e WASM e executado
- **THEN** cada backend preserva o valor do alvo e executa o bloco