#L ============================================================================
#L Algoritmo: Heuristic Search (Busca Heuristica Guiada / Best-First)
#L Dominio: 01_foundations / Categoria: 1. Fundamentos e paradigmas algoritmicos
#L Complexidade: O(V) guiada por h(n) | Espaco O(V)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfAlgorithmicFoundationsAndParadigmsHeuristicSearch) {
      println("==================================================")
      println("  SciAlgo: Heuristic Search (Busca Heuristica)")
      println("==================================================")

      #L Grid 5x5: Inicio em (1,1) e Meta em (5,5)
      #L Obstaculos (parede vertical): (2,3), (3,3), (4,3)
      #L Indice no grid linear 1-based: idx = ((r - 1) * 5) + c
      mut as int64: grid_rows = 5
      mut as int64: grid_cols = 5
      mut as int64: start_r = 1
      mut as int64: start_c = 1
      mut as int64: goal_r = 5
      mut as int64: goal_c = 5

      println("1. Grid 5x5: Origem (" + start_r + "," + start_c + ") -> Destino (" + goal_r + "," + goal_c + ")")
      println("   Obstaculos em (2,3), (3,3), (4,3)")

      #L Mapa de bloqueios (0=livre, 1=parede)
      mut as list of int64: walls = [
            0, 0, 0, 0, 0,
            0, 0, 1, 0, 0,
            0, 0, 1, 0, 0,
            0, 0, 1, 0, 0,
            0, 0, 0, 0, 0
      ]

      #L 1. Busca Cega (BFS Nao-Informada)
      mut as list of int64: bfs_q_r = [start_r]
      mut as list of int64: bfs_q_c = [start_c]
      mut as list of int64: bfs_visited = [
            1, 0, 0, 0, 0,
            0, 0, 0, 0, 0,
            0, 0, 0, 0, 0,
            0, 0, 0, 0, 0,
            0, 0, 0, 0, 0
      ]
      mut as int64: bfs_expansions = 0
      mut as bool: bfs_found = false

      infinite (listLength(bfs_q_r) > 0 and not bfs_found) {
            mut as int64: cr = bfs_q_r[1]
            mut as int64: cc = bfs_q_c[1]

            #L Remove frente da fila BFS
            mut as list of int64: nr = []
            mut as list of int64: nc = []
            mut as int64: ql = listLength(bfs_q_r)
            mut as int64: qi = 2
            infinite (qi <= ql) {
                  nr = listPushBack(nr, bfs_q_r[qi])
                  nc = listPushBack(nc, bfs_q_c[qi])
                  qi = qi + 1
            }
            bfs_q_r = nr
            bfs_q_c = nc

            bfs_expansions = bfs_expansions + 1
            route {
                  cr == goal_r and cc == goal_c ==> {
                        bfs_found = true
                  }
                  _ ==> {
                        #L Tenta 4 movimentos: baixo, direita, cima, esquerda
                        mut as list of int64: dr = [1, 0, -1, 0]
                        mut as list of int64: dc = [0, 1, 0, -1]
                        mut as int64: di = 1
                        infinite (di <= 4) {
                              mut as int64: adj_r = cr + dr[di]
                              mut as int64: adj_c = cc + dc[di]
                              route {
                                    adj_r >= 1 and adj_r <= 5 and adj_c >= 1 and adj_c <= 5 ==> {
                                          mut as int64: pos = ((adj_r - 1) * 5) + adj_c
                                          route {
                                                walls[pos] == 0 and bfs_visited[pos] == 0 ==> {
                                                      bfs_visited[pos] = 1
                                                      bfs_q_r = listPushBack(bfs_q_r, adj_r)
                                                      bfs_q_c = listPushBack(bfs_q_c, adj_c)
                                                }
                                                _ ==> {
                                                }
                                          }
                                    }
                                    _ ==> {
                                    }
                              }
                              di = di + 1
                        }
                  }
            }
      }

      #L 2. Busca Heuristica (Greedy Best-First guiada por Manhattan Distance)
      #L h(r, c) = |goal_r - r| + |goal_c - c|
      mut as list of int64: open_r = [start_r]
      mut as list of int64: open_c = [start_c]
      mut as list of int64: open_h = [(goal_r - start_r) + (goal_c - start_c)]
      mut as list of int64: heur_visited = [
            1, 0, 0, 0, 0,
            0, 0, 0, 0, 0,
            0, 0, 0, 0, 0,
            0, 0, 0, 0, 0,
            0, 0, 0, 0, 0
      ]
      mut as int64: heur_expansions = 0
      mut as bool: heur_found = false

      infinite (listLength(open_r) > 0 and not heur_found) {
            #L Escolhe no com menor valor heuristico h(n) na lista aberta
            mut as int64: best_idx = 1
            mut as int64: min_h = open_h[1]
            mut as int64: sz = listLength(open_h)
            mut as int64: k = 2
            infinite (k <= sz) {
                  route {
                        open_h[k] < min_h ==> {
                              min_h = open_h[k]
                              best_idx = k
                        }
                        _ ==> {
                        }
                  }
                  k = k + 1
            }

            mut as int64: cur_r = open_r[best_idx]
            mut as int64: cur_c = open_c[best_idx]

            #L Remove no selecionado
            mut as list of int64: no_r = []
            mut as list of int64: no_c = []
            mut as list of int64: no_h = []
            mut as int64: ri = 1
            infinite (ri <= sz) {
                  route {
                        ri != best_idx ==> {
                              no_r = listPushBack(no_r, open_r[ri])
                              no_c = listPushBack(no_c, open_c[ri])
                              no_h = listPushBack(no_h, open_h[ri])
                        }
                        _ ==> {
                        }
                  }
                  ri = ri + 1
            }
            open_r = no_r
            open_c = no_c
            open_h = no_h

            heur_expansions = heur_expansions + 1
            route {
                  cur_r == goal_r and cur_c == goal_c ==> {
                        heur_found = true
                  }
                  _ ==> {
                        mut as list of int64: d_r = [0, 1, 0, -1]
                        mut as list of int64: d_c = [1, 0, -1, 0]
                        mut as int64: mi = 1
                        infinite (mi <= 4) {
                              mut as int64: nr_val = cur_r + d_r[mi]
                              mut as int64: nc_val = cur_c + d_c[mi]
                              route {
                                    nr_val >= 1 and nr_val <= 5 and nc_val >= 1 and nc_val <= 5 ==> {
                                          mut as int64: p = ((nr_val - 1) * 5) + nc_val
                                          route {
                                                walls[p] == 0 and heur_visited[p] == 0 ==> {
                                                      heur_visited[p] = 1
                                                      mut as int64: diff_r = goal_r - nr_val
                                                      mut as int64: diff_c = goal_c - nc_val
                                                      route {
                                                            diff_r < 0 ==> {
                                                                  diff_r = 0 - diff_r
                                                            }
                                                            _ ==> {
                                                            }
                                                      }
                                                      route {
                                                            diff_c < 0 ==> {
                                                                  diff_c = 0 - diff_c
                                                            }
                                                            _ ==> {
                                                            }
                                                      }
                                                      mut as int64: h_val = diff_r + diff_c
                                                      open_r = listPushBack(open_r, nr_val)
                                                      open_c = listPushBack(open_c, nc_val)
                                                      open_h = listPushBack(open_h, h_val)
                                                }
                                                _ ==> {
                                                }
                                          }
                                    }
                                    _ ==> {
                                    }
                              }
                              mi = mi + 1
                        }
                  }
            }
      }

      println("2. Nos expandidos pela Busca Cega (BFS): " + bfs_expansions)
      println("3. Nos expandidos pela Busca Heuristica (h(n)): " + heur_expansions)
      route {
            heur_expansions <= bfs_expansions ==> {
                  println("4. Eficiencia: A heuristica reduziu/otimizou a exploracao de nos (OK)")
            }
            _ ==> {
            }
      }
      println("Concluido com Sucesso")
}
