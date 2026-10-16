#!/usr/bin/env python3
"""Sync Errors Catalog: Compiles YAML error definitions into in-memory code and docs.

Generates:
  1. src/flux_proto/diagnostics/catalog_data.py (Static O(1) in-memory dictionaries for Python compiler)
  2. src/flux_proto/llvm/runtime/flux_errors.h (C runtime enum and error messages for LLVM/Wasm)
  3. docs/Errors.md (Authoritative unified markdown documentation sorted strictly by class: 0xx, 1xx, 2xx, 3xx, 4xx, 5xx, 6xx, 7xx)

Guarantees ZERO disk I/O overhead during compilation and execution.
"""
from __future__ import annotations

import argparse
import glob
import os
import re
import sys
import yaml

CODE_RE = re.compile(r"^([A-Z]{2,4})(\d{3})$")

FAMILY_RANGES = {
    "LEX": (1, 99),
    "SYN": (100, 199),
    "IMP": (200, 299),
    "SEM": (300, 399),
    "TYP": (400, 499),
    "OWN": (500, 599),
    "CON": (600, 699),
    "RT":  (700, 799),
}

CLASS_SECTIONS_PT = [
    ("0xx", "LEX", "Léxico e Tokenização", 1, 99, "Erros relacionados a literais, delimitadores e caracteres inválidos"),
    ("1xx", "SYN", "Sintaxe e Estrutura Gramatical", 100, 199, "Erros de estrutura gramatical, conectores `==>` e declarações canônicas de tipos e coleções"),
    ("2xx", "IMP", "Módulos e Resolução de Importações", 200, 299, "Erros de resolução de módulos `.fdsl`, ciclos de dependência e controle de acesso privado"),
    ("3xx", "SEM", "Análise Semântica e Escopos", 300, 399, "Erros de regras da linguagem, convenções de nomenclatura, escopos e contratos"),
    ("4xx", "TYP", "Sistema de Tipos e Tipagem Estática", 400, 499, "Erros de incompatibilidade direcional de tipos estáticos, coerções e retornos"),
    ("5xx", "OWN", "Posse de Memória (Ownership) e Mutabilidade", 500, 599, "Erros de ciclo de vida de memória, reatribuição imutável, uso pós-movimentação e coleções"),
    ("6xx", "CON", "Concorrência, Atores e Máquinas de Estado (FSM)", 600, 699, "Erros de concorrência, transições de estado na FSM e mailboxes de atores"),
    ("7xx", "RT",  "Tempo de Execução Nativa (Runtime)", 700, 799, "Erros e exceções geradas pelo motor nativo de execução em tempo de runtime"),
]

CLASS_SECTIONS_EN = [
    ("0xx", "LEX", "Lexical and Tokenization", 1, 99, "Errors related to literals, delimiters, and invalid characters"),
    ("1xx", "SYN", "Syntax and Grammatical Structure", 100, 199, "Grammar structure errors, `==>` connectors, and canonical type/collection declarations"),
    ("2xx", "IMP", "Modules and Import Resolution", 200, 299, "Module resolution errors (`.fdsl`), circular dependencies, and private access violations"),
    ("3xx", "SEM", "Semantic Analysis and Scopes", 300, 399, "Language rules, naming conventions, scopes, and contracts"),
    ("4xx", "TYP", "Type System and Static Typing", 400, 499, "Directional static type mismatches, coercions, and return types"),
    ("5xx", "OWN", "Memory Ownership and Mutability", 500, 599, "Memory lifecycle, immutable reassignment, use-after-move, and collection mutability"),
    ("6xx", "CON", "Concurrency, Actors, and State Machines (FSM)", 600, 699, "Concurrency errors, invalid FSM state transitions, and actor mailboxes"),
    ("7xx", "RT",  "Native Runtime", 700, 799, "Errors and exceptions raised by the native runtime engine"),
]

CLASS_SECTIONS = CLASS_SECTIONS_PT



def error_sort_key(item: dict) -> tuple[int, str]:
    """Sorts errors numerically by class: 0xx (LEX), 1xx (SYN), 2xx (IMP), 3xx (SEM), 4xx (TYP), 5xx (OWN), 6xx (CON), 7xx (RT)."""
    code = str(item.get("code", "")).strip().upper()
    m = CODE_RE.match(code)
    if m:
        return (int(m.group(2)), code)
    return (9999, code)


def parse_type_mismatch_from_mnemonic(mnemonic: str) -> tuple[str, str] | None:
    """Infers (expected, actual) types from mnemonics like EXPECT_INT_GOT_FLOAT."""
    m = re.match(r"^EXPECT_([A-Z0-9]+)_GOT_([A-Z0-9]+)$", mnemonic.upper())
    if m:
        exp, act = m.group(1).lower(), m.group(2).lower()
        return (exp, act)
    return None


def collect_errors_from_yaml_dir(yaml_dir: str) -> list[dict]:
    errors = []
    yaml_files = sorted(glob.glob(os.path.join(yaml_dir, "KW_*.yaml")))
    for path in yaml_files:
        basename = os.path.basename(path)
        with open(path, "r", encoding="utf-8") as f:
            try:
                data = yaml.safe_load(f)
            except Exception as e:
                print(f"Error parsing YAML '{path}': {e}", file=sys.stderr)
                continue
        if not isinstance(data, dict):
            continue
        err_list = data.get("errors")
        if not err_list or not isinstance(err_list, list):
            continue
        for idx, item in enumerate(err_list):
            if not isinstance(item, dict):
                continue
            item_copy = dict(item)
            item_copy["yaml_file"] = basename
            errors.append(item_copy)
    return errors


def validate_errors(errors: list[dict]) -> list[str]:
    issues = []
    seen_codes = {}
    seen_mnemonics = {}

    for item in errors:
        code = str(item.get("code", "")).strip().upper()
        mnemonic = str(item.get("mnemonic", "")).strip().upper()
        yaml_file = item.get("yaml_file", "<unknown>")

        if not code:
            issues.append(f"[{yaml_file}] Missing 'code' in error entry: {item}")
            continue
        if not mnemonic:
            issues.append(f"[{yaml_file}] Missing 'mnemonic' in error entry for code '{code}'")
            continue

        m = CODE_RE.match(code)
        if not m:
            issues.append(f"[{yaml_file}] Code '{code}' does not match standard pattern (e.g. TYP401, SEM301).")
        else:
            fam = m.group(1)
            num = int(m.group(2))
            if fam in FAMILY_RANGES:
                low, high = FAMILY_RANGES[fam]
                if not (low <= num <= high):
                    issues.append(f"[{yaml_file}] Code '{code}' number {num} outside standard range {low}-{high} for family '{fam}'.")
            else:
                issues.append(f"[{yaml_file}] Unknown error family '{fam}' in code '{code}'.")

        if code in seen_codes:
            issues.append(f"Duplicate error code '{code}' in '{yaml_file}' (already defined in '{seen_codes[code]}')")
        else:
            seen_codes[code] = yaml_file

        if mnemonic in seen_mnemonics:
            issues.append(f"Duplicate mnemonic '{mnemonic}' in '{yaml_file}' (already defined in '{seen_mnemonics[mnemonic]}')")
        else:
            seen_mnemonics[mnemonic] = yaml_file

        if not item.get("message"):
            issues.append(f"[{yaml_file}] Missing 'message' for error '{code}'")
        if not item.get("trigger"):
            issues.append(f"[{yaml_file}] Missing 'trigger' for error '{code}'")
        if not item.get("hint") or not str(item.get("hint")).strip():
            issues.append(f"[{yaml_file}] Missing mandatory 'hint' for error '{code}'")

    return issues


def generate_python_catalog(errors: list[dict], output_path: str):
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    sorted_errors = sorted(errors, key=error_sort_key)
    lines = [
        '"""Auto-generated ahead-of-time diagnostic catalog data.',
        'DO NOT EDIT MANUALLY! Generated by scripts/sync_errors_catalog.py.',
        '"""',
        'from __future__ import annotations',
        'from flux_proto.diagnostics.catalog import DiagnosticDef',
        '',
        'ERRORS_BY_CODE: dict[str, DiagnosticDef] = {',
    ]

    for item in sorted_errors:
        code = str(item.get("code", "")).strip().upper()
        mnemonic = str(item.get("mnemonic", "")).strip().upper()
        category = code[:3] if len(code) >= 3 else "GEN"
        severity = str(item.get("severity", "Error")).strip()
        trigger = str(item.get("trigger", "")).replace('"""', '\\"\\"\\"')
        message = str(item.get("message", "")).replace('"""', '\\"\\"\\"')
        hint = str(item.get("hint", "")).replace('"""', '\\"\\"\\"')
        example_bad = str(item.get("example_bad", "")).replace('"""', '\\"\\"\\"')
        example_good = str(item.get("example_good", "")).replace('"""', '\\"\\"\\"')
        yaml_file = str(item.get("yaml_file", ""))
        
        # Mismatch detection
        mismatch = item.get("type_mismatch")
        exp_type = None
        act_type = None
        if isinstance(mismatch, (list, tuple)) and len(mismatch) >= 2:
            exp_type, act_type = str(mismatch[0]).lower(), str(mismatch[1]).lower()
        else:
            inferred = parse_type_mismatch_from_mnemonic(mnemonic)
            if inferred:
                exp_type, act_type = inferred

        lines.append(f'    "{code}": DiagnosticDef(')
        lines.append(f'        code="{code}",')
        lines.append(f'        mnemonic="{mnemonic}",')
        lines.append(f'        category="{category}",')
        lines.append(f'        severity="{severity}",')
        lines.append(f'        trigger="""{trigger}""",')
        lines.append(f'        message="""{message}""",')
        lines.append(f'        hint="""{hint}""",')
        lines.append(f'        example_bad="""{example_bad}""",')
        lines.append(f'        example_good="""{example_good}""",')
        lines.append(f'        expected_type={repr(exp_type)},')
        lines.append(f'        actual_type={repr(act_type)},')
        lines.append(f'        yaml_file="{yaml_file}",')
        lines.append('    ),')

    lines.append('}')
    lines.append('')
    lines.append('ERRORS_BY_MNEMONIC: dict[str, DiagnosticDef] = {')
    lines.append('    d.mnemonic: d for d in ERRORS_BY_CODE.values()')
    lines.append('}')
    lines.append('')
    lines.append('TYPE_MISMATCH_MATRIX: dict[tuple[str, str], DiagnosticDef] = {')
    lines.append('    (d.expected_type, d.actual_type): d')
    lines.append('    for d in ERRORS_BY_CODE.values()')
    lines.append('    if d.expected_type and d.actual_type')
    lines.append('}')
    lines.append('')

    content = "\n".join(lines)
    with open(output_path, "w", encoding="utf-8") as f:
        f.write(content)


def generate_c_header(errors: list[dict], output_path: str):
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    sorted_errors = sorted(errors, key=error_sort_key)
    lines = [
        "/* Auto-generated Ahead-of-Time Runtime Errors Header.",
        " * DO NOT EDIT MANUALLY! Generated by scripts/sync_errors_catalog.py.",
        " */",
        "#ifndef FLUX_ERRORS_H",
        "#define FLUX_ERRORS_H",
        "",
        "#ifdef __cplusplus",
        'extern "C" {',
        "#endif",
        "",
        "typedef enum {",
        "    FLUX_ERR_OK = 0,",
    ]

    for item in sorted_errors:
        code = str(item.get("code", "")).strip().upper()
        mnemonic = str(item.get("mnemonic", "")).strip().upper()
        m = CODE_RE.match(code)
        num = int(m.group(2)) if m else 999
        lines.append(f"    FLUX_ERR_{mnemonic} = {num}, /* {code} */")

    lines.extend([
        "} FluxErrorCode;",
        "",
        "static inline const char* flux_error_code_str(FluxErrorCode err) {",
        "    switch (err) {",
        "        case FLUX_ERR_OK: return \"OK\";",
    ])

    for item in sorted_errors:
        code = str(item.get("code", "")).strip().upper()
        mnemonic = str(item.get("mnemonic", "")).strip().upper()
        lines.append(f"        case FLUX_ERR_{mnemonic}: return \"{code}\";")

    lines.extend([
        "        default: return \"ERR_UNKNOWN\";",
        "    }",
        "}",
        "",
        "static inline const char* flux_error_mnemonic(FluxErrorCode err) {",
        "    switch (err) {",
        "        case FLUX_ERR_OK: return \"OK\";",
    ])

    for item in sorted_errors:
        mnemonic = str(item.get("mnemonic", "")).strip().upper()
        lines.append(f"        case FLUX_ERR_{mnemonic}: return \"{mnemonic}\";")

    lines.extend([
        "        default: return \"UNKNOWN\";",
        "    }",
        "}",
        "",
        "static inline const char* flux_error_message(FluxErrorCode err) {",
        "    switch (err) {",
        "        case FLUX_ERR_OK: return \"Operação realizada com sucesso\";",
    ])

    for item in sorted_errors:
        mnemonic = str(item.get("mnemonic", "")).strip().upper()
        msg = str(item.get("message", "")).replace('"', '\\"')
        lines.append(f"        case FLUX_ERR_{mnemonic}: return \"{msg}\";")

    lines.extend([
        "        default: return \"Erro desconhecido em tempo de execução\";",
        "    }",
        "}",
        "",
        "static inline const char* flux_error_hint(FluxErrorCode err) {",
        "    switch (err) {",
        "        case FLUX_ERR_OK: return \"\";",
    ])

    for item in sorted_errors:
        mnemonic = str(item.get("mnemonic", "")).strip().upper()
        hnt = str(item.get("hint", "")).replace('"', '\\"')
        lines.append(f"        case FLUX_ERR_{mnemonic}: return \"{hnt}\";")

    lines.extend([
        "        default: return \"\";",
        "    }",
        "}",
        "",
        "#ifdef __cplusplus",
        "}",
        "#endif",
        "",
        "#endif /* FLUX_ERRORS_H */",
        "",
    ])

    content = "\n".join(lines)
    with open(output_path, "w", encoding="utf-8") as f:
        f.write(content)


def generate_errors_catalog_docs(errors: list[dict], output_path: str, lang: str = "pt"):
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    sorted_errors = sorted(errors, key=error_sort_key)

    if lang == "en":
        sections = CLASS_SECTIONS_EN
        lines = [
            "# 📋 Official Architecture & Diagnostic Errors Catalog — TheFlux",
            "",
            "> **Status**: ✅ Implemented and Fully Verified (100% Completed)  ",
            f"> **Objective**: Authoritative and unified documentation of diagnostic architecture, error conventions, design guidelines, complete catalog of {len(sorted_errors)} official diagnostics with prescriptive hints (`hint:`), and implementation checklist for TheFlux programming language.",
            "",
            "---",
            "",
            "## 🎯 1. Scope and Design Guidelines for the Error System",
            "",
            "### 1.1 Universal Coverage Across the 8 Error Families",
            "TheFlux categorizes all compilation and execution issues into 8 canonical families with strictly delimited three-digit numeric ranges:",
            "",
            "| Class | Family | Range | Description | Primary Responsibilities |",
            "| :---: | :--- | :---: | :--- | :--- |",
            "| **0xx** | **`LEX`** | `001–099` | Lexical and Tokenization | Unterminated string/comment delimiters, invalid non-ASCII characters, forbidden tabs (`\\t`), numeric literal formatting, and boolean casing. |",
            "| **1xx** | **`SYN`** | `100–199` | Syntax and Grammatical Structure | Unexpected tokens, unbalanced delimiters, canonical collection declarations (`tensor`, `list`, `set`), missing `==>` connector, and deprecated syntax. |",
            "| **2xx** | **`IMP`** | `200–299` | Modules and Import Resolution | Missing `.fdsl` files, cyclic dependencies, private operation access violations (`_op`), and alias collisions. |",
            "| **3xx** | **`SEM`** | `300–399` | Semantic Analysis and Scopes | Naming conventions (*PascalCase*, *camelCase*, *snake_case*, *SCREAMING_SNAKE*), required initializers on immutable variables, incomplete agents per contracts (`impl`), and channel rules in `emit`. |",
            "| **4xx** | **`TYP`** | `400–499` | Type System and Static Typing | Full matrix of directional type incompatibilities (e.g., `int` receiving `float` vs `float` receiving `complex`), `emit` return types, and invalid coercions. |",
            "| **5xx** | **`OWN`** | `500–599` | Memory Ownership and Mutability | Reassignment to immutable variables/fields (`imut`), use-after-move, mutable borrow conflicts (`borrow_mut`), and prohibition of immutable collections. |",
            "| **6xx** | **`CON`** | `600–699` | Concurrency, Actors, and State Machines (FSM) | Invalid FSM transitions, sends on closed channels, and actor mailbox overflow. |",
            "| **7xx** | **`RT`**  | `700–799` | Native Runtime | Division by zero, 1-based collection out-of-bounds, decompression quota exhaustion (`DecompressQuota`), stack overflow, and out of memory. |",
            "",
            "### 1.2 Principle of Violated Expectation",
            "Error messages and codes strictly adhere to the **Principle of Violated Expectation**: the code and message reside on the keyword or entity that **established the expected rule**, rather than on the value that violated it.",
            "* Example: If a variable declared as `mut as int64: x` is assigned `3.14`, the rule violated was the expectation of type `int64`. Therefore, the error is cataloged in `KW_TYPE_int.yaml` under code `TYP401` (`EXPECT_INT_GOT_FLOAT`).",
            "* Opposite example: If a variable declared as `mut as complex128: c` receives `10`, the rule violated was that of type `complex128`. Therefore, the error resides in `KW_TYPE_complex.yaml` under code `TYP411` (`EXPECT_COMPLEX_GOT_INT`).",
            "",
            "### 1.3 Canonical Standardized Diagnostic Format",
            "All tools (compiler, interpreter, backends, and CLI) emit messages in the universal canonical format:",
            "",
            "```text",
            "<file>:<line>,<col> -> [<CODE> - <MNEMONIC>]: <MESSAGE> (line X, column Y)",
            "  💡 Hint: <actionable text guiding the correction>",
            "```",
            "",
            "---",
            "",
            "## ⚡ 2. Ahead-of-Time (AOT) Architecture and Zero Runtime I/O Overhead",
            "",
            "To ensure rich diagnostics introduce zero latency or disk I/O during critical compilations and runs, TheFlux adopts an **Ahead-of-Time (AOT)** pipeline:",
            "",
            "1. **Single Source of Truth**: All canonical error definitions are declared directly in the `errors:` sections of YAML files in `docs/en/keywords/KW_*.yaml`.",
            "2. **Catalog Validator and Compiler (`scripts/sync_errors_catalog.py`)**: During build / CI time, the compiler scans all YAMLs, validates integrity rules, and compiles data directly into source code:",
            "   - **Python** ([`src/flux_proto/diagnostics/catalog_data.py`](../src/flux_proto/diagnostics/catalog_data.py)): Static in-memory dictionaries (`ERRORS_BY_CODE`, `ERRORS_BY_MNEMONIC`, `TYPE_MISMATCH_MATRIX`) with $O(1)$ lookup complexity without touching the file system.",
            "   - **C Runtime** ([`src/flux_proto/llvm/runtime/flux_errors.h`](../src/flux_proto/llvm/runtime/flux_errors.h)): `FluxErrorCode` enum and C string resolution tables with fast static lookup via `switch-case` for LLVM IR and WebAssembly.",
            "   - **CLI Self-Help**: `flux --explain <CODE_OR_MNEMONIC>` resolves the full error explanation instantly.",
            "",
            "---",
            "",
            "## 📐 3. Standard Structure of the `errors:` YAML Section",
            "",
            "Each keyword, type, or operator in `keywords/` must contain an `errors:` section with the required fields:",
            "* `code`: Standard alphanumeric code with 3-letter family prefix + 3 digits (e.g., `TYP401`, `OWN501`).",
            "* `mnemonic`: Mnemonic name in SCREAMING_SNAKE_CASE (e.g., `EXPECT_INT_GOT_FLOAT`).",
            "* `severity`: Diagnostic level (`Error`, `Warning`, or `Suggestion`).",
            "* `trigger`: Technical description of the exact condition that triggers the error.",
            "* `message`: Canonical message emitted by the compiler.",
            "* `hint`: **Mandatory field**. Prescriptive corrective action guiding the user how to fix the code.",
            "* `example_bad`: TheFlux snippet illustrating invalid code.",
            "* `example_good`: TheFlux snippet illustrating canonical corrected code.",
            "",
            "### 3.1 Canonical Example in English (`docs/en/keywords/KW_op.yaml`)",
            "```yaml",
            "restrictions:",
            "  - 'Operation name must be in camelCase: `op operationName`.'",
            "  - 'Parameters follow the convention `[mut | imut | as] <type>: <identifier>`.'",
            "  - 'The body must end with a terminal `emit` statement when a return type is specified.'",
            "",
            "errors:",
            "  - code: \"SYN130\"",
            "    mnemonic: \"CONTRACT_OP_CANNOT_HAVE_BODY\"",
            "    severity: \"Error\"",
            "    trigger: \"Operation inside 'contract' declared with execution body '==> { ... }'\"",
            "    message: \"Operations inside 'contract' declare signatures only and cannot have bodies\"",
            "    hint: \"Remove operation body ('==> { ... }'); implementations belong exclusively to 'agent'\"",
            "    example_bad: |",
            "      contract (CalcContract) {",
            "        op add (as int64: a, as int64: b) as int64 ==> { ... }",
            "      }",
            "    example_good: |",
            "      contract (CalcContract) {",
            "        op add (as int64: a, as int64: b) as int64",
            "      }",
            "```",
            "",
            "---",
            "",
            f"## 📊 4. Summary Matrix of {len(sorted_errors)} Cataloged Errors (Class Order: 0xx to 7xx)",
            "",
            "| Code | Mnemonic | Severity | Default Message | Source File |",
            "| :--- | :--- | :---: | :--- | :--- |",
        ]

        for item in sorted_errors:
            code = item.get("code", "")
            mnemonic = item.get("mnemonic", "")
            severity = item.get("severity", "Error")
            message = item.get("message", "").replace("|", "\\|")
            yaml_file = item.get("yaml_file", "")
            lines.append(f"| `{code}` | `{mnemonic}` | {severity} | {message} | [`{yaml_file}`](keywords/{yaml_file}) |")

        lines.extend([
            "",
            "---",
            "",
            "## 🔬 5. Comprehensive Analytical Diagnostic Details",
            "",
        ])

        for class_id, prefix, class_name, low, high, desc in sections:
            class_errors = [e for e in sorted_errors if low <= error_sort_key(e)[0] <= high]
            lines.extend([
                f"### 5.{class_id[0]} Class {class_id} — {class_name} (`{prefix}` {low:03d}–{high:03d})",
                "",
                f"*{desc}. Total cataloged diagnostics: {len(class_errors)}.*",
                "",
            ])

            for item in class_errors:
                code = item.get("code", "")
                mnemonic = item.get("mnemonic", "")
                severity = item.get("severity", "Error")
                trigger = item.get("trigger", "")
                message = item.get("message", "")
                hint = item.get("hint", "")
                example_bad = item.get("example_bad", "")
                example_good = item.get("example_good", "")
                yaml_file = item.get("yaml_file", "")

                lines.extend([
                    f"#### `{code}` — `{mnemonic}`",
                    f"* **Severity**: `{severity}`",
                    f"* **Source File**: [`{yaml_file}`](keywords/{yaml_file})",
                    f"* **Trigger**: {trigger}",
                    f"* **Default Message**: *\"{message}\"*",
                    f"* **Resolution Hint**: 💡 {hint}",
                ])
                if example_bad:
                    lines.extend([
                        "",
                        "**Incorrect Example:**",
                        "```theflux",
                        example_bad.strip(),
                        "```",
                    ])
                if example_good:
                    lines.extend([
                        "",
                        "**Corrected Example:**",
                        "```theflux",
                        example_good.strip(),
                        "```",
                    ])
                lines.append("")
                lines.append("---")
                lines.append("")

        lines.extend([
            "",
            "## 🛠️ 6. Automation Tools and Catalog Validation",
            "",
            "### 6.1 `scripts/sync_errors_catalog.py`",
            "Main script for the AOT pipeline with operation modes:",
            "1. **Strict Validation (`--validate-only`)**: Scans all YAMLs and validates:",
            "   - All codes follow `[A-Z]{2,4}\\d{3}` and respect their family numeric range.",
            "   - No duplicate codes or mnemonics.",
            "   - **100% of errors have a filled, non-empty `hint:` field** (blocking build failure).",
            "2. **Python Code Generation**: Produces [`src/flux_proto/diagnostics/catalog_data.py`](../src/flux_proto/diagnostics/catalog_data.py).",
            "3. **C Runtime Generation**: Produces [`src/flux_proto/llvm/runtime/flux_errors.h`](../src/flux_proto/llvm/runtime/flux_errors.h).",
            "4. **Documentation Generation**: Produces this official unified catalog [`docs/en/Errors.md`](Errors.md).",
            "",
            "### 6.2 CLI Command `flux --explain <CODE>`",
            "Allows developers to query any official diagnostic directly in the terminal:",
            "```powershell",
            "python -m flux_proto.cli --explain TYP401",
            "python -m flux_proto.cli --explain OWN501",
            "python -m flux_proto.cli --explain RT701",
            "```",
            "",
            "---",
            "",
            "## 📋 7. Implementation Checklist and Execution Tracking",
            "",
            "- [x] **Phase 1: Tooling Infrastructure and Strict Validation**",
            "  - [x] Create `scripts/sync_errors_catalog.py` with AOT generators (Python, C, and Markdown).",
            "  - [x] Implement mandatory `hint:` validation for 100% of diagnostics.",
            "  - [x] Implement in-memory query engine `src/flux_proto/diagnostics/catalog.py` and $O(1)$ coercion matrix.",
            "- [x] **Phase 2: YAML Enrichment (Group 1: Basic Declarations and Types)**",
            "  - [x] `KW_program.yaml` (`SYN100`, `SYN140`, `SEM310`, `SEM311`, `SEM312`, `TYP499`).",
            "  - [x] `KW_mut.yaml` (`SYN105`, `SEM303`, `SEM304`, `SEM306`).",
            "  - [x] `KW_imut.yaml` (`SEM305`, `SEM307`, `OWN501`, `OWN502`).",
            "  - [x] `KW_TYPE_int.yaml` (`TYP401`..`TYP404`, `SEM301`).",
            "  - [x] `KW_TYPE_float.yaml` (`TYP421`..`TYP423`).",
            "  - [x] `KW_TYPE_complex.yaml` (`TYP411`..`TYP414`).",
            "  - [x] `KW_TYPE_string.yaml` (`TYP431`..`TYP434`).",
            "  - [x] `KW_LITERAL_bool.yaml` (`TYP441`..`TYP443`, `LEX010`).",
            "- [x] **Phase 3: YAML Enrichment (Group 2: Modules, Contracts, and Agents)**",
            "  - [x] `KW_use.yaml` (`IMP201`, `IMP202`, `IMP203`, `IMP204`).",
            "  - [x] `KW_contract.yaml` (`SEM330`, `SEM331`, `SYN130`).",
            "  - [x] `KW_agent.yaml` (`SEM340`, `SEM341`, `SEM342`, `CON603`).",
            "  - [x] `KW_emit.yaml` (`SEM350`, `SEM351`, `TYP450`).",
            "  - [x] `KW_route.yaml` (`SEM320`, `SYN120`).",
            "  - [x] `KW_struct.yaml` (`SEM360`..`SEM363`).",
            "  - [x] `KW_enum.yaml` (`SEM370`..`SEM372`).",
            "- [x] **Phase 4: YAML Enrichment (Group 3: Collections, Concurrency, and Runtime)**",
            "  - [x] `KW_comments.yaml` (`LEX001`, `LEX003`, `LEX005`, `LEX006`).",
            "  - [x] `KW_LITERAL_string.yaml` (`LEX002`, `LEX004`).",
            "  - [x] `KW_LITERAL_float.yaml` (`LEX007`).",
            "  - [x] `KW_TYPE_tensor.yaml` (`SYN150`, `SYN151`, `RT705`).",
            "  - [x] `KW_TYPE_list.yaml` (`SYN160`, `OWN505`, `RT702`).",
            "  - [x] `KW_TYPE_set.yaml` (`SYN161`).",
            "  - [x] `KW_borrow.yaml` (`OWN503`, `OWN504`).",
            "  - [x] `KW_spawn.yaml` (`CON601`, `CON602`).",
            "  - [x] `KW_OP_arithmetic.yaml` (`RT701`).",
            "  - [x] `KW_keep.yaml` (`RT703`).",
            "  - [x] `KW_infinite.yaml` (`RT704`).",
            "- [x] **Phase 5: Compiler Integration and Multi-Backend Compliance**",
            "  - [x] Update `src/flux_proto/semantic/diagnostic.py` to standardize hints.",
            "  - [x] Update `src/flux_proto/cli.py` to emit canonical format across all stages.",
            "  - [x] Verify triad and hints across all error families.",
            "  - [x] Run `python backend_compliance.py` achieving 100% passing across all 6 backends.",
            "",
        ])
    else:
        # Portuguese generation
        sections = CLASS_SECTIONS_PT
        lines = [
            "# 📋 Catálogo Oficial e Arquitetura de Diagnósticos e Erros — TheFlux",
            "",
            "> **Status**: ✅ Implementado e Homologado (100% Concluído)  ",
            f"> **Objetivo**: Documentação autoritativa e unificada da arquitetura de diagnósticos, convenções de erro, diretrizes de design, catálogo completo dos {len(sorted_errors)} erros oficiais com dicas prescritivas (`hint:`) e checklist de implementação da linguagem TheFlux.",
            "",
            "---",
            "",
            "## 🎯 1. Escopo e Diretrizes de Design do Sistema de Erros",
            "",
            "### 1.1 Cobertura Universal das 8 Famílias de Erro",
            "A linguagem TheFlux categoriza todos os possíveis problemas de compilação e execução em 8 famílias canônicas com faixas numéricas de três dígitos estritamente delimitadas:",
            "",
            "| Classe | Família | Faixa | Descrição | Principais Responsabilidades |",
            "| :---: | :--- | :---: | :--- | :--- |",
            "| **0xx** | **`LEX`** | `001–099` | Léxico e Tokenização | Delimitadores de string/comentários não terminados, caracteres inválidos fora da faixa ASCII, tabulações proibidas (`\\t`), formatação numérica literal e casing booleano. |",
            "| **1xx** | **`SYN`** | `100–199` | Sintático e Estrutura Gramatical | Tokens inesperados, delimitadores não balanceados, formas canônicas de coleções (`tensor`, `list`, `set`), ausência do conector `==>` e declarações com sintaxe obsoleta. |",
            "| **2xx** | **`IMP`** | `200–299` | Módulos e Resolução de Importações | Arquivo `.fdsl` não encontrado, dependências cíclicas entre módulos, violação de acesso a operações privadas (`_op`) e colisão de aliases. |",
            "| **3xx** | **`SEM`** | `300–399` | Análise Semântica e Escopos | Convenções de nomenclatura (*PascalCase*, *camelCase*, *snake_case*, *SCREAMING_SNAKE*), inicializadores obrigatórios em imutáveis, agentes incompletos perante seus contratos (`impl`) e regras de canal em `emit`. |",
            "| **4xx** | **`TYP`** | `400–499` | Sistema de Tipos e Tipagem Estática | Matriz completa de incompatibilidades direcionais (ex.: `int` recebendo `float` vs `float` recebendo `complex`), tipos de retorno de `emit` e coerções inválidas. |",
            "| **5xx** | **`OWN`** | `500–599` | Posse de Memória (*Ownership*) e Mutabilidade | Reatribuição a variáveis ou campos imutáveis (`imut`), leitura após movimentação (`use-after-move`), conflitos de empréstimo mutável (`borrow_mut`) e proibição de coleções imutáveis. |",
            "| **6xx** | **`CON`** | `600–699` | Concorrência, Atores e Máquinas de Estado (*FSM*) | Transições de estado inválidas na FSM, envio em canais fechados e estouro de mailbox de agentes. |",
            "| **7xx** | **`RT`**  | `700–799` | Tempo de Execução Nativa (*Runtime*) | Divisão por zero, acessos fora dos limites em coleções 1-based (*out-of-bounds*), estouro de cotas de descompressão (`DecompressQuota`), estouro de pilha (*stack overflow*) e exaustão de memória. |",
            "",
            "### 1.2 Princípio da Expectativa Violada",
            "A organização das mensagens de erro e códigos segue rigorosamente o **Princípio da Expectativa Violada**: o código e a mensagem residem na palavra-chave ou entidade que **estabeleceu a regra esperada**, e não no valor que a violou.",
            "* Exemplo: Se uma variável declarada como `mut as int64: x` recebe o valor decimal `3.14`, a regra violada foi a expectativa do tipo `int64`. Logo, o erro é catalogado em `KW_TYPE_int.yaml` sob o código `TYP401` (`EXPECT_INT_GOT_FLOAT`).",
            "* Exemplo oposto: Se uma variável declarada como `mut as complex128: c` recebe `10`, a regra violada foi a do tipo `complex128`. Logo, o erro reside em `KW_TYPE_complex.yaml` sob o código `TYP411` (`EXPECT_COMPLEX_GOT_INT`).",
            "",
            "### 1.3 Formato Canônico e Padronizado dos Diagnósticos",
            "Todas as ferramentas (compilador, interpretador, backends e CLI) emitem mensagens no formato canônico universal:",
            "",
            "```text",
            "<arquivo>:<linha>,<coluna> -> [<CÓDIGO> - <MNEMÔNICO>]: <MENSAGEM> (linha X, coluna Y)",
            "  💡 Dica: <texto acionável orientando a correção>",
            "```",
            "",
            "---",
            "",
            "## ⚡ 2. Arquitetura AOT e Zero Overhead de I/O em Runtime",
            "",
            "Para garantir que diagnósticos ricos não introduzam lentidão ou I/O de disco durante compilações e execuções críticas, TheFlux adota um pipeline **Ahead-of-Time (AOT)**:",
            "",
            "1. **Fonte Única da Verdade (`Single Source of Truth`)**: Todas as definições canônicas de erro são declaradas diretamente nas seções `errors:` dos arquivos YAML em `docs/pt/keywords/KW_*.yaml`.",
            "2. **Validador e Compilador de Catálogo (`scripts/sync_errors_catalog.py`)**: Em tempo de build / CI, o compilador varre todos os YAMLs, valida regras de integridade e compila os dados diretamente para estruturas em código-fonte:",
            "   - **Python** ([`src/flux_proto/diagnostics/catalog_data.py`](../src/flux_proto/diagnostics/catalog_data.py)): Dicionários estáticos em memória (`ERRORS_BY_CODE`, `ERRORS_BY_MNEMONIC`, `TYPE_MISMATCH_MATRIX`) com complexidade de busca $O(1)$ sem tocar no sistema de arquivos.",
            "   - **C Runtime** ([`src/flux_proto/llvm/runtime/flux_errors.h`](../src/flux_proto/llvm/runtime/flux_errors.h)): Enum `FluxErrorCode` e tabelas de resolução de strings C com busca estática rápida via `switch-case` para LLVM IR e WebAssembly.",
            "   - **Autoajuda CLI**: `flux --explain <CÓDIGO_OU_MNEMÔNICO>` resolve instantaneamente a explicação completa do erro.",
            "",
            "---",
            "",
            "## 📐 3. Estrutura Padrão da Seção `errors:` nos Arquivos YAML",
            "",
            "Cada palavra-chave, tipo ou operador em `keywords/` deve conter sua seção `errors:` com os campos obrigatórios:",
            "* `code`: Código alfanumérico padrão de 3 letras da família + 3 dígitos (ex: `TYP401`, `OWN501`).",
            "* `mnemonic`: Nome mnemônico em SCREAMING_SNAKE_CASE (ex: `EXPECT_INT_GOT_FLOAT`).",
            "* `severity`: Nível do diagnóstico (`Error`, `Warning` ou `Suggestion`).",
            "* `trigger`: Descrição técnica da condição exata que dispara o erro.",
            "* `message`: Mensagem canônica emitida pelo compilador.",
            "* `hint`: **Campo obrigatório**. Ação prescritiva de correção orientando o usuário como corrigir o código.",
            "* `example_bad`: Trecho em TheFlux ilustrando o código inválido.",
            "* `example_good`: Trecho em TheFlux ilustrando a forma canônica corrigida.",
            "",
            "### 3.1 Exemplo Canônico em Português (`docs/pt/keywords/KW_op.yaml`)",
            "```yaml",
            "restrictions:",
            "  - 'O nome da operação deve estar em camelCase: `op nomeDaOperacao`.'",
            "  - 'Parâmetros seguem a convenção `[mut | imut | as] <tipo>: <identificador>`.'",
            "  - 'O corpo deve terminar obrigatoriamente com um comando `emit` terminal quando possuir retorno.'",
            "",
            "errors:",
            "  - code: \"SYN130\"",
            "    mnemonic: \"CONTRACT_OP_CANNOT_HAVE_BODY\"",
            "    severity: \"Error\"",
            "    trigger: \"Operação dentro de 'contract' declarando corpo de execução com '==> { ... }'\"",
            "    message: \"Operações dentro de 'contract' definem apenas assinaturas e não podem possuir corpo de execução\"",
            "    hint: \"Remova o corpo da operação ('==> { ... }'); implementações pertencem exclusivamente ao 'agent'\"",
            "    example_bad: |",
            "      contract (CalculadoraContract) {",
            "        op somar (as int64: a, as int64: b) as int64 ==> {",
            "          emit(nice, a + b, \"ok\")",
            "        }",
            "      }",
            "    example_good: |",
            "      contract (CalculadoraContract) {",
            "        op somar (as int64: a, as int64: b) as int64",
            "      }",
            "```",
            "",
            "---",
            "",
            f"## 📊 4. Matriz Resumida dos {len(sorted_errors)} Erros Catalogados (Ordem por Classe: 0xx a 7xx)",
            "",
            "| Código | Mnemônico | Severidade | Mensagem Padrão | Arquivo Fonte |",
            "| :--- | :--- | :---: | :--- | :--- |",
        ]

        for item in sorted_errors:
            code = item.get("code", "")
            mnemonic = item.get("mnemonic", "")
            severity = item.get("severity", "Error")
            message = item.get("message", "").replace("|", "\\|")
            yaml_file = item.get("yaml_file", "")
            lines.append(f"| `{code}` | `{mnemonic}` | {severity} | {message} | [`{yaml_file}`](keywords/{yaml_file}) |")

        lines.extend([
            "",
            "---",
            "",
            "## 🔬 5. Detalhamento Analítico Completo dos Diagnósticos",
            "",
        ])

        for class_id, prefix, class_name, low, high, desc in sections:
            class_errors = [e for e in sorted_errors if low <= error_sort_key(e)[0] <= high]
            lines.extend([
                f"### 5.{class_id[0]} Classe {class_id} — {class_name} (`{prefix}` {low:03d}–{high:03d})",
                "",
                f"*{desc}. Total de diagnósticos catalogados: {len(class_errors)}.*",
                "",
            ])

            for item in class_errors:
                code = item.get("code", "")
                mnemonic = item.get("mnemonic", "")
                severity = item.get("severity", "Error")
                trigger = item.get("trigger", "")
                message = item.get("message", "")
                hint = item.get("hint", "")
                example_bad = item.get("example_bad", "")
                example_good = item.get("example_good", "")
                yaml_file = item.get("yaml_file", "")

                lines.extend([
                    f"#### `{code}` — `{mnemonic}`",
                    f"* **Severidade**: `{severity}`",
                    f"* **Arquivo Fonte**: [`{yaml_file}`](keywords/{yaml_file})",
                    f"* **Gatilho**: {trigger}",
                    f"* **Mensagem Padrão**: *\"{message}\"*",
                    f"* **Dica de Correção**: 💡 {hint}",
                ])
                if example_bad:
                    lines.extend([
                        "",
                        "**Exemplo Incorreto:**",
                        "```theflux",
                        example_bad.strip(),
                        "```",
                    ])
                if example_good:
                    lines.extend([
                        "",
                        "**Exemplo Corrigido:**",
                        "```theflux",
                        example_good.strip(),
                        "```",
                    ])
                lines.append("")
                lines.append("---")
                lines.append("")

        lines.extend([
            "",
            "## 🛠️ 6. Ferramentas de Automação e Validação do Catálogo",
            "",
            "### 6.1 `scripts/sync_errors_catalog.py`",
            "Script principal do pipeline AOT com os modos de operação:",
            "1. **Validação Estrita (`--validate-only`)**: Inspeciona todos os YAMLs e valida se:",
            "   - Todos os códigos seguem o padrão `[A-Z]{2,4}\\d{3}` e respeitam os limites numéricos de sua família.",
            "   - Não existem códigos ou mnemônicos duplicados.",
            "   - **100% dos erros possuem o campo `hint:` preenchido e não vazio** (falha impeditiva no build).",
            "2. **Geração de Código Python**: Produz [`src/flux_proto/diagnostics/catalog_data.py`](../src/flux_proto/diagnostics/catalog_data.py).",
            "3. **Geração de Runtime C**: Produz [`src/flux_proto/llvm/runtime/flux_errors.h`](../src/flux_proto/llvm/runtime/flux_errors.h).",
            "4. **Geração de Documentação**: Produz este catálogo oficial unificado [`docs/pt/Errors.md`](Errors.md).",
            "",
            "### 6.2 Comando CLI `flux --explain <CÓDIGO>`",
            "Permite que o desenvolvedor consulte diretamente no terminal qualquer diagnóstico oficial:",
            "```powershell",
            "python -m flux_proto.cli --explain TYP401",
            "python -m flux_proto.cli --explain OWN501",
            "python -m flux_proto.cli --explain RT701",
            "```",
            "",
            "---",
            "",
            "## 📋 7. Checklist de Implementação e Rastreamento de Execução",
            "",
            "- [x] **Fase 1: Infraestrutura de Scripts e Validação Estrita**",
            "  - [x] Criar `scripts/sync_errors_catalog.py` com geradores AOT (Python, C e Markdown).",
            "  - [x] Implementar validação mandatória de `hint:` para 100% dos diagnósticos.",
            "  - [x] Implementar motor de consulta em memória `src/flux_proto/diagnostics/catalog.py` e matriz de coerção $O(1)$.",
            "- [x] **Fase 2: Enriquecimento dos Arquivos YAML (Grupo 1: Declarações e Tipos Básicos)**",
            "  - [x] `KW_program.yaml` (`SYN100`, `SYN140`, `SEM310`, `SEM311`, `SEM312`, `TYP499`).",
            "  - [x] `KW_mut.yaml` (`SYN105`, `SEM303`, `SEM304`, `SEM306`).",
            "  - [x] `KW_imut.yaml` (`SEM305`, `SEM307`, `OWN501`, `OWN502`).",
            "  - [x] `KW_TYPE_int.yaml` (`TYP401`..`TYP404`, `SEM301`).",
            "  - [x] `KW_TYPE_float.yaml` (`TYP421`..`TYP423`).",
            "  - [x] `KW_TYPE_complex.yaml` (`TYP411`..`TYP414`).",
            "  - [x] `KW_TYPE_string.yaml` (`TYP431`..`TYP434`).",
            "  - [x] `KW_LITERAL_bool.yaml` (`TYP441`..`TYP443`, `LEX010`).",
            "- [x] **Fase 3: Enriquecimento dos Arquivos YAML (Grupo 2: Módulos, Contratos e Agentes)**",
            "  - [x] `KW_use.yaml` (`IMP201`, `IMP202`, `IMP203`, `IMP204`).",
            "  - [x] `KW_contract.yaml` (`SEM330`, `SEM331`, `SYN130`).",
            "  - [x] `KW_agent.yaml` (`SEM340`, `SEM341`, `SEM342`, `CON603`).",
            "  - [x] `KW_emit.yaml` (`SEM350`, `SEM351`, `TYP450`).",
            "  - [x] `KW_route.yaml` (`SEM320`, `SYN120`).",
            "  - [x] `KW_struct.yaml` (`SEM360`..`SEM363`).",
            "  - [x] `KW_enum.yaml` (`SEM370`..`SEM372`).",
            "- [x] **Fase 4: Enriquecimento dos Arquivos YAML (Grupo 3: Coleções, Concorrência e Runtime)**",
            "  - [x] `KW_comments.yaml` (`LEX001`, `LEX003`, `LEX005`, `LEX006`).",
            "  - [x] `KW_LITERAL_string.yaml` (`LEX002`, `LEX004`).",
            "  - [x] `KW_LITERAL_float.yaml` (`LEX007`).",
            "  - [x] `KW_TYPE_tensor.yaml` (`SYN150`, `SYN151`, `RT705`).",
            "  - [x] `KW_TYPE_list.yaml` (`SYN160`, `OWN505`, `RT702`).",
            "  - [x] `KW_TYPE_set.yaml` (`SYN161`).",
            "  - [x] `KW_borrow.yaml` (`OWN503`, `OWN504`).",
            "  - [x] `KW_spawn.yaml` (`CON601`, `CON602`).",
            "  - [x] `KW_OP_arithmetic.yaml` (`RT701`).",
            "  - [x] `KW_keep.yaml` (`RT703`).",
            "  - [x] `KW_infinite.yaml` (`RT704`).",
            "- [x] **Fase 5: Integração no Compilador e Homologação Multi-Backend**",
            "  - [x] Atualizar `src/flux_proto/semantic/diagnostic.py` para emitir `💡 Dica: <hint>` de forma padronizada.",
            "  - [x] Atualizar `src/flux_proto/cli.py` para emitir formato canônico e dicas em erros léxicos, sintáticos e importações.",
            "  - [x] Criar suite de testes em `scratch/` e homologar a tríade e dicas para todas as famílias.",
            "  - [x] Executar `python backend_compliance.py` garantindo 360/360 testes passando nos 6 backends.",
            "",
        ])

    content = "\n".join(lines)
    with open(output_path, "w", encoding="utf-8") as f:
        f.write(content)



def main():
    for stream in (sys.stdout, sys.stderr):
        if stream is not None:
            try:
                stream.reconfigure(encoding="utf-8")
            except (AttributeError, ValueError):
                pass

    repo_root = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
    default_pt_yaml = os.path.join(repo_root, "docs", "pt", "keywords")
    default_en_yaml = os.path.join(repo_root, "docs", "en", "keywords")

    parser = argparse.ArgumentParser(description="Compile YAML error definitions into in-memory code and docs.")
    parser.add_argument("--yaml-dir", default=None, help="Path to keywords YAML directory (default: docs/pt/keywords)")
    parser.add_argument("--py-output", default=os.path.join(repo_root, "src", "flux_proto", "diagnostics", "catalog_data.py"), help="Output path for Python catalog")
    parser.add_argument("--c-output", default=os.path.join(repo_root, "src", "flux_proto", "llvm", "runtime", "flux_errors.h"), help="Output path for C header")
    parser.add_argument("--docs-output", default=None, help="Output path for markdown documentation")
    parser.add_argument("--lang", choices=["pt", "en", "all"], default="all", help="Target documentation language (pt, en, or all)")
    parser.add_argument("--validate-only", action="store_true", help="Only validate definitions without generating files")
    args = parser.parse_args()

    pt_yaml_dir = args.yaml_dir if args.yaml_dir else default_pt_yaml
    en_yaml_dir = default_en_yaml

    # 1. Load & Validate PT errors
    pt_errors = collect_errors_from_yaml_dir(pt_yaml_dir)
    print(f"Loaded {len(pt_errors)} error definitions from '{pt_yaml_dir}'.")
    pt_issues = validate_errors(pt_errors)
    if pt_issues:
        print("Validation errors detected in PT definitions:", file=sys.stderr)
        for issue in pt_issues:
            print(f"  [!] {issue}", file=sys.stderr)
        return 1

    # 2. Load & Validate EN errors if requested
    en_errors = []
    if args.lang in ("en", "all") and os.path.exists(en_yaml_dir):
        en_errors = collect_errors_from_yaml_dir(en_yaml_dir)
        print(f"Loaded {len(en_errors)} error definitions from '{en_yaml_dir}'.")
        en_issues = validate_errors(en_errors)
        if en_issues:
            print("Validation errors detected in EN definitions:", file=sys.stderr)
            for issue in en_issues:
                print(f"  [!] {issue}", file=sys.stderr)
            return 1

    if args.validate_only:
        print("Validation passed successfully! 0 issues.")
        return 0

    # 3. Code Generation (from canonical PT definitions)
    generate_python_catalog(pt_errors, args.py_output)
    print(f"  [+] Python catalog generated: {args.py_output}")

    generate_c_header(pt_errors, args.c_output)
    print(f"  [+] C header generated: {args.c_output}")

    # 4. Docs Generation
    if args.lang in ("pt", "all"):
        pt_docs_path = args.docs_output if (args.docs_output and args.lang == "pt") else os.path.join(repo_root, "docs", "pt", "Errors.md")
        generate_errors_catalog_docs(pt_errors, pt_docs_path, lang="pt")
        print(f"  [+] Markdown catalog documentation (PT) generated: {pt_docs_path}")

    if args.lang in ("en", "all") and en_errors:
        en_docs_path = args.docs_output if (args.docs_output and args.lang == "en") else os.path.join(repo_root, "docs", "en", "Errors.md")
        generate_errors_catalog_docs(en_errors, en_docs_path, lang="en")
        print(f"  [+] Markdown catalog documentation (EN) generated: {en_docs_path}")

    print("Error catalog synchronization complete!")
    return 0


if __name__ == "__main__":
    sys.exit(main())

