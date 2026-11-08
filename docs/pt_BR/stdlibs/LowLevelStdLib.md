# 📚 `LowLevelStdLib` — Operações de Baixo Nível, Ponteiros Brutos e Manipulação de Memória

> **Pilar Arquitetural**: Pilar 4 (Sistema, I/O & Rede)  
> **Status**: ✅ Homologado com 100% de Paridade nos 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Arquivo Mestre**: `stdlib/LowLevelStdLib/LowLevelStdLib.fdsl`  
> **Modo de Importação**: `use LowLevelStdLib` ou `use LowLevelStdLib::<Modulo>::<operacao>`

---

## 1. Visão Geral e Funcionalidades

A biblioteca padrão **`LowLevelStdLib`** integra o ecossistema oficial da linguagem TheFlux, fornecendo suporte de nível de sistema e algoritmos nativos certificados.

Acesso direto a primitivas de hardware e memória: aritmética de ponteiros brutos, alinhamento de bytes, inspeção e manipulação bit a bit (popcount, clz, ctz), transposição de endianness (Big/Little Endian) e cópia direta de blocos de memória.

### 1.1 Características e Princípios de Design
- **Compilação e Fusão Estática**: Todos os módulos de domínio são fundidos no agente unificado `LowLevelStdLib` em tempo de compilação, sem sobrecarga (*overhead*) de despacho indireto.
- **Isolamento e Segurança**: As operações verificam limites operacionais e utilizam despacho por contratos formais rigorosos.
- **Compatibilidade Multi-Backend**: Execução bit-a-bit idêntica em interpretador (`in`), bytecode (`vm`, `vmr`), nativo AOT (`llvm`) e WebAssembly (`wat`, `wasm`).

---

## 2. Estrutura Modular e Contratos

A biblioteca é composta por **9 módulos de domínio** e declara **105 operações públicas**:

| Arquivo de Domínio | Contrato Formal | Responsabilidade Principal | Qtd. Ops |
|---|---|---|:---:|
| `LowLevelAlignment.fdsl` | `LowLevelAlignmentContract` | Domínio especializado de `LowLevelAlignment` | 6 |
| `LowLevelBitInspection.fdsl` | `LowLevelBitInspectionContract` | Domínio especializado de `LowLevelBitInspection` | 12 |
| `LowLevelBitwise.fdsl` | `LowLevelBitwiseContract` | Domínio especializado de `LowLevelBitwise` | 7 |
| `LowLevelBlockMemory.fdsl` | `LowLevelBlockMemoryContract` | Domínio especializado de `LowLevelBlockMemory` | 5 |
| `LowLevelBuffer.fdsl` | `LowLevelBufferContract` | Domínio especializado de `LowLevelBuffer` | 13 |
| `LowLevelConstants.fdsl` | `LowLevelConstantsContract` | Domínio especializado de `LowLevelConstants` | 28 |
| `LowLevelEndianness.fdsl` | `LowLevelEndiannessContract` | Domínio especializado de `LowLevelEndianness` | 9 |
| `LowLevelMemoryAccess.fdsl` | `LowLevelMemoryAccessContract` | Domínio especializado de `LowLevelMemoryAccess` | 16 |
| `LowLevelShiftRotate.fdsl` | `LowLevelShiftRotateContract` | Domínio especializado de `LowLevelShiftRotate` | 9 |

---

## 3. Tipos, Estruturas e Enumerações Públicas

A biblioteca `LowLevelStdLib` opera diretamente com os tipos nativos e primitivos da linguagem TheFlux (`string`, `int64`, `float64`, `bool`, `list of data`, etc.), sem exigir tipos compostos adicionais.

---

## 4. Catálogo Detalhado de Operações por Domínio

### 4.1 Contrato `LowLevelAlignmentContract` (`LowLevelAlignment.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `lowIsAligned` | `op lowIsAligned (as int64: address, as int64: alignment) as bool` | `bool` |
| `lowAlignForward` | `op lowAlignForward (as int64: address, as int64: alignment) as int64` | `int64` |
| `lowAlignBackward` | `op lowAlignBackward (as int64: address, as int64: alignment) as int64` | `int64` |
| `lowAlignmentPadding` | `op lowAlignmentPadding (as int64: address, as int64: alignment) as int64` | `int64` |
| `lowAddressOffset` | `op lowAddressOffset (as int64: base_address, as int64: offset_bytes) as int64` | `int64` |
| `lowAddressDifference` | `op lowAddressDifference (as int64: addr1, as int64: addr2) as int64` | `int64` |

#### Ficha Técnica das Operações:

##### `op lowIsAligned`
```flux
op lowIsAligned (as int64: address, as int64: alignment) as bool
```
- **Parâmetros**:
  - `address` (`int64`): Parâmetro de entrada para processamento da operação.
  - `alignment` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowIsAligned` no domínio `LowLevelAlignmentContract`.

##### `op lowAlignForward`
```flux
op lowAlignForward (as int64: address, as int64: alignment) as int64
```
- **Parâmetros**:
  - `address` (`int64`): Parâmetro de entrada para processamento da operação.
  - `alignment` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowAlignForward` no domínio `LowLevelAlignmentContract`.

##### `op lowAlignBackward`
```flux
op lowAlignBackward (as int64: address, as int64: alignment) as int64
```
- **Parâmetros**:
  - `address` (`int64`): Parâmetro de entrada para processamento da operação.
  - `alignment` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowAlignBackward` no domínio `LowLevelAlignmentContract`.

##### `op lowAlignmentPadding`
```flux
op lowAlignmentPadding (as int64: address, as int64: alignment) as int64
```
- **Parâmetros**:
  - `address` (`int64`): Parâmetro de entrada para processamento da operação.
  - `alignment` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowAlignmentPadding` no domínio `LowLevelAlignmentContract`.

##### `op lowAddressOffset`
```flux
op lowAddressOffset (as int64: base_address, as int64: offset_bytes) as int64
```
- **Parâmetros**:
  - `base_address` (`int64`): Parâmetro de entrada para processamento da operação.
  - `offset_bytes` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowAddressOffset` no domínio `LowLevelAlignmentContract`.

##### `op lowAddressDifference`
```flux
op lowAddressDifference (as int64: addr1, as int64: addr2) as int64
```
- **Parâmetros**:
  - `addr1` (`int64`): Parâmetro de entrada para processamento da operação.
  - `addr2` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowAddressDifference` no domínio `LowLevelAlignmentContract`.

### 4.2 Contrato `LowLevelBitInspectionContract` (`LowLevelBitInspection.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `lowBitCheck` | `op lowBitCheck (as int64: value, as int64: bit_index) as bool` | `bool` |
| `lowBitSet` | `op lowBitSet (as int64: value, as int64: bit_index) as int64` | `int64` |
| `lowBitClear` | `op lowBitClear (as int64: value, as int64: bit_index) as int64` | `int64` |
| `lowBitToggle` | `op lowBitToggle (as int64: value, as int64: bit_index) as int64` | `int64` |
| `lowBitWrite` | `op lowBitWrite (as int64: value, as int64: bit_index, as bool: state) as int64` | `int64` |
| `lowPopCount` | `op lowPopCount (as int64: value) as int64` | `int64` |
| `lowCountLeadingZeros` | `op lowCountLeadingZeros (as int64: value, as int64: width) as int64` | `int64` |
| `lowCountTrailingZeros` | `op lowCountTrailingZeros (as int64: value) as int64` | `int64` |
| `lowParity` | `op lowParity (as int64: value) as int64` | `int64` |
| `lowReverseBits` | `op lowReverseBits (as int64: value, as int64: width) as int64` | `int64` |
| `lowBitExtract` | `op lowBitExtract (as int64: value, as int64: start_bit, as int64: num_bits) as int64` | `int64` |
| `lowBitInsert` | `op lowBitInsert (as int64: target, as int64: source, as int64: start_bit, as int64: num_bits) as int64` | `int64` |

#### Ficha Técnica das Operações:

##### `op lowBitCheck`
```flux
op lowBitCheck (as int64: value, as int64: bit_index) as bool
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
  - `bit_index` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowBitCheck` no domínio `LowLevelBitInspectionContract`.

##### `op lowBitSet`
```flux
op lowBitSet (as int64: value, as int64: bit_index) as int64
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
  - `bit_index` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowBitSet` no domínio `LowLevelBitInspectionContract`.

##### `op lowBitClear`
```flux
op lowBitClear (as int64: value, as int64: bit_index) as int64
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
  - `bit_index` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowBitClear` no domínio `LowLevelBitInspectionContract`.

##### `op lowBitToggle`
```flux
op lowBitToggle (as int64: value, as int64: bit_index) as int64
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
  - `bit_index` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowBitToggle` no domínio `LowLevelBitInspectionContract`.

##### `op lowBitWrite`
```flux
op lowBitWrite (as int64: value, as int64: bit_index, as bool: state) as int64
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
  - `bit_index` (`int64`): Parâmetro de entrada para processamento da operação.
  - `state` (`bool`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowBitWrite` no domínio `LowLevelBitInspectionContract`.

##### `op lowPopCount`
```flux
op lowPopCount (as int64: value) as int64
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowPopCount` no domínio `LowLevelBitInspectionContract`.

##### `op lowCountLeadingZeros`
```flux
op lowCountLeadingZeros (as int64: value, as int64: width) as int64
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
  - `width` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowCountLeadingZeros` no domínio `LowLevelBitInspectionContract`.

##### `op lowCountTrailingZeros`
```flux
op lowCountTrailingZeros (as int64: value) as int64
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowCountTrailingZeros` no domínio `LowLevelBitInspectionContract`.

##### `op lowParity`
```flux
op lowParity (as int64: value) as int64
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowParity` no domínio `LowLevelBitInspectionContract`.

##### `op lowReverseBits`
```flux
op lowReverseBits (as int64: value, as int64: width) as int64
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
  - `width` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowReverseBits` no domínio `LowLevelBitInspectionContract`.

##### `op lowBitExtract`
```flux
op lowBitExtract (as int64: value, as int64: start_bit, as int64: num_bits) as int64
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
  - `start_bit` (`int64`): Parâmetro de entrada para processamento da operação.
  - `num_bits` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowBitExtract` no domínio `LowLevelBitInspectionContract`.

##### `op lowBitInsert`
```flux
op lowBitInsert (as int64: target, as int64: source, as int64: start_bit, as int64: num_bits) as int64
```
- **Parâmetros**:
  - `target` (`int64`): Parâmetro de entrada para processamento da operação.
  - `source` (`int64`): Parâmetro de entrada para processamento da operação.
  - `start_bit` (`int64`): Parâmetro de entrada para processamento da operação.
  - `num_bits` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowBitInsert` no domínio `LowLevelBitInspectionContract`.

### 4.3 Contrato `LowLevelBitwiseContract` (`LowLevelBitwise.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `lowBitAnd` | `op lowBitAnd (as int64: a, as int64: b) as int64` | `int64` |
| `lowBitOr` | `op lowBitOr (as int64: a, as int64: b) as int64` | `int64` |
| `lowBitXor` | `op lowBitXor (as int64: a, as int64: b) as int64` | `int64` |
| `lowBitNot` | `op lowBitNot (as int64: a) as int64` | `int64` |
| `lowBitNand` | `op lowBitNand (as int64: a, as int64: b) as int64` | `int64` |
| `lowBitNor` | `op lowBitNor (as int64: a, as int64: b) as int64` | `int64` |
| `lowBitXnor` | `op lowBitXnor (as int64: a, as int64: b) as int64` | `int64` |

#### Ficha Técnica das Operações:

##### `op lowBitAnd`
```flux
op lowBitAnd (as int64: a, as int64: b) as int64
```
- **Parâmetros**:
  - `a` (`int64`): Parâmetro de entrada para processamento da operação.
  - `b` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowBitAnd` no domínio `LowLevelBitwiseContract`.

##### `op lowBitOr`
```flux
op lowBitOr (as int64: a, as int64: b) as int64
```
- **Parâmetros**:
  - `a` (`int64`): Parâmetro de entrada para processamento da operação.
  - `b` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowBitOr` no domínio `LowLevelBitwiseContract`.

##### `op lowBitXor`
```flux
op lowBitXor (as int64: a, as int64: b) as int64
```
- **Parâmetros**:
  - `a` (`int64`): Parâmetro de entrada para processamento da operação.
  - `b` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowBitXor` no domínio `LowLevelBitwiseContract`.

##### `op lowBitNot`
```flux
op lowBitNot (as int64: a) as int64
```
- **Parâmetros**:
  - `a` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowBitNot` no domínio `LowLevelBitwiseContract`.

##### `op lowBitNand`
```flux
op lowBitNand (as int64: a, as int64: b) as int64
```
- **Parâmetros**:
  - `a` (`int64`): Parâmetro de entrada para processamento da operação.
  - `b` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowBitNand` no domínio `LowLevelBitwiseContract`.

##### `op lowBitNor`
```flux
op lowBitNor (as int64: a, as int64: b) as int64
```
- **Parâmetros**:
  - `a` (`int64`): Parâmetro de entrada para processamento da operação.
  - `b` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowBitNor` no domínio `LowLevelBitwiseContract`.

##### `op lowBitXnor`
```flux
op lowBitXnor (as int64: a, as int64: b) as int64
```
- **Parâmetros**:
  - `a` (`int64`): Parâmetro de entrada para processamento da operação.
  - `b` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowBitXnor` no domínio `LowLevelBitwiseContract`.

### 4.4 Contrato `LowLevelBlockMemoryContract` (`LowLevelBlockMemory.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `lowMemoryCopy` | `op lowMemoryCopy (as map: mem, as int64: src_addr, as int64: dst_addr, as int64: count) as map` | `map` |
| `lowMemorySet` | `op lowMemorySet (as map: mem, as int64: dst_addr, as int64: byte_val, as int64: count) as map` | `map` |
| `lowMemoryCompare` | `op lowMemoryCompare (as map: mem, as int64: addr1, as int64: addr2, as int64: count) as int64` | `int64` |
| `lowMemoryClear` | `op lowMemoryClear (as map: mem, as int64: address, as int64: count) as map` | `map` |
| `lowMemoryDump` | `op lowMemoryDump (as map: mem, as int64: address, as int64: count) as string` | `string` |

#### Ficha Técnica das Operações:

##### `op lowMemoryCopy`
```flux
op lowMemoryCopy (as map: mem, as int64: src_addr, as int64: dst_addr, as int64: count) as map
```
- **Parâmetros**:
  - `mem` (`map`): Parâmetro de entrada para processamento da operação.
  - `src_addr` (`int64`): Parâmetro de entrada para processamento da operação.
  - `dst_addr` (`int64`): Parâmetro de entrada para processamento da operação.
  - `count` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowMemoryCopy` no domínio `LowLevelBlockMemoryContract`.

##### `op lowMemorySet`
```flux
op lowMemorySet (as map: mem, as int64: dst_addr, as int64: byte_val, as int64: count) as map
```
- **Parâmetros**:
  - `mem` (`map`): Parâmetro de entrada para processamento da operação.
  - `dst_addr` (`int64`): Parâmetro de entrada para processamento da operação.
  - `byte_val` (`int64`): Parâmetro de entrada para processamento da operação.
  - `count` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowMemorySet` no domínio `LowLevelBlockMemoryContract`.

##### `op lowMemoryCompare`
```flux
op lowMemoryCompare (as map: mem, as int64: addr1, as int64: addr2, as int64: count) as int64
```
- **Parâmetros**:
  - `mem` (`map`): Parâmetro de entrada para processamento da operação.
  - `addr1` (`int64`): Parâmetro de entrada para processamento da operação.
  - `addr2` (`int64`): Parâmetro de entrada para processamento da operação.
  - `count` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowMemoryCompare` no domínio `LowLevelBlockMemoryContract`.

##### `op lowMemoryClear`
```flux
op lowMemoryClear (as map: mem, as int64: address, as int64: count) as map
```
- **Parâmetros**:
  - `mem` (`map`): Parâmetro de entrada para processamento da operação.
  - `address` (`int64`): Parâmetro de entrada para processamento da operação.
  - `count` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowMemoryClear` no domínio `LowLevelBlockMemoryContract`.

##### `op lowMemoryDump`
```flux
op lowMemoryDump (as map: mem, as int64: address, as int64: count) as string
```
- **Parâmetros**:
  - `mem` (`map`): Parâmetro de entrada para processamento da operação.
  - `address` (`int64`): Parâmetro de entrada para processamento da operação.
  - `count` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowMemoryDump` no domínio `LowLevelBlockMemoryContract`.

### 4.5 Contrato `LowLevelBufferContract` (`LowLevelBuffer.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `lowBufferNew` | `op lowBufferNew (as int64: capacity) as map` | `map` |
| `lowBufferLength` | `op lowBufferLength (as map: buf) as int64` | `int64` |
| `lowBufferCapacity` | `op lowBufferCapacity (as map: buf) as int64` | `int64` |
| `lowBufferWriteByte` | `op lowBufferWriteByte (as map: buf, as int64: val) as map` | `map` |
| `lowBufferWriteHWord` | `op lowBufferWriteHWord (as map: buf, as int64: val) as map` | `map` |
| `lowBufferWriteWord` | `op lowBufferWriteWord (as map: buf, as int64: val) as map` | `map` |
| `lowBufferWriteDWord` | `op lowBufferWriteDWord (as map: buf, as int64: val) as map` | `map` |
| `lowBufferReadByte` | `op lowBufferReadByte (as map: buf, as int64: offset) as int64` | `int64` |
| `lowBufferReadHWord` | `op lowBufferReadHWord (as map: buf, as int64: offset) as int64` | `int64` |
| `lowBufferReadWord` | `op lowBufferReadWord (as map: buf, as int64: offset) as int64` | `int64` |
| `lowBufferReadDWord` | `op lowBufferReadDWord (as map: buf, as int64: offset) as int64` | `int64` |
| `lowBufferToHex` | `op lowBufferToHex (as map: buf) as string` | `string` |
| `lowBufferFromHex` | `op lowBufferFromHex (as string: hex_str) as map` | `map` |

#### Ficha Técnica das Operações:

##### `op lowBufferNew`
```flux
op lowBufferNew (as int64: capacity) as map
```
- **Parâmetros**:
  - `capacity` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowBufferNew` no domínio `LowLevelBufferContract`.

##### `op lowBufferLength`
```flux
op lowBufferLength (as map: buf) as int64
```
- **Parâmetros**:
  - `buf` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowBufferLength` no domínio `LowLevelBufferContract`.

##### `op lowBufferCapacity`
```flux
op lowBufferCapacity (as map: buf) as int64
```
- **Parâmetros**:
  - `buf` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowBufferCapacity` no domínio `LowLevelBufferContract`.

##### `op lowBufferWriteByte`
```flux
op lowBufferWriteByte (as map: buf, as int64: val) as map
```
- **Parâmetros**:
  - `buf` (`map`): Parâmetro de entrada para processamento da operação.
  - `val` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowBufferWriteByte` no domínio `LowLevelBufferContract`.

##### `op lowBufferWriteHWord`
```flux
op lowBufferWriteHWord (as map: buf, as int64: val) as map
```
- **Parâmetros**:
  - `buf` (`map`): Parâmetro de entrada para processamento da operação.
  - `val` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowBufferWriteHWord` no domínio `LowLevelBufferContract`.

##### `op lowBufferWriteWord`
```flux
op lowBufferWriteWord (as map: buf, as int64: val) as map
```
- **Parâmetros**:
  - `buf` (`map`): Parâmetro de entrada para processamento da operação.
  - `val` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowBufferWriteWord` no domínio `LowLevelBufferContract`.

##### `op lowBufferWriteDWord`
```flux
op lowBufferWriteDWord (as map: buf, as int64: val) as map
```
- **Parâmetros**:
  - `buf` (`map`): Parâmetro de entrada para processamento da operação.
  - `val` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowBufferWriteDWord` no domínio `LowLevelBufferContract`.

##### `op lowBufferReadByte`
```flux
op lowBufferReadByte (as map: buf, as int64: offset) as int64
```
- **Parâmetros**:
  - `buf` (`map`): Parâmetro de entrada para processamento da operação.
  - `offset` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowBufferReadByte` no domínio `LowLevelBufferContract`.

##### `op lowBufferReadHWord`
```flux
op lowBufferReadHWord (as map: buf, as int64: offset) as int64
```
- **Parâmetros**:
  - `buf` (`map`): Parâmetro de entrada para processamento da operação.
  - `offset` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowBufferReadHWord` no domínio `LowLevelBufferContract`.

##### `op lowBufferReadWord`
```flux
op lowBufferReadWord (as map: buf, as int64: offset) as int64
```
- **Parâmetros**:
  - `buf` (`map`): Parâmetro de entrada para processamento da operação.
  - `offset` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowBufferReadWord` no domínio `LowLevelBufferContract`.

##### `op lowBufferReadDWord`
```flux
op lowBufferReadDWord (as map: buf, as int64: offset) as int64
```
- **Parâmetros**:
  - `buf` (`map`): Parâmetro de entrada para processamento da operação.
  - `offset` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowBufferReadDWord` no domínio `LowLevelBufferContract`.

##### `op lowBufferToHex`
```flux
op lowBufferToHex (as map: buf) as string
```
- **Parâmetros**:
  - `buf` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowBufferToHex` no domínio `LowLevelBufferContract`.

##### `op lowBufferFromHex`
```flux
op lowBufferFromHex (as string: hex_str) as map
```
- **Parâmetros**:
  - `hex_str` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowBufferFromHex` no domínio `LowLevelBufferContract`.

### 4.6 Contrato `LowLevelConstantsContract` (`LowLevelConstants.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `mask8` | `op mask8 () as int64` | `int64` |
| `mask16` | `op mask16 () as int64` | `int64` |
| `mask32` | `op mask32 () as int64` | `int64` |
| `mask64` | `op mask64 () as int64` | `int64` |
| `int8Min` | `op int8Min () as int64` | `int64` |
| `int8Max` | `op int8Max () as int64` | `int64` |
| `uint8Max` | `op uint8Max () as int64` | `int64` |
| `int16Min` | `op int16Min () as int64` | `int64` |
| `int16Max` | `op int16Max () as int64` | `int64` |
| `uint16Max` | `op uint16Max () as int64` | `int64` |
| `int32Min` | `op int32Min () as int64` | `int64` |
| `int32Max` | `op int32Max () as int64` | `int64` |
| `uint32Max` | `op uint32Max () as int64` | `int64` |
| `int64Min` | `op int64Min () as int64` | `int64` |
| `int64Max` | `op int64Max () as int64` | `int64` |
| `sizeByte` | `op sizeByte () as int64` | `int64` |
| `sizeHWord` | `op sizeHWord () as int64` | `int64` |
| `sizeWord` | `op sizeWord () as int64` | `int64` |
| `sizeDWord` | `op sizeDWord () as int64` | `int64` |
| `bitsByte` | `op bitsByte () as int64` | `int64` |
| `bitsHWord` | `op bitsHWord () as int64` | `int64` |
| `bitsWord` | `op bitsWord () as int64` | `int64` |
| `bitsDWord` | `op bitsDWord () as int64` | `int64` |
| `pageSize4K` | `op pageSize4K () as int64` | `int64` |
| `pageSizeHuge2M` | `op pageSizeHuge2M () as int64` | `int64` |
| `cacheLineSize` | `op cacheLineSize () as int64` | `int64` |
| `endianLittle` | `op endianLittle () as int64` | `int64` |
| `endianBig` | `op endianBig () as int64` | `int64` |

#### Ficha Técnica das Operações:

##### `op mask8`
```flux
op mask8 () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mask8` no domínio `LowLevelConstantsContract`.

##### `op mask16`
```flux
op mask16 () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mask16` no domínio `LowLevelConstantsContract`.

##### `op mask32`
```flux
op mask32 () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mask32` no domínio `LowLevelConstantsContract`.

##### `op mask64`
```flux
op mask64 () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mask64` no domínio `LowLevelConstantsContract`.

##### `op int8Min`
```flux
op int8Min () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `int8Min` no domínio `LowLevelConstantsContract`.

##### `op int8Max`
```flux
op int8Max () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `int8Max` no domínio `LowLevelConstantsContract`.

##### `op uint8Max`
```flux
op uint8Max () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `uint8Max` no domínio `LowLevelConstantsContract`.

##### `op int16Min`
```flux
op int16Min () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `int16Min` no domínio `LowLevelConstantsContract`.

##### `op int16Max`
```flux
op int16Max () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `int16Max` no domínio `LowLevelConstantsContract`.

##### `op uint16Max`
```flux
op uint16Max () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `uint16Max` no domínio `LowLevelConstantsContract`.

##### `op int32Min`
```flux
op int32Min () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `int32Min` no domínio `LowLevelConstantsContract`.

##### `op int32Max`
```flux
op int32Max () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `int32Max` no domínio `LowLevelConstantsContract`.

##### `op uint32Max`
```flux
op uint32Max () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `uint32Max` no domínio `LowLevelConstantsContract`.

##### `op int64Min`
```flux
op int64Min () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `int64Min` no domínio `LowLevelConstantsContract`.

##### `op int64Max`
```flux
op int64Max () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `int64Max` no domínio `LowLevelConstantsContract`.

##### `op sizeByte`
```flux
op sizeByte () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `sizeByte` no domínio `LowLevelConstantsContract`.

##### `op sizeHWord`
```flux
op sizeHWord () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `sizeHWord` no domínio `LowLevelConstantsContract`.

##### `op sizeWord`
```flux
op sizeWord () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `sizeWord` no domínio `LowLevelConstantsContract`.

##### `op sizeDWord`
```flux
op sizeDWord () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `sizeDWord` no domínio `LowLevelConstantsContract`.

##### `op bitsByte`
```flux
op bitsByte () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `bitsByte` no domínio `LowLevelConstantsContract`.

##### `op bitsHWord`
```flux
op bitsHWord () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `bitsHWord` no domínio `LowLevelConstantsContract`.

##### `op bitsWord`
```flux
op bitsWord () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `bitsWord` no domínio `LowLevelConstantsContract`.

##### `op bitsDWord`
```flux
op bitsDWord () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `bitsDWord` no domínio `LowLevelConstantsContract`.

##### `op pageSize4K`
```flux
op pageSize4K () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `pageSize4K` no domínio `LowLevelConstantsContract`.

##### `op pageSizeHuge2M`
```flux
op pageSizeHuge2M () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `pageSizeHuge2M` no domínio `LowLevelConstantsContract`.

##### `op cacheLineSize`
```flux
op cacheLineSize () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `cacheLineSize` no domínio `LowLevelConstantsContract`.

##### `op endianLittle`
```flux
op endianLittle () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `endianLittle` no domínio `LowLevelConstantsContract`.

##### `op endianBig`
```flux
op endianBig () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `endianBig` no domínio `LowLevelConstantsContract`.

### 4.7 Contrato `LowLevelEndiannessContract` (`LowLevelEndianness.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `lowByteSwap16` | `op lowByteSwap16 (as int64: v) as int64` | `int64` |
| `lowByteSwap32` | `op lowByteSwap32 (as int64: v) as int64` | `int64` |
| `lowByteSwap64` | `op lowByteSwap64 (as int64: v) as int64` | `int64` |
| `lowHostToNetwork16` | `op lowHostToNetwork16 (as int64: v) as int64` | `int64` |
| `lowNetworkToHost16` | `op lowNetworkToHost16 (as int64: v) as int64` | `int64` |
| `lowHostToNetwork32` | `op lowHostToNetwork32 (as int64: v) as int64` | `int64` |
| `lowNetworkToHost32` | `op lowNetworkToHost32 (as int64: v) as int64` | `int64` |
| `lowHostToNetwork64` | `op lowHostToNetwork64 (as int64: v) as int64` | `int64` |
| `lowNetworkToHost64` | `op lowNetworkToHost64 (as int64: v) as int64` | `int64` |

#### Ficha Técnica das Operações:

##### `op lowByteSwap16`
```flux
op lowByteSwap16 (as int64: v) as int64
```
- **Parâmetros**:
  - `v` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowByteSwap16` no domínio `LowLevelEndiannessContract`.

##### `op lowByteSwap32`
```flux
op lowByteSwap32 (as int64: v) as int64
```
- **Parâmetros**:
  - `v` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowByteSwap32` no domínio `LowLevelEndiannessContract`.

##### `op lowByteSwap64`
```flux
op lowByteSwap64 (as int64: v) as int64
```
- **Parâmetros**:
  - `v` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowByteSwap64` no domínio `LowLevelEndiannessContract`.

##### `op lowHostToNetwork16`
```flux
op lowHostToNetwork16 (as int64: v) as int64
```
- **Parâmetros**:
  - `v` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowHostToNetwork16` no domínio `LowLevelEndiannessContract`.

##### `op lowNetworkToHost16`
```flux
op lowNetworkToHost16 (as int64: v) as int64
```
- **Parâmetros**:
  - `v` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowNetworkToHost16` no domínio `LowLevelEndiannessContract`.

##### `op lowHostToNetwork32`
```flux
op lowHostToNetwork32 (as int64: v) as int64
```
- **Parâmetros**:
  - `v` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowHostToNetwork32` no domínio `LowLevelEndiannessContract`.

##### `op lowNetworkToHost32`
```flux
op lowNetworkToHost32 (as int64: v) as int64
```
- **Parâmetros**:
  - `v` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowNetworkToHost32` no domínio `LowLevelEndiannessContract`.

##### `op lowHostToNetwork64`
```flux
op lowHostToNetwork64 (as int64: v) as int64
```
- **Parâmetros**:
  - `v` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowHostToNetwork64` no domínio `LowLevelEndiannessContract`.

##### `op lowNetworkToHost64`
```flux
op lowNetworkToHost64 (as int64: v) as int64
```
- **Parâmetros**:
  - `v` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowNetworkToHost64` no domínio `LowLevelEndiannessContract`.

### 4.8 Contrato `LowLevelMemoryAccessContract` (`LowLevelMemoryAccess.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `lowMemoryInit` | `op lowMemoryInit (as int64: size_bytes) as map` | `map` |
| `lowMemoryPeekByte` | `op lowMemoryPeekByte (as map: mem, as int64: address) as int64` | `int64` |
| `lowMemoryPokeByte` | `op lowMemoryPokeByte (as map: mem, as int64: address, as int64: value) as map` | `map` |
| `lowMemoryPeekHWord` | `op lowMemoryPeekHWord (as map: mem, as int64: address) as int64` | `int64` |
| `lowMemoryPokeHWord` | `op lowMemoryPokeHWord (as map: mem, as int64: address, as int64: value) as map` | `map` |
| `lowMemoryPeekWord` | `op lowMemoryPeekWord (as map: mem, as int64: address) as int64` | `int64` |
| `lowMemoryPokeWord` | `op lowMemoryPokeWord (as map: mem, as int64: address, as int64: value) as map` | `map` |
| `lowMemoryPeekDWord` | `op lowMemoryPeekDWord (as map: mem, as int64: address) as int64` | `int64` |
| `lowMemoryPokeDWord` | `op lowMemoryPokeDWord (as map: mem, as int64: address, as int64: value) as map` | `map` |
| `lowByteGet` | `op lowByteGet (as int64: value, as int64: byte_index) as int64` | `int64` |
| `lowByteSet` | `op lowByteSet (as int64: value, as int64: byte_index, as int64: byte_val) as int64` | `int64` |
| `lowHWordGet` | `op lowHWordGet (as int64: value, as int64: hword_index) as int64` | `int64` |
| `lowWordGet` | `op lowWordGet (as int64: value, as int64: word_index) as int64` | `int64` |
| `lowMakeHWord` | `op lowMakeHWord (as int64: b0, as int64: b1) as int64` | `int64` |
| `lowMakeWord` | `op lowMakeWord (as int64: b0, as int64: b1, as int64: b2, as int64: b3) as int64` | `int64` |
| `lowMakeDWord` | `op lowMakeDWord (as int64: w0, as int64: w1) as int64` | `int64` |

#### Ficha Técnica das Operações:

##### `op lowMemoryInit`
```flux
op lowMemoryInit (as int64: size_bytes) as map
```
- **Parâmetros**:
  - `size_bytes` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowMemoryInit` no domínio `LowLevelMemoryAccessContract`.

##### `op lowMemoryPeekByte`
```flux
op lowMemoryPeekByte (as map: mem, as int64: address) as int64
```
- **Parâmetros**:
  - `mem` (`map`): Parâmetro de entrada para processamento da operação.
  - `address` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowMemoryPeekByte` no domínio `LowLevelMemoryAccessContract`.

##### `op lowMemoryPokeByte`
```flux
op lowMemoryPokeByte (as map: mem, as int64: address, as int64: value) as map
```
- **Parâmetros**:
  - `mem` (`map`): Parâmetro de entrada para processamento da operação.
  - `address` (`int64`): Parâmetro de entrada para processamento da operação.
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowMemoryPokeByte` no domínio `LowLevelMemoryAccessContract`.

##### `op lowMemoryPeekHWord`
```flux
op lowMemoryPeekHWord (as map: mem, as int64: address) as int64
```
- **Parâmetros**:
  - `mem` (`map`): Parâmetro de entrada para processamento da operação.
  - `address` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowMemoryPeekHWord` no domínio `LowLevelMemoryAccessContract`.

##### `op lowMemoryPokeHWord`
```flux
op lowMemoryPokeHWord (as map: mem, as int64: address, as int64: value) as map
```
- **Parâmetros**:
  - `mem` (`map`): Parâmetro de entrada para processamento da operação.
  - `address` (`int64`): Parâmetro de entrada para processamento da operação.
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowMemoryPokeHWord` no domínio `LowLevelMemoryAccessContract`.

##### `op lowMemoryPeekWord`
```flux
op lowMemoryPeekWord (as map: mem, as int64: address) as int64
```
- **Parâmetros**:
  - `mem` (`map`): Parâmetro de entrada para processamento da operação.
  - `address` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowMemoryPeekWord` no domínio `LowLevelMemoryAccessContract`.

##### `op lowMemoryPokeWord`
```flux
op lowMemoryPokeWord (as map: mem, as int64: address, as int64: value) as map
```
- **Parâmetros**:
  - `mem` (`map`): Parâmetro de entrada para processamento da operação.
  - `address` (`int64`): Parâmetro de entrada para processamento da operação.
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowMemoryPokeWord` no domínio `LowLevelMemoryAccessContract`.

##### `op lowMemoryPeekDWord`
```flux
op lowMemoryPeekDWord (as map: mem, as int64: address) as int64
```
- **Parâmetros**:
  - `mem` (`map`): Parâmetro de entrada para processamento da operação.
  - `address` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowMemoryPeekDWord` no domínio `LowLevelMemoryAccessContract`.

##### `op lowMemoryPokeDWord`
```flux
op lowMemoryPokeDWord (as map: mem, as int64: address, as int64: value) as map
```
- **Parâmetros**:
  - `mem` (`map`): Parâmetro de entrada para processamento da operação.
  - `address` (`int64`): Parâmetro de entrada para processamento da operação.
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowMemoryPokeDWord` no domínio `LowLevelMemoryAccessContract`.

##### `op lowByteGet`
```flux
op lowByteGet (as int64: value, as int64: byte_index) as int64
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
  - `byte_index` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowByteGet` no domínio `LowLevelMemoryAccessContract`.

##### `op lowByteSet`
```flux
op lowByteSet (as int64: value, as int64: byte_index, as int64: byte_val) as int64
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
  - `byte_index` (`int64`): Parâmetro de entrada para processamento da operação.
  - `byte_val` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowByteSet` no domínio `LowLevelMemoryAccessContract`.

##### `op lowHWordGet`
```flux
op lowHWordGet (as int64: value, as int64: hword_index) as int64
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
  - `hword_index` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowHWordGet` no domínio `LowLevelMemoryAccessContract`.

##### `op lowWordGet`
```flux
op lowWordGet (as int64: value, as int64: word_index) as int64
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
  - `word_index` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowWordGet` no domínio `LowLevelMemoryAccessContract`.

##### `op lowMakeHWord`
```flux
op lowMakeHWord (as int64: b0, as int64: b1) as int64
```
- **Parâmetros**:
  - `b0` (`int64`): Parâmetro de entrada para processamento da operação.
  - `b1` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowMakeHWord` no domínio `LowLevelMemoryAccessContract`.

##### `op lowMakeWord`
```flux
op lowMakeWord (as int64: b0, as int64: b1, as int64: b2, as int64: b3) as int64
```
- **Parâmetros**:
  - `b0` (`int64`): Parâmetro de entrada para processamento da operação.
  - `b1` (`int64`): Parâmetro de entrada para processamento da operação.
  - `b2` (`int64`): Parâmetro de entrada para processamento da operação.
  - `b3` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowMakeWord` no domínio `LowLevelMemoryAccessContract`.

##### `op lowMakeDWord`
```flux
op lowMakeDWord (as int64: w0, as int64: w1) as int64
```
- **Parâmetros**:
  - `w0` (`int64`): Parâmetro de entrada para processamento da operação.
  - `w1` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowMakeDWord` no domínio `LowLevelMemoryAccessContract`.

### 4.9 Contrato `LowLevelShiftRotateContract` (`LowLevelShiftRotate.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `lowShiftLeft` | `op lowShiftLeft (as int64: value, as int64: bits) as int64` | `int64` |
| `lowShiftRight` | `op lowShiftRight (as int64: value, as int64: bits) as int64` | `int64` |
| `lowShiftRightLogical` | `op lowShiftRightLogical (as int64: value, as int64: bits) as int64` | `int64` |
| `lowRotateLeft` | `op lowRotateLeft (as int64: value, as int64: bits, as int64: width) as int64` | `int64` |
| `lowRotateRight` | `op lowRotateRight (as int64: value, as int64: bits, as int64: width) as int64` | `int64` |
| `lowRotateLeft64` | `op lowRotateLeft64 (as int64: value, as int64: bits) as int64` | `int64` |
| `lowRotateRight64` | `op lowRotateRight64 (as int64: value, as int64: bits) as int64` | `int64` |
| `lowRotateLeft32` | `op lowRotateLeft32 (as int64: value, as int64: bits) as int64` | `int64` |
| `lowRotateRight32` | `op lowRotateRight32 (as int64: value, as int64: bits) as int64` | `int64` |

#### Ficha Técnica das Operações:

##### `op lowShiftLeft`
```flux
op lowShiftLeft (as int64: value, as int64: bits) as int64
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
  - `bits` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowShiftLeft` no domínio `LowLevelShiftRotateContract`.

##### `op lowShiftRight`
```flux
op lowShiftRight (as int64: value, as int64: bits) as int64
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
  - `bits` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowShiftRight` no domínio `LowLevelShiftRotateContract`.

##### `op lowShiftRightLogical`
```flux
op lowShiftRightLogical (as int64: value, as int64: bits) as int64
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
  - `bits` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowShiftRightLogical` no domínio `LowLevelShiftRotateContract`.

##### `op lowRotateLeft`
```flux
op lowRotateLeft (as int64: value, as int64: bits, as int64: width) as int64
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
  - `bits` (`int64`): Parâmetro de entrada para processamento da operação.
  - `width` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowRotateLeft` no domínio `LowLevelShiftRotateContract`.

##### `op lowRotateRight`
```flux
op lowRotateRight (as int64: value, as int64: bits, as int64: width) as int64
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
  - `bits` (`int64`): Parâmetro de entrada para processamento da operação.
  - `width` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowRotateRight` no domínio `LowLevelShiftRotateContract`.

##### `op lowRotateLeft64`
```flux
op lowRotateLeft64 (as int64: value, as int64: bits) as int64
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
  - `bits` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowRotateLeft64` no domínio `LowLevelShiftRotateContract`.

##### `op lowRotateRight64`
```flux
op lowRotateRight64 (as int64: value, as int64: bits) as int64
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
  - `bits` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowRotateRight64` no domínio `LowLevelShiftRotateContract`.

##### `op lowRotateLeft32`
```flux
op lowRotateLeft32 (as int64: value, as int64: bits) as int64
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
  - `bits` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowRotateLeft32` no domínio `LowLevelShiftRotateContract`.

##### `op lowRotateRight32`
```flux
op lowRotateRight32 (as int64: value, as int64: bits) as int64
```
- **Parâmetros**:
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
  - `bits` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lowRotateRight32` no domínio `LowLevelShiftRotateContract`.

---

## 5. Exemplos Canônicos de Uso em TheFlux

O exemplo a seguir demonstra a importação e o consumo prático da biblioteca:

```flux
# Exemplo Canônico de Consumo da LowLevelStdLib
use LowLevelStdLib

program (ExemploLowLevelStdLib) {
      println("==================================================")
      println("  Demonstracao da Standard Library: LowLevelStdLib")
      println("==================================================")

      # Chamada da operacao canônica
      mut as data: resultado = LowLevelStdLib::lowLevelSwapBytes32(0x12345678)
      println("Resultado obtido: " + resultado)

      println("Demonstracao concluida com sucesso.")
}
```

---

> [!TIP]
> Para consultar a visão arquitetural unificada de todas as bibliotecas, consulte o documento principal [StdLibs.md](../StdLibs.md).
