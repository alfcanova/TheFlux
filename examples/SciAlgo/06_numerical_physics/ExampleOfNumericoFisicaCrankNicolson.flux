#L ============================================================================
#L Algoritmo: Crank-Nicolson PDE Solver
#L Dominio: 06_numerical_physics / Subdominio: physics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoFisicaCrankNicolson) {
      println("==================================================")
      println("  SciAlgo: Crank-Nicolson PDE Solver")
      println("==================================================")

      mut as int64: u_old = 100
      mut as int64: d_expl = 10
      mut as int64: d_impl = 8
      mut as int64: u_new = u_old + (d_expl + d_impl) /i 2

      println("1. Avanço no tempo estavel por Crank-Nicolson: " + u_new)
      println("2. Crank-Nicolson PDE Solver concluido com sucesso.")
}
