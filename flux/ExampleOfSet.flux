program (ExampleOfSet) {
      println("=== Set: declaracao e dedup no literal ===")
      mut as set of string: sensores = {"temp", "pressao", "temp", "vibracao"}
      println("Sensores (sem duplicatas): " + sensores)

      println("=== Set: dedup de inteiros ===")
      mut as set of int64: valores = {1, 2, 2, 3, 3, 3}
      println("Valores unicos: " + valores)

      println("=== Set: operador de pertencimento in ===")
      println("temp in sensores: " + ("temp" in sensores))
      println("umidade in sensores: " + ("umidade" in sensores))
      println("2 in valores: " + (2 in valores))
      println("9 in valores: " + (9 in valores))

      println("=== Set: reatribuicao de variavel ===")
      valores = {10, 20, 30}
      println("Novos valores: " + valores)

      println("=== Set: iteracao nativa ===")
      infinite (s in sensores) {
            println("Sensor ativo: " + s)
      }

      println("=== Set: conversoes nativas por cast ===")
      mut as list of int64: lista_orig = [5, 5, 6, 7, 7]
      mut as set of data: set_convertido = lista_orig as set of data
      println("Lista [5, 5, 6, 7, 7] como set: " + set_convertido)

      mut as list of data: lista_de_set = sensores as list of data
      println("Set como lista: " + lista_de_set)
}
