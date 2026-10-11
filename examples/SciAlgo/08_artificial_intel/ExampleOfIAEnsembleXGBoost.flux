#L ============================================================================
#L Algoritmo: XGBoost (Extreme Gradient Boosting com Regularizacao L2)
#L Dominio: 08_artificial_intel / Subdominio: Ensemble
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAEnsembleXGBoost) {
      println("=== Algoritmo: XGBoost ===")
      mut as int64: g = 0 - 30
      mut as int64: h = 20
      mut as int64: lambdaReg = 5
      mut as int64: optimalWeight = (0 - g * 100) /i (h + lambdaReg)
      mut as int64: gain = (g * g * 100) /i (h + lambdaReg)
      println("1. Peso otimo da folha: " + optimalWeight)
      println("2. Ganho de divisao estrutural: " + gain)
      println("Teste concluido com sucesso.")
}
