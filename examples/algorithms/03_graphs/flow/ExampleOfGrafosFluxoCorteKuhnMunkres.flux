#L ============================================================================
#L Algoritmo: Kuhn-Munkres (KM / Maximum Weight Bipartite Matching)
#L Dominio: 03_graphs / Categoria: Fluxo, corte e matching
#L Complexidade: O(N^3) tempo | O(N^2) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosFluxoCorteKuhnMunkres) {
      println("==================================================")
      println("  SciAlgo: Kuhn-Munkres (Dual Potentials KM)      ")
      println("==================================================")

      mut as int64: n = 3

      #L Matriz de pesos 3x3 (Max-Weight Bipartite Matching)
      #L L1: [3, 8, 5]
      #L L2: [4, 2, 7]
      #L L3: [6, 1, 9]
      mut as list of int64: weight = [
            3, 8, 5,
            4, 2, 7,
            6, 1, 9
      ]

      println("1. Matriz de Pesos Bipartida (3x3):")
      println("   L1: [3, 8, 5]")
      println("   L2: [4, 2, 7]")
      println("   L3: [6, 1, 9]")

      #L Inicializacao dos potenciais duais:
      #L u[i] = max_j weight[i, j], v[j] = 0
      mut as list of int64: u_pot = [0, 0, 0]
      mut as list of int64: v_pot = [0, 0, 0]

      mut as int64: i = 1
      infinite (i <= n) {
            mut as int64: max_w = -999999
            mut as int64: j = 1
            infinite (j <= n) {
                  mut as int64: w = weight[(i - 1) * n + j]
                  route {
                        w > max_w ==> {
                              max_w = w
                        }
                        _ ==> {}
                  }
                  j = j + 1
            }
            u_pot[i] = max_w
            i = i + 1
      }

      mut as list of int64: match_l = [0, 0, 0]
      mut as list of int64: match_r = [0, 0, 0]

      #L Emparelha cada vertice i de L
      i = 1
      infinite (i <= n) {
            mut as bool: augmented = false

            infinite (not augmented) {
                  #L Busca em largura na arvore alternante do subgrafo de igualdade
                  mut as list of bool: s_visited = [false, false, false]
                  mut as list of bool: t_visited = [false, false, false]
                  mut as list of int64: from_l = [0, 0, 0]

                  mut as list of int64: queue = [0, 0, 0]
                  mut as int64: q_head = 1
                  mut as int64: q_tail = 1

                  queue[q_tail] = i
                  q_tail = q_tail + 1
                  s_visited[i] = true

                  mut as int64: free_r = 0

                  infinite (q_head < q_tail and free_r == 0) {
                        mut as int64: curr_u = queue[q_head]
                        q_head = q_head + 1

                        mut as int64: j = 1
                        infinite (j <= n and free_r == 0) {
                              mut as int64: w = weight[(curr_u - 1) * n + j]
                              #L Condicao de aresta de igualdade: u_pot[curr_u] + v_pot[j] == w
                              route {
                                    (not t_visited[j]) and (u_pot[curr_u] + v_pot[j] == w) ==> {
                                          t_visited[j] = true
                                          from_l[j] = curr_u

                                          route {
                                                match_r[j] == 0 ==> {
                                                      free_r = j
                                                }
                                                _ ==> {
                                                      mut as int64: next_u = match_r[j]
                                                      s_visited[next_u] = true
                                                      queue[q_tail] = next_u
                                                      q_tail = q_tail + 1
                                                }
                                          }
                                    }
                                    _ ==> {}
                              }
                              j = j + 1
                        }
                  }

                  route {
                        free_r > 0 ==> {
                              #L Encontrou caminho aumentante no subgrafo de igualdade
                              mut as int64: curr = free_r
                              infinite (curr != 0) {
                                    mut as int64: u = from_l[curr]
                                    mut as int64: prev_r = match_l[u]

                                    match_r[curr] = u
                                    match_l[u] = curr

                                    curr = prev_r
                              }
                              augmented = true
                        }
                        _ ==> {
                              #L Calcula folga delta = min_{u in S, v not in T} (u_pot[u] + v_pot[v] - weight[u, v])
                              mut as int64: delta = 999999
                              mut as int64: u_idx = 1
                              infinite (u_idx <= n) {
                                    route {
                                          s_visited[u_idx] ==> {
                                                mut as int64: v_idx = 1
                                                infinite (v_idx <= n) {
                                                      route {
                                                            not t_visited[v_idx] ==> {
                                                                  mut as int64: slack = u_pot[u_idx] + v_pot[v_idx] - weight[(u_idx - 1) * n + v_idx]
                                                                  route {
                                                                        slack < delta ==> {
                                                                              delta = slack
                                                                        }
                                                                        _ ==> {}
                                                                  }
                                                            }
                                                            _ ==> {}
                                                      }
                                                      v_idx = v_idx + 1
                                                }
                                          }
                                          _ ==> {}
                                    }
                                    u_idx = u_idx + 1
                              }

                              #L Atualiza potenciais
                              mut as int64: k = 1
                              infinite (k <= n) {
                                    route {
                                          s_visited[k] ==> {
                                                u_pot[k] = u_pot[k] - delta
                                          }
                                          _ ==> {}
                                    }
                                    route {
                                          t_visited[k] ==> {
                                                v_pot[k] = v_pot[k] + delta
                                          }
                                          _ ==> {}
                                    }
                                    k = k + 1
                              }
                        }
                  }
            }

            i = i + 1
      }

      mut as int64: total_weight = 0
      println("2. Emparelhamento de Peso Maximo Encontrado:")
      i = 1
      infinite (i <= n) {
            mut as int64: j = match_l[i]
            mut as int64: w = weight[(i - 1) * n + j]
            total_weight = total_weight + w
            println("   L" + i + " <-> R" + j + " (peso " + w + ")")
            i = i + 1
      }

      println("3. Peso Maximo Total: " + total_weight)
      println("Kuhn-Munkres concluido com sucesso.")
}
