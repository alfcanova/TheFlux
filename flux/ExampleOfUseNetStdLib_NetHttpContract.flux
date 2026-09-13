use NetStdLib

program (ExampleOfUseNetStdLib_NetHttpContract) {
      println("==================================================")
      println("  Exemplo: NetHttpContract (Status e Metodos HTTP)")
      println("==================================================")

      println("1. Status 200: " + netHttpStatusText(200))
      println("2. Status 201: " + netHttpStatusText(201))
      println("3. Status 204: " + netHttpStatusText(204))
      println("4. Status 301: " + netHttpStatusText(301))
      println("5. Status 400: " + netHttpStatusText(400))
      println("6. Status 401: " + netHttpStatusText(401))
      println("7. Status 403: " + netHttpStatusText(403))
      println("8. Status 404: " + netHttpStatusText(404))
      println("9. Status 500: " + netHttpStatusText(500))
      println("10. Status 503: " + netHttpStatusText(503))

      mut as int64: del_status = netHttpDelete("http://localhost:8080/resource")
      println("11. Chamada DELETE Concluida: " + (del_status >= 0))
}
