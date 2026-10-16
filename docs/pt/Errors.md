# 📋 Catálogo Oficial e Arquitetura de Diagnósticos e Erros — TheFlux

> **Status**: ✅ Implementado e Homologado (100% Concluído)  
> **Objetivo**: Documentação autoritativa e unificada da arquitetura de diagnósticos, convenções de erro, diretrizes de design, catálogo completo dos 82 erros oficiais com dicas prescritivas (`hint:`) e checklist de implementação da linguagem TheFlux.

---

## 🎯 1. Escopo e Diretrizes de Design do Sistema de Erros

### 1.1 Cobertura Universal das 8 Famílias de Erro
A linguagem TheFlux categoriza todos os possíveis problemas de compilação e execução em 8 famílias canônicas com faixas numéricas de três dígitos estritamente delimitadas:

| Classe | Família | Faixa | Descrição | Principais Responsabilidades |
| :---: | :--- | :---: | :--- | :--- |
| **0xx** | **`LEX`** | `001–099` | Léxico e Tokenização | Delimitadores de string/comentários não terminados, caracteres inválidos fora da faixa ASCII, tabulações proibidas (`\t`), formatação numérica literal e casing booleano. |
| **1xx** | **`SYN`** | `100–199` | Sintático e Estrutura Gramatical | Tokens inesperados, delimitadores não balanceados, formas canônicas de coleções (`tensor`, `list`, `set`), ausência do conector `==>` e declarações com sintaxe obsoleta. |
| **2xx** | **`IMP`** | `200–299` | Módulos e Resolução de Importações | Arquivo `.fdsl` não encontrado, dependências cíclicas entre módulos, violação de acesso a operações privadas (`_op`) e colisão de aliases. |
| **3xx** | **`SEM`** | `300–399` | Análise Semântica e Escopos | Convenções de nomenclatura (*PascalCase*, *camelCase*, *snake_case*, *SCREAMING_SNAKE*), inicializadores obrigatórios em imutáveis, agentes incompletos perante seus contratos (`impl`) e regras de canal em `emit`. |
| **4xx** | **`TYP`** | `400–499` | Sistema de Tipos e Tipagem Estática | Matriz completa de incompatibilidades direcionais (ex.: `int` recebendo `float` vs `float` recebendo `complex`), tipos de retorno de `emit` e coerções inválidas. |
| **5xx** | **`OWN`** | `500–599` | Posse de Memória (*Ownership*) e Mutabilidade | Reatribuição a variáveis ou campos imutáveis (`imut`), leitura após movimentação (`use-after-move`), conflitos de empréstimo mutável (`borrow_mut`) e proibição de coleções imutáveis. |
| **6xx** | **`CON`** | `600–699` | Concorrência, Atores e Máquinas de Estado (*FSM*) | Transições de estado inválidas na FSM, envio em canais fechados e estouro de mailbox de agentes. |
| **7xx** | **`RT`**  | `700–799` | Tempo de Execução Nativa (*Runtime*) | Divisão por zero, acessos fora dos limites em coleções 1-based (*out-of-bounds*), estouro de cotas de descompressão (`DecompressQuota`), estouro de pilha (*stack overflow*) e exaustão de memória. |

### 1.2 Princípio da Expectativa Violada
A organização das mensagens de erro e códigos segue rigorosamente o **Princípio da Expectativa Violada**: o código e a mensagem residem na palavra-chave ou entidade que **estabeleceu a regra esperada**, e não no valor que a violou.
* Exemplo: Se uma variável declarada como `mut as int64: x` recebe o valor decimal `3.14`, a regra violada foi a expectativa do tipo `int64`. Logo, o erro é catalogado em `KW_TYPE_int.yaml` sob o código `TYP401` (`EXPECT_INT_GOT_FLOAT`).
* Exemplo oposto: Se uma variável declarada como `mut as complex128: c` recebe `10`, a regra violada foi a do tipo `complex128`. Logo, o erro reside em `KW_TYPE_complex.yaml` sob o código `TYP411` (`EXPECT_COMPLEX_GOT_INT`).

### 1.3 Formato Canônico e Padronizado dos Diagnósticos
Todas as ferramentas (compilador, interpretador, backends e CLI) emitem mensagens no formato canônico universal:

```text
<arquivo>:<linha>,<coluna> -> [<CÓDIGO> - <MNEMÔNICO>]: <MENSAGEM> (linha X, coluna Y)
  💡 Dica: <texto acionável orientando a correção>
```

---

## ⚡ 2. Arquitetura AOT e Zero Overhead de I/O em Runtime

Para garantir que diagnósticos ricos não introduzam lentidão ou I/O de disco durante compilações e execuções críticas, TheFlux adota um pipeline **Ahead-of-Time (AOT)**:

1. **Fonte Única da Verdade (`Single Source of Truth`)**: Todas as definições canônicas de erro são declaradas diretamente nas seções `errors:` dos arquivos YAML em `docs/pt/keywords/KW_*.yaml`.
2. **Validador e Compilador de Catálogo (`scripts/sync_errors_catalog.py`)**: Em tempo de build / CI, o compilador varre todos os YAMLs, valida regras de integridade e compila os dados diretamente para estruturas em código-fonte:
   - **Python** ([`src/flux_proto/diagnostics/catalog_data.py`](../src/flux_proto/diagnostics/catalog_data.py)): Dicionários estáticos em memória (`ERRORS_BY_CODE`, `ERRORS_BY_MNEMONIC`, `TYPE_MISMATCH_MATRIX`) com complexidade de busca $O(1)$ sem tocar no sistema de arquivos.
   - **C Runtime** ([`src/flux_proto/llvm/runtime/flux_errors.h`](../src/flux_proto/llvm/runtime/flux_errors.h)): Enum `FluxErrorCode` e tabelas de resolução de strings C com busca estática rápida via `switch-case` para LLVM IR e WebAssembly.
   - **Autoajuda CLI**: `flux --explain <CÓDIGO_OU_MNEMÔNICO>` resolve instantaneamente a explicação completa do erro.

---

## 📐 3. Estrutura Padrão da Seção `errors:` nos Arquivos YAML

Cada palavra-chave, tipo ou operador em `keywords/` deve conter sua seção `errors:` com os campos obrigatórios:
* `code`: Código alfanumérico padrão de 3 letras da família + 3 dígitos (ex: `TYP401`, `OWN501`).
* `mnemonic`: Nome mnemônico em SCREAMING_SNAKE_CASE (ex: `EXPECT_INT_GOT_FLOAT`).
* `severity`: Nível do diagnóstico (`Error`, `Warning` ou `Suggestion`).
* `trigger`: Descrição técnica da condição exata que dispara o erro.
* `message`: Mensagem canônica emitida pelo compilador.
* `hint`: **Campo obrigatório**. Ação prescritiva de correção orientando o usuário como corrigir o código.
* `example_bad`: Trecho em TheFlux ilustrando o código inválido.
* `example_good`: Trecho em TheFlux ilustrando a forma canônica corrigida.

### 3.1 Exemplo Canônico em Português (`docs/pt/keywords/KW_op.yaml`)
```yaml
restrictions:
  - 'O nome da operação deve estar em camelCase: `op nomeDaOperacao`.'
  - 'Parâmetros seguem a convenção `[mut | imut | as] <tipo>: <identificador>`.'
  - 'O corpo deve terminar obrigatoriamente com um comando `emit` terminal quando possuir retorno.'

errors:
  - code: "SYN130"
    mnemonic: "CONTRACT_OP_CANNOT_HAVE_BODY"
    severity: "Error"
    trigger: "Operação dentro de 'contract' declarando corpo de execução com '==> { ... }'"
    message: "Operações dentro de 'contract' definem apenas assinaturas e não podem possuir corpo de execução"
    hint: "Remova o corpo da operação ('==> { ... }'); implementações pertencem exclusivamente ao 'agent'"
    example_bad: |
      contract (CalculadoraContract) {
        op somar (as int64: a, as int64: b) as int64 ==> {
          emit(nice, a + b, "ok")
        }
      }
    example_good: |
      contract (CalculadoraContract) {
        op somar (as int64: a, as int64: b) as int64
      }
```

---

## 📊 4. Matriz Resumida dos 82 Erros Catalogados (Ordem por Classe: 0xx a 7xx)

| Código | Mnemônico | Severidade | Mensagem Padrão | Arquivo Fonte |
| :--- | :--- | :---: | :--- | :--- |
| `LEX001` | `INVALID_HASH_COMMENT` | Error | Caractere '#' inválido: esperado '#L' para comentário de linha, '#B...B#' para bloco ou '#D...D#' para docstring | [`KW_comments.yaml`](keywords/KW_comments.yaml) |
| `LEX002` | `UNTERMINATED_STRING` | Error | String literal não terminada antes do fim da linha | [`KW_LITERAL_string.yaml`](keywords/KW_LITERAL_string.yaml) |
| `LEX003` | `TABULATION_ERROR` | Error | Tabulação '\t' é proibida no código-fonte TheFlux; utilize múltiplos de 6 espaços | [`KW_comments.yaml`](keywords/KW_comments.yaml) |
| `LEX004` | `NON_ASCII_CHARACTER` | Error | Caractere não-ASCII inválido no código-fonte fora de literais de texto | [`KW_LITERAL_string.yaml`](keywords/KW_LITERAL_string.yaml) |
| `LEX005` | `UNTERMINATED_DOCSTRING` | Error | Docstring não terminada: esperado delimitador de fechamento 'D#' | [`KW_comments.yaml`](keywords/KW_comments.yaml) |
| `LEX006` | `UNTERMINATED_BLOCK_COMMENT` | Error | Comentário em bloco não terminado: esperado delimitador de fechamento 'B#' | [`KW_comments.yaml`](keywords/KW_comments.yaml) |
| `LEX007` | `INVALID_NUMBER_FORMAT` | Error | Formato de número decimal literal inválido | [`KW_LITERAL_float.yaml`](keywords/KW_LITERAL_float.yaml) |
| `LEX010` | `BOOL_INVALID_LITERAL_CASING` | Error | Literais booleanos no TheFlux devem usar PascalCase ('True' ou 'False') | [`KW_LITERAL_bool.yaml`](keywords/KW_LITERAL_bool.yaml) |
| `SYN100` | `UNEXPECTED_TOKEN` | Error | Símbolo ou estrutura sintática inesperada encontrada no código | [`KW_program.yaml`](keywords/KW_program.yaml) |
| `SYN105` | `MUT_MISSING_AS_KEYWORD` | Error | Sintaxe inválida de declaração: esperado 'as' após 'mut' | [`KW_mut.yaml`](keywords/KW_mut.yaml) |
| `SYN120` | `ROUTE_EXPECTED_DOUBLE_ARROW` | Error | Sintaxe inválida de braço no bloco 'route': esperado operador '==>' | [`KW_route.yaml`](keywords/KW_route.yaml) |
| `SYN130` | `CONTRACT_OP_CANNOT_HAVE_BODY` | Error | Operações dentro de 'contract' definem apenas assinaturas e não podem possuir corpo de execução | [`KW_contract.yaml`](keywords/KW_contract.yaml) |
| `SYN140` | `UNCLOSED_DELIMITER` | Error | Delimitador não fechado: esperado fechamento correspondente ')', '}' ou ']' | [`KW_program.yaml`](keywords/KW_program.yaml) |
| `SYN150` | `TENSOR_REQUIRES_SHAPE` | Error | Tipo 'tensor' requer especificação das dimensões entre colchetes (ex: 'tensor[3,3] of float64') | [`KW_TYPE_tensor.yaml`](keywords/KW_TYPE_tensor.yaml) |
| `SYN151` | `TENSOR_REQUIRES_OF_TYPE` | Error | Tipo 'tensor' requer especificação do tipo de elemento com 'of <tipo>' | [`KW_TYPE_tensor.yaml`](keywords/KW_TYPE_tensor.yaml) |
| `SYN160` | `LIST_REQUIRES_OF_TYPE` | Error | Tipo 'list' requer especificação do tipo de elemento com 'of <tipo>' | [`KW_TYPE_list.yaml`](keywords/KW_TYPE_list.yaml) |
| `SYN161` | `SET_REQUIRES_OF_TYPE` | Error | Tipo 'set' requer especificação do tipo de elemento com 'of <tipo>' | [`KW_TYPE_set.yaml`](keywords/KW_TYPE_set.yaml) |
| `IMP201` | `MODULE_NOT_FOUND` | Error | Módulo ou arquivo .fdsl não encontrado nos diretórios de busca ou stdlib | [`KW_use.yaml`](keywords/KW_use.yaml) |
| `IMP202` | `CIRCULAR_IMPORT` | Error | Dependência cíclica de importação detectada entre módulos .fdsl | [`KW_use.yaml`](keywords/KW_use.yaml) |
| `IMP203` | `PRIVATE_OP_ACCESS` | Error | Operações iniciadas com '_' são privadas e não podem ser importadas externamente | [`KW_use.yaml`](keywords/KW_use.yaml) |
| `IMP204` | `DUPLICATE_IMPORT_ALIAS` | Error | Colisão de identificador: o alias já foi utilizado em outra cláusula de importação | [`KW_use.yaml`](keywords/KW_use.yaml) |
| `SEM301` | `INT_LITERAL_OUT_OF_RANGE` | Error | Valor literal excede os limites suportados pelo tipo inteiro | [`KW_TYPE_int.yaml`](keywords/KW_TYPE_int.yaml) |
| `SEM303` | `UNDEFINED_IDENTIFIER` | Error | Identificador não declarado: a variável precisa ser declarada com 'mut' ou 'imut' | [`KW_mut.yaml`](keywords/KW_mut.yaml) |
| `SEM304` | `DUPLICATE_IDENTIFIER` | Error | Identificador duplicado: a variável já foi declarada anteriormente neste mesmo escopo | [`KW_mut.yaml`](keywords/KW_mut.yaml) |
| `SEM305` | `IMMUT_REQUIRES_INITIALIZER` | Error | Declaração de identificador 'imut' exige valor de inicialização obrigatório | [`KW_imut.yaml`](keywords/KW_imut.yaml) |
| `SEM306` | `MUT_IDENTIFIER_SNAKE_CASE` | Warning | Identificador mutável ('mut') deve utilizar a convenção snake_case | [`KW_mut.yaml`](keywords/KW_mut.yaml) |
| `SEM307` | `IMMUT_IDENTIFIER_SCREAMING_SNAKE` | Warning | Identificador imutável ('imut') deve utilizar a convenção SCREAMING_SNAKE_CASE | [`KW_imut.yaml`](keywords/KW_imut.yaml) |
| `SEM310` | `PROGRAM_NAME_PASCAL_CASE` | Error | Nome de 'program' deve utilizar a convenção PascalCase | [`KW_program.yaml`](keywords/KW_program.yaml) |
| `SEM311` | `PROGRAM_PROHIBITED_IN_FDSL` | Error | Declaração de 'program' é proibida em arquivos .fdsl | [`KW_program.yaml`](keywords/KW_program.yaml) |
| `SEM312` | `PROGRAM_MISSING_IN_FLUX` | Error | Arquivo .flux requer declaração do ponto de entrada 'program (<Nome>) { ... }' | [`KW_program.yaml`](keywords/KW_program.yaml) |
| `SEM320` | `ROUTE_WILDCARD_NOT_LAST` | Error | O braço coringa padrão ('_') deve ser obrigatoriamente o último braço no bloco 'route' | [`KW_route.yaml`](keywords/KW_route.yaml) |
| `SEM330` | `CONTRACT_NAME_PASCAL_CASE` | Error | Nome de contrato deve utilizar a convenção PascalCase | [`KW_contract.yaml`](keywords/KW_contract.yaml) |
| `SEM331` | `CONTRACT_OP_CAMEL_CASE` | Error | Operação de contrato deve utilizar a convenção camelCase | [`KW_contract.yaml`](keywords/KW_contract.yaml) |
| `SEM340` | `AGENT_MISSING_CONTRACT_OP` | Error | O agente não implementou todas as operações exigidas pelo contrato | [`KW_agent.yaml`](keywords/KW_agent.yaml) |
| `SEM341` | `AGENT_NAME_PASCAL_CASE` | Error | Nome de agente deve utilizar a convenção PascalCase | [`KW_agent.yaml`](keywords/KW_agent.yaml) |
| `SEM342` | `AGENT_PROHIBITED_IN_FLUX_FILE` | Error | Declaração de 'agent' é permitida exclusivamente em arquivos de biblioteca (.fdsl) | [`KW_agent.yaml`](keywords/KW_agent.yaml) |
| `SEM350` | `EMIT_INVALID_CHANNEL` | Error | Canal de emissão inválido: 'emit' aceita exclusivamente os status 'nice' ou 'fail' | [`KW_emit.yaml`](keywords/KW_emit.yaml) |
| `SEM351` | `EMIT_NON_TERMINAL_STATEMENT` | Error | Código inalcançável detectado: 'emit' encerra a execução da função/operação e deve ser a última instrução | [`KW_emit.yaml`](keywords/KW_emit.yaml) |
| `SEM360` | `STRUCT_NAME_PASCAL_CASE` | Error | Nome de tipo 'struct' deve utilizar a convenção PascalCase | [`KW_struct.yaml`](keywords/KW_struct.yaml) |
| `SEM361` | `STRUCT_UNKNOWN_FIELD` | Error | Campo não encontrado na estrutura | [`KW_struct.yaml`](keywords/KW_struct.yaml) |
| `SEM362` | `STRUCT_MUTABLE_FIELD_SNAKE_CASE` | Warning | Campo mutável de struct deve utilizar a convenção snake_case | [`KW_struct.yaml`](keywords/KW_struct.yaml) |
| `SEM363` | `STRUCT_IMMUTABLE_FIELD_SCREAMING_SNAKE` | Warning | Campo imutável de struct deve utilizar a convenção SCREAMING_SNAKE_CASE | [`KW_struct.yaml`](keywords/KW_struct.yaml) |
| `SEM370` | `ENUM_NAME_PASCAL_CASE` | Error | Nome de enum deve utilizar a convenção PascalCase | [`KW_enum.yaml`](keywords/KW_enum.yaml) |
| `SEM371` | `ENUM_UNKNOWN_VARIANT` | Error | Variante não encontrada na definição do enum | [`KW_enum.yaml`](keywords/KW_enum.yaml) |
| `SEM372` | `ENUM_VARIANT_PASCAL_CASE` | Error | Nome da variante de enum deve utilizar a convenção PascalCase | [`KW_enum.yaml`](keywords/KW_enum.yaml) |
| `TYP401` | `EXPECT_INT_GOT_FLOAT` | Error | A variável esperava um inteiro e recebeu um número decimal (float) | [`KW_TYPE_int.yaml`](keywords/KW_TYPE_int.yaml) |
| `TYP402` | `EXPECT_INT_GOT_COMPLEX` | Error | A variável esperava um inteiro e recebeu um número complexo | [`KW_TYPE_int.yaml`](keywords/KW_TYPE_int.yaml) |
| `TYP403` | `EXPECT_INT_GOT_STRING` | Error | A variável esperava um inteiro e recebeu um texto (string) | [`KW_TYPE_int.yaml`](keywords/KW_TYPE_int.yaml) |
| `TYP404` | `EXPECT_INT_GOT_BOOL` | Error | A variável esperava um inteiro e recebeu um booleano (bool) | [`KW_TYPE_int.yaml`](keywords/KW_TYPE_int.yaml) |
| `TYP411` | `EXPECT_COMPLEX_GOT_INT` | Error | A variável esperava um número complexo e recebeu um número inteiro | [`KW_TYPE_complex.yaml`](keywords/KW_TYPE_complex.yaml) |
| `TYP412` | `EXPECT_COMPLEX_GOT_FLOAT` | Error | A variável esperava um número complexo e recebeu um número decimal (float) | [`KW_TYPE_complex.yaml`](keywords/KW_TYPE_complex.yaml) |
| `TYP413` | `EXPECT_COMPLEX_GOT_STRING` | Error | A variável esperava um número complexo e recebeu texto (string) | [`KW_TYPE_complex.yaml`](keywords/KW_TYPE_complex.yaml) |
| `TYP414` | `EXPECT_COMPLEX_GOT_BOOL` | Error | A variável esperava um número complexo e recebeu um booleano (bool) | [`KW_TYPE_complex.yaml`](keywords/KW_TYPE_complex.yaml) |
| `TYP421` | `EXPECT_FLOAT_GOT_COMPLEX` | Error | A variável esperava um número decimal (float) e recebeu um número complexo | [`KW_TYPE_float.yaml`](keywords/KW_TYPE_float.yaml) |
| `TYP422` | `EXPECT_FLOAT_GOT_STRING` | Error | A variável esperava um número decimal (float) e recebeu texto (string) | [`KW_TYPE_float.yaml`](keywords/KW_TYPE_float.yaml) |
| `TYP423` | `EXPECT_FLOAT_GOT_BOOL` | Error | A variável esperava um número decimal (float) e recebeu um booleano (bool) | [`KW_TYPE_float.yaml`](keywords/KW_TYPE_float.yaml) |
| `TYP431` | `EXPECT_STRING_GOT_INT` | Error | A variável esperava texto (string) e recebeu um número inteiro | [`KW_TYPE_string.yaml`](keywords/KW_TYPE_string.yaml) |
| `TYP432` | `EXPECT_STRING_GOT_FLOAT` | Error | A variável esperava texto (string) e recebeu um número decimal (float) | [`KW_TYPE_string.yaml`](keywords/KW_TYPE_string.yaml) |
| `TYP433` | `EXPECT_STRING_GOT_COMPLEX` | Error | A variável esperava texto (string) e recebeu um número complexo | [`KW_TYPE_string.yaml`](keywords/KW_TYPE_string.yaml) |
| `TYP434` | `EXPECT_STRING_GOT_BOOL` | Error | A variável esperava texto (string) e recebeu um booleano (bool) | [`KW_TYPE_string.yaml`](keywords/KW_TYPE_string.yaml) |
| `TYP441` | `EXPECT_BOOL_GOT_INT` | Error | A expressão esperava um booleano (bool) e recebeu um número inteiro | [`KW_LITERAL_bool.yaml`](keywords/KW_LITERAL_bool.yaml) |
| `TYP442` | `EXPECT_BOOL_GOT_STRING` | Error | A expressão esperava um booleano (bool) e recebeu texto (string) | [`KW_LITERAL_bool.yaml`](keywords/KW_LITERAL_bool.yaml) |
| `TYP443` | `EXPECT_BOOL_GOT_FLOAT` | Error | A expressão esperava um booleano (bool) e recebeu um número decimal (float) | [`KW_LITERAL_bool.yaml`](keywords/KW_LITERAL_bool.yaml) |
| `TYP450` | `EMIT_RETURN_TYPE_MISMATCH` | Error | Tipo de valor emitido diverge do tipo de retorno especificado na assinatura | [`KW_emit.yaml`](keywords/KW_emit.yaml) |
| `TYP499` | `TYPE_MISMATCH_GENERIC` | Error | Incompatibilidade de tipos: os tipos esperados e fornecidos não são compatíveis | [`KW_program.yaml`](keywords/KW_program.yaml) |
| `OWN501` | `CANNOT_MUTATE_IMMUTABLE` | Error | Não é permitido alterar o valor de um identificador imutável ('imut') | [`KW_imut.yaml`](keywords/KW_imut.yaml) |
| `OWN502` | `CANNOT_MUTATE_IMMUT_FIELD` | Error | Campo de estrutura é imutável e não pode ser reatribuído | [`KW_imut.yaml`](keywords/KW_imut.yaml) |
| `OWN503` | `USE_AFTER_MOVE` | Error | Uso inválido de valor movido: a variável já transferiu sua posse e não pode mais ser lida | [`KW_borrow.yaml`](keywords/KW_borrow.yaml) |
| `OWN504` | `MUTABLE_BORROW_CONFLICT` | Error | Conflito de empréstimo: não é permitido acessar ou emprestar variável enquanto houver borrow_mut ativo | [`KW_borrow.yaml`](keywords/KW_borrow.yaml) |
| `OWN505` | `COLLECTION_CANNOT_BE_IMMUTABLE` | Error | Coleções dinâmicas não podem ser imutáveis ('imut'); utilize 'mut as list of <tipo>:' | [`KW_TYPE_list.yaml`](keywords/KW_TYPE_list.yaml) |
| `CON601` | `FSM_INVALID_STATE_TRANSITION` | Error | Transição de estado inválida: o estado de destino não é permitido a partir do estado atual | [`KW_spawn.yaml`](keywords/KW_spawn.yaml) |
| `CON602` | `CHANNEL_SEND_ON_CLOSED` | Error | Tentativa de envio em canal fechado: o canal não aceita mais mensagens | [`KW_spawn.yaml`](keywords/KW_spawn.yaml) |
| `CON603` | `AGENT_MAILBOX_OVERFLOW` | Error | Estouro da caixa postal do agente: capacidade máxima de mensagens pendentes excedida | [`KW_agent.yaml`](keywords/KW_agent.yaml) |
| `RT701` | `DIVISION_BY_ZERO` | Error | Divisão por zero em tempo de execução | [`KW_OP_arithmetic.yaml`](keywords/KW_OP_arithmetic.yaml) |
| `RT702` | `INDEX_OUT_OF_BOUNDS` | Error | Índice fora dos limites da coleção (indexação 1-based) | [`KW_TYPE_list.yaml`](keywords/KW_TYPE_list.yaml) |
| `RT703` | `DECOMPRESS_QUOTA_EXCEEDED` | Error | Cota de descompressão excedida em tempo de execução (limite de segurança violado) | [`KW_keep.yaml`](keywords/KW_keep.yaml) |
| `RT704` | `STACK_OVERFLOW` | Error | Estouro da pilha de execução (Stack Overflow): recursão excessiva sem condição de término | [`KW_infinite.yaml`](keywords/KW_infinite.yaml) |
| `RT705` | `OUT_OF_MEMORY` | Error | Memória insuficiente para alocação do objeto em tempo de execução | [`KW_TYPE_tensor.yaml`](keywords/KW_TYPE_tensor.yaml) |
| `RT706` | `MATH_DOMAIN_LOG` | Error | Argumento fora do domínio de logaritmo: esperado x > 0 | [`KW_OP_arithmetic.yaml`](keywords/KW_OP_arithmetic.yaml) |
| `RT707` | `MATH_DOMAIN_SQRT` | Error | Radicando negativo em raiz par: esperado x >= 0 para números reais | [`KW_OP_arithmetic.yaml`](keywords/KW_OP_arithmetic.yaml) |
| `RT708` | `MATH_DOMAIN_TRIG` | Error | Argumento fora do domínio trigonométrico inverso: esperado -1.0 <= x <= 1.0 | [`KW_OP_arithmetic.yaml`](keywords/KW_OP_arithmetic.yaml) |
| `RT709` | `MATH_POWER_UNDEFINED` | Error | Potência indefinida para base zero e expoente não-positivo | [`KW_OP_arithmetic.yaml`](keywords/KW_OP_arithmetic.yaml) |

---

## 🔬 5. Detalhamento Analítico Completo dos Diagnósticos

### 5.0 Classe 0xx — Léxico e Tokenização (`LEX` 001–099)

*Erros relacionados a literais, delimitadores e caracteres inválidos. Total de diagnósticos catalogados: 8.*

#### `LEX001` — `INVALID_HASH_COMMENT`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_comments.yaml`](keywords/KW_comments.yaml)
* **Gatilho**: Uso do caractere '#' sem um qualificador válido ('#L', '#B' ou '#D')
* **Mensagem Padrão**: *"Caractere '#' inválido: esperado '#L' para comentário de linha, '#B...B#' para bloco ou '#D...D#' para docstring"*
* **Dica de Correção**: 💡 Utilize '#L' para comentários de linha única ou '#B ... B#' para blocos comentados

**Exemplo Incorreto:**
```theflux
# comentario errado
```

**Exemplo Corrigido:**
```theflux
#L comentario correto
```

---

#### `LEX002` — `UNTERMINATED_STRING`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_LITERAL_string.yaml`](keywords/KW_LITERAL_string.yaml)
* **Gatilho**: Literal de string aberto com aspas duplas sem aspas de fechamento antes do fim da linha
* **Mensagem Padrão**: *"String literal não terminada antes do fim da linha"*
* **Dica de Correção**: 💡 Feche o literal de texto com aspas duplas '"' antes da quebra de linha

**Exemplo Incorreto:**
```theflux
mut as string: s = "texto sem fechar
```

**Exemplo Corrigido:**
```theflux
mut as string: s = "texto fechado"
```

---

#### `LEX003` — `TABULATION_ERROR`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_comments.yaml`](keywords/KW_comments.yaml)
* **Gatilho**: Uso de caractere de tabulação (	) no código-fonte
* **Mensagem Padrão**: *"Tabulação '\t' é proibida no código-fonte TheFlux; utilize múltiplos de 6 espaços"*
* **Dica de Correção**: 💡 Substitua caracteres de tabulação '\t' por múltiplos de 6 espaços

**Exemplo Incorreto:**
```theflux
program (Main) {
\tprint("ola")
}
```

**Exemplo Corrigido:**
```theflux
program (Main) {
      print("ola")
}
```

---

#### `LEX004` — `NON_ASCII_CHARACTER`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_LITERAL_string.yaml`](keywords/KW_LITERAL_string.yaml)
* **Gatilho**: Caractere não-ASCII encontrado fora de literais de string ou comentários
* **Mensagem Padrão**: *"Caractere não-ASCII inválido no código-fonte fora de literais de texto"*
* **Dica de Correção**: 💡 Caracteres fora da faixa ASCII (0x00–0x7F) só são permitidos dentro de strings literais ou comentários

**Exemplo Incorreto:**
```theflux
mut as int64: número = 10
```

**Exemplo Corrigido:**
```theflux
mut as int64: numero = 10
```

---

#### `LEX005` — `UNTERMINATED_DOCSTRING`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_comments.yaml`](keywords/KW_comments.yaml)
* **Gatilho**: Bloco de documentação #D ... D# não encerrado antes do final do arquivo
* **Mensagem Padrão**: *"Docstring não terminada: esperado delimitador de fechamento 'D#'"*
* **Dica de Correção**: 💡 Finalize o bloco de docstring com o delimitador 'D#'

**Exemplo Incorreto:**
```theflux
#D
- Titulo: Exemplo
program (Main) { }
```

**Exemplo Corrigido:**
```theflux
#D
- Titulo: Exemplo
D#
program (Main) { }
```

---

#### `LEX006` — `UNTERMINATED_BLOCK_COMMENT`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_comments.yaml`](keywords/KW_comments.yaml)
* **Gatilho**: Comentário em bloco #B ... B# não encerrado antes do final do arquivo
* **Mensagem Padrão**: *"Comentário em bloco não terminado: esperado delimitador de fechamento 'B#'"*
* **Dica de Correção**: 💡 Finalize o comentário em bloco com o delimitador 'B#'

**Exemplo Incorreto:**
```theflux
#B
Comentário sem fechar
```

**Exemplo Corrigido:**
```theflux
#B
Comentário fechado
B#
```

---

#### `LEX007` — `INVALID_NUMBER_FORMAT`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_LITERAL_float.yaml`](keywords/KW_LITERAL_float.yaml)
* **Gatilho**: Formato numérico literal com múltiplos pontos decimais ou caracteres inválidos
* **Mensagem Padrão**: *"Formato de número decimal literal inválido"*
* **Dica de Correção**: 💡 Verifique a formatação do número literal (números decimais devem ter dígitos antes e após o ponto)

**Exemplo Incorreto:**
```theflux
mut as float64: f = 3.14.15
```

**Exemplo Corrigido:**
```theflux
mut as float64: f = 3.1415
```

---

#### `LEX010` — `BOOL_INVALID_LITERAL_CASING`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_LITERAL_bool.yaml`](keywords/KW_LITERAL_bool.yaml)
* **Gatilho**: Uso de literal booleano em minúsculo ou caixa alta (true, false, TRUE, FALSE)
* **Mensagem Padrão**: *"Literais booleanos no TheFlux devem usar PascalCase ('True' ou 'False')"*
* **Dica de Correção**: 💡 Utilize 'True' ou 'False' com a primeira letra maiúscula

**Exemplo Incorreto:**
```theflux
mut as bool: ativo = true
```

**Exemplo Corrigido:**
```theflux
mut as bool: ativo = True
```

---

### 5.1 Classe 1xx — Sintaxe e Estrutura Gramatical (`SYN` 100–199)

*Erros de estrutura gramatical, conectores `==>` e declarações canônicas de tipos e coleções. Total de diagnósticos catalogados: 9.*

#### `SYN100` — `UNEXPECTED_TOKEN`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_program.yaml`](keywords/KW_program.yaml)
* **Gatilho**: Token inesperado encontrado durante a análise sintática
* **Mensagem Padrão**: *"Símbolo ou estrutura sintática inesperada encontrada no código"*
* **Dica de Correção**: 💡 Verifique a sintaxe ao redor do token indicado

**Exemplo Incorreto:**
```theflux
program (Main) {
  mut as int64: x == 10
}
```

**Exemplo Corrigido:**
```theflux
program (Main) {
  mut as int64: x = 10
}
```

---

#### `SYN105` — `MUT_MISSING_AS_KEYWORD`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_mut.yaml`](keywords/KW_mut.yaml)
* **Gatilho**: Declaração mutável no formato antigo 'mut: var: Tipo' sem a palavra-chave 'as'
* **Mensagem Padrão**: *"Sintaxe inválida de declaração: esperado 'as' após 'mut'"*
* **Dica de Correção**: 💡 Utilize a sintaxe canônica: 'mut as <tipo>: <identificador> [= <valor>]'

**Exemplo Incorreto:**
```theflux
mut: x: int64 = 10
```

**Exemplo Corrigido:**
```theflux
mut as int64: x = 10
```

---

#### `SYN120` — `ROUTE_EXPECTED_DOUBLE_ARROW`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_route.yaml`](keywords/KW_route.yaml)
* **Gatilho**: Braço de rota definido sem o operador de mapeamento '==>'
* **Mensagem Padrão**: *"Sintaxe inválida de braço no bloco 'route': esperado operador '==>'"*
* **Dica de Correção**: 💡 Adicione o operador '==>' entre a condição/padrão e o bloco de ação

**Exemplo Incorreto:**
```theflux
route {
  x > 0 { print("positivo") }
}
```

**Exemplo Corrigido:**
```theflux
route {
  x > 0 ==> { print("positivo") }
}
```

---

#### `SYN130` — `CONTRACT_OP_CANNOT_HAVE_BODY`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_contract.yaml`](keywords/KW_contract.yaml)
* **Gatilho**: Operação declarada dentro de contrato com corpo executável ou bloco '==>'
* **Mensagem Padrão**: *"Operações dentro de 'contract' definem apenas assinaturas e não podem possuir corpo de execução"*
* **Dica de Correção**: 💡 Remova o corpo da operação ('==> { ... }'); implementações pertencem ao 'agent'

**Exemplo Incorreto:**
```theflux
contract (Servico) {
  op somar(as int64: a) as int64 ==> { emit(nice, a + 1, "ok") }
}
```

**Exemplo Corrigido:**
```theflux
contract (Servico) {
  op somar(as int64: a) as int64
}
```

---

#### `SYN140` — `UNCLOSED_DELIMITER`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_program.yaml`](keywords/KW_program.yaml)
* **Gatilho**: Delimitador '(' ou '{' ou '[' não fechado antes do fim do escopo ou arquivo
* **Mensagem Padrão**: *"Delimitador não fechado: esperado fechamento correspondente ')', '}' ou ']'"*
* **Dica de Correção**: 💡 Feche o delimitador correspondente (')', '}' ou ']') antes do final do bloco

**Exemplo Incorreto:**
```theflux
program (Main {
  print("ola")
}
```

**Exemplo Corrigido:**
```theflux
program (Main) {
  print("ola")
}
```

---

#### `SYN150` — `TENSOR_REQUIRES_SHAPE`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_TYPE_tensor.yaml`](keywords/KW_TYPE_tensor.yaml)
* **Gatilho**: Declaração de tensor sem a especificação das dimensões entre colchetes
* **Mensagem Padrão**: *"Tipo 'tensor' requer especificação das dimensões entre colchetes (ex: 'tensor[3,3] of float64')"*
* **Dica de Correção**: 💡 Especifique as dimensões do tensor entre colchetes (ex: 'tensor[3,3] of float64')

**Exemplo Incorreto:**
```theflux
mut as tensor of float64: t = [1.0, 2.0]
```

**Exemplo Corrigido:**
```theflux
mut as tensor[2] of float64: t = [1.0, 2.0]
```

---

#### `SYN151` — `TENSOR_REQUIRES_OF_TYPE`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_TYPE_tensor.yaml`](keywords/KW_TYPE_tensor.yaml)
* **Gatilho**: Declaração de tensor sem a especificação do tipo dos elementos com 'of <tipo>'
* **Mensagem Padrão**: *"Tipo 'tensor' requer especificação do tipo de elemento com 'of <tipo>'"*
* **Dica de Correção**: 💡 Especifique o tipo numérico dos elementos utilizando 'of <tipo>' (ex: 'tensor[3] of float64')

**Exemplo Incorreto:**
```theflux
mut as tensor[3]: t = [1.0, 2.0, 3.0]
```

**Exemplo Corrigido:**
```theflux
mut as tensor[3] of float64: t = [1.0, 2.0, 3.0]
```

---

#### `SYN160` — `LIST_REQUIRES_OF_TYPE`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_TYPE_list.yaml`](keywords/KW_TYPE_list.yaml)
* **Gatilho**: Declaração de 'list' sem especificar o tipo dos elementos com 'of <tipo>'
* **Mensagem Padrão**: *"Tipo 'list' requer especificação do tipo de elemento com 'of <tipo>'"*
* **Dica de Correção**: 💡 Especifique o tipo dos elementos com 'of <tipo>' (ex: 'list of int64')

**Exemplo Incorreto:**
```theflux
mut as list: xs = [1, 2, 3]
```

**Exemplo Corrigido:**
```theflux
mut as list of int64: xs = [1, 2, 3]
```

---

#### `SYN161` — `SET_REQUIRES_OF_TYPE`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_TYPE_set.yaml`](keywords/KW_TYPE_set.yaml)
* **Gatilho**: Declaração de 'set' sem especificar o tipo dos elementos com 'of <tipo>'
* **Mensagem Padrão**: *"Tipo 'set' requer especificação do tipo de elemento com 'of <tipo>'"*
* **Dica de Correção**: 💡 Especifique o tipo dos elementos com 'of <tipo>' (ex: 'set of string')

**Exemplo Incorreto:**
```theflux
mut as set: s = {"a", "b"}
```

**Exemplo Corrigido:**
```theflux
mut as set of string: s = {"a", "b"}
```

---

### 5.2 Classe 2xx — Módulos e Resolução de Importações (`IMP` 200–299)

*Erros de resolução de módulos `.fdsl`, ciclos de dependência e controle de acesso privado. Total de diagnósticos catalogados: 4.*

#### `IMP201` — `MODULE_NOT_FOUND`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_use.yaml`](keywords/KW_use.yaml)
* **Gatilho**: Módulo ou arquivo .fdsl especificado na cláusula 'use' não encontrado nos caminhos de busca
* **Mensagem Padrão**: *"Módulo ou arquivo .fdsl não encontrado nos diretórios de busca ou stdlib"*
* **Dica de Correção**: 💡 Verifique se o caminho do arquivo .fdsl existe e está no diretório correto ou no FLUX_PATH

**Exemplo Incorreto:**
```theflux
use ModuloInexistente as MI
```

**Exemplo Corrigido:**
```theflux
use MathStdLib as MS
```

---

#### `IMP202` — `CIRCULAR_IMPORT`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_use.yaml`](keywords/KW_use.yaml)
* **Gatilho**: Dependência cíclica detectada entre módulos (A importa B, que importa A)
* **Mensagem Padrão**: *"Dependência cíclica de importação detectada entre módulos .fdsl"*
* **Dica de Correção**: 💡 Quebre a dependência cíclica movendo os tipos comuns para um arquivo agregado mestre

**Exemplo Incorreto:**
```theflux
# ModuloA importa ModuloB e ModuloB importa ModuloA
use ModuloB
```

**Exemplo Corrigido:**
```theflux
use ModuloComum
```

---

#### `IMP203` — `PRIVATE_OP_ACCESS`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_use.yaml`](keywords/KW_use.yaml)
* **Gatilho**: Tentativa de importar ou acessar externamente uma operação privada (iniciada com '_')
* **Mensagem Padrão**: *"Operações iniciadas com '_' são privadas e não podem ser importadas externamente"*
* **Dica de Correção**: 💡 Operações iniciadas com '_' são privadas ao módulo; utilize apenas operações públicas do contrato

**Exemplo Incorreto:**
```theflux
use CalculadoraAgent::_auxiliar as aux
```

**Exemplo Corrigido:**
```theflux
use CalculadoraAgent::somar as somar
```

---

#### `IMP204` — `DUPLICATE_IMPORT_ALIAS`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_use.yaml`](keywords/KW_use.yaml)
* **Gatilho**: Dois ou mais módulos ou operações importados com o mesmo alias no mesmo arquivo
* **Mensagem Padrão**: *"Colisão de identificador: o alias já foi utilizado em outra cláusula de importação"*
* **Dica de Correção**: 💡 Utilize 'use <Modulo> as <NovoAlias>' para evitar colisão de nomes no escopo

**Exemplo Incorreto:**
```theflux
use ModuloA as M
use ModuloB as M
```

**Exemplo Corrigido:**
```theflux
use ModuloA as MA
use ModuloB as MB
```

---

### 5.3 Classe 3xx — Análise Semântica e Escopos (`SEM` 300–399)

*Erros de regras da linguagem, convenções de nomenclatura, escopos e contratos. Total de diagnósticos catalogados: 24.*

#### `SEM301` — `INT_LITERAL_OUT_OF_RANGE`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_TYPE_int.yaml`](keywords/KW_TYPE_int.yaml)
* **Gatilho**: O valor literal numérico excede os limites suportados pela largura do tipo inteiro declarado
* **Mensagem Padrão**: *"Valor literal excede os limites suportados pelo tipo inteiro"*
* **Dica de Correção**: 💡 Utilize um tipo inteiro com maior largura (ex: int64 ou uint64)

**Exemplo Incorreto:**
```theflux
mut as int8: x = 300
```

**Exemplo Corrigido:**
```theflux
mut as int16: x = 300
```

---

#### `SEM303` — `UNDEFINED_IDENTIFIER`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_mut.yaml`](keywords/KW_mut.yaml)
* **Gatilho**: Uso de identificador de variável não declarado no escopo léxico corrente
* **Mensagem Padrão**: *"Identificador não declarado: a variável precisa ser declarada com 'mut' ou 'imut'"*
* **Dica de Correção**: 💡 Declare a variável com 'mut as <tipo>:' ou 'imut as <tipo>:' antes de utilizá-la

**Exemplo Incorreto:**
```theflux
x = 10
```

**Exemplo Corrigido:**
```theflux
mut as int64: x = 10
```

---

#### `SEM304` — `DUPLICATE_IDENTIFIER`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_mut.yaml`](keywords/KW_mut.yaml)
* **Gatilho**: Redeclaração de identificador que já existe no mesmo escopo léxico
* **Mensagem Padrão**: *"Identificador duplicado: a variável já foi declarada anteriormente neste mesmo escopo"*
* **Dica de Correção**: 💡 Renomeie uma das declarações para evitar colisão no mesmo escopo

**Exemplo Incorreto:**
```theflux
mut as int64: total = 1
mut as int64: total = 2
```

**Exemplo Corrigido:**
```theflux
mut as int64: total_inicial = 1
mut as int64: total_final = 2
```

---

#### `SEM305` — `IMMUT_REQUIRES_INITIALIZER`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_imut.yaml`](keywords/KW_imut.yaml)
* **Gatilho**: Declaração de constante imutável sem expressão de valor inicial
* **Mensagem Padrão**: *"Declaração de identificador 'imut' exige valor de inicialização obrigatório"*
* **Dica de Correção**: 💡 Forneça o valor inicial na declaração (ex: 'imut as int64: LIMITE = 100')

**Exemplo Incorreto:**
```theflux
imut as int64: LIMITE
```

**Exemplo Corrigido:**
```theflux
imut as int64: LIMITE = 100
```

---

#### `SEM306` — `MUT_IDENTIFIER_SNAKE_CASE`
* **Severidade**: `Warning`
* **Arquivo Fonte**: [`KW_mut.yaml`](keywords/KW_mut.yaml)
* **Gatilho**: Identificador mutável declarado fora da convenção snake_case
* **Mensagem Padrão**: *"Identificador mutável ('mut') deve utilizar a convenção snake_case"*
* **Dica de Correção**: 💡 Renomeie o identificador para letras minúsculas separadas por sublinhado (ex: 'contador_total')

**Exemplo Incorreto:**
```theflux
mut as int64: contadorTotal = 0
```

**Exemplo Corrigido:**
```theflux
mut as int64: contador_total = 0
```

---

#### `SEM307` — `IMMUT_IDENTIFIER_SCREAMING_SNAKE`
* **Severidade**: `Warning`
* **Arquivo Fonte**: [`KW_imut.yaml`](keywords/KW_imut.yaml)
* **Gatilho**: Nome de constante 'imut' declarado fora do padrão SCREAMING_SNAKE_CASE
* **Mensagem Padrão**: *"Identificador imutável ('imut') deve utilizar a convenção SCREAMING_SNAKE_CASE"*
* **Dica de Correção**: 💡 Renomeie o identificador para letras maiúsculas separadas por sublinhado (ex: 'VALOR_MAXIMO')

**Exemplo Incorreto:**
```theflux
imut as int64: maxValor = 50
```

**Exemplo Corrigido:**
```theflux
imut as int64: MAX_VALOR = 50
```

---

#### `SEM310` — `PROGRAM_NAME_PASCAL_CASE`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_program.yaml`](keywords/KW_program.yaml)
* **Gatilho**: Nome de 'program' declarado fora da convenção PascalCase
* **Mensagem Padrão**: *"Nome de 'program' deve utilizar a convenção PascalCase"*
* **Dica de Correção**: 💡 Renomeie o programa para iniciar com letra maiúscula (ex: 'program (Main)')

**Exemplo Incorreto:**
```theflux
program (meuPrograma) { }
```

**Exemplo Corrigido:**
```theflux
program (MeuPrograma) { }
```

---

#### `SEM311` — `PROGRAM_PROHIBITED_IN_FDSL`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_program.yaml`](keywords/KW_program.yaml)
* **Gatilho**: Declaração de 'program' dentro de arquivo de biblioteca (.fdsl)
* **Mensagem Padrão**: *"Declaração de 'program' é proibida em arquivos .fdsl"*
* **Dica de Correção**: 💡 Arquivos .fdsl devem conter apenas bibliotecas, contratos e agentes

**Exemplo Incorreto:**
```theflux
# Em MinhaLib.fdsl
program (Main) { }
```

**Exemplo Corrigido:**
```theflux
# Em MinhaLib.fdsl
agent (MinhaLib) { }
```

---

#### `SEM312` — `PROGRAM_MISSING_IN_FLUX`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_program.yaml`](keywords/KW_program.yaml)
* **Gatilho**: Arquivo executável (.flux) sem a declaração obrigatória 'program'
* **Mensagem Padrão**: *"Arquivo .flux requer declaração do ponto de entrada 'program (<Nome>) { ... }'"*
* **Dica de Correção**: 💡 Adicione o bloco 'program (<Nome>) { ... }' ao final do arquivo .flux

**Exemplo Incorreto:**
```theflux
# Arquivo sem bloco program
print("ola")
```

**Exemplo Corrigido:**
```theflux
program (Main) {
  print("ola")
}
```

---

#### `SEM320` — `ROUTE_WILDCARD_NOT_LAST`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_route.yaml`](keywords/KW_route.yaml)
* **Gatilho**: Braço padrão coringa ('_') posicionado antes de outros braços condicionais no bloco 'route'
* **Mensagem Padrão**: *"O braço coringa padrão ('_') deve ser obrigatoriamente o último braço no bloco 'route'"*
* **Dica de Correção**: 💡 Mova o braço '_ ==> { ... }' para o final do bloco 'route'

**Exemplo Incorreto:**
```theflux
route {
  _ ==> { print("fallback") }
  x == 1 ==> { print("um") }
}
```

**Exemplo Corrigido:**
```theflux
route {
  x == 1 ==> { print("um") }
  _ ==> { print("fallback") }
}
```

---

#### `SEM330` — `CONTRACT_NAME_PASCAL_CASE`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_contract.yaml`](keywords/KW_contract.yaml)
* **Gatilho**: Nome de contrato declarado fora da convenção PascalCase
* **Mensagem Padrão**: *"Nome de contrato deve utilizar a convenção PascalCase"*
* **Dica de Correção**: 💡 Renomeie o contrato para iniciar com letra maiúscula (ex: 'CalculadoraContract')

**Exemplo Incorreto:**
```theflux
contract (meuContrato) {
  op executar() as int64
}
```

**Exemplo Corrigido:**
```theflux
contract (MeuContrato) {
  op executar() as int64
}
```

---

#### `SEM331` — `CONTRACT_OP_CAMEL_CASE`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_contract.yaml`](keywords/KW_contract.yaml)
* **Gatilho**: Nome de operação em contrato declarado fora da convenção camelCase
* **Mensagem Padrão**: *"Operação de contrato deve utilizar a convenção camelCase"*
* **Dica de Correção**: 💡 Renomeie a operação para iniciar com letra minúscula (ex: 'calcularTotal')

**Exemplo Incorreto:**
```theflux
contract (Processador) {
  op ExecutarTarefa() as bool
}
```

**Exemplo Corrigido:**
```theflux
contract (Processador) {
  op executarTarefa() as bool
}
```

---

#### `SEM340` — `AGENT_MISSING_CONTRACT_OP`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_agent.yaml`](keywords/KW_agent.yaml)
* **Gatilho**: O agente declara implementar um contrato ('impl'), mas deixa de implementar uma ou mais operações requeridas
* **Mensagem Padrão**: *"O agente não implementou todas as operações exigidas pelo contrato"*
* **Dica de Correção**: 💡 Implemente todas as operações definidas no contrato ou revise a cláusula 'impl'

**Exemplo Incorreto:**
```theflux
contract (Calculadora) { op somar(as int64: a) as int64 }
agent (MeuAgente) impl Calculadora { }
```

**Exemplo Corrigido:**
```theflux
contract (Calculadora) { op somar(as int64: a) as int64 }
agent (MeuAgente) impl Calculadora {
  op somar(as int64: a) as int64 ==> { emit(nice, a, "ok") }
}
```

---

#### `SEM341` — `AGENT_NAME_PASCAL_CASE`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_agent.yaml`](keywords/KW_agent.yaml)
* **Gatilho**: Nome de agente declarado fora da convenção PascalCase
* **Mensagem Padrão**: *"Nome de agente deve utilizar a convenção PascalCase"*
* **Dica de Correção**: 💡 Renomeie o agente para iniciar com letra maiúscula (ex: 'CompressStdLib')

**Exemplo Incorreto:**
```theflux
agent (meuAgente) { }
```

**Exemplo Corrigido:**
```theflux
agent (MeuAgente) { }
```

---

#### `SEM342` — `AGENT_PROHIBITED_IN_FLUX_FILE`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_agent.yaml`](keywords/KW_agent.yaml)
* **Gatilho**: Declaração de 'agent' dentro de arquivo com extensão .flux
* **Mensagem Padrão**: *"Declaração de 'agent' é permitida exclusivamente em arquivos de biblioteca (.fdsl)"*
* **Dica de Correção**: 💡 Mova a declaração do agente para um arquivo '.fdsl' e importe-o no '.flux' via 'use'

**Exemplo Incorreto:**
```theflux
# Em main.flux
agent (MeuAgente) { }
```

**Exemplo Corrigido:**
```theflux
# Em modulo.fdsl: agent (MeuAgente) { ... }
# Em main.flux: use MeuAgente
```

---

#### `SEM350` — `EMIT_INVALID_CHANNEL`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_emit.yaml`](keywords/KW_emit.yaml)
* **Gatilho**: Uso de canal ou status de retorno diferente de 'nice' ou 'fail' na instrução 'emit'
* **Mensagem Padrão**: *"Canal de emissão inválido: 'emit' aceita exclusivamente os status 'nice' ou 'fail'"*
* **Dica de Correção**: 💡 Altere o primeiro argumento para 'nice' (sucesso) ou 'fail' (falha)

**Exemplo Incorreto:**
```theflux
emit(ok, resultado, "sucesso")
```

**Exemplo Corrigido:**
```theflux
emit(nice, resultado, "sucesso")
```

---

#### `SEM351` — `EMIT_NON_TERMINAL_STATEMENT`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_emit.yaml`](keywords/KW_emit.yaml)
* **Gatilho**: Existência de instruções executáveis após a instrução 'emit' dentro do mesmo bloco
* **Mensagem Padrão**: *"Código inalcançável detectado: 'emit' encerra a execução da função/operação e deve ser a última instrução"*
* **Dica de Correção**: 💡 Remova ou reorganize o código posicionado após o 'emit'

**Exemplo Incorreto:**
```theflux
emit(nice, total, "fim")
print("depois do emit")
```

**Exemplo Corrigido:**
```theflux
print("antes do emit")
emit(nice, total, "fim")
```

---

#### `SEM360` — `STRUCT_NAME_PASCAL_CASE`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_struct.yaml`](keywords/KW_struct.yaml)
* **Gatilho**: Nome de struct declarado fora da convenção PascalCase
* **Mensagem Padrão**: *"Nome de tipo 'struct' deve utilizar a convenção PascalCase"*
* **Dica de Correção**: 💡 Renomeie a struct para iniciar com letra maiúscula (ex: 'struct (Usuario)')

**Exemplo Incorreto:**
```theflux
struct (usuario) {
  mut: .nome: string
}
```

**Exemplo Corrigido:**
```theflux
struct (Usuario) {
  mut: .nome: string
}
```

---

#### `SEM361` — `STRUCT_UNKNOWN_FIELD`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_struct.yaml`](keywords/KW_struct.yaml)
* **Gatilho**: Acesso ou atribuição a campo não existente na definição da struct
* **Mensagem Padrão**: *"Campo não encontrado na estrutura"*
* **Dica de Correção**: 💡 Verifique o nome dos campos definidos na struct correspondente

**Exemplo Incorreto:**
```theflux
print(evento.naame)
```

**Exemplo Corrigido:**
```theflux
print(evento.nome)
```

---

#### `SEM362` — `STRUCT_MUTABLE_FIELD_SNAKE_CASE`
* **Severidade**: `Warning`
* **Arquivo Fonte**: [`KW_struct.yaml`](keywords/KW_struct.yaml)
* **Gatilho**: Campo mutável de struct declarado fora da convenção snake_case
* **Mensagem Padrão**: *"Campo mutável de struct deve utilizar a convenção snake_case"*
* **Dica de Correção**: 💡 Renomeie o campo para minúsculas separadas por sublinhado (ex: '.meu_campo')

**Exemplo Incorreto:**
```theflux
struct (Config) {
  mut: .meuCampo: int64
}
```

**Exemplo Corrigido:**
```theflux
struct (Config) {
  mut: .meu_campo: int64
}
```

---

#### `SEM363` — `STRUCT_IMMUTABLE_FIELD_SCREAMING_SNAKE`
* **Severidade**: `Warning`
* **Arquivo Fonte**: [`KW_struct.yaml`](keywords/KW_struct.yaml)
* **Gatilho**: Campo imutável de struct declarado fora da convenção SCREAMING_SNAKE_CASE
* **Mensagem Padrão**: *"Campo imutável de struct deve utilizar a convenção SCREAMING_SNAKE_CASE"*
* **Dica de Correção**: 💡 Renomeie o campo para letras maiúsculas separadas por sublinhado (ex: '.ID_UNICO')

**Exemplo Incorreto:**
```theflux
struct (Config) {
  imut: .idUnico: int64
}
```

**Exemplo Corrigido:**
```theflux
struct (Config) {
  imut: .ID_UNICO: int64
}
```

---

#### `SEM370` — `ENUM_NAME_PASCAL_CASE`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_enum.yaml`](keywords/KW_enum.yaml)
* **Gatilho**: Nome de enum declarado fora da convenção PascalCase
* **Mensagem Padrão**: *"Nome de enum deve utilizar a convenção PascalCase"*
* **Dica de Correção**: 💡 Renomeie o enum para iniciar com letra maiúscula (ex: 'enum (Status)')

**Exemplo Incorreto:**
```theflux
enum (status) {
  Ativo
}
```

**Exemplo Corrigido:**
```theflux
enum (Status) {
  Ativo
}
```

---

#### `SEM371` — `ENUM_UNKNOWN_VARIANT`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_enum.yaml`](keywords/KW_enum.yaml)
* **Gatilho**: Tentativa de acessar uma variante não declarada no enum correspondente
* **Mensagem Padrão**: *"Variante não encontrada na definição do enum"*
* **Dica de Correção**: 💡 Verifique as variantes declaradas no enum correspondente

**Exemplo Incorreto:**
```theflux
mut as Status: s = Status::Pendente
```

**Exemplo Corrigido:**
```theflux
mut as Status: s = Status::Aberto
```

---

#### `SEM372` — `ENUM_VARIANT_PASCAL_CASE`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_enum.yaml`](keywords/KW_enum.yaml)
* **Gatilho**: Nome de variante de enum declarado fora da convenção PascalCase
* **Mensagem Padrão**: *"Nome da variante de enum deve utilizar a convenção PascalCase"*
* **Dica de Correção**: 💡 Renomeie a variante para iniciar com letra maiúscula (ex: 'Ativo' ou 'Fechado')

**Exemplo Incorreto:**
```theflux
enum (Status) {
  ativo
}
```

**Exemplo Corrigido:**
```theflux
enum (Status) {
  Ativo
}
```

---

### 5.4 Classe 4xx — Sistema de Tipos e Tipagem Estática (`TYP` 400–499)

*Erros de incompatibilidade direcional de tipos estáticos, coerções e retornos. Total de diagnósticos catalogados: 20.*

#### `TYP401` — `EXPECT_INT_GOT_FLOAT`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_TYPE_int.yaml`](keywords/KW_TYPE_int.yaml)
* **Gatilho**: Uma variável ou parâmetro declarado como inteiro (int8..uint64) recebe um número de ponto flutuante
* **Mensagem Padrão**: *"A variável esperava um inteiro e recebeu um número decimal (float)"*
* **Dica de Correção**: 💡 Use 'trunc()' ou 'round()' para converter explicitamente o valor decimal para inteiro

**Exemplo Incorreto:**
```theflux
mut as int64: x = 3.14
```

**Exemplo Corrigido:**
```theflux
mut as int64: x = trunc(3.14)
```

---

#### `TYP402` — `EXPECT_INT_GOT_COMPLEX`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_TYPE_int.yaml`](keywords/KW_TYPE_int.yaml)
* **Gatilho**: Uma variável ou parâmetro do tipo inteiro recebe um número complexo
* **Mensagem Padrão**: *"A variável esperava um inteiro e recebeu um número complexo"*
* **Dica de Correção**: 💡 Números complexos possuem partes real e imaginária. Extraia a parte desejada (.real) antes de converter

**Exemplo Incorreto:**
```theflux
mut as int64: x = 1 + 2i
```

**Exemplo Corrigido:**
```theflux
mut as int64: x = trunc((1 + 2i).real)
```

---

#### `TYP403` — `EXPECT_INT_GOT_STRING`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_TYPE_int.yaml`](keywords/KW_TYPE_int.yaml)
* **Gatilho**: Uma variável ou parâmetro do tipo inteiro recebe uma string
* **Mensagem Padrão**: *"A variável esperava um inteiro e recebeu um texto (string)"*
* **Dica de Correção**: 💡 Use 'parse_int()' para converter a string em inteiro

**Exemplo Incorreto:**
```theflux
mut as int64: x = "42"
```

**Exemplo Corrigido:**
```theflux
mut as int64: x = parse_int("42")
```

---

#### `TYP404` — `EXPECT_INT_GOT_BOOL`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_TYPE_int.yaml`](keywords/KW_TYPE_int.yaml)
* **Gatilho**: Uma variável ou parâmetro do tipo inteiro recebe um booleano
* **Mensagem Padrão**: *"A variável esperava um inteiro e recebeu um booleano (bool)"*
* **Dica de Correção**: 💡 Use 'as int64' para conversão explícita de bool para inteiro

**Exemplo Incorreto:**
```theflux
mut as int64: x = true
```

**Exemplo Corrigido:**
```theflux
mut as int64: x = true as int64
```

---

#### `TYP411` — `EXPECT_COMPLEX_GOT_INT`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_TYPE_complex.yaml`](keywords/KW_TYPE_complex.yaml)
* **Gatilho**: Uma variável ou parâmetro do tipo complexo recebe um valor inteiro puro
* **Mensagem Padrão**: *"A variável esperava um número complexo e recebeu um número inteiro"*
* **Dica de Correção**: 💡 Adicione a parte imaginária explicitamente (ex: '+ 0i') ou use construtor complexo

**Exemplo Incorreto:**
```theflux
mut as complex128: c = 42
```

**Exemplo Corrigido:**
```theflux
mut as complex128: c = 42 + 0i
```

---

#### `TYP412` — `EXPECT_COMPLEX_GOT_FLOAT`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_TYPE_complex.yaml`](keywords/KW_TYPE_complex.yaml)
* **Gatilho**: Uma variável ou parâmetro do tipo complexo recebe um número decimal puro (float)
* **Mensagem Padrão**: *"A variável esperava um número complexo e recebeu um número decimal (float)"*
* **Dica de Correção**: 💡 Adicione a parte imaginária explicitamente (ex: '+ 0.0i')

**Exemplo Incorreto:**
```theflux
mut as complex128: c = 3.14
```

**Exemplo Corrigido:**
```theflux
mut as complex128: c = 3.14 + 0.0i
```

---

#### `TYP413` — `EXPECT_COMPLEX_GOT_STRING`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_TYPE_complex.yaml`](keywords/KW_TYPE_complex.yaml)
* **Gatilho**: Uma variável ou parâmetro do tipo complexo recebe uma string
* **Mensagem Padrão**: *"A variável esperava um número complexo e recebeu texto (string)"*
* **Dica de Correção**: 💡 Converta a string para complexo utilizando função de parsing apropriada

**Exemplo Incorreto:**
```theflux
mut as complex128: c = "1+2i"
```

**Exemplo Corrigido:**
```theflux
mut as complex128: c = parse_complex("1+2i")
```

---

#### `TYP414` — `EXPECT_COMPLEX_GOT_BOOL`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_TYPE_complex.yaml`](keywords/KW_TYPE_complex.yaml)
* **Gatilho**: Uma variável ou parâmetro do tipo complexo recebe um valor booleano
* **Mensagem Padrão**: *"A variável esperava um número complexo e recebeu um booleano (bool)"*
* **Dica de Correção**: 💡 Booleano não pode ser convertido diretamente para número complexo

**Exemplo Incorreto:**
```theflux
mut as complex128: c = true
```

**Exemplo Corrigido:**
```theflux
mut as complex128: c = (true as int64) + 0i
```

---

#### `TYP421` — `EXPECT_FLOAT_GOT_COMPLEX`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_TYPE_float.yaml`](keywords/KW_TYPE_float.yaml)
* **Gatilho**: Uma variável ou parâmetro do tipo float recebe um número complexo
* **Mensagem Padrão**: *"A variável esperava um número decimal (float) e recebeu um número complexo"*
* **Dica de Correção**: 💡 Obtenha a parte real com '.real' ou a magnitude com 'abs()'

**Exemplo Incorreto:**
```theflux
mut as float64: f = 1.5 + 2.0i
```

**Exemplo Corrigido:**
```theflux
mut as float64: f = (1.5 + 2.0i).real
```

---

#### `TYP422` — `EXPECT_FLOAT_GOT_STRING`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_TYPE_float.yaml`](keywords/KW_TYPE_float.yaml)
* **Gatilho**: Uma variável ou parâmetro do tipo float recebe uma string
* **Mensagem Padrão**: *"A variável esperava um número decimal (float) e recebeu texto (string)"*
* **Dica de Correção**: 💡 Use 'parse_float()' para converter a string em número decimal

**Exemplo Incorreto:**
```theflux
mut as float64: f = "3.14159"
```

**Exemplo Corrigido:**
```theflux
mut as float64: f = parse_float("3.14159")
```

---

#### `TYP423` — `EXPECT_FLOAT_GOT_BOOL`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_TYPE_float.yaml`](keywords/KW_TYPE_float.yaml)
* **Gatilho**: Uma variável ou parâmetro do tipo float recebe um booleano
* **Mensagem Padrão**: *"A variável esperava um número decimal (float) e recebeu um booleano (bool)"*
* **Dica de Correção**: 💡 Booleano não pode ser atribuído a float diretamente; use 'as int64 as float64' para conversão explícita

**Exemplo Incorreto:**
```theflux
mut as float64: f = true
```

**Exemplo Corrigido:**
```theflux
mut as float64: f = 1.0
```

---

#### `TYP431` — `EXPECT_STRING_GOT_INT`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_TYPE_string.yaml`](keywords/KW_TYPE_string.yaml)
* **Gatilho**: Uma variável ou parâmetro do tipo string recebe um número inteiro
* **Mensagem Padrão**: *"A variável esperava texto (string) e recebeu um número inteiro"*
* **Dica de Correção**: 💡 Use interpolação "$(x)" ou função de conversão para formatar o inteiro como texto

**Exemplo Incorreto:**
```theflux
mut as string: s = 42
```

**Exemplo Corrigido:**
```theflux
mut as string: s = "$(42)"
```

---

#### `TYP432` — `EXPECT_STRING_GOT_FLOAT`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_TYPE_string.yaml`](keywords/KW_TYPE_string.yaml)
* **Gatilho**: Uma variável ou parâmetro do tipo string recebe um número decimal
* **Mensagem Padrão**: *"A variável esperava texto (string) e recebeu um número decimal (float)"*
* **Dica de Correção**: 💡 Use interpolação "$(x)" para formatar o número decimal como texto

**Exemplo Incorreto:**
```theflux
mut as string: s = 3.14
```

**Exemplo Corrigido:**
```theflux
mut as string: s = "$(3.14)"
```

---

#### `TYP433` — `EXPECT_STRING_GOT_COMPLEX`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_TYPE_string.yaml`](keywords/KW_TYPE_string.yaml)
* **Gatilho**: Uma variável ou parâmetro do tipo string recebe um número complexo
* **Mensagem Padrão**: *"A variável esperava texto (string) e recebeu um número complexo"*
* **Dica de Correção**: 💡 Use interpolação "$(c)" para formatar o número complexo como texto

**Exemplo Incorreto:**
```theflux
mut as string: s = 1 + 2i
```

**Exemplo Corrigido:**
```theflux
mut as string: s = "$(1 + 2i)"
```

---

#### `TYP434` — `EXPECT_STRING_GOT_BOOL`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_TYPE_string.yaml`](keywords/KW_TYPE_string.yaml)
* **Gatilho**: Uma variável ou parâmetro do tipo string recebe um valor booleano
* **Mensagem Padrão**: *"A variável esperava texto (string) e recebeu um booleano (bool)"*
* **Dica de Correção**: 💡 Use interpolação "$(b)" para converter o booleano em texto ('true'/'false')

**Exemplo Incorreto:**
```theflux
mut as string: s = true
```

**Exemplo Corrigido:**
```theflux
mut as string: s = "$(true)"
```

---

#### `TYP441` — `EXPECT_BOOL_GOT_INT`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_LITERAL_bool.yaml`](keywords/KW_LITERAL_bool.yaml)
* **Gatilho**: Uma variável ou expressão condicional booleana recebe um número inteiro
* **Mensagem Padrão**: *"A expressão esperava um booleano (bool) e recebeu um número inteiro"*
* **Dica de Correção**: 💡 Compare explicitamente o inteiro contra zero (ex: 'x != 0') ou converta com cast

**Exemplo Incorreto:**
```theflux
mut as bool: b = 1
```

**Exemplo Corrigido:**
```theflux
mut as bool: b = (1 != 0)
```

---

#### `TYP442` — `EXPECT_BOOL_GOT_STRING`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_LITERAL_bool.yaml`](keywords/KW_LITERAL_bool.yaml)
* **Gatilho**: Uma variável ou expressão condicional booleana recebe uma string
* **Mensagem Padrão**: *"A expressão esperava um booleano (bool) e recebeu texto (string)"*
* **Dica de Correção**: 💡 Compare o texto explicitamente (ex: 's == "True"')

**Exemplo Incorreto:**
```theflux
mut as bool: b = "True"
```

**Exemplo Corrigido:**
```theflux
mut as bool: b = ("True" == "True")
```

---

#### `TYP443` — `EXPECT_BOOL_GOT_FLOAT`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_LITERAL_bool.yaml`](keywords/KW_LITERAL_bool.yaml)
* **Gatilho**: Uma variável ou expressão condicional booleana recebe um número decimal
* **Mensagem Padrão**: *"A expressão esperava um booleano (bool) e recebeu um número decimal (float)"*
* **Dica de Correção**: 💡 Compare explicitamente o decimal contra zero (ex: 'f != 0.0')

**Exemplo Incorreto:**
```theflux
mut as bool: b = 0.0
```

**Exemplo Corrigido:**
```theflux
mut as bool: b = (0.0 != 0.0)
```

---

#### `TYP450` — `EMIT_RETURN_TYPE_MISMATCH`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_emit.yaml`](keywords/KW_emit.yaml)
* **Gatilho**: O tipo do valor emitido não coincide com o tipo de retorno declarado na assinatura da função ou contrato
* **Mensagem Padrão**: *"Tipo de valor emitido diverge do tipo de retorno especificado na assinatura"*
* **Dica de Correção**: 💡 Garanta que a variável emitida possua o mesmo tipo declarado em 'as <tipo_retorno>'

**Exemplo Incorreto:**
```theflux
op calcular() as int64 ==> {
  mut as string: txt = "42"
  emit(nice, txt, "ok")
}
```

**Exemplo Corrigido:**
```theflux
op calcular() as int64 ==> {
  mut as int64: num = 42
  emit(nice, num, "ok")
}
```

---

#### `TYP499` — `TYPE_MISMATCH_GENERIC`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_program.yaml`](keywords/KW_program.yaml)
* **Gatilho**: Incompatibilidade de tipos genérica sem mapeamento direcional específico
* **Mensagem Padrão**: *"Incompatibilidade de tipos: os tipos esperados e fornecidos não são compatíveis"*
* **Dica de Correção**: 💡 Verifique a compatibilidade dos tipos ou utilize conversão explícita com 'as <tipo>'

**Exemplo Incorreto:**
```theflux
mut as int64: x = (1 > 0)
```

**Exemplo Corrigido:**
```theflux
mut as int64: x = 1
```

---

### 5.5 Classe 5xx — Posse de Memória (Ownership) e Mutabilidade (`OWN` 500–599)

*Erros de ciclo de vida de memória, reatribuição imutável, uso pós-movimentação e coleções. Total de diagnósticos catalogados: 5.*

#### `OWN501` — `CANNOT_MUTATE_IMMUTABLE`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_imut.yaml`](keywords/KW_imut.yaml)
* **Gatilho**: Tentativa de reatribuir ou modificar uma variável declarada como imutável ('imut')
* **Mensagem Padrão**: *"Não é permitido alterar o valor de um identificador imutável ('imut')"*
* **Dica de Correção**: 💡 Declare a variável com 'mut as <tipo>:' se ela precisar ter seu valor modificado

**Exemplo Incorreto:**
```theflux
imut as int64: TOTAL = 10
TOTAL = 20
```

**Exemplo Corrigido:**
```theflux
mut as int64: total = 10
total = 20
```

---

#### `OWN502` — `CANNOT_MUTATE_IMMUT_FIELD`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_imut.yaml`](keywords/KW_imut.yaml)
* **Gatilho**: Tentativa de modificar um campo de struct marcado como 'imut:'
* **Mensagem Padrão**: *"Campo de estrutura é imutável e não pode ser reatribuído"*
* **Dica de Correção**: 💡 Marque o campo como 'mut: .campo: tipo' na definição da struct se precisar modificá-lo

**Exemplo Incorreto:**
```theflux
user.ID = 99
```

**Exemplo Corrigido:**
```theflux
user.name = "novo_nome"
```

---

#### `OWN503` — `USE_AFTER_MOVE`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_borrow.yaml`](keywords/KW_borrow.yaml)
* **Gatilho**: Tentativa de acessar uma variável após sua posse (ownership) ter sido transferida via 'move'
* **Mensagem Padrão**: *"Uso inválido de valor movido: a variável já transferiu sua posse e não pode mais ser lida"*
* **Dica de Correção**: 💡 Utilize 'borrow' para leitura compartilhada sem consumir a propriedade do símbolo

**Exemplo Incorreto:**
```theflux
mut as string: a = "dado"
mut as string: b = move(a)
print(a)
```

**Exemplo Corrigido:**
```theflux
mut as string: a = "dado"
mut as string: b = borrow(a)
print(a)
```

---

#### `OWN504` — `MUTABLE_BORROW_CONFLICT`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_borrow.yaml`](keywords/KW_borrow.yaml)
* **Gatilho**: Tentativa de criar empréstimo mútuo ou leitura concorrente enquanto um 'borrow_mut' estiver ativo
* **Mensagem Padrão**: *"Conflito de empréstimo: não é permitido acessar ou emprestar variável enquanto houver borrow_mut ativo"*
* **Dica de Correção**: 💡 Aguarde o fechamento do escopo do empréstimo mutável antes de acessar a variável novamente

**Exemplo Incorreto:**
```theflux
mut as int64: x = 10
mut as int64: r1 = borrow_mut(x)
mut as int64: r2 = borrow(x)
```

**Exemplo Corrigido:**
```theflux
mut as int64: x = 10
mut as int64: r1 = borrow(x)
mut as int64: r2 = borrow(x)
```

---

#### `OWN505` — `COLLECTION_CANNOT_BE_IMMUTABLE`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_TYPE_list.yaml`](keywords/KW_TYPE_list.yaml)
* **Gatilho**: Tentativa de declarar coleção dinâmica ('list' ou 'set') como imutável ('imut')
* **Mensagem Padrão**: *"Coleções dinâmicas não podem ser imutáveis ('imut'); utilize 'mut as list of <tipo>:'"*
* **Dica de Correção**: 💡 Tipos list e set não podem ser imutáveis; declare utilizando 'mut as <tipo>:'

**Exemplo Incorreto:**
```theflux
imut as list of int64: XS = [1, 2, 3]
```

**Exemplo Corrigido:**
```theflux
mut as list of int64: xs = [1, 2, 3]
```

---

### 5.6 Classe 6xx — Concorrência, Atores e Máquinas de Estado (FSM) (`CON` 600–699)

*Erros de concorrência, transições de estado na FSM e mailboxes de atores. Total de diagnósticos catalogados: 3.*

#### `CON601` — `FSM_INVALID_STATE_TRANSITION`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_spawn.yaml`](keywords/KW_spawn.yaml)
* **Gatilho**: Tentativa de transição para estado inválido ou não mapeado na FSM
* **Mensagem Padrão**: *"Transição de estado inválida: o estado de destino não é permitido a partir do estado atual"*
* **Dica de Correção**: 💡 Verifique a tabela de transições válidas definida na máquina de estados (FSM)

**Exemplo Incorreto:**
```theflux
# Transição direta de Inicializado para Finalizado sem passar por Executando
```

**Exemplo Corrigido:**
```theflux
# Seguir o ciclo de vida: Inicializado -> Executando -> Finalizado
```

---

#### `CON602` — `CHANNEL_SEND_ON_CLOSED`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_spawn.yaml`](keywords/KW_spawn.yaml)
* **Gatilho**: Tentativa de enviar mensagem através de um canal que já foi encerrado
* **Mensagem Padrão**: *"Tentativa de envio em canal fechado: o canal não aceita mais mensagens"*
* **Dica de Correção**: 💡 Verifique se o canal ainda está ativo antes de enviar mensagens ('route { channelIsClosed(ch) ==> ... }')

**Exemplo Incorreto:**
```theflux
channelClose(ch)
channelSend(ch, "mensagem")
```

**Exemplo Corrigido:**
```theflux
channelSend(ch, "mensagem")
channelClose(ch)
```

---

#### `CON603` — `AGENT_MAILBOX_OVERFLOW`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_agent.yaml`](keywords/KW_agent.yaml)
* **Gatilho**: Caixa de mensagens do agente atinge capacidade máxima sem consumo
* **Mensagem Padrão**: *"Estouro da caixa postal do agente: capacidade máxima de mensagens pendentes excedida"*
* **Dica de Correção**: 💡 Processe mensagens pendentes do agente ou aumente a capacidade da caixa postal

**Exemplo Incorreto:**
```theflux
# Envio em loop infinito sem que o agente processe mensagens
```

**Exemplo Corrigido:**
```theflux
# Processar mensagens ou consumir a fila do agente
```

---

### 5.7 Classe 7xx — Tempo de Execução Nativa (Runtime) (`RT` 700–799)

*Erros e exceções geradas pelo motor nativo de execução em tempo de runtime. Total de diagnósticos catalogados: 9.*

#### `RT701` — `DIVISION_BY_ZERO`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_OP_arithmetic.yaml`](keywords/KW_OP_arithmetic.yaml)
* **Gatilho**: Tentativa de divisão (/i ou /f) ou resto (/r) onde o divisor é zero
* **Mensagem Padrão**: *"Divisão por zero em tempo de execução"*
* **Dica de Correção**: 💡 Adicione uma verificação condicional ('route { divisor == 0 ==> ... }') antes da operação de divisão

**Exemplo Incorreto:**
```theflux
mut as int64: x = 10 /i 0
```

**Exemplo Corrigido:**
```theflux
route {
  divisor == 0 ==> { print("erro: zero") }
  _ ==> { mut as int64: x = 10 /i divisor }
}
```

---

#### `RT702` — `INDEX_OUT_OF_BOUNDS`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_TYPE_list.yaml`](keywords/KW_TYPE_list.yaml)
* **Gatilho**: Acesso a índice menor que 1 ou maior que o comprimento da lista/tensor
* **Mensagem Padrão**: *"Índice fora dos limites da coleção (indexação 1-based)"*
* **Dica de Correção**: 💡 Lembre-se: TheFlux adota indexação 1-based (1..N). Verifique se o índice está dentro da faixa válida

**Exemplo Incorreto:**
```theflux
mut as list of int64: xs = [10, 20]
print(xs[3])
```

**Exemplo Corrigido:**
```theflux
mut as list of int64: xs = [10, 20]
print(xs[2])
```

---

#### `RT703` — `DECOMPRESS_QUOTA_EXCEEDED`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_keep.yaml`](keywords/KW_keep.yaml)
* **Gatilho**: Tentativa de descompressão ou leitura de payload que excede a cota máxima permitida em memória
* **Mensagem Padrão**: *"Cota de descompressão excedida em tempo de execução (limite de segurança violado)"*
* **Dica de Correção**: 💡 Aumente a cota em 'DecompressQuota.max_bytes' ou revise a integridade dos dados comprimidos

**Exemplo Incorreto:**
```theflux
# Leitura de payload comprimido excedendo cota de segurança
```

**Exemplo Corrigido:**
```theflux
# Ajustar a cota de segurança antes de descomprimir
```

---

#### `RT704` — `STACK_OVERFLOW`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_infinite.yaml`](keywords/KW_infinite.yaml)
* **Gatilho**: Profundidade excessiva de chamadas de funções recursivas sem caso base
* **Mensagem Padrão**: *"Estouro da pilha de execução (Stack Overflow): recursão excessiva sem condição de término"*
* **Dica de Correção**: 💡 Transforme chamadas recursivas profundas em loops de iteração infinita ('infinite')

**Exemplo Incorreto:**
```theflux
function recursaoInfinita() {
  recursaoInfinita()
}
```

**Exemplo Corrigido:**
```theflux
infinite {
  # Loop iterativo sem consumir pilha de chamadas
  break
}
```

---

#### `RT705` — `OUT_OF_MEMORY`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_TYPE_tensor.yaml`](keywords/KW_TYPE_tensor.yaml)
* **Gatilho**: Falha na alocação de memória do heap para tensores, buffers ou objetos grandes
* **Mensagem Padrão**: *"Memória insuficiente para alocação do objeto em tempo de execução"*
* **Dica de Correção**: 💡 Otimize alocações de tensores/buffers ou aumente a memória disponível para o processo

**Exemplo Incorreto:**
```theflux
# Tentativa de alocar tensor com dimensões astronômicas
mut as tensor[1000000, 1000000] of float64: t
```

**Exemplo Corrigido:**
```theflux
mut as tensor[1000, 1000] of float64: t
```

---

#### `RT706` — `MATH_DOMAIN_LOG`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_OP_arithmetic.yaml`](keywords/KW_OP_arithmetic.yaml)
* **Gatilho**: Cálculo de logaritmo (log64, log10_64, log2_64) onde o argumento é menor ou igual a zero
* **Mensagem Padrão**: *"Argumento fora do domínio de logaritmo: esperado x > 0"*
* **Dica de Correção**: 💡 Assegure que o valor passado para o logaritmo seja estritamente positivo (x > 0.0)

**Exemplo Incorreto:**
```theflux
use MathStdLib as M
mut as float64: l = log64(0.0)
```

**Exemplo Corrigido:**
```theflux
use MathStdLib as M
route {
  x <= 0.0 ==> { print("invalido") }
  _ ==> { mut as float64: l = log64(x) }
}
```

---

#### `RT707` — `MATH_DOMAIN_SQRT`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_OP_arithmetic.yaml`](keywords/KW_OP_arithmetic.yaml)
* **Gatilho**: Cálculo de raiz quadrada ou raiz de índice par (^r 2, squareRoot64) onde o radicando é negativo
* **Mensagem Padrão**: *"Radicando negativo em raiz par: esperado x >= 0 para números reais"*
* **Dica de Correção**: 💡 Verifique se o radicando é não-negativo (x >= 0.0) antes de calcular a raiz, ou utilize números complexos

**Exemplo Incorreto:**
```theflux
use MathStdLib as M
mut as float64: r = squareRoot64(-4.0)
```

**Exemplo Corrigido:**
```theflux
use MathStdLib as M
route {
  x < 0.0 ==> { print("invalido") }
  _ ==> { mut as float64: r = squareRoot64(x) }
}
```

---

#### `RT708` — `MATH_DOMAIN_TRIG`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_OP_arithmetic.yaml`](keywords/KW_OP_arithmetic.yaml)
* **Gatilho**: Cálculo de função trigonométrica inversa (asin, acos) com argumento fora do intervalo [-1.0, 1.0]
* **Mensagem Padrão**: *"Argumento fora do domínio trigonométrico inverso: esperado -1.0 <= x <= 1.0"*
* **Dica de Correção**: 💡 Limite o argumento ao intervalo [-1.0, 1.0] antes de chamar asin ou acos

**Exemplo Incorreto:**
```theflux
use MathStdLib as M
mut as float64: a = asin64(2.0)
```

**Exemplo Corrigido:**
```theflux
use MathStdLib as M
route {
  (x < -1.0) or (x > 1.0) ==> { print("invalido") }
  _ ==> { mut as float64: a = asin64(x) }
}
```

---

#### `RT709` — `MATH_POWER_UNDEFINED`
* **Severidade**: `Error`
* **Arquivo Fonte**: [`KW_OP_arithmetic.yaml`](keywords/KW_OP_arithmetic.yaml)
* **Gatilho**: Cálculo de exponenciação (^e ou powerFloat64) com base zero e expoente menor ou igual a zero
* **Mensagem Padrão**: *"Potência indefinida para base zero e expoente não-positivo"*
* **Dica de Correção**: 💡 Evite elevar zero a expoentes menores ou iguais a zero (0^0 ou 0^(-k))

**Exemplo Incorreto:**
```theflux
use MathStdLib as M
mut as float64: p = powerFloat64(0.0, -1.0)
```

**Exemplo Corrigido:**
```theflux
use MathStdLib as M
route {
  (b == 0.0) and (e <= 0.0) ==> { print("indefinido") }
  _ ==> { mut as float64: p = powerFloat64(b, e) }
}
```

---


## 🛠️ 6. Ferramentas de Automação e Validação do Catálogo

### 6.1 `scripts/sync_errors_catalog.py`
Script principal do pipeline AOT com os modos de operação:
1. **Validação Estrita (`--validate-only`)**: Inspeciona todos os YAMLs e valida se:
   - Todos os códigos seguem o padrão `[A-Z]{2,4}\d{3}` e respeitam os limites numéricos de sua família.
   - Não existem códigos ou mnemônicos duplicados.
   - **100% dos erros possuem o campo `hint:` preenchido e não vazio** (falha impeditiva no build).
2. **Geração de Código Python**: Produz [`src/flux_proto/diagnostics/catalog_data.py`](../src/flux_proto/diagnostics/catalog_data.py).
3. **Geração de Runtime C**: Produz [`src/flux_proto/llvm/runtime/flux_errors.h`](../src/flux_proto/llvm/runtime/flux_errors.h).
4. **Geração de Documentação**: Produz este catálogo oficial unificado [`docs/pt/Errors.md`](Errors.md).

### 6.2 Comando CLI `flux --explain <CÓDIGO>`
Permite que o desenvolvedor consulte diretamente no terminal qualquer diagnóstico oficial:
```powershell
python -m flux_proto.cli --explain TYP401
python -m flux_proto.cli --explain OWN501
python -m flux_proto.cli --explain RT701
```

---

## 📋 7. Checklist de Implementação e Rastreamento de Execução

- [x] **Fase 1: Infraestrutura de Scripts e Validação Estrita**
  - [x] Criar `scripts/sync_errors_catalog.py` com geradores AOT (Python, C e Markdown).
  - [x] Implementar validação mandatória de `hint:` para 100% dos diagnósticos.
  - [x] Implementar motor de consulta em memória `src/flux_proto/diagnostics/catalog.py` e matriz de coerção $O(1)$.
- [x] **Fase 2: Enriquecimento dos Arquivos YAML (Grupo 1: Declarações e Tipos Básicos)**
  - [x] `KW_program.yaml` (`SYN100`, `SYN140`, `SEM310`, `SEM311`, `SEM312`, `TYP499`).
  - [x] `KW_mut.yaml` (`SYN105`, `SEM303`, `SEM304`, `SEM306`).
  - [x] `KW_imut.yaml` (`SEM305`, `SEM307`, `OWN501`, `OWN502`).
  - [x] `KW_TYPE_int.yaml` (`TYP401`..`TYP404`, `SEM301`).
  - [x] `KW_TYPE_float.yaml` (`TYP421`..`TYP423`).
  - [x] `KW_TYPE_complex.yaml` (`TYP411`..`TYP414`).
  - [x] `KW_TYPE_string.yaml` (`TYP431`..`TYP434`).
  - [x] `KW_LITERAL_bool.yaml` (`TYP441`..`TYP443`, `LEX010`).
- [x] **Fase 3: Enriquecimento dos Arquivos YAML (Grupo 2: Módulos, Contratos e Agentes)**
  - [x] `KW_use.yaml` (`IMP201`, `IMP202`, `IMP203`, `IMP204`).
  - [x] `KW_contract.yaml` (`SEM330`, `SEM331`, `SYN130`).
  - [x] `KW_agent.yaml` (`SEM340`, `SEM341`, `SEM342`, `CON603`).
  - [x] `KW_emit.yaml` (`SEM350`, `SEM351`, `TYP450`).
  - [x] `KW_route.yaml` (`SEM320`, `SYN120`).
  - [x] `KW_struct.yaml` (`SEM360`..`SEM363`).
  - [x] `KW_enum.yaml` (`SEM370`..`SEM372`).
- [x] **Fase 4: Enriquecimento dos Arquivos YAML (Grupo 3: Coleções, Concorrência e Runtime)**
  - [x] `KW_comments.yaml` (`LEX001`, `LEX003`, `LEX005`, `LEX006`).
  - [x] `KW_LITERAL_string.yaml` (`LEX002`, `LEX004`).
  - [x] `KW_LITERAL_float.yaml` (`LEX007`).
  - [x] `KW_TYPE_tensor.yaml` (`SYN150`, `SYN151`, `RT705`).
  - [x] `KW_TYPE_list.yaml` (`SYN160`, `OWN505`, `RT702`).
  - [x] `KW_TYPE_set.yaml` (`SYN161`).
  - [x] `KW_borrow.yaml` (`OWN503`, `OWN504`).
  - [x] `KW_spawn.yaml` (`CON601`, `CON602`).
  - [x] `KW_OP_arithmetic.yaml` (`RT701`).
  - [x] `KW_keep.yaml` (`RT703`).
  - [x] `KW_infinite.yaml` (`RT704`).
- [x] **Fase 5: Integração no Compilador e Homologação Multi-Backend**
  - [x] Atualizar `src/flux_proto/semantic/diagnostic.py` para emitir `💡 Dica: <hint>` de forma padronizada.
  - [x] Atualizar `src/flux_proto/cli.py` para emitir formato canônico e dicas em erros léxicos, sintáticos e importações.
  - [x] Criar suite de testes em `scratch/` e homologar a tríade e dicas para todas as famílias.
  - [x] Executar `python backend_compliance.py` garantindo 360/360 testes passando nos 6 backends.
