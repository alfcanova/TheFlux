#L ============================================================================
#L Algoritmo: Bitonic Sorting Network (Rede de Ordenação Bitônica de Batcher)
#L Domínio: 01_foundations / Categoria: 3. Ordenação
#L Complexidade: O(log^2 N) passos paralelos | O(N log^2 N) comparadores
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSortBitonicNetwork) {
      println("==================================================")
      println("  SciAlgo: Bitonic Sorting Network (Batcher 1968)")
      println("==================================================")

      mut as list of int64: arr = [38, 27, 43, 3, 9, 82, 10, 19, 50, 12, 5, 64, 31, 7, 99, 1]
      mut as int64: n = listLength(arr)
      println("1. Vetor de entrada (N = 16): " + arr)

      #L Executa as etapas da rede de ordenação bitônica (k varia em potências de 2)
      mut as int64: total_comparators = 0
      mut as int64: k = 2
      infinite (k <= n) {
            mut as int64: j = k /i 2
            infinite (j > 0) {
                  mut as int64: i = 0
                  infinite (i < n) {
                        mut as int64: l = i ^ j
                        route {
                              l > i ==> {
                                    total_comparators = total_comparators + 1
                                    #L Determina a direção da sequência bitônica
                                    mut as int64: dir_bit = i & k
                                    route {
                                          dir_bit == 0 ==> {
                                                #L Ordenação crescente
                                                route {
                                                      arr[i + 1] > arr[l + 1] ==> {
                                                            mut as int64: tmp = arr[i + 1]
                                                            arr[i + 1] = arr[l + 1]
                                                            arr[l + 1] = tmp
                                                      }
                                                }
                                          }
                                          _ ==> {
                                                #L Ordenação decrescente
                                                route {
                                                      arr[i + 1] < arr[l + 1] ==> {
                                                            mut as int64: tmp = arr[i + 1]
                                                            arr[i + 1] = arr[l + 1]
                                                            arr[l + 1] = tmp
                                                      }
                                                }
                                          }
                                    }
                              }
                        }
                        i = i + 1
                  }
                  j = j /i 2
            }
            k = k * 2
      }

      println("2. Total de comparadores executados na rede: " + total_comparators)
      println("3. Vetor ordenado pela rede bitonica: " + arr)

      #L Validação de corretude
      mut as bool: sorted_ok = true
      mut as int64: idx = 1
      infinite (idx < n) {
            route {
                  arr[idx] > arr[idx + 1] ==> {
                        sorted_ok = false
                        break
                  }
            }
            idx = idx + 1
      }
      println("4. Validacao de ordenacao: " + sorted_ok)
      println("==================================================")
}
