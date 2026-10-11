#L ============================================================================
#L Algoritmo: 0-1 BFS (Busca em Largura para Arestas de Peso 0 ou 1)
#L Dominio: 03_graphs / Categoria: Caminhos minimos
#L Complexidade: O(V + E) tempo | O(V) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosCaminhosMinimosZeroOneBFS) {
      println("==================================================")
      println("  SciAlgo: 0-1 BFS (Deque Shortest Path)          ")
      println("==================================================")

      mut as int64: num_v = 5
      mut as int64: src = 1

      #L Matriz de adjacencia com pesos 0 e 1 (-1 indica sem aresta)
      #L 1->2 (1), 1->3 (0)
      #L 2->4 (1), 2->5 (1)
      #L 3->2 (0), 3->4 (1)
      #L 4->5 (0)
      mut as list of int64: weight = [
            -1,  1,  0, -1, -1,
            -1, -1, -1,  1,  1,
            -1,  0, -1,  1, -1,
            -1, -1, -1, -1,  0,
            -1, -1, -1, -1, -1
      ]

      println("1. Grafo com Arestas de Peso 0 e 1:")
      println("   Fonte: " + src)
      println("   Arestas: (1->2: 1), (1->3: 0), (3->2: 0), (2->4: 1), (3->4: 1), (4->5: 0), (2->5: 1)")

      mut as list of int64: dist = [999999, 999999, 999999, 999999, 999999]
      dist[src] = 0

      #L Deque implementado em buffer linear com ponteiros de head e tail
      mut as list of int64: deque = [
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      ]
      mut as int64: d_head = 15
      mut as int64: d_tail = 15

      #L Insere elemento inicial no deque
      deque[d_tail] = src
      d_tail = d_tail + 1

      mut as int64: u = 0
      mut as int64: v = 0
      mut as int64: w = 0
      mut as int64: i = 1

      infinite (d_head < d_tail) {
            u = deque[d_head]
            d_head = d_head + 1

            v = 1
            infinite (v <= num_v) {
                  w = weight[(u - 1) * num_v + v]
                  route {
                        w >= 0 ==> {
                              route {
                                    dist[u] + w < dist[v] ==> {
                                          dist[v] = dist[u] + w
                                          route {
                                                w == 0 ==> {
                                                      #L Aresta de peso 0: insere na frente (push front)
                                                      d_head = d_head - 1
                                                      deque[d_head] = v
                                                }
                                                _ ==> {
                                                      #L Aresta de peso 1: insere no final (push back)
                                                      deque[d_tail] = v
                                                      d_tail = d_tail + 1
                                                }
                                          }
                                    }
                                    _ ==> {}
                              }
                        }
                        _ ==> {}
                  }
                  v = v + 1
            }
      }

      println("2. Distancias Minimas Obtidas via 0-1 BFS:")
      i = 1
      infinite (i <= num_v) {
            println("   Vertice " + i + ": distancia = " + dist[i])
            i = i + 1
      }

      println("0-1 BFS concluido com sucesso.")
}
