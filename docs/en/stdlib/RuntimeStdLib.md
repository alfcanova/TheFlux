# 📚 `RuntimeStdLib` — TheFlux Virtual Machine Control, Memory Management, and Telemetry

> **Architectural Pillar**: Pillar 4 (System, I/O & Network)  
> **Status**: ✅ Certified with 100% Parity across 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Master File**: `stdlib/RuntimeStdLib/RuntimeStdLib.fdsl`  
> **Import Mode**: `use RuntimeStdLib` or `use RuntimeStdLib::<Module>::<operation>`

---

## 1. Overview and Capabilities

The **`RuntimeStdLib`** standard library is an integral component of the official TheFlux language ecosystem, providing certified system-level algorithms and robust capabilities.

Low-level inspection and governance of the TheFlux runtime virtual machine: heap memory metrics, garbage collector controls, execution telemetry, and compiler/host platform version metadata.

### 1.1 Key Architectural Principles and Design
- **Static Fusion and Zero-Overhead**: All domain modules are transparently fused into the `RuntimeStdLib` unified agent at compile time, avoiding virtual dispatch penalties.
- **Safety and Isolation**: Operations strictly validate parameter bounds and guarantee predictable error semantics via contract definitions.
- **Universal Multi-Backend Parity**: Bit-for-bit identical execution guarantees across interpreter (`in`), bytecode VM (`vm`, `vmr`), native AOT LLVM (`llvm`), and WebAssembly (`wat`, `wasm`).

---

## 2. Modular Structure and Contracts

The library comprises **4 domain modules** declaring a total of **45 public operations**:

| Domain Source File | Formal Contract | Domain Responsibility | Ops Count |
|---|---|---|:---:|
| `RuntimeControl.fdsl` | `RuntimeControlContract` | Specialized domain for `RuntimeControl` | 8 |
| `RuntimeHost.fdsl` | `RuntimeHostContract` | Specialized domain for `RuntimeHost` | 18 |
| `RuntimeMemory.fdsl` | `RuntimeMemoryContract` | Specialized domain for `RuntimeMemory` | 6 |
| `RuntimeType.fdsl` | `RuntimeTypeContract` | Specialized domain for `RuntimeType` | 13 |

---

## 3. Public Types, Structures, and Enumerations

The `RuntimeStdLib` library operates directly on primitive native TheFlux types (`string`, `int64`, `float64`, `bool`, `list of data`, etc.) without requiring custom composite types.

---

## 4. Detailed Operations Catalog by Domain

### 4.1 Contract `RuntimeControlContract` (`RuntimeControl.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `runtimePanic` | `op runtimePanic (as string: message) as bool` | `bool` |
| `runtimeTrap` | `op runtimeTrap () as bool` | `bool` |
| `runtimeSetPanicHook` | `op runtimeSetPanicHook (as string: agent_name, as string: op_name) as bool` | `bool` |
| `runtimeStackTrace` | `op runtimeStackTrace () as list of data` | `list of data` |
| `panic` | `op panic (as string: message) as bool` | `bool` |
| `trap` | `op trap () as bool` | `bool` |
| `setPanicHook` | `op setPanicHook (as string: agent_name, as string: op_name) as bool` | `bool` |
| `stackTrace` | `op stackTrace () as list of data` | `list of data` |

#### Operation Technical Specifications:

##### `op runtimePanic`
```flux
op runtimePanic (as string: message) as bool
```
- **Parameters**:
  - `message` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `runtimePanic` functionality within the `RuntimeControlContract` domain.

##### `op runtimeTrap`
```flux
op runtimeTrap () as bool
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `runtimeTrap` functionality within the `RuntimeControlContract` domain.

##### `op runtimeSetPanicHook`
```flux
op runtimeSetPanicHook (as string: agent_name, as string: op_name) as bool
```
- **Parameters**:
  - `agent_name` (`string`): Input argument for operation execution.
  - `op_name` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `runtimeSetPanicHook` functionality within the `RuntimeControlContract` domain.

##### `op runtimeStackTrace`
```flux
op runtimeStackTrace () as list of data
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `runtimeStackTrace` functionality within the `RuntimeControlContract` domain.

##### `op panic`
```flux
op panic (as string: message) as bool
```
- **Parameters**:
  - `message` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `panic` functionality within the `RuntimeControlContract` domain.

##### `op trap`
```flux
op trap () as bool
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `trap` functionality within the `RuntimeControlContract` domain.

##### `op setPanicHook`
```flux
op setPanicHook (as string: agent_name, as string: op_name) as bool
```
- **Parameters**:
  - `agent_name` (`string`): Input argument for operation execution.
  - `op_name` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setPanicHook` functionality within the `RuntimeControlContract` domain.

##### `op stackTrace`
```flux
op stackTrace () as list of data
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stackTrace` functionality within the `RuntimeControlContract` domain.

### 4.2 Contract `RuntimeHostContract` (`RuntimeHost.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `runtimeBackend` | `op runtimeBackend () as string` | `string` |
| `runtimeIsNative` | `op runtimeIsNative () as bool` | `bool` |
| `runtimeIsWasm` | `op runtimeIsWasm () as bool` | `bool` |
| `runtimeIsInterpreter` | `op runtimeIsInterpreter () as bool` | `bool` |
| `runtimePointerSize` | `op runtimePointerSize () as int64` | `int64` |
| `runtimeCompilerVersion` | `op runtimeCompilerVersion () as string` | `string` |
| `runtimeGetArgs` | `op runtimeGetArgs () as list of data` | `list of data` |
| `runtimeGetArgCount` | `op runtimeGetArgCount () as int64` | `int64` |
| `runtimeGetArg` | `op runtimeGetArg (as int64: index) as string` | `string` |
| `runtimeExecutablePath` | `op runtimeExecutablePath () as string` | `string` |
| `backend` | `op backend () as string` | `string` |
| `isNative` | `op isNative () as bool` | `bool` |
| `isWasm` | `op isWasm () as bool` | `bool` |
| `isInterpreter` | `op isInterpreter () as bool` | `bool` |
| `compilerVersion` | `op compilerVersion () as string` | `string` |
| `getArgs` | `op getArgs () as list of data` | `list of data` |
| `getArgCount` | `op getArgCount () as int64` | `int64` |
| `getArg` | `op getArg (as int64: index) as string` | `string` |

#### Operation Technical Specifications:

##### `op runtimeBackend`
```flux
op runtimeBackend () as string
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `runtimeBackend` functionality within the `RuntimeHostContract` domain.

##### `op runtimeIsNative`
```flux
op runtimeIsNative () as bool
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `runtimeIsNative` functionality within the `RuntimeHostContract` domain.

##### `op runtimeIsWasm`
```flux
op runtimeIsWasm () as bool
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `runtimeIsWasm` functionality within the `RuntimeHostContract` domain.

##### `op runtimeIsInterpreter`
```flux
op runtimeIsInterpreter () as bool
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `runtimeIsInterpreter` functionality within the `RuntimeHostContract` domain.

##### `op runtimePointerSize`
```flux
op runtimePointerSize () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `runtimePointerSize` functionality within the `RuntimeHostContract` domain.

##### `op runtimeCompilerVersion`
```flux
op runtimeCompilerVersion () as string
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `runtimeCompilerVersion` functionality within the `RuntimeHostContract` domain.

##### `op runtimeGetArgs`
```flux
op runtimeGetArgs () as list of data
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `runtimeGetArgs` functionality within the `RuntimeHostContract` domain.

##### `op runtimeGetArgCount`
```flux
op runtimeGetArgCount () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `runtimeGetArgCount` functionality within the `RuntimeHostContract` domain.

##### `op runtimeGetArg`
```flux
op runtimeGetArg (as int64: index) as string
```
- **Parameters**:
  - `index` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `runtimeGetArg` functionality within the `RuntimeHostContract` domain.

##### `op runtimeExecutablePath`
```flux
op runtimeExecutablePath () as string
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `runtimeExecutablePath` functionality within the `RuntimeHostContract` domain.

##### `op backend`
```flux
op backend () as string
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `backend` functionality within the `RuntimeHostContract` domain.

##### `op isNative`
```flux
op isNative () as bool
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `isNative` functionality within the `RuntimeHostContract` domain.

##### `op isWasm`
```flux
op isWasm () as bool
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `isWasm` functionality within the `RuntimeHostContract` domain.

##### `op isInterpreter`
```flux
op isInterpreter () as bool
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `isInterpreter` functionality within the `RuntimeHostContract` domain.

##### `op compilerVersion`
```flux
op compilerVersion () as string
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `compilerVersion` functionality within the `RuntimeHostContract` domain.

##### `op getArgs`
```flux
op getArgs () as list of data
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `getArgs` functionality within the `RuntimeHostContract` domain.

##### `op getArgCount`
```flux
op getArgCount () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `getArgCount` functionality within the `RuntimeHostContract` domain.

##### `op getArg`
```flux
op getArg (as int64: index) as string
```
- **Parameters**:
  - `index` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `getArg` functionality within the `RuntimeHostContract` domain.

### 4.3 Contract `RuntimeMemoryContract` (`RuntimeMemory.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `runtimeAllocatedMemory` | `op runtimeAllocatedMemory () as int64` | `int64` |
| `runtimeHeapSize` | `op runtimeHeapSize () as int64` | `int64` |
| `runtimePointerOf` | `op runtimePointerOf (as data: value) as int64` | `int64` |
| `allocatedMemory` | `op allocatedMemory () as int64` | `int64` |
| `heapSize` | `op heapSize () as int64` | `int64` |
| `pointerOf` | `op pointerOf (as data: value) as int64` | `int64` |

#### Operation Technical Specifications:

##### `op runtimeAllocatedMemory`
```flux
op runtimeAllocatedMemory () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `runtimeAllocatedMemory` functionality within the `RuntimeMemoryContract` domain.

##### `op runtimeHeapSize`
```flux
op runtimeHeapSize () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `runtimeHeapSize` functionality within the `RuntimeMemoryContract` domain.

##### `op runtimePointerOf`
```flux
op runtimePointerOf (as data: value) as int64
```
- **Parameters**:
  - `value` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `runtimePointerOf` functionality within the `RuntimeMemoryContract` domain.

##### `op allocatedMemory`
```flux
op allocatedMemory () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `allocatedMemory` functionality within the `RuntimeMemoryContract` domain.

##### `op heapSize`
```flux
op heapSize () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `heapSize` functionality within the `RuntimeMemoryContract` domain.

##### `op pointerOf`
```flux
op pointerOf (as data: value) as int64
```
- **Parameters**:
  - `value` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `pointerOf` functionality within the `RuntimeMemoryContract` domain.

### 4.4 Contract `RuntimeTypeContract` (`RuntimeType.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `runtimeGetTypeName` | `op runtimeGetTypeName (as data: value) as string` | `string` |
| `runtimeGetTypeId` | `op runtimeGetTypeId (as data: value) as int64` | `int64` |
| `runtimeIsPrimitive` | `op runtimeIsPrimitive (as data: value) as bool` | `bool` |
| `runtimeIsCollection` | `op runtimeIsCollection (as data: value) as bool` | `bool` |
| `runtimeIsStruct` | `op runtimeIsStruct (as data: value) as bool` | `bool` |
| `runtimeSizeOf` | `op runtimeSizeOf (as data: value) as int64` | `int64` |
| `runtimeGetStructMetadata` | `op runtimeGetStructMetadata (as string: struct_name) as map` | `map` |
| `getTypeName` | `op getTypeName (as data: value) as string` | `string` |
| `getTypeId` | `op getTypeId (as data: value) as int64` | `int64` |
| `isPrimitive` | `op isPrimitive (as data: value) as bool` | `bool` |
| `isCollection` | `op isCollection (as data: value) as bool` | `bool` |
| `isStruct` | `op isStruct (as data: value) as bool` | `bool` |
| `sizeOf` | `op sizeOf (as data: value) as int64` | `int64` |

#### Operation Technical Specifications:

##### `op runtimeGetTypeName`
```flux
op runtimeGetTypeName (as data: value) as string
```
- **Parameters**:
  - `value` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `runtimeGetTypeName` functionality within the `RuntimeTypeContract` domain.

##### `op runtimeGetTypeId`
```flux
op runtimeGetTypeId (as data: value) as int64
```
- **Parameters**:
  - `value` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `runtimeGetTypeId` functionality within the `RuntimeTypeContract` domain.

##### `op runtimeIsPrimitive`
```flux
op runtimeIsPrimitive (as data: value) as bool
```
- **Parameters**:
  - `value` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `runtimeIsPrimitive` functionality within the `RuntimeTypeContract` domain.

##### `op runtimeIsCollection`
```flux
op runtimeIsCollection (as data: value) as bool
```
- **Parameters**:
  - `value` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `runtimeIsCollection` functionality within the `RuntimeTypeContract` domain.

##### `op runtimeIsStruct`
```flux
op runtimeIsStruct (as data: value) as bool
```
- **Parameters**:
  - `value` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `runtimeIsStruct` functionality within the `RuntimeTypeContract` domain.

##### `op runtimeSizeOf`
```flux
op runtimeSizeOf (as data: value) as int64
```
- **Parameters**:
  - `value` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `runtimeSizeOf` functionality within the `RuntimeTypeContract` domain.

##### `op runtimeGetStructMetadata`
```flux
op runtimeGetStructMetadata (as string: struct_name) as map
```
- **Parameters**:
  - `struct_name` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `runtimeGetStructMetadata` functionality within the `RuntimeTypeContract` domain.

##### `op getTypeName`
```flux
op getTypeName (as data: value) as string
```
- **Parameters**:
  - `value` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `getTypeName` functionality within the `RuntimeTypeContract` domain.

##### `op getTypeId`
```flux
op getTypeId (as data: value) as int64
```
- **Parameters**:
  - `value` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `getTypeId` functionality within the `RuntimeTypeContract` domain.

##### `op isPrimitive`
```flux
op isPrimitive (as data: value) as bool
```
- **Parameters**:
  - `value` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `isPrimitive` functionality within the `RuntimeTypeContract` domain.

##### `op isCollection`
```flux
op isCollection (as data: value) as bool
```
- **Parameters**:
  - `value` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `isCollection` functionality within the `RuntimeTypeContract` domain.

##### `op isStruct`
```flux
op isStruct (as data: value) as bool
```
- **Parameters**:
  - `value` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `isStruct` functionality within the `RuntimeTypeContract` domain.

##### `op sizeOf`
```flux
op sizeOf (as data: value) as int64
```
- **Parameters**:
  - `value` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `sizeOf` functionality within the `RuntimeTypeContract` domain.

---

## 5. Canonical Usage Examples in TheFlux

The following snippet illustrates importing and utilizing the library in a TheFlux program:

```flux
# Canonical Usage Example for RuntimeStdLib
use RuntimeStdLib

program (ExampleOfRuntimeStdLib) {
      println("==================================================")
      println("  Standard Library Demonstration: RuntimeStdLib")
      println("==================================================")

      # Invoking canonical operation
      mut as data: result = RuntimeStdLib::runtimeVersion()
      println("Obtained result: " + result)

      println("Execution completed successfully.")
}
```

---

> [!TIP]
> For the complete unified architecture across all standard libraries, consult the master [StdLibs.md](../StdLibs.md) reference.
