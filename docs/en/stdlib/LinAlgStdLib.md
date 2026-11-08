# 📚 `LinAlgStdLib` — Computational Linear Algebra, Matrices, and Decompositions

> **Architectural Pillar**: Pillar 3 (Mathematics & Graphics)  
> **Status**: ✅ Certified with 100% Parity across 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Master File**: `stdlib/LinAlgStdLib/LinAlgStdLib.fdsl`  
> **Import Mode**: `use LinAlgStdLib` or `use LinAlgStdLib::<Module>::<operation>`

---

## 1. Overview and Capabilities

The **`LinAlgStdLib`** standard library is an integral component of the official TheFlux language ecosystem, providing certified system-level algorithms and robust capabilities.

High-performance computational linear algebra: dense and sparse matrix representation, matrix-matrix and matrix-vector operations, linear equation solvers, eigenvalue/eigenvector solvers, and matrix factorizations (LU, QR, Cholesky, SVD).

### 1.1 Key Architectural Principles and Design
- **Static Fusion and Zero-Overhead**: All domain modules are transparently fused into the `LinAlgStdLib` unified agent at compile time, avoiding virtual dispatch penalties.
- **Safety and Isolation**: Operations strictly validate parameter bounds and guarantee predictable error semantics via contract definitions.
- **Universal Multi-Backend Parity**: Bit-for-bit identical execution guarantees across interpreter (`in`), bytecode VM (`vm`, `vmr`), native AOT LLVM (`llvm`), and WebAssembly (`wat`, `wasm`).

---

## 2. Modular Structure and Contracts

The library comprises **16 domain modules** declaring a total of **83 public operations**:

| Domain Source File | Formal Contract | Domain Responsibility | Ops Count |
|---|---|---|:---:|
| `MatrixAdvancedDecomposition.fdsl` | `MatrixAdvancedDecompositionContract` | Specialized domain for `MatrixAdvancedDecomposition` | 5 |
| `MatrixDecomposition.fdsl` | `MatrixDecompositionContract` | Specialized domain for `MatrixDecomposition` | 4 |
| `MatrixEigen.fdsl` | `MatrixEigenContract` | Specialized domain for `MatrixEigen` | 7 |
| `MatrixFactory.fdsl` | `MatrixFactoryContract` | Specialized domain for `MatrixFactory` | 8 |
| `MatrixQR.fdsl` | `MatrixQRContract` | Specialized domain for `MatrixQR` | 2 |
| `MatrixSVD.fdsl` | `MatrixSVDContract` | Specialized domain for `MatrixSVD` | 3 |
| `TensorArithmetic.fdsl` | `TensorArithmeticContract` | Specialized domain for `TensorArithmetic` | 4 |
| `TensorCore.fdsl` | `TensorCoreContract` | Specialized domain for `TensorCore` | 5 |
| `TensorEinsum.fdsl` | `TensorEinsumContract` | Specialized domain for `TensorEinsum` | 1 |
| `TensorElementwise.fdsl` | `TensorElementwiseContract` | Specialized domain for `TensorElementwise` | 7 |
| `TensorMath.fdsl` | `TensorMathContract` | Specialized domain for `TensorMath` | 8 |
| `TensorMultilinear.fdsl` | `TensorMultilinearContract` | Specialized domain for `TensorMultilinear` | 7 |
| `TensorReduction.fdsl` | `TensorReductionContract` | Specialized domain for `TensorReduction` | 2 |
| `TensorStrides.fdsl` | `TensorStridesContract` | Specialized domain for `TensorStrides` | 6 |
| `TensorTransform.fdsl` | `TensorTransformContract` | Specialized domain for `TensorTransform` | 5 |
| `VectorGeometry.fdsl` | `VectorGeometryContract` | Specialized domain for `VectorGeometry` | 9 |

---

## 3. Public Types, Structures, and Enumerations

The `LinAlgStdLib` library operates directly on primitive native TheFlux types (`string`, `int64`, `float64`, `bool`, `list of data`, etc.) without requiring custom composite types.

---

## 4. Detailed Operations Catalog by Domain

### 4.1 Contract `MatrixAdvancedDecompositionContract` (`MatrixAdvancedDecomposition.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `matrixCholesky` | `op matrixCholesky (as map: matrix) as map` | `map` |
| `matrixSolveCholesky` | `op matrixSolveCholesky (as map: L, as list of data: b) as list of data` | `list of data` |
| `matrixPowerIteration` | `op matrixPowerIteration (as map: matrix, as int64: max_iters, as float64: tolerance) as list of data` | `list of data` |
| `matrixRank` | `op matrixRank (as map: matrix, as float64: tolerance) as int64` | `int64` |
| `matrixFrobeniusNorm` | `op matrixFrobeniusNorm (as map: matrix) as float64` | `float64` |

#### Operation Technical Specifications:

##### `op matrixCholesky`
```flux
op matrixCholesky (as map: matrix) as map
```
- **Parameters**:
  - `matrix` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `matrixCholesky` functionality within the `MatrixAdvancedDecompositionContract` domain.

##### `op matrixSolveCholesky`
```flux
op matrixSolveCholesky (as map: L, as list of data: b) as list of data
```
- **Parameters**:
  - `L` (`map`): Input argument for operation execution.
  - `b` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `matrixSolveCholesky` functionality within the `MatrixAdvancedDecompositionContract` domain.

##### `op matrixPowerIteration`
```flux
op matrixPowerIteration (as map: matrix, as int64: max_iters, as float64: tolerance) as list of data
```
- **Parameters**:
  - `matrix` (`map`): Input argument for operation execution.
  - `max_iters` (`int64`): Input argument for operation execution.
  - `tolerance` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `matrixPowerIteration` functionality within the `MatrixAdvancedDecompositionContract` domain.

##### `op matrixRank`
```flux
op matrixRank (as map: matrix, as float64: tolerance) as int64
```
- **Parameters**:
  - `matrix` (`map`): Input argument for operation execution.
  - `tolerance` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `matrixRank` functionality within the `MatrixAdvancedDecompositionContract` domain.

##### `op matrixFrobeniusNorm`
```flux
op matrixFrobeniusNorm (as map: matrix) as float64
```
- **Parameters**:
  - `matrix` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `matrixFrobeniusNorm` functionality within the `MatrixAdvancedDecompositionContract` domain.

### 4.2 Contract `MatrixDecompositionContract` (`MatrixDecomposition.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `matrixLU` | `op matrixLU (as map: matrix) as list of data` | `list of data` |
| `matrixSolveLU` | `op matrixSolveLU (as map: L, as map: U, as list of data: P, as list of data: b) as list of data` | `list of data` |
| `matrixDeterminant` | `op matrixDeterminant (as map: matrix) as float64` | `float64` |
| `matrixInverse` | `op matrixInverse (as map: matrix) as map` | `map` |

#### Operation Technical Specifications:

##### `op matrixLU`
```flux
op matrixLU (as map: matrix) as list of data
```
- **Parameters**:
  - `matrix` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `matrixLU` functionality within the `MatrixDecompositionContract` domain.

##### `op matrixSolveLU`
```flux
op matrixSolveLU (as map: L, as map: U, as list of data: P, as list of data: b) as list of data
```
- **Parameters**:
  - `L` (`map`): Input argument for operation execution.
  - `U` (`map`): Input argument for operation execution.
  - `P` (`list of data`): Input argument for operation execution.
  - `b` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `matrixSolveLU` functionality within the `MatrixDecompositionContract` domain.

##### `op matrixDeterminant`
```flux
op matrixDeterminant (as map: matrix) as float64
```
- **Parameters**:
  - `matrix` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `matrixDeterminant` functionality within the `MatrixDecompositionContract` domain.

##### `op matrixInverse`
```flux
op matrixInverse (as map: matrix) as map
```
- **Parameters**:
  - `matrix` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `matrixInverse` functionality within the `MatrixDecompositionContract` domain.

### 4.3 Contract `MatrixEigenContract` (`MatrixEigen.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `matrixEigenvalues2D` | `op matrixEigenvalues2D (as map: matrix) as list of data` | `list of data` |
| `matrixEigenvaluesQR` | `op matrixEigenvaluesQR (as map: matrix, as int64: max_iters, as float64: tolerance) as list of data` | `list of data` |
| `matrixEigenvectorsQR` | `op matrixEigenvectorsQR (as map: matrix, as int64: max_iters, as float64: tolerance) as list of data` | `list of data` |
| `matrixIsSymmetric` | `op matrixIsSymmetric (as map: matrix, as float64: tolerance) as bool` | `bool` |
| `matrixEigenvectors2D` | `op matrixEigenvectors2D (as map: matrix) as list of data` | `list of data` |
| `matrixEig` | `op matrixEig (as map: matrix, as int64: max_iters, as float64: tolerance) as list of data` | `list of data` |
| `matrixEigenvectorInverseIteration` | `op matrixEigenvectorInverseIteration (as map: matrix, as float64: lambda, as int64: max_iters) as list of data` | `list of data` |

#### Operation Technical Specifications:

##### `op matrixEigenvalues2D`
```flux
op matrixEigenvalues2D (as map: matrix) as list of data
```
- **Parameters**:
  - `matrix` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `matrixEigenvalues2D` functionality within the `MatrixEigenContract` domain.

##### `op matrixEigenvaluesQR`
```flux
op matrixEigenvaluesQR (as map: matrix, as int64: max_iters, as float64: tolerance) as list of data
```
- **Parameters**:
  - `matrix` (`map`): Input argument for operation execution.
  - `max_iters` (`int64`): Input argument for operation execution.
  - `tolerance` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `matrixEigenvaluesQR` functionality within the `MatrixEigenContract` domain.

##### `op matrixEigenvectorsQR`
```flux
op matrixEigenvectorsQR (as map: matrix, as int64: max_iters, as float64: tolerance) as list of data
```
- **Parameters**:
  - `matrix` (`map`): Input argument for operation execution.
  - `max_iters` (`int64`): Input argument for operation execution.
  - `tolerance` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `matrixEigenvectorsQR` functionality within the `MatrixEigenContract` domain.

##### `op matrixIsSymmetric`
```flux
op matrixIsSymmetric (as map: matrix, as float64: tolerance) as bool
```
- **Parameters**:
  - `matrix` (`map`): Input argument for operation execution.
  - `tolerance` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `matrixIsSymmetric` functionality within the `MatrixEigenContract` domain.

##### `op matrixEigenvectors2D`
```flux
op matrixEigenvectors2D (as map: matrix) as list of data
```
- **Parameters**:
  - `matrix` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `matrixEigenvectors2D` functionality within the `MatrixEigenContract` domain.

##### `op matrixEig`
```flux
op matrixEig (as map: matrix, as int64: max_iters, as float64: tolerance) as list of data
```
- **Parameters**:
  - `matrix` (`map`): Input argument for operation execution.
  - `max_iters` (`int64`): Input argument for operation execution.
  - `tolerance` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `matrixEig` functionality within the `MatrixEigenContract` domain.

##### `op matrixEigenvectorInverseIteration`
```flux
op matrixEigenvectorInverseIteration (as map: matrix, as float64: lambda, as int64: max_iters) as list of data
```
- **Parameters**:
  - `matrix` (`map`): Input argument for operation execution.
  - `lambda` (`float64`): Input argument for operation execution.
  - `max_iters` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `matrixEigenvectorInverseIteration` functionality within the `MatrixEigenContract` domain.

### 4.4 Contract `MatrixFactoryContract` (`MatrixFactory.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `matrixIdentity` | `op matrixIdentity (as int64: n) as map` | `map` |
| `matrixZeros` | `op matrixZeros (as list of data: shape) as map` | `map` |
| `matrixOnes` | `op matrixOnes (as list of data: shape) as map` | `map` |
| `matrixDiagonal` | `op matrixDiagonal (as list of data: values) as map` | `map` |
| `matrixExtractDiagonal` | `op matrixExtractDiagonal (as map: matrix) as list of data` | `list of data` |
| `matrixTrace` | `op matrixTrace (as map: matrix) as float64` | `float64` |
| `matrixTriu` | `op matrixTriu (as map: matrix, as int64: k) as map` | `map` |
| `matrixTril` | `op matrixTril (as map: matrix, as int64: k) as map` | `map` |

#### Operation Technical Specifications:

##### `op matrixIdentity`
```flux
op matrixIdentity (as int64: n) as map
```
- **Parameters**:
  - `n` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `matrixIdentity` functionality within the `MatrixFactoryContract` domain.

##### `op matrixZeros`
```flux
op matrixZeros (as list of data: shape) as map
```
- **Parameters**:
  - `shape` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `matrixZeros` functionality within the `MatrixFactoryContract` domain.

##### `op matrixOnes`
```flux
op matrixOnes (as list of data: shape) as map
```
- **Parameters**:
  - `shape` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `matrixOnes` functionality within the `MatrixFactoryContract` domain.

##### `op matrixDiagonal`
```flux
op matrixDiagonal (as list of data: values) as map
```
- **Parameters**:
  - `values` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `matrixDiagonal` functionality within the `MatrixFactoryContract` domain.

##### `op matrixExtractDiagonal`
```flux
op matrixExtractDiagonal (as map: matrix) as list of data
```
- **Parameters**:
  - `matrix` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `matrixExtractDiagonal` functionality within the `MatrixFactoryContract` domain.

##### `op matrixTrace`
```flux
op matrixTrace (as map: matrix) as float64
```
- **Parameters**:
  - `matrix` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `matrixTrace` functionality within the `MatrixFactoryContract` domain.

##### `op matrixTriu`
```flux
op matrixTriu (as map: matrix, as int64: k) as map
```
- **Parameters**:
  - `matrix` (`map`): Input argument for operation execution.
  - `k` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `matrixTriu` functionality within the `MatrixFactoryContract` domain.

##### `op matrixTril`
```flux
op matrixTril (as map: matrix, as int64: k) as map
```
- **Parameters**:
  - `matrix` (`map`): Input argument for operation execution.
  - `k` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `matrixTril` functionality within the `MatrixFactoryContract` domain.

### 4.5 Contract `MatrixQRContract` (`MatrixQR.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `matrixQR` | `op matrixQR (as map: matrix) as list of data` | `list of data` |
| `matrixSolveQR` | `op matrixSolveQR (as map: Q, as map: R, as list of data: b) as list of data` | `list of data` |

#### Operation Technical Specifications:

##### `op matrixQR`
```flux
op matrixQR (as map: matrix) as list of data
```
- **Parameters**:
  - `matrix` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `matrixQR` functionality within the `MatrixQRContract` domain.

##### `op matrixSolveQR`
```flux
op matrixSolveQR (as map: Q, as map: R, as list of data: b) as list of data
```
- **Parameters**:
  - `Q` (`map`): Input argument for operation execution.
  - `R` (`map`): Input argument for operation execution.
  - `b` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `matrixSolveQR` functionality within the `MatrixQRContract` domain.

### 4.6 Contract `MatrixSVDContract` (`MatrixSVD.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `matrixSVD` | `op matrixSVD (as map: matrix) as list of data` | `list of data` |
| `matrixPseudoInverse` | `op matrixPseudoInverse (as map: matrix) as map` | `map` |
| `matrixLeastSquares` | `op matrixLeastSquares (as map: A, as list of data: b) as list of data` | `list of data` |

#### Operation Technical Specifications:

##### `op matrixSVD`
```flux
op matrixSVD (as map: matrix) as list of data
```
- **Parameters**:
  - `matrix` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `matrixSVD` functionality within the `MatrixSVDContract` domain.

##### `op matrixPseudoInverse`
```flux
op matrixPseudoInverse (as map: matrix) as map
```
- **Parameters**:
  - `matrix` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `matrixPseudoInverse` functionality within the `MatrixSVDContract` domain.

##### `op matrixLeastSquares`
```flux
op matrixLeastSquares (as map: A, as list of data: b) as list of data
```
- **Parameters**:
  - `A` (`map`): Input argument for operation execution.
  - `b` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `matrixLeastSquares` functionality within the `MatrixSVDContract` domain.

### 4.7 Contract `TensorArithmeticContract` (`TensorArithmetic.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `tensorAddElementwise` | `op tensorAddElementwise (as map: lhs, as map: rhs) as map` | `map` |
| `tensorMulScalar` | `op tensorMulScalar (as map: tensor, as float64: scalar) as map` | `map` |
| `tensorMatMul2D` | `op tensorMatMul2D (as map: lhs, as map: rhs) as map` | `map` |
| `tensorBatchedMatMul` | `op tensorBatchedMatMul (as map: lhs, as map: rhs) as map` | `map` |

#### Operation Technical Specifications:

##### `op tensorAddElementwise`
```flux
op tensorAddElementwise (as map: lhs, as map: rhs) as map
```
- **Parameters**:
  - `lhs` (`map`): Input argument for operation execution.
  - `rhs` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `tensorAddElementwise` functionality within the `TensorArithmeticContract` domain.

##### `op tensorMulScalar`
```flux
op tensorMulScalar (as map: tensor, as float64: scalar) as map
```
- **Parameters**:
  - `tensor` (`map`): Input argument for operation execution.
  - `scalar` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `tensorMulScalar` functionality within the `TensorArithmeticContract` domain.

##### `op tensorMatMul2D`
```flux
op tensorMatMul2D (as map: lhs, as map: rhs) as map
```
- **Parameters**:
  - `lhs` (`map`): Input argument for operation execution.
  - `rhs` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `tensorMatMul2D` functionality within the `TensorArithmeticContract` domain.

##### `op tensorBatchedMatMul`
```flux
op tensorBatchedMatMul (as map: lhs, as map: rhs) as map
```
- **Parameters**:
  - `lhs` (`map`): Input argument for operation execution.
  - `rhs` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `tensorBatchedMatMul` functionality within the `TensorArithmeticContract` domain.

### 4.8 Contract `TensorCoreContract` (`TensorCore.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `tensorNew` | `op tensorNew (as list of data: shape) as map` | `map` |
| `tensorGetAt` | `op tensorGetAt (as map: tensor, as list of data: indices) as float64` | `float64` |
| `tensorSetAt` | `op tensorSetAt (as map: tensor, as list of data: indices, as float64: val) as map` | `map` |
| `tensorTranspose2D` | `op tensorTranspose2D (as map: tensor) as map` | `map` |
| `tensorPermute` | `op tensorPermute (as map: tensor, as list of data: axes) as map` | `map` |

#### Operation Technical Specifications:

##### `op tensorNew`
```flux
op tensorNew (as list of data: shape) as map
```
- **Parameters**:
  - `shape` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `tensorNew` functionality within the `TensorCoreContract` domain.

##### `op tensorGetAt`
```flux
op tensorGetAt (as map: tensor, as list of data: indices) as float64
```
- **Parameters**:
  - `tensor` (`map`): Input argument for operation execution.
  - `indices` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `tensorGetAt` functionality within the `TensorCoreContract` domain.

##### `op tensorSetAt`
```flux
op tensorSetAt (as map: tensor, as list of data: indices, as float64: val) as map
```
- **Parameters**:
  - `tensor` (`map`): Input argument for operation execution.
  - `indices` (`list of data`): Input argument for operation execution.
  - `val` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `tensorSetAt` functionality within the `TensorCoreContract` domain.

##### `op tensorTranspose2D`
```flux
op tensorTranspose2D (as map: tensor) as map
```
- **Parameters**:
  - `tensor` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `tensorTranspose2D` functionality within the `TensorCoreContract` domain.

##### `op tensorPermute`
```flux
op tensorPermute (as map: tensor, as list of data: axes) as map
```
- **Parameters**:
  - `tensor` (`map`): Input argument for operation execution.
  - `axes` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `tensorPermute` functionality within the `TensorCoreContract` domain.

### 4.9 Contract `TensorEinsumContract` (`TensorEinsum.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `tensorEinsum` | `op tensorEinsum (as string: equation, as list of data: operands) as map` | `map` |

#### Operation Technical Specifications:

##### `op tensorEinsum`
```flux
op tensorEinsum (as string: equation, as list of data: operands) as map
```
- **Parameters**:
  - `equation` (`string`): Input argument for operation execution.
  - `operands` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `tensorEinsum` functionality within the `TensorEinsumContract` domain.

### 4.10 Contract `TensorElementwiseContract` (`TensorElementwise.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `tensorSubElementwise` | `op tensorSubElementwise (as map: lhs, as map: rhs) as map` | `map` |
| `tensorMulElementwise` | `op tensorMulElementwise (as map: lhs, as map: rhs) as map` | `map` |
| `tensorDivElementwise` | `op tensorDivElementwise (as map: lhs, as map: rhs) as map` | `map` |
| `tensorMeanAxis` | `op tensorMeanAxis (as map: tensor, as int64: axis) as map` | `map` |
| `tensorMinAxis` | `op tensorMinAxis (as map: tensor, as int64: axis) as map` | `map` |
| `tensorMaxAxis` | `op tensorMaxAxis (as map: tensor, as int64: axis) as map` | `map` |
| `tensorClamp` | `op tensorClamp (as map: tensor, as float64: min_val, as float64: max_val) as map` | `map` |

#### Operation Technical Specifications:

##### `op tensorSubElementwise`
```flux
op tensorSubElementwise (as map: lhs, as map: rhs) as map
```
- **Parameters**:
  - `lhs` (`map`): Input argument for operation execution.
  - `rhs` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `tensorSubElementwise` functionality within the `TensorElementwiseContract` domain.

##### `op tensorMulElementwise`
```flux
op tensorMulElementwise (as map: lhs, as map: rhs) as map
```
- **Parameters**:
  - `lhs` (`map`): Input argument for operation execution.
  - `rhs` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `tensorMulElementwise` functionality within the `TensorElementwiseContract` domain.

##### `op tensorDivElementwise`
```flux
op tensorDivElementwise (as map: lhs, as map: rhs) as map
```
- **Parameters**:
  - `lhs` (`map`): Input argument for operation execution.
  - `rhs` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `tensorDivElementwise` functionality within the `TensorElementwiseContract` domain.

##### `op tensorMeanAxis`
```flux
op tensorMeanAxis (as map: tensor, as int64: axis) as map
```
- **Parameters**:
  - `tensor` (`map`): Input argument for operation execution.
  - `axis` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `tensorMeanAxis` functionality within the `TensorElementwiseContract` domain.

##### `op tensorMinAxis`
```flux
op tensorMinAxis (as map: tensor, as int64: axis) as map
```
- **Parameters**:
  - `tensor` (`map`): Input argument for operation execution.
  - `axis` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `tensorMinAxis` functionality within the `TensorElementwiseContract` domain.

##### `op tensorMaxAxis`
```flux
op tensorMaxAxis (as map: tensor, as int64: axis) as map
```
- **Parameters**:
  - `tensor` (`map`): Input argument for operation execution.
  - `axis` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `tensorMaxAxis` functionality within the `TensorElementwiseContract` domain.

##### `op tensorClamp`
```flux
op tensorClamp (as map: tensor, as float64: min_val, as float64: max_val) as map
```
- **Parameters**:
  - `tensor` (`map`): Input argument for operation execution.
  - `min_val` (`float64`): Input argument for operation execution.
  - `max_val` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `tensorClamp` functionality within the `TensorElementwiseContract` domain.

### 4.11 Contract `TensorMathContract` (`TensorMath.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `tensorSumAll` | `op tensorSumAll (as map: tensor) as float64` | `float64` |
| `tensorMeanAll` | `op tensorMeanAll (as map: tensor) as float64` | `float64` |
| `tensorMinAll` | `op tensorMinAll (as map: tensor) as float64` | `float64` |
| `tensorMaxAll` | `op tensorMaxAll (as map: tensor) as float64` | `float64` |
| `tensorAbs` | `op tensorAbs (as map: tensor) as map` | `map` |
| `tensorNeg` | `op tensorNeg (as map: tensor) as map` | `map` |
| `tensorSqrtElementwise` | `op tensorSqrtElementwise (as map: tensor) as map` | `map` |
| `tensorPowerScalar` | `op tensorPowerScalar (as map: tensor, as int64: exponent) as map` | `map` |

#### Operation Technical Specifications:

##### `op tensorSumAll`
```flux
op tensorSumAll (as map: tensor) as float64
```
- **Parameters**:
  - `tensor` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `tensorSumAll` functionality within the `TensorMathContract` domain.

##### `op tensorMeanAll`
```flux
op tensorMeanAll (as map: tensor) as float64
```
- **Parameters**:
  - `tensor` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `tensorMeanAll` functionality within the `TensorMathContract` domain.

##### `op tensorMinAll`
```flux
op tensorMinAll (as map: tensor) as float64
```
- **Parameters**:
  - `tensor` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `tensorMinAll` functionality within the `TensorMathContract` domain.

##### `op tensorMaxAll`
```flux
op tensorMaxAll (as map: tensor) as float64
```
- **Parameters**:
  - `tensor` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `tensorMaxAll` functionality within the `TensorMathContract` domain.

##### `op tensorAbs`
```flux
op tensorAbs (as map: tensor) as map
```
- **Parameters**:
  - `tensor` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `tensorAbs` functionality within the `TensorMathContract` domain.

##### `op tensorNeg`
```flux
op tensorNeg (as map: tensor) as map
```
- **Parameters**:
  - `tensor` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `tensorNeg` functionality within the `TensorMathContract` domain.

##### `op tensorSqrtElementwise`
```flux
op tensorSqrtElementwise (as map: tensor) as map
```
- **Parameters**:
  - `tensor` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `tensorSqrtElementwise` functionality within the `TensorMathContract` domain.

##### `op tensorPowerScalar`
```flux
op tensorPowerScalar (as map: tensor, as int64: exponent) as map
```
- **Parameters**:
  - `tensor` (`map`): Input argument for operation execution.
  - `exponent` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `tensorPowerScalar` functionality within the `TensorMathContract` domain.

### 4.12 Contract `TensorMultilinearContract` (`TensorMultilinear.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `tensorExtractSlice` | `op tensorExtractSlice (as map: tensor, as int64: axis, as int64: index) as map` | `map` |
| `tensorInsertSlice` | `op tensorInsertSlice (as map: tensor, as map: slice_tensor, as int64: axis, as int64: index) as map` | `map` |
| `tensorDiagonal3D` | `op tensorDiagonal3D (as map: tensor) as list of data` | `list of data` |
| `tensorTrace3D` | `op tensorTrace3D (as map: tensor) as float64` | `float64` |
| `tensorSwapAxes` | `op tensorSwapAxes (as map: tensor, as int64: axis1, as int64: axis2) as map` | `map` |
| `tensorContract` | `op tensorContract (as map: lhs, as map: rhs, as int64: axis_lhs, as int64: axis_rhs) as map` | `map` |
| `tensorFrobeniusNormND` | `op tensorFrobeniusNormND (as map: tensor) as float64` | `float64` |

#### Operation Technical Specifications:

##### `op tensorExtractSlice`
```flux
op tensorExtractSlice (as map: tensor, as int64: axis, as int64: index) as map
```
- **Parameters**:
  - `tensor` (`map`): Input argument for operation execution.
  - `axis` (`int64`): Input argument for operation execution.
  - `index` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `tensorExtractSlice` functionality within the `TensorMultilinearContract` domain.

##### `op tensorInsertSlice`
```flux
op tensorInsertSlice (as map: tensor, as map: slice_tensor, as int64: axis, as int64: index) as map
```
- **Parameters**:
  - `tensor` (`map`): Input argument for operation execution.
  - `slice_tensor` (`map`): Input argument for operation execution.
  - `axis` (`int64`): Input argument for operation execution.
  - `index` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `tensorInsertSlice` functionality within the `TensorMultilinearContract` domain.

##### `op tensorDiagonal3D`
```flux
op tensorDiagonal3D (as map: tensor) as list of data
```
- **Parameters**:
  - `tensor` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `tensorDiagonal3D` functionality within the `TensorMultilinearContract` domain.

##### `op tensorTrace3D`
```flux
op tensorTrace3D (as map: tensor) as float64
```
- **Parameters**:
  - `tensor` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `tensorTrace3D` functionality within the `TensorMultilinearContract` domain.

##### `op tensorSwapAxes`
```flux
op tensorSwapAxes (as map: tensor, as int64: axis1, as int64: axis2) as map
```
- **Parameters**:
  - `tensor` (`map`): Input argument for operation execution.
  - `axis1` (`int64`): Input argument for operation execution.
  - `axis2` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `tensorSwapAxes` functionality within the `TensorMultilinearContract` domain.

##### `op tensorContract`
```flux
op tensorContract (as map: lhs, as map: rhs, as int64: axis_lhs, as int64: axis_rhs) as map
```
- **Parameters**:
  - `lhs` (`map`): Input argument for operation execution.
  - `rhs` (`map`): Input argument for operation execution.
  - `axis_lhs` (`int64`): Input argument for operation execution.
  - `axis_rhs` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `tensorContract` functionality within the `TensorMultilinearContract` domain.

##### `op tensorFrobeniusNormND`
```flux
op tensorFrobeniusNormND (as map: tensor) as float64
```
- **Parameters**:
  - `tensor` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `tensorFrobeniusNormND` functionality within the `TensorMultilinearContract` domain.

### 4.13 Contract `TensorReductionContract` (`TensorReduction.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `tensorSumAxis` | `op tensorSumAxis (as map: tensor, as int64: axis) as map` | `map` |
| `tensorNormL2Axis` | `op tensorNormL2Axis (as map: tensor, as int64: axis) as map` | `map` |

#### Operation Technical Specifications:

##### `op tensorSumAxis`
```flux
op tensorSumAxis (as map: tensor, as int64: axis) as map
```
- **Parameters**:
  - `tensor` (`map`): Input argument for operation execution.
  - `axis` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `tensorSumAxis` functionality within the `TensorReductionContract` domain.

##### `op tensorNormL2Axis`
```flux
op tensorNormL2Axis (as map: tensor, as int64: axis) as map
```
- **Parameters**:
  - `tensor` (`map`): Input argument for operation execution.
  - `axis` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `tensorNormL2Axis` functionality within the `TensorReductionContract` domain.

### 4.14 Contract `TensorStridesContract` (`TensorStrides.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `tensorNewWithStrides` | `op tensorNewWithStrides (as list of data: shape, as list of data: strides, as int64: offset, as list of data: data_buffer) as map` | `map` |
| `tensorAsStrided` | `op tensorAsStrided (as map: tensor, as list of data: new_shape, as list of data: new_strides, as int64: new_offset) as map` | `map` |
| `tensorSliceView` | `op tensorSliceView (as map: tensor, as list of data: starts, as list of data: ends, as list of data: steps) as map` | `map` |
| `tensorBroadcastTo` | `op tensorBroadcastTo (as map: tensor, as list of data: target_shape) as map` | `map` |
| `tensorIsContiguous` | `op tensorIsContiguous (as map: tensor) as bool` | `bool` |
| `tensorContiguous` | `op tensorContiguous (as map: tensor) as map` | `map` |

#### Operation Technical Specifications:

##### `op tensorNewWithStrides`
```flux
op tensorNewWithStrides (as list of data: shape, as list of data: strides, as int64: offset, as list of data: data_buffer) as map
```
- **Parameters**:
  - `shape` (`list of data`): Input argument for operation execution.
  - `strides` (`list of data`): Input argument for operation execution.
  - `offset` (`int64`): Input argument for operation execution.
  - `data_buffer` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `tensorNewWithStrides` functionality within the `TensorStridesContract` domain.

##### `op tensorAsStrided`
```flux
op tensorAsStrided (as map: tensor, as list of data: new_shape, as list of data: new_strides, as int64: new_offset) as map
```
- **Parameters**:
  - `tensor` (`map`): Input argument for operation execution.
  - `new_shape` (`list of data`): Input argument for operation execution.
  - `new_strides` (`list of data`): Input argument for operation execution.
  - `new_offset` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `tensorAsStrided` functionality within the `TensorStridesContract` domain.

##### `op tensorSliceView`
```flux
op tensorSliceView (as map: tensor, as list of data: starts, as list of data: ends, as list of data: steps) as map
```
- **Parameters**:
  - `tensor` (`map`): Input argument for operation execution.
  - `starts` (`list of data`): Input argument for operation execution.
  - `ends` (`list of data`): Input argument for operation execution.
  - `steps` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `tensorSliceView` functionality within the `TensorStridesContract` domain.

##### `op tensorBroadcastTo`
```flux
op tensorBroadcastTo (as map: tensor, as list of data: target_shape) as map
```
- **Parameters**:
  - `tensor` (`map`): Input argument for operation execution.
  - `target_shape` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `tensorBroadcastTo` functionality within the `TensorStridesContract` domain.

##### `op tensorIsContiguous`
```flux
op tensorIsContiguous (as map: tensor) as bool
```
- **Parameters**:
  - `tensor` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `tensorIsContiguous` functionality within the `TensorStridesContract` domain.

##### `op tensorContiguous`
```flux
op tensorContiguous (as map: tensor) as map
```
- **Parameters**:
  - `tensor` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `tensorContiguous` functionality within the `TensorStridesContract` domain.

### 4.15 Contract `TensorTransformContract` (`TensorTransform.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `tensorReshape` | `op tensorReshape (as map: tensor, as list of data: new_shape) as map` | `map` |
| `tensorFlatten` | `op tensorFlatten (as map: tensor) as list of data` | `list of data` |
| `tensorSqueeze` | `op tensorSqueeze (as map: tensor) as map` | `map` |
| `tensorUnsqueeze` | `op tensorUnsqueeze (as map: tensor, as int64: axis) as map` | `map` |
| `tensorConcatenate` | `op tensorConcatenate (as map: lhs, as map: rhs, as int64: axis) as map` | `map` |

#### Operation Technical Specifications:

##### `op tensorReshape`
```flux
op tensorReshape (as map: tensor, as list of data: new_shape) as map
```
- **Parameters**:
  - `tensor` (`map`): Input argument for operation execution.
  - `new_shape` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `tensorReshape` functionality within the `TensorTransformContract` domain.

##### `op tensorFlatten`
```flux
op tensorFlatten (as map: tensor) as list of data
```
- **Parameters**:
  - `tensor` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `tensorFlatten` functionality within the `TensorTransformContract` domain.

##### `op tensorSqueeze`
```flux
op tensorSqueeze (as map: tensor) as map
```
- **Parameters**:
  - `tensor` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `tensorSqueeze` functionality within the `TensorTransformContract` domain.

##### `op tensorUnsqueeze`
```flux
op tensorUnsqueeze (as map: tensor, as int64: axis) as map
```
- **Parameters**:
  - `tensor` (`map`): Input argument for operation execution.
  - `axis` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `tensorUnsqueeze` functionality within the `TensorTransformContract` domain.

##### `op tensorConcatenate`
```flux
op tensorConcatenate (as map: lhs, as map: rhs, as int64: axis) as map
```
- **Parameters**:
  - `lhs` (`map`): Input argument for operation execution.
  - `rhs` (`map`): Input argument for operation execution.
  - `axis` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `tensorConcatenate` functionality within the `TensorTransformContract` domain.

### 4.16 Contract `VectorGeometryContract` (`VectorGeometry.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `vectorDotProduct` | `op vectorDotProduct (as list of data: u, as list of data: v) as float64` | `float64` |
| `vectorCrossProduct3D` | `op vectorCrossProduct3D (as list of data: u, as list of data: v) as list of data` | `list of data` |
| `vectorOuterProduct` | `op vectorOuterProduct (as list of data: u, as list of data: v) as map` | `map` |
| `vectorNormL1` | `op vectorNormL1 (as list of data: v) as float64` | `float64` |
| `vectorNormL2` | `op vectorNormL2 (as list of data: v) as float64` | `float64` |
| `vectorNormLInf` | `op vectorNormLInf (as list of data: v) as float64` | `float64` |
| `vectorNormalize` | `op vectorNormalize (as list of data: v) as list of data` | `list of data` |
| `vectorAngle` | `op vectorAngle (as list of data: u, as list of data: v) as float64` | `float64` |
| `vectorProjection` | `op vectorProjection (as list of data: u, as list of data: v) as list of data` | `list of data` |

#### Operation Technical Specifications:

##### `op vectorDotProduct`
```flux
op vectorDotProduct (as list of data: u, as list of data: v) as float64
```
- **Parameters**:
  - `u` (`list of data`): Input argument for operation execution.
  - `v` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `vectorDotProduct` functionality within the `VectorGeometryContract` domain.

##### `op vectorCrossProduct3D`
```flux
op vectorCrossProduct3D (as list of data: u, as list of data: v) as list of data
```
- **Parameters**:
  - `u` (`list of data`): Input argument for operation execution.
  - `v` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `vectorCrossProduct3D` functionality within the `VectorGeometryContract` domain.

##### `op vectorOuterProduct`
```flux
op vectorOuterProduct (as list of data: u, as list of data: v) as map
```
- **Parameters**:
  - `u` (`list of data`): Input argument for operation execution.
  - `v` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `vectorOuterProduct` functionality within the `VectorGeometryContract` domain.

##### `op vectorNormL1`
```flux
op vectorNormL1 (as list of data: v) as float64
```
- **Parameters**:
  - `v` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `vectorNormL1` functionality within the `VectorGeometryContract` domain.

##### `op vectorNormL2`
```flux
op vectorNormL2 (as list of data: v) as float64
```
- **Parameters**:
  - `v` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `vectorNormL2` functionality within the `VectorGeometryContract` domain.

##### `op vectorNormLInf`
```flux
op vectorNormLInf (as list of data: v) as float64
```
- **Parameters**:
  - `v` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `vectorNormLInf` functionality within the `VectorGeometryContract` domain.

##### `op vectorNormalize`
```flux
op vectorNormalize (as list of data: v) as list of data
```
- **Parameters**:
  - `v` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `vectorNormalize` functionality within the `VectorGeometryContract` domain.

##### `op vectorAngle`
```flux
op vectorAngle (as list of data: u, as list of data: v) as float64
```
- **Parameters**:
  - `u` (`list of data`): Input argument for operation execution.
  - `v` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `vectorAngle` functionality within the `VectorGeometryContract` domain.

##### `op vectorProjection`
```flux
op vectorProjection (as list of data: u, as list of data: v) as list of data
```
- **Parameters**:
  - `u` (`list of data`): Input argument for operation execution.
  - `v` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `vectorProjection` functionality within the `VectorGeometryContract` domain.

---

## 5. Canonical Usage Examples in TheFlux

The following snippet illustrates importing and utilizing the library in a TheFlux program:

```flux
# Canonical Usage Example for LinAlgStdLib
use LinAlgStdLib

program (ExampleOfLinAlgStdLib) {
      println("==================================================")
      println("  Standard Library Demonstration: LinAlgStdLib")
      println("==================================================")

      # Invoking canonical operation
      mut as data: result = LinAlgStdLib::matrixIdentity(4)
      println("Obtained result: " + result)

      println("Execution completed successfully.")
}
```

---

> [!TIP]
> For the complete unified architecture across all standard libraries, consult the master [StdLibs.md](../StdLibs.md) reference.
