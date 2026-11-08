# 📚 `StatStdLib` — Descriptive and Inferential Statistics, Correlations, and Curve Fitting

> **Architectural Pillar**: Pillar 3 (Mathematics & Graphics)  
> **Status**: ✅ Certified with 100% Parity across 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Master File**: `stdlib/StatStdLib/StatStdLib.fdsl`  
> **Import Mode**: `use StatStdLib` or `use StatStdLib::<Module>::<operation>`

---

## 1. Overview and Capabilities

The **`StatStdLib`** standard library is an integral component of the official TheFlux language ecosystem, providing certified system-level algorithms and robust capabilities.

Comprehensive analytical statistics toolkit: central tendency metrics (arithmetic, geometric, harmonic mean, median, mode), dispersion (variance, standard deviation), quantiles, skewness, kurtosis, correlation coefficients (Pearson, Spearman), and hypothesis tests.

### 1.1 Key Architectural Principles and Design
- **Static Fusion and Zero-Overhead**: All domain modules are transparently fused into the `StatStdLib` unified agent at compile time, avoiding virtual dispatch penalties.
- **Safety and Isolation**: Operations strictly validate parameter bounds and guarantee predictable error semantics via contract definitions.
- **Universal Multi-Backend Parity**: Bit-for-bit identical execution guarantees across interpreter (`in`), bytecode VM (`vm`, `vmr`), native AOT LLVM (`llvm`), and WebAssembly (`wat`, `wasm`).

---

## 2. Modular Structure and Contracts

The library comprises **8 domain modules** declaring a total of **62 public operations**:

| Domain Source File | Formal Contract | Domain Responsibility | Ops Count |
|---|---|---|:---:|
| `StatCentralTendency.fdsl` | `StatCentralTendencyContract` | Specialized domain for `StatCentralTendency` | 10 |
| `StatCorrelation.fdsl` | `StatCorrelationContract` | Specialized domain for `StatCorrelation` | 6 |
| `StatDispersion.fdsl` | `StatDispersionContract` | Specialized domain for `StatDispersion` | 11 |
| `StatDistribution.fdsl` | `StatDistributionContract` | Specialized domain for `StatDistribution` | 11 |
| `StatInference.fdsl` | `StatInferenceContract` | Specialized domain for `StatInference` | 6 |
| `StatOrderAndQuantiles.fdsl` | `StatOrderAndQuantilesContract` | Specialized domain for `StatOrderAndQuantiles` | 6 |
| `StatShape.fdsl` | `StatShapeContract` | Specialized domain for `StatShape` | 6 |
| `StatSummary.fdsl` | `StatSummaryContract` | Specialized domain for `StatSummary` | 6 |

---

## 3. Public Types, Structures, and Enumerations

The `StatStdLib` library operates directly on primitive native TheFlux types (`string`, `int64`, `float64`, `bool`, `list of data`, etc.) without requiring custom composite types.

---

## 4. Detailed Operations Catalog by Domain

### 4.1 Contract `StatCentralTendencyContract` (`StatCentralTendency.fdsl`)

| Operation | Formal Signature | Return Type |
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

#### Operation Technical Specifications:

##### `op statMean`
```flux
op statMean (as list of data: data_points) as float64
```
- **Parameters**:
  - `data_points` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statMean` functionality within the `StatCentralTendencyContract` domain.

##### `op statWeightedMean`
```flux
op statWeightedMean (as list of data: data_points, as list of data: weights) as float64
```
- **Parameters**:
  - `data_points` (`list of data`): Input argument for operation execution.
  - `weights` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statWeightedMean` functionality within the `StatCentralTendencyContract` domain.

##### `op statGeometricMean`
```flux
op statGeometricMean (as list of data: data_points) as float64
```
- **Parameters**:
  - `data_points` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statGeometricMean` functionality within the `StatCentralTendencyContract` domain.

##### `op statHarmonicMean`
```flux
op statHarmonicMean (as list of data: data_points) as float64
```
- **Parameters**:
  - `data_points` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statHarmonicMean` functionality within the `StatCentralTendencyContract` domain.

##### `op statMedian`
```flux
op statMedian (as list of data: data_points) as float64
```
- **Parameters**:
  - `data_points` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statMedian` functionality within the `StatCentralTendencyContract` domain.

##### `op statMedianLow`
```flux
op statMedianLow (as list of data: data_points) as float64
```
- **Parameters**:
  - `data_points` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statMedianLow` functionality within the `StatCentralTendencyContract` domain.

##### `op statMedianHigh`
```flux
op statMedianHigh (as list of data: data_points) as float64
```
- **Parameters**:
  - `data_points` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statMedianHigh` functionality within the `StatCentralTendencyContract` domain.

##### `op statMode`
```flux
op statMode (as list of data: data_points) as float64
```
- **Parameters**:
  - `data_points` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statMode` functionality within the `StatCentralTendencyContract` domain.

##### `op statMultimode`
```flux
op statMultimode (as list of data: data_points) as list of data
```
- **Parameters**:
  - `data_points` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statMultimode` functionality within the `StatCentralTendencyContract` domain.

##### `op statTrimmedMean`
```flux
op statTrimmedMean (as list of data: data_points, as float64: cut_proportion) as float64
```
- **Parameters**:
  - `data_points` (`list of data`): Input argument for operation execution.
  - `cut_proportion` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statTrimmedMean` functionality within the `StatCentralTendencyContract` domain.

### 4.2 Contract `StatCorrelationContract` (`StatCorrelation.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `statCovariancePopulation` | `op statCovariancePopulation (as list of data: x, as list of data: y) as float64` | `float64` |
| `statCovarianceSample` | `op statCovarianceSample (as list of data: x, as list of data: y) as float64` | `float64` |
| `statPearsonCorrelation` | `op statPearsonCorrelation (as list of data: x, as list of data: y) as float64` | `float64` |
| `statSpearmanCorrelation` | `op statSpearmanCorrelation (as list of data: x, as list of data: y) as float64` | `float64` |
| `statLinearRegression` | `op statLinearRegression (as list of data: x, as list of data: y) as map` | `map` |
| `statLinearResiduals` | `op statLinearResiduals (as list of data: x, as list of data: y, as float64: slope, as float64: intercept) as list of data` | `list of data` |

#### Operation Technical Specifications:

##### `op statCovariancePopulation`
```flux
op statCovariancePopulation (as list of data: x, as list of data: y) as float64
```
- **Parameters**:
  - `x` (`list of data`): Input argument for operation execution.
  - `y` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statCovariancePopulation` functionality within the `StatCorrelationContract` domain.

##### `op statCovarianceSample`
```flux
op statCovarianceSample (as list of data: x, as list of data: y) as float64
```
- **Parameters**:
  - `x` (`list of data`): Input argument for operation execution.
  - `y` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statCovarianceSample` functionality within the `StatCorrelationContract` domain.

##### `op statPearsonCorrelation`
```flux
op statPearsonCorrelation (as list of data: x, as list of data: y) as float64
```
- **Parameters**:
  - `x` (`list of data`): Input argument for operation execution.
  - `y` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statPearsonCorrelation` functionality within the `StatCorrelationContract` domain.

##### `op statSpearmanCorrelation`
```flux
op statSpearmanCorrelation (as list of data: x, as list of data: y) as float64
```
- **Parameters**:
  - `x` (`list of data`): Input argument for operation execution.
  - `y` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statSpearmanCorrelation` functionality within the `StatCorrelationContract` domain.

##### `op statLinearRegression`
```flux
op statLinearRegression (as list of data: x, as list of data: y) as map
```
- **Parameters**:
  - `x` (`list of data`): Input argument for operation execution.
  - `y` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statLinearRegression` functionality within the `StatCorrelationContract` domain.

##### `op statLinearResiduals`
```flux
op statLinearResiduals (as list of data: x, as list of data: y, as float64: slope, as float64: intercept) as list of data
```
- **Parameters**:
  - `x` (`list of data`): Input argument for operation execution.
  - `y` (`list of data`): Input argument for operation execution.
  - `slope` (`float64`): Input argument for operation execution.
  - `intercept` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statLinearResiduals` functionality within the `StatCorrelationContract` domain.

### 4.3 Contract `StatDispersionContract` (`StatDispersion.fdsl`)

| Operation | Formal Signature | Return Type |
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

#### Operation Technical Specifications:

##### `op statVariancePopulation`
```flux
op statVariancePopulation (as list of data: data_points) as float64
```
- **Parameters**:
  - `data_points` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statVariancePopulation` functionality within the `StatDispersionContract` domain.

##### `op statVarianceSample`
```flux
op statVarianceSample (as list of data: data_points) as float64
```
- **Parameters**:
  - `data_points` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statVarianceSample` functionality within the `StatDispersionContract` domain.

##### `op statStdDevPopulation`
```flux
op statStdDevPopulation (as list of data: data_points) as float64
```
- **Parameters**:
  - `data_points` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statStdDevPopulation` functionality within the `StatDispersionContract` domain.

##### `op statStdDevSample`
```flux
op statStdDevSample (as list of data: data_points) as float64
```
- **Parameters**:
  - `data_points` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statStdDevSample` functionality within the `StatDispersionContract` domain.

##### `op statRange`
```flux
op statRange (as list of data: data_points) as float64
```
- **Parameters**:
  - `data_points` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statRange` functionality within the `StatDispersionContract` domain.

##### `op statMin`
```flux
op statMin (as list of data: data_points) as float64
```
- **Parameters**:
  - `data_points` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statMin` functionality within the `StatDispersionContract` domain.

##### `op statMax`
```flux
op statMax (as list of data: data_points) as float64
```
- **Parameters**:
  - `data_points` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statMax` functionality within the `StatDispersionContract` domain.

##### `op statIQR`
```flux
op statIQR (as list of data: data_points) as float64
```
- **Parameters**:
  - `data_points` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statIQR` functionality within the `StatDispersionContract` domain.

##### `op statMeanAbsoluteDeviation`
```flux
op statMeanAbsoluteDeviation (as list of data: data_points) as float64
```
- **Parameters**:
  - `data_points` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statMeanAbsoluteDeviation` functionality within the `StatDispersionContract` domain.

##### `op statMedianAbsoluteDeviation`
```flux
op statMedianAbsoluteDeviation (as list of data: data_points) as float64
```
- **Parameters**:
  - `data_points` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statMedianAbsoluteDeviation` functionality within the `StatDispersionContract` domain.

##### `op statCoefficientOfVariation`
```flux
op statCoefficientOfVariation (as list of data: data_points) as float64
```
- **Parameters**:
  - `data_points` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statCoefficientOfVariation` functionality within the `StatDispersionContract` domain.

### 4.4 Contract `StatDistributionContract` (`StatDistribution.fdsl`)

| Operation | Formal Signature | Return Type |
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

#### Operation Technical Specifications:

##### `op statNormalPdf`
```flux
op statNormalPdf (as float64: x, as float64: mean, as float64: std_dev) as float64
```
- **Parameters**:
  - `x` (`float64`): Input argument for operation execution.
  - `mean` (`float64`): Input argument for operation execution.
  - `std_dev` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statNormalPdf` functionality within the `StatDistributionContract` domain.

##### `op statNormalCdf`
```flux
op statNormalCdf (as float64: x, as float64: mean, as float64: std_dev) as float64
```
- **Parameters**:
  - `x` (`float64`): Input argument for operation execution.
  - `mean` (`float64`): Input argument for operation execution.
  - `std_dev` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statNormalCdf` functionality within the `StatDistributionContract` domain.

##### `op statNormalInvCdf`
```flux
op statNormalInvCdf (as float64: p, as float64: mean, as float64: std_dev) as float64
```
- **Parameters**:
  - `p` (`float64`): Input argument for operation execution.
  - `mean` (`float64`): Input argument for operation execution.
  - `std_dev` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statNormalInvCdf` functionality within the `StatDistributionContract` domain.

##### `op statBinomialPmf`
```flux
op statBinomialPmf (as int64: k, as int64: n, as float64: p) as float64
```
- **Parameters**:
  - `k` (`int64`): Input argument for operation execution.
  - `n` (`int64`): Input argument for operation execution.
  - `p` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statBinomialPmf` functionality within the `StatDistributionContract` domain.

##### `op statBinomialCdf`
```flux
op statBinomialCdf (as int64: k, as int64: n, as float64: p) as float64
```
- **Parameters**:
  - `k` (`int64`): Input argument for operation execution.
  - `n` (`int64`): Input argument for operation execution.
  - `p` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statBinomialCdf` functionality within the `StatDistributionContract` domain.

##### `op statPoissonPmf`
```flux
op statPoissonPmf (as int64: k, as float64: lambda_rate) as float64
```
- **Parameters**:
  - `k` (`int64`): Input argument for operation execution.
  - `lambda_rate` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statPoissonPmf` functionality within the `StatDistributionContract` domain.

##### `op statPoissonCdf`
```flux
op statPoissonCdf (as int64: k, as float64: lambda_rate) as float64
```
- **Parameters**:
  - `k` (`int64`): Input argument for operation execution.
  - `lambda_rate` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statPoissonCdf` functionality within the `StatDistributionContract` domain.

##### `op statExponentialPdf`
```flux
op statExponentialPdf (as float64: x, as float64: lambda_rate) as float64
```
- **Parameters**:
  - `x` (`float64`): Input argument for operation execution.
  - `lambda_rate` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statExponentialPdf` functionality within the `StatDistributionContract` domain.

##### `op statExponentialCdf`
```flux
op statExponentialCdf (as float64: x, as float64: lambda_rate) as float64
```
- **Parameters**:
  - `x` (`float64`): Input argument for operation execution.
  - `lambda_rate` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statExponentialCdf` functionality within the `StatDistributionContract` domain.

##### `op statUniformPdf`
```flux
op statUniformPdf (as float64: x, as float64: a, as float64: b) as float64
```
- **Parameters**:
  - `x` (`float64`): Input argument for operation execution.
  - `a` (`float64`): Input argument for operation execution.
  - `b` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statUniformPdf` functionality within the `StatDistributionContract` domain.

##### `op statUniformCdf`
```flux
op statUniformCdf (as float64: x, as float64: a, as float64: b) as float64
```
- **Parameters**:
  - `x` (`float64`): Input argument for operation execution.
  - `a` (`float64`): Input argument for operation execution.
  - `b` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statUniformCdf` functionality within the `StatDistributionContract` domain.

### 4.5 Contract `StatInferenceContract` (`StatInference.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `statStandardErrorOfMean` | `op statStandardErrorOfMean (as list of data: data_points) as float64` | `float64` |
| `statConfidenceIntervalMean` | `op statConfidenceIntervalMean (as list of data: data_points, as float64: confidence_level) as list of data` | `list of data` |
| `statZTestOneSample` | `op statZTestOneSample (as list of data: data_points, as float64: null_mean) as float64` | `float64` |
| `statTTestOneSample` | `op statTTestOneSample (as list of data: data_points, as float64: null_mean) as list of data` | `list of data` |
| `statTTestTwoSample` | `op statTTestTwoSample (as list of data: sample1, as list of data: sample2) as list of data` | `list of data` |
| `statChiSquareGoF` | `op statChiSquareGoF (as list of data: observed, as list of data: expected) as list of data` | `list of data` |

#### Operation Technical Specifications:

##### `op statStandardErrorOfMean`
```flux
op statStandardErrorOfMean (as list of data: data_points) as float64
```
- **Parameters**:
  - `data_points` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statStandardErrorOfMean` functionality within the `StatInferenceContract` domain.

##### `op statConfidenceIntervalMean`
```flux
op statConfidenceIntervalMean (as list of data: data_points, as float64: confidence_level) as list of data
```
- **Parameters**:
  - `data_points` (`list of data`): Input argument for operation execution.
  - `confidence_level` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statConfidenceIntervalMean` functionality within the `StatInferenceContract` domain.

##### `op statZTestOneSample`
```flux
op statZTestOneSample (as list of data: data_points, as float64: null_mean) as float64
```
- **Parameters**:
  - `data_points` (`list of data`): Input argument for operation execution.
  - `null_mean` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statZTestOneSample` functionality within the `StatInferenceContract` domain.

##### `op statTTestOneSample`
```flux
op statTTestOneSample (as list of data: data_points, as float64: null_mean) as list of data
```
- **Parameters**:
  - `data_points` (`list of data`): Input argument for operation execution.
  - `null_mean` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statTTestOneSample` functionality within the `StatInferenceContract` domain.

##### `op statTTestTwoSample`
```flux
op statTTestTwoSample (as list of data: sample1, as list of data: sample2) as list of data
```
- **Parameters**:
  - `sample1` (`list of data`): Input argument for operation execution.
  - `sample2` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statTTestTwoSample` functionality within the `StatInferenceContract` domain.

##### `op statChiSquareGoF`
```flux
op statChiSquareGoF (as list of data: observed, as list of data: expected) as list of data
```
- **Parameters**:
  - `observed` (`list of data`): Input argument for operation execution.
  - `expected` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statChiSquareGoF` functionality within the `StatInferenceContract` domain.

### 4.6 Contract `StatOrderAndQuantilesContract` (`StatOrderAndQuantiles.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `statQuantile` | `op statQuantile (as list of data: data_points, as float64: p) as float64` | `float64` |
| `statPercentile` | `op statPercentile (as list of data: data_points, as float64: percent) as float64` | `float64` |
| `statQuartiles` | `op statQuartiles (as list of data: data_points) as list of data` | `list of data` |
| `statDeciles` | `op statDeciles (as list of data: data_points) as list of data` | `list of data` |
| `statRanks` | `op statRanks (as list of data: data_points) as list of data` | `list of data` |
| `statZScores` | `op statZScores (as list of data: data_points) as list of data` | `list of data` |

#### Operation Technical Specifications:

##### `op statQuantile`
```flux
op statQuantile (as list of data: data_points, as float64: p) as float64
```
- **Parameters**:
  - `data_points` (`list of data`): Input argument for operation execution.
  - `p` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statQuantile` functionality within the `StatOrderAndQuantilesContract` domain.

##### `op statPercentile`
```flux
op statPercentile (as list of data: data_points, as float64: percent) as float64
```
- **Parameters**:
  - `data_points` (`list of data`): Input argument for operation execution.
  - `percent` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statPercentile` functionality within the `StatOrderAndQuantilesContract` domain.

##### `op statQuartiles`
```flux
op statQuartiles (as list of data: data_points) as list of data
```
- **Parameters**:
  - `data_points` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statQuartiles` functionality within the `StatOrderAndQuantilesContract` domain.

##### `op statDeciles`
```flux
op statDeciles (as list of data: data_points) as list of data
```
- **Parameters**:
  - `data_points` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statDeciles` functionality within the `StatOrderAndQuantilesContract` domain.

##### `op statRanks`
```flux
op statRanks (as list of data: data_points) as list of data
```
- **Parameters**:
  - `data_points` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statRanks` functionality within the `StatOrderAndQuantilesContract` domain.

##### `op statZScores`
```flux
op statZScores (as list of data: data_points) as list of data
```
- **Parameters**:
  - `data_points` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statZScores` functionality within the `StatOrderAndQuantilesContract` domain.

### 4.7 Contract `StatShapeContract` (`StatShape.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `statSkewnessPopulation` | `op statSkewnessPopulation (as list of data: data_points) as float64` | `float64` |
| `statSkewnessSample` | `op statSkewnessSample (as list of data: data_points) as float64` | `float64` |
| `statKurtosisPopulation` | `op statKurtosisPopulation (as list of data: data_points) as float64` | `float64` |
| `statKurtosisSample` | `op statKurtosisSample (as list of data: data_points) as float64` | `float64` |
| `statRawMoment` | `op statRawMoment (as list of data: data_points, as int64: order) as float64` | `float64` |
| `statCentralMoment` | `op statCentralMoment (as list of data: data_points, as int64: order) as float64` | `float64` |

#### Operation Technical Specifications:

##### `op statSkewnessPopulation`
```flux
op statSkewnessPopulation (as list of data: data_points) as float64
```
- **Parameters**:
  - `data_points` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statSkewnessPopulation` functionality within the `StatShapeContract` domain.

##### `op statSkewnessSample`
```flux
op statSkewnessSample (as list of data: data_points) as float64
```
- **Parameters**:
  - `data_points` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statSkewnessSample` functionality within the `StatShapeContract` domain.

##### `op statKurtosisPopulation`
```flux
op statKurtosisPopulation (as list of data: data_points) as float64
```
- **Parameters**:
  - `data_points` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statKurtosisPopulation` functionality within the `StatShapeContract` domain.

##### `op statKurtosisSample`
```flux
op statKurtosisSample (as list of data: data_points) as float64
```
- **Parameters**:
  - `data_points` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statKurtosisSample` functionality within the `StatShapeContract` domain.

##### `op statRawMoment`
```flux
op statRawMoment (as list of data: data_points, as int64: order) as float64
```
- **Parameters**:
  - `data_points` (`list of data`): Input argument for operation execution.
  - `order` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statRawMoment` functionality within the `StatShapeContract` domain.

##### `op statCentralMoment`
```flux
op statCentralMoment (as list of data: data_points, as int64: order) as float64
```
- **Parameters**:
  - `data_points` (`list of data`): Input argument for operation execution.
  - `order` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statCentralMoment` functionality within the `StatShapeContract` domain.

### 4.8 Contract `StatSummaryContract` (`StatSummary.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `statFiveNumberSummary` | `op statFiveNumberSummary (as list of data: data_points) as list of data` | `list of data` |
| `statDetectOutliersIqr` | `op statDetectOutliersIqr (as list of data: data_points, as float64: multiplier) as list of data` | `list of data` |
| `statFrequencyTable` | `op statFrequencyTable (as list of data: data_points) as map` | `map` |
| `statHistogramBins` | `op statHistogramBins (as list of data: data_points, as int64: bin_count) as list of data` | `list of data` |
| `statHistogramCounts` | `op statHistogramCounts (as list of data: data_points, as list of data: bins) as list of data` | `list of data` |
| `statDescribe` | `op statDescribe (as list of data: data_points) as map` | `map` |

#### Operation Technical Specifications:

##### `op statFiveNumberSummary`
```flux
op statFiveNumberSummary (as list of data: data_points) as list of data
```
- **Parameters**:
  - `data_points` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statFiveNumberSummary` functionality within the `StatSummaryContract` domain.

##### `op statDetectOutliersIqr`
```flux
op statDetectOutliersIqr (as list of data: data_points, as float64: multiplier) as list of data
```
- **Parameters**:
  - `data_points` (`list of data`): Input argument for operation execution.
  - `multiplier` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statDetectOutliersIqr` functionality within the `StatSummaryContract` domain.

##### `op statFrequencyTable`
```flux
op statFrequencyTable (as list of data: data_points) as map
```
- **Parameters**:
  - `data_points` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statFrequencyTable` functionality within the `StatSummaryContract` domain.

##### `op statHistogramBins`
```flux
op statHistogramBins (as list of data: data_points, as int64: bin_count) as list of data
```
- **Parameters**:
  - `data_points` (`list of data`): Input argument for operation execution.
  - `bin_count` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statHistogramBins` functionality within the `StatSummaryContract` domain.

##### `op statHistogramCounts`
```flux
op statHistogramCounts (as list of data: data_points, as list of data: bins) as list of data
```
- **Parameters**:
  - `data_points` (`list of data`): Input argument for operation execution.
  - `bins` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statHistogramCounts` functionality within the `StatSummaryContract` domain.

##### `op statDescribe`
```flux
op statDescribe (as list of data: data_points) as map
```
- **Parameters**:
  - `data_points` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `statDescribe` functionality within the `StatSummaryContract` domain.

---

## 5. Canonical Usage Examples in TheFlux

The following snippet illustrates importing and utilizing the library in a TheFlux program:

```flux
# Canonical Usage Example for StatStdLib
use StatStdLib

program (ExampleOfStatStdLib) {
      println("==================================================")
      println("  Standard Library Demonstration: StatStdLib")
      println("==================================================")

      # Invoking canonical operation
      mut as data: result = StatStdLib::statMean([1.0, 2.0, 3.0, 4.0, 5.0])
      println("Obtained result: " + result)

      println("Execution completed successfully.")
}
```

---

> [!TIP]
> For the complete unified architecture across all standard libraries, consult the master [StdLibs.md](../StdLibs.md) reference.
