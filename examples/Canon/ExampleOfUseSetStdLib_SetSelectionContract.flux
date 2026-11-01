use SetStdLib

program (ExampleOfUseSetStdLib_SetSelectionContract) {
      println("==================================================")
      println("  Exemplo: SetSelectionContract (6 Operacoes)")
      println("==================================================")

      mut as set of int64: a = {10, 20, 30, 40, 50}
      println("1. setTake({10, 20, 30, 40, 50}, 3): " + setTake(a, 3))
      println("2. setDrop({10, 20, 30, 40, 50}, 2): " + setDrop(a, 2))
      println("3. setTakeLast({10, 20, 30, 40, 50}, 2): " + setTakeLast(a, 2))
      println("4. setDropLast({10, 20, 30, 40, 50}, 2): " + setDropLast(a, 2))
      println("5. setFilter(a, [20, 40, 99]): " + setFilter(a, [20, 40, 99]))
      println("6. setOmit(a, [10, 30, 50]): " + setOmit(a, [10, 30, 50]))
}
