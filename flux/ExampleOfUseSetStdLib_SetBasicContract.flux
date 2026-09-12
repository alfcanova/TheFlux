use SetStdLib

program (ExampleOfUseSetStdLib_SetBasicContract) {
      println("==================================================")
      println("  Exemplo: SetBasicContract (17 Operacoes)")
      println("==================================================")

      mut as set of int64: a = {10, 20, 30, 40}
      println("1. setLength({10, 20, 30, 40}): " + setLength(a))
      println("2. setIsEmpty({10, 20, 30, 40}): " + setIsEmpty(a))
      println("3. setIsNotEmpty({10, 20, 30, 40}): " + setIsNotEmpty(a))
      println("4. setContains(a, 20): " + setContains(a, 20))
      println("5. setContainsAny(a, {20, 99}): " + setContainsAny(a, {20, 99}))
      println("6. setContainsAll(a, {20, 30}): " + setContainsAll(a, {20, 30}))
      println("7. setClearAll(a): " + setClearAll(a))
      println("8. setSingleton(42): " + setSingleton(42))
      println("9. setSingletonInt(42): " + setSingletonInt(42))
      println("10. setSingletonString(\"flux\"): " + setSingletonString("flux"))
      println("11. setClone(a): " + setClone(a))
      println("12. setToList(a): " + setToList(a))
      println("13. setToSet([1, 2, 2, 3]): " + setToSet([1, 2, 2, 3]))
      println("14. setToMap({[\"nome\", \"Flux\"], [\"versao\", 1]}): " + setToMap({["nome", "Flux"], ["versao", 1]}))
      println("15. setToString(a): " + setToString(a))
      println("16. setFromList([1, 2, 2, 3]): " + setFromList([1, 2, 2, 3]))
      println("17. setFromSet({10, 20}): " + setFromSet({10, 20}))
      println("18. setFromString(\"flux\"): " + setFromString("flux"))
}
