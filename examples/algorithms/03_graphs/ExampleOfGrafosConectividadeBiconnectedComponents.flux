#L ============================================================================
#L Algoritmo: Biconnected Components (Componentes Biconexas / Blocos 2-VC)
#L Dominio: 03_graphs / Categoria: Conectividade, travessia e representacao
#L Complexidade: O(V + E) tempo | O(V + E) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosConectividadeBiconnectedComponents) {
      println("==================================================")
      println("  SciAlgo: Biconnected Components (Blocks)        ")
      println("==================================================")

      mut as int64: num_v = 6
      mut as list of int64: adj = [
            0, 1, 1, 0, 0, 0,
            1, 0, 1, 0, 0, 0,
            1, 1, 0, 1, 0, 0,
            0, 0, 1, 0, 1, 1,
            0, 0, 0, 1, 0, 1,
            0, 0, 0, 1, 1, 0
      ]

      mut as list of int64: tin = [0, 0, 0, 0, 0, 0]
      mut as list of int64: low = [0, 0, 0, 0, 0, 0]
      mut as list of int64: visited = [0, 0, 0, 0, 0, 0]
      mut as list of int64: parent = [0, 0, 0, 0, 0, 0]

      mut as list of int64: stk_u = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      mut as list of int64: stk_v = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      mut as int64: stk_top = 0
      mut as int64: bcc_cnt = 0

      mut as int64: timer = 1
      tin[1] = timer
      low[1] = timer
      visited[1] = 1

      mut as list of int64: cs_u = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      mut as list of int64: cs_e = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
      mut as int64: cs_top = 1
      cs_u[1] = 1
      cs_e[1] = 1

      println("Identificacao das Componentes Biconexas:")

      infinite (cs_top > 0) {
            mut as int64: u = cs_u[cs_top]
            mut as int64: edge_k = cs_e[cs_top]
            mut as bool: advanced = false

            infinite (edge_k <= num_v and not advanced) {
                  route {
                        adj[(u - 1) * num_v + edge_k] == 1 ==> {
                              mut as int64: v = edge_k
                              route {
                                    v == parent[u] ==> {
                                          edge_k = edge_k + 1
                                    }
                                    visited[v] == 1 ==> {
                                          route {
                                                tin[v] < tin[u] ==> {
                                                      stk_top = stk_top + 1
                                                      stk_u[stk_top] = u
                                                      stk_v[stk_top] = v
                                                      route {
                                                            tin[v] < low[u] ==> {
                                                                  low[u] = tin[v]
                                                            }
                                                            _ ==> {}
                                                      }
                                                }
                                                _ ==> {}
                                          }
                                          edge_k = edge_k + 1
                                    }
                                    visited[v] == 0 ==> {
                                          stk_top = stk_top + 1
                                          stk_u[stk_top] = u
                                          stk_v[stk_top] = v

                                          visited[v] = 1
                                          parent[v] = u
                                          timer = timer + 1
                                          tin[v] = timer
                                          low[v] = timer

                                          cs_e[cs_top] = edge_k + 1
                                          cs_top = cs_top + 1
                                          cs_u[cs_top] = v
                                          cs_e[cs_top] = 1
                                          advanced = true
                                    }
                                    _ ==> {
                                          edge_k = edge_k + 1
                                    }
                              }
                        }
                        _ ==> {
                              edge_k = edge_k + 1
                        }
                  }
            }

            route {
                  not advanced ==> {
                        mut as int64: p = parent[u]
                        route {
                              p > 0 ==> {
                                    route {
                                          low[u] < low[p] ==> {
                                                low[p] = low[u]
                                          }
                                          _ ==> {}
                                    }
                                    route {
                                          low[u] >= tin[p] ==> {
                                                bcc_cnt = bcc_cnt + 1
                                                mut as string: bcc_str = "Bloco " + bcc_cnt + ":"
                                                mut as bool: pop_done = false
                                                infinite (stk_top > 0 and not pop_done) {
                                                      mut as int64: pu = stk_u[stk_top]
                                                      mut as int64: pv = stk_v[stk_top]
                                                      stk_top = stk_top - 1
                                                      bcc_str = bcc_str + " (" + pu + "-" + pv + ")"
                                                      route {
                                                            pu == p and pv == u ==> {
                                                                  pop_done = true
                                                            }
                                                            _ ==> {}
                                                      }
                                                }
                                                println("   " + bcc_str)
                                          }
                                          _ ==> {}
                                    }
                              }
                              _ ==> {}
                        }
                        cs_top = cs_top - 1
                  }
                  _ ==> {}
            }
      }

      println("Total de Componentes Biconexas: " + bcc_cnt)
}
