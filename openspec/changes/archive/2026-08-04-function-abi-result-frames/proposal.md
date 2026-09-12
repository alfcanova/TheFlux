## Why

Chamada de função definida pelo usuário funciona hoje apenas no interpreter. Nos backends VM/LLVM/WAT/WASM o resultado é transportado por globais não reentrantes (`@__flux_result_sta/val/vald/msg` no LLVM, `$__flux_result_*` no WAT/WASM) e por um `_op_call` da VM que só aceita endereço literal — chamadas aninhadas corrompem o resultado, recursão é impossível, e fallbacks silenciosos (`("0","i64")`, `Value("void")`) mascaram o que não foi implementado. O interpreter (`emit` terminal + struct `{sta,val,msg}`) é a referência correta e permanece intocado.

## What Changes

- Novo **ABI de função com frame de resultado por chamada** nos backends VM, LLVM, WAT e WASM; o interpreter não muda.
- **BREAKING (implementação, sem mudança de sintaxe):** remoção de todos os globais de resultado não reentrantes (`@__flux_result_*`, `$__flux_result_*`) e de todo placeholder que mascare resultado (`("0","i64")` em LLVM/WAT/WASM, `Value("void")` no interpreter, PUSH 0 no compiler VM). Tudo que não for implementável passa a levantar erro explícito.
- VM: `CALL` passa a aceitar endereço de função (não só literal); frame local por chamada (`sta/val/msg`) com `RET` devolvendo o frame ao chamador; `ExpressionStmt`/chamada em statement fazem POP da pilha; `_op_store` para de vazar escopo externo.
- LLVM: assinatura de função com retorno tipado real (struct `{i1 status, i64 val, i8* msg}` ou equivalente); params com tipos reais; strings como ponteiros de dados; sem globals.
- WAT/WASM: mesmo modelo de frame; strings no `data` segment; `unreachable`/`i64.div_s` sinalizando erro em vez de gravar globals.
- Recursão (direta e indireta) passa a funcionar nos 4 backends.
- Gate de paridade (`backend_compliance.py` + `flux_verify.py`) estendido com exemplo que exercita chamadas aninhadas, `.val` tipado e recursão, exigindo saída idêntica aos 5 backends.
- `src/flux_tests/compliance/test_llvm_globals.py` reescrito (deixou de refletir o comportamento após a remoção dos globals).

## Capabilities

### New Capabilities
- `function-abi-result-frames`: chamada de função com frame de resultado por invocação nos backends VM/LLVM/WAT/WASM — chamadas aninhadas e recursão preservam cada resultado, sem placeholders.

### Modified Capabilities
<!-- Nenhuma spec consolidada existente é alterada: short-circuit-postfix não muda; emit-result-fields está arquivada. -->

## Impact

- **VM:** `src/flux_proto/vm/compiler.py` (`_compile_call`, `_compile_statement`, `_compile_expr`, `_compile_function`), `src/flux_proto/vm/runtime.py` (`_op_call`, `_op_ret`, `_op_store`, `_op_emit`), `src/flux_proto/vm/opcodes.py` (possivelmente `DECLARE`/`POP`).
- **LLVM:** `src/flux_proto/llvm/codegen.py` (`_compile_function`, `_gen_call`, `_gen_emit`, divisão por zero).
- **WAT:** `src/flux_proto/wat/codegen.py` (`_gen_call`, `_emit_user_function`, `_infer_type`).
- **WASM:** `src/flux_proto/wasm/codegen.py` (`_result_globals`, `_gen_call`, `_compile_function`).
- **Interpreter:** apenas remoção do `Value("void")` silencioso em `_eval` (erro explícito no lugar).
- **Exemplos:** `flux/ExampleOfFunction.flux` (já usa `.val`), novo `flux/ExampleOfFunctionParity.flux`.
- **Testes/gate:** `backend_compliance.py`, `flux_verify.py`, `src/flux_tests/compliance/test_llvm_globals.py`, `src/flux_tests/**`.
- **Docs:** `docs/erros.md` (gaps B1/B2 atualizados).

Formato de exemplo: `function (fatorial) (n: int64) as int64 { ... emit(nice, resultado, "ok") }` → `r = fatorial(5)`; recursão `fatorial(n-1)` devolve o próprio struct.
