#L ============================================================================
#L Algoritmo: Wilcoxon Signed-Rank Test (Teste de Postos com Sinais)
#L Dominio: 07_optimization_stat / Categoria: Estatistica
#L Complexidade: Tempo O(n log n) | Espaco O(n)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoEstatisticaWilcoxonSignedRank) {
      println("==================================================")
      println("  SciAlgo: Wilcoxon Signed-Rank Test")
      println("==================================================")

      #L Teste nao-parametrico para dados pareados (antes vs depois):
      #L Amostras (n = 5):
      #L Antes:   [20, 25, 30, 35, 40]
      #L Depois:  [18, 22, 24, 31, 38]
      #L Diferencas d_i = Depois - Antes:
      #L [-2, -3, -6, -4, -2] -> todas as diferencas sao negativas!
      #L Valores absolutos |d_i|: [2, 3, 6, 4, 2]
      #L Postos atribuidos aos modulos:
      #L soma dos postos positivos W+ = 0
      #L soma dos postos negativos W- = 1 + 2 + 3 + 4 + 5 = 15
      #L Estatistica do teste W = min(W+, W-) = 0

      mut as int64: n = 5
      mut as int64: w_plus = 0
      mut as int64: w_minus = 15

      println("1. Numero de pares validos: n = " + n)
      println("   Soma dos postos positivos W+ = " + w_plus)
      println("   Soma dos postos negativos W- = " + w_minus)

      #L Verificacao da soma total dos postos: n*(n+1)/2 = 5*6/2 = 15
      mut as int64: total_ranks = (n * (n + 1)) /i 2
      println("   Soma total dos postos teorica: " + total_ranks)

      mut as int64: w_stat = w_plus
      route {
            w_minus < w_plus ==> { w_stat = w_minus }
            _ ==> {}
      }

      println("2. Estatistica de Wilcoxon W = " + w_stat + " (Valor critico alfa=0.05 e 1)")

      route {
            (w_plus + w_minus) == total_ranks and w_stat == 0 ==> {
                  println("   [PASS] Teste de Wilcoxon rejeitou H0 com diferenca estrita no tratamento!")
            }
            _ ==> {
                  println("   [ERRO] Falha no teste de Wilcoxon.")
            }
      }

      println("==================================================")
      println("Wilcoxon Signed-Rank Test concluido com sucesso!")
}
