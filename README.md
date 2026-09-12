# TheFlux Programming Language

> **TheFlux**: Uma linguagem de programação moderna orientada a contratos e agentes, com compilação multi-backend e biblioteca padrão modular de alto desempenho.

---

## 🚀 Visão Geral

TheFlux introduz um modelo expressivo centrado em **contratos** (contract), **agentes** (gent) e **operações de fluxo contínuo**, garantindo forte consistência semântica e determinismo através de múltiplos alvos de compilação e execução.

### Principais Características

- **Paradigma Orientado a Agentes & Contratos**: Separação clara entre especificações de interface e implementações reativas.
- **Tipagem Estática Expressiva**: Suporte a inteiros primitivos, ponto flutuante com formatos para ML, tensores/matrizes, coleções e tipos de data/hora nativos.
- **Arquitetura Multi-Backend (6 Alvos de Execução)**: O mesmo código-fonte TheFlux executa com exata paridade comportamental em todos os ambientes.
- **Biblioteca Padrão Abrangente (stdlib/)**: 14 bibliotecas modulares cobrindo desde álgebra linear e SIMD até criptografia, rede e relógio monotônico.
- **Playground Web**: Ambiente interativo WebAssembly no navegador (web_wasm/).

---

## ⚙️ Os 6 Backends de Execução

| Backend | Identificador | Descrição |
| :--- | :---: | :--- |
| **Interpretador AST** | in | Execução direta da Árvore Sintática Abstrata para depuração rápida e análise semântica interativa. |
| **VM Bytecode** | m | Compilação para bytecode TheFlux (.fvmbc) e execução na máquina virtual Python otimizada. |
| **VM Rust** | mr | Execução de alta performance do bytecode TheFlux com runtime nativo em Rust. |
| **LLVM Nativo** | llvm | Emissão direta de LLVM IR compilado via Clang com runtime de suporte em C (lux_input.c). |
| **WebAssembly Text** | wat | Geração de WebAssembly em formato texto com chamadas de sistema WASI para portabilidade universal. |
| **WebAssembly Binário** | wasm | Codificador binário direto em WASM para execução em navegadores e runtimes WASI (Wasmtime, Node.js). |

---

## 📂 Estrutura do Repositório

`	ext
TheFlux/
├── src/                     # Núcleo do compilador e backends
│   └── flux_proto/          # Lexer, Parser, AST, Semântica, VM, LLVM, WAT, WASM
├── stdlib/                  # 14 Bibliotecas Padrão em FDSL (.fdsl)
│   ├── DateTimeStdLib.fdsl  # Data, tempo, fuso horário, relógio monotônico
│   ├── MathStdLib.fdsl      # Matemática fundamental, trigonometria, estatística
│   ├── LinAlgStdLib.fdsl    # Álgebra linear, vetores, matrizes, autovalores
│   ├── SimdStdLib.fdsl      # Operações vetoriais aceleradas
│   ├── IoStdLib.fdsl        # Arquivos, diretórios, inspeção
│   ├── NetStdLib.fdsl       # Redes, sockets, HTTP
│   ├── OsStdLib.fdsl        # Processos, ambiente, sistema operacional
│   ├── HashStdLib.fdsl      # Criptografia, checksums, hashes rápidos
│   ├── ConvertStdLib.fdsl   # Conversões numéricas, bases, parsing
│   ├── StringStdLib.fdsl    # Manipulação e mutação de strings
│   ├── ListStdLib.fdsl      # Listas e sequências
│   ├── SetStdLib.fdsl       # Teoria e álgebra de conjuntos
│   ├── RandomStdLib.fdsl    # Geradores pseudo-aleatórios e distribuições
│   └── TimeStdLib.fdsl      # Temporização e utilitários
├── flux/                    # Mais de 200 programas e suítes de teste (.flux)
├── docs/                    # Especificação EBNF, gramática e documentação técnica
├── specs/                   # Especificações estruturadas de funcionalidades
├── openspec/                # Sistema de mudanças e propostas OpenSpec
├── web_wasm/                # Frontend web e playground interativo WebAssembly
├── backend_compliance.py    # Harness de testes de conformidade dos 6 backends
└── backend_compliance.md    # Matriz oficial de conformidade dos testes (100% PASS)
`

---

## 🛠️ Requisitos e Instalação

### Pré-requisitos

- **Python 3.11+**
- **LLVM / Clang** (para o backend nativo llvm)
- **WABT** (wat2wasm) ou **Wasmtime** (para os backends wat e wasm)
- **Rust / Cargo** (opcional, para compilar a mr)

### Configuração do Ambiente

`ash
# Configurar a variável de ambiente PYTHONPATH para incluir src
export PYTHONPATH="src"

# No Windows PowerShell:
$env:PYTHONPATH = "src"
`

---

## 🧪 Execução e Testes

### Executar um Programa Individual

Para rodar qualquer arquivo .flux em qualquer backend:

`ash
# Via Interpretador AST
python flux_in.py flux/ExampleOfArithmetic.flux

# Via Bytecode VM
python flux_vm.py flux/ExampleOfArithmetic.flux

# Via VM Rust
python flux_vmr.py flux/ExampleOfArithmetic.flux

# Via LLVM Nativo
python flux_lv.py flux/ExampleOfArithmetic.flux

# Via WebAssembly Text
python flux_wat.py flux/ExampleOfArithmetic.flux

# Via WebAssembly Binário
python flux_was.py flux/ExampleOfArithmetic.flux
`

### Rodar a Suíte Completa de Conformidade

O harness ackend_compliance.py valida todos os arquivos de teste simultaneamente nos 6 backends, garantindo paridade exata de saída caractere por caractere:

`ash
python backend_compliance.py
`

> **Status Atual**: **211/211 arquivos com 100% de conformidade nos 6 backends** (0 regressões).

---

## 🌐 Playground WebAssembly

Para testar o compilador no navegador através do ambiente WASM:

`ash
cd web_wasm
python server.py
`
Acesse http://localhost:8000 para editar, compilar e executar TheFlux no browser.

---

## 📄 Licença

Este projeto é desenvolvido para fins de pesquisa e desenvolvimento de linguagens de programação. Consulte a documentação em docs/ para obter detalhes completos da especificação e licença.
