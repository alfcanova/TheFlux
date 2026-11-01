use CharStdLib

program (ExampleOfUseCharStdLib_CharHexContract) {
      println("==================================================")
      println("  Exemplo: CharHexContract (4 Operacoes)")
      println("==================================================")

      mut as char: c_a = 'A'
      mut as char: c_f = 'f'
      mut as char: c_nine = '9'
      mut as char: c_one = '1'
      mut as char: c_zero = '0'

      println("1. charToHexValue('A'): ", charToHexValue(c_a))
      println("   charToHexValue('f'): ", charToHexValue(c_f))
      println("   charToHexValue('9'): ", charToHexValue(c_nine))

      println("2. charFromHexValue(10): ", charFromHexValue(10))
      println("   charFromHexValue(15): ", charFromHexValue(15))
      println("   charFromHexValue(9): ", charFromHexValue(9))

      println("3. charToBinaryValue('1'): ", charToBinaryValue(c_one))
      println("   charToBinaryValue('0'): ", charToBinaryValue(c_zero))

      println("4. charFromBinaryValue(1): ", charFromBinaryValue(1))
      println("   charFromBinaryValue(0): ", charFromBinaryValue(0))
}
