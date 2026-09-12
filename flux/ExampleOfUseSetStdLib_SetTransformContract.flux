use SetStdLib

program (ExampleOfUseSetStdLib_SetTransformContract) {
      println("==================================================")
      println("  Exemplo: SetTransformContract (4 Operacoes)")
      println("==================================================")

      mut as list of data: all_sets = [{1, 2}, {2, 3}, {3, 4}]
      println("1. setUnionAll([{1, 2}, {2, 3}, {3, 4}]): " + setUnionAll(all_sets))

      mut as list of data: common_sets = [{1, 2, 3}, {2, 3, 4}, {3, 5, 2}]
      println("2. setIntersectAll([{1, 2, 3}, {2, 3, 4}, {3, 5, 2}]): " + setIntersectAll(common_sets))

      mut as set of int64: s1 = {1, 2}
      mut as set of string: s2 = {"a", "b"}
      println("3. setCartesianProduct({1, 2}, {\"a\", \"b\"}): " + setCartesianProduct(s1, s2))

      mut as set of int64: s3 = {1, 2, 3}
      println("4. setPowerSet({1, 2, 3}): " + setPowerSet(s3))
}
