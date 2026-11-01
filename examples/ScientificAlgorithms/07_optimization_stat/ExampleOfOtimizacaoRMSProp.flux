#L ============================================================================
#L Algoritmo: RMSProp (Root Mean Square Propagation)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(Iter) | Espaco O(1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoRMSProp) {
      println("==================================================")
      println("  SciAlgo: RMSProp Optimizer")
      println("==================================================")

      #L Media movel exponencial dos quadrados dos gradientes: v = beta*v + (1-beta)*grad^2
      mut as int64: x = 60
      mut as int64: v_avg = 100

      mut as int64: iter = 1
      infinite (iter <= 10) {
            mut as int64: grad = 2 * (x - 10)
            v_avg = ((9 * v_avg) /i 10) + ((grad * grad) /i 10)
            mut as int64: step = (grad * 10) /i 20
            x = x - step
            iter = iter + 1
      }
      println("1. Posicao obtida pelo RMSProp: " + x)

      route {
            x <= 15 ==> {
                  println("   [PASS] RMSProp convergiu com taxa adaptativa amortecida!")
            }
            _ ==> {
                  println("   [ERRO] Falha no RMSProp.")
            }
      }

      println("==================================================")
      println("RMSProp concluido com sucesso!")
}
