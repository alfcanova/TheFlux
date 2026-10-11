#L ============================================================================
#L Algoritmo: Next Permutation (Narayana Pandita)
#L Dominio: 01_foundations / Arrays e Sequencias
#L Complexidade: O(n) tempo | O(1) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosArraysNextPermutation) {
      println("==================================================")
      println("  SciAlgo: Next Permutation (Narayana Pandita)   ")
      println("==================================================")

      mut as list of int64: arr = [1, 2, 3, 5, 4]
      mut as int64: n = listLength(arr)
      println("1. Permutacao Atual: " + arr)

      #L Passo 1: Encontrar o maior indice i tal que arr[i] < arr[i+1]
      mut as int64: i = n - 1
      infinite (i >= 1 and arr[i] >= arr[i + 1]) {
            i = i - 1
      }

      route {
            i >= 1 ==> {
                  #L Passo 2: Encontrar o maior indice j tal que arr[i] < arr[j]
                  mut as int64: j = n
                  infinite (arr[j] <= arr[i]) {
                        j = j - 1
                  }
                  #L Passo 3: Trocar arr[i] e arr[j]
                  mut as int64: tmp = arr[i]
                  arr[i] = arr[j]
                  arr[j] = tmp
            }
            _ ==> {}
      }

      #L Passo 4: Inverter o sufixo a partir de i + 1 ate n
      mut as int64: left = i + 1
      mut as int64: right = n
      infinite (left < right) {
            mut as int64: tmp2 = arr[left]
            arr[left] = arr[right]
            arr[right] = tmp2
            left = left + 1
            right = right - 1
      }

      println("2. Proxima Permutacao: " + arr)
      #L Para [1, 2, 3, 5, 4], a proxima permutacao eh [1, 2, 4, 3, 5]
      mut as bool: ok = (arr[1] == 1 and arr[2] == 2 and arr[3] == 4 and arr[4] == 3 and arr[5] == 5)
      println("3. Validacao ([1, 2, 4, 3, 5]): " + ok)
      println("==================================================")
}
