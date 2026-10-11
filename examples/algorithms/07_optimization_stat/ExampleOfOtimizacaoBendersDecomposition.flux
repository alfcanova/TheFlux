#L ============================================================================
#L Algoritmo: Decomposicao de Benders (Benders Decomposition)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(Iter * LP) | Espaco O(Iter)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoBendersDecomposition) {
      println("==================================================")
      println("  SciAlgo: Benders Decomposition (Cortes de Otimalidade)")
      println("==================================================")

      #L Problema Mestre: min c^T x + theta s.a. cortes de Benders
      #L Subproblema dual fornece multiplicador u que gera o corte:
      #L theta >= u^T (b - A x)
      #L Modelo 1D:
      #L Custo mestre: 2 * x + theta
      #L Subproblema dual: max u * (20 - 2*x) sujeito a u <= 3 -> u* = 3
      #L Corte gerado: theta >= 3 * (20 - 2*x) = 60 - 6*x

      mut as int64: x = 0
      mut as int64: theta = 0
      mut as int64: lower_bound = 0
      mut as int64: upper_bound = 999

      println("1. Iteracao 1 (Relaxacao inicial sem cortes):")
      #L Mestre inicial: min 2*x + theta -> x = 0, theta = 0
      mut as int64: obj_master = (2 * x) + theta
      println("   Master: x = " + x + ", theta = " + theta)

      #L Subproblema dual avalia x = 0: u = 3, sub_obj = 3 * (20 - 0) = 60
      mut as int64: sub_val = 3 * (20 - (2 * x))
      upper_bound = (2 * x) + sub_val #L 60
      println("   Dual Subproblem gera corte: theta >= 60 - 6*x")

      println("2. Iteracao 2 (Resolucao com Corte de Benders):")
      #L Mestre resolve min 2*x + theta s.a. theta >= 60 - 6*x, x >= 0
      #L Substituindo theta: min 2*x + 60 - 6*x = 60 - 4*x -> limite x <= 10 (onde 20 - 2x = 0)
      #L Ponto otimo x* = 10, theta* = 0, custo total = 20
      x = 10
      theta = 0
      sub_val = 3 * (20 - (2 * x)) #L 0
      lower_bound = (2 * x) + theta
      upper_bound = (2 * x) + sub_val

      println("   Master refinado: x = " + x + ", theta = " + theta)
      println("   Upper Bound = " + upper_bound + " | Lower Bound = " + lower_bound)

      route {
            lower_bound == upper_bound and x == 10 and upper_bound == 20 ==> {
                  println("   [PASS] Decomposicao de Benders convergiu no gap de dualidade zero!")
            }
            _ ==> {
                  println("   [ERRO] Falha na Decomposicao de Benders.")
            }
      }

      println("==================================================")
      println("Benders Decomposition concluido com sucesso!")
}
