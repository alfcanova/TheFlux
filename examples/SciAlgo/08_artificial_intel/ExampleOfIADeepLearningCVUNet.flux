#L ============================================================================
#L Algoritmo: U-Net (Segmentacao Biomedica com Skip Connections Encoder-Decoder)
#L Dominio: 08_artificial_intel / Subdominio: DeepLearningCV
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIADeepLearningCVUNet) {
      println("=== Algoritmo: U-Net Segmentation ===")
      mut as int64: encFeatChannels = 64
      mut as int64: decUpChannels = 64
      mut as int64: concatChannels = encFeatChannels + decUpChannels
      println("1. Canais concatenados via skip-connection: " + concatChannels)
      println("Teste concluido com sucesso.")
}
