#L ============================================================================
#L Algoritmo: Successive Over-Relaxation (SOR)
#L Dominio: 06_numerical_physics / Subdominio: physics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoFisicaSuccessiveOverRelaxation) {
      println("==================================================")
      println("  SciAlgo: Successive Over-Relaxation (SOR)")
      println("==================================================")

      mut as int64: u_old = 50
      mut as int64: u_gs = 80
      mut as int64: omega = 140
      mut as int64: u_sor = ((100 - omega) * u_old + omega * u_gs) /i 100

      println("1. Relaxacao otima SOR com parametro omega: " + u_sor)
      println("2. Successive Over-Relaxation (SOR) concluido com sucesso.")
}
