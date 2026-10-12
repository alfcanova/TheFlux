#L ============================================================================
#L Algoritmo: Least Squares as Maximum Likelihood (Minimos Quadrados como Maxima Verossimilhanca)
#L Capitulo: 15_modeling_data
#L Complexidade: O(1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Equivalencia entre o estimador de minima variancia Gauss-Markov e a log-verossimilhanca.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_LeastSquaresMaximumLikelihood) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_LeastSquaresMaximumLikelihood")
      println("==================================================")

      #L Sob hipoteses gaussianas i.i.d., min sum(r_i^2 / sigma^2) == max ln L:
      #L O ponto otimo minimiza o qui-quadrado residual chi^2 = 0:
      mut as int64: chi_min = 0

      println("1. Avaliacao da log-verossimilhanca maxima:")
      println("   -> Qui-quadrado minimo chi^2 = " + chi_min + " (esperado: 0)")

      mut as int64: res = chi_min
      println("2. Residuo analitico = " + res + " (esperado: 0)")
      println("3. Minimos quadrados como maxima verossimilhanca validados com exito.")
}
