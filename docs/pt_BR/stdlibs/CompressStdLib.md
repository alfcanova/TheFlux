# 📚 `CompressStdLib` — Compressão e Descompressão de Fluxos de Dados com Quotas Seguras

> **Pilar Arquitetural**: Pilar 2 (Estruturas & Estados)  
> **Status**: ✅ Homologado com 100% de Paridade nos 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Arquivo Mestre**: `stdlib/CompressStdLib/CompressStdLib.fdsl`  
> **Modo de Importação**: `use CompressStdLib` ou `use CompressStdLib::<Modulo>::<operacao>`

---

## 1. Visão Geral e Funcionalidades

A biblioteca padrão **`CompressStdLib`** integra o ecossistema oficial da linguagem TheFlux, fornecendo suporte de nível de sistema e algoritmos nativos certificados.

Implementa motores nativos de compactação e descompactação de memória e streams para GZIP, DEFLATE, ZLIB, BZIP2, LZMA, XZ e ZSTD. Inclui suporte a limites de expansão (DecompressQuota) para proteção contra ataques do tipo Zip-Bomb.

### 1.1 Características e Princípios de Design
- **Compilação e Fusão Estática**: Todos os módulos de domínio são fundidos no agente unificado `CompressStdLib` em tempo de compilação, sem sobrecarga (*overhead*) de despacho indireto.
- **Isolamento e Segurança**: As operações verificam limites operacionais e utilizam despacho por contratos formais rigorosos.
- **Compatibilidade Multi-Backend**: Execução bit-a-bit idêntica em interpretador (`in`), bytecode (`vm`, `vmr`), nativo AOT (`llvm`) e WebAssembly (`wat`, `wasm`).

---

## 2. Estrutura Modular e Contratos

A biblioteca é composta por **8 módulos de domínio** e declara **49 operações públicas**:

| Arquivo de Domínio | Contrato Formal | Responsabilidade Principal | Qtd. Ops |
|---|---|---|:---:|
| `CompressBzip2.fdsl` | `CompressBzip2Contract` | Domínio especializado de `CompressBzip2` | 5 |
| `CompressDeflate.fdsl` | `CompressDeflateContract` | Domínio especializado de `CompressDeflate` | 5 |
| `CompressGzip.fdsl` | `CompressGzipContract` | Domínio especializado de `CompressGzip` | 7 |
| `CompressInspection.fdsl` | `CompressInspectionContract` | Domínio especializado de `CompressInspection` | 6 |
| `CompressLzma.fdsl` | `CompressLzmaContract` | Domínio especializado de `CompressLzma` | 5 |
| `CompressXz.fdsl` | `CompressXzContract` | Domínio especializado de `CompressXz` | 9 |
| `CompressZlib.fdsl` | `CompressZlibContract` | Domínio especializado de `CompressZlib` | 6 |
| `CompressZstd.fdsl` | `CompressZstdContract` | Domínio especializado de `CompressZstd` | 6 |

---

## 3. Tipos, Estruturas e Enumerações Públicas

### Estrutura `struct (CompressStats)`
*Declarada em: `CompressStdLib.fdsl`*

```flux
struct (CompressStats) {
      imut: .uncompressed_size: int64
      imut: .compressed_size: int64
      imut: .ratio: float64
      imut: .savings_percent: float64
      imut: .format: CompressFormat
}
```

### Estrutura `struct (DecompressQuota)`
*Declarada em: `CompressStdLib.fdsl`*

```flux
struct (DecompressQuota) {
      mut: .max_bytes: int64
      mut: .strict_abort: bool
}
```

### Enumeração `enum (CompressFormat)`
*Declarada em: `CompressStdLib.fdsl`*

```flux
enum (CompressFormat) {
      DEFLATE
      ZLIB
      GZIP
      BZIP2
      LZMA
      LZMA2
      XZ
      ZSTD
      BROTLI
      ZIP
      TAR
      SEVEN_ZIP
      RAR
      UNKNOWN
}
```

---

## 4. Catálogo Detalhado de Operações por Domínio

### 4.1 Contrato `CompressBzip2Contract` (`CompressBzip2.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `compressBzip2` | `op compressBzip2 (as string: input_data) as string` | `string` |
| `compressBzip2Level` | `op compressBzip2Level (as string: input_data, as int64: level) as string` | `string` |
| `decompressBzip2` | `op decompressBzip2 (as string: compressed_data) as string` | `string` |
| `decompressBzip2Safe` | `op decompressBzip2Safe (as string: compressed_data, as DecompressQuota: quota) as string` | `string` |
| `compressIsBzip2` | `op compressIsBzip2 (as string: compressed_data) as bool` | `bool` |

#### Ficha Técnica das Operações:

##### `op compressBzip2`
```flux
op compressBzip2 (as string: input_data) as string
```
- **Parâmetros**:
  - `input_data` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `compressBzip2` no domínio `CompressBzip2Contract`.

##### `op compressBzip2Level`
```flux
op compressBzip2Level (as string: input_data, as int64: level) as string
```
- **Parâmetros**:
  - `input_data` (`string`): Parâmetro de entrada para processamento da operação.
  - `level` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `compressBzip2Level` no domínio `CompressBzip2Contract`.

##### `op decompressBzip2`
```flux
op decompressBzip2 (as string: compressed_data) as string
```
- **Parâmetros**:
  - `compressed_data` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ⚠️ Emite `fail` com status `"erro na descompressao bzip2"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `decompressBzip2` no domínio `CompressBzip2Contract`.

##### `op decompressBzip2Safe`
```flux
op decompressBzip2Safe (as string: compressed_data, as DecompressQuota: quota) as string
```
- **Parâmetros**:
  - `compressed_data` (`string`): Parâmetro de entrada para processamento da operação.
  - `quota` (`DecompressQuota`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ⚠️ Emite `fail` com status `"quota de seguranca excedida na descompressao bzip2"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `decompressBzip2Safe` no domínio `CompressBzip2Contract`.

##### `op compressIsBzip2`
```flux
op compressIsBzip2 (as string: compressed_data) as bool
```
- **Parâmetros**:
  - `compressed_data` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `compressIsBzip2` no domínio `CompressBzip2Contract`.

### 4.2 Contrato `CompressDeflateContract` (`CompressDeflate.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `compressDeflate` | `op compressDeflate (as string: input_data) as string` | `string` |
| `compressDeflateLevel` | `op compressDeflateLevel (as string: input_data, as int64: level) as string` | `string` |
| `decompressDeflate` | `op decompressDeflate (as string: compressed_data) as string` | `string` |
| `decompressDeflateSafe` | `op decompressDeflateSafe (as string: compressed_data, as DecompressQuota: quota) as string` | `string` |
| `compressIsDeflate` | `op compressIsDeflate (as string: compressed_data) as bool` | `bool` |

#### Ficha Técnica das Operações:

##### `op compressDeflate`
```flux
op compressDeflate (as string: input_data) as string
```
- **Parâmetros**:
  - `input_data` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `compressDeflate` no domínio `CompressDeflateContract`.

##### `op compressDeflateLevel`
```flux
op compressDeflateLevel (as string: input_data, as int64: level) as string
```
- **Parâmetros**:
  - `input_data` (`string`): Parâmetro de entrada para processamento da operação.
  - `level` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `compressDeflateLevel` no domínio `CompressDeflateContract`.

##### `op decompressDeflate`
```flux
op decompressDeflate (as string: compressed_data) as string
```
- **Parâmetros**:
  - `compressed_data` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ⚠️ Emite `fail` com status `"erro na descompressao deflate"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `decompressDeflate` no domínio `CompressDeflateContract`.

##### `op decompressDeflateSafe`
```flux
op decompressDeflateSafe (as string: compressed_data, as DecompressQuota: quota) as string
```
- **Parâmetros**:
  - `compressed_data` (`string`): Parâmetro de entrada para processamento da operação.
  - `quota` (`DecompressQuota`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ⚠️ Emite `fail` com status `"quota de seguranca excedida na descompressao deflate"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `decompressDeflateSafe` no domínio `CompressDeflateContract`.

##### `op compressIsDeflate`
```flux
op compressIsDeflate (as string: compressed_data) as bool
```
- **Parâmetros**:
  - `compressed_data` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `compressIsDeflate` no domínio `CompressDeflateContract`.

### 4.3 Contrato `CompressGzipContract` (`CompressGzip.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `compressGzip` | `op compressGzip (as string: input_data) as string` | `string` |
| `compressGzipLevel` | `op compressGzipLevel (as string: input_data, as int64: level) as string` | `string` |
| `decompressGzip` | `op decompressGzip (as string: compressed_data) as string` | `string` |
| `decompressGzipSafe` | `op decompressGzipSafe (as string: compressed_data, as DecompressQuota: quota) as string` | `string` |
| `compressIsGzip` | `op compressIsGzip (as string: compressed_data) as bool` | `bool` |
| `compressGzipCrc32` | `op compressGzipCrc32 (as string: compressed_data) as int64` | `int64` |
| `compressGzipTimestamp` | `op compressGzipTimestamp (as string: compressed_data) as int64` | `int64` |

#### Ficha Técnica das Operações:

##### `op compressGzip`
```flux
op compressGzip (as string: input_data) as string
```
- **Parâmetros**:
  - `input_data` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `compressGzip` no domínio `CompressGzipContract`.

##### `op compressGzipLevel`
```flux
op compressGzipLevel (as string: input_data, as int64: level) as string
```
- **Parâmetros**:
  - `input_data` (`string`): Parâmetro de entrada para processamento da operação.
  - `level` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `compressGzipLevel` no domínio `CompressGzipContract`.

##### `op decompressGzip`
```flux
op decompressGzip (as string: compressed_data) as string
```
- **Parâmetros**:
  - `compressed_data` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ⚠️ Emite `fail` com status `"erro na descompressao gzip"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `decompressGzip` no domínio `CompressGzipContract`.

##### `op decompressGzipSafe`
```flux
op decompressGzipSafe (as string: compressed_data, as DecompressQuota: quota) as string
```
- **Parâmetros**:
  - `compressed_data` (`string`): Parâmetro de entrada para processamento da operação.
  - `quota` (`DecompressQuota`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ⚠️ Emite `fail` com status `"quota de seguranca excedida na descompressao gzip"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `decompressGzipSafe` no domínio `CompressGzipContract`.

##### `op compressIsGzip`
```flux
op compressIsGzip (as string: compressed_data) as bool
```
- **Parâmetros**:
  - `compressed_data` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `compressIsGzip` no domínio `CompressGzipContract`.

##### `op compressGzipCrc32`
```flux
op compressGzipCrc32 (as string: compressed_data) as int64
```
- **Parâmetros**:
  - `compressed_data` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `compressGzipCrc32` no domínio `CompressGzipContract`.

##### `op compressGzipTimestamp`
```flux
op compressGzipTimestamp (as string: compressed_data) as int64
```
- **Parâmetros**:
  - `compressed_data` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `compressGzipTimestamp` no domínio `CompressGzipContract`.

### 4.4 Contrato `CompressInspectionContract` (`CompressInspection.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `compressEstimateDecompressedSize` | `op compressEstimateDecompressedSize (as string: compressed_data) as int64` | `int64` |
| `compressDetectFormat` | `op compressDetectFormat (as string: compressed_data) as string` | `string` |
| `compressStats` | `op compressStats (as string: uncompressed, as string: compressed) as CompressStats` | `CompressStats` |
| `decompressAuto` | `op decompressAuto (as string: compressed_data) as string` | `string` |
| `compressIsEffective` | `op compressIsEffective (as string: uncompressed, as string: compressed) as bool` | `bool` |
| `compressIsFormatSupported` | `op compressIsFormatSupported (as string: format_name) as bool` | `bool` |

#### Ficha Técnica das Operações:

##### `op compressEstimateDecompressedSize`
```flux
op compressEstimateDecompressedSize (as string: compressed_data) as int64
```
- **Parâmetros**:
  - `compressed_data` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `compressEstimateDecompressedSize` no domínio `CompressInspectionContract`.

##### `op compressDetectFormat`
```flux
op compressDetectFormat (as string: compressed_data) as string
```
- **Parâmetros**:
  - `compressed_data` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `compressDetectFormat` no domínio `CompressInspectionContract`.

##### `op compressStats`
```flux
op compressStats (as string: uncompressed, as string: compressed) as CompressStats
```
- **Parâmetros**:
  - `uncompressed` (`string`): Parâmetro de entrada para processamento da operação.
  - `compressed` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `CompressStats`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `compressStats` no domínio `CompressInspectionContract`.

##### `op decompressAuto`
```flux
op decompressAuto (as string: compressed_data) as string
```
- **Parâmetros**:
  - `compressed_data` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ⚠️ Emite `fail` com status `"formato nao suportado ou falha na auto-descompressao"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `decompressAuto` no domínio `CompressInspectionContract`.

##### `op compressIsEffective`
```flux
op compressIsEffective (as string: uncompressed, as string: compressed) as bool
```
- **Parâmetros**:
  - `uncompressed` (`string`): Parâmetro de entrada para processamento da operação.
  - `compressed` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `compressIsEffective` no domínio `CompressInspectionContract`.

##### `op compressIsFormatSupported`
```flux
op compressIsFormatSupported (as string: format_name) as bool
```
- **Parâmetros**:
  - `format_name` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `compressIsFormatSupported` no domínio `CompressInspectionContract`.

### 4.5 Contrato `CompressLzmaContract` (`CompressLzma.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `compressLzma` | `op compressLzma (as string: input_data) as string` | `string` |
| `compressLzmaLevel` | `op compressLzmaLevel (as string: input_data, as int64: level) as string` | `string` |
| `decompressLzma` | `op decompressLzma (as string: compressed_data) as string` | `string` |
| `decompressLzmaSafe` | `op decompressLzmaSafe (as string: compressed_data, as DecompressQuota: quota) as string` | `string` |
| `compressIsLzma` | `op compressIsLzma (as string: compressed_data) as bool` | `bool` |

#### Ficha Técnica das Operações:

##### `op compressLzma`
```flux
op compressLzma (as string: input_data) as string
```
- **Parâmetros**:
  - `input_data` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `compressLzma` no domínio `CompressLzmaContract`.

##### `op compressLzmaLevel`
```flux
op compressLzmaLevel (as string: input_data, as int64: level) as string
```
- **Parâmetros**:
  - `input_data` (`string`): Parâmetro de entrada para processamento da operação.
  - `level` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `compressLzmaLevel` no domínio `CompressLzmaContract`.

##### `op decompressLzma`
```flux
op decompressLzma (as string: compressed_data) as string
```
- **Parâmetros**:
  - `compressed_data` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ⚠️ Emite `fail` com status `"erro na descompressao lzma"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `decompressLzma` no domínio `CompressLzmaContract`.

##### `op decompressLzmaSafe`
```flux
op decompressLzmaSafe (as string: compressed_data, as DecompressQuota: quota) as string
```
- **Parâmetros**:
  - `compressed_data` (`string`): Parâmetro de entrada para processamento da operação.
  - `quota` (`DecompressQuota`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ⚠️ Emite `fail` com status `"quota de seguranca excedida na descompressao lzma"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `decompressLzmaSafe` no domínio `CompressLzmaContract`.

##### `op compressIsLzma`
```flux
op compressIsLzma (as string: compressed_data) as bool
```
- **Parâmetros**:
  - `compressed_data` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `compressIsLzma` no domínio `CompressLzmaContract`.

### 4.6 Contrato `CompressXzContract` (`CompressXz.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `compressLzma2` | `op compressLzma2 (as string: input_data) as string` | `string` |
| `compressLzma2Level` | `op compressLzma2Level (as string: input_data, as int64: level) as string` | `string` |
| `decompressLzma2` | `op decompressLzma2 (as string: compressed_data) as string` | `string` |
| `decompressLzma2Safe` | `op decompressLzma2Safe (as string: compressed_data, as DecompressQuota: quota) as string` | `string` |
| `compressXz` | `op compressXz (as string: input_data) as string` | `string` |
| `compressXzLevel` | `op compressXzLevel (as string: input_data, as int64: level) as string` | `string` |
| `decompressXz` | `op decompressXz (as string: compressed_data) as string` | `string` |
| `decompressXzSafe` | `op decompressXzSafe (as string: compressed_data, as DecompressQuota: quota) as string` | `string` |
| `compressIsXz` | `op compressIsXz (as string: compressed_data) as bool` | `bool` |

#### Ficha Técnica das Operações:

##### `op compressLzma2`
```flux
op compressLzma2 (as string: input_data) as string
```
- **Parâmetros**:
  - `input_data` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `compressLzma2` no domínio `CompressXzContract`.

##### `op compressLzma2Level`
```flux
op compressLzma2Level (as string: input_data, as int64: level) as string
```
- **Parâmetros**:
  - `input_data` (`string`): Parâmetro de entrada para processamento da operação.
  - `level` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `compressLzma2Level` no domínio `CompressXzContract`.

##### `op decompressLzma2`
```flux
op decompressLzma2 (as string: compressed_data) as string
```
- **Parâmetros**:
  - `compressed_data` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ⚠️ Emite `fail` com status `"erro na descompressao lzma2"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `decompressLzma2` no domínio `CompressXzContract`.

##### `op decompressLzma2Safe`
```flux
op decompressLzma2Safe (as string: compressed_data, as DecompressQuota: quota) as string
```
- **Parâmetros**:
  - `compressed_data` (`string`): Parâmetro de entrada para processamento da operação.
  - `quota` (`DecompressQuota`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ⚠️ Emite `fail` com status `"quota de seguranca excedida na descompressao lzma2"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `decompressLzma2Safe` no domínio `CompressXzContract`.

##### `op compressXz`
```flux
op compressXz (as string: input_data) as string
```
- **Parâmetros**:
  - `input_data` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `compressXz` no domínio `CompressXzContract`.

##### `op compressXzLevel`
```flux
op compressXzLevel (as string: input_data, as int64: level) as string
```
- **Parâmetros**:
  - `input_data` (`string`): Parâmetro de entrada para processamento da operação.
  - `level` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `compressXzLevel` no domínio `CompressXzContract`.

##### `op decompressXz`
```flux
op decompressXz (as string: compressed_data) as string
```
- **Parâmetros**:
  - `compressed_data` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ⚠️ Emite `fail` com status `"erro na descompressao xz"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `decompressXz` no domínio `CompressXzContract`.

##### `op decompressXzSafe`
```flux
op decompressXzSafe (as string: compressed_data, as DecompressQuota: quota) as string
```
- **Parâmetros**:
  - `compressed_data` (`string`): Parâmetro de entrada para processamento da operação.
  - `quota` (`DecompressQuota`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ⚠️ Emite `fail` com status `"quota de seguranca excedida na descompressao xz"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `decompressXzSafe` no domínio `CompressXzContract`.

##### `op compressIsXz`
```flux
op compressIsXz (as string: compressed_data) as bool
```
- **Parâmetros**:
  - `compressed_data` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `compressIsXz` no domínio `CompressXzContract`.

### 4.7 Contrato `CompressZlibContract` (`CompressZlib.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `compressZlib` | `op compressZlib (as string: input_data) as string` | `string` |
| `compressZlibLevel` | `op compressZlibLevel (as string: input_data, as int64: level) as string` | `string` |
| `decompressZlib` | `op decompressZlib (as string: compressed_data) as string` | `string` |
| `decompressZlibSafe` | `op decompressZlibSafe (as string: compressed_data, as DecompressQuota: quota) as string` | `string` |
| `compressIsZlib` | `op compressIsZlib (as string: compressed_data) as bool` | `bool` |
| `compressZlibAdler32` | `op compressZlibAdler32 (as string: compressed_data) as int64` | `int64` |

#### Ficha Técnica das Operações:

##### `op compressZlib`
```flux
op compressZlib (as string: input_data) as string
```
- **Parâmetros**:
  - `input_data` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `compressZlib` no domínio `CompressZlibContract`.

##### `op compressZlibLevel`
```flux
op compressZlibLevel (as string: input_data, as int64: level) as string
```
- **Parâmetros**:
  - `input_data` (`string`): Parâmetro de entrada para processamento da operação.
  - `level` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `compressZlibLevel` no domínio `CompressZlibContract`.

##### `op decompressZlib`
```flux
op decompressZlib (as string: compressed_data) as string
```
- **Parâmetros**:
  - `compressed_data` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ⚠️ Emite `fail` com status `"erro na descompressao zlib"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `decompressZlib` no domínio `CompressZlibContract`.

##### `op decompressZlibSafe`
```flux
op decompressZlibSafe (as string: compressed_data, as DecompressQuota: quota) as string
```
- **Parâmetros**:
  - `compressed_data` (`string`): Parâmetro de entrada para processamento da operação.
  - `quota` (`DecompressQuota`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ⚠️ Emite `fail` com status `"quota de seguranca excedida na descompressao zlib"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `decompressZlibSafe` no domínio `CompressZlibContract`.

##### `op compressIsZlib`
```flux
op compressIsZlib (as string: compressed_data) as bool
```
- **Parâmetros**:
  - `compressed_data` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `compressIsZlib` no domínio `CompressZlibContract`.

##### `op compressZlibAdler32`
```flux
op compressZlibAdler32 (as string: compressed_data) as int64
```
- **Parâmetros**:
  - `compressed_data` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `compressZlibAdler32` no domínio `CompressZlibContract`.

### 4.8 Contrato `CompressZstdContract` (`CompressZstd.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `compressZstd` | `op compressZstd (as string: input_data) as string` | `string` |
| `compressZstdLevel` | `op compressZstdLevel (as string: input_data, as int64: level) as string` | `string` |
| `decompressZstd` | `op decompressZstd (as string: compressed_data) as string` | `string` |
| `decompressZstdSafe` | `op decompressZstdSafe (as string: compressed_data, as DecompressQuota: quota) as string` | `string` |
| `compressIsZstd` | `op compressIsZstd (as string: compressed_data) as bool` | `bool` |
| `compressZstdFrameSize` | `op compressZstdFrameSize (as string: compressed_data) as int64` | `int64` |

#### Ficha Técnica das Operações:

##### `op compressZstd`
```flux
op compressZstd (as string: input_data) as string
```
- **Parâmetros**:
  - `input_data` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `compressZstd` no domínio `CompressZstdContract`.

##### `op compressZstdLevel`
```flux
op compressZstdLevel (as string: input_data, as int64: level) as string
```
- **Parâmetros**:
  - `input_data` (`string`): Parâmetro de entrada para processamento da operação.
  - `level` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `compressZstdLevel` no domínio `CompressZstdContract`.

##### `op decompressZstd`
```flux
op decompressZstd (as string: compressed_data) as string
```
- **Parâmetros**:
  - `compressed_data` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ⚠️ Emite `fail` com status `"erro na descompressao zstd"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `decompressZstd` no domínio `CompressZstdContract`.

##### `op decompressZstdSafe`
```flux
op decompressZstdSafe (as string: compressed_data, as DecompressQuota: quota) as string
```
- **Parâmetros**:
  - `compressed_data` (`string`): Parâmetro de entrada para processamento da operação.
  - `quota` (`DecompressQuota`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ⚠️ Emite `fail` com status `"quota de seguranca excedida na descompressao zstd"`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `decompressZstdSafe` no domínio `CompressZstdContract`.

##### `op compressIsZstd`
```flux
op compressIsZstd (as string: compressed_data) as bool
```
- **Parâmetros**:
  - `compressed_data` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `compressIsZstd` no domínio `CompressZstdContract`.

##### `op compressZstdFrameSize`
```flux
op compressZstdFrameSize (as string: compressed_data) as int64
```
- **Parâmetros**:
  - `compressed_data` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `compressZstdFrameSize` no domínio `CompressZstdContract`.

---

## 5. Exemplos Canônicos de Uso em TheFlux

O exemplo a seguir demonstra a importação e o consumo prático da biblioteca:

```flux
# Exemplo Canônico de Consumo da CompressStdLib
use CompressStdLib

program (ExemploCompressStdLib) {
      println("==================================================")
      println("  Demonstracao da Standard Library: CompressStdLib")
      println("==================================================")

      # Chamada da operacao canônica
      mut as data: resultado = CompressStdLib::compressGzip("TheFlux Standard Library")
      println("Resultado obtido: " + resultado)

      println("Demonstracao concluida com sucesso.")
}
```

---

> [!TIP]
> Para consultar a visão arquitetural unificada de todas as bibliotecas, consulte o documento principal [StdLibs.md](../StdLibs.md).
