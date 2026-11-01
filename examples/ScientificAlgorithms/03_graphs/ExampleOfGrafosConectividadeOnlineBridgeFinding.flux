#L ============================================================================
#L Algoritmo: Online Bridge Finding (Manutencao Dinamica de 2-ECC e Pontes)
#L Dominio: 03_graphs / Categoria: Conectividade, travessia e representacao
#L Complexidade: O(E log V) tempo amortizado | O(V) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosConectividadeOnlineBridgeFinding) {
      println("==================================================")
      println("  SciAlgo: Online Bridge Finding (Dynamic 2-ECC)  ")
      println("==================================================")

      mut as int64: num_v = 6
      mut as list of int64: edges_u = [1, 2, 3, 3, 4, 5, 6]
      mut as list of int64: edges_v = [2, 3, 1, 4, 5, 6, 4]
      mut as int64: num_e = 7

      mut as list of int64: dsu_2ecc = [1, 2, 3, 4, 5, 6]
      mut as list of int64: dsu_cc = [1, 2, 3, 4, 5, 6]
      mut as list of int64: par = [0, 0, 0, 0, 0, 0]
      mut as list of int64: mark = [0, 0, 0, 0, 0, 0]
      mut as int64: iter_tag = 0
      mut as int64: bridges_count = 0

      mut as int64: e = 1
      infinite (e <= num_e) {
            mut as int64: raw_u = edges_u[e]
            mut as int64: raw_v = edges_v[e]

            mut as int64: cu = raw_u
            infinite (dsu_2ecc[cu] != cu) {
                  cu = dsu_2ecc[cu]
            }

            mut as int64: cv = raw_v
            infinite (dsu_2ecc[cv] != cv) {
                  cv = dsu_2ecc[cv]
            }

            route {
                  cu == cv ==> {
                        println("   Aresta (" + raw_u + " - " + raw_v + "): Pontes ativas = " + bridges_count)
                  }
                  _ ==> {
                        mut as int64: root_u = cu
                        infinite (dsu_cc[root_u] != root_u) {
                              root_u = dsu_cc[root_u]
                        }

                        mut as int64: root_v = cv
                        infinite (dsu_cc[root_v] != root_v) {
                              root_v = dsu_cc[root_v]
                        }

                        route {
                              root_u != root_v ==> {
                                    mut as int64: curr = cu
                                    mut as int64: prev = 0
                                    infinite (curr != 0) {
                                          mut as int64: temp = curr
                                          infinite (dsu_2ecc[temp] != temp) {
                                                temp = dsu_2ecc[temp]
                                          }
                                          curr = temp

                                          mut as int64: nxt = par[curr]
                                          route {
                                                nxt != 0 ==> {
                                                      mut as int64: temp2 = nxt
                                                      infinite (dsu_2ecc[temp2] != temp2) {
                                                            temp2 = dsu_2ecc[temp2]
                                                      }
                                                      nxt = temp2
                                                }
                                                _ ==> {}
                                          }

                                          par[curr] = prev
                                          prev = curr
                                          curr = nxt
                                    }

                                    par[cu] = cv
                                    dsu_cc[root_u] = root_v
                                    bridges_count = bridges_count + 1
                                    println("   Aresta (" + raw_u + " - " + raw_v + "): Pontes ativas = " + bridges_count)
                              }
                              _ ==> {
                                    iter_tag = iter_tag + 1
                                    mut as int64: walk_u = cu
                                    mut as int64: walk_v = cv
                                    mut as int64: lca = 0

                                    infinite (lca == 0) {
                                          route {
                                                walk_u != 0 ==> {
                                                      mut as int64: t_u = walk_u
                                                      infinite (dsu_2ecc[t_u] != t_u) {
                                                            t_u = dsu_2ecc[t_u]
                                                      }
                                                      walk_u = t_u

                                                      route {
                                                            mark[walk_u] == iter_tag ==> {
                                                                  lca = walk_u
                                                            }
                                                            _ ==> {
                                                                  mark[walk_u] = iter_tag
                                                                  walk_u = par[walk_u]
                                                            }
                                                      }
                                                }
                                                _ ==> {}
                                          }

                                          route {
                                                lca == 0 and walk_v != 0 ==> {
                                                      mut as int64: t_v = walk_v
                                                      infinite (dsu_2ecc[t_v] != t_v) {
                                                            t_v = dsu_2ecc[t_v]
                                                      }
                                                      walk_v = t_v

                                                      route {
                                                            mark[walk_v] == iter_tag ==> {
                                                                  lca = walk_v
                                                            }
                                                            _ ==> {
                                                                  mark[walk_v] = iter_tag
                                                                  walk_v = par[walk_v]
                                                            }
                                                      }
                                                }
                                                _ ==> {}
                                          }
                                    }

                                    mut as int64: c_path = cu
                                    infinite (c_path != lca) {
                                          mut as int64: tp = c_path
                                          infinite (dsu_2ecc[tp] != tp) {
                                                tp = dsu_2ecc[tp]
                                          }
                                          c_path = tp
                                          route {
                                                c_path == lca ==> {}
                                                _ ==> {
                                                      mut as int64: np = par[c_path]
                                                      route {
                                                            np != 0 ==> {
                                                                  mut as int64: tp2 = np
                                                                  infinite (dsu_2ecc[tp2] != tp2) {
                                                                        tp2 = dsu_2ecc[tp2]
                                                                  }
                                                                  np = tp2
                                                            }
                                                            _ ==> {}
                                                      }
                                                      dsu_2ecc[c_path] = lca
                                                      bridges_count = bridges_count - 1
                                                      c_path = np
                                                }
                                          }
                                    }

                                    c_path = cv
                                    infinite (c_path != lca) {
                                          mut as int64: tp = c_path
                                          infinite (dsu_2ecc[tp] != tp) {
                                                tp = dsu_2ecc[tp]
                                          }
                                          c_path = tp
                                          route {
                                                c_path == lca ==> {}
                                                _ ==> {
                                                      mut as int64: np = par[c_path]
                                                      route {
                                                            np != 0 ==> {
                                                                  mut as int64: tp2 = np
                                                                  infinite (dsu_2ecc[tp2] != tp2) {
                                                                        tp2 = dsu_2ecc[tp2]
                                                                  }
                                                                  np = tp2
                                                            }
                                                            _ ==> {}
                                                      }
                                                      dsu_2ecc[c_path] = lca
                                                      bridges_count = bridges_count - 1
                                                      c_path = np
                                                }
                                          }
                                    }

                                    println("   Aresta (" + raw_u + " - " + raw_v + "): Pontes ativas = " + bridges_count)
                              }
                        }
                  }
            }
            e = e + 1
      }
}
