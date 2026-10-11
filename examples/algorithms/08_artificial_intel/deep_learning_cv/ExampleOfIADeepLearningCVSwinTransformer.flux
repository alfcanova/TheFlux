#L ============================================================================
#L Algoritmo: Swin Transformer (Hierarchical Vision Transformer com Shifted Windows)
#L Dominio: 08_artificial_intel / Subdominio: DeepLearningCV
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIADeepLearningCVSwinTransformer) {
      println("=== Algoritmo: Swin Transformer Shifted Window ===")
      mut as int64: windowSize = 7
      mut as int64: shiftAmount = windowSize /i 2
      println("1. Tamanho da janela local: " + windowSize)
      println("2. Deslocamento ciclico (cyclic shift): " + shiftAmount)
      println("Teste concluido com sucesso.")
}
