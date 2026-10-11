#L ============================================================================
#L Algoritmo: D* (Dynamic A* / Replanejamento Dinamico em Tempo Real)
#L Dominio: 03_graphs / Categoria: Caminhos minimos
#L Complexidade: O(V log V) por replanejamento | O(V) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosCaminhosMinimosDStar) {
      println("==================================================")
      println("  SciAlgo: D* (Dynamic A* Replanning)             ")
      println("==================================================")

      mut as int64: num_v = 5
      mut as int64: start_node = 1
      mut as int64: goal_node = 5

      #L Matriz de pesos original (5x5). -1 indica sem aresta
      #L 1->2 (2), 1->3 (5)
      #L 2->4 (1), 2->3 (2)
      #L 3->5 (6)
      #L 4->5 (3)
      mut as list of int64: cost = [
            -1,  2,  5, -1, -1,
            -1, -1,  2,  1, -1,
            -1, -1, -1, -1,  6,
            -1, -1, -1, -1,  3,
            -1, -1, -1, -1, -1
      ]

      println("1. Grafo com 5 Vertices (Inicio: 1, Objetivo: 5)")
      println("   Caminho inicial esperado: 1 -> 2 -> 4 -> 5 (custo 2 + 1 + 3 = 6)")

      #L D* calcula custos do objetivo (goal) para os nos (backward search)
      #L h_cost[X]: estimativa atual de custo ate o objetivo
      mut as list of int64: h_cost = [999999, 999999, 999999, 999999, 0]
      mut as list of int64: next_hop = [0, 0, 0, 0, 5]
      mut as list of bool: open_list = [false, false, false, false, true]

      #L Planejamento inicial backward
      mut as bool: planning = true
      mut as int64: u = 0
      mut as int64: min_h = 0
      mut as int64: i = 1
      mut as int64: p = 1

      infinite (planning) {
            u = 0
            min_h = 999999
            i = 1
            infinite (i <= num_v) {
                  route {
                        open_list[i] and (h_cost[i] < min_h) ==> {
                              min_h = h_cost[i]
                              u = i
                        }
                        _ ==> {}
                  }
                  i = i + 1
            }

            route {
                  u == 0 ==> {
                        planning = false
                  }
                  _ ==> {
                        open_list[u] = false

                        #L Relaxa arestas predecessoras p -> u
                        p = 1
                        infinite (p <= num_v) {
                              mut as int64: c_pu = cost[(p - 1) * num_v + u]
                              route {
                                    c_pu >= 0 ==> {
                                          route {
                                                h_cost[u] + c_pu < h_cost[p] ==> {
                                                      h_cost[p] = h_cost[u] + c_pu
                                                      next_hop[p] = u
                                                      open_list[p] = true
                                                }
                                                _ ==> {}
                                          }
                                    }
                                    _ ==> {}
                              }
                              p = p + 1
                        }
                  }
            }
      }

      println("2. Planejamento Inicial Concluido:")
      println("   Custo de 1 ate 5: " + h_cost[start_node])
      println("   Proximo no a partir de 1: " + next_hop[start_node])

      #L EVENTO DINAMICO: Obstaculo surge na aresta 2->4! Custo aumenta para 20
      println("3. Evento Dinamico: Obstaculo detectado na aresta (2->4)! Custo alterado de 1 para 20.")
      cost[(2 - 1) * num_v + 4] = 20

      #L Replanejamento D*: No 2 detecta aumento e propaga novo custo
      h_cost[2] = 999999
      open_list[2] = true

      #L Reavalia vizinhos de 2
      mut as int64: nxt = 1
      infinite (nxt <= num_v) {
            mut as int64: c_2nxt = cost[(2 - 1) * num_v + nxt]
            route {
                  c_2nxt >= 0 ==> {
                        route {
                              h_cost[nxt] + c_2nxt < h_cost[2] ==> {
                                    h_cost[2] = h_cost[nxt] + c_2nxt
                                    next_hop[2] = nxt
                              }
                              _ ==> {}
                        }
                  }
                  _ ==> {}
            }
            nxt = nxt + 1
      }

      #L Atualiza no 1 em funcao do novo custo de 2
      mut as int64: c_12 = cost[(1 - 1) * num_v + 2]
      mut as int64: c_13 = cost[(1 - 1) * num_v + 3]
      h_cost[1] = 999999

      route {
            h_cost[2] + c_12 < h_cost[1] ==> {
                  h_cost[1] = h_cost[2] + c_12
                  next_hop[1] = 2
            }
            _ ==> {}
      }

      route {
            h_cost[3] + c_13 < h_cost[1] ==> {
                  h_cost[1] = h_cost[3] + c_13
                  next_hop[1] = 3
            }
            _ ==> {}
      }

      println("4. Replanejamento Concluido:")
      println("   Novo caminho otimo a partir de 1 desvia para o no " + next_hop[1])
      println("   Novo custo total replanejado: " + h_cost[1])

      println("D* concluido com sucesso.")
}
