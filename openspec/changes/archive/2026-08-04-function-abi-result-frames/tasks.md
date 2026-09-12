## 1. Base de verificação

- [x] 1.1 Criar `flux/ExampleOfFunctionParity.flux` com chamadas aninhadas (`soma(quadrado(x), cubo(x))`), `.val` tipado, divisão por zero capturada e recursão (`fatorial`); conferir saída esperada no interpreter
- [x] 1.2 Rodar `backend_compliance.py` para registrar o estado atual (esperado: função quebra em VM/LLVM/WAT/WASM) e confirmar baseline do interpreter

## 2. VM: frame de resultado por chamada

- [x] 2.1 `vm/opcodes.py`: adicionar opcode `POP` (e `DECLARE` se necessário) para limpeza de pilha e declaração local
- [x] 2.2 `vm/runtime.py`: `_op_call` passa a aceitar endereço de função e aloca frame `{sta, val, msg}` por chamada; `_op_ret` devolve o frame ao chamador; `_op_store` não vaza escopo externo
- [x] 2.3 `vm/runtime.py`: `_op_emit` preenche o frame corrente; divisão por zero continua `fail` com `val` = divisor (paridade já existente)
- [x] 2.4 `vm/compiler.py`: `_compile_call` emite `CALL <addr>` da função (não só literal); `ExpressionStmt` e chamada-em-statement fazem `POP`; remover `PUSH 0` para expr desconhecida (erro explícito)
- [x] 2.5 Testes: funções aninhadas, recursão e `.val` tipado na VM idênticos ao interpreter (novo teste em `src/flux_tests/vm/` + exemplos no gate)

## 3. LLVM: struct de retorno sem globals

- [x] 3.1 `llvm/codegen.py`: `_compile_function` com params tipados e retorno `{i1, i64, i8*}`; `emit` monta struct e retorna; remover globals `@__flux_result_*`
- [x] 3.2 `llvm/codegen.py`: `_gen_call` sem fallback `("0","i64")` (erro explícito); divisão por zero via bloco de fail com `val` = divisor (substituir `add 0,0`)
- [x] 3.3 Reescrita de `src/flux_tests/compliance/test_llvm_globals.py` para o IR novo (sem `__flux_result_*`, assinatura com struct)
- [x] 3.4 Validar: `ExampleOfFunctionParity.flux` em LLVM idêntico ao interpreter; `intermediates/llvm` regenerado

## 4. WAT/WASM: struct de retorno sem globals

- [x] 4.1 `wat/codegen.py`: assinatura de função `(result i32 i64 i32)`; `_gen_call` consume 3 valores; remover `$__flux_result_*` e fallback `("0","i32")`
- [x] 4.2 `wat/codegen.py`: divisão por zero devolve frame `fail` (sta ptr `"fail"`, val = divisor, msg) sem globals; `_infer_type` com `.val` tipado
- [x] 4.3 `wasm/codegen.py`: assinatura `[I32, I64, I32]`; remover `_result_globals` e `i64.const 0` para nós não suportados; divisão por zero → frame `fail`
- [x] 4.4 Validar: `flux_verify.py` (wat2wasm, wasm-validate, wasmer) com `ExampleOfFunctionParity.flux`; WAT e WASM idênticos ao interpreter

## 5. Interpreter: zero placeholders

- [x] 5.1 `interpreter/interpreter.py`: `_eval` lança erro explícito para nó não suportado (remover `Value("void")` silencioso)
- [x] 5.2 Confirmar que `ExampleOfFunction.flux`, `ExampleOfResult.flux` e `ExampleOfShortCircuit.flux` seguem idênticos no interpreter (sem regressão)

## 6. Gate de paridade final

- [x] 6.1 `backend_compliance.py`: incluir `ExampleOfFunctionParity.flux` na varredura (sem STDIN) e garantir `STDIN_MAP` intacto
- [x] 6.2 Rodar gate completo: 5 backends verdes em todos os exemplos; `flux_verify.py` verde
- [x] 6.3 Atualizar `docs/erros.md` (gaps B1/B2 emit e placeholders removidos) e `docs/exemplos.md` se aplicável
- [x] 6.4 Rodar suíte `src/flux_tests/` completa (parser/semantic/interpreter/vm/multitarget) sem regressões

## 7. Encerramento

- [x] 7.1 Revisar o diff contra o design (D1–D7) e a spec (nenhum global de resultado remanescente em LLVM/WAT/WASM)
- [x] 7.2 Rodar `openspec status --change function-abi-result-frames` e arquivar a mudança
