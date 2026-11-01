use StringStdLib

program (ExampleOfUseStringStdLib_StringAccessContract) {
      println("==================================================")
      println("  Exemplo: StringAccessContract (7 Operacoes - 1-Index)")
      println("==================================================")

      mut as string: text = "ABCDEF"
      println("1. stringGetFirst(\"ABCDEF\"): " + stringGetFirst(text))
      println("2. stringGetAt(\"ABCDEF\", 4): " + stringGetAt(text, 4))
      println("3. stringGetLast(\"ABCDEF\"): " + stringGetLast(text))
      println("4. stringGetLeft(\"ABCDEF\", 3): " + stringGetLeft(text, 3))
      println("5. stringGetRight(\"ABCDEF\", 3): " + stringGetRight(text, 3))
      println("6. stringGetCenter(\"ABCDEF\", 0) [par]: " + stringGetCenter(text, 0))
      println("   stringGetCenter(\"ABCDEFG\", 1) [impar]: " + stringGetCenter("ABCDEFG", 1))
      println("7. stringSlice(\"ABCDEF\", 2, 5): " + stringSlice(text, 2, 5))
}
