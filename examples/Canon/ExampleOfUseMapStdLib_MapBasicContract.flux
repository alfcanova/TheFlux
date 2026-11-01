use MapStdLib

program (ExampleOfUseMapStdLib_MapBasicContract) {
      println("==================================================")
      println("  Exemplo: MapBasicContract (19 Operacoes)")
      println("==================================================")

      mut as map: m = map{"a": 10, "b": 20, "c": 30}
      println("1. mapLength(m): " + mapLength(m))
      println("2. mapIsEmpty(m): " + mapIsEmpty(m))
      println("3. mapIsNotEmpty(m): " + mapIsNotEmpty(m))
      println("4. mapContainsKey(m, \"b\"): " + mapContainsKey(m, "b"))
      println("   mapContainsKey(m, \"z\"): " + mapContainsKey(m, "z"))
      println("5. mapContainsAnyKey(m, [\"b\", \"z\"]): " + mapContainsAnyKey(m, ["b", "z"]))
      println("6. mapContainsAllKeys(m, [\"a\", \"b\"]): " + mapContainsAllKeys(m, ["a", "b"]))
      println("7. mapContainsValue(m, 20): " + mapContainsValue(m, 20))
      println("   mapContainsValue(m, 99): " + mapContainsValue(m, 99))
      println("8. mapContainsAnyValue(m, [20, 99]): " + mapContainsAnyValue(m, [20, 99]))
      println("9. mapContainsAllValues(m, [10, 20]): " + mapContainsAllValues(m, [10, 20]))
      println("10. mapClearAll(m): " + mapClearAll(m))
      println("11. mapSingleton(\"id\", 101): " + mapSingleton("id", 101))
      println("12. mapClone(m): " + mapClone(m))
      println("13. mapToList(m): " + mapToList(m))
      println("14. mapToSet(m): " + mapToSet(m))
      println("15. mapToMap([[\"x\", 1], [\"y\", 2]]): " + mapToMap([["x", 1], ["y", 2]]))
      println("16. mapToString(m): " + mapToString(m))
      println("17. mapFromList([[\"k1\", 10], [\"k2\", 20]]): " + mapFromList([["k1", 10], ["k2", 20]]))
      println("18. mapFromSet({[\"k1\", 10], [\"k2\", 20]}): " + mapFromSet({["k1", 10], ["k2", 20]}))
      println("19. mapFromString(\"a: 1, b: 2\"): " + mapFromString("a: 1, b: 2"))
}
