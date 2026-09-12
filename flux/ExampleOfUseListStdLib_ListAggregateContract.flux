use ListStdLib

program (ExampleOfUseListStdLib_ListAggregateContract) {
      println("==================================================")
      println("  Exemplo: ListAggregateContract (6 Operacoes)")
      println("==================================================")

      mut as list of int64: numbers = [12, 45, 7, 89, 23, 7]
      println("1. listMin([12, 45, 7, 89, 23, 7]): " + listMin(numbers))
      println("2. listMax([12, 45, 7, 89, 23, 7]): " + listMax(numbers))
      println("3. listSum([12, 45, 7, 89, 23, 7]): " + listSum(numbers))
      println("4. listProduct([2, 3, 4, 5]): " + listProduct([2, 3, 4, 5]))
      println("5. listAverage([10, 20, 30, 40, 50]): " + listAverage([10, 20, 30, 40, 50]))
      println("6. listCountValues([12, 45, 7, 89, 23, 7], 7): " + listCountValues(numbers, 7))
}
