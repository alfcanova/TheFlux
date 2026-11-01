## Context

IN: storage `map`/`data` prontos (environment.py:24); `_eval_map_literal` (interpreter.py:651), `_eval_index_access` (664) e `_exec_index_assign` (693) — porém: `data`/`list` index-assign estrito (sem growth), aninhado crasha (ListLiteral guarda coleções aninhadas como raw list, `items[i-1]` sem `Value`), e `_STDLIST` (414) não tem `stdMap*`/`stdCollection*`. VM: `MAKE_MAP`/`INDEX`/`INDEX_ASSIGN` (compiler.py:484-515, runtime.py:418-480) funcionam para map básico; `_BUILTINS` (runtime.py:625) sem `stdMap*`; sem growth. WAT/WASM/LLVM: modelo de coleção por rows tagged (list/set) implementado; map não existe (MapLiteral cai em `unsupported`/`(i32.const 0)`), e `data` = list puro.

Restrições: saída dos backends deve igualar IN (oráculo); stdlib `MapStdLib.fdsl` existente com nomes `stdMap*`/`stdCollection*` (convenção: intrínsecos privados no corpo de ops importadas); linguagem sem loops/comprehensions → ops expressas via intrínsecos.

## Goals / Non-Goals

**Goals:** 5 backends executam `flux/ExampleOfData.flux` e `flux/ExampleOfMap.flux` com saída = IN; growth `len+1` para data/list nos 5; mutação aninhada funcional; 24 ops do MapStdLib operantes; entradas de map tipadas parseáveis; `list of list of string` aceito pelo semantic.

**Non-Goals:** map como tipo paramétrico (tipo do valor); iteração `infinite (x in map)`; ordenação de map; chaves não-string/numéricas; slice em `data` (já suportado em IN/VM como list; mantido, sem novas garantias); crescimento com buracos (`> len+1`).

## Decisions

### D1 — Growth de data/list (append-only)
`<coll>[len+1] = v` → append; in-range → replace; `> len+1` → erro out-of-range. Aplicado a `data` **e** `list` em todos os backends (decisão de produto; remove distinção de tipo necessária no VM/nativos). IN: `_exec_index_assign` aceita `i == len+1`. VM: `_op_index_assign` idem. Nativos: helpers de set-row ganham branch "índice == len+1 ⇒ grow + set" no path de data/list.

### D2 — Index aninhado (IN)
Causa raiz: `_eval` de `ListLiteral` (interpreter.py:522-530) empacota coleções aninhadas como raw (`v.data`) enquanto `_eval_index_access` espera `Value`. Fix: `_eval_index_access`/`_exec_index_assign` normalizam elementos raw (coleção → `Value(type_name=orig, data=...)`; scalar → `Value`) na leitura/escrita; index-assign percorre todos os índices em cadeia (hoje só `indices[0]`).

### D3 — Entradas tipadas de map (parser)
`map{.key of <T>: <valor> of <T>, ...}` e chave numérica `.1 of uint8`. `MapEntry` ganha `key_type`/`value_type` opcionais. Regra de chave runtime: `of string` → lexema; `of uint8/int64/...` numérico → string do dígito. `of <T>` no valor → cast semântico (sem coerção numérica em runtime; anotação de tipo).

### D4 — Tipos aninhados (semantic)
`ListType`/`SetType`/`MapType` aceitam element_type = outro tipo de coleção (`list of list of string`, `list of data`). Fix do `SEM001` em storage decl. `MapType` mantém par chave/tipo (chave string|numérica; valor qualquer).

### D5 — Representação WAT/WASM/LLVM de map
Reuso do layout de coleção (header len/cap/etag + rows) com rows de 2 entradas: `[key_row][val_row]` empilhadas (key sempre string tag; valor tagged). Helpers: `$map_build`, `$map_get` (varre key rows + `$strcmp`), `$map_set` (replace ou append), `$map_remove`, `$map_len`, `$map_contains_key`, `$map_keys`, `$map_values`, `$map_entries`, `$map_to_str` (`{a: 42, b: 99}`, strings sem aspas), `$map_merge`. LLVM: `%flux.map` = `{ i64, [2N x i64] }` estático (pares key/val) + helpers IR espelhando `@flux_list_*`. Chave ausente em `map[k]` → `none` (IN: Value none; nativos: flag/repr none).

### D6 — Intrínsecos `stdMap*`/`stdCollection*`
23 intrínsecos conforme corpos do `MapStdLib.fdsl`: `stdCollectionLength/IsEmpty/Contains/ClearAll/Keys/Values/ToList/ToSet/ToMap`, `stdMapClearAll/InsertEntry/InsertEntryIfAbsent/ReplaceEntry/RemoveEntry/Length/IsEmpty/Entries/Keys/Values/ContainsKey/ContainsValue/GetValueOrDefault/Merge`. Semânticas: insertEntry sobrescreve; insertEntryIfAbsent preserva existente; removeEntry/removeKey idempotente; getValueOrDefault com default; merge = direita vence; extractEntries/Keys/Values devolvem `list of data`.

### D7 — Print/oráculo
IN: map `{a: 42, b: 99}` (ordem de inserção, `, ` separador, strings sem aspas); data/list aninhado `[ok, 42, [0.1, 0.2, 0.3], 0]`; ausente em print de map → `none`. Nativos replicam via helpers de to_str.

## Risks / Trade-offs

- Map em WASM/LLVM = terceiro tipo coleção (modelo set provado, mas par key/val dobra rows).
- Growth em nativos: helpers de set-row precisam de grow path por índice (hoje `$list_grow` só via push) — risco de divergência de cap; validar por compliance.
- Entradas `.key of T` mudam o parser: exemplos antigos que usam `map{.name of string: v}` (sem `of` no valor) continuam válidos (campos opcionais).
- `none` como valor de map (chave ausente): nativos precisam repr explícita no print/`+`.

## Migration Plan

1. F0: change OpenSpec + unificação de exemplos (2 oráculos).
2. F1 (parser) → F2 (semantic): tipos aninhados + entradas tipadas, testes unit.
3. F3 (IN) → oráculo igual; F4 (VM). Unit tests em cada fase.
4. F5 (WAT) → F6 (WASM) → F7 (LLVM), cada um validado por compliance contra IN.
5. F8: compliance `backend_compliance.py` (2 exemplos × 5 colunas), `pytest src/flux_tests`, docs KW_TYPE_data/map/list, archive.
Rollback: cada fase isolada; stdlib só depende das fases finais.

## Open Questions

- Print de map com valor aninhado (list dentro de map) em nativos — formatação recursiva limitada à profundidade do oráculo do exemplo.
- `collectionLength(value: data)` sobre `data` aninhado: conta só nível 1 (IN `len`), manter.
