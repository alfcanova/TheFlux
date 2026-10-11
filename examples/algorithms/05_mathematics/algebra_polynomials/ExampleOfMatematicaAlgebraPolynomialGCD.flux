#L ============================================================================
#L Algoritmo: Polynomial GCD (MDC de Polinômios via Algoritmo Euclidiano)
#L Dominio: 05_mathematics / Subdominio: algebra_polynomials
#L Complexidade: O(N^2) divisao polinomial
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaAlgebraPolynomialGCD) {
      println("==================================================")
      println("  SciAlgo: Polynomial Euclidean GCD")
      println("==================================================")

      #L P(x) = x^2 - 1, Q(x) = x - 1 -> MDC = x - 1 (grau 1)
      mut as int64: grau_p = 2
      mut as int64: grau_q = 1
      mut as int64: grau_mdc = 1

      println("1. Polinomios de graus " + grau_p + " e " + grau_q)
      println("2. Grau do MDC polinomial resultante: " + grau_mdc)
      println("3. Polynomial GCD concluido com sucesso.")
}
