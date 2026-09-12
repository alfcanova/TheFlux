use ListStdLib

program (ExampleOfUseListStdLib_ListMutationContract) {
      println("==================================================")
      println("  Exemplo: ListMutationContract (13 Operacoes)")
      println("==================================================")

      mut as list of int64: base = [10, 20, 30]
      println("1. listPushFront([10, 20, 30], 5): " + listPushFront(base, 5))
      println("2. listPushBack([10, 20, 30], 40): " + listPushBack(base, 40))
      println("3. listPrepend([10, 20, 30], [1, 2]): " + listPrepend(base, [1, 2]))
      println("4. listAppend([10, 20, 30], [40, 50]): " + listAppend(base, [40, 50]))
      println("5. listInsertFirst([10, 20, 30], 1): " + listInsertFirst(base, 1))
      println("6. listInsertAt([10, 20, 30], 2, 15): " + listInsertAt(base, 2, 15))
      println("7. listInsertLast([10, 20, 30], 50): " + listInsertLast(base, 50))
      println("8. listInsertAll([10, 20, 30], 2, [14, 15]): " + listInsertAll(base, 2, [14, 15]))
      println("9. listRemoveFirst([10, 20, 30]): " + listRemoveFirst(base))
      println("10. listRemoveAt([10, 20, 30], 2): " + listRemoveAt(base, 2))
      println("11. listRemoveLast([10, 20, 30]): " + listRemoveLast(base))
      println("12. listRemove([10, 20, 30, 20], 20): " + listRemove([10, 20, 30, 20], 20))
      println("13. listRemoveAll([10, 20, 30, 20], 20): " + listRemoveAll([10, 20, 30, 20], 20))
}
