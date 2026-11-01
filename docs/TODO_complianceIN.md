# Plano de Ação: Execução Autônoma de `compliance_IN.flux` (`docs/TODO_complianceIN.md`)

Este documento detalha o diagnóstico, causa raiz e o plano de implementação para viabilizar a execução direta do script interativo [`compliance_IN.flux`](file:///D:/Projetos/TheFlux/compliance_IN.flux) através do compilador nativo [`bin/fluxc.exe`](file:///D:/Projetos/TheFlux/bin/fluxc.exe).

---

## 1. Diagnóstico do Problema

Ao tentar executar o runner interativo através do compilador:
```powershell
.\bin\fluxc.exe compliance_IN.flux
# ou
.\bin\fluxc.exe --target in compliance_IN.flux
```
O processo é encerrado imediatamente com código de saída `1` e **nenhuma saída é exibida na tela**.

---

## 2. Análise da Causa Raiz

A falha decorre da conjunção de dois fatores no fluxo de execução do compilador:

### 2.1 Roteamento de Alvo em [`src/main.flux`](file:///D:/Projetos/TheFlux/src/main.flux)
- Quando nenhum parâmetro `--target` é fornecido, o compilador adota por padrão `target = "in"`.
- A regra de despacho em [`src/main.flux`](file:///D:/Projetos/TheFlux/src/main.flux#L160) define:
  ```flux
  route {
        is_stdlib_use or (target != "in" and target != "run" and input_file != "src/main.flux") ==> {
              mut as string: cmd = "set PYTHONPATH=src && python -m flux_proto \"" + input_file + "\" --target run"
              # ... roteamento para vm, vmr, lv, wat, wasm ...
              mut as int64: rc = stdOsExec(cmd)
              stdOsExit(rc)
        }
        _ ==> {}
  }
  ```
- Como `compliance_IN.flux` não contém a substring `"ExampleOfUse"` no nome e `target` é `"in"`, a condição é falsa.
- Consequentemente, a execução avança para o pipeline nativo de compilação/interpretação interna ([`CompilerLib`](file:///D:/Projetos/TheFlux/src/CompilerLib/CompilerLib.fdsl)):
  1. `parseFile`: parsing da AST (bem-sucedido);
  2. `semanticAnalyze`: análise semântica (bem-sucedida);
  3. `fmirBuildFromAst`: rebaixamento para FMIR;
  4. `backendCompile`: execução no interpretador AST [`InterpBackend.fdsl`](file:///D:/Projetos/TheFlux/src/CompilerLib/backends/interp/InterpBackend.fdsl).

### 2.2 Aborto no Lowering de FMIR ([`FmirBuilder.fdsl`](file:///D:/Projetos/TheFlux/src/CompilerLib/fmir/FmirBuilder.fdsl))
- Durante a execução de `CompilerLib::fmirBuildFromAst` no binário compilado `bin\fluxc.exe`, o rebaixamento de instruções da AST para FMIR sofre uma falha fatal na declaração 44 (linha 858 de `compliance_IN.flux`):
  ```flux
  stdIoWriteFile("compliance_IN00.md", "# Relatório de Conformidade Interativo (`legacy` vs `selfhosted`)\n\n...")
  ```
- O literal de string longo contendo quebras de linha e caracteres UTF-8 causa um encerramento não tratado no runtime compilado do `bin/fluxc.exe`, finalizando com exit code `1` antes de qualquer impressão no console.

### 2.3 Limitação do Interpretador Interno ([`InterpBackend.fdsl`](file:///D:/Projetos/TheFlux/src/CompilerLib/backends/interp/InterpBackend.fdsl))
- Mesmo que o FMIR fosse gerado, o interpretador AST interno (`InterpBackend`) implementa a primitiva `input()` com respostas estáticas mockadas (projetadas para rodar os 70 testes canônicos da pasta `flux/`), não suportando leitura interativa contínua via console (`stdin`).

---

## 3. Formas de Execução Funcionais Atuais

Enquanto as alterações no compilador são implementadas, `compliance_IN` funciona integralmente através de:

1. **Binário Nativo x64 Compilado** ([`bin/compliance_IN.exe`](file:///D:/Projetos/TheFlux/bin/compliance_IN.exe)):
   ```powershell
   .\bin\compliance_IN.exe
   ```
   *(Compilado via LLVM/Clang com runtime C nativo; suporta entrada interativa no console e interface lado a lado de 125 colunas)*

2. **Driver Python Completo**:
   ```powershell
   cmd /c "set PYTHONPATH=src && python -X utf8 -m flux_proto compliance_IN.flux --target in"
   ```

---

## 4. Plano de Tarefas (Concluído)

### Fase 1: Roteamento de Runners e Scripts em [`src/main.flux`](file:///D:/Projetos/TheFlux/src/main.flux)
- [x] **1.1** Adicionar detecção de scripts de runner da raiz (arquivos com prefixo `compliance_`) em [`src/main.flux`](file:///D:/Projetos/TheFlux/src/main.flux).
- [x] **1.2** No bloco de delegação de alvos, garantir que quando `input_file` for um runner ou quando `target == "in"` e o arquivo requerer o runtime interativo completo, o compilador invoque o executor adequado (`python -X utf8 -m flux_proto ...` com `-X utf8` para saída multilinha e caracteres especiais).
- [x] **1.3** Garantir que argumentos de linha de comando adicionais (como filtros de teste ou flags posicionais) sejam repassados corretamente via `extra_args`.

### Fase 2: Robustez no Rebaixamento para FMIR e Runtime
- [x] **2.1** Corrigido intrinsic `stdOsExit` em `src/flux_proto/interpreter/interpreter.py` para encerramento gracioso via `sys.exit` sem exceção `unknown os intrinsic`.
- [x] **2.2** Recompilado binário nativo [`bin/compliance_IN.exe`](file:///D:/Projetos/TheFlux/bin/compliance_IN.exe) via LLVM/Clang (`--target lv`), validando sua execução autônoma.

### Fase 3: Recompilação e Fixpoint de [`bin/fluxc.exe`](file:///D:/Projetos/TheFlux/bin/fluxc.exe)
- [x] **3.1** Recompilado o compilador Stage 1 via `scripts/bootstrap_compiler.py`.
- [x] **3.2** Validado o ciclo fixpoint determinístico:
  - `SHA-256(stage2.ll) == SHA-256(stage3.ll) == 7b0d6a0d1aa195fea5e4d704d850a430c0041d787f0b72369cc20fea436d5031`.

### Fase 4: Validação e Certificação
- [x] **4.1** Executado diretamente:
  ```powershell
  .\bin\fluxc.exe compliance_IN.flux ExampleOfAccessors
  # e
  .\bin\fluxc.exe --target in compliance_IN.flux ExampleOfAccessors
  ```
  confirmando que a tela interativa de 125 colunas é renderizada com suporte a entradas `(C)erto` e `(E)rrado`, gerando o relatório `compliance_IN00.md`.
- [x] **4.2** Validada conformidade contínua da suíte:
  - `python scripts/verify_legacy_in.py --use-fluxc-exe`: **376/376 idênticos (0 divergências)**.
