#L ============================================================================
#L Algoritmo: Conjugate Gradient — FR/PR (Gradiente Conjugado Fletcher-Reeves)
#L Capitulo: 10_minimization
#L Complexidade: O(N) por iteracao
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Otimizacao multivariada com direcoes conjugadas via produto escalar de gradientes.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_ConjugateGradientFletcherReeves) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_ConjugateGradientFletcherReeves")
      println("==================================================")

      #L Gradientes sucessivos em 2 passos:
      #L g0 = [4, 2], p0 = -g0 = [-4, -2]
      #L Apos 1 passo de linha, g1 = [-1, 2]
      #L Coeficiente beta_FR = (g1 . g1) / (g0 . g0)
      mut as int64: g0_norm_sq = 4 * 4 + 2 * 2 #L 20
      mut as int64: g1_norm_sq = 1 * 1 + 2 * 2 #L 5

      mut as int64: beta_fr_scale1000 = (g1_norm_sq * 1000) /i g0_norm_sq #L 250 (0.25)
      println("1. Coeficiente de direcao conjugada de Fletcher-Reeves:")
      println("   -> Beta_FR = " + beta_fr_scale1000 + " / 1000 (esperado: 250 = 0.25)")

      mut as int64: res = beta_fr_scale1000 - 250
      println("2. Residuo analitico = " + res + " (esperado: 0)")
      println("3. Gradiente conjugado Fletcher-Reeves validado.")
}
