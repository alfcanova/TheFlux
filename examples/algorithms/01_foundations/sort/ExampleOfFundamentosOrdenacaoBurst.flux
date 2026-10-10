#L ============================================================================
#L Algoritmo: Burstsort (Ordenação Híbrida Trie-Baldes com Limiar de Ruptura)
#L Domínio: 01_foundations / Categoria: 3. Ordenação
#L Complexidade: O(N) cache-eficiente | O(N) espaço | Sinha & Zobel (2004)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosOrdenacaoBurst) {
      println("==================================================")
      println("  SciAlgo: Burstsort (Trie Dinamica com Burst)")
      println("==================================================")

      mut as list of int64: arr = [45, 12, 89, 41, 19, 48, 15, 82, 43, 90, 11, 47, 85, 33]
      mut as int64: n = listLength(arr)
      println("1. Vetor de entrada: " + arr)

      mut as int64: burst_limit = 3
      println("2. Limiar de ruptura (burst threshold): " + burst_limit)

      #L Estrutura da Trie de Nível 1 (Dígito mais significativo: dezenas 0..9)
      mut as list of bool: is_burst = []
      mut as list of int64: root_bucket_sz = []
      mut as int64: d = 1
      infinite (d <= 10) {
            is_burst = listPushBack(is_burst, false)
            root_bucket_sz = listPushBack(root_bucket_sz, 0)
            d = d + 1
      }

      #L Alocação plana para baldes de nível 1 (10 dígitos x capacidade 10)
      mut as list of int64: root_bucket_items = []
      mut as int64: total_root_items = 100
      d = 1
      infinite (d <= total_root_items) {
            root_bucket_items = listPushBack(root_bucket_items, 0)
            d = d + 1
      }

      #L Alocação plana para nós filhos após o burst (10 x 10 = 100 sub-baldes x capacidade 10)
      mut as list of int64: sub_bucket_sz = []
      d = 1
      infinite (d <= 100) {
            sub_bucket_sz = listPushBack(sub_bucket_sz, 0)
            d = d + 1
      }

      mut as list of int64: sub_bucket_items = []
      mut as int64: total_sub_items = 1000
      d = 1
      infinite (d <= total_sub_items) {
            sub_bucket_items = listPushBack(sub_bucket_items, 0)
            d = d + 1
      }

      mut as int64: burst_events = 0

      #L Inserção progressiva na Trie
      mut as int64: i = 1
      infinite (i <= n) {
            mut as int64: val = arr[i]
            mut as int64: d1 = (val /i 10) + 1 #L Índice 1 a 10
            route {
                  d1 > 10 ==> { d1 = 10 }
                  d1 < 1 ==> { d1 = 1 }
            }

            route {
                  is_burst[d1] ==> {
                        #L Nó já explodiu em sub-trie: insere diretamente no sub-balde pelo dígito de unidades
                        mut as int64: d2 = (val /r 10) + 1 #L 1 a 10
                        mut as int64: sub_id = (d1 - 1) * 10 + d2
                        mut as int64: cur_sub_sz = sub_bucket_sz[sub_id] + 1
                        sub_bucket_sz[sub_id] = cur_sub_sz
                        mut as int64: pos = (sub_id - 1) * 10 + cur_sub_sz
                        sub_bucket_items[pos] = val
                  }
                  _ ==> {
                        #L Balde folha ainda intacto
                        mut as int64: cur_sz = root_bucket_sz[d1] + 1
                        root_bucket_sz[d1] = cur_sz
                        mut as int64: pos = (d1 - 1) * 10 + cur_sz
                        root_bucket_items[pos] = val

                        #L Verifica se atingiu a capacidade de ruptura (BURST)
                        route {
                              cur_sz > burst_limit ==> {
                                    burst_events = burst_events + 1
                                    is_burst[d1] = true

                                    #L Redistribui todos os elementos do balde folha nos sub-baldes
                                    mut as int64: item_idx = 1
                                    infinite (item_idx <= cur_sz) {
                                          mut as int64: item_pos = (d1 - 1) * 10 + item_idx
                                          mut as int64: item_val = root_bucket_items[item_pos]
                                          mut as int64: d2 = (item_val /r 10) + 1
                                          mut as int64: sub_id = (d1 - 1) * 10 + d2
                                          mut as int64: s_sz = sub_bucket_sz[sub_id] + 1
                                          sub_bucket_sz[sub_id] = s_sz
                                          mut as int64: s_pos = (sub_id - 1) * 10 + s_sz
                                          sub_bucket_items[s_pos] = item_val
                                          item_idx = item_idx + 1
                                    }
                              }
                        }
                  }
            }

            i = i + 1
      }

      println("3. Total de eventos de Burst ocorridos: " + burst_events)

      #L Travessia em ordem (in-order traversal) da Trie para reconstruir o vetor ordenado
      mut as list of int64: output = []
      mut as int64: p1 = 1
      infinite (p1 <= 10) {
            route {
                  is_burst[p1] ==> {
                        #L Percorre os 10 sub-baldes
                        mut as int64: p2 = 1
                        infinite (p2 <= 10) {
                              mut as int64: sub_id = (p1 - 1) * 10 + p2
                              mut as int64: s_sz = sub_bucket_sz[sub_id]
                              route {
                                    s_sz > 0 ==> {
                                          #L Coleta e ordena localmente com Insertion Sort
                                          mut as list of int64: sub_list = []
                                          mut as int64: sk = 1
                                          infinite (sk <= s_sz) {
                                                mut as int64: spos = (sub_id - 1) * 10 + sk
                                                sub_list = listPushBack(sub_list, sub_bucket_items[spos])
                                                sk = sk + 1
                                          }

                                          mut as int64: sj = 2
                                          infinite (sj <= s_sz) {
                                                mut as int64: key = sub_list[sj]
                                                mut as int64: sp = sj - 1
                                                infinite (sp >= 1) {
                                                      route {
                                                            sub_list[sp] > key ==> {
                                                                  sub_list[sp + 1] = sub_list[sp]
                                                                  sp = sp - 1
                                                            }
                                                            _ ==> { break }
                                                      }
                                                }
                                                sub_list[sp + 1] = key
                                                sj = sj + 1
                                          }

                                          sk = 1
                                          infinite (sk <= s_sz) {
                                                output = listPushBack(output, sub_list[sk])
                                                sk = sk + 1
                                          }
                                    }
                              }
                              p2 = p2 + 1
                        }
                  }
                  _ ==> {
                        mut as int64: b_sz = root_bucket_sz[p1]
                        route {
                              b_sz > 0 ==> {
                                    mut as list of int64: b_list = []
                                    mut as int64: bk = 1
                                    infinite (bk <= b_sz) {
                                          mut as int64: bpos = (p1 - 1) * 10 + bk
                                          b_list = listPushBack(b_list, root_bucket_items[bpos])
                                          bk = bk + 1
                                    }

                                    mut as int64: bj = 2
                                    infinite (bj <= b_sz) {
                                          mut as int64: key = b_list[bj]
                                          mut as int64: bp = bj - 1
                                          infinite (bp >= 1) {
                                                route {
                                                      b_list[bp] > key ==> {
                                                            b_list[bp + 1] = b_list[bp]
                                                            bp = bp - 1
                                                      }
                                                      _ ==> { break }
                                                }
                                          }
                                          b_list[bp + 1] = key
                                          bj = bj + 1
                                    }

                                    bk = 1
                                    infinite (bk <= b_sz) {
                                          output = listPushBack(output, b_list[bk])
                                          bk = bk + 1
                                    }
                              }
                        }
                  }
            }
            p1 = p1 + 1
      }

      #L Copia resultado ordenado de volta para arr
      i = 1
      infinite (i <= n) {
            arr[i] = output[i]
            i = i + 1
      }

      println("4. Vetor ordenado pelo Burstsort: " + arr)

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
      println("5. Validacao de ordenacao: " + sorted_ok)
      println("==================================================")
}
