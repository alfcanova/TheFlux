#L ============================================================================
#L Algoritmo: Polynomial Regression (Regressao com Expansao Polinomial)
#L Dominio: 08_artificial_intel / Subdominio: MLClassico
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAMLClassicoPolynomialRegression) {
      println("=== Algoritmo: Regressao Polinomial Grau 2 ===")
      mut as int64: xVal = 4
      mut as int64: a2 = 2
      mut as int64: a1 = 3
      mut as int64: a0 = 5
      mut as int64: yPred = a2 * xVal * xVal + a1 * xVal + a0
      println("1. Entrada x: " + xVal)
      println("2. Predicao polinomial quadratica: " + yPred)
      println("Teste concluido com sucesso.")
}
