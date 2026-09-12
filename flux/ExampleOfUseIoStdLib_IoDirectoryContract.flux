use IoStdLib

program (ExampleOfUseIoStdLib_IoDirectoryContract) {
      println("==================================================")
      println("  Exemplo: IoDirectoryContract (4 Operacoes)")
      println("==================================================")

      println("1. createDir: " + createDir("io_stdlib_test_dir"))
      println("2. dirExists apos create: " + dirExists("io_stdlib_test_dir"))
      writeFile("io_stdlib_test_dir/arquivo.txt", "conteudo interno")
      mut as list of data: entradas = listDir("io_stdlib_test_dir")
      println("3. listDir item 1: " + entradas[1])
      deleteFile("io_stdlib_test_dir/arquivo.txt")
      println("4. removeDir: " + removeDir("io_stdlib_test_dir"))
      println("   dirExists apos remove: " + dirExists("io_stdlib_test_dir"))
}
