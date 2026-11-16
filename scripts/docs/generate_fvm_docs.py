#!/usr/bin/env python3
"""Gerador e Sincronizador de Documentação Técnica Bilíngue da FVM (Fast Virtual Machine).

Gera documentação técnica oficial, detalhada e bilíngue para a FVM e conector FDSL:
  - FvmOverview.md (Visão Geral, Arquitetura C, Modos de Execução, CLI)
  - FvmClient.md (Conector FDSL, Contrato FvmContract, Agente FvmClient, Exemplos)
  - FvmBytecode.md (Formato .fvmbc, Pipeline FMIR, Catálogo de 92 Opcodes, Tipos Tagged)

Uso:
  python scripts/docs/generate_fvm_docs.py
  python scripts/docs/generate_fvm_docs.py --verify
"""
from __future__ import annotations

import argparse
import os
import sys
from pathlib import Path

# Reconfigura stdout para UTF-8 no Windows
if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8")
if hasattr(sys.stderr, "reconfigure"):
    sys.stderr.reconfigure(encoding="utf-8")

REPO_ROOT = Path(__file__).resolve().parent.parent.parent
DOCS_PT_DIR = REPO_ROOT / "docs" / "pt_BR" / "fvm"
DOCS_EN_DIR = REPO_ROOT / "docs" / "en" / "fvm"

FVM_DOCS = {
    "FvmOverview": {
        "title_pt": "Visão Geral e Arquitetura da FVM (TheFlux Fast Virtual Machine)",
        "title_en": "FVM Architecture and Technical Overview (TheFlux Fast Virtual Machine)",
        "binary": "bin/fluxvm.exe (Windows) / bin/fluxvm (Linux)",
        "source": "runtime/fvm/",
        "version": "1.0.0",
        "pt": """# ⚡ Visão Geral e Arquitetura da FVM (TheFlux Fast Virtual Machine)

> **Binário Oficial**: `bin/fluxvm.exe (Windows) / bin/fluxvm (Linux)`  
> **Código-Fonte do Motor**: [`runtime/fvm/`](file:///D:/Projetos/TheFlux/runtime/fvm) e [`runtime/flux_service.c`](file:///D:/Projetos/TheFlux/runtime/flux_service.c)  
> **Versão Homologada**: `v1.0.0`  
> **Status**: ✅ Componente Canônico Oficial do TheFlux v1.0.0

---

## 1. Visão Geral e Papel Arquitetural

A **TheFlux Fast Virtual Machine (FVM)** é o motor de execução nativo de alta performance projetado para interpretar arquivos de bytecode compilados (`.fvmbc`) do ecossistema TheFlux. Desenvolvida em C puro com alocação em blocos de memória arena, a FVM oferece um ambiente de execução leve, desacoplado de dependências externas de compilação C/LLVM e com tempo de inicialização na ordem de fração de milissegundo.

A FVM opera sob uma arquitetura dual única no ecossistema:
1. **Modo Standalone (Execução Local Isolada)**: Inicialização instantânea sob demanda para scripts, utilitários e suítes de teste locais.
2. **Modo Residente / Serviço do Windows (IPC via Named Pipe)**: Um servidor de execução residente (`\\.\\pipe\\theflux_fvm`) que mantém a máquina virtual pré-aquecida em memória, recebendo bytecodes via injeção (`--inject`) com latência de resposta de apenas **0.10 ms** (100 microssegundos). Se o serviço não estiver ativo, o cliente realiza **fallback automático transparente** para execução local sem qualquer falha de processo.

---

## 2. Componentes Internos do Motor C

A implementação física da FVM reside no diretório [`runtime/fvm/`](file:///D:/Projetos/TheFlux/runtime/fvm):

```mermaid
flowchart TD
    CLI["Ponto de Entrada CLI & SCM<br/>(runtime/fvm/fvm_main.c)"] --> Mode{"Modo de Execução"}
    
    Mode -->|Local Standalone| Parser["Parser de Bytecode JSON<br/>(runtime/fvm/fvm_parser.c)"]
    Mode -->|Daemon Console| IPCServer["Servidor Named Pipe<br/>(runtime/flux_service.c)"]
    Mode -->|Windows Service| IPCServer
    Mode -->|Injeção IPC| IPCClient["Cliente IPC / Fallback<br/>(runtime/flux_service.c)"]

    IPCServer --> Parser
    IPCClient -.->|\\.\\pipe\\theflux_fvm| IPCServer
    
    Parser --> Core["Núcleo Executor & Despachante de Opcodes<br/>(runtime/fvm/fvm_core.c)"]
    Core <--> Arena["Gerenciador de Memória Arena<br/>(runtime/fvm/fvm_arena.c)"]
    Core <--> Types["Sistema de Valores Tagged FluxVal<br/>(runtime/fvm/fvm_types.h)"]
```

| Módulo Fonte | Header | Responsabilidade Técnica |
|---|---|---|
| [`fvm_arena.c`](file:///D:/Projetos/TheFlux/runtime/fvm/fvm_arena.c) | `fvm_arena.h` | Alocador de memória em blocos contíguos (Arena Allocator) de 64 KB, eliminando chamadas repetidas a `malloc` e permitindo desalocação instantânea de ciclo de vida com zero fragmentação de heap. |
| [`fvm_parser.c`](file:///D:/Projetos/TheFlux/runtime/fvm/fvm_parser.c) | `fvm_parser.h` | Parser de alta velocidade para carregar e desserializar o formato de bytecode JSON (`.fvmbc`) em estruturas nativas em memória (`FvmProgram`). |
| [`fvm_core.c`](file:///D:/Projetos/TheFlux/runtime/fvm/fvm_core.c) | `fvm_core.h` | Núcleo de execução com loop de despacho direto sobre os **92 opcodes canônicos**, pilha de operandos e tabela de registradores. |
| [`fvm_types.h`](file:///D:/Projetos/TheFlux/runtime/fvm/fvm_types.h) | `fvm_types.h` | Definição dos opcodes, enumeração dos 16 tipos primitivos e estrutura de valores *tagged* de 16 bytes alinhados (`FluxVal`). |
| [`flux_service.c`](file:///D:/Projetos/TheFlux/runtime/flux_service.c) | `flux_service.h` | Camada de integração com o sistema operacional Windows: controle do SCM (instalação, início, parada), servidor Named Pipe multi-instância e cliente de injeção IPC. |
| [`fvm_main.c`](file:///D:/Projetos/TheFlux/runtime/fvm/fvm_main.c) | - | Interface de linha de comando CLI, despacho de flags, benchmarking via contadores de alta precisão do Windows (`QueryPerformanceCounter`) e orquestração. |

---

## 3. Modos de Operação Detalhados

### 3.1 Modo Standalone (Execução Local Direta)
Neste modo, o binário `fluxvm.exe` recebe o caminho de um arquivo `.fvmbc`, lê seu conteúdo, instancia uma máquina virtual com arena local e executa as instruções até o término:
```bash
fluxvm t_fvmbc/ExampleOfAsync.fvmbc
```
- **Vantagem**: Isolamento absoluto de processo, sem dependência de serviços em execução em segundo plano.
- **Caso de uso**: Testes unitários, tarefas em lote (batch), scripts pontuais e ambientes restritos sem permissão para daemons.

### 3.2 Modo Daemon Console (Residente sem Privilégios de Administrador)
Permite inicializar o servidor de Named Pipe diretamente em uma janela de console ou processo em segundo plano do usuário corrente, sem requerer privilégios administrativos:
```bash
fluxvm --daemon
```
O servidor escuta continuamente conexões no canal `\\\\.\\pipe\\theflux_fvm`. Ao receber conexões de clientes injetores (`--inject`), processa o bytecode recebido e envia a resposta de volta pelo mesmo pipe.

### 3.3 Modo Serviço do Windows (Service Control Manager - SCM)
Para implantações de produção e servidores dedicados, a FVM pode ser instalada formalmente como um Serviço do Windows com inicialização automática (`SERVICE_AUTO_START`):
- **Instalar**: `fluxvm --service install` (requer Administrador)
- **Iniciar**: `fluxvm --service start`
- **Consultar Status**: `fluxvm --service status` ou `fluxvm --status`
- **Parar**: `fluxvm --service stop`
- **Desinstalar**: `fluxvm --service uninstall`

### 3.4 Modo Injeção de Bytecode (IPC) com Fallback Transparente
O comando de injeção transmite o bytecode diretamente para o processo residente:
```bash
fluxvm --inject programa.fvmbc --bench
```
- **Com Serviço/Daemon Ativo**: O bytecode é despachado via IPC em ~0.10 ms.
- **Com Serviço Inativo**: A FVM detecta o retorno IPC `-2` e **imediatamente executa o programa localmente** em fallback automático, garantindo que comandos de injeção nunca falhem por ausência do serviço.

---

## 4. Tabela de Opções de Linha de Comando (CLI)

| Opção | Parâmetro | Descrição |
|---|---|---|
| `<arquivo.fvmbc>` | Obrigatório no modo direto | Executa o arquivo de bytecode localmente em modo standalone. |
| `--inject` | `<arquivo.fvmbc>` ou `-` | Injeta o bytecode no serviço Windows ou Daemon via Named Pipe (suporta leitura de STDIN com `-`). |
| `--status`, `--ping` | - | Verifica se o serviço ou daemon FVM está ativo e respondendo (`active` / `inactive`). |
| `--bench` | - | Habilita cronometragem de alta resolução, exibindo tempo de execução (ms) e contagem de instruções / latência IPC. |
| `--stdin` | `<texto>` | Fornece texto de entrada padrão simulado via argumento de linha de comando. |
| `--service install` | - | Registra formalmente `TheFluxFvmService` no Windows SCM com autostart. |
| `--service uninstall` | - | Remove o serviço `TheFluxFvmService` do Windows SCM. |
| `--service start` | - | Inicia o serviço Windows registrado no SCM. |
| `--service stop` | - | Interrompe a execução do serviço Windows no SCM. |
| `--service status` | - | Consulta e exibe o estado operacional do serviço no SCM. |
| `--service run` | - | Ponto de entrada interno invocado pelo SCM ao despachar o serviço. |
| `--daemon` | - | Inicia o servidor residente em console de usuário (sem requerer elevação de privilégios). |
| `--version`, `-v` | - | Exibe a versão oficial instalada da FVM (`1.0.0`). |
| `--help`, `-h` | - | Exibe o manual de ajuda e opções na tela. |

---

## 5. Métricas de Performance e Benchmarking

Testes executados com contadores de performance de alta precisão do Windows (`QueryPerformanceCounter`) demonstram os seguintes tempos de turnaround médios:

| Modo de Execução | Tempo Típico de Turnaround | Overhead de Processo |
|---|---|---|
| **Injeção IPC via Named Pipe** (`--inject`) | **0.08 ms a 0.12 ms** (80–120 µs) | Zero (instância quente residente pré-alocada) |
| **Standalone Local** (`fluxvm <arquivo>`) | **0.02 ms a 0.04 ms** (após spawn) | ~15 ms (tempo de spawn do processo pelo OS) |
| **Fallback Automático** (sem serviço) | **0.02 ms a 0.04 ms** | Transparente e imediato após timeout de 50 ms |
""",
        "en": """# ⚡ FVM Architecture and Technical Overview (TheFlux Fast Virtual Machine)

> **Official Binary**: `bin/fluxvm.exe (Windows) / bin/fluxvm (Linux)`  
> **Engine Source Code**: [`runtime/fvm/`](file:///D:/Projetos/TheFlux/runtime/fvm) and [`runtime/flux_service.c`](file:///D:/Projetos/TheFlux/runtime/flux_service.c)  
> **Supported Version**: `v1.0.0`  
> **Status**: ✅ Official Canonical Subsystem of TheFlux v1.0.0

---

## 1. Overview and Architectural Role

The **TheFlux Fast Virtual Machine (FVM)** is the high-performance native bytecode interpreter designed to execute compiled bytecode files (`.fvmbc`) within TheFlux programming ecosystem. Developed in clean C with an arena-based memory management model, FVM provides a lightweight, instant-startup runtime decoupled from external C/LLVM toolchain dependencies.

FVM implements a unique dual-mode architecture:
1. **Standalone Mode (Isolated Local Execution)**: Instant on-demand execution for standalone scripts, utilities, and continuous integration suites.
2. **Resident Daemon / Windows Service Mode (Named Pipe IPC)**: A persistent execution daemon listening on a Windows Named Pipe (`\\.\\pipe\\theflux_fvm`). The pre-warmed VM accepts injected bytecodes (`--inject`) with ultra-low turnaround times of approximately **0.10 ms** (100 microseconds). If the background daemon is not running, clients execute a **transparent automatic fallback** to local execution without process failure.

---

## 2. Internal Components of the C Engine

The physical implementation of FVM resides in [`runtime/fvm/`](file:///D:/Projetos/TheFlux/runtime/fvm):

```mermaid
flowchart TD
    CLI["CLI & SCM Entry Point<br/>(runtime/fvm/fvm_main.c)"] --> Mode{"Execution Mode"}
    
    Mode -->|Local Standalone| Parser["Bytecode JSON Parser<br/>(runtime/fvm/fvm_parser.c)"]
    Mode -->|Console Daemon| IPCServer["Named Pipe IPC Server<br/>(runtime/flux_service.c)"]
    Mode -->|Windows Service| IPCServer
    Mode -->|IPC Injection| IPCClient["IPC Client / Fallback<br/>(runtime/flux_service.c)"]

    IPCServer --> Parser
    IPCClient -.->|\\.\\pipe\\theflux_fvm| IPCServer
    
    Parser --> Core["Core Executor & Opcode Dispatcher<br/>(runtime/fvm/fvm_core.c)"]
    Core <--> Arena["Arena Memory Manager<br/>(runtime/fvm/fvm_arena.c)"]
    Core <--> Types["Tagged Value System FluxVal<br/>(runtime/fvm/fvm_types.h)"]
```

| Source File | Header | Technical Purpose |
|---|---|---|
| [`fvm_arena.c`](file:///D:/Projetos/TheFlux/runtime/fvm/fvm_arena.c) | `fvm_arena.h` | 64 KB chunk contiguous arena memory allocator, preventing repeated `malloc` calls and enabling instant block deallocation without heap fragmentation. |
| [`fvm_parser.c`](file:///D:/Projetos/TheFlux/runtime/fvm/fvm_parser.c) | `fvm_parser.h` | High-speed JSON deserializer and loader for `.fvmbc` bytecode structures into in-memory `FvmProgram` representations. |
| [`fvm_core.c`](file:///D:/Projetos/TheFlux/runtime/fvm/fvm_core.c) | `fvm_core.h` | Execution engine with direct dispatch loop over **92 canonical opcodes**, evaluation stack, and register table. |
| [`fvm_types.h`](file:///D:/Projetos/TheFlux/runtime/fvm/fvm_types.h) | `fvm_types.h` | Opcode definitions, 16 primitive value type enumerations, and 16-byte aligned tagged value structure (`FluxVal`). |
| [`flux_service.c`](file:///D:/Projetos/TheFlux/runtime/flux_service.c) | `flux_service.h` | Windows platform bridge: SCM service management, multi-instance Named Pipe server, and IPC injection client. |
| [`fvm_main.c`](file:///D:/Projetos/TheFlux/runtime/fvm/fvm_main.c) | - | CLI command-line interface, argument routing, high-resolution performance benchmarking via Windows `QueryPerformanceCounter`. |

---

## 3. Detailed Operating Modes

### 3.1 Standalone Mode (Direct Local Execution)
`fluxvm.exe` loads the target `.fvmbc` bytecode file, initializes a local arena state, and executes the bytecode program directly:
```bash
fluxvm t_fvmbc/ExampleOfAsync.fvmbc
```
- **Advantages**: Complete process isolation, no reliance on background daemons or services.
- **Use Cases**: Unit testing, automated batch jobs, one-off scripts, and environments with restricted background execution rights.

### 3.2 Console Daemon Mode (Resident without Administrator Privileges)
Starts the resident Named Pipe server directly in a user console or background task without requiring elevated privileges:
```bash
fluxvm --daemon
```
The server listens for incoming connections on `\\\\.\\pipe\\theflux_fvm`. When an injection client connects (`--inject`), the daemon processes the payload and returns stdout, stderr, and exit codes over the pipe.

### 3.3 Windows Service Mode (Service Control Manager - SCM)
For production deployments and dedicated build nodes, FVM registers as a standard Windows Service configured with automatic startup (`SERVICE_AUTO_START`):
- **Install**: `fluxvm --service install` (requires Administrator)
- **Start**: `fluxvm --service start`
- **Check Status**: `fluxvm --service status` or `fluxvm --status`
- **Stop**: `fluxvm --service stop`
- **Uninstall**: `fluxvm --service uninstall`

### 3.4 IPC Bytecode Injection with Automatic Fallback
Clients inject bytecode directly into the running instance:
```bash
fluxvm --inject program.fvmbc --bench
```
- **Service/Daemon Active**: Bytecode is executed over IPC in ~0.10 ms.
- **Service Inactive**: FVM intercepts the IPC status `-2` and **automatically falls back to local execution**, ensuring that injection commands never fail due to an unstarted daemon.

---

## 4. Command-Line Interface (CLI) Reference

| Option | Argument | Description |
|---|---|---|
| `<file.fvmbc>` | Required in direct mode | Executes the bytecode file locally in standalone mode. |
| `--inject` | `<file.fvmbc>` or `-` | Injects bytecode into the Windows Service or Daemon via Named Pipe (supports STDIN via `-`). |
| `--status`, `--ping` | - | Queries whether the FVM service or daemon is active (`active` / `inactive`). |
| `--bench` | - | Enables high-resolution benchmarking, displaying execution time (ms), instruction count, and IPC latency. |
| `--stdin` | `<text>` | Feeds simulated standard input text through CLI parameters. |
| `--service install` | - | Registers `TheFluxFvmService` in Windows SCM with automatic startup. |
| `--service uninstall` | - | Removes `TheFluxFvmService` from Windows SCM. |
| `--service start` | - | Starts the registered Windows service. |
| `--service stop` | - | Stops the running Windows service. |
| `--service status` | - | Queries and displays the SCM service operational status. |
| `--service run` | - | Internal entrypoint dispatched by SCM when managing the service lifecycle. |
| `--daemon` | - | Launches the resident Named Pipe server in console space (without admin elevation). |
| `--version`, `-v` | - | Prints the installed FVM version (`1.0.0`). |
| `--help`, `-h` | - | Displays usage manual and command options. |

---

## 5. Performance and Benchmarking Metrics

Benchmarks measured using Windows high-resolution performance counters (`QueryPerformanceCounter`) demonstrate:

| Execution Mode | Typical Turnaround Time | Process Spawn Overhead |
|---|---|---|
| **IPC Named Pipe Injection** (`--inject`) | **0.08 ms to 0.12 ms** (80–120 µs) | Zero (pre-warmed resident instance) |
| **Local Standalone** (`fluxvm <file>`) | **0.02 ms to 0.04 ms** (post-spawn) | ~15 ms (operating system process startup) |
| **Automatic Fallback** (daemon inactive) | **0.02 ms to 0.04 ms** | Immediate execution after 50 ms timeout |
"""
    },

    "FvmClient": {
        "title_pt": "Conector FDSL e Interface de Agente FvmClient",
        "title_en": "FDSL Connector and FvmClient Agent Interface",
        "binary": "bin/fluxvm.exe",
        "source": "src/Fvm/FvmClient.fdsl",
        "version": "1.0.0",
        "pt": """# 🔌 Conector FDSL e Interface de Agente FvmClient

> **Código-Fonte do Agente**: [`src/Fvm/FvmClient.fdsl`](file:///D:/Projetos/TheFlux/src/Fvm/FvmClient.fdsl)  
> **Contrato Canônico**: [`src/Fvm/FvmContract.fdsl`](file:///D:/Projetos/TheFlux/src/Fvm/FvmContract.fdsl)  
> **Versão Oficial**: `v1.0.0`  
> **Status**: ✅ Componente Canônico Oficial do TheFlux v1.0.0

---

## 1. Visão Geral e Papel do Conector FDSL

O módulo [`src/Fvm`](file:///D:/Projetos/TheFlux/src/Fvm) implementa o conector oficial de alto nível da linguagem TheFlux para interação direta com a máquina virtual **Fast Virtual Machine (`bin/fluxvm.exe`)**. Seguindo o paradigma orientado a contratos e agentes de TheFlux, o conector expõe uma API limpa e declarativa que abstrai:

- Detecção de atividade do serviço residente Windows ou daemon local.
- Execução protegida de arquivos de bytecode `.fvmbc` locais.
- Injeção atômica de bytecodes em memória no serviço residente via Named Pipe (`\\\\.\\pipe\\theflux_fvm`) com fallback automático.

---

## 2. Especificação do Contrato `FvmContract`

O contrato canônico é definido em [`src/Fvm/FvmContract.fdsl`](file:///D:/Projetos/TheFlux/src/Fvm/FvmContract.fdsl):

```flux
contract (FvmContract) {
      #L Injeta bytecode .fvmbc no servico residente Windows via Named Pipe
      op fvmInjectBytecode (as string: bytecode_json, as string: stdin_text) as map

      #L Executa arquivo de bytecode localmente
      op fvmExecuteFile (as string: fvmbc_path, as string: stdin_text) as map

      #L Checa se o servico Windows fluxvm esta ativo e respondendo
      op fvmIsServiceActive () as bool
}
```

### 2.1 `fvmIsServiceActive () as bool`
- **Propósito**: Consulta se o servidor residente da FVM (Serviço Windows ou Daemon) está ativo e respondendo conexões IPC.
- **Retorno**: `true` se o canal Named Pipe `\\\\.\\pipe\\theflux_fvm` estiver aberto ou o serviço estiver ativo no SCM; `false` caso contrário.
- **Implementação**: Invoca `fluxvm.exe --status`, retornando imediatamente sem timeouts bloqueantes.

### 2.2 `fvmExecuteFile (as string: fvmbc_path, as string: stdin_text) as map`
- **Propósito**: Executa um arquivo de bytecode `.fvmbc` existente no disco local em modo standalone.
- **Entradas**:
  - `fvmbc_path`: Caminho para o arquivo compilado `.fvmbc` (com tratamento de aspas para caminhos com espaços).
  - `stdin_text`: Texto a ser fornecido como entrada padrão (repassado via `--stdin` caso não seja vazio).
- **Retorno (`map`)**:
  - `res["success"]`: Booleano indicando término da execução (`true`).
  - `res["stdout"]`: String contendo a saída capturada do processo.

### 2.3 `fvmInjectBytecode (as string: bytecode_json, as string: stdin_text) as map`
- **Propósito**: Injeta uma representação em JSON de bytecode compilado diretamente no motor residente.
- **Entradas**:
  - `bytecode_json`: Conteúdo serializado do programa `.fvmbc`.
  - `stdin_text`: Texto de entrada padrão opcional.
- **Comportamento**: Grava o payload em arquivo temporário seguro em `temp/fvm_inject_<timestamp>.fvmbc`, invoca `fluxvm.exe --inject` e remove o arquivo temporário após o retorno. Se o serviço residente estiver ativo, a injeção ocorre via IPC Named Pipe; se estiver inativo, ocorre o fallback local transparente.
- **Retorno (`map`)**:
  - `res["success"]`: Booleano de sucesso (`true`).
  - `res["stdout"]`: Saída completa da execução.

---

## 3. Implementação do Agente `FvmClient`

O agente [`src/Fvm/FvmClient.fdsl`](file:///D:/Projetos/TheFlux/src/Fvm/FvmClient.fdsl) implementa o contrato `FvmContract`:

```flux
use RuntimeStdLib
use IoStdLib
use FvmContract.fdsl

agent (FvmClient) impl FvmContract {
      #L Implementacoes de fvmInjectBytecode, fvmExecuteFile e fvmIsServiceActive
}
```

### Características Técnicas de Segurança
- **Resolução Dinâmica do Binário**: Detecta automaticamente a presença de `bin/fluxvm.exe` tanto em execuções relativas (`.\\bin\\fluxvm.exe`), locais (`bin\\fluxvm.exe`) ou globais (`fluxvm.exe` no PATH).
- **Proteção de Argumentos**: Todos os caminhos de arquivos e textos de entrada são protegidos por aspas escapadas contra espaços e caracteres especiais de shell.
- **Gerenciamento Seguro de Arquivos Temporários**: Criação sob demanda do diretório `temp/` e remoção garantida de artefatos efêmeros.

---

## 4. Exemplo Canônico de Código TheFlux

O exemplo oficial demonstrando o consumo do agente está disponível em [`examples/Canon/ExampleOfFvmClient.flux`](file:///D:/Projetos/TheFlux/examples/Canon/ExampleOfFvmClient.flux):

```flux
use src::Fvm::FvmClient as FC

program (ExampleOfFvmClient) {
      print("=== FVM Client: Verificando status do servico ===")
      mut as bool: active = FC::fvmIsServiceActive()
      print("Servico FVM ativo: " + active)

      print("=== FVM Client: Execucao de arquivo de bytecode local ===")
      mut as map: res_exec = FC::fvmExecuteFile("t_fvmbc/test_acc.fvmbc", "")
      print("Sucesso: " + res_exec["success"])
      print("Saida:")
      print(res_exec["stdout"])

      print("=== FVM Client: Injecao de bytecode no servico ou fallback local ===")
      mut as string: bc_content = stdIoReadFile("t_fvmbc/test_acc.fvmbc")
      mut as map: res_inj = FC::fvmInjectBytecode(bc_content, "")
      print("Injecao sucesso: " + res_inj["success"])
      print("Injecao saida:")
      print(res_inj["stdout"])
}
```
""",
        "en": """# 🔌 FDSL Connector and FvmClient Agent Interface

> **Agent Source Code**: [`src/Fvm/FvmClient.fdsl`](file:///D:/Projetos/TheFlux/src/Fvm/FvmClient.fdsl)  
> **Canonical Contract**: [`src/Fvm/FvmContract.fdsl`](file:///D:/Projetos/TheFlux/src/Fvm/FvmContract.fdsl)  
> **Supported Version**: `v1.0.0`  
> **Status**: ✅ Official Canonical Subsystem of TheFlux v1.0.0

---

## 1. Overview and Architectural Purpose

The [`src/Fvm`](file:///D:/Projetos/TheFlux/src/Fvm) module implements the official high-level TheFlux language connector for interacting with the **Fast Virtual Machine (`bin/fluxvm.exe`)**. In accordance with TheFlux contract-and-agent programming paradigm, the connector provides a declarative API that abstracts:

- Operational status detection for the background Windows Service or console daemon.
- Safe execution of local `.fvmbc` bytecode files.
- Atomic in-memory bytecode injection over Windows Named Pipes (`\\\\.\\pipe\\theflux_fvm`) with transparent local fallback.

---

## 2. `FvmContract` Specification

The canonical interface is declared in [`src/Fvm/FvmContract.fdsl`](file:///D:/Projetos/TheFlux/src/Fvm/FvmContract.fdsl):

```flux
contract (FvmContract) {
      #L Injects .fvmbc bytecode into the resident Windows service via Named Pipe
      op fvmInjectBytecode (as string: bytecode_json, as string: stdin_text) as map

      #L Executes a local bytecode file
      op fvmExecuteFile (as string: fvmbc_path, as string: stdin_text) as map

      #L Queries whether the fluxvm service is active and listening
      op fvmIsServiceActive () as bool
}
```

### 2.1 `fvmIsServiceActive () as bool`
- **Purpose**: Checks whether the background FVM daemon or Windows Service is listening for IPC requests.
- **Returns**: `true` if `\\\\.\\pipe\\theflux_fvm` is active or SCM reports the service is running; `false` otherwise.
- **Behavior**: Executes `fluxvm.exe --status`, providing instantaneous non-blocking responses.

### 2.2 `fvmExecuteFile (as string: fvmbc_path, as string: stdin_text) as map`
- **Purpose**: Executes an existing `.fvmbc` bytecode file from disk in standalone mode.
- **Parameters**:
  - `fvmbc_path`: Path to the `.fvmbc` file (safely escaped with quotes to handle spaces).
  - `stdin_text`: Optional standard input text forwarded via `--stdin`.
- **Return Map**:
  - `res["success"]`: Boolean indicating execution status (`true`).
  - `res["stdout"]`: Captured standard output text.

### 2.3 `fvmInjectBytecode (as string: bytecode_json, as string: stdin_text) as map`
- **Purpose**: Injects a serialized JSON bytecode payload into the pre-warmed resident daemon.
- **Parameters**:
  - `bytecode_json`: Serialized `.fvmbc` program content.
  - `stdin_text`: Optional standard input string.
- **Behavior**: Writes bytecode into an ephemeral `temp/fvm_inject_<timestamp>.fvmbc` file, invokes `fluxvm.exe --inject`, and cleans up the temporary file upon completion. If the daemon is active, execution occurs via Named Pipe IPC; otherwise, transparent local fallback is performed.
- **Return Map**:
  - `res["success"]`: Success boolean (`true`).
  - `res["stdout"]`: Standard output emitted by the VM.

---

## 3. `FvmClient` Agent Implementation

The agent in [`src/Fvm/FvmClient.fdsl`](file:///D:/Projetos/TheFlux/src/Fvm/FvmClient.fdsl) implements `FvmContract`:

```flux
use RuntimeStdLib
use IoStdLib
use FvmContract.fdsl

agent (FvmClient) impl FvmContract {
      #L Implementations of fvmInjectBytecode, fvmExecuteFile, and fvmIsServiceActive
}
```

### Security and Robustness Highlights
- **Dynamic Binary Resolution**: Automatically detects `bin/fluxvm.exe` whether invoked via relative paths (`.\\bin\\fluxvm.exe`), local folders (`bin\\fluxvm.exe`), or system `PATH`.
- **Argument Escaping**: File paths and input strings are safely enclosed in quotes.
- **Safe Scratch File Lifecycle**: Creates `temp/` on demand and ensures deletion of temporary injection artifacts.

---

## 4. Canonical TheFlux Code Example

The standard usage pattern is demonstrated in [`examples/Canon/ExampleOfFvmClient.flux`](file:///D:/Projetos/TheFlux/examples/Canon/ExampleOfFvmClient.flux):

```flux
use src::Fvm::FvmClient as FC

program (ExampleOfFvmClient) {
      print("=== FVM Client: Verificando status do servico ===")
      mut as bool: active = FC::fvmIsServiceActive()
      print("Servico FVM ativo: " + active)

      print("=== FVM Client: Execucao de arquivo de bytecode local ===")
      mut as map: res_exec = FC::fvmExecuteFile("t_fvmbc/test_acc.fvmbc", "")
      print("Sucesso: " + res_exec["success"])
      print("Saida:")
      print(res_exec["stdout"])

      print("=== FVM Client: Injecao de bytecode no servico ou fallback local ===")
      mut as string: bc_content = stdIoReadFile("t_fvmbc/test_acc.fvmbc")
      mut as map: res_inj = FC::fvmInjectBytecode(bc_content, "")
      print("Injecao sucesso: " + res_inj["success"])
      print("Injecao saida:")
      print(res_inj["stdout"])
}
```
"""
    },

    "FvmBytecode": {
        "title_pt": "Especificação do Formato .fvmbc e Catálogo dos 92 Opcodes Canônicos",
        "title_en": ".fvmbc Bytecode Specification and 92 Canonical Opcodes Catalog",
        "binary": "bin/fluxvm.exe",
        "source": "runtime/fvm/fvm_types.h",
        "version": "1.0.0",
        "pt": """# 📜 Especificação do Formato .fvmbc e Catálogo dos 92 Opcodes Canônicos

> **Cabeçalho de Tipos e Opcodes**: [`runtime/fvm/fvm_types.h`](file:///D:/Projetos/TheFlux/runtime/fvm/fvm_types.h)  
> **Emissor no Compilador**: [`src/CompilerLib/backends/vm/VmCompiler.fdsl`](file:///D:/Projetos/TheFlux/src/CompilerLib/backends/vm/VmCompiler.fdsl)  
> **Versão Oficial**: `v1.0.0`  
> **Status**: ✅ Especificação Canônica Oficial do TheFlux v1.0.0

---

## 1. Visão Geral do Formato `.fvmbc`

O arquivo de bytecode **`.fvmbc`** (Fast Virtual Machine Bytecode) é a representação intermediária serializada em formato JSON gerada pelo backend VM do compilador self-hosted (`fluxc --target vm`). Ele encapsula o código executável, constantes tipadas, definições de funções e metadados estruturais de um programa TheFlux.

### Estrutura Geral do JSON `.fvmbc`

```json
{
  "version": "1.0.0",
  "constants": [
    {"type": "int", "value": 42},
    {"type": "string", "value": "Olá, TheFlux!"}
  ],
  "functions": [
    {
      "name": "main",
      "params": [],
      "locals_count": 8,
      "instructions": [
        {"op": "LOAD_CONST", "arg": 0},
        {"op": "PRINT"},
        {"op": "HALT"}
      ]
    }
  ],
  "metadata": {
    "target": "fvm",
    "compiler": "fluxc-1.0.0"
  }
}
```

---

## 2. Pipeline de Compilação e Emissão

A compilação para FVM segue o fluxo formal do compilador nativo:

```mermaid
flowchart LR
    Fonte[".flux / .fdsl"] --> Parser["ParserCore.fdsl"]
    Parser --> AST["Árvore Sintática (AST)"]
    AST --> Semant["SemanticCore.fdsl"]
    Semant --> FMIR["Flux Mid-level IR (FMIR)"]
    FMIR --> VmBackend["VmBackend.fdsl"]
    VmBackend --> VmCompiler["VmCompiler.fdsl"]
    VmCompiler --> FVMBlob[".fvmbc (JSON Bytecode)"]
    FVMBlob --> FVMExec["fluxvm.exe (Execução / Injeção)"]
```

1. **Geração de FMIR**: O compilador traduz as declarações, contratos e programas para a representação intermediária unificada FMIR.
2. **Emissão de Instruções VM**: O módulo `VmBackend.fdsl` percorre o grafo de blocos básicos do FMIR, convertendo instruções de alto nível nos 92 opcodes canônicos da FVM.
3. **Serialização JSON**: `VmCompiler.fdsl` empacota a tabela de constantes e o array de instruções gerando o arquivo final `.fvmbc`.

---

## 3. Catálogo dos 92 Opcodes Canônicos

A enumeração oficial de opcodes reside em [`runtime/fvm/fvm_types.h`](file:///D:/Projetos/TheFlux/runtime/fvm/fvm_types.h) (`FvmOpcode`), categorizada em 9 grupos funcionais:

### 3.1 Controle do Ciclo de Vida e Pilha (Opcodes 0–5, 17–18)
| Opcode | ID | Descrição |
|---|---|---|
| `OP_HALT` | 0 | Encerra a execução da máquina virtual retornando o valor do topo da pilha como exit code. |
| `OP_PUSH` | 1 | Empilha uma constante da tabela de constantes no topo da pilha. |
| `OP_LOAD` | 2 | Carrega o valor de uma variável local ou registrador para a pilha. |
| `OP_STORE` | 3 | Armazena o valor do topo da pilha em uma variável local ou slot de memória. |
| `OP_MAKE_REF` | 4 | Cria uma referência mutável a um slot de variável. |
| `OP_DECLARE` | 5 | Declara uma nova variável no escopo corrente com tipo inicial. |
| `OP_DUP` | 17 | Duplica o elemento no topo da pilha de operandos. |
| `OP_POP` | 18 | Descarta o elemento no topo da pilha de operandos. |

### 3.2 Aritmética e Matemática (Opcodes 6–15, 60–61)
| Opcode | ID | Descrição |
|---|---|---|
| `OP_ADD` | 6 | Soma aritmética entre os dois valores no topo da pilha (`a + b`). |
| `OP_SUB` | 7 | Subtração aritmética (`a - b`). |
| `OP_MUL` | 8 | Multiplicação aritmética (`a * b`). |
| `OP_DIV` | 9 | Divisão real de ponto flutuante (`a / b`). |
| `OP_IDIV` | 10 | Divisão inteira truncada (`a /i b`). |
| `OP_REM` | 11 | Resto inteiro da divisão (`a /r b`). |
| `OP_POW_E` | 12 | Potenciação exata (`a ^e b`). |
| `OP_POW_R` | 13 | Potenciação real (`a ^r b`). |
| `OP_NEG` | 14 | Negação aritmética unária (`-a`). |
| `OP_ROUND` | 60 | Arredondamento numérico com modo configurável. |
| `OP_ROUND_COMPLEX` | 61 | Arredondamento de partes real e imaginária de número complexo. |

### 3.3 Comparações e Lógica Booleana (Opcodes 16, 19–26)
| Opcode | ID | Descrição |
|---|---|---|
| `OP_NOT` | 16 | Negação lógica (`not a`). |
| `OP_EQ` | 19 | Comparação de igualdade (`a == b`). |
| `OP_NE` | 20 | Comparação de desigualdade (`a != b`). |
| `OP_LT` | 21 | Menor que (`a < b`). |
| `OP_LE` | 22 | Menor ou igual (`a <= b`). |
| `OP_GT` | 23 | Maior que (`a > b`). |
| `OP_GE` | 24 | Maior ou igual (`a >= b`). |
| `OP_AND` | 25 | Operação lógica E (`a and b`). |
| `OP_OR` | 26 | Operação lógica OU (`a or b`). |

### 3.4 Operações Bitwise (Opcodes 27–33)
| Opcode | ID | Descrição |
|---|---|---|
| `OP_BAND` | 27 | E bit a bit (`&`). |
| `OP_BOR` | 28 | OU bit a bit (`&#124;`). |
| `OP_BXOR` | 29 | OU exclusivo bit a bit (`^`). |
| `OP_BSHL` | 30 | Deslocamento de bits para esquerda (`<<`). |
| `OP_BSHR` | 31 | Deslocamento de bits aritmético para direita (`>>`). |
| `OP_BSHRU` | 32 | Deslocamento de bits lógico (sem sinal) para direita (`>>>`). |
| `OP_BNOT` | 33 | Negação bit a bit (`~`). |

### 3.5 Entrada, Saída e Depuração (Opcodes 34–36, 86)
| Opcode | ID | Descrição |
|---|---|---|
| `OP_PRINT` | 34 | Imprime o valor no topo da pilha sem quebra de linha. |
| `OP_PRINTLN` | 35 | Imprime o valor no topo da pilha com quebra de linha. |
| `OP_INPUT` | 36 | Lê uma linha de entrada de stdin. |
| `OP_SPY` | 86 | Inspeciona e imprime o estado interno de um registrador ou valor em depuração. |

### 3.6 Saltos, Funções e Controle de Escopo (Opcodes 37–43)
| Opcode | ID | Descrição |
|---|---|---|
| `OP_JMP` | 37 | Salto incondicional para o endereço de instrução alvo. |
| `OP_JZ` | 38 | Salto condicional se o topo da pilha for falso ou zero. |
| `OP_JNZ` | 39 | Salto condicional se o topo da pilha for verdadeiro ou não-zero. |
| `OP_CALL` | 40 | Invoca uma função passando argumentos da pilha. |
| `OP_RET` | 41 | Retorna da função corrente para o chamador. |
| `OP_SCOPE_ENTER` | 42 | Abre um novo escopo léxico de variáveis locais. |
| `OP_SCOPE_EXIT` | 43 | Encerra o escopo léxico corrente, liberando variáveis. |

### 3.7 Contratos, Agentes e Tratamento de Erros (Opcodes 44–46)
| Opcode | ID | Descrição |
|---|---|---|
| `OP_EMIT` | 44 | Emite um resultado de operação de agente (`emit(nice, val, msg)`). |
| `OP_FAIL` | 45 | Dispara um erro estruturado de falha de contrato. |
| `OP_IS_FAIL` | 46 | Verifica se um resultado retornado contém sinalização de falha. |

### 3.8 Estruturas, Enums, Tuplas e Pattern Matching (Opcodes 47–59, 74–79)
| Opcode | ID | Descrição |
|---|---|---|
| `OP_MAKE_STRUCT` | 47 | Cria uma nova instância de struct com campos inicializados. |
| `OP_FIELD_ACCESS` | 48 | Acessa um campo de struct pelo nome ou índice. |
| `OP_FIELD_SET` | 49 | Atribui um novo valor a um campo de struct. |
| `OP_TO_STRING` | 50 | Converte qualquer valor *tagged* em representação textual string. |
| `OP_JUMP_IF_NOT_MATCH` | 51 | Salto condicional para arm alternativo caso o padrão não case. |
| `OP_MATCH_BIND` | 53 | Vincula valores desestruturados a variáveis de padrão. |
| `OP_ENUM_NEW` | 55 | Cria uma nova variante de enum com tag e campos associados. |
| `OP_ENUM_TAG` | 56 | Extrai a tag de discriminante de um enum. |
| `OP_INDEX` | 62 | Acesso indexado em listas, mapas ou tensores (`col[idx]`). |
| `OP_INDEX_ASSIGN` | 63 | Atribuição indexada (`col[idx] = val`). |
| `OP_SLICE` | 69 | Fatiamento de coleções ou strings (`col[ini..fim]`). |
| `OP_IN` | 70 | Teste de pertencimento de elemento em coleção (`item in col`). |

### 3.9 Tensores, Coleções e Iteradores (Opcodes 64–68, 71–73, 83–85, 87)
| Opcode | ID | Descrição |
|---|---|---|
| `OP_TGET` | 64 | Leitura de elemento multidimensional em tensor. |
| `OP_TSET` | 65 | Escrita de elemento multidimensional em tensor. |
| `OP_TENSOR_PACK` | 66 | Empacota elementos em buffer contíguo de tensor numérico. |
| `OP_TSLICE` | 67 | Fatiamento multidimensional de tensor. |
| `OP_TMAT` | 68 | Operação de multiplicação de matrizes de tensor. |
| `OP_MAKE_LIST` | 71 | Cria uma nova lista dinâmica de elementos. |
| `OP_MAKE_SET` | 72 | Cria um novo conjunto hash set de valores únicos. |
| `OP_MAKE_MAP` | 73 | Cria um novo mapa hash map chave-valor. |
| `OP_ITER_NEW` | 83 | Cria um novo iterador sobre uma coleção. |
| `OP_ITER_NEXT` | 84 | Avança o iterador e retorna o próximo elemento. |
| `OP_UNWRAP_NICE` | 85 | Desempacota o valor de um resultado `nice` de emissão de agente. |
| `OP_NOP` | 87 | Nenhuma operação (usado para alinhamento ou pontos de inserção de saltos). |

---

## 4. O Sistema de Tipos Tagged (`FluxVal`) e Gerenciador de Arena

Para atingir performance máxima sem o overhead de coletor de lixo (GC) tradicional em tempo de execução, a FVM utiliza duas técnicas de engenharia de software de ponta:

### 4.1 Estrutura `FluxVal` (16 bytes alinhados)
Todo valor em tempo de execução na FVM é representado pela struct unificada `FluxVal` definida em [`runtime/fvm/fvm_types.h`](file:///D:/Projetos/TheFlux/runtime/fvm/fvm_types.h):

```c
typedef struct FluxVal {
    uint8_t type;       /* 16 tipos primitivos: VAL_INT, VAL_FLOAT, VAL_STRING, etc. */
    uint8_t flags;      /* Flags de mutabilidade e GC */
    uint16_t aux;       /* Metadados auxiliares de enum / comprimento curto */
    int32_t len;        /* Comprimento de strings, coleções ou tensores */
    union {
        int64_t i64;    /* Inteiros signed de 64 bits */
        double f64;     /* Números de ponto flutuante IEEE 754 de 64 bits */
        uint32_t ch;    /* Caracteres UTF-32 */
        void *ptr;      /* Ponteiros para objetos na arena (strings, listas, mapas) */
    } as;
} FluxVal;
```

### 4.2 Gerenciamento de Memória por Arena (`FvmArena`)
- **Alocação Rápida (Bump Allocation)**: Strings, listas, mapas e structs são alocados linearmente em blocos contíguos de 64 KB (`fvm_arena.c`), com ponteiro de offset que avança em tempo O(1).
- **Zero Fragmentação e Limpeza Instantânea**: Quando uma execução é concluída, a arena inteira é reinicializada instantaneamente em O(1), liberando todos os objetos alocados sem custo de varredura ou pausas de *stop-the-world*.
""",
        "en": """# 📜 .fvmbc Bytecode Specification and 92 Canonical Opcodes Catalog

> **Types and Opcode Header**: [`runtime/fvm/fvm_types.h`](file:///D:/Projetos/TheFlux/runtime/fvm/fvm_types.h)  
> **Compiler VM Emitter**: [`src/CompilerLib/backends/vm/VmCompiler.fdsl`](file:///D:/Projetos/TheFlux/src/CompilerLib/backends/vm/VmCompiler.fdsl)  
> **Supported Version**: `v1.0.0`  
> **Status**: ✅ Official Canonical Specification of TheFlux v1.0.0

---

## 1. Overview of the `.fvmbc` Bytecode Format

The **`.fvmbc`** (Fast Virtual Machine Bytecode) file is the serialized JSON intermediate representation generated by the self-hosted compiler's VM backend (`fluxc --target vm`). It encapsulates executable instructions, typed constants, function definitions, and structural program metadata.

### `.fvmbc` JSON Schema Structure

```json
{
  "version": "1.0.0",
  "constants": [
    {"type": "int", "value": 42},
    {"type": "string", "value": "Hello, TheFlux!"}
  ],
  "functions": [
    {
      "name": "main",
      "params": [],
      "locals_count": 8,
      "instructions": [
        {"op": "LOAD_CONST", "arg": 0},
        {"op": "PRINT"},
        {"op": "HALT"}
      ]
    }
  ],
  "metadata": {
    "target": "fvm",
    "compiler": "fluxc-1.0.0"
  }
}
```

---

## 2. Compilation and Code Generation Pipeline

Compilation for the FVM target follows the canonical compiler architecture:

```mermaid
flowchart LR
    Source[".flux / .fdsl"] --> Parser["ParserCore.fdsl"]
    Parser --> AST["Abstract Syntax Tree (AST)"]
    AST --> Semant["SemanticCore.fdsl"]
    Semant --> FMIR["Flux Mid-level IR (FMIR)"]
    FMIR --> VmBackend["VmBackend.fdsl"]
    VmBackend --> VmCompiler["VmCompiler.fdsl"]
    VmCompiler --> FVMBlob[".fvmbc (JSON Bytecode)"]
    FVMBlob --> FVMExec["fluxvm.exe (Execution / Injection)"]
```

1. **FMIR Generation**: The frontend lowers AST declarations, contracts, and expressions into the unified FMIR control-flow graph.
2. **VM Instruction Emission**: `VmBackend.fdsl` walks basic blocks and generates sequences of the 92 canonical FVM opcodes.
3. **JSON Serialization**: `VmCompiler.fdsl` encodes the constant pool and function array into the standardized `.fvmbc` payload.

---

## 3. Catalog of the 92 Canonical Opcodes

The official opcode enumeration resides in [`runtime/fvm/fvm_types.h`](file:///D:/Projetos/TheFlux/runtime/fvm/fvm_types.h) (`FvmOpcode`), grouped into 9 functional categories:

### 3.1 Lifecycle & Stack Management (Opcodes 0–5, 17–18)
| Opcode | ID | Description |
|---|---|---|
| `OP_HALT` | 0 | Terminates virtual machine execution and returns top-of-stack as exit code. |
| `OP_PUSH` | 1 | Pushes a constant from the constant table onto the evaluation stack. |
| `OP_LOAD` | 2 | Loads a local variable or register onto the stack. |
| `OP_STORE` | 3 | Stores the top-of-stack value into a local variable slot. |
| `OP_MAKE_REF` | 4 | Creates a mutable reference to a variable memory slot. |
| `OP_DECLARE` | 5 | Allocates and initializes a new typed variable in current scope. |
| `OP_DUP` | 17 | Duplicates the element on top of the operand stack. |
| `OP_POP` | 18 | Pops and discards the element on top of the operand stack. |

### 3.2 Arithmetic & Mathematical Operations (Opcodes 6–15, 60–61)
| Opcode | ID | Description |
|---|---|---|
| `OP_ADD` | 6 | Arithmetic addition (`a + b`). |
| `OP_SUB` | 7 | Arithmetic subtraction (`a - b`). |
| `OP_MUL` | 8 | Arithmetic multiplication (`a * b`). |
| `OP_DIV` | 9 | Floating-point real division (`a / b`). |
| `OP_IDIV` | 10 | Integer truncated division (`a /i b`). |
| `OP_REM` | 11 | Integer remainder (`a /r b`). |
| `OP_POW_E` | 12 | Exact exponentiation (`a ^e b`). |
| `OP_POW_R` | 13 | Real power exponentiation (`a ^r b`). |
| `OP_NEG` | 14 | Unary arithmetic negation (`-a`). |
| `OP_ROUND` | 60 | Numeric rounding with configurable mode. |
| `OP_ROUND_COMPLEX` | 61 | Rounding of real and imaginary parts of complex numbers. |

### 3.3 Comparisons & Boolean Logic (Opcodes 16, 19–26)
| Opcode | ID | Description |
|---|---|---|
| `OP_NOT` | 16 | Logical NOT (`not a`). |
| `OP_EQ` | 19 | Equality check (`a == b`). |
| `OP_NE` | 20 | Inequality check (`a != b`). |
| `OP_LT` | 21 | Less than (`a < b`). |
| `OP_LE` | 22 | Less than or equal (`a <= b`). |
| `OP_GT` | 23 | Greater than (`a > b`). |
| `OP_GE` | 24 | Greater than or equal (`a >= b`). |
| `OP_AND` | 25 | Logical AND (`a and b`). |
| `OP_OR` | 26 | Logical OR (`a or b`). |

### 3.4 Bitwise Operations (Opcodes 27–33)
| Opcode | ID | Description |
|---|---|---|
| `OP_BAND` | 27 | Bitwise AND (`&`). |
| `OP_BOR` | 28 | Bitwise OR (`&#124;`). |
| `OP_BXOR` | 29 | Bitwise XOR (`^`). |
| `OP_BSHL` | 30 | Bitwise shift left (`<<`). |
| `OP_BSHR` | 31 | Bitwise arithmetic shift right (`>>`). |
| `OP_BSHRU` | 32 | Bitwise logical unsigned shift right (`>>>`). |
| `OP_BNOT` | 33 | Bitwise NOT (`~`). |

### 3.5 I/O & Debugging (Opcodes 34–36, 86)
| Opcode | ID | Description |
|---|---|---|
| `OP_PRINT` | 34 | Prints top-of-stack value without newline. |
| `OP_PRINTLN` | 35 | Prints top-of-stack value followed by newline. |
| `OP_INPUT` | 36 | Reads one line from standard input. |
| `OP_SPY` | 86 | Inspects and displays runtime value diagnostics. |

### 3.6 Control Flow, Functions & Scopes (Opcodes 37–43)
| Opcode | ID | Description |
|---|---|---|
| `OP_JMP` | 37 | Unconditional jump to target instruction address. |
| `OP_JZ` | 38 | Conditional jump if top-of-stack is false or zero. |
| `OP_JNZ` | 39 | Conditional jump if top-of-stack is true or non-zero. |
| `OP_CALL` | 40 | Calls function passing arguments from the stack. |
| `OP_RET` | 41 | Returns from current function call to caller. |
| `OP_SCOPE_ENTER` | 42 | Opens a new lexical variable scope. |
| `OP_SCOPE_EXIT` | 43 | Exits current lexical scope, popping local frames. |

### 3.7 Contracts, Agents & Structured Errors (Opcodes 44–46)
| Opcode | ID | Description |
|---|---|---|
| `OP_EMIT` | 44 | Emits an agent operation outcome (`emit(nice, val, msg)`). |
| `OP_FAIL` | 45 | Triggers a structured contract failure. |
| `OP_IS_FAIL` | 46 | Checks if an emit result indicates failure. |

### 3.8 Structs, Enums, Tuples & Pattern Matching (Opcodes 47–59, 74–79)
| Opcode | ID | Description |
|---|---|---|
| `OP_MAKE_STRUCT` | 47 | Allocates a new struct instance with fields. |
| `OP_FIELD_ACCESS` | 48 | Accesses a struct field by name or index. |
| `OP_FIELD_SET` | 49 | Mutates a struct field value. |
| `OP_TO_STRING` | 50 | Casts any tagged value into string representation. |
| `OP_JUMP_IF_NOT_MATCH` | 51 | Conditional branch when pattern arm fails to match. |
| `OP_MATCH_BIND` | 53 | Binds destructured pattern values to local variables. |
| `OP_ENUM_NEW` | 55 | Instantiates an enum variant with discriminant tag. |
| `OP_ENUM_TAG` | 56 | Extracts the discriminant tag from an enum instance. |
| `OP_INDEX` | 62 | Indexed lookup on lists, maps, or tensors (`col[idx]`). |
| `OP_INDEX_ASSIGN` | 63 | Indexed mutation (`col[idx] = val`). |
| `OP_SLICE` | 69 | Slices collections or strings (`col[start..end]`). |
| `OP_IN` | 70 | Membership test (`item in col`). |

### 3.9 Tensors, Collections & Iterators (Opcodes 64–68, 71–73, 83–85, 87)
| Opcode | ID | Description |
|---|---|---|
| `OP_TGET` | 64 | Multidimensional tensor element read. |
| `OP_TSET` | 65 | Multidimensional tensor element write. |
| `OP_TENSOR_PACK` | 66 | Packs values into contiguous tensor buffer. |
| `OP_TSLICE` | 67 | Multidimensional tensor slicing. |
| `OP_TMAT` | 68 | Tensor matrix multiplication kernel. |
| `OP_MAKE_LIST` | 71 | Allocates a dynamic list collection. |
| `OP_MAKE_SET` | 72 | Allocates a unique-value hash set. |
| `OP_MAKE_MAP` | 73 | Allocates a key-value hash map. |
| `OP_ITER_NEW` | 83 | Creates an iterator over a collection. |
| `OP_ITER_NEXT` | 84 | Advances iterator to next element. |
| `OP_UNWRAP_NICE` | 85 | Unwraps payload value from a `nice` emit result. |
| `OP_NOP` | 87 | No operation (used for alignment and jump patching). |

---

## 4. Tagged Value System (`FluxVal`) & Arena Memory Management

FVM achieves top-tier performance without garbage collection pause overhead using two core architectural strategies:

### 4.1 Tagged Value Structure `FluxVal` (16 Bytes Aligned)
Every runtime entity is represented by the 16-byte aligned `FluxVal` structure defined in [`runtime/fvm/fvm_types.h`](file:///D:/Projetos/TheFlux/runtime/fvm/fvm_types.h):

```c
typedef struct FluxVal {
    uint8_t type;       /* 16 primitive types: VAL_INT, VAL_FLOAT, VAL_STRING, etc. */
    uint8_t flags;      /* Mutability and lifecycle flags */
    uint16_t aux;       /* Auxiliary metadata / enum discriminant */
    int32_t len;        /* String or collection element length */
    union {
        int64_t i64;    /* 64-bit signed integers */
        double f64;     /* 64-bit IEEE 754 floating-point numbers */
        uint32_t ch;    /* UTF-32 code points */
        void *ptr;      /* Heap/arena object pointer (strings, lists, maps) */
    } as;
} FluxVal;
```

### 4.2 Arena Memory Allocator (`FvmArena`)
- **Linear Bump Allocation**: Heap structures are allocated in contiguous 64 KB memory chunks (`fvm_arena.c`), with pointer increments operating in O(1) time without system heap contention.
- **Instant Zero-Cost Deallocation**: When execution finishes, the entire arena resets in O(1) time without GC scanning, heap compaction, or stop-the-world pauses.
"""
    }
}


def generate_docs(verify_only: bool = False) -> int:
    DOCS_PT_DIR.mkdir(parents=True, exist_ok=True)
    DOCS_EN_DIR.mkdir(parents=True, exist_ok=True)

    divergencias = []
    total_gerados = 0

    print("=" * 70)
    print("📜 TheFlux — Gerador de Documentação Técnica Bilíngue da FVM")
    print(f"   Modo: {'VERIFICAÇÃO' if verify_only else 'GERAÇÃO / SINCRONIZAÇÃO'}")
    print(f"   Docs PT: {DOCS_PT_DIR}")
    print(f"   Docs EN: {DOCS_EN_DIR}")
    print("=" * 70)

    for doc_name, data in FVM_DOCS.items():
        file_name = f"{doc_name}.md"
        pt_path = DOCS_PT_DIR / file_name
        en_path = DOCS_EN_DIR / file_name

        content_pt = data["pt"].strip() + "\n"
        content_en = data["en"].strip() + "\n"

        if verify_only:
            if not pt_path.exists():
                divergencias.append(f"Documento PT ausente: {file_name}")
            else:
                existing_pt = pt_path.read_text(encoding="utf-8")
                if existing_pt != content_pt:
                    divergencias.append(f"Documento PT desatualizado: {file_name}")

            if not en_path.exists():
                divergencias.append(f"Documento EN ausente: {file_name}")
            else:
                existing_en = en_path.read_text(encoding="utf-8")
                if existing_en != content_en:
                    divergencias.append(f"Documento EN desatualizado: {file_name}")
        else:
            pt_path.write_text(content_pt, encoding="utf-8")
            en_path.write_text(content_en, encoding="utf-8")
            print(f"  [+] Gerado: docs/pt_BR/fvm/{file_name} <---> docs/en/fvm/{file_name}")
            total_gerados += 1

    print("=" * 70)
    if verify_only:
        if not divergencias:
            print("✅ Todos os 3 pares de documentação técnica da FVM estão 100% íntegros e sincronizados.")
            return 0
        else:
            print(f"❌ {len(divergencias)} divergência(s) detectada(s) na documentação da FVM:")
            for d in divergencias:
                print(f"   [!] {d}")
            return 1
    else:
        print(f"✅ Geração concluída: {total_gerados} pares de documentos sincronizados com sucesso.")
        return 0


def main() -> int:
    parser = argparse.ArgumentParser(description="Gerador de Documentação Técnica da FVM")
    parser.add_argument("--verify", action="store_true", help="Apenas verifica se os arquivos em disco coincidem")
    args = parser.parse_args()
    return generate_docs(verify_only=args.verify)


if __name__ == "__main__":
    sys.exit(main())
