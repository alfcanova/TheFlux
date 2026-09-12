use SetStdLib

program (ExampleOfUseSetStdLib_SetAggregateContract) {
      println("==================================================")
      println("  Exemplo: SetAggregateContract (6 Operacoes)")
      println("==================================================")

      mut as set of int64: a = {12, 45, 7, 89, 23}
      println("1. setMin({12, 45, 7, 89, 23}): " + setMin(a))
      println("2. setMax({12, 45, 7, 89, 23}): " + setMax(a))
      println("3. setSum({12, 45, 7, 89, 23}): " + setSum(a))
      println("4. setProduct({2, 3, 4, 5}): " + setProduct({2, 3, 4, 5}))
      println("5. setAverage({10, 20, 30, 40, 50}): " + setAverage({10, 20, 30, 40, 50}))
      println("6. setCountValues({12, 45, 7, 89, 23}, 7): " + setCountValues(a, 7))
      println("   setCountValues({12, 45, 7, 89, 23}, 99): " + setCountValues(a, 99))
}
