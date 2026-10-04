#L ============================================================================
#L Algoritmo: Library Sort (Ordenação de Biblioteca / Gapped Insertion Sort)
#L Domínio: 01_foundations / Categoria: 3. Ordenação
#L Complexidade: O(N log N) com alta probabilidade | O(1) deslocamentos médios
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSortLibrary) {
      println("==================================================")
      println("  SciAlgo: Library Sort (Gapped Insertion Sort)")
      println("==================================================")

      mut as list of int64: arr = [37, 12, 85, 43, 61, 19, 74, 28, 9, 56]
      mut as int64: n = listLength(arr)
      println("1. Vetor de entrada: " + arr)

      #L Estante de biblioteca com lacunas (gaps representados por -1)
      mut as int64: shelf_cap = 30
      mut as list of int64: shelf = []
      mut as int64: i = 1
      infinite (i <= shelf_cap) {
            shelf = listPushBack(shelf, -1)
            i = i + 1
      }

      #L Insere o primeiro elemento com espaçamento
      shelf[5] = arr[1]
      mut as int64: num_active = 1
      println("2. Primeiro elemento posicionado na estante.")

      #L Insere os elementos subsequentes usando busca binária e preenchimento de lacunas
      mut as int64: item_idx = 2
      infinite (item_idx <= n) {
            mut as int64: val = arr[item_idx]

            #L Coleta posições dos elementos já alocados na estante
            mut as list of int64: active_slots = []
            mut as list of int64: active_vals = []
            mut as int64: s = 1
            infinite (s <= shelf_cap) {
                  route {
                        shelf[s] != -1 ==> {
                              active_slots = listPushBack(active_slots, s)
                              active_vals = listPushBack(active_vals, shelf[s])
                        }
                  }
                  s = s + 1
            }

            #L Busca binária entre os elementos existentes
            mut as int64: l = 1
            mut as int64: r = listLength(active_vals)
            mut as int64: ins_active_idx = listLength(active_vals) + 1

            infinite (l <= r) {
                  mut as int64: mid = (l + r) /i 2
                  route {
                        active_vals[mid] >= val ==> {
                              ins_active_idx = mid
                              r = mid - 1
                        }
                        _ ==> {
                              l = mid + 1
                        }
                  }
            }

            #L Determina o slot alvo na estante
            mut as int64: target_slot = 1
            route {
                  ins_active_idx <= listLength(active_slots) ==> {
                        target_slot = active_slots[ins_active_idx]
                  }
                  _ ==> {
                        target_slot = active_slots[listLength(active_slots)] + 1
                  }
            }

            #L Se o slot alvo estiver vazio (-1), insere diretamente
            route {
                  shelf[target_slot] == -1 ==> {
                        shelf[target_slot] = val
                  }
                  _ ==> {
                        #L Procura a lacuna (-1) mais próxima à direita para deslocar
                        mut as int64: gap = target_slot
                        infinite (gap <= shelf_cap) {
                              route {
                                    shelf[gap] == -1 ==> {
                                          break
                                    }
                              }
                              gap = gap + 1
                        }

                        #L Desloca apenas o pequeno trecho até a lacuna encontrada
                        mut as int64: shift_p = gap
                        infinite (shift_p > target_slot) {
                              shelf[shift_p] = shelf[shift_p - 1]
                              shift_p = shift_p - 1
                        }
                        shelf[target_slot] = val
                  }
            }

            num_active = num_active + 1

            #L Rebalanceamento periódico (redistribui elementos uniformemente com lacunas intercaladas)
            route {
                  (num_active == 5) or (num_active == 8) ==> {
                        mut as list of int64: tmp_active = []
                        mut as int64: scan = 1
                        infinite (scan <= shelf_cap) {
                              route {
                                    shelf[scan] != -1 ==> {
                                          tmp_active = listPushBack(tmp_active, shelf[scan])
                                          shelf[scan] = -1
                                    }
                              }
                              scan = scan + 1
                        }

                        #L Redistribui com um gap de 2 posições entre livros
                        mut as int64: t_len = listLength(tmp_active)
                        mut as int64: k = 1
                        infinite (k <= t_len) {
                              mut as int64: new_pos = k * 2
                              shelf[new_pos] = tmp_active[k]
                              k = k + 1
                        }
                  }
            }

            item_idx = item_idx + 1
      }

      #L Compacta os livros da estante de volta para o vetor ordenado
      mut as int64: write_idx = 1
      mut as int64: slot = 1
      infinite (slot <= shelf_cap) {
            route {
                  shelf[slot] != -1 ==> {
                        arr[write_idx] = shelf[slot]
                        write_idx = write_idx + 1
                  }
            }
            slot = slot + 1
      }

      println("3. Vetor ordenado pelo Library Sort: " + arr)

      #L Validação de corretude
      mut as bool: sorted_ok = true
      mut as int64: vi = 1
      infinite (vi < n) {
            route {
                  arr[vi] > arr[vi + 1] ==> {
                        sorted_ok = false
                        break
                  }
            }
            vi = vi + 1
      }
      println("4. Validacao de ordenacao: " + sorted_ok)
      println("==================================================")
}
