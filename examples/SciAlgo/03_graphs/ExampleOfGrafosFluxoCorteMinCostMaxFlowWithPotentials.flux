#L ============================================================================
#L Algoritmo: Min-Cost Max-Flow com Potenciais (Dijkstra + Johnson)
#L Dominio: 03_graphs / Categoria: Fluxo, corte e matching
#L Complexidade: O(F * (E + V log V)) tempo | O(V^2) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosFluxoCorteMinCostMaxFlowWithPotentials) {
      println("==================================================")
      println("  SciAlgo: Min-Cost Max-Flow com Potenciais       ")
      println("==================================================")

      mut as int64: num_v = 4
      mut as int64: src = 1
      mut as int64: sink = 4

      #L Matriz residual de capacidades 4x4
      mut as list of int64: capacity = [
            0, 3, 2, 0,
            0, 0, 1, 2,
            0, 0, 0, 3,
            0, 0, 0, 0
      ]

      #L Matriz de custos
      mut as list of int64: cost = [
            0, 1, 4, 0,
            0, 0, 1, 5,
            0, 0, 0, 2,
            0, 0, 0, 0
      ]

      println("1. Grafo de Entrada:")
      println("   Fonte: " + src + ", Sumidouro: " + sink)
      println("   Arestas (cap, custo): (1->2: 3, 1), (1->3: 2, 4), (2->3: 1, 1), (2->4: 2, 5), (3->4: 3, 2)")

      #L Potenciais de nos pi (iniciados com 0 pois custos iniciais sao >= 0)
      mut as list of int64: pi = [0, 0, 0, 0]

      mut as int64: total_flow = 0
      mut as int64: total_cost = 0
      mut as bool: has_path = true

      #L Laco de aumentacao usando Dijkstra com custos reduzidos
      infinite (has_path) {
            mut as list of int64: dist = [999999, 999999, 999999, 999999]
            mut as list of bool: visited = [false, false, false, false]
            mut as list of int64: parent = [0, 0, 0, 0]
            dist[src] = 0

            #L Dijkstra
            mut as int64: count = 1
            infinite (count <= num_v) {
                  #L Encontra vertice nao visitado com menor distancia
                  mut as int64: u = 0
                  mut as int64: min_d = 999999

                  mut as int64: i = 1
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
                              count = num_v + 1
                        }
                        _ ==> {
                              visited[u] = true

                              #L Relaxa arestas saindo de u com custo reduzido: c_pi = cost[u, v] + pi[u] - pi[v]
                              mut as int64: v = 1
                              infinite (v <= num_v) {
                                    mut as int64: idx = (u - 1) * num_v + v
                                    route {
                                          capacity[idx] > 0 ==> {
                                                mut as int64: reduced_cost = cost[idx] + pi[u] - pi[v]
                                                route {
                                                      dist[u] + reduced_cost < dist[v] ==> {
                                                            dist[v] = dist[u] + reduced_cost
                                                            parent[v] = u
                                                      }
                                                      _ ==> {}
                                                }
                                          }
                                          _ ==> {}
                                    }
                                    v = v + 1
                              }

                              count = count + 1
                        }
                  }
            }

            route {
                  dist[sink] >= 999999 ==> {
                        has_path = false
                  }
                  _ ==> {
                        #L Atualiza potenciais pi[v] = pi[v] + dist[v] para vertices alcancaveis
                        mut as int64: v_idx = 1
                        infinite (v_idx <= num_v) {
                              route {
                                    dist[v_idx] < 999999 ==> {
                                          pi[v_idx] = pi[v_idx] + dist[v_idx]
                                    }
                                    _ ==> {}
                              }
                              v_idx = v_idx + 1
                        }

                        #L Determina o gargalo do caminho
                        mut as int64: bottleneck = 999999
                        mut as int64: curr = sink
                        infinite (curr != src) {
                              mut as int64: p = parent[curr]
                              mut as int64: cap_res = capacity[(p - 1) * num_v + curr]
                              route {
                                    cap_res < bottleneck ==> {
                                          bottleneck = cap_res
                                    }
                                    _ ==> {}
                              }
                              curr = p
                        }

                        #L Aplica fluxo
                        curr = sink
                        infinite (curr != src) {
                              mut as int64: p = parent[curr]
                              mut as int64: fwd = (p - 1) * num_v + curr
                              mut as int64: rev = (curr - 1) * num_v + p

                              capacity[fwd] = capacity[fwd] - bottleneck
                              capacity[rev] = capacity[rev] + bottleneck
                              cost[rev] = 0 - cost[fwd]

                              total_cost = total_cost + bottleneck * cost[fwd]
                              curr = p
                        }

                        total_flow = total_flow + bottleneck
                  }
            }
      }

      println("2. Fluxo maximo com potenciais: " + total_flow)
      println("3. Custo total minimo: " + total_cost)
      println("4. Potenciais finais pi: [" + pi[1] + ", " + pi[2] + ", " + pi[3] + ", " + pi[4] + "]")
      println("Min-Cost Max-Flow com Potenciais concluido com sucesso.")
}
