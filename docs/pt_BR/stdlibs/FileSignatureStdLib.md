# 📚 `FileSignatureStdLib` — Detecção de Formatos via Magic Numbers e Validação de Assinaturas

> **Pilar Arquitetural**: Pilar 1 (Núcleo, Texto & OO)  
> **Status**: ✅ Homologado com 100% de Paridade nos 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Arquivo Mestre**: `stdlib/FileSignatureStdLib/FileSignatureStdLib.fdsl`  
> **Modo de Importação**: `use FileSignatureStdLib` ou `use FileSignatureStdLib::<Modulo>::<operacao>`

---

## 1. Visão Geral e Funcionalidades

A biblioteca padrão **`FileSignatureStdLib`** integra o ecossistema oficial da linguagem TheFlux, fornecendo suporte de nível de sistema e algoritmos nativos certificados.

Identificação confiável de tipos MIME e formatos de arquivos reais através da inspeção de sequências mágicas (magic bytes) no cabeçalho binário, prevenindo spoofing de extensão e validando integridade estrutural e assinaturas de diretórios.

### 1.1 Características e Princípios de Design
- **Compilação e Fusão Estática**: Todos os módulos de domínio são fundidos no agente unificado `FileSignatureStdLib` em tempo de compilação, sem sobrecarga (*overhead*) de despacho indireto.
- **Isolamento e Segurança**: As operações verificam limites operacionais e utilizam despacho por contratos formais rigorosos.
- **Compatibilidade Multi-Backend**: Execução bit-a-bit idêntica em interpretador (`in`), bytecode (`vm`, `vmr`), nativo AOT (`llvm`) e WebAssembly (`wat`, `wasm`).

---

## 2. Estrutura Modular e Contratos

A biblioteca é composta por **4 módulos de domínio** e declara **17 operações públicas**:

| Arquivo de Domínio | Contrato Formal | Responsabilidade Principal | Qtd. Ops |
|---|---|---|:---:|
| `FileAuthSignature.fdsl` | `FileAuthSignatureContract` | Domínio especializado de `FileAuthSignature` | 3 |
| `FileDirectorySignature.fdsl` | `FileDirectorySignatureContract` | Domínio especializado de `FileDirectorySignature` | 4 |
| `FileFormatSignature.fdsl` | `FileFormatSignatureContract` | Domínio especializado de `FileFormatSignature` | 3 |
| `FileHashSignature.fdsl` | `FileHashSignatureContract` | Domínio especializado de `FileHashSignature` | 7 |

---

## 3. Tipos, Estruturas e Enumerações Públicas

A biblioteca `FileSignatureStdLib` opera diretamente com os tipos nativos e primitivos da linguagem TheFlux (`string`, `int64`, `float64`, `bool`, `list of data`, etc.), sem exigir tipos compostos adicionais.

---

## 4. Catálogo Detalhado de Operações por Domínio

### 4.1 Contrato `FileAuthSignatureContract` (`FileAuthSignature.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `fileHmacSha256` | `op fileHmacSha256 (as string: path, as string: key) as string` | `string` |
| `fileHmacMd5` | `op fileHmacMd5 (as string: path, as string: key) as string` | `string` |
| `fileVerifyHmac` | `op fileVerifyHmac (as string: path, as string: key, as string: expected_hmac) as bool` | `bool` |

#### Ficha Técnica das Operações:

##### `op fileHmacSha256`
```flux
op fileHmacSha256 (as string: path, as string: key) as string
```
- **Parâmetros**:
  - `path` (`string`): Parâmetro de entrada para processamento da operação.
  - `key` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `fileHmacSha256` no domínio `FileAuthSignatureContract`.

##### `op fileHmacMd5`
```flux
op fileHmacMd5 (as string: path, as string: key) as string
```
- **Parâmetros**:
  - `path` (`string`): Parâmetro de entrada para processamento da operação.
  - `key` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `fileHmacMd5` no domínio `FileAuthSignatureContract`.

##### `op fileVerifyHmac`
```flux
op fileVerifyHmac (as string: path, as string: key, as string: expected_hmac) as bool
```
- **Parâmetros**:
  - `path` (`string`): Parâmetro de entrada para processamento da operação.
  - `key` (`string`): Parâmetro de entrada para processamento da operação.
  - `expected_hmac` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `fileVerifyHmac` no domínio `FileAuthSignatureContract`.

### 4.2 Contrato `FileDirectorySignatureContract` (`FileDirectorySignature.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `fileSignDirectory` | `op fileSignDirectory (as string: dir_path) as list of data` | `list of data` |
| `fileFilterAndSign` | `op fileFilterAndSign (as string: dir_path, as string: extension) as list of data` | `list of data` |
| `fileCreateManifest` | `op fileCreateManifest (as string: dir_path) as string` | `string` |
| `fileChecksumManifest` | `op fileChecksumManifest (as string: manifest_content) as string` | `string` |

#### Ficha Técnica das Operações:

##### `op fileSignDirectory`
```flux
op fileSignDirectory (as string: dir_path) as list of data
```
- **Parâmetros**:
  - `dir_path` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `fileSignDirectory` no domínio `FileDirectorySignatureContract`.

##### `op fileFilterAndSign`
```flux
op fileFilterAndSign (as string: dir_path, as string: extension) as list of data
```
- **Parâmetros**:
  - `dir_path` (`string`): Parâmetro de entrada para processamento da operação.
  - `extension` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `fileFilterAndSign` no domínio `FileDirectorySignatureContract`.

##### `op fileCreateManifest`
```flux
op fileCreateManifest (as string: dir_path) as string
```
- **Parâmetros**:
  - `dir_path` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `fileCreateManifest` no domínio `FileDirectorySignatureContract`.

##### `op fileChecksumManifest`
```flux
op fileChecksumManifest (as string: manifest_content) as string
```
- **Parâmetros**:
  - `manifest_content` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `fileChecksumManifest` no domínio `FileDirectorySignatureContract`.

### 4.3 Contrato `FileFormatSignatureContract` (`FileFormatSignature.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `fileMagicBytes` | `op fileMagicBytes (as string: path, as int64: num_bytes) as string` | `string` |
| `fileDetectType` | `op fileDetectType (as string: path) as string` | `string` |
| `fileIsBinary` | `op fileIsBinary (as string: path) as bool` | `bool` |

#### Ficha Técnica das Operações:

##### `op fileMagicBytes`
```flux
op fileMagicBytes (as string: path, as int64: num_bytes) as string
```
- **Parâmetros**:
  - `path` (`string`): Parâmetro de entrada para processamento da operação.
  - `num_bytes` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `fileMagicBytes` no domínio `FileFormatSignatureContract`.

##### `op fileDetectType`
```flux
op fileDetectType (as string: path) as string
```
- **Parâmetros**:
  - `path` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `fileDetectType` no domínio `FileFormatSignatureContract`.

##### `op fileIsBinary`
```flux
op fileIsBinary (as string: path) as bool
```
- **Parâmetros**:
  - `path` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `fileIsBinary` no domínio `FileFormatSignatureContract`.

### 4.4 Contrato `FileHashSignatureContract` (`FileHashSignature.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `fileSha256` | `op fileSha256 (as string: path) as string` | `string` |
| `fileMd5` | `op fileMd5 (as string: path) as string` | `string` |
| `fileSha1` | `op fileSha1 (as string: path) as string` | `string` |
| `fileCrc32` | `op fileCrc32 (as string: path) as int64` | `int64` |
| `fileVerifySha256` | `op fileVerifySha256 (as string: path, as string: expected_hash) as bool` | `bool` |
| `fileVerifyMd5` | `op fileVerifyMd5 (as string: path, as string: expected_hash) as bool` | `bool` |
| `fileVerifyHash` | `op fileVerifyHash (as string: path, as string: expected_hash) as bool` | `bool` |

#### Ficha Técnica das Operações:

##### `op fileSha256`
```flux
op fileSha256 (as string: path) as string
```
- **Parâmetros**:
  - `path` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `fileSha256` no domínio `FileHashSignatureContract`.

##### `op fileMd5`
```flux
op fileMd5 (as string: path) as string
```
- **Parâmetros**:
  - `path` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `fileMd5` no domínio `FileHashSignatureContract`.

##### `op fileSha1`
```flux
op fileSha1 (as string: path) as string
```
- **Parâmetros**:
  - `path` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `fileSha1` no domínio `FileHashSignatureContract`.

##### `op fileCrc32`
```flux
op fileCrc32 (as string: path) as int64
```
- **Parâmetros**:
  - `path` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `fileCrc32` no domínio `FileHashSignatureContract`.

##### `op fileVerifySha256`
```flux
op fileVerifySha256 (as string: path, as string: expected_hash) as bool
```
- **Parâmetros**:
  - `path` (`string`): Parâmetro de entrada para processamento da operação.
  - `expected_hash` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `fileVerifySha256` no domínio `FileHashSignatureContract`.

##### `op fileVerifyMd5`
```flux
op fileVerifyMd5 (as string: path, as string: expected_hash) as bool
```
- **Parâmetros**:
  - `path` (`string`): Parâmetro de entrada para processamento da operação.
  - `expected_hash` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `fileVerifyMd5` no domínio `FileHashSignatureContract`.

##### `op fileVerifyHash`
```flux
op fileVerifyHash (as string: path, as string: expected_hash) as bool
```
- **Parâmetros**:
  - `path` (`string`): Parâmetro de entrada para processamento da operação.
  - `expected_hash` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `fileVerifyHash` no domínio `FileHashSignatureContract`.

---

## 5. Exemplos Canônicos de Uso em TheFlux

O exemplo a seguir demonstra a importação e o consumo prático da biblioteca:

```flux
# Exemplo Canônico de Consumo da FileSignatureStdLib
use FileSignatureStdLib

program (ExemploFileSignatureStdLib) {
      println("==================================================")
      println("  Demonstracao da Standard Library: FileSignatureStdLib")
      println("==================================================")

      # Chamada da operacao canônica
      mut as data: resultado = FileSignatureStdLib::detectFileFormat("app.exe")
      println("Resultado obtido: " + resultado)

      println("Demonstracao concluida com sucesso.")
}
```

---

> [!TIP]
> Para consultar a visão arquitetural unificada de todas as bibliotecas, consulte o documento principal [StdLibs.md](../StdLibs.md).
