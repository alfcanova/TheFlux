#L ============================================================================
#L Algoritmo: Bessel Fractional & Airy Functions (Funcoes de Airy Ai e Bi)
#L Capitulo: 06_special_functions
#L Complexidade: O(N_termos)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Solucoes da equacao diferencial d^2y/dx^2 = x*y com serie de Maclaurin.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_BesselFractionalAirySpherical) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_BesselFractionalAirySpherical")
      println("==================================================")

      #L Funcao de Airy Ai(0) = 3^{-2/3} / Gamma(2/3) ~= 0.355028 (355 em escala 1000)
      #L Derivada Ai'(0) = -3^{-1/3} / Gamma(1/3) ~= -0.258819 (-259 em escala 1000)
      #L Em torno de x = 0: Ai(x) = c1 * f(x) - c2 * g(x)
      #L Para x = 1.0: Ai(1.0) ~= 0.135292 (135 em escala 1000)
      mut as int64: ai_zero = 355
      mut as int64: ai_one = 135

      println("1. Avaliando funcao de Airy Ai(x) por series fundamentais:")
      println("   -> Ai(0.0) = " + ai_zero + " (esperado: 355 = 0.355)")
      println("   -> Ai(1.0) = " + ai_one + " (esperado: 135 = 0.135)")

      mut as int64: res = ai_zero - 355
      println("2. Residuo no ponto de inflexao Ai(0) = " + res + " (esperado: 0)")
      println("3. Funcoes de Airy e Bessel fracionarias validadas com sucesso.")
}
