# 📚 `DslStdLib` — DSL Compilation, Lexing, AST Parsing, and Secure Execution

> **Architectural Pillar**: Pillar 1 (Core, Text & OO)  
> **Status**: ✅ Certified with 100% Parity across 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Master File**: `stdlib/DslStdLib/DslStdLib.fdsl`  
> **Import Mode**: `use DslStdLib` or `use DslStdLib::<Module>::<operation>`

---

## 1. Overview and Capabilities

The **`DslStdLib`** standard library is an integral component of the official TheFlux language ecosystem, providing certified system-level algorithms and robust capabilities.

Domain-Specific Language (DSL) construction toolkit for TheFlux: configurable tokenizers, AST building and structural validation, intermediate bytecode assembler, and sandboxed bytecode execution engines.

### 1.1 Key Architectural Principles and Design
- **Static Fusion and Zero-Overhead**: All domain modules are transparently fused into the `DslStdLib` unified agent at compile time, avoiding virtual dispatch penalties.
- **Safety and Isolation**: Operations strictly validate parameter bounds and guarantee predictable error semantics via contract definitions.
- **Universal Multi-Backend Parity**: Bit-for-bit identical execution guarantees across interpreter (`in`), bytecode VM (`vm`, `vmr`), native AOT LLVM (`llvm`), and WebAssembly (`wat`, `wasm`).

---

## 2. Modular Structure and Contracts

The library comprises **6 domain modules** declaring a total of **21 public operations**:

| Domain Source File | Formal Contract | Domain Responsibility | Ops Count |
|---|---|---|:---:|
| `DslAsm.fdsl` | `DslAsmContract` | Specialized domain for `DslAsm` | 5 |
| `DslAst.fdsl` | `DslAstContract` | Specialized domain for `DslAst` | 4 |
| `DslExecution.fdsl` | `DslExecutionContract` | Specialized domain for `DslExecution` | 2 |
| `DslLexer.fdsl` | `DslLexerContract` | Specialized domain for `DslLexer` | 3 |
| `DslParser.fdsl` | `DslParserContract` | Specialized domain for `DslParser` | 4 |
| `DslSandbox.fdsl` | `DslSandboxContract` | Specialized domain for `DslSandbox` | 3 |

---

## 3. Public Types, Structures, and Enumerations

The `DslStdLib` library operates directly on primitive native TheFlux types (`string`, `int64`, `float64`, `bool`, `list of data`, etc.) without requiring custom composite types.

---

## 4. Detailed Operations Catalog by Domain

### 4.1 Contract `DslAsmContract` (`DslAsm.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `dslGetAsmEngine` | `op dslGetAsmEngine (as string: architecture) as data` | `data` |
| `dslAsmAssemble` | `op dslAsmAssemble (as data: asm_engine, as string: asm_code) as list of int64` | `list of int64` |
| `dslAsmDisassemble` | `op dslAsmDisassemble (as data: asm_engine, as list of int64: machine_code) as string` | `string` |
| `dslAsmValidateRegisters` | `op dslAsmValidateRegisters (as data: asm_engine, as list of string: registers) as bool` | `bool` |
| `dslAsmGetRegisterMap` | `op dslAsmGetRegisterMap (as data: asm_engine) as map` | `map` |

#### Operation Technical Specifications:

##### `op dslGetAsmEngine`
```flux
op dslGetAsmEngine (as string: architecture) as data
```
- **Parameters**:
  - `architecture` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dslGetAsmEngine` functionality within the `DslAsmContract` domain.

##### `op dslAsmAssemble`
```flux
op dslAsmAssemble (as data: asm_engine, as string: asm_code) as list of int64
```
- **Parameters**:
  - `asm_engine` (`data`): Input argument for operation execution.
  - `asm_code` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of int64`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dslAsmAssemble` functionality within the `DslAsmContract` domain.

##### `op dslAsmDisassemble`
```flux
op dslAsmDisassemble (as data: asm_engine, as list of int64: machine_code) as string
```
- **Parameters**:
  - `asm_engine` (`data`): Input argument for operation execution.
  - `machine_code` (`list of int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dslAsmDisassemble` functionality within the `DslAsmContract` domain.

##### `op dslAsmValidateRegisters`
```flux
op dslAsmValidateRegisters (as data: asm_engine, as list of string: registers) as bool
```
- **Parameters**:
  - `asm_engine` (`data`): Input argument for operation execution.
  - `registers` (`list of string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dslAsmValidateRegisters` functionality within the `DslAsmContract` domain.

##### `op dslAsmGetRegisterMap`
```flux
op dslAsmGetRegisterMap (as data: asm_engine) as map
```
- **Parameters**:
  - `asm_engine` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dslAsmGetRegisterMap` functionality within the `DslAsmContract` domain.

### 4.2 Contract `DslAstContract` (`DslAst.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `dslGenerateAst` | `op dslGenerateAst (as data: parser, as string: dsl_code) as map` | `map` |
| `dslDumpAst` | `op dslDumpAst (as map: ast) as string` | `string` |
| `dslFindAstNodes` | `op dslFindAstNodes (as map: ast, as string: node_type) as list of data` | `list of data` |
| `dslTransformAst` | `op dslTransformAst (as map: ast, as map: transform_rules) as map` | `map` |

#### Operation Technical Specifications:

##### `op dslGenerateAst`
```flux
op dslGenerateAst (as data: parser, as string: dsl_code) as map
```
- **Parameters**:
  - `parser` (`data`): Input argument for operation execution.
  - `dsl_code` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dslGenerateAst` functionality within the `DslAstContract` domain.

##### `op dslDumpAst`
```flux
op dslDumpAst (as map: ast) as string
```
- **Parameters**:
  - `ast` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dslDumpAst` functionality within the `DslAstContract` domain.

##### `op dslFindAstNodes`
```flux
op dslFindAstNodes (as map: ast, as string: node_type) as list of data
```
- **Parameters**:
  - `ast` (`map`): Input argument for operation execution.
  - `node_type` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dslFindAstNodes` functionality within the `DslAstContract` domain.

##### `op dslTransformAst`
```flux
op dslTransformAst (as map: ast, as map: transform_rules) as map
```
- **Parameters**:
  - `ast` (`map`): Input argument for operation execution.
  - `transform_rules` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `map`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dslTransformAst` functionality within the `DslAstContract` domain.

### 4.3 Contract `DslExecutionContract` (`DslExecution.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `dslCompile` | `op dslCompile (as map: ast, as string: target_end) as data` | `data` |
| `dslExecuteInline` | `op dslExecuteInline (as data: parser, as string: dsl_code, mut as data: context) as data` | `data` |

#### Operation Technical Specifications:

##### `op dslCompile`
```flux
op dslCompile (as map: ast, as string: target_end) as data
```
- **Parameters**:
  - `ast` (`map`): Input argument for operation execution.
  - `target_end` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dslCompile` functionality within the `DslExecutionContract` domain.

##### `op dslExecuteInline`
```flux
op dslExecuteInline (as data: parser, as string: dsl_code, mut as data: context) as data
```
- **Parameters**:
  - `parser` (`data`): Input argument for operation execution.
  - `dsl_code` (`string`): Input argument for operation execution.
  - `context` (`mut data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dslExecuteInline` functionality within the `DslExecutionContract` domain.

### 4.4 Contract `DslLexerContract` (`DslLexer.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `dslCreateLexer` | `op dslCreateLexer (as map: tokens_regex) as data` | `data` |
| `dslTokenize` | `op dslTokenize (as data: lexer, as string: dsl_code) as list of data` | `list of data` |
| `dslGetLexerTokens` | `op dslGetLexerTokens (as data: lexer) as list of string` | `list of string` |

#### Operation Technical Specifications:

##### `op dslCreateLexer`
```flux
op dslCreateLexer (as map: tokens_regex) as data
```
- **Parameters**:
  - `tokens_regex` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dslCreateLexer` functionality within the `DslLexerContract` domain.

##### `op dslTokenize`
```flux
op dslTokenize (as data: lexer, as string: dsl_code) as list of data
```
- **Parameters**:
  - `lexer` (`data`): Input argument for operation execution.
  - `dsl_code` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dslTokenize` functionality within the `DslLexerContract` domain.

##### `op dslGetLexerTokens`
```flux
op dslGetLexerTokens (as data: lexer) as list of string
```
- **Parameters**:
  - `lexer` (`data`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dslGetLexerTokens` functionality within the `DslLexerContract` domain.

### 4.5 Contract `DslParserContract` (`DslParser.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `dslCreateParser` | `op dslCreateParser (as data: lexer, as map: grammar_rules) as data` | `data` |
| `dslIsValidSyntax` | `op dslIsValidSyntax (as data: parser, as string: dsl_code) as bool` | `bool` |
| `dslGetErrors` | `op dslGetErrors (as data: parser, as string: dsl_code) as list of data` | `list of data` |
| `dslFormatErrors` | `op dslFormatErrors (as list of data: errors, as string: dsl_code) as string` | `string` |

#### Operation Technical Specifications:

##### `op dslCreateParser`
```flux
op dslCreateParser (as data: lexer, as map: grammar_rules) as data
```
- **Parameters**:
  - `lexer` (`data`): Input argument for operation execution.
  - `grammar_rules` (`map`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dslCreateParser` functionality within the `DslParserContract` domain.

##### `op dslIsValidSyntax`
```flux
op dslIsValidSyntax (as data: parser, as string: dsl_code) as bool
```
- **Parameters**:
  - `parser` (`data`): Input argument for operation execution.
  - `dsl_code` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dslIsValidSyntax` functionality within the `DslParserContract` domain.

##### `op dslGetErrors`
```flux
op dslGetErrors (as data: parser, as string: dsl_code) as list of data
```
- **Parameters**:
  - `parser` (`data`): Input argument for operation execution.
  - `dsl_code` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `list of data`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dslGetErrors` functionality within the `DslParserContract` domain.

##### `op dslFormatErrors`
```flux
op dslFormatErrors (as list of data: errors, as string: dsl_code) as string
```
- **Parameters**:
  - `errors` (`list of data`): Input argument for operation execution.
  - `dsl_code` (`string`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `string`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dslFormatErrors` functionality within the `DslParserContract` domain.

### 4.6 Contract `DslSandboxContract` (`DslSandbox.fdsl`)

| Operation | Formal Signature | Return Type |
|---|---|---|
| `dslSetTimeout` | `op dslSetTimeout (mut as data: engine, as int64: timeout_ms) as bool` | `bool` |
| `dslSetInstructionLimit` | `op dslSetInstructionLimit (mut as data: engine, as int64: max_instructions) as bool` | `bool` |
| `dslSetMemoryLimit` | `op dslSetMemoryLimit (mut as data: engine, as int64: max_bytes) as bool` | `bool` |

#### Operation Technical Specifications:

##### `op dslSetTimeout`
```flux
op dslSetTimeout (mut as data: engine, as int64: timeout_ms) as bool
```
- **Parameters**:
  - `engine` (`mut data`): Input argument for operation execution.
  - `timeout_ms` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dslSetTimeout` functionality within the `DslSandboxContract` domain.

##### `op dslSetInstructionLimit`
```flux
op dslSetInstructionLimit (mut as data: engine, as int64: max_instructions) as bool
```
- **Parameters**:
  - `engine` (`mut data`): Input argument for operation execution.
  - `max_instructions` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dslSetInstructionLimit` functionality within the `DslSandboxContract` domain.

##### `op dslSetMemoryLimit`
```flux
op dslSetMemoryLimit (mut as data: engine, as int64: max_bytes) as bool
```
- **Parameters**:
  - `engine` (`mut data`): Input argument for operation execution.
  - `max_bytes` (`int64`): Input argument for operation execution.
- **Return and Emission**:
  - Return data type: `bool`
  - ✅ Emits `nice` with status message `"ok"`
- **Functional Description**:
  - Executes canonical `dslSetMemoryLimit` functionality within the `DslSandboxContract` domain.

---

## 5. Canonical Usage Examples in TheFlux

The following snippet illustrates importing and utilizing the library in a TheFlux program:

```flux
# Canonical Usage Example for DslStdLib
use DslStdLib

program (ExampleOfDslStdLib) {
      println("==================================================")
      println("  Standard Library Demonstration: DslStdLib")
      println("==================================================")

      # Invoking canonical operation
      mut as data: result = DslStdLib::dslLex("x = 1 + 2")
      println("Obtained result: " + result)

      println("Execution completed successfully.")
}
```

---

> [!TIP]
> For the complete unified architecture across all standard libraries, consult the master [StdLibs.md](../StdLibs.md) reference.
