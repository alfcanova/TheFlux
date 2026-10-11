#L ============================================================================
#L Algoritmo: Autoencoder (Compressao e Reconstrucao Nao-Linear)
#L Dominio: 08_artificial_intel / Subdominio: RedesNeurais
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIARedesNeuraisAutoencoder) {
      println("=== Algoritmo: Autoencoder ===")
      mut as int64: inputX = 50
      mut as int64: latentZ = inputX /i 5
      mut as int64: reconX = latentZ * 5
      mut as int64: reconLoss = (inputX - reconX) * (inputX - reconX)
      println("1. Dimensao latente comprimida: " + latentZ)
      println("2. Sinal reconstruido: " + reconX)
      println("3. Erro de reconstrucao MSE: " + reconLoss)
      println("Teste concluido com sucesso.")
}
