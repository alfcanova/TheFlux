# 📚 `NativeGfxStdLib` — Low-Level Native Graphics Acceleration and Window Management

> **Architectural Pillar**: Pillar 4 (System, I/O & Network)  
> **Status**: ✅ Certified with 100% Parity across 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Master File**: `stdlib/NativeGfxStdLib/NativeGfxStdLib.fdsl`  
> **Import Mode**: `use NativeGfxStdLib` or `use NativeGfxStdLib::<Module>::<operation>`

---

## 1. Overview and Capabilities

The **`NativeGfxStdLib`** standard library is an integral component of the official TheFlux language ecosystem, providing certified system-level algorithms and robust capabilities.

Direct interface to the host operating system display subsystem: creation and event management of native desktop windows, mouse/keyboard input capture, and low-latency raster drawing primitives.

### 1.1 Key Architectural Principles and Design
- **Static Fusion and Zero-Overhead**: All domain modules are transparently fused into the `NativeGfxStdLib` unified agent at compile time, avoiding virtual dispatch penalties.
- **Safety and Isolation**: Operations strictly validate parameter bounds and guarantee predictable error semantics via contract definitions.
- **Universal Multi-Backend Parity**: Bit-for-bit identical execution guarantees across interpreter (`in`), bytecode VM (`vm`, `vmr`), native AOT LLVM (`llvm`), and WebAssembly (`wat`, `wasm`).

---

## 2. Modular Structure and Contracts

The library comprises **3 domain modules** declaring a total of **32 public operations**:

| Domain Source File | Formal Contract | Domain Responsibility | Ops Count |
|---|---|---|:---:|
| `NativeGfxDraw.fdsl` | `NativeGfxDrawContract` | Specialized domain for `NativeGfxDraw` | 10 |
| `NativeGfxEvent.fdsl` | `NativeGfxEventContract` | Specialized domain for `NativeGfxEvent` | 8 |
| `NativeGfxWindow.fdsl` | `NativeGfxWindowContract` | Specialized domain for `NativeGfxWindow` | 14 |

---

## 3. Public Types, Structures, and Enumerations

The `NativeGfxStdLib` library operates directly on primitive native TheFlux types (`string`, `int64`, `float64`, `bool`, `list of data`, etc.) without requiring custom composite types.

---

## 4. Detailed Operations Catalog by Domain

### 4.1 Contract `NativeGfxDrawContract` (`NativeGfxDraw.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `nativeGfxClear` | `op nativeGfxClear (as int64: win_id, as int64: r, as int64: g, as int64: b) as bool` | `bool` |
| `nativeGfxFillRect` | `op nativeGfxFillRect (as int64: win_id, as int64: x, as int64: y, as int64: w, as int64: h, as int64: r, as int64: g, as int64: b) as bool` | `bool` |
| `nativeGfxDrawRect` | `op nativeGfxDrawRect (as int64: win_id, as int64: x, as int64: y, as int64: w, as int64: h, as int64: r, as int64: g, as int64: b) as bool` | `bool` |
| `nativeGfxDrawLine` | `op nativeGfxDrawLine (as int64: win_id, as int64: x1, as int64: y1, as int64: x2, as int64: y2, as int64: r, as int64: g, as int64: b) as bool` | `bool` |
| `nativeGfxDrawCircle` | `op nativeGfxDrawCircle (as int64: win_id, as int64: cx, as int64: cy, as int64: radius, as int64: r, as int64: g, as int64: b) as bool` | `bool` |
| `nativeGfxFillCircle` | `op nativeGfxFillCircle (as int64: win_id, as int64: cx, as int64: cy, as int64: radius, as int64: r, as int64: g, as int64: b) as bool` | `bool` |
| `nativeGfxDrawText` | `op nativeGfxDrawText (as int64: win_id, as int64: x, as int64: y, as string: text, as int64: r, as int64: g, as int64: b) as bool` | `bool` |
| `gfxClear` | `op gfxClear (as int64: win_id, as int64: r, as int64: g, as int64: b) as bool` | `bool` |
| `gfxFillRect` | `op gfxFillRect (as int64: win_id, as int64: x, as int64: y, as int64: w, as int64: h, as int64: r, as int64: g, as int64: b) as bool` | `bool` |
| `gfxFillCircle` | `op gfxFillCircle (as int64: win_id, as int64: cx, as int64: cy, as int64: radius, as int64: r, as int64: g, as int64: b) as bool` | `bool` |

#### Operation Technical Specifications:

##### `op nativeGfxClear`
```flux
op nativeGfxClear (as int64: win_id, as int64: r, as int64: g, as int64: b) as bool
```
- **Parameters**:
  - `win_id` (`int64`): Input argument for operation execution.
  - `r` (`int64`): Input argument for operation execution.
  - `g` (`int64`): Input argument for operation execution.
  - `b` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `nativeGfxClear` functionality within the `NativeGfxDrawContract` domain.

##### `op nativeGfxFillRect`
```flux
op nativeGfxFillRect (as int64: win_id, as int64: x, as int64: y, as int64: w, as int64: h, as int64: r, as int64: g, as int64: b) as bool
```
- **Parameters**:
  - `win_id` (`int64`): Input argument for operation execution.
  - `x` (`int64`): Input argument for operation execution.
  - `y` (`int64`): Input argument for operation execution.
  - `w` (`int64`): Input argument for operation execution.
  - `h` (`int64`): Input argument for operation execution.
  - `r` (`int64`): Input argument for operation execution.
  - `g` (`int64`): Input argument for operation execution.
  - `b` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `nativeGfxFillRect` functionality within the `NativeGfxDrawContract` domain.

##### `op nativeGfxDrawRect`
```flux
op nativeGfxDrawRect (as int64: win_id, as int64: x, as int64: y, as int64: w, as int64: h, as int64: r, as int64: g, as int64: b) as bool
```
- **Parameters**:
  - `win_id` (`int64`): Input argument for operation execution.
  - `x` (`int64`): Input argument for operation execution.
  - `y` (`int64`): Input argument for operation execution.
  - `w` (`int64`): Input argument for operation execution.
  - `h` (`int64`): Input argument for operation execution.
  - `r` (`int64`): Input argument for operation execution.
  - `g` (`int64`): Input argument for operation execution.
  - `b` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `nativeGfxDrawRect` functionality within the `NativeGfxDrawContract` domain.

##### `op nativeGfxDrawLine`
```flux
op nativeGfxDrawLine (as int64: win_id, as int64: x1, as int64: y1, as int64: x2, as int64: y2, as int64: r, as int64: g, as int64: b) as bool
```
- **Parameters**:
  - `win_id` (`int64`): Input argument for operation execution.
  - `x1` (`int64`): Input argument for operation execution.
  - `y1` (`int64`): Input argument for operation execution.
  - `x2` (`int64`): Input argument for operation execution.
  - `y2` (`int64`): Input argument for operation execution.
  - `r` (`int64`): Input argument for operation execution.
  - `g` (`int64`): Input argument for operation execution.
  - `b` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `nativeGfxDrawLine` functionality within the `NativeGfxDrawContract` domain.

##### `op nativeGfxDrawCircle`
```flux
op nativeGfxDrawCircle (as int64: win_id, as int64: cx, as int64: cy, as int64: radius, as int64: r, as int64: g, as int64: b) as bool
```
- **Parameters**:
  - `win_id` (`int64`): Input argument for operation execution.
  - `cx` (`int64`): Input argument for operation execution.
  - `cy` (`int64`): Input argument for operation execution.
  - `radius` (`int64`): Input argument for operation execution.
  - `r` (`int64`): Input argument for operation execution.
  - `g` (`int64`): Input argument for operation execution.
  - `b` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `nativeGfxDrawCircle` functionality within the `NativeGfxDrawContract` domain.

##### `op nativeGfxFillCircle`
```flux
op nativeGfxFillCircle (as int64: win_id, as int64: cx, as int64: cy, as int64: radius, as int64: r, as int64: g, as int64: b) as bool
```
- **Parameters**:
  - `win_id` (`int64`): Input argument for operation execution.
  - `cx` (`int64`): Input argument for operation execution.
  - `cy` (`int64`): Input argument for operation execution.
  - `radius` (`int64`): Input argument for operation execution.
  - `r` (`int64`): Input argument for operation execution.
  - `g` (`int64`): Input argument for operation execution.
  - `b` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `nativeGfxFillCircle` functionality within the `NativeGfxDrawContract` domain.

##### `op nativeGfxDrawText`
```flux
op nativeGfxDrawText (as int64: win_id, as int64: x, as int64: y, as string: text, as int64: r, as int64: g, as int64: b) as bool
```
- **Parameters**:
  - `win_id` (`int64`): Input argument for operation execution.
  - `x` (`int64`): Input argument for operation execution.
  - `y` (`int64`): Input argument for operation execution.
  - `text` (`string`): Input argument for operation execution.
  - `r` (`int64`): Input argument for operation execution.
  - `g` (`int64`): Input argument for operation execution.
  - `b` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `nativeGfxDrawText` functionality within the `NativeGfxDrawContract` domain.

##### `op gfxClear`
```flux
op gfxClear (as int64: win_id, as int64: r, as int64: g, as int64: b) as bool
```
- **Parameters**:
  - `win_id` (`int64`): Input argument for operation execution.
  - `r` (`int64`): Input argument for operation execution.
  - `g` (`int64`): Input argument for operation execution.
  - `b` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxClear` functionality within the `NativeGfxDrawContract` domain.

##### `op gfxFillRect`
```flux
op gfxFillRect (as int64: win_id, as int64: x, as int64: y, as int64: w, as int64: h, as int64: r, as int64: g, as int64: b) as bool
```
- **Parameters**:
  - `win_id` (`int64`): Input argument for operation execution.
  - `x` (`int64`): Input argument for operation execution.
  - `y` (`int64`): Input argument for operation execution.
  - `w` (`int64`): Input argument for operation execution.
  - `h` (`int64`): Input argument for operation execution.
  - `r` (`int64`): Input argument for operation execution.
  - `g` (`int64`): Input argument for operation execution.
  - `b` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxFillRect` functionality within the `NativeGfxDrawContract` domain.

##### `op gfxFillCircle`
```flux
op gfxFillCircle (as int64: win_id, as int64: cx, as int64: cy, as int64: radius, as int64: r, as int64: g, as int64: b) as bool
```
- **Parameters**:
  - `win_id` (`int64`): Input argument for operation execution.
  - `cx` (`int64`): Input argument for operation execution.
  - `cy` (`int64`): Input argument for operation execution.
  - `radius` (`int64`): Input argument for operation execution.
  - `r` (`int64`): Input argument for operation execution.
  - `g` (`int64`): Input argument for operation execution.
  - `b` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxFillCircle` functionality within the `NativeGfxDrawContract` domain.

### 4.2 Contract `NativeGfxEventContract` (`NativeGfxEvent.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `gfxEventPoll` | `op gfxEventPoll (as int64: win_id) as int64` | `int64` |
| `gfxEventX` | `op gfxEventX () as int64` | `int64` |
| `gfxEventY` | `op gfxEventY () as int64` | `int64` |
| `gfxEventKey` | `op gfxEventKey () as int64` | `int64` |
| `nativeGfxEventPoll` | `op nativeGfxEventPoll (as int64: win_id) as int64` | `int64` |
| `nativeGfxEventX` | `op nativeGfxEventX () as int64` | `int64` |
| `nativeGfxEventY` | `op nativeGfxEventY () as int64` | `int64` |
| `nativeGfxEventKey` | `op nativeGfxEventKey () as int64` | `int64` |

#### Operation Technical Specifications:

##### `op gfxEventPoll`
```flux
op gfxEventPoll (as int64: win_id) as int64
```
- **Parameters**:
  - `win_id` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxEventPoll` functionality within the `NativeGfxEventContract` domain.

##### `op gfxEventX`
```flux
op gfxEventX () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxEventX` functionality within the `NativeGfxEventContract` domain.

##### `op gfxEventY`
```flux
op gfxEventY () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxEventY` functionality within the `NativeGfxEventContract` domain.

##### `op gfxEventKey`
```flux
op gfxEventKey () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxEventKey` functionality within the `NativeGfxEventContract` domain.

##### `op nativeGfxEventPoll`
```flux
op nativeGfxEventPoll (as int64: win_id) as int64
```
- **Parameters**:
  - `win_id` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `nativeGfxEventPoll` functionality within the `NativeGfxEventContract` domain.

##### `op nativeGfxEventX`
```flux
op nativeGfxEventX () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `nativeGfxEventX` functionality within the `NativeGfxEventContract` domain.

##### `op nativeGfxEventY`
```flux
op nativeGfxEventY () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `nativeGfxEventY` functionality within the `NativeGfxEventContract` domain.

##### `op nativeGfxEventKey`
```flux
op nativeGfxEventKey () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `nativeGfxEventKey` functionality within the `NativeGfxEventContract` domain.

### 4.3 Contract `NativeGfxWindowContract` (`NativeGfxWindow.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `gfxWindowCreate` | `op gfxWindowCreate (as int64: w, as int64: h, as string: title) as int64` | `int64` |
| `gfxWindowClose` | `op gfxWindowClose (as int64: win_id) as bool` | `bool` |
| `gfxWindowFlush` | `op gfxWindowFlush (as int64: win_id) as bool` | `bool` |
| `gfxWindowClosed` | `op gfxWindowClosed (as int64: win_id) as bool` | `bool` |
| `gfxWindowWidth` | `op gfxWindowWidth (as int64: win_id) as int64` | `int64` |
| `gfxWindowHeight` | `op gfxWindowHeight (as int64: win_id) as int64` | `int64` |
| `gfxWindowWait` | `op gfxWindowWait (as int64: win_id, as int64: ms) as bool` | `bool` |
| `nativeGfxWindowCreate` | `op nativeGfxWindowCreate (as int64: w, as int64: h, as string: title) as int64` | `int64` |
| `nativeGfxWindowClose` | `op nativeGfxWindowClose (as int64: win_id) as bool` | `bool` |
| `nativeGfxWindowFlush` | `op nativeGfxWindowFlush (as int64: win_id) as bool` | `bool` |
| `nativeGfxWindowClosed` | `op nativeGfxWindowClosed (as int64: win_id) as bool` | `bool` |
| `nativeGfxWindowWidth` | `op nativeGfxWindowWidth (as int64: win_id) as int64` | `int64` |
| `nativeGfxWindowHeight` | `op nativeGfxWindowHeight (as int64: win_id) as int64` | `int64` |
| `nativeGfxWindowWait` | `op nativeGfxWindowWait (as int64: win_id, as int64: ms) as bool` | `bool` |

#### Operation Technical Specifications:

##### `op gfxWindowCreate`
```flux
op gfxWindowCreate (as int64: w, as int64: h, as string: title) as int64
```
- **Parameters**:
  - `w` (`int64`): Input argument for operation execution.
  - `h` (`int64`): Input argument for operation execution.
  - `title` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxWindowCreate` functionality within the `NativeGfxWindowContract` domain.

##### `op gfxWindowClose`
```flux
op gfxWindowClose (as int64: win_id) as bool
```
- **Parameters**:
  - `win_id` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxWindowClose` functionality within the `NativeGfxWindowContract` domain.

##### `op gfxWindowFlush`
```flux
op gfxWindowFlush (as int64: win_id) as bool
```
- **Parameters**:
  - `win_id` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxWindowFlush` functionality within the `NativeGfxWindowContract` domain.

##### `op gfxWindowClosed`
```flux
op gfxWindowClosed (as int64: win_id) as bool
```
- **Parameters**:
  - `win_id` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxWindowClosed` functionality within the `NativeGfxWindowContract` domain.

##### `op gfxWindowWidth`
```flux
op gfxWindowWidth (as int64: win_id) as int64
```
- **Parameters**:
  - `win_id` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxWindowWidth` functionality within the `NativeGfxWindowContract` domain.

##### `op gfxWindowHeight`
```flux
op gfxWindowHeight (as int64: win_id) as int64
```
- **Parameters**:
  - `win_id` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxWindowHeight` functionality within the `NativeGfxWindowContract` domain.

##### `op gfxWindowWait`
```flux
op gfxWindowWait (as int64: win_id, as int64: ms) as bool
```
- **Parameters**:
  - `win_id` (`int64`): Input argument for operation execution.
  - `ms` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxWindowWait` functionality within the `NativeGfxWindowContract` domain.

##### `op nativeGfxWindowCreate`
```flux
op nativeGfxWindowCreate (as int64: w, as int64: h, as string: title) as int64
```
- **Parameters**:
  - `w` (`int64`): Input argument for operation execution.
  - `h` (`int64`): Input argument for operation execution.
  - `title` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `nativeGfxWindowCreate` functionality within the `NativeGfxWindowContract` domain.

##### `op nativeGfxWindowClose`
```flux
op nativeGfxWindowClose (as int64: win_id) as bool
```
- **Parameters**:
  - `win_id` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `nativeGfxWindowClose` functionality within the `NativeGfxWindowContract` domain.

##### `op nativeGfxWindowFlush`
```flux
op nativeGfxWindowFlush (as int64: win_id) as bool
```
- **Parameters**:
  - `win_id` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `nativeGfxWindowFlush` functionality within the `NativeGfxWindowContract` domain.

##### `op nativeGfxWindowClosed`
```flux
op nativeGfxWindowClosed (as int64: win_id) as bool
```
- **Parameters**:
  - `win_id` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `nativeGfxWindowClosed` functionality within the `NativeGfxWindowContract` domain.

##### `op nativeGfxWindowWidth`
```flux
op nativeGfxWindowWidth (as int64: win_id) as int64
```
- **Parameters**:
  - `win_id` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `nativeGfxWindowWidth` functionality within the `NativeGfxWindowContract` domain.

##### `op nativeGfxWindowHeight`
```flux
op nativeGfxWindowHeight (as int64: win_id) as int64
```
- **Parameters**:
  - `win_id` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `nativeGfxWindowHeight` functionality within the `NativeGfxWindowContract` domain.

##### `op nativeGfxWindowWait`
```flux
op nativeGfxWindowWait (as int64: win_id, as int64: ms) as bool
```
- **Parameters**:
  - `win_id` (`int64`): Input argument for operation execution.
  - `ms` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `nativeGfxWindowWait` functionality within the `NativeGfxWindowContract` domain.

---

## 5. Canonical Usage Examples in TheFlux

The following snippet illustrates importing and utilizing the library in a TheFlux program:

```flux
# Canonical Usage Example for NativeGfxStdLib
use NativeGfxStdLib

program (ExampleOfNativeGfxStdLib) {
      println("==================================================")
      println("  Standard Library Demonstration: NativeGfxStdLib")
      println("==================================================")

      # Invoking canonical operation
      mut as data: result = NativeGfxStdLib::nativeCreateWindow("TheFlux Window", 800, 600)
      println("Obtained result: " + result)

      println("Execution completed successfully.")
}
```

---

> [!TIP]
> For the complete unified architecture across all standard libraries, consult the master [StdLibs.md](../StdLibs.md) reference.
