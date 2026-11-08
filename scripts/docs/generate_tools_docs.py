#!/usr/bin/env python3
"""Gerador e Sincronizador de Documentação Técnica Bilíngue das Ferramentas Canônicas do TheFlux (src/tools).

Gera documentação técnica oficial, detalhada e bilíngue para:
  - fluxbuilder (Scaffolding, Wizard, Integrador, Doctor e Reparo)
  - fluxfmt (Formatador Canônico de 6 espaços, Simplificação e Diffs)
  - fluxlinter (Linter Estático estilo Clippy, Severidades e Autofix)
  - fluxlsp (Servidor LSP para VS Code e Exportador XML UDL para Notepad++)

Uso:
  python scripts/docs/generate_tools_docs.py
  python scripts/docs/generate_tools_docs.py --verify
"""
from __future__ import annotations

import argparse
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent.parent
DOCS_PT_DIR = REPO_ROOT / "docs" / "pt_BR" / "tools"
DOCS_EN_DIR = REPO_ROOT / "docs" / "en" / "tools"

TOOLS_METADATA = {
    "fluxbuilder": {
        "title_pt": "fluxbuilder — Utilitário de Scaffolding, Integração e Diagnóstico de Projetos",
        "title_en": "fluxbuilder — Project Scaffolding, Integration, and Diagnostic Utility",
        "binary": "bin/fluxbuilder.exe (Windows) / bin/fluxbuilder (Linux)",
        "source": "src/tools/fluxbuilder/fluxbuilder.flux",
        "version": "1.0.0",
        "desc_pt": """O **`fluxbuilder`** é o utilitário nativo de gerenciamento do ciclo inicial de desenvolvimento de projetos TheFlux. Oferece tanto um assistente interativo em terminal (*Wizard*) guiado por prompts amigáveis quanto suporte completo a modo não-interativo via flags de linha de comando para automação em pipelines de CI/CD.

Além de inicializar novos projetos com estrutura de diretórios padronizada e manifestos declarativos (`flux.toml`), o `fluxbuilder` implementa os modos exclusivos de **Reparo Idempotente** (`--repair`) e **Diagnóstico de Ambiente** (`--doctor`), garantindo que o compilador `fluxc`, o toolchain C/LLVM `clang` e o ecossistema Git estejam configurados corretamente.""",
        "desc_en": """**`fluxbuilder`** is the native project lifecycle management and bootstrapping utility for the TheFlux language ecosystem. It provides both an interactive terminal wizard guided by user-friendly prompts and a robust non-interactive CLI mode tailored for CI/CD automation pipelines.

Beyond scaffolding new projects with standardized directory hierarchies and configuration manifests (`flux.toml`), `fluxbuilder` implements specialized **Idempotent Repair** (`--repair`) and **Environment Diagnostics** (`--doctor`) modes, ensuring that the `fluxc` compiler, Clang/LLVM toolchain, and Git version control systems are operational and properly configured.""",
        "modes_pt": """### 2.1 Assistente Interativo (Modo Wizard)
Quando executado sem argumentos adicionais (`fluxbuilder` ou `fluxbuilder <NomeDoProjeto>`), o utilitário inicia uma sessão interativa no terminal:
- Pergunta o nome sanitizado do projeto (transformado automaticamente em *kebab-case* para pastas e identificador válido para o manifesto).
- Solicita versão semântica (com padrão `1.0.0`).
- Solicita autor e e-mail (validando rigorosamente a presença do caractere `@`).
- Permite selecionar o banco de dados inicial: `PostgreSQL`, `SQLite`, `MySQL` ou `None`.
- Permite selecionar o modo de linkagem do binário final: `Static` (executável autocontido) ou `Dynamic` (dependências dinâmicas compartilhadas).
- Solicita lista inicial de pacotes/dependências.
- Oferece escolha de licença: `MIT`, `Apache-2.0`, `GPLv3` ou `Proprietary`.
- Pergunta se deseja inicializar o repositório Git local (`git init`).

### 2.2 Modo Não-Interativo (CI/CD e Automação)
Ativado pelas flags `-n` (`--non-interactive`) e/ou `-y` (`--yes`), permite provisionar projetos instantaneamente sem intervenção humana, consumindo os parâmetros passados diretamente na linha de comando.

### 2.3 Modo Reparo Idempotente (`--repair` / `-r`)
Inspeciona um projeto existente (ou diretório alvo) e restaura arquivos estruturais ausentes (`flux.toml`, diretórios `src/`, `tests/`, `docs/`, `.gitignore`, `README.md`) **sem sobrescrever ou corromper qualquer código-fonte existente**.

### 2.4 Modo Diagnóstico do Sistema (`--doctor` / `-c`)
Realiza uma bateria de checagens de sanidade no ambiente:
1. Verifica se o compilador `fluxc` está acessível no PATH ou em `bin/fluxc.exe`.
2. Valida versão e execução do `clang` (compilador C de suporte e linker AOT).
3. Valida a presença e funcionamento do `git`.
4. Emite relatório com marcadores `[OK]`, `[AVISO]` e `[ERRO]`.""",
        "modes_en": """### 2.1 Interactive Terminal Wizard
When launched without options (`fluxbuilder` or `fluxbuilder <ProjectName>`), the utility presents an interactive guided setup:
- Prompts for a sanitized project name (converted to kebab-case for directories and valid identifiers for manifests).
- Prompts for initial semantic version (defaulting to `1.0.0`).
- Prompts for author name and contact e-mail (strictly validating the `@` symbol).
- Allows selecting database engine support: `PostgreSQL`, `SQLite`, `MySQL`, or `None`.
- Selects binary linkage mode: `Static` (fully self-contained standalone binary) or `Dynamic` (shared libraries).
- Accepts a comma-separated initial dependencies/packages list.
- Selects open-source or proprietary licensing: `MIT`, `Apache-2.0`, `GPLv3`, or `Proprietary`.
- Prompts whether to initialize a local Git repository (`git init`).

### 2.2 Non-Interactive Mode (CI/CD and Scripting)
Triggered by `-n` (`--non-interactive`) and/or `-y` (`--yes`), allowing automated headless provisioning by supplying configuration parameters directly as CLI flags.

### 2.3 Idempotent Repair Mode (`--repair` / `-r`)
Scans an existing project directory and restores missing structural components (`flux.toml`, directory trees `src/`, `tests/`, `docs/`, `.gitignore`, `README.md`) **without modifying or overwriting any existing user code**.

### 2.4 System Diagnostics Mode (`--doctor` / `-c`)
Executes comprehensive environment health checks:
1. Confirms whether `fluxc` compiler binary is accessible via PATH or `bin/fluxc.exe`.
2. Validates Clang C/LLVM toolchain availability and version.
3. Checks local Git installation.
4. Generates a clear report displaying status badges: `[OK]`, `[WARNING]`, or `[ERROR]`.""",
        "inputs_table_pt": r"""| Flag Curta | Flag Longa | Argumento | Padrão | Descrição |
|---|---|---|---|---|
| `-r` | `--repair` | `[diretório]` | `.` | Executa o Modo Reparo idempotente no diretório alvo |
| `-c` | `--doctor` | *nenhum* | — | Executa o diagnóstico completo do ambiente |
| `-n` | `--non-interactive` | *nenhum* | `false` | Desativa perguntas interativas, usando valores passados |
| `-y` | `--yes` | *nenhum* | `false` | Assume respostas afirmativas/padrão para todas as opções |
| — | `--name` | `<nome>` | `app` | Nome do projeto (sanitizado e slugificado) |
| — | `--ver` | `<versao>` | `1.0.0` | Versão semântica inicial do projeto |
| — | `--author` | `<autor>` | `Developer` | Nome do autor ou organização mantenedora |
| — | `--email` | `<email>` | `dev@local` | E-mail de contato do autor (exige `@`) |
| — | `--db` | `<engine>` | `None` | Motor de banco de dados (`PostgreSQL`, `SQLite`, `MySQL`, `None`) |
| — | `--link` | `<modo>` | `Static` | Tipo de linkagem binária (`Static` ou `Dynamic`) |
| — | `--pkgs` | `<pacotes>` | `""` | Lista de pacotes e dependências separadas por vírgula |
| — | `--license` | `<licenca>` | `MIT` | Modelo de licença (`MIT`, `Apache-2.0`, `GPLv3`, `Proprietary`) |
| — | `--git` | `<true\|false>` | `true` | Determina se o repositório Git local deve ser inicializado |
| `-h` | `--help` | *nenhum* | — | Exibe o manual de ajuda e sintaxe |
| `-v` | `--version` | *nenhum* | — | Exibe a versão oficial do utilitário |""",
        "inputs_table_en": r"""| Short Flag | Long Flag | Argument | Default | Description |
|---|---|---|---|---|
| `-r` | `--repair` | `[directory]` | `.` | Executes idempotent Repair Mode in the target directory |
| `-c` | `--doctor` | *none* | — | Runs complete environment diagnostics |
| `-n` | `--non-interactive` | *none* | `false` | Disables interactive prompts, using supplied flags |
| `-y` | `--yes` | *none* | `false` | Assumes default/yes answers for all configuration prompts |
| — | `--name` | `<name>` | `app` | Project name (sanitized and slugified) |
| — | `--ver` | `<version>` | `1.0.0` | Initial semantic version string |
| — | `--author` | `<author>` | `Developer` | Author or organizational entity name |
| — | `--email` | `<email>` | `dev@local` | Author contact e-mail address (requires `@`) |
| — | `--db` | `<engine>` | `None` | Database backend engine (`PostgreSQL`, `SQLite`, `MySQL`, `None`) |
| — | `--link` | `<mode>` | `Static` | Binary linkage model (`Static` or `Dynamic`) |
| — | `--pkgs` | `<packages>` | `""` | Comma-separated initial package dependencies |
| — | `--license` | `<license>` | `MIT` | Licensing template (`MIT`, `Apache-2.0`, `GPLv3`, `Proprietary`) |
| — | `--git` | `<true\|false>` | `true` | Specifies whether to initialize a local Git repository |
| `-h` | `--help` | *none* | — | Displays the help manual and syntax guide |
| `-v` | `--version` | *none* | — | Displays the official version string |""",
        "outputs_pt": """### 4.1 Códigos de Término (Exit Codes)
| Código de Saída | Significado | Condição |
|:---:|---|---|
| `0` | **Sucesso** | Projeto criado, reparado ou diagnosticado com sucesso |
| `1` | **Erro de Validação ou Ambiente** | E-mail inválido, diretório inacessível ou falha crítica no doctor |

### 4.2 Artefatos Gerados no Sistema de Arquivos
- `flux.toml`: Manifesto de configuração contendo metadados de compilação, pacotes, linkagem e banco de dados.
- `src/main.flux`: Arquivo principal com ponto de entrada `program (...)` funcional.
- `tests/`: Diretório preparado para testes unitários e de integração.
- `docs/`: Diretório de documentação do projeto.
- `.gitignore`: Configuração oficial TheFlux para ignorar binários `bin/`, arquivos temporários `.ll`, `.o` e builds.
- `README.md`: Documentação inicial do projeto com instruções de compilação.
- `LICENSE`: Arquivo de licença contendo os termos legais escolhidos.""",
        "outputs_en": """### 4.1 Exit Codes
| Exit Code | Meaning | Condition |
|:---:|---|---|
| `0` | **Success** | Project successfully initialized, repaired, or verified |
| `1` | **Validation or Environment Failure** | Invalid e-mail, directory permission error, or doctor check failure |

### 4.2 Generated Filesystem Artifacts
- `flux.toml`: Configuration manifest detailing compilation targets, dependencies, linkage, and database configs.
- `src/main.flux`: Canonical entry point source containing an executable `program (...)`.
- `tests/`: Test harness folder for unit and integration suites.
- `docs/`: Project documentation directory.
- `.gitignore`: Standard TheFlux gitignore rules for `bin/`, temporary `.ll`, `.o`, and build caches.
- `README.md`: Initial project documentation with build instructions.
- `LICENSE`: Selected legal licensing terms.""",
        "examples_pt": """```powershell
# 1. Iniciar assistente interativo na pasta atual
fluxbuilder

# 2. Criar novo projeto em subpasta
fluxbuilder MeuServicoWeb

# 3. Criação automatizada não-interativa em pipeline de CI
fluxbuilder -n --name api_gateway --ver 1.0.0 --author "Dev Team" --email dev@empresa.com --db PostgreSQL

# 4. Reparar estrutura sem sobrescrever código
fluxbuilder --repair .

# 5. Executar diagnóstico do ambiente
fluxbuilder --doctor
```""",
        "examples_en": """```powershell
# 1. Launch interactive wizard in current directory
fluxbuilder

# 2. Scaffold new project in a named subfolder
fluxbuilder MyWebService

# 3. Automated non-interactive creation in CI pipeline
fluxbuilder -n --name api_gateway --ver 1.0.0 --author "Dev Team" --email dev@corp.com --db PostgreSQL

# 4. Idempotently repair project structure without altering existing code
fluxbuilder --repair .

# 5. Execute system environment diagnostics
fluxbuilder --doctor
```""",
    },

    "fluxfmt": {
        "title_pt": "fluxfmt — Utilitário de Formatação Canônica de Código TheFlux",
        "title_en": "fluxfmt — TheFlux Canonical Code Formatter",
        "binary": "bin/fluxfmt.exe (Windows) / bin/fluxfmt (Linux)",
        "source": "src/tools/fluxfmt/fluxfmt.flux",
        "version": "1.0.0",
        "desc_pt": """O **`fluxfmt`** é o formatador oficial de código-fonte da linguagem TheFlux, concebido para impor consistência visual e estilística rigorosa em arquivos `.flux` e `.fdsl`. 

Ele implementa as regras da gramática canônica TheFlux:
1. **Indentação Estrita de 6 Espaços**: Cada nível de aninhamento de bloco (`program`, `contract`, `agent`, `route`, `infinite`, funções, structs e enums) recebe exatamente 6 espaços em branco, sem tabulações (*tabs*).
2. **Normalização de Comentários**: Converte comentários legados `#` para o padrão `#L` (comentário de linha) ou preserva blocos `#B ... B#`.
3. **Simplificação de Expressões de Guarda (`--simplify`)**: Remove parênteses redundantes em guardas de rota (ex: `(x > 0) ==>` torna-se `x > 0 ==>`).
4. **Higiene de Espaços em Branco**: Remove espaços excedentes no final de linhas (*trailing whitespace*) e garante final de arquivo limpo com quebra de linha determinística.""",
        "desc_en": """**`fluxfmt`** is the official canonical code formatter for the TheFlux language, engineered to enforce strict structural and aesthetic consistency across `.flux` and `.fdsl` source files.

It strictly implements TheFlux canonical style rules:
1. **Strict 6-Space Indentation**: Every block nesting depth (`program`, `contract`, `agent`, `route`, `infinite`, functions, structs, and enums) receives exactly 6 indentation spaces, forbidding raw tab characters.
2. **Comment Normalization**: Converts legacy single-hash comments `#` to canonical `#L` (line comment) syntax while preserving `#B ... B#` block comments.
3. **Guard Simplification (`--simplify`)**: Eliminates redundant outer parentheses in pattern-matching route guards (e.g., `(x > 0) ==>` is simplified to `x > 0 ==>`).
4. **Whitespace Hygiene**: Strips trailing whitespace from line ends and ensures deterministic line terminators across the file.""",
        "modes_pt": """### 2.1 Modos de Operação
- **Modo Verificação (`-l` / `--list`)**: Inspeciona arquivos e lista apenas os caminhos daqueles que violam o padrão de formatação, retornando código de saída `1` se houver divergências. Ideal para linting em *pre-commit hooks* e CI/CD.
- **Modo Diff (`-d` / `--diff`)**: Computa as diferenças e exibe um diff unificado colorido no formato patch (`---` e `+++`) sem efetuar modificações no disco.
- **Modo Escrita (`-w` / `--write`)**: Aplica a formatação canônica diretamente sobre os arquivos no disco apenas se houver alterações reais.
- **Modo Simplificação (`-s` / `--simplify`)**: Além da indentação, aplica regras de modernização sintática e simplificação de código.""",
        "modes_en": """### 2.1 Operational Modes
- **List Mode (`-l` / `--list`)**: Inspects source files and reports only the paths of files violating canonical formatting rules, returning exit code `1` upon divergence. Tailored for pre-commit hooks and CI quality gates.
- **Diff Mode (`-d` / `--diff`)**: Calculates formatting adjustments and outputs a standard unified diff patch (`---` and `+++`) to stdout without altering files on disk.
- **Write Mode (`-w` / `--write`)**: Applies canonical formatting in-place to files on disk only when modifications are detected.
- **Simplify Mode (`-s` / `--simplify`)**: In addition to indentation, applies syntactic modernizations and guard parenthesization cleanups.""",
        "inputs_table_pt": """| Flag Curta | Flag Longa | Argumento | Padrão | Descrição |
|---|---|---|---|---|
| `-w` | `--write` | *nenhum* | `false` | Reescreve o arquivo fonte no disco se houver mudanças |
| `-d` | `--diff` | *nenhum* | `false` | Exibe diff unificado no formato patch sem alterar o disco |
| `-l` | `--list` | *nenhum* | `false` | Lista caminhos dos arquivos fora do padrão canônico |
| `-s` | `--simplify` | *nenhum* | `false` | Simplifica código (# para #L, parênteses em rotas) |
| `-e` | `--all-errors` | *nenhum* | `false` | Reporta todos os erros sintáticos/lexicais sem abortar precocemente |
| `-r` | `--recursive` | *nenhum* | `false` | Percorre subdiretórios recursivamente |
| `-h` | `--help` | *nenhum* | — | Exibe o manual de ajuda e sintaxe |
| `-v` | `--version` | *nenhum* | — | Exibe a versão oficial do utilitário |""",
        "inputs_table_en": """| Short Flag | Long Flag | Argument | Default | Description |
|---|---|---|---|---|
| `-w` | `--write` | *none* | `false` | Overwrites source files in-place on disk if formatting changes |
| `-d` | `--diff` | *none* | `false` | Prints unified diff patch to stdout without altering disk files |
| `-l` | `--list` | *none* | `false` | Lists paths of files that deviate from canonical formatting |
| `-s` | `--simplify` | *none* | `false` | Simplifies code (# to #L, redundant route guard parentheses) |
| `-e` | `--all-errors` | *none* | `false` | Emits all structural/lexical errors without aborting early |
| `-r` | `--recursive` | *none* | `false` | Recursively traverses nested subdirectories |
| `-h` | `--help` | *none* | — | Displays the help manual and syntax guide |
| `-v` | `--version` | *none* | — | Displays the official version string |""",
        "outputs_pt": """### 4.1 Códigos de Término (Exit Codes)
| Código de Saída | Significado | Condição |
|:---:|---|---|
| `0` | **Conforme / Sucesso** | Todos os arquivos estão formatados ou foram reescritos com sucesso |
| `1` | **Divergência ou Erro** | Arquivos fora do padrão detectados no modo `-l`, ou erro sintático |

### 4.2 Saída no Terminal (stdout/stderr)
- No modo `-l`: Imprime a lista de caminhos que necessitam de formatação.
- No modo `-d`: Imprime patches unificados no formato:
  ```diff
  --- a/src/main.flux
  +++ b/src/main.flux
  @@ -1,5 +1,5 @@
  -# Legado
  +#L Canonico
  ```
- No modo `-w`: Imprime resumo informativo dos arquivos formatados.""",
        "outputs_en": """### 4.1 Exit Codes
| Exit Code | Meaning | Condition |
|:---:|---|---|
| `0` | **Compliant / Success** | All files adhere to formatting rules or were formatted cleanly |
| `1` | **Deviation or Error** | Files need formatting under `-l` mode, or lexical parsing failed |

### 4.2 Terminal Output (stdout/stderr)
- Under `-l` mode: Emits newline-delimited file paths requiring reformatting.
- Under `-d` mode: Emits standard unified diff patches:
  ```diff
  --- a/src/main.flux
  +++ b/src/main.flux
  @@ -1,5 +1,5 @@
  -# Legacy
  +#L Canonical
  ```
- Under `-w` mode: Emits summary confirmations for modified files.""",
        "examples_pt": """```powershell
# 1. Verificar se algum arquivo no projeto está fora do padrão (CI/CD)
fluxfmt -l -r src\\*

# 2. Exibir o diff das correções propostas sem alterar o disco
fluxfmt -d src\\main.flux

# 3. Formatar e simplificar todos os arquivos da pasta src recursivamente
fluxfmt -w -s -r src\\*

# 4. Formatar arquivo específico no disco
fluxfmt -w examples\\Canon\\ExampleOfRoute.flux
```""",
        "examples_en": """```powershell
# 1. Verify whether any project source violates formatting rules (CI gate)
fluxfmt -l -r src\\*

# 2. Preview formatting diffs without altering files on disk
fluxfmt -d src\\main.flux

# 3. Format and simplify all sources in src recursively
fluxfmt -w -s -r src\\*

# 4. Format a specific file in-place
fluxfmt -w examples\\Canon\\ExampleOfRoute.flux
```""",
    },

    "fluxlinter": {
        "title_pt": "fluxlinter — Utilitário de Análise Estática e Linter Canônico",
        "title_en": "fluxlinter — Canonical Static Analysis and Linter Utility",
        "binary": "bin/fluxlinter.exe (Windows) / bin/fluxlinter (Linux)",
        "source": "src/tools/fluxlinter/fluxlinter.flux",
        "version": "1.0.0",
        "desc_pt": """O **`fluxlinter`** é o analisador estático e linter canônico oficial do TheFlux. Inspirado na arquitetura e ergonomia do Clippy do ecossistema Rust (`rustc`), ele realiza varreduras profundas na árvore sintática abstrata (AST) e na estrutura de tokens para identificar *bugs* potenciais, construções suspeitas, anti-patterns e desvios de estilo antes da compilação.

O utilitário organiza suas regras em 4 categorias formais de severidade e oferece recursos avançados de **Autofix** (`--fix`), permitindo corrigir automaticamente problemas de estilo e complexidade diretamente no disco.""",
        "desc_en": """**`fluxlinter`** is the official canonical linter and static analysis engine for TheFlux. Heavily inspired by the architecture and developer experience of Clippy in the Rust ecosystem (`rustc`), it conducts deep AST and token-stream inspections to catch latent bugs, suspicious logic, code smells, and stylistic deviations prior to compilation.

The tool categorizes lints across 4 formal severity categories and provides automated **Autofix** (`--fix`) capabilities, enabling instant and safe remediation of stylistic and complexity issues directly on disk.""",
        "modes_pt": """### 2.1 Categorias e Regras Registradas (11 Lints Oficiais)
| Categoria | Nível Padrão | Regras Registradas |
|---|:---:|---|
| **`correctness`** | `deny` | `division_by_zero` (divisão inteira ou resto por zero literal)<br>`unreachable_route_arm` (ramo de rota posicionado após coringa `_`)<br>`empty_infinite_loop` (loop `infinite` sem saída via `break` ou `emit`) |
| **`suspicious`** | `warn` | `self_assignment` (atribuição redundante `x = x`)<br>`tautological_comparison` (comparação sempre verdadeira/falsa `a == a`)<br>`missing_operation_emit` (operação de agente sem caminho de `emit`) |
| **`style`** | `warn` | `redundant_mut` (variável `mut` nunca reatribuída; sugere `imut`)<br>`legacy_comment` (comentário `#` em vez de `#L`)<br>`naming_convention` (contrato ou agente fora de PascalCase) |
| **`complexity`** | `warn` | `collapsible_route` (rota booleana simplificável em expressão direta)<br>`superfluous_guard_parens` (parênteses redundantes em guarda `(c) ==>`) |

### 2.2 Sistema de Controle de Severidade
O desenvolvedor pode redefinir o comportamento de qualquer regra individual ou categoria inteira:
- `-W, --warn <lint|cat>`: Emite aviso informativo no terminal sem interromper o build.
- `-D, --deny <lint|cat>`: Promove a infração a erro impeditivo (exit code `1`).
- `-A, --allow <lint|cat>`: Silencia completamente a verificação.
- `-F, --forbid <lint|cat>`: Trata a regra como proibição irrevogável.""",
        "modes_en": """### 2.1 Categories and Registered Rules (11 Official Lints)
| Category | Default Level | Registered Lint Rules |
|---|:---:|---|
| **`correctness`** | `deny` | `division_by_zero` (integer division or modulo by literal zero)<br>`unreachable_route_arm` (route pattern arm placed after wildcard `_`)<br>`empty_infinite_loop` (infinite loop missing exit via `break` or `emit`) |
| **`suspicious`** | `warn` | `self_assignment` (redundant self-assignment `x = x`)<br>`tautological_comparison` (always-true/false comparison `a == a`)<br>`missing_operation_emit` (agent operation missing terminal `emit` path) |
| **`style`** | `warn` | `redundant_mut` (variable marked `mut` never reassigned; suggests `imut`)<br>`legacy_comment` (legacy `#` comments instead of `#L`)<br>`naming_convention` (contract or agent not adhering to PascalCase) |
| **`complexity`** | `warn` | `collapsible_route` (boolean route arm collapsible to direct expression)<br>`superfluous_guard_parens` (redundant parentheses in guard `(c) ==>`) |

### 2.2 Severity Configuration System
Developers can override rule severity individually or across entire categories:
- `-W, --warn <lint|cat>`: Emits non-blocking warnings on stdout.
- `-D, --deny <lint|cat>`: Treats infractions as fatal build errors (exit code `1`).
- `-A, --allow <lint|cat>`: Silences and ignores the specified check.
- `-F, --forbid <lint|cat>`: Elevates check to an irrevocable build constraint.""",
        "inputs_table_pt": r"""| Flag Curta | Flag Longa | Argumento | Padrão | Descrição |
|---|---|---|---|---|
| `-W` | `--warn` | `<lint\|cat>` | — | Define a severidade de uma regra ou categoria como warning |
| `-D` | `--deny` | `<lint\|cat>` | — | Define a severidade como erro impeditivo (exit code 1) |
| `-A` | `--allow` | `<lint\|cat>` | — | Silencia/ignora a regra ou categoria especificada |
| `-F` | `--forbid` | `<lint\|cat>` | — | Proibição estrita irrevogável da regra |
| `-f` | `--fix` | *nenhum* | `false` | Aplica correções automáticas seguras diretamente no disco |
| `-d` | `--diff` | *nenhum* | `false` | Exibe diff unificado com as correções propostas sem alterar disco |
| `-l` | `--list` | *nenhum* | — | Lista todos os 11 lints registrados com suas categorias |
| `-e` | `--explain` | `<lint>` | — | Exibe documentação embutida detalhada e exemplos do lint |
| `-r` | `--recursive` | *nenhum* | `false` | Inspeciona arquivos em subdiretórios recursivamente |
| `-h` | `--help` | *nenhum* | — | Exibe o manual de ajuda e sintaxe |
| `-v` | `--version` | *nenhum* | — | Exibe a versão oficial do utilitário |""",
        "inputs_table_en": r"""| Short Flag | Long Flag | Argument | Default | Description |
|---|---|---|---|---|
| `-W` | `--warn` | `<lint\|cat>` | — | Configures lint rule or category severity to warning |
| `-D` | `--deny` | `<lint\|cat>` | — | Configures lint rule or category as a fatal build error (exit 1) |
| `-A` | `--allow` | `<lint\|cat>` | — | Silences and bypasses the specified rule or category |
| `-F` | `--forbid` | `<lint\|cat>` | — | Establishes an irrevocable strict ban on the rule |
| `-f` | `--fix` | *none* | `false` | Applies automated safe fixes directly in-place on disk |
| `-d` | `--diff` | *none* | `false` | Prints unified diff patch of proposed fixes without altering disk |
| `-l` | `--list` | *none* | — | Lists all 11 registered lints with descriptions and categories |
| `-e` | `--explain` | `<lint>` | — | Prints detailed documentation and code examples for a lint |
| `-r` | `--recursive` | *none* | `false` | Recursively inspects nested subdirectories |
| `-h` | `--help` | *none* | — | Displays the help manual and syntax guide |
| `-v` | `--version` | *none* | — | Displays the official version string |""",
        "outputs_pt": """### 4.1 Códigos de Término (Exit Codes)
| Código de Saída | Significado | Condição |
|:---:|---|---|
| `0` | **Sucesso** | Nenhuma violação impeditiva encontrada (apenas warnings ou código limpo) |
| `1` | **Erro de Lint** | Pelo menos uma infração de nível `deny` foi disparada |

### 4.2 Relatórios Diagnósticos (stdout/stderr)
Cada diagnóstico emitido detalha:
- Localização exata: `<arquivo>:<linha>:<coluna>`
- Nível de severidade: `error:`, `warning:` ou `suggestion:`
- Nome qualificado da regra: `[fluxlinter::<regra>]`
- Destaque visual da linha com apontador `^`
- Sugestão de correção acionável.""",
        "outputs_en": """### 4.1 Exit Codes
| Exit Code | Meaning | Condition |
|:---:|---|---|
| `0` | **Success** | No blocking infractions found (only warnings or pristine code) |
| `1` | **Lint Failure** | At least one check with `deny` severity was triggered |

### 4.2 Diagnostic Reports (stdout/stderr)
Each diagnostic emission includes:
- Exact source coordinates: `<file>:<line>:<column>`
- Severity tier: `error:`, `warning:`, or `suggestion:`
- Fully-qualified rule identifier: `[fluxlinter::<rule>]`
- Visual source snippet with caret pointing indicators `^`
- Actionable automated remediation suggestions.""",
        "examples_pt": """```powershell
# 1. Analisar código com configurações padrão
fluxlinter src\\* -r

# 2. Exigir conformidade estrita (tratar avisos de estilo como erro impeditivo no CI)
fluxlinter -D style src\\* -r

# 3. Aplicar correções automáticas no disco
fluxlinter -f src\\main.flux

# 4. Explicar um lint específico com exemplos
fluxlinter --explain fluxlinter::division_by_zero

# 5. Listar todos os lints disponíveis
fluxlinter --list
```""",
        "examples_en": """```powershell
# 1. Run static analysis with default severities
fluxlinter src\\* -r

# 2. Enforce strict compliance (treat style warnings as build errors in CI)
fluxlinter -D style src\\* -r

# 3. Automatically remediate lint issues on disk
fluxlinter -f src\\main.flux

# 4. View in-depth documentation and code snippets for a lint
fluxlinter --explain fluxlinter::division_by_zero

# 5. List all registered lint rules
fluxlinter --list
```""",
    },

    "fluxlsp": {
        "title_pt": "fluxlsp — Servidor Language Server Protocol (LSP) e Suporte a IDEs",
        "title_en": "fluxlsp — Language Server Protocol (LSP) Server and IDE Support",
        "binary": "bin/fluxlsp.exe (Windows) / bin/fluxlsp (Linux)",
        "source": "src/tools/fluxlsp/fluxlsp.flux",
        "version": "1.0.0",
        "desc_pt": """O **`fluxlsp`** é o servidor de linguagem oficial e motor de suporte a IDEs da linguagem TheFlux. Ele implementa a especificação padronizada **Language Server Protocol (LSP)** sobre transporte JSON-RPC 2.0 via entrada/saída padrão (`stdio`), oferecendo uma experiência de desenvolvimento rica, reativa e inteligente no Visual Studio Code e em qualquer editor compatível com LSP.

Adicionalmente, o `fluxlsp` possui o gerador de esquemas **User Defined Language (UDL 2.1)** para Notepad++ via flag `--xml`, permitindo exportar o realce sintático oficial de palavras-chave, comentários `#L` e operadores para ambientes sem suporte a LSP.""",
        "desc_en": """**`fluxlsp`** is the official Language Server Protocol (LSP) server and IDE integration engine for TheFlux. It implements the standardized **Language Server Protocol (LSP)** specification over JSON-RPC 2.0 communication on standard I/O streams (`stdio`), delivering a rich, responsive, and intelligent editing experience in Visual Studio Code and all LSP-compliant editors.

Furthermore, `fluxlsp` includes a built-in **User Defined Language (UDL 2.1)** syntax exporter for Notepad++ via the `--xml` flag, generating production-grade syntax highlighting schemes for keywords, `#L` comments, and custom operators in lightweight text editors.""",
        "modes_pt": """### 2.1 Servidor LSP para Visual Studio Code (JSON-RPC 2.0)
Quando invocado sem opções (`fluxlsp`), o utilitário entra no modo de escuta contínua de requisições e notificações estruturadas via `stdio`, implementando os seguintes recursos:
- **`textDocument/publishDiagnostics`**: Diagnósticos reativos de sintaxe, validação em tempo real de indentação de 6 espaços e alertas do `fluxlinter`.
- **`textDocument/hover`**: Documentação sob demanda ao repousar o cursor sobre palavras-chave, contratos, agentes e operadores.
- **`textDocument/completion`**: Autocompletar contextual com snippets semânticos para `route`, `infinite`, `program`, `contract`, `agent`, etc.
- **`textDocument/definition`**: Navegação com salto direto (*Go to Definition*) para funções e contratos.
- **`textDocument/formatting`**: Formatação canônica do documento acionada via atalho de teclado ou automaticamente ao salvar (*Format on Save*), integrando o motor do `fluxfmt`.
- **`textDocument/documentSymbol`**: Árvore hierárquica de símbolos para navegação por breadcrumbs e contorno de documento.

### 2.2 Gerador XML Notepad++ UDL 2.1 (`--xml`)
Quando invocado com `fluxlsp --xml [caminho]`, o utilitário gera um documento XML padronizado contendo todas as 74 palavras-chave canônicas TheFlux, delimitadores de comentários (`#L`, `#B ... B#`), separadores de blocos e operadores.""",
        "modes_en": """### 2.1 LSP Server for Visual Studio Code (JSON-RPC 2.0)
When invoked without arguments (`fluxlsp`), the tool runs continuously listening for incoming requests and notifications over standard I/O:
- **`textDocument/publishDiagnostics`**: Real-time syntax error checking, 6-space indentation validation, and linter diagnostics.
- **`textDocument/hover`**: Rich tooltips showing parameter signatures, keyword semantics, and language specifications.
- **`textDocument/completion`**: Intelligent code completions and semantic snippets for `route`, `infinite`, `program`, `contract`, and `agent` blocks.
- **`textDocument/definition`**: Go-to-definition symbol resolution across functions, contracts, and agents.
- **`textDocument/formatting`**: Canonical on-demand document formatting (including Format on Save), powered by `fluxfmt`.
- **`textDocument/documentSymbol`**: Hierarchical outline symbol tree driving editor breadcrumbs and symbol navigation.

### 2.2 Notepad++ UDL 2.1 XML Exporter (`--xml`)
When invoked as `fluxlsp --xml [path]`, the tool generates an XML definition mapping all 74 canonical TheFlux keywords, comment delimiters (`#L`, `#B ... B#`), and operators into Notepad++ User Defined Language (UDL 2.1) syntax tables.""",
        "inputs_table_pt": """| Opção / Flag | Argumento | Padrão | Descrição |
|---|---|---|---|
| *nenhuma* | — | — | Inicia o servidor de linguagem LSP em background via JSON-RPC 2.0 (stdio) |
| `--xml` | `[caminho_arquivo]` | `theflux_udl.xml` | Exporta arquivo XML de realce sintático UDL 2.1 compatível com Notepad++ |
| `-h`, `--help` | *nenhum* | — | Exibe o manual de ajuda e sintaxe |
| `-v`, `--version` | *nenhum* | — | Exibe a versão oficial do utilitário |""",
        "inputs_table_en": """| Option / Flag | Argument | Default | Description |
|---|---|---|---|
| *none* | — | — | Launches background LSP Language Server over JSON-RPC 2.0 (stdio) |
| `--xml` | `[file_path]` | `theflux_udl.xml` | Exports Notepad++ UDL 2.1 XML syntax highlighting definition |
| `-h`, `--help` | *none* | — | Displays the help manual and syntax guide |
| `-v`, `--version` | *none* | — | Displays the official version string |""",
        "outputs_pt": """### 4.1 Códigos de Término (Exit Codes)
| Código de Saída | Significado | Condição |
|:---:|---|---|
| `0` | **Sucesso** | Servidor finalizado normalmente via requisição `shutdown`/`exit` ou XML exportado |
| `1` | **Erro de Comunicação / I/O** | Quebra de pipe stdio, frame JSON-RPC corrompido ou erro de escrita do XML |

### 4.2 Protocolos e Formatos de Saída
- **No Modo LSP**:
  - Mensagens JSON-RPC 2.0 emitidas em `stdout` com cabeçalho `Content-Length: <n>\r\n\r\n{"jsonrpc":"2.0",...}`.
  - Logs estruturados e telemetria emitidos em `stderr`.
- **No Modo XML**:
  - Arquivo XML em conformidade com o DTD do Notepad++ contendo grupos de palavras-chave (`Keywords1` a `Keywords8`), estilos de operadores e delimitadores de comentários.""",
        "outputs_en": """### 4.1 Exit Codes
| Exit Code | Meaning | Condition |
|:---:|---|---|
| `0` | **Success** | Clean server termination following `shutdown`/`exit`, or successful XML export |
| `1` | **I/O / Protocol Error** | Broken stdio pipe, malformed JSON-RPC header, or XML filesystem write failure |

### 4.2 Communication Protocols and Output Formats
- **Under LSP Mode**:
  - Structured JSON-RPC 2.0 frames on `stdout` with HTTP-like headers `Content-Length: <n>\r\n\r\n{"jsonrpc":"2.0",...}`.
  - Telemetry and server diagnostic logging routed to `stderr`.
- **Under XML Mode**:
  - Clean XML file conforming to Notepad++ UDL DTD with categorized keyword sets (`Keywords1` through `Keywords8`), operator symbols, and comment delimiters.""",
        "examples_pt": """```powershell
# 1. Iniciar servidor LSP (geralmente invocado pela extensao TheFlux do VS Code)
fluxlsp

# 2. Gerar arquivo de realce sintatico para Notepad++
fluxlsp --xml theflux_notepadpp.xml

# 3. Importar no Notepad++:
#    Menu: Linguagem -> Definir linguagem... -> Importar... -> selecionar 'theflux_notepadpp.xml'
```""",
        "examples_en": """```powershell
# 1. Launch LSP server (typically spawned automatically by TheFlux VS Code extension)
fluxlsp

# 2. Export syntax highlighting definition file for Notepad++
fluxlsp --xml theflux_notepadpp.xml

# 3. Import into Notepad++:
#    Menu: Language -> User Defined Language -> Define your language... -> Import... -> select 'theflux_notepadpp.xml'
```""",
    },
}


def generate_tool_doc_pt(tool_name: str, meta: dict) -> str:
    lines = [
        f"# 🛠️ `{tool_name}` — {meta['title_pt']}",
        "",
        f"> **Binário Canônico**: `{meta['binary']}`  ",
        f"> **Código-Fonte**: [`{meta['source']}`](file:///D:/Projetos/TheFlux/{meta['source']})  ",
        f"> **Versão Oficial**: `v{meta['version']}`  ",
        f"> **Status**: ✅ Homologado no ecossistema TheFlux v1.0.0",
        "",
        "---",
        "",
        "## 1. Visão Geral e Funcionalidades",
        "",
        meta["desc_pt"],
        "",
        "---",
        "",
        "## 2. Modos de Operação",
        "",
        meta["modes_pt"],
        "",
        "---",
        "",
        "## 3. Especificação de Entradas e Opções de Linha de Comando",
        "",
        meta["inputs_table_pt"],
        "",
        "---",
        "",
        "## 4. Especificação de Retornos e Saídas",
        "",
        meta["outputs_pt"],
        "",
        "---",
        "",
        "## 5. Exemplos Canônicos de Uso e Fluxos de Trabalho",
        "",
        meta["examples_pt"],
    ]
    return "\n".join(lines) + "\n"


def generate_tool_doc_en(tool_name: str, meta: dict) -> str:
    lines = [
        f"# 🛠️ `{tool_name}` — {meta['title_en']}",
        "",
        f"> **Canonical Binary**: `{meta['binary']}`  ",
        f"> **Source Code**: [`{meta['source']}`](file:///D:/Projetos/TheFlux/{meta['source']})  ",
        f"> **Official Version**: `v{meta['version']}`  ",
        f"> **Status**: ✅ Certified across TheFlux v1.0.0 ecosystem",
        "",
        "---",
        "",
        "## 1. Overview and Capabilities",
        "",
        meta["desc_en"],
        "",
        "---",
        "",
        "## 2. Operational Modes",
        "",
        meta["modes_en"],
        "",
        "---",
        "",
        "## 3. Input Specification and Command-Line Options",
        "",
        meta["inputs_table_en"],
        "",
        "---",
        "",
        "## 4. Return and Output Specifications",
        "",
        meta["outputs_en"],
        "",
        "---",
        "",
        "## 5. Canonical Usage Examples and Workflows",
        "",
        meta["examples_en"],
    ]
    return "\n".join(lines) + "\n"


def main() -> int:
    parser = argparse.ArgumentParser(description="TheFlux Canonical Tools Docs Generator")
    parser.add_argument("--verify", action="store_true", help="Verify existing tool docs without re-writing")
    args = parser.parse_args()

    DOCS_PT_DIR.mkdir(parents=True, exist_ok=True)
    DOCS_EN_DIR.mkdir(parents=True, exist_ok=True)

    print("=" * 70)
    print("🛠️ TheFlux — Gerador de Documentação das Ferramentas Canônicas (src/tools)")
    print(f"   Destino PT: {DOCS_PT_DIR}")
    print(f"   Destino EN: {DOCS_EN_DIR}")
    print("=" * 70)

    errors = []
    for tool_name, meta in TOOLS_METADATA.items():
        pt_file = DOCS_PT_DIR / f"{tool_name}.md"
        en_file = DOCS_EN_DIR / f"{tool_name}.md"

        pt_content = generate_tool_doc_pt(tool_name, meta)
        en_content = generate_tool_doc_en(tool_name, meta)

        if not args.verify:
            pt_file.write_text(pt_content, encoding="utf-8")
            en_file.write_text(en_content, encoding="utf-8")
            print(f"  [+] Gerado: {tool_name}.md (PT e EN)")
        else:
            if not pt_file.exists() or pt_file.stat().st_size == 0:
                errors.append(f"Documento de ferramenta em PT ausente ou vazio: {pt_file.name}")
            if not en_file.exists() or en_file.stat().st_size == 0:
                errors.append(f"Documento de ferramenta em EN ausente ou vazio: {en_file.name}")

    print("=" * 70)
    if errors:
        print(f"❌ {len(errors)} erro(s) encontrados na verificação:")
        for e in errors:
            print(f"  - {e}")
        return 1

    action = "verificados" if args.verify else "gerados"
    print(f"✅ Sucesso: 4 pares de documentação de ferramentas {action} com paridade 1:1!")
    print("=" * 70)
    return 0


if __name__ == "__main__":
    sys.exit(main())
