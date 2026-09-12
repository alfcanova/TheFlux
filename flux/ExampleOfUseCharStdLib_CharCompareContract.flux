use CharStdLib

program (ExampleOfUseCharStdLib_CharCompareContract) {
      println("==================================================")
      println("  Exemplo: CharCompareContract (5 Operacoes)")
      println("==================================================")

      mut as char: c_a = 'a'
      mut as char: c_b = 'b'
      mut as char: c_cap_a = 'A'
      mut as char: c_m = 'm'

      println("1. charEquals('a', 'a'): ", charEquals(c_a, c_a))
      println("   charEquals('a', 'A'): ", charEquals(c_a, c_cap_a))

      println("2. charEqualsIgnoreCase('a', 'A'): ", charEqualsIgnoreCase(c_a, c_cap_a))
      println("   charEqualsIgnoreCase('a', 'b'): ", charEqualsIgnoreCase(c_a, c_b))

      println("3. charCompare('a', 'b'): ", charCompare(c_a, c_b))
      println("   charCompare('b', 'a'): ", charCompare(c_b, c_a))
      println("   charCompare('a', 'a'): ", charCompare(c_a, c_a))

      println("4. charCompareIgnoreCase('a', 'A'): ", charCompareIgnoreCase(c_a, c_cap_a))
      println("   charCompareIgnoreCase('a', 'B'): ", charCompareIgnoreCase(c_a, 'B'))

      println("5. charIsBetween('m', 'a', 'z'): ", charIsBetween(c_m, 'a', 'z'))
      println("   charIsBetween('m', '0', '9'): ", charIsBetween(c_m, '0', '9'))
}
