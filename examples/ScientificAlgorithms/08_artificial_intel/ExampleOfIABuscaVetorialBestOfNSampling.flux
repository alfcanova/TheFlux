#L ============================================================================
#L Algoritmo: Best-of-N Sampling (Re-ranqueamento com Verificador)
#L Dominio: 08_artificial_intel / Subdominio: Busca Vetorial, RAG & Adaptacao
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfIABuscaVetorialBestOfNSampling) {
      println("=== Algoritmo: Best-of-N Sampling ===")
      mut as list of int64: rewards = [62, 88, 74, 91, 55]
      mut as int64: bestIdx = 1
      mut as int64: maxRew = rewards[1]
      mut as int64: i = 2
      infinite (i <= 5) {
            route {
                  rewards[i] > maxRew ==> {
                        maxRew = rewards[i]
                        bestIdx = i
                  }
                  _ ==> {}
            }
            i = i + 1
      }
      println("1. Melhor candidato N: " + bestIdx)
      println("2. Pontuacao de recompensa: " + maxRew)
      println("Teste concluido com sucesso.")
}
