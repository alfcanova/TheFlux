## Why

Strings são hoje representadas como ponteiro i32 NUL-terminado nos backends WASM e WAT, com o comprimento recuperado via scan `$strlen` em runtime; colecionáveis (list/set de string) guardam apenas o ponteiro na linha (tag 4, val i64) e descartam o comprimento. Isso obriga scans O(n) redundantes no print e impossibilita strings binárias (NUL interno). O ABI da fronteira JS/WASI já consome pares `(ptr, len)` — manter o comprimento junto ao ponteiro (fat pointer) elimina o scan, habilita strings com NUL interno e alinha a representação interna com a ABI externa.

## What Changes

- Adotar fat pointer como representação canônica para **strings** e demais tipos len-carrying (data/bytes, slices) nos backends nativos:
  - WASM: fat empacotado em `i64` = `(ptr << 32) | len` em memória linear, globals, locals, struct fields e linhas de list/set.
  - WAT: mesmo layout, emitido em texto.
  - LLVM: `i8*` mantido para printf `%s`, mas comprimento passa a ser transportado (side-table de len ou par `{i8*, i64}`) nos colecionáveis e concatenações.
- Linhas de list/set (16 bytes: `+0 tag i32, +8 val i64`) com tag 4 (string) passam a guardar o fat completo (ptr<<32|len) em `val`.
- `$strlen` deixa de ser usado no caminho quente: print de variável string, `$elem_to_str`/`$list_to_str`/`$set_to_str` e concatenações extraem len do fat (shift/wrap), sem scan.
- Strings passam a suportar NUL interno; o terminator `\0` continua presente nas constantes apenas para compatibilidade LLVM `%s`.
- **BREAKING**: representação interna de strings nos artefatos WASM/WAT (globals/locals de string passam de i32 -> i64 fat-packed; rows de list/set de string mudam o conteúdo de `val`). Artefatos e testes de ouro gerados anteriormente são regenerados.
- **BREAKING**: ABI externa de strings (imports/exports com parâmetros/retornos string) passa a ser `u64` fat-packed na fronteira (ex.: `criar_string_fat_ptr() -> u64`), ou split `(i32 ptr, i32 len)` onde a ABI já é posicional (iovec/fd_write permanece como está).
- Funções de usuário com parâmetros/retorno string nos backends WASM/WAT passam a transportar fat (i64) internamente.
- Interpreter e VM (Python) não mudam internamente; apenas paridade de saída mantida nos novos testes.

## Capabilities

### New Capabilities
- `string-fat-pointer`: representação canônica len-carrying (fat pointer) para strings e tipos len-carrying nos backends WASM, WAT e LLVM, incluindo colecionáveis (list/set de string), concatenações, print e ABI externa.

### Modified Capabilities
<!-- Nenhuma spec existente (`function-abi-result-frames`, `short-circuit-postfix`) muda em nível de requisito. -->

## Impact

- `src/flux_proto/wasm/codegen.py` — `_alloc_str` (len side-table), globals/locals/struct fields de string (I32 -> I64 fat), index-assign/push em list/set (empacotamento), print path (unpack sem `$strlen`), função de usuário (params/returns fat).
- `src/flux_proto/wasm/list_helpers.py` — `$elem_to_str`/`$list_to_str`/`$set_to_str` (tag 4 lê fat, sem `$strlen`), join/concat de strings.
- `src/flux_proto/wasm/binary.py` — sem mudança de formato; apenas uso.
- `src/flux_proto/wat/codegen.py` e `src/flux_proto/wat/list_helpers.py` — espelho do backend WASM em texto.
- `src/flux_proto/llvm/codegen.py` e `ir_writer.py` — transporte de len (side-table/par) em colecionáveis e concat.
- `web_wasm/index.html` — glue JS já decodifica `(ptr, len)`; ajustar decodificação de fat u64 em exports se necessário (ABI externa).
- Testes de ouro em `t_wat-*`, `t_wasm-*`, `t_llvm`, `t_fvmbc`, `t_general` — regeneração de artefatos; verificação via `backend_compliance.py` e `flux_verify.py` (5 alvos).
- `docs/TODO.md` — decisão arquitetural já registrada (item "fat pointer"); atualizar status após implementação.