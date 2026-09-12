## Why

Os tipos `map` e `data` são suportados apenas parcialmente pelo interpretador (IN): storage, literal, indexação 1-based (data) e acesso dinâmico (map) existem, mas o growth de `data` em atribuição indexada (`payload[4] = 100` sobre len 3) falha (`out of range`), indexação aninhada de `data`/`list` (`payload[3][1]`, `payload[3][2] = 0.25`) crasha (`AttributeError: 'list' object has no attribute 'type_name'`), e os 23 intrínsecos `stdMap*`/`stdCollection*` referenciados por `stdlib/MapStdLib.fdsl` **não existem em backend algum** (nem IN/VM). VM não tem builtins de map nem growth. WAT/WASM/LLVM não têm representação de map nem helpers. Sintaxe de entradas tipadas `map{.key of uint8: "x" of string}` (usada em 3 exemplos) é rejeitada pelo parser (`PAR001`), e o tipo aninhado `list of list of string` é rejeitado pelo semantic (`SEM001`).

## What Changes

- Suporte completo a `map` e `data` nos 5 backends (in, vm, wat, wasm, llvm): storage, literal, indexação 1-based (data/list), acesso dinâmico por chave string (map), chave ausente → `none`, print `{a: 42, b: 99}`, reassign, mutação aninhada.
- Growth em atribuição indexada de `data` **e** `list`: índice `len+1` faz append; in-range faz replace; `> len+1` é erro (`out of range`).
- Sintaxe de entrada de map tipada `map{.key of <T>: <valor> of <T>}` com chave string ou numérica (`.1 of uint8` → chave `"1"`).
- Tipos aninhados de coleção: `list of list of string` (elemento pode ser coleção).
- Registro dos intrínsecos `stdMap*` (23) nos 5 backends, incluindo IN/VM (hoje inexistentes), conforme corpos do `MapStdLib.fdsl`.
- Exemplos unificados: `flux/ExampleOfData.flux` (merge de 5) e `flux/ExampleOfMap.flux` (merge de 5); removidas as variantes.

## Capabilities

### New Capabilities
- `data`: semântica completa do tipo `data` (heterogêneo, 1-based, growth, mutação aninhada, default `[]`) — capaz de todas as linguagens-alvo.
- `map`: semântica completa do tipo `map` (chaves string, acesso dinâmico, ausente → none, entradas tipadas, 24 ops da stdlib `MapStdLib`) — capaz de todas as linguagens-alvo.

### Modified Capabilities
- `list`: growth por append em index-assign (`len+1`) — extensão da semântica atual (antes: erro out-of-range).

## Impact

- `stdlib/MapStdLib.fdsl` — mantida; 23 intrínsecos `stdMap*`/`stdCollection*` passam a existir.
- `src/flux_proto/parser/expressions.py` + `parser/ast.py` — MapEntry com `key_type`/`value_type`.
- `src/flux_proto/semantic/types.py` — tipos de coleção aninhados.
- `src/flux_proto/interpreter/interpreter.py` — growth, index aninhado, intrínsecos.
- `src/flux_proto/vm/compiler.py` + `vm/runtime.py` — growth, MAKE_MAP com chave numérica, builtins.
- `src/flux_proto/wat/`, `wasm/`, `llvm/codegen.py` — helpers de map (modelo list/set), growth, intrínsecos.
- Exemplos: `flux/ExampleOfData.flux` e `flux/ExampleOfMap.flux` (merge) passam em 5 alvos; 8 variantes removidas.
- Testes: unit em `src/flux_tests/interpreter/` e `src/flux_tests/vm/`; compliance via `backend_compliance.py`/`flux_verify.py`.
- Docs: `docs/keywords/KW_TYPE_data.yaml`, `KW_TYPE_map.yaml`, `KW_TYPE_list.yaml`.
