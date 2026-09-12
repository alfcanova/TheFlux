use ListStdLib

program (ExampleOfUseListStdLib_ListBasicContract) {
      println("==================================================")
      println("  Exemplo: ListBasicContract (18 Operacoes)")
      println("==================================================")

      mut as list of int64: numbers = [10, 20, 30, 40]
      println("1. listLength([10, 20, 30, 40]): " + listLength(numbers))
      println("2. listIsEmpty([10, 20, 30, 40]): " + listIsEmpty(numbers))
      println("3. listIsNotEmpty([10, 20, 30, 40]): " + listIsNotEmpty(numbers))
      println("4. listContains([10, 20, 30, 40], 20): " + listContains(numbers, 20))
      println("5. listContainsAny([10, 20, 30, 40], [20, 99]): " + listContainsAny(numbers, [20, 99]))
      println("6. listContainsAll([10, 20, 30, 40], [20, 30]): " + listContainsAll(numbers, [20, 30]))
      println("7. listClearAll([10, 20, 30, 40]): " + listClearAll(numbers))
      println("8. listSingleton(42): " + listSingleton(42))
      println("9. listSingletonInt(42): " + listSingletonInt(42))
      println("10. listSingletonString(\"flux\"): " + listSingletonString("flux"))
      println("11. listClone([10, 20, 30, 40]): " + listClone(numbers))
      println("12. listToList(99): " + listToList(99))
      println("13. listToSet([1, 2, 2, 3]): " + listToSet([1, 2, 2, 3]))

      mut as list of data: pairs = [["nome", "Flux"], ["versao", 1]]
      println("14. listToMap([[\"nome\", \"Flux\"], [\"versao\", 1]]): " + listToMap(pairs))
      println("15. listToString([10, 20, 30, 40]): " + listToString(numbers))
      println("16. listFromList([1, 2, 3]): " + listFromList([1, 2, 3]))
      println("17. listFromSet({10, 20}): " + listFromSet({10, 20}))
      println("18. listFromString(\"flux\"): " + listFromString("flux"))
}
