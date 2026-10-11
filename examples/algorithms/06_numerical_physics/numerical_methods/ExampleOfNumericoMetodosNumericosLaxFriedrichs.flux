#L ============================================================================
#L Algoritmo: Lax-Friedrichs Scheme
#L Dominio: 06_numerical_physics / Subdominio: numerical_methods
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoMetodosNumericosLaxFriedrichs) {
      println("==================================================")
      println("  SciAlgo: Lax-Friedrichs Scheme")
      println("==================================================")

      mut as int64: u_left = 20
      mut as int64: u_right = 30
      mut as int64: flux_diff = 10
      mut as int64: cfl_scale = 50
      mut as int64: u_next = (u_left + u_right) /i 2 - (flux_diff * cfl_scale) /i 100

      println("1. Atualizacao numerica conservativa Lax-Friedrichs: " + u_next)
      println("2. Lax-Friedrichs Scheme concluido com sucesso.")
}
