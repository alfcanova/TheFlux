#L ============================================================================
#L Algoritmo: Lee Algorithm (Roteamento de Labirinto / Expansao de Onda)
#L Dominio: 03_graphs / Categoria: Caminhos minimos
#L Complexidade: O(M * N) tempo | O(M * N) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosCaminhosMinimosLeeAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Lee Algorithm (Maze Routing / Wavefront)")
      println("==================================================")

      #L Grade 5x5: 0 = celula livre, -1 = obstaculo
      #L Origem em (1, 1), Destino em (5, 5)
      mut as int64: rows = 5
      mut as int64: cols = 5
      mut as int64: total_cells = 25

      mut as list of int64: grid = [
            0,  0,  0,  0,  0,
            0, -1, -1, -1,  0,
            0,  0,  0, -1,  0,
            -1, -1,  0, -1,  0,
            0,  0,  0,  0,  0
      ]

      println("1. Grade 5x5 com Obstaculos (Inicio: [1,1], Fim: [5,5])")

      #L Fila para expansao de onda (Wavefront BFS)
      mut as list of int64: q_row = [
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      ]
      mut as list of int64: q_col = [
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      ]
      mut as int64: q_head = 1
      mut as int64: q_tail = 1

      #L Inicializa onda na origem com valor 1
      grid[(1 - 1) * cols + 1] = 1
      q_row[q_tail] = 1
      q_col[q_tail] = 1
      q_tail = q_tail + 1

      mut as bool: reached_target = false
      mut as int64: cr = 0
      mut as int64: cc = 0
      mut as int64: dist_val = 0
      mut as int64: d = 1
      mut as int64: nr = 0
      mut as int64: nc = 0

      #L FASE 1: Expansao da onda (Wave Expansion)
      infinite (q_head < q_tail and not reached_target) {
            cr = q_row[q_head]
            cc = q_col[q_head]
            q_head = q_head + 1

            dist_val = grid[(cr - 1) * cols + cc]

            route {
                  (cr == 5) and (cc == 5) ==> {
                        reached_target = true
                  }
                  _ ==> {
                        #L Testa 4 vizinhos (Cima, Baixo, Esquerda, Direita)
                        d = 1
                        infinite (d <= 4) {
                              nr = cr
                              nc = cc
                              route {
                                    d == 1 ==> { nr = cr - 1 } #L Cima
                                    d == 2 ==> { nr = cr + 1 } #L Baixo
                                    d == 3 ==> { nc = cc - 1 } #L Esquerda
                                    _      ==> { nc = cc + 1 } #L Direita
                              }

                              route {
                                    (nr >= 1) and (nr <= rows) and (nc >= 1) and (nc <= cols) ==> {
                                          mut as int64: cell_idx = (nr - 1) * cols + nc
                                          route {
                                                grid[cell_idx] == 0 ==> {
                                                      grid[cell_idx] = dist_val + 1
                                                      q_row[q_tail] = nr
                                                      q_col[q_tail] = nc
                                                      q_tail = q_tail + 1
                                                }
                                                _ ==> {}
                                          }
                                    }
                                    _ ==> {}
                              }
                              d = d + 1
                        }
                  }
            }
      }

      mut as int64: path_length = grid[(5 - 1) * cols + 5] - 1
      println("2. Expansao de Onda Concluida. Distancia Minima: " + path_length + " passos.")

      #L FASE 2: Rastreamento do caminho (Backtrace) do destino ate a origem
      mut as int64: trace_r = 5
      mut as int64: trace_c = 5
      println("3. Caminho Reconstruido via Backtrace:")
      println("   Passo final: [" + trace_r + ", " + trace_c + "]")

      infinite ((trace_r != 1) or (trace_c != 1)) {
            mut as int64: cur_step = grid[(trace_r - 1) * cols + trace_c]
            mut as int64: next_r = trace_r
            mut as int64: next_c = trace_c
            mut as bool: step_found = false

            d = 1
            infinite (d <= 4 and not step_found) {
                  nr = trace_r
                  nc = trace_c
                  route {
                        d == 1 ==> { nr = trace_r - 1 }
                        d == 2 ==> { nr = trace_r + 1 }
                        d == 3 ==> { nc = trace_c - 1 }
                        _      ==> { nc = trace_c + 1 }
                  }

                  route {
                        (nr >= 1) and (nr <= rows) and (nc >= 1) and (nc <= cols) ==> {
                              route {
                                    grid[(nr - 1) * cols + nc] == cur_step - 1 ==> {
                                          next_r = nr
                                          next_c = nc
                                          step_found = true
                                    }
                                    _ ==> {}
                              }
                        }
                        _ ==> {}
                  }
                  d = d + 1
            }

            trace_r = next_r
            trace_c = next_c
            println("   Passo anterior: [" + trace_r + ", " + trace_c + "]")
      }

      println("Lee Algorithm concluido com sucesso.")
}
