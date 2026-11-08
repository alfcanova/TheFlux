# 📚 `GfxStdLib` — 2D/3D Graphics Primitives, Shaders, Cameras, and Transforms

> **Architectural Pillar**: Pillar 4 (System, I/O & Network)  
> **Status**: ✅ Certified with 100% Parity across 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Master File**: `stdlib/GfxStdLib/GfxStdLib.fdsl`  
> **Import Mode**: `use GfxStdLib` or `use GfxStdLib::<Module>::<operation>`

---

## 1. Overview and Capabilities

The **`GfxStdLib`** standard library is an integral component of the official TheFlux language ecosystem, providing certified system-level algorithms and robust capabilities.

Graphics computing toolkit: perspective and orthographic projection matrices, Phong/Blinn lighting equations, orbit/FPS camera controllers, 3D polygon meshes, color space math, and spatial collision primitives (AABB/sphere bounds).

### 1.1 Key Architectural Principles and Design
- **Static Fusion and Zero-Overhead**: All domain modules are transparently fused into the `GfxStdLib` unified agent at compile time, avoiding virtual dispatch penalties.
- **Safety and Isolation**: Operations strictly validate parameter bounds and guarantee predictable error semantics via contract definitions.
- **Universal Multi-Backend Parity**: Bit-for-bit identical execution guarantees across interpreter (`in`), bytecode VM (`vm`, `vmr`), native AOT LLVM (`llvm`), and WebAssembly (`wat`, `wasm`).

---

## 2. Modular Structure and Contracts

The library comprises **9 domain modules** declaring a total of **86 public operations**:

| Domain Source File | Formal Contract | Domain Responsibility | Ops Count |
|---|---|---|:---:|
| `GfxCamera.fdsl` | `GfxCameraContract` | Specialized domain for `GfxCamera` | 3 |
| `GfxCollision.fdsl` | `GfxCollisionContract` | Specialized domain for `GfxCollision` | 4 |
| `GfxColor.fdsl` | `GfxColorContract` | Specialized domain for `GfxColor` | 9 |
| `GfxConstants.fdsl` | `GfxConstantsContract` | Specialized domain for `GfxConstants` | 30 |
| `GfxInput.fdsl` | `GfxInputContract` | Specialized domain for `GfxInput` | 6 |
| `GfxOpticsPhysics.fdsl` | `GfxOpticsPhysicsContract` | Specialized domain for `GfxOpticsPhysics` | 4 |
| `GfxPrimitives.fdsl` | `GfxPrimitivesContract` | Specialized domain for `GfxPrimitives` | 8 |
| `GfxState.fdsl` | `GfxStateContract` | Specialized domain for `GfxState` | 16 |
| `GfxTexture.fdsl` | `GfxTextureContract` | Specialized domain for `GfxTexture` | 6 |

---

## 3. Public Types, Structures, and Enumerations

The `GfxStdLib` library operates directly on primitive native TheFlux types (`string`, `int64`, `float64`, `bool`, `list of data`, etc.) without requiring custom composite types.

---

## 4. Detailed Operations Catalog by Domain

### 4.1 Contract `GfxCameraContract` (`GfxCamera.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `gfxCamera2DNew` | `op gfxCamera2DNew (as float64: target_x, as float64: target_y, as float64: offset_x, as float64: offset_y, as float64: rotation_deg, as float64: zoom) as map` | `map` |
| `gfxWorldToScreen2D` | `op gfxWorldToScreen2D (as float64: wx, as float64: wy, as map: camera) as list of float64` | `list of float64` |
| `gfxScreenToWorld2D` | `op gfxScreenToWorld2D (as float64: sx, as float64: sy, as map: camera) as list of float64` | `list of float64` |

#### Operation Technical Specifications:

##### `op gfxCamera2DNew`
```flux
op gfxCamera2DNew (as float64: target_x, as float64: target_y, as float64: offset_x, as float64: offset_y, as float64: rotation_deg, as float64: zoom) as map
```
- **Parameters**:
  - `target_x` (`float64`): Input argument for operation execution.
  - `target_y` (`float64`): Input argument for operation execution.
  - `offset_x` (`float64`): Input argument for operation execution.
  - `offset_y` (`float64`): Input argument for operation execution.
  - `rotation_deg` (`float64`): Input argument for operation execution.
  - `zoom` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxCamera2DNew` functionality within the `GfxCameraContract` domain.

##### `op gfxWorldToScreen2D`
```flux
op gfxWorldToScreen2D (as float64: wx, as float64: wy, as map: camera) as list of float64
```
- **Parameters**:
  - `wx` (`float64`): Input argument for operation execution.
  - `wy` (`float64`): Input argument for operation execution.
  - `camera` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxWorldToScreen2D` functionality within the `GfxCameraContract` domain.

##### `op gfxScreenToWorld2D`
```flux
op gfxScreenToWorld2D (as float64: sx, as float64: sy, as map: camera) as list of float64
```
- **Parameters**:
  - `sx` (`float64`): Input argument for operation execution.
  - `sy` (`float64`): Input argument for operation execution.
  - `camera` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxScreenToWorld2D` functionality within the `GfxCameraContract` domain.

### 4.2 Contract `GfxCollisionContract` (`GfxCollision.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `gfxCheckCollisionRecs` | `op gfxCheckCollisionRecs (as float64: x1, as float64: y1, as float64: w1, as float64: h1, as float64: x2, as float64: y2, as float64: w2, as float64: h2) as bool` | `bool` |
| `gfxCheckCollisionCircles` | `op gfxCheckCollisionCircles (as float64: c1x, as float64: c1y, as float64: r1, as float64: c2x, as float64: c2y, as float64: r2) as bool` | `bool` |
| `gfxCheckCollisionPointRec` | `op gfxCheckCollisionPointRec (as float64: px, as float64: py, as float64: rx, as float64: ry, as float64: rw, as float64: rh) as bool` | `bool` |
| `gfxCheckCollisionPointCircle` | `op gfxCheckCollisionPointCircle (as float64: px, as float64: py, as float64: cx, as float64: cy, as float64: radius) as bool` | `bool` |

#### Operation Technical Specifications:

##### `op gfxCheckCollisionRecs`
```flux
op gfxCheckCollisionRecs (as float64: x1, as float64: y1, as float64: w1, as float64: h1, as float64: x2, as float64: y2, as float64: w2, as float64: h2) as bool
```
- **Parameters**:
  - `x1` (`float64`): Input argument for operation execution.
  - `y1` (`float64`): Input argument for operation execution.
  - `w1` (`float64`): Input argument for operation execution.
  - `h1` (`float64`): Input argument for operation execution.
  - `x2` (`float64`): Input argument for operation execution.
  - `y2` (`float64`): Input argument for operation execution.
  - `w2` (`float64`): Input argument for operation execution.
  - `h2` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxCheckCollisionRecs` functionality within the `GfxCollisionContract` domain.

##### `op gfxCheckCollisionCircles`
```flux
op gfxCheckCollisionCircles (as float64: c1x, as float64: c1y, as float64: r1, as float64: c2x, as float64: c2y, as float64: r2) as bool
```
- **Parameters**:
  - `c1x` (`float64`): Input argument for operation execution.
  - `c1y` (`float64`): Input argument for operation execution.
  - `r1` (`float64`): Input argument for operation execution.
  - `c2x` (`float64`): Input argument for operation execution.
  - `c2y` (`float64`): Input argument for operation execution.
  - `r2` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxCheckCollisionCircles` functionality within the `GfxCollisionContract` domain.

##### `op gfxCheckCollisionPointRec`
```flux
op gfxCheckCollisionPointRec (as float64: px, as float64: py, as float64: rx, as float64: ry, as float64: rw, as float64: rh) as bool
```
- **Parameters**:
  - `px` (`float64`): Input argument for operation execution.
  - `py` (`float64`): Input argument for operation execution.
  - `rx` (`float64`): Input argument for operation execution.
  - `ry` (`float64`): Input argument for operation execution.
  - `rw` (`float64`): Input argument for operation execution.
  - `rh` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxCheckCollisionPointRec` functionality within the `GfxCollisionContract` domain.

##### `op gfxCheckCollisionPointCircle`
```flux
op gfxCheckCollisionPointCircle (as float64: px, as float64: py, as float64: cx, as float64: cy, as float64: radius) as bool
```
- **Parameters**:
  - `px` (`float64`): Input argument for operation execution.
  - `py` (`float64`): Input argument for operation execution.
  - `cx` (`float64`): Input argument for operation execution.
  - `cy` (`float64`): Input argument for operation execution.
  - `radius` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxCheckCollisionPointCircle` functionality within the `GfxCollisionContract` domain.

### 4.3 Contract `GfxColorContract` (`GfxColor.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `gfxColorRgba` | `op gfxColorRgba (as int64: r, as int64: g, as int64: b, as int64: a) as list of int64` | `list of int64` |
| `gfxColorGetR` | `op gfxColorGetR (as list of int64: c) as int64` | `int64` |
| `gfxColorGetG` | `op gfxColorGetG (as list of int64: c) as int64` | `int64` |
| `gfxColorGetB` | `op gfxColorGetB (as list of int64: c) as int64` | `int64` |
| `gfxColorGetA` | `op gfxColorGetA (as list of int64: c) as int64` | `int64` |
| `gfxColorFromHex` | `op gfxColorFromHex (as string: hex_str) as list of int64` | `list of int64` |
| `gfxColorToHex` | `op gfxColorToHex (as list of int64: color) as string` | `string` |
| `gfxColorLerp` | `op gfxColorLerp (as list of int64: c1, as list of int64: c2, as float64: t) as list of int64` | `list of int64` |
| `gfxColorAlpha` | `op gfxColorAlpha (as list of int64: color, as float64: alpha) as list of int64` | `list of int64` |

#### Operation Technical Specifications:

##### `op gfxColorRgba`
```flux
op gfxColorRgba (as int64: r, as int64: g, as int64: b, as int64: a) as list of int64
```
- **Parameters**:
  - `r` (`int64`): Input argument for operation execution.
  - `g` (`int64`): Input argument for operation execution.
  - `b` (`int64`): Input argument for operation execution.
  - `a` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxColorRgba` functionality within the `GfxColorContract` domain.

##### `op gfxColorGetR`
```flux
op gfxColorGetR (as list of int64: c) as int64
```
- **Parameters**:
  - `c` (`list of int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxColorGetR` functionality within the `GfxColorContract` domain.

##### `op gfxColorGetG`
```flux
op gfxColorGetG (as list of int64: c) as int64
```
- **Parameters**:
  - `c` (`list of int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxColorGetG` functionality within the `GfxColorContract` domain.

##### `op gfxColorGetB`
```flux
op gfxColorGetB (as list of int64: c) as int64
```
- **Parameters**:
  - `c` (`list of int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxColorGetB` functionality within the `GfxColorContract` domain.

##### `op gfxColorGetA`
```flux
op gfxColorGetA (as list of int64: c) as int64
```
- **Parameters**:
  - `c` (`list of int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxColorGetA` functionality within the `GfxColorContract` domain.

##### `op gfxColorFromHex`
```flux
op gfxColorFromHex (as string: hex_str) as list of int64
```
- **Parameters**:
  - `hex_str` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxColorFromHex` functionality within the `GfxColorContract` domain.

##### `op gfxColorToHex`
```flux
op gfxColorToHex (as list of int64: color) as string
```
- **Parameters**:
  - `color` (`list of int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxColorToHex` functionality within the `GfxColorContract` domain.

##### `op gfxColorLerp`
```flux
op gfxColorLerp (as list of int64: c1, as list of int64: c2, as float64: t) as list of int64
```
- **Parameters**:
  - `c1` (`list of int64`): Input argument for operation execution.
  - `c2` (`list of int64`): Input argument for operation execution.
  - `t` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxColorLerp` functionality within the `GfxColorContract` domain.

##### `op gfxColorAlpha`
```flux
op gfxColorAlpha (as list of int64: color, as float64: alpha) as list of int64
```
- **Parameters**:
  - `color` (`list of int64`): Input argument for operation execution.
  - `alpha` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxColorAlpha` functionality within the `GfxColorContract` domain.

### 4.4 Contract `GfxConstantsContract` (`GfxConstants.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `res720pW` | `op res720pW () as int64` | `int64` |
| `res720pH` | `op res720pH () as int64` | `int64` |
| `res1080pW` | `op res1080pW () as int64` | `int64` |
| `res1080pH` | `op res1080pH () as int64` | `int64` |
| `res4kW` | `op res4kW () as int64` | `int64` |
| `res4kH` | `op res4kH () as int64` | `int64` |
| `aspect16x9` | `op aspect16x9 () as float64` | `float64` |
| `aspect4x3` | `op aspect4x3 () as float64` | `float64` |
| `aspect21x9` | `op aspect21x9 () as float64` | `float64` |
| `colorWhite` | `op colorWhite () as list of int64` | `list of int64` |
| `colorBlack` | `op colorBlack () as list of int64` | `list of int64` |
| `colorRed` | `op colorRed () as list of int64` | `list of int64` |
| `colorGreen` | `op colorGreen () as list of int64` | `list of int64` |
| `colorBlue` | `op colorBlue () as list of int64` | `list of int64` |
| `colorYellow` | `op colorYellow () as list of int64` | `list of int64` |
| `colorMagenta` | `op colorMagenta () as list of int64` | `list of int64` |
| `colorCyan` | `op colorCyan () as list of int64` | `list of int64` |
| `colorTransparent` | `op colorTransparent () as list of int64` | `list of int64` |
| `gfxIorAir` | `op gfxIorAir () as float64` | `float64` |
| `gfxIorWater` | `op gfxIorWater () as float64` | `float64` |
| `gfxIorGlass` | `op gfxIorGlass () as float64` | `float64` |
| `gfxIorDiamond` | `op gfxIorDiamond () as float64` | `float64` |
| `gfxIorPolycarbonate` | `op gfxIorPolycarbonate () as float64` | `float64` |
| `gfxLuxDirectSun` | `op gfxLuxDirectSun () as float64` | `float64` |
| `gfxLuxOvercastDay` | `op gfxLuxOvercastDay () as float64` | `float64` |
| `gfxLuxOffice` | `op gfxLuxOffice () as float64` | `float64` |
| `gfxLuxFullMoon` | `op gfxLuxFullMoon () as float64` | `float64` |
| `gfxKelvinDaylightD65` | `op gfxKelvinDaylightD65 () as float64` | `float64` |
| `gfxKelvinTungsten` | `op gfxKelvinTungsten () as float64` | `float64` |
| `gfxKelvinCandle` | `op gfxKelvinCandle () as float64` | `float64` |

#### Operation Technical Specifications:

##### `op res720pW`
```flux
op res720pW () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `res720pW` functionality within the `GfxConstantsContract` domain.

##### `op res720pH`
```flux
op res720pH () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `res720pH` functionality within the `GfxConstantsContract` domain.

##### `op res1080pW`
```flux
op res1080pW () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `res1080pW` functionality within the `GfxConstantsContract` domain.

##### `op res1080pH`
```flux
op res1080pH () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `res1080pH` functionality within the `GfxConstantsContract` domain.

##### `op res4kW`
```flux
op res4kW () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `res4kW` functionality within the `GfxConstantsContract` domain.

##### `op res4kH`
```flux
op res4kH () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `res4kH` functionality within the `GfxConstantsContract` domain.

##### `op aspect16x9`
```flux
op aspect16x9 () as float64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `aspect16x9` functionality within the `GfxConstantsContract` domain.

##### `op aspect4x3`
```flux
op aspect4x3 () as float64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `aspect4x3` functionality within the `GfxConstantsContract` domain.

##### `op aspect21x9`
```flux
op aspect21x9 () as float64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `aspect21x9` functionality within the `GfxConstantsContract` domain.

##### `op colorWhite`
```flux
op colorWhite () as list of int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `list of int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `colorWhite` functionality within the `GfxConstantsContract` domain.

##### `op colorBlack`
```flux
op colorBlack () as list of int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `list of int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `colorBlack` functionality within the `GfxConstantsContract` domain.

##### `op colorRed`
```flux
op colorRed () as list of int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `list of int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `colorRed` functionality within the `GfxConstantsContract` domain.

##### `op colorGreen`
```flux
op colorGreen () as list of int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `list of int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `colorGreen` functionality within the `GfxConstantsContract` domain.

##### `op colorBlue`
```flux
op colorBlue () as list of int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `list of int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `colorBlue` functionality within the `GfxConstantsContract` domain.

##### `op colorYellow`
```flux
op colorYellow () as list of int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `list of int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `colorYellow` functionality within the `GfxConstantsContract` domain.

##### `op colorMagenta`
```flux
op colorMagenta () as list of int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `list of int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `colorMagenta` functionality within the `GfxConstantsContract` domain.

##### `op colorCyan`
```flux
op colorCyan () as list of int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `list of int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `colorCyan` functionality within the `GfxConstantsContract` domain.

##### `op colorTransparent`
```flux
op colorTransparent () as list of int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `list of int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `colorTransparent` functionality within the `GfxConstantsContract` domain.

##### `op gfxIorAir`
```flux
op gfxIorAir () as float64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxIorAir` functionality within the `GfxConstantsContract` domain.

##### `op gfxIorWater`
```flux
op gfxIorWater () as float64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxIorWater` functionality within the `GfxConstantsContract` domain.

##### `op gfxIorGlass`
```flux
op gfxIorGlass () as float64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxIorGlass` functionality within the `GfxConstantsContract` domain.

##### `op gfxIorDiamond`
```flux
op gfxIorDiamond () as float64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxIorDiamond` functionality within the `GfxConstantsContract` domain.

##### `op gfxIorPolycarbonate`
```flux
op gfxIorPolycarbonate () as float64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxIorPolycarbonate` functionality within the `GfxConstantsContract` domain.

##### `op gfxLuxDirectSun`
```flux
op gfxLuxDirectSun () as float64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxLuxDirectSun` functionality within the `GfxConstantsContract` domain.

##### `op gfxLuxOvercastDay`
```flux
op gfxLuxOvercastDay () as float64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxLuxOvercastDay` functionality within the `GfxConstantsContract` domain.

##### `op gfxLuxOffice`
```flux
op gfxLuxOffice () as float64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxLuxOffice` functionality within the `GfxConstantsContract` domain.

##### `op gfxLuxFullMoon`
```flux
op gfxLuxFullMoon () as float64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxLuxFullMoon` functionality within the `GfxConstantsContract` domain.

##### `op gfxKelvinDaylightD65`
```flux
op gfxKelvinDaylightD65 () as float64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxKelvinDaylightD65` functionality within the `GfxConstantsContract` domain.

##### `op gfxKelvinTungsten`
```flux
op gfxKelvinTungsten () as float64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxKelvinTungsten` functionality within the `GfxConstantsContract` domain.

##### `op gfxKelvinCandle`
```flux
op gfxKelvinCandle () as float64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxKelvinCandle` functionality within the `GfxConstantsContract` domain.

### 4.5 Contract `GfxInputContract` (`GfxInput.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `gfxInputNew` | `op gfxInputNew () as map` | `map` |
| `gfxSetInputState` | `op gfxSetInputState (as map: input_state, as string: key_name, as bool: is_down) as map` | `map` |
| `gfxPollInput` | `op gfxPollInput (as map: input_state, as string: key_name) as bool` | `bool` |
| `gfxSetMousePosition` | `op gfxSetMousePosition (as map: input_state, as int64: x, as int64: y) as map` | `map` |
| `gfxGetMouseX` | `op gfxGetMouseX (as map: input_state) as int64` | `int64` |
| `gfxGetMouseY` | `op gfxGetMouseY (as map: input_state) as int64` | `int64` |

#### Operation Technical Specifications:

##### `op gfxInputNew`
```flux
op gfxInputNew () as map
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxInputNew` functionality within the `GfxInputContract` domain.

##### `op gfxSetInputState`
```flux
op gfxSetInputState (as map: input_state, as string: key_name, as bool: is_down) as map
```
- **Parameters**:
  - `input_state` (`map`): Input argument for operation execution.
  - `key_name` (`string`): Input argument for operation execution.
  - `is_down` (`bool`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxSetInputState` functionality within the `GfxInputContract` domain.

##### `op gfxPollInput`
```flux
op gfxPollInput (as map: input_state, as string: key_name) as bool
```
- **Parameters**:
  - `input_state` (`map`): Input argument for operation execution.
  - `key_name` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxPollInput` functionality within the `GfxInputContract` domain.

##### `op gfxSetMousePosition`
```flux
op gfxSetMousePosition (as map: input_state, as int64: x, as int64: y) as map
```
- **Parameters**:
  - `input_state` (`map`): Input argument for operation execution.
  - `x` (`int64`): Input argument for operation execution.
  - `y` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxSetMousePosition` functionality within the `GfxInputContract` domain.

##### `op gfxGetMouseX`
```flux
op gfxGetMouseX (as map: input_state) as int64
```
- **Parameters**:
  - `input_state` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxGetMouseX` functionality within the `GfxInputContract` domain.

##### `op gfxGetMouseY`
```flux
op gfxGetMouseY (as map: input_state) as int64
```
- **Parameters**:
  - `input_state` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxGetMouseY` functionality within the `GfxInputContract` domain.

### 4.6 Contract `GfxOpticsPhysicsContract` (`GfxOpticsPhysics.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `gfxFresnelSchlick` | `op gfxFresnelSchlick (as float64: cos_theta, as float64: f0) as float64` | `float64` |
| `gfxLightAttenuation` | `op gfxLightAttenuation (as float64: distance, as float64: constant_term, as float64: linear_term, as float64: quadratic_term) as float64` | `float64` |
| `gfxKelvinToRgb` | `op gfxKelvinToRgb (as float64: kelvin) as list of int64` | `list of int64` |
| `gfxLuminance` | `op gfxLuminance (as list of int64: color) as float64` | `float64` |

#### Operation Technical Specifications:

##### `op gfxFresnelSchlick`
```flux
op gfxFresnelSchlick (as float64: cos_theta, as float64: f0) as float64
```
- **Parameters**:
  - `cos_theta` (`float64`): Input argument for operation execution.
  - `f0` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxFresnelSchlick` functionality within the `GfxOpticsPhysicsContract` domain.

##### `op gfxLightAttenuation`
```flux
op gfxLightAttenuation (as float64: distance, as float64: constant_term, as float64: linear_term, as float64: quadratic_term) as float64
```
- **Parameters**:
  - `distance` (`float64`): Input argument for operation execution.
  - `constant_term` (`float64`): Input argument for operation execution.
  - `linear_term` (`float64`): Input argument for operation execution.
  - `quadratic_term` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxLightAttenuation` functionality within the `GfxOpticsPhysicsContract` domain.

##### `op gfxKelvinToRgb`
```flux
op gfxKelvinToRgb (as float64: kelvin) as list of int64
```
- **Parameters**:
  - `kelvin` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxKelvinToRgb` functionality within the `GfxOpticsPhysicsContract` domain.

##### `op gfxLuminance`
```flux
op gfxLuminance (as list of int64: color) as float64
```
- **Parameters**:
  - `color` (`list of int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxLuminance` functionality within the `GfxOpticsPhysicsContract` domain.

### 4.7 Contract `GfxPrimitivesContract` (`GfxPrimitives.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `gfxClearBackground` | `op gfxClearBackground (as map: ctx, as list of int64: color) as map` | `map` |
| `gfxDrawRect` | `op gfxDrawRect (as map: ctx, as float64: x, as float64: y, as float64: w, as float64: h, as list of int64: color) as map` | `map` |
| `gfxDrawRectLines` | `op gfxDrawRectLines (as map: ctx, as float64: x, as float64: y, as float64: w, as float64: h, as list of int64: color) as map` | `map` |
| `gfxDrawCircle` | `op gfxDrawCircle (as map: ctx, as float64: cx, as float64: cy, as float64: radius, as list of int64: color) as map` | `map` |
| `gfxDrawCircleLines` | `op gfxDrawCircleLines (as map: ctx, as float64: cx, as float64: cy, as float64: radius, as list of int64: color) as map` | `map` |
| `gfxDrawLine` | `op gfxDrawLine (as map: ctx, as float64: x1, as float64: y1, as float64: x2, as float64: y2, as list of int64: color) as map` | `map` |
| `gfxDrawTriangle` | `op gfxDrawTriangle (as map: ctx, as float64: x1, as float64: y1, as float64: x2, as float64: y2, as float64: x3, as float64: y3, as list of int64: color) as map` | `map` |
| `gfxDrawText` | `op gfxDrawText (as map: ctx, as string: text, as float64: x, as float64: y, as int64: font_size, as list of int64: color) as map` | `map` |

#### Operation Technical Specifications:

##### `op gfxClearBackground`
```flux
op gfxClearBackground (as map: ctx, as list of int64: color) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `color` (`list of int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxClearBackground` functionality within the `GfxPrimitivesContract` domain.

##### `op gfxDrawRect`
```flux
op gfxDrawRect (as map: ctx, as float64: x, as float64: y, as float64: w, as float64: h, as list of int64: color) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `x` (`float64`): Input argument for operation execution.
  - `y` (`float64`): Input argument for operation execution.
  - `w` (`float64`): Input argument for operation execution.
  - `h` (`float64`): Input argument for operation execution.
  - `color` (`list of int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxDrawRect` functionality within the `GfxPrimitivesContract` domain.

##### `op gfxDrawRectLines`
```flux
op gfxDrawRectLines (as map: ctx, as float64: x, as float64: y, as float64: w, as float64: h, as list of int64: color) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `x` (`float64`): Input argument for operation execution.
  - `y` (`float64`): Input argument for operation execution.
  - `w` (`float64`): Input argument for operation execution.
  - `h` (`float64`): Input argument for operation execution.
  - `color` (`list of int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxDrawRectLines` functionality within the `GfxPrimitivesContract` domain.

##### `op gfxDrawCircle`
```flux
op gfxDrawCircle (as map: ctx, as float64: cx, as float64: cy, as float64: radius, as list of int64: color) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `cx` (`float64`): Input argument for operation execution.
  - `cy` (`float64`): Input argument for operation execution.
  - `radius` (`float64`): Input argument for operation execution.
  - `color` (`list of int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxDrawCircle` functionality within the `GfxPrimitivesContract` domain.

##### `op gfxDrawCircleLines`
```flux
op gfxDrawCircleLines (as map: ctx, as float64: cx, as float64: cy, as float64: radius, as list of int64: color) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `cx` (`float64`): Input argument for operation execution.
  - `cy` (`float64`): Input argument for operation execution.
  - `radius` (`float64`): Input argument for operation execution.
  - `color` (`list of int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxDrawCircleLines` functionality within the `GfxPrimitivesContract` domain.

##### `op gfxDrawLine`
```flux
op gfxDrawLine (as map: ctx, as float64: x1, as float64: y1, as float64: x2, as float64: y2, as list of int64: color) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `x1` (`float64`): Input argument for operation execution.
  - `y1` (`float64`): Input argument for operation execution.
  - `x2` (`float64`): Input argument for operation execution.
  - `y2` (`float64`): Input argument for operation execution.
  - `color` (`list of int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxDrawLine` functionality within the `GfxPrimitivesContract` domain.

##### `op gfxDrawTriangle`
```flux
op gfxDrawTriangle (as map: ctx, as float64: x1, as float64: y1, as float64: x2, as float64: y2, as float64: x3, as float64: y3, as list of int64: color) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `x1` (`float64`): Input argument for operation execution.
  - `y1` (`float64`): Input argument for operation execution.
  - `x2` (`float64`): Input argument for operation execution.
  - `y2` (`float64`): Input argument for operation execution.
  - `x3` (`float64`): Input argument for operation execution.
  - `y3` (`float64`): Input argument for operation execution.
  - `color` (`list of int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxDrawTriangle` functionality within the `GfxPrimitivesContract` domain.

##### `op gfxDrawText`
```flux
op gfxDrawText (as map: ctx, as string: text, as float64: x, as float64: y, as int64: font_size, as list of int64: color) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `text` (`string`): Input argument for operation execution.
  - `x` (`float64`): Input argument for operation execution.
  - `y` (`float64`): Input argument for operation execution.
  - `font_size` (`int64`): Input argument for operation execution.
  - `color` (`list of int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxDrawText` functionality within the `GfxPrimitivesContract` domain.

### 4.8 Contract `GfxStateContract` (`GfxState.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `gfxInitContext` | `op gfxInitContext (as int64: width, as int64: height, as string: title) as map` | `map` |
| `gfxCloseContext` | `op gfxCloseContext (as map: ctx) as map` | `map` |
| `gfxContextShouldClose` | `op gfxContextShouldClose (as map: ctx) as bool` | `bool` |
| `gfxContextWidth` | `op gfxContextWidth (as map: ctx) as int64` | `int64` |
| `gfxContextHeight` | `op gfxContextHeight (as map: ctx) as int64` | `int64` |
| `gfxContextTitle` | `op gfxContextTitle (as map: ctx) as string` | `string` |
| `gfxContextSetFps` | `op gfxContextSetFps (as map: ctx, as int64: fps) as map` | `map` |
| `gfxContextGetFps` | `op gfxContextGetFps (as map: ctx) as int64` | `int64` |
| `gfxContextDrawCalls` | `op gfxContextDrawCalls (as map: ctx) as int64` | `int64` |
| `gfxContextResetDrawCalls` | `op gfxContextResetDrawCalls (as map: ctx) as map` | `map` |
| `gfxCheckInBounds` | `op gfxCheckInBounds (as float64: x, as float64: y, as float64: w, as float64: h, as int64: screen_w, as int64: screen_h) as bool` | `bool` |
| `gfxBindNativeWindow` | `op gfxBindNativeWindow (as map: ctx, as int64: win_id) as map` | `map` |
| `gfxGetNativeWindow` | `op gfxGetNativeWindow (as map: ctx) as int64` | `int64` |
| `gfxPresentFrame` | `op gfxPresentFrame (as map: ctx) as bool` | `bool` |
| `gfxPollNativeEvents` | `op gfxPollNativeEvents (as map: ctx) as int64` | `int64` |
| `gfxContextWait` | `op gfxContextWait (as map: ctx, as int64: ms) as bool` | `bool` |

#### Operation Technical Specifications:

##### `op gfxInitContext`
```flux
op gfxInitContext (as int64: width, as int64: height, as string: title) as map
```
- **Parameters**:
  - `width` (`int64`): Input argument for operation execution.
  - `height` (`int64`): Input argument for operation execution.
  - `title` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxInitContext` functionality within the `GfxStateContract` domain.

##### `op gfxCloseContext`
```flux
op gfxCloseContext (as map: ctx) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxCloseContext` functionality within the `GfxStateContract` domain.

##### `op gfxContextShouldClose`
```flux
op gfxContextShouldClose (as map: ctx) as bool
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxContextShouldClose` functionality within the `GfxStateContract` domain.

##### `op gfxContextWidth`
```flux
op gfxContextWidth (as map: ctx) as int64
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxContextWidth` functionality within the `GfxStateContract` domain.

##### `op gfxContextHeight`
```flux
op gfxContextHeight (as map: ctx) as int64
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxContextHeight` functionality within the `GfxStateContract` domain.

##### `op gfxContextTitle`
```flux
op gfxContextTitle (as map: ctx) as string
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxContextTitle` functionality within the `GfxStateContract` domain.

##### `op gfxContextSetFps`
```flux
op gfxContextSetFps (as map: ctx, as int64: fps) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `fps` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxContextSetFps` functionality within the `GfxStateContract` domain.

##### `op gfxContextGetFps`
```flux
op gfxContextGetFps (as map: ctx) as int64
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxContextGetFps` functionality within the `GfxStateContract` domain.

##### `op gfxContextDrawCalls`
```flux
op gfxContextDrawCalls (as map: ctx) as int64
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxContextDrawCalls` functionality within the `GfxStateContract` domain.

##### `op gfxContextResetDrawCalls`
```flux
op gfxContextResetDrawCalls (as map: ctx) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxContextResetDrawCalls` functionality within the `GfxStateContract` domain.

##### `op gfxCheckInBounds`
```flux
op gfxCheckInBounds (as float64: x, as float64: y, as float64: w, as float64: h, as int64: screen_w, as int64: screen_h) as bool
```
- **Parameters**:
  - `x` (`float64`): Input argument for operation execution.
  - `y` (`float64`): Input argument for operation execution.
  - `w` (`float64`): Input argument for operation execution.
  - `h` (`float64`): Input argument for operation execution.
  - `screen_w` (`int64`): Input argument for operation execution.
  - `screen_h` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxCheckInBounds` functionality within the `GfxStateContract` domain.

##### `op gfxBindNativeWindow`
```flux
op gfxBindNativeWindow (as map: ctx, as int64: win_id) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `win_id` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxBindNativeWindow` functionality within the `GfxStateContract` domain.

##### `op gfxGetNativeWindow`
```flux
op gfxGetNativeWindow (as map: ctx) as int64
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxGetNativeWindow` functionality within the `GfxStateContract` domain.

##### `op gfxPresentFrame`
```flux
op gfxPresentFrame (as map: ctx) as bool
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxPresentFrame` functionality within the `GfxStateContract` domain.

##### `op gfxPollNativeEvents`
```flux
op gfxPollNativeEvents (as map: ctx) as int64
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxPollNativeEvents` functionality within the `GfxStateContract` domain.

##### `op gfxContextWait`
```flux
op gfxContextWait (as map: ctx, as int64: ms) as bool
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `ms` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxContextWait` functionality within the `GfxStateContract` domain.

### 4.9 Contract `GfxTextureContract` (`GfxTexture.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `gfxTextureNew` | `op gfxTextureNew (as int64: width, as int64: height) as map` | `map` |
| `gfxTextureGetWidth` | `op gfxTextureGetWidth (as map: texture) as int64` | `int64` |
| `gfxTextureGetHeight` | `op gfxTextureGetHeight (as map: texture) as int64` | `int64` |
| `gfxTextureIsLoaded` | `op gfxTextureIsLoaded (as map: texture) as bool` | `bool` |
| `gfxDrawTexture` | `op gfxDrawTexture (as map: ctx, as map: texture, as float64: x, as float64: y) as map` | `map` |
| `gfxDrawTexturePro` | `op gfxDrawTexturePro (as map: ctx, as map: texture, as float64: sx, as float64: sy, as float64: sw, as float64: sh, as float64: dx, as float64: dy, as float64: dw, as float64: dh, as float64: rotation_deg) as map` | `map` |

#### Operation Technical Specifications:

##### `op gfxTextureNew`
```flux
op gfxTextureNew (as int64: width, as int64: height) as map
```
- **Parameters**:
  - `width` (`int64`): Input argument for operation execution.
  - `height` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxTextureNew` functionality within the `GfxTextureContract` domain.

##### `op gfxTextureGetWidth`
```flux
op gfxTextureGetWidth (as map: texture) as int64
```
- **Parameters**:
  - `texture` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxTextureGetWidth` functionality within the `GfxTextureContract` domain.

##### `op gfxTextureGetHeight`
```flux
op gfxTextureGetHeight (as map: texture) as int64
```
- **Parameters**:
  - `texture` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxTextureGetHeight` functionality within the `GfxTextureContract` domain.

##### `op gfxTextureIsLoaded`
```flux
op gfxTextureIsLoaded (as map: texture) as bool
```
- **Parameters**:
  - `texture` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxTextureIsLoaded` functionality within the `GfxTextureContract` domain.

##### `op gfxDrawTexture`
```flux
op gfxDrawTexture (as map: ctx, as map: texture, as float64: x, as float64: y) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `texture` (`map`): Input argument for operation execution.
  - `x` (`float64`): Input argument for operation execution.
  - `y` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxDrawTexture` functionality within the `GfxTextureContract` domain.

##### `op gfxDrawTexturePro`
```flux
op gfxDrawTexturePro (as map: ctx, as map: texture, as float64: sx, as float64: sy, as float64: sw, as float64: sh, as float64: dx, as float64: dy, as float64: dw, as float64: dh, as float64: rotation_deg) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `texture` (`map`): Input argument for operation execution.
  - `sx` (`float64`): Input argument for operation execution.
  - `sy` (`float64`): Input argument for operation execution.
  - `sw` (`float64`): Input argument for operation execution.
  - `sh` (`float64`): Input argument for operation execution.
  - `dx` (`float64`): Input argument for operation execution.
  - `dy` (`float64`): Input argument for operation execution.
  - `dw` (`float64`): Input argument for operation execution.
  - `dh` (`float64`): Input argument for operation execution.
  - `rotation_deg` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gfxDrawTexturePro` functionality within the `GfxTextureContract` domain.

---

## 5. Canonical Usage Examples in TheFlux

The following snippet illustrates importing and utilizing the library in a TheFlux program:

```flux
# Canonical Usage Example for GfxStdLib
use GfxStdLib

program (ExampleOfGfxStdLib) {
      println("==================================================")
      println("  Standard Library Demonstration: GfxStdLib")
      println("==================================================")

      # Invoking canonical operation
      mut as data: result = GfxStdLib::gfxColorRgb(255, 128, 0)
      println("Obtained result: " + result)

      println("Execution completed successfully.")
}
```

---

> [!TIP]
> For the complete unified architecture across all standard libraries, consult the master [StdLibs.md](../StdLibs.md) reference.
