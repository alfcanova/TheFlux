use RegexStdLib

program (ExampleOfUseRegexStdLib_RegexCaptureContract) {
      println("==================================================")
      println("  Exemplo: RegexCaptureContract (Grupos de Captura)")
      println("==================================================")

      mut as string: cabecalho = "usuario: alfcanova, cargo: arquiteto, codigo: SEC-987"
      mut as string: log_transacoes = "id: TRX-101, valor: 450; id: TRX-102, valor: 890; id: TRX-103, valor: 120"

      #L 1. Extracao de grupos da primeira ocorrencia como lista (regexExtractGroups)
      mut as list of data: grupos_lista = regexExtractGroups("([a-zA-Z]+)-([0-9]+)", cabecalho)
      println("1. Grupos extraidos como lista (primeira ocorrencia): ")
      println("   Prefixo capturado (G1): ", grupos_lista[1])
      println("   Numero capturado  (G2): ", grupos_lista[2])

      #L 2. Captura de grupos da primeira ocorrencia como mapa (regexCaptureGroups)
      mut as map: grupos_mapa = regexCaptureGroups("([a-zA-Z]+)-([0-9]+)", cabecalho)
      println("2. Grupos capturados como mapa: ")
      println("   Mapa completo:          ", grupos_mapa)
      println("   Grupo '1':              ", grupos_mapa["1"])
      println("   Grupo '2':              ", grupos_mapa["2"])

      #L 3. Extracao de grupos de todas as ocorrencias como listas aninhadas (regexExtractAllGroups)
      mut as list of data: todos_grupos_lista = regexExtractAllGroups("TRX-([0-9]+), valor: ([0-9]+)", log_transacoes)
      println("3. Todas as ocorrencias como listas aninhadas: ")
      println("   Lista total de grupos:  ", todos_grupos_lista)

      #L 4. Captura de grupos de todas as ocorrencias como lista de mapas (regexCaptureAll)
      mut as list of data: todos_grupos_mapa = regexCaptureAll("TRX-([0-9]+), valor: ([0-9]+)", log_transacoes)
      println("4. Todas as ocorrencias como lista de mapas: ")
      println("   Lista de mapas:         ", todos_grupos_mapa)
      mut as map: primeiro_trx = todos_grupos_mapa[1] as map
      println("   Primeira transacao ID:   ", primeiro_trx["1"])
      println("   Primeira transacao Val:  ", primeiro_trx["2"])
}
