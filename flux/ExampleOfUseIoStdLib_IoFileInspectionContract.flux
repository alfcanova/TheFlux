use IoStdLib

program (ExampleOfUseIoStdLib_IoFileInspectionContract) {
      println("==================================================")
      println("  Exemplo: IoFileInspectionContract (3 Operacoes)")
      println("==================================================")

      println("1. fileExists(\"io_stdlib_fixture.txt\"): " + fileExists("io_stdlib_fixture.txt"))
      println("2. fileSize(\"io_stdlib_fixture.txt\"): " + fileSize("io_stdlib_fixture.txt"))
      println("3. fileIsEmpty(\"io_stdlib_fixture.txt\"): " + fileIsEmpty("io_stdlib_fixture.txt"))
}
