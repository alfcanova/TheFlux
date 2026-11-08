# 📚 `FileSignatureStdLib` — File Format Identification via Magic Numbers and Signature Validation

> **Architectural Pillar**: Pillar 1 (Core, Text & OO)  
> **Status**: ✅ Certified with 100% Parity across 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Master File**: `stdlib/FileSignatureStdLib/FileSignatureStdLib.fdsl`  
> **Import Mode**: `use FileSignatureStdLib` or `use FileSignatureStdLib::<Module>::<operation>`

---

## 1. Overview and Capabilities

The **`FileSignatureStdLib`** standard library is an integral component of the official TheFlux language ecosystem, providing certified system-level algorithms and robust capabilities.

Reliable MIME and container file identification based on magic number inspection in binary headers, defeating extension spoofing and validating filesystem container signatures and directory structures.

### 1.1 Key Architectural Principles and Design
- **Static Fusion and Zero-Overhead**: All domain modules are transparently fused into the `FileSignatureStdLib` unified agent at compile time, avoiding virtual dispatch penalties.
- **Safety and Isolation**: Operations strictly validate parameter bounds and guarantee predictable error semantics via contract definitions.
- **Universal Multi-Backend Parity**: Bit-for-bit identical execution guarantees across interpreter (`in`), bytecode VM (`vm`, `vmr`), native AOT LLVM (`llvm`), and WebAssembly (`wat`, `wasm`).

---

## 2. Modular Structure and Contracts

The library comprises **4 domain modules** declaring a total of **17 public operations**:

| Domain Source File | Formal Contract | Domain Responsibility | Ops Count |
|---|---|---|:---:|
| `FileAuthSignature.fdsl` | `FileAuthSignatureContract` | Specialized domain for `FileAuthSignature` | 3 |
| `FileDirectorySignature.fdsl` | `FileDirectorySignatureContract` | Specialized domain for `FileDirectorySignature` | 4 |
| `FileFormatSignature.fdsl` | `FileFormatSignatureContract` | Specialized domain for `FileFormatSignature` | 3 |
| `FileHashSignature.fdsl` | `FileHashSignatureContract` | Specialized domain for `FileHashSignature` | 7 |

---

## 3. Public Types, Structures, and Enumerations

The `FileSignatureStdLib` library operates directly on primitive native TheFlux types (`string`, `int64`, `float64`, `bool`, `list of data`, etc.) without requiring custom composite types.

---

## 4. Detailed Operations Catalog by Domain

### 4.1 Contract `FileAuthSignatureContract` (`FileAuthSignature.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `fileHmacSha256` | `op fileHmacSha256 (as string: path, as string: key) as string` | `string` |
| `fileHmacMd5` | `op fileHmacMd5 (as string: path, as string: key) as string` | `string` |
| `fileVerifyHmac` | `op fileVerifyHmac (as string: path, as string: key, as string: expected_hmac) as bool` | `bool` |

#### Operation Technical Specifications:

##### `op fileHmacSha256`
```flux
op fileHmacSha256 (as string: path, as string: key) as string
```
- **Parameters**:
  - `path` (`string`): Input argument for operation execution.
  - `key` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `fileHmacSha256` functionality within the `FileAuthSignatureContract` domain.

##### `op fileHmacMd5`
```flux
op fileHmacMd5 (as string: path, as string: key) as string
```
- **Parameters**:
  - `path` (`string`): Input argument for operation execution.
  - `key` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `fileHmacMd5` functionality within the `FileAuthSignatureContract` domain.

##### `op fileVerifyHmac`
```flux
op fileVerifyHmac (as string: path, as string: key, as string: expected_hmac) as bool
```
- **Parameters**:
  - `path` (`string`): Input argument for operation execution.
  - `key` (`string`): Input argument for operation execution.
  - `expected_hmac` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `fileVerifyHmac` functionality within the `FileAuthSignatureContract` domain.

### 4.2 Contract `FileDirectorySignatureContract` (`FileDirectorySignature.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `fileSignDirectory` | `op fileSignDirectory (as string: dir_path) as list of data` | `list of data` |
| `fileFilterAndSign` | `op fileFilterAndSign (as string: dir_path, as string: extension) as list of data` | `list of data` |
| `fileCreateManifest` | `op fileCreateManifest (as string: dir_path) as string` | `string` |
| `fileChecksumManifest` | `op fileChecksumManifest (as string: manifest_content) as string` | `string` |

#### Operation Technical Specifications:

##### `op fileSignDirectory`
```flux
op fileSignDirectory (as string: dir_path) as list of data
```
- **Parameters**:
  - `dir_path` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `fileSignDirectory` functionality within the `FileDirectorySignatureContract` domain.

##### `op fileFilterAndSign`
```flux
op fileFilterAndSign (as string: dir_path, as string: extension) as list of data
```
- **Parameters**:
  - `dir_path` (`string`): Input argument for operation execution.
  - `extension` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `fileFilterAndSign` functionality within the `FileDirectorySignatureContract` domain.

##### `op fileCreateManifest`
```flux
op fileCreateManifest (as string: dir_path) as string
```
- **Parameters**:
  - `dir_path` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `fileCreateManifest` functionality within the `FileDirectorySignatureContract` domain.

##### `op fileChecksumManifest`
```flux
op fileChecksumManifest (as string: manifest_content) as string
```
- **Parameters**:
  - `manifest_content` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `fileChecksumManifest` functionality within the `FileDirectorySignatureContract` domain.

### 4.3 Contract `FileFormatSignatureContract` (`FileFormatSignature.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `fileMagicBytes` | `op fileMagicBytes (as string: path, as int64: num_bytes) as string` | `string` |
| `fileDetectType` | `op fileDetectType (as string: path) as string` | `string` |
| `fileIsBinary` | `op fileIsBinary (as string: path) as bool` | `bool` |

#### Operation Technical Specifications:

##### `op fileMagicBytes`
```flux
op fileMagicBytes (as string: path, as int64: num_bytes) as string
```
- **Parameters**:
  - `path` (`string`): Input argument for operation execution.
  - `num_bytes` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `fileMagicBytes` functionality within the `FileFormatSignatureContract` domain.

##### `op fileDetectType`
```flux
op fileDetectType (as string: path) as string
```
- **Parameters**:
  - `path` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `fileDetectType` functionality within the `FileFormatSignatureContract` domain.

##### `op fileIsBinary`
```flux
op fileIsBinary (as string: path) as bool
```
- **Parameters**:
  - `path` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `fileIsBinary` functionality within the `FileFormatSignatureContract` domain.

### 4.4 Contract `FileHashSignatureContract` (`FileHashSignature.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `fileSha256` | `op fileSha256 (as string: path) as string` | `string` |
| `fileMd5` | `op fileMd5 (as string: path) as string` | `string` |
| `fileSha1` | `op fileSha1 (as string: path) as string` | `string` |
| `fileCrc32` | `op fileCrc32 (as string: path) as int64` | `int64` |
| `fileVerifySha256` | `op fileVerifySha256 (as string: path, as string: expected_hash) as bool` | `bool` |
| `fileVerifyMd5` | `op fileVerifyMd5 (as string: path, as string: expected_hash) as bool` | `bool` |
| `fileVerifyHash` | `op fileVerifyHash (as string: path, as string: expected_hash) as bool` | `bool` |

#### Operation Technical Specifications:

##### `op fileSha256`
```flux
op fileSha256 (as string: path) as string
```
- **Parameters**:
  - `path` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `fileSha256` functionality within the `FileHashSignatureContract` domain.

##### `op fileMd5`
```flux
op fileMd5 (as string: path) as string
```
- **Parameters**:
  - `path` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `fileMd5` functionality within the `FileHashSignatureContract` domain.

##### `op fileSha1`
```flux
op fileSha1 (as string: path) as string
```
- **Parameters**:
  - `path` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `fileSha1` functionality within the `FileHashSignatureContract` domain.

##### `op fileCrc32`
```flux
op fileCrc32 (as string: path) as int64
```
- **Parameters**:
  - `path` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `fileCrc32` functionality within the `FileHashSignatureContract` domain.

##### `op fileVerifySha256`
```flux
op fileVerifySha256 (as string: path, as string: expected_hash) as bool
```
- **Parameters**:
  - `path` (`string`): Input argument for operation execution.
  - `expected_hash` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `fileVerifySha256` functionality within the `FileHashSignatureContract` domain.

##### `op fileVerifyMd5`
```flux
op fileVerifyMd5 (as string: path, as string: expected_hash) as bool
```
- **Parameters**:
  - `path` (`string`): Input argument for operation execution.
  - `expected_hash` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `fileVerifyMd5` functionality within the `FileHashSignatureContract` domain.

##### `op fileVerifyHash`
```flux
op fileVerifyHash (as string: path, as string: expected_hash) as bool
```
- **Parameters**:
  - `path` (`string`): Input argument for operation execution.
  - `expected_hash` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `fileVerifyHash` functionality within the `FileHashSignatureContract` domain.

---

## 5. Canonical Usage Examples in TheFlux

The following snippet illustrates importing and utilizing the library in a TheFlux program:

```flux
# Canonical Usage Example for FileSignatureStdLib
use FileSignatureStdLib

program (ExampleOfFileSignatureStdLib) {
      println("==================================================")
      println("  Standard Library Demonstration: FileSignatureStdLib")
      println("==================================================")

      # Invoking canonical operation
      mut as data: result = FileSignatureStdLib::detectFileFormat("app.exe")
      println("Obtained result: " + result)

      println("Execution completed successfully.")
}
```

---

> [!TIP]
> For the complete unified architecture across all standard libraries, consult the master [StdLibs.md](../StdLibs.md) reference.
