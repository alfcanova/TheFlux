## 1. Stdlib, exemplos e spec

- [x] 1.1 Reescrever `stdlib/SetStdLib.fdsl` autocontida no tipo set: 11 ops (include, exclude, union, intersect, difference, symmetricDifference, isSubset, isSuperset, isDisjoint, toList, toSet) com corpos `emit(nice, stdSetXxx(...), "ok")`; remover `collectionLength/IsEmpty/Contains`, `clearAll`, `toMap`
- [x] 1.2 Merge dos 3 exemplos em `flux/ExampleOfSet.flux` (usa SetStdLib; sem `infinite`) e remover `flux/ExampleOfSetAtribuicao.flux` + `flux/ExampleOfSet01.flux`
- [x] 1.3 Criar change OpenSpec `set-full-support` (proposal, design, spec, tasks)

## 2. Backend IN (interpretador)

- [x] 2.1 Intrínsecos `stdSet*` em `_STDLIST` (FSet: include/exclude/union/intersect/difference/symmetricDifference/isSubset/isSuperset/isDisjoint/toList/toSet)
- [x] 2.2 Unit tests: dedup, `in`, print, concat, reassign, cada op `stdSet*` via agente
- [x] 2.3 `flux/ExampleOfSet.flux` roda no IN e oráculo fica igual

## 3. Backend VM (vmbc)

- [x] 3.1 Builtins `stdSet*` no runtime (`_BUILTINS`)
- [x] 3.2 Concat `str + set` em `_op_add` (validação pré-existente aceita FSet)
- [x] 3.3 Unit tests `src/flux_tests/vm/test_sets_vm.py` (storage, literal, `in`, print, concat, ops via agente)

## 4. Backend WAT

- [x] 4.1 `_is_set_type`/`_set_elem_type`; `_wtype("set of")`→`i32`; `_infer_type`: SetLiteral→`"set of X"`, BinaryOp `in`→`"int64"` (antes do check de string)
- [x] 4.2 `_collect_strs` para SetLiteral
- [x] 4.3 Helpers: `$set_build` (flag), `$set_push` (dedup), `$set_to_str`, `$set_remove`, `$set_union/intersect/difference/symmetric_difference`, `$set_is_subset/is_superset/is_disjoint`, `$set_to_list`; desbloquear `stdListToSet`
- [x] 4.4 `_gen_expr` SetLiteral; `in`→`$list_contains`; print branch set→`$set_to_str`
- [x] 4.5 Concat `string + set` via `$strbuf_new`/`$strappend`
- [x] 4.6 `stdSet*` em `_gen_stdlist_intrinsic`; rtype `set of data` nas ops importadas
- [x] 4.7 Validar wat2wasm+wasmer: saída = IN

## 5. Backend WASM

- [x] 5.1 Dispatch de agent: registrar ops importadas como funções + corpo `emit`→intrinsic; `_gen_call` despacha ops (base wat `_op_defs`/`_emit_op_function`)
- [x] 5.2 `_wtype` set→I32; layout estático `[len cap etag flag][rows tag val]`; helper `$strcmp`
- [x] 5.3 Helpers `$set_contains/push/remove/union/intersect/difference/symmetric_difference/is_subset/is_superset/is_disjoint/to_list/to_str`
- [x] 5.4 `_gen_expr` SetLiteral; `in` em `_apply_binop` antes do string check; print branch; `_collect_strs` SetLiteral
- [x] 5.5 Concat `string + set`: corrigir path de string (hoje devolve só left) + `$strconcat`
- [x] 5.6 Storage global/local i32 + init; `stdSet*` em `_gen_call`
- [x] 5.7 Validar wasmer: saída = IN

## 6. Backend LLVM

- [x] 6.1 Dispatch de agent: ops importadas → funções; `_gen_call` despacha ops; EmitStmt→intrinsic→result struct
- [x] 6.2 Tipo `%flux.set` = `{ i64, [N x i64] }` (N dedup compile-time; strings `[N x i8*]`); storage com init estático total
- [x] 6.3 `in` em `_apply_binary_op` → `@flux_set_contains_i64/str` (strcmp libc), antes do check de string; garantir `in` não caia em concat (`_gen_binary_op_text`)
- [x] 6.4 Helpers `@flux_set_*` (contains/insert/remove/álgebra/to_list/to_str buffer estático)
- [x] 6.5 Print set → `@flux_set_to_str` → `printf("%s")`; concat via `snprintf %s%s`
- [x] 6.6 `_collect_strings` SetLiteral; intrinsics `stdSet*` → helpers IR
- [x] 6.7 Validar clang: saída = IN

## 7. Aceitação e docs

- [x] 7.1 `python backend_compliance.py`: `ExampleOfSet.flux` ✓ nas 5 colunas
- [x] 7.2 `pytest src/flux_tests` sem regressão
- [x] 7.3 Atualizar `docs/keywords/KW_TYPE_set.yaml`: remover restriction "backends ainda não emitem memória estática"; marcar 5 backends, concat e stdlib