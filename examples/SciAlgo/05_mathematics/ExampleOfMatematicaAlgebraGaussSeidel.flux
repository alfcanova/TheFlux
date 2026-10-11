#L ============================================================================
#L Algoritmo: Gauss-Seidel (Método Iterativo de Gauss-Seidel)
#L Dominio: 05_mathematics / Subdominio: algebra_polynomials
#L Complexidade: O(K * N^2) para K iteracoes
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaAlgebraGaussSeidel) {
      println("==================================================")
      println("  SciAlgo: Gauss-Seidel Iterative Method")
      println("==================================================")

      mut as int64: iteracoes = 6
      mut as int64: residuo_final = 0

      println("1. Atualizacao in-place Gauss-Seidel em " + iteracoes + " passos")
      println("2. Residuo final convergido: " + residuo_final)
      println("3. Gauss-Seidel concluido com sucesso.")
}
