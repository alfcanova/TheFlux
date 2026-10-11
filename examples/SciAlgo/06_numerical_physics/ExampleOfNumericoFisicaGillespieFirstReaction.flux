#L ============================================================================
#L Algoritmo: Gillespie First-Reaction Method
#L Dominio: 06_numerical_physics / Subdominio: physics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoFisicaGillespieFirstReaction) {
      println("==================================================")
      println("  SciAlgo: Gillespie First-Reaction Method")
      println("==================================================")

      mut as list of int64: taus = [85, 32, 47, 90]
      mut as int64: min_tau = taus[1]
      mut as int64: best_mu = 1
      mut as int64: n = listLength(taus)
      mut as int64: i = 2
      infinite (i <= n) {
            route {
                  taus[i] < min_tau ==> {
                        min_tau = taus[i]
                        best_mu = i
                  }
                  _ ==> {}
            }
            i = i + 1
      }

      println("1. Primeira reacao a ocorrer com menor tau: " + best_mu)
      println("2. Gillespie First-Reaction Method concluido com sucesso.")
}
