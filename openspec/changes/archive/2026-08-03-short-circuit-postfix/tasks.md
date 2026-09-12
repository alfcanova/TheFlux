## 1. Parser e AST

- [x] 1.1 Refazer `ShortCircuitArm` em `src/flux_proto/parser/ast.py`: de `(var, body)` para `(status, value, message)`; `ShortCircuitBlock` mantém `expr`, `fail_arm`, `nice_arm`
- [x] 1.2 Em `src/flux_proto/parser/expressions.py`: remover interceptação de `QUESTION` em `parse_prefix_expr` e o `?` do conjunto de unários
- [x] 1.3 Em `parse_primary_postfix_expr`: adicionar hook pós-fixado — se `QUESTION`, consumir `?`, EOL opcional, `{`, braços `==> emit(fail, id, msg)` e `==> emit(nice, id, msg)` (nessa ordem, ambos obrigatórios), `}` → `ShortCircuitBlock(expr=node, ...)`
- [x] 1.4 Verificar que `parse_short_circuit_block` antigo é removido/substituído e que `parse_statement` continua aceitando o bloco como statement

## 2. Interpreter

- [x] 2.1 Reescrever `_exec_short_circuit` em `src/flux_proto/interpreter/interpreter.py`: classificar status (fail se `.sta == "fail"`, bool false, ou valor fail de operação inválida; senão nice) e avaliar o emit do braço selecionado (sem binding de variável de braço)
- [x] 2.2 Implementar Modelo B: em atribuição `V = expr ? {...}`, ligar `expr` a `V` antes dos braços e atribuir o struct do braço a `V` no final
- [x] 2.3 `/i` e `/r` por zero: produzir `Value(type_name="fail", data=denominador, message="divisao por zero")` em vez de `ZeroDivisionError`

## 3. VM

- [x] 3.1 Reescrever `_compile_short_circuit` em `src/flux_proto/vm/compiler.py`: despacho por status (incluindo bool false e valor fail injetado), braços como emit
- [x] 3.2 Modelo B na VM: STORE do valor da expressão antes do despacho (contexto de atribuição) e STORE final do struct do braço
- [x] 3.3 Injetar zero-check em IDIV/REM no compiler (ou runtime) para produzir struct fail em vez de erro

## 4. LLVM / WAT / WASM

- [x] 4.1 Reescrever `_gen_short_circuit`/`_bind_sc_arm` em `src/flux_proto/llvm/codegen.py`: despacho por status e braços como emit
- [x] 4.2 Reescrever `_gen_short_circuit`/`_bind_sc_arm` em `src/flux_proto/wat/codegen.py`
- [x] 4.3 Reescrever `_gen_short_circuit`/`_bind_sc_arm` em `src/flux_proto/wasm/codegen.py`
- [x] 4.4 Modelo B nos três codegens (ligar valor da expressão antes dos braços na atribuição)
- [x] 4.5 Injetar zero-check em `/i` e `/r` (LLVM: icmp+select; WAT/WASM: branch `i64.eqz`/`if` em vez de trap) reutilizando a representação de struct de emit existente

## 5. Documentação

- [x] 5.1 `docs/TheFlux.ebnf`: `short_circuit_block = expression , "?" , eol , "{" , arms , "}"`; braços `==> emit(...)`; remover `?` e `short_circuit_block` de `prefix_expr`
- [x] 5.2 `docs/TheFlux.md`: espelhar as mesmas alterações
- [x] 5.3 `docs/grammar.md`: mesma regra; mover `short_circuit_block` para pós-fixo; remover `?` do unário prefixo; atualizar comentário de propagação de erro
- [x] 5.4 `docs/keywords/KW_short_circuit.yaml`: Syntax e exemplos na forma `<expressão> ? { ==> emit(...) }`
- [x] 5.5 `docs/exemplos.md` e `docs/erros.md`: atualizar exemplos e descrição do bloco `?`

## 6. Exemplo e testes

- [x] 6.1 Validar `flux/ExampleOfShortCircuit.flux` (formato pós-fixado) compila e roda nos 5 backends
- [x] 6.2 Adicionar testes de parser: forma pós-fixada → `ShortCircuitBlock`; `?` prefixo → erro; braços ausentes/fora de ordem → erro
- [x] 6.3 Adicionar testes de interpreter: despacho booleano (false→fail, true→nice), valor aritmético válido→nice, divisão por zero→fail (dentro e fora do `?`), Modelo B na atribuição, campos `.sta/.val/.msg` do bloco
- [x] 6.4 Rodar suíte completa (`python -m pytest src/flux_tests`) e `python backend_compliance.py`; atualizar testes existentes afetados pela mudança global de `/i`/`/r` por zero
