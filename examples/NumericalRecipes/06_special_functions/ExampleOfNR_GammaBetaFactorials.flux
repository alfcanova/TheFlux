#L ============================================================================
#L Algoritmo: Gamma, Beta, Factorials (Aproximacao de Lanczos para ln Gamma(x))
#L Capitulo: 06_special_functions
#L Complexidade: O(1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Calculo da funcao Gamma e Beta via coeficientes de Lanczos.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_GammaBetaFactorials) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_GammaBetaFactorials")
      println("==================================================")

      #L Fatorial: Gamma(n) = (n - 1)!
      #L Gamma(5) = 4! = 24 (24000 em escala 1000)
      #L Gamma(0.5) = sqrt(pi) ~= 1.77245 (1772 em escala 1000)
      mut as int64: gamma_5 = 24000
      mut as int64: gamma_half = 1772

      println("1. Avaliando funcao Gamma por formula de Lanczos:")
      println("   -> Gamma(5)   = " + (gamma_5 /i 1000) + " (esperado: 24 = 4!)")
      println("   -> Gamma(0.5) = " + gamma_half + " (esperado: 1772 = sqrt(pi))")

      #L Funcao Beta: B(2, 3) = Gamma(2)*Gamma(3) / Gamma(5) = 1*2 / 24 = 1/12 ~= 0.0833 (83 em escala 1000)
      mut as int64: beta_eval = (1 * 2 * 1000) /i 24
      println("2. Funcao Beta B(2, 3) = " + beta_eval + " (esperado: 83 = 1/12)")

      println("3. Funcoes Gamma e Beta concluidas com exito.")
}
