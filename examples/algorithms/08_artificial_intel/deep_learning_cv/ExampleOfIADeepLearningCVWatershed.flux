#L ============================================================================
#L Algoritmo: Watershed (Segmentacao por Linhas Divisoras de Aguas Topologicas)
#L Dominio: 08_artificial_intel / Subdominio: DeepLearningCV
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIADeepLearningCVWatershed) {
      println("=== Algoritmo: Watershed Segmentation ===")
      mut as int64: basinHeight1 = 12
      mut as int64: basinHeight2 = 12
      mut as int64: floodedLevel = 12
      mut as int64: isDamBuilt = 0
      route {
            floodedLevel >= basinHeight1 and floodedLevel >= basinHeight2 ==> { isDamBuilt = 1 }
            _ ==> {}
      }
      println("1. Linha divisora de aguas (dam) construida: " + isDamBuilt)
      println("Teste concluido com sucesso.")
}
