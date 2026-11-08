# 🛠️ `fluxbuilder` — fluxbuilder — Utilitário de Scaffolding, Integração e Diagnóstico de Projetos

> **Binário Canônico**: `bin/fluxbuilder.exe (Windows) / bin/fluxbuilder (Linux)`  
> **Código-Fonte**: [`src/tools/fluxbuilder/fluxbuilder.flux`](file:///D:/Projetos/TheFlux/src/tools/fluxbuilder/fluxbuilder.flux)  
> **Versão Oficial**: `v1.0.0`  
> **Status**: ✅ Homologado no ecossistema TheFlux v1.0.0

---

## 1. Visão Geral e Funcionalidades

O **`fluxbuilder`** é o utilitário nativo de gerenciamento do ciclo inicial de desenvolvimento de projetos TheFlux. Oferece tanto um assistente interativo em terminal (*Wizard*) guiado por prompts amigáveis quanto suporte completo a modo não-interativo via flags de linha de comando para automação em pipelines de CI/CD.

Além de inicializar novos projetos com estrutura de diretórios padronizada e manifestos declarativos (`flux.toml`), o `fluxbuilder` implementa os modos exclusivos de **Reparo Idempotente** (`--repair`) e **Diagnóstico de Ambiente** (`--doctor`), garantindo que o compilador `fluxc`, o toolchain C/LLVM `clang` e o ecossistema Git estejam configurados corretamente.

---

## 2. Modos de Operação

### 2.1 Assistente Interativo (Modo Wizard)
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
4. Emite relatório com marcadores `[OK]`, `[AVISO]` e `[ERRO]`.

---

## 3. Especificação de Entradas e Opções de Linha de Comando

| Flag Curta | Flag Longa | Argumento | Padrão | Descrição |
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
| `-v` | `--version` | *nenhum* | — | Exibe a versão oficial do utilitário |

---

## 4. Especificação de Retornos e Saídas

### 4.1 Códigos de Término (Exit Codes)
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
- `LICENSE`: Arquivo de licença contendo os termos legais escolhidos.

---

## 5. Exemplos Canônicos de Uso e Fluxos de Trabalho

```powershell
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
```
