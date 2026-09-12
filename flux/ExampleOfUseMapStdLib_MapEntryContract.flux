use MapStdLib

program (ExampleOfUseMapStdLib_MapEntryContract) {
      println("==================================================")
      println("  Exemplo: MapEntryContract (5 Operacoes)")
      println("==================================================")

      #L 1. mapFromEntries & mapToEntries
      mut as list of data: pairs = [["nome", "Flux"], ["versao", 2026], ["status", "ativo"]]
      mut as map: m = mapFromEntries(pairs)
      println("1. mapFromEntries(pairs): " + m)
      println("2. mapToEntries(m): " + mapToEntries(m))

      #L 3. mapInvertMulti
      mut as map: notas = map{"mat": 80, "fis": 90, "qui": 80, "bio": 70}
      println("3. mapInvertMulti(notas): " + mapInvertMulti(notas))

      #L 4. mapGroupListBy
      mut as list of data: usuarios = [
            map{"id": 1, "tipo": "admin", "nome": "Alice"},
            map{"id": 2, "tipo": "user", "nome": "Bob"},
            map{"id": 3, "tipo": "admin", "nome": "Carol"}
      ]
      mut as map: agrupados = mapGroupListBy(usuarios, "tipo")
      println("4. mapGroupListBy(usuarios, \"tipo\"): " + agrupados)

      #L 5. mapSelectEntries
      mut as list of data: sel = mapSelectEntries(notas, ["mat", "qui", "inexistente"])
      println("5. mapSelectEntries(notas, [\"mat\", \"qui\"]): " + sel)
}
