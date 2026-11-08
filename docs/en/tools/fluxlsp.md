# 🛠️ `fluxlsp` — fluxlsp — Language Server Protocol (LSP) Server and IDE Support

> **Canonical Binary**: `bin/fluxlsp.exe (Windows) / bin/fluxlsp (Linux)`  
> **Source Code**: [`src/tools/fluxlsp/fluxlsp.flux`](file:///D:/Projetos/TheFlux/src/tools/fluxlsp/fluxlsp.flux)  
> **Official Version**: `v1.0.0`  
> **Status**: ✅ Certified across TheFlux v1.0.0 ecosystem

---

## 1. Overview and Capabilities

**`fluxlsp`** is the official Language Server Protocol (LSP) server and IDE integration engine for TheFlux. It implements the standardized **Language Server Protocol (LSP)** specification over JSON-RPC 2.0 communication on standard I/O streams (`stdio`), delivering a rich, responsive, and intelligent editing experience in Visual Studio Code and all LSP-compliant editors.

Furthermore, `fluxlsp` includes a built-in **User Defined Language (UDL 2.1)** syntax exporter for Notepad++ via the `--xml` flag, generating production-grade syntax highlighting schemes for keywords, `#L` comments, and custom operators in lightweight text editors.

---

## 2. Operational Modes

### 2.1 LSP Server for Visual Studio Code (JSON-RPC 2.0)
When invoked without arguments (`fluxlsp`), the tool runs continuously listening for incoming requests and notifications over standard I/O:
- **`textDocument/publishDiagnostics`**: Real-time syntax error checking, 6-space indentation validation, and linter diagnostics.
- **`textDocument/hover`**: Rich tooltips showing parameter signatures, keyword semantics, and language specifications.
- **`textDocument/completion`**: Intelligent code completions and semantic snippets for `route`, `infinite`, `program`, `contract`, and `agent` blocks.
- **`textDocument/definition`**: Go-to-definition symbol resolution across functions, contracts, and agents.
- **`textDocument/formatting`**: Canonical on-demand document formatting (including Format on Save), powered by `fluxfmt`.
- **`textDocument/documentSymbol`**: Hierarchical outline symbol tree driving editor breadcrumbs and symbol navigation.

### 2.2 Notepad++ UDL 2.1 XML Exporter (`--xml`)
When invoked as `fluxlsp --xml [path]`, the tool generates an XML definition mapping all 74 canonical TheFlux keywords, comment delimiters (`#L`, `#B ... B#`), and operators into Notepad++ User Defined Language (UDL 2.1) syntax tables.

---

## 3. Input Specification and Command-Line Options

| Option / Flag | Argument | Default | Description |
|---|---|---|---|
| *none* | — | — | Launches background LSP Language Server over JSON-RPC 2.0 (stdio) |
| `--xml` | `[file_path]` | `theflux_udl.xml` | Exports Notepad++ UDL 2.1 XML syntax highlighting definition |
| `-h`, `--help` | *none* | — | Displays the help manual and syntax guide |
| `-v`, `--version` | *none* | — | Displays the official version string |

---

## 4. Return and Output Specifications

### 4.1 Exit Codes
| Exit Code | Meaning | Condition |
|:---:|---|---|
| `0` | **Success** | Clean server termination following `shutdown`/`exit`, or successful XML export |
| `1` | **I/O / Protocol Error** | Broken stdio pipe, malformed JSON-RPC header, or XML filesystem write failure |

### 4.2 Communication Protocols and Output Formats
- **Under LSP Mode**:
  - Structured JSON-RPC 2.0 frames on `stdout` with HTTP-like headers `Content-Length: <n>

{"jsonrpc":"2.0",...}`.
  - Telemetry and server diagnostic logging routed to `stderr`.
- **Under XML Mode**:
  - Clean XML file conforming to Notepad++ UDL DTD with categorized keyword sets (`Keywords1` through `Keywords8`), operator symbols, and comment delimiters.

---

## 5. Canonical Usage Examples and Workflows

```powershell
# 1. Launch LSP server (typically spawned automatically by TheFlux VS Code extension)
fluxlsp

# 2. Export syntax highlighting definition file for Notepad++
fluxlsp --xml theflux_notepadpp.xml

# 3. Import into Notepad++:
#    Menu: Language -> User Defined Language -> Define your language... -> Import... -> select 'theflux_notepadpp.xml'
```
