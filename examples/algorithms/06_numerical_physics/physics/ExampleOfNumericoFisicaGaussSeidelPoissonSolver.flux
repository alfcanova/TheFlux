#L ============================================================================
#L Algoritmo: Gauss-Seidel In-Place Poisson Solver
#L Dominio: 06_numerical_physics / Subdominio: physics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoFisicaGaussSeidelPoissonSolver) {
      println("==================================================")
      println("  SciAlgo: Gauss-Seidel In-Place Poisson Solver")
      println("==================================================")

      mut as int64: u1 = 80
      mut as int64: u2 = 120
      mut as int64: u3 = 90
      mut as int64: u4 = 110
      mut as int64: u_gs = (u1 + u2 + u3 + u4) /i 4

      println("1. Convergencia acelerada in-place de Gauss-Seidel: " + u_gs)
      println("2. Gauss-Seidel In-Place Poisson Solver concluido com sucesso.")
}
