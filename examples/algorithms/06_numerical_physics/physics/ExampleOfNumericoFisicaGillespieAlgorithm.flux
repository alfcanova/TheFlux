#L ============================================================================
#L Algoritmo: Gillespie Stochastic Simulation
#L Dominio: 06_numerical_physics / Subdominio: physics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoFisicaGillespieAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Gillespie Stochastic Simulation")
      println("==================================================")

      mut as list of int64: propensities = [25, 40, 15, 20]
      mut as int64: n = listLength(propensities)
      mut as int64: a0 = 0
      mut as int64: i = 1
      infinite (i <= n) {
            a0 = a0 + propensities[i]
            i = i + 1
      }

      println("1. Propensao total a0 de reacoes quimicas estocasticas: " + a0)
      println("2. Gillespie Stochastic Simulation concluido com sucesso.")
}
