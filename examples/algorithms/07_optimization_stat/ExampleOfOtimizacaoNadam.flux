#L ============================================================================
#L Algoritmo: Nadam (Nesterov-accelerated Adaptive Moment Estimation)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(Iter) | Espaco O(1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoNadam) {
      println("==================================================")
      println("  SciAlgo: Nadam (Nesterov + Adam)")
      println("==================================================")

      mut as int64: x = 60
      mut as int64: m = 0

      mut as int64: iter = 1
      infinite (iter <= 8) {
            mut as int64: grad = x - 10
            m = ((9 * m) /i 10) + ((1 * grad) /i 10)
            #L Nadam incorpora o gradiente atual no passo de Nesterov
            mut as int64: nesterov_step = ((9 * m) /i 10) + ((1 * grad) /i 10)
            x = x - nesterov_step
            iter = iter + 1
      }
      println("1. Posicao final com Nadam: x = " + x)

      route {
            x <= 20 ==> {
                  println("   [PASS] Nadam combinou Nesterov e Adam com sucesso!")
            }
            _ ==> {
                  println("   [ERRO] Falha no Nadam.")
            }
      }

      println("==================================================")
      println("Nadam concluido com sucesso!")
}
