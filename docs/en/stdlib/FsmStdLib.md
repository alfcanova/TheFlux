# 📚 `FsmStdLib` — Deterministic Finite State Machines (FSM) and Audit Logging

> **Architectural Pillar**: Pillar 2 (Structures & State)  
> **Status**: ✅ Certified with 100% Parity across 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Master File**: `stdlib/FsmStdLib/FsmStdLib.fdsl`  
> **Import Mode**: `use FsmStdLib` or `use FsmStdLib::<Module>::<operation>`

---

## 1. Overview and Capabilities

The **`FsmStdLib`** standard library is an integral component of the official TheFlux language ecosystem, providing certified system-level algorithms and robust capabilities.

Declarative finite state machine modeling engine: formal state/event definitions, transition guards, step-by-step deterministic progression, persistent audit trail logs, and Graphviz DOT visualization export.

### 1.1 Key Architectural Principles and Design
- **Static Fusion and Zero-Overhead**: All domain modules are transparently fused into the `FsmStdLib` unified agent at compile time, avoiding virtual dispatch penalties.
- **Safety and Isolation**: Operations strictly validate parameter bounds and guarantee predictable error semantics via contract definitions.
- **Universal Multi-Backend Parity**: Bit-for-bit identical execution guarantees across interpreter (`in`), bytecode VM (`vm`, `vmr`), native AOT LLVM (`llvm`), and WebAssembly (`wat`, `wasm`).

---

## 2. Modular Structure and Contracts

The library comprises **5 domain modules** declaring a total of **22 public operations**:

| Domain Source File | Formal Contract | Domain Responsibility | Ops Count |
|---|---|---|:---:|
| `FsmAudit.fdsl` | `FsmAuditContract` | Specialized domain for `FsmAudit` | 4 |
| `FsmDefinition.fdsl` | `FsmDefinitionContract` | Specialized domain for `FsmDefinition` | 6 |
| `FsmExecution.fdsl` | `FsmExecutionContract` | Specialized domain for `FsmExecution` | 2 |
| `FsmExport.fdsl` | `FsmExportContract` | Specialized domain for `FsmExport` | 1 |
| `FsmQuery.fdsl` | `FsmQueryContract` | Specialized domain for `FsmQuery` | 9 |

---

## 3. Public Types, Structures, and Enumerations

The `FsmStdLib` library operates directly on primitive native TheFlux types (`string`, `int64`, `float64`, `bool`, `list of data`, etc.) without requiring custom composite types.

---

## 4. Detailed Operations Catalog by Domain

### 4.1 Contract `FsmAuditContract` (`FsmAudit.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `fsmAuditTrail` | `op fsmAuditTrail (as list of data: history, as string: new_state) as list of data` | `list of data` |
| `fsmHistoryValidate` | `op fsmHistoryValidate (as map: fsm_instance, as list of data: history) as bool` | `bool` |
| `fsmHistoryLength` | `op fsmHistoryLength (as list of data: history) as int64` | `int64` |
| `fsmHistoryLast` | `op fsmHistoryLast (as list of data: history) as string` | `string` |

#### Operation Technical Specifications:

##### `op fsmAuditTrail`
```flux
op fsmAuditTrail (as list of data: history, as string: new_state) as list of data
```
- **Parameters**:
  - `history` (`list of data`): Input argument for operation execution.
  - `new_state` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `fsmAuditTrail` functionality within the `FsmAuditContract` domain.

##### `op fsmHistoryValidate`
```flux
op fsmHistoryValidate (as map: fsm_instance, as list of data: history) as bool
```
- **Parameters**:
  - `fsm_instance` (`map`): Input argument for operation execution.
  - `history` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `fsmHistoryValidate` functionality within the `FsmAuditContract` domain.

##### `op fsmHistoryLength`
```flux
op fsmHistoryLength (as list of data: history) as int64
```
- **Parameters**:
  - `history` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `fsmHistoryLength` functionality within the `FsmAuditContract` domain.

##### `op fsmHistoryLast`
```flux
op fsmHistoryLast (as list of data: history) as string
```
- **Parameters**:
  - `history` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `fsmHistoryLast` functionality within the `FsmAuditContract` domain.

### 4.2 Contract `FsmDefinitionContract` (`FsmDefinition.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `fsmCreate` | `op fsmCreate (as map: config) as map` | `map` |
| `fsmValidate` | `op fsmValidate (as map: fsm_instance) as bool` | `bool` |
| `fsmInitialState` | `op fsmInitialState (as map: fsm_instance) as string` | `string` |
| `fsmFinalStates` | `op fsmFinalStates (as map: fsm_instance) as list of data` | `list of data` |
| `fsmStates` | `op fsmStates (as map: fsm_instance) as list of data` | `list of data` |
| `fsmEvents` | `op fsmEvents (as map: fsm_instance) as list of data` | `list of data` |

#### Operation Technical Specifications:

##### `op fsmCreate`
```flux
op fsmCreate (as map: config) as map
```
- **Parameters**:
  - `config` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `fsmCreate` functionality within the `FsmDefinitionContract` domain.

##### `op fsmValidate`
```flux
op fsmValidate (as map: fsm_instance) as bool
```
- **Parameters**:
  - `fsm_instance` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
  - ⚠️ Emits `fail` with status message `"FSM estruturalmente invalida"`
- **Functional Description**:
  - Executes canonical `fsmValidate` functionality within the `FsmDefinitionContract` domain.

##### `op fsmInitialState`
```flux
op fsmInitialState (as map: fsm_instance) as string
```
- **Parameters**:
  - `fsm_instance` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `fsmInitialState` functionality within the `FsmDefinitionContract` domain.

##### `op fsmFinalStates`
```flux
op fsmFinalStates (as map: fsm_instance) as list of data
```
- **Parameters**:
  - `fsm_instance` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `fsmFinalStates` functionality within the `FsmDefinitionContract` domain.

##### `op fsmStates`
```flux
op fsmStates (as map: fsm_instance) as list of data
```
- **Parameters**:
  - `fsm_instance` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `fsmStates` functionality within the `FsmDefinitionContract` domain.

##### `op fsmEvents`
```flux
op fsmEvents (as map: fsm_instance) as list of data
```
- **Parameters**:
  - `fsm_instance` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `fsmEvents` functionality within the `FsmDefinitionContract` domain.

### 4.3 Contract `FsmExecutionContract` (`FsmExecution.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `fsmTransition` | `op fsmTransition (as map: fsm_instance, as string: current_state, as string: event_name) as string` | `string` |
| `fsmTryTransition` | `op fsmTryTransition (as map: fsm_instance, as string: current_state, as string: event_name) as list of data` | `list of data` |

#### Operation Technical Specifications:

##### `op fsmTransition`
```flux
op fsmTransition (as map: fsm_instance, as string: current_state, as string: event_name) as string
```
- **Parameters**:
  - `fsm_instance` (`map`): Input argument for operation execution.
  - `current_state` (`string`): Input argument for operation execution.
  - `event_name` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `fsmTransition` functionality within the `FsmExecutionContract` domain.

##### `op fsmTryTransition`
```flux
op fsmTryTransition (as map: fsm_instance, as string: current_state, as string: event_name) as list of data
```
- **Parameters**:
  - `fsm_instance` (`map`): Input argument for operation execution.
  - `current_state` (`string`): Input argument for operation execution.
  - `event_name` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `fsmTryTransition` functionality within the `FsmExecutionContract` domain.

### 4.4 Contract `FsmExportContract` (`FsmExport.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `fsmToMermaid` | `op fsmToMermaid (as map: fsm_instance) as string` | `string` |

#### Operation Technical Specifications:

##### `op fsmToMermaid`
```flux
op fsmToMermaid (as map: fsm_instance) as string
```
- **Parameters**:
  - `fsm_instance` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `fsmToMermaid` functionality within the `FsmExportContract` domain.

### 4.5 Contract `FsmQueryContract` (`FsmQuery.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `fsmHasState` | `op fsmHasState (as map: fsm_instance, as string: state) as bool` | `bool` |
| `fsmHasEvent` | `op fsmHasEvent (as map: fsm_instance, as string: event_name) as bool` | `bool` |
| `fsmIsInitial` | `op fsmIsInitial (as map: fsm_instance, as string: state) as bool` | `bool` |
| `fsmIsFinal` | `op fsmIsFinal (as map: fsm_instance, as string: state) as bool` | `bool` |
| `fsmCanTransition` | `op fsmCanTransition (as map: fsm_instance, as string: current_state, as string: event_name) as bool` | `bool` |
| `fsmNextState` | `op fsmNextState (as map: fsm_instance, as string: current_state, as string: event_name) as string` | `string` |
| `fsmAllowedEvents` | `op fsmAllowedEvents (as map: fsm_instance, as string: current_state) as list of data` | `list of data` |
| `fsmNextStates` | `op fsmNextStates (as map: fsm_instance, as string: current_state) as list of data` | `list of data` |
| `fsmIsReachable` | `op fsmIsReachable (as map: fsm_instance, as string: from_state, as string: to_state) as bool` | `bool` |

#### Operation Technical Specifications:

##### `op fsmHasState`
```flux
op fsmHasState (as map: fsm_instance, as string: state) as bool
```
- **Parameters**:
  - `fsm_instance` (`map`): Input argument for operation execution.
  - `state` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `fsmHasState` functionality within the `FsmQueryContract` domain.

##### `op fsmHasEvent`
```flux
op fsmHasEvent (as map: fsm_instance, as string: event_name) as bool
```
- **Parameters**:
  - `fsm_instance` (`map`): Input argument for operation execution.
  - `event_name` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `fsmHasEvent` functionality within the `FsmQueryContract` domain.

##### `op fsmIsInitial`
```flux
op fsmIsInitial (as map: fsm_instance, as string: state) as bool
```
- **Parameters**:
  - `fsm_instance` (`map`): Input argument for operation execution.
  - `state` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `fsmIsInitial` functionality within the `FsmQueryContract` domain.

##### `op fsmIsFinal`
```flux
op fsmIsFinal (as map: fsm_instance, as string: state) as bool
```
- **Parameters**:
  - `fsm_instance` (`map`): Input argument for operation execution.
  - `state` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `fsmIsFinal` functionality within the `FsmQueryContract` domain.

##### `op fsmCanTransition`
```flux
op fsmCanTransition (as map: fsm_instance, as string: current_state, as string: event_name) as bool
```
- **Parameters**:
  - `fsm_instance` (`map`): Input argument for operation execution.
  - `current_state` (`string`): Input argument for operation execution.
  - `event_name` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `fsmCanTransition` functionality within the `FsmQueryContract` domain.

##### `op fsmNextState`
```flux
op fsmNextState (as map: fsm_instance, as string: current_state, as string: event_name) as string
```
- **Parameters**:
  - `fsm_instance` (`map`): Input argument for operation execution.
  - `current_state` (`string`): Input argument for operation execution.
  - `event_name` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `fsmNextState` functionality within the `FsmQueryContract` domain.

##### `op fsmAllowedEvents`
```flux
op fsmAllowedEvents (as map: fsm_instance, as string: current_state) as list of data
```
- **Parameters**:
  - `fsm_instance` (`map`): Input argument for operation execution.
  - `current_state` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `fsmAllowedEvents` functionality within the `FsmQueryContract` domain.

##### `op fsmNextStates`
```flux
op fsmNextStates (as map: fsm_instance, as string: current_state) as list of data
```
- **Parameters**:
  - `fsm_instance` (`map`): Input argument for operation execution.
  - `current_state` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `fsmNextStates` functionality within the `FsmQueryContract` domain.

##### `op fsmIsReachable`
```flux
op fsmIsReachable (as map: fsm_instance, as string: from_state, as string: to_state) as bool
```
- **Parameters**:
  - `fsm_instance` (`map`): Input argument for operation execution.
  - `from_state` (`string`): Input argument for operation execution.
  - `to_state` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `fsmIsReachable` functionality within the `FsmQueryContract` domain.

---

## 5. Canonical Usage Examples in TheFlux

The following snippet illustrates importing and utilizing the library in a TheFlux program:

```flux
# Canonical Usage Example for FsmStdLib
use FsmStdLib

program (ExampleOfFsmStdLib) {
      println("==================================================")
      println("  Standard Library Demonstration: FsmStdLib")
      println("==================================================")

      # Invoking canonical operation
      mut as data: result = FsmStdLib::fsmCreate("OrderFSM")
      println("Obtained result: " + result)

      println("Execution completed successfully.")
}
```

---

> [!TIP]
> For the complete unified architecture across all standard libraries, consult the master [StdLibs.md](../StdLibs.md) reference.
