# 📚 `StructStdLib` — Struct Introspection, Schema Validation, and Deep Cloning

> **Architectural Pillar**: Pillar 2 (Structures & State)  
> **Status**: ✅ Certified with 100% Parity across 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Master File**: `stdlib/StructStdLib/StructStdLib.fdsl`  
> **Import Mode**: `use StructStdLib` or `use StructStdLib::<Module>::<operation>`

---

## 1. Overview and Capabilities

The **`StructStdLib`** standard library is an integral component of the official TheFlux language ecosystem, providing certified system-level algorithms and robust capabilities.

Reflection and schema utilities for user-defined structs: inspecting field names and associated type signatures, structural conformity validation, deep cloning, and byte-level memory serialization.

### 1.1 Key Architectural Principles and Design
- **Static Fusion and Zero-Overhead**: All domain modules are transparently fused into the `StructStdLib` unified agent at compile time, avoiding virtual dispatch penalties.
- **Safety and Isolation**: Operations strictly validate parameter bounds and guarantee predictable error semantics via contract definitions.
- **Universal Multi-Backend Parity**: Bit-for-bit identical execution guarantees across interpreter (`in`), bytecode VM (`vm`, `vmr`), native AOT LLVM (`llvm`), and WebAssembly (`wat`, `wasm`).

---

## 2. Modular Structure and Contracts

The library comprises **4 domain modules** declaring a total of **23 public operations**:

| Domain Source File | Formal Contract | Domain Responsibility | Ops Count |
|---|---|---|:---:|
| `StructConversion.fdsl` | `StructConversionContract` | Specialized domain for `StructConversion` | 4 |
| `StructCore.fdsl` | `StructCoreContract` | Specialized domain for `StructCore` | 7 |
| `StructIntrospection.fdsl` | `StructIntrospectionContract` | Specialized domain for `StructIntrospection` | 9 |
| `StructMemory.fdsl` | `StructMemoryContract` | Specialized domain for `StructMemory` | 3 |

---

## 3. Public Types, Structures, and Enumerations

The `StructStdLib` library operates directly on primitive native TheFlux types (`string`, `int64`, `float64`, `bool`, `list of data`, etc.) without requiring custom composite types.

---

## 4. Detailed Operations Catalog by Domain

### 4.1 Contract `StructConversionContract` (`StructConversion.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `structToMap` | `op structToMap (as data: instance) as map` | `map` |
| `structEntries` | `op structEntries (as data: instance) as list of data` | `list of data` |
| `structToString` | `op structToString (as data: instance) as string` | `string` |
| `structDiff` | `op structDiff (as data: a, as data: b) as map` | `map` |

#### Operation Technical Specifications:

##### `op structToMap`
```flux
op structToMap (as data: instance) as map
```
- **Parameters**:
  - `instance` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `structToMap` functionality within the `StructConversionContract` domain.

##### `op structEntries`
```flux
op structEntries (as data: instance) as list of data
```
- **Parameters**:
  - `instance` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `structEntries` functionality within the `StructConversionContract` domain.

##### `op structToString`
```flux
op structToString (as data: instance) as string
```
- **Parameters**:
  - `instance` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `structToString` functionality within the `StructConversionContract` domain.

##### `op structDiff`
```flux
op structDiff (as data: a, as data: b) as map
```
- **Parameters**:
  - `a` (`data`): Input argument for operation execution.
  - `b` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `structDiff` functionality within the `StructConversionContract` domain.

### 4.2 Contract `StructCoreContract` (`StructCore.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `structAllocate` | `op structAllocate (as string: name) as data` | `data` |
| `structFromMap` | `op structFromMap (as string: name, as map: data_map) as data` | `data` |
| `structGetField` | `op structGetField (as data: instance, as string: field) as data` | `data` |
| `structSetField` | `op structSetField (as data: instance, as string: field, as data: value) as data` | `data` |
| `structName` | `op structName (as data: instance) as string` | `string` |
| `structClone` | `op structClone (as data: instance) as data` | `data` |
| `structEquals` | `op structEquals (as data: a, as data: b) as bool` | `bool` |

#### Operation Technical Specifications:

##### `op structAllocate`
```flux
op structAllocate (as string: name) as data
```
- **Parameters**:
  - `name` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `structAllocate` functionality within the `StructCoreContract` domain.

##### `op structFromMap`
```flux
op structFromMap (as string: name, as map: data_map) as data
```
- **Parameters**:
  - `name` (`string`): Input argument for operation execution.
  - `data_map` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `structFromMap` functionality within the `StructCoreContract` domain.

##### `op structGetField`
```flux
op structGetField (as data: instance, as string: field) as data
```
- **Parameters**:
  - `instance` (`data`): Input argument for operation execution.
  - `field` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `structGetField` functionality within the `StructCoreContract` domain.

##### `op structSetField`
```flux
op structSetField (as data: instance, as string: field, as data: value) as data
```
- **Parameters**:
  - `instance` (`data`): Input argument for operation execution.
  - `field` (`string`): Input argument for operation execution.
  - `value` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `data`
  - ✅ Emits `nice` with status message `"Campo atualizado com sucesso"`
- **Functional Description**:
  - Executes canonical `structSetField` functionality within the `StructCoreContract` domain.

##### `op structName`
```flux
op structName (as data: instance) as string
```
- **Parameters**:
  - `instance` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `structName` functionality within the `StructCoreContract` domain.

##### `op structClone`
```flux
op structClone (as data: instance) as data
```
- **Parameters**:
  - `instance` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `structClone` functionality within the `StructCoreContract` domain.

##### `op structEquals`
```flux
op structEquals (as data: a, as data: b) as bool
```
- **Parameters**:
  - `a` (`data`): Input argument for operation execution.
  - `b` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `structEquals` functionality within the `StructCoreContract` domain.

### 4.3 Contract `StructIntrospectionContract` (`StructIntrospection.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `structIsStruct` | `op structIsStruct (as data: instance) as bool` | `bool` |
| `structIsInstance` | `op structIsInstance (as data: instance, as string: name) as bool` | `bool` |
| `structHasField` | `op structHasField (as data: instance, as string: field) as bool` | `bool` |
| `structFields` | `op structFields (as string: name) as list of data` | `list of data` |
| `structFieldCount` | `op structFieldCount (as string: name) as int64` | `int64` |
| `structFieldType` | `op structFieldType (as string: name, as string: field) as string` | `string` |
| `structIsFieldMutable` | `op structIsFieldMutable (as string: name, as string: field) as bool` | `bool` |
| `structMutableFields` | `op structMutableFields (as string: name) as list of data` | `list of data` |
| `structImmutableFields` | `op structImmutableFields (as string: name) as list of data` | `list of data` |

#### Operation Technical Specifications:

##### `op structIsStruct`
```flux
op structIsStruct (as data: instance) as bool
```
- **Parameters**:
  - `instance` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `structIsStruct` functionality within the `StructIntrospectionContract` domain.

##### `op structIsInstance`
```flux
op structIsInstance (as data: instance, as string: name) as bool
```
- **Parameters**:
  - `instance` (`data`): Input argument for operation execution.
  - `name` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `structIsInstance` functionality within the `StructIntrospectionContract` domain.

##### `op structHasField`
```flux
op structHasField (as data: instance, as string: field) as bool
```
- **Parameters**:
  - `instance` (`data`): Input argument for operation execution.
  - `field` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `structHasField` functionality within the `StructIntrospectionContract` domain.

##### `op structFields`
```flux
op structFields (as string: name) as list of data
```
- **Parameters**:
  - `name` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `structFields` functionality within the `StructIntrospectionContract` domain.

##### `op structFieldCount`
```flux
op structFieldCount (as string: name) as int64
```
- **Parameters**:
  - `name` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `structFieldCount` functionality within the `StructIntrospectionContract` domain.

##### `op structFieldType`
```flux
op structFieldType (as string: name, as string: field) as string
```
- **Parameters**:
  - `name` (`string`): Input argument for operation execution.
  - `field` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `structFieldType` functionality within the `StructIntrospectionContract` domain.

##### `op structIsFieldMutable`
```flux
op structIsFieldMutable (as string: name, as string: field) as bool
```
- **Parameters**:
  - `name` (`string`): Input argument for operation execution.
  - `field` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `structIsFieldMutable` functionality within the `StructIntrospectionContract` domain.

##### `op structMutableFields`
```flux
op structMutableFields (as string: name) as list of data
```
- **Parameters**:
  - `name` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `structMutableFields` functionality within the `StructIntrospectionContract` domain.

##### `op structImmutableFields`
```flux
op structImmutableFields (as string: name) as list of data
```
- **Parameters**:
  - `name` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `structImmutableFields` functionality within the `StructIntrospectionContract` domain.

### 4.4 Contract `StructMemoryContract` (`StructMemory.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `structSizeOf` | `op structSizeOf (as string: name) as int64` | `int64` |
| `structAlignOf` | `op structAlignOf (as string: name) as int64` | `int64` |
| `structFieldOffset` | `op structFieldOffset (as string: name, as string: field) as int64` | `int64` |

#### Operation Technical Specifications:

##### `op structSizeOf`
```flux
op structSizeOf (as string: name) as int64
```
- **Parameters**:
  - `name` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `structSizeOf` functionality within the `StructMemoryContract` domain.

##### `op structAlignOf`
```flux
op structAlignOf (as string: name) as int64
```
- **Parameters**:
  - `name` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `structAlignOf` functionality within the `StructMemoryContract` domain.

##### `op structFieldOffset`
```flux
op structFieldOffset (as string: name, as string: field) as int64
```
- **Parameters**:
  - `name` (`string`): Input argument for operation execution.
  - `field` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `structFieldOffset` functionality within the `StructMemoryContract` domain.

---

## 5. Canonical Usage Examples in TheFlux

The following snippet illustrates importing and utilizing the library in a TheFlux program:

```flux
# Canonical Usage Example for StructStdLib
use StructStdLib

program (ExampleOfStructStdLib) {
      println("==================================================")
      println("  Standard Library Demonstration: StructStdLib")
      println("==================================================")

      # Invoking canonical operation
      mut as data: result = StructStdLib::structFieldCount("MyStruct")
      println("Obtained result: " + result)

      println("Execution completed successfully.")
}
```

---

> [!TIP]
> For the complete unified architecture across all standard libraries, consult the master [StdLibs.md](../StdLibs.md) reference.
