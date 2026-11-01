use StructStdLib

struct (Transacao) {
      mut: .id: string
      mut: .valor: float64
      mut: .timestamp_ms: int64
}

program (ExampleOfUseStructStdLib_StructCoreContract) {
      println("==================================================")
      println("  Exemplo: StructCoreContract (Nucleo e Alocacao)")
      println("==================================================")

      mut as Transacao: tx = Transacao(
            .id: "TX-1001"
            .valor: 250.50
            .timestamp_ms: 1726600000000
      )

      #L 1. Identificacao nominal da struct
      println("1. Nome da struct: " + structName(tx))

      #L 2. Leitura dinamica de campo por reflexao
      println("2. Campo id: " + structGetField(tx, "id"))
      println("   Campo valor: " + structGetField(tx, "valor"))

      #L 3. Clonagem profunda de struct
      mut as data: tx_clone = structClone(tx)
      println("3. Clone realizado: " + structToString(tx_clone))

      #L 4. Comparacao estrutural
      mut as bool: iguais = structEquals(tx, tx_clone)
      println("4. Original e clone sao iguais: " + iguais)

      #L 5. Alocacao dinamica zero-initialized
      mut as data: tx_alocada = structAllocate("Transacao")
      println("5. Struct alocada dinamicamente: " + structToString(tx_alocada))

      #L 6. Instanciacao via mapa de dados
      mut as map: dados = map{}
      dados["id"] = "TX-2002"
      dados["valor"] = "999.99"
      dados["timestamp_ms"] = "1726600500000"
      mut as data: tx_map = structFromMap("Transacao", dados)
      println("6. Struct criada a partir de mapa: " + structToString(tx_map))

      #L 7. Modificacao dinamica de campo (move)
      mut as data: tx_modificada = structSetField(tx, "valor", "300.75")
      println("7. Campo valor atualizado: " + structGetField(tx_modificada, "valor"))
}
