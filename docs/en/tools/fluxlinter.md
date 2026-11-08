# 🛠️ `fluxlinter` — fluxlinter — Canonical Static Analysis and Linter Utility

> **Canonical Binary**: `bin/fluxlinter.exe (Windows) / bin/fluxlinter (Linux)`  
> **Source Code**: [`src/tools/fluxlinter/fluxlinter.flux`](file:///D:/Projetos/TheFlux/src/tools/fluxlinter/fluxlinter.flux)  
> **Official Version**: `v1.0.0`  
> **Status**: ✅ Certified across TheFlux v1.0.0 ecosystem

---

## 1. Overview and Capabilities

**`fluxlinter`** is the official canonical linter and static analysis engine for TheFlux. Heavily inspired by the architecture and developer experience of Clippy in the Rust ecosystem (`rustc`), it conducts deep AST and token-stream inspections to catch latent bugs, suspicious logic, code smells, and stylistic deviations prior to compilation.

The tool categorizes lints across 4 formal severity categories and provides automated **Autofix** (`--fix`) capabilities, enabling instant and safe remediation of stylistic and complexity issues directly on disk.

---

## 2. Operational Modes

### 2.1 Categories and Registered Rules (11 Official Lints)
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
- `-F, --forbid <lint|cat>`: Elevates check to an irrevocable build constraint.

---

## 3. Input Specification and Command-Line Options

| Short Flag | Long Flag | Argument | Default | Description |
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
| `-v` | `--version` | *none* | — | Displays the official version string |

---

## 4. Return and Output Specifications

### 4.1 Exit Codes
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
- Actionable automated remediation suggestions.

---

## 5. Canonical Usage Examples and Workflows

```powershell
# 1. Run static analysis with default severities
fluxlinter src\* -r

# 2. Enforce strict compliance (treat style warnings as build errors in CI)
fluxlinter -D style src\* -r

# 3. Automatically remediate lint issues on disk
fluxlinter -f src\main.flux

# 4. View in-depth documentation and code snippets for a lint
fluxlinter --explain fluxlinter::division_by_zero

# 5. List all registered lint rules
fluxlinter --list
```
