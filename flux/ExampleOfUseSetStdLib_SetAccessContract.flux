use SetStdLib

program (ExampleOfUseSetStdLib_SetAccessContract) {
      println("==================================================")
      println("  Exemplo: SetAccessContract (7 Operacoes)")
      println("==================================================")

      mut as set of int64: items = {10, 20, 30, 40, 50}
      println("1. setGetFirst({10, 20, 30, 40, 50}): " + setGetFirst(items))
      println("2. setGetLast({10, 20, 30, 40, 50}): " + setGetLast(items))
      println("3. setGetAt({10, 20, 30, 40, 50}, 3): " + setGetAt(items, 3))
      println("4. setGetLeft({10, 20, 30, 40, 50}, 2): " + setGetLeft(items, 2))
      println("5. setGetRight({10, 20, 30, 40, 50}, 2): " + setGetRight(items, 2))
      println("6. setGetCenter({10, 20, 30, 40, 50}, 1): " + setGetCenter(items, 1))
      println("7. setSlice({10, 20, 30, 40, 50}, 2, 4): " + setSlice(items, 2, 4))
}
