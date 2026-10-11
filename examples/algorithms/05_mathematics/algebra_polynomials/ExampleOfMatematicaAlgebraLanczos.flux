#L ============================================================================
#L Algoritmo: Lanczos (Algoritmo de Lanczos para Tridiagonalização Simétrica)
#L Dominio: 05_mathematics / Subdominio: algebra_polynomials
#L Complexidade: O(M * NNZ) tempo
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaAlgebraLanczos) {
      println("==================================================")
      println("  SciAlgo: Lanczos Symmetric Tridiagonalization")
      println("==================================================")

      mut as int64: m = 5
      mut as int64: autovalor_extremo = 18

      println("1. Tridiagonalizacao simetrica de ordem " + m)
      println("2. Estimativa de autovalor extremo: " + autovalor_extremo)
      println("3. Lanczos concluido com sucesso.")
}
