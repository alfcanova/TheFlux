#L ============================================================================
#L Algoritmo: Velocity Verlet Dynamics
#L Dominio: 06_numerical_physics / Subdominio: physics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoFisicaVelocityVerlet) {
      println("==================================================")
      println("  SciAlgo: Velocity Verlet Dynamics")
      println("==================================================")

      mut as int64: x = 10
      mut as int64: v = 5
      mut as int64: a = 2
      mut as int64: dt = 3
      mut as int64: x_new = x + v * dt + (a * dt * dt) /i 2

      println("1. Posicao atualizada via Velocity Verlet: " + x_new)
      println("2. Velocity Verlet Dynamics concluido com sucesso.")
}
