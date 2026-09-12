use IoStdLib

program (ExampleOfUseIoStdLib_IoFileLineContract) {
      println("==================================================")
      println("  Exemplo: IoFileLineContract (3 Operacoes)")
      println("==================================================")

      println("1. writeLines: " + writeLines("io_stdlib_lines.txt", ["linha1", "linha2"]))
      println("2. appendLines: " + appendLines("io_stdlib_lines.txt", ["linha3"]))
      mut as list of data: linhas = readLines("io_stdlib_lines.txt")
      println("3. readLines linha 1: " + linhas[1])
      println("   readLines linha 2: " + linhas[2])
      println("   readLines linha 3: " + linhas[3])
      deleteFile("io_stdlib_lines.txt")
}
