#L ============================================================================
#L Algoritmo: Floyd-Steinberg Dithering (Difusao de Erro de Quantizacao)
#L Dominio: 08_artificial_intel / Subdominio: DeepLearningCV
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIADeepLearningCVFloydSteinbergDithering) {
      println("=== Algoritmo: Floyd-Steinberg Dithering ===")
      mut as int64: oldPixel = 180
      mut as int64: newPixel = 255
      mut as int64: quantError = oldPixel - newPixel
      mut as int64: errorRight = (quantError * 7) /i 16
      mut as int64: errorDownLeft = (quantError * 3) /i 16
      mut as int64: errorDown = (quantError * 5) /i 16
      mut as int64: errorDownRight = (quantError * 1) /i 16
      println("1. Erro de quantizacao difundido: " + quantError)
      println("2. Parcela difundida para a direita (7/16): " + errorRight)
      println("Teste concluido com sucesso.")
}
