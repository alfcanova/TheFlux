# Compilation and Execution — TheFlux

## Overview

A `.flux` (or `.fdsl`) source file passes through four phases to produce execution or artifacts:

```text
Source Code (.flux/.fdsl)
    │
    ▼
┌──────────────────────┐
│  Phase 1: LEXER      │  --emit-lexer
│  (lexical analyzer)  │
└──────────────────────┘
    │
    ▼
┌──────────────────────┐
│  Phase 2: PARSER     │  --emit-ast
│  (syntax analyzer)   │
└──────────────────────┘
    │
    ▼
┌──────────────────────┐
│  Phase 3: SEMANTIC   │  --emit-semantic
│  (semantic validator)│
└──────────────────────┘
    │
    ┌──────────┬──────────┬──────────┬──────────┐
    ▼          ▼          ▼          ▼          ▼
┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐ ┌──────────┐
│   RUN  │ │  VMBC  │ │   WAT  │ │  WASM  │ │   LLVM   │
│--target│ │--target│ │--target│ │--target│ │--target  │
│  run   │ │  vmbc  │ │  wat   │ │  wasm  │ │  llvm    │
│ (interp│ │(bytecode│ │(WAT text│ │ (binary│ │ (native │
│  AST)  │ │   VM)  │ │ format) │ │   WASM)│ │   exec)  │
└────────┘ └────────┘ └────────┘ └────────┘ └──────────┘
    ▼          ▼          ▼          ▼          ▼
 stdout     .fvmbc      .wat       .wasm       .exe
 (screen)  (bytecode)  (text)    (binary)    (native)
```

## Basic Usage

All compilation and execution targets use the unified `python -m flux_proto.cli` command:

```powershell
python -m flux_proto.cli <file> [--target <mode>] [--output <path>] [flags]
```

---

## 1. Interpreter (`--target run`)

Executes the program immediately and displays output to the terminal stdout.

```powershell
python -m flux_proto.cli flux/hello.flux --target run
```

**Output**: text to `stdout` (no file generated).

**Example** (`flux/hello.flux`):

```theflux
print("Hello, TheFlux!")
let X: int64 = 42
print(X)
```

```powershell
python -m flux_proto.cli flux/hello.flux --target run
# Hello, TheFlux!
# 42
```

**Requirements**: None — standard Python 3.14+.

---

## 2. Bytecode VM (`--target vmbc`)

Compiles the program to `.fvmbc` bytecode (JSON format) executable by TheFlux Virtual Machine.

```powershell
python -m flux_proto.cli flux/program.flux --target vmbc -o output
```

Generates `output.fvmbc` containing the VM bytecode in structured JSON format. The bytecode can be loaded and executed by the VM runtime (`flux_proto.vm.runtime`).

**Output**: `.fvmbc` file (JSON).

**Requirements**: Python 3.14+ (the VM is implemented in pure Python).

---

## 3. WebAssembly Text (`--target wat`)

Compiles the program into human-readable WebAssembly Text format (`.wat`).

```powershell
python -m flux_proto.cli flux/program.flux --target wat -o output
```

Generates `output.wat`. To convert to binary `.wasm`:

```powershell
wat2wasm output.wat -o output.wasm
wasm-validate output.wasm
```

**Output**: `.wat` file (textual WebAssembly S-expressions).

**Requirements**: Python 3.14+ to generate WAT; [`wat2wasm`](https://github.com/WebAssembly/wabt) to convert into binary.

---

## 4. WebAssembly Binary (`--target wasm`)

Directly compiles the program into WebAssembly binary bytecode (`.wasm`).

```powershell
python -m flux_proto.cli flux/program.flux --target wasm -o output
```

Generates `output.wasm`. To validate the binary:

```powershell
wasm-validate output.wasm
```

To execute via WASI:

```powershell
wasmer run output.wasm
```

**Output**: `.wasm` file (WebAssembly binary).

**Requirements**: Python 3.14+ to generate WASM; [wasmer](https://wasmer.io) or any WASI-compliant WASM runtime to execute; [`wasm-validate`](https://github.com/WebAssembly/wabt) to validate.

---

## 5. LLVM / Native (`--target llvm`)

Compiles the program into native machine code via LLVM, generating a standalone `.exe` binary.

```powershell
python -m flux_proto.cli flux/program.flux --target llvm -o output
```

Generates `output.ll` (LLVM Intermediate Representation) and compiles it via Clang into `output.exe` (native executable).

The internal compilation pipeline is:
1. Emits LLVM IR (`.ll`)
2. Invokes `clang` with the runtime support library (`flux_input.c`) to generate the native binary (`.exe` on Windows).

**Output**: `.ll` and `.exe` files.

**Requirements**: Python 3.14+, [LLVM/clang](https://clang.llvm.org/) on PATH.

---

## Debugging and Emission Flags

The compiler provides `--emit-*` flags to inspect intermediate compiler representations without modifying the final target output:

| Flag | Artifact Emitted | Directory |
|------|-----------------|-----------|
| `--emit-lexer` | Token stream (JSON) | `intermediates/lexer/` |
| `--emit-ast` | Abstract Syntax Tree (JSON) | `intermediates/ast/` |
| `--emit-wat` | Intermediate WAT | `intermediates/wat/` |
| `--emit-llvm` | Intermediate LLVM IR | `intermediates/llvm/` |

Example:

```powershell
python -m flux_proto.cli flux/hello.flux --target run --emit-ast --emit-wat
```

Generates `intermediates/ast/hello.json` and `intermediates/wat/hello.wat` while simultaneously executing the program.

---

## Comprehensive Example

Source file `flux/sum.flux`:

```theflux
let A: int64 = 10
let B: int64 = 20
print(A + B)
```

```powershell
# Direct execution via interpreter
python -m flux_proto.cli flux/sum.flux --target run
# output: 30

# Compile to bytecode
python -m flux_proto.cli flux/sum.flux --target vmbc -o build/sum

# Compile to WAT
python -m flux_proto.cli flux/sum.flux --target wat -o build/sum

# Compile to WASM
python -m flux_proto.cli flux/sum.flux --target wasm -o build/sum

# Compile to native executable
python -m flux_proto.cli flux/sum.flux --target llvm -o build/sum
# Generates build/sum.exe

# With intermediate debugging emission
python -m flux_proto.cli flux/sum.flux --target run --emit-ast --emit-lexer
```

---

## Internal Pipeline Architecture

1. **Input Reading & Resolution**: Source file read as UTF-8 (or modular library directory resolved to `<Dir>/<Dir>.fdsl`).
2. **Lexer**: `flux_proto.lexer.lexer.lex()` — tokenizes the source into structured tokens.
3. **Parser**: `flux_proto.parser.parser.parse()` — builds the AST (`FluxProgram` or `FdslFile`).
4. **Import Resolution & Transparent Merging**: `flux_proto.parser.import_resolver.resolve_imports()`:
   - Resolves modular canonical directories (`stdlib/<Name>StdLib/`).
   - Reads the declarative `use` manifest of the master aggregator file and transparently merges `ops`, `contracts`, `storages`, `structs`, and `enums`.
   - Strict isolation against undeclared files (foreign/scratch files are ignored) and typo detection.
   - Registers multi-segment hierarchical paths (`<Lib>::<Domain>::<op>`).
5. **Semantic Analysis**: `flux_proto.semantic.analyze()` — validates types, scopes, contract compliance (`impl`), mutability, and ownership.
6. **Target Dispatch**:
   - `run` → `flux_proto.interpreter.interpreter.interpret()`
   - `vmbc` → `flux_proto.vm.compiler.compile_to_bytecode()` + runtime
   - `wat` → `flux_proto.wat.codegen.generate_wat()`
   - `wasm` → `flux_proto.wasm.codegen.generate_wasm()`
   - `llvm` → `flux_proto.llvm.codegen.generate_llvm()` + clang

All stages following source reading reside in `src/flux_proto/`. The semantic analyzer is unified and shared across all 5 targets — no target-specific validation forks exist.

---

## Modular Standard Libraries (`stdlib/<Name>StdLib/`)

TheFlux compilation suite provides first-class native support for modular standard libraries organized in flat folders under `stdlib/` according to the canonical specification in [`docs/en/StdLibs.md`](StdLibs.md).

### Compiling or Inspecting a Modular Library Directly
The CLI accepts both the library directory path or the master aggregator file:

```powershell
# Inspect the complete merged AST (with all contracts and operations):
python -m flux_proto.cli stdlib/MathStdLib --emit-ast

# Validate complete semantics of all library modules:
python -m flux_proto.cli stdlib/MathStdLib/MathStdLib.fdsl
```

### Multi-Backend Compliance Validation
The official test harness `backend_compliance.py` verifies programs consuming modular libraries across all 6 backends:

```powershell
# Validate all modular library test suites:
python backend_compliance.py --modular

# Validate a specific test or domain:
python backend_compliance.py ExampleOfUseMathStdLib_TrigonometryContract
```

---

## String ABI by Target

Internal string representations differ across backends per the `fat-pointer-representation` architecture:

| Target | Representation | Length Storage | Internal NUL Support |
| :--- | :--- | :--- | :--- |
| **in / vm / vmr** | `str` / native object | Native | Yes |
| **wasm / wat** | Fat pointer `i64` = `(ptr << 32) \| len` | In fat pointer (unpack via `shr_u 32` / `wrap`) | Yes |
| **llvm** | `i8*` C-string + `printf %s` | `strlen` / `snprintf` (runtime) | No (truncates at first NUL) |

Strings are UTF-8 encoded across all targets: `len()` (and capacity `string(N)`) count UTF-8 bytes, and `\u{XXXX}` in source code decodes the code point into its UTF-8 bytes.

## Char ABI (UTF-32)

`char` represents exactly one Unicode code point (U+0000..U+10FFFF) and is stored as a 32-bit value (UTF-32) across all compiled targets:

| Target | Representation | UTF-8 Conversion |
| :--- | :--- | :--- |
| **in / vm** | 1-code-point `str` / `_Chr(cp)` (int) | `chr()` on print |
| **wasm / wat** | `i32` code point | `$encode_utf8` on print/concat |
| **llvm** | `i32` code point | `flux_char_to_utf8` on print/concat |

Conversion to UTF-8 (1–4 bytes) occurs exclusively during print output or string concatenation; the in-memory value is always the 32-bit code point.

### WASM: Fat Pointer (`u64`)

All strings in storages, locals, list/set rows (tag 4), parameters, and user function returns are loaded as `i64`:
- `fat = (u64(ptr) << 32) | u64(len)`; `ptr = u32(fat >> 32)`; `len = u32(fat)`.
- Literals compile with constant `len` (`_alloc_str` side-table); concatenation and interpolation compute the new length dynamically.
- `$print_str(ptr, len)` receives the unpacked pair — the WASI `fd_write` shim (`iovec (ptr, len)` in `(i32, i32)`) remains unmodified.

### External Boundary (JS Bridge)

The WASM module exports only `memory` and `_start`; no direct string exports exist. If future exports return strings, the ABI format is the `u64` fat pointer: `hi32 = ptr`, `lo32 = len` — decoded via `decodeFatString` (see `web_wasm/index.html`).

### Documented LLVM Boundary

`i8*` + `printf %s` does not carry explicit length: strings containing embedded NUL characters truncate during printing. Parity is preserved across existing test suites; literal concatenation uses `malloc` + `memcpy` with length from `IRWriter` side-tables.
