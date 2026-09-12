## Context

TheFlux é compilador Python multi-backend (interpreter, VM, LLVM, WAT, WASM) com paridade de saída verificada por `backend_compliance.py`/`flux_verify.py` (5 alvos). Estado atual das strings:

- **WASM/WAT**: strings são `i32` pointer para bytes NUL-terminados em data segment estático. Comprimento recuperado em runtime via `$strlen` (scan linear). Constantes têm len conhecida em compile-time e já usam `(ptr, len)` no print (wasm/codegen.py:1671-1677); variáveis/computadas dependem de scan.
- **Colecionáveis** (list/set), WASM e WAT: header `+0 len, +4 cap, +8 etag, +12 data`, rows de 16 bytes `+0 tag i32, +8 val i64` (wasm/list_helpers.py:8-9, wat/list_helpers.py). Tag 4 = string; `val` guarda só o ptr — a len é descartada na escrita (wasm/codegen.py:2046-2059 usa `I64_EXTEND_I32_U`) e recuperada com `$strcpy`+scan na leitura (`$elem_to_str`, wasm/list_helpers.py:1374-1386).
- **Print/ABI**: `$print_str (ptr i32, len i32)` já é par fat (wasm/codegen.py:1042); iovéc da WASI `fd_write` e o glue JS de `web_wasm/index.html:222-224` já decodificam `(ptr, len)` — a fronteira externa é len-carrying de fato.
- **LLVM**: strings como `i8*` + printf `%s` (llvm/codegen.py:46) — NUL obrigatório, len não transportada; concat gera novo buffer com len conhecida.
- **VM/Interpreter**: strings nativas Python (pool), len intrínseca — sem representação binária própria.

Capacidade proposta: `string-fat-pointer`. Nenhuma spec existente (`function-abi-result-frames`, `short-circuit-postfix`) muda.

## Goals / Non-Goals

**Goals:**

- Representação canônica len-carrying para strings e tipos len-carrying (data/bytes, slices) nos backends nativos.
- Eliminar `$strlen` do caminho quente (print de variáveis, formatação de colecionáveis, join/concat).
- Habilitar strings com NUL interno (binary-safe) onde a representação permitir.
- Reusar o layout existente de rows (val i64 de 8 bytes) sem mudança estrutural do header de list/set.
- Manter paridade de saída nos 5 alvos (oráculo: interpreter).
- Manter compatibilidade LLVM `printf %s` (sem rewrites de printf por variadic dinâmico).

**Non-Goals:**

- Não mudar a sintaxe/linguagem (sem novo tipo `data`/slice exposto ao programador neste change).
- Não mudar o layout do header de list/set (len/cap/etag/data permanecem).
- Não migrar VM/Interpreter para fat binário (são oráculos/referência).
- Não implementar GC/arena; strings continuam imutáveis e estáticas exceto por concat (já alocado via `$flux_alloc`).
- Não alterar ABI WASI `fd_write`/iovec (já fat).

## Decisions

### D1: Encoding interno — fat-packed i64 `(ptr << 32) | len`
Uma string runtime em WASM/WAT é um `i64`: `ptr` nos 32 bits altos, `len` nos baixos. Onde ptr-único era usado (global/local/struct field/row val/retorno de função), opera-se à unidade i64 e extrai-se:
- `ptr = i32.wrap_i64(fat) >> 32` (WASM: `i32.shr_u` do wrap; WAT idem)
- `len = i32.wrap_i64(fat)`

Packing: `i64.or(i64.shl(i64.extend_i32_u(ptr), 32), i64.extend_i32_u(len))`.

Alternativas consideradas:
- *Par de slots i32 separados* (ptr, len em dois registradores/globals): dobrado nos mapeamentos, complica stack de valores e rows; rejeitado.
- *Struct {ptr, len} na heap com header*: transporte por ponteiro único, mas alocação extra por string e two-step deref; rejeitado por custo.
- *Packed em u64 na fronteira apenas, ptr puro internamente*: é o estado atual; não resolve scans nem len descartada.

### D2: Constantes — data segment permanece; len vira side-table em compile-time
`_alloc_str` (wasm/codegen.py:150, wat equivalente) continua alocando em data segment estático. O codegen mantém `dict[str, int]` de offsets e passa a raciocinar em `(off, len)` — pattern já existente no print de literais (wasm/codegen.py:1673). Terminator `\0` mantido nas constantes (compat LLVM `%s`, `$strcpy`, WASI paths) mas não mais confiável como fonte de len.

### D3: Colecionáveis — tag 4 guarda fat completo em `val`
Escrita de elemento string em list/set: empacotar `(ptr, len)` no i64 antes do `$list_set_row` (substitui `I64_EXTEND_I32_U` em wasm/codegen.py:2046-2047 e equivalentes no build de literais: :2778, :2847, :2869). Leitura (`$elem_to_str` tag 4): `ptr = wrap >> 32`, `len = wrap`, copiar `len` bytes (sem scan). Concat/join de fat pointers (wat/list_helpers.py `$str_join`/append, linhas ~368-381) usam len dos operandos.

### D4: Print path — unpack em vez de `$strlen`
`_gen_print_arg` (wasm/codegen.py:1652) para var string: em vez de `$strlen` (:1684), gerar `(ptr, len)` do fat. `$print_str (ptr, len)` inalterado. `$strlen` permanece emitido apenas onde len é genuinamente desconhecida (fallback de compat), removível em follow-up após cobertura de testes.

### D5: Mapeamento de tipos — string vira I64 no WASM/WAT
`_wtype` (wasm/codegen.py:60-68) e `_field_type` (wasm/codegen.py:2076-2082) passam a mapear string/str/char → I64 (fat). Ripple:
- Globals de storage (storage decl literal: :1167-1168 — hoje `i32.const off`; vira pack), 
- locals, struct fields (layout), 
- params/returns de `function` de usuário (ABI interna i64; `_user_funcs`/emissão de chamadas), 
- pattern match de strings em enum/struct (checks de igualdade por ptr+len), 
- IndexAssign/IndexAccess de `list of string` (leitura de elemento: fat em vez de ptr; `_gen_index_assign` :2046, `_gen_index_access` equivalente).
- Enum variants com payload string (se existentes) — verificar em implementação.

### D6: LLVM — `i8*` mantido + len transportada em side-table
LLVM permanece `i8*` para printf `%s` (NUL preservado em consts). Para colecionáveis/concat, o comprimento é carregado como `i64` (side-table declarada ou retorno em par) onde hoje a len é computada e descartada (`_gen_string_concat`, llvm/codegen.py:2677-2696; `_collect_strings`/globals :1419-1470). Não usar `%.*s` dinâmico: variadic dinâmico exigiria realocar printf path; **decidido** manter `%s` e só transportar len para formatação de colecionáveis e concat.

### D7: ABI externa — fat-packed `u64` em exports/imports de string
Para o browser (web_wasm) e futuros hosts: exports/imports com string usam `u64` fat-packed, espelhando `criar_string_fat_ptr() -> u64 { ((ptr as u64) << 32) | (len as u64) }`. Iovec/`fd_write` permanece pares `(i32, i32)`. Glue JS (`web_wasm/index.html`) ganha helper de decode fat (ptr = hi32, len = lo32) por export; o shim de iov não muda.

### D8: Ordem de implementação — WASM primeiro, WAT espelho, LLVM isolado
Backend WASM concentra todo o padrão (pack/unpack, rows, print, ABI). WAT é espelho textual (mesmos helpers em WAT texto). LLVM é tratado isoladamente após paridade WASM/WAT (representação diferente). Testes de ouro regenerados a cada fase; `backend_compliance.py` garante paridade.

## Risks / Trade-offs

- **[Breaking de artefatos]** → Artefatos `.wat`/`.wasm` antigos em `t_wat-*`/`t_wasm-*` e bins de referência mudam de layout. Mitigação: regenerar via toolchain na implementação; compliance roda sobre artefatos regenerados.
- **[Ripple de ABI de função de usuário]** → params/returns string trocam de tipo (I32→I64) internamente; chamadas e `_start` precisam consistência. Mitigação: camada única de marshaling (helpers pack/unpack), testes focados em função com parâmetro/retorno string (cross-target).
- **[LLVM `%s` vs NUL interno]** → strings binárias com NUL interno não são representáveis fielmente via printf `%s` no LLVM. Mitigação: NUL interno garantido apenas em WASM/WAT (documentar na spec); LLVM mantém comportamento atual (truncamento em NUL) — paridade preservada para as strings das suites existentes.
- **[Char como string]** → `char` tratado como string de 1 byte (today); com fat, `char` vira fat de len=1. Verificar impacto em conversões numéricas de char.
- **[Complexidade de `$strlen` residual]** → scans remanescentes criam inconsistência se usados sobre fat. Mitigação: grep de usos de `$strlen` após cada fase; caminho quente sem scans é critério de aceite.
- **[Enum payload string]** → se variants de enum carregam string, o discriminante/layout muda com fat. Mitigação: inventariar enums com payload string antes da fase WASM (task específica).

## Migration Plan

1. Fase 0: pack/unpack helpers em WASM + side-table de len em `_alloc_str` (sem mudança de comportamento; `$strlen` ainda ativo).
2. Fase 1: WASM — colecionáveis, then globals/locals/structs, then print path, then função ABI. Regenerar `t_wasm-*` a cada subpasso; rodar compliance.
3. Fase 2: WAT espelho; regenerar `t_wat-*`.
4. Fase 3: LLVM side-table de len; regenerar `t_llvm`.
5. Fase 4: ABI externa u64 (exports JS) + docs.
6. Fase 5: remoção de `$strlen` residual (se coberto) e atualização de `docs/TODO.md`.

Rollback: reverter commits por fase; artefatos regeneráveis; nenhuma dependência externa nova.

## Open Questions

- Char: manter como fat len=1 ou permanecer escala numérica (impacto em coerções)? — definido empiricamente na Fase 1 via testes existentes de char.
- Funções de usuário importadas/exportadas de agentes (fdsl imports): a ABI externa fat u64 se aplica a todas ou apenas ao `_start`/browser bridge? — decidir na Fase 4 com base nos agentes existentes.
- `list of data`/`set of data`: elementos heterogêneos já carregam tag própria — fat se aplica apenas a elementos string (tag 4), sem mudança para os demais tags.