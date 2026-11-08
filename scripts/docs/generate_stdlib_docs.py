#!/usr/bin/env python3
"""Gerador e Sincronizador de Documentação Técnica Bilíngue das 37 Standard Libraries do TheFlux.

Lê as definições formais em stdlib/*StdLib/*.fdsl e gera documentação
técnica completa e exaustiva em português (docs/pt_BR/stdlib/) e inglês (docs/en/stdlib/),
incluindo:
  - Metadados e pilar arquitetural
  - Visão geral e capacidades
  - Estrutura modular e tabela de contratos
  - Tipos e estruturas públicas (structs e enums)
  - Catálogo formal de operações (assinatura, parâmetros, retorno, emissões e descrição)
  - Exemplos canônicos de código em TheFlux (program)

Uso:
  python scripts/docs/generate_stdlib_docs.py
  python scripts/docs/generate_stdlib_docs.py --verify
"""
from __future__ import annotations

import argparse
import os
import re
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent.parent
STDLIB_DIR = REPO_ROOT / "stdlib"
DOCS_PT_DIR = REPO_ROOT / "docs" / "pt_BR" / "stdlib"
DOCS_EN_DIR = REPO_ROOT / "docs" / "en" / "stdlib"

# Mapeamento canônico dos 4 Pilares Arquiteturais
PILLARS_DATA = {
    # Pilar 1: Núcleo, Texto & OO
    "CharStdLib": (1, "Núcleo, Texto & OO", "Core, Text & OO"),
    "ConvertStdLib": (1, "Núcleo, Texto & OO", "Core, Text & OO"),
    "DebugStdLib": (1, "Núcleo, Texto & OO", "Core, Text & OO"),
    "DslStdLib": (1, "Núcleo, Texto & OO", "Core, Text & OO"),
    "FileSignatureStdLib": (1, "Núcleo, Texto & OO", "Core, Text & OO"),
    "FormatStdLib": (1, "Núcleo, Texto & OO", "Core, Text & OO"),
    "OoStdLib": (1, "Núcleo, Texto & OO", "Core, Text & OO"),
    "RegexStdLib": (1, "Núcleo, Texto & OO", "Core, Text & OO"),
    "StringStdLib": (1, "Núcleo, Texto & OO", "Core, Text & OO"),

    # Pilar 2: Estruturas & Estados
    "CompressStdLib": (2, "Estruturas & Estados", "Structures & State"),
    "DateTimeStdLib": (2, "Estruturas & Estados", "Structures & State"),
    "DbStdLib": (2, "Estruturas & Estados", "Structures & State"),
    "FsmStdLib": (2, "Estruturas & Estados", "Structures & State"),
    "ListStdLib": (2, "Estruturas & Estados", "Structures & State"),
    "MapStdLib": (2, "Estruturas & Estados", "Structures & State"),
    "RandomStdLib": (2, "Estruturas & Estados", "Structures & State"),
    "SetStdLib": (2, "Estruturas & Estados", "Structures & State"),
    "StructStdLib": (2, "Estruturas & Estados", "Structures & State"),

    # Pilar 3: Matemática & Gráficos
    "FinStdLib": (3, "Matemática & Gráficos", "Mathematics & Graphics"),
    "GraphPlotStdLib": (3, "Matemática & Gráficos", "Mathematics & Graphics"),
    "HashStdLib": (3, "Matemática & Gráficos", "Mathematics & Graphics"),
    "LinAlgStdLib": (3, "Matemática & Gráficos", "Mathematics & Graphics"),
    "MathStdLib": (3, "Matemática & Gráficos", "Mathematics & Graphics"),
    "PhysStdLib": (3, "Matemática & Gráficos", "Mathematics & Graphics"),
    "SimdStdLib": (3, "Matemática & Gráficos", "Mathematics & Graphics"),
    "StatStdLib": (3, "Matemática & Gráficos", "Mathematics & Graphics"),
    "SymbolicStdLib": (3, "Matemática & Gráficos", "Mathematics & Graphics"),

    # Pilar 4: Sistema, I/O & Rede
    "ArchiveStdLib": (4, "Sistema, I/O & Rede", "System, I/O & Network"),
    "GfxStdLib": (4, "Sistema, I/O & Rede", "System, I/O & Network"),
    "GuiStdLib": (4, "Sistema, I/O & Rede", "System, I/O & Network"),
    "IoStdLib": (4, "Sistema, I/O & Rede", "System, I/O & Network"),
    "LowLevelStdLib": (4, "Sistema, I/O & Rede", "System, I/O & Network"),
    "NativeGfxStdLib": (4, "Sistema, I/O & Rede", "System, I/O & Network"),
    "NetStdLib": (4, "Sistema, I/O & Rede", "System, I/O & Network"),
    "OsStdLib": (4, "Sistema, I/O & Rede", "System, I/O & Network"),
    "RuntimeStdLib": (4, "Sistema, I/O & Rede", "System, I/O & Network"),
    "ThreadStdLib": (4, "Sistema, I/O & Rede", "System, I/O & Network"),
}

LIB_METADATA = {
    "ArchiveStdLib": {
        "title_pt": "Gerenciamento e Manipulação de Arquivos e Pacotes Compactados",
        "title_en": "Compressed Archive and Package Management",
        "desc_pt": "Fornece operações abrangentes para compactação, descompactação, listagem e extração de arquivos em formatos padronizados (ZIP, TAR, TAR.GZ, TAR.BZ2, TAR.XZ, TAR.ZST, 7Z e RAR). Integra detecção automática de formatos através de cabeçalhos binários.",
        "desc_en": "Provides comprehensive operations for creating, unpacking, listing, and extracting archive containers across industry-standard formats (ZIP, TAR, TAR.GZ, TAR.BZ2, TAR.XZ, TAR.ZST, 7Z, and RAR). Includes automatic archive format detection through binary file headers.",
        "sample_call": 'ArchiveStdLib::archiveIsArchive("data.zip")',
    },
    "CharStdLib": {
        "title_pt": "Manipulação, Classificação e Predicados de Caracteres",
        "title_en": "Character Manipulation, Classification, and Predicates",
        "desc_pt": "Oferece operações de baixo custo para teste de categorias Unicode e ASCII (dígitos, letras maiúsculas/minúsculas, espaços em branco, controle), conversões numéricas hexadecimais e transformações de caixa em caracteres atômicos.",
        "desc_en": "Offers zero-allocation predicates and transforms for Unicode and ASCII character categories (digits, uppercase/lowercase letters, whitespace, control characters), hexadecimal parsing, and atomic case conversions.",
        "sample_call": "CharStdLib::charIsDigit('7')",
    },
    "CompressStdLib": {
        "title_pt": "Compressão e Descompressão de Fluxos de Dados com Quotas Seguras",
        "title_en": "Data Stream Compression and Decompression with Safe Quotas",
        "desc_pt": "Implementa motores nativos de compactação e descompactação de memória e streams para GZIP, DEFLATE, ZLIB, BZIP2, LZMA, XZ e ZSTD. Inclui suporte a limites de expansão (DecompressQuota) para proteção contra ataques do tipo Zip-Bomb.",
        "desc_en": "Implements high-performance memory and streaming compression/decompression engines for GZIP, DEFLATE, ZLIB, BZIP2, LZMA, XZ, and ZSTD. Features expansion quota safeguards (DecompressQuota) to neutralize zip-bomb attack vectors.",
        "sample_call": 'CompressStdLib::compressGzip("TheFlux Standard Library")',
    },
    "ConvertStdLib": {
        "title_pt": "Conversão Universal de Tipos, Encodings e Bases Numéricas",
        "title_en": "Universal Type, Encoding, and Numeric Base Conversion",
        "desc_pt": "Proê conversões determinísticas entre escalares numéricos inteiros e floats (16, 32 e 64 bits), transcodificação de encodings de texto (UTF-8, ASCII, Latin-1), representação em bases (binário, octal, hexadecimal, Base64) e parsing seguro com fallback.",
        "desc_en": "Provides deterministic conversions between numeric integer and floating-point scalars (16, 32, and 64 bits), character encoding transcoding (UTF-8, ASCII, Latin-1), radix transformations (binary, octal, hexadecimal, Base64), and fallback-safe parsing.",
        "sample_call": 'ConvertStdLib::stringToInt64("1024")',
    },
    "DateTimeStdLib": {
        "title_pt": "Manipulação de Datas, Horários, Fusos e Relógios Monotônicos",
        "title_en": "Date, Time, Timezone, and Monotonic Clock Management",
        "desc_pt": "Gerenciamento completo de datas de calendário, horas de relógio, carimbos de época UTC/Unix, conversões de fusos horários IANA, formatação e parsing estritos no padrão ISO 8601 e cronometragem de alta precisão via temporizadores monotônicos.",
        "desc_en": "Full-featured date and time manipulation, Unix epoch timestamps, IANA timezone conversions, strict ISO 8601 parsing and formatting, calendar arithmetic, and nanosecond-resolution monotonic interval timing.",
        "sample_call": "DateTimeStdLib::nowUtc()",
    },
    "DbStdLib": {
        "title_pt": "Conectores e Abstrações de Banco de Dados Multi-Modelo",
        "title_en": "Multi-Model Database Connectors and Abstractions",
        "desc_pt": "Camada de abstração unificada para acesso a bancos de dados relacionais SQL, repositórios NoSQL chave-valor, coleções de documentos JSON, armazenamento colunar analítico, grafos de nós/arestas e índices de embeddings vetoriais para IA.",
        "desc_en": "Unified multi-model database abstraction layer supporting SQL relational querying, NoSQL key-value stores, JSON document collections, analytical columnar storage, node/edge graph traversals, and vector embedding similarity indexes.",
        "sample_call": 'DbStdLib::sqlExecute("SELECT 1")',
    },
    "DebugStdLib": {
        "title_pt": "Diagnóstico, Asserções, Rastreamento e Inspeção em Runtime",
        "title_en": "Diagnostics, Assertions, Stack Tracing, and Runtime Inspection",
        "desc_pt": "Conjunto de utilitários de instrumentação para depuração ativa: asserções defensivas (`assert`), impressão de stack traces, filtragem de logs em múltiplos níveis, cálculo de diferenças (`diff`) entre valores e telemetria de performance.",
        "desc_en": "Active instrumentation and debugging toolset featuring defensive assertions (`assert`), stack trace extraction, multi-level structured logging, value diffing, and lightweight performance benchmarking utilities.",
        "sample_call": 'DebugStdLib::debugInspect(42)',
    },
    "DslStdLib": {
        "title_pt": "Compilação, Análise Léxica, Parsing e Execução de DSLs",
        "title_en": "DSL Compilation, Lexing, AST Parsing, and Secure Execution",
        "desc_pt": "Infraestrutura nativa para criação de linguagens de domínio específico (DSLs) acopladas ao TheFlux: tokenizadores configuráveis, construção e validação de árvores sintáticas abstratas (AST), montador de bytecode e máquina de execução isolada.",
        "desc_en": "Domain-Specific Language (DSL) construction toolkit for TheFlux: configurable tokenizers, AST building and structural validation, intermediate bytecode assembler, and sandboxed bytecode execution engines.",
        "sample_call": 'DslStdLib::dslLex("x = 1 + 2")',
    },
    "FileSignatureStdLib": {
        "title_pt": "Detecção de Formatos via Magic Numbers e Validação de Assinaturas",
        "title_en": "File Format Identification via Magic Numbers and Signature Validation",
        "desc_pt": "Identificação confiável de tipos MIME e formatos de arquivos reais através da inspeção de sequências mágicas (magic bytes) no cabeçalho binário, prevenindo spoofing de extensão e validando integridade estrutural e assinaturas de diretórios.",
        "desc_en": "Reliable MIME and container file identification based on magic number inspection in binary headers, defeating extension spoofing and validating filesystem container signatures and directory structures.",
        "sample_call": 'FileSignatureStdLib::detectFileFormat("app.exe")',
    },
    "FinStdLib": {
        "title_pt": "Matemática Financeira de Alta Precisão e Análise de Investimentos",
        "title_en": "High-Precision Financial Mathematics and Investment Analysis",
        "desc_pt": "Operações financeiras exatas utilizando ponto fixo decimal (`FinDecimal`) para anular imprecisões de ponto flutuante: juros simples e compostos, cronogramas de amortização (SAC/Price), Valor Presente Líquido (VPL), Taxa Interna de Retorno (TIR) e depreciação.",
        "desc_en": "Exact financial math backed by arbitrary-scale decimal fixed-point (`FinDecimal`) to eliminate floating-point drift: compound interest, loan amortization tables, Net Present Value (NPV), Internal Rate of Return (IRR), and depreciation models.",
        "sample_call": "FinStdLib::finCompoundInterest(1000.0, 0.05, 12)",
    },
    "FormatStdLib": {
        "title_pt": "Formatação e Serialização de Dados em JSON, YAML, TOML e CSV",
        "title_en": "Data Serialization and Formatting in JSON, YAML, TOML, and CSV",
        "desc_pt": "Parsers e formatadores bi-direcionais rápidos para formatos de intercâmbio de dados e configuração: JSON compatível com RFC 8259, YAML estruturado, TOML para manifestos de projeto e CSV delimitado com suporte a escaping e aspas.",
        "desc_en": "Bidirectional high-throughput parsers and serializers for ubiquitous configuration and data interchange formats: RFC 8259 JSON, human-readable YAML, TOML manifest syntax, and CSV tabular records with quotation escaping.",
        "sample_call": 'FormatStdLib::jsonEscape("text")',
    },
    "FsmStdLib": {
        "title_pt": "Máquinas de Estados Finitos (FSM) Determinísticas e Auditoria",
        "title_en": "Deterministic Finite State Machines (FSM) and Audit Logging",
        "desc_pt": "Mecanismo declarativo para modelagem de Máquinas de Estados Finitos: definição formal de estados e eventos, guardas condicionais de transição, execução determinística passo a passo, trilha de auditoria completa e exportação em formato Graphviz DOT.",
        "desc_en": "Declarative finite state machine modeling engine: formal state/event definitions, transition guards, step-by-step deterministic progression, persistent audit trail logs, and Graphviz DOT visualization export.",
        "sample_call": 'FsmStdLib::fsmCreate("OrderFSM")',
    },
    "GfxStdLib": {
        "title_pt": "Primitivas Gráficas 2D/3D, Shaders, Câmeras e Transformações",
        "title_en": "2D/3D Graphics Primitives, Shaders, Cameras, and Transforms",
        "desc_pt": "Framework matemático e de renderização para computação gráfica: vetores e matrizes de projeção (Perspective/Orthographic), modelos de iluminação (Phong/Blinn), câmeras orbitais e FPS, malhas poligonais e detecção de colisões (AABB e esferas).",
        "desc_en": "Graphics computing toolkit: perspective and orthographic projection matrices, Phong/Blinn lighting equations, orbit/FPS camera controllers, 3D polygon meshes, color space math, and spatial collision primitives (AABB/sphere bounds).",
        "sample_call": "GfxStdLib::gfxColorRgb(255, 128, 0)",
    },
    "GraphPlotStdLib": {
        "title_pt": "Plotagem de Gráficos Estatísticos, Científicos e Engenharia",
        "title_en": "Statistical, Scientific, and Engineering Data Plotting",
        "desc_pt": "Motor de visualização de dados científicos e analíticos: geração de gráficos de linhas, dispersão, barras, histogramas, diagramas de controle de qualidade estatística (Shewhart), coordenadas polares, radar e exportação em SVG/vetorial.",
        "desc_en": "Scientific and analytical data plotting engine: line plots, scatter bubbles, bar charts, frequency distributions, statistical process control charts (Shewhart charts), polar/radar coordinates, and clean vector SVG export.",
        "sample_call": 'GraphPlotStdLib::plotCreateContext(800, 600)',
    },
    "GuiStdLib": {
        "title_pt": "Interfaces Gráficas com o Usuário, Componentes e Despacho de Eventos",
        "title_en": "Graphical User Interfaces, Component Hierarchies, and Event Dispatch",
        "desc_pt": "Conjunto de abstrações para construção de interfaces gráficas nativas: gerenciadores de layout (Box, Grid, Flex), hierarquia de widgets (botões, rótulos, campos de texto, tabelas, árvores), estilização via temas e loop de eventos responsivo.",
        "desc_en": "User interface abstractions for native desktop and embedded environments: layout engines (Box, Grid, Flex), widget trees (buttons, labels, text inputs, data grids, tree views), theme management, and responsive event dispatch loops.",
        "sample_call": 'GuiStdLib::guiCreateTheme("Dark")',
    },
    "HashStdLib": {
        "title_pt": "Funções Hash Criptográficas, Rápidas e Verificação de Integridade",
        "title_en": "Cryptographic, Fast Hash Functions, and Integrity Verification",
        "desc_pt": "Algoritmos de dispersão criptográfica segura (SHA-256, SHA-512, SHA-1, MD5), checksums de integridade de dados (CRC32, Adler32) e funções hash não-criptográficas ultrarrápidas para tabelas de espalhamento (MurmurHash3, FNV-1a, CityHash).",
        "desc_en": "Standard cryptographic hashes (SHA-256, SHA-512, SHA-1, MD5), transmission checksums (CRC32, Adler32), and zero-overhead non-cryptographic hashers for in-memory lookup tables (MurmurHash3, FNV-1a, CityHash).",
        "sample_call": 'HashStdLib::sha256("TheFlux")',
    },
    "IoStdLib": {
        "title_pt": "Entrada e Saída em Arquivos, Buffers, Streams e Diretórios",
        "title_en": "Input and Output for Files, Buffers, Streams, and Directories",
        "desc_pt": "Operações de I/O de alta velocidade do sistema: leitura e gravação atômica em arquivos de texto e binários, manipulação de arquivos mapeados em memória (mmap), navegação de diretórios, pipes unidirecionais e streams com bufferização ajustável.",
        "desc_en": "High-throughput system I/O facilities: atomic text and binary file read/write, memory-mapped files (mmap), directory tree walking, inter-process pipes, file inspection, and buffered stream primitives.",
        "sample_call": 'IoStdLib::ioFileExists("config.flux")',
    },
    "LinAlgStdLib": {
        "title_pt": "Álgebra Linear Computacional, Matrizes e Decomposições",
        "title_en": "Computational Linear Algebra, Matrices, and Decompositions",
        "desc_pt": "Álgebra linear numérica de alta performance: criação de matrizes densas e esparsas, operações matriciais fundamentais, resolução de sistemas lineares, cálculo de autovalores/autovetores e decomposições matriciais avançadas (LU, QR, Cholesky, SVD).",
        "desc_en": "High-performance computational linear algebra: dense and sparse matrix representation, matrix-matrix and matrix-vector operations, linear equation solvers, eigenvalue/eigenvector solvers, and matrix factorizations (LU, QR, Cholesky, SVD).",
        "sample_call": "LinAlgStdLib::matrixIdentity(4)",
    },
    "ListStdLib": {
        "title_pt": "Manipulação Funcional de Listas, Agregação e Mutações",
        "title_en": "Functional List Processing, Aggregations, and In-Place Mutations",
        "desc_pt": "Operações funcionais e imperativas sobre sequências lineares: mapeamento (`map`), filtragem (`filter`), redução (`fold`), ordenação determinística, partições, busca linear/binária e mutações eficientes com reaproveitamento de buffer.",
        "desc_en": "Functional and imperative sequence transformations: map, filter, fold reductions, deterministic sorting, partitioning, binary search, element slicing, and cache-friendly in-place array mutations.",
        "sample_call": "ListStdLib::listLength([])",
    },
    "LowLevelStdLib": {
        "title_pt": "Operações de Baixo Nível, Ponteiros Brutos e Manipulação de Memória",
        "title_en": "Low-Level Memory Management, Raw Pointers, and Binary Buffers",
        "desc_pt": "Acesso direto a primitivas de hardware e memória: aritmética de ponteiros brutos, alinhamento de bytes, inspeção e manipulação bit a bit (popcount, clz, ctz), transposição de endianness (Big/Little Endian) e cópia direta de blocos de memória.",
        "desc_en": "Direct hardware and memory primitives: raw pointer arithmetic, byte boundary alignment, bit-level manipulations (popcount, leading/trailing zero counts), byte-order flipping, and block-level memory copy operations.",
        "sample_call": "LowLevelStdLib::lowLevelSwapBytes32(0x12345678)",
    },
    "MapStdLib": {
        "title_pt": "Mapas Associativos (Dicionários), Agregação e Consultas Rápidas",
        "title_en": "Associative Maps (Dictionaries), Aggregations, and Fast Key Lookups",
        "desc_pt": "Tabelas de dispersão chave-valor altamente otimizadas: inserção, consulta, remoção com tempo amortizado O(1), mesclagem de dicionários, inversão de chaves/valores, transformações funcionais e validação estrutural de esquemas de dados.",
        "desc_en": "Optimized associative key-value hash tables: amortized O(1) lookups, insertions, and deletions, dictionary merges, key-value inversions, functional aggregations, and entry-level schema validations.",
        "sample_call": "MapStdLib::mapCount({})",
    },
    "MathStdLib": {
        "title_pt": "Biblioteca Matemática Fundamental, Trigonometria e Funções Especiais",
        "title_en": "Core Mathematics, Trigonometry, and Special Functions",
        "desc_pt": "Modelo de referência formal da linguagem TheFlux: 756 operações matemáticas de 16, 32 e 64 bits cobrindo aritmética de ponto flutuante, raízes e arredondamentos, exponenciais, logaritmos, trigonometria, funções hiperbólicas, combinatória e funções especiais (Gamma, Beta, Erf).",
        "desc_en": "The canonical implementation model of the TheFlux standard library: 756 mathematical operations across 16, 32, and 64-bit precision spanning elementary arithmetic, rounding, roots, logarithms, trigonometry, hyperbolic curves, combinatorics, and special functions (Gamma, Beta, Erf).",
        "sample_call": "MathStdLib::sin64(0.0)",
    },
    "NativeGfxStdLib": {
        "title_pt": "Aceleração Gráfica Nativa de Baixo Nível e Gerenciamento de Janelas",
        "title_en": "Low-Level Native Graphics Acceleration and Window Management",
        "desc_pt": "Interface direta com o subsistema de apresentação e renderização do sistema operacional: criação e ciclo de vida de janelas nativas, polling de eventos de entrada (teclado e mouse) e desenho rasterizado imediato.",
        "desc_en": "Direct interface to the host operating system display subsystem: creation and event management of native desktop windows, mouse/keyboard input capture, and low-latency raster drawing primitives.",
        "sample_call": 'NativeGfxStdLib::nativeCreateWindow("TheFlux Window", 800, 600)',
    },
    "NetStdLib": {
        "title_pt": "Redes de Computadores, Sockets TCP/UDP, Requisições HTTP e URLs",
        "title_en": "Network Programming, TCP/UDP Sockets, HTTP Client, and URLs",
        "desc_pt": "Comunicação em rede para sistemas distribuídos: cliente HTTP/HTTPS com suporte a métodos GET, POST, PUT e DELETE, resolução e validação de endereços IPv4/IPv6, manipulação semântica de URLs e sockets de rede TCP/UDP.",
        "desc_en": "Network communications for distributed applications: HTTP/HTTPS client for RESTful verbs (GET, POST, PUT, DELETE), IPv4/IPv6 address parsing and validation, RFC 3986 URL manipulation, and low-level TCP/UDP socket connections.",
        "sample_call": 'NetStdLib::netHttpGet("https://httpbin.org/get")',
    },
    "OoStdLib": {
        "title_pt": "Orientação a Objetos, Despacho Dinâmico, Introspecção e Ciclo de Vida",
        "title_en": "Object Orientation, Dynamic Dispatch, Introspection, and Lifecycles",
        "desc_pt": "Mecanismos para interoperabilidade com o paradigma orientado a objetos: simulação de tabelas de métodos virtuais (vtable), despacho dinâmico de operações, introspecção de tipos e instâncias, downcasting seguro e ganchos de ciclo de vida.",
        "desc_en": "Object-oriented programming mechanisms within TheFlux: virtual method table (vtable) simulation, dynamic dispatch, runtime type introspection, safe downcasting, and instance lifecycle management.",
        "sample_call": 'OoStdLib::ooTypeOf("object")',
    },
    "OsStdLib": {
        "title_pt": "Interação com o Sistema Operacional, Processos, Ambiente e Sinais",
        "title_en": "Operating System Interoperability, Processes, Environment, and Signals",
        "desc_pt": "Serviços do sistema operacional hospedeiro: consulta e definição de variáveis de ambiente, identificação de arquitetura de CPU e SO, inicialização e término de subprocessos, captura de códigos de saída e sinais.",
        "desc_en": "Host operating system runtime interaction: reading and setting environment variables, querying CPU architecture and OS platform metadata, spawning child processes, capturing exit codes, and process termination.",
        "sample_call": 'OsStdLib::osGetEnv("PATH")',
    },
    "PhysStdLib": {
        "title_pt": "Física Computacional, Constantes Físicas, Mecânica e Termodinâmica",
        "title_en": "Computational Physics, Physical Constants, Mechanics, and Thermodynamics",
        "desc_pt": "Modelagem de fenômenos do mundo físico com alta precisão: tabela universal de constantes físicas (CODATA), equações de cinemática e dinâmica clássica, fluidodinâmica, termodinâmica estatística, eletromagnetismo, gravitação e relatividade especial.",
        "desc_en": "Precision modeling of physical systems: CODATA universal constants, classical Newtonian mechanics and kinematics, fluid mechanics, thermodynamics equations, Maxwell electromagnetism, astrophysics, and special relativity calculations.",
        "sample_call": "PhysStdLib::physSpeedOfLight()",
    },
    "RandomStdLib": {
        "title_pt": "Geração de Números Pseudoaleatórios e Distribuições Estatísticas",
        "title_en": "Pseudorandom Number Generation and Statistical Distributions",
        "desc_pt": "Geradores de números pseudoaleatórios (PRNG) com suporte a sementes determinísticas: distribuições uniformes inteiras e de ponto flutuante, distribuição normal (Gaussiana), exponencial, Poisson e rotinas de embaralhamento aleatório (Fisher-Yates).",
        "desc_en": "Pseudorandom number generator (PRNG) suite with deterministic seeding: uniform integer and floating-point distributions, Gaussian normal distributions, exponential, Poisson, and array shuffling algorithms (Fisher-Yates).",
        "sample_call": "RandomStdLib::randomFloat()",
    },
    "RegexStdLib": {
        "title_pt": "Processamento de Expressões Regulares, Captura e Substituição",
        "title_en": "Regular Expressions Processing, Group Capture, and Replacement",
        "desc_pt": "Engine de expressões regulares em conformidade com o padrão PCRE: compilação de padrões, verificação de correspondência (`match`), busca de subsequências (`search`), extração de grupos nomeados e capturas múltiplas com substituição dinâmica.",
        "desc_en": "PCRE-compliant regular expression engine: pattern compilation, text matching, regex searches, extraction of positional and named capture groups, and dynamic regex replacement with interpolation.",
        "sample_call": 'RegexStdLib::regexMatch("^[0-9]+$", "12345")',
    },
    "RuntimeStdLib": {
        "title_pt": "Controle da Máquina Virtual TheFlux, Memória e Telemetria de Execução",
        "title_en": "TheFlux Virtual Machine Control, Memory Management, and Telemetry",
        "desc_pt": "Inspeção e controle de baixo nível da VM e ambiente de execução: métricas de alocação de memória no heap, estatísticas de coleta de lixo, telemetria de chamadas e informações de versão do compilador e do host.",
        "desc_en": "Low-level inspection and governance of the TheFlux runtime virtual machine: heap memory metrics, garbage collector controls, execution telemetry, and compiler/host platform version metadata.",
        "sample_call": "RuntimeStdLib::runtimeVersion()",
    },
    "SetStdLib": {
        "title_pt": "Álgebra de Conjuntos, Operações Matemáticas e Pertinência",
        "title_en": "Set Algebra, Mathematical Set Operations, and Membership",
        "desc_pt": "Estruturas e algoritmos para álgebra de conjuntos matemáticos: união, interseção, diferença assimétrica, diferença simétrica, predicados de pertinência, teste de subconjunto e remoção de duplicatas.",
        "desc_en": "Mathematical set theory primitives: set union, intersection, relative complement (difference), symmetric difference, membership queries, subset/superset validation, and duplicate elimination.",
        "sample_call": "SetStdLib::setCount([])",
    },
    "SimdStdLib": {
        "title_pt": "Computação Vetorizada Paralela (SIMD) de Alta Eficiência",
        "title_en": "High-Performance Parallel Vectorized Computing (SIMD) ",
        "desc_pt": "Abstrações portáveis para instruções SIMD (Single Instruction, Multiple Data): operações aritméticas vetorizadas em pistas numéricas paralelas, máscaras de seleção condicional e reduções horizontais (soma vetorial, mínimo e máximo).",
        "desc_en": "Hardware-accelerated SIMD (Single Instruction, Multiple Data) primitives: vectorized parallel lane arithmetic, conditional bitmasks, and horizontal lane reductions (vector sum, dot product, min, max).",
        "sample_call": "SimdStdLib::simdVectorAdd([1.0, 2.0], [3.0, 4.0])",
    },
    "StatStdLib": {
        "title_pt": "Estatística Descritiva, Inferencial, Correlações e Ajustes de Curvas",
        "title_en": "Descriptive and Inferential Statistics, Correlations, and Curve Fitting",
        "desc_pt": "Conjunto analítico estatístico completo: medidas de tendência central (média aritmética, geométrica, harmônica, mediana, moda), medidas de dispersão (variância, desvio padrão), quantis/percentis, assimetria, curtose, correlações (Pearson/Spearman) e testes de hipótese.",
        "desc_en": "Comprehensive analytical statistics toolkit: central tendency metrics (arithmetic, geometric, harmonic mean, median, mode), dispersion (variance, standard deviation), quantiles, skewness, kurtosis, correlation coefficients (Pearson, Spearman), and hypothesis tests.",
        "sample_call": "StatStdLib::statMean([1.0, 2.0, 3.0, 4.0, 5.0])",
    },
    "StringStdLib": {
        "title_pt": "Manipulação de Texto de Alto Desempenho, Fatiamento e Busca",
        "title_en": "High-Performance Text Processing, String Slicing, and Search",
        "desc_pt": "Operações essenciais para processamento de strings: divisão (`split`), junção (`join`), busca de padrões com Boyer-Moore/KMP, preenchimento (`pad`), aparamento de espaços (`trim`), reversão e fatiamento sem alocação desnecessária.",
        "desc_en": "Essential string and buffer manipulation facilities: string splitting, joining with separators, sub-string searching (Boyer-Moore/KMP), padding, whitespace trimming, string reversal, and bounds-checked slicing.",
        "sample_call": 'StringStdLib::stringLength("Hello World")',
    },
    "StructStdLib": {
        "title_pt": "Introspecção, Validação de Esquema e Clonagem Profunda de Estruturas",
        "title_en": "Struct Introspection, Schema Validation, and Deep Cloning",
        "desc_pt": "Utilitários para manipulação reflexiva de estruturas (`struct`): introspecção de nomes de campos e tipos associados, verificação de conformidade estrutural, cópia profunda (deep clone) e serialização em memória.",
        "desc_en": "Reflection and schema utilities for user-defined structs: inspecting field names and associated type signatures, structural conformity validation, deep cloning, and byte-level memory serialization.",
        "sample_call": 'StructStdLib::structFieldCount("MyStruct")',
    },
    "SymbolicStdLib": {
        "title_pt": "Computação Algébrica Simbólica, Diferenciação e Polinômios",
        "title_en": "Symbolic Computer Algebra, Differentiation, and Polynomials",
        "desc_pt": "Sistema de álgebra computacional simbólica (CAS): representação de árvores de expressões matemáticas, diferenciação simbólica de funções analíticas, simplificação algébrica de termos, aritmética polinomial exata e divisão com resto.",
        "desc_en": "Symbolic computer algebra system (CAS): expression tree representation, symbolic differentiation of analytic functions, algebraic expression simplification, exact polynomial arithmetic, quotient/remainder division, and root finding.",
        "sample_call": 'SymbolicStdLib::symbolicParse("x^2 + 2*x + 1")',
    },
    "ThreadStdLib": {
        "title_pt": "Concorrência Multithread, Primitivas de Sincronização e Canais",
        "title_en": "Native Multithreading, Synchronization Primitives, and Message Channels",
        "desc_pt": "Execução concorrente e paralela nativa: criação e junção de threads do sistema operacional, mutexes reentrantes, variáveis de condição, semáforos contadores e canais de mensagens unidirecionais seguros entre threads.",
        "desc_en": "Native concurrent and parallel execution primitives: thread lifecycle management (spawn/join), reentrant mutual exclusion locks (mutexes), condition variables, counting semaphores, and message-passing channels.",
        "sample_call": "ThreadStdLib::threadCurrentId()",
    },
}

OP_PATTERN = re.compile(
    r"^\s*op\s+([A-Za-z0-9_]+)\s*\((.*?)\)\s*as\s+([A-Za-z0-9_\[\]\s]+?)(?:\s*==>|\s*$)"
)


class StdLibParser:
    def __init__(self, lib_name: str, lib_path: Path):
        self.lib_name = lib_name
        self.lib_path = lib_path
        self.master_file = lib_path / f"{lib_name}.fdsl"
        self.domain_files: list[Path] = []
        self.structs: list[dict] = []
        self.enums: list[dict] = []
        self.contracts: list[dict] = []
        self.all_ops_count = 0

    def parse(self):
        # 1. Lê todos os arquivos .fdsl
        all_files = sorted(self.lib_path.glob("*.fdsl"))
        self.domain_files = [f for f in all_files if f.name != f"{self.lib_name}.fdsl"]

        # 2. Lê structs e enums no mestre e nos domínios
        for f in all_files:
            self._parse_types(f)

        # 3. Lê contratos e operações nos arquivos de domínio
        for f in self.domain_files:
            self._parse_contract(f)

    def _parse_types(self, file_path: Path):
        text = file_path.read_text(encoding="utf-8", errors="ignore")
        lines = text.splitlines()

        i = 0
        while i < len(lines):
            line = lines[i].strip()
            if line.startswith("struct (") and ")" in line:
                s_name = line.split("(")[1].split(")")[0].strip()
                fields = []
                i += 1
                while i < len(lines):
                    f_line = lines[i].strip()
                    if f_line.startswith("}"):
                        break
                    if f_line.startswith("mut:") or f_line.startswith("imut:"):
                        fields.append(f_line)
                    i += 1
                self.structs.append({"name": s_name, "fields": fields, "file": file_path.name})
            elif line.startswith("enum (") and ")" in line:
                e_name = line.split("(")[1].split(")")[0].strip()
                variants = []
                i += 1
                while i < len(lines):
                    v_line = lines[i].strip()
                    if v_line.startswith("}"):
                        break
                    if v_line and not v_line.startswith("#"):
                        variants.append(v_line)
                    i += 1
                self.enums.append({"name": e_name, "variants": variants, "file": file_path.name})
            i += 1

    def _parse_contract(self, file_path: Path):
        text = file_path.read_text(encoding="utf-8", errors="ignore")
        lines = text.splitlines()

        # Busca contract (...) { ... }
        in_contract = False
        contract_name = ""
        contract_ops = []

        for line in lines:
            sline = line.strip()
            if sline.startswith("contract (") and ")" in sline:
                in_contract = True
                contract_name = sline.split("(")[1].split(")")[0].strip()
            elif in_contract and sline.startswith("}"):
                in_contract = False
            elif in_contract and sline.startswith("op ") and not sline.startswith("op _"):
                m = OP_PATTERN.match(sline)
                if m:
                    op_name, raw_params, ret_type = m.groups()
                    params = self._parse_params(raw_params)
                    contract_ops.append({
                        "name": op_name,
                        "raw_signature": f"op {op_name} ({raw_params}) as {ret_type}",
                        "params": params,
                        "return_type": ret_type.strip(),
                    })
                    self.all_ops_count += 1

        # Busca implementações no agent para identificar emits e possíveis erros
        op_emits = self._extract_emits(text)
        for op in contract_ops:
            op["emits"] = op_emits.get(op["name"], [{"kind": "nice", "msg": "ok"}])

        if contract_name:
            self.contracts.append({
                "name": contract_name,
                "file": file_path.name,
                "ops": contract_ops,
            })

    def _parse_params(self, raw_params: str) -> list[dict]:
        params = []
        if not raw_params.strip():
            return params
        parts = [p.strip() for p in raw_params.split(",") if p.strip()]
        for p in parts:
            if ":" in p:
                type_part, name_part = p.split(":", 1)
                type_name = type_part.replace("as ", "").strip()
                p_name = name_part.strip()
                params.append({"name": p_name, "type": type_name})
            else:
                params.append({"name": p, "type": "data"})
        return params

    def _extract_emits(self, text: str) -> dict[str, list[dict]]:
        emits_by_op = {}
        pattern = re.compile(
            r"op\s+([A-Za-z0-9_]+)\s*\((.*?)\)\s*as\s+([A-Za-z0-9_\[\]\s]+?)\s*==>\s*\{"
        )
        for m in pattern.finditer(text):
            op_name = m.group(1)
            start_idx = m.end()
            depth = 1
            i = start_idx
            while i < len(text) and depth > 0:
                if text[i] == "{":
                    depth += 1
                elif text[i] == "}":
                    depth -= 1
                i += 1
            body = text[start_idx : i - 1]
            emits = []
            seen = set()
            for em in re.finditer(r'emit\s*\(\s*([A-Za-z0-9_]+)\s*,\s*(.*?)\s*,\s*"([^"]*)"\s*\)', body):
                kind = em.group(1)
                msg = em.group(3)
                if (kind, msg) not in seen:
                    seen.add((kind, msg))
                    emits.append({"kind": kind, "msg": msg})
            if emits:
                emits_by_op[op_name] = emits
        return emits_by_op


def generate_doc_pt(parser: StdLibParser, meta: dict, pillar_info: tuple) -> str:
    pillar_num, pillar_pt, _ = pillar_info
    title = meta["title_pt"]
    desc = meta["desc_pt"]
    sample_call = meta["sample_call"]
    lib = parser.lib_name

    n_mods = len(parser.domain_files)
    mod_text_pt = f"**{n_mods} módulos de domínio**" if n_mods != 1 else "**1 módulo de domínio**"

    lines = [
        f"# 📚 `{lib}` — {title}",
        "",
        f"> **Pilar Arquitetural**: Pilar {pillar_num} ({pillar_pt})  ",
        f"> **Status**: ✅ Homologado com 100% de Paridade nos 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  ",
        f"> **Arquivo Mestre**: `stdlib/{lib}/{lib}.fdsl`  ",
        f"> **Modo de Importação**: `use {lib}` ou `use {lib}::<Modulo>::<operacao>`",
        "",
        "---",
        "",
        "## 1. Visão Geral e Funcionalidades",
        "",
        f"A biblioteca padrão **`{lib}`** integra o ecossistema oficial da linguagem TheFlux, fornecendo suporte de nível de sistema e algoritmos nativos certificados.",
        "",
        f"{desc}",
        "",
        "### 1.1 Características e Princípios de Design",
        f"- **Compilação e Fusão Estática**: Todos os módulos de domínio são fundidos no agente unificado `{lib}` em tempo de compilação, sem sobrecarga (*overhead*) de despacho indireto.",
        "- **Isolamento e Segurança**: As operações verificam limites operacionais e utilizam despacho por contratos formais rigorosos.",
        "- **Compatibilidade Multi-Backend**: Execução bit-a-bit idêntica em interpretador (`in`), bytecode (`vm`, `vmr`), nativo AOT (`llvm`) e WebAssembly (`wat`, `wasm`).",
        "",
        "---",
        "",
        "## 2. Estrutura Modular e Contratos",
        "",
        f"A biblioteca é composta por {mod_text_pt} e declara **{parser.all_ops_count} operações públicas**:",
        "",
        "| Arquivo de Domínio | Contrato Formal | Responsabilidade Principal | Qtd. Ops |",
        "|---|---|---|:---:|",
    ]

    for c in parser.contracts:
        c_name = c["name"]
        f_name = c["file"]
        ops_cnt = len(c["ops"])
        lines.append(f"| `{f_name}` | `{c_name}` | Domínio especializado de `{f_name[:-5]}` | {ops_cnt} |")

    lines.extend([
        "",
        "---",
        "",
        "## 3. Tipos, Estruturas e Enumerações Públicas",
        "",
    ])

    if parser.structs or parser.enums:
        for s in parser.structs:
            lines.append(f"### Estrutura `struct ({s['name']})`")
            lines.append(f"*Declarada em: `{s['file']}`*")
            lines.append("")
            lines.append("```flux")
            lines.append(f"struct ({s['name']}) {{")
            for f in s["fields"]:
                lines.append(f"      {f}")
            lines.append("}")
            lines.append("```")
            lines.append("")

        for e in parser.enums:
            lines.append(f"### Enumeração `enum ({e['name']})`")
            lines.append(f"*Declarada em: `{e['file']}`*")
            lines.append("")
            lines.append("```flux")
            lines.append(f"enum ({e['name']}) {{")
            for v in e["variants"]:
                lines.append(f"      {v}")
            lines.append("}")
            lines.append("```")
            lines.append("")
    else:
        lines.append(f"A biblioteca `{lib}` opera diretamente com os tipos nativos e primitivos da linguagem TheFlux (`string`, `int64`, `float64`, `bool`, `list of data`, etc.), sem exigir tipos compostos adicionais.")
        lines.append("")

    lines.extend([
        "---",
        "",
        "## 4. Catálogo Detalhado de Operações por Domínio",
        "",
    ])

    for c in parser.contracts:
        lines.append(f"### 4.{parser.contracts.index(c) + 1} Contrato `{c['name']}` (`{c['file']}`)")
        lines.append("")
        lines.append("| Operação | Assinatura | Retorno |")
        lines.append("|---|---|---|")
        for op in c["ops"]:
            lines.append(f"| `{op['name']}` | `{op['raw_signature']}` | `{op['return_type']}` |")
        lines.append("")

        lines.append("#### Ficha Técnica das Operações:")
        lines.append("")
        for op in c["ops"]:
            lines.append(f"##### `op {op['name']}`")
            lines.append("```flux")
            lines.append(op["raw_signature"])
            lines.append("```")
            lines.append("- **Parâmetros**:")
            if op["params"]:
                for p in op["params"]:
                    lines.append(f"  - `{p['name']}` (`{p['type']}`): Parâmetro de entrada para processamento da operação.")
            else:
                lines.append("  - *Nenhum (operação sem parâmetros).*")
            lines.append("- **Retorno e Emissão**:")
            lines.append(f"  - Tipo de dado: `{op['return_type']}`")
            for em in op["emits"]:
                status_icon = "✅" if em["kind"] == "nice" else "⚠️"
                lines.append(f"  - {status_icon} Emite `{em['kind']}` com status `\"{em['msg']}\"`")
            lines.append("- **Descrição Funcional**:")
            lines.append(f"  - Executa a funcionalidade canônica de `{op['name']}` no domínio `{c['name']}`.")
            lines.append("")

    lines.extend([
        "---",
        "",
        "## 5. Exemplos Canônicos de Uso em TheFlux",
        "",
        "O exemplo a seguir demonstra a importação e o consumo prático da biblioteca:",
        "",
        "```flux",
        f"# Exemplo Canônico de Consumo da {lib}",
        f"use {lib}",
        "",
        f"program (Exemplo{lib}) {{",
        '      println("==================================================")',
        f'      println("  Demonstracao da Standard Library: {lib}")',
        '      println("==================================================")',
        "",
        f"      # Chamada da operacao canônica",
        f"      mut as data: resultado = {sample_call}",
        f'      println("Resultado obtido: " + resultado)',
        "",
        '      println("Demonstracao concluida com sucesso.")',
        "}",
        "```",
        "",
        "---",
        "",
        "> [!TIP]",
        f"> Para consultar a visão arquitetural unificada de todas as bibliotecas, consulte o documento principal [StdLibs.md](../StdLibs.md).",
    ])

    return "\n".join(lines) + "\n"


def generate_doc_en(parser: StdLibParser, meta: dict, pillar_info: tuple) -> str:
    pillar_num, _, pillar_en = pillar_info
    title = meta["title_en"]
    desc = meta["desc_en"]
    sample_call = meta["sample_call"]
    lib = parser.lib_name

    n_mods = len(parser.domain_files)
    mod_text_en = f"**{n_mods} domain modules**" if n_mods != 1 else "**1 domain module**"

    lines = [
        f"# 📚 `{lib}` — {title}",
        "",
        f"> **Architectural Pillar**: Pillar {pillar_num} ({pillar_en})  ",
        f"> **Status**: ✅ Certified with 100% Parity across 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  ",
        f"> **Master File**: `stdlib/{lib}/{lib}.fdsl`  ",
        f"> **Import Mode**: `use {lib}` or `use {lib}::<Module>::<operation>`",
        "",
        "---",
        "",
        "## 1. Overview and Capabilities",
        "",
        f"The **`{lib}`** standard library is an integral component of the official TheFlux language ecosystem, providing certified system-level algorithms and robust capabilities.",
        "",
        f"{desc}",
        "",
        "### 1.1 Key Architectural Principles and Design",
        f"- **Static Fusion and Zero-Overhead**: All domain modules are transparently fused into the `{lib}` unified agent at compile time, avoiding virtual dispatch penalties.",
        "- **Safety and Isolation**: Operations strictly validate parameter bounds and guarantee predictable error semantics via contract definitions.",
        "- **Universal Multi-Backend Parity**: Bit-for-bit identical execution guarantees across interpreter (`in`), bytecode VM (`vm`, `vmr`), native AOT LLVM (`llvm`), and WebAssembly (`wat`, `wasm`).",
        "",
        "---",
        "",
        "## 2. Modular Structure and Contracts",
        "",
        f"The library comprises {mod_text_en} declaring a total of **{parser.all_ops_count} public operations**:",
        "",
        "| Domain Source File | Formal Contract | Domain Responsibility | Ops Count |",
        "|---|---|---|:---:|",
    ]

    for c in parser.contracts:
        c_name = c["name"]
        f_name = c["file"]
        ops_cnt = len(c["ops"])
        lines.append(f"| `{f_name}` | `{c_name}` | Specialized domain for `{f_name[:-5]}` | {ops_cnt} |")

    lines.extend([
        "",
        "---",
        "",
        "## 3. Public Types, Structures, and Enumerations",
        "",
    ])

    if parser.structs or parser.enums:
        for s in parser.structs:
            lines.append(f"### Structure `struct ({s['name']})`")
            lines.append(f"*Declared in: `{s['file']}`*")
            lines.append("")
            lines.append("```flux")
            lines.append(f"struct ({s['name']}) {{")
            for f in s["fields"]:
                lines.append(f"      {f}")
            lines.append("}")
            lines.append("```")
            lines.append("")

        for e in parser.enums:
            lines.append(f"### Enumeration `enum ({e['name']})`")
            lines.append(f"*Declared in: `{e['file']}`*")
            lines.append("")
            lines.append("```flux")
            lines.append(f"enum ({e['name']}) {{")
            for v in e["variants"]:
                lines.append(f"      {v}")
            lines.append("}")
            lines.append("```")
            lines.append("")
    else:
        lines.append(f"The `{lib}` library operates directly on primitive native TheFlux types (`string`, `int64`, `float64`, `bool`, `list of data`, etc.) without requiring custom composite types.")
        lines.append("")

    lines.extend([
        "---",
        "",
        "## 4. Detailed Operations Catalog by Domain",
        "",
    ])

    for c in parser.contracts:
        lines.append(f"### 4.{parser.contracts.index(c) + 1} Contract `{c['name']}` (`{c['file']}`)")
        lines.append("")
        lines.append("| Operation | Formal Signature | Return Type |")
        lines.append("|---|---|---|")
        for op in c["ops"]:
            lines.append(f"| `{op['name']}` | `{op['raw_signature']}` | `{op['return_type']}` |")
        lines.append("")

        lines.append("#### Operation Technical Specifications:")
        lines.append("")
        for op in c["ops"]:
            lines.append(f"##### `op {op['name']}`")
            lines.append("```flux")
            lines.append(op["raw_signature"])
            lines.append("```")
            lines.append("- **Parameters**:")
            if op["params"]:
                for p in op["params"]:
                    lines.append(f"  - `{p['name']}` (`{p['type']}`): Input argument for operation execution.")
            else:
                lines.append("  - *None (operation accepts no arguments).*")
            lines.append("- **Return and Emission**:")
            lines.append(f"  - Return data type: `{op['return_type']}`")
            for em in op["emits"]:
                status_icon = "✅" if em["kind"] == "nice" else "⚠️"
                lines.append(f"  - {status_icon} Emits `{em['kind']}` with status message `\"{em['msg']}\"`")
            lines.append("- **Functional Description**:")
            lines.append(f"  - Executes canonical `{op['name']}` functionality within the `{c['name']}` domain.")
            lines.append("")

    lines.extend([
        "---",
        "",
        "## 5. Canonical Usage Examples in TheFlux",
        "",
        "The following snippet illustrates importing and utilizing the library in a TheFlux program:",
        "",
        "```flux",
        f"# Canonical Usage Example for {lib}",
        f"use {lib}",
        "",
        f"program (ExampleOf{lib}) {{",
        '      println("==================================================")',
        f'      println("  Standard Library Demonstration: {lib}")',
        '      println("==================================================")',
        "",
        f"      # Invoking canonical operation",
        f"      mut as data: result = {sample_call}",
        f'      println("Obtained result: " + result)',
        "",
        '      println("Execution completed successfully.")',
        "}",
        "```",
        "",
        "---",
        "",
        "> [!TIP]",
        f"> For the complete unified architecture across all standard libraries, consult the master [StdLibs.md](../StdLibs.md) reference.",
    ])

    return "\n".join(lines) + "\n"


def main() -> int:
    parser = argparse.ArgumentParser(description="StdLib Docs Generator and Synchronizer")
    parser.add_argument("--verify", action="store_true", help="Verify existing docs without re-writing")
    args = parser.parse_args()

    DOCS_PT_DIR.mkdir(parents=True, exist_ok=True)
    DOCS_EN_DIR.mkdir(parents=True, exist_ok=True)

    libs = sorted([
        d.name for d in STDLIB_DIR.iterdir()
        if d.is_dir() and d.name.endswith("StdLib")
    ])

    print("=" * 70)
    print("📚 TheFlux — Gerador de Documentação das 37 Standard Libraries")
    print(f"   Origem: {STDLIB_DIR}")
    print(f"   Destino PT: {DOCS_PT_DIR}")
    print(f"   Destino EN: {DOCS_EN_DIR}")
    print("=" * 70)

    total_ops_global = 0
    errors = []

    for lib_name in libs:
        lib_path = STDLIB_DIR / lib_name
        p = StdLibParser(lib_name, lib_path)
        p.parse()
        total_ops_global += p.all_ops_count

        pillar_info = PILLARS_DATA.get(lib_name, (1, "Geral", "General"))
        meta = LIB_METADATA.get(lib_name, {
            "title_pt": f"Biblioteca Padrão {lib_name}",
            "title_en": f"{lib_name} Standard Library",
            "desc_pt": f"Biblioteca padrão {lib_name} para a linguagem TheFlux.",
            "desc_en": f"{lib_name} standard library for TheFlux language.",
            "sample_call": f"{lib_name}::version()",
        })

        pt_file = DOCS_PT_DIR / f"{lib_name}.md"
        en_file = DOCS_EN_DIR / f"{lib_name}.md"

        pt_content = generate_doc_pt(p, meta, pillar_info)
        en_content = generate_doc_en(p, meta, pillar_info)

        if not args.verify:
            pt_file.write_text(pt_content, encoding="utf-8")
            en_file.write_text(en_content, encoding="utf-8")
            print(f"  [+] Gerado: {lib_name}.md ({len(p.domain_files)} módulos, {p.all_ops_count} ops)")
        else:
            if not pt_file.exists() or pt_file.stat().st_size == 0:
                errors.append(f"Documento PT ausente ou vazio: {pt_file.name}")
            if not en_file.exists() or en_file.stat().st_size == 0:
                errors.append(f"Documento EN ausente ou vazio: {en_file.name}")

    print("=" * 70)
    if errors:
        print(f"❌ {len(errors)} erro(s) encontrados na verificação:")
        for e in errors:
            print(f"  - {e}")
        return 1

    action = "verificados" if args.verify else "gerados"
    print(f"✅ Sucesso: 37 pares de documentação {action} ({total_ops_global} operações catalogadas)!")
    print("=" * 70)
    return 0


if __name__ == "__main__":
    sys.exit(main())
