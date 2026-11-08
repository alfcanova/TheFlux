# 📚 `HashStdLib` — Cryptographic, Fast Hash Functions, and Integrity Verification

> **Architectural Pillar**: Pillar 3 (Mathematics & Graphics)  
> **Status**: ✅ Certified with 100% Parity across 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Master File**: `stdlib/HashStdLib/HashStdLib.fdsl`  
> **Import Mode**: `use HashStdLib` or `use HashStdLib::<Module>::<operation>`

---

## 1. Overview and Capabilities

The **`HashStdLib`** standard library is an integral component of the official TheFlux language ecosystem, providing certified system-level algorithms and robust capabilities.

Standard cryptographic hashes (SHA-256, SHA-512, SHA-1, MD5), transmission checksums (CRC32, Adler32), and zero-overhead non-cryptographic hashers for in-memory lookup tables (MurmurHash3, FNV-1a, CityHash).

### 1.1 Key Architectural Principles and Design
- **Static Fusion and Zero-Overhead**: All domain modules are transparently fused into the `HashStdLib` unified agent at compile time, avoiding virtual dispatch penalties.
- **Safety and Isolation**: Operations strictly validate parameter bounds and guarantee predictable error semantics via contract definitions.
- **Universal Multi-Backend Parity**: Bit-for-bit identical execution guarantees across interpreter (`in`), bytecode VM (`vm`, `vmr`), native AOT LLVM (`llvm`), and WebAssembly (`wat`, `wasm`).

---

## 2. Modular Structure and Contracts

The library comprises **6 domain modules** declaring a total of **48 public operations**:

| Domain Source File | Formal Contract | Domain Responsibility | Ops Count |
|---|---|---|:---:|
| `HashChecksum.fdsl` | `HashChecksumContract` | Specialized domain for `HashChecksum` | 8 |
| `HashCrypto.fdsl` | `HashCryptoContract` | Specialized domain for `HashCrypto` | 14 |
| `HashDistributed.fdsl` | `HashDistributedContract` | Specialized domain for `HashDistributed` | 4 |
| `HashFast.fdsl` | `HashFastContract` | Specialized domain for `HashFast` | 11 |
| `HashInteger.fdsl` | `HashIntegerContract` | Specialized domain for `HashInteger` | 5 |
| `HashSecurity.fdsl` | `HashSecurityContract` | Specialized domain for `HashSecurity` | 6 |

---

## 3. Public Types, Structures, and Enumerations

The `HashStdLib` library operates directly on primitive native TheFlux types (`string`, `int64`, `float64`, `bool`, `list of data`, etc.) without requiring custom composite types.

---

## 4. Detailed Operations Catalog by Domain

### 4.1 Contract `HashChecksumContract` (`HashChecksum.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `hashCrc16` | `op hashCrc16 (as string: text) as int64` | `int64` |
| `hashCrc32` | `op hashCrc32 (as string: text) as int64` | `int64` |
| `hashCrc64` | `op hashCrc64 (as string: text) as int64` | `int64` |
| `hashAdler32` | `op hashAdler32 (as string: text) as int64` | `int64` |
| `hashFletcher16` | `op hashFletcher16 (as string: text) as int64` | `int64` |
| `hashBsdChecksum` | `op hashBsdChecksum (as string: text) as int64` | `int64` |
| `hashSysVChecksum` | `op hashSysVChecksum (as string: text) as int64` | `int64` |
| `hashLuhn` | `op hashLuhn (as string: digits) as bool` | `bool` |

#### Operation Technical Specifications:

##### `op hashCrc16`
```flux
op hashCrc16 (as string: text) as int64
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `hashCrc16` functionality within the `HashChecksumContract` domain.

##### `op hashCrc32`
```flux
op hashCrc32 (as string: text) as int64
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `hashCrc32` functionality within the `HashChecksumContract` domain.

##### `op hashCrc64`
```flux
op hashCrc64 (as string: text) as int64
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `hashCrc64` functionality within the `HashChecksumContract` domain.

##### `op hashAdler32`
```flux
op hashAdler32 (as string: text) as int64
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `hashAdler32` functionality within the `HashChecksumContract` domain.

##### `op hashFletcher16`
```flux
op hashFletcher16 (as string: text) as int64
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `hashFletcher16` functionality within the `HashChecksumContract` domain.

##### `op hashBsdChecksum`
```flux
op hashBsdChecksum (as string: text) as int64
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `hashBsdChecksum` functionality within the `HashChecksumContract` domain.

##### `op hashSysVChecksum`
```flux
op hashSysVChecksum (as string: text) as int64
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `hashSysVChecksum` functionality within the `HashChecksumContract` domain.

##### `op hashLuhn`
```flux
op hashLuhn (as string: digits) as bool
```
- **Parameters**:
  - `digits` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `hashLuhn` functionality within the `HashChecksumContract` domain.

### 4.2 Contract `HashCryptoContract` (`HashCrypto.fdsl`)

| Operation | Formal Signature | Return Type |
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

#### Operation Technical Specifications:

##### `op hashMd5`
```flux
op hashMd5 (as string: text) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `hashMd5` functionality within the `HashCryptoContract` domain.

##### `op hashSha1`
```flux
op hashSha1 (as string: text) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `hashSha1` functionality within the `HashCryptoContract` domain.

##### `op hashSha224`
```flux
op hashSha224 (as string: text) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `hashSha224` functionality within the `HashCryptoContract` domain.

##### `op hashSha256`
```flux
op hashSha256 (as string: text) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `hashSha256` functionality within the `HashCryptoContract` domain.

##### `op hashSha384`
```flux
op hashSha384 (as string: text) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `hashSha384` functionality within the `HashCryptoContract` domain.

##### `op hashSha512`
```flux
op hashSha512 (as string: text) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `hashSha512` functionality within the `HashCryptoContract` domain.

##### `op hashSha3224`
```flux
op hashSha3224 (as string: text) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `hashSha3224` functionality within the `HashCryptoContract` domain.

##### `op hashSha3256`
```flux
op hashSha3256 (as string: text) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `hashSha3256` functionality within the `HashCryptoContract` domain.

##### `op hashSha3384`
```flux
op hashSha3384 (as string: text) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `hashSha3384` functionality within the `HashCryptoContract` domain.

##### `op hashSha3512`
```flux
op hashSha3512 (as string: text) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `hashSha3512` functionality within the `HashCryptoContract` domain.

##### `op hashRipemd160`
```flux
op hashRipemd160 (as string: text) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `hashRipemd160` functionality within the `HashCryptoContract` domain.

##### `op hashBlake2s`
```flux
op hashBlake2s (as string: text) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `hashBlake2s` functionality within the `HashCryptoContract` domain.

##### `op hashBlake3`
```flux
op hashBlake3 (as string: text) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `hashBlake3` functionality within the `HashCryptoContract` domain.

##### `op hashAscon`
```flux
op hashAscon (as string: text) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `hashAscon` functionality within the `HashCryptoContract` domain.

### 4.3 Contract `HashDistributedContract` (`HashDistributed.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `hashJumpConsistent` | `op hashJumpConsistent (as int64: key, as int64: num_buckets) as int64` | `int64` |
| `hashBloomIndices` | `op hashBloomIndices (as string: key, as int64: num_hashes, as int64: filter_size) as list of data` | `list of data` |
| `hashSimHash` | `op hashSimHash (as string: text) as string` | `string` |
| `hashMinHash` | `op hashMinHash (as string: text, as int64: num_hashes) as list of data` | `list of data` |

#### Operation Technical Specifications:

##### `op hashJumpConsistent`
```flux
op hashJumpConsistent (as int64: key, as int64: num_buckets) as int64
```
- **Parameters**:
  - `key` (`int64`): Input argument for operation execution.
  - `num_buckets` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `hashJumpConsistent` functionality within the `HashDistributedContract` domain.

##### `op hashBloomIndices`
```flux
op hashBloomIndices (as string: key, as int64: num_hashes, as int64: filter_size) as list of data
```
- **Parameters**:
  - `key` (`string`): Input argument for operation execution.
  - `num_hashes` (`int64`): Input argument for operation execution.
  - `filter_size` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `hashBloomIndices` functionality within the `HashDistributedContract` domain.

##### `op hashSimHash`
```flux
op hashSimHash (as string: text) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `hashSimHash` functionality within the `HashDistributedContract` domain.

##### `op hashMinHash`
```flux
op hashMinHash (as string: text, as int64: num_hashes) as list of data
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
  - `num_hashes` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `hashMinHash` functionality within the `HashDistributedContract` domain.

### 4.4 Contract `HashFastContract` (`HashFast.fdsl`)

| Operation | Formal Signature | Return Type |
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

#### Operation Technical Specifications:

##### `op hashDjb2`
```flux
op hashDjb2 (as string: text) as int64
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `hashDjb2` functionality within the `HashFastContract` domain.

##### `op hashDjb2a`
```flux
op hashDjb2a (as string: text) as int64
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `hashDjb2a` functionality within the `HashFastContract` domain.

##### `op hashSdbm`
```flux
op hashSdbm (as string: text) as int64
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `hashSdbm` functionality within the `HashFastContract` domain.

##### `op hashFnv1a32`
```flux
op hashFnv1a32 (as string: text) as int64
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `hashFnv1a32` functionality within the `HashFastContract` domain.

##### `op hashFnv1a64`
```flux
op hashFnv1a64 (as string: text) as int64
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `hashFnv1a64` functionality within the `HashFastContract` domain.

##### `op hashMurmur3`
```flux
op hashMurmur3 (as string: text) as int64
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `hashMurmur3` functionality within the `HashFastContract` domain.

##### `op hashXxHash64`
```flux
op hashXxHash64 (as string: text) as int64
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `hashXxHash64` functionality within the `HashFastContract` domain.

##### `op hashXxh3`
```flux
op hashXxh3 (as string: text) as int64
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `hashXxh3` functionality within the `HashFastContract` domain.

##### `op hashCombine`
```flux
op hashCombine (as int64: h1, as int64: h2) as int64
```
- **Parameters**:
  - `h1` (`int64`): Input argument for operation execution.
  - `h2` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `hashCombine` functionality within the `HashFastContract` domain.

##### `op hashRolling`
```flux
op hashRolling (as string: text) as int64
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `hashRolling` functionality within the `HashFastContract` domain.

##### `op hashRollingUpdate`
```flux
op hashRollingUpdate (as int64: old_hash, as string: old_char, as string: new_char, as int64: len) as int64
```
- **Parameters**:
  - `old_hash` (`int64`): Input argument for operation execution.
  - `old_char` (`string`): Input argument for operation execution.
  - `new_char` (`string`): Input argument for operation execution.
  - `len` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `hashRollingUpdate` functionality within the `HashFastContract` domain.

### 4.5 Contract `HashIntegerContract` (`HashInteger.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `hashInt32` | `op hashInt32 (as int64: val) as int64` | `int64` |
| `hashInt64` | `op hashInt64 (as int64: val) as int64` | `int64` |
| `hashFibonacci` | `op hashFibonacci (as int64: val, as int64: num_bits) as int64` | `int64` |
| `hashJenkins32` | `op hashJenkins32 (as int64: val) as int64` | `int64` |
| `hashZobrist` | `op hashZobrist (as int64: piece, as int64: square) as int64` | `int64` |

#### Operation Technical Specifications:

##### `op hashInt32`
```flux
op hashInt32 (as int64: val) as int64
```
- **Parameters**:
  - `val` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `hashInt32` functionality within the `HashIntegerContract` domain.

##### `op hashInt64`
```flux
op hashInt64 (as int64: val) as int64
```
- **Parameters**:
  - `val` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `hashInt64` functionality within the `HashIntegerContract` domain.

##### `op hashFibonacci`
```flux
op hashFibonacci (as int64: val, as int64: num_bits) as int64
```
- **Parameters**:
  - `val` (`int64`): Input argument for operation execution.
  - `num_bits` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `hashFibonacci` functionality within the `HashIntegerContract` domain.

##### `op hashJenkins32`
```flux
op hashJenkins32 (as int64: val) as int64
```
- **Parameters**:
  - `val` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `hashJenkins32` functionality within the `HashIntegerContract` domain.

##### `op hashZobrist`
```flux
op hashZobrist (as int64: piece, as int64: square) as int64
```
- **Parameters**:
  - `piece` (`int64`): Input argument for operation execution.
  - `square` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `hashZobrist` functionality within the `HashIntegerContract` domain.

### 4.6 Contract `HashSecurityContract` (`HashSecurity.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `hashHex` | `op hashHex (as int64: hash_val) as string` | `string` |
| `hashHmac` | `op hashHmac (as string: key, as string: message) as string` | `string` |
| `hashHmacSha256` | `op hashHmacSha256 (as string: key, as string: message) as string` | `string` |
| `hashHmacMd5` | `op hashHmacMd5 (as string: key, as string: message) as string` | `string` |
| `hashPbkdf2` | `op hashPbkdf2 (as string: password, as string: salt, as int64: iterations) as string` | `string` |
| `hashVerify` | `op hashVerify (as string: text, as string: expected_hash) as bool` | `bool` |

#### Operation Technical Specifications:

##### `op hashHex`
```flux
op hashHex (as int64: hash_val) as string
```
- **Parameters**:
  - `hash_val` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `hashHex` functionality within the `HashSecurityContract` domain.

##### `op hashHmac`
```flux
op hashHmac (as string: key, as string: message) as string
```
- **Parameters**:
  - `key` (`string`): Input argument for operation execution.
  - `message` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `hashHmac` functionality within the `HashSecurityContract` domain.

##### `op hashHmacSha256`
```flux
op hashHmacSha256 (as string: key, as string: message) as string
```
- **Parameters**:
  - `key` (`string`): Input argument for operation execution.
  - `message` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `hashHmacSha256` functionality within the `HashSecurityContract` domain.

##### `op hashHmacMd5`
```flux
op hashHmacMd5 (as string: key, as string: message) as string
```
- **Parameters**:
  - `key` (`string`): Input argument for operation execution.
  - `message` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `hashHmacMd5` functionality within the `HashSecurityContract` domain.

##### `op hashPbkdf2`
```flux
op hashPbkdf2 (as string: password, as string: salt, as int64: iterations) as string
```
- **Parameters**:
  - `password` (`string`): Input argument for operation execution.
  - `salt` (`string`): Input argument for operation execution.
  - `iterations` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `hashPbkdf2` functionality within the `HashSecurityContract` domain.

##### `op hashVerify`
```flux
op hashVerify (as string: text, as string: expected_hash) as bool
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
  - `expected_hash` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `hashVerify` functionality within the `HashSecurityContract` domain.

---

## 5. Canonical Usage Examples in TheFlux

The following snippet illustrates importing and utilizing the library in a TheFlux program:

```flux
# Canonical Usage Example for HashStdLib
use HashStdLib

program (ExampleOfHashStdLib) {
      println("==================================================")
      println("  Standard Library Demonstration: HashStdLib")
      println("==================================================")

      # Invoking canonical operation
      mut as data: result = HashStdLib::sha256("TheFlux")
      println("Obtained result: " + result)

      println("Execution completed successfully.")
}
```

---

> [!TIP]
> For the complete unified architecture across all standard libraries, consult the master [StdLibs.md](../StdLibs.md) reference.
