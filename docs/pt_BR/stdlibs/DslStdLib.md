# 📚 `DslStdLib` — Compilação, Análise Léxica, Parsing e Execução de DSLs

> **Pilar Arquitetural**: Pilar 1 (Núcleo, Texto & OO)  
> **Status**: ✅ Homologado com 100% de Paridade nos 6 Backends (`in`, `vm`, `vmr`, `llvm`, `wat`, `wasm`)  
> **Arquivo Mestre**: `stdlib/DslStdLib/DslStdLib.fdsl`  
> **Modo de Importação**: `use DslStdLib` ou `use DslStdLib::<Modulo>::<operacao>`

---

## 1. Visão Geral e Funcionalidades

A biblioteca padrão **`DslStdLib`** integra o ecossistema oficial da linguagem TheFlux, fornecendo suporte de nível de sistema e algoritmos nativos certificados.

Infraestrutura nativa para criação de linguagens de domínio específico (DSLs) acopladas ao TheFlux: tokenizadores configuráveis, construção e validação de árvores sintáticas abstratas (AST), montador de bytecode e máquina de execução isolada.

### 1.1 Características e Princípios de Design
- **Compilação e Fusão Estática**: Todos os módulos de domínio são fundidos no agente unificado `DslStdLib` em tempo de compilação, sem sobrecarga (*overhead*) de despacho indireto.
- **Isolamento e Segurança**: As operações verificam limites operacionais e utilizam despacho por contratos formais rigorosos.
- **Compatibilidade Multi-Backend**: Execução bit-a-bit idêntica em interpretador (`in`), bytecode (`vm`, `vmr`), nativo AOT (`llvm`) e WebAssembly (`wat`, `wasm`).

---

## 2. Estrutura Modular e Contratos

A biblioteca é composta por **6 módulos de domínio** e declara **21 operações públicas**:

| Arquivo de Domínio | Contrato Formal | Responsabilidade Principal | Qtd. Ops |
|---|---|---|:---:|
| `DslAsm.fdsl` | `DslAsmContract` | Domínio especializado de `DslAsm` | 5 |
| `DslAst.fdsl` | `DslAstContract` | Domínio especializado de `DslAst` | 4 |
| `DslExecution.fdsl` | `DslExecutionContract` | Domínio especializado de `DslExecution` | 2 |
| `DslLexer.fdsl` | `DslLexerContract` | Domínio especializado de `DslLexer` | 3 |
| `DslParser.fdsl` | `DslParserContract` | Domínio especializado de `DslParser` | 4 |
| `DslSandbox.fdsl` | `DslSandboxContract` | Domínio especializado de `DslSandbox` | 3 |

---

## 3. Tipos, Estruturas e Enumerações Públicas

A biblioteca `DslStdLib` opera diretamente com os tipos nativos e primitivos da linguagem TheFlux (`string`, `int64`, `float64`, `bool`, `list of data`, etc.), sem exigir tipos compostos adicionais.

---

## 4. Catálogo Detalhado de Operações por Domínio

### 4.1 Contrato `DslAsmContract` (`DslAsm.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `dslGetAsmEngine` | `op dslGetAsmEngine (as string: architecture) as data` | `data` |
| `dslAsmAssemble` | `op dslAsmAssemble (as data: asm_engine, as string: asm_code) as list of int64` | `list of int64` |
| `dslAsmDisassemble` | `op dslAsmDisassemble (as data: asm_engine, as list of int64: machine_code) as string` | `string` |
| `dslAsmValidateRegisters` | `op dslAsmValidateRegisters (as data: asm_engine, as list of string: registers) as bool` | `bool` |
| `dslAsmGetRegisterMap` | `op dslAsmGetRegisterMap (as data: asm_engine) as map` | `map` |

#### Ficha Técnica das Operações:

##### `op dslGetAsmEngine`
```flux
op dslGetAsmEngine (as string: architecture) as data
```
- **Parâmetros**:
  - `architecture` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dslGetAsmEngine` no domínio `DslAsmContract`.

##### `op dslAsmAssemble`
```flux
op dslAsmAssemble (as data: asm_engine, as string: asm_code) as list of int64
```
- **Parâmetros**:
  - `asm_engine` (`data`): Parâmetro de entrada para processamento da operação.
  - `asm_code` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of int64`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dslAsmAssemble` no domínio `DslAsmContract`.

##### `op dslAsmDisassemble`
```flux
op dslAsmDisassemble (as data: asm_engine, as list of int64: machine_code) as string
```
- **Parâmetros**:
  - `asm_engine` (`data`): Parâmetro de entrada para processamento da operação.
  - `machine_code` (`list of int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dslAsmDisassemble` no domínio `DslAsmContract`.

##### `op dslAsmValidateRegisters`
```flux
op dslAsmValidateRegisters (as data: asm_engine, as list of string: registers) as bool
```
- **Parâmetros**:
  - `asm_engine` (`data`): Parâmetro de entrada para processamento da operação.
  - `registers` (`list of string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dslAsmValidateRegisters` no domínio `DslAsmContract`.

##### `op dslAsmGetRegisterMap`
```flux
op dslAsmGetRegisterMap (as data: asm_engine) as map
```
- **Parâmetros**:
  - `asm_engine` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dslAsmGetRegisterMap` no domínio `DslAsmContract`.

### 4.2 Contrato `DslAstContract` (`DslAst.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `dslGenerateAst` | `op dslGenerateAst (as data: parser, as string: dsl_code) as map` | `map` |
| `dslDumpAst` | `op dslDumpAst (as map: ast) as string` | `string` |
| `dslFindAstNodes` | `op dslFindAstNodes (as map: ast, as string: node_type) as list of data` | `list of data` |
| `dslTransformAst` | `op dslTransformAst (as map: ast, as map: transform_rules) as map` | `map` |

#### Ficha Técnica das Operações:

##### `op dslGenerateAst`
```flux
op dslGenerateAst (as data: parser, as string: dsl_code) as map
```
- **Parâmetros**:
  - `parser` (`data`): Parâmetro de entrada para processamento da operação.
  - `dsl_code` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dslGenerateAst` no domínio `DslAstContract`.

##### `op dslDumpAst`
```flux
op dslDumpAst (as map: ast) as string
```
- **Parâmetros**:
  - `ast` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dslDumpAst` no domínio `DslAstContract`.

##### `op dslFindAstNodes`
```flux
op dslFindAstNodes (as map: ast, as string: node_type) as list of data
```
- **Parâmetros**:
  - `ast` (`map`): Parâmetro de entrada para processamento da operação.
  - `node_type` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dslFindAstNodes` no domínio `DslAstContract`.

##### `op dslTransformAst`
```flux
op dslTransformAst (as map: ast, as map: transform_rules) as map
```
- **Parâmetros**:
  - `ast` (`map`): Parâmetro de entrada para processamento da operação.
  - `transform_rules` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `map`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dslTransformAst` no domínio `DslAstContract`.

### 4.3 Contrato `DslExecutionContract` (`DslExecution.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `dslCompile` | `op dslCompile (as map: ast, as string: target_end) as data` | `data` |
| `dslExecuteInline` | `op dslExecuteInline (as data: parser, as string: dsl_code, mut as data: context) as data` | `data` |

#### Ficha Técnica das Operações:

##### `op dslCompile`
```flux
op dslCompile (as map: ast, as string: target_end) as data
```
- **Parâmetros**:
  - `ast` (`map`): Parâmetro de entrada para processamento da operação.
  - `target_end` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dslCompile` no domínio `DslExecutionContract`.

##### `op dslExecuteInline`
```flux
op dslExecuteInline (as data: parser, as string: dsl_code, mut as data: context) as data
```
- **Parâmetros**:
  - `parser` (`data`): Parâmetro de entrada para processamento da operação.
  - `dsl_code` (`string`): Parâmetro de entrada para processamento da operação.
  - `context` (`mut data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dslExecuteInline` no domínio `DslExecutionContract`.

### 4.4 Contrato `DslLexerContract` (`DslLexer.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `dslCreateLexer` | `op dslCreateLexer (as map: tokens_regex) as data` | `data` |
| `dslTokenize` | `op dslTokenize (as data: lexer, as string: dsl_code) as list of data` | `list of data` |
| `dslGetLexerTokens` | `op dslGetLexerTokens (as data: lexer) as list of string` | `list of string` |

#### Ficha Técnica das Operações:

##### `op dslCreateLexer`
```flux
op dslCreateLexer (as map: tokens_regex) as data
```
- **Parâmetros**:
  - `tokens_regex` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dslCreateLexer` no domínio `DslLexerContract`.

##### `op dslTokenize`
```flux
op dslTokenize (as data: lexer, as string: dsl_code) as list of data
```
- **Parâmetros**:
  - `lexer` (`data`): Parâmetro de entrada para processamento da operação.
  - `dsl_code` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dslTokenize` no domínio `DslLexerContract`.

##### `op dslGetLexerTokens`
```flux
op dslGetLexerTokens (as data: lexer) as list of string
```
- **Parâmetros**:
  - `lexer` (`data`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dslGetLexerTokens` no domínio `DslLexerContract`.

### 4.5 Contrato `DslParserContract` (`DslParser.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `dslCreateParser` | `op dslCreateParser (as data: lexer, as map: grammar_rules) as data` | `data` |
| `dslIsValidSyntax` | `op dslIsValidSyntax (as data: parser, as string: dsl_code) as bool` | `bool` |
| `dslGetErrors` | `op dslGetErrors (as data: parser, as string: dsl_code) as list of data` | `list of data` |
| `dslFormatErrors` | `op dslFormatErrors (as list of data: errors, as string: dsl_code) as string` | `string` |

#### Ficha Técnica das Operações:

##### `op dslCreateParser`
```flux
op dslCreateParser (as data: lexer, as map: grammar_rules) as data
```
- **Parâmetros**:
  - `lexer` (`data`): Parâmetro de entrada para processamento da operação.
  - `grammar_rules` (`map`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dslCreateParser` no domínio `DslParserContract`.

##### `op dslIsValidSyntax`
```flux
op dslIsValidSyntax (as data: parser, as string: dsl_code) as bool
```
- **Parâmetros**:
  - `parser` (`data`): Parâmetro de entrada para processamento da operação.
  - `dsl_code` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dslIsValidSyntax` no domínio `DslParserContract`.

##### `op dslGetErrors`
```flux
op dslGetErrors (as data: parser, as string: dsl_code) as list of data
```
- **Parâmetros**:
  - `parser` (`data`): Parâmetro de entrada para processamento da operação.
  - `dsl_code` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `list of data`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dslGetErrors` no domínio `DslParserContract`.

##### `op dslFormatErrors`
```flux
op dslFormatErrors (as list of data: errors, as string: dsl_code) as string
```
- **Parâmetros**:
  - `errors` (`list of data`): Parâmetro de entrada para processamento da operação.
  - `dsl_code` (`string`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `string`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dslFormatErrors` no domínio `DslParserContract`.

### 4.6 Contrato `DslSandboxContract` (`DslSandbox.fdsl`)

| Operação | Assinatura | Retorno |
|---|---|---|
| `dslSetTimeout` | `op dslSetTimeout (mut as data: engine, as int64: timeout_ms) as bool` | `bool` |
| `dslSetInstructionLimit` | `op dslSetInstructionLimit (mut as data: engine, as int64: max_instructions) as bool` | `bool` |
| `dslSetMemoryLimit` | `op dslSetMemoryLimit (mut as data: engine, as int64: max_bytes) as bool` | `bool` |

#### Ficha Técnica das Operações:

##### `op dslSetTimeout`
```flux
op dslSetTimeout (mut as data: engine, as int64: timeout_ms) as bool
```
- **Parâmetros**:
  - `engine` (`mut data`): Parâmetro de entrada para processamento da operação.
  - `timeout_ms` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dslSetTimeout` no domínio `DslSandboxContract`.

##### `op dslSetInstructionLimit`
```flux
op dslSetInstructionLimit (mut as data: engine, as int64: max_instructions) as bool
```
- **Parâmetros**:
  - `engine` (`mut data`): Parâmetro de entrada para processamento da operação.
  - `max_instructions` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dslSetInstructionLimit` no domínio `DslSandboxContract`.

##### `op dslSetMemoryLimit`
```flux
op dslSetMemoryLimit (mut as data: engine, as int64: max_bytes) as bool
```
- **Parâmetros**:
  - `engine` (`mut data`): Parâmetro de entrada para processamento da operação.
  - `max_bytes` (`int64`): Parâmetro de entrada para processamento da operação.
- **Retorno e Emissão**:
  - Tipo de dado: `bool`
  - ✅ Emite `nice` com status `"ok"`
- **Descrição Funcional**:
  - Executa a funcionalidade canônica de `dslSetMemoryLimit` no domínio `DslSandboxContract`.

---

## 5. Exemplos Canônicos de Uso em TheFlux

O exemplo a seguir demonstra a importação e o consumo prático da biblioteca:

```flux
# Exemplo Canônico de Consumo da DslStdLib
use DslStdLib

program (ExemploDslStdLib) {
      println("==================================================")
      println("  Demonstracao da Standard Library: DslStdLib")
      println("==================================================")

      # Chamada da operacao canônica
      mut as data: resultado = DslStdLib::dslLex("x = 1 + 2")
      println("Resultado obtido: " + resultado)

      println("Demonstracao concluida com sucesso.")
}
```

---

> [!TIP]
> Para consultar a visão arquitetural unificada de todas as bibliotecas, consulte o documento principal [StdLibs.md](../StdLibs.md).
