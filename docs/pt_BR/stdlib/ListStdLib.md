# 📚 `ListStdLib` — Manipulação Funcional de Listas, Agregação e Mutações

> **Pilar Arquitetural**: Pilar 2 (Estruturas & Estados)  
> **Status**: ✅ Homologado com 100% de Paridade nos 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Arquivo Mestre**: `stdlib/ListStdLib/ListStdLib.fdsl`  
> **Modo de Importação**: `use ListStdLib` ou `use ListStdLib::<Modulo>::<operacao>`

---

## 1. Visão Geral e Funcionalidades

A biblioteca padrão **`ListStdLib`** integra o ecossistema oficial da linguagem TheFlux, fornecendo suporte de nível de sistema e algoritmos nativos certificados.

Operações funcionais e imperativas sobre sequências lineares: mapeamento (`map`), filtragem (`filter`), redução (`fold`), ordenação determinística, partições, busca linear/binária e mutações eficientes com reaproveitamento de buffer.

### 1.1 Características e Princípios de Design
- **Compilação e Fusão Estática**: Todos os módulos de domínio são fundidos no agente unificado `ListStdLib` em tempo de compilação, sem sobrecarga (*overhead*) de despacho indireto.
- **Isolamento e Segurança**: As operações verificam limites operacionais e utilizam despacho por contratos formais rigorosos.
- **Compatibilidade Multi-Backend**: Execução bit-a-bit idêntica em interpretador (`in`), bytecode (`vm`, `vmr`), nativo AOT (`llvm`) e WebAssembly (`wat`, `wasm`).

---

## 2. Estrutura Modular e Contratos

A biblioteca é composta por **9 módulos de domínio** e declara **81 operações públicas**:

| Arquivo de Domínio | Contrato Formal | Responsabilidade Principal | Qtd. Ops |
|---|---|---|:---:|
| `ListAccess.fdsl` | `ListAccessContract` | Domínio especializado de `ListAccess` | 7 |
| `ListAggregate.fdsl` | `ListAggregateContract` | Domínio especializado de `ListAggregate` | 6 |
| `ListBasic.fdsl` | `ListBasicContract` | Domínio especializado de `ListBasic` | 18 |
| `ListCombinator.fdsl` | `ListCombinatorContract` | Domínio especializado de `ListCombinator` | 5 |
| `ListMutation.fdsl` | `ListMutationContract` | Domínio especializado de `ListMutation` | 13 |
| `ListSearch.fdsl` | `ListSearchContract` | Domínio especializado de `ListSearch` | 8 |
| `ListSelection.fdsl` | `ListSelectionContract` | Domínio especializado de `ListSelection` | 7 |
| `ListTransform.fdsl` | `ListTransformContract` | Domínio especializado de `ListTransform` | 10 |
| `ListUtility.fdsl` | `ListUtilityContract` | Domínio especializado de `ListUtility` | 7 |

---

## 3. Tipos, Estruturas e Enumerações Públicas

A biblioteca `ListStdLib` opera diretamente com os tipos nativos e primitivos da linguagem TheFlux (`string`, `int64`, `float64`, `bool`, `list of data`, etc.), sem exigir tipos compostos adicionais.

---

## 4. Catálogo Detalhado de Operações por Domínio

### 4.1 Contrato `ListAccessContract` (`ListAccess.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `listGetFirst` | `op listGetFirst (as list of data: items) as data` | `data` |
| `listGetAt` | `op listGetAt (as list of data: items, as int64: index) as data` | `data` |
| `listGetLast` | `op listGetLast (as list of data: items) as data` | `data` |
| `listGetLeft` | `op listGetLeft (as list of data: items, as int64: n) as list of data` | `list of data` |
| `listGetRight` | `op listGetRight (as list of data: items, as int64: n) as list of data` | `list of data` |
| `listGetCenter` | `op listGetCenter (as list of data: items, as int64: n) as list of data` | `list of data` |
| `listSlice` | `op listSlice (as list of data: items, as int64: start, as int64: end) as list of data` | `list of data` |

#### Ficha Técnica das Operações:

##### `op listGetFirst`
```flux
op listGetFirst (as list of data: items) as data
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listGetFirst` no domínio `ListAccessContract`.

##### `op listGetAt`
```flux
op listGetAt (as list of data: items, as int64: index) as data
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `index` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listGetAt` no domínio `ListAccessContract`.

##### `op listGetLast`
```flux
op listGetLast (as list of data: items) as data
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listGetLast` no domínio `ListAccessContract`.

##### `op listGetLeft`
```flux
op listGetLeft (as list of data: items, as int64: n) as list of data
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `n` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listGetLeft` no domínio `ListAccessContract`.

##### `op listGetRight`
```flux
op listGetRight (as list of data: items, as int64: n) as list of data
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `n` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listGetRight` no domínio `ListAccessContract`.

##### `op listGetCenter`
```flux
op listGetCenter (as list of data: items, as int64: n) as list of data
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `n` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listGetCenter` no domínio `ListAccessContract`.

##### `op listSlice`
```flux
op listSlice (as list of data: items, as int64: start, as int64: end) as list of data
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `start` (`int64`): Parâmetro de entrada para processamento da operação.
  - `end` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listSlice` no domínio `ListAccessContract`.

### 4.2 Contrato `ListAggregateContract` (`ListAggregate.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `listMin` | `op listMin (as list of data: items) as data` | `data` |
| `listMax` | `op listMax (as list of data: items) as data` | `data` |
| `listSum` | `op listSum (as list of data: items) as data` | `data` |
| `listProduct` | `op listProduct (as list of data: items) as data` | `data` |
| `listAverage` | `op listAverage (as list of data: items) as float64` | `float64` |
| `listCountValues` | `op listCountValues (as list of data: items, as data: value) as int64` | `int64` |

#### Ficha Técnica das Operações:

##### `op listMin`
```flux
op listMin (as list of data: items) as data
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listMin` no domínio `ListAggregateContract`.

##### `op listMax`
```flux
op listMax (as list of data: items) as data
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listMax` no domínio `ListAggregateContract`.

##### `op listSum`
```flux
op listSum (as list of data: items) as data
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listSum` no domínio `ListAggregateContract`.

##### `op listProduct`
```flux
op listProduct (as list of data: items) as data
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listProduct` no domínio `ListAggregateContract`.

##### `op listAverage`
```flux
op listAverage (as list of data: items) as float64
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listAverage` no domínio `ListAggregateContract`.

##### `op listCountValues`
```flux
op listCountValues (as list of data: items, as data: value) as int64
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `value` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listCountValues` no domínio `ListAggregateContract`.

### 4.3 Contrato `ListBasicContract` (`ListBasic.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `listLength` | `op listLength (as list of data: value) as int64` | `int64` |
| `listIsEmpty` | `op listIsEmpty (as list of data: value) as bool` | `bool` |
| `listIsNotEmpty` | `op listIsNotEmpty (as list of data: value) as bool` | `bool` |
| `listContains` | `op listContains (as list of data: value, as data: item) as bool` | `bool` |
| `listContainsAny` | `op listContainsAny (as list of data: value, as list of data: items) as bool` | `bool` |
| `listContainsAll` | `op listContainsAll (as list of data: items, as list of data: subset) as bool` | `bool` |
| `listClearAll` | `op listClearAll (as list of data: value) as list of data` | `list of data` |
| `listSingleton` | `op listSingleton (as data: value) as list of data` | `list of data` |
| `listSingletonInt` | `op listSingletonInt (as int64: value) as list of data` | `list of data` |
| `listSingletonString` | `op listSingletonString (as string: value) as list of data` | `list of data` |
| `listClone` | `op listClone (as list of data: value) as list of data` | `list of data` |
| `listToList` | `op listToList (as data: value) as list of data` | `list of data` |
| `listToSet` | `op listToSet (as data: value) as set of data` | `set of data` |
| `listToMap` | `op listToMap (as list of data: value) as map` | `map` |
| `listToString` | `op listToString (as list of data: value) as string` | `string` |
| `listFromList` | `op listFromList (as list of data: items) as list of data` | `list of data` |
| `listFromSet` | `op listFromSet (as set of data: items) as list of data` | `list of data` |
| `listFromString` | `op listFromString (as string: text) as list of data` | `list of data` |

#### Ficha Técnica das Operações:

##### `op listLength`
```flux
op listLength (as list of data: value) as int64
```
- **Parâmetros**:
  - `value` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listLength` no domínio `ListBasicContract`.

##### `op listIsEmpty`
```flux
op listIsEmpty (as list of data: value) as bool
```
- **Parâmetros**:
  - `value` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listIsEmpty` no domínio `ListBasicContract`.

##### `op listIsNotEmpty`
```flux
op listIsNotEmpty (as list of data: value) as bool
```
- **Parâmetros**:
  - `value` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listIsNotEmpty` no domínio `ListBasicContract`.

##### `op listContains`
```flux
op listContains (as list of data: value, as data: item) as bool
```
- **Parâmetros**:
  - `value` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `item` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listContains` no domínio `ListBasicContract`.

##### `op listContainsAny`
```flux
op listContainsAny (as list of data: value, as list of data: items) as bool
```
- **Parâmetros**:
  - `value` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listContainsAny` no domínio `ListBasicContract`.

##### `op listContainsAll`
```flux
op listContainsAll (as list of data: items, as list of data: subset) as bool
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `subset` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listContainsAll` no domínio `ListBasicContract`.

##### `op listClearAll`
```flux
op listClearAll (as list of data: value) as list of data
```
- **Parâmetros**:
  - `value` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listClearAll` no domínio `ListBasicContract`.

##### `op listSingleton`
```flux
op listSingleton (as data: value) as list of data
```
- **Parâmetros**:
  - `value` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listSingleton` no domínio `ListBasicContract`.

##### `op listSingletonInt`
```flux
op listSingletonInt (as int64: value) as list of data
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listSingletonInt` no domínio `ListBasicContract`.

##### `op listSingletonString`
```flux
op listSingletonString (as string: value) as list of data
```
- **Parâmetros**:
  - `value` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listSingletonString` no domínio `ListBasicContract`.

##### `op listClone`
```flux
op listClone (as list of data: value) as list of data
```
- **Parâmetros**:
  - `value` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listClone` no domínio `ListBasicContract`.

##### `op listToList`
```flux
op listToList (as data: value) as list of data
```
- **Parâmetros**:
  - `value` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listToList` no domínio `ListBasicContract`.

##### `op listToSet`
```flux
op listToSet (as data: value) as set of data
```
- **Parâmetros**:
  - `value` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `set of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listToSet` no domínio `ListBasicContract`.

##### `op listToMap`
```flux
op listToMap (as list of data: value) as map
```
- **Parâmetros**:
  - `value` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listToMap` no domínio `ListBasicContract`.

##### `op listToString`
```flux
op listToString (as list of data: value) as string
```
- **Parâmetros**:
  - `value` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `", "`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listToString` no domínio `ListBasicContract`.

##### `op listFromList`
```flux
op listFromList (as list of data: items) as list of data
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listFromList` no domínio `ListBasicContract`.

##### `op listFromSet`
```flux
op listFromSet (as set of data: items) as list of data
```
- **Parâmetros**:
  - `items` (`set of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listFromSet` no domínio `ListBasicContract`.

##### `op listFromString`
```flux
op listFromString (as string: text) as list of data
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listFromString` no domínio `ListBasicContract`.

### 4.4 Contrato `ListCombinatorContract` (`ListCombinator.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `listChunk` | `op listChunk (as list of data: items, as int64: size) as list of data` | `list of data` |
| `listWindow` | `op listWindow (as list of data: items, as int64: size) as list of data` | `list of data` |
| `listFrequencies` | `op listFrequencies (as list of data: items) as map` | `map` |
| `listCartesian` | `op listCartesian (as list of data: lhs, as list of data: rhs) as list of data` | `list of data` |
| `listCombinations` | `op listCombinations (as list of data: items, as int64: k) as list of data` | `list of data` |

#### Ficha Técnica das Operações:

##### `op listChunk`
```flux
op listChunk (as list of data: items, as int64: size) as list of data
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `size` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listChunk` no domínio `ListCombinatorContract`.

##### `op listWindow`
```flux
op listWindow (as list of data: items, as int64: size) as list of data
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `size` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listWindow` no domínio `ListCombinatorContract`.

##### `op listFrequencies`
```flux
op listFrequencies (as list of data: items) as map
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listFrequencies` no domínio `ListCombinatorContract`.

##### `op listCartesian`
```flux
op listCartesian (as list of data: lhs, as list of data: rhs) as list of data
```
- **Parâmetros**:
  - `lhs` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `rhs` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listCartesian` no domínio `ListCombinatorContract`.

##### `op listCombinations`
```flux
op listCombinations (as list of data: items, as int64: k) as list of data
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `k` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listCombinations` no domínio `ListCombinatorContract`.

### 4.5 Contrato `ListMutationContract` (`ListMutation.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `listPushFront` | `op listPushFront (as list of data: items, as data: item) as list of data` | `list of data` |
| `listPushBack` | `op listPushBack (as list of data: items, as data: item) as list of data` | `list of data` |
| `listPrepend` | `op listPrepend (as list of data: items, as list of data: other) as list of data` | `list of data` |
| `listAppend` | `op listAppend (as list of data: items, as list of data: other) as list of data` | `list of data` |
| `listInsertFirst` | `op listInsertFirst (as list of data: items, as data: item) as list of data` | `list of data` |
| `listInsertAt` | `op listInsertAt (as list of data: items, as int64: index, as data: item) as list of data` | `list of data` |
| `listInsertLast` | `op listInsertLast (as list of data: items, as data: item) as list of data` | `list of data` |
| `listInsertAll` | `op listInsertAll (as list of data: items, as int64: index, as list of data: other) as list of data` | `list of data` |
| `listRemoveFirst` | `op listRemoveFirst (as list of data: items) as list of data` | `list of data` |
| `listRemoveAt` | `op listRemoveAt (as list of data: items, as int64: index) as list of data` | `list of data` |
| `listRemoveLast` | `op listRemoveLast (as list of data: items) as list of data` | `list of data` |
| `listRemove` | `op listRemove (as list of data: items, as data: item) as list of data` | `list of data` |
| `listRemoveAll` | `op listRemoveAll (as list of data: items, as data: item) as list of data` | `list of data` |

#### Ficha Técnica das Operações:

##### `op listPushFront`
```flux
op listPushFront (as list of data: items, as data: item) as list of data
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `item` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listPushFront` no domínio `ListMutationContract`.

##### `op listPushBack`
```flux
op listPushBack (as list of data: items, as data: item) as list of data
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `item` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listPushBack` no domínio `ListMutationContract`.

##### `op listPrepend`
```flux
op listPrepend (as list of data: items, as list of data: other) as list of data
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `other` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listPrepend` no domínio `ListMutationContract`.

##### `op listAppend`
```flux
op listAppend (as list of data: items, as list of data: other) as list of data
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `other` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listAppend` no domínio `ListMutationContract`.

##### `op listInsertFirst`
```flux
op listInsertFirst (as list of data: items, as data: item) as list of data
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `item` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listInsertFirst` no domínio `ListMutationContract`.

##### `op listInsertAt`
```flux
op listInsertAt (as list of data: items, as int64: index, as data: item) as list of data
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `index` (`int64`): Parâmetro de entrada para processamento da operação.
  - `item` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listInsertAt` no domínio `ListMutationContract`.

##### `op listInsertLast`
```flux
op listInsertLast (as list of data: items, as data: item) as list of data
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `item` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listInsertLast` no domínio `ListMutationContract`.

##### `op listInsertAll`
```flux
op listInsertAll (as list of data: items, as int64: index, as list of data: other) as list of data
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `index` (`int64`): Parâmetro de entrada para processamento da operação.
  - `other` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listInsertAll` no domínio `ListMutationContract`.

##### `op listRemoveFirst`
```flux
op listRemoveFirst (as list of data: items) as list of data
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listRemoveFirst` no domínio `ListMutationContract`.

##### `op listRemoveAt`
```flux
op listRemoveAt (as list of data: items, as int64: index) as list of data
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `index` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listRemoveAt` no domínio `ListMutationContract`.

##### `op listRemoveLast`
```flux
op listRemoveLast (as list of data: items) as list of data
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listRemoveLast` no domínio `ListMutationContract`.

##### `op listRemove`
```flux
op listRemove (as list of data: items, as data: item) as list of data
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `item` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listRemove` no domínio `ListMutationContract`.

##### `op listRemoveAll`
```flux
op listRemoveAll (as list of data: items, as data: item) as list of data
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `item` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listRemoveAll` no domínio `ListMutationContract`.

### 4.6 Contrato `ListSearchContract` (`ListSearch.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `listContains` | `op listContains (as list of data: items, as data: item) as bool` | `bool` |
| `listContainsAny` | `op listContainsAny (as list of data: items, as list of data: needles) as bool` | `bool` |
| `listContainsAll` | `op listContainsAll (as list of data: items, as list of data: subset) as bool` | `bool` |
| `listStartsWith` | `op listStartsWith (as list of data: items, as list of data: prefix) as bool` | `bool` |
| `listEndsWith` | `op listEndsWith (as list of data: items, as list of data: suffix) as bool` | `bool` |
| `listIndexOf` | `op listIndexOf (as list of data: items, as data: item) as int64` | `int64` |
| `listLastIndexOf` | `op listLastIndexOf (as list of data: items, as data: item) as int64` | `int64` |
| `listCount` | `op listCount (as list of data: items, as data: item) as int64` | `int64` |

#### Ficha Técnica das Operações:

##### `op listContains`
```flux
op listContains (as list of data: items, as data: item) as bool
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `item` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listContains` no domínio `ListSearchContract`.

##### `op listContainsAny`
```flux
op listContainsAny (as list of data: items, as list of data: needles) as bool
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `needles` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listContainsAny` no domínio `ListSearchContract`.

##### `op listContainsAll`
```flux
op listContainsAll (as list of data: items, as list of data: subset) as bool
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `subset` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listContainsAll` no domínio `ListSearchContract`.

##### `op listStartsWith`
```flux
op listStartsWith (as list of data: items, as list of data: prefix) as bool
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `prefix` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listStartsWith` no domínio `ListSearchContract`.

##### `op listEndsWith`
```flux
op listEndsWith (as list of data: items, as list of data: suffix) as bool
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `suffix` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listEndsWith` no domínio `ListSearchContract`.

##### `op listIndexOf`
```flux
op listIndexOf (as list of data: items, as data: item) as int64
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `item` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listIndexOf` no domínio `ListSearchContract`.

##### `op listLastIndexOf`
```flux
op listLastIndexOf (as list of data: items, as data: item) as int64
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `item` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listLastIndexOf` no domínio `ListSearchContract`.

##### `op listCount`
```flux
op listCount (as list of data: items, as data: item) as int64
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `item` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listCount` no domínio `ListSearchContract`.

### 4.7 Contrato `ListSelectionContract` (`ListSelection.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `listTake` | `op listTake (as list of data: items, as int64: n) as list of data` | `list of data` |
| `listDrop` | `op listDrop (as list of data: items, as int64: n) as list of data` | `list of data` |
| `listTakeLast` | `op listTakeLast (as list of data: items, as int64: n) as list of data` | `list of data` |
| `listDropLast` | `op listDropLast (as list of data: items, as int64: n) as list of data` | `list of data` |
| `listFilter` | `op listFilter (as list of data: items, as list of data: allowed_items) as list of data` | `list of data` |
| `listOmit` | `op listOmit (as list of data: items, as list of data: omitted_items) as list of data` | `list of data` |
| `listDistinct` | `op listDistinct (as list of data: items) as list of data` | `list of data` |

#### Ficha Técnica das Operações:

##### `op listTake`
```flux
op listTake (as list of data: items, as int64: n) as list of data
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `n` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listTake` no domínio `ListSelectionContract`.

##### `op listDrop`
```flux
op listDrop (as list of data: items, as int64: n) as list of data
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `n` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listDrop` no domínio `ListSelectionContract`.

##### `op listTakeLast`
```flux
op listTakeLast (as list of data: items, as int64: n) as list of data
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `n` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listTakeLast` no domínio `ListSelectionContract`.

##### `op listDropLast`
```flux
op listDropLast (as list of data: items, as int64: n) as list of data
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `n` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listDropLast` no domínio `ListSelectionContract`.

##### `op listFilter`
```flux
op listFilter (as list of data: items, as list of data: allowed_items) as list of data
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `allowed_items` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listFilter` no domínio `ListSelectionContract`.

##### `op listOmit`
```flux
op listOmit (as list of data: items, as list of data: omitted_items) as list of data
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `omitted_items` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listOmit` no domínio `ListSelectionContract`.

##### `op listDistinct`
```flux
op listDistinct (as list of data: items) as list of data
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listDistinct` no domínio `ListSelectionContract`.

### 4.8 Contrato `ListTransformContract` (`ListTransform.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `listSort` | `op listSort (as list of data: items) as list of data` | `list of data` |
| `listSortAscending` | `op listSortAscending (as list of data: items) as list of data` | `list of data` |
| `listSortDescending` | `op listSortDescending (as list of data: items) as list of data` | `list of data` |
| `listReverse` | `op listReverse (as list of data: items) as list of data` | `list of data` |
| `listRotateLeft` | `op listRotateLeft (as list of data: items, as int64: n) as list of data` | `list of data` |
| `listRotateRight` | `op listRotateRight (as list of data: items, as int64: n) as list of data` | `list of data` |
| `listFlatten` | `op listFlatten (as list of data: items) as list of data` | `list of data` |
| `listPartition` | `op listPartition (as list of data: items, as int64: size) as list of data` | `list of data` |
| `listZip` | `op listZip (as list of data: left, as list of data: right) as list of data` | `list of data` |
| `listUnzip` | `op listUnzip (as list of data: pairs) as list of data` | `list of data` |

#### Ficha Técnica das Operações:

##### `op listSort`
```flux
op listSort (as list of data: items) as list of data
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listSort` no domínio `ListTransformContract`.

##### `op listSortAscending`
```flux
op listSortAscending (as list of data: items) as list of data
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listSortAscending` no domínio `ListTransformContract`.

##### `op listSortDescending`
```flux
op listSortDescending (as list of data: items) as list of data
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listSortDescending` no domínio `ListTransformContract`.

##### `op listReverse`
```flux
op listReverse (as list of data: items) as list of data
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listReverse` no domínio `ListTransformContract`.

##### `op listRotateLeft`
```flux
op listRotateLeft (as list of data: items, as int64: n) as list of data
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `n` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listRotateLeft` no domínio `ListTransformContract`.

##### `op listRotateRight`
```flux
op listRotateRight (as list of data: items, as int64: n) as list of data
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `n` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listRotateRight` no domínio `ListTransformContract`.

##### `op listFlatten`
```flux
op listFlatten (as list of data: items) as list of data
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listFlatten` no domínio `ListTransformContract`.

##### `op listPartition`
```flux
op listPartition (as list of data: items, as int64: size) as list of data
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `size` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listPartition` no domínio `ListTransformContract`.

##### `op listZip`
```flux
op listZip (as list of data: left, as list of data: right) as list of data
```
- **Parâmetros**:
  - `left` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `right` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listZip` no domínio `ListTransformContract`.

##### `op listUnzip`
```flux
op listUnzip (as list of data: pairs) as list of data
```
- **Parâmetros**:
  - `pairs` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listUnzip` no domínio `ListTransformContract`.

### 4.9 Contrato `ListUtilityContract` (`ListUtility.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `listEquals` | `op listEquals (as list of data: lhs, as list of data: rhs) as bool` | `bool` |
| `listJoin` | `op listJoin (as list of data: items, as string: separator) as string` | `string` |
| `listSwap` | `op listSwap (as list of data: items, as int64: i, as int64: j) as list of data` | `list of data` |
| `listReplaceAt` | `op listReplaceAt (as list of data: items, as int64: index, as data: item) as list of data` | `list of data` |
| `listConcat` | `op listConcat (as list of data: left, as list of data: right) as list of data` | `list of data` |
| `listRepeat` | `op listRepeat (as data: item, as int64: count) as list of data` | `list of data` |
| `listFill` | `op listFill (as list of data: items, as data: value) as list of data` | `list of data` |

#### Ficha Técnica das Operações:

##### `op listEquals`
```flux
op listEquals (as list of data: lhs, as list of data: rhs) as bool
```
- **Parâmetros**:
  - `lhs` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `rhs` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listEquals` no domínio `ListUtilityContract`.

##### `op listJoin`
```flux
op listJoin (as list of data: items, as string: separator) as string
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `separator` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listJoin` no domínio `ListUtilityContract`.

##### `op listSwap`
```flux
op listSwap (as list of data: items, as int64: i, as int64: j) as list of data
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `i` (`int64`): Parâmetro de entrada para processamento da operação.
  - `j` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listSwap` no domínio `ListUtilityContract`.

##### `op listReplaceAt`
```flux
op listReplaceAt (as list of data: items, as int64: index, as data: item) as list of data
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `index` (`int64`): Parâmetro de entrada para processamento da operação.
  - `item` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listReplaceAt` no domínio `ListUtilityContract`.

##### `op listConcat`
```flux
op listConcat (as list of data: left, as list of data: right) as list of data
```
- **Parâmetros**:
  - `left` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `right` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listConcat` no domínio `ListUtilityContract`.

##### `op listRepeat`
```flux
op listRepeat (as data: item, as int64: count) as list of data
```
- **Parâmetros**:
  - `item` (`data`): Parâmetro de entrada para processamento da operação.
  - `count` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listRepeat` no domínio `ListUtilityContract`.

##### `op listFill`
```flux
op listFill (as list of data: items, as data: value) as list of data
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `value` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listFill` no domínio `ListUtilityContract`.

---

## 5. Exemplos Canônicos de Uso em TheFlux

O exemplo a seguir demonstra a importação e o consumo prático da biblioteca:

```flux
# Exemplo Canônico de Consumo da ListStdLib
use ListStdLib

program (ExemploListStdLib) {
      println("==================================================")
      println("  Demonstracao da Standard Library: ListStdLib")
      println("==================================================")

      # Chamada da operacao canônica
      mut as data: resultado = ListStdLib::listLength([])
      println("Resultado obtido: " + resultado)

      println("Demonstracao concluida com sucesso.")
}
```

---

> [!TIP]
> Para consultar a visão arquitetural unificada de todas as bibliotecas, consulte o documento principal [StdLibs.md](../StdLibs.md).
