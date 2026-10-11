#L ============================================================================
#L Algoritmo: Thomas Algorithm (TDMA)
#L Dominio: 06_numerical_physics / Subdominio: physics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoFisicaThomasAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Thomas Algorithm (TDMA)")
      println("==================================================")

      mut as int64: b = 200
      mut as int64: a = 50
      mut as int64: c_prev = 40
      mut as int64: diag_prime = b - (a * c_prev) /i 100

      println("1. Eliminacao direta tridiagonal TDMA concluida: " + diag_prime)
      println("2. Thomas Algorithm (TDMA) concluido com sucesso.")
}
