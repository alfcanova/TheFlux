# 📚 `PhysStdLib` — Física Computacional, Constantes Físicas, Mecânica e Termodinâmica

> **Pilar Arquitetural**: Pilar 3 (Matemática & Gráficos)  
> **Status**: ✅ Homologado com 100% de Paridade nos 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Arquivo Mestre**: `stdlib/PhysStdLib/PhysStdLib.fdsl`  
> **Modo de Importação**: `use PhysStdLib` ou `use PhysStdLib::<Modulo>::<operacao>`

---

## 1. Visão Geral e Funcionalidades

A biblioteca padrão **`PhysStdLib`** integra o ecossistema oficial da linguagem TheFlux, fornecendo suporte de nível de sistema e algoritmos nativos certificados.

Modelagem de fenômenos do mundo físico com alta precisão: tabela universal de constantes físicas (CODATA), equações de cinemática e dinâmica clássica, fluidodinâmica, termodinâmica estatística, eletromagnetismo, gravitação e relatividade especial.

### 1.1 Características e Princípios de Design
- **Compilação e Fusão Estática**: Todos os módulos de domínio são fundidos no agente unificado `PhysStdLib` em tempo de compilação, sem sobrecarga (*overhead*) de despacho indireto.
- **Isolamento e Segurança**: As operações verificam limites operacionais e utilizam despacho por contratos formais rigorosos.
- **Compatibilidade Multi-Backend**: Execução bit-a-bit idêntica em interpretador (`in`), bytecode (`vm`, `vmr`), nativo AOT (`llvm`) e WebAssembly (`wat`, `wasm`).

---

## 2. Estrutura Modular e Contratos

A biblioteca é composta por **10 módulos de domínio** e declara **136 operações públicas**:

| Arquivo de Domínio | Contrato Formal | Responsabilidade Principal | Qtd. Ops |
|---|---|---|:---:|
| `PhysAstrophysics.fdsl` | `PhysAstrophysicsContract` | Domínio especializado de `PhysAstrophysics` | 5 |
| `PhysConstants.fdsl` | `PhysConstantsContract` | Domínio especializado de `PhysConstants` | 63 |
| `PhysDynamics.fdsl` | `PhysDynamicsContract` | Domínio especializado de `PhysDynamics` | 8 |
| `PhysElectromagnetism.fdsl` | `PhysElectromagnetismContract` | Domínio especializado de `PhysElectromagnetism` | 7 |
| `PhysEnergy.fdsl` | `PhysEnergyContract` | Domínio especializado de `PhysEnergy` | 7 |
| `PhysKinematics.fdsl` | `PhysKinematicsContract` | Domínio especializado de `PhysKinematics` | 9 |
| `PhysQuantumRelativity.fdsl` | `PhysQuantumRelativityContract` | Domínio especializado de `PhysQuantumRelativity` | 6 |
| `PhysRigidBody2D.fdsl` | `PhysRigidBody2DContract` | Domínio especializado de `PhysRigidBody2D` | 10 |
| `PhysThermodynamicsAndWaves.fdsl` | `PhysThermodynamicsAndWavesContract` | Domínio especializado de `PhysThermodynamicsAndWaves` | 10 |
| `PhysVector2D.fdsl` | `PhysVector2DContract` | Domínio especializado de `PhysVector2D` | 11 |

---

## 3. Tipos, Estruturas e Enumerações Públicas

A biblioteca `PhysStdLib` opera diretamente com os tipos nativos e primitivos da linguagem TheFlux (`string`, `int64`, `float64`, `bool`, `list of data`, etc.), sem exigir tipos compostos adicionais.

---

## 4. Catálogo Detalhado de Operações por Domínio

### 4.1 Contrato `PhysAstrophysicsContract` (`PhysAstrophysics.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `physGravitationalForce` | `op physGravitationalForce (as float64: m1, as float64: m2, as float64: distance) as float64` | `float64` |
| `physGravitationalPotentialEnergy` | `op physGravitationalPotentialEnergy (as float64: m1, as float64: m2, as float64: distance) as float64` | `float64` |
| `physEscapeVelocity` | `op physEscapeVelocity (as float64: mass, as float64: radius) as float64` | `float64` |
| `physOrbitalVelocity` | `op physOrbitalVelocity (as float64: mass, as float64: radius) as float64` | `float64` |
| `physKeplerPeriod` | `op physKeplerPeriod (as float64: semi_major_axis, as float64: central_mass) as float64` | `float64` |

#### Ficha Técnica das Operações:

##### `op physGravitationalForce`
```flux
op physGravitationalForce (as float64: m1, as float64: m2, as float64: distance) as float64
```
- **Parâmetros**:
  - `m1` (`float64`): Parâmetro de entrada para processamento da operação.
  - `m2` (`float64`): Parâmetro de entrada para processamento da operação.
  - `distance` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ⚠️ Emite `fail` com status `"distancia invalida em gravitacao"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physGravitationalForce` no domínio `PhysAstrophysicsContract`.

##### `op physGravitationalPotentialEnergy`
```flux
op physGravitationalPotentialEnergy (as float64: m1, as float64: m2, as float64: distance) as float64
```
- **Parâmetros**:
  - `m1` (`float64`): Parâmetro de entrada para processamento da operação.
  - `m2` (`float64`): Parâmetro de entrada para processamento da operação.
  - `distance` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ⚠️ Emite `fail` com status `"distancia invalida em potencial gravitacional"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physGravitationalPotentialEnergy` no domínio `PhysAstrophysicsContract`.

##### `op physEscapeVelocity`
```flux
op physEscapeVelocity (as float64: mass, as float64: radius) as float64
```
- **Parâmetros**:
  - `mass` (`float64`): Parâmetro de entrada para processamento da operação.
  - `radius` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ⚠️ Emite `fail` com status `"massa ou raio invalido em velocidade de escape"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physEscapeVelocity` no domínio `PhysAstrophysicsContract`.

##### `op physOrbitalVelocity`
```flux
op physOrbitalVelocity (as float64: mass, as float64: radius) as float64
```
- **Parâmetros**:
  - `mass` (`float64`): Parâmetro de entrada para processamento da operação.
  - `radius` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ⚠️ Emite `fail` com status `"massa ou raio invalido em velocidade orbital"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physOrbitalVelocity` no domínio `PhysAstrophysicsContract`.

##### `op physKeplerPeriod`
```flux
op physKeplerPeriod (as float64: semi_major_axis, as float64: central_mass) as float64
```
- **Parâmetros**:
  - `semi_major_axis` (`float64`): Parâmetro de entrada para processamento da operação.
  - `central_mass` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ⚠️ Emite `fail` com status `"eixo ou massa invalida em Kepler"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physKeplerPeriod` no domínio `PhysAstrophysicsContract`.

### 4.2 Contrato `PhysConstantsContract` (`PhysConstants.fdsl`)

| Operação | Assinatura | Retorno |
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

#### Ficha Técnica das Operações:

##### `op speedOfLight64`
```flux
op speedOfLight64 () as float64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `speedOfLight64` no domínio `PhysConstantsContract`.

##### `op speedOfLight32`
```flux
op speedOfLight32 () as float32
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `speedOfLight32` no domínio `PhysConstantsContract`.

##### `op speedOfLight16`
```flux
op speedOfLight16 () as float16
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `speedOfLight16` no domínio `PhysConstantsContract`.

##### `op gravitationalConstant64`
```flux
op gravitationalConstant64 () as float64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gravitationalConstant64` no domínio `PhysConstantsContract`.

##### `op gravitationalConstant32`
```flux
op gravitationalConstant32 () as float32
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gravitationalConstant32` no domínio `PhysConstantsContract`.

##### `op gravitationalConstant16`
```flux
op gravitationalConstant16 () as float16
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gravitationalConstant16` no domínio `PhysConstantsContract`.

##### `op standardGravity64`
```flux
op standardGravity64 () as float64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `standardGravity64` no domínio `PhysConstantsContract`.

##### `op standardGravity32`
```flux
op standardGravity32 () as float32
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `standardGravity32` no domínio `PhysConstantsContract`.

##### `op standardGravity16`
```flux
op standardGravity16 () as float16
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `standardGravity16` no domínio `PhysConstantsContract`.

##### `op planckConstant64`
```flux
op planckConstant64 () as float64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `planckConstant64` no domínio `PhysConstantsContract`.

##### `op planckConstant32`
```flux
op planckConstant32 () as float32
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `planckConstant32` no domínio `PhysConstantsContract`.

##### `op planckConstant16`
```flux
op planckConstant16 () as float16
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `planckConstant16` no domínio `PhysConstantsContract`.

##### `op reducedPlanckConstant64`
```flux
op reducedPlanckConstant64 () as float64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `reducedPlanckConstant64` no domínio `PhysConstantsContract`.

##### `op reducedPlanckConstant32`
```flux
op reducedPlanckConstant32 () as float32
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `reducedPlanckConstant32` no domínio `PhysConstantsContract`.

##### `op reducedPlanckConstant16`
```flux
op reducedPlanckConstant16 () as float16
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `reducedPlanckConstant16` no domínio `PhysConstantsContract`.

##### `op elementaryCharge64`
```flux
op elementaryCharge64 () as float64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `elementaryCharge64` no domínio `PhysConstantsContract`.

##### `op elementaryCharge32`
```flux
op elementaryCharge32 () as float32
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `elementaryCharge32` no domínio `PhysConstantsContract`.

##### `op elementaryCharge16`
```flux
op elementaryCharge16 () as float16
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `elementaryCharge16` no domínio `PhysConstantsContract`.

##### `op boltzmannConstant64`
```flux
op boltzmannConstant64 () as float64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `boltzmannConstant64` no domínio `PhysConstantsContract`.

##### `op boltzmannConstant32`
```flux
op boltzmannConstant32 () as float32
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `boltzmannConstant32` no domínio `PhysConstantsContract`.

##### `op boltzmannConstant16`
```flux
op boltzmannConstant16 () as float16
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `boltzmannConstant16` no domínio `PhysConstantsContract`.

##### `op avogadroNumber64`
```flux
op avogadroNumber64 () as float64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `avogadroNumber64` no domínio `PhysConstantsContract`.

##### `op avogadroNumber32`
```flux
op avogadroNumber32 () as float32
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `avogadroNumber32` no domínio `PhysConstantsContract`.

##### `op avogadroNumber16`
```flux
op avogadroNumber16 () as float16
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `avogadroNumber16` no domínio `PhysConstantsContract`.

##### `op gasConstant64`
```flux
op gasConstant64 () as float64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gasConstant64` no domínio `PhysConstantsContract`.

##### `op gasConstant32`
```flux
op gasConstant32 () as float32
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gasConstant32` no domínio `PhysConstantsContract`.

##### `op gasConstant16`
```flux
op gasConstant16 () as float16
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gasConstant16` no domínio `PhysConstantsContract`.

##### `op vacuumPermittivity64`
```flux
op vacuumPermittivity64 () as float64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `vacuumPermittivity64` no domínio `PhysConstantsContract`.

##### `op vacuumPermittivity32`
```flux
op vacuumPermittivity32 () as float32
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `vacuumPermittivity32` no domínio `PhysConstantsContract`.

##### `op vacuumPermittivity16`
```flux
op vacuumPermittivity16 () as float16
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `vacuumPermittivity16` no domínio `PhysConstantsContract`.

##### `op vacuumPermeability64`
```flux
op vacuumPermeability64 () as float64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `vacuumPermeability64` no domínio `PhysConstantsContract`.

##### `op vacuumPermeability32`
```flux
op vacuumPermeability32 () as float32
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `vacuumPermeability32` no domínio `PhysConstantsContract`.

##### `op vacuumPermeability16`
```flux
op vacuumPermeability16 () as float16
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `vacuumPermeability16` no domínio `PhysConstantsContract`.

##### `op coulombConstant64`
```flux
op coulombConstant64 () as float64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `coulombConstant64` no domínio `PhysConstantsContract`.

##### `op coulombConstant32`
```flux
op coulombConstant32 () as float32
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `coulombConstant32` no domínio `PhysConstantsContract`.

##### `op coulombConstant16`
```flux
op coulombConstant16 () as float16
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `coulombConstant16` no domínio `PhysConstantsContract`.

##### `op electronMass64`
```flux
op electronMass64 () as float64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `electronMass64` no domínio `PhysConstantsContract`.

##### `op electronMass32`
```flux
op electronMass32 () as float32
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `electronMass32` no domínio `PhysConstantsContract`.

##### `op electronMass16`
```flux
op electronMass16 () as float16
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `electronMass16` no domínio `PhysConstantsContract`.

##### `op protonMass64`
```flux
op protonMass64 () as float64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `protonMass64` no domínio `PhysConstantsContract`.

##### `op protonMass32`
```flux
op protonMass32 () as float32
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `protonMass32` no domínio `PhysConstantsContract`.

##### `op protonMass16`
```flux
op protonMass16 () as float16
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `protonMass16` no domínio `PhysConstantsContract`.

##### `op neutronMass64`
```flux
op neutronMass64 () as float64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `neutronMass64` no domínio `PhysConstantsContract`.

##### `op neutronMass32`
```flux
op neutronMass32 () as float32
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `neutronMass32` no domínio `PhysConstantsContract`.

##### `op neutronMass16`
```flux
op neutronMass16 () as float16
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `neutronMass16` no domínio `PhysConstantsContract`.

##### `op stefanBoltzmannConstant64`
```flux
op stefanBoltzmannConstant64 () as float64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stefanBoltzmannConstant64` no domínio `PhysConstantsContract`.

##### `op stefanBoltzmannConstant32`
```flux
op stefanBoltzmannConstant32 () as float32
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stefanBoltzmannConstant32` no domínio `PhysConstantsContract`.

##### `op stefanBoltzmannConstant16`
```flux
op stefanBoltzmannConstant16 () as float16
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stefanBoltzmannConstant16` no domínio `PhysConstantsContract`.

##### `op wienDisplacementConstant64`
```flux
op wienDisplacementConstant64 () as float64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `wienDisplacementConstant64` no domínio `PhysConstantsContract`.

##### `op wienDisplacementConstant32`
```flux
op wienDisplacementConstant32 () as float32
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `wienDisplacementConstant32` no domínio `PhysConstantsContract`.

##### `op wienDisplacementConstant16`
```flux
op wienDisplacementConstant16 () as float16
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `wienDisplacementConstant16` no domínio `PhysConstantsContract`.

##### `op astronomicalUnit64`
```flux
op astronomicalUnit64 () as float64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `astronomicalUnit64` no domínio `PhysConstantsContract`.

##### `op astronomicalUnit32`
```flux
op astronomicalUnit32 () as float32
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `astronomicalUnit32` no domínio `PhysConstantsContract`.

##### `op astronomicalUnit16`
```flux
op astronomicalUnit16 () as float16
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `astronomicalUnit16` no domínio `PhysConstantsContract`.

##### `op lightYear64`
```flux
op lightYear64 () as float64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lightYear64` no domínio `PhysConstantsContract`.

##### `op lightYear32`
```flux
op lightYear32 () as float32
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lightYear32` no domínio `PhysConstantsContract`.

##### `op lightYear16`
```flux
op lightYear16 () as float16
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lightYear16` no domínio `PhysConstantsContract`.

##### `op standardAtmosphere64`
```flux
op standardAtmosphere64 () as float64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `standardAtmosphere64` no domínio `PhysConstantsContract`.

##### `op standardAtmosphere32`
```flux
op standardAtmosphere32 () as float32
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `standardAtmosphere32` no domínio `PhysConstantsContract`.

##### `op standardAtmosphere16`
```flux
op standardAtmosphere16 () as float16
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `standardAtmosphere16` no domínio `PhysConstantsContract`.

##### `op absoluteZeroCelsius64`
```flux
op absoluteZeroCelsius64 () as float64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `absoluteZeroCelsius64` no domínio `PhysConstantsContract`.

##### `op absoluteZeroCelsius32`
```flux
op absoluteZeroCelsius32 () as float32
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float32`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `absoluteZeroCelsius32` no domínio `PhysConstantsContract`.

##### `op absoluteZeroCelsius16`
```flux
op absoluteZeroCelsius16 () as float16
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float16`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `absoluteZeroCelsius16` no domínio `PhysConstantsContract`.

### 4.3 Contrato `PhysDynamicsContract` (`PhysDynamics.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `physForce` | `op physForce (as float64: mass, as float64: acceleration) as float64` | `float64` |
| `physAcceleration` | `op physAcceleration (as float64: force, as float64: mass) as float64` | `float64` |
| `physWeight` | `op physWeight (as float64: mass, as float64: gravity) as float64` | `float64` |
| `physFrictionForce` | `op physFrictionForce (as float64: normal_force, as float64: friction_coeff) as float64` | `float64` |
| `physHookeForce` | `op physHookeForce (as float64: spring_k, as float64: displacement) as float64` | `float64` |
| `physCentripetalForce` | `op physCentripetalForce (as float64: mass, as float64: velocity, as float64: radius) as float64` | `float64` |
| `physMomentum` | `op physMomentum (as float64: mass, as float64: velocity) as float64` | `float64` |
| `physImpulse` | `op physImpulse (as float64: force, as float64: delta_time) as float64` | `float64` |

#### Ficha Técnica das Operações:

##### `op physForce`
```flux
op physForce (as float64: mass, as float64: acceleration) as float64
```
- **Parâmetros**:
  - `mass` (`float64`): Parâmetro de entrada para processamento da operação.
  - `acceleration` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physForce` no domínio `PhysDynamicsContract`.

##### `op physAcceleration`
```flux
op physAcceleration (as float64: force, as float64: mass) as float64
```
- **Parâmetros**:
  - `force` (`float64`): Parâmetro de entrada para processamento da operação.
  - `mass` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ⚠️ Emite `fail` com status `"massa zero em aceleracao"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physAcceleration` no domínio `PhysDynamicsContract`.

##### `op physWeight`
```flux
op physWeight (as float64: mass, as float64: gravity) as float64
```
- **Parâmetros**:
  - `mass` (`float64`): Parâmetro de entrada para processamento da operação.
  - `gravity` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physWeight` no domínio `PhysDynamicsContract`.

##### `op physFrictionForce`
```flux
op physFrictionForce (as float64: normal_force, as float64: friction_coeff) as float64
```
- **Parâmetros**:
  - `normal_force` (`float64`): Parâmetro de entrada para processamento da operação.
  - `friction_coeff` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physFrictionForce` no domínio `PhysDynamicsContract`.

##### `op physHookeForce`
```flux
op physHookeForce (as float64: spring_k, as float64: displacement) as float64
```
- **Parâmetros**:
  - `spring_k` (`float64`): Parâmetro de entrada para processamento da operação.
  - `displacement` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physHookeForce` no domínio `PhysDynamicsContract`.

##### `op physCentripetalForce`
```flux
op physCentripetalForce (as float64: mass, as float64: velocity, as float64: radius) as float64
```
- **Parâmetros**:
  - `mass` (`float64`): Parâmetro de entrada para processamento da operação.
  - `velocity` (`float64`): Parâmetro de entrada para processamento da operação.
  - `radius` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ⚠️ Emite `fail` com status `"raio zero em forca centripeta"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physCentripetalForce` no domínio `PhysDynamicsContract`.

##### `op physMomentum`
```flux
op physMomentum (as float64: mass, as float64: velocity) as float64
```
- **Parâmetros**:
  - `mass` (`float64`): Parâmetro de entrada para processamento da operação.
  - `velocity` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physMomentum` no domínio `PhysDynamicsContract`.

##### `op physImpulse`
```flux
op physImpulse (as float64: force, as float64: delta_time) as float64
```
- **Parâmetros**:
  - `force` (`float64`): Parâmetro de entrada para processamento da operação.
  - `delta_time` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physImpulse` no domínio `PhysDynamicsContract`.

### 4.4 Contrato `PhysElectromagnetismContract` (`PhysElectromagnetism.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `physCoulombForce` | `op physCoulombForce (as float64: q1, as float64: q2, as float64: distance) as float64` | `float64` |
| `physElectricField` | `op physElectricField (as float64: charge, as float64: distance) as float64` | `float64` |
| `physElectricPotential` | `op physElectricPotential (as float64: charge, as float64: distance) as float64` | `float64` |
| `physOhmCurrent` | `op physOhmCurrent (as float64: voltage, as float64: resistance) as float64` | `float64` |
| `physOhmVoltage` | `op physOhmVoltage (as float64: current, as float64: resistance) as float64` | `float64` |
| `physElectricPower` | `op physElectricPower (as float64: voltage, as float64: current) as float64` | `float64` |
| `physCapacitorEnergy` | `op physCapacitorEnergy (as float64: capacitance, as float64: voltage) as float64` | `float64` |

#### Ficha Técnica das Operações:

##### `op physCoulombForce`
```flux
op physCoulombForce (as float64: q1, as float64: q2, as float64: distance) as float64
```
- **Parâmetros**:
  - `q1` (`float64`): Parâmetro de entrada para processamento da operação.
  - `q2` (`float64`): Parâmetro de entrada para processamento da operação.
  - `distance` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ⚠️ Emite `fail` com status `"distancia invalida em Coulomb"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physCoulombForce` no domínio `PhysElectromagnetismContract`.

##### `op physElectricField`
```flux
op physElectricField (as float64: charge, as float64: distance) as float64
```
- **Parâmetros**:
  - `charge` (`float64`): Parâmetro de entrada para processamento da operação.
  - `distance` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ⚠️ Emite `fail` com status `"distancia invalida em campo eletrico"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physElectricField` no domínio `PhysElectromagnetismContract`.

##### `op physElectricPotential`
```flux
op physElectricPotential (as float64: charge, as float64: distance) as float64
```
- **Parâmetros**:
  - `charge` (`float64`): Parâmetro de entrada para processamento da operação.
  - `distance` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ⚠️ Emite `fail` com status `"distancia invalida em potencial eletrico"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physElectricPotential` no domínio `PhysElectromagnetismContract`.

##### `op physOhmCurrent`
```flux
op physOhmCurrent (as float64: voltage, as float64: resistance) as float64
```
- **Parâmetros**:
  - `voltage` (`float64`): Parâmetro de entrada para processamento da operação.
  - `resistance` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ⚠️ Emite `fail` com status `"resistencia zero em Ohm"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physOhmCurrent` no domínio `PhysElectromagnetismContract`.

##### `op physOhmVoltage`
```flux
op physOhmVoltage (as float64: current, as float64: resistance) as float64
```
- **Parâmetros**:
  - `current` (`float64`): Parâmetro de entrada para processamento da operação.
  - `resistance` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physOhmVoltage` no domínio `PhysElectromagnetismContract`.

##### `op physElectricPower`
```flux
op physElectricPower (as float64: voltage, as float64: current) as float64
```
- **Parâmetros**:
  - `voltage` (`float64`): Parâmetro de entrada para processamento da operação.
  - `current` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physElectricPower` no domínio `PhysElectromagnetismContract`.

##### `op physCapacitorEnergy`
```flux
op physCapacitorEnergy (as float64: capacitance, as float64: voltage) as float64
```
- **Parâmetros**:
  - `capacitance` (`float64`): Parâmetro de entrada para processamento da operação.
  - `voltage` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physCapacitorEnergy` no domínio `PhysElectromagnetismContract`.

### 4.5 Contrato `PhysEnergyContract` (`PhysEnergy.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `physKineticEnergy` | `op physKineticEnergy (as float64: mass, as float64: velocity) as float64` | `float64` |
| `physPotentialEnergy` | `op physPotentialEnergy (as float64: mass, as float64: height, as float64: gravity) as float64` | `float64` |
| `physElasticPotentialEnergy` | `op physElasticPotentialEnergy (as float64: spring_k, as float64: displacement) as float64` | `float64` |
| `physMechanicalEnergy` | `op physMechanicalEnergy (as float64: kinetic, as float64: potential) as float64` | `float64` |
| `physWork` | `op physWork (as float64: force, as float64: displacement) as float64` | `float64` |
| `physPower` | `op physPower (as float64: work, as float64: time) as float64` | `float64` |
| `physEfficiency` | `op physEfficiency (as float64: useful_power, as float64: total_power) as float64` | `float64` |

#### Ficha Técnica das Operações:

##### `op physKineticEnergy`
```flux
op physKineticEnergy (as float64: mass, as float64: velocity) as float64
```
- **Parâmetros**:
  - `mass` (`float64`): Parâmetro de entrada para processamento da operação.
  - `velocity` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physKineticEnergy` no domínio `PhysEnergyContract`.

##### `op physPotentialEnergy`
```flux
op physPotentialEnergy (as float64: mass, as float64: height, as float64: gravity) as float64
```
- **Parâmetros**:
  - `mass` (`float64`): Parâmetro de entrada para processamento da operação.
  - `height` (`float64`): Parâmetro de entrada para processamento da operação.
  - `gravity` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physPotentialEnergy` no domínio `PhysEnergyContract`.

##### `op physElasticPotentialEnergy`
```flux
op physElasticPotentialEnergy (as float64: spring_k, as float64: displacement) as float64
```
- **Parâmetros**:
  - `spring_k` (`float64`): Parâmetro de entrada para processamento da operação.
  - `displacement` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physElasticPotentialEnergy` no domínio `PhysEnergyContract`.

##### `op physMechanicalEnergy`
```flux
op physMechanicalEnergy (as float64: kinetic, as float64: potential) as float64
```
- **Parâmetros**:
  - `kinetic` (`float64`): Parâmetro de entrada para processamento da operação.
  - `potential` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physMechanicalEnergy` no domínio `PhysEnergyContract`.

##### `op physWork`
```flux
op physWork (as float64: force, as float64: displacement) as float64
```
- **Parâmetros**:
  - `force` (`float64`): Parâmetro de entrada para processamento da operação.
  - `displacement` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physWork` no domínio `PhysEnergyContract`.

##### `op physPower`
```flux
op physPower (as float64: work, as float64: time) as float64
```
- **Parâmetros**:
  - `work` (`float64`): Parâmetro de entrada para processamento da operação.
  - `time` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ⚠️ Emite `fail` com status `"tempo zero em potencia"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physPower` no domínio `PhysEnergyContract`.

##### `op physEfficiency`
```flux
op physEfficiency (as float64: useful_power, as float64: total_power) as float64
```
- **Parâmetros**:
  - `useful_power` (`float64`): Parâmetro de entrada para processamento da operação.
  - `total_power` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ⚠️ Emite `fail` com status `"potencia total zero em rendimento"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physEfficiency` no domínio `PhysEnergyContract`.

### 4.6 Contrato `PhysKinematicsContract` (`PhysKinematics.fdsl`)

| Operação | Assinatura | Retorno |
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

#### Ficha Técnica das Operações:

##### `op physVelocity`
```flux
op physVelocity (as float64: v0, as float64: a, as float64: t) as float64
```
- **Parâmetros**:
  - `v0` (`float64`): Parâmetro de entrada para processamento da operação.
  - `a` (`float64`): Parâmetro de entrada para processamento da operação.
  - `t` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physVelocity` no domínio `PhysKinematicsContract`.

##### `op physDisplacement`
```flux
op physDisplacement (as float64: s0, as float64: v0, as float64: a, as float64: t) as float64
```
- **Parâmetros**:
  - `s0` (`float64`): Parâmetro de entrada para processamento da operação.
  - `v0` (`float64`): Parâmetro de entrada para processamento da operação.
  - `a` (`float64`): Parâmetro de entrada para processamento da operação.
  - `t` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physDisplacement` no domínio `PhysKinematicsContract`.

##### `op physTorricelli`
```flux
op physTorricelli (as float64: v0, as float64: a, as float64: delta_s) as float64
```
- **Parâmetros**:
  - `v0` (`float64`): Parâmetro de entrada para processamento da operação.
  - `a` (`float64`): Parâmetro de entrada para processamento da operação.
  - `delta_s` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ⚠️ Emite `fail` com status `"velocidade imaginaria em Torricelli"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physTorricelli` no domínio `PhysKinematicsContract`.

##### `op physAverageSpeed`
```flux
op physAverageSpeed (as float64: distance, as float64: time) as float64
```
- **Parâmetros**:
  - `distance` (`float64`): Parâmetro de entrada para processamento da operação.
  - `time` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ⚠️ Emite `fail` com status `"tempo zero em velocidade media"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physAverageSpeed` no domínio `PhysKinematicsContract`.

##### `op physCircularAngularVelocity`
```flux
op physCircularAngularVelocity (as float64: angle_rad, as float64: time) as float64
```
- **Parâmetros**:
  - `angle_rad` (`float64`): Parâmetro de entrada para processamento da operação.
  - `time` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ⚠️ Emite `fail` com status `"tempo zero em velocidade angular"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physCircularAngularVelocity` no domínio `PhysKinematicsContract`.

##### `op physCircularLinearVelocity`
```flux
op physCircularLinearVelocity (as float64: omega, as float64: radius) as float64
```
- **Parâmetros**:
  - `omega` (`float64`): Parâmetro de entrada para processamento da operação.
  - `radius` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physCircularLinearVelocity` no domínio `PhysKinematicsContract`.

##### `op physCentripetalAcceleration`
```flux
op physCentripetalAcceleration (as float64: velocity, as float64: radius) as float64
```
- **Parâmetros**:
  - `velocity` (`float64`): Parâmetro de entrada para processamento da operação.
  - `radius` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ⚠️ Emite `fail` com status `"raio zero em aceleracao centripeta"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physCentripetalAcceleration` no domínio `PhysKinematicsContract`.

##### `op physSimpleHarmonicPeriod`
```flux
op physSimpleHarmonicPeriod (as float64: mass, as float64: spring_k) as float64
```
- **Parâmetros**:
  - `mass` (`float64`): Parâmetro de entrada para processamento da operação.
  - `spring_k` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ⚠️ Emite `fail` com status `"massa ou constante elastica invalida no MHS"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physSimpleHarmonicPeriod` no domínio `PhysKinematicsContract`.

##### `op physPendulumPeriod`
```flux
op physPendulumPeriod (as float64: length, as float64: gravity) as float64
```
- **Parâmetros**:
  - `length` (`float64`): Parâmetro de entrada para processamento da operação.
  - `gravity` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ⚠️ Emite `fail` com status `"comprimento ou gravidade invalida no pendulo"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physPendulumPeriod` no domínio `PhysKinematicsContract`.

### 4.7 Contrato `PhysQuantumRelativityContract` (`PhysQuantumRelativity.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `physPhotonEnergy` | `op physPhotonEnergy (as float64: frequency) as float64` | `float64` |
| `physDeBroglieWavelength` | `op physDeBroglieWavelength (as float64: momentum) as float64` | `float64` |
| `physMassEnergyEquivalence` | `op physMassEnergyEquivalence (as float64: mass) as float64` | `float64` |
| `physLorentzGamma` | `op physLorentzGamma (as float64: velocity) as float64` | `float64` |
| `physTimeDilation` | `op physTimeDilation (as float64: proper_time, as float64: velocity) as float64` | `float64` |
| `physLengthContraction` | `op physLengthContraction (as float64: proper_length, as float64: velocity) as float64` | `float64` |

#### Ficha Técnica das Operações:

##### `op physPhotonEnergy`
```flux
op physPhotonEnergy (as float64: frequency) as float64
```
- **Parâmetros**:
  - `frequency` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physPhotonEnergy` no domínio `PhysQuantumRelativityContract`.

##### `op physDeBroglieWavelength`
```flux
op physDeBroglieWavelength (as float64: momentum) as float64
```
- **Parâmetros**:
  - `momentum` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ⚠️ Emite `fail` com status `"momento invalido em De Broglie"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physDeBroglieWavelength` no domínio `PhysQuantumRelativityContract`.

##### `op physMassEnergyEquivalence`
```flux
op physMassEnergyEquivalence (as float64: mass) as float64
```
- **Parâmetros**:
  - `mass` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physMassEnergyEquivalence` no domínio `PhysQuantumRelativityContract`.

##### `op physLorentzGamma`
```flux
op physLorentzGamma (as float64: velocity) as float64
```
- **Parâmetros**:
  - `velocity` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ⚠️ Emite `fail` com status `"velocidade igual ou superior a luz"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physLorentzGamma` no domínio `PhysQuantumRelativityContract`.

##### `op physTimeDilation`
```flux
op physTimeDilation (as float64: proper_time, as float64: velocity) as float64
```
- **Parâmetros**:
  - `proper_time` (`float64`): Parâmetro de entrada para processamento da operação.
  - `velocity` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ⚠️ Emite `fail` com status `"velocidade superior a luz em dilatacao temporal"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physTimeDilation` no domínio `PhysQuantumRelativityContract`.

##### `op physLengthContraction`
```flux
op physLengthContraction (as float64: proper_length, as float64: velocity) as float64
```
- **Parâmetros**:
  - `proper_length` (`float64`): Parâmetro de entrada para processamento da operação.
  - `velocity` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ⚠️ Emite `fail` com status `"velocidade superior a luz em contracao de Lorentz"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physLengthContraction` no domínio `PhysQuantumRelativityContract`.

### 4.8 Contrato `PhysRigidBody2DContract` (`PhysRigidBody2D.fdsl`)

| Operação | Assinatura | Retorno |
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

#### Ficha Técnica das Operações:

##### `op physCreateWorld`
```flux
op physCreateWorld (as list of data: gravity, as float64: damping) as map
```
- **Parâmetros**:
  - `gravity` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `damping` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physCreateWorld` no domínio `PhysRigidBody2DContract`.

##### `op physCreateBodyCircle`
```flux
op physCreateBodyCircle (as float64: id, as float64: mass, as list of data: pos, as list of data: vel, as float64: radius) as map
```
- **Parâmetros**:
  - `id` (`float64`): Parâmetro de entrada para processamento da operação.
  - `mass` (`float64`): Parâmetro de entrada para processamento da operação.
  - `pos` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `vel` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `radius` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physCreateBodyCircle` no domínio `PhysRigidBody2DContract`.

##### `op physCreateBodyBox`
```flux
op physCreateBodyBox (as float64: id, as float64: mass, as list of data: pos, as list of data: vel, as float64: width, as float64: height) as map
```
- **Parâmetros**:
  - `id` (`float64`): Parâmetro de entrada para processamento da operação.
  - `mass` (`float64`): Parâmetro de entrada para processamento da operação.
  - `pos` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `vel` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `width` (`float64`): Parâmetro de entrada para processamento da operação.
  - `height` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physCreateBodyBox` no domínio `PhysRigidBody2DContract`.

##### `op physApplyForce`
```flux
op physApplyForce (as map: body, as list of data: force) as map
```
- **Parâmetros**:
  - `body` (`map`): Parâmetro de entrada para processamento da operação.
  - `force` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physApplyForce` no domínio `PhysRigidBody2DContract`.

##### `op physApplyImpulse`
```flux
op physApplyImpulse (as map: body, as list of data: impulse) as map
```
- **Parâmetros**:
  - `body` (`map`): Parâmetro de entrada para processamento da operação.
  - `impulse` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physApplyImpulse` no domínio `PhysRigidBody2DContract`.

##### `op physSetMaterial`
```flux
op physSetMaterial (as map: body, as float64: restitution, as float64: friction) as map
```
- **Parâmetros**:
  - `body` (`map`): Parâmetro de entrada para processamento da operação.
  - `restitution` (`float64`): Parâmetro de entrada para processamento da operação.
  - `friction` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physSetMaterial` no domínio `PhysRigidBody2DContract`.

##### `op physCheckCollision`
```flux
op physCheckCollision (as map: body_a, as map: body_b) as bool
```
- **Parâmetros**:
  - `body_a` (`map`): Parâmetro de entrada para processamento da operação.
  - `body_b` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physCheckCollision` no domínio `PhysRigidBody2DContract`.

##### `op physResolveCollision`
```flux
op physResolveCollision (as map: body_a, as map: body_b) as list of data
```
- **Parâmetros**:
  - `body_a` (`map`): Parâmetro de entrada para processamento da operação.
  - `body_b` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physResolveCollision` no domínio `PhysRigidBody2DContract`.

##### `op physStepSimulation`
```flux
op physStepSimulation (as map: world, as list of data: bodies, as float64: delta_time) as list of data
```
- **Parâmetros**:
  - `world` (`map`): Parâmetro de entrada para processamento da operação.
  - `bodies` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `delta_time` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physStepSimulation` no domínio `PhysRigidBody2DContract`.

##### `op physRaycast`
```flux
op physRaycast (as list of data: bodies, as list of data: origin, as list of data: direction, as float64: max_dist) as map
```
- **Parâmetros**:
  - `bodies` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `origin` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `direction` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `max_dist` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physRaycast` no domínio `PhysRigidBody2DContract`.

### 4.9 Contrato `PhysThermodynamicsAndWavesContract` (`PhysThermodynamicsAndWaves.fdsl`)

| Operação | Assinatura | Retorno |
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

#### Ficha Técnica das Operações:

##### `op physCelsiusToKelvin`
```flux
op physCelsiusToKelvin (as float64: celsius) as float64
```
- **Parâmetros**:
  - `celsius` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physCelsiusToKelvin` no domínio `PhysThermodynamicsAndWavesContract`.

##### `op physKelvinToCelsius`
```flux
op physKelvinToCelsius (as float64: kelvin) as float64
```
- **Parâmetros**:
  - `kelvin` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physKelvinToCelsius` no domínio `PhysThermodynamicsAndWavesContract`.

##### `op physCelsiusToFahrenheit`
```flux
op physCelsiusToFahrenheit (as float64: celsius) as float64
```
- **Parâmetros**:
  - `celsius` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physCelsiusToFahrenheit` no domínio `PhysThermodynamicsAndWavesContract`.

##### `op physFahrenheitToCelsius`
```flux
op physFahrenheitToCelsius (as float64: fahrenheit) as float64
```
- **Parâmetros**:
  - `fahrenheit` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physFahrenheitToCelsius` no domínio `PhysThermodynamicsAndWavesContract`.

##### `op physIdealGasPressure`
```flux
op physIdealGasPressure (as float64: moles, as float64: kelvin, as float64: volume) as float64
```
- **Parâmetros**:
  - `moles` (`float64`): Parâmetro de entrada para processamento da operação.
  - `kelvin` (`float64`): Parâmetro de entrada para processamento da operação.
  - `volume` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ⚠️ Emite `fail` com status `"volume invalido no gas ideal"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physIdealGasPressure` no domínio `PhysThermodynamicsAndWavesContract`.

##### `op physSensibleHeat`
```flux
op physSensibleHeat (as float64: mass, as float64: specific_heat, as float64: delta_temp) as float64
```
- **Parâmetros**:
  - `mass` (`float64`): Parâmetro de entrada para processamento da operação.
  - `specific_heat` (`float64`): Parâmetro de entrada para processamento da operação.
  - `delta_temp` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physSensibleHeat` no domínio `PhysThermodynamicsAndWavesContract`.

##### `op physLatentHeat`
```flux
op physLatentHeat (as float64: mass, as float64: latent_heat) as float64
```
- **Parâmetros**:
  - `mass` (`float64`): Parâmetro de entrada para processamento da operação.
  - `latent_heat` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physLatentHeat` no domínio `PhysThermodynamicsAndWavesContract`.

##### `op physWaveSpeed`
```flux
op physWaveSpeed (as float64: frequency, as float64: wavelength) as float64
```
- **Parâmetros**:
  - `frequency` (`float64`): Parâmetro de entrada para processamento da operação.
  - `wavelength` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physWaveSpeed` no domínio `PhysThermodynamicsAndWavesContract`.

##### `op physWaveFrequency`
```flux
op physWaveFrequency (as float64: speed, as float64: wavelength) as float64
```
- **Parâmetros**:
  - `speed` (`float64`): Parâmetro de entrada para processamento da operação.
  - `wavelength` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ⚠️ Emite `fail` com status `"comprimento de onda invalido"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physWaveFrequency` no domínio `PhysThermodynamicsAndWavesContract`.

##### `op physWavePeriod`
```flux
op physWavePeriod (as float64: frequency) as float64
```
- **Parâmetros**:
  - `frequency` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ⚠️ Emite `fail` com status `"frequencia invalida para periodo"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physWavePeriod` no domínio `PhysThermodynamicsAndWavesContract`.

### 4.10 Contrato `PhysVector2DContract` (`PhysVector2D.fdsl`)

| Operação | Assinatura | Retorno |
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

#### Ficha Técnica das Operações:

##### `op physVec2New`
```flux
op physVec2New (as float64: x, as float64: y) as list of data
```
- **Parâmetros**:
  - `x` (`float64`): Parâmetro de entrada para processamento da operação.
  - `y` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physVec2New` no domínio `PhysVector2DContract`.

##### `op physVec2X`
```flux
op physVec2X (as list of data: v) as float64
```
- **Parâmetros**:
  - `v` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physVec2X` no domínio `PhysVector2DContract`.

##### `op physVec2Y`
```flux
op physVec2Y (as list of data: v) as float64
```
- **Parâmetros**:
  - `v` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physVec2Y` no domínio `PhysVector2DContract`.

##### `op physVec2Add`
```flux
op physVec2Add (as list of data: a, as list of data: b) as list of data
```
- **Parâmetros**:
  - `a` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `b` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physVec2Add` no domínio `PhysVector2DContract`.

##### `op physVec2Sub`
```flux
op physVec2Sub (as list of data: a, as list of data: b) as list of data
```
- **Parâmetros**:
  - `a` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `b` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physVec2Sub` no domínio `PhysVector2DContract`.

##### `op physVec2Scale`
```flux
op physVec2Scale (as list of data: v, as float64: s) as list of data
```
- **Parâmetros**:
  - `v` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `s` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physVec2Scale` no domínio `PhysVector2DContract`.

##### `op physVec2Dot`
```flux
op physVec2Dot (as list of data: a, as list of data: b) as float64
```
- **Parâmetros**:
  - `a` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `b` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physVec2Dot` no domínio `PhysVector2DContract`.

##### `op physVec2LengthSq`
```flux
op physVec2LengthSq (as list of data: v) as float64
```
- **Parâmetros**:
  - `v` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physVec2LengthSq` no domínio `PhysVector2DContract`.

##### `op physVec2Length`
```flux
op physVec2Length (as list of data: v) as float64
```
- **Parâmetros**:
  - `v` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physVec2Length` no domínio `PhysVector2DContract`.

##### `op physVec2Distance`
```flux
op physVec2Distance (as list of data: a, as list of data: b) as float64
```
- **Parâmetros**:
  - `a` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `b` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physVec2Distance` no domínio `PhysVector2DContract`.

##### `op physVec2Normalize`
```flux
op physVec2Normalize (as list of data: v) as list of data
```
- **Parâmetros**:
  - `v` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `physVec2Normalize` no domínio `PhysVector2DContract`.

---

## 5. Exemplos Canônicos de Uso em TheFlux

O exemplo a seguir demonstra a importação e o consumo prático da biblioteca:

```flux
# Exemplo Canônico de Consumo da PhysStdLib
use PhysStdLib

program (ExemploPhysStdLib) {
      println("==================================================")
      println("  Demonstracao da Standard Library: PhysStdLib")
      println("==================================================")

      # Chamada da operacao canônica
      mut as data: resultado = PhysStdLib::physSpeedOfLight()
      println("Resultado obtido: " + resultado)

      println("Demonstracao concluida com sucesso.")
}
```

---

> [!TIP]
> Para consultar a visão arquitetural unificada de todas as bibliotecas, consulte o documento principal [StdLibs.md](../StdLibs.md).
