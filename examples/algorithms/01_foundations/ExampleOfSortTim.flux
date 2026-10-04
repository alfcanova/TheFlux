#L ============================================================================
#L Algoritmo: Timsort (Híbrido Industrial: Corridas Naturais + Binary Insertion + Merge Stack)
#L Domínio: 01_foundations / Categoria: 3. Ordenação
#L Complexidade: O(N log N) pior caso | O(N) melhor caso (adaptativo) | Estável
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSortTim) {
      println("==================================================")
      println("  SciAlgo: Timsort (Corridas Naturais e Insercao)")
      println("==================================================")

      mut as list of int64: arr = [33, 14, 55, 78, 92, 10, 5, 2, 60, 48, 25, 71, 80, 19, 3, 42]
      mut as int64: n = listLength(arr)
      println("1. Vetor de entrada (N = 16): " + arr)

      mut as int64: minrun = 4
      println("2. Tamanho minimo de corrida (minrun): " + minrun)

      #L Pilha de corridas para mesclagem balanceada
      mut as list of int64: stack_start = []
      mut as list of int64: stack_len = []
      mut as int64: stack_top = 0

      mut as int64: idx = 1
      infinite (idx <= n) {
            mut as int64: r_start = idx
            route {
                  idx == n ==> {
                        #L Último elemento isolado
                        stack_top = stack_top + 1
                        stack_start = listPushBack(stack_start, r_start)
                        stack_len = listPushBack(stack_len, 1)
                        idx = idx + 1
                  }
                  _ ==> {
                        #L Identifica direção da corrida natural (crescente vs estritamente decrescente)
                        mut as bool: is_descending = false
                        route {
                              arr[idx] > arr[idx + 1] ==> {
                                    is_descending = true
                              }
                        }

                        route {
                              is_descending ==> {
                                    infinite (idx < n) {
                                          route {
                                                arr[idx] > arr[idx + 1] ==> {
                                                      idx = idx + 1
                                                }
                                                _ ==> {
                                                      break
                                                }
                                          }
                                    }
                                    idx = idx + 1
                                    #L Inverte corrida estritamente decrescente para torná-la crescente
                                    mut as int64: rev_l = r_start
                                    mut as int64: rev_r = idx - 1
                                    infinite (rev_l < rev_r) {
                                          mut as int64: tmp = arr[rev_l]
                                          arr[rev_l] = arr[rev_r]
                                          arr[rev_r] = tmp
                                          rev_l = rev_l + 1
                                          rev_r = rev_r - 1
                                    }
                              }
                              _ ==> {
                                    infinite (idx < n) {
                                          route {
                                                arr[idx] <= arr[idx + 1] ==> {
                                                      idx = idx + 1
                                                }
                                                _ ==> {
                                                      break
                                                }
                                          }
                                    }
                                    idx = idx + 1
                              }
                        }

                        mut as int64: current_len = idx - r_start

                        #L Extensão com Binary Insertion Sort caso current_len < minrun
                        route {
                              current_len < minrun ==> {
                                    mut as int64: r_end = r_start + minrun - 1
                                    route {
                                          r_end > n ==> {
                                                r_end = n
                                          }
                                    }

                                    #L Binary Insertion Sort no segmento [r_start .. r_end]
                                    mut as int64: bi = r_start + 1
                                    infinite (bi <= r_end) {
                                          mut as int64: key = arr[bi]
                                          mut as int64: bl = r_start
                                          mut as int64: br = bi - 1
                                          infinite (bl <= br) {
                                                mut as int64: bmid = (bl + br) /i 2
                                                route {
                                                      key < arr[bmid] ==> {
                                                            br = bmid - 1
                                                      }
                                                      _ ==> {
                                                            bl = bmid + 1
                                                      }
                                                }
                                          }
                                          #L Desloca elementos à direita para abrir espaço
                                          mut as int64: bj = bi - 1
                                          infinite (bj >= bl) {
                                                arr[bj + 1] = arr[bj]
                                                bj = bj - 1
                                          }
                                          arr[bl] = key
                                          bi = bi + 1
                                    }

                                    current_len = r_end - r_start + 1
                                    idx = r_end + 1
                              }
                        }

                        #L Empilha a corrida
                        stack_top = stack_top + 1
                        route {
                              stack_top > listLength(stack_start) ==> {
                                    stack_start = listPushBack(stack_start, r_start)
                                    stack_len = listPushBack(stack_len, current_len)
                              }
                              _ ==> {
                                    stack_start[stack_top] = r_start
                                    stack_len[stack_top] = current_len
                              }
                        }

                        #L Mesclagem progressiva do topo da pilha de corridas
                        infinite (stack_top > 1) {
                              mut as int64: s1 = stack_start[stack_top - 1]
                              mut as int64: l1 = stack_len[stack_top - 1]
                              mut as int64: s2 = stack_start[stack_top]
                              mut as int64: l2 = stack_len[stack_top]

                              #L Mescla arr[s1 .. s1+l1-1] com arr[s2 .. s2+l2-1]
                              mut as list of int64: m_buf = []
                              mut as int64: mi = s1
                              mut as int64: mj = s2
                              mut as int64: mend1 = s1 + l1
                              mut as int64: mend2 = s2 + l2

                              infinite ((mi < mend1) and (mj < mend2)) {
                                    route {
                                          arr[mi] <= arr[mj] ==> {
                                                m_buf = listPushBack(m_buf, arr[mi])
                                                mi = mi + 1
                                          }
                                          _ ==> {
                                                m_buf = listPushBack(m_buf, arr[mj])
                                                mj = mj + 1
                                          }
                                    }
                              }
                              infinite (mi < mend1) {
                                    m_buf = listPushBack(m_buf, arr[mi])
                                    mi = mi + 1
                              }
                              infinite (mj < mend2) {
                                    m_buf = listPushBack(m_buf, arr[mj])
                                    mj = mj + 1
                              }

                              #L Copia buffer de volta
                              mut as int64: m_total = listLength(m_buf)
                              mut as int64: mk = 1
                              infinite (mk <= m_total) {
                                    arr[s1 + mk - 1] = m_buf[mk]
                                    mk = mk + 1
                              }

                              stack_top = stack_top - 1
                              stack_len[stack_top] = l1 + l2
                        }
                  }
            }
      }

      println("3. Vetor ordenado pelo Timsort: " + arr)

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
