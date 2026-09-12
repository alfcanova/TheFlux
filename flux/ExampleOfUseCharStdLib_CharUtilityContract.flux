use CharStdLib

program (ExampleOfUseCharStdLib_CharUtilityContract) {
      println("==================================================")
      println("  Exemplo: CharUtilityContract (6 Operacoes)")
      println("==================================================")

      mut as char: c_z = 'Z'
      mut as char: c_star = '*'
      mut as char: c_e = 'e'
      mut as char: c_nl = '\n'
      mut as char: c_digit = '9'

      println("1. charToString('Z'): ", charToString(c_z))

      println("2. charRepeat('*', 5): ", charRepeat(c_star, 5))

      println("3. charIsVowel('e'): ", charIsVowel(c_e))
      println("   charIsVowel('Z'): ", charIsVowel(c_z))

      println("4. charIsConsonant('Z'): ", charIsConsonant(c_z))
      println("   charIsConsonant('e'): ", charIsConsonant(c_e))

      println("5. charEscape('\\n'): ", charEscape(c_nl))
      println("   charEscape('Z'): ", charEscape(c_z))

      println("6. charName('9'): ", charName(c_digit))
      println("   charName('Z'): ", charName(c_z))
      println("   charName('e'): ", charName(c_e))
      println("   charName(' '): ", charName(' '))
}
