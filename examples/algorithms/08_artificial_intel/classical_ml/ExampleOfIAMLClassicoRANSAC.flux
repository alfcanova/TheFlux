#L ============================================================================
#L Algoritmo: RANSAC (Random Sample Consensus para Regressao Robusta)
#L Dominio: 08_artificial_intel / Subdominio: MLClassico
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAMLClassicoRANSAC) {
      println("=== Algoritmo: RANSAC ===")
      mut as int64: inliersCurrent = 85
      mut as int64: bestInlierCount = 70
      route {
            inliersCurrent > bestInlierCount ==> { bestInlierCount = inliersCurrent }
            _ ==> {}
      }
      println("1. Melhor contagem de inliers pelo consenso: " + bestInlierCount)
      println("Teste concluido com sucesso.")
}
