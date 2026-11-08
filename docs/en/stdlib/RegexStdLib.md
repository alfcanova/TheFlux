# 📚 `RegexStdLib` — Regular Expressions Processing, Group Capture, and Replacement

> **Architectural Pillar**: Pillar 1 (Core, Text & OO)  
> **Status**: ✅ Certified with 100% Parity across 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Master File**: `stdlib/RegexStdLib/RegexStdLib.fdsl`  
> **Import Mode**: `use RegexStdLib` or `use RegexStdLib::<Module>::<operation>`

---

## 1. Overview and Capabilities

The **`RegexStdLib`** standard library is an integral component of the official TheFlux language ecosystem, providing certified system-level algorithms and robust capabilities.

PCRE-compliant regular expression engine: pattern compilation, text matching, regex searches, extraction of positional and named capture groups, and dynamic regex replacement with interpolation.

### 1.1 Key Architectural Principles and Design
- **Static Fusion and Zero-Overhead**: All domain modules are transparently fused into the `RegexStdLib` unified agent at compile time, avoiding virtual dispatch penalties.
- **Safety and Isolation**: Operations strictly validate parameter bounds and guarantee predictable error semantics via contract definitions.
- **Universal Multi-Backend Parity**: Bit-for-bit identical execution guarantees across interpreter (`in`), bytecode VM (`vm`, `vmr`), native AOT LLVM (`llvm`), and WebAssembly (`wat`, `wasm`).

---

## 2. Modular Structure and Contracts

The library comprises **5 domain modules** declaring a total of **27 public operations**:

| Domain Source File | Formal Contract | Domain Responsibility | Ops Count |
|---|---|---|:---:|
| `RegexCapture.fdsl` | `RegexCaptureContract` | Specialized domain for `RegexCapture` | 4 |
| `RegexPreset.fdsl` | `RegexPresetContract` | Specialized domain for `RegexPreset` | 6 |
| `RegexSearch.fdsl` | `RegexSearchContract` | Specialized domain for `RegexSearch` | 8 |
| `RegexTransform.fdsl` | `RegexTransformContract` | Specialized domain for `RegexTransform` | 5 |
| `RegexUtility.fdsl` | `RegexUtilityContract` | Specialized domain for `RegexUtility` | 4 |

---

## 3. Public Types, Structures, and Enumerations

The `RegexStdLib` library operates directly on primitive native TheFlux types (`string`, `int64`, `float64`, `bool`, `list of data`, etc.) without requiring custom composite types.

---

## 4. Detailed Operations Catalog by Domain

### 4.1 Contract `RegexCaptureContract` (`RegexCapture.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `regexCaptureGroups` | `op regexCaptureGroups (as string: pattern, as string: text) as map` | `map` |
| `regexCaptureAll` | `op regexCaptureAll (as string: pattern, as string: text) as list of data` | `list of data` |
| `regexExtractGroups` | `op regexExtractGroups (as string: pattern, as string: text) as list of data` | `list of data` |
| `regexExtractAllGroups` | `op regexExtractAllGroups (as string: pattern, as string: text) as list of data` | `list of data` |

#### Operation Technical Specifications:

##### `op regexCaptureGroups`
```flux
op regexCaptureGroups (as string: pattern, as string: text) as map
```
- **Parameters**:
  - `pattern` (`string`): Input argument for operation execution.
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `regexCaptureGroups` functionality within the `RegexCaptureContract` domain.

##### `op regexCaptureAll`
```flux
op regexCaptureAll (as string: pattern, as string: text) as list of data
```
- **Parameters**:
  - `pattern` (`string`): Input argument for operation execution.
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `regexCaptureAll` functionality within the `RegexCaptureContract` domain.

##### `op regexExtractGroups`
```flux
op regexExtractGroups (as string: pattern, as string: text) as list of data
```
- **Parameters**:
  - `pattern` (`string`): Input argument for operation execution.
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `regexExtractGroups` functionality within the `RegexCaptureContract` domain.

##### `op regexExtractAllGroups`
```flux
op regexExtractAllGroups (as string: pattern, as string: text) as list of data
```
- **Parameters**:
  - `pattern` (`string`): Input argument for operation execution.
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `regexExtractAllGroups` functionality within the `RegexCaptureContract` domain.

### 4.2 Contract `RegexPresetContract` (`RegexPreset.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `regexIsEmail` | `op regexIsEmail (as string: text) as bool` | `bool` |
| `regexIsUrl` | `op regexIsUrl (as string: text) as bool` | `bool` |
| `regexIsUuid` | `op regexIsUuid (as string: text) as bool` | `bool` |
| `regexIsIpv4` | `op regexIsIpv4 (as string: text) as bool` | `bool` |
| `regexIsNumeric` | `op regexIsNumeric (as string: text) as bool` | `bool` |
| `regexIsDate` | `op regexIsDate (as string: text) as bool` | `bool` |

#### Operation Technical Specifications:

##### `op regexIsEmail`
```flux
op regexIsEmail (as string: text) as bool
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `regexIsEmail` functionality within the `RegexPresetContract` domain.

##### `op regexIsUrl`
```flux
op regexIsUrl (as string: text) as bool
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `regexIsUrl` functionality within the `RegexPresetContract` domain.

##### `op regexIsUuid`
```flux
op regexIsUuid (as string: text) as bool
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `regexIsUuid` functionality within the `RegexPresetContract` domain.

##### `op regexIsIpv4`
```flux
op regexIsIpv4 (as string: text) as bool
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `regexIsIpv4` functionality within the `RegexPresetContract` domain.

##### `op regexIsNumeric`
```flux
op regexIsNumeric (as string: text) as bool
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `regexIsNumeric` functionality within the `RegexPresetContract` domain.

##### `op regexIsDate`
```flux
op regexIsDate (as string: text) as bool
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `regexIsDate` functionality within the `RegexPresetContract` domain.

### 4.3 Contract `RegexSearchContract` (`RegexSearch.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `regexIsMatch` | `op regexIsMatch (as string: pattern, as string: text) as bool` | `bool` |
| `regexFullMatch` | `op regexFullMatch (as string: pattern, as string: text) as bool` | `bool` |
| `regexFind` | `op regexFind (as string: pattern, as string: text) as string` | `string` |
| `regexFindAll` | `op regexFindAll (as string: pattern, as string: text) as list of data` | `list of data` |
| `regexFindIndex` | `op regexFindIndex (as string: pattern, as string: text) as int64` | `int64` |
| `regexFindSpan` | `op regexFindSpan (as string: pattern, as string: text) as list of data` | `list of data` |
| `regexFindAllSpans` | `op regexFindAllSpans (as string: pattern, as string: text) as list of data` | `list of data` |
| `regexCount` | `op regexCount (as string: pattern, as string: text) as int64` | `int64` |

#### Operation Technical Specifications:

##### `op regexIsMatch`
```flux
op regexIsMatch (as string: pattern, as string: text) as bool
```
- **Parameters**:
  - `pattern` (`string`): Input argument for operation execution.
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `regexIsMatch` functionality within the `RegexSearchContract` domain.

##### `op regexFullMatch`
```flux
op regexFullMatch (as string: pattern, as string: text) as bool
```
- **Parameters**:
  - `pattern` (`string`): Input argument for operation execution.
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `regexFullMatch` functionality within the `RegexSearchContract` domain.

##### `op regexFind`
```flux
op regexFind (as string: pattern, as string: text) as string
```
- **Parameters**:
  - `pattern` (`string`): Input argument for operation execution.
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `regexFind` functionality within the `RegexSearchContract` domain.

##### `op regexFindAll`
```flux
op regexFindAll (as string: pattern, as string: text) as list of data
```
- **Parameters**:
  - `pattern` (`string`): Input argument for operation execution.
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `regexFindAll` functionality within the `RegexSearchContract` domain.

##### `op regexFindIndex`
```flux
op regexFindIndex (as string: pattern, as string: text) as int64
```
- **Parameters**:
  - `pattern` (`string`): Input argument for operation execution.
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `regexFindIndex` functionality within the `RegexSearchContract` domain.

##### `op regexFindSpan`
```flux
op regexFindSpan (as string: pattern, as string: text) as list of data
```
- **Parameters**:
  - `pattern` (`string`): Input argument for operation execution.
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `regexFindSpan` functionality within the `RegexSearchContract` domain.

##### `op regexFindAllSpans`
```flux
op regexFindAllSpans (as string: pattern, as string: text) as list of data
```
- **Parameters**:
  - `pattern` (`string`): Input argument for operation execution.
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `regexFindAllSpans` functionality within the `RegexSearchContract` domain.

##### `op regexCount`
```flux
op regexCount (as string: pattern, as string: text) as int64
```
- **Parameters**:
  - `pattern` (`string`): Input argument for operation execution.
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `regexCount` functionality within the `RegexSearchContract` domain.

### 4.4 Contract `RegexTransformContract` (`RegexTransform.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `regexReplace` | `op regexReplace (as string: pattern, as string: text, as string: replacement) as string` | `string` |
| `regexReplaceFirst` | `op regexReplaceFirst (as string: pattern, as string: text, as string: replacement) as string` | `string` |
| `regexReplaceLimit` | `op regexReplaceLimit (as string: pattern, as string: text, as string: replacement, as int64: max_count) as string` | `string` |
| `regexSplit` | `op regexSplit (as string: pattern, as string: text) as list of data` | `list of data` |
| `regexSplitLimit` | `op regexSplitLimit (as string: pattern, as string: text, as int64: limit) as list of data` | `list of data` |

#### Operation Technical Specifications:

##### `op regexReplace`
```flux
op regexReplace (as string: pattern, as string: text, as string: replacement) as string
```
- **Parameters**:
  - `pattern` (`string`): Input argument for operation execution.
  - `text` (`string`): Input argument for operation execution.
  - `replacement` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `regexReplace` functionality within the `RegexTransformContract` domain.

##### `op regexReplaceFirst`
```flux
op regexReplaceFirst (as string: pattern, as string: text, as string: replacement) as string
```
- **Parameters**:
  - `pattern` (`string`): Input argument for operation execution.
  - `text` (`string`): Input argument for operation execution.
  - `replacement` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `regexReplaceFirst` functionality within the `RegexTransformContract` domain.

##### `op regexReplaceLimit`
```flux
op regexReplaceLimit (as string: pattern, as string: text, as string: replacement, as int64: max_count) as string
```
- **Parameters**:
  - `pattern` (`string`): Input argument for operation execution.
  - `text` (`string`): Input argument for operation execution.
  - `replacement` (`string`): Input argument for operation execution.
  - `max_count` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `regexReplaceLimit` functionality within the `RegexTransformContract` domain.

##### `op regexSplit`
```flux
op regexSplit (as string: pattern, as string: text) as list of data
```
- **Parameters**:
  - `pattern` (`string`): Input argument for operation execution.
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `regexSplit` functionality within the `RegexTransformContract` domain.

##### `op regexSplitLimit`
```flux
op regexSplitLimit (as string: pattern, as string: text, as int64: limit) as list of data
```
- **Parameters**:
  - `pattern` (`string`): Input argument for operation execution.
  - `text` (`string`): Input argument for operation execution.
  - `limit` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `regexSplitLimit` functionality within the `RegexTransformContract` domain.

### 4.5 Contract `RegexUtilityContract` (`RegexUtility.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `regexEscape` | `op regexEscape (as string: text) as string` | `string` |
| `regexIsValid` | `op regexIsValid (as string: pattern) as bool` | `bool` |
| `regexIsPatternLiteral` | `op regexIsPatternLiteral (as string: pattern) as bool` | `bool` |
| `regexMatchWithFlags` | `op regexMatchWithFlags (as string: pattern, as string: text, as string: flags) as bool` | `bool` |

#### Operation Technical Specifications:

##### `op regexEscape`
```flux
op regexEscape (as string: text) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `regexEscape` functionality within the `RegexUtilityContract` domain.

##### `op regexIsValid`
```flux
op regexIsValid (as string: pattern) as bool
```
- **Parameters**:
  - `pattern` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `regexIsValid` functionality within the `RegexUtilityContract` domain.

##### `op regexIsPatternLiteral`
```flux
op regexIsPatternLiteral (as string: pattern) as bool
```
- **Parameters**:
  - `pattern` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `regexIsPatternLiteral` functionality within the `RegexUtilityContract` domain.

##### `op regexMatchWithFlags`
```flux
op regexMatchWithFlags (as string: pattern, as string: text, as string: flags) as bool
```
- **Parameters**:
  - `pattern` (`string`): Input argument for operation execution.
  - `text` (`string`): Input argument for operation execution.
  - `flags` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `regexMatchWithFlags` functionality within the `RegexUtilityContract` domain.

---

## 5. Canonical Usage Examples in TheFlux

The following snippet illustrates importing and utilizing the library in a TheFlux program:

```flux
# Canonical Usage Example for RegexStdLib
use RegexStdLib

program (ExampleOfRegexStdLib) {
      println("==================================================")
      println("  Standard Library Demonstration: RegexStdLib")
      println("==================================================")

      # Invoking canonical operation
      mut as data: result = RegexStdLib::regexMatch("^[0-9]+$", "12345")
      println("Obtained result: " + result)

      println("Execution completed successfully.")
}
```

---

> [!TIP]
> For the complete unified architecture across all standard libraries, consult the master [StdLibs.md](../StdLibs.md) reference.
