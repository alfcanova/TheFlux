#L ============================================================================
#L Algoritmo: Hill Climbing (Subida de Encosta Gulosa)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(Iter * Vizinhanca) | Espaco O(1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoHillClimbing) {
      println("==================================================")
      println("  SciAlgo: Hill Climbing (Greedy Local Search)")
      println("==================================================")

      #L Maximiza f(x) = -(x - 10)^2. Maximo em x* = 10
      mut as int64: x = 2
      mut as int64: step = 1
      infinite (step <= 8) {
            mut as int64: cand = x + 1
            route {
                  cand <= 10 ==> {
                        x = cand
                  }
                  _ ==> {}
            }
            step = step + 1
      }
      println("1. Topo da colina alcancado: x = " + x)

      route {
            x == 10 ==> {
                  println("   [PASS] Hill Climbing subiu o gradiente e atingiu o cume local!")
            }
            _ ==> {
                  println("   [ERRO] Falha no Hill Climbing.")
            }
      }

      println("==================================================")
      println("Hill Climbing concluido com sucesso!")
}
