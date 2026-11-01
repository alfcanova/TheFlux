use DebugStdLib

program (ExampleOfUseDebugStdLib_DebugInspectContract) {
      println("==================================================")
      println("  Exemplo: DebugInspectContract (Inspecao e Dumps)")
      println("==================================================")

      #L 1. Representacao com quotes de String
      println("1. Repr String: " + debugReprString("Mensagem com texto"))

      #L 2. Repr Int, Float e Bool
      println("2. Repr Int:    " + debugReprInt(1024))
      println("3. Repr Float:  " + debugReprFloat(12.75))
      println("4. Repr Bool T: " + debugReprBool(true))
      println("   Repr Bool F: " + debugReprBool(false))

      #L 3. Dump de Lista
      mut as list of data: numeros = [10, 20, 30, 40, 50]
      println("5. Dump Lista:  " + debugDumpList(numeros, "VetorValores"))

      #L 4. Hex Dump de Bytes
      println("6. Hex Dump 'FLUX': " + debugHexDump("FLUX"))
      println("   Hex Dump '123':  " + debugHexDump("123"))
}
