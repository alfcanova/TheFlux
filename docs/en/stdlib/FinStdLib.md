# 📚 `FinStdLib` — High-Precision Financial Mathematics and Investment Analysis

> **Architectural Pillar**: Pillar 3 (Mathematics & Graphics)  
> **Status**: ✅ Certified with 100% Parity across 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Master File**: `stdlib/FinStdLib/FinStdLib.fdsl`  
> **Import Mode**: `use FinStdLib` or `use FinStdLib::<Module>::<operation>`

---

## 1. Overview and Capabilities

The **`FinStdLib`** standard library is an integral component of the official TheFlux language ecosystem, providing certified system-level algorithms and robust capabilities.

Exact financial math backed by arbitrary-scale decimal fixed-point (`FinDecimal`) to eliminate floating-point drift: compound interest, loan amortization tables, Net Present Value (NPV), Internal Rate of Return (IRR), and depreciation models.

### 1.1 Key Architectural Principles and Design
- **Static Fusion and Zero-Overhead**: All domain modules are transparently fused into the `FinStdLib` unified agent at compile time, avoiding virtual dispatch penalties.
- **Safety and Isolation**: Operations strictly validate parameter bounds and guarantee predictable error semantics via contract definitions.
- **Universal Multi-Backend Parity**: Bit-for-bit identical execution guarantees across interpreter (`in`), bytecode VM (`vm`, `vmr`), native AOT LLVM (`llvm`), and WebAssembly (`wat`, `wasm`).

---

## 2. Modular Structure and Contracts

The library comprises **7 domain modules** declaring a total of **62 public operations**:

| Domain Source File | Formal Contract | Domain Responsibility | Ops Count |
|---|---|---|:---:|
| `FinAmortization.fdsl` | `FinAmortizationContract` | Specialized domain for `FinAmortization` | 4 |
| `FinComparison.fdsl` | `FinComparisonContract` | Specialized domain for `FinComparison` | 11 |
| `FinDecimal.fdsl` | `FinDecimalContract` | Specialized domain for `FinDecimal` | 17 |
| `FinDepreciation.fdsl` | `FinDepreciationContract` | Specialized domain for `FinDepreciation` | 3 |
| `FinFormat.fdsl` | `FinFormatContract` | Specialized domain for `FinFormat` | 3 |
| `FinRate.fdsl` | `FinRateContract` | Specialized domain for `FinRate` | 12 |
| `FinTimeValueOfMoney.fdsl` | `FinTimeValueOfMoneyContract` | Specialized domain for `FinTimeValueOfMoney` | 12 |

---

## 3. Public Types, Structures, and Enumerations

### Structure `struct (FinDecimal)`
*Declared in: `FinStdLib.fdsl`*

```flux
struct (FinDecimal) {
      mut: .raw: int64
      mut: .scale: int64
}
```

### Structure `struct (AmortizationInstallment)`
*Declared in: `FinStdLib.fdsl`*

```flux
struct (AmortizationInstallment) {
      mut: .month: int64
      mut: .payment: FinDecimal
      mut: .amortization: FinDecimal
      mut: .interest: FinDecimal
      mut: .balance: FinDecimal
}
```

### Enumeration `enum (RoundingMode)`
*Declared in: `FinStdLib.fdsl`*

```flux
enum (RoundingMode) {
      FinHalfEven
      FinHalfUp
      FinUp
      FinDown
}
```

---

## 4. Detailed Operations Catalog by Domain

### 4.1 Contract `FinAmortizationContract` (`FinAmortization.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `finAmortizationPrice` | `op finAmortizationPrice (as FinDecimal: principal, as float64: annual_rate, as int64: months) as list of data` | `list of data` |
| `finAmortizationSac` | `op finAmortizationSac (as FinDecimal: principal, as float64: annual_rate, as int64: months) as list of data` | `list of data` |
| `finAmortizationSaa` | `op finAmortizationSaa (as FinDecimal: principal, as float64: annual_rate, as int64: months) as list of data` | `list of data` |
| `finAmortizationTotals` | `op finAmortizationTotals (as list of data: installments) as map` | `map` |

#### Operation Technical Specifications:

##### `op finAmortizationPrice`
```flux
op finAmortizationPrice (as FinDecimal: principal, as float64: annual_rate, as int64: months) as list of data
```
- **Parameters**:
  - `principal` (`FinDecimal`): Input argument for operation execution.
  - `annual_rate` (`float64`): Input argument for operation execution.
  - `months` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finAmortizationPrice` functionality within the `FinAmortizationContract` domain.

##### `op finAmortizationSac`
```flux
op finAmortizationSac (as FinDecimal: principal, as float64: annual_rate, as int64: months) as list of data
```
- **Parameters**:
  - `principal` (`FinDecimal`): Input argument for operation execution.
  - `annual_rate` (`float64`): Input argument for operation execution.
  - `months` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finAmortizationSac` functionality within the `FinAmortizationContract` domain.

##### `op finAmortizationSaa`
```flux
op finAmortizationSaa (as FinDecimal: principal, as float64: annual_rate, as int64: months) as list of data
```
- **Parameters**:
  - `principal` (`FinDecimal`): Input argument for operation execution.
  - `annual_rate` (`float64`): Input argument for operation execution.
  - `months` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finAmortizationSaa` functionality within the `FinAmortizationContract` domain.

##### `op finAmortizationTotals`
```flux
op finAmortizationTotals (as list of data: installments) as map
```
- **Parameters**:
  - `installments` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finAmortizationTotals` functionality within the `FinAmortizationContract` domain.

### 4.2 Contract `FinComparisonContract` (`FinComparison.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `finEquals` | `op finEquals (as FinDecimal: a, as FinDecimal: b) as bool` | `bool` |
| `finCompare` | `op finCompare (as FinDecimal: a, as FinDecimal: b) as int64` | `int64` |
| `finGt` | `op finGt (as FinDecimal: a, as FinDecimal: b) as bool` | `bool` |
| `finGte` | `op finGte (as FinDecimal: a, as FinDecimal: b) as bool` | `bool` |
| `finLt` | `op finLt (as FinDecimal: a, as FinDecimal: b) as bool` | `bool` |
| `finLte` | `op finLte (as FinDecimal: a, as FinDecimal: b) as bool` | `bool` |
| `finIsZero` | `op finIsZero (as FinDecimal: val) as bool` | `bool` |
| `finIsPositive` | `op finIsPositive (as FinDecimal: val) as bool` | `bool` |
| `finIsNegative` | `op finIsNegative (as FinDecimal: val) as bool` | `bool` |
| `finBetween` | `op finBetween (as FinDecimal: val, as FinDecimal: min_val, as FinDecimal: max_val) as bool` | `bool` |
| `finIsValidBalance` | `op finIsValidBalance (as FinDecimal: val) as bool` | `bool` |

#### Operation Technical Specifications:

##### `op finEquals`
```flux
op finEquals (as FinDecimal: a, as FinDecimal: b) as bool
```
- **Parameters**:
  - `a` (`FinDecimal`): Input argument for operation execution.
  - `b` (`FinDecimal`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finEquals` functionality within the `FinComparisonContract` domain.

##### `op finCompare`
```flux
op finCompare (as FinDecimal: a, as FinDecimal: b) as int64
```
- **Parameters**:
  - `a` (`FinDecimal`): Input argument for operation execution.
  - `b` (`FinDecimal`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finCompare` functionality within the `FinComparisonContract` domain.

##### `op finGt`
```flux
op finGt (as FinDecimal: a, as FinDecimal: b) as bool
```
- **Parameters**:
  - `a` (`FinDecimal`): Input argument for operation execution.
  - `b` (`FinDecimal`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finGt` functionality within the `FinComparisonContract` domain.

##### `op finGte`
```flux
op finGte (as FinDecimal: a, as FinDecimal: b) as bool
```
- **Parameters**:
  - `a` (`FinDecimal`): Input argument for operation execution.
  - `b` (`FinDecimal`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finGte` functionality within the `FinComparisonContract` domain.

##### `op finLt`
```flux
op finLt (as FinDecimal: a, as FinDecimal: b) as bool
```
- **Parameters**:
  - `a` (`FinDecimal`): Input argument for operation execution.
  - `b` (`FinDecimal`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finLt` functionality within the `FinComparisonContract` domain.

##### `op finLte`
```flux
op finLte (as FinDecimal: a, as FinDecimal: b) as bool
```
- **Parameters**:
  - `a` (`FinDecimal`): Input argument for operation execution.
  - `b` (`FinDecimal`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finLte` functionality within the `FinComparisonContract` domain.

##### `op finIsZero`
```flux
op finIsZero (as FinDecimal: val) as bool
```
- **Parameters**:
  - `val` (`FinDecimal`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finIsZero` functionality within the `FinComparisonContract` domain.

##### `op finIsPositive`
```flux
op finIsPositive (as FinDecimal: val) as bool
```
- **Parameters**:
  - `val` (`FinDecimal`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finIsPositive` functionality within the `FinComparisonContract` domain.

##### `op finIsNegative`
```flux
op finIsNegative (as FinDecimal: val) as bool
```
- **Parameters**:
  - `val` (`FinDecimal`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finIsNegative` functionality within the `FinComparisonContract` domain.

##### `op finBetween`
```flux
op finBetween (as FinDecimal: val, as FinDecimal: min_val, as FinDecimal: max_val) as bool
```
- **Parameters**:
  - `val` (`FinDecimal`): Input argument for operation execution.
  - `min_val` (`FinDecimal`): Input argument for operation execution.
  - `max_val` (`FinDecimal`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finBetween` functionality within the `FinComparisonContract` domain.

##### `op finIsValidBalance`
```flux
op finIsValidBalance (as FinDecimal: val) as bool
```
- **Parameters**:
  - `val` (`FinDecimal`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finIsValidBalance` functionality within the `FinComparisonContract` domain.

### 4.3 Contract `FinDecimalContract` (`FinDecimal.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `finCreateDecimal` | `op finCreateDecimal (as string: value) as FinDecimal` | `FinDecimal` |
| `finFromInt` | `op finFromInt (as int64: value) as FinDecimal` | `FinDecimal` |
| `finFromFloat` | `op finFromFloat (as float64: value) as FinDecimal` | `FinDecimal` |
| `finDecimalToString` | `op finDecimalToString (as FinDecimal: val) as string` | `string` |
| `finDecimalToFloat` | `op finDecimalToFloat (as FinDecimal: val) as float64` | `float64` |
| `finAdd` | `op finAdd (as FinDecimal: a, as FinDecimal: b) as FinDecimal` | `FinDecimal` |
| `finSubtract` | `op finSubtract (as FinDecimal: a, as FinDecimal: b) as FinDecimal` | `FinDecimal` |
| `finMultiply` | `op finMultiply (as FinDecimal: a, as FinDecimal: b) as FinDecimal` | `FinDecimal` |
| `finDivide` | `op finDivide (as FinDecimal: a, as FinDecimal: b) as FinDecimal` | `FinDecimal` |
| `finRound` | `op finRound (as FinDecimal: val, as int64: decimals, as RoundingMode: mode) as FinDecimal` | `FinDecimal` |
| `finAbs` | `op finAbs (as FinDecimal: val) as FinDecimal` | `FinDecimal` |
| `finNegate` | `op finNegate (as FinDecimal: val) as FinDecimal` | `FinDecimal` |
| `finMin` | `op finMin (as FinDecimal: a, as FinDecimal: b) as FinDecimal` | `FinDecimal` |
| `finMax` | `op finMax (as FinDecimal: a, as FinDecimal: b) as FinDecimal` | `FinDecimal` |
| `finClamp` | `op finClamp (as FinDecimal: val, as FinDecimal: min_val, as FinDecimal: max_val) as FinDecimal` | `FinDecimal` |
| `finSplit` | `op finSplit (as FinDecimal: amount, as int64: parts) as list of data` | `list of data` |
| `finAllocate` | `op finAllocate (as FinDecimal: amount, as list of data: weights) as list of data` | `list of data` |

#### Operation Technical Specifications:

##### `op finCreateDecimal`
```flux
op finCreateDecimal (as string: value) as FinDecimal
```
- **Parameters**:
  - `value` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `FinDecimal`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finCreateDecimal` functionality within the `FinDecimalContract` domain.

##### `op finFromInt`
```flux
op finFromInt (as int64: value) as FinDecimal
```
- **Parameters**:
  - `value` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `FinDecimal`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finFromInt` functionality within the `FinDecimalContract` domain.

##### `op finFromFloat`
```flux
op finFromFloat (as float64: value) as FinDecimal
```
- **Parameters**:
  - `value` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `FinDecimal`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finFromFloat` functionality within the `FinDecimalContract` domain.

##### `op finDecimalToString`
```flux
op finDecimalToString (as FinDecimal: val) as string
```
- **Parameters**:
  - `val` (`FinDecimal`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finDecimalToString` functionality within the `FinDecimalContract` domain.

##### `op finDecimalToFloat`
```flux
op finDecimalToFloat (as FinDecimal: val) as float64
```
- **Parameters**:
  - `val` (`FinDecimal`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finDecimalToFloat` functionality within the `FinDecimalContract` domain.

##### `op finAdd`
```flux
op finAdd (as FinDecimal: a, as FinDecimal: b) as FinDecimal
```
- **Parameters**:
  - `a` (`FinDecimal`): Input argument for operation execution.
  - `b` (`FinDecimal`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `FinDecimal`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finAdd` functionality within the `FinDecimalContract` domain.

##### `op finSubtract`
```flux
op finSubtract (as FinDecimal: a, as FinDecimal: b) as FinDecimal
```
- **Parameters**:
  - `a` (`FinDecimal`): Input argument for operation execution.
  - `b` (`FinDecimal`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `FinDecimal`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finSubtract` functionality within the `FinDecimalContract` domain.

##### `op finMultiply`
```flux
op finMultiply (as FinDecimal: a, as FinDecimal: b) as FinDecimal
```
- **Parameters**:
  - `a` (`FinDecimal`): Input argument for operation execution.
  - `b` (`FinDecimal`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `FinDecimal`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finMultiply` functionality within the `FinDecimalContract` domain.

##### `op finDivide`
```flux
op finDivide (as FinDecimal: a, as FinDecimal: b) as FinDecimal
```
- **Parameters**:
  - `a` (`FinDecimal`): Input argument for operation execution.
  - `b` (`FinDecimal`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `FinDecimal`
  - ⚠️ Emits `fail` with status message `"divisao por zero"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finDivide` functionality within the `FinDecimalContract` domain.

##### `op finRound`
```flux
op finRound (as FinDecimal: val, as int64: decimals, as RoundingMode: mode) as FinDecimal
```
- **Parameters**:
  - `val` (`FinDecimal`): Input argument for operation execution.
  - `decimals` (`int64`): Input argument for operation execution.
  - `mode` (`RoundingMode`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `FinDecimal`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finRound` functionality within the `FinDecimalContract` domain.

##### `op finAbs`
```flux
op finAbs (as FinDecimal: val) as FinDecimal
```
- **Parameters**:
  - `val` (`FinDecimal`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `FinDecimal`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finAbs` functionality within the `FinDecimalContract` domain.

##### `op finNegate`
```flux
op finNegate (as FinDecimal: val) as FinDecimal
```
- **Parameters**:
  - `val` (`FinDecimal`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `FinDecimal`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finNegate` functionality within the `FinDecimalContract` domain.

##### `op finMin`
```flux
op finMin (as FinDecimal: a, as FinDecimal: b) as FinDecimal
```
- **Parameters**:
  - `a` (`FinDecimal`): Input argument for operation execution.
  - `b` (`FinDecimal`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `FinDecimal`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finMin` functionality within the `FinDecimalContract` domain.

##### `op finMax`
```flux
op finMax (as FinDecimal: a, as FinDecimal: b) as FinDecimal
```
- **Parameters**:
  - `a` (`FinDecimal`): Input argument for operation execution.
  - `b` (`FinDecimal`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `FinDecimal`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finMax` functionality within the `FinDecimalContract` domain.

##### `op finClamp`
```flux
op finClamp (as FinDecimal: val, as FinDecimal: min_val, as FinDecimal: max_val) as FinDecimal
```
- **Parameters**:
  - `val` (`FinDecimal`): Input argument for operation execution.
  - `min_val` (`FinDecimal`): Input argument for operation execution.
  - `max_val` (`FinDecimal`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `FinDecimal`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finClamp` functionality within the `FinDecimalContract` domain.

##### `op finSplit`
```flux
op finSplit (as FinDecimal: amount, as int64: parts) as list of data
```
- **Parameters**:
  - `amount` (`FinDecimal`): Input argument for operation execution.
  - `parts` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ⚠️ Emits `fail` with status message `"partes devem ser positivas"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finSplit` functionality within the `FinDecimalContract` domain.

##### `op finAllocate`
```flux
op finAllocate (as FinDecimal: amount, as list of data: weights) as list of data
```
- **Parameters**:
  - `amount` (`FinDecimal`): Input argument for operation execution.
  - `weights` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ⚠️ Emits `fail` with status message `"pesos devem somar mais que zero"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finAllocate` functionality within the `FinDecimalContract` domain.

### 4.4 Contract `FinDepreciationContract` (`FinDepreciation.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `finDepreciationLinear` | `op finDepreciationLinear (as FinDecimal: cost, as FinDecimal: salvage, as int64: life_years) as FinDecimal` | `FinDecimal` |
| `finDepreciationSyd` | `op finDepreciationSyd (as FinDecimal: cost, as FinDecimal: salvage, as int64: life_years, as int64: period) as FinDecimal` | `FinDecimal` |
| `finDepreciationDdb` | `op finDepreciationDdb (as FinDecimal: cost, as FinDecimal: salvage, as int64: life_years, as int64: period) as FinDecimal` | `FinDecimal` |

#### Operation Technical Specifications:

##### `op finDepreciationLinear`
```flux
op finDepreciationLinear (as FinDecimal: cost, as FinDecimal: salvage, as int64: life_years) as FinDecimal
```
- **Parameters**:
  - `cost` (`FinDecimal`): Input argument for operation execution.
  - `salvage` (`FinDecimal`): Input argument for operation execution.
  - `life_years` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `FinDecimal`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finDepreciationLinear` functionality within the `FinDepreciationContract` domain.

##### `op finDepreciationSyd`
```flux
op finDepreciationSyd (as FinDecimal: cost, as FinDecimal: salvage, as int64: life_years, as int64: period) as FinDecimal
```
- **Parameters**:
  - `cost` (`FinDecimal`): Input argument for operation execution.
  - `salvage` (`FinDecimal`): Input argument for operation execution.
  - `life_years` (`int64`): Input argument for operation execution.
  - `period` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `FinDecimal`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finDepreciationSyd` functionality within the `FinDepreciationContract` domain.

##### `op finDepreciationDdb`
```flux
op finDepreciationDdb (as FinDecimal: cost, as FinDecimal: salvage, as int64: life_years, as int64: period) as FinDecimal
```
- **Parameters**:
  - `cost` (`FinDecimal`): Input argument for operation execution.
  - `salvage` (`FinDecimal`): Input argument for operation execution.
  - `life_years` (`int64`): Input argument for operation execution.
  - `period` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `FinDecimal`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finDepreciationDdb` functionality within the `FinDepreciationContract` domain.

### 4.5 Contract `FinFormatContract` (`FinFormat.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `finFormatCurrency` | `op finFormatCurrency (as FinDecimal: value, as string: locale) as string` | `string` |
| `finFormatPercent` | `op finFormatPercent (as float64: rate, as int64: decimals) as string` | `string` |
| `finParseCurrency` | `op finParseCurrency (as string: text) as FinDecimal` | `FinDecimal` |

#### Operation Technical Specifications:

##### `op finFormatCurrency`
```flux
op finFormatCurrency (as FinDecimal: value, as string: locale) as string
```
- **Parameters**:
  - `value` (`FinDecimal`): Input argument for operation execution.
  - `locale` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finFormatCurrency` functionality within the `FinFormatContract` domain.

##### `op finFormatPercent`
```flux
op finFormatPercent (as float64: rate, as int64: decimals) as string
```
- **Parameters**:
  - `rate` (`float64`): Input argument for operation execution.
  - `decimals` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finFormatPercent` functionality within the `FinFormatContract` domain.

##### `op finParseCurrency`
```flux
op finParseCurrency (as string: text) as FinDecimal
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `FinDecimal`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finParseCurrency` functionality within the `FinFormatContract` domain.

### 4.6 Contract `FinRateContract` (`FinRate.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `finEffectiveRate` | `op finEffectiveRate (as float64: nominal_rate, as int64: compounding_periods) as float64` | `float64` |
| `finNominalRate` | `op finNominalRate (as float64: effective_rate, as int64: compounding_periods) as float64` | `float64` |
| `finConvertRate` | `op finConvertRate (as float64: rate, as int64: from_periods, as int64: to_periods) as float64` | `float64` |
| `finRateEquivalent` | `op finRateEquivalent (as float64: rate, as float64: target_period, as float64: base_period) as float64` | `float64` |
| `finMonthlyToDailyRate` | `op finMonthlyToDailyRate (as float64: monthly_rate, as int64: days_in_month) as float64` | `float64` |
| `finMonthlyToAnnualRate` | `op finMonthlyToAnnualRate (as float64: monthly_rate) as float64` | `float64` |
| `finAnnualToDailyRate` | `op finAnnualToDailyRate (as float64: annual_rate, as int64: days_in_year) as float64` | `float64` |
| `finAnnualToMonthlyRate` | `op finAnnualToMonthlyRate (as float64: annual_rate) as float64` | `float64` |
| `finDailyToMonthlyRate` | `op finDailyToMonthlyRate (as float64: daily_rate, as int64: days_in_month) as float64` | `float64` |
| `finDailyToAnnualRate` | `op finDailyToAnnualRate (as float64: daily_rate, as int64: days_in_year) as float64` | `float64` |
| `finRealRate` | `op finRealRate (as float64: nominal_rate, as float64: inflation_rate) as float64` | `float64` |
| `finContinuousCompounding` | `op finContinuousCompounding (as FinDecimal: principal, as float64: rate, as float64: periods) as FinDecimal` | `FinDecimal` |

#### Operation Technical Specifications:

##### `op finEffectiveRate`
```flux
op finEffectiveRate (as float64: nominal_rate, as int64: compounding_periods) as float64
```
- **Parameters**:
  - `nominal_rate` (`float64`): Input argument for operation execution.
  - `compounding_periods` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finEffectiveRate` functionality within the `FinRateContract` domain.

##### `op finNominalRate`
```flux
op finNominalRate (as float64: effective_rate, as int64: compounding_periods) as float64
```
- **Parameters**:
  - `effective_rate` (`float64`): Input argument for operation execution.
  - `compounding_periods` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finNominalRate` functionality within the `FinRateContract` domain.

##### `op finConvertRate`
```flux
op finConvertRate (as float64: rate, as int64: from_periods, as int64: to_periods) as float64
```
- **Parameters**:
  - `rate` (`float64`): Input argument for operation execution.
  - `from_periods` (`int64`): Input argument for operation execution.
  - `to_periods` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finConvertRate` functionality within the `FinRateContract` domain.

##### `op finRateEquivalent`
```flux
op finRateEquivalent (as float64: rate, as float64: target_period, as float64: base_period) as float64
```
- **Parameters**:
  - `rate` (`float64`): Input argument for operation execution.
  - `target_period` (`float64`): Input argument for operation execution.
  - `base_period` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ⚠️ Emits `fail` with status message `"Periodo base invalido ou taxa menor que -100%"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finRateEquivalent` functionality within the `FinRateContract` domain.

##### `op finMonthlyToDailyRate`
```flux
op finMonthlyToDailyRate (as float64: monthly_rate, as int64: days_in_month) as float64
```
- **Parameters**:
  - `monthly_rate` (`float64`): Input argument for operation execution.
  - `days_in_month` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finMonthlyToDailyRate` functionality within the `FinRateContract` domain.

##### `op finMonthlyToAnnualRate`
```flux
op finMonthlyToAnnualRate (as float64: monthly_rate) as float64
```
- **Parameters**:
  - `monthly_rate` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finMonthlyToAnnualRate` functionality within the `FinRateContract` domain.

##### `op finAnnualToDailyRate`
```flux
op finAnnualToDailyRate (as float64: annual_rate, as int64: days_in_year) as float64
```
- **Parameters**:
  - `annual_rate` (`float64`): Input argument for operation execution.
  - `days_in_year` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finAnnualToDailyRate` functionality within the `FinRateContract` domain.

##### `op finAnnualToMonthlyRate`
```flux
op finAnnualToMonthlyRate (as float64: annual_rate) as float64
```
- **Parameters**:
  - `annual_rate` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finAnnualToMonthlyRate` functionality within the `FinRateContract` domain.

##### `op finDailyToMonthlyRate`
```flux
op finDailyToMonthlyRate (as float64: daily_rate, as int64: days_in_month) as float64
```
- **Parameters**:
  - `daily_rate` (`float64`): Input argument for operation execution.
  - `days_in_month` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finDailyToMonthlyRate` functionality within the `FinRateContract` domain.

##### `op finDailyToAnnualRate`
```flux
op finDailyToAnnualRate (as float64: daily_rate, as int64: days_in_year) as float64
```
- **Parameters**:
  - `daily_rate` (`float64`): Input argument for operation execution.
  - `days_in_year` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finDailyToAnnualRate` functionality within the `FinRateContract` domain.

##### `op finRealRate`
```flux
op finRealRate (as float64: nominal_rate, as float64: inflation_rate) as float64
```
- **Parameters**:
  - `nominal_rate` (`float64`): Input argument for operation execution.
  - `inflation_rate` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finRealRate` functionality within the `FinRateContract` domain.

##### `op finContinuousCompounding`
```flux
op finContinuousCompounding (as FinDecimal: principal, as float64: rate, as float64: periods) as FinDecimal
```
- **Parameters**:
  - `principal` (`FinDecimal`): Input argument for operation execution.
  - `rate` (`float64`): Input argument for operation execution.
  - `periods` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `FinDecimal`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finContinuousCompounding` functionality within the `FinRateContract` domain.

### 4.7 Contract `FinTimeValueOfMoneyContract` (`FinTimeValueOfMoney.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `finSimpleInterest` | `op finSimpleInterest (as FinDecimal: principal, as float64: rate, as int64: periods) as FinDecimal` | `FinDecimal` |
| `finCompoundInterest` | `op finCompoundInterest (as FinDecimal: principal, as float64: rate, as int64: periods) as FinDecimal` | `FinDecimal` |
| `finPresentValue` | `op finPresentValue (as FinDecimal: future_value, as float64: rate, as int64: periods) as FinDecimal` | `FinDecimal` |
| `finFutureValue` | `op finFutureValue (as FinDecimal: present_value, as float64: rate, as int64: periods) as FinDecimal` | `FinDecimal` |
| `finAnnuityPayment` | `op finAnnuityPayment (as FinDecimal: principal, as float64: rate, as int64: periods) as FinDecimal` | `FinDecimal` |
| `finFutureValueOfAnnuity` | `op finFutureValueOfAnnuity (as FinDecimal: payment, as float64: rate, as int64: periods) as FinDecimal` | `FinDecimal` |
| `finPresentValueOfAnnuity` | `op finPresentValueOfAnnuity (as FinDecimal: payment, as float64: rate, as int64: periods) as FinDecimal` | `FinDecimal` |
| `finNetPresentValue` | `op finNetPresentValue (as float64: discount_rate, as list of data: cash_flows) as float64` | `float64` |
| `finInternalRateOfReturn` | `op finInternalRateOfReturn (as list of data: cash_flows) as float64` | `float64` |
| `finPaybackPeriod` | `op finPaybackPeriod (as FinDecimal: initial_investment, as list of data: cash_flows) as float64` | `float64` |
| `finDiscountedPayback` | `op finDiscountedPayback (as FinDecimal: initial_investment, as float64: discount_rate, as list of data: cash_flows) as float64` | `float64` |
| `finProfitabilityIndex` | `op finProfitabilityIndex (as FinDecimal: initial_investment, as float64: discount_rate, as list of data: cash_flows) as float64` | `float64` |

#### Operation Technical Specifications:

##### `op finSimpleInterest`
```flux
op finSimpleInterest (as FinDecimal: principal, as float64: rate, as int64: periods) as FinDecimal
```
- **Parameters**:
  - `principal` (`FinDecimal`): Input argument for operation execution.
  - `rate` (`float64`): Input argument for operation execution.
  - `periods` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `FinDecimal`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finSimpleInterest` functionality within the `FinTimeValueOfMoneyContract` domain.

##### `op finCompoundInterest`
```flux
op finCompoundInterest (as FinDecimal: principal, as float64: rate, as int64: periods) as FinDecimal
```
- **Parameters**:
  - `principal` (`FinDecimal`): Input argument for operation execution.
  - `rate` (`float64`): Input argument for operation execution.
  - `periods` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `FinDecimal`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finCompoundInterest` functionality within the `FinTimeValueOfMoneyContract` domain.

##### `op finPresentValue`
```flux
op finPresentValue (as FinDecimal: future_value, as float64: rate, as int64: periods) as FinDecimal
```
- **Parameters**:
  - `future_value` (`FinDecimal`): Input argument for operation execution.
  - `rate` (`float64`): Input argument for operation execution.
  - `periods` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `FinDecimal`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finPresentValue` functionality within the `FinTimeValueOfMoneyContract` domain.

##### `op finFutureValue`
```flux
op finFutureValue (as FinDecimal: present_value, as float64: rate, as int64: periods) as FinDecimal
```
- **Parameters**:
  - `present_value` (`FinDecimal`): Input argument for operation execution.
  - `rate` (`float64`): Input argument for operation execution.
  - `periods` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `FinDecimal`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finFutureValue` functionality within the `FinTimeValueOfMoneyContract` domain.

##### `op finAnnuityPayment`
```flux
op finAnnuityPayment (as FinDecimal: principal, as float64: rate, as int64: periods) as FinDecimal
```
- **Parameters**:
  - `principal` (`FinDecimal`): Input argument for operation execution.
  - `rate` (`float64`): Input argument for operation execution.
  - `periods` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `FinDecimal`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finAnnuityPayment` functionality within the `FinTimeValueOfMoneyContract` domain.

##### `op finFutureValueOfAnnuity`
```flux
op finFutureValueOfAnnuity (as FinDecimal: payment, as float64: rate, as int64: periods) as FinDecimal
```
- **Parameters**:
  - `payment` (`FinDecimal`): Input argument for operation execution.
  - `rate` (`float64`): Input argument for operation execution.
  - `periods` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `FinDecimal`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finFutureValueOfAnnuity` functionality within the `FinTimeValueOfMoneyContract` domain.

##### `op finPresentValueOfAnnuity`
```flux
op finPresentValueOfAnnuity (as FinDecimal: payment, as float64: rate, as int64: periods) as FinDecimal
```
- **Parameters**:
  - `payment` (`FinDecimal`): Input argument for operation execution.
  - `rate` (`float64`): Input argument for operation execution.
  - `periods` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `FinDecimal`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finPresentValueOfAnnuity` functionality within the `FinTimeValueOfMoneyContract` domain.

##### `op finNetPresentValue`
```flux
op finNetPresentValue (as float64: discount_rate, as list of data: cash_flows) as float64
```
- **Parameters**:
  - `discount_rate` (`float64`): Input argument for operation execution.
  - `cash_flows` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finNetPresentValue` functionality within the `FinTimeValueOfMoneyContract` domain.

##### `op finInternalRateOfReturn`
```flux
op finInternalRateOfReturn (as list of data: cash_flows) as float64
```
- **Parameters**:
  - `cash_flows` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finInternalRateOfReturn` functionality within the `FinTimeValueOfMoneyContract` domain.

##### `op finPaybackPeriod`
```flux
op finPaybackPeriod (as FinDecimal: initial_investment, as list of data: cash_flows) as float64
```
- **Parameters**:
  - `initial_investment` (`FinDecimal`): Input argument for operation execution.
  - `cash_flows` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finPaybackPeriod` functionality within the `FinTimeValueOfMoneyContract` domain.

##### `op finDiscountedPayback`
```flux
op finDiscountedPayback (as FinDecimal: initial_investment, as float64: discount_rate, as list of data: cash_flows) as float64
```
- **Parameters**:
  - `initial_investment` (`FinDecimal`): Input argument for operation execution.
  - `discount_rate` (`float64`): Input argument for operation execution.
  - `cash_flows` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finDiscountedPayback` functionality within the `FinTimeValueOfMoneyContract` domain.

##### `op finProfitabilityIndex`
```flux
op finProfitabilityIndex (as FinDecimal: initial_investment, as float64: discount_rate, as list of data: cash_flows) as float64
```
- **Parameters**:
  - `initial_investment` (`FinDecimal`): Input argument for operation execution.
  - `discount_rate` (`float64`): Input argument for operation execution.
  - `cash_flows` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `finProfitabilityIndex` functionality within the `FinTimeValueOfMoneyContract` domain.

---

## 5. Canonical Usage Examples in TheFlux

The following snippet illustrates importing and utilizing the library in a TheFlux program:

```flux
# Canonical Usage Example for FinStdLib
use FinStdLib

program (ExampleOfFinStdLib) {
      println("==================================================")
      println("  Standard Library Demonstration: FinStdLib")
      println("==================================================")

      # Invoking canonical operation
      mut as data: result = FinStdLib::finCompoundInterest(1000.0, 0.05, 12)
      println("Obtained result: " + result)

      println("Execution completed successfully.")
}
```

---

> [!TIP]
> For the complete unified architecture across all standard libraries, consult the master [StdLibs.md](../StdLibs.md) reference.
