#L ============================================================================
#L Algoritmo: Laplacian Edge Detection (Segunda Derivada e Cruzamento por Zero)
#L Dominio: 08_artificial_intel / Subdominio: DeepLearningCV
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIADeepLearningCVLaplacianEdgeDetection) {
      println("=== Algoritmo: Laplacian 2nd Derivative ===")
      mut as int64: centerP = 20
      mut as int64: upP = 18
      mut as int64: downP = 19
      mut as int64: leftP = 21
      mut as int64: rightP = 22
      mut as int64: laplacianVal = upP + downP + leftP + rightP - 4 * centerP
      println("1. Resposta Laplaciana: " + laplacianVal)
      println("Teste concluido com sucesso.")
}
