#L ============================================================================
#L Algoritmo: Samplesort (Generalização Paralela do Quicksort com Amostradores)
#L Domínio: 01_foundations / Categoria: 3. Ordenação
#L Complexidade: O(N log N) tempo | O(N) espaço | Altamente Paralelizável
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSortSample) {
      println("==================================================")
      println("  SciAlgo: Samplesort (Particionamento com Splitters)")
      println("==================================================")

      mut as list of int64: arr = [63, 19, 82, 44, 11, 95, 30, 77, 2, 53, 38, 88, 15, 6, 71, 25]
      mut as int64: n = listLength(arr)
      println("1. Vetor de entrada: " + arr)

      #L Número de partições (buckets) P = 4, requer P - 1 = 3 splitters
      mut as int64: num_buckets = 4

      #L Fase 1: Coleta de amostra regular do vetor
      mut as list of int64: sample = []
      mut as int64: step = n /i 6
      mut as int64: i = step
      infinite (i <= n) {
            sample = listPushBack(sample, arr[i])
            i = i + step
      }
      mut as int64: sample_len = listLength(sample)
      println("2. Amostra coletada: " + sample)

      #L Fase 2: Ordena a amostra localmente (Insertion Sort)
      i = 2
      infinite (i <= sample_len) {
            mut as int64: key = sample[i]
            mut as int64: j = i - 1
            infinite (j >= 1) {
                  route {
                        sample[j] > key ==> {
                              sample[j + 1] = sample[j]
                              j = j - 1
                        }
                        _ ==> {
                              break
                        }
                  }
            }
            sample[j + 1] = key
            i = i + 1
      }
      println("3. Amostra ordenada: " + sample)

      #L Fase 3: Seleciona 3 splitters equidistantes da amostra ordenada
      mut as int64: s1 = sample[2]
      mut as int64: s2 = sample[4]
      mut as int64: s3 = sample[sample_len]
      println("4. Splitters selecionados: s1 = " + s1 + ", s2 = " + s2 + ", s3 = " + s3)

      #L Fase 4: Contagem de elementos para cada um dos 4 buckets
      mut as list of int64: b_counts = [0, 0, 0, 0]
      i = 1
      infinite (i <= n) {
            mut as int64: val = arr[i]
            route {
                  val <= s1 ==> {
                        b_counts[1] = b_counts[1] + 1
                  }
                  val <= s2 ==> {
                        b_counts[2] = b_counts[2] + 1
                  }
                  val <= s3 ==> {
                        b_counts[3] = b_counts[3] + 1
                  }
                  _ ==> {
                        b_counts[4] = b_counts[4] + 1
                  }
            }
            i = i + 1
      }
      println("5. Distribuicao nos buckets: " + b_counts)

      #L Offset de cada partição
      mut as list of int64: b_offsets = [1, 0, 0, 0]
      mut as list of int64: b_heads = [1, 0, 0, 0]
      mut as int64: accum = 1
      mut as int64: b = 1
      infinite (b <= num_buckets) {
            b_offsets[b] = accum
            b_heads[b] = accum
            accum = accum + b_counts[b]
            b = b + 1
      }

      #L Vetor auxiliar plano para alocação dos buckets
      mut as list of int64: buckets = []
      i = 1
      infinite (i <= n) {
            buckets = listPushBack(buckets, 0)
            i = i + 1
      }

      #L Dispersão dos elementos nos buckets baseados nos splitters
      i = 1
      infinite (i <= n) {
            mut as int64: val = arr[i]
            mut as int64: target_b = 4
            route {
                  val <= s1 ==> { target_b = 1 }
                  val <= s2 ==> { target_b = 2 }
                  val <= s3 ==> { target_b = 3 }
            }
            mut as int64: pos = b_heads[target_b]
            buckets[pos] = val
            b_heads[target_b] = b_heads[target_b] + 1
            i = i + 1
      }

      #L Fase 5: Ordenação local de cada bucket
      b = 1
      infinite (b <= num_buckets) {
            mut as int64: start_idx = b_offsets[b]
            mut as int64: end_idx = start_idx + b_counts[b] - 1
            mut as int64: k = start_idx + 1
            infinite (k <= end_idx) {
                  mut as int64: item = buckets[k]
                  mut as int64: p = k - 1
                  infinite (p >= start_idx) {
                        route {
                              buckets[p] > item ==> {
                                    buckets[p + 1] = buckets[p]
                                    p = p - 1
                              }
                              _ ==> {
                                    break
                              }
                        }
                  }
                  buckets[p + 1] = item
                  k = k + 1
            }
            b = b + 1
      }

      #L Fase 6: Concatenação final no vetor original
      i = 1
      infinite (i <= n) {
            arr[i] = buckets[i]
            i = i + 1
      }

      println("6. Vetor ordenado pelo Samplesort: " + arr)

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
      println("7. Validacao de ordenacao: " + sorted_ok)
      println("==================================================")
}
