#L ============================================================================
#L Algoritmo: Christofides 1.5-Aproximação para TSP Métrico
#L Domínio: 03_graphs / Categoria: Problemas de Roteamento e TSP
#L Complexidade: O(V^3)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

function (absVal) (as int64: x) as int64 {
      mut as int64: res = x
      route {
            x < 0 ==> {
                  res = 0 - x
            }
      }
      emit(nice, res, "ok")
}

function (manhattanDist) (as int64: x1, as int64: y1, as int64: x2, as int64: y2) as int64 {
      mut as int64: dx = absVal(x1 - x2)
      mut as int64: dy = absVal(y1 - y2)
      mut as int64: total = dx + dy
      emit(nice, total, "ok")
}

program (ExampleOfGrafosComplexidadeChristofidesTSP) {
      println("==================================================")
      println("  SciAlgo: Christofides 1.5-Aproximacao TSP")
      println("==================================================")

      #L Coordenadas de 5 cidades em 2D
      mut as list of int64: px = [0, 1, 5, 6, 3]
      mut as list of int64: py = [0, 5, 1, 6, 3]
      mut as int64: n = 5

      #L Matriz de distancias 5x5 (1-based: idx = (r - 1) * n + c)
      mut as list of int64: dist_mat = []
      mut as int64: r = 1
      infinite (r <= n) {
            mut as int64: c = 1
            infinite (c <= n) {
                  mut as int64: d = manhattanDist(px[r], py[r], px[c], py[c])
                  dist_mat = listPushBack(dist_mat, d)
                  c = c + 1
            }
            r = r + 1
      }

      #L Passo 1: Prim MST comecando em 1
      mut as list of int64: in_mst = [0, 0, 0, 0, 0]
      mut as list of int64: key = [999999, 999999, 999999, 999999, 999999]
      mut as list of int64: parent = [0, 0, 0, 0, 0]
      key[1] = 0

      mut as int64: step = 1
      infinite (step <= n) {
            mut as int64: u = 0
            mut as int64: min_key = 999999
            mut as int64: i = 1
            infinite (i <= n) {
                  route {
                        in_mst[i] == 0 ==> {
                              route {
                                    key[i] < min_key ==> {
                                          min_key = key[i]
                                          u = i
                                    }
                              }
                        }
                  }
                  i = i + 1
            }

            in_mst[u] = 1

            mut as int64: v = 1
            infinite (v <= n) {
                  route {
                        in_mst[v] == 0 ==> {
                              mut as int64: mat_idx = (u - 1) * n + v
                              mut as int64: d_uv = dist_mat[mat_idx]
                              route {
                                    d_uv < key[v] ==> {
                                          key[v] = d_uv
                                          parent[v] = u
                                    }
                              }
                        }
                  }
                  v = v + 1
            }
            step = step + 1
      }

      #L Passo 2: Graus na MST e deteccao de vertices de grau impar
      mut as list of int64: deg = [0, 0, 0, 0, 0]
      mut as int64: edge_idx = 2
      infinite (edge_idx <= n) {
            mut as int64: p = parent[edge_idx]
            deg[p] = deg[p] + 1
            deg[edge_idx] = deg[edge_idx] + 1
            edge_idx = edge_idx + 1
      }

      mut as list of int64: odd = []
      mut as int64: vi = 1
      infinite (vi <= n) {
            mut as int64: is_odd = deg[vi] /r 2
            route {
                  is_odd == 1 ==> {
                        odd = listPushBack(odd, vi)
                  }
            }
            vi = vi + 1
      }

      println("1. Vertices de grau impar na MST: " + odd)

      #L Passo 3: Emparelhamento perfeito de peso minimo nos vertices impares
      mut as int64: num_odd = listLength(odd)
      mut as list of int64: match_u = []
      mut as list of int64: match_v = []

      route {
            num_odd == 2 ==> {
                  match_u = listPushBack(match_u, odd[1])
                  match_v = listPushBack(match_v, odd[2])
            }
            num_odd == 4 ==> {
                  mut as int64: o1 = odd[1]
                  mut as int64: o2 = odd[2]
                  mut as int64: o3 = odd[3]
                  mut as int64: o4 = odd[4]

                  mut as int64: d12 = dist_mat[(o1 - 1) * n + o2]
                  mut as int64: d34 = dist_mat[(o3 - 1) * n + o4]
                  mut as int64: cost1 = d12 + d34

                  mut as int64: d13 = dist_mat[(o1 - 1) * n + o3]
                  mut as int64: d24 = dist_mat[(o2 - 1) * n + o4]
                  mut as int64: cost2 = d13 + d24

                  mut as int64: d14 = dist_mat[(o1 - 1) * n + o4]
                  mut as int64: d23 = dist_mat[(o2 - 1) * n + o3]
                  mut as int64: cost3 = d14 + d23

                  route {
                        cost1 <= cost2 ==> {
                              route {
                                    cost1 <= cost3 ==> {
                                          match_u = listPushBack(match_u, o1)
                                          match_v = listPushBack(match_v, o2)
                                          match_u = listPushBack(match_u, o3)
                                          match_v = listPushBack(match_v, o4)
                                    }
                                    _ ==> {
                                          match_u = listPushBack(match_u, o1)
                                          match_v = listPushBack(match_v, o4)
                                          match_u = listPushBack(match_u, o2)
                                          match_v = listPushBack(match_v, o3)
                                    }
                              }
                        }
                        _ ==> {
                              route {
                                    cost2 <= cost3 ==> {
                                          match_u = listPushBack(match_u, o1)
                                          match_v = listPushBack(match_v, o3)
                                          match_u = listPushBack(match_u, o2)
                                          match_v = listPushBack(match_v, o4)
                                    }
                                    _ ==> {
                                          match_u = listPushBack(match_u, o1)
                                          match_v = listPushBack(match_v, o4)
                                          match_u = listPushBack(match_u, o2)
                                          match_v = listPushBack(match_v, o3)
                                    }
                              }
                        }
                  }
            }
      }

      #L Passo 4: Construir multigrafo Euleriano com matriz de adjacencia
      mut as list of int64: adj_mult = []
      mut as int64: total_cells = n * n
      mut as int64: ci = 1
      infinite (ci <= total_cells) {
            adj_mult = listPushBack(adj_mult, 0)
            ci = ci + 1
      }

      #L Adiciona arestas da MST
      mut as int64: mi = 2
      infinite (mi <= n) {
            mut as int64: mu = parent[mi]
            mut as int64: mv = mi
            mut as int64: idx_uv = (mu - 1) * n + mv
            mut as int64: idx_vu = (mv - 1) * n + mu
            adj_mult[idx_uv] = adj_mult[idx_uv] + 1
            adj_mult[idx_vu] = adj_mult[idx_vu] + 1
            mi = mi + 1
      }

      #L Adiciona arestas do emparelhamento
      mut as int64: m_len = listLength(match_u)
      mut as int64: ki = 1
      infinite (ki <= m_len) {
            mut as int64: ku = match_u[ki]
            mut as int64: kv = match_v[ki]
            mut as int64: idx_uv = (ku - 1) * n + kv
            mut as int64: idx_vu = (kv - 1) * n + ku
            adj_mult[idx_uv] = adj_mult[idx_uv] + 1
            adj_mult[idx_vu] = adj_mult[idx_vu] + 1
            ki = ki + 1
      }

      #L Passo 5: Algoritmo de Hierholzer para Circuito Euleriano
      mut as list of int64: stack = [1]
      mut as list of int64: circuit = []

      infinite (listLength(stack) > 0) {
            mut as int64: top_idx = listLength(stack)
            mut as int64: curr = stack[top_idx]

            mut as int64: nxt = 0
            mut as int64: cand = 1
            infinite (cand <= n) {
                  mut as int64: cell = (curr - 1) * n + cand
                  route {
                        adj_mult[cell] > 0 ==> {
                              nxt = cand
                              break
                        }
                  }
                  cand = cand + 1
            }

            route {
                  nxt > 0 ==> {
                        mut as int64: c1 = (curr - 1) * n + nxt
                        mut as int64: c2 = (nxt - 1) * n + curr
                        adj_mult[c1] = adj_mult[c1] - 1
                        adj_mult[c2] = adj_mult[c2] - 1
                        stack = listPushBack(stack, nxt)
                  }
                  _ ==> {
                        circuit = listPushBack(circuit, curr)
                        mut as list of int64: new_stack = []
                        mut as int64: si = 1
                        infinite (si < top_idx) {
                              new_stack = listPushBack(new_stack, stack[si])
                              si = si + 1
                        }
                        stack = new_stack
                  }
            }
      }

      #L Passo 6: Atalhos (Shortcutting) para Tour Hamiltoniano
      mut as list of int64: visited = [0, 0, 0, 0, 0]
      mut as list of int64: tour = []
      mut as int64: circ_len = listLength(circuit)
      mut as int64: ti = 1
      infinite (ti <= circ_len) {
            mut as int64: vtx = circuit[ti]
            route {
                  visited[vtx] == 0 ==> {
                        visited[vtx] = 1
                        tour = listPushBack(tour, vtx)
                  }
            }
            ti = ti + 1
      }
      #L Fecha o ciclo retornando a cidade inicial
      tour = listPushBack(tour, tour[1])

      #L Passo 7: Calcula custo total do tour aproximado
      mut as int64: tour_cost = 0
      mut as int64: tour_size = listLength(tour)
      mut as int64: k = 1
      infinite (k < tour_size) {
            mut as int64: a = tour[k]
            mut as int64: b = tour[k + 1]
            mut as int64: dist_ab = dist_mat[(a - 1) * n + b]
            tour_cost = tour_cost + dist_ab
            k = k + 1
      }

      println("2. Tour aproximado Christofides: " + tour)
      println("3. Comprimento total do tour: " + tour_cost)

      mut as bool: tour_valido = (tour_size == 6) and (tour[1] == tour[6]) and (tour_cost <= 48)
      println("4. Verificacao de corretude do tour aproximado: " + tour_valido)
      println("==================================================")
}
