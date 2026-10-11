#L ============================================================================
#L Algoritmo: Nesterov Accelerated Gradient (NAG)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(Iter) | Espaco O(1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoNesterovMomentum) {
      println("==================================================")
      println("  SciAlgo: Nesterov Accelerated Gradient (NAG)")
      println("==================================================")

      #L Gradiente avaliado no ponto look-ahead: x_look = x - gamma * v
      mut as int64: x = 80
      mut as int64: v = 0

      mut as int64: iter = 1
      infinite (iter <= 8) {
            mut as int64: x_look = x - ((8 * v) /i 10)
            mut as int64: grad = 2 * (x_look - 10)
            v = ((8 * v) /i 10) + ((2 * grad) /i 10)
            x = x - v
            iter = iter + 1
      }
      println("1. Posicao alcancada pelo Nesterov Momentum: x = " + x)

      route {
            x <= 25 ==> {
                  println("   [PASS] Nesterov Accelerated Gradient convergiu no alvo!")
            }
            _ ==> {
                  println("   [ERRO] Falha no NAG.")
            }
      }

      println("==================================================")
      println("Nesterov Momentum concluido com sucesso!")
}
