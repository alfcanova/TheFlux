# 📚 `OsStdLib` — Operating System Interoperability, Processes, Environment, and Signals

> **Architectural Pillar**: Pillar 4 (System, I/O & Network)  
> **Status**: ✅ Certified with 100% Parity across 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Master File**: `stdlib/OsStdLib/OsStdLib.fdsl`  
> **Import Mode**: `use OsStdLib` or `use OsStdLib::<Module>::<operation>`

---

## 1. Overview and Capabilities

The **`OsStdLib`** standard library is an integral component of the official TheFlux language ecosystem, providing certified system-level algorithms and robust capabilities.

Host operating system runtime interaction: reading and setting environment variables, querying CPU architecture and OS platform metadata, spawning child processes, capturing exit codes, and process termination.

### 1.1 Key Architectural Principles and Design
- **Static Fusion and Zero-Overhead**: All domain modules are transparently fused into the `OsStdLib` unified agent at compile time, avoiding virtual dispatch penalties.
- **Safety and Isolation**: Operations strictly validate parameter bounds and guarantee predictable error semantics via contract definitions.
- **Universal Multi-Backend Parity**: Bit-for-bit identical execution guarantees across interpreter (`in`), bytecode VM (`vm`, `vmr`), native AOT LLVM (`llvm`), and WebAssembly (`wat`, `wasm`).

---

## 2. Modular Structure and Contracts

The library comprises **4 domain modules** declaring a total of **64 public operations**:

| Domain Source File | Formal Contract | Domain Responsibility | Ops Count |
|---|---|---|:---:|
| `OsEnv.fdsl` | `OsEnvContract` | Specialized domain for `OsEnv` | 12 |
| `OsInfo.fdsl` | `OsInfoContract` | Specialized domain for `OsInfo` | 18 |
| `OsProcess.fdsl` | `OsProcessContract` | Specialized domain for `OsProcess` | 15 |
| `OsSystem.fdsl` | `OsSystemContract` | Specialized domain for `OsSystem` | 19 |

---

## 3. Public Types, Structures, and Enumerations

The `OsStdLib` library operates directly on primitive native TheFlux types (`string`, `int64`, `float64`, `bool`, `list of data`, etc.) without requiring custom composite types.

---

## 4. Detailed Operations Catalog by Domain

### 4.1 Contract `OsEnvContract` (`OsEnv.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `osGetEnv` | `op osGetEnv (as string: name) as string` | `string` |
| `osGetEnvOrDefault` | `op osGetEnvOrDefault (as string: name, as string: default_value) as string` | `string` |
| `osSetEnv` | `op osSetEnv (as string: name, as string: value) as bool` | `bool` |
| `osHasEnv` | `op osHasEnv (as string: name) as bool` | `bool` |
| `osUnsetEnv` | `op osUnsetEnv (as string: name) as bool` | `bool` |
| `osListEnv` | `op osListEnv () as list of data` | `list of data` |
| `getEnv` | `op getEnv (as string: name) as string` | `string` |
| `getEnvOrDefault` | `op getEnvOrDefault (as string: name, as string: default_value) as string` | `string` |
| `setEnv` | `op setEnv (as string: name, as string: value) as bool` | `bool` |
| `hasEnv` | `op hasEnv (as string: name) as bool` | `bool` |
| `unsetEnv` | `op unsetEnv (as string: name) as bool` | `bool` |
| `listEnv` | `op listEnv () as list of data` | `list of data` |

#### Operation Technical Specifications:

##### `op osGetEnv`
```flux
op osGetEnv (as string: name) as string
```
- **Parameters**:
  - `name` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `osGetEnv` functionality within the `OsEnvContract` domain.

##### `op osGetEnvOrDefault`
```flux
op osGetEnvOrDefault (as string: name, as string: default_value) as string
```
- **Parameters**:
  - `name` (`string`): Input argument for operation execution.
  - `default_value` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `osGetEnvOrDefault` functionality within the `OsEnvContract` domain.

##### `op osSetEnv`
```flux
op osSetEnv (as string: name, as string: value) as bool
```
- **Parameters**:
  - `name` (`string`): Input argument for operation execution.
  - `value` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `osSetEnv` functionality within the `OsEnvContract` domain.

##### `op osHasEnv`
```flux
op osHasEnv (as string: name) as bool
```
- **Parameters**:
  - `name` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `osHasEnv` functionality within the `OsEnvContract` domain.

##### `op osUnsetEnv`
```flux
op osUnsetEnv (as string: name) as bool
```
- **Parameters**:
  - `name` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `osUnsetEnv` functionality within the `OsEnvContract` domain.

##### `op osListEnv`
```flux
op osListEnv () as list of data
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `osListEnv` functionality within the `OsEnvContract` domain.

##### `op getEnv`
```flux
op getEnv (as string: name) as string
```
- **Parameters**:
  - `name` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `getEnv` functionality within the `OsEnvContract` domain.

##### `op getEnvOrDefault`
```flux
op getEnvOrDefault (as string: name, as string: default_value) as string
```
- **Parameters**:
  - `name` (`string`): Input argument for operation execution.
  - `default_value` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `getEnvOrDefault` functionality within the `OsEnvContract` domain.

##### `op setEnv`
```flux
op setEnv (as string: name, as string: value) as bool
```
- **Parameters**:
  - `name` (`string`): Input argument for operation execution.
  - `value` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `setEnv` functionality within the `OsEnvContract` domain.

##### `op hasEnv`
```flux
op hasEnv (as string: name) as bool
```
- **Parameters**:
  - `name` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `hasEnv` functionality within the `OsEnvContract` domain.

##### `op unsetEnv`
```flux
op unsetEnv (as string: name) as bool
```
- **Parameters**:
  - `name` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `unsetEnv` functionality within the `OsEnvContract` domain.

##### `op listEnv`
```flux
op listEnv () as list of data
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `listEnv` functionality within the `OsEnvContract` domain.

### 4.2 Contract `OsInfoContract` (`OsInfo.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `osPlatform` | `op osPlatform () as string` | `string` |
| `osArch` | `op osArch () as string` | `string` |
| `osFamily` | `op osFamily () as string` | `string` |
| `osHostname` | `op osHostname () as string` | `string` |
| `osLineSeparator` | `op osLineSeparator () as string` | `string` |
| `osPathSeparator` | `op osPathSeparator () as string` | `string` |
| `osDirSeparator` | `op osDirSeparator () as string` | `string` |
| `osIsWindows` | `op osIsWindows () as bool` | `bool` |
| `osIsLinux` | `op osIsLinux () as bool` | `bool` |
| `osIsDarwin` | `op osIsDarwin () as bool` | `bool` |
| `osInfoSummary` | `op osInfoSummary () as string` | `string` |
| `platform` | `op platform () as string` | `string` |
| `arch` | `op arch () as string` | `string` |
| `family` | `op family () as string` | `string` |
| `hostname` | `op hostname () as string` | `string` |
| `lineSeparator` | `op lineSeparator () as string` | `string` |
| `pathSeparator` | `op pathSeparator () as string` | `string` |
| `dirSeparator` | `op dirSeparator () as string` | `string` |

#### Operation Technical Specifications:

##### `op osPlatform`
```flux
op osPlatform () as string
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `osPlatform` functionality within the `OsInfoContract` domain.

##### `op osArch`
```flux
op osArch () as string
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `osArch` functionality within the `OsInfoContract` domain.

##### `op osFamily`
```flux
op osFamily () as string
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `osFamily` functionality within the `OsInfoContract` domain.

##### `op osHostname`
```flux
op osHostname () as string
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `osHostname` functionality within the `OsInfoContract` domain.

##### `op osLineSeparator`
```flux
op osLineSeparator () as string
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `osLineSeparator` functionality within the `OsInfoContract` domain.

##### `op osPathSeparator`
```flux
op osPathSeparator () as string
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `osPathSeparator` functionality within the `OsInfoContract` domain.

##### `op osDirSeparator`
```flux
op osDirSeparator () as string
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `osDirSeparator` functionality within the `OsInfoContract` domain.

##### `op osIsWindows`
```flux
op osIsWindows () as bool
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `osIsWindows` functionality within the `OsInfoContract` domain.

##### `op osIsLinux`
```flux
op osIsLinux () as bool
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `osIsLinux` functionality within the `OsInfoContract` domain.

##### `op osIsDarwin`
```flux
op osIsDarwin () as bool
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `osIsDarwin` functionality within the `OsInfoContract` domain.

##### `op osInfoSummary`
```flux
op osInfoSummary () as string
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `osInfoSummary` functionality within the `OsInfoContract` domain.

##### `op platform`
```flux
op platform () as string
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `platform` functionality within the `OsInfoContract` domain.

##### `op arch`
```flux
op arch () as string
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `arch` functionality within the `OsInfoContract` domain.

##### `op family`
```flux
op family () as string
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `family` functionality within the `OsInfoContract` domain.

##### `op hostname`
```flux
op hostname () as string
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `hostname` functionality within the `OsInfoContract` domain.

##### `op lineSeparator`
```flux
op lineSeparator () as string
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `lineSeparator` functionality within the `OsInfoContract` domain.

##### `op pathSeparator`
```flux
op pathSeparator () as string
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `pathSeparator` functionality within the `OsInfoContract` domain.

##### `op dirSeparator`
```flux
op dirSeparator () as string
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dirSeparator` functionality within the `OsInfoContract` domain.

### 4.3 Contract `OsProcessContract` (`OsProcess.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `osGetPid` | `op osGetPid () as int64` | `int64` |
| `osGetParentPid` | `op osGetParentPid () as int64` | `int64` |
| `osCwd` | `op osCwd () as string` | `string` |
| `osChdir` | `op osChdir (as string: path) as bool` | `bool` |
| `osExec` | `op osExec (as string: command) as int64` | `int64` |
| `osExecOutput` | `op osExecOutput (as string: command) as string` | `string` |
| `osSleep` | `op osSleep (as int64: milliseconds) as bool` | `bool` |
| `osProcessSummary` | `op osProcessSummary () as string` | `string` |
| `getPid` | `op getPid () as int64` | `int64` |
| `getParentPid` | `op getParentPid () as int64` | `int64` |
| `cwd` | `op cwd () as string` | `string` |
| `chdir` | `op chdir (as string: path) as bool` | `bool` |
| `exec` | `op exec (as string: command) as int64` | `int64` |
| `execOutput` | `op execOutput (as string: command) as string` | `string` |
| `sleep` | `op sleep (as int64: milliseconds) as bool` | `bool` |

#### Operation Technical Specifications:

##### `op osGetPid`
```flux
op osGetPid () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `osGetPid` functionality within the `OsProcessContract` domain.

##### `op osGetParentPid`
```flux
op osGetParentPid () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `osGetParentPid` functionality within the `OsProcessContract` domain.

##### `op osCwd`
```flux
op osCwd () as string
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `osCwd` functionality within the `OsProcessContract` domain.

##### `op osChdir`
```flux
op osChdir (as string: path) as bool
```
- **Parameters**:
  - `path` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `osChdir` functionality within the `OsProcessContract` domain.

##### `op osExec`
```flux
op osExec (as string: command) as int64
```
- **Parameters**:
  - `command` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `osExec` functionality within the `OsProcessContract` domain.

##### `op osExecOutput`
```flux
op osExecOutput (as string: command) as string
```
- **Parameters**:
  - `command` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `osExecOutput` functionality within the `OsProcessContract` domain.

##### `op osSleep`
```flux
op osSleep (as int64: milliseconds) as bool
```
- **Parameters**:
  - `milliseconds` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `osSleep` functionality within the `OsProcessContract` domain.

##### `op osProcessSummary`
```flux
op osProcessSummary () as string
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `osProcessSummary` functionality within the `OsProcessContract` domain.

##### `op getPid`
```flux
op getPid () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `getPid` functionality within the `OsProcessContract` domain.

##### `op getParentPid`
```flux
op getParentPid () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `getParentPid` functionality within the `OsProcessContract` domain.

##### `op cwd`
```flux
op cwd () as string
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `cwd` functionality within the `OsProcessContract` domain.

##### `op chdir`
```flux
op chdir (as string: path) as bool
```
- **Parameters**:
  - `path` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `chdir` functionality within the `OsProcessContract` domain.

##### `op exec`
```flux
op exec (as string: command) as int64
```
- **Parameters**:
  - `command` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `exec` functionality within the `OsProcessContract` domain.

##### `op execOutput`
```flux
op execOutput (as string: command) as string
```
- **Parameters**:
  - `command` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `execOutput` functionality within the `OsProcessContract` domain.

##### `op sleep`
```flux
op sleep (as int64: milliseconds) as bool
```
- **Parameters**:
  - `milliseconds` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `sleep` functionality within the `OsProcessContract` domain.

### 4.4 Contract `OsSystemContract` (`OsSystem.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `osUserName` | `op osUserName () as string` | `string` |
| `osHomeDir` | `op osHomeDir () as string` | `string` |
| `osTempDir` | `op osTempDir () as string` | `string` |
| `osCpuCount` | `op osCpuCount () as int64` | `int64` |
| `osUptime` | `op osUptime () as int64` | `int64` |
| `osMemoryTotal` | `op osMemoryTotal () as int64` | `int64` |
| `osMemoryFree` | `op osMemoryFree () as int64` | `int64` |
| `osMemoryTotalMb` | `op osMemoryTotalMb () as int64` | `int64` |
| `osMemoryTotalGb` | `op osMemoryTotalGb () as int64` | `int64` |
| `osMemoryFreeMb` | `op osMemoryFreeMb () as int64` | `int64` |
| `osMemoryFreeGb` | `op osMemoryFreeGb () as int64` | `int64` |
| `osSystemSummary` | `op osSystemSummary () as string` | `string` |
| `userName` | `op userName () as string` | `string` |
| `homeDir` | `op homeDir () as string` | `string` |
| `tempDir` | `op tempDir () as string` | `string` |
| `cpuCount` | `op cpuCount () as int64` | `int64` |
| `uptime` | `op uptime () as int64` | `int64` |
| `memoryTotal` | `op memoryTotal () as int64` | `int64` |
| `memoryFree` | `op memoryFree () as int64` | `int64` |

#### Operation Technical Specifications:

##### `op osUserName`
```flux
op osUserName () as string
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `osUserName` functionality within the `OsSystemContract` domain.

##### `op osHomeDir`
```flux
op osHomeDir () as string
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `osHomeDir` functionality within the `OsSystemContract` domain.

##### `op osTempDir`
```flux
op osTempDir () as string
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `osTempDir` functionality within the `OsSystemContract` domain.

##### `op osCpuCount`
```flux
op osCpuCount () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `osCpuCount` functionality within the `OsSystemContract` domain.

##### `op osUptime`
```flux
op osUptime () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `osUptime` functionality within the `OsSystemContract` domain.

##### `op osMemoryTotal`
```flux
op osMemoryTotal () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `osMemoryTotal` functionality within the `OsSystemContract` domain.

##### `op osMemoryFree`
```flux
op osMemoryFree () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `osMemoryFree` functionality within the `OsSystemContract` domain.

##### `op osMemoryTotalMb`
```flux
op osMemoryTotalMb () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `osMemoryTotalMb` functionality within the `OsSystemContract` domain.

##### `op osMemoryTotalGb`
```flux
op osMemoryTotalGb () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `osMemoryTotalGb` functionality within the `OsSystemContract` domain.

##### `op osMemoryFreeMb`
```flux
op osMemoryFreeMb () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `osMemoryFreeMb` functionality within the `OsSystemContract` domain.

##### `op osMemoryFreeGb`
```flux
op osMemoryFreeGb () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `osMemoryFreeGb` functionality within the `OsSystemContract` domain.

##### `op osSystemSummary`
```flux
op osSystemSummary () as string
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `osSystemSummary` functionality within the `OsSystemContract` domain.

##### `op userName`
```flux
op userName () as string
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `userName` functionality within the `OsSystemContract` domain.

##### `op homeDir`
```flux
op homeDir () as string
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `homeDir` functionality within the `OsSystemContract` domain.

##### `op tempDir`
```flux
op tempDir () as string
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `tempDir` functionality within the `OsSystemContract` domain.

##### `op cpuCount`
```flux
op cpuCount () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `cpuCount` functionality within the `OsSystemContract` domain.

##### `op uptime`
```flux
op uptime () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `uptime` functionality within the `OsSystemContract` domain.

##### `op memoryTotal`
```flux
op memoryTotal () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `memoryTotal` functionality within the `OsSystemContract` domain.

##### `op memoryFree`
```flux
op memoryFree () as int64
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `memoryFree` functionality within the `OsSystemContract` domain.

---

## 5. Canonical Usage Examples in TheFlux

The following snippet illustrates importing and utilizing the library in a TheFlux program:

```flux
# Canonical Usage Example for OsStdLib
use OsStdLib

program (ExampleOfOsStdLib) {
      println("==================================================")
      println("  Standard Library Demonstration: OsStdLib")
      println("==================================================")

      # Invoking canonical operation
      mut as data: result = OsStdLib::osGetEnv("PATH")
      println("Obtained result: " + result)

      println("Execution completed successfully.")
}
```

---

> [!TIP]
> For the complete unified architecture across all standard libraries, consult the master [StdLibs.md](../StdLibs.md) reference.
