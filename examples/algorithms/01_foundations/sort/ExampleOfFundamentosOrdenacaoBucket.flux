#L ============================================================================
#L Algoritmo: Bucket Sort (Ordenação por Baldes com Partição Uniforme)
#L Domínio: 01_foundations / Categoria: 3. Ordenação
#L Complexidade: O(N + K) médio | O(N^2) pior caso | Estável
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosOrdenacaoBucket) {
      println("==================================================")
      println("  SciAlgo: Bucket Sort (Particao Uniforme e Coleta)")
      println("==================================================")

      mut as list of int64: arr = [78, 17, 39, 26, 72, 94, 21, 12, 23, 68, 88, 55]
      mut as int64: n = listLength(arr)
      println("1. Vetor de entrada: " + arr)

      #L Identifica mínimo e máximo para definir amplitude dos baldes
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

      mut as int64: num_buckets = 4
      mut as int64: range_k = max_val - min_val + 1
      println("2. Min: " + min_val + ", Max: " + max_val + ", Baldes: " + num_buckets)

      #L Contagem de elementos por balde
      mut as list of int64: b_counts = []
      i = 1
      infinite (i <= num_buckets) {
            b_counts = listPushBack(b_counts, 0)
            i = i + 1
      }

      i = 1
      infinite (i <= n) {
            mut as int64: b_idx = ((arr[i] - min_val) * num_buckets) /i range_k + 1
            route {
                  b_idx > num_buckets ==> {
                        b_idx = num_buckets
                  }
            }
            b_counts[b_idx] = b_counts[b_idx] + 1
            i = i + 1
      }
      println("3. Contagem por balde: " + b_counts)

      #L Calcula deslocamento de início de cada balde
      mut as list of int64: b_offsets = []
      mut as list of int64: b_heads = []
      mut as int64: accum = 1
      i = 1
      infinite (i <= num_buckets) {
            b_offsets = listPushBack(b_offsets, accum)
            b_heads = listPushBack(b_heads, accum)
            accum = accum + b_counts[i]
            i = i + 1
      }

      #L Aloca vetor auxiliar de dispersão
      mut as list of int64: buckets = []
      i = 1
      infinite (i <= n) {
            buckets = listPushBack(buckets, 0)
            i = i + 1
      }

      #L Dispersa elementos nos baldes
      i = 1
      infinite (i <= n) {
            mut as int64: item = arr[i]
            mut as int64: b_idx = ((item - min_val) * num_buckets) /i range_k + 1
            route {
                  b_idx > num_buckets ==> {
                        b_idx = num_buckets
                  }
            }
            mut as int64: pos = b_heads[b_idx]
            buckets[pos] = item
            b_heads[b_idx] = b_heads[b_idx] + 1
            i = i + 1
      }
      println("4. Dispersao inicial nos baldes: " + buckets)

      #L Ordena cada balde individualmente usando Insertion Sort
      mut as int64: b = 1
      infinite (b <= num_buckets) {
            mut as int64: start_idx = b_offsets[b]
            mut as int64: count_b = b_counts[b]
            mut as int64: end_idx = start_idx + count_b - 1

            mut as int64: j = start_idx + 1
            infinite (j <= end_idx) {
                  mut as int64: key = buckets[j]
                  mut as int64: k = j - 1
                  infinite (k >= start_idx) {
                        route {
                              buckets[k] > key ==> {
                                    buckets[k + 1] = buckets[k]
                                    k = k - 1
                              }
                              _ ==> {
                                    break
                              }
                        }
                  }
                  buckets[k + 1] = key
                  j = j + 1
            }
            b = b + 1
      }

      #L Coleta dos baldes ordenados para o vetor final
      i = 1
      infinite (i <= n) {
            arr[i] = buckets[i]
            i = i + 1
      }

      println("5. Vetor final ordenado: " + arr)

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
