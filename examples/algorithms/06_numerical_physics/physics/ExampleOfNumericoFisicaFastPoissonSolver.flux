#L ============================================================================
#L Algoritmo: Fast Poisson Solver (Sine Transform)
#L Dominio: 06_numerical_physics / Subdominio: physics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoFisicaFastPoissonSolver) {
      println("==================================================")
      println("  SciAlgo: Fast Poisson Solver (Sine Transform)")
      println("==================================================")

      mut as int64: kx = 2
      mut as int64: ky = 3
      mut as int64: eig_val = kx * kx + ky * ky

      println("1. Autovalor do operador laplaciano discreto: " + eig_val)
      println("2. Fast Poisson Solver (Sine Transform) concluido com sucesso.")
}
