program (ExampleOfBuscaDijkstra) {
      mut as Tensor[5, 5] of int64: grafo = [
            [0, 2, 5, 0, 0],
            [0, 0, 1, 2, 0],
            [0, 0, 0, 3, 8],
            [0, 0, 0, 0, 1],
            [0, 0, 0, 0, 0]
      ]
      mut as Tensor[5] of int64: distancia = [0, 9999, 9999, 9999, 9999]
      mut as Tensor[5] of int64: visitado = [0, 0, 0, 0, 0]
      mut as int64: passo = 1
      mut as int64: vertice = 1
      mut as int64: vizinho = 1
      mut as int64: atual = 0
      mut as int64: menor = 9999
      mut as int64: peso = 0
      mut as int64: nova_distancia = 0

      print("Algoritmo de Dijkstra")
      print("Origem: 1")

      infinite (passo <= 5) {
            atual = 0
            menor = 9999
            vertice = 1

            infinite (vertice <= 5) {
                  route {
                        visitado[vertice] == 0 and distancia[vertice] < menor ==> {
                              menor = distancia[vertice]
                              atual = vertice
                        }
                  }

                  vertice =+ 1
            }

            route {
                  atual == 0 ==> {
                        passo = 6
                  }
                  _ ==> {
                        visitado[atual] = 1
                        print("Fecha vertice: " + atual)

                        vizinho = 1
                        infinite (vizinho <= 5) {
                              peso = grafo[atual, vizinho]

                              route {
                                    peso > 0 and visitado[vizinho] == 0 ==> {
                                          nova_distancia = distancia[atual] + peso

                                          route {
                                                nova_distancia < distancia[vizinho] ==> {
                                                      distancia[vizinho] = nova_distancia
                                                      print("Atualiza vertice: " + vizinho)
                                                      print("Distancia: " + nova_distancia)
                                                }
                                          }
                                    }
                              }

                              vizinho =+ 1
                        }
                  }
            }

            passo =+ 1
      }

      print("Distancias finais")
      vertice = 1
      infinite (vertice <= 5) {
            print("Vertice: " + vertice)
            print("Distancia: " + distancia[vertice])
            vertice =+ 1
      }
}
