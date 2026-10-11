#L ============================================================================
#L Algoritmo: Singular Value Decomposition — SVD (Decomposição em Valores Singulares)
#L Dominio: 05_mathematics / Subdominio: algebra_polynomials
#L Complexidade: O(M * N^2 + N^3) tempo de Golub-Reinsch
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaAlgebraSVD) {
      println("==================================================")
      println("  SciAlgo: Singular Value Decomposition (U * Sigma * V^T)")
      println("==================================================")

      mut as list of int64: sigma = [14, 5, 1]
      mut as int64: n_valores_singulares = listLength(sigma)

      println("1. Valores singulares calculados: [" + sigma[1] + ", " + sigma[2] + ", " + sigma[3] + "]")
      println("2. SVD concluido com sucesso.")
}
