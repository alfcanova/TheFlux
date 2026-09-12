## Why

O operador short-circuit é hoje pré-fixado (`? <expressão> { fail(v) ==> {...} nice(n) ==> {...} }`), o que quebra a fluidez natural de leitura (a expressão é o sujeito, o `?` é o operador). A documentação de precedência já lista `?` como pós-fixo, mas a regra gramatical e o parser tratam como prefixo. O objetivo é alinhar sintaxe e implementação: `<expressão> ? { ==> emit(...) ... }`, com braços anônimos `==> emit(...)` em vez de braços com binding `fail(v) ==> { corpo }`.

## What Changes

- **BREAKING** — Mover o `?` de operador pré-fixado para pós-fixado:
  - De: `? <expressão> { fail(v) ==> {...} nice(n) ==> {...} }`
  - Para: `<expressão> ? { ==> emit(fail, variável, mensagem) ==> emit(nice, variável, mensagem) }`
- Remover o binding `fail(v)`/`nice(n)` (variável de braço com escopo próprio) e os corpos de bloco dos braços; os braços passam a ser statements `emit` anônimos despachados conforme `.sta` do struct resultante.
- Remover `?` da lista de operadores unários de prefixo na gramática (passa a existir somente como operador pós-fixado do bloco short-circuit).
- Atualizar parser (reconhecimento pós-fixado), AST (`ShortCircuitArm` passa de `var+body` para status/value/message do emit), e os 5 backends (interpreter, VM, LLVM, WAT, WASM) para a nova semântica.
- Atualizar documentação (`docs/TheFlux.ebnf`, `docs/TheFlux.md`, `docs/grammar.md`, `docs/keywords/KW_short_circuit.yaml`, `docs/exemplos.md`, `docs/erros.md`).
- Garantir que `flux/ExampleOfShortCircuit.flux` (já no formato pós-fixado) compile e rode nos backends.
- **BREAKING** — `?` no início de expressão passa a ser erro de sintaxe.

## Capabilities

### New Capabilities
- `short-circuit-postfix`: operador short-circuit pós-fixado `<expressão> ? { ==> emit(fail, v, msg) ==> emit(nice, v, msg) }`, despacho por `.sta` do struct de resultado sem reavaliar a expressão, e remoção do `?` prefixo.

### Modified Capabilities
<!-- Nenhuma spec existente em openspec/specs/ é alterada; o requisito "Bloco `?` short-circuit preservado" do delta emit-result-fields é substituído por esta capability. -->

## Impact

- `src/flux_proto/parser/expressions.py`: remover interceptação de `?` em `parse_prefix_expr`; adicionar hook pós-fixo em `parse_primary_postfix_expr`.
- `src/flux_proto/parser/ast.py`: refazer `ShortCircuitArm`.
- Backends: `src/flux_proto/interpreter/interpreter.py` (`_exec_short_circuit`), `src/flux_proto/vm/compiler.py` (`_compile_short_circuit`), `src/flux_proto/wasm/codegen.py` (`_gen_short_circuit`, `_bind_sc_arm`), `src/flux_proto/llvm/codegen.py` (`_gen_short_circuit`, `_bind_sc_arm`), `src/flux_proto/wat/codegen.py` (`_gen_short_circuit`, `_bind_sc_arm`).
- Docs: `docs/TheFlux.ebnf`, `docs/TheFlux.md`, `docs/grammar.md`, `docs/keywords/KW_short_circuit.yaml`, `docs/exemplos.md`, `docs/erros.md`.
- Exemplo: `flux/ExampleOfShortCircuit.flux` (já editado manualmente para a forma alvo).
- Testes: novo teste de parser (forma pós-fixada; `?` prefixo rejeitado) e validação com `backend_compliance.py`.
- Semântico: nenhuma alteração estrutural (o AST continua sendo percorrido genericamente).
