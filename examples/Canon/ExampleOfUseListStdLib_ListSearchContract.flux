use ListStdLib

program (ExampleOfUseListStdLib_ListSearchContract) {
      println("==================================================")
      println("  Exemplo: ListSearchContract (8 Operacoes - 1-Index)")
      println("==================================================")

      mut as list of int64: items = [10, 20, 30, 20, 40, 20]
      println("1. listContains(items, 30): " + listContains(items, 30))
      println("2. listContainsAny(items, [99, 20]): " + listContainsAny(items, [99, 20]))
      println("3. listContainsAll(items, [10, 20, 30]): " + listContainsAll(items, [10, 20, 30]))
      println("4. listStartsWith(items, [10, 20]): " + listStartsWith(items, [10, 20]))
      println("5. listEndsWith(items, [40, 20]): " + listEndsWith(items, [40, 20]))
      println("6. listIndexOf(items, 20): " + listIndexOf(items, 20))
      println("7. listLastIndexOf(items, 20): " + listLastIndexOf(items, 20))
      println("8. listCount(items, 20): " + listCount(items, 20))
}
