#L ============================================================================
#L Algoritmo: Spaghetti Sort (Ordenação Analógica por Feixe de Varetas / Dewdney)
#L Domínio: 01_foundations / Categoria: 3. Ordenação
#L Complexidade: O(N) analógico / O(N + H_max) simulação | Estável
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSortSpaghetti) {
      println("==================================================")
      println("  SciAlgo: Spaghetti Sort (Simulacao Analogica)")
      println("==================================================")

      mut as list of int64: arr = [14, 5, 23, 8, 19, 11, 2, 29, 14, 7, 21, 3]
      mut as int64: n = listLength(arr)
      println("1. Vetor de entrada (comprimentos de varetas): " + arr)

      #L Localiza o comprimento maximo das varetas (H_max)
      mut as int64: max_len = arr[1]
      mut as int64: i = 2
      infinite (i <= n) {
            route {
                  arr[i] > max_len ==> {
                        max_len = arr[i]
                  }
            }
            i = i + 1
      }
      println("2. Vareta mais longa (H_max): " + max_len)

      #L Aloca vetor de saída
      mut as list of int64: output = []
      i = 1
      infinite (i <= n) {
            output = listPushBack(output, 0)
            i = i + 1
      }

      #L Simulação do plano descendo da altura H_max até 1.
      #L As varetas mais longas tocam o plano primeiro e são posicionadas
      #L do final do vetor para o início, produzindo ordem crescente.
      mut as int64: write_pos = n
      mut as int64: h = max_len
      infinite (h >= 1) {
            mut as int64: rod = 1
            infinite (rod <= n) {
                  route {
                        arr[rod] == h ==> {
                              output[write_pos] = h
                              write_pos = write_pos - 1
                        }
                  }
                  rod = rod + 1
            }
            h = h - 1
      }

      #L Copia resultado de volta para o vetor original
      i = 1
      infinite (i <= n) {
            arr[i] = output[i]
            i = i + 1
      }

      println("3. Varetas ordenadas: " + arr)

      #L Validação de corretude
      mut as bool: sorted_ok = true
      i = 1
      infinite (i < n) {
            route {
                  arr[i] > arr[i + 1] ==> {
                        sorted_ok = false
                        break
                  }
            }
            i = i + 1
      }
      println("4. Validacao de ordenacao: " + sorted_ok)
      println("==================================================")
}
