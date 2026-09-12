use StringStdLib

program (ExampleOfUseStringStdLib_StringValidationContract) {
      println("==================================================")
      println("  Exemplo: StringValidationContract (8 Operacoes)")
      println("==================================================")

      #L 1. Testes de Caracteres Alfanumericos
      println("1. stringIsAlpha(\"HelloWorld\"): " + stringIsAlpha("HelloWorld"))
      println("   stringIsAlpha(\"Hello123\"): " + stringIsAlpha("Hello123"))

      println("2. stringIsDigit(\"123456\"): " + stringIsDigit("123456"))
      println("   stringIsDigit(\"123a45\"): " + stringIsDigit("123a45"))

      println("3. stringIsAlphanumeric(\"FluxLang2026\"): " + stringIsAlphanumeric("FluxLang2026"))
      println("   stringIsAlphanumeric(\"Flux Lang!\"): " + stringIsAlphanumeric("Flux Lang!"))

      #L 2. Testes de Espacamento e Vacuidade
      println("4. stringIsWhitespace(\"   \\t\\n\"): " + stringIsWhitespace("   \t\n"))
      println("   stringIsWhitespace(\"  a  \"): " + stringIsWhitespace("  a  "))

      println("5. stringIsBlank(\"\"): " + stringIsBlank(""))
      println("   stringIsBlank(\"   \"): " + stringIsBlank("   "))
      println("   stringIsBlank(\"abc\"): " + stringIsBlank("abc"))

      #L 3. Testes de Caixa
      println("6. stringIsLower(\"hello\"): " + stringIsLower("hello"))
      println("   stringIsLower(\"Hello\"): " + stringIsLower("Hello"))

      println("7. stringIsUpper(\"WORLD\"): " + stringIsUpper("WORLD"))
      println("   stringIsUpper(\"World\"): " + stringIsUpper("World"))

      #L 4. Testes de Tabela de Caracteres
      println("8. stringIsAscii(\"Hello, Flux!\"): " + stringIsAscii("Hello, Flux!"))
}
