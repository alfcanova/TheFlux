#L ============================================================================
#L Algoritmo: Block Sort (WikiSort / GrailSort Concept)
#L Dominio: 01_foundations / Ordenacao
#L Complexidade: O(n log n) tempo | O(1) espaco auxiliar
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosOrdenacaoBlock) {
      println("==================================================")
      println("  SciAlgo: Block Sort (Ordenacao em Blocos)       ")
      println("==================================================")

      mut as list of int64: arr = [9, 1, 8, 2, 7, 3, 6, 4]
      mut as int64: n = listLength(arr)
      println("1. Vetor Original: " + arr)

      mut as int64: block_size = 2
      #L Fase 1: Ordena localmente cada bloco de tamanho block_size
      mut as int64: b_start = 1
      infinite (b_start <= n) {
            mut as int64: b_end = b_start + block_size - 1
            route {
                  b_end > n ==> {
                        b_end = n
                  }
            }
            #L Insertion sort no bloco com guarda segura
            mut as int64: i = b_start + 1
            infinite (i <= b_end) {
                  mut as int64: key = arr[i]
                  mut as int64: j = i - 1
                  infinite (j >= b_start) {
                        route {
                              arr[j] > key ==> {
                                    arr[j + 1] = arr[j]
                                    j = j - 1
                              }
                              _ ==> {
                                    break
                              }
                        }
                  }
                  arr[j + 1] = key
                  i = i + 1
            }
            b_start = b_start + block_size
      }

      #L Fase 2: Intercalacao progressiva de blocos
      mut as int64: width = block_size
      infinite (width < n) {
            mut as int64: left = 1
            infinite (left <= n) {
                  mut as int64: mid = left + width - 1
                  mut as int64: right = left + 2 * width - 1
                  route {
                        right > n ==> {
                              right = n
                        }
                  }
                  route {
                        mid < right ==> {
                              #L Intercalacao in-place dos dois blocos [left..mid] e [mid+1..right]
                              mut as int64: p1 = left
                              mut as int64: p2 = mid + 1
                              infinite (p1 <= mid and p2 <= right) {
                                    route {
                                          arr[p1] <= arr[p2] ==> {
                                                p1 = p1 + 1
                                          }
                                          _ ==> {
                                                mut as int64: val = arr[p2]
                                                mut as int64: idx = p2
                                                infinite (idx > p1) {
                                                      arr[idx] = arr[idx - 1]
                                                      idx = idx - 1
                                                }
                                                arr[p1] = val
                                                p1 = p1 + 1
                                                mid = mid + 1
                                                p2 = p2 + 1
                                          }
                                    }
                              }
                        }
                  }
                  left = left + 2 * width
            }
            width = width * 2
      }

      println("2. Vetor Ordenado: " + arr)
      #L Esperado: [1, 2, 3, 4, 6, 7, 8, 9]
      mut as bool: ok = (arr[1] == 1 and arr[2] == 2 and arr[3] == 3 and arr[4] == 4 and arr[5] == 6 and arr[6] == 7 and arr[7] == 8 and arr[8] == 9)
      println("3. Validacao (Blocos intercalados ordenados): " + ok)
      println("==================================================")
}
