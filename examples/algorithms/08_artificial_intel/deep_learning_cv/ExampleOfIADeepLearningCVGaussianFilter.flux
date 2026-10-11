#L ============================================================================
#L Algoritmo: Gaussian Filter (Filtro Gaussiano com Convolucao Espacial)
#L Dominio: 08_artificial_intel / Subdominio: DeepLearningCV
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIADeepLearningCVGaussianFilter) {
      println("=== Algoritmo: Gaussian Filter ===")
      mut as int64: pCenter = 50
      mut as int64: pLeft = 40
      mut as int64: pRight = 40
      mut as int64: blurredPixel = (pLeft * 1 + pCenter * 2 + pRight * 1) /i 4
      println("1. Pixel filtrado por kernel gaussiano [1, 2, 1]: " + blurredPixel)
      println("Teste concluido com sucesso.")
}
