use StringStdLib

program (ExampleOfUseStringStdLib_StringBasicContract) {
      println("==================================================")
      println("  Exemplo: StringBasicContract (17 Operacoes)")
      println("==================================================")

      mut as string: text = "TheFlux"
      println("1. stringLength(\"TheFlux\"): " + stringLength(text))
      println("2. stringIsEmpty(\"TheFlux\"): " + stringIsEmpty(text))
      println("3. stringIsNotEmpty(\"TheFlux\"): " + stringIsNotEmpty(text))
      println("4. stringContains(\"TheFlux\", \"Flux\"): " + stringContains(text, "Flux"))
      println("5. stringContainsAny(\"TheFlux\", [\"Rust\", \"Flux\"]): " + stringContainsAny(text, ["Rust", "Flux"]))
      println("6. stringContainsAll(\"TheFlux\", [\"The\", \"Flux\"]): " + stringContainsAll(text, ["The", "Flux"]))
      println("7. stringClearAll(\"TheFlux\"): [" + stringClearAll(text) + "]")
      println("8. stringSingleton(\"A\"): " + stringSingleton("A"))
      println("9. stringSingletonInt(42): " + stringSingletonInt(42))
      println("10. stringSingletonString(\"flux\"): " + stringSingletonString("flux"))
      println("11. stringClone(\"TheFlux\"): " + stringClone(text))

      mut as list of data: chars = stringToList(text)
      println("12. stringToList(\"TheFlux\"): " + chars)
      println("13. stringFromList([\"T\", \"h\", \"e\", \"F\", \"l\", \"u\", \"x\"]): " + stringFromList(chars))
      println("14. stringFromSet({\"a\", \"b\"}): " + stringFromSet({"a", "b"}))
      println("15. stringFromString(\"TheFlux\"): " + stringFromString(text))
      println("16. stringToSet(\"TheFlux\"): " + stringToSet(text))
      println("17. stringToMap(\"k1: 10, k2: 20\"): " + stringToMap("k1: 10, k2: 20"))
      println("18. stringToString(\"TheFlux\"): " + stringToString(text))
}
