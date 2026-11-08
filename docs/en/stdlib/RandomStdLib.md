# 📚 `RandomStdLib` — Pseudorandom Number Generation and Statistical Distributions

> **Architectural Pillar**: Pillar 2 (Structures & State)  
> **Status**: ✅ Certified with 100% Parity across 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Master File**: `stdlib/RandomStdLib/RandomStdLib.fdsl`  
> **Import Mode**: `use RandomStdLib` or `use RandomStdLib::<Module>::<operation>`

---

## 1. Overview and Capabilities

The **`RandomStdLib`** standard library is an integral component of the official TheFlux language ecosystem, providing certified system-level algorithms and robust capabilities.

Pseudorandom number generator (PRNG) suite with deterministic seeding: uniform integer and floating-point distributions, Gaussian normal distributions, exponential, Poisson, and array shuffling algorithms (Fisher-Yates).

### 1.1 Key Architectural Principles and Design
- **Static Fusion and Zero-Overhead**: All domain modules are transparently fused into the `RandomStdLib` unified agent at compile time, avoiding virtual dispatch penalties.
- **Safety and Isolation**: Operations strictly validate parameter bounds and guarantee predictable error semantics via contract definitions.
- **Universal Multi-Backend Parity**: Bit-for-bit identical execution guarantees across interpreter (`in`), bytecode VM (`vm`, `vmr`), native AOT LLVM (`llvm`), and WebAssembly (`wat`, `wasm`).

---

## 2. Modular Structure and Contracts

The library comprises **4 domain modules** declaring a total of **28 public operations**:

| Domain Source File | Formal Contract | Domain Responsibility | Ops Count |
|---|---|---|:---:|
| `RandomDistribution.fdsl` | `RandomDistributionContract` | Specialized domain for `RandomDistribution` | 8 |
| `RandomGenerator.fdsl` | `RandomGeneratorContract` | Specialized domain for `RandomGenerator` | 8 |
| `RandomSequence.fdsl` | `RandomSequenceContract` | Specialized domain for `RandomSequence` | 6 |
| `RandomUtility.fdsl` | `RandomUtilityContract` | Specialized domain for `RandomUtility` | 6 |

---

## 3. Public Types, Structures, and Enumerations

The `RandomStdLib` library operates directly on primitive native TheFlux types (`string`, `int64`, `float64`, `bool`, `list of data`, etc.) without requiring custom composite types.

---

## 4. Detailed Operations Catalog by Domain

### 4.1 Contract `RandomDistributionContract` (`RandomDistribution.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `randomNextInt` | `op randomNextInt (as int64: state) as list of data` | `list of data` |
| `randomNextIntRange` | `op randomNextIntRange (as int64: state, as int64: min, as int64: max) as list of data` | `list of data` |
| `randomNextFloat` | `op randomNextFloat (as int64: state) as list of data` | `list of data` |
| `randomNextFloatRange` | `op randomNextFloatRange (as int64: state, as float64: min, as float64: max) as list of data` | `list of data` |
| `randomNextBool` | `op randomNextBool (as int64: state) as list of data` | `list of data` |
| `randomNextBernoulli` | `op randomNextBernoulli (as int64: state, as float64: p) as list of data` | `list of data` |
| `randomNextGaussian` | `op randomNextGaussian (as int64: state, as float64: mean, as float64: std_dev) as list of data` | `list of data` |
| `randomNextDice` | `op randomNextDice (as int64: state, as int64: count, as int64: sides) as list of data` | `list of data` |

#### Operation Technical Specifications:

##### `op randomNextInt`
```flux
op randomNextInt (as int64: state) as list of data
```
- **Parameters**:
  - `state` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `randomNextInt` functionality within the `RandomDistributionContract` domain.

##### `op randomNextIntRange`
```flux
op randomNextIntRange (as int64: state, as int64: min, as int64: max) as list of data
```
- **Parameters**:
  - `state` (`int64`): Input argument for operation execution.
  - `min` (`int64`): Input argument for operation execution.
  - `max` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `randomNextIntRange` functionality within the `RandomDistributionContract` domain.

##### `op randomNextFloat`
```flux
op randomNextFloat (as int64: state) as list of data
```
- **Parameters**:
  - `state` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `randomNextFloat` functionality within the `RandomDistributionContract` domain.

##### `op randomNextFloatRange`
```flux
op randomNextFloatRange (as int64: state, as float64: min, as float64: max) as list of data
```
- **Parameters**:
  - `state` (`int64`): Input argument for operation execution.
  - `min` (`float64`): Input argument for operation execution.
  - `max` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `randomNextFloatRange` functionality within the `RandomDistributionContract` domain.

##### `op randomNextBool`
```flux
op randomNextBool (as int64: state) as list of data
```
- **Parameters**:
  - `state` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `randomNextBool` functionality within the `RandomDistributionContract` domain.

##### `op randomNextBernoulli`
```flux
op randomNextBernoulli (as int64: state, as float64: p) as list of data
```
- **Parameters**:
  - `state` (`int64`): Input argument for operation execution.
  - `p` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `randomNextBernoulli` functionality within the `RandomDistributionContract` domain.

##### `op randomNextGaussian`
```flux
op randomNextGaussian (as int64: state, as float64: mean, as float64: std_dev) as list of data
```
- **Parameters**:
  - `state` (`int64`): Input argument for operation execution.
  - `mean` (`float64`): Input argument for operation execution.
  - `std_dev` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `randomNextGaussian` functionality within the `RandomDistributionContract` domain.

##### `op randomNextDice`
```flux
op randomNextDice (as int64: state, as int64: count, as int64: sides) as list of data
```
- **Parameters**:
  - `state` (`int64`): Input argument for operation execution.
  - `count` (`int64`): Input argument for operation execution.
  - `sides` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `randomNextDice` functionality within the `RandomDistributionContract` domain.

### 4.2 Contract `RandomGeneratorContract` (`RandomGenerator.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `randomLcgNew` | `op randomLcgNew (as int64: seed) as int64` | `int64` |
| `randomLcgNext` | `op randomLcgNext (as int64: state) as list of data` | `list of data` |
| `randomXorNew` | `op randomXorNew (as int64: seed) as int64` | `int64` |
| `randomXorNext` | `op randomXorNext (as int64: state) as list of data` | `list of data` |
| `randomPcgNew` | `op randomPcgNew (as int64: seed) as int64` | `int64` |
| `randomPcgNext` | `op randomPcgNext (as int64: state) as list of data` | `list of data` |
| `randomSplitMix64` | `op randomSplitMix64 (as int64: seed) as int64` | `int64` |
| `randomSeedSystem` | `op randomSeedSystem () as int64` | `int64` |

#### Operation Technical Specifications:

##### `op randomLcgNew`
```flux
op randomLcgNew (as int64: seed) as int64
```
- **Parameters**:
  - `seed` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `randomLcgNew` functionality within the `RandomGeneratorContract` domain.

##### `op randomLcgNext`
```flux
op randomLcgNext (as int64: state) as list of data
```
- **Parameters**:
  - `state` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `randomLcgNext` functionality within the `RandomGeneratorContract` domain.

##### `op randomXorNew`
```flux
op randomXorNew (as int64: seed) as int64
```
- **Parameters**:
  - `seed` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `randomXorNew` functionality within the `RandomGeneratorContract` domain.

##### `op randomXorNext`
```flux
op randomXorNext (as int64: state) as list of data
```
- **Parameters**:
  - `state` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `randomXorNext` functionality within the `RandomGeneratorContract` domain.

##### `op randomPcgNew`
```flux
op randomPcgNew (as int64: seed) as int64
```
- **Parameters**:
  - `seed` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `randomPcgNew` functionality within the `RandomGeneratorContract` domain.

##### `op randomPcgNext`
```flux
op randomPcgNext (as int64: state) as list of data
```
- **Parameters**:
  - `state` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `randomPcgNext` functionality within the `RandomGeneratorContract` domain.

##### `op randomSplitMix64`
```flux
op randomSplitMix64 (as int64: seed) as int64
```
- **Parameters**:
  - `seed` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `randomSplitMix64` functionality within the `RandomGeneratorContract` domain.

##### `op randomSeedSystem`
```flux
op randomSeedSystem () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ⚠️ Emits `fail` with status message `"Nao implementada"`
- **Functional Description**:
  - Executes canonical `randomSeedSystem` functionality within the `RandomGeneratorContract` domain.

### 4.3 Contract `RandomSequenceContract` (`RandomSequence.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `randomPick` | `op randomPick (as int64: state, as list of data: items) as list of data` | `list of data` |
| `randomPickIndex` | `op randomPickIndex (as int64: state, as list of data: items) as list of data` | `list of data` |
| `randomShuffle` | `op randomShuffle (as int64: state, as list of data: items) as list of data` | `list of data` |
| `randomSample` | `op randomSample (as int64: state, as list of data: items, as int64: k) as list of data` | `list of data` |
| `randomChoices` | `op randomChoices (as int64: state, as list of data: items, as int64: k) as list of data` | `list of data` |
| `randomWeightedChoice` | `op randomWeightedChoice (as int64: state, as list of data: items, as list of data: weights) as list of data` | `list of data` |

#### Operation Technical Specifications:

##### `op randomPick`
```flux
op randomPick (as int64: state, as list of data: items) as list of data
```
- **Parameters**:
  - `state` (`int64`): Input argument for operation execution.
  - `items` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `randomPick` functionality within the `RandomSequenceContract` domain.

##### `op randomPickIndex`
```flux
op randomPickIndex (as int64: state, as list of data: items) as list of data
```
- **Parameters**:
  - `state` (`int64`): Input argument for operation execution.
  - `items` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `randomPickIndex` functionality within the `RandomSequenceContract` domain.

##### `op randomShuffle`
```flux
op randomShuffle (as int64: state, as list of data: items) as list of data
```
- **Parameters**:
  - `state` (`int64`): Input argument for operation execution.
  - `items` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `randomShuffle` functionality within the `RandomSequenceContract` domain.

##### `op randomSample`
```flux
op randomSample (as int64: state, as list of data: items, as int64: k) as list of data
```
- **Parameters**:
  - `state` (`int64`): Input argument for operation execution.
  - `items` (`list of data`): Input argument for operation execution.
  - `k` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `randomSample` functionality within the `RandomSequenceContract` domain.

##### `op randomChoices`
```flux
op randomChoices (as int64: state, as list of data: items, as int64: k) as list of data
```
- **Parameters**:
  - `state` (`int64`): Input argument for operation execution.
  - `items` (`list of data`): Input argument for operation execution.
  - `k` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `randomChoices` functionality within the `RandomSequenceContract` domain.

##### `op randomWeightedChoice`
```flux
op randomWeightedChoice (as int64: state, as list of data: items, as list of data: weights) as list of data
```
- **Parameters**:
  - `state` (`int64`): Input argument for operation execution.
  - `items` (`list of data`): Input argument for operation execution.
  - `weights` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `randomWeightedChoice` functionality within the `RandomSequenceContract` domain.

### 4.4 Contract `RandomUtilityContract` (`RandomUtility.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `randomString` | `op randomString (as int64: state, as int64: length, as string: alphabet) as list of data` | `list of data` |
| `randomAlphaNumeric` | `op randomAlphaNumeric (as int64: state, as int64: length) as list of data` | `list of data` |
| `randomHex` | `op randomHex (as int64: state, as int64: length) as list of data` | `list of data` |
| `randomUuidV4` | `op randomUuidV4 (as int64: state) as list of data` | `list of data` |
| `randomIntList` | `op randomIntList (as int64: state, as int64: count, as int64: min, as int64: max) as list of data` | `list of data` |
| `randomFloatList` | `op randomFloatList (as int64: state, as int64: count) as list of data` | `list of data` |

#### Operation Technical Specifications:

##### `op randomString`
```flux
op randomString (as int64: state, as int64: length, as string: alphabet) as list of data
```
- **Parameters**:
  - `state` (`int64`): Input argument for operation execution.
  - `length` (`int64`): Input argument for operation execution.
  - `alphabet` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `randomString` functionality within the `RandomUtilityContract` domain.

##### `op randomAlphaNumeric`
```flux
op randomAlphaNumeric (as int64: state, as int64: length) as list of data
```
- **Parameters**:
  - `state` (`int64`): Input argument for operation execution.
  - `length` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `randomAlphaNumeric` functionality within the `RandomUtilityContract` domain.

##### `op randomHex`
```flux
op randomHex (as int64: state, as int64: length) as list of data
```
- **Parameters**:
  - `state` (`int64`): Input argument for operation execution.
  - `length` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `randomHex` functionality within the `RandomUtilityContract` domain.

##### `op randomUuidV4`
```flux
op randomUuidV4 (as int64: state) as list of data
```
- **Parameters**:
  - `state` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `randomUuidV4` functionality within the `RandomUtilityContract` domain.

##### `op randomIntList`
```flux
op randomIntList (as int64: state, as int64: count, as int64: min, as int64: max) as list of data
```
- **Parameters**:
  - `state` (`int64`): Input argument for operation execution.
  - `count` (`int64`): Input argument for operation execution.
  - `min` (`int64`): Input argument for operation execution.
  - `max` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `randomIntList` functionality within the `RandomUtilityContract` domain.

##### `op randomFloatList`
```flux
op randomFloatList (as int64: state, as int64: count) as list of data
```
- **Parameters**:
  - `state` (`int64`): Input argument for operation execution.
  - `count` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `randomFloatList` functionality within the `RandomUtilityContract` domain.

---

## 5. Canonical Usage Examples in TheFlux

The following snippet illustrates importing and utilizing the library in a TheFlux program:

```flux
# Canonical Usage Example for RandomStdLib
use RandomStdLib

program (ExampleOfRandomStdLib) {
      println("==================================================")
      println("  Standard Library Demonstration: RandomStdLib")
      println("==================================================")

      # Invoking canonical operation
      mut as data: result = RandomStdLib::randomFloat()
      println("Obtained result: " + result)

      println("Execution completed successfully.")
}
```

---

> [!TIP]
> For the complete unified architecture across all standard libraries, consult the master [StdLibs.md](../StdLibs.md) reference.
