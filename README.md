# TheFlux Programming Language

> **TheFlux**: Uma linguagem de programação moderna orientada a contratos e agentes, com compilação multi-backend e biblioteca padrão modular de alto desempenho.

---

## 🚀 Visão Geral

TheFlux introduz um modelo expressivo centrado em **contratos** (contract), **agentes** (agent) e **operações de fluxo contínuo** (-->), garantindo forte consistência semântica e determinismo através de múltiplos alvos de compilação e execução.

### Principais Características

- **Paradigma Orientado a Agentes & Contratos**: Separação clara entre especificações de interface e implementações reativas.
- **Tipagem Estática Expressiva**: Suporte a inteiros primitivos, ponto flutuante com formatos para ML, tensores/matrizes, coleções e tipos de data/hora nativos.
- **Arquitetura Multi-Backend (6 Alvos de Execução)**: O mesmo código-fonte TheFlux executa com exata paridade comportamental em todos os ambientes.
- **Biblioteca Padrão Abrangente (stdlib)**: Bibliotecas modulares cobrindo desde formatos estruturados (JSON, CSV, YAML 1.2, TOML), álgebra linear e SIMD até criptografia, rede e relógio monotônico.
- **Playground Web**: Ambiente interativo WebAssembly no navegador (web_wasm/).

---

## ⚙️ Os 6 Backends de Execução

| Backend | Identificador | Descrição |
| :--- | :---: | :--- |
| **Interpretador AST** | in | Execução direta da Árvore Sintática Abstrata para depuração rápida e análise semântica interativa. |
| **VM Bytecode** | vm | Compilação para bytecode TheFlux (.fvmbc) e execução na máquina virtual Python otimizada. |
| **VM Runner** | vmr | Execução do bytecode TheFlux. |
| **LLVM Nativo** | llvm | Emissão direta de LLVM IR compilado via Clang com runtime de suporte em C (flux_input.c). |
| **WebAssembly Text** | wat | Geração de WebAssembly em formato texto com chamadas de sistema WASI para portabilidade universal. |
| **WebAssembly Binário** | wasm | Codificador binário direto em WASM para execução em navegadores e runtimes WASI (Wasmtime, Node.js). |

---

## 📂 Estrutura do Repositório

```text
TheFlux/
├── docs/                        # Especificação EBNF, gramática e documentação técnica
├── fdsl/                        # 11 agentes FDSL de exemplo (AgentOf*.fdsl)
├── flux/                        # 305 programas e suítes de teste (.flux)
├── intermediates/               # Saídas intermediárias (ast, lexer, llvm, semantic, wasm, wat)
├── runtime/                     # Suporte de runtime
├── src/                         # Núcleo do compilador e backends (src/flux_proto)
│   └── flux_proto/              # Lexer, Parser, AST, Semântica, VM, LLVM, WAT, WASM
│       ├── ast/                 # Árvores sintáticas (AST, DDG, grafo de dependência)
│       ├── lexer/ - parser/     # Análise léxica e sintática
│       ├── semantic/            # Análise semântica, símbolos e tipos
│       ├── interpreter/         # Interpretador AST interativo
│       ├── macro/               # Sistema de macros
│       ├── vm/                  # Bytecode + máquina virtual (.fvmbc)
│       ├── llvm/                # Emissão LLVM IR nativo
│       ├── wasm/ - wat/         # Backends WebAssembly (binário e texto)
│       └── telemetry/           # Diagnóstico e instrumentação
├── stdlib/                      # Bibliotecas Padrão em FDSL (.fdsl)
│   ├── CharStdLib.fdsl          # Manipulação e mutação de char
│   ├── ConvertStdLib.fdsl       # Conversões numéricas, bases, parsing
│   ├── DateTimeStdLib.fdsl      # Data, tempo, fuso horário, relógio monotônico
│   ├── DebugStdLib.fdsl         # Debug de programas
│   ├── FileSignatureStdLib.fdsl # Assinatura, autenticação de arquivos e diretórios
│   ├── FinStdLib.fdsl           # Cálculos financeiros
│   ├── FormatStdLib.fdsl        # Formatos estruturados (JSON, CSV, YAML 1.2, TOML, Base64, URL)
│   ├── FsmStdLib.fdsl           # Máquinas de estados finitos
│   ├── GfxStdLib.fdsl           # Gráficos e renderização
│   ├── GuiStdLib.fdsl           # Interface gráfica
│   ├── HashStdLib.fdsl          # Criptografia, checksums, hashes rápidos
│   ├── IoStdLib.fdsl            # Arquivos, diretórios, inspeção
│   ├── LinAlgStdLib.fdsl        # Álgebra linear, vetores, matrizes, autovalores
│   ├── ListStdLib.fdsl          # Listas e sequências
│   ├── LowLevelStdLib.fdsl      # Operações de baixo nível
│   ├── MapStdLib.fdsl           # Dicionários, mapas chave-valor, entradas e transformações
│   ├── MathStdLib.fdsl          # Matemática fundamental, trigonometria, estatística
│   ├── NetStdLib.fdsl           # Redes, sockets, HTTP
│   ├── OoStdLib.fdsl            # Orientação a objetos
│   ├── OsStdLib.fdsl            # Processos, ambiente, sistema operacional
│   ├── PhysStdLib.fdsl          # Física e simulações
│   ├── RandomStdLib.fdsl        # Geradores pseudo-aleatórios e distribuições
│   ├── RegexStdLib.fdsl         # Expressões regulares
│   ├── SetStdLib.fdsl           # Teoria e álgebra de conjuntos
│   ├── StatStdLib.fdsl          # Estatística descritiva, distribuições e inferência
│   ├── StringStdLib.fdsl        # Manipulação e mutação de strings
│   └── StructStdLib.fdsl        # Estruturas e contratos de dados
├── t_benchmarks                 # Testes: bechmarks
├── t_fvmbc/                     # Testes: VM bytecode
├── t_general/                   # Testes: gerais
├── t_llvm/                      # Testes: LLVM+CLANG (.exe)
├── t_wasm-1.0/                  # Testes: WebAssembly Binary versão 1.0
├── t_wasm-2.0/                  # Testes: WebAssembly Binary versão 2.0
├── t_wasm-3.0/                  # Testes: WebAssembly Binary versão 3.0
├── t_wat-1.0/                   # Testes: WebAssembly Text versão 1.0
├── t_wat-2.0/                   # Testes: WebAssembly Text versão 2.0
├── t_wat-3.0/                   # Testes: WebAssembly Text versão 3.0
├── web_wasm/                    # Frontend web e playground interativo WebAssembly
├── backend_compliance.py        # Harness de testes de conformidade dos 6 backends
├── backend_compliance.md        # Matriz oficial de conformidade dos testes (100% PASS)
├── backend_compliance_OLD.md    # Matriz oficial de conformidade dos testes (100% PASS) versão anterior
├── exemplos_in.py               # Suíte: exemplos via interpretador AST
├── exemplos_lv.py               # Suíte: exemplos via LLVM nativo
├── exemplos_vm.py               # Suíte: exemplos via VM bytecode
├── exemplos_vmr.py              # Suíte: exemplos via VM runner
├── exemplos_was.py              # Suíte: exemplos via WebAssembly Binário
├── exemplos_wat.py              # Suíte: exemplos via WebAssembly Text
├── flux_in.py                   # Runner: interpretador AST interativo
├── flux_vm.py                   # Runner: compilar via VM bytecode
├── flux_vmr.py                  # Runner: executar bytecode via VM runner
├── flux_lv.py                   # Runner: compilar via LLVM nativo
├── flux_was.py                  # Runner: compilar via WebAssembly Binário
└── flux_wat.py                  # Runner: compilar via WebAssembly Text


```

---

## 🛠️ Requisitos e Instalação

### Pré-requisitos

- **Python 3.11+**
- **LLVM / Clang** (para o backend nativo llvm)
- **WABT** (wat2wasm) ou **Wasmtime** (para os backends wat e wasm)

### Configuração do Ambiente

```sh
# Configurar a variável de ambiente PYTHONPATH para incluir src
export PYTHONPATH="src"

# No Windows PowerShell:
$env:PYTHONPATH = "src"
```

---

## 🧪 Execução e Testes

### Executar um Programa Individual

Para rodar qualquer arquivo .flux em qualquer backend:

```sh
# Executar via Interpretador AST
python flux_in.py flux/ExampleOfArithmetic.flux

# Compilar via Bytecode VM
python flux_vm.py flux/ExampleOfArithmetic.flux

# Executar via Bytecode VM
python flux_vmr.py flux/ExampleOfArithmetic.flux

# Compilar via LLVM Nativo
python flux_lv.py flux/ExampleOfArithmetic.flux

# Compilar via WebAssembly Text
python flux_wat.py flux/ExampleOfArithmetic.flux

# Compilar via WebAssembly Binário
python flux_was.py flux/ExampleOfArithmetic.flux
```

### Rodar a Suíte Completa de Conformidade

O harness backend_compliance.py valida todos os arquivos de teste simultaneamente nos 6 backends, garantindo paridade exata de saída caractere por caractere:

```sh
python backend_compliance.py
```

> **Status Atual**: **305/305 arquivos com 100% de conformidade nos 6 backends** (1830/1830 verificações verdes, 0 divergências, 0 regressões).

---

## 🌐 Playground WebAssembly

Para testar o compilador no navegador através do ambiente WASM:

```sh
cd web_wasm
python server.py
```
Acesse http://localhost:8000 para editar, compilar e executar TheFlux no browser.

---



## 📄 Licença
Este projeto é desenvolvido para fins de pesquisa e desenvolvimento de linguagens de programação. Consulte a documentação em docs/ para obter detalhes completos da especificação e licença.

               GNU GENERAL PUBLIC LICENSE
Version 3, 29 June 2007 Copyright (C) 2007 Free Software
