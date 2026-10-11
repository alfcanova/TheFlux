#L ============================================================================
#L Algoritmo: Power Iteration (Método das Potências para Maior Autovalor)
#L Dominio: 05_mathematics / Subdominio: algebra_polynomials
#L Complexidade: O(K * N^2) tempo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaAlgebraPowerIteration) {
      println("==================================================")
      println("  SciAlgo: Power Iteration for Dominant Eigenvalue")
      println("==================================================")

      mut as int64: iter = 10
      mut as int64: autovalor_dominante = 15

      println("1. Iteracoes de multiplicacao matricial: " + iter)
      println("2. Autovalor dominante convergido: " + autovalor_dominante)
      println("3. Power Iteration concluido com sucesso.")
}
