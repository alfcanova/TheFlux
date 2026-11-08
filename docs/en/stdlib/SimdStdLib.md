# 📚 `SimdStdLib` — High-Performance Parallel Vectorized Computing (SIMD) 

> **Architectural Pillar**: Pillar 3 (Mathematics & Graphics)  
> **Status**: ✅ Certified with 100% Parity across 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Master File**: `stdlib/SimdStdLib/SimdStdLib.fdsl`  
> **Import Mode**: `use SimdStdLib` or `use SimdStdLib::<Module>::<operation>`

---

## 1. Overview and Capabilities

The **`SimdStdLib`** standard library is an integral component of the official TheFlux language ecosystem, providing certified system-level algorithms and robust capabilities.

Hardware-accelerated SIMD (Single Instruction, Multiple Data) primitives: vectorized parallel lane arithmetic, conditional bitmasks, and horizontal lane reductions (vector sum, dot product, min, max).

### 1.1 Key Architectural Principles and Design
- **Static Fusion and Zero-Overhead**: All domain modules are transparently fused into the `SimdStdLib` unified agent at compile time, avoiding virtual dispatch penalties.
- **Safety and Isolation**: Operations strictly validate parameter bounds and guarantee predictable error semantics via contract definitions.
- **Universal Multi-Backend Parity**: Bit-for-bit identical execution guarantees across interpreter (`in`), bytecode VM (`vm`, `vmr`), native AOT LLVM (`llvm`), and WebAssembly (`wat`, `wasm`).

---

## 2. Modular Structure and Contracts

The library comprises **4 domain modules** declaring a total of **27 public operations**:

| Domain Source File | Formal Contract | Domain Responsibility | Ops Count |
|---|---|---|:---:|
| `SimdMask.fdsl` | `SimdMaskContract` | Specialized domain for `SimdMask` | 6 |
| `SimdMatrix.fdsl` | `SimdMatrixContract` | Specialized domain for `SimdMatrix` | 3 |
| `SimdVectorArithmetic.fdsl` | `SimdVectorArithmeticContract` | Specialized domain for `SimdVectorArithmetic` | 12 |
| `SimdVectorReduction.fdsl` | `SimdVectorReductionContract` | Specialized domain for `SimdVectorReduction` | 6 |

---

## 3. Public Types, Structures, and Enumerations

The `SimdStdLib` library operates directly on primitive native TheFlux types (`string`, `int64`, `float64`, `bool`, `list of data`, etc.) without requiring custom composite types.

---

## 4. Detailed Operations Catalog by Domain

### 4.1 Contract `SimdMaskContract` (`SimdMask.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `simdVectorClampF32` | `op simdVectorClampF32 (as list of data: a, as float32: min_v, as float32: max_v) as list of data` | `list of data` |
| `simdVectorClampF64` | `op simdVectorClampF64 (as list of data: a, as float64: min_v, as float64: max_v) as list of data` | `list of data` |
| `simdSelectF32` | `op simdSelectF32 (as list of data: mask, as list of data: a, as list of data: b) as list of data` | `list of data` |
| `simdSelectF64` | `op simdSelectF64 (as list of data: mask, as list of data: a, as list of data: b) as list of data` | `list of data` |
| `simdVectorClamp` | `op simdVectorClamp (as list of data: a, as float64: min_v, as float64: max_v) as list of data` | `list of data` |
| `simdSelect` | `op simdSelect (as list of data: mask, as list of data: a, as list of data: b) as list of data` | `list of data` |

#### Operation Technical Specifications:

##### `op simdVectorClampF32`
```flux
op simdVectorClampF32 (as list of data: a, as float32: min_v, as float32: max_v) as list of data
```
- **Parameters**:
  - `a` (`list of data`): Input argument for operation execution.
  - `min_v` (`float32`): Input argument for operation execution.
  - `max_v` (`float32`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `simdVectorClampF32` functionality within the `SimdMaskContract` domain.

##### `op simdVectorClampF64`
```flux
op simdVectorClampF64 (as list of data: a, as float64: min_v, as float64: max_v) as list of data
```
- **Parameters**:
  - `a` (`list of data`): Input argument for operation execution.
  - `min_v` (`float64`): Input argument for operation execution.
  - `max_v` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `simdVectorClampF64` functionality within the `SimdMaskContract` domain.

##### `op simdSelectF32`
```flux
op simdSelectF32 (as list of data: mask, as list of data: a, as list of data: b) as list of data
```
- **Parameters**:
  - `mask` (`list of data`): Input argument for operation execution.
  - `a` (`list of data`): Input argument for operation execution.
  - `b` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `simdSelectF32` functionality within the `SimdMaskContract` domain.

##### `op simdSelectF64`
```flux
op simdSelectF64 (as list of data: mask, as list of data: a, as list of data: b) as list of data
```
- **Parameters**:
  - `mask` (`list of data`): Input argument for operation execution.
  - `a` (`list of data`): Input argument for operation execution.
  - `b` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `simdSelectF64` functionality within the `SimdMaskContract` domain.

##### `op simdVectorClamp`
```flux
op simdVectorClamp (as list of data: a, as float64: min_v, as float64: max_v) as list of data
```
- **Parameters**:
  - `a` (`list of data`): Input argument for operation execution.
  - `min_v` (`float64`): Input argument for operation execution.
  - `max_v` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `simdVectorClamp` functionality within the `SimdMaskContract` domain.

##### `op simdSelect`
```flux
op simdSelect (as list of data: mask, as list of data: a, as list of data: b) as list of data
```
- **Parameters**:
  - `mask` (`list of data`): Input argument for operation execution.
  - `a` (`list of data`): Input argument for operation execution.
  - `b` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `simdSelect` functionality within the `SimdMaskContract` domain.

### 4.2 Contract `SimdMatrixContract` (`SimdMatrix.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `simdMatrixMul2DF32` | `op simdMatrixMul2DF32 (as map: lhs, as map: rhs) as map` | `map` |
| `simdMatrixMul2DF64` | `op simdMatrixMul2DF64 (as map: lhs, as map: rhs) as map` | `map` |
| `simdMatrixMul2D` | `op simdMatrixMul2D (as map: lhs, as map: rhs) as map` | `map` |

#### Operation Technical Specifications:

##### `op simdMatrixMul2DF32`
```flux
op simdMatrixMul2DF32 (as map: lhs, as map: rhs) as map
```
- **Parameters**:
  - `lhs` (`map`): Input argument for operation execution.
  - `rhs` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `simdMatrixMul2DF32` functionality within the `SimdMatrixContract` domain.

##### `op simdMatrixMul2DF64`
```flux
op simdMatrixMul2DF64 (as map: lhs, as map: rhs) as map
```
- **Parameters**:
  - `lhs` (`map`): Input argument for operation execution.
  - `rhs` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `simdMatrixMul2DF64` functionality within the `SimdMatrixContract` domain.

##### `op simdMatrixMul2D`
```flux
op simdMatrixMul2D (as map: lhs, as map: rhs) as map
```
- **Parameters**:
  - `lhs` (`map`): Input argument for operation execution.
  - `rhs` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `simdMatrixMul2D` functionality within the `SimdMatrixContract` domain.

### 4.3 Contract `SimdVectorArithmeticContract` (`SimdVectorArithmetic.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `simdVectorAddF32` | `op simdVectorAddF32 (as list of data: a, as list of data: b) as list of data` | `list of data` |
| `simdVectorSubF32` | `op simdVectorSubF32 (as list of data: a, as list of data: b) as list of data` | `list of data` |
| `simdVectorMulF32` | `op simdVectorMulF32 (as list of data: a, as list of data: b) as list of data` | `list of data` |
| `simdVectorDivF32` | `op simdVectorDivF32 (as list of data: a, as list of data: b) as list of data` | `list of data` |
| `simdVectorAddF64` | `op simdVectorAddF64 (as list of data: a, as list of data: b) as list of data` | `list of data` |
| `simdVectorSubF64` | `op simdVectorSubF64 (as list of data: a, as list of data: b) as list of data` | `list of data` |
| `simdVectorMulF64` | `op simdVectorMulF64 (as list of data: a, as list of data: b) as list of data` | `list of data` |
| `simdVectorDivF64` | `op simdVectorDivF64 (as list of data: a, as list of data: b) as list of data` | `list of data` |
| `simdVectorAdd` | `op simdVectorAdd (as list of data: a, as list of data: b) as list of data` | `list of data` |
| `simdVectorSub` | `op simdVectorSub (as list of data: a, as list of data: b) as list of data` | `list of data` |
| `simdVectorMul` | `op simdVectorMul (as list of data: a, as list of data: b) as list of data` | `list of data` |
| `simdVectorDiv` | `op simdVectorDiv (as list of data: a, as list of data: b) as list of data` | `list of data` |

#### Operation Technical Specifications:

##### `op simdVectorAddF32`
```flux
op simdVectorAddF32 (as list of data: a, as list of data: b) as list of data
```
- **Parameters**:
  - `a` (`list of data`): Input argument for operation execution.
  - `b` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `simdVectorAddF32` functionality within the `SimdVectorArithmeticContract` domain.

##### `op simdVectorSubF32`
```flux
op simdVectorSubF32 (as list of data: a, as list of data: b) as list of data
```
- **Parameters**:
  - `a` (`list of data`): Input argument for operation execution.
  - `b` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `simdVectorSubF32` functionality within the `SimdVectorArithmeticContract` domain.

##### `op simdVectorMulF32`
```flux
op simdVectorMulF32 (as list of data: a, as list of data: b) as list of data
```
- **Parameters**:
  - `a` (`list of data`): Input argument for operation execution.
  - `b` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `simdVectorMulF32` functionality within the `SimdVectorArithmeticContract` domain.

##### `op simdVectorDivF32`
```flux
op simdVectorDivF32 (as list of data: a, as list of data: b) as list of data
```
- **Parameters**:
  - `a` (`list of data`): Input argument for operation execution.
  - `b` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `simdVectorDivF32` functionality within the `SimdVectorArithmeticContract` domain.

##### `op simdVectorAddF64`
```flux
op simdVectorAddF64 (as list of data: a, as list of data: b) as list of data
```
- **Parameters**:
  - `a` (`list of data`): Input argument for operation execution.
  - `b` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `simdVectorAddF64` functionality within the `SimdVectorArithmeticContract` domain.

##### `op simdVectorSubF64`
```flux
op simdVectorSubF64 (as list of data: a, as list of data: b) as list of data
```
- **Parameters**:
  - `a` (`list of data`): Input argument for operation execution.
  - `b` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `simdVectorSubF64` functionality within the `SimdVectorArithmeticContract` domain.

##### `op simdVectorMulF64`
```flux
op simdVectorMulF64 (as list of data: a, as list of data: b) as list of data
```
- **Parameters**:
  - `a` (`list of data`): Input argument for operation execution.
  - `b` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `simdVectorMulF64` functionality within the `SimdVectorArithmeticContract` domain.

##### `op simdVectorDivF64`
```flux
op simdVectorDivF64 (as list of data: a, as list of data: b) as list of data
```
- **Parameters**:
  - `a` (`list of data`): Input argument for operation execution.
  - `b` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `simdVectorDivF64` functionality within the `SimdVectorArithmeticContract` domain.

##### `op simdVectorAdd`
```flux
op simdVectorAdd (as list of data: a, as list of data: b) as list of data
```
- **Parameters**:
  - `a` (`list of data`): Input argument for operation execution.
  - `b` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `simdVectorAdd` functionality within the `SimdVectorArithmeticContract` domain.

##### `op simdVectorSub`
```flux
op simdVectorSub (as list of data: a, as list of data: b) as list of data
```
- **Parameters**:
  - `a` (`list of data`): Input argument for operation execution.
  - `b` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `simdVectorSub` functionality within the `SimdVectorArithmeticContract` domain.

##### `op simdVectorMul`
```flux
op simdVectorMul (as list of data: a, as list of data: b) as list of data
```
- **Parameters**:
  - `a` (`list of data`): Input argument for operation execution.
  - `b` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `simdVectorMul` functionality within the `SimdVectorArithmeticContract` domain.

##### `op simdVectorDiv`
```flux
op simdVectorDiv (as list of data: a, as list of data: b) as list of data
```
- **Parameters**:
  - `a` (`list of data`): Input argument for operation execution.
  - `b` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `simdVectorDiv` functionality within the `SimdVectorArithmeticContract` domain.

### 4.4 Contract `SimdVectorReductionContract` (`SimdVectorReduction.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `simdDotProductF32` | `op simdDotProductF32 (as list of data: a, as list of data: b) as float32` | `float32` |
| `simdDotProductF64` | `op simdDotProductF64 (as list of data: a, as list of data: b) as float64` | `float64` |
| `simdVectorSumF32` | `op simdVectorSumF32 (as list of data: a) as float32` | `float32` |
| `simdVectorSumF64` | `op simdVectorSumF64 (as list of data: a) as float64` | `float64` |
| `simdDotProduct` | `op simdDotProduct (as list of data: a, as list of data: b) as float64` | `float64` |
| `simdVectorSum` | `op simdVectorSum (as list of data: a) as float64` | `float64` |

#### Operation Technical Specifications:

##### `op simdDotProductF32`
```flux
op simdDotProductF32 (as list of data: a, as list of data: b) as float32
```
- **Parameters**:
  - `a` (`list of data`): Input argument for operation execution.
  - `b` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `simdDotProductF32` functionality within the `SimdVectorReductionContract` domain.

##### `op simdDotProductF64`
```flux
op simdDotProductF64 (as list of data: a, as list of data: b) as float64
```
- **Parameters**:
  - `a` (`list of data`): Input argument for operation execution.
  - `b` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `simdDotProductF64` functionality within the `SimdVectorReductionContract` domain.

##### `op simdVectorSumF32`
```flux
op simdVectorSumF32 (as list of data: a) as float32
```
- **Parameters**:
  - `a` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `simdVectorSumF32` functionality within the `SimdVectorReductionContract` domain.

##### `op simdVectorSumF64`
```flux
op simdVectorSumF64 (as list of data: a) as float64
```
- **Parameters**:
  - `a` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `simdVectorSumF64` functionality within the `SimdVectorReductionContract` domain.

##### `op simdDotProduct`
```flux
op simdDotProduct (as list of data: a, as list of data: b) as float64
```
- **Parameters**:
  - `a` (`list of data`): Input argument for operation execution.
  - `b` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `simdDotProduct` functionality within the `SimdVectorReductionContract` domain.

##### `op simdVectorSum`
```flux
op simdVectorSum (as list of data: a) as float64
```
- **Parameters**:
  - `a` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `simdVectorSum` functionality within the `SimdVectorReductionContract` domain.

---

## 5. Canonical Usage Examples in TheFlux

The following snippet illustrates importing and utilizing the library in a TheFlux program:

```flux
# Canonical Usage Example for SimdStdLib
use SimdStdLib

program (ExampleOfSimdStdLib) {
      println("==================================================")
      println("  Standard Library Demonstration: SimdStdLib")
      println("==================================================")

      # Invoking canonical operation
      mut as data: result = SimdStdLib::simdVectorAdd([1.0, 2.0], [3.0, 4.0])
      println("Obtained result: " + result)

      println("Execution completed successfully.")
}
```

---

> [!TIP]
> For the complete unified architecture across all standard libraries, consult the master [StdLibs.md](../StdLibs.md) reference.
