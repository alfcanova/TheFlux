use MapStdLib

program (ExampleOfUseMapStdLib_MapAggregateContract) {
      println("==================================================")
      println("  Exemplo: MapAggregateContract (6 Operacoes)")
      println("==================================================")

      mut as map: notas = map{"mat": 80, "fis": 90, "qui": 80, "bio": 70}
      println("1. mapMin(notas): " + mapMin(notas))
      println("2. mapMax(notas): " + mapMax(notas))
      println("3. mapSum(notas): " + mapSum(notas))

      mut as map: fatores = map{"a": 2, "b": 3, "c": 4, "d": 5}
      println("4. mapProduct(fatores): " + mapProduct(fatores))
      println("5. mapAverage(notas): " + mapAverage(notas))
      println("6. mapCountValues(notas, 80): " + mapCountValues(notas, 80))
      println("   mapCountValues(notas, 100): " + mapCountValues(notas, 100))
}
