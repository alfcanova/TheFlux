#L ============================================================================
#L Algoritmo: Runge-Kutta Ballistics
#L Dominio: 06_numerical_physics / Subdominio: physics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoFisicaRungeKutta) {
      println("==================================================")
      println("  SciAlgo: Runge-Kutta Ballistics")
      println("==================================================")

      mut as int64: v = 100
      mut as int64: drag = 10
      mut as int64: dt = 1
      mut as int64: k1 = (0 - drag * v) /i 100
      mut as int64: v_mid = v + (k1 * dt) /i 2
      mut as int64: k2 = (0 - drag * v_mid) /i 100
      mut as int64: v_next = v + k2 * dt

      println("1. Velocidade amortecida integrada por Runge-Kutta: " + v_next)
      println("2. Runge-Kutta Ballistics concluido com sucesso.")
}
