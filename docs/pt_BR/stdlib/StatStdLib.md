# 📚 `StatStdLib` — Estatística Descritiva, Inferencial, Correlações e Ajustes de Curvas

> **Pilar Arquitetural**: Pilar 3 (Matemática & Gráficos)  
> **Status**: ✅ Homologado com 100% de Paridade nos 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Arquivo Mestre**: `stdlib/StatStdLib/StatStdLib.fdsl`  
> **Modo de Importação**: `use StatStdLib` ou `use StatStdLib::<Modulo>::<operacao>`

---

## 1. Visão Geral e Funcionalidades

A biblioteca padrão **`StatStdLib`** integra o ecossistema oficial da linguagem TheFlux, fornecendo suporte de nível de sistema e algoritmos nativos certificados.

Conjunto analítico estatístico completo: medidas de tendência central (média aritmética, geométrica, harmônica, mediana, moda), medidas de dispersão (variância, desvio padrão), quantis/percentis, assimetria, curtose, correlações (Pearson/Spearman) e testes de hipótese.

### 1.1 Características e Princípios de Design
- **Compilação e Fusão Estática**: Todos os módulos de domínio são fundidos no agente unificado `StatStdLib` em tempo de compilação, sem sobrecarga (*overhead*) de despacho indireto.
- **Isolamento e Segurança**: As operações verificam limites operacionais e utilizam despacho por contratos formais rigorosos.
- **Compatibilidade Multi-Backend**: Execução bit-a-bit idêntica em interpretador (`in`), bytecode (`vm`, `vmr`), nativo AOT (`llvm`) e WebAssembly (`wat`, `wasm`).

---

## 2. Estrutura Modular e Contratos

A biblioteca é composta por **8 módulos de domínio** e declara **62 operações públicas**:

| Arquivo de Domínio | Contrato Formal | Responsabilidade Principal | Qtd. Ops |
|---|---|---|:---:|
| `StatCentralTendency.fdsl` | `StatCentralTendencyContract` | Domínio especializado de `StatCentralTendency` | 10 |
| `StatCorrelation.fdsl` | `StatCorrelationContract` | Domínio especializado de `StatCorrelation` | 6 |
| `StatDispersion.fdsl` | `StatDispersionContract` | Domínio especializado de `StatDispersion` | 11 |
| `StatDistribution.fdsl` | `StatDistributionContract` | Domínio especializado de `StatDistribution` | 11 |
| `StatInference.fdsl` | `StatInferenceContract` | Domínio especializado de `StatInference` | 6 |
| `StatOrderAndQuantiles.fdsl` | `StatOrderAndQuantilesContract` | Domínio especializado de `StatOrderAndQuantiles` | 6 |
| `StatShape.fdsl` | `StatShapeContract` | Domínio especializado de `StatShape` | 6 |
| `StatSummary.fdsl` | `StatSummaryContract` | Domínio especializado de `StatSummary` | 6 |

---

## 3. Tipos, Estruturas e Enumerações Públicas

A biblioteca `StatStdLib` opera diretamente com os tipos nativos e primitivos da linguagem TheFlux (`string`, `int64`, `float64`, `bool`, `list of data`, etc.), sem exigir tipos compostos adicionais.

---

## 4. Catálogo Detalhado de Operações por Domínio

### 4.1 Contrato `StatCentralTendencyContract` (`StatCentralTendency.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `statMean` | `op statMean (as list of data: data_points) as float64` | `float64` |
| `statWeightedMean` | `op statWeightedMean (as list of data: data_points, as list of data: weights) as float64` | `float64` |
| `statGeometricMean` | `op statGeometricMean (as list of data: data_points) as float64` | `float64` |
| `statHarmonicMean` | `op statHarmonicMean (as list of data: data_points) as float64` | `float64` |
| `statMedian` | `op statMedian (as list of data: data_points) as float64` | `float64` |
| `statMedianLow` | `op statMedianLow (as list of data: data_points) as float64` | `float64` |
| `statMedianHigh` | `op statMedianHigh (as list of data: data_points) as float64` | `float64` |
| `statMode` | `op statMode (as list of data: data_points) as float64` | `float64` |
| `statMultimode` | `op statMultimode (as list of data: data_points) as list of data` | `list of data` |
| `statTrimmedMean` | `op statTrimmedMean (as list of data: data_points, as float64: cut_proportion) as float64` | `float64` |

#### Ficha Técnica das Operações:

##### `op statMean`
```flux
op statMean (as list of data: data_points) as float64
```
- **Parâmetros**:
  - `data_points` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statMean` no domínio `StatCentralTendencyContract`.

##### `op statWeightedMean`
```flux
op statWeightedMean (as list of data: data_points, as list of data: weights) as float64
```
- **Parâmetros**:
  - `data_points` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `weights` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statWeightedMean` no domínio `StatCentralTendencyContract`.

##### `op statGeometricMean`
```flux
op statGeometricMean (as list of data: data_points) as float64
```
- **Parâmetros**:
  - `data_points` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statGeometricMean` no domínio `StatCentralTendencyContract`.

##### `op statHarmonicMean`
```flux
op statHarmonicMean (as list of data: data_points) as float64
```
- **Parâmetros**:
  - `data_points` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statHarmonicMean` no domínio `StatCentralTendencyContract`.

##### `op statMedian`
```flux
op statMedian (as list of data: data_points) as float64
```
- **Parâmetros**:
  - `data_points` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statMedian` no domínio `StatCentralTendencyContract`.

##### `op statMedianLow`
```flux
op statMedianLow (as list of data: data_points) as float64
```
- **Parâmetros**:
  - `data_points` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statMedianLow` no domínio `StatCentralTendencyContract`.

##### `op statMedianHigh`
```flux
op statMedianHigh (as list of data: data_points) as float64
```
- **Parâmetros**:
  - `data_points` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statMedianHigh` no domínio `StatCentralTendencyContract`.

##### `op statMode`
```flux
op statMode (as list of data: data_points) as float64
```
- **Parâmetros**:
  - `data_points` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statMode` no domínio `StatCentralTendencyContract`.

##### `op statMultimode`
```flux
op statMultimode (as list of data: data_points) as list of data
```
- **Parâmetros**:
  - `data_points` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statMultimode` no domínio `StatCentralTendencyContract`.

##### `op statTrimmedMean`
```flux
op statTrimmedMean (as list of data: data_points, as float64: cut_proportion) as float64
```
- **Parâmetros**:
  - `data_points` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `cut_proportion` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statTrimmedMean` no domínio `StatCentralTendencyContract`.

### 4.2 Contrato `StatCorrelationContract` (`StatCorrelation.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `statCovariancePopulation` | `op statCovariancePopulation (as list of data: x, as list of data: y) as float64` | `float64` |
| `statCovarianceSample` | `op statCovarianceSample (as list of data: x, as list of data: y) as float64` | `float64` |
| `statPearsonCorrelation` | `op statPearsonCorrelation (as list of data: x, as list of data: y) as float64` | `float64` |
| `statSpearmanCorrelation` | `op statSpearmanCorrelation (as list of data: x, as list of data: y) as float64` | `float64` |
| `statLinearRegression` | `op statLinearRegression (as list of data: x, as list of data: y) as map` | `map` |
| `statLinearResiduals` | `op statLinearResiduals (as list of data: x, as list of data: y, as float64: slope, as float64: intercept) as list of data` | `list of data` |

#### Ficha Técnica das Operações:

##### `op statCovariancePopulation`
```flux
op statCovariancePopulation (as list of data: x, as list of data: y) as float64
```
- **Parâmetros**:
  - `x` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `y` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statCovariancePopulation` no domínio `StatCorrelationContract`.

##### `op statCovarianceSample`
```flux
op statCovarianceSample (as list of data: x, as list of data: y) as float64
```
- **Parâmetros**:
  - `x` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `y` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statCovarianceSample` no domínio `StatCorrelationContract`.

##### `op statPearsonCorrelation`
```flux
op statPearsonCorrelation (as list of data: x, as list of data: y) as float64
```
- **Parâmetros**:
  - `x` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `y` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statPearsonCorrelation` no domínio `StatCorrelationContract`.

##### `op statSpearmanCorrelation`
```flux
op statSpearmanCorrelation (as list of data: x, as list of data: y) as float64
```
- **Parâmetros**:
  - `x` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `y` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statSpearmanCorrelation` no domínio `StatCorrelationContract`.

##### `op statLinearRegression`
```flux
op statLinearRegression (as list of data: x, as list of data: y) as map
```
- **Parâmetros**:
  - `x` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `y` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statLinearRegression` no domínio `StatCorrelationContract`.

##### `op statLinearResiduals`
```flux
op statLinearResiduals (as list of data: x, as list of data: y, as float64: slope, as float64: intercept) as list of data
```
- **Parâmetros**:
  - `x` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `y` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `slope` (`float64`): Parâmetro de entrada para processamento da operação.
  - `intercept` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statLinearResiduals` no domínio `StatCorrelationContract`.

### 4.3 Contrato `StatDispersionContract` (`StatDispersion.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `statVariancePopulation` | `op statVariancePopulation (as list of data: data_points) as float64` | `float64` |
| `statVarianceSample` | `op statVarianceSample (as list of data: data_points) as float64` | `float64` |
| `statStdDevPopulation` | `op statStdDevPopulation (as list of data: data_points) as float64` | `float64` |
| `statStdDevSample` | `op statStdDevSample (as list of data: data_points) as float64` | `float64` |
| `statRange` | `op statRange (as list of data: data_points) as float64` | `float64` |
| `statMin` | `op statMin (as list of data: data_points) as float64` | `float64` |
| `statMax` | `op statMax (as list of data: data_points) as float64` | `float64` |
| `statIQR` | `op statIQR (as list of data: data_points) as float64` | `float64` |
| `statMeanAbsoluteDeviation` | `op statMeanAbsoluteDeviation (as list of data: data_points) as float64` | `float64` |
| `statMedianAbsoluteDeviation` | `op statMedianAbsoluteDeviation (as list of data: data_points) as float64` | `float64` |
| `statCoefficientOfVariation` | `op statCoefficientOfVariation (as list of data: data_points) as float64` | `float64` |

#### Ficha Técnica das Operações:

##### `op statVariancePopulation`
```flux
op statVariancePopulation (as list of data: data_points) as float64
```
- **Parâmetros**:
  - `data_points` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statVariancePopulation` no domínio `StatDispersionContract`.

##### `op statVarianceSample`
```flux
op statVarianceSample (as list of data: data_points) as float64
```
- **Parâmetros**:
  - `data_points` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statVarianceSample` no domínio `StatDispersionContract`.

##### `op statStdDevPopulation`
```flux
op statStdDevPopulation (as list of data: data_points) as float64
```
- **Parâmetros**:
  - `data_points` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statStdDevPopulation` no domínio `StatDispersionContract`.

##### `op statStdDevSample`
```flux
op statStdDevSample (as list of data: data_points) as float64
```
- **Parâmetros**:
  - `data_points` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statStdDevSample` no domínio `StatDispersionContract`.

##### `op statRange`
```flux
op statRange (as list of data: data_points) as float64
```
- **Parâmetros**:
  - `data_points` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statRange` no domínio `StatDispersionContract`.

##### `op statMin`
```flux
op statMin (as list of data: data_points) as float64
```
- **Parâmetros**:
  - `data_points` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statMin` no domínio `StatDispersionContract`.

##### `op statMax`
```flux
op statMax (as list of data: data_points) as float64
```
- **Parâmetros**:
  - `data_points` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statMax` no domínio `StatDispersionContract`.

##### `op statIQR`
```flux
op statIQR (as list of data: data_points) as float64
```
- **Parâmetros**:
  - `data_points` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statIQR` no domínio `StatDispersionContract`.

##### `op statMeanAbsoluteDeviation`
```flux
op statMeanAbsoluteDeviation (as list of data: data_points) as float64
```
- **Parâmetros**:
  - `data_points` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statMeanAbsoluteDeviation` no domínio `StatDispersionContract`.

##### `op statMedianAbsoluteDeviation`
```flux
op statMedianAbsoluteDeviation (as list of data: data_points) as float64
```
- **Parâmetros**:
  - `data_points` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statMedianAbsoluteDeviation` no domínio `StatDispersionContract`.

##### `op statCoefficientOfVariation`
```flux
op statCoefficientOfVariation (as list of data: data_points) as float64
```
- **Parâmetros**:
  - `data_points` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statCoefficientOfVariation` no domínio `StatDispersionContract`.

### 4.4 Contrato `StatDistributionContract` (`StatDistribution.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `statNormalPdf` | `op statNormalPdf (as float64: x, as float64: mean, as float64: std_dev) as float64` | `float64` |
| `statNormalCdf` | `op statNormalCdf (as float64: x, as float64: mean, as float64: std_dev) as float64` | `float64` |
| `statNormalInvCdf` | `op statNormalInvCdf (as float64: p, as float64: mean, as float64: std_dev) as float64` | `float64` |
| `statBinomialPmf` | `op statBinomialPmf (as int64: k, as int64: n, as float64: p) as float64` | `float64` |
| `statBinomialCdf` | `op statBinomialCdf (as int64: k, as int64: n, as float64: p) as float64` | `float64` |
| `statPoissonPmf` | `op statPoissonPmf (as int64: k, as float64: lambda_rate) as float64` | `float64` |
| `statPoissonCdf` | `op statPoissonCdf (as int64: k, as float64: lambda_rate) as float64` | `float64` |
| `statExponentialPdf` | `op statExponentialPdf (as float64: x, as float64: lambda_rate) as float64` | `float64` |
| `statExponentialCdf` | `op statExponentialCdf (as float64: x, as float64: lambda_rate) as float64` | `float64` |
| `statUniformPdf` | `op statUniformPdf (as float64: x, as float64: a, as float64: b) as float64` | `float64` |
| `statUniformCdf` | `op statUniformCdf (as float64: x, as float64: a, as float64: b) as float64` | `float64` |

#### Ficha Técnica das Operações:

##### `op statNormalPdf`
```flux
op statNormalPdf (as float64: x, as float64: mean, as float64: std_dev) as float64
```
- **Parâmetros**:
  - `x` (`float64`): Parâmetro de entrada para processamento da operação.
  - `mean` (`float64`): Parâmetro de entrada para processamento da operação.
  - `std_dev` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statNormalPdf` no domínio `StatDistributionContract`.

##### `op statNormalCdf`
```flux
op statNormalCdf (as float64: x, as float64: mean, as float64: std_dev) as float64
```
- **Parâmetros**:
  - `x` (`float64`): Parâmetro de entrada para processamento da operação.
  - `mean` (`float64`): Parâmetro de entrada para processamento da operação.
  - `std_dev` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statNormalCdf` no domínio `StatDistributionContract`.

##### `op statNormalInvCdf`
```flux
op statNormalInvCdf (as float64: p, as float64: mean, as float64: std_dev) as float64
```
- **Parâmetros**:
  - `p` (`float64`): Parâmetro de entrada para processamento da operação.
  - `mean` (`float64`): Parâmetro de entrada para processamento da operação.
  - `std_dev` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statNormalInvCdf` no domínio `StatDistributionContract`.

##### `op statBinomialPmf`
```flux
op statBinomialPmf (as int64: k, as int64: n, as float64: p) as float64
```
- **Parâmetros**:
  - `k` (`int64`): Parâmetro de entrada para processamento da operação.
  - `n` (`int64`): Parâmetro de entrada para processamento da operação.
  - `p` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statBinomialPmf` no domínio `StatDistributionContract`.

##### `op statBinomialCdf`
```flux
op statBinomialCdf (as int64: k, as int64: n, as float64: p) as float64
```
- **Parâmetros**:
  - `k` (`int64`): Parâmetro de entrada para processamento da operação.
  - `n` (`int64`): Parâmetro de entrada para processamento da operação.
  - `p` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statBinomialCdf` no domínio `StatDistributionContract`.

##### `op statPoissonPmf`
```flux
op statPoissonPmf (as int64: k, as float64: lambda_rate) as float64
```
- **Parâmetros**:
  - `k` (`int64`): Parâmetro de entrada para processamento da operação.
  - `lambda_rate` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statPoissonPmf` no domínio `StatDistributionContract`.

##### `op statPoissonCdf`
```flux
op statPoissonCdf (as int64: k, as float64: lambda_rate) as float64
```
- **Parâmetros**:
  - `k` (`int64`): Parâmetro de entrada para processamento da operação.
  - `lambda_rate` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statPoissonCdf` no domínio `StatDistributionContract`.

##### `op statExponentialPdf`
```flux
op statExponentialPdf (as float64: x, as float64: lambda_rate) as float64
```
- **Parâmetros**:
  - `x` (`float64`): Parâmetro de entrada para processamento da operação.
  - `lambda_rate` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statExponentialPdf` no domínio `StatDistributionContract`.

##### `op statExponentialCdf`
```flux
op statExponentialCdf (as float64: x, as float64: lambda_rate) as float64
```
- **Parâmetros**:
  - `x` (`float64`): Parâmetro de entrada para processamento da operação.
  - `lambda_rate` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statExponentialCdf` no domínio `StatDistributionContract`.

##### `op statUniformPdf`
```flux
op statUniformPdf (as float64: x, as float64: a, as float64: b) as float64
```
- **Parâmetros**:
  - `x` (`float64`): Parâmetro de entrada para processamento da operação.
  - `a` (`float64`): Parâmetro de entrada para processamento da operação.
  - `b` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statUniformPdf` no domínio `StatDistributionContract`.

##### `op statUniformCdf`
```flux
op statUniformCdf (as float64: x, as float64: a, as float64: b) as float64
```
- **Parâmetros**:
  - `x` (`float64`): Parâmetro de entrada para processamento da operação.
  - `a` (`float64`): Parâmetro de entrada para processamento da operação.
  - `b` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statUniformCdf` no domínio `StatDistributionContract`.

### 4.5 Contrato `StatInferenceContract` (`StatInference.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `statStandardErrorOfMean` | `op statStandardErrorOfMean (as list of data: data_points) as float64` | `float64` |
| `statConfidenceIntervalMean` | `op statConfidenceIntervalMean (as list of data: data_points, as float64: confidence_level) as list of data` | `list of data` |
| `statZTestOneSample` | `op statZTestOneSample (as list of data: data_points, as float64: null_mean) as float64` | `float64` |
| `statTTestOneSample` | `op statTTestOneSample (as list of data: data_points, as float64: null_mean) as list of data` | `list of data` |
| `statTTestTwoSample` | `op statTTestTwoSample (as list of data: sample1, as list of data: sample2) as list of data` | `list of data` |
| `statChiSquareGoF` | `op statChiSquareGoF (as list of data: observed, as list of data: expected) as list of data` | `list of data` |

#### Ficha Técnica das Operações:

##### `op statStandardErrorOfMean`
```flux
op statStandardErrorOfMean (as list of data: data_points) as float64
```
- **Parâmetros**:
  - `data_points` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statStandardErrorOfMean` no domínio `StatInferenceContract`.

##### `op statConfidenceIntervalMean`
```flux
op statConfidenceIntervalMean (as list of data: data_points, as float64: confidence_level) as list of data
```
- **Parâmetros**:
  - `data_points` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `confidence_level` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statConfidenceIntervalMean` no domínio `StatInferenceContract`.

##### `op statZTestOneSample`
```flux
op statZTestOneSample (as list of data: data_points, as float64: null_mean) as float64
```
- **Parâmetros**:
  - `data_points` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `null_mean` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statZTestOneSample` no domínio `StatInferenceContract`.

##### `op statTTestOneSample`
```flux
op statTTestOneSample (as list of data: data_points, as float64: null_mean) as list of data
```
- **Parâmetros**:
  - `data_points` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `null_mean` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statTTestOneSample` no domínio `StatInferenceContract`.

##### `op statTTestTwoSample`
```flux
op statTTestTwoSample (as list of data: sample1, as list of data: sample2) as list of data
```
- **Parâmetros**:
  - `sample1` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `sample2` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statTTestTwoSample` no domínio `StatInferenceContract`.

##### `op statChiSquareGoF`
```flux
op statChiSquareGoF (as list of data: observed, as list of data: expected) as list of data
```
- **Parâmetros**:
  - `observed` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `expected` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statChiSquareGoF` no domínio `StatInferenceContract`.

### 4.6 Contrato `StatOrderAndQuantilesContract` (`StatOrderAndQuantiles.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `statQuantile` | `op statQuantile (as list of data: data_points, as float64: p) as float64` | `float64` |
| `statPercentile` | `op statPercentile (as list of data: data_points, as float64: percent) as float64` | `float64` |
| `statQuartiles` | `op statQuartiles (as list of data: data_points) as list of data` | `list of data` |
| `statDeciles` | `op statDeciles (as list of data: data_points) as list of data` | `list of data` |
| `statRanks` | `op statRanks (as list of data: data_points) as list of data` | `list of data` |
| `statZScores` | `op statZScores (as list of data: data_points) as list of data` | `list of data` |

#### Ficha Técnica das Operações:

##### `op statQuantile`
```flux
op statQuantile (as list of data: data_points, as float64: p) as float64
```
- **Parâmetros**:
  - `data_points` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `p` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statQuantile` no domínio `StatOrderAndQuantilesContract`.

##### `op statPercentile`
```flux
op statPercentile (as list of data: data_points, as float64: percent) as float64
```
- **Parâmetros**:
  - `data_points` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `percent` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statPercentile` no domínio `StatOrderAndQuantilesContract`.

##### `op statQuartiles`
```flux
op statQuartiles (as list of data: data_points) as list of data
```
- **Parâmetros**:
  - `data_points` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statQuartiles` no domínio `StatOrderAndQuantilesContract`.

##### `op statDeciles`
```flux
op statDeciles (as list of data: data_points) as list of data
```
- **Parâmetros**:
  - `data_points` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statDeciles` no domínio `StatOrderAndQuantilesContract`.

##### `op statRanks`
```flux
op statRanks (as list of data: data_points) as list of data
```
- **Parâmetros**:
  - `data_points` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statRanks` no domínio `StatOrderAndQuantilesContract`.

##### `op statZScores`
```flux
op statZScores (as list of data: data_points) as list of data
```
- **Parâmetros**:
  - `data_points` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statZScores` no domínio `StatOrderAndQuantilesContract`.

### 4.7 Contrato `StatShapeContract` (`StatShape.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `statSkewnessPopulation` | `op statSkewnessPopulation (as list of data: data_points) as float64` | `float64` |
| `statSkewnessSample` | `op statSkewnessSample (as list of data: data_points) as float64` | `float64` |
| `statKurtosisPopulation` | `op statKurtosisPopulation (as list of data: data_points) as float64` | `float64` |
| `statKurtosisSample` | `op statKurtosisSample (as list of data: data_points) as float64` | `float64` |
| `statRawMoment` | `op statRawMoment (as list of data: data_points, as int64: order) as float64` | `float64` |
| `statCentralMoment` | `op statCentralMoment (as list of data: data_points, as int64: order) as float64` | `float64` |

#### Ficha Técnica das Operações:

##### `op statSkewnessPopulation`
```flux
op statSkewnessPopulation (as list of data: data_points) as float64
```
- **Parâmetros**:
  - `data_points` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statSkewnessPopulation` no domínio `StatShapeContract`.

##### `op statSkewnessSample`
```flux
op statSkewnessSample (as list of data: data_points) as float64
```
- **Parâmetros**:
  - `data_points` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statSkewnessSample` no domínio `StatShapeContract`.

##### `op statKurtosisPopulation`
```flux
op statKurtosisPopulation (as list of data: data_points) as float64
```
- **Parâmetros**:
  - `data_points` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statKurtosisPopulation` no domínio `StatShapeContract`.

##### `op statKurtosisSample`
```flux
op statKurtosisSample (as list of data: data_points) as float64
```
- **Parâmetros**:
  - `data_points` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statKurtosisSample` no domínio `StatShapeContract`.

##### `op statRawMoment`
```flux
op statRawMoment (as list of data: data_points, as int64: order) as float64
```
- **Parâmetros**:
  - `data_points` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `order` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statRawMoment` no domínio `StatShapeContract`.

##### `op statCentralMoment`
```flux
op statCentralMoment (as list of data: data_points, as int64: order) as float64
```
- **Parâmetros**:
  - `data_points` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `order` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statCentralMoment` no domínio `StatShapeContract`.

### 4.8 Contrato `StatSummaryContract` (`StatSummary.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `statFiveNumberSummary` | `op statFiveNumberSummary (as list of data: data_points) as list of data` | `list of data` |
| `statDetectOutliersIqr` | `op statDetectOutliersIqr (as list of data: data_points, as float64: multiplier) as list of data` | `list of data` |
| `statFrequencyTable` | `op statFrequencyTable (as list of data: data_points) as map` | `map` |
| `statHistogramBins` | `op statHistogramBins (as list of data: data_points, as int64: bin_count) as list of data` | `list of data` |
| `statHistogramCounts` | `op statHistogramCounts (as list of data: data_points, as list of data: bins) as list of data` | `list of data` |
| `statDescribe` | `op statDescribe (as list of data: data_points) as map` | `map` |

#### Ficha Técnica das Operações:

##### `op statFiveNumberSummary`
```flux
op statFiveNumberSummary (as list of data: data_points) as list of data
```
- **Parâmetros**:
  - `data_points` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statFiveNumberSummary` no domínio `StatSummaryContract`.

##### `op statDetectOutliersIqr`
```flux
op statDetectOutliersIqr (as list of data: data_points, as float64: multiplier) as list of data
```
- **Parâmetros**:
  - `data_points` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `multiplier` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statDetectOutliersIqr` no domínio `StatSummaryContract`.

##### `op statFrequencyTable`
```flux
op statFrequencyTable (as list of data: data_points) as map
```
- **Parâmetros**:
  - `data_points` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statFrequencyTable` no domínio `StatSummaryContract`.

##### `op statHistogramBins`
```flux
op statHistogramBins (as list of data: data_points, as int64: bin_count) as list of data
```
- **Parâmetros**:
  - `data_points` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `bin_count` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statHistogramBins` no domínio `StatSummaryContract`.

##### `op statHistogramCounts`
```flux
op statHistogramCounts (as list of data: data_points, as list of data: bins) as list of data
```
- **Parâmetros**:
  - `data_points` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `bins` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statHistogramCounts` no domínio `StatSummaryContract`.

##### `op statDescribe`
```flux
op statDescribe (as list of data: data_points) as map
```
- **Parâmetros**:
  - `data_points` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `statDescribe` no domínio `StatSummaryContract`.

---

## 5. Exemplos Canônicos de Uso em TheFlux

O exemplo a seguir demonstra a importação e o consumo prático da biblioteca:

```flux
# Exemplo Canônico de Consumo da StatStdLib
use StatStdLib

program (ExemploStatStdLib) {
      println("==================================================")
      println("  Demonstracao da Standard Library: StatStdLib")
      println("==================================================")

      # Chamada da operacao canônica
      mut as data: resultado = StatStdLib::statMean([1.0, 2.0, 3.0, 4.0, 5.0])
      println("Resultado obtido: " + resultado)

      println("Demonstracao concluida com sucesso.")
}
```

---

> [!TIP]
> Para consultar a visão arquitetural unificada de todas as bibliotecas, consulte o documento principal [StdLibs.md](../StdLibs.md).
