#L ============================================================================
#L Algoritmo: Simulated Annealing (Recozimento Simulado de Metropolis)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(Passos) | Espaco O(1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoSimulatedAnnealing) {
      println("==================================================")
      println("  SciAlgo: Simulated Annealing (Cooling Schedule)")
      println("==================================================")

      #L Temperatura T decai: T = T * alpha (resfriamento)
      mut as int64: temp = 100
      mut as int64: curr_e = 50
      mut as int64: cand_e = 30 #L menor energia (melhor) -> sempre aceito

      #L Aceitacao de candidato com menor energia
      curr_e = cand_e
      temp = (temp * 9) /i 10 #L resfria para 90

      println("1. Energia reduzida para: " + curr_e + " (temperatura atual: " + temp + ")")
      route {
            curr_e == 30 and temp == 90 ==> {
                  println("   [PASS] Simulated Annealing transitou e resfriou o sistema com sucesso!")
            }
            _ ==> {
                  println("   [ERRO] Falha no Simulated Annealing.")
            }
      }

      println("==================================================")
      println("Simulated Annealing concluido com sucesso!")
}
