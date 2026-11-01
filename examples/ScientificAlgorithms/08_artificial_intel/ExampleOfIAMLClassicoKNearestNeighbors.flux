#L ============================================================================
#L Algoritmo: K-Nearest Neighbors (K-NN com Voto Majoritario)
#L Dominio: 08_artificial_intel / Subdominio: MLClassico
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAMLClassicoKNearestNeighbors) {
      println("=== Algoritmo: K-Nearest Neighbors ===")
      mut as list of int64: neighborDist = [5, 8, 12]
      mut as list of int64: neighborClass = [1, 1, 0]
      mut as int64: votes1 = 0
      mut as int64: i = 1
      infinite (i <= 3) {
            route {
                  neighborClass[i] == 1 ==> { votes1 = votes1 + 1 }
                  _ ==> {}
            }
            i = i + 1
      }
      mut as int64: assignedClass = 0
      route {
            votes1 >= 2 ==> { assignedClass = 1 }
            _ ==> {}
      }
      println("1. Votos para classe 1 (k=3): " + votes1)
      println("2. Classe atribuida pelo KNN: " + assignedClass)
      println("Teste concluido com sucesso.")
}
