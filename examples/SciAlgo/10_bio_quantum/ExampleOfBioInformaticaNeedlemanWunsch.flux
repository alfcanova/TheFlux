#L ============================================================================
#L Algoritmo: Needleman-Wunsch (Alinhamento Global de Sequencias)
#L Dominio: 10_bio_quantum / Categoria: Bioinformatica
#L Complexidade: O(M * N) tempo | O(M * N) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfBioInformaticaNeedlemanWunsch) {
      println("==================================================")
      println("  SciAlgo: Needleman-Wunsch Global Alignment")
      println("==================================================")

      #L Mapeamento de Nucleotideos: 1='A', 2='C', 3='G', 4='T'
      #L Seq 1 (S1): "GATTACA" -> [3, 1, 4, 4, 1, 2, 1] (tam m=7)
      #L Seq 2 (S2): "GCATGCU" -> [3, 2, 1, 4, 3, 2, 4] (tam n=7)
      mut as list of int64: s1 = [3, 1, 4, 4, 1, 2, 1]
      mut as int64: m = 7

      mut as list of int64: s2 = [3, 2, 1, 4, 3, 2, 4]
      mut as int64: n = 7

      mut as int64: match_score = 1
      mut as int64: mismatch_penalty = -1
      mut as int64: gap_penalty = -2

      println("1. Sequencias de Entrada e Parametros de Escore:")
      println("   Sequencia 1 (S1) [tam " + m + "]: G A T T A C A")
      println("   Sequencia 2 (S2) [tam " + n + "]: G C A T G C T")
      println("   Match = +" + match_score + " | Mismatch = " + mismatch_penalty + " | Gap = " + gap_penalty)

      #L Matriz DP (m+1) linhas x (n+1) colunas linearizada
      #L Indice 1-based: idx = (i * (n + 1)) + j + 1, onde i in 0..m, j in 0..n
      mut as int64: cols = n + 1
      mut as int64: total_cells = (m + 1) * cols
      mut as list of int64: dp = []
      mut as int64: z = 1
      infinite (z <= total_cells) {
            dp = listPushBack(dp, 0)
            z = z + 1
      }

      #L Inicializacao da primeira coluna (j = 0): dp[i, 0] = i * gap_penalty
      mut as int64: r = 0
      infinite (r <= m) {
            mut as int64: idx_r = (r * cols) + 0 + 1
            dp[idx_r] = r * gap_penalty
            r = r + 1
      }

      #L Inicializacao da primeira linha (i = 0): dp[0, j] = j * gap_penalty
      mut as int64: c = 0
      infinite (c <= n) {
            mut as int64: idx_c = (0 * cols) + c + 1
            dp[idx_c] = c * gap_penalty
            c = c + 1
      }

      println("==================================================")
      println("2. Preenchimento da Matriz de Programacao Dinamica:")

      mut as int64: i = 1
      infinite (i <= m) {
            mut as int64: j = 1
            infinite (j <= n) {
                  #L Escore de substituicao (Diagonal)
                  mut as int64: subst = mismatch_penalty
                  route {
                        s1[i] == s2[j] ==> { subst = match_score }
                        _ ==> {}
                  }
                  mut as int64: diag_idx = ((i - 1) * cols) + (j - 1) + 1
                  mut as int64: score_diag = dp[diag_idx] + subst

                  #L Delecao em S2 (De cima: gap em S2)
                  mut as int64: up_idx = ((i - 1) * cols) + j + 1
                  mut as int64: score_up = dp[up_idx] + gap_penalty

                  #L Insercao em S2 (Da esquerda: gap em S1)
                  mut as int64: left_idx = (i * cols) + (j - 1) + 1
                  mut as int64: score_left = dp[left_idx] + gap_penalty

                  #L Maximo dos 3 caminhos
                  mut as int64: max_val = score_diag
                  route {
                        score_up > max_val ==> { max_val = score_up }
                        _ ==> {}
                  }
                  route {
                        score_left > max_val ==> { max_val = score_left }
                        _ ==> {}
                  }

                  mut as int64: cur_idx = (i * cols) + j + 1
                  dp[cur_idx] = max_val
                  j = j + 1
            }
            i = i + 1
      }

      mut as int64: final_idx = (m * cols) + n + 1
      mut as int64: global_score = dp[final_idx]
      println("   Escore Global Otimo: " + global_score)

      println("==================================================")
      println("3. Rastreamento do Alinhamento (Traceback):")

      mut as int64: ti = m
      mut as int64: tj = n
      mut as int64: step_count = 0
      mut as list of int64: align_s1 = []
      mut as list of int64: align_s2 = []

      #L Traceback reverso de (m, n) ate (0, 0)
      infinite (ti > 0 or tj > 0) {
            step_count = step_count + 1
            mut as int64: cur_cell = dp[(ti * cols) + tj + 1]

            mut as int64: chosen_move = 0 #L 1=diag, 2=up, 3=left

            route {
                  ti > 0 and tj > 0 ==> {
                        mut as int64: s_val = mismatch_penalty
                        route {
                              s1[ti] == s2[tj] ==> { s_val = match_score }
                              _ ==> {}
                        }
                        mut as int64: d_val = dp[((ti - 1) * cols) + (tj - 1) + 1]
                        route {
                              cur_cell == (d_val + s_val) ==> { chosen_move = 1 }
                              _ ==> {}
                        }
                  }
                  _ ==> {}
            }

            route {
                  chosen_move == 0 and ti > 0 ==> {
                        mut as int64: u_val = dp[((ti - 1) * cols) + tj + 1]
                        route {
                              cur_cell == (u_val + gap_penalty) ==> { chosen_move = 2 }
                              _ ==> {}
                        }
                  }
                  _ ==> {}
            }

            route {
                  chosen_move == 0 ==> {
                        chosen_move = 3
                  }
                  _ ==> {}
            }

            route {
                  chosen_move == 1 ==> {
                        align_s1 = listPushBack(align_s1, s1[ti])
                        align_s2 = listPushBack(align_s2, s2[tj])
                        ti = ti - 1
                        tj = tj - 1
                  }
                  chosen_move == 2 ==> {
                        align_s1 = listPushBack(align_s1, s1[ti])
                        align_s2 = listPushBack(align_s2, 0) #L 0 representa GAP (-)
                        ti = ti - 1
                  }
                  _ ==> {
                        align_s1 = listPushBack(align_s1, 0) #L GAP em S1
                        align_s2 = listPushBack(align_s2, s2[tj])
                        tj = tj - 1
                  }
            }
      }

      println("   Comprimento do Alinhamento Alinhado: " + step_count + " colunas")
      println("4. Resumo do Alinhamento Global:")
      println("   Pontuacao Final Needleman-Wunsch: " + global_score)
      println("   Total de passos no traceback: " + step_count)
      println("   Needleman-Wunsch concluido com sucesso!")
      println("==================================================")
}
