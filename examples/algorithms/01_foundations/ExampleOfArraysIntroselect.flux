#L ============================================================================
#L Algoritmo: Introselect (Selecao Introspectiva de Musser)
#L Dominio: 01_foundations / Categoria: 4. Arrays e sequencias
#L Complexidade: O(N) tempo pior caso | O(log N) espaco de pilha
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfArraysIntroselect) {
      println("==================================================")
      println("  SciAlgo: Introselect (Musser Hybrid Selection)")
      println("==================================================")

      mut as list of int64: arr = [55, 12, 89, 42, 3, 99, 21, 67, 7, 34, 18, 76]
      mut as int64: n = listLength(arr)
      println("1. Array original (N = " + n + "): " + arr)

      #L Busca para K = 1, K = 6 (Mediana), K = 12 (Maximo)
      mut as list of int64: targets = [1, 6, 12]
      mut as int64: t_idx = 1

      infinite (t_idx <= listLength(targets)) {
            mut as int64: k = targets[t_idx]

            #L Copia do array
            mut as list of int64: a = []
            mut as int64: c = 1
            infinite (c <= n) {
                  a = listPushBack(a, arr[c])
                  c = c + 1
            }

            mut as int64: left = 1
            mut as int64: right = n
            #L Profundidade maxima tolerada antes do fallback: 2 * floor(log2(n))
            #L Para N = 12, log2(12) = 3, max_depth = 6
            mut as int64: max_depth = 6
            mut as int64: ans = 0
            mut as bool: done = false

            infinite (left <= right and not done) {
                  route {
                        left == right ==> {
                              ans = a[left]
                              done = true
                        }
                        right - left <= 3 or max_depth == 0 ==> {
                              #L Fallback: Ordenacao simples por insercao no subarray restante
                              mut as int64: x = left
                              infinite (x <= right) {
                                    mut as int64: y = x + 1
                                    infinite (y <= right) {
                                          route {
                                                a[y] < a[x] ==> {
                                                      mut as int64: swp = a[x]
                                                      a[x] = a[y]
                                                      a[y] = swp
                                                }
                                                _ ==> {
                                                }
                                          }
                                          y = y + 1
                                    }
                                    x = x + 1
                              }
                              ans = a[k]
                              done = true
                        }
                        _ ==> {
                              #L Particionamento Quickselect padrao
                              max_depth = max_depth - 1

                              #L Selecao de pivo pelo metodo da mediana de tres
                              mut as int64: mid = left + ((right - left) /i 2)
                              mut as int64: pivot = a[mid]

                              #L Coloca o pivo no final
                              mut as int64: p_swp = a[mid]
                              a[mid] = a[right]
                              a[right] = p_swp

                              mut as int64: store = left
                              mut as int64: scan = left
                              infinite (scan < right) {
                                    route {
                                          a[scan] <= a[right] ==> {
                                                mut as int64: t = a[store]
                                                a[store] = a[scan]
                                                a[scan] = t
                                                store = store + 1
                                          }
                                          _ ==> {
                                          }
                                    }
                                    scan = scan + 1
                              }

                              mut as int64: t_end = a[store]
                              a[store] = a[right]
                              a[right] = t_end

                              route {
                                    store == k ==> {
                                          ans = a[store]
                                          done = true
                                    }
                                    store < k ==> {
                                          left = store + 1
                                    }
                                    _ ==> {
                                          right = store - 1
                                    }
                              }
                        }
                  }
            }

            println("2. K = " + k + " -> Elemento selecionado pelo Introselect: " + ans)
            t_idx = t_idx + 1
      }
}
