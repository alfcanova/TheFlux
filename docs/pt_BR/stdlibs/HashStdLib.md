# 📚 `HashStdLib` — Funções Hash Criptográficas, Rápidas e Verificação de Integridade

> **Pilar Arquitetural**: Pilar 3 (Matemática & Gráficos)  
> **Status**: ✅ Homologado com 100% de Paridade nos 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Arquivo Mestre**: `stdlib/HashStdLib/HashStdLib.fdsl`  
> **Modo de Importação**: `use HashStdLib` ou `use HashStdLib::<Modulo>::<operacao>`

---

## 1. Visão Geral e Funcionalidades

A biblioteca padrão **`HashStdLib`** integra o ecossistema oficial da linguagem TheFlux, fornecendo suporte de nível de sistema e algoritmos nativos certificados.

Algoritmos de dispersão criptográfica segura (SHA-256, SHA-512, SHA-1, MD5), checksums de integridade de dados (CRC32, Adler32) e funções hash não-criptográficas ultrarrápidas para tabelas de espalhamento (MurmurHash3, FNV-1a, CityHash).

### 1.1 Características e Princípios de Design
- **Compilação e Fusão Estática**: Todos os módulos de domínio são fundidos no agente unificado `HashStdLib` em tempo de compilação, sem sobrecarga (*overhead*) de despacho indireto.
- **Isolamento e Segurança**: As operações verificam limites operacionais e utilizam despacho por contratos formais rigorosos.
- **Compatibilidade Multi-Backend**: Execução bit-a-bit idêntica em interpretador (`in`), bytecode (`vm`, `vmr`), nativo AOT (`llvm`) e WebAssembly (`wat`, `wasm`).

---

## 2. Estrutura Modular e Contratos

A biblioteca é composta por **6 módulos de domínio** e declara **48 operações públicas**:

| Arquivo de Domínio | Contrato Formal | Responsabilidade Principal | Qtd. Ops |
|---|---|---|:---:|
| `HashChecksum.fdsl` | `HashChecksumContract` | Domínio especializado de `HashChecksum` | 8 |
| `HashCrypto.fdsl` | `HashCryptoContract` | Domínio especializado de `HashCrypto` | 14 |
| `HashDistributed.fdsl` | `HashDistributedContract` | Domínio especializado de `HashDistributed` | 4 |
| `HashFast.fdsl` | `HashFastContract` | Domínio especializado de `HashFast` | 11 |
| `HashInteger.fdsl` | `HashIntegerContract` | Domínio especializado de `HashInteger` | 5 |
| `HashSecurity.fdsl` | `HashSecurityContract` | Domínio especializado de `HashSecurity` | 6 |

---

## 3. Tipos, Estruturas e Enumerações Públicas

A biblioteca `HashStdLib` opera diretamente com os tipos nativos e primitivos da linguagem TheFlux (`string`, `int64`, `float64`, `bool`, `list of data`, etc.), sem exigir tipos compostos adicionais.

---

## 4. Catálogo Detalhado de Operações por Domínio

### 4.1 Contrato `HashChecksumContract` (`HashChecksum.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `hashCrc16` | `op hashCrc16 (as string: text) as int64` | `int64` |
| `hashCrc32` | `op hashCrc32 (as string: text) as int64` | `int64` |
| `hashCrc64` | `op hashCrc64 (as string: text) as int64` | `int64` |
| `hashAdler32` | `op hashAdler32 (as string: text) as int64` | `int64` |
| `hashFletcher16` | `op hashFletcher16 (as string: text) as int64` | `int64` |
| `hashBsdChecksum` | `op hashBsdChecksum (as string: text) as int64` | `int64` |
| `hashSysVChecksum` | `op hashSysVChecksum (as string: text) as int64` | `int64` |
| `hashLuhn` | `op hashLuhn (as string: digits) as bool` | `bool` |

#### Ficha Técnica das Operações:

##### `op hashCrc16`
```flux
op hashCrc16 (as string: text) as int64
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `hashCrc16` no domínio `HashChecksumContract`.

##### `op hashCrc32`
```flux
op hashCrc32 (as string: text) as int64
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `hashCrc32` no domínio `HashChecksumContract`.

##### `op hashCrc64`
```flux
op hashCrc64 (as string: text) as int64
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `hashCrc64` no domínio `HashChecksumContract`.

##### `op hashAdler32`
```flux
op hashAdler32 (as string: text) as int64
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `hashAdler32` no domínio `HashChecksumContract`.

##### `op hashFletcher16`
```flux
op hashFletcher16 (as string: text) as int64
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `hashFletcher16` no domínio `HashChecksumContract`.

##### `op hashBsdChecksum`
```flux
op hashBsdChecksum (as string: text) as int64
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `hashBsdChecksum` no domínio `HashChecksumContract`.

##### `op hashSysVChecksum`
```flux
op hashSysVChecksum (as string: text) as int64
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `hashSysVChecksum` no domínio `HashChecksumContract`.

##### `op hashLuhn`
```flux
op hashLuhn (as string: digits) as bool
```
- **Parâmetros**:
  - `digits` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `hashLuhn` no domínio `HashChecksumContract`.

### 4.2 Contrato `HashCryptoContract` (`HashCrypto.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `hashMd5` | `op hashMd5 (as string: text) as string` | `string` |
| `hashSha1` | `op hashSha1 (as string: text) as string` | `string` |
| `hashSha224` | `op hashSha224 (as string: text) as string` | `string` |
| `hashSha256` | `op hashSha256 (as string: text) as string` | `string` |
| `hashSha384` | `op hashSha384 (as string: text) as string` | `string` |
| `hashSha512` | `op hashSha512 (as string: text) as string` | `string` |
| `hashSha3224` | `op hashSha3224 (as string: text) as string` | `string` |
| `hashSha3256` | `op hashSha3256 (as string: text) as string` | `string` |
| `hashSha3384` | `op hashSha3384 (as string: text) as string` | `string` |
| `hashSha3512` | `op hashSha3512 (as string: text) as string` | `string` |
| `hashRipemd160` | `op hashRipemd160 (as string: text) as string` | `string` |
| `hashBlake2s` | `op hashBlake2s (as string: text) as string` | `string` |
| `hashBlake3` | `op hashBlake3 (as string: text) as string` | `string` |
| `hashAscon` | `op hashAscon (as string: text) as string` | `string` |

#### Ficha Técnica das Operações:

##### `op hashMd5`
```flux
op hashMd5 (as string: text) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `hashMd5` no domínio `HashCryptoContract`.

##### `op hashSha1`
```flux
op hashSha1 (as string: text) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `hashSha1` no domínio `HashCryptoContract`.

##### `op hashSha224`
```flux
op hashSha224 (as string: text) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `hashSha224` no domínio `HashCryptoContract`.

##### `op hashSha256`
```flux
op hashSha256 (as string: text) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `hashSha256` no domínio `HashCryptoContract`.

##### `op hashSha384`
```flux
op hashSha384 (as string: text) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `hashSha384` no domínio `HashCryptoContract`.

##### `op hashSha512`
```flux
op hashSha512 (as string: text) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `hashSha512` no domínio `HashCryptoContract`.

##### `op hashSha3224`
```flux
op hashSha3224 (as string: text) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `hashSha3224` no domínio `HashCryptoContract`.

##### `op hashSha3256`
```flux
op hashSha3256 (as string: text) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `hashSha3256` no domínio `HashCryptoContract`.

##### `op hashSha3384`
```flux
op hashSha3384 (as string: text) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `hashSha3384` no domínio `HashCryptoContract`.

##### `op hashSha3512`
```flux
op hashSha3512 (as string: text) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `hashSha3512` no domínio `HashCryptoContract`.

##### `op hashRipemd160`
```flux
op hashRipemd160 (as string: text) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `hashRipemd160` no domínio `HashCryptoContract`.

##### `op hashBlake2s`
```flux
op hashBlake2s (as string: text) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `hashBlake2s` no domínio `HashCryptoContract`.

##### `op hashBlake3`
```flux
op hashBlake3 (as string: text) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `hashBlake3` no domínio `HashCryptoContract`.

##### `op hashAscon`
```flux
op hashAscon (as string: text) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `hashAscon` no domínio `HashCryptoContract`.

### 4.3 Contrato `HashDistributedContract` (`HashDistributed.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `hashJumpConsistent` | `op hashJumpConsistent (as int64: key, as int64: num_buckets) as int64` | `int64` |
| `hashBloomIndices` | `op hashBloomIndices (as string: key, as int64: num_hashes, as int64: filter_size) as list of data` | `list of data` |
| `hashSimHash` | `op hashSimHash (as string: text) as string` | `string` |
| `hashMinHash` | `op hashMinHash (as string: text, as int64: num_hashes) as list of data` | `list of data` |

#### Ficha Técnica das Operações:

##### `op hashJumpConsistent`
```flux
op hashJumpConsistent (as int64: key, as int64: num_buckets) as int64
```
- **Parâmetros**:
  - `key` (`int64`): Parâmetro de entrada para processamento da operação.
  - `num_buckets` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `hashJumpConsistent` no domínio `HashDistributedContract`.

##### `op hashBloomIndices`
```flux
op hashBloomIndices (as string: key, as int64: num_hashes, as int64: filter_size) as list of data
```
- **Parâmetros**:
  - `key` (`string`): Parâmetro de entrada para processamento da operação.
  - `num_hashes` (`int64`): Parâmetro de entrada para processamento da operação.
  - `filter_size` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `hashBloomIndices` no domínio `HashDistributedContract`.

##### `op hashSimHash`
```flux
op hashSimHash (as string: text) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `hashSimHash` no domínio `HashDistributedContract`.

##### `op hashMinHash`
```flux
op hashMinHash (as string: text, as int64: num_hashes) as list of data
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
  - `num_hashes` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `hashMinHash` no domínio `HashDistributedContract`.

### 4.4 Contrato `HashFastContract` (`HashFast.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `hashDjb2` | `op hashDjb2 (as string: text) as int64` | `int64` |
| `hashDjb2a` | `op hashDjb2a (as string: text) as int64` | `int64` |
| `hashSdbm` | `op hashSdbm (as string: text) as int64` | `int64` |
| `hashFnv1a32` | `op hashFnv1a32 (as string: text) as int64` | `int64` |
| `hashFnv1a64` | `op hashFnv1a64 (as string: text) as int64` | `int64` |
| `hashMurmur3` | `op hashMurmur3 (as string: text) as int64` | `int64` |
| `hashXxHash64` | `op hashXxHash64 (as string: text) as int64` | `int64` |
| `hashXxh3` | `op hashXxh3 (as string: text) as int64` | `int64` |
| `hashCombine` | `op hashCombine (as int64: h1, as int64: h2) as int64` | `int64` |
| `hashRolling` | `op hashRolling (as string: text) as int64` | `int64` |
| `hashRollingUpdate` | `op hashRollingUpdate (as int64: old_hash, as string: old_char, as string: new_char, as int64: len) as int64` | `int64` |

#### Ficha Técnica das Operações:

##### `op hashDjb2`
```flux
op hashDjb2 (as string: text) as int64
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `hashDjb2` no domínio `HashFastContract`.

##### `op hashDjb2a`
```flux
op hashDjb2a (as string: text) as int64
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `hashDjb2a` no domínio `HashFastContract`.

##### `op hashSdbm`
```flux
op hashSdbm (as string: text) as int64
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `hashSdbm` no domínio `HashFastContract`.

##### `op hashFnv1a32`
```flux
op hashFnv1a32 (as string: text) as int64
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `hashFnv1a32` no domínio `HashFastContract`.

##### `op hashFnv1a64`
```flux
op hashFnv1a64 (as string: text) as int64
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `hashFnv1a64` no domínio `HashFastContract`.

##### `op hashMurmur3`
```flux
op hashMurmur3 (as string: text) as int64
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `hashMurmur3` no domínio `HashFastContract`.

##### `op hashXxHash64`
```flux
op hashXxHash64 (as string: text) as int64
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `hashXxHash64` no domínio `HashFastContract`.

##### `op hashXxh3`
```flux
op hashXxh3 (as string: text) as int64
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `hashXxh3` no domínio `HashFastContract`.

##### `op hashCombine`
```flux
op hashCombine (as int64: h1, as int64: h2) as int64
```
- **Parâmetros**:
  - `h1` (`int64`): Parâmetro de entrada para processamento da operação.
  - `h2` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `hashCombine` no domínio `HashFastContract`.

##### `op hashRolling`
```flux
op hashRolling (as string: text) as int64
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `hashRolling` no domínio `HashFastContract`.

##### `op hashRollingUpdate`
```flux
op hashRollingUpdate (as int64: old_hash, as string: old_char, as string: new_char, as int64: len) as int64
```
- **Parâmetros**:
  - `old_hash` (`int64`): Parâmetro de entrada para processamento da operação.
  - `old_char` (`string`): Parâmetro de entrada para processamento da operação.
  - `new_char` (`string`): Parâmetro de entrada para processamento da operação.
  - `len` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `hashRollingUpdate` no domínio `HashFastContract`.

### 4.5 Contrato `HashIntegerContract` (`HashInteger.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `hashInt32` | `op hashInt32 (as int64: val) as int64` | `int64` |
| `hashInt64` | `op hashInt64 (as int64: val) as int64` | `int64` |
| `hashFibonacci` | `op hashFibonacci (as int64: val, as int64: num_bits) as int64` | `int64` |
| `hashJenkins32` | `op hashJenkins32 (as int64: val) as int64` | `int64` |
| `hashZobrist` | `op hashZobrist (as int64: piece, as int64: square) as int64` | `int64` |

#### Ficha Técnica das Operações:

##### `op hashInt32`
```flux
op hashInt32 (as int64: val) as int64
```
- **Parâmetros**:
  - `val` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `hashInt32` no domínio `HashIntegerContract`.

##### `op hashInt64`
```flux
op hashInt64 (as int64: val) as int64
```
- **Parâmetros**:
  - `val` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `hashInt64` no domínio `HashIntegerContract`.

##### `op hashFibonacci`
```flux
op hashFibonacci (as int64: val, as int64: num_bits) as int64
```
- **Parâmetros**:
  - `val` (`int64`): Parâmetro de entrada para processamento da operação.
  - `num_bits` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `hashFibonacci` no domínio `HashIntegerContract`.

##### `op hashJenkins32`
```flux
op hashJenkins32 (as int64: val) as int64
```
- **Parâmetros**:
  - `val` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `hashJenkins32` no domínio `HashIntegerContract`.

##### `op hashZobrist`
```flux
op hashZobrist (as int64: piece, as int64: square) as int64
```
- **Parâmetros**:
  - `piece` (`int64`): Parâmetro de entrada para processamento da operação.
  - `square` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `hashZobrist` no domínio `HashIntegerContract`.

### 4.6 Contrato `HashSecurityContract` (`HashSecurity.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `hashHex` | `op hashHex (as int64: hash_val) as string` | `string` |
| `hashHmac` | `op hashHmac (as string: key, as string: message) as string` | `string` |
| `hashHmacSha256` | `op hashHmacSha256 (as string: key, as string: message) as string` | `string` |
| `hashHmacMd5` | `op hashHmacMd5 (as string: key, as string: message) as string` | `string` |
| `hashPbkdf2` | `op hashPbkdf2 (as string: password, as string: salt, as int64: iterations) as string` | `string` |
| `hashVerify` | `op hashVerify (as string: text, as string: expected_hash) as bool` | `bool` |

#### Ficha Técnica das Operações:

##### `op hashHex`
```flux
op hashHex (as int64: hash_val) as string
```
- **Parâmetros**:
  - `hash_val` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `hashHex` no domínio `HashSecurityContract`.

##### `op hashHmac`
```flux
op hashHmac (as string: key, as string: message) as string
```
- **Parâmetros**:
  - `key` (`string`): Parâmetro de entrada para processamento da operação.
  - `message` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `hashHmac` no domínio `HashSecurityContract`.

##### `op hashHmacSha256`
```flux
op hashHmacSha256 (as string: key, as string: message) as string
```
- **Parâmetros**:
  - `key` (`string`): Parâmetro de entrada para processamento da operação.
  - `message` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `hashHmacSha256` no domínio `HashSecurityContract`.

##### `op hashHmacMd5`
```flux
op hashHmacMd5 (as string: key, as string: message) as string
```
- **Parâmetros**:
  - `key` (`string`): Parâmetro de entrada para processamento da operação.
  - `message` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `hashHmacMd5` no domínio `HashSecurityContract`.

##### `op hashPbkdf2`
```flux
op hashPbkdf2 (as string: password, as string: salt, as int64: iterations) as string
```
- **Parâmetros**:
  - `password` (`string`): Parâmetro de entrada para processamento da operação.
  - `salt` (`string`): Parâmetro de entrada para processamento da operação.
  - `iterations` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `hashPbkdf2` no domínio `HashSecurityContract`.

##### `op hashVerify`
```flux
op hashVerify (as string: text, as string: expected_hash) as bool
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
  - `expected_hash` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `hashVerify` no domínio `HashSecurityContract`.

---

## 5. Exemplos Canônicos de Uso em TheFlux

O exemplo a seguir demonstra a importação e o consumo prático da biblioteca:

```flux
# Exemplo Canônico de Consumo da HashStdLib
use HashStdLib

program (ExemploHashStdLib) {
      println("==================================================")
      println("  Demonstracao da Standard Library: HashStdLib")
      println("==================================================")

      # Chamada da operacao canônica
      mut as data: resultado = HashStdLib::sha256("TheFlux")
      println("Resultado obtido: " + resultado)

      println("Demonstracao concluida com sucesso.")
}
```

---

> [!TIP]
> Para consultar a visão arquitetural unificada de todas as bibliotecas, consulte o documento principal [StdLibs.md](../StdLibs.md).
