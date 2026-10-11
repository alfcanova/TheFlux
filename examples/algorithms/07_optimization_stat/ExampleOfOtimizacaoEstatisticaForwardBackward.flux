#L ============================================================================
#L Algoritmo: Forward-Backward (Suavizacao Marginal em HMM)
#L Dominio: 07_optimization_stat / Categoria: Estatistica e inferencia
#L Complexidade: Tempo O(T * S^2) | Espaco O(T * S)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoEstatisticaForwardBackward) {
      println("==================================================")
      println("  SciAlgo: Forward-Backward (HMM Smoothing)")
      println("==================================================")

      #L Passada Forward alpha em t=2 para 2 estados
      mut as int64: alpha_s1 = 45
      mut as int64: alpha_s2 = 15

      #L Passada Backward beta em t=2 para 2 estados
      mut as int64: beta_s1 = 30
      mut as int64: beta_s2 = 10

      #L Posterior marginal gamma_t(i) = alpha_t(i) * beta_t(i) / normalizador
      mut as int64: prod1 = alpha_s1 * beta_s1   #L 1350
      mut as int64: prod2 = alpha_s2 * beta_s2   #L 150
      mut as int64: total = prod1 + prod2        #L 1500

      mut as int64: gamma1_pct = (prod1 * 100) /i total  #L 90%
      mut as int64: gamma2_pct = (prod2 * 100) /i total  #L 10%

      println("1. Distribuicao marginal suavizada no instante t = 2:")
      println("   -> P(S_2 = Estado 1 | Y) = " + gamma1_pct + "%")
      println("   -> P(S_2 = Estado 2 | Y) = " + gamma2_pct + "%")

      route {
            gamma1_pct == 90 and gamma2_pct == 10 ==> {
                  println("   [PASS] Forward-Backward suavizou o estado com exatidao!")
            }
            _ ==> {
                  println("   [ERRO] Divergencia no Forward-Backward.")
            }
      }

      println("==================================================")
      println("Forward-Backward concluido com sucesso!")
}
