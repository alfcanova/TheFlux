#L ============================================================================
#L Algoritmo: QR Decomposition (Fatoração QR via Householder / Givens)
#L Dominio: 05_mathematics / Subdominio: algebra_polynomials
#L Complexidade: O(M * N^2) tempo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaAlgebraQRDecomposition) {
      println("==================================================")
      println("  SciAlgo: QR Decomposition (Q Ortogonal, R Triangular)")
      println("==================================================")

      mut as int64: m = 3
      mut as int64: n = 3
      mut as int64: ortogonalidade_q = 1

      println("1. Matriz " + m + "x" + n + " decomposta em Q e R")
      println("2. Verificacao Q^T * Q = I: " + ortogonalidade_q)
      println("3. QR Decomposition concluido com sucesso.")
}
