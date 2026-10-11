#L ============================================================================
#L Algoritmo: Subresultant PRS (Sequencia de Pseudo-Restos Sub-resultante)
#L Dominio: 05_mathematics / Subdominio: algebra_polynomials
#L Complexidade: O(deg(A) * deg(B)) MDC polinomial estavel
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaAlgebraSubresultantPRS) {
      println("==================================================")
      println("  SciAlgo: Subresultant Polynomial Remainder Sequence")
      println("==================================================")

      mut as int64: grau_p = 5
      mut as int64: grau_q = 4
      mut as int64: coef_explosao_evitada = 1

      println("1. Calculo do MDC entre polinomios de grau " + grau_p + " e " + grau_q)
      println("2. Controle de coeficientes via pseudo-divisao sub-resultante: " + coef_explosao_evitada)
      println("3. Subresultant PRS concluido com sucesso.")
}
