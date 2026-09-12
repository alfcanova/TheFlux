use StringStdLib

program (ExampleOfUseStringStdLib_StringTransformContract) {
      println("==================================================")
      println("  Exemplo: StringTransformContract (12 Operacoes)")
      println("==================================================")

      println("1. stringUpper(\"hello world\"): " + stringUpper("hello world"))
      println("2. stringLower(\"HELLO WORLD\"): " + stringLower("HELLO WORLD"))
      println("3. stringCapitalize(\"theFLUX\"): " + stringCapitalize("theFLUX"))
      println("4. stringTrim(\"  flux  \"): [" + stringTrim("  flux  ") + "]")
      println("5. stringTrimStart(\"  flux  \"): [" + stringTrimStart("  flux  ") + "]")
      println("6. stringTrimEnd(\"  flux  \"): [" + stringTrimEnd("  flux  ") + "]")
      println("7. stringReplace(\"a-b-a\", \"a\", \"x\"): " + stringReplace("a-b-a", "a", "x"))
      println("8. stringReplaceFirst(\"a-b-a\", \"a\", \"x\"): " + stringReplaceFirst("a-b-a", "a", "x"))
      println("9. stringReverse(\"Flux\"): " + stringReverse("Flux"))
      println("10. stringRepeat(\"Echo \", 3): " + stringRepeat("Echo ", 3))
      println("11. stringConcat(\"The\", \"Flux\"): " + stringConcat("The", "Flux"))
      println("12. stringSurround(\"Flux\", \"[\", \"]\"): " + stringSurround("Flux", "[", "]"))
}
