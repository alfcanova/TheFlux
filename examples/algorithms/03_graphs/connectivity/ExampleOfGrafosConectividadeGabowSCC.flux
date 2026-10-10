#L ============================================================================
#L Algoritmo: Gabow SCC (Algoritmo de Gabow com Pilhas de Fronteira)
#L Dominio: 03_graphs / Categoria: Conectividade, travessia e representacao
#L Complexidade: O(V + E) tempo | O(V) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosConectividadeGabowSCC) {
      println("==================================================")
      println("  SciAlgo: Gabow's SCC Algorithm                  ")
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

      println("1. Grafo Direcionado com 5 Vertices (Gabow SCC)")

      mut as list of int64: pre = [0, 0, 0, 0, 0]
      mut as list of int64: scc_id = [0, 0, 0, 0, 0]
      mut as int64: c_timer = 0
      mut as int64: scc_count = 0

      #L Pilha S de vertices e Pilha B de fronteiras de caminho
      mut as list of int64: s_stk = [0, 0, 0, 0, 0, 0]
      mut as int64: s_top = 0
      mut as list of int64: b_stk = [0, 0, 0, 0, 0, 0]
      mut as int64: b_top = 0

      #L Pilha de recursao para DFS
      mut as list of int64: cs = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      mut as list of int64: ce = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
      mut as int64: cs_top = 0

      mut as int64: start_v = 1
      mut as int64: u = 0
      mut as int64: v = 0
      mut as int64: i = 1

      infinite (start_v <= num_v) {
            route {
                  pre[start_v] == 0 ==> {
                        cs_top = 1
                        cs[cs_top] = start_v
                        ce[cs_top] = 1

                        c_timer = c_timer + 1
                        pre[start_v] = c_timer
                        s_top = s_top + 1
                        s_stk[s_top] = start_v
                        b_top = b_top + 1
                        b_stk[b_top] = start_v

                        infinite (cs_top > 0) {
                              u = cs[cs_top]
                              mut as int64: edge_k = ce[cs_top]
                              mut as bool: advanced = false

                              infinite (edge_k <= num_v and not advanced) {
                                    route {
                                          adj[(u - 1) * num_v + edge_k] == 1 ==> {
                                                v = edge_k
                                                route {
                                                      pre[v] == 0 ==> {
                                                            ce[cs_top] = edge_k + 1
                                                            cs_top = cs_top + 1
                                                            cs[cs_top] = v
                                                            ce[cs_top] = 1

                                                            c_timer = c_timer + 1
                                                            pre[v] = c_timer
                                                            s_top = s_top + 1
                                                            s_stk[s_top] = v
                                                            b_top = b_top + 1
                                                            b_stk[b_top] = v
                                                            advanced = true
                                                      }
                                                      scc_id[v] == 0 ==> {
                                                            #L Contrai ciclo na pilha B
                                                            infinite (b_top > 0 and pre[b_stk[b_top]] > pre[v]) {
                                                                  b_top = b_top - 1
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
                                          #L Se u esta no topo de B, ele e raiz da sua SCC
                                          route {
                                                (b_top > 0) and (b_stk[b_top] == u) ==> {
                                                      b_top = b_top - 1
                                                      scc_count = scc_count + 1
                                                      mut as int64: popped = 0
                                                      mut as bool: done = false
                                                      infinite (not done) {
                                                            popped = s_stk[s_top]
                                                            s_top = s_top - 1
                                                            scc_id[popped] = scc_count
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

      println("2. Total de SCCs via Gabow: " + scc_count)
      i = 1
      infinite (i <= num_v) {
            println("   Vertice " + i + " -> SCC #" + scc_id[i])
            i = i + 1
      }

      println("Gabow SCC concluido com sucesso.")
}
