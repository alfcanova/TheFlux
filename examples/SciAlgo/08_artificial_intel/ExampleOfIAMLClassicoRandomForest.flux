#L ============================================================================
#L Algoritmo: Random Forest (Florestas Aleatorias com Ensacamento de Arvores)
#L Dominio: 08_artificial_intel / Subdominio: MLClassico
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAMLClassicoRandomForest) {
      println("=== Algoritmo: Random Forest ===")
      mut as list of int64: treeVotes = [1, 1, 0, 1, 0]
      mut as int64: onesCount = 0
      mut as int64: i = 1
      infinite (i <= 5) {
            route {
                  treeVotes[i] == 1 ==> { onesCount = onesCount + 1 }
                  _ ==> {}
            }
            i = i + 1
      }
      mut as int64: ensemblePred = 0
      route {
            onesCount >= 3 ==> { ensemblePred = 1 }
            _ ==> {}
      }
      println("1. Votos positivos entre 5 arvores: " + onesCount)
      println("2. Voto majoritario da floresta: " + ensemblePred)
      println("Teste concluido com sucesso.")
}
