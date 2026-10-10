#L ============================================================================
#L Algoritmo: Hopcroft-Karp (Emparelhamento Bipartido Maximo em O(E * sqrt(V)))
#L Dominio: 03_graphs / Categoria: Fluxo, corte e matching
#L Complexidade: O(E * sqrt(V)) tempo | O(V) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosFluxoCorteHopcroftKarp) {
      println("==================================================")
      println("  SciAlgo: Hopcroft-Karp (Fast Bipartite Matching)")
      println("==================================================")

      mut as int64: n_l = 4
      mut as int64: n_r = 4

      #L Matriz de adjacencia bipartida (4x4)
      #L L1: R1, R2
      #L L2: R1, R3
      #L L3: R2, R4
      #L L4: R3, R4
      mut as list of int64: adj = [
            1, 1, 0, 0,
            1, 0, 1, 0,
            0, 1, 0, 1,
            0, 0, 1, 1
      ]

      println("1. Grafo Bipartido:")
      println("   L = {1, 2, 3, 4}, R = {1, 2, 3, 4}")
      println("   Arestas: L1->(R1, R2), L2->(R1, R3), L3->(R2, R4), L4->(R3, R4)")

      mut as list of int64: pair_l = [0, 0, 0, 0]
      mut as list of int64: pair_r = [0, 0, 0, 0]
      mut as list of int64: dist = [0, 0, 0, 0]

      mut as int64: matching = 0
      mut as bool: has_augmenting_phase = true

      #L Fases do algoritmo Hopcroft-Karp
      infinite (has_augmenting_phase) {
            #L PASSO 1: BFS para construir niveis e encontrar menor distancia ate vertice livre
            mut as list of int64: queue = [0, 0, 0, 0, 0]
            mut as int64: q_head = 1
            mut as int64: q_tail = 1
            mut as int64: inf_dist = 999999
            mut as int64: dist_nil = inf_dist

            mut as int64: u = 1
            infinite (u <= n_l) {
                  route {
                        pair_l[u] == 0 ==> {
                              dist[u] = 0
                              queue[q_tail] = u
                              q_tail = q_tail + 1
                        }
                        _ ==> {
                              dist[u] = inf_dist
                        }
                  }
                  u = u + 1
            }

            infinite (q_head < q_tail) {
                  mut as int64: curr_u = queue[q_head]
                  q_head = q_head + 1

                  route {
                        dist[curr_u] < dist_nil ==> {
                              mut as int64: v = 1
                              infinite (v <= n_r) {
                                    mut as int64: edge = adj[(curr_u - 1) * n_r + v]
                                    route {
                                          edge == 1 ==> {
                                                mut as int64: matched_u = pair_r[v]
                                                route {
                                                      matched_u == 0 ==> {
                                                            dist_nil = dist[curr_u] + 1
                                                      }
                                                      _ ==> {
                                                            route {
                                                                  dist[matched_u] == inf_dist ==> {
                                                                        dist[matched_u] = dist[curr_u] + 1
                                                                        queue[q_tail] = matched_u
                                                                        q_tail = q_tail + 1
                                                                  }
                                                                  _ ==> {}
                                                            }
                                                      }
                                                }
                                          }
                                          _ ==> {}
                                    }
                                    v = v + 1
                              }
                        }
                        _ ==> {}
                  }
            }

            route {
                  dist_nil == inf_dist ==> {
                        has_augmenting_phase = false
                  }
                  _ ==> {
                        #L PASSO 2: DFS para encontrar caminhos aumentantes disjuntos no grafo em camadas
                        u = 1
                        infinite (u <= n_l) {
                              route {
                                    pair_l[u] == 0 ==> {
                                          #L Busca caminho aumentante a partir de u usando busca em camadas
                                          mut as list of bool: visited_r = [false, false, false, false]
                                          mut as list of int64: from_l = [0, 0, 0, 0]
                                          mut as list of int64: dfs_q = [0, 0, 0, 0]
                                          mut as int64: dh = 1
                                          mut as int64: dt = 1

                                          dfs_q[dt] = u
                                          dt = dt + 1
                                          mut as int64: found_free = 0

                                          infinite (dh < dt and found_free == 0) {
                                                mut as int64: cu = dfs_q[dh]
                                                dh = dh + 1

                                                mut as int64: v = 1
                                                infinite (v <= n_r and found_free == 0) {
                                                      mut as int64: edge = adj[(cu - 1) * n_r + v]
                                                      route {
                                                            (edge == 1) and (not visited_r[v]) ==> {
                                                                  mut as int64: pu = pair_r[v]
                                                                  mut as bool: can_extend = false
                                                                  route {
                                                                        pu == 0 ==> {
                                                                              can_extend = true
                                                                        }
                                                                        _ ==> {
                                                                              route {
                                                                                    dist[pu] == dist[cu] + 1 ==> {
                                                                                          can_extend = true
                                                                                    }
                                                                                    _ ==> {}
                                                                              }
                                                                        }
                                                                  }

                                                                  route {
                                                                        can_extend ==> {
                                                                              visited_r[v] = true
                                                                              from_l[v] = cu
                                                                              route {
                                                                                    pu == 0 ==> {
                                                                                          found_free = v
                                                                                    }
                                                                                    _ ==> {
                                                                                          dfs_q[dt] = pu
                                                                                          dt = dt + 1
                                                                                    }
                                                                              }
                                                                        }
                                                                        _ ==> {}
                                                                  }
                                                            }
                                                            _ ==> {}
                                                      }
                                                      v = v + 1
                                                }
                                          }

                                          route {
                                                found_free > 0 ==> {
                                                      mut as int64: cur_v = found_free
                                                      infinite (cur_v != 0) {
                                                            mut as int64: lu = from_l[cur_v]
                                                            mut as int64: prev_rv = pair_l[lu]
                                                            pair_r[cur_v] = lu
                                                            pair_l[lu] = cur_v
                                                            cur_v = prev_rv
                                                      }
                                                      matching = matching + 1
                                                }
                                                _ ==> {}
                                          }
                                    }
                                    _ ==> {}
                              }
                              u = u + 1
                        }
                  }
            }
      }

      println("2. Tamanho do Emparelhamento Maximo (Hopcroft-Karp): " + matching)
      println("3. Conexoes:")
      mut as int64: k = 1
      infinite (k <= n_l) {
            println("   L" + k + " <-> R" + pair_l[k])
            k = k + 1
      }
      println("Hopcroft-Karp concluido com sucesso.")
}
