#L ============================================================================
#L Algoritmo: Postman's Sort (MSD Hierarchical Radix Sort / Henderson 1969)
#L Domínio: 01_foundations / Categoria: 3. Ordenação
#L Complexidade: O(N * D) tempo | O(N + Base) memória auxiliar | Estável
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSortPostman) {
      println("==================================================")
      println("  SciAlgo: Postman's Sort (MSD Radix Hierarquico)")
      println("==================================================")

      mut as list of int64: arr = [382, 145, 921, 384, 142, 607, 319, 905, 650, 108]
      mut as int64: n = listLength(arr)
      println("1. Vetor de entrada: " + arr)

      #L Pilha explícita para processamento hierárquico (start, end, divisor)
      mut as list of int64: stack_l = [1]
      mut as list of int64: stack_r = [n]
      mut as list of int64: stack_div = [100] #L Inicia pelo dígito mais significativo (centenas)
      mut as int64: stack_top = 1

      mut as int64: total_partitions = 0

      infinite (stack_top > 0) {
            mut as int64: l = stack_l[stack_top]
            mut as int64: r = stack_r[stack_top]
            mut as int64: div_val = stack_div[stack_top]
            stack_top = stack_top - 1

            route {
                  (r <= l) or (div_val <= 0) ==> {
                        #L Segmento de 1 elemento ou dígitos esgotados
                  }
                  _ ==> {
                        total_partitions = total_partitions + 1

                        #L Conta frequências dos 10 dígitos (0 a 9)
                        mut as list of int64: counts = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
                        mut as int64: i = l
                        infinite (i <= r) {
                              mut as int64: digit = (arr[i] /i div_val) /r 10
                              counts[digit + 1] = counts[digit + 1] + 1
                              i = i + 1
                        }

                        #L Calcula cabeçalhos e offsets para distribuição
                        mut as list of int64: heads = []
                        mut as list of int64: offsets = []
                        mut as int64: acc = 1
                        mut as int64: d = 1
                        infinite (d <= 10) {
                              heads = listPushBack(heads, acc)
                              offsets = listPushBack(offsets, acc)
                              acc = acc + counts[d]
                              d = d + 1
                        }

                        #L Buffer temporário do segmento
                        mut as int64: seg_size = r - l + 1
                        mut as list of int64: temp_buf = []
                        i = 1
                        infinite (i <= seg_size) {
                              temp_buf = listPushBack(temp_buf, 0)
                              i = i + 1
                        }

                        #L Distribui no buffer temporário
                        i = l
                        infinite (i <= r) {
                              mut as int64: digit = (arr[i] /i div_val) /r 10
                              mut as int64: pos = heads[digit + 1]
                              temp_buf[pos] = arr[i]
                              heads[digit + 1] = heads[digit + 1] + 1
                              i = i + 1
                        }

                        #L Copia de volta para o vetor original no trecho [l..r]
                        i = 1
                        infinite (i <= seg_size) {
                              arr[l + i - 1] = temp_buf[i]
                              i = i + 1
                        }

                        #L Empilha os subsegmentos não-vazios para o próximo dígito menos significativo
                        mut as int64: next_div = div_val /i 10
                        route {
                              next_div > 0 ==> {
                                    mut as int64: rev_d = 10
                                    infinite (rev_d >= 1) {
                                          mut as int64: cnt = counts[rev_d]
                                          route {
                                                cnt > 1 ==> {
                                                      mut as int64: sub_l = l + offsets[rev_d] - 1
                                                      mut as int64: sub_r = sub_l + cnt - 1
                                                      stack_top = stack_top + 1
                                                      route {
                                                            stack_top > listLength(stack_l) ==> {
                                                                  stack_l = listPushBack(stack_l, sub_l)
                                                                  stack_r = listPushBack(stack_r, sub_r)
                                                                  stack_div = listPushBack(stack_div, next_div)
                                                            }
                                                            _ ==> {
                                                                  stack_l[stack_top] = sub_l
                                                                  stack_r[stack_top] = sub_r
                                                                  stack_div[stack_top] = next_div
                                                            }
                                                      }
                                                }
                                          }
                                          rev_d = rev_d - 1
                                    }
                              }
                        }
                  }
            }
      }

      println("2. Total de particionamentos MSD executados: " + total_partitions)
      println("3. Vetor ordenado pelo Postman's Sort: " + arr)

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
