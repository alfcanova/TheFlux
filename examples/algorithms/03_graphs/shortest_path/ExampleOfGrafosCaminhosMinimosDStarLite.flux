#L ============================================================================
#L Algoritmo: D* Lite (Incremental Heuristic Search baseado em LPA*)
#L Dominio: 03_graphs / Categoria: Caminhos minimos
#L Complexidade: O(V log V) por reparo incremental | O(V) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosCaminhosMinimosDStarLite) {
      println("==================================================")
      println("  SciAlgo: D* Lite (Incremental Replanning)       ")
      println("==================================================")

      mut as int64: num_v = 5
      mut as int64: start_node = 1
      mut as int64: goal_node = 5

      #L Matriz de pesos inicial
      #L 1->2 (2), 1->3 (5)
      #L 2->4 (1), 2->3 (2)
      #L 3->5 (6)
      #L 4->5 (3)
      mut as list of int64: cost = [
            -1,  2,  5, -1, -1,
            -1, -1,  2,  1, -1,
            -1, -1, -1, -1,  6,
            -1, -1, -1, -1,  3,
            -1, -1, -1, -1, -1
      ]

      println("1. Grafo de Entrada para D* Lite (Inicio: 1, Destino: 5)")

      #L D* Lite mantem dois valores de distancia para cada no:
      #L g[s] e rhs[s]. Um no e consistente quando g[s] == rhs[s].
      #L No objetivo: rhs[goal] = 0
      mut as list of int64: g_val = [999999, 999999, 999999, 999999, 999999]
      mut as list of int64: rhs_val = [999999, 999999, 999999, 999999, 0]
      mut as list of bool: in_queue = [false, false, false, false, true]

      #L Funcao de reparo de consistencia local (ComputeShortestPath)
      mut as bool: consistent = false
      mut as int64: u = 0
      mut as int64: min_k = 0
      mut as int64: i = 1
      mut as int64: p = 1
      mut as int64: succ = 1

      infinite (not consistent) {
            #L Encontra no inconsistente com menor chave min(g, rhs)
            u = 0
            min_k = 999999
            i = 1
            infinite (i <= num_v) {
                  route {
                        in_queue[i] ==> {
                              mut as int64: k = g_val[i]
                              route {
                                    rhs_val[i] < k ==> {
                                          k = rhs_val[i]
                                    }
                                    _ ==> {}
                              }
                              route {
                                    k < min_k ==> {
                                          min_k = k
                                          u = i
                                    }
                                    _ ==> {}
                              }
                        }
                        _ ==> {}
                  }
                  i = i + 1
            }

            route {
                  (u == 0) or ((g_val[start_node] == rhs_val[start_node]) and (min_k >= rhs_val[start_node])) ==> {
                        consistent = true
                  }
                  _ ==> {
                        in_queue[u] = false

                        route {
                              g_val[u] > rhs_val[u] ==> {
                                    #L Caso overconsistent: g[u] = rhs[u]
                                    g_val[u] = rhs_val[u]

                                    #L Atualiza predecessores p -> u
                                    p = 1
                                    infinite (p <= num_v) {
                                          mut as int64: c_pu = cost[(p - 1) * num_v + u]
                                          route {
                                                (c_pu >= 0) and (p != goal_node) ==> {
                                                      route {
                                                            g_val[u] + c_pu < rhs_val[p] ==> {
                                                                  rhs_val[p] = g_val[u] + c_pu
                                                                  route {
                                                                        g_val[p] != rhs_val[p] ==> {
                                                                              in_queue[p] = true
                                                                        }
                                                                        _ ==> {}
                                                                  }
                                                            }
                                                            _ ==> {}
                                                      }
                                                }
                                                _ ==> {}
                                          }
                                          p = p + 1
                                    }
                              }
                              _ ==> {
                                    #L Caso underconsistent: g[u] = inf
                                    g_val[u] = 999999
                                    route {
                                          g_val[u] != rhs_val[u] ==> {
                                                in_queue[u] = true
                                          }
                                          _ ==> {}
                                    }
                              }
                        }
                  }
            }
      }

      println("2. Planejamento Inicial D* Lite:")
      println("   Custo minimo inicial ate o destino: " + g_val[start_node])

      #L MUDANCA DINAMICA NO CENARIO:
      println("3. Evento Dinamico: Custo da aresta (2->4) aumenta de 1 para 25.")
      cost[(2 - 1) * num_v + 4] = 25

      #L Recomputa rhs do no afetado (no 2)
      rhs_val[2] = 999999
      succ = 1
      infinite (succ <= num_v) {
            mut as int64: c_2s = cost[(2 - 1) * num_v + succ]
            route {
                  c_2s >= 0 ==> {
                        route {
                              g_val[succ] + c_2s < rhs_val[2] ==> {
                                    rhs_val[2] = g_val[succ] + c_2s
                              }
                              _ ==> {}
                        }
                  }
                  _ ==> {}
            }
            succ = succ + 1
      }
      in_queue[2] = true

      #L Repara consistencia incrementalmente
      consistent = false
      infinite (not consistent) {
            u = 0
            min_k = 999999
            i = 1
            infinite (i <= num_v) {
                  route {
                        in_queue[i] ==> {
                              mut as int64: k = g_val[i]
                              route {
                                    rhs_val[i] < k ==> {
                                          k = rhs_val[i]
                                    }
                                    _ ==> {}
                              }
                              route {
                                    k < min_k ==> {
                                          min_k = k
                                          u = i
                                    }
                                    _ ==> {}
                              }
                        }
                        _ ==> {}
                  }
                  i = i + 1
            }

            route {
                  (u == 0) or ((g_val[start_node] == rhs_val[start_node]) and (min_k >= rhs_val[start_node])) ==> {
                        consistent = true
                  }
                  _ ==> {
                        in_queue[u] = false
                        g_val[u] = rhs_val[u]

                        #L Propaga para predecessores
                        p = 1
                        infinite (p <= num_v) {
                              mut as int64: c_pu = cost[(p - 1) * num_v + u]
                              route {
                                    (c_pu >= 0) and (p != goal_node) ==> {
                                          #L Recalcula rhs[p]
                                          mut as int64: best_rhs = 999999
                                          mut as int64: s_idx = 1
                                          infinite (s_idx <= num_v) {
                                                mut as int64: c_ps = cost[(p - 1) * num_v + s_idx]
                                                route {
                                                      c_ps >= 0 ==> {
                                                            route {
                                                                  g_val[s_idx] + c_ps < best_rhs ==> {
                                                                        best_rhs = g_val[s_idx] + c_ps
                                                                  }
                                                                  _ ==> {}
                                                            }
                                                      }
                                                      _ ==> {}
                                                }
                                                s_idx = s_idx + 1
                                          }
                                          rhs_val[p] = best_rhs
                                          route {
                                                g_val[p] != rhs_val[p] ==> {
                                                      in_queue[p] = true
                                                }
                                                _ ==> {}
                                          }
                                    }
                                    _ ==> {}
                              }
                              p = p + 1
                        }
                  }
            }
      }

      println("4. Replanejamento Concluido pelo D* Lite:")
      println("   Novo custo minimo recalculado de 1 ate 5: " + g_val[start_node])
      println("D* Lite concluido com sucesso.")
}
