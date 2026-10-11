#L ============================================================================
#L Algoritmo: Bidirectional A* (Busca A* Bidirecional)
#L Dominio: 01_foundations / Busca
#L Complexidade: O(b^(d/2)) tempo | O(b^(d/2)) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosBuscaBidirectionalAStar) {
      println("==================================================")
      println("  SciAlgo: Bidirectional A* Search                ")
      println("==================================================")

      #L Grafo com 5 vertices
      #L 1->2 (2), 1->3 (4), 2->4 (3), 3->4 (1), 4->5 (2)
      mut as list of list of int64: cost = [
            [0, 2, 4, 0, 0],
            [0, 0, 0, 3, 0],
            [0, 0, 0, 1, 0],
            [0, 0, 0, 0, 2],
            [0, 0, 0, 0, 0]
      ]

      mut as int64: start = 1
      mut as int64: goal = 5

      #L Custos acumulados para frente g_f e para tras g_b
      mut as list of int64: g_f = [0, 0, 9999, 9999, 9999, 9999]
      mut as list of int64: g_b = [0, 9999, 9999, 9999, 9999, 0]

      mut as list of int64: visited_f = [0, 0, 0, 0, 0, 0]
      mut as list of int64: visited_b = [0, 0, 0, 0, 0, 0]

      mut as int64: best_cost = 9999
      mut as int64: meeting_node = 0
      mut as int64: step = 1

      println("1. Origem: " + start + " | Destino: " + goal)

      infinite (step <= 5) {
            #L Expansao para frente
            mut as int64: u_f = 0
            mut as int64: min_f = 9999
            mut as int64: i = 1
            infinite (i <= 5) {
                  route {
                        visited_f[i] == 0 and g_f[i] < min_f ==> {
                              min_f = g_f[i]
                              u_f = i
                        }
                  }
                  i = i + 1
            }

            route {
                  u_f > 0 ==> {
                        visited_f[u_f] = 1
                        mut as int64: v = 1
                        infinite (v <= 5) {
                              mut as int64: w = cost[u_f][v]
                              route {
                                    w > 0 ==> {
                                          route {
                                                g_f[u_f] + w < g_f[v] ==> {
                                                      g_f[v] = g_f[u_f] + w
                                                }
                                          }
                                    }
                              }
                              v = v + 1
                        }
                  }
            }

            #L Expansao para tras
            mut as int64: u_b = 0
            mut as int64: min_b = 9999
            i = 1
            infinite (i <= 5) {
                  route {
                        visited_b[i] == 0 and g_b[i] < min_b ==> {
                              min_b = g_b[i]
                              u_b = i
                        }
                  }
                  i = i + 1
            }

            route {
                  u_b > 0 ==> {
                        visited_b[u_b] = 1
                        #L Predecessores de u_b
                        mut as int64: p = 1
                        infinite (p <= 5) {
                              mut as int64: w = cost[p][u_b]
                              route {
                                    w > 0 ==> {
                                          route {
                                                g_b[u_b] + w < g_b[p] ==> {
                                                      g_b[p] = g_b[u_b] + w
                                                }
                                          }
                                    }
                              }
                              p = p + 1
                        }
                  }
            }

            #L Verifica encontro
            i = 1
            infinite (i <= 5) {
                  route {
                        visited_f[i] == 1 and visited_b[i] == 1 ==> {
                              mut as int64: total_c = g_f[i] + g_b[i]
                              route {
                                    total_c < best_cost ==> {
                                          best_cost = total_c
                                          meeting_node = i
                                    }
                              }
                        }
                  }
                  i = i + 1
            }

            step = step + 1
      }

      println("2. Vertice de Encontro das Fronteiras: " + meeting_node)
      println("3. Custo Otimo Encontrado: " + best_cost)
      mut as bool: ok = (best_cost == 7)
      println("4. Validacao (Custo minimo == 7): " + ok)
      println("==================================================")
}
