use MapStdLib

program (ExampleOfUseMapStdLib_MapSearchContract) {
      println("==================================================")
      println("  Exemplo: MapSearchContract (9 Operacoes)")
      println("==================================================")

      mut as map: m = map{"a": 10, "b": 20, "c": 10, "d": 30}

      #L 1. Busca por Chave
      println("1. mapContainsKey(m, \"b\"): " + mapContainsKey(m, "b"))
      println("2. mapContainsAnyKey(m, [\"z\", \"a\"]): " + mapContainsAnyKey(m, ["z", "a"]))
      println("3. mapContainsAllKeys(m, [\"a\", \"b\", \"c\"]): " + mapContainsAllKeys(m, ["a", "b", "c"]))

      #L 2. Busca por Valor
      println("4. mapContainsValue(m, 20): " + mapContainsValue(m, 20))
      println("5. mapContainsAnyValue(m, [99, 10]): " + mapContainsAnyValue(m, [99, 10]))
      println("6. mapContainsAllValues(m, [10, 20, 30]): " + mapContainsAllValues(m, [10, 20, 30]))

      #L 3. Busca Reversa e Quantificacao
      println("7. mapFindKey(m, 20): " + mapFindKey(m, 20))
      println("8. mapFindKeys(m, 10): " + mapFindKeys(m, 10))
      println("9. mapCountValues(m, 10): " + mapCountValues(m, 10))
}
