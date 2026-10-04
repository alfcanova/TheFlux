#L ============================================================================
#L Algoritmo: Sliding Window (Janela Deslizante)
#L Dominio: 01_foundations / Categoria: 4. Arrays e sequencias
#L Complexidade: O(N) tempo | O(1) espaco auxiliar
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfArraysSlidingWindow) {
      println("==================================================")
      println("  SciAlgo: Sliding Window Technique")
      println("==================================================")

      #L Parte 1: Janela Fixa - Subarray de tamanho K com soma maxima
      mut as list of int64: arr1 = [2, 1, 5, 1, 3, 2]
      mut as int64: n1 = listLength(arr1)
      mut as int64: k = 3
      println("1. Array 1 (tamanho " + n1 + "): " + arr1)

      mut as int64: cur_sum = 0
      mut as int64: i = 1
      infinite (i <= k) {
            cur_sum = cur_sum + arr1[i]
            i = i + 1
      }
      mut as int64: max_sum = cur_sum
      infinite (i <= n1) {
            cur_sum = cur_sum + arr1[i] - arr1[i - k]
            route {
                  cur_sum > max_sum ==> {
                        max_sum = cur_sum
                  }
                  _ ==> {
                  }
            }
            i = i + 1
      }
      println("2. Janela fixa (K = " + k + "), Soma maxima: " + max_sum)

      #L Parte 2: Janela Dinamica - Menor comprimento de subarray com soma >= S
      mut as list of int64: arr2 = [2, 3, 1, 2, 4, 3]
      mut as int64: n2 = listLength(arr2)
      mut as int64: target_sum = 7
      println("3. Array 2 (tamanho " + n2 + "): " + arr2)

      mut as int64: min_len = n2 + 1
      mut as int64: window_sum = 0
      mut as int64: left = 1
      mut as int64: right = 1

      infinite (right <= n2) {
            window_sum = window_sum + arr2[right]
            infinite (window_sum >= target_sum) {
                  mut as int64: win_len = right - left + 1
                  route {
                        win_len < min_len ==> {
                              min_len = win_len
                        }
                        _ ==> {
                        }
                  }
                  window_sum = window_sum - arr2[left]
                  left = left + 1
            }
            right = right + 1
      }

      route {
            min_len > n2 ==> {
                  min_len = 0
            }
            _ ==> {
            }
      }
      println("4. Janela dinamica (alvo >= " + target_sum + "), Menor comprimento: " + min_len)
}
