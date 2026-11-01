## Context

IN: FSet dict ordenado, dedup primeira-ocorrência (`interpreter/environment.py`), storage/literal/`in`/print/`+` prontos. VM: MAKE_SET (compiler.py), `_op_make_set` (runtime.py), `in` (Op.IN), print `_fmt` — pronto; faltam builtins `stdSet*`. WAT: modelo de list por rows (tag i32 + val i64, header len/cap/etag) reutilizável (`$list_contains`, `$elem_to_str`, `$strbuf_new`/`$strappend`); falta tratar set. WASM/LLVM: sem coleção alguma; LLVM sem dispatch de agent op (`unsupported call`); WASM idem (só print/user_funcs).

Restrições: saída dos backends deve igualar IN (oráculo); stdlib autocontida no tipo (sem builtin fora do fdsl; precedente: list-full-support); linguagem sem loops/comprehensions → ops expressas via intrínsecos privados `stdSet*`.

## Goals / Non-Goals

**Goals:** 5 backends executam `flux/ExampleOfSet.flux` com saída = IN; 11 ops residem em SetStdLib.fdsl autocontida; concat `str+set` nos 5.

**Non-Goals:** iteração `infinite (x in coll)` (inexistente em todos os backends — feature separada); map/data como tipo paramétrico; slice/indexação de set.

## Decisions

### D1 — Representação WAT
Reuso do layout de list (header len/cap/etag + rows [tag i32, val i64]) + flag set em header+12. Helpers: `$set_build` (flag=1), `$set_push` (dedup via `$list_contains` + `$list_push_row`), `$set_to_str` (`{`/`}` via `$elem_to_str`), `$set_remove`, `$set_union/intersect/difference/symdiff`, `$set_is_subset/is_superset/is_disjoint`, `$set_to_list`. `in` reusa `$list_contains` (layout idêntico).

### D2 — Representação WASM (estática, dedup em compile-time)
Região fixa em memória linear via offset: `[len i32][cap i32][etag i32][flag i32][rows tag i32 val i64]` + helpers como funcs do módulo. Items de literal dedupados em compile-time (contagem final no header).

### D3 — Representação LLVM (estático)
`%flux.set` = `{ i64, [N x i64] }` global com init estático total (N = dedup do literal feito pelo gerador Python); strings `[N x i8*]`. Items não-literal: cap em helpers.

### D4 — Concat `str + set`
IN/VM: `+` com coleção → repr via `_fmt`. WAT: `$strbuf_new`+`$strappend`+`$set_to_str`. WASM: helper `$strconcat` com buffer estático; corrigir caminho string (hoje devolve só left). LLVM: `_gen_string_concat` já usa `snprintf("%s%s")` — suficiente com set→`i8*` via `@flux_set_to_str`.

### D5 — Dispatch de agent ops em WASM/LLVM
Espelhar WAT (`_op_defs`/`_used_op_names` DCE + `_emit_op_function`): registrar ops importadas, compilar corpo `emit(nice, stdSetX(...), "ok")` como função, mapear `stdSet*` → helper. LLVM: `_gen_call` ganha branch de agents (hoje raise). WASM: `_user_funcs` + `_gen_call` despacha.

### D6 — Semânticas das ops
include = dedup push (primeira ocorrência vence); exclude remove; union/intersect/difference/symmetricDifference; isSubset/isSuperset/isDisjoint; toList preserva ordem de inserção; toSet dedup. `toSet(value: data)` aceita list literal (ex: `toSet([1, 1, 2, 3])`).

## Risks / Trade-offs

- WASM/LLVM: primeiro tipo coleção + dispatch de agent = maior bloco (helpers de álgebra em 3 representações).
- Duplicação WAT↔WASM: mudanças espelhadas 1:1, validação por compliance em cada fase.
- `in` em WAT hoje compila como `i64.add` (bug pré-existente no branch relacional) — correção incluída.
- `_infer_type` de `in` retorna "string" quando left é string (bug pré-existente) — fix obrigatório.

## Migration Plan

1. F0: fdsl reescrita + spec + tasks (nome `stdSet*` quebra referências antigas — intencional).
2. F1 (IN) → oráculo igual; F2 (VM). Unit tests em cada fase.
3. F3 (WAT) → F4 (WASM) → F5 (LLVM), cada um validado por compliance contra IN.
4. F6: exemplos unificados + docs KW_TYPE_set.yaml.
Rollback: cada fase isolada; fdsl só referenciada na fase final dos backends compilados.

## Open Questions

- Print de set contendo float (formatação via `$f64_to_str` — casar com IN nos testes).
- `toSet` com entrada `data` não-set (ex.: literal list) — converter no backend (bug conhecido: list literal como `[i32.const 0]` i64 em WAT; solução dedicada).