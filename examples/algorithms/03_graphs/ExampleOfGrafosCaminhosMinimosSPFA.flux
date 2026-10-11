#L ============================================================================
#L Algoritmo: SPFA (Shortest Path Faster Algorithm)
#L Dominio: 03_graphs / Categoria: Caminhos minimos
#L Complexidade: O(E) caso medio, O(V * E) pior caso | O(V) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosCaminhosMinimosSPFA) {
      println("==================================================")
      println("  SciAlgo: SPFA (Queue-based Shortest Path)       ")
      println("==================================================")

      mut as int64: num_v = 5
      mut as int64: src = 1

      #L Matriz de pesos (5x5). 999999 indica ausencia de aresta
      #L 1->2 (-1), 1->3 (4)
      #L 2->3 (3), 2->4 (2), 2->5 (2)
      #L 4->2 (1), 4->3 (5)
      #L 5->4 (-3)
      mut as list of int64: weight = [
            0, -1, 4, 999999, 999999,
            999999, 0, 3, 2, 2,
            999999, 999999, 0, 999999, 999999,
            999999, 1, 5, 0, 999999,
            999999, 999999, 999999, -3, 0
      ]

      println("1. Grafo Direcionado com Pesos:")
      println("   Fonte: " + src)

      mut as list of int64: dist = [999999, 999999, 999999, 999999, 999999]
      mut as list of bool: in_queue = [false, false, false, false, false]
      mut as list of int64: count = [0, 0, 0, 0, 0]

      #L Fila circular para SPFA
      mut as list of int64: queue = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      mut as int64: q_head = 1
      mut as int64: q_tail = 1

      dist[src] = 0
      queue[q_tail] = src
      q_tail = q_tail + 1
      in_queue[src] = true

      mut as bool: has_neg_cycle = false
      mut as int64: u = 0
      mut as int64: v = 0
      mut as int64: w = 0
      mut as int64: i = 1

      infinite (q_head < q_tail and not has_neg_cycle) {
            u = queue[q_head]
            q_head = q_head + 1
            in_queue[u] = false

            v = 1
            infinite (v <= num_v and not has_neg_cycle) {
                  w = weight[(u - 1) * num_v + v]
                  route {
                        (w != 999999) and (u != v) ==> {
                              route {
                                    dist[u] + w < dist[v] ==> {
                                          dist[v] = dist[u] + w
                                          count[v] = count[v] + 1

                                          route {
                                                count[v] >= num_v ==> {
                                                      has_neg_cycle = true
                                                }
                                                _ ==> {
                                                      route {
                                                            not in_queue[v] ==> {
                                                                  queue[q_tail] = v
                                                                  q_tail = q_tail + 1
                                                                  in_queue[v] = true
                                                            }
                                                            _ ==> {}
                                                      }
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

      route {
            has_neg_cycle ==> {
                  println("2. Ciclo negativo detectado pelo SPFA!")
            }
            _ ==> {
                  println("2. Distancias Minimas Finais (SPFA):")
                  i = 1
                  infinite (i <= num_v) {
                        println("   Vertice " + i + ": distancia = " + dist[i])
                        i = i + 1
                  }
            }
      }

      println("SPFA concluido com sucesso.")
}
