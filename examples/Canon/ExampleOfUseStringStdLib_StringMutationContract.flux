use StringStdLib

program (ExampleOfUseStringStdLib_StringMutationContract) {
      println("==================================================")
      println("  Exemplo: StringMutationContract (12 Operacoes)")
      println("==================================================")

      mut as string: text = "TheFlux"
      println("Texto original: " + text)
      println("1. stringPushFront(text, \"#\"): " + stringPushFront(text, "#"))
      println("2. stringPushBack(text, \"!\"): " + stringPushBack(text, "!"))
      println("3. stringPrepend(text, \"[Flux] \"): " + stringPrepend(text, "[Flux] "))
      println("4. stringAppend(text, \" 2026\"): " + stringAppend(text, " 2026"))
      println("5. stringInsertFirst(text, \">>\"): " + stringInsertFirst(text, ">>"))
      println("6. stringInsertAt(text, 4, \"-Awesome-\"): " + stringInsertAt(text, 4, "-Awesome-"))
      println("7. stringInsertLast(text, \"<<\"): " + stringInsertLast(text, "<<"))
      println("8. stringInsert(text, 4, \"-Awesome-\"): " + stringInsert(text, 4, "-Awesome-"))
      println("9. stringRemoveFirst(text): " + stringRemoveFirst(text))
      println("10. stringRemoveAt(text, 4): " + stringRemoveAt(text, 4))
      println("11. stringRemoveLast(text): " + stringRemoveLast(text))
      println("12. stringRemove(\"banana\", \"na\"): " + stringRemove("banana", "na"))
      println("    stringRemoveAll(\"banana\", \"na\"): " + stringRemoveAll("banana", "na"))
}
