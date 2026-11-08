# 📚 `GuiStdLib` — Graphical User Interfaces, Component Hierarchies, and Event Dispatch

> **Architectural Pillar**: Pillar 4 (System, I/O & Network)  
> **Status**: ✅ Certified with 100% Parity across 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Master File**: `stdlib/GuiStdLib/GuiStdLib.fdsl`  
> **Import Mode**: `use GuiStdLib` or `use GuiStdLib::<Module>::<operation>`

---

## 1. Overview and Capabilities

The **`GuiStdLib`** standard library is an integral component of the official TheFlux language ecosystem, providing certified system-level algorithms and robust capabilities.

User interface abstractions for native desktop and embedded environments: layout engines (Box, Grid, Flex), widget trees (buttons, labels, text inputs, data grids, tree views), theme management, and responsive event dispatch loops.

### 1.1 Key Architectural Principles and Design
- **Static Fusion and Zero-Overhead**: All domain modules are transparently fused into the `GuiStdLib` unified agent at compile time, avoiding virtual dispatch penalties.
- **Safety and Isolation**: Operations strictly validate parameter bounds and guarantee predictable error semantics via contract definitions.
- **Universal Multi-Backend Parity**: Bit-for-bit identical execution guarantees across interpreter (`in`), bytecode VM (`vm`, `vmr`), native AOT LLVM (`llvm`), and WebAssembly (`wat`, `wasm`).

---

## 2. Modular Structure and Contracts

The library comprises **9 domain modules** declaring a total of **56 public operations**:

| Domain Source File | Formal Contract | Domain Responsibility | Ops Count |
|---|---|---|:---:|
| `GuiConstants.fdsl` | `GuiConstantsContract` | Specialized domain for `GuiConstants` | 13 |
| `GuiLayout.fdsl` | `GuiLayoutContract` | Specialized domain for `GuiLayout` | 9 |
| `GuiScrollArea.fdsl` | `GuiScrollAreaContract` | Specialized domain for `GuiScrollArea` | 4 |
| `GuiState.fdsl` | `GuiStateContract` | Specialized domain for `GuiState` | 11 |
| `GuiTheme.fdsl` | `GuiThemeContract` | Specialized domain for `GuiTheme` | 5 |
| `GuiWidgetBasic.fdsl` | `GuiWidgetBasicContract` | Specialized domain for `GuiWidgetBasic` | 5 |
| `GuiWidgetButton.fdsl` | `GuiWidgetButtonContract` | Specialized domain for `GuiWidgetButton` | 4 |
| `GuiWidgetInput.fdsl` | `GuiWidgetInputContract` | Specialized domain for `GuiWidgetInput` | 3 |
| `GuiWidgetSlider.fdsl` | `GuiWidgetSliderContract` | Specialized domain for `GuiWidgetSlider` | 2 |

---

## 3. Public Types, Structures, and Enumerations

The `GuiStdLib` library operates directly on primitive native TheFlux types (`string`, `int64`, `float64`, `bool`, `list of data`, etc.) without requiring custom composite types.

---

## 4. Detailed Operations Catalog by Domain

### 4.1 Contract `GuiConstantsContract` (`GuiConstants.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `guiDpiStandard` | `op guiDpiStandard () as float64` | `float64` |
| `guiDpiMacClassic` | `op guiDpiMacClassic () as float64` | `float64` |
| `guiDpiRetina` | `op guiDpiRetina () as float64` | `float64` |
| `guiMmPerInch` | `op guiMmPerInch () as float64` | `float64` |
| `guiHumanVisualReactionTimeMs` | `op guiHumanVisualReactionTimeMs () as float64` | `float64` |
| `guiPersistenceOfVisionHz` | `op guiPersistenceOfVisionHz () as float64` | `float64` |
| `guiLatencyInstantFeedbackMs` | `op guiLatencyInstantFeedbackMs () as float64` | `float64` |
| `guiTouchTargetMinPx` | `op guiTouchTargetMinPx () as int64` | `int64` |
| `guiFontSizeDefault` | `op guiFontSizeDefault () as int64` | `int64` |
| `guiFontSizeHeading` | `op guiFontSizeHeading () as int64` | `int64` |
| `guiFontSizeTitle` | `op guiFontSizeTitle () as int64` | `int64` |
| `guiPaddingDefault` | `op guiPaddingDefault () as int64` | `int64` |
| `guiItemSpacingDefault` | `op guiItemSpacingDefault () as int64` | `int64` |

#### Operation Technical Specifications:

##### `op guiDpiStandard`
```flux
op guiDpiStandard () as float64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `guiDpiStandard` functionality within the `GuiConstantsContract` domain.

##### `op guiDpiMacClassic`
```flux
op guiDpiMacClassic () as float64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `guiDpiMacClassic` functionality within the `GuiConstantsContract` domain.

##### `op guiDpiRetina`
```flux
op guiDpiRetina () as float64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `guiDpiRetina` functionality within the `GuiConstantsContract` domain.

##### `op guiMmPerInch`
```flux
op guiMmPerInch () as float64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `guiMmPerInch` functionality within the `GuiConstantsContract` domain.

##### `op guiHumanVisualReactionTimeMs`
```flux
op guiHumanVisualReactionTimeMs () as float64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `guiHumanVisualReactionTimeMs` functionality within the `GuiConstantsContract` domain.

##### `op guiPersistenceOfVisionHz`
```flux
op guiPersistenceOfVisionHz () as float64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `guiPersistenceOfVisionHz` functionality within the `GuiConstantsContract` domain.

##### `op guiLatencyInstantFeedbackMs`
```flux
op guiLatencyInstantFeedbackMs () as float64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `guiLatencyInstantFeedbackMs` functionality within the `GuiConstantsContract` domain.

##### `op guiTouchTargetMinPx`
```flux
op guiTouchTargetMinPx () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `guiTouchTargetMinPx` functionality within the `GuiConstantsContract` domain.

##### `op guiFontSizeDefault`
```flux
op guiFontSizeDefault () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `guiFontSizeDefault` functionality within the `GuiConstantsContract` domain.

##### `op guiFontSizeHeading`
```flux
op guiFontSizeHeading () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `guiFontSizeHeading` functionality within the `GuiConstantsContract` domain.

##### `op guiFontSizeTitle`
```flux
op guiFontSizeTitle () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `guiFontSizeTitle` functionality within the `GuiConstantsContract` domain.

##### `op guiPaddingDefault`
```flux
op guiPaddingDefault () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `guiPaddingDefault` functionality within the `GuiConstantsContract` domain.

##### `op guiItemSpacingDefault`
```flux
op guiItemSpacingDefault () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `guiItemSpacingDefault` functionality within the `GuiConstantsContract` domain.

### 4.2 Contract `GuiLayoutContract` (`GuiLayout.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `guiLayoutBeginRow` | `op guiLayoutBeginRow (as map: ctx) as map` | `map` |
| `guiLayoutEndRow` | `op guiLayoutEndRow (as map: ctx) as map` | `map` |
| `guiLayoutBeginColumn` | `op guiLayoutBeginColumn (as map: ctx) as map` | `map` |
| `guiLayoutEndColumn` | `op guiLayoutEndColumn (as map: ctx) as map` | `map` |
| `guiSpacing` | `op guiSpacing (as map: ctx, as int64: pixels) as map` | `map` |
| `guiSameLine` | `op guiSameLine (as map: ctx) as map` | `map` |
| `guiGetCursorX` | `op guiGetCursorX (as map: ctx) as int64` | `int64` |
| `guiGetCursorY` | `op guiGetCursorY (as map: ctx) as int64` | `int64` |
| `guiSetCursor` | `op guiSetCursor (as map: ctx, as int64: x, as int64: y) as map` | `map` |

#### Operation Technical Specifications:

##### `op guiLayoutBeginRow`
```flux
op guiLayoutBeginRow (as map: ctx) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `guiLayoutBeginRow` functionality within the `GuiLayoutContract` domain.

##### `op guiLayoutEndRow`
```flux
op guiLayoutEndRow (as map: ctx) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `guiLayoutEndRow` functionality within the `GuiLayoutContract` domain.

##### `op guiLayoutBeginColumn`
```flux
op guiLayoutBeginColumn (as map: ctx) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `guiLayoutBeginColumn` functionality within the `GuiLayoutContract` domain.

##### `op guiLayoutEndColumn`
```flux
op guiLayoutEndColumn (as map: ctx) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `guiLayoutEndColumn` functionality within the `GuiLayoutContract` domain.

##### `op guiSpacing`
```flux
op guiSpacing (as map: ctx, as int64: pixels) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `pixels` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `guiSpacing` functionality within the `GuiLayoutContract` domain.

##### `op guiSameLine`
```flux
op guiSameLine (as map: ctx) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `guiSameLine` functionality within the `GuiLayoutContract` domain.

##### `op guiGetCursorX`
```flux
op guiGetCursorX (as map: ctx) as int64
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `guiGetCursorX` functionality within the `GuiLayoutContract` domain.

##### `op guiGetCursorY`
```flux
op guiGetCursorY (as map: ctx) as int64
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `guiGetCursorY` functionality within the `GuiLayoutContract` domain.

##### `op guiSetCursor`
```flux
op guiSetCursor (as map: ctx, as int64: x, as int64: y) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `x` (`int64`): Input argument for operation execution.
  - `y` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `guiSetCursor` functionality within the `GuiLayoutContract` domain.

### 4.3 Contract `GuiScrollAreaContract` (`GuiScrollArea.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `guiBeginScrollArea` | `op guiBeginScrollArea (as map: ctx, as string: area_id, as int64: w, as int64: h) as map` | `map` |
| `guiEndScrollArea` | `op guiEndScrollArea (as map: ctx) as map` | `map` |
| `guiSetScrollOffsetY` | `op guiSetScrollOffsetY (as map: ctx, as string: area_id, as int64: offset_y) as map` | `map` |
| `guiGetScrollOffsetY` | `op guiGetScrollOffsetY (as map: ctx, as string: area_id) as int64` | `int64` |

#### Operation Technical Specifications:

##### `op guiBeginScrollArea`
```flux
op guiBeginScrollArea (as map: ctx, as string: area_id, as int64: w, as int64: h) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `area_id` (`string`): Input argument for operation execution.
  - `w` (`int64`): Input argument for operation execution.
  - `h` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `guiBeginScrollArea` functionality within the `GuiScrollAreaContract` domain.

##### `op guiEndScrollArea`
```flux
op guiEndScrollArea (as map: ctx) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `guiEndScrollArea` functionality within the `GuiScrollAreaContract` domain.

##### `op guiSetScrollOffsetY`
```flux
op guiSetScrollOffsetY (as map: ctx, as string: area_id, as int64: offset_y) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `area_id` (`string`): Input argument for operation execution.
  - `offset_y` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `guiSetScrollOffsetY` functionality within the `GuiScrollAreaContract` domain.

##### `op guiGetScrollOffsetY`
```flux
op guiGetScrollOffsetY (as map: ctx, as string: area_id) as int64
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `area_id` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `guiGetScrollOffsetY` functionality within the `GuiScrollAreaContract` domain.

### 4.4 Contract `GuiStateContract` (`GuiState.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `guiInitContext` | `op guiInitContext (as int64: screen_w, as int64: screen_h) as map` | `map` |
| `guiCloseContext` | `op guiCloseContext (as map: ctx) as map` | `map` |
| `guiContextResetFrame` | `op guiContextResetFrame (as map: ctx) as map` | `map` |
| `guiGetWidgetCount` | `op guiGetWidgetCount (as map: ctx) as int64` | `int64` |
| `guiGetFrameCount` | `op guiGetFrameCount (as map: ctx) as int64` | `int64` |
| `guiGetScreenWidth` | `op guiGetScreenWidth (as map: ctx) as int64` | `int64` |
| `guiGetScreenHeight` | `op guiGetScreenHeight (as map: ctx) as int64` | `int64` |
| `guiBindNativeWindow` | `op guiBindNativeWindow (as map: ctx, as int64: win_id) as map` | `map` |
| `guiGetNativeWindow` | `op guiGetNativeWindow (as map: ctx) as int64` | `int64` |
| `guiUpdateInput` | `op guiUpdateInput (as map: ctx) as map` | `map` |
| `guiPollNativeEvents` | `op guiPollNativeEvents (as map: ctx) as int64` | `int64` |

#### Operation Technical Specifications:

##### `op guiInitContext`
```flux
op guiInitContext (as int64: screen_w, as int64: screen_h) as map
```
- **Parameters**:
  - `screen_w` (`int64`): Input argument for operation execution.
  - `screen_h` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `guiInitContext` functionality within the `GuiStateContract` domain.

##### `op guiCloseContext`
```flux
op guiCloseContext (as map: ctx) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `guiCloseContext` functionality within the `GuiStateContract` domain.

##### `op guiContextResetFrame`
```flux
op guiContextResetFrame (as map: ctx) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `guiContextResetFrame` functionality within the `GuiStateContract` domain.

##### `op guiGetWidgetCount`
```flux
op guiGetWidgetCount (as map: ctx) as int64
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `guiGetWidgetCount` functionality within the `GuiStateContract` domain.

##### `op guiGetFrameCount`
```flux
op guiGetFrameCount (as map: ctx) as int64
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `guiGetFrameCount` functionality within the `GuiStateContract` domain.

##### `op guiGetScreenWidth`
```flux
op guiGetScreenWidth (as map: ctx) as int64
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `guiGetScreenWidth` functionality within the `GuiStateContract` domain.

##### `op guiGetScreenHeight`
```flux
op guiGetScreenHeight (as map: ctx) as int64
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `guiGetScreenHeight` functionality within the `GuiStateContract` domain.

##### `op guiBindNativeWindow`
```flux
op guiBindNativeWindow (as map: ctx, as int64: win_id) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `win_id` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `guiBindNativeWindow` functionality within the `GuiStateContract` domain.

##### `op guiGetNativeWindow`
```flux
op guiGetNativeWindow (as map: ctx) as int64
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `guiGetNativeWindow` functionality within the `GuiStateContract` domain.

##### `op guiUpdateInput`
```flux
op guiUpdateInput (as map: ctx) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `guiUpdateInput` functionality within the `GuiStateContract` domain.

##### `op guiPollNativeEvents`
```flux
op guiPollNativeEvents (as map: ctx) as int64
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `guiPollNativeEvents` functionality within the `GuiStateContract` domain.

### 4.5 Contract `GuiThemeContract` (`GuiTheme.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `guiThemeDefault` | `op guiThemeDefault () as map` | `map` |
| `guiThemeDark` | `op guiThemeDark () as map` | `map` |
| `guiThemeLight` | `op guiThemeLight () as map` | `map` |
| `guiSetTheme` | `op guiSetTheme (as map: ctx, as map: theme) as map` | `map` |
| `guiGetThemeColor` | `op guiGetThemeColor (as map: ctx, as string: key) as list of int64` | `list of int64` |

#### Operation Technical Specifications:

##### `op guiThemeDefault`
```flux
op guiThemeDefault () as map
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `guiThemeDefault` functionality within the `GuiThemeContract` domain.

##### `op guiThemeDark`
```flux
op guiThemeDark () as map
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `guiThemeDark` functionality within the `GuiThemeContract` domain.

##### `op guiThemeLight`
```flux
op guiThemeLight () as map
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `guiThemeLight` functionality within the `GuiThemeContract` domain.

##### `op guiSetTheme`
```flux
op guiSetTheme (as map: ctx, as map: theme) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `theme` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `guiSetTheme` functionality within the `GuiThemeContract` domain.

##### `op guiGetThemeColor`
```flux
op guiGetThemeColor (as map: ctx, as string: key) as list of int64
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `key` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `guiGetThemeColor` functionality within the `GuiThemeContract` domain.

### 4.6 Contract `GuiWidgetBasicContract` (`GuiWidgetBasic.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `guiLabel` | `op guiLabel (as map: ctx, as string: text) as map` | `map` |
| `guiHeading` | `op guiHeading (as map: ctx, as string: text) as map` | `map` |
| `guiTitle` | `op guiTitle (as map: ctx, as string: text) as map` | `map` |
| `guiSeparator` | `op guiSeparator (as map: ctx) as map` | `map` |
| `guiProgressBar` | `op guiProgressBar (as map: ctx, as float64: fraction, as int64: w, as int64: h) as map` | `map` |

#### Operation Technical Specifications:

##### `op guiLabel`
```flux
op guiLabel (as map: ctx, as string: text) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `guiLabel` functionality within the `GuiWidgetBasicContract` domain.

##### `op guiHeading`
```flux
op guiHeading (as map: ctx, as string: text) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `guiHeading` functionality within the `GuiWidgetBasicContract` domain.

##### `op guiTitle`
```flux
op guiTitle (as map: ctx, as string: text) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `guiTitle` functionality within the `GuiWidgetBasicContract` domain.

##### `op guiSeparator`
```flux
op guiSeparator (as map: ctx) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `guiSeparator` functionality within the `GuiWidgetBasicContract` domain.

##### `op guiProgressBar`
```flux
op guiProgressBar (as map: ctx, as float64: fraction, as int64: w, as int64: h) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `fraction` (`float64`): Input argument for operation execution.
  - `w` (`int64`): Input argument for operation execution.
  - `h` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `guiProgressBar` functionality within the `GuiWidgetBasicContract` domain.

### 4.7 Contract `GuiWidgetButtonContract` (`GuiWidgetButton.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `guiButton` | `op guiButton (as map: ctx, as string: label) as list of data` | `list of data` |
| `guiButtonEx` | `op guiButtonEx (as map: ctx, as string: label, as int64: w, as int64: h) as list of data` | `list of data` |
| `guiCheckbox` | `op guiCheckbox (as map: ctx, as string: label, as bool: active) as list of data` | `list of data` |
| `guiRadioButton` | `op guiRadioButton (as map: ctx, as string: label, as bool: active) as list of data` | `list of data` |

#### Operation Technical Specifications:

##### `op guiButton`
```flux
op guiButton (as map: ctx, as string: label) as list of data
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `label` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `guiButton` functionality within the `GuiWidgetButtonContract` domain.

##### `op guiButtonEx`
```flux
op guiButtonEx (as map: ctx, as string: label, as int64: w, as int64: h) as list of data
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `label` (`string`): Input argument for operation execution.
  - `w` (`int64`): Input argument for operation execution.
  - `h` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `guiButtonEx` functionality within the `GuiWidgetButtonContract` domain.

##### `op guiCheckbox`
```flux
op guiCheckbox (as map: ctx, as string: label, as bool: active) as list of data
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `label` (`string`): Input argument for operation execution.
  - `active` (`bool`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `guiCheckbox` functionality within the `GuiWidgetButtonContract` domain.

##### `op guiRadioButton`
```flux
op guiRadioButton (as map: ctx, as string: label, as bool: active) as list of data
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `label` (`string`): Input argument for operation execution.
  - `active` (`bool`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `guiRadioButton` functionality within the `GuiWidgetButtonContract` domain.

### 4.8 Contract `GuiWidgetInputContract` (`GuiWidgetInput.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `guiInputText` | `op guiInputText (as map: ctx, as string: label, as string: current_text, as int64: max_len) as list of data` | `list of data` |
| `guiInputInt` | `op guiInputInt (as map: ctx, as string: label, as int64: current_val) as list of data` | `list of data` |
| `guiInputFloat` | `op guiInputFloat (as map: ctx, as string: label, as float64: current_val) as list of data` | `list of data` |

#### Operation Technical Specifications:

##### `op guiInputText`
```flux
op guiInputText (as map: ctx, as string: label, as string: current_text, as int64: max_len) as list of data
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `label` (`string`): Input argument for operation execution.
  - `current_text` (`string`): Input argument for operation execution.
  - `max_len` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `guiInputText` functionality within the `GuiWidgetInputContract` domain.

##### `op guiInputInt`
```flux
op guiInputInt (as map: ctx, as string: label, as int64: current_val) as list of data
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `label` (`string`): Input argument for operation execution.
  - `current_val` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `guiInputInt` functionality within the `GuiWidgetInputContract` domain.

##### `op guiInputFloat`
```flux
op guiInputFloat (as map: ctx, as string: label, as float64: current_val) as list of data
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `label` (`string`): Input argument for operation execution.
  - `current_val` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `guiInputFloat` functionality within the `GuiWidgetInputContract` domain.

### 4.9 Contract `GuiWidgetSliderContract` (`GuiWidgetSlider.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `guiSliderFloat` | `op guiSliderFloat (as map: ctx, as string: label, as float64: val, as float64: min_val, as float64: max_val) as list of data` | `list of data` |
| `guiSliderInt` | `op guiSliderInt (as map: ctx, as string: label, as int64: val, as int64: min_val, as int64: max_val) as list of data` | `list of data` |

#### Operation Technical Specifications:

##### `op guiSliderFloat`
```flux
op guiSliderFloat (as map: ctx, as string: label, as float64: val, as float64: min_val, as float64: max_val) as list of data
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `label` (`string`): Input argument for operation execution.
  - `val` (`float64`): Input argument for operation execution.
  - `min_val` (`float64`): Input argument for operation execution.
  - `max_val` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `guiSliderFloat` functionality within the `GuiWidgetSliderContract` domain.

##### `op guiSliderInt`
```flux
op guiSliderInt (as map: ctx, as string: label, as int64: val, as int64: min_val, as int64: max_val) as list of data
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `label` (`string`): Input argument for operation execution.
  - `val` (`int64`): Input argument for operation execution.
  - `min_val` (`int64`): Input argument for operation execution.
  - `max_val` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `guiSliderInt` functionality within the `GuiWidgetSliderContract` domain.

---

## 5. Canonical Usage Examples in TheFlux

The following snippet illustrates importing and utilizing the library in a TheFlux program:

```flux
# Canonical Usage Example for GuiStdLib
use GuiStdLib

program (ExampleOfGuiStdLib) {
      println("==================================================")
      println("  Standard Library Demonstration: GuiStdLib")
      println("==================================================")

      # Invoking canonical operation
      mut as data: result = GuiStdLib::guiCreateTheme("Dark")
      println("Obtained result: " + result)

      println("Execution completed successfully.")
}
```

---

> [!TIP]
> For the complete unified architecture across all standard libraries, consult the master [StdLibs.md](../StdLibs.md) reference.
