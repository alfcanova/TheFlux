use IoStdLib

program (ExampleOfUseIoStdLib_IoPathContract) {
      println("==================================================")
      println("  Exemplo: IoPathContract (4 Operacoes)")
      println("==================================================")

      println("1. pathBaseName(\"docs/manual.pdf\"): " + pathBaseName("docs/manual.pdf"))
      println("2. pathDirName(\"docs/manual.pdf\"): " + pathDirName("docs/manual.pdf"))
      println("3. pathExtension(\"docs/manual.pdf\"): " + pathExtension("docs/manual.pdf"))
      println("4. pathJoin(\"docs\", \"manual.pdf\"): " + pathJoin("docs", "manual.pdf"))
}
