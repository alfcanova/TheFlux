#L ============================================================================
#L Algoritmo: Odd-Even Merge Sort (Rede de Mesclagem Par-Ímpar de Batcher)
#L Domínio: 01_foundations / Categoria: 3. Ordenação
#L Complexidade: O(log^2 N) estágios paralelos | O(N log^2 N) comparadores
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSortOddEvenMerge) {
      println("==================================================")
      println("  SciAlgo: Odd-Even Merge Sort (Batcher 1968)")
      println("==================================================")

      mut as list of int64: arr = [54, 26, 93, 17, 77, 31, 44, 55, 20, 85, 36, 62, 8, 99, 12, 4]
      mut as int64: n = listLength(arr)
      println("1. Vetor de entrada (N = 16): " + arr)

      mut as int64: total_comparators = 0
      mut as int64: p = 1

      infinite (p < n) {
            mut as int64: k = p
            infinite (k >= 1) {
                  mut as int64: j = k /r p
                  infinite (j < (n - k)) {
                        mut as int64: limit = k
                        route {
                              (n - j - k) < limit ==> {
                                    limit = n - j - k
                              }
                        }

                        mut as int64: i = 0
                        infinite (i < limit) {
                              mut as int64: block1 = (i + j) /i (2 * p)
                              mut as int64: block2 = (i + j + k) /i (2 * p)
                              route {
                                    block1 == block2 ==> {
                                          total_comparators = total_comparators + 1
                                          mut as int64: idx1 = i + j + 1
                                          mut as int64: idx2 = i + j + k + 1
                                          route {
                                                arr[idx1] > arr[idx2] ==> {
                                                      mut as int64: tmp = arr[idx1]
                                                      arr[idx1] = arr[idx2]
                                                      arr[idx2] = tmp
                                                }
                                          }
                                    }
                              }
                              i = i + 1
                        }
                        j = j + 2 * k
                  }
                  k = k /i 2
            }
            p = p * 2
      }

      println("2. Total de comparadores executados na rede: " + total_comparators)
      println("3. Vetor ordenado pela rede par-impar: " + arr)

      #L Validação de corretude
      mut as bool: sorted_ok = true
      mut as int64: idx = 1
      infinite (idx < n) {
            route {
                  arr[idx] > arr[idx + 1] ==> {
                        sorted_ok = false
                        break
                  }
            }
            idx = idx + 1
      }
      println("4. Validacao de ordenacao: " + sorted_ok)
      println("==================================================")
}
