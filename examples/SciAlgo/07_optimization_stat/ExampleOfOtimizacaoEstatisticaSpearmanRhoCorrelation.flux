#L ============================================================================
#L Algoritmo: Spearman's Rho Rank Correlation (Coeficiente de Correlacao de Postos)
#L Dominio: 07_optimization_stat / Categoria: Estatistica Nao-Parametrica
#L Descricao: Mede relacao monotona entre postos via diferencas quadraticas
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoEstatisticaSpearmanRhoCorrelation) {
      println("=== Algoritmo: Spearman's Rho Rank Correlation ===")

      #L Amostra de n = 5 sujeitos com postos em duas avaliacoes (X e Y)
      #L Sujeito 1: Rank_X = 1, Rank_Y = 1 -> d = 0,  d^2 = 0
      #L Sujeito 2: Rank_X = 2, Rank_Y = 3 -> d = -1, d^2 = 1
      #L Sujeito 3: Rank_X = 3, Rank_Y = 2 -> d = +1, d^2 = 1
      #L Sujeito 4: Rank_X = 4, Rank_Y = 4 -> d = 0,  d^2 = 0
      #L Sujeito 5: Rank_X = 5, Rank_Y = 5 -> d = 0,  d^2 = 0
      mut as int64: n = 5

      #L Soma das diferencas quadraticas sum(d_i^2)
      mut as int64: sum_d2 = 0 + 1 + 1 + 0 + 0
      println("Numero de observacoes (n): " + n)
      println("Soma das diferencas ao quadrado sum(d^2): " + sum_d2)

      #L Denominador: n * (n^2 - 1) = 5 * (25 - 1) = 5 * 24 = 120
      mut as int64: n_sq = n * n
      mut as int64: n_sq_minus_1 = n_sq - 1
      mut as int64: denom = n * n_sq_minus_1

      #L Numerador da fracao: 6 * sum(d^2) = 6 * 2 = 12
      mut as int64: num_frac = 6 * sum_d2

      #L Rho = 1 - (6 * sum(d^2)) / (n * (n^2 - 1))
      #L Escalando por 1000 para precisao inteira:
      #L rho_x1000 = 1000 - (1000 * num_frac) /i denom
      #L rho_x1000 = 1000 - 12000 /i 120 = 1000 - 100 = 900 (rho = 0.90)
      mut as int64: frac_scaled = 1000 * num_frac
      mut as int64: subtraendo = frac_scaled /i denom
      mut as int64: rho_x1000 = 1000 - subtraendo

      mut as int64: rho_int = rho_x1000 /i 1000
      mut as int64: rho_dec = rho_x1000 /r 1000
      println("Spearman Rho (x1000): " + rho_x1000)
      println("Coeficiente Rho: " + rho_int + "." + rho_dec)

      route {
            rho_x1000 >= 800 ==> {
                  println("Interpretacao: Fortissima associacao monotonica positiva")
            }
            rho_x1000 < 800 ==> {
                  println("Interpretacao: Associacao moderada ou fraca")
            }
      }

      println("Spearman's Rho Rank Correlation concluido com sucesso.")
}
