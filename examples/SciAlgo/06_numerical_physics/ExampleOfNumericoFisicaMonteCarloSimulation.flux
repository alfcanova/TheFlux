#L ============================================================================
#L Algoritmo: Monte Carlo Physical Ensemble
#L Dominio: 06_numerical_physics / Subdominio: physics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoFisicaMonteCarloSimulation) {
      println("==================================================")
      println("  SciAlgo: Monte Carlo Physical Ensemble")
      println("==================================================")

      mut as list of int64: energies = [100, 120, 80, 140, 110]
      mut as int64: n = listLength(energies)
      mut as int64: sum_e = 0
      mut as int64: i = 1
      infinite (i <= n) {
            sum_e = sum_e + energies[i]
            i = i + 1
      }
      mut as int64: avg_e = sum_e /i n

      println("1. Energia media de ensamble canonico Monte Carlo: " + avg_e)
      println("2. Monte Carlo Physical Ensemble concluido com sucesso.")
}
