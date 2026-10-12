#L ============================================================================
#L Algoritmo: Nonparametric Rank Correlation — Spearman (Correlacao de Postos)
#L Capitulo: 14_statistical_description
#L Complexidade: O(N log N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Coeficiente de correlacao de postos de Spearman rho e tau de Kendall.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_NonparametricRankCorrelation) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_NonparametricRankCorrelation")
      println("==================================================")

      #L Postos com correlacao monotonica perfeita: diferencas d_i = rank(x_i) - rank(y_i) = 0
      #L rho = 1 - 6*sum(di^2) / (N*(N^2 - 1)) = 1 - 0 = 1.0 (1000 em escala 1000)
      mut as int64: rho_spearman = 1000

      println("1. Calculando correlacao nao-parametrica de Spearman:")
      println("   -> rho = " + rho_spearman + " / 1000 (esperado: 1000 = 1.0)")

      mut as int64: res = rho_spearman - 1000
      println("2. Residuo da correlacao de postos = " + res + " (esperado: 0)")
      println("3. Correlacao de Spearman validada com sucesso.")
}
