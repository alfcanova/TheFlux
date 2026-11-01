use ListStdLib

program (ExampleOfUseListStdLib_ListTransformContract) {
      println("==================================================")
      println("  Exemplo: ListTransformContract (10 Operacoes)")
      println("==================================================")

      mut as list of int64: unsorted = [30, 10, 50, 20, 40]
      println("1. listSort([30, 10, 50, 20, 40]): " + listSort(unsorted))
      println("2. listSortAscending([30, 10, 50, 20, 40]): " + listSortAscending(unsorted))
      println("3. listSortDescending([30, 10, 50, 20, 40]): " + listSortDescending(unsorted))
      println("4. listReverse([1, 2, 3, 4, 5]): " + listReverse([1, 2, 3, 4, 5]))
      println("5. listRotateLeft([1, 2, 3, 4, 5], 2): " + listRotateLeft([1, 2, 3, 4, 5], 2))
      println("6. listRotateRight([1, 2, 3, 4, 5], 2): " + listRotateRight([1, 2, 3, 4, 5], 2))

      mut as list of data: nested = [[1, 2], [3], 4]
      println("7. listFlatten([[1, 2], [3], 4]): " + listFlatten(nested))
      println("8. listPartition([1, 2, 3, 4, 5, 6, 7], 3): " + listPartition([1, 2, 3, 4, 5, 6, 7], 3))

      mut as list of data: l1 = [1, 2, 3]
      mut as list of data: l2 = ["a", "b", "c"]
      mut as list of data: zipped = listZip(l1, l2)
      println("9. listZip([1, 2, 3], [\"a\", \"b\", \"c\"]): " + zipped)
      println("10. listUnzip(zipped): " + listUnzip(zipped))
}
