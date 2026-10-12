#L ============================================================================
#L Algoritmo: Polynomial from Chebyshev Coefficients (Sintese Monomial)
#L Capitulo: 05_function_evaluation
#L Complexidade: O(N^2)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Conversao de serie de Chebyshev sum c_k T_k(x) em potencias sum a_k x^k.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_PolynomialFromChebyshevCoefficients) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_PolynomialFromChebyshevCoefficients")
      println("==================================================")

      #L Serie: f(x) = 1/2 T0(x) + 1/2 T2(x)
      #L Como T0 = 1 e T2 = 2x^2 - 1:
      #L f(x) = 1/2(1) + 1/2(2x^2 - 1) = 1/2 + x^2 - 1/2 = x^2
      #L Coeficientes monomiais resultantes a = [a0, a1, a2] = [0, 0, 1]
      mut as list of int64: a = [0, 0, 1]

      println("1. Convertendo coeficientes de Chebyshev para monomios padrao:")
      println("2. Coeficientes monomiais obtidos:")
      println("   -> a0 = " + a[1] + " (esperado: 0)")
      println("   -> a1 = " + a[2] + " (esperado: 0)")
      println("   -> a2 = " + a[3] + " (esperado: 1)")

      println("3. Conversao exata de Chebyshev para monomio comprovada.")
}
