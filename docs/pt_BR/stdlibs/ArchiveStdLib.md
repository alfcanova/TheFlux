# 📚 `ArchiveStdLib` — Gerenciamento e Manipulação de Arquivos e Pacotes Compactados

> **Pilar Arquitetural**: Pilar 4 (Sistema, I/O & Rede)  
> **Status**: ✅ Homologado com 100% de Paridade nos 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Arquivo Mestre**: `stdlib/ArchiveStdLib/ArchiveStdLib.fdsl`  
> **Modo de Importação**: `use ArchiveStdLib` ou `use ArchiveStdLib::<Modulo>::<operacao>`

---

## 1. Visão Geral e Funcionalidades

A biblioteca padrão **`ArchiveStdLib`** integra o ecossistema oficial da linguagem TheFlux, fornecendo suporte de nível de sistema e algoritmos nativos certificados.

Fornece operações abrangentes para compactação, descompactação, listagem e extração de arquivos em formatos padronizados (ZIP, TAR, TAR.GZ, TAR.BZ2, TAR.XZ, TAR.ZST, 7Z e RAR). Integra detecção automática de formatos através de cabeçalhos binários.

### 1.1 Características e Princípios de Design
- **Compilação e Fusão Estática**: Todos os módulos de domínio são fundidos no agente unificado `ArchiveStdLib` em tempo de compilação, sem sobrecarga (*overhead*) de despacho indireto.
- **Isolamento e Segurança**: As operações verificam limites operacionais e utilizam despacho por contratos formais rigorosos.
- **Compatibilidade Multi-Backend**: Execução bit-a-bit idêntica em interpretador (`in`), bytecode (`vm`, `vmr`), nativo AOT (`llvm`) e WebAssembly (`wat`, `wasm`).

---

## 2. Estrutura Modular e Contratos

A biblioteca é composta por **1 módulo de domínio** e declara **19 operações públicas**:

| Arquivo de Domínio | Contrato Formal | Responsabilidade Principal | Qtd. Ops |
|---|---|---|:---:|
| `ArchiveManagement.fdsl` | `ArchiveManagementContract` | Domínio especializado de `ArchiveManagement` | 19 |

---

## 3. Tipos, Estruturas e Enumerações Públicas

A biblioteca `ArchiveStdLib` opera diretamente com os tipos nativos e primitivos da linguagem TheFlux (`string`, `int64`, `float64`, `bool`, `list of data`, etc.), sem exigir tipos compostos adicionais.

---

## 4. Catálogo Detalhado de Operações por Domínio

### 4.1 Contrato `ArchiveManagementContract` (`ArchiveManagement.fdsl`)

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
  - Executa a funcionalidade canônica de `archiveZip` no domínio `ArchiveManagementContract`.

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
  - Executa a funcionalidade canônica de `archiveUnzip` no domínio `ArchiveManagementContract`.

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
  - Executa a funcionalidade canônica de `archiveTar` no domínio `ArchiveManagementContract`.

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
  - Executa a funcionalidade canônica de `archiveExtractTar` no domínio `ArchiveManagementContract`.

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
  - Executa a funcionalidade canônica de `archiveTarGz` no domínio `ArchiveManagementContract`.

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
  - Executa a funcionalidade canônica de `archiveExtractTarGz` no domínio `ArchiveManagementContract`.

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
  - Executa a funcionalidade canônica de `archiveTarBz2` no domínio `ArchiveManagementContract`.

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
  - Executa a funcionalidade canônica de `archiveExtractTarBz2` no domínio `ArchiveManagementContract`.

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
  - Executa a funcionalidade canônica de `archiveTarXz` no domínio `ArchiveManagementContract`.

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
  - Executa a funcionalidade canônica de `archiveExtractTarXz` no domínio `ArchiveManagementContract`.

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
  - Executa a funcionalidade canônica de `archiveTarZst` no domínio `ArchiveManagementContract`.

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
  - Executa a funcionalidade canônica de `archiveExtractTarZst` no domínio `ArchiveManagementContract`.

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
  - Executa a funcionalidade canônica de `archiveCreate7z` no domínio `ArchiveManagementContract`.

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
  - Executa a funcionalidade canônica de `archiveExtract7z` no domínio `ArchiveManagementContract`.

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
  - Executa a funcionalidade canônica de `archiveExtractRar` no domínio `ArchiveManagementContract`.

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
  - Executa a funcionalidade canônica de `archiveListFiles` no domínio `ArchiveManagementContract`.

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
  - Executa a funcionalidade canônica de `archiveExtractFile` no domínio `ArchiveManagementContract`.

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
  - Executa a funcionalidade canônica de `archiveIsArchive` no domínio `ArchiveManagementContract`.

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
  - Executa a funcionalidade canônica de `archiveDetectFormat` no domínio `ArchiveManagementContract`.

---

## 5. Exemplos Canônicos de Uso em TheFlux

O exemplo a seguir demonstra a importação e o consumo prático da biblioteca:

```flux
# Exemplo Canônico de Consumo da ArchiveStdLib
use ArchiveStdLib

program (ExemploArchiveStdLib) {
      println("==================================================")
      println("  Demonstracao da Standard Library: ArchiveStdLib")
      println("==================================================")

      # Chamada da operacao canônica
      mut as data: resultado = ArchiveStdLib::archiveIsArchive("data.zip")
      println("Resultado obtido: " + resultado)

      println("Demonstracao concluida com sucesso.")
}
```

---

> [!TIP]
> Para consultar a visão arquitetural unificada de todas as bibliotecas, consulte o documento principal [StdLibs.md](../StdLibs.md).
