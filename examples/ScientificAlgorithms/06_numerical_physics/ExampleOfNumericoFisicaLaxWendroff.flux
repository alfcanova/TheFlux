#L ============================================================================
#L Algoritmo: Lax-Wendroff Hydrodynamics
#L Dominio: 06_numerical_physics / Subdominio: physics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoFisicaLaxWendroff) {
      println("==================================================")
      println("  SciAlgo: Lax-Wendroff Hydrodynamics")
      println("==================================================")

      mut as int64: fl = 80
      mut as int64: fr = 120
      mut as int64: mid_flux = (fl + fr) /i 2

      println("1. Fluxo numerico no meio do passo de Lax-Wendroff: " + mid_flux)
      println("2. Lax-Wendroff Hydrodynamics concluido com sucesso.")
}
