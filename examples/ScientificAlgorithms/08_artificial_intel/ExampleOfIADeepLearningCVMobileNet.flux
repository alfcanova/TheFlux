#L ============================================================================
#L Algoritmo: MobileNet (Convolucoes Separaveis em Profundidade Depthwise Separable)
#L Dominio: 08_artificial_intel / Subdominio: DeepLearningCV
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIADeepLearningCVMobileNet) {
      println("=== Algoritmo: MobileNet Depthwise Separable ===")
      mut as int64: depthwiseCost = 9
      mut as int64: pointwiseCost = 64
      mut as int64: separableCost = depthwiseCost + pointwiseCost
      mut as int64: standardConvCost = 9 * 64
      mut as int64: efficiencyPct = (separableCost * 100) /i standardConvCost
      println("1. Custo convolucao separavel: " + separableCost)
      println("2. Custo convolucao padrao: " + standardConvCost)
      println("3. Fracao de computacao necessaria (%): " + efficiencyPct)
      println("Teste concluido com sucesso.")
}
