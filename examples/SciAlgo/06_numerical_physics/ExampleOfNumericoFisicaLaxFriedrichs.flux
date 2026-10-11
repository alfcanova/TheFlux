#L ============================================================================
#L Algoritmo: Lax-Friedrichs Shock Capturing
#L Dominio: 06_numerical_physics / Subdominio: physics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoFisicaLaxFriedrichs) {
      println("==================================================")
      println("  SciAlgo: Lax-Friedrichs Shock Capturing")
      println("==================================================")

      mut as int64: ul = 10
      mut as int64: ur = 30
      mut as int64: wave_speed = 50
      mut as int64: num_flux = (ul + ur) /i 2 - (wave_speed * (ur - ul)) /i 200

      println("1. Fluxo de Lax-Friedrichs com viscosidade numerica: " + num_flux)
      println("2. Lax-Friedrichs Shock Capturing concluido com sucesso.")
}
