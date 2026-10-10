#L ============================================================================
#L Algoritmo: Shortest Path Faster Algorithm (SPFA com Otimizacao SLF)
#L Dominio: 03_graphs / Categoria: Caminhos minimos
#L Complexidade: O(E) medio, O(V * E) pior caso | O(V) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosCaminhosMinimosShortestPathFasterAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Shortest Path Faster Algorithm (SLF)   ")
      println("==================================================")

      mut as int64: num_v = 5
      mut as int64: src = 1

      #L Matriz de pesos com arestas negativas (sem ciclo negativo)
      #L 1->2 (6), 1->3 (7)
      #L 2->4 (5), 2->5 (-4)
      #L 3->4 (-3), 3->5 (9)
      #L 4->2 (-2)
      #L 5->4 (7)
      mut as list of int64: weight = [
            0,      6,      7, 999999, 999999,
            999999, 0, 999999,      5,     -4,
            999999, 999999, 0,     -3,      9,
            999999, -2, 999999,     0, 999999,
            999999, 999999, 999999, 7,      0
      ]

      println("1. Grafo com Arestas Negativas (5 Vertices). Fonte: " + src)

      mut as list of int64: dist = [999999, 999999, 999999, 999999, 999999]
      mut as list of bool: in_queue = [false, false, false, false, false]
      mut as list of int64: relax_count = [0, 0, 0, 0, 0]

      #L Deque para SPFA com heuristica SLF (Small Label to the Front)
      mut as list of int64: deque = [
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      ]
      mut as int64: head = 20
      mut as int64: tail = 20

      dist[src] = 0
      deque[tail] = src
      tail = tail + 1
      in_queue[src] = true

      mut as bool: has_neg_cycle = false
      mut as int64: u = 0
      mut as int64: v = 0
      mut as int64: w = 0
      mut as int64: i = 1

      infinite (head < tail and not has_neg_cycle) {
            u = deque[head]
            head = head + 1
            in_queue[u] = false

            v = 1
            infinite (v <= num_v and not has_neg_cycle) {
                  w = weight[(u - 1) * num_v + v]
                  route {
                        (w != 999999) and (u != v) ==> {
                              route {
                                    dist[u] + w < dist[v] ==> {
                                          dist[v] = dist[u] + w
                                          relax_count[v] = relax_count[v] + 1

                                          route {
                                                relax_count[v] >= num_v ==> {
                                                      has_neg_cycle = true
                                                }
                                                _ ==> {
                                                      route {
                                                            not in_queue[v] ==> {
                                                                  #L Otimizacao SLF protegida contra avaliacao de indice 0
                                                                  mut as bool: to_front = false
                                                                  route {
                                                                        head < tail ==> {
                                                                              mut as int64: front_node = deque[head]
                                                                              route {
                                                                                    front_node > 0 ==> {
                                                                                          route {
                                                                                                dist[v] < dist[front_node] ==> {
                                                                                                      to_front = true
                                                                                                }
                                                                                                _ ==> {}
                                                                                          }
                                                                                    }
                                                                                    _ ==> {}
                                                                              }
                                                                        }
                                                                        _ ==> {}
                                                                  }

                                                                  route {
                                                                        to_front ==> {
                                                                              head = head - 1
                                                                              deque[head] = v
                                                                        }
                                                                        _ ==> {
                                                                              deque[tail] = v
                                                                              tail = tail + 1
                                                                        }
                                                                  }
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
                  println("2. Ciclo negativo detectado!")
            }
            _ ==> {
                  println("2. Distancias Minimas Finais com SPFA-SLF:")
                  i = 1
                  infinite (i <= num_v) {
                        println("   Vertice " + i + ": distancia = " + dist[i])
                        i = i + 1
                  }
            }
      }

      println("Shortest Path Faster Algorithm concluido com sucesso.")
}
