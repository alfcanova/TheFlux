## Why

O tipo `list` é suportado apenas parcialmente: o interpretador (IN) e o VM (vmbc) executam literal, indexação 1-based e atribuição por índice, mas os backends WAT, WASM e LLVM descartam silenciosamente listas (artefatos gerados sem dados), e nenhum backend implementa slice, concatenação string+lista ou as operações da biblioteca padrão `ListStdLib.fdsl` — que hoje nem sequer são chamáveis (falha com "undefined function").

## What Changes

- Suporte completo a `list` nos 5 backends (run, vmbc, wat, wasm, llvm): literal, índice 1-based, atribuição por índice, slice `a[start..end]` inclusivo, print `[10, 25, 30]`, aninhamento `[[1, 2], 5]`.
- Concatenação `string + list` formatando a lista (ex: `"xs: " + xs`).
- Reescrever `stdlib/ListStdLib.fdsl` com nomenclatura autocontida no tipo: todas as operações prefixadas `list*` (ex: `listLength`, `listIsEmpty`, `listContains`, `listPushBack`, `listSortAscending`, `listZip`), corpos via intrínsecos privados `stdList*` (ex: `stdListLength`).
- Registro de intrínsecos `stdList*` nos 5 backends (hoje inexistentes em todo o repositório).
- Chamada de ops de agente importado (ex: `listLength(numbers)`) executando o corpo do op e devolvendo o valor do `emit(nice, ...)`.
- 21 operações de lista: length, isEmpty, contains, clearAll, first, second, third, getAt, slice, singletonInt, singletonString, pushBack, pushFront, insertAt, removeAt, removeLast, sortAscending, sortDescending, reverse, flatten, partition, zip, unzip, toList, toSet, toMap.
- Semânticas fixadas: slice inclusivo nos dois extremos; zip usa o menor comprimento; sort lexicográfico para string e numérico para numérico; acesso fora de range é erro de runtime.
- Runtime embutido (helpers) para WAT, WASM e LLVM — heap linear/`malloc` com representação de lista em memória.

## Capabilities

### New Capabilities
- `list`: semântica completa do tipo `list` (literal, indexação, slice, concat, print, ops da stdlib) — capaz de todas as linguagens-alvo.

### Modified Capabilities
<!-- nenhuma spec existente é alterada; comportamento novo é a capability list -->

## Impact

- `stdlib/ListStdLib.fdsl` — reescrita (nomes `list*`; **BREAKING** para códigos usando nomes `collection*`/`first`/`second` antigos).
- `src/flux_proto/interpreter/interpreter.py` — intrínsecos, resolução de op de agente, slice, concat.
- `src/flux_proto/vm/compiler.py`, `vm/runtime.py`, `vm/opcodes.py` — builtins `stdList*`, slice, concat.
- `src/flux_proto/wat/codegen.py` — representação heap de lista + helpers + expressões + agents.
- `src/flux_proto/wasm/codegen.py`, `wasm/binary.py` — espelho do WAT em binário.
- `src/flux_proto/llvm/codegen.py` — `%flux_list`, `@malloc`, helpers, expressões, agents.
- Exemplos: `flux/ExampleOfList.flux`, `flux/ExampleOfList01.flux`, `flux/ExampleOfListAtribuicao.flux` — agora passam em 5 alvos.
- Testes: novos unit em `src/flux_tests/interpreter/` e `src/flux_tests/vm/`; compliance via `flux_verify.py`.
