use MapStdLib

program (ExampleOfUseMapStdLib_MapTransformContract) {
      println("==================================================")
      println("  Exemplo: MapTransformContract (5 Operacoes)")
      println("==================================================")

      mut as map: m1 = map{"a": 1, "b": 2}
      mut as map: m2 = map{"b": 20, "c": 3}
      println("1. mapMerge(m1, m2): " + mapMerge(m1, m2))

      mut as map: orig = map{"admin": 1, "user": 2}
      println("2. mapInvert(orig): " + mapInvert(orig))

      println("3. mapZip([\"k1\", \"k2\", \"k3\"], [100, 200, 300]): " + mapZip(["k1", "k2", "k3"], [100, 200, 300]))

      mut as map: full = map{"id": 10, "nome": "Alice", "senha": "secret", "ativo": true}
      println("4. mapFilterKeys(full, [\"id\", \"nome\"]): " + mapFilterKeys(full, ["id", "nome"]))
      println("5. mapOmitKeys(full, [\"senha\"]): " + mapOmitKeys(full, ["senha"]))
}
