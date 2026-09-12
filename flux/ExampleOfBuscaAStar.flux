program (ExampleOfBuscaAStar) {
      mut as Tensor[5, 5] of int64: grafo = [
            [0, 2, 4, 0, 0],
            [0, 0, 1, 3, 0],
            [0, 0, 0, 1, 5],
            [0, 0, 0, 0, 2],
            [0, 0, 0, 0, 0]
      ]
      mut as Tensor[5] of int64: heuristica = [6, 4, 3, 1, 0]
      mut as Tensor[5] of int64: custo_g = [0, 9999, 9999, 9999, 9999]
      mut as Tensor[5] of int64: custo_f = [6, 9999, 9999, 9999, 9999]
      mut as Tensor[5] of int64: aberto = [1, 0, 0, 0, 0]
      mut as Tensor[5] of int64: fechado = [0, 0, 0, 0, 0]
      mut as Tensor[5] of int64: anterior = [0, 0, 0, 0, 0]
      mut as Tensor[5] of int64: caminho = [0, 0, 0, 0, 0]
      mut as int64: origem = 1
      mut as int64: destino = 5
      mut as int64: atual = 0
      mut as int64: vertice = 1
      mut as int64: vizinho = 1
      mut as int64: menor_f = 9999
      mut as int64: peso = 0
      mut as int64: tentativa_g = 0
      mut as bool: encontrou = false
      mut as int64: passos = 1
      mut as int64: tamanho_caminho = 0
      mut as int64: cursor = 0

      print("Algoritmo A-Star")
      print("Origem: " + origem)
      print("Destino: " + destino)

      infinite (passos <= 5 and not encontrou) {
            atual = 0
            menor_f = 9999
            vertice = 1

            infinite (vertice <= 5) {
                  route {
                        aberto[vertice] == 1 and custo_f[vertice] < menor_f ==> {
                              menor_f = custo_f[vertice]
                              atual = vertice
                        }
                  }

                  vertice =+ 1
            }

            route {
                  atual == 0 ==> {
                        passos = 6
                  }
                  atual == destino ==> {
                        encontrou = true
                        print("Destino selecionado: " + atual)
                  }
                  _ ==> {
                        aberto[atual] = 0
                        fechado[atual] = 1
                        print("Expande vertice: " + atual)

                        vizinho = 1
                        infinite (vizinho <= 5) {
                              peso = grafo[atual, vizinho]

                              route {
                                    peso > 0 and fechado[vizinho] == 0 ==> {
                                          tentativa_g = custo_g[atual] + peso

                                          route {
                                                aberto[vizinho] == 0 ==> {
                                                      aberto[vizinho] = 1
                                                }
                                          }

                                          route {
                                                tentativa_g < custo_g[vizinho] ==> {
                                                      anterior[vizinho] = atual
                                                      custo_g[vizinho] = tentativa_g
                                                      custo_f[vizinho] = tentativa_g + heuristica[vizinho]
                                                      print("Atualiza vertice: " + vizinho)
                                                      print("Custo g: " + custo_g[vizinho])
                                                      print("Custo f: " + custo_f[vizinho])
                                                }
                                          }
                                    }
                              }

                              vizinho =+ 1
                        }
                  }
            }

            passos =+ 1
      }

      route {
            encontrou ==> {
                  print("Custo final: " + custo_g[destino])

                  cursor = destino
                  tamanho_caminho = 0
                  infinite (cursor > 0) {
                        tamanho_caminho = tamanho_caminho + 1
                        caminho[tamanho_caminho] = cursor
                        cursor = anterior[cursor]
                  }

                  print("Caminho do inicio ao destino")
                  infinite (tamanho_caminho >= 1) {
                        print("Vertice: " + caminho[tamanho_caminho])
                        tamanho_caminho = tamanho_caminho - 1
                  }
            }
            _ ==> {
                  print("Destino nao encontrado")
            }
      }
}
