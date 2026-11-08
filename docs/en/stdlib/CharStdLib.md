# 📚 `CharStdLib` — Character Manipulation, Classification, and Predicates

> **Architectural Pillar**: Pillar 1 (Core, Text & OO)  
> **Status**: ✅ Certified with 100% Parity across 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Master File**: `stdlib/CharStdLib/CharStdLib.fdsl`  
> **Import Mode**: `use CharStdLib` or `use CharStdLib::<Module>::<operation>`

---

## 1. Overview and Capabilities

The **`CharStdLib`** standard library is an integral component of the official TheFlux language ecosystem, providing certified system-level algorithms and robust capabilities.

Offers zero-allocation predicates and transforms for Unicode and ASCII character categories (digits, uppercase/lowercase letters, whitespace, control characters), hexadecimal parsing, and atomic case conversions.

### 1.1 Key Architectural Principles and Design
- **Static Fusion and Zero-Overhead**: All domain modules are transparently fused into the `CharStdLib` unified agent at compile time, avoiding virtual dispatch penalties.
- **Safety and Isolation**: Operations strictly validate parameter bounds and guarantee predictable error semantics via contract definitions.
- **Universal Multi-Backend Parity**: Bit-for-bit identical execution guarantees across interpreter (`in`), bytecode VM (`vm`, `vmr`), native AOT LLVM (`llvm`), and WebAssembly (`wat`, `wasm`).

---

## 2. Modular Structure and Contracts

The library comprises **6 domain modules** declaring a total of **36 public operations**:

| Domain Source File | Formal Contract | Domain Responsibility | Ops Count |
|---|---|---|:---:|
| `CharAscii.fdsl` | `CharAsciiContract` | Specialized domain for `CharAscii` | 4 |
| `CharClassification.fdsl` | `CharClassificationContract` | Specialized domain for `CharClassification` | 12 |
| `CharCompare.fdsl` | `CharCompareContract` | Specialized domain for `CharCompare` | 5 |
| `CharHex.fdsl` | `CharHexContract` | Specialized domain for `CharHex` | 4 |
| `CharTransform.fdsl` | `CharTransformContract` | Specialized domain for `CharTransform` | 5 |
| `CharUtility.fdsl` | `CharUtilityContract` | Specialized domain for `CharUtility` | 6 |

---

## 3. Public Types, Structures, and Enumerations

The `CharStdLib` library operates directly on primitive native TheFlux types (`string`, `int64`, `float64`, `bool`, `list of data`, etc.) without requiring custom composite types.

---

## 4. Detailed Operations Catalog by Domain

### 4.1 Contract `CharAsciiContract` (`CharAscii.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `charToAscii` | `op charToAscii (as char: c) as int64` | `int64` |
| `charFromAscii` | `op charFromAscii (as int64: code) as char` | `char` |
| `charIsPrintable` | `op charIsPrintable (as char: c) as bool` | `bool` |
| `charIsControl` | `op charIsControl (as char: c) as bool` | `bool` |

#### Operation Technical Specifications:

##### `op charToAscii`
```flux
op charToAscii (as char: c) as int64
```
- **Parameters**:
  - `c` (`char`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `charToAscii` functionality within the `CharAsciiContract` domain.

##### `op charFromAscii`
```flux
op charFromAscii (as int64: code) as char
```
- **Parameters**:
  - `code` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `char`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `charFromAscii` functionality within the `CharAsciiContract` domain.

##### `op charIsPrintable`
```flux
op charIsPrintable (as char: c) as bool
```
- **Parameters**:
  - `c` (`char`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `charIsPrintable` functionality within the `CharAsciiContract` domain.

##### `op charIsControl`
```flux
op charIsControl (as char: c) as bool
```
- **Parameters**:
  - `c` (`char`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `charIsControl` functionality within the `CharAsciiContract` domain.

### 4.2 Contract `CharClassificationContract` (`CharClassification.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `charIsDigit` | `op charIsDigit (as char: c) as bool` | `bool` |
| `charIsAlpha` | `op charIsAlpha (as char: c) as bool` | `bool` |
| `charIsAlphanumeric` | `op charIsAlphanumeric (as char: c) as bool` | `bool` |
| `charIsLower` | `op charIsLower (as char: c) as bool` | `bool` |
| `charIsUpper` | `op charIsUpper (as char: c) as bool` | `bool` |
| `charIsWhitespace` | `op charIsWhitespace (as char: c) as bool` | `bool` |
| `charIsSpace` | `op charIsSpace (as char: c) as bool` | `bool` |
| `charIsPunctuation` | `op charIsPunctuation (as char: c) as bool` | `bool` |
| `charIsHexDigit` | `op charIsHexDigit (as char: c) as bool` | `bool` |
| `charIsOctalDigit` | `op charIsOctalDigit (as char: c) as bool` | `bool` |
| `charIsBinaryDigit` | `op charIsBinaryDigit (as char: c) as bool` | `bool` |
| `charIsAscii` | `op charIsAscii (as char: c) as bool` | `bool` |

#### Operation Technical Specifications:

##### `op charIsDigit`
```flux
op charIsDigit (as char: c) as bool
```
- **Parameters**:
  - `c` (`char`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `charIsDigit` functionality within the `CharClassificationContract` domain.

##### `op charIsAlpha`
```flux
op charIsAlpha (as char: c) as bool
```
- **Parameters**:
  - `c` (`char`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `charIsAlpha` functionality within the `CharClassificationContract` domain.

##### `op charIsAlphanumeric`
```flux
op charIsAlphanumeric (as char: c) as bool
```
- **Parameters**:
  - `c` (`char`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `charIsAlphanumeric` functionality within the `CharClassificationContract` domain.

##### `op charIsLower`
```flux
op charIsLower (as char: c) as bool
```
- **Parameters**:
  - `c` (`char`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `charIsLower` functionality within the `CharClassificationContract` domain.

##### `op charIsUpper`
```flux
op charIsUpper (as char: c) as bool
```
- **Parameters**:
  - `c` (`char`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `charIsUpper` functionality within the `CharClassificationContract` domain.

##### `op charIsWhitespace`
```flux
op charIsWhitespace (as char: c) as bool
```
- **Parameters**:
  - `c` (`char`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `charIsWhitespace` functionality within the `CharClassificationContract` domain.

##### `op charIsSpace`
```flux
op charIsSpace (as char: c) as bool
```
- **Parameters**:
  - `c` (`char`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `charIsSpace` functionality within the `CharClassificationContract` domain.

##### `op charIsPunctuation`
```flux
op charIsPunctuation (as char: c) as bool
```
- **Parameters**:
  - `c` (`char`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `charIsPunctuation` functionality within the `CharClassificationContract` domain.

##### `op charIsHexDigit`
```flux
op charIsHexDigit (as char: c) as bool
```
- **Parameters**:
  - `c` (`char`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `charIsHexDigit` functionality within the `CharClassificationContract` domain.

##### `op charIsOctalDigit`
```flux
op charIsOctalDigit (as char: c) as bool
```
- **Parameters**:
  - `c` (`char`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `charIsOctalDigit` functionality within the `CharClassificationContract` domain.

##### `op charIsBinaryDigit`
```flux
op charIsBinaryDigit (as char: c) as bool
```
- **Parameters**:
  - `c` (`char`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `charIsBinaryDigit` functionality within the `CharClassificationContract` domain.

##### `op charIsAscii`
```flux
op charIsAscii (as char: c) as bool
```
- **Parameters**:
  - `c` (`char`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `charIsAscii` functionality within the `CharClassificationContract` domain.

### 4.3 Contract `CharCompareContract` (`CharCompare.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `charEquals` | `op charEquals (as char: a, as char: b) as bool` | `bool` |
| `charEqualsIgnoreCase` | `op charEqualsIgnoreCase (as char: a, as char: b) as bool` | `bool` |
| `charCompare` | `op charCompare (as char: a, as char: b) as int64` | `int64` |
| `charCompareIgnoreCase` | `op charCompareIgnoreCase (as char: a, as char: b) as int64` | `int64` |
| `charIsBetween` | `op charIsBetween (as char: c, as char: start, as char: end) as bool` | `bool` |

#### Operation Technical Specifications:

##### `op charEquals`
```flux
op charEquals (as char: a, as char: b) as bool
```
- **Parameters**:
  - `a` (`char`): Input argument for operation execution.
  - `b` (`char`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `charEquals` functionality within the `CharCompareContract` domain.

##### `op charEqualsIgnoreCase`
```flux
op charEqualsIgnoreCase (as char: a, as char: b) as bool
```
- **Parameters**:
  - `a` (`char`): Input argument for operation execution.
  - `b` (`char`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `charEqualsIgnoreCase` functionality within the `CharCompareContract` domain.

##### `op charCompare`
```flux
op charCompare (as char: a, as char: b) as int64
```
- **Parameters**:
  - `a` (`char`): Input argument for operation execution.
  - `b` (`char`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `charCompare` functionality within the `CharCompareContract` domain.

##### `op charCompareIgnoreCase`
```flux
op charCompareIgnoreCase (as char: a, as char: b) as int64
```
- **Parameters**:
  - `a` (`char`): Input argument for operation execution.
  - `b` (`char`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `charCompareIgnoreCase` functionality within the `CharCompareContract` domain.

##### `op charIsBetween`
```flux
op charIsBetween (as char: c, as char: start, as char: end) as bool
```
- **Parameters**:
  - `c` (`char`): Input argument for operation execution.
  - `start` (`char`): Input argument for operation execution.
  - `end` (`char`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `charIsBetween` functionality within the `CharCompareContract` domain.

### 4.4 Contract `CharHexContract` (`CharHex.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `charToHexValue` | `op charToHexValue (as char: c) as int64` | `int64` |
| `charFromHexValue` | `op charFromHexValue (as int64: value) as char` | `char` |
| `charToBinaryValue` | `op charToBinaryValue (as char: c) as int64` | `int64` |
| `charFromBinaryValue` | `op charFromBinaryValue (as int64: value) as char` | `char` |

#### Operation Technical Specifications:

##### `op charToHexValue`
```flux
op charToHexValue (as char: c) as int64
```
- **Parameters**:
  - `c` (`char`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `charToHexValue` functionality within the `CharHexContract` domain.

##### `op charFromHexValue`
```flux
op charFromHexValue (as int64: value) as char
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `char`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `charFromHexValue` functionality within the `CharHexContract` domain.

##### `op charToBinaryValue`
```flux
op charToBinaryValue (as char: c) as int64
```
- **Parameters**:
  - `c` (`char`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `charToBinaryValue` functionality within the `CharHexContract` domain.

##### `op charFromBinaryValue`
```flux
op charFromBinaryValue (as int64: value) as char
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `char`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `charFromBinaryValue` functionality within the `CharHexContract` domain.

### 4.5 Contract `CharTransformContract` (`CharTransform.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `charToUpper` | `op charToUpper (as char: c) as char` | `char` |
| `charToLower` | `op charToLower (as char: c) as char` | `char` |
| `charToggleCase` | `op charToggleCase (as char: c) as char` | `char` |
| `charToDigit` | `op charToDigit (as char: c) as int64` | `int64` |
| `charFromDigit` | `op charFromDigit (as int64: digit) as char` | `char` |

#### Operation Technical Specifications:

##### `op charToUpper`
```flux
op charToUpper (as char: c) as char
```
- **Parameters**:
  - `c` (`char`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `char`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `charToUpper` functionality within the `CharTransformContract` domain.

##### `op charToLower`
```flux
op charToLower (as char: c) as char
```
- **Parameters**:
  - `c` (`char`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `char`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `charToLower` functionality within the `CharTransformContract` domain.

##### `op charToggleCase`
```flux
op charToggleCase (as char: c) as char
```
- **Parameters**:
  - `c` (`char`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `char`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `charToggleCase` functionality within the `CharTransformContract` domain.

##### `op charToDigit`
```flux
op charToDigit (as char: c) as int64
```
- **Parameters**:
  - `c` (`char`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `charToDigit` functionality within the `CharTransformContract` domain.

##### `op charFromDigit`
```flux
op charFromDigit (as int64: digit) as char
```
- **Parameters**:
  - `digit` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `char`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `charFromDigit` functionality within the `CharTransformContract` domain.

### 4.6 Contract `CharUtilityContract` (`CharUtility.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `charToString` | `op charToString (as char: c) as string` | `string` |
| `charRepeat` | `op charRepeat (as char: c, as int64: count) as string` | `string` |
| `charIsVowel` | `op charIsVowel (as char: c) as bool` | `bool` |
| `charIsConsonant` | `op charIsConsonant (as char: c) as bool` | `bool` |
| `charEscape` | `op charEscape (as char: c) as string` | `string` |
| `charName` | `op charName (as char: c) as string` | `string` |

#### Operation Technical Specifications:

##### `op charToString`
```flux
op charToString (as char: c) as string
```
- **Parameters**:
  - `c` (`char`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `charToString` functionality within the `CharUtilityContract` domain.

##### `op charRepeat`
```flux
op charRepeat (as char: c, as int64: count) as string
```
- **Parameters**:
  - `c` (`char`): Input argument for operation execution.
  - `count` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `charRepeat` functionality within the `CharUtilityContract` domain.

##### `op charIsVowel`
```flux
op charIsVowel (as char: c) as bool
```
- **Parameters**:
  - `c` (`char`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `charIsVowel` functionality within the `CharUtilityContract` domain.

##### `op charIsConsonant`
```flux
op charIsConsonant (as char: c) as bool
```
- **Parameters**:
  - `c` (`char`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `charIsConsonant` functionality within the `CharUtilityContract` domain.

##### `op charEscape`
```flux
op charEscape (as char: c) as string
```
- **Parameters**:
  - `c` (`char`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `charEscape` functionality within the `CharUtilityContract` domain.

##### `op charName`
```flux
op charName (as char: c) as string
```
- **Parameters**:
  - `c` (`char`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `charName` functionality within the `CharUtilityContract` domain.

---

## 5. Canonical Usage Examples in TheFlux

The following snippet illustrates importing and utilizing the library in a TheFlux program:

```flux
# Canonical Usage Example for CharStdLib
use CharStdLib

program (ExampleOfCharStdLib) {
      println("==================================================")
      println("  Standard Library Demonstration: CharStdLib")
      println("==================================================")

      # Invoking canonical operation
      mut as data: result = CharStdLib::charIsDigit('7')
      println("Obtained result: " + result)

      println("Execution completed successfully.")
}
```

---

> [!TIP]
> For the complete unified architecture across all standard libraries, consult the master [StdLibs.md](../StdLibs.md) reference.
