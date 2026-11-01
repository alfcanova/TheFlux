## Why

O tipo `set` é suportado apenas pelo interpretador (IN) e parcialmente pelo VM: storage `set of T`, literal `{...}` com dedup, operador `in` e print `{a, b}` existem, mas WAT descarta silenciosamente o literal (cai em `(i32.const 0)`), WASM e LLVM não têm nenhuma infraestrutura de coleção, e o operador `in` compila errado em WAT (cai em `i64.add`). A biblioteca `SetStdLib.fdsl` referencia intrínsecos `stdCollection*` que não existem em backend algum (nem IN), e concatenação `string + set` não é suportada em WAT/WASM.

## What Changes

- Suporte completo a `set` nos 5 backends (in, vm, wat, wasm, llvm): storage com dedup, literal `{...}`, operador `in`, print `{a, b, c}`, reassign.
- Concatenação `string + set` (ex: `"Set inicial: " + valores`).
- `stdlib/SetStdLib.fdsl` reescrita **autocontida no próprio tipo**: 11 ops (include, exclude, union, intersect, difference, symmetricDifference, isSubset, isSuperset, isDisjoint, toList, toSet), corpos via intrínsecos privados `stdSet*`; removidas ops genéricas `collection*`/`clearAll`/`toMap`.
- Registro dos intrínsecos `stdSet*` nos 5 backends (incluindo IN/VM, hoje inexistentes).
- Dispatch de ops de agente importado em WASM e LLVM (hoje `unsupported call`); WAT/VM/IN já têm.
- Exemplos unificados: `flux/ExampleOfSet.flux` único (use SetStdLib; sem `infinite`); removidos `ExampleOfSetAtribuicao.flux` e `ExampleOfSet01.flux`.

## Capabilities

### New Capabilities
- `set`: semântica completa do tipo `set` (literal com dedup, `in`, print, concat, 11 ops da stdlib autocontidas no tipo) — capaz de todas as linguagens-alvo.

### Modified Capabilities
<!-- nenhuma spec existente é alterada -->

## Impact

- `stdlib/SetStdLib.fdsl` — reescrita (nomes `stdSet*`; remoção de ops `collection*`; **BREAKING**).
- `src/flux_proto/interpreter/interpreter.py` — intrínsecos `stdSet*`.
- `src/flux_proto/vm/runtime.py` — builtins `stdSet*`; concat `str+set` em `_op_add`.
- `src/flux_proto/wat/codegen.py`, `wat/list_helpers.py` — helpers de set (reuso do modelo de list).
- `src/flux_proto/wasm/codegen.py` — infra de coleção estática + agent ops + helpers.
- `src/flux_proto/llvm/codegen.py` — `%flux.set` estático + helpers + agent ops.
- Exemplos: `flux/ExampleOfSet.flux` (merge) passa em 5 alvos.
- Testes: novos unit em `src/flux_tests/interpreter/` e `src/flux_tests/vm/`; compliance via `backend_compliance.py`/`flux_verify.py`.