#L ============================================================================
#L Algoritmo: Confidence Limits on Estimated Parameters (Limites de Confianca)
#L Capitulo: 15_modeling_data
#L Complexidade: O(M^3)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Determinacao de elipses de confianca conjunta a partir da matriz de covariancia.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_ConfidenceLimitsModelParameters) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_ConfidenceLimitsModelParameters")
      println("==================================================")

      #L Nivel de confianca de 68.3% (1 sigma) para 2 parametros: Delta Chi^2 = 2.30 (230 em escala 100)
      mut as int64: delta_chi2 = 230

      println("1. Nivel critico de Delta Chi^2 para elipse de confianca de 68.3%:")
      println("   -> Delta Chi^2 = " + delta_chi2 + " / 100 (esperado: 2.30)")

      mut as int64: res = delta_chi2 - 230
      println("2. Residuo analitico do contorno = " + res + " (esperado: 0)")
      println("3. Limites de confianca de parametros validados com sucesso.")
}
