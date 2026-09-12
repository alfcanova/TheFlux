use StringStdLib

program (ExampleOfUseStringStdLib_StringSelectionContract) {
      println("==================================================")
      println("  Exemplo: StringSelectionContract (9 Operacoes)")
      println("==================================================")

      mut as string: text = "abcdefgh"
      println("1. stringTake(\"abcdefgh\", 4): " + stringTake(text, 4))
      println("2. stringDrop(\"abcdefgh\", 4): " + stringDrop(text, 4))
      println("3. stringTakeLast(\"abcdefgh\", 3): " + stringTakeLast(text, 3))
      println("4. stringDropLast(\"abcdefgh\", 3): " + stringDropLast(text, 3))
      println("5. stringPadStart(\"42\", 6, \"0\"): [" + stringPadStart("42", 6, "0") + "]")
      println("6. stringPadEnd(\"42\", 6, \".\"): [" + stringPadEnd("42", 6, ".") + "]")
      println("7. stringPadCenter(\"42\", 6, \"-\"): [" + stringPadCenter("42", 6, "-") + "]")
      println("8. stringFilter(\"abcdefgh\", [\"a\", \"c\", \"e\"]): " + stringFilter(text, ["a", "c", "e"]))
      println("9. stringOmit(\"abcdefgh\", [\"a\", \"c\", \"e\"]): " + stringOmit(text, ["a", "c", "e"]))
}
