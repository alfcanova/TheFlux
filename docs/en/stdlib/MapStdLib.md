# 📚 `MapStdLib` — Associative Maps (Dictionaries), Aggregations, and Fast Key Lookups

> **Architectural Pillar**: Pillar 2 (Structures & State)  
> **Status**: ✅ Certified with 100% Parity across 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Master File**: `stdlib/MapStdLib/MapStdLib.fdsl`  
> **Import Mode**: `use MapStdLib` or `use MapStdLib::<Module>::<operation>`

---

## 1. Overview and Capabilities

The **`MapStdLib`** standard library is an integral component of the official TheFlux language ecosystem, providing certified system-level algorithms and robust capabilities.

Optimized associative key-value hash tables: amortized O(1) lookups, insertions, and deletions, dictionary merges, key-value inversions, functional aggregations, and entry-level schema validations.

### 1.1 Key Architectural Principles and Design
- **Static Fusion and Zero-Overhead**: All domain modules are transparently fused into the `MapStdLib` unified agent at compile time, avoiding virtual dispatch penalties.
- **Safety and Isolation**: Operations strictly validate parameter bounds and guarantee predictable error semantics via contract definitions.
- **Universal Multi-Backend Parity**: Bit-for-bit identical execution guarantees across interpreter (`in`), bytecode VM (`vm`, `vmr`), native AOT LLVM (`llvm`), and WebAssembly (`wat`, `wasm`).

---

## 2. Modular Structure and Contracts

The library comprises **10 domain modules** declaring a total of **79 public operations**:

| Domain Source File | Formal Contract | Domain Responsibility | Ops Count |
|---|---|---|:---:|
| `MapAccess.fdsl` | `MapAccessContract` | Specialized domain for `MapAccess` | 12 |
| `MapAggregate.fdsl` | `MapAggregateContract` | Specialized domain for `MapAggregate` | 6 |
| `MapBasic.fdsl` | `MapBasicContract` | Specialized domain for `MapBasic` | 19 |
| `MapEntry.fdsl` | `MapEntryContract` | Specialized domain for `MapEntry` | 5 |
| `MapMutation.fdsl` | `MapMutationContract` | Specialized domain for `MapMutation` | 6 |
| `MapRelation.fdsl` | `MapRelationContract` | Specialized domain for `MapRelation` | 5 |
| `MapSearch.fdsl` | `MapSearchContract` | Specialized domain for `MapSearch` | 9 |
| `MapSelection.fdsl` | `MapSelectionContract` | Specialized domain for `MapSelection` | 8 |
| `MapTransform.fdsl` | `MapTransformContract` | Specialized domain for `MapTransform` | 5 |
| `MapUtility.fdsl` | `MapUtilityContract` | Specialized domain for `MapUtility` | 4 |

---

## 3. Public Types, Structures, and Enumerations

The `MapStdLib` library operates directly on primitive native TheFlux types (`string`, `int64`, `float64`, `bool`, `list of data`, etc.) without requiring custom composite types.

---

## 4. Detailed Operations Catalog by Domain

### 4.1 Contract `MapAccessContract` (`MapAccess.fdsl`)

| Operation | Formal Signature | Return Type |
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

#### Operation Technical Specifications:

##### `op mapGet`
```flux
op mapGet (as map: record, as string: key) as data
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
  - `key` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapGet` functionality within the `MapAccessContract` domain.

##### `op mapGetOrDefault`
```flux
op mapGetOrDefault (as map: record, as string: key, as data: default_value) as data
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
  - `key` (`string`): Input argument for operation execution.
  - `default_value` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapGetOrDefault` functionality within the `MapAccessContract` domain.

##### `op mapGetFirst`
```flux
op mapGetFirst (as map: record) as list of data
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapGetFirst` functionality within the `MapAccessContract` domain.

##### `op mapGetAt`
```flux
op mapGetAt (as map: record, as int64: index) as list of data
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
  - `index` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapGetAt` functionality within the `MapAccessContract` domain.

##### `op mapGetLast`
```flux
op mapGetLast (as map: record) as list of data
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapGetLast` functionality within the `MapAccessContract` domain.

##### `op mapGetLeft`
```flux
op mapGetLeft (as map: record, as int64: n) as map
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
  - `n` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapGetLeft` functionality within the `MapAccessContract` domain.

##### `op mapGetRight`
```flux
op mapGetRight (as map: record, as int64: n) as map
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
  - `n` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapGetRight` functionality within the `MapAccessContract` domain.

##### `op mapGetCenter`
```flux
op mapGetCenter (as map: record, as int64: n) as map
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
  - `n` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapGetCenter` functionality within the `MapAccessContract` domain.

##### `op mapSlice`
```flux
op mapSlice (as map: record, as int64: start, as int64: end) as map
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
  - `start` (`int64`): Input argument for operation execution.
  - `end` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapSlice` functionality within the `MapAccessContract` domain.

##### `op mapKeys`
```flux
op mapKeys (as map: record) as list of data
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapKeys` functionality within the `MapAccessContract` domain.

##### `op mapValues`
```flux
op mapValues (as map: record) as list of data
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapValues` functionality within the `MapAccessContract` domain.

##### `op mapEntries`
```flux
op mapEntries (as map: record) as list of data
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapEntries` functionality within the `MapAccessContract` domain.

### 4.2 Contract `MapAggregateContract` (`MapAggregate.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `mapMin` | `op mapMin (as map: record) as data` | `data` |
| `mapMax` | `op mapMax (as map: record) as data` | `data` |
| `mapSum` | `op mapSum (as map: record) as data` | `data` |
| `mapProduct` | `op mapProduct (as map: record) as data` | `data` |
| `mapAverage` | `op mapAverage (as map: record) as float64` | `float64` |
| `mapCountValues` | `op mapCountValues (as map: record, as data: value) as int64` | `int64` |

#### Operation Technical Specifications:

##### `op mapMin`
```flux
op mapMin (as map: record) as data
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapMin` functionality within the `MapAggregateContract` domain.

##### `op mapMax`
```flux
op mapMax (as map: record) as data
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapMax` functionality within the `MapAggregateContract` domain.

##### `op mapSum`
```flux
op mapSum (as map: record) as data
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapSum` functionality within the `MapAggregateContract` domain.

##### `op mapProduct`
```flux
op mapProduct (as map: record) as data
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapProduct` functionality within the `MapAggregateContract` domain.

##### `op mapAverage`
```flux
op mapAverage (as map: record) as float64
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapAverage` functionality within the `MapAggregateContract` domain.

##### `op mapCountValues`
```flux
op mapCountValues (as map: record, as data: value) as int64
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
  - `value` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapCountValues` functionality within the `MapAggregateContract` domain.

### 4.3 Contract `MapBasicContract` (`MapBasic.fdsl`)

| Operation | Formal Signature | Return Type |
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

#### Operation Technical Specifications:

##### `op mapLength`
```flux
op mapLength (as map: record) as int64
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapLength` functionality within the `MapBasicContract` domain.

##### `op mapIsEmpty`
```flux
op mapIsEmpty (as map: record) as bool
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapIsEmpty` functionality within the `MapBasicContract` domain.

##### `op mapIsNotEmpty`
```flux
op mapIsNotEmpty (as map: record) as bool
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapIsNotEmpty` functionality within the `MapBasicContract` domain.

##### `op mapContainsKey`
```flux
op mapContainsKey (as map: record, as string: key) as bool
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
  - `key` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapContainsKey` functionality within the `MapBasicContract` domain.

##### `op mapContainsAnyKey`
```flux
op mapContainsAnyKey (as map: record, as list of data: keys) as bool
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
  - `keys` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapContainsAnyKey` functionality within the `MapBasicContract` domain.

##### `op mapContainsAllKeys`
```flux
op mapContainsAllKeys (as map: record, as list of data: keys) as bool
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
  - `keys` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapContainsAllKeys` functionality within the `MapBasicContract` domain.

##### `op mapContainsValue`
```flux
op mapContainsValue (as map: record, as data: value) as bool
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
  - `value` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapContainsValue` functionality within the `MapBasicContract` domain.

##### `op mapContainsAnyValue`
```flux
op mapContainsAnyValue (as map: record, as list of data: values) as bool
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
  - `values` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapContainsAnyValue` functionality within the `MapBasicContract` domain.

##### `op mapContainsAllValues`
```flux
op mapContainsAllValues (as map: record, as list of data: values) as bool
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
  - `values` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapContainsAllValues` functionality within the `MapBasicContract` domain.

##### `op mapClearAll`
```flux
op mapClearAll (as map: record) as map
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapClearAll` functionality within the `MapBasicContract` domain.

##### `op mapSingleton`
```flux
op mapSingleton (as string: key, as data: value) as map
```
- **Parameters**:
  - `key` (`string`): Input argument for operation execution.
  - `value` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapSingleton` functionality within the `MapBasicContract` domain.

##### `op mapClone`
```flux
op mapClone (as map: record) as map
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapClone` functionality within the `MapBasicContract` domain.

##### `op mapToList`
```flux
op mapToList (as map: record) as list of data
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapToList` functionality within the `MapBasicContract` domain.

##### `op mapToSet`
```flux
op mapToSet (as map: record) as set of data
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `set of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapToSet` functionality within the `MapBasicContract` domain.

##### `op mapToMap`
```flux
op mapToMap (as data: value) as map
```
- **Parameters**:
  - `value` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapToMap` functionality within the `MapBasicContract` domain.

##### `op mapToString`
```flux
op mapToString (as map: record) as string
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `": "`
- **Functional Description**:
  - Executes canonical `mapToString` functionality within the `MapBasicContract` domain.

##### `op mapFromList`
```flux
op mapFromList (as list of data: pairs) as map
```
- **Parameters**:
  - `pairs` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapFromList` functionality within the `MapBasicContract` domain.

##### `op mapFromSet`
```flux
op mapFromSet (as set of data: pairs) as map
```
- **Parameters**:
  - `pairs` (`set of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapFromSet` functionality within the `MapBasicContract` domain.

##### `op mapFromString`
```flux
op mapFromString (as string: text) as map
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapFromString` functionality within the `MapBasicContract` domain.

### 4.4 Contract `MapEntryContract` (`MapEntry.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `mapFromEntries` | `op mapFromEntries (as list of data: entries) as map` | `map` |
| `mapToEntries` | `op mapToEntries (as map: record) as list of data` | `list of data` |
| `mapInvertMulti` | `op mapInvertMulti (as map: record) as map` | `map` |
| `mapGroupListBy` | `op mapGroupListBy (as list of data: items, as string: key_field) as map` | `map` |
| `mapSelectEntries` | `op mapSelectEntries (as map: record, as list of data: keys) as list of data` | `list of data` |

#### Operation Technical Specifications:

##### `op mapFromEntries`
```flux
op mapFromEntries (as list of data: entries) as map
```
- **Parameters**:
  - `entries` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapFromEntries` functionality within the `MapEntryContract` domain.

##### `op mapToEntries`
```flux
op mapToEntries (as map: record) as list of data
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapToEntries` functionality within the `MapEntryContract` domain.

##### `op mapInvertMulti`
```flux
op mapInvertMulti (as map: record) as map
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapInvertMulti` functionality within the `MapEntryContract` domain.

##### `op mapGroupListBy`
```flux
op mapGroupListBy (as list of data: items, as string: key_field) as map
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
  - `key_field` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapGroupListBy` functionality within the `MapEntryContract` domain.

##### `op mapSelectEntries`
```flux
op mapSelectEntries (as map: record, as list of data: keys) as list of data
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
  - `keys` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapSelectEntries` functionality within the `MapEntryContract` domain.

### 4.5 Contract `MapMutationContract` (`MapMutation.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `mapPut` | `op mapPut (as map: record, as string: key, as data: value) as map` | `map` |
| `mapPutIfAbsent` | `op mapPutIfAbsent (as map: record, as string: key, as data: value) as map` | `map` |
| `mapReplace` | `op mapReplace (as map: record, as string: key, as data: value) as map` | `map` |
| `mapPutAll` | `op mapPutAll (as map: record, as map: other) as map` | `map` |
| `mapRemove` | `op mapRemove (as map: record, as string: key) as map` | `map` |
| `mapRemoveAll` | `op mapRemoveAll (as map: record, as list of data: keys) as map` | `map` |

#### Operation Technical Specifications:

##### `op mapPut`
```flux
op mapPut (as map: record, as string: key, as data: value) as map
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
  - `key` (`string`): Input argument for operation execution.
  - `value` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapPut` functionality within the `MapMutationContract` domain.

##### `op mapPutIfAbsent`
```flux
op mapPutIfAbsent (as map: record, as string: key, as data: value) as map
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
  - `key` (`string`): Input argument for operation execution.
  - `value` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapPutIfAbsent` functionality within the `MapMutationContract` domain.

##### `op mapReplace`
```flux
op mapReplace (as map: record, as string: key, as data: value) as map
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
  - `key` (`string`): Input argument for operation execution.
  - `value` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapReplace` functionality within the `MapMutationContract` domain.

##### `op mapPutAll`
```flux
op mapPutAll (as map: record, as map: other) as map
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
  - `other` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapPutAll` functionality within the `MapMutationContract` domain.

##### `op mapRemove`
```flux
op mapRemove (as map: record, as string: key) as map
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
  - `key` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapRemove` functionality within the `MapMutationContract` domain.

##### `op mapRemoveAll`
```flux
op mapRemoveAll (as map: record, as list of data: keys) as map
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
  - `keys` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapRemoveAll` functionality within the `MapMutationContract` domain.

### 4.6 Contract `MapRelationContract` (`MapRelation.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `mapIsSubmap` | `op mapIsSubmap (as map: sub, as map: sup) as bool` | `bool` |
| `mapIsSupermap` | `op mapIsSupermap (as map: sup, as map: sub) as bool` | `bool` |
| `mapHasSameKeys` | `op mapHasSameKeys (as map: lhs, as map: rhs) as bool` | `bool` |
| `mapDisjointKeys` | `op mapDisjointKeys (as map: lhs, as map: rhs) as bool` | `bool` |
| `mapDiffKeys` | `op mapDiffKeys (as map: lhs, as map: rhs) as list of data` | `list of data` |

#### Operation Technical Specifications:

##### `op mapIsSubmap`
```flux
op mapIsSubmap (as map: sub, as map: sup) as bool
```
- **Parameters**:
  - `sub` (`map`): Input argument for operation execution.
  - `sup` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapIsSubmap` functionality within the `MapRelationContract` domain.

##### `op mapIsSupermap`
```flux
op mapIsSupermap (as map: sup, as map: sub) as bool
```
- **Parameters**:
  - `sup` (`map`): Input argument for operation execution.
  - `sub` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapIsSupermap` functionality within the `MapRelationContract` domain.

##### `op mapHasSameKeys`
```flux
op mapHasSameKeys (as map: lhs, as map: rhs) as bool
```
- **Parameters**:
  - `lhs` (`map`): Input argument for operation execution.
  - `rhs` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapHasSameKeys` functionality within the `MapRelationContract` domain.

##### `op mapDisjointKeys`
```flux
op mapDisjointKeys (as map: lhs, as map: rhs) as bool
```
- **Parameters**:
  - `lhs` (`map`): Input argument for operation execution.
  - `rhs` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapDisjointKeys` functionality within the `MapRelationContract` domain.

##### `op mapDiffKeys`
```flux
op mapDiffKeys (as map: lhs, as map: rhs) as list of data
```
- **Parameters**:
  - `lhs` (`map`): Input argument for operation execution.
  - `rhs` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapDiffKeys` functionality within the `MapRelationContract` domain.

### 4.7 Contract `MapSearchContract` (`MapSearch.fdsl`)

| Operation | Formal Signature | Return Type |
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

#### Operation Technical Specifications:

##### `op mapContainsKey`
```flux
op mapContainsKey (as map: record, as string: key) as bool
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
  - `key` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapContainsKey` functionality within the `MapSearchContract` domain.

##### `op mapContainsAnyKey`
```flux
op mapContainsAnyKey (as map: record, as list of data: keys) as bool
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
  - `keys` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapContainsAnyKey` functionality within the `MapSearchContract` domain.

##### `op mapContainsAllKeys`
```flux
op mapContainsAllKeys (as map: record, as list of data: keys) as bool
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
  - `keys` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapContainsAllKeys` functionality within the `MapSearchContract` domain.

##### `op mapContainsValue`
```flux
op mapContainsValue (as map: record, as data: value) as bool
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
  - `value` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapContainsValue` functionality within the `MapSearchContract` domain.

##### `op mapContainsAnyValue`
```flux
op mapContainsAnyValue (as map: record, as list of data: values) as bool
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
  - `values` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapContainsAnyValue` functionality within the `MapSearchContract` domain.

##### `op mapContainsAllValues`
```flux
op mapContainsAllValues (as map: record, as list of data: values) as bool
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
  - `values` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapContainsAllValues` functionality within the `MapSearchContract` domain.

##### `op mapFindKey`
```flux
op mapFindKey (as map: record, as data: value) as data
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
  - `value` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapFindKey` functionality within the `MapSearchContract` domain.

##### `op mapFindKeys`
```flux
op mapFindKeys (as map: record, as data: value) as list of data
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
  - `value` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapFindKeys` functionality within the `MapSearchContract` domain.

##### `op mapCountValues`
```flux
op mapCountValues (as map: record, as data: value) as int64
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
  - `value` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapCountValues` functionality within the `MapSearchContract` domain.

### 4.8 Contract `MapSelectionContract` (`MapSelection.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `mapTake` | `op mapTake (as map: record, as int64: n) as map` | `map` |
| `mapDrop` | `op mapDrop (as map: record, as int64: n) as map` | `map` |
| `mapTakeLast` | `op mapTakeLast (as map: record, as int64: n) as map` | `map` |
| `mapDropLast` | `op mapDropLast (as map: record, as int64: n) as map` | `map` |
| `mapFilterKeys` | `op mapFilterKeys (as map: record, as list of data: allowed_keys) as map` | `map` |
| `mapOmitKeys` | `op mapOmitKeys (as map: record, as list of data: omitted_keys) as map` | `map` |
| `mapFilterValues` | `op mapFilterValues (as map: record, as list of data: allowed_values) as map` | `map` |
| `mapOmitValues` | `op mapOmitValues (as map: record, as list of data: omitted_values) as map` | `map` |

#### Operation Technical Specifications:

##### `op mapTake`
```flux
op mapTake (as map: record, as int64: n) as map
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
  - `n` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapTake` functionality within the `MapSelectionContract` domain.

##### `op mapDrop`
```flux
op mapDrop (as map: record, as int64: n) as map
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
  - `n` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapDrop` functionality within the `MapSelectionContract` domain.

##### `op mapTakeLast`
```flux
op mapTakeLast (as map: record, as int64: n) as map
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
  - `n` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapTakeLast` functionality within the `MapSelectionContract` domain.

##### `op mapDropLast`
```flux
op mapDropLast (as map: record, as int64: n) as map
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
  - `n` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapDropLast` functionality within the `MapSelectionContract` domain.

##### `op mapFilterKeys`
```flux
op mapFilterKeys (as map: record, as list of data: allowed_keys) as map
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
  - `allowed_keys` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapFilterKeys` functionality within the `MapSelectionContract` domain.

##### `op mapOmitKeys`
```flux
op mapOmitKeys (as map: record, as list of data: omitted_keys) as map
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
  - `omitted_keys` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapOmitKeys` functionality within the `MapSelectionContract` domain.

##### `op mapFilterValues`
```flux
op mapFilterValues (as map: record, as list of data: allowed_values) as map
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
  - `allowed_values` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapFilterValues` functionality within the `MapSelectionContract` domain.

##### `op mapOmitValues`
```flux
op mapOmitValues (as map: record, as list of data: omitted_values) as map
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
  - `omitted_values` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapOmitValues` functionality within the `MapSelectionContract` domain.

### 4.9 Contract `MapTransformContract` (`MapTransform.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `mapMerge` | `op mapMerge (as map: left, as map: right) as map` | `map` |
| `mapInvert` | `op mapInvert (as map: record) as map` | `map` |
| `mapZip` | `op mapZip (as list of data: keys, as list of data: values) as map` | `map` |
| `mapFilterKeys` | `op mapFilterKeys (as map: record, as list of data: allowed_keys) as map` | `map` |
| `mapOmitKeys` | `op mapOmitKeys (as map: record, as list of data: omitted_keys) as map` | `map` |

#### Operation Technical Specifications:

##### `op mapMerge`
```flux
op mapMerge (as map: left, as map: right) as map
```
- **Parameters**:
  - `left` (`map`): Input argument for operation execution.
  - `right` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapMerge` functionality within the `MapTransformContract` domain.

##### `op mapInvert`
```flux
op mapInvert (as map: record) as map
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapInvert` functionality within the `MapTransformContract` domain.

##### `op mapZip`
```flux
op mapZip (as list of data: keys, as list of data: values) as map
```
- **Parameters**:
  - `keys` (`list of data`): Input argument for operation execution.
  - `values` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapZip` functionality within the `MapTransformContract` domain.

##### `op mapFilterKeys`
```flux
op mapFilterKeys (as map: record, as list of data: allowed_keys) as map
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
  - `allowed_keys` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapFilterKeys` functionality within the `MapTransformContract` domain.

##### `op mapOmitKeys`
```flux
op mapOmitKeys (as map: record, as list of data: omitted_keys) as map
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
  - `omitted_keys` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapOmitKeys` functionality within the `MapTransformContract` domain.

### 4.10 Contract `MapUtilityContract` (`MapUtility.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `mapEquals` | `op mapEquals (as map: lhs, as map: rhs) as bool` | `bool` |
| `mapSwapKeys` | `op mapSwapKeys (as map: record, as string: key1, as string: key2) as map` | `map` |
| `mapJoin` | `op mapJoin (as map: record, as string: entry_sep, as string: kv_sep) as string` | `string` |
| `mapCount` | `op mapCount (as map: record, as string: key) as int64` | `int64` |

#### Operation Technical Specifications:

##### `op mapEquals`
```flux
op mapEquals (as map: lhs, as map: rhs) as bool
```
- **Parameters**:
  - `lhs` (`map`): Input argument for operation execution.
  - `rhs` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapEquals` functionality within the `MapUtilityContract` domain.

##### `op mapSwapKeys`
```flux
op mapSwapKeys (as map: record, as string: key1, as string: key2) as map
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
  - `key1` (`string`): Input argument for operation execution.
  - `key2` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapSwapKeys` functionality within the `MapUtilityContract` domain.

##### `op mapJoin`
```flux
op mapJoin (as map: record, as string: entry_sep, as string: kv_sep) as string
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
  - `entry_sep` (`string`): Input argument for operation execution.
  - `kv_sep` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapJoin` functionality within the `MapUtilityContract` domain.

##### `op mapCount`
```flux
op mapCount (as map: record, as string: key) as int64
```
- **Parameters**:
  - `record` (`map`): Input argument for operation execution.
  - `key` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapCount` functionality within the `MapUtilityContract` domain.

---

## 5. Canonical Usage Examples in TheFlux

The following snippet illustrates importing and utilizing the library in a TheFlux program:

```flux
# Canonical Usage Example for MapStdLib
use MapStdLib

program (ExampleOfMapStdLib) {
      println("==================================================")
      println("  Standard Library Demonstration: MapStdLib")
      println("==================================================")

      # Invoking canonical operation
      mut as data: result = MapStdLib::mapCount({})
      println("Obtained result: " + result)

      println("Execution completed successfully.")
}
```

---

> [!TIP]
> For the complete unified architecture across all standard libraries, consult the master [StdLibs.md](../StdLibs.md) reference.
