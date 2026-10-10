#L ============================================================================
#L Algoritmo: Slowsort (Paradigma Pessimal Multiply-and-Surrender / Broder & Stolfi 1984)
#L Domínio: 01_foundations / Categoria: 3. Ordenação
#L Complexidade: T(N) > N^(log N / c) super-polinomial | Antítese do Divide and Conquer
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosOrdenacaoSlow) {
      println("==================================================")
      println("  SciAlgo: Slowsort (Multiply and Surrender)")
      println("==================================================")

      #L Variáveis no escopo superior para estabilidade e dominância em LLVM
      mut as int64: cur_i = 0
      mut as int64: cur_j = 0
      mut as int64: cur_st = 0
      mut as int64: m = 0
      mut as int64: steps = 0

      #L Vetor propositalmente pequeno (N = 6) devido ao crescimento super-polinomial
      mut as list of int64: arr = [5, 2, 8, 1, 9, 3]
      mut as int64: n = listLength(arr)
      println("1. Vetor de entrada (N = 6): " + arr)

      #L Pilha de ativação explícita com máquina de estados (i, j, state)
      #L state 1: antes do primeiro sub-problema [i..m]
      #L state 2: antes do segundo sub-problema [m+1..j]
      #L state 3: após os sub-problemas, aplica comparador e invoca [i..j-1]
      mut as list of int64: st_i = [1]
      mut as list of int64: st_j = [n]
      mut as list of int64: st_state = [1]
      mut as int64: top = 1

      infinite (top > 0) {
            steps = steps + 1
            cur_i = st_i[top]
            cur_j = st_j[top]
            cur_st = st_state[top]
            top = top - 1

            route {
                  cur_i >= cur_j ==> {
                        #L Caso base trivial (tamanho <= 1): elemento já posicionado
                  }
                  _ ==> {
                        m = (cur_i + cur_j) /i 2

                        route {
                              cur_st == 1 ==> {
                                    #L Transição para estado 2 e empilha sub-problema esquerdo [cur_i..m]
                                    top = top + 1
                                    route {
                                          top > listLength(st_i) ==> {
                                                st_i = listPushBack(st_i, cur_i)
                                                st_j = listPushBack(st_j, cur_j)
                                                st_state = listPushBack(st_state, 2)
                                          }
                                          _ ==> {
                                                st_i[top] = cur_i
                                                st_j[top] = cur_j
                                                st_state[top] = 2
                                          }
                                    }

                                    top = top + 1
                                    route {
                                          top > listLength(st_i) ==> {
                                                st_i = listPushBack(st_i, cur_i)
                                                st_j = listPushBack(st_j, m)
                                                st_state = listPushBack(st_state, 1)
                                          }
                                          _ ==> {
                                                st_i[top] = cur_i
                                                st_j[top] = m
                                                st_state[top] = 1
                                          }
                                    }
                              }
                              cur_st == 2 ==> {
                                    #L Transição para estado 3 e empilha sub-problema direito [m+1..cur_j]
                                    top = top + 1
                                    route {
                                          top > listLength(st_i) ==> {
                                                st_i = listPushBack(st_i, cur_i)
                                                st_j = listPushBack(st_j, cur_j)
                                                st_state = listPushBack(st_state, 3)
                                          }
                                          _ ==> {
                                                st_i[top] = cur_i
                                                st_j[top] = cur_j
                                                st_state[top] = 3
                                          }
                                    }

                                    top = top + 1
                                    route {
                                          top > listLength(st_i) ==> {
                                                st_i = listPushBack(st_i, m + 1)
                                                st_j = listPushBack(st_j, cur_j)
                                                st_state = listPushBack(st_state, 1)
                                          }
                                          _ ==> {
                                                st_i[top] = m + 1
                                                st_j[top] = cur_j
                                                st_state[top] = 1
                                          }
                                    }
                              }
                              cur_st == 3 ==> {
                                    #L Posiciona o elemento máximo no final cur_j
                                    route {
                                          arr[m] > arr[cur_j] ==> {
                                                mut as int64: tmp = arr[m]
                                                arr[m] = arr[cur_j]
                                                arr[cur_j] = tmp
                                          }
                                    }

                                    #L Empilha ordenação do restante do vetor [cur_i .. cur_j - 1]
                                    top = top + 1
                                    route {
                                          top > listLength(st_i) ==> {
                                                st_i = listPushBack(st_i, cur_i)
                                                st_j = listPushBack(st_j, cur_j - 1)
                                                st_state = listPushBack(st_state, 1)
                                          }
                                          _ ==> {
                                                st_i[top] = cur_i
                                                st_j[top] = cur_j - 1
                                                st_state[top] = 1
                                          }
                                    }
                              }
                        }
                  }
            }
      }

      println("2. Total de passos da pilha pessimal: " + steps)
      println("3. Vetor ordenado pelo Slowsort: " + arr)

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
