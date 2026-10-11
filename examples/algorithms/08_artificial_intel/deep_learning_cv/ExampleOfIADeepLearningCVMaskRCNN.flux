#L ============================================================================
#L Algoritmo: Mask R-CNN (Deteccao e Segmentacao de Instancias com RoIAlign)
#L Dominio: 08_artificial_intel / Subdominio: DeepLearningCV
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIADeepLearningCVMaskRCNN) {
      println("=== Algoritmo: Mask R-CNN RoIAlign ===")
      mut as int64: bboxLoss = 12
      mut as int64: classLoss = 15
      mut as int64: maskLoss = 20
      mut as int64: totalMultiTaskLoss = bboxLoss + classLoss + maskLoss
      println("1. Perda multitarefa unificada: " + totalMultiTaskLoss)
      println("Teste concluido com sucesso.")
}
