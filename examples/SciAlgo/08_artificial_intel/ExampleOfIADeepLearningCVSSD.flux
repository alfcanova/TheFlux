#L ============================================================================
#L Algoritmo: SSD (Single Shot MultiBox Detector em Multiplas Escalas)
#L Dominio: 08_artificial_intel / Subdominio: DeepLearningCV
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIADeepLearningCVSSD) {
      println("=== Algoritmo: Single Shot MultiBox Detector ===")
      mut as int64: numFeatureMaps = 6
      mut as int64: defaultBoxesPerMap = 4
      mut as int64: totalBoxProposals = numFeatureMaps * defaultBoxesPerMap * 100
      println("1. Mapas de caracteristicas piramidais: " + numFeatureMaps)
      println("2. Total aproximado de caixas ancoras: " + totalBoxProposals)
      println("Teste concluido com sucesso.")
}
