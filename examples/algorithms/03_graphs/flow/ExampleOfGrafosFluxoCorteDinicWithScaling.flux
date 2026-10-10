#L ============================================================================
#L Algoritmo: Dinic with Scaling (Fluxo Maximo com Escalonamento de Capacidade)
#L Dominio: 03_graphs / Categoria: Fluxo, corte e matching
#L Complexidade: O(V * E * log(U)) tempo | O(V^2) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosFluxoCorteDinicWithScaling) {
      println("==================================================")
      println("  SciAlgo: Dinic com Escalonamento (Scaling)      ")
      println("==================================================")

      mut as int64: num_v = 4
      mut as int64: src = 1
      mut as int64: sink = 4

      mut as list of int64: capacity = [
            0, 100, 100, 0,
            0, 0, 1, 100,
            0, 0, 0, 100,
            0, 0, 0, 0
      ]

      println("1. Grafo de Entrada:")
      println("   Fonte: " + src + ", Sumidouro: " + sink)
      println("   Capacidades: 1->2: 100, 1->3: 100, 2->3: 1, 2->4: 100, 3->4: 100")

      mut as int64: max_flow = 0
      mut as int64: delta = 64

      infinite (delta >= 1) {
            println("   Escala delta = " + delta)

            mut as bool: can_reach_sink = true

            infinite (can_reach_sink) {
                  #L BFS considerando apenas arestas residuais com cap >= delta
                  mut as list of int64: level = [-1, -1, -1, -1]
                  mut as list of int64: queue = [src, 0, 0, 0]
                  mut as int64: head = 1
                  mut as int64: tail = 1
                  level[src] = 0

                  infinite (head <= tail) {
                        mut as int64: u = queue[head]
                        head = head + 1

                        mut as int64: v = 1
                        infinite (v <= num_v) {
                              mut as int64: idx = (u - 1) * num_v + v
                              mut as int64: cap = capacity[idx]

                              route {
                                    (level[v] == -1) and (cap >= delta) ==> {
                                          level[v] = level[u] + 1
                                          tail = tail + 1
                                          queue[tail] = v
                                    }
                                    _ ==> {}
                              }
                              v = v + 1
                        }
                  }

                  route {
                        level[sink] == -1 ==> {
                              can_reach_sink = false
                        }
                        _ ==> {
                              #L Empurra fluxo bloqueante nesta escala
                              mut as bool: search_augmenting = true
                              infinite (search_augmenting) {
                                    mut as list of bool: visited = [false, false, false, false]
                                    mut as list of int64: parent = [0, 0, 0, 0]
                                    mut as list of int64: stack = [src, 0, 0, 0]
                                    mut as int64: top = 1
                                    visited[src] = true
                                    mut as bool: path_found = false

                                    infinite (top > 0 and not path_found) {
                                          mut as int64: curr = stack[top]
                                          top = top - 1

                                          route {
                                                curr == sink ==> {
                                                      path_found = true
                                                }
                                                _ ==> {
                                                      mut as int64: nxt = 1
                                                      infinite (nxt <= num_v and not path_found) {
                                                            mut as int64: idx = (curr - 1) * num_v + nxt
                                                            mut as int64: cap = capacity[idx]

                                                            route {
                                                                  (not visited[nxt]) and (cap >= delta) and (level[nxt] == level[curr] + 1) ==> {
                                                                        visited[nxt] = true
                                                                        parent[nxt] = curr
                                                                        top = top + 1
                                                                        stack[top] = nxt
                                                                  }
                                                                  _ ==> {}
                                                            }
                                                            nxt = nxt + 1
                                                      }
                                                }
                                          }
                                    }

                                    route {
                                          not path_found ==> {
                                                search_augmenting = false
                                          }
                                          _ ==> {
                                                mut as int64: bottleneck = 999999
                                                mut as int64: cur_v = sink
                                                infinite (cur_v != src) {
                                                      mut as int64: p = parent[cur_v]
                                                      mut as int64: idx = (p - 1) * num_v + cur_v
                                                      mut as int64: cap = capacity[idx]
                                                      route {
                                                            cap < bottleneck ==> {
                                                                  bottleneck = cap
                                                            }
                                                            _ ==> {}
                                                      }
                                                      cur_v = p
                                                }

                                                cur_v = sink
                                                infinite (cur_v != src) {
                                                      mut as int64: p = parent[cur_v]
                                                      mut as int64: fwd = (p - 1) * num_v + cur_v
                                                      mut as int64: rev = (cur_v - 1) * num_v + p

                                                      capacity[fwd] = capacity[fwd] - bottleneck
                                                      capacity[rev] = capacity[rev] + bottleneck
                                                      cur_v = p
                                                }

                                                max_flow = max_flow + bottleneck
                                          }
                                    }
                              }
                        }
                  }
            }

            delta = delta /i 2
      }

      println("2. Resultado Final:")
      println("   Fluxo Maximo Dinic com Scaling: " + max_flow)

      route {
            max_flow == 200 ==> {
                  println("   Validacao: SUCESSO (Fluxo Maximo = 200)")
            }
            _ ==> {
                  println("   Validacao: FALHA")
            }
      }

      println("Dinic with Scaling concluido com sucesso.")
}
