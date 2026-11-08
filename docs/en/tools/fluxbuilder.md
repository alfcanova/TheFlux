# 🛠️ `fluxbuilder` — fluxbuilder — Project Scaffolding, Integration, and Diagnostic Utility

> **Canonical Binary**: `bin/fluxbuilder.exe (Windows) / bin/fluxbuilder (Linux)`  
> **Source Code**: [`src/tools/fluxbuilder/fluxbuilder.flux`](file:///D:/Projetos/TheFlux/src/tools/fluxbuilder/fluxbuilder.flux)  
> **Official Version**: `v1.0.0`  
> **Status**: ✅ Certified across TheFlux v1.0.0 ecosystem

---

## 1. Overview and Capabilities

**`fluxbuilder`** is the native project lifecycle management and bootstrapping utility for the TheFlux language ecosystem. It provides both an interactive terminal wizard guided by user-friendly prompts and a robust non-interactive CLI mode tailored for CI/CD automation pipelines.

Beyond scaffolding new projects with standardized directory hierarchies and configuration manifests (`flux.toml`), `fluxbuilder` implements specialized **Idempotent Repair** (`--repair`) and **Environment Diagnostics** (`--doctor`) modes, ensuring that the `fluxc` compiler, Clang/LLVM toolchain, and Git version control systems are operational and properly configured.

---

## 2. Operational Modes

### 2.1 Interactive Terminal Wizard
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
4. Generates a clear report displaying status badges: `[OK]`, `[WARNING]`, or `[ERROR]`.

---

## 3. Input Specification and Command-Line Options

| Short Flag | Long Flag | Argument | Default | Description |
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
| `-v` | `--version` | *none* | — | Displays the official version string |

---

## 4. Return and Output Specifications

### 4.1 Exit Codes
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
- `LICENSE`: Selected legal licensing terms.

---

## 5. Canonical Usage Examples and Workflows

```powershell
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
```
