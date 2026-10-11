#L ============================================================================
#L Algoritmo: Longest Increasing Subsequence (LIS)
#L Dominio: 01_foundations / Arrays e Sequencias
#L Complexidade: O(n log n) tempo | O(n) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosArraysLongestIncreasingSubsequence) {
      println("==================================================")
      println("  SciAlgo: Longest Increasing Subsequence (LIS)   ")
      println("==================================================")

      mut as list of int64: arr = [10, 9, 2, 5, 3, 7, 101, 18]
      mut as int64: n = listLength(arr)
      println("1. Vetor de Entrada: " + arr)

      #L tails[i] armazena o menor elemento final de todas as subsequencias de tamanho i
      mut as list of int64: tails = []
      mut as int64: i = 1
      infinite (i <= n) {
            mut as int64: x = arr[i]
            mut as int64: low = 1
            mut as int64: high = listLength(tails)
            mut as int64: pos = listLength(tails) + 1

            #L Busca binaria pelo primeiro elemento >= x em tails
            infinite (low <= high) {
                  mut as int64: mid = low + (high - low) /i 2
                  route {
                        tails[mid] >= x ==> {
                              pos = mid
                              high = mid - 1
                        }
                        _ ==> {
                              low = mid + 1
                        }
                  }
            }

            route {
                  pos > listLength(tails) ==> {
                        tails = listPushBack(tails, x)
                  }
                  _ ==> {
                        tails[pos] = x
                  }
            }
            i = i + 1
      }

      mut as int64: lis_len = listLength(tails)
      println("2. Tamanho da LIS: " + lis_len)
      println("3. Tails do Patience Sorting: " + tails)
      println("4. Validacao (LIS esperada == 4): " + (lis_len == 4))
      println("==================================================")
}
