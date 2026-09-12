mut as int64: contador = 1
mut as bool: continuar = true
mut as list of int64: valores = [10, 20, 30]

mut as int64: soma_i = 1
mut as int64: soma_total = 0

mut as int64: skip_i = 1
mut as int64: skip_count = 0

mut as list of int64: lista = [10, 20, 30]
mut as int64: lista_indice = 1

mut as set of string: conjunto = {"cpu", "gpu", "tpu"}
mut as int64: conjunto_passo = 1

mut as map: metricas = map{.threads of string: 8, .batch of string: 32}
mut as int64: mapa_passo = 1

mut as data: payload = ["novo", 2]
mut as int64: data_passo = 1

mut as string: texto = "flux"
mut as list of string: letras = ["f", "l", "u", "x"]
mut as int64: letra_indice = 1

program (ExampleOfInfiniteWhile) {
      print("=== InfiniteWhile: contador simples ===")
      infinite (contador <= 3) {
            print("Contador: " + contador)
            contador =+ 1
      }

      print("=== InfiniteWhile: flag + route ===")
      infinite (continuar) {
            print("Flag ativa, contador: " + contador)

            route {
                  contador == 4 ==> {
                        valores[2] = 99
                  }
            }

            contador =+ 1

            route {
                  contador > 5 ==> {
                        continuar = false
                  }
            }
      }
      print("Lista apos route: " + valores)

      print("=== InfiniteWhile: break ===")
      infinite (soma_i <= 10) {
            print("Iteracao: #{soma_i}")
            soma_total = soma_total + soma_i
            infinite (soma_i >= 5) {
                  print("Break interno acionado")
                  break
            }
            soma_i =+ 1
      }
      print("Soma total: " + soma_total)

      print("=== InfiniteWhile: continue ===")
      infinite (skip_i <= 5) {
            infinite (skip_i == 3) {
                  skip_i =+ 1
                  print("Continue pulou o 3")
                  continue
            }
            skip_count =+ 1
            skip_i =+ 1
      }
      print("Total de incrementos: " + skip_count)

      print("=== InfiniteWhile: iteraveis ===")

      print("-- list --")
      infinite (lista_indice <= 3) {
            print(lista[lista_indice])
            lista_indice =+ 1
      }

      print("-- set --")
      infinite (conjunto_passo <= 2) {
            print(conjunto)
            conjunto = {"cpu", "gpu", "tpu", "npu"}
            conjunto_passo =+ 1
      }

      print("-- map --")
      infinite (mapa_passo <= 2) {
            route {
                  mapa_passo == 1 ==> {
                        print(metricas["threads"])
                  }
            }
            route {
                  mapa_passo == 2 ==> {
                        print(metricas["batch"])
                  }
            }
            mapa_passo =+ 1
      }

      print("-- data --")
      infinite (data_passo <= 2) {
            route {
                  data_passo == 1 ==> {
                        print(payload[1])
                  }
            }
            route {
                  data_passo == 2 ==> {
                        print(payload[2])
                  }
            }
            data_passo =+ 1
      }

      print("-- string --")
      print(texto)
      infinite (letra_indice <= 4) {
            print(letras[letra_indice])
            letra_indice =+ 1
      }

      print("InfiniteWhile executado com sucesso!")
}
