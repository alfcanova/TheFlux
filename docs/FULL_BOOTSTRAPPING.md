# Plano Mestre de Full Bootstrapping (`v1.0.0`) — Migração da Camada Híbrida para `.fdsl`

> **Diretriz Inegociável de Segurança**: Nenhuma pasta ou arquivo legado (`.\legacy\` ou `.\src\flux_proto\`) será removido em momento algum. Todas as evoluções são aditivas em `src/CompilerLib/` e `src/main.flux`, com ajustes exclusivos de caminhos nos scripts de recompilação e verificação do `bin/fluxc.exe`.

---

## Checklist de Execução (Ondas 7 a 12)

### Onda 7 — Ajuste de Caminhos de Recompilação e Resolução Recursiva de Módulos `.fdsl`
- [x] **7.1** Ajustar caminhos de recompilação em [`scripts/bootstrap_compiler.py`](file:///D:/Projetos/TheFlux/scripts/bootstrap_compiler.py) e [`src/flux_proto/compiler_driver.py`](file:///D:/Projetos/TheFlux/src/flux_proto/compiler_driver.py) para usar exclusivamente `.\src` e `.\runtime\flux_input.c` (`docs/pt_BR/keywords`).
- [x] **7.2** Ajustar caminhos nos verificadores [`scripts/test_tri_engine_parity.py`](file:///D:/Projetos/TheFlux/scripts/test_tri_engine_parity.py) e [`scripts/test_control_flow_parity.py`](file:///D:/Projetos/TheFlux/scripts/test_control_flow_parity.py) para apontarem para `.\flux_in.py` na raiz.
- [x] **7.3** Expandir [`src/CompilerLib/parser/ImportResolver.fdsl`](file:///D:/Projetos/TheFlux/src/CompilerLib/parser/ImportResolver.fdsl) com `importResolveRelative` e controle de módulos visitados para pacotes `stdlib/<Lib>StdLib/` e `src/CompilerLib/`.
- [x] **7.4** Expandir [`src/CompilerLib/parser/ParseDecls.fdsl`](file:///D:/Projetos/TheFlux/src/CompilerLib/parser/ParseDecls.fdsl) e [`src/CompilerLib/parser/ParserCore.fdsl`](file:///D:/Projetos/TheFlux/src/CompilerLib/parser/ParserCore.fdsl) para capturar extensões `.fdsl` e aliases `as` em `DECL_USE` e registrar `file_path` na `AstArena`.
- [x] **7.5** Expandir [`src/CompilerLib/fmir/FmirBuilder.fdsl`](file:///D:/Projetos/TheFlux/src/CompilerLib/fmir/FmirBuilder.fdsl) (`fmirBuildFromAst`) para registrar procedimentos `DECL_FUNCTION` e `DECL_AGENT` (`op`) em `fmir_module["functions"]` e `fmir_module["imports"]`.

### Onda 8 — Ponte Nativa das 37 `StdLibs` (`StdLibBridge.fdsl`) e Execução Nativa em `InterpBackend.fdsl`
- [x] **8.1** Criar [`src/CompilerLib/backends/interp/StdLibBridge.fdsl`](file:///D:/Projetos/TheFlux/src/CompilerLib/backends/interp/StdLibBridge.fdsl) e registrá-lo em [`src/CompilerLib/CompilerLib.fdsl`](file:///D:/Projetos/TheFlux/src/CompilerLib/CompilerLib.fdsl) para despacho nativo de intrínsecas `std*`.
- [x] **8.2** Integrar chamada de procedimentos de `fmir_module["functions"]` e `interpCallStdIntrinsic` no opcode `CALL` de [`src/CompilerLib/backends/interp/InterpBackend.fdsl`](file:///D:/Projetos/TheFlux/src/CompilerLib/backends/interp/InterpBackend.fdsl).
- [x] **8.3** Validar `376/376` em `python scripts/verify_legacy_in.py` e `python scripts/verify_legacy_in.py --use-fluxc-exe`.

### Onda 9 — Backends `VmBackend.fdsl` e `VmrBackend.fdsl` Completos em `.fdsl`
- [x] **9.1** Expandir [`src/CompilerLib/backends/vm/VmCompiler.fdsl`](file:///D:/Projetos/TheFlux/src/CompilerLib/backends/vm/VmCompiler.fdsl) e [`src/CompilerLib/backends/vm/VmBackend.fdsl`](file:///D:/Projetos/TheFlux/src/CompilerLib/backends/vm/VmBackend.fdsl) para suportar o conjunto completo de opcodes FMIR e emissão `.fvmbc`.
- [x] **9.2** Expandir [`src/CompilerLib/backends/vm/VmRuntime.fdsl`](file:///D:/Projetos/TheFlux/src/CompilerLib/backends/vm/VmRuntime.fdsl) e [`src/CompilerLib/backends/vmr/VmrBackend.fdsl`](file:///D:/Projetos/TheFlux/src/CompilerLib/backends/vmr/VmrBackend.fdsl) para execução e recarregamento de `.fvmbc`.

### Onda 10 — Backend `LlvmBackend.fdsl` Expandido em `.fdsl` e Linkagem Nativa com `runtime/flux_input.c`
- [x] **10.1** Expandir [`src/CompilerLib/backends/llvm/LlvmBackend.fdsl`](file:///D:/Projetos/TheFlux/src/CompilerLib/backends/llvm/LlvmBackend.fdsl) para suportar constantes, operações aritméticas/bitwise/relacionais e controle de fluxo (`LABEL`, `JUMP`).

### Onda 11 — Backends `WatBackend.fdsl` e `WasmBackend.fdsl` Expandidos em `.fdsl`
- [x] **11.1** Expandir [`src/CompilerLib/backends/wat/WatBackend.fdsl`](file:///D:/Projetos/TheFlux/src/CompilerLib/backends/wat/WatBackend.fdsl) com suporte completo aos opcodes FMIR aritméticos e bitwise.
- [x] **11.2** Expandir [`src/CompilerLib/backends/wasm/WasmBackend.fdsl`](file:///D:/Projetos/TheFlux/src/CompilerLib/backends/wasm/WasmBackend.fdsl) com opcodes binários WebAssembly adicionais.

### Onda 12 — Recompilação Final de `bin/fluxc.exe`, Fixpoint (`Stage 2 == Stage 3`) e Certificação 376/376
- [x] **12.1** Recompilar `bin/fluxc.exe` via `python scripts/bootstrap_compiler.py --stage2`.
- [x] **12.2** Verificar Fixpoint determinístico (`SHA256(stage2.ll) == SHA256(stage3.ll)` = `293d9e2419490dafe285e72ed91f80097d54d5a85e46b63a74127e28320128e3`).
- [x] **12.3** Verificar `376/376` em `python scripts/verify_legacy_in.py` e nos verificadores tri-engine (`test_tri_engine_parity.py` 17/17 e `test_control_flow_parity.py` 11/11).
