# 📚 `SetStdLib` — Set Algebra, Mathematical Set Operations, and Membership

> **Architectural Pillar**: Pillar 2 (Structures & State)  
> **Status**: ✅ Certified with 100% Parity across 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Master File**: `stdlib/SetStdLib/SetStdLib.fdsl`  
> **Import Mode**: `use SetStdLib` or `use SetStdLib::<Module>::<operation>`

---

## 1. Overview and Capabilities

The **`SetStdLib`** standard library is an integral component of the official TheFlux language ecosystem, providing certified system-level algorithms and robust capabilities.

Mathematical set theory primitives: set union, intersection, relative complement (difference), symmetric difference, membership queries, subset/superset validation, and duplicate elimination.

### 1.1 Key Architectural Principles and Design
- **Static Fusion and Zero-Overhead**: All domain modules are transparently fused into the `SetStdLib` unified agent at compile time, avoiding virtual dispatch penalties.
- **Safety and Isolation**: Operations strictly validate parameter bounds and guarantee predictable error semantics via contract definitions.
- **Universal Multi-Backend Parity**: Bit-for-bit identical execution guarantees across interpreter (`in`), bytecode VM (`vm`, `vmr`), native AOT LLVM (`llvm`), and WebAssembly (`wat`, `wasm`).

---

## 2. Modular Structure and Contracts

The library comprises **10 domain modules** declaring a total of **62 public operations**:

| Domain Source File | Formal Contract | Domain Responsibility | Ops Count |
|---|---|---|:---:|
| `SetAccess.fdsl` | `SetAccessContract` | Specialized domain for `SetAccess` | 7 |
| `SetAggregate.fdsl` | `SetAggregateContract` | Specialized domain for `SetAggregate` | 6 |
| `SetAlgebra.fdsl` | `SetAlgebraContract` | Specialized domain for `SetAlgebra` | 4 |
| `SetBasic.fdsl` | `SetBasicContract` | Specialized domain for `SetBasic` | 18 |
| `SetMutation.fdsl` | `SetMutationContract` | Specialized domain for `SetMutation` | 4 |
| `SetRelation.fdsl` | `SetRelationContract` | Specialized domain for `SetRelation` | 5 |
| `SetSearch.fdsl` | `SetSearchContract` | Specialized domain for `SetSearch` | 5 |
| `SetSelection.fdsl` | `SetSelectionContract` | Specialized domain for `SetSelection` | 6 |
| `SetTransform.fdsl` | `SetTransformContract` | Specialized domain for `SetTransform` | 4 |
| `SetUtility.fdsl` | `SetUtilityContract` | Specialized domain for `SetUtility` | 3 |

---

## 3. Public Types, Structures, and Enumerations

The `SetStdLib` library operates directly on primitive native TheFlux types (`string`, `int64`, `float64`, `bool`, `list of data`, etc.) without requiring custom composite types.

---

## 4. Detailed Operations Catalog by Domain

### 4.1 Contract `SetAccessContract` (`SetAccess.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `setGetFirst` | `op setGetFirst (as set of data: items) as data` | `data` |
| `setGetAt` | `op setGetAt (as set of data: items, as int64: index) as data` | `data` |
| `setGetLast` | `op setGetLast (as set of data: items) as data` | `data` |
| `setGetLeft` | `op setGetLeft (as set of data: items, as int64: n) as set of data` | `set of data` |
| `setGetRight` | `op setGetRight (as set of data: items, as int64: n) as set of data` | `set of data` |
| `setGetCenter` | `op setGetCenter (as set of data: items, as int64: n) as set of data` | `set of data` |
| `setSlice` | `op setSlice (as set of data: items, as int64: start, as int64: end) as set of data` | `set of data` |

#### Operation Technical Specifications:

##### `op setGetFirst`
```flux
op setGetFirst (as set of data: items) as data
```
- **Parameters**:
  - `items` (`set of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setGetFirst` functionality within the `SetAccessContract` domain.

##### `op setGetAt`
```flux
op setGetAt (as set of data: items, as int64: index) as data
```
- **Parameters**:
  - `items` (`set of data`): Input argument for operation execution.
  - `index` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setGetAt` functionality within the `SetAccessContract` domain.

##### `op setGetLast`
```flux
op setGetLast (as set of data: items) as data
```
- **Parameters**:
  - `items` (`set of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setGetLast` functionality within the `SetAccessContract` domain.

##### `op setGetLeft`
```flux
op setGetLeft (as set of data: items, as int64: n) as set of data
```
- **Parameters**:
  - `items` (`set of data`): Input argument for operation execution.
  - `n` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `set of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setGetLeft` functionality within the `SetAccessContract` domain.

##### `op setGetRight`
```flux
op setGetRight (as set of data: items, as int64: n) as set of data
```
- **Parameters**:
  - `items` (`set of data`): Input argument for operation execution.
  - `n` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `set of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setGetRight` functionality within the `SetAccessContract` domain.

##### `op setGetCenter`
```flux
op setGetCenter (as set of data: items, as int64: n) as set of data
```
- **Parameters**:
  - `items` (`set of data`): Input argument for operation execution.
  - `n` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `set of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setGetCenter` functionality within the `SetAccessContract` domain.

##### `op setSlice`
```flux
op setSlice (as set of data: items, as int64: start, as int64: end) as set of data
```
- **Parameters**:
  - `items` (`set of data`): Input argument for operation execution.
  - `start` (`int64`): Input argument for operation execution.
  - `end` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `set of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setSlice` functionality within the `SetAccessContract` domain.

### 4.2 Contract `SetAggregateContract` (`SetAggregate.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `setMin` | `op setMin (as set of data: items) as data` | `data` |
| `setMax` | `op setMax (as set of data: items) as data` | `data` |
| `setSum` | `op setSum (as set of data: items) as data` | `data` |
| `setProduct` | `op setProduct (as set of data: items) as data` | `data` |
| `setAverage` | `op setAverage (as set of data: items) as float64` | `float64` |
| `setCountValues` | `op setCountValues (as set of data: items, as data: value) as int64` | `int64` |

#### Operation Technical Specifications:

##### `op setMin`
```flux
op setMin (as set of data: items) as data
```
- **Parameters**:
  - `items` (`set of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setMin` functionality within the `SetAggregateContract` domain.

##### `op setMax`
```flux
op setMax (as set of data: items) as data
```
- **Parameters**:
  - `items` (`set of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setMax` functionality within the `SetAggregateContract` domain.

##### `op setSum`
```flux
op setSum (as set of data: items) as data
```
- **Parameters**:
  - `items` (`set of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setSum` functionality within the `SetAggregateContract` domain.

##### `op setProduct`
```flux
op setProduct (as set of data: items) as data
```
- **Parameters**:
  - `items` (`set of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setProduct` functionality within the `SetAggregateContract` domain.

##### `op setAverage`
```flux
op setAverage (as set of data: items) as float64
```
- **Parameters**:
  - `items` (`set of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setAverage` functionality within the `SetAggregateContract` domain.

##### `op setCountValues`
```flux
op setCountValues (as set of data: items, as data: value) as int64
```
- **Parameters**:
  - `items` (`set of data`): Input argument for operation execution.
  - `value` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setCountValues` functionality within the `SetAggregateContract` domain.

### 4.3 Contract `SetAlgebraContract` (`SetAlgebra.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `setUnion` | `op setUnion (as set of data: lhs, as set of data: rhs) as set of data` | `set of data` |
| `setIntersect` | `op setIntersect (as set of data: lhs, as set of data: rhs) as set of data` | `set of data` |
| `setDifference` | `op setDifference (as set of data: lhs, as set of data: rhs) as set of data` | `set of data` |
| `setSymmetricDifference` | `op setSymmetricDifference (as set of data: lhs, as set of data: rhs) as set of data` | `set of data` |

#### Operation Technical Specifications:

##### `op setUnion`
```flux
op setUnion (as set of data: lhs, as set of data: rhs) as set of data
```
- **Parameters**:
  - `lhs` (`set of data`): Input argument for operation execution.
  - `rhs` (`set of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `set of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setUnion` functionality within the `SetAlgebraContract` domain.

##### `op setIntersect`
```flux
op setIntersect (as set of data: lhs, as set of data: rhs) as set of data
```
- **Parameters**:
  - `lhs` (`set of data`): Input argument for operation execution.
  - `rhs` (`set of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `set of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setIntersect` functionality within the `SetAlgebraContract` domain.

##### `op setDifference`
```flux
op setDifference (as set of data: lhs, as set of data: rhs) as set of data
```
- **Parameters**:
  - `lhs` (`set of data`): Input argument for operation execution.
  - `rhs` (`set of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `set of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setDifference` functionality within the `SetAlgebraContract` domain.

##### `op setSymmetricDifference`
```flux
op setSymmetricDifference (as set of data: lhs, as set of data: rhs) as set of data
```
- **Parameters**:
  - `lhs` (`set of data`): Input argument for operation execution.
  - `rhs` (`set of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `set of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setSymmetricDifference` functionality within the `SetAlgebraContract` domain.

### 4.4 Contract `SetBasicContract` (`SetBasic.fdsl`)

| Operation | Formal Signature | Return Type |
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

#### Operation Technical Specifications:

##### `op setLength`
```flux
op setLength (as set of data: items) as int64
```
- **Parameters**:
  - `items` (`set of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setLength` functionality within the `SetBasicContract` domain.

##### `op setIsEmpty`
```flux
op setIsEmpty (as set of data: items) as bool
```
- **Parameters**:
  - `items` (`set of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setIsEmpty` functionality within the `SetBasicContract` domain.

##### `op setIsNotEmpty`
```flux
op setIsNotEmpty (as set of data: items) as bool
```
- **Parameters**:
  - `items` (`set of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setIsNotEmpty` functionality within the `SetBasicContract` domain.

##### `op setContains`
```flux
op setContains (as set of data: items, as data: item) as bool
```
- **Parameters**:
  - `items` (`set of data`): Input argument for operation execution.
  - `item` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setContains` functionality within the `SetBasicContract` domain.

##### `op setContainsAny`
```flux
op setContainsAny (as set of data: lhs, as set of data: rhs) as bool
```
- **Parameters**:
  - `lhs` (`set of data`): Input argument for operation execution.
  - `rhs` (`set of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setContainsAny` functionality within the `SetBasicContract` domain.

##### `op setContainsAll`
```flux
op setContainsAll (as set of data: lhs, as set of data: rhs) as bool
```
- **Parameters**:
  - `lhs` (`set of data`): Input argument for operation execution.
  - `rhs` (`set of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setContainsAll` functionality within the `SetBasicContract` domain.

##### `op setClearAll`
```flux
op setClearAll (as set of data: items) as set of data
```
- **Parameters**:
  - `items` (`set of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `set of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setClearAll` functionality within the `SetBasicContract` domain.

##### `op setSingleton`
```flux
op setSingleton (as data: value) as set of data
```
- **Parameters**:
  - `value` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `set of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setSingleton` functionality within the `SetBasicContract` domain.

##### `op setSingletonInt`
```flux
op setSingletonInt (as int64: value) as set of data
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `set of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setSingletonInt` functionality within the `SetBasicContract` domain.

##### `op setSingletonString`
```flux
op setSingletonString (as string: value) as set of data
```
- **Parameters**:
  - `value` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `set of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setSingletonString` functionality within the `SetBasicContract` domain.

##### `op setClone`
```flux
op setClone (as set of data: items) as set of data
```
- **Parameters**:
  - `items` (`set of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `set of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setClone` functionality within the `SetBasicContract` domain.

##### `op setToList`
```flux
op setToList (as set of data: items) as list of data
```
- **Parameters**:
  - `items` (`set of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setToList` functionality within the `SetBasicContract` domain.

##### `op setToSet`
```flux
op setToSet (as data: value) as set of data
```
- **Parameters**:
  - `value` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `set of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setToSet` functionality within the `SetBasicContract` domain.

##### `op setToMap`
```flux
op setToMap (as set of data: value) as map
```
- **Parameters**:
  - `value` (`set of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setToMap` functionality within the `SetBasicContract` domain.

##### `op setToString`
```flux
op setToString (as set of data: items) as string
```
- **Parameters**:
  - `items` (`set of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `", "`
- **Functional Description**:
  - Executes canonical `setToString` functionality within the `SetBasicContract` domain.

##### `op setFromList`
```flux
op setFromList (as list of data: items) as set of data
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `set of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setFromList` functionality within the `SetBasicContract` domain.

##### `op setFromSet`
```flux
op setFromSet (as set of data: items) as set of data
```
- **Parameters**:
  - `items` (`set of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `set of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setFromSet` functionality within the `SetBasicContract` domain.

##### `op setFromString`
```flux
op setFromString (as string: text) as set of data
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `set of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setFromString` functionality within the `SetBasicContract` domain.

### 4.5 Contract `SetMutationContract` (`SetMutation.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `setInclude` | `op setInclude (as set of data: items, as data: item) as set of data` | `set of data` |
| `setIncludeAll` | `op setIncludeAll (as set of data: items, as set of data: other) as set of data` | `set of data` |
| `setExclude` | `op setExclude (as set of data: items, as data: item) as set of data` | `set of data` |
| `setExcludeAll` | `op setExcludeAll (as set of data: items, as set of data: other) as set of data` | `set of data` |

#### Operation Technical Specifications:

##### `op setInclude`
```flux
op setInclude (as set of data: items, as data: item) as set of data
```
- **Parameters**:
  - `items` (`set of data`): Input argument for operation execution.
  - `item` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `set of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setInclude` functionality within the `SetMutationContract` domain.

##### `op setIncludeAll`
```flux
op setIncludeAll (as set of data: items, as set of data: other) as set of data
```
- **Parameters**:
  - `items` (`set of data`): Input argument for operation execution.
  - `other` (`set of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `set of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setIncludeAll` functionality within the `SetMutationContract` domain.

##### `op setExclude`
```flux
op setExclude (as set of data: items, as data: item) as set of data
```
- **Parameters**:
  - `items` (`set of data`): Input argument for operation execution.
  - `item` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `set of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setExclude` functionality within the `SetMutationContract` domain.

##### `op setExcludeAll`
```flux
op setExcludeAll (as set of data: items, as set of data: other) as set of data
```
- **Parameters**:
  - `items` (`set of data`): Input argument for operation execution.
  - `other` (`set of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `set of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setExcludeAll` functionality within the `SetMutationContract` domain.

### 4.6 Contract `SetRelationContract` (`SetRelation.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `setIsSubset` | `op setIsSubset (as set of data: lhs, as set of data: rhs) as bool` | `bool` |
| `setIsSuperset` | `op setIsSuperset (as set of data: lhs, as set of data: rhs) as bool` | `bool` |
| `setIsDisjoint` | `op setIsDisjoint (as set of data: lhs, as set of data: rhs) as bool` | `bool` |
| `setIsProperSubset` | `op setIsProperSubset (as set of data: lhs, as set of data: rhs) as bool` | `bool` |
| `setIsProperSuperset` | `op setIsProperSuperset (as set of data: lhs, as set of data: rhs) as bool` | `bool` |

#### Operation Technical Specifications:

##### `op setIsSubset`
```flux
op setIsSubset (as set of data: lhs, as set of data: rhs) as bool
```
- **Parameters**:
  - `lhs` (`set of data`): Input argument for operation execution.
  - `rhs` (`set of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setIsSubset` functionality within the `SetRelationContract` domain.

##### `op setIsSuperset`
```flux
op setIsSuperset (as set of data: lhs, as set of data: rhs) as bool
```
- **Parameters**:
  - `lhs` (`set of data`): Input argument for operation execution.
  - `rhs` (`set of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setIsSuperset` functionality within the `SetRelationContract` domain.

##### `op setIsDisjoint`
```flux
op setIsDisjoint (as set of data: lhs, as set of data: rhs) as bool
```
- **Parameters**:
  - `lhs` (`set of data`): Input argument for operation execution.
  - `rhs` (`set of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setIsDisjoint` functionality within the `SetRelationContract` domain.

##### `op setIsProperSubset`
```flux
op setIsProperSubset (as set of data: lhs, as set of data: rhs) as bool
```
- **Parameters**:
  - `lhs` (`set of data`): Input argument for operation execution.
  - `rhs` (`set of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setIsProperSubset` functionality within the `SetRelationContract` domain.

##### `op setIsProperSuperset`
```flux
op setIsProperSuperset (as set of data: lhs, as set of data: rhs) as bool
```
- **Parameters**:
  - `lhs` (`set of data`): Input argument for operation execution.
  - `rhs` (`set of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setIsProperSuperset` functionality within the `SetRelationContract` domain.

### 4.7 Contract `SetSearchContract` (`SetSearch.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `setContains` | `op setContains (as set of data: items, as data: item) as bool` | `bool` |
| `setContainsAny` | `op setContainsAny (as set of data: lhs, as set of data: rhs) as bool` | `bool` |
| `setContainsAll` | `op setContainsAll (as set of data: lhs, as set of data: rhs) as bool` | `bool` |
| `setIndexOf` | `op setIndexOf (as set of data: items, as data: item) as int64` | `int64` |
| `setCount` | `op setCount (as set of data: items, as data: item) as int64` | `int64` |

#### Operation Technical Specifications:

##### `op setContains`
```flux
op setContains (as set of data: items, as data: item) as bool
```
- **Parameters**:
  - `items` (`set of data`): Input argument for operation execution.
  - `item` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setContains` functionality within the `SetSearchContract` domain.

##### `op setContainsAny`
```flux
op setContainsAny (as set of data: lhs, as set of data: rhs) as bool
```
- **Parameters**:
  - `lhs` (`set of data`): Input argument for operation execution.
  - `rhs` (`set of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setContainsAny` functionality within the `SetSearchContract` domain.

##### `op setContainsAll`
```flux
op setContainsAll (as set of data: lhs, as set of data: rhs) as bool
```
- **Parameters**:
  - `lhs` (`set of data`): Input argument for operation execution.
  - `rhs` (`set of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setContainsAll` functionality within the `SetSearchContract` domain.

##### `op setIndexOf`
```flux
op setIndexOf (as set of data: items, as data: item) as int64
```
- **Parameters**:
  - `items` (`set of data`): Input argument for operation execution.
  - `item` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setIndexOf` functionality within the `SetSearchContract` domain.

##### `op setCount`
```flux
op setCount (as set of data: items, as data: item) as int64
```
- **Parameters**:
  - `items` (`set of data`): Input argument for operation execution.
  - `item` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setCount` functionality within the `SetSearchContract` domain.

### 4.8 Contract `SetSelectionContract` (`SetSelection.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `setTake` | `op setTake (as set of data: items, as int64: n) as set of data` | `set of data` |
| `setDrop` | `op setDrop (as set of data: items, as int64: n) as set of data` | `set of data` |
| `setTakeLast` | `op setTakeLast (as set of data: items, as int64: n) as set of data` | `set of data` |
| `setDropLast` | `op setDropLast (as set of data: items, as int64: n) as set of data` | `set of data` |
| `setFilter` | `op setFilter (as set of data: items, as list of data: allowed_items) as set of data` | `set of data` |
| `setOmit` | `op setOmit (as set of data: items, as list of data: omitted_items) as set of data` | `set of data` |

#### Operation Technical Specifications:

##### `op setTake`
```flux
op setTake (as set of data: items, as int64: n) as set of data
```
- **Parameters**:
  - `items` (`set of data`): Input argument for operation execution.
  - `n` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `set of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setTake` functionality within the `SetSelectionContract` domain.

##### `op setDrop`
```flux
op setDrop (as set of data: items, as int64: n) as set of data
```
- **Parameters**:
  - `items` (`set of data`): Input argument for operation execution.
  - `n` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `set of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setDrop` functionality within the `SetSelectionContract` domain.

##### `op setTakeLast`
```flux
op setTakeLast (as set of data: items, as int64: n) as set of data
```
- **Parameters**:
  - `items` (`set of data`): Input argument for operation execution.
  - `n` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `set of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setTakeLast` functionality within the `SetSelectionContract` domain.

##### `op setDropLast`
```flux
op setDropLast (as set of data: items, as int64: n) as set of data
```
- **Parameters**:
  - `items` (`set of data`): Input argument for operation execution.
  - `n` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `set of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setDropLast` functionality within the `SetSelectionContract` domain.

##### `op setFilter`
```flux
op setFilter (as set of data: items, as list of data: allowed_items) as set of data
```
- **Parameters**:
  - `items` (`set of data`): Input argument for operation execution.
  - `allowed_items` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `set of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setFilter` functionality within the `SetSelectionContract` domain.

##### `op setOmit`
```flux
op setOmit (as set of data: items, as list of data: omitted_items) as set of data
```
- **Parameters**:
  - `items` (`set of data`): Input argument for operation execution.
  - `omitted_items` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `set of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setOmit` functionality within the `SetSelectionContract` domain.

### 4.9 Contract `SetTransformContract` (`SetTransform.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `setUnionAll` | `op setUnionAll (as list of data: sets) as set of data` | `set of data` |
| `setIntersectAll` | `op setIntersectAll (as list of data: sets) as set of data` | `set of data` |
| `setCartesianProduct` | `op setCartesianProduct (as set of data: lhs, as set of data: rhs) as list of data` | `list of data` |
| `setPowerSet` | `op setPowerSet (as set of data: items) as list of data` | `list of data` |

#### Operation Technical Specifications:

##### `op setUnionAll`
```flux
op setUnionAll (as list of data: sets) as set of data
```
- **Parameters**:
  - `sets` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `set of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setUnionAll` functionality within the `SetTransformContract` domain.

##### `op setIntersectAll`
```flux
op setIntersectAll (as list of data: sets) as set of data
```
- **Parameters**:
  - `sets` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `set of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setIntersectAll` functionality within the `SetTransformContract` domain.

##### `op setCartesianProduct`
```flux
op setCartesianProduct (as set of data: lhs, as set of data: rhs) as list of data
```
- **Parameters**:
  - `lhs` (`set of data`): Input argument for operation execution.
  - `rhs` (`set of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setCartesianProduct` functionality within the `SetTransformContract` domain.

##### `op setPowerSet`
```flux
op setPowerSet (as set of data: items) as list of data
```
- **Parameters**:
  - `items` (`set of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setPowerSet` functionality within the `SetTransformContract` domain.

### 4.10 Contract `SetUtilityContract` (`SetUtility.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `setEquals` | `op setEquals (as set of data: lhs, as set of data: rhs) as bool` | `bool` |
| `setJoin` | `op setJoin (as set of data: items, as string: separator) as string` | `string` |
| `setSwap` | `op setSwap (as set of data: items, as data: old_val, as data: new_val) as set of data` | `set of data` |

#### Operation Technical Specifications:

##### `op setEquals`
```flux
op setEquals (as set of data: lhs, as set of data: rhs) as bool
```
- **Parameters**:
  - `lhs` (`set of data`): Input argument for operation execution.
  - `rhs` (`set of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setEquals` functionality within the `SetUtilityContract` domain.

##### `op setJoin`
```flux
op setJoin (as set of data: items, as string: separator) as string
```
- **Parameters**:
  - `items` (`set of data`): Input argument for operation execution.
  - `separator` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setJoin` functionality within the `SetUtilityContract` domain.

##### `op setSwap`
```flux
op setSwap (as set of data: items, as data: old_val, as data: new_val) as set of data
```
- **Parameters**:
  - `items` (`set of data`): Input argument for operation execution.
  - `old_val` (`data`): Input argument for operation execution.
  - `new_val` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `set of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setSwap` functionality within the `SetUtilityContract` domain.

---

## 5. Canonical Usage Examples in TheFlux

The following snippet illustrates importing and utilizing the library in a TheFlux program:

```flux
# Canonical Usage Example for SetStdLib
use SetStdLib

program (ExampleOfSetStdLib) {
      println("==================================================")
      println("  Standard Library Demonstration: SetStdLib")
      println("==================================================")

      # Invoking canonical operation
      mut as data: result = SetStdLib::setCount([])
      println("Obtained result: " + result)

      println("Execution completed successfully.")
}
```

---

> [!TIP]
> For the complete unified architecture across all standard libraries, consult the master [StdLibs.md](../StdLibs.md) reference.
