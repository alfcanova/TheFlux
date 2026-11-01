#L ============================================================================
#L Algoritmo: Segment Tree (Arvore de Segmentos com Range Query e Point Update)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados e algoritmos associados
#L Complexidade: Construcao O(N) | Atualizacao O(log N) | Consulta O(log N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosAvancadasSegmentTree) {
      println("==================================================")
      println("  SciAlgo: Segment Tree (Soma por Faixa)")
      println("==================================================")

      mut as list of int64: arr = [1, 3, 5, 7, 9, 11]
      mut as int64: n = listLength(arr)
      println("1. Vetor de entrada (" + n + " elementos): " + arr)

      #L Alocacao da arvore de segmentos de tamanho 4 * n preenchida com zeros
      mut as int64: tree_sz = 4 * n
      mut as list of int64: tree = []
      mut as int64: zi = 1
      infinite (zi <= tree_sz) {
            tree = listPushBack(tree, 0)
            zi = zi + 1
      }

      #L Construcao iterativa/recursiva simulada por pilha para o build
      #L Pilha de frames de construcao: [node, l, r, state]
      #L state 0: inicializa e divide, state 1: combina filhos
      mut as list of int64: st_node = [1]
      mut as list of int64: st_l = [1]
      mut as list of int64: st_r = [n]
      mut as list of int64: st_state = [0]

      infinite (listLength(st_node) > 0) {
            mut as int64: top_idx = listLength(st_node)
            mut as int64: u_node = st_node[top_idx]
            mut as int64: u_l = st_l[top_idx]
            mut as int64: u_r = st_r[top_idx]
            mut as int64: u_state = st_state[top_idx]

            route {
                  u_l == u_r ==> {
                        #L Folha
                        tree[u_node] = arr[u_l]
                        st_node = listTake(st_node, top_idx - 1)
                        st_l = listTake(st_l, top_idx - 1)
                        st_r = listTake(st_r, top_idx - 1)
                        st_state = listTake(st_state, top_idx - 1)
                  }
                  u_state == 0 ==> {
                        #L Marca como visitado e empilha filhos
                        st_state[top_idx] = 1
                        mut as int64: mid = (u_l + u_r) /i 2
                        mut as int64: left_ch = 2 * u_node
                        mut as int64: right_ch = (2 * u_node) + 1

                        #L Empilha filho direito
                        st_node = listPushBack(st_node, right_ch)
                        st_l = listPushBack(st_l, mid + 1)
                        st_r = listPushBack(st_r, u_r)
                        st_state = listPushBack(st_state, 0)

                        #L Empilha filho esquerdo
                        st_node = listPushBack(st_node, left_ch)
                        st_l = listPushBack(st_l, u_l)
                        st_r = listPushBack(st_r, mid)
                        st_state = listPushBack(st_state, 0)
                  }
                  _ ==> {
                        #L Combina resultados dos filhos
                        mut as int64: left_ch = 2 * u_node
                        mut as int64: right_ch = (2 * u_node) + 1
                        tree[u_node] = tree[left_ch] + tree[right_ch]

                        st_node = listTake(st_node, top_idx - 1)
                        st_l = listTake(st_l, top_idx - 1)
                        st_r = listTake(st_r, top_idx - 1)
                        st_state = listTake(st_state, top_idx - 1)
                  }
            }
      }

      println("2. Segment Tree construida com sucesso (Raiz: " + tree[1] + ")")

      #L Consultas de soma por faixa: Range Sum Query [QL..QR]
      #L Pilha de consulta: [node, l, r]
      println("3. Executando consultas de soma por faixa:")

      #L Consulta 1: soma em [1..6] -> total = 1+3+5+7+9+11 = 36
      mut as list of int64: q_node = [1]
      mut as list of int64: q_l = [1]
      mut as list of int64: q_r = [n]
      mut as int64: sum_1_6 = 0
      mut as int64: ql_1 = 1
      mut as int64: qr_1 = 6

      infinite (listLength(q_node) > 0) {
            mut as int64: cur_sz = listLength(q_node)
            mut as int64: cn = q_node[cur_sz]
            mut as int64: cl = q_l[cur_sz]
            mut as int64: cr = q_r[cur_sz]
            q_node = listTake(q_node, cur_sz - 1)
            q_l = listTake(q_l, cur_sz - 1)
            q_r = listTake(q_r, cur_sz - 1)

            route {
                  ql_1 <= cl and cr <= qr_1 ==> {
                        sum_1_6 = sum_1_6 + tree[cn]
                  }
                  cl > qr_1 or cr < ql_1 ==> {
                  }
                  _ ==> {
                        mut as int64: mid = (cl + cr) /i 2
                        #L Empilha esquerda e direita
                        q_node = listPushBack(q_node, 2 * cn)
                        q_l = listPushBack(q_l, cl)
                        q_r = listPushBack(q_r, mid)

                        q_node = listPushBack(q_node, (2 * cn) + 1)
                        q_l = listPushBack(q_l, mid + 1)
                        q_r = listPushBack(q_r, cr)
                  }
            }
      }
      println("   Soma subfaixa [1..6] (esperado 36): " + sum_1_6)

      #L Consulta 2: soma em [2..5] -> arr[2..5] = [3, 5, 7, 9] -> soma = 24
      q_node = [1]
      q_l = [1]
      q_r = [n]
      mut as int64: sum_2_5 = 0
      mut as int64: ql_2 = 2
      mut as int64: qr_2 = 5

      infinite (listLength(q_node) > 0) {
            mut as int64: cur_sz = listLength(q_node)
            mut as int64: cn = q_node[cur_sz]
            mut as int64: cl = q_l[cur_sz]
            mut as int64: cr = q_r[cur_sz]
            q_node = listTake(q_node, cur_sz - 1)
            q_l = listTake(q_l, cur_sz - 1)
            q_r = listTake(q_r, cur_sz - 1)

            route {
                  ql_2 <= cl and cr <= qr_2 ==> {
                        sum_2_5 = sum_2_5 + tree[cn]
                  }
                  cl > qr_2 or cr < ql_2 ==> {
                  }
                  _ ==> {
                        mut as int64: mid = (cl + cr) /i 2
                        q_node = listPushBack(q_node, 2 * cn)
                        q_l = listPushBack(q_l, cl)
                        q_r = listPushBack(q_r, mid)

                        q_node = listPushBack(q_node, (2 * cn) + 1)
                        q_l = listPushBack(q_l, mid + 1)
                        q_r = listPushBack(q_r, cr)
                  }
            }
      }
      println("   Soma subfaixa [2..5] (esperado 24): " + sum_2_5)

      #L Atualizacao pontual (Point Update): pos 3 (valor antigo 5) -> novo valor 10 (+5)
      println("4. Atualizando posicao 3 para valor 10 (antigo 5)...")
      mut as int64: target_pos = 3
      mut as int64: new_val = 10
      mut as int64: cur_n = 1
      mut as int64: cur_l = 1
      mut as int64: cur_r = n

      #L Caminho descendente guardando nos a atualizar
      mut as list of int64: path_nodes = []
      infinite (cur_l <= cur_r) {
            path_nodes = listPushBack(path_nodes, cur_n)
            route {
                  cur_l == cur_r ==> {
                        tree[cur_n] = new_val
                        break
                  }
                  _ ==> {
                        mut as int64: mid = (cur_l + cur_r) /i 2
                        route {
                              target_pos <= mid ==> {
                                    cur_n = 2 * cur_n
                                    cur_r = mid
                              }
                              _ ==> {
                                    cur_n = (2 * cur_n) + 1
                                    cur_l = mid + 1
                              }
                        }
                  }
            }
      }

      #L Propaga subindo pelos nos do caminho
      mut as int64: pi = listLength(path_nodes) - 1
      infinite (pi >= 1) {
            mut as int64: p_n = path_nodes[pi]
            tree[p_n] = tree[2 * p_n] + tree[(2 * p_n) + 1]
            pi = pi - 1
      }

      #L Reconsulta [2..5] -> agora deve ser 3 + 10 + 7 + 9 = 29
      q_node = [1]
      q_l = [1]
      q_r = [n]
      mut as int64: new_sum_2_5 = 0

      infinite (listLength(q_node) > 0) {
            mut as int64: cur_sz = listLength(q_node)
            mut as int64: cn = q_node[cur_sz]
            mut as int64: cl = q_l[cur_sz]
            mut as int64: cr = q_r[cur_sz]
            q_node = listTake(q_node, cur_sz - 1)
            q_l = listTake(q_l, cur_sz - 1)
            q_r = listTake(q_r, cur_sz - 1)

            route {
                  ql_2 <= cl and cr <= qr_2 ==> {
                        new_sum_2_5 = new_sum_2_5 + tree[cn]
                  }
                  cl > qr_2 or cr < ql_2 ==> {
                  }
                  _ ==> {
                        mut as int64: mid = (cl + cr) /i 2
                        q_node = listPushBack(q_node, 2 * cn)
                        q_l = listPushBack(q_l, cl)
                        q_r = listPushBack(q_r, mid)

                        q_node = listPushBack(q_node, (2 * cn) + 1)
                        q_l = listPushBack(q_l, mid + 1)
                        q_r = listPushBack(q_r, cr)
                  }
            }
      }
      println("5. Nova soma subfaixa [2..5] (esperado 29): " + new_sum_2_5)

      mut as bool: ok = (sum_1_6 == 36) and (sum_2_5 == 24) and (new_sum_2_5 == 29)
      println("6. Verificacao da Segment Tree: " + ok)
      println("Concluido com Sucesso")
}
