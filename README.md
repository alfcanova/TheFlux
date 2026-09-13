# TheFlux Programming Language

> **TheFlux**: Uma linguagem de programação moderna orientada a contratos e agentes, com compilação multi-backend e biblioteca padrão modular de alto desempenho.

---

## 🚀 Visão Geral

TheFlux introduz um modelo expressivo centrado em **contratos** (contract), **agentes** (agent) e **operações de fluxo contínuo** (-->), garantindo forte consistência semântica e determinismo através de múltiplos alvos de compilação e execução.

### Principais Características

- **Paradigma Orientado a Agentes & Contratos**: Separação clara entre especificações de interface e implementações reativas.
- **Tipagem Estática Expressiva**: Suporte a inteiros primitivos, ponto flutuante com formatos para ML, tensores/matrizes, coleções e tipos de data/hora nativos.
- **Arquitetura Multi-Backend (6 Alvos de Execução)**: O mesmo código-fonte TheFlux executa com exata paridade comportamental em todos os ambientes.
- **Biblioteca Padrão Abrangente (stdlib)**: 16 bibliotecas modulares cobrindo desde álgebra linear e SIMD até criptografia, rede e relógio monotônico.
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
├── src/                         # Núcleo do compilador e backends
│   └── flux_proto/              # Lexer, Parser, AST, Semântica, VM, LLVM, WAT, WASM
├── stdlib/                      # Bibliotecas Padrão em FDSL (.fdsl)
│   ├── CharStdLib.fdsl          # Manipulação e mutação de char
│   ├── ConvertStdLib.fdsl       # Conversões numéricas, bases, parsing
│   ├── DateTimeStdLib.fdsl      # Data, tempo, fuso horário, relógio monotônico
│   ├── DebugStdLib.fdsl         # Debug de programas
│   ├── FileSignatureStdLib.fdsl # Assinatura, autenticação de arquivos e diretórios
│   ├── HashStdLib.fdsl          # Criptografia, checksums, hashes rápidos
│   ├── IoStdLib.fdsl            # Arquivos, diretórios, inspeção
│   ├── LinAlgStdLib.fdsl        # Álgebra linear, vetores, matrizes, autovalores
│   ├── ListStdLib.fdsl          # Listas e sequências
│   ├── MapStdLib.fdsl           # Matemática fundamental, trigonometria, estatística
│   ├── MathStdLib.fdsl          # Matemática fundamental, trigonometria, estatística
│   ├── NetStdLib.fdsl           # Redes, sockets, HTTP
│   ├── OsStdLib.fdsl            # Processos, ambiente, sistema operacional
│   ├── RandomStdLib.fdsl        # Geradores pseudo-aleatórios e distribuições
│   ├── SetStdLib.fdsl           # Teoria e álgebra de conjuntos
│   ├── SimdStdLib.fdsl          # Operações vetoriais aceleradas
│   └── StringStdLib.fdsl        # Manipulação e mutação de strings
├── flux/                        # Mais de 200 programas e suítes de teste (.flux)
├── docs/                        # Especificação EBNF, gramática e documentação técnica
├── specs/                       # Especificações estruturadas de funcionalidades
├── openspec/                    # Sistema de mudanças e propostas OpenSpec
├── web_wasm/                    # Frontend web e playground interativo WebAssembly
├── backend_compliance.py        # Harness de testes de conformidade dos 6 backends
└── backend_compliance.md        # Matriz oficial de conformidade dos testes (100% PASS)
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
```

### Rodar a Suíte Completa de Conformidade

O harness backend_compliance.py valida todos os arquivos de teste simultaneamente nos 6 backends, garantindo paridade exata de saída caractere por caractere:

```sh
python backend_compliance.py
```

> **Status Atual**: **223/223 arquivos com 100% de conformidade nos 6 backends** (0 regressões).

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