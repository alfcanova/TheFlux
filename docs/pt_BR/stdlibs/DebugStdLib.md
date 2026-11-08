# 📚 `DebugStdLib` — Diagnóstico, Asserções, Rastreamento e Inspeção em Runtime

> **Pilar Arquitetural**: Pilar 1 (Núcleo, Texto & OO)  
> **Status**: ✅ Homologado com 100% de Paridade nos 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Arquivo Mestre**: `stdlib/DebugStdLib/DebugStdLib.fdsl`  
> **Modo de Importação**: `use DebugStdLib` ou `use DebugStdLib::<Modulo>::<operacao>`

---

## 1. Visão Geral e Funcionalidades

A biblioteca padrão **`DebugStdLib`** integra o ecossistema oficial da linguagem TheFlux, fornecendo suporte de nível de sistema e algoritmos nativos certificados.

Conjunto de utilitários de instrumentação para depuração ativa: asserções defensivas (`assert`), impressão de stack traces, filtragem de logs em múltiplos níveis, cálculo de diferenças (`diff`) entre valores e telemetria de performance.

### 1.1 Características e Princípios de Design
- **Compilação e Fusão Estática**: Todos os módulos de domínio são fundidos no agente unificado `DebugStdLib` em tempo de compilação, sem sobrecarga (*overhead*) de despacho indireto.
- **Isolamento e Segurança**: As operações verificam limites operacionais e utilizam despacho por contratos formais rigorosos.
- **Compatibilidade Multi-Backend**: Execução bit-a-bit idêntica em interpretador (`in`), bytecode (`vm`, `vmr`), nativo AOT (`llvm`) e WebAssembly (`wat`, `wasm`).

---

## 2. Estrutura Modular e Contratos

A biblioteca é composta por **8 módulos de domínio** e declara **33 operações públicas**:

| Arquivo de Domínio | Contrato Formal | Responsabilidade Principal | Qtd. Ops |
|---|---|---|:---:|
| `DebugAssert.fdsl` | `DebugAssertContract` | Domínio especializado de `DebugAssert` | 5 |
| `DebugDiff.fdsl` | `DebugDiffContract` | Domínio especializado de `DebugDiff` | 3 |
| `DebugFilter.fdsl` | `DebugFilterContract` | Domínio especializado de `DebugFilter` | 3 |
| `DebugInspect.fdsl` | `DebugInspectContract` | Domínio especializado de `DebugInspect` | 6 |
| `DebugLogging.fdsl` | `DebugLoggingContract` | Domínio especializado de `DebugLogging` | 6 |
| `DebugPipeline.fdsl` | `DebugPipelineContract` | Domínio especializado de `DebugPipeline` | 3 |
| `DebugProfile.fdsl` | `DebugProfileContract` | Domínio especializado de `DebugProfile` | 4 |
| `DebugState.fdsl` | `DebugStateContract` | Domínio especializado de `DebugState` | 3 |

---

## 3. Tipos, Estruturas e Enumerações Públicas

A biblioteca `DebugStdLib` opera diretamente com os tipos nativos e primitivos da linguagem TheFlux (`string`, `int64`, `float64`, `bool`, `list of data`, etc.), sem exigir tipos compostos adicionais.

---

## 4. Catálogo Detalhado de Operações por Domínio

### 4.1 Contrato `DebugAssertContract` (`DebugAssert.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `debugAssert` | `op debugAssert (as bool: condition, as string: message) as bool` | `bool` |
| `debugAssertEqualInt` | `op debugAssertEqualInt (as int64: actual, as int64: expected, as string: tag) as bool` | `bool` |
| `debugAssertEqualString` | `op debugAssertEqualString (as string: actual, as string: expected, as string: tag) as bool` | `bool` |
| `debugAssertEqualBool` | `op debugAssertEqualBool (as bool: actual, as bool: expected, as string: tag) as bool` | `bool` |
| `debugAssertInRange` | `op debugAssertInRange (as int64: val, as int64: min_val, as int64: max_val, as string: tag) as bool` | `bool` |

#### Ficha Técnica das Operações:

##### `op debugAssert`
```flux
op debugAssert (as bool: condition, as string: message) as bool
```
- **Parâmetros**:
  - `condition` (`bool`): Parâmetro de entrada para processamento da operação.
  - `message` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `debugAssert` no domínio `DebugAssertContract`.

##### `op debugAssertEqualInt`
```flux
op debugAssertEqualInt (as int64: actual, as int64: expected, as string: tag) as bool
```
- **Parâmetros**:
  - `actual` (`int64`): Parâmetro de entrada para processamento da operação.
  - `expected` (`int64`): Parâmetro de entrada para processamento da operação.
  - `tag` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `debugAssertEqualInt` no domínio `DebugAssertContract`.

##### `op debugAssertEqualString`
```flux
op debugAssertEqualString (as string: actual, as string: expected, as string: tag) as bool
```
- **Parâmetros**:
  - `actual` (`string`): Parâmetro de entrada para processamento da operação.
  - `expected` (`string`): Parâmetro de entrada para processamento da operação.
  - `tag` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `debugAssertEqualString` no domínio `DebugAssertContract`.

##### `op debugAssertEqualBool`
```flux
op debugAssertEqualBool (as bool: actual, as bool: expected, as string: tag) as bool
```
- **Parâmetros**:
  - `actual` (`bool`): Parâmetro de entrada para processamento da operação.
  - `expected` (`bool`): Parâmetro de entrada para processamento da operação.
  - `tag` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `debugAssertEqualBool` no domínio `DebugAssertContract`.

##### `op debugAssertInRange`
```flux
op debugAssertInRange (as int64: val, as int64: min_val, as int64: max_val, as string: tag) as bool
```
- **Parâmetros**:
  - `val` (`int64`): Parâmetro de entrada para processamento da operação.
  - `min_val` (`int64`): Parâmetro de entrada para processamento da operação.
  - `max_val` (`int64`): Parâmetro de entrada para processamento da operação.
  - `tag` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `debugAssertInRange` no domínio `DebugAssertContract`.

### 4.2 Contrato `DebugDiffContract` (`DebugDiff.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `debugDiffString` | `op debugDiffString (as string: actual, as string: expected) as string` | `string` |
| `debugDiffList` | `op debugDiffList (as list of data: actual, as list of data: expected) as string` | `string` |
| `debugDiffCount` | `op debugDiffCount (as list of data: a, as list of data: b) as int64` | `int64` |

#### Ficha Técnica das Operações:

##### `op debugDiffString`
```flux
op debugDiffString (as string: actual, as string: expected) as string
```
- **Parâmetros**:
  - `actual` (`string`): Parâmetro de entrada para processamento da operação.
  - `expected` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `debugDiffString` no domínio `DebugDiffContract`.

##### `op debugDiffList`
```flux
op debugDiffList (as list of data: actual, as list of data: expected) as string
```
- **Parâmetros**:
  - `actual` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `expected` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `debugDiffList` no domínio `DebugDiffContract`.

##### `op debugDiffCount`
```flux
op debugDiffCount (as list of data: a, as list of data: b) as int64
```
- **Parâmetros**:
  - `a` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `b` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `debugDiffCount` no domínio `DebugDiffContract`.

### 4.3 Contrato `DebugFilterContract` (`DebugFilter.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `debugLevelShouldLog` | `op debugLevelShouldLog (as int64: current_level, as int64: message_level) as bool` | `bool` |
| `debugLevelName` | `op debugLevelName (as int64: level) as string` | `string` |
| `debugTagMatches` | `op debugTagMatches (as string: active_tags, as string: target_tag) as bool` | `bool` |

#### Ficha Técnica das Operações:

##### `op debugLevelShouldLog`
```flux
op debugLevelShouldLog (as int64: current_level, as int64: message_level) as bool
```
- **Parâmetros**:
  - `current_level` (`int64`): Parâmetro de entrada para processamento da operação.
  - `message_level` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `debugLevelShouldLog` no domínio `DebugFilterContract`.

##### `op debugLevelName`
```flux
op debugLevelName (as int64: level) as string
```
- **Parâmetros**:
  - `level` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `debugLevelName` no domínio `DebugFilterContract`.

##### `op debugTagMatches`
```flux
op debugTagMatches (as string: active_tags, as string: target_tag) as bool
```
- **Parâmetros**:
  - `active_tags` (`string`): Parâmetro de entrada para processamento da operação.
  - `target_tag` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `debugTagMatches` no domínio `DebugFilterContract`.

### 4.4 Contrato `DebugInspectContract` (`DebugInspect.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `debugReprString` | `op debugReprString (as string: text) as string` | `string` |
| `debugReprInt` | `op debugReprInt (as int64: value) as string` | `string` |
| `debugReprFloat` | `op debugReprFloat (as float64: value) as string` | `string` |
| `debugReprBool` | `op debugReprBool (as bool: value) as string` | `string` |
| `debugDumpList` | `op debugDumpList (as list of data: items, as string: label) as string` | `string` |
| `debugHexDump` | `op debugHexDump (as string: text) as string` | `string` |

#### Ficha Técnica das Operações:

##### `op debugReprString`
```flux
op debugReprString (as string: text) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `debugReprString` no domínio `DebugInspectContract`.

##### `op debugReprInt`
```flux
op debugReprInt (as int64: value) as string
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `debugReprInt` no domínio `DebugInspectContract`.

##### `op debugReprFloat`
```flux
op debugReprFloat (as float64: value) as string
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `debugReprFloat` no domínio `DebugInspectContract`.

##### `op debugReprBool`
```flux
op debugReprBool (as bool: value) as string
```
- **Parâmetros**:
  - `value` (`bool`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `debugReprBool` no domínio `DebugInspectContract`.

##### `op debugDumpList`
```flux
op debugDumpList (as list of data: items, as string: label) as string
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `label` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `debugDumpList` no domínio `DebugInspectContract`.

##### `op debugHexDump`
```flux
op debugHexDump (as string: text) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `debugHexDump` no domínio `DebugInspectContract`.

### 4.5 Contrato `DebugLoggingContract` (`DebugLogging.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `debugLogInfo` | `op debugLogInfo (as string: tag, as string: message) as string` | `string` |
| `debugLogWarn` | `op debugLogWarn (as string: tag, as string: message) as string` | `string` |
| `debugLogError` | `op debugLogError (as string: tag, as string: message) as string` | `string` |
| `debugLogDebug` | `op debugLogDebug (as string: tag, as string: message) as string` | `string` |
| `debugTrace` | `op debugTrace (as string: context, as string: step) as string` | `string` |
| `debugBanner` | `op debugBanner (as string: title, as int64: width) as string` | `string` |

#### Ficha Técnica das Operações:

##### `op debugLogInfo`
```flux
op debugLogInfo (as string: tag, as string: message) as string
```
- **Parâmetros**:
  - `tag` (`string`): Parâmetro de entrada para processamento da operação.
  - `message` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `debugLogInfo` no domínio `DebugLoggingContract`.

##### `op debugLogWarn`
```flux
op debugLogWarn (as string: tag, as string: message) as string
```
- **Parâmetros**:
  - `tag` (`string`): Parâmetro de entrada para processamento da operação.
  - `message` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `debugLogWarn` no domínio `DebugLoggingContract`.

##### `op debugLogError`
```flux
op debugLogError (as string: tag, as string: message) as string
```
- **Parâmetros**:
  - `tag` (`string`): Parâmetro de entrada para processamento da operação.
  - `message` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `debugLogError` no domínio `DebugLoggingContract`.

##### `op debugLogDebug`
```flux
op debugLogDebug (as string: tag, as string: message) as string
```
- **Parâmetros**:
  - `tag` (`string`): Parâmetro de entrada para processamento da operação.
  - `message` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `debugLogDebug` no domínio `DebugLoggingContract`.

##### `op debugTrace`
```flux
op debugTrace (as string: context, as string: step) as string
```
- **Parâmetros**:
  - `context` (`string`): Parâmetro de entrada para processamento da operação.
  - `step` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `debugTrace` no domínio `DebugLoggingContract`.

##### `op debugBanner`
```flux
op debugBanner (as string: title, as int64: width) as string
```
- **Parâmetros**:
  - `title` (`string`): Parâmetro de entrada para processamento da operação.
  - `width` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `debugBanner` no domínio `DebugLoggingContract`.

### 4.6 Contrato `DebugPipelineContract` (`DebugPipeline.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `debugTap` | `op debugTap (as data: value, as string: step_name) as data` | `data` |
| `debugTapIf` | `op debugTapIf (as data: value, as bool: condition, as string: tag) as data` | `data` |
| `debugCounterTap` | `op debugCounterTap (as data: value, as int64: counter) as int64` | `int64` |

#### Ficha Técnica das Operações:

##### `op debugTap`
```flux
op debugTap (as data: value, as string: step_name) as data
```
- **Parâmetros**:
  - `value` (`data`): Parâmetro de entrada para processamento da operação.
  - `step_name` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `debugTap` no domínio `DebugPipelineContract`.

##### `op debugTapIf`
```flux
op debugTapIf (as data: value, as bool: condition, as string: tag) as data
```
- **Parâmetros**:
  - `value` (`data`): Parâmetro de entrada para processamento da operação.
  - `condition` (`bool`): Parâmetro de entrada para processamento da operação.
  - `tag` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `debugTapIf` no domínio `DebugPipelineContract`.

##### `op debugCounterTap`
```flux
op debugCounterTap (as data: value, as int64: counter) as int64
```
- **Parâmetros**:
  - `value` (`data`): Parâmetro de entrada para processamento da operação.
  - `counter` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `debugCounterTap` no domínio `DebugPipelineContract`.

### 4.7 Contrato `DebugProfileContract` (`DebugProfile.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `debugCounterNew` | `op debugCounterNew () as int64` | `int64` |
| `debugCounterIncrement` | `op debugCounterIncrement (as int64: counter, as int64: step) as int64` | `int64` |
| `debugMetricRecord` | `op debugMetricRecord (as string: name, as int64: value, as string: unit) as string` | `string` |
| `debugProgress` | `op debugProgress (as int64: current, as int64: total, as int64: width) as string` | `string` |

#### Ficha Técnica das Operações:

##### `op debugCounterNew`
```flux
op debugCounterNew () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `debugCounterNew` no domínio `DebugProfileContract`.

##### `op debugCounterIncrement`
```flux
op debugCounterIncrement (as int64: counter, as int64: step) as int64
```
- **Parâmetros**:
  - `counter` (`int64`): Parâmetro de entrada para processamento da operação.
  - `step` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `debugCounterIncrement` no domínio `DebugProfileContract`.

##### `op debugMetricRecord`
```flux
op debugMetricRecord (as string: name, as int64: value, as string: unit) as string
```
- **Parâmetros**:
  - `name` (`string`): Parâmetro de entrada para processamento da operação.
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
  - `unit` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `debugMetricRecord` no domínio `DebugProfileContract`.

##### `op debugProgress`
```flux
op debugProgress (as int64: current, as int64: total, as int64: width) as string
```
- **Parâmetros**:
  - `current` (`int64`): Parâmetro de entrada para processamento da operação.
  - `total` (`int64`): Parâmetro de entrada para processamento da operação.
  - `width` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `debugProgress` no domínio `DebugProfileContract`.

### 4.8 Contrato `DebugStateContract` (`DebugState.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `debugStateTransition` | `op debugStateTransition (as string: entity_name, as string: from_state, as string: to_state, as string: event_name) as string` | `string` |
| `debugStateAudit` | `op debugStateAudit (as string: current_state, as list of data: allowed_states) as bool` | `bool` |
| `debugBreadcrumb` | `op debugBreadcrumb (as string: trail, as string: new_event) as string` | `string` |

#### Ficha Técnica das Operações:

##### `op debugStateTransition`
```flux
op debugStateTransition (as string: entity_name, as string: from_state, as string: to_state, as string: event_name) as string
```
- **Parâmetros**:
  - `entity_name` (`string`): Parâmetro de entrada para processamento da operação.
  - `from_state` (`string`): Parâmetro de entrada para processamento da operação.
  - `to_state` (`string`): Parâmetro de entrada para processamento da operação.
  - `event_name` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `debugStateTransition` no domínio `DebugStateContract`.

##### `op debugStateAudit`
```flux
op debugStateAudit (as string: current_state, as list of data: allowed_states) as bool
```
- **Parâmetros**:
  - `current_state` (`string`): Parâmetro de entrada para processamento da operação.
  - `allowed_states` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `debugStateAudit` no domínio `DebugStateContract`.

##### `op debugBreadcrumb`
```flux
op debugBreadcrumb (as string: trail, as string: new_event) as string
```
- **Parâmetros**:
  - `trail` (`string`): Parâmetro de entrada para processamento da operação.
  - `new_event` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `debugBreadcrumb` no domínio `DebugStateContract`.

---

## 5. Exemplos Canônicos de Uso em TheFlux

O exemplo a seguir demonstra a importação e o consumo prático da biblioteca:

```flux
# Exemplo Canônico de Consumo da DebugStdLib
use DebugStdLib

program (ExemploDebugStdLib) {
      println("==================================================")
      println("  Demonstracao da Standard Library: DebugStdLib")
      println("==================================================")

      # Chamada da operacao canônica
      mut as data: resultado = DebugStdLib::debugInspect(42)
      println("Resultado obtido: " + resultado)

      println("Demonstracao concluida com sucesso.")
}
```

---

> [!TIP]
> Para consultar a visão arquitetural unificada de todas as bibliotecas, consulte o documento principal [StdLibs.md](../StdLibs.md).
