#L ============================================================================
#L Algoritmo: Highest-Label Push-Relabel (HLPR)
#L Dominio: 03_graphs / Categoria: Fluxo, corte e matching
#L Complexidade: O(V^2 * sqrt(E)) tempo | O(V^2) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosFluxoCorteHighestLabelPushRelabel) {
      println("==================================================")
      println("  SciAlgo: Highest-Label Push-Relabel (HLPR)      ")
      println("==================================================")

      mut as int64: num_v = 4
      mut as int64: src = 1
      mut as int64: sink = 4

      #L Matriz residual 4x4
      mut as list of int64: capacity = [
            0, 15, 10, 0,
            0, 0, 5, 10,
            0, 0, 0, 15,
            0, 0, 0, 0
      ]

      println("1. Grafo de Entrada:")
      println("   Fonte: " + src + ", Sumidouro: " + sink)
      println("   Capacidades: 1->2: 15, 1->3: 10, 2->3: 5, 2->4: 10, 3->4: 15")

      mut as list of int64: height = [0, 0, 0, 0]
      mut as list of int64: excess = [0, 0, 0, 0]

      #L Inicializacao: altura da fonte = V
      height[src] = num_v

      #L Preflow inicial da fonte
      mut as int64: v = 1
      infinite (v <= num_v) {
            mut as int64: idx = (src - 1) * num_v + v
            mut as int64: cap = capacity[idx]
            route {
                  cap > 0 ==> {
                        capacity[idx] = 0
                        mut as int64: rev = (v - 1) * num_v + src
                        capacity[rev] = capacity[rev] + cap
                        excess[v] = excess[v] + cap
                        excess[src] = excess[src] - cap
                  }
                  _ ==> {}
            }
            v = v + 1
      }

      mut as bool: has_active = true
      mut as int64: step = 0

      infinite (has_active) {
            step = step + 1
            has_active = false
            mut as int64: max_h = -1
            mut as int64: active_u = 0

            #L Seleciona o vertice ativo de MAIOR ALTURA (Highest-Label)
            mut as int64: u = 1
            infinite (u <= num_v) {
                  route {
                        (u != src) and (u != sink) and (excess[u] > 0) ==> {
                              route {
                                    height[u] > max_h ==> {
                                          max_h = height[u]
                                          active_u = u
                                    }
                                    _ ==> {}
                              }
                        }
                        _ ==> {}
                  }
                  u = u + 1
            }

            route {
                  active_u > 0 ==> {
                        has_active = true
                        #L Tenta operacao PUSH para vizinho com height[u] == height[nxt] + 1
                        mut as bool: pushed = false
                        mut as int64: nxt = 1

                        infinite (nxt <= num_v and not pushed) {
                              mut as int64: fwd = (active_u - 1) * num_v + nxt
                              mut as int64: cap_res = capacity[fwd]

                              route {
                                    (cap_res > 0) and (height[active_u] == height[nxt] + 1) ==> {
                                          mut as int64: send = excess[active_u]
                                          route {
                                                cap_res < send ==> {
                                                      send = cap_res
                                                }
                                                _ ==> {}
                                          }

                                          capacity[fwd] = capacity[fwd] - send
                                          mut as int64: rev = (nxt - 1) * num_v + active_u
                                          capacity[rev] = capacity[rev] + send

                                          excess[active_u] = excess[active_u] - send
                                          excess[nxt] = excess[nxt] + send
                                          pushed = true
                                    }
                                    _ ==> {}
                              }
                              nxt = nxt + 1
                        }

                        #L Se nenhum push foi possivel, faz RELABEL
                        route {
                              not pushed ==> {
                                    mut as int64: min_neighbor_h = 999999
                                    mut as int64: k = 1
                                    infinite (k <= num_v) {
                                          mut as int64: res_idx = (active_u - 1) * num_v + k
                                          route {
                                                capacity[res_idx] > 0 ==> {
                                                      route {
                                                            height[k] < min_neighbor_h ==> {
                                                                  min_neighbor_h = height[k]
                                                            }
                                                            _ ==> {}
                                                      }
                                                }
                                                _ ==> {}
                                          }
                                          k = k + 1
                                    }

                                    route {
                                          min_neighbor_h < 999999 ==> {
                                                height[active_u] = min_neighbor_h + 1
                                          }
                                          _ ==> {}
                                    }
                              }
                              _ ==> {}
                        }
                  }
                  _ ==> {}
            }
      }

      mut as int64: max_flow = excess[sink]
      println("2. Fluxo maximo calculado: " + max_flow)
      println("3. Alturas finais dos vertices: [" + height[1] + ", " + height[2] + ", " + height[3] + ", " + height[4] + "]")
      println("4. Excessos finais: [" + excess[1] + ", " + excess[2] + ", " + excess[3] + ", " + excess[4] + "]")
      println("Highest-Label Push-Relabel concluido com sucesso.")
}
