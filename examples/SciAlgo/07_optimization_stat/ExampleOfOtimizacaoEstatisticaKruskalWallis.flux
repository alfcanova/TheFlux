#L ============================================================================
#L Algoritmo: Kruskal-Wallis (Teste Nao-Parametrico de Variancia)
#L Dominio: 07_optimization_stat / Categoria: Estatistica e inferencia
#L Complexidade: Tempo O(N log N) | Espaco O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoEstatisticaKruskalWallis) {
      println("==================================================")
      println("  SciAlgo: Kruskal-Wallis Test (H Statistic)")
      println("==================================================")

      #L 3 Grupos com 3 amostras cada (N = 9 total)
      #L Postos acumulados: Grupo 1 = [1, 2, 3] (soma R1 = 6)
      #L                    Grupo 2 = [4, 5, 6] (soma R2 = 15)
      #L                    Grupo 3 = [7, 8, 9] (soma R3 = 24)
      mut as int64: r1 = 6
      mut as int64: r2 = 15
      mut as int64: r3 = 24
      mut as int64: n_grp = 3
      mut as int64: n_total = 9

      #L H = (12 / (N * (N + 1))) * sum(R_i^2 / n_i) - 3 * (N + 1)
      #L N * (N + 1) = 90
      mut as int64: sum_sq = (r1 * r1) /i n_grp + (r2 * r2) /i n_grp + (r3 * r3) /i n_grp
      mut as int64: term1 = (12 * sum_sq) /i 90
      mut as int64: term2 = 3 * (n_total + 1)
      mut as int64: h_stat = term1 - term2

      println("1. Soma de postos: R1 = " + r1 + ", R2 = " + r2 + ", R3 = " + r3)
      println("2. Estatistica H calculada: " + h_stat)

      route {
            h_stat > 5 ==> {
                  println("   [PASS] Kruskal-Wallis rejeita a hipotese nula com significancia!")
            }
            _ ==> {
                  println("   [ERRO] Falha no teste Kruskal-Wallis.")
            }
      }

      println("==================================================")
      println("Kruskal-Wallis concluido com sucesso!")
}
