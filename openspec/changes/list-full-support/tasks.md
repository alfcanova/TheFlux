## 1. Stdlib e especificação comum

- [ ] 1.1 Reescrever `stdlib/ListStdLib.fdsl` com nomenclatura `list*` (26 ops: listLength, listIsEmpty, listContains, listClearAll, listFirst, listSecond, listThird, listGetAt, listSlice, listSingletonInt, listSingletonString, listPushBack, listPushFront, listInsertAt, listRemoveAt, listRemoveLast, listSortAscending, listSortDescending, listReverse, listFlatten, listPartition, listZip, listUnzip, listToList, listToSet, listToMap) e corpos com intrínsecos `stdList*`
- [ ] 1.2 Atualizar os 3 exemplos em `flux/` para os novos nomes (listLength etc.)

## 2. Backend IN (interpretador)

- [x] 2.1 Registro de intrínsecos `stdList*` (dict name→fn) consultado em `_eval_call` antes do erro "undefined function"
- [x] 2.2 Resolução de op de agente importado (`use ListStdLib` → `listLength(...)`) executando corpo do op e devolvendo valor do `emit(nice, ...)`
- [x] 2.3 Slice `xs[start..end]` inclusivo em `_eval_index_access` e `_exec_index_assign` (SliceSpec)
- [x] 2.4 Concat `str + list` via `_fmt` (corrige TypeError)
- [x] 2.5 Unit tests interpreter: literal, índice, assign, slice, concat, cada op `list*`

## 3. Backend VM (vmbc)

- [x] 3.1 Builtins `stdList*` no runtime (`_builtins` dict); `_op_call` consulta antes do erro
- [x] 3.2 Slice (opcode SLICE) em compiler + runtime
- [x] 3.3 Concat `str + list` em `_op_add` (com unwrap de frames)
- [x] 3.4 Garantir `_op_emit` devolve valor da op na chamada (ops compiladas como funções `f_<name>`; frames desembrulhados em `_fmt`/`_op_add`/builtins)
- [x] 3.5 Unit tests vm: literal, índice, assign, slice, concat, ops `list*`

## 4. Backend WAT

- [ ] 4.1 Layout heap: header `[len, cap, elem_tag, data_ptr]` + elemento `[tag, val]` (i64; float bitcast; string/nested ptr); helpers de alloc/realloc via `$flux_alloc`
- [ ] 4.2 Helpers WAT: list_new, list_len, list_get, list_set, list_push_back, list_push_front, list_insert_at, list_remove_at, list_remove_last, list_clear, list_contains
- [ ] 4.3 Helpers sort (numérico/lexicográfico por elem_tag), reverse, flatten, partition, zip, unzip
- [ ] 4.4 `$list_to_string` (fmt `[e1, e2]`, strings sem aspas, aninhado, float via `$f64_to_str`)
- [ ] 4.5 `_gen_expr`/_gen_statement: ListLiteral, IndexAccess, IndexAssign, SliceSpec; storage `list of X` vira ponteiro (hoje i64=0)
- [ ] 4.6 Concat `+` com coleção e print de lista via `$list_to_string`
- [ ] 4.7 Compilar agent ops `.fdsl` como funções (padrão `_store_result_status`); mapear `stdList*` → helpers
- [ ] 4.8 Validar: wat2wasm + wasmer saída identica a IN nos 3 exemplos

## 5. Backend WASM

- [ ] 5.1 Espelhar helper functions do WAT no emissor binário (mesmo layout/memória)
- [ ] 5.2 Espelhar expressões/storage/concat/print/agent ops
- [ ] 5.3 Validar: wasm-validate + wasmer saída identica a IN nos 3 exemplos

## 6. Backend LLVM

- [ ] 6.1 `%flux_list = {i64 len, i64 cap, i64 elem_tag, i64* data}` + declarar `@malloc`/`@free` (fallback bump allocator)
- [ ] 6.2 Helpers LLVM: mesmas 20+ operações do WAT (list_new/get/set/push/insert/remove/sort/reverse/flatten/partition/zip/unzip)
- [ ] 6.3 Expressões: ListLiteral, IndexAccess, IndexAssign, SliceSpec; storage list → ponteiro
- [ ] 6.4 Print/concat de lista via snprintf acumulativo
- [ ] 6.5 Agent ops `.fdsl` como funções + mapeamento `stdList*`
- [ ] 6.6 Validar: clang → exe nativo saída identica a IN nos 3 exemplos

## 7. Verificação final

- [ ] 7.1 Homogeneidade: check semantic de literais `list of int64` + runtime check IN/VM
- [ ] 7.2 Compliance: `flux_verify.py` passando nos 3 exemplos (5 alvos, saída = IN)
- [ ] 7.3 Regressão: suítes existentes (t_wasm, t_wat, t_llvm, t_general, src/flux_tests) sem quebras
- [ ] 7.4 Documentar em `docs/keywords/KW_TYPE_list.yaml` (slice, ops list*)