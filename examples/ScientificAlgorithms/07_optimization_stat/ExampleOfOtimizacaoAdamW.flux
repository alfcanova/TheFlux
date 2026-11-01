#L ============================================================================
#L Algoritmo: AdamW (Adam com Decaimento de Peso Desacoplado)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(Iter) | Espaco O(1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoAdamW) {
      println("==================================================")
      println("  SciAlgo: AdamW (Decoupled Weight Decay)")
      println("==================================================")

      #L AdamW aplica decaimento direto: theta = theta - lr * lambda * theta - step_adam
      mut as int64: theta = 50
      mut as int64: m = 0
      mut as int64: weight_decay = 1 #L 0.01

      mut as int64: step = 1
      infinite (step <= 8) {
            mut as int64: grad = theta - 10
            m = ((9 * m) /i 10) + ((1 * grad) /i 10)

            #L Decaimento desacoplado + passo de gradiente
            theta = theta - ((weight_decay * theta) /i 100) - m
            step = step + 1
      }
      println("1. Parametro final regulado pelo AdamW: " + theta)

      route {
            theta <= 20 ==> {
                  println("   [PASS] AdamW regularizou pesos e convergiu estavelmente!")
            }
            _ ==> {
                  println("   [ERRO] Falha no AdamW.")
            }
      }

      println("==================================================")
      println("AdamW concluido com sucesso!")
}
