#L ============================================================================
#L Algoritmo: Introsort (Ordenação Introspectiva Híbrida: Quick + Heap + Insert)
#L Domínio: 01_foundations / Categoria: 3. Ordenação
#L Complexidade: O(N log N) pior caso | O(log N) memória de pilha
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSortIntro) {
      println("==================================================")
      println("  SciAlgo: Introsort (QuickSort + HeapSort + Insert)")
      println("==================================================")

      mut as list of int64: arr = [24, 97, 40, 67, 88, 85, 15, 66, 53, 44, 26, 48, 16, 52, 45, 39]
      mut as int64: n = listLength(arr)
      println("1. Vetor de entrada (N = 16): " + arr)

      #L Pilhas explícitas para simular a recursão e profundidade do Introsort
      mut as list of int64: stack_l = [1]
      mut as list of int64: stack_r = [n]
      mut as list of int64: stack_depth = [2] #L Limite de profundidade para acionar HeapSort
      mut as int64: stack_top = 1

      mut as int64: quick_count = 0
      mut as int64: heap_count = 0
      mut as int64: insert_count = 0

      infinite (stack_top > 0) {
            mut as int64: l = stack_l[stack_top]
            mut as int64: r = stack_r[stack_top]
            mut as int64: d = stack_depth[stack_top]
            stack_top = stack_top - 1

            mut as int64: seg_len = r - l + 1
            route {
                  #L Caso base 1: Subvetores pequenos (<= 4) usam Insertion Sort
                  seg_len <= 4 ==> {
                        insert_count = insert_count + 1
                        mut as int64: i = l + 1
                        infinite (i <= r) {
                              mut as int64: key = arr[i]
                              mut as int64: j = i - 1
                              infinite (j >= l) {
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
                  }
                  #L Caso base 2: Limite de profundidade excedido; fallback seguro para HeapSort O(N log N)
                  d <= 0 ==> {
                        heap_count = heap_count + 1
                        #L Constrói o max-heap no subvetor arr[l..r]
                        mut as int64: count_heap = r - l + 1
                        mut as int64: p = l + count_heap /i 2 - 1
                        infinite (p >= l) {
                              mut as int64: root = p
                              infinite (true) {
                                    mut as int64: child = 2 * (root - l + 1) - 1 + l
                                    route {
                                          child > r ==> { break }
                                    }
                                    route {
                                          (child + 1) <= r ==> {
                                                route {
                                                      arr[child + 1] > arr[child] ==> {
                                                            child = child + 1
                                                      }
                                                }
                                          }
                                    }
                                    route {
                                          arr[root] < arr[child] ==> {
                                                mut as int64: tmp = arr[root]
                                                arr[root] = arr[child]
                                                arr[child] = tmp
                                                root = child
                                          }
                                          _ ==> {
                                                break
                                          }
                                    }
                              }
                              p = p - 1
                        }

                        #L Extrai elementos do max-heap
                        mut as int64: end_h = r
                        infinite (end_h > l) {
                              mut as int64: tmp = arr[l]
                              arr[l] = arr[end_h]
                              arr[end_h] = tmp
                              end_h = end_h - 1

                              #L Re-heapify
                              mut as int64: root = l
                              infinite (true) {
                                    mut as int64: child = 2 * (root - l + 1) - 1 + l
                                    route {
                                          child > end_h ==> { break }
                                    }
                                    route {
                                          (child + 1) <= end_h ==> {
                                                route {
                                                      arr[child + 1] > arr[child] ==> {
                                                            child = child + 1
                                                      }
                                                }
                                          }
                                    }
                                    route {
                                          arr[root] < arr[child] ==> {
                                                mut as int64: sw = arr[root]
                                                arr[root] = arr[child]
                                                arr[child] = sw
                                                root = child
                                          }
                                          _ ==> {
                                                break
                                          }
                                    }
                              }
                        }
                  }
                  #L Caso geral: Partição de QuickSort
                  _ ==> {
                        quick_count = quick_count + 1
                        mut as int64: pivot = arr[r]
                        mut as int64: pi = l
                        mut as int64: pj = l
                        infinite (pj < r) {
                              route {
                                    arr[pj] <= pivot ==> {
                                          mut as int64: tmp = arr[pi]
                                          arr[pi] = arr[pj]
                                          arr[pj] = tmp
                                          pi = pi + 1
                                    }
                              }
                              pj = pj + 1
                        }
                        arr[r] = arr[pi]
                        arr[pi] = pivot

                        #L Empilha partições esquerda e direita
                        route {
                              (pi - 1) > l ==> {
                                    stack_top = stack_top + 1
                                    route {
                                          stack_top > listLength(stack_l) ==> {
                                                stack_l = listPushBack(stack_l, l)
                                                stack_r = listPushBack(stack_r, pi - 1)
                                                stack_depth = listPushBack(stack_depth, d - 1)
                                          }
                                          _ ==> {
                                                stack_l[stack_top] = l
                                                stack_r[stack_top] = pi - 1
                                                stack_depth[stack_top] = d - 1
                                          }
                                    }
                              }
                        }
                        route {
                              r > (pi + 1) ==> {
                                    stack_top = stack_top + 1
                                    route {
                                          stack_top > listLength(stack_l) ==> {
                                                stack_l = listPushBack(stack_l, pi + 1)
                                                stack_r = listPushBack(stack_r, r)
                                                stack_depth = listPushBack(stack_depth, d - 1)
                                          }
                                          _ ==> {
                                                stack_l[stack_top] = pi + 1
                                                stack_r[stack_top] = r
                                                stack_depth[stack_top] = d - 1
                                          }
                                    }
                              }
                        }
                  }
            }
      }

      println("2. Estatisticas Introsort: QuickSort = " + quick_count + ", HeapSort = " + heap_count + ", InsertionSort = " + insert_count)
      println("3. Vetor ordenado pelo Introsort: " + arr)

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
