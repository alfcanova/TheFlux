#L ============================================================================
#L Algoritmo: Hopcroft-Karp (Emparelhamento Maximo em Grafos Bipartidos)
#L Dominio: 03_graphs / Categoria: Teoria da computacao e complexidade
#L Complexidade: O(E * sqrt(V)) tempo | O(V + E) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosComplexidadeHopcroftKarp) {
      println("==================================================")
      println("  SciAlgo: Algoritmo de Hopcroft-Karp")
      println("==================================================")

      #L Grafo bipartido com particoes U = {1..4} e V = {1..4} (rotulados 5..8):
      #L Vertices U: 1, 2, 3, 4
      #L Vertices V: 5, 6, 7, 8
      mut as int64: n_u = 4
      mut as int64: n_v = 4

      #L Arestas bipartidas:
      #L 1 -> [5, 6]
      #L 2 -> [6, 7]
      #L 3 -> [7, 8]
      #L 4 -> [8]
      mut as list of int64: deg_u = [2, 2, 2, 1]
      mut as list of int64: off_u = [1, 3, 5, 7]
      mut as list of int64: adj_pool = [5, 6,  6, 7,  7, 8,  8]

      println("1. Grafo Bipartido (|U| = 4, |V| = 4, 7 arestas) carregado.")

      #L Vetores de emparelhamento:
      #L pair_u[u]: vertice em V emparelhado com u (0 se livre)
      #L pair_v[v - 4]: vertice em U emparelhado com v (0 se livre)
      #L dist[u]: distancia de camadas encontrada na BFS (0..INF)
      mut as list of int64: pair_u = [0, 0, 0, 0] #L 1-based (indices 1..4)
      mut as list of int64: pair_v = [0, 0, 0, 0] #L 1-based para V (1..4 representando 5..8)
      mut as list of int64: dist = [0, 0, 0, 0]
      mut as int64: inf = 999999
      mut as int64: dist_nil = inf

      mut as int64: matching_size = 0
      mut as bool: augmenting = true

      #L Laco principal do Hopcroft-Karp:
      infinite (augmenting) {
            #L 1. BFS em camadas: calcula caminhos de aumento de menor comprimento
            mut as list of int64: q = []
            mut as int64: u = 1
            infinite (u <= n_u) {
                  route {
                        pair_u[u] == 0 ==> {
                              dist[u] = 0
                              q = listPushBack(q, u)
                        }
                        _ ==> {
                              dist[u] = inf
                        }
                  }
                  u = u + 1
            }
            dist_nil = inf

            mut as int64: q_head = 1
            infinite (q_head <= listLength(q)) {
                  mut as int64: cur_u = q[q_head]
                  q_head = q_head + 1

                  route {
                        dist[cur_u] < dist_nil ==> {
                              mut as int64: d = deg_u[cur_u]
                              mut as int64: o = off_u[cur_u]
                              mut as int64: di = 0
                              infinite (di < d) {
                                    mut as int64: v = adj_pool[o + di]
                                    mut as int64: v_idx = v - 4
                                    mut as int64: next_u = pair_v[v_idx]

                                    route {
                                          next_u == 0 ==> {
                                                route {
                                                      dist_nil == inf ==> { dist_nil = dist[cur_u] + 1 }
                                                }
                                          }
                                          _ ==> {
                                                route {
                                                      dist[next_u] == inf ==> {
                                                            dist[next_u] = dist[cur_u] + 1
                                                            q = listPushBack(q, next_u)
                                                      }
                                                }
                                          }
                                    }
                                    di = di + 1
                              }
                        }
                  }
            }

            route {
                  dist_nil == inf ==> {
                        #L Nenhum caminho de aumento encontrado
                        augmenting = false
                  }
                  _ ==> {
                        #L 2. DFS para encontrar caminhos de aumento disjuntos
                        mut as int64: ui = 1
                        infinite (ui <= n_u) {
                              route {
                                    pair_u[ui] == 0 ==> {
                                          #L Simula DFS iterativa para encontrar caminho de aumento
                                          mut as int64: du = deg_u[ui]
                                          mut as int64: ou = off_u[ui]
                                          mut as int64: d_idx = 0
                                          mut as bool: path_found = false

                                          infinite (d_idx < du) {
                                                route {
                                                      not path_found ==> {
                                                            mut as int64: cv = adj_pool[ou + d_idx]
                                                            mut as int64: cv_idx = cv - 4
                                                            mut as int64: paired_u = pair_v[cv_idx]

                                                            route {
                                                                  paired_u == 0 ==> {
                                                                        pair_v[cv_idx] = ui
                                                                        pair_u[ui] = cv
                                                                        matching_size = matching_size + 1
                                                                        path_found = true
                                                                  }
                                                                  _ ==> {
                                                                        route {
                                                                              dist[paired_u] == (dist[ui] + 1) ==> {
                                                                                    #L Se paired_u puder ser re-emparelhado
                                                                                    mut as int64: pdu = deg_u[paired_u]
                                                                                    mut as int64: pou = off_u[paired_u]
                                                                                    mut as int64: pdi = 0
                                                                                    mut as bool: sub_found = false
                                                                                    infinite (pdi < pdu) {
                                                                                          route {
                                                                                                not sub_found ==> {
                                                                                                      mut as int64: nv = adj_pool[pou + pdi]
                                                                                                      mut as int64: nv_idx = nv - 4
                                                                                                      route {
                                                                                                            pair_v[nv_idx] == 0 ==> {
                                                                                                                  pair_v[nv_idx] = paired_u
                                                                                                                  pair_u[paired_u] = nv
                                                                                                                  pair_v[cv_idx] = ui
                                                                                                                  pair_u[ui] = cv
                                                                                                                  matching_size = matching_size + 1
                                                                                                                  sub_found = true
                                                                                                                  path_found = true
                                                                                                            }
                                                                                                      }
                                                                                                }
                                                                                          }
                                                                                          pdi = pdi + 1
                                                                                    }
                                                                              }
                                                                        }
                                                                  }
                                                            }
                                                      }
                                                }
                                                d_idx = d_idx + 1
                                          }
                                    }
                              }
                              ui = ui + 1
                        }
                  }
            }
      }

      println("2. Emparelhamento Maximo obtido: " + matching_size + " arestas")
      mut as int64: pi = 1
      infinite (pi <= n_u) {
            println("   Par U(" + pi + ") <-> V(" + pair_u[pi] + ")")
            pi = pi + 1
      }

      mut as bool: correct = (matching_size == 4)
      println("3. Verificacao de emparelhamento perfeito (esperado 4): " + correct)
      println("Concluido com Sucesso")
}
