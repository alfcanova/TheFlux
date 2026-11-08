# 📚 `ArchiveStdLib` — Compressed Archive and Package Management

> **Architectural Pillar**: Pillar 4 (System, I/O & Network)  
> **Status**: ✅ Certified with 100% Parity across 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Master File**: `stdlib/ArchiveStdLib/ArchiveStdLib.fdsl`  
> **Import Mode**: `use ArchiveStdLib` or `use ArchiveStdLib::<Module>::<operation>`

---

## 1. Overview and Capabilities

The **`ArchiveStdLib`** standard library is an integral component of the official TheFlux language ecosystem, providing certified system-level algorithms and robust capabilities.

Provides comprehensive operations for creating, unpacking, listing, and extracting archive containers across industry-standard formats (ZIP, TAR, TAR.GZ, TAR.BZ2, TAR.XZ, TAR.ZST, 7Z, and RAR). Includes automatic archive format detection through binary file headers.

### 1.1 Key Architectural Principles and Design
- **Static Fusion and Zero-Overhead**: All domain modules are transparently fused into the `ArchiveStdLib` unified agent at compile time, avoiding virtual dispatch penalties.
- **Safety and Isolation**: Operations strictly validate parameter bounds and guarantee predictable error semantics via contract definitions.
- **Universal Multi-Backend Parity**: Bit-for-bit identical execution guarantees across interpreter (`in`), bytecode VM (`vm`, `vmr`), native AOT LLVM (`llvm`), and WebAssembly (`wat`, `wasm`).

---

## 2. Modular Structure and Contracts

The library comprises **1 domain module** declaring a total of **19 public operations**:

| Domain Source File | Formal Contract | Domain Responsibility | Ops Count |
|---|---|---|:---:|
| `ArchiveManagement.fdsl` | `ArchiveManagementContract` | Specialized domain for `ArchiveManagement` | 19 |

---

## 3. Public Types, Structures, and Enumerations

The `ArchiveStdLib` library operates directly on primitive native TheFlux types (`string`, `int64`, `float64`, `bool`, `list of data`, etc.) without requiring custom composite types.

---

## 4. Detailed Operations Catalog by Domain

### 4.1 Contract `ArchiveManagementContract` (`ArchiveManagement.fdsl`)

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
  - Executes canonical `archiveZip` functionality within the `ArchiveManagementContract` domain.

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
  - Executes canonical `archiveUnzip` functionality within the `ArchiveManagementContract` domain.

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
  - Executes canonical `archiveTar` functionality within the `ArchiveManagementContract` domain.

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
  - Executes canonical `archiveExtractTar` functionality within the `ArchiveManagementContract` domain.

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
  - Executes canonical `archiveTarGz` functionality within the `ArchiveManagementContract` domain.

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
  - Executes canonical `archiveExtractTarGz` functionality within the `ArchiveManagementContract` domain.

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
  - Executes canonical `archiveTarBz2` functionality within the `ArchiveManagementContract` domain.

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
  - Executes canonical `archiveExtractTarBz2` functionality within the `ArchiveManagementContract` domain.

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
  - Executes canonical `archiveTarXz` functionality within the `ArchiveManagementContract` domain.

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
  - Executes canonical `archiveExtractTarXz` functionality within the `ArchiveManagementContract` domain.

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
  - Executes canonical `archiveTarZst` functionality within the `ArchiveManagementContract` domain.

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
  - Executes canonical `archiveExtractTarZst` functionality within the `ArchiveManagementContract` domain.

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
  - Executes canonical `archiveCreate7z` functionality within the `ArchiveManagementContract` domain.

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
  - Executes canonical `archiveExtract7z` functionality within the `ArchiveManagementContract` domain.

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
  - Executes canonical `archiveExtractRar` functionality within the `ArchiveManagementContract` domain.

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
  - Executes canonical `archiveListFiles` functionality within the `ArchiveManagementContract` domain.

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
  - Executes canonical `archiveExtractFile` functionality within the `ArchiveManagementContract` domain.

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
  - Executes canonical `archiveIsArchive` functionality within the `ArchiveManagementContract` domain.

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
  - Executes canonical `archiveDetectFormat` functionality within the `ArchiveManagementContract` domain.

---

## 5. Canonical Usage Examples in TheFlux

The following snippet illustrates importing and utilizing the library in a TheFlux program:

```flux
# Canonical Usage Example for ArchiveStdLib
use ArchiveStdLib

program (ExampleOfArchiveStdLib) {
      println("==================================================")
      println("  Standard Library Demonstration: ArchiveStdLib")
      println("==================================================")

      # Invoking canonical operation
      mut as data: result = ArchiveStdLib::archiveIsArchive("data.zip")
      println("Obtained result: " + result)

      println("Execution completed successfully.")
}
```

---

> [!TIP]
> For the complete unified architecture across all standard libraries, consult the master [StdLibs.md](../StdLibs.md) reference.
