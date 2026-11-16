use src::Fvm::FvmClient as FC

program (ExampleOfFvmClient) {
      print("=== FVM Client: Verificando status do servico ===")
      mut as bool: active = FC::fvmIsServiceActive()
      print("Servico FVM ativo: " + active)

      print("=== FVM Client: Execucao de arquivo de bytecode local ===")
      mut as map: res_exec = FC::fvmExecuteFile("t_fvmbc/test_acc.fvmbc", "")
      print("Sucesso: " + res_exec["success"])
      print("Saida:")
      print(res_exec["stdout"])

      print("=== FVM Client: Injecao de bytecode no servico ou fallback local ===")
      mut as string: bc_content = stdIoReadFile("t_fvmbc/test_acc.fvmbc")
      mut as map: res_inj = FC::fvmInjectBytecode(bc_content, "")
      print("Injecao sucesso: " + res_inj["success"])
      print("Injecao saida:")
      print(res_inj["stdout"])
}
