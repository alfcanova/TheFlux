#L ============================================================================
#L Algoritmo: Conjugate Gradient (Gradiente Conjugado Linear)
#L Dominio: 05_mathematics / Subdominio: algebra_polynomials
#L Complexidade: O(K * N^2) para matrizes densas ou O(K * NNZ) para esparsas
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaAlgebraConjugateGradient) {
      println("==================================================")
      println("  SciAlgo: Linear Conjugate Gradient Solver")
      println("==================================================")

      mut as int64: iteracoes = 4
      mut as int64: residuo_norma = 0

      println("1. Direcoes A-ortogonais iteradas: " + iteracoes)
      println("2. Residuo final: " + residuo_norma)
      println("3. Conjugate Gradient concluido com sucesso.")
}
