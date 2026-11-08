# 📚 `SetStdLib` — Álgebra de Conjuntos, Operações Matemáticas e Pertinência

> **Pilar Arquitetural**: Pilar 2 (Estruturas & Estados)  
> **Status**: ✅ Homologado com 100% de Paridade nos 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Arquivo Mestre**: `stdlib/SetStdLib/SetStdLib.fdsl`  
> **Modo de Importação**: `use SetStdLib` ou `use SetStdLib::<Modulo>::<operacao>`

---

## 1. Visão Geral e Funcionalidades

A biblioteca padrão **`SetStdLib`** integra o ecossistema oficial da linguagem TheFlux, fornecendo suporte de nível de sistema e algoritmos nativos certificados.

Estruturas e algoritmos para álgebra de conjuntos matemáticos: união, interseção, diferença assimétrica, diferença simétrica, predicados de pertinência, teste de subconjunto e remoção de duplicatas.

### 1.1 Características e Princípios de Design
- **Compilação e Fusão Estática**: Todos os módulos de domínio são fundidos no agente unificado `SetStdLib` em tempo de compilação, sem sobrecarga (*overhead*) de despacho indireto.
- **Isolamento e Segurança**: As operações verificam limites operacionais e utilizam despacho por contratos formais rigorosos.
- **Compatibilidade Multi-Backend**: Execução bit-a-bit idêntica em interpretador (`in`), bytecode (`vm`, `vmr`), nativo AOT (`llvm`) e WebAssembly (`wat`, `wasm`).

---

## 2. Estrutura Modular e Contratos

A biblioteca é composta por **10 módulos de domínio** e declara **62 operações públicas**:

| Arquivo de Domínio | Contrato Formal | Responsabilidade Principal | Qtd. Ops |
|---|---|---|:---:|
| `SetAccess.fdsl` | `SetAccessContract` | Domínio especializado de `SetAccess` | 7 |
| `SetAggregate.fdsl` | `SetAggregateContract` | Domínio especializado de `SetAggregate` | 6 |
| `SetAlgebra.fdsl` | `SetAlgebraContract` | Domínio especializado de `SetAlgebra` | 4 |
| `SetBasic.fdsl` | `SetBasicContract` | Domínio especializado de `SetBasic` | 18 |
| `SetMutation.fdsl` | `SetMutationContract` | Domínio especializado de `SetMutation` | 4 |
| `SetRelation.fdsl` | `SetRelationContract` | Domínio especializado de `SetRelation` | 5 |
| `SetSearch.fdsl` | `SetSearchContract` | Domínio especializado de `SetSearch` | 5 |
| `SetSelection.fdsl` | `SetSelectionContract` | Domínio especializado de `SetSelection` | 6 |
| `SetTransform.fdsl` | `SetTransformContract` | Domínio especializado de `SetTransform` | 4 |
| `SetUtility.fdsl` | `SetUtilityContract` | Domínio especializado de `SetUtility` | 3 |

---

## 3. Tipos, Estruturas e Enumerações Públicas

A biblioteca `SetStdLib` opera diretamente com os tipos nativos e primitivos da linguagem TheFlux (`string`, `int64`, `float64`, `bool`, `list of data`, etc.), sem exigir tipos compostos adicionais.

---

## 4. Catálogo Detalhado de Operações por Domínio

### 4.1 Contrato `SetAccessContract` (`SetAccess.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `setGetFirst` | `op setGetFirst (as set of data: items) as data` | `data` |
| `setGetAt` | `op setGetAt (as set of data: items, as int64: index) as data` | `data` |
| `setGetLast` | `op setGetLast (as set of data: items) as data` | `data` |
| `setGetLeft` | `op setGetLeft (as set of data: items, as int64: n) as set of data` | `set of data` |
| `setGetRight` | `op setGetRight (as set of data: items, as int64: n) as set of data` | `set of data` |
| `setGetCenter` | `op setGetCenter (as set of data: items, as int64: n) as set of data` | `set of data` |
| `setSlice` | `op setSlice (as set of data: items, as int64: start, as int64: end) as set of data` | `set of data` |

#### Ficha Técnica das Operações:

##### `op setGetFirst`
```flux
op setGetFirst (as set of data: items) as data
```
- **Parâmetros**:
  - `items` (`set of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setGetFirst` no domínio `SetAccessContract`.

##### `op setGetAt`
```flux
op setGetAt (as set of data: items, as int64: index) as data
```
- **Parâmetros**:
  - `items` (`set of data`): Parâmetro de entrada para processamento da operação.
  - `index` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setGetAt` no domínio `SetAccessContract`.

##### `op setGetLast`
```flux
op setGetLast (as set of data: items) as data
```
- **Parâmetros**:
  - `items` (`set of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setGetLast` no domínio `SetAccessContract`.

##### `op setGetLeft`
```flux
op setGetLeft (as set of data: items, as int64: n) as set of data
```
- **Parâmetros**:
  - `items` (`set of data`): Parâmetro de entrada para processamento da operação.
  - `n` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `set of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setGetLeft` no domínio `SetAccessContract`.

##### `op setGetRight`
```flux
op setGetRight (as set of data: items, as int64: n) as set of data
```
- **Parâmetros**:
  - `items` (`set of data`): Parâmetro de entrada para processamento da operação.
  - `n` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `set of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setGetRight` no domínio `SetAccessContract`.

##### `op setGetCenter`
```flux
op setGetCenter (as set of data: items, as int64: n) as set of data
```
- **Parâmetros**:
  - `items` (`set of data`): Parâmetro de entrada para processamento da operação.
  - `n` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `set of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setGetCenter` no domínio `SetAccessContract`.

##### `op setSlice`
```flux
op setSlice (as set of data: items, as int64: start, as int64: end) as set of data
```
- **Parâmetros**:
  - `items` (`set of data`): Parâmetro de entrada para processamento da operação.
  - `start` (`int64`): Parâmetro de entrada para processamento da operação.
  - `end` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `set of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setSlice` no domínio `SetAccessContract`.

### 4.2 Contrato `SetAggregateContract` (`SetAggregate.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `setMin` | `op setMin (as set of data: items) as data` | `data` |
| `setMax` | `op setMax (as set of data: items) as data` | `data` |
| `setSum` | `op setSum (as set of data: items) as data` | `data` |
| `setProduct` | `op setProduct (as set of data: items) as data` | `data` |
| `setAverage` | `op setAverage (as set of data: items) as float64` | `float64` |
| `setCountValues` | `op setCountValues (as set of data: items, as data: value) as int64` | `int64` |

#### Ficha Técnica das Operações:

##### `op setMin`
```flux
op setMin (as set of data: items) as data
```
- **Parâmetros**:
  - `items` (`set of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setMin` no domínio `SetAggregateContract`.

##### `op setMax`
```flux
op setMax (as set of data: items) as data
```
- **Parâmetros**:
  - `items` (`set of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setMax` no domínio `SetAggregateContract`.

##### `op setSum`
```flux
op setSum (as set of data: items) as data
```
- **Parâmetros**:
  - `items` (`set of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setSum` no domínio `SetAggregateContract`.

##### `op setProduct`
```flux
op setProduct (as set of data: items) as data
```
- **Parâmetros**:
  - `items` (`set of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setProduct` no domínio `SetAggregateContract`.

##### `op setAverage`
```flux
op setAverage (as set of data: items) as float64
```
- **Parâmetros**:
  - `items` (`set of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setAverage` no domínio `SetAggregateContract`.

##### `op setCountValues`
```flux
op setCountValues (as set of data: items, as data: value) as int64
```
- **Parâmetros**:
  - `items` (`set of data`): Parâmetro de entrada para processamento da operação.
  - `value` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setCountValues` no domínio `SetAggregateContract`.

### 4.3 Contrato `SetAlgebraContract` (`SetAlgebra.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `setUnion` | `op setUnion (as set of data: lhs, as set of data: rhs) as set of data` | `set of data` |
| `setIntersect` | `op setIntersect (as set of data: lhs, as set of data: rhs) as set of data` | `set of data` |
| `setDifference` | `op setDifference (as set of data: lhs, as set of data: rhs) as set of data` | `set of data` |
| `setSymmetricDifference` | `op setSymmetricDifference (as set of data: lhs, as set of data: rhs) as set of data` | `set of data` |

#### Ficha Técnica das Operações:

##### `op setUnion`
```flux
op setUnion (as set of data: lhs, as set of data: rhs) as set of data
```
- **Parâmetros**:
  - `lhs` (`set of data`): Parâmetro de entrada para processamento da operação.
  - `rhs` (`set of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `set of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setUnion` no domínio `SetAlgebraContract`.

##### `op setIntersect`
```flux
op setIntersect (as set of data: lhs, as set of data: rhs) as set of data
```
- **Parâmetros**:
  - `lhs` (`set of data`): Parâmetro de entrada para processamento da operação.
  - `rhs` (`set of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `set of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setIntersect` no domínio `SetAlgebraContract`.

##### `op setDifference`
```flux
op setDifference (as set of data: lhs, as set of data: rhs) as set of data
```
- **Parâmetros**:
  - `lhs` (`set of data`): Parâmetro de entrada para processamento da operação.
  - `rhs` (`set of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `set of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setDifference` no domínio `SetAlgebraContract`.

##### `op setSymmetricDifference`
```flux
op setSymmetricDifference (as set of data: lhs, as set of data: rhs) as set of data
```
- **Parâmetros**:
  - `lhs` (`set of data`): Parâmetro de entrada para processamento da operação.
  - `rhs` (`set of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `set of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setSymmetricDifference` no domínio `SetAlgebraContract`.

### 4.4 Contrato `SetBasicContract` (`SetBasic.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `setLength` | `op setLength (as set of data: items) as int64` | `int64` |
| `setIsEmpty` | `op setIsEmpty (as set of data: items) as bool` | `bool` |
| `setIsNotEmpty` | `op setIsNotEmpty (as set of data: items) as bool` | `bool` |
| `setContains` | `op setContains (as set of data: items, as data: item) as bool` | `bool` |
| `setContainsAny` | `op setContainsAny (as set of data: lhs, as set of data: rhs) as bool` | `bool` |
| `setContainsAll` | `op setContainsAll (as set of data: lhs, as set of data: rhs) as bool` | `bool` |
| `setClearAll` | `op setClearAll (as set of data: items) as set of data` | `set of data` |
| `setSingleton` | `op setSingleton (as data: value) as set of data` | `set of data` |
| `setSingletonInt` | `op setSingletonInt (as int64: value) as set of data` | `set of data` |
| `setSingletonString` | `op setSingletonString (as string: value) as set of data` | `set of data` |
| `setClone` | `op setClone (as set of data: items) as set of data` | `set of data` |
| `setToList` | `op setToList (as set of data: items) as list of data` | `list of data` |
| `setToSet` | `op setToSet (as data: value) as set of data` | `set of data` |
| `setToMap` | `op setToMap (as set of data: value) as map` | `map` |
| `setToString` | `op setToString (as set of data: items) as string` | `string` |
| `setFromList` | `op setFromList (as list of data: items) as set of data` | `set of data` |
| `setFromSet` | `op setFromSet (as set of data: items) as set of data` | `set of data` |
| `setFromString` | `op setFromString (as string: text) as set of data` | `set of data` |

#### Ficha Técnica das Operações:

##### `op setLength`
```flux
op setLength (as set of data: items) as int64
```
- **Parâmetros**:
  - `items` (`set of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setLength` no domínio `SetBasicContract`.

##### `op setIsEmpty`
```flux
op setIsEmpty (as set of data: items) as bool
```
- **Parâmetros**:
  - `items` (`set of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setIsEmpty` no domínio `SetBasicContract`.

##### `op setIsNotEmpty`
```flux
op setIsNotEmpty (as set of data: items) as bool
```
- **Parâmetros**:
  - `items` (`set of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setIsNotEmpty` no domínio `SetBasicContract`.

##### `op setContains`
```flux
op setContains (as set of data: items, as data: item) as bool
```
- **Parâmetros**:
  - `items` (`set of data`): Parâmetro de entrada para processamento da operação.
  - `item` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setContains` no domínio `SetBasicContract`.

##### `op setContainsAny`
```flux
op setContainsAny (as set of data: lhs, as set of data: rhs) as bool
```
- **Parâmetros**:
  - `lhs` (`set of data`): Parâmetro de entrada para processamento da operação.
  - `rhs` (`set of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setContainsAny` no domínio `SetBasicContract`.

##### `op setContainsAll`
```flux
op setContainsAll (as set of data: lhs, as set of data: rhs) as bool
```
- **Parâmetros**:
  - `lhs` (`set of data`): Parâmetro de entrada para processamento da operação.
  - `rhs` (`set of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setContainsAll` no domínio `SetBasicContract`.

##### `op setClearAll`
```flux
op setClearAll (as set of data: items) as set of data
```
- **Parâmetros**:
  - `items` (`set of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `set of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setClearAll` no domínio `SetBasicContract`.

##### `op setSingleton`
```flux
op setSingleton (as data: value) as set of data
```
- **Parâmetros**:
  - `value` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `set of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setSingleton` no domínio `SetBasicContract`.

##### `op setSingletonInt`
```flux
op setSingletonInt (as int64: value) as set of data
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `set of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setSingletonInt` no domínio `SetBasicContract`.

##### `op setSingletonString`
```flux
op setSingletonString (as string: value) as set of data
```
- **Parâmetros**:
  - `value` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `set of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setSingletonString` no domínio `SetBasicContract`.

##### `op setClone`
```flux
op setClone (as set of data: items) as set of data
```
- **Parâmetros**:
  - `items` (`set of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `set of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setClone` no domínio `SetBasicContract`.

##### `op setToList`
```flux
op setToList (as set of data: items) as list of data
```
- **Parâmetros**:
  - `items` (`set of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setToList` no domínio `SetBasicContract`.

##### `op setToSet`
```flux
op setToSet (as data: value) as set of data
```
- **Parâmetros**:
  - `value` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `set of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setToSet` no domínio `SetBasicContract`.

##### `op setToMap`
```flux
op setToMap (as set of data: value) as map
```
- **Parâmetros**:
  - `value` (`set of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setToMap` no domínio `SetBasicContract`.

##### `op setToString`
```flux
op setToString (as set of data: items) as string
```
- **Parâmetros**:
  - `items` (`set of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `", "`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setToString` no domínio `SetBasicContract`.

##### `op setFromList`
```flux
op setFromList (as list of data: items) as set of data
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `set of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setFromList` no domínio `SetBasicContract`.

##### `op setFromSet`
```flux
op setFromSet (as set of data: items) as set of data
```
- **Parâmetros**:
  - `items` (`set of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `set of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setFromSet` no domínio `SetBasicContract`.

##### `op setFromString`
```flux
op setFromString (as string: text) as set of data
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `set of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setFromString` no domínio `SetBasicContract`.

### 4.5 Contrato `SetMutationContract` (`SetMutation.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `setInclude` | `op setInclude (as set of data: items, as data: item) as set of data` | `set of data` |
| `setIncludeAll` | `op setIncludeAll (as set of data: items, as set of data: other) as set of data` | `set of data` |
| `setExclude` | `op setExclude (as set of data: items, as data: item) as set of data` | `set of data` |
| `setExcludeAll` | `op setExcludeAll (as set of data: items, as set of data: other) as set of data` | `set of data` |

#### Ficha Técnica das Operações:

##### `op setInclude`
```flux
op setInclude (as set of data: items, as data: item) as set of data
```
- **Parâmetros**:
  - `items` (`set of data`): Parâmetro de entrada para processamento da operação.
  - `item` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `set of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setInclude` no domínio `SetMutationContract`.

##### `op setIncludeAll`
```flux
op setIncludeAll (as set of data: items, as set of data: other) as set of data
```
- **Parâmetros**:
  - `items` (`set of data`): Parâmetro de entrada para processamento da operação.
  - `other` (`set of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `set of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setIncludeAll` no domínio `SetMutationContract`.

##### `op setExclude`
```flux
op setExclude (as set of data: items, as data: item) as set of data
```
- **Parâmetros**:
  - `items` (`set of data`): Parâmetro de entrada para processamento da operação.
  - `item` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `set of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setExclude` no domínio `SetMutationContract`.

##### `op setExcludeAll`
```flux
op setExcludeAll (as set of data: items, as set of data: other) as set of data
```
- **Parâmetros**:
  - `items` (`set of data`): Parâmetro de entrada para processamento da operação.
  - `other` (`set of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `set of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setExcludeAll` no domínio `SetMutationContract`.

### 4.6 Contrato `SetRelationContract` (`SetRelation.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `setIsSubset` | `op setIsSubset (as set of data: lhs, as set of data: rhs) as bool` | `bool` |
| `setIsSuperset` | `op setIsSuperset (as set of data: lhs, as set of data: rhs) as bool` | `bool` |
| `setIsDisjoint` | `op setIsDisjoint (as set of data: lhs, as set of data: rhs) as bool` | `bool` |
| `setIsProperSubset` | `op setIsProperSubset (as set of data: lhs, as set of data: rhs) as bool` | `bool` |
| `setIsProperSuperset` | `op setIsProperSuperset (as set of data: lhs, as set of data: rhs) as bool` | `bool` |

#### Ficha Técnica das Operações:

##### `op setIsSubset`
```flux
op setIsSubset (as set of data: lhs, as set of data: rhs) as bool
```
- **Parâmetros**:
  - `lhs` (`set of data`): Parâmetro de entrada para processamento da operação.
  - `rhs` (`set of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setIsSubset` no domínio `SetRelationContract`.

##### `op setIsSuperset`
```flux
op setIsSuperset (as set of data: lhs, as set of data: rhs) as bool
```
- **Parâmetros**:
  - `lhs` (`set of data`): Parâmetro de entrada para processamento da operação.
  - `rhs` (`set of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setIsSuperset` no domínio `SetRelationContract`.

##### `op setIsDisjoint`
```flux
op setIsDisjoint (as set of data: lhs, as set of data: rhs) as bool
```
- **Parâmetros**:
  - `lhs` (`set of data`): Parâmetro de entrada para processamento da operação.
  - `rhs` (`set of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setIsDisjoint` no domínio `SetRelationContract`.

##### `op setIsProperSubset`
```flux
op setIsProperSubset (as set of data: lhs, as set of data: rhs) as bool
```
- **Parâmetros**:
  - `lhs` (`set of data`): Parâmetro de entrada para processamento da operação.
  - `rhs` (`set of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setIsProperSubset` no domínio `SetRelationContract`.

##### `op setIsProperSuperset`
```flux
op setIsProperSuperset (as set of data: lhs, as set of data: rhs) as bool
```
- **Parâmetros**:
  - `lhs` (`set of data`): Parâmetro de entrada para processamento da operação.
  - `rhs` (`set of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setIsProperSuperset` no domínio `SetRelationContract`.

### 4.7 Contrato `SetSearchContract` (`SetSearch.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `setContains` | `op setContains (as set of data: items, as data: item) as bool` | `bool` |
| `setContainsAny` | `op setContainsAny (as set of data: lhs, as set of data: rhs) as bool` | `bool` |
| `setContainsAll` | `op setContainsAll (as set of data: lhs, as set of data: rhs) as bool` | `bool` |
| `setIndexOf` | `op setIndexOf (as set of data: items, as data: item) as int64` | `int64` |
| `setCount` | `op setCount (as set of data: items, as data: item) as int64` | `int64` |

#### Ficha Técnica das Operações:

##### `op setContains`
```flux
op setContains (as set of data: items, as data: item) as bool
```
- **Parâmetros**:
  - `items` (`set of data`): Parâmetro de entrada para processamento da operação.
  - `item` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setContains` no domínio `SetSearchContract`.

##### `op setContainsAny`
```flux
op setContainsAny (as set of data: lhs, as set of data: rhs) as bool
```
- **Parâmetros**:
  - `lhs` (`set of data`): Parâmetro de entrada para processamento da operação.
  - `rhs` (`set of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setContainsAny` no domínio `SetSearchContract`.

##### `op setContainsAll`
```flux
op setContainsAll (as set of data: lhs, as set of data: rhs) as bool
```
- **Parâmetros**:
  - `lhs` (`set of data`): Parâmetro de entrada para processamento da operação.
  - `rhs` (`set of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setContainsAll` no domínio `SetSearchContract`.

##### `op setIndexOf`
```flux
op setIndexOf (as set of data: items, as data: item) as int64
```
- **Parâmetros**:
  - `items` (`set of data`): Parâmetro de entrada para processamento da operação.
  - `item` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setIndexOf` no domínio `SetSearchContract`.

##### `op setCount`
```flux
op setCount (as set of data: items, as data: item) as int64
```
- **Parâmetros**:
  - `items` (`set of data`): Parâmetro de entrada para processamento da operação.
  - `item` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setCount` no domínio `SetSearchContract`.

### 4.8 Contrato `SetSelectionContract` (`SetSelection.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `setTake` | `op setTake (as set of data: items, as int64: n) as set of data` | `set of data` |
| `setDrop` | `op setDrop (as set of data: items, as int64: n) as set of data` | `set of data` |
| `setTakeLast` | `op setTakeLast (as set of data: items, as int64: n) as set of data` | `set of data` |
| `setDropLast` | `op setDropLast (as set of data: items, as int64: n) as set of data` | `set of data` |
| `setFilter` | `op setFilter (as set of data: items, as list of data: allowed_items) as set of data` | `set of data` |
| `setOmit` | `op setOmit (as set of data: items, as list of data: omitted_items) as set of data` | `set of data` |

#### Ficha Técnica das Operações:

##### `op setTake`
```flux
op setTake (as set of data: items, as int64: n) as set of data
```
- **Parâmetros**:
  - `items` (`set of data`): Parâmetro de entrada para processamento da operação.
  - `n` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `set of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setTake` no domínio `SetSelectionContract`.

##### `op setDrop`
```flux
op setDrop (as set of data: items, as int64: n) as set of data
```
- **Parâmetros**:
  - `items` (`set of data`): Parâmetro de entrada para processamento da operação.
  - `n` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `set of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setDrop` no domínio `SetSelectionContract`.

##### `op setTakeLast`
```flux
op setTakeLast (as set of data: items, as int64: n) as set of data
```
- **Parâmetros**:
  - `items` (`set of data`): Parâmetro de entrada para processamento da operação.
  - `n` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `set of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setTakeLast` no domínio `SetSelectionContract`.

##### `op setDropLast`
```flux
op setDropLast (as set of data: items, as int64: n) as set of data
```
- **Parâmetros**:
  - `items` (`set of data`): Parâmetro de entrada para processamento da operação.
  - `n` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `set of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setDropLast` no domínio `SetSelectionContract`.

##### `op setFilter`
```flux
op setFilter (as set of data: items, as list of data: allowed_items) as set of data
```
- **Parâmetros**:
  - `items` (`set of data`): Parâmetro de entrada para processamento da operação.
  - `allowed_items` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `set of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setFilter` no domínio `SetSelectionContract`.

##### `op setOmit`
```flux
op setOmit (as set of data: items, as list of data: omitted_items) as set of data
```
- **Parâmetros**:
  - `items` (`set of data`): Parâmetro de entrada para processamento da operação.
  - `omitted_items` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `set of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setOmit` no domínio `SetSelectionContract`.

### 4.9 Contrato `SetTransformContract` (`SetTransform.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `setUnionAll` | `op setUnionAll (as list of data: sets) as set of data` | `set of data` |
| `setIntersectAll` | `op setIntersectAll (as list of data: sets) as set of data` | `set of data` |
| `setCartesianProduct` | `op setCartesianProduct (as set of data: lhs, as set of data: rhs) as list of data` | `list of data` |
| `setPowerSet` | `op setPowerSet (as set of data: items) as list of data` | `list of data` |

#### Ficha Técnica das Operações:

##### `op setUnionAll`
```flux
op setUnionAll (as list of data: sets) as set of data
```
- **Parâmetros**:
  - `sets` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `set of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setUnionAll` no domínio `SetTransformContract`.

##### `op setIntersectAll`
```flux
op setIntersectAll (as list of data: sets) as set of data
```
- **Parâmetros**:
  - `sets` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `set of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setIntersectAll` no domínio `SetTransformContract`.

##### `op setCartesianProduct`
```flux
op setCartesianProduct (as set of data: lhs, as set of data: rhs) as list of data
```
- **Parâmetros**:
  - `lhs` (`set of data`): Parâmetro de entrada para processamento da operação.
  - `rhs` (`set of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setCartesianProduct` no domínio `SetTransformContract`.

##### `op setPowerSet`
```flux
op setPowerSet (as set of data: items) as list of data
```
- **Parâmetros**:
  - `items` (`set of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setPowerSet` no domínio `SetTransformContract`.

### 4.10 Contrato `SetUtilityContract` (`SetUtility.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `setEquals` | `op setEquals (as set of data: lhs, as set of data: rhs) as bool` | `bool` |
| `setJoin` | `op setJoin (as set of data: items, as string: separator) as string` | `string` |
| `setSwap` | `op setSwap (as set of data: items, as data: old_val, as data: new_val) as set of data` | `set of data` |

#### Ficha Técnica das Operações:

##### `op setEquals`
```flux
op setEquals (as set of data: lhs, as set of data: rhs) as bool
```
- **Parâmetros**:
  - `lhs` (`set of data`): Parâmetro de entrada para processamento da operação.
  - `rhs` (`set of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setEquals` no domínio `SetUtilityContract`.

##### `op setJoin`
```flux
op setJoin (as set of data: items, as string: separator) as string
```
- **Parâmetros**:
  - `items` (`set of data`): Parâmetro de entrada para processamento da operação.
  - `separator` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setJoin` no domínio `SetUtilityContract`.

##### `op setSwap`
```flux
op setSwap (as set of data: items, as data: old_val, as data: new_val) as set of data
```
- **Parâmetros**:
  - `items` (`set of data`): Parâmetro de entrada para processamento da operação.
  - `old_val` (`data`): Parâmetro de entrada para processamento da operação.
  - `new_val` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `set of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setSwap` no domínio `SetUtilityContract`.

---

## 5. Exemplos Canônicos de Uso em TheFlux

O exemplo a seguir demonstra a importação e o consumo prático da biblioteca:

```flux
# Exemplo Canônico de Consumo da SetStdLib
use SetStdLib

program (ExemploSetStdLib) {
      println("==================================================")
      println("  Demonstracao da Standard Library: SetStdLib")
      println("==================================================")

      # Chamada da operacao canônica
      mut as data: resultado = SetStdLib::setCount([])
      println("Resultado obtido: " + resultado)

      println("Demonstracao concluida com sucesso.")
}
```

---

> [!TIP]
> Para consultar a visão arquitetural unificada de todas as bibliotecas, consulte o documento principal [StdLibs.md](../StdLibs.md).
