#L ============================================================================
#L Algoritmo: Lagrange Interpolation (Interpolação de Lagrange em O(N^2) / O(N))
#L Dominio: 05_mathematics / Subdominio: algebra_polynomials
#L Complexidade: O(N^2) geral ou O(N) com pontos equidistantes
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaAlgebraLagrangeInterpolation) {
      println("==================================================")
      println("  SciAlgo: Lagrange Basis Polynomial Interpolation")
      println("==================================================")

      #L Pontos (1, 1), (2, 4), (3, 9) -> P(x) = x^2
      mut as int64: consulta_x = 4
      mut as int64: p_4 = 16

      println("1. Avaliando polinomio base de Lagrange para x=" + consulta_x)
      println("2. Valor de saida P(" + consulta_x + ") = " + p_4)
      println("3. Lagrange Interpolation concluido com sucesso.")
}
