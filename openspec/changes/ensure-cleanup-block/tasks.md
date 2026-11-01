## 1. Documentação

- [ ] 1.1 `docs/TheFlux.md` + `docs/TheFlux.ebnf:571`: `postfix_ensure_clause = "ensure" , "{" , { function_statement } , "}" ;` (remover `primary_base`)
- [ ] 1.2 Corrigir exemplos 568-570 e 588: `ensure fechar()` → `ensure { fechar() }`
- [ ] 1.3 `docs/grammar.md`: nota semântica em `ensure_suffix` (740) e comentário 535-538 — preserva valor/tipo do alvo, sempre executa, falha propaga
- [ ] 1.4 `docs/keywords/KW_ensure.yaml`: adicionar restrição "tipo do resultado = tipo da expressão alvo"
- [ ] 1.5 `docs/erros.md` H1: marcar obsoleto/resolvido (forma inline não existe; forma é bloco)

## 2. Semântico

- [ ] 2.1 `src/flux_proto/semantic/types.py` `_infer_binary_op`: special-case `op == "ensure"` → tipo = `_infer(node.left)` (não inferir bloco)
- [ ] 2.2 Testes semantic (tipo do alvo preservado; bloco não tipa)

## 3. Interpreter

- [ ] 3.1 `interpreter.py` `_eval_binary_op`: `op == "ensure"` → avalia alvo, executa bloco (try/finally), retorna valor do alvo; falha ABI (`type_name == "fail"`) preservada após bloco
- [ ] 3.2 Testes interpreter: sucesso preservando valor, alvo falha + bloco roda, falha do bloco propaga

## 4. VM

- [ ] 4.1 `vm/compiler.py:198` `BinaryOp`: compilar ensure — valor do alvo preservado em slot/temp durante corpo
- [ ] 4.2 `vm/runtime.py`: suporte à operação (sem desempilhar alvo)
- [ ] 4.3 Testes vm

## 5. LLVM

- [ ] 5.1 `llvm/codegen.py`: eval alvo → register/temp; corpo bloco; resultado do alvo; checagem de falha (`sta`) após bloco
- [ ] 5.2 Testes llvm (multitarget)

## 6. WAT / WASM

- [ ] 6.1 `wat/codegen.py` + `wasm/codegen.py`: stack/local preserva valor do alvo; corpo executa; resultado no topo; layout ABI `{sta,val,msg}` respeitado
- [ ] 6.2 Testes wat/wasm (multitarget)

## 7. Integração

- [ ] 7.1 Teste ponta-a-ponta no padrão do exemplo: `arquivo.lerTexto() ensure { arquivo.fechar(); print("liberado") }` → valor original retornado
- [ ] 7.2 Rodar `flux/ExampleOfEnsure.flux` nos backends (interpreter, vm, wat, wasm, llvm)