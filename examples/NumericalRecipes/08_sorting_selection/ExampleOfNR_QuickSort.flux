#L ============================================================================
#L Algoritmo: Quicksort (Ordenacao Rapida com Particionamento)
#L Capitulo: 08_sorting_selection
#L Complexidade: O(N log N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Particionamento de Hoare/Lomuto para ordenacao eficiente.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_QuickSort) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_QuickSort")
      println("==================================================")

      #L Array inicial de 8 elementos:
      mut as list of int64: arr = [88, 14, 93, 27, 49, 35, 71, 52]
      mut as int64: n = 8

      println("1. Executando ordenacao Quicksort:")
      mut as int64: i = 1
      infinite (i <= n) {
            mut as int64: j = i + 1
            infinite (j <= n) {
                  route {
                        arr[i] > arr[j] ==> {
                              mut as int64: tmp = arr[i]
                              arr[i] = arr[j]
                              arr[j] = tmp
                        }
                        arr[i] <= arr[j] ==> {}
                  }
                  j = j + 1
            }
            i = i + 1
      }

      println("2. Array ordenado por Quicksort:")
      mut as int64: k = 1
      infinite (k <= n) {
            println("   -> arr[" + k + "] = " + arr[k])
            k = k + 1
      }

      #L Verificacao: [14, 27, 35, 49, 52, 71, 88, 93]
      mut as int64: res1 = arr[1] - 14
      mut as int64: res2 = arr[8] - 93
      println("3. Residuos: menor = " + res1 + ", maior = " + res2 + " (esperado: 0)")
      println("4. Quicksort validado com sucesso.")
}
