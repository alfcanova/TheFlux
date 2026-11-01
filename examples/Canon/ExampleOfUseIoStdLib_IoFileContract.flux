use IoStdLib

program (ExampleOfUseIoStdLib_IoFileContract) {
      println("==================================================")
      println("  Exemplo: IoFileContract (6 Operacoes)")
      println("==================================================")

      println("1. readFile de fixture: " + readFile("io_stdlib_fixture.txt"))
      println("2. writeFile: " + writeFile("io_stdlib_output.txt", "conteudo gravado pela IoStdLib"))
      println("   readFile apos writeFile: " + readFile("io_stdlib_output.txt"))
      println("3. appendFile: " + appendFile("io_stdlib_output.txt", " mais dados"))
      println("   readFile apos appendFile: " + readFile("io_stdlib_output.txt"))
      println("4. copyFile: " + copyFile("io_stdlib_output.txt", "io_stdlib_copy.txt"))
      println("5. moveFile: " + moveFile("io_stdlib_copy.txt", "io_stdlib_moved.txt"))
      println("6. deleteFile: " + deleteFile("io_stdlib_moved.txt"))
}
