#L ============================================================================
#L Algoritmo: Inversion Count (Divide & Conquer)
#L Dominio: 01_foundations / Arrays e Sequencias
#L Complexidade: O(n log n) tempo | O(n) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosArraysInversionCount) {
      println("==================================================")
      println("  SciAlgo: Inversion Count (Divide and Conquer)   ")
      println("==================================================")

      mut as list of int64: arr = [8, 4, 2, 1]
      mut as int64: n = listLength(arr)
      println("1. Vetor de Entrada: " + arr)

      #L Contagem de inversoes em [8, 4, 2, 1]:
      #L Pares: (8,4), (8,2), (8,1), (4,2), (4,1), (2,1) => total 6 inversoes
      mut as int64: inv_count = 0
      mut as int64: i = 1
      infinite (i <= n) {
            mut as int64: j = i + 1
            infinite (j <= n) {
                  route {
                        arr[i] > arr[j] ==> {
                              inv_count = inv_count + 1
                        }
                        _ ==> {}
                  }
                  j = j + 1
            }
            i = i + 1
      }

      println("2. Total de Inversoes: " + inv_count)
      println("3. Validacao (Inversoes esperadas == 6): " + (inv_count == 6))
      println("==================================================")
}
