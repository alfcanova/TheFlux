#L ============================================================================
#L Algoritmo: Hungarian Algorithm (Metodo Hungaro Classico de Reducao de Matriz)
#L Dominio: 03_graphs / Categoria: Fluxo, corte e matching
#L Complexidade: O(N^3) tempo | O(N^2) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosFluxoCorteHungarianAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Hungarian Algorithm (Matrix Reduction) ")
      println("==================================================")

      mut as int64: n = 3

      #L Matriz original de custos 3x3
      #L Trabalhador 1: [9, 2, 7]
      #L Trabalhador 2: [6, 4, 3]
      #L Trabalhador 3: [5, 8, 1]
      mut as list of int64: orig_cost = [
            9, 2, 7,
            6, 4, 3,
            5, 8, 1
      ]

      println("1. Matriz de Custos Inicial (3x3):")
      println("   T1: [9, 2, 7]")
      println("   T2: [6, 4, 3]")
      println("   T3: [5, 8, 1]")

      #L Copia para matriz de trabalho
      mut as list of int64: mat = [
            orig_cost[1], orig_cost[2], orig_cost[3],
            orig_cost[4], orig_cost[5], orig_cost[6],
            orig_cost[7], orig_cost[8], orig_cost[9]
      ]

      #L PASSO 1: Reducao de Linhas (subtrai o minimo de cada linha)
      mut as int64: r = 1
      infinite (r <= n) {
            mut as int64: min_r = 999999
            mut as int64: c = 1
            infinite (c <= n) {
                  mut as int64: val = mat[(r - 1) * n + c]
                  route {
                        val < min_r ==> {
                              min_r = val
                        }
                        _ ==> {}
                  }
                  c = c + 1
            }

            c = 1
            infinite (c <= n) {
                  mut as int64: idx = (r - 1) * n + c
                  mat[idx] = mat[idx] - min_r
                  c = c + 1
            }
            r = r + 1
      }

      #L PASSO 2: Reducao de Colunas (subtrai o minimo de cada coluna)
      mut as int64: col = 1
      infinite (col <= n) {
            mut as int64: min_c = 999999
            mut as int64: row = 1
            infinite (row <= n) {
                  mut as int64: val = mat[(row - 1) * n + col]
                  route {
                        val < min_c ==> {
                              min_c = val
                        }
                        _ ==> {}
                  }
                  row = row + 1
            }

            row = 1
            infinite (row <= n) {
                  mut as int64: idx = (row - 1) * n + col
                  mat[idx] = mat[idx] - min_c
                  row = row + 1
            }
            col = col + 1
      }

      #L PASSO 3: Atribuicao gulosa de zeros independentes com caminhos aumentantes
      #L Busca emparelhamento maximo na matriz de zeros
      mut as list of int64: match_row = [0, 0, 0]
      mut as list of int64: match_col = [0, 0, 0]

      mut as int64: u0 = 1
      infinite (u0 <= n) {
            mut as list of bool: visited_c = [false, false, false]
            mut as list of int64: from_r = [0, 0, 0]

            mut as list of int64: queue = [0, 0, 0]
            mut as int64: q_head = 1
            mut as int64: q_tail = 1
            queue[q_tail] = u0
            q_tail = q_tail + 1

            mut as int64: free_c = 0
            infinite (q_head < q_tail and free_c == 0) {
                  mut as int64: curr_r = queue[q_head]
                  q_head = q_head + 1

                  mut as int64: c_idx = 1
                  infinite (c_idx <= n and free_c == 0) {
                        mut as int64: is_zero = mat[(curr_r - 1) * n + c_idx]
                        route {
                              (is_zero == 0) and (not visited_c[c_idx]) ==> {
                                    visited_c[c_idx] = true
                                    from_r[c_idx] = curr_r

                                    route {
                                          match_col[c_idx] == 0 ==> {
                                                free_c = c_idx
                                          }
                                          _ ==> {
                                                queue[q_tail] = match_col[c_idx]
                                                q_tail = q_tail + 1
                                          }
                                    }
                              }
                              _ ==> {}
                        }
                        c_idx = c_idx + 1
                  }
            }

            route {
                  free_c > 0 ==> {
                        mut as int64: curr = free_c
                        infinite (curr != 0) {
                              mut as int64: row_u = from_r[curr]
                              mut as int64: prev_c = match_row[row_u]

                              match_col[curr] = row_u
                              match_row[row_u] = curr

                              curr = prev_c
                        }
                  }
                  _ ==> {}
            }

            u0 = u0 + 1
      }

      mut as int64: total_cost = 0
      println("2. Designacao Otima Encontrada:")
      r = 1
      infinite (r <= n) {
            mut as int64: assigned_c = match_row[r]
            mut as int64: cst = orig_cost[(r - 1) * n + assigned_c]
            total_cost = total_cost + cst
            println("   Trabalhador " + r + " -> Tarefa " + assigned_c + " (custo " + cst + ")")
            r = r + 1
      }

      println("3. Custo Minimo Total: " + total_cost)
      println("Hungarian Algorithm concluido com sucesso.")
}
