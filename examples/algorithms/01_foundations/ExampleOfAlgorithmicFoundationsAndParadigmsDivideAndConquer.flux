#L ============================================================================
#L Algoritmo: Divide and Conquer (Divisao e Conquista)
#L Dominio: 01_foundations / Categoria: 1. Fundamentos e paradigmas algoritmicos
#L Complexidade: O(N log N) tempo | O(log N) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfAlgorithmicFoundationsAndParadigmsDivideAndConquer) {
      println("==================================================")
      println("  SciAlgo: Divide and Conquer (Divisao e Conquista)")
      println("==================================================")

      mut as list of int64: arr = [-2, 1, -3, 4, -1, 2, 1, -5, 4]
      mut as int64: n = listLength(arr)
      println("1. Vetor de entrada: " + arr)

      #L Pilhas para simular execucao de Divisao e Conquista (Max Subarray)
      #L st_l: limites esquerdos, st_r: limites direitos, st_stage: 0=dividir, 1=combinar
      mut as list of int64: st_l = [1]
      mut as list of int64: st_r = [n]
      mut as list of int64: st_stage = [0]
      mut as list of int64: val_stack = []

      mut as int64: divisions_count = 0
      mut as int64: merges_count = 0

      infinite (listLength(st_l) > 0) {
            mut as int64: top = listLength(st_l)
            mut as int64: l = st_l[top]
            mut as int64: r = st_r[top]
            mut as int64: stage = st_stage[top]

            #L Remove topo das pilhas de controle
            mut as list of int64: n_l = []
            mut as list of int64: n_r = []
            mut as list of int64: n_st = []
            mut as int64: idx = 1
            infinite (idx < top) {
                  n_l = listPushBack(n_l, st_l[idx])
                  n_r = listPushBack(n_r, st_r[idx])
                  n_st = listPushBack(n_st, st_stage[idx])
                  idx = idx + 1
            }
            st_l = n_l
            st_r = n_r
            st_stage = n_st

            route {
                  l == r ==> {
                        #L Caso Base: elemento unico
                        val_stack = listPushBack(val_stack, arr[l])
                  }
                  stage == 0 ==> {
                        #L Fase Divide: agenda combinacao e empilha metades
                        mut as int64: m = (l + r) /i 2
                        divisions_count = divisions_count + 1

                        #L 1. Re-empilha o no atual com stage=1 para combinar depois
                        st_l = listPushBack(st_l, l)
                        st_r = listPushBack(st_r, r)
                        st_stage = listPushBack(st_stage, 1)

                        #L 2. Empilha metade direita
                        st_l = listPushBack(st_l, m + 1)
                        st_r = listPushBack(st_r, r)
                        st_stage = listPushBack(st_stage, 0)

                        #L 3. Empilha metade esquerda
                        st_l = listPushBack(st_l, l)
                        st_r = listPushBack(st_r, m)
                        st_stage = listPushBack(st_stage, 0)
                  }
                  stage == 1 ==> {
                        #L Fase Conquer & Combine: desempilha resultados da esquerda e direita
                        mut as int64: v_top = listLength(val_stack)
                        mut as int64: right_max = val_stack[v_top]
                        mut as int64: left_max = val_stack[v_top - 1]

                        #L Remove os 2 valores
                        mut as list of int64: n_val = []
                        mut as int64: vi = 1
                        infinite (vi < (v_top - 1)) {
                              n_val = listPushBack(n_val, val_stack[vi])
                              vi = vi + 1
                        }
                        val_stack = n_val

                        #L Calcula soma cruzada passando pelo ponto medio m
                        mut as int64: m = (l + r) /i 2
                        mut as int64: sum_l = 0
                        mut as int64: max_cross_l = arr[m]
                        mut as int64: ci = m
                        infinite (ci >= l) {
                              sum_l = sum_l + arr[ci]
                              route {
                                    sum_l > max_cross_l ==> {
                                          max_cross_l = sum_l
                                    }
                                    _ ==> {
                              }
                              }
                              ci = ci - 1
                        }

                        mut as int64: sum_r = 0
                        mut as int64: max_cross_r = arr[m + 1]
                        mut as int64: cj = m + 1
                        infinite (cj <= r) {
                              sum_r = sum_r + arr[cj]
                              route {
                                    sum_r > max_cross_r ==> {
                                          max_cross_r = sum_r
                                    }
                                    _ ==> {
                                    }
                              }
                              cj = cj + 1
                        }

                        mut as int64: cross_max = max_cross_l + max_cross_r

                        #L max_comb = max(left_max, right_max, cross_max)
                        mut as int64: max_comb = left_max
                        route {
                              right_max > max_comb ==> {
                                    max_comb = right_max
                              }
                              _ ==> {
                              }
                        }
                        route {
                              cross_max > max_comb ==> {
                                    max_comb = cross_max
                              }
                              _ ==> {
                              }
                        }

                        merges_count = merges_count + 1
                        val_stack = listPushBack(val_stack, max_comb)
                  }
                  _ ==> {
                  }
            }
      }

      mut as int64: final_result = val_stack[1]
      println("2. Total de particionamentos (Divide): " + divisions_count)
      println("3. Total de combinacoes (Conquer): " + merges_count)
      println("4. Soma maxima obtida: " + final_result)
      println("Concluido com Sucesso")
}
