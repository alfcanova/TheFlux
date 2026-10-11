#L ============================================================================
#L Algoritmo: D'Esopo-Pape (Caminho Minimo com Fila de Dupla Prioridade)
#L Dominio: 03_graphs / Categoria: Caminhos minimos
#L Complexidade: O(V * E) pior caso, muito rapido na pratica | O(V) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosCaminhosMinimosDEsopoPape) {
      println("==================================================")
      println("  SciAlgo: D'Esopo-Pape Algorithm                 ")
      println("==================================================")

      mut as int64: num_v = 5
      mut as int64: src = 1

      #L Matriz de pesos (5x5). 999999 indica sem aresta
      #L 1->2 (4), 1->3 (2)
      #L 2->3 (1), 2->4 (5)
      #L 3->4 (8), 3->5 (10)
      #L 4->5 (2)
      mut as list of int64: weight = [
            0, 4, 2, 999999, 999999,
            999999, 0, 1, 5, 999999,
            999999, 999999, 0, 8, 10,
            999999, 999999, 999999, 0, 2,
            999999, 999999, 999999, 999999, 0
      ]

      println("1. Grafo com 5 Vertices:")
      println("   Fonte: " + src)

      mut as list of int64: dist = [999999, 999999, 999999, 999999, 999999]
      dist[src] = 0

      #L Estado de cada vertice:
      #L 0: nunca inserido na fila
      #L 1: atualmente na fila
      #L 2: ja foi processado e retirado da fila
      mut as list of int64: state = [0, 0, 0, 0, 0]

      #L Deque implementado em buffer linear
      mut as list of int64: deque = [
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      ]
      mut as int64: head = 15
      mut as int64: tail = 15

      #L Insere fonte na fila
      deque[tail] = src
      tail = tail + 1
      state[src] = 1

      mut as int64: u = 0
      mut as int64: v = 0
      mut as int64: w = 0
      mut as int64: i = 1

      infinite (head < tail) {
            u = deque[head]
            head = head + 1
            state[u] = 2 #L Marcado como ja processado

            v = 1
            infinite (v <= num_v) {
                  w = weight[(u - 1) * num_v + v]
                  route {
                        (w != 999999) and (u != v) ==> {
                              route {
                                    dist[u] + w < dist[v] ==> {
                                          dist[v] = dist[u] + w
                                          mut as int64: s = state[v]

                                          route {
                                                s == 0 ==> {
                                                      #L Nunca esteve na fila: insere no FINAL (tail)
                                                      deque[tail] = v
                                                      tail = tail + 1
                                                      state[v] = 1
                                                }
                                                s == 2 ==> {
                                                      #L Ja foi processado: insere no INICIO (head) para reavaliacao prioritaria
                                                      head = head - 1
                                                      deque[head] = v
                                                      state[v] = 1
                                                }
                                                _ ==> {
                                                      #L Ja esta na fila (s == 1): apenas atualizou distancia
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

      println("2. Distancias Minimas Obtidas via D'Esopo-Pape:")
      i = 1
      infinite (i <= num_v) {
            println("   Vertice " + i + ": distancia = " + dist[i])
            i = i + 1
      }

      println("D'Esopo-Pape concluido com sucesso.")
}
