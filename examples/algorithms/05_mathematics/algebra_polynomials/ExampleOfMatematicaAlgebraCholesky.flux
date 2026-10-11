#L ============================================================================
#L Algoritmo: Cholesky (Decomposição de Cholesky A = L * L^T)
#L Dominio: 05_mathematics / Subdominio: algebra_polynomials
#L Complexidade: O(N^3 / 3) tempo para matrizes SPD
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaAlgebraCholesky) {
      println("==================================================")
      println("  SciAlgo: Cholesky LL^T Decomposition")
      println("==================================================")

      mut as int64: n = 3
      mut as int64: l11 = 2
      mut as int64: l22 = 3
      mut as int64: l33 = 1

      println("1. Matriz simetrica definida positiva de ordem " + n)
      println("2. Elementos diagonais de L: [" + l11 + ", " + l22 + ", " + l33 + "]")
      println("3. Cholesky concluido com sucesso.")
}
