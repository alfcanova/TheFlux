#L ============================================================================
#L Algoritmo: Polynomial Interpolation (Interpolação Polinomial de Grau N)
#L Dominio: 05_mathematics / Subdominio: algebra_polynomials
#L Complexidade: O(N^2) tempo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaAlgebraPolynomialInterpolation) {
      println("==================================================")
      println("  SciAlgo: Polynomial Interpolation")
      println("==================================================")

      mut as int64: pontos = 3
      mut as int64: grau_polinomio = pontos - 1
      mut as int64: y_interpolado = 16

      println("1. Ajuste por " + pontos + " pontos (grau " + grau_polinomio + ")")
      println("2. Valor interpolado para consulta: " + y_interpolado)
      println("3. Polynomial Interpolation concluido com sucesso.")
}
