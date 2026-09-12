program (ExampleOfBuscaSequencial) {
      mut as Tensor[10] of int64: numeros = [45, 12, 89, 34, 67, 23, 78, 90, 11, 56]
      mut as int64: alvo = 23
      mut as int64: tamanho = 10
      mut as int64: indice = 1
      mut as int64: valor_atual = 0
      mut as int64: posicao = 0
      mut as bool: encontrado = false
      mut as int64: passos = 0

      print("Busca sequencial")
      print("Lista com 10 itens")
      print("Alvo: " + alvo)

      infinite (indice <= tamanho and not encontrado) {
            passos =+ 1
            valor_atual = numeros[indice]

            print("Passo: " + passos)
            print("Indice: " + indice)
            print("Valor no indice: " + valor_atual)

            route {
                  valor_atual == alvo ==> {
                        encontrado = true
                        posicao = indice
                  }
                  _ ==> {
                        indice =+ 1
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
