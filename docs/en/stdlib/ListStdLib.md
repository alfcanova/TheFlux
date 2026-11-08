# 📚 `ListStdLib` — Functional List Processing, Aggregations, and In-Place Mutations

> **Architectural Pillar**: Pillar 2 (Structures & State)  
> **Status**: ✅ Certified with 100% Parity across 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Master File**: `stdlib/ListStdLib/ListStdLib.fdsl`  
> **Import Mode**: `use ListStdLib` or `use ListStdLib::<Module>::<operation>`

---

## 1. Overview and Capabilities

The **`ListStdLib`** standard library is an integral component of the official TheFlux language ecosystem, providing certified system-level algorithms and robust capabilities.

Functional and imperative sequence transformations: map, filter, fold reductions, deterministic sorting, partitioning, binary search, element slicing, and cache-friendly in-place array mutations.

### 1.1 Key Architectural Principles and Design
- **Static Fusion and Zero-Overhead**: All domain modules are transparently fused into the `ListStdLib` unified agent at compile time, avoiding virtual dispatch penalties.
- **Safety and Isolation**: Operations strictly validate parameter bounds and guarantee predictable error semantics via contract definitions.
- **Universal Multi-Backend Parity**: Bit-for-bit identical execution guarantees across interpreter (`in`), bytecode VM (`vm`, `vmr`), native AOT LLVM (`llvm`), and WebAssembly (`wat`, `wasm`).

---

## 2. Modular Structure and Contracts

The library comprises **9 domain modules** declaring a total of **81 public operations**:

| Domain Source File | Formal Contract | Domain Responsibility | Ops Count |
|---|---|---|:---:|
| `ListAccess.fdsl` | `ListAccessContract` | Specialized domain for `ListAccess` | 7 |
| `ListAggregate.fdsl` | `ListAggregateContract` | Specialized domain for `ListAggregate` | 6 |
| `ListBasic.fdsl` | `ListBasicContract` | Specialized domain for `ListBasic` | 18 |
| `ListCombinator.fdsl` | `ListCombinatorContract` | Specialized domain for `ListCombinator` | 5 |
| `ListMutation.fdsl` | `ListMutationContract` | Specialized domain for `ListMutation` | 13 |
| `ListSearch.fdsl` | `ListSearchContract` | Specialized domain for `ListSearch` | 8 |
| `ListSelection.fdsl` | `ListSelectionContract` | Specialized domain for `ListSelection` | 7 |
| `ListTransform.fdsl` | `ListTransformContract` | Specialized domain for `ListTransform` | 10 |
| `ListUtility.fdsl` | `ListUtilityContract` | Specialized domain for `ListUtility` | 7 |

---

## 3. Public Types, Structures, and Enumerations

The `ListStdLib` library operates directly on primitive native TheFlux types (`string`, `int64`, `float64`, `bool`, `list of data`, etc.) without requiring custom composite types.

---

## 4. Detailed Operations Catalog by Domain

### 4.1 Contract `ListAccessContract` (`ListAccess.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `listGetFirst` | `op listGetFirst (as list of data: items) as data` | `data` |
| `listGetAt` | `op listGetAt (as list of data: items, as int64: index) as data` | `data` |
| `listGetLast` | `op listGetLast (as list of data: items) as data` | `data` |
| `listGetLeft` | `op listGetLeft (as list of data: items, as int64: n) as list of data` | `list of data` |
| `listGetRight` | `op listGetRight (as list of data: items, as int64: n) as list of data` | `list of data` |
| `listGetCenter` | `op listGetCenter (as list of data: items, as int64: n) as list of data` | `list of data` |
| `listSlice` | `op listSlice (as list of data: items, as int64: start, as int64: end) as list of data` | `list of data` |

#### Operation Technical Specifications:

##### `op listGetFirst`
```flux
op listGetFirst (as list of data: items) as data
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listGetFirst` functionality within the `ListAccessContract` domain.

##### `op listGetAt`
```flux
op listGetAt (as list of data: items, as int64: index) as data
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
  - `index` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listGetAt` functionality within the `ListAccessContract` domain.

##### `op listGetLast`
```flux
op listGetLast (as list of data: items) as data
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listGetLast` functionality within the `ListAccessContract` domain.

##### `op listGetLeft`
```flux
op listGetLeft (as list of data: items, as int64: n) as list of data
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
  - `n` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listGetLeft` functionality within the `ListAccessContract` domain.

##### `op listGetRight`
```flux
op listGetRight (as list of data: items, as int64: n) as list of data
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
  - `n` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listGetRight` functionality within the `ListAccessContract` domain.

##### `op listGetCenter`
```flux
op listGetCenter (as list of data: items, as int64: n) as list of data
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
  - `n` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listGetCenter` functionality within the `ListAccessContract` domain.

##### `op listSlice`
```flux
op listSlice (as list of data: items, as int64: start, as int64: end) as list of data
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
  - `start` (`int64`): Input argument for operation execution.
  - `end` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listSlice` functionality within the `ListAccessContract` domain.

### 4.2 Contract `ListAggregateContract` (`ListAggregate.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `listMin` | `op listMin (as list of data: items) as data` | `data` |
| `listMax` | `op listMax (as list of data: items) as data` | `data` |
| `listSum` | `op listSum (as list of data: items) as data` | `data` |
| `listProduct` | `op listProduct (as list of data: items) as data` | `data` |
| `listAverage` | `op listAverage (as list of data: items) as float64` | `float64` |
| `listCountValues` | `op listCountValues (as list of data: items, as data: value) as int64` | `int64` |

#### Operation Technical Specifications:

##### `op listMin`
```flux
op listMin (as list of data: items) as data
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listMin` functionality within the `ListAggregateContract` domain.

##### `op listMax`
```flux
op listMax (as list of data: items) as data
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listMax` functionality within the `ListAggregateContract` domain.

##### `op listSum`
```flux
op listSum (as list of data: items) as data
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listSum` functionality within the `ListAggregateContract` domain.

##### `op listProduct`
```flux
op listProduct (as list of data: items) as data
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listProduct` functionality within the `ListAggregateContract` domain.

##### `op listAverage`
```flux
op listAverage (as list of data: items) as float64
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listAverage` functionality within the `ListAggregateContract` domain.

##### `op listCountValues`
```flux
op listCountValues (as list of data: items, as data: value) as int64
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
  - `value` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listCountValues` functionality within the `ListAggregateContract` domain.

### 4.3 Contract `ListBasicContract` (`ListBasic.fdsl`)

| Operation | Formal Signature | Return Type |
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

#### Operation Technical Specifications:

##### `op listLength`
```flux
op listLength (as list of data: value) as int64
```
- **Parameters**:
  - `value` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listLength` functionality within the `ListBasicContract` domain.

##### `op listIsEmpty`
```flux
op listIsEmpty (as list of data: value) as bool
```
- **Parameters**:
  - `value` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listIsEmpty` functionality within the `ListBasicContract` domain.

##### `op listIsNotEmpty`
```flux
op listIsNotEmpty (as list of data: value) as bool
```
- **Parameters**:
  - `value` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listIsNotEmpty` functionality within the `ListBasicContract` domain.

##### `op listContains`
```flux
op listContains (as list of data: value, as data: item) as bool
```
- **Parameters**:
  - `value` (`list of data`): Input argument for operation execution.
  - `item` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listContains` functionality within the `ListBasicContract` domain.

##### `op listContainsAny`
```flux
op listContainsAny (as list of data: value, as list of data: items) as bool
```
- **Parameters**:
  - `value` (`list of data`): Input argument for operation execution.
  - `items` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listContainsAny` functionality within the `ListBasicContract` domain.

##### `op listContainsAll`
```flux
op listContainsAll (as list of data: items, as list of data: subset) as bool
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
  - `subset` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listContainsAll` functionality within the `ListBasicContract` domain.

##### `op listClearAll`
```flux
op listClearAll (as list of data: value) as list of data
```
- **Parameters**:
  - `value` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listClearAll` functionality within the `ListBasicContract` domain.

##### `op listSingleton`
```flux
op listSingleton (as data: value) as list of data
```
- **Parameters**:
  - `value` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listSingleton` functionality within the `ListBasicContract` domain.

##### `op listSingletonInt`
```flux
op listSingletonInt (as int64: value) as list of data
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listSingletonInt` functionality within the `ListBasicContract` domain.

##### `op listSingletonString`
```flux
op listSingletonString (as string: value) as list of data
```
- **Parameters**:
  - `value` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listSingletonString` functionality within the `ListBasicContract` domain.

##### `op listClone`
```flux
op listClone (as list of data: value) as list of data
```
- **Parameters**:
  - `value` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listClone` functionality within the `ListBasicContract` domain.

##### `op listToList`
```flux
op listToList (as data: value) as list of data
```
- **Parameters**:
  - `value` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listToList` functionality within the `ListBasicContract` domain.

##### `op listToSet`
```flux
op listToSet (as data: value) as set of data
```
- **Parameters**:
  - `value` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `set of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listToSet` functionality within the `ListBasicContract` domain.

##### `op listToMap`
```flux
op listToMap (as list of data: value) as map
```
- **Parameters**:
  - `value` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listToMap` functionality within the `ListBasicContract` domain.

##### `op listToString`
```flux
op listToString (as list of data: value) as string
```
- **Parameters**:
  - `value` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `", "`
- **Functional Description**:
  - Executes canonical `listToString` functionality within the `ListBasicContract` domain.

##### `op listFromList`
```flux
op listFromList (as list of data: items) as list of data
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listFromList` functionality within the `ListBasicContract` domain.

##### `op listFromSet`
```flux
op listFromSet (as set of data: items) as list of data
```
- **Parameters**:
  - `items` (`set of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listFromSet` functionality within the `ListBasicContract` domain.

##### `op listFromString`
```flux
op listFromString (as string: text) as list of data
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listFromString` functionality within the `ListBasicContract` domain.

### 4.4 Contract `ListCombinatorContract` (`ListCombinator.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `listChunk` | `op listChunk (as list of data: items, as int64: size) as list of data` | `list of data` |
| `listWindow` | `op listWindow (as list of data: items, as int64: size) as list of data` | `list of data` |
| `listFrequencies` | `op listFrequencies (as list of data: items) as map` | `map` |
| `listCartesian` | `op listCartesian (as list of data: lhs, as list of data: rhs) as list of data` | `list of data` |
| `listCombinations` | `op listCombinations (as list of data: items, as int64: k) as list of data` | `list of data` |

#### Operation Technical Specifications:

##### `op listChunk`
```flux
op listChunk (as list of data: items, as int64: size) as list of data
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
  - `size` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listChunk` functionality within the `ListCombinatorContract` domain.

##### `op listWindow`
```flux
op listWindow (as list of data: items, as int64: size) as list of data
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
  - `size` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listWindow` functionality within the `ListCombinatorContract` domain.

##### `op listFrequencies`
```flux
op listFrequencies (as list of data: items) as map
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listFrequencies` functionality within the `ListCombinatorContract` domain.

##### `op listCartesian`
```flux
op listCartesian (as list of data: lhs, as list of data: rhs) as list of data
```
- **Parameters**:
  - `lhs` (`list of data`): Input argument for operation execution.
  - `rhs` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listCartesian` functionality within the `ListCombinatorContract` domain.

##### `op listCombinations`
```flux
op listCombinations (as list of data: items, as int64: k) as list of data
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
  - `k` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listCombinations` functionality within the `ListCombinatorContract` domain.

### 4.5 Contract `ListMutationContract` (`ListMutation.fdsl`)

| Operation | Formal Signature | Return Type |
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

#### Operation Technical Specifications:

##### `op listPushFront`
```flux
op listPushFront (as list of data: items, as data: item) as list of data
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
  - `item` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listPushFront` functionality within the `ListMutationContract` domain.

##### `op listPushBack`
```flux
op listPushBack (as list of data: items, as data: item) as list of data
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
  - `item` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listPushBack` functionality within the `ListMutationContract` domain.

##### `op listPrepend`
```flux
op listPrepend (as list of data: items, as list of data: other) as list of data
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
  - `other` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listPrepend` functionality within the `ListMutationContract` domain.

##### `op listAppend`
```flux
op listAppend (as list of data: items, as list of data: other) as list of data
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
  - `other` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listAppend` functionality within the `ListMutationContract` domain.

##### `op listInsertFirst`
```flux
op listInsertFirst (as list of data: items, as data: item) as list of data
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
  - `item` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listInsertFirst` functionality within the `ListMutationContract` domain.

##### `op listInsertAt`
```flux
op listInsertAt (as list of data: items, as int64: index, as data: item) as list of data
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
  - `index` (`int64`): Input argument for operation execution.
  - `item` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listInsertAt` functionality within the `ListMutationContract` domain.

##### `op listInsertLast`
```flux
op listInsertLast (as list of data: items, as data: item) as list of data
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
  - `item` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listInsertLast` functionality within the `ListMutationContract` domain.

##### `op listInsertAll`
```flux
op listInsertAll (as list of data: items, as int64: index, as list of data: other) as list of data
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
  - `index` (`int64`): Input argument for operation execution.
  - `other` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listInsertAll` functionality within the `ListMutationContract` domain.

##### `op listRemoveFirst`
```flux
op listRemoveFirst (as list of data: items) as list of data
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listRemoveFirst` functionality within the `ListMutationContract` domain.

##### `op listRemoveAt`
```flux
op listRemoveAt (as list of data: items, as int64: index) as list of data
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
  - `index` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listRemoveAt` functionality within the `ListMutationContract` domain.

##### `op listRemoveLast`
```flux
op listRemoveLast (as list of data: items) as list of data
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listRemoveLast` functionality within the `ListMutationContract` domain.

##### `op listRemove`
```flux
op listRemove (as list of data: items, as data: item) as list of data
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
  - `item` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listRemove` functionality within the `ListMutationContract` domain.

##### `op listRemoveAll`
```flux
op listRemoveAll (as list of data: items, as data: item) as list of data
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
  - `item` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listRemoveAll` functionality within the `ListMutationContract` domain.

### 4.6 Contract `ListSearchContract` (`ListSearch.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `listContains` | `op listContains (as list of data: items, as data: item) as bool` | `bool` |
| `listContainsAny` | `op listContainsAny (as list of data: items, as list of data: needles) as bool` | `bool` |
| `listContainsAll` | `op listContainsAll (as list of data: items, as list of data: subset) as bool` | `bool` |
| `listStartsWith` | `op listStartsWith (as list of data: items, as list of data: prefix) as bool` | `bool` |
| `listEndsWith` | `op listEndsWith (as list of data: items, as list of data: suffix) as bool` | `bool` |
| `listIndexOf` | `op listIndexOf (as list of data: items, as data: item) as int64` | `int64` |
| `listLastIndexOf` | `op listLastIndexOf (as list of data: items, as data: item) as int64` | `int64` |
| `listCount` | `op listCount (as list of data: items, as data: item) as int64` | `int64` |

#### Operation Technical Specifications:

##### `op listContains`
```flux
op listContains (as list of data: items, as data: item) as bool
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
  - `item` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listContains` functionality within the `ListSearchContract` domain.

##### `op listContainsAny`
```flux
op listContainsAny (as list of data: items, as list of data: needles) as bool
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
  - `needles` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listContainsAny` functionality within the `ListSearchContract` domain.

##### `op listContainsAll`
```flux
op listContainsAll (as list of data: items, as list of data: subset) as bool
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
  - `subset` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listContainsAll` functionality within the `ListSearchContract` domain.

##### `op listStartsWith`
```flux
op listStartsWith (as list of data: items, as list of data: prefix) as bool
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
  - `prefix` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listStartsWith` functionality within the `ListSearchContract` domain.

##### `op listEndsWith`
```flux
op listEndsWith (as list of data: items, as list of data: suffix) as bool
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
  - `suffix` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listEndsWith` functionality within the `ListSearchContract` domain.

##### `op listIndexOf`
```flux
op listIndexOf (as list of data: items, as data: item) as int64
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
  - `item` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listIndexOf` functionality within the `ListSearchContract` domain.

##### `op listLastIndexOf`
```flux
op listLastIndexOf (as list of data: items, as data: item) as int64
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
  - `item` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listLastIndexOf` functionality within the `ListSearchContract` domain.

##### `op listCount`
```flux
op listCount (as list of data: items, as data: item) as int64
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
  - `item` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listCount` functionality within the `ListSearchContract` domain.

### 4.7 Contract `ListSelectionContract` (`ListSelection.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `listTake` | `op listTake (as list of data: items, as int64: n) as list of data` | `list of data` |
| `listDrop` | `op listDrop (as list of data: items, as int64: n) as list of data` | `list of data` |
| `listTakeLast` | `op listTakeLast (as list of data: items, as int64: n) as list of data` | `list of data` |
| `listDropLast` | `op listDropLast (as list of data: items, as int64: n) as list of data` | `list of data` |
| `listFilter` | `op listFilter (as list of data: items, as list of data: allowed_items) as list of data` | `list of data` |
| `listOmit` | `op listOmit (as list of data: items, as list of data: omitted_items) as list of data` | `list of data` |
| `listDistinct` | `op listDistinct (as list of data: items) as list of data` | `list of data` |

#### Operation Technical Specifications:

##### `op listTake`
```flux
op listTake (as list of data: items, as int64: n) as list of data
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
  - `n` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listTake` functionality within the `ListSelectionContract` domain.

##### `op listDrop`
```flux
op listDrop (as list of data: items, as int64: n) as list of data
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
  - `n` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listDrop` functionality within the `ListSelectionContract` domain.

##### `op listTakeLast`
```flux
op listTakeLast (as list of data: items, as int64: n) as list of data
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
  - `n` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listTakeLast` functionality within the `ListSelectionContract` domain.

##### `op listDropLast`
```flux
op listDropLast (as list of data: items, as int64: n) as list of data
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
  - `n` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listDropLast` functionality within the `ListSelectionContract` domain.

##### `op listFilter`
```flux
op listFilter (as list of data: items, as list of data: allowed_items) as list of data
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
  - `allowed_items` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listFilter` functionality within the `ListSelectionContract` domain.

##### `op listOmit`
```flux
op listOmit (as list of data: items, as list of data: omitted_items) as list of data
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
  - `omitted_items` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listOmit` functionality within the `ListSelectionContract` domain.

##### `op listDistinct`
```flux
op listDistinct (as list of data: items) as list of data
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listDistinct` functionality within the `ListSelectionContract` domain.

### 4.8 Contract `ListTransformContract` (`ListTransform.fdsl`)

| Operation | Formal Signature | Return Type |
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

#### Operation Technical Specifications:

##### `op listSort`
```flux
op listSort (as list of data: items) as list of data
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listSort` functionality within the `ListTransformContract` domain.

##### `op listSortAscending`
```flux
op listSortAscending (as list of data: items) as list of data
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listSortAscending` functionality within the `ListTransformContract` domain.

##### `op listSortDescending`
```flux
op listSortDescending (as list of data: items) as list of data
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listSortDescending` functionality within the `ListTransformContract` domain.

##### `op listReverse`
```flux
op listReverse (as list of data: items) as list of data
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listReverse` functionality within the `ListTransformContract` domain.

##### `op listRotateLeft`
```flux
op listRotateLeft (as list of data: items, as int64: n) as list of data
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
  - `n` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listRotateLeft` functionality within the `ListTransformContract` domain.

##### `op listRotateRight`
```flux
op listRotateRight (as list of data: items, as int64: n) as list of data
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
  - `n` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listRotateRight` functionality within the `ListTransformContract` domain.

##### `op listFlatten`
```flux
op listFlatten (as list of data: items) as list of data
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listFlatten` functionality within the `ListTransformContract` domain.

##### `op listPartition`
```flux
op listPartition (as list of data: items, as int64: size) as list of data
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
  - `size` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listPartition` functionality within the `ListTransformContract` domain.

##### `op listZip`
```flux
op listZip (as list of data: left, as list of data: right) as list of data
```
- **Parameters**:
  - `left` (`list of data`): Input argument for operation execution.
  - `right` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listZip` functionality within the `ListTransformContract` domain.

##### `op listUnzip`
```flux
op listUnzip (as list of data: pairs) as list of data
```
- **Parameters**:
  - `pairs` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listUnzip` functionality within the `ListTransformContract` domain.

### 4.9 Contract `ListUtilityContract` (`ListUtility.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `listEquals` | `op listEquals (as list of data: lhs, as list of data: rhs) as bool` | `bool` |
| `listJoin` | `op listJoin (as list of data: items, as string: separator) as string` | `string` |
| `listSwap` | `op listSwap (as list of data: items, as int64: i, as int64: j) as list of data` | `list of data` |
| `listReplaceAt` | `op listReplaceAt (as list of data: items, as int64: index, as data: item) as list of data` | `list of data` |
| `listConcat` | `op listConcat (as list of data: left, as list of data: right) as list of data` | `list of data` |
| `listRepeat` | `op listRepeat (as data: item, as int64: count) as list of data` | `list of data` |
| `listFill` | `op listFill (as list of data: items, as data: value) as list of data` | `list of data` |

#### Operation Technical Specifications:

##### `op listEquals`
```flux
op listEquals (as list of data: lhs, as list of data: rhs) as bool
```
- **Parameters**:
  - `lhs` (`list of data`): Input argument for operation execution.
  - `rhs` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listEquals` functionality within the `ListUtilityContract` domain.

##### `op listJoin`
```flux
op listJoin (as list of data: items, as string: separator) as string
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
  - `separator` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listJoin` functionality within the `ListUtilityContract` domain.

##### `op listSwap`
```flux
op listSwap (as list of data: items, as int64: i, as int64: j) as list of data
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
  - `i` (`int64`): Input argument for operation execution.
  - `j` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listSwap` functionality within the `ListUtilityContract` domain.

##### `op listReplaceAt`
```flux
op listReplaceAt (as list of data: items, as int64: index, as data: item) as list of data
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
  - `index` (`int64`): Input argument for operation execution.
  - `item` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listReplaceAt` functionality within the `ListUtilityContract` domain.

##### `op listConcat`
```flux
op listConcat (as list of data: left, as list of data: right) as list of data
```
- **Parameters**:
  - `left` (`list of data`): Input argument for operation execution.
  - `right` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listConcat` functionality within the `ListUtilityContract` domain.

##### `op listRepeat`
```flux
op listRepeat (as data: item, as int64: count) as list of data
```
- **Parameters**:
  - `item` (`data`): Input argument for operation execution.
  - `count` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listRepeat` functionality within the `ListUtilityContract` domain.

##### `op listFill`
```flux
op listFill (as list of data: items, as data: value) as list of data
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
  - `value` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listFill` functionality within the `ListUtilityContract` domain.

---

## 5. Canonical Usage Examples in TheFlux

The following snippet illustrates importing and utilizing the library in a TheFlux program:

```flux
# Canonical Usage Example for ListStdLib
use ListStdLib

program (ExampleOfListStdLib) {
      println("==================================================")
      println("  Standard Library Demonstration: ListStdLib")
      println("==================================================")

      # Invoking canonical operation
      mut as data: result = ListStdLib::listLength([])
      println("Obtained result: " + result)

      println("Execution completed successfully.")
}
```

---

> [!TIP]
> For the complete unified architecture across all standard libraries, consult the master [StdLibs.md](../StdLibs.md) reference.
