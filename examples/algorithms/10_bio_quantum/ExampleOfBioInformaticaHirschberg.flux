#L ============================================================================
#L Algoritmo: Hirschberg (Alinhamento Linear em Espaco por Divisao e Conquista)
#L Dominio: 10_bio_quantum / Categoria: Bioinformatica
#L Complexidade: O(M * N) tempo | O(min(M, N)) espaco linear
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfBioInformaticaHirschberg) {
      println("==================================================")
      println("  SciAlgo: Hirschberg Space-Efficient Alignment")
      println("==================================================")

      #L Mapeamento de Nucleotideos: 1='A', 2='C', 3='G', 4='T'
      #L S1: "AGTACG" -> [1, 3, 4, 1, 2, 3] (tam m=6)
      #L S2: "ACATAG" -> [1, 2, 1, 4, 1, 3] (tam n=6)
      mut as list of int64: s1 = [1, 3, 4, 1, 2, 3]
      mut as int64: m = 6

      mut as list of int64: s2 = [1, 2, 1, 4, 1, 3]
      mut as int64: n = 6

      mut as int64: match_score = 2
      mut as int64: mismatch_penalty = -1
      mut as int64: gap_penalty = -2

      println("1. Sequencias de Entrada (Alinhamento em Espaco O(N)):")
      println("   S1 [tam " + m + "]: A G T A C G")
      println("   S2 [tam " + n + "]: A C A T A G")
      println("   Match = +" + match_score + " | Mismatch = " + mismatch_penalty + " | Gap = " + gap_penalty)

      println("==================================================")
      println("2. Divisao no Ponto Medio (Midpoint Decomposition):")
      mut as int64: mid = m /i 2
      println("   Ponto Medio de S1: mid = " + mid + " (Prefixo tam " + mid + ", Sufixo tam " + (m - mid) + ")")

      #L 2.1 Forward Needleman-Wunsch em uma linha (de 0 ate mid)
      #L Vetor anterior e vetor atual de tamanho n+1
      mut as list of int64: fwd_prev = []
      mut as int64: c = 0
      infinite (c <= n) {
            fwd_prev = listPushBack(fwd_prev, c * gap_penalty)
            c = c + 1
      }

      mut as int64: r = 1
      infinite (r <= mid) {
            mut as list of int64: fwd_curr = []
            fwd_curr = listPushBack(fwd_curr, r * gap_penalty) #L j = 0

            mut as int64: j = 1
            infinite (j <= n) {
                  mut as int64: subst = mismatch_penalty
                  route {
                        s1[r] == s2[j] ==> { subst = match_score }
                        _ ==> {}
                  }

                  mut as int64: sc_diag = fwd_prev[j] + subst
                  mut as int64: sc_up = fwd_prev[j + 1] + gap_penalty
                  mut as int64: sc_left = fwd_curr[j] + gap_penalty

                  mut as int64: best = sc_diag
                  route {
                        sc_up > best ==> { best = sc_up }
                        _ ==> {}
                  }
                  route {
                        sc_left > best ==> { best = sc_left }
                        _ ==> {}
                  }

                  fwd_curr = listPushBack(fwd_curr, best)
                  j = j + 1
            }
            fwd_prev = fwd_curr
            r = r + 1
      }

      #L 2.2 Reverse Needleman-Wunsch em uma linha (do fim ate mid)
      #L Alinha reverso de S1[mid+1..m] com reverso de S2[1..n]
      mut as list of int64: rev_prev = []
      mut as int64: rc = 0
      infinite (rc <= n) {
            rev_prev = listPushBack(rev_prev, rc * gap_penalty)
            rc = rc + 1
      }

      mut as int64: rr = m
      infinite (rr > mid) {
            mut as list of int64: rev_curr = []
            rev_curr = listPushBack(rev_curr, (m - rr + 1) * gap_penalty)

            mut as int64: rj = 1
            infinite (rj <= n) {
                  #L nucleotideo correspondente no reverso de S2: s2[n - rj + 1]
                  mut as int64: subst_rev = mismatch_penalty
                  route {
                        s1[rr] == s2[n - rj + 1] ==> { subst_rev = match_score }
                        _ ==> {}
                  }

                  mut as int64: sc_diag_r = rev_prev[rj] + subst_rev
                  mut as int64: sc_up_r = rev_prev[rj + 1] + gap_penalty
                  mut as int64: sc_left_r = rev_curr[rj] + gap_penalty

                  mut as int64: best_r = sc_diag_r
                  route {
                        sc_up_r > best_r ==> { best_r = sc_up_r }
                        _ ==> {}
                  }
                  route {
                        sc_left_r > best_r ==> { best_r = sc_left_r }
                        _ ==> {}
                  }

                  rev_curr = listPushBack(rev_curr, best_r)
                  rj = rj + 1
            }
            rev_prev = rev_curr
            rr = rr - 1
      }

      println("==================================================")
      println("3. Combinacao e Encontro do Ponto Otimo de Corte (Cut):")

      mut as int64: best_cut_score = -999999
      mut as int64: best_cut_j = 0

      #L fwd_prev[j+1] contem Fwd(j), onde j in 0..n
      #L rev_prev[n - j + 1] contem Rev(n - j)
      mut as int64: cut_j = 0
      infinite (cut_j <= n) {
            mut as int64: f_val = fwd_prev[cut_j + 1]
            mut as int64: r_val = rev_prev[n - cut_j + 1]
            mut as int64: total_score = f_val + r_val

            println("   Corte j=" + cut_j + ": Fwd=" + f_val + " + Rev=" + r_val + " = " + total_score)

            route {
                  total_score > best_cut_score ==> {
                        best_cut_score = total_score
                        best_cut_j = cut_j
                  }
                  _ ==> {}
            }
            cut_j = cut_j + 1
      }

      println("==================================================")
      println("4. Resumo da Recursao de Hirschberg:")
      println("   Ponto de Divisao Identificado: (i=" + mid + ", j=" + best_cut_j + ")")
      println("   Escore Global do Alinhamento: " + best_cut_score)
      println("   Reducao de Memoria: Espaco O(N) mantido com sucesso")
      println("   Hirschberg concluido com sucesso!")
      println("==================================================")
}
