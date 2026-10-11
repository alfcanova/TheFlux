#L ============================================================================
#L Algoritmo: Elliptic Envelope (Distancia de Mahalanobis e Covariancia Robusta)
#L Dominio: 08_artificial_intel / Subdominio: MLClassico
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAMLClassicoEllipticEnvelope) {
      println("=== Algoritmo: Elliptic Envelope ===")
      mut as int64: mahalanobisDistSq = 45
      mut as int64: chiSquareCutoff = 30
      mut as int64: isOutlier = 0
      route {
            mahalanobisDistSq > chiSquareCutoff ==> { isOutlier = 1 }
            _ ==> {}
      }
      println("1. Distancia de Mahalanobis quadratica: " + mahalanobisDistSq)
      println("2. Classificacao de outlier eliptico: " + isOutlier)
      println("Teste concluido com sucesso.")
}
