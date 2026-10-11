#L ============================================================================
#L Algoritmo: Smith-Waterman (Alinhamento Local de Sequencias)
#L Dominio: 10_bio_quantum / Categoria: Bioinformatica
#L Complexidade: O(M * N) tempo | O(M * N) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfBioInformaticaSmithWaterman) {
      println("==================================================")
      println("  SciAlgo: Smith-Waterman Local Sequence Alignment")
      println("==================================================")

      #L Nucleotideos: 1='A', 2='C', 3='G', 4='T'
      #L Seq 1 (S1): "ACACACTA" -> [1, 2, 1, 2, 1, 2, 4, 1] (tam m=8)
      #L Seq 2 (S2): "AGCACACA" -> [1, 3, 2, 1, 2, 1, 2, 1] (tam n=8)
      mut as list of int64: s1 = [1, 2, 1, 2, 1, 2, 4, 1]
      mut as int64: m = 8

      mut as list of int64: s2 = [1, 3, 2, 1, 2, 1, 2, 1]
      mut as int64: n = 8

      mut as int64: match_score = 2
      mut as int64: mismatch_penalty = -1
      mut as int64: gap_penalty = -1

      println("1. Sequencias de Entrada e Parametros:")
      println("   Sequencia 1 (S1) [tam " + m + "]: A C A C A C T A")
      println("   Sequencia 2 (S2) [tam " + n + "]: A G C A C A C A")
      println("   Match = +" + match_score + " | Mismatch = " + mismatch_penalty + " | Gap = " + gap_penalty)

      #L Matriz DP (m+1) x (n+1) inicializada com zeros
      mut as int64: cols = n + 1
      mut as int64: total_cells = (m + 1) * cols
      mut as list of int64: dp = []
      mut as int64: z = 1
      infinite (z <= total_cells) {
            dp = listPushBack(dp, 0)
            z = z + 1
      }

      println("==================================================")
      println("2. Preenchimento da Matriz com Clamping a Zero:")

      mut as int64: max_score = 0
      mut as int64: max_i = 0
      mut as int64: max_j = 0

      mut as int64: i = 1
      infinite (i <= m) {
            mut as int64: j = 1
            infinite (j <= n) {
                  mut as int64: subst = mismatch_penalty
                  route {
                        s1[i] == s2[j] ==> { subst = match_score }
                        _ ==> {}
                  }

                  mut as int64: score_diag = dp[((i - 1) * cols) + (j - 1) + 1] + subst
                  mut as int64: score_up = dp[((i - 1) * cols) + j + 1] + gap_penalty
                  mut as int64: score_left = dp[(i * cols) + (j - 1) + 1] + gap_penalty

                  #L O Smith-Waterman restringe o valor minimo a 0
                  mut as int64: best = 0
                  route {
                        score_diag > best ==> { best = score_diag }
                        _ ==> {}
                  }
                  route {
                        score_up > best ==> { best = score_up }
                        _ ==> {}
                  }
                  route {
                        score_left > best ==> { best = score_left }
                        _ ==> {}
                  }

                  dp[(i * cols) + j + 1] = best

                  #L Rastreia o ponto de maxima similaridade local
                  route {
                        best > max_score ==> {
                              max_score = best
                              max_i = i
                              max_j = j
                        }
                        _ ==> {}
                  }
                  j = j + 1
            }
            i = i + 1
      }

      println("   Maximo Escore Local Encontrado: " + max_score)
      println("   Posicao do Pico: S1[" + max_i + "] e S2[" + max_j + "]")

      println("==================================================")
      println("3. Traceback a partir do Pico Local (ate celula zero):")

      mut as int64: ti = max_i
      mut as int64: tj = max_j
      mut as int64: align_len = 0
      mut as int64: matches_count = 0

      infinite (ti > 0 and tj > 0) {
            mut as int64: cur = dp[(ti * cols) + tj + 1]
            route {
                  cur == 0 ==> {
                        #L Fim do alinhamento local
                        ti = 0
                        tj = 0
                  }
                  _ ==> {
                        align_len = align_len + 1
                        mut as int64: s_val = mismatch_penalty
                        route {
                              s1[ti] == s2[tj] ==> {
                                    s_val = match_score
                                    matches_count = matches_count + 1
                              }
                              _ ==> {}
                        }

                        mut as int64: d_val = dp[((ti - 1) * cols) + (tj - 1) + 1]
                        mut as int64: u_val = dp[((ti - 1) * cols) + tj + 1]
                        mut as int64: l_val = dp[(ti * cols) + (tj - 1) + 1]

                        route {
                              cur == (d_val + s_val) ==> {
                                    ti = ti - 1
                                    tj = tj - 1
                              }
                              cur == (u_val + gap_penalty) ==> {
                                    ti = ti - 1
                              }
                              _ ==> {
                                    tj = tj - 1
                              }
                        }
                  }
            }
      }

      println("   Tamanho do Subsegmento Local: " + align_len + " posicoes")
      println("   Identidades (Matches exatos): " + matches_count)

      println("==================================================")
      println("4. Resumo do Alinhamento Local:")
      println("   Escore Local Otimo: " + max_score)
      println("   Comprimento do Alinhamento: " + align_len)
      println("   Smith-Waterman concluido com sucesso!")
      println("==================================================")
}
