# 📚 `ThreadStdLib` — Native Multithreading, Synchronization Primitives, and Message Channels

> **Architectural Pillar**: Pillar 4 (System, I/O & Network)  
> **Status**: ✅ Certified with 100% Parity across 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Master File**: `stdlib/ThreadStdLib/ThreadStdLib.fdsl`  
> **Import Mode**: `use ThreadStdLib` or `use ThreadStdLib::<Module>::<operation>`

---

## 1. Overview and Capabilities

The **`ThreadStdLib`** standard library is an integral component of the official TheFlux language ecosystem, providing certified system-level algorithms and robust capabilities.

Native concurrent and parallel execution primitives: thread lifecycle management (spawn/join), reentrant mutual exclusion locks (mutexes), condition variables, counting semaphores, and message-passing channels.

### 1.1 Key Architectural Principles and Design
- **Static Fusion and Zero-Overhead**: All domain modules are transparently fused into the `ThreadStdLib` unified agent at compile time, avoiding virtual dispatch penalties.
- **Safety and Isolation**: Operations strictly validate parameter bounds and guarantee predictable error semantics via contract definitions.
- **Universal Multi-Backend Parity**: Bit-for-bit identical execution guarantees across interpreter (`in`), bytecode VM (`vm`, `vmr`), native AOT LLVM (`llvm`), and WebAssembly (`wat`, `wasm`).

---

## 2. Modular Structure and Contracts

The library comprises **4 domain modules** declaring a total of **57 public operations**:

| Domain Source File | Formal Contract | Domain Responsibility | Ops Count |
|---|---|---|:---:|
| `ThreadChannel.fdsl` | `ThreadChannelContract` | Specialized domain for `ThreadChannel` | 17 |
| `ThreadLifecycle.fdsl` | `ThreadLifecycleContract` | Specialized domain for `ThreadLifecycle` | 9 |
| `ThreadSync.fdsl` | `ThreadSyncContract` | Specialized domain for `ThreadSync` | 24 |
| `ThreadSystem.fdsl` | `ThreadSystemContract` | Specialized domain for `ThreadSystem` | 7 |

---

## 3. Public Types, Structures, and Enumerations

The `ThreadStdLib` library operates directly on primitive native TheFlux types (`string`, `int64`, `float64`, `bool`, `list of data`, etc.) without requiring custom composite types.

---

## 4. Detailed Operations Catalog by Domain

### 4.1 Contract `ThreadChannelContract` (`ThreadChannel.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `channelCreate` | `op channelCreate () as map` | `map` |
| `channelCreateWithCapacity` | `op channelCreateWithCapacity (as int64: capacity) as map` | `map` |
| `channelSend` | `op channelSend (as data: port, as data: message) as bool` | `bool` |
| `channelRecv` | `op channelRecv (as data: port) as data` | `data` |
| `channelTrySend` | `op channelTrySend (as data: port, as data: message) as bool` | `bool` |
| `channelTryRecv` | `op channelTryRecv (as data: port) as map` | `map` |
| `channelClose` | `op channelClose (as data: port) as bool` | `bool` |
| `channelIsClosed` | `op channelIsClosed (as data: port) as bool` | `bool` |
| `channelIsEmpty` | `op channelIsEmpty (as data: port) as bool` | `bool` |
| `channelLength` | `op channelLength (as data: port) as int64` | `int64` |
| `channelCapacity` | `op channelCapacity (as data: port) as int64` | `int64` |
| `chanCreate` | `op chanCreate () as map` | `map` |
| `chanSend` | `op chanSend (as data: port, as data: message) as bool` | `bool` |
| `chanRecv` | `op chanRecv (as data: port) as data` | `data` |
| `chanClose` | `op chanClose (as data: port) as bool` | `bool` |
| `chanLen` | `op chanLen (as data: port) as int64` | `int64` |
| `chanCap` | `op chanCap (as data: port) as int64` | `int64` |

#### Operation Technical Specifications:

##### `op channelCreate`
```flux
op channelCreate () as map
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `channelCreate` functionality within the `ThreadChannelContract` domain.

##### `op channelCreateWithCapacity`
```flux
op channelCreateWithCapacity (as int64: capacity) as map
```
- **Parameters**:
  - `capacity` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `channelCreateWithCapacity` functionality within the `ThreadChannelContract` domain.

##### `op channelSend`
```flux
op channelSend (as data: port, as data: message) as bool
```
- **Parameters**:
  - `port` (`data`): Input argument for operation execution.
  - `message` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `channelSend` functionality within the `ThreadChannelContract` domain.

##### `op channelRecv`
```flux
op channelRecv (as data: port) as data
```
- **Parameters**:
  - `port` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `channelRecv` functionality within the `ThreadChannelContract` domain.

##### `op channelTrySend`
```flux
op channelTrySend (as data: port, as data: message) as bool
```
- **Parameters**:
  - `port` (`data`): Input argument for operation execution.
  - `message` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `channelTrySend` functionality within the `ThreadChannelContract` domain.

##### `op channelTryRecv`
```flux
op channelTryRecv (as data: port) as map
```
- **Parameters**:
  - `port` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `channelTryRecv` functionality within the `ThreadChannelContract` domain.

##### `op channelClose`
```flux
op channelClose (as data: port) as bool
```
- **Parameters**:
  - `port` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `channelClose` functionality within the `ThreadChannelContract` domain.

##### `op channelIsClosed`
```flux
op channelIsClosed (as data: port) as bool
```
- **Parameters**:
  - `port` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `channelIsClosed` functionality within the `ThreadChannelContract` domain.

##### `op channelIsEmpty`
```flux
op channelIsEmpty (as data: port) as bool
```
- **Parameters**:
  - `port` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `channelIsEmpty` functionality within the `ThreadChannelContract` domain.

##### `op channelLength`
```flux
op channelLength (as data: port) as int64
```
- **Parameters**:
  - `port` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `channelLength` functionality within the `ThreadChannelContract` domain.

##### `op channelCapacity`
```flux
op channelCapacity (as data: port) as int64
```
- **Parameters**:
  - `port` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `channelCapacity` functionality within the `ThreadChannelContract` domain.

##### `op chanCreate`
```flux
op chanCreate () as map
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `chanCreate` functionality within the `ThreadChannelContract` domain.

##### `op chanSend`
```flux
op chanSend (as data: port, as data: message) as bool
```
- **Parameters**:
  - `port` (`data`): Input argument for operation execution.
  - `message` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `chanSend` functionality within the `ThreadChannelContract` domain.

##### `op chanRecv`
```flux
op chanRecv (as data: port) as data
```
- **Parameters**:
  - `port` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `chanRecv` functionality within the `ThreadChannelContract` domain.

##### `op chanClose`
```flux
op chanClose (as data: port) as bool
```
- **Parameters**:
  - `port` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `chanClose` functionality within the `ThreadChannelContract` domain.

##### `op chanLen`
```flux
op chanLen (as data: port) as int64
```
- **Parameters**:
  - `port` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `chanLen` functionality within the `ThreadChannelContract` domain.

##### `op chanCap`
```flux
op chanCap (as data: port) as int64
```
- **Parameters**:
  - `port` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `chanCap` functionality within the `ThreadChannelContract` domain.

### 4.2 Contract `ThreadLifecycleContract` (`ThreadLifecycle.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `threadSpawn` | `op threadSpawn (as string: agent_name, as string: op_name, as data: payload) as int64` | `int64` |
| `threadJoin` | `op threadJoin (as int64: thread_id) as data` | `data` |
| `threadIsAlive` | `op threadIsAlive (as int64: thread_id) as bool` | `bool` |
| `threadCurrentId` | `op threadCurrentId () as int64` | `int64` |
| `threadDetach` | `op threadDetach (as int64: thread_id) as bool` | `bool` |
| `spawnTask` | `op spawnTask (as string: agent_name, as string: op_name, as data: payload) as int64` | `int64` |
| `joinTask` | `op joinTask (as int64: thread_id) as data` | `data` |
| `isAlive` | `op isAlive (as int64: thread_id) as bool` | `bool` |
| `currentThreadId` | `op currentThreadId () as int64` | `int64` |

#### Operation Technical Specifications:

##### `op threadSpawn`
```flux
op threadSpawn (as string: agent_name, as string: op_name, as data: payload) as int64
```
- **Parameters**:
  - `agent_name` (`string`): Input argument for operation execution.
  - `op_name` (`string`): Input argument for operation execution.
  - `payload` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `threadSpawn` functionality within the `ThreadLifecycleContract` domain.

##### `op threadJoin`
```flux
op threadJoin (as int64: thread_id) as data
```
- **Parameters**:
  - `thread_id` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `threadJoin` functionality within the `ThreadLifecycleContract` domain.

##### `op threadIsAlive`
```flux
op threadIsAlive (as int64: thread_id) as bool
```
- **Parameters**:
  - `thread_id` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `threadIsAlive` functionality within the `ThreadLifecycleContract` domain.

##### `op threadCurrentId`
```flux
op threadCurrentId () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `threadCurrentId` functionality within the `ThreadLifecycleContract` domain.

##### `op threadDetach`
```flux
op threadDetach (as int64: thread_id) as bool
```
- **Parameters**:
  - `thread_id` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `threadDetach` functionality within the `ThreadLifecycleContract` domain.

##### `op spawnTask`
```flux
op spawnTask (as string: agent_name, as string: op_name, as data: payload) as int64
```
- **Parameters**:
  - `agent_name` (`string`): Input argument for operation execution.
  - `op_name` (`string`): Input argument for operation execution.
  - `payload` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `spawnTask` functionality within the `ThreadLifecycleContract` domain.

##### `op joinTask`
```flux
op joinTask (as int64: thread_id) as data
```
- **Parameters**:
  - `thread_id` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `joinTask` functionality within the `ThreadLifecycleContract` domain.

##### `op isAlive`
```flux
op isAlive (as int64: thread_id) as bool
```
- **Parameters**:
  - `thread_id` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `isAlive` functionality within the `ThreadLifecycleContract` domain.

##### `op currentThreadId`
```flux
op currentThreadId () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `currentThreadId` functionality within the `ThreadLifecycleContract` domain.

### 4.3 Contract `ThreadSyncContract` (`ThreadSync.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `mutexCreate` | `op mutexCreate () as int64` | `int64` |
| `mutexLock` | `op mutexLock (as int64: mutex_id) as bool` | `bool` |
| `mutexUnlock` | `op mutexUnlock (as int64: mutex_id) as bool` | `bool` |
| `mutexTryLock` | `op mutexTryLock (as int64: mutex_id) as bool` | `bool` |
| `mutexDestroy` | `op mutexDestroy (as int64: mutex_id) as bool` | `bool` |
| `atomicCreate` | `op atomicCreate (as int64: initial_value) as int64` | `int64` |
| `atomicGet` | `op atomicGet (as int64: atomic_id) as int64` | `int64` |
| `atomicSet` | `op atomicSet (as int64: atomic_id, as int64: value) as bool` | `bool` |
| `atomicAdd` | `op atomicAdd (as int64: atomic_id, as int64: delta) as int64` | `int64` |
| `atomicCas` | `op atomicCas (as int64: atomic_id, as int64: expected, as int64: desired) as bool` | `bool` |
| `atomicDestroy` | `op atomicDestroy (as int64: atomic_id) as bool` | `bool` |
| `waitGroupCreate` | `op waitGroupCreate () as int64` | `int64` |
| `waitGroupAdd` | `op waitGroupAdd (as int64: wg_id, as int64: delta) as bool` | `bool` |
| `waitGroupDone` | `op waitGroupDone (as int64: wg_id) as bool` | `bool` |
| `waitGroupWait` | `op waitGroupWait (as int64: wg_id) as bool` | `bool` |
| `waitGroupDestroy` | `op waitGroupDestroy (as int64: wg_id) as bool` | `bool` |
| `lock` | `op lock (as int64: mutex_id) as bool` | `bool` |
| `unlock` | `op unlock (as int64: mutex_id) as bool` | `bool` |
| `tryLock` | `op tryLock (as int64: mutex_id) as bool` | `bool` |
| `atomicLoad` | `op atomicLoad (as int64: atomic_id) as int64` | `int64` |
| `atomicStore` | `op atomicStore (as int64: atomic_id, as int64: value) as bool` | `bool` |
| `wgAdd` | `op wgAdd (as int64: wg_id, as int64: delta) as bool` | `bool` |
| `wgDone` | `op wgDone (as int64: wg_id) as bool` | `bool` |
| `wgWait` | `op wgWait (as int64: wg_id) as bool` | `bool` |

#### Operation Technical Specifications:

##### `op mutexCreate`
```flux
op mutexCreate () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mutexCreate` functionality within the `ThreadSyncContract` domain.

##### `op mutexLock`
```flux
op mutexLock (as int64: mutex_id) as bool
```
- **Parameters**:
  - `mutex_id` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mutexLock` functionality within the `ThreadSyncContract` domain.

##### `op mutexUnlock`
```flux
op mutexUnlock (as int64: mutex_id) as bool
```
- **Parameters**:
  - `mutex_id` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mutexUnlock` functionality within the `ThreadSyncContract` domain.

##### `op mutexTryLock`
```flux
op mutexTryLock (as int64: mutex_id) as bool
```
- **Parameters**:
  - `mutex_id` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mutexTryLock` functionality within the `ThreadSyncContract` domain.

##### `op mutexDestroy`
```flux
op mutexDestroy (as int64: mutex_id) as bool
```
- **Parameters**:
  - `mutex_id` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mutexDestroy` functionality within the `ThreadSyncContract` domain.

##### `op atomicCreate`
```flux
op atomicCreate (as int64: initial_value) as int64
```
- **Parameters**:
  - `initial_value` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `atomicCreate` functionality within the `ThreadSyncContract` domain.

##### `op atomicGet`
```flux
op atomicGet (as int64: atomic_id) as int64
```
- **Parameters**:
  - `atomic_id` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `atomicGet` functionality within the `ThreadSyncContract` domain.

##### `op atomicSet`
```flux
op atomicSet (as int64: atomic_id, as int64: value) as bool
```
- **Parameters**:
  - `atomic_id` (`int64`): Input argument for operation execution.
  - `value` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `atomicSet` functionality within the `ThreadSyncContract` domain.

##### `op atomicAdd`
```flux
op atomicAdd (as int64: atomic_id, as int64: delta) as int64
```
- **Parameters**:
  - `atomic_id` (`int64`): Input argument for operation execution.
  - `delta` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `atomicAdd` functionality within the `ThreadSyncContract` domain.

##### `op atomicCas`
```flux
op atomicCas (as int64: atomic_id, as int64: expected, as int64: desired) as bool
```
- **Parameters**:
  - `atomic_id` (`int64`): Input argument for operation execution.
  - `expected` (`int64`): Input argument for operation execution.
  - `desired` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `atomicCas` functionality within the `ThreadSyncContract` domain.

##### `op atomicDestroy`
```flux
op atomicDestroy (as int64: atomic_id) as bool
```
- **Parameters**:
  - `atomic_id` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `atomicDestroy` functionality within the `ThreadSyncContract` domain.

##### `op waitGroupCreate`
```flux
op waitGroupCreate () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `waitGroupCreate` functionality within the `ThreadSyncContract` domain.

##### `op waitGroupAdd`
```flux
op waitGroupAdd (as int64: wg_id, as int64: delta) as bool
```
- **Parameters**:
  - `wg_id` (`int64`): Input argument for operation execution.
  - `delta` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `waitGroupAdd` functionality within the `ThreadSyncContract` domain.

##### `op waitGroupDone`
```flux
op waitGroupDone (as int64: wg_id) as bool
```
- **Parameters**:
  - `wg_id` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `waitGroupDone` functionality within the `ThreadSyncContract` domain.

##### `op waitGroupWait`
```flux
op waitGroupWait (as int64: wg_id) as bool
```
- **Parameters**:
  - `wg_id` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `waitGroupWait` functionality within the `ThreadSyncContract` domain.

##### `op waitGroupDestroy`
```flux
op waitGroupDestroy (as int64: wg_id) as bool
```
- **Parameters**:
  - `wg_id` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `waitGroupDestroy` functionality within the `ThreadSyncContract` domain.

##### `op lock`
```flux
op lock (as int64: mutex_id) as bool
```
- **Parameters**:
  - `mutex_id` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lock` functionality within the `ThreadSyncContract` domain.

##### `op unlock`
```flux
op unlock (as int64: mutex_id) as bool
```
- **Parameters**:
  - `mutex_id` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `unlock` functionality within the `ThreadSyncContract` domain.

##### `op tryLock`
```flux
op tryLock (as int64: mutex_id) as bool
```
- **Parameters**:
  - `mutex_id` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `tryLock` functionality within the `ThreadSyncContract` domain.

##### `op atomicLoad`
```flux
op atomicLoad (as int64: atomic_id) as int64
```
- **Parameters**:
  - `atomic_id` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `atomicLoad` functionality within the `ThreadSyncContract` domain.

##### `op atomicStore`
```flux
op atomicStore (as int64: atomic_id, as int64: value) as bool
```
- **Parameters**:
  - `atomic_id` (`int64`): Input argument for operation execution.
  - `value` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `atomicStore` functionality within the `ThreadSyncContract` domain.

##### `op wgAdd`
```flux
op wgAdd (as int64: wg_id, as int64: delta) as bool
```
- **Parameters**:
  - `wg_id` (`int64`): Input argument for operation execution.
  - `delta` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `wgAdd` functionality within the `ThreadSyncContract` domain.

##### `op wgDone`
```flux
op wgDone (as int64: wg_id) as bool
```
- **Parameters**:
  - `wg_id` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `wgDone` functionality within the `ThreadSyncContract` domain.

##### `op wgWait`
```flux
op wgWait (as int64: wg_id) as bool
```
- **Parameters**:
  - `wg_id` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `wgWait` functionality within the `ThreadSyncContract` domain.

### 4.4 Contract `ThreadSystemContract` (`ThreadSystem.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `threadHardwareConcurrency` | `op threadHardwareConcurrency () as int64` | `int64` |
| `threadSleep` | `op threadSleep (as int64: milliseconds) as bool` | `bool` |
| `threadSleepMs` | `op threadSleepMs (as int64: milliseconds) as bool` | `bool` |
| `threadYield` | `op threadYield () as bool` | `bool` |
| `hardwareConcurrency` | `op hardwareConcurrency () as int64` | `int64` |
| `sleepMs` | `op sleepMs (as int64: milliseconds) as bool` | `bool` |
| `yield` | `op yield () as bool` | `bool` |

#### Operation Technical Specifications:

##### `op threadHardwareConcurrency`
```flux
op threadHardwareConcurrency () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `threadHardwareConcurrency` functionality within the `ThreadSystemContract` domain.

##### `op threadSleep`
```flux
op threadSleep (as int64: milliseconds) as bool
```
- **Parameters**:
  - `milliseconds` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `threadSleep` functionality within the `ThreadSystemContract` domain.

##### `op threadSleepMs`
```flux
op threadSleepMs (as int64: milliseconds) as bool
```
- **Parameters**:
  - `milliseconds` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `threadSleepMs` functionality within the `ThreadSystemContract` domain.

##### `op threadYield`
```flux
op threadYield () as bool
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `threadYield` functionality within the `ThreadSystemContract` domain.

##### `op hardwareConcurrency`
```flux
op hardwareConcurrency () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `hardwareConcurrency` functionality within the `ThreadSystemContract` domain.

##### `op sleepMs`
```flux
op sleepMs (as int64: milliseconds) as bool
```
- **Parameters**:
  - `milliseconds` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `sleepMs` functionality within the `ThreadSystemContract` domain.

##### `op yield`
```flux
op yield () as bool
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `yield` functionality within the `ThreadSystemContract` domain.

---

## 5. Canonical Usage Examples in TheFlux

The following snippet illustrates importing and utilizing the library in a TheFlux program:

```flux
# Canonical Usage Example for ThreadStdLib
use ThreadStdLib

program (ExampleOfThreadStdLib) {
      println("==================================================")
      println("  Standard Library Demonstration: ThreadStdLib")
      println("==================================================")

      # Invoking canonical operation
      mut as data: result = ThreadStdLib::threadCurrentId()
      println("Obtained result: " + result)

      println("Execution completed successfully.")
}
```

---

> [!TIP]
> For the complete unified architecture across all standard libraries, consult the master [StdLibs.md](../StdLibs.md) reference.
