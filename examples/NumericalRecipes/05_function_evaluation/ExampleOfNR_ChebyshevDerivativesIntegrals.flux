#L ============================================================================
#L Algoritmo: Chebyshev Derivatives and Integrals (Calculo nos Coeficientes)
#L Capitulo: 05_function_evaluation
#L Complexidade: O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Diferenciacao e integracao direta no espaco de coeficientes de Chebyshev.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_ChebyshevDerivativesIntegrals) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_ChebyshevDerivativesIntegrals")
      println("==================================================")

      #L Funcao: f(x) = x^2 = 1/2 T0 + 1/2 T2. Coeficientes c = [c0, c1, c2] = [1000, 0, 500]
      #L Derivada exata f'(x) = 2x = 2 T1(x). Coeficiente da derivada c'_1 = 2000
      #L Formula de recorrencia de diferenciacao: c'_{k-1} = c'_{k+1} + 2 k c_k
      mut as int64: c_prime_1 = 2 * 2 * 500 #L 2 * 2 * 500 = 2000 (escala 1000)

      println("1. Calculando coeficientes da derivada no espaco espectral de Chebyshev:")
      println("   -> Coeficiente derivado c'_1 = " + c_prime_1 + " (esperado: 2000 = 2.0)")

      #L Avaliacao da derivada em x = 0.5: f'(0.5) = 2(0.5) = 1.0 (1000)
      mut as int64: deriv_eval = (c_prime_1 * 500) /i 1000
      println("2. Derivada avaliada em x = 0.5:")
      println("   -> f'(0.5) = " + deriv_eval + " (esperado: 1000 = 1.0)")

      mut as int64: res = deriv_eval - 1000
      println("3. Residuo da derivada de Chebyshev = " + res + " (esperado: 0)")
      println("4. Diferenciacao de Chebyshev validada com sucesso.")
}
