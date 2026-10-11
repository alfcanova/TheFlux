#L ============================================================================
#L Algoritmo: Interpolation Search (Busca por Interpolacao)
#L Dominio: 01_foundations / Categoria: 2. Busca
#L Complexidade: O(log log N) caso medio uniforme | O(N) pior caso
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosBuscaInterpolation) {
      println("==================================================")
      println("  SciAlgo: Interpolation Search")
      println("==================================================")

      mut as list of int64: arr = [10, 14, 19, 26, 31, 42, 47, 53, 62, 70, 78, 85, 91, 100]
      mut as int64: n = listLength(arr)
      println("1. Vetor ordenado uniforme (N = 14): " + arr)

      mut as int64: target = 70
      mut as int64: low = 1
      mut as int64: high = n
      mut as int64: found_pos = 0
      mut as int64: probes = 0

      infinite (low <= high and target >= arr[low] and target <= arr[high]) {
            probes = probes + 1
            route {
                  low == high ==> {
                        route {
                              arr[low] == target ==> {
                                    found_pos = low
                              }
                        }
                        break
                  }
            }

            #L Formula de interpolacao: pos = low + ((target - arr[low]) * (high - low)) / (arr[high] - arr[low])
            mut as int64: diff_val = arr[high] - arr[low]
            route {
                  diff_val == 0 ==> {
                        break
                  }
            }

            mut as int64: num = (target - arr[low]) * (high - low)
            mut as int64: pos = low + (num /i diff_val)

            route {
                  arr[pos] == target ==> {
                        found_pos = pos
                        break
                  }
                  arr[pos] < target ==> {
                        low = pos + 1
                  }
                  _ ==> {
                        high = pos - 1
                  }
            }
      }

      println("2. Alvo: " + target)
      println("3. Posicao encontrada: " + found_pos)
      println("4. Estimativas (sondagens): " + probes)
      println("5. Validacao: " + (found_pos == 10 and arr[found_pos] == target))
      println("==================================================")
}
