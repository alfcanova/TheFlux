# Tensor Strides

## Why

Tensors (`tensor[dims] of primitive`) hoje usam listas aninhadas no interpretador/VM e não têm suporte algum nos backends WAT, WASM e LLVM. Além disso: o read rotula todo elemento como `float64` (bug), o literal inicializador não é validado contra a shape declarada (aceita ragged/mismatch silenciosamente) e o write só valida bounds da última dimensão.

## What Changes

- Representação única de tensor em **buffer flat row-major** com strides `S_x=8`, `S_y=X*8`, `S_z=Y*X*8` bytes e header `[rank][d0..d{r-1}]` — em todos os 5 alvos (run, vmbc, wat, wasm, llvm).
- Indexação **1-based preservada na linguagem**; tradução automática para offset 0-based na máquina (constante quando índice é literal, `sub 1` por dimensão quando variável).
- Sem tag por elemento: tipo do elemento é único e estático no tipo do tensor.
- Correções: elem type correto no read; shape validation do literal contra a declaração (rejeita ragged/mismatch); bounds check por dimensão no write.
- Print de tensor no formato aninhado `[[10, 20], [99, 40]]` via dims do header.
- Default (decl sem init) = buffer zero-filled.

## Capabilities

### New Capabilities
- `tensor`: semântica completa do tipo tensor N-D (layout flat por strides, indexação 1-based multi-dim, atribuição por índice, literal validado, print aninhado) — capaz de todos os alvos.

### Modified Capabilities
<!-- nenhuma spec existente alterada -->

## Impact

- `src/flux_proto/interpreter/interpreter.py` — storage flat + strides, shape-check, elem type.
- `src/flux_proto/vm/compiler.py`, `vm/runtime.py`, `vm/opcodes.py` — opcodes `TGET`/`TSET`.
- `src/flux_proto/wat/codegen.py`, `wasm/codegen.py` — inline load/store com offset constexpr + `$tensor_to_str`.
- `src/flux_proto/llvm/codegen.py` — GEP com offsets constantes + print loops.
- `src/flux_proto/semantic/types.py` — diagnóstico de shape mismatch em literal.
- Exemplo novo `flux/ExampleOfTensor.flux`; testes novos em `src/flux_tests/`.
