# 📚 `SimdStdLib` — Computação Vetorizada Paralela (SIMD) de Alta Eficiência

> **Pilar Arquitetural**: Pilar 3 (Matemática & Gráficos)  
> **Status**: ✅ Homologado com 100% de Paridade nos 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Arquivo Mestre**: `stdlib/SimdStdLib/SimdStdLib.fdsl`  
> **Modo de Importação**: `use SimdStdLib` ou `use SimdStdLib::<Modulo>::<operacao>`

---

## 1. Visão Geral e Funcionalidades

A biblioteca padrão **`SimdStdLib`** integra o ecossistema oficial da linguagem TheFlux, fornecendo suporte de nível de sistema e algoritmos nativos certificados.

Abstrações portáveis para instruções SIMD (Single Instruction, Multiple Data): operações aritméticas vetorizadas em pistas numéricas paralelas, máscaras de seleção condicional e reduções horizontais (soma vetorial, mínimo e máximo).

### 1.1 Características e Princípios de Design
- **Compilação e Fusão Estática**: Todos os módulos de domínio são fundidos no agente unificado `SimdStdLib` em tempo de compilação, sem sobrecarga (*overhead*) de despacho indireto.
- **Isolamento e Segurança**: As operações verificam limites operacionais e utilizam despacho por contratos formais rigorosos.
- **Compatibilidade Multi-Backend**: Execução bit-a-bit idêntica em interpretador (`in`), bytecode (`vm`, `vmr`), nativo AOT (`llvm`) e WebAssembly (`wat`, `wasm`).

---

## 2. Estrutura Modular e Contratos

A biblioteca é composta por **4 módulos de domínio** e declara **27 operações públicas**:

| Arquivo de Domínio | Contrato Formal | Responsabilidade Principal | Qtd. Ops |
|---|---|---|:---:|
| `SimdMask.fdsl` | `SimdMaskContract` | Domínio especializado de `SimdMask` | 6 |
| `SimdMatrix.fdsl` | `SimdMatrixContract` | Domínio especializado de `SimdMatrix` | 3 |
| `SimdVectorArithmetic.fdsl` | `SimdVectorArithmeticContract` | Domínio especializado de `SimdVectorArithmetic` | 12 |
| `SimdVectorReduction.fdsl` | `SimdVectorReductionContract` | Domínio especializado de `SimdVectorReduction` | 6 |

---

## 3. Tipos, Estruturas e Enumerações Públicas

A biblioteca `SimdStdLib` opera diretamente com os tipos nativos e primitivos da linguagem TheFlux (`string`, `int64`, `float64`, `bool`, `list of data`, etc.), sem exigir tipos compostos adicionais.

---

## 4. Catálogo Detalhado de Operações por Domínio

### 4.1 Contrato `SimdMaskContract` (`SimdMask.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `simdVectorClampF32` | `op simdVectorClampF32 (as list of data: a, as float32: min_v, as float32: max_v) as list of data` | `list of data` |
| `simdVectorClampF64` | `op simdVectorClampF64 (as list of data: a, as float64: min_v, as float64: max_v) as list of data` | `list of data` |
| `simdSelectF32` | `op simdSelectF32 (as list of data: mask, as list of data: a, as list of data: b) as list of data` | `list of data` |
| `simdSelectF64` | `op simdSelectF64 (as list of data: mask, as list of data: a, as list of data: b) as list of data` | `list of data` |
| `simdVectorClamp` | `op simdVectorClamp (as list of data: a, as float64: min_v, as float64: max_v) as list of data` | `list of data` |
| `simdSelect` | `op simdSelect (as list of data: mask, as list of data: a, as list of data: b) as list of data` | `list of data` |

#### Ficha Técnica das Operações:

##### `op simdVectorClampF32`
```flux
op simdVectorClampF32 (as list of data: a, as float32: min_v, as float32: max_v) as list of data
```
- **Parâmetros**:
  - `a` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `min_v` (`float32`): Parâmetro de entrada para processamento da operação.
  - `max_v` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `simdVectorClampF32` no domínio `SimdMaskContract`.

##### `op simdVectorClampF64`
```flux
op simdVectorClampF64 (as list of data: a, as float64: min_v, as float64: max_v) as list of data
```
- **Parâmetros**:
  - `a` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `min_v` (`float64`): Parâmetro de entrada para processamento da operação.
  - `max_v` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `simdVectorClampF64` no domínio `SimdMaskContract`.

##### `op simdSelectF32`
```flux
op simdSelectF32 (as list of data: mask, as list of data: a, as list of data: b) as list of data
```
- **Parâmetros**:
  - `mask` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `a` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `b` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `simdSelectF32` no domínio `SimdMaskContract`.

##### `op simdSelectF64`
```flux
op simdSelectF64 (as list of data: mask, as list of data: a, as list of data: b) as list of data
```
- **Parâmetros**:
  - `mask` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `a` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `b` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `simdSelectF64` no domínio `SimdMaskContract`.

##### `op simdVectorClamp`
```flux
op simdVectorClamp (as list of data: a, as float64: min_v, as float64: max_v) as list of data
```
- **Parâmetros**:
  - `a` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `min_v` (`float64`): Parâmetro de entrada para processamento da operação.
  - `max_v` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `simdVectorClamp` no domínio `SimdMaskContract`.

##### `op simdSelect`
```flux
op simdSelect (as list of data: mask, as list of data: a, as list of data: b) as list of data
```
- **Parâmetros**:
  - `mask` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `a` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `b` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `simdSelect` no domínio `SimdMaskContract`.

### 4.2 Contrato `SimdMatrixContract` (`SimdMatrix.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `simdMatrixMul2DF32` | `op simdMatrixMul2DF32 (as map: lhs, as map: rhs) as map` | `map` |
| `simdMatrixMul2DF64` | `op simdMatrixMul2DF64 (as map: lhs, as map: rhs) as map` | `map` |
| `simdMatrixMul2D` | `op simdMatrixMul2D (as map: lhs, as map: rhs) as map` | `map` |

#### Ficha Técnica das Operações:

##### `op simdMatrixMul2DF32`
```flux
op simdMatrixMul2DF32 (as map: lhs, as map: rhs) as map
```
- **Parâmetros**:
  - `lhs` (`map`): Parâmetro de entrada para processamento da operação.
  - `rhs` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `simdMatrixMul2DF32` no domínio `SimdMatrixContract`.

##### `op simdMatrixMul2DF64`
```flux
op simdMatrixMul2DF64 (as map: lhs, as map: rhs) as map
```
- **Parâmetros**:
  - `lhs` (`map`): Parâmetro de entrada para processamento da operação.
  - `rhs` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `simdMatrixMul2DF64` no domínio `SimdMatrixContract`.

##### `op simdMatrixMul2D`
```flux
op simdMatrixMul2D (as map: lhs, as map: rhs) as map
```
- **Parâmetros**:
  - `lhs` (`map`): Parâmetro de entrada para processamento da operação.
  - `rhs` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `simdMatrixMul2D` no domínio `SimdMatrixContract`.

### 4.3 Contrato `SimdVectorArithmeticContract` (`SimdVectorArithmetic.fdsl`)

| Operação | Assinatura | Retorno |
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

#### Ficha Técnica das Operações:

##### `op simdVectorAddF32`
```flux
op simdVectorAddF32 (as list of data: a, as list of data: b) as list of data
```
- **Parâmetros**:
  - `a` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `b` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `simdVectorAddF32` no domínio `SimdVectorArithmeticContract`.

##### `op simdVectorSubF32`
```flux
op simdVectorSubF32 (as list of data: a, as list of data: b) as list of data
```
- **Parâmetros**:
  - `a` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `b` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `simdVectorSubF32` no domínio `SimdVectorArithmeticContract`.

##### `op simdVectorMulF32`
```flux
op simdVectorMulF32 (as list of data: a, as list of data: b) as list of data
```
- **Parâmetros**:
  - `a` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `b` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `simdVectorMulF32` no domínio `SimdVectorArithmeticContract`.

##### `op simdVectorDivF32`
```flux
op simdVectorDivF32 (as list of data: a, as list of data: b) as list of data
```
- **Parâmetros**:
  - `a` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `b` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `simdVectorDivF32` no domínio `SimdVectorArithmeticContract`.

##### `op simdVectorAddF64`
```flux
op simdVectorAddF64 (as list of data: a, as list of data: b) as list of data
```
- **Parâmetros**:
  - `a` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `b` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `simdVectorAddF64` no domínio `SimdVectorArithmeticContract`.

##### `op simdVectorSubF64`
```flux
op simdVectorSubF64 (as list of data: a, as list of data: b) as list of data
```
- **Parâmetros**:
  - `a` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `b` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `simdVectorSubF64` no domínio `SimdVectorArithmeticContract`.

##### `op simdVectorMulF64`
```flux
op simdVectorMulF64 (as list of data: a, as list of data: b) as list of data
```
- **Parâmetros**:
  - `a` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `b` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `simdVectorMulF64` no domínio `SimdVectorArithmeticContract`.

##### `op simdVectorDivF64`
```flux
op simdVectorDivF64 (as list of data: a, as list of data: b) as list of data
```
- **Parâmetros**:
  - `a` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `b` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `simdVectorDivF64` no domínio `SimdVectorArithmeticContract`.

##### `op simdVectorAdd`
```flux
op simdVectorAdd (as list of data: a, as list of data: b) as list of data
```
- **Parâmetros**:
  - `a` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `b` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `simdVectorAdd` no domínio `SimdVectorArithmeticContract`.

##### `op simdVectorSub`
```flux
op simdVectorSub (as list of data: a, as list of data: b) as list of data
```
- **Parâmetros**:
  - `a` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `b` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `simdVectorSub` no domínio `SimdVectorArithmeticContract`.

##### `op simdVectorMul`
```flux
op simdVectorMul (as list of data: a, as list of data: b) as list of data
```
- **Parâmetros**:
  - `a` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `b` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `simdVectorMul` no domínio `SimdVectorArithmeticContract`.

##### `op simdVectorDiv`
```flux
op simdVectorDiv (as list of data: a, as list of data: b) as list of data
```
- **Parâmetros**:
  - `a` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `b` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `simdVectorDiv` no domínio `SimdVectorArithmeticContract`.

### 4.4 Contrato `SimdVectorReductionContract` (`SimdVectorReduction.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `simdDotProductF32` | `op simdDotProductF32 (as list of data: a, as list of data: b) as float32` | `float32` |
| `simdDotProductF64` | `op simdDotProductF64 (as list of data: a, as list of data: b) as float64` | `float64` |
| `simdVectorSumF32` | `op simdVectorSumF32 (as list of data: a) as float32` | `float32` |
| `simdVectorSumF64` | `op simdVectorSumF64 (as list of data: a) as float64` | `float64` |
| `simdDotProduct` | `op simdDotProduct (as list of data: a, as list of data: b) as float64` | `float64` |
| `simdVectorSum` | `op simdVectorSum (as list of data: a) as float64` | `float64` |

#### Ficha Técnica das Operações:

##### `op simdDotProductF32`
```flux
op simdDotProductF32 (as list of data: a, as list of data: b) as float32
```
- **Parâmetros**:
  - `a` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `b` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `simdDotProductF32` no domínio `SimdVectorReductionContract`.

##### `op simdDotProductF64`
```flux
op simdDotProductF64 (as list of data: a, as list of data: b) as float64
```
- **Parâmetros**:
  - `a` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `b` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `simdDotProductF64` no domínio `SimdVectorReductionContract`.

##### `op simdVectorSumF32`
```flux
op simdVectorSumF32 (as list of data: a) as float32
```
- **Parâmetros**:
  - `a` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `simdVectorSumF32` no domínio `SimdVectorReductionContract`.

##### `op simdVectorSumF64`
```flux
op simdVectorSumF64 (as list of data: a) as float64
```
- **Parâmetros**:
  - `a` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `simdVectorSumF64` no domínio `SimdVectorReductionContract`.

##### `op simdDotProduct`
```flux
op simdDotProduct (as list of data: a, as list of data: b) as float64
```
- **Parâmetros**:
  - `a` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `b` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `simdDotProduct` no domínio `SimdVectorReductionContract`.

##### `op simdVectorSum`
```flux
op simdVectorSum (as list of data: a) as float64
```
- **Parâmetros**:
  - `a` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `simdVectorSum` no domínio `SimdVectorReductionContract`.

---

## 5. Exemplos Canônicos de Uso em TheFlux

O exemplo a seguir demonstra a importação e o consumo prático da biblioteca:

```flux
# Exemplo Canônico de Consumo da SimdStdLib
use SimdStdLib

program (ExemploSimdStdLib) {
      println("==================================================")
      println("  Demonstracao da Standard Library: SimdStdLib")
      println("==================================================")

      # Chamada da operacao canônica
      mut as data: resultado = SimdStdLib::simdVectorAdd([1.0, 2.0], [3.0, 4.0])
      println("Resultado obtido: " + resultado)

      println("Demonstracao concluida com sucesso.")
}
```

---

> [!TIP]
> Para consultar a visão arquitetural unificada de todas as bibliotecas, consulte o documento principal [StdLibs.md](../StdLibs.md).
