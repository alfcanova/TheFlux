use OoStdLib

struct (Transacao) {
      mut: .id: string
      mut: .valor: float64
      mut: .timestamp_ms: int64
}

program (ExampleOfUseOoStdLib_OOIntrospectionContract) {
      println("==================================================")
      println("  Exemplo: OOIntrospectionContract (Introspeccao)")
      println("==================================================")

      mut as Transacao: tx = Transacao(
            .id: "TX-99812"
            .valor: 1540.75
            .timestamp_ms: 1726598400000
      )
      mut as Transacao: tx2 = Transacao(
            .id: "TX-99813"
            .valor: 2000.00
            .timestamp_ms: 1726598405000
      )

      #L 1. Envelopamento para o contrato Auditavel
      mut as data: obj_tx = ooCastToContract(tx, "Auditavel")
      mut as data: obj_tx2 = ooCastToContract(tx2, "Auditavel")

      #L 2. Obtencao do nome do contrato e tipo subjacente
      println("1. Nome do contrato: " + ooContractName(obj_tx))
      println("   Tipo real subjacente: " + ooUnderlyingType(obj_tx))

      #L 3. Listagem e contagem de metodos do contrato
      mut as list of data: metodos = ooMethods("Auditavel")
      mut as int64: qtd_metodos = ooMethodCount("Auditavel")
      println("2. Metodos disponiveis no contrato: " + metodos)
      println("   Quantidade de metodos: " + qtd_metodos)

      #L 4. Listagem e contagem de contratos implementados pela struct
      mut as list of data: contratos = ooContracts(tx)
      mut as int64: qtd_contratos = ooContractCount(tx)
      println("3. Contratos suportados pela struct: " + contratos)
      println("   Quantidade de contratos: " + qtd_contratos)

      #L 5. Exportacao completa de metadados para mapa
      mut as map: mapa_inspecao = ooToMap(obj_tx)
      println("4. Mapa de introspeccao completo:")
      println("   Contrato: " + mapa_inspecao["contract"])
      println("   Tipo: " + mapa_inspecao["type"])
      println("   Valido: " + mapa_inspecao["valid"])
      println("   Dados: " + mapa_inspecao["data"])

      #L 6. Pares de chave/valor canonicos via ooEntries
      mut as list of data: entradas = ooEntries(obj_tx)
      println("5. Entradas do envelope: " + entradas)

      #L 7. Diferencial estrutural entre dois envelopes polimorficos via ooDiff
      mut as map: diferenca = ooDiff(obj_tx, obj_tx2)
      println("6. Diferenca entre obj_tx e obj_tx2: " + diferenca)
}
