use MapStdLib

program (ExampleOfUseMapStdLib_MapMutationContract) {
      println("==================================================")
      println("  Exemplo: MapMutationContract (6 Operacoes)")
      println("==================================================")

      mut as map: m = map{"a": 10, "b": 20}
      println("1. mapPut(m, \"c\", 30): " + mapPut(m, "c", 30))
      println("2. mapPutIfAbsent(m, \"a\", 99): " + mapPutIfAbsent(m, "a", 99))
      println("   mapPutIfAbsent(m, \"d\", 40): " + mapPutIfAbsent(m, "d", 40))
      println("3. mapReplace(m, \"b\", 200): " + mapReplace(m, "b", 200))
      println("4. mapPutAll(m, map{\"e\": 50, \"f\": 60}): " + mapPutAll(m, map{"e": 50, "f": 60}))
      println("5. mapRemove(m, \"a\"): " + mapRemove(m, "a"))
      println("6. mapRemoveAll(m, [\"a\", \"b\"]): " + mapRemoveAll(m, ["a", "b"]))
}
