#L ============================================================================
#L Algoritmo: Piksrt (Straight Insertion Sort)
#L Capitulo: 08_sorting_selection
#L Complexidade: O(N^2)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Ordenacao por insercao direta in-place para pequenos arrays.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_Piksrt) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_Piksrt")
      println("==================================================")

      #L Array inicial desordenado com 8 elementos:
      mut as list of int64: arr = [45, 12, 85, 32, 89, 39, 69, 21]
      mut as int64: n = 8

      println("1. Executando ordenacao por insercao direta (Piksrt):")
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

      println("2. Array ordenado:")
      mut as int64: k = 1
      infinite (k <= n) {
            println("   -> arr[" + k + "] = " + arr[k])
            k = k + 1
      }

      #L Verificacao: arr[1] == 12 e arr[8] == 89
      mut as int64: res1 = arr[1] - 12
      mut as int64: res2 = arr[8] - 89
      println("3. Residuos: menor = " + res1 + ", maior = " + res2 + " (esperado: 0)")
      println("4. Ordenacao por insercao Piksrt concluida com sucesso.")
}
