#L ============================================================================
#L Algoritmo: Nucleus Sampling (Top-p Sampling Baseado em Probabilidade Acumulada)
#L Dominio: 08_artificial_intel / Subdominio: Generativa
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIAGenerativaNucleusSampling) {
      println("=== Algoritmo: Nucleus Sampling ===")
      mut as list of int64: sortedProbs = [50, 30, 12, 5, 3]
      mut as int64: pThreshold = 90
      mut as int64: cumSum = 0
      mut as int64: nucleusSize = 0
      mut as int64: i = 1
      infinite (i <= 5) {
            cumSum = cumSum + sortedProbs[i]
            nucleusSize = nucleusSize + 1
            route {
                  cumSum >= pThreshold ==> { i = 10 }
                  _ ==> {}
            }
            i = i + 1
      }
      println("1. Tamanho do nucleo dinamico: " + nucleusSize)
      println("2. Massa acumulada de probabilidade: " + cumSum)
      println("Teste concluido com sucesso.")
}
