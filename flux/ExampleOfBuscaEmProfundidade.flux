program (ExampleOfBuscaEmProfundidade) {
      mut as Tensor[6, 6] of int64: grafo = [
            [0, 1, 1, 0, 0, 0],
            [0, 0, 0, 1, 1, 0],
            [0, 0, 0, 0, 0, 1],
            [0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 0]
      ]
      mut as Tensor[6] of int64: pilha = [0, 0, 0, 0, 0, 0]
      mut as Tensor[6] of int64: visitado = [0, 0, 0, 0, 0, 0]
      mut as int64: inicio = 1
      mut as int64: topo = 1
      mut as int64: atual = 0
      mut as int64: vizinho = 6
      mut as int64: aresta = 0
      mut as int64: ja_visitado = 0

      print("Busca em Profundidade - DFS")
      print("Grafo dirigido com 6 vertices")
      print("Inicio: " + inicio)

      pilha[topo] = inicio
      topo =+ 1
      visitado[inicio] = 1

      infinite (topo > 1) {
            topo = topo - 1
            atual = pilha[topo]

            print("Visitado: " + atual)

            vizinho = 6
            infinite (vizinho >= 1) {
                  aresta = grafo[atual, vizinho]
                  ja_visitado = visitado[vizinho]

                  route {
                        aresta == 1 and ja_visitado == 0 ==> {
                              visitado[vizinho] = 1
                              pilha[topo] = vizinho
                              topo =+ 1
                              print("Empilha: " + vizinho)
                        }
                  }

                  vizinho = vizinho - 1
            }
      }
}
