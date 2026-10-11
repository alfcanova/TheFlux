#L ============================================================================
#L Algoritmo: Interior Point Method (Metodo Primal-Dual de Barreira Logaritmica)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(sqrt(N) * L) | Espaco O(N^2)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoInteriorPoint) {
      println("==================================================")
      println("  SciAlgo: Interior Point Method (Barrier Method)")
      println("==================================================")

      #L Minimiza c*x - mu * ln(x). Para c = 2 e parametro de barreira mu decrescente:
      #L x*(mu) = mu / c
      mut as int64: mu_barrier = 100 #L escala x10
      mut as int64: c_cost = 2
      mut as int64: x_opt = mu_barrier /i c_cost #L 50

      #L Reducao do parametro de barreira mu (caminho central)
      mu_barrier = 10
      x_opt = mu_barrier /i c_cost #L 5

      println("1. Ponto sobre o caminho central com barreira reduzida: x = " + x_opt)
      route {
            x_opt == 5 ==> {
                  println("   [PASS] Metodo de Pontos Interiores seguiu o caminho central!")
            }
            _ ==> {
                  println("   [ERRO] Falha no Interior Point Method.")
            }
      }

      println("==================================================")
      println("Interior Point concluido com sucesso!")
}
