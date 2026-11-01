use CharStdLib

program (ExampleOfUseCharStdLib_CharClassificationContract) {
      println("==================================================")
      println("  Exemplo: CharClassificationContract (12 Operacoes)")
      println("==================================================")

      mut as char: c_digit = '5'
      mut as char: c_upper = 'K'
      mut as char: c_lower = 'm'
      mut as char: c_space = ' '
      mut as char: c_tab = '\t'
      mut as char: c_punct = '!'
      mut as char: c_hex = 'F'
      mut as char: c_oct = '7'
      mut as char: c_bin = '1'

      println("1. charIsDigit('5'): ", charIsDigit(c_digit))
      println("   charIsDigit('K'): ", charIsDigit(c_upper))

      println("2. charIsAlpha('K'): ", charIsAlpha(c_upper))
      println("   charIsAlpha('5'): ", charIsAlpha(c_digit))

      println("3. charIsAlphanumeric('K'): ", charIsAlphanumeric(c_upper))
      println("   charIsAlphanumeric('!'): ", charIsAlphanumeric(c_punct))

      println("4. charIsLower('m'): ", charIsLower(c_lower))
      println("   charIsLower('K'): ", charIsLower(c_upper))

      println("5. charIsUpper('K'): ", charIsUpper(c_upper))
      println("   charIsUpper('m'): ", charIsUpper(c_lower))

      println("6. charIsWhitespace('\\t'): ", charIsWhitespace(c_tab))
      println("   charIsWhitespace('K'): ", charIsWhitespace(c_upper))

      println("7. charIsSpace(' '): ", charIsSpace(c_space))
      println("   charIsSpace('K'): ", charIsSpace(c_upper))

      println("8. charIsPunctuation('!'): ", charIsPunctuation(c_punct))
      println("   charIsPunctuation('K'): ", charIsPunctuation(c_upper))

      println("9. charIsHexDigit('F'): ", charIsHexDigit(c_hex))
      println("   charIsHexDigit('Z'): ", charIsHexDigit('Z'))

      println("10. charIsOctalDigit('7'): ", charIsOctalDigit(c_oct))
      println("    charIsOctalDigit('9'): ", charIsOctalDigit('9'))

      println("11. charIsBinaryDigit('1'): ", charIsBinaryDigit(c_bin))
      println("    charIsBinaryDigit('2'): ", charIsBinaryDigit('2'))

      println("12. charIsAscii('K'): ", charIsAscii(c_upper))
}
