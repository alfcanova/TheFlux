use SetStdLib

program (ExampleOfUseSetStdLib_SetMutationContract) {
      println("==================================================")
      println("  Exemplo: SetMutationContract (4 Operacoes)")
      println("==================================================")

      mut as set of int64: a = {1, 2, 3}
      println("1. setInclude({1, 2, 3}, 4): " + setInclude(a, 4))
      println("2. setIncludeAll({1, 2, 3}, {4, 5}): " + setIncludeAll(a, {4, 5}))
      println("3. setExclude({1, 2, 3}, 2): " + setExclude(a, 2))
      println("4. setExcludeAll({1, 2, 3}, {1, 3}): " + setExcludeAll(a, {1, 3}))
}
