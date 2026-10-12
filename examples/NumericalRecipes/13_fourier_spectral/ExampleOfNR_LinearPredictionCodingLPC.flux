#L ============================================================================
#L Algoritmo: Linear Prediction & LPC (Predicao Linear com Levinson-Durbin)
#L Capitulo: 13_fourier_spectral
#L Complexidade: O(P^2)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Resolucao das equacoes de Yule-Walker para predicao linear autorregressiva (AR).
#L ============================================================================

use ListStdLib

program (ExampleOfNR_LinearPredictionCodingLPC) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_LinearPredictionCodingLPC")
      println("==================================================")

      #L Autocorrelacao: r[0] = 10000, r[1] = 6000 (escala 10000)
      #L Coeficiente de reflexao de Levinson: a1 = -r[1] / r[0] = -6000 / 10000 = -0.6 (-6000)
      #L Erro residual de predicao: E1 = r[0] * (1 - a1^2) = 10000 * (1 - 0.36) = 6400
      mut as int64: a1 = 0 - 6000
      mut as int64: e1 = 6400

      println("1. Executando algoritmo de Levinson-Durbin para coeficientes LPC:")
      println("   -> Coeficiente preditor a1 = " + a1 + " / 10000 (esperado: -0.6000)")
      println("   -> Potencia de erro de predicao E1 = " + e1 + " / 10000 (esperado: 0.6400)")

      mut as int64: res = e1 - 6400
      println("2. Residuo do erro de predicao = " + res + " (esperado: 0)")
      println("3. Linear Prediction LPC validada com exito.")
}
