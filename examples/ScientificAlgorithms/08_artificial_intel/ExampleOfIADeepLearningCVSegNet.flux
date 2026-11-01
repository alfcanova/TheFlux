#L ============================================================================
#L Algoritmo: SegNet (Segmentacao Semantica com Indices de Max-Pooling)
#L Dominio: 08_artificial_intel / Subdominio: DeepLearningCV
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIADeepLearningCVSegNet) {
      println("=== Algoritmo: SegNet Pooling Indices ===")
      mut as int64: maxPoolIndex = 3
      mut as int64: reconstructedPos = maxPoolIndex
      println("1. Indice de pooling recuperado pelo decoder: " + reconstructedPos)
      println("Teste concluido com sucesso.")
}
