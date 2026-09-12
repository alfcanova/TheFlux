## Why

Hoje `emit(status, variables, message)` encerra uma função e devolve ao chamador apenas status (`Value.type_name`) e valor (`Value.data`); a **mensagem é descartada** em todos os runtimes (interpreter.py:302, vm/runtime.py:160), e o chamador não tem uma forma nomeada de ler cada campo do retorno. Isso impede observabilidade (mensagem de falha) e força um consumo apenas via `?` short-circuit.

## What Changes

- **BREAKING** `emit_statement` deixa de aceitar uma lista de variáveis:
  `emit_statement = "emit" , "(" , emit_status , "," , identifier , "," , ( string_literal | interpolated_string ) , ")"`.
  - Primeiro argumento restrito aos tokens `nice`/`fail` (parser deixa de aceitar `IDENTIFIER` como status).
  - Segundo argumento vira **um único identificador** (nem lista, nem expressão).
  - `message` torna-se obrigatório (sem pontos de omissão).
- Toda chamada de função devolve um **struct implícito do sistema** com três campos sempre definidos:
  - `.sta`: `string` (`"nice"`/`"fail"`), nunca vazio.
  - `.val`: valor do identificador emitido, com tipo estático derivado do `as type_reference` da função, nunca vazio.
  - `.msg`: `string`, nunca vazio.
- Acesso nomeado via `FieldAccess` existente: `r.sta`, `r.val`, `r.msg`, ou `r = function(teste)` para obter o struct inteiro.
- O `?` short-circuit (`fail(v) ==> {...}` / `nice(v) ==> {...}`) continua consumindo o mesmo struct, sem reavaliar a chamada.
- Novos diagnósticos semânticos: `emit` com identificador não declarado, valor/mensagem ausentes, função sem `as` declarado, ou incompatibilidade de tipo entre o identificador e o tipo de retorno da função.
- Todos os backends (Interpreter, VM, LLVM, WAT/WASM) carregam o struct de resultado com os 3 campos.

## Capabilities

### New Capabilities
- `emit-result-fields`: resultado de chamada de função como struct implícito de sistema `{ sta, val, msg }`, com acesso nomeado `.sta/.val/.msg` e restrições de gramática/semântica.

### Modified Capabilities
<!-- Nenhuma spec existente é alterada (openspec/specs ainda não possui specs consolidadas). -->

## Impact

- **Gramática/docs:** `docs/TheFlux.md` (`emit_statement`, `emit_status`, struct de resultado); `docs/exemplos.md`, `docs/erros.md`.
- **AST/parser:** `src/flux_proto/parser/ast.py` (`EmitStmt` passa a ter `value` único), `src/flux_proto/parser/statements.py` (`parse_emit_stmt`).
- **Interpreter:** `src/flux_proto/interpreter/environment.py` (`Value.message`), `src/flux_proto/interpreter/interpreter.py` (`_exec_emit`, `_exec_fail`, `_eval_field_access`, `_exec_function`).
- **Semântico:** `src/flux_proto/semantic/analyzer.py`, `src/flux_proto/semantic/emit_check.py` (novos diagnósticos).
- **VM:** `src/flux_proto/vm/compiler.py`, `src/flux_proto/vm/runtime.py` (emit/fail com 3 campos + extração).
- **LLVM:** `src/flux_proto/llvm/codegen.py` (struct de retorno `{i1 status, * value, i8* message}`).
- **WAT/WASM:** `src/flux_proto/wat/codegen.py`, `src/flux_proto/wasm/codegen.py` (layout do struct de resultado; audit de suporte a funções).
- **Testes:** `src/flux_tests/**` (parser, interpreter, semantic, vm e multitarget wat/wasm/llvm).

Formato de exemplo: `function (calc) (x: int64) as int64 { emit(nice, x, "ok") }` → `r = calc(5)`; `r.sta == "nice"`, `r.val == 5`, `r.msg == "ok"`.