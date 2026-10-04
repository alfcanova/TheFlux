#L ============================================================================
#L Algoritmo: Binary Heap (Min-Heap com Array 1-Based)
#L Dominio: 02_data_structures / Categoria: Heaps e Filas de Prioridade
#L Complexidade: Insercao O(log N) | Remocao de Minimo O(log N) | Peek O(1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

function (heapPush) (as list of int64: h, as int64: val) as list of int64 {
      mut as list of int64: res = listPushBack(h, val)
      mut as int64: idx = listLength(res)
      
      infinite (idx > 1) {
            mut as int64: parent_idx = idx /i 2
            mut as int64: current_val = res[idx]
            mut as int64: parent_val = res[parent_idx]
            
            route {
                  current_val < parent_val ==> {
                        res[idx] = parent_val
                        res[parent_idx] = current_val
                        idx = parent_idx
                  }
                  _ ==> {
                        break
                  }
            }
      }
      
      emit(nice, res, "ok")
}

function (heapPop) (as list of int64: h) as list of data {
      mut as int64: n = listLength(h)
      route {
            n == 0 ==> {
                  mut as list of data: vazio = [0, []]
                  emit(nice, vazio, "empty")
            }
            n == 1 ==> {
                  mut as int64: min_elem = h[1]
                  mut as list of data: unico = [min_elem, []]
                  emit(nice, unico, "ok")
            }
            _ ==> {
                  mut as int64: min_val = h[1]
                  mut as list of int64: res = []
                  mut as int64: i = 1
                  infinite (i <= n) {
                        res = listPushBack(res, h[i])
                        i = i + 1
                  }
                  
                  #L Move o ultimo para o topo e remove o ultimo
                  res[1] = res[n]
                  res = listTake(res, n - 1)
                  mut as int64: cur_len = n - 1
                  mut as int64: idx = 1
                  
                  #L Sift down
                  infinite (true) {
                        mut as int64: left = idx * 2
                        mut as int64: right = left + 1
                        mut as int64: smallest = idx
                        
                        route {
                              left <= cur_len ==> {
                                    route {
                                          res[left] < res[smallest] ==> {
                                                smallest = left
                                          }
                                    }
                              }
                        }
                        route {
                              right <= cur_len ==> {
                                    route {
                                          res[right] < res[smallest] ==> {
                                                smallest = right
                                          }
                                    }
                              }
                        }
                        
                        route {
                              smallest != idx ==> {
                                    mut as int64: tmp = res[idx]
                                    res[idx] = res[smallest]
                                    res[smallest] = tmp
                                    idx = smallest
                              }
                              _ ==> {
                                    break
                              }
                        }
                  }
                  
                  mut as list of data: ret = [min_val, res]
                  emit(nice, ret, "ok")
            }
      }
}

program (ExampleOfBinaryHeap) {
      println("==================================================")
      println("  SciAlgo: Binary Heap (Min-Heap 1-Based)")
      println("==================================================")

      mut as list of int64: heap = []
      mut as list of int64: entradas = [42, 15, 88, 3, 27, 10, 99]
      println("1. Inserindo elementos: " + entradas)

      mut as int64: i = 1
      mut as int64: n = listLength(entradas)
      infinite (i <= n) {
            heap = heapPush(heap, entradas[i])
            i = i + 1
      }
      println("2. Heap estruturado: " + heap)
      println("3. Menor elemento no topo (Peek): " + heap[1])

      println("4. Extraindo elementos em ordem de prioridade:")
      mut as list of int64: extraidos = []
      infinite (listLength(heap) > 0) {
            mut as list of data: pop_res = heapPop(heap)
            mut as int64: min_elem = pop_res[1] as int64
            heap = pop_res[2] as list of int64
            extraidos = listPushBack(extraidos, min_elem)
      }
      println("   Elementos extraidos: " + extraidos)

      #L Verificacao de ordenacao estrita
      mut as bool: ordenado = true
      i = 1
      mut as int64: m = listLength(extraidos)
      infinite (i < m) {
            route {
                  extraidos[i] > extraidos[i + 1] ==> {
                        ordenado = false
                        break
                  }
            }
            i = i + 1
      }
      println("5. Verificacao de ordenacao ascendente: " + ordenado)
      println("==================================================")
}
