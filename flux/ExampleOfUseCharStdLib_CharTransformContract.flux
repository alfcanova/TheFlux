use CharStdLib

program (ExampleOfUseCharStdLib_CharTransformContract) {
      println("==================================================")
      println("  Exemplo: CharTransformContract (5 Operacoes)")
      println("==================================================")

      mut as char: c_lo = 'x'
      mut as char: c_up = 'X'
      mut as char: c_dig = '8'

      println("1. charToUpper('x'): ", charToUpper(c_lo))
      println("2. charToLower('X'): ", charToLower(c_up))
      println("3. charToggleCase('x'): ", charToggleCase(c_lo))
      println("   charToggleCase('X'): ", charToggleCase(c_up))
      println("4. charToDigit('8'): ", charToDigit(c_dig))
      println("5. charFromDigit(8): ", charFromDigit(8))
}
