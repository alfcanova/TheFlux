# 📚 `LinAlgStdLib` — Álgebra Linear Computacional, Matrizes e Decomposições

> **Pilar Arquitetural**: Pilar 3 (Matemática & Gráficos)  
> **Status**: ✅ Homologado com 100% de Paridade nos 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Arquivo Mestre**: `stdlib/LinAlgStdLib/LinAlgStdLib.fdsl`  
> **Modo de Importação**: `use LinAlgStdLib` ou `use LinAlgStdLib::<Modulo>::<operacao>`

---

## 1. Visão Geral e Funcionalidades

A biblioteca padrão **`LinAlgStdLib`** integra o ecossistema oficial da linguagem TheFlux, fornecendo suporte de nível de sistema e algoritmos nativos certificados.

Álgebra linear numérica de alta performance: criação de matrizes densas e esparsas, operações matriciais fundamentais, resolução de sistemas lineares, cálculo de autovalores/autovetores e decomposições matriciais avançadas (LU, QR, Cholesky, SVD).

### 1.1 Características e Princípios de Design
- **Compilação e Fusão Estática**: Todos os módulos de domínio são fundidos no agente unificado `LinAlgStdLib` em tempo de compilação, sem sobrecarga (*overhead*) de despacho indireto.
- **Isolamento e Segurança**: As operações verificam limites operacionais e utilizam despacho por contratos formais rigorosos.
- **Compatibilidade Multi-Backend**: Execução bit-a-bit idêntica em interpretador (`in`), bytecode (`vm`, `vmr`), nativo AOT (`llvm`) e WebAssembly (`wat`, `wasm`).

---

## 2. Estrutura Modular e Contratos

A biblioteca é composta por **16 módulos de domínio** e declara **83 operações públicas**:

| Arquivo de Domínio | Contrato Formal | Responsabilidade Principal | Qtd. Ops |
|---|---|---|:---:|
| `MatrixAdvancedDecomposition.fdsl` | `MatrixAdvancedDecompositionContract` | Domínio especializado de `MatrixAdvancedDecomposition` | 5 |
| `MatrixDecomposition.fdsl` | `MatrixDecompositionContract` | Domínio especializado de `MatrixDecomposition` | 4 |
| `MatrixEigen.fdsl` | `MatrixEigenContract` | Domínio especializado de `MatrixEigen` | 7 |
| `MatrixFactory.fdsl` | `MatrixFactoryContract` | Domínio especializado de `MatrixFactory` | 8 |
| `MatrixQR.fdsl` | `MatrixQRContract` | Domínio especializado de `MatrixQR` | 2 |
| `MatrixSVD.fdsl` | `MatrixSVDContract` | Domínio especializado de `MatrixSVD` | 3 |
| `TensorArithmetic.fdsl` | `TensorArithmeticContract` | Domínio especializado de `TensorArithmetic` | 4 |
| `TensorCore.fdsl` | `TensorCoreContract` | Domínio especializado de `TensorCore` | 5 |
| `TensorEinsum.fdsl` | `TensorEinsumContract` | Domínio especializado de `TensorEinsum` | 1 |
| `TensorElementwise.fdsl` | `TensorElementwiseContract` | Domínio especializado de `TensorElementwise` | 7 |
| `TensorMath.fdsl` | `TensorMathContract` | Domínio especializado de `TensorMath` | 8 |
| `TensorMultilinear.fdsl` | `TensorMultilinearContract` | Domínio especializado de `TensorMultilinear` | 7 |
| `TensorReduction.fdsl` | `TensorReductionContract` | Domínio especializado de `TensorReduction` | 2 |
| `TensorStrides.fdsl` | `TensorStridesContract` | Domínio especializado de `TensorStrides` | 6 |
| `TensorTransform.fdsl` | `TensorTransformContract` | Domínio especializado de `TensorTransform` | 5 |
| `VectorGeometry.fdsl` | `VectorGeometryContract` | Domínio especializado de `VectorGeometry` | 9 |

---

## 3. Tipos, Estruturas e Enumerações Públicas

A biblioteca `LinAlgStdLib` opera diretamente com os tipos nativos e primitivos da linguagem TheFlux (`string`, `int64`, `float64`, `bool`, `list of data`, etc.), sem exigir tipos compostos adicionais.

---

## 4. Catálogo Detalhado de Operações por Domínio

### 4.1 Contrato `MatrixAdvancedDecompositionContract` (`MatrixAdvancedDecomposition.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `matrixCholesky` | `op matrixCholesky (as map: matrix) as map` | `map` |
| `matrixSolveCholesky` | `op matrixSolveCholesky (as map: L, as list of data: b) as list of data` | `list of data` |
| `matrixPowerIteration` | `op matrixPowerIteration (as map: matrix, as int64: max_iters, as float64: tolerance) as list of data` | `list of data` |
| `matrixRank` | `op matrixRank (as map: matrix, as float64: tolerance) as int64` | `int64` |
| `matrixFrobeniusNorm` | `op matrixFrobeniusNorm (as map: matrix) as float64` | `float64` |

#### Ficha Técnica das Operações:

##### `op matrixCholesky`
```flux
op matrixCholesky (as map: matrix) as map
```
- **Parâmetros**:
  - `matrix` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `matrixCholesky` no domínio `MatrixAdvancedDecompositionContract`.

##### `op matrixSolveCholesky`
```flux
op matrixSolveCholesky (as map: L, as list of data: b) as list of data
```
- **Parâmetros**:
  - `L` (`map`): Parâmetro de entrada para processamento da operação.
  - `b` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `matrixSolveCholesky` no domínio `MatrixAdvancedDecompositionContract`.

##### `op matrixPowerIteration`
```flux
op matrixPowerIteration (as map: matrix, as int64: max_iters, as float64: tolerance) as list of data
```
- **Parâmetros**:
  - `matrix` (`map`): Parâmetro de entrada para processamento da operação.
  - `max_iters` (`int64`): Parâmetro de entrada para processamento da operação.
  - `tolerance` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `matrixPowerIteration` no domínio `MatrixAdvancedDecompositionContract`.

##### `op matrixRank`
```flux
op matrixRank (as map: matrix, as float64: tolerance) as int64
```
- **Parâmetros**:
  - `matrix` (`map`): Parâmetro de entrada para processamento da operação.
  - `tolerance` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `matrixRank` no domínio `MatrixAdvancedDecompositionContract`.

##### `op matrixFrobeniusNorm`
```flux
op matrixFrobeniusNorm (as map: matrix) as float64
```
- **Parâmetros**:
  - `matrix` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `matrixFrobeniusNorm` no domínio `MatrixAdvancedDecompositionContract`.

### 4.2 Contrato `MatrixDecompositionContract` (`MatrixDecomposition.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `matrixLU` | `op matrixLU (as map: matrix) as list of data` | `list of data` |
| `matrixSolveLU` | `op matrixSolveLU (as map: L, as map: U, as list of data: P, as list of data: b) as list of data` | `list of data` |
| `matrixDeterminant` | `op matrixDeterminant (as map: matrix) as float64` | `float64` |
| `matrixInverse` | `op matrixInverse (as map: matrix) as map` | `map` |

#### Ficha Técnica das Operações:

##### `op matrixLU`
```flux
op matrixLU (as map: matrix) as list of data
```
- **Parâmetros**:
  - `matrix` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `matrixLU` no domínio `MatrixDecompositionContract`.

##### `op matrixSolveLU`
```flux
op matrixSolveLU (as map: L, as map: U, as list of data: P, as list of data: b) as list of data
```
- **Parâmetros**:
  - `L` (`map`): Parâmetro de entrada para processamento da operação.
  - `U` (`map`): Parâmetro de entrada para processamento da operação.
  - `P` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `b` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `matrixSolveLU` no domínio `MatrixDecompositionContract`.

##### `op matrixDeterminant`
```flux
op matrixDeterminant (as map: matrix) as float64
```
- **Parâmetros**:
  - `matrix` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `matrixDeterminant` no domínio `MatrixDecompositionContract`.

##### `op matrixInverse`
```flux
op matrixInverse (as map: matrix) as map
```
- **Parâmetros**:
  - `matrix` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `matrixInverse` no domínio `MatrixDecompositionContract`.

### 4.3 Contrato `MatrixEigenContract` (`MatrixEigen.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `matrixEigenvalues2D` | `op matrixEigenvalues2D (as map: matrix) as list of data` | `list of data` |
| `matrixEigenvaluesQR` | `op matrixEigenvaluesQR (as map: matrix, as int64: max_iters, as float64: tolerance) as list of data` | `list of data` |
| `matrixEigenvectorsQR` | `op matrixEigenvectorsQR (as map: matrix, as int64: max_iters, as float64: tolerance) as list of data` | `list of data` |
| `matrixIsSymmetric` | `op matrixIsSymmetric (as map: matrix, as float64: tolerance) as bool` | `bool` |
| `matrixEigenvectors2D` | `op matrixEigenvectors2D (as map: matrix) as list of data` | `list of data` |
| `matrixEig` | `op matrixEig (as map: matrix, as int64: max_iters, as float64: tolerance) as list of data` | `list of data` |
| `matrixEigenvectorInverseIteration` | `op matrixEigenvectorInverseIteration (as map: matrix, as float64: lambda, as int64: max_iters) as list of data` | `list of data` |

#### Ficha Técnica das Operações:

##### `op matrixEigenvalues2D`
```flux
op matrixEigenvalues2D (as map: matrix) as list of data
```
- **Parâmetros**:
  - `matrix` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `matrixEigenvalues2D` no domínio `MatrixEigenContract`.

##### `op matrixEigenvaluesQR`
```flux
op matrixEigenvaluesQR (as map: matrix, as int64: max_iters, as float64: tolerance) as list of data
```
- **Parâmetros**:
  - `matrix` (`map`): Parâmetro de entrada para processamento da operação.
  - `max_iters` (`int64`): Parâmetro de entrada para processamento da operação.
  - `tolerance` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `matrixEigenvaluesQR` no domínio `MatrixEigenContract`.

##### `op matrixEigenvectorsQR`
```flux
op matrixEigenvectorsQR (as map: matrix, as int64: max_iters, as float64: tolerance) as list of data
```
- **Parâmetros**:
  - `matrix` (`map`): Parâmetro de entrada para processamento da operação.
  - `max_iters` (`int64`): Parâmetro de entrada para processamento da operação.
  - `tolerance` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `matrixEigenvectorsQR` no domínio `MatrixEigenContract`.

##### `op matrixIsSymmetric`
```flux
op matrixIsSymmetric (as map: matrix, as float64: tolerance) as bool
```
- **Parâmetros**:
  - `matrix` (`map`): Parâmetro de entrada para processamento da operação.
  - `tolerance` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `matrixIsSymmetric` no domínio `MatrixEigenContract`.

##### `op matrixEigenvectors2D`
```flux
op matrixEigenvectors2D (as map: matrix) as list of data
```
- **Parâmetros**:
  - `matrix` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `matrixEigenvectors2D` no domínio `MatrixEigenContract`.

##### `op matrixEig`
```flux
op matrixEig (as map: matrix, as int64: max_iters, as float64: tolerance) as list of data
```
- **Parâmetros**:
  - `matrix` (`map`): Parâmetro de entrada para processamento da operação.
  - `max_iters` (`int64`): Parâmetro de entrada para processamento da operação.
  - `tolerance` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `matrixEig` no domínio `MatrixEigenContract`.

##### `op matrixEigenvectorInverseIteration`
```flux
op matrixEigenvectorInverseIteration (as map: matrix, as float64: lambda, as int64: max_iters) as list of data
```
- **Parâmetros**:
  - `matrix` (`map`): Parâmetro de entrada para processamento da operação.
  - `lambda` (`float64`): Parâmetro de entrada para processamento da operação.
  - `max_iters` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `matrixEigenvectorInverseIteration` no domínio `MatrixEigenContract`.

### 4.4 Contrato `MatrixFactoryContract` (`MatrixFactory.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `matrixIdentity` | `op matrixIdentity (as int64: n) as map` | `map` |
| `matrixZeros` | `op matrixZeros (as list of data: shape) as map` | `map` |
| `matrixOnes` | `op matrixOnes (as list of data: shape) as map` | `map` |
| `matrixDiagonal` | `op matrixDiagonal (as list of data: values) as map` | `map` |
| `matrixExtractDiagonal` | `op matrixExtractDiagonal (as map: matrix) as list of data` | `list of data` |
| `matrixTrace` | `op matrixTrace (as map: matrix) as float64` | `float64` |
| `matrixTriu` | `op matrixTriu (as map: matrix, as int64: k) as map` | `map` |
| `matrixTril` | `op matrixTril (as map: matrix, as int64: k) as map` | `map` |

#### Ficha Técnica das Operações:

##### `op matrixIdentity`
```flux
op matrixIdentity (as int64: n) as map
```
- **Parâmetros**:
  - `n` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `matrixIdentity` no domínio `MatrixFactoryContract`.

##### `op matrixZeros`
```flux
op matrixZeros (as list of data: shape) as map
```
- **Parâmetros**:
  - `shape` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `matrixZeros` no domínio `MatrixFactoryContract`.

##### `op matrixOnes`
```flux
op matrixOnes (as list of data: shape) as map
```
- **Parâmetros**:
  - `shape` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `matrixOnes` no domínio `MatrixFactoryContract`.

##### `op matrixDiagonal`
```flux
op matrixDiagonal (as list of data: values) as map
```
- **Parâmetros**:
  - `values` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `matrixDiagonal` no domínio `MatrixFactoryContract`.

##### `op matrixExtractDiagonal`
```flux
op matrixExtractDiagonal (as map: matrix) as list of data
```
- **Parâmetros**:
  - `matrix` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `matrixExtractDiagonal` no domínio `MatrixFactoryContract`.

##### `op matrixTrace`
```flux
op matrixTrace (as map: matrix) as float64
```
- **Parâmetros**:
  - `matrix` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `matrixTrace` no domínio `MatrixFactoryContract`.

##### `op matrixTriu`
```flux
op matrixTriu (as map: matrix, as int64: k) as map
```
- **Parâmetros**:
  - `matrix` (`map`): Parâmetro de entrada para processamento da operação.
  - `k` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `matrixTriu` no domínio `MatrixFactoryContract`.

##### `op matrixTril`
```flux
op matrixTril (as map: matrix, as int64: k) as map
```
- **Parâmetros**:
  - `matrix` (`map`): Parâmetro de entrada para processamento da operação.
  - `k` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `matrixTril` no domínio `MatrixFactoryContract`.

### 4.5 Contrato `MatrixQRContract` (`MatrixQR.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `matrixQR` | `op matrixQR (as map: matrix) as list of data` | `list of data` |
| `matrixSolveQR` | `op matrixSolveQR (as map: Q, as map: R, as list of data: b) as list of data` | `list of data` |

#### Ficha Técnica das Operações:

##### `op matrixQR`
```flux
op matrixQR (as map: matrix) as list of data
```
- **Parâmetros**:
  - `matrix` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `matrixQR` no domínio `MatrixQRContract`.

##### `op matrixSolveQR`
```flux
op matrixSolveQR (as map: Q, as map: R, as list of data: b) as list of data
```
- **Parâmetros**:
  - `Q` (`map`): Parâmetro de entrada para processamento da operação.
  - `R` (`map`): Parâmetro de entrada para processamento da operação.
  - `b` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `matrixSolveQR` no domínio `MatrixQRContract`.

### 4.6 Contrato `MatrixSVDContract` (`MatrixSVD.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `matrixSVD` | `op matrixSVD (as map: matrix) as list of data` | `list of data` |
| `matrixPseudoInverse` | `op matrixPseudoInverse (as map: matrix) as map` | `map` |
| `matrixLeastSquares` | `op matrixLeastSquares (as map: A, as list of data: b) as list of data` | `list of data` |

#### Ficha Técnica das Operações:

##### `op matrixSVD`
```flux
op matrixSVD (as map: matrix) as list of data
```
- **Parâmetros**:
  - `matrix` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `matrixSVD` no domínio `MatrixSVDContract`.

##### `op matrixPseudoInverse`
```flux
op matrixPseudoInverse (as map: matrix) as map
```
- **Parâmetros**:
  - `matrix` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `matrixPseudoInverse` no domínio `MatrixSVDContract`.

##### `op matrixLeastSquares`
```flux
op matrixLeastSquares (as map: A, as list of data: b) as list of data
```
- **Parâmetros**:
  - `A` (`map`): Parâmetro de entrada para processamento da operação.
  - `b` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `matrixLeastSquares` no domínio `MatrixSVDContract`.

### 4.7 Contrato `TensorArithmeticContract` (`TensorArithmetic.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `tensorAddElementwise` | `op tensorAddElementwise (as map: lhs, as map: rhs) as map` | `map` |
| `tensorMulScalar` | `op tensorMulScalar (as map: tensor, as float64: scalar) as map` | `map` |
| `tensorMatMul2D` | `op tensorMatMul2D (as map: lhs, as map: rhs) as map` | `map` |
| `tensorBatchedMatMul` | `op tensorBatchedMatMul (as map: lhs, as map: rhs) as map` | `map` |

#### Ficha Técnica das Operações:

##### `op tensorAddElementwise`
```flux
op tensorAddElementwise (as map: lhs, as map: rhs) as map
```
- **Parâmetros**:
  - `lhs` (`map`): Parâmetro de entrada para processamento da operação.
  - `rhs` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `tensorAddElementwise` no domínio `TensorArithmeticContract`.

##### `op tensorMulScalar`
```flux
op tensorMulScalar (as map: tensor, as float64: scalar) as map
```
- **Parâmetros**:
  - `tensor` (`map`): Parâmetro de entrada para processamento da operação.
  - `scalar` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `tensorMulScalar` no domínio `TensorArithmeticContract`.

##### `op tensorMatMul2D`
```flux
op tensorMatMul2D (as map: lhs, as map: rhs) as map
```
- **Parâmetros**:
  - `lhs` (`map`): Parâmetro de entrada para processamento da operação.
  - `rhs` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `tensorMatMul2D` no domínio `TensorArithmeticContract`.

##### `op tensorBatchedMatMul`
```flux
op tensorBatchedMatMul (as map: lhs, as map: rhs) as map
```
- **Parâmetros**:
  - `lhs` (`map`): Parâmetro de entrada para processamento da operação.
  - `rhs` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `tensorBatchedMatMul` no domínio `TensorArithmeticContract`.

### 4.8 Contrato `TensorCoreContract` (`TensorCore.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `tensorNew` | `op tensorNew (as list of data: shape) as map` | `map` |
| `tensorGetAt` | `op tensorGetAt (as map: tensor, as list of data: indices) as float64` | `float64` |
| `tensorSetAt` | `op tensorSetAt (as map: tensor, as list of data: indices, as float64: val) as map` | `map` |
| `tensorTranspose2D` | `op tensorTranspose2D (as map: tensor) as map` | `map` |
| `tensorPermute` | `op tensorPermute (as map: tensor, as list of data: axes) as map` | `map` |

#### Ficha Técnica das Operações:

##### `op tensorNew`
```flux
op tensorNew (as list of data: shape) as map
```
- **Parâmetros**:
  - `shape` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `tensorNew` no domínio `TensorCoreContract`.

##### `op tensorGetAt`
```flux
op tensorGetAt (as map: tensor, as list of data: indices) as float64
```
- **Parâmetros**:
  - `tensor` (`map`): Parâmetro de entrada para processamento da operação.
  - `indices` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `tensorGetAt` no domínio `TensorCoreContract`.

##### `op tensorSetAt`
```flux
op tensorSetAt (as map: tensor, as list of data: indices, as float64: val) as map
```
- **Parâmetros**:
  - `tensor` (`map`): Parâmetro de entrada para processamento da operação.
  - `indices` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `val` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `tensorSetAt` no domínio `TensorCoreContract`.

##### `op tensorTranspose2D`
```flux
op tensorTranspose2D (as map: tensor) as map
```
- **Parâmetros**:
  - `tensor` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `tensorTranspose2D` no domínio `TensorCoreContract`.

##### `op tensorPermute`
```flux
op tensorPermute (as map: tensor, as list of data: axes) as map
```
- **Parâmetros**:
  - `tensor` (`map`): Parâmetro de entrada para processamento da operação.
  - `axes` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `tensorPermute` no domínio `TensorCoreContract`.

### 4.9 Contrato `TensorEinsumContract` (`TensorEinsum.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `tensorEinsum` | `op tensorEinsum (as string: equation, as list of data: operands) as map` | `map` |

#### Ficha Técnica das Operações:

##### `op tensorEinsum`
```flux
op tensorEinsum (as string: equation, as list of data: operands) as map
```
- **Parâmetros**:
  - `equation` (`string`): Parâmetro de entrada para processamento da operação.
  - `operands` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `tensorEinsum` no domínio `TensorEinsumContract`.

### 4.10 Contrato `TensorElementwiseContract` (`TensorElementwise.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `tensorSubElementwise` | `op tensorSubElementwise (as map: lhs, as map: rhs) as map` | `map` |
| `tensorMulElementwise` | `op tensorMulElementwise (as map: lhs, as map: rhs) as map` | `map` |
| `tensorDivElementwise` | `op tensorDivElementwise (as map: lhs, as map: rhs) as map` | `map` |
| `tensorMeanAxis` | `op tensorMeanAxis (as map: tensor, as int64: axis) as map` | `map` |
| `tensorMinAxis` | `op tensorMinAxis (as map: tensor, as int64: axis) as map` | `map` |
| `tensorMaxAxis` | `op tensorMaxAxis (as map: tensor, as int64: axis) as map` | `map` |
| `tensorClamp` | `op tensorClamp (as map: tensor, as float64: min_val, as float64: max_val) as map` | `map` |

#### Ficha Técnica das Operações:

##### `op tensorSubElementwise`
```flux
op tensorSubElementwise (as map: lhs, as map: rhs) as map
```
- **Parâmetros**:
  - `lhs` (`map`): Parâmetro de entrada para processamento da operação.
  - `rhs` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `tensorSubElementwise` no domínio `TensorElementwiseContract`.

##### `op tensorMulElementwise`
```flux
op tensorMulElementwise (as map: lhs, as map: rhs) as map
```
- **Parâmetros**:
  - `lhs` (`map`): Parâmetro de entrada para processamento da operação.
  - `rhs` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `tensorMulElementwise` no domínio `TensorElementwiseContract`.

##### `op tensorDivElementwise`
```flux
op tensorDivElementwise (as map: lhs, as map: rhs) as map
```
- **Parâmetros**:
  - `lhs` (`map`): Parâmetro de entrada para processamento da operação.
  - `rhs` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `tensorDivElementwise` no domínio `TensorElementwiseContract`.

##### `op tensorMeanAxis`
```flux
op tensorMeanAxis (as map: tensor, as int64: axis) as map
```
- **Parâmetros**:
  - `tensor` (`map`): Parâmetro de entrada para processamento da operação.
  - `axis` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `tensorMeanAxis` no domínio `TensorElementwiseContract`.

##### `op tensorMinAxis`
```flux
op tensorMinAxis (as map: tensor, as int64: axis) as map
```
- **Parâmetros**:
  - `tensor` (`map`): Parâmetro de entrada para processamento da operação.
  - `axis` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `tensorMinAxis` no domínio `TensorElementwiseContract`.

##### `op tensorMaxAxis`
```flux
op tensorMaxAxis (as map: tensor, as int64: axis) as map
```
- **Parâmetros**:
  - `tensor` (`map`): Parâmetro de entrada para processamento da operação.
  - `axis` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `tensorMaxAxis` no domínio `TensorElementwiseContract`.

##### `op tensorClamp`
```flux
op tensorClamp (as map: tensor, as float64: min_val, as float64: max_val) as map
```
- **Parâmetros**:
  - `tensor` (`map`): Parâmetro de entrada para processamento da operação.
  - `min_val` (`float64`): Parâmetro de entrada para processamento da operação.
  - `max_val` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `tensorClamp` no domínio `TensorElementwiseContract`.

### 4.11 Contrato `TensorMathContract` (`TensorMath.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `tensorSumAll` | `op tensorSumAll (as map: tensor) as float64` | `float64` |
| `tensorMeanAll` | `op tensorMeanAll (as map: tensor) as float64` | `float64` |
| `tensorMinAll` | `op tensorMinAll (as map: tensor) as float64` | `float64` |
| `tensorMaxAll` | `op tensorMaxAll (as map: tensor) as float64` | `float64` |
| `tensorAbs` | `op tensorAbs (as map: tensor) as map` | `map` |
| `tensorNeg` | `op tensorNeg (as map: tensor) as map` | `map` |
| `tensorSqrtElementwise` | `op tensorSqrtElementwise (as map: tensor) as map` | `map` |
| `tensorPowerScalar` | `op tensorPowerScalar (as map: tensor, as int64: exponent) as map` | `map` |

#### Ficha Técnica das Operações:

##### `op tensorSumAll`
```flux
op tensorSumAll (as map: tensor) as float64
```
- **Parâmetros**:
  - `tensor` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `tensorSumAll` no domínio `TensorMathContract`.

##### `op tensorMeanAll`
```flux
op tensorMeanAll (as map: tensor) as float64
```
- **Parâmetros**:
  - `tensor` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `tensorMeanAll` no domínio `TensorMathContract`.

##### `op tensorMinAll`
```flux
op tensorMinAll (as map: tensor) as float64
```
- **Parâmetros**:
  - `tensor` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `tensorMinAll` no domínio `TensorMathContract`.

##### `op tensorMaxAll`
```flux
op tensorMaxAll (as map: tensor) as float64
```
- **Parâmetros**:
  - `tensor` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `tensorMaxAll` no domínio `TensorMathContract`.

##### `op tensorAbs`
```flux
op tensorAbs (as map: tensor) as map
```
- **Parâmetros**:
  - `tensor` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `tensorAbs` no domínio `TensorMathContract`.

##### `op tensorNeg`
```flux
op tensorNeg (as map: tensor) as map
```
- **Parâmetros**:
  - `tensor` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `tensorNeg` no domínio `TensorMathContract`.

##### `op tensorSqrtElementwise`
```flux
op tensorSqrtElementwise (as map: tensor) as map
```
- **Parâmetros**:
  - `tensor` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `tensorSqrtElementwise` no domínio `TensorMathContract`.

##### `op tensorPowerScalar`
```flux
op tensorPowerScalar (as map: tensor, as int64: exponent) as map
```
- **Parâmetros**:
  - `tensor` (`map`): Parâmetro de entrada para processamento da operação.
  - `exponent` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `tensorPowerScalar` no domínio `TensorMathContract`.

### 4.12 Contrato `TensorMultilinearContract` (`TensorMultilinear.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `tensorExtractSlice` | `op tensorExtractSlice (as map: tensor, as int64: axis, as int64: index) as map` | `map` |
| `tensorInsertSlice` | `op tensorInsertSlice (as map: tensor, as map: slice_tensor, as int64: axis, as int64: index) as map` | `map` |
| `tensorDiagonal3D` | `op tensorDiagonal3D (as map: tensor) as list of data` | `list of data` |
| `tensorTrace3D` | `op tensorTrace3D (as map: tensor) as float64` | `float64` |
| `tensorSwapAxes` | `op tensorSwapAxes (as map: tensor, as int64: axis1, as int64: axis2) as map` | `map` |
| `tensorContract` | `op tensorContract (as map: lhs, as map: rhs, as int64: axis_lhs, as int64: axis_rhs) as map` | `map` |
| `tensorFrobeniusNormND` | `op tensorFrobeniusNormND (as map: tensor) as float64` | `float64` |

#### Ficha Técnica das Operações:

##### `op tensorExtractSlice`
```flux
op tensorExtractSlice (as map: tensor, as int64: axis, as int64: index) as map
```
- **Parâmetros**:
  - `tensor` (`map`): Parâmetro de entrada para processamento da operação.
  - `axis` (`int64`): Parâmetro de entrada para processamento da operação.
  - `index` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `tensorExtractSlice` no domínio `TensorMultilinearContract`.

##### `op tensorInsertSlice`
```flux
op tensorInsertSlice (as map: tensor, as map: slice_tensor, as int64: axis, as int64: index) as map
```
- **Parâmetros**:
  - `tensor` (`map`): Parâmetro de entrada para processamento da operação.
  - `slice_tensor` (`map`): Parâmetro de entrada para processamento da operação.
  - `axis` (`int64`): Parâmetro de entrada para processamento da operação.
  - `index` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `tensorInsertSlice` no domínio `TensorMultilinearContract`.

##### `op tensorDiagonal3D`
```flux
op tensorDiagonal3D (as map: tensor) as list of data
```
- **Parâmetros**:
  - `tensor` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `tensorDiagonal3D` no domínio `TensorMultilinearContract`.

##### `op tensorTrace3D`
```flux
op tensorTrace3D (as map: tensor) as float64
```
- **Parâmetros**:
  - `tensor` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `tensorTrace3D` no domínio `TensorMultilinearContract`.

##### `op tensorSwapAxes`
```flux
op tensorSwapAxes (as map: tensor, as int64: axis1, as int64: axis2) as map
```
- **Parâmetros**:
  - `tensor` (`map`): Parâmetro de entrada para processamento da operação.
  - `axis1` (`int64`): Parâmetro de entrada para processamento da operação.
  - `axis2` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `tensorSwapAxes` no domínio `TensorMultilinearContract`.

##### `op tensorContract`
```flux
op tensorContract (as map: lhs, as map: rhs, as int64: axis_lhs, as int64: axis_rhs) as map
```
- **Parâmetros**:
  - `lhs` (`map`): Parâmetro de entrada para processamento da operação.
  - `rhs` (`map`): Parâmetro de entrada para processamento da operação.
  - `axis_lhs` (`int64`): Parâmetro de entrada para processamento da operação.
  - `axis_rhs` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `tensorContract` no domínio `TensorMultilinearContract`.

##### `op tensorFrobeniusNormND`
```flux
op tensorFrobeniusNormND (as map: tensor) as float64
```
- **Parâmetros**:
  - `tensor` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `tensorFrobeniusNormND` no domínio `TensorMultilinearContract`.

### 4.13 Contrato `TensorReductionContract` (`TensorReduction.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `tensorSumAxis` | `op tensorSumAxis (as map: tensor, as int64: axis) as map` | `map` |
| `tensorNormL2Axis` | `op tensorNormL2Axis (as map: tensor, as int64: axis) as map` | `map` |

#### Ficha Técnica das Operações:

##### `op tensorSumAxis`
```flux
op tensorSumAxis (as map: tensor, as int64: axis) as map
```
- **Parâmetros**:
  - `tensor` (`map`): Parâmetro de entrada para processamento da operação.
  - `axis` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `tensorSumAxis` no domínio `TensorReductionContract`.

##### `op tensorNormL2Axis`
```flux
op tensorNormL2Axis (as map: tensor, as int64: axis) as map
```
- **Parâmetros**:
  - `tensor` (`map`): Parâmetro de entrada para processamento da operação.
  - `axis` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `tensorNormL2Axis` no domínio `TensorReductionContract`.

### 4.14 Contrato `TensorStridesContract` (`TensorStrides.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `tensorNewWithStrides` | `op tensorNewWithStrides (as list of data: shape, as list of data: strides, as int64: offset, as list of data: data_buffer) as map` | `map` |
| `tensorAsStrided` | `op tensorAsStrided (as map: tensor, as list of data: new_shape, as list of data: new_strides, as int64: new_offset) as map` | `map` |
| `tensorSliceView` | `op tensorSliceView (as map: tensor, as list of data: starts, as list of data: ends, as list of data: steps) as map` | `map` |
| `tensorBroadcastTo` | `op tensorBroadcastTo (as map: tensor, as list of data: target_shape) as map` | `map` |
| `tensorIsContiguous` | `op tensorIsContiguous (as map: tensor) as bool` | `bool` |
| `tensorContiguous` | `op tensorContiguous (as map: tensor) as map` | `map` |

#### Ficha Técnica das Operações:

##### `op tensorNewWithStrides`
```flux
op tensorNewWithStrides (as list of data: shape, as list of data: strides, as int64: offset, as list of data: data_buffer) as map
```
- **Parâmetros**:
  - `shape` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `strides` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `offset` (`int64`): Parâmetro de entrada para processamento da operação.
  - `data_buffer` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `tensorNewWithStrides` no domínio `TensorStridesContract`.

##### `op tensorAsStrided`
```flux
op tensorAsStrided (as map: tensor, as list of data: new_shape, as list of data: new_strides, as int64: new_offset) as map
```
- **Parâmetros**:
  - `tensor` (`map`): Parâmetro de entrada para processamento da operação.
  - `new_shape` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `new_strides` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `new_offset` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `tensorAsStrided` no domínio `TensorStridesContract`.

##### `op tensorSliceView`
```flux
op tensorSliceView (as map: tensor, as list of data: starts, as list of data: ends, as list of data: steps) as map
```
- **Parâmetros**:
  - `tensor` (`map`): Parâmetro de entrada para processamento da operação.
  - `starts` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `ends` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `steps` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `tensorSliceView` no domínio `TensorStridesContract`.

##### `op tensorBroadcastTo`
```flux
op tensorBroadcastTo (as map: tensor, as list of data: target_shape) as map
```
- **Parâmetros**:
  - `tensor` (`map`): Parâmetro de entrada para processamento da operação.
  - `target_shape` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `tensorBroadcastTo` no domínio `TensorStridesContract`.

##### `op tensorIsContiguous`
```flux
op tensorIsContiguous (as map: tensor) as bool
```
- **Parâmetros**:
  - `tensor` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `tensorIsContiguous` no domínio `TensorStridesContract`.

##### `op tensorContiguous`
```flux
op tensorContiguous (as map: tensor) as map
```
- **Parâmetros**:
  - `tensor` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `tensorContiguous` no domínio `TensorStridesContract`.

### 4.15 Contrato `TensorTransformContract` (`TensorTransform.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `tensorReshape` | `op tensorReshape (as map: tensor, as list of data: new_shape) as map` | `map` |
| `tensorFlatten` | `op tensorFlatten (as map: tensor) as list of data` | `list of data` |
| `tensorSqueeze` | `op tensorSqueeze (as map: tensor) as map` | `map` |
| `tensorUnsqueeze` | `op tensorUnsqueeze (as map: tensor, as int64: axis) as map` | `map` |
| `tensorConcatenate` | `op tensorConcatenate (as map: lhs, as map: rhs, as int64: axis) as map` | `map` |

#### Ficha Técnica das Operações:

##### `op tensorReshape`
```flux
op tensorReshape (as map: tensor, as list of data: new_shape) as map
```
- **Parâmetros**:
  - `tensor` (`map`): Parâmetro de entrada para processamento da operação.
  - `new_shape` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `tensorReshape` no domínio `TensorTransformContract`.

##### `op tensorFlatten`
```flux
op tensorFlatten (as map: tensor) as list of data
```
- **Parâmetros**:
  - `tensor` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `tensorFlatten` no domínio `TensorTransformContract`.

##### `op tensorSqueeze`
```flux
op tensorSqueeze (as map: tensor) as map
```
- **Parâmetros**:
  - `tensor` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `tensorSqueeze` no domínio `TensorTransformContract`.

##### `op tensorUnsqueeze`
```flux
op tensorUnsqueeze (as map: tensor, as int64: axis) as map
```
- **Parâmetros**:
  - `tensor` (`map`): Parâmetro de entrada para processamento da operação.
  - `axis` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `tensorUnsqueeze` no domínio `TensorTransformContract`.

##### `op tensorConcatenate`
```flux
op tensorConcatenate (as map: lhs, as map: rhs, as int64: axis) as map
```
- **Parâmetros**:
  - `lhs` (`map`): Parâmetro de entrada para processamento da operação.
  - `rhs` (`map`): Parâmetro de entrada para processamento da operação.
  - `axis` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `tensorConcatenate` no domínio `TensorTransformContract`.

### 4.16 Contrato `VectorGeometryContract` (`VectorGeometry.fdsl`)

| Operação | Assinatura | Retorno |
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

#### Ficha Técnica das Operações:

##### `op vectorDotProduct`
```flux
op vectorDotProduct (as list of data: u, as list of data: v) as float64
```
- **Parâmetros**:
  - `u` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `v` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `vectorDotProduct` no domínio `VectorGeometryContract`.

##### `op vectorCrossProduct3D`
```flux
op vectorCrossProduct3D (as list of data: u, as list of data: v) as list of data
```
- **Parâmetros**:
  - `u` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `v` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `vectorCrossProduct3D` no domínio `VectorGeometryContract`.

##### `op vectorOuterProduct`
```flux
op vectorOuterProduct (as list of data: u, as list of data: v) as map
```
- **Parâmetros**:
  - `u` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `v` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `vectorOuterProduct` no domínio `VectorGeometryContract`.

##### `op vectorNormL1`
```flux
op vectorNormL1 (as list of data: v) as float64
```
- **Parâmetros**:
  - `v` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `vectorNormL1` no domínio `VectorGeometryContract`.

##### `op vectorNormL2`
```flux
op vectorNormL2 (as list of data: v) as float64
```
- **Parâmetros**:
  - `v` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `vectorNormL2` no domínio `VectorGeometryContract`.

##### `op vectorNormLInf`
```flux
op vectorNormLInf (as list of data: v) as float64
```
- **Parâmetros**:
  - `v` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `vectorNormLInf` no domínio `VectorGeometryContract`.

##### `op vectorNormalize`
```flux
op vectorNormalize (as list of data: v) as list of data
```
- **Parâmetros**:
  - `v` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `vectorNormalize` no domínio `VectorGeometryContract`.

##### `op vectorAngle`
```flux
op vectorAngle (as list of data: u, as list of data: v) as float64
```
- **Parâmetros**:
  - `u` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `v` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `vectorAngle` no domínio `VectorGeometryContract`.

##### `op vectorProjection`
```flux
op vectorProjection (as list of data: u, as list of data: v) as list of data
```
- **Parâmetros**:
  - `u` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `v` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `vectorProjection` no domínio `VectorGeometryContract`.

---

## 5. Exemplos Canônicos de Uso em TheFlux

O exemplo a seguir demonstra a importação e o consumo prático da biblioteca:

```flux
# Exemplo Canônico de Consumo da LinAlgStdLib
use LinAlgStdLib

program (ExemploLinAlgStdLib) {
      println("==================================================")
      println("  Demonstracao da Standard Library: LinAlgStdLib")
      println("==================================================")

      # Chamada da operacao canônica
      mut as data: resultado = LinAlgStdLib::matrixIdentity(4)
      println("Resultado obtido: " + resultado)

      println("Demonstracao concluida com sucesso.")
}
```

---

> [!TIP]
> Para consultar a visão arquitetural unificada de todas as bibliotecas, consulte o documento principal [StdLibs.md](../StdLibs.md).
