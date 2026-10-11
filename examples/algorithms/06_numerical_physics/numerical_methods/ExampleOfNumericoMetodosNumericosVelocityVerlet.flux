#L ============================================================================
#L Algoritmo: Velocity Verlet
#L Dominio: 06_numerical_physics / Subdominio: numerical_methods
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoMetodosNumericosVelocityVerlet) {
      println("==================================================")
      println("  SciAlgo: Velocity Verlet")
      println("==================================================")

      mut as int64: x = 0
      mut as int64: v = 20
      mut as int64: a = 4
      mut as int64: dt = 3
      mut as int64: x_new = x + v * dt + (a * dt * dt) /i 2

      println("1. Trajetoria calculada por Velocity Verlet: " + x_new)
      println("2. Velocity Verlet concluido com sucesso.")
}
