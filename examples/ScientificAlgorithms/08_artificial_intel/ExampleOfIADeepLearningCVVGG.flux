#L ============================================================================
#L Algoritmo: VGG (Visual Geometry Group - Filtros 3x3 Homogeneos)
#L Dominio: 08_artificial_intel / Subdominio: DeepLearningCV
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIADeepLearningCVVGG) {
      println("=== Algoritmo: VGG-16 Architecture ===")
      mut as int64: numConvLayers = 13
      mut as int64: numFcLayers = 3
      mut as int64: totalLayers = numConvLayers + numFcLayers
      mut as int64: kernelReceptiveField = 3 + 2 + 2
      println("1. Total de camadas parametrizadas: " + totalLayers)
      println("2. Campo receptivo efetivo de 3 camadas 3x3: " + kernelReceptiveField)
      println("Teste concluido com sucesso.")
}
