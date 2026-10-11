#L ============================================================================
#L Algoritmo: Backtracking (Retrocesso com Poda)
#L Dominio: 01_foundations / Categoria: 1. Fundamentos e paradigmas algoritmicos
#L Complexidade: O(N!) pior caso | O(N) espaco auxiliar
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosParadigmasBacktracking) {
      println("==================================================")
      println("  SciAlgo: Backtracking (4-Rainhas)")
      println("==================================================")

      mut as int64: n = 4
      println("1. Tamanho do tabuleiro: " + n + " x " + n)

      #L Vetor queen_col[row] guarda a coluna (1..N) da rainha na linha row
      mut as list of int64: queen_col = [0, 0, 0, 0]
      mut as int64: solutions_found = 0
      mut as list of int64: first_solution = []
      mut as int64: prunes_count = 0
      mut as int64: placements_tested = 0

      #L Busca iterativa de Backtracking com controle de linha e coluna
      mut as int64: row = 1
      infinite (row >= 1) {
            #L Tenta avancar coluna para a rainha da linha atual
            mut as int64: col = queen_col[row] + 1
            mut as bool: placed = false

            infinite (col <= n and not placed) {
                  placements_tested = placements_tested + 1

                  #L Verifica se e seguro colocar em (row, col)
                  mut as bool: safe = true
                  mut as int64: prev_row = 1
                  infinite (prev_row < row and safe) {
                        mut as int64: prev_col = queen_col[prev_row]
                        #L Conflito na mesma coluna
                        route {
                              prev_col == col ==> {
                                    safe = false
                              }
                              _ ==> {
                              }
                        }
                        #L Conflito na diagonal (|r1 - r2| == |c1 - c2|)
                        mut as int64: diff_r = row - prev_row
                        mut as int64: diff_c = col - prev_col
                        route {
                              diff_c < 0 ==> {
                                    diff_c = 0 - diff_c
                              }
                              _ ==> {
                              }
                        }
                        route {
                              diff_r == diff_c ==> {
                                    safe = false
                              }
                              _ ==> {
                              }
                        }
                        prev_row = prev_row + 1
                  }

                  route {
                        safe ==> {
                              queen_col[row] = col
                              placed = true
                        }
                        _ ==> {
                              prunes_count = prunes_count + 1
                              col = col + 1
                        }
                  }
            }

            route {
                  placed ==> {
                        route {
                              row == n ==> {
                                    #L Encontrou solucao completa
                                    solutions_found = solutions_found + 1
                                    route {
                                          solutions_found == 1 ==> {
                                                first_solution = listClone(queen_col)
                                          }
                                          _ ==> {
                                          }
                                    }
                                    #L Nao incrementa linha; retrocede para buscar proximas solucoes
                                    queen_col[row] = 0
                                    row = row - 1
                              }
                              _ ==> {
                                    row = row + 1
                                    queen_col[row] = 0
                              }
                        }
                  }
                  _ ==> {
                        #L Retrocesso (Backtrack): nao ha mais colunas validas para esta linha
                        queen_col[row] = 0
                        row = row - 1
                  }
            }
      }

      println("2. Total de posicionamentos testados: " + placements_tested)
      println("3. Podas de ramos invalidos: " + prunes_count)
      println("4. Solucoes encontradas para N = 4: " + solutions_found)
      println("5. Primeira solucao (colunas por linha): " + first_solution)
      println("Concluido com Sucesso")
}
