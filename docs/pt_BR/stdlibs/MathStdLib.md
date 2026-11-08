# 📚 `MathStdLib` — Biblioteca Matemática Fundamental, Trigonometria e Funções Especiais

> **Pilar Arquitetural**: Pilar 3 (Matemática & Gráficos)  
> **Status**: ✅ Homologado com 100% de Paridade nos 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Arquivo Mestre**: `stdlib/MathStdLib/MathStdLib.fdsl`  
> **Modo de Importação**: `use MathStdLib` ou `use MathStdLib::<Modulo>::<operacao>`

---

## 1. Visão Geral e Funcionalidades

A biblioteca padrão **`MathStdLib`** integra o ecossistema oficial da linguagem TheFlux, fornecendo suporte de nível de sistema e algoritmos nativos certificados.

Modelo de referência formal da linguagem TheFlux: 756 operações matemáticas de 16, 32 e 64 bits cobrindo aritmética de ponto flutuante, raízes e arredondamentos, exponenciais, logaritmos, trigonometria, funções hiperbólicas, combinatória e funções especiais (Gamma, Beta, Erf).

### 1.1 Características e Princípios de Design
- **Compilação e Fusão Estática**: Todos os módulos de domínio são fundidos no agente unificado `MathStdLib` em tempo de compilação, sem sobrecarga (*overhead*) de despacho indireto.
- **Isolamento e Segurança**: As operações verificam limites operacionais e utilizam despacho por contratos formais rigorosos.
- **Compatibilidade Multi-Backend**: Execução bit-a-bit idêntica em interpretador (`in`), bytecode (`vm`, `vmr`), nativo AOT (`llvm`) e WebAssembly (`wat`, `wasm`).

---

## 2. Estrutura Modular e Contratos

A biblioteca é composta por **10 módulos de domínio** e declara **378 operações públicas**:

| Arquivo de Domínio | Contrato Formal | Responsabilidade Principal | Qtd. Ops |
|---|---|---|:---:|
| `AngleConversion.fdsl` | `AngleConversionContract` | Domínio especializado de `AngleConversion` | 18 |
| `BasicArithmetic.fdsl` | `BasicArithmeticContract` | Domínio especializado de `BasicArithmetic` | 27 |
| `Combinatorics.fdsl` | `CombinatoricsContract` | Domínio especializado de `Combinatorics` | 27 |
| `ExponentialLog.fdsl` | `ExponentialLogContract` | Domínio especializado de `ExponentialLog` | 33 |
| `FloatElementary.fdsl` | `FloatElementaryContract` | Domínio especializado de `FloatElementary` | 27 |
| `Hyperbolic.fdsl` | `HyperbolicContract` | Domínio especializado de `Hyperbolic` | 39 |
| `MathConstants.fdsl` | `MathConstantsContract` | Domínio especializado de `MathConstants` | 45 |
| `RootsAndRounding.fdsl` | `RootsAndRoundingContract` | Domínio especializado de `RootsAndRounding` | 24 |
| `SpecialFunctions.fdsl` | `SpecialFunctionsContract` | Domínio especializado de `SpecialFunctions` | 81 |
| `Trigonometry.fdsl` | `TrigonometryContract` | Domínio especializado de `Trigonometry` | 57 |

---

## 3. Tipos, Estruturas e Enumerações Públicas

A biblioteca `MathStdLib` opera diretamente com os tipos nativos e primitivos da linguagem TheFlux (`string`, `int64`, `float64`, `bool`, `list of data`, etc.), sem exigir tipos compostos adicionais.

---

## 4. Catálogo Detalhado de Operações por Domínio

### 4.1 Contrato `AngleConversionContract` (`AngleConversion.fdsl`)

| Operação | Assinatura | Retorno |
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

#### Ficha Técnica das Operações:

##### `op degreesToRadians64`
```flux
op degreesToRadians64 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `degreesToRadians64` no domínio `AngleConversionContract`.

##### `op degreesToRadians32`
```flux
op degreesToRadians32 (as float32: value) as float32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `degreesToRadians32` no domínio `AngleConversionContract`.

##### `op degreesToRadians16`
```flux
op degreesToRadians16 (as float16: value) as float16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `degreesToRadians16` no domínio `AngleConversionContract`.

##### `op gradiansToRadians64`
```flux
op gradiansToRadians64 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gradiansToRadians64` no domínio `AngleConversionContract`.

##### `op gradiansToRadians32`
```flux
op gradiansToRadians32 (as float32: value) as float32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gradiansToRadians32` no domínio `AngleConversionContract`.

##### `op gradiansToRadians16`
```flux
op gradiansToRadians16 (as float16: value) as float16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gradiansToRadians16` no domínio `AngleConversionContract`.

##### `op radiansToDegrees64`
```flux
op radiansToDegrees64 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `radiansToDegrees64` no domínio `AngleConversionContract`.

##### `op radiansToDegrees32`
```flux
op radiansToDegrees32 (as float32: value) as float32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `radiansToDegrees32` no domínio `AngleConversionContract`.

##### `op radiansToDegrees16`
```flux
op radiansToDegrees16 (as float16: value) as float16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `radiansToDegrees16` no domínio `AngleConversionContract`.

##### `op gradiansToDegrees64`
```flux
op gradiansToDegrees64 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gradiansToDegrees64` no domínio `AngleConversionContract`.

##### `op gradiansToDegrees32`
```flux
op gradiansToDegrees32 (as float32: value) as float32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gradiansToDegrees32` no domínio `AngleConversionContract`.

##### `op gradiansToDegrees16`
```flux
op gradiansToDegrees16 (as float16: value) as float16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gradiansToDegrees16` no domínio `AngleConversionContract`.

##### `op radiansToGradians64`
```flux
op radiansToGradians64 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `radiansToGradians64` no domínio `AngleConversionContract`.

##### `op radiansToGradians32`
```flux
op radiansToGradians32 (as float32: value) as float32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `radiansToGradians32` no domínio `AngleConversionContract`.

##### `op radiansToGradians16`
```flux
op radiansToGradians16 (as float16: value) as float16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `radiansToGradians16` no domínio `AngleConversionContract`.

##### `op degreesToGradians64`
```flux
op degreesToGradians64 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `degreesToGradians64` no domínio `AngleConversionContract`.

##### `op degreesToGradians32`
```flux
op degreesToGradians32 (as float32: value) as float32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `degreesToGradians32` no domínio `AngleConversionContract`.

##### `op degreesToGradians16`
```flux
op degreesToGradians16 (as float16: value) as float16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `degreesToGradians16` no domínio `AngleConversionContract`.

### 4.2 Contrato `BasicArithmeticContract` (`BasicArithmetic.fdsl`)

| Operação | Assinatura | Retorno |
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

#### Ficha Técnica das Operações:

##### `op add64`
```flux
op add64 (as int64: left, as int64: right) as int64
```
- **Parâmetros**:
  - `left` (`int64`): Parâmetro de entrada para processamento da operação.
  - `right` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `add64` no domínio `BasicArithmeticContract`.

##### `op add32`
```flux
op add32 (as int32: left, as int32: right) as int32
```
- **Parâmetros**:
  - `left` (`int32`): Parâmetro de entrada para processamento da operação.
  - `right` (`int32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `add32` no domínio `BasicArithmeticContract`.

##### `op add16`
```flux
op add16 (as int16: left, as int16: right) as int16
```
- **Parâmetros**:
  - `left` (`int16`): Parâmetro de entrada para processamento da operação.
  - `right` (`int16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `add16` no domínio `BasicArithmeticContract`.

##### `op subtract64`
```flux
op subtract64 (as int64: left, as int64: right) as int64
```
- **Parâmetros**:
  - `left` (`int64`): Parâmetro de entrada para processamento da operação.
  - `right` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `subtract64` no domínio `BasicArithmeticContract`.

##### `op subtract32`
```flux
op subtract32 (as int32: left, as int32: right) as int32
```
- **Parâmetros**:
  - `left` (`int32`): Parâmetro de entrada para processamento da operação.
  - `right` (`int32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `subtract32` no domínio `BasicArithmeticContract`.

##### `op subtract16`
```flux
op subtract16 (as int16: left, as int16: right) as int16
```
- **Parâmetros**:
  - `left` (`int16`): Parâmetro de entrada para processamento da operação.
  - `right` (`int16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `subtract16` no domínio `BasicArithmeticContract`.

##### `op multiply64`
```flux
op multiply64 (as int64: left, as int64: right) as int64
```
- **Parâmetros**:
  - `left` (`int64`): Parâmetro de entrada para processamento da operação.
  - `right` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `multiply64` no domínio `BasicArithmeticContract`.

##### `op multiply32`
```flux
op multiply32 (as int32: left, as int32: right) as int32
```
- **Parâmetros**:
  - `left` (`int32`): Parâmetro de entrada para processamento da operação.
  - `right` (`int32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `multiply32` no domínio `BasicArithmeticContract`.

##### `op multiply16`
```flux
op multiply16 (as int16: left, as int16: right) as int16
```
- **Parâmetros**:
  - `left` (`int16`): Parâmetro de entrada para processamento da operação.
  - `right` (`int16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `multiply16` no domínio `BasicArithmeticContract`.

##### `op remainder64`
```flux
op remainder64 (as int64: left, as int64: right) as int64
```
- **Parâmetros**:
  - `left` (`int64`): Parâmetro de entrada para processamento da operação.
  - `right` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `remainder64` no domínio `BasicArithmeticContract`.

##### `op remainder32`
```flux
op remainder32 (as int32: left, as int32: right) as int32
```
- **Parâmetros**:
  - `left` (`int32`): Parâmetro de entrada para processamento da operação.
  - `right` (`int32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `remainder32` no domínio `BasicArithmeticContract`.

##### `op remainder16`
```flux
op remainder16 (as int16: left, as int16: right) as int16
```
- **Parâmetros**:
  - `left` (`int16`): Parâmetro de entrada para processamento da operação.
  - `right` (`int16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `remainder16` no domínio `BasicArithmeticContract`.

##### `op negate64`
```flux
op negate64 (as int64: value) as int64
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `negate64` no domínio `BasicArithmeticContract`.

##### `op negate32`
```flux
op negate32 (as int32: value) as int32
```
- **Parâmetros**:
  - `value` (`int32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `negate32` no domínio `BasicArithmeticContract`.

##### `op negate16`
```flux
op negate16 (as int16: value) as int16
```
- **Parâmetros**:
  - `value` (`int16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `negate16` no domínio `BasicArithmeticContract`.

##### `op divideInt64`
```flux
op divideInt64 (as int64: left, as int64: right) as int64
```
- **Parâmetros**:
  - `left` (`int64`): Parâmetro de entrada para processamento da operação.
  - `right` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
  - ⚠️ Emite `fail` com status `"divisao inteira por zero"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `divideInt64` no domínio `BasicArithmeticContract`.

##### `op divideInt32`
```flux
op divideInt32 (as int32: left, as int32: right) as int32
```
- **Parâmetros**:
  - `left` (`int32`): Parâmetro de entrada para processamento da operação.
  - `right` (`int32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int32`
  - ✅ Emite `nice` com status `"ok"`
  - ⚠️ Emite `fail` com status `"divisao inteira por zero"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `divideInt32` no domínio `BasicArithmeticContract`.

##### `op divideInt16`
```flux
op divideInt16 (as int16: left, as int16: right) as int16
```
- **Parâmetros**:
  - `left` (`int16`): Parâmetro de entrada para processamento da operação.
  - `right` (`int16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int16`
  - ✅ Emite `nice` com status `"ok"`
  - ⚠️ Emite `fail` com status `"divisao inteira por zero"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `divideInt16` no domínio `BasicArithmeticContract`.

##### `op divideFloat64`
```flux
op divideFloat64 (as float64: left, as float64: right) as float64
```
- **Parâmetros**:
  - `left` (`float64`): Parâmetro de entrada para processamento da operação.
  - `right` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
  - ⚠️ Emite `fail` com status `"divisao decimal por zero"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `divideFloat64` no domínio `BasicArithmeticContract`.

##### `op divideFloat32`
```flux
op divideFloat32 (as float32: left, as float32: right) as float32
```
- **Parâmetros**:
  - `left` (`float32`): Parâmetro de entrada para processamento da operação.
  - `right` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
  - ⚠️ Emite `fail` com status `"divisao decimal por zero"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `divideFloat32` no domínio `BasicArithmeticContract`.

##### `op divideFloat16`
```flux
op divideFloat16 (as float16: left, as float16: right) as float16
```
- **Parâmetros**:
  - `left` (`float16`): Parâmetro de entrada para processamento da operação.
  - `right` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
  - ⚠️ Emite `fail` com status `"divisao decimal por zero"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `divideFloat16` no domínio `BasicArithmeticContract`.

##### `op power64`
```flux
op power64 (as float64: left, as float64: right) as float64
```
- **Parâmetros**:
  - `left` (`float64`): Parâmetro de entrada para processamento da operação.
  - `right` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `power64` no domínio `BasicArithmeticContract`.

##### `op power32`
```flux
op power32 (as float32: left, as float32: right) as float32
```
- **Parâmetros**:
  - `left` (`float32`): Parâmetro de entrada para processamento da operação.
  - `right` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `power32` no domínio `BasicArithmeticContract`.

##### `op power16`
```flux
op power16 (as float16: left, as float16: right) as float16
```
- **Parâmetros**:
  - `left` (`float16`): Parâmetro de entrada para processamento da operação.
  - `right` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `power16` no domínio `BasicArithmeticContract`.

##### `op root64`
```flux
op root64 (as float64: degree, as float64: radicand) as float64
```
- **Parâmetros**:
  - `degree` (`float64`): Parâmetro de entrada para processamento da operação.
  - `radicand` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ⚠️ Emite `fail` com status `"grau da raiz nao pode ser zero"`
  - ⚠️ Emite `fail` com status `"radicando negativo"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `root64` no domínio `BasicArithmeticContract`.

##### `op root32`
```flux
op root32 (as float32: degree, as float32: radicand) as float32
```
- **Parâmetros**:
  - `degree` (`float32`): Parâmetro de entrada para processamento da operação.
  - `radicand` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ⚠️ Emite `fail` com status `"grau da raiz nao pode ser zero"`
  - ⚠️ Emite `fail` com status `"radicando negativo"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `root32` no domínio `BasicArithmeticContract`.

##### `op root16`
```flux
op root16 (as float16: degree, as float16: radicand) as float16
```
- **Parâmetros**:
  - `degree` (`float16`): Parâmetro de entrada para processamento da operação.
  - `radicand` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ⚠️ Emite `fail` com status `"grau da raiz nao pode ser zero"`
  - ⚠️ Emite `fail` com status `"radicando negativo"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `root16` no domínio `BasicArithmeticContract`.

### 4.3 Contrato `CombinatoricsContract` (`Combinatorics.fdsl`)

| Operação | Assinatura | Retorno |
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

#### Ficha Técnica das Operações:

##### `op factorial64`
```flux
op factorial64 (as int64: value) as int64
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ⚠️ Emite `fail` com status `"fatorial indefinido para inteiros negativos"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `factorial64` no domínio `CombinatoricsContract`.

##### `op factorial32`
```flux
op factorial32 (as int32: value) as int32
```
- **Parâmetros**:
  - `value` (`int32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int32`
  - ⚠️ Emite `fail` com status `"fatorial indefinido para inteiros negativos"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `factorial32` no domínio `CombinatoricsContract`.

##### `op factorial16`
```flux
op factorial16 (as int16: value) as int16
```
- **Parâmetros**:
  - `value` (`int16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int16`
  - ⚠️ Emite `fail` com status `"fatorial indefinido para inteiros negativos"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `factorial16` no domínio `CombinatoricsContract`.

##### `op arrangements64`
```flux
op arrangements64 (as int64: n, as int64: k) as int64
```
- **Parâmetros**:
  - `n` (`int64`): Parâmetro de entrada para processamento da operação.
  - `k` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ⚠️ Emite `fail` com status `"arranjo requer 0 <= k <= n"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `arrangements64` no domínio `CombinatoricsContract`.

##### `op arrangements32`
```flux
op arrangements32 (as int32: n, as int32: k) as int32
```
- **Parâmetros**:
  - `n` (`int32`): Parâmetro de entrada para processamento da operação.
  - `k` (`int32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int32`
  - ⚠️ Emite `fail` com status `"arranjo requer 0 <= k <= n"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `arrangements32` no domínio `CombinatoricsContract`.

##### `op arrangements16`
```flux
op arrangements16 (as int16: n, as int16: k) as int16
```
- **Parâmetros**:
  - `n` (`int16`): Parâmetro de entrada para processamento da operação.
  - `k` (`int16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int16`
  - ⚠️ Emite `fail` com status `"arranjo requer 0 <= k <= n"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `arrangements16` no domínio `CombinatoricsContract`.

##### `op arrangementsWithRepetition64`
```flux
op arrangementsWithRepetition64 (as int64: n, as int64: k) as int64
```
- **Parâmetros**:
  - `n` (`int64`): Parâmetro de entrada para processamento da operação.
  - `k` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ⚠️ Emite `fail` com status `"arranjo com repeticao requer n >= 0 e k >= 0"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `arrangementsWithRepetition64` no domínio `CombinatoricsContract`.

##### `op arrangementsWithRepetition32`
```flux
op arrangementsWithRepetition32 (as int32: n, as int32: k) as int32
```
- **Parâmetros**:
  - `n` (`int32`): Parâmetro de entrada para processamento da operação.
  - `k` (`int32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int32`
  - ⚠️ Emite `fail` com status `"arranjo com repeticao requer n >= 0 e k >= 0"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `arrangementsWithRepetition32` no domínio `CombinatoricsContract`.

##### `op arrangementsWithRepetition16`
```flux
op arrangementsWithRepetition16 (as int16: n, as int16: k) as int16
```
- **Parâmetros**:
  - `n` (`int16`): Parâmetro de entrada para processamento da operação.
  - `k` (`int16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int16`
  - ⚠️ Emite `fail` com status `"arranjo com repeticao requer n >= 0 e k >= 0"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `arrangementsWithRepetition16` no domínio `CombinatoricsContract`.

##### `op combinations64`
```flux
op combinations64 (as int64: n, as int64: k) as int64
```
- **Parâmetros**:
  - `n` (`int64`): Parâmetro de entrada para processamento da operação.
  - `k` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ⚠️ Emite `fail` com status `"combinacoes requerem 0 <= k <= n"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `combinations64` no domínio `CombinatoricsContract`.

##### `op combinations32`
```flux
op combinations32 (as int32: n, as int32: k) as int32
```
- **Parâmetros**:
  - `n` (`int32`): Parâmetro de entrada para processamento da operação.
  - `k` (`int32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int32`
  - ⚠️ Emite `fail` com status `"combinacoes requerem 0 <= k <= n"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `combinations32` no domínio `CombinatoricsContract`.

##### `op combinations16`
```flux
op combinations16 (as int16: n, as int16: k) as int16
```
- **Parâmetros**:
  - `n` (`int16`): Parâmetro de entrada para processamento da operação.
  - `k` (`int16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int16`
  - ⚠️ Emite `fail` com status `"combinacoes requerem 0 <= k <= n"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `combinations16` no domínio `CombinatoricsContract`.

##### `op combinationsWithRepetition64`
```flux
op combinationsWithRepetition64 (as int64: n, as int64: k) as int64
```
- **Parâmetros**:
  - `n` (`int64`): Parâmetro de entrada para processamento da operação.
  - `k` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ⚠️ Emite `fail` com status `"combinacao com repeticao requer n >= 1 e k >= 0"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `combinationsWithRepetition64` no domínio `CombinatoricsContract`.

##### `op combinationsWithRepetition32`
```flux
op combinationsWithRepetition32 (as int32: n, as int32: k) as int32
```
- **Parâmetros**:
  - `n` (`int32`): Parâmetro de entrada para processamento da operação.
  - `k` (`int32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int32`
  - ⚠️ Emite `fail` com status `"combinacao com repeticao requer n >= 1 e k >= 0"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `combinationsWithRepetition32` no domínio `CombinatoricsContract`.

##### `op combinationsWithRepetition16`
```flux
op combinationsWithRepetition16 (as int16: n, as int16: k) as int16
```
- **Parâmetros**:
  - `n` (`int16`): Parâmetro de entrada para processamento da operação.
  - `k` (`int16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int16`
  - ⚠️ Emite `fail` com status `"combinacao com repeticao requer n >= 1 e k >= 0"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `combinationsWithRepetition16` no domínio `CombinatoricsContract`.

##### `op permutations64`
```flux
op permutations64 (as int64: n, as int64: k) as int64
```
- **Parâmetros**:
  - `n` (`int64`): Parâmetro de entrada para processamento da operação.
  - `k` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `permutations64` no domínio `CombinatoricsContract`.

##### `op permutations32`
```flux
op permutations32 (as int32: n, as int32: k) as int32
```
- **Parâmetros**:
  - `n` (`int32`): Parâmetro de entrada para processamento da operação.
  - `k` (`int32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `permutations32` no domínio `CombinatoricsContract`.

##### `op permutations16`
```flux
op permutations16 (as int16: n, as int16: k) as int16
```
- **Parâmetros**:
  - `n` (`int16`): Parâmetro de entrada para processamento da operação.
  - `k` (`int16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `permutations16` no domínio `CombinatoricsContract`.

##### `op permutationsWithRepetition64`
```flux
op permutationsWithRepetition64 (as int64: n, as int64: k) as int64
```
- **Parâmetros**:
  - `n` (`int64`): Parâmetro de entrada para processamento da operação.
  - `k` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `permutationsWithRepetition64` no domínio `CombinatoricsContract`.

##### `op permutationsWithRepetition32`
```flux
op permutationsWithRepetition32 (as int32: n, as int32: k) as int32
```
- **Parâmetros**:
  - `n` (`int32`): Parâmetro de entrada para processamento da operação.
  - `k` (`int32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `permutationsWithRepetition32` no domínio `CombinatoricsContract`.

##### `op permutationsWithRepetition16`
```flux
op permutationsWithRepetition16 (as int16: n, as int16: k) as int16
```
- **Parâmetros**:
  - `n` (`int16`): Parâmetro de entrada para processamento da operação.
  - `k` (`int16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `permutationsWithRepetition16` no domínio `CombinatoricsContract`.

##### `op greatestCommonDivisor64`
```flux
op greatestCommonDivisor64 (as int64: n, as int64: k) as int64
```
- **Parâmetros**:
  - `n` (`int64`): Parâmetro de entrada para processamento da operação.
  - `k` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `greatestCommonDivisor64` no domínio `CombinatoricsContract`.

##### `op greatestCommonDivisor32`
```flux
op greatestCommonDivisor32 (as int32: n, as int32: k) as int32
```
- **Parâmetros**:
  - `n` (`int32`): Parâmetro de entrada para processamento da operação.
  - `k` (`int32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `greatestCommonDivisor32` no domínio `CombinatoricsContract`.

##### `op greatestCommonDivisor16`
```flux
op greatestCommonDivisor16 (as int16: n, as int16: k) as int16
```
- **Parâmetros**:
  - `n` (`int16`): Parâmetro de entrada para processamento da operação.
  - `k` (`int16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `greatestCommonDivisor16` no domínio `CombinatoricsContract`.

##### `op leastCommonMultiple64`
```flux
op leastCommonMultiple64 (as int64: n, as int64: k) as int64
```
- **Parâmetros**:
  - `n` (`int64`): Parâmetro de entrada para processamento da operação.
  - `k` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `leastCommonMultiple64` no domínio `CombinatoricsContract`.

##### `op leastCommonMultiple32`
```flux
op leastCommonMultiple32 (as int32: n, as int32: k) as int32
```
- **Parâmetros**:
  - `n` (`int32`): Parâmetro de entrada para processamento da operação.
  - `k` (`int32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `leastCommonMultiple32` no domínio `CombinatoricsContract`.

##### `op leastCommonMultiple16`
```flux
op leastCommonMultiple16 (as int16: n, as int16: k) as int16
```
- **Parâmetros**:
  - `n` (`int16`): Parâmetro de entrada para processamento da operação.
  - `k` (`int16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `leastCommonMultiple16` no domínio `CombinatoricsContract`.

### 4.4 Contrato `ExponentialLogContract` (`ExponentialLog.fdsl`)

| Operação | Assinatura | Retorno |
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

#### Ficha Técnica das Operações:

##### `op powerFloat64`
```flux
op powerFloat64 (as float64: base_val, as float64: exponent_val) as float64
```
- **Parâmetros**:
  - `base_val` (`float64`): Parâmetro de entrada para processamento da operação.
  - `exponent_val` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
  - ⚠️ Emite `fail` com status `"potencia indefinida para base zero e expoente nao-positivo"`
  - ⚠️ Emite `fail` com status `"base negativa com expoente nao-inteiro"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `powerFloat64` no domínio `ExponentialLogContract`.

##### `op powerFloat32`
```flux
op powerFloat32 (as float32: base_val, as float32: exponent_val) as float32
```
- **Parâmetros**:
  - `base_val` (`float32`): Parâmetro de entrada para processamento da operação.
  - `exponent_val` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `powerFloat32` no domínio `ExponentialLogContract`.

##### `op powerFloat16`
```flux
op powerFloat16 (as float16: base_val, as float16: exponent_val) as float16
```
- **Parâmetros**:
  - `base_val` (`float16`): Parâmetro de entrada para processamento da operação.
  - `exponent_val` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `powerFloat16` no domínio `ExponentialLogContract`.

##### `op exp64`
```flux
op exp64 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `exp64` no domínio `ExponentialLogContract`.

##### `op exp32`
```flux
op exp32 (as float32: value) as float32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `exp32` no domínio `ExponentialLogContract`.

##### `op exp16`
```flux
op exp16 (as float16: value) as float16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `exp16` no domínio `ExponentialLogContract`.

##### `op log64`
```flux
op log64 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ⚠️ Emite `fail` com status `"dominio do logaritmo natural: (0, inf)"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `log64` no domínio `ExponentialLogContract`.

##### `op log32`
```flux
op log32 (as float32: value) as float32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ⚠️ Emite `fail` com status `"dominio do logaritmo natural: (0, inf)"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `log32` no domínio `ExponentialLogContract`.

##### `op log16`
```flux
op log16 (as float16: value) as float16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ⚠️ Emite `fail` com status `"dominio do logaritmo natural: (0, inf)"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `log16` no domínio `ExponentialLogContract`.

##### `op log2_64`
```flux
op log2_64 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ⚠️ Emite `fail` com status `"dominio de log2: (0, inf)"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `log2_64` no domínio `ExponentialLogContract`.

##### `op log2_32`
```flux
op log2_32 (as float32: value) as float32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ⚠️ Emite `fail` com status `"dominio de log2: (0, inf)"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `log2_32` no domínio `ExponentialLogContract`.

##### `op log2_16`
```flux
op log2_16 (as float16: value) as float16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ⚠️ Emite `fail` com status `"dominio de log2: (0, inf)"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `log2_16` no domínio `ExponentialLogContract`.

##### `op log10_64`
```flux
op log10_64 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ⚠️ Emite `fail` com status `"dominio de log10: (0, inf)"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `log10_64` no domínio `ExponentialLogContract`.

##### `op log10_32`
```flux
op log10_32 (as float32: value) as float32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ⚠️ Emite `fail` com status `"dominio de log10: (0, inf)"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `log10_32` no domínio `ExponentialLogContract`.

##### `op log10_16`
```flux
op log10_16 (as float16: value) as float16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ⚠️ Emite `fail` com status `"dominio de log10: (0, inf)"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `log10_16` no domínio `ExponentialLogContract`.

##### `op expm164`
```flux
op expm164 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `expm164` no domínio `ExponentialLogContract`.

##### `op expm132`
```flux
op expm132 (as float32: value) as float32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `expm132` no domínio `ExponentialLogContract`.

##### `op expm116`
```flux
op expm116 (as float16: value) as float16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `expm116` no domínio `ExponentialLogContract`.

##### `op log1p64`
```flux
op log1p64 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ⚠️ Emite `fail` com status `"dominio de log1p: (-1, inf)"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `log1p64` no domínio `ExponentialLogContract`.

##### `op log1p32`
```flux
op log1p32 (as float32: value) as float32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ⚠️ Emite `fail` com status `"dominio de log1p: (-1, inf)"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `log1p32` no domínio `ExponentialLogContract`.

##### `op log1p16`
```flux
op log1p16 (as float16: value) as float16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ⚠️ Emite `fail` com status `"dominio de log1p: (-1, inf)"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `log1p16` no domínio `ExponentialLogContract`.

##### `op exp2_64`
```flux
op exp2_64 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `exp2_64` no domínio `ExponentialLogContract`.

##### `op exp2_32`
```flux
op exp2_32 (as float32: value) as float32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `exp2_32` no domínio `ExponentialLogContract`.

##### `op exp2_16`
```flux
op exp2_16 (as float16: value) as float16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `exp2_16` no domínio `ExponentialLogContract`.

##### `op exp10_64`
```flux
op exp10_64 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `exp10_64` no domínio `ExponentialLogContract`.

##### `op exp10_32`
```flux
op exp10_32 (as float32: value) as float32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `exp10_32` no domínio `ExponentialLogContract`.

##### `op exp10_16`
```flux
op exp10_16 (as float16: value) as float16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `exp10_16` no domínio `ExponentialLogContract`.

##### `op softplus64`
```flux
op softplus64 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `softplus64` no domínio `ExponentialLogContract`.

##### `op softplus32`
```flux
op softplus32 (as float32: value) as float32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `softplus32` no domínio `ExponentialLogContract`.

##### `op softplus16`
```flux
op softplus16 (as float16: value) as float16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `softplus16` no domínio `ExponentialLogContract`.

##### `op logAddExp64`
```flux
op logAddExp64 (as float64: left, as float64: right) as float64
```
- **Parâmetros**:
  - `left` (`float64`): Parâmetro de entrada para processamento da operação.
  - `right` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `logAddExp64` no domínio `ExponentialLogContract`.

##### `op logAddExp32`
```flux
op logAddExp32 (as float32: left, as float32: right) as float32
```
- **Parâmetros**:
  - `left` (`float32`): Parâmetro de entrada para processamento da operação.
  - `right` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `logAddExp32` no domínio `ExponentialLogContract`.

##### `op logAddExp16`
```flux
op logAddExp16 (as float16: left, as float16: right) as float16
```
- **Parâmetros**:
  - `left` (`float16`): Parâmetro de entrada para processamento da operação.
  - `right` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `logAddExp16` no domínio `ExponentialLogContract`.

### 4.5 Contrato `FloatElementaryContract` (`FloatElementary.fdsl`)

| Operação | Assinatura | Retorno |
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

#### Ficha Técnica das Operações:

##### `op absolute64`
```flux
op absolute64 (as int64: value) as int64
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `absolute64` no domínio `FloatElementaryContract`.

##### `op absolute32`
```flux
op absolute32 (as int32: value) as int32
```
- **Parâmetros**:
  - `value` (`int32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `absolute32` no domínio `FloatElementaryContract`.

##### `op absolute16`
```flux
op absolute16 (as int16: value) as int16
```
- **Parâmetros**:
  - `value` (`int16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `absolute16` no domínio `FloatElementaryContract`.

##### `op minimum64`
```flux
op minimum64 (as int64: left, as int64: right) as int64
```
- **Parâmetros**:
  - `left` (`int64`): Parâmetro de entrada para processamento da operação.
  - `right` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `minimum64` no domínio `FloatElementaryContract`.

##### `op minimum32`
```flux
op minimum32 (as int32: left, as int32: right) as int32
```
- **Parâmetros**:
  - `left` (`int32`): Parâmetro de entrada para processamento da operação.
  - `right` (`int32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `minimum32` no domínio `FloatElementaryContract`.

##### `op minimum16`
```flux
op minimum16 (as int16: left, as int16: right) as int16
```
- **Parâmetros**:
  - `left` (`int16`): Parâmetro de entrada para processamento da operação.
  - `right` (`int16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `minimum16` no domínio `FloatElementaryContract`.

##### `op maximum64`
```flux
op maximum64 (as int64: left, as int64: right) as int64
```
- **Parâmetros**:
  - `left` (`int64`): Parâmetro de entrada para processamento da operação.
  - `right` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `maximum64` no domínio `FloatElementaryContract`.

##### `op maximum32`
```flux
op maximum32 (as int32: left, as int32: right) as int32
```
- **Parâmetros**:
  - `left` (`int32`): Parâmetro de entrada para processamento da operação.
  - `right` (`int32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `maximum32` no domínio `FloatElementaryContract`.

##### `op maximum16`
```flux
op maximum16 (as int16: left, as int16: right) as int16
```
- **Parâmetros**:
  - `left` (`int16`): Parâmetro de entrada para processamento da operação.
  - `right` (`int16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `maximum16` no domínio `FloatElementaryContract`.

##### `op absoluteFloat64`
```flux
op absoluteFloat64 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `absoluteFloat64` no domínio `FloatElementaryContract`.

##### `op absoluteFloat32`
```flux
op absoluteFloat32 (as float32: value) as float32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `absoluteFloat32` no domínio `FloatElementaryContract`.

##### `op absoluteFloat16`
```flux
op absoluteFloat16 (as float16: value) as float16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `absoluteFloat16` no domínio `FloatElementaryContract`.

##### `op signal64`
```flux
op signal64 (as float64: value) as int64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `signal64` no domínio `FloatElementaryContract`.

##### `op signal32`
```flux
op signal32 (as float32: value) as int64
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `signal32` no domínio `FloatElementaryContract`.

##### `op signal16`
```flux
op signal16 (as float16: value) as int64
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `signal16` no domínio `FloatElementaryContract`.

##### `op minimumFloat64`
```flux
op minimumFloat64 (as float64: left, as float64: right) as float64
```
- **Parâmetros**:
  - `left` (`float64`): Parâmetro de entrada para processamento da operação.
  - `right` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `minimumFloat64` no domínio `FloatElementaryContract`.

##### `op minimumFloat32`
```flux
op minimumFloat32 (as float32: left, as float32: right) as float32
```
- **Parâmetros**:
  - `left` (`float32`): Parâmetro de entrada para processamento da operação.
  - `right` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `minimumFloat32` no domínio `FloatElementaryContract`.

##### `op minimumFloat16`
```flux
op minimumFloat16 (as float16: left, as float16: right) as float16
```
- **Parâmetros**:
  - `left` (`float16`): Parâmetro de entrada para processamento da operação.
  - `right` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `minimumFloat16` no domínio `FloatElementaryContract`.

##### `op maximumFloat64`
```flux
op maximumFloat64 (as float64: left, as float64: right) as float64
```
- **Parâmetros**:
  - `left` (`float64`): Parâmetro de entrada para processamento da operação.
  - `right` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `maximumFloat64` no domínio `FloatElementaryContract`.

##### `op maximumFloat32`
```flux
op maximumFloat32 (as float32: left, as float32: right) as float32
```
- **Parâmetros**:
  - `left` (`float32`): Parâmetro de entrada para processamento da operação.
  - `right` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `maximumFloat32` no domínio `FloatElementaryContract`.

##### `op maximumFloat16`
```flux
op maximumFloat16 (as float16: left, as float16: right) as float16
```
- **Parâmetros**:
  - `left` (`float16`): Parâmetro de entrada para processamento da operação.
  - `right` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `maximumFloat16` no domínio `FloatElementaryContract`.

##### `op constrain64`
```flux
op constrain64 (as float64: val, as float64: min_val, as float64: max_val) as float64
```
- **Parâmetros**:
  - `val` (`float64`): Parâmetro de entrada para processamento da operação.
  - `min_val` (`float64`): Parâmetro de entrada para processamento da operação.
  - `max_val` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `constrain64` no domínio `FloatElementaryContract`.

##### `op constrain32`
```flux
op constrain32 (as float32: val, as float32: min_val, as float32: max_val) as float32
```
- **Parâmetros**:
  - `val` (`float32`): Parâmetro de entrada para processamento da operação.
  - `min_val` (`float32`): Parâmetro de entrada para processamento da operação.
  - `max_val` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `constrain32` no domínio `FloatElementaryContract`.

##### `op constrain16`
```flux
op constrain16 (as float16: val, as float16: min_val, as float16: max_val) as float16
```
- **Parâmetros**:
  - `val` (`float16`): Parâmetro de entrada para processamento da operação.
  - `min_val` (`float16`): Parâmetro de entrada para processamento da operação.
  - `max_val` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `constrain16` no domínio `FloatElementaryContract`.

##### `op linearInterpolation64`
```flux
op linearInterpolation64 (as float64: start, as float64: stop, as float64: factor) as float64
```
- **Parâmetros**:
  - `start` (`float64`): Parâmetro de entrada para processamento da operação.
  - `stop` (`float64`): Parâmetro de entrada para processamento da operação.
  - `factor` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `linearInterpolation64` no domínio `FloatElementaryContract`.

##### `op linearInterpolation32`
```flux
op linearInterpolation32 (as float32: start, as float32: stop, as float32: factor) as float32
```
- **Parâmetros**:
  - `start` (`float32`): Parâmetro de entrada para processamento da operação.
  - `stop` (`float32`): Parâmetro de entrada para processamento da operação.
  - `factor` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `linearInterpolation32` no domínio `FloatElementaryContract`.

##### `op linearInterpolation16`
```flux
op linearInterpolation16 (as float16: start, as float16: stop, as float16: factor) as float16
```
- **Parâmetros**:
  - `start` (`float16`): Parâmetro de entrada para processamento da operação.
  - `stop` (`float16`): Parâmetro de entrada para processamento da operação.
  - `factor` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `linearInterpolation16` no domínio `FloatElementaryContract`.

### 4.6 Contrato `HyperbolicContract` (`Hyperbolic.fdsl`)

| Operação | Assinatura | Retorno |
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

#### Ficha Técnica das Operações:

##### `op sinh64`
```flux
op sinh64 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `sinh64` no domínio `HyperbolicContract`.

##### `op sinh32`
```flux
op sinh32 (as float32: value) as float32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `sinh32` no domínio `HyperbolicContract`.

##### `op sinh16`
```flux
op sinh16 (as float16: value) as float16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `sinh16` no domínio `HyperbolicContract`.

##### `op cosh64`
```flux
op cosh64 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `cosh64` no domínio `HyperbolicContract`.

##### `op cosh32`
```flux
op cosh32 (as float32: value) as float32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `cosh32` no domínio `HyperbolicContract`.

##### `op cosh16`
```flux
op cosh16 (as float16: value) as float16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `cosh16` no domínio `HyperbolicContract`.

##### `op tanh64`
```flux
op tanh64 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `tanh64` no domínio `HyperbolicContract`.

##### `op tanh32`
```flux
op tanh32 (as float32: value) as float32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `tanh32` no domínio `HyperbolicContract`.

##### `op tanh16`
```flux
op tanh16 (as float16: value) as float16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `tanh16` no domínio `HyperbolicContract`.

##### `op arcSinh64`
```flux
op arcSinh64 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `arcSinh64` no domínio `HyperbolicContract`.

##### `op arcSinh32`
```flux
op arcSinh32 (as float32: value) as float32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `arcSinh32` no domínio `HyperbolicContract`.

##### `op arcSinh16`
```flux
op arcSinh16 (as float16: value) as float16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `arcSinh16` no domínio `HyperbolicContract`.

##### `op arcCosh64`
```flux
op arcCosh64 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ⚠️ Emite `fail` com status `"dominio de arcCosh: [1, inf)"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `arcCosh64` no domínio `HyperbolicContract`.

##### `op arcCosh32`
```flux
op arcCosh32 (as float32: value) as float32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ⚠️ Emite `fail` com status `"dominio de arcCosh: [1, inf)"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `arcCosh32` no domínio `HyperbolicContract`.

##### `op arcCosh16`
```flux
op arcCosh16 (as float16: value) as float16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ⚠️ Emite `fail` com status `"dominio de arcCosh: [1, inf)"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `arcCosh16` no domínio `HyperbolicContract`.

##### `op arcTanh64`
```flux
op arcTanh64 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ⚠️ Emite `fail` com status `"dominio de arcTanh: (-1, 1)"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `arcTanh64` no domínio `HyperbolicContract`.

##### `op arcTanh32`
```flux
op arcTanh32 (as float32: value) as float32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ⚠️ Emite `fail` com status `"dominio de arcTanh: (-1, 1)"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `arcTanh32` no domínio `HyperbolicContract`.

##### `op arcTanh16`
```flux
op arcTanh16 (as float16: value) as float16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ⚠️ Emite `fail` com status `"dominio de arcTanh: (-1, 1)"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `arcTanh16` no domínio `HyperbolicContract`.

##### `op sech64`
```flux
op sech64 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `sech64` no domínio `HyperbolicContract`.

##### `op sech32`
```flux
op sech32 (as float32: value) as float32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `sech32` no domínio `HyperbolicContract`.

##### `op sech16`
```flux
op sech16 (as float16: value) as float16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `sech16` no domínio `HyperbolicContract`.

##### `op csch64`
```flux
op csch64 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ⚠️ Emite `fail` com status `"cossecante hiperbolica indefinida para zero"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `csch64` no domínio `HyperbolicContract`.

##### `op csch32`
```flux
op csch32 (as float32: value) as float32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `csch32` no domínio `HyperbolicContract`.

##### `op csch16`
```flux
op csch16 (as float16: value) as float16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `csch16` no domínio `HyperbolicContract`.

##### `op coth64`
```flux
op coth64 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ⚠️ Emite `fail` com status `"cotangente hiperbolica indefinida para zero"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `coth64` no domínio `HyperbolicContract`.

##### `op coth32`
```flux
op coth32 (as float32: value) as float32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `coth32` no domínio `HyperbolicContract`.

##### `op coth16`
```flux
op coth16 (as float16: value) as float16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `coth16` no domínio `HyperbolicContract`.

##### `op arcSech64`
```flux
op arcSech64 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ⚠️ Emite `fail` com status `"dominio de arcSech: (0, 1]"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `arcSech64` no domínio `HyperbolicContract`.

##### `op arcSech32`
```flux
op arcSech32 (as float32: value) as float32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `arcSech32` no domínio `HyperbolicContract`.

##### `op arcSech16`
```flux
op arcSech16 (as float16: value) as float16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `arcSech16` no domínio `HyperbolicContract`.

##### `op arcCsch64`
```flux
op arcCsch64 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ⚠️ Emite `fail` com status `"dominio de arcCsch: (-inf, 0) U (0, inf)"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `arcCsch64` no domínio `HyperbolicContract`.

##### `op arcCsch32`
```flux
op arcCsch32 (as float32: value) as float32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `arcCsch32` no domínio `HyperbolicContract`.

##### `op arcCsch16`
```flux
op arcCsch16 (as float16: value) as float16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `arcCsch16` no domínio `HyperbolicContract`.

##### `op arcCoth64`
```flux
op arcCoth64 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ⚠️ Emite `fail` com status `"dominio de arcCoth: (-inf, -1) U (1, inf)"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `arcCoth64` no domínio `HyperbolicContract`.

##### `op arcCoth32`
```flux
op arcCoth32 (as float32: value) as float32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `arcCoth32` no domínio `HyperbolicContract`.

##### `op arcCoth16`
```flux
op arcCoth16 (as float16: value) as float16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `arcCoth16` no domínio `HyperbolicContract`.

##### `op arcTanh2_64`
```flux
op arcTanh2_64 (as float64: y, as float64: x) as float64
```
- **Parâmetros**:
  - `y` (`float64`): Parâmetro de entrada para processamento da operação.
  - `x` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ⚠️ Emite `fail` com status `"arcTanh2 indefinido para x zero"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `arcTanh2_64` no domínio `HyperbolicContract`.

##### `op arcTanh2_32`
```flux
op arcTanh2_32 (as float32: y, as float32: x) as float32
```
- **Parâmetros**:
  - `y` (`float32`): Parâmetro de entrada para processamento da operação.
  - `x` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `arcTanh2_32` no domínio `HyperbolicContract`.

##### `op arcTanh2_16`
```flux
op arcTanh2_16 (as float16: y, as float16: x) as float16
```
- **Parâmetros**:
  - `y` (`float16`): Parâmetro de entrada para processamento da operação.
  - `x` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `arcTanh2_16` no domínio `HyperbolicContract`.

### 4.7 Contrato `MathConstantsContract` (`MathConstants.fdsl`)

| Operação | Assinatura | Retorno |
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

#### Ficha Técnica das Operações:

##### `op pi64`
```flux
op pi64 () as float64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `pi64` no domínio `MathConstantsContract`.

##### `op pi32`
```flux
op pi32 () as float32
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `pi32` no domínio `MathConstantsContract`.

##### `op pi16`
```flux
op pi16 () as float16
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `pi16` no domínio `MathConstantsContract`.

##### `op e64`
```flux
op e64 () as float64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `e64` no domínio `MathConstantsContract`.

##### `op e32`
```flux
op e32 () as float32
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `e32` no domínio `MathConstantsContract`.

##### `op e16`
```flux
op e16 () as float16
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `e16` no domínio `MathConstantsContract`.

##### `op tau64`
```flux
op tau64 () as float64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `tau64` no domínio `MathConstantsContract`.

##### `op tau32`
```flux
op tau32 () as float32
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `tau32` no domínio `MathConstantsContract`.

##### `op tau16`
```flux
op tau16 () as float16
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `tau16` no domínio `MathConstantsContract`.

##### `op sqrt2_64`
```flux
op sqrt2_64 () as float64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `sqrt2_64` no domínio `MathConstantsContract`.

##### `op sqrt2_32`
```flux
op sqrt2_32 () as float32
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `sqrt2_32` no domínio `MathConstantsContract`.

##### `op sqrt2_16`
```flux
op sqrt2_16 () as float16
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `sqrt2_16` no domínio `MathConstantsContract`.

##### `op sqrt3_64`
```flux
op sqrt3_64 () as float64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `sqrt3_64` no domínio `MathConstantsContract`.

##### `op sqrt3_32`
```flux
op sqrt3_32 () as float32
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `sqrt3_32` no domínio `MathConstantsContract`.

##### `op sqrt3_16`
```flux
op sqrt3_16 () as float16
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `sqrt3_16` no domínio `MathConstantsContract`.

##### `op invSqrt2_64`
```flux
op invSqrt2_64 () as float64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `invSqrt2_64` no domínio `MathConstantsContract`.

##### `op invSqrt2_32`
```flux
op invSqrt2_32 () as float32
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `invSqrt2_32` no domínio `MathConstantsContract`.

##### `op invSqrt2_16`
```flux
op invSqrt2_16 () as float16
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `invSqrt2_16` no domínio `MathConstantsContract`.

##### `op invSqrt3_64`
```flux
op invSqrt3_64 () as float64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `invSqrt3_64` no domínio `MathConstantsContract`.

##### `op invSqrt3_32`
```flux
op invSqrt3_32 () as float32
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `invSqrt3_32` no domínio `MathConstantsContract`.

##### `op invSqrt3_16`
```flux
op invSqrt3_16 () as float16
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `invSqrt3_16` no domínio `MathConstantsContract`.

##### `op ln2_64`
```flux
op ln2_64 () as float64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `ln2_64` no domínio `MathConstantsContract`.

##### `op ln2_32`
```flux
op ln2_32 () as float32
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `ln2_32` no domínio `MathConstantsContract`.

##### `op ln2_16`
```flux
op ln2_16 () as float16
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `ln2_16` no domínio `MathConstantsContract`.

##### `op ln10_64`
```flux
op ln10_64 () as float64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `ln10_64` no domínio `MathConstantsContract`.

##### `op ln10_32`
```flux
op ln10_32 () as float32
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `ln10_32` no domínio `MathConstantsContract`.

##### `op ln10_16`
```flux
op ln10_16 () as float16
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `ln10_16` no domínio `MathConstantsContract`.

##### `op log2e64`
```flux
op log2e64 () as float64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `log2e64` no domínio `MathConstantsContract`.

##### `op log2e32`
```flux
op log2e32 () as float32
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `log2e32` no domínio `MathConstantsContract`.

##### `op log2e16`
```flux
op log2e16 () as float16
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `log2e16` no domínio `MathConstantsContract`.

##### `op log10e64`
```flux
op log10e64 () as float64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `log10e64` no domínio `MathConstantsContract`.

##### `op log10e32`
```flux
op log10e32 () as float32
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `log10e32` no domínio `MathConstantsContract`.

##### `op log10e16`
```flux
op log10e16 () as float16
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `log10e16` no domínio `MathConstantsContract`.

##### `op pi_2_64`
```flux
op pi_2_64 () as float64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `pi_2_64` no domínio `MathConstantsContract`.

##### `op pi_2_32`
```flux
op pi_2_32 () as float32
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `pi_2_32` no domínio `MathConstantsContract`.

##### `op pi_2_16`
```flux
op pi_2_16 () as float16
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `pi_2_16` no domínio `MathConstantsContract`.

##### `op pi_4_64`
```flux
op pi_4_64 () as float64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `pi_4_64` no domínio `MathConstantsContract`.

##### `op pi_4_32`
```flux
op pi_4_32 () as float32
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `pi_4_32` no domínio `MathConstantsContract`.

##### `op pi_4_16`
```flux
op pi_4_16 () as float16
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `pi_4_16` no domínio `MathConstantsContract`.

##### `op invPi64`
```flux
op invPi64 () as float64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `invPi64` no domínio `MathConstantsContract`.

##### `op invPi32`
```flux
op invPi32 () as float32
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `invPi32` no domínio `MathConstantsContract`.

##### `op invPi16`
```flux
op invPi16 () as float16
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `invPi16` no domínio `MathConstantsContract`.

##### `op phi64`
```flux
op phi64 () as float64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `phi64` no domínio `MathConstantsContract`.

##### `op phi32`
```flux
op phi32 () as float32
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `phi32` no domínio `MathConstantsContract`.

##### `op phi16`
```flux
op phi16 () as float16
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `phi16` no domínio `MathConstantsContract`.

### 4.8 Contrato `RootsAndRoundingContract` (`RootsAndRounding.fdsl`)

| Operação | Assinatura | Retorno |
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

#### Ficha Técnica das Operações:

##### `op squareRoot64`
```flux
op squareRoot64 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ⚠️ Emite `fail` com status `"raiz quadrada de numero negativo"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `squareRoot64` no domínio `RootsAndRoundingContract`.

##### `op squareRoot32`
```flux
op squareRoot32 (as float32: value) as float32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ⚠️ Emite `fail` com status `"raiz quadrada de numero negativo"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `squareRoot32` no domínio `RootsAndRoundingContract`.

##### `op squareRoot16`
```flux
op squareRoot16 (as float16: value) as float16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ⚠️ Emite `fail` com status `"raiz quadrada de numero negativo"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `squareRoot16` no domínio `RootsAndRoundingContract`.

##### `op cubeRoot64`
```flux
op cubeRoot64 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `cubeRoot64` no domínio `RootsAndRoundingContract`.

##### `op cubeRoot32`
```flux
op cubeRoot32 (as float32: value) as float32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `cubeRoot32` no domínio `RootsAndRoundingContract`.

##### `op cubeRoot16`
```flux
op cubeRoot16 (as float16: value) as float16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `cubeRoot16` no domínio `RootsAndRoundingContract`.

##### `op integerSquareRoot64`
```flux
op integerSquareRoot64 (as int64: value) as int64
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ⚠️ Emite `fail` com status `"raiz quadrada inteira de numero negativo"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `integerSquareRoot64` no domínio `RootsAndRoundingContract`.

##### `op integerSquareRoot32`
```flux
op integerSquareRoot32 (as int32: value) as int32
```
- **Parâmetros**:
  - `value` (`int32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int32`
  - ⚠️ Emite `fail` com status `"raiz quadrada inteira de numero negativo"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `integerSquareRoot32` no domínio `RootsAndRoundingContract`.

##### `op integerSquareRoot16`
```flux
op integerSquareRoot16 (as int16: value) as int16
```
- **Parâmetros**:
  - `value` (`int16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int16`
  - ⚠️ Emite `fail` com status `"raiz quadrada inteira de numero negativo"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `integerSquareRoot16` no domínio `RootsAndRoundingContract`.

##### `op floor64`
```flux
op floor64 (as float64: value) as int64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `floor64` no domínio `RootsAndRoundingContract`.

##### `op floor32`
```flux
op floor32 (as float32: value) as int32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `floor32` no domínio `RootsAndRoundingContract`.

##### `op floor16`
```flux
op floor16 (as float16: value) as int16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `floor16` no domínio `RootsAndRoundingContract`.

##### `op ceil64`
```flux
op ceil64 (as float64: value) as int64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `ceil64` no domínio `RootsAndRoundingContract`.

##### `op ceil32`
```flux
op ceil32 (as float32: value) as int32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `ceil32` no domínio `RootsAndRoundingContract`.

##### `op ceil16`
```flux
op ceil16 (as float16: value) as int16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `ceil16` no domínio `RootsAndRoundingContract`.

##### `op round64`
```flux
op round64 (as float64: value) as int64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `round64` no domínio `RootsAndRoundingContract`.

##### `op round32`
```flux
op round32 (as float32: value) as int32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `round32` no domínio `RootsAndRoundingContract`.

##### `op round16`
```flux
op round16 (as float16: value) as int16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `round16` no domínio `RootsAndRoundingContract`.

##### `op roundToInt64`
```flux
op roundToInt64 (as float64: value) as int64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `roundToInt64` no domínio `RootsAndRoundingContract`.

##### `op roundToInt32`
```flux
op roundToInt32 (as float32: value) as int32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `roundToInt32` no domínio `RootsAndRoundingContract`.

##### `op roundToInt16`
```flux
op roundToInt16 (as float16: value) as int16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `roundToInt16` no domínio `RootsAndRoundingContract`.

##### `op truncate64`
```flux
op truncate64 (as float64: value) as int64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `truncate64` no domínio `RootsAndRoundingContract`.

##### `op truncate32`
```flux
op truncate32 (as float32: value) as int32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `truncate32` no domínio `RootsAndRoundingContract`.

##### `op truncate16`
```flux
op truncate16 (as float16: value) as int16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `truncate16` no domínio `RootsAndRoundingContract`.

### 4.9 Contrato `SpecialFunctionsContract` (`SpecialFunctions.fdsl`)

| Operação | Assinatura | Retorno |
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

#### Ficha Técnica das Operações:

##### `op errorFunction64`
```flux
op errorFunction64 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `errorFunction64` no domínio `SpecialFunctionsContract`.

##### `op errorFunction32`
```flux
op errorFunction32 (as float32: value) as float32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `errorFunction32` no domínio `SpecialFunctionsContract`.

##### `op errorFunction16`
```flux
op errorFunction16 (as float16: value) as float16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `errorFunction16` no domínio `SpecialFunctionsContract`.

##### `op gammaFunction64`
```flux
op gammaFunction64 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gammaFunction64` no domínio `SpecialFunctionsContract`.

##### `op gammaFunction32`
```flux
op gammaFunction32 (as float32: value) as float32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gammaFunction32` no domínio `SpecialFunctionsContract`.

##### `op gammaFunction16`
```flux
op gammaFunction16 (as float16: value) as float16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gammaFunction16` no domínio `SpecialFunctionsContract`.

##### `op erfc64`
```flux
op erfc64 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `erfc64` no domínio `SpecialFunctionsContract`.

##### `op erfc32`
```flux
op erfc32 (as float32: value) as float32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `erfc32` no domínio `SpecialFunctionsContract`.

##### `op erfc16`
```flux
op erfc16 (as float16: value) as float16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `erfc16` no domínio `SpecialFunctionsContract`.

##### `op erfinv64`
```flux
op erfinv64 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ⚠️ Emite `fail` com status `"dominio de erfinv: (-1, 1)"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `erfinv64` no domínio `SpecialFunctionsContract`.

##### `op erfinv32`
```flux
op erfinv32 (as float32: value) as float32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `erfinv32` no domínio `SpecialFunctionsContract`.

##### `op erfinv16`
```flux
op erfinv16 (as float16: value) as float16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `erfinv16` no domínio `SpecialFunctionsContract`.

##### `op logGamma64`
```flux
op logGamma64 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ⚠️ Emite `fail` com status `"dominio de logGamma: (0, inf)"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `logGamma64` no domínio `SpecialFunctionsContract`.

##### `op logGamma32`
```flux
op logGamma32 (as float32: value) as float32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `logGamma32` no domínio `SpecialFunctionsContract`.

##### `op logGamma16`
```flux
op logGamma16 (as float16: value) as float16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `logGamma16` no domínio `SpecialFunctionsContract`.

##### `op digamma64`
```flux
op digamma64 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ⚠️ Emite `fail` com status `"dominio de digamma: (0, inf)"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `digamma64` no domínio `SpecialFunctionsContract`.

##### `op digamma32`
```flux
op digamma32 (as float32: value) as float32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `digamma32` no domínio `SpecialFunctionsContract`.

##### `op digamma16`
```flux
op digamma16 (as float16: value) as float16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `digamma16` no domínio `SpecialFunctionsContract`.

##### `op sigmoid64`
```flux
op sigmoid64 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `sigmoid64` no domínio `SpecialFunctionsContract`.

##### `op sigmoid32`
```flux
op sigmoid32 (as float32: value) as float32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `sigmoid32` no domínio `SpecialFunctionsContract`.

##### `op sigmoid16`
```flux
op sigmoid16 (as float16: value) as float16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `sigmoid16` no domínio `SpecialFunctionsContract`.

##### `op normalCdf64`
```flux
op normalCdf64 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `normalCdf64` no domínio `SpecialFunctionsContract`.

##### `op normalCdf32`
```flux
op normalCdf32 (as float32: value) as float32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `normalCdf32` no domínio `SpecialFunctionsContract`.

##### `op normalCdf16`
```flux
op normalCdf16 (as float16: value) as float16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `normalCdf16` no domínio `SpecialFunctionsContract`.

##### `op besselJ0_64`
```flux
op besselJ0_64 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `besselJ0_64` no domínio `SpecialFunctionsContract`.

##### `op besselJ0_32`
```flux
op besselJ0_32 (as float32: value) as float32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `besselJ0_32` no domínio `SpecialFunctionsContract`.

##### `op besselJ0_16`
```flux
op besselJ0_16 (as float16: value) as float16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `besselJ0_16` no domínio `SpecialFunctionsContract`.

##### `op besselJ1_64`
```flux
op besselJ1_64 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `besselJ1_64` no domínio `SpecialFunctionsContract`.

##### `op besselJ1_32`
```flux
op besselJ1_32 (as float32: value) as float32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `besselJ1_32` no domínio `SpecialFunctionsContract`.

##### `op besselJ1_16`
```flux
op besselJ1_16 (as float16: value) as float16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `besselJ1_16` no domínio `SpecialFunctionsContract`.

##### `op ulp64`
```flux
op ulp64 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `ulp64` no domínio `SpecialFunctionsContract`.

##### `op ulp32`
```flux
op ulp32 (as float32: value) as float32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `ulp32` no domínio `SpecialFunctionsContract`.

##### `op ulp16`
```flux
op ulp16 (as float16: value) as float16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `ulp16` no domínio `SpecialFunctionsContract`.

##### `op fract64`
```flux
op fract64 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `fract64` no domínio `SpecialFunctionsContract`.

##### `op fract32`
```flux
op fract32 (as float32: value) as float32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `fract32` no domínio `SpecialFunctionsContract`.

##### `op fract16`
```flux
op fract16 (as float16: value) as float16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `fract16` no domínio `SpecialFunctionsContract`.

##### `op wrapAngle64`
```flux
op wrapAngle64 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `wrapAngle64` no domínio `SpecialFunctionsContract`.

##### `op wrapAngle32`
```flux
op wrapAngle32 (as float32: value) as float32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `wrapAngle32` no domínio `SpecialFunctionsContract`.

##### `op wrapAngle16`
```flux
op wrapAngle16 (as float16: value) as float16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `wrapAngle16` no domínio `SpecialFunctionsContract`.

##### `op beta64`
```flux
op beta64 (as float64: a, as float64: b) as float64
```
- **Parâmetros**:
  - `a` (`float64`): Parâmetro de entrada para processamento da operação.
  - `b` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ⚠️ Emite `fail` com status `"dominio de beta: a > 0 e b > 0"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `beta64` no domínio `SpecialFunctionsContract`.

##### `op beta32`
```flux
op beta32 (as float32: a, as float32: b) as float32
```
- **Parâmetros**:
  - `a` (`float32`): Parâmetro de entrada para processamento da operação.
  - `b` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `beta32` no domínio `SpecialFunctionsContract`.

##### `op beta16`
```flux
op beta16 (as float16: a, as float16: b) as float16
```
- **Parâmetros**:
  - `a` (`float16`): Parâmetro de entrada para processamento da operação.
  - `b` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `beta16` no domínio `SpecialFunctionsContract`.

##### `op logBeta64`
```flux
op logBeta64 (as float64: a, as float64: b) as float64
```
- **Parâmetros**:
  - `a` (`float64`): Parâmetro de entrada para processamento da operação.
  - `b` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ⚠️ Emite `fail` com status `"dominio de logBeta: a > 0 e b > 0"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `logBeta64` no domínio `SpecialFunctionsContract`.

##### `op logBeta32`
```flux
op logBeta32 (as float32: a, as float32: b) as float32
```
- **Parâmetros**:
  - `a` (`float32`): Parâmetro de entrada para processamento da operação.
  - `b` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `logBeta32` no domínio `SpecialFunctionsContract`.

##### `op logBeta16`
```flux
op logBeta16 (as float16: a, as float16: b) as float16
```
- **Parâmetros**:
  - `a` (`float16`): Parâmetro de entrada para processamento da operação.
  - `b` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `logBeta16` no domínio `SpecialFunctionsContract`.

##### `op fdim64`
```flux
op fdim64 (as float64: a, as float64: b) as float64
```
- **Parâmetros**:
  - `a` (`float64`): Parâmetro de entrada para processamento da operação.
  - `b` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `fdim64` no domínio `SpecialFunctionsContract`.

##### `op fdim32`
```flux
op fdim32 (as float32: a, as float32: b) as float32
```
- **Parâmetros**:
  - `a` (`float32`): Parâmetro de entrada para processamento da operação.
  - `b` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `fdim32` no domínio `SpecialFunctionsContract`.

##### `op fdim16`
```flux
op fdim16 (as float16: a, as float16: b) as float16
```
- **Parâmetros**:
  - `a` (`float16`): Parâmetro de entrada para processamento da operação.
  - `b` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `fdim16` no domínio `SpecialFunctionsContract`.

##### `op step64`
```flux
op step64 (as float64: a, as float64: b) as float64
```
- **Parâmetros**:
  - `a` (`float64`): Parâmetro de entrada para processamento da operação.
  - `b` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `step64` no domínio `SpecialFunctionsContract`.

##### `op step32`
```flux
op step32 (as float32: a, as float32: b) as float32
```
- **Parâmetros**:
  - `a` (`float32`): Parâmetro de entrada para processamento da operação.
  - `b` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `step32` no domínio `SpecialFunctionsContract`.

##### `op step16`
```flux
op step16 (as float16: a, as float16: b) as float16
```
- **Parâmetros**:
  - `a` (`float16`): Parâmetro de entrada para processamento da operação.
  - `b` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `step16` no domínio `SpecialFunctionsContract`.

##### `op isCloseTo64`
```flux
op isCloseTo64 (as float64: a, as float64: b) as bool
```
- **Parâmetros**:
  - `a` (`float64`): Parâmetro de entrada para processamento da operação.
  - `b` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `isCloseTo64` no domínio `SpecialFunctionsContract`.

##### `op isCloseTo32`
```flux
op isCloseTo32 (as float32: a, as float32: b) as bool
```
- **Parâmetros**:
  - `a` (`float32`): Parâmetro de entrada para processamento da operação.
  - `b` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `isCloseTo32` no domínio `SpecialFunctionsContract`.

##### `op isCloseTo16`
```flux
op isCloseTo16 (as float16: a, as float16: b) as bool
```
- **Parâmetros**:
  - `a` (`float16`): Parâmetro de entrada para processamento da operação.
  - `b` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `isCloseTo16` no domínio `SpecialFunctionsContract`.

##### `op signbit64`
```flux
op signbit64 (as float64: value) as bool
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `signbit64` no domínio `SpecialFunctionsContract`.

##### `op signbit32`
```flux
op signbit32 (as float32: value) as bool
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `signbit32` no domínio `SpecialFunctionsContract`.

##### `op signbit16`
```flux
op signbit16 (as float16: value) as bool
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `signbit16` no domínio `SpecialFunctionsContract`.

##### `op copySign64`
```flux
op copySign64 (as float64: magnitude, as float64: sign_source) as float64
```
- **Parâmetros**:
  - `magnitude` (`float64`): Parâmetro de entrada para processamento da operação.
  - `sign_source` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `copySign64` no domínio `SpecialFunctionsContract`.

##### `op copySign32`
```flux
op copySign32 (as float32: magnitude, as float32: sign_source) as float32
```
- **Parâmetros**:
  - `magnitude` (`float32`): Parâmetro de entrada para processamento da operação.
  - `sign_source` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `copySign32` no domínio `SpecialFunctionsContract`.

##### `op copySign16`
```flux
op copySign16 (as float16: magnitude, as float16: sign_source) as float16
```
- **Parâmetros**:
  - `magnitude` (`float16`): Parâmetro de entrada para processamento da operação.
  - `sign_source` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `copySign16` no domínio `SpecialFunctionsContract`.

##### `op nextRepresentable64`
```flux
op nextRepresentable64 (as float64: magnitude, as float64: sign_source) as float64
```
- **Parâmetros**:
  - `magnitude` (`float64`): Parâmetro de entrada para processamento da operação.
  - `sign_source` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `nextRepresentable64` no domínio `SpecialFunctionsContract`.

##### `op nextRepresentable32`
```flux
op nextRepresentable32 (as float32: magnitude, as float32: sign_source) as float32
```
- **Parâmetros**:
  - `magnitude` (`float32`): Parâmetro de entrada para processamento da operação.
  - `sign_source` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `nextRepresentable32` no domínio `SpecialFunctionsContract`.

##### `op nextRepresentable16`
```flux
op nextRepresentable16 (as float16: magnitude, as float16: sign_source) as float16
```
- **Parâmetros**:
  - `magnitude` (`float16`): Parâmetro de entrada para processamento da operação.
  - `sign_source` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `nextRepresentable16` no domínio `SpecialFunctionsContract`.

##### `op fusedMultiplyAdd64`
```flux
op fusedMultiplyAdd64 (as float64: a, as float64: b, as float64: c) as float64
```
- **Parâmetros**:
  - `a` (`float64`): Parâmetro de entrada para processamento da operação.
  - `b` (`float64`): Parâmetro de entrada para processamento da operação.
  - `c` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `fusedMultiplyAdd64` no domínio `SpecialFunctionsContract`.

##### `op fusedMultiplyAdd32`
```flux
op fusedMultiplyAdd32 (as float32: a, as float32: b, as float32: c) as float32
```
- **Parâmetros**:
  - `a` (`float32`): Parâmetro de entrada para processamento da operação.
  - `b` (`float32`): Parâmetro de entrada para processamento da operação.
  - `c` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `fusedMultiplyAdd32` no domínio `SpecialFunctionsContract`.

##### `op fusedMultiplyAdd16`
```flux
op fusedMultiplyAdd16 (as float16: a, as float16: b, as float16: c) as float16
```
- **Parâmetros**:
  - `a` (`float16`): Parâmetro de entrada para processamento da operação.
  - `b` (`float16`): Parâmetro de entrada para processamento da operação.
  - `c` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `fusedMultiplyAdd16` no domínio `SpecialFunctionsContract`.

##### `op ldexp64`
```flux
op ldexp64 (as float64: x, as int64: exp_val) as float64
```
- **Parâmetros**:
  - `x` (`float64`): Parâmetro de entrada para processamento da operação.
  - `exp_val` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `ldexp64` no domínio `SpecialFunctionsContract`.

##### `op ldexp32`
```flux
op ldexp32 (as float32: x, as int32: exp_val) as float32
```
- **Parâmetros**:
  - `x` (`float32`): Parâmetro de entrada para processamento da operação.
  - `exp_val` (`int32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `ldexp32` no domínio `SpecialFunctionsContract`.

##### `op ldexp16`
```flux
op ldexp16 (as float16: x, as int16: exp_val) as float16
```
- **Parâmetros**:
  - `x` (`float16`): Parâmetro de entrada para processamento da operação.
  - `exp_val` (`int16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `ldexp16` no domínio `SpecialFunctionsContract`.

##### `op smoothstep64`
```flux
op smoothstep64 (as float64: edge0, as float64: edge1, as float64: x) as float64
```
- **Parâmetros**:
  - `edge0` (`float64`): Parâmetro de entrada para processamento da operação.
  - `edge1` (`float64`): Parâmetro de entrada para processamento da operação.
  - `x` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ⚠️ Emite `fail` com status `"smoothstep requer edge0 != edge1"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `smoothstep64` no domínio `SpecialFunctionsContract`.

##### `op smoothstep32`
```flux
op smoothstep32 (as float32: edge0, as float32: edge1, as float32: x) as float32
```
- **Parâmetros**:
  - `edge0` (`float32`): Parâmetro de entrada para processamento da operação.
  - `edge1` (`float32`): Parâmetro de entrada para processamento da operação.
  - `x` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `smoothstep32` no domínio `SpecialFunctionsContract`.

##### `op smoothstep16`
```flux
op smoothstep16 (as float16: edge0, as float16: edge1, as float16: x) as float16
```
- **Parâmetros**:
  - `edge0` (`float16`): Parâmetro de entrada para processamento da operação.
  - `edge1` (`float16`): Parâmetro de entrada para processamento da operação.
  - `x` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `smoothstep16` no domínio `SpecialFunctionsContract`.

##### `op smootherstep64`
```flux
op smootherstep64 (as float64: edge0, as float64: edge1, as float64: x) as float64
```
- **Parâmetros**:
  - `edge0` (`float64`): Parâmetro de entrada para processamento da operação.
  - `edge1` (`float64`): Parâmetro de entrada para processamento da operação.
  - `x` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ⚠️ Emite `fail` com status `"smootherstep requer edge0 != edge1"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `smootherstep64` no domínio `SpecialFunctionsContract`.

##### `op smootherstep32`
```flux
op smootherstep32 (as float32: edge0, as float32: edge1, as float32: x) as float32
```
- **Parâmetros**:
  - `edge0` (`float32`): Parâmetro de entrada para processamento da operação.
  - `edge1` (`float32`): Parâmetro de entrada para processamento da operação.
  - `x` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `smootherstep32` no domínio `SpecialFunctionsContract`.

##### `op smootherstep16`
```flux
op smootherstep16 (as float16: edge0, as float16: edge1, as float16: x) as float16
```
- **Parâmetros**:
  - `edge0` (`float16`): Parâmetro de entrada para processamento da operação.
  - `edge1` (`float16`): Parâmetro de entrada para processamento da operação.
  - `x` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `smootherstep16` no domínio `SpecialFunctionsContract`.

##### `op inverseLinearInterpolation64`
```flux
op inverseLinearInterpolation64 (as float64: a, as float64: b, as float64: val) as float64
```
- **Parâmetros**:
  - `a` (`float64`): Parâmetro de entrada para processamento da operação.
  - `b` (`float64`): Parâmetro de entrada para processamento da operação.
  - `val` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ⚠️ Emite `fail` com status `"interpolacao linear inversa requer a != b"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `inverseLinearInterpolation64` no domínio `SpecialFunctionsContract`.

##### `op inverseLinearInterpolation32`
```flux
op inverseLinearInterpolation32 (as float32: a, as float32: b, as float32: val) as float32
```
- **Parâmetros**:
  - `a` (`float32`): Parâmetro de entrada para processamento da operação.
  - `b` (`float32`): Parâmetro de entrada para processamento da operação.
  - `val` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `inverseLinearInterpolation32` no domínio `SpecialFunctionsContract`.

##### `op inverseLinearInterpolation16`
```flux
op inverseLinearInterpolation16 (as float16: a, as float16: b, as float16: val) as float16
```
- **Parâmetros**:
  - `a` (`float16`): Parâmetro de entrada para processamento da operação.
  - `b` (`float16`): Parâmetro de entrada para processamento da operação.
  - `val` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `inverseLinearInterpolation16` no domínio `SpecialFunctionsContract`.

##### `op mapRange64`
```flux
op mapRange64 (as float64: val, as float64: in_min, as float64: in_max, as float64: out_min, as float64: out_max) as float64
```
- **Parâmetros**:
  - `val` (`float64`): Parâmetro de entrada para processamento da operação.
  - `in_min` (`float64`): Parâmetro de entrada para processamento da operação.
  - `in_max` (`float64`): Parâmetro de entrada para processamento da operação.
  - `out_min` (`float64`): Parâmetro de entrada para processamento da operação.
  - `out_max` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ⚠️ Emite `fail` com status `"mapRange requer in_min != in_max"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapRange64` no domínio `SpecialFunctionsContract`.

##### `op mapRange32`
```flux
op mapRange32 (as float32: val, as float32: in_min, as float32: in_max, as float32: out_min, as float32: out_max) as float32
```
- **Parâmetros**:
  - `val` (`float32`): Parâmetro de entrada para processamento da operação.
  - `in_min` (`float32`): Parâmetro de entrada para processamento da operação.
  - `in_max` (`float32`): Parâmetro de entrada para processamento da operação.
  - `out_min` (`float32`): Parâmetro de entrada para processamento da operação.
  - `out_max` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapRange32` no domínio `SpecialFunctionsContract`.

##### `op mapRange16`
```flux
op mapRange16 (as float16: val, as float16: in_min, as float16: in_max, as float16: out_min, as float16: out_max) as float16
```
- **Parâmetros**:
  - `val` (`float16`): Parâmetro de entrada para processamento da operação.
  - `in_min` (`float16`): Parâmetro de entrada para processamento da operação.
  - `in_max` (`float16`): Parâmetro de entrada para processamento da operação.
  - `out_min` (`float16`): Parâmetro de entrada para processamento da operação.
  - `out_max` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mapRange16` no domínio `SpecialFunctionsContract`.

### 4.10 Contrato `TrigonometryContract` (`Trigonometry.fdsl`)

| Operação | Assinatura | Retorno |
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

#### Ficha Técnica das Operações:

##### `op sin64`
```flux
op sin64 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `sin64` no domínio `TrigonometryContract`.

##### `op sin32`
```flux
op sin32 (as float32: value) as float32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `sin32` no domínio `TrigonometryContract`.

##### `op sin16`
```flux
op sin16 (as float16: value) as float16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `sin16` no domínio `TrigonometryContract`.

##### `op cos64`
```flux
op cos64 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `cos64` no domínio `TrigonometryContract`.

##### `op cos32`
```flux
op cos32 (as float32: value) as float32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `cos32` no domínio `TrigonometryContract`.

##### `op cos16`
```flux
op cos16 (as float16: value) as float16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `cos16` no domínio `TrigonometryContract`.

##### `op tan64`
```flux
op tan64 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ⚠️ Emite `fail` com status `"tangente indefinida para multiplos impares de pi/2"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `tan64` no domínio `TrigonometryContract`.

##### `op tan32`
```flux
op tan32 (as float32: value) as float32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `tan32` no domínio `TrigonometryContract`.

##### `op tan16`
```flux
op tan16 (as float16: value) as float16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `tan16` no domínio `TrigonometryContract`.

##### `op arcTan64`
```flux
op arcTan64 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `arcTan64` no domínio `TrigonometryContract`.

##### `op arcTan32`
```flux
op arcTan32 (as float32: value) as float32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `arcTan32` no domínio `TrigonometryContract`.

##### `op arcTan16`
```flux
op arcTan16 (as float16: value) as float16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `arcTan16` no domínio `TrigonometryContract`.

##### `op arcSin64`
```flux
op arcSin64 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ⚠️ Emite `fail` com status `"dominio de arcSin: [-1, 1]"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `arcSin64` no domínio `TrigonometryContract`.

##### `op arcSin32`
```flux
op arcSin32 (as float32: value) as float32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ⚠️ Emite `fail` com status `"dominio de arcSin: [-1, 1]"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `arcSin32` no domínio `TrigonometryContract`.

##### `op arcSin16`
```flux
op arcSin16 (as float16: value) as float16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ⚠️ Emite `fail` com status `"dominio de arcSin: [-1, 1]"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `arcSin16` no domínio `TrigonometryContract`.

##### `op arcCos64`
```flux
op arcCos64 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ⚠️ Emite `fail` com status `"dominio de arcCos: [-1, 1]"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `arcCos64` no domínio `TrigonometryContract`.

##### `op arcCos32`
```flux
op arcCos32 (as float32: value) as float32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ⚠️ Emite `fail` com status `"dominio de arcCos: [-1, 1]"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `arcCos32` no domínio `TrigonometryContract`.

##### `op arcCos16`
```flux
op arcCos16 (as float16: value) as float16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ⚠️ Emite `fail` com status `"dominio de arcCos: [-1, 1]"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `arcCos16` no domínio `TrigonometryContract`.

##### `op sec64`
```flux
op sec64 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ⚠️ Emite `fail` com status `"secante indefinida para multiplos impares de pi/2"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `sec64` no domínio `TrigonometryContract`.

##### `op sec32`
```flux
op sec32 (as float32: value) as float32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `sec32` no domínio `TrigonometryContract`.

##### `op sec16`
```flux
op sec16 (as float16: value) as float16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `sec16` no domínio `TrigonometryContract`.

##### `op csc64`
```flux
op csc64 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ⚠️ Emite `fail` com status `"cossecante indefinida para multiplos de pi"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `csc64` no domínio `TrigonometryContract`.

##### `op csc32`
```flux
op csc32 (as float32: value) as float32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `csc32` no domínio `TrigonometryContract`.

##### `op csc16`
```flux
op csc16 (as float16: value) as float16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `csc16` no domínio `TrigonometryContract`.

##### `op cot64`
```flux
op cot64 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ⚠️ Emite `fail` com status `"cotangente indefinida para multiplos de pi"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `cot64` no domínio `TrigonometryContract`.

##### `op cot32`
```flux
op cot32 (as float32: value) as float32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `cot32` no domínio `TrigonometryContract`.

##### `op cot16`
```flux
op cot16 (as float16: value) as float16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `cot16` no domínio `TrigonometryContract`.

##### `op arcSec64`
```flux
op arcSec64 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ⚠️ Emite `fail` com status `"dominio de arcSec: (-inf, -1] U [1, inf)"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `arcSec64` no domínio `TrigonometryContract`.

##### `op arcSec32`
```flux
op arcSec32 (as float32: value) as float32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `arcSec32` no domínio `TrigonometryContract`.

##### `op arcSec16`
```flux
op arcSec16 (as float16: value) as float16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `arcSec16` no domínio `TrigonometryContract`.

##### `op arcCsc64`
```flux
op arcCsc64 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ⚠️ Emite `fail` com status `"dominio de arcCsc: (-inf, -1] U [1, inf)"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `arcCsc64` no domínio `TrigonometryContract`.

##### `op arcCsc32`
```flux
op arcCsc32 (as float32: value) as float32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `arcCsc32` no domínio `TrigonometryContract`.

##### `op arcCsc16`
```flux
op arcCsc16 (as float16: value) as float16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `arcCsc16` no domínio `TrigonometryContract`.

##### `op arcCot64`
```flux
op arcCot64 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `arcCot64` no domínio `TrigonometryContract`.

##### `op arcCot32`
```flux
op arcCot32 (as float32: value) as float32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `arcCot32` no domínio `TrigonometryContract`.

##### `op arcCot16`
```flux
op arcCot16 (as float16: value) as float16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `arcCot16` no domínio `TrigonometryContract`.

##### `op sinc64`
```flux
op sinc64 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `sinc64` no domínio `TrigonometryContract`.

##### `op sinc32`
```flux
op sinc32 (as float32: value) as float32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `sinc32` no domínio `TrigonometryContract`.

##### `op sinc16`
```flux
op sinc16 (as float16: value) as float16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `sinc16` no domínio `TrigonometryContract`.

##### `op sinpi64`
```flux
op sinpi64 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `sinpi64` no domínio `TrigonometryContract`.

##### `op sinpi32`
```flux
op sinpi32 (as float32: value) as float32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `sinpi32` no domínio `TrigonometryContract`.

##### `op sinpi16`
```flux
op sinpi16 (as float16: value) as float16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `sinpi16` no domínio `TrigonometryContract`.

##### `op cospi64`
```flux
op cospi64 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `cospi64` no domínio `TrigonometryContract`.

##### `op cospi32`
```flux
op cospi32 (as float32: value) as float32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `cospi32` no domínio `TrigonometryContract`.

##### `op cospi16`
```flux
op cospi16 (as float16: value) as float16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `cospi16` no domínio `TrigonometryContract`.

##### `op tanpi64`
```flux
op tanpi64 (as float64: value) as float64
```
- **Parâmetros**:
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `tanpi64` no domínio `TrigonometryContract`.

##### `op tanpi32`
```flux
op tanpi32 (as float32: value) as float32
```
- **Parâmetros**:
  - `value` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `tanpi32` no domínio `TrigonometryContract`.

##### `op tanpi16`
```flux
op tanpi16 (as float16: value) as float16
```
- **Parâmetros**:
  - `value` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `tanpi16` no domínio `TrigonometryContract`.

##### `op hypotenuse64`
```flux
op hypotenuse64 (as float64: y, as float64: x) as float64
```
- **Parâmetros**:
  - `y` (`float64`): Parâmetro de entrada para processamento da operação.
  - `x` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `hypotenuse64` no domínio `TrigonometryContract`.

##### `op hypotenuse32`
```flux
op hypotenuse32 (as float32: y, as float32: x) as float32
```
- **Parâmetros**:
  - `y` (`float32`): Parâmetro de entrada para processamento da operação.
  - `x` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `hypotenuse32` no domínio `TrigonometryContract`.

##### `op hypotenuse16`
```flux
op hypotenuse16 (as float16: y, as float16: x) as float16
```
- **Parâmetros**:
  - `y` (`float16`): Parâmetro de entrada para processamento da operação.
  - `x` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `hypotenuse16` no domínio `TrigonometryContract`.

##### `op arcTan2_64`
```flux
op arcTan2_64 (as float64: y, as float64: x) as float64
```
- **Parâmetros**:
  - `y` (`float64`): Parâmetro de entrada para processamento da operação.
  - `x` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `arcTan2_64` no domínio `TrigonometryContract`.

##### `op arcTan2_32`
```flux
op arcTan2_32 (as float32: y, as float32: x) as float32
```
- **Parâmetros**:
  - `y` (`float32`): Parâmetro de entrada para processamento da operação.
  - `x` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `arcTan2_32` no domínio `TrigonometryContract`.

##### `op arcTan2_16`
```flux
op arcTan2_16 (as float16: y, as float16: x) as float16
```
- **Parâmetros**:
  - `y` (`float16`): Parâmetro de entrada para processamento da operação.
  - `x` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `arcTan2_16` no domínio `TrigonometryContract`.

##### `op sen64`
```flux
op sen64 (as float64: radians) as float64
```
- **Parâmetros**:
  - `radians` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `sen64` no domínio `TrigonometryContract`.

##### `op sen32`
```flux
op sen32 (as float32: radians) as float32
```
- **Parâmetros**:
  - `radians` (`float32`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `sen32` no domínio `TrigonometryContract`.

##### `op sen16`
```flux
op sen16 (as float16: radians) as float16
```
- **Parâmetros**:
  - `radians` (`float16`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `sen16` no domínio `TrigonometryContract`.

---

## 5. Exemplos Canônicos de Uso em TheFlux

O exemplo a seguir demonstra a importação e o consumo prático da biblioteca:

```flux
# Exemplo Canônico de Consumo da MathStdLib
use MathStdLib

program (ExemploMathStdLib) {
      println("==================================================")
      println("  Demonstracao da Standard Library: MathStdLib")
      println("==================================================")

      # Chamada da operacao canônica
      mut as data: resultado = MathStdLib::sin64(0.0)
      println("Resultado obtido: " + resultado)

      println("Demonstracao concluida com sucesso.")
}
```

---

> [!TIP]
> Para consultar a visão arquitetural unificada de todas as bibliotecas, consulte o documento principal [StdLibs.md](../StdLibs.md).
