#L ============================================================================
#L Algoritmo: Path-Based SCC (Algoritmo Baseado em Caminhos de Cheriyan-Mehlhorn)
#L Dominio: 03_graphs / Categoria: Conectividade, travessia e representacao
#L Complexidade: O(V + E) tempo | O(V) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosConectividadePathBasedSCC) {
      println("==================================================")
      println("  SciAlgo: Path-Based Strong Components (SCC)     ")
      println("==================================================")

      mut as int64: num_v = 5

      #L Grafo: 1->2, 2->3, 3->1 (SCC 1), 3->4, 4->5, 5->4 (SCC 2)
      mut as list of int64: adj = [
            0, 1, 0, 0, 0,
            0, 0, 1, 0, 0,
            1, 0, 0, 1, 0,
            0, 0, 0, 0, 1,
            0, 0, 0, 1, 0
      ]

      println("1. Grafo Direcionado com 5 Vertices (Path-Based SCC)")

      mut as list of int64: val = [0, 0, 0, 0, 0] #L DFN/indice de pre-ordem
      mut as list of int64: scc = [0, 0, 0, 0, 0]
      mut as int64: clock = 0
      mut as int64: count_scc = 0

      #L Pilha de nos no caminho atual
      mut as list of int64: path_stk = [0, 0, 0, 0, 0, 0]
      mut as int64: p_top = 0

      #L Pilha de representantes do caminho (boundary roots)
      mut as list of int64: root_stk = [0, 0, 0, 0, 0, 0]
      mut as int64: r_top = 0

      #L Pilha DFS
      mut as list of int64: cs = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      mut as list of int64: ce = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
      mut as int64: cs_top = 0

      mut as int64: start_v = 1
      mut as int64: u = 0
      mut as int64: v = 0
      mut as int64: i = 1

      infinite (start_v <= num_v) {
            route {
                  val[start_v] == 0 ==> {
                        cs_top = 1
                        cs[cs_top] = start_v
                        ce[cs_top] = 1

                        clock = clock + 1
                        val[start_v] = clock
                        p_top = p_top + 1
                        path_stk[p_top] = start_v
                        r_top = r_top + 1
                        root_stk[r_top] = start_v

                        infinite (cs_top > 0) {
                              u = cs[cs_top]
                              mut as int64: edge_k = ce[cs_top]
                              mut as bool: advanced = false

                              infinite (edge_k <= num_v and not advanced) {
                                    route {
                                          adj[(u - 1) * num_v + edge_k] == 1 ==> {
                                                v = edge_k
                                                route {
                                                      val[v] == 0 ==> {
                                                            ce[cs_top] = edge_k + 1
                                                            cs_top = cs_top + 1
                                                            cs[cs_top] = v
                                                            ce[cs_top] = 1

                                                            clock = clock + 1
                                                            val[v] = clock
                                                            p_top = p_top + 1
                                                            path_stk[p_top] = v
                                                            r_top = r_top + 1
                                                            root_stk[r_top] = v
                                                            advanced = true
                                                      }
                                                      scc[v] == 0 ==> {
                                                            #L Contrai ciclo no caminho
                                                            infinite (r_top > 0 and val[root_stk[r_top]] > val[v]) {
                                                                  r_top = r_top - 1
                                                            }
                                                      }
                                                      _ ==> {}
                                                }
                                          }
                                          _ ==> {}
                                    }
                                    edge_k = edge_k + 1
                              }

                              route {
                                    not advanced ==> {
                                          #L Se u e a raiz da componente no caminho
                                          route {
                                                (r_top > 0) and (root_stk[r_top] == u) ==> {
                                                      r_top = r_top - 1
                                                      count_scc = count_scc + 1
                                                      mut as int64: popped = 0
                                                      mut as bool: done = false
                                                      infinite (not done) {
                                                            popped = path_stk[p_top]
                                                            p_top = p_top - 1
                                                            scc[popped] = count_scc
                                                            route {
                                                                  popped == u ==> {
                                                                        done = true
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
            start_v = start_v + 1
      }

      println("2. Total de SCCs via Path-Based: " + count_scc)
      i = 1
      infinite (i <= num_v) {
            println("   Vertice " + i + " -> SCC #" + scc[i])
            i = i + 1
      }

      println("Path-Based SCC concluido com sucesso.")
}
