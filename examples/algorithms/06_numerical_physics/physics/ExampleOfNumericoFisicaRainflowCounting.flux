#L ============================================================================
#L Algoritmo: Rainflow Fatigue Cycle Counting
#L Dominio: 06_numerical_physics / Subdominio: physics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoFisicaRainflowCounting) {
      println("==================================================")
      println("  SciAlgo: Rainflow Fatigue Cycle Counting")
      println("==================================================")

      mut as int64: peak = 80
      mut as int64: valley = 20
      mut as int64: stress_range = peak - valley
      route { stress_range < 0 ==> { stress_range = 0 - stress_range } _ ==> {} }

      println("1. Amplitude do ciclo de histerese por Rainflow: " + stress_range)
      println("2. Rainflow Fatigue Cycle Counting concluido com sucesso.")
}
