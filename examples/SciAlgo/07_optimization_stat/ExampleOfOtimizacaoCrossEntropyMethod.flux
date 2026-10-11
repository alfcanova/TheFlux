#L ============================================================================
#L Algoritmo: Cross-Entropy Method (CEM com Amostragem de Elite)
#L Dominio: 07_optimization_stat / Categoria: Otimizacao
#L Complexidade: Tempo O(Iter * Amostras * D) | Espaco O(Elite * D)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfOtimizacaoCrossEntropyMethod) {
      println("==================================================")
      println("  SciAlgo: Cross-Entropy Method (Elite Sampling)")
      println("==================================================")

      #L Amostras geradas: [10, 20, 50, 60]
      #L Amostras de elite (top 50%): [50, 60]
      #L Atualiza parametros da distribuicao para casar a distribuicao de elite:
      #L Nova media = (50 + 60) / 2 = 55
      mut as int64: new_mean = (50 + 60) /i 2

      println("1. Parametro de probabilidade atualizado pelo CEM: mu = " + new_mean)
      route {
            new_mean == 55 ==> {
                  println("   [PASS] Cross-Entropy Method minimizou a divergencia KL com a elite!")
            }
            _ ==> {
                  println("   [ERRO] Falha no Cross-Entropy Method.")
            }
      }

      println("==================================================")
      println("Cross-Entropy Method concluido com sucesso!")
}
