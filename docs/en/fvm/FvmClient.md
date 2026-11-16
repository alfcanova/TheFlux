# 🔌 FDSL Connector and FvmClient Agent Interface

> **Agent Source Code**: [`src/Fvm/FvmClient.fdsl`](file:///D:/Projetos/TheFlux/src/Fvm/FvmClient.fdsl)  
> **Canonical Contract**: [`src/Fvm/FvmContract.fdsl`](file:///D:/Projetos/TheFlux/src/Fvm/FvmContract.fdsl)  
> **Supported Version**: `v1.0.0`  
> **Status**: ✅ Official Canonical Subsystem of TheFlux v1.0.0

---

## 1. Overview and Architectural Purpose

The [`src/Fvm`](file:///D:/Projetos/TheFlux/src/Fvm) module implements the official high-level TheFlux language connector for interacting with the **Fast Virtual Machine (`bin/fluxvm.exe`)**. In accordance with TheFlux contract-and-agent programming paradigm, the connector provides a declarative API that abstracts:

- Operational status detection for the background Windows Service or console daemon.
- Safe execution of local `.fvmbc` bytecode files.
- Atomic in-memory bytecode injection over Windows Named Pipes (`\\.\pipe\theflux_fvm`) with transparent local fallback.

---

## 2. `FvmContract` Specification

The canonical interface is declared in [`src/Fvm/FvmContract.fdsl`](file:///D:/Projetos/TheFlux/src/Fvm/FvmContract.fdsl):

```flux
contract (FvmContract) {
      #L Injects .fvmbc bytecode into the resident Windows service via Named Pipe
      op fvmInjectBytecode (as string: bytecode_json, as string: stdin_text) as map

      #L Executes a local bytecode file
      op fvmExecuteFile (as string: fvmbc_path, as string: stdin_text) as map

      #L Queries whether the fluxvm service is active and listening
      op fvmIsServiceActive () as bool
}
```

### 2.1 `fvmIsServiceActive () as bool`
- **Purpose**: Checks whether the background FVM daemon or Windows Service is listening for IPC requests.
- **Returns**: `true` if `\\.\pipe\theflux_fvm` is active or SCM reports the service is running; `false` otherwise.
- **Behavior**: Executes `fluxvm.exe --status`, providing instantaneous non-blocking responses.

### 2.2 `fvmExecuteFile (as string: fvmbc_path, as string: stdin_text) as map`
- **Purpose**: Executes an existing `.fvmbc` bytecode file from disk in standalone mode.
- **Parameters**:
  - `fvmbc_path`: Path to the `.fvmbc` file (safely escaped with quotes to handle spaces).
  - `stdin_text`: Optional standard input text forwarded via `--stdin`.
- **Return Map**:
  - `res["success"]`: Boolean indicating execution status (`true`).
  - `res["stdout"]`: Captured standard output text.

### 2.3 `fvmInjectBytecode (as string: bytecode_json, as string: stdin_text) as map`
- **Purpose**: Injects a serialized JSON bytecode payload into the pre-warmed resident daemon.
- **Parameters**:
  - `bytecode_json`: Serialized `.fvmbc` program content.
  - `stdin_text`: Optional standard input string.
- **Behavior**: Writes bytecode into an ephemeral `temp/fvm_inject_<timestamp>.fvmbc` file, invokes `fluxvm.exe --inject`, and cleans up the temporary file upon completion. If the daemon is active, execution occurs via Named Pipe IPC; otherwise, transparent local fallback is performed.
- **Return Map**:
  - `res["success"]`: Success boolean (`true`).
  - `res["stdout"]`: Standard output emitted by the VM.

---

## 3. `FvmClient` Agent Implementation

The agent in [`src/Fvm/FvmClient.fdsl`](file:///D:/Projetos/TheFlux/src/Fvm/FvmClient.fdsl) implements `FvmContract`:

```flux
use RuntimeStdLib
use IoStdLib
use FvmContract.fdsl

agent (FvmClient) impl FvmContract {
      #L Implementations of fvmInjectBytecode, fvmExecuteFile, and fvmIsServiceActive
}
```

### Security and Robustness Highlights
- **Dynamic Binary Resolution**: Automatically detects `bin/fluxvm.exe` whether invoked via relative paths (`.\bin\fluxvm.exe`), local folders (`bin\fluxvm.exe`), or system `PATH`.
- **Argument Escaping**: File paths and input strings are safely enclosed in quotes.
- **Safe Scratch File Lifecycle**: Creates `temp/` on demand and ensures deletion of temporary injection artifacts.

---

## 4. Canonical TheFlux Code Example

The standard usage pattern is demonstrated in [`examples/Canon/ExampleOfFvmClient.flux`](file:///D:/Projetos/TheFlux/examples/Canon/ExampleOfFvmClient.flux):

```flux
use src::Fvm::FvmClient as FC

program (ExampleOfFvmClient) {
      print("=== FVM Client: Verificando status do servico ===")
      mut as bool: active = FC::fvmIsServiceActive()
      print("Servico FVM ativo: " + active)

      print("=== FVM Client: Execucao de arquivo de bytecode local ===")
      mut as map: res_exec = FC::fvmExecuteFile("t_fvmbc/test_acc.fvmbc", "")
      print("Sucesso: " + res_exec["success"])
      print("Saida:")
      print(res_exec["stdout"])

      print("=== FVM Client: Injecao de bytecode no servico ou fallback local ===")
      mut as string: bc_content = stdIoReadFile("t_fvmbc/test_acc.fvmbc")
      mut as map: res_inj = FC::fvmInjectBytecode(bc_content, "")
      print("Injecao sucesso: " + res_inj["success"])
      print("Injecao saida:")
      print(res_inj["stdout"])
}
```
