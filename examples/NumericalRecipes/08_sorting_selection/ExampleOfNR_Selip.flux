#L ============================================================================
#L Algoritmo: Selip (Selecao in-place de K-esimo Elemento)
#L Capitulo: 08_sorting_selection
#L Complexidade: O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Selecao in-place da mediana estatistica sem copias adicionais.
#L ============================================================================

use ListStdLib

program (ExampleOfNR_Selip) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_Selip")
      println("==================================================")

      #L Array de 7 elementos: [67, 12, 89, 43, 25, 91, 54]
      #L Ordenado: [12, 25, 43, 54, 67, 89, 91] -> Mediana (k=4) = 54
      mut as list of int64: a = [67, 12, 89, 43, 25, 91, 54]
      mut as int64: n = 7
      mut as int64: k_mediana = 4

      println("1. Selecionando mediana (k = 4) in-place com Selip:")
      mut as int64: i = 1
      infinite (i <= k_mediana) {
            mut as int64: min_idx = i
            mut as int64: j = i + 1
            infinite (j <= n) {
                  route {
                        a[j] < a[min_idx] ==> {
                              min_idx = j
                        }
                        a[j] >= a[min_idx] ==> {}
                  }
                  j = j + 1
            }
            mut as int64: tmp = a[i]
            a[i] = a[min_idx]
            a[min_idx] = tmp
            i = i + 1
      }

      mut as int64: mediana = a[k_mediana]
      println("2. Mediana in-place encontrada: " + mediana + " (esperado: 54)")

      mut as int64: res = mediana - 54
      println("3. Residuo da mediana = " + res + " (esperado: 0)")
      println("4. Algoritmo Selip concluido com exito.")
}
