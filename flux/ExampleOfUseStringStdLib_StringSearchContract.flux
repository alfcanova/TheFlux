use StringStdLib

program (ExampleOfUseStringStdLib_StringSearchContract) {
      println("==================================================")
      println("  Exemplo: StringSearchContract (8 Operacoes - 1-Index)")
      println("==================================================")

      mut as string: text = "the quick brown fox jumps over the lazy dog"
      println("1. stringContains(text, \"fox\"): " + stringContains(text, "fox"))
      println("2. stringContainsAny(text, [\"wolf\", \"fox\"]): " + stringContainsAny(text, ["wolf", "fox"]))
      println("3. stringContainsAll(text, [\"quick\", \"fox\", \"dog\"]): " + stringContainsAll(text, ["quick", "fox", "dog"]))
      println("4. stringStartsWith(text, \"the\"): " + stringStartsWith(text, "the"))
      println("5. stringEndsWith(text, \"dog\"): " + stringEndsWith(text, "dog"))
      println("6. stringIndexOf(text, \"the\"): " + stringIndexOf(text, "the"))
      println("7. stringLastIndexOf(text, \"the\"): " + stringLastIndexOf(text, "the"))
      println("8. stringCount(text, \"the\"): " + stringCount(text, "the"))
}
