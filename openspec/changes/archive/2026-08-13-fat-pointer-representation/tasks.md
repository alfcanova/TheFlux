## 1. Fundamentos (Fase 0)

- [x] 1.1 Inventariar usos de string nos 5 backends: grep `$strlen`|`strlen`|`i8*`|`_is_str_type` em `wasm/`, `wat/`, `llvm/`, confirmando pontos de contato do design (print, index, concat, rows, function params)
- [x] 1.2 Inventariar enums com payload string (variants com campo string) e impacto no discriminante — definir tratamento antes da migração WASM
- [x] 1.3 Adicionar helpers pack/unpack no WASM codegen: `fat_pack(ptr, len) -> i64` = `(i64.extend_i32_u(ptr) << 32) | i64.extend_i32_u(len)`; `fat_ptr(fat)` = wrap + `i32.shr_u 32`; `fat_len(fat)` = wrap — como método no `_WasmCodegen` (falha silenciosa nenhuma: unit-testes do helper)
- [x] 1.4 Side-table de len no `_alloc_str` (wasm/codegen.py:150 e wat equivalente): `_str_offsets` passa a guardar `(off, len)` e expor `_str_len(s)`; regressão com suite existente (`python -m flux_tests` e `backend_compliance.py`) deve passar inalterada

## 2. Backend WASM (Fase 1)

- [x] 2.1 Mapear string/str/char → I64 em `_wtype` e `_field_type` (wasm/codegen.py:60, :2076); ajustar layout de struct fields e `_gen_decl_struct_init`/`_gen_struct_field_access` para carregar fat
- [x] 2.2 Storage decl de string global (wasm/codegen.py:1167, :1358, :1375, :1425): emitir pack `(off, slen)` em vez de `i32.const off`; ajustar leitura de storage string
- [x] 2.3 Locals e temporários de string em `_sc_vars`/`_local_vars`: transporte como i64 fat; revisar `_sc_set`/leitura de variável string
- [x] 2.4 Escrita de elementos string em list/set: substituir `I64_EXTEND_I32_U` por pack (wasm/codegen.py:2046-2047); idem no build de literais (`:2778`, `:2847`, `:2869`) e `_gen_index_assign`
- [x] 2.5 Leitura de elemento string de list/set: `$elem_to_str` tag 4 (wasm/list_helpers.py:1374-1386) extrai `(ptr, len)` do fat sem `$strlen`/`$strcpy` scan; `$list_to_str`/`$set_to_str` e join de strings usam `len` dos fat pointers (wasm/list_helpers.py `$str_join`/append ~linha 372)
- [x] 2.6 Print path de var string (wasm/codegen.py:1678-1687): unpack `(ptr, len)` do fat em vez de `$strlen`; literais/enum variants mantêm len constante; interpolação/concat produzem fat
- [x] 2.7 IndexAccess de `list of string`: devolver fat do elemento; coerções/prints derivados atualizados
- [x] 2.8 Função de usuário: params/returns string como i64 fat (registro em `_user_funcs` e emissão de chamadas em body; `_start` marshaling); função com parâmetro e com retorno string
- [x] 2.9 Regenerar artefatos de ouro `t_wasm-*`; rodar `python flux_verify.py flux\ExampleOf*.flux` e `backend_compliance.py`; saída idêntica ao interpreter
- [x] 2.10 Testes novos: string com NUL interno (literal, var, elemento de list), `list of string`/`set of string` com comprimentos variados, função string cross-target

## 3. Backend WAT (Fase 2)

- [x] 3.1 Espelhar pack/unpack do D1 em texto WAT (helpers `$fat_pack`/`$fat_ptr`/`$fat_len` ou inline) em `_emit_helpers` (wat/codegen.py:671+)
- [x] 3.2 Mapear string → i64 no WAT codegen: storage decl (wat/codegen.py:636), globals, structs, locals
- [x] 3.3 Colecionáveis WAT: rows tag 4 com fat (wat/list_helpers.py `$elem_to_str` `$str_join`/append), escrita com pack, leitura com unpack; print de var string sem `$strlen` (wat/codegen.py `_gen_print_arg` equivalente)
- [x] 3.4 Função de usuário WAT com params/returns string (i64 fat); `_start` e chamadas atualizados
- [x] 3.5 Regenerar `t_wat-*`; validar com WABT (`wat2wasm`, `wasm-validate`, `wasm2wat`) via `flux_verify.py`; paridade com interpreter

## 4. Backend LLVM (Fase 3)

- [x] 4.1 Manter `i8*` + printf `%s` para strings (llvm/codegen.py:46); adicionar side-table de len para strings coletadas (`_collect_strings`/`_w.get_string_global`, llvm/codegen.py:1419-1470)
- [x] 4.2 Concat de strings (llvm/codegen.py:2677-2696): propagar len computada no resultado; join/formatação de `list of string`/`set of string` usam len transportada
- [x] 4.3 Função de usuário LLVM com string: manter ABI `i8*` (printf `%s`), garante paridade sem variadic dinâmico
- [x] 4.4 Regenerar `t_llvm`; rodar `backend_compliance.py` incl. alvo llvm; documentar limite de NUL interno no LLVM (paridade preservada nas suites existentes)

## 5. ABI externa e bridge JS (Fase 4)

- [x] 5.1 Exports/imports WASM de strings como `u64` fat (espelhando `criar_string_fat_ptr`); onde já é par `(i32, i32)` (iovec/fd_write) não muda
- [x] 5.2 Glue JS `web_wasm/index.html`: helper de decode fat (`ptr = hi32`, `len = lo32`) para exports de string; manter shim iov atual (:222-224)
- [x] 5.3 Documentar ABI externa de strings no `docs/compilacao.md` (ou arquivo de ABI existente): encodings interno vs fronteira, casos i64 fat vs pares iov

## 6. Limpeza e verificação final (Fase 5/6)

- [x] 6.1 Grep final de `$strlen`/`strlen` nos caminhos quentes (print, elem_to_str, join, concat); remover scans residuais cobertos por testes; manter fallback somente onde len é genuinamente desconhecida
- [x] 6.2 Rodar suites completas: `python -m flux_tests` (categorias positive/negative/compliance/regression), `backend_compliance.py`, `flux_verify.py` nos 5 alvos — zero regressão
- [x] 6.3 Atualizar `docs/TODO.md`: marcar diretriz de fat pointer como implementada; registrar decisões D1-D8 do design
- [x] 6.4 Validar change no openspec (`openspec validate`); ao concluir, sincronizar spec `string-fat-pointer` para `openspec/specs/` e arquivar change