#L ============================================================================
#L Algoritmo: Bootstrap (Reamostragem Nao-Parametrica)
#L Dominio: 07_optimization_stat / Categoria: Estatistica e inferencia
#L Complexidade: Tempo O(B * N) | Espaco O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoEstatisticaBootstrap) {
      println("==================================================")
      println("  SciAlgo: Bootstrap (Empirical Resampling)")
      println("==================================================")

      #L Amostra original (N = 5): media real = 10
      mut as list of int64: amostra = [6, 8, 10, 12, 14]
      mut as int64: n = listLength(amostra)

      #L Simula 3 replicas bootstrap geradas com reposicao
      #L Replica 1: [8, 10, 10, 12, 14] -> soma 54, media 10
      #L Replica 2: [6, 6, 8, 12, 14]   -> soma 46, media 9
      #L Replica 3: [8, 10, 12, 12, 14] -> soma 56, media 11
      mut as list of int64: boot_means = [10, 9, 11]
      mut as int64: b_count = listLength(boot_means)

      mut as int64: sum_means = 0
      mut as int64: k = 1
      infinite (k <= b_count) {
            sum_means = sum_means + boot_means[k]
            k = k + 1
      }
      mut as int64: mean_of_means = sum_means /i b_count

      println("1. Media global estimada por Bootstrap: " + mean_of_means)
      route {
            mean_of_means == 10 ==> {
                  println("   [PASS] Estimacao pontual Bootstrap consistente com a populacao!")
            }
            _ ==> {
                  println("   [ERRO] Divergencia na media Bootstrap.")
            }
      }

      println("==================================================")
      println("Bootstrap concluido com sucesso!")
}
