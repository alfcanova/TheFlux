# 📚 `NativeGfxStdLib` — Aceleração Gráfica Nativa de Baixo Nível e Gerenciamento de Janelas

> **Pilar Arquitetural**: Pilar 4 (Sistema, I/O & Rede)  
> **Status**: ✅ Homologado com 100% de Paridade nos 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Arquivo Mestre**: `stdlib/NativeGfxStdLib/NativeGfxStdLib.fdsl`  
> **Modo de Importação**: `use NativeGfxStdLib` ou `use NativeGfxStdLib::<Modulo>::<operacao>`

---

## 1. Visão Geral e Funcionalidades

A biblioteca padrão **`NativeGfxStdLib`** integra o ecossistema oficial da linguagem TheFlux, fornecendo suporte de nível de sistema e algoritmos nativos certificados.

Interface direta com o subsistema de apresentação e renderização do sistema operacional: criação e ciclo de vida de janelas nativas, polling de eventos de entrada (teclado e mouse) e desenho rasterizado imediato.

### 1.1 Características e Princípios de Design
- **Compilação e Fusão Estática**: Todos os módulos de domínio são fundidos no agente unificado `NativeGfxStdLib` em tempo de compilação, sem sobrecarga (*overhead*) de despacho indireto.
- **Isolamento e Segurança**: As operações verificam limites operacionais e utilizam despacho por contratos formais rigorosos.
- **Compatibilidade Multi-Backend**: Execução bit-a-bit idêntica em interpretador (`in`), bytecode (`vm`, `vmr`), nativo AOT (`llvm`) e WebAssembly (`wat`, `wasm`).

---

## 2. Estrutura Modular e Contratos

A biblioteca é composta por **3 módulos de domínio** e declara **32 operações públicas**:

| Arquivo de Domínio | Contrato Formal | Responsabilidade Principal | Qtd. Ops |
|---|---|---|:---:|
| `NativeGfxDraw.fdsl` | `NativeGfxDrawContract` | Domínio especializado de `NativeGfxDraw` | 10 |
| `NativeGfxEvent.fdsl` | `NativeGfxEventContract` | Domínio especializado de `NativeGfxEvent` | 8 |
| `NativeGfxWindow.fdsl` | `NativeGfxWindowContract` | Domínio especializado de `NativeGfxWindow` | 14 |

---

## 3. Tipos, Estruturas e Enumerações Públicas

A biblioteca `NativeGfxStdLib` opera diretamente com os tipos nativos e primitivos da linguagem TheFlux (`string`, `int64`, `float64`, `bool`, `list of data`, etc.), sem exigir tipos compostos adicionais.

---

## 4. Catálogo Detalhado de Operações por Domínio

### 4.1 Contrato `NativeGfxDrawContract` (`NativeGfxDraw.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `nativeGfxClear` | `op nativeGfxClear (as int64: win_id, as int64: r, as int64: g, as int64: b) as bool` | `bool` |
| `nativeGfxFillRect` | `op nativeGfxFillRect (as int64: win_id, as int64: x, as int64: y, as int64: w, as int64: h, as int64: r, as int64: g, as int64: b) as bool` | `bool` |
| `nativeGfxDrawRect` | `op nativeGfxDrawRect (as int64: win_id, as int64: x, as int64: y, as int64: w, as int64: h, as int64: r, as int64: g, as int64: b) as bool` | `bool` |
| `nativeGfxDrawLine` | `op nativeGfxDrawLine (as int64: win_id, as int64: x1, as int64: y1, as int64: x2, as int64: y2, as int64: r, as int64: g, as int64: b) as bool` | `bool` |
| `nativeGfxDrawCircle` | `op nativeGfxDrawCircle (as int64: win_id, as int64: cx, as int64: cy, as int64: radius, as int64: r, as int64: g, as int64: b) as bool` | `bool` |
| `nativeGfxFillCircle` | `op nativeGfxFillCircle (as int64: win_id, as int64: cx, as int64: cy, as int64: radius, as int64: r, as int64: g, as int64: b) as bool` | `bool` |
| `nativeGfxDrawText` | `op nativeGfxDrawText (as int64: win_id, as int64: x, as int64: y, as string: text, as int64: r, as int64: g, as int64: b) as bool` | `bool` |
| `gfxClear` | `op gfxClear (as int64: win_id, as int64: r, as int64: g, as int64: b) as bool` | `bool` |
| `gfxFillRect` | `op gfxFillRect (as int64: win_id, as int64: x, as int64: y, as int64: w, as int64: h, as int64: r, as int64: g, as int64: b) as bool` | `bool` |
| `gfxFillCircle` | `op gfxFillCircle (as int64: win_id, as int64: cx, as int64: cy, as int64: radius, as int64: r, as int64: g, as int64: b) as bool` | `bool` |

#### Ficha Técnica das Operações:

##### `op nativeGfxClear`
```flux
op nativeGfxClear (as int64: win_id, as int64: r, as int64: g, as int64: b) as bool
```
- **Parâmetros**:
  - `win_id` (`int64`): Parâmetro de entrada para processamento da operação.
  - `r` (`int64`): Parâmetro de entrada para processamento da operação.
  - `g` (`int64`): Parâmetro de entrada para processamento da operação.
  - `b` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `nativeGfxClear` no domínio `NativeGfxDrawContract`.

##### `op nativeGfxFillRect`
```flux
op nativeGfxFillRect (as int64: win_id, as int64: x, as int64: y, as int64: w, as int64: h, as int64: r, as int64: g, as int64: b) as bool
```
- **Parâmetros**:
  - `win_id` (`int64`): Parâmetro de entrada para processamento da operação.
  - `x` (`int64`): Parâmetro de entrada para processamento da operação.
  - `y` (`int64`): Parâmetro de entrada para processamento da operação.
  - `w` (`int64`): Parâmetro de entrada para processamento da operação.
  - `h` (`int64`): Parâmetro de entrada para processamento da operação.
  - `r` (`int64`): Parâmetro de entrada para processamento da operação.
  - `g` (`int64`): Parâmetro de entrada para processamento da operação.
  - `b` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `nativeGfxFillRect` no domínio `NativeGfxDrawContract`.

##### `op nativeGfxDrawRect`
```flux
op nativeGfxDrawRect (as int64: win_id, as int64: x, as int64: y, as int64: w, as int64: h, as int64: r, as int64: g, as int64: b) as bool
```
- **Parâmetros**:
  - `win_id` (`int64`): Parâmetro de entrada para processamento da operação.
  - `x` (`int64`): Parâmetro de entrada para processamento da operação.
  - `y` (`int64`): Parâmetro de entrada para processamento da operação.
  - `w` (`int64`): Parâmetro de entrada para processamento da operação.
  - `h` (`int64`): Parâmetro de entrada para processamento da operação.
  - `r` (`int64`): Parâmetro de entrada para processamento da operação.
  - `g` (`int64`): Parâmetro de entrada para processamento da operação.
  - `b` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `nativeGfxDrawRect` no domínio `NativeGfxDrawContract`.

##### `op nativeGfxDrawLine`
```flux
op nativeGfxDrawLine (as int64: win_id, as int64: x1, as int64: y1, as int64: x2, as int64: y2, as int64: r, as int64: g, as int64: b) as bool
```
- **Parâmetros**:
  - `win_id` (`int64`): Parâmetro de entrada para processamento da operação.
  - `x1` (`int64`): Parâmetro de entrada para processamento da operação.
  - `y1` (`int64`): Parâmetro de entrada para processamento da operação.
  - `x2` (`int64`): Parâmetro de entrada para processamento da operação.
  - `y2` (`int64`): Parâmetro de entrada para processamento da operação.
  - `r` (`int64`): Parâmetro de entrada para processamento da operação.
  - `g` (`int64`): Parâmetro de entrada para processamento da operação.
  - `b` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `nativeGfxDrawLine` no domínio `NativeGfxDrawContract`.

##### `op nativeGfxDrawCircle`
```flux
op nativeGfxDrawCircle (as int64: win_id, as int64: cx, as int64: cy, as int64: radius, as int64: r, as int64: g, as int64: b) as bool
```
- **Parâmetros**:
  - `win_id` (`int64`): Parâmetro de entrada para processamento da operação.
  - `cx` (`int64`): Parâmetro de entrada para processamento da operação.
  - `cy` (`int64`): Parâmetro de entrada para processamento da operação.
  - `radius` (`int64`): Parâmetro de entrada para processamento da operação.
  - `r` (`int64`): Parâmetro de entrada para processamento da operação.
  - `g` (`int64`): Parâmetro de entrada para processamento da operação.
  - `b` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `nativeGfxDrawCircle` no domínio `NativeGfxDrawContract`.

##### `op nativeGfxFillCircle`
```flux
op nativeGfxFillCircle (as int64: win_id, as int64: cx, as int64: cy, as int64: radius, as int64: r, as int64: g, as int64: b) as bool
```
- **Parâmetros**:
  - `win_id` (`int64`): Parâmetro de entrada para processamento da operação.
  - `cx` (`int64`): Parâmetro de entrada para processamento da operação.
  - `cy` (`int64`): Parâmetro de entrada para processamento da operação.
  - `radius` (`int64`): Parâmetro de entrada para processamento da operação.
  - `r` (`int64`): Parâmetro de entrada para processamento da operação.
  - `g` (`int64`): Parâmetro de entrada para processamento da operação.
  - `b` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `nativeGfxFillCircle` no domínio `NativeGfxDrawContract`.

##### `op nativeGfxDrawText`
```flux
op nativeGfxDrawText (as int64: win_id, as int64: x, as int64: y, as string: text, as int64: r, as int64: g, as int64: b) as bool
```
- **Parâmetros**:
  - `win_id` (`int64`): Parâmetro de entrada para processamento da operação.
  - `x` (`int64`): Parâmetro de entrada para processamento da operação.
  - `y` (`int64`): Parâmetro de entrada para processamento da operação.
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
  - `r` (`int64`): Parâmetro de entrada para processamento da operação.
  - `g` (`int64`): Parâmetro de entrada para processamento da operação.
  - `b` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `nativeGfxDrawText` no domínio `NativeGfxDrawContract`.

##### `op gfxClear`
```flux
op gfxClear (as int64: win_id, as int64: r, as int64: g, as int64: b) as bool
```
- **Parâmetros**:
  - `win_id` (`int64`): Parâmetro de entrada para processamento da operação.
  - `r` (`int64`): Parâmetro de entrada para processamento da operação.
  - `g` (`int64`): Parâmetro de entrada para processamento da operação.
  - `b` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxClear` no domínio `NativeGfxDrawContract`.

##### `op gfxFillRect`
```flux
op gfxFillRect (as int64: win_id, as int64: x, as int64: y, as int64: w, as int64: h, as int64: r, as int64: g, as int64: b) as bool
```
- **Parâmetros**:
  - `win_id` (`int64`): Parâmetro de entrada para processamento da operação.
  - `x` (`int64`): Parâmetro de entrada para processamento da operação.
  - `y` (`int64`): Parâmetro de entrada para processamento da operação.
  - `w` (`int64`): Parâmetro de entrada para processamento da operação.
  - `h` (`int64`): Parâmetro de entrada para processamento da operação.
  - `r` (`int64`): Parâmetro de entrada para processamento da operação.
  - `g` (`int64`): Parâmetro de entrada para processamento da operação.
  - `b` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxFillRect` no domínio `NativeGfxDrawContract`.

##### `op gfxFillCircle`
```flux
op gfxFillCircle (as int64: win_id, as int64: cx, as int64: cy, as int64: radius, as int64: r, as int64: g, as int64: b) as bool
```
- **Parâmetros**:
  - `win_id` (`int64`): Parâmetro de entrada para processamento da operação.
  - `cx` (`int64`): Parâmetro de entrada para processamento da operação.
  - `cy` (`int64`): Parâmetro de entrada para processamento da operação.
  - `radius` (`int64`): Parâmetro de entrada para processamento da operação.
  - `r` (`int64`): Parâmetro de entrada para processamento da operação.
  - `g` (`int64`): Parâmetro de entrada para processamento da operação.
  - `b` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxFillCircle` no domínio `NativeGfxDrawContract`.

### 4.2 Contrato `NativeGfxEventContract` (`NativeGfxEvent.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `gfxEventPoll` | `op gfxEventPoll (as int64: win_id) as int64` | `int64` |
| `gfxEventX` | `op gfxEventX () as int64` | `int64` |
| `gfxEventY` | `op gfxEventY () as int64` | `int64` |
| `gfxEventKey` | `op gfxEventKey () as int64` | `int64` |
| `nativeGfxEventPoll` | `op nativeGfxEventPoll (as int64: win_id) as int64` | `int64` |
| `nativeGfxEventX` | `op nativeGfxEventX () as int64` | `int64` |
| `nativeGfxEventY` | `op nativeGfxEventY () as int64` | `int64` |
| `nativeGfxEventKey` | `op nativeGfxEventKey () as int64` | `int64` |

#### Ficha Técnica das Operações:

##### `op gfxEventPoll`
```flux
op gfxEventPoll (as int64: win_id) as int64
```
- **Parâmetros**:
  - `win_id` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxEventPoll` no domínio `NativeGfxEventContract`.

##### `op gfxEventX`
```flux
op gfxEventX () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxEventX` no domínio `NativeGfxEventContract`.

##### `op gfxEventY`
```flux
op gfxEventY () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxEventY` no domínio `NativeGfxEventContract`.

##### `op gfxEventKey`
```flux
op gfxEventKey () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxEventKey` no domínio `NativeGfxEventContract`.

##### `op nativeGfxEventPoll`
```flux
op nativeGfxEventPoll (as int64: win_id) as int64
```
- **Parâmetros**:
  - `win_id` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `nativeGfxEventPoll` no domínio `NativeGfxEventContract`.

##### `op nativeGfxEventX`
```flux
op nativeGfxEventX () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `nativeGfxEventX` no domínio `NativeGfxEventContract`.

##### `op nativeGfxEventY`
```flux
op nativeGfxEventY () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `nativeGfxEventY` no domínio `NativeGfxEventContract`.

##### `op nativeGfxEventKey`
```flux
op nativeGfxEventKey () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `nativeGfxEventKey` no domínio `NativeGfxEventContract`.

### 4.3 Contrato `NativeGfxWindowContract` (`NativeGfxWindow.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `gfxWindowCreate` | `op gfxWindowCreate (as int64: w, as int64: h, as string: title) as int64` | `int64` |
| `gfxWindowClose` | `op gfxWindowClose (as int64: win_id) as bool` | `bool` |
| `gfxWindowFlush` | `op gfxWindowFlush (as int64: win_id) as bool` | `bool` |
| `gfxWindowClosed` | `op gfxWindowClosed (as int64: win_id) as bool` | `bool` |
| `gfxWindowWidth` | `op gfxWindowWidth (as int64: win_id) as int64` | `int64` |
| `gfxWindowHeight` | `op gfxWindowHeight (as int64: win_id) as int64` | `int64` |
| `gfxWindowWait` | `op gfxWindowWait (as int64: win_id, as int64: ms) as bool` | `bool` |
| `nativeGfxWindowCreate` | `op nativeGfxWindowCreate (as int64: w, as int64: h, as string: title) as int64` | `int64` |
| `nativeGfxWindowClose` | `op nativeGfxWindowClose (as int64: win_id) as bool` | `bool` |
| `nativeGfxWindowFlush` | `op nativeGfxWindowFlush (as int64: win_id) as bool` | `bool` |
| `nativeGfxWindowClosed` | `op nativeGfxWindowClosed (as int64: win_id) as bool` | `bool` |
| `nativeGfxWindowWidth` | `op nativeGfxWindowWidth (as int64: win_id) as int64` | `int64` |
| `nativeGfxWindowHeight` | `op nativeGfxWindowHeight (as int64: win_id) as int64` | `int64` |
| `nativeGfxWindowWait` | `op nativeGfxWindowWait (as int64: win_id, as int64: ms) as bool` | `bool` |

#### Ficha Técnica das Operações:

##### `op gfxWindowCreate`
```flux
op gfxWindowCreate (as int64: w, as int64: h, as string: title) as int64
```
- **Parâmetros**:
  - `w` (`int64`): Parâmetro de entrada para processamento da operação.
  - `h` (`int64`): Parâmetro de entrada para processamento da operação.
  - `title` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxWindowCreate` no domínio `NativeGfxWindowContract`.

##### `op gfxWindowClose`
```flux
op gfxWindowClose (as int64: win_id) as bool
```
- **Parâmetros**:
  - `win_id` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxWindowClose` no domínio `NativeGfxWindowContract`.

##### `op gfxWindowFlush`
```flux
op gfxWindowFlush (as int64: win_id) as bool
```
- **Parâmetros**:
  - `win_id` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxWindowFlush` no domínio `NativeGfxWindowContract`.

##### `op gfxWindowClosed`
```flux
op gfxWindowClosed (as int64: win_id) as bool
```
- **Parâmetros**:
  - `win_id` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxWindowClosed` no domínio `NativeGfxWindowContract`.

##### `op gfxWindowWidth`
```flux
op gfxWindowWidth (as int64: win_id) as int64
```
- **Parâmetros**:
  - `win_id` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxWindowWidth` no domínio `NativeGfxWindowContract`.

##### `op gfxWindowHeight`
```flux
op gfxWindowHeight (as int64: win_id) as int64
```
- **Parâmetros**:
  - `win_id` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxWindowHeight` no domínio `NativeGfxWindowContract`.

##### `op gfxWindowWait`
```flux
op gfxWindowWait (as int64: win_id, as int64: ms) as bool
```
- **Parâmetros**:
  - `win_id` (`int64`): Parâmetro de entrada para processamento da operação.
  - `ms` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxWindowWait` no domínio `NativeGfxWindowContract`.

##### `op nativeGfxWindowCreate`
```flux
op nativeGfxWindowCreate (as int64: w, as int64: h, as string: title) as int64
```
- **Parâmetros**:
  - `w` (`int64`): Parâmetro de entrada para processamento da operação.
  - `h` (`int64`): Parâmetro de entrada para processamento da operação.
  - `title` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `nativeGfxWindowCreate` no domínio `NativeGfxWindowContract`.

##### `op nativeGfxWindowClose`
```flux
op nativeGfxWindowClose (as int64: win_id) as bool
```
- **Parâmetros**:
  - `win_id` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `nativeGfxWindowClose` no domínio `NativeGfxWindowContract`.

##### `op nativeGfxWindowFlush`
```flux
op nativeGfxWindowFlush (as int64: win_id) as bool
```
- **Parâmetros**:
  - `win_id` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `nativeGfxWindowFlush` no domínio `NativeGfxWindowContract`.

##### `op nativeGfxWindowClosed`
```flux
op nativeGfxWindowClosed (as int64: win_id) as bool
```
- **Parâmetros**:
  - `win_id` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `nativeGfxWindowClosed` no domínio `NativeGfxWindowContract`.

##### `op nativeGfxWindowWidth`
```flux
op nativeGfxWindowWidth (as int64: win_id) as int64
```
- **Parâmetros**:
  - `win_id` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `nativeGfxWindowWidth` no domínio `NativeGfxWindowContract`.

##### `op nativeGfxWindowHeight`
```flux
op nativeGfxWindowHeight (as int64: win_id) as int64
```
- **Parâmetros**:
  - `win_id` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `nativeGfxWindowHeight` no domínio `NativeGfxWindowContract`.

##### `op nativeGfxWindowWait`
```flux
op nativeGfxWindowWait (as int64: win_id, as int64: ms) as bool
```
- **Parâmetros**:
  - `win_id` (`int64`): Parâmetro de entrada para processamento da operação.
  - `ms` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `nativeGfxWindowWait` no domínio `NativeGfxWindowContract`.

---

## 5. Exemplos Canônicos de Uso em TheFlux

O exemplo a seguir demonstra a importação e o consumo prático da biblioteca:

```flux
# Exemplo Canônico de Consumo da NativeGfxStdLib
use NativeGfxStdLib

program (ExemploNativeGfxStdLib) {
      println("==================================================")
      println("  Demonstracao da Standard Library: NativeGfxStdLib")
      println("==================================================")

      # Chamada da operacao canônica
      mut as data: resultado = NativeGfxStdLib::nativeCreateWindow("TheFlux Window", 800, 600)
      println("Resultado obtido: " + resultado)

      println("Demonstracao concluida com sucesso.")
}
```

---

> [!TIP]
> Para consultar a visão arquitetural unificada de todas as bibliotecas, consulte o documento principal [StdLibs.md](../StdLibs.md).
