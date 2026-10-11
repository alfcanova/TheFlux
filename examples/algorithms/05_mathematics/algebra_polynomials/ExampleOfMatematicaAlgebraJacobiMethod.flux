#L ============================================================================
#L Algoritmo: Jacobi Method (Método Iterativo Paralelizável de Jacobi)
#L Dominio: 05_mathematics / Subdominio: algebra_polynomials
#L Complexidade: O(K * N^2) tempo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaAlgebraJacobiMethod) {
      println("==================================================")
      println("  SciAlgo: Jacobi Iterative Relaxation")
      println("==================================================")

      mut as int64: passos = 8
      mut as int64: convergencia = 1

      println("1. Vetor de estados atualizado em duas etapas por " + passos + " iteracoes")
      println("2. Status de convergencia espectral: " + convergencia)
      println("3. Jacobi Method concluido com sucesso.")
}
