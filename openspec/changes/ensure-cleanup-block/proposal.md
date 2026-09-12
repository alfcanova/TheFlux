## Why

`ensure` hoje é somente sintaxe superficial: o parser gera `BinaryOp(op="ensure", left, right=BlockStmt)` (`src/flux_proto/parser/expressions.py:214`), mas nenhuma camada posterior o implementa — semantic infere tipo errado, interpreter lança `unknown operator 'ensure'`, e VM/LLVM/WAT/WASM não possuem codegen. Além disso, a documentação diverge: `docs/TheFlux.md`/`TheFlux.ebnf:571` define `postfix_ensure_clause = "ensure", primary_base` (forma inline sem bloco) enquanto o parser e `KW_ensure.yaml` usam a forma de bloco `ensure { ... }`.

## What Changes

- Implementar semântica de cleanup estilo guard (Rust `defer`/guard) para `expr ensure { bloco }`:
  - Avalia `expr` → valor `v`; executa o bloco **sempre** (sucesso ou falha); a expressão resulta em `v` (valor original preservado, sem reavaliação).
  - Tipo da expressão = tipo de `expr`; o bloco **não** contribui com tipo (efeito colateral apenas).
  - Falha em `expr` (marcador ABI `{ sta, val, msg }`) → bloco ainda executa, falha propaga ao final.
  - Falha não tratada lançada pelo bloco propaga (não é engolida).
- Implementar nos cinco alvos: Semantic, Interpreter, VM, LLVM, WAT/WASM.
- **Docs:** corrigir `TheFlux.md`/`TheFlux.ebnf` (produção `postfix_ensure_clause` e exemplos), `grammar.md` (nota semântica), `KW_ensure.yaml` (tipo do alvo), `erros.md` (H1) para refletir a forma de bloco e a semântica de preservação de valor.
- **Exemplo:** `flux/ExampleOfEnsure.flux`.

## Capabilities

### New Capabilities
- `ensure-cleanup-block`: cláusula pós-fixa `expr ensure { bloco }` com semântica de cleanup — bloco sempre executa após o alvo, preservando o valor e o tipo da expressão à esquerda e propagando falhas não tratadas.

### Modified Capabilities
<!-- Nenhuma spec consolidada existe em `openspec/specs/` ainda — mesmo padrão de changes anteriores. -->

## Impact

- **Semântico:** `src/flux_proto/semantic/types.py` (`_infer_binary_op` — special-case `op == "ensure"` para tipo da esquerda; bloco validado como corpo sem tipar a expressão).
- **Interpreter:** `src/flux_proto/interpreter/interpreter.py` (`_eval_binary_op` — `try/finally`: avalia alvo, executa bloco, retorna valor do alvo; falha ABI propaga após o bloco).
- **VM:** `src/flux_proto/vm/compiler.py` + `src/flux_proto/vm/runtime.py` (preservar valor do alvo em slot/temp durante execução do bloco).
- **LLVM:** `src/flux_proto/llvm/codegen.py` (resultado do alvo em register local; corpo do bloco antes do retorno/falha).
- **WAT/WASM:** `src/flux_proto/wat/codegen.py`, `src/flux_proto/wasm/codegen.py` (idem, com frame de resultado ABI `{sta,val,msg}`).
- **Parser:** sem mudança de comportamento (`expressions.py:209-214` já produz a árvore correta); apenas verificação.
- **Testes:** `src/flux_tests/**` (semantic, interpreter, vm, e backends).
- **Docs:** `docs/TheFlux.md`, `docs/TheFlux.ebnf` (linhas 571, 568-570, 588), `docs/grammar.md` (740 + nota 535-538), `docs/keywords/KW_ensure.yaml`, `docs/erros.md` (H1).