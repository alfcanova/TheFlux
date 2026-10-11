#L ============================================================================
#L Algoritmo: Tarjan SCC (Componentes Fortemente Conexos em Uma Passagem)
#L Dominio: 03_graphs / Categoria: Conectividade, travessia e representacao
#L Complexidade: O(V + E) tempo | O(V) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosConectividadeTarjanSCC) {
      println("==================================================")
      println("  SciAlgo: Tarjan's SCC Algorithm                 ")
      println("==================================================")

      mut as int64: num_v = 5

      #L 1->2, 2->3, 3->1 (SCC 1)
      #L 3->4
      #L 4->5, 5->4 (SCC 2)
      mut as list of int64: adj = [
            0, 1, 0, 0, 0,
            0, 0, 1, 0, 0,
            1, 0, 0, 1, 0,
            0, 0, 0, 0, 1,
            0, 0, 0, 1, 0
      ]

      println("1. Grafo Direcionado com 5 Vertices (Tarjan SCC)")

      mut as list of int64: dfn = [0, 0, 0, 0, 0]
      mut as list of int64: low = [0, 0, 0, 0, 0]
      mut as list of bool: in_stk = [false, false, false, false, false]
      mut as list of int64: scc_id = [0, 0, 0, 0, 0]

      mut as list of int64: stk = [0, 0, 0, 0, 0, 0]
      mut as int64: top = 0
      mut as int64: timer = 0
      mut as int64: scc_cnt = 0

      #L Pilha para DFS iterativo do algoritmo de Tarjan
      mut as list of int64: call_stack = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      mut as list of int64: next_edge = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
      mut as int64: cs_top = 0

      mut as int64: start_node = 1
      mut as int64: u = 0
      mut as int64: v = 0
      mut as int64: i = 1

      infinite (start_node <= num_v) {
            route {
                  dfn[start_node] == 0 ==> {
                        cs_top = 1
                        call_stack[cs_top] = start_node
                        next_edge[cs_top] = 1

                        timer = timer + 1
                        dfn[start_node] = timer
                        low[start_node] = timer
                        top = top + 1
                        stk[top] = start_node
                        in_stk[start_node] = true

                        infinite (cs_top > 0) {
                              u = call_stack[cs_top]
                              mut as int64: edge_idx = next_edge[cs_top]
                              mut as bool: advanced = false

                              infinite (edge_idx <= num_v and not advanced) {
                                    route {
                                          adj[(u - 1) * num_v + edge_idx] == 1 ==> {
                                                v = edge_idx
                                                route {
                                                      dfn[v] == 0 ==> {
                                                            #L Avanca chamada para v
                                                            next_edge[cs_top] = edge_idx + 1
                                                            cs_top = cs_top + 1
                                                            call_stack[cs_top] = v
                                                            next_edge[cs_top] = 1

                                                            timer = timer + 1
                                                            dfn[v] = timer
                                                            low[v] = timer
                                                            top = top + 1
                                                            stk[top] = v
                                                            in_stk[v] = true
                                                            advanced = true
                                                      }
                                                      in_stk[v] ==> {
                                                            route {
                                                                  dfn[v] < low[u] ==> {
                                                                        low[u] = dfn[v]
                                                                  }
                                                                  _ ==> {}
                                                            }
                                                      }
                                                      _ ==> {}
                                                }
                                          }
                                          _ ==> {}
                                    }
                                    edge_idx = edge_idx + 1
                              }

                              route {
                                    not advanced ==> {
                                          #L Retorna de u
                                          route {
                                                cs_top > 1 ==> {
                                                      mut as int64: parent_u = call_stack[cs_top - 1]
                                                      route {
                                                            low[u] < low[parent_u] ==> {
                                                                  low[parent_u] = low[u]
                                                            }
                                                            _ ==> {}
                                                      }
                                                }
                                                _ ==> {}
                                          }

                                          #L Verifica se u e raiz de uma SCC
                                          route {
                                                dfn[u] == low[u] ==> {
                                                      scc_cnt = scc_cnt + 1
                                                      mut as int64: popped = 0
                                                      mut as bool: scc_done = false
                                                      infinite (not scc_done) {
                                                            popped = stk[top]
                                                            top = top - 1
                                                            in_stk[popped] = false
                                                            scc_id[popped] = scc_cnt
                                                            route {
                                                                  popped == u ==> {
                                                                        scc_done = true
                                                                  }
                                                                  _ ==> {}
                                                            }
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
                  _ ==> {}
            }
            start_node = start_node + 1
      }

      println("2. Total de SCCs via Tarjan: " + scc_cnt)
      i = 1
      infinite (i <= num_v) {
            println("   Vertice " + i + " -> SCC #" + scc_id[i])
            i = i + 1
      }

      println("Tarjan SCC concluido com sucesso.")
}
