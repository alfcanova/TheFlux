# 📚 `RuntimeStdLib` — Controle da Máquina Virtual TheFlux, Memória e Telemetria de Execução

> **Pilar Arquitetural**: Pilar 4 (Sistema, I/O & Rede)  
> **Status**: ✅ Homologado com 100% de Paridade nos 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Arquivo Mestre**: `stdlib/RuntimeStdLib/RuntimeStdLib.fdsl`  
> **Modo de Importação**: `use RuntimeStdLib` ou `use RuntimeStdLib::<Modulo>::<operacao>`

---

## 1. Visão Geral e Funcionalidades

A biblioteca padrão **`RuntimeStdLib`** integra o ecossistema oficial da linguagem TheFlux, fornecendo suporte de nível de sistema e algoritmos nativos certificados.

Inspeção e controle de baixo nível da VM e ambiente de execução: métricas de alocação de memória no heap, estatísticas de coleta de lixo, telemetria de chamadas e informações de versão do compilador e do host.

### 1.1 Características e Princípios de Design
- **Compilação e Fusão Estática**: Todos os módulos de domínio são fundidos no agente unificado `RuntimeStdLib` em tempo de compilação, sem sobrecarga (*overhead*) de despacho indireto.
- **Isolamento e Segurança**: As operações verificam limites operacionais e utilizam despacho por contratos formais rigorosos.
- **Compatibilidade Multi-Backend**: Execução bit-a-bit idêntica em interpretador (`in`), bytecode (`vm`, `vmr`), nativo AOT (`llvm`) e WebAssembly (`wat`, `wasm`).

---

## 2. Estrutura Modular e Contratos

A biblioteca é composta por **4 módulos de domínio** e declara **45 operações públicas**:

| Arquivo de Domínio | Contrato Formal | Responsabilidade Principal | Qtd. Ops |
|---|---|---|:---:|
| `RuntimeControl.fdsl` | `RuntimeControlContract` | Domínio especializado de `RuntimeControl` | 8 |
| `RuntimeHost.fdsl` | `RuntimeHostContract` | Domínio especializado de `RuntimeHost` | 18 |
| `RuntimeMemory.fdsl` | `RuntimeMemoryContract` | Domínio especializado de `RuntimeMemory` | 6 |
| `RuntimeType.fdsl` | `RuntimeTypeContract` | Domínio especializado de `RuntimeType` | 13 |

---

## 3. Tipos, Estruturas e Enumerações Públicas

A biblioteca `RuntimeStdLib` opera diretamente com os tipos nativos e primitivos da linguagem TheFlux (`string`, `int64`, `float64`, `bool`, `list of data`, etc.), sem exigir tipos compostos adicionais.

---

## 4. Catálogo Detalhado de Operações por Domínio

### 4.1 Contrato `RuntimeControlContract` (`RuntimeControl.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `runtimePanic` | `op runtimePanic (as string: message) as bool` | `bool` |
| `runtimeTrap` | `op runtimeTrap () as bool` | `bool` |
| `runtimeSetPanicHook` | `op runtimeSetPanicHook (as string: agent_name, as string: op_name) as bool` | `bool` |
| `runtimeStackTrace` | `op runtimeStackTrace () as list of data` | `list of data` |
| `panic` | `op panic (as string: message) as bool` | `bool` |
| `trap` | `op trap () as bool` | `bool` |
| `setPanicHook` | `op setPanicHook (as string: agent_name, as string: op_name) as bool` | `bool` |
| `stackTrace` | `op stackTrace () as list of data` | `list of data` |

#### Ficha Técnica das Operações:

##### `op runtimePanic`
```flux
op runtimePanic (as string: message) as bool
```
- **Parâmetros**:
  - `message` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `runtimePanic` no domínio `RuntimeControlContract`.

##### `op runtimeTrap`
```flux
op runtimeTrap () as bool
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `runtimeTrap` no domínio `RuntimeControlContract`.

##### `op runtimeSetPanicHook`
```flux
op runtimeSetPanicHook (as string: agent_name, as string: op_name) as bool
```
- **Parâmetros**:
  - `agent_name` (`string`): Parâmetro de entrada para processamento da operação.
  - `op_name` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `runtimeSetPanicHook` no domínio `RuntimeControlContract`.

##### `op runtimeStackTrace`
```flux
op runtimeStackTrace () as list of data
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `runtimeStackTrace` no domínio `RuntimeControlContract`.

##### `op panic`
```flux
op panic (as string: message) as bool
```
- **Parâmetros**:
  - `message` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `panic` no domínio `RuntimeControlContract`.

##### `op trap`
```flux
op trap () as bool
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `trap` no domínio `RuntimeControlContract`.

##### `op setPanicHook`
```flux
op setPanicHook (as string: agent_name, as string: op_name) as bool
```
- **Parâmetros**:
  - `agent_name` (`string`): Parâmetro de entrada para processamento da operação.
  - `op_name` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `setPanicHook` no domínio `RuntimeControlContract`.

##### `op stackTrace`
```flux
op stackTrace () as list of data
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stackTrace` no domínio `RuntimeControlContract`.

### 4.2 Contrato `RuntimeHostContract` (`RuntimeHost.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `runtimeBackend` | `op runtimeBackend () as string` | `string` |
| `runtimeIsNative` | `op runtimeIsNative () as bool` | `bool` |
| `runtimeIsWasm` | `op runtimeIsWasm () as bool` | `bool` |
| `runtimeIsInterpreter` | `op runtimeIsInterpreter () as bool` | `bool` |
| `runtimePointerSize` | `op runtimePointerSize () as int64` | `int64` |
| `runtimeCompilerVersion` | `op runtimeCompilerVersion () as string` | `string` |
| `runtimeGetArgs` | `op runtimeGetArgs () as list of data` | `list of data` |
| `runtimeGetArgCount` | `op runtimeGetArgCount () as int64` | `int64` |
| `runtimeGetArg` | `op runtimeGetArg (as int64: index) as string` | `string` |
| `runtimeExecutablePath` | `op runtimeExecutablePath () as string` | `string` |
| `backend` | `op backend () as string` | `string` |
| `isNative` | `op isNative () as bool` | `bool` |
| `isWasm` | `op isWasm () as bool` | `bool` |
| `isInterpreter` | `op isInterpreter () as bool` | `bool` |
| `compilerVersion` | `op compilerVersion () as string` | `string` |
| `getArgs` | `op getArgs () as list of data` | `list of data` |
| `getArgCount` | `op getArgCount () as int64` | `int64` |
| `getArg` | `op getArg (as int64: index) as string` | `string` |

#### Ficha Técnica das Operações:

##### `op runtimeBackend`
```flux
op runtimeBackend () as string
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `runtimeBackend` no domínio `RuntimeHostContract`.

##### `op runtimeIsNative`
```flux
op runtimeIsNative () as bool
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `runtimeIsNative` no domínio `RuntimeHostContract`.

##### `op runtimeIsWasm`
```flux
op runtimeIsWasm () as bool
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `runtimeIsWasm` no domínio `RuntimeHostContract`.

##### `op runtimeIsInterpreter`
```flux
op runtimeIsInterpreter () as bool
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `runtimeIsInterpreter` no domínio `RuntimeHostContract`.

##### `op runtimePointerSize`
```flux
op runtimePointerSize () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `runtimePointerSize` no domínio `RuntimeHostContract`.

##### `op runtimeCompilerVersion`
```flux
op runtimeCompilerVersion () as string
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `runtimeCompilerVersion` no domínio `RuntimeHostContract`.

##### `op runtimeGetArgs`
```flux
op runtimeGetArgs () as list of data
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `runtimeGetArgs` no domínio `RuntimeHostContract`.

##### `op runtimeGetArgCount`
```flux
op runtimeGetArgCount () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `runtimeGetArgCount` no domínio `RuntimeHostContract`.

##### `op runtimeGetArg`
```flux
op runtimeGetArg (as int64: index) as string
```
- **Parâmetros**:
  - `index` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `runtimeGetArg` no domínio `RuntimeHostContract`.

##### `op runtimeExecutablePath`
```flux
op runtimeExecutablePath () as string
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `runtimeExecutablePath` no domínio `RuntimeHostContract`.

##### `op backend`
```flux
op backend () as string
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `backend` no domínio `RuntimeHostContract`.

##### `op isNative`
```flux
op isNative () as bool
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `isNative` no domínio `RuntimeHostContract`.

##### `op isWasm`
```flux
op isWasm () as bool
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `isWasm` no domínio `RuntimeHostContract`.

##### `op isInterpreter`
```flux
op isInterpreter () as bool
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `isInterpreter` no domínio `RuntimeHostContract`.

##### `op compilerVersion`
```flux
op compilerVersion () as string
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `compilerVersion` no domínio `RuntimeHostContract`.

##### `op getArgs`
```flux
op getArgs () as list of data
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `getArgs` no domínio `RuntimeHostContract`.

##### `op getArgCount`
```flux
op getArgCount () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `getArgCount` no domínio `RuntimeHostContract`.

##### `op getArg`
```flux
op getArg (as int64: index) as string
```
- **Parâmetros**:
  - `index` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `getArg` no domínio `RuntimeHostContract`.

### 4.3 Contrato `RuntimeMemoryContract` (`RuntimeMemory.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `runtimeAllocatedMemory` | `op runtimeAllocatedMemory () as int64` | `int64` |
| `runtimeHeapSize` | `op runtimeHeapSize () as int64` | `int64` |
| `runtimePointerOf` | `op runtimePointerOf (as data: value) as int64` | `int64` |
| `allocatedMemory` | `op allocatedMemory () as int64` | `int64` |
| `heapSize` | `op heapSize () as int64` | `int64` |
| `pointerOf` | `op pointerOf (as data: value) as int64` | `int64` |

#### Ficha Técnica das Operações:

##### `op runtimeAllocatedMemory`
```flux
op runtimeAllocatedMemory () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `runtimeAllocatedMemory` no domínio `RuntimeMemoryContract`.

##### `op runtimeHeapSize`
```flux
op runtimeHeapSize () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `runtimeHeapSize` no domínio `RuntimeMemoryContract`.

##### `op runtimePointerOf`
```flux
op runtimePointerOf (as data: value) as int64
```
- **Parâmetros**:
  - `value` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `runtimePointerOf` no domínio `RuntimeMemoryContract`.

##### `op allocatedMemory`
```flux
op allocatedMemory () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `allocatedMemory` no domínio `RuntimeMemoryContract`.

##### `op heapSize`
```flux
op heapSize () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `heapSize` no domínio `RuntimeMemoryContract`.

##### `op pointerOf`
```flux
op pointerOf (as data: value) as int64
```
- **Parâmetros**:
  - `value` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `pointerOf` no domínio `RuntimeMemoryContract`.

### 4.4 Contrato `RuntimeTypeContract` (`RuntimeType.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `runtimeGetTypeName` | `op runtimeGetTypeName (as data: value) as string` | `string` |
| `runtimeGetTypeId` | `op runtimeGetTypeId (as data: value) as int64` | `int64` |
| `runtimeIsPrimitive` | `op runtimeIsPrimitive (as data: value) as bool` | `bool` |
| `runtimeIsCollection` | `op runtimeIsCollection (as data: value) as bool` | `bool` |
| `runtimeIsStruct` | `op runtimeIsStruct (as data: value) as bool` | `bool` |
| `runtimeSizeOf` | `op runtimeSizeOf (as data: value) as int64` | `int64` |
| `runtimeGetStructMetadata` | `op runtimeGetStructMetadata (as string: struct_name) as map` | `map` |
| `getTypeName` | `op getTypeName (as data: value) as string` | `string` |
| `getTypeId` | `op getTypeId (as data: value) as int64` | `int64` |
| `isPrimitive` | `op isPrimitive (as data: value) as bool` | `bool` |
| `isCollection` | `op isCollection (as data: value) as bool` | `bool` |
| `isStruct` | `op isStruct (as data: value) as bool` | `bool` |
| `sizeOf` | `op sizeOf (as data: value) as int64` | `int64` |

#### Ficha Técnica das Operações:

##### `op runtimeGetTypeName`
```flux
op runtimeGetTypeName (as data: value) as string
```
- **Parâmetros**:
  - `value` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `runtimeGetTypeName` no domínio `RuntimeTypeContract`.

##### `op runtimeGetTypeId`
```flux
op runtimeGetTypeId (as data: value) as int64
```
- **Parâmetros**:
  - `value` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `runtimeGetTypeId` no domínio `RuntimeTypeContract`.

##### `op runtimeIsPrimitive`
```flux
op runtimeIsPrimitive (as data: value) as bool
```
- **Parâmetros**:
  - `value` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `runtimeIsPrimitive` no domínio `RuntimeTypeContract`.

##### `op runtimeIsCollection`
```flux
op runtimeIsCollection (as data: value) as bool
```
- **Parâmetros**:
  - `value` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `runtimeIsCollection` no domínio `RuntimeTypeContract`.

##### `op runtimeIsStruct`
```flux
op runtimeIsStruct (as data: value) as bool
```
- **Parâmetros**:
  - `value` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `runtimeIsStruct` no domínio `RuntimeTypeContract`.

##### `op runtimeSizeOf`
```flux
op runtimeSizeOf (as data: value) as int64
```
- **Parâmetros**:
  - `value` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `runtimeSizeOf` no domínio `RuntimeTypeContract`.

##### `op runtimeGetStructMetadata`
```flux
op runtimeGetStructMetadata (as string: struct_name) as map
```
- **Parâmetros**:
  - `struct_name` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `runtimeGetStructMetadata` no domínio `RuntimeTypeContract`.

##### `op getTypeName`
```flux
op getTypeName (as data: value) as string
```
- **Parâmetros**:
  - `value` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `getTypeName` no domínio `RuntimeTypeContract`.

##### `op getTypeId`
```flux
op getTypeId (as data: value) as int64
```
- **Parâmetros**:
  - `value` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `getTypeId` no domínio `RuntimeTypeContract`.

##### `op isPrimitive`
```flux
op isPrimitive (as data: value) as bool
```
- **Parâmetros**:
  - `value` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `isPrimitive` no domínio `RuntimeTypeContract`.

##### `op isCollection`
```flux
op isCollection (as data: value) as bool
```
- **Parâmetros**:
  - `value` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `isCollection` no domínio `RuntimeTypeContract`.

##### `op isStruct`
```flux
op isStruct (as data: value) as bool
```
- **Parâmetros**:
  - `value` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `isStruct` no domínio `RuntimeTypeContract`.

##### `op sizeOf`
```flux
op sizeOf (as data: value) as int64
```
- **Parâmetros**:
  - `value` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `sizeOf` no domínio `RuntimeTypeContract`.

---

## 5. Exemplos Canônicos de Uso em TheFlux

O exemplo a seguir demonstra a importação e o consumo prático da biblioteca:

```flux
# Exemplo Canônico de Consumo da RuntimeStdLib
use RuntimeStdLib

program (ExemploRuntimeStdLib) {
      println("==================================================")
      println("  Demonstracao da Standard Library: RuntimeStdLib")
      println("==================================================")

      # Chamada da operacao canônica
      mut as data: resultado = RuntimeStdLib::runtimeVersion()
      println("Resultado obtido: " + resultado)

      println("Demonstracao concluida com sucesso.")
}
```

---

> [!TIP]
> Para consultar a visão arquitetural unificada de todas as bibliotecas, consulte o documento principal [StdLibs.md](../StdLibs.md).
