#L ============================================================================
#L Algoritmo: Mini-Batch Gradient Descent (Gradiente em Lotes Pequenos)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(Epocas * (N / B)) | Espaco O(B)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoMiniBatchSGD) {
      println("==================================================")
      println("  SciAlgo: Mini-Batch Gradient Descent")
      println("==================================================")

      #L Mini-lote de tamanho B = 2: gradiente medio entre duas observacoes
      mut as int64: theta = 50
      mut as int64: target = 10

      mut as int64: step = 1
      infinite (step <= 10) {
            #L Erro de duas amostras do mini-lote
            mut as int64: g1 = theta - target
            mut as int64: g2 = (theta - target) + 2
            mut as int64: avg_grad = (g1 + g2) /i 2

            theta = theta - ((avg_grad * 3) /i 10)
            step = step + 1
      }
      println("1. Parametro convergido por Mini-Batch: " + theta)

      route {
            theta >= 8 and theta <= 12 ==> {
                  println("   [PASS] Mini-Batch SGD convergiu com estabilidade!")
            }
            _ ==> {
                  println("   [ERRO] Divergencia no Mini-Batch SGD.")
            }
      }

      println("==================================================")
      println("Mini-Batch Gradient Descent concluido com sucesso!")
}
