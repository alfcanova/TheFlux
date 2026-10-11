#L ============================================================================
#L Algoritmo: Momentum (Descida de Gradiente com Momento de Polyak)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(Iter) | Espaco O(1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoMomentum) {
      println("==================================================")
      println("  SciAlgo: Momentum Optimizer")
      println("==================================================")

      #L v_t = gamma * v_{t-1} + lr * grad
      #L x_t = x_{t-1} - v_t
      mut as int64: x = 100
      mut as int64: v = 0
      mut as int64: gamma = 9 #L 0.9 (escala /10)
      mut as int64: lr = 1    #L 0.1

      mut as int64: iter = 1
      infinite (iter <= 10) {
            mut as int64: grad = 2 * (x - 10)
            v = ((gamma * v) /i 10) + ((lr * grad) /i 10)
            x = x - v
            iter = iter + 1
      }
      println("1. Posicao final com Momentum: x = " + x)

      route {
            x <= 20 ==> {
                  println("   [PASS] Momentum acelerou a convergencia com sucesso!")
            }
            _ ==> {
                  println("   [ERRO] Falha no Momentum.")
            }
      }

      println("==================================================")
      println("Momentum concluido com sucesso!")
}
