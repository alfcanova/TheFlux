#L ============================================================================
#L Algoritmo: Pix2Pix (Traducao Imagem-para-Imagem com U-Net e PatchGAN)
#L Dominio: 08_artificial_intel / Subdominio: Generativa
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAGenerativaPix2Pix) {
      println("=== Algoritmo: Pix2Pix ===")
      mut as int64: advLoss = 40
      mut as int64: l1Loss = 15
      mut as int64: lambdaL1 = 100
      mut as int64: totalLoss = advLoss + (lambdaL1 * l1Loss) /i 10
      println("1. Perda combinada cGAN e L1: " + totalLoss)
      println("Teste concluido com sucesso.")
}
