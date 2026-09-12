# Compilação e Execução — TheFlux

## Visão Geral

Um arquivo `.flux` (ou `.fdsl`) passa por quatro fases até virar saída:

```text
Código Fonte (.flux/.fdsl)
    │
    ▼
┌──────────────────────┐
│  Fase 1: LEXER       │  --emit-lexer
│  (analisador léxico) │
└──────────────────────┘
    │
    ▼
┌──────────────────────┐
│  Fase 2: PARSER      │  --emit-ast
│  (analisador sintaxe)│
└──────────────────────┘
    │
    ▼
┌──────────────────────┐
│  Fase 3: SEMANTIC    │  --emit-semantic
│  (validação semantica)│
└──────────────────────┘
    │
    ┌──────────┬──────────┬──────────┬──────────┐
    ▼          ▼          ▼          ▼          ▼
┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐ ┌──────────┐
│   RUN  │ │  VMBC  │ │   WAT  │ │  WASM  │ │   LLVM   │
│--target│ │--target│ │--target│ │--target│ │--target  │
│  run   │ │  vmbc  │ │  wat   │ │  wasm  │ │  llvm    │
└────────┘ └────────┘ └────────┘ └────────┘ └──────────┘
    ▼          ▼          ▼          ▼          ▼
 stdout    .fvmbc      .wat       .wasm       .exe
 (tela)   (bytecode)  (texto)    (binário)  (nativo)
```

## Uso Básico

Todos os modos usam o mesmo comando `python -m flux_proto.cli`:

```powershell
python -m flux_proto.cli <arquivo> [--target <modo>] [--output <caminho>] [flags]
```

---

## 1. Interpretador (`--target run`)

Executa o programa imediatamente e mostra a saída no terminal.

```powershell
python -m flux_proto.cli flux/hello.flux --target run
```

**Saída**: texto no `stdout` (não gera arquivo).

**Exemplo** (`flux/hello.flux`):

```flux
print("Ola, TheFlux!")
let X: int64 = 42
print(X)
```

```powershell
python -m flux_proto.cli flux/hello.flux --target run
# Ola, TheFlux!
# 42
```

**Requisitos**: nenhum — apenas Python 3.14+.

---

## 2. Bytecode VM (`--target vmbc`)

Compila o programa para bytecode `.fvmbc` (JSON) executável pela máquina virtual.

```powershell
python -m flux_proto.cli flux/programa.flux --target vmbc -o saida
```

Gera `saida.fvmbc` com o bytecode em formato JSON. O bytecode pode ser carregado
e executado pelo runtime da VM (`flux_proto.vm.runtime`).

**Saída**: arquivo `.fvmbc` (JSON).

**Requisitos**: Python 3.14+ (a VM é implementada em Python puro).

---

## 3. WebAssembly Texto (`--target wat`)

Compila o programa para o formato texto de WebAssembly (`.wat`), legível por humanos.

```powershell
python -m flux_proto.cli flux/programa.flux --target wat -o saida
```

Gera `saida.wat`. Para converter em binário `.wasm`:

```powershell
wat2wasm saida.wat -o saida.wasm
wasm-validate saida.wasm
```

**Saída**: arquivo `.wat` (textual WAT).

**Requisitos**: Python 3.14+ para gerar WAT;
[`wat2wasm`](https://github.com/WebAssembly/wabt) para converter em binário.

---

## 4. WebAssembly Binário (`--target wasm`)

Compila o programa diretamente para WebAssembly binário (`.wasm`).

```powershell
python -m flux_proto.cli flux/programa.flux --target wasm -o saida
```

Gera `saida.wasm`. Para validar:

```powershell
wasm-validate saida.wasm
```

Para executar:

```powershell
wasmer run saida.wasm
```

**Saída**: arquivo `.wasm` (binário WebAssembly).

**Requisitos**: Python 3.14+ para gerar WASM;
[wasmer](https://wasmer.io) ou outro runtime WASM para executar;
[`wasm-validate`](https://github.com/WebAssembly/wabt) para validar o binário.

---

## 5. LLVM / Nativo (`--target llvm`)

Compila o programa para código nativo via LLVM, gerando um executável `.exe`.

```powershell
python -m flux_proto.cli flux/programa.flux --target llvm -o saida
```

Gera `saida.ll` (LLVM IR) e `saida.exe` (executável nativo via clang).

O pipeline interno é:

1. Gera LLVM IR (`.ll`)
2. Compila com `clang` para executável nativo (`.exe` no Windows)

**Saída**: arquivos `.ll` e `.exe`.

**Requisitos**: Python 3.14+, [LLVM/clang](https://clang.llvm.org/) no PATH.

---

## Flags de Depuração

O compilador oferece flags `--emit-*` para inspecionar fases intermediárias sem
alterar a saída final:

| Flag | O que gera | Pasta |
|------|-----------|-------|
| `--emit-lexer` | Token stream (JSON) | `intermediates/lexer/` |
| `--emit-ast` | Árvore abstrata (JSON) | `intermediates/ast/` |
| `--emit-wat` | WAT intermediário | `intermediates/wat/` |
| `--emit-llvm` | LLVM IR intermediário | `intermediates/llvm/` |

Exemplo:

```powershell
python -m flux_proto.cli flux/hello.flux --target run --emit-ast --emit-wat
```

Gera `intermediates/ast/hello.json` e `intermediates/wat/hello.wat` além de
executar o programa.

---

## Exemplo Completo

Arquivo `flux/soma.flux`:

```flux
let A: int64 = 10
let B: int64 = 20
print(A + B)
```

```powershell
# Executar direto
python -m flux_proto.cli flux/soma.flux --target run
# saída: 30

# Compilar para bytecode
python -m flux_proto.cli flux/soma.flux --target vmbc -o build/soma

# Compilar para WAT
python -m flux_proto.cli flux/soma.flux --target wat -o build/soma

# Compilar para WASM
python -m flux_proto.cli flux/soma.flux --target wasm -o build/soma

# Compilar para executável nativo
python -m flux_proto.cli flux/soma.flux --target llvm -o build/soma
# Gera build/soma.exe

# Com depuração
python -m flux_proto.cli flux/soma.flux --target run --emit-ast --emit-lexer
```

---

## Pipeline Interno

1. **Leitura**: arquivo fonte lido como UTF-8
2. **Lexer**: `flux_proto.lexer.lexer.lex()` — tokeniza o fonte
3. **Parser**: `flux_proto.parser.parser.parse()` — constrói a AST (`FluxProgram`)
4. **Semantic**: `flux_proto.semantic.analyze()` — valida tipos, escopos, capitalização, ownership
5. **Target dispatch**:
   - `run` → `flux_proto.interpreter.interpreter.interpret()`
   - `vmbc` → `flux_proto.vm.compiler.compile_to_bytecode()` + runtime
   - `wat` → `flux_proto.wat.codegen.generate_wat()`
   - `wasm` → `flux_proto.wasm.codegen.generate_wasm()`
   - `llvm` → `flux_proto.llvm.codegen.generate_llvm()` + clang

Todas as fases após a leitura vivem em `src/flux_proto/`. O analisador semântico
é único e compartilhado por todos os 5 targets — não existe validação específica
por target.


---

## ABI de Strings por Target

A representacao interna de strings difere por backend, conforme as decisoes do
change `fat-pointer-representation`:

| Target | Representacao | Len | NUL interno |
| ------ | ------------- | --- | ----------- |
| in/vm/lv | `str`/objeto nativo | nativa | sim |
| wasm/wat | fat pointer `i64` = `(ptr << 32) | len` | no fat (unpack `shr_u 32`/`wrap`) | sim |
| llvm | `i8*` C-string + printf `%s` | `strlen`/snprintf (runtime) | **nao** (trunca no primeiro NUL) |

Strings sao codificadas em UTF-8 em todos os targets: `len()` (e a capacidade
`string(N)`) contam bytes UTF-8, e `\u{XXXX}` no fonte decodifica o code point
para seus bytes UTF-8.

## ABI de Char (UTF-32)

`char` representa exatamente um code point Unicode (U+0000..U+10FFFF) e e
armazenado como valor de 32 bits (UTF-32) em todos os targets compilados:

| Target | Representacao | UTF-8 |
| ------ | ------------- | ----- |
| in/vm | `str` de 1 code point / `_Chr(cp)` (int) | `chr()` no print |
| wasm/wat | `i32` code point | `$encode_utf8` no print/concat |
| llvm | `i32` code point | `flux_char_to_utf8` no print/concat |

A conversao para UTF-8 (1-4 bytes) acontece apenas na impressao ou na
concatenacao com string; o valor em memoria e sempre o code point de 32 bits.

### WASM: fat pointer (u64)

Toda string em storage, local, row de list/set (tag 4), parametro/retorno de
funcao de usuario e carregada como `i64`:

- `fat = (u64(ptr) << 32) | u64(len)`; `ptr = u32(fat >> 32)`; `len = u32(fat)`.
- Literais compilam com `len` constante (side-table do `_alloc_str`); resultados
  de concat/interpolacao produzem fat com len computada.
- `$print_str(ptr, len)` recebe o par ja separado - o shim WASI `fd_write`
  (iovec `(ptr, len)` em `(i32, i32)`) nao muda.

### Fronteira externa (bridge JS)

O modulo WASM exporta apenas `memory` e `_start`; nao ha exports de string.
Caso um futuro export devolva string, o formato ABI e o fat pointer `u64`:
`hi32 = ptr`, `lo32 = len` - decodifique com `decodeFatString` abaixo
(ver `web_wasm/index.html`).

### Limite documentado (LLVM)

`i8*` + `printf %s` nao transporta len: strings com NUL interno sao truncadas
na impressao. Paridade preservada nas suites existentes; concat de literais usa
`malloc`+`memcpy` com len da side-table do `IRWriter` (sem truncamento de 1024).
