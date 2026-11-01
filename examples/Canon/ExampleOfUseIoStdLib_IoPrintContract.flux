use IoStdLib

program (ExampleOfUseIoStdLib_IoPrintContract) {
      println("==================================================")
      println("  Exemplo: IoPrintContract (4 Operacoes)")
      println("==================================================")

      mut as string: retEcho = echo("Mensagem via echo")
      println("1. echo(\"Mensagem via echo\"): " + retEcho)
      mut as string: retPrintLn = printLn("Mensagem via printLn")
      println("2. printLn(\"Mensagem via printLn\"): " + retPrintLn)
      mut as string: retPrintLine = printLine("Mensagem via printLine")
      println("3. printLine(\"Mensagem via printLine\"): " + retPrintLine)
      println("4. printErr(\"Mensagem stderr via printErr\"): " + printErr("Mensagem stderr via printErr"))
}
