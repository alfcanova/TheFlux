## Context

O interpreter executa chamadas de função de forma correta e reentrante: `emit` é terminal, e a chamada devolve um struct de sistema `{sta, val, msg}` materializado uma única vez (`_exec_emit` + `_eval_field_access`). Os outros quatro backends, porém, transportam o resultado por **globals de módulo não reentrantes**:

- **LLVM** (`llvm/codegen.py`): globals `@__flux_result_sta/val/vald/msg`; `_compile_function` força params `["i64"]*n` e retorna void, gravando o resultado nos globals; `_gen_call` fallback `("0","i64")`.
- **WAT** (`wat/codegen.py`) e **WASM** (`wasm/codegen.py`): globals `$__flux_result_*`/`_result_globals`; assinatura WASM retorna `[]`; chamador lê `(global.get $__flux_result_val)`.
- **VM** (`vm/runtime.py`): `_op_call` só aceita literal int (chamada nomeada → RuntimeError); `_op_store` vaza escopo externo; `ExpressionStmt` e chamada em statement deixam valor na pilha sem POP.

Consequências observáveis: chamadas aninhadas corrompem o resultado do chamador, recursão é impossível, e fallbacks (`("0","i64")`, `Value("void")`, `PUSH 0`) mascaram ausência de implementação. O gate de paridade (`backend_compliance.py` + `flux_verify.py`) é a verificação de segurança entre os 5 backends.

## Goals / Non-Goals

**Goals:**
- Frame de resultado **por chamada** (reentrante) nos 4 backends, permitindo aninhamento e recursão.
- Remoção total dos globals de resultado e de todo placeholder que mascare resultado (erro explícito no lugar).
- `.sta/.val/.msg` observáveis nos 4 backends com o mesmo conteúdo do interpreter, incluindo `.val` tipado pelo `as <tipo>`.
- Paridade mantida pelo gate existente + exemplo novo de função com aninhamento/recursão.

**Non-Goals:**
- `use`/imports/agent ops (já funcionais via expansão inline de `EnumVariant`; não há CALL de função via import).
- Sintaxe nova ou mudança de gramática; semântica nova além da eliminação de placeholders.
- `match`, `input/spy`, dataflow, `spawn` — gaps documentados em `docs/erros.md`, fora desta mudança.
- Otimizações (inlining, tail call).

## Decisions

### D1. Frame de resultado por chamada (todos os backends)
Cada chamada aloca seu próprio frame `{sta, val, msg}`; `RET` devolve o frame ao chamador, que o consome **uma vez**. Não há storage compartilhado entre chamadas.

- **Alternativa descartada:** registrador global de resultado — não reentrante (origem do bug atual).
- **Alternativa descartada:** cópia do frame no call site — correto, mas duplica o transporte do mesmo dado; no LLVM/WASM o struct de retorno já é cópia, sem custo extra.

### D2. Contrato semântico único (fonte da verdade = interpreter)
Contrato que todo backend deve reproduzir (interpreter não muda, exceto erro explícito no lugar de `Value("void")`):

1. Chamada termina por `emit(status, id, msg)` → resultado `{sta, val, msg}`; `val` tipado pelo `as` da função.
2. Divisão por zero em função → status `fail` com `val` = divisor (`fail` é observável via `.sta`/`?`).
3. Acesso `.sta/.val/.msg` lê campos do frame; caminho inteiro disponível via `r = f(x)`.
4. Short-circuit (`? f(x) {fail(v)==>{...} nice(n)==>{...}}`) consome o frame sem reavaliar.
5. Um `emit` por chamada: `RET` devolve o frame construído; nenhum outro path de retorno existe (função sempre termina em `emit`).

### D3. VM: `CALL` com endereço de função + frame na pilha
- `_compile_call` passa a compilar `CALL <addr>` com o endereço da função (rótulo), não mais literal.
- Runtime: `_op_call` aloca frame `{sta, val, msg}` no escopo da chamada; `_op_emit` preenche o frame corrente; `_op_ret` devolve o frame à pilha do chamador (topo de pilha vira o struct, sem POP).
- `_op_store` passa a declarar no escopo local (sem vazar para o externo) — corrige shadowing.
- `ExpressionStmt` e chamada-em-statement: após avaliar, `POP` do valor (efeito colateral preservado).
- **Alternativa descartada:** pilha de frames separada no runtime (registros `CALLFRAME`) — equivalente, mas exigiria mudanças em opcodes; frame na pilha reaproveita `PUSH`/`POP` existentes.

### D4. LLVM: struct de retorno tipado, sem globals
- Funções viram `{i1, i64, i8*}` (status, val, msg): `_compile_function` remove params `["i64"]*n` forçados e globals; `emit` monta o struct; retorno direto.
- Strings: litrais continuam em `private unnamed_addr constant`; `msg` é `i8*` para o literal (strings interpoladas permanecem gap documentado, como hoje).
- Divisão por zero: substituir o `add 0,0` por `{i1 0, i64 <divisor>, i8* @msg}` via bloco de fail (paridade com o interpreter: `val` = divisor).
- `_gen_call` remove o fallback `("0","i64")` — node desconhecido vira erro explícito.

### D5. WAT/WASM: frame no struct de retorno, sem globals
- Assinatura de função muda de `[]` para `(result i32 i64 i32)` (WAT) / `[I32, I64, I32]` (WASM): `sta` (ptr da string), `val` (i64), `msg` (ptr).
- `sta`/`msg` são ponteiros para `data` strings (`"nice"`/`"fail"`/mensagem); o chamador materializa o struct por acesso direto aos 3 valores da pilha WASM (sem heap de struct).
- Remoção de `_result_globals` e de `(global.set $__flux_result_*)`.
- Divisão por zero: gravar status `fail` no valor retornado (i32/i64/i32), não em globals; o `i64.div_s` segue executando com `unreachable` apenas quando o erro não é capturável — decisão de paridade: o interpreter produz `fail` observável, então o backend deve devolver o frame `fail`, nunca trap.
- `_gen_call`/`_gen_expr` removem fallback `("0","i64")`/`i64.const 0` para nós não suportados → `WasmError`/`WatError` explícito.

### D6. Zero placeholders — erro explícito
Todo caminho que hoje mascara resultado vira erro: `_eval` interpreter (nó não suportado → erro, não `Value("void")`), compiler VM (`PUSH 0` para expr desconhecida), codegen LLVM/WAT/WASM (node desconhecido → exceção com nome do node). Sem exceção silenciosa em runtime.

### D7. Verificação por gate de paridade
- Novo `flux/ExampleOfFunctionParity.flux`: função com chamadas aninhadas (`soma(quadrado(x), cubo(x))`), `.val` tipado, divisão por zero (frame `fail` com `val`=divisor), e recursão (`fatorial`). Saída idêntica nos 5 backends via `backend_compliance.py` e `flux_verify.py`.
- `test_llvm_globals.py` reescrito para assinar contra o novo IR (sem globals).

## Risks / Trade-offs

- **Strings de mensagem** (LLVM/WAT/WASM) → Transportar `msg` como ponteiro de literal; strings interpoladas continuam gap documentado (nenhum backend as suporta em `emit` hoje).
- **Trap vs. fail observável na divisão por zero** → Risco de o WAT/WASM cair em `unreachable` se o layout da pilha divergir; mitigação: frame `fail` retornado antes do `div_s` (check explícito), alinhado ao interpreter; `unreachable` fica apenas para invariantes internas.
- **Região de pilha WASM (return pointer)** → Não usamos memória linear além de `data` strings; struct via 3 valores na pilha de valores (não na memória), eliminando risco de gestão de memória.
- **Alteração de assinatura quebra IRs/dumps existentes** (`intermediates/`, `t_*`) → Regenerados pelo gate; `test_llvm_globals.py` é o único teste que inspeciona IR e será reescrito.
- **Recursão profunda** → Depende da pilha do runtime/estado (como no interpreter); sem profundidade garantida, igual aos demais backends.

## Migration Plan

1. Fase VM (independe dos demais): opcodes/runtime/compiler + testes VM + exemplo parity rodando em interpreter e VM.
2. Fase LLVM: IR novo + teste IR + exemplo parity em LLVM.
3. Fase WAT/WASM: assinaturas novas + exemplos parity + `flux_verify.py`.
4. Gate completo (5 backends) verde; remoção final dos fallbacks restantes; docs/erros.md atualizado.
5. Rollback: cada fase é um commit isolado; o gate falha acusa a fase exata.

## Open Questions

- Nenhuma em aberto; decisões de escopo (`use`/imports fora, interpreter como referência) já confirmadas.
