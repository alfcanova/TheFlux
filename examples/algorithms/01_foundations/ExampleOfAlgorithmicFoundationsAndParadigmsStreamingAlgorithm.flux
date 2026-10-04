#L ============================================================================
#L Algoritmo: Streaming Algorithm (Algoritmo de Streaming em Passagem Unica)
#L Dominio: 01_foundations / Categoria: 1. Fundamentos e paradigmas algoritmicos
#L Complexidade: O(N) tempo | O(1) espaco auxiliar
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfAlgorithmicFoundationsAndParadigmsStreamingAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Streaming Algorithm (Passagem Unica)")
      println("==================================================")

      #L Fluxo continuo simulado de inteiros
      mut as list of int64: stream = [7, 7, 3, 7, 2, 7, 7, 4, 7, 1]
      mut as int64: n_items = listLength(stream)
      println("1. Fluxo de dados (N = " + n_items + "): " + stream)

      #L 1. Boyer-Moore Majority Element em Streaming (Espaco O(1))
      mut as int64: candidate = 0
      mut as int64: count = 0
      mut as int64: i = 1

      infinite (i <= n_items) {
            mut as int64: item = stream[i]
            route {
                  count == 0 ==> {
                        candidate = item
                        count = 1
                  }
                  item == candidate ==> {
                        count = count + 1
                  }
                  _ ==> {
                        count = count - 1
                  }
            }
            i = i + 1
      }
      println("2. Elemento Majoritario identificado no stream: " + candidate)

      #L 2. Estatisticas em Streaming (Soma, Minimo, Maximo, Media inteira)
      mut as int64: stream_sum = 0
      mut as int64: stream_min = stream[1]
      mut as int64: stream_max = stream[1]
      mut as int64: stream_count = 0
      mut as int64: j = 1

      infinite (j <= n_items) {
            mut as int64: val = stream[j]
            stream_count = stream_count + 1
            stream_sum = stream_sum + val

            route {
                  val < stream_min ==> {
                        stream_min = val
                  }
                  _ ==> {
                  }
            }
            route {
                  val > stream_max ==> {
                        stream_max = val
                  }
                  _ ==> {
                  }
            }
            j = j + 1
      }

      mut as int64: mean_scaled = (stream_sum * 100) /i stream_count
      println("3. Total de elementos processados em O(1) espaco: " + stream_count)
      println("4. Minimo do fluxo: " + stream_min)
      println("5. Maximo do fluxo: " + stream_max)
      println("6. Media do fluxo (* 100): " + mean_scaled)
      println("Concluido com Sucesso")
}
