#L ============================================================================
#L Algoritmo: Bridge Finding (Deteccao de Pontes em Grafos / Arestas de Corte)
#L Dominio: 03_graphs / Categoria: Conectividade, travessia e representacao
#L Complexidade: O(V + E) tempo | O(V) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosConectividadeBridgeFinding) {
      println("==================================================")
      println("  SciAlgo: Bridge Finding (Tarjan Lowlink)        ")
      println("==================================================")

      mut as int64: num_v = 5
      mut as list of int64: adj = [
            0, 1, 1, 0, 0,
            1, 0, 1, 0, 0,
            1, 1, 0, 1, 0,
            0, 0, 1, 0, 1,
            0, 0, 0, 1, 0
      ]

      mut as list of int64: tin = [0, 0, 0, 0, 0]
      mut as list of int64: low = [0, 0, 0, 0, 0]
      mut as list of int64: visited = [0, 0, 0, 0, 0]
      mut as list of int64: parent = [0, 0, 0, 0, 0]

      mut as int64: timer = 1
      tin[1] = timer
      low[1] = timer
      visited[1] = 1

      mut as list of int64: cs_u = [0, 0, 0, 0, 0, 0, 0, 0]
      mut as list of int64: cs_e = [1, 1, 1, 1, 1, 1, 1, 1]
      mut as int64: cs_top = 1
      cs_u[1] = 1
      cs_e[1] = 1

      println("Pontes Encontradas no Grafo:")

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
                                                tin[v] < low[u] ==> {
                                                      low[u] = tin[v]
                                                }
                                                _ ==> {}
                                          }
                                          edge_k = edge_k + 1
                                    }
                                    visited[v] == 0 ==> {
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
                                          low[u] > tin[p] ==> {
                                                println("   Ponte encontrada: (" + p + " - " + u + ")")
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
}
