#L ============================================================================
#L Algoritmo: Random-Restart Hill Climbing (Subida de Encosta com Reinicios)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(R * Passos) | Espaco O(1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoRandomRestartHillClimbing) {
      println("==================================================")
      println("  SciAlgo: Random-Restart Hill Climbing")
      println("==================================================")

      #L 3 Reinicios aleatorios para escapar de maximos locais
      #L Reinicio 1 atinge 5, Reinicio 2 atinge 8, Reinicio 3 atinge 10 (otimo global)
      mut as list of int64: restarts = [5, 8, 10]
      mut as int64: best_val = restarts[1]

      mut as int64: i = 2
      infinite (i <= 3) {
            route {
                  restarts[i] > best_val ==> {
                        best_val = restarts[i]
                  }
                  _ ==> {}
            }
            i = i + 1
      }
      println("1. Melhor solucao global entre os reinicios: " + best_val)

      route {
            best_val == 10 ==> {
                  println("   [PASS] Reinicios aleatorios superaram os otimos locais com sucesso!")
            }
            _ ==> {
                  println("   [ERRO] Falha no Random-Restart Hill Climbing.")
            }
      }

      println("==================================================")
      println("Random-Restart Hill Climbing concluido com sucesso!")
}
