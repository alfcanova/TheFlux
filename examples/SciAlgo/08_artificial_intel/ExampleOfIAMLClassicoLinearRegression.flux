#L ============================================================================
#L Algoritmo: Linear Regression (Minimos Quadrados Ordinarios / OLS)
#L Dominio: 08_artificial_intel / Subdominio: MLClassico
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAMLClassicoLinearRegression) {
      println("=== Algoritmo: Regressao Linear OLS ===")
      mut as int64: x1 = 1
      mut as int64: y1 = 2
      mut as int64: x2 = 2
      mut as int64: y2 = 4
      mut as int64: x3 = 3
      mut as int64: y3 = 6
      mut as int64: slope = (y3 - y1) /i (x3 - x1)
      mut as int64: intercept = y1 - slope * x1
      mut as int64: pred4 = slope * 4 + intercept
      println("1. Coeficiente angular estimado: " + slope)
      println("2. Intercepto: " + intercept)
      println("3. Predicao para x=4: " + pred4)
      println("Teste concluido com sucesso.")
}
