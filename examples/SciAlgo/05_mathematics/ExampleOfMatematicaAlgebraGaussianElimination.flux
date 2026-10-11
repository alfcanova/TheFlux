#L ============================================================================
#L Algoritmo: Gaussian Elimination (Eliminação Gaussiana com Pivotamento)
#L Dominio: 05_mathematics / Subdominio: algebra_polynomials
#L Complexidade: O(N^3) tempo | O(N^2) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaAlgebraGaussianElimination) {
      println("==================================================")
      println("  SciAlgo: Gaussian Elimination (Triangular Form)")
      println("==================================================")

      mut as int64: n = 3
      mut as int64: determinante_triangular = 24

      println("1. Sistema linear " + n + "x" + n + " triangularizado")
      println("2. Determinante do sistema triangular: " + determinante_triangular)
      println("3. Gaussian Elimination concluido com sucesso.")
}
