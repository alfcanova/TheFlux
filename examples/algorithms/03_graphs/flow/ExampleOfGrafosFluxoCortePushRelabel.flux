#L ============================================================================
#L Algoritmo: Push-Relabel (Fluxo Maximo Preflow-Push de Goldberg-Tarjan)
#L Dominio: 03_graphs / Categoria: Fluxo, corte e matching
#L Complexidade: O(V^2 * E) tempo | O(V^2) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosFluxoCortePushRelabel) {
      println("==================================================")
      println("  SciAlgo: Push-Relabel (Preflow-Push)            ")
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

      #L Laco principal: enquanto houver vertice ativo u (u != src, u != sink com excesso > 0)
      mut as bool: has_active = true
      mut as int64: step = 0

      infinite (has_active) {
            step = step + 1
            has_active = false
            mut as int64: active_u = 0

            #L Busca vertice ativo
            mut as int64: u = 1
            infinite (u <= num_v and active_u == 0) {
                  route {
                        (u != src) and (u != sink) and (excess[u] > 0) ==> {
                              active_u = u
                        }
                        _ ==> {}
                  }
                  u = u + 1
            }

            route {
                  active_u > 0 ==> {
                        has_active = true
                        #L Tenta operacao PUSH para algum vizinho com height[u] == height[v] + 1
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

                        #L Se nao foi possivel dar push, RELABEL vertice active_u
                        route {
                              not pushed ==> {
                                    mut as int64: min_h = 999999
                                    mut as int64: k = 1
                                    infinite (k <= num_v) {
                                          mut as int64: fwd = (active_u - 1) * num_v + k
                                          route {
                                                capacity[fwd] > 0 ==> {
                                                      route {
                                                            height[k] < min_h ==> {
                                                                  min_h = height[k]
                                                            }
                                                            _ ==> {}
                                                      }
                                                }
                                                _ ==> {}
                                          }
                                          k = k + 1
                                    }

                                    route {
                                          min_h < 999999 ==> {
                                                height[active_u] = min_h + 1
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

      println("2. Resultado Final:")
      println("   Passos executados: " + step)
      println("   Fluxo Maximo Push-Relabel: " + max_flow)

      route {
            max_flow == 25 ==> {
                  println("   Validacao: SUCESSO (Fluxo Maximo = 25)")
            }
            _ ==> {
                  println("   Validacao: FALHA")
            }
      }

      println("Push-Relabel concluido com sucesso.")
}
