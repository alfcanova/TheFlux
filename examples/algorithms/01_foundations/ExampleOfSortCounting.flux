#L ============================================================================
#L Algoritmo: Counting Sort (Ordenação por Contagem e Histograma)
#L Domínio: 01_foundations / Categoria: 3. Ordenação
#L Complexidade: O(N + K) tempo | O(N + K) memória | Estável
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSortCounting) {
      println("==================================================")
      println("  SciAlgo: Counting Sort (Histograma e Prefix Sum)")
      println("==================================================")

      mut as list of int64: arr = [4, 2, 2, 8, 3, 3, 1, 0, 7, 5, 2, 3]
      mut as int64: n = listLength(arr)
      println("1. Vetor de entrada: " + arr)

      #L Determina o valor mínimo e máximo
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

      mut as int64: range_k = max_val - min_val + 1
      println("2. Minimo: " + min_val + ", Maximo: " + max_val + ", Amplitude K: " + range_k)

      #L Inicializa o vetor de contagem com zeros
      mut as list of int64: count = []
      i = 1
      infinite (i <= range_k) {
            count = listPushBack(count, 0)
            i = i + 1
      }

      #L Contagem de frequências
      i = 1
      infinite (i <= n) {
            mut as int64: key = arr[i] - min_val + 1
            count[key] = count[key] + 1
            i = i + 1
      }
      println("3. Histograma de contagem: " + count)

      #L Prefix sum cumulativo para cálculo de posições finais estáveis
      i = 2
      infinite (i <= range_k) {
            count[i] = count[i] + count[i - 1]
            i = i + 1
      }
      println("4. Soma cumulativa (prefix sums): " + count)

      #L Aloca vetor de saída
      mut as list of int64: output = []
      i = 1
      infinite (i <= n) {
            output = listPushBack(output, 0)
            i = i + 1
      }

      #L Construção reversa para garantir ordenação estável (O(N))
      i = n
      infinite (i >= 1) {
            mut as int64: item = arr[i]
            mut as int64: key = item - min_val + 1
            mut as int64: pos = count[key]
            output[pos] = item
            count[key] = count[key] - 1
            i = i - 1
      }

      #L Cópia de volta para o vetor original
      i = 1
      infinite (i <= n) {
            arr[i] = output[i]
            i = i + 1
      }

      println("5. Vetor ordenado: " + arr)

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
      println("6. Validacao de ordenacao: " + sorted_ok)
      println("==================================================")
}
