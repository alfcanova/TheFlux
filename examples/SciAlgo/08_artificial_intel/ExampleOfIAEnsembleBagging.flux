#L ============================================================================
#L Algoritmo: Bagging (Bootstrap Aggregating)
#L Dominio: 08_artificial_intel / Subdominio: Ensemble
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAEnsembleBagging) {
      println("=== Algoritmo: Bagging Ensemble ===")
      mut as list of int64: preds = [1, 1, 0, 1, 0]
      mut as int64: sumOnes = 0
      mut as int64: i = 1
      infinite (i <= 5) {
            route {
                  preds[i] == 1 ==> { sumOnes = sumOnes + 1 }
                  _ ==> {}
            }
            i = i + 1
      }
      mut as int64: finalVote = 0
      route {
            sumOnes >= 3 ==> { finalVote = 1 }
            _ ==> {}
      }
      println("1. Votos positivos acumulados: " + sumOnes)
      println("2. Predicao agregada majoritaria: " + finalVote)
      println("Teste concluido com sucesso.")
}
