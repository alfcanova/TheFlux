#L ============================================================================
#L Algoritmo: Gillespie Direct Method
#L Dominio: 06_numerical_physics / Subdominio: physics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoFisicaGillespieDirectMethod) {
      println("==================================================")
      println("  SciAlgo: Gillespie Direct Method")
      println("==================================================")

      mut as list of int64: props = [10, 30, 20]
      mut as int64: r_target = 25
      mut as int64: accum = 0
      mut as int64: chosen_mu = 1
      mut as int64: n = listLength(props)
      mut as int64: i = 1
      infinite (i <= n) {
            accum = accum + props[i]
            route {
                  accum >= r_target and chosen_mu == 1 ==> { chosen_mu = i }
                  _ ==> {}
            }
            i = i + 1
      }

      println("1. Canal de reacao mu sorteado pelo metodo direto: " + chosen_mu)
      println("2. Gillespie Direct Method concluido com sucesso.")
}
