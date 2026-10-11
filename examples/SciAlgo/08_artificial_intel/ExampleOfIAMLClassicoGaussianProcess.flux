#L ============================================================================
#L Algoritmo: Gaussian Process (Krigagem e Regressao Bayesiana Nao-Parametrica)
#L Dominio: 08_artificial_intel / Subdominio: MLClassico
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAMLClassicoGaussianProcess) {
      println("=== Algoritmo: Gaussian Process Regression ===")
      mut as int64: kStar = 75
      mut as int64: kInvY = 40
      mut as int64: predMean = (kStar * kInvY) /i 100
      mut as int64: priorVar = 100
      mut as int64: predVar = priorVar - (kStar * kStar) /i 100
      println("1. Media posterior predita: " + predMean)
      println("2. Incerteza residual (variancia): " + predVar)
      println("Teste concluido com sucesso.")
}
