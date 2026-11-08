# 📚 `CompressStdLib` — Data Stream Compression and Decompression with Safe Quotas

> **Architectural Pillar**: Pillar 2 (Structures & State)  
> **Status**: ✅ Certified with 100% Parity across 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Master File**: `stdlib/CompressStdLib/CompressStdLib.fdsl`  
> **Import Mode**: `use CompressStdLib` or `use CompressStdLib::<Module>::<operation>`

---

## 1. Overview and Capabilities

The **`CompressStdLib`** standard library is an integral component of the official TheFlux language ecosystem, providing certified system-level algorithms and robust capabilities.

Implements high-performance memory and streaming compression/decompression engines for GZIP, DEFLATE, ZLIB, BZIP2, LZMA, XZ, and ZSTD. Features expansion quota safeguards (DecompressQuota) to neutralize zip-bomb attack vectors.

### 1.1 Key Architectural Principles and Design
- **Static Fusion and Zero-Overhead**: All domain modules are transparently fused into the `CompressStdLib` unified agent at compile time, avoiding virtual dispatch penalties.
- **Safety and Isolation**: Operations strictly validate parameter bounds and guarantee predictable error semantics via contract definitions.
- **Universal Multi-Backend Parity**: Bit-for-bit identical execution guarantees across interpreter (`in`), bytecode VM (`vm`, `vmr`), native AOT LLVM (`llvm`), and WebAssembly (`wat`, `wasm`).

---

## 2. Modular Structure and Contracts

The library comprises **8 domain modules** declaring a total of **49 public operations**:

| Domain Source File | Formal Contract | Domain Responsibility | Ops Count |
|---|---|---|:---:|
| `CompressBzip2.fdsl` | `CompressBzip2Contract` | Specialized domain for `CompressBzip2` | 5 |
| `CompressDeflate.fdsl` | `CompressDeflateContract` | Specialized domain for `CompressDeflate` | 5 |
| `CompressGzip.fdsl` | `CompressGzipContract` | Specialized domain for `CompressGzip` | 7 |
| `CompressInspection.fdsl` | `CompressInspectionContract` | Specialized domain for `CompressInspection` | 6 |
| `CompressLzma.fdsl` | `CompressLzmaContract` | Specialized domain for `CompressLzma` | 5 |
| `CompressXz.fdsl` | `CompressXzContract` | Specialized domain for `CompressXz` | 9 |
| `CompressZlib.fdsl` | `CompressZlibContract` | Specialized domain for `CompressZlib` | 6 |
| `CompressZstd.fdsl` | `CompressZstdContract` | Specialized domain for `CompressZstd` | 6 |

---

## 3. Public Types, Structures, and Enumerations

### Structure `struct (CompressStats)`
*Declared in: `CompressStdLib.fdsl`*

```flux
struct (CompressStats) {
      imut: .uncompressed_size: int64
      imut: .compressed_size: int64
      imut: .ratio: float64
      imut: .savings_percent: float64
      imut: .format: CompressFormat
}
```

### Structure `struct (DecompressQuota)`
*Declared in: `CompressStdLib.fdsl`*

```flux
struct (DecompressQuota) {
      mut: .max_bytes: int64
      mut: .strict_abort: bool
}
```

### Enumeration `enum (CompressFormat)`
*Declared in: `CompressStdLib.fdsl`*

```flux
enum (CompressFormat) {
      DEFLATE
      ZLIB
      GZIP
      BZIP2
      LZMA
      LZMA2
      XZ
      ZSTD
      BROTLI
      ZIP
      TAR
      SEVEN_ZIP
      RAR
      UNKNOWN
}
```

---

## 4. Detailed Operations Catalog by Domain

### 4.1 Contract `CompressBzip2Contract` (`CompressBzip2.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `compressBzip2` | `op compressBzip2 (as string: input_data) as string` | `string` |
| `compressBzip2Level` | `op compressBzip2Level (as string: input_data, as int64: level) as string` | `string` |
| `decompressBzip2` | `op decompressBzip2 (as string: compressed_data) as string` | `string` |
| `decompressBzip2Safe` | `op decompressBzip2Safe (as string: compressed_data, as DecompressQuota: quota) as string` | `string` |
| `compressIsBzip2` | `op compressIsBzip2 (as string: compressed_data) as bool` | `bool` |

#### Operation Technical Specifications:

##### `op compressBzip2`
```flux
op compressBzip2 (as string: input_data) as string
```
- **Parameters**:
  - `input_data` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `compressBzip2` functionality within the `CompressBzip2Contract` domain.

##### `op compressBzip2Level`
```flux
op compressBzip2Level (as string: input_data, as int64: level) as string
```
- **Parameters**:
  - `input_data` (`string`): Input argument for operation execution.
  - `level` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `compressBzip2Level` functionality within the `CompressBzip2Contract` domain.

##### `op decompressBzip2`
```flux
op decompressBzip2 (as string: compressed_data) as string
```
- **Parameters**:
  - `compressed_data` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ⚠️ Emits `fail` with status message `"erro na descompressao bzip2"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `decompressBzip2` functionality within the `CompressBzip2Contract` domain.

##### `op decompressBzip2Safe`
```flux
op decompressBzip2Safe (as string: compressed_data, as DecompressQuota: quota) as string
```
- **Parameters**:
  - `compressed_data` (`string`): Input argument for operation execution.
  - `quota` (`DecompressQuota`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ⚠️ Emits `fail` with status message `"quota de seguranca excedida na descompressao bzip2"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `decompressBzip2Safe` functionality within the `CompressBzip2Contract` domain.

##### `op compressIsBzip2`
```flux
op compressIsBzip2 (as string: compressed_data) as bool
```
- **Parameters**:
  - `compressed_data` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `compressIsBzip2` functionality within the `CompressBzip2Contract` domain.

### 4.2 Contract `CompressDeflateContract` (`CompressDeflate.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `compressDeflate` | `op compressDeflate (as string: input_data) as string` | `string` |
| `compressDeflateLevel` | `op compressDeflateLevel (as string: input_data, as int64: level) as string` | `string` |
| `decompressDeflate` | `op decompressDeflate (as string: compressed_data) as string` | `string` |
| `decompressDeflateSafe` | `op decompressDeflateSafe (as string: compressed_data, as DecompressQuota: quota) as string` | `string` |
| `compressIsDeflate` | `op compressIsDeflate (as string: compressed_data) as bool` | `bool` |

#### Operation Technical Specifications:

##### `op compressDeflate`
```flux
op compressDeflate (as string: input_data) as string
```
- **Parameters**:
  - `input_data` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `compressDeflate` functionality within the `CompressDeflateContract` domain.

##### `op compressDeflateLevel`
```flux
op compressDeflateLevel (as string: input_data, as int64: level) as string
```
- **Parameters**:
  - `input_data` (`string`): Input argument for operation execution.
  - `level` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `compressDeflateLevel` functionality within the `CompressDeflateContract` domain.

##### `op decompressDeflate`
```flux
op decompressDeflate (as string: compressed_data) as string
```
- **Parameters**:
  - `compressed_data` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ⚠️ Emits `fail` with status message `"erro na descompressao deflate"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `decompressDeflate` functionality within the `CompressDeflateContract` domain.

##### `op decompressDeflateSafe`
```flux
op decompressDeflateSafe (as string: compressed_data, as DecompressQuota: quota) as string
```
- **Parameters**:
  - `compressed_data` (`string`): Input argument for operation execution.
  - `quota` (`DecompressQuota`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ⚠️ Emits `fail` with status message `"quota de seguranca excedida na descompressao deflate"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `decompressDeflateSafe` functionality within the `CompressDeflateContract` domain.

##### `op compressIsDeflate`
```flux
op compressIsDeflate (as string: compressed_data) as bool
```
- **Parameters**:
  - `compressed_data` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `compressIsDeflate` functionality within the `CompressDeflateContract` domain.

### 4.3 Contract `CompressGzipContract` (`CompressGzip.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `compressGzip` | `op compressGzip (as string: input_data) as string` | `string` |
| `compressGzipLevel` | `op compressGzipLevel (as string: input_data, as int64: level) as string` | `string` |
| `decompressGzip` | `op decompressGzip (as string: compressed_data) as string` | `string` |
| `decompressGzipSafe` | `op decompressGzipSafe (as string: compressed_data, as DecompressQuota: quota) as string` | `string` |
| `compressIsGzip` | `op compressIsGzip (as string: compressed_data) as bool` | `bool` |
| `compressGzipCrc32` | `op compressGzipCrc32 (as string: compressed_data) as int64` | `int64` |
| `compressGzipTimestamp` | `op compressGzipTimestamp (as string: compressed_data) as int64` | `int64` |

#### Operation Technical Specifications:

##### `op compressGzip`
```flux
op compressGzip (as string: input_data) as string
```
- **Parameters**:
  - `input_data` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `compressGzip` functionality within the `CompressGzipContract` domain.

##### `op compressGzipLevel`
```flux
op compressGzipLevel (as string: input_data, as int64: level) as string
```
- **Parameters**:
  - `input_data` (`string`): Input argument for operation execution.
  - `level` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `compressGzipLevel` functionality within the `CompressGzipContract` domain.

##### `op decompressGzip`
```flux
op decompressGzip (as string: compressed_data) as string
```
- **Parameters**:
  - `compressed_data` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ⚠️ Emits `fail` with status message `"erro na descompressao gzip"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `decompressGzip` functionality within the `CompressGzipContract` domain.

##### `op decompressGzipSafe`
```flux
op decompressGzipSafe (as string: compressed_data, as DecompressQuota: quota) as string
```
- **Parameters**:
  - `compressed_data` (`string`): Input argument for operation execution.
  - `quota` (`DecompressQuota`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ⚠️ Emits `fail` with status message `"quota de seguranca excedida na descompressao gzip"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `decompressGzipSafe` functionality within the `CompressGzipContract` domain.

##### `op compressIsGzip`
```flux
op compressIsGzip (as string: compressed_data) as bool
```
- **Parameters**:
  - `compressed_data` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `compressIsGzip` functionality within the `CompressGzipContract` domain.

##### `op compressGzipCrc32`
```flux
op compressGzipCrc32 (as string: compressed_data) as int64
```
- **Parameters**:
  - `compressed_data` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `compressGzipCrc32` functionality within the `CompressGzipContract` domain.

##### `op compressGzipTimestamp`
```flux
op compressGzipTimestamp (as string: compressed_data) as int64
```
- **Parameters**:
  - `compressed_data` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `compressGzipTimestamp` functionality within the `CompressGzipContract` domain.

### 4.4 Contract `CompressInspectionContract` (`CompressInspection.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `compressEstimateDecompressedSize` | `op compressEstimateDecompressedSize (as string: compressed_data) as int64` | `int64` |
| `compressDetectFormat` | `op compressDetectFormat (as string: compressed_data) as string` | `string` |
| `compressStats` | `op compressStats (as string: uncompressed, as string: compressed) as CompressStats` | `CompressStats` |
| `decompressAuto` | `op decompressAuto (as string: compressed_data) as string` | `string` |
| `compressIsEffective` | `op compressIsEffective (as string: uncompressed, as string: compressed) as bool` | `bool` |
| `compressIsFormatSupported` | `op compressIsFormatSupported (as string: format_name) as bool` | `bool` |

#### Operation Technical Specifications:

##### `op compressEstimateDecompressedSize`
```flux
op compressEstimateDecompressedSize (as string: compressed_data) as int64
```
- **Parameters**:
  - `compressed_data` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `compressEstimateDecompressedSize` functionality within the `CompressInspectionContract` domain.

##### `op compressDetectFormat`
```flux
op compressDetectFormat (as string: compressed_data) as string
```
- **Parameters**:
  - `compressed_data` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `compressDetectFormat` functionality within the `CompressInspectionContract` domain.

##### `op compressStats`
```flux
op compressStats (as string: uncompressed, as string: compressed) as CompressStats
```
- **Parameters**:
  - `uncompressed` (`string`): Input argument for operation execution.
  - `compressed` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `CompressStats`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `compressStats` functionality within the `CompressInspectionContract` domain.

##### `op decompressAuto`
```flux
op decompressAuto (as string: compressed_data) as string
```
- **Parameters**:
  - `compressed_data` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ⚠️ Emits `fail` with status message `"formato nao suportado ou falha na auto-descompressao"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `decompressAuto` functionality within the `CompressInspectionContract` domain.

##### `op compressIsEffective`
```flux
op compressIsEffective (as string: uncompressed, as string: compressed) as bool
```
- **Parameters**:
  - `uncompressed` (`string`): Input argument for operation execution.
  - `compressed` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `compressIsEffective` functionality within the `CompressInspectionContract` domain.

##### `op compressIsFormatSupported`
```flux
op compressIsFormatSupported (as string: format_name) as bool
```
- **Parameters**:
  - `format_name` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `compressIsFormatSupported` functionality within the `CompressInspectionContract` domain.

### 4.5 Contract `CompressLzmaContract` (`CompressLzma.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `compressLzma` | `op compressLzma (as string: input_data) as string` | `string` |
| `compressLzmaLevel` | `op compressLzmaLevel (as string: input_data, as int64: level) as string` | `string` |
| `decompressLzma` | `op decompressLzma (as string: compressed_data) as string` | `string` |
| `decompressLzmaSafe` | `op decompressLzmaSafe (as string: compressed_data, as DecompressQuota: quota) as string` | `string` |
| `compressIsLzma` | `op compressIsLzma (as string: compressed_data) as bool` | `bool` |

#### Operation Technical Specifications:

##### `op compressLzma`
```flux
op compressLzma (as string: input_data) as string
```
- **Parameters**:
  - `input_data` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `compressLzma` functionality within the `CompressLzmaContract` domain.

##### `op compressLzmaLevel`
```flux
op compressLzmaLevel (as string: input_data, as int64: level) as string
```
- **Parameters**:
  - `input_data` (`string`): Input argument for operation execution.
  - `level` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `compressLzmaLevel` functionality within the `CompressLzmaContract` domain.

##### `op decompressLzma`
```flux
op decompressLzma (as string: compressed_data) as string
```
- **Parameters**:
  - `compressed_data` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ⚠️ Emits `fail` with status message `"erro na descompressao lzma"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `decompressLzma` functionality within the `CompressLzmaContract` domain.

##### `op decompressLzmaSafe`
```flux
op decompressLzmaSafe (as string: compressed_data, as DecompressQuota: quota) as string
```
- **Parameters**:
  - `compressed_data` (`string`): Input argument for operation execution.
  - `quota` (`DecompressQuota`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ⚠️ Emits `fail` with status message `"quota de seguranca excedida na descompressao lzma"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `decompressLzmaSafe` functionality within the `CompressLzmaContract` domain.

##### `op compressIsLzma`
```flux
op compressIsLzma (as string: compressed_data) as bool
```
- **Parameters**:
  - `compressed_data` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `compressIsLzma` functionality within the `CompressLzmaContract` domain.

### 4.6 Contract `CompressXzContract` (`CompressXz.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `compressLzma2` | `op compressLzma2 (as string: input_data) as string` | `string` |
| `compressLzma2Level` | `op compressLzma2Level (as string: input_data, as int64: level) as string` | `string` |
| `decompressLzma2` | `op decompressLzma2 (as string: compressed_data) as string` | `string` |
| `decompressLzma2Safe` | `op decompressLzma2Safe (as string: compressed_data, as DecompressQuota: quota) as string` | `string` |
| `compressXz` | `op compressXz (as string: input_data) as string` | `string` |
| `compressXzLevel` | `op compressXzLevel (as string: input_data, as int64: level) as string` | `string` |
| `decompressXz` | `op decompressXz (as string: compressed_data) as string` | `string` |
| `decompressXzSafe` | `op decompressXzSafe (as string: compressed_data, as DecompressQuota: quota) as string` | `string` |
| `compressIsXz` | `op compressIsXz (as string: compressed_data) as bool` | `bool` |

#### Operation Technical Specifications:

##### `op compressLzma2`
```flux
op compressLzma2 (as string: input_data) as string
```
- **Parameters**:
  - `input_data` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `compressLzma2` functionality within the `CompressXzContract` domain.

##### `op compressLzma2Level`
```flux
op compressLzma2Level (as string: input_data, as int64: level) as string
```
- **Parameters**:
  - `input_data` (`string`): Input argument for operation execution.
  - `level` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `compressLzma2Level` functionality within the `CompressXzContract` domain.

##### `op decompressLzma2`
```flux
op decompressLzma2 (as string: compressed_data) as string
```
- **Parameters**:
  - `compressed_data` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ⚠️ Emits `fail` with status message `"erro na descompressao lzma2"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `decompressLzma2` functionality within the `CompressXzContract` domain.

##### `op decompressLzma2Safe`
```flux
op decompressLzma2Safe (as string: compressed_data, as DecompressQuota: quota) as string
```
- **Parameters**:
  - `compressed_data` (`string`): Input argument for operation execution.
  - `quota` (`DecompressQuota`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ⚠️ Emits `fail` with status message `"quota de seguranca excedida na descompressao lzma2"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `decompressLzma2Safe` functionality within the `CompressXzContract` domain.

##### `op compressXz`
```flux
op compressXz (as string: input_data) as string
```
- **Parameters**:
  - `input_data` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `compressXz` functionality within the `CompressXzContract` domain.

##### `op compressXzLevel`
```flux
op compressXzLevel (as string: input_data, as int64: level) as string
```
- **Parameters**:
  - `input_data` (`string`): Input argument for operation execution.
  - `level` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `compressXzLevel` functionality within the `CompressXzContract` domain.

##### `op decompressXz`
```flux
op decompressXz (as string: compressed_data) as string
```
- **Parameters**:
  - `compressed_data` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ⚠️ Emits `fail` with status message `"erro na descompressao xz"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `decompressXz` functionality within the `CompressXzContract` domain.

##### `op decompressXzSafe`
```flux
op decompressXzSafe (as string: compressed_data, as DecompressQuota: quota) as string
```
- **Parameters**:
  - `compressed_data` (`string`): Input argument for operation execution.
  - `quota` (`DecompressQuota`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ⚠️ Emits `fail` with status message `"quota de seguranca excedida na descompressao xz"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `decompressXzSafe` functionality within the `CompressXzContract` domain.

##### `op compressIsXz`
```flux
op compressIsXz (as string: compressed_data) as bool
```
- **Parameters**:
  - `compressed_data` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `compressIsXz` functionality within the `CompressXzContract` domain.

### 4.7 Contract `CompressZlibContract` (`CompressZlib.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `compressZlib` | `op compressZlib (as string: input_data) as string` | `string` |
| `compressZlibLevel` | `op compressZlibLevel (as string: input_data, as int64: level) as string` | `string` |
| `decompressZlib` | `op decompressZlib (as string: compressed_data) as string` | `string` |
| `decompressZlibSafe` | `op decompressZlibSafe (as string: compressed_data, as DecompressQuota: quota) as string` | `string` |
| `compressIsZlib` | `op compressIsZlib (as string: compressed_data) as bool` | `bool` |
| `compressZlibAdler32` | `op compressZlibAdler32 (as string: compressed_data) as int64` | `int64` |

#### Operation Technical Specifications:

##### `op compressZlib`
```flux
op compressZlib (as string: input_data) as string
```
- **Parameters**:
  - `input_data` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `compressZlib` functionality within the `CompressZlibContract` domain.

##### `op compressZlibLevel`
```flux
op compressZlibLevel (as string: input_data, as int64: level) as string
```
- **Parameters**:
  - `input_data` (`string`): Input argument for operation execution.
  - `level` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `compressZlibLevel` functionality within the `CompressZlibContract` domain.

##### `op decompressZlib`
```flux
op decompressZlib (as string: compressed_data) as string
```
- **Parameters**:
  - `compressed_data` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ⚠️ Emits `fail` with status message `"erro na descompressao zlib"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `decompressZlib` functionality within the `CompressZlibContract` domain.

##### `op decompressZlibSafe`
```flux
op decompressZlibSafe (as string: compressed_data, as DecompressQuota: quota) as string
```
- **Parameters**:
  - `compressed_data` (`string`): Input argument for operation execution.
  - `quota` (`DecompressQuota`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ⚠️ Emits `fail` with status message `"quota de seguranca excedida na descompressao zlib"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `decompressZlibSafe` functionality within the `CompressZlibContract` domain.

##### `op compressIsZlib`
```flux
op compressIsZlib (as string: compressed_data) as bool
```
- **Parameters**:
  - `compressed_data` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `compressIsZlib` functionality within the `CompressZlibContract` domain.

##### `op compressZlibAdler32`
```flux
op compressZlibAdler32 (as string: compressed_data) as int64
```
- **Parameters**:
  - `compressed_data` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `compressZlibAdler32` functionality within the `CompressZlibContract` domain.

### 4.8 Contract `CompressZstdContract` (`CompressZstd.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `compressZstd` | `op compressZstd (as string: input_data) as string` | `string` |
| `compressZstdLevel` | `op compressZstdLevel (as string: input_data, as int64: level) as string` | `string` |
| `decompressZstd` | `op decompressZstd (as string: compressed_data) as string` | `string` |
| `decompressZstdSafe` | `op decompressZstdSafe (as string: compressed_data, as DecompressQuota: quota) as string` | `string` |
| `compressIsZstd` | `op compressIsZstd (as string: compressed_data) as bool` | `bool` |
| `compressZstdFrameSize` | `op compressZstdFrameSize (as string: compressed_data) as int64` | `int64` |

#### Operation Technical Specifications:

##### `op compressZstd`
```flux
op compressZstd (as string: input_data) as string
```
- **Parameters**:
  - `input_data` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `compressZstd` functionality within the `CompressZstdContract` domain.

##### `op compressZstdLevel`
```flux
op compressZstdLevel (as string: input_data, as int64: level) as string
```
- **Parameters**:
  - `input_data` (`string`): Input argument for operation execution.
  - `level` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `compressZstdLevel` functionality within the `CompressZstdContract` domain.

##### `op decompressZstd`
```flux
op decompressZstd (as string: compressed_data) as string
```
- **Parameters**:
  - `compressed_data` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ⚠️ Emits `fail` with status message `"erro na descompressao zstd"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `decompressZstd` functionality within the `CompressZstdContract` domain.

##### `op decompressZstdSafe`
```flux
op decompressZstdSafe (as string: compressed_data, as DecompressQuota: quota) as string
```
- **Parameters**:
  - `compressed_data` (`string`): Input argument for operation execution.
  - `quota` (`DecompressQuota`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ⚠️ Emits `fail` with status message `"quota de seguranca excedida na descompressao zstd"`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `decompressZstdSafe` functionality within the `CompressZstdContract` domain.

##### `op compressIsZstd`
```flux
op compressIsZstd (as string: compressed_data) as bool
```
- **Parameters**:
  - `compressed_data` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `compressIsZstd` functionality within the `CompressZstdContract` domain.

##### `op compressZstdFrameSize`
```flux
op compressZstdFrameSize (as string: compressed_data) as int64
```
- **Parameters**:
  - `compressed_data` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `compressZstdFrameSize` functionality within the `CompressZstdContract` domain.

---

## 5. Canonical Usage Examples in TheFlux

The following snippet illustrates importing and utilizing the library in a TheFlux program:

```flux
# Canonical Usage Example for CompressStdLib
use CompressStdLib

program (ExampleOfCompressStdLib) {
      println("==================================================")
      println("  Standard Library Demonstration: CompressStdLib")
      println("==================================================")

      # Invoking canonical operation
      mut as data: result = CompressStdLib::compressGzip("TheFlux Standard Library")
      println("Obtained result: " + result)

      println("Execution completed successfully.")
}
```

---

> [!TIP]
> For the complete unified architecture across all standard libraries, consult the master [StdLibs.md](../StdLibs.md) reference.
