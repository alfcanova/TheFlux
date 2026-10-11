#L ============================================================================
#L Algoritmo: Pigeonhole Sort (Ordenação por Casas de Pombos)
#L Domínio: 01_foundations / Categoria: 3. Ordenação
#L Complexidade: O(N + Range) tempo | O(Range) espaço auxiliar
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosOrdenacaoPigeonhole) {
      println("==================================================")
      println("  SciAlgo: Pigeonhole Sort (Casas de Pombos)")
      println("==================================================")

      mut as list of int64: arr = [8, 3, 2, 7, 4, 6, 8, 3, 5, 2, 6, 4]
      mut as int64: n = listLength(arr)
      println("1. Vetor de entrada: " + arr)

      #L Localiza o menor e maior elemento
      mut as int64: min_val = arr[1]
      mut as int64: max_val = arr[1]
      mut as int64: i = 2
      infinite (i <= n) {
            mut as int64: val = arr[i]
            route {
                  val < min_val ==> {
                        min_val = val
                  }
                  val > max_val ==> {
                        max_val = val
                  }
            }
            i = i + 1
      }

      mut as int64: range_val = max_val - min_val + 1
      println("2. Minimo: " + min_val + ", Maximo: " + max_val + ", Total de Casas: " + range_val)

      #L Inicializa as casas de pombos com zero
      mut as list of int64: holes = []
      i = 1
      infinite (i <= range_val) {
            holes = listPushBack(holes, 0)
            i = i + 1
      }

      #L Distribui cada elemento na sua respectiva casa
      i = 1
      infinite (i <= n) {
            mut as int64: h_idx = arr[i] - min_val + 1
            holes[h_idx] = holes[h_idx] + 1
            i = i + 1
      }
      println("3. Ocupacao das casas de pombos: " + holes)

      #L Reconstroi o vetor ordenado percorrendo as casas em ordem
      mut as int64: write_idx = 1
      mut as int64: h = 1
      infinite (h <= range_val) {
            mut as int64: item_val = h + min_val - 1
            infinite (holes[h] > 0) {
                  arr[write_idx] = item_val
                  write_idx = write_idx + 1
                  holes[h] = holes[h] - 1
            }
            h = h + 1
      }

      println("4. Vetor reconstruido e ordenado: " + arr)

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
      println("5. Validacao de ordenacao: " + sorted_ok)
      println("==================================================")
}
