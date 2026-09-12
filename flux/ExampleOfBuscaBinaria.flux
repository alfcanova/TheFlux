program (ExampleOfBuscaBinaria) {
      mut as Tensor[9] of int64: numeros = [3, 7, 12, 18, 25, 31, 37, 42, 56]
      mut as int64: alvo = 37
      mut as int64: inicio = 1
      mut as int64: fim = 9
      mut as int64: meio = 0
      mut as int64: valor_meio = 0
      mut as int64: posicao = 0
      mut as bool: encontrado = false
      mut as int64: passos = 0

      print("Busca binaria")
      print("Lista ordenada com 9 itens")
      print("Alvo: " + alvo)

      infinite (inicio <= fim and not encontrado) {
            passos =+ 1
            meio = (inicio + fim) /i 2
            valor_meio = numeros[meio]

            print("Passo: " + passos)
            print("Inicio: " + inicio)
            print("Fim: " + fim)
            print("Meio: " + meio)
            print("Valor no meio: " + valor_meio)

            route {
                  valor_meio == alvo ==> {
                        encontrado = true
                        posicao = meio
                  }
                  valor_meio < alvo ==> {
                        inicio = meio + 1
                  }
                  _ ==> {
                        fim = meio - 1
                  }
            }
      }

      route {
            encontrado ==> {
                  print("Alvo encontrado na posicao: " + posicao)
            }
            _ ==> {
                  print("Alvo nao encontrado")
            }
      }
}
