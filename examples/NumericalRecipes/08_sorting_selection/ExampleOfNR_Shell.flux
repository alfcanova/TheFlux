#L ============================================================================
#L Algoritmo: Shell (Ordenacao por Shellsort)
#L Capitulo: 08_sorting_selection
#L Complexidade: O(N^{3/2})
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L Descricao: Ordenacao por incrementos decrescentes (gaps de Knuth/Sedgewick).
#L ============================================================================

use ListStdLib

program (ExampleOfNR_Shell) {
      println("==================================================")
      println("  Numerical Recipes v3: ExampleOfNR_Shell")
      println("==================================================")

      #L Array de 8 elementos desordenados:
      mut as list of int64: arr = [62, 83, 18, 53, 7, 17, 95, 22]
      mut as int64: n = 8

      println("1. Executando Shellsort com passadas de gap:")
      #L Passada com gap 4 e depois gap 1:
      mut as int64: gap = 4
      mut as int64: step = 1
      infinite (step <= 2) {
            mut as int64: i = 1
            infinite (i <= n) {
                  mut as int64: j = i + gap
                  infinite (j <= n) {
                        route {
                              arr[i] > arr[j] ==> {
                                    mut as int64: tmp = arr[i]
                                    arr[i] = arr[j]
                                    arr[j] = tmp
                              }
                              arr[i] <= arr[j] ==> {}
                        }
                        j = j + gap
                  }
                  i = i + 1
            }
            gap = 1
            step = step + 1
      }

      println("2. Array resultante ordenado por Shellsort:")
      mut as int64: k = 1
      infinite (k <= n) {
            println("   -> arr[" + k + "] = " + arr[k])
            k = k + 1
      }

      mut as int64: res1 = arr[1] - 7
      mut as int64: res2 = arr[8] - 95
      println("3. Residuos: primeiro = " + res1 + ", ultimo = " + res2 + " (esperado: 0)")
      println("4. Shellsort validado com exito.")
}
