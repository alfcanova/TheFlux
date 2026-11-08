# 📚 `NetStdLib` — Redes de Computadores, Sockets TCP/UDP, Requisições HTTP e URLs

> **Pilar Arquitetural**: Pilar 4 (Sistema, I/O & Rede)  
> **Status**: ✅ Homologado com 100% de Paridade nos 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Arquivo Mestre**: `stdlib/NetStdLib/NetStdLib.fdsl`  
> **Modo de Importação**: `use NetStdLib` ou `use NetStdLib::<Modulo>::<operacao>`

---

## 1. Visão Geral e Funcionalidades

A biblioteca padrão **`NetStdLib`** integra o ecossistema oficial da linguagem TheFlux, fornecendo suporte de nível de sistema e algoritmos nativos certificados.

Comunicação em rede para sistemas distribuídos: cliente HTTP/HTTPS com suporte a métodos GET, POST, PUT e DELETE, resolução e validação de endereços IPv4/IPv6, manipulação semântica de URLs e sockets de rede TCP/UDP.

### 1.1 Características e Princípios de Design
- **Compilação e Fusão Estática**: Todos os módulos de domínio são fundidos no agente unificado `NetStdLib` em tempo de compilação, sem sobrecarga (*overhead*) de despacho indireto.
- **Isolamento e Segurança**: As operações verificam limites operacionais e utilizam despacho por contratos formais rigorosos.
- **Compatibilidade Multi-Backend**: Execução bit-a-bit idêntica em interpretador (`in`), bytecode (`vm`, `vmr`), nativo AOT (`llvm`) e WebAssembly (`wat`, `wasm`).

---

## 2. Estrutura Modular e Contratos

A biblioteca é composta por **4 módulos de domínio** e declara **54 operações públicas**:

| Arquivo de Domínio | Contrato Formal | Responsabilidade Principal | Qtd. Ops |
|---|---|---|:---:|
| `NetHttp.fdsl` | `NetHttpContract` | Domínio especializado de `NetHttp` | 12 |
| `NetIp.fdsl` | `NetIpContract` | Domínio especializado de `NetIp` | 14 |
| `NetSocket.fdsl` | `NetSocketContract` | Domínio especializado de `NetSocket` | 8 |
| `NetUrl.fdsl` | `NetUrlContract` | Domínio especializado de `NetUrl` | 20 |

---

## 3. Tipos, Estruturas e Enumerações Públicas

A biblioteca `NetStdLib` opera diretamente com os tipos nativos e primitivos da linguagem TheFlux (`string`, `int64`, `float64`, `bool`, `list of data`, etc.), sem exigir tipos compostos adicionais.

---

## 4. Catálogo Detalhado de Operações por Domínio

### 4.1 Contrato `NetHttpContract` (`NetHttp.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `netHttpGet` | `op netHttpGet (as string: url) as string` | `string` |
| `netHttpGetStatus` | `op netHttpGetStatus (as string: url) as int64` | `int64` |
| `netHttpPost` | `op netHttpPost (as string: url, as string: body, as string: content_type) as string` | `string` |
| `netHttpPut` | `op netHttpPut (as string: url, as string: body, as string: content_type) as string` | `string` |
| `netHttpDelete` | `op netHttpDelete (as string: url) as int64` | `int64` |
| `netHttpStatusText` | `op netHttpStatusText (as int64: status_code) as string` | `string` |
| `httpGet` | `op httpGet (as string: url) as string` | `string` |
| `httpGetStatus` | `op httpGetStatus (as string: url) as int64` | `int64` |
| `httpPost` | `op httpPost (as string: url, as string: body, as string: content_type) as string` | `string` |
| `httpPut` | `op httpPut (as string: url, as string: body, as string: content_type) as string` | `string` |
| `httpDelete` | `op httpDelete (as string: url) as int64` | `int64` |
| `httpStatusText` | `op httpStatusText (as int64: status_code) as string` | `string` |

#### Ficha Técnica das Operações:

##### `op netHttpGet`
```flux
op netHttpGet (as string: url) as string
```
- **Parâmetros**:
  - `url` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `netHttpGet` no domínio `NetHttpContract`.

##### `op netHttpGetStatus`
```flux
op netHttpGetStatus (as string: url) as int64
```
- **Parâmetros**:
  - `url` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `netHttpGetStatus` no domínio `NetHttpContract`.

##### `op netHttpPost`
```flux
op netHttpPost (as string: url, as string: body, as string: content_type) as string
```
- **Parâmetros**:
  - `url` (`string`): Parâmetro de entrada para processamento da operação.
  - `body` (`string`): Parâmetro de entrada para processamento da operação.
  - `content_type` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `netHttpPost` no domínio `NetHttpContract`.

##### `op netHttpPut`
```flux
op netHttpPut (as string: url, as string: body, as string: content_type) as string
```
- **Parâmetros**:
  - `url` (`string`): Parâmetro de entrada para processamento da operação.
  - `body` (`string`): Parâmetro de entrada para processamento da operação.
  - `content_type` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `netHttpPut` no domínio `NetHttpContract`.

##### `op netHttpDelete`
```flux
op netHttpDelete (as string: url) as int64
```
- **Parâmetros**:
  - `url` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `netHttpDelete` no domínio `NetHttpContract`.

##### `op netHttpStatusText`
```flux
op netHttpStatusText (as int64: status_code) as string
```
- **Parâmetros**:
  - `status_code` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `netHttpStatusText` no domínio `NetHttpContract`.

##### `op httpGet`
```flux
op httpGet (as string: url) as string
```
- **Parâmetros**:
  - `url` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `httpGet` no domínio `NetHttpContract`.

##### `op httpGetStatus`
```flux
op httpGetStatus (as string: url) as int64
```
- **Parâmetros**:
  - `url` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `httpGetStatus` no domínio `NetHttpContract`.

##### `op httpPost`
```flux
op httpPost (as string: url, as string: body, as string: content_type) as string
```
- **Parâmetros**:
  - `url` (`string`): Parâmetro de entrada para processamento da operação.
  - `body` (`string`): Parâmetro de entrada para processamento da operação.
  - `content_type` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `httpPost` no domínio `NetHttpContract`.

##### `op httpPut`
```flux
op httpPut (as string: url, as string: body, as string: content_type) as string
```
- **Parâmetros**:
  - `url` (`string`): Parâmetro de entrada para processamento da operação.
  - `body` (`string`): Parâmetro de entrada para processamento da operação.
  - `content_type` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `httpPut` no domínio `NetHttpContract`.

##### `op httpDelete`
```flux
op httpDelete (as string: url) as int64
```
- **Parâmetros**:
  - `url` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `httpDelete` no domínio `NetHttpContract`.

##### `op httpStatusText`
```flux
op httpStatusText (as int64: status_code) as string
```
- **Parâmetros**:
  - `status_code` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `httpStatusText` no domínio `NetHttpContract`.

### 4.2 Contrato `NetIpContract` (`NetIp.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `netIpIsValid` | `op netIpIsValid (as string: ip) as bool` | `bool` |
| `netIpIsV4` | `op netIpIsV4 (as string: ip) as bool` | `bool` |
| `netIpIsV6` | `op netIpIsV6 (as string: ip) as bool` | `bool` |
| `netIpIsLoopback` | `op netIpIsLoopback (as string: ip) as bool` | `bool` |
| `netIpIsPrivate` | `op netIpIsPrivate (as string: ip) as bool` | `bool` |
| `netResolveHost` | `op netResolveHost (as string: host) as string` | `string` |
| `netResolveIp` | `op netResolveIp (as string: ip) as string` | `string` |
| `ipIsValid` | `op ipIsValid (as string: ip) as bool` | `bool` |
| `ipIsV4` | `op ipIsV4 (as string: ip) as bool` | `bool` |
| `ipIsV6` | `op ipIsV6 (as string: ip) as bool` | `bool` |
| `ipIsLoopback` | `op ipIsLoopback (as string: ip) as bool` | `bool` |
| `ipIsPrivate` | `op ipIsPrivate (as string: ip) as bool` | `bool` |
| `resolveHost` | `op resolveHost (as string: host) as string` | `string` |
| `resolveIp` | `op resolveIp (as string: ip) as string` | `string` |

#### Ficha Técnica das Operações:

##### `op netIpIsValid`
```flux
op netIpIsValid (as string: ip) as bool
```
- **Parâmetros**:
  - `ip` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `netIpIsValid` no domínio `NetIpContract`.

##### `op netIpIsV4`
```flux
op netIpIsV4 (as string: ip) as bool
```
- **Parâmetros**:
  - `ip` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `netIpIsV4` no domínio `NetIpContract`.

##### `op netIpIsV6`
```flux
op netIpIsV6 (as string: ip) as bool
```
- **Parâmetros**:
  - `ip` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `netIpIsV6` no domínio `NetIpContract`.

##### `op netIpIsLoopback`
```flux
op netIpIsLoopback (as string: ip) as bool
```
- **Parâmetros**:
  - `ip` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `netIpIsLoopback` no domínio `NetIpContract`.

##### `op netIpIsPrivate`
```flux
op netIpIsPrivate (as string: ip) as bool
```
- **Parâmetros**:
  - `ip` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `netIpIsPrivate` no domínio `NetIpContract`.

##### `op netResolveHost`
```flux
op netResolveHost (as string: host) as string
```
- **Parâmetros**:
  - `host` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `netResolveHost` no domínio `NetIpContract`.

##### `op netResolveIp`
```flux
op netResolveIp (as string: ip) as string
```
- **Parâmetros**:
  - `ip` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `netResolveIp` no domínio `NetIpContract`.

##### `op ipIsValid`
```flux
op ipIsValid (as string: ip) as bool
```
- **Parâmetros**:
  - `ip` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `ipIsValid` no domínio `NetIpContract`.

##### `op ipIsV4`
```flux
op ipIsV4 (as string: ip) as bool
```
- **Parâmetros**:
  - `ip` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `ipIsV4` no domínio `NetIpContract`.

##### `op ipIsV6`
```flux
op ipIsV6 (as string: ip) as bool
```
- **Parâmetros**:
  - `ip` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `ipIsV6` no domínio `NetIpContract`.

##### `op ipIsLoopback`
```flux
op ipIsLoopback (as string: ip) as bool
```
- **Parâmetros**:
  - `ip` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `ipIsLoopback` no domínio `NetIpContract`.

##### `op ipIsPrivate`
```flux
op ipIsPrivate (as string: ip) as bool
```
- **Parâmetros**:
  - `ip` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `ipIsPrivate` no domínio `NetIpContract`.

##### `op resolveHost`
```flux
op resolveHost (as string: host) as string
```
- **Parâmetros**:
  - `host` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `resolveHost` no domínio `NetIpContract`.

##### `op resolveIp`
```flux
op resolveIp (as string: ip) as string
```
- **Parâmetros**:
  - `ip` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `resolveIp` no domínio `NetIpContract`.

### 4.3 Contrato `NetSocketContract` (`NetSocket.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `netTcpPing` | `op netTcpPing (as string: host, as int64: port, as int64: timeout_ms) as bool` | `bool` |
| `netLocalIp` | `op netLocalIp () as string` | `string` |
| `netPortIsAvailable` | `op netPortIsAvailable (as int64: port) as bool` | `bool` |
| `netPing` | `op netPing (as string: host) as bool` | `bool` |
| `tcpPing` | `op tcpPing (as string: host, as int64: port, as int64: timeout_ms) as bool` | `bool` |
| `localIp` | `op localIp () as string` | `string` |
| `portIsAvailable` | `op portIsAvailable (as int64: port) as bool` | `bool` |
| `ping` | `op ping (as string: host) as bool` | `bool` |

#### Ficha Técnica das Operações:

##### `op netTcpPing`
```flux
op netTcpPing (as string: host, as int64: port, as int64: timeout_ms) as bool
```
- **Parâmetros**:
  - `host` (`string`): Parâmetro de entrada para processamento da operação.
  - `port` (`int64`): Parâmetro de entrada para processamento da operação.
  - `timeout_ms` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `netTcpPing` no domínio `NetSocketContract`.

##### `op netLocalIp`
```flux
op netLocalIp () as string
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `netLocalIp` no domínio `NetSocketContract`.

##### `op netPortIsAvailable`
```flux
op netPortIsAvailable (as int64: port) as bool
```
- **Parâmetros**:
  - `port` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `netPortIsAvailable` no domínio `NetSocketContract`.

##### `op netPing`
```flux
op netPing (as string: host) as bool
```
- **Parâmetros**:
  - `host` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `netPing` no domínio `NetSocketContract`.

##### `op tcpPing`
```flux
op tcpPing (as string: host, as int64: port, as int64: timeout_ms) as bool
```
- **Parâmetros**:
  - `host` (`string`): Parâmetro de entrada para processamento da operação.
  - `port` (`int64`): Parâmetro de entrada para processamento da operação.
  - `timeout_ms` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `tcpPing` no domínio `NetSocketContract`.

##### `op localIp`
```flux
op localIp () as string
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `localIp` no domínio `NetSocketContract`.

##### `op portIsAvailable`
```flux
op portIsAvailable (as int64: port) as bool
```
- **Parâmetros**:
  - `port` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `portIsAvailable` no domínio `NetSocketContract`.

##### `op ping`
```flux
op ping (as string: host) as bool
```
- **Parâmetros**:
  - `host` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `ping` no domínio `NetSocketContract`.

### 4.4 Contrato `NetUrlContract` (`NetUrl.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `netUrlGetScheme` | `op netUrlGetScheme (as string: url) as string` | `string` |
| `netUrlGetHost` | `op netUrlGetHost (as string: url) as string` | `string` |
| `netUrlGetPort` | `op netUrlGetPort (as string: url) as int64` | `int64` |
| `netUrlGetPath` | `op netUrlGetPath (as string: url) as string` | `string` |
| `netUrlGetQuery` | `op netUrlGetQuery (as string: url) as string` | `string` |
| `netUrlGetFragment` | `op netUrlGetFragment (as string: url) as string` | `string` |
| `netUrlEncode` | `op netUrlEncode (as string: text) as string` | `string` |
| `netUrlDecode` | `op netUrlDecode (as string: text) as string` | `string` |
| `netUrlIsValid` | `op netUrlIsValid (as string: url) as bool` | `bool` |
| `netUrlJoin` | `op netUrlJoin (as string: base_url, as string: relative_path) as string` | `string` |
| `urlGetScheme` | `op urlGetScheme (as string: url) as string` | `string` |
| `urlGetHost` | `op urlGetHost (as string: url) as string` | `string` |
| `urlGetPort` | `op urlGetPort (as string: url) as int64` | `int64` |
| `urlGetPath` | `op urlGetPath (as string: url) as string` | `string` |
| `urlGetQuery` | `op urlGetQuery (as string: url) as string` | `string` |
| `urlGetFragment` | `op urlGetFragment (as string: url) as string` | `string` |
| `urlEncode` | `op urlEncode (as string: text) as string` | `string` |
| `urlDecode` | `op urlDecode (as string: text) as string` | `string` |
| `urlIsValid` | `op urlIsValid (as string: url) as bool` | `bool` |
| `urlJoin` | `op urlJoin (as string: base_url, as string: relative_path) as string` | `string` |

#### Ficha Técnica das Operações:

##### `op netUrlGetScheme`
```flux
op netUrlGetScheme (as string: url) as string
```
- **Parâmetros**:
  - `url` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `netUrlGetScheme` no domínio `NetUrlContract`.

##### `op netUrlGetHost`
```flux
op netUrlGetHost (as string: url) as string
```
- **Parâmetros**:
  - `url` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `netUrlGetHost` no domínio `NetUrlContract`.

##### `op netUrlGetPort`
```flux
op netUrlGetPort (as string: url) as int64
```
- **Parâmetros**:
  - `url` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `netUrlGetPort` no domínio `NetUrlContract`.

##### `op netUrlGetPath`
```flux
op netUrlGetPath (as string: url) as string
```
- **Parâmetros**:
  - `url` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `netUrlGetPath` no domínio `NetUrlContract`.

##### `op netUrlGetQuery`
```flux
op netUrlGetQuery (as string: url) as string
```
- **Parâmetros**:
  - `url` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `netUrlGetQuery` no domínio `NetUrlContract`.

##### `op netUrlGetFragment`
```flux
op netUrlGetFragment (as string: url) as string
```
- **Parâmetros**:
  - `url` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `netUrlGetFragment` no domínio `NetUrlContract`.

##### `op netUrlEncode`
```flux
op netUrlEncode (as string: text) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `netUrlEncode` no domínio `NetUrlContract`.

##### `op netUrlDecode`
```flux
op netUrlDecode (as string: text) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `netUrlDecode` no domínio `NetUrlContract`.

##### `op netUrlIsValid`
```flux
op netUrlIsValid (as string: url) as bool
```
- **Parâmetros**:
  - `url` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `netUrlIsValid` no domínio `NetUrlContract`.

##### `op netUrlJoin`
```flux
op netUrlJoin (as string: base_url, as string: relative_path) as string
```
- **Parâmetros**:
  - `base_url` (`string`): Parâmetro de entrada para processamento da operação.
  - `relative_path` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `netUrlJoin` no domínio `NetUrlContract`.

##### `op urlGetScheme`
```flux
op urlGetScheme (as string: url) as string
```
- **Parâmetros**:
  - `url` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `urlGetScheme` no domínio `NetUrlContract`.

##### `op urlGetHost`
```flux
op urlGetHost (as string: url) as string
```
- **Parâmetros**:
  - `url` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `urlGetHost` no domínio `NetUrlContract`.

##### `op urlGetPort`
```flux
op urlGetPort (as string: url) as int64
```
- **Parâmetros**:
  - `url` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `urlGetPort` no domínio `NetUrlContract`.

##### `op urlGetPath`
```flux
op urlGetPath (as string: url) as string
```
- **Parâmetros**:
  - `url` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `urlGetPath` no domínio `NetUrlContract`.

##### `op urlGetQuery`
```flux
op urlGetQuery (as string: url) as string
```
- **Parâmetros**:
  - `url` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `urlGetQuery` no domínio `NetUrlContract`.

##### `op urlGetFragment`
```flux
op urlGetFragment (as string: url) as string
```
- **Parâmetros**:
  - `url` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `urlGetFragment` no domínio `NetUrlContract`.

##### `op urlEncode`
```flux
op urlEncode (as string: text) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `urlEncode` no domínio `NetUrlContract`.

##### `op urlDecode`
```flux
op urlDecode (as string: text) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `urlDecode` no domínio `NetUrlContract`.

##### `op urlIsValid`
```flux
op urlIsValid (as string: url) as bool
```
- **Parâmetros**:
  - `url` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `urlIsValid` no domínio `NetUrlContract`.

##### `op urlJoin`
```flux
op urlJoin (as string: base_url, as string: relative_path) as string
```
- **Parâmetros**:
  - `base_url` (`string`): Parâmetro de entrada para processamento da operação.
  - `relative_path` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `urlJoin` no domínio `NetUrlContract`.

---

## 5. Exemplos Canônicos de Uso em TheFlux

O exemplo a seguir demonstra a importação e o consumo prático da biblioteca:

```flux
# Exemplo Canônico de Consumo da NetStdLib
use NetStdLib

program (ExemploNetStdLib) {
      println("==================================================")
      println("  Demonstracao da Standard Library: NetStdLib")
      println("==================================================")

      # Chamada da operacao canônica
      mut as data: resultado = NetStdLib::netHttpGet("https://httpbin.org/get")
      println("Resultado obtido: " + resultado)

      println("Demonstracao concluida com sucesso.")
}
```

---

> [!TIP]
> Para consultar a visão arquitetural unificada de todas as bibliotecas, consulte o documento principal [StdLibs.md](../StdLibs.md).
