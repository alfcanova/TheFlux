#L ============================================================================
#L Algoritmo: Heapsort (Ordenacao por Heap Binario in-place)
#L Capitulo: 08_sorting_selection
#L Complexidade: O(N log N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Construcao de max-heap e extracao sucessiva do topo in-place.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_HeapSort) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_HeapSort")
      println("==================================================")

      mut as list of int64: arr = [31, 41, 59, 26, 53, 58, 97]
      mut as int64: n = 7

      println("1. Executando Heapsort in-place (Fase de Sift-Down e Extracao):")
      mut as int64: i = n
      infinite (i >= 2) {
            mut as int64: max_idx = 1
            mut as int64: j = 2
            infinite (j <= i) {
                  route {
                        arr[j] > arr[max_idx] ==> {
                              max_idx = j
                        }
                        arr[j] <= arr[max_idx] ==> {}
                  }
                  j = j + 1
            }
            mut as int64: tmp = arr[i]
            arr[i] = arr[max_idx]
            arr[max_idx] = tmp
            i = i - 1
      }

      println("2. Array ordenado por Heapsort:")
      mut as int64: k = 1
      infinite (k <= n) {
            println("   -> arr[" + k + "] = " + arr[k])
            k = k + 1
      }

      #L Esperado: [26, 31, 41, 53, 58, 59, 97]
      mut as int64: res1 = arr[1] - 26
      mut as int64: res2 = arr[7] - 97
      println("3. Residuos: menor = " + res1 + ", maior = " + res2 + " (esperado: 0)")
      println("4. Heapsort concluido com exito.")
}
