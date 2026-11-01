## Context

`ensure` é parseado como `BinaryOp(op="ensure", left=<expr>, right=BlockStmt)` (`expressions.py:214`) dentro do loop de pós-fixos (nível 17). Nenhum backend o executa. A ABI de retorno de função é struct `{ sta, val, msg }` (change `function-abi-result-frames`); falha = `sta == "fail"`. Docs divergem sobre a forma: EBNF antiga `ensure primary_base` vs parser/grammar.md/KW_ensure.yaml `ensure { bloco }`.

## Goals / Non-Goals

**Goals:**
- `expr ensure { bloco }`: bloco cleanup sempre executa após avaliar `expr`; resultado = valor de `expr` (mesmo tipo).
- Falha do alvo ou do bloco propaga após o bloco; bloco não engolido.
- Suporte em Semantic, Interpreter, VM, LLVM, WAT, WASM.
- Documentação alinhada (EBNF, grammar.md, KW_ensure.yaml, erros.md H1).

**Non-Goals:**
- Não introduzir `ensure <expressão>` inline (sem bloco) — forma única `ensure { bloco }`.
- Não implementar `defer`/escopo de função geral; apenas o operador pós-fixo.
- Não executar o bloco em branch paralelo/async.

## Decisions

### D1 — Resultado = valor do alvo, preservado
- `eval(left)` primeiro → `v`. Bloco roda em seguida (sem reavaliação do alvo). Expressão inteira retorna `v`. Tipo = `_infer(left)`.
- Interpreter: `v = eval(left); try: exec(bloco); finally: return v` (preservando exceção do bloco).
- Falha do alvo (Value com `type_name == "fail"`) → bloco roda e falha continua como resultado.

### D2 — Bloco não tipa a expressão
- Semantic `_infer_binary_op` (`types.py:204`): `if node.op == "ensure": return self._infer(node.left)`. Bloco é corpo de statements (validação de declarações já coberta pelo analyzer; `_infer(BlockStmt)` não deve ser chamado).

### D3 — Codegen por backend
- VM: `eval` do alvo deixa valor na pilha → salvar em slot temp → corpo bloco → restaurar valor (ou usar top-of-stack preservado: corpo em scope próprio não desempilha o alvo).
- LLVM: register/alloc temporário com o valor do alvo; bloco emitido antes do ponto de retorno/uso; falha `%flux.result` (`sta`) checada APÓS o bloco.
- WAT/WASM: stack com valor do alvo preservado abaixo do frame do corpo (ou local `$__ensure_*`); corpo executa; resultado do alvo retorna no topo. Respeitar layout `{i32,i64,i32}` do frame ABI.

### D4 — Docs
- `postfix_ensure_clause = "ensure" , "{" , { function_statement } , "}" ;` em TheFlux.ebnf/TheFlux.md (substituir `primary_base`); exemplos `ensure { fechar() }`.
- grammar.md:740 já correto — adicionar nota: preserva valor/tipo do alvo, sempre executa, falha propaga.
- KW_ensure.yaml: adicionar restrição "tipo do resultado = tipo da expressão alvo".
- erros.md H1 → marcado obsoleto/resolvido (forma inline `ensure <expr>` não existe).