## Context

O short-circuit é hoje pré-fixado: `? <expr> { fail(v) ==> { corpo } nice(n) ==> { corpo } }`. A tabela de precedência já lista `?` como pós-fixo, mas a regra EBNF e o parser o tratam como prefixo. Os arquivos canônicos editados pelo usuário (`docs/keywords/KW_short_circuit.yaml` e `flux/ExampleOfShortCircuit.flux`) definem o alvo: `<expr> ? { ==> emit(fail, v, msg) ==> emit(nice, v, msg) }` — braços anônimos sem binding e sem corpo. Além da sintaxe, a semântica ganha um modelo de status unificado: falha = `fail`/`false`/operação matemática inválida; sucesso = `nice`/`true`/qualquer outro valor. Hoje, divisão por zero em `/i`/`/r` aborta (ZeroDivisionError no interpreter, trap no wasm).

## Goals / Non-Goals

**Goals:**
- Parser reconhece `?` somente pós-fixado, com braços anônimos `==> emit(status, id, msg)`.
- Despacho por status: `fail`/`false`/mat inválida → braço fail; `nice`/`true`/outros → braço nice; sem reavaliar a expressão.
- `/i` e `/r` por zero produzem status fail por injeção de código nos 5 backends (não abortam).
- Atribuição `V = expr ? {...}` liga `expr` a `V` antes dos braços (braços podem referenciar `V`) e atribui o struct do braço a `V`.
- Docs e exemplo `flux/ExampleOfShortCircuit.flux` coerentes; `backend_compliance.py` verde.

**Non-Goals:**
- Não mudar a sintaxe do `emit` nem dos campos `.sta/.val/.msg`.
- Não alterar `catch`/`fallback`/`ensure`.
- Não introduzir status para outros erros aritméticos além de `/i` e `/r` por zero (ex.: overflow).

## Decisions

**D1 — Hook pós-fixado no parser.** `?` é tratado no fim de `parse_primary_postfix_expr` (após o loop de pós-fixos): se o próximo token é `QUESTION`, consome `?`, EOL opcional, `{`, braços, `}` e embrulha o nó em `ShortCircuitBlock`. Remover a interceptação de `QUESTION` em `parse_prefix_expr` e o `?` do conjunto de unários.
- *Alternativa:* checar `?` no topo da hierarquia de precedência — rejeitada: `?` tem precedência pós-fixa (tabela já o lista assim) e o exemplo agrupa com parênteses (`(a /i b) ?`).

**D2 — Novo AST de braço.** `ShortCircuitArm(var, body)` vira `ShortCircuitArm(status: str, value: str, message: ASTNode)`; `ShortCircuitBlock` mantém `expr`, `fail_arm`, `nice_arm`. Nenhuma variável de braço é declarada.

**D3 — Classificação de status centralizada.** Cada backend expõe um predicado `is_fail(value)`: struct com `type_name == "fail"` (ou `.sta`), booleano `false`, ou valor marcado como fail por operação inválida. Todo o resto é nice. No interpreter, um helper único; nas codegens, um branch injetado por tipo do operando (o compilador conhece o tipo estático).

**D4 — Injeção de zero-check em `/i`/`/r`.** Cada backend injeta verificação do divisor antes de dividir:
- Interpreter/VM: checar `b == 0` e produzir `Value(type_name="fail", data=b, message="divisao por zero")` em vez de levantar ZeroDivisionError.
- WASM/WAT: branch explícito `i64.eqz`/`if` em vez de confiar no trap do `i64.div_s/rem_s`.
- LLVM: `icmp eq b, 0` + select para o valor fail.
A injeção é global (dentro e fora de `?`), conforme a diretiva do usuário: toda operação matemática inválida gera fail.

**D5 — Binding da variável alvo (Modelo B).** Em `V = expr ? {...}`, o valor de `expr` é ligado a `V` antes dos braços (na VM: STORE antes do despacho; nos demais, equivalente); os braços podem referenciar `V` (valor bruto). O valor final do bloco (struct do emit do braço) é atribuído a `V`. Fora de atribuição, braços referenciam apenas o escopo envolvente.
- *Alternativa:* ligar só depois (semântica de atribuição normal) — rejeitada porque o exemplo canônico (`emit(nice, resultado, ...)`) exige `resultado` visível nos braços.

**D6 — Despacho booleano.** Bool `false` → braço fail; `true` → braço nice. Nas codegens, valores i64 0/1 classificam diretamente.

**D7 — Semântico intocado.** O semântico percorre o AST genericamente; `emit_check` já trata `emit` terminal. Apenas verificar que o nó novo não quebra travessias (campos renomeados em `ShortCircuitArm`).

## Risks / Trade-offs

- [Mudança global de `/i` por zero altera comportamento fora do `?`] → Mitigação: teste da suíte existente que espere ZeroDivisionError será atualizado para o novo contrato (status fail), e `backend_compliance.py` valida os 5 backends.
- [Reaproveitamento da representação de struct de emit no wasm/wat/llvm para o fail injetado] → Mitigação: reutilizar o mesmo caminho de código do `emit(fail, ...)` já existente em cada backend (padrão emit-result-fields).
- [`print(dividir(10, 2))` imprime `.val` do struct (5) e não o struct] → Mitigação: comportamento herdado do print de Value (imprime `.data`); documentar no exemplo.
- [Braços anônimos com identificador não declarado] → Erro do semântico já existente para `emit` com variável inexistente se aplica.

## Migration Plan

1. Parser + AST primeiro (programa compila de novo).
2. Interpreter (fonte de verdade rápida para testes).
3. VM, depois LLVM/WAT/WASM.
4. Docs (`TheFlux.ebnf`, `TheFlux.md`, `grammar.md`, `KW_short_circuit.yaml`, `exemplos.md`, `erros.md`).
5. Exemplo + testes + `backend_compliance.py`.

## Open Questions

- Nenhum bloqueante. Mensagem do fail injetado fixada em `"divisao por zero"` e `.val` = denominador (os braços do `?` sobrepõem de qualquer forma).
