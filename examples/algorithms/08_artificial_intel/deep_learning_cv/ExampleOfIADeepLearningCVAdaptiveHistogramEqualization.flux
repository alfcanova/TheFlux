#L ============================================================================
#L Algoritmo: Adaptive Histogram Equalization (AHE / CLAHE com Limitacao de Contraste)
#L Dominio: 08_artificial_intel / Subdominio: DeepLearningCV
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIADeepLearningCVAdaptiveHistogramEqualization) {
      println("=== Algoritmo: Adaptive Histogram Equalization ===")
      mut as int64: localBinCount = 45
      mut as int64: clipLimit = 30
      mut as int64: clippedBin = localBinCount
      route {
            localBinCount > clipLimit ==> { clippedBin = clipLimit }
            _ ==> {}
      }
      println("1. Contagem do bin truncada pelo clip limit: " + clippedBin)
      println("Teste concluido com sucesso.")
}
