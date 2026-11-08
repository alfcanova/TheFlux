# 📚 `SymbolicStdLib` — Computação Algébrica Simbólica, Diferenciação e Polinômios

> **Pilar Arquitetural**: Pilar 3 (Matemática & Gráficos)  
> **Status**: ✅ Homologado com 100% de Paridade nos 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Arquivo Mestre**: `stdlib/SymbolicStdLib/SymbolicStdLib.fdsl`  
> **Modo de Importação**: `use SymbolicStdLib` ou `use SymbolicStdLib::<Modulo>::<operacao>`

---

## 1. Visão Geral e Funcionalidades

A biblioteca padrão **`SymbolicStdLib`** integra o ecossistema oficial da linguagem TheFlux, fornecendo suporte de nível de sistema e algoritmos nativos certificados.

Sistema de álgebra computacional simbólica (CAS): representação de árvores de expressões matemáticas, diferenciação simbólica de funções analíticas, simplificação algébrica de termos, aritmética polinomial exata e divisão com resto.

### 1.1 Características e Princípios de Design
- **Compilação e Fusão Estática**: Todos os módulos de domínio são fundidos no agente unificado `SymbolicStdLib` em tempo de compilação, sem sobrecarga (*overhead*) de despacho indireto.
- **Isolamento e Segurança**: As operações verificam limites operacionais e utilizam despacho por contratos formais rigorosos.
- **Compatibilidade Multi-Backend**: Execução bit-a-bit idêntica em interpretador (`in`), bytecode (`vm`, `vmr`), nativo AOT (`llvm`) e WebAssembly (`wat`, `wasm`).

---

## 2. Estrutura Modular e Contratos

A biblioteca é composta por **9 módulos de domínio** e declara **42 operações públicas**:

| Arquivo de Domínio | Contrato Formal | Responsabilidade Principal | Qtd. Ops |
|---|---|---|:---:|
| `SymbolicCalculus.fdsl` | `SymbolicCalculusContract` | Domínio especializado de `SymbolicCalculus` | 6 |
| `SymbolicCore.fdsl` | `SymbolicCoreContract` | Domínio especializado de `SymbolicCore` | 6 |
| `SymbolicFormat.fdsl` | `SymbolicFormatContract` | Domínio especializado de `SymbolicFormat` | 5 |
| `SymbolicMatrix.fdsl` | `SymbolicMatrixContract` | Domínio especializado de `SymbolicMatrix` | 3 |
| `SymbolicPoly.fdsl` | `SymbolicPolyContract` | Domínio especializado de `SymbolicPoly` | 4 |
| `SymbolicSolver.fdsl` | `SymbolicSolverContract` | Domínio especializado de `SymbolicSolver` | 4 |
| `SymbolicSubstitution.fdsl` | `SymbolicSubstitutionContract` | Domínio especializado de `SymbolicSubstitution` | 4 |
| `SymbolicTransform.fdsl` | `SymbolicTransformContract` | Domínio especializado de `SymbolicTransform` | 5 |
| `SymbolicValidation.fdsl` | `SymbolicValidationContract` | Domínio especializado de `SymbolicValidation` | 5 |

---

## 3. Tipos, Estruturas e Enumerações Públicas

### Estrutura `struct (SymbolicPolyDivideResult)`
*Declarada em: `SymbolicStdLib.fdsl`*

```flux
struct (SymbolicPolyDivideResult) {
      mut: .quotient: string
      mut: .remainder: string
}
```

### Estrutura `struct (SymbolicStats)`
*Declarada em: `SymbolicStdLib.fdsl`*

```flux
struct (SymbolicStats) {
      mut: .node_count: int64
      mut: .depth: int64
      mut: .variable_count: int64
      mut: .is_canonical: bool
}
```

### Estrutura `struct (SymbolicNode)`
*Declarada em: `SymbolicStdLib.fdsl`*

```flux
struct (SymbolicNode) {
      mut: .type_name: string
      mut: .value: string
      mut: .ast_repr: string
}
```

### Enumeração `enum (SymbolicNodeType)`
*Declarada em: `SymbolicStdLib.fdsl`*

```flux
enum (SymbolicNodeType) {
      SymbolicSymbol
      SymbolicNumber
      SymbolicAdd
      SymbolicSub
      SymbolicMul
      SymbolicDivInt
      SymbolicDivFloat
      SymbolicPow
      SymbolicNeg
      SymbolicFunc
}
```

---

## 4. Catálogo Detalhado de Operações por Domínio

### 4.1 Contrato `SymbolicCalculusContract` (`SymbolicCalculus.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `symbolicDifferentiate` | `op symbolicDifferentiate (as string: expression, as string: variable) as string` | `string` |
| `symbolicDiffN` | `op symbolicDiffN (as string: expression, as string: variable, as int64: order) as string` | `string` |
| `symbolicIntegrate` | `op symbolicIntegrate (as string: expression, as string: variable) as string` | `string` |
| `symbolicDefiniteIntegrate` | `op symbolicDefiniteIntegrate (as string: expression, as string: variable, as float64: lower_bound, as float64: upper_bound) as float64` | `float64` |
| `symbolicTaylorSeries` | `op symbolicTaylorSeries (as string: expression, as string: variable, as float64: point, as int64: order) as string` | `string` |
| `symbolicLimit` | `op symbolicLimit (as string: expression, as string: variable, as float64: target, as string: direction) as string` | `string` |

#### Ficha Técnica das Operações:

##### `op symbolicDifferentiate`
```flux
op symbolicDifferentiate (as string: expression, as string: variable) as string
```
- **Parâmetros**:
  - `expression` (`string`): Parâmetro de entrada para processamento da operação.
  - `variable` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `symbolicDifferentiate` no domínio `SymbolicCalculusContract`.

##### `op symbolicDiffN`
```flux
op symbolicDiffN (as string: expression, as string: variable, as int64: order) as string
```
- **Parâmetros**:
  - `expression` (`string`): Parâmetro de entrada para processamento da operação.
  - `variable` (`string`): Parâmetro de entrada para processamento da operação.
  - `order` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `symbolicDiffN` no domínio `SymbolicCalculusContract`.

##### `op symbolicIntegrate`
```flux
op symbolicIntegrate (as string: expression, as string: variable) as string
```
- **Parâmetros**:
  - `expression` (`string`): Parâmetro de entrada para processamento da operação.
  - `variable` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `symbolicIntegrate` no domínio `SymbolicCalculusContract`.

##### `op symbolicDefiniteIntegrate`
```flux
op symbolicDefiniteIntegrate (as string: expression, as string: variable, as float64: lower_bound, as float64: upper_bound) as float64
```
- **Parâmetros**:
  - `expression` (`string`): Parâmetro de entrada para processamento da operação.
  - `variable` (`string`): Parâmetro de entrada para processamento da operação.
  - `lower_bound` (`float64`): Parâmetro de entrada para processamento da operação.
  - `upper_bound` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `symbolicDefiniteIntegrate` no domínio `SymbolicCalculusContract`.

##### `op symbolicTaylorSeries`
```flux
op symbolicTaylorSeries (as string: expression, as string: variable, as float64: point, as int64: order) as string
```
- **Parâmetros**:
  - `expression` (`string`): Parâmetro de entrada para processamento da operação.
  - `variable` (`string`): Parâmetro de entrada para processamento da operação.
  - `point` (`float64`): Parâmetro de entrada para processamento da operação.
  - `order` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `symbolicTaylorSeries` no domínio `SymbolicCalculusContract`.

##### `op symbolicLimit`
```flux
op symbolicLimit (as string: expression, as string: variable, as float64: target, as string: direction) as string
```
- **Parâmetros**:
  - `expression` (`string`): Parâmetro de entrada para processamento da operação.
  - `variable` (`string`): Parâmetro de entrada para processamento da operação.
  - `target` (`float64`): Parâmetro de entrada para processamento da operação.
  - `direction` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `symbolicLimit` no domínio `SymbolicCalculusContract`.

### 4.2 Contrato `SymbolicCoreContract` (`SymbolicCore.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `symbolicSimplify` | `op symbolicSimplify (as string: expression) as string` | `string` |
| `symbolicExpand` | `op symbolicExpand (as string: expression) as string` | `string` |
| `symbolicFactor` | `op symbolicFactor (as string: expression) as string` | `string` |
| `symbolicCancel` | `op symbolicCancel (as string: expression) as string` | `string` |
| `symbolicTogether` | `op symbolicTogether (as string: expression) as string` | `string` |
| `symbolicApart` | `op symbolicApart (as string: expression, as string: variable) as string` | `string` |

#### Ficha Técnica das Operações:

##### `op symbolicSimplify`
```flux
op symbolicSimplify (as string: expression) as string
```
- **Parâmetros**:
  - `expression` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ⚠️ Emite `fail` com status `"erro sintatico: exponenciacao deve usar exclusivamente o operador ^e"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `symbolicSimplify` no domínio `SymbolicCoreContract`.

##### `op symbolicExpand`
```flux
op symbolicExpand (as string: expression) as string
```
- **Parâmetros**:
  - `expression` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `symbolicExpand` no domínio `SymbolicCoreContract`.

##### `op symbolicFactor`
```flux
op symbolicFactor (as string: expression) as string
```
- **Parâmetros**:
  - `expression` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ⚠️ Emite `fail` com status `"erro sintatico: exponenciacao deve usar exclusivamente o operador ^e"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `symbolicFactor` no domínio `SymbolicCoreContract`.

##### `op symbolicCancel`
```flux
op symbolicCancel (as string: expression) as string
```
- **Parâmetros**:
  - `expression` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `symbolicCancel` no domínio `SymbolicCoreContract`.

##### `op symbolicTogether`
```flux
op symbolicTogether (as string: expression) as string
```
- **Parâmetros**:
  - `expression` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `symbolicTogether` no domínio `SymbolicCoreContract`.

##### `op symbolicApart`
```flux
op symbolicApart (as string: expression, as string: variable) as string
```
- **Parâmetros**:
  - `expression` (`string`): Parâmetro de entrada para processamento da operação.
  - `variable` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `symbolicApart` no domínio `SymbolicCoreContract`.

### 4.3 Contrato `SymbolicFormatContract` (`SymbolicFormat.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `symbolicToTheFluxCode` | `op symbolicToTheFluxCode (as string: expression) as string` | `string` |
| `symbolicStats` | `op symbolicStats (as string: expression) as SymbolicStats` | `SymbolicStats` |
| `symbolicToLaTeX` | `op symbolicToLaTeX (as string: expression) as string` | `string` |
| `symbolicToAST` | `op symbolicToAST (as string: expression) as string` | `string` |
| `symbolicParseAst` | `op symbolicParseAst (as string: expression) as SymbolicNode` | `SymbolicNode` |

#### Ficha Técnica das Operações:

##### `op symbolicToTheFluxCode`
```flux
op symbolicToTheFluxCode (as string: expression) as string
```
- **Parâmetros**:
  - `expression` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `symbolicToTheFluxCode` no domínio `SymbolicFormatContract`.

##### `op symbolicStats`
```flux
op symbolicStats (as string: expression) as SymbolicStats
```
- **Parâmetros**:
  - `expression` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `SymbolicStats`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `symbolicStats` no domínio `SymbolicFormatContract`.

##### `op symbolicToLaTeX`
```flux
op symbolicToLaTeX (as string: expression) as string
```
- **Parâmetros**:
  - `expression` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `symbolicToLaTeX` no domínio `SymbolicFormatContract`.

##### `op symbolicToAST`
```flux
op symbolicToAST (as string: expression) as string
```
- **Parâmetros**:
  - `expression` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `symbolicToAST` no domínio `SymbolicFormatContract`.

##### `op symbolicParseAst`
```flux
op symbolicParseAst (as string: expression) as SymbolicNode
```
- **Parâmetros**:
  - `expression` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `SymbolicNode`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `symbolicParseAst` no domínio `SymbolicFormatContract`.

### 4.4 Contrato `SymbolicMatrixContract` (`SymbolicMatrix.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `symbolicMatrixDeterminant` | `op symbolicMatrixDeterminant (as list of data: matrix_rows) as string` | `string` |
| `symbolicMatrixJacobian` | `op symbolicMatrixJacobian (as list of data: expressions, as list of data: variables) as list of data` | `list of data` |
| `symbolicMatrixHessian` | `op symbolicMatrixHessian (as string: expression, as list of data: variables) as list of data` | `list of data` |

#### Ficha Técnica das Operações:

##### `op symbolicMatrixDeterminant`
```flux
op symbolicMatrixDeterminant (as list of data: matrix_rows) as string
```
- **Parâmetros**:
  - `matrix_rows` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `symbolicMatrixDeterminant` no domínio `SymbolicMatrixContract`.

##### `op symbolicMatrixJacobian`
```flux
op symbolicMatrixJacobian (as list of data: expressions, as list of data: variables) as list of data
```
- **Parâmetros**:
  - `expressions` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `variables` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `symbolicMatrixJacobian` no domínio `SymbolicMatrixContract`.

##### `op symbolicMatrixHessian`
```flux
op symbolicMatrixHessian (as string: expression, as list of data: variables) as list of data
```
- **Parâmetros**:
  - `expression` (`string`): Parâmetro de entrada para processamento da operação.
  - `variables` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `symbolicMatrixHessian` no domínio `SymbolicMatrixContract`.

### 4.5 Contrato `SymbolicPolyContract` (`SymbolicPoly.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `symbolicDegree` | `op symbolicDegree (as string: expression, as string: variable) as int64` | `int64` |
| `symbolicCoefficients` | `op symbolicCoefficients (as string: expression, as string: variable) as list of data` | `list of data` |
| `symbolicPolynomialDivide` | `op symbolicPolynomialDivide (as string: numerator, as string: denominator, as string: variable) as SymbolicPolyDivideResult` | `SymbolicPolyDivideResult` |
| `symbolicCollect` | `op symbolicCollect (as string: expression, as string: variable) as string` | `string` |

#### Ficha Técnica das Operações:

##### `op symbolicDegree`
```flux
op symbolicDegree (as string: expression, as string: variable) as int64
```
- **Parâmetros**:
  - `expression` (`string`): Parâmetro de entrada para processamento da operação.
  - `variable` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `symbolicDegree` no domínio `SymbolicPolyContract`.

##### `op symbolicCoefficients`
```flux
op symbolicCoefficients (as string: expression, as string: variable) as list of data
```
- **Parâmetros**:
  - `expression` (`string`): Parâmetro de entrada para processamento da operação.
  - `variable` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `symbolicCoefficients` no domínio `SymbolicPolyContract`.

##### `op symbolicPolynomialDivide`
```flux
op symbolicPolynomialDivide (as string: numerator, as string: denominator, as string: variable) as SymbolicPolyDivideResult
```
- **Parâmetros**:
  - `numerator` (`string`): Parâmetro de entrada para processamento da operação.
  - `denominator` (`string`): Parâmetro de entrada para processamento da operação.
  - `variable` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `SymbolicPolyDivideResult`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `symbolicPolynomialDivide` no domínio `SymbolicPolyContract`.

##### `op symbolicCollect`
```flux
op symbolicCollect (as string: expression, as string: variable) as string
```
- **Parâmetros**:
  - `expression` (`string`): Parâmetro de entrada para processamento da operação.
  - `variable` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `symbolicCollect` no domínio `SymbolicPolyContract`.

### 4.6 Contrato `SymbolicSolverContract` (`SymbolicSolver.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `symbolicSolve` | `op symbolicSolve (as string: equation, as string: variable) as list of data` | `list of data` |
| `symbolicSolveLinear` | `op symbolicSolveLinear (as string: equation, as string: variable) as float64` | `float64` |
| `symbolicSolveQuadratic` | `op symbolicSolveQuadratic (as string: equation, as string: variable) as list of data` | `list of data` |
| `symbolicSolveSystem` | `op symbolicSolveSystem (as list of data: equations, as list of data: variables) as map` | `map` |

#### Ficha Técnica das Operações:

##### `op symbolicSolve`
```flux
op symbolicSolve (as string: equation, as string: variable) as list of data
```
- **Parâmetros**:
  - `equation` (`string`): Parâmetro de entrada para processamento da operação.
  - `variable` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `symbolicSolve` no domínio `SymbolicSolverContract`.

##### `op symbolicSolveLinear`
```flux
op symbolicSolveLinear (as string: equation, as string: variable) as float64
```
- **Parâmetros**:
  - `equation` (`string`): Parâmetro de entrada para processamento da operação.
  - `variable` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ⚠️ Emite `fail` com status `"equacao linear impossivel ou sem solucao unica"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `symbolicSolveLinear` no domínio `SymbolicSolverContract`.

##### `op symbolicSolveQuadratic`
```flux
op symbolicSolveQuadratic (as string: equation, as string: variable) as list of data
```
- **Parâmetros**:
  - `equation` (`string`): Parâmetro de entrada para processamento da operação.
  - `variable` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `symbolicSolveQuadratic` no domínio `SymbolicSolverContract`.

##### `op symbolicSolveSystem`
```flux
op symbolicSolveSystem (as list of data: equations, as list of data: variables) as map
```
- **Parâmetros**:
  - `equations` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `variables` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `symbolicSolveSystem` no domínio `SymbolicSolverContract`.

### 4.7 Contrato `SymbolicSubstitutionContract` (`SymbolicSubstitution.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `symbolicSubstitute` | `op symbolicSubstitute (as string: expression, as string: variable, as string: replacement) as string` | `string` |
| `symbolicSubstituteAll` | `op symbolicSubstituteAll (as string: expression, as map: replacements) as string` | `string` |
| `symbolicEvaluate` | `op symbolicEvaluate (as string: expression, as map: variables) as float64` | `float64` |
| `symbolicGetVariables` | `op symbolicGetVariables (as string: expression) as list of data` | `list of data` |

#### Ficha Técnica das Operações:

##### `op symbolicSubstitute`
```flux
op symbolicSubstitute (as string: expression, as string: variable, as string: replacement) as string
```
- **Parâmetros**:
  - `expression` (`string`): Parâmetro de entrada para processamento da operação.
  - `variable` (`string`): Parâmetro de entrada para processamento da operação.
  - `replacement` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `symbolicSubstitute` no domínio `SymbolicSubstitutionContract`.

##### `op symbolicSubstituteAll`
```flux
op symbolicSubstituteAll (as string: expression, as map: replacements) as string
```
- **Parâmetros**:
  - `expression` (`string`): Parâmetro de entrada para processamento da operação.
  - `replacements` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `symbolicSubstituteAll` no domínio `SymbolicSubstitutionContract`.

##### `op symbolicEvaluate`
```flux
op symbolicEvaluate (as string: expression, as map: variables) as float64
```
- **Parâmetros**:
  - `expression` (`string`): Parâmetro de entrada para processamento da operação.
  - `variables` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `symbolicEvaluate` no domínio `SymbolicSubstitutionContract`.

##### `op symbolicGetVariables`
```flux
op symbolicGetVariables (as string: expression) as list of data
```
- **Parâmetros**:
  - `expression` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `symbolicGetVariables` no domínio `SymbolicSubstitutionContract`.

### 4.8 Contrato `SymbolicTransformContract` (`SymbolicTransform.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `symbolicFourierTransform` | `op symbolicFourierTransform (as string: expression, as string: t_var, as string: w_var) as string` | `string` |
| `symbolicInverseFourierTransform` | `op symbolicInverseFourierTransform (as string: expression, as string: w_var, as string: t_var) as string` | `string` |
| `symbolicFFT` | `op symbolicFFT (as list of data: samples) as list of data` | `list of data` |
| `symbolicIFFT` | `op symbolicIFFT (as list of data: spectrum) as list of data` | `list of data` |
| `symbolicFastPolynomialMul` | `op symbolicFastPolynomialMul (as list of data: poly_a, as list of data: poly_b) as list of data` | `list of data` |

#### Ficha Técnica das Operações:

##### `op symbolicFourierTransform`
```flux
op symbolicFourierTransform (as string: expression, as string: t_var, as string: w_var) as string
```
- **Parâmetros**:
  - `expression` (`string`): Parâmetro de entrada para processamento da operação.
  - `t_var` (`string`): Parâmetro de entrada para processamento da operação.
  - `w_var` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `symbolicFourierTransform` no domínio `SymbolicTransformContract`.

##### `op symbolicInverseFourierTransform`
```flux
op symbolicInverseFourierTransform (as string: expression, as string: w_var, as string: t_var) as string
```
- **Parâmetros**:
  - `expression` (`string`): Parâmetro de entrada para processamento da operação.
  - `w_var` (`string`): Parâmetro de entrada para processamento da operação.
  - `t_var` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `symbolicInverseFourierTransform` no domínio `SymbolicTransformContract`.

##### `op symbolicFFT`
```flux
op symbolicFFT (as list of data: samples) as list of data
```
- **Parâmetros**:
  - `samples` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `symbolicFFT` no domínio `SymbolicTransformContract`.

##### `op symbolicIFFT`
```flux
op symbolicIFFT (as list of data: spectrum) as list of data
```
- **Parâmetros**:
  - `spectrum` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `symbolicIFFT` no domínio `SymbolicTransformContract`.

##### `op symbolicFastPolynomialMul`
```flux
op symbolicFastPolynomialMul (as list of data: poly_a, as list of data: poly_b) as list of data
```
- **Parâmetros**:
  - `poly_a` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `poly_b` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `symbolicFastPolynomialMul` no domínio `SymbolicTransformContract`.

### 4.9 Contrato `SymbolicValidationContract` (`SymbolicValidation.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `symbolicAreEqual` | `op symbolicAreEqual (as string: expr1, as string: expr2) as bool` | `bool` |
| `symbolicIsPolynomial` | `op symbolicIsPolynomial (as string: expression, as string: variable) as bool` | `bool` |
| `symbolicIsLinear` | `op symbolicIsLinear (as string: expression, as string: variable) as bool` | `bool` |
| `symbolicHasVariable` | `op symbolicHasVariable (as string: expression, as string: variable) as bool` | `bool` |
| `symbolicIsValidExpression` | `op symbolicIsValidExpression (as string: expression) as bool` | `bool` |

#### Ficha Técnica das Operações:

##### `op symbolicAreEqual`
```flux
op symbolicAreEqual (as string: expr1, as string: expr2) as bool
```
- **Parâmetros**:
  - `expr1` (`string`): Parâmetro de entrada para processamento da operação.
  - `expr2` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `symbolicAreEqual` no domínio `SymbolicValidationContract`.

##### `op symbolicIsPolynomial`
```flux
op symbolicIsPolynomial (as string: expression, as string: variable) as bool
```
- **Parâmetros**:
  - `expression` (`string`): Parâmetro de entrada para processamento da operação.
  - `variable` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `symbolicIsPolynomial` no domínio `SymbolicValidationContract`.

##### `op symbolicIsLinear`
```flux
op symbolicIsLinear (as string: expression, as string: variable) as bool
```
- **Parâmetros**:
  - `expression` (`string`): Parâmetro de entrada para processamento da operação.
  - `variable` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `symbolicIsLinear` no domínio `SymbolicValidationContract`.

##### `op symbolicHasVariable`
```flux
op symbolicHasVariable (as string: expression, as string: variable) as bool
```
- **Parâmetros**:
  - `expression` (`string`): Parâmetro de entrada para processamento da operação.
  - `variable` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `symbolicHasVariable` no domínio `SymbolicValidationContract`.

##### `op symbolicIsValidExpression`
```flux
op symbolicIsValidExpression (as string: expression) as bool
```
- **Parâmetros**:
  - `expression` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `symbolicIsValidExpression` no domínio `SymbolicValidationContract`.

---

## 5. Exemplos Canônicos de Uso em TheFlux

O exemplo a seguir demonstra a importação e o consumo prático da biblioteca:

```flux
# Exemplo Canônico de Consumo da SymbolicStdLib
use SymbolicStdLib

program (ExemploSymbolicStdLib) {
      println("==================================================")
      println("  Demonstracao da Standard Library: SymbolicStdLib")
      println("==================================================")

      # Chamada da operacao canônica
      mut as data: resultado = SymbolicStdLib::symbolicParse("x^2 + 2*x + 1")
      println("Resultado obtido: " + resultado)

      println("Demonstracao concluida com sucesso.")
}
```

---

> [!TIP]
> Para consultar a visão arquitetural unificada de todas as bibliotecas, consulte o documento principal [StdLibs.md](../StdLibs.md).
