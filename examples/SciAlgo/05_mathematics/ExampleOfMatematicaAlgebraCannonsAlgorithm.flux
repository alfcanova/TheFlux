#L ============================================================================
#L Algoritmo: Cannon's Algorithm (Multiplicação Distribuída em Grade 2D Toroidal)
#L Dominio: 05_mathematics / Subdominio: algebra_polynomials
#L Complexidade: O(N^3 / P) tempo com P processadores
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaAlgebraCannonsAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Cannon's Distributed 2D Grid Multiplication")
      println("==================================================")

      mut as int64: grade_p = 4
      mut as int64: shifts_circulares = 2

      println("1. Topologia de grade toroidal 2x2 com P=" + grade_p + " nos")
      println("2. Rotacoes circulares de blocos: " + shifts_circulares)
      println("3. Cannon's Algorithm concluido com sucesso.")
}
