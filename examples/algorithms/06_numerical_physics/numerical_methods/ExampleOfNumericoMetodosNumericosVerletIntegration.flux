#L ============================================================================
#L Algoritmo: Verlet Integration
#L Dominio: 06_numerical_physics / Subdominio: numerical_methods
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoMetodosNumericosVerletIntegration) {
      println("==================================================")
      println("  SciAlgo: Verlet Integration")
      println("==================================================")

      mut as int64: x_prev = 90
      mut as int64: x_curr = 100
      mut as int64: accel = -2
      mut as int64: dt_sq = 1
      mut as int64: x_next = 2 * x_curr - x_prev + accel * dt_sq

      println("1. Posicao no instante seguinte via Verlet: " + x_next)
      println("2. Verlet Integration concluido com sucesso.")
}
