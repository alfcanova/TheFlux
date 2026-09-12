use MapStdLib

program (ExampleOfUseMapStdLib_MapRelationContract) {
      println("==================================================")
      println("  Exemplo: MapRelationContract (5 Operacoes)")
      println("==================================================")

      mut as map: sub = map{"a": 10, "b": 20}
      mut as map: sup = map{"a": 10, "b": 20, "c": 30}
      mut as map: outro = map{"x": 100, "y": 200}
      mut as map: mesmo_k = map{"a": 99, "b": 88, "c": 77}

      println("1. mapIsSubmap(sub, sup): " + mapIsSubmap(sub, sup))
      println("   mapIsSubmap(sup, sub): " + mapIsSubmap(sup, sub))
      println("2. mapIsSupermap(sup, sub): " + mapIsSupermap(sup, sub))
      println("   mapIsSupermap(sub, sup): " + mapIsSupermap(sub, sup))
      println("3. mapHasSameKeys(sup, mesmo_k): " + mapHasSameKeys(sup, mesmo_k))
      println("   mapHasSameKeys(sub, sup): " + mapHasSameKeys(sub, sup))
      println("4. mapDisjointKeys(sub, outro): " + mapDisjointKeys(sub, outro))
      println("   mapDisjointKeys(sub, sup): " + mapDisjointKeys(sub, sup))
      println("5. mapDiffKeys(sup, sub): " + mapDiffKeys(sup, sub))
}
