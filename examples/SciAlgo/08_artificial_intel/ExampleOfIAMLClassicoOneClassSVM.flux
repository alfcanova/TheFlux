#L ============================================================================
#L Algoritmo: One-Class SVM (Deteccao de Anomalias e Novidades)
#L Dominio: 08_artificial_intel / Subdominio: MLClassico
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAMLClassicoOneClassSVM) {
      println("=== Algoritmo: One-Class SVM ===")
      mut as int64: distanceToOrigin = 85
      mut as int64: rhoThreshold = 60
      mut as int64: isNovelty = 0
      route {
            distanceToOrigin < rhoThreshold ==> { isNovelty = 1 }
            _ ==> {}
      }
      println("1. Distancia projetada no espaco de kernel: " + distanceToOrigin)
      println("2. Deteccao de anomalia (1=Anomalo, 0=Inlier): " + isNovelty)
      println("Teste concluido com sucesso.")
}
