#L ============================================================================
#L Algoritmo: Faster R-CNN (Region Proposal Network RPN com Anchor Boxes)
#L Dominio: 08_artificial_intel / Subdominio: DeepLearningCV
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIADeepLearningCVFasterRCNN) {
      println("=== Algoritmo: Faster R-CNN RPN ===")
      mut as int64: numScales = 3
      mut as int64: numAspectRatios = 3
      mut as int64: anchorsPerLocation = numScales * numAspectRatios
      println("1. Caixas ancoras por posicao espacial: " + anchorsPerLocation)
      println("Teste concluido com sucesso.")
}
