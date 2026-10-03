# TheFlux Programming Language

[![Compliance](https://img.shields.io/badge/Compliance-349%2F349%20(100%25)-brightgreen)](#)
[![Backends](https://img.shields.io/badge/Backends-6%20Alvos%20Parit%C3%A1rios-blue)](#)
[![Encoding](https://img.shields.io/badge/Encoding-UTF--8%20Strict-orange)](#)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](#)

> **TheFlux**: Uma linguagem de programação moderna orientada a contratos e agentes, com compilação multi-backend e biblioteca padrão modular de alto desempenho.

---

## 🚀 Visão Geral

TheFlux introduz um modelo expressivo centrado em **contratos** (`contract`), **agentes** (`agent`) e **operações de fluxo contínuo** (`-->` / `==>`), garantindo forte consistência semântica e determinismo através de múltiplos alvos de compilação e execução.

### Principais Características

- **Paradigma Orientado a Agentes & Contratos**: Separação clara entre especificações de interface e implementações reativas.
- **Tipagem Estática Expressiva**: Suporte a inteiros primitivos, ponto flutuante com formatos para ML, tensores/matrizes, coleções e tipos de data/hora nativos.
- **Arquitetura Multi-Backend (6 Alvos de Execução)**: O mesmo código-fonte TheFlux executa com exata paridade comportamental em todos os ambientes.
- **Biblioteca Padrão Abrangente (35 stdlibs)**: Bibliotecas modulares cobrindo formatos estruturados, bancos de dados embutidos, álgebra linear, SIMD, cálculo simbólico, concorrência preemptiva (threads nativas e canais MPMC), drivers gráficos acelerados, plotagem científica, criptografia, rede e governança de runtime.
- **DSLs Modulares de Usuário (`fdsl/`)**: Suporte a domínios específicos com analisadores léxicos, validação semântica com diagnósticos visuais (`^`), ASTs e execução em sandbox.
- **Playground Web**: Ambiente interativo WebAssembly no navegador (`web_wasm/`).

---

## 💡 Exemplo Rápido (Quick Start)

TheFlux separa especificações contratuais e lógica de agentes em arquivos `.fdsl`, consumidos por programas executáveis `.flux`:

### 1. Definição do Contrato e do Agente (`MathAgent.fdsl`)
```flux
contract CalcContract {
      op dobro (as int64: n) as int64
}

agent (MathAgent) impl CalcContract {
      op dobro (as int64: n) as int64 ==> {
            emit(nice, n * 2, "ok")
      }
}
```

### 2. Programa Principal (`Main.flux`)
```flux
use MathAgent

program (Main) {
      mut as int64: valor = 21
      mut as int64: resultado = MathAgent::dobro(valor)
      println("O dobro de " + valor + " é " + resultado)
}
```

---

## ⚙️ Os 6 Backends de Execução

Todos os programas TheFlux são compilados e validados simultaneamente em 6 ambientes de execução com 100% de paridade comportamental:

| Backend | Identificador | Status Oficial | Descrição |
| :--- | :---: | :---: | :--- |
| **Interpretador AST** | `in` | ✅ 349/349 PASS | Execução direta da Árvore Sintática Abstrata para depuração rápida e análise semântica. |
| **VM Bytecode** | `vm` | ✅ 349/349 PASS | Compilação para bytecode TheFlux (`.fvmbc`) e execução na máquina virtual otimizada. |
| **VM Runner** | `vmr` | ✅ 349/349 PASS | Execução do bytecode TheFlux recarregado do disco (`.fvmbc`). |
| **LLVM Nativo** | `llvm` | ✅ 349/349 PASS | Emissão de LLVM IR compilado via Clang com runtime de suporte em C (`flux_input.c`). |
| **WebAssembly Text** | `wat` | ✅ 349/349 PASS | Geração de WebAssembly em formato texto com chamadas WASI para portabilidade universal. |
| **WebAssembly Binário** | `wasm` | ✅ 349/349 PASS | Emissor binário direto em WASM para execução em navegadores e runtimes WASI (`wasmer`). |

---

## 📦 Catálogo da Biblioteca Padrão (`stdlib/`)

A linguagem conta com **35 bibliotecas padrão contratuais** organizadas pelos 4 pilares oficiais de desenvolvimento:

### 🔤 1. Núcleo, Texto & OO
- `CharStdLib.fdsl`: Classificação, conversão e manipulação de caracteres individuais.
- `ConvertStdLib.fdsl`: Conversões numéricas, bases matemáticas (binário, octal, hex) e parsing seguro.
- `DebugStdLib.fdsl`: Rastreamento de chamadas, pontos de parada e introspecção em tempo de depuração.
- `DslStdLib.fdsl`: Criação, análise e execução de linguagens de domínio específico (DSLs):
  - Análise léxica com regex (`DslLexerContract`).
  - Parsing e validação com diagnósticos visuais e cursor `^` (`DslParserContract`).
  - Manipulação de árvores AST e otimização por *constant folding* (`DslAstContract`).
  - Execução inline segura com injeção de contexto (`DslExecutionContract`).
  - Assembly inline de hardware com montagem e validação de registradores (`DslAsmContract`).
  - Governança de execução com limites de CPU, memória e timeout (`DslSandboxContract`).
- `FileSignatureStdLib.fdsl`: Identificação de tipos MIME e assinaturas criptográficas de arquivos.
- `FormatStdLib.fdsl`: Serialização e desserialização de formatos (JSON, CSV, YAML 1.2, TOML, Base64, URL).
- `OoStdLib.fdsl`: Herança comportamental via contratos, composição e polimorfismo seguro.
- `RegexStdLib.fdsl`: Motor de expressões regulares para busca, captura e substituição de padrões.
- `StringStdLib.fdsl`: Manipulação, mutação, transformações e validações de strings.

### 📊 2. Estruturas & Estados
- `DateTimeStdLib.fdsl`: Manipulação de datas, horas, fusos horários e relógio monotônico de alta precisão.
- `DbStdLib.fdsl`: Motores embutidos multi-modelo com persistência física em disco (`scratch/`):
  - *Relacional (SQL)*: SQLite 3.53.4
  - *Colunar / OLAP*: DuckDB
  - *Chave-Valor*: LevelDB 1.23
  - *Documentos NoSQL*: UnQLite 1.1.4
  - *Grafos de Propriedades*: KùzuDB
  - *Vetores para IA*: ObjectBox 5.3.2
- `FsmStdLib.fdsl`: Máquinas de estados finitos determinísticas orientadas a eventos.
- `ListStdLib.fdsl`: Listas ordenadas dinâmicas, busca, filtros e transformações funcionais.
- `MapStdLib.fdsl`: Tabelas hash, dicionários chave-valor, entradas e relacionamentos.
- `RandomStdLib.fdsl`: Geradores pseudo-aleatórios criptográficos e distribuições estatísticas.
- `SetStdLib.fdsl`: Teoria dos conjuntos, união, interseção, diferença e testes de pertinência.
- `StructStdLib.fdsl`: Estruturas de dados tipadas, introspecção de campos e contratos em memória.

### 🧮 3. Matemática & Gráficos
- `FinStdLib.fdsl`: Cálculos financeiros, amortizações, taxas de juros compostos e anuidades.
- `GraphPlotStdLib.fdsl`: Plotagem científica abrangente cobrindo 7 domínios (distribuições/densidades/probabilidade, relações/correlações, superfícies/campos 3D, composições/partições, sistemas curvilíneos e câmeras, modelos matemáticos/grafos, gráficos de engenharia/controle), com 19 sistemas de coordenadas curvilíneas e projeções de câmera 3D (perspectiva, ortográfica, isométrica).
- `HashStdLib.fdsl`: Hashes criptográficos (SHA-256, MD5) e checksums de integridade rápida (CRC32, Adler32).
- `LinAlgStdLib.fdsl`: Álgebra linear densa, vetores multidimensionais, matrizes, determinantes e autovalores.
- `MathStdLib.fdsl`: Operações fundamentais, trigonometria, hiperbólicas, logaritmos e arredondamentos.
- `PhysStdLib.fdsl`: Cinemática, dinâmica, eletromagnetismo e termodinâmica física.
- `SimdStdLib.fdsl`: Vetorização paralela de hardware SIMD, operações aritméticas e reduções de alta performance.
- `StatStdLib.fdsl`: Estatística descritiva, medidas de tendência central, dispersão e testes de inferência.
- `SymbolicStdLib.fdsl`: Computação algébrica simbólica, derivadas, integrais analíticas e matrizes simbólicas.

### 🌐 4. Sistema, I/O & Rede
- `GfxStdLib.fdsl` & `GuiStdLib.fdsl`: Primitivas gráficas em memória e componentes visuais imediatos (IMGUI).
- `IoStdLib.fdsl`: Manipulação física de arquivos, diretórios, percursos de árvore e deleções.
- `LowLevelStdLib.fdsl`: Acesso direto a bits, bytes, endianness e inspeção de blocos de memória.
- `NativeGfxStdLib.fdsl`: Driver gráfico nativo acelerado (Win32 GDI / HTML5 Canvas / WASI), janelamento nativo, ciclo de vida de janelas, renderização acelerada (linhas, retângulos, círculos, textos) e pooling de eventos.
- `NetStdLib.fdsl`: Redes, conectividade TCP/UDP, clientes HTTP e resolução de IP/URL.
- `OsStdLib.fdsl`: Processos, variáveis de ambiente, caminhos e controle do sistema operacional.
- `RuntimeStdLib.fdsl`: Introspecção do ambiente, controle do Garbage Collector (GC), memória e tipos.
- `ThreadStdLib.fdsl`: Concorrência preemptiva multi-threading, ciclo de vida de threads nativas (`threadSpawn`, `threadJoin`, `threadYield`), primitivas de sincronização (mutexes recursivos, condition variables, semáforos, barreiras) e canais MPMC com buffers limitados ou ilimitados.

---

## 🗄️ Catálogo de Banco de Dados

TheFlux disponibiliza suporte nativo e embutido a múltiplos paradigmas de persistência física em disco através da biblioteca padrão `DbStdLib.fdsl` e de motores compilados de alto desempenho localizados em `stdlib/db/windows/`. Cada motor atende a um padrão de acesso específico (SQL relacional, séries temporais/colunar, chave-valor, grafos de conhecimento, vetores de IA ou documentos NoSQL):

| Motor | Versão | Modelo de Dados | Subpasta em `stdlib/db/windows/` | Artefatos Principais | Principais Características |
| :--- | :---: | :--- | :--- | :--- | :--- |
| **DuckDB** | `1.5.6` | Colunar / OLAP / SQL Vetorial | `duckdb-1.5.6/` | `duckdb.dll`, `duckdb.lib`, `duckdb.exe`, `duckdb.h`, `duckdb.hpp`, `duckdb_extension.h` | Motor analítico colunar in-process de altíssima performance; otimizado para consultas analíticas complexas, agregações vetoriais massivas e integração direta com fluxos de dados de Machine Learning. |
| **KùzuDB** | `0.11.3` | Grafos de Propriedades / Cypher | `kuzudb-0.11.3/` | `kuzu_shared.dll`, `kuzu_shared.lib`, `kuzudb.exe`, `kuzu.h`, `kuzu.hpp` | Banco de dados de grafos embutido de última geração; executa consultas declarativas estruturadas em Cypher sobre nós, propriedades e arestas com indexação colunar em memória compartilhada. |
| **LevelDB** | `1.23` | Chave-Valor (LSM-Tree) | `leveldb-1.23/` | `include/leveldb/db.h`, `table/`, `util/`, `port/` | Armazenamento chave-valor de alta velocidade baseado em Log-Structured Merge-tree (LSM); provê ordenação automática de chaves, compressão Snappy opcional e throughput extremo de escrita sequencial. |
| **ObjectBox** | `5.3.2` | Vetores para IA & NoSQL de Objetos | `objectbox- 5.3.2/` | `lib/objectbox.dll`, `lib/objectbox.lib`, `include/objectbox.h`, `include/objectbox.hpp`, `include/objectbox-sync.h` | Motor de busca vetorial ultrarrápido embutido para IA (k-NN / HNSW sobre Embeddings) e persistência NoSQL orientada a objetos com suporte a transações ACID e sincronização edge/cloud. |
| **SQLite** | `3.53.4` | Relacional SQL (ACID) | `sqlite-3.53.4/` | `sqlite3.dll`, `sqlite3.def` | O clássico e mais confiável motor SQL relacional embutido do mundo; suporte completo a transações ACID, consultas tabulares padrão ANSI SQL, junções complexas e persistência em arquivo único ou `:memory:`. |
| **UnQLite** | `1.1.4` | Documentos NoSQL & KV Transacional | `unqlite-1.1.4/` | `unqlite.c`, `unqlite.h`, `unqlite.dll`, `unqlite.lib`, `license.txt` | Motor NoSQL embutido sem dependências externas; combina armazenamento de chave-valor transacional baseado em disco com um banco orientado a documentos compatível com JSON e consultas estruturadas. |

### Exemplo de Uso Integrado (`DbStdLib.fdsl`)
```flux
use DbStdLib

program (ExemploBancoDeDados) {
      #L Inicialização de banco relacional embutido SQLite
      mut as map: db = dbOpen("scratch/dados_app.db", "sqlite")
      mut as bool: criado = dbExec(db, "CREATE TABLE IF NOT EXISTS sensores (id INT PRIMARY KEY, valor REAL)")
      mut as bool: inserido = dbExec(db, "INSERT INTO sensores VALUES (1, 98.6)")
      println("Tabela criada: " + criado + ", Dado inserido: " + inserido)
      mut as bool: fechado = dbClose(db)
}
```

---

## 🧩 DSLs Modulares do Usuário (`fdsl/`)

O compilador TheFlux suporta resolução modular recursiva em subpastas dentro de `fdsl/`. Cada DSL é implementada no padrão clássico de 4 fases de compiladores:

| Subpasta | Arquivos FDSL | Domínio | Exemplo de Aplicação |
| :--- | :--- | :--- | :--- |
| **`fdsl/calc_dsl/`** | `CalcLexer`, `CalcSemantic`, `CalcAst`, `CalcExecutor` | Expressões Aritméticas | Avaliação de fórmulas matemáticas com precedência e parênteses. |
| **`fdsl/rule_dsl/`** | `RuleLexer`, `RuleSemantic`, `RuleAst`, `RuleExecutor` | Regras de Negócio | Tomada de decisão declarativa (`SE saldo > 500 ENTAO liberar`). |
| **`fdsl/asm_dsl/`** | `AsmLexer`, `AsmSemantic`, `AsmAst`, `AsmExecutor` | Assembly Inline | Mnemônicos de máquina (`mov`, `imul`, `rdtsc`) e validação de registradores. |
| **`fdsl/logo_dsl/`** | `LogoLexer`, `LogoSemantic`, `LogoAst`, `LogoExecutor` | Tartaruga 2D / Logo | Navegação cartesiana (`FRENTE 20; GIRAR DIREITA; FRENTE 10`). |

---

## 📂 Estrutura do Repositório

```text
TheFlux/
├── docs/                        # Especificação EBNF, gramática, manuais de DB e documentação técnica
├── fdsl/                        # Agentes de exemplo e DSLs modulares em subpastas
│   ├── asm_dsl/                 # DSL de Assembly Inline (Lexer, Semantic, AST, Executor)
│   ├── calc_dsl/                # DSL de Cálculo Aritmético (Lexer, Semantic, AST, Executor)
│   ├── logo_dsl/                # DSL Logo de Navegação 2D (Lexer, Semantic, AST, Executor)
│   └── rule_dsl/                # DSL de Regras de Negócio (Lexer, Semantic, AST, Executor)
├── flux/                        # 349 programas e suítes canônicas de teste (.flux)
├── intermediates/               # Saídas intermediárias (ast, lexer, llvm, semantic, wasm, wat)
├── runtime/                     # Suporte de runtime
├── src/                         # Núcleo do compilador e backends (src/flux_proto)
│   └── flux_proto/              # Lexer, Parser, AST, Semântica, VM, LLVM, WAT, WASM
│       ├── ast/                 # Árvores sintáticas AST
│       ├── ddg/                 # Árvores sintáticas DDG
│       ├── interpreter/         # Interpretador AST interativo
│       ├── lexer/               # Análise léxica
│       ├── llvm/                # Emissão LLVM IR nativo + runtime C (flux_input.c)
│       ├── macro/               # Expansor de macros
│       ├── parser/              # Análise sintática
│       ├── semantic/            # Análise semântica, tabela de símbolos e tipos
│       ├── telemetry/           # Substima de telemetria de dados
│       ├── vm/                  # Bytecode + máquina virtual (.fvmbc)
│       ├── wat/                 # Backends WebAssembly texto (.wat)
│       └── wasm/                # Backends WebAssembly binário (.wasm)
├── stdlib/                      # 35 Bibliotecas Padrão em FDSL (.fdsl)
│   ├── db/                      # Motores de banco de dados embutidos (cabeçalhos C/C++ e binários)
│   │   └── windows/             # Distribuições nativas Windows x64
│   │       ├── duckdb-1.5.6/    # Motor colunar OLAP (DLL, LIB, EXE, headers C/C++)
│   │       ├── kuzudb-0.11.3/   # Motor de grafos de propriedades Cypher (DLL, LIB, EXE, headers)
│   │       ├── leveldb-1.23/    # Motor chave-valor LSM-Tree (código-fonte, headers e utilitários)
│   │       ├── objectbox- 5.3.2/# Motor de vetores para IA e objetos NoSQL (DLL, LIB, headers)
│   │       ├── sqlite-3.53.4/   # Motor relacional SQL transacional (DLL, DEF)
│   │       └── unqlite-1.1.4/   # Motor NoSQL de documentos e chave-valor (C, H, DLL, LIB)
│   ├── CharStdLib.fdsl          # Manipulação e mutação de caracteres
│   ├── ConvertStdLib.fdsl       # Conversões numéricas, bases matemáticas e parsing
│   ├── DateTimeStdLib.fdsl      # Data, tempo, fuso horário e relógio monotônico
│   ├── DbStdLib.fdsl            # Motores de banco de dados embutidos (SQL, KV, Doc, Colunar, Grafo, Vetor)
│   ├── DebugStdLib.fdsl         # Rastreamento, breakpoints e introspecção
│   ├── DslStdLib.fdsl           # Lexer, Parser, AST, execução inline e assembly de DSLs
│   ├── FileSignatureStdLib.fdsl # Assinaturas de arquivo e identificação MIME
│   ├── FinStdLib.fdsl           # Cálculos financeiros, amortizações e juros
│   ├── FormatStdLib.fdsl        # Formatos estruturados (JSON, CSV, YAML 1.2, TOML, Base64, URL)
│   ├── FsmStdLib.fdsl           # Máquinas de estados finitos determinísticas
│   ├── GfxStdLib.fdsl           # Primitivas gráficas e renderização
│   ├── GraphPlotStdLib.fdsl     # Plotagem científica avançada (7 domínios, 19 sistemas de coordenadas)
│   ├── GuiStdLib.fdsl           # Componentes visuais de interface gráfica
│   ├── HashStdLib.fdsl          # Hashes criptográficos e checksums de integridade
│   ├── IoStdLib.fdsl            # Arquivos físicos em disco, diretórios e percursos
│   ├── LinAlgStdLib.fdsl        # Álgebra linear, vetores densos, matrizes e autovalores
│   ├── ListStdLib.fdsl          # Listas dinâmicas, busca, filtros e transformações
│   ├── LowLevelStdLib.fdsl      # Operações de baixo nível, bits, bytes e memória
│   ├── MapStdLib.fdsl           # Dicionários, tabelas hash chave-valor e entradas
│   ├── MathStdLib.fdsl          # Matemática fundamental, trigonometria e logaritmos
│   ├── NativeGfxStdLib.fdsl     # Driver gráfico nativo Win32 GDI / HTML5 Canvas / WASI
│   ├── NetStdLib.fdsl           # Redes, sockets TCP/UDP, HTTP e IPs
│   ├── OoStdLib.fdsl            # Orientação a objetos, herança por contratos e despacho
│   ├── OsStdLib.fdsl            # Processos, ambiente e sistema operacional
│   ├── PhysStdLib.fdsl          # Cinemática, dinâmica, gravidade e simulações físicas
│   ├── RandomStdLib.fdsl        # Geradores pseudo-aleatórios e distribuições
│   ├── RegexStdLib.fdsl         # Motor de expressões regulares
│   ├── RuntimeStdLib.fdsl       # Introspecção de runtime, GC, heap e metadados
│   ├── SetStdLib.fdsl           # Álgebra e teoria de conjuntos
│   ├── SimdStdLib.fdsl          # Vetores paralelos de hardware SIMD e matrizes
│   ├── StatStdLib.fdsl          # Estatística descritiva, dispersão e inferência
│   ├── StringStdLib.fdsl        # Manipulação, mutação e busca em strings
│   ├── StructStdLib.fdsl        # Estruturas de dados tipadas e contratos em memória
│   ├── SymbolicStdLib.fdsl      # Computação algébrica simbólica e cálculo analítico
│   └── ThreadStdLib.fdsl        # Concorrência preemptiva multi-threading e sincronização
├── web_wasm/                    # Frontend web e playground interativo WebAssembly
├── backend_compliance.py        # Harness oficial de testes de conformidade dos 6 backends
├── backend_compliance.md        # Relatório de conformidade dos 349 testes (100% PASS)
├── backend_compliance_OLD.md    # Baseline de regressão dos testes anteriores
├── flux_in.py                   # Runner: interpretador AST interativo
├── flux_vm.py                   # Runner: compilação para bytecode VM
├── flux_vmr.py                  # Runner: execução de bytecode recarregado do disco
├── flux_lv.py                   # Runner: compilação e execução via LLVM nativo
├── flux_wat.py                  # Runner: compilação para WebAssembly Text
└── flux_was.py                  # Runner: compilação para WebAssembly Binário
```

---

## 🛠️ Requisitos e Instalação

### Pré-requisitos

- **Python 3.11+**
- **LLVM / Clang** (para o backend nativo `llvm`)
- **WABT** (`wat2wasm`) e **Wasmer** ou **Wasmtime** (para os backends `wat` e `wasm`)

### Configuração do Ambiente

```sh
# Linux / macOS:
export PYTHONPATH="src"

# Windows PowerShell:
$env:PYTHONPATH = "src"
```

---

## 🧪 Execução e Testes

### Executar um Programa Individual

Para rodar qualquer arquivo `.flux` em qualquer um dos 6 backends:

```sh
# Executar via Interpretador AST:
python flux_in.py flux/ExampleOfArithmetic.flux

# Compilar via Bytecode VM:
python flux_vm.py flux/ExampleOfArithmetic.flux

# Executar via Bytecode VM recarregado do disco:
python flux_vmr.py flux/ExampleOfArithmetic.flux

# Compilar e executar via LLVM Nativo:
python flux_lv.py flux/ExampleOfArithmetic.flux

# Compilar e executar via WebAssembly Text:
python flux_wat.py flux/ExampleOfArithmetic.flux

# Compilar e executar via WebAssembly Binário:
python flux_was.py flux/ExampleOfArithmetic.flux
```

### Rodar a Suíte Completa de Conformidade

O harness `backend_compliance.py` valida todos os arquivos de teste simultaneamente nos 6 backends, garantindo paridade exata de saída caractere por caractere:

```sh
python backend_compliance.py
```

> **Status Atual**: **349/349 arquivos com 100% de conformidade nos 6 backends** (2094 de 2094 verificações verdes, 0 divergências, 0 regressões).

---

## 🌐 Playground WebAssembly

Para testar o compilador no navegador através do ambiente WASM:

```sh
cd web_wasm
python server.py
```
Acesse `http://localhost:8000` para editar, compilar e executar TheFlux no browser.

---

## 📄 Licença

Este projeto é desenvolvido para fins de pesquisa e desenvolvimento de linguagens de programação. Consulte a documentação em [`docs/`](docs/) para obter detalhes completos da especificação e licença.

Distribuído sob os termos da licença **GNU General Public License v3.0 (GPL-3.0)**.
