# 📚 `RandomStdLib` — Geração de Números Pseudoaleatórios e Distribuições Estatísticas

> **Pilar Arquitetural**: Pilar 2 (Estruturas & Estados)  
> **Status**: ✅ Homologado com 100% de Paridade nos 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Arquivo Mestre**: `stdlib/RandomStdLib/RandomStdLib.fdsl`  
> **Modo de Importação**: `use RandomStdLib` ou `use RandomStdLib::<Modulo>::<operacao>`

---

## 1. Visão Geral e Funcionalidades

A biblioteca padrão **`RandomStdLib`** integra o ecossistema oficial da linguagem TheFlux, fornecendo suporte de nível de sistema e algoritmos nativos certificados.

Geradores de números pseudoaleatórios (PRNG) com suporte a sementes determinísticas: distribuições uniformes inteiras e de ponto flutuante, distribuição normal (Gaussiana), exponencial, Poisson e rotinas de embaralhamento aleatório (Fisher-Yates).

### 1.1 Características e Princípios de Design
- **Compilação e Fusão Estática**: Todos os módulos de domínio são fundidos no agente unificado `RandomStdLib` em tempo de compilação, sem sobrecarga (*overhead*) de despacho indireto.
- **Isolamento e Segurança**: As operações verificam limites operacionais e utilizam despacho por contratos formais rigorosos.
- **Compatibilidade Multi-Backend**: Execução bit-a-bit idêntica em interpretador (`in`), bytecode (`vm`, `vmr`), nativo AOT (`llvm`) e WebAssembly (`wat`, `wasm`).

---

## 2. Estrutura Modular e Contratos

A biblioteca é composta por **4 módulos de domínio** e declara **28 operações públicas**:

| Arquivo de Domínio | Contrato Formal | Responsabilidade Principal | Qtd. Ops |
|---|---|---|:---:|
| `RandomDistribution.fdsl` | `RandomDistributionContract` | Domínio especializado de `RandomDistribution` | 8 |
| `RandomGenerator.fdsl` | `RandomGeneratorContract` | Domínio especializado de `RandomGenerator` | 8 |
| `RandomSequence.fdsl` | `RandomSequenceContract` | Domínio especializado de `RandomSequence` | 6 |
| `RandomUtility.fdsl` | `RandomUtilityContract` | Domínio especializado de `RandomUtility` | 6 |

---

## 3. Tipos, Estruturas e Enumerações Públicas

A biblioteca `RandomStdLib` opera diretamente com os tipos nativos e primitivos da linguagem TheFlux (`string`, `int64`, `float64`, `bool`, `list of data`, etc.), sem exigir tipos compostos adicionais.

---

## 4. Catálogo Detalhado de Operações por Domínio

### 4.1 Contrato `RandomDistributionContract` (`RandomDistribution.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `randomNextInt` | `op randomNextInt (as int64: state) as list of data` | `list of data` |
| `randomNextIntRange` | `op randomNextIntRange (as int64: state, as int64: min, as int64: max) as list of data` | `list of data` |
| `randomNextFloat` | `op randomNextFloat (as int64: state) as list of data` | `list of data` |
| `randomNextFloatRange` | `op randomNextFloatRange (as int64: state, as float64: min, as float64: max) as list of data` | `list of data` |
| `randomNextBool` | `op randomNextBool (as int64: state) as list of data` | `list of data` |
| `randomNextBernoulli` | `op randomNextBernoulli (as int64: state, as float64: p) as list of data` | `list of data` |
| `randomNextGaussian` | `op randomNextGaussian (as int64: state, as float64: mean, as float64: std_dev) as list of data` | `list of data` |
| `randomNextDice` | `op randomNextDice (as int64: state, as int64: count, as int64: sides) as list of data` | `list of data` |

#### Ficha Técnica das Operações:

##### `op randomNextInt`
```flux
op randomNextInt (as int64: state) as list of data
```
- **Parâmetros**:
  - `state` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `randomNextInt` no domínio `RandomDistributionContract`.

##### `op randomNextIntRange`
```flux
op randomNextIntRange (as int64: state, as int64: min, as int64: max) as list of data
```
- **Parâmetros**:
  - `state` (`int64`): Parâmetro de entrada para processamento da operação.
  - `min` (`int64`): Parâmetro de entrada para processamento da operação.
  - `max` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `randomNextIntRange` no domínio `RandomDistributionContract`.

##### `op randomNextFloat`
```flux
op randomNextFloat (as int64: state) as list of data
```
- **Parâmetros**:
  - `state` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `randomNextFloat` no domínio `RandomDistributionContract`.

##### `op randomNextFloatRange`
```flux
op randomNextFloatRange (as int64: state, as float64: min, as float64: max) as list of data
```
- **Parâmetros**:
  - `state` (`int64`): Parâmetro de entrada para processamento da operação.
  - `min` (`float64`): Parâmetro de entrada para processamento da operação.
  - `max` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `randomNextFloatRange` no domínio `RandomDistributionContract`.

##### `op randomNextBool`
```flux
op randomNextBool (as int64: state) as list of data
```
- **Parâmetros**:
  - `state` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `randomNextBool` no domínio `RandomDistributionContract`.

##### `op randomNextBernoulli`
```flux
op randomNextBernoulli (as int64: state, as float64: p) as list of data
```
- **Parâmetros**:
  - `state` (`int64`): Parâmetro de entrada para processamento da operação.
  - `p` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `randomNextBernoulli` no domínio `RandomDistributionContract`.

##### `op randomNextGaussian`
```flux
op randomNextGaussian (as int64: state, as float64: mean, as float64: std_dev) as list of data
```
- **Parâmetros**:
  - `state` (`int64`): Parâmetro de entrada para processamento da operação.
  - `mean` (`float64`): Parâmetro de entrada para processamento da operação.
  - `std_dev` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `randomNextGaussian` no domínio `RandomDistributionContract`.

##### `op randomNextDice`
```flux
op randomNextDice (as int64: state, as int64: count, as int64: sides) as list of data
```
- **Parâmetros**:
  - `state` (`int64`): Parâmetro de entrada para processamento da operação.
  - `count` (`int64`): Parâmetro de entrada para processamento da operação.
  - `sides` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `randomNextDice` no domínio `RandomDistributionContract`.

### 4.2 Contrato `RandomGeneratorContract` (`RandomGenerator.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `randomLcgNew` | `op randomLcgNew (as int64: seed) as int64` | `int64` |
| `randomLcgNext` | `op randomLcgNext (as int64: state) as list of data` | `list of data` |
| `randomXorNew` | `op randomXorNew (as int64: seed) as int64` | `int64` |
| `randomXorNext` | `op randomXorNext (as int64: state) as list of data` | `list of data` |
| `randomPcgNew` | `op randomPcgNew (as int64: seed) as int64` | `int64` |
| `randomPcgNext` | `op randomPcgNext (as int64: state) as list of data` | `list of data` |
| `randomSplitMix64` | `op randomSplitMix64 (as int64: seed) as int64` | `int64` |
| `randomSeedSystem` | `op randomSeedSystem () as int64` | `int64` |

#### Ficha Técnica das Operações:

##### `op randomLcgNew`
```flux
op randomLcgNew (as int64: seed) as int64
```
- **Parâmetros**:
  - `seed` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `randomLcgNew` no domínio `RandomGeneratorContract`.

##### `op randomLcgNext`
```flux
op randomLcgNext (as int64: state) as list of data
```
- **Parâmetros**:
  - `state` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `randomLcgNext` no domínio `RandomGeneratorContract`.

##### `op randomXorNew`
```flux
op randomXorNew (as int64: seed) as int64
```
- **Parâmetros**:
  - `seed` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `randomXorNew` no domínio `RandomGeneratorContract`.

##### `op randomXorNext`
```flux
op randomXorNext (as int64: state) as list of data
```
- **Parâmetros**:
  - `state` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `randomXorNext` no domínio `RandomGeneratorContract`.

##### `op randomPcgNew`
```flux
op randomPcgNew (as int64: seed) as int64
```
- **Parâmetros**:
  - `seed` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `randomPcgNew` no domínio `RandomGeneratorContract`.

##### `op randomPcgNext`
```flux
op randomPcgNext (as int64: state) as list of data
```
- **Parâmetros**:
  - `state` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `randomPcgNext` no domínio `RandomGeneratorContract`.

##### `op randomSplitMix64`
```flux
op randomSplitMix64 (as int64: seed) as int64
```
- **Parâmetros**:
  - `seed` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `randomSplitMix64` no domínio `RandomGeneratorContract`.

##### `op randomSeedSystem`
```flux
op randomSeedSystem () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ⚠️ Emite `fail` com status `"Nao implementada"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `randomSeedSystem` no domínio `RandomGeneratorContract`.

### 4.3 Contrato `RandomSequenceContract` (`RandomSequence.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `randomPick` | `op randomPick (as int64: state, as list of data: items) as list of data` | `list of data` |
| `randomPickIndex` | `op randomPickIndex (as int64: state, as list of data: items) as list of data` | `list of data` |
| `randomShuffle` | `op randomShuffle (as int64: state, as list of data: items) as list of data` | `list of data` |
| `randomSample` | `op randomSample (as int64: state, as list of data: items, as int64: k) as list of data` | `list of data` |
| `randomChoices` | `op randomChoices (as int64: state, as list of data: items, as int64: k) as list of data` | `list of data` |
| `randomWeightedChoice` | `op randomWeightedChoice (as int64: state, as list of data: items, as list of data: weights) as list of data` | `list of data` |

#### Ficha Técnica das Operações:

##### `op randomPick`
```flux
op randomPick (as int64: state, as list of data: items) as list of data
```
- **Parâmetros**:
  - `state` (`int64`): Parâmetro de entrada para processamento da operação.
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `randomPick` no domínio `RandomSequenceContract`.

##### `op randomPickIndex`
```flux
op randomPickIndex (as int64: state, as list of data: items) as list of data
```
- **Parâmetros**:
  - `state` (`int64`): Parâmetro de entrada para processamento da operação.
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `randomPickIndex` no domínio `RandomSequenceContract`.

##### `op randomShuffle`
```flux
op randomShuffle (as int64: state, as list of data: items) as list of data
```
- **Parâmetros**:
  - `state` (`int64`): Parâmetro de entrada para processamento da operação.
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `randomShuffle` no domínio `RandomSequenceContract`.

##### `op randomSample`
```flux
op randomSample (as int64: state, as list of data: items, as int64: k) as list of data
```
- **Parâmetros**:
  - `state` (`int64`): Parâmetro de entrada para processamento da operação.
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `k` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `randomSample` no domínio `RandomSequenceContract`.

##### `op randomChoices`
```flux
op randomChoices (as int64: state, as list of data: items, as int64: k) as list of data
```
- **Parâmetros**:
  - `state` (`int64`): Parâmetro de entrada para processamento da operação.
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `k` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `randomChoices` no domínio `RandomSequenceContract`.

##### `op randomWeightedChoice`
```flux
op randomWeightedChoice (as int64: state, as list of data: items, as list of data: weights) as list of data
```
- **Parâmetros**:
  - `state` (`int64`): Parâmetro de entrada para processamento da operação.
  - `items` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `weights` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `randomWeightedChoice` no domínio `RandomSequenceContract`.

### 4.4 Contrato `RandomUtilityContract` (`RandomUtility.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `randomString` | `op randomString (as int64: state, as int64: length, as string: alphabet) as list of data` | `list of data` |
| `randomAlphaNumeric` | `op randomAlphaNumeric (as int64: state, as int64: length) as list of data` | `list of data` |
| `randomHex` | `op randomHex (as int64: state, as int64: length) as list of data` | `list of data` |
| `randomUuidV4` | `op randomUuidV4 (as int64: state) as list of data` | `list of data` |
| `randomIntList` | `op randomIntList (as int64: state, as int64: count, as int64: min, as int64: max) as list of data` | `list of data` |
| `randomFloatList` | `op randomFloatList (as int64: state, as int64: count) as list of data` | `list of data` |

#### Ficha Técnica das Operações:

##### `op randomString`
```flux
op randomString (as int64: state, as int64: length, as string: alphabet) as list of data
```
- **Parâmetros**:
  - `state` (`int64`): Parâmetro de entrada para processamento da operação.
  - `length` (`int64`): Parâmetro de entrada para processamento da operação.
  - `alphabet` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `randomString` no domínio `RandomUtilityContract`.

##### `op randomAlphaNumeric`
```flux
op randomAlphaNumeric (as int64: state, as int64: length) as list of data
```
- **Parâmetros**:
  - `state` (`int64`): Parâmetro de entrada para processamento da operação.
  - `length` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `randomAlphaNumeric` no domínio `RandomUtilityContract`.

##### `op randomHex`
```flux
op randomHex (as int64: state, as int64: length) as list of data
```
- **Parâmetros**:
  - `state` (`int64`): Parâmetro de entrada para processamento da operação.
  - `length` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `randomHex` no domínio `RandomUtilityContract`.

##### `op randomUuidV4`
```flux
op randomUuidV4 (as int64: state) as list of data
```
- **Parâmetros**:
  - `state` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `randomUuidV4` no domínio `RandomUtilityContract`.

##### `op randomIntList`
```flux
op randomIntList (as int64: state, as int64: count, as int64: min, as int64: max) as list of data
```
- **Parâmetros**:
  - `state` (`int64`): Parâmetro de entrada para processamento da operação.
  - `count` (`int64`): Parâmetro de entrada para processamento da operação.
  - `min` (`int64`): Parâmetro de entrada para processamento da operação.
  - `max` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `randomIntList` no domínio `RandomUtilityContract`.

##### `op randomFloatList`
```flux
op randomFloatList (as int64: state, as int64: count) as list of data
```
- **Parâmetros**:
  - `state` (`int64`): Parâmetro de entrada para processamento da operação.
  - `count` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `randomFloatList` no domínio `RandomUtilityContract`.

---

## 5. Exemplos Canônicos de Uso em TheFlux

O exemplo a seguir demonstra a importação e o consumo prático da biblioteca:

```flux
# Exemplo Canônico de Consumo da RandomStdLib
use RandomStdLib

program (ExemploRandomStdLib) {
      println("==================================================")
      println("  Demonstracao da Standard Library: RandomStdLib")
      println("==================================================")

      # Chamada da operacao canônica
      mut as data: resultado = RandomStdLib::randomFloat()
      println("Resultado obtido: " + resultado)

      println("Demonstracao concluida com sucesso.")
}
```

---

> [!TIP]
> Para consultar a visão arquitetural unificada de todas as bibliotecas, consulte o documento principal [StdLibs.md](../StdLibs.md).
