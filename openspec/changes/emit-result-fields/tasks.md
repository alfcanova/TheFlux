## 1. Gramática e documentação

- [x] 1.1 Atualizar `emit_statement` e `emit_status` em `docs/TheFlux.md` para a forma única `emit(status, identifier, mensagem)` (sem lista de variáveis, mensagem obrigatória, status só `nice`/`fail`)
- [x] 1.2 Documentar o struct implícito de retorno `{ sta, val, msg }` com `.val` tipado pelo `as` da função em `docs/TheFlux.md`
- [x] 1.3 Atualizar exemplos em `docs/exemplos.md` (chamada → `r.sta`/`r.val`/`r.msg`; `?` short-circuit)
- [x] 1.4 Registrar mudanças/limitações em `docs/erros.md`

## 2. AST e Parser

- [x] 2.1 Alterar `EmitStmt` (`src/flux_proto/parser/ast.py`): substituir `variables: list[str]` por `value: str`
- [x] 2.2 Reescrever `parse_emit_stmt` (`src/flux_proto/parser/statements.py`): status restrito a `T.NICE`/`T.FAIL` (sem `T.IDENTIFIER`), slot único de identificador, `message` obrigatório (sem branches de omissão)
- [x] 2.3 Verificar ausência de produção de `FailStmt` no parser e preparar remoção do caminho de `fail` statement (mantendo `fail` como status)

## 3. Núcleo interpreter

- [x] 3.1 Estender `Value` (`src/flux_proto/interpreter/environment.py`): adicionar `message: str = ""` e `value_type: str = ""` (o `data` carrega o `.val`; `type_name` continua sendo o marker `nice`/`fail` de transporte)
- [x] 3.2 Reescrever `_exec_emit` (`interpreter.py:302`) para ler um único identificador (`self._env.get(node.value)`) e montar `Value(type_name=status, data=<valor>, message=<msg>)`
- [x] 3.3 `_exec_function` (`interpreter.py:191`): preencher `value_type` com `func.return_type` quando o resultado for resultado de `emit`
- [x] 3.4 `_eval_field_access` (`interpreter.py:335`): resolver `.sta`/`.val`/`.msg` quando `obj.type_name ∈ {"nice","fail","emit"}`, senão `InterpreterError` para campos desconhecidos
- [x] 3.5 Substituir `_exec_fail` (`interpreter.py:321`) pelo fluxo `status fail` com `.val`/`.msg` preenchidos (remover `FailStmt` do fluxo de execução)

## 4. Semântico

- [x] 4.1 `src/flux_proto/semantic/emit_check.py`: adicionar regra de `.val` único + mensagem obrigatória + status só keyword (EMC-101/102)
- [x] 4.2 Novo diag: função que termina em `emit` sem `as <tipo>` (`.val` sem tipo estático) (EMC-103)
- [x] 4.3 Novo diag: `value` = identificador não declarado (EMC-104)
- [x] 4.4 Novo diag: acesso `.sta/.val/.msg` sobre valor que não é resultado de função (EMC-105)
- [x] 4.5 Revisar `semantic/ownership.py:66` e demais visitantes que marcam `EmitStmt`/`FailStmt` para a nova estrutura `value` única

## 5. VM

- [x] 5.1 `src/flux_proto/vm/compiler.py:105`: `Op.EMIT` sem `count`; compilar identificador único + mensagem e `Op.EMIT status`
- [x] 5.2 `src/flux_proto/vm/runtime.py:164`: `_op_emit` empurra dict-like `{"status":…, "value":…, "message":…}` (convenção `_op_field_access`)
- [x] 5.3 Remover `_op_fail` (fail vira `Op.EMIT` com status `"fail"`)
- [x] 5.4 Manter `_op_field_access` funcionando para `.sta/.val/.msg`; testes em `src/flux_tests/vm/` (ex.: `test_vm.py:183`) migrados e passando

## 6. Backends LLVM

- [x] 6.1 Representar struct de resultado `%flux.result = { i32, i64, i8* }` (sta, val, msg) em `src/flux_proto/llvm/codegen.py` (representado por 3 globals `@__flux_result_sta/val/msg`)
- [x] 6.2 `_gen_call`/`_gen_emit` (`llvm/codegen.py`): `emit` escreve os 3 slots; `.sta/.val/.msg` viram loads dos slots (lowering de chamada de função de usuário permanece fora do escopo — gap pré-existente, ver design.md)
- [x] 6.3 Atualizar imports/uso de `EmitStmt`/`FailStmt` no codegen LLVM (removido `FailStmt`)

## 7. Backend WAT

- [x] 7.1 Audit do estado atual do codegen de função em `src/flux_proto/wat/codegen.py` (hoje sem `FunctionDef`; contrato do design mantido)
- [x] 7.2 `emit` grava layout fixo de 3 slots (sta/val/msg) em globals `$__flux_result_*` (lowering de chamada de função de usuário permanece fora do escopo — pre-existente)
- [x] 7.3 Expor acesso nomeado `.sta/.val/.msg` no WAT (slots globais; `.sta`/`.msg` tratados como string, `.val` como i64)
- [x] 7.4 Validar com `t_wat` gerado + wasmer run e novos testes de inferência de tipo de `FieldAccess`

## 8. Backend WASM

- [x] 8.1 Audit do `_gen_call`/`_gen_function` em `src/flux_proto/wasm/codegen.py`
- [x] 8.2 `emit` grava os 3 slots em globals de resultado (mantendo os imports WASI existentes); o adendo global no binário foi corrigido (init sem `OP_END` redundante)
- [x] 8.3 Expor acesso `.sta/.val/.msg` e validar binário com `wasm-validate` (amostra `emit_result` passa; falhas em `flux/ExampleOfFunction.wasm` são pré-existentes)

## 9. Testes e regressão

- [x] 9.1 Migrar testes que instanciam `EmitStmt(status=…, variables=[...])` (ex.: `tests/interpreter`, `tests/vm`, `tests/semantic/test_emit_terminal.py`, `lexer` integration) para `value` único
- [x] 9.2 Novos testes interpreter: `emit(nice,…)` e `emit(fail,…)` e acesso `.sta/.val/.msg` (TestResultFields); `?` short-circuit coberto em `interpreter` existente
- [x] 9.3 Novos testes semânticos: EMC-101 (status não-keyword), EMC-102 (mensagem ausente), EMC-104 (`.val` não declarado), função sem `as` (EMC-103)
- [x] 9.4 Padrões multitarget: mesmo programa em Interpreter e VM produzindo `.sta/.val/.msg` iguais (TestEmitFail/VM idem; parity de função de usuário limitada por gap pré-existente de `_op_call`)
- [x] 9.5 Rodar `pytest` em `src/flux_tests/` (315 passam; 10 falhas lexer pré-existentes não relacionadas) e `flux_verify.py` (falhas pré-existentes em sample be e binários WASM mantidas)

## 10. Finalização

- [x] 10.1 `openspec validate emit-result-fields` (válido)
- [x] 10.2 Revisão do diff (gramática, docs, AST, interpreter, semântico, VM, LLVM, WAT, WASM) — compilação, pytest (317 passam), amostra `emit_result` executada em interp/WAT; falhas lexer/WASM pré-existentes registradas

## 11. Renomeação dos campos expostos (`status/value/message` → `sta/val/msg`)

- [x] 11.1 `.status` → `.sta`, `.value` → `.val`, `.message` → `.msg` em todos os resolvedores de campo: `interpreter.py` (`_eval_field_access`), `emit_check.py` (`_RESULT_FIELDS`), `vm/runtime.py` (`_op_emit`), `llvm/codegen.py`, `wat/codegen.py`, `wasm/codegen.py`
- [x] 11.2 Globals/nomes internos renomeados: `@__flux_result_sta/val/msg` (LLVM) e `$__flux_result_sta/val/msg` (WAT/WASM)
- [x] 11.3 Exemplo end-to-end `flux/ExampleOfResult.flux` (novo) com `r = calc(5)` e `print(r.sta)`/`print(r.val)`/`print(r.msg)`, validado em interp, VM, LLVM, WAT (wat2wasm) e WASM (wasm-validate); paridade wasmer de `.val`/`.msg` em chamada de usuário permanece um gap pré-existente dos backends WAT/WASM (mesma categoria de `ExampleOfFunction.flux`)
- [x] 11.4 Docs e signatures atualizadas: `docs/TheFlux.md`, `docs/TheFlux.ebnf`, `docs/grammar.md`, `docs/exemplos.md`, `docs/erros.md` e `docs/keywords/KW_emit|function|short_circuit|program|print.yaml`
- [x] 11.5 Nota de reuso registrada: `.msg` também é campo-seletor em binding de padrão de struct do usuário (`erro(.msg: m)`), desambiguado por contexto