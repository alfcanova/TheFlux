#L ============================================================================
#L Algoritmo: Minimum-Cost Flow (Fluxo de Custo Minimo via Caminhos Aumentantes)
#L Dominio: 03_graphs / Categoria: Fluxo, corte e matching
#L Complexidade: O(F * V * E) tempo | O(V^2) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosFluxoCorteMinimumCostFlow) {
      println("==================================================")
      println("  SciAlgo: Minimum-Cost Flow (SPFA / Bellman-Ford)")
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

      #L Matriz de custos por unidade de fluxo
      mut as list of int64: cost = [
            0, 1, 4, 0,
            0, 0, 1, 5,
            0, 0, 0, 2,
            0, 0, 0, 0
      ]

      println("1. Grafo de Entrada:")
      println("   Fonte: " + src + ", Sumidouro: " + sink)
      println("   Arestas (cap, custo): (1->2: 3, 1), (1->3: 2, 4), (2->3: 1, 1), (2->4: 2, 5), (3->4: 3, 2)")

      mut as int64: total_flow = 0
      mut as int64: total_cost = 0
      mut as bool: has_path = true

      #L Laco de caminhos aumentantes de custo minimo (Busacker-Gowen)
      infinite (has_path) {
            #L Encontra caminho de custo minimo via Bellman-Ford
            mut as list of int64: dist = [999999, 999999, 999999, 999999]
            mut as list of int64: parent = [0, 0, 0, 0]
            dist[src] = 0

            mut as int64: iter = 1
            infinite (iter < num_v) {
                  mut as int64: u = 1
                  infinite (u <= num_v) {
                        route {
                              dist[u] < 999999 ==> {
                                    mut as int64: v = 1
                                    infinite (v <= num_v) {
                                          mut as int64: c_idx = (u - 1) * num_v + v
                                          route {
                                                capacity[c_idx] > 0 ==> {
                                                      mut as int64: edge_cost = cost[c_idx]
                                                      route {
                                                            dist[u] + edge_cost < dist[v] ==> {
                                                                  dist[v] = dist[u] + edge_cost
                                                                  parent[v] = u
                                                            }
                                                            _ ==> {}
                                                      }
                                                }
                                                _ ==> {}
                                          }
                                          v = v + 1
                                    }
                              }
                              _ ==> {}
                        }
                        u = u + 1
                  }
                  iter = iter + 1
            }

            route {
                  dist[sink] >= 999999 ==> {
                        has_path = false
                  }
                  _ ==> {
                        #L Determina o gargalo (capacidade residual minima no caminho)
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

                        #L Atualiza as capacidades e custos residuais
                        curr = sink
                        infinite (curr != src) {
                              mut as int64: p = parent[curr]
                              mut as int64: fwd = (p - 1) * num_v + curr
                              mut as int64: rev = (curr - 1) * num_v + p

                              capacity[fwd] = capacity[fwd] - bottleneck
                              capacity[rev] = capacity[rev] + bottleneck

                              #L O custo da aresta reversa e o oposto da aresta original
                              cost[rev] = 0 - cost[fwd]

                              curr = p
                        }

                        total_flow = total_flow + bottleneck
                        total_cost = total_cost + bottleneck * dist[sink]
                  }
            }
      }

      println("2. Fluxo maximo transportado: " + total_flow)
      println("3. Custo minimo total associado: " + total_cost)
      println("Minimum-Cost Flow concluido com sucesso.")
}
