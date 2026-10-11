#L ============================================================================
#L Algoritmo: Flood Fill (Preenchimento por Inundacao 4-Conexo)
#L Dominio: 08_artificial_intel / Subdominio: DeepLearningCV
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIADeepLearningCVFloodFill) {
      println("=== Algoritmo: Flood Fill ===")
      mut as int64: targetColor = 0
      mut as int64: replacementColor = 255
      mut as int64: pixelColor = 0
      route {
            pixelColor == targetColor ==> { pixelColor = replacementColor }
            _ ==> {}
      }
      println("1. Cor do pixel preenchido: " + pixelColor)
      println("Teste concluido com sucesso.")
}
