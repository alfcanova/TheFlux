# 📚 `GraphPlotStdLib` — Statistical, Scientific, and Engineering Data Plotting

> **Architectural Pillar**: Pillar 3 (Mathematics & Graphics)  
> **Status**: ✅ Certified with 100% Parity across 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Master File**: `stdlib/GraphPlotStdLib/GraphPlotStdLib.fdsl`  
> **Import Mode**: `use GraphPlotStdLib` or `use GraphPlotStdLib::<Module>::<operation>`

---

## 1. Overview and Capabilities

The **`GraphPlotStdLib`** standard library is an integral component of the official TheFlux language ecosystem, providing certified system-level algorithms and robust capabilities.

Scientific and analytical data plotting engine: line plots, scatter bubbles, bar charts, frequency distributions, statistical process control charts (Shewhart charts), polar/radar coordinates, and clean vector SVG export.

### 1.1 Key Architectural Principles and Design
- **Static Fusion and Zero-Overhead**: All domain modules are transparently fused into the `GraphPlotStdLib` unified agent at compile time, avoiding virtual dispatch penalties.
- **Safety and Isolation**: Operations strictly validate parameter bounds and guarantee predictable error semantics via contract definitions.
- **Universal Multi-Backend Parity**: Bit-for-bit identical execution guarantees across interpreter (`in`), bytecode VM (`vm`, `vmr`), native AOT LLVM (`llvm`), and WebAssembly (`wat`, `wasm`).

---

## 2. Modular Structure and Contracts

The library comprises **12 domain modules** declaring a total of **72 public operations**:

| Domain Source File | Formal Contract | Domain Responsibility | Ops Count |
|---|---|---|:---:|
| `PlotComposition.fdsl` | `PlotCompositionContract` | Specialized domain for `PlotComposition` | 8 |
| `PlotContext.fdsl` | `PlotContextContract` | Specialized domain for `PlotContext` | 13 |
| `PlotDistribution.fdsl` | `PlotDistributionContract` | Specialized domain for `PlotDistribution` | 7 |
| `PlotEngineeringControl.fdsl` | `PlotEngineeringControlContract` | Specialized domain for `PlotEngineeringControl` | 10 |
| `PlotExport.fdsl` | `PlotExportContract` | Specialized domain for `PlotExport` | 2 |
| `PlotGeometryCoord.fdsl` | `PlotGeometryCoordContract` | Specialized domain for `PlotGeometryCoord` | 2 |
| `PlotRelation.fdsl` | `PlotRelationContract` | Specialized domain for `PlotRelation` | 6 |
| `PlotRender.fdsl` | `PlotRenderContract` | Specialized domain for `PlotRender` | 4 |
| `PlotSpecialMath.fdsl` | `PlotSpecialMathContract` | Specialized domain for `PlotSpecialMath` | 6 |
| `PlotSurfaceField.fdsl` | `PlotSurfaceFieldContract` | Specialized domain for `PlotSurfaceField` | 7 |
| `PlotTheme.fdsl` | `PlotThemeContract` | Specialized domain for `PlotTheme` | 4 |
| `PlotTransform.fdsl` | `PlotTransformContract` | Specialized domain for `PlotTransform` | 3 |

---

## 3. Public Types, Structures, and Enumerations

The `GraphPlotStdLib` library operates directly on primitive native TheFlux types (`string`, `int64`, `float64`, `bool`, `list of data`, etc.) without requiring custom composite types.

---

## 4. Detailed Operations Catalog by Domain

### 4.1 Contract `PlotCompositionContract` (`PlotComposition.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `plotPie` | `op plotPie (as map: ctx, as list of float64: values, as list of string: labels) as map` | `map` |
| `plotDonut` | `op plotDonut (as map: ctx, as list of float64: values, as list of string: labels, as float64: hole_ratio) as map` | `map` |
| `plotGauge` | `op plotGauge (as map: ctx, as float64: value, as float64: min_val, as float64: max_val, as string: label) as map` | `map` |
| `plotTernary` | `op plotTernary (as map: ctx, as list of float64: as_comp, as list of float64: bs_comp, as list of float64: cs_comp) as map` | `map` |
| `plotStackedBar` | `op plotStackedBar (as map: ctx, as list of data: series_matrix, as list of string: group_labels) as map` | `map` |
| `plotStackedArea` | `op plotStackedArea (as map: ctx, as list of float64: xs, as list of data: series_matrix) as map` | `map` |
| `plotTreemap` | `op plotTreemap (as map: ctx, as list of float64: values, as list of string: labels) as map` | `map` |
| `plotWaffle` | `op plotWaffle (as map: ctx, as list of float64: proportions, as list of string: labels) as map` | `map` |

#### Operation Technical Specifications:

##### `op plotPie`
```flux
op plotPie (as map: ctx, as list of float64: values, as list of string: labels) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `values` (`list of float64`): Input argument for operation execution.
  - `labels` (`list of string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotPie` functionality within the `PlotCompositionContract` domain.

##### `op plotDonut`
```flux
op plotDonut (as map: ctx, as list of float64: values, as list of string: labels, as float64: hole_ratio) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `values` (`list of float64`): Input argument for operation execution.
  - `labels` (`list of string`): Input argument for operation execution.
  - `hole_ratio` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotDonut` functionality within the `PlotCompositionContract` domain.

##### `op plotGauge`
```flux
op plotGauge (as map: ctx, as float64: value, as float64: min_val, as float64: max_val, as string: label) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `value` (`float64`): Input argument for operation execution.
  - `min_val` (`float64`): Input argument for operation execution.
  - `max_val` (`float64`): Input argument for operation execution.
  - `label` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotGauge` functionality within the `PlotCompositionContract` domain.

##### `op plotTernary`
```flux
op plotTernary (as map: ctx, as list of float64: as_comp, as list of float64: bs_comp, as list of float64: cs_comp) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `as_comp` (`list of float64`): Input argument for operation execution.
  - `bs_comp` (`list of float64`): Input argument for operation execution.
  - `cs_comp` (`list of float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotTernary` functionality within the `PlotCompositionContract` domain.

##### `op plotStackedBar`
```flux
op plotStackedBar (as map: ctx, as list of data: series_matrix, as list of string: group_labels) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `series_matrix` (`list of data`): Input argument for operation execution.
  - `group_labels` (`list of string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotStackedBar` functionality within the `PlotCompositionContract` domain.

##### `op plotStackedArea`
```flux
op plotStackedArea (as map: ctx, as list of float64: xs, as list of data: series_matrix) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `xs` (`list of float64`): Input argument for operation execution.
  - `series_matrix` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotStackedArea` functionality within the `PlotCompositionContract` domain.

##### `op plotTreemap`
```flux
op plotTreemap (as map: ctx, as list of float64: values, as list of string: labels) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `values` (`list of float64`): Input argument for operation execution.
  - `labels` (`list of string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotTreemap` functionality within the `PlotCompositionContract` domain.

##### `op plotWaffle`
```flux
op plotWaffle (as map: ctx, as list of float64: proportions, as list of string: labels) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `proportions` (`list of float64`): Input argument for operation execution.
  - `labels` (`list of string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotWaffle` functionality within the `PlotCompositionContract` domain.

### 4.2 Contract `PlotContextContract` (`PlotContext.fdsl`)

| Operation | Formal Signature | Return Type |
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

#### Operation Technical Specifications:

##### `op plotCreate`
```flux
op plotCreate (as int64: width, as int64: height, as string: title) as map
```
- **Parameters**:
  - `width` (`int64`): Input argument for operation execution.
  - `height` (`int64`): Input argument for operation execution.
  - `title` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotCreate` functionality within the `PlotContextContract` domain.

##### `op plotClose`
```flux
op plotClose (as map: ctx) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotClose` functionality within the `PlotContextContract` domain.

##### `op plotSetViewport`
```flux
op plotSetViewport (as map: ctx, as int64: x, as int64: y, as int64: w, as int64: h) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `x` (`int64`): Input argument for operation execution.
  - `y` (`int64`): Input argument for operation execution.
  - `w` (`int64`): Input argument for operation execution.
  - `h` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotSetViewport` functionality within the `PlotContextContract` domain.

##### `op plotSetMargins`
```flux
op plotSetMargins (as map: ctx, as int64: top, as int64: right, as int64: bottom, as int64: left) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `top` (`int64`): Input argument for operation execution.
  - `right` (`int64`): Input argument for operation execution.
  - `bottom` (`int64`): Input argument for operation execution.
  - `left` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotSetMargins` functionality within the `PlotContextContract` domain.

##### `op plotSetCoordSystem`
```flux
op plotSetCoordSystem (as map: ctx, as int64: coord_sys) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `coord_sys` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotSetCoordSystem` functionality within the `PlotContextContract` domain.

##### `op plotSetCamera`
```flux
op plotSetCamera (as map: ctx, as int64: cam_type, as float64: fov) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `cam_type` (`int64`): Input argument for operation execution.
  - `fov` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotSetCamera` functionality within the `PlotContextContract` domain.

##### `op plotSetScaleType`
```flux
op plotSetScaleType (as map: ctx, as int64: scale_type) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `scale_type` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotSetScaleType` functionality within the `PlotContextContract` domain.

##### `op plotSetColorMap`
```flux
op plotSetColorMap (as map: ctx, as int64: cmap) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `cmap` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotSetColorMap` functionality within the `PlotContextContract` domain.

##### `op plotShowAxes`
```flux
op plotShowAxes (as map: ctx, as bool: show) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `show` (`bool`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotShowAxes` functionality within the `PlotContextContract` domain.

##### `op plotShowGrid`
```flux
op plotShowGrid (as map: ctx, as bool: show) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `show` (`bool`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotShowGrid` functionality within the `PlotContextContract` domain.

##### `op plotShowLegend`
```flux
op plotShowLegend (as map: ctx, as bool: show) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `show` (`bool`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotShowLegend` functionality within the `PlotContextContract` domain.

##### `op plotBindWindow`
```flux
op plotBindWindow (as map: ctx, as int64: win_id) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `win_id` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotBindWindow` functionality within the `PlotContextContract` domain.

##### `op plotGetWindow`
```flux
op plotGetWindow (as map: ctx) as int64
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotGetWindow` functionality within the `PlotContextContract` domain.

### 4.3 Contract `PlotDistributionContract` (`PlotDistribution.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `plotHistogram` | `op plotHistogram (as map: ctx, as list of float64: data_vals, as int64: n_bins) as map` | `map` |
| `plotKde` | `op plotKde (as map: ctx, as list of float64: data_vals, as float64: bandwidth) as map` | `map` |
| `plotBoxplot` | `op plotBoxplot (as map: ctx, as list of float64: data_vals, as float64: center_x, as float64: width) as map` | `map` |
| `plotViolin` | `op plotViolin (as map: ctx, as list of float64: data_vals, as float64: center_x, as float64: width) as map` | `map` |
| `plotStrip` | `op plotStrip (as map: ctx, as list of float64: data_vals, as float64: center_x) as map` | `map` |
| `plotOgive` | `op plotOgive (as map: ctx, as list of float64: data_vals) as map` | `map` |
| `plotQqPlot` | `op plotQqPlot (as map: ctx, as list of float64: data_vals) as map` | `map` |

#### Operation Technical Specifications:

##### `op plotHistogram`
```flux
op plotHistogram (as map: ctx, as list of float64: data_vals, as int64: n_bins) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `data_vals` (`list of float64`): Input argument for operation execution.
  - `n_bins` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotHistogram` functionality within the `PlotDistributionContract` domain.

##### `op plotKde`
```flux
op plotKde (as map: ctx, as list of float64: data_vals, as float64: bandwidth) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `data_vals` (`list of float64`): Input argument for operation execution.
  - `bandwidth` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotKde` functionality within the `PlotDistributionContract` domain.

##### `op plotBoxplot`
```flux
op plotBoxplot (as map: ctx, as list of float64: data_vals, as float64: center_x, as float64: width) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `data_vals` (`list of float64`): Input argument for operation execution.
  - `center_x` (`float64`): Input argument for operation execution.
  - `width` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotBoxplot` functionality within the `PlotDistributionContract` domain.

##### `op plotViolin`
```flux
op plotViolin (as map: ctx, as list of float64: data_vals, as float64: center_x, as float64: width) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `data_vals` (`list of float64`): Input argument for operation execution.
  - `center_x` (`float64`): Input argument for operation execution.
  - `width` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotViolin` functionality within the `PlotDistributionContract` domain.

##### `op plotStrip`
```flux
op plotStrip (as map: ctx, as list of float64: data_vals, as float64: center_x) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `data_vals` (`list of float64`): Input argument for operation execution.
  - `center_x` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotStrip` functionality within the `PlotDistributionContract` domain.

##### `op plotOgive`
```flux
op plotOgive (as map: ctx, as list of float64: data_vals) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `data_vals` (`list of float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotOgive` functionality within the `PlotDistributionContract` domain.

##### `op plotQqPlot`
```flux
op plotQqPlot (as map: ctx, as list of float64: data_vals) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `data_vals` (`list of float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotQqPlot` functionality within the `PlotDistributionContract` domain.

### 4.4 Contract `PlotEngineeringControlContract` (`PlotEngineeringControl.fdsl`)

| Operation | Formal Signature | Return Type |
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

#### Operation Technical Specifications:

##### `op plotBode`
```flux
op plotBode (as map: ctx, as list of float64: omegas, as list of float64: mag_db, as list of float64: phase_deg) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `omegas` (`list of float64`): Input argument for operation execution.
  - `mag_db` (`list of float64`): Input argument for operation execution.
  - `phase_deg` (`list of float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotBode` functionality within the `PlotEngineeringControlContract` domain.

##### `op plotNyquist`
```flux
op plotNyquist (as map: ctx, as list of float64: real_parts, as list of float64: imag_parts) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `real_parts` (`list of float64`): Input argument for operation execution.
  - `imag_parts` (`list of float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotNyquist` functionality within the `PlotEngineeringControlContract` domain.

##### `op plotNichols`
```flux
op plotNichols (as map: ctx, as list of float64: phase_deg, as list of float64: mag_db) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `phase_deg` (`list of float64`): Input argument for operation execution.
  - `mag_db` (`list of float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotNichols` functionality within the `PlotEngineeringControlContract` domain.

##### `op plotSmithChart`
```flux
op plotSmithChart (as map: ctx, as list of float64: gamma_re, as list of float64: gamma_im) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `gamma_re` (`list of float64`): Input argument for operation execution.
  - `gamma_im` (`list of float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotSmithChart` functionality within the `PlotEngineeringControlContract` domain.

##### `op plotKaplanMeier`
```flux
op plotKaplanMeier (as map: ctx, as list of float64: times, as list of int64: events) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `times` (`list of float64`): Input argument for operation execution.
  - `events` (`list of int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotKaplanMeier` functionality within the `PlotEngineeringControlContract` domain.

##### `op plotRocCurve`
```flux
op plotRocCurve (as map: ctx, as list of float64: fpr, as list of float64: tpr) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `fpr` (`list of float64`): Input argument for operation execution.
  - `tpr` (`list of float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotRocCurve` functionality within the `PlotEngineeringControlContract` domain.

##### `op plotPareto`
```flux
op plotPareto (as map: ctx, as list of float64: frequencies, as list of string: categories) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `frequencies` (`list of float64`): Input argument for operation execution.
  - `categories` (`list of string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotPareto` functionality within the `PlotEngineeringControlContract` domain.

##### `op plotRadar`
```flux
op plotRadar (as map: ctx, as list of float64: values, as list of string: axes_labels) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `values` (`list of float64`): Input argument for operation execution.
  - `axes_labels` (`list of string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotRadar` functionality within the `PlotEngineeringControlContract` domain.

##### `op plotCoxcomb`
```flux
op plotCoxcomb (as map: ctx, as list of float64: values, as list of string: sector_labels) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `values` (`list of float64`): Input argument for operation execution.
  - `sector_labels` (`list of string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotCoxcomb` functionality within the `PlotEngineeringControlContract` domain.

##### `op plotUxHeatmap`
```flux
op plotUxHeatmap (as map: ctx, as list of float64: click_xs, as list of float64: click_ys, as list of float64: weights) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `click_xs` (`list of float64`): Input argument for operation execution.
  - `click_ys` (`list of float64`): Input argument for operation execution.
  - `weights` (`list of float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotUxHeatmap` functionality within the `PlotEngineeringControlContract` domain.

### 4.5 Contract `PlotExportContract` (`PlotExport.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `plotExportHtml` | `op plotExportHtml (as map: ctx, as string: path) as bool` | `bool` |
| `plotExportSvg` | `op plotExportSvg (as map: ctx, as string: path) as bool` | `bool` |

#### Operation Technical Specifications:

##### `op plotExportHtml`
```flux
op plotExportHtml (as map: ctx, as string: path) as bool
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `path` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotExportHtml` functionality within the `PlotExportContract` domain.

##### `op plotExportSvg`
```flux
op plotExportSvg (as map: ctx, as string: path) as bool
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `path` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotExportSvg` functionality within the `PlotExportContract` domain.

### 4.6 Contract `PlotGeometryCoordContract` (`PlotGeometryCoord.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `plotCurvilinearGrid` | `op plotCurvilinearGrid (as map: ctx, as int64: coord_sys, as int64: divisions) as map` | `map` |
| `plotCurvilinearCurve` | `op plotCurvilinearCurve (as map: ctx, as int64: coord_sys, as list of float64: us, as list of float64: vs, as list of float64: ws, as list of int64: color) as map` | `map` |

#### Operation Technical Specifications:

##### `op plotCurvilinearGrid`
```flux
op plotCurvilinearGrid (as map: ctx, as int64: coord_sys, as int64: divisions) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `coord_sys` (`int64`): Input argument for operation execution.
  - `divisions` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotCurvilinearGrid` functionality within the `PlotGeometryCoordContract` domain.

##### `op plotCurvilinearCurve`
```flux
op plotCurvilinearCurve (as map: ctx, as int64: coord_sys, as list of float64: us, as list of float64: vs, as list of float64: ws, as list of int64: color) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `coord_sys` (`int64`): Input argument for operation execution.
  - `us` (`list of float64`): Input argument for operation execution.
  - `vs` (`list of float64`): Input argument for operation execution.
  - `ws` (`list of float64`): Input argument for operation execution.
  - `color` (`list of int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotCurvilinearCurve` functionality within the `PlotGeometryCoordContract` domain.

### 4.7 Contract `PlotRelationContract` (`PlotRelation.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `plotScatter` | `op plotScatter (as map: ctx, as list of float64: xs, as list of float64: ys, as list of int64: color) as map` | `map` |
| `plotLine` | `op plotLine (as map: ctx, as list of float64: xs, as list of float64: ys, as list of int64: color) as map` | `map` |
| `plotBubble` | `op plotBubble (as map: ctx, as list of float64: xs, as list of float64: ys, as list of float64: sizes, as list of int64: color) as map` | `map` |
| `plotParallelCoords` | `op plotParallelCoords (as map: ctx, as list of data: dimensions, as list of data: records) as map` | `map` |
| `plotCorrelationMatrix` | `op plotCorrelationMatrix (as map: ctx, as list of data: matrix_rows, as list of string: labels) as map` | `map` |
| `plotHexbin` | `op plotHexbin (as map: ctx, as list of float64: xs, as list of float64: ys, as int64: grid_size) as map` | `map` |

#### Operation Technical Specifications:

##### `op plotScatter`
```flux
op plotScatter (as map: ctx, as list of float64: xs, as list of float64: ys, as list of int64: color) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `xs` (`list of float64`): Input argument for operation execution.
  - `ys` (`list of float64`): Input argument for operation execution.
  - `color` (`list of int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotScatter` functionality within the `PlotRelationContract` domain.

##### `op plotLine`
```flux
op plotLine (as map: ctx, as list of float64: xs, as list of float64: ys, as list of int64: color) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `xs` (`list of float64`): Input argument for operation execution.
  - `ys` (`list of float64`): Input argument for operation execution.
  - `color` (`list of int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotLine` functionality within the `PlotRelationContract` domain.

##### `op plotBubble`
```flux
op plotBubble (as map: ctx, as list of float64: xs, as list of float64: ys, as list of float64: sizes, as list of int64: color) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `xs` (`list of float64`): Input argument for operation execution.
  - `ys` (`list of float64`): Input argument for operation execution.
  - `sizes` (`list of float64`): Input argument for operation execution.
  - `color` (`list of int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotBubble` functionality within the `PlotRelationContract` domain.

##### `op plotParallelCoords`
```flux
op plotParallelCoords (as map: ctx, as list of data: dimensions, as list of data: records) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `dimensions` (`list of data`): Input argument for operation execution.
  - `records` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotParallelCoords` functionality within the `PlotRelationContract` domain.

##### `op plotCorrelationMatrix`
```flux
op plotCorrelationMatrix (as map: ctx, as list of data: matrix_rows, as list of string: labels) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `matrix_rows` (`list of data`): Input argument for operation execution.
  - `labels` (`list of string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotCorrelationMatrix` functionality within the `PlotRelationContract` domain.

##### `op plotHexbin`
```flux
op plotHexbin (as map: ctx, as list of float64: xs, as list of float64: ys, as int64: grid_size) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `xs` (`list of float64`): Input argument for operation execution.
  - `ys` (`list of float64`): Input argument for operation execution.
  - `grid_size` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotHexbin` functionality within the `PlotRelationContract` domain.

### 4.8 Contract `PlotRenderContract` (`PlotRender.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `plotRender` | `op plotRender (as map: ctx) as map` | `map` |
| `plotPresent` | `op plotPresent (as map: ctx) as bool` | `bool` |
| `plotShow` | `op plotShow (as map: ctx, as int64: ms) as bool` | `bool` |
| `plotWait` | `op plotWait (as map: ctx) as bool` | `bool` |

#### Operation Technical Specifications:

##### `op plotRender`
```flux
op plotRender (as map: ctx) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotRender` functionality within the `PlotRenderContract` domain.

##### `op plotPresent`
```flux
op plotPresent (as map: ctx) as bool
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotPresent` functionality within the `PlotRenderContract` domain.

##### `op plotShow`
```flux
op plotShow (as map: ctx, as int64: ms) as bool
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `ms` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotShow` functionality within the `PlotRenderContract` domain.

##### `op plotWait`
```flux
op plotWait (as map: ctx) as bool
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotWait` functionality within the `PlotRenderContract` domain.

### 4.9 Contract `PlotSpecialMathContract` (`PlotSpecialMath.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `plotParametric2D` | `op plotParametric2D (as map: ctx, as list of float64: xs, as list of float64: ys) as map` | `map` |
| `plotParametric3D` | `op plotParametric3D (as map: ctx, as list of float64: xs, as list of float64: ys, as list of float64: zs) as map` | `map` |
| `plotBifurcation` | `op plotBifurcation (as map: ctx, as float64: r_min, as float64: r_max, as int64: n_points) as map` | `map` |
| `plotPhaseSpace` | `op plotPhaseSpace (as map: ctx, as list of float64: qs, as list of float64: ps) as map` | `map` |
| `plotNetworkGraph` | `op plotNetworkGraph (as map: ctx, as list of data: nodes, as list of data: edges) as map` | `map` |
| `plotVenn` | `op plotVenn (as map: ctx, as int64: set_count, as list of float64: subset_sizes) as map` | `map` |

#### Operation Technical Specifications:

##### `op plotParametric2D`
```flux
op plotParametric2D (as map: ctx, as list of float64: xs, as list of float64: ys) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `xs` (`list of float64`): Input argument for operation execution.
  - `ys` (`list of float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotParametric2D` functionality within the `PlotSpecialMathContract` domain.

##### `op plotParametric3D`
```flux
op plotParametric3D (as map: ctx, as list of float64: xs, as list of float64: ys, as list of float64: zs) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `xs` (`list of float64`): Input argument for operation execution.
  - `ys` (`list of float64`): Input argument for operation execution.
  - `zs` (`list of float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotParametric3D` functionality within the `PlotSpecialMathContract` domain.

##### `op plotBifurcation`
```flux
op plotBifurcation (as map: ctx, as float64: r_min, as float64: r_max, as int64: n_points) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `r_min` (`float64`): Input argument for operation execution.
  - `r_max` (`float64`): Input argument for operation execution.
  - `n_points` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotBifurcation` functionality within the `PlotSpecialMathContract` domain.

##### `op plotPhaseSpace`
```flux
op plotPhaseSpace (as map: ctx, as list of float64: qs, as list of float64: ps) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `qs` (`list of float64`): Input argument for operation execution.
  - `ps` (`list of float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotPhaseSpace` functionality within the `PlotSpecialMathContract` domain.

##### `op plotNetworkGraph`
```flux
op plotNetworkGraph (as map: ctx, as list of data: nodes, as list of data: edges) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `nodes` (`list of data`): Input argument for operation execution.
  - `edges` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotNetworkGraph` functionality within the `PlotSpecialMathContract` domain.

##### `op plotVenn`
```flux
op plotVenn (as map: ctx, as int64: set_count, as list of float64: subset_sizes) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `set_count` (`int64`): Input argument for operation execution.
  - `subset_sizes` (`list of float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotVenn` functionality within the `PlotSpecialMathContract` domain.

### 4.10 Contract `PlotSurfaceFieldContract` (`PlotSurfaceField.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `plotSurface3D` | `op plotSurface3D (as map: ctx, as list of data: grid_x, as list of data: grid_y, as list of data: grid_z) as map` | `map` |
| `plotMesh3D` | `op plotMesh3D (as map: ctx, as list of data: grid_x, as list of data: grid_y, as list of data: grid_z) as map` | `map` |
| `plotContour` | `op plotContour (as map: ctx, as list of data: grid_z, as int64: n_levels) as map` | `map` |
| `plotQuiver2D` | `op plotQuiver2D (as map: ctx, as list of float64: xs, as list of float64: ys, as list of float64: us, as list of float64: vs) as map` | `map` |
| `plotStreamlines` | `op plotStreamlines (as map: ctx, as list of data: grid_u, as list of data: grid_v) as map` | `map` |
| `plotScatter3D` | `op plotScatter3D (as map: ctx, as list of float64: xs, as list of float64: ys, as list of float64: zs) as map` | `map` |
| `plotTrajectory3D` | `op plotTrajectory3D (as map: ctx, as list of float64: xs, as list of float64: ys, as list of float64: zs) as map` | `map` |

#### Operation Technical Specifications:

##### `op plotSurface3D`
```flux
op plotSurface3D (as map: ctx, as list of data: grid_x, as list of data: grid_y, as list of data: grid_z) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `grid_x` (`list of data`): Input argument for operation execution.
  - `grid_y` (`list of data`): Input argument for operation execution.
  - `grid_z` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotSurface3D` functionality within the `PlotSurfaceFieldContract` domain.

##### `op plotMesh3D`
```flux
op plotMesh3D (as map: ctx, as list of data: grid_x, as list of data: grid_y, as list of data: grid_z) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `grid_x` (`list of data`): Input argument for operation execution.
  - `grid_y` (`list of data`): Input argument for operation execution.
  - `grid_z` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotMesh3D` functionality within the `PlotSurfaceFieldContract` domain.

##### `op plotContour`
```flux
op plotContour (as map: ctx, as list of data: grid_z, as int64: n_levels) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `grid_z` (`list of data`): Input argument for operation execution.
  - `n_levels` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotContour` functionality within the `PlotSurfaceFieldContract` domain.

##### `op plotQuiver2D`
```flux
op plotQuiver2D (as map: ctx, as list of float64: xs, as list of float64: ys, as list of float64: us, as list of float64: vs) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `xs` (`list of float64`): Input argument for operation execution.
  - `ys` (`list of float64`): Input argument for operation execution.
  - `us` (`list of float64`): Input argument for operation execution.
  - `vs` (`list of float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotQuiver2D` functionality within the `PlotSurfaceFieldContract` domain.

##### `op plotStreamlines`
```flux
op plotStreamlines (as map: ctx, as list of data: grid_u, as list of data: grid_v) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `grid_u` (`list of data`): Input argument for operation execution.
  - `grid_v` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotStreamlines` functionality within the `PlotSurfaceFieldContract` domain.

##### `op plotScatter3D`
```flux
op plotScatter3D (as map: ctx, as list of float64: xs, as list of float64: ys, as list of float64: zs) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `xs` (`list of float64`): Input argument for operation execution.
  - `ys` (`list of float64`): Input argument for operation execution.
  - `zs` (`list of float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotScatter3D` functionality within the `PlotSurfaceFieldContract` domain.

##### `op plotTrajectory3D`
```flux
op plotTrajectory3D (as map: ctx, as list of float64: xs, as list of float64: ys, as list of float64: zs) as map
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `xs` (`list of float64`): Input argument for operation execution.
  - `ys` (`list of float64`): Input argument for operation execution.
  - `zs` (`list of float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotTrajectory3D` functionality within the `PlotSurfaceFieldContract` domain.

### 4.11 Contract `PlotThemeContract` (`PlotTheme.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `plotThemeDark` | `op plotThemeDark () as map` | `map` |
| `plotThemeLight` | `op plotThemeLight () as map` | `map` |
| `plotThemeScientific` | `op plotThemeScientific () as map` | `map` |
| `plotGetColorMapRgb` | `op plotGetColorMapRgb (as int64: cmap, as float64: t) as list of int64` | `list of int64` |

#### Operation Technical Specifications:

##### `op plotThemeDark`
```flux
op plotThemeDark () as map
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotThemeDark` functionality within the `PlotThemeContract` domain.

##### `op plotThemeLight`
```flux
op plotThemeLight () as map
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotThemeLight` functionality within the `PlotThemeContract` domain.

##### `op plotThemeScientific`
```flux
op plotThemeScientific () as map
```
- **Parameters**:
  - *None (operation accepts no arguments).*
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotThemeScientific` functionality within the `PlotThemeContract` domain.

##### `op plotGetColorMapRgb`
```flux
op plotGetColorMapRgb (as int64: cmap, as float64: t) as list of int64
```
- **Parameters**:
  - `cmap` (`int64`): Input argument for operation execution.
  - `t` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotGetColorMapRgb` functionality within the `PlotThemeContract` domain.

### 4.12 Contract `PlotTransformContract` (`PlotTransform.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `plotTransformToCartesian` | `op plotTransformToCartesian (as int64: coord_sys, as float64: u, as float64: v, as float64: w) as list of float64` | `list of float64` |
| `plotTransformFromCartesian` | `op plotTransformFromCartesian (as int64: coord_sys, as float64: x, as float64: y, as float64: z) as list of float64` | `list of float64` |
| `plotProjectToScreen` | `op plotProjectToScreen (as map: ctx, as float64: x, as float64: y, as float64: z) as list of int64` | `list of int64` |

#### Operation Technical Specifications:

##### `op plotTransformToCartesian`
```flux
op plotTransformToCartesian (as int64: coord_sys, as float64: u, as float64: v, as float64: w) as list of float64
```
- **Parameters**:
  - `coord_sys` (`int64`): Input argument for operation execution.
  - `u` (`float64`): Input argument for operation execution.
  - `v` (`float64`): Input argument for operation execution.
  - `w` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotTransformToCartesian` functionality within the `PlotTransformContract` domain.

##### `op plotTransformFromCartesian`
```flux
op plotTransformFromCartesian (as int64: coord_sys, as float64: x, as float64: y, as float64: z) as list of float64
```
- **Parameters**:
  - `coord_sys` (`int64`): Input argument for operation execution.
  - `x` (`float64`): Input argument for operation execution.
  - `y` (`float64`): Input argument for operation execution.
  - `z` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of float64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotTransformFromCartesian` functionality within the `PlotTransformContract` domain.

##### `op plotProjectToScreen`
```flux
op plotProjectToScreen (as map: ctx, as float64: x, as float64: y, as float64: z) as list of int64
```
- **Parameters**:
  - `ctx` (`map`): Input argument for operation execution.
  - `x` (`float64`): Input argument for operation execution.
  - `y` (`float64`): Input argument for operation execution.
  - `z` (`float64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `plotProjectToScreen` functionality within the `PlotTransformContract` domain.

---

## 5. Canonical Usage Examples in TheFlux

The following snippet illustrates importing and utilizing the library in a TheFlux program:

```flux
# Canonical Usage Example for GraphPlotStdLib
use GraphPlotStdLib

program (ExampleOfGraphPlotStdLib) {
      println("==================================================")
      println("  Standard Library Demonstration: GraphPlotStdLib")
      println("==================================================")

      # Invoking canonical operation
      mut as data: result = GraphPlotStdLib::plotCreateContext(800, 600)
      println("Obtained result: " + result)

      println("Execution completed successfully.")
}
```

---

> [!TIP]
> For the complete unified architecture across all standard libraries, consult the master [StdLibs.md](../StdLibs.md) reference.
