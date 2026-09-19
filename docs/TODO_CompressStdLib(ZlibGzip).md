# CompressStdLib — Biblioteca Padrão de Compressão e Descompressão (TheFlux)

Para a **CompressStdLib**, o design da biblioteca padrão de compressão e descompressão na TheFlux atua como um **otimizador de pacotes de dados** e uma **barreira de proteção física de hardware**.

Como a linguagem TheFlux opera em um modelo linear orientado a contratos com gerenciamento estrito de memória e ownership amarrado à AST, a **CompressStdLib** é crucial para diminuir a pegada de memória e o teto de tamanho de payloads transitando pela `NetStdLib` ou gravados em disco pela `IoStdLib`. Além disso, ela ganha superpoderes ao se integrar aos blocos `contract:`, servindo de escudo impenetrável contra ataques de estouro de memória (*Zip Bombs* / *Decompression Bombs*).

---

## 🏛️ Divisão Arquitetural: Dados em Memória vs Arquivos em Disco

Para preservar o princípio de responsabilidade única e a elegância do ecossistema:
1. **`CompressStdLib` (esta biblioteca):** Focada em **algoritmos puros de compressão de streams, buffers e payloads** na memória RAM ou em conexões de rede (Zlib, Gzip, Deflate, LZMA/7-Zip e Bzip2).
2. **`IoStdLib` (extensão com `IoArchiveContract`):** Focada no **gerenciamento de containers de arquivos e diretórios em disco** (`.zip`, `.7z`, `.tar.gz` e extração de `.rar` do WinRAR).

---

## 💎 Tipos de Dados de Domínio Exportados pela DSL (Adoção da Opção 3)

Com a adoção da **Opção 3** (habilitando o compilador TheFlux a exportar `structs` e `enums` declarados dentro de módulos `.fdsl`), a **`CompressStdLib`** define e exporta seus próprios tipos de dados com **tipagem nominal forte**, eliminando a necessidade de mapas genéricos soltos e garantindo integridade estática:

```theflux
#L --- Enum de Formatos Reconhecidos pela DSL ---
enum (CompressFormat) {
      DEFLATE,
      ZLIB,
      GZIP,
      LZMA,
      BZIP2,
      UNKNOWN
}

#L --- Struct de Métricas e Telemetria de Compressão ---
struct (CompressStats) {
      imut: .uncompressed_size: int64
      imut: .compressed_size: int64
      imut: .ratio: float64
      imut: .savings_percent: float64
      imut: .format: CompressFormat
}

#L --- Struct de Quota de Segurança para Descompressão ---
struct (DecompressQuota) {
      mut: .max_bytes: int64
      mut: .strict_abort: bool
}
```

Dessa forma, qualquer programa `.flux` que declarar `use CompressStdLib` terá acesso imediato aos tipos `CompressStats`, `DecompressQuota` e `CompressFormat` com validação estrita em tempo de compilação!

---

## 🎯 1. Contratos e Operações da CompressStdLib

A biblioteca é estruturada em 6 contratos temáticos altamente coesos:

### ⚡ 1.1 CompressDeflateContract (RFC 1951)
Processamento de streams comprimidas no formato bruto Deflate:

- **`compressDeflate (as string: input_data) as string`**
  Compacta dados usando o algoritmo bruto Deflate com nível padrão (6).
- **`compressDeflateLevel (as string: input_data, as int64: level) as string`**
  Compacta dados ajustando o nível de compressão (0 = sem compressão, 1 = ultra-rápido/streaming, 9 = máxima redução).
- **`decompressDeflate (as string: compressed_data) as string`**
  Descompacta dados gerados por Deflate de volta para a string original. Se o dado estiver corrompido, encerra o fluxo com `emit(fail, "", "erro na descompressao deflate")`.
- **`decompressDeflateSafe (as string: compressed_data, as DecompressQuota: quota) as string`**
  Descompactação com cota máxima de segurança: interrompe imediatamente com `emit(fail)` se a expansão ultrapassar `quota.max_bytes` (proteção física contra Zip Bombs).
- **`compressIsDeflate (as string: compressed_data) as bool`**
  Verifica se o buffer binário é um bloco de dados Deflate válido.

### 📦 1.2 CompressZlibContract (RFC 1950)
Compactação e descompactação envelopada no formato padrão Zlib (ideal para memória e IPC):

- **`compressZlib (as string: input_data) as string`**
  Compacta dados no formato estruturado Zlib com nível padrão.
- **`compressZlibLevel (as string: input_data, as int64: level) as string`**
  Compacta no formato Zlib com nível ajustável (0 a 9).
- **`decompressZlib (as string: compressed_data) as string`**
  Descompacta dados Zlib validando a integridade pelo checksum Adler-32.
- **`decompressZlibSafe (as string: compressed_data, as DecompressQuota: quota) as string`**
  Descompactação Zlib com teto máximo de expansão na memória RAM.
- **`compressIsZlib (as string: compressed_data) as bool`**
  Valida se os magic bytes iniciais correspondem aos cabeçalhos oficiais da RFC 1950 (`0x78 0x01`, `0x78 0x9C`, `0x78 0xDA`).
- **`compressZlibAdler32 (as string: compressed_data) as int64`**
  Extrai diretamente dos últimos 4 bytes o checksum Adler-32 gravado no rodapé do pacote Zlib.

### 🌐 1.3 CompressGzipContract (RFC 1952)
Compactação e descompactação envelopada no padrão Gzip clássico:

- **`compressGzip (as string: input_data) as string`**
  Compacta dados envelopando-os com o cabeçalho e rodapé clássicos do formato Gzip.
- **`compressGzipLevel (as string: input_data, as int64: level) as string`**
  Compacta dados Gzip com nível ajustável (1 a 9).
- **`decompressGzip (as string: compressed_data) as string`**
  Descompacta dados Gzip validando a integridade pelo CRC-32 oficial.
- **`decompressGzipSafe (as string: compressed_data, as DecompressQuota: quota) as string`**
  Descompactação Gzip com limite de segurança em bytes contra estouro de memória.
- **`compressIsGzip (as string: compressed_data) as bool`**
  Valida se os bytes mágicos iniciais correspondem ao cabeçalho oficial Gzip (`0x1F 0x8B`).
- **`compressGzipCrc32 (as string: compressed_data) as int64`**
  Extrai o valor de integridade CRC-32 gravado no rodapé do pacote Gzip.
- **`compressGzipTimestamp (as string: compressed_data) as int64`**
  Extrai a data/hora original (Unix Epoch) gravada no cabeçalho do pacote Gzip.

### 💎 1.4 CompressLzmaContract (O Motor do 7-Zip / XZ)
Compactação de altíssima densidade baseada no algoritmo LZMA/LZMA2:

- **`compressLzma (as string: input_data) as string`**
  Compacta dados usando o algoritmo LZMA (mesmo motor de alta compressão do 7-Zip).
- **`compressLzmaLevel (as string: input_data, as int64: level) as string`**
  Compacta dados via LZMA com nível customizado (1 a 9).
- **`decompressLzma (as string: compressed_data) as string`**
  Descompacta dados gerados por LZMA/XZ de volta para a forma original.
- **`decompressLzmaSafe (as string: compressed_data, as DecompressQuota: quota) as string`**
  Descompactação LZMA com cota estrita de expansão em RAM.
- **`compressIsLzma (as string: compressed_data) as bool`**
  Valida se o cabeçalho binário corresponde a um fluxo válido de dados LZMA/XZ.

### 📜 1.5 CompressBzip2Contract (Legado Unix de Alta Entropia)
Compactação baseada na transformada de Burrows-Wheeler:

- **`compressBzip2 (as string: input_data) as string`**
  Compacta dados no formato padrão Bzip2 (`.bz2`).
- **`compressBzip2Level (as string: input_data, as int64: level) as string`**
  Compacta dados Bzip2 com tamanho de bloco configurável (nível 1 a 9).
- **`decompressBzip2 (as string: compressed_data) as string`**
  Descompacta dados no formato Bzip2.
- **`decompressBzip2Safe (as string: compressed_data, as DecompressQuota: quota) as string`**
  Descompactação Bzip2 protegida com limite máximo de expansão.
- **`compressIsBzip2 (as string: compressed_data) as bool`**
  Valida se os bytes mágicos iniciais correspondem ao formato Bzip2 (`0x42 0x5A` ou `"BZ"`).

### 🔍 1.6 CompressInspectionContract
Inspeção, auto-detecção, telemetria e blindagem em contratos com structs nominais:

- **`compressEstimateDecompressedSize (as string: compressed_data) as int64`**
  Lê os metadados do pacote (ex: ISIZE no Gzip ou dicionário no Zlib/LZMA) para descobrir o tamanho exato em bytes após descompressão.
  ```theflux
  // O contrato impede que o fluxo descompacte um arquivo malicioso que estoure a RAM livre
  contract: CompressStdLib.compressEstimateDecompressedSize(payload) < OsStdLib.memoryFree()
  ```
- **`compressDetectFormat (as string: compressed_data) as CompressFormat`**
  Analisa os magic bytes e identifica o formato retornando o enum nominal tipado `CompressFormat`.
- **`compressStats (as string: uncompressed, as string: compressed) as CompressStats`**
  Retorna uma instância completa de `CompressStats` contendo o tamanho original, tamanho final, taxa volumétrica e percentual de economia de banda.
- **`decompressAuto (as string: compressed_data) as string`**
  Detecta dinamicamente o formato e executa a descompactação apropriada de forma transparente.
- **`compressIsEffective (as string: uncompressed, as string: compressed) as bool`**
  Garante que a compressão foi eficiente e não inflou o tamanho do pacote antes de enviá-lo pela rede.

---

## 🗄️ 2. Integração com a `IoStdLib` (Gerenciador de Arquivos e Containers)

Enquanto a `CompressStdLib` opera em strings e buffers de memória com tipos ricos, o gerenciamento de diretórios e pacotes no disco será atendido pelo contrato **`IoArchiveContract`** na **`IoStdLib`**:

- **ZIP:** `archiveZip(origem, saida_zip)` e `archiveUnzip(arquivo_zip, destino)`
- **7-Zip:** `archiveCreate7z(origem, saida_7z)` e `archiveExtract7z(arquivo_7z, destino)`
- **TAR / TAR.GZ:** `archiveCreateTarGz(origem, saida_tar)` e `archiveExtractTar(arquivo_tar, destino)`
- **RAR (WinRAR Legado):** `archiveExtractRar(arquivo_rar, destino)` *(somente leitura/extração, respeitando as patentes da RARLab)*
- **Inspecção de Pacote:** `archiveListFiles(caminho_arquivo)` e `archiveIsArchive(caminho_arquivo)`

---

## 🏗️ 3. Sugestão de Implementação no Cenário Multiend com a Opção 3

Como operações de compressão de bits exigem máxima velocidade em múltiplos alvos:

### A. No Compilador (Suporte à Exportação de Tipos em `.fdsl`)
- **Import Resolver (`import_resolver.py`):** Coleta as declarações de `struct` e `enum` dos arquivos `.fdsl` carregados via `use`.
- **Analisador Semântico (`semantic/analyzer.py`):** Insere as structs e enums importados no escopo de tipos globais, permitindo tipagem estática `mut as CompressStats: st`.
- **Runtimes e Codegen (LLVM, WASM, Interpretador):** Unificam `program.structs` com os modelos importados das DSLs.

### B. No Interpretador (Python)
Execução direta e sem atrito. O interpretador em Python intercepta a execução dos nós e delega aos pacotes ultrarrápidos e embutidos em C da biblioteca padrão do Python:
- Zlib e Deflate: módulo nativo `zlib`.
- Gzip: módulo nativo `gzip`.
- LZMA (7-Zip stream): módulo nativo `lzma`.
- Bzip2: módulo nativo `bz2`.

### C. Na LLVM IR + Clang (.exe nativo)
*A Estratégia de Runtime Autônomo:* Seguindo o modelo de `src/flux_proto/llvm/runtime/flux_input.c` (que implementa SHA-256 e MD5 de forma 100% autônoma), o runtime C do TheFlux incorporará rotinas leves em C de Deflate/Inflate/Gzip e LZMA, permitindo compilação nativa em qualquer máquina Windows/Linux com **zero dependências externas de `.dll` ou `.lib`**. As structs exportadas pela DSL mapeiam 1:1 para LLVM struct types nativos.

### D. No WebAssembly (WASM / WAT)
- *Ambiente de Navegador (`web_wasm`):* Aproveita a aceleração nativa de hardware do browser através das APIs `CompressionStream` e `DecompressionStream`.
- *Ambiente CLI / Node.js (`flux_was.py`):* Utiliza a ponte do módulo nativo `zlib` do Node.js ou runtime C embutido.

### E. O Casamento Rígido com Ownership (`move` / `borrow`)
- **Semântica de Borrow:** Todas as funções de checagem, identificação e estimativa (`compressEstimateDecompressedSize`, `compressIsGzip`, `compressStats`) operam estritamente por borrow, preservando o payload para contratos.
- **Semântica de Move:** A descompressão final consome o buffer compactado como move, liberando imediatamente o buffer comprimido da RAM e emitindo o dado limpo e expandido através de `emit(nice, descompressed_data, "ok")`.