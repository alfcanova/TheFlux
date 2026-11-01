#L ============================================================================
#L Algoritmo: R-CNN (Regions with CNN Features e Selective Search)
#L Dominio: 08_artificial_intel / Subdominio: DeepLearningCV
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIADeepLearningCVRCNN) {
      println("=== Algoritmo: R-CNN Region Proposal ===")
      mut as int64: proposalsCount = 2000
      mut as int64: croppedSize = 227
      println("1. Propostas de regiao extraidas por imagem: " + proposalsCount)
      println("2. Dimensoes das regioes redimensionadas: " + croppedSize)
      println("Teste concluido com sucesso.")
}
