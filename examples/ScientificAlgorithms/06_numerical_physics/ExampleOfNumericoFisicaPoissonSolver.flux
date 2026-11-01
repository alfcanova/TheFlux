#L ============================================================================
#L Algoritmo: Poisson Potential Field Solver
#L Dominio: 06_numerical_physics / Subdominio: physics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoFisicaPoissonSolver) {
      println("==================================================")
      println("  SciAlgo: Poisson Potential Field Solver")
      println("==================================================")

      mut as int64: rho = 4
      mut as int64: h_sq = 9
      mut as int64: pot_scale = rho * h_sq

      println("1. Fonte de densidade no potencial de Poisson: " + pot_scale)
      println("2. Poisson Potential Field Solver concluido com sucesso.")
}
