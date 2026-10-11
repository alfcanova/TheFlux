#L ============================================================================
#L Algoritmo: ResNet (Deep Residual Network com Conexoes de Salto Skip/Identity)
#L Dominio: 08_artificial_intel / Subdominio: DeepLearningCV
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIADeepLearningCVResNet) {
      println("=== Algoritmo: ResNet Residual Block ===")
      mut as int64: identityX = 40
      mut as int64: residualFX = 8
      mut as int64: resOutput = identityX + residualFX
      println("1. Mapeamento de identidade x: " + identityX)
      println("2. Mapeamento residual F(x): " + residualFX)
      println("3. Saida do bloco residual F(x) + x: " + resOutput)
      println("Teste concluido com sucesso.")
}
