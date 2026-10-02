use RuntimeStdLib

program (ExampleOfUseRuntimeStdLib_RuntimeHostContract) {
      println("==================================================")
      println("  Exemplo: RuntimeHostContract (Host e Ambiente)")
      println("==================================================")

      mut as string: b = runtimeBackend()
      mut as bool: valid_backend = (b == "in" or b == "vm" or b == "vmr" or b == "llvm" or b == "wat" or b == "wasm")
      println("1. Backend valido: " + valid_backend)

      mut as bool: env_detected = (runtimeIsNative() or runtimeIsWasm() or runtimeIsInterpreter())
      println("2. Ambiente de execucao detectado: " + env_detected)

      mut as int64: ps = runtimePointerSize()
      mut as bool: valid_pointer = (ps == 4 or ps == 8)
      println("3. Tamanho de ponteiro valido (4 ou 8 bytes): " + valid_pointer)

      println("4. Versao do Compilador: " + runtimeCompilerVersion())

      mut as int64: argc = runtimeGetArgCount()
      println("5. Quantidade de argumentos (>= 0): " + (argc >= 0))

      mut as string: arg1 = runtimeGetArg(999)
      println("6. Argumento inexistente seguro: " + (arg1 == ""))

      mut as string: exe = runtimeExecutablePath()
      println("7. Executavel presente: " + (exe != ""))

      #L Aliases
      println("8. Alias compilerVersion: " + compilerVersion())
      println("9. Alias getArgCount (>= 0): " + (getArgCount() >= 0))
}
