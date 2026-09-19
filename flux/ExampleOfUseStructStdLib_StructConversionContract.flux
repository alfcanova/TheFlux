use StructStdLib

struct (Transacao) {
      mut: .id: string
      mut: .valor: float64
      mut: .timestamp_ms: int64
}

program (ExampleOfUseStructStdLib_StructConversionContract) {
      println("==================================================")
      println("  Exemplo: StructConversionContract (Conversoes)")
      println("==================================================")

      mut as Transacao: tx1 = Transacao(
            .id: "TX-1001"
            .valor: 250.50
            .timestamp_ms: 1726600000000
      )

      #L 1. Conversao de struct para mapa chave-valor
      mut as map: mapa = structToMap(tx1)
      println("1. Mapa extraido:")
      println("   id: " + mapa["id"])
      println("   valor: " + mapa["valor"])
      println("   timestamp_ms: " + mapa["timestamp_ms"])

      #L 2. Lista de pares [chave, valor]
      println("2. Entradas [chave, valor]: " + structEntries(tx1))

      #L 3. Conversao para representacao textual canonica
      mut as string: txt = structToString(tx1)
      println("3. Representacao textual: " + txt)

      #L 4. Diferenca estrutural entre duas instancias
      mut as Transacao: tx2 = Transacao(
            .id: "TX-1001"
            .valor: 300.75
            .timestamp_ms: 1726600000000
      )
      mut as map: diff = structDiff(tx1, tx2)
      println("4. Diferenca estrutural (diff):")
      println("   Diferenca em valor: " + diff["valor"])
}
