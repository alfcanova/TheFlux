# 📚 `NetStdLib` — Network Programming, TCP/UDP Sockets, HTTP Client, and URLs

> **Architectural Pillar**: Pillar 4 (System, I/O & Network)  
> **Status**: ✅ Certified with 100% Parity across 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Master File**: `stdlib/NetStdLib/NetStdLib.fdsl`  
> **Import Mode**: `use NetStdLib` or `use NetStdLib::<Module>::<operation>`

---

## 1. Overview and Capabilities

The **`NetStdLib`** standard library is an integral component of the official TheFlux language ecosystem, providing certified system-level algorithms and robust capabilities.

Network communications for distributed applications: HTTP/HTTPS client for RESTful verbs (GET, POST, PUT, DELETE), IPv4/IPv6 address parsing and validation, RFC 3986 URL manipulation, and low-level TCP/UDP socket connections.

### 1.1 Key Architectural Principles and Design
- **Static Fusion and Zero-Overhead**: All domain modules are transparently fused into the `NetStdLib` unified agent at compile time, avoiding virtual dispatch penalties.
- **Safety and Isolation**: Operations strictly validate parameter bounds and guarantee predictable error semantics via contract definitions.
- **Universal Multi-Backend Parity**: Bit-for-bit identical execution guarantees across interpreter (`in`), bytecode VM (`vm`, `vmr`), native AOT LLVM (`llvm`), and WebAssembly (`wat`, `wasm`).

---

## 2. Modular Structure and Contracts

The library comprises **4 domain modules** declaring a total of **54 public operations**:

| Domain Source File | Formal Contract | Domain Responsibility | Ops Count |
|---|---|---|:---:|
| `NetHttp.fdsl` | `NetHttpContract` | Specialized domain for `NetHttp` | 12 |
| `NetIp.fdsl` | `NetIpContract` | Specialized domain for `NetIp` | 14 |
| `NetSocket.fdsl` | `NetSocketContract` | Specialized domain for `NetSocket` | 8 |
| `NetUrl.fdsl` | `NetUrlContract` | Specialized domain for `NetUrl` | 20 |

---

## 3. Public Types, Structures, and Enumerations

The `NetStdLib` library operates directly on primitive native TheFlux types (`string`, `int64`, `float64`, `bool`, `list of data`, etc.) without requiring custom composite types.

---

## 4. Detailed Operations Catalog by Domain

### 4.1 Contract `NetHttpContract` (`NetHttp.fdsl`)

| Operation | Formal Signature | Return Type |
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

#### Operation Technical Specifications:

##### `op netHttpGet`
```flux
op netHttpGet (as string: url) as string
```
- **Parameters**:
  - `url` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `netHttpGet` functionality within the `NetHttpContract` domain.

##### `op netHttpGetStatus`
```flux
op netHttpGetStatus (as string: url) as int64
```
- **Parameters**:
  - `url` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `netHttpGetStatus` functionality within the `NetHttpContract` domain.

##### `op netHttpPost`
```flux
op netHttpPost (as string: url, as string: body, as string: content_type) as string
```
- **Parameters**:
  - `url` (`string`): Input argument for operation execution.
  - `body` (`string`): Input argument for operation execution.
  - `content_type` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `netHttpPost` functionality within the `NetHttpContract` domain.

##### `op netHttpPut`
```flux
op netHttpPut (as string: url, as string: body, as string: content_type) as string
```
- **Parameters**:
  - `url` (`string`): Input argument for operation execution.
  - `body` (`string`): Input argument for operation execution.
  - `content_type` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `netHttpPut` functionality within the `NetHttpContract` domain.

##### `op netHttpDelete`
```flux
op netHttpDelete (as string: url) as int64
```
- **Parameters**:
  - `url` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `netHttpDelete` functionality within the `NetHttpContract` domain.

##### `op netHttpStatusText`
```flux
op netHttpStatusText (as int64: status_code) as string
```
- **Parameters**:
  - `status_code` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `netHttpStatusText` functionality within the `NetHttpContract` domain.

##### `op httpGet`
```flux
op httpGet (as string: url) as string
```
- **Parameters**:
  - `url` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `httpGet` functionality within the `NetHttpContract` domain.

##### `op httpGetStatus`
```flux
op httpGetStatus (as string: url) as int64
```
- **Parameters**:
  - `url` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `httpGetStatus` functionality within the `NetHttpContract` domain.

##### `op httpPost`
```flux
op httpPost (as string: url, as string: body, as string: content_type) as string
```
- **Parameters**:
  - `url` (`string`): Input argument for operation execution.
  - `body` (`string`): Input argument for operation execution.
  - `content_type` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `httpPost` functionality within the `NetHttpContract` domain.

##### `op httpPut`
```flux
op httpPut (as string: url, as string: body, as string: content_type) as string
```
- **Parameters**:
  - `url` (`string`): Input argument for operation execution.
  - `body` (`string`): Input argument for operation execution.
  - `content_type` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `httpPut` functionality within the `NetHttpContract` domain.

##### `op httpDelete`
```flux
op httpDelete (as string: url) as int64
```
- **Parameters**:
  - `url` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `httpDelete` functionality within the `NetHttpContract` domain.

##### `op httpStatusText`
```flux
op httpStatusText (as int64: status_code) as string
```
- **Parameters**:
  - `status_code` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `httpStatusText` functionality within the `NetHttpContract` domain.

### 4.2 Contract `NetIpContract` (`NetIp.fdsl`)

| Operation | Formal Signature | Return Type |
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

#### Operation Technical Specifications:

##### `op netIpIsValid`
```flux
op netIpIsValid (as string: ip) as bool
```
- **Parameters**:
  - `ip` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `netIpIsValid` functionality within the `NetIpContract` domain.

##### `op netIpIsV4`
```flux
op netIpIsV4 (as string: ip) as bool
```
- **Parameters**:
  - `ip` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `netIpIsV4` functionality within the `NetIpContract` domain.

##### `op netIpIsV6`
```flux
op netIpIsV6 (as string: ip) as bool
```
- **Parameters**:
  - `ip` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `netIpIsV6` functionality within the `NetIpContract` domain.

##### `op netIpIsLoopback`
```flux
op netIpIsLoopback (as string: ip) as bool
```
- **Parameters**:
  - `ip` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `netIpIsLoopback` functionality within the `NetIpContract` domain.

##### `op netIpIsPrivate`
```flux
op netIpIsPrivate (as string: ip) as bool
```
- **Parameters**:
  - `ip` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `netIpIsPrivate` functionality within the `NetIpContract` domain.

##### `op netResolveHost`
```flux
op netResolveHost (as string: host) as string
```
- **Parameters**:
  - `host` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `netResolveHost` functionality within the `NetIpContract` domain.

##### `op netResolveIp`
```flux
op netResolveIp (as string: ip) as string
```
- **Parameters**:
  - `ip` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `netResolveIp` functionality within the `NetIpContract` domain.

##### `op ipIsValid`
```flux
op ipIsValid (as string: ip) as bool
```
- **Parameters**:
  - `ip` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `ipIsValid` functionality within the `NetIpContract` domain.

##### `op ipIsV4`
```flux
op ipIsV4 (as string: ip) as bool
```
- **Parameters**:
  - `ip` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `ipIsV4` functionality within the `NetIpContract` domain.

##### `op ipIsV6`
```flux
op ipIsV6 (as string: ip) as bool
```
- **Parameters**:
  - `ip` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `ipIsV6` functionality within the `NetIpContract` domain.

##### `op ipIsLoopback`
```flux
op ipIsLoopback (as string: ip) as bool
```
- **Parameters**:
  - `ip` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `ipIsLoopback` functionality within the `NetIpContract` domain.

##### `op ipIsPrivate`
```flux
op ipIsPrivate (as string: ip) as bool
```
- **Parameters**:
  - `ip` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `ipIsPrivate` functionality within the `NetIpContract` domain.

##### `op resolveHost`
```flux
op resolveHost (as string: host) as string
```
- **Parameters**:
  - `host` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `resolveHost` functionality within the `NetIpContract` domain.

##### `op resolveIp`
```flux
op resolveIp (as string: ip) as string
```
- **Parameters**:
  - `ip` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `resolveIp` functionality within the `NetIpContract` domain.

### 4.3 Contract `NetSocketContract` (`NetSocket.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `netTcpPing` | `op netTcpPing (as string: host, as int64: port, as int64: timeout_ms) as bool` | `bool` |
| `netLocalIp` | `op netLocalIp () as string` | `string` |
| `netPortIsAvailable` | `op netPortIsAvailable (as int64: port) as bool` | `bool` |
| `netPing` | `op netPing (as string: host) as bool` | `bool` |
| `tcpPing` | `op tcpPing (as string: host, as int64: port, as int64: timeout_ms) as bool` | `bool` |
| `localIp` | `op localIp () as string` | `string` |
| `portIsAvailable` | `op portIsAvailable (as int64: port) as bool` | `bool` |
| `ping` | `op ping (as string: host) as bool` | `bool` |

#### Operation Technical Specifications:

##### `op netTcpPing`
```flux
op netTcpPing (as string: host, as int64: port, as int64: timeout_ms) as bool
```
- **Parameters**:
  - `host` (`string`): Input argument for operation execution.
  - `port` (`int64`): Input argument for operation execution.
  - `timeout_ms` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `netTcpPing` functionality within the `NetSocketContract` domain.

##### `op netLocalIp`
```flux
op netLocalIp () as string
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `netLocalIp` functionality within the `NetSocketContract` domain.

##### `op netPortIsAvailable`
```flux
op netPortIsAvailable (as int64: port) as bool
```
- **Parameters**:
  - `port` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `netPortIsAvailable` functionality within the `NetSocketContract` domain.

##### `op netPing`
```flux
op netPing (as string: host) as bool
```
- **Parameters**:
  - `host` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `netPing` functionality within the `NetSocketContract` domain.

##### `op tcpPing`
```flux
op tcpPing (as string: host, as int64: port, as int64: timeout_ms) as bool
```
- **Parameters**:
  - `host` (`string`): Input argument for operation execution.
  - `port` (`int64`): Input argument for operation execution.
  - `timeout_ms` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `tcpPing` functionality within the `NetSocketContract` domain.

##### `op localIp`
```flux
op localIp () as string
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `localIp` functionality within the `NetSocketContract` domain.

##### `op portIsAvailable`
```flux
op portIsAvailable (as int64: port) as bool
```
- **Parameters**:
  - `port` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `portIsAvailable` functionality within the `NetSocketContract` domain.

##### `op ping`
```flux
op ping (as string: host) as bool
```
- **Parameters**:
  - `host` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `ping` functionality within the `NetSocketContract` domain.

### 4.4 Contract `NetUrlContract` (`NetUrl.fdsl`)

| Operation | Formal Signature | Return Type |
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

#### Operation Technical Specifications:

##### `op netUrlGetScheme`
```flux
op netUrlGetScheme (as string: url) as string
```
- **Parameters**:
  - `url` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `netUrlGetScheme` functionality within the `NetUrlContract` domain.

##### `op netUrlGetHost`
```flux
op netUrlGetHost (as string: url) as string
```
- **Parameters**:
  - `url` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `netUrlGetHost` functionality within the `NetUrlContract` domain.

##### `op netUrlGetPort`
```flux
op netUrlGetPort (as string: url) as int64
```
- **Parameters**:
  - `url` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `netUrlGetPort` functionality within the `NetUrlContract` domain.

##### `op netUrlGetPath`
```flux
op netUrlGetPath (as string: url) as string
```
- **Parameters**:
  - `url` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `netUrlGetPath` functionality within the `NetUrlContract` domain.

##### `op netUrlGetQuery`
```flux
op netUrlGetQuery (as string: url) as string
```
- **Parameters**:
  - `url` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `netUrlGetQuery` functionality within the `NetUrlContract` domain.

##### `op netUrlGetFragment`
```flux
op netUrlGetFragment (as string: url) as string
```
- **Parameters**:
  - `url` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `netUrlGetFragment` functionality within the `NetUrlContract` domain.

##### `op netUrlEncode`
```flux
op netUrlEncode (as string: text) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `netUrlEncode` functionality within the `NetUrlContract` domain.

##### `op netUrlDecode`
```flux
op netUrlDecode (as string: text) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `netUrlDecode` functionality within the `NetUrlContract` domain.

##### `op netUrlIsValid`
```flux
op netUrlIsValid (as string: url) as bool
```
- **Parameters**:
  - `url` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `netUrlIsValid` functionality within the `NetUrlContract` domain.

##### `op netUrlJoin`
```flux
op netUrlJoin (as string: base_url, as string: relative_path) as string
```
- **Parameters**:
  - `base_url` (`string`): Input argument for operation execution.
  - `relative_path` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `netUrlJoin` functionality within the `NetUrlContract` domain.

##### `op urlGetScheme`
```flux
op urlGetScheme (as string: url) as string
```
- **Parameters**:
  - `url` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `urlGetScheme` functionality within the `NetUrlContract` domain.

##### `op urlGetHost`
```flux
op urlGetHost (as string: url) as string
```
- **Parameters**:
  - `url` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `urlGetHost` functionality within the `NetUrlContract` domain.

##### `op urlGetPort`
```flux
op urlGetPort (as string: url) as int64
```
- **Parameters**:
  - `url` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `urlGetPort` functionality within the `NetUrlContract` domain.

##### `op urlGetPath`
```flux
op urlGetPath (as string: url) as string
```
- **Parameters**:
  - `url` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `urlGetPath` functionality within the `NetUrlContract` domain.

##### `op urlGetQuery`
```flux
op urlGetQuery (as string: url) as string
```
- **Parameters**:
  - `url` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `urlGetQuery` functionality within the `NetUrlContract` domain.

##### `op urlGetFragment`
```flux
op urlGetFragment (as string: url) as string
```
- **Parameters**:
  - `url` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `urlGetFragment` functionality within the `NetUrlContract` domain.

##### `op urlEncode`
```flux
op urlEncode (as string: text) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `urlEncode` functionality within the `NetUrlContract` domain.

##### `op urlDecode`
```flux
op urlDecode (as string: text) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `urlDecode` functionality within the `NetUrlContract` domain.

##### `op urlIsValid`
```flux
op urlIsValid (as string: url) as bool
```
- **Parameters**:
  - `url` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `urlIsValid` functionality within the `NetUrlContract` domain.

##### `op urlJoin`
```flux
op urlJoin (as string: base_url, as string: relative_path) as string
```
- **Parameters**:
  - `base_url` (`string`): Input argument for operation execution.
  - `relative_path` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `urlJoin` functionality within the `NetUrlContract` domain.

---

## 5. Canonical Usage Examples in TheFlux

The following snippet illustrates importing and utilizing the library in a TheFlux program:

```flux
# Canonical Usage Example for NetStdLib
use NetStdLib

program (ExampleOfNetStdLib) {
      println("==================================================")
      println("  Standard Library Demonstration: NetStdLib")
      println("==================================================")

      # Invoking canonical operation
      mut as data: result = NetStdLib::netHttpGet("https://httpbin.org/get")
      println("Obtained result: " + result)

      println("Execution completed successfully.")
}
```

---

> [!TIP]
> For the complete unified architecture across all standard libraries, consult the master [StdLibs.md](../StdLibs.md) reference.
