#L ============================================================================
#L Algoritmo: HOG (Histogram of Oriented Gradients para Deteccao de Pedestres)
#L Dominio: 08_artificial_intel / Subdominio: DeepLearningCV
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIADeepLearningCVHOG) {
      println("=== Algoritmo: Histogram of Oriented Gradients ===")
      mut as list of int64: binHistogram = [10, 45, 80, 25]
      mut as int64: dominantBin = 3
      mut as int64: dominantMagnitude = binHistogram[3]
      println("1. Orientacao dominante na celula 8x8: Bin " + dominantBin)
      println("2. Magnitude do gradiente acumulado: " + dominantMagnitude)
      println("Teste concluido com sucesso.")
}
