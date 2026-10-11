#L ============================================================================
#L Algoritmo: Frank-Wolfe (Conditional Gradient Method)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(1 / epsilon) | Espaco O(D)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoFrankWolfe) {
      println("==================================================")
      println("  SciAlgo: Frank-Wolfe (Conditional Gradient)")
      println("==================================================")

      #L Minimiza f(x) sobre conjunto convexo C = [0, 10]
      #L Gradiente df/dx > 0 -> oraculo linear escolhe extremo s = 0
      mut as int64: x = 8
      mut as int64: iter = 1
      infinite (iter <= 3) {
            mut as int64: s_extremo = 0 #L oraculo linear
            #L Combinacao convexa: x_{t+1} = (1 - gamma) * x_t + gamma * s (gamma = 1/2)
            x = (x + s_extremo) /i 2
            iter = iter + 1
      }
      println("1. Posicao convergida por combinacoes convexas: x = " + x)

      route {
            x <= 2 ==> {
                  println("   [PASS] Frank-Wolfe convergiu preservando a convexidade do dominio!")
            }
            _ ==> {
                  println("   [ERRO] Falha no Frank-Wolfe.")
            }
      }

      println("==================================================")
      println("Frank-Wolfe concluido com sucesso!")
}
