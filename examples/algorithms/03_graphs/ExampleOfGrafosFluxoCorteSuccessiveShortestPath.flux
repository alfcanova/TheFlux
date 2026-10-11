#L ============================================================================
#L Algoritmo: Successive Shortest Path (Caminho Mais Curto Sucessivo para Fluxo Minimo)
#L Dominio: 03_graphs / Categoria: Fluxo, corte e matching
#L Complexidade: O(U * (E + V log V)) tempo | O(V^2) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosFluxoCorteSuccessiveShortestPath) {
      println("==================================================")
      println("  SciAlgo: Successive Shortest Path               ")
      println("==================================================")

      mut as int64: num_v = 4

      #L Balanco de suprimento/demanda inicial dos vertices
      #L Vertice 1: suprimento (+4), Vertice 4: demanda (-4)
      mut as list of int64: balance = [4, 0, 0, -4]

      #L Matriz residual de capacidades 4x4
      mut as list of int64: capacity = [
            0, 3, 3, 0,
            0, 0, 2, 2,
            0, 0, 0, 3,
            0, 0, 0, 0
      ]

      #L Matriz de custos por unidade de fluxo
      mut as list of int64: cost = [
            0, 2, 5, 0,
            0, 0, 1, 4,
            0, 0, 0, 1,
            0, 0, 0, 0
      ]

      println("1. Rede com Balanco de Oferta e Demanda:")
      println("   No 1: oferta +4, Nos 2 e 3: transbordo 0, No 4: demanda -4")
      println("   Arestas (cap, custo): (1->2: 3, 2), (1->3: 3, 5), (2->3: 2, 1), (2->4: 2, 4), (3->4: 3, 1)")

      mut as int64: total_cost = 0
      mut as bool: has_unbalanced = true

      #L Laco do algoritmo Successive Shortest Path
      infinite (has_unbalanced) {
            #L Encontra vertice com excesso (oferta restante > 0)
            mut as int64: src = 0
            mut as int64: i = 1
            infinite (i <= num_v and src == 0) {
                  route {
                        balance[i] > 0 ==> {
                              src = i
                        }
                        _ ==> {}
                  }
                  i = i + 1
            }

            #L Encontra vertice com deficit (demanda restante < 0)
            mut as int64: sink = 0
            i = 1
            infinite (i <= num_v and sink == 0) {
                  route {
                        balance[i] < 0 ==> {
                              sink = i
                        }
                        _ ==> {}
                  }
                  i = i + 1
            }

            route {
                  (src == 0) or (sink == 0) ==> {
                        has_unbalanced = false
                  }
                  _ ==> {
                        #L Calcula caminho mais curto de src para todos os vertices via Bellman-Ford
                        mut as list of int64: dist = [999999, 999999, 999999, 999999]
                        mut as list of int64: parent = [0, 0, 0, 0]
                        dist[src] = 0

                        mut as int64: step = 1
                        infinite (step < num_v) {
                              mut as int64: u = 1
                              infinite (u <= num_v) {
                                    route {
                                          dist[u] < 999999 ==> {
                                                mut as int64: v = 1
                                                infinite (v <= num_v) {
                                                      mut as int64: idx = (u - 1) * num_v + v
                                                      route {
                                                            capacity[idx] > 0 ==> {
                                                                  mut as int64: c_uv = cost[idx]
                                                                  route {
                                                                        dist[u] + c_uv < dist[v] ==> {
                                                                              dist[v] = dist[u] + c_uv
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
                              step = step + 1
                        }

                        route {
                              dist[sink] >= 999999 ==> {
                                    #L Rede inviavel (nao alcanca deficit)
                                    has_unbalanced = false
                              }
                              _ ==> {
                                    #L Gargalo de fluxo no caminho
                                    mut as int64: send = balance[src]
                                    mut as int64: neg_dem = 0 - balance[sink]
                                    route {
                                          neg_dem < send ==> {
                                                send = neg_dem
                                          }
                                          _ ==> {}
                                    }

                                    mut as int64: curr = sink
                                    infinite (curr != src) {
                                          mut as int64: p = parent[curr]
                                          mut as int64: cap_res = capacity[(p - 1) * num_v + curr]
                                          route {
                                                cap_res < send ==> {
                                                      send = cap_res
                                                }
                                                _ ==> {}
                                          }
                                          curr = p
                                    }

                                    #L Aplica o fluxo no caminho residual
                                    curr = sink
                                    infinite (curr != src) {
                                          mut as int64: p = parent[curr]
                                          mut as int64: fwd = (p - 1) * num_v + curr
                                          mut as int64: rev = (curr - 1) * num_v + p

                                          capacity[fwd] = capacity[fwd] - send
                                          capacity[rev] = capacity[rev] + send
                                          cost[rev] = 0 - cost[fwd]

                                          curr = p
                                    }

                                    balance[src] = balance[src] - send
                                    balance[sink] = balance[sink] + send
                                    total_cost = total_cost + send * dist[sink]
                              }
                        }
                  }
            }
      }

      println("2. Suprimentos/Demandas atendidos com sucesso.")
      println("3. Custo minimo total da circulacao: " + total_cost)
      println("Successive Shortest Path concluido com sucesso.")
}
