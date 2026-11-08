# 📚 `OsStdLib` — Interação com o Sistema Operacional, Processos, Ambiente e Sinais

> **Pilar Arquitetural**: Pilar 4 (Sistema, I/O & Rede)  
> **Status**: ✅ Homologado com 100% de Paridade nos 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Arquivo Mestre**: `stdlib/OsStdLib/OsStdLib.fdsl`  
> **Modo de Importação**: `use OsStdLib` ou `use OsStdLib::<Modulo>::<operacao>`

---

## 1. Visão Geral e Funcionalidades

A biblioteca padrão **`OsStdLib`** integra o ecossistema oficial da linguagem TheFlux, fornecendo suporte de nível de sistema e algoritmos nativos certificados.

Serviços do sistema operacional hospedeiro: consulta e definição de variáveis de ambiente, identificação de arquitetura de CPU e SO, inicialização e término de subprocessos, captura de códigos de saída e sinais.

### 1.1 Características e Princípios de Design
- **Compilação e Fusão Estática**: Todos os módulos de domínio são fundidos no agente unificado `OsStdLib` em tempo de compilação, sem sobrecarga (*overhead*) de despacho indireto.
- **Isolamento e Segurança**: As operações verificam limites operacionais e utilizam despacho por contratos formais rigorosos.
- **Compatibilidade Multi-Backend**: Execução bit-a-bit idêntica em interpretador (`in`), bytecode (`vm`, `vmr`), nativo AOT (`llvm`) e WebAssembly (`wat`, `wasm`).

---

## 2. Estrutura Modular e Contratos

A biblioteca é composta por **4 módulos de domínio** e declara **64 operações públicas**:

| Arquivo de Domínio | Contrato Formal | Responsabilidade Principal | Qtd. Ops |
|---|---|---|:---:|
| `OsEnv.fdsl` | `OsEnvContract` | Domínio especializado de `OsEnv` | 12 |
| `OsInfo.fdsl` | `OsInfoContract` | Domínio especializado de `OsInfo` | 18 |
| `OsProcess.fdsl` | `OsProcessContract` | Domínio especializado de `OsProcess` | 15 |
| `OsSystem.fdsl` | `OsSystemContract` | Domínio especializado de `OsSystem` | 19 |

---

## 3. Tipos, Estruturas e Enumerações Públicas

A biblioteca `OsStdLib` opera diretamente com os tipos nativos e primitivos da linguagem TheFlux (`string`, `int64`, `float64`, `bool`, `list of data`, etc.), sem exigir tipos compostos adicionais.

---

## 4. Catálogo Detalhado de Operações por Domínio

### 4.1 Contrato `OsEnvContract` (`OsEnv.fdsl`)

| Operação | Assinatura | Retorno |
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

#### Ficha Técnica das Operações:

##### `op osGetEnv`
```flux
op osGetEnv (as string: name) as string
```
- **Parâmetros**:
  - `name` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `osGetEnv` no domínio `OsEnvContract`.

##### `op osGetEnvOrDefault`
```flux
op osGetEnvOrDefault (as string: name, as string: default_value) as string
```
- **Parâmetros**:
  - `name` (`string`): Parâmetro de entrada para processamento da operação.
  - `default_value` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `osGetEnvOrDefault` no domínio `OsEnvContract`.

##### `op osSetEnv`
```flux
op osSetEnv (as string: name, as string: value) as bool
```
- **Parâmetros**:
  - `name` (`string`): Parâmetro de entrada para processamento da operação.
  - `value` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `osSetEnv` no domínio `OsEnvContract`.

##### `op osHasEnv`
```flux
op osHasEnv (as string: name) as bool
```
- **Parâmetros**:
  - `name` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `osHasEnv` no domínio `OsEnvContract`.

##### `op osUnsetEnv`
```flux
op osUnsetEnv (as string: name) as bool
```
- **Parâmetros**:
  - `name` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `osUnsetEnv` no domínio `OsEnvContract`.

##### `op osListEnv`
```flux
op osListEnv () as list of data
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `osListEnv` no domínio `OsEnvContract`.

##### `op getEnv`
```flux
op getEnv (as string: name) as string
```
- **Parâmetros**:
  - `name` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `getEnv` no domínio `OsEnvContract`.

##### `op getEnvOrDefault`
```flux
op getEnvOrDefault (as string: name, as string: default_value) as string
```
- **Parâmetros**:
  - `name` (`string`): Parâmetro de entrada para processamento da operação.
  - `default_value` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `getEnvOrDefault` no domínio `OsEnvContract`.

##### `op setEnv`
```flux
op setEnv (as string: name, as string: value) as bool
```
- **Parâmetros**:
  - `name` (`string`): Parâmetro de entrada para processamento da operação.
  - `value` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setEnv` no domínio `OsEnvContract`.

##### `op hasEnv`
```flux
op hasEnv (as string: name) as bool
```
- **Parâmetros**:
  - `name` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `hasEnv` no domínio `OsEnvContract`.

##### `op unsetEnv`
```flux
op unsetEnv (as string: name) as bool
```
- **Parâmetros**:
  - `name` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `unsetEnv` no domínio `OsEnvContract`.

##### `op listEnv`
```flux
op listEnv () as list of data
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listEnv` no domínio `OsEnvContract`.

### 4.2 Contrato `OsInfoContract` (`OsInfo.fdsl`)

| Operação | Assinatura | Retorno |
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

#### Ficha Técnica das Operações:

##### `op osPlatform`
```flux
op osPlatform () as string
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `osPlatform` no domínio `OsInfoContract`.

##### `op osArch`
```flux
op osArch () as string
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `osArch` no domínio `OsInfoContract`.

##### `op osFamily`
```flux
op osFamily () as string
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `osFamily` no domínio `OsInfoContract`.

##### `op osHostname`
```flux
op osHostname () as string
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `osHostname` no domínio `OsInfoContract`.

##### `op osLineSeparator`
```flux
op osLineSeparator () as string
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `osLineSeparator` no domínio `OsInfoContract`.

##### `op osPathSeparator`
```flux
op osPathSeparator () as string
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `osPathSeparator` no domínio `OsInfoContract`.

##### `op osDirSeparator`
```flux
op osDirSeparator () as string
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `osDirSeparator` no domínio `OsInfoContract`.

##### `op osIsWindows`
```flux
op osIsWindows () as bool
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `osIsWindows` no domínio `OsInfoContract`.

##### `op osIsLinux`
```flux
op osIsLinux () as bool
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `osIsLinux` no domínio `OsInfoContract`.

##### `op osIsDarwin`
```flux
op osIsDarwin () as bool
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `osIsDarwin` no domínio `OsInfoContract`.

##### `op osInfoSummary`
```flux
op osInfoSummary () as string
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `osInfoSummary` no domínio `OsInfoContract`.

##### `op platform`
```flux
op platform () as string
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `platform` no domínio `OsInfoContract`.

##### `op arch`
```flux
op arch () as string
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `arch` no domínio `OsInfoContract`.

##### `op family`
```flux
op family () as string
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `family` no domínio `OsInfoContract`.

##### `op hostname`
```flux
op hostname () as string
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `hostname` no domínio `OsInfoContract`.

##### `op lineSeparator`
```flux
op lineSeparator () as string
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lineSeparator` no domínio `OsInfoContract`.

##### `op pathSeparator`
```flux
op pathSeparator () as string
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `pathSeparator` no domínio `OsInfoContract`.

##### `op dirSeparator`
```flux
op dirSeparator () as string
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dirSeparator` no domínio `OsInfoContract`.

### 4.3 Contrato `OsProcessContract` (`OsProcess.fdsl`)

| Operação | Assinatura | Retorno |
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

#### Ficha Técnica das Operações:

##### `op osGetPid`
```flux
op osGetPid () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `osGetPid` no domínio `OsProcessContract`.

##### `op osGetParentPid`
```flux
op osGetParentPid () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `osGetParentPid` no domínio `OsProcessContract`.

##### `op osCwd`
```flux
op osCwd () as string
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `osCwd` no domínio `OsProcessContract`.

##### `op osChdir`
```flux
op osChdir (as string: path) as bool
```
- **Parâmetros**:
  - `path` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `osChdir` no domínio `OsProcessContract`.

##### `op osExec`
```flux
op osExec (as string: command) as int64
```
- **Parâmetros**:
  - `command` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `osExec` no domínio `OsProcessContract`.

##### `op osExecOutput`
```flux
op osExecOutput (as string: command) as string
```
- **Parâmetros**:
  - `command` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `osExecOutput` no domínio `OsProcessContract`.

##### `op osSleep`
```flux
op osSleep (as int64: milliseconds) as bool
```
- **Parâmetros**:
  - `milliseconds` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `osSleep` no domínio `OsProcessContract`.

##### `op osProcessSummary`
```flux
op osProcessSummary () as string
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `osProcessSummary` no domínio `OsProcessContract`.

##### `op getPid`
```flux
op getPid () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `getPid` no domínio `OsProcessContract`.

##### `op getParentPid`
```flux
op getParentPid () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `getParentPid` no domínio `OsProcessContract`.

##### `op cwd`
```flux
op cwd () as string
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `cwd` no domínio `OsProcessContract`.

##### `op chdir`
```flux
op chdir (as string: path) as bool
```
- **Parâmetros**:
  - `path` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `chdir` no domínio `OsProcessContract`.

##### `op exec`
```flux
op exec (as string: command) as int64
```
- **Parâmetros**:
  - `command` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `exec` no domínio `OsProcessContract`.

##### `op execOutput`
```flux
op execOutput (as string: command) as string
```
- **Parâmetros**:
  - `command` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `execOutput` no domínio `OsProcessContract`.

##### `op sleep`
```flux
op sleep (as int64: milliseconds) as bool
```
- **Parâmetros**:
  - `milliseconds` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `sleep` no domínio `OsProcessContract`.

### 4.4 Contrato `OsSystemContract` (`OsSystem.fdsl`)

| Operação | Assinatura | Retorno |
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

#### Ficha Técnica das Operações:

##### `op osUserName`
```flux
op osUserName () as string
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `osUserName` no domínio `OsSystemContract`.

##### `op osHomeDir`
```flux
op osHomeDir () as string
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `osHomeDir` no domínio `OsSystemContract`.

##### `op osTempDir`
```flux
op osTempDir () as string
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `osTempDir` no domínio `OsSystemContract`.

##### `op osCpuCount`
```flux
op osCpuCount () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `osCpuCount` no domínio `OsSystemContract`.

##### `op osUptime`
```flux
op osUptime () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `osUptime` no domínio `OsSystemContract`.

##### `op osMemoryTotal`
```flux
op osMemoryTotal () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `osMemoryTotal` no domínio `OsSystemContract`.

##### `op osMemoryFree`
```flux
op osMemoryFree () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `osMemoryFree` no domínio `OsSystemContract`.

##### `op osMemoryTotalMb`
```flux
op osMemoryTotalMb () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `osMemoryTotalMb` no domínio `OsSystemContract`.

##### `op osMemoryTotalGb`
```flux
op osMemoryTotalGb () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `osMemoryTotalGb` no domínio `OsSystemContract`.

##### `op osMemoryFreeMb`
```flux
op osMemoryFreeMb () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `osMemoryFreeMb` no domínio `OsSystemContract`.

##### `op osMemoryFreeGb`
```flux
op osMemoryFreeGb () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `osMemoryFreeGb` no domínio `OsSystemContract`.

##### `op osSystemSummary`
```flux
op osSystemSummary () as string
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `osSystemSummary` no domínio `OsSystemContract`.

##### `op userName`
```flux
op userName () as string
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `userName` no domínio `OsSystemContract`.

##### `op homeDir`
```flux
op homeDir () as string
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `homeDir` no domínio `OsSystemContract`.

##### `op tempDir`
```flux
op tempDir () as string
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `tempDir` no domínio `OsSystemContract`.

##### `op cpuCount`
```flux
op cpuCount () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `cpuCount` no domínio `OsSystemContract`.

##### `op uptime`
```flux
op uptime () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `uptime` no domínio `OsSystemContract`.

##### `op memoryTotal`
```flux
op memoryTotal () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `memoryTotal` no domínio `OsSystemContract`.

##### `op memoryFree`
```flux
op memoryFree () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `memoryFree` no domínio `OsSystemContract`.

---

## 5. Exemplos Canônicos de Uso em TheFlux

O exemplo a seguir demonstra a importação e o consumo prático da biblioteca:

```flux
# Exemplo Canônico de Consumo da OsStdLib
use OsStdLib

program (ExemploOsStdLib) {
      println("==================================================")
      println("  Demonstracao da Standard Library: OsStdLib")
      println("==================================================")

      # Chamada da operacao canônica
      mut as data: resultado = OsStdLib::osGetEnv("PATH")
      println("Resultado obtido: " + resultado)

      println("Demonstracao concluida com sucesso.")
}
```

---

> [!TIP]
> Para consultar a visão arquitetural unificada de todas as bibliotecas, consulte o documento principal [StdLibs.md](../StdLibs.md).
