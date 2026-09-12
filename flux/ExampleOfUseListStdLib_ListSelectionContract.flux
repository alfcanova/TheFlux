use ListStdLib

program (ExampleOfUseListStdLib_ListSelectionContract) {
      println("==================================================")
      println("  Exemplo: ListSelectionContract (7 Operacoes)")
      println("==================================================")

      mut as list of int64: items = [10, 20, 30, 20, 40, 50]
      println("1. listTake([10, 20, 30, 20, 40, 50], 3): " + listTake(items, 3))
      println("2. listDrop([10, 20, 30, 20, 40, 50], 2): " + listDrop(items, 2))
      println("3. listTakeLast([10, 20, 30, 20, 40, 50], 2): " + listTakeLast(items, 2))
      println("4. listDropLast([10, 20, 30, 20, 40, 50], 2): " + listDropLast(items, 2))
      println("5. listFilter([10, 20, 30, 20, 40, 50], [20, 50]): " + listFilter(items, [20, 50]))
      println("6. listOmit([10, 20, 30, 20, 40, 50], [20, 50]): " + listOmit(items, [20, 50]))
      println("7. listDistinct([10, 20, 30, 20, 40, 50]): " + listDistinct(items))
}
