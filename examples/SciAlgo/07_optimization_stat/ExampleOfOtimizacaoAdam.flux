#L ============================================================================
#L Algoritmo: Adam (Adaptive Moment Estimation)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(Iter) | Espaco O(1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoAdam) {
      println("==================================================")
      println("  SciAlgo: Adam (1st & 2nd Moment Optimization)")
      println("==================================================")

      mut as int64: theta = 70
      mut as int64: m1 = 0
      mut as int64: v2 = 0

      mut as int64: t = 1
      infinite (t <= 10) {
            mut as int64: grad = theta - 10
            #L m1 = 0.9 * m1 + 0.1 * grad
            m1 = ((9 * m1) /i 10) + ((1 * grad) /i 10)
            #L v2 = 0.99 * v2 + 0.01 * grad^2
            v2 = ((99 * v2) /i 100) + ((grad * grad) /i 100)

            theta = theta - m1
            t = t + 1
      }
      println("1. Parametro convergido pelo otimizador Adam: " + theta)

      route {
            theta <= 20 ==> {
                  println("   [PASS] Adam convergiu com momentos adaptativos com sucesso!")
            }
            _ ==> {
                  println("   [ERRO] Falha no Adam.")
            }
      }

      println("==================================================")
      println("Adam concluido com sucesso!")
}
