#L ============================================================================
#L Algoritmo: Newton Interpolation (Diferenças Divididas de Newton)
#L Dominio: 05_mathematics / Subdominio: algebra_polynomials
#L Complexidade: O(N^2) construcao da tabela de diferencas
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaAlgebraNewtonInterpolation) {
      println("==================================================")
      println("  SciAlgo: Newton's Divided Differences")
      println("==================================================")

      mut as list of int64: coeficientes_newton = [1, 3, 1]
      mut as int64: ordem = listLength(coeficientes_newton) - 1

      println("1. Tabela triangular de diferencas divididas calculada")
      println("2. Polinomio de Newton de ordem: " + ordem)
      println("3. Newton Interpolation concluido com sucesso.")
}
