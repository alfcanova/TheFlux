use SetStdLib

program (ExampleOfUseSetStdLib_SetRelationContract) {
      println("==================================================")
      println("  Exemplo: SetRelationContract (5 Operacoes)")
      println("==================================================")

      mut as set of int64: a = {1, 2, 3, 4}
      println("1. setIsSubset({1, 2}, a): " + setIsSubset({1, 2}, a))
      println("   setIsSubset({1, 9}, a): " + setIsSubset({1, 9}, a))
      println("2. setIsSuperset(a, {1, 2}): " + setIsSuperset(a, {1, 2}))
      println("3. setIsDisjoint({8, 9}, a): " + setIsDisjoint({8, 9}, a))
      println("4. setIsProperSubset({1, 2}, a): " + setIsProperSubset({1, 2}, a))
      println("5. setIsProperSuperset(a, {1, 2}): " + setIsProperSuperset(a, {1, 2}))
}
