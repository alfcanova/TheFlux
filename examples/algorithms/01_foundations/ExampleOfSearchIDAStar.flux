#L ============================================================================
#L Algoritmo: IDA* (Iterative Deepening A* em Grid 2D)
#L Dominio: 01_foundations / Categoria: 2. Busca
#L Complexidade: O(b^d) tempo | O(d) espaco linear de memoria
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSearchIDAStar) {
      println("==================================================")
      println("  SciAlgo: IDA* (Iterative Deepening A* 2D Grid)")
      println("==================================================")

      #L Grid 4x4: 0 = livre, 1 = obstaculo
      #L Obstaculos em (2,2) e (3,2)
      mut as list of list of int64: grid = [
            [0, 0, 0, 0],
            [0, 1, 0, 0],
            [0, 1, 0, 0],
            [0, 0, 0, 0]
      ]

      mut as int64: start_r = 1
      mut as int64: start_c = 1
      mut as int64: goal_r = 4
      mut as int64: goal_c = 4

      println("1. Origem: (1,1) | Destino: (4,4) | Dimensoes: 4x4")

      #L Heuristica de Manhattan inicial: |4 - 1| + |4 - 1| = 6
      mut as int64: threshold = (goal_r - start_r) + (goal_c - start_c)
      mut as bool: reached = false
      mut as int64: optimal_steps = 0
      mut as int64: iters = 0

      #L Deslocamentos 4-vizinhanca: baixo, direita, cima, esquerda
      mut as list of int64: dr = [1, 0, -1, 0]
      mut as list of int64: dc = [0, 1, 0, -1]

      infinite (not reached and threshold <= 12) {
            iters = iters + 1
            mut as int64: min_exceeded = 9999

            #L Pilhas para busca em profundidade: [r, c, g]
            mut as list of int64: st_r = [start_r]
            mut as list of int64: st_c = [start_c]
            mut as list of int64: st_g = [0]

            infinite (listLength(st_r) > 0 and not reached) {
                  mut as int64: top = listLength(st_r)
                  mut as int64: cr = st_r[top]
                  mut as int64: cc = st_c[top]
                  mut as int64: cg = st_g[top]

                  #L Desempilha
                  mut as list of int64: n_r = []
                  mut as list of int64: n_c = []
                  mut as list of int64: n_g = []
                  mut as int64: idx = 1
                  infinite (idx < top) {
                        n_r = listPushBack(n_r, st_r[idx])
                        n_c = listPushBack(n_c, st_c[idx])
                        n_g = listPushBack(n_g, st_g[idx])
                        idx = idx + 1
                  }
                  st_r = n_r
                  st_c = n_c
                  st_g = n_g

                  #L Heuristica Manhattan |4 - cr| + |4 - cc|
                  mut as int64: dist_r = goal_r - cr
                  route { dist_r < 0 ==> { dist_r = dist_r * -1 } }
                  mut as int64: dist_c = goal_c - cc
                  route { dist_c < 0 ==> { dist_c = dist_c * -1 } }
                  mut as int64: h = dist_r + dist_c
                  mut as int64: f = cg + h

                  route {
                        f > threshold ==> {
                              route {
                                    f < min_exceeded ==> {
                                          min_exceeded = f
                                    }
                              }
                        }
                        cr == goal_r and cc == goal_c ==> {
                              reached = true
                              optimal_steps = cg
                              break
                        }
                        _ ==> {
                              #L Expande vizinhos validos
                              mut as int64: di = 1
                              infinite (di <= 4) {
                                    mut as int64: nr = cr + dr[di]
                                    mut as int64: nc = cc + dc[di]
                                    route {
                                          nr >= 1 and nr <= 4 and nc >= 1 and nc <= 4 ==> {
                                                route {
                                                      grid[nr][nc] == 0 ==> {
                                                            st_r = listPushBack(st_r, nr)
                                                            st_c = listPushBack(st_c, nc)
                                                            st_g = listPushBack(st_g, cg + 1)
                                                      }
                                                }
                                          }
                                    }
                                    di = di + 1
                              }
                        }
                  }
            }

            println("  Iteracao " + iters + " | Limiar f: " + threshold)
            route {
                  not reached ==> {
                        threshold = min_exceeded
                  }
            }
      }

      println("2. Objetivo alcancado no grid: " + reached)
      println("3. Passos minimos no caminho: " + optimal_steps)
      println("4. Iteracoes de threshold: " + iters)
      println("5. Validacao: " + (reached and optimal_steps == 6))
      println("==================================================")
}
