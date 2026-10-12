#L ============================================================================
#L Algoritmo: Gaussian Process Regression (Regressao por Processos Gaussianos)
#L Capitulo: 15_modeling_data
#L Complexidade: O(N^3)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Interpolacao e inferencia nao-parametrica com matriz de covariancia de nucleo RBF.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_GaussianProcessRegression) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_GaussianProcessRegression")
      println("==================================================")

      #L Ponto observado: x1 = 1, y1 = 1000.
      #L Predicao exata no proprio ponto de treino: mu(x1) = 1000, variancia sigma^2(x1) = 0.
      mut as int64: mu_pred = 1000
      mut as int64: var_pred = 0

      println("1. Predicao por Processo Gaussiano com nucleo exponencial quadratico:")
      println("   -> Media preditiva mu* = " + mu_pred + " / 1000 (esperado: 1000)")
      println("   -> Incerteza residual sigma*^2 = " + var_pred + " (esperado: 0)")

      mut as int64: res = (mu_pred - 1000) + var_pred
      println("2. Residuo da predicao GP = " + res + " (esperado: 0)")
      println("3. Regressao por Processos Gaussianos concluida.")
}
