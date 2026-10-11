#L ============================================================================
#L Algoritmo: Metropolis-Hastings Boltzmann Algorithm
#L Dominio: 06_numerical_physics / Subdominio: physics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoFisicaMetropolisAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Metropolis-Hastings Boltzmann Algorithm")
      println("==================================================")

      mut as int64: delta_e = -5
      mut as int64: temp = 10
      mut as int64: accept = 0
      route {
            delta_e <= 0 ==> { accept = 1 }
            _ ==> {
                  mut as int64: boltzmann_pct = 100 - (delta_e * 100) /i temp
                  route { boltzmann_pct > 30 ==> { accept = 1 } _ ==> {} }
            }
      }

      println("1. Decisao estocastica de Boltzmann aceita: " + accept)
      println("2. Metropolis-Hastings Boltzmann Algorithm concluido com sucesso.")
}
