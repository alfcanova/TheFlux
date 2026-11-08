# 📚 `MathStdLib` — Core Mathematics, Trigonometry, and Special Functions

> **Architectural Pillar**: Pillar 3 (Mathematics & Graphics)  
> **Status**: ✅ Certified with 100% Parity across 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Master File**: `stdlib/MathStdLib/MathStdLib.fdsl`  
> **Import Mode**: `use MathStdLib` or `use MathStdLib::<Module>::<operation>`

---

## 1. Overview and Capabilities

The **`MathStdLib`** standard library is an integral component of the official TheFlux language ecosystem, providing certified system-level algorithms and robust capabilities.

The canonical implementation model of the TheFlux standard library: 756 mathematical operations across 16, 32, and 64-bit precision spanning elementary arithmetic, rounding, roots, logarithms, trigonometry, hyperbolic curves, combinatorics, and special functions (Gamma, Beta, Erf).

### 1.1 Key Architectural Principles and Design
- **Static Fusion and Zero-Overhead**: All domain modules are transparently fused into the `MathStdLib` unified agent at compile time, avoiding virtual dispatch penalties.
- **Safety and Isolation**: Operations strictly validate parameter bounds and guarantee predictable error semantics via contract definitions.
- **Universal Multi-Backend Parity**: Bit-for-bit identical execution guarantees across interpreter (`in`), bytecode VM (`vm`, `vmr`), native AOT LLVM (`llvm`), and WebAssembly (`wat`, `wasm`).

---

## 2. Modular Structure and Contracts

The library comprises **10 domain modules** declaring a total of **378 public operations**:

| Domain Source File | Formal Contract | Domain Responsibility | Ops Count |
|---|---|---|:---:|
| `AngleConversion.fdsl` | `AngleConversionContract` | Specialized domain for `AngleConversion` | 18 |
| `BasicArithmetic.fdsl` | `BasicArithmeticContract` | Specialized domain for `BasicArithmetic` | 27 |
| `Combinatorics.fdsl` | `CombinatoricsContract` | Specialized domain for `Combinatorics` | 27 |
| `ExponentialLog.fdsl` | `ExponentialLogContract` | Specialized domain for `ExponentialLog` | 33 |
| `FloatElementary.fdsl` | `FloatElementaryContract` | Specialized domain for `FloatElementary` | 27 |
| `Hyperbolic.fdsl` | `HyperbolicContract` | Specialized domain for `Hyperbolic` | 39 |
| `MathConstants.fdsl` | `MathConstantsContract` | Specialized domain for `MathConstants` | 45 |
| `RootsAndRounding.fdsl` | `RootsAndRoundingContract` | Specialized domain for `RootsAndRounding` | 24 |
| `SpecialFunctions.fdsl` | `SpecialFunctionsContract` | Specialized domain for `SpecialFunctions` | 81 |
| `Trigonometry.fdsl` | `TrigonometryContract` | Specialized domain for `Trigonometry` | 57 |

---

## 3. Public Types, Structures, and Enumerations

The `MathStdLib` library operates directly on primitive native TheFlux types (`string`, `int64`, `float64`, `bool`, `list of data`, etc.) without requiring custom composite types.

---

## 4. Detailed Operations Catalog by Domain

### 4.1 Contract `AngleConversionContract` (`AngleConversion.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `degreesToRadians64` | `op degreesToRadians64 (as float64: value) as float64` | `float64` |
| `degreesToRadians32` | `op degreesToRadians32 (as float32: value) as float32` | `float32` |
| `degreesToRadians16` | `op degreesToRadians16 (as float16: value) as float16` | `float16` |
| `gradiansToRadians64` | `op gradiansToRadians64 (as float64: value) as float64` | `float64` |
| `gradiansToRadians32` | `op gradiansToRadians32 (as float32: value) as float32` | `float32` |
| `gradiansToRadians16` | `op gradiansToRadians16 (as float16: value) as float16` | `float16` |
| `radiansToDegrees64` | `op radiansToDegrees64 (as float64: value) as float64` | `float64` |
| `radiansToDegrees32` | `op radiansToDegrees32 (as float32: value) as float32` | `float32` |
| `radiansToDegrees16` | `op radiansToDegrees16 (as float16: value) as float16` | `float16` |
| `gradiansToDegrees64` | `op gradiansToDegrees64 (as float64: value) as float64` | `float64` |
| `gradiansToDegrees32` | `op gradiansToDegrees32 (as float32: value) as float32` | `float32` |
| `gradiansToDegrees16` | `op gradiansToDegrees16 (as float16: value) as float16` | `float16` |
| `radiansToGradians64` | `op radiansToGradians64 (as float64: value) as float64` | `float64` |
| `radiansToGradians32` | `op radiansToGradians32 (as float32: value) as float32` | `float32` |
| `radiansToGradians16` | `op radiansToGradians16 (as float16: value) as float16` | `float16` |
| `degreesToGradians64` | `op degreesToGradians64 (as float64: value) as float64` | `float64` |
| `degreesToGradians32` | `op degreesToGradians32 (as float32: value) as float32` | `float32` |
| `degreesToGradians16` | `op degreesToGradians16 (as float16: value) as float16` | `float16` |

#### Operation Technical Specifications:

##### `op degreesToRadians64`
```flux
op degreesToRadians64 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `degreesToRadians64` functionality within the `AngleConversionContract` domain.

##### `op degreesToRadians32`
```flux
op degreesToRadians32 (as float32: value) as float32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `degreesToRadians32` functionality within the `AngleConversionContract` domain.

##### `op degreesToRadians16`
```flux
op degreesToRadians16 (as float16: value) as float16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `degreesToRadians16` functionality within the `AngleConversionContract` domain.

##### `op gradiansToRadians64`
```flux
op gradiansToRadians64 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gradiansToRadians64` functionality within the `AngleConversionContract` domain.

##### `op gradiansToRadians32`
```flux
op gradiansToRadians32 (as float32: value) as float32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gradiansToRadians32` functionality within the `AngleConversionContract` domain.

##### `op gradiansToRadians16`
```flux
op gradiansToRadians16 (as float16: value) as float16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gradiansToRadians16` functionality within the `AngleConversionContract` domain.

##### `op radiansToDegrees64`
```flux
op radiansToDegrees64 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `radiansToDegrees64` functionality within the `AngleConversionContract` domain.

##### `op radiansToDegrees32`
```flux
op radiansToDegrees32 (as float32: value) as float32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `radiansToDegrees32` functionality within the `AngleConversionContract` domain.

##### `op radiansToDegrees16`
```flux
op radiansToDegrees16 (as float16: value) as float16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `radiansToDegrees16` functionality within the `AngleConversionContract` domain.

##### `op gradiansToDegrees64`
```flux
op gradiansToDegrees64 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gradiansToDegrees64` functionality within the `AngleConversionContract` domain.

##### `op gradiansToDegrees32`
```flux
op gradiansToDegrees32 (as float32: value) as float32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gradiansToDegrees32` functionality within the `AngleConversionContract` domain.

##### `op gradiansToDegrees16`
```flux
op gradiansToDegrees16 (as float16: value) as float16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gradiansToDegrees16` functionality within the `AngleConversionContract` domain.

##### `op radiansToGradians64`
```flux
op radiansToGradians64 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `radiansToGradians64` functionality within the `AngleConversionContract` domain.

##### `op radiansToGradians32`
```flux
op radiansToGradians32 (as float32: value) as float32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `radiansToGradians32` functionality within the `AngleConversionContract` domain.

##### `op radiansToGradians16`
```flux
op radiansToGradians16 (as float16: value) as float16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `radiansToGradians16` functionality within the `AngleConversionContract` domain.

##### `op degreesToGradians64`
```flux
op degreesToGradians64 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `degreesToGradians64` functionality within the `AngleConversionContract` domain.

##### `op degreesToGradians32`
```flux
op degreesToGradians32 (as float32: value) as float32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `degreesToGradians32` functionality within the `AngleConversionContract` domain.

##### `op degreesToGradians16`
```flux
op degreesToGradians16 (as float16: value) as float16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `degreesToGradians16` functionality within the `AngleConversionContract` domain.

### 4.2 Contract `BasicArithmeticContract` (`BasicArithmetic.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `add64` | `op add64 (as int64: left, as int64: right) as int64` | `int64` |
| `add32` | `op add32 (as int32: left, as int32: right) as int32` | `int32` |
| `add16` | `op add16 (as int16: left, as int16: right) as int16` | `int16` |
| `subtract64` | `op subtract64 (as int64: left, as int64: right) as int64` | `int64` |
| `subtract32` | `op subtract32 (as int32: left, as int32: right) as int32` | `int32` |
| `subtract16` | `op subtract16 (as int16: left, as int16: right) as int16` | `int16` |
| `multiply64` | `op multiply64 (as int64: left, as int64: right) as int64` | `int64` |
| `multiply32` | `op multiply32 (as int32: left, as int32: right) as int32` | `int32` |
| `multiply16` | `op multiply16 (as int16: left, as int16: right) as int16` | `int16` |
| `remainder64` | `op remainder64 (as int64: left, as int64: right) as int64` | `int64` |
| `remainder32` | `op remainder32 (as int32: left, as int32: right) as int32` | `int32` |
| `remainder16` | `op remainder16 (as int16: left, as int16: right) as int16` | `int16` |
| `negate64` | `op negate64 (as int64: value) as int64` | `int64` |
| `negate32` | `op negate32 (as int32: value) as int32` | `int32` |
| `negate16` | `op negate16 (as int16: value) as int16` | `int16` |
| `divideInt64` | `op divideInt64 (as int64: left, as int64: right) as int64` | `int64` |
| `divideInt32` | `op divideInt32 (as int32: left, as int32: right) as int32` | `int32` |
| `divideInt16` | `op divideInt16 (as int16: left, as int16: right) as int16` | `int16` |
| `divideFloat64` | `op divideFloat64 (as float64: left, as float64: right) as float64` | `float64` |
| `divideFloat32` | `op divideFloat32 (as float32: left, as float32: right) as float32` | `float32` |
| `divideFloat16` | `op divideFloat16 (as float16: left, as float16: right) as float16` | `float16` |
| `power64` | `op power64 (as float64: left, as float64: right) as float64` | `float64` |
| `power32` | `op power32 (as float32: left, as float32: right) as float32` | `float32` |
| `power16` | `op power16 (as float16: left, as float16: right) as float16` | `float16` |
| `root64` | `op root64 (as float64: degree, as float64: radicand) as float64` | `float64` |
| `root32` | `op root32 (as float32: degree, as float32: radicand) as float32` | `float32` |
| `root16` | `op root16 (as float16: degree, as float16: radicand) as float16` | `float16` |

#### Operation Technical Specifications:

##### `op add64`
```flux
op add64 (as int64: left, as int64: right) as int64
```
- **Parameters**:
  - `left` (`int64`): Input argument for operation execution.
  - `right` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `add64` functionality within the `BasicArithmeticContract` domain.

##### `op add32`
```flux
op add32 (as int32: left, as int32: right) as int32
```
- **Parameters**:
  - `left` (`int32`): Input argument for operation execution.
  - `right` (`int32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `add32` functionality within the `BasicArithmeticContract` domain.

##### `op add16`
```flux
op add16 (as int16: left, as int16: right) as int16
```
- **Parameters**:
  - `left` (`int16`): Input argument for operation execution.
  - `right` (`int16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `add16` functionality within the `BasicArithmeticContract` domain.

##### `op subtract64`
```flux
op subtract64 (as int64: left, as int64: right) as int64
```
- **Parameters**:
  - `left` (`int64`): Input argument for operation execution.
  - `right` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `subtract64` functionality within the `BasicArithmeticContract` domain.

##### `op subtract32`
```flux
op subtract32 (as int32: left, as int32: right) as int32
```
- **Parameters**:
  - `left` (`int32`): Input argument for operation execution.
  - `right` (`int32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `subtract32` functionality within the `BasicArithmeticContract` domain.

##### `op subtract16`
```flux
op subtract16 (as int16: left, as int16: right) as int16
```
- **Parameters**:
  - `left` (`int16`): Input argument for operation execution.
  - `right` (`int16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `subtract16` functionality within the `BasicArithmeticContract` domain.

##### `op multiply64`
```flux
op multiply64 (as int64: left, as int64: right) as int64
```
- **Parameters**:
  - `left` (`int64`): Input argument for operation execution.
  - `right` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `multiply64` functionality within the `BasicArithmeticContract` domain.

##### `op multiply32`
```flux
op multiply32 (as int32: left, as int32: right) as int32
```
- **Parameters**:
  - `left` (`int32`): Input argument for operation execution.
  - `right` (`int32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `multiply32` functionality within the `BasicArithmeticContract` domain.

##### `op multiply16`
```flux
op multiply16 (as int16: left, as int16: right) as int16
```
- **Parameters**:
  - `left` (`int16`): Input argument for operation execution.
  - `right` (`int16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `multiply16` functionality within the `BasicArithmeticContract` domain.

##### `op remainder64`
```flux
op remainder64 (as int64: left, as int64: right) as int64
```
- **Parameters**:
  - `left` (`int64`): Input argument for operation execution.
  - `right` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `remainder64` functionality within the `BasicArithmeticContract` domain.

##### `op remainder32`
```flux
op remainder32 (as int32: left, as int32: right) as int32
```
- **Parameters**:
  - `left` (`int32`): Input argument for operation execution.
  - `right` (`int32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `remainder32` functionality within the `BasicArithmeticContract` domain.

##### `op remainder16`
```flux
op remainder16 (as int16: left, as int16: right) as int16
```
- **Parameters**:
  - `left` (`int16`): Input argument for operation execution.
  - `right` (`int16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `remainder16` functionality within the `BasicArithmeticContract` domain.

##### `op negate64`
```flux
op negate64 (as int64: value) as int64
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `negate64` functionality within the `BasicArithmeticContract` domain.

##### `op negate32`
```flux
op negate32 (as int32: value) as int32
```
- **Parameters**:
  - `value` (`int32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `negate32` functionality within the `BasicArithmeticContract` domain.

##### `op negate16`
```flux
op negate16 (as int16: value) as int16
```
- **Parameters**:
  - `value` (`int16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `negate16` functionality within the `BasicArithmeticContract` domain.

##### `op divideInt64`
```flux
op divideInt64 (as int64: left, as int64: right) as int64
```
- **Parameters**:
  - `left` (`int64`): Input argument for operation execution.
  - `right` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
  - ⚠️ Emits `fail` with status message `"divisao inteira por zero"`
- **Functional Description**:
  - Executes canonical `divideInt64` functionality within the `BasicArithmeticContract` domain.

##### `op divideInt32`
```flux
op divideInt32 (as int32: left, as int32: right) as int32
```
- **Parameters**:
  - `left` (`int32`): Input argument for operation execution.
  - `right` (`int32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int32`
  - ✅ Emits `nice` with status message `"ok"`
  - ⚠️ Emits `fail` with status message `"divisao inteira por zero"`
- **Functional Description**:
  - Executes canonical `divideInt32` functionality within the `BasicArithmeticContract` domain.

##### `op divideInt16`
```flux
op divideInt16 (as int16: left, as int16: right) as int16
```
- **Parameters**:
  - `left` (`int16`): Input argument for operation execution.
  - `right` (`int16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int16`
  - ✅ Emits `nice` with status message `"ok"`
  - ⚠️ Emits `fail` with status message `"divisao inteira por zero"`
- **Functional Description**:
  - Executes canonical `divideInt16` functionality within the `BasicArithmeticContract` domain.

##### `op divideFloat64`
```flux
op divideFloat64 (as float64: left, as float64: right) as float64
```
- **Parameters**:
  - `left` (`float64`): Input argument for operation execution.
  - `right` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
  - ⚠️ Emits `fail` with status message `"divisao decimal por zero"`
- **Functional Description**:
  - Executes canonical `divideFloat64` functionality within the `BasicArithmeticContract` domain.

##### `op divideFloat32`
```flux
op divideFloat32 (as float32: left, as float32: right) as float32
```
- **Parameters**:
  - `left` (`float32`): Input argument for operation execution.
  - `right` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
  - ⚠️ Emits `fail` with status message `"divisao decimal por zero"`
- **Functional Description**:
  - Executes canonical `divideFloat32` functionality within the `BasicArithmeticContract` domain.

##### `op divideFloat16`
```flux
op divideFloat16 (as float16: left, as float16: right) as float16
```
- **Parameters**:
  - `left` (`float16`): Input argument for operation execution.
  - `right` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
  - ⚠️ Emits `fail` with status message `"divisao decimal por zero"`
- **Functional Description**:
  - Executes canonical `divideFloat16` functionality within the `BasicArithmeticContract` domain.

##### `op power64`
```flux
op power64 (as float64: left, as float64: right) as float64
```
- **Parameters**:
  - `left` (`float64`): Input argument for operation execution.
  - `right` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `power64` functionality within the `BasicArithmeticContract` domain.

##### `op power32`
```flux
op power32 (as float32: left, as float32: right) as float32
```
- **Parameters**:
  - `left` (`float32`): Input argument for operation execution.
  - `right` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `power32` functionality within the `BasicArithmeticContract` domain.

##### `op power16`
```flux
op power16 (as float16: left, as float16: right) as float16
```
- **Parameters**:
  - `left` (`float16`): Input argument for operation execution.
  - `right` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `power16` functionality within the `BasicArithmeticContract` domain.

##### `op root64`
```flux
op root64 (as float64: degree, as float64: radicand) as float64
```
- **Parameters**:
  - `degree` (`float64`): Input argument for operation execution.
  - `radicand` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ⚠️ Emits `fail` with status message `"grau da raiz nao pode ser zero"`
  - ⚠️ Emits `fail` with status message `"radicando negativo"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `root64` functionality within the `BasicArithmeticContract` domain.

##### `op root32`
```flux
op root32 (as float32: degree, as float32: radicand) as float32
```
- **Parameters**:
  - `degree` (`float32`): Input argument for operation execution.
  - `radicand` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ⚠️ Emits `fail` with status message `"grau da raiz nao pode ser zero"`
  - ⚠️ Emits `fail` with status message `"radicando negativo"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `root32` functionality within the `BasicArithmeticContract` domain.

##### `op root16`
```flux
op root16 (as float16: degree, as float16: radicand) as float16
```
- **Parameters**:
  - `degree` (`float16`): Input argument for operation execution.
  - `radicand` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ⚠️ Emits `fail` with status message `"grau da raiz nao pode ser zero"`
  - ⚠️ Emits `fail` with status message `"radicando negativo"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `root16` functionality within the `BasicArithmeticContract` domain.

### 4.3 Contract `CombinatoricsContract` (`Combinatorics.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `factorial64` | `op factorial64 (as int64: value) as int64` | `int64` |
| `factorial32` | `op factorial32 (as int32: value) as int32` | `int32` |
| `factorial16` | `op factorial16 (as int16: value) as int16` | `int16` |
| `arrangements64` | `op arrangements64 (as int64: n, as int64: k) as int64` | `int64` |
| `arrangements32` | `op arrangements32 (as int32: n, as int32: k) as int32` | `int32` |
| `arrangements16` | `op arrangements16 (as int16: n, as int16: k) as int16` | `int16` |
| `arrangementsWithRepetition64` | `op arrangementsWithRepetition64 (as int64: n, as int64: k) as int64` | `int64` |
| `arrangementsWithRepetition32` | `op arrangementsWithRepetition32 (as int32: n, as int32: k) as int32` | `int32` |
| `arrangementsWithRepetition16` | `op arrangementsWithRepetition16 (as int16: n, as int16: k) as int16` | `int16` |
| `combinations64` | `op combinations64 (as int64: n, as int64: k) as int64` | `int64` |
| `combinations32` | `op combinations32 (as int32: n, as int32: k) as int32` | `int32` |
| `combinations16` | `op combinations16 (as int16: n, as int16: k) as int16` | `int16` |
| `combinationsWithRepetition64` | `op combinationsWithRepetition64 (as int64: n, as int64: k) as int64` | `int64` |
| `combinationsWithRepetition32` | `op combinationsWithRepetition32 (as int32: n, as int32: k) as int32` | `int32` |
| `combinationsWithRepetition16` | `op combinationsWithRepetition16 (as int16: n, as int16: k) as int16` | `int16` |
| `permutations64` | `op permutations64 (as int64: n, as int64: k) as int64` | `int64` |
| `permutations32` | `op permutations32 (as int32: n, as int32: k) as int32` | `int32` |
| `permutations16` | `op permutations16 (as int16: n, as int16: k) as int16` | `int16` |
| `permutationsWithRepetition64` | `op permutationsWithRepetition64 (as int64: n, as int64: k) as int64` | `int64` |
| `permutationsWithRepetition32` | `op permutationsWithRepetition32 (as int32: n, as int32: k) as int32` | `int32` |
| `permutationsWithRepetition16` | `op permutationsWithRepetition16 (as int16: n, as int16: k) as int16` | `int16` |
| `greatestCommonDivisor64` | `op greatestCommonDivisor64 (as int64: n, as int64: k) as int64` | `int64` |
| `greatestCommonDivisor32` | `op greatestCommonDivisor32 (as int32: n, as int32: k) as int32` | `int32` |
| `greatestCommonDivisor16` | `op greatestCommonDivisor16 (as int16: n, as int16: k) as int16` | `int16` |
| `leastCommonMultiple64` | `op leastCommonMultiple64 (as int64: n, as int64: k) as int64` | `int64` |
| `leastCommonMultiple32` | `op leastCommonMultiple32 (as int32: n, as int32: k) as int32` | `int32` |
| `leastCommonMultiple16` | `op leastCommonMultiple16 (as int16: n, as int16: k) as int16` | `int16` |

#### Operation Technical Specifications:

##### `op factorial64`
```flux
op factorial64 (as int64: value) as int64
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ⚠️ Emits `fail` with status message `"fatorial indefinido para inteiros negativos"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `factorial64` functionality within the `CombinatoricsContract` domain.

##### `op factorial32`
```flux
op factorial32 (as int32: value) as int32
```
- **Parameters**:
  - `value` (`int32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int32`
  - ⚠️ Emits `fail` with status message `"fatorial indefinido para inteiros negativos"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `factorial32` functionality within the `CombinatoricsContract` domain.

##### `op factorial16`
```flux
op factorial16 (as int16: value) as int16
```
- **Parameters**:
  - `value` (`int16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int16`
  - ⚠️ Emits `fail` with status message `"fatorial indefinido para inteiros negativos"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `factorial16` functionality within the `CombinatoricsContract` domain.

##### `op arrangements64`
```flux
op arrangements64 (as int64: n, as int64: k) as int64
```
- **Parameters**:
  - `n` (`int64`): Input argument for operation execution.
  - `k` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ⚠️ Emits `fail` with status message `"arranjo requer 0 <= k <= n"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `arrangements64` functionality within the `CombinatoricsContract` domain.

##### `op arrangements32`
```flux
op arrangements32 (as int32: n, as int32: k) as int32
```
- **Parameters**:
  - `n` (`int32`): Input argument for operation execution.
  - `k` (`int32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int32`
  - ⚠️ Emits `fail` with status message `"arranjo requer 0 <= k <= n"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `arrangements32` functionality within the `CombinatoricsContract` domain.

##### `op arrangements16`
```flux
op arrangements16 (as int16: n, as int16: k) as int16
```
- **Parameters**:
  - `n` (`int16`): Input argument for operation execution.
  - `k` (`int16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int16`
  - ⚠️ Emits `fail` with status message `"arranjo requer 0 <= k <= n"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `arrangements16` functionality within the `CombinatoricsContract` domain.

##### `op arrangementsWithRepetition64`
```flux
op arrangementsWithRepetition64 (as int64: n, as int64: k) as int64
```
- **Parameters**:
  - `n` (`int64`): Input argument for operation execution.
  - `k` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ⚠️ Emits `fail` with status message `"arranjo com repeticao requer n >= 0 e k >= 0"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `arrangementsWithRepetition64` functionality within the `CombinatoricsContract` domain.

##### `op arrangementsWithRepetition32`
```flux
op arrangementsWithRepetition32 (as int32: n, as int32: k) as int32
```
- **Parameters**:
  - `n` (`int32`): Input argument for operation execution.
  - `k` (`int32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int32`
  - ⚠️ Emits `fail` with status message `"arranjo com repeticao requer n >= 0 e k >= 0"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `arrangementsWithRepetition32` functionality within the `CombinatoricsContract` domain.

##### `op arrangementsWithRepetition16`
```flux
op arrangementsWithRepetition16 (as int16: n, as int16: k) as int16
```
- **Parameters**:
  - `n` (`int16`): Input argument for operation execution.
  - `k` (`int16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int16`
  - ⚠️ Emits `fail` with status message `"arranjo com repeticao requer n >= 0 e k >= 0"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `arrangementsWithRepetition16` functionality within the `CombinatoricsContract` domain.

##### `op combinations64`
```flux
op combinations64 (as int64: n, as int64: k) as int64
```
- **Parameters**:
  - `n` (`int64`): Input argument for operation execution.
  - `k` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ⚠️ Emits `fail` with status message `"combinacoes requerem 0 <= k <= n"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `combinations64` functionality within the `CombinatoricsContract` domain.

##### `op combinations32`
```flux
op combinations32 (as int32: n, as int32: k) as int32
```
- **Parameters**:
  - `n` (`int32`): Input argument for operation execution.
  - `k` (`int32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int32`
  - ⚠️ Emits `fail` with status message `"combinacoes requerem 0 <= k <= n"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `combinations32` functionality within the `CombinatoricsContract` domain.

##### `op combinations16`
```flux
op combinations16 (as int16: n, as int16: k) as int16
```
- **Parameters**:
  - `n` (`int16`): Input argument for operation execution.
  - `k` (`int16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int16`
  - ⚠️ Emits `fail` with status message `"combinacoes requerem 0 <= k <= n"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `combinations16` functionality within the `CombinatoricsContract` domain.

##### `op combinationsWithRepetition64`
```flux
op combinationsWithRepetition64 (as int64: n, as int64: k) as int64
```
- **Parameters**:
  - `n` (`int64`): Input argument for operation execution.
  - `k` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ⚠️ Emits `fail` with status message `"combinacao com repeticao requer n >= 1 e k >= 0"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `combinationsWithRepetition64` functionality within the `CombinatoricsContract` domain.

##### `op combinationsWithRepetition32`
```flux
op combinationsWithRepetition32 (as int32: n, as int32: k) as int32
```
- **Parameters**:
  - `n` (`int32`): Input argument for operation execution.
  - `k` (`int32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int32`
  - ⚠️ Emits `fail` with status message `"combinacao com repeticao requer n >= 1 e k >= 0"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `combinationsWithRepetition32` functionality within the `CombinatoricsContract` domain.

##### `op combinationsWithRepetition16`
```flux
op combinationsWithRepetition16 (as int16: n, as int16: k) as int16
```
- **Parameters**:
  - `n` (`int16`): Input argument for operation execution.
  - `k` (`int16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int16`
  - ⚠️ Emits `fail` with status message `"combinacao com repeticao requer n >= 1 e k >= 0"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `combinationsWithRepetition16` functionality within the `CombinatoricsContract` domain.

##### `op permutations64`
```flux
op permutations64 (as int64: n, as int64: k) as int64
```
- **Parameters**:
  - `n` (`int64`): Input argument for operation execution.
  - `k` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `permutations64` functionality within the `CombinatoricsContract` domain.

##### `op permutations32`
```flux
op permutations32 (as int32: n, as int32: k) as int32
```
- **Parameters**:
  - `n` (`int32`): Input argument for operation execution.
  - `k` (`int32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `permutations32` functionality within the `CombinatoricsContract` domain.

##### `op permutations16`
```flux
op permutations16 (as int16: n, as int16: k) as int16
```
- **Parameters**:
  - `n` (`int16`): Input argument for operation execution.
  - `k` (`int16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `permutations16` functionality within the `CombinatoricsContract` domain.

##### `op permutationsWithRepetition64`
```flux
op permutationsWithRepetition64 (as int64: n, as int64: k) as int64
```
- **Parameters**:
  - `n` (`int64`): Input argument for operation execution.
  - `k` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `permutationsWithRepetition64` functionality within the `CombinatoricsContract` domain.

##### `op permutationsWithRepetition32`
```flux
op permutationsWithRepetition32 (as int32: n, as int32: k) as int32
```
- **Parameters**:
  - `n` (`int32`): Input argument for operation execution.
  - `k` (`int32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `permutationsWithRepetition32` functionality within the `CombinatoricsContract` domain.

##### `op permutationsWithRepetition16`
```flux
op permutationsWithRepetition16 (as int16: n, as int16: k) as int16
```
- **Parameters**:
  - `n` (`int16`): Input argument for operation execution.
  - `k` (`int16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `permutationsWithRepetition16` functionality within the `CombinatoricsContract` domain.

##### `op greatestCommonDivisor64`
```flux
op greatestCommonDivisor64 (as int64: n, as int64: k) as int64
```
- **Parameters**:
  - `n` (`int64`): Input argument for operation execution.
  - `k` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `greatestCommonDivisor64` functionality within the `CombinatoricsContract` domain.

##### `op greatestCommonDivisor32`
```flux
op greatestCommonDivisor32 (as int32: n, as int32: k) as int32
```
- **Parameters**:
  - `n` (`int32`): Input argument for operation execution.
  - `k` (`int32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `greatestCommonDivisor32` functionality within the `CombinatoricsContract` domain.

##### `op greatestCommonDivisor16`
```flux
op greatestCommonDivisor16 (as int16: n, as int16: k) as int16
```
- **Parameters**:
  - `n` (`int16`): Input argument for operation execution.
  - `k` (`int16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `greatestCommonDivisor16` functionality within the `CombinatoricsContract` domain.

##### `op leastCommonMultiple64`
```flux
op leastCommonMultiple64 (as int64: n, as int64: k) as int64
```
- **Parameters**:
  - `n` (`int64`): Input argument for operation execution.
  - `k` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `leastCommonMultiple64` functionality within the `CombinatoricsContract` domain.

##### `op leastCommonMultiple32`
```flux
op leastCommonMultiple32 (as int32: n, as int32: k) as int32
```
- **Parameters**:
  - `n` (`int32`): Input argument for operation execution.
  - `k` (`int32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `leastCommonMultiple32` functionality within the `CombinatoricsContract` domain.

##### `op leastCommonMultiple16`
```flux
op leastCommonMultiple16 (as int16: n, as int16: k) as int16
```
- **Parameters**:
  - `n` (`int16`): Input argument for operation execution.
  - `k` (`int16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `leastCommonMultiple16` functionality within the `CombinatoricsContract` domain.

### 4.4 Contract `ExponentialLogContract` (`ExponentialLog.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `powerFloat64` | `op powerFloat64 (as float64: base_val, as float64: exponent_val) as float64` | `float64` |
| `powerFloat32` | `op powerFloat32 (as float32: base_val, as float32: exponent_val) as float32` | `float32` |
| `powerFloat16` | `op powerFloat16 (as float16: base_val, as float16: exponent_val) as float16` | `float16` |
| `exp64` | `op exp64 (as float64: value) as float64` | `float64` |
| `exp32` | `op exp32 (as float32: value) as float32` | `float32` |
| `exp16` | `op exp16 (as float16: value) as float16` | `float16` |
| `log64` | `op log64 (as float64: value) as float64` | `float64` |
| `log32` | `op log32 (as float32: value) as float32` | `float32` |
| `log16` | `op log16 (as float16: value) as float16` | `float16` |
| `log2_64` | `op log2_64 (as float64: value) as float64` | `float64` |
| `log2_32` | `op log2_32 (as float32: value) as float32` | `float32` |
| `log2_16` | `op log2_16 (as float16: value) as float16` | `float16` |
| `log10_64` | `op log10_64 (as float64: value) as float64` | `float64` |
| `log10_32` | `op log10_32 (as float32: value) as float32` | `float32` |
| `log10_16` | `op log10_16 (as float16: value) as float16` | `float16` |
| `expm164` | `op expm164 (as float64: value) as float64` | `float64` |
| `expm132` | `op expm132 (as float32: value) as float32` | `float32` |
| `expm116` | `op expm116 (as float16: value) as float16` | `float16` |
| `log1p64` | `op log1p64 (as float64: value) as float64` | `float64` |
| `log1p32` | `op log1p32 (as float32: value) as float32` | `float32` |
| `log1p16` | `op log1p16 (as float16: value) as float16` | `float16` |
| `exp2_64` | `op exp2_64 (as float64: value) as float64` | `float64` |
| `exp2_32` | `op exp2_32 (as float32: value) as float32` | `float32` |
| `exp2_16` | `op exp2_16 (as float16: value) as float16` | `float16` |
| `exp10_64` | `op exp10_64 (as float64: value) as float64` | `float64` |
| `exp10_32` | `op exp10_32 (as float32: value) as float32` | `float32` |
| `exp10_16` | `op exp10_16 (as float16: value) as float16` | `float16` |
| `softplus64` | `op softplus64 (as float64: value) as float64` | `float64` |
| `softplus32` | `op softplus32 (as float32: value) as float32` | `float32` |
| `softplus16` | `op softplus16 (as float16: value) as float16` | `float16` |
| `logAddExp64` | `op logAddExp64 (as float64: left, as float64: right) as float64` | `float64` |
| `logAddExp32` | `op logAddExp32 (as float32: left, as float32: right) as float32` | `float32` |
| `logAddExp16` | `op logAddExp16 (as float16: left, as float16: right) as float16` | `float16` |

#### Operation Technical Specifications:

##### `op powerFloat64`
```flux
op powerFloat64 (as float64: base_val, as float64: exponent_val) as float64
```
- **Parameters**:
  - `base_val` (`float64`): Input argument for operation execution.
  - `exponent_val` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
  - ⚠️ Emits `fail` with status message `"potencia indefinida para base zero e expoente nao-positivo"`
  - ⚠️ Emits `fail` with status message `"base negativa com expoente nao-inteiro"`
- **Functional Description**:
  - Executes canonical `powerFloat64` functionality within the `ExponentialLogContract` domain.

##### `op powerFloat32`
```flux
op powerFloat32 (as float32: base_val, as float32: exponent_val) as float32
```
- **Parameters**:
  - `base_val` (`float32`): Input argument for operation execution.
  - `exponent_val` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `powerFloat32` functionality within the `ExponentialLogContract` domain.

##### `op powerFloat16`
```flux
op powerFloat16 (as float16: base_val, as float16: exponent_val) as float16
```
- **Parameters**:
  - `base_val` (`float16`): Input argument for operation execution.
  - `exponent_val` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `powerFloat16` functionality within the `ExponentialLogContract` domain.

##### `op exp64`
```flux
op exp64 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `exp64` functionality within the `ExponentialLogContract` domain.

##### `op exp32`
```flux
op exp32 (as float32: value) as float32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `exp32` functionality within the `ExponentialLogContract` domain.

##### `op exp16`
```flux
op exp16 (as float16: value) as float16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `exp16` functionality within the `ExponentialLogContract` domain.

##### `op log64`
```flux
op log64 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ⚠️ Emits `fail` with status message `"dominio do logaritmo natural: (0, inf)"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `log64` functionality within the `ExponentialLogContract` domain.

##### `op log32`
```flux
op log32 (as float32: value) as float32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ⚠️ Emits `fail` with status message `"dominio do logaritmo natural: (0, inf)"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `log32` functionality within the `ExponentialLogContract` domain.

##### `op log16`
```flux
op log16 (as float16: value) as float16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ⚠️ Emits `fail` with status message `"dominio do logaritmo natural: (0, inf)"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `log16` functionality within the `ExponentialLogContract` domain.

##### `op log2_64`
```flux
op log2_64 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ⚠️ Emits `fail` with status message `"dominio de log2: (0, inf)"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `log2_64` functionality within the `ExponentialLogContract` domain.

##### `op log2_32`
```flux
op log2_32 (as float32: value) as float32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ⚠️ Emits `fail` with status message `"dominio de log2: (0, inf)"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `log2_32` functionality within the `ExponentialLogContract` domain.

##### `op log2_16`
```flux
op log2_16 (as float16: value) as float16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ⚠️ Emits `fail` with status message `"dominio de log2: (0, inf)"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `log2_16` functionality within the `ExponentialLogContract` domain.

##### `op log10_64`
```flux
op log10_64 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ⚠️ Emits `fail` with status message `"dominio de log10: (0, inf)"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `log10_64` functionality within the `ExponentialLogContract` domain.

##### `op log10_32`
```flux
op log10_32 (as float32: value) as float32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ⚠️ Emits `fail` with status message `"dominio de log10: (0, inf)"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `log10_32` functionality within the `ExponentialLogContract` domain.

##### `op log10_16`
```flux
op log10_16 (as float16: value) as float16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ⚠️ Emits `fail` with status message `"dominio de log10: (0, inf)"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `log10_16` functionality within the `ExponentialLogContract` domain.

##### `op expm164`
```flux
op expm164 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `expm164` functionality within the `ExponentialLogContract` domain.

##### `op expm132`
```flux
op expm132 (as float32: value) as float32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `expm132` functionality within the `ExponentialLogContract` domain.

##### `op expm116`
```flux
op expm116 (as float16: value) as float16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `expm116` functionality within the `ExponentialLogContract` domain.

##### `op log1p64`
```flux
op log1p64 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ⚠️ Emits `fail` with status message `"dominio de log1p: (-1, inf)"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `log1p64` functionality within the `ExponentialLogContract` domain.

##### `op log1p32`
```flux
op log1p32 (as float32: value) as float32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ⚠️ Emits `fail` with status message `"dominio de log1p: (-1, inf)"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `log1p32` functionality within the `ExponentialLogContract` domain.

##### `op log1p16`
```flux
op log1p16 (as float16: value) as float16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ⚠️ Emits `fail` with status message `"dominio de log1p: (-1, inf)"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `log1p16` functionality within the `ExponentialLogContract` domain.

##### `op exp2_64`
```flux
op exp2_64 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `exp2_64` functionality within the `ExponentialLogContract` domain.

##### `op exp2_32`
```flux
op exp2_32 (as float32: value) as float32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `exp2_32` functionality within the `ExponentialLogContract` domain.

##### `op exp2_16`
```flux
op exp2_16 (as float16: value) as float16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `exp2_16` functionality within the `ExponentialLogContract` domain.

##### `op exp10_64`
```flux
op exp10_64 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `exp10_64` functionality within the `ExponentialLogContract` domain.

##### `op exp10_32`
```flux
op exp10_32 (as float32: value) as float32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `exp10_32` functionality within the `ExponentialLogContract` domain.

##### `op exp10_16`
```flux
op exp10_16 (as float16: value) as float16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `exp10_16` functionality within the `ExponentialLogContract` domain.

##### `op softplus64`
```flux
op softplus64 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `softplus64` functionality within the `ExponentialLogContract` domain.

##### `op softplus32`
```flux
op softplus32 (as float32: value) as float32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `softplus32` functionality within the `ExponentialLogContract` domain.

##### `op softplus16`
```flux
op softplus16 (as float16: value) as float16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `softplus16` functionality within the `ExponentialLogContract` domain.

##### `op logAddExp64`
```flux
op logAddExp64 (as float64: left, as float64: right) as float64
```
- **Parameters**:
  - `left` (`float64`): Input argument for operation execution.
  - `right` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `logAddExp64` functionality within the `ExponentialLogContract` domain.

##### `op logAddExp32`
```flux
op logAddExp32 (as float32: left, as float32: right) as float32
```
- **Parameters**:
  - `left` (`float32`): Input argument for operation execution.
  - `right` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `logAddExp32` functionality within the `ExponentialLogContract` domain.

##### `op logAddExp16`
```flux
op logAddExp16 (as float16: left, as float16: right) as float16
```
- **Parameters**:
  - `left` (`float16`): Input argument for operation execution.
  - `right` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `logAddExp16` functionality within the `ExponentialLogContract` domain.

### 4.5 Contract `FloatElementaryContract` (`FloatElementary.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `absolute64` | `op absolute64 (as int64: value) as int64` | `int64` |
| `absolute32` | `op absolute32 (as int32: value) as int32` | `int32` |
| `absolute16` | `op absolute16 (as int16: value) as int16` | `int16` |
| `minimum64` | `op minimum64 (as int64: left, as int64: right) as int64` | `int64` |
| `minimum32` | `op minimum32 (as int32: left, as int32: right) as int32` | `int32` |
| `minimum16` | `op minimum16 (as int16: left, as int16: right) as int16` | `int16` |
| `maximum64` | `op maximum64 (as int64: left, as int64: right) as int64` | `int64` |
| `maximum32` | `op maximum32 (as int32: left, as int32: right) as int32` | `int32` |
| `maximum16` | `op maximum16 (as int16: left, as int16: right) as int16` | `int16` |
| `absoluteFloat64` | `op absoluteFloat64 (as float64: value) as float64` | `float64` |
| `absoluteFloat32` | `op absoluteFloat32 (as float32: value) as float32` | `float32` |
| `absoluteFloat16` | `op absoluteFloat16 (as float16: value) as float16` | `float16` |
| `signal64` | `op signal64 (as float64: value) as int64` | `int64` |
| `signal32` | `op signal32 (as float32: value) as int64` | `int64` |
| `signal16` | `op signal16 (as float16: value) as int64` | `int64` |
| `minimumFloat64` | `op minimumFloat64 (as float64: left, as float64: right) as float64` | `float64` |
| `minimumFloat32` | `op minimumFloat32 (as float32: left, as float32: right) as float32` | `float32` |
| `minimumFloat16` | `op minimumFloat16 (as float16: left, as float16: right) as float16` | `float16` |
| `maximumFloat64` | `op maximumFloat64 (as float64: left, as float64: right) as float64` | `float64` |
| `maximumFloat32` | `op maximumFloat32 (as float32: left, as float32: right) as float32` | `float32` |
| `maximumFloat16` | `op maximumFloat16 (as float16: left, as float16: right) as float16` | `float16` |
| `constrain64` | `op constrain64 (as float64: val, as float64: min_val, as float64: max_val) as float64` | `float64` |
| `constrain32` | `op constrain32 (as float32: val, as float32: min_val, as float32: max_val) as float32` | `float32` |
| `constrain16` | `op constrain16 (as float16: val, as float16: min_val, as float16: max_val) as float16` | `float16` |
| `linearInterpolation64` | `op linearInterpolation64 (as float64: start, as float64: stop, as float64: factor) as float64` | `float64` |
| `linearInterpolation32` | `op linearInterpolation32 (as float32: start, as float32: stop, as float32: factor) as float32` | `float32` |
| `linearInterpolation16` | `op linearInterpolation16 (as float16: start, as float16: stop, as float16: factor) as float16` | `float16` |

#### Operation Technical Specifications:

##### `op absolute64`
```flux
op absolute64 (as int64: value) as int64
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `absolute64` functionality within the `FloatElementaryContract` domain.

##### `op absolute32`
```flux
op absolute32 (as int32: value) as int32
```
- **Parameters**:
  - `value` (`int32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `absolute32` functionality within the `FloatElementaryContract` domain.

##### `op absolute16`
```flux
op absolute16 (as int16: value) as int16
```
- **Parameters**:
  - `value` (`int16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `absolute16` functionality within the `FloatElementaryContract` domain.

##### `op minimum64`
```flux
op minimum64 (as int64: left, as int64: right) as int64
```
- **Parameters**:
  - `left` (`int64`): Input argument for operation execution.
  - `right` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `minimum64` functionality within the `FloatElementaryContract` domain.

##### `op minimum32`
```flux
op minimum32 (as int32: left, as int32: right) as int32
```
- **Parameters**:
  - `left` (`int32`): Input argument for operation execution.
  - `right` (`int32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `minimum32` functionality within the `FloatElementaryContract` domain.

##### `op minimum16`
```flux
op minimum16 (as int16: left, as int16: right) as int16
```
- **Parameters**:
  - `left` (`int16`): Input argument for operation execution.
  - `right` (`int16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `minimum16` functionality within the `FloatElementaryContract` domain.

##### `op maximum64`
```flux
op maximum64 (as int64: left, as int64: right) as int64
```
- **Parameters**:
  - `left` (`int64`): Input argument for operation execution.
  - `right` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `maximum64` functionality within the `FloatElementaryContract` domain.

##### `op maximum32`
```flux
op maximum32 (as int32: left, as int32: right) as int32
```
- **Parameters**:
  - `left` (`int32`): Input argument for operation execution.
  - `right` (`int32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `maximum32` functionality within the `FloatElementaryContract` domain.

##### `op maximum16`
```flux
op maximum16 (as int16: left, as int16: right) as int16
```
- **Parameters**:
  - `left` (`int16`): Input argument for operation execution.
  - `right` (`int16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `maximum16` functionality within the `FloatElementaryContract` domain.

##### `op absoluteFloat64`
```flux
op absoluteFloat64 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `absoluteFloat64` functionality within the `FloatElementaryContract` domain.

##### `op absoluteFloat32`
```flux
op absoluteFloat32 (as float32: value) as float32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `absoluteFloat32` functionality within the `FloatElementaryContract` domain.

##### `op absoluteFloat16`
```flux
op absoluteFloat16 (as float16: value) as float16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `absoluteFloat16` functionality within the `FloatElementaryContract` domain.

##### `op signal64`
```flux
op signal64 (as float64: value) as int64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `signal64` functionality within the `FloatElementaryContract` domain.

##### `op signal32`
```flux
op signal32 (as float32: value) as int64
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `signal32` functionality within the `FloatElementaryContract` domain.

##### `op signal16`
```flux
op signal16 (as float16: value) as int64
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `signal16` functionality within the `FloatElementaryContract` domain.

##### `op minimumFloat64`
```flux
op minimumFloat64 (as float64: left, as float64: right) as float64
```
- **Parameters**:
  - `left` (`float64`): Input argument for operation execution.
  - `right` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `minimumFloat64` functionality within the `FloatElementaryContract` domain.

##### `op minimumFloat32`
```flux
op minimumFloat32 (as float32: left, as float32: right) as float32
```
- **Parameters**:
  - `left` (`float32`): Input argument for operation execution.
  - `right` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `minimumFloat32` functionality within the `FloatElementaryContract` domain.

##### `op minimumFloat16`
```flux
op minimumFloat16 (as float16: left, as float16: right) as float16
```
- **Parameters**:
  - `left` (`float16`): Input argument for operation execution.
  - `right` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `minimumFloat16` functionality within the `FloatElementaryContract` domain.

##### `op maximumFloat64`
```flux
op maximumFloat64 (as float64: left, as float64: right) as float64
```
- **Parameters**:
  - `left` (`float64`): Input argument for operation execution.
  - `right` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `maximumFloat64` functionality within the `FloatElementaryContract` domain.

##### `op maximumFloat32`
```flux
op maximumFloat32 (as float32: left, as float32: right) as float32
```
- **Parameters**:
  - `left` (`float32`): Input argument for operation execution.
  - `right` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `maximumFloat32` functionality within the `FloatElementaryContract` domain.

##### `op maximumFloat16`
```flux
op maximumFloat16 (as float16: left, as float16: right) as float16
```
- **Parameters**:
  - `left` (`float16`): Input argument for operation execution.
  - `right` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `maximumFloat16` functionality within the `FloatElementaryContract` domain.

##### `op constrain64`
```flux
op constrain64 (as float64: val, as float64: min_val, as float64: max_val) as float64
```
- **Parameters**:
  - `val` (`float64`): Input argument for operation execution.
  - `min_val` (`float64`): Input argument for operation execution.
  - `max_val` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `constrain64` functionality within the `FloatElementaryContract` domain.

##### `op constrain32`
```flux
op constrain32 (as float32: val, as float32: min_val, as float32: max_val) as float32
```
- **Parameters**:
  - `val` (`float32`): Input argument for operation execution.
  - `min_val` (`float32`): Input argument for operation execution.
  - `max_val` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `constrain32` functionality within the `FloatElementaryContract` domain.

##### `op constrain16`
```flux
op constrain16 (as float16: val, as float16: min_val, as float16: max_val) as float16
```
- **Parameters**:
  - `val` (`float16`): Input argument for operation execution.
  - `min_val` (`float16`): Input argument for operation execution.
  - `max_val` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `constrain16` functionality within the `FloatElementaryContract` domain.

##### `op linearInterpolation64`
```flux
op linearInterpolation64 (as float64: start, as float64: stop, as float64: factor) as float64
```
- **Parameters**:
  - `start` (`float64`): Input argument for operation execution.
  - `stop` (`float64`): Input argument for operation execution.
  - `factor` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `linearInterpolation64` functionality within the `FloatElementaryContract` domain.

##### `op linearInterpolation32`
```flux
op linearInterpolation32 (as float32: start, as float32: stop, as float32: factor) as float32
```
- **Parameters**:
  - `start` (`float32`): Input argument for operation execution.
  - `stop` (`float32`): Input argument for operation execution.
  - `factor` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `linearInterpolation32` functionality within the `FloatElementaryContract` domain.

##### `op linearInterpolation16`
```flux
op linearInterpolation16 (as float16: start, as float16: stop, as float16: factor) as float16
```
- **Parameters**:
  - `start` (`float16`): Input argument for operation execution.
  - `stop` (`float16`): Input argument for operation execution.
  - `factor` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `linearInterpolation16` functionality within the `FloatElementaryContract` domain.

### 4.6 Contract `HyperbolicContract` (`Hyperbolic.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `sinh64` | `op sinh64 (as float64: value) as float64` | `float64` |
| `sinh32` | `op sinh32 (as float32: value) as float32` | `float32` |
| `sinh16` | `op sinh16 (as float16: value) as float16` | `float16` |
| `cosh64` | `op cosh64 (as float64: value) as float64` | `float64` |
| `cosh32` | `op cosh32 (as float32: value) as float32` | `float32` |
| `cosh16` | `op cosh16 (as float16: value) as float16` | `float16` |
| `tanh64` | `op tanh64 (as float64: value) as float64` | `float64` |
| `tanh32` | `op tanh32 (as float32: value) as float32` | `float32` |
| `tanh16` | `op tanh16 (as float16: value) as float16` | `float16` |
| `arcSinh64` | `op arcSinh64 (as float64: value) as float64` | `float64` |
| `arcSinh32` | `op arcSinh32 (as float32: value) as float32` | `float32` |
| `arcSinh16` | `op arcSinh16 (as float16: value) as float16` | `float16` |
| `arcCosh64` | `op arcCosh64 (as float64: value) as float64` | `float64` |
| `arcCosh32` | `op arcCosh32 (as float32: value) as float32` | `float32` |
| `arcCosh16` | `op arcCosh16 (as float16: value) as float16` | `float16` |
| `arcTanh64` | `op arcTanh64 (as float64: value) as float64` | `float64` |
| `arcTanh32` | `op arcTanh32 (as float32: value) as float32` | `float32` |
| `arcTanh16` | `op arcTanh16 (as float16: value) as float16` | `float16` |
| `sech64` | `op sech64 (as float64: value) as float64` | `float64` |
| `sech32` | `op sech32 (as float32: value) as float32` | `float32` |
| `sech16` | `op sech16 (as float16: value) as float16` | `float16` |
| `csch64` | `op csch64 (as float64: value) as float64` | `float64` |
| `csch32` | `op csch32 (as float32: value) as float32` | `float32` |
| `csch16` | `op csch16 (as float16: value) as float16` | `float16` |
| `coth64` | `op coth64 (as float64: value) as float64` | `float64` |
| `coth32` | `op coth32 (as float32: value) as float32` | `float32` |
| `coth16` | `op coth16 (as float16: value) as float16` | `float16` |
| `arcSech64` | `op arcSech64 (as float64: value) as float64` | `float64` |
| `arcSech32` | `op arcSech32 (as float32: value) as float32` | `float32` |
| `arcSech16` | `op arcSech16 (as float16: value) as float16` | `float16` |
| `arcCsch64` | `op arcCsch64 (as float64: value) as float64` | `float64` |
| `arcCsch32` | `op arcCsch32 (as float32: value) as float32` | `float32` |
| `arcCsch16` | `op arcCsch16 (as float16: value) as float16` | `float16` |
| `arcCoth64` | `op arcCoth64 (as float64: value) as float64` | `float64` |
| `arcCoth32` | `op arcCoth32 (as float32: value) as float32` | `float32` |
| `arcCoth16` | `op arcCoth16 (as float16: value) as float16` | `float16` |
| `arcTanh2_64` | `op arcTanh2_64 (as float64: y, as float64: x) as float64` | `float64` |
| `arcTanh2_32` | `op arcTanh2_32 (as float32: y, as float32: x) as float32` | `float32` |
| `arcTanh2_16` | `op arcTanh2_16 (as float16: y, as float16: x) as float16` | `float16` |

#### Operation Technical Specifications:

##### `op sinh64`
```flux
op sinh64 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `sinh64` functionality within the `HyperbolicContract` domain.

##### `op sinh32`
```flux
op sinh32 (as float32: value) as float32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `sinh32` functionality within the `HyperbolicContract` domain.

##### `op sinh16`
```flux
op sinh16 (as float16: value) as float16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `sinh16` functionality within the `HyperbolicContract` domain.

##### `op cosh64`
```flux
op cosh64 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `cosh64` functionality within the `HyperbolicContract` domain.

##### `op cosh32`
```flux
op cosh32 (as float32: value) as float32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `cosh32` functionality within the `HyperbolicContract` domain.

##### `op cosh16`
```flux
op cosh16 (as float16: value) as float16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `cosh16` functionality within the `HyperbolicContract` domain.

##### `op tanh64`
```flux
op tanh64 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `tanh64` functionality within the `HyperbolicContract` domain.

##### `op tanh32`
```flux
op tanh32 (as float32: value) as float32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `tanh32` functionality within the `HyperbolicContract` domain.

##### `op tanh16`
```flux
op tanh16 (as float16: value) as float16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `tanh16` functionality within the `HyperbolicContract` domain.

##### `op arcSinh64`
```flux
op arcSinh64 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `arcSinh64` functionality within the `HyperbolicContract` domain.

##### `op arcSinh32`
```flux
op arcSinh32 (as float32: value) as float32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `arcSinh32` functionality within the `HyperbolicContract` domain.

##### `op arcSinh16`
```flux
op arcSinh16 (as float16: value) as float16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `arcSinh16` functionality within the `HyperbolicContract` domain.

##### `op arcCosh64`
```flux
op arcCosh64 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ⚠️ Emits `fail` with status message `"dominio de arcCosh: [1, inf)"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `arcCosh64` functionality within the `HyperbolicContract` domain.

##### `op arcCosh32`
```flux
op arcCosh32 (as float32: value) as float32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ⚠️ Emits `fail` with status message `"dominio de arcCosh: [1, inf)"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `arcCosh32` functionality within the `HyperbolicContract` domain.

##### `op arcCosh16`
```flux
op arcCosh16 (as float16: value) as float16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ⚠️ Emits `fail` with status message `"dominio de arcCosh: [1, inf)"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `arcCosh16` functionality within the `HyperbolicContract` domain.

##### `op arcTanh64`
```flux
op arcTanh64 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ⚠️ Emits `fail` with status message `"dominio de arcTanh: (-1, 1)"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `arcTanh64` functionality within the `HyperbolicContract` domain.

##### `op arcTanh32`
```flux
op arcTanh32 (as float32: value) as float32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ⚠️ Emits `fail` with status message `"dominio de arcTanh: (-1, 1)"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `arcTanh32` functionality within the `HyperbolicContract` domain.

##### `op arcTanh16`
```flux
op arcTanh16 (as float16: value) as float16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ⚠️ Emits `fail` with status message `"dominio de arcTanh: (-1, 1)"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `arcTanh16` functionality within the `HyperbolicContract` domain.

##### `op sech64`
```flux
op sech64 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `sech64` functionality within the `HyperbolicContract` domain.

##### `op sech32`
```flux
op sech32 (as float32: value) as float32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `sech32` functionality within the `HyperbolicContract` domain.

##### `op sech16`
```flux
op sech16 (as float16: value) as float16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `sech16` functionality within the `HyperbolicContract` domain.

##### `op csch64`
```flux
op csch64 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ⚠️ Emits `fail` with status message `"cossecante hiperbolica indefinida para zero"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `csch64` functionality within the `HyperbolicContract` domain.

##### `op csch32`
```flux
op csch32 (as float32: value) as float32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `csch32` functionality within the `HyperbolicContract` domain.

##### `op csch16`
```flux
op csch16 (as float16: value) as float16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `csch16` functionality within the `HyperbolicContract` domain.

##### `op coth64`
```flux
op coth64 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ⚠️ Emits `fail` with status message `"cotangente hiperbolica indefinida para zero"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `coth64` functionality within the `HyperbolicContract` domain.

##### `op coth32`
```flux
op coth32 (as float32: value) as float32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `coth32` functionality within the `HyperbolicContract` domain.

##### `op coth16`
```flux
op coth16 (as float16: value) as float16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `coth16` functionality within the `HyperbolicContract` domain.

##### `op arcSech64`
```flux
op arcSech64 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ⚠️ Emits `fail` with status message `"dominio de arcSech: (0, 1]"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `arcSech64` functionality within the `HyperbolicContract` domain.

##### `op arcSech32`
```flux
op arcSech32 (as float32: value) as float32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `arcSech32` functionality within the `HyperbolicContract` domain.

##### `op arcSech16`
```flux
op arcSech16 (as float16: value) as float16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `arcSech16` functionality within the `HyperbolicContract` domain.

##### `op arcCsch64`
```flux
op arcCsch64 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ⚠️ Emits `fail` with status message `"dominio de arcCsch: (-inf, 0) U (0, inf)"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `arcCsch64` functionality within the `HyperbolicContract` domain.

##### `op arcCsch32`
```flux
op arcCsch32 (as float32: value) as float32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `arcCsch32` functionality within the `HyperbolicContract` domain.

##### `op arcCsch16`
```flux
op arcCsch16 (as float16: value) as float16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `arcCsch16` functionality within the `HyperbolicContract` domain.

##### `op arcCoth64`
```flux
op arcCoth64 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ⚠️ Emits `fail` with status message `"dominio de arcCoth: (-inf, -1) U (1, inf)"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `arcCoth64` functionality within the `HyperbolicContract` domain.

##### `op arcCoth32`
```flux
op arcCoth32 (as float32: value) as float32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `arcCoth32` functionality within the `HyperbolicContract` domain.

##### `op arcCoth16`
```flux
op arcCoth16 (as float16: value) as float16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `arcCoth16` functionality within the `HyperbolicContract` domain.

##### `op arcTanh2_64`
```flux
op arcTanh2_64 (as float64: y, as float64: x) as float64
```
- **Parameters**:
  - `y` (`float64`): Input argument for operation execution.
  - `x` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ⚠️ Emits `fail` with status message `"arcTanh2 indefinido para x zero"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `arcTanh2_64` functionality within the `HyperbolicContract` domain.

##### `op arcTanh2_32`
```flux
op arcTanh2_32 (as float32: y, as float32: x) as float32
```
- **Parameters**:
  - `y` (`float32`): Input argument for operation execution.
  - `x` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `arcTanh2_32` functionality within the `HyperbolicContract` domain.

##### `op arcTanh2_16`
```flux
op arcTanh2_16 (as float16: y, as float16: x) as float16
```
- **Parameters**:
  - `y` (`float16`): Input argument for operation execution.
  - `x` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `arcTanh2_16` functionality within the `HyperbolicContract` domain.

### 4.7 Contract `MathConstantsContract` (`MathConstants.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `pi64` | `op pi64 () as float64` | `float64` |
| `pi32` | `op pi32 () as float32` | `float32` |
| `pi16` | `op pi16 () as float16` | `float16` |
| `e64` | `op e64 () as float64` | `float64` |
| `e32` | `op e32 () as float32` | `float32` |
| `e16` | `op e16 () as float16` | `float16` |
| `tau64` | `op tau64 () as float64` | `float64` |
| `tau32` | `op tau32 () as float32` | `float32` |
| `tau16` | `op tau16 () as float16` | `float16` |
| `sqrt2_64` | `op sqrt2_64 () as float64` | `float64` |
| `sqrt2_32` | `op sqrt2_32 () as float32` | `float32` |
| `sqrt2_16` | `op sqrt2_16 () as float16` | `float16` |
| `sqrt3_64` | `op sqrt3_64 () as float64` | `float64` |
| `sqrt3_32` | `op sqrt3_32 () as float32` | `float32` |
| `sqrt3_16` | `op sqrt3_16 () as float16` | `float16` |
| `invSqrt2_64` | `op invSqrt2_64 () as float64` | `float64` |
| `invSqrt2_32` | `op invSqrt2_32 () as float32` | `float32` |
| `invSqrt2_16` | `op invSqrt2_16 () as float16` | `float16` |
| `invSqrt3_64` | `op invSqrt3_64 () as float64` | `float64` |
| `invSqrt3_32` | `op invSqrt3_32 () as float32` | `float32` |
| `invSqrt3_16` | `op invSqrt3_16 () as float16` | `float16` |
| `ln2_64` | `op ln2_64 () as float64` | `float64` |
| `ln2_32` | `op ln2_32 () as float32` | `float32` |
| `ln2_16` | `op ln2_16 () as float16` | `float16` |
| `ln10_64` | `op ln10_64 () as float64` | `float64` |
| `ln10_32` | `op ln10_32 () as float32` | `float32` |
| `ln10_16` | `op ln10_16 () as float16` | `float16` |
| `log2e64` | `op log2e64 () as float64` | `float64` |
| `log2e32` | `op log2e32 () as float32` | `float32` |
| `log2e16` | `op log2e16 () as float16` | `float16` |
| `log10e64` | `op log10e64 () as float64` | `float64` |
| `log10e32` | `op log10e32 () as float32` | `float32` |
| `log10e16` | `op log10e16 () as float16` | `float16` |
| `pi_2_64` | `op pi_2_64 () as float64` | `float64` |
| `pi_2_32` | `op pi_2_32 () as float32` | `float32` |
| `pi_2_16` | `op pi_2_16 () as float16` | `float16` |
| `pi_4_64` | `op pi_4_64 () as float64` | `float64` |
| `pi_4_32` | `op pi_4_32 () as float32` | `float32` |
| `pi_4_16` | `op pi_4_16 () as float16` | `float16` |
| `invPi64` | `op invPi64 () as float64` | `float64` |
| `invPi32` | `op invPi32 () as float32` | `float32` |
| `invPi16` | `op invPi16 () as float16` | `float16` |
| `phi64` | `op phi64 () as float64` | `float64` |
| `phi32` | `op phi32 () as float32` | `float32` |
| `phi16` | `op phi16 () as float16` | `float16` |

#### Operation Technical Specifications:

##### `op pi64`
```flux
op pi64 () as float64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `pi64` functionality within the `MathConstantsContract` domain.

##### `op pi32`
```flux
op pi32 () as float32
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `pi32` functionality within the `MathConstantsContract` domain.

##### `op pi16`
```flux
op pi16 () as float16
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `pi16` functionality within the `MathConstantsContract` domain.

##### `op e64`
```flux
op e64 () as float64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `e64` functionality within the `MathConstantsContract` domain.

##### `op e32`
```flux
op e32 () as float32
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `e32` functionality within the `MathConstantsContract` domain.

##### `op e16`
```flux
op e16 () as float16
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `e16` functionality within the `MathConstantsContract` domain.

##### `op tau64`
```flux
op tau64 () as float64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `tau64` functionality within the `MathConstantsContract` domain.

##### `op tau32`
```flux
op tau32 () as float32
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `tau32` functionality within the `MathConstantsContract` domain.

##### `op tau16`
```flux
op tau16 () as float16
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `tau16` functionality within the `MathConstantsContract` domain.

##### `op sqrt2_64`
```flux
op sqrt2_64 () as float64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `sqrt2_64` functionality within the `MathConstantsContract` domain.

##### `op sqrt2_32`
```flux
op sqrt2_32 () as float32
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `sqrt2_32` functionality within the `MathConstantsContract` domain.

##### `op sqrt2_16`
```flux
op sqrt2_16 () as float16
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `sqrt2_16` functionality within the `MathConstantsContract` domain.

##### `op sqrt3_64`
```flux
op sqrt3_64 () as float64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `sqrt3_64` functionality within the `MathConstantsContract` domain.

##### `op sqrt3_32`
```flux
op sqrt3_32 () as float32
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `sqrt3_32` functionality within the `MathConstantsContract` domain.

##### `op sqrt3_16`
```flux
op sqrt3_16 () as float16
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `sqrt3_16` functionality within the `MathConstantsContract` domain.

##### `op invSqrt2_64`
```flux
op invSqrt2_64 () as float64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `invSqrt2_64` functionality within the `MathConstantsContract` domain.

##### `op invSqrt2_32`
```flux
op invSqrt2_32 () as float32
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `invSqrt2_32` functionality within the `MathConstantsContract` domain.

##### `op invSqrt2_16`
```flux
op invSqrt2_16 () as float16
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `invSqrt2_16` functionality within the `MathConstantsContract` domain.

##### `op invSqrt3_64`
```flux
op invSqrt3_64 () as float64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `invSqrt3_64` functionality within the `MathConstantsContract` domain.

##### `op invSqrt3_32`
```flux
op invSqrt3_32 () as float32
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `invSqrt3_32` functionality within the `MathConstantsContract` domain.

##### `op invSqrt3_16`
```flux
op invSqrt3_16 () as float16
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `invSqrt3_16` functionality within the `MathConstantsContract` domain.

##### `op ln2_64`
```flux
op ln2_64 () as float64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `ln2_64` functionality within the `MathConstantsContract` domain.

##### `op ln2_32`
```flux
op ln2_32 () as float32
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `ln2_32` functionality within the `MathConstantsContract` domain.

##### `op ln2_16`
```flux
op ln2_16 () as float16
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `ln2_16` functionality within the `MathConstantsContract` domain.

##### `op ln10_64`
```flux
op ln10_64 () as float64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `ln10_64` functionality within the `MathConstantsContract` domain.

##### `op ln10_32`
```flux
op ln10_32 () as float32
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `ln10_32` functionality within the `MathConstantsContract` domain.

##### `op ln10_16`
```flux
op ln10_16 () as float16
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `ln10_16` functionality within the `MathConstantsContract` domain.

##### `op log2e64`
```flux
op log2e64 () as float64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `log2e64` functionality within the `MathConstantsContract` domain.

##### `op log2e32`
```flux
op log2e32 () as float32
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `log2e32` functionality within the `MathConstantsContract` domain.

##### `op log2e16`
```flux
op log2e16 () as float16
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `log2e16` functionality within the `MathConstantsContract` domain.

##### `op log10e64`
```flux
op log10e64 () as float64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `log10e64` functionality within the `MathConstantsContract` domain.

##### `op log10e32`
```flux
op log10e32 () as float32
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `log10e32` functionality within the `MathConstantsContract` domain.

##### `op log10e16`
```flux
op log10e16 () as float16
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `log10e16` functionality within the `MathConstantsContract` domain.

##### `op pi_2_64`
```flux
op pi_2_64 () as float64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `pi_2_64` functionality within the `MathConstantsContract` domain.

##### `op pi_2_32`
```flux
op pi_2_32 () as float32
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `pi_2_32` functionality within the `MathConstantsContract` domain.

##### `op pi_2_16`
```flux
op pi_2_16 () as float16
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `pi_2_16` functionality within the `MathConstantsContract` domain.

##### `op pi_4_64`
```flux
op pi_4_64 () as float64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `pi_4_64` functionality within the `MathConstantsContract` domain.

##### `op pi_4_32`
```flux
op pi_4_32 () as float32
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `pi_4_32` functionality within the `MathConstantsContract` domain.

##### `op pi_4_16`
```flux
op pi_4_16 () as float16
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `pi_4_16` functionality within the `MathConstantsContract` domain.

##### `op invPi64`
```flux
op invPi64 () as float64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `invPi64` functionality within the `MathConstantsContract` domain.

##### `op invPi32`
```flux
op invPi32 () as float32
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `invPi32` functionality within the `MathConstantsContract` domain.

##### `op invPi16`
```flux
op invPi16 () as float16
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `invPi16` functionality within the `MathConstantsContract` domain.

##### `op phi64`
```flux
op phi64 () as float64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `phi64` functionality within the `MathConstantsContract` domain.

##### `op phi32`
```flux
op phi32 () as float32
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `phi32` functionality within the `MathConstantsContract` domain.

##### `op phi16`
```flux
op phi16 () as float16
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `phi16` functionality within the `MathConstantsContract` domain.

### 4.8 Contract `RootsAndRoundingContract` (`RootsAndRounding.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `squareRoot64` | `op squareRoot64 (as float64: value) as float64` | `float64` |
| `squareRoot32` | `op squareRoot32 (as float32: value) as float32` | `float32` |
| `squareRoot16` | `op squareRoot16 (as float16: value) as float16` | `float16` |
| `cubeRoot64` | `op cubeRoot64 (as float64: value) as float64` | `float64` |
| `cubeRoot32` | `op cubeRoot32 (as float32: value) as float32` | `float32` |
| `cubeRoot16` | `op cubeRoot16 (as float16: value) as float16` | `float16` |
| `integerSquareRoot64` | `op integerSquareRoot64 (as int64: value) as int64` | `int64` |
| `integerSquareRoot32` | `op integerSquareRoot32 (as int32: value) as int32` | `int32` |
| `integerSquareRoot16` | `op integerSquareRoot16 (as int16: value) as int16` | `int16` |
| `floor64` | `op floor64 (as float64: value) as int64` | `int64` |
| `floor32` | `op floor32 (as float32: value) as int32` | `int32` |
| `floor16` | `op floor16 (as float16: value) as int16` | `int16` |
| `ceil64` | `op ceil64 (as float64: value) as int64` | `int64` |
| `ceil32` | `op ceil32 (as float32: value) as int32` | `int32` |
| `ceil16` | `op ceil16 (as float16: value) as int16` | `int16` |
| `round64` | `op round64 (as float64: value) as int64` | `int64` |
| `round32` | `op round32 (as float32: value) as int32` | `int32` |
| `round16` | `op round16 (as float16: value) as int16` | `int16` |
| `roundToInt64` | `op roundToInt64 (as float64: value) as int64` | `int64` |
| `roundToInt32` | `op roundToInt32 (as float32: value) as int32` | `int32` |
| `roundToInt16` | `op roundToInt16 (as float16: value) as int16` | `int16` |
| `truncate64` | `op truncate64 (as float64: value) as int64` | `int64` |
| `truncate32` | `op truncate32 (as float32: value) as int32` | `int32` |
| `truncate16` | `op truncate16 (as float16: value) as int16` | `int16` |

#### Operation Technical Specifications:

##### `op squareRoot64`
```flux
op squareRoot64 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ⚠️ Emits `fail` with status message `"raiz quadrada de numero negativo"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `squareRoot64` functionality within the `RootsAndRoundingContract` domain.

##### `op squareRoot32`
```flux
op squareRoot32 (as float32: value) as float32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ⚠️ Emits `fail` with status message `"raiz quadrada de numero negativo"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `squareRoot32` functionality within the `RootsAndRoundingContract` domain.

##### `op squareRoot16`
```flux
op squareRoot16 (as float16: value) as float16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ⚠️ Emits `fail` with status message `"raiz quadrada de numero negativo"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `squareRoot16` functionality within the `RootsAndRoundingContract` domain.

##### `op cubeRoot64`
```flux
op cubeRoot64 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `cubeRoot64` functionality within the `RootsAndRoundingContract` domain.

##### `op cubeRoot32`
```flux
op cubeRoot32 (as float32: value) as float32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `cubeRoot32` functionality within the `RootsAndRoundingContract` domain.

##### `op cubeRoot16`
```flux
op cubeRoot16 (as float16: value) as float16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `cubeRoot16` functionality within the `RootsAndRoundingContract` domain.

##### `op integerSquareRoot64`
```flux
op integerSquareRoot64 (as int64: value) as int64
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ⚠️ Emits `fail` with status message `"raiz quadrada inteira de numero negativo"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `integerSquareRoot64` functionality within the `RootsAndRoundingContract` domain.

##### `op integerSquareRoot32`
```flux
op integerSquareRoot32 (as int32: value) as int32
```
- **Parameters**:
  - `value` (`int32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int32`
  - ⚠️ Emits `fail` with status message `"raiz quadrada inteira de numero negativo"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `integerSquareRoot32` functionality within the `RootsAndRoundingContract` domain.

##### `op integerSquareRoot16`
```flux
op integerSquareRoot16 (as int16: value) as int16
```
- **Parameters**:
  - `value` (`int16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int16`
  - ⚠️ Emits `fail` with status message `"raiz quadrada inteira de numero negativo"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `integerSquareRoot16` functionality within the `RootsAndRoundingContract` domain.

##### `op floor64`
```flux
op floor64 (as float64: value) as int64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `floor64` functionality within the `RootsAndRoundingContract` domain.

##### `op floor32`
```flux
op floor32 (as float32: value) as int32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `floor32` functionality within the `RootsAndRoundingContract` domain.

##### `op floor16`
```flux
op floor16 (as float16: value) as int16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `floor16` functionality within the `RootsAndRoundingContract` domain.

##### `op ceil64`
```flux
op ceil64 (as float64: value) as int64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `ceil64` functionality within the `RootsAndRoundingContract` domain.

##### `op ceil32`
```flux
op ceil32 (as float32: value) as int32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `ceil32` functionality within the `RootsAndRoundingContract` domain.

##### `op ceil16`
```flux
op ceil16 (as float16: value) as int16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `ceil16` functionality within the `RootsAndRoundingContract` domain.

##### `op round64`
```flux
op round64 (as float64: value) as int64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `round64` functionality within the `RootsAndRoundingContract` domain.

##### `op round32`
```flux
op round32 (as float32: value) as int32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `round32` functionality within the `RootsAndRoundingContract` domain.

##### `op round16`
```flux
op round16 (as float16: value) as int16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `round16` functionality within the `RootsAndRoundingContract` domain.

##### `op roundToInt64`
```flux
op roundToInt64 (as float64: value) as int64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `roundToInt64` functionality within the `RootsAndRoundingContract` domain.

##### `op roundToInt32`
```flux
op roundToInt32 (as float32: value) as int32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `roundToInt32` functionality within the `RootsAndRoundingContract` domain.

##### `op roundToInt16`
```flux
op roundToInt16 (as float16: value) as int16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `roundToInt16` functionality within the `RootsAndRoundingContract` domain.

##### `op truncate64`
```flux
op truncate64 (as float64: value) as int64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `truncate64` functionality within the `RootsAndRoundingContract` domain.

##### `op truncate32`
```flux
op truncate32 (as float32: value) as int32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `truncate32` functionality within the `RootsAndRoundingContract` domain.

##### `op truncate16`
```flux
op truncate16 (as float16: value) as int16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `truncate16` functionality within the `RootsAndRoundingContract` domain.

### 4.9 Contract `SpecialFunctionsContract` (`SpecialFunctions.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `errorFunction64` | `op errorFunction64 (as float64: value) as float64` | `float64` |
| `errorFunction32` | `op errorFunction32 (as float32: value) as float32` | `float32` |
| `errorFunction16` | `op errorFunction16 (as float16: value) as float16` | `float16` |
| `gammaFunction64` | `op gammaFunction64 (as float64: value) as float64` | `float64` |
| `gammaFunction32` | `op gammaFunction32 (as float32: value) as float32` | `float32` |
| `gammaFunction16` | `op gammaFunction16 (as float16: value) as float16` | `float16` |
| `erfc64` | `op erfc64 (as float64: value) as float64` | `float64` |
| `erfc32` | `op erfc32 (as float32: value) as float32` | `float32` |
| `erfc16` | `op erfc16 (as float16: value) as float16` | `float16` |
| `erfinv64` | `op erfinv64 (as float64: value) as float64` | `float64` |
| `erfinv32` | `op erfinv32 (as float32: value) as float32` | `float32` |
| `erfinv16` | `op erfinv16 (as float16: value) as float16` | `float16` |
| `logGamma64` | `op logGamma64 (as float64: value) as float64` | `float64` |
| `logGamma32` | `op logGamma32 (as float32: value) as float32` | `float32` |
| `logGamma16` | `op logGamma16 (as float16: value) as float16` | `float16` |
| `digamma64` | `op digamma64 (as float64: value) as float64` | `float64` |
| `digamma32` | `op digamma32 (as float32: value) as float32` | `float32` |
| `digamma16` | `op digamma16 (as float16: value) as float16` | `float16` |
| `sigmoid64` | `op sigmoid64 (as float64: value) as float64` | `float64` |
| `sigmoid32` | `op sigmoid32 (as float32: value) as float32` | `float32` |
| `sigmoid16` | `op sigmoid16 (as float16: value) as float16` | `float16` |
| `normalCdf64` | `op normalCdf64 (as float64: value) as float64` | `float64` |
| `normalCdf32` | `op normalCdf32 (as float32: value) as float32` | `float32` |
| `normalCdf16` | `op normalCdf16 (as float16: value) as float16` | `float16` |
| `besselJ0_64` | `op besselJ0_64 (as float64: value) as float64` | `float64` |
| `besselJ0_32` | `op besselJ0_32 (as float32: value) as float32` | `float32` |
| `besselJ0_16` | `op besselJ0_16 (as float16: value) as float16` | `float16` |
| `besselJ1_64` | `op besselJ1_64 (as float64: value) as float64` | `float64` |
| `besselJ1_32` | `op besselJ1_32 (as float32: value) as float32` | `float32` |
| `besselJ1_16` | `op besselJ1_16 (as float16: value) as float16` | `float16` |
| `ulp64` | `op ulp64 (as float64: value) as float64` | `float64` |
| `ulp32` | `op ulp32 (as float32: value) as float32` | `float32` |
| `ulp16` | `op ulp16 (as float16: value) as float16` | `float16` |
| `fract64` | `op fract64 (as float64: value) as float64` | `float64` |
| `fract32` | `op fract32 (as float32: value) as float32` | `float32` |
| `fract16` | `op fract16 (as float16: value) as float16` | `float16` |
| `wrapAngle64` | `op wrapAngle64 (as float64: value) as float64` | `float64` |
| `wrapAngle32` | `op wrapAngle32 (as float32: value) as float32` | `float32` |
| `wrapAngle16` | `op wrapAngle16 (as float16: value) as float16` | `float16` |
| `beta64` | `op beta64 (as float64: a, as float64: b) as float64` | `float64` |
| `beta32` | `op beta32 (as float32: a, as float32: b) as float32` | `float32` |
| `beta16` | `op beta16 (as float16: a, as float16: b) as float16` | `float16` |
| `logBeta64` | `op logBeta64 (as float64: a, as float64: b) as float64` | `float64` |
| `logBeta32` | `op logBeta32 (as float32: a, as float32: b) as float32` | `float32` |
| `logBeta16` | `op logBeta16 (as float16: a, as float16: b) as float16` | `float16` |
| `fdim64` | `op fdim64 (as float64: a, as float64: b) as float64` | `float64` |
| `fdim32` | `op fdim32 (as float32: a, as float32: b) as float32` | `float32` |
| `fdim16` | `op fdim16 (as float16: a, as float16: b) as float16` | `float16` |
| `step64` | `op step64 (as float64: a, as float64: b) as float64` | `float64` |
| `step32` | `op step32 (as float32: a, as float32: b) as float32` | `float32` |
| `step16` | `op step16 (as float16: a, as float16: b) as float16` | `float16` |
| `isCloseTo64` | `op isCloseTo64 (as float64: a, as float64: b) as bool` | `bool` |
| `isCloseTo32` | `op isCloseTo32 (as float32: a, as float32: b) as bool` | `bool` |
| `isCloseTo16` | `op isCloseTo16 (as float16: a, as float16: b) as bool` | `bool` |
| `signbit64` | `op signbit64 (as float64: value) as bool` | `bool` |
| `signbit32` | `op signbit32 (as float32: value) as bool` | `bool` |
| `signbit16` | `op signbit16 (as float16: value) as bool` | `bool` |
| `copySign64` | `op copySign64 (as float64: magnitude, as float64: sign_source) as float64` | `float64` |
| `copySign32` | `op copySign32 (as float32: magnitude, as float32: sign_source) as float32` | `float32` |
| `copySign16` | `op copySign16 (as float16: magnitude, as float16: sign_source) as float16` | `float16` |
| `nextRepresentable64` | `op nextRepresentable64 (as float64: magnitude, as float64: sign_source) as float64` | `float64` |
| `nextRepresentable32` | `op nextRepresentable32 (as float32: magnitude, as float32: sign_source) as float32` | `float32` |
| `nextRepresentable16` | `op nextRepresentable16 (as float16: magnitude, as float16: sign_source) as float16` | `float16` |
| `fusedMultiplyAdd64` | `op fusedMultiplyAdd64 (as float64: a, as float64: b, as float64: c) as float64` | `float64` |
| `fusedMultiplyAdd32` | `op fusedMultiplyAdd32 (as float32: a, as float32: b, as float32: c) as float32` | `float32` |
| `fusedMultiplyAdd16` | `op fusedMultiplyAdd16 (as float16: a, as float16: b, as float16: c) as float16` | `float16` |
| `ldexp64` | `op ldexp64 (as float64: x, as int64: exp_val) as float64` | `float64` |
| `ldexp32` | `op ldexp32 (as float32: x, as int32: exp_val) as float32` | `float32` |
| `ldexp16` | `op ldexp16 (as float16: x, as int16: exp_val) as float16` | `float16` |
| `smoothstep64` | `op smoothstep64 (as float64: edge0, as float64: edge1, as float64: x) as float64` | `float64` |
| `smoothstep32` | `op smoothstep32 (as float32: edge0, as float32: edge1, as float32: x) as float32` | `float32` |
| `smoothstep16` | `op smoothstep16 (as float16: edge0, as float16: edge1, as float16: x) as float16` | `float16` |
| `smootherstep64` | `op smootherstep64 (as float64: edge0, as float64: edge1, as float64: x) as float64` | `float64` |
| `smootherstep32` | `op smootherstep32 (as float32: edge0, as float32: edge1, as float32: x) as float32` | `float32` |
| `smootherstep16` | `op smootherstep16 (as float16: edge0, as float16: edge1, as float16: x) as float16` | `float16` |
| `inverseLinearInterpolation64` | `op inverseLinearInterpolation64 (as float64: a, as float64: b, as float64: val) as float64` | `float64` |
| `inverseLinearInterpolation32` | `op inverseLinearInterpolation32 (as float32: a, as float32: b, as float32: val) as float32` | `float32` |
| `inverseLinearInterpolation16` | `op inverseLinearInterpolation16 (as float16: a, as float16: b, as float16: val) as float16` | `float16` |
| `mapRange64` | `op mapRange64 (as float64: val, as float64: in_min, as float64: in_max, as float64: out_min, as float64: out_max) as float64` | `float64` |
| `mapRange32` | `op mapRange32 (as float32: val, as float32: in_min, as float32: in_max, as float32: out_min, as float32: out_max) as float32` | `float32` |
| `mapRange16` | `op mapRange16 (as float16: val, as float16: in_min, as float16: in_max, as float16: out_min, as float16: out_max) as float16` | `float16` |

#### Operation Technical Specifications:

##### `op errorFunction64`
```flux
op errorFunction64 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `errorFunction64` functionality within the `SpecialFunctionsContract` domain.

##### `op errorFunction32`
```flux
op errorFunction32 (as float32: value) as float32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `errorFunction32` functionality within the `SpecialFunctionsContract` domain.

##### `op errorFunction16`
```flux
op errorFunction16 (as float16: value) as float16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `errorFunction16` functionality within the `SpecialFunctionsContract` domain.

##### `op gammaFunction64`
```flux
op gammaFunction64 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gammaFunction64` functionality within the `SpecialFunctionsContract` domain.

##### `op gammaFunction32`
```flux
op gammaFunction32 (as float32: value) as float32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gammaFunction32` functionality within the `SpecialFunctionsContract` domain.

##### `op gammaFunction16`
```flux
op gammaFunction16 (as float16: value) as float16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gammaFunction16` functionality within the `SpecialFunctionsContract` domain.

##### `op erfc64`
```flux
op erfc64 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `erfc64` functionality within the `SpecialFunctionsContract` domain.

##### `op erfc32`
```flux
op erfc32 (as float32: value) as float32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `erfc32` functionality within the `SpecialFunctionsContract` domain.

##### `op erfc16`
```flux
op erfc16 (as float16: value) as float16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `erfc16` functionality within the `SpecialFunctionsContract` domain.

##### `op erfinv64`
```flux
op erfinv64 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ⚠️ Emits `fail` with status message `"dominio de erfinv: (-1, 1)"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `erfinv64` functionality within the `SpecialFunctionsContract` domain.

##### `op erfinv32`
```flux
op erfinv32 (as float32: value) as float32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `erfinv32` functionality within the `SpecialFunctionsContract` domain.

##### `op erfinv16`
```flux
op erfinv16 (as float16: value) as float16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `erfinv16` functionality within the `SpecialFunctionsContract` domain.

##### `op logGamma64`
```flux
op logGamma64 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ⚠️ Emits `fail` with status message `"dominio de logGamma: (0, inf)"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `logGamma64` functionality within the `SpecialFunctionsContract` domain.

##### `op logGamma32`
```flux
op logGamma32 (as float32: value) as float32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `logGamma32` functionality within the `SpecialFunctionsContract` domain.

##### `op logGamma16`
```flux
op logGamma16 (as float16: value) as float16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `logGamma16` functionality within the `SpecialFunctionsContract` domain.

##### `op digamma64`
```flux
op digamma64 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ⚠️ Emits `fail` with status message `"dominio de digamma: (0, inf)"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `digamma64` functionality within the `SpecialFunctionsContract` domain.

##### `op digamma32`
```flux
op digamma32 (as float32: value) as float32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `digamma32` functionality within the `SpecialFunctionsContract` domain.

##### `op digamma16`
```flux
op digamma16 (as float16: value) as float16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `digamma16` functionality within the `SpecialFunctionsContract` domain.

##### `op sigmoid64`
```flux
op sigmoid64 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `sigmoid64` functionality within the `SpecialFunctionsContract` domain.

##### `op sigmoid32`
```flux
op sigmoid32 (as float32: value) as float32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `sigmoid32` functionality within the `SpecialFunctionsContract` domain.

##### `op sigmoid16`
```flux
op sigmoid16 (as float16: value) as float16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `sigmoid16` functionality within the `SpecialFunctionsContract` domain.

##### `op normalCdf64`
```flux
op normalCdf64 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `normalCdf64` functionality within the `SpecialFunctionsContract` domain.

##### `op normalCdf32`
```flux
op normalCdf32 (as float32: value) as float32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `normalCdf32` functionality within the `SpecialFunctionsContract` domain.

##### `op normalCdf16`
```flux
op normalCdf16 (as float16: value) as float16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `normalCdf16` functionality within the `SpecialFunctionsContract` domain.

##### `op besselJ0_64`
```flux
op besselJ0_64 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `besselJ0_64` functionality within the `SpecialFunctionsContract` domain.

##### `op besselJ0_32`
```flux
op besselJ0_32 (as float32: value) as float32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `besselJ0_32` functionality within the `SpecialFunctionsContract` domain.

##### `op besselJ0_16`
```flux
op besselJ0_16 (as float16: value) as float16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `besselJ0_16` functionality within the `SpecialFunctionsContract` domain.

##### `op besselJ1_64`
```flux
op besselJ1_64 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `besselJ1_64` functionality within the `SpecialFunctionsContract` domain.

##### `op besselJ1_32`
```flux
op besselJ1_32 (as float32: value) as float32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `besselJ1_32` functionality within the `SpecialFunctionsContract` domain.

##### `op besselJ1_16`
```flux
op besselJ1_16 (as float16: value) as float16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `besselJ1_16` functionality within the `SpecialFunctionsContract` domain.

##### `op ulp64`
```flux
op ulp64 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `ulp64` functionality within the `SpecialFunctionsContract` domain.

##### `op ulp32`
```flux
op ulp32 (as float32: value) as float32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `ulp32` functionality within the `SpecialFunctionsContract` domain.

##### `op ulp16`
```flux
op ulp16 (as float16: value) as float16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `ulp16` functionality within the `SpecialFunctionsContract` domain.

##### `op fract64`
```flux
op fract64 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `fract64` functionality within the `SpecialFunctionsContract` domain.

##### `op fract32`
```flux
op fract32 (as float32: value) as float32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `fract32` functionality within the `SpecialFunctionsContract` domain.

##### `op fract16`
```flux
op fract16 (as float16: value) as float16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `fract16` functionality within the `SpecialFunctionsContract` domain.

##### `op wrapAngle64`
```flux
op wrapAngle64 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `wrapAngle64` functionality within the `SpecialFunctionsContract` domain.

##### `op wrapAngle32`
```flux
op wrapAngle32 (as float32: value) as float32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `wrapAngle32` functionality within the `SpecialFunctionsContract` domain.

##### `op wrapAngle16`
```flux
op wrapAngle16 (as float16: value) as float16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `wrapAngle16` functionality within the `SpecialFunctionsContract` domain.

##### `op beta64`
```flux
op beta64 (as float64: a, as float64: b) as float64
```
- **Parameters**:
  - `a` (`float64`): Input argument for operation execution.
  - `b` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ⚠️ Emits `fail` with status message `"dominio de beta: a > 0 e b > 0"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `beta64` functionality within the `SpecialFunctionsContract` domain.

##### `op beta32`
```flux
op beta32 (as float32: a, as float32: b) as float32
```
- **Parameters**:
  - `a` (`float32`): Input argument for operation execution.
  - `b` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `beta32` functionality within the `SpecialFunctionsContract` domain.

##### `op beta16`
```flux
op beta16 (as float16: a, as float16: b) as float16
```
- **Parameters**:
  - `a` (`float16`): Input argument for operation execution.
  - `b` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `beta16` functionality within the `SpecialFunctionsContract` domain.

##### `op logBeta64`
```flux
op logBeta64 (as float64: a, as float64: b) as float64
```
- **Parameters**:
  - `a` (`float64`): Input argument for operation execution.
  - `b` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ⚠️ Emits `fail` with status message `"dominio de logBeta: a > 0 e b > 0"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `logBeta64` functionality within the `SpecialFunctionsContract` domain.

##### `op logBeta32`
```flux
op logBeta32 (as float32: a, as float32: b) as float32
```
- **Parameters**:
  - `a` (`float32`): Input argument for operation execution.
  - `b` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `logBeta32` functionality within the `SpecialFunctionsContract` domain.

##### `op logBeta16`
```flux
op logBeta16 (as float16: a, as float16: b) as float16
```
- **Parameters**:
  - `a` (`float16`): Input argument for operation execution.
  - `b` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `logBeta16` functionality within the `SpecialFunctionsContract` domain.

##### `op fdim64`
```flux
op fdim64 (as float64: a, as float64: b) as float64
```
- **Parameters**:
  - `a` (`float64`): Input argument for operation execution.
  - `b` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `fdim64` functionality within the `SpecialFunctionsContract` domain.

##### `op fdim32`
```flux
op fdim32 (as float32: a, as float32: b) as float32
```
- **Parameters**:
  - `a` (`float32`): Input argument for operation execution.
  - `b` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `fdim32` functionality within the `SpecialFunctionsContract` domain.

##### `op fdim16`
```flux
op fdim16 (as float16: a, as float16: b) as float16
```
- **Parameters**:
  - `a` (`float16`): Input argument for operation execution.
  - `b` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `fdim16` functionality within the `SpecialFunctionsContract` domain.

##### `op step64`
```flux
op step64 (as float64: a, as float64: b) as float64
```
- **Parameters**:
  - `a` (`float64`): Input argument for operation execution.
  - `b` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `step64` functionality within the `SpecialFunctionsContract` domain.

##### `op step32`
```flux
op step32 (as float32: a, as float32: b) as float32
```
- **Parameters**:
  - `a` (`float32`): Input argument for operation execution.
  - `b` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `step32` functionality within the `SpecialFunctionsContract` domain.

##### `op step16`
```flux
op step16 (as float16: a, as float16: b) as float16
```
- **Parameters**:
  - `a` (`float16`): Input argument for operation execution.
  - `b` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `step16` functionality within the `SpecialFunctionsContract` domain.

##### `op isCloseTo64`
```flux
op isCloseTo64 (as float64: a, as float64: b) as bool
```
- **Parameters**:
  - `a` (`float64`): Input argument for operation execution.
  - `b` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `isCloseTo64` functionality within the `SpecialFunctionsContract` domain.

##### `op isCloseTo32`
```flux
op isCloseTo32 (as float32: a, as float32: b) as bool
```
- **Parameters**:
  - `a` (`float32`): Input argument for operation execution.
  - `b` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `isCloseTo32` functionality within the `SpecialFunctionsContract` domain.

##### `op isCloseTo16`
```flux
op isCloseTo16 (as float16: a, as float16: b) as bool
```
- **Parameters**:
  - `a` (`float16`): Input argument for operation execution.
  - `b` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `isCloseTo16` functionality within the `SpecialFunctionsContract` domain.

##### `op signbit64`
```flux
op signbit64 (as float64: value) as bool
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `signbit64` functionality within the `SpecialFunctionsContract` domain.

##### `op signbit32`
```flux
op signbit32 (as float32: value) as bool
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `signbit32` functionality within the `SpecialFunctionsContract` domain.

##### `op signbit16`
```flux
op signbit16 (as float16: value) as bool
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `signbit16` functionality within the `SpecialFunctionsContract` domain.

##### `op copySign64`
```flux
op copySign64 (as float64: magnitude, as float64: sign_source) as float64
```
- **Parameters**:
  - `magnitude` (`float64`): Input argument for operation execution.
  - `sign_source` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `copySign64` functionality within the `SpecialFunctionsContract` domain.

##### `op copySign32`
```flux
op copySign32 (as float32: magnitude, as float32: sign_source) as float32
```
- **Parameters**:
  - `magnitude` (`float32`): Input argument for operation execution.
  - `sign_source` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `copySign32` functionality within the `SpecialFunctionsContract` domain.

##### `op copySign16`
```flux
op copySign16 (as float16: magnitude, as float16: sign_source) as float16
```
- **Parameters**:
  - `magnitude` (`float16`): Input argument for operation execution.
  - `sign_source` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `copySign16` functionality within the `SpecialFunctionsContract` domain.

##### `op nextRepresentable64`
```flux
op nextRepresentable64 (as float64: magnitude, as float64: sign_source) as float64
```
- **Parameters**:
  - `magnitude` (`float64`): Input argument for operation execution.
  - `sign_source` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `nextRepresentable64` functionality within the `SpecialFunctionsContract` domain.

##### `op nextRepresentable32`
```flux
op nextRepresentable32 (as float32: magnitude, as float32: sign_source) as float32
```
- **Parameters**:
  - `magnitude` (`float32`): Input argument for operation execution.
  - `sign_source` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `nextRepresentable32` functionality within the `SpecialFunctionsContract` domain.

##### `op nextRepresentable16`
```flux
op nextRepresentable16 (as float16: magnitude, as float16: sign_source) as float16
```
- **Parameters**:
  - `magnitude` (`float16`): Input argument for operation execution.
  - `sign_source` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `nextRepresentable16` functionality within the `SpecialFunctionsContract` domain.

##### `op fusedMultiplyAdd64`
```flux
op fusedMultiplyAdd64 (as float64: a, as float64: b, as float64: c) as float64
```
- **Parameters**:
  - `a` (`float64`): Input argument for operation execution.
  - `b` (`float64`): Input argument for operation execution.
  - `c` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `fusedMultiplyAdd64` functionality within the `SpecialFunctionsContract` domain.

##### `op fusedMultiplyAdd32`
```flux
op fusedMultiplyAdd32 (as float32: a, as float32: b, as float32: c) as float32
```
- **Parameters**:
  - `a` (`float32`): Input argument for operation execution.
  - `b` (`float32`): Input argument for operation execution.
  - `c` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `fusedMultiplyAdd32` functionality within the `SpecialFunctionsContract` domain.

##### `op fusedMultiplyAdd16`
```flux
op fusedMultiplyAdd16 (as float16: a, as float16: b, as float16: c) as float16
```
- **Parameters**:
  - `a` (`float16`): Input argument for operation execution.
  - `b` (`float16`): Input argument for operation execution.
  - `c` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `fusedMultiplyAdd16` functionality within the `SpecialFunctionsContract` domain.

##### `op ldexp64`
```flux
op ldexp64 (as float64: x, as int64: exp_val) as float64
```
- **Parameters**:
  - `x` (`float64`): Input argument for operation execution.
  - `exp_val` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `ldexp64` functionality within the `SpecialFunctionsContract` domain.

##### `op ldexp32`
```flux
op ldexp32 (as float32: x, as int32: exp_val) as float32
```
- **Parameters**:
  - `x` (`float32`): Input argument for operation execution.
  - `exp_val` (`int32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `ldexp32` functionality within the `SpecialFunctionsContract` domain.

##### `op ldexp16`
```flux
op ldexp16 (as float16: x, as int16: exp_val) as float16
```
- **Parameters**:
  - `x` (`float16`): Input argument for operation execution.
  - `exp_val` (`int16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `ldexp16` functionality within the `SpecialFunctionsContract` domain.

##### `op smoothstep64`
```flux
op smoothstep64 (as float64: edge0, as float64: edge1, as float64: x) as float64
```
- **Parameters**:
  - `edge0` (`float64`): Input argument for operation execution.
  - `edge1` (`float64`): Input argument for operation execution.
  - `x` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ⚠️ Emits `fail` with status message `"smoothstep requer edge0 != edge1"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `smoothstep64` functionality within the `SpecialFunctionsContract` domain.

##### `op smoothstep32`
```flux
op smoothstep32 (as float32: edge0, as float32: edge1, as float32: x) as float32
```
- **Parameters**:
  - `edge0` (`float32`): Input argument for operation execution.
  - `edge1` (`float32`): Input argument for operation execution.
  - `x` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `smoothstep32` functionality within the `SpecialFunctionsContract` domain.

##### `op smoothstep16`
```flux
op smoothstep16 (as float16: edge0, as float16: edge1, as float16: x) as float16
```
- **Parameters**:
  - `edge0` (`float16`): Input argument for operation execution.
  - `edge1` (`float16`): Input argument for operation execution.
  - `x` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `smoothstep16` functionality within the `SpecialFunctionsContract` domain.

##### `op smootherstep64`
```flux
op smootherstep64 (as float64: edge0, as float64: edge1, as float64: x) as float64
```
- **Parameters**:
  - `edge0` (`float64`): Input argument for operation execution.
  - `edge1` (`float64`): Input argument for operation execution.
  - `x` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ⚠️ Emits `fail` with status message `"smootherstep requer edge0 != edge1"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `smootherstep64` functionality within the `SpecialFunctionsContract` domain.

##### `op smootherstep32`
```flux
op smootherstep32 (as float32: edge0, as float32: edge1, as float32: x) as float32
```
- **Parameters**:
  - `edge0` (`float32`): Input argument for operation execution.
  - `edge1` (`float32`): Input argument for operation execution.
  - `x` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `smootherstep32` functionality within the `SpecialFunctionsContract` domain.

##### `op smootherstep16`
```flux
op smootherstep16 (as float16: edge0, as float16: edge1, as float16: x) as float16
```
- **Parameters**:
  - `edge0` (`float16`): Input argument for operation execution.
  - `edge1` (`float16`): Input argument for operation execution.
  - `x` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `smootherstep16` functionality within the `SpecialFunctionsContract` domain.

##### `op inverseLinearInterpolation64`
```flux
op inverseLinearInterpolation64 (as float64: a, as float64: b, as float64: val) as float64
```
- **Parameters**:
  - `a` (`float64`): Input argument for operation execution.
  - `b` (`float64`): Input argument for operation execution.
  - `val` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ⚠️ Emits `fail` with status message `"interpolacao linear inversa requer a != b"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `inverseLinearInterpolation64` functionality within the `SpecialFunctionsContract` domain.

##### `op inverseLinearInterpolation32`
```flux
op inverseLinearInterpolation32 (as float32: a, as float32: b, as float32: val) as float32
```
- **Parameters**:
  - `a` (`float32`): Input argument for operation execution.
  - `b` (`float32`): Input argument for operation execution.
  - `val` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `inverseLinearInterpolation32` functionality within the `SpecialFunctionsContract` domain.

##### `op inverseLinearInterpolation16`
```flux
op inverseLinearInterpolation16 (as float16: a, as float16: b, as float16: val) as float16
```
- **Parameters**:
  - `a` (`float16`): Input argument for operation execution.
  - `b` (`float16`): Input argument for operation execution.
  - `val` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `inverseLinearInterpolation16` functionality within the `SpecialFunctionsContract` domain.

##### `op mapRange64`
```flux
op mapRange64 (as float64: val, as float64: in_min, as float64: in_max, as float64: out_min, as float64: out_max) as float64
```
- **Parameters**:
  - `val` (`float64`): Input argument for operation execution.
  - `in_min` (`float64`): Input argument for operation execution.
  - `in_max` (`float64`): Input argument for operation execution.
  - `out_min` (`float64`): Input argument for operation execution.
  - `out_max` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ⚠️ Emits `fail` with status message `"mapRange requer in_min != in_max"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapRange64` functionality within the `SpecialFunctionsContract` domain.

##### `op mapRange32`
```flux
op mapRange32 (as float32: val, as float32: in_min, as float32: in_max, as float32: out_min, as float32: out_max) as float32
```
- **Parameters**:
  - `val` (`float32`): Input argument for operation execution.
  - `in_min` (`float32`): Input argument for operation execution.
  - `in_max` (`float32`): Input argument for operation execution.
  - `out_min` (`float32`): Input argument for operation execution.
  - `out_max` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapRange32` functionality within the `SpecialFunctionsContract` domain.

##### `op mapRange16`
```flux
op mapRange16 (as float16: val, as float16: in_min, as float16: in_max, as float16: out_min, as float16: out_max) as float16
```
- **Parameters**:
  - `val` (`float16`): Input argument for operation execution.
  - `in_min` (`float16`): Input argument for operation execution.
  - `in_max` (`float16`): Input argument for operation execution.
  - `out_min` (`float16`): Input argument for operation execution.
  - `out_max` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `mapRange16` functionality within the `SpecialFunctionsContract` domain.

### 4.10 Contract `TrigonometryContract` (`Trigonometry.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `sin64` | `op sin64 (as float64: value) as float64` | `float64` |
| `sin32` | `op sin32 (as float32: value) as float32` | `float32` |
| `sin16` | `op sin16 (as float16: value) as float16` | `float16` |
| `cos64` | `op cos64 (as float64: value) as float64` | `float64` |
| `cos32` | `op cos32 (as float32: value) as float32` | `float32` |
| `cos16` | `op cos16 (as float16: value) as float16` | `float16` |
| `tan64` | `op tan64 (as float64: value) as float64` | `float64` |
| `tan32` | `op tan32 (as float32: value) as float32` | `float32` |
| `tan16` | `op tan16 (as float16: value) as float16` | `float16` |
| `arcTan64` | `op arcTan64 (as float64: value) as float64` | `float64` |
| `arcTan32` | `op arcTan32 (as float32: value) as float32` | `float32` |
| `arcTan16` | `op arcTan16 (as float16: value) as float16` | `float16` |
| `arcSin64` | `op arcSin64 (as float64: value) as float64` | `float64` |
| `arcSin32` | `op arcSin32 (as float32: value) as float32` | `float32` |
| `arcSin16` | `op arcSin16 (as float16: value) as float16` | `float16` |
| `arcCos64` | `op arcCos64 (as float64: value) as float64` | `float64` |
| `arcCos32` | `op arcCos32 (as float32: value) as float32` | `float32` |
| `arcCos16` | `op arcCos16 (as float16: value) as float16` | `float16` |
| `sec64` | `op sec64 (as float64: value) as float64` | `float64` |
| `sec32` | `op sec32 (as float32: value) as float32` | `float32` |
| `sec16` | `op sec16 (as float16: value) as float16` | `float16` |
| `csc64` | `op csc64 (as float64: value) as float64` | `float64` |
| `csc32` | `op csc32 (as float32: value) as float32` | `float32` |
| `csc16` | `op csc16 (as float16: value) as float16` | `float16` |
| `cot64` | `op cot64 (as float64: value) as float64` | `float64` |
| `cot32` | `op cot32 (as float32: value) as float32` | `float32` |
| `cot16` | `op cot16 (as float16: value) as float16` | `float16` |
| `arcSec64` | `op arcSec64 (as float64: value) as float64` | `float64` |
| `arcSec32` | `op arcSec32 (as float32: value) as float32` | `float32` |
| `arcSec16` | `op arcSec16 (as float16: value) as float16` | `float16` |
| `arcCsc64` | `op arcCsc64 (as float64: value) as float64` | `float64` |
| `arcCsc32` | `op arcCsc32 (as float32: value) as float32` | `float32` |
| `arcCsc16` | `op arcCsc16 (as float16: value) as float16` | `float16` |
| `arcCot64` | `op arcCot64 (as float64: value) as float64` | `float64` |
| `arcCot32` | `op arcCot32 (as float32: value) as float32` | `float32` |
| `arcCot16` | `op arcCot16 (as float16: value) as float16` | `float16` |
| `sinc64` | `op sinc64 (as float64: value) as float64` | `float64` |
| `sinc32` | `op sinc32 (as float32: value) as float32` | `float32` |
| `sinc16` | `op sinc16 (as float16: value) as float16` | `float16` |
| `sinpi64` | `op sinpi64 (as float64: value) as float64` | `float64` |
| `sinpi32` | `op sinpi32 (as float32: value) as float32` | `float32` |
| `sinpi16` | `op sinpi16 (as float16: value) as float16` | `float16` |
| `cospi64` | `op cospi64 (as float64: value) as float64` | `float64` |
| `cospi32` | `op cospi32 (as float32: value) as float32` | `float32` |
| `cospi16` | `op cospi16 (as float16: value) as float16` | `float16` |
| `tanpi64` | `op tanpi64 (as float64: value) as float64` | `float64` |
| `tanpi32` | `op tanpi32 (as float32: value) as float32` | `float32` |
| `tanpi16` | `op tanpi16 (as float16: value) as float16` | `float16` |
| `hypotenuse64` | `op hypotenuse64 (as float64: y, as float64: x) as float64` | `float64` |
| `hypotenuse32` | `op hypotenuse32 (as float32: y, as float32: x) as float32` | `float32` |
| `hypotenuse16` | `op hypotenuse16 (as float16: y, as float16: x) as float16` | `float16` |
| `arcTan2_64` | `op arcTan2_64 (as float64: y, as float64: x) as float64` | `float64` |
| `arcTan2_32` | `op arcTan2_32 (as float32: y, as float32: x) as float32` | `float32` |
| `arcTan2_16` | `op arcTan2_16 (as float16: y, as float16: x) as float16` | `float16` |
| `sen64` | `op sen64 (as float64: radians) as float64` | `float64` |
| `sen32` | `op sen32 (as float32: radians) as float32` | `float32` |
| `sen16` | `op sen16 (as float16: radians) as float16` | `float16` |

#### Operation Technical Specifications:

##### `op sin64`
```flux
op sin64 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `sin64` functionality within the `TrigonometryContract` domain.

##### `op sin32`
```flux
op sin32 (as float32: value) as float32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `sin32` functionality within the `TrigonometryContract` domain.

##### `op sin16`
```flux
op sin16 (as float16: value) as float16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `sin16` functionality within the `TrigonometryContract` domain.

##### `op cos64`
```flux
op cos64 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `cos64` functionality within the `TrigonometryContract` domain.

##### `op cos32`
```flux
op cos32 (as float32: value) as float32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `cos32` functionality within the `TrigonometryContract` domain.

##### `op cos16`
```flux
op cos16 (as float16: value) as float16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `cos16` functionality within the `TrigonometryContract` domain.

##### `op tan64`
```flux
op tan64 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ⚠️ Emits `fail` with status message `"tangente indefinida para multiplos impares de pi/2"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `tan64` functionality within the `TrigonometryContract` domain.

##### `op tan32`
```flux
op tan32 (as float32: value) as float32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `tan32` functionality within the `TrigonometryContract` domain.

##### `op tan16`
```flux
op tan16 (as float16: value) as float16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `tan16` functionality within the `TrigonometryContract` domain.

##### `op arcTan64`
```flux
op arcTan64 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `arcTan64` functionality within the `TrigonometryContract` domain.

##### `op arcTan32`
```flux
op arcTan32 (as float32: value) as float32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `arcTan32` functionality within the `TrigonometryContract` domain.

##### `op arcTan16`
```flux
op arcTan16 (as float16: value) as float16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `arcTan16` functionality within the `TrigonometryContract` domain.

##### `op arcSin64`
```flux
op arcSin64 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ⚠️ Emits `fail` with status message `"dominio de arcSin: [-1, 1]"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `arcSin64` functionality within the `TrigonometryContract` domain.

##### `op arcSin32`
```flux
op arcSin32 (as float32: value) as float32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ⚠️ Emits `fail` with status message `"dominio de arcSin: [-1, 1]"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `arcSin32` functionality within the `TrigonometryContract` domain.

##### `op arcSin16`
```flux
op arcSin16 (as float16: value) as float16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ⚠️ Emits `fail` with status message `"dominio de arcSin: [-1, 1]"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `arcSin16` functionality within the `TrigonometryContract` domain.

##### `op arcCos64`
```flux
op arcCos64 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ⚠️ Emits `fail` with status message `"dominio de arcCos: [-1, 1]"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `arcCos64` functionality within the `TrigonometryContract` domain.

##### `op arcCos32`
```flux
op arcCos32 (as float32: value) as float32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ⚠️ Emits `fail` with status message `"dominio de arcCos: [-1, 1]"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `arcCos32` functionality within the `TrigonometryContract` domain.

##### `op arcCos16`
```flux
op arcCos16 (as float16: value) as float16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ⚠️ Emits `fail` with status message `"dominio de arcCos: [-1, 1]"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `arcCos16` functionality within the `TrigonometryContract` domain.

##### `op sec64`
```flux
op sec64 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ⚠️ Emits `fail` with status message `"secante indefinida para multiplos impares de pi/2"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `sec64` functionality within the `TrigonometryContract` domain.

##### `op sec32`
```flux
op sec32 (as float32: value) as float32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `sec32` functionality within the `TrigonometryContract` domain.

##### `op sec16`
```flux
op sec16 (as float16: value) as float16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `sec16` functionality within the `TrigonometryContract` domain.

##### `op csc64`
```flux
op csc64 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ⚠️ Emits `fail` with status message `"cossecante indefinida para multiplos de pi"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `csc64` functionality within the `TrigonometryContract` domain.

##### `op csc32`
```flux
op csc32 (as float32: value) as float32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `csc32` functionality within the `TrigonometryContract` domain.

##### `op csc16`
```flux
op csc16 (as float16: value) as float16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `csc16` functionality within the `TrigonometryContract` domain.

##### `op cot64`
```flux
op cot64 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ⚠️ Emits `fail` with status message `"cotangente indefinida para multiplos de pi"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `cot64` functionality within the `TrigonometryContract` domain.

##### `op cot32`
```flux
op cot32 (as float32: value) as float32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `cot32` functionality within the `TrigonometryContract` domain.

##### `op cot16`
```flux
op cot16 (as float16: value) as float16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `cot16` functionality within the `TrigonometryContract` domain.

##### `op arcSec64`
```flux
op arcSec64 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ⚠️ Emits `fail` with status message `"dominio de arcSec: (-inf, -1] U [1, inf)"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `arcSec64` functionality within the `TrigonometryContract` domain.

##### `op arcSec32`
```flux
op arcSec32 (as float32: value) as float32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `arcSec32` functionality within the `TrigonometryContract` domain.

##### `op arcSec16`
```flux
op arcSec16 (as float16: value) as float16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `arcSec16` functionality within the `TrigonometryContract` domain.

##### `op arcCsc64`
```flux
op arcCsc64 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ⚠️ Emits `fail` with status message `"dominio de arcCsc: (-inf, -1] U [1, inf)"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `arcCsc64` functionality within the `TrigonometryContract` domain.

##### `op arcCsc32`
```flux
op arcCsc32 (as float32: value) as float32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `arcCsc32` functionality within the `TrigonometryContract` domain.

##### `op arcCsc16`
```flux
op arcCsc16 (as float16: value) as float16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `arcCsc16` functionality within the `TrigonometryContract` domain.

##### `op arcCot64`
```flux
op arcCot64 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `arcCot64` functionality within the `TrigonometryContract` domain.

##### `op arcCot32`
```flux
op arcCot32 (as float32: value) as float32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `arcCot32` functionality within the `TrigonometryContract` domain.

##### `op arcCot16`
```flux
op arcCot16 (as float16: value) as float16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `arcCot16` functionality within the `TrigonometryContract` domain.

##### `op sinc64`
```flux
op sinc64 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `sinc64` functionality within the `TrigonometryContract` domain.

##### `op sinc32`
```flux
op sinc32 (as float32: value) as float32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `sinc32` functionality within the `TrigonometryContract` domain.

##### `op sinc16`
```flux
op sinc16 (as float16: value) as float16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `sinc16` functionality within the `TrigonometryContract` domain.

##### `op sinpi64`
```flux
op sinpi64 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `sinpi64` functionality within the `TrigonometryContract` domain.

##### `op sinpi32`
```flux
op sinpi32 (as float32: value) as float32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `sinpi32` functionality within the `TrigonometryContract` domain.

##### `op sinpi16`
```flux
op sinpi16 (as float16: value) as float16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `sinpi16` functionality within the `TrigonometryContract` domain.

##### `op cospi64`
```flux
op cospi64 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `cospi64` functionality within the `TrigonometryContract` domain.

##### `op cospi32`
```flux
op cospi32 (as float32: value) as float32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `cospi32` functionality within the `TrigonometryContract` domain.

##### `op cospi16`
```flux
op cospi16 (as float16: value) as float16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `cospi16` functionality within the `TrigonometryContract` domain.

##### `op tanpi64`
```flux
op tanpi64 (as float64: value) as float64
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `tanpi64` functionality within the `TrigonometryContract` domain.

##### `op tanpi32`
```flux
op tanpi32 (as float32: value) as float32
```
- **Parameters**:
  - `value` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `tanpi32` functionality within the `TrigonometryContract` domain.

##### `op tanpi16`
```flux
op tanpi16 (as float16: value) as float16
```
- **Parameters**:
  - `value` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `tanpi16` functionality within the `TrigonometryContract` domain.

##### `op hypotenuse64`
```flux
op hypotenuse64 (as float64: y, as float64: x) as float64
```
- **Parameters**:
  - `y` (`float64`): Input argument for operation execution.
  - `x` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `hypotenuse64` functionality within the `TrigonometryContract` domain.

##### `op hypotenuse32`
```flux
op hypotenuse32 (as float32: y, as float32: x) as float32
```
- **Parameters**:
  - `y` (`float32`): Input argument for operation execution.
  - `x` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `hypotenuse32` functionality within the `TrigonometryContract` domain.

##### `op hypotenuse16`
```flux
op hypotenuse16 (as float16: y, as float16: x) as float16
```
- **Parameters**:
  - `y` (`float16`): Input argument for operation execution.
  - `x` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `hypotenuse16` functionality within the `TrigonometryContract` domain.

##### `op arcTan2_64`
```flux
op arcTan2_64 (as float64: y, as float64: x) as float64
```
- **Parameters**:
  - `y` (`float64`): Input argument for operation execution.
  - `x` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `arcTan2_64` functionality within the `TrigonometryContract` domain.

##### `op arcTan2_32`
```flux
op arcTan2_32 (as float32: y, as float32: x) as float32
```
- **Parameters**:
  - `y` (`float32`): Input argument for operation execution.
  - `x` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `arcTan2_32` functionality within the `TrigonometryContract` domain.

##### `op arcTan2_16`
```flux
op arcTan2_16 (as float16: y, as float16: x) as float16
```
- **Parameters**:
  - `y` (`float16`): Input argument for operation execution.
  - `x` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `arcTan2_16` functionality within the `TrigonometryContract` domain.

##### `op sen64`
```flux
op sen64 (as float64: radians) as float64
```
- **Parameters**:
  - `radians` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `sen64` functionality within the `TrigonometryContract` domain.

##### `op sen32`
```flux
op sen32 (as float32: radians) as float32
```
- **Parameters**:
  - `radians` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `sen32` functionality within the `TrigonometryContract` domain.

##### `op sen16`
```flux
op sen16 (as float16: radians) as float16
```
- **Parameters**:
  - `radians` (`float16`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `sen16` functionality within the `TrigonometryContract` domain.

---

## 5. Canonical Usage Examples in TheFlux

The following snippet illustrates importing and utilizing the library in a TheFlux program:

```flux
# Canonical Usage Example for MathStdLib
use MathStdLib

program (ExampleOfMathStdLib) {
      println("==================================================")
      println("  Standard Library Demonstration: MathStdLib")
      println("==================================================")

      # Invoking canonical operation
      mut as data: result = MathStdLib::sin64(0.0)
      println("Obtained result: " + result)

      println("Execution completed successfully.")
}
```

---

> [!TIP]
> For the complete unified architecture across all standard libraries, consult the master [StdLibs.md](../StdLibs.md) reference.
