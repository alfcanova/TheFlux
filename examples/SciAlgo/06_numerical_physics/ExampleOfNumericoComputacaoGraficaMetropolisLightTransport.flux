#L ============================================================================
#L Algoritmo: Metropolis Light Transport
#L Dominio: 06_numerical_physics / Subdominio: graphics
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfNumericoComputacaoGraficaMetropolisLightTransport) {
      println("==================================================")
      println("  SciAlgo: Metropolis Light Transport")
      println("==================================================")

      mut as int64: cur_eval = 100
      mut as int64: prop_eval = 120
      mut as int64: accepted = 0
      route {
            prop_eval >= cur_eval ==> { accepted = 1 }
            _ ==> {
                  mut as int64: r = (prop_eval * 100) /i cur_eval
                  route { r > 50 ==> { accepted = 1 } _ ==> {} }
            }
      }

      println("1. Mutacao de caminho aceita no MLT: " + accepted)
      println("2. Metropolis Light Transport concluido com sucesso.")
}
