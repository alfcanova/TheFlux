## Context

A linguagem termina funções com `emit(status, variables..., message)` (statement terminal, verificado por `check_emit_terminals`). Hoje a runtime preserva apenas `status` e o valor; a **message é descartada** em `interpreter.py:302-307` e `vm/runtime.py:160-166`, e os backends LLVM/WAT/WASM nem possuem codegen de chamada de função definida pelo usuário (`_gen_call` só trata `print`/`println` e devolve constante). A linguagem não tem "record"/"tupla"; o vocabulário de tipos é `struct`, `enum`, `list`, `set`, `data`, `map`, `tensor`.

O objetivo é dar ao chamador um retorno nomeado de três campos sobre `emit`, usando o único construtor que já oferece acesso por campo nomeado: o `struct`.

## Goals / Non-Goals

**Goals:**
- `emit` vira um único contrato: `emit(status, <identificador>, <string/interpolated>)` com os três campos sempre presentes (sem campos vazios).
- Retorno da chamada = struct implícito de sistema com `.sta` (string), `.val` (tipo derivado do `as` da função), `.msg` (string).
- Acesso via `FieldAccess` existente e via `?` short-circuit (sem reavaliação).
- Todos os backends (Interpreter, VM, LLVM, WAT/WASM) carregam e expõem os 3 campos.

**Non-Goals:**
- Não introduzir tipo novo (`record`/`tuple`/`result`) — modela-se como struct de sistema.
- Não aceitar expressão no slot `value` do `emit` (restrito a identificador).
- Não implementar sistema de tipos completo do LLVM/WAT/WASM; apenas o contrato de resultado de 3 campos.

## Decisions

### D1 — `emit` é o único terminal; `fail` vira status, não statement
- No EBNF, `function_body` termina em `emit_statement`; o parser nunca produz `FailStmt` a partir de texto (só existe em ASTs de mão em testes). `fail` já é um status de `emit` e um braço do short-circuit.
- **Decisão:** retirar `FailStmt` do caminho de emissão; "fail" vira apenas o status `emit(fail, <id>, <msg>)`. O retorno de falha mantém status, valor e message — nenhum campo vazio.
- Alternativa considerada: manter `FailStmt` com `.value` vazio — descartada por violar a invariante "nenhum campo vazio".

### D2 — Representação do struct de resultado no interpreter
- `Value` (interpreter/environment.py:32) ganha campos:
  ```python
  @dataclass
  class Value:
      type_name: str = ""   # "nice"/"fail" ao transportar resultado; senão o tipo normal
      data: Any = None      # valor único emitido (.val)
      message: str = ""     # mensagem do emit (.msg)
      value_type: str = ""  # tipo estático de .val (do "as" da função)
  ```
- `type_name` mantém `"nice"`/`"fail"` para preservar o teste existente do short-circuit (`is_fail = val.type_name == "fail"`, interpreter.py:311).
- `_exec_emit` (interpreter.py:302) monta `Value(type_name=status, data=<data do identificador>, message=<mensagem>)`.
- `_exec_function` (interpreter.py:191) preenche `value_type` a partir do `return_type` da `FunctionDef`.
- `FailStmt` é substituído pelo fluxo `emit(fail, ...)`; `_exec_fail` passa a devolver o mesmo contrato.

### D3 — Acesso `.sta`, `.val`, `.msg`
- `_eval_field_access` (interpreter.py:335) ganha um ramo: se `obj.type_name ∈ {"nice", "fail", "emit"}`:
  - `.sta` → `Value(type_name="string", data=obj.type_name)`
  - `.val` → `Value(type_name=obj.value_type or obj.type_name, data=obj.data)`
  - `.msg` → `Value(type_name="string", data=obj.message)`
  - outro campo → `InterpreterError`
- `postfix_dot_access` já aceita `generic_lower_identifier`, e `sta`/`val`/`msg` são identificadores válidos — sem mudança de gramática de expressão.
- Alternativa considerada: `.1/.2/.3` posicional — descartada por dupla avaliação, legibilidade ruim e campos obrigatórios de aridade variável.

### D4 — VM (vm/compiler.py:105, vm/runtime.py:160)
- `Op.EMIT` deixa de carregar `count` de variáveis; `_compile_statement` compila o identificador único e a mensagem, depois `self._emit(Op.EMIT, node.status)`.
- `_op_emit` empurra um dict-like na convenção já usada por `_op_make_struct`/`_op_field_access`: `{"sta": <status>, "val": <valor>, "msg": <msg>}`. Logo `r.sta`/`r.val`/`r.msg` funcionam sem op novo.
- `_op_fail` é removido (fail vira `Op.EMIT` com status `"fail"`).

### D5 — LLVM (src/flux_proto/llvm/codegen.py)
- Função devolve um struct de resultado: `%flux.result = type { i32, i64, i8* }` (sta, val, msg).
- `_gen_call` (llvm:438) deixa de retornar constante; gera a chamada e materializa o struct; `.sta/.val/.msg` viram loads nos campos.

### D6 — WAT/WASM (wat/codegen.py, wasm/codegen.py)
- Audit: esses backends hoje só codem `_start`/storages/print/route/infinite; `_gen_call` só trata print. Não há codegen de `FunctionDef` nem de `EmitStmt`.
- Implementar codegen de função que retorna o struct de resultado (3 slots) e expor acesso nomeado aos campos: layout fixo na memória exportada ou multi-value do WASM.
- Simplificação: valor tratado como `i64` genérico e message como ponteiro/offset de string na memória.

## Risks / Trade-offs

- **BREAKING — AST/APIs:** `EmitStmt.variables: list[str]` → `EmitStmt.value: str`; testes que instanciam `EmitStmt(status=..., variables=[...])` miggram em lote e `FailStmt` deixa de ser terminal. → Mitigação: localizar com `git grep` e atualizar as suítes junto do mesmo change.
- **BREAKING — Grammar:** `emit` sem variável ou sem mensagem deixa de ser válido → Mitigação: diagnósticos semânticos claros (EMC-101/EMC-102).
- **Função sem `as`:** `.val` precisa de tipo estático; sem `as` declarado o campo fica vazio → Mitigação: novo diagnóstico exigindo `as` em função que emite.
- **Codegen de função ausente em LLVM/WAT/WASM:** o escopo nesses backends cresce (call/return de usuário). → Mitigação: manter o contrato genérico (i64+i64+i8*) e validar com `t_llvm`, `t_wat-1.0`, `t_wasm-1.0`.

## Migration Plan

1. Grammar + docs (`docs/TheFlux.md`, `exemplos.md`, `erros.md`).
2. Núcleo interpreter: `Value.message`, `_exec_emit`, `_exec_fail` em rotina, field access.
3. AST/parser/semânt– `EmitStmt.value`, `parse_emit_stmt`, novos diagnósticos.
4. Migração de testes do interpreter/VM; depois VM runtime; depois LLVM, WAT, WASM.
5. Regressão: `pytest` + `flux_verify.py` e baseline multitarget (`t_vm`, `t_llvm`, `t_wat-1.0`, `t_wasm-1.0`).

## Open Questions

- Exigir `as <tipo>` em toda função que termina em `emit` (para tipar `.val`) — decisão recomendada e alinhada à decisão do usuário ("tipo do val dado pela function"). Consolidar como requisito no spec.
- Remover `FailStmt`/`_op_fail` por completo (inclui imports de codegens) — decisão: remover do caminho de emissão; manter a classe só se título de migração de teste justificar.