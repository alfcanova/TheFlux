#L ============================================================================
#L Algoritmo: Parallel Algorithm (Algoritmo Paralelo / PRAM Scan)
#L Dominio: 01_foundations / Categoria: 1. Fundamentos e paradigmas algoritmicos
#L Complexidade: O(log N) profundidade paralela (Span) | O(N log N) trabalho
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosParadigmasParallelAlgorithm) {
      println("==================================================")
      println("  SciAlgo: Parallel Algorithm (Parallel Scan)")
      println("==================================================")

      mut as list of int64: arr = [3, 1, 7, 0, 4, 1, 6, 3]
      mut as int64: n = listLength(arr)
      println("1. Vetor de entrada para processamento paralelo (N = " + n + "): " + arr)

      #L Simulacao sincrona PRAM (Hillis-Steele Parallel Prefix Sum)
      #L Profundidade (passos de barreira): ceil(log2(N)) = 3 passos
      mut as list of int64: current_layer = arr
      mut as int64: stride = 1
      mut as int64: step = 1

      infinite (stride < n) {
            println("2. Rodada paralela " + step + " com salto (stride) = " + stride)

            #L Todos os processadores i executam em paralelo
            mut as list of int64: next_layer = current_layer
            mut as int64: i = 1
            infinite (i <= n) {
                  route {
                        i > stride ==> {
                              next_layer[i] = current_layer[i] + current_layer[i - stride]
                        }
                        _ ==> {
                              next_layer[i] = current_layer[i]
                        }
                  }
                  i = i + 1
            }

            #L Barreira de sincronizacao paralela
            current_layer = next_layer
            stride = stride * 2
            step = step + 1
      }

      println("3. Vetor final de prefixos paralelos: " + current_layer)
      println("4. Total de rodadas paralelas sincronizadas: " + (step - 1))
      println("Concluido com Sucesso")
}
