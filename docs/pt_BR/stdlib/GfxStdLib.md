# 📚 `GfxStdLib` — Primitivas Gráficas 2D/3D, Shaders, Câmeras e Transformações

> **Pilar Arquitetural**: Pilar 4 (Sistema, I/O & Rede)  
> **Status**: ✅ Homologado com 100% de Paridade nos 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Arquivo Mestre**: `stdlib/GfxStdLib/GfxStdLib.fdsl`  
> **Modo de Importação**: `use GfxStdLib` ou `use GfxStdLib::<Modulo>::<operacao>`

---

## 1. Visão Geral e Funcionalidades

A biblioteca padrão **`GfxStdLib`** integra o ecossistema oficial da linguagem TheFlux, fornecendo suporte de nível de sistema e algoritmos nativos certificados.

Framework matemático e de renderização para computação gráfica: vetores e matrizes de projeção (Perspective/Orthographic), modelos de iluminação (Phong/Blinn), câmeras orbitais e FPS, malhas poligonais e detecção de colisões (AABB e esferas).

### 1.1 Características e Princípios de Design
- **Compilação e Fusão Estática**: Todos os módulos de domínio são fundidos no agente unificado `GfxStdLib` em tempo de compilação, sem sobrecarga (*overhead*) de despacho indireto.
- **Isolamento e Segurança**: As operações verificam limites operacionais e utilizam despacho por contratos formais rigorosos.
- **Compatibilidade Multi-Backend**: Execução bit-a-bit idêntica em interpretador (`in`), bytecode (`vm`, `vmr`), nativo AOT (`llvm`) e WebAssembly (`wat`, `wasm`).

---

## 2. Estrutura Modular e Contratos

A biblioteca é composta por **9 módulos de domínio** e declara **86 operações públicas**:

| Arquivo de Domínio | Contrato Formal | Responsabilidade Principal | Qtd. Ops |
|---|---|---|:---:|
| `GfxCamera.fdsl` | `GfxCameraContract` | Domínio especializado de `GfxCamera` | 3 |
| `GfxCollision.fdsl` | `GfxCollisionContract` | Domínio especializado de `GfxCollision` | 4 |
| `GfxColor.fdsl` | `GfxColorContract` | Domínio especializado de `GfxColor` | 9 |
| `GfxConstants.fdsl` | `GfxConstantsContract` | Domínio especializado de `GfxConstants` | 30 |
| `GfxInput.fdsl` | `GfxInputContract` | Domínio especializado de `GfxInput` | 6 |
| `GfxOpticsPhysics.fdsl` | `GfxOpticsPhysicsContract` | Domínio especializado de `GfxOpticsPhysics` | 4 |
| `GfxPrimitives.fdsl` | `GfxPrimitivesContract` | Domínio especializado de `GfxPrimitives` | 8 |
| `GfxState.fdsl` | `GfxStateContract` | Domínio especializado de `GfxState` | 16 |
| `GfxTexture.fdsl` | `GfxTextureContract` | Domínio especializado de `GfxTexture` | 6 |

---

## 3. Tipos, Estruturas e Enumerações Públicas

A biblioteca `GfxStdLib` opera diretamente com os tipos nativos e primitivos da linguagem TheFlux (`string`, `int64`, `float64`, `bool`, `list of data`, etc.), sem exigir tipos compostos adicionais.

---

## 4. Catálogo Detalhado de Operações por Domínio

### 4.1 Contrato `GfxCameraContract` (`GfxCamera.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `gfxCamera2DNew` | `op gfxCamera2DNew (as float64: target_x, as float64: target_y, as float64: offset_x, as float64: offset_y, as float64: rotation_deg, as float64: zoom) as map` | `map` |
| `gfxWorldToScreen2D` | `op gfxWorldToScreen2D (as float64: wx, as float64: wy, as map: camera) as list of float64` | `list of float64` |
| `gfxScreenToWorld2D` | `op gfxScreenToWorld2D (as float64: sx, as float64: sy, as map: camera) as list of float64` | `list of float64` |

#### Ficha Técnica das Operações:

##### `op gfxCamera2DNew`
```flux
op gfxCamera2DNew (as float64: target_x, as float64: target_y, as float64: offset_x, as float64: offset_y, as float64: rotation_deg, as float64: zoom) as map
```
- **Parâmetros**:
  - `target_x` (`float64`): Parâmetro de entrada para processamento da operação.
  - `target_y` (`float64`): Parâmetro de entrada para processamento da operação.
  - `offset_x` (`float64`): Parâmetro de entrada para processamento da operação.
  - `offset_y` (`float64`): Parâmetro de entrada para processamento da operação.
  - `rotation_deg` (`float64`): Parâmetro de entrada para processamento da operação.
  - `zoom` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxCamera2DNew` no domínio `GfxCameraContract`.

##### `op gfxWorldToScreen2D`
```flux
op gfxWorldToScreen2D (as float64: wx, as float64: wy, as map: camera) as list of float64
```
- **Parâmetros**:
  - `wx` (`float64`): Parâmetro de entrada para processamento da operação.
  - `wy` (`float64`): Parâmetro de entrada para processamento da operação.
  - `camera` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxWorldToScreen2D` no domínio `GfxCameraContract`.

##### `op gfxScreenToWorld2D`
```flux
op gfxScreenToWorld2D (as float64: sx, as float64: sy, as map: camera) as list of float64
```
- **Parâmetros**:
  - `sx` (`float64`): Parâmetro de entrada para processamento da operação.
  - `sy` (`float64`): Parâmetro de entrada para processamento da operação.
  - `camera` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxScreenToWorld2D` no domínio `GfxCameraContract`.

### 4.2 Contrato `GfxCollisionContract` (`GfxCollision.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `gfxCheckCollisionRecs` | `op gfxCheckCollisionRecs (as float64: x1, as float64: y1, as float64: w1, as float64: h1, as float64: x2, as float64: y2, as float64: w2, as float64: h2) as bool` | `bool` |
| `gfxCheckCollisionCircles` | `op gfxCheckCollisionCircles (as float64: c1x, as float64: c1y, as float64: r1, as float64: c2x, as float64: c2y, as float64: r2) as bool` | `bool` |
| `gfxCheckCollisionPointRec` | `op gfxCheckCollisionPointRec (as float64: px, as float64: py, as float64: rx, as float64: ry, as float64: rw, as float64: rh) as bool` | `bool` |
| `gfxCheckCollisionPointCircle` | `op gfxCheckCollisionPointCircle (as float64: px, as float64: py, as float64: cx, as float64: cy, as float64: radius) as bool` | `bool` |

#### Ficha Técnica das Operações:

##### `op gfxCheckCollisionRecs`
```flux
op gfxCheckCollisionRecs (as float64: x1, as float64: y1, as float64: w1, as float64: h1, as float64: x2, as float64: y2, as float64: w2, as float64: h2) as bool
```
- **Parâmetros**:
  - `x1` (`float64`): Parâmetro de entrada para processamento da operação.
  - `y1` (`float64`): Parâmetro de entrada para processamento da operação.
  - `w1` (`float64`): Parâmetro de entrada para processamento da operação.
  - `h1` (`float64`): Parâmetro de entrada para processamento da operação.
  - `x2` (`float64`): Parâmetro de entrada para processamento da operação.
  - `y2` (`float64`): Parâmetro de entrada para processamento da operação.
  - `w2` (`float64`): Parâmetro de entrada para processamento da operação.
  - `h2` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxCheckCollisionRecs` no domínio `GfxCollisionContract`.

##### `op gfxCheckCollisionCircles`
```flux
op gfxCheckCollisionCircles (as float64: c1x, as float64: c1y, as float64: r1, as float64: c2x, as float64: c2y, as float64: r2) as bool
```
- **Parâmetros**:
  - `c1x` (`float64`): Parâmetro de entrada para processamento da operação.
  - `c1y` (`float64`): Parâmetro de entrada para processamento da operação.
  - `r1` (`float64`): Parâmetro de entrada para processamento da operação.
  - `c2x` (`float64`): Parâmetro de entrada para processamento da operação.
  - `c2y` (`float64`): Parâmetro de entrada para processamento da operação.
  - `r2` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxCheckCollisionCircles` no domínio `GfxCollisionContract`.

##### `op gfxCheckCollisionPointRec`
```flux
op gfxCheckCollisionPointRec (as float64: px, as float64: py, as float64: rx, as float64: ry, as float64: rw, as float64: rh) as bool
```
- **Parâmetros**:
  - `px` (`float64`): Parâmetro de entrada para processamento da operação.
  - `py` (`float64`): Parâmetro de entrada para processamento da operação.
  - `rx` (`float64`): Parâmetro de entrada para processamento da operação.
  - `ry` (`float64`): Parâmetro de entrada para processamento da operação.
  - `rw` (`float64`): Parâmetro de entrada para processamento da operação.
  - `rh` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxCheckCollisionPointRec` no domínio `GfxCollisionContract`.

##### `op gfxCheckCollisionPointCircle`
```flux
op gfxCheckCollisionPointCircle (as float64: px, as float64: py, as float64: cx, as float64: cy, as float64: radius) as bool
```
- **Parâmetros**:
  - `px` (`float64`): Parâmetro de entrada para processamento da operação.
  - `py` (`float64`): Parâmetro de entrada para processamento da operação.
  - `cx` (`float64`): Parâmetro de entrada para processamento da operação.
  - `cy` (`float64`): Parâmetro de entrada para processamento da operação.
  - `radius` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxCheckCollisionPointCircle` no domínio `GfxCollisionContract`.

### 4.3 Contrato `GfxColorContract` (`GfxColor.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `gfxColorRgba` | `op gfxColorRgba (as int64: r, as int64: g, as int64: b, as int64: a) as list of int64` | `list of int64` |
| `gfxColorGetR` | `op gfxColorGetR (as list of int64: c) as int64` | `int64` |
| `gfxColorGetG` | `op gfxColorGetG (as list of int64: c) as int64` | `int64` |
| `gfxColorGetB` | `op gfxColorGetB (as list of int64: c) as int64` | `int64` |
| `gfxColorGetA` | `op gfxColorGetA (as list of int64: c) as int64` | `int64` |
| `gfxColorFromHex` | `op gfxColorFromHex (as string: hex_str) as list of int64` | `list of int64` |
| `gfxColorToHex` | `op gfxColorToHex (as list of int64: color) as string` | `string` |
| `gfxColorLerp` | `op gfxColorLerp (as list of int64: c1, as list of int64: c2, as float64: t) as list of int64` | `list of int64` |
| `gfxColorAlpha` | `op gfxColorAlpha (as list of int64: color, as float64: alpha) as list of int64` | `list of int64` |

#### Ficha Técnica das Operações:

##### `op gfxColorRgba`
```flux
op gfxColorRgba (as int64: r, as int64: g, as int64: b, as int64: a) as list of int64
```
- **Parâmetros**:
  - `r` (`int64`): Parâmetro de entrada para processamento da operação.
  - `g` (`int64`): Parâmetro de entrada para processamento da operação.
  - `b` (`int64`): Parâmetro de entrada para processamento da operação.
  - `a` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxColorRgba` no domínio `GfxColorContract`.

##### `op gfxColorGetR`
```flux
op gfxColorGetR (as list of int64: c) as int64
```
- **Parâmetros**:
  - `c` (`list of int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxColorGetR` no domínio `GfxColorContract`.

##### `op gfxColorGetG`
```flux
op gfxColorGetG (as list of int64: c) as int64
```
- **Parâmetros**:
  - `c` (`list of int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxColorGetG` no domínio `GfxColorContract`.

##### `op gfxColorGetB`
```flux
op gfxColorGetB (as list of int64: c) as int64
```
- **Parâmetros**:
  - `c` (`list of int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxColorGetB` no domínio `GfxColorContract`.

##### `op gfxColorGetA`
```flux
op gfxColorGetA (as list of int64: c) as int64
```
- **Parâmetros**:
  - `c` (`list of int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxColorGetA` no domínio `GfxColorContract`.

##### `op gfxColorFromHex`
```flux
op gfxColorFromHex (as string: hex_str) as list of int64
```
- **Parâmetros**:
  - `hex_str` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxColorFromHex` no domínio `GfxColorContract`.

##### `op gfxColorToHex`
```flux
op gfxColorToHex (as list of int64: color) as string
```
- **Parâmetros**:
  - `color` (`list of int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxColorToHex` no domínio `GfxColorContract`.

##### `op gfxColorLerp`
```flux
op gfxColorLerp (as list of int64: c1, as list of int64: c2, as float64: t) as list of int64
```
- **Parâmetros**:
  - `c1` (`list of int64`): Parâmetro de entrada para processamento da operação.
  - `c2` (`list of int64`): Parâmetro de entrada para processamento da operação.
  - `t` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxColorLerp` no domínio `GfxColorContract`.

##### `op gfxColorAlpha`
```flux
op gfxColorAlpha (as list of int64: color, as float64: alpha) as list of int64
```
- **Parâmetros**:
  - `color` (`list of int64`): Parâmetro de entrada para processamento da operação.
  - `alpha` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxColorAlpha` no domínio `GfxColorContract`.

### 4.4 Contrato `GfxConstantsContract` (`GfxConstants.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `res720pW` | `op res720pW () as int64` | `int64` |
| `res720pH` | `op res720pH () as int64` | `int64` |
| `res1080pW` | `op res1080pW () as int64` | `int64` |
| `res1080pH` | `op res1080pH () as int64` | `int64` |
| `res4kW` | `op res4kW () as int64` | `int64` |
| `res4kH` | `op res4kH () as int64` | `int64` |
| `aspect16x9` | `op aspect16x9 () as float64` | `float64` |
| `aspect4x3` | `op aspect4x3 () as float64` | `float64` |
| `aspect21x9` | `op aspect21x9 () as float64` | `float64` |
| `colorWhite` | `op colorWhite () as list of int64` | `list of int64` |
| `colorBlack` | `op colorBlack () as list of int64` | `list of int64` |
| `colorRed` | `op colorRed () as list of int64` | `list of int64` |
| `colorGreen` | `op colorGreen () as list of int64` | `list of int64` |
| `colorBlue` | `op colorBlue () as list of int64` | `list of int64` |
| `colorYellow` | `op colorYellow () as list of int64` | `list of int64` |
| `colorMagenta` | `op colorMagenta () as list of int64` | `list of int64` |
| `colorCyan` | `op colorCyan () as list of int64` | `list of int64` |
| `colorTransparent` | `op colorTransparent () as list of int64` | `list of int64` |
| `gfxIorAir` | `op gfxIorAir () as float64` | `float64` |
| `gfxIorWater` | `op gfxIorWater () as float64` | `float64` |
| `gfxIorGlass` | `op gfxIorGlass () as float64` | `float64` |
| `gfxIorDiamond` | `op gfxIorDiamond () as float64` | `float64` |
| `gfxIorPolycarbonate` | `op gfxIorPolycarbonate () as float64` | `float64` |
| `gfxLuxDirectSun` | `op gfxLuxDirectSun () as float64` | `float64` |
| `gfxLuxOvercastDay` | `op gfxLuxOvercastDay () as float64` | `float64` |
| `gfxLuxOffice` | `op gfxLuxOffice () as float64` | `float64` |
| `gfxLuxFullMoon` | `op gfxLuxFullMoon () as float64` | `float64` |
| `gfxKelvinDaylightD65` | `op gfxKelvinDaylightD65 () as float64` | `float64` |
| `gfxKelvinTungsten` | `op gfxKelvinTungsten () as float64` | `float64` |
| `gfxKelvinCandle` | `op gfxKelvinCandle () as float64` | `float64` |

#### Ficha Técnica das Operações:

##### `op res720pW`
```flux
op res720pW () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `res720pW` no domínio `GfxConstantsContract`.

##### `op res720pH`
```flux
op res720pH () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `res720pH` no domínio `GfxConstantsContract`.

##### `op res1080pW`
```flux
op res1080pW () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `res1080pW` no domínio `GfxConstantsContract`.

##### `op res1080pH`
```flux
op res1080pH () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `res1080pH` no domínio `GfxConstantsContract`.

##### `op res4kW`
```flux
op res4kW () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `res4kW` no domínio `GfxConstantsContract`.

##### `op res4kH`
```flux
op res4kH () as int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `res4kH` no domínio `GfxConstantsContract`.

##### `op aspect16x9`
```flux
op aspect16x9 () as float64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `aspect16x9` no domínio `GfxConstantsContract`.

##### `op aspect4x3`
```flux
op aspect4x3 () as float64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `aspect4x3` no domínio `GfxConstantsContract`.

##### `op aspect21x9`
```flux
op aspect21x9 () as float64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `aspect21x9` no domínio `GfxConstantsContract`.

##### `op colorWhite`
```flux
op colorWhite () as list of int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `list of int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `colorWhite` no domínio `GfxConstantsContract`.

##### `op colorBlack`
```flux
op colorBlack () as list of int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `list of int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `colorBlack` no domínio `GfxConstantsContract`.

##### `op colorRed`
```flux
op colorRed () as list of int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `list of int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `colorRed` no domínio `GfxConstantsContract`.

##### `op colorGreen`
```flux
op colorGreen () as list of int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `list of int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `colorGreen` no domínio `GfxConstantsContract`.

##### `op colorBlue`
```flux
op colorBlue () as list of int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `list of int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `colorBlue` no domínio `GfxConstantsContract`.

##### `op colorYellow`
```flux
op colorYellow () as list of int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `list of int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `colorYellow` no domínio `GfxConstantsContract`.

##### `op colorMagenta`
```flux
op colorMagenta () as list of int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `list of int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `colorMagenta` no domínio `GfxConstantsContract`.

##### `op colorCyan`
```flux
op colorCyan () as list of int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `list of int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `colorCyan` no domínio `GfxConstantsContract`.

##### `op colorTransparent`
```flux
op colorTransparent () as list of int64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `list of int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `colorTransparent` no domínio `GfxConstantsContract`.

##### `op gfxIorAir`
```flux
op gfxIorAir () as float64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxIorAir` no domínio `GfxConstantsContract`.

##### `op gfxIorWater`
```flux
op gfxIorWater () as float64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxIorWater` no domínio `GfxConstantsContract`.

##### `op gfxIorGlass`
```flux
op gfxIorGlass () as float64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxIorGlass` no domínio `GfxConstantsContract`.

##### `op gfxIorDiamond`
```flux
op gfxIorDiamond () as float64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxIorDiamond` no domínio `GfxConstantsContract`.

##### `op gfxIorPolycarbonate`
```flux
op gfxIorPolycarbonate () as float64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxIorPolycarbonate` no domínio `GfxConstantsContract`.

##### `op gfxLuxDirectSun`
```flux
op gfxLuxDirectSun () as float64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxLuxDirectSun` no domínio `GfxConstantsContract`.

##### `op gfxLuxOvercastDay`
```flux
op gfxLuxOvercastDay () as float64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxLuxOvercastDay` no domínio `GfxConstantsContract`.

##### `op gfxLuxOffice`
```flux
op gfxLuxOffice () as float64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxLuxOffice` no domínio `GfxConstantsContract`.

##### `op gfxLuxFullMoon`
```flux
op gfxLuxFullMoon () as float64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxLuxFullMoon` no domínio `GfxConstantsContract`.

##### `op gfxKelvinDaylightD65`
```flux
op gfxKelvinDaylightD65 () as float64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxKelvinDaylightD65` no domínio `GfxConstantsContract`.

##### `op gfxKelvinTungsten`
```flux
op gfxKelvinTungsten () as float64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxKelvinTungsten` no domínio `GfxConstantsContract`.

##### `op gfxKelvinCandle`
```flux
op gfxKelvinCandle () as float64
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxKelvinCandle` no domínio `GfxConstantsContract`.

### 4.5 Contrato `GfxInputContract` (`GfxInput.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `gfxInputNew` | `op gfxInputNew () as map` | `map` |
| `gfxSetInputState` | `op gfxSetInputState (as map: input_state, as string: key_name, as bool: is_down) as map` | `map` |
| `gfxPollInput` | `op gfxPollInput (as map: input_state, as string: key_name) as bool` | `bool` |
| `gfxSetMousePosition` | `op gfxSetMousePosition (as map: input_state, as int64: x, as int64: y) as map` | `map` |
| `gfxGetMouseX` | `op gfxGetMouseX (as map: input_state) as int64` | `int64` |
| `gfxGetMouseY` | `op gfxGetMouseY (as map: input_state) as int64` | `int64` |

#### Ficha Técnica das Operações:

##### `op gfxInputNew`
```flux
op gfxInputNew () as map
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxInputNew` no domínio `GfxInputContract`.

##### `op gfxSetInputState`
```flux
op gfxSetInputState (as map: input_state, as string: key_name, as bool: is_down) as map
```
- **Parâmetros**:
  - `input_state` (`map`): Parâmetro de entrada para processamento da operação.
  - `key_name` (`string`): Parâmetro de entrada para processamento da operação.
  - `is_down` (`bool`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxSetInputState` no domínio `GfxInputContract`.

##### `op gfxPollInput`
```flux
op gfxPollInput (as map: input_state, as string: key_name) as bool
```
- **Parâmetros**:
  - `input_state` (`map`): Parâmetro de entrada para processamento da operação.
  - `key_name` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxPollInput` no domínio `GfxInputContract`.

##### `op gfxSetMousePosition`
```flux
op gfxSetMousePosition (as map: input_state, as int64: x, as int64: y) as map
```
- **Parâmetros**:
  - `input_state` (`map`): Parâmetro de entrada para processamento da operação.
  - `x` (`int64`): Parâmetro de entrada para processamento da operação.
  - `y` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxSetMousePosition` no domínio `GfxInputContract`.

##### `op gfxGetMouseX`
```flux
op gfxGetMouseX (as map: input_state) as int64
```
- **Parâmetros**:
  - `input_state` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxGetMouseX` no domínio `GfxInputContract`.

##### `op gfxGetMouseY`
```flux
op gfxGetMouseY (as map: input_state) as int64
```
- **Parâmetros**:
  - `input_state` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxGetMouseY` no domínio `GfxInputContract`.

### 4.6 Contrato `GfxOpticsPhysicsContract` (`GfxOpticsPhysics.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `gfxFresnelSchlick` | `op gfxFresnelSchlick (as float64: cos_theta, as float64: f0) as float64` | `float64` |
| `gfxLightAttenuation` | `op gfxLightAttenuation (as float64: distance, as float64: constant_term, as float64: linear_term, as float64: quadratic_term) as float64` | `float64` |
| `gfxKelvinToRgb` | `op gfxKelvinToRgb (as float64: kelvin) as list of int64` | `list of int64` |
| `gfxLuminance` | `op gfxLuminance (as list of int64: color) as float64` | `float64` |

#### Ficha Técnica das Operações:

##### `op gfxFresnelSchlick`
```flux
op gfxFresnelSchlick (as float64: cos_theta, as float64: f0) as float64
```
- **Parâmetros**:
  - `cos_theta` (`float64`): Parâmetro de entrada para processamento da operação.
  - `f0` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxFresnelSchlick` no domínio `GfxOpticsPhysicsContract`.

##### `op gfxLightAttenuation`
```flux
op gfxLightAttenuation (as float64: distance, as float64: constant_term, as float64: linear_term, as float64: quadratic_term) as float64
```
- **Parâmetros**:
  - `distance` (`float64`): Parâmetro de entrada para processamento da operação.
  - `constant_term` (`float64`): Parâmetro de entrada para processamento da operação.
  - `linear_term` (`float64`): Parâmetro de entrada para processamento da operação.
  - `quadratic_term` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxLightAttenuation` no domínio `GfxOpticsPhysicsContract`.

##### `op gfxKelvinToRgb`
```flux
op gfxKelvinToRgb (as float64: kelvin) as list of int64
```
- **Parâmetros**:
  - `kelvin` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxKelvinToRgb` no domínio `GfxOpticsPhysicsContract`.

##### `op gfxLuminance`
```flux
op gfxLuminance (as list of int64: color) as float64
```
- **Parâmetros**:
  - `color` (`list of int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxLuminance` no domínio `GfxOpticsPhysicsContract`.

### 4.7 Contrato `GfxPrimitivesContract` (`GfxPrimitives.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `gfxClearBackground` | `op gfxClearBackground (as map: ctx, as list of int64: color) as map` | `map` |
| `gfxDrawRect` | `op gfxDrawRect (as map: ctx, as float64: x, as float64: y, as float64: w, as float64: h, as list of int64: color) as map` | `map` |
| `gfxDrawRectLines` | `op gfxDrawRectLines (as map: ctx, as float64: x, as float64: y, as float64: w, as float64: h, as list of int64: color) as map` | `map` |
| `gfxDrawCircle` | `op gfxDrawCircle (as map: ctx, as float64: cx, as float64: cy, as float64: radius, as list of int64: color) as map` | `map` |
| `gfxDrawCircleLines` | `op gfxDrawCircleLines (as map: ctx, as float64: cx, as float64: cy, as float64: radius, as list of int64: color) as map` | `map` |
| `gfxDrawLine` | `op gfxDrawLine (as map: ctx, as float64: x1, as float64: y1, as float64: x2, as float64: y2, as list of int64: color) as map` | `map` |
| `gfxDrawTriangle` | `op gfxDrawTriangle (as map: ctx, as float64: x1, as float64: y1, as float64: x2, as float64: y2, as float64: x3, as float64: y3, as list of int64: color) as map` | `map` |
| `gfxDrawText` | `op gfxDrawText (as map: ctx, as string: text, as float64: x, as float64: y, as int64: font_size, as list of int64: color) as map` | `map` |

#### Ficha Técnica das Operações:

##### `op gfxClearBackground`
```flux
op gfxClearBackground (as map: ctx, as list of int64: color) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `color` (`list of int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxClearBackground` no domínio `GfxPrimitivesContract`.

##### `op gfxDrawRect`
```flux
op gfxDrawRect (as map: ctx, as float64: x, as float64: y, as float64: w, as float64: h, as list of int64: color) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `x` (`float64`): Parâmetro de entrada para processamento da operação.
  - `y` (`float64`): Parâmetro de entrada para processamento da operação.
  - `w` (`float64`): Parâmetro de entrada para processamento da operação.
  - `h` (`float64`): Parâmetro de entrada para processamento da operação.
  - `color` (`list of int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxDrawRect` no domínio `GfxPrimitivesContract`.

##### `op gfxDrawRectLines`
```flux
op gfxDrawRectLines (as map: ctx, as float64: x, as float64: y, as float64: w, as float64: h, as list of int64: color) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `x` (`float64`): Parâmetro de entrada para processamento da operação.
  - `y` (`float64`): Parâmetro de entrada para processamento da operação.
  - `w` (`float64`): Parâmetro de entrada para processamento da operação.
  - `h` (`float64`): Parâmetro de entrada para processamento da operação.
  - `color` (`list of int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxDrawRectLines` no domínio `GfxPrimitivesContract`.

##### `op gfxDrawCircle`
```flux
op gfxDrawCircle (as map: ctx, as float64: cx, as float64: cy, as float64: radius, as list of int64: color) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `cx` (`float64`): Parâmetro de entrada para processamento da operação.
  - `cy` (`float64`): Parâmetro de entrada para processamento da operação.
  - `radius` (`float64`): Parâmetro de entrada para processamento da operação.
  - `color` (`list of int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxDrawCircle` no domínio `GfxPrimitivesContract`.

##### `op gfxDrawCircleLines`
```flux
op gfxDrawCircleLines (as map: ctx, as float64: cx, as float64: cy, as float64: radius, as list of int64: color) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `cx` (`float64`): Parâmetro de entrada para processamento da operação.
  - `cy` (`float64`): Parâmetro de entrada para processamento da operação.
  - `radius` (`float64`): Parâmetro de entrada para processamento da operação.
  - `color` (`list of int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxDrawCircleLines` no domínio `GfxPrimitivesContract`.

##### `op gfxDrawLine`
```flux
op gfxDrawLine (as map: ctx, as float64: x1, as float64: y1, as float64: x2, as float64: y2, as list of int64: color) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `x1` (`float64`): Parâmetro de entrada para processamento da operação.
  - `y1` (`float64`): Parâmetro de entrada para processamento da operação.
  - `x2` (`float64`): Parâmetro de entrada para processamento da operação.
  - `y2` (`float64`): Parâmetro de entrada para processamento da operação.
  - `color` (`list of int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxDrawLine` no domínio `GfxPrimitivesContract`.

##### `op gfxDrawTriangle`
```flux
op gfxDrawTriangle (as map: ctx, as float64: x1, as float64: y1, as float64: x2, as float64: y2, as float64: x3, as float64: y3, as list of int64: color) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `x1` (`float64`): Parâmetro de entrada para processamento da operação.
  - `y1` (`float64`): Parâmetro de entrada para processamento da operação.
  - `x2` (`float64`): Parâmetro de entrada para processamento da operação.
  - `y2` (`float64`): Parâmetro de entrada para processamento da operação.
  - `x3` (`float64`): Parâmetro de entrada para processamento da operação.
  - `y3` (`float64`): Parâmetro de entrada para processamento da operação.
  - `color` (`list of int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxDrawTriangle` no domínio `GfxPrimitivesContract`.

##### `op gfxDrawText`
```flux
op gfxDrawText (as map: ctx, as string: text, as float64: x, as float64: y, as int64: font_size, as list of int64: color) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
  - `x` (`float64`): Parâmetro de entrada para processamento da operação.
  - `y` (`float64`): Parâmetro de entrada para processamento da operação.
  - `font_size` (`int64`): Parâmetro de entrada para processamento da operação.
  - `color` (`list of int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxDrawText` no domínio `GfxPrimitivesContract`.

### 4.8 Contrato `GfxStateContract` (`GfxState.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `gfxInitContext` | `op gfxInitContext (as int64: width, as int64: height, as string: title) as map` | `map` |
| `gfxCloseContext` | `op gfxCloseContext (as map: ctx) as map` | `map` |
| `gfxContextShouldClose` | `op gfxContextShouldClose (as map: ctx) as bool` | `bool` |
| `gfxContextWidth` | `op gfxContextWidth (as map: ctx) as int64` | `int64` |
| `gfxContextHeight` | `op gfxContextHeight (as map: ctx) as int64` | `int64` |
| `gfxContextTitle` | `op gfxContextTitle (as map: ctx) as string` | `string` |
| `gfxContextSetFps` | `op gfxContextSetFps (as map: ctx, as int64: fps) as map` | `map` |
| `gfxContextGetFps` | `op gfxContextGetFps (as map: ctx) as int64` | `int64` |
| `gfxContextDrawCalls` | `op gfxContextDrawCalls (as map: ctx) as int64` | `int64` |
| `gfxContextResetDrawCalls` | `op gfxContextResetDrawCalls (as map: ctx) as map` | `map` |
| `gfxCheckInBounds` | `op gfxCheckInBounds (as float64: x, as float64: y, as float64: w, as float64: h, as int64: screen_w, as int64: screen_h) as bool` | `bool` |
| `gfxBindNativeWindow` | `op gfxBindNativeWindow (as map: ctx, as int64: win_id) as map` | `map` |
| `gfxGetNativeWindow` | `op gfxGetNativeWindow (as map: ctx) as int64` | `int64` |
| `gfxPresentFrame` | `op gfxPresentFrame (as map: ctx) as bool` | `bool` |
| `gfxPollNativeEvents` | `op gfxPollNativeEvents (as map: ctx) as int64` | `int64` |
| `gfxContextWait` | `op gfxContextWait (as map: ctx, as int64: ms) as bool` | `bool` |

#### Ficha Técnica das Operações:

##### `op gfxInitContext`
```flux
op gfxInitContext (as int64: width, as int64: height, as string: title) as map
```
- **Parâmetros**:
  - `width` (`int64`): Parâmetro de entrada para processamento da operação.
  - `height` (`int64`): Parâmetro de entrada para processamento da operação.
  - `title` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxInitContext` no domínio `GfxStateContract`.

##### `op gfxCloseContext`
```flux
op gfxCloseContext (as map: ctx) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxCloseContext` no domínio `GfxStateContract`.

##### `op gfxContextShouldClose`
```flux
op gfxContextShouldClose (as map: ctx) as bool
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxContextShouldClose` no domínio `GfxStateContract`.

##### `op gfxContextWidth`
```flux
op gfxContextWidth (as map: ctx) as int64
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxContextWidth` no domínio `GfxStateContract`.

##### `op gfxContextHeight`
```flux
op gfxContextHeight (as map: ctx) as int64
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxContextHeight` no domínio `GfxStateContract`.

##### `op gfxContextTitle`
```flux
op gfxContextTitle (as map: ctx) as string
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxContextTitle` no domínio `GfxStateContract`.

##### `op gfxContextSetFps`
```flux
op gfxContextSetFps (as map: ctx, as int64: fps) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `fps` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxContextSetFps` no domínio `GfxStateContract`.

##### `op gfxContextGetFps`
```flux
op gfxContextGetFps (as map: ctx) as int64
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxContextGetFps` no domínio `GfxStateContract`.

##### `op gfxContextDrawCalls`
```flux
op gfxContextDrawCalls (as map: ctx) as int64
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxContextDrawCalls` no domínio `GfxStateContract`.

##### `op gfxContextResetDrawCalls`
```flux
op gfxContextResetDrawCalls (as map: ctx) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxContextResetDrawCalls` no domínio `GfxStateContract`.

##### `op gfxCheckInBounds`
```flux
op gfxCheckInBounds (as float64: x, as float64: y, as float64: w, as float64: h, as int64: screen_w, as int64: screen_h) as bool
```
- **Parâmetros**:
  - `x` (`float64`): Parâmetro de entrada para processamento da operação.
  - `y` (`float64`): Parâmetro de entrada para processamento da operação.
  - `w` (`float64`): Parâmetro de entrada para processamento da operação.
  - `h` (`float64`): Parâmetro de entrada para processamento da operação.
  - `screen_w` (`int64`): Parâmetro de entrada para processamento da operação.
  - `screen_h` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxCheckInBounds` no domínio `GfxStateContract`.

##### `op gfxBindNativeWindow`
```flux
op gfxBindNativeWindow (as map: ctx, as int64: win_id) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `win_id` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxBindNativeWindow` no domínio `GfxStateContract`.

##### `op gfxGetNativeWindow`
```flux
op gfxGetNativeWindow (as map: ctx) as int64
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxGetNativeWindow` no domínio `GfxStateContract`.

##### `op gfxPresentFrame`
```flux
op gfxPresentFrame (as map: ctx) as bool
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxPresentFrame` no domínio `GfxStateContract`.

##### `op gfxPollNativeEvents`
```flux
op gfxPollNativeEvents (as map: ctx) as int64
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxPollNativeEvents` no domínio `GfxStateContract`.

##### `op gfxContextWait`
```flux
op gfxContextWait (as map: ctx, as int64: ms) as bool
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `ms` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxContextWait` no domínio `GfxStateContract`.

### 4.9 Contrato `GfxTextureContract` (`GfxTexture.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `gfxTextureNew` | `op gfxTextureNew (as int64: width, as int64: height) as map` | `map` |
| `gfxTextureGetWidth` | `op gfxTextureGetWidth (as map: texture) as int64` | `int64` |
| `gfxTextureGetHeight` | `op gfxTextureGetHeight (as map: texture) as int64` | `int64` |
| `gfxTextureIsLoaded` | `op gfxTextureIsLoaded (as map: texture) as bool` | `bool` |
| `gfxDrawTexture` | `op gfxDrawTexture (as map: ctx, as map: texture, as float64: x, as float64: y) as map` | `map` |
| `gfxDrawTexturePro` | `op gfxDrawTexturePro (as map: ctx, as map: texture, as float64: sx, as float64: sy, as float64: sw, as float64: sh, as float64: dx, as float64: dy, as float64: dw, as float64: dh, as float64: rotation_deg) as map` | `map` |

#### Ficha Técnica das Operações:

##### `op gfxTextureNew`
```flux
op gfxTextureNew (as int64: width, as int64: height) as map
```
- **Parâmetros**:
  - `width` (`int64`): Parâmetro de entrada para processamento da operação.
  - `height` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxTextureNew` no domínio `GfxTextureContract`.

##### `op gfxTextureGetWidth`
```flux
op gfxTextureGetWidth (as map: texture) as int64
```
- **Parâmetros**:
  - `texture` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxTextureGetWidth` no domínio `GfxTextureContract`.

##### `op gfxTextureGetHeight`
```flux
op gfxTextureGetHeight (as map: texture) as int64
```
- **Parâmetros**:
  - `texture` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxTextureGetHeight` no domínio `GfxTextureContract`.

##### `op gfxTextureIsLoaded`
```flux
op gfxTextureIsLoaded (as map: texture) as bool
```
- **Parâmetros**:
  - `texture` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxTextureIsLoaded` no domínio `GfxTextureContract`.

##### `op gfxDrawTexture`
```flux
op gfxDrawTexture (as map: ctx, as map: texture, as float64: x, as float64: y) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `texture` (`map`): Parâmetro de entrada para processamento da operação.
  - `x` (`float64`): Parâmetro de entrada para processamento da operação.
  - `y` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxDrawTexture` no domínio `GfxTextureContract`.

##### `op gfxDrawTexturePro`
```flux
op gfxDrawTexturePro (as map: ctx, as map: texture, as float64: sx, as float64: sy, as float64: sw, as float64: sh, as float64: dx, as float64: dy, as float64: dw, as float64: dh, as float64: rotation_deg) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `texture` (`map`): Parâmetro de entrada para processamento da operação.
  - `sx` (`float64`): Parâmetro de entrada para processamento da operação.
  - `sy` (`float64`): Parâmetro de entrada para processamento da operação.
  - `sw` (`float64`): Parâmetro de entrada para processamento da operação.
  - `sh` (`float64`): Parâmetro de entrada para processamento da operação.
  - `dx` (`float64`): Parâmetro de entrada para processamento da operação.
  - `dy` (`float64`): Parâmetro de entrada para processamento da operação.
  - `dw` (`float64`): Parâmetro de entrada para processamento da operação.
  - `dh` (`float64`): Parâmetro de entrada para processamento da operação.
  - `rotation_deg` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `gfxDrawTexturePro` no domínio `GfxTextureContract`.

---

## 5. Exemplos Canônicos de Uso em TheFlux

O exemplo a seguir demonstra a importação e o consumo prático da biblioteca:

```flux
# Exemplo Canônico de Consumo da GfxStdLib
use GfxStdLib

program (ExemploGfxStdLib) {
      println("==================================================")
      println("  Demonstracao da Standard Library: GfxStdLib")
      println("==================================================")

      # Chamada da operacao canônica
      mut as data: resultado = GfxStdLib::gfxColorRgb(255, 128, 0)
      println("Resultado obtido: " + resultado)

      println("Demonstracao concluida com sucesso.")
}
```

---

> [!TIP]
> Para consultar a visão arquitetural unificada de todas as bibliotecas, consulte o documento principal [StdLibs.md](../StdLibs.md).
