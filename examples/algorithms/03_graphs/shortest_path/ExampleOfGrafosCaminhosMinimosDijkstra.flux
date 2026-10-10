#L ============================================================================
#L Algoritmo: Dijkstra (Caminho Mais Curto de Fonte Unica)
#L Dominio: 03_graphs / Categoria: Caminhos minimos
#L Complexidade: O(V^2) tempo | O(V) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosCaminhosMinimosDijkstra) {
      println("==================================================")
      println("  SciAlgo: Dijkstra (Single-Source Shortest Path) ")
      println("==================================================")

      mut as int64: num_v = 5
      mut as int64: src = 1

      #L Matriz de adjacencia com pesos (5x5). 0 indica ausencia de aresta
      #L 1->2 (4), 1->3 (2)
      #L 2->3 (1), 2->4 (5)
      #L 3->4 (8), 3->5 (10)
      #L 4->5 (2)
      mut as list of int64: weight = [
            0, 4, 2, 0, 0,
            0, 0, 1, 5, 0,
            0, 0, 0, 8, 10,
            0, 0, 0, 0, 2,
            0, 0, 0, 0, 0
      ]

      println("1. Grafo Direcionado Ponderado com 5 Vertices:")
      println("   Fonte: " + src)
      println("   Arestas: (1->2: 4), (1->3: 2), (2->3: 1), (2->4: 5), (3->4: 8), (3->5: 10), (4->5: 2)")

      mut as list of int64: dist = [999999, 999999, 999999, 999999, 999999]
      mut as list of bool: visited = [false, false, false, false, false]
      mut as list of int64: parent = [0, 0, 0, 0, 0]

      dist[src] = 0

      mut as int64: step = 1
      mut as int64: u = 0
      mut as int64: min_d = 999999
      mut as int64: i = 1
      mut as int64: v = 1

      infinite (step <= num_v) {
            #L Encontra vertice nao visitado com menor distancia estimada
            u = 0
            min_d = 999999
            i = 1
            infinite (i <= num_v) {
                  route {
                        (not visited[i]) and (dist[i] < min_d) ==> {
                              min_d = dist[i]
                              u = i
                        }
                        _ ==> {}
                  }
                  i = i + 1
            }

            route {
                  (u == 0) or (min_d >= 999999) ==> {
                        step = num_v + 1
                  }
                  _ ==> {
                        visited[u] = true

                        #L Relaxa arestas saindo de u
                        v = 1
                        infinite (v <= num_v) {
                              mut as int64: w = weight[(u - 1) * num_v + v]
                              route {
                                    w > 0 ==> {
                                          route {
                                                dist[u] + w < dist[v] ==> {
                                                      dist[v] = dist[u] + w
                                                      parent[v] = u
                                                }
                                                _ ==> {}
                                          }
                                    }
                                    _ ==> {}
                              }
                              v = v + 1
                        }

                        step = step + 1
                  }
            }
      }

      println("2. Distancias Minimas a partir do Vertice " + src + ":")
      i = 1
      infinite (i <= num_v) {
            println("   Vertice " + i + ": distancia = " + dist[i])
            i = i + 1
      }

      println("Dijkstra concluido com sucesso.")
}
