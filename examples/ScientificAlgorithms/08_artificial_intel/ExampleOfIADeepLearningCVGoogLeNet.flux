#L ============================================================================
#L Algoritmo: GoogLeNet (Inception v1 com Modulos Multi-Escala)
#L Dominio: 08_artificial_intel / Subdominio: DeepLearningCV
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIADeepLearningCVGoogLeNet) {
      println("=== Algoritmo: GoogLeNet Inception ===")
      mut as int64: c1x1 = 64
      mut as int64: c3x3 = 128
      mut as int64: c5x5 = 32
      mut as int64: poolProj = 32
      mut as int64: totalConcatChannels = c1x1 + c3x3 + c5x5 + poolProj
      println("1. Canais concatenados na saida do modulo Inception: " + totalConcatChannels)
      println("Teste concluido com sucesso.")
}
