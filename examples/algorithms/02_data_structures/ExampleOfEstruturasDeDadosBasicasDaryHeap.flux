#L ============================================================================
#L Algoritmo: D-ary Heap (Heap 4-ario de Minimo)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados (Adicoes Prioritarias)
#L Complexidade: Insercao O(log_D N) | Remocao O(D log_D N) | Peek O(1)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosBasicasDaryHeap) {
      println("==================================================")
      println("  SciAlgo: D-ary Heap (4-ary Min-Heap)")
      println("==================================================")

      mut as int64: d = 4
      println("1. Grau do heap (D filhos por no): " + d)

      mut as list of int64: entradas = [50, 23, 88, 12, 6, 71, 35, 19, 4, 95]
      mut as int64: n_in = listLength(entradas)
      println("2. Inserindo elementos: " + entradas)

      mut as list of int64: heap = []

      #L Insercao com Sift-Up no Heap D-ario (1-based)
      mut as int64: in_idx = 1
      infinite (in_idx <= n_in) {
            mut as int64: val = entradas[in_idx]
            heap = listPushBack(heap, val)
            mut as int64: idx = listLength(heap)

            #L Sift up
            infinite (idx > 1) {
                  mut as int64: parent_idx = ((idx - 2) /i d) + 1
                  route {
                        heap[idx] < heap[parent_idx] ==> {
                              mut as int64: tmp = heap[idx]
                              heap[idx] = heap[parent_idx]
                              heap[parent_idx] = tmp
                              idx = parent_idx
                        }
                        _ ==> {
                              idx = 1
                        }
                  }
            }
            in_idx = in_idx + 1
      }

      println("3. Estrutura do 4-ary Heap resultante: " + heap)
      println("4. Elemento de menor valor na raiz (Peek): " + heap[1])

      #L Remocao sucessiva do minimo (Extract-Min) com Sift-Down
      mut as list of int64: extraidos = []
      infinite (listLength(heap) > 0) {
            mut as int64: h_len = listLength(heap)
            mut as int64: min_elem = heap[1]
            extraidos = listPushBack(extraidos, min_elem)

            route {
                  h_len == 1 ==> {
                        heap = []
                  }
                  _ ==> {
                        #L Substitui raiz pelo ultimo elemento e reduz tamanho
                        heap[1] = heap[h_len]
                        mut as list of int64: n_h = []
                        mut as int64: ci = 1
                        infinite (ci < h_len) {
                              n_h = listPushBack(n_h, heap[ci])
                              ci = ci + 1
                        }
                        heap = n_h
                        mut as int64: cur_sz = listLength(heap)
                        mut as int64: cur = 1

                        #L Sift down entre os D filhos
                        mut as bool: sifting = true
                        infinite (sifting) {
                              mut as int64: smallest = cur
                              mut as int64: first_child = (d * (cur - 1)) + 2
                              mut as int64: k = 0

                              infinite (k < d) {
                                    mut as int64: child = first_child + k
                                    route {
                                          child <= cur_sz ==> {
                                                route {
                                                      heap[child] < heap[smallest] ==> {
                                                            smallest = child
                                                      }
                                                      _ ==> {
                                                      }
                                                }
                                          }
                                          _ ==> {
                                          }
                                    }
                                    k = k + 1
                              }

                              route {
                                    smallest != cur ==> {
                                          mut as int64: t = heap[cur]
                                          heap[cur] = heap[smallest]
                                          heap[smallest] = t
                                          cur = smallest
                                    }
                                    _ ==> {
                                          sifting = false
                                    }
                              }
                        }
                  }
            }
      }

      println("5. Elementos extraidos por prioridade: " + extraidos)

      #L Verificacao de ordenacao ascendente
      mut as bool: ordenado = true
      mut as int64: vi = 1
      mut as int64: n_ext = listLength(extraidos)
      infinite (vi < n_ext) {
            route {
                  extraidos[vi] > extraidos[vi + 1] ==> {
                        ordenado = false
                  }
                  _ ==> {
                  }
            }
            vi = vi + 1
      }
      println("6. Verificacao de integridade (Ordenado): " + ordenado)
      println("Concluido com Sucesso")
}

