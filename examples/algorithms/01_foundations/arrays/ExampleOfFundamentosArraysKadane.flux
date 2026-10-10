#L ============================================================================
#L Algoritmo: Kadane's Algorithm (Subarray Contiguo de Soma Maxima)
#L Dominio: 01_foundations / Categoria: 4. Arrays e sequencias
#L Complexidade: O(N) tempo | O(1) espaco auxiliar
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosArraysKadane) {
      println("==================================================")
      println("  SciAlgo: Kadane's Algorithm")
      println("==================================================")

      #L Teste 1: Array misto (positivos e negativos)
      mut as list of int64: arr1 = [-2, 1, -3, 4, -1, 2, 1, -5, 4]
      mut as int64: n1 = listLength(arr1)
      println("1. Array 1: " + arr1)

      mut as int64: max_so_far1 = arr1[1]
      mut as int64: cur_max1 = arr1[1]
      mut as int64: start_idx1 = 1
      mut as int64: end_idx1 = 1
      mut as int64: temp_start1 = 1

      mut as int64: i1 = 2
      infinite (i1 <= n1) {
            route {
                  arr1[i1] > cur_max1 + arr1[i1] ==> {
                        cur_max1 = arr1[i1]
                        temp_start1 = i1
                  }
                  _ ==> {
                        cur_max1 = cur_max1 + arr1[i1]
                  }
            }

            route {
                  cur_max1 > max_so_far1 ==> {
                        max_so_far1 = cur_max1
                        start_idx1 = temp_start1
                        end_idx1 = i1
                  }
                  _ ==> {
                  }
            }
            i1 = i1 + 1
      }
      println("2. Array 1 - Soma maxima: " + max_so_far1 + " (indices " + start_idx1 + " ate " + end_idx1 + ")")

      #L Teste 2: Array com todos elementos negativos
      mut as list of int64: arr2 = [-8, -3, -6, -2, -5, -4]
      mut as int64: n2 = listLength(arr2)
      println("3. Array 2 (todos negativos): " + arr2)

      mut as int64: max_so_far2 = arr2[1]
      mut as int64: cur_max2 = arr2[1]
      mut as int64: start_idx2 = 1
      mut as int64: end_idx2 = 1
      mut as int64: temp_start2 = 1

      mut as int64: i2 = 2
      infinite (i2 <= n2) {
            route {
                  arr2[i2] > cur_max2 + arr2[i2] ==> {
                        cur_max2 = arr2[i2]
                        temp_start2 = i2
                  }
                  _ ==> {
                        cur_max2 = cur_max2 + arr2[i2]
                  }
            }

            route {
                  cur_max2 > max_so_far2 ==> {
                        max_so_far2 = cur_max2
                        start_idx2 = temp_start2
                        end_idx2 = i2
                  }
                  _ ==> {
                  }
            }
            i2 = i2 + 1
      }
      println("4. Array 2 - Soma maxima: " + max_so_far2 + " (indices " + start_idx2 + " ate " + end_idx2 + ")")
}
