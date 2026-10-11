#L ============================================================================
#L Algoritmo: FCN (Fully Convolutional Network para Segmentacao Semantica)
#L Dominio: 08_artificial_intel / Subdominio: DeepLearningCV
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIADeepLearningCVFCN) {
      println("=== Algoritmo: Fully Convolutional Network ===")
      mut as int64: strideTranspose = 8
      mut as int64: featureMapDim = 16
      mut as int64: restoredImageDim = featureMapDim * strideTranspose
      println("1. Fator de upsampling (FCN-8s): " + strideTranspose)
      println("2. Resolucao restaurada da mascara: " + restoredImageDim)
      println("Teste concluido com sucesso.")
}
