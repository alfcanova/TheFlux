# 📚 `PhysStdLib` — Computational Physics, Physical Constants, Mechanics, and Thermodynamics

> **Architectural Pillar**: Pillar 3 (Mathematics & Graphics)  
> **Status**: ✅ Certified with 100% Parity across 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Master File**: `stdlib/PhysStdLib/PhysStdLib.fdsl`  
> **Import Mode**: `use PhysStdLib` or `use PhysStdLib::<Module>::<operation>`

---

## 1. Overview and Capabilities

The **`PhysStdLib`** standard library is an integral component of the official TheFlux language ecosystem, providing certified system-level algorithms and robust capabilities.

Precision modeling of physical systems: CODATA universal constants, classical Newtonian mechanics and kinematics, fluid mechanics, thermodynamics equations, Maxwell electromagnetism, astrophysics, and special relativity calculations.

### 1.1 Key Architectural Principles and Design
- **Static Fusion and Zero-Overhead**: All domain modules are transparently fused into the `PhysStdLib` unified agent at compile time, avoiding virtual dispatch penalties.
- **Safety and Isolation**: Operations strictly validate parameter bounds and guarantee predictable error semantics via contract definitions.
- **Universal Multi-Backend Parity**: Bit-for-bit identical execution guarantees across interpreter (`in`), bytecode VM (`vm`, `vmr`), native AOT LLVM (`llvm`), and WebAssembly (`wat`, `wasm`).

---

## 2. Modular Structure and Contracts

The library comprises **10 domain modules** declaring a total of **136 public operations**:

| Domain Source File | Formal Contract | Domain Responsibility | Ops Count |
|---|---|---|:---:|
| `PhysAstrophysics.fdsl` | `PhysAstrophysicsContract` | Specialized domain for `PhysAstrophysics` | 5 |
| `PhysConstants.fdsl` | `PhysConstantsContract` | Specialized domain for `PhysConstants` | 63 |
| `PhysDynamics.fdsl` | `PhysDynamicsContract` | Specialized domain for `PhysDynamics` | 8 |
| `PhysElectromagnetism.fdsl` | `PhysElectromagnetismContract` | Specialized domain for `PhysElectromagnetism` | 7 |
| `PhysEnergy.fdsl` | `PhysEnergyContract` | Specialized domain for `PhysEnergy` | 7 |
| `PhysKinematics.fdsl` | `PhysKinematicsContract` | Specialized domain for `PhysKinematics` | 9 |
| `PhysQuantumRelativity.fdsl` | `PhysQuantumRelativityContract` | Specialized domain for `PhysQuantumRelativity` | 6 |
| `PhysRigidBody2D.fdsl` | `PhysRigidBody2DContract` | Specialized domain for `PhysRigidBody2D` | 10 |
| `PhysThermodynamicsAndWaves.fdsl` | `PhysThermodynamicsAndWavesContract` | Specialized domain for `PhysThermodynamicsAndWaves` | 10 |
| `PhysVector2D.fdsl` | `PhysVector2DContract` | Specialized domain for `PhysVector2D` | 11 |

---

## 3. Public Types, Structures, and Enumerations

The `PhysStdLib` library operates directly on primitive native TheFlux types (`string`, `int64`, `float64`, `bool`, `list of data`, etc.) without requiring custom composite types.

---

## 4. Detailed Operations Catalog by Domain

### 4.1 Contract `PhysAstrophysicsContract` (`PhysAstrophysics.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `physGravitationalForce` | `op physGravitationalForce (as float64: m1, as float64: m2, as float64: distance) as float64` | `float64` |
| `physGravitationalPotentialEnergy` | `op physGravitationalPotentialEnergy (as float64: m1, as float64: m2, as float64: distance) as float64` | `float64` |
| `physEscapeVelocity` | `op physEscapeVelocity (as float64: mass, as float64: radius) as float64` | `float64` |
| `physOrbitalVelocity` | `op physOrbitalVelocity (as float64: mass, as float64: radius) as float64` | `float64` |
| `physKeplerPeriod` | `op physKeplerPeriod (as float64: semi_major_axis, as float64: central_mass) as float64` | `float64` |

#### Operation Technical Specifications:

##### `op physGravitationalForce`
```flux
op physGravitationalForce (as float64: m1, as float64: m2, as float64: distance) as float64
```
- **Parameters**:
  - `m1` (`float64`): Input argument for operation execution.
  - `m2` (`float64`): Input argument for operation execution.
  - `distance` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ⚠️ Emits `fail` with status message `"distancia invalida em gravitacao"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physGravitationalForce` functionality within the `PhysAstrophysicsContract` domain.

##### `op physGravitationalPotentialEnergy`
```flux
op physGravitationalPotentialEnergy (as float64: m1, as float64: m2, as float64: distance) as float64
```
- **Parameters**:
  - `m1` (`float64`): Input argument for operation execution.
  - `m2` (`float64`): Input argument for operation execution.
  - `distance` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ⚠️ Emits `fail` with status message `"distancia invalida em potencial gravitacional"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physGravitationalPotentialEnergy` functionality within the `PhysAstrophysicsContract` domain.

##### `op physEscapeVelocity`
```flux
op physEscapeVelocity (as float64: mass, as float64: radius) as float64
```
- **Parameters**:
  - `mass` (`float64`): Input argument for operation execution.
  - `radius` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ⚠️ Emits `fail` with status message `"massa ou raio invalido em velocidade de escape"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physEscapeVelocity` functionality within the `PhysAstrophysicsContract` domain.

##### `op physOrbitalVelocity`
```flux
op physOrbitalVelocity (as float64: mass, as float64: radius) as float64
```
- **Parameters**:
  - `mass` (`float64`): Input argument for operation execution.
  - `radius` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ⚠️ Emits `fail` with status message `"massa ou raio invalido em velocidade orbital"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physOrbitalVelocity` functionality within the `PhysAstrophysicsContract` domain.

##### `op physKeplerPeriod`
```flux
op physKeplerPeriod (as float64: semi_major_axis, as float64: central_mass) as float64
```
- **Parameters**:
  - `semi_major_axis` (`float64`): Input argument for operation execution.
  - `central_mass` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ⚠️ Emits `fail` with status message `"eixo ou massa invalida em Kepler"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physKeplerPeriod` functionality within the `PhysAstrophysicsContract` domain.

### 4.2 Contract `PhysConstantsContract` (`PhysConstants.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `speedOfLight64` | `op speedOfLight64 () as float64` | `float64` |
| `speedOfLight32` | `op speedOfLight32 () as float32` | `float32` |
| `speedOfLight16` | `op speedOfLight16 () as float16` | `float16` |
| `gravitationalConstant64` | `op gravitationalConstant64 () as float64` | `float64` |
| `gravitationalConstant32` | `op gravitationalConstant32 () as float32` | `float32` |
| `gravitationalConstant16` | `op gravitationalConstant16 () as float16` | `float16` |
| `standardGravity64` | `op standardGravity64 () as float64` | `float64` |
| `standardGravity32` | `op standardGravity32 () as float32` | `float32` |
| `standardGravity16` | `op standardGravity16 () as float16` | `float16` |
| `planckConstant64` | `op planckConstant64 () as float64` | `float64` |
| `planckConstant32` | `op planckConstant32 () as float32` | `float32` |
| `planckConstant16` | `op planckConstant16 () as float16` | `float16` |
| `reducedPlanckConstant64` | `op reducedPlanckConstant64 () as float64` | `float64` |
| `reducedPlanckConstant32` | `op reducedPlanckConstant32 () as float32` | `float32` |
| `reducedPlanckConstant16` | `op reducedPlanckConstant16 () as float16` | `float16` |
| `elementaryCharge64` | `op elementaryCharge64 () as float64` | `float64` |
| `elementaryCharge32` | `op elementaryCharge32 () as float32` | `float32` |
| `elementaryCharge16` | `op elementaryCharge16 () as float16` | `float16` |
| `boltzmannConstant64` | `op boltzmannConstant64 () as float64` | `float64` |
| `boltzmannConstant32` | `op boltzmannConstant32 () as float32` | `float32` |
| `boltzmannConstant16` | `op boltzmannConstant16 () as float16` | `float16` |
| `avogadroNumber64` | `op avogadroNumber64 () as float64` | `float64` |
| `avogadroNumber32` | `op avogadroNumber32 () as float32` | `float32` |
| `avogadroNumber16` | `op avogadroNumber16 () as float16` | `float16` |
| `gasConstant64` | `op gasConstant64 () as float64` | `float64` |
| `gasConstant32` | `op gasConstant32 () as float32` | `float32` |
| `gasConstant16` | `op gasConstant16 () as float16` | `float16` |
| `vacuumPermittivity64` | `op vacuumPermittivity64 () as float64` | `float64` |
| `vacuumPermittivity32` | `op vacuumPermittivity32 () as float32` | `float32` |
| `vacuumPermittivity16` | `op vacuumPermittivity16 () as float16` | `float16` |
| `vacuumPermeability64` | `op vacuumPermeability64 () as float64` | `float64` |
| `vacuumPermeability32` | `op vacuumPermeability32 () as float32` | `float32` |
| `vacuumPermeability16` | `op vacuumPermeability16 () as float16` | `float16` |
| `coulombConstant64` | `op coulombConstant64 () as float64` | `float64` |
| `coulombConstant32` | `op coulombConstant32 () as float32` | `float32` |
| `coulombConstant16` | `op coulombConstant16 () as float16` | `float16` |
| `electronMass64` | `op electronMass64 () as float64` | `float64` |
| `electronMass32` | `op electronMass32 () as float32` | `float32` |
| `electronMass16` | `op electronMass16 () as float16` | `float16` |
| `protonMass64` | `op protonMass64 () as float64` | `float64` |
| `protonMass32` | `op protonMass32 () as float32` | `float32` |
| `protonMass16` | `op protonMass16 () as float16` | `float16` |
| `neutronMass64` | `op neutronMass64 () as float64` | `float64` |
| `neutronMass32` | `op neutronMass32 () as float32` | `float32` |
| `neutronMass16` | `op neutronMass16 () as float16` | `float16` |
| `stefanBoltzmannConstant64` | `op stefanBoltzmannConstant64 () as float64` | `float64` |
| `stefanBoltzmannConstant32` | `op stefanBoltzmannConstant32 () as float32` | `float32` |
| `stefanBoltzmannConstant16` | `op stefanBoltzmannConstant16 () as float16` | `float16` |
| `wienDisplacementConstant64` | `op wienDisplacementConstant64 () as float64` | `float64` |
| `wienDisplacementConstant32` | `op wienDisplacementConstant32 () as float32` | `float32` |
| `wienDisplacementConstant16` | `op wienDisplacementConstant16 () as float16` | `float16` |
| `astronomicalUnit64` | `op astronomicalUnit64 () as float64` | `float64` |
| `astronomicalUnit32` | `op astronomicalUnit32 () as float32` | `float32` |
| `astronomicalUnit16` | `op astronomicalUnit16 () as float16` | `float16` |
| `lightYear64` | `op lightYear64 () as float64` | `float64` |
| `lightYear32` | `op lightYear32 () as float32` | `float32` |
| `lightYear16` | `op lightYear16 () as float16` | `float16` |
| `standardAtmosphere64` | `op standardAtmosphere64 () as float64` | `float64` |
| `standardAtmosphere32` | `op standardAtmosphere32 () as float32` | `float32` |
| `standardAtmosphere16` | `op standardAtmosphere16 () as float16` | `float16` |
| `absoluteZeroCelsius64` | `op absoluteZeroCelsius64 () as float64` | `float64` |
| `absoluteZeroCelsius32` | `op absoluteZeroCelsius32 () as float32` | `float32` |
| `absoluteZeroCelsius16` | `op absoluteZeroCelsius16 () as float16` | `float16` |

#### Operation Technical Specifications:

##### `op speedOfLight64`
```flux
op speedOfLight64 () as float64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `speedOfLight64` functionality within the `PhysConstantsContract` domain.

##### `op speedOfLight32`
```flux
op speedOfLight32 () as float32
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `speedOfLight32` functionality within the `PhysConstantsContract` domain.

##### `op speedOfLight16`
```flux
op speedOfLight16 () as float16
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `speedOfLight16` functionality within the `PhysConstantsContract` domain.

##### `op gravitationalConstant64`
```flux
op gravitationalConstant64 () as float64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gravitationalConstant64` functionality within the `PhysConstantsContract` domain.

##### `op gravitationalConstant32`
```flux
op gravitationalConstant32 () as float32
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gravitationalConstant32` functionality within the `PhysConstantsContract` domain.

##### `op gravitationalConstant16`
```flux
op gravitationalConstant16 () as float16
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gravitationalConstant16` functionality within the `PhysConstantsContract` domain.

##### `op standardGravity64`
```flux
op standardGravity64 () as float64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `standardGravity64` functionality within the `PhysConstantsContract` domain.

##### `op standardGravity32`
```flux
op standardGravity32 () as float32
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `standardGravity32` functionality within the `PhysConstantsContract` domain.

##### `op standardGravity16`
```flux
op standardGravity16 () as float16
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `standardGravity16` functionality within the `PhysConstantsContract` domain.

##### `op planckConstant64`
```flux
op planckConstant64 () as float64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `planckConstant64` functionality within the `PhysConstantsContract` domain.

##### `op planckConstant32`
```flux
op planckConstant32 () as float32
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `planckConstant32` functionality within the `PhysConstantsContract` domain.

##### `op planckConstant16`
```flux
op planckConstant16 () as float16
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `planckConstant16` functionality within the `PhysConstantsContract` domain.

##### `op reducedPlanckConstant64`
```flux
op reducedPlanckConstant64 () as float64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `reducedPlanckConstant64` functionality within the `PhysConstantsContract` domain.

##### `op reducedPlanckConstant32`
```flux
op reducedPlanckConstant32 () as float32
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `reducedPlanckConstant32` functionality within the `PhysConstantsContract` domain.

##### `op reducedPlanckConstant16`
```flux
op reducedPlanckConstant16 () as float16
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `reducedPlanckConstant16` functionality within the `PhysConstantsContract` domain.

##### `op elementaryCharge64`
```flux
op elementaryCharge64 () as float64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `elementaryCharge64` functionality within the `PhysConstantsContract` domain.

##### `op elementaryCharge32`
```flux
op elementaryCharge32 () as float32
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `elementaryCharge32` functionality within the `PhysConstantsContract` domain.

##### `op elementaryCharge16`
```flux
op elementaryCharge16 () as float16
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `elementaryCharge16` functionality within the `PhysConstantsContract` domain.

##### `op boltzmannConstant64`
```flux
op boltzmannConstant64 () as float64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `boltzmannConstant64` functionality within the `PhysConstantsContract` domain.

##### `op boltzmannConstant32`
```flux
op boltzmannConstant32 () as float32
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `boltzmannConstant32` functionality within the `PhysConstantsContract` domain.

##### `op boltzmannConstant16`
```flux
op boltzmannConstant16 () as float16
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `boltzmannConstant16` functionality within the `PhysConstantsContract` domain.

##### `op avogadroNumber64`
```flux
op avogadroNumber64 () as float64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `avogadroNumber64` functionality within the `PhysConstantsContract` domain.

##### `op avogadroNumber32`
```flux
op avogadroNumber32 () as float32
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `avogadroNumber32` functionality within the `PhysConstantsContract` domain.

##### `op avogadroNumber16`
```flux
op avogadroNumber16 () as float16
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `avogadroNumber16` functionality within the `PhysConstantsContract` domain.

##### `op gasConstant64`
```flux
op gasConstant64 () as float64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gasConstant64` functionality within the `PhysConstantsContract` domain.

##### `op gasConstant32`
```flux
op gasConstant32 () as float32
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gasConstant32` functionality within the `PhysConstantsContract` domain.

##### `op gasConstant16`
```flux
op gasConstant16 () as float16
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `gasConstant16` functionality within the `PhysConstantsContract` domain.

##### `op vacuumPermittivity64`
```flux
op vacuumPermittivity64 () as float64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `vacuumPermittivity64` functionality within the `PhysConstantsContract` domain.

##### `op vacuumPermittivity32`
```flux
op vacuumPermittivity32 () as float32
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `vacuumPermittivity32` functionality within the `PhysConstantsContract` domain.

##### `op vacuumPermittivity16`
```flux
op vacuumPermittivity16 () as float16
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `vacuumPermittivity16` functionality within the `PhysConstantsContract` domain.

##### `op vacuumPermeability64`
```flux
op vacuumPermeability64 () as float64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `vacuumPermeability64` functionality within the `PhysConstantsContract` domain.

##### `op vacuumPermeability32`
```flux
op vacuumPermeability32 () as float32
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `vacuumPermeability32` functionality within the `PhysConstantsContract` domain.

##### `op vacuumPermeability16`
```flux
op vacuumPermeability16 () as float16
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `vacuumPermeability16` functionality within the `PhysConstantsContract` domain.

##### `op coulombConstant64`
```flux
op coulombConstant64 () as float64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `coulombConstant64` functionality within the `PhysConstantsContract` domain.

##### `op coulombConstant32`
```flux
op coulombConstant32 () as float32
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `coulombConstant32` functionality within the `PhysConstantsContract` domain.

##### `op coulombConstant16`
```flux
op coulombConstant16 () as float16
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `coulombConstant16` functionality within the `PhysConstantsContract` domain.

##### `op electronMass64`
```flux
op electronMass64 () as float64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `electronMass64` functionality within the `PhysConstantsContract` domain.

##### `op electronMass32`
```flux
op electronMass32 () as float32
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `electronMass32` functionality within the `PhysConstantsContract` domain.

##### `op electronMass16`
```flux
op electronMass16 () as float16
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `electronMass16` functionality within the `PhysConstantsContract` domain.

##### `op protonMass64`
```flux
op protonMass64 () as float64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `protonMass64` functionality within the `PhysConstantsContract` domain.

##### `op protonMass32`
```flux
op protonMass32 () as float32
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `protonMass32` functionality within the `PhysConstantsContract` domain.

##### `op protonMass16`
```flux
op protonMass16 () as float16
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `protonMass16` functionality within the `PhysConstantsContract` domain.

##### `op neutronMass64`
```flux
op neutronMass64 () as float64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `neutronMass64` functionality within the `PhysConstantsContract` domain.

##### `op neutronMass32`
```flux
op neutronMass32 () as float32
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `neutronMass32` functionality within the `PhysConstantsContract` domain.

##### `op neutronMass16`
```flux
op neutronMass16 () as float16
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `neutronMass16` functionality within the `PhysConstantsContract` domain.

##### `op stefanBoltzmannConstant64`
```flux
op stefanBoltzmannConstant64 () as float64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stefanBoltzmannConstant64` functionality within the `PhysConstantsContract` domain.

##### `op stefanBoltzmannConstant32`
```flux
op stefanBoltzmannConstant32 () as float32
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stefanBoltzmannConstant32` functionality within the `PhysConstantsContract` domain.

##### `op stefanBoltzmannConstant16`
```flux
op stefanBoltzmannConstant16 () as float16
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stefanBoltzmannConstant16` functionality within the `PhysConstantsContract` domain.

##### `op wienDisplacementConstant64`
```flux
op wienDisplacementConstant64 () as float64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `wienDisplacementConstant64` functionality within the `PhysConstantsContract` domain.

##### `op wienDisplacementConstant32`
```flux
op wienDisplacementConstant32 () as float32
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `wienDisplacementConstant32` functionality within the `PhysConstantsContract` domain.

##### `op wienDisplacementConstant16`
```flux
op wienDisplacementConstant16 () as float16
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `wienDisplacementConstant16` functionality within the `PhysConstantsContract` domain.

##### `op astronomicalUnit64`
```flux
op astronomicalUnit64 () as float64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `astronomicalUnit64` functionality within the `PhysConstantsContract` domain.

##### `op astronomicalUnit32`
```flux
op astronomicalUnit32 () as float32
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `astronomicalUnit32` functionality within the `PhysConstantsContract` domain.

##### `op astronomicalUnit16`
```flux
op astronomicalUnit16 () as float16
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `astronomicalUnit16` functionality within the `PhysConstantsContract` domain.

##### `op lightYear64`
```flux
op lightYear64 () as float64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lightYear64` functionality within the `PhysConstantsContract` domain.

##### `op lightYear32`
```flux
op lightYear32 () as float32
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lightYear32` functionality within the `PhysConstantsContract` domain.

##### `op lightYear16`
```flux
op lightYear16 () as float16
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lightYear16` functionality within the `PhysConstantsContract` domain.

##### `op standardAtmosphere64`
```flux
op standardAtmosphere64 () as float64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `standardAtmosphere64` functionality within the `PhysConstantsContract` domain.

##### `op standardAtmosphere32`
```flux
op standardAtmosphere32 () as float32
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `standardAtmosphere32` functionality within the `PhysConstantsContract` domain.

##### `op standardAtmosphere16`
```flux
op standardAtmosphere16 () as float16
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `standardAtmosphere16` functionality within the `PhysConstantsContract` domain.

##### `op absoluteZeroCelsius64`
```flux
op absoluteZeroCelsius64 () as float64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `absoluteZeroCelsius64` functionality within the `PhysConstantsContract` domain.

##### `op absoluteZeroCelsius32`
```flux
op absoluteZeroCelsius32 () as float32
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float32`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `absoluteZeroCelsius32` functionality within the `PhysConstantsContract` domain.

##### `op absoluteZeroCelsius16`
```flux
op absoluteZeroCelsius16 () as float16
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `float16`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `absoluteZeroCelsius16` functionality within the `PhysConstantsContract` domain.

### 4.3 Contract `PhysDynamicsContract` (`PhysDynamics.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `physForce` | `op physForce (as float64: mass, as float64: acceleration) as float64` | `float64` |
| `physAcceleration` | `op physAcceleration (as float64: force, as float64: mass) as float64` | `float64` |
| `physWeight` | `op physWeight (as float64: mass, as float64: gravity) as float64` | `float64` |
| `physFrictionForce` | `op physFrictionForce (as float64: normal_force, as float64: friction_coeff) as float64` | `float64` |
| `physHookeForce` | `op physHookeForce (as float64: spring_k, as float64: displacement) as float64` | `float64` |
| `physCentripetalForce` | `op physCentripetalForce (as float64: mass, as float64: velocity, as float64: radius) as float64` | `float64` |
| `physMomentum` | `op physMomentum (as float64: mass, as float64: velocity) as float64` | `float64` |
| `physImpulse` | `op physImpulse (as float64: force, as float64: delta_time) as float64` | `float64` |

#### Operation Technical Specifications:

##### `op physForce`
```flux
op physForce (as float64: mass, as float64: acceleration) as float64
```
- **Parameters**:
  - `mass` (`float64`): Input argument for operation execution.
  - `acceleration` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physForce` functionality within the `PhysDynamicsContract` domain.

##### `op physAcceleration`
```flux
op physAcceleration (as float64: force, as float64: mass) as float64
```
- **Parameters**:
  - `force` (`float64`): Input argument for operation execution.
  - `mass` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ⚠️ Emits `fail` with status message `"massa zero em aceleracao"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physAcceleration` functionality within the `PhysDynamicsContract` domain.

##### `op physWeight`
```flux
op physWeight (as float64: mass, as float64: gravity) as float64
```
- **Parameters**:
  - `mass` (`float64`): Input argument for operation execution.
  - `gravity` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physWeight` functionality within the `PhysDynamicsContract` domain.

##### `op physFrictionForce`
```flux
op physFrictionForce (as float64: normal_force, as float64: friction_coeff) as float64
```
- **Parameters**:
  - `normal_force` (`float64`): Input argument for operation execution.
  - `friction_coeff` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physFrictionForce` functionality within the `PhysDynamicsContract` domain.

##### `op physHookeForce`
```flux
op physHookeForce (as float64: spring_k, as float64: displacement) as float64
```
- **Parameters**:
  - `spring_k` (`float64`): Input argument for operation execution.
  - `displacement` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physHookeForce` functionality within the `PhysDynamicsContract` domain.

##### `op physCentripetalForce`
```flux
op physCentripetalForce (as float64: mass, as float64: velocity, as float64: radius) as float64
```
- **Parameters**:
  - `mass` (`float64`): Input argument for operation execution.
  - `velocity` (`float64`): Input argument for operation execution.
  - `radius` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ⚠️ Emits `fail` with status message `"raio zero em forca centripeta"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physCentripetalForce` functionality within the `PhysDynamicsContract` domain.

##### `op physMomentum`
```flux
op physMomentum (as float64: mass, as float64: velocity) as float64
```
- **Parameters**:
  - `mass` (`float64`): Input argument for operation execution.
  - `velocity` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physMomentum` functionality within the `PhysDynamicsContract` domain.

##### `op physImpulse`
```flux
op physImpulse (as float64: force, as float64: delta_time) as float64
```
- **Parameters**:
  - `force` (`float64`): Input argument for operation execution.
  - `delta_time` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physImpulse` functionality within the `PhysDynamicsContract` domain.

### 4.4 Contract `PhysElectromagnetismContract` (`PhysElectromagnetism.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `physCoulombForce` | `op physCoulombForce (as float64: q1, as float64: q2, as float64: distance) as float64` | `float64` |
| `physElectricField` | `op physElectricField (as float64: charge, as float64: distance) as float64` | `float64` |
| `physElectricPotential` | `op physElectricPotential (as float64: charge, as float64: distance) as float64` | `float64` |
| `physOhmCurrent` | `op physOhmCurrent (as float64: voltage, as float64: resistance) as float64` | `float64` |
| `physOhmVoltage` | `op physOhmVoltage (as float64: current, as float64: resistance) as float64` | `float64` |
| `physElectricPower` | `op physElectricPower (as float64: voltage, as float64: current) as float64` | `float64` |
| `physCapacitorEnergy` | `op physCapacitorEnergy (as float64: capacitance, as float64: voltage) as float64` | `float64` |

#### Operation Technical Specifications:

##### `op physCoulombForce`
```flux
op physCoulombForce (as float64: q1, as float64: q2, as float64: distance) as float64
```
- **Parameters**:
  - `q1` (`float64`): Input argument for operation execution.
  - `q2` (`float64`): Input argument for operation execution.
  - `distance` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ⚠️ Emits `fail` with status message `"distancia invalida em Coulomb"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physCoulombForce` functionality within the `PhysElectromagnetismContract` domain.

##### `op physElectricField`
```flux
op physElectricField (as float64: charge, as float64: distance) as float64
```
- **Parameters**:
  - `charge` (`float64`): Input argument for operation execution.
  - `distance` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ⚠️ Emits `fail` with status message `"distancia invalida em campo eletrico"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physElectricField` functionality within the `PhysElectromagnetismContract` domain.

##### `op physElectricPotential`
```flux
op physElectricPotential (as float64: charge, as float64: distance) as float64
```
- **Parameters**:
  - `charge` (`float64`): Input argument for operation execution.
  - `distance` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ⚠️ Emits `fail` with status message `"distancia invalida em potencial eletrico"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physElectricPotential` functionality within the `PhysElectromagnetismContract` domain.

##### `op physOhmCurrent`
```flux
op physOhmCurrent (as float64: voltage, as float64: resistance) as float64
```
- **Parameters**:
  - `voltage` (`float64`): Input argument for operation execution.
  - `resistance` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ⚠️ Emits `fail` with status message `"resistencia zero em Ohm"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physOhmCurrent` functionality within the `PhysElectromagnetismContract` domain.

##### `op physOhmVoltage`
```flux
op physOhmVoltage (as float64: current, as float64: resistance) as float64
```
- **Parameters**:
  - `current` (`float64`): Input argument for operation execution.
  - `resistance` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physOhmVoltage` functionality within the `PhysElectromagnetismContract` domain.

##### `op physElectricPower`
```flux
op physElectricPower (as float64: voltage, as float64: current) as float64
```
- **Parameters**:
  - `voltage` (`float64`): Input argument for operation execution.
  - `current` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physElectricPower` functionality within the `PhysElectromagnetismContract` domain.

##### `op physCapacitorEnergy`
```flux
op physCapacitorEnergy (as float64: capacitance, as float64: voltage) as float64
```
- **Parameters**:
  - `capacitance` (`float64`): Input argument for operation execution.
  - `voltage` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physCapacitorEnergy` functionality within the `PhysElectromagnetismContract` domain.

### 4.5 Contract `PhysEnergyContract` (`PhysEnergy.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `physKineticEnergy` | `op physKineticEnergy (as float64: mass, as float64: velocity) as float64` | `float64` |
| `physPotentialEnergy` | `op physPotentialEnergy (as float64: mass, as float64: height, as float64: gravity) as float64` | `float64` |
| `physElasticPotentialEnergy` | `op physElasticPotentialEnergy (as float64: spring_k, as float64: displacement) as float64` | `float64` |
| `physMechanicalEnergy` | `op physMechanicalEnergy (as float64: kinetic, as float64: potential) as float64` | `float64` |
| `physWork` | `op physWork (as float64: force, as float64: displacement) as float64` | `float64` |
| `physPower` | `op physPower (as float64: work, as float64: time) as float64` | `float64` |
| `physEfficiency` | `op physEfficiency (as float64: useful_power, as float64: total_power) as float64` | `float64` |

#### Operation Technical Specifications:

##### `op physKineticEnergy`
```flux
op physKineticEnergy (as float64: mass, as float64: velocity) as float64
```
- **Parameters**:
  - `mass` (`float64`): Input argument for operation execution.
  - `velocity` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physKineticEnergy` functionality within the `PhysEnergyContract` domain.

##### `op physPotentialEnergy`
```flux
op physPotentialEnergy (as float64: mass, as float64: height, as float64: gravity) as float64
```
- **Parameters**:
  - `mass` (`float64`): Input argument for operation execution.
  - `height` (`float64`): Input argument for operation execution.
  - `gravity` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physPotentialEnergy` functionality within the `PhysEnergyContract` domain.

##### `op physElasticPotentialEnergy`
```flux
op physElasticPotentialEnergy (as float64: spring_k, as float64: displacement) as float64
```
- **Parameters**:
  - `spring_k` (`float64`): Input argument for operation execution.
  - `displacement` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physElasticPotentialEnergy` functionality within the `PhysEnergyContract` domain.

##### `op physMechanicalEnergy`
```flux
op physMechanicalEnergy (as float64: kinetic, as float64: potential) as float64
```
- **Parameters**:
  - `kinetic` (`float64`): Input argument for operation execution.
  - `potential` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physMechanicalEnergy` functionality within the `PhysEnergyContract` domain.

##### `op physWork`
```flux
op physWork (as float64: force, as float64: displacement) as float64
```
- **Parameters**:
  - `force` (`float64`): Input argument for operation execution.
  - `displacement` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physWork` functionality within the `PhysEnergyContract` domain.

##### `op physPower`
```flux
op physPower (as float64: work, as float64: time) as float64
```
- **Parameters**:
  - `work` (`float64`): Input argument for operation execution.
  - `time` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ⚠️ Emits `fail` with status message `"tempo zero em potencia"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physPower` functionality within the `PhysEnergyContract` domain.

##### `op physEfficiency`
```flux
op physEfficiency (as float64: useful_power, as float64: total_power) as float64
```
- **Parameters**:
  - `useful_power` (`float64`): Input argument for operation execution.
  - `total_power` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ⚠️ Emits `fail` with status message `"potencia total zero em rendimento"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physEfficiency` functionality within the `PhysEnergyContract` domain.

### 4.6 Contract `PhysKinematicsContract` (`PhysKinematics.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `physVelocity` | `op physVelocity (as float64: v0, as float64: a, as float64: t) as float64` | `float64` |
| `physDisplacement` | `op physDisplacement (as float64: s0, as float64: v0, as float64: a, as float64: t) as float64` | `float64` |
| `physTorricelli` | `op physTorricelli (as float64: v0, as float64: a, as float64: delta_s) as float64` | `float64` |
| `physAverageSpeed` | `op physAverageSpeed (as float64: distance, as float64: time) as float64` | `float64` |
| `physCircularAngularVelocity` | `op physCircularAngularVelocity (as float64: angle_rad, as float64: time) as float64` | `float64` |
| `physCircularLinearVelocity` | `op physCircularLinearVelocity (as float64: omega, as float64: radius) as float64` | `float64` |
| `physCentripetalAcceleration` | `op physCentripetalAcceleration (as float64: velocity, as float64: radius) as float64` | `float64` |
| `physSimpleHarmonicPeriod` | `op physSimpleHarmonicPeriod (as float64: mass, as float64: spring_k) as float64` | `float64` |
| `physPendulumPeriod` | `op physPendulumPeriod (as float64: length, as float64: gravity) as float64` | `float64` |

#### Operation Technical Specifications:

##### `op physVelocity`
```flux
op physVelocity (as float64: v0, as float64: a, as float64: t) as float64
```
- **Parameters**:
  - `v0` (`float64`): Input argument for operation execution.
  - `a` (`float64`): Input argument for operation execution.
  - `t` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physVelocity` functionality within the `PhysKinematicsContract` domain.

##### `op physDisplacement`
```flux
op physDisplacement (as float64: s0, as float64: v0, as float64: a, as float64: t) as float64
```
- **Parameters**:
  - `s0` (`float64`): Input argument for operation execution.
  - `v0` (`float64`): Input argument for operation execution.
  - `a` (`float64`): Input argument for operation execution.
  - `t` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physDisplacement` functionality within the `PhysKinematicsContract` domain.

##### `op physTorricelli`
```flux
op physTorricelli (as float64: v0, as float64: a, as float64: delta_s) as float64
```
- **Parameters**:
  - `v0` (`float64`): Input argument for operation execution.
  - `a` (`float64`): Input argument for operation execution.
  - `delta_s` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ⚠️ Emits `fail` with status message `"velocidade imaginaria em Torricelli"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physTorricelli` functionality within the `PhysKinematicsContract` domain.

##### `op physAverageSpeed`
```flux
op physAverageSpeed (as float64: distance, as float64: time) as float64
```
- **Parameters**:
  - `distance` (`float64`): Input argument for operation execution.
  - `time` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ⚠️ Emits `fail` with status message `"tempo zero em velocidade media"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physAverageSpeed` functionality within the `PhysKinematicsContract` domain.

##### `op physCircularAngularVelocity`
```flux
op physCircularAngularVelocity (as float64: angle_rad, as float64: time) as float64
```
- **Parameters**:
  - `angle_rad` (`float64`): Input argument for operation execution.
  - `time` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ⚠️ Emits `fail` with status message `"tempo zero em velocidade angular"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physCircularAngularVelocity` functionality within the `PhysKinematicsContract` domain.

##### `op physCircularLinearVelocity`
```flux
op physCircularLinearVelocity (as float64: omega, as float64: radius) as float64
```
- **Parameters**:
  - `omega` (`float64`): Input argument for operation execution.
  - `radius` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physCircularLinearVelocity` functionality within the `PhysKinematicsContract` domain.

##### `op physCentripetalAcceleration`
```flux
op physCentripetalAcceleration (as float64: velocity, as float64: radius) as float64
```
- **Parameters**:
  - `velocity` (`float64`): Input argument for operation execution.
  - `radius` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ⚠️ Emits `fail` with status message `"raio zero em aceleracao centripeta"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physCentripetalAcceleration` functionality within the `PhysKinematicsContract` domain.

##### `op physSimpleHarmonicPeriod`
```flux
op physSimpleHarmonicPeriod (as float64: mass, as float64: spring_k) as float64
```
- **Parameters**:
  - `mass` (`float64`): Input argument for operation execution.
  - `spring_k` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ⚠️ Emits `fail` with status message `"massa ou constante elastica invalida no MHS"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physSimpleHarmonicPeriod` functionality within the `PhysKinematicsContract` domain.

##### `op physPendulumPeriod`
```flux
op physPendulumPeriod (as float64: length, as float64: gravity) as float64
```
- **Parameters**:
  - `length` (`float64`): Input argument for operation execution.
  - `gravity` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ⚠️ Emits `fail` with status message `"comprimento ou gravidade invalida no pendulo"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physPendulumPeriod` functionality within the `PhysKinematicsContract` domain.

### 4.7 Contract `PhysQuantumRelativityContract` (`PhysQuantumRelativity.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `physPhotonEnergy` | `op physPhotonEnergy (as float64: frequency) as float64` | `float64` |
| `physDeBroglieWavelength` | `op physDeBroglieWavelength (as float64: momentum) as float64` | `float64` |
| `physMassEnergyEquivalence` | `op physMassEnergyEquivalence (as float64: mass) as float64` | `float64` |
| `physLorentzGamma` | `op physLorentzGamma (as float64: velocity) as float64` | `float64` |
| `physTimeDilation` | `op physTimeDilation (as float64: proper_time, as float64: velocity) as float64` | `float64` |
| `physLengthContraction` | `op physLengthContraction (as float64: proper_length, as float64: velocity) as float64` | `float64` |

#### Operation Technical Specifications:

##### `op physPhotonEnergy`
```flux
op physPhotonEnergy (as float64: frequency) as float64
```
- **Parameters**:
  - `frequency` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physPhotonEnergy` functionality within the `PhysQuantumRelativityContract` domain.

##### `op physDeBroglieWavelength`
```flux
op physDeBroglieWavelength (as float64: momentum) as float64
```
- **Parameters**:
  - `momentum` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ⚠️ Emits `fail` with status message `"momento invalido em De Broglie"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physDeBroglieWavelength` functionality within the `PhysQuantumRelativityContract` domain.

##### `op physMassEnergyEquivalence`
```flux
op physMassEnergyEquivalence (as float64: mass) as float64
```
- **Parameters**:
  - `mass` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physMassEnergyEquivalence` functionality within the `PhysQuantumRelativityContract` domain.

##### `op physLorentzGamma`
```flux
op physLorentzGamma (as float64: velocity) as float64
```
- **Parameters**:
  - `velocity` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ⚠️ Emits `fail` with status message `"velocidade igual ou superior a luz"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physLorentzGamma` functionality within the `PhysQuantumRelativityContract` domain.

##### `op physTimeDilation`
```flux
op physTimeDilation (as float64: proper_time, as float64: velocity) as float64
```
- **Parameters**:
  - `proper_time` (`float64`): Input argument for operation execution.
  - `velocity` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ⚠️ Emits `fail` with status message `"velocidade superior a luz em dilatacao temporal"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physTimeDilation` functionality within the `PhysQuantumRelativityContract` domain.

##### `op physLengthContraction`
```flux
op physLengthContraction (as float64: proper_length, as float64: velocity) as float64
```
- **Parameters**:
  - `proper_length` (`float64`): Input argument for operation execution.
  - `velocity` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ⚠️ Emits `fail` with status message `"velocidade superior a luz em contracao de Lorentz"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physLengthContraction` functionality within the `PhysQuantumRelativityContract` domain.

### 4.8 Contract `PhysRigidBody2DContract` (`PhysRigidBody2D.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `physCreateWorld` | `op physCreateWorld (as list of data: gravity, as float64: damping) as map` | `map` |
| `physCreateBodyCircle` | `op physCreateBodyCircle (as float64: id, as float64: mass, as list of data: pos, as list of data: vel, as float64: radius) as map` | `map` |
| `physCreateBodyBox` | `op physCreateBodyBox (as float64: id, as float64: mass, as list of data: pos, as list of data: vel, as float64: width, as float64: height) as map` | `map` |
| `physApplyForce` | `op physApplyForce (as map: body, as list of data: force) as map` | `map` |
| `physApplyImpulse` | `op physApplyImpulse (as map: body, as list of data: impulse) as map` | `map` |
| `physSetMaterial` | `op physSetMaterial (as map: body, as float64: restitution, as float64: friction) as map` | `map` |
| `physCheckCollision` | `op physCheckCollision (as map: body_a, as map: body_b) as bool` | `bool` |
| `physResolveCollision` | `op physResolveCollision (as map: body_a, as map: body_b) as list of data` | `list of data` |
| `physStepSimulation` | `op physStepSimulation (as map: world, as list of data: bodies, as float64: delta_time) as list of data` | `list of data` |
| `physRaycast` | `op physRaycast (as list of data: bodies, as list of data: origin, as list of data: direction, as float64: max_dist) as map` | `map` |

#### Operation Technical Specifications:

##### `op physCreateWorld`
```flux
op physCreateWorld (as list of data: gravity, as float64: damping) as map
```
- **Parameters**:
  - `gravity` (`list of data`): Input argument for operation execution.
  - `damping` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physCreateWorld` functionality within the `PhysRigidBody2DContract` domain.

##### `op physCreateBodyCircle`
```flux
op physCreateBodyCircle (as float64: id, as float64: mass, as list of data: pos, as list of data: vel, as float64: radius) as map
```
- **Parameters**:
  - `id` (`float64`): Input argument for operation execution.
  - `mass` (`float64`): Input argument for operation execution.
  - `pos` (`list of data`): Input argument for operation execution.
  - `vel` (`list of data`): Input argument for operation execution.
  - `radius` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physCreateBodyCircle` functionality within the `PhysRigidBody2DContract` domain.

##### `op physCreateBodyBox`
```flux
op physCreateBodyBox (as float64: id, as float64: mass, as list of data: pos, as list of data: vel, as float64: width, as float64: height) as map
```
- **Parameters**:
  - `id` (`float64`): Input argument for operation execution.
  - `mass` (`float64`): Input argument for operation execution.
  - `pos` (`list of data`): Input argument for operation execution.
  - `vel` (`list of data`): Input argument for operation execution.
  - `width` (`float64`): Input argument for operation execution.
  - `height` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physCreateBodyBox` functionality within the `PhysRigidBody2DContract` domain.

##### `op physApplyForce`
```flux
op physApplyForce (as map: body, as list of data: force) as map
```
- **Parameters**:
  - `body` (`map`): Input argument for operation execution.
  - `force` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physApplyForce` functionality within the `PhysRigidBody2DContract` domain.

##### `op physApplyImpulse`
```flux
op physApplyImpulse (as map: body, as list of data: impulse) as map
```
- **Parameters**:
  - `body` (`map`): Input argument for operation execution.
  - `impulse` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physApplyImpulse` functionality within the `PhysRigidBody2DContract` domain.

##### `op physSetMaterial`
```flux
op physSetMaterial (as map: body, as float64: restitution, as float64: friction) as map
```
- **Parameters**:
  - `body` (`map`): Input argument for operation execution.
  - `restitution` (`float64`): Input argument for operation execution.
  - `friction` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physSetMaterial` functionality within the `PhysRigidBody2DContract` domain.

##### `op physCheckCollision`
```flux
op physCheckCollision (as map: body_a, as map: body_b) as bool
```
- **Parameters**:
  - `body_a` (`map`): Input argument for operation execution.
  - `body_b` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physCheckCollision` functionality within the `PhysRigidBody2DContract` domain.

##### `op physResolveCollision`
```flux
op physResolveCollision (as map: body_a, as map: body_b) as list of data
```
- **Parameters**:
  - `body_a` (`map`): Input argument for operation execution.
  - `body_b` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physResolveCollision` functionality within the `PhysRigidBody2DContract` domain.

##### `op physStepSimulation`
```flux
op physStepSimulation (as map: world, as list of data: bodies, as float64: delta_time) as list of data
```
- **Parameters**:
  - `world` (`map`): Input argument for operation execution.
  - `bodies` (`list of data`): Input argument for operation execution.
  - `delta_time` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physStepSimulation` functionality within the `PhysRigidBody2DContract` domain.

##### `op physRaycast`
```flux
op physRaycast (as list of data: bodies, as list of data: origin, as list of data: direction, as float64: max_dist) as map
```
- **Parameters**:
  - `bodies` (`list of data`): Input argument for operation execution.
  - `origin` (`list of data`): Input argument for operation execution.
  - `direction` (`list of data`): Input argument for operation execution.
  - `max_dist` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physRaycast` functionality within the `PhysRigidBody2DContract` domain.

### 4.9 Contract `PhysThermodynamicsAndWavesContract` (`PhysThermodynamicsAndWaves.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `physCelsiusToKelvin` | `op physCelsiusToKelvin (as float64: celsius) as float64` | `float64` |
| `physKelvinToCelsius` | `op physKelvinToCelsius (as float64: kelvin) as float64` | `float64` |
| `physCelsiusToFahrenheit` | `op physCelsiusToFahrenheit (as float64: celsius) as float64` | `float64` |
| `physFahrenheitToCelsius` | `op physFahrenheitToCelsius (as float64: fahrenheit) as float64` | `float64` |
| `physIdealGasPressure` | `op physIdealGasPressure (as float64: moles, as float64: kelvin, as float64: volume) as float64` | `float64` |
| `physSensibleHeat` | `op physSensibleHeat (as float64: mass, as float64: specific_heat, as float64: delta_temp) as float64` | `float64` |
| `physLatentHeat` | `op physLatentHeat (as float64: mass, as float64: latent_heat) as float64` | `float64` |
| `physWaveSpeed` | `op physWaveSpeed (as float64: frequency, as float64: wavelength) as float64` | `float64` |
| `physWaveFrequency` | `op physWaveFrequency (as float64: speed, as float64: wavelength) as float64` | `float64` |
| `physWavePeriod` | `op physWavePeriod (as float64: frequency) as float64` | `float64` |

#### Operation Technical Specifications:

##### `op physCelsiusToKelvin`
```flux
op physCelsiusToKelvin (as float64: celsius) as float64
```
- **Parameters**:
  - `celsius` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physCelsiusToKelvin` functionality within the `PhysThermodynamicsAndWavesContract` domain.

##### `op physKelvinToCelsius`
```flux
op physKelvinToCelsius (as float64: kelvin) as float64
```
- **Parameters**:
  - `kelvin` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physKelvinToCelsius` functionality within the `PhysThermodynamicsAndWavesContract` domain.

##### `op physCelsiusToFahrenheit`
```flux
op physCelsiusToFahrenheit (as float64: celsius) as float64
```
- **Parameters**:
  - `celsius` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physCelsiusToFahrenheit` functionality within the `PhysThermodynamicsAndWavesContract` domain.

##### `op physFahrenheitToCelsius`
```flux
op physFahrenheitToCelsius (as float64: fahrenheit) as float64
```
- **Parameters**:
  - `fahrenheit` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physFahrenheitToCelsius` functionality within the `PhysThermodynamicsAndWavesContract` domain.

##### `op physIdealGasPressure`
```flux
op physIdealGasPressure (as float64: moles, as float64: kelvin, as float64: volume) as float64
```
- **Parameters**:
  - `moles` (`float64`): Input argument for operation execution.
  - `kelvin` (`float64`): Input argument for operation execution.
  - `volume` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ⚠️ Emits `fail` with status message `"volume invalido no gas ideal"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physIdealGasPressure` functionality within the `PhysThermodynamicsAndWavesContract` domain.

##### `op physSensibleHeat`
```flux
op physSensibleHeat (as float64: mass, as float64: specific_heat, as float64: delta_temp) as float64
```
- **Parameters**:
  - `mass` (`float64`): Input argument for operation execution.
  - `specific_heat` (`float64`): Input argument for operation execution.
  - `delta_temp` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physSensibleHeat` functionality within the `PhysThermodynamicsAndWavesContract` domain.

##### `op physLatentHeat`
```flux
op physLatentHeat (as float64: mass, as float64: latent_heat) as float64
```
- **Parameters**:
  - `mass` (`float64`): Input argument for operation execution.
  - `latent_heat` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physLatentHeat` functionality within the `PhysThermodynamicsAndWavesContract` domain.

##### `op physWaveSpeed`
```flux
op physWaveSpeed (as float64: frequency, as float64: wavelength) as float64
```
- **Parameters**:
  - `frequency` (`float64`): Input argument for operation execution.
  - `wavelength` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physWaveSpeed` functionality within the `PhysThermodynamicsAndWavesContract` domain.

##### `op physWaveFrequency`
```flux
op physWaveFrequency (as float64: speed, as float64: wavelength) as float64
```
- **Parameters**:
  - `speed` (`float64`): Input argument for operation execution.
  - `wavelength` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ⚠️ Emits `fail` with status message `"comprimento de onda invalido"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physWaveFrequency` functionality within the `PhysThermodynamicsAndWavesContract` domain.

##### `op physWavePeriod`
```flux
op physWavePeriod (as float64: frequency) as float64
```
- **Parameters**:
  - `frequency` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ⚠️ Emits `fail` with status message `"frequencia invalida para periodo"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physWavePeriod` functionality within the `PhysThermodynamicsAndWavesContract` domain.

### 4.10 Contract `PhysVector2DContract` (`PhysVector2D.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `physVec2New` | `op physVec2New (as float64: x, as float64: y) as list of data` | `list of data` |
| `physVec2X` | `op physVec2X (as list of data: v) as float64` | `float64` |
| `physVec2Y` | `op physVec2Y (as list of data: v) as float64` | `float64` |
| `physVec2Add` | `op physVec2Add (as list of data: a, as list of data: b) as list of data` | `list of data` |
| `physVec2Sub` | `op physVec2Sub (as list of data: a, as list of data: b) as list of data` | `list of data` |
| `physVec2Scale` | `op physVec2Scale (as list of data: v, as float64: s) as list of data` | `list of data` |
| `physVec2Dot` | `op physVec2Dot (as list of data: a, as list of data: b) as float64` | `float64` |
| `physVec2LengthSq` | `op physVec2LengthSq (as list of data: v) as float64` | `float64` |
| `physVec2Length` | `op physVec2Length (as list of data: v) as float64` | `float64` |
| `physVec2Distance` | `op physVec2Distance (as list of data: a, as list of data: b) as float64` | `float64` |
| `physVec2Normalize` | `op physVec2Normalize (as list of data: v) as list of data` | `list of data` |

#### Operation Technical Specifications:

##### `op physVec2New`
```flux
op physVec2New (as float64: x, as float64: y) as list of data
```
- **Parameters**:
  - `x` (`float64`): Input argument for operation execution.
  - `y` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physVec2New` functionality within the `PhysVector2DContract` domain.

##### `op physVec2X`
```flux
op physVec2X (as list of data: v) as float64
```
- **Parameters**:
  - `v` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physVec2X` functionality within the `PhysVector2DContract` domain.

##### `op physVec2Y`
```flux
op physVec2Y (as list of data: v) as float64
```
- **Parameters**:
  - `v` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physVec2Y` functionality within the `PhysVector2DContract` domain.

##### `op physVec2Add`
```flux
op physVec2Add (as list of data: a, as list of data: b) as list of data
```
- **Parameters**:
  - `a` (`list of data`): Input argument for operation execution.
  - `b` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physVec2Add` functionality within the `PhysVector2DContract` domain.

##### `op physVec2Sub`
```flux
op physVec2Sub (as list of data: a, as list of data: b) as list of data
```
- **Parameters**:
  - `a` (`list of data`): Input argument for operation execution.
  - `b` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physVec2Sub` functionality within the `PhysVector2DContract` domain.

##### `op physVec2Scale`
```flux
op physVec2Scale (as list of data: v, as float64: s) as list of data
```
- **Parameters**:
  - `v` (`list of data`): Input argument for operation execution.
  - `s` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physVec2Scale` functionality within the `PhysVector2DContract` domain.

##### `op physVec2Dot`
```flux
op physVec2Dot (as list of data: a, as list of data: b) as float64
```
- **Parameters**:
  - `a` (`list of data`): Input argument for operation execution.
  - `b` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physVec2Dot` functionality within the `PhysVector2DContract` domain.

##### `op physVec2LengthSq`
```flux
op physVec2LengthSq (as list of data: v) as float64
```
- **Parameters**:
  - `v` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physVec2LengthSq` functionality within the `PhysVector2DContract` domain.

##### `op physVec2Length`
```flux
op physVec2Length (as list of data: v) as float64
```
- **Parameters**:
  - `v` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physVec2Length` functionality within the `PhysVector2DContract` domain.

##### `op physVec2Distance`
```flux
op physVec2Distance (as list of data: a, as list of data: b) as float64
```
- **Parameters**:
  - `a` (`list of data`): Input argument for operation execution.
  - `b` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physVec2Distance` functionality within the `PhysVector2DContract` domain.

##### `op physVec2Normalize`
```flux
op physVec2Normalize (as list of data: v) as list of data
```
- **Parameters**:
  - `v` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `physVec2Normalize` functionality within the `PhysVector2DContract` domain.

---

## 5. Canonical Usage Examples in TheFlux

The following snippet illustrates importing and utilizing the library in a TheFlux program:

```flux
# Canonical Usage Example for PhysStdLib
use PhysStdLib

program (ExampleOfPhysStdLib) {
      println("==================================================")
      println("  Standard Library Demonstration: PhysStdLib")
      println("==================================================")

      # Invoking canonical operation
      mut as data: result = PhysStdLib::physSpeedOfLight()
      println("Obtained result: " + result)

      println("Execution completed successfully.")
}
```

---

> [!TIP]
> For the complete unified architecture across all standard libraries, consult the master [StdLibs.md](../StdLibs.md) reference.
