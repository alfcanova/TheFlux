#L ============================================================================
#L Algoritmo: Dutch National Flag (Bandeira Holandesa - Particao 3-Vias)
#L Dominio: 01_foundations / Categoria: 4. Arrays e sequencias
#L Complexidade: O(N) tempo | O(1) espaco auxiliar
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfArraysDutchNationalFlag) {
      println("==================================================")
      println("  SciAlgo: Dutch National Flag (3-Way Partition)")
      println("==================================================")

      #L Teste 1: Array com elementos 0, 1 e 2
      mut as list of int64: arr1 = [2, 0, 2, 1, 1, 0]
      println("1. Array 1 original:  " + arr1)

      mut as int64: low1 = 1
      mut as int64: mid1 = 1
      mut as int64: high1 = listLength(arr1)

      infinite (mid1 <= high1) {
            route {
                  arr1[mid1] == 0 ==> {
                        mut as int64: tmp = arr1[low1]
                        arr1[low1] = arr1[mid1]
                        arr1[mid1] = tmp
                        low1 = low1 + 1
                        mid1 = mid1 + 1
                  }
                  arr1[mid1] == 1 ==> {
                        mid1 = mid1 + 1
                  }
                  _ ==> {
                        mut as int64: tmp2 = arr1[mid1]
                        arr1[mid1] = arr1[high1]
                        arr1[high1] = tmp2
                        high1 = high1 - 1
                  }
            }
      }
      println("2. Array 1 particionado: " + arr1)

      #L Teste 2: Array maior e variado
      mut as list of int64: arr2 = [2, 1, 1, 0, 1, 2, 1, 2, 0, 0, 0, 1]
      println("3. Array 2 original:  " + arr2)

      mut as int64: low2 = 1
      mut as int64: mid2 = 1
      mut as int64: high2 = listLength(arr2)

      infinite (mid2 <= high2) {
            route {
                  arr2[mid2] == 0 ==> {
                        mut as int64: tmp = arr2[low2]
                        arr2[low2] = arr2[mid2]
                        arr2[mid2] = tmp
                        low2 = low2 + 1
                        mid2 = mid2 + 1
                  }
                  arr2[mid2] == 1 ==> {
                        mid2 = mid2 + 1
                  }
                  _ ==> {
                        mut as int64: tmp2 = arr2[mid2]
                        arr2[mid2] = arr2[high2]
                        arr2[high2] = tmp2
                        high2 = high2 - 1
                  }
            }
      }
      println("4. Array 2 particionado: " + arr2)
}
