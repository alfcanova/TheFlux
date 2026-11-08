# 📚 `ThreadStdLib` — Concorrência Multithread, Primitivas de Sincronização e Canais

> **Pilar Arquitetural**: Pilar 4 (Sistema, I/O & Rede)  
> **Status**: ✅ Homologado com 100% de Paridade nos 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Arquivo Mestre**: `stdlib/ThreadStdLib/ThreadStdLib.fdsl`  
> **Modo de Importação**: `use ThreadStdLib` ou `use ThreadStdLib::<Modulo>::<operacao>`

---

## 1. Visão Geral e Funcionalidades

A biblioteca padrão **`ThreadStdLib`** integra o ecossistema oficial da linguagem TheFlux, fornecendo suporte de nível de sistema e algoritmos nativos certificados.

Execução concorrente e paralela nativa: criação e junção de threads do sistema operacional, mutexes reentrantes, variáveis de condição, semáforos contadores e canais de mensagens unidirecionais seguros entre threads.

### 1.1 Características e Princípios de Design
- **Compilação e Fusão Estática**: Todos os módulos de domínio são fundidos no agente unificado `ThreadStdLib` em tempo de compilação, sem sobrecarga (*overhead*) de despacho indireto.
- **Isolamento e Segurança**: As operações verificam limites operacionais e utilizam despacho por contratos formais rigorosos.
- **Compatibilidade Multi-Backend**: Execução bit-a-bit idêntica em interpretador (`in`), bytecode (`vm`, `vmr`), nativo AOT (`llvm`) e WebAssembly (`wat`, `wasm`).

---

## 2. Estrutura Modular e Contratos

A biblioteca é composta por **4 módulos de domínio** e declara **57 operações públicas**:

| Arquivo de Domínio | Contrato Formal | Responsabilidade Principal | Qtd. Ops |
|---|---|---|:---:|
| `ThreadChannel.fdsl` | `ThreadChannelContract` | Domínio especializado de `ThreadChannel` | 17 |
| `ThreadLifecycle.fdsl` | `ThreadLifecycleContract` | Domínio especializado de `ThreadLifecycle` | 9 |
| `ThreadSync.fdsl` | `ThreadSyncContract` | Domínio especializado de `ThreadSync` | 24 |
| `ThreadSystem.fdsl` | `ThreadSystemContract` | Domínio especializado de `ThreadSystem` | 7 |

---

## 3. Tipos, Estruturas e Enumerações Públicas

A biblioteca `ThreadStdLib` opera diretamente com os tipos nativos e primitivos da linguagem TheFlux (`string`, `int64`, `float64`, `bool`, `list of data`, etc.), sem exigir tipos compostos adicionais.

---

## 4. Catálogo Detalhado de Operações por Domínio

### 4.1 Contrato `ThreadChannelContract` (`ThreadChannel.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `channelCreate` | `op channelCreate () as map` | `map` |
| `channelCreateWithCapacity` | `op channelCreateWithCapacity (as int64: capacity) as map` | `map` |
| `channelSend` | `op channelSend (as data: port, as data: message) as bool` | `bool` |
| `channelRecv` | `op channelRecv (as data: port) as data` | `data` |
| `channelTrySend` | `op channelTrySend (as data: port, as data: message) as bool` | `bool` |
| `channelTryRecv` | `op channelTryRecv (as data: port) as map` | `map` |
| `channelClose` | `op channelClose (as data: port) as bool` | `bool` |
| `channelIsClosed` | `op channelIsClosed (as data: port) as bool` | `bool` |
| `channelIsEmpty` | `op channelIsEmpty (as data: port) as bool` | `bool` |
| `channelLength` | `op channelLength (as data: port) as int64` | `int64` |
| `channelCapacity` | `op channelCapacity (as data: port) as int64` | `int64` |
| `chanCreate` | `op chanCreate () as map` | `map` |
| `chanSend` | `op chanSend (as data: port, as data: message) as bool` | `bool` |
| `chanRecv` | `op chanRecv (as data: port) as data` | `data` |
| `chanClose` | `op chanClose (as data: port) as bool` | `bool` |
| `chanLen` | `op chanLen (as data: port) as int64` | `int64` |
| `chanCap` | `op chanCap (as data: port) as int64` | `int64` |

#### Ficha Técnica das Operações:

##### `op channelCreate`
```flux
op channelCreate () as map
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `channelCreate` no domínio `ThreadChannelContract`.

##### `op channelCreateWithCapacity`
```flux
op channelCreateWithCapacity (as int64: capacity) as map
```
- **Parâmetros**:
  - `capacity` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `channelCreateWithCapacity` no domínio `ThreadChannelContract`.

##### `op channelSend`
```flux
op channelSend (as data: port, as data: message) as bool
```
- **Parâmetros**:
  - `port` (`data`): Parâmetro de entrada para processamento da operação.
  - `message` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `channelSend` no domínio `ThreadChannelContract`.

##### `op channelRecv`
```flux
op channelRecv (as data: port) as data
```
- **Parâmetros**:
  - `port` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `channelRecv` no domínio `ThreadChannelContract`.

##### `op channelTrySend`
```flux
op channelTrySend (as data: port, as data: message) as bool
```
- **Parâmetros**:
  - `port` (`data`): Parâmetro de entrada para processamento da operação.
  - `message` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `channelTrySend` no domínio `ThreadChannelContract`.

##### `op channelTryRecv`
```flux
op channelTryRecv (as data: port) as map
```
- **Parâmetros**:
  - `port` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `channelTryRecv` no domínio `ThreadChannelContract`.

##### `op channelClose`
```flux
op channelClose (as data: port) as bool
```
- **Parâmetros**:
  - `port` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `channelClose` no domínio `ThreadChannelContract`.

##### `op channelIsClosed`
```flux
op channelIsClosed (as data: port) as bool
```
- **Parâmetros**:
  - `port` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `channelIsClosed` no domínio `ThreadChannelContract`.

##### `op channelIsEmpty`
```flux
op channelIsEmpty (as data: port) as bool
```
- **Parâmetros**:
  - `port` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `channelIsEmpty` no domínio `ThreadChannelContract`.

##### `op channelLength`
```flux
op channelLength (as data: port) as int64
```
- **Parâmetros**:
  - `port` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `channelLength` no domínio `ThreadChannelContract`.

##### `op channelCapacity`
```flux
op channelCapacity (as data: port) as int64
```
- **Parâmetros**:
  - `port` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `channelCapacity` no domínio `ThreadChannelContract`.

##### `op chanCreate`
```flux
op chanCreate () as map
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `chanCreate` no domínio `ThreadChannelContract`.

##### `op chanSend`
```flux
op chanSend (as data: port, as data: message) as bool
```
- **Parâmetros**:
  - `port` (`data`): Parâmetro de entrada para processamento da operação.
  - `message` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `chanSend` no domínio `ThreadChannelContract`.

##### `op chanRecv`
```flux
op chanRecv (as data: port) as data
```
- **Parâmetros**:
  - `port` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `chanRecv` no domínio `ThreadChannelContract`.

##### `op chanClose`
```flux
op chanClose (as data: port) as bool
```
- **Parâmetros**:
  - `port` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `chanClose` no domínio `ThreadChannelContract`.

##### `op chanLen`
```flux
op chanLen (as data: port) as int64
```
- **Parâmetros**:
  - `port` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `chanLen` no domínio `ThreadChannelContract`.

##### `op chanCap`
```flux
op chanCap (as data: port) as int64
```
- **Parâmetros**:
  - `port` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `chanCap` no domínio `ThreadChannelContract`.

### 4.2 Contrato `ThreadLifecycleContract` (`ThreadLifecycle.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `threadSpawn` | `op threadSpawn (as string: agent_name, as string: op_name, as data: payload) as int64` | `int64` |
| `threadJoin` | `op threadJoin (as int64: thread_id) as data` | `data` |
| `threadIsAlive` | `op threadIsAlive (as int64: thread_id) as bool` | `bool` |
| `threadCurrentId` | `op threadCurrentId () as int64` | `int64` |
| `threadDetach` | `op threadDetach (as int64: thread_id) as bool` | `bool` |
| `spawnTask` | `op spawnTask (as string: agent_name, as string: op_name, as data: payload) as int64` | `int64` |
| `joinTask` | `op joinTask (as int64: thread_id) as data` | `data` |
| `isAlive` | `op isAlive (as int64: thread_id) as bool` | `bool` |
| `currentThreadId` | `op currentThreadId () as int64` | `int64` |

#### Ficha Técnica das Operações:

##### `op threadSpawn`
```flux
op threadSpawn (as string: agent_name, as string: op_name, as data: payload) as int64
```
- **Parâmetros**:
  - `agent_name` (`string`): Parâmetro de entrada para processamento da operação.
  - `op_name` (`string`): Parâmetro de entrada para processamento da operação.
  - `payload` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `threadSpawn` no domínio `ThreadLifecycleContract`.

##### `op threadJoin`
```flux
op threadJoin (as int64: thread_id) as data
```
- **Parâmetros**:
  - `thread_id` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `threadJoin` no domínio `ThreadLifecycleContract`.

##### `op threadIsAlive`
```flux
op threadIsAlive (as int64: thread_id) as bool
```
- **Parâmetros**:
  - `thread_id` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `threadIsAlive` no domínio `ThreadLifecycleContract`.

##### `op threadCurrentId`
```flux
op threadCurrentId () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `threadCurrentId` no domínio `ThreadLifecycleContract`.

##### `op threadDetach`
```flux
op threadDetach (as int64: thread_id) as bool
```
- **Parâmetros**:
  - `thread_id` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `threadDetach` no domínio `ThreadLifecycleContract`.

##### `op spawnTask`
```flux
op spawnTask (as string: agent_name, as string: op_name, as data: payload) as int64
```
- **Parâmetros**:
  - `agent_name` (`string`): Parâmetro de entrada para processamento da operação.
  - `op_name` (`string`): Parâmetro de entrada para processamento da operação.
  - `payload` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `spawnTask` no domínio `ThreadLifecycleContract`.

##### `op joinTask`
```flux
op joinTask (as int64: thread_id) as data
```
- **Parâmetros**:
  - `thread_id` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `joinTask` no domínio `ThreadLifecycleContract`.

##### `op isAlive`
```flux
op isAlive (as int64: thread_id) as bool
```
- **Parâmetros**:
  - `thread_id` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `isAlive` no domínio `ThreadLifecycleContract`.

##### `op currentThreadId`
```flux
op currentThreadId () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `currentThreadId` no domínio `ThreadLifecycleContract`.

### 4.3 Contrato `ThreadSyncContract` (`ThreadSync.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `mutexCreate` | `op mutexCreate () as int64` | `int64` |
| `mutexLock` | `op mutexLock (as int64: mutex_id) as bool` | `bool` |
| `mutexUnlock` | `op mutexUnlock (as int64: mutex_id) as bool` | `bool` |
| `mutexTryLock` | `op mutexTryLock (as int64: mutex_id) as bool` | `bool` |
| `mutexDestroy` | `op mutexDestroy (as int64: mutex_id) as bool` | `bool` |
| `atomicCreate` | `op atomicCreate (as int64: initial_value) as int64` | `int64` |
| `atomicGet` | `op atomicGet (as int64: atomic_id) as int64` | `int64` |
| `atomicSet` | `op atomicSet (as int64: atomic_id, as int64: value) as bool` | `bool` |
| `atomicAdd` | `op atomicAdd (as int64: atomic_id, as int64: delta) as int64` | `int64` |
| `atomicCas` | `op atomicCas (as int64: atomic_id, as int64: expected, as int64: desired) as bool` | `bool` |
| `atomicDestroy` | `op atomicDestroy (as int64: atomic_id) as bool` | `bool` |
| `waitGroupCreate` | `op waitGroupCreate () as int64` | `int64` |
| `waitGroupAdd` | `op waitGroupAdd (as int64: wg_id, as int64: delta) as bool` | `bool` |
| `waitGroupDone` | `op waitGroupDone (as int64: wg_id) as bool` | `bool` |
| `waitGroupWait` | `op waitGroupWait (as int64: wg_id) as bool` | `bool` |
| `waitGroupDestroy` | `op waitGroupDestroy (as int64: wg_id) as bool` | `bool` |
| `lock` | `op lock (as int64: mutex_id) as bool` | `bool` |
| `unlock` | `op unlock (as int64: mutex_id) as bool` | `bool` |
| `tryLock` | `op tryLock (as int64: mutex_id) as bool` | `bool` |
| `atomicLoad` | `op atomicLoad (as int64: atomic_id) as int64` | `int64` |
| `atomicStore` | `op atomicStore (as int64: atomic_id, as int64: value) as bool` | `bool` |
| `wgAdd` | `op wgAdd (as int64: wg_id, as int64: delta) as bool` | `bool` |
| `wgDone` | `op wgDone (as int64: wg_id) as bool` | `bool` |
| `wgWait` | `op wgWait (as int64: wg_id) as bool` | `bool` |

#### Ficha Técnica das Operações:

##### `op mutexCreate`
```flux
op mutexCreate () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mutexCreate` no domínio `ThreadSyncContract`.

##### `op mutexLock`
```flux
op mutexLock (as int64: mutex_id) as bool
```
- **Parâmetros**:
  - `mutex_id` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mutexLock` no domínio `ThreadSyncContract`.

##### `op mutexUnlock`
```flux
op mutexUnlock (as int64: mutex_id) as bool
```
- **Parâmetros**:
  - `mutex_id` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mutexUnlock` no domínio `ThreadSyncContract`.

##### `op mutexTryLock`
```flux
op mutexTryLock (as int64: mutex_id) as bool
```
- **Parâmetros**:
  - `mutex_id` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mutexTryLock` no domínio `ThreadSyncContract`.

##### `op mutexDestroy`
```flux
op mutexDestroy (as int64: mutex_id) as bool
```
- **Parâmetros**:
  - `mutex_id` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `mutexDestroy` no domínio `ThreadSyncContract`.

##### `op atomicCreate`
```flux
op atomicCreate (as int64: initial_value) as int64
```
- **Parâmetros**:
  - `initial_value` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `atomicCreate` no domínio `ThreadSyncContract`.

##### `op atomicGet`
```flux
op atomicGet (as int64: atomic_id) as int64
```
- **Parâmetros**:
  - `atomic_id` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `atomicGet` no domínio `ThreadSyncContract`.

##### `op atomicSet`
```flux
op atomicSet (as int64: atomic_id, as int64: value) as bool
```
- **Parâmetros**:
  - `atomic_id` (`int64`): Parâmetro de entrada para processamento da operação.
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `atomicSet` no domínio `ThreadSyncContract`.

##### `op atomicAdd`
```flux
op atomicAdd (as int64: atomic_id, as int64: delta) as int64
```
- **Parâmetros**:
  - `atomic_id` (`int64`): Parâmetro de entrada para processamento da operação.
  - `delta` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `atomicAdd` no domínio `ThreadSyncContract`.

##### `op atomicCas`
```flux
op atomicCas (as int64: atomic_id, as int64: expected, as int64: desired) as bool
```
- **Parâmetros**:
  - `atomic_id` (`int64`): Parâmetro de entrada para processamento da operação.
  - `expected` (`int64`): Parâmetro de entrada para processamento da operação.
  - `desired` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `atomicCas` no domínio `ThreadSyncContract`.

##### `op atomicDestroy`
```flux
op atomicDestroy (as int64: atomic_id) as bool
```
- **Parâmetros**:
  - `atomic_id` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `atomicDestroy` no domínio `ThreadSyncContract`.

##### `op waitGroupCreate`
```flux
op waitGroupCreate () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `waitGroupCreate` no domínio `ThreadSyncContract`.

##### `op waitGroupAdd`
```flux
op waitGroupAdd (as int64: wg_id, as int64: delta) as bool
```
- **Parâmetros**:
  - `wg_id` (`int64`): Parâmetro de entrada para processamento da operação.
  - `delta` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `waitGroupAdd` no domínio `ThreadSyncContract`.

##### `op waitGroupDone`
```flux
op waitGroupDone (as int64: wg_id) as bool
```
- **Parâmetros**:
  - `wg_id` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `waitGroupDone` no domínio `ThreadSyncContract`.

##### `op waitGroupWait`
```flux
op waitGroupWait (as int64: wg_id) as bool
```
- **Parâmetros**:
  - `wg_id` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `waitGroupWait` no domínio `ThreadSyncContract`.

##### `op waitGroupDestroy`
```flux
op waitGroupDestroy (as int64: wg_id) as bool
```
- **Parâmetros**:
  - `wg_id` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `waitGroupDestroy` no domínio `ThreadSyncContract`.

##### `op lock`
```flux
op lock (as int64: mutex_id) as bool
```
- **Parâmetros**:
  - `mutex_id` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `lock` no domínio `ThreadSyncContract`.

##### `op unlock`
```flux
op unlock (as int64: mutex_id) as bool
```
- **Parâmetros**:
  - `mutex_id` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `unlock` no domínio `ThreadSyncContract`.

##### `op tryLock`
```flux
op tryLock (as int64: mutex_id) as bool
```
- **Parâmetros**:
  - `mutex_id` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `tryLock` no domínio `ThreadSyncContract`.

##### `op atomicLoad`
```flux
op atomicLoad (as int64: atomic_id) as int64
```
- **Parâmetros**:
  - `atomic_id` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `atomicLoad` no domínio `ThreadSyncContract`.

##### `op atomicStore`
```flux
op atomicStore (as int64: atomic_id, as int64: value) as bool
```
- **Parâmetros**:
  - `atomic_id` (`int64`): Parâmetro de entrada para processamento da operação.
  - `value` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `atomicStore` no domínio `ThreadSyncContract`.

##### `op wgAdd`
```flux
op wgAdd (as int64: wg_id, as int64: delta) as bool
```
- **Parâmetros**:
  - `wg_id` (`int64`): Parâmetro de entrada para processamento da operação.
  - `delta` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `wgAdd` no domínio `ThreadSyncContract`.

##### `op wgDone`
```flux
op wgDone (as int64: wg_id) as bool
```
- **Parâmetros**:
  - `wg_id` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `wgDone` no domínio `ThreadSyncContract`.

##### `op wgWait`
```flux
op wgWait (as int64: wg_id) as bool
```
- **Parâmetros**:
  - `wg_id` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `wgWait` no domínio `ThreadSyncContract`.

### 4.4 Contrato `ThreadSystemContract` (`ThreadSystem.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `threadHardwareConcurrency` | `op threadHardwareConcurrency () as int64` | `int64` |
| `threadSleep` | `op threadSleep (as int64: milliseconds) as bool` | `bool` |
| `threadSleepMs` | `op threadSleepMs (as int64: milliseconds) as bool` | `bool` |
| `threadYield` | `op threadYield () as bool` | `bool` |
| `hardwareConcurrency` | `op hardwareConcurrency () as int64` | `int64` |
| `sleepMs` | `op sleepMs (as int64: milliseconds) as bool` | `bool` |
| `yield` | `op yield () as bool` | `bool` |

#### Ficha Técnica das Operações:

##### `op threadHardwareConcurrency`
```flux
op threadHardwareConcurrency () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `threadHardwareConcurrency` no domínio `ThreadSystemContract`.

##### `op threadSleep`
```flux
op threadSleep (as int64: milliseconds) as bool
```
- **Parâmetros**:
  - `milliseconds` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `threadSleep` no domínio `ThreadSystemContract`.

##### `op threadSleepMs`
```flux
op threadSleepMs (as int64: milliseconds) as bool
```
- **Parâmetros**:
  - `milliseconds` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `threadSleepMs` no domínio `ThreadSystemContract`.

##### `op threadYield`
```flux
op threadYield () as bool
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `threadYield` no domínio `ThreadSystemContract`.

##### `op hardwareConcurrency`
```flux
op hardwareConcurrency () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `hardwareConcurrency` no domínio `ThreadSystemContract`.

##### `op sleepMs`
```flux
op sleepMs (as int64: milliseconds) as bool
```
- **Parâmetros**:
  - `milliseconds` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `sleepMs` no domínio `ThreadSystemContract`.

##### `op yield`
```flux
op yield () as bool
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `yield` no domínio `ThreadSystemContract`.

---

## 5. Exemplos Canônicos de Uso em TheFlux

O exemplo a seguir demonstra a importação e o consumo prático da biblioteca:

```flux
# Exemplo Canônico de Consumo da ThreadStdLib
use ThreadStdLib

program (ExemploThreadStdLib) {
      println("==================================================")
      println("  Demonstracao da Standard Library: ThreadStdLib")
      println("==================================================")

      # Chamada da operacao canônica
      mut as data: resultado = ThreadStdLib::threadCurrentId()
      println("Resultado obtido: " + resultado)

      println("Demonstracao concluida com sucesso.")
}
```

---

> [!TIP]
> Para consultar a visão arquitetural unificada de todas as bibliotecas, consulte o documento principal [StdLibs.md](../StdLibs.md).
