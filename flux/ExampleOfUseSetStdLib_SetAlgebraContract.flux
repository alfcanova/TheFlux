use SetStdLib

program (ExampleOfUseSetStdLib_SetAlgebraContract) {
      println("==================================================")
      println("  Exemplo: SetAlgebraContract (4 Operacoes)")
      println("==================================================")

      mut as set of int64: a = {1, 2, 3}
      mut as set of int64: b = {3, 4, 5}
      println("1. setUnion({1, 2, 3}, {3, 4, 5}): " + setUnion(a, b))
      println("2. setIntersect({1, 2, 3}, {3, 4, 5}): " + setIntersect(a, b))
      println("3. setDifference({1, 2, 3}, {3, 4, 5}): " + setDifference(a, b))
      println("4. setSymmetricDifference({1, 2, 3}, {3, 4, 5}): " + setSymmetricDifference(a, b))
}
