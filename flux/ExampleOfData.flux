program (ExampleOfData) {
      print("=== Data: lista heterogenea ===")
      mut as data: payload = ["ok", 42, [0.1, 0.2, 0.3], 0]
      print("Status: " + payload[1])
      print("Ciclo: " + payload[2])
      print("Primeira amostra: " + payload[3][1])

      print("=== Data: atribuicao por indice ===")
      payload[1] = "done"
      payload[4] = 3
      print("Status atualizado: " + payload[1])
      print("Total: " + payload[4])

      print("=== Data: mutacao aninhada ===")
      payload[3][2] = 0.25
      print("Segunda amostra atualizada: " + payload[3][2])

      print("=== Data: growth por atribuicao ===")
      mut as data: simples = [1, 2, 3]
      simples[4] = 100
      simples[5] = 200
      print(simples)

      print("--- done ---")
}