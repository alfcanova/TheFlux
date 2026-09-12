use CharStdLib

program (ExampleOfUseCharStdLib_CharAsciiContract) {
      println("==================================================")
      println("  Exemplo: CharAsciiContract (4 Operacoes)")
      println("==================================================")

      mut as char: c_a = 'A'
      mut as char: c_tab = '\t'
      mut as char: c_null = '\0'

      println("1. charToAscii('A'): ", charToAscii(c_a))
      println("   charToAscii('\\t'): ", charToAscii(c_tab))
      println("   charToAscii('\\0'): ", charToAscii(c_null))

      println("2. charFromAscii(65): ", charFromAscii(65))
      println("   charFromAscii(97): ", charFromAscii(97))

      println("3. charIsPrintable('A'): ", charIsPrintable(c_a))
      println("   charIsPrintable('\\t'): ", charIsPrintable(c_tab))

      println("4. charIsControl('\\t'): ", charIsControl(c_tab))
      println("   charIsControl('A'): ", charIsControl(c_a))
}
