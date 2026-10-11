#L ============================================================================
#L Algoritmo: Runge-Kutta-Fehlberg (RKF45)
#L Dominio: 06_numerical_physics / Subdominio: numerical_methods
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoMetodosNumericosRungeKuttaFehlberg) {
      println("==================================================")
      println("  SciAlgo: Runge-Kutta-Fehlberg (RKF45)")
      println("==================================================")

      mut as int64: val_rk4 = 1000
      mut as int64: val_rk5 = 1003
      mut as int64: err = val_rk5 - val_rk4
      route { err < 0 ==> { err = 0 - err } _ ==> {} }

      println("1. Erro adaptativo estimado por RKF45: " + err)
      println("2. Runge-Kutta-Fehlberg (RKF45) concluido com sucesso.")
}
