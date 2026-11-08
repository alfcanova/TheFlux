# 📚 `MapStdLib` — Mapas Associativos (Dicionários), Agregação e Consultas Rápidas

> **Pilar Arquitetural**: Pilar 2 (Estruturas & Estados)  
> **Status**: ✅ Homologado com 100% de Paridade nos 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Arquivo Mestre**: `stdlib/MapStdLib/MapStdLib.fdsl`  
> **Modo de Importação**: `use MapStdLib` ou `use MapStdLib::<Modulo>::<operacao>`

---

## 1. Visão Geral e Funcionalidades

A biblioteca padrão **`MapStdLib`** integra o ecossistema oficial da linguagem TheFlux, fornecendo suporte de nível de sistema e algoritmos nativos certificados.

Tabelas de dispersão chave-valor altamente otimizadas: inserção, consulta, remoção com tempo amortizado O(1), mesclagem de dicionários, inversão de chaves/valores, transformações funcionais e validação estrutural de esquemas de dados.

### 1.1 Características e Princípios de Design
- **Compilação e Fusão Estática**: Todos os módulos de domínio são fundidos no agente unificado `MapStdLib` em tempo de compilação, sem sobrecarga (*overhead*) de despacho indireto.
- **Isolamento e Segurança**: As operações verificam limites operacionais e utilizam despacho por contratos formais rigorosos.
- **Compatibilidade Multi-Backend**: Execução bit-a-bit idêntica em interpretador (`in`), bytecode (`vm`, `vmr`), nativo AOT (`llvm`) e WebAssembly (`wat`, `wasm`).

---

## 2. Estrutura Modular e Contratos

A biblioteca é composta por **10 módulos de domínio** e declara **79 operações públicas**:

| Arquivo de Domínio | Contrato Formal | Responsabilidade Principal | Qtd. Ops |
|---|---|---|:---:|
| `MapAccess.fdsl` | `MapAccessContract` | Domínio especializado de `MapAccess` | 12 |
| `MapAggregate.fdsl` | `MapAggregateContract` | Domínio especializado de `MapAggregate` | 6 |
| `MapBasic.fdsl` | `MapBasicContract` | Domínio especializado de `MapBasic` | 19 |
| `MapEntry.fdsl` | `MapEntryContract` | Domínio especializado de `MapEntry` | 5 |
| `MapMutation.fdsl` | `MapMutationContract` | Domínio especializado de `MapMutation` | 6 |
| `MapRelation.fdsl` | `MapRelationContract` | Domínio especializado de `MapRelation` | 5 |
| `MapSearch.fdsl` | `MapSearchContract` | Domínio especializado de `MapSearch` | 9 |
| `MapSelection.fdsl` | `MapSelectionContract` | Domínio especializado de `MapSelection` | 8 |
| `MapTransform.fdsl` | `MapTransformContract` | Domínio especializado de `MapTransform` | 5 |
| `MapUtility.fdsl` | `MapUtilityContract` | Domínio especializado de `MapUtility` | 4 |

---

## 3. Tipos, Estruturas e Enumerações Públicas

A biblioteca `MapStdLib` opera diretamente com os tipos nativos e primitivos da linguagem TheFlux (`string`, `int64`, `float64`, `bool`, `list of data`, etc.), sem exigir tipos compostos adicionais.

---

## 4. Catálogo Detalhado de Operações por Domínio

### 4.1 Contrato `MapAccessContract` (`MapAccess.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `mapGet` | `op mapGet (as map: record, as string: key) as data` | `data` |
| `mapGetOrDefault` | `op mapGetOrDefault (as map: record, as string: key, as data: default_value) as data` | `data` |
| `mapGetFirst` | `op mapGetFirst (as map: record) as list of data` | `list of data` |
| `mapGetAt` | `op mapGetAt (as map: record, as int64: index) as list of data` | `list of data` |
| `mapGetLast` | `op mapGetLast (as map: record) as list of data` | `list of data` |
| `mapGetLeft` | `op mapGetLeft (as map: record, as int64: n) as map` | `map` |
| `mapGetRight` | `op mapGetRight (as map: record, as int64: n) as map` | `map` |
| `mapGetCenter` | `op mapGetCenter (as map: record, as int64: n) as map` | `map` |
| `mapSlice` | `op mapSlice (as map: record, as int64: start, as int64: end) as map` | `map` |
| `mapKeys` | `op mapKeys (as map: record) as list of data` | `list of data` |
| `mapValues` | `op mapValues (as map: record) as list of data` | `list of data` |
| `mapEntries` | `op mapEntries (as map: record) as list of data` | `list of data` |

#### Ficha Técnica das Operações:

##### `op mapGet`
```flux
op mapGet (as map: record, as string: key) as data
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
  - `key` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapGet` no domínio `MapAccessContract`.

##### `op mapGetOrDefault`
```flux
op mapGetOrDefault (as map: record, as string: key, as data: default_value) as data
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
  - `key` (`string`): Parâmetro de entrada para processamento da operação.
  - `default_value` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapGetOrDefault` no domínio `MapAccessContract`.

##### `op mapGetFirst`
```flux
op mapGetFirst (as map: record) as list of data
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapGetFirst` no domínio `MapAccessContract`.

##### `op mapGetAt`
```flux
op mapGetAt (as map: record, as int64: index) as list of data
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
  - `index` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapGetAt` no domínio `MapAccessContract`.

##### `op mapGetLast`
```flux
op mapGetLast (as map: record) as list of data
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapGetLast` no domínio `MapAccessContract`.

##### `op mapGetLeft`
```flux
op mapGetLeft (as map: record, as int64: n) as map
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
  - `n` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapGetLeft` no domínio `MapAccessContract`.

##### `op mapGetRight`
```flux
op mapGetRight (as map: record, as int64: n) as map
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
  - `n` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapGetRight` no domínio `MapAccessContract`.

##### `op mapGetCenter`
```flux
op mapGetCenter (as map: record, as int64: n) as map
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
  - `n` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapGetCenter` no domínio `MapAccessContract`.

##### `op mapSlice`
```flux
op mapSlice (as map: record, as int64: start, as int64: end) as map
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
  - `start` (`int64`): Parâmetro de entrada para processamento da operação.
  - `end` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapSlice` no domínio `MapAccessContract`.

##### `op mapKeys`
```flux
op mapKeys (as map: record) as list of data
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapKeys` no domínio `MapAccessContract`.

##### `op mapValues`
```flux
op mapValues (as map: record) as list of data
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapValues` no domínio `MapAccessContract`.

##### `op mapEntries`
```flux
op mapEntries (as map: record) as list of data
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapEntries` no domínio `MapAccessContract`.

### 4.2 Contrato `MapAggregateContract` (`MapAggregate.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `mapMin` | `op mapMin (as map: record) as data` | `data` |
| `mapMax` | `op mapMax (as map: record) as data` | `data` |
| `mapSum` | `op mapSum (as map: record) as data` | `data` |
| `mapProduct` | `op mapProduct (as map: record) as data` | `data` |
| `mapAverage` | `op mapAverage (as map: record) as float64` | `float64` |
| `mapCountValues` | `op mapCountValues (as map: record, as data: value) as int64` | `int64` |

#### Ficha Técnica das Operações:

##### `op mapMin`
```flux
op mapMin (as map: record) as data
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapMin` no domínio `MapAggregateContract`.

##### `op mapMax`
```flux
op mapMax (as map: record) as data
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapMax` no domínio `MapAggregateContract`.

##### `op mapSum`
```flux
op mapSum (as map: record) as data
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapSum` no domínio `MapAggregateContract`.

##### `op mapProduct`
```flux
op mapProduct (as map: record) as data
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapProduct` no domínio `MapAggregateContract`.

##### `op mapAverage`
```flux
op mapAverage (as map: record) as float64
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapAverage` no domínio `MapAggregateContract`.

##### `op mapCountValues`
```flux
op mapCountValues (as map: record, as data: value) as int64
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
  - `value` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapCountValues` no domínio `MapAggregateContract`.

### 4.3 Contrato `MapBasicContract` (`MapBasic.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `mapLength` | `op mapLength (as map: record) as int64` | `int64` |
| `mapIsEmpty` | `op mapIsEmpty (as map: record) as bool` | `bool` |
| `mapIsNotEmpty` | `op mapIsNotEmpty (as map: record) as bool` | `bool` |
| `mapContainsKey` | `op mapContainsKey (as map: record, as string: key) as bool` | `bool` |
| `mapContainsAnyKey` | `op mapContainsAnyKey (as map: record, as list of data: keys) as bool` | `bool` |
| `mapContainsAllKeys` | `op mapContainsAllKeys (as map: record, as list of data: keys) as bool` | `bool` |
| `mapContainsValue` | `op mapContainsValue (as map: record, as data: value) as bool` | `bool` |
| `mapContainsAnyValue` | `op mapContainsAnyValue (as map: record, as list of data: values) as bool` | `bool` |
| `mapContainsAllValues` | `op mapContainsAllValues (as map: record, as list of data: values) as bool` | `bool` |
| `mapClearAll` | `op mapClearAll (as map: record) as map` | `map` |
| `mapSingleton` | `op mapSingleton (as string: key, as data: value) as map` | `map` |
| `mapClone` | `op mapClone (as map: record) as map` | `map` |
| `mapToList` | `op mapToList (as map: record) as list of data` | `list of data` |
| `mapToSet` | `op mapToSet (as map: record) as set of data` | `set of data` |
| `mapToMap` | `op mapToMap (as data: value) as map` | `map` |
| `mapToString` | `op mapToString (as map: record) as string` | `string` |
| `mapFromList` | `op mapFromList (as list of data: pairs) as map` | `map` |
| `mapFromSet` | `op mapFromSet (as set of data: pairs) as map` | `map` |
| `mapFromString` | `op mapFromString (as string: text) as map` | `map` |

#### Ficha Técnica das Operações:

##### `op mapLength`
```flux
op mapLength (as map: record) as int64
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapLength` no domínio `MapBasicContract`.

##### `op mapIsEmpty`
```flux
op mapIsEmpty (as map: record) as bool
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapIsEmpty` no domínio `MapBasicContract`.

##### `op mapIsNotEmpty`
```flux
op mapIsNotEmpty (as map: record) as bool
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapIsNotEmpty` no domínio `MapBasicContract`.

##### `op mapContainsKey`
```flux
op mapContainsKey (as map: record, as string: key) as bool
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
  - `key` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapContainsKey` no domínio `MapBasicContract`.

##### `op mapContainsAnyKey`
```flux
op mapContainsAnyKey (as map: record, as list of data: keys) as bool
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
  - `keys` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapContainsAnyKey` no domínio `MapBasicContract`.

##### `op mapContainsAllKeys`
```flux
op mapContainsAllKeys (as map: record, as list of data: keys) as bool
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
  - `keys` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapContainsAllKeys` no domínio `MapBasicContract`.

##### `op mapContainsValue`
```flux
op mapContainsValue (as map: record, as data: value) as bool
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
  - `value` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapContainsValue` no domínio `MapBasicContract`.

##### `op mapContainsAnyValue`
```flux
op mapContainsAnyValue (as map: record, as list of data: values) as bool
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
  - `values` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapContainsAnyValue` no domínio `MapBasicContract`.

##### `op mapContainsAllValues`
```flux
op mapContainsAllValues (as map: record, as list of data: values) as bool
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
  - `values` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapContainsAllValues` no domínio `MapBasicContract`.

##### `op mapClearAll`
```flux
op mapClearAll (as map: record) as map
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapClearAll` no domínio `MapBasicContract`.

##### `op mapSingleton`
```flux
op mapSingleton (as string: key, as data: value) as map
```
- **Parâmetros**:
  - `key` (`string`): Parâmetro de entrada para processamento da operação.
  - `value` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapSingleton` no domínio `MapBasicContract`.

##### `op mapClone`
```flux
op mapClone (as map: record) as map
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapClone` no domínio `MapBasicContract`.

##### `op mapToList`
```flux
op mapToList (as map: record) as list of data
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapToList` no domínio `MapBasicContract`.

##### `op mapToSet`
```flux
op mapToSet (as map: record) as set of data
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `set of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapToSet` no domínio `MapBasicContract`.

##### `op mapToMap`
```flux
op mapToMap (as data: value) as map
```
- **Parâmetros**:
  - `value` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapToMap` no domínio `MapBasicContract`.

##### `op mapToString`
```flux
op mapToString (as map: record) as string
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `": "`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapToString` no domínio `MapBasicContract`.

##### `op mapFromList`
```flux
op mapFromList (as list of data: pairs) as map
```
- **Parâmetros**:
  - `pairs` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapFromList` no domínio `MapBasicContract`.

##### `op mapFromSet`
```flux
op mapFromSet (as set of data: pairs) as map
```
- **Parâmetros**:
  - `pairs` (`set of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapFromSet` no domínio `MapBasicContract`.

##### `op mapFromString`
```flux
op mapFromString (as string: text) as map
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapFromString` no domínio `MapBasicContract`.

### 4.4 Contrato `MapEntryContract` (`MapEntry.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `mapFromEntries` | `op mapFromEntries (as list of data: entries) as map` | `map` |
| `mapToEntries` | `op mapToEntries (as map: record) as list of data` | `list of data` |
| `mapInvertMulti` | `op mapInvertMulti (as map: record) as map` | `map` |
| `mapGroupListBy` | `op mapGroupListBy (as list of data: items, as string: key_field) as map` | `map` |
| `mapSelectEntries` | `op mapSelectEntries (as map: record, as list of data: keys) as list of data` | `list of data` |

#### Ficha Técnica das Operações:

##### `op mapFromEntries`
```flux
op mapFromEntries (as list of data: entries) as map
```
- **Parâmetros**:
  - `entries` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapFromEntries` no domínio `MapEntryContract`.

##### `op mapToEntries`
```flux
op mapToEntries (as map: record) as list of data
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapToEntries` no domínio `MapEntryContract`.

##### `op mapInvertMulti`
```flux
op mapInvertMulti (as map: record) as map
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapInvertMulti` no domínio `MapEntryContract`.

##### `op mapGroupListBy`
```flux
op mapGroupListBy (as list of data: items, as string: key_field) as map
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `key_field` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapGroupListBy` no domínio `MapEntryContract`.

##### `op mapSelectEntries`
```flux
op mapSelectEntries (as map: record, as list of data: keys) as list of data
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
  - `keys` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapSelectEntries` no domínio `MapEntryContract`.

### 4.5 Contrato `MapMutationContract` (`MapMutation.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `mapPut` | `op mapPut (as map: record, as string: key, as data: value) as map` | `map` |
| `mapPutIfAbsent` | `op mapPutIfAbsent (as map: record, as string: key, as data: value) as map` | `map` |
| `mapReplace` | `op mapReplace (as map: record, as string: key, as data: value) as map` | `map` |
| `mapPutAll` | `op mapPutAll (as map: record, as map: other) as map` | `map` |
| `mapRemove` | `op mapRemove (as map: record, as string: key) as map` | `map` |
| `mapRemoveAll` | `op mapRemoveAll (as map: record, as list of data: keys) as map` | `map` |

#### Ficha Técnica das Operações:

##### `op mapPut`
```flux
op mapPut (as map: record, as string: key, as data: value) as map
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
  - `key` (`string`): Parâmetro de entrada para processamento da operação.
  - `value` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapPut` no domínio `MapMutationContract`.

##### `op mapPutIfAbsent`
```flux
op mapPutIfAbsent (as map: record, as string: key, as data: value) as map
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
  - `key` (`string`): Parâmetro de entrada para processamento da operação.
  - `value` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapPutIfAbsent` no domínio `MapMutationContract`.

##### `op mapReplace`
```flux
op mapReplace (as map: record, as string: key, as data: value) as map
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
  - `key` (`string`): Parâmetro de entrada para processamento da operação.
  - `value` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapReplace` no domínio `MapMutationContract`.

##### `op mapPutAll`
```flux
op mapPutAll (as map: record, as map: other) as map
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
  - `other` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapPutAll` no domínio `MapMutationContract`.

##### `op mapRemove`
```flux
op mapRemove (as map: record, as string: key) as map
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
  - `key` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapRemove` no domínio `MapMutationContract`.

##### `op mapRemoveAll`
```flux
op mapRemoveAll (as map: record, as list of data: keys) as map
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
  - `keys` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapRemoveAll` no domínio `MapMutationContract`.

### 4.6 Contrato `MapRelationContract` (`MapRelation.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `mapIsSubmap` | `op mapIsSubmap (as map: sub, as map: sup) as bool` | `bool` |
| `mapIsSupermap` | `op mapIsSupermap (as map: sup, as map: sub) as bool` | `bool` |
| `mapHasSameKeys` | `op mapHasSameKeys (as map: lhs, as map: rhs) as bool` | `bool` |
| `mapDisjointKeys` | `op mapDisjointKeys (as map: lhs, as map: rhs) as bool` | `bool` |
| `mapDiffKeys` | `op mapDiffKeys (as map: lhs, as map: rhs) as list of data` | `list of data` |

#### Ficha Técnica das Operações:

##### `op mapIsSubmap`
```flux
op mapIsSubmap (as map: sub, as map: sup) as bool
```
- **Parâmetros**:
  - `sub` (`map`): Parâmetro de entrada para processamento da operação.
  - `sup` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapIsSubmap` no domínio `MapRelationContract`.

##### `op mapIsSupermap`
```flux
op mapIsSupermap (as map: sup, as map: sub) as bool
```
- **Parâmetros**:
  - `sup` (`map`): Parâmetro de entrada para processamento da operação.
  - `sub` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapIsSupermap` no domínio `MapRelationContract`.

##### `op mapHasSameKeys`
```flux
op mapHasSameKeys (as map: lhs, as map: rhs) as bool
```
- **Parâmetros**:
  - `lhs` (`map`): Parâmetro de entrada para processamento da operação.
  - `rhs` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapHasSameKeys` no domínio `MapRelationContract`.

##### `op mapDisjointKeys`
```flux
op mapDisjointKeys (as map: lhs, as map: rhs) as bool
```
- **Parâmetros**:
  - `lhs` (`map`): Parâmetro de entrada para processamento da operação.
  - `rhs` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapDisjointKeys` no domínio `MapRelationContract`.

##### `op mapDiffKeys`
```flux
op mapDiffKeys (as map: lhs, as map: rhs) as list of data
```
- **Parâmetros**:
  - `lhs` (`map`): Parâmetro de entrada para processamento da operação.
  - `rhs` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapDiffKeys` no domínio `MapRelationContract`.

### 4.7 Contrato `MapSearchContract` (`MapSearch.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `mapContainsKey` | `op mapContainsKey (as map: record, as string: key) as bool` | `bool` |
| `mapContainsAnyKey` | `op mapContainsAnyKey (as map: record, as list of data: keys) as bool` | `bool` |
| `mapContainsAllKeys` | `op mapContainsAllKeys (as map: record, as list of data: keys) as bool` | `bool` |
| `mapContainsValue` | `op mapContainsValue (as map: record, as data: value) as bool` | `bool` |
| `mapContainsAnyValue` | `op mapContainsAnyValue (as map: record, as list of data: values) as bool` | `bool` |
| `mapContainsAllValues` | `op mapContainsAllValues (as map: record, as list of data: values) as bool` | `bool` |
| `mapFindKey` | `op mapFindKey (as map: record, as data: value) as data` | `data` |
| `mapFindKeys` | `op mapFindKeys (as map: record, as data: value) as list of data` | `list of data` |
| `mapCountValues` | `op mapCountValues (as map: record, as data: value) as int64` | `int64` |

#### Ficha Técnica das Operações:

##### `op mapContainsKey`
```flux
op mapContainsKey (as map: record, as string: key) as bool
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
  - `key` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapContainsKey` no domínio `MapSearchContract`.

##### `op mapContainsAnyKey`
```flux
op mapContainsAnyKey (as map: record, as list of data: keys) as bool
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
  - `keys` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapContainsAnyKey` no domínio `MapSearchContract`.

##### `op mapContainsAllKeys`
```flux
op mapContainsAllKeys (as map: record, as list of data: keys) as bool
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
  - `keys` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapContainsAllKeys` no domínio `MapSearchContract`.

##### `op mapContainsValue`
```flux
op mapContainsValue (as map: record, as data: value) as bool
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
  - `value` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapContainsValue` no domínio `MapSearchContract`.

##### `op mapContainsAnyValue`
```flux
op mapContainsAnyValue (as map: record, as list of data: values) as bool
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
  - `values` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapContainsAnyValue` no domínio `MapSearchContract`.

##### `op mapContainsAllValues`
```flux
op mapContainsAllValues (as map: record, as list of data: values) as bool
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
  - `values` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapContainsAllValues` no domínio `MapSearchContract`.

##### `op mapFindKey`
```flux
op mapFindKey (as map: record, as data: value) as data
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
  - `value` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapFindKey` no domínio `MapSearchContract`.

##### `op mapFindKeys`
```flux
op mapFindKeys (as map: record, as data: value) as list of data
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
  - `value` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapFindKeys` no domínio `MapSearchContract`.

##### `op mapCountValues`
```flux
op mapCountValues (as map: record, as data: value) as int64
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
  - `value` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapCountValues` no domínio `MapSearchContract`.

### 4.8 Contrato `MapSelectionContract` (`MapSelection.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `mapTake` | `op mapTake (as map: record, as int64: n) as map` | `map` |
| `mapDrop` | `op mapDrop (as map: record, as int64: n) as map` | `map` |
| `mapTakeLast` | `op mapTakeLast (as map: record, as int64: n) as map` | `map` |
| `mapDropLast` | `op mapDropLast (as map: record, as int64: n) as map` | `map` |
| `mapFilterKeys` | `op mapFilterKeys (as map: record, as list of data: allowed_keys) as map` | `map` |
| `mapOmitKeys` | `op mapOmitKeys (as map: record, as list of data: omitted_keys) as map` | `map` |
| `mapFilterValues` | `op mapFilterValues (as map: record, as list of data: allowed_values) as map` | `map` |
| `mapOmitValues` | `op mapOmitValues (as map: record, as list of data: omitted_values) as map` | `map` |

#### Ficha Técnica das Operações:

##### `op mapTake`
```flux
op mapTake (as map: record, as int64: n) as map
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
  - `n` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapTake` no domínio `MapSelectionContract`.

##### `op mapDrop`
```flux
op mapDrop (as map: record, as int64: n) as map
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
  - `n` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapDrop` no domínio `MapSelectionContract`.

##### `op mapTakeLast`
```flux
op mapTakeLast (as map: record, as int64: n) as map
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
  - `n` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapTakeLast` no domínio `MapSelectionContract`.

##### `op mapDropLast`
```flux
op mapDropLast (as map: record, as int64: n) as map
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
  - `n` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapDropLast` no domínio `MapSelectionContract`.

##### `op mapFilterKeys`
```flux
op mapFilterKeys (as map: record, as list of data: allowed_keys) as map
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
  - `allowed_keys` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapFilterKeys` no domínio `MapSelectionContract`.

##### `op mapOmitKeys`
```flux
op mapOmitKeys (as map: record, as list of data: omitted_keys) as map
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
  - `omitted_keys` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapOmitKeys` no domínio `MapSelectionContract`.

##### `op mapFilterValues`
```flux
op mapFilterValues (as map: record, as list of data: allowed_values) as map
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
  - `allowed_values` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapFilterValues` no domínio `MapSelectionContract`.

##### `op mapOmitValues`
```flux
op mapOmitValues (as map: record, as list of data: omitted_values) as map
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
  - `omitted_values` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapOmitValues` no domínio `MapSelectionContract`.

### 4.9 Contrato `MapTransformContract` (`MapTransform.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `mapMerge` | `op mapMerge (as map: left, as map: right) as map` | `map` |
| `mapInvert` | `op mapInvert (as map: record) as map` | `map` |
| `mapZip` | `op mapZip (as list of data: keys, as list of data: values) as map` | `map` |
| `mapFilterKeys` | `op mapFilterKeys (as map: record, as list of data: allowed_keys) as map` | `map` |
| `mapOmitKeys` | `op mapOmitKeys (as map: record, as list of data: omitted_keys) as map` | `map` |

#### Ficha Técnica das Operações:

##### `op mapMerge`
```flux
op mapMerge (as map: left, as map: right) as map
```
- **Parâmetros**:
  - `left` (`map`): Parâmetro de entrada para processamento da operação.
  - `right` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapMerge` no domínio `MapTransformContract`.

##### `op mapInvert`
```flux
op mapInvert (as map: record) as map
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapInvert` no domínio `MapTransformContract`.

##### `op mapZip`
```flux
op mapZip (as list of data: keys, as list of data: values) as map
```
- **Parâmetros**:
  - `keys` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `values` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapZip` no domínio `MapTransformContract`.

##### `op mapFilterKeys`
```flux
op mapFilterKeys (as map: record, as list of data: allowed_keys) as map
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
  - `allowed_keys` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapFilterKeys` no domínio `MapTransformContract`.

##### `op mapOmitKeys`
```flux
op mapOmitKeys (as map: record, as list of data: omitted_keys) as map
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
  - `omitted_keys` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapOmitKeys` no domínio `MapTransformContract`.

### 4.10 Contrato `MapUtilityContract` (`MapUtility.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `mapEquals` | `op mapEquals (as map: lhs, as map: rhs) as bool` | `bool` |
| `mapSwapKeys` | `op mapSwapKeys (as map: record, as string: key1, as string: key2) as map` | `map` |
| `mapJoin` | `op mapJoin (as map: record, as string: entry_sep, as string: kv_sep) as string` | `string` |
| `mapCount` | `op mapCount (as map: record, as string: key) as int64` | `int64` |

#### Ficha Técnica das Operações:

##### `op mapEquals`
```flux
op mapEquals (as map: lhs, as map: rhs) as bool
```
- **Parâmetros**:
  - `lhs` (`map`): Parâmetro de entrada para processamento da operação.
  - `rhs` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapEquals` no domínio `MapUtilityContract`.

##### `op mapSwapKeys`
```flux
op mapSwapKeys (as map: record, as string: key1, as string: key2) as map
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
  - `key1` (`string`): Parâmetro de entrada para processamento da operação.
  - `key2` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapSwapKeys` no domínio `MapUtilityContract`.

##### `op mapJoin`
```flux
op mapJoin (as map: record, as string: entry_sep, as string: kv_sep) as string
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
  - `entry_sep` (`string`): Parâmetro de entrada para processamento da operação.
  - `kv_sep` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapJoin` no domínio `MapUtilityContract`.

##### `op mapCount`
```flux
op mapCount (as map: record, as string: key) as int64
```
- **Parâmetros**:
  - `record` (`map`): Parâmetro de entrada para processamento da operação.
  - `key` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapCount` no domínio `MapUtilityContract`.

---

## 5. Exemplos Canônicos de Uso em TheFlux

O exemplo a seguir demonstra a importação e o consumo prático da biblioteca:

```flux
# Exemplo Canônico de Consumo da MapStdLib
use MapStdLib

program (ExemploMapStdLib) {
      println("==================================================")
      println("  Demonstracao da Standard Library: MapStdLib")
      println("==================================================")

      # Chamada da operacao canônica
      mut as data: resultado = MapStdLib::mapCount({})
      println("Resultado obtido: " + resultado)

      println("Demonstracao concluida com sucesso.")
}
```

---

> [!TIP]
> Para consultar a visão arquitetural unificada de todas as bibliotecas, consulte o documento principal [StdLibs.md](../StdLibs.md).
