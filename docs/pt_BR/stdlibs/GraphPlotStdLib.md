# 📚 `GraphPlotStdLib` — Plotagem de Gráficos Estatísticos, Científicos e Engenharia

> **Pilar Arquitetural**: Pilar 3 (Matemática & Gráficos)  
> **Status**: ✅ Homologado com 100% de Paridade nos 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Arquivo Mestre**: `stdlib/GraphPlotStdLib/GraphPlotStdLib.fdsl`  
> **Modo de Importação**: `use GraphPlotStdLib` ou `use GraphPlotStdLib::<Modulo>::<operacao>`

---

## 1. Visão Geral e Funcionalidades

A biblioteca padrão **`GraphPlotStdLib`** integra o ecossistema oficial da linguagem TheFlux, fornecendo suporte de nível de sistema e algoritmos nativos certificados.

Motor de visualização de dados científicos e analíticos: geração de gráficos de linhas, dispersão, barras, histogramas, diagramas de controle de qualidade estatística (Shewhart), coordenadas polares, radar e exportação em SVG/vetorial.

### 1.1 Características e Princípios de Design
- **Compilação e Fusão Estática**: Todos os módulos de domínio são fundidos no agente unificado `GraphPlotStdLib` em tempo de compilação, sem sobrecarga (*overhead*) de despacho indireto.
- **Isolamento e Segurança**: As operações verificam limites operacionais e utilizam despacho por contratos formais rigorosos.
- **Compatibilidade Multi-Backend**: Execução bit-a-bit idêntica em interpretador (`in`), bytecode (`vm`, `vmr`), nativo AOT (`llvm`) e WebAssembly (`wat`, `wasm`).

---

## 2. Estrutura Modular e Contratos

A biblioteca é composta por **12 módulos de domínio** e declara **72 operações públicas**:

| Arquivo de Domínio | Contrato Formal | Responsabilidade Principal | Qtd. Ops |
|---|---|---|:---:|
| `PlotComposition.fdsl` | `PlotCompositionContract` | Domínio especializado de `PlotComposition` | 8 |
| `PlotContext.fdsl` | `PlotContextContract` | Domínio especializado de `PlotContext` | 13 |
| `PlotDistribution.fdsl` | `PlotDistributionContract` | Domínio especializado de `PlotDistribution` | 7 |
| `PlotEngineeringControl.fdsl` | `PlotEngineeringControlContract` | Domínio especializado de `PlotEngineeringControl` | 10 |
| `PlotExport.fdsl` | `PlotExportContract` | Domínio especializado de `PlotExport` | 2 |
| `PlotGeometryCoord.fdsl` | `PlotGeometryCoordContract` | Domínio especializado de `PlotGeometryCoord` | 2 |
| `PlotRelation.fdsl` | `PlotRelationContract` | Domínio especializado de `PlotRelation` | 6 |
| `PlotRender.fdsl` | `PlotRenderContract` | Domínio especializado de `PlotRender` | 4 |
| `PlotSpecialMath.fdsl` | `PlotSpecialMathContract` | Domínio especializado de `PlotSpecialMath` | 6 |
| `PlotSurfaceField.fdsl` | `PlotSurfaceFieldContract` | Domínio especializado de `PlotSurfaceField` | 7 |
| `PlotTheme.fdsl` | `PlotThemeContract` | Domínio especializado de `PlotTheme` | 4 |
| `PlotTransform.fdsl` | `PlotTransformContract` | Domínio especializado de `PlotTransform` | 3 |

---

## 3. Tipos, Estruturas e Enumerações Públicas

A biblioteca `GraphPlotStdLib` opera diretamente com os tipos nativos e primitivos da linguagem TheFlux (`string`, `int64`, `float64`, `bool`, `list of data`, etc.), sem exigir tipos compostos adicionais.

---

## 4. Catálogo Detalhado de Operações por Domínio

### 4.1 Contrato `PlotCompositionContract` (`PlotComposition.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `plotPie` | `op plotPie (as map: ctx, as list of float64: values, as list of string: labels) as map` | `map` |
| `plotDonut` | `op plotDonut (as map: ctx, as list of float64: values, as list of string: labels, as float64: hole_ratio) as map` | `map` |
| `plotGauge` | `op plotGauge (as map: ctx, as float64: value, as float64: min_val, as float64: max_val, as string: label) as map` | `map` |
| `plotTernary` | `op plotTernary (as map: ctx, as list of float64: as_comp, as list of float64: bs_comp, as list of float64: cs_comp) as map` | `map` |
| `plotStackedBar` | `op plotStackedBar (as map: ctx, as list of data: series_matrix, as list of string: group_labels) as map` | `map` |
| `plotStackedArea` | `op plotStackedArea (as map: ctx, as list of float64: xs, as list of data: series_matrix) as map` | `map` |
| `plotTreemap` | `op plotTreemap (as map: ctx, as list of float64: values, as list of string: labels) as map` | `map` |
| `plotWaffle` | `op plotWaffle (as map: ctx, as list of float64: proportions, as list of string: labels) as map` | `map` |

#### Ficha Técnica das Operações:

##### `op plotPie`
```flux
op plotPie (as map: ctx, as list of float64: values, as list of string: labels) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `values` (`list of float64`): Parâmetro de entrada para processamento da operação.
  - `labels` (`list of string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotPie` no domínio `PlotCompositionContract`.

##### `op plotDonut`
```flux
op plotDonut (as map: ctx, as list of float64: values, as list of string: labels, as float64: hole_ratio) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `values` (`list of float64`): Parâmetro de entrada para processamento da operação.
  - `labels` (`list of string`): Parâmetro de entrada para processamento da operação.
  - `hole_ratio` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotDonut` no domínio `PlotCompositionContract`.

##### `op plotGauge`
```flux
op plotGauge (as map: ctx, as float64: value, as float64: min_val, as float64: max_val, as string: label) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `value` (`float64`): Parâmetro de entrada para processamento da operação.
  - `min_val` (`float64`): Parâmetro de entrada para processamento da operação.
  - `max_val` (`float64`): Parâmetro de entrada para processamento da operação.
  - `label` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotGauge` no domínio `PlotCompositionContract`.

##### `op plotTernary`
```flux
op plotTernary (as map: ctx, as list of float64: as_comp, as list of float64: bs_comp, as list of float64: cs_comp) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `as_comp` (`list of float64`): Parâmetro de entrada para processamento da operação.
  - `bs_comp` (`list of float64`): Parâmetro de entrada para processamento da operação.
  - `cs_comp` (`list of float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotTernary` no domínio `PlotCompositionContract`.

##### `op plotStackedBar`
```flux
op plotStackedBar (as map: ctx, as list of data: series_matrix, as list of string: group_labels) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `series_matrix` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `group_labels` (`list of string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotStackedBar` no domínio `PlotCompositionContract`.

##### `op plotStackedArea`
```flux
op plotStackedArea (as map: ctx, as list of float64: xs, as list of data: series_matrix) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `xs` (`list of float64`): Parâmetro de entrada para processamento da operação.
  - `series_matrix` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotStackedArea` no domínio `PlotCompositionContract`.

##### `op plotTreemap`
```flux
op plotTreemap (as map: ctx, as list of float64: values, as list of string: labels) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `values` (`list of float64`): Parâmetro de entrada para processamento da operação.
  - `labels` (`list of string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotTreemap` no domínio `PlotCompositionContract`.

##### `op plotWaffle`
```flux
op plotWaffle (as map: ctx, as list of float64: proportions, as list of string: labels) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `proportions` (`list of float64`): Parâmetro de entrada para processamento da operação.
  - `labels` (`list of string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotWaffle` no domínio `PlotCompositionContract`.

### 4.2 Contrato `PlotContextContract` (`PlotContext.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `plotCreate` | `op plotCreate (as int64: width, as int64: height, as string: title) as map` | `map` |
| `plotClose` | `op plotClose (as map: ctx) as map` | `map` |
| `plotSetViewport` | `op plotSetViewport (as map: ctx, as int64: x, as int64: y, as int64: w, as int64: h) as map` | `map` |
| `plotSetMargins` | `op plotSetMargins (as map: ctx, as int64: top, as int64: right, as int64: bottom, as int64: left) as map` | `map` |
| `plotSetCoordSystem` | `op plotSetCoordSystem (as map: ctx, as int64: coord_sys) as map` | `map` |
| `plotSetCamera` | `op plotSetCamera (as map: ctx, as int64: cam_type, as float64: fov) as map` | `map` |
| `plotSetScaleType` | `op plotSetScaleType (as map: ctx, as int64: scale_type) as map` | `map` |
| `plotSetColorMap` | `op plotSetColorMap (as map: ctx, as int64: cmap) as map` | `map` |
| `plotShowAxes` | `op plotShowAxes (as map: ctx, as bool: show) as map` | `map` |
| `plotShowGrid` | `op plotShowGrid (as map: ctx, as bool: show) as map` | `map` |
| `plotShowLegend` | `op plotShowLegend (as map: ctx, as bool: show) as map` | `map` |
| `plotBindWindow` | `op plotBindWindow (as map: ctx, as int64: win_id) as map` | `map` |
| `plotGetWindow` | `op plotGetWindow (as map: ctx) as int64` | `int64` |

#### Ficha Técnica das Operações:

##### `op plotCreate`
```flux
op plotCreate (as int64: width, as int64: height, as string: title) as map
```
- **Parâmetros**:
  - `width` (`int64`): Parâmetro de entrada para processamento da operação.
  - `height` (`int64`): Parâmetro de entrada para processamento da operação.
  - `title` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotCreate` no domínio `PlotContextContract`.

##### `op plotClose`
```flux
op plotClose (as map: ctx) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotClose` no domínio `PlotContextContract`.

##### `op plotSetViewport`
```flux
op plotSetViewport (as map: ctx, as int64: x, as int64: y, as int64: w, as int64: h) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `x` (`int64`): Parâmetro de entrada para processamento da operação.
  - `y` (`int64`): Parâmetro de entrada para processamento da operação.
  - `w` (`int64`): Parâmetro de entrada para processamento da operação.
  - `h` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotSetViewport` no domínio `PlotContextContract`.

##### `op plotSetMargins`
```flux
op plotSetMargins (as map: ctx, as int64: top, as int64: right, as int64: bottom, as int64: left) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `top` (`int64`): Parâmetro de entrada para processamento da operação.
  - `right` (`int64`): Parâmetro de entrada para processamento da operação.
  - `bottom` (`int64`): Parâmetro de entrada para processamento da operação.
  - `left` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotSetMargins` no domínio `PlotContextContract`.

##### `op plotSetCoordSystem`
```flux
op plotSetCoordSystem (as map: ctx, as int64: coord_sys) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `coord_sys` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotSetCoordSystem` no domínio `PlotContextContract`.

##### `op plotSetCamera`
```flux
op plotSetCamera (as map: ctx, as int64: cam_type, as float64: fov) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `cam_type` (`int64`): Parâmetro de entrada para processamento da operação.
  - `fov` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotSetCamera` no domínio `PlotContextContract`.

##### `op plotSetScaleType`
```flux
op plotSetScaleType (as map: ctx, as int64: scale_type) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `scale_type` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotSetScaleType` no domínio `PlotContextContract`.

##### `op plotSetColorMap`
```flux
op plotSetColorMap (as map: ctx, as int64: cmap) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `cmap` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotSetColorMap` no domínio `PlotContextContract`.

##### `op plotShowAxes`
```flux
op plotShowAxes (as map: ctx, as bool: show) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `show` (`bool`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotShowAxes` no domínio `PlotContextContract`.

##### `op plotShowGrid`
```flux
op plotShowGrid (as map: ctx, as bool: show) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `show` (`bool`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotShowGrid` no domínio `PlotContextContract`.

##### `op plotShowLegend`
```flux
op plotShowLegend (as map: ctx, as bool: show) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `show` (`bool`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotShowLegend` no domínio `PlotContextContract`.

##### `op plotBindWindow`
```flux
op plotBindWindow (as map: ctx, as int64: win_id) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `win_id` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotBindWindow` no domínio `PlotContextContract`.

##### `op plotGetWindow`
```flux
op plotGetWindow (as map: ctx) as int64
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotGetWindow` no domínio `PlotContextContract`.

### 4.3 Contrato `PlotDistributionContract` (`PlotDistribution.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `plotHistogram` | `op plotHistogram (as map: ctx, as list of float64: data_vals, as int64: n_bins) as map` | `map` |
| `plotKde` | `op plotKde (as map: ctx, as list of float64: data_vals, as float64: bandwidth) as map` | `map` |
| `plotBoxplot` | `op plotBoxplot (as map: ctx, as list of float64: data_vals, as float64: center_x, as float64: width) as map` | `map` |
| `plotViolin` | `op plotViolin (as map: ctx, as list of float64: data_vals, as float64: center_x, as float64: width) as map` | `map` |
| `plotStrip` | `op plotStrip (as map: ctx, as list of float64: data_vals, as float64: center_x) as map` | `map` |
| `plotOgive` | `op plotOgive (as map: ctx, as list of float64: data_vals) as map` | `map` |
| `plotQqPlot` | `op plotQqPlot (as map: ctx, as list of float64: data_vals) as map` | `map` |

#### Ficha Técnica das Operações:

##### `op plotHistogram`
```flux
op plotHistogram (as map: ctx, as list of float64: data_vals, as int64: n_bins) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `data_vals` (`list of float64`): Parâmetro de entrada para processamento da operação.
  - `n_bins` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotHistogram` no domínio `PlotDistributionContract`.

##### `op plotKde`
```flux
op plotKde (as map: ctx, as list of float64: data_vals, as float64: bandwidth) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `data_vals` (`list of float64`): Parâmetro de entrada para processamento da operação.
  - `bandwidth` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotKde` no domínio `PlotDistributionContract`.

##### `op plotBoxplot`
```flux
op plotBoxplot (as map: ctx, as list of float64: data_vals, as float64: center_x, as float64: width) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `data_vals` (`list of float64`): Parâmetro de entrada para processamento da operação.
  - `center_x` (`float64`): Parâmetro de entrada para processamento da operação.
  - `width` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotBoxplot` no domínio `PlotDistributionContract`.

##### `op plotViolin`
```flux
op plotViolin (as map: ctx, as list of float64: data_vals, as float64: center_x, as float64: width) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `data_vals` (`list of float64`): Parâmetro de entrada para processamento da operação.
  - `center_x` (`float64`): Parâmetro de entrada para processamento da operação.
  - `width` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotViolin` no domínio `PlotDistributionContract`.

##### `op plotStrip`
```flux
op plotStrip (as map: ctx, as list of float64: data_vals, as float64: center_x) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `data_vals` (`list of float64`): Parâmetro de entrada para processamento da operação.
  - `center_x` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotStrip` no domínio `PlotDistributionContract`.

##### `op plotOgive`
```flux
op plotOgive (as map: ctx, as list of float64: data_vals) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `data_vals` (`list of float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotOgive` no domínio `PlotDistributionContract`.

##### `op plotQqPlot`
```flux
op plotQqPlot (as map: ctx, as list of float64: data_vals) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `data_vals` (`list of float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotQqPlot` no domínio `PlotDistributionContract`.

### 4.4 Contrato `PlotEngineeringControlContract` (`PlotEngineeringControl.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `plotBode` | `op plotBode (as map: ctx, as list of float64: omegas, as list of float64: mag_db, as list of float64: phase_deg) as map` | `map` |
| `plotNyquist` | `op plotNyquist (as map: ctx, as list of float64: real_parts, as list of float64: imag_parts) as map` | `map` |
| `plotNichols` | `op plotNichols (as map: ctx, as list of float64: phase_deg, as list of float64: mag_db) as map` | `map` |
| `plotSmithChart` | `op plotSmithChart (as map: ctx, as list of float64: gamma_re, as list of float64: gamma_im) as map` | `map` |
| `plotKaplanMeier` | `op plotKaplanMeier (as map: ctx, as list of float64: times, as list of int64: events) as map` | `map` |
| `plotRocCurve` | `op plotRocCurve (as map: ctx, as list of float64: fpr, as list of float64: tpr) as map` | `map` |
| `plotPareto` | `op plotPareto (as map: ctx, as list of float64: frequencies, as list of string: categories) as map` | `map` |
| `plotRadar` | `op plotRadar (as map: ctx, as list of float64: values, as list of string: axes_labels) as map` | `map` |
| `plotCoxcomb` | `op plotCoxcomb (as map: ctx, as list of float64: values, as list of string: sector_labels) as map` | `map` |
| `plotUxHeatmap` | `op plotUxHeatmap (as map: ctx, as list of float64: click_xs, as list of float64: click_ys, as list of float64: weights) as map` | `map` |

#### Ficha Técnica das Operações:

##### `op plotBode`
```flux
op plotBode (as map: ctx, as list of float64: omegas, as list of float64: mag_db, as list of float64: phase_deg) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `omegas` (`list of float64`): Parâmetro de entrada para processamento da operação.
  - `mag_db` (`list of float64`): Parâmetro de entrada para processamento da operação.
  - `phase_deg` (`list of float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotBode` no domínio `PlotEngineeringControlContract`.

##### `op plotNyquist`
```flux
op plotNyquist (as map: ctx, as list of float64: real_parts, as list of float64: imag_parts) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `real_parts` (`list of float64`): Parâmetro de entrada para processamento da operação.
  - `imag_parts` (`list of float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotNyquist` no domínio `PlotEngineeringControlContract`.

##### `op plotNichols`
```flux
op plotNichols (as map: ctx, as list of float64: phase_deg, as list of float64: mag_db) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `phase_deg` (`list of float64`): Parâmetro de entrada para processamento da operação.
  - `mag_db` (`list of float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotNichols` no domínio `PlotEngineeringControlContract`.

##### `op plotSmithChart`
```flux
op plotSmithChart (as map: ctx, as list of float64: gamma_re, as list of float64: gamma_im) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `gamma_re` (`list of float64`): Parâmetro de entrada para processamento da operação.
  - `gamma_im` (`list of float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotSmithChart` no domínio `PlotEngineeringControlContract`.

##### `op plotKaplanMeier`
```flux
op plotKaplanMeier (as map: ctx, as list of float64: times, as list of int64: events) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `times` (`list of float64`): Parâmetro de entrada para processamento da operação.
  - `events` (`list of int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotKaplanMeier` no domínio `PlotEngineeringControlContract`.

##### `op plotRocCurve`
```flux
op plotRocCurve (as map: ctx, as list of float64: fpr, as list of float64: tpr) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `fpr` (`list of float64`): Parâmetro de entrada para processamento da operação.
  - `tpr` (`list of float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotRocCurve` no domínio `PlotEngineeringControlContract`.

##### `op plotPareto`
```flux
op plotPareto (as map: ctx, as list of float64: frequencies, as list of string: categories) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `frequencies` (`list of float64`): Parâmetro de entrada para processamento da operação.
  - `categories` (`list of string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotPareto` no domínio `PlotEngineeringControlContract`.

##### `op plotRadar`
```flux
op plotRadar (as map: ctx, as list of float64: values, as list of string: axes_labels) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `values` (`list of float64`): Parâmetro de entrada para processamento da operação.
  - `axes_labels` (`list of string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotRadar` no domínio `PlotEngineeringControlContract`.

##### `op plotCoxcomb`
```flux
op plotCoxcomb (as map: ctx, as list of float64: values, as list of string: sector_labels) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `values` (`list of float64`): Parâmetro de entrada para processamento da operação.
  - `sector_labels` (`list of string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotCoxcomb` no domínio `PlotEngineeringControlContract`.

##### `op plotUxHeatmap`
```flux
op plotUxHeatmap (as map: ctx, as list of float64: click_xs, as list of float64: click_ys, as list of float64: weights) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `click_xs` (`list of float64`): Parâmetro de entrada para processamento da operação.
  - `click_ys` (`list of float64`): Parâmetro de entrada para processamento da operação.
  - `weights` (`list of float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotUxHeatmap` no domínio `PlotEngineeringControlContract`.

### 4.5 Contrato `PlotExportContract` (`PlotExport.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `plotExportHtml` | `op plotExportHtml (as map: ctx, as string: path) as bool` | `bool` |
| `plotExportSvg` | `op plotExportSvg (as map: ctx, as string: path) as bool` | `bool` |

#### Ficha Técnica das Operações:

##### `op plotExportHtml`
```flux
op plotExportHtml (as map: ctx, as string: path) as bool
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `path` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotExportHtml` no domínio `PlotExportContract`.

##### `op plotExportSvg`
```flux
op plotExportSvg (as map: ctx, as string: path) as bool
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `path` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotExportSvg` no domínio `PlotExportContract`.

### 4.6 Contrato `PlotGeometryCoordContract` (`PlotGeometryCoord.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `plotCurvilinearGrid` | `op plotCurvilinearGrid (as map: ctx, as int64: coord_sys, as int64: divisions) as map` | `map` |
| `plotCurvilinearCurve` | `op plotCurvilinearCurve (as map: ctx, as int64: coord_sys, as list of float64: us, as list of float64: vs, as list of float64: ws, as list of int64: color) as map` | `map` |

#### Ficha Técnica das Operações:

##### `op plotCurvilinearGrid`
```flux
op plotCurvilinearGrid (as map: ctx, as int64: coord_sys, as int64: divisions) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `coord_sys` (`int64`): Parâmetro de entrada para processamento da operação.
  - `divisions` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotCurvilinearGrid` no domínio `PlotGeometryCoordContract`.

##### `op plotCurvilinearCurve`
```flux
op plotCurvilinearCurve (as map: ctx, as int64: coord_sys, as list of float64: us, as list of float64: vs, as list of float64: ws, as list of int64: color) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `coord_sys` (`int64`): Parâmetro de entrada para processamento da operação.
  - `us` (`list of float64`): Parâmetro de entrada para processamento da operação.
  - `vs` (`list of float64`): Parâmetro de entrada para processamento da operação.
  - `ws` (`list of float64`): Parâmetro de entrada para processamento da operação.
  - `color` (`list of int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotCurvilinearCurve` no domínio `PlotGeometryCoordContract`.

### 4.7 Contrato `PlotRelationContract` (`PlotRelation.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `plotScatter` | `op plotScatter (as map: ctx, as list of float64: xs, as list of float64: ys, as list of int64: color) as map` | `map` |
| `plotLine` | `op plotLine (as map: ctx, as list of float64: xs, as list of float64: ys, as list of int64: color) as map` | `map` |
| `plotBubble` | `op plotBubble (as map: ctx, as list of float64: xs, as list of float64: ys, as list of float64: sizes, as list of int64: color) as map` | `map` |
| `plotParallelCoords` | `op plotParallelCoords (as map: ctx, as list of data: dimensions, as list of data: records) as map` | `map` |
| `plotCorrelationMatrix` | `op plotCorrelationMatrix (as map: ctx, as list of data: matrix_rows, as list of string: labels) as map` | `map` |
| `plotHexbin` | `op plotHexbin (as map: ctx, as list of float64: xs, as list of float64: ys, as int64: grid_size) as map` | `map` |

#### Ficha Técnica das Operações:

##### `op plotScatter`
```flux
op plotScatter (as map: ctx, as list of float64: xs, as list of float64: ys, as list of int64: color) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `xs` (`list of float64`): Parâmetro de entrada para processamento da operação.
  - `ys` (`list of float64`): Parâmetro de entrada para processamento da operação.
  - `color` (`list of int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotScatter` no domínio `PlotRelationContract`.

##### `op plotLine`
```flux
op plotLine (as map: ctx, as list of float64: xs, as list of float64: ys, as list of int64: color) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `xs` (`list of float64`): Parâmetro de entrada para processamento da operação.
  - `ys` (`list of float64`): Parâmetro de entrada para processamento da operação.
  - `color` (`list of int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotLine` no domínio `PlotRelationContract`.

##### `op plotBubble`
```flux
op plotBubble (as map: ctx, as list of float64: xs, as list of float64: ys, as list of float64: sizes, as list of int64: color) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `xs` (`list of float64`): Parâmetro de entrada para processamento da operação.
  - `ys` (`list of float64`): Parâmetro de entrada para processamento da operação.
  - `sizes` (`list of float64`): Parâmetro de entrada para processamento da operação.
  - `color` (`list of int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotBubble` no domínio `PlotRelationContract`.

##### `op plotParallelCoords`
```flux
op plotParallelCoords (as map: ctx, as list of data: dimensions, as list of data: records) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `dimensions` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `records` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotParallelCoords` no domínio `PlotRelationContract`.

##### `op plotCorrelationMatrix`
```flux
op plotCorrelationMatrix (as map: ctx, as list of data: matrix_rows, as list of string: labels) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `matrix_rows` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `labels` (`list of string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotCorrelationMatrix` no domínio `PlotRelationContract`.

##### `op plotHexbin`
```flux
op plotHexbin (as map: ctx, as list of float64: xs, as list of float64: ys, as int64: grid_size) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `xs` (`list of float64`): Parâmetro de entrada para processamento da operação.
  - `ys` (`list of float64`): Parâmetro de entrada para processamento da operação.
  - `grid_size` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotHexbin` no domínio `PlotRelationContract`.

### 4.8 Contrato `PlotRenderContract` (`PlotRender.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `plotRender` | `op plotRender (as map: ctx) as map` | `map` |
| `plotPresent` | `op plotPresent (as map: ctx) as bool` | `bool` |
| `plotShow` | `op plotShow (as map: ctx, as int64: ms) as bool` | `bool` |
| `plotWait` | `op plotWait (as map: ctx) as bool` | `bool` |

#### Ficha Técnica das Operações:

##### `op plotRender`
```flux
op plotRender (as map: ctx) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotRender` no domínio `PlotRenderContract`.

##### `op plotPresent`
```flux
op plotPresent (as map: ctx) as bool
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotPresent` no domínio `PlotRenderContract`.

##### `op plotShow`
```flux
op plotShow (as map: ctx, as int64: ms) as bool
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `ms` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotShow` no domínio `PlotRenderContract`.

##### `op plotWait`
```flux
op plotWait (as map: ctx) as bool
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotWait` no domínio `PlotRenderContract`.

### 4.9 Contrato `PlotSpecialMathContract` (`PlotSpecialMath.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `plotParametric2D` | `op plotParametric2D (as map: ctx, as list of float64: xs, as list of float64: ys) as map` | `map` |
| `plotParametric3D` | `op plotParametric3D (as map: ctx, as list of float64: xs, as list of float64: ys, as list of float64: zs) as map` | `map` |
| `plotBifurcation` | `op plotBifurcation (as map: ctx, as float64: r_min, as float64: r_max, as int64: n_points) as map` | `map` |
| `plotPhaseSpace` | `op plotPhaseSpace (as map: ctx, as list of float64: qs, as list of float64: ps) as map` | `map` |
| `plotNetworkGraph` | `op plotNetworkGraph (as map: ctx, as list of data: nodes, as list of data: edges) as map` | `map` |
| `plotVenn` | `op plotVenn (as map: ctx, as int64: set_count, as list of float64: subset_sizes) as map` | `map` |

#### Ficha Técnica das Operações:

##### `op plotParametric2D`
```flux
op plotParametric2D (as map: ctx, as list of float64: xs, as list of float64: ys) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `xs` (`list of float64`): Parâmetro de entrada para processamento da operação.
  - `ys` (`list of float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotParametric2D` no domínio `PlotSpecialMathContract`.

##### `op plotParametric3D`
```flux
op plotParametric3D (as map: ctx, as list of float64: xs, as list of float64: ys, as list of float64: zs) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `xs` (`list of float64`): Parâmetro de entrada para processamento da operação.
  - `ys` (`list of float64`): Parâmetro de entrada para processamento da operação.
  - `zs` (`list of float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotParametric3D` no domínio `PlotSpecialMathContract`.

##### `op plotBifurcation`
```flux
op plotBifurcation (as map: ctx, as float64: r_min, as float64: r_max, as int64: n_points) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `r_min` (`float64`): Parâmetro de entrada para processamento da operação.
  - `r_max` (`float64`): Parâmetro de entrada para processamento da operação.
  - `n_points` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotBifurcation` no domínio `PlotSpecialMathContract`.

##### `op plotPhaseSpace`
```flux
op plotPhaseSpace (as map: ctx, as list of float64: qs, as list of float64: ps) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `qs` (`list of float64`): Parâmetro de entrada para processamento da operação.
  - `ps` (`list of float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotPhaseSpace` no domínio `PlotSpecialMathContract`.

##### `op plotNetworkGraph`
```flux
op plotNetworkGraph (as map: ctx, as list of data: nodes, as list of data: edges) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `nodes` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `edges` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotNetworkGraph` no domínio `PlotSpecialMathContract`.

##### `op plotVenn`
```flux
op plotVenn (as map: ctx, as int64: set_count, as list of float64: subset_sizes) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `set_count` (`int64`): Parâmetro de entrada para processamento da operação.
  - `subset_sizes` (`list of float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotVenn` no domínio `PlotSpecialMathContract`.

### 4.10 Contrato `PlotSurfaceFieldContract` (`PlotSurfaceField.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `plotSurface3D` | `op plotSurface3D (as map: ctx, as list of data: grid_x, as list of data: grid_y, as list of data: grid_z) as map` | `map` |
| `plotMesh3D` | `op plotMesh3D (as map: ctx, as list of data: grid_x, as list of data: grid_y, as list of data: grid_z) as map` | `map` |
| `plotContour` | `op plotContour (as map: ctx, as list of data: grid_z, as int64: n_levels) as map` | `map` |
| `plotQuiver2D` | `op plotQuiver2D (as map: ctx, as list of float64: xs, as list of float64: ys, as list of float64: us, as list of float64: vs) as map` | `map` |
| `plotStreamlines` | `op plotStreamlines (as map: ctx, as list of data: grid_u, as list of data: grid_v) as map` | `map` |
| `plotScatter3D` | `op plotScatter3D (as map: ctx, as list of float64: xs, as list of float64: ys, as list of float64: zs) as map` | `map` |
| `plotTrajectory3D` | `op plotTrajectory3D (as map: ctx, as list of float64: xs, as list of float64: ys, as list of float64: zs) as map` | `map` |

#### Ficha Técnica das Operações:

##### `op plotSurface3D`
```flux
op plotSurface3D (as map: ctx, as list of data: grid_x, as list of data: grid_y, as list of data: grid_z) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `grid_x` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `grid_y` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `grid_z` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotSurface3D` no domínio `PlotSurfaceFieldContract`.

##### `op plotMesh3D`
```flux
op plotMesh3D (as map: ctx, as list of data: grid_x, as list of data: grid_y, as list of data: grid_z) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `grid_x` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `grid_y` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `grid_z` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotMesh3D` no domínio `PlotSurfaceFieldContract`.

##### `op plotContour`
```flux
op plotContour (as map: ctx, as list of data: grid_z, as int64: n_levels) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `grid_z` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `n_levels` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotContour` no domínio `PlotSurfaceFieldContract`.

##### `op plotQuiver2D`
```flux
op plotQuiver2D (as map: ctx, as list of float64: xs, as list of float64: ys, as list of float64: us, as list of float64: vs) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `xs` (`list of float64`): Parâmetro de entrada para processamento da operação.
  - `ys` (`list of float64`): Parâmetro de entrada para processamento da operação.
  - `us` (`list of float64`): Parâmetro de entrada para processamento da operação.
  - `vs` (`list of float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotQuiver2D` no domínio `PlotSurfaceFieldContract`.

##### `op plotStreamlines`
```flux
op plotStreamlines (as map: ctx, as list of data: grid_u, as list of data: grid_v) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `grid_u` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `grid_v` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotStreamlines` no domínio `PlotSurfaceFieldContract`.

##### `op plotScatter3D`
```flux
op plotScatter3D (as map: ctx, as list of float64: xs, as list of float64: ys, as list of float64: zs) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `xs` (`list of float64`): Parâmetro de entrada para processamento da operação.
  - `ys` (`list of float64`): Parâmetro de entrada para processamento da operação.
  - `zs` (`list of float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotScatter3D` no domínio `PlotSurfaceFieldContract`.

##### `op plotTrajectory3D`
```flux
op plotTrajectory3D (as map: ctx, as list of float64: xs, as list of float64: ys, as list of float64: zs) as map
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `xs` (`list of float64`): Parâmetro de entrada para processamento da operação.
  - `ys` (`list of float64`): Parâmetro de entrada para processamento da operação.
  - `zs` (`list of float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotTrajectory3D` no domínio `PlotSurfaceFieldContract`.

### 4.11 Contrato `PlotThemeContract` (`PlotTheme.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `plotThemeDark` | `op plotThemeDark () as map` | `map` |
| `plotThemeLight` | `op plotThemeLight () as map` | `map` |
| `plotThemeScientific` | `op plotThemeScientific () as map` | `map` |
| `plotGetColorMapRgb` | `op plotGetColorMapRgb (as int64: cmap, as float64: t) as list of int64` | `list of int64` |

#### Ficha Técnica das Operações:

##### `op plotThemeDark`
```flux
op plotThemeDark () as map
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotThemeDark` no domínio `PlotThemeContract`.

##### `op plotThemeLight`
```flux
op plotThemeLight () as map
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotThemeLight` no domínio `PlotThemeContract`.

##### `op plotThemeScientific`
```flux
op plotThemeScientific () as map
```
- **Parâmetros**:
  - *Nenhum (operação sem parâmetros).*
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotThemeScientific` no domínio `PlotThemeContract`.

##### `op plotGetColorMapRgb`
```flux
op plotGetColorMapRgb (as int64: cmap, as float64: t) as list of int64
```
- **Parâmetros**:
  - `cmap` (`int64`): Parâmetro de entrada para processamento da operação.
  - `t` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotGetColorMapRgb` no domínio `PlotThemeContract`.

### 4.12 Contrato `PlotTransformContract` (`PlotTransform.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `plotTransformToCartesian` | `op plotTransformToCartesian (as int64: coord_sys, as float64: u, as float64: v, as float64: w) as list of float64` | `list of float64` |
| `plotTransformFromCartesian` | `op plotTransformFromCartesian (as int64: coord_sys, as float64: x, as float64: y, as float64: z) as list of float64` | `list of float64` |
| `plotProjectToScreen` | `op plotProjectToScreen (as map: ctx, as float64: x, as float64: y, as float64: z) as list of int64` | `list of int64` |

#### Ficha Técnica das Operações:

##### `op plotTransformToCartesian`
```flux
op plotTransformToCartesian (as int64: coord_sys, as float64: u, as float64: v, as float64: w) as list of float64
```
- **Parâmetros**:
  - `coord_sys` (`int64`): Parâmetro de entrada para processamento da operação.
  - `u` (`float64`): Parâmetro de entrada para processamento da operação.
  - `v` (`float64`): Parâmetro de entrada para processamento da operação.
  - `w` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotTransformToCartesian` no domínio `PlotTransformContract`.

##### `op plotTransformFromCartesian`
```flux
op plotTransformFromCartesian (as int64: coord_sys, as float64: x, as float64: y, as float64: z) as list of float64
```
- **Parâmetros**:
  - `coord_sys` (`int64`): Parâmetro de entrada para processamento da operação.
  - `x` (`float64`): Parâmetro de entrada para processamento da operação.
  - `y` (`float64`): Parâmetro de entrada para processamento da operação.
  - `z` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of float64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotTransformFromCartesian` no domínio `PlotTransformContract`.

##### `op plotProjectToScreen`
```flux
op plotProjectToScreen (as map: ctx, as float64: x, as float64: y, as float64: z) as list of int64
```
- **Parâmetros**:
  - `ctx` (`map`): Parâmetro de entrada para processamento da operação.
  - `x` (`float64`): Parâmetro de entrada para processamento da operação.
  - `y` (`float64`): Parâmetro de entrada para processamento da operação.
  - `z` (`float64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `plotProjectToScreen` no domínio `PlotTransformContract`.

---

## 5. Exemplos Canônicos de Uso em TheFlux

O exemplo a seguir demonstra a importação e o consumo prático da biblioteca:

```flux
# Exemplo Canônico de Consumo da GraphPlotStdLib
use GraphPlotStdLib

program (ExemploGraphPlotStdLib) {
      println("==================================================")
      println("  Demonstracao da Standard Library: GraphPlotStdLib")
      println("==================================================")

      # Chamada da operacao canônica
      mut as data: resultado = GraphPlotStdLib::plotCreateContext(800, 600)
      println("Resultado obtido: " + resultado)

      println("Demonstracao concluida com sucesso.")
}
```

---

> [!TIP]
> Para consultar a visão arquitetural unificada de todas as bibliotecas, consulte o documento principal [StdLibs.md](../StdLibs.md).
