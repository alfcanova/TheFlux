program (ExampleOfBuscaEmLargura) {
      mut as Tensor[6, 6] of int64: grafo = [
            [0, 1, 1, 0, 0, 0],
            [0, 0, 0, 1, 1, 0],
            [0, 0, 0, 0, 0, 1],
            [0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0]
      ]
      mut as Tensor[6] of int64: fila = [0, 0, 0, 0, 0, 0]
      mut as Tensor[6] of int64: visitado = [0, 0, 0, 0, 0, 0]
      mut as int64: inicio = 1
      mut as int64: frente = 1
      mut as int64: fim = 1
      mut as int64: atual = 0
      mut as int64: vizinho = 1
      mut as int64: aresta = 0
      mut as int64: ja_visitado = 0

      print("Busca em Largura - BFS")
      print("Grafo dirigido com 6 vertices")
      print("Inicio: " + inicio)

      fila[fim] = inicio
      fim =+ 1
      visitado[inicio] = 1

      infinite (frente < fim) {
            atual = fila[frente]
            frente =+ 1

            print("Visitado: " + atual)

            vizinho = 1
            infinite (vizinho <= 6) {
                  aresta = grafo[atual, vizinho]
                  ja_visitado = visitado[vizinho]

                  route {
                        aresta == 1 and ja_visitado == 0 ==> {
                              visitado[vizinho] = 1
                              fila[fim] = vizinho
                              fim =+ 1
                              print("Enfileira: " + vizinho)
                        }
                  }

                  vizinho =+ 1
            }
      }
}
