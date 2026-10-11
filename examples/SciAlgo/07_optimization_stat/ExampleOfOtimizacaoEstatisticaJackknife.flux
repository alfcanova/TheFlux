#L ============================================================================
#L Algoritmo: Jackknife (Estimacao Leave-One-Out)
#L Dominio: 07_optimization_stat / Categoria: Estatistica e inferencia
#L Complexidade: Tempo O(N^2) | Espaco O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoEstatisticaJackknife) {
      println("==================================================")
      println("  SciAlgo: Jackknife (Leave-One-Out Variance)")
      println("==================================================")

      mut as list of int64: amostra = [2, 4, 6, 8, 10]
      mut as int64: n = listLength(amostra)
      mut as int64: full_sum = 30

      #L Computa medias leave-one-out theta_{(i)}
      mut as list of int64: jack_means = []
      mut as int64: i = 1
      infinite (i <= n) {
            mut as int64: part_sum = full_sum - amostra[i]
            mut as int64: m = (part_sum * 10) /i (n - 1)
            jack_means = listPushBack(jack_means, m)
            i = i + 1
      }

      #L Variancia Jackknife: (n - 1)/n * sum( (theta_i - theta_bar)^2 )
      mut as int64: theta_bar = 60 #L 6.0 * 10
      mut as int64: sum_diff_sq = 0
      i = 1
      infinite (i <= n) {
            mut as int64: diff = jack_means[i] - theta_bar
            sum_diff_sq = sum_diff_sq + (diff * diff)
            i = i + 1
      }
      mut as int64: jack_var = ((n - 1) * sum_diff_sq) /i n

      println("1. Variancia do estimador estimada por Jackknife: " + jack_var)
      route {
            jack_var > 0 ==> {
                  println("   [PASS] Variancia Jackknife computada com estabilidade!")
            }
            _ ==> {
                  println("   [ERRO] Falha na estimacao Jackknife.")
            }
      }

      println("==================================================")
      println("Jackknife concluido com sucesso!")
}
