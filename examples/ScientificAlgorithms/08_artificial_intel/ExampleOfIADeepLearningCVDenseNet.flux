#L ============================================================================
#L Algoritmo: DenseNet (Densely Connected Convolutional Networks)
#L Dominio: 08_artificial_intel / Subdominio: DeepLearningCV
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIADeepLearningCVDenseNet) {
      println("=== Algoritmo: DenseNet Growth Rate ===")
      mut as int64: kGrowth = 32
      mut as int64: numLayersInBlock = 4
      mut as int64: initialChannels = 64
      mut as int64: finalChannels = initialChannels + numLayersInBlock * kGrowth
      println("1. Taxa de crescimento k: " + kGrowth)
      println("2. Total de canais acumulados no bloco denso: " + finalChannels)
      println("Teste concluido com sucesso.")
}
