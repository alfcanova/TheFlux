#L ============================================================================
#L Algoritmo: GAN (Generative Adversarial Network - Minimax)
#L Dominio: 08_artificial_intel / Subdominio: Generativa
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAGenerativaGAN) {
      println("=== Algoritmo: Generative Adversarial Network ===")
      mut as int64: dReal = 90
      mut as int64: dFake = 15
      mut as int64: gLoss = 100 - dFake
      mut as int64: dLoss = (100 - dReal + dFake) /i 2
      println("1. Pontuacao do discriminador para amostra real: " + dReal)
      println("2. Perda do gerador: " + gLoss)
      println("3. Perda do discriminador: " + dLoss)
      println("Teste concluido com sucesso.")
}
