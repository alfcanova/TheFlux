# 📚 `DebugStdLib` — Diagnostics, Assertions, Stack Tracing, and Runtime Inspection

> **Architectural Pillar**: Pillar 1 (Core, Text & OO)  
> **Status**: ✅ Certified with 100% Parity across 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Master File**: `stdlib/DebugStdLib/DebugStdLib.fdsl`  
> **Import Mode**: `use DebugStdLib` or `use DebugStdLib::<Module>::<operation>`

---

## 1. Overview and Capabilities

The **`DebugStdLib`** standard library is an integral component of the official TheFlux language ecosystem, providing certified system-level algorithms and robust capabilities.

Active instrumentation and debugging toolset featuring defensive assertions (`assert`), stack trace extraction, multi-level structured logging, value diffing, and lightweight performance benchmarking utilities.

### 1.1 Key Architectural Principles and Design
- **Static Fusion and Zero-Overhead**: All domain modules are transparently fused into the `DebugStdLib` unified agent at compile time, avoiding virtual dispatch penalties.
- **Safety and Isolation**: Operations strictly validate parameter bounds and guarantee predictable error semantics via contract definitions.
- **Universal Multi-Backend Parity**: Bit-for-bit identical execution guarantees across interpreter (`in`), bytecode VM (`vm`, `vmr`), native AOT LLVM (`llvm`), and WebAssembly (`wat`, `wasm`).

---

## 2. Modular Structure and Contracts

The library comprises **8 domain modules** declaring a total of **33 public operations**:

| Domain Source File | Formal Contract | Domain Responsibility | Ops Count |
|---|---|---|:---:|
| `DebugAssert.fdsl` | `DebugAssertContract` | Specialized domain for `DebugAssert` | 5 |
| `DebugDiff.fdsl` | `DebugDiffContract` | Specialized domain for `DebugDiff` | 3 |
| `DebugFilter.fdsl` | `DebugFilterContract` | Specialized domain for `DebugFilter` | 3 |
| `DebugInspect.fdsl` | `DebugInspectContract` | Specialized domain for `DebugInspect` | 6 |
| `DebugLogging.fdsl` | `DebugLoggingContract` | Specialized domain for `DebugLogging` | 6 |
| `DebugPipeline.fdsl` | `DebugPipelineContract` | Specialized domain for `DebugPipeline` | 3 |
| `DebugProfile.fdsl` | `DebugProfileContract` | Specialized domain for `DebugProfile` | 4 |
| `DebugState.fdsl` | `DebugStateContract` | Specialized domain for `DebugState` | 3 |

---

## 3. Public Types, Structures, and Enumerations

The `DebugStdLib` library operates directly on primitive native TheFlux types (`string`, `int64`, `float64`, `bool`, `list of data`, etc.) without requiring custom composite types.

---

## 4. Detailed Operations Catalog by Domain

### 4.1 Contract `DebugAssertContract` (`DebugAssert.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `debugAssert` | `op debugAssert (as bool: condition, as string: message) as bool` | `bool` |
| `debugAssertEqualInt` | `op debugAssertEqualInt (as int64: actual, as int64: expected, as string: tag) as bool` | `bool` |
| `debugAssertEqualString` | `op debugAssertEqualString (as string: actual, as string: expected, as string: tag) as bool` | `bool` |
| `debugAssertEqualBool` | `op debugAssertEqualBool (as bool: actual, as bool: expected, as string: tag) as bool` | `bool` |
| `debugAssertInRange` | `op debugAssertInRange (as int64: val, as int64: min_val, as int64: max_val, as string: tag) as bool` | `bool` |

#### Operation Technical Specifications:

##### `op debugAssert`
```flux
op debugAssert (as bool: condition, as string: message) as bool
```
- **Parameters**:
  - `condition` (`bool`): Input argument for operation execution.
  - `message` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `debugAssert` functionality within the `DebugAssertContract` domain.

##### `op debugAssertEqualInt`
```flux
op debugAssertEqualInt (as int64: actual, as int64: expected, as string: tag) as bool
```
- **Parameters**:
  - `actual` (`int64`): Input argument for operation execution.
  - `expected` (`int64`): Input argument for operation execution.
  - `tag` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `debugAssertEqualInt` functionality within the `DebugAssertContract` domain.

##### `op debugAssertEqualString`
```flux
op debugAssertEqualString (as string: actual, as string: expected, as string: tag) as bool
```
- **Parameters**:
  - `actual` (`string`): Input argument for operation execution.
  - `expected` (`string`): Input argument for operation execution.
  - `tag` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `debugAssertEqualString` functionality within the `DebugAssertContract` domain.

##### `op debugAssertEqualBool`
```flux
op debugAssertEqualBool (as bool: actual, as bool: expected, as string: tag) as bool
```
- **Parameters**:
  - `actual` (`bool`): Input argument for operation execution.
  - `expected` (`bool`): Input argument for operation execution.
  - `tag` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `debugAssertEqualBool` functionality within the `DebugAssertContract` domain.

##### `op debugAssertInRange`
```flux
op debugAssertInRange (as int64: val, as int64: min_val, as int64: max_val, as string: tag) as bool
```
- **Parameters**:
  - `val` (`int64`): Input argument for operation execution.
  - `min_val` (`int64`): Input argument for operation execution.
  - `max_val` (`int64`): Input argument for operation execution.
  - `tag` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `debugAssertInRange` functionality within the `DebugAssertContract` domain.

### 4.2 Contract `DebugDiffContract` (`DebugDiff.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `debugDiffString` | `op debugDiffString (as string: actual, as string: expected) as string` | `string` |
| `debugDiffList` | `op debugDiffList (as list of data: actual, as list of data: expected) as string` | `string` |
| `debugDiffCount` | `op debugDiffCount (as list of data: a, as list of data: b) as int64` | `int64` |

#### Operation Technical Specifications:

##### `op debugDiffString`
```flux
op debugDiffString (as string: actual, as string: expected) as string
```
- **Parameters**:
  - `actual` (`string`): Input argument for operation execution.
  - `expected` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `debugDiffString` functionality within the `DebugDiffContract` domain.

##### `op debugDiffList`
```flux
op debugDiffList (as list of data: actual, as list of data: expected) as string
```
- **Parameters**:
  - `actual` (`list of data`): Input argument for operation execution.
  - `expected` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `debugDiffList` functionality within the `DebugDiffContract` domain.

##### `op debugDiffCount`
```flux
op debugDiffCount (as list of data: a, as list of data: b) as int64
```
- **Parameters**:
  - `a` (`list of data`): Input argument for operation execution.
  - `b` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `debugDiffCount` functionality within the `DebugDiffContract` domain.

### 4.3 Contract `DebugFilterContract` (`DebugFilter.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `debugLevelShouldLog` | `op debugLevelShouldLog (as int64: current_level, as int64: message_level) as bool` | `bool` |
| `debugLevelName` | `op debugLevelName (as int64: level) as string` | `string` |
| `debugTagMatches` | `op debugTagMatches (as string: active_tags, as string: target_tag) as bool` | `bool` |

#### Operation Technical Specifications:

##### `op debugLevelShouldLog`
```flux
op debugLevelShouldLog (as int64: current_level, as int64: message_level) as bool
```
- **Parameters**:
  - `current_level` (`int64`): Input argument for operation execution.
  - `message_level` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `debugLevelShouldLog` functionality within the `DebugFilterContract` domain.

##### `op debugLevelName`
```flux
op debugLevelName (as int64: level) as string
```
- **Parameters**:
  - `level` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `debugLevelName` functionality within the `DebugFilterContract` domain.

##### `op debugTagMatches`
```flux
op debugTagMatches (as string: active_tags, as string: target_tag) as bool
```
- **Parameters**:
  - `active_tags` (`string`): Input argument for operation execution.
  - `target_tag` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `debugTagMatches` functionality within the `DebugFilterContract` domain.

### 4.4 Contract `DebugInspectContract` (`DebugInspect.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `debugReprString` | `op debugReprString (as string: text) as string` | `string` |
| `debugReprInt` | `op debugReprInt (as int64: value) as string` | `string` |
| `debugReprFloat` | `op debugReprFloat (as float64: value) as string` | `string` |
| `debugReprBool` | `op debugReprBool (as bool: value) as string` | `string` |
| `debugDumpList` | `op debugDumpList (as list of data: items, as string: label) as string` | `string` |
| `debugHexDump` | `op debugHexDump (as string: text) as string` | `string` |

#### Operation Technical Specifications:

##### `op debugReprString`
```flux
op debugReprString (as string: text) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `debugReprString` functionality within the `DebugInspectContract` domain.

##### `op debugReprInt`
```flux
op debugReprInt (as int64: value) as string
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `debugReprInt` functionality within the `DebugInspectContract` domain.

##### `op debugReprFloat`
```flux
op debugReprFloat (as float64: value) as string
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `debugReprFloat` functionality within the `DebugInspectContract` domain.

##### `op debugReprBool`
```flux
op debugReprBool (as bool: value) as string
```
- **Parameters**:
  - `value` (`bool`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `debugReprBool` functionality within the `DebugInspectContract` domain.

##### `op debugDumpList`
```flux
op debugDumpList (as list of data: items, as string: label) as string
```
- **Parameters**:
  - `items` (`list of data`): Input argument for operation execution.
  - `label` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `debugDumpList` functionality within the `DebugInspectContract` domain.

##### `op debugHexDump`
```flux
op debugHexDump (as string: text) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `debugHexDump` functionality within the `DebugInspectContract` domain.

### 4.5 Contract `DebugLoggingContract` (`DebugLogging.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `debugLogInfo` | `op debugLogInfo (as string: tag, as string: message) as string` | `string` |
| `debugLogWarn` | `op debugLogWarn (as string: tag, as string: message) as string` | `string` |
| `debugLogError` | `op debugLogError (as string: tag, as string: message) as string` | `string` |
| `debugLogDebug` | `op debugLogDebug (as string: tag, as string: message) as string` | `string` |
| `debugTrace` | `op debugTrace (as string: context, as string: step) as string` | `string` |
| `debugBanner` | `op debugBanner (as string: title, as int64: width) as string` | `string` |

#### Operation Technical Specifications:

##### `op debugLogInfo`
```flux
op debugLogInfo (as string: tag, as string: message) as string
```
- **Parameters**:
  - `tag` (`string`): Input argument for operation execution.
  - `message` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `debugLogInfo` functionality within the `DebugLoggingContract` domain.

##### `op debugLogWarn`
```flux
op debugLogWarn (as string: tag, as string: message) as string
```
- **Parameters**:
  - `tag` (`string`): Input argument for operation execution.
  - `message` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `debugLogWarn` functionality within the `DebugLoggingContract` domain.

##### `op debugLogError`
```flux
op debugLogError (as string: tag, as string: message) as string
```
- **Parameters**:
  - `tag` (`string`): Input argument for operation execution.
  - `message` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `debugLogError` functionality within the `DebugLoggingContract` domain.

##### `op debugLogDebug`
```flux
op debugLogDebug (as string: tag, as string: message) as string
```
- **Parameters**:
  - `tag` (`string`): Input argument for operation execution.
  - `message` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `debugLogDebug` functionality within the `DebugLoggingContract` domain.

##### `op debugTrace`
```flux
op debugTrace (as string: context, as string: step) as string
```
- **Parameters**:
  - `context` (`string`): Input argument for operation execution.
  - `step` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `debugTrace` functionality within the `DebugLoggingContract` domain.

##### `op debugBanner`
```flux
op debugBanner (as string: title, as int64: width) as string
```
- **Parameters**:
  - `title` (`string`): Input argument for operation execution.
  - `width` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `debugBanner` functionality within the `DebugLoggingContract` domain.

### 4.6 Contract `DebugPipelineContract` (`DebugPipeline.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `debugTap` | `op debugTap (as data: value, as string: step_name) as data` | `data` |
| `debugTapIf` | `op debugTapIf (as data: value, as bool: condition, as string: tag) as data` | `data` |
| `debugCounterTap` | `op debugCounterTap (as data: value, as int64: counter) as int64` | `int64` |

#### Operation Technical Specifications:

##### `op debugTap`
```flux
op debugTap (as data: value, as string: step_name) as data
```
- **Parameters**:
  - `value` (`data`): Input argument for operation execution.
  - `step_name` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `debugTap` functionality within the `DebugPipelineContract` domain.

##### `op debugTapIf`
```flux
op debugTapIf (as data: value, as bool: condition, as string: tag) as data
```
- **Parameters**:
  - `value` (`data`): Input argument for operation execution.
  - `condition` (`bool`): Input argument for operation execution.
  - `tag` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `debugTapIf` functionality within the `DebugPipelineContract` domain.

##### `op debugCounterTap`
```flux
op debugCounterTap (as data: value, as int64: counter) as int64
```
- **Parameters**:
  - `value` (`data`): Input argument for operation execution.
  - `counter` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `debugCounterTap` functionality within the `DebugPipelineContract` domain.

### 4.7 Contract `DebugProfileContract` (`DebugProfile.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `debugCounterNew` | `op debugCounterNew () as int64` | `int64` |
| `debugCounterIncrement` | `op debugCounterIncrement (as int64: counter, as int64: step) as int64` | `int64` |
| `debugMetricRecord` | `op debugMetricRecord (as string: name, as int64: value, as string: unit) as string` | `string` |
| `debugProgress` | `op debugProgress (as int64: current, as int64: total, as int64: width) as string` | `string` |

#### Operation Technical Specifications:

##### `op debugCounterNew`
```flux
op debugCounterNew () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `debugCounterNew` functionality within the `DebugProfileContract` domain.

##### `op debugCounterIncrement`
```flux
op debugCounterIncrement (as int64: counter, as int64: step) as int64
```
- **Parameters**:
  - `counter` (`int64`): Input argument for operation execution.
  - `step` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `debugCounterIncrement` functionality within the `DebugProfileContract` domain.

##### `op debugMetricRecord`
```flux
op debugMetricRecord (as string: name, as int64: value, as string: unit) as string
```
- **Parameters**:
  - `name` (`string`): Input argument for operation execution.
  - `value` (`int64`): Input argument for operation execution.
  - `unit` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `debugMetricRecord` functionality within the `DebugProfileContract` domain.

##### `op debugProgress`
```flux
op debugProgress (as int64: current, as int64: total, as int64: width) as string
```
- **Parameters**:
  - `current` (`int64`): Input argument for operation execution.
  - `total` (`int64`): Input argument for operation execution.
  - `width` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `debugProgress` functionality within the `DebugProfileContract` domain.

### 4.8 Contract `DebugStateContract` (`DebugState.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `debugStateTransition` | `op debugStateTransition (as string: entity_name, as string: from_state, as string: to_state, as string: event_name) as string` | `string` |
| `debugStateAudit` | `op debugStateAudit (as string: current_state, as list of data: allowed_states) as bool` | `bool` |
| `debugBreadcrumb` | `op debugBreadcrumb (as string: trail, as string: new_event) as string` | `string` |

#### Operation Technical Specifications:

##### `op debugStateTransition`
```flux
op debugStateTransition (as string: entity_name, as string: from_state, as string: to_state, as string: event_name) as string
```
- **Parameters**:
  - `entity_name` (`string`): Input argument for operation execution.
  - `from_state` (`string`): Input argument for operation execution.
  - `to_state` (`string`): Input argument for operation execution.
  - `event_name` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `debugStateTransition` functionality within the `DebugStateContract` domain.

##### `op debugStateAudit`
```flux
op debugStateAudit (as string: current_state, as list of data: allowed_states) as bool
```
- **Parameters**:
  - `current_state` (`string`): Input argument for operation execution.
  - `allowed_states` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `debugStateAudit` functionality within the `DebugStateContract` domain.

##### `op debugBreadcrumb`
```flux
op debugBreadcrumb (as string: trail, as string: new_event) as string
```
- **Parameters**:
  - `trail` (`string`): Input argument for operation execution.
  - `new_event` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `debugBreadcrumb` functionality within the `DebugStateContract` domain.

---

## 5. Canonical Usage Examples in TheFlux

The following snippet illustrates importing and utilizing the library in a TheFlux program:

```flux
# Canonical Usage Example for DebugStdLib
use DebugStdLib

program (ExampleOfDebugStdLib) {
      println("==================================================")
      println("  Standard Library Demonstration: DebugStdLib")
      println("==================================================")

      # Invoking canonical operation
      mut as data: result = DebugStdLib::debugInspect(42)
      println("Obtained result: " + result)

      println("Execution completed successfully.")
}
```

---

> [!TIP]
> For the complete unified architecture across all standard libraries, consult the master [StdLibs.md](../StdLibs.md) reference.
