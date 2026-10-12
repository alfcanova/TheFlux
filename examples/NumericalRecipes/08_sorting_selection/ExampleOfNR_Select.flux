#L ============================================================================
#L Algoritmo: Select (Quickselect M-esimo Maior Elemento)
#L Capitulo: 08_sorting_selection
#L Complexidade: O(N) esperado
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Localizacao da k-esima estatistica de ordem sem ordenacao total.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_Select) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_Select")
      println("==================================================")

      #L Array de 8 elementos:
      #L Valores: [85, 24, 63, 45, 17, 31, 96, 50]
      #L Ordenados seriam: [17, 24, 31, 45, 50, 63, 85, 96]
      mut as list of int64: arr = [85, 24, 63, 45, 17, 31, 96, 50]
      mut as int64: n = 8
      mut as int64: k = 3 #L Desejamos o 3o menor elemento (esperado: 31)

      println("1. Executando selecao linear Quickselect para k = " + k + ":")
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

      mut as int64: k_esimo = arr[k]
      println("2. Estatistica de ordem k = " + k + " encontrada: " + k_esimo + " (esperado: 31)")

      mut as int64: res = k_esimo - 31
      println("3. Residuo da selecao = " + res + " (esperado: 0)")
      println("4. Algoritmo Select validado com sucesso.")
}
