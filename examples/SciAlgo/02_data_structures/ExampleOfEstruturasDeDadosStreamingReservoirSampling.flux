#L ============================================================================
#L Algoritmo: Reservoir Sampling (Amostragem em Reservatorio sobre Fluxo Continuo)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados streaming
#L Complexidade: O(N) tempo em streaming com memoria estrita O(K)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosStreamingReservoirSampling) {
      println("==================================================")
      println("  SciAlgo: Reservoir Sampling (Streaming)")
      println("==================================================")

      #L Fluxo continuo de dados (streaming)
      mut as list of int64: stream = [101, 202, 303, 404, 505, 606, 707, 808, 909, 1010]
      mut as int64: n = listLength(stream)
      mut as int64: k = 4 #L Capacidade do reservatorio fixo

      println("1. Tamanho do reservatorio K: " + k + " sobre fluxo de N = " + n + " itens")

      #L Inicializa o reservatorio com os primeiros K itens do fluxo
      mut as list of int64: reservoir = []
      mut as int64: idx = 1
      infinite (idx <= k) {
            reservoir = listPushBack(reservoir, stream[idx])
            idx = idx + 1
      }
      println("2. Reservatorio inicial (primeiros " + k + " itens): " + reservoir)

      #L Processa os itens subsequentes com substituicao probabilistica (Algoritmo R)
      #L Gerador pseudo-aleatorio LCG deterministico
      mut as int64: seed = 987654321
      mut as int64: replacements = 0

      mut as int64: item_idx = k + 1
      infinite (item_idx <= n) {
            seed = (1103515245 * seed + 12345) /r 2147483647
            route { seed < 0 ==> { seed = seed * -1 } }
            mut as int64: rand_slot = (seed /r item_idx) + 1

            route {
                  rand_slot <= k ==> {
                        replacements = replacements + 1
                        reservoir[rand_slot] = stream[item_idx]
                  }
            }
            item_idx = item_idx + 1
      }

      println("3. Reservatorio final resultante: " + reservoir)
      println("4. Total de substituicoes efetuadas: " + replacements)
      println("5. Validacao: " + (listLength(reservoir) == k and replacements > 0))
      println("==================================================")
}
