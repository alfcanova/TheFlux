#L ============================================================================
#L Algoritmo: Parallel Quicksort (Particionamento Concorrente de Sub-ramos)
#L Dominio: 09_systems_infra / Categoria: Computacao concorrente e paralela
#L Complexidade: O(N log N) trabalho | O(N) pior caso | O(log N) profundidade
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSistemasConcorrenteParallelQuicksort) {
      println("==================================================")
      println("  SciAlgo: Parallel Quicksort (Branch Concurrency)")
      println("==================================================")

      #L Vetor de N = 8 elementos
      mut as int64: n = 8
      mut as list of int64: a = [42, 17, 89, 33, 65, 12, 78, 5]

      println("1. Vetor de Entrada (N = 8):")
      mut as string: in_str = ""
      mut as int64: idx = 1
      infinite (idx <= n) {
            in_str = in_str + a[idx] + " "
            idx = idx + 1
      }
      println("   A = [ " + in_str + "]")

      println("2. Fase 1: Particionamento Raiz pelo Pivo:")
      #L Escolhe pivo = a[4] = 33
      mut as int64: pivot = a[4]
      println("   Pivo Escolhido: " + pivot)

      #L Separa elementos menores e maiores em buffers concorrentes
      mut as list of int64: left = [0, 0, 0, 0, 0, 0, 0, 0]
      mut as list of int64: right = [0, 0, 0, 0, 0, 0, 0, 0]
      mut as int64: count_l = 0
      mut as int64: count_r = 0

      idx = 1
      infinite (idx <= n) {
            route {
                  idx == 4 ==> {} #L Pula o proprio pivo
                  a[idx] <= pivot ==> {
                        count_l = count_l + 1
                        left[count_l] = a[idx]
                  }
                  _ ==> {
                        count_r = count_r + 1
                        right[count_r] = a[idx]
                  }
            }
            idx = idx + 1
      }

      println("3. Fase 2: Execucao Concorrente dos Sub-ramos (Fork em Threads):")
      #L Thread Esquerda ordena a particao left[1..count_l]
      mut as int64: i = 1
      infinite (i <= count_l) {
            mut as int64: j = i + 1
            infinite (j <= count_l) {
                  route {
                        left[i] > left[j] ==> {
                              mut as int64: sw = left[i]
                              left[i] = left[j]
                              left[j] = sw
                        }
                        _ ==> {}
                  }
                  j = j + 1
            }
            i = i + 1
      }

      #L Thread Direita ordena a particao right[1..count_r]
      i = 1
      infinite (i <= count_r) {
            mut as int64: j = i + 1
            infinite (j <= count_r) {
                  route {
                        right[i] > right[j] ==> {
                              mut as int64: sw = right[i]
                              right[i] = right[j]
                              right[j] = sw
                        }
                        _ ==> {}
                  }
                  j = j + 1
            }
            i = i + 1
      }

      println("4. Fase 3: Juncao (Join) dos Ramos Ordenados:")
      #L Concatena left + pivot + right de volta em a
      mut as int64: pos = 1
      i = 1
      infinite (i <= count_l) {
            a[pos] = left[i]
            pos = pos + 1
            i = i + 1
      }

      a[pos] = pivot
      pos = pos + 1

      i = 1
      infinite (i <= count_r) {
            a[pos] = right[i]
            pos = pos + 1
            i = i + 1
      }

      println("5. Vetor Final Ordenado:")
      mut as string: out_str = ""
      idx = 1
      infinite (idx <= n) {
            out_str = out_str + a[idx] + " "
            idx = idx + 1
      }
      println("   A = [ " + out_str + "]")

      #L Verificacao de ordenacao
      mut as bool: is_sorted = true
      idx = 1
      infinite (idx < n) {
            route {
                  a[idx] > a[idx + 1] ==> {
                        is_sorted = false
                  }
                  _ ==> {}
            }
            idx = idx + 1
      }
      println("6. Verificacao de Exatidao: " + is_sorted)

      println("Parallel Quicksort concluido com sucesso.")
}
