use ListStdLib

program (ExampleOfUseListStdLib_ListUtilityContract) {
      println("==================================================")
      println("  Exemplo: ListUtilityContract (7 Operacoes)")
      println("==================================================")

      mut as list of int64: l1 = [1, 2]
      mut as list of int64: l2 = [1, 2]
      mut as list of int64: l3 = [3, 4]

      println("1. listEquals([1, 2], [1, 2]): " + listEquals(l1, l2))
      println("   listEquals([1, 2], [3, 4]): " + listEquals(l1, l3))

      mut as list of string: words = ["The", "Flux", "Language"]
      println("2. listJoin(words, \" \"): " + listJoin(words, " "))

      println("3. listSwap([10, 20, 30, 40], 1, 4): " + listSwap([10, 20, 30, 40], 1, 4))
      println("4. listReplaceAt([10, 20, 30], 2, 99): " + listReplaceAt([10, 20, 30], 2, 99))
      println("5. listConcat([1, 2], [3, 4]): " + listConcat(l1, l3))
      println("6. listRepeat(42, 4): " + listRepeat(42, 4))
      println("7. listFill([1, 2, 3, 4], 0): " + listFill([1, 2, 3, 4], 0))
}
