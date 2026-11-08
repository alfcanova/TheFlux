# 📚 `FormatStdLib` — Formatação e Serialização de Dados em JSON, YAML, TOML e CSV

> **Pilar Arquitetural**: Pilar 1 (Núcleo, Texto & OO)  
> **Status**: ✅ Homologado com 100% de Paridade nos 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Arquivo Mestre**: `stdlib/FormatStdLib/FormatStdLib.fdsl`  
> **Modo de Importação**: `use FormatStdLib` ou `use FormatStdLib::<Modulo>::<operacao>`

---

## 1. Visão Geral e Funcionalidades

A biblioteca padrão **`FormatStdLib`** integra o ecossistema oficial da linguagem TheFlux, fornecendo suporte de nível de sistema e algoritmos nativos certificados.

Parsers e formatadores bi-direcionais rápidos para formatos de intercâmbio de dados e configuração: JSON compatível com RFC 8259, YAML estruturado, TOML para manifestos de projeto e CSV delimitado com suporte a escaping e aspas.

### 1.1 Características e Princípios de Design
- **Compilação e Fusão Estática**: Todos os módulos de domínio são fundidos no agente unificado `FormatStdLib` em tempo de compilação, sem sobrecarga (*overhead*) de despacho indireto.
- **Isolamento e Segurança**: As operações verificam limites operacionais e utilizam despacho por contratos formais rigorosos.
- **Compatibilidade Multi-Backend**: Execução bit-a-bit idêntica em interpretador (`in`), bytecode (`vm`, `vmr`), nativo AOT (`llvm`) e WebAssembly (`wat`, `wasm`).

---

## 2. Estrutura Modular e Contratos

A biblioteca é composta por **5 módulos de domínio** e declara **46 operações públicas**:

| Arquivo de Domínio | Contrato Formal | Responsabilidade Principal | Qtd. Ops |
|---|---|---|:---:|
| `FormatCsv.fdsl` | `FormatCsvContract` | Domínio especializado de `FormatCsv` | 10 |
| `FormatEncoding.fdsl` | `FormatEncodingContract` | Domínio especializado de `FormatEncoding` | 10 |
| `FormatJson.fdsl` | `FormatJsonContract` | Domínio especializado de `FormatJson` | 10 |
| `FormatToml.fdsl` | `FormatTomlContract` | Domínio especializado de `FormatToml` | 6 |
| `FormatYaml.fdsl` | `FormatYamlContract` | Domínio especializado de `FormatYaml` | 10 |

---

## 3. Tipos, Estruturas e Enumerações Públicas

A biblioteca `FormatStdLib` opera diretamente com os tipos nativos e primitivos da linguagem TheFlux (`string`, `int64`, `float64`, `bool`, `list of data`, etc.), sem exigir tipos compostos adicionais.

---

## 4. Catálogo Detalhado de Operações por Domínio

### 4.1 Contrato `FormatCsvContract` (`FormatCsv.fdsl`)

| Operação | Assinatura | Retorno |
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

#### Ficha Técnica das Operações:

##### `op formatParseCsvRows`
```flux
op formatParseCsvRows (as string: csv_text, as string: delimiter) as list of data
```
- **Parâmetros**:
  - `csv_text` (`string`): Parâmetro de entrada para processamento da operação.
  - `delimiter` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `formatParseCsvRows` no domínio `FormatCsvContract`.

##### `op formatParseCsvTable`
```flux
op formatParseCsvTable (as string: csv_text, as string: delimiter) as list of data
```
- **Parâmetros**:
  - `csv_text` (`string`): Parâmetro de entrada para processamento da operação.
  - `delimiter` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `formatParseCsvTable` no domínio `FormatCsvContract`.

##### `op formatStringifyCsvRows`
```flux
op formatStringifyCsvRows (as list of data: rows, as string: delimiter) as string
```
- **Parâmetros**:
  - `rows` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `delimiter` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `formatStringifyCsvRows` no domínio `FormatCsvContract`.

##### `op formatStringifyCsvTable`
```flux
op formatStringifyCsvTable (as list of data: records, as list of data: headers, as string: delimiter) as string
```
- **Parâmetros**:
  - `records` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `headers` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `delimiter` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `formatStringifyCsvTable` no domínio `FormatCsvContract`.

##### `op formatIsValidCsv`
```flux
op formatIsValidCsv (as string: csv_text, as string: delimiter) as bool
```
- **Parâmetros**:
  - `csv_text` (`string`): Parâmetro de entrada para processamento da operação.
  - `delimiter` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `formatIsValidCsv` no domínio `FormatCsvContract`.

##### `op parseCsvRows`
```flux
op parseCsvRows (as string: csv_text, as string: delimiter) as list of data
```
- **Parâmetros**:
  - `csv_text` (`string`): Parâmetro de entrada para processamento da operação.
  - `delimiter` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `parseCsvRows` no domínio `FormatCsvContract`.

##### `op parseCsvTable`
```flux
op parseCsvTable (as string: csv_text, as string: delimiter) as list of data
```
- **Parâmetros**:
  - `csv_text` (`string`): Parâmetro de entrada para processamento da operação.
  - `delimiter` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `parseCsvTable` no domínio `FormatCsvContract`.

##### `op stringifyCsvRows`
```flux
op stringifyCsvRows (as list of data: rows, as string: delimiter) as string
```
- **Parâmetros**:
  - `rows` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `delimiter` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringifyCsvRows` no domínio `FormatCsvContract`.

##### `op stringifyCsvTable`
```flux
op stringifyCsvTable (as list of data: records, as list of data: headers, as string: delimiter) as string
```
- **Parâmetros**:
  - `records` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `headers` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `delimiter` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringifyCsvTable` no domínio `FormatCsvContract`.

##### `op isValidCsv`
```flux
op isValidCsv (as string: csv_text, as string: delimiter) as bool
```
- **Parâmetros**:
  - `csv_text` (`string`): Parâmetro de entrada para processamento da operação.
  - `delimiter` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `isValidCsv` no domínio `FormatCsvContract`.

### 4.2 Contrato `FormatEncodingContract` (`FormatEncoding.fdsl`)

| Operação | Assinatura | Retorno |
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

#### Ficha Técnica das Operações:

##### `op formatEncodeBase64`
```flux
op formatEncodeBase64 (as string: text) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `formatEncodeBase64` no domínio `FormatEncodingContract`.

##### `op formatDecodeBase64`
```flux
op formatDecodeBase64 (as string: b64_text) as string
```
- **Parâmetros**:
  - `b64_text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `formatDecodeBase64` no domínio `FormatEncodingContract`.

##### `op formatIsValidBase64`
```flux
op formatIsValidBase64 (as string: b64_text) as bool
```
- **Parâmetros**:
  - `b64_text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `formatIsValidBase64` no domínio `FormatEncodingContract`.

##### `op formatParseQueryString`
```flux
op formatParseQueryString (as string: query_text) as map
```
- **Parâmetros**:
  - `query_text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `formatParseQueryString` no domínio `FormatEncodingContract`.

##### `op formatStringifyQueryString`
```flux
op formatStringifyQueryString (as map: params) as string
```
- **Parâmetros**:
  - `params` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `formatStringifyQueryString` no domínio `FormatEncodingContract`.

##### `op encodeBase64`
```flux
op encodeBase64 (as string: text) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `encodeBase64` no domínio `FormatEncodingContract`.

##### `op decodeBase64`
```flux
op decodeBase64 (as string: b64_text) as string
```
- **Parâmetros**:
  - `b64_text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `decodeBase64` no domínio `FormatEncodingContract`.

##### `op isValidBase64`
```flux
op isValidBase64 (as string: b64_text) as bool
```
- **Parâmetros**:
  - `b64_text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `isValidBase64` no domínio `FormatEncodingContract`.

##### `op parseQueryString`
```flux
op parseQueryString (as string: query_text) as map
```
- **Parâmetros**:
  - `query_text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `parseQueryString` no domínio `FormatEncodingContract`.

##### `op stringifyQueryString`
```flux
op stringifyQueryString (as map: params) as string
```
- **Parâmetros**:
  - `params` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringifyQueryString` no domínio `FormatEncodingContract`.

### 4.3 Contrato `FormatJsonContract` (`FormatJson.fdsl`)

| Operação | Assinatura | Retorno |
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

#### Ficha Técnica das Operações:

##### `op formatParseJson`
```flux
op formatParseJson (as string: json_text) as data
```
- **Parâmetros**:
  - `json_text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `formatParseJson` no domínio `FormatJsonContract`.

##### `op formatStringifyJson`
```flux
op formatStringifyJson (as data: val) as string
```
- **Parâmetros**:
  - `val` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `formatStringifyJson` no domínio `FormatJsonContract`.

##### `op formatIsValidJson`
```flux
op formatIsValidJson (as string: json_text) as bool
```
- **Parâmetros**:
  - `json_text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `formatIsValidJson` no domínio `FormatJsonContract`.

##### `op formatMinifyJson`
```flux
op formatMinifyJson (as string: json_text) as string
```
- **Parâmetros**:
  - `json_text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `formatMinifyJson` no domínio `FormatJsonContract`.

##### `op formatPrettyJson`
```flux
op formatPrettyJson (as string: json_text, as int64: indent_size) as string
```
- **Parâmetros**:
  - `json_text` (`string`): Parâmetro de entrada para processamento da operação.
  - `indent_size` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `formatPrettyJson` no domínio `FormatJsonContract`.

##### `op parseJson`
```flux
op parseJson (as string: json_text) as data
```
- **Parâmetros**:
  - `json_text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `parseJson` no domínio `FormatJsonContract`.

##### `op stringifyJson`
```flux
op stringifyJson (as data: val) as string
```
- **Parâmetros**:
  - `val` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringifyJson` no domínio `FormatJsonContract`.

##### `op isValidJson`
```flux
op isValidJson (as string: json_text) as bool
```
- **Parâmetros**:
  - `json_text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `isValidJson` no domínio `FormatJsonContract`.

##### `op minifyJson`
```flux
op minifyJson (as string: json_text) as string
```
- **Parâmetros**:
  - `json_text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `minifyJson` no domínio `FormatJsonContract`.

##### `op prettyJson`
```flux
op prettyJson (as string: json_text, as int64: indent_size) as string
```
- **Parâmetros**:
  - `json_text` (`string`): Parâmetro de entrada para processamento da operação.
  - `indent_size` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `prettyJson` no domínio `FormatJsonContract`.

### 4.4 Contrato `FormatTomlContract` (`FormatToml.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `formatParseToml` | `op formatParseToml (as string: toml_text) as map` | `map` |
| `formatStringifyToml` | `op formatStringifyToml (as map: data_map) as string` | `string` |
| `formatIsValidToml` | `op formatIsValidToml (as string: toml_text) as bool` | `bool` |
| `parseToml` | `op parseToml (as string: toml_text) as map` | `map` |
| `stringifyToml` | `op stringifyToml (as map: data_map) as string` | `string` |
| `isValidToml` | `op isValidToml (as string: toml_text) as bool` | `bool` |

#### Ficha Técnica das Operações:

##### `op formatParseToml`
```flux
op formatParseToml (as string: toml_text) as map
```
- **Parâmetros**:
  - `toml_text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `formatParseToml` no domínio `FormatTomlContract`.

##### `op formatStringifyToml`
```flux
op formatStringifyToml (as map: data_map) as string
```
- **Parâmetros**:
  - `data_map` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `formatStringifyToml` no domínio `FormatTomlContract`.

##### `op formatIsValidToml`
```flux
op formatIsValidToml (as string: toml_text) as bool
```
- **Parâmetros**:
  - `toml_text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `formatIsValidToml` no domínio `FormatTomlContract`.

##### `op parseToml`
```flux
op parseToml (as string: toml_text) as map
```
- **Parâmetros**:
  - `toml_text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `parseToml` no domínio `FormatTomlContract`.

##### `op stringifyToml`
```flux
op stringifyToml (as map: data_map) as string
```
- **Parâmetros**:
  - `data_map` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringifyToml` no domínio `FormatTomlContract`.

##### `op isValidToml`
```flux
op isValidToml (as string: toml_text) as bool
```
- **Parâmetros**:
  - `toml_text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `isValidToml` no domínio `FormatTomlContract`.

### 4.5 Contrato `FormatYamlContract` (`FormatYaml.fdsl`)

| Operação | Assinatura | Retorno |
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

#### Ficha Técnica das Operações:

##### `op formatParseYaml`
```flux
op formatParseYaml (as string: yaml_text) as data
```
- **Parâmetros**:
  - `yaml_text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `formatParseYaml` no domínio `FormatYamlContract`.

##### `op formatParseYamlAll`
```flux
op formatParseYamlAll (as string: yaml_text) as list of data
```
- **Parâmetros**:
  - `yaml_text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `formatParseYamlAll` no domínio `FormatYamlContract`.

##### `op formatStringifyYaml`
```flux
op formatStringifyYaml (as data: val) as string
```
- **Parâmetros**:
  - `val` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `formatStringifyYaml` no domínio `FormatYamlContract`.

##### `op formatStringifyYamlAll`
```flux
op formatStringifyYamlAll (as list of data: docs) as string
```
- **Parâmetros**:
  - `docs` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `formatStringifyYamlAll` no domínio `FormatYamlContract`.

##### `op formatIsValidYaml`
```flux
op formatIsValidYaml (as string: yaml_text) as bool
```
- **Parâmetros**:
  - `yaml_text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `formatIsValidYaml` no domínio `FormatYamlContract`.

##### `op parseYaml`
```flux
op parseYaml (as string: yaml_text) as data
```
- **Parâmetros**:
  - `yaml_text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `parseYaml` no domínio `FormatYamlContract`.

##### `op parseYamlAll`
```flux
op parseYamlAll (as string: yaml_text) as list of data
```
- **Parâmetros**:
  - `yaml_text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `parseYamlAll` no domínio `FormatYamlContract`.

##### `op stringifyYaml`
```flux
op stringifyYaml (as data: val) as string
```
- **Parâmetros**:
  - `val` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringifyYaml` no domínio `FormatYamlContract`.

##### `op stringifyYamlAll`
```flux
op stringifyYamlAll (as list of data: docs) as string
```
- **Parâmetros**:
  - `docs` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `stringifyYamlAll` no domínio `FormatYamlContract`.

##### `op isValidYaml`
```flux
op isValidYaml (as string: yaml_text) as bool
```
- **Parâmetros**:
  - `yaml_text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `isValidYaml` no domínio `FormatYamlContract`.

---

## 5. Exemplos Canônicos de Uso em TheFlux

O exemplo a seguir demonstra a importação e o consumo prático da biblioteca:

```flux
# Exemplo Canônico de Consumo da FormatStdLib
use FormatStdLib

program (ExemploFormatStdLib) {
      println("==================================================")
      println("  Demonstracao da Standard Library: FormatStdLib")
      println("==================================================")

      # Chamada da operacao canônica
      mut as data: resultado = FormatStdLib::jsonEscape("text")
      println("Resultado obtido: " + resultado)

      println("Demonstracao concluida com sucesso.")
}
```

---

> [!TIP]
> Para consultar a visão arquitetural unificada de todas as bibliotecas, consulte o documento principal [StdLibs.md](../StdLibs.md).
