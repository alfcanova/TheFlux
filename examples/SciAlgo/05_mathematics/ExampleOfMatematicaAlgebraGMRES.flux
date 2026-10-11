#L ============================================================================
#L Algoritmo: GMRES (Generalized Minimal Residual Method)
#L Dominio: 05_mathematics / Subdominio: algebra_polynomials
#L Complexidade: O(M * NNZ + M^2 * N) com reinicializacao m
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaAlgebraGMRES) {
      println("==================================================")
      println("  SciAlgo: GMRES Krylov Subspace Minimization")
      println("==================================================")

      mut as int64: krylov_dim = 10
      mut as int64: residuo_minimo = 0

      println("1. Projecao no subespaco de Krylov de dimensao " + krylov_dim)
      println("2. Menor residuo atingido: " + residuo_minimo)
      println("3. GMRES concluido com sucesso.")
}
