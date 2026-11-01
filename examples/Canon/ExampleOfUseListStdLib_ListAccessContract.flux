use ListStdLib

program (ExampleOfUseListStdLib_ListAccessContract) {
      println("==================================================")
      println("  Exemplo: ListAccessContract (7 Operacoes)")
      println("==================================================")

      mut as list of int64: items = [10, 20, 30, 40, 50]
      println("1. listGetFirst([10, 20, 30, 40, 50]): " + listGetFirst(items))
      println("2. listGetAt([10, 20, 30, 40, 50], 3): " + listGetAt(items, 3))
      println("3. listGetLast([10, 20, 30, 40, 50]): " + listGetLast(items))
      println("4. listGetLeft([10, 20, 30, 40, 50], 2): " + listGetLeft(items, 2))
      println("5. listGetRight([10, 20, 30, 40, 50], 2): " + listGetRight(items, 2))
      println("6. listGetCenter([10, 20, 30, 40, 50], 1): " + listGetCenter(items, 1))
      println("7. listSlice([10, 20, 30, 40, 50], 2, 4): " + listSlice(items, 2, 4))
}
