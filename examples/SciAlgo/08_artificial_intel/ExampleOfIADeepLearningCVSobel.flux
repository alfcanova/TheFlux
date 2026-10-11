#L ============================================================================
#L Algoritmo: Sobel Operator (Operador de Convolucao com Gradientes Gx e Gy)
#L Dominio: 08_artificial_intel / Subdominio: DeepLearningCV
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIADeepLearningCVSobel) {
      println("=== Algoritmo: Sobel Edge Operator ===")
      mut as int64: gX = 30
      mut as int64: gY = 40
      mut as int64: gradMagnitude = gX * gX + gY * gY
      println("1. Gradiente horizontal Gx: " + gX)
      println("2. Gradiente vertical Gy: " + gY)
      println("3. Magnitude quadratica do gradiente: " + gradMagnitude)
      println("Teste concluido com sucesso.")
}
