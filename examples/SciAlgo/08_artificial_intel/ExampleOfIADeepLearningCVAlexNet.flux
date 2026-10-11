#L ============================================================================
#L Algoritmo: AlexNet (Convolucao Profunda com ReLU e Dropout)
#L Dominio: 08_artificial_intel / Subdominio: DeepLearningCV
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIADeepLearningCVAlexNet) {
      println("=== Algoritmo: AlexNet ===")
      mut as int64: imgSize = 224
      mut as int64: kSize = 11
      mut as int64: strideVal = 4
      mut as int64: outConv1 = (imgSize - kSize) /i strideVal + 1
      println("1. Tamanho do mapa de caracteristicas Conv1: " + outConv1)
      println("Teste concluido com sucesso.")
}
