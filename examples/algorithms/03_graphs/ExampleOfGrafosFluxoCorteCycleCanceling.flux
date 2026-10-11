#L ============================================================================
#L Algoritmo: Cycle-Canceling (Algoritmo de Klein para Fluxo de Custo Minimo)
#L Dominio: 03_graphs / Categoria: Fluxo, corte e matching
#L Complexidade: O(E^2 * C * U) tempo | O(V^2) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosFluxoCorteCycleCanceling) {
      println("==================================================")
      println("  SciAlgo: Cycle-Canceling (Klein's Algorithm)    ")
      println("==================================================")

      mut as int64: num_v = 4
      mut as int64: src = 1
      mut as int64: sink = 4

      #L Grafo com 4 vertices:
      #L Arestas originais e capacidades/custos:
      #L 1->2 (cap 3, custo 1)
      #L 1->3 (cap 2, custo 4)
      #L 2->3 (cap 1, custo 1)
      #L 2->4 (cap 2, custo 5)
      #L 3->4 (cap 3, custo 2)

      #L Inicializamos com um fluxo viavel inicial maximo de valor 4:
      #L 2 unidades via 1->2->4 (custo 2*(1+5) = 12)
      #L 2 unidades via 1->3->4 (custo 2*(4+2) = 12)
      #L Custo inicial = 24

      #L Matriz residual de capacidades 4x4
      mut as list of int64: capacity = [
            0, 1, 0, 0,
            2, 0, 1, 0,
            2, 0, 0, 1,
            0, 2, 2, 0
      ]

      #L Matriz de custos residuais
      mut as list of int64: cost = [
            0, 1, 4, 0,
            -1, 0, 1, 5,
            -4, -1, 0, 2,
            0, -5, -2, 0
      ]

      mut as int64: current_cost = 24
      println("1. Fluxo Viavel Inicial de 4 unidades com custo inicial: " + current_cost)

      #L Laco do Cycle-Canceling: enquanto existir ciclo negativo na rede residual
      mut as bool: has_neg_cycle = true
      mut as int64: cancel_steps = 0

      infinite (has_neg_cycle) {
            #L Deteccao de ciclo negativo usando Bellman-Ford a partir de no virtual 0
            mut as list of int64: dist = [0, 0, 0, 0]
            mut as list of int64: parent = [0, 0, 0, 0]

            #L Relaxa |V|-1 vezes
            mut as int64: iter = 1
            infinite (iter < num_v) {
                  mut as int64: u = 1
                  infinite (u <= num_v) {
                        mut as int64: v = 1
                        infinite (v <= num_v) {
                              mut as int64: idx = (u - 1) * num_v + v
                              route {
                                    capacity[idx] > 0 ==> {
                                          mut as int64: edge_c = cost[idx]
                                          route {
                                                dist[u] + edge_c < dist[v] ==> {
                                                      dist[v] = dist[u] + edge_c
                                                      parent[v] = u
                                                }
                                                _ ==> {}
                                          }
                                    }
                                    _ ==> {}
                              }
                              v = v + 1
                        }
                        u = u + 1
                  }
                  iter = iter + 1
            }

            #L Na iteracao |V|, verifica se ha aresta relaxavel
            mut as int64: cycle_node = 0
            mut as int64: u = 1
            infinite (u <= num_v and cycle_node == 0) {
                  mut as int64: v = 1
                  infinite (v <= num_v and cycle_node == 0) {
                        mut as int64: idx = (u - 1) * num_v + v
                        route {
                              capacity[idx] > 0 ==> {
                                    mut as int64: edge_c = cost[idx]
                                    route {
                                          dist[u] + edge_c < dist[v] ==> {
                                                cycle_node = v
                                          }
                                          _ ==> {}
                                    }
                              }
                              _ ==> {}
                        }
                        v = v + 1
                  }
                  u = u + 1
            }

            route {
                  cycle_node == 0 ==> {
                        has_neg_cycle = false
                  }
                  _ ==> {
                        cancel_steps = cancel_steps + 1

                        #L Retrocede |V| vezes para garantir estar dentro do ciclo
                        mut as int64: k = 1
                        infinite (k <= num_v) {
                              cycle_node = parent[cycle_node]
                              k = k + 1
                        }

                        #L Identifica vertices do ciclo
                        mut as list of int64: cycle = [cycle_node, 0, 0, 0, 0]
                        mut as int64: cycle_len = 1
                        mut as int64: curr = parent[cycle_node]
                        infinite (curr != cycle_node) {
                              cycle_len = cycle_len + 1
                              cycle[cycle_len] = curr
                              curr = parent[curr]
                        }
                        cycle_len = cycle_len + 1
                        cycle[cycle_len] = cycle_node

                        #L Encontra gargalo ao longo do ciclo
                        mut as int64: bottleneck = 999999
                        mut as int64: cycle_cost = 0
                        mut as int64: i = cycle_len
                        infinite (i > 1) {
                              mut as int64: from_node = cycle[i]
                              mut as int64: to_node = cycle[i - 1]
                              mut as int64: edge_idx = (from_node - 1) * num_v + to_node
                              mut as int64: cap_res = capacity[edge_idx]
                              route {
                                    cap_res < bottleneck ==> {
                                          bottleneck = cap_res
                                    }
                                    _ ==> {}
                              }
                              cycle_cost = cycle_cost + cost[edge_idx]
                              i = i - 1
                        }

                        #L Aumenta fluxo ao longo do ciclo
                        i = cycle_len
                        infinite (i > 1) {
                              mut as int64: from_node = cycle[i]
                              mut as int64: to_node = cycle[i - 1]
                              mut as int64: fwd = (from_node - 1) * num_v + to_node
                              mut as int64: rev = (to_node - 1) * num_v + from_node

                              capacity[fwd] = capacity[fwd] - bottleneck
                              capacity[rev] = capacity[rev] + bottleneck

                              i = i - 1
                        }

                        current_cost = current_cost + bottleneck * cycle_cost
                        println("   Cancelado ciclo negativo de custo " + cycle_cost + " com fluxo " + bottleneck)
                  }
            }
      }

      println("2. Nenhum ciclo negativo restante na rede residual.")
      println("3. Custo minimo otimizado: " + current_cost)
      println("Cycle-Canceling concluido com sucesso.")
}
