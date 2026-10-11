#L ============================================================================
#L Algoritmo: Gradient Descent (Descida de Gradiente Pura)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(Iter * D) | Espaco O(D)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoGradientDescent) {
      println("==================================================")
      println("  SciAlgo: Gradient Descent (Quadratic Minimum)")
      println("==================================================")

      #L Minimiza f(x) = (x - 20)^2. Minimo global em x* = 20. Gradiente df/dx = 2*(x - 20)
      mut as int64: x = 100
      mut as int64: lr = 2 #L taxa de aprendizado 0.2 (escala /10)
      println("1. Ponto inicial x_0 = " + x + " | Minimo teorico x* = 20")

      mut as int64: iter = 1
      infinite (iter <= 15) {
            mut as int64: grad = 2 * (x - 20)
            x = x - ((lr * grad) /i 10)
            iter = iter + 1
      }
      println("2. Ponto final apos 15 iteracoes: x = " + x)

      route {
            x >= 19 and x <= 21 ==> {
                  println("   [PASS] Gradient Descent convergiu no minimo global com sucesso!")
            }
            _ ==> {
                  println("   [ERRO] Divergencia no Gradient Descent.")
            }
      }

      println("==================================================")
      println("Gradient Descent concluido com sucesso!")
}
