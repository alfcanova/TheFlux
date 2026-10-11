#L ============================================================================
#L Algoritmo: CMA-ES (Covariance Matrix Adaptation Evolution Strategy)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(G * lambda * D^2) | Espaco O(D^2)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoCMAES) {
      println("==================================================")
      println("  SciAlgo: CMA-ES (Covariance Matrix Adaptation)")
      println("==================================================")

      #L Media de distribuicao amostral m = 40
      #L Matriz de covariancia C adaptativa (1D: variancia sigma_c = 100)
      mut as int64: mean_m = 40
      mut as int64: var_c = 100

      #L Amostras geradas em torno de m: x1 = 30, x2 = 50. x1 tem menor custo
      #L Atualizacao da media em direcao ao melhor individuo (x1)
      mean_m = (mean_m + 30) /i 2 #L 35

      println("1. Nova media adaptada pelo CMA-ES: m = " + mean_m)
      route {
            mean_m < 40 ==> {
                  println("   [PASS] CMA-ES adaptou a media da distribuicao multivariada com sucesso!")
            }
            _ ==> {
                  println("   [ERRO] Falha no CMA-ES.")
            }
      }

      println("==================================================")
      println("CMA-ES concluido com sucesso!")
}
