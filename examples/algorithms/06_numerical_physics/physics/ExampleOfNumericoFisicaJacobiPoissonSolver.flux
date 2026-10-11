#L ============================================================================
#L Algoritmo: Jacobi 5-Point Poisson Stencil
#L Dominio: 06_numerical_physics / Subdominio: physics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoFisicaJacobiPoissonSolver) {
      println("==================================================")
      println("  SciAlgo: Jacobi 5-Point Poisson Stencil")
      println("==================================================")

      mut as int64: ul = 100
      mut as int64: ur = 100
      mut as int64: uu = 100
      mut as int64: ud = 100
      mut as int64: center = (ul + ur + uu + ud) /i 4

      println("1. Media de 5 pontos na iteracao Jacobi do potencial: " + center)
      println("2. Jacobi 5-Point Poisson Stencil concluido com sucesso.")
}
