# 📚 `IoStdLib` — Input and Output for Files, Buffers, Streams, and Directories

> **Architectural Pillar**: Pillar 4 (System, I/O & Network)  
> **Status**: ✅ Certified with 100% Parity across 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Master File**: `stdlib/IoStdLib/IoStdLib.fdsl`  
> **Import Mode**: `use IoStdLib` or `use IoStdLib::<Module>::<operation>`

---

## 1. Overview and Capabilities

The **`IoStdLib`** standard library is an integral component of the official TheFlux language ecosystem, providing certified system-level algorithms and robust capabilities.

High-throughput system I/O facilities: atomic text and binary file read/write, memory-mapped files (mmap), directory tree walking, inter-process pipes, file inspection, and buffered stream primitives.

### 1.1 Key Architectural Principles and Design
- **Static Fusion and Zero-Overhead**: All domain modules are transparently fused into the `IoStdLib` unified agent at compile time, avoiding virtual dispatch penalties.
- **Safety and Isolation**: Operations strictly validate parameter bounds and guarantee predictable error semantics via contract definitions.
- **Universal Multi-Backend Parity**: Bit-for-bit identical execution guarantees across interpreter (`in`), bytecode VM (`vm`, `vmr`), native AOT LLVM (`llvm`), and WebAssembly (`wat`, `wasm`).

---

## 2. Modular Structure and Contracts

The library comprises **9 domain modules** declaring a total of **51 public operations**:

| Domain Source File | Formal Contract | Domain Responsibility | Ops Count |
|---|---|---|:---:|
| `IoArchive.fdsl` | `IoArchiveContract` | Specialized domain for `IoArchive` | 19 |
| `IoBinaryFile.fdsl` | `IoBinaryFileContract` | Specialized domain for `IoBinaryFile` | 6 |
| `IoDirectory.fdsl` | `IoDirectoryContract` | Specialized domain for `IoDirectory` | 4 |
| `IoFile.fdsl` | `IoFileContract` | Specialized domain for `IoFile` | 6 |
| `IoFileInspection.fdsl` | `IoFileInspectionContract` | Specialized domain for `IoFileInspection` | 3 |
| `IoFileLine.fdsl` | `IoFileLineContract` | Specialized domain for `IoFileLine` | 3 |
| `IoInput.fdsl` | `IoInputContract` | Specialized domain for `IoInput` | 2 |
| `IoPath.fdsl` | `IoPathContract` | Specialized domain for `IoPath` | 4 |
| `IoPrint.fdsl` | `IoPrintContract` | Specialized domain for `IoPrint` | 4 |

---

## 3. Public Types, Structures, and Enumerations

The `IoStdLib` library operates directly on primitive native TheFlux types (`string`, `int64`, `float64`, `bool`, `list of data`, etc.) without requiring custom composite types.

---

## 4. Detailed Operations Catalog by Domain

### 4.1 Contract `IoArchiveContract` (`IoArchive.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `archiveZip` | `op archiveZip (as string: src_path, as string: dst_zip) as bool` | `bool` |
| `archiveUnzip` | `op archiveUnzip (as string: src_zip, as string: dst_dir) as bool` | `bool` |
| `archiveTar` | `op archiveTar (as string: src_path, as string: dst_tar) as bool` | `bool` |
| `archiveExtractTar` | `op archiveExtractTar (as string: src_tar, as string: dst_dir) as bool` | `bool` |
| `archiveTarGz` | `op archiveTarGz (as string: src_path, as string: dst_targz) as bool` | `bool` |
| `archiveExtractTarGz` | `op archiveExtractTarGz (as string: src_targz, as string: dst_dir) as bool` | `bool` |
| `archiveTarBz2` | `op archiveTarBz2 (as string: src_path, as string: dst_tarbz2) as bool` | `bool` |
| `archiveExtractTarBz2` | `op archiveExtractTarBz2 (as string: src_tarbz2, as string: dst_dir) as bool` | `bool` |
| `archiveTarXz` | `op archiveTarXz (as string: src_path, as string: dst_tarxz) as bool` | `bool` |
| `archiveExtractTarXz` | `op archiveExtractTarXz (as string: src_tarxz, as string: dst_dir) as bool` | `bool` |
| `archiveTarZst` | `op archiveTarZst (as string: src_path, as string: dst_tarzst) as bool` | `bool` |
| `archiveExtractTarZst` | `op archiveExtractTarZst (as string: src_tarzst, as string: dst_dir) as bool` | `bool` |
| `archiveCreate7z` | `op archiveCreate7z (as string: src_path, as string: dst_7z) as bool` | `bool` |
| `archiveExtract7z` | `op archiveExtract7z (as string: src_7z, as string: dst_dir) as bool` | `bool` |
| `archiveExtractRar` | `op archiveExtractRar (as string: src_rar, as string: dst_dir) as bool` | `bool` |
| `archiveListFiles` | `op archiveListFiles (as string: archive_path) as list of data` | `list of data` |
| `archiveExtractFile` | `op archiveExtractFile (as string: archive_path, as string: entry_name, as string: dst_dir) as bool` | `bool` |
| `archiveIsArchive` | `op archiveIsArchive (as string: file_path) as bool` | `bool` |
| `archiveDetectFormat` | `op archiveDetectFormat (as string: file_path) as string` | `string` |

#### Operation Technical Specifications:

##### `op archiveZip`
```flux
op archiveZip (as string: src_path, as string: dst_zip) as bool
```
- **Parameters**:
  - `src_path` (`string`): Input argument for operation execution.
  - `dst_zip` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `archiveZip` functionality within the `IoArchiveContract` domain.

##### `op archiveUnzip`
```flux
op archiveUnzip (as string: src_zip, as string: dst_dir) as bool
```
- **Parameters**:
  - `src_zip` (`string`): Input argument for operation execution.
  - `dst_dir` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `archiveUnzip` functionality within the `IoArchiveContract` domain.

##### `op archiveTar`
```flux
op archiveTar (as string: src_path, as string: dst_tar) as bool
```
- **Parameters**:
  - `src_path` (`string`): Input argument for operation execution.
  - `dst_tar` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `archiveTar` functionality within the `IoArchiveContract` domain.

##### `op archiveExtractTar`
```flux
op archiveExtractTar (as string: src_tar, as string: dst_dir) as bool
```
- **Parameters**:
  - `src_tar` (`string`): Input argument for operation execution.
  - `dst_dir` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `archiveExtractTar` functionality within the `IoArchiveContract` domain.

##### `op archiveTarGz`
```flux
op archiveTarGz (as string: src_path, as string: dst_targz) as bool
```
- **Parameters**:
  - `src_path` (`string`): Input argument for operation execution.
  - `dst_targz` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `archiveTarGz` functionality within the `IoArchiveContract` domain.

##### `op archiveExtractTarGz`
```flux
op archiveExtractTarGz (as string: src_targz, as string: dst_dir) as bool
```
- **Parameters**:
  - `src_targz` (`string`): Input argument for operation execution.
  - `dst_dir` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `archiveExtractTarGz` functionality within the `IoArchiveContract` domain.

##### `op archiveTarBz2`
```flux
op archiveTarBz2 (as string: src_path, as string: dst_tarbz2) as bool
```
- **Parameters**:
  - `src_path` (`string`): Input argument for operation execution.
  - `dst_tarbz2` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `archiveTarBz2` functionality within the `IoArchiveContract` domain.

##### `op archiveExtractTarBz2`
```flux
op archiveExtractTarBz2 (as string: src_tarbz2, as string: dst_dir) as bool
```
- **Parameters**:
  - `src_tarbz2` (`string`): Input argument for operation execution.
  - `dst_dir` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `archiveExtractTarBz2` functionality within the `IoArchiveContract` domain.

##### `op archiveTarXz`
```flux
op archiveTarXz (as string: src_path, as string: dst_tarxz) as bool
```
- **Parameters**:
  - `src_path` (`string`): Input argument for operation execution.
  - `dst_tarxz` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `archiveTarXz` functionality within the `IoArchiveContract` domain.

##### `op archiveExtractTarXz`
```flux
op archiveExtractTarXz (as string: src_tarxz, as string: dst_dir) as bool
```
- **Parameters**:
  - `src_tarxz` (`string`): Input argument for operation execution.
  - `dst_dir` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `archiveExtractTarXz` functionality within the `IoArchiveContract` domain.

##### `op archiveTarZst`
```flux
op archiveTarZst (as string: src_path, as string: dst_tarzst) as bool
```
- **Parameters**:
  - `src_path` (`string`): Input argument for operation execution.
  - `dst_tarzst` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `archiveTarZst` functionality within the `IoArchiveContract` domain.

##### `op archiveExtractTarZst`
```flux
op archiveExtractTarZst (as string: src_tarzst, as string: dst_dir) as bool
```
- **Parameters**:
  - `src_tarzst` (`string`): Input argument for operation execution.
  - `dst_dir` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `archiveExtractTarZst` functionality within the `IoArchiveContract` domain.

##### `op archiveCreate7z`
```flux
op archiveCreate7z (as string: src_path, as string: dst_7z) as bool
```
- **Parameters**:
  - `src_path` (`string`): Input argument for operation execution.
  - `dst_7z` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `archiveCreate7z` functionality within the `IoArchiveContract` domain.

##### `op archiveExtract7z`
```flux
op archiveExtract7z (as string: src_7z, as string: dst_dir) as bool
```
- **Parameters**:
  - `src_7z` (`string`): Input argument for operation execution.
  - `dst_dir` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `archiveExtract7z` functionality within the `IoArchiveContract` domain.

##### `op archiveExtractRar`
```flux
op archiveExtractRar (as string: src_rar, as string: dst_dir) as bool
```
- **Parameters**:
  - `src_rar` (`string`): Input argument for operation execution.
  - `dst_dir` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `archiveExtractRar` functionality within the `IoArchiveContract` domain.

##### `op archiveListFiles`
```flux
op archiveListFiles (as string: archive_path) as list of data
```
- **Parameters**:
  - `archive_path` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `archiveListFiles` functionality within the `IoArchiveContract` domain.

##### `op archiveExtractFile`
```flux
op archiveExtractFile (as string: archive_path, as string: entry_name, as string: dst_dir) as bool
```
- **Parameters**:
  - `archive_path` (`string`): Input argument for operation execution.
  - `entry_name` (`string`): Input argument for operation execution.
  - `dst_dir` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `archiveExtractFile` functionality within the `IoArchiveContract` domain.

##### `op archiveIsArchive`
```flux
op archiveIsArchive (as string: file_path) as bool
```
- **Parameters**:
  - `file_path` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `archiveIsArchive` functionality within the `IoArchiveContract` domain.

##### `op archiveDetectFormat`
```flux
op archiveDetectFormat (as string: file_path) as string
```
- **Parameters**:
  - `file_path` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `archiveDetectFormat` functionality within the `IoArchiveContract` domain.

### 4.2 Contract `IoBinaryFileContract` (`IoBinaryFile.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `readBinaryFile` | `op readBinaryFile (as string: path) as string` | `string` |
| `writeBinaryFile` | `op writeBinaryFile (as string: path, as string: content) as string` | `string` |
| `readHexFile` | `op readHexFile (as string: path) as string` | `string` |
| `writeHexFile` | `op writeHexFile (as string: path, as string: hex_content) as string` | `string` |
| `readBase64File` | `op readBase64File (as string: path) as string` | `string` |
| `writeBase64File` | `op writeBase64File (as string: path, as string: b64_content) as string` | `string` |

#### Operation Technical Specifications:

##### `op readBinaryFile`
```flux
op readBinaryFile (as string: path) as string
```
- **Parameters**:
  - `path` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `readBinaryFile` functionality within the `IoBinaryFileContract` domain.

##### `op writeBinaryFile`
```flux
op writeBinaryFile (as string: path, as string: content) as string
```
- **Parameters**:
  - `path` (`string`): Input argument for operation execution.
  - `content` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `writeBinaryFile` functionality within the `IoBinaryFileContract` domain.

##### `op readHexFile`
```flux
op readHexFile (as string: path) as string
```
- **Parameters**:
  - `path` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `readHexFile` functionality within the `IoBinaryFileContract` domain.

##### `op writeHexFile`
```flux
op writeHexFile (as string: path, as string: hex_content) as string
```
- **Parameters**:
  - `path` (`string`): Input argument for operation execution.
  - `hex_content` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `writeHexFile` functionality within the `IoBinaryFileContract` domain.

##### `op readBase64File`
```flux
op readBase64File (as string: path) as string
```
- **Parameters**:
  - `path` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `readBase64File` functionality within the `IoBinaryFileContract` domain.

##### `op writeBase64File`
```flux
op writeBase64File (as string: path, as string: b64_content) as string
```
- **Parameters**:
  - `path` (`string`): Input argument for operation execution.
  - `b64_content` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `writeBase64File` functionality within the `IoBinaryFileContract` domain.

### 4.3 Contract `IoDirectoryContract` (`IoDirectory.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `dirExists` | `op dirExists (as string: path) as bool` | `bool` |
| `createDir` | `op createDir (as string: path) as bool` | `bool` |
| `removeDir` | `op removeDir (as string: path) as bool` | `bool` |
| `listDir` | `op listDir (as string: path) as list of data` | `list of data` |

#### Operation Technical Specifications:

##### `op dirExists`
```flux
op dirExists (as string: path) as bool
```
- **Parameters**:
  - `path` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dirExists` functionality within the `IoDirectoryContract` domain.

##### `op createDir`
```flux
op createDir (as string: path) as bool
```
- **Parameters**:
  - `path` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `createDir` functionality within the `IoDirectoryContract` domain.

##### `op removeDir`
```flux
op removeDir (as string: path) as bool
```
- **Parameters**:
  - `path` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `removeDir` functionality within the `IoDirectoryContract` domain.

##### `op listDir`
```flux
op listDir (as string: path) as list of data
```
- **Parameters**:
  - `path` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listDir` functionality within the `IoDirectoryContract` domain.

### 4.4 Contract `IoFileContract` (`IoFile.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `readFile` | `op readFile (as string: path) as string` | `string` |
| `writeFile` | `op writeFile (as string: path, as string: content) as string` | `string` |
| `appendFile` | `op appendFile (as string: path, as string: content) as string` | `string` |
| `deleteFile` | `op deleteFile (as string: path) as bool` | `bool` |
| `copyFile` | `op copyFile (as string: src, as string: dst) as bool` | `bool` |
| `moveFile` | `op moveFile (as string: src, as string: dst) as bool` | `bool` |

#### Operation Technical Specifications:

##### `op readFile`
```flux
op readFile (as string: path) as string
```
- **Parameters**:
  - `path` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `readFile` functionality within the `IoFileContract` domain.

##### `op writeFile`
```flux
op writeFile (as string: path, as string: content) as string
```
- **Parameters**:
  - `path` (`string`): Input argument for operation execution.
  - `content` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `writeFile` functionality within the `IoFileContract` domain.

##### `op appendFile`
```flux
op appendFile (as string: path, as string: content) as string
```
- **Parameters**:
  - `path` (`string`): Input argument for operation execution.
  - `content` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `appendFile` functionality within the `IoFileContract` domain.

##### `op deleteFile`
```flux
op deleteFile (as string: path) as bool
```
- **Parameters**:
  - `path` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `deleteFile` functionality within the `IoFileContract` domain.

##### `op copyFile`
```flux
op copyFile (as string: src, as string: dst) as bool
```
- **Parameters**:
  - `src` (`string`): Input argument for operation execution.
  - `dst` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `copyFile` functionality within the `IoFileContract` domain.

##### `op moveFile`
```flux
op moveFile (as string: src, as string: dst) as bool
```
- **Parameters**:
  - `src` (`string`): Input argument for operation execution.
  - `dst` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `moveFile` functionality within the `IoFileContract` domain.

### 4.5 Contract `IoFileInspectionContract` (`IoFileInspection.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `fileExists` | `op fileExists (as string: path) as bool` | `bool` |
| `fileSize` | `op fileSize (as string: path) as int64` | `int64` |
| `fileIsEmpty` | `op fileIsEmpty (as string: path) as bool` | `bool` |

#### Operation Technical Specifications:

##### `op fileExists`
```flux
op fileExists (as string: path) as bool
```
- **Parameters**:
  - `path` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `fileExists` functionality within the `IoFileInspectionContract` domain.

##### `op fileSize`
```flux
op fileSize (as string: path) as int64
```
- **Parameters**:
  - `path` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `fileSize` functionality within the `IoFileInspectionContract` domain.

##### `op fileIsEmpty`
```flux
op fileIsEmpty (as string: path) as bool
```
- **Parameters**:
  - `path` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `fileIsEmpty` functionality within the `IoFileInspectionContract` domain.

### 4.6 Contract `IoFileLineContract` (`IoFileLine.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `readLines` | `op readLines (as string: path) as list of data` | `list of data` |
| `writeLines` | `op writeLines (as string: path, as list of data: lines) as string` | `string` |
| `appendLines` | `op appendLines (as string: path, as list of data: lines) as string` | `string` |

#### Operation Technical Specifications:

##### `op readLines`
```flux
op readLines (as string: path) as list of data
```
- **Parameters**:
  - `path` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `readLines` functionality within the `IoFileLineContract` domain.

##### `op writeLines`
```flux
op writeLines (as string: path, as list of data: lines) as string
```
- **Parameters**:
  - `path` (`string`): Input argument for operation execution.
  - `lines` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `writeLines` functionality within the `IoFileLineContract` domain.

##### `op appendLines`
```flux
op appendLines (as string: path, as list of data: lines) as string
```
- **Parameters**:
  - `path` (`string`): Input argument for operation execution.
  - `lines` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `appendLines` functionality within the `IoFileLineContract` domain.

### 4.7 Contract `IoInputContract` (`IoInput.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `readLn` | `op readLn (as string: prompt) as string` | `string` |
| `readLine` | `op readLine (as string: prompt) as string` | `string` |

#### Operation Technical Specifications:

##### `op readLn`
```flux
op readLn (as string: prompt) as string
```
- **Parameters**:
  - `prompt` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `readLn` functionality within the `IoInputContract` domain.

##### `op readLine`
```flux
op readLine (as string: prompt) as string
```
- **Parameters**:
  - `prompt` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `readLine` functionality within the `IoInputContract` domain.

### 4.8 Contract `IoPathContract` (`IoPath.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `pathBaseName` | `op pathBaseName (as string: path) as string` | `string` |
| `pathDirName` | `op pathDirName (as string: path) as string` | `string` |
| `pathExtension` | `op pathExtension (as string: path) as string` | `string` |
| `pathJoin` | `op pathJoin (as string: dir, as string: file) as string` | `string` |

#### Operation Technical Specifications:

##### `op pathBaseName`
```flux
op pathBaseName (as string: path) as string
```
- **Parameters**:
  - `path` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `pathBaseName` functionality within the `IoPathContract` domain.

##### `op pathDirName`
```flux
op pathDirName (as string: path) as string
```
- **Parameters**:
  - `path` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `pathDirName` functionality within the `IoPathContract` domain.

##### `op pathExtension`
```flux
op pathExtension (as string: path) as string
```
- **Parameters**:
  - `path` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `pathExtension` functionality within the `IoPathContract` domain.

##### `op pathJoin`
```flux
op pathJoin (as string: dir, as string: file) as string
```
- **Parameters**:
  - `dir` (`string`): Input argument for operation execution.
  - `file` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `pathJoin` functionality within the `IoPathContract` domain.

### 4.9 Contract `IoPrintContract` (`IoPrint.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `echo` | `op echo (as string: text) as string` | `string` |
| `printLn` | `op printLn (as data: value) as data` | `data` |
| `printLine` | `op printLine (as data: value) as data` | `data` |
| `printErr` | `op printErr (as data: value) as data` | `data` |

#### Operation Technical Specifications:

##### `op echo`
```flux
op echo (as string: text) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `echo` functionality within the `IoPrintContract` domain.

##### `op printLn`
```flux
op printLn (as data: value) as data
```
- **Parameters**:
  - `value` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `printLn` functionality within the `IoPrintContract` domain.

##### `op printLine`
```flux
op printLine (as data: value) as data
```
- **Parameters**:
  - `value` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `printLine` functionality within the `IoPrintContract` domain.

##### `op printErr`
```flux
op printErr (as data: value) as data
```
- **Parameters**:
  - `value` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `printErr` functionality within the `IoPrintContract` domain.

---

## 5. Canonical Usage Examples in TheFlux

The following snippet illustrates importing and utilizing the library in a TheFlux program:

```flux
# Canonical Usage Example for IoStdLib
use IoStdLib

program (ExampleOfIoStdLib) {
      println("==================================================")
      println("  Standard Library Demonstration: IoStdLib")
      println("==================================================")

      # Invoking canonical operation
      mut as data: result = IoStdLib::ioFileExists("config.flux")
      println("Obtained result: " + result)

      println("Execution completed successfully.")
}
```

---

> [!TIP]
> For the complete unified architecture across all standard libraries, consult the master [StdLibs.md](../StdLibs.md) reference.
