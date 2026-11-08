# 📚 `FsmStdLib` — Máquinas de Estados Finitos (FSM) Determinísticas e Auditoria

> **Pilar Arquitetural**: Pilar 2 (Estruturas & Estados)  
> **Status**: ✅ Homologado com 100% de Paridade nos 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Arquivo Mestre**: `stdlib/FsmStdLib/FsmStdLib.fdsl`  
> **Modo de Importação**: `use FsmStdLib` ou `use FsmStdLib::<Modulo>::<operacao>`

---

## 1. Visão Geral e Funcionalidades

A biblioteca padrão **`FsmStdLib`** integra o ecossistema oficial da linguagem TheFlux, fornecendo suporte de nível de sistema e algoritmos nativos certificados.

Mecanismo declarativo para modelagem de Máquinas de Estados Finitos: definição formal de estados e eventos, guardas condicionais de transição, execução determinística passo a passo, trilha de auditoria completa e exportação em formato Graphviz DOT.

### 1.1 Características e Princípios de Design
- **Compilação e Fusão Estática**: Todos os módulos de domínio são fundidos no agente unificado `FsmStdLib` em tempo de compilação, sem sobrecarga (*overhead*) de despacho indireto.
- **Isolamento e Segurança**: As operações verificam limites operacionais e utilizam despacho por contratos formais rigorosos.
- **Compatibilidade Multi-Backend**: Execução bit-a-bit idêntica em interpretador (`in`), bytecode (`vm`, `vmr`), nativo AOT (`llvm`) e WebAssembly (`wat`, `wasm`).

---

## 2. Estrutura Modular e Contratos

A biblioteca é composta por **5 módulos de domínio** e declara **22 operações públicas**:

| Arquivo de Domínio | Contrato Formal | Responsabilidade Principal | Qtd. Ops |
|---|---|---|:---:|
| `FsmAudit.fdsl` | `FsmAuditContract` | Domínio especializado de `FsmAudit` | 4 |
| `FsmDefinition.fdsl` | `FsmDefinitionContract` | Domínio especializado de `FsmDefinition` | 6 |
| `FsmExecution.fdsl` | `FsmExecutionContract` | Domínio especializado de `FsmExecution` | 2 |
| `FsmExport.fdsl` | `FsmExportContract` | Domínio especializado de `FsmExport` | 1 |
| `FsmQuery.fdsl` | `FsmQueryContract` | Domínio especializado de `FsmQuery` | 9 |

---

## 3. Tipos, Estruturas e Enumerações Públicas

A biblioteca `FsmStdLib` opera diretamente com os tipos nativos e primitivos da linguagem TheFlux (`string`, `int64`, `float64`, `bool`, `list of data`, etc.), sem exigir tipos compostos adicionais.

---

## 4. Catálogo Detalhado de Operações por Domínio

### 4.1 Contrato `FsmAuditContract` (`FsmAudit.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `fsmAuditTrail` | `op fsmAuditTrail (as list of data: history, as string: new_state) as list of data` | `list of data` |
| `fsmHistoryValidate` | `op fsmHistoryValidate (as map: fsm_instance, as list of data: history) as bool` | `bool` |
| `fsmHistoryLength` | `op fsmHistoryLength (as list of data: history) as int64` | `int64` |
| `fsmHistoryLast` | `op fsmHistoryLast (as list of data: history) as string` | `string` |

#### Ficha Técnica das Operações:

##### `op fsmAuditTrail`
```flux
op fsmAuditTrail (as list of data: history, as string: new_state) as list of data
```
- **Parâmetros**:
  - `history` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `new_state` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `fsmAuditTrail` no domínio `FsmAuditContract`.

##### `op fsmHistoryValidate`
```flux
op fsmHistoryValidate (as map: fsm_instance, as list of data: history) as bool
```
- **Parâmetros**:
  - `fsm_instance` (`map`): Parâmetro de entrada para processamento da operação.
  - `history` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `fsmHistoryValidate` no domínio `FsmAuditContract`.

##### `op fsmHistoryLength`
```flux
op fsmHistoryLength (as list of data: history) as int64
```
- **Parâmetros**:
  - `history` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `fsmHistoryLength` no domínio `FsmAuditContract`.

##### `op fsmHistoryLast`
```flux
op fsmHistoryLast (as list of data: history) as string
```
- **Parâmetros**:
  - `history` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `fsmHistoryLast` no domínio `FsmAuditContract`.

### 4.2 Contrato `FsmDefinitionContract` (`FsmDefinition.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `fsmCreate` | `op fsmCreate (as map: config) as map` | `map` |
| `fsmValidate` | `op fsmValidate (as map: fsm_instance) as bool` | `bool` |
| `fsmInitialState` | `op fsmInitialState (as map: fsm_instance) as string` | `string` |
| `fsmFinalStates` | `op fsmFinalStates (as map: fsm_instance) as list of data` | `list of data` |
| `fsmStates` | `op fsmStates (as map: fsm_instance) as list of data` | `list of data` |
| `fsmEvents` | `op fsmEvents (as map: fsm_instance) as list of data` | `list of data` |

#### Ficha Técnica das Operações:

##### `op fsmCreate`
```flux
op fsmCreate (as map: config) as map
```
- **Parâmetros**:
  - `config` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `fsmCreate` no domínio `FsmDefinitionContract`.

##### `op fsmValidate`
```flux
op fsmValidate (as map: fsm_instance) as bool
```
- **Parâmetros**:
  - `fsm_instance` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
  - ⚠️ Emite `fail` com status `"FSM estruturalmente invalida"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `fsmValidate` no domínio `FsmDefinitionContract`.

##### `op fsmInitialState`
```flux
op fsmInitialState (as map: fsm_instance) as string
```
- **Parâmetros**:
  - `fsm_instance` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `fsmInitialState` no domínio `FsmDefinitionContract`.

##### `op fsmFinalStates`
```flux
op fsmFinalStates (as map: fsm_instance) as list of data
```
- **Parâmetros**:
  - `fsm_instance` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `fsmFinalStates` no domínio `FsmDefinitionContract`.

##### `op fsmStates`
```flux
op fsmStates (as map: fsm_instance) as list of data
```
- **Parâmetros**:
  - `fsm_instance` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `fsmStates` no domínio `FsmDefinitionContract`.

##### `op fsmEvents`
```flux
op fsmEvents (as map: fsm_instance) as list of data
```
- **Parâmetros**:
  - `fsm_instance` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `fsmEvents` no domínio `FsmDefinitionContract`.

### 4.3 Contrato `FsmExecutionContract` (`FsmExecution.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `fsmTransition` | `op fsmTransition (as map: fsm_instance, as string: current_state, as string: event_name) as string` | `string` |
| `fsmTryTransition` | `op fsmTryTransition (as map: fsm_instance, as string: current_state, as string: event_name) as list of data` | `list of data` |

#### Ficha Técnica das Operações:

##### `op fsmTransition`
```flux
op fsmTransition (as map: fsm_instance, as string: current_state, as string: event_name) as string
```
- **Parâmetros**:
  - `fsm_instance` (`map`): Parâmetro de entrada para processamento da operação.
  - `current_state` (`string`): Parâmetro de entrada para processamento da operação.
  - `event_name` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `fsmTransition` no domínio `FsmExecutionContract`.

##### `op fsmTryTransition`
```flux
op fsmTryTransition (as map: fsm_instance, as string: current_state, as string: event_name) as list of data
```
- **Parâmetros**:
  - `fsm_instance` (`map`): Parâmetro de entrada para processamento da operação.
  - `current_state` (`string`): Parâmetro de entrada para processamento da operação.
  - `event_name` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `fsmTryTransition` no domínio `FsmExecutionContract`.

### 4.4 Contrato `FsmExportContract` (`FsmExport.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `fsmToMermaid` | `op fsmToMermaid (as map: fsm_instance) as string` | `string` |

#### Ficha Técnica das Operações:

##### `op fsmToMermaid`
```flux
op fsmToMermaid (as map: fsm_instance) as string
```
- **Parâmetros**:
  - `fsm_instance` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `fsmToMermaid` no domínio `FsmExportContract`.

### 4.5 Contrato `FsmQueryContract` (`FsmQuery.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `fsmHasState` | `op fsmHasState (as map: fsm_instance, as string: state) as bool` | `bool` |
| `fsmHasEvent` | `op fsmHasEvent (as map: fsm_instance, as string: event_name) as bool` | `bool` |
| `fsmIsInitial` | `op fsmIsInitial (as map: fsm_instance, as string: state) as bool` | `bool` |
| `fsmIsFinal` | `op fsmIsFinal (as map: fsm_instance, as string: state) as bool` | `bool` |
| `fsmCanTransition` | `op fsmCanTransition (as map: fsm_instance, as string: current_state, as string: event_name) as bool` | `bool` |
| `fsmNextState` | `op fsmNextState (as map: fsm_instance, as string: current_state, as string: event_name) as string` | `string` |
| `fsmAllowedEvents` | `op fsmAllowedEvents (as map: fsm_instance, as string: current_state) as list of data` | `list of data` |
| `fsmNextStates` | `op fsmNextStates (as map: fsm_instance, as string: current_state) as list of data` | `list of data` |
| `fsmIsReachable` | `op fsmIsReachable (as map: fsm_instance, as string: from_state, as string: to_state) as bool` | `bool` |

#### Ficha Técnica das Operações:

##### `op fsmHasState`
```flux
op fsmHasState (as map: fsm_instance, as string: state) as bool
```
- **Parâmetros**:
  - `fsm_instance` (`map`): Parâmetro de entrada para processamento da operação.
  - `state` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `fsmHasState` no domínio `FsmQueryContract`.

##### `op fsmHasEvent`
```flux
op fsmHasEvent (as map: fsm_instance, as string: event_name) as bool
```
- **Parâmetros**:
  - `fsm_instance` (`map`): Parâmetro de entrada para processamento da operação.
  - `event_name` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `fsmHasEvent` no domínio `FsmQueryContract`.

##### `op fsmIsInitial`
```flux
op fsmIsInitial (as map: fsm_instance, as string: state) as bool
```
- **Parâmetros**:
  - `fsm_instance` (`map`): Parâmetro de entrada para processamento da operação.
  - `state` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `fsmIsInitial` no domínio `FsmQueryContract`.

##### `op fsmIsFinal`
```flux
op fsmIsFinal (as map: fsm_instance, as string: state) as bool
```
- **Parâmetros**:
  - `fsm_instance` (`map`): Parâmetro de entrada para processamento da operação.
  - `state` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `fsmIsFinal` no domínio `FsmQueryContract`.

##### `op fsmCanTransition`
```flux
op fsmCanTransition (as map: fsm_instance, as string: current_state, as string: event_name) as bool
```
- **Parâmetros**:
  - `fsm_instance` (`map`): Parâmetro de entrada para processamento da operação.
  - `current_state` (`string`): Parâmetro de entrada para processamento da operação.
  - `event_name` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `fsmCanTransition` no domínio `FsmQueryContract`.

##### `op fsmNextState`
```flux
op fsmNextState (as map: fsm_instance, as string: current_state, as string: event_name) as string
```
- **Parâmetros**:
  - `fsm_instance` (`map`): Parâmetro de entrada para processamento da operação.
  - `current_state` (`string`): Parâmetro de entrada para processamento da operação.
  - `event_name` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `fsmNextState` no domínio `FsmQueryContract`.

##### `op fsmAllowedEvents`
```flux
op fsmAllowedEvents (as map: fsm_instance, as string: current_state) as list of data
```
- **Parâmetros**:
  - `fsm_instance` (`map`): Parâmetro de entrada para processamento da operação.
  - `current_state` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `fsmAllowedEvents` no domínio `FsmQueryContract`.

##### `op fsmNextStates`
```flux
op fsmNextStates (as map: fsm_instance, as string: current_state) as list of data
```
- **Parâmetros**:
  - `fsm_instance` (`map`): Parâmetro de entrada para processamento da operação.
  - `current_state` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `fsmNextStates` no domínio `FsmQueryContract`.

##### `op fsmIsReachable`
```flux
op fsmIsReachable (as map: fsm_instance, as string: from_state, as string: to_state) as bool
```
- **Parâmetros**:
  - `fsm_instance` (`map`): Parâmetro de entrada para processamento da operação.
  - `from_state` (`string`): Parâmetro de entrada para processamento da operação.
  - `to_state` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `fsmIsReachable` no domínio `FsmQueryContract`.

---

## 5. Exemplos Canônicos de Uso em TheFlux

O exemplo a seguir demonstra a importação e o consumo prático da biblioteca:

```flux
# Exemplo Canônico de Consumo da FsmStdLib
use FsmStdLib

program (ExemploFsmStdLib) {
      println("==================================================")
      println("  Demonstracao da Standard Library: FsmStdLib")
      println("==================================================")

      # Chamada da operacao canônica
      mut as data: resultado = FsmStdLib::fsmCreate("OrderFSM")
      println("Resultado obtido: " + resultado)

      println("Demonstracao concluida com sucesso.")
}
```

---

> [!TIP]
> Para consultar a visão arquitetural unificada de todas as bibliotecas, consulte o documento principal [StdLibs.md](../StdLibs.md).
