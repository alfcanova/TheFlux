# TheFlux Programming Language

[![Compliance](https://img.shields.io/badge/Compliance-338%2F338%20(100%25)-brightgreen)](#)
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
- **Biblioteca Padrão Abrangente (32 stdlibs)**: Bibliotecas modulares cobrindo formatos estruturados, bancos de dados embutidos, álgebra linear, SIMD, cálculo simbólico, criptografia, rede e governança de runtime.
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
| **Interpretador AST** | `in` | ✅ 338/338 PASS | Execução direta da Árvore Sintática Abstrata para depuração rápida e análise semântica. |
| **VM Bytecode** | `vm` | ✅ 338/338 PASS | Compilação para bytecode TheFlux (`.fvmbc`) e execução na máquina virtual otimizada. |
| **VM Runner** | `vmr` | ✅ 338/338 PASS | Execução do bytecode TheFlux recarregado do disco (`.fvmbc`). |
| **LLVM Nativo** | `llvm` | ✅ 338/338 PASS | Emissão de LLVM IR compilado via Clang com runtime de suporte em C (`flux_input.c`). |
| **WebAssembly Text** | `wat` | ✅ 338/338 PASS | Geração de WebAssembly em formato texto com chamadas WASI para portabilidade universal. |
| **WebAssembly Binário** | `wasm` | ✅ 338/338 PASS | Emissor binário direto em WASM para execução em navegadores e runtimes WASI (`wasmer`). |

---

## 📦 Catálogo da Biblioteca Padrão (`stdlib/`)

A linguagem conta com **32 bibliotecas padrão contratuais** organizadas por domínio de aplicação:

### Dados & Formatos Estruturados
- `FormatStdLib.fdsl`: Serialização e desserialização de formatos (JSON, CSV, YAML 1.2, TOML, Base64, URL).
- `StructStdLib.fdsl`: Estruturas de dados tipadas, introspecção de campos e contratos em memória.
- `ConvertStdLib.fdsl`: Conversões numéricas, bases matemáticas (binário, octal, hex) e parsing seguro.
- `StringStdLib.fdsl`: Manipulação, mutação, transformações e validações de strings.
- `CharStdLib.fdsl`: Classificação, conversão e manipulação de caracteres individuais.

### Coleções & Estruturas de Dados
- `ListStdLib.fdsl`: Listas ordenadas dinâmicas, busca, filtros e transformações funcionais.
- `MapStdLib.fdsl`: Tabelas hash, dicionários chave-valor, entradas e relacionamentos.
- `SetStdLib.fdsl`: Teoria dos conjuntos, união, interseção, diferença e testes de pertinência.

### Matemática, Álgebra & Computação Científica
- `MathStdLib.fdsl`: Operações fundamentais, trigonometria, hiperbólicas, logaritmos e arredondamentos.
- `LinAlgStdLib.fdsl`: Álgebra linear densa, vetores multidimensionais, matrizes, determinantes e autovalores.
- `SimdStdLib.fdsl`: Vetorização paralela de hardware SIMD, operações aritméticas e reduções de alta performance.
- `SymbolicStdLib.fdsl`: Computação algébrica simbólica, derivadas, integrais analíticas e matrizes simbólicas.
- `StatStdLib.fdsl`: Estatística descritiva, medidas de tendência central, dispersão e testes de inferência.
- `RandomStdLib.fdsl`: Geradores pseudo-aleatórios criptográficos e distribuições estatísticas.
- `FinStdLib.fdsl`: Cálculos financeiros, amortizações, taxas de juros compostos e anuidades.

### Persistência & Bancos de Dados Embutidos
- `DbStdLib.fdsl`: Motores embutidos multi-modelo com persistência física em disco (`scratch/`):
  - *Relacional (SQL)*: SQLite 3.53.4
  - *Colunar / OLAP*: DuckDB
  - *Chave-Valor*: LevelDB 1.23
  - *Documentos NoSQL*: UnQLite 1.1.4
  - *Grafos de Propriedades*: KùzuDB
  - *Vetores para IA*: ObjectBox 5.3.2
- `IoStdLib.fdsl`: Manipulação física de arquivos, diretórios, percursos de árvore e deleções.
- `FileSignatureStdLib.fdsl`: Identificação de tipos MIME e assinaturas criptográficas de arquivos.

### Engenharia de Linguagens & DSLs
- `DslStdLib.fdsl`: Criação, análise e execução de linguagens de domínio específico (DSLs):
  - Análise léxica com regex (`DslLexerContract`).
  - Parsing e validação com diagnósticos visuais e cursor `^` (`DslParserContract`).
  - Manipulação de árvores AST e otimização por *constant folding* (`DslAstContract`).
  - Execução inline segura com injeção de contexto (`DslExecutionContract`).
  - Assembly inline de hardware com montagem e validação de registradores (`DslAsmContract`).
  - Governança de execução com limites de CPU, memória e timeout (`DslSandboxContract`).

### Sistemas, Rede & Runtime
- `RuntimeStdLib.fdsl`: Introspecção do ambiente, controle do Garbage Collector (GC), memória e tipos.
- `LowLevelStdLib.fdsl`: Acesso direto a bits, bytes, endianness e inspeção de blocos de memória.
- `NetStdLib.fdsl`: Redes, conectividade TCP/UDP, clientes HTTP e resolução de IP/URL.
- `OsStdLib.fdsl`: Processos, variáveis de ambiente, caminhos e controle do sistema operacional.
- `DateTimeStdLib.fdsl`: Manipulação de datas, horas, fusos horários e relógio monotônico de alta precisão.
- `HashStdLib.fdsl`: Hashes criptográficos (SHA-256, MD5) e checksums de integridade rápida (CRC32, Adler32).
- `RegexStdLib.fdsl`: Motor de expressões regulares para busca, captura e substituição de padrões.

### Arquitetura Reativa & Gráfica
- `OoStdLib.fdsl`: Herança comportamental via contratos, composição e polimorfismo seguro.
- `FsmStdLib.fdsl`: Máquinas de estados finitos determinísticas orientadas a eventos.
- `GfxStdLib.fdsl` & `GuiStdLib.fdsl`: Primitivas gráficas e componentes visuais de interface.
- `PhysStdLib.fdsl`: Cinemática, dinâmica, eletromagnetismo e termodinâmica física.
- `DebugStdLib.fdsl`: Rastreamento de chamadas, pontos de parada e introspecção em tempo de depuração.

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
├── flux/                        # 338 programas e suítes canônicas de teste (.flux)
├── intermediates/               # Saídas intermediárias (ast, lexer, llvm, semantic, wasm, wat)
├── runtime/                     # Suporte de runtime
├── src/                         # Núcleo do compilador e backends (src/flux_proto)
│   └── flux_proto/              # Lexer, Parser, AST, Semântica, VM, LLVM, WAT, WASM
│       ├── ast/                 # Árvores sintáticas AST
│       ├── ddg/                 # Árvores sintáticas DDG
│       ├── interpreter/         # Interpretador AST interativo
│       ├── lexer/ - parser/     # Análise léxica
│       ├── llvm/                # Emissão LLVM IR nativo + runtime C (flux_input.c)
│       ├── macro/               # Expansor de macros
│       ├── parser/              # Análise sintática
│       ├── semantic/            # Análise semântica, tabela de símbolos e tipos
│       ├── telemetry/           # Substima de telemetria de dados
│       ├── vm/                  # Bytecode + máquina virtual (.fvmbc)
│       ├── wat/                 # Backends WebAssembly texto (.wat)
│       └── wasm/                # Backends WebAssembly binário (.wasm)
├── stdlib/                      # 32 Bibliotecas Padrão em FDSL (.fdsl)
│   ├── db/                      # Cabeçalhos C/C++ e binários dos motores de banco de dados embutidos
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
│   ├── GuiStdLib.fdsl           # Componentes visuais de interface gráfica
│   ├── HashStdLib.fdsl          # Hashes criptográficos e checksums de integridade
│   ├── IoStdLib.fdsl            # Arquivos físicos em disco, diretórios e percursos
│   ├── LinAlgStdLib.fdsl        # Álgebra linear, vetores densos, matrizes e autovalores
│   ├── ListStdLib.fdsl          # Listas dinâmicas, busca, filtros e transformações
│   ├── LowLevelStdLib.fdsl      # Operações de baixo nível, bits, bytes e memória
│   ├── MapStdLib.fdsl           # Dicionários, tabelas hash chave-valor e entradas
│   ├── MathStdLib.fdsl          # Matemática fundamental, trigonometria e logaritmos
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
│   └── SymbolicStdLib.fdsl      # Computação algébrica simbólica e cálculo analítico
├── web_wasm/                    # Frontend web e playground interativo WebAssembly
├── backend_compliance.py        # Harness oficial de testes de conformidade dos 6 backends
├── backend_compliance.md        # Relatório de conformidade dos 338 testes (100% PASS)
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

> **Status Atual**: **338/338 arquivos com 100% de conformidade nos 6 backends** (2028 de 2028 verificações verdes, 0 divergências, 0 regressões).

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
