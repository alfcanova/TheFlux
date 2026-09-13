use OsStdLib

program (ExampleOfUseOsStdLib_OsProcessContract) {
      println("==================================================")
      println("  Exemplo: OsProcessContract (Processos do OS)")
      println("==================================================")

      println("1. Diretorio de Trabalho Atual (CWD): " + osCwd())
      mut as bool: cd_ok = osChdir(osCwd())
      println("2. osChdir para CWD: " + cd_ok)
      println("3. osExec('cd .'): retorno " + osExec("cd ."))
      println("4. osExecOutput('echo FluxRuntime'): " + osExecOutput("echo FluxRuntime"))
      println("5. osSleep(10ms): " + osSleep(10))
      println("6. Process ID Ativo (> 0): " + (osGetPid() > 0))
      println("7. Parent Process ID (>= 0): " + (osGetParentPid() >= 0))
}
