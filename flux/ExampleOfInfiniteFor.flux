mut as int64: total = 0
mut as int64: ext = 1
mut as int64: k = 1

mut as list of int64: numeros = [10, 20, 30]
mut as set of string: unicos = {"cpu", "gpu", "tpu"}
mut as map: metricas = map{.threads of string: 8, .batch of string: 32}
mut as data: payload = ["ok", 42]
mut as string: texto = "flux"
mut as list of string: letras = ["f", "l", "u", "x"]

program (ExampleOfInfiniteFor) {
      print("=== InfiniteFor: range crescente ===")
      infinite (i in 1 .. 4) {
            total =+ i
            print("For iteracao: " + i)
            print("For total: " + total)
      }

      print("=== InfiniteFor: range negativo ===")
      infinite (j in -4 .. 2) {
            print(j)
      }

      print("=== InfiniteFor: range descendente ===")
      infinite (d in 3 .. 1) {
            print(d)
      }

      print("=== InfiniteFor: break aninhado ===")
      infinite (ext <= 5) {
            infinite (ext <= 5) {
                  print("Interno #{ext}")
                  break
            }
            print("Externo: #{ext}")
            ext =+ 1
      }

      print("=== InfiniteFor: pares com /r ===")
      infinite (k <= 10) {
            infinite ((k /r 2) == 0) {
                  print("Numero par: " + k)
                  break
            }
            k =+ 1
      }

      print("=== InfiniteFor: iteraveis ===")

      print("-- list --")
      infinite (numero in numeros) {
            print(numero)
      }

      print("-- set --")
      infinite (item in unicos) {
            print(item)
      }

      print("-- map --")
      infinite (chave in metricas) {
            print(chave + " = " + metricas[chave])
      }

      print("-- data --")
      infinite (idx in 1 .. 2) {
            print(payload[idx])
      }

      print("-- string --")
      print(texto)
      infinite (letra in letras) {
            print(letra)
      }

      print("InfiniteFor executado com sucesso!")
}
