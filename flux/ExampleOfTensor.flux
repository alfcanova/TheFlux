program (ExampleOfTensor) {
      print("=== Tensor: literal e multi-index ===")
      mut as tensor[2, 2] of int64: t = [[10, 20], [30, 40]]
      print(t[1, 1])
      print(t[2, 1])
      print(t[2, 2])
      print(t)

      print("=== Tensor: index-assign ===")
      t[2, 1] = 99
      print(t)
      print(t[2, 1])

      print("=== Tensor: default zeros ===")
      mut as tensor[2, 3] of float64: z
      print(z)
      z[1, 3] = 7.5
      print(z)

      print("=== Tensor: cubo 3D ===")
      mut as tensor[2, 2, 2] of int64: c = [[[1, 2], [3, 4]], [[5, 6], [7, 8]]]
      print(c[1, 1, 1])
      print(c[2, 2, 2])
      c[2, 1, 2] = 60
      print(c[2, 1, 2])
      print(c)

      print("=== Tensor: vetor ===")
      mut as tensor[3] of float32: v = [1.5, 2.5, 3.5]
      print(v[3])
      print(v)

      print("=== Tensor: concat string ===")
      print("valor: " + t[2, 1])

      print("=== Tensor: indice variavel ===")
      mut as int64: i = 2
      print(t[i, i])

      print("=== Tensor: telemetria spy ===")
      print("--- Tensor 1D (Vetor) ---")
      mut as tensor[3] of int64: t1 = [1, 2, 3]
      spy(t1)

      print("--- Tensor 2D (Matriz) ---")
      mut as tensor[3, 3] of int64: t2 = [
            [10, 20, 30],
            [40, 50, 60],
            [70, 80, 90]
      ]
      spy(t2)

      print("--- Tensor 3D (Cubo) ---")
      mut as tensor[3, 3, 3] of int64: t3 = [
            [
            [10, 20, 30],
            [40, 50, 60],
            [70, 80, 90]
            ],
            [
            [11, 21, 31],
            [41, 51, 61],
            [71, 81, 91]
            ],
            [
            [12, 22, 32],
            [42, 52, 62],
            [72, 82, 92]
            ]
      ]
      spy(t3)

      print("=== Tensor: tabela hash (enderecamento aberto) ===")
      mut as Tensor[5] of int64: chaves_entrada = [10, 17, 24, 3, 31]
      mut as Tensor[5] of int64: valores_entrada = [100, 170, 240, 30, 310]
      mut as Tensor[7] of int64: tabela_chaves = [0, 0, 0, 0, 0, 0, 0]
      mut as Tensor[7] of int64: tabela_valores = [0, 0, 0, 0, 0, 0, 0]
      mut as int64: tamanho = 7
      mut as int64: indice = 1
      mut as int64: chave = 0
      mut as int64: valor = 0
      mut as int64: resto = 0
      mut as int64: posicao = 0
      mut as int64: sondagens = 0
      mut as int64: chave_slot = 0
      mut as bool: encontrado = false
      mut as int64: consulta = 0
      mut as int64: resultado = 0

      print("Tabela Hash - Hashing")
      print("Endereco aberto com sondagem linear")

      indice = 1
      infinite (indice <= 5) {
            chave = chaves_entrada[indice]
            valor = valores_entrada[indice]
            resto = chave - (chave /i tamanho) * tamanho
            posicao = resto + 1
            sondagens = 1

            infinite (sondagens <= tamanho) {
                  chave_slot = tabela_chaves[posicao]

                  route { chave_slot == 0 or chave_slot == chave ==> {
                        tabela_chaves[posicao] = chave
                        tabela_valores[posicao] = valor
                        sondagens = tamanho + 1
                        print("Insere chave: " + chave)
                        print("Posicao: " + posicao)
                  } _ ==> {
                        posicao = posicao + 1
                        route { posicao > tamanho ==> {
                              posicao = 1
                        } }
                        sondagens = sondagens + 1
                  } }
            }

            indice = indice + 1
      }

      consulta = 24
      resto = consulta - (consulta /i tamanho) * tamanho
      posicao = resto + 1
      sondagens = 1
      encontrado = false
      resultado = 0

      infinite (sondagens <= tamanho and not encontrado) {
            chave_slot = tabela_chaves[posicao]

            route { chave_slot == consulta ==> {
                  encontrado = true
                  resultado = tabela_valores[posicao]
            } chave_slot == 0 ==> {
                  sondagens = tamanho + 1
            } _ ==> {
                  posicao = posicao + 1
                  route { posicao > tamanho ==> {
                        posicao = 1
                  } }
                  sondagens = sondagens + 1
            } }
      }

      route { encontrado ==> {
            print("Consulta 24 encontrada")
            print("Valor: " + resultado)
            print("Posicao: " + posicao)
      } _ ==> {
            print("Consulta 24 nao encontrada")
      } }

      consulta = 99
      resto = consulta - (consulta /i tamanho) * tamanho
      posicao = resto + 1
      sondagens = 1
      encontrado = false
      resultado = 0

      infinite (sondagens <= tamanho and not encontrado) {
            chave_slot = tabela_chaves[posicao]

            route { chave_slot == consulta ==> {
                  encontrado = true
                  resultado = tabela_valores[posicao]
            } chave_slot == 0 ==> {
                  sondagens = tamanho + 1
            } _ ==> {
                  posicao = posicao + 1
                  route { posicao > tamanho ==> {
                        posicao = 1
                  } }
                  sondagens = sondagens + 1
            } }
      }

      route { encontrado ==> {
            print("Consulta 99 encontrada")
            print("Valor: " + resultado)
            print("Posicao: " + posicao)
      } _ ==> {
            print("Consulta 99 nao encontrada")
      } }
}
