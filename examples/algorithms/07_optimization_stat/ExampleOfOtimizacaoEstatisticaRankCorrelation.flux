#L ============================================================================
#L Algoritmo: Rank Correlation (Spearman Rho e Kendall Tau)
#L Dominio: 07_optimization_stat / Categoria: Estatistica
#L Complexidade: Tempo O(n^2) | Espaco O(n)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoEstatisticaRankCorrelation) {
      println("==================================================")
      println("  SciAlgo: Rank Correlation (Spearman & Kendall)")
      println("==================================================")

      #L Coeficientes de correlacao nao-parametricos baseados em postos:
      #L Amostras pareadas (n = 4):
      #L X: [10, 20, 30, 40] -> Postos R_x: [1, 2, 3, 4]
      #L Y: [15, 25, 28, 45] -> Postos R_y: [1, 2, 3, 4] (correlacao perfeita monotona)
      #L 1. Spearman Rho:
      #L   d_i = R_x - R_y = [0, 0, 0, 0]
      #L   rho = 1 - 6 * sum(d_i^2) / (n * (n^2 - 1)) = 1 - 0 = 1.0 (escala x100 = 100)
      #L 2. Kendall Tau:
      #L   Pares totais n*(n-1)/2 = 6
      #L   Todos os 6 pares sao concordantes: C = 6, D = 0
      #L   tau = (C - D) / 6 = 1.0 (escala x100 = 100)

      mut as list of int64: rx = [1, 2, 3, 4]
      mut as list of int64: ry = [1, 2, 3, 4]
      mut as int64: n = 4

      #L Calculo de Spearman
      mut as int64: sum_d2 = 0
      mut as int64: i = 1
      infinite (i <= n) {
            mut as int64: d = rx[i] - ry[i]
            sum_d2 = sum_d2 + (d * d)
            i = i + 1
      }
      mut as int64: denom_spearman = n * ((n * n) - 1) #L 4 * 15 = 60
      mut as int64: rho_scaled = 100 - ((6 * sum_d2 * 100) /i denom_spearman)

      #L Calculo de Kendall
      mut as int64: concordant = 0
      mut as int64: discordant = 0
      i = 1
      infinite (i <= n) {
            mut as int64: j = i + 1
            infinite (j <= n) {
                  mut as int64: dx = rx[j] - rx[i]
                  mut as int64: dy = ry[j] - ry[i]
                  route {
                        (dx * dy) > 0 ==> { concordant = concordant + 1 }
                        (dx * dy) < 0 ==> { discordant = discordant + 1 }
                        _ ==> {}
                  }
                  j = j + 1
            }
            i = i + 1
      }
      mut as int64: total_pairs = (n * (n - 1)) /i 2 #L 6
      mut as int64: tau_scaled = ((concordant - discordant) * 100) /i total_pairs

      println("1. Coeficiente de Spearman Rho:")
      println("   Soma dos desvios quadráticos sum(d^2) = " + sum_d2)
      println("   Rho = " + rho_scaled + " / 100 (1.00)")

      println("2. Coeficiente de Kendall Tau:")
      println("   Pares concordantes = " + concordant + " | Discordantes = " + discordant)
      println("   Tau = " + tau_scaled + " / 100 (1.00)")

      route {
            rho_scaled == 100 and tau_scaled == 100 and concordant == 6 ==> {
                  println("   [PASS] Correlacao monotona estrita confirmada por Spearman e Kendall!")
            }
            _ ==> {
                  println("   [ERRO] Falha nos coeficientes de correlacao.")
            }
      }

      println("==================================================")
      println("Rank Correlation concluido com sucesso!")
}
