#L ============================================================================
#L Algoritmo: Las Vegas Algorithm (Algoritmo de Las Vegas)
#L Dominio: 01_foundations / Categoria: 1. Fundamentos e paradigmas algoritmicos
#L Complexidade: Tempo esperado finito | 100% exatidao | O(N) espaco auxiliar
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosParadigmasLasVegasAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Las Vegas Algorithm (N-Rainhas)")
      println("==================================================")

      mut as int64: n = 6
      println("1. Problema das " + n + "-Rainhas via Las Vegas")

      #L PRNG LCG deterministico
      mut as int64: seed = 555555555
      mut as int64: lcg_m = 2147483647
      mut as int64: lcg_a = 48271

      mut as list of int64: queens = [0, 0, 0, 0, 0, 0]
      mut as bool: solved = false
      mut as int64: attempts = 0
      mut as int64: total_tries = 0

      infinite (not solved) {
            attempts = attempts + 1
            mut as int64: row = 1
            mut as bool: failed_attempt = false
            queens = [0, 0, 0, 0, 0, 0]

            infinite (row <= n and not failed_attempt) {
                  #L Encontra todas as colunas validas para a linha row
                  mut as list of int64: valid_cols = []
                  mut as int64: col = 1
                  infinite (col <= n) {
                        mut as bool: safe = true
                        mut as int64: prev_row = 1
                        infinite (prev_row < row and safe) {
                              mut as int64: prev_col = queens[prev_row]
                              route {
                                    prev_col == col ==> {
                                          safe = false
                                    }
                                    _ ==> {
                                    }
                              }
                              mut as int64: dr = row - prev_row
                              mut as int64: dc = col - prev_col
                              route {
                                    dc < 0 ==> {
                                          dc = 0 - dc
                                    }
                                    _ ==> {
                                    }
                              }
                              route {
                                    dr == dc ==> {
                                          safe = false
                                    }
                                    _ ==> {
                                    }
                              }
                              prev_row = prev_row + 1
                        }

                        route {
                              safe ==> {
                                    valid_cols = listPushBack(valid_cols, col)
                              }
                              _ ==> {
                              }
                        }
                        col = col + 1
                  }

                  mut as int64: num_valid = listLength(valid_cols)
                  route {
                        num_valid == 0 ==> {
                              failed_attempt = true
                        }
                        _ ==> {
                              #L Sorteia uma das colunas validas
                              seed = ((seed * lcg_a) + 1) /r lcg_m
                              route {
                                    seed < 0 ==> {
                                          seed = 0 - seed
                                    }
                                    _ ==> {
                              }
                              }
                              mut as int64: pick_idx = 1 + (seed /r num_valid)
                              queens[row] = valid_cols[pick_idx]
                              total_tries = total_tries + 1
                              row = row + 1
                        }
                  }
            }

            route {
                  not failed_attempt ==> {
                        solved = true
                  }
                  _ ==> {
                  }
            }
      }

      println("2. Tentativas ate sucesso garantido: " + attempts)
      println("3. Posicionamentos individuais realizados: " + total_tries)
      println("4. Solucao exata encontrada (colunas 1..6): " + queens)
      println("Concluido com Sucesso")
}
