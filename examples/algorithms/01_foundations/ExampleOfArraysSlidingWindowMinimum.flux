#L ============================================================================
#L Algoritmo: Sliding Window Minimum (Minimo Deslizante em Janela Fixa)
#L Dominio: 01_foundations / Categoria: 4. Arrays e sequencias
#L Complexidade: O(N) tempo total | O(K) espaco auxiliar
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfArraysSlidingWindowMinimum) {
      println("==================================================")
      println("  SciAlgo: Sliding Window Minimum")
      println("==================================================")

      mut as list of int64: arr = [4, 3, 2, 1, 5, 7, 6, 8, 2]
      mut as int64: n = listLength(arr)
      mut as int64: k = 3
      println("1. Array de entrada (N = " + n + "): " + arr)
      println("2. Tamanho da janela deslizante: K = " + k)

      #L Deque de indices em ordem crescente de valor arr[idx]
      mut as list of int64: deque = []
      mut as list of int64: window_mins = []

      mut as int64: i = 1
      infinite (i <= n) {
            #L Remove indices que estao fora da janela atual (idx < i - k + 1)
            #L Obs: 'and' nao possui curto-circuito; usa-se flag + route
            mut as bool: trimming = true
            infinite (trimming) {
                  route {
                        listLength(deque) == 0 ==> {
                              trimming = false
                        }
                        deque[1] < i - k + 1 ==> {
                              mut as list of int64: nd_front = []
                              mut as int64: s1 = 2
                              infinite (s1 <= listLength(deque)) {
                                    nd_front = listPushBack(nd_front, deque[s1])
                                    s1 = s1 + 1
                              }
                              deque = nd_front
                        }
                        _ ==> {
                              trimming = false
                        }
                  }
            }

            #L Remove elementos do fundo que sao maiores ou iguais ao atual
            mut as bool: popping = true
            infinite (popping) {
                  route {
                        listLength(deque) == 0 ==> {
                              popping = false
                        }
                        arr[deque[listLength(deque)]] >= arr[i] ==> {
                              mut as int64: last_pos = listLength(deque)
                              mut as list of int64: nd_back = []
                              mut as int64: s2 = 1
                              infinite (s2 < last_pos) {
                                    nd_back = listPushBack(nd_back, deque[s2])
                                    s2 = s2 + 1
                              }
                              deque = nd_back
                        }
                        _ ==> {
                              popping = false
                        }
                  }
            }

            deque = listPushBack(deque, i)

            #L Se a janela de tamanho k estiver formada, a frente do deque eh o minimo
            route {
                  i >= k ==> {
                        mut as int64: min_idx = deque[1]
                        window_mins = listPushBack(window_mins, arr[min_idx])
                  }
                  _ ==> {
                  }
            }
            i = i + 1
      }

      println("3. Minimos de cada janela de tamanho 3:")
      println("   Resultado: " + window_mins)
      println("   Esperado:  [2, 1, 1, 1, 5, 6, 2]")
}
