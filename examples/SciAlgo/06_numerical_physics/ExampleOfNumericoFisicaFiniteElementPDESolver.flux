#L ============================================================================
#L Algoritmo: Finite Element PDE Solver
#L Dominio: 06_numerical_physics / Subdominio: physics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoFisicaFiniteElementPDESolver) {
      println("==================================================")
      println("  SciAlgo: Finite Element PDE Solver")
      println("==================================================")

      mut as int64: body_force = 6
      mut as int64: elem_len = 10
      mut as int64: nodal_load = (body_force * elem_len) /i 2

      println("1. Vetor de forcas nodais integradas FEM: " + nodal_load)
      println("2. Finite Element PDE Solver concluido com sucesso.")
}
