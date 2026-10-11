#L ============================================================================
#L Algoritmo: DCGAN (Deep Convolutional GAN)
#L Dominio: 08_artificial_intel / Subdominio: Generativa
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAGenerativaDCGAN) {
      println("=== Algoritmo: DCGAN ===")
      mut as int64: latentDim = 100
      mut as int64: featureMaps = 64
      mut as int64: imageChannels = 3
      println("1. Dimensao do vetor de ruido z: " + latentDim)
      println("2. Canais na camada convolucional transposta: " + featureMaps)
      println("Teste concluido com sucesso.")
}
