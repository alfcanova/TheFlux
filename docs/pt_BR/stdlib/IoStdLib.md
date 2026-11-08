# 📚 `IoStdLib` — Entrada e Saída em Arquivos, Buffers, Streams e Diretórios

> **Pilar Arquitetural**: Pilar 4 (Sistema, I/O & Rede)  
> **Status**: ✅ Homologado com 100% de Paridade nos 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Arquivo Mestre**: `stdlib/IoStdLib/IoStdLib.fdsl`  
> **Modo de Importação**: `use IoStdLib` ou `use IoStdLib::<Modulo>::<operacao>`

---

## 1. Visão Geral e Funcionalidades

A biblioteca padrão **`IoStdLib`** integra o ecossistema oficial da linguagem TheFlux, fornecendo suporte de nível de sistema e algoritmos nativos certificados.

Operações de I/O de alta velocidade do sistema: leitura e gravação atômica em arquivos de texto e binários, manipulação de arquivos mapeados em memória (mmap), navegação de diretórios, pipes unidirecionais e streams com bufferização ajustável.

### 1.1 Características e Princípios de Design
- **Compilação e Fusão Estática**: Todos os módulos de domínio são fundidos no agente unificado `IoStdLib` em tempo de compilação, sem sobrecarga (*overhead*) de despacho indireto.
- **Isolamento e Segurança**: As operações verificam limites operacionais e utilizam despacho por contratos formais rigorosos.
- **Compatibilidade Multi-Backend**: Execução bit-a-bit idêntica em interpretador (`in`), bytecode (`vm`, `vmr`), nativo AOT (`llvm`) e WebAssembly (`wat`, `wasm`).

---

## 2. Estrutura Modular e Contratos

A biblioteca é composta por **9 módulos de domínio** e declara **51 operações públicas**:

| Arquivo de Domínio | Contrato Formal | Responsabilidade Principal | Qtd. Ops |
|---|---|---|:---:|
| `IoArchive.fdsl` | `IoArchiveContract` | Domínio especializado de `IoArchive` | 19 |
| `IoBinaryFile.fdsl` | `IoBinaryFileContract` | Domínio especializado de `IoBinaryFile` | 6 |
| `IoDirectory.fdsl` | `IoDirectoryContract` | Domínio especializado de `IoDirectory` | 4 |
| `IoFile.fdsl` | `IoFileContract` | Domínio especializado de `IoFile` | 6 |
| `IoFileInspection.fdsl` | `IoFileInspectionContract` | Domínio especializado de `IoFileInspection` | 3 |
| `IoFileLine.fdsl` | `IoFileLineContract` | Domínio especializado de `IoFileLine` | 3 |
| `IoInput.fdsl` | `IoInputContract` | Domínio especializado de `IoInput` | 2 |
| `IoPath.fdsl` | `IoPathContract` | Domínio especializado de `IoPath` | 4 |
| `IoPrint.fdsl` | `IoPrintContract` | Domínio especializado de `IoPrint` | 4 |

---

## 3. Tipos, Estruturas e Enumerações Públicas

A biblioteca `IoStdLib` opera diretamente com os tipos nativos e primitivos da linguagem TheFlux (`string`, `int64`, `float64`, `bool`, `list of data`, etc.), sem exigir tipos compostos adicionais.

---

## 4. Catálogo Detalhado de Operações por Domínio

### 4.1 Contrato `IoArchiveContract` (`IoArchive.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `archiveZip` | `op archiveZip (as string: src_path, as string: dst_zip) as bool` | `bool` |
| `archiveUnzip` | `op archiveUnzip (as string: src_zip, as string: dst_dir) as bool` | `bool` |
| `archiveTar` | `op archiveTar (as string: src_path, as string: dst_tar) as bool` | `bool` |
| `archiveExtractTar` | `op archiveExtractTar (as string: src_tar, as string: dst_dir) as bool` | `bool` |
| `archiveTarGz` | `op archiveTarGz (as string: src_path, as string: dst_targz) as bool` | `bool` |
| `archiveExtractTarGz` | `op archiveExtractTarGz (as string: src_targz, as string: dst_dir) as bool` | `bool` |
| `archiveTarBz2` | `op archiveTarBz2 (as string: src_path, as string: dst_tarbz2) as bool` | `bool` |
| `archiveExtractTarBz2` | `op archiveExtractTarBz2 (as string: src_tarbz2, as string: dst_dir) as bool` | `bool` |
| `archiveTarXz` | `op archiveTarXz (as string: src_path, as string: dst_tarxz) as bool` | `bool` |
| `archiveExtractTarXz` | `op archiveExtractTarXz (as string: src_tarxz, as string: dst_dir) as bool` | `bool` |
| `archiveTarZst` | `op archiveTarZst (as string: src_path, as string: dst_tarzst) as bool` | `bool` |
| `archiveExtractTarZst` | `op archiveExtractTarZst (as string: src_tarzst, as string: dst_dir) as bool` | `bool` |
| `archiveCreate7z` | `op archiveCreate7z (as string: src_path, as string: dst_7z) as bool` | `bool` |
| `archiveExtract7z` | `op archiveExtract7z (as string: src_7z, as string: dst_dir) as bool` | `bool` |
| `archiveExtractRar` | `op archiveExtractRar (as string: src_rar, as string: dst_dir) as bool` | `bool` |
| `archiveListFiles` | `op archiveListFiles (as string: archive_path) as list of data` | `list of data` |
| `archiveExtractFile` | `op archiveExtractFile (as string: archive_path, as string: entry_name, as string: dst_dir) as bool` | `bool` |
| `archiveIsArchive` | `op archiveIsArchive (as string: file_path) as bool` | `bool` |
| `archiveDetectFormat` | `op archiveDetectFormat (as string: file_path) as string` | `string` |

#### Ficha Técnica das Operações:

##### `op archiveZip`
```flux
op archiveZip (as string: src_path, as string: dst_zip) as bool
```
- **Parâmetros**:
  - `src_path` (`string`): Parâmetro de entrada para processamento da operação.
  - `dst_zip` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `archiveZip` no domínio `IoArchiveContract`.

##### `op archiveUnzip`
```flux
op archiveUnzip (as string: src_zip, as string: dst_dir) as bool
```
- **Parâmetros**:
  - `src_zip` (`string`): Parâmetro de entrada para processamento da operação.
  - `dst_dir` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `archiveUnzip` no domínio `IoArchiveContract`.

##### `op archiveTar`
```flux
op archiveTar (as string: src_path, as string: dst_tar) as bool
```
- **Parâmetros**:
  - `src_path` (`string`): Parâmetro de entrada para processamento da operação.
  - `dst_tar` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `archiveTar` no domínio `IoArchiveContract`.

##### `op archiveExtractTar`
```flux
op archiveExtractTar (as string: src_tar, as string: dst_dir) as bool
```
- **Parâmetros**:
  - `src_tar` (`string`): Parâmetro de entrada para processamento da operação.
  - `dst_dir` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `archiveExtractTar` no domínio `IoArchiveContract`.

##### `op archiveTarGz`
```flux
op archiveTarGz (as string: src_path, as string: dst_targz) as bool
```
- **Parâmetros**:
  - `src_path` (`string`): Parâmetro de entrada para processamento da operação.
  - `dst_targz` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `archiveTarGz` no domínio `IoArchiveContract`.

##### `op archiveExtractTarGz`
```flux
op archiveExtractTarGz (as string: src_targz, as string: dst_dir) as bool
```
- **Parâmetros**:
  - `src_targz` (`string`): Parâmetro de entrada para processamento da operação.
  - `dst_dir` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `archiveExtractTarGz` no domínio `IoArchiveContract`.

##### `op archiveTarBz2`
```flux
op archiveTarBz2 (as string: src_path, as string: dst_tarbz2) as bool
```
- **Parâmetros**:
  - `src_path` (`string`): Parâmetro de entrada para processamento da operação.
  - `dst_tarbz2` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `archiveTarBz2` no domínio `IoArchiveContract`.

##### `op archiveExtractTarBz2`
```flux
op archiveExtractTarBz2 (as string: src_tarbz2, as string: dst_dir) as bool
```
- **Parâmetros**:
  - `src_tarbz2` (`string`): Parâmetro de entrada para processamento da operação.
  - `dst_dir` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `archiveExtractTarBz2` no domínio `IoArchiveContract`.

##### `op archiveTarXz`
```flux
op archiveTarXz (as string: src_path, as string: dst_tarxz) as bool
```
- **Parâmetros**:
  - `src_path` (`string`): Parâmetro de entrada para processamento da operação.
  - `dst_tarxz` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `archiveTarXz` no domínio `IoArchiveContract`.

##### `op archiveExtractTarXz`
```flux
op archiveExtractTarXz (as string: src_tarxz, as string: dst_dir) as bool
```
- **Parâmetros**:
  - `src_tarxz` (`string`): Parâmetro de entrada para processamento da operação.
  - `dst_dir` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `archiveExtractTarXz` no domínio `IoArchiveContract`.

##### `op archiveTarZst`
```flux
op archiveTarZst (as string: src_path, as string: dst_tarzst) as bool
```
- **Parâmetros**:
  - `src_path` (`string`): Parâmetro de entrada para processamento da operação.
  - `dst_tarzst` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `archiveTarZst` no domínio `IoArchiveContract`.

##### `op archiveExtractTarZst`
```flux
op archiveExtractTarZst (as string: src_tarzst, as string: dst_dir) as bool
```
- **Parâmetros**:
  - `src_tarzst` (`string`): Parâmetro de entrada para processamento da operação.
  - `dst_dir` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `archiveExtractTarZst` no domínio `IoArchiveContract`.

##### `op archiveCreate7z`
```flux
op archiveCreate7z (as string: src_path, as string: dst_7z) as bool
```
- **Parâmetros**:
  - `src_path` (`string`): Parâmetro de entrada para processamento da operação.
  - `dst_7z` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `archiveCreate7z` no domínio `IoArchiveContract`.

##### `op archiveExtract7z`
```flux
op archiveExtract7z (as string: src_7z, as string: dst_dir) as bool
```
- **Parâmetros**:
  - `src_7z` (`string`): Parâmetro de entrada para processamento da operação.
  - `dst_dir` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `archiveExtract7z` no domínio `IoArchiveContract`.

##### `op archiveExtractRar`
```flux
op archiveExtractRar (as string: src_rar, as string: dst_dir) as bool
```
- **Parâmetros**:
  - `src_rar` (`string`): Parâmetro de entrada para processamento da operação.
  - `dst_dir` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `archiveExtractRar` no domínio `IoArchiveContract`.

##### `op archiveListFiles`
```flux
op archiveListFiles (as string: archive_path) as list of data
```
- **Parâmetros**:
  - `archive_path` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `archiveListFiles` no domínio `IoArchiveContract`.

##### `op archiveExtractFile`
```flux
op archiveExtractFile (as string: archive_path, as string: entry_name, as string: dst_dir) as bool
```
- **Parâmetros**:
  - `archive_path` (`string`): Parâmetro de entrada para processamento da operação.
  - `entry_name` (`string`): Parâmetro de entrada para processamento da operação.
  - `dst_dir` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `archiveExtractFile` no domínio `IoArchiveContract`.

##### `op archiveIsArchive`
```flux
op archiveIsArchive (as string: file_path) as bool
```
- **Parâmetros**:
  - `file_path` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `archiveIsArchive` no domínio `IoArchiveContract`.

##### `op archiveDetectFormat`
```flux
op archiveDetectFormat (as string: file_path) as string
```
- **Parâmetros**:
  - `file_path` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `archiveDetectFormat` no domínio `IoArchiveContract`.

### 4.2 Contrato `IoBinaryFileContract` (`IoBinaryFile.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `readBinaryFile` | `op readBinaryFile (as string: path) as string` | `string` |
| `writeBinaryFile` | `op writeBinaryFile (as string: path, as string: content) as string` | `string` |
| `readHexFile` | `op readHexFile (as string: path) as string` | `string` |
| `writeHexFile` | `op writeHexFile (as string: path, as string: hex_content) as string` | `string` |
| `readBase64File` | `op readBase64File (as string: path) as string` | `string` |
| `writeBase64File` | `op writeBase64File (as string: path, as string: b64_content) as string` | `string` |

#### Ficha Técnica das Operações:

##### `op readBinaryFile`
```flux
op readBinaryFile (as string: path) as string
```
- **Parâmetros**:
  - `path` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `readBinaryFile` no domínio `IoBinaryFileContract`.

##### `op writeBinaryFile`
```flux
op writeBinaryFile (as string: path, as string: content) as string
```
- **Parâmetros**:
  - `path` (`string`): Parâmetro de entrada para processamento da operação.
  - `content` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `writeBinaryFile` no domínio `IoBinaryFileContract`.

##### `op readHexFile`
```flux
op readHexFile (as string: path) as string
```
- **Parâmetros**:
  - `path` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `readHexFile` no domínio `IoBinaryFileContract`.

##### `op writeHexFile`
```flux
op writeHexFile (as string: path, as string: hex_content) as string
```
- **Parâmetros**:
  - `path` (`string`): Parâmetro de entrada para processamento da operação.
  - `hex_content` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `writeHexFile` no domínio `IoBinaryFileContract`.

##### `op readBase64File`
```flux
op readBase64File (as string: path) as string
```
- **Parâmetros**:
  - `path` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `readBase64File` no domínio `IoBinaryFileContract`.

##### `op writeBase64File`
```flux
op writeBase64File (as string: path, as string: b64_content) as string
```
- **Parâmetros**:
  - `path` (`string`): Parâmetro de entrada para processamento da operação.
  - `b64_content` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `writeBase64File` no domínio `IoBinaryFileContract`.

### 4.3 Contrato `IoDirectoryContract` (`IoDirectory.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `dirExists` | `op dirExists (as string: path) as bool` | `bool` |
| `createDir` | `op createDir (as string: path) as bool` | `bool` |
| `removeDir` | `op removeDir (as string: path) as bool` | `bool` |
| `listDir` | `op listDir (as string: path) as list of data` | `list of data` |

#### Ficha Técnica das Operações:

##### `op dirExists`
```flux
op dirExists (as string: path) as bool
```
- **Parâmetros**:
  - `path` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dirExists` no domínio `IoDirectoryContract`.

##### `op createDir`
```flux
op createDir (as string: path) as bool
```
- **Parâmetros**:
  - `path` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `createDir` no domínio `IoDirectoryContract`.

##### `op removeDir`
```flux
op removeDir (as string: path) as bool
```
- **Parâmetros**:
  - `path` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `removeDir` no domínio `IoDirectoryContract`.

##### `op listDir`
```flux
op listDir (as string: path) as list of data
```
- **Parâmetros**:
  - `path` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `listDir` no domínio `IoDirectoryContract`.

### 4.4 Contrato `IoFileContract` (`IoFile.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `readFile` | `op readFile (as string: path) as string` | `string` |
| `writeFile` | `op writeFile (as string: path, as string: content) as string` | `string` |
| `appendFile` | `op appendFile (as string: path, as string: content) as string` | `string` |
| `deleteFile` | `op deleteFile (as string: path) as bool` | `bool` |
| `copyFile` | `op copyFile (as string: src, as string: dst) as bool` | `bool` |
| `moveFile` | `op moveFile (as string: src, as string: dst) as bool` | `bool` |

#### Ficha Técnica das Operações:

##### `op readFile`
```flux
op readFile (as string: path) as string
```
- **Parâmetros**:
  - `path` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `readFile` no domínio `IoFileContract`.

##### `op writeFile`
```flux
op writeFile (as string: path, as string: content) as string
```
- **Parâmetros**:
  - `path` (`string`): Parâmetro de entrada para processamento da operação.
  - `content` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `writeFile` no domínio `IoFileContract`.

##### `op appendFile`
```flux
op appendFile (as string: path, as string: content) as string
```
- **Parâmetros**:
  - `path` (`string`): Parâmetro de entrada para processamento da operação.
  - `content` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `appendFile` no domínio `IoFileContract`.

##### `op deleteFile`
```flux
op deleteFile (as string: path) as bool
```
- **Parâmetros**:
  - `path` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `deleteFile` no domínio `IoFileContract`.

##### `op copyFile`
```flux
op copyFile (as string: src, as string: dst) as bool
```
- **Parâmetros**:
  - `src` (`string`): Parâmetro de entrada para processamento da operação.
  - `dst` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `copyFile` no domínio `IoFileContract`.

##### `op moveFile`
```flux
op moveFile (as string: src, as string: dst) as bool
```
- **Parâmetros**:
  - `src` (`string`): Parâmetro de entrada para processamento da operação.
  - `dst` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `moveFile` no domínio `IoFileContract`.

### 4.5 Contrato `IoFileInspectionContract` (`IoFileInspection.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `fileExists` | `op fileExists (as string: path) as bool` | `bool` |
| `fileSize` | `op fileSize (as string: path) as int64` | `int64` |
| `fileIsEmpty` | `op fileIsEmpty (as string: path) as bool` | `bool` |

#### Ficha Técnica das Operações:

##### `op fileExists`
```flux
op fileExists (as string: path) as bool
```
- **Parâmetros**:
  - `path` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `fileExists` no domínio `IoFileInspectionContract`.

##### `op fileSize`
```flux
op fileSize (as string: path) as int64
```
- **Parâmetros**:
  - `path` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `fileSize` no domínio `IoFileInspectionContract`.

##### `op fileIsEmpty`
```flux
op fileIsEmpty (as string: path) as bool
```
- **Parâmetros**:
  - `path` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `fileIsEmpty` no domínio `IoFileInspectionContract`.

### 4.6 Contrato `IoFileLineContract` (`IoFileLine.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `readLines` | `op readLines (as string: path) as list of data` | `list of data` |
| `writeLines` | `op writeLines (as string: path, as list of data: lines) as string` | `string` |
| `appendLines` | `op appendLines (as string: path, as list of data: lines) as string` | `string` |

#### Ficha Técnica das Operações:

##### `op readLines`
```flux
op readLines (as string: path) as list of data
```
- **Parâmetros**:
  - `path` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `readLines` no domínio `IoFileLineContract`.

##### `op writeLines`
```flux
op writeLines (as string: path, as list of data: lines) as string
```
- **Parâmetros**:
  - `path` (`string`): Parâmetro de entrada para processamento da operação.
  - `lines` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `writeLines` no domínio `IoFileLineContract`.

##### `op appendLines`
```flux
op appendLines (as string: path, as list of data: lines) as string
```
- **Parâmetros**:
  - `path` (`string`): Parâmetro de entrada para processamento da operação.
  - `lines` (`list of data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `appendLines` no domínio `IoFileLineContract`.

### 4.7 Contrato `IoInputContract` (`IoInput.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `readLn` | `op readLn (as string: prompt) as string` | `string` |
| `readLine` | `op readLine (as string: prompt) as string` | `string` |

#### Ficha Técnica das Operações:

##### `op readLn`
```flux
op readLn (as string: prompt) as string
```
- **Parâmetros**:
  - `prompt` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `readLn` no domínio `IoInputContract`.

##### `op readLine`
```flux
op readLine (as string: prompt) as string
```
- **Parâmetros**:
  - `prompt` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `readLine` no domínio `IoInputContract`.

### 4.8 Contrato `IoPathContract` (`IoPath.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `pathBaseName` | `op pathBaseName (as string: path) as string` | `string` |
| `pathDirName` | `op pathDirName (as string: path) as string` | `string` |
| `pathExtension` | `op pathExtension (as string: path) as string` | `string` |
| `pathJoin` | `op pathJoin (as string: dir, as string: file) as string` | `string` |

#### Ficha Técnica das Operações:

##### `op pathBaseName`
```flux
op pathBaseName (as string: path) as string
```
- **Parâmetros**:
  - `path` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `pathBaseName` no domínio `IoPathContract`.

##### `op pathDirName`
```flux
op pathDirName (as string: path) as string
```
- **Parâmetros**:
  - `path` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `pathDirName` no domínio `IoPathContract`.

##### `op pathExtension`
```flux
op pathExtension (as string: path) as string
```
- **Parâmetros**:
  - `path` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `pathExtension` no domínio `IoPathContract`.

##### `op pathJoin`
```flux
op pathJoin (as string: dir, as string: file) as string
```
- **Parâmetros**:
  - `dir` (`string`): Parâmetro de entrada para processamento da operação.
  - `file` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `pathJoin` no domínio `IoPathContract`.

### 4.9 Contrato `IoPrintContract` (`IoPrint.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `echo` | `op echo (as string: text) as string` | `string` |
| `printLn` | `op printLn (as data: value) as data` | `data` |
| `printLine` | `op printLine (as data: value) as data` | `data` |
| `printErr` | `op printErr (as data: value) as data` | `data` |

#### Ficha Técnica das Operações:

##### `op echo`
```flux
op echo (as string: text) as string
```
- **Parâmetros**:
  - `text` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `echo` no domínio `IoPrintContract`.

##### `op printLn`
```flux
op printLn (as data: value) as data
```
- **Parâmetros**:
  - `value` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `printLn` no domínio `IoPrintContract`.

##### `op printLine`
```flux
op printLine (as data: value) as data
```
- **Parâmetros**:
  - `value` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `printLine` no domínio `IoPrintContract`.

##### `op printErr`
```flux
op printErr (as data: value) as data
```
- **Parâmetros**:
  - `value` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `printErr` no domínio `IoPrintContract`.

---

## 5. Exemplos Canônicos de Uso em TheFlux

O exemplo a seguir demonstra a importação e o consumo prático da biblioteca:

```flux
# Exemplo Canônico de Consumo da IoStdLib
use IoStdLib

program (ExemploIoStdLib) {
      println("==================================================")
      println("  Demonstracao da Standard Library: IoStdLib")
      println("==================================================")

      # Chamada da operacao canônica
      mut as data: resultado = IoStdLib::ioFileExists("config.flux")
      println("Resultado obtido: " + resultado)

      println("Demonstracao concluida com sucesso.")
}
```

---

> [!TIP]
> Para consultar a visão arquitetural unificada de todas as bibliotecas, consulte o documento principal [StdLibs.md](../StdLibs.md).
