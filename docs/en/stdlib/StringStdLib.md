# 📚 `StringStdLib` — High-Performance Text Processing, String Slicing, and Search

> **Architectural Pillar**: Pillar 1 (Core, Text & OO)  
> **Status**: ✅ Certified with 100% Parity across 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Master File**: `stdlib/StringStdLib/StringStdLib.fdsl`  
> **Import Mode**: `use StringStdLib` or `use StringStdLib::<Module>::<operation>`

---

## 1. Overview and Capabilities

The **`StringStdLib`** standard library is an integral component of the official TheFlux language ecosystem, providing certified system-level algorithms and robust capabilities.

Essential string and buffer manipulation facilities: string splitting, joining with separators, sub-string searching (Boyer-Moore/KMP), padding, whitespace trimming, string reversal, and bounds-checked slicing.

### 1.1 Key Architectural Principles and Design
- **Static Fusion and Zero-Overhead**: All domain modules are transparently fused into the `StringStdLib` unified agent at compile time, avoiding virtual dispatch penalties.
- **Safety and Isolation**: Operations strictly validate parameter bounds and guarantee predictable error semantics via contract definitions.
- **Universal Multi-Backend Parity**: Bit-for-bit identical execution guarantees across interpreter (`in`), bytecode VM (`vm`, `vmr`), native AOT LLVM (`llvm`), and WebAssembly (`wat`, `wasm`).

---

## 2. Modular Structure and Contracts

The library comprises **8 domain modules** declaring a total of **79 public operations**:

| Domain Source File | Formal Contract | Domain Responsibility | Ops Count |
|---|---|---|:---:|
| `StringAccess.fdsl` | `StringAccessContract` | Specialized domain for `StringAccess` | 7 |
| `StringBasic.fdsl` | `StringBasicContract` | Specialized domain for `StringBasic` | 18 |
| `StringMutation.fdsl` | `StringMutationContract` | Specialized domain for `StringMutation` | 13 |
| `StringSearch.fdsl` | `StringSearchContract` | Specialized domain for `StringSearch` | 8 |
| `StringSelection.fdsl` | `StringSelectionContract` | Specialized domain for `StringSelection` | 9 |
| `StringTransform.fdsl` | `StringTransformContract` | Specialized domain for `StringTransform` | 12 |
| `StringUtility.fdsl` | `StringUtilityContract` | Specialized domain for `StringUtility` | 4 |
| `StringValidation.fdsl` | `StringValidationContract` | Specialized domain for `StringValidation` | 8 |

---

## 3. Public Types, Structures, and Enumerations

The `StringStdLib` library operates directly on primitive native TheFlux types (`string`, `int64`, `float64`, `bool`, `list of data`, etc.) without requiring custom composite types.

---

## 4. Detailed Operations Catalog by Domain

### 4.1 Contract `StringAccessContract` (`StringAccess.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `stringGetFirst` | `op stringGetFirst (as string: text) as string` | `string` |
| `stringGetAt` | `op stringGetAt (as string: text, as int64: index) as string` | `string` |
| `stringGetLast` | `op stringGetLast (as string: text) as string` | `string` |
| `stringGetLeft` | `op stringGetLeft (as string: text, as int64: n) as string` | `string` |
| `stringGetRight` | `op stringGetRight (as string: text, as int64: n) as string` | `string` |
| `stringGetCenter` | `op stringGetCenter (as string: text, as int64: n) as string` | `string` |
| `stringSlice` | `op stringSlice (as string: text, as int64: start, as int64: end) as string` | `string` |

#### Operation Technical Specifications:

##### `op stringGetFirst`
```flux
op stringGetFirst (as string: text) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringGetFirst` functionality within the `StringAccessContract` domain.

##### `op stringGetAt`
```flux
op stringGetAt (as string: text, as int64: index) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
  - `index` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringGetAt` functionality within the `StringAccessContract` domain.

##### `op stringGetLast`
```flux
op stringGetLast (as string: text) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringGetLast` functionality within the `StringAccessContract` domain.

##### `op stringGetLeft`
```flux
op stringGetLeft (as string: text, as int64: n) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
  - `n` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringGetLeft` functionality within the `StringAccessContract` domain.

##### `op stringGetRight`
```flux
op stringGetRight (as string: text, as int64: n) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
  - `n` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringGetRight` functionality within the `StringAccessContract` domain.

##### `op stringGetCenter`
```flux
op stringGetCenter (as string: text, as int64: n) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
  - `n` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringGetCenter` functionality within the `StringAccessContract` domain.

##### `op stringSlice`
```flux
op stringSlice (as string: text, as int64: start, as int64: end) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
  - `start` (`int64`): Input argument for operation execution.
  - `end` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringSlice` functionality within the `StringAccessContract` domain.

### 4.2 Contract `StringBasicContract` (`StringBasic.fdsl`)

| Operation | Formal Signature | Return Type |
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

#### Operation Technical Specifications:

##### `op stringLength`
```flux
op stringLength (as string: text) as int64
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringLength` functionality within the `StringBasicContract` domain.

##### `op stringIsEmpty`
```flux
op stringIsEmpty (as string: text) as bool
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringIsEmpty` functionality within the `StringBasicContract` domain.

##### `op stringIsNotEmpty`
```flux
op stringIsNotEmpty (as string: text) as bool
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringIsNotEmpty` functionality within the `StringBasicContract` domain.

##### `op stringContains`
```flux
op stringContains (as string: text, as string: needle) as bool
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
  - `needle` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringContains` functionality within the `StringBasicContract` domain.

##### `op stringContainsAny`
```flux
op stringContainsAny (as string: text, as list of data: needles) as bool
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
  - `needles` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringContainsAny` functionality within the `StringBasicContract` domain.

##### `op stringContainsAll`
```flux
op stringContainsAll (as string: text, as list of data: needles) as bool
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
  - `needles` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringContainsAll` functionality within the `StringBasicContract` domain.

##### `op stringClearAll`
```flux
op stringClearAll (as string: text) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringClearAll` functionality within the `StringBasicContract` domain.

##### `op stringSingleton`
```flux
op stringSingleton (as string: char) as string
```
- **Parameters**:
  - `char` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringSingleton` functionality within the `StringBasicContract` domain.

##### `op stringSingletonInt`
```flux
op stringSingletonInt (as int64: value) as string
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringSingletonInt` functionality within the `StringBasicContract` domain.

##### `op stringSingletonString`
```flux
op stringSingletonString (as string: value) as string
```
- **Parameters**:
  - `value` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringSingletonString` functionality within the `StringBasicContract` domain.

##### `op stringClone`
```flux
op stringClone (as string: text) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringClone` functionality within the `StringBasicContract` domain.

##### `op stringToList`
```flux
op stringToList (as string: text) as list of data
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringToList` functionality within the `StringBasicContract` domain.

##### `op stringToSet`
```flux
op stringToSet (as string: text) as set of data
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `set of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringToSet` functionality within the `StringBasicContract` domain.

##### `op stringToMap`
```flux
op stringToMap (as string: text) as map
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringToMap` functionality within the `StringBasicContract` domain.

##### `op stringToString`
```flux
op stringToString (as string: text) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringToString` functionality within the `StringBasicContract` domain.

##### `op stringFromList`
```flux
op stringFromList (as list of data: chars) as string
```
- **Parameters**:
  - `chars` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringFromList` functionality within the `StringBasicContract` domain.

##### `op stringFromSet`
```flux
op stringFromSet (as set of data: chars) as string
```
- **Parameters**:
  - `chars` (`set of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringFromSet` functionality within the `StringBasicContract` domain.

##### `op stringFromString`
```flux
op stringFromString (as string: text) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringFromString` functionality within the `StringBasicContract` domain.

### 4.3 Contract `StringMutationContract` (`StringMutation.fdsl`)

| Operation | Formal Signature | Return Type |
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

#### Operation Technical Specifications:

##### `op stringPushFront`
```flux
op stringPushFront (as string: text, as string: char) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
  - `char` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringPushFront` functionality within the `StringMutationContract` domain.

##### `op stringPushBack`
```flux
op stringPushBack (as string: text, as string: char) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
  - `char` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringPushBack` functionality within the `StringMutationContract` domain.

##### `op stringPrepend`
```flux
op stringPrepend (as string: text, as string: prefix) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
  - `prefix` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringPrepend` functionality within the `StringMutationContract` domain.

##### `op stringAppend`
```flux
op stringAppend (as string: text, as string: suffix) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
  - `suffix` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringAppend` functionality within the `StringMutationContract` domain.

##### `op stringInsertFirst`
```flux
op stringInsertFirst (as string: text, as string: insert_text) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
  - `insert_text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringInsertFirst` functionality within the `StringMutationContract` domain.

##### `op stringInsertAt`
```flux
op stringInsertAt (as string: text, as int64: index, as string: insert_text) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
  - `index` (`int64`): Input argument for operation execution.
  - `insert_text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringInsertAt` functionality within the `StringMutationContract` domain.

##### `op stringInsertLast`
```flux
op stringInsertLast (as string: text, as string: insert_text) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
  - `insert_text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringInsertLast` functionality within the `StringMutationContract` domain.

##### `op stringInsert`
```flux
op stringInsert (as string: text, as int64: index, as string: insert_text) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
  - `index` (`int64`): Input argument for operation execution.
  - `insert_text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringInsert` functionality within the `StringMutationContract` domain.

##### `op stringRemoveFirst`
```flux
op stringRemoveFirst (as string: text) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringRemoveFirst` functionality within the `StringMutationContract` domain.

##### `op stringRemoveAt`
```flux
op stringRemoveAt (as string: text, as int64: index) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
  - `index` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringRemoveAt` functionality within the `StringMutationContract` domain.

##### `op stringRemoveLast`
```flux
op stringRemoveLast (as string: text) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringRemoveLast` functionality within the `StringMutationContract` domain.

##### `op stringRemove`
```flux
op stringRemove (as string: text, as string: target) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
  - `target` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `""`
- **Functional Description**:
  - Executes canonical `stringRemove` functionality within the `StringMutationContract` domain.

##### `op stringRemoveAll`
```flux
op stringRemoveAll (as string: text, as string: target) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
  - `target` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `""`
- **Functional Description**:
  - Executes canonical `stringRemoveAll` functionality within the `StringMutationContract` domain.

### 4.4 Contract `StringSearchContract` (`StringSearch.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `stringContains` | `op stringContains (as string: text, as string: needle) as bool` | `bool` |
| `stringContainsAny` | `op stringContainsAny (as string: text, as list of data: needles) as bool` | `bool` |
| `stringContainsAll` | `op stringContainsAll (as string: text, as list of data: needles) as bool` | `bool` |
| `stringStartsWith` | `op stringStartsWith (as string: text, as string: prefix) as bool` | `bool` |
| `stringEndsWith` | `op stringEndsWith (as string: text, as string: suffix) as bool` | `bool` |
| `stringIndexOf` | `op stringIndexOf (as string: text, as string: needle) as int64` | `int64` |
| `stringLastIndexOf` | `op stringLastIndexOf (as string: text, as string: needle) as int64` | `int64` |
| `stringCount` | `op stringCount (as string: text, as string: needle) as int64` | `int64` |

#### Operation Technical Specifications:

##### `op stringContains`
```flux
op stringContains (as string: text, as string: needle) as bool
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
  - `needle` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringContains` functionality within the `StringSearchContract` domain.

##### `op stringContainsAny`
```flux
op stringContainsAny (as string: text, as list of data: needles) as bool
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
  - `needles` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringContainsAny` functionality within the `StringSearchContract` domain.

##### `op stringContainsAll`
```flux
op stringContainsAll (as string: text, as list of data: needles) as bool
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
  - `needles` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringContainsAll` functionality within the `StringSearchContract` domain.

##### `op stringStartsWith`
```flux
op stringStartsWith (as string: text, as string: prefix) as bool
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
  - `prefix` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringStartsWith` functionality within the `StringSearchContract` domain.

##### `op stringEndsWith`
```flux
op stringEndsWith (as string: text, as string: suffix) as bool
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
  - `suffix` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringEndsWith` functionality within the `StringSearchContract` domain.

##### `op stringIndexOf`
```flux
op stringIndexOf (as string: text, as string: needle) as int64
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
  - `needle` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringIndexOf` functionality within the `StringSearchContract` domain.

##### `op stringLastIndexOf`
```flux
op stringLastIndexOf (as string: text, as string: needle) as int64
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
  - `needle` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringLastIndexOf` functionality within the `StringSearchContract` domain.

##### `op stringCount`
```flux
op stringCount (as string: text, as string: needle) as int64
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
  - `needle` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringCount` functionality within the `StringSearchContract` domain.

### 4.5 Contract `StringSelectionContract` (`StringSelection.fdsl`)

| Operation | Formal Signature | Return Type |
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

#### Operation Technical Specifications:

##### `op stringTake`
```flux
op stringTake (as string: text, as int64: n) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
  - `n` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringTake` functionality within the `StringSelectionContract` domain.

##### `op stringDrop`
```flux
op stringDrop (as string: text, as int64: n) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
  - `n` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringDrop` functionality within the `StringSelectionContract` domain.

##### `op stringTakeLast`
```flux
op stringTakeLast (as string: text, as int64: n) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
  - `n` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringTakeLast` functionality within the `StringSelectionContract` domain.

##### `op stringDropLast`
```flux
op stringDropLast (as string: text, as int64: n) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
  - `n` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringDropLast` functionality within the `StringSelectionContract` domain.

##### `op stringPadStart`
```flux
op stringPadStart (as string: text, as int64: target_len, as string: pad) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
  - `target_len` (`int64`): Input argument for operation execution.
  - `pad` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringPadStart` functionality within the `StringSelectionContract` domain.

##### `op stringPadEnd`
```flux
op stringPadEnd (as string: text, as int64: target_len, as string: pad) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
  - `target_len` (`int64`): Input argument for operation execution.
  - `pad` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringPadEnd` functionality within the `StringSelectionContract` domain.

##### `op stringPadCenter`
```flux
op stringPadCenter (as string: text, as int64: target_len, as string: pad) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
  - `target_len` (`int64`): Input argument for operation execution.
  - `pad` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringPadCenter` functionality within the `StringSelectionContract` domain.

##### `op stringFilter`
```flux
op stringFilter (as string: text, as list of data: allowed_chars) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
  - `allowed_chars` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringFilter` functionality within the `StringSelectionContract` domain.

##### `op stringOmit`
```flux
op stringOmit (as string: text, as list of data: omitted_chars) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
  - `omitted_chars` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringOmit` functionality within the `StringSelectionContract` domain.

### 4.6 Contract `StringTransformContract` (`StringTransform.fdsl`)

| Operation | Formal Signature | Return Type |
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

#### Operation Technical Specifications:

##### `op stringUpper`
```flux
op stringUpper (as string: text) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringUpper` functionality within the `StringTransformContract` domain.

##### `op stringLower`
```flux
op stringLower (as string: text) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringLower` functionality within the `StringTransformContract` domain.

##### `op stringCapitalize`
```flux
op stringCapitalize (as string: text) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringCapitalize` functionality within the `StringTransformContract` domain.

##### `op stringTrim`
```flux
op stringTrim (as string: text) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringTrim` functionality within the `StringTransformContract` domain.

##### `op stringTrimStart`
```flux
op stringTrimStart (as string: text) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringTrimStart` functionality within the `StringTransformContract` domain.

##### `op stringTrimEnd`
```flux
op stringTrimEnd (as string: text) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringTrimEnd` functionality within the `StringTransformContract` domain.

##### `op stringReplace`
```flux
op stringReplace (as string: text, as string: target, as string: replacement) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
  - `target` (`string`): Input argument for operation execution.
  - `replacement` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringReplace` functionality within the `StringTransformContract` domain.

##### `op stringReplaceFirst`
```flux
op stringReplaceFirst (as string: text, as string: target, as string: replacement) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
  - `target` (`string`): Input argument for operation execution.
  - `replacement` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringReplaceFirst` functionality within the `StringTransformContract` domain.

##### `op stringReverse`
```flux
op stringReverse (as string: text) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringReverse` functionality within the `StringTransformContract` domain.

##### `op stringRepeat`
```flux
op stringRepeat (as string: text, as int64: count) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
  - `count` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringRepeat` functionality within the `StringTransformContract` domain.

##### `op stringConcat`
```flux
op stringConcat (as string: left, as string: right) as string
```
- **Parameters**:
  - `left` (`string`): Input argument for operation execution.
  - `right` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringConcat` functionality within the `StringTransformContract` domain.

##### `op stringSurround`
```flux
op stringSurround (as string: text, as string: prefix, as string: suffix) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
  - `prefix` (`string`): Input argument for operation execution.
  - `suffix` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringSurround` functionality within the `StringTransformContract` domain.

### 4.7 Contract `StringUtilityContract` (`StringUtility.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `stringCompare` | `op stringCompare (as string: left, as string: right) as int64` | `int64` |
| `stringEqualsIgnoreCase` | `op stringEqualsIgnoreCase (as string: left, as string: right) as bool` | `bool` |
| `stringSplit` | `op stringSplit (as string: text, as string: separator) as list of data` | `list of data` |
| `stringJoin` | `op stringJoin (as list of data: items, as string: separator) as string` | `string` |

#### Operation Technical Specifications:

##### `op stringCompare`
```flux
op stringCompare (as string: left, as string: right) as int64
```
- **Parameters**:
  - `left` (`string`): Input argument for operation execution.
  - `right` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringCompare` functionality within the `StringUtilityContract` domain.

##### `op stringEqualsIgnoreCase`
```flux
op stringEqualsIgnoreCase (as string: left, as string: right) as bool
```
- **Parameters**:
  - `left` (`string`): Input argument for operation execution.
  - `right` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringEqualsIgnoreCase` functionality within the `StringUtilityContract` domain.

##### `op stringSplit`
```flux
op stringSplit (as string: text, as string: separator) as list of data
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
  - `separator` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringSplit` functionality within the `StringUtilityContract` domain.

##### `op stringJoin`
```flux
op stringJoin (as list of data: items, as string: separator) as string
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
  - `separator` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringJoin` functionality within the `StringUtilityContract` domain.

### 4.8 Contract `StringValidationContract` (`StringValidation.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `stringIsAlpha` | `op stringIsAlpha (as string: text) as bool` | `bool` |
| `stringIsDigit` | `op stringIsDigit (as string: text) as bool` | `bool` |
| `stringIsAlphanumeric` | `op stringIsAlphanumeric (as string: text) as bool` | `bool` |
| `stringIsWhitespace` | `op stringIsWhitespace (as string: text) as bool` | `bool` |
| `stringIsBlank` | `op stringIsBlank (as string: text) as bool` | `bool` |
| `stringIsLower` | `op stringIsLower (as string: text) as bool` | `bool` |
| `stringIsUpper` | `op stringIsUpper (as string: text) as bool` | `bool` |
| `stringIsAscii` | `op stringIsAscii (as string: text) as bool` | `bool` |

#### Operation Technical Specifications:

##### `op stringIsAlpha`
```flux
op stringIsAlpha (as string: text) as bool
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringIsAlpha` functionality within the `StringValidationContract` domain.

##### `op stringIsDigit`
```flux
op stringIsDigit (as string: text) as bool
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringIsDigit` functionality within the `StringValidationContract` domain.

##### `op stringIsAlphanumeric`
```flux
op stringIsAlphanumeric (as string: text) as bool
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringIsAlphanumeric` functionality within the `StringValidationContract` domain.

##### `op stringIsWhitespace`
```flux
op stringIsWhitespace (as string: text) as bool
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringIsWhitespace` functionality within the `StringValidationContract` domain.

##### `op stringIsBlank`
```flux
op stringIsBlank (as string: text) as bool
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringIsBlank` functionality within the `StringValidationContract` domain.

##### `op stringIsLower`
```flux
op stringIsLower (as string: text) as bool
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringIsLower` functionality within the `StringValidationContract` domain.

##### `op stringIsUpper`
```flux
op stringIsUpper (as string: text) as bool
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringIsUpper` functionality within the `StringValidationContract` domain.

##### `op stringIsAscii`
```flux
op stringIsAscii (as string: text) as bool
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringIsAscii` functionality within the `StringValidationContract` domain.

---

## 5. Canonical Usage Examples in TheFlux

The following snippet illustrates importing and utilizing the library in a TheFlux program:

```flux
# Canonical Usage Example for StringStdLib
use StringStdLib

program (ExampleOfStringStdLib) {
      println("==================================================")
      println("  Standard Library Demonstration: StringStdLib")
      println("==================================================")

      # Invoking canonical operation
      mut as data: result = StringStdLib::stringLength("Hello World")
      println("Obtained result: " + result)

      println("Execution completed successfully.")
}
```

---

> [!TIP]
> For the complete unified architecture across all standard libraries, consult the master [StdLibs.md](../StdLibs.md) reference.
