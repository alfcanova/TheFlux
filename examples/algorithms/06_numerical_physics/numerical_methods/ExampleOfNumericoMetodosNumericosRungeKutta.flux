#L ============================================================================
#L Algoritmo: Runge-Kutta RK4 Method
#L Dominio: 06_numerical_physics / Subdominio: numerical_methods
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoMetodosNumericosRungeKutta) {
      println("==================================================")
      println("  SciAlgo: Runge-Kutta RK4 Method")
      println("==================================================")

      mut as int64: y = 100
      mut as int64: dt = 10
      mut as int64: k1 = 2 * y
      mut as int64: k2 = 2 * (y + (k1 * dt) /i 200)
      mut as int64: k3 = 2 * (y + (k2 * dt) /i 200)
      mut as int64: k4 = 2 * (y + (k3 * dt) /i 100)
      mut as int64: next_y = y + (dt * (k1 + 2 * k2 + 2 * k3 + k4)) /i 600

      println("1. Passo RK4 de 4a ordem concluido: " + next_y)
      println("2. Runge-Kutta RK4 Method concluido com sucesso.")
}
