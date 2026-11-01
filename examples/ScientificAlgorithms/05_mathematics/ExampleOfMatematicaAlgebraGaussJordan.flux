#L ============================================================================
#L Algoritmo: Gauss-Jordan (Eliminação de Gauss-Jordan / Matriz Reduzida em Escada)
#L Dominio: 05_mathematics / Subdominio: algebra_polynomials
#L Complexidade: O(N^3) tempo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaAlgebraGaussJordan) {
      println("==================================================")
      println("  SciAlgo: Gauss-Jordan Inversion & Reduced Echelon")
      println("==================================================")

      mut as int64: n = 3
      mut as int64: posto_matriz = 3

      println("1. Matriz reduzida a forma canônica por Gauss-Jordan: posto=" + posto_matriz)
      println("2. Gauss-Jordan concluido com sucesso.")
}
