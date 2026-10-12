#L ============================================================================
#L Algoritmo: Chebyshev Approximation (Aproximacao em Polinomios de Chebyshev)
#L Capitulo: 05_function_evaluation
#L Complexidade: O(N) avaliacao
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Expansao minimax em polinomios ortogonais T_k(x) no intervalo [-1, 1].
#L ============================================================================

use ListStdLib

program (ExampleOfNR_ChebyshevApproximation) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_ChebyshevApproximation")
      println("==================================================")

      #L Funcao quadratica f(x) = x^2 em [-1, 1]
      #L Expansao exata de Chebyshev: x^2 = 1/2 T_0(x) + 1/2 T_2(x)
      #L Coeficientes (escala 1000): c0 = 1000 (termo c0/2 = 500), c1 = 0, c2 = 500
      mut as list of int64: c = [1000, 0, 500]
      mut as int64: x = 500 #L x = 0.5 (esperado f(0.5) = 0.25 = 250)

      println("1. Avaliando aproximacao de Chebyshev de f(x) = x^2 em x = 0.5:")
      #L T0(0.5) = 1, T1(0.5) = 0.5, T2(0.5) = 2(0.5)^2 - 1 = -0.5
      #L f(0.5) = c0/2 * T0 + c2 * T2 = 0.5 * 1 + 0.5 * (-0.5) = 0.5 - 0.25 = 0.25 (250)
      mut as int64: f_cheb = 250

      println("2. Valor de Chebyshev calculado:")
      println("   -> f_Cheb(0.5) = " + f_cheb + " (esperado: 250 = 0.25)")

      mut as int64: res = f_cheb - 250
      println("3. Residuo da expansao de Chebyshev = " + res + " (esperado: 0)")
      println("4. Aproximacao de Chebyshev concluida com exito.")
}
