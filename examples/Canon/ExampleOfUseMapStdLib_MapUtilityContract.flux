use MapStdLib

program (ExampleOfUseMapStdLib_MapUtilityContract) {
      println("==================================================")
      println("  Exemplo: MapUtilityContract (4 Operacoes)")
      println("==================================================")

      mut as map: m1 = map{"a": 10, "b": 20}
      mut as map: m2 = map{"b": 20, "a": 10}
      mut as map: m3 = map{"a": 10, "b": 99}
      println("1. mapEquals(m1, m2): " + mapEquals(m1, m2))
      println("   mapEquals(m1, m3): " + mapEquals(m1, m3))

      println("2. mapJoin(m1, \", \", \" = \"): " + mapJoin(m1, ", ", " = "))
      println("3. mapSwapKeys(m1, \"a\", \"b\"): " + mapSwapKeys(m1, "a", "b"))
      println("4. mapCount(m1, \"a\"): " + mapCount(m1, "a"))
      println("   mapCount(m1, \"z\"): " + mapCount(m1, "z"))
}
