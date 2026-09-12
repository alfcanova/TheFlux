## Context

Pipeline único (cli.py) com 5 alvos: `run` (interpreter), `vmbc` (VM), `wat`, `wasm`, `llvm`. Estado atual:

- IN: literal/índice/assign/print OK (Value type_name "list", Python list). Faltam: intrínsecos `stdList*`, resolução de op de agente em `_eval_call` (interpreter.py:463, só vê functions), slice (SliceSpec importado e não usado), concat `str+list` (TypeError, interpreter.py:129).
- VM: MAKE_LIST/INDEX/INDEX_ASSIGN OK, print OK, resolução de op de agente existe (vm/compiler.py:514-532); falta: builtins `stdList*` (runtime `_op_call` → "undefined function"), slice, concat.
- WAT: nada de lista — storage vira i64=0, expressões caem em `(i32.const 0)` (wat/codegen.py:807). Heap linear `$flux_heap_ptr`+`$flux_alloc` existem (wat/codegen.py:262-274). Sem agentes compilados.
- WASM: espelho do WAT, zero código de lista.
- LLVM: `CodegenError` em IndexAccess (llvm/codegen.py:839). Sem heap dinâmico.
- `std*` intrínsecos: não existem em lugar nenhum do repo.
- `stdlib/ListStdLib.fdsl`: ops nomeadas `collection*`/`first`/`second`... → renomear para `list*`.

Restrições: linguagem autocontida (runtime gerado no artefato, sem lib externa — alinhado com flux_alloc/wat e printf/llvm já usados); saída deve igualar o IN (oráculo) nos 5 alvos (flux_verify.py).

## Goals / Non-Goals

**Goals:**
- 5 backends executam os 3 exemplos de lista com saída idêntica ao IN.
- Todas as operações residem em `ListStdLib.fdsl` (nomes `list*`), autocontidas no tipo; intrínsecos `stdList*` implementados nos 5 backends.
- Slice inclusivo, zip menor comprimento, sort tipo-dependente (lexicográfico string / numérico numérico).

**Non-Goals:**
- Suporte a `set`, `map`, `data` (operam via ops genéricas hoje; ficam fora, exceto toList/toSet/toMap mínimos).
- Coleta de lixo / desalocação (heap bump allocator, sem free — como status quo wat).
- Heterogeneidade verificada em `list of int64` em backends compilados (flag para fase 6; runtime check só IN/VM).
- Performance/otimização de layout de memória (2 palavras por elemento primeiro; otimizar depois).

## Decisions

### D1 — Nomenclatura: op `list*` + intrínseco `stdList*`
`ListStdLib.fdsl` reescrito: `collectionLength` → `listLength`, `first` → `listFirst`, etc.; corpos `emit(nice, stdListLength(value), "ok")`. Nenhum builtin fora do fdsl. Alternativa (builtins direto no compilador) rejeitada: viola "autocontido no TYPE".

### D2 — Representação de lista em WAT/WASM/LLVM
Heap bump (`$flux_alloc` no WAT/WASM; `@malloc` declarado no LLVM). Layout:
```
header 4 palavras: [len i32, cap i32, elem_tag i32, data_ptr i32]
elemento 2 palavras: [tag i32, val i64]   # val: int raw; float bitcast; bool 0/1; string/nested = ptr
```
`elem_tag` = tipo dos elementos (int64/float64/string/bool/none/data...) para formatação de print. `list of data` heterogênea usa tag por elemento. Alternativa (1 palavra/elemento, homogêneo) rejeitada: complexo para `list of data`/aninhado; 2 palavras é uniforme e simples — otimização futura.

### D3 — Slice inclusivo `[start..end]`, 1-based
Semântica igual IN/VM: `start..end` inclusivo; `start>end` → vazio; fora de range → erro runtime. Parser/SliceSpec já existem (expressions.py:533-550); falta binding nos 5 backends. RANGE token `..` existe.

### D4 — Dispatch de ops de agente (IN)
`_eval_call`: antes de "undefined function", resolver `name` como op de agente importado (padrão existente em interpreter.py:302-326, mas nunca alcançado por calls não qualificadas) → mapear args a params, executar corpo, devolver valor do `emit(nice,...)`. VM já tem o caminho (compiler.py:514-532); WAT/WASM/LLVM: compilar op como função (padrão `_store_result_status` existe nos 3) e mapear chamada `stdList*` para helper/intrínseco.

### D5 — Concat `str + list`
IN/VM: no `+`, se um lado for coleção → `str(lado)` via `_fmt`. WAT/WASM/LLVM: helper `list_to_string(ptr) → buf` reutilizado por print e concat (mesma formatação `[e1, e2]`, strings sem aspas, aninhado).

### D6 — Print de lista
Mesmo formato do IN (`_fmt_collection`): `[10, 25, 30]`, `[ana, bia, caio]`, `[[1, 2], [3, 4], 5]`. WAT/WASM: monta string em buffer via `$list_to_string`; LLVM: `snprintf` acumulativo (padrão já usado em llvm/codegen.py:818).

### D7 — Semânticas de ops (tabela canônica)
1-based; `listContains` usa igualdade de valor; sort: numérico para int/float, lexicográfico para string (comparador por elem_tag); `listZip` menor comprimento, item = [a, b]; `listFlatten` achata 1 nível (item aninhado list → concat), preserva não-lista; `listPartition(list, size)` → blocos; `listPushFront`/`listInsertAt` shift; `listRemoveAt`/`listRemoveLast` shrink; `listClearAll` → vazia; `listToSet` → set (devido, delega set); `listToMap` mínimo documentado; `listSingletonInt/String` → `[v]`.

### D8 — Homogeneidade (adiada, parcial)
Semantic: checar tipos de literais de `list of int64` com elementos estáticos (erro compile). Runtime IN/VM: tag mismatch → erro. WAT/WASM/LLVM: campo elem_tag no header permite checar em runtime; implementação adiada para F6 sem bloqueio.

## Risks / Trade-offs

- Duplicação WAT↔WASM (2 codegens paralelos ~105KB) → Mitigação: mudanças espelhadas 1:1, validação por flux_verify (saída igual IN) em cada fase; helper module compartilhado não viável por estilos text/binário diferentes.
- LLVM sem heap hoje → `@malloc` de libc; risco de plataforma (clang presente, extern "malloc" padrão). Fallback: bump allocator em array global como WAT.
- Renomeação `collection*`→`list*` quebra exemplos/usuários → só ListStdLib + 3 exemplos no repo; **BREAKING** documentado na proposal.
- Slice/ops com `list of string` em WAT/WASM: strings são offsets internos (i32); zip de strings ok; sort lexicográfico em memória linear ok — mas comparação de strings não pode usar `strcmp` externo → helper próprio de byte compare (segue padrão `$i64_to_str`).
- Print de float em lista: formatação de ponto flutuante deve casar IN (formato existente `$f64_to_str` usado).
- Zip aninhado/unzip: profundidade 1 só; `listUnzip` espera lista de pares (list de 2 elems) — erro runtime se item não for lista de 2.

## Migration Plan

1. F0: fdsl reescrito + spec + tasks (nomes novos; código antigo quebra — intencional).
2. F1 (IN) → oráculo atualizado; F2 (VM). Ambos com unit tests.
3. F3 (WAT) → F4 (WASM) → F5 (LLVM), cada um validado por flux_verify contra IN.
4. F6: testes compliance 5 alvos (flux_verify.py sobre os 3 exemplos) + homogeneidade.
Rollback: cada fase isolada; sem reverter fdsl (runtime segue com nomes antigos até fase concluída — compat só entre fases consecutivas).

## Open Questions

- Formato exato de print de float/string dentro de listas compostas (casar `_fmt` do IN — validar nos testes de compliance).
- `listToSet`/`listToMap` retornam `set of data`/`data` (map): fmt de set/map fora do escopo list; manter comportamento IN atual.