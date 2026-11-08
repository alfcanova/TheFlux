# 🛠️ `fluxfmt` — fluxfmt — TheFlux Canonical Code Formatter

> **Canonical Binary**: `bin/fluxfmt.exe (Windows) / bin/fluxfmt (Linux)`  
> **Source Code**: [`src/tools/fluxfmt/fluxfmt.flux`](file:///D:/Projetos/TheFlux/src/tools/fluxfmt/fluxfmt.flux)  
> **Official Version**: `v1.0.0`  
> **Status**: ✅ Certified across TheFlux v1.0.0 ecosystem

---

## 1. Overview and Capabilities

**`fluxfmt`** is the official canonical code formatter for the TheFlux language, engineered to enforce strict structural and aesthetic consistency across `.flux` and `.fdsl` source files.

It strictly implements TheFlux canonical style rules:
1. **Strict 6-Space Indentation**: Every block nesting depth (`program`, `contract`, `agent`, `route`, `infinite`, functions, structs, and enums) receives exactly 6 indentation spaces, forbidding raw tab characters.
2. **Comment Normalization**: Converts legacy single-hash comments `#` to canonical `#L` (line comment) syntax while preserving `#B ... B#` block comments.
3. **Guard Simplification (`--simplify`)**: Eliminates redundant outer parentheses in pattern-matching route guards (e.g., `(x > 0) ==>` is simplified to `x > 0 ==>`).
4. **Whitespace Hygiene**: Strips trailing whitespace from line ends and ensures deterministic line terminators across the file.

---

## 2. Operational Modes

### 2.1 Operational Modes
- **List Mode (`-l` / `--list`)**: Inspects source files and reports only the paths of files violating canonical formatting rules, returning exit code `1` upon divergence. Tailored for pre-commit hooks and CI quality gates.
- **Diff Mode (`-d` / `--diff`)**: Calculates formatting adjustments and outputs a standard unified diff patch (`---` and `+++`) to stdout without altering files on disk.
- **Write Mode (`-w` / `--write`)**: Applies canonical formatting in-place to files on disk only when modifications are detected.
- **Simplify Mode (`-s` / `--simplify`)**: In addition to indentation, applies syntactic modernizations and guard parenthesization cleanups.

---

## 3. Input Specification and Command-Line Options

| Short Flag | Long Flag | Argument | Default | Description |
|---|---|---|---|---|
| `-w` | `--write` | *none* | `false` | Overwrites source files in-place on disk if formatting changes |
| `-d` | `--diff` | *none* | `false` | Prints unified diff patch to stdout without altering disk files |
| `-l` | `--list` | *none* | `false` | Lists paths of files that deviate from canonical formatting |
| `-s` | `--simplify` | *none* | `false` | Simplifies code (# to #L, redundant route guard parentheses) |
| `-e` | `--all-errors` | *none* | `false` | Emits all structural/lexical errors without aborting early |
| `-r` | `--recursive` | *none* | `false` | Recursively traverses nested subdirectories |
| `-h` | `--help` | *none* | — | Displays the help manual and syntax guide |
| `-v` | `--version` | *none* | — | Displays the official version string |

---

## 4. Return and Output Specifications

### 4.1 Exit Codes
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
- Under `-w` mode: Emits summary confirmations for modified files.

---

## 5. Canonical Usage Examples and Workflows

```powershell
# 1. Verify whether any project source violates formatting rules (CI gate)
fluxfmt -l -r src\*

# 2. Preview formatting diffs without altering files on disk
fluxfmt -d src\main.flux

# 3. Format and simplify all sources in src recursively
fluxfmt -w -s -r src\*

# 4. Format a specific file in-place
fluxfmt -w examples\Canon\ExampleOfRoute.flux
```
