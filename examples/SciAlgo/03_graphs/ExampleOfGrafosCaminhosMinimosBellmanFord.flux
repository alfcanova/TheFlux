#L ============================================================================
#L Algoritmo: Bellman-Ford (Caminhos Minimos com Arestas Negativas)
#L Dominio: 03_graphs / Categoria: Caminhos minimos
#L Complexidade: O(V * E) tempo | O(V) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosCaminhosMinimosBellmanFord) {
      println("==================================================")
      println("  SciAlgo: Bellman-Ford Shortest Path             ")
      println("==================================================")

      mut as int64: num_v = 5
      mut as int64: num_e = 8
      mut as int64: src = 1

      #L Grafo com 5 vertices e arestas com pesos positivos e negativos:
      #L (1->2: -1), (1->3: 4), (2->3: 3), (2->4: 2), (2->5: 2)
      #L (4->2: 1), (4->3: 5), (5->4: -3)
      mut as list of int64: edge_from = [1, 1, 2, 2, 2, 4, 4, 5]
      mut as list of int64: edge_to =   [2, 3, 3, 4, 5, 2, 3, 4]
      mut as list of int64: edge_wt =   [-1, 4, 3, 2, 2, 1, 5, -3]

      println("1. Grafo Direcionado com Pesos Negativos (5 vertices, 8 arestas):")
      println("   Fonte: " + src)

      mut as list of int64: dist = [999999, 999999, 999999, 999999, 999999]
      dist[src] = 0

      #L Relaxa todas as arestas |V| - 1 vezes
      mut as int64: iter = 1
      mut as int64: e = 1
      mut as int64: u = 0
      mut as int64: v = 0
      mut as int64: w = 0
      mut as int64: i = 1

      infinite (iter < num_v) {
            e = 1
            infinite (e <= num_e) {
                  u = edge_from[e]
                  v = edge_to[e]
                  w = edge_wt[e]

                  route {
                        dist[u] < 999999 ==> {
                              route {
                                    dist[u] + w < dist[v] ==> {
                                          dist[v] = dist[u] + w
                                    }
                                    _ ==> {}
                              }
                        }
                        _ ==> {}
                  }
                  e = e + 1
            }
            iter = iter + 1
      }

      #L Passo |V|: Verificacao de ciclos negativos
      mut as bool: has_neg_cycle = false
      e = 1
      infinite (e <= num_e) {
            u = edge_from[e]
            v = edge_to[e]
            w = edge_wt[e]

            route {
                  dist[u] < 999999 ==> {
                        route {
                              dist[u] + w < dist[v] ==> {
                                    has_neg_cycle = true
                              }
                              _ ==> {}
                        }
                  }
                  _ ==> {}
            }
            e = e + 1
      }

      route {
            has_neg_cycle ==> {
                  println("2. Alerta: Ciclo negativo detectado!")
            }
            _ ==> {
                  println("2. Nenhum ciclo negativo detectado.")
                  println("3. Distancias Minimas a partir de " + src + ":")
                  i = 1
                  infinite (i <= num_v) {
                        println("   Vertice " + i + ": distancia = " + dist[i])
                        i = i + 1
                  }
            }
      }

      println("Bellman-Ford concluido com sucesso.")
}
