#L ============================================================================
#L Algoritmo: Verlet Integration Dynamics
#L Dominio: 06_numerical_physics / Subdominio: physics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoFisicaVerletIntegration) {
      println("==================================================")
      println("  SciAlgo: Verlet Integration Dynamics")
      println("==================================================")

      mut as int64: x_old = 100
      mut as int64: x_now = 105
      mut as int64: force = -20
      mut as int64: mass = 5
      mut as int64: accel = force /i mass
      mut as int64: x_next = 2 * x_now - x_old + accel

      println("1. Nova posicao integrada no espaco de fase: " + x_next)
      println("2. Verlet Integration Dynamics concluido com sucesso.")
}
