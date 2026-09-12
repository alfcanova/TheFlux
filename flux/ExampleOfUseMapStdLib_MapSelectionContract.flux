use MapStdLib

program (ExampleOfUseMapStdLib_MapSelectionContract) {
      println("==================================================")
      println("  Exemplo: MapSelectionContract (8 Operacoes)")
      println("==================================================")

      mut as map: m = map{"a": 10, "b": 20, "c": 30, "d": 20, "e": 50}
      println("1. mapTake(m, 2): " + mapTake(m, 2))
      println("2. mapDrop(m, 3): " + mapDrop(m, 3))
      println("3. mapTakeLast(m, 2): " + mapTakeLast(m, 2))
      println("4. mapDropLast(m, 2): " + mapDropLast(m, 2))
      println("5. mapFilterKeys(m, [\"a\", \"c\", \"e\"]): " + mapFilterKeys(m, ["a", "c", "e"]))
      println("6. mapOmitKeys(m, [\"b\", \"d\"]): " + mapOmitKeys(m, ["b", "d"]))
      println("7. mapFilterValues(m, [20, 50]): " + mapFilterValues(m, [20, 50]))
      println("8. mapOmitValues(m, [10, 30]): " + mapOmitValues(m, [10, 30]))
}
