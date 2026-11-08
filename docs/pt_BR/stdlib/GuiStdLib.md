# 📚 `GuiStdLib` — Interfaces Gráficas com o Usuário, Componentes e Despacho de Eventos

> **Pilar Arquitetural**: Pilar 4 (Sistema, I/O & Rede)  
> **Status**: ✅ Homologado com 100% de Paridade nos 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Arquivo Mestre**: `stdlib/GuiStdLib/GuiStdLib.fdsl`  
> **Modo de Importação**: `use GuiStdLib` ou `use GuiStdLib::<Modulo>::<operacao>`

---

## 1. Visão Geral e Funcionalidades

A biblioteca padrão **`GuiStdLib`** integra o ecossistema oficial da linguagem TheFlux, fornecendo suporte de nível de sistema e algoritmos nativos certificados.

Conjunto de abstrações para construção de interfaces gráficas nativas: gerenciadores de layout (Box, Grid, Flex), hierarquia de widgets (botões, rótulos, campos de texto, tabelas, árvores), estilização via temas e loop de eventos responsivo.

### 1.1 Características e Princípios de Design
- **Compilação e Fusão Estática**: Todos os módulos de domínio são fundidos no agente unificado `GuiStdLib` em tempo de compilação, sem sobrecarga (*overhead*) de despacho indireto.
- **Isolamento e Segurança**: As operações verificam limites operacionais e utilizam despacho por contratos formais rigorosos.
- **Compatibilidade Multi-Backend**: Execução bit-a-bit idêntica em interpretador (`in`), bytecode (`vm`, `vmr`), nativo AOT (`llvm`) e WebAssembly (`wat`, `wasm`).

---

## 2. Estrutura Modular e Contratos

A biblioteca é composta por **9 módulos de domínio** e declara **56 operações públicas**:

| Arquivo de Domínio | Contrato Formal | Responsabilidade Principal | Qtd. Ops |
|---|---|---|:---:|
| `GuiConstants.fdsl` | `GuiConstantsContract` | Domínio especializado de `GuiConstants` | 13 |
| `GuiLayout.fdsl` | `GuiLayoutContract` | Domínio especializado de `GuiLayout` | 9 |
| `GuiScrollArea.fdsl` | `GuiScrollAreaContract` | Domínio especializado de `GuiScrollArea` | 4 |
| `GuiState.fdsl` | `GuiStateContract` | Domínio especializado de `GuiState` | 11 |
| `GuiTheme.fdsl` | `GuiThemeContract` | Domínio especializado de `GuiTheme` | 5 |
| `GuiWidgetBasic.fdsl` | `GuiWidgetBasicContract` | Domínio especializado de `GuiWidgetBasic` | 5 |
| `GuiWidgetButton.fdsl` | `GuiWidgetButtonContract` | Domínio especializado de `GuiWidgetButton` | 4 |
| `GuiWidgetInput.fdsl` | `GuiWidgetInputContract` | Domínio especializado de `GuiWidgetInput` | 3 |
| `GuiWidgetSlider.fdsl` | `GuiWidgetSliderContract` | Domínio especializado de `GuiWidgetSlider` | 2 |

---

## 3. Tipos, Estruturas e Enumerações Públicas

A biblioteca `GuiStdLib` opera diretamente com os tipos nativos e primitivos da linguagem TheFlux (`string`, `int64`, `float64`, `bool`, `list of data`, etc.), sem exigir tipos compostos adicionais.

---

## 4. Catálogo Detalhado de Operações por Domínio

### 4.1 Contrato `GuiConstantsContract` (`GuiConstants.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `guiDpiStandard` | `op guiDpiStandard () as float64` | `float64` |
| `guiDpiMacClassic` | `op guiDpiMacClassic () as float64` | `float64` |
| `guiDpiRetina` | `op guiDpiRetina () as float64` | `float64` |
| `guiMmPerInch` | `op guiMmPerInch () as float64` | `float64` |
| `guiHumanVisualReactionTimeMs` | `op guiHumanVisualReactionTimeMs () as float64` | `float64` |
| `guiPersistenceOfVisionHz` | `op guiPersistenceOfVisionHz () as float64` | `float64` |
| `guiLatencyInstantFeedbackMs` | `op guiLatencyInstantFeedbackMs () as float64` | `float64` |
| `guiTouchTargetMinPx` | `op guiTouchTargetMinPx () as int64` | `int64` |
| `guiFontSizeDefault` | `op guiFontSizeDefault () as int64` | `int64` |
| `guiFontSizeHeading` | `op guiFontSizeHeading () as int64` | `int64` |
| `guiFontSizeTitle` | `op guiFontSizeTitle () as int64` | `int64` |
| `guiPaddingDefault` | `op guiPaddingDefault () as int64` | `int64` |
| `guiItemSpacingDefault` | `op guiItemSpacingDefault () as int64` | `int64` |

#### Ficha Técnica das Operações:

##### `op guiDpiStandard`
```flux
op guiDpiStandard () as float64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `guiDpiStandard` no domínio `GuiConstantsContract`.

##### `op guiDpiMacClassic`
```flux
op guiDpiMacClassic () as float64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `guiDpiMacClassic` no domínio `GuiConstantsContract`.

##### `op guiDpiRetina`
```flux
op guiDpiRetina () as float64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `guiDpiRetina` no domínio `GuiConstantsContract`.

##### `op guiMmPerInch`
```flux
op guiMmPerInch () as float64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `guiMmPerInch` no domínio `GuiConstantsContract`.

##### `op guiHumanVisualReactionTimeMs`
```flux
op guiHumanVisualReactionTimeMs () as float64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `guiHumanVisualReactionTimeMs` no domínio `GuiConstantsContract`.

##### `op guiPersistenceOfVisionHz`
```flux
op guiPersistenceOfVisionHz () as float64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `guiPersistenceOfVisionHz` no domínio `GuiConstantsContract`.

##### `op guiLatencyInstantFeedbackMs`
```flux
op guiLatencyInstantFeedbackMs () as float64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `guiLatencyInstantFeedbackMs` no domínio `GuiConstantsContract`.

##### `op guiTouchTargetMinPx`
```flux
op guiTouchTargetMinPx () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `guiTouchTargetMinPx` no domínio `GuiConstantsContract`.

##### `op guiFontSizeDefault`
```flux
op guiFontSizeDefault () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `guiFontSizeDefault` no domínio `GuiConstantsContract`.

##### `op guiFontSizeHeading`
```flux
op guiFontSizeHeading () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `guiFontSizeHeading` no domínio `GuiConstantsContract`.

##### `op guiFontSizeTitle`
```flux
op guiFontSizeTitle () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `guiFontSizeTitle` no domínio `GuiConstantsContract`.

##### `op guiPaddingDefault`
```flux
op guiPaddingDefault () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `guiPaddingDefault` no domínio `GuiConstantsContract`.

##### `op guiItemSpacingDefault`
```flux
op guiItemSpacingDefault () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `guiItemSpacingDefault` no domínio `GuiConstantsContract`.

### 4.2 Contrato `GuiLayoutContract` (`GuiLayout.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `guiLayoutBeginRow` | `op guiLayoutBeginRow (as map: ctx) as map` | `map` |
| `guiLayoutEndRow` | `op guiLayoutEndRow (as map: ctx) as map` | `map` |
| `guiLayoutBeginColumn` | `op guiLayoutBeginColumn (as map: ctx) as map` | `map` |
| `guiLayoutEndColumn` | `op guiLayoutEndColumn (as map: ctx) as map` | `map` |
| `guiSpacing` | `op guiSpacing (as map: ctx, as int64: pixels) as map` | `map` |
| `guiSameLine` | `op guiSameLine (as map: ctx) as map` | `map` |
| `guiGetCursorX` | `op guiGetCursorX (as map: ctx) as int64` | `int64` |
| `guiGetCursorY` | `op guiGetCursorY (as map: ctx) as int64` | `int64` |
| `guiSetCursor` | `op guiSetCursor (as map: ctx, as int64: x, as int64: y) as map` | `map` |

#### Ficha Técnica das Operações:

##### `op guiLayoutBeginRow`
```flux
op guiLayoutBeginRow (as map: ctx) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `guiLayoutBeginRow` no domínio `GuiLayoutContract`.

##### `op guiLayoutEndRow`
```flux
op guiLayoutEndRow (as map: ctx) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `guiLayoutEndRow` no domínio `GuiLayoutContract`.

##### `op guiLayoutBeginColumn`
```flux
op guiLayoutBeginColumn (as map: ctx) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `guiLayoutBeginColumn` no domínio `GuiLayoutContract`.

##### `op guiLayoutEndColumn`
```flux
op guiLayoutEndColumn (as map: ctx) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `guiLayoutEndColumn` no domínio `GuiLayoutContract`.

##### `op guiSpacing`
```flux
op guiSpacing (as map: ctx, as int64: pixels) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `pixels` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `guiSpacing` no domínio `GuiLayoutContract`.

##### `op guiSameLine`
```flux
op guiSameLine (as map: ctx) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `guiSameLine` no domínio `GuiLayoutContract`.

##### `op guiGetCursorX`
```flux
op guiGetCursorX (as map: ctx) as int64
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `guiGetCursorX` no domínio `GuiLayoutContract`.

##### `op guiGetCursorY`
```flux
op guiGetCursorY (as map: ctx) as int64
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `guiGetCursorY` no domínio `GuiLayoutContract`.

##### `op guiSetCursor`
```flux
op guiSetCursor (as map: ctx, as int64: x, as int64: y) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `x` (`int64`): Parâmetro de entrada para processamento da operação.
  - `y` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `guiSetCursor` no domínio `GuiLayoutContract`.

### 4.3 Contrato `GuiScrollAreaContract` (`GuiScrollArea.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `guiBeginScrollArea` | `op guiBeginScrollArea (as map: ctx, as string: area_id, as int64: w, as int64: h) as map` | `map` |
| `guiEndScrollArea` | `op guiEndScrollArea (as map: ctx) as map` | `map` |
| `guiSetScrollOffsetY` | `op guiSetScrollOffsetY (as map: ctx, as string: area_id, as int64: offset_y) as map` | `map` |
| `guiGetScrollOffsetY` | `op guiGetScrollOffsetY (as map: ctx, as string: area_id) as int64` | `int64` |

#### Ficha Técnica das Operações:

##### `op guiBeginScrollArea`
```flux
op guiBeginScrollArea (as map: ctx, as string: area_id, as int64: w, as int64: h) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `area_id` (`string`): Parâmetro de entrada para processamento da operação.
  - `w` (`int64`): Parâmetro de entrada para processamento da operação.
  - `h` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `guiBeginScrollArea` no domínio `GuiScrollAreaContract`.

##### `op guiEndScrollArea`
```flux
op guiEndScrollArea (as map: ctx) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `guiEndScrollArea` no domínio `GuiScrollAreaContract`.

##### `op guiSetScrollOffsetY`
```flux
op guiSetScrollOffsetY (as map: ctx, as string: area_id, as int64: offset_y) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `area_id` (`string`): Parâmetro de entrada para processamento da operação.
  - `offset_y` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `guiSetScrollOffsetY` no domínio `GuiScrollAreaContract`.

##### `op guiGetScrollOffsetY`
```flux
op guiGetScrollOffsetY (as map: ctx, as string: area_id) as int64
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `area_id` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `guiGetScrollOffsetY` no domínio `GuiScrollAreaContract`.

### 4.4 Contrato `GuiStateContract` (`GuiState.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `guiInitContext` | `op guiInitContext (as int64: screen_w, as int64: screen_h) as map` | `map` |
| `guiCloseContext` | `op guiCloseContext (as map: ctx) as map` | `map` |
| `guiContextResetFrame` | `op guiContextResetFrame (as map: ctx) as map` | `map` |
| `guiGetWidgetCount` | `op guiGetWidgetCount (as map: ctx) as int64` | `int64` |
| `guiGetFrameCount` | `op guiGetFrameCount (as map: ctx) as int64` | `int64` |
| `guiGetScreenWidth` | `op guiGetScreenWidth (as map: ctx) as int64` | `int64` |
| `guiGetScreenHeight` | `op guiGetScreenHeight (as map: ctx) as int64` | `int64` |
| `guiBindNativeWindow` | `op guiBindNativeWindow (as map: ctx, as int64: win_id) as map` | `map` |
| `guiGetNativeWindow` | `op guiGetNativeWindow (as map: ctx) as int64` | `int64` |
| `guiUpdateInput` | `op guiUpdateInput (as map: ctx) as map` | `map` |
| `guiPollNativeEvents` | `op guiPollNativeEvents (as map: ctx) as int64` | `int64` |

#### Ficha Técnica das Operações:

##### `op guiInitContext`
```flux
op guiInitContext (as int64: screen_w, as int64: screen_h) as map
```
- **Parâmetros**:
  - `screen_w` (`int64`): Parâmetro de entrada para processamento da operação.
  - `screen_h` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `guiInitContext` no domínio `GuiStateContract`.

##### `op guiCloseContext`
```flux
op guiCloseContext (as map: ctx) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `guiCloseContext` no domínio `GuiStateContract`.

##### `op guiContextResetFrame`
```flux
op guiContextResetFrame (as map: ctx) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `guiContextResetFrame` no domínio `GuiStateContract`.

##### `op guiGetWidgetCount`
```flux
op guiGetWidgetCount (as map: ctx) as int64
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `guiGetWidgetCount` no domínio `GuiStateContract`.

##### `op guiGetFrameCount`
```flux
op guiGetFrameCount (as map: ctx) as int64
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `guiGetFrameCount` no domínio `GuiStateContract`.

##### `op guiGetScreenWidth`
```flux
op guiGetScreenWidth (as map: ctx) as int64
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `guiGetScreenWidth` no domínio `GuiStateContract`.

##### `op guiGetScreenHeight`
```flux
op guiGetScreenHeight (as map: ctx) as int64
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `guiGetScreenHeight` no domínio `GuiStateContract`.

##### `op guiBindNativeWindow`
```flux
op guiBindNativeWindow (as map: ctx, as int64: win_id) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `win_id` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `guiBindNativeWindow` no domínio `GuiStateContract`.

##### `op guiGetNativeWindow`
```flux
op guiGetNativeWindow (as map: ctx) as int64
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `guiGetNativeWindow` no domínio `GuiStateContract`.

##### `op guiUpdateInput`
```flux
op guiUpdateInput (as map: ctx) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `guiUpdateInput` no domínio `GuiStateContract`.

##### `op guiPollNativeEvents`
```flux
op guiPollNativeEvents (as map: ctx) as int64
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `guiPollNativeEvents` no domínio `GuiStateContract`.

### 4.5 Contrato `GuiThemeContract` (`GuiTheme.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `guiThemeDefault` | `op guiThemeDefault () as map` | `map` |
| `guiThemeDark` | `op guiThemeDark () as map` | `map` |
| `guiThemeLight` | `op guiThemeLight () as map` | `map` |
| `guiSetTheme` | `op guiSetTheme (as map: ctx, as map: theme) as map` | `map` |
| `guiGetThemeColor` | `op guiGetThemeColor (as map: ctx, as string: key) as list of int64` | `list of int64` |

#### Ficha Técnica das Operações:

##### `op guiThemeDefault`
```flux
op guiThemeDefault () as map
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `guiThemeDefault` no domínio `GuiThemeContract`.

##### `op guiThemeDark`
```flux
op guiThemeDark () as map
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `guiThemeDark` no domínio `GuiThemeContract`.

##### `op guiThemeLight`
```flux
op guiThemeLight () as map
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `guiThemeLight` no domínio `GuiThemeContract`.

##### `op guiSetTheme`
```flux
op guiSetTheme (as map: ctx, as map: theme) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `theme` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `guiSetTheme` no domínio `GuiThemeContract`.

##### `op guiGetThemeColor`
```flux
op guiGetThemeColor (as map: ctx, as string: key) as list of int64
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `key` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `guiGetThemeColor` no domínio `GuiThemeContract`.

### 4.6 Contrato `GuiWidgetBasicContract` (`GuiWidgetBasic.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `guiLabel` | `op guiLabel (as map: ctx, as string: text) as map` | `map` |
| `guiHeading` | `op guiHeading (as map: ctx, as string: text) as map` | `map` |
| `guiTitle` | `op guiTitle (as map: ctx, as string: text) as map` | `map` |
| `guiSeparator` | `op guiSeparator (as map: ctx) as map` | `map` |
| `guiProgressBar` | `op guiProgressBar (as map: ctx, as float64: fraction, as int64: w, as int64: h) as map` | `map` |

#### Ficha Técnica das Operações:

##### `op guiLabel`
```flux
op guiLabel (as map: ctx, as string: text) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `guiLabel` no domínio `GuiWidgetBasicContract`.

##### `op guiHeading`
```flux
op guiHeading (as map: ctx, as string: text) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `guiHeading` no domínio `GuiWidgetBasicContract`.

##### `op guiTitle`
```flux
op guiTitle (as map: ctx, as string: text) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `guiTitle` no domínio `GuiWidgetBasicContract`.

##### `op guiSeparator`
```flux
op guiSeparator (as map: ctx) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `guiSeparator` no domínio `GuiWidgetBasicContract`.

##### `op guiProgressBar`
```flux
op guiProgressBar (as map: ctx, as float64: fraction, as int64: w, as int64: h) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `fraction` (`float64`): Parâmetro de entrada para processamento da operação.
  - `w` (`int64`): Parâmetro de entrada para processamento da operação.
  - `h` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `guiProgressBar` no domínio `GuiWidgetBasicContract`.

### 4.7 Contrato `GuiWidgetButtonContract` (`GuiWidgetButton.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `guiButton` | `op guiButton (as map: ctx, as string: label) as list of data` | `list of data` |
| `guiButtonEx` | `op guiButtonEx (as map: ctx, as string: label, as int64: w, as int64: h) as list of data` | `list of data` |
| `guiCheckbox` | `op guiCheckbox (as map: ctx, as string: label, as bool: active) as list of data` | `list of data` |
| `guiRadioButton` | `op guiRadioButton (as map: ctx, as string: label, as bool: active) as list of data` | `list of data` |

#### Ficha Técnica das Operações:

##### `op guiButton`
```flux
op guiButton (as map: ctx, as string: label) as list of data
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `label` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `guiButton` no domínio `GuiWidgetButtonContract`.

##### `op guiButtonEx`
```flux
op guiButtonEx (as map: ctx, as string: label, as int64: w, as int64: h) as list of data
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `label` (`string`): Parâmetro de entrada para processamento da operação.
  - `w` (`int64`): Parâmetro de entrada para processamento da operação.
  - `h` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `guiButtonEx` no domínio `GuiWidgetButtonContract`.

##### `op guiCheckbox`
```flux
op guiCheckbox (as map: ctx, as string: label, as bool: active) as list of data
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `label` (`string`): Parâmetro de entrada para processamento da operação.
  - `active` (`bool`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `guiCheckbox` no domínio `GuiWidgetButtonContract`.

##### `op guiRadioButton`
```flux
op guiRadioButton (as map: ctx, as string: label, as bool: active) as list of data
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `label` (`string`): Parâmetro de entrada para processamento da operação.
  - `active` (`bool`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `guiRadioButton` no domínio `GuiWidgetButtonContract`.

### 4.8 Contrato `GuiWidgetInputContract` (`GuiWidgetInput.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `guiInputText` | `op guiInputText (as map: ctx, as string: label, as string: current_text, as int64: max_len) as list of data` | `list of data` |
| `guiInputInt` | `op guiInputInt (as map: ctx, as string: label, as int64: current_val) as list of data` | `list of data` |
| `guiInputFloat` | `op guiInputFloat (as map: ctx, as string: label, as float64: current_val) as list of data` | `list of data` |

#### Ficha Técnica das Operações:

##### `op guiInputText`
```flux
op guiInputText (as map: ctx, as string: label, as string: current_text, as int64: max_len) as list of data
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `label` (`string`): Parâmetro de entrada para processamento da operação.
  - `current_text` (`string`): Parâmetro de entrada para processamento da operação.
  - `max_len` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `guiInputText` no domínio `GuiWidgetInputContract`.

##### `op guiInputInt`
```flux
op guiInputInt (as map: ctx, as string: label, as int64: current_val) as list of data
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `label` (`string`): Parâmetro de entrada para processamento da operação.
  - `current_val` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `guiInputInt` no domínio `GuiWidgetInputContract`.

##### `op guiInputFloat`
```flux
op guiInputFloat (as map: ctx, as string: label, as float64: current_val) as list of data
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `label` (`string`): Parâmetro de entrada para processamento da operação.
  - `current_val` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `guiInputFloat` no domínio `GuiWidgetInputContract`.

### 4.9 Contrato `GuiWidgetSliderContract` (`GuiWidgetSlider.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `guiSliderFloat` | `op guiSliderFloat (as map: ctx, as string: label, as float64: val, as float64: min_val, as float64: max_val) as list of data` | `list of data` |
| `guiSliderInt` | `op guiSliderInt (as map: ctx, as string: label, as int64: val, as int64: min_val, as int64: max_val) as list of data` | `list of data` |

#### Ficha Técnica das Operações:

##### `op guiSliderFloat`
```flux
op guiSliderFloat (as map: ctx, as string: label, as float64: val, as float64: min_val, as float64: max_val) as list of data
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `label` (`string`): Parâmetro de entrada para processamento da operação.
  - `val` (`float64`): Parâmetro de entrada para processamento da operação.
  - `min_val` (`float64`): Parâmetro de entrada para processamento da operação.
  - `max_val` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `guiSliderFloat` no domínio `GuiWidgetSliderContract`.

##### `op guiSliderInt`
```flux
op guiSliderInt (as map: ctx, as string: label, as int64: val, as int64: min_val, as int64: max_val) as list of data
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `label` (`string`): Parâmetro de entrada para processamento da operação.
  - `val` (`int64`): Parâmetro de entrada para processamento da operação.
  - `min_val` (`int64`): Parâmetro de entrada para processamento da operação.
  - `max_val` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `guiSliderInt` no domínio `GuiWidgetSliderContract`.

---

## 5. Exemplos Canônicos de Uso em TheFlux

O exemplo a seguir demonstra a importação e o consumo prático da biblioteca:

```flux
# Exemplo Canônico de Consumo da GuiStdLib
use GuiStdLib

program (ExemploGuiStdLib) {
      println("==================================================")
      println("  Demonstracao da Standard Library: GuiStdLib")
      println("==================================================")

      # Chamada da operacao canônica
      mut as data: resultado = GuiStdLib::guiCreateTheme("Dark")
      println("Resultado obtido: " + resultado)

      println("Demonstracao concluida com sucesso.")
}
```

---

> [!TIP]
> Para consultar a visão arquitetural unificada de todas as bibliotecas, consulte o documento principal [StdLibs.md](../StdLibs.md).
