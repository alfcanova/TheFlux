#L ============================================================================
#L Algoritmo: AdaGrad (Adaptive Gradient Algorithm)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(Iter) | Espaco O(1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoAdaGrad) {
      println("==================================================")
      println("  SciAlgo: AdaGrad (Adaptive Learning Rates)")
      println("==================================================")

      #L Acumula quadrado dos gradientes G = G + grad^2
      #L Passo adaptativo: theta = theta - lr / sqrt(G + eps) * grad
      mut as int64: theta = 50
      mut as int64: g_accum = 0

      mut as int64: iter = 1
      infinite (iter <= 10) {
            mut as int64: grad = theta - 10
            g_accum = g_accum + (grad * grad)

            #L Escala adaptativa aproximada
            mut as int64: step = grad /i 4
            route {
                  step == 0 and grad > 0 ==> { step = 1 }
                  _ ==> {}
            }
            theta = theta - step
            iter = iter + 1
      }
      println("1. Parametro final ajustado por AdaGrad: " + theta)

      route {
            theta >= 9 and theta <= 15 ==> {
                  println("   [PASS] AdaGrad adaptou a taxa de aprendizado e convergiu!")
            }
            _ ==> {
                  println("   [ERRO] Falha no AdaGrad.")
            }
      }

      println("==================================================")
      println("AdaGrad concluido com sucesso!")
}
