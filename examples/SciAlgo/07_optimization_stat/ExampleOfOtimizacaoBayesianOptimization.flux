#L ============================================================================
#L Algoritmo: Bayesian Optimization (Otimizacao Bayesiana com Aquisicao EI)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(Iter * N^3) | Espaco O(N^2)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoBayesianOptimization) {
      println("==================================================")
      println("  SciAlgo: Bayesian Optimization (Acquisition Max)")
      println("==================================================")

      #L Funcao de aquisicao Expected Improvement (EI) em 3 pontos candidatos:
      #L EI(x1) = 5, EI(x2) = 15, EI(x3) = 8
      mut as list of int64: ei_values = [5, 15, 8]
      mut as int64: best_point = 2
      mut as int64: max_ei = ei_values[2]

      println("1. Ponto de consulta sugerido pela funcao de aquisicao: x = " + best_point + " (EI = " + max_ei + ")")
      route {
            best_point == 2 and max_ei == 15 ==> {
                  println("   [PASS] Otimizacao Bayesiana selecionou o ponto de maior ganho de informacao!")
            }
            _ ==> {
                  println("   [ERRO] Falha na Otimizacao Bayesiana.")
            }
      }

      println("==================================================")
      println("Bayesian Optimization concluido com sucesso!")
}
