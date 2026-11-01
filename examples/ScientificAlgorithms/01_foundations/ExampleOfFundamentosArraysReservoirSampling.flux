#L ============================================================================
#L Algoritmo: Reservoir Sampling (Amostragem de Reservatorio - Algoritmo R)
#L Dominio: 01_foundations / Categoria: 4. Arrays e sequencias
#L Complexidade: O(N) tempo | O(K) espaco auxiliar
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosArraysReservoirSampling) {
      println("==================================================")
      println("  SciAlgo: Reservoir Sampling (Arrays)")
      println("==================================================")

      mut as list of int64: stream = [101, 102, 103, 104, 105, 106, 107, 108, 109, 110]
      mut as int64: n = listLength(stream)
      mut as int64: k = 4
      println("1. Stream de entrada (N = " + n + "): " + stream)
      println("2. Tamanho do reservatorio desejado: K = " + k)

      #L Inicializa o reservatorio com os primeiros K elementos
      mut as list of int64: reservoir = []
      mut as int64: i = 1
      infinite (i <= k) {
            reservoir = listPushBack(reservoir, stream[i])
            i = i + 1
      }

      #L PRNG deterministico LCG
      mut as int64: rng = 987654321

      #L Processa os elementos restantes da stream de K+1 ate N
      infinite (i <= n) {
            rng = (rng * 1103515245 + 12345) /r 2147483647
            route {
                  rng < 0 ==> {
                        rng = rng + 2147483647
                  }
                  _ ==> {
                  }
            }

            #L Sorteia j no intervalo [1..i]
            mut as int64: j = (rng /r i) + 1
            route {
                  j <= k ==> {
                        reservoir[j] = stream[i]
                  }
                  _ ==> {
                  }
            }
            i = i + 1
      }

      println("3. Amostra final no reservatorio: " + reservoir)
      println("4. Quantidade de elementos amostrados: " + listLength(reservoir))
}
