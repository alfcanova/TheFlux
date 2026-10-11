#L ============================================================================
#L Algoritmo: Ridge Regression (Regressao com Penalizacao L2 Tikhonov)
#L Dominio: 08_artificial_intel / Subdominio: MLClassico
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAMLClassicoRidgeRegression) {
      println("=== Algoritmo: Ridge Regression L2 ===")
      mut as int64: lambdaParam = 10
      mut as int64: xVar = 50
      mut as int64: xyCov = 120
      mut as int64: ridgeBeta = (xyCov * 100) /i (xVar + lambdaParam)
      println("1. Fator regularizador lambda: " + lambdaParam)
      println("2. Coeficiente encolhido Ridge: " + ridgeBeta)
      println("Teste concluido com sucesso.")
}
