use SetStdLib

program (ExampleOfUseSetStdLib_SetUtilityContract) {
      println("==================================================")
      println("  Exemplo: SetUtilityContract (3 Operacoes)")
      println("==================================================")

      mut as set of int64: a = {10, 20, 30}
      mut as set of int64: b = {30, 20, 10}
      mut as set of int64: c = {10, 20, 40}
      println("1. setEquals({10, 20, 30}, {30, 20, 10}): " + setEquals(a, b))
      println("   setEquals({10, 20, 30}, {10, 20, 40}): " + setEquals(a, c))

      println("2. setJoin({10, 20, 30}, \", \"): " + setJoin(a, ", "))
      println("3. setSwap({10, 20, 30}, 20, 99): " + setSwap(a, 20, 99))
}
