use ListStdLib

program (ExampleOfUseListStdLib_ListCombinatorContract) {
      println("==================================================")
      println("  Exemplo: ListCombinatorContract (5 Operacoes)")
      println("==================================================")

      mut as list of int64: numbers = [10, 20, 30, 40, 50]

      #L 1. listChunk
      println("1. listChunk([10..50], 2): " + listChunk(numbers, 2))

      #L 2. listWindow
      println("2. listWindow([10..50], 3): " + listWindow(numbers, 3))

      #L 3. listFrequencies
      mut as list of string: tags = ["flux", "ai", "flux", "lang", "flux", "ai"]
      println("3. listFrequencies(tags): " + listFrequencies(tags))

      #L 4. listCartesian
      mut as list of int64: l1 = [1, 2]
      mut as list of string: l2 = ["A", "B"]
      println("4. listCartesian([1, 2], [\"A\", \"B\"]): " + listCartesian(l1, l2))

      #L 5. listCombinations
      mut as list of string: items = ["a", "b", "c", "d"]
      println("5. listCombinations([a, b, c, d], 2): " + listCombinations(items, 2))
}
