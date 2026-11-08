# 📚 `StringStdLib` — Manipulação de Texto de Alto Desempenho, Fatiamento e Busca

> **Pilar Arquitetural**: Pilar 1 (Núcleo, Texto & OO)  
> **Status**: ✅ Homologado com 100% de Paridade nos 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Arquivo Mestre**: `stdlib/StringStdLib/StringStdLib.fdsl`  
> **Modo de Importação**: `use StringStdLib` ou `use StringStdLib::<Modulo>::<operacao>`

---

## 1. Visão Geral e Funcionalidades

A biblioteca padrão **`StringStdLib`** integra o ecossistema oficial da linguagem TheFlux, fornecendo suporte de nível de sistema e algoritmos nativos certificados.

Operações essenciais para processamento de strings: divisão (`split`), junção (`join`), busca de padrões com Boyer-Moore/KMP, preenchimento (`pad`), aparamento de espaços (`trim`), reversão e fatiamento sem alocação desnecessária.

### 1.1 Características e Princípios de Design
- **Compilação e Fusão Estática**: Todos os módulos de domínio são fundidos no agente unificado `StringStdLib` em tempo de compilação, sem sobrecarga (*overhead*) de despacho indireto.
- **Isolamento e Segurança**: As operações verificam limites operacionais e utilizam despacho por contratos formais rigorosos.
- **Compatibilidade Multi-Backend**: Execução bit-a-bit idêntica em interpretador (`in`), bytecode (`vm`, `vmr`), nativo AOT (`llvm`) e WebAssembly (`wat`, `wasm`).

---

## 2. Estrutura Modular e Contratos

A biblioteca é composta por **8 módulos de domínio** e declara **79 operações públicas**:

| Arquivo de Domínio | Contrato Formal | Responsabilidade Principal | Qtd. Ops |
|---|---|---|:---:|
| `StringAccess.fdsl` | `StringAccessContract` | Domínio especializado de `StringAccess` | 7 |
| `StringBasic.fdsl` | `StringBasicContract` | Domínio especializado de `StringBasic` | 18 |
| `StringMutation.fdsl` | `StringMutationContract` | Domínio especializado de `StringMutation` | 13 |
| `StringSearch.fdsl` | `StringSearchContract` | Domínio especializado de `StringSearch` | 8 |
| `StringSelection.fdsl` | `StringSelectionContract` | Domínio especializado de `StringSelection` | 9 |
| `StringTransform.fdsl` | `StringTransformContract` | Domínio especializado de `StringTransform` | 12 |
| `StringUtility.fdsl` | `StringUtilityContract` | Domínio especializado de `StringUtility` | 4 |
| `StringValidation.fdsl` | `StringValidationContract` | Domínio especializado de `StringValidation` | 8 |

---

## 3. Tipos, Estruturas e Enumerações Públicas

A biblioteca `StringStdLib` opera diretamente com os tipos nativos e primitivos da linguagem TheFlux (`string`, `int64`, `float64`, `bool`, `list of data`, etc.), sem exigir tipos compostos adicionais.

---

## 4. Catálogo Detalhado de Operações por Domínio

### 4.1 Contrato `StringAccessContract` (`StringAccess.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `stringGetFirst` | `op stringGetFirst (as string: text) as string` | `string` |
| `stringGetAt` | `op stringGetAt (as string: text, as int64: index) as string` | `string` |
| `stringGetLast` | `op stringGetLast (as string: text) as string` | `string` |
| `stringGetLeft` | `op stringGetLeft (as string: text, as int64: n) as string` | `string` |
| `stringGetRight` | `op stringGetRight (as string: text, as int64: n) as string` | `string` |
| `stringGetCenter` | `op stringGetCenter (as string: text, as int64: n) as string` | `string` |
| `stringSlice` | `op stringSlice (as string: text, as int64: start, as int64: end) as string` | `string` |

#### Ficha Técnica das Operações:

##### `op stringGetFirst`
```flux
op stringGetFirst (as string: text) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringGetFirst` no domínio `StringAccessContract`.

##### `op stringGetAt`
```flux
op stringGetAt (as string: text, as int64: index) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
  - `index` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringGetAt` no domínio `StringAccessContract`.

##### `op stringGetLast`
```flux
op stringGetLast (as string: text) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringGetLast` no domínio `StringAccessContract`.

##### `op stringGetLeft`
```flux
op stringGetLeft (as string: text, as int64: n) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
  - `n` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringGetLeft` no domínio `StringAccessContract`.

##### `op stringGetRight`
```flux
op stringGetRight (as string: text, as int64: n) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
  - `n` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringGetRight` no domínio `StringAccessContract`.

##### `op stringGetCenter`
```flux
op stringGetCenter (as string: text, as int64: n) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
  - `n` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringGetCenter` no domínio `StringAccessContract`.

##### `op stringSlice`
```flux
op stringSlice (as string: text, as int64: start, as int64: end) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
  - `start` (`int64`): Parâmetro de entrada para processamento da operação.
  - `end` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringSlice` no domínio `StringAccessContract`.

### 4.2 Contrato `StringBasicContract` (`StringBasic.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `stringLength` | `op stringLength (as string: text) as int64` | `int64` |
| `stringIsEmpty` | `op stringIsEmpty (as string: text) as bool` | `bool` |
| `stringIsNotEmpty` | `op stringIsNotEmpty (as string: text) as bool` | `bool` |
| `stringContains` | `op stringContains (as string: text, as string: needle) as bool` | `bool` |
| `stringContainsAny` | `op stringContainsAny (as string: text, as list of data: needles) as bool` | `bool` |
| `stringContainsAll` | `op stringContainsAll (as string: text, as list of data: needles) as bool` | `bool` |
| `stringClearAll` | `op stringClearAll (as string: text) as string` | `string` |
| `stringSingleton` | `op stringSingleton (as string: char) as string` | `string` |
| `stringSingletonInt` | `op stringSingletonInt (as int64: value) as string` | `string` |
| `stringSingletonString` | `op stringSingletonString (as string: value) as string` | `string` |
| `stringClone` | `op stringClone (as string: text) as string` | `string` |
| `stringToList` | `op stringToList (as string: text) as list of data` | `list of data` |
| `stringToSet` | `op stringToSet (as string: text) as set of data` | `set of data` |
| `stringToMap` | `op stringToMap (as string: text) as map` | `map` |
| `stringToString` | `op stringToString (as string: text) as string` | `string` |
| `stringFromList` | `op stringFromList (as list of data: chars) as string` | `string` |
| `stringFromSet` | `op stringFromSet (as set of data: chars) as string` | `string` |
| `stringFromString` | `op stringFromString (as string: text) as string` | `string` |

#### Ficha Técnica das Operações:

##### `op stringLength`
```flux
op stringLength (as string: text) as int64
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringLength` no domínio `StringBasicContract`.

##### `op stringIsEmpty`
```flux
op stringIsEmpty (as string: text) as bool
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringIsEmpty` no domínio `StringBasicContract`.

##### `op stringIsNotEmpty`
```flux
op stringIsNotEmpty (as string: text) as bool
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringIsNotEmpty` no domínio `StringBasicContract`.

##### `op stringContains`
```flux
op stringContains (as string: text, as string: needle) as bool
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
  - `needle` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringContains` no domínio `StringBasicContract`.

##### `op stringContainsAny`
```flux
op stringContainsAny (as string: text, as list of data: needles) as bool
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
  - `needles` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringContainsAny` no domínio `StringBasicContract`.

##### `op stringContainsAll`
```flux
op stringContainsAll (as string: text, as list of data: needles) as bool
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
  - `needles` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringContainsAll` no domínio `StringBasicContract`.

##### `op stringClearAll`
```flux
op stringClearAll (as string: text) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringClearAll` no domínio `StringBasicContract`.

##### `op stringSingleton`
```flux
op stringSingleton (as string: char) as string
```
- **Parâmetros**:
  - `char` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringSingleton` no domínio `StringBasicContract`.

##### `op stringSingletonInt`
```flux
op stringSingletonInt (as int64: value) as string
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringSingletonInt` no domínio `StringBasicContract`.

##### `op stringSingletonString`
```flux
op stringSingletonString (as string: value) as string
```
- **Parâmetros**:
  - `value` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringSingletonString` no domínio `StringBasicContract`.

##### `op stringClone`
```flux
op stringClone (as string: text) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringClone` no domínio `StringBasicContract`.

##### `op stringToList`
```flux
op stringToList (as string: text) as list of data
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringToList` no domínio `StringBasicContract`.

##### `op stringToSet`
```flux
op stringToSet (as string: text) as set of data
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `set of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringToSet` no domínio `StringBasicContract`.

##### `op stringToMap`
```flux
op stringToMap (as string: text) as map
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringToMap` no domínio `StringBasicContract`.

##### `op stringToString`
```flux
op stringToString (as string: text) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringToString` no domínio `StringBasicContract`.

##### `op stringFromList`
```flux
op stringFromList (as list of data: chars) as string
```
- **Parâmetros**:
  - `chars` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringFromList` no domínio `StringBasicContract`.

##### `op stringFromSet`
```flux
op stringFromSet (as set of data: chars) as string
```
- **Parâmetros**:
  - `chars` (`set of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringFromSet` no domínio `StringBasicContract`.

##### `op stringFromString`
```flux
op stringFromString (as string: text) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringFromString` no domínio `StringBasicContract`.

### 4.3 Contrato `StringMutationContract` (`StringMutation.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `stringPushFront` | `op stringPushFront (as string: text, as string: char) as string` | `string` |
| `stringPushBack` | `op stringPushBack (as string: text, as string: char) as string` | `string` |
| `stringPrepend` | `op stringPrepend (as string: text, as string: prefix) as string` | `string` |
| `stringAppend` | `op stringAppend (as string: text, as string: suffix) as string` | `string` |
| `stringInsertFirst` | `op stringInsertFirst (as string: text, as string: insert_text) as string` | `string` |
| `stringInsertAt` | `op stringInsertAt (as string: text, as int64: index, as string: insert_text) as string` | `string` |
| `stringInsertLast` | `op stringInsertLast (as string: text, as string: insert_text) as string` | `string` |
| `stringInsert` | `op stringInsert (as string: text, as int64: index, as string: insert_text) as string` | `string` |
| `stringRemoveFirst` | `op stringRemoveFirst (as string: text) as string` | `string` |
| `stringRemoveAt` | `op stringRemoveAt (as string: text, as int64: index) as string` | `string` |
| `stringRemoveLast` | `op stringRemoveLast (as string: text) as string` | `string` |
| `stringRemove` | `op stringRemove (as string: text, as string: target) as string` | `string` |
| `stringRemoveAll` | `op stringRemoveAll (as string: text, as string: target) as string` | `string` |

#### Ficha Técnica das Operações:

##### `op stringPushFront`
```flux
op stringPushFront (as string: text, as string: char) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
  - `char` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringPushFront` no domínio `StringMutationContract`.

##### `op stringPushBack`
```flux
op stringPushBack (as string: text, as string: char) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
  - `char` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringPushBack` no domínio `StringMutationContract`.

##### `op stringPrepend`
```flux
op stringPrepend (as string: text, as string: prefix) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
  - `prefix` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringPrepend` no domínio `StringMutationContract`.

##### `op stringAppend`
```flux
op stringAppend (as string: text, as string: suffix) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
  - `suffix` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringAppend` no domínio `StringMutationContract`.

##### `op stringInsertFirst`
```flux
op stringInsertFirst (as string: text, as string: insert_text) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
  - `insert_text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringInsertFirst` no domínio `StringMutationContract`.

##### `op stringInsertAt`
```flux
op stringInsertAt (as string: text, as int64: index, as string: insert_text) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
  - `index` (`int64`): Parâmetro de entrada para processamento da operação.
  - `insert_text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringInsertAt` no domínio `StringMutationContract`.

##### `op stringInsertLast`
```flux
op stringInsertLast (as string: text, as string: insert_text) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
  - `insert_text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringInsertLast` no domínio `StringMutationContract`.

##### `op stringInsert`
```flux
op stringInsert (as string: text, as int64: index, as string: insert_text) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
  - `index` (`int64`): Parâmetro de entrada para processamento da operação.
  - `insert_text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringInsert` no domínio `StringMutationContract`.

##### `op stringRemoveFirst`
```flux
op stringRemoveFirst (as string: text) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringRemoveFirst` no domínio `StringMutationContract`.

##### `op stringRemoveAt`
```flux
op stringRemoveAt (as string: text, as int64: index) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
  - `index` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringRemoveAt` no domínio `StringMutationContract`.

##### `op stringRemoveLast`
```flux
op stringRemoveLast (as string: text) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringRemoveLast` no domínio `StringMutationContract`.

##### `op stringRemove`
```flux
op stringRemove (as string: text, as string: target) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
  - `target` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `""`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringRemove` no domínio `StringMutationContract`.

##### `op stringRemoveAll`
```flux
op stringRemoveAll (as string: text, as string: target) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
  - `target` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `""`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringRemoveAll` no domínio `StringMutationContract`.

### 4.4 Contrato `StringSearchContract` (`StringSearch.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `stringContains` | `op stringContains (as string: text, as string: needle) as bool` | `bool` |
| `stringContainsAny` | `op stringContainsAny (as string: text, as list of data: needles) as bool` | `bool` |
| `stringContainsAll` | `op stringContainsAll (as string: text, as list of data: needles) as bool` | `bool` |
| `stringStartsWith` | `op stringStartsWith (as string: text, as string: prefix) as bool` | `bool` |
| `stringEndsWith` | `op stringEndsWith (as string: text, as string: suffix) as bool` | `bool` |
| `stringIndexOf` | `op stringIndexOf (as string: text, as string: needle) as int64` | `int64` |
| `stringLastIndexOf` | `op stringLastIndexOf (as string: text, as string: needle) as int64` | `int64` |
| `stringCount` | `op stringCount (as string: text, as string: needle) as int64` | `int64` |

#### Ficha Técnica das Operações:

##### `op stringContains`
```flux
op stringContains (as string: text, as string: needle) as bool
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
  - `needle` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringContains` no domínio `StringSearchContract`.

##### `op stringContainsAny`
```flux
op stringContainsAny (as string: text, as list of data: needles) as bool
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
  - `needles` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringContainsAny` no domínio `StringSearchContract`.

##### `op stringContainsAll`
```flux
op stringContainsAll (as string: text, as list of data: needles) as bool
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
  - `needles` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringContainsAll` no domínio `StringSearchContract`.

##### `op stringStartsWith`
```flux
op stringStartsWith (as string: text, as string: prefix) as bool
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
  - `prefix` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringStartsWith` no domínio `StringSearchContract`.

##### `op stringEndsWith`
```flux
op stringEndsWith (as string: text, as string: suffix) as bool
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
  - `suffix` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringEndsWith` no domínio `StringSearchContract`.

##### `op stringIndexOf`
```flux
op stringIndexOf (as string: text, as string: needle) as int64
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
  - `needle` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringIndexOf` no domínio `StringSearchContract`.

##### `op stringLastIndexOf`
```flux
op stringLastIndexOf (as string: text, as string: needle) as int64
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
  - `needle` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringLastIndexOf` no domínio `StringSearchContract`.

##### `op stringCount`
```flux
op stringCount (as string: text, as string: needle) as int64
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
  - `needle` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringCount` no domínio `StringSearchContract`.

### 4.5 Contrato `StringSelectionContract` (`StringSelection.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `stringTake` | `op stringTake (as string: text, as int64: n) as string` | `string` |
| `stringDrop` | `op stringDrop (as string: text, as int64: n) as string` | `string` |
| `stringTakeLast` | `op stringTakeLast (as string: text, as int64: n) as string` | `string` |
| `stringDropLast` | `op stringDropLast (as string: text, as int64: n) as string` | `string` |
| `stringPadStart` | `op stringPadStart (as string: text, as int64: target_len, as string: pad) as string` | `string` |
| `stringPadEnd` | `op stringPadEnd (as string: text, as int64: target_len, as string: pad) as string` | `string` |
| `stringPadCenter` | `op stringPadCenter (as string: text, as int64: target_len, as string: pad) as string` | `string` |
| `stringFilter` | `op stringFilter (as string: text, as list of data: allowed_chars) as string` | `string` |
| `stringOmit` | `op stringOmit (as string: text, as list of data: omitted_chars) as string` | `string` |

#### Ficha Técnica das Operações:

##### `op stringTake`
```flux
op stringTake (as string: text, as int64: n) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
  - `n` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringTake` no domínio `StringSelectionContract`.

##### `op stringDrop`
```flux
op stringDrop (as string: text, as int64: n) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
  - `n` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringDrop` no domínio `StringSelectionContract`.

##### `op stringTakeLast`
```flux
op stringTakeLast (as string: text, as int64: n) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
  - `n` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringTakeLast` no domínio `StringSelectionContract`.

##### `op stringDropLast`
```flux
op stringDropLast (as string: text, as int64: n) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
  - `n` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringDropLast` no domínio `StringSelectionContract`.

##### `op stringPadStart`
```flux
op stringPadStart (as string: text, as int64: target_len, as string: pad) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
  - `target_len` (`int64`): Parâmetro de entrada para processamento da operação.
  - `pad` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringPadStart` no domínio `StringSelectionContract`.

##### `op stringPadEnd`
```flux
op stringPadEnd (as string: text, as int64: target_len, as string: pad) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
  - `target_len` (`int64`): Parâmetro de entrada para processamento da operação.
  - `pad` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringPadEnd` no domínio `StringSelectionContract`.

##### `op stringPadCenter`
```flux
op stringPadCenter (as string: text, as int64: target_len, as string: pad) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
  - `target_len` (`int64`): Parâmetro de entrada para processamento da operação.
  - `pad` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringPadCenter` no domínio `StringSelectionContract`.

##### `op stringFilter`
```flux
op stringFilter (as string: text, as list of data: allowed_chars) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
  - `allowed_chars` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringFilter` no domínio `StringSelectionContract`.

##### `op stringOmit`
```flux
op stringOmit (as string: text, as list of data: omitted_chars) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
  - `omitted_chars` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringOmit` no domínio `StringSelectionContract`.

### 4.6 Contrato `StringTransformContract` (`StringTransform.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `stringUpper` | `op stringUpper (as string: text) as string` | `string` |
| `stringLower` | `op stringLower (as string: text) as string` | `string` |
| `stringCapitalize` | `op stringCapitalize (as string: text) as string` | `string` |
| `stringTrim` | `op stringTrim (as string: text) as string` | `string` |
| `stringTrimStart` | `op stringTrimStart (as string: text) as string` | `string` |
| `stringTrimEnd` | `op stringTrimEnd (as string: text) as string` | `string` |
| `stringReplace` | `op stringReplace (as string: text, as string: target, as string: replacement) as string` | `string` |
| `stringReplaceFirst` | `op stringReplaceFirst (as string: text, as string: target, as string: replacement) as string` | `string` |
| `stringReverse` | `op stringReverse (as string: text) as string` | `string` |
| `stringRepeat` | `op stringRepeat (as string: text, as int64: count) as string` | `string` |
| `stringConcat` | `op stringConcat (as string: left, as string: right) as string` | `string` |
| `stringSurround` | `op stringSurround (as string: text, as string: prefix, as string: suffix) as string` | `string` |

#### Ficha Técnica das Operações:

##### `op stringUpper`
```flux
op stringUpper (as string: text) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringUpper` no domínio `StringTransformContract`.

##### `op stringLower`
```flux
op stringLower (as string: text) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringLower` no domínio `StringTransformContract`.

##### `op stringCapitalize`
```flux
op stringCapitalize (as string: text) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringCapitalize` no domínio `StringTransformContract`.

##### `op stringTrim`
```flux
op stringTrim (as string: text) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringTrim` no domínio `StringTransformContract`.

##### `op stringTrimStart`
```flux
op stringTrimStart (as string: text) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringTrimStart` no domínio `StringTransformContract`.

##### `op stringTrimEnd`
```flux
op stringTrimEnd (as string: text) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringTrimEnd` no domínio `StringTransformContract`.

##### `op stringReplace`
```flux
op stringReplace (as string: text, as string: target, as string: replacement) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
  - `target` (`string`): Parâmetro de entrada para processamento da operação.
  - `replacement` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringReplace` no domínio `StringTransformContract`.

##### `op stringReplaceFirst`
```flux
op stringReplaceFirst (as string: text, as string: target, as string: replacement) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
  - `target` (`string`): Parâmetro de entrada para processamento da operação.
  - `replacement` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringReplaceFirst` no domínio `StringTransformContract`.

##### `op stringReverse`
```flux
op stringReverse (as string: text) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringReverse` no domínio `StringTransformContract`.

##### `op stringRepeat`
```flux
op stringRepeat (as string: text, as int64: count) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
  - `count` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringRepeat` no domínio `StringTransformContract`.

##### `op stringConcat`
```flux
op stringConcat (as string: left, as string: right) as string
```
- **Parâmetros**:
  - `left` (`string`): Parâmetro de entrada para processamento da operação.
  - `right` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringConcat` no domínio `StringTransformContract`.

##### `op stringSurround`
```flux
op stringSurround (as string: text, as string: prefix, as string: suffix) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
  - `prefix` (`string`): Parâmetro de entrada para processamento da operação.
  - `suffix` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringSurround` no domínio `StringTransformContract`.

### 4.7 Contrato `StringUtilityContract` (`StringUtility.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `stringCompare` | `op stringCompare (as string: left, as string: right) as int64` | `int64` |
| `stringEqualsIgnoreCase` | `op stringEqualsIgnoreCase (as string: left, as string: right) as bool` | `bool` |
| `stringSplit` | `op stringSplit (as string: text, as string: separator) as list of data` | `list of data` |
| `stringJoin` | `op stringJoin (as list of data: items, as string: separator) as string` | `string` |

#### Ficha Técnica das Operações:

##### `op stringCompare`
```flux
op stringCompare (as string: left, as string: right) as int64
```
- **Parâmetros**:
  - `left` (`string`): Parâmetro de entrada para processamento da operação.
  - `right` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringCompare` no domínio `StringUtilityContract`.

##### `op stringEqualsIgnoreCase`
```flux
op stringEqualsIgnoreCase (as string: left, as string: right) as bool
```
- **Parâmetros**:
  - `left` (`string`): Parâmetro de entrada para processamento da operação.
  - `right` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringEqualsIgnoreCase` no domínio `StringUtilityContract`.

##### `op stringSplit`
```flux
op stringSplit (as string: text, as string: separator) as list of data
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
  - `separator` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringSplit` no domínio `StringUtilityContract`.

##### `op stringJoin`
```flux
op stringJoin (as list of data: items, as string: separator) as string
```
- **Parâmetros**:
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `separator` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringJoin` no domínio `StringUtilityContract`.

### 4.8 Contrato `StringValidationContract` (`StringValidation.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `stringIsAlpha` | `op stringIsAlpha (as string: text) as bool` | `bool` |
| `stringIsDigit` | `op stringIsDigit (as string: text) as bool` | `bool` |
| `stringIsAlphanumeric` | `op stringIsAlphanumeric (as string: text) as bool` | `bool` |
| `stringIsWhitespace` | `op stringIsWhitespace (as string: text) as bool` | `bool` |
| `stringIsBlank` | `op stringIsBlank (as string: text) as bool` | `bool` |
| `stringIsLower` | `op stringIsLower (as string: text) as bool` | `bool` |
| `stringIsUpper` | `op stringIsUpper (as string: text) as bool` | `bool` |
| `stringIsAscii` | `op stringIsAscii (as string: text) as bool` | `bool` |

#### Ficha Técnica das Operações:

##### `op stringIsAlpha`
```flux
op stringIsAlpha (as string: text) as bool
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringIsAlpha` no domínio `StringValidationContract`.

##### `op stringIsDigit`
```flux
op stringIsDigit (as string: text) as bool
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringIsDigit` no domínio `StringValidationContract`.

##### `op stringIsAlphanumeric`
```flux
op stringIsAlphanumeric (as string: text) as bool
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringIsAlphanumeric` no domínio `StringValidationContract`.

##### `op stringIsWhitespace`
```flux
op stringIsWhitespace (as string: text) as bool
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringIsWhitespace` no domínio `StringValidationContract`.

##### `op stringIsBlank`
```flux
op stringIsBlank (as string: text) as bool
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringIsBlank` no domínio `StringValidationContract`.

##### `op stringIsLower`
```flux
op stringIsLower (as string: text) as bool
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringIsLower` no domínio `StringValidationContract`.

##### `op stringIsUpper`
```flux
op stringIsUpper (as string: text) as bool
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringIsUpper` no domínio `StringValidationContract`.

##### `op stringIsAscii`
```flux
op stringIsAscii (as string: text) as bool
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringIsAscii` no domínio `StringValidationContract`.

---

## 5. Exemplos Canônicos de Uso em TheFlux

O exemplo a seguir demonstra a importação e o consumo prático da biblioteca:

```flux
# Exemplo Canônico de Consumo da StringStdLib
use StringStdLib

program (ExemploStringStdLib) {
      println("==================================================")
      println("  Demonstracao da Standard Library: StringStdLib")
      println("==================================================")

      # Chamada da operacao canônica
      mut as data: resultado = StringStdLib::stringLength("Hello World")
      println("Resultado obtido: " + resultado)

      println("Demonstracao concluida com sucesso.")
}
```

---

> [!TIP]
> Para consultar a visão arquitetural unificada de todas as bibliotecas, consulte o documento principal [StdLibs.md](../StdLibs.md).
