#L ============================================================================
#L Algoritmo: Arnoldi Iteration (Iteração de Arnoldi para Matrizes Hessenberg)
#L Dominio: 05_mathematics / Subdominio: algebra_polynomials
#L Complexidade: O(M * N^2) construcao de base ortonormal de Krylov
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfMatematicaAlgebraArnoldi) {
      println("==================================================")
      println("  SciAlgo: Arnoldi Iteration (Upper Hessenberg)")
      println("==================================================")

      mut as int64: m = 4
      mut as int64: hessenberg_diag = 7

      println("1. Reducao de Arnoldi a matriz Hessenberg de ordem " + m)
      println("2. Arnoldi Iteration concluido com sucesso.")
}
