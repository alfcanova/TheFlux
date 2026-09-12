use SetStdLib

program (ExampleOfUseSetStdLib_SetSearchContract) {
      println("==================================================")
      println("  Exemplo: SetSearchContract (5 Operacoes)")
      println("==================================================")

      mut as set of int64: s1 = {10, 20, 30, 40, 50}
      println("1. setContains({10, 20, 30, 40, 50}, 30): " + setContains(s1, 30))
      println("   setContains({10, 20, 30, 40, 50}, 99): " + setContains(s1, 99))

      mut as set of int64: subset_any = {99, 20}
      println("2. setContainsAny(s1, {99, 20}): " + setContainsAny(s1, subset_any))

      mut as set of int64: subset_all = {10, 30, 50}
      println("3. setContainsAll(s1, {10, 30, 50}): " + setContainsAll(s1, subset_all))

      println("4. setIndexOf(s1, 30): " + setIndexOf(s1, 30))
      println("   setIndexOf(s1, 99): " + setIndexOf(s1, 99))

      println("5. setCount(s1, 30): " + setCount(s1, 30))
      println("   setCount(s1, 99): " + setCount(s1, 99))
}
