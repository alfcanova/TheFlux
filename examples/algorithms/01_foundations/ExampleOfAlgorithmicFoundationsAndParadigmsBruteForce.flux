#L ============================================================================
#L Algoritmo: Brute Force (Forca Bruta Exaustiva)
#L Dominio: 01_foundations / Categoria: 1. Fundamentos e paradigmas algoritmicos
#L Complexidade: O(N^2) tempo | O(1) espaco auxiliar
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfAlgorithmicFoundationsAndParadigmsBruteForce) {
      println("==================================================")
      println("  SciAlgo: Brute Force (Forca Bruta)")
      println("==================================================")

      mut as list of int64: arr = [-2, 1, -3, 4, -1, 2, 1, -5, 4]
      mut as int64: n = listLength(arr)
      println("1. Vetor de entrada (N = " + n + "): " + arr)

      mut as int64: max_sum = arr[1]
      mut as int64: best_start = 1
      mut as int64: best_end = 1
      mut as int64: candidates_evaluated = 0

      mut as int64: i = 1
      infinite (i <= n) {
            mut as int64: current_sum = 0
            mut as int64: j = i
            infinite (j <= n) {
                  current_sum = current_sum + arr[j]
                  candidates_evaluated = candidates_evaluated + 1

                  route {
                        current_sum > max_sum ==> {
                              max_sum = current_sum
                              best_start = i
                              best_end = j
                        }
                        _ ==> {
                        }
                  }
                  j = j + 1
            }
            i = i + 1
      }

      println("2. Total de subarranjos avaliados: " + candidates_evaluated)
      println("3. Soma maxima encontrada: " + max_sum)
      println("4. Intervalo otimo: [" + best_start + ", " + best_end + "]")

      mut as list of int64: best_sub = []
      mut as int64: k = best_start
      infinite (k <= best_end) {
            best_sub = listPushBack(best_sub, arr[k])
            k = k + 1
      }
      println("5. Elementos do subarranjo otimo: " + best_sub)
      println("Concluido com Sucesso")
}
