# 📚 `FormatStdLib` — Data Serialization and Formatting in JSON, YAML, TOML, and CSV

> **Architectural Pillar**: Pillar 1 (Core, Text & OO)  
> **Status**: ✅ Certified with 100% Parity across 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Master File**: `stdlib/FormatStdLib/FormatStdLib.fdsl`  
> **Import Mode**: `use FormatStdLib` or `use FormatStdLib::<Module>::<operation>`

---

## 1. Overview and Capabilities

The **`FormatStdLib`** standard library is an integral component of the official TheFlux language ecosystem, providing certified system-level algorithms and robust capabilities.

Bidirectional high-throughput parsers and serializers for ubiquitous configuration and data interchange formats: RFC 8259 JSON, human-readable YAML, TOML manifest syntax, and CSV tabular records with quotation escaping.

### 1.1 Key Architectural Principles and Design
- **Static Fusion and Zero-Overhead**: All domain modules are transparently fused into the `FormatStdLib` unified agent at compile time, avoiding virtual dispatch penalties.
- **Safety and Isolation**: Operations strictly validate parameter bounds and guarantee predictable error semantics via contract definitions.
- **Universal Multi-Backend Parity**: Bit-for-bit identical execution guarantees across interpreter (`in`), bytecode VM (`vm`, `vmr`), native AOT LLVM (`llvm`), and WebAssembly (`wat`, `wasm`).

---

## 2. Modular Structure and Contracts

The library comprises **5 domain modules** declaring a total of **46 public operations**:

| Domain Source File | Formal Contract | Domain Responsibility | Ops Count |
|---|---|---|:---:|
| `FormatCsv.fdsl` | `FormatCsvContract` | Specialized domain for `FormatCsv` | 10 |
| `FormatEncoding.fdsl` | `FormatEncodingContract` | Specialized domain for `FormatEncoding` | 10 |
| `FormatJson.fdsl` | `FormatJsonContract` | Specialized domain for `FormatJson` | 10 |
| `FormatToml.fdsl` | `FormatTomlContract` | Specialized domain for `FormatToml` | 6 |
| `FormatYaml.fdsl` | `FormatYamlContract` | Specialized domain for `FormatYaml` | 10 |

---

## 3. Public Types, Structures, and Enumerations

The `FormatStdLib` library operates directly on primitive native TheFlux types (`string`, `int64`, `float64`, `bool`, `list of data`, etc.) without requiring custom composite types.

---

## 4. Detailed Operations Catalog by Domain

### 4.1 Contract `FormatCsvContract` (`FormatCsv.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `formatParseCsvRows` | `op formatParseCsvRows (as string: csv_text, as string: delimiter) as list of data` | `list of data` |
| `formatParseCsvTable` | `op formatParseCsvTable (as string: csv_text, as string: delimiter) as list of data` | `list of data` |
| `formatStringifyCsvRows` | `op formatStringifyCsvRows (as list of data: rows, as string: delimiter) as string` | `string` |
| `formatStringifyCsvTable` | `op formatStringifyCsvTable (as list of data: records, as list of data: headers, as string: delimiter) as string` | `string` |
| `formatIsValidCsv` | `op formatIsValidCsv (as string: csv_text, as string: delimiter) as bool` | `bool` |
| `parseCsvRows` | `op parseCsvRows (as string: csv_text, as string: delimiter) as list of data` | `list of data` |
| `parseCsvTable` | `op parseCsvTable (as string: csv_text, as string: delimiter) as list of data` | `list of data` |
| `stringifyCsvRows` | `op stringifyCsvRows (as list of data: rows, as string: delimiter) as string` | `string` |
| `stringifyCsvTable` | `op stringifyCsvTable (as list of data: records, as list of data: headers, as string: delimiter) as string` | `string` |
| `isValidCsv` | `op isValidCsv (as string: csv_text, as string: delimiter) as bool` | `bool` |

#### Operation Technical Specifications:

##### `op formatParseCsvRows`
```flux
op formatParseCsvRows (as string: csv_text, as string: delimiter) as list of data
```
- **Parameters**:
  - `csv_text` (`string`): Input argument for operation execution.
  - `delimiter` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `formatParseCsvRows` functionality within the `FormatCsvContract` domain.

##### `op formatParseCsvTable`
```flux
op formatParseCsvTable (as string: csv_text, as string: delimiter) as list of data
```
- **Parameters**:
  - `csv_text` (`string`): Input argument for operation execution.
  - `delimiter` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `formatParseCsvTable` functionality within the `FormatCsvContract` domain.

##### `op formatStringifyCsvRows`
```flux
op formatStringifyCsvRows (as list of data: rows, as string: delimiter) as string
```
- **Parameters**:
  - `rows` (`list of data`): Input argument for operation execution.
  - `delimiter` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `formatStringifyCsvRows` functionality within the `FormatCsvContract` domain.

##### `op formatStringifyCsvTable`
```flux
op formatStringifyCsvTable (as list of data: records, as list of data: headers, as string: delimiter) as string
```
- **Parameters**:
  - `records` (`list of data`): Input argument for operation execution.
  - `headers` (`list of data`): Input argument for operation execution.
  - `delimiter` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `formatStringifyCsvTable` functionality within the `FormatCsvContract` domain.

##### `op formatIsValidCsv`
```flux
op formatIsValidCsv (as string: csv_text, as string: delimiter) as bool
```
- **Parameters**:
  - `csv_text` (`string`): Input argument for operation execution.
  - `delimiter` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `formatIsValidCsv` functionality within the `FormatCsvContract` domain.

##### `op parseCsvRows`
```flux
op parseCsvRows (as string: csv_text, as string: delimiter) as list of data
```
- **Parameters**:
  - `csv_text` (`string`): Input argument for operation execution.
  - `delimiter` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `parseCsvRows` functionality within the `FormatCsvContract` domain.

##### `op parseCsvTable`
```flux
op parseCsvTable (as string: csv_text, as string: delimiter) as list of data
```
- **Parameters**:
  - `csv_text` (`string`): Input argument for operation execution.
  - `delimiter` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `parseCsvTable` functionality within the `FormatCsvContract` domain.

##### `op stringifyCsvRows`
```flux
op stringifyCsvRows (as list of data: rows, as string: delimiter) as string
```
- **Parameters**:
  - `rows` (`list of data`): Input argument for operation execution.
  - `delimiter` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringifyCsvRows` functionality within the `FormatCsvContract` domain.

##### `op stringifyCsvTable`
```flux
op stringifyCsvTable (as list of data: records, as list of data: headers, as string: delimiter) as string
```
- **Parameters**:
  - `records` (`list of data`): Input argument for operation execution.
  - `headers` (`list of data`): Input argument for operation execution.
  - `delimiter` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringifyCsvTable` functionality within the `FormatCsvContract` domain.

##### `op isValidCsv`
```flux
op isValidCsv (as string: csv_text, as string: delimiter) as bool
```
- **Parameters**:
  - `csv_text` (`string`): Input argument for operation execution.
  - `delimiter` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `isValidCsv` functionality within the `FormatCsvContract` domain.

### 4.2 Contract `FormatEncodingContract` (`FormatEncoding.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `formatEncodeBase64` | `op formatEncodeBase64 (as string: text) as string` | `string` |
| `formatDecodeBase64` | `op formatDecodeBase64 (as string: b64_text) as string` | `string` |
| `formatIsValidBase64` | `op formatIsValidBase64 (as string: b64_text) as bool` | `bool` |
| `formatParseQueryString` | `op formatParseQueryString (as string: query_text) as map` | `map` |
| `formatStringifyQueryString` | `op formatStringifyQueryString (as map: params) as string` | `string` |
| `encodeBase64` | `op encodeBase64 (as string: text) as string` | `string` |
| `decodeBase64` | `op decodeBase64 (as string: b64_text) as string` | `string` |
| `isValidBase64` | `op isValidBase64 (as string: b64_text) as bool` | `bool` |
| `parseQueryString` | `op parseQueryString (as string: query_text) as map` | `map` |
| `stringifyQueryString` | `op stringifyQueryString (as map: params) as string` | `string` |

#### Operation Technical Specifications:

##### `op formatEncodeBase64`
```flux
op formatEncodeBase64 (as string: text) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `formatEncodeBase64` functionality within the `FormatEncodingContract` domain.

##### `op formatDecodeBase64`
```flux
op formatDecodeBase64 (as string: b64_text) as string
```
- **Parameters**:
  - `b64_text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `formatDecodeBase64` functionality within the `FormatEncodingContract` domain.

##### `op formatIsValidBase64`
```flux
op formatIsValidBase64 (as string: b64_text) as bool
```
- **Parameters**:
  - `b64_text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `formatIsValidBase64` functionality within the `FormatEncodingContract` domain.

##### `op formatParseQueryString`
```flux
op formatParseQueryString (as string: query_text) as map
```
- **Parameters**:
  - `query_text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `formatParseQueryString` functionality within the `FormatEncodingContract` domain.

##### `op formatStringifyQueryString`
```flux
op formatStringifyQueryString (as map: params) as string
```
- **Parameters**:
  - `params` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `formatStringifyQueryString` functionality within the `FormatEncodingContract` domain.

##### `op encodeBase64`
```flux
op encodeBase64 (as string: text) as string
```
- **Parameters**:
  - `text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `encodeBase64` functionality within the `FormatEncodingContract` domain.

##### `op decodeBase64`
```flux
op decodeBase64 (as string: b64_text) as string
```
- **Parameters**:
  - `b64_text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `decodeBase64` functionality within the `FormatEncodingContract` domain.

##### `op isValidBase64`
```flux
op isValidBase64 (as string: b64_text) as bool
```
- **Parameters**:
  - `b64_text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `isValidBase64` functionality within the `FormatEncodingContract` domain.

##### `op parseQueryString`
```flux
op parseQueryString (as string: query_text) as map
```
- **Parameters**:
  - `query_text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `parseQueryString` functionality within the `FormatEncodingContract` domain.

##### `op stringifyQueryString`
```flux
op stringifyQueryString (as map: params) as string
```
- **Parameters**:
  - `params` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringifyQueryString` functionality within the `FormatEncodingContract` domain.

### 4.3 Contract `FormatJsonContract` (`FormatJson.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `formatParseJson` | `op formatParseJson (as string: json_text) as data` | `data` |
| `formatStringifyJson` | `op formatStringifyJson (as data: val) as string` | `string` |
| `formatIsValidJson` | `op formatIsValidJson (as string: json_text) as bool` | `bool` |
| `formatMinifyJson` | `op formatMinifyJson (as string: json_text) as string` | `string` |
| `formatPrettyJson` | `op formatPrettyJson (as string: json_text, as int64: indent_size) as string` | `string` |
| `parseJson` | `op parseJson (as string: json_text) as data` | `data` |
| `stringifyJson` | `op stringifyJson (as data: val) as string` | `string` |
| `isValidJson` | `op isValidJson (as string: json_text) as bool` | `bool` |
| `minifyJson` | `op minifyJson (as string: json_text) as string` | `string` |
| `prettyJson` | `op prettyJson (as string: json_text, as int64: indent_size) as string` | `string` |

#### Operation Technical Specifications:

##### `op formatParseJson`
```flux
op formatParseJson (as string: json_text) as data
```
- **Parameters**:
  - `json_text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `formatParseJson` functionality within the `FormatJsonContract` domain.

##### `op formatStringifyJson`
```flux
op formatStringifyJson (as data: val) as string
```
- **Parameters**:
  - `val` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `formatStringifyJson` functionality within the `FormatJsonContract` domain.

##### `op formatIsValidJson`
```flux
op formatIsValidJson (as string: json_text) as bool
```
- **Parameters**:
  - `json_text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `formatIsValidJson` functionality within the `FormatJsonContract` domain.

##### `op formatMinifyJson`
```flux
op formatMinifyJson (as string: json_text) as string
```
- **Parameters**:
  - `json_text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `formatMinifyJson` functionality within the `FormatJsonContract` domain.

##### `op formatPrettyJson`
```flux
op formatPrettyJson (as string: json_text, as int64: indent_size) as string
```
- **Parameters**:
  - `json_text` (`string`): Input argument for operation execution.
  - `indent_size` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `formatPrettyJson` functionality within the `FormatJsonContract` domain.

##### `op parseJson`
```flux
op parseJson (as string: json_text) as data
```
- **Parameters**:
  - `json_text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `parseJson` functionality within the `FormatJsonContract` domain.

##### `op stringifyJson`
```flux
op stringifyJson (as data: val) as string
```
- **Parameters**:
  - `val` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringifyJson` functionality within the `FormatJsonContract` domain.

##### `op isValidJson`
```flux
op isValidJson (as string: json_text) as bool
```
- **Parameters**:
  - `json_text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `isValidJson` functionality within the `FormatJsonContract` domain.

##### `op minifyJson`
```flux
op minifyJson (as string: json_text) as string
```
- **Parameters**:
  - `json_text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `minifyJson` functionality within the `FormatJsonContract` domain.

##### `op prettyJson`
```flux
op prettyJson (as string: json_text, as int64: indent_size) as string
```
- **Parameters**:
  - `json_text` (`string`): Input argument for operation execution.
  - `indent_size` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `prettyJson` functionality within the `FormatJsonContract` domain.

### 4.4 Contract `FormatTomlContract` (`FormatToml.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `formatParseToml` | `op formatParseToml (as string: toml_text) as map` | `map` |
| `formatStringifyToml` | `op formatStringifyToml (as map: data_map) as string` | `string` |
| `formatIsValidToml` | `op formatIsValidToml (as string: toml_text) as bool` | `bool` |
| `parseToml` | `op parseToml (as string: toml_text) as map` | `map` |
| `stringifyToml` | `op stringifyToml (as map: data_map) as string` | `string` |
| `isValidToml` | `op isValidToml (as string: toml_text) as bool` | `bool` |

#### Operation Technical Specifications:

##### `op formatParseToml`
```flux
op formatParseToml (as string: toml_text) as map
```
- **Parameters**:
  - `toml_text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `formatParseToml` functionality within the `FormatTomlContract` domain.

##### `op formatStringifyToml`
```flux
op formatStringifyToml (as map: data_map) as string
```
- **Parameters**:
  - `data_map` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `formatStringifyToml` functionality within the `FormatTomlContract` domain.

##### `op formatIsValidToml`
```flux
op formatIsValidToml (as string: toml_text) as bool
```
- **Parameters**:
  - `toml_text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `formatIsValidToml` functionality within the `FormatTomlContract` domain.

##### `op parseToml`
```flux
op parseToml (as string: toml_text) as map
```
- **Parameters**:
  - `toml_text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `parseToml` functionality within the `FormatTomlContract` domain.

##### `op stringifyToml`
```flux
op stringifyToml (as map: data_map) as string
```
- **Parameters**:
  - `data_map` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringifyToml` functionality within the `FormatTomlContract` domain.

##### `op isValidToml`
```flux
op isValidToml (as string: toml_text) as bool
```
- **Parameters**:
  - `toml_text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `isValidToml` functionality within the `FormatTomlContract` domain.

### 4.5 Contract `FormatYamlContract` (`FormatYaml.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `formatParseYaml` | `op formatParseYaml (as string: yaml_text) as data` | `data` |
| `formatParseYamlAll` | `op formatParseYamlAll (as string: yaml_text) as list of data` | `list of data` |
| `formatStringifyYaml` | `op formatStringifyYaml (as data: val) as string` | `string` |
| `formatStringifyYamlAll` | `op formatStringifyYamlAll (as list of data: docs) as string` | `string` |
| `formatIsValidYaml` | `op formatIsValidYaml (as string: yaml_text) as bool` | `bool` |
| `parseYaml` | `op parseYaml (as string: yaml_text) as data` | `data` |
| `parseYamlAll` | `op parseYamlAll (as string: yaml_text) as list of data` | `list of data` |
| `stringifyYaml` | `op stringifyYaml (as data: val) as string` | `string` |
| `stringifyYamlAll` | `op stringifyYamlAll (as list of data: docs) as string` | `string` |
| `isValidYaml` | `op isValidYaml (as string: yaml_text) as bool` | `bool` |

#### Operation Technical Specifications:

##### `op formatParseYaml`
```flux
op formatParseYaml (as string: yaml_text) as data
```
- **Parameters**:
  - `yaml_text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `formatParseYaml` functionality within the `FormatYamlContract` domain.

##### `op formatParseYamlAll`
```flux
op formatParseYamlAll (as string: yaml_text) as list of data
```
- **Parameters**:
  - `yaml_text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `formatParseYamlAll` functionality within the `FormatYamlContract` domain.

##### `op formatStringifyYaml`
```flux
op formatStringifyYaml (as data: val) as string
```
- **Parameters**:
  - `val` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `formatStringifyYaml` functionality within the `FormatYamlContract` domain.

##### `op formatStringifyYamlAll`
```flux
op formatStringifyYamlAll (as list of data: docs) as string
```
- **Parameters**:
  - `docs` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `formatStringifyYamlAll` functionality within the `FormatYamlContract` domain.

##### `op formatIsValidYaml`
```flux
op formatIsValidYaml (as string: yaml_text) as bool
```
- **Parameters**:
  - `yaml_text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `formatIsValidYaml` functionality within the `FormatYamlContract` domain.

##### `op parseYaml`
```flux
op parseYaml (as string: yaml_text) as data
```
- **Parameters**:
  - `yaml_text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `parseYaml` functionality within the `FormatYamlContract` domain.

##### `op parseYamlAll`
```flux
op parseYamlAll (as string: yaml_text) as list of data
```
- **Parameters**:
  - `yaml_text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `parseYamlAll` functionality within the `FormatYamlContract` domain.

##### `op stringifyYaml`
```flux
op stringifyYaml (as data: val) as string
```
- **Parameters**:
  - `val` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringifyYaml` functionality within the `FormatYamlContract` domain.

##### `op stringifyYamlAll`
```flux
op stringifyYamlAll (as list of data: docs) as string
```
- **Parameters**:
  - `docs` (`list of data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `stringifyYamlAll` functionality within the `FormatYamlContract` domain.

##### `op isValidYaml`
```flux
op isValidYaml (as string: yaml_text) as bool
```
- **Parameters**:
  - `yaml_text` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `isValidYaml` functionality within the `FormatYamlContract` domain.

---

## 5. Canonical Usage Examples in TheFlux

The following snippet illustrates importing and utilizing the library in a TheFlux program:

```flux
# Canonical Usage Example for FormatStdLib
use FormatStdLib

program (ExampleOfFormatStdLib) {
      println("==================================================")
      println("  Standard Library Demonstration: FormatStdLib")
      println("==================================================")

      # Invoking canonical operation
      mut as data: result = FormatStdLib::jsonEscape("text")
      println("Obtained result: " + result)

      println("Execution completed successfully.")
}
```

---

> [!TIP]
> For the complete unified architecture across all standard libraries, consult the master [StdLibs.md](../StdLibs.md) reference.
