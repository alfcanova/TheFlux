#L ============================================================================
#L Algoritmo: Maximum Product Subarray
#L Dominio: 01_foundations / Arrays e Sequencias
#L Complexidade: O(n) tempo | O(1) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosArraysMaximumProductSubarray) {
      println("==================================================")
      println("  SciAlgo: Maximum Product Subarray               ")
      println("==================================================")

      mut as list of int64: nums = [2, 3, -2, 4, -1]
      mut as int64: n = listLength(nums)
      println("1. Vetor de Entrada: " + nums)

      mut as int64: max_ending_here = nums[1]
      mut as int64: min_ending_here = nums[1]
      mut as int64: max_so_far = nums[1]

      mut as int64: i = 2
      infinite (i <= n) {
            mut as int64: x = nums[i]
            mut as int64: cand1 = max_ending_here * x
            mut as int64: cand2 = min_ending_here * x

            mut as int64: cur_max = x
            route {
                  cand1 > cur_max ==> {
                        cur_max = cand1
                  }
            }
            route {
                  cand2 > cur_max ==> {
                        cur_max = cand2
                  }
            }

            mut as int64: cur_min = x
            route {
                  cand1 < cur_min ==> {
                        cur_min = cand1
                  }
            }
            route {
                  cand2 < cur_min ==> {
                        cur_min = cand2
                  }
            }

            max_ending_here = cur_max
            min_ending_here = cur_min

            route {
                  max_ending_here > max_so_far ==> {
                        max_so_far = max_ending_here
                  }
            }

            i = i + 1
      }

      println("2. Produto Maximo do Subarray: " + max_so_far)
      #L Para [2, 3, -2, 4, -1], o produto do array completo eh 48
      println("3. Validacao (Esperado == 48): " + (max_so_far == 48))
      println("==================================================")
}
