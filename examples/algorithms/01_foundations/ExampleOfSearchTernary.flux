#L ============================================================================
#L Algoritmo: Ternary Search (Busca Ternaria)
#L Dominio: 01_foundations / Categoria: 2. Busca
#L Complexidade: O(log3 N) tempo | O(1) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSearchTernary) {
      println("==================================================")
      println("  SciAlgo: Ternary Search")
      println("==================================================")

      mut as list of int64: arr = [3, 7, 12, 18, 25, 31, 42, 55, 68, 77, 89, 94]
      mut as int64: n = listLength(arr)
      println("1. Vetor ordenado (N = 12): " + arr)

      mut as int64: target = 42
      mut as int64: low = 1
      mut as int64: high = n
      mut as int64: found_pos = 0
      mut as int64: steps = 0

      infinite (low <= high) {
            steps = steps + 1
            mut as int64: span = (high - low) /i 3
            mut as int64: mid1 = low + span
            mut as int64: mid2 = high - span

            route {
                  arr[mid1] == target ==> {
                        found_pos = mid1
                        break
                  }
                  arr[mid2] == target ==> {
                        found_pos = mid2
                        break
                  }
                  target < arr[mid1] ==> {
                        high = mid1 - 1
                  }
                  target > arr[mid2] ==> {
                        low = mid2 + 1
                  }
                  _ ==> {
                        low = mid1 + 1
                        high = mid2 - 1
                  }
            }
      }

      println("2. Alvo: " + target)
      println("3. Posicao encontrada: " + found_pos)
      println("4. Passos executados: " + steps)

      #L Busca por elemento inexistente
      mut as int64: target_missing = 99
      mut as int64: low2 = 1
      mut as int64: high2 = n
      mut as int64: found_missing = 0

      infinite (low2 <= high2) {
            mut as int64: span2 = (high2 - low2) /i 3
            mut as int64: m1 = low2 + span2
            mut as int64: m2 = high2 - span2

            route {
                  arr[m1] == target_missing ==> {
                        found_missing = m1
                        break
                  }
                  arr[m2] == target_missing ==> {
                        found_missing = m2
                        break
                  }
                  target_missing < arr[m1] ==> {
                        high2 = m1 - 1
                  }
                  target_missing > arr[m2] ==> {
                        low2 = m2 + 1
                  }
                  _ ==> {
                        low2 = m1 + 1
                        high2 = m2 - 1
                  }
            }
      }

      println("5. Busca por 99 (nao presente): " + found_missing)
      println("6. Validacao: " + (found_pos == 7 and found_missing == 0))
      println("==================================================")
}
