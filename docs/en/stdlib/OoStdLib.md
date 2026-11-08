# 📚 `OoStdLib` — Object Orientation, Dynamic Dispatch, Introspection, and Lifecycles

> **Architectural Pillar**: Pillar 1 (Core, Text & OO)  
> **Status**: ✅ Certified with 100% Parity across 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Master File**: `stdlib/OoStdLib/OoStdLib.fdsl`  
> **Import Mode**: `use OoStdLib` or `use OoStdLib::<Module>::<operation>`

---

## 1. Overview and Capabilities

The **`OoStdLib`** standard library is an integral component of the official TheFlux language ecosystem, providing certified system-level algorithms and robust capabilities.

Object-oriented programming mechanisms within TheFlux: virtual method table (vtable) simulation, dynamic dispatch, runtime type introspection, safe downcasting, and instance lifecycle management.

### 1.1 Key Architectural Principles and Design
- **Static Fusion and Zero-Overhead**: All domain modules are transparently fused into the `OoStdLib` unified agent at compile time, avoiding virtual dispatch penalties.
- **Safety and Isolation**: Operations strictly validate parameter bounds and guarantee predictable error semantics via contract definitions.
- **Universal Multi-Backend Parity**: Bit-for-bit identical execution guarantees across interpreter (`in`), bytecode VM (`vm`, `vmr`), native AOT LLVM (`llvm`), and WebAssembly (`wat`, `wasm`).

---

## 2. Modular Structure and Contracts

The library comprises **5 domain modules** declaring a total of **26 public operations**:

| Domain Source File | Formal Contract | Domain Responsibility | Ops Count |
|---|---|---|:---:|
| `OOCasting.fdsl` | `OOCastingContract` | Specialized domain for `OOCasting` | 4 |
| `OODispatch.fdsl` | `OODispatchContract` | Specialized domain for `OODispatch` | 1 |
| `OOIntrospection.fdsl` | `OOIntrospectionContract` | Specialized domain for `OOIntrospection` | 9 |
| `OOLifecycle.fdsl` | `OOLifecycleContract` | Specialized domain for `OOLifecycle` | 4 |
| `OOValidation.fdsl` | `OOValidationContract` | Specialized domain for `OOValidation` | 8 |

---

## 3. Public Types, Structures, and Enumerations

The `OoStdLib` library operates directly on primitive native TheFlux types (`string`, `int64`, `float64`, `bool`, `list of data`, etc.) without requiring custom composite types.

---

## 4. Detailed Operations Catalog by Domain

### 4.1 Contract `OOCastingContract` (`OOCasting.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `ooCastToContract` | `op ooCastToContract (as data: struct_instance, as string: contract_name) as data` | `data` |
| `ooDowncast` | `op ooDowncast (as data: interface_object, as string: target_struct_name) as data` | `data` |
| `ooCanDowncast` | `op ooCanDowncast (as data: interface_object, as string: target_struct_name) as bool` | `bool` |
| `ooUnwrap` | `op ooUnwrap (as data: interface_object) as data` | `data` |

#### Operation Technical Specifications:

##### `op ooCastToContract`
```flux
op ooCastToContract (as data: struct_instance, as string: contract_name) as data
```
- **Parameters**:
  - `struct_instance` (`data`): Input argument for operation execution.
  - `contract_name` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `ooCastToContract` functionality within the `OOCastingContract` domain.

##### `op ooDowncast`
```flux
op ooDowncast (as data: interface_object, as string: target_struct_name) as data
```
- **Parameters**:
  - `interface_object` (`data`): Input argument for operation execution.
  - `target_struct_name` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `data`
  - ⚠️ Emits `fail` with status message `"Objeto polimorfico invalido ou descartado"`
  - ✅ Emits `nice` with status message `"Downcast realizado com sucesso"`
- **Functional Description**:
  - Executes canonical `ooDowncast` functionality within the `OOCastingContract` domain.

##### `op ooCanDowncast`
```flux
op ooCanDowncast (as data: interface_object, as string: target_struct_name) as bool
```
- **Parameters**:
  - `interface_object` (`data`): Input argument for operation execution.
  - `target_struct_name` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `ooCanDowncast` functionality within the `OOCastingContract` domain.

##### `op ooUnwrap`
```flux
op ooUnwrap (as data: interface_object) as data
```
- **Parameters**:
  - `interface_object` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `data`
  - ⚠️ Emits `fail` with status message `"Objeto polimorfico invalido ou descartado"`
  - ✅ Emits `nice` with status message `"Unwrap realizado com sucesso"`
- **Functional Description**:
  - Executes canonical `ooUnwrap` functionality within the `OOCastingContract` domain.

### 4.2 Contract `OODispatchContract` (`OODispatch.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `ooDispatch` | `op ooDispatch (as data: interface_object, as string: method_name, as list of data: args) as data` | `data` |

#### Operation Technical Specifications:

##### `op ooDispatch`
```flux
op ooDispatch (as data: interface_object, as string: method_name, as list of data: args) as data
```
- **Parameters**:
  - `interface_object` (`data`): Input argument for operation execution.
  - `method_name` (`string`): Input argument for operation execution.
  - `args` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `data`
  - ⚠️ Emits `fail` with status message `"Objeto polimorfico invalido para despacho"`
  - ✅ Emits `nice` with status message `"Despacho executado"`
- **Functional Description**:
  - Executes canonical `ooDispatch` functionality within the `OODispatchContract` domain.

### 4.3 Contract `OOIntrospectionContract` (`OOIntrospection.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `ooContractName` | `op ooContractName (as data: interface_object) as string` | `string` |
| `ooUnderlyingType` | `op ooUnderlyingType (as data: interface_object) as string` | `string` |
| `ooMethods` | `op ooMethods (as string: contract_or_struct_name) as list of data` | `list of data` |
| `ooMethodCount` | `op ooMethodCount (as string: contract_or_struct_name) as int64` | `int64` |
| `ooContracts` | `op ooContracts (as data: struct_instance) as list of data` | `list of data` |
| `ooContractCount` | `op ooContractCount (as data: struct_instance) as int64` | `int64` |
| `ooToMap` | `op ooToMap (as data: interface_object) as map` | `map` |
| `ooEntries` | `op ooEntries (as data: interface_object) as list of data` | `list of data` |
| `ooDiff` | `op ooDiff (as data: a, as data: b) as map` | `map` |

#### Operation Technical Specifications:

##### `op ooContractName`
```flux
op ooContractName (as data: interface_object) as string
```
- **Parameters**:
  - `interface_object` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `ooContractName` functionality within the `OOIntrospectionContract` domain.

##### `op ooUnderlyingType`
```flux
op ooUnderlyingType (as data: interface_object) as string
```
- **Parameters**:
  - `interface_object` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `ooUnderlyingType` functionality within the `OOIntrospectionContract` domain.

##### `op ooMethods`
```flux
op ooMethods (as string: contract_or_struct_name) as list of data
```
- **Parameters**:
  - `contract_or_struct_name` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `ooMethods` functionality within the `OOIntrospectionContract` domain.

##### `op ooMethodCount`
```flux
op ooMethodCount (as string: contract_or_struct_name) as int64
```
- **Parameters**:
  - `contract_or_struct_name` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `ooMethodCount` functionality within the `OOIntrospectionContract` domain.

##### `op ooContracts`
```flux
op ooContracts (as data: struct_instance) as list of data
```
- **Parameters**:
  - `struct_instance` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `ooContracts` functionality within the `OOIntrospectionContract` domain.

##### `op ooContractCount`
```flux
op ooContractCount (as data: struct_instance) as int64
```
- **Parameters**:
  - `struct_instance` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `ooContractCount` functionality within the `OOIntrospectionContract` domain.

##### `op ooToMap`
```flux
op ooToMap (as data: interface_object) as map
```
- **Parameters**:
  - `interface_object` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `ooToMap` functionality within the `OOIntrospectionContract` domain.

##### `op ooEntries`
```flux
op ooEntries (as data: interface_object) as list of data
```
- **Parameters**:
  - `interface_object` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `ooEntries` functionality within the `OOIntrospectionContract` domain.

##### `op ooDiff`
```flux
op ooDiff (as data: a, as data: b) as map
```
- **Parameters**:
  - `a` (`data`): Input argument for operation execution.
  - `b` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `ooDiff` functionality within the `OOIntrospectionContract` domain.

### 4.4 Contract `OOLifecycleContract` (`OOLifecycle.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `ooClone` | `op ooClone (as data: interface_object) as data` | `data` |
| `ooDispose` | `op ooDispose (as data: interface_object) as bool` | `bool` |
| `ooIsDisposed` | `op ooIsDisposed (as data: interface_object) as bool` | `bool` |
| `ooToString` | `op ooToString (as data: interface_object) as string` | `string` |

#### Operation Technical Specifications:

##### `op ooClone`
```flux
op ooClone (as data: interface_object) as data
```
- **Parameters**:
  - `interface_object` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `ooClone` functionality within the `OOLifecycleContract` domain.

##### `op ooDispose`
```flux
op ooDispose (as data: interface_object) as bool
```
- **Parameters**:
  - `interface_object` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"Objeto descartado com sucesso"`
- **Functional Description**:
  - Executes canonical `ooDispose` functionality within the `OOLifecycleContract` domain.

##### `op ooIsDisposed`
```flux
op ooIsDisposed (as data: interface_object) as bool
```
- **Parameters**:
  - `interface_object` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `ooIsDisposed` functionality within the `OOLifecycleContract` domain.

##### `op ooToString`
```flux
op ooToString (as data: interface_object) as string
```
- **Parameters**:
  - `interface_object` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `ooToString` functionality within the `OOLifecycleContract` domain.

### 4.5 Contract `OOValidationContract` (`OOValidation.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `ooImplements` | `op ooImplements (as data: struct_instance, as string: contract_name) as bool` | `bool` |
| `ooImplementsAll` | `op ooImplementsAll (as data: struct_instance, as list of data: contract_names) as bool` | `bool` |
| `ooHasMethod` | `op ooHasMethod (as data: target, as string: method_name) as bool` | `bool` |
| `ooIsInstance` | `op ooIsInstance (as data: target, as string: struct_name) as bool` | `bool` |
| `ooValidateContract` | `op ooValidateContract (as data: interface_object) as bool` | `bool` |
| `ooIsValid` | `op ooIsValid (as data: interface_object) as bool` | `bool` |
| `ooEquals` | `op ooEquals (as data: a, as data: b) as bool` | `bool` |
| `ooIsObject` | `op ooIsObject (as data: instance) as bool` | `bool` |

#### Operation Technical Specifications:

##### `op ooImplements`
```flux
op ooImplements (as data: struct_instance, as string: contract_name) as bool
```
- **Parameters**:
  - `struct_instance` (`data`): Input argument for operation execution.
  - `contract_name` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `ooImplements` functionality within the `OOValidationContract` domain.

##### `op ooImplementsAll`
```flux
op ooImplementsAll (as data: struct_instance, as list of data: contract_names) as bool
```
- **Parameters**:
  - `struct_instance` (`data`): Input argument for operation execution.
  - `contract_names` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `ooImplementsAll` functionality within the `OOValidationContract` domain.

##### `op ooHasMethod`
```flux
op ooHasMethod (as data: target, as string: method_name) as bool
```
- **Parameters**:
  - `target` (`data`): Input argument for operation execution.
  - `method_name` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `ooHasMethod` functionality within the `OOValidationContract` domain.

##### `op ooIsInstance`
```flux
op ooIsInstance (as data: target, as string: struct_name) as bool
```
- **Parameters**:
  - `target` (`data`): Input argument for operation execution.
  - `struct_name` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `ooIsInstance` functionality within the `OOValidationContract` domain.

##### `op ooValidateContract`
```flux
op ooValidateContract (as data: interface_object) as bool
```
- **Parameters**:
  - `interface_object` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `ooValidateContract` functionality within the `OOValidationContract` domain.

##### `op ooIsValid`
```flux
op ooIsValid (as data: interface_object) as bool
```
- **Parameters**:
  - `interface_object` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `ooIsValid` functionality within the `OOValidationContract` domain.

##### `op ooEquals`
```flux
op ooEquals (as data: a, as data: b) as bool
```
- **Parameters**:
  - `a` (`data`): Input argument for operation execution.
  - `b` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `ooEquals` functionality within the `OOValidationContract` domain.

##### `op ooIsObject`
```flux
op ooIsObject (as data: instance) as bool
```
- **Parameters**:
  - `instance` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `ooIsObject` functionality within the `OOValidationContract` domain.

---

## 5. Canonical Usage Examples in TheFlux

The following snippet illustrates importing and utilizing the library in a TheFlux program:

```flux
# Canonical Usage Example for OoStdLib
use OoStdLib

program (ExampleOfOoStdLib) {
      println("==================================================")
      println("  Standard Library Demonstration: OoStdLib")
      println("==================================================")

      # Invoking canonical operation
      mut as data: result = OoStdLib::ooTypeOf("object")
      println("Obtained result: " + result)

      println("Execution completed successfully.")
}
```

---

> [!TIP]
> For the complete unified architecture across all standard libraries, consult the master [StdLibs.md](../StdLibs.md) reference.
