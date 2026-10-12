# 📋 TODO — Plano 1: Documentação Completa de Erros e Catálogo Oficial de Diagnósticos

> **Status**: Em Planejamento / Pronto para Execução  
> **Objetivo**: Enriquecer a documentação de todas as palavras-chave, operadores, literais e tipos em `docs/keywords/` (PT) e `docs/keywords/en/` (EN) com a seção formal `errors:`, além de criar o catálogo mestre oficial [`docs/erros.md`](erros.md) e [`docs/errors_en.md`](errors_en.md) para consulta direta pelo compilador durante as etapas de compilação e execução.

---

## 🎯 1. Escopo e Diretrizes do Plano

1. **Cobertura Universal de Categorias de Erro**:
   - **Erros Léxicos (`lexical`)**: Caracteres não permitidos, literais mal-formados (números com múltiplos pontos, strings não fechadas, caracteres de escape inválidos).
   - **Erros Sintáticos / Parser (`parser`)**: Violação gramatical EBNF, parênteses ou chaves desbalanceadas, ausência de conectores mandatórios (`==>`, `-->`), identificadores ausentes.
   - **Erros Semânticos & Tipagem (`semantic`)**: Atribuição entre tipos incompatíveis, reatribuição de variáveis imutáveis (`imut`), uso de identificador não declarado, colisão de símbolos no mesmo escopo.
   - **Erros de Contratos & Agentes (`contract`)**: Agente que não implementa integralmente o contrato declarado (`impl`), divergência de assinatura ou tipos de parâmetros, operação (`op`) com retorno sem comando `emit` terminal.
   - **Condições de Falha em Tempo de Execução (`runtime`)**: Divisão inteira por zero, tentativa de acesso fora dos limites (*out-of-bounds*) em listas, strings ou tensores, estouro de cotas de memória/descompressão (`DecompressQuota`), fechamento e leitura em canais de concorrência (`channelIsClosed`), falhas em operações de bancos de dados embutidos (`DbStdLib`).

2. **Inclusão da Seção `errors:` nos YAMLs**:
   - Em cada um dos ~70 arquivos em `docs/keywords/KW_*.yaml` (Português) e `docs/keywords/en/KW_*.yaml` (Inglês), inserir a seção `errors:` imediatamente após `restrictions:`.
   - Manter a integridade de todas as seções já existentes (`keyword`, `category`, `description`, `syntax`, `pseudocode`, `usages`, `restrictions`).

3. **Catálogo Central `docs/erros.md` (e `docs/errors_en.md`)**:
   - Criar o catálogo autoritativo consultável pelo compilador TheFlux para padronização de códigos (`LEX_*`, `SYN_*`, `SEM_*`, `RT_*`), formatação visual de mensagens com cursor indicador (`^`), severidade e sugestões acionáveis (*did you mean*).

---

## 📐 2. Estrutura Padrão da Seção `errors:` nos Arquivos YAML

### 2.1 Exemplo em Português (`docs/keywords/KW_op.yaml`)
```yaml
restrictions:
  - 'O nome da operação deve estar em camelCase: `op nomeDaOperacao`.'
  - 'Parâmetros seguem a convenção `[mut | imut | as] <tipo>: <identificador>`.'
  - 'O corpo deve terminar obrigatoriamente com um comando `emit` terminal quando possuir retorno.'

errors:
  - code: "SYN_OP_INVALID_NAME"
    phase: "parser"
    severity: "error"
    trigger: "Nome de operação não segue camelCase ou contém caracteres inválidos"
    message: "nome da operação '{name}' deve iniciar com letra minúscula (camelCase)"
    hint: "Altere o identificador para começar com letra minúscula seguindo camelCase."
    example_bad: |
      op SomarValores (as int64: a) as int64 ==> { ... }
    example_good: |
      op somarValores (as int64: a) as int64 ==> { ... }

  - code: "SEM_OP_MISSING_EMIT"
    phase: "semantic"
    severity: "error"
    trigger: "Operação com tipo de retorno declarado não finaliza com 'emit' terminal"
    message: "operação '{name}' declara retorno 'as {return_type}' mas não possui 'emit' terminal"
    hint: "Finalize o corpo da operação com uma chamada 'emit(nice|fail, valor, \"status\")'."
    example_bad: |
      op dobro (as int64: x) as int64 ==> {
            mut as int64: r = x * 2
      }
    example_good: |
      op dobro (as int64: x) as int64 ==> {
            mut as int64: r = x * 2
            emit(nice, r, "ok")
      }

  - code: "SEM_OP_MUT_PARAM_REASSIGN"
    phase: "semantic"
    severity: "error"
    trigger: "Reatribuição a parâmetro imutável padrão dentro do corpo da operação"
    message: "parâmetro '{param}' é imutável por padrão; declare como 'mut as {type}:' para permitir alteração"
    hint: "Adicione o modificador 'mut' antes de 'as <tipo>:' na assinatura da operação."
    example_bad: |
      op incrementar (as int64: total) as int64 ==> {
            total = total + 1
            emit(nice, total, "ok")
      }
    example_good: |
      op incrementar (mut as int64: total) as int64 ==> {
            total = total + 1
            emit(nice, total, "ok")
      }
```

### 2.2 Exemplo em Inglês (`docs/keywords/en/KW_op.yaml`)
```yaml
restrictions:
  - 'Operation name must be in camelCase: `op operationName`.'
  - 'Parameters follow the convention `[mut | imut | as] <type>: <identifier>`.'
  - 'The body must end with a terminal `emit` statement when a return type is specified.'

errors:
  - code: "SYN_OP_INVALID_NAME"
    phase: "parser"
    severity: "error"
    trigger: "Operation name does not follow camelCase or contains invalid characters"
    message: "operation name '{name}' must start with a lowercase letter (camelCase)"
    hint: "Change the identifier to start with a lowercase letter following camelCase."
    example_bad: |
      op CalculateValue (as int64: a) as int64 ==> { ... }
    example_good: |
      op calculateValue (as int64: a) as int64 ==> { ... }

  - code: "SEM_OP_MISSING_EMIT"
    phase: "semantic"
    severity: "error"
    trigger: "Operation with return type does not conclude with a terminal 'emit'"
    message: "operation '{name}' declares return type 'as {return_type}' but lacks terminal 'emit'"
    hint: "Conclude operation body with an 'emit(nice|fail, value, \"status\")' call."
    example_bad: |
      op double (as int64: x) as int64 ==> {
            mut as int64: r = x * 2
      }
    example_good: |
      op double (as int64: x) as int64 ==> {
            mut as int64: r = x * 2
            emit(nice, r, "ok")
      }
```

---

## 📚 3. Estrutura do Catálogo Oficial `docs/erros.md`

O arquivo `docs/erros.md` consolidará todos os erros em uma tabela mestre de referência e seções analíticas detalhadas:

```markdown
# Catálogo Oficial de Diagnósticos e Erros — TheFlux

## 📊 Matriz Resumida de Códigos

| Código | Fase | Severidade | Descrição / Gatilho | Mensagem Padrão |
| :--- | :---: | :---: | :--- | :--- |
| `LEX_INVALID_CHAR` | Léxico | Error | Caractere inválido ou não reconhecido no código | caractere inválido '{char}' encontrado |
| `SYN_UNEXPECTED_TOKEN`| Parser | Error | Token encontrado diverge da gramática esperada | token inesperado '{token}', esperado '{expected}' |
| `SEM_UNDEFINED_SYMBOL`| Semântica| Error | Identificador não declarado no escopo | símbolo '{name}' não definido no escopo |
| `SEM_MUT_REASSIGN` | Semântica| Error | Tentativa de alterar variável imutável | variável '{name}' é imutável e não pode ser reatribuída |
| `SEM_TYPE_MISMATCH` | Tipagem | Error | Tipos incompatíveis em operação ou atribuição | tipo incompatível: esperado '{expected}', obtido '{actual}' |
| `SEM_CONTRACT_UNMET` | Contratos | Error | Agente não implementa operação do contrato | agente '{agent}' não implementa operação '{op}' do contrato '{contract}' |
| `RT_DIV_BY_ZERO` | Runtime | Exception | Divisão inteira por zero em tempo de execução | divisão por zero detectada |
| `RT_INDEX_OUT_OF_BOUNDS`| Runtime | Exception | Índice além do tamanho da coleção | índice {index} fora dos limites da coleção (tamanho {size}) |
```

Cada código contará com sua seção contendo:
1. **Identificador e Categoria**.
2. **Formatação Visual do Compilador** (linha, coluna e trecho de código com indicador `^`).
3. **Mecanismo de Sugestão** (did you mean, conversão de tipo, remoção de palavra-chave estrangeira).
4. **Exemplo Incorreto e Exemplo Corrigido**.

---

## 🛠️ 4. Ferramentas de Automação

1. **`scripts/sync_errors_catalog.py`**:
   - Realiza o parse de todos os arquivos em `docs/keywords/` e `docs/keywords/en/`.
   - Valida consistência de códigos de erro entre as versões PT e EN.
   - Gera e sincroniza automaticamente `docs/erros.md`, `docs/errors_en.md` e `docs/keywords.yaml`.
2. **`scripts/validate_keywords_docs.py`**:
   - Validador de CI/teste para assegurar que nenhum arquivo YAML novo ou editado fique sem a seção `errors:`.

---

## 📋 5. Lista de Tarefas (Checklist de Execução)

- [ ] **Fase 1: Infraestrutura de Scripts e Catálogo Base**
  - [ ] Criar `scripts/sync_errors_catalog.py`.
  - [ ] Criar estrutura base de `docs/erros.md` e `docs/errors_en.md`.
  - [ ] Criar `scripts/validate_keywords_docs.py`.
- [ ] **Fase 2: Atualização dos Arquivos YAML (Grupo 1: Declarações e Núcleo)**
  - [ ] `KW_program.yaml`, `KW_contract.yaml`, `KW_agent.yaml`, `KW_impl.yaml`.
  - [ ] `KW_op.yaml`, `KW_function.yaml`, `KW_emit.yaml`, `KW_route.yaml`.
  - [ ] `KW_mut.yaml`, `KW_imut.yaml`, `KW_struct.yaml`, `KW_enum.yaml`.
  - [ ] Atualizar versões espelho em `docs/keywords/en/`.
- [ ] **Fase 3: Atualização dos Arquivos YAML (Grupo 2: Controle de Fluxo e Operadores)**
  - [ ] `KW_infinite.yaml`, `KW_continue.yaml`, `KW_break.yaml`, `KW_match.yaml`.
  - [ ] `KW_OP_arithmetic.yaml`, `KW_OP_comparison.yaml`, `KW_OP_logical.yaml`.
  - [ ] `KW_OP_dataflow.yaml`, `KW_short_circuit.yaml`, `KW_slices.yaml`.
  - [ ] Atualizar versões espelho em `docs/keywords/en/`.
- [ ] **Fase 4: Atualização dos Arquivos YAML (Grupo 3: Tipos, Literais e Sistema)**
  - [ ] `KW_TYPE_int.yaml`, `KW_TYPE_float.yaml`, `KW_TYPE_string.yaml`, `KW_TYPE_char.yaml`.
  - [ ] `KW_TYPE_bool.yaml`, `KW_TYPE_list.yaml`, `KW_TYPE_map.yaml`, `KW_TYPE_set.yaml`, `KW_TYPE_tensor.yaml`.
  - [ ] `KW_LITERAL_*.yaml`, `KW_use.yaml`, `KW_unsafe.yaml`, `KW_input.yaml`, `KW_print.yaml`.
  - [ ] Atualizar versões espelho em `docs/keywords/en/`.
- [ ] **Fase 5: Consolidação e Validação Final**
  - [ ] Executar `sync_errors_catalog.py` gerando `docs/erros.md` e `docs/keywords.yaml` 100% atualizados.
  - [ ] Executar `validate_keywords_docs.py` confirmando conformidade de 100% dos arquivos YAML.
