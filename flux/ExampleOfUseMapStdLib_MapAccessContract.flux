use MapStdLib

program (ExampleOfUseMapStdLib_MapAccessContract) {
      println("==================================================")
      println("  Exemplo: MapAccessContract (12 Operacoes)")
      println("==================================================")

      mut as map: m = map{"a": 10, "b": 20, "c": 30, "d": 40, "e": 50}
      println("1. mapGet(m, \"b\"): " + mapGet(m, "b"))
      println("   mapGet(m, \"missing\"): " + mapGet(m, "missing"))
      println("2. mapGetOrDefault(m, \"b\", 999): " + mapGetOrDefault(m, "b", 999))
      println("   mapGetOrDefault(m, \"missing\", 999): " + mapGetOrDefault(m, "missing", 999))
      println("3. mapGetFirst(m): " + mapGetFirst(m))
      println("4. mapGetAt(m, 2): " + mapGetAt(m, 2))
      println("5. mapGetLast(m): " + mapGetLast(m))
      println("6. mapGetLeft(m, 2): " + mapGetLeft(m, 2))
      println("7. mapGetRight(m, 2): " + mapGetRight(m, 2))
      println("8. mapGetCenter(m, 1): " + mapGetCenter(m, 1))
      println("9. mapSlice(m, 2, 4): " + mapSlice(m, 2, 4))
      println("10. mapKeys(m): " + mapKeys(m))
      println("11. mapValues(m): " + mapValues(m))
      println("12. mapEntries(m): " + mapEntries(m))
}
