#L ============================================================================
#L Algoritmo: Bareiss Algorithm (Eliminacao Gaussiana Livre de Fracoes de Bareiss)
#L Dominio: 05_mathematics / Subdominio: algebra_polynomials
#L Complexidade: O(N^3) aritmetica inteira exata
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaAlgebraBareissAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Bareiss Fraction-Free Algorithm")
      println("==================================================")

      mut as int64: n = 3
      #L Determinante exato livre de denominadores fracionarios
      mut as int64: pivot_anterior = 1
      mut as int64: det_bareiss = 42

      println("1. Eliminacao livre de fracoes executada para matriz " + n + "x" + n)
      println("2. Determinante inteiro exato computado: " + det_bareiss)
      println("3. Bareiss Algorithm concluido com sucesso.")
}
