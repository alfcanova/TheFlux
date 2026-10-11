#L ============================================================================
#L Algoritmo: Karger-Stein (Corte Minimo por Contracao Recursiva Rapida)
#L Dominio: 03_graphs / Categoria: Fluxo, corte e matching
#L Complexidade: O(V^2 * log^2 V) tempo | O(V^2) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosFluxoCorteKargerStein) {
      println("==================================================")
      println("  SciAlgo: Karger-Stein (Recursive Contraction)   ")
      println("==================================================")

      mut as int64: num_v = 6
      mut as int64: num_e = 8

      mut as list of int64: edge_u = [1, 2, 3, 4, 5, 6, 1, 2]
      mut as list of int64: edge_v = [2, 3, 1, 5, 6, 4, 4, 5]

      println("1. Grafo com " + num_v + " vertices e " + num_e + " arestas:")
      println("   Cluster A: {1, 2, 3}, Cluster B: {4, 5, 6}")
      println("   Pontes de ligacao: (1-4) e (2-5)")

      mut as int64: seed = 7654321
      mut as int64: global_min_cut = 999999
      mut as int64: num_phases = 5

      #L Executa fases da arvore de ramificacao de Karger-Stein
      mut as int64: phase = 1
      infinite (phase <= num_phases) {
            #L Nivel 1: Contrai ate t = 4 vertices (n / sqrt(2) approx)
            mut as list of int64: p_lvl1 = [1, 2, 3, 4, 5, 6]
            mut as int64: act_v = num_v

            infinite (act_v > 4) {
                  seed = (seed * 1103515245 + 12345) /r 2147483647
                  route {
                        seed < 0 ==> {
                              seed = 0 - seed
                        }
                        _ ==> {}
                  }

                  mut as int64: picked = 1 + (seed /r num_e)
                  mut as int64: u = edge_u[picked]
                  mut as int64: v = edge_v[picked]

                  mut as int64: ru = u
                  infinite (p_lvl1[ru] != ru) {
                        ru = p_lvl1[ru]
                  }

                  mut as int64: rv = v
                  infinite (p_lvl1[rv] != rv) {
                        rv = p_lvl1[rv]
                  }

                  route {
                        ru != rv ==> {
                              p_lvl1[ru] = rv
                              act_v = act_v - 1
                        }
                        _ ==> {}
                  }
            }

            #L Nivel 2: Ramifica em dois ramos independentes (Branch 1 e Branch 2)
            mut as int64: branch = 1
            infinite (branch <= 2) {
                  mut as list of int64: p_branch = [
                        p_lvl1[1], p_lvl1[2], p_lvl1[3],
                        p_lvl1[4], p_lvl1[5], p_lvl1[6]
                  ]
                  mut as int64: b_act = act_v

                  infinite (b_act > 2) {
                        seed = (seed * 1103515245 + 12345) /r 2147483647
                        route {
                              seed < 0 ==> {
                                    seed = 0 - seed
                              }
                              _ ==> {}
                        }

                        mut as int64: picked = 1 + (seed /r num_e)
                        mut as int64: u = edge_u[picked]
                        mut as int64: v = edge_v[picked]

                        mut as int64: ru = u
                        infinite (p_branch[ru] != ru) {
                              ru = p_branch[ru]
                        }

                        mut as int64: rv = v
                        infinite (p_branch[rv] != rv) {
                              rv = p_branch[rv]
                        }

                        route {
                              ru != rv ==> {
                                    p_branch[ru] = rv
                                    b_act = b_act - 1
                              }
                              _ ==> {}
                        }
                  }

                  #L Avalia o corte do ramo
                  mut as int64: cut_edges = 0
                  mut as int64: e = 1
                  infinite (e <= num_e) {
                        mut as int64: u = edge_u[e]
                        mut as int64: v = edge_v[e]

                        mut as int64: ru = u
                        infinite (p_branch[ru] != ru) {
                              ru = p_branch[ru]
                        }

                        mut as int64: rv = v
                        infinite (p_branch[rv] != rv) {
                              rv = p_branch[rv]
                        }

                        route {
                              ru != rv ==> {
                                    cut_edges = cut_edges + 1
                              }
                              _ ==> {}
                        }
                        e = e + 1
                  }

                  route {
                        cut_edges < global_min_cut ==> {
                              global_min_cut = cut_edges
                        }
                        _ ==> {}
                  }

                  branch = branch + 1
            }

            phase = phase + 1
      }

      println("2. Min-Cut obtido apos " + num_phases + " fases recursivas ramificadas: " + global_min_cut)
      println("Karger-Stein concluido com sucesso.")
}
