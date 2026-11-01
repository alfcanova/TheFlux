#L ============================================================================
#L Algoritmo: Fast R-CNN (Extracao Compartilhada de Features e RoI Pooling)
#L Dominio: 08_artificial_intel / Subdominio: DeepLearningCV
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIADeepLearningCVFastRCNN) {
      println("=== Algoritmo: Fast R-CNN RoIPooling ===")
      mut as int64: roiHeight = 7
      mut as int64: roiWidth = 7
      mut as int64: pooledFeatureDim = roiHeight * roiWidth
      println("1. Dimensao espacial fixa do vetor RoI: " + pooledFeatureDim)
      println("Teste concluido com sucesso.")
}
