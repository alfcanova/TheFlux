#L ============================================================================
#L Algoritmo: Exponential Search (Busca Exponencial / Dobra)
#L Dominio: 01_foundations / Categoria: 2. Busca
#L Complexidade: O(log i) tempo onde i e a posicao do elemento | O(1) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSearchExponential) {
      println("==================================================")
      println("  SciAlgo: Exponential Search")
      println("==================================================")

      mut as list of int64: arr = [2, 4, 7, 11, 16, 23, 31, 42, 56, 72, 90, 110, 135, 162]
      mut as int64: n = listLength(arr)
      println("1. Vetor ordenado (N = 14): " + arr)

      mut as int64: target = 56
      mut as int64: found_pos = 0

      route {
            arr[1] == target ==> {
                  found_pos = 1
            }
      }

      mut as int64: bound = 1
      mut as int64: doublings = 0

      route {
            found_pos == 0 ==> {
                  #L Encontra intervalo dobrando a cota exponencialmente
                  infinite (bound < n) {
                        route {
                              arr[bound] >= target ==> {
                                    break
                              }
                        }
                        doublings = doublings + 1
                        bound = bound * 2
                  }

                  mut as int64: low = bound /i 2
                  mut as int64: high = bound
                  route {
                        high > n ==> {
                              high = n
                        }
                  }

                  #L Busca binaria no intervalo delimitado [low, high]
                  infinite (low <= high) {
                        mut as int64: mid = (low + high) /i 2
                        route {
                              arr[mid] == target ==> {
                                    found_pos = mid
                                    break
                              }
                              arr[mid] < target ==> {
                                    low = mid + 1
                              }
                              _ ==> {
                                    high = mid - 1
                              }
                        }
                  }
            }
      }

      println("2. Alvo: " + target)
      println("3. Posicao encontrada: " + found_pos)
      println("4. Expansoes exponenciais (dobras): " + doublings)
      println("5. Validacao: " + (found_pos == 9 and arr[found_pos] == target))
      println("==================================================")
}
