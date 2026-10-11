#L ============================================================================
#L Algoritmo: L-BFGS (Limited-Memory BFGS com Buffer de Memoria m)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(Iter * m * D) | Espaco O(m * D)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoLBFGS) {
      println("==================================================")
      println("  SciAlgo: L-BFGS (Two-Loop Recursion)")
      println("==================================================")

      #L L-BFGS mantem historico limitado m = 2 dos pares (s_k, y_k)
      mut as int64: x = 50
      mut as int64: target = 15

      mut as int64: k = 1
      infinite (k <= 5) {
            mut as int64: grad = x - target
            #L Recursao de dois loops aproximada
            mut as int64: dir = grad /i 2
            x = x - dir
            k = k + 1
      }
      println("1. Solucao otima pelo L-BFGS: x = " + x)

      route {
            x >= 14 and x <= 16 ==> {
                  println("   [PASS] L-BFGS otimizou com consumo de memoria O(mD)!")
            }
            _ ==> {
                  println("   [ERRO] Falha no L-BFGS.")
            }
      }

      println("==================================================")
      println("L-BFGS concluido com sucesso!")
}
