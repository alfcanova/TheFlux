## 1. OpenSpec, exemplos e docs base

- [x] 1.1 Change OpenSpec `map-data-full-support` (proposal, design, specs data+map, tasks)
- [x] 1.2 Unificar `flux/ExampleOfData.flux` (merge de DataAtribuicao/DataLocal/DataSimple/DataType_completo) e remover as 4 variantes
- [x] 1.3 Unificar `flux/ExampleOfMap.flux` (merge de MapAtribuicao/MapCidades/MapHeterogeneo/MapNumerico) e remover as 4 variantes

## 2. Parser

- [x] 2.1 `MapEntry` ganha `key_type`/`value_type` opcionais (ast.py:91)
- [x] 2.2 `parse_map_literal` (expressions.py:371): aceita `.key of <T>: <valor> of <T>` e chave numérica `.1 of uint8`
- [x] 2.3 Tests parser: entradas tipadas string/numérica, forma simplificada mantida

## 3. Semantic

- [x] 3.1 Tipos aninhados: element_type recursivo em types.py (fix SEM001 `list of list of string`)
- [x] 3.2 Validação entrada map: key_type vs chave, `of <T>` no valor
- [x] 3.3 Tests semantic: declaração aninhada, map tipado

## 4. Backend IN (interpretador)

- [x] 4.1 Growth em `_exec_index_assign` (interpreter.py:707): `i == len+1` ⇒ append para data/list
- [x] 4.2 Index aninhado: `_eval_index_access` (664) normaliza elementos raw; `_exec_index_assign` percorre índices em cadeia
- [x] 4.3 `_eval_map_literal` (651): usa `key_type` (numérico → string), aceita `value_type`
- [x] 4.4 23 intrínsecos `stdMap*`/`stdCollection*` no `_STDLIST` (414)
- [x] 4.5 Tests `test_data.py` + `test_maps.py` (growth, aninhado, cada op via agente)
- [x] 4.6 `flux/ExampleOfData.flux` e `ExampleOfMap.flux` rodam no IN; oráculos gravados

## 5. Backend VM (vmbc)

- [x] 5.1 Growth em `_op_index_assign` (runtime.py:431): `i == len+1` ⇒ append
- [x] 5.2 `MAKE_MAP` (compiler.py:484): chave numérica `.1` → `"1"`; value cast ignorado
- [x] 5.3 Builtins `stdMap*`/`stdCollection*` no `_BUILTINS` (runtime.py:625)
- [x] 5.4 Tests `test_maps_vm.py` (storage, literal, growth, ops via agente)

## 6. Backend WAT

- [x] 6.1 Helpers map no LIST_HELPERS (wat/list_helpers.py): `$map_build/get/set/remove/len/contains_key/keys/values/entries/to_str/merge` (modelo `$list_*`, pairs key/val)
- [x] 6.2 `_gen_expr` MapLiteral; IndexAccess/IndexAssign map; print/concat map
- [x] 6.3 Growth no index-assign de list/data (len+1)
- [x] 6.4 `stdMap*`/`stdCollection*` em `_gen_stdlist_intrinsic` (wat/codegen.py)
- [x] 6.5 Validar wat2wasm+wasmer: saída = IN (ExampleOfData/ExampleOfMap/ExampleOfList wat ✓; `$collection_to_str` tag-aware com `$flux_heap_start` p/ ops `data`)

## 7. Backend WASM

- [x] 7.1 CollectionHelpers (wasm/list_helpers.py): `build_map`, `map_get/set/remove/len/contains_key/keys/values/entries/to_str/merge`
- [x] 7.2 codegen: MapLiteral, index map, print, storage estático
- [x] 7.3 Growth no index-assign (`$list_set_grow`)
- [x] 7.4 `stdMap*`/`stdCollection*` em `_gen_call`; agent ops dispatch
- [x] 7.5 Validar wasmer: saída = IN (ExampleOfData/ExampleOfMap/ExampleOfList wasm ✓; fixes: `_index_access_type` aninhado, wrap i64→i32 no chain print, `$collection_to_str` com `$flux_heap_base`)

## 8. Backend LLVM

- [x] 8.1 Runtime IR: `@flux_map_build/get/set/remove/len/contains_key/keys/values/entries/to_str/merge` (modelo `@flux_list_*`)
- [x] 8.2 `_gen_map_literal_text`; IndexAccess/IndexAssign map; print/concat
- [x] 8.3 Growth no index-assign
- [x] 8.4 `stdMap*`/`stdCollection*` em `_gen_std_collection_intrinsic` (codegen.py:2802) + mapas de retorno (85-105)
- [x] 8.5 Validar clang: saída = IN (ExampleOfData/ExampleOfMap/ExampleOfList MATCH; +Arithmetic/Float/MutMulti corrigidos)

## 9. Aceitação e docs

- [x] 9.1 `backend_compliance.py`: `ExampleOfData.flux` + `ExampleOfMap.flux` ✓ nas 5 colunas (28/33 com todos os backends; foi o mesmo commit dos fixes WAT/WASM: ExampleOfList ✓ wat+wasm)
- [x] 9.2 `pytest src/flux_tests` sem regressão (656 passed, 4 skipped)
- [x] 9.3 `flux_verify.py` ok
- [x] 9.4 Docs: `KW_TYPE_data.yaml`/`KW_TYPE_map.yaml` (remover restriction "interpretador", documentar growth/syntax tipada), `KW_TYPE_list.yaml` (growth)
- [ ] 9.5 Archive do change
