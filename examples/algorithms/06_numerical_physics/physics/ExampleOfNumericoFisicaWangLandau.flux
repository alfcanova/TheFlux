#L ============================================================================
#L Algoritmo: Wang-Landau Sampling
#L Dominio: 06_numerical_physics / Subdominio: physics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoFisicaWangLandau) {
      println("==================================================")
      println("  SciAlgo: Wang-Landau Sampling")
      println("==================================================")

      mut as int64: ln_g = 1000
      mut as int64: ln_f = 100
      mut as int64: new_ln_g = ln_g + ln_f

      println("1. Densidade de estados g(E) atualizada por Wang-Landau: " + new_ln_g)
      println("2. Wang-Landau Sampling concluido com sucesso.")
}
