use RuntimeStdLib

program (ExampleOfUseRuntimeStdLib_RuntimeControlContract) {
      println("==================================================")
      println("  Exemplo: RuntimeControlContract (Controle e Pilha)")
      println("==================================================")

      mut as bool: hook_ok = runtimeSetPanicHook("DiagnosticoAgente", "salvarDump")
      println("1. Registro de Panic Hook: " + hook_ok)

      mut as list of data: trace = runtimeStackTrace()
      println("2. Stack Trace possui frames: " + (stdCollectionLength(trace) > 0))
      println("3. Primeiro frame contem texto: " + ("" + trace[1] != ""))

      #L Aliases
      mut as bool: alias_hook = setPanicHook("DiagnosticoAgente", "salvarDump")
      println("4. Alias setPanicHook: " + alias_hook)

      mut as list of data: alias_trace = stackTrace()
      println("5. Alias stackTrace possui frames: " + (stdCollectionLength(alias_trace) > 0))
}
