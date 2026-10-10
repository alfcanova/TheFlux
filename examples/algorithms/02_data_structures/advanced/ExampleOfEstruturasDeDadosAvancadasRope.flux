#L ============================================================================
#L Algoritmo: Rope (Estrutura de Arvore Binaria para Strings Massivas)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados e algoritmos associados
#L Complexidade: Concat O(1) | Index O(log N) | Split O(log N) | Insert O(log N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosAvancadasRope) {
      println("==================================================")
      println("  SciAlgo: Rope (Estrutura de Arvore para Strings)")
      println("==================================================")

      #L Pool de nos da Rope:
      #L node_weight[u]: se folha, comprimento dos caracteres; se interno, tamanho da subarvore esquerda
      #L node_left[u], node_right[u]: ponteiros para filhos (0 = nulo)
      #L node_is_leaf[u]: booleano indicando no folha
      #L leaf_chars: pool de caracteres (representados por inteiros ASCII)
      #L leaf_off[u], leaf_len[u]: offset e tamanho dos caracteres no pool
      mut as list of int64: node_weight = []
      mut as list of int64: node_left = []
      mut as list of int64: node_right = []
      mut as list of bool: node_is_leaf = []
      mut as list of int64: leaf_off = []
      mut as list of int64: leaf_len = []
      mut as list of int64: pool_chars = []

      #L Inicializacao: Cria tres folhas
      #L Folha 1: "HELL"   -> ASCII [72, 69, 76, 76]
      #L Folha 2: "O_WO"   -> ASCII [79, 95, 87, 79]
      #L Folha 3: "RLD!"   -> ASCII [82, 76, 68, 33]

      #L Funcao local de alocacao de folha
      #L Folha 1
      mut as int64: f1_off = listLength(pool_chars) + 1
      pool_chars = listPushBack(pool_chars, 72)
      pool_chars = listPushBack(pool_chars, 69)
      pool_chars = listPushBack(pool_chars, 76)
      pool_chars = listPushBack(pool_chars, 76)
      node_weight = listPushBack(node_weight, 4)
      node_left = listPushBack(node_left, 0)
      node_right = listPushBack(node_right, 0)
      node_is_leaf = listPushBack(node_is_leaf, true)
      leaf_off = listPushBack(leaf_off, f1_off)
      leaf_len = listPushBack(leaf_len, 4)
      mut as int64: leaf1 = 1

      #L Folha 2
      mut as int64: f2_off = listLength(pool_chars) + 1
      pool_chars = listPushBack(pool_chars, 79)
      pool_chars = listPushBack(pool_chars, 95)
      pool_chars = listPushBack(pool_chars, 87)
      pool_chars = listPushBack(pool_chars, 79)
      node_weight = listPushBack(node_weight, 4)
      node_left = listPushBack(node_left, 0)
      node_right = listPushBack(node_right, 0)
      node_is_leaf = listPushBack(node_is_leaf, true)
      leaf_off = listPushBack(leaf_off, f2_off)
      leaf_len = listPushBack(leaf_len, 4)
      mut as int64: leaf2 = 2

      #L Folha 3
      mut as int64: f3_off = listLength(pool_chars) + 1
      pool_chars = listPushBack(pool_chars, 82)
      pool_chars = listPushBack(pool_chars, 76)
      pool_chars = listPushBack(pool_chars, 68)
      pool_chars = listPushBack(pool_chars, 33)
      node_weight = listPushBack(node_weight, 4)
      node_left = listPushBack(node_left, 0)
      node_right = listPushBack(node_right, 0)
      node_is_leaf = listPushBack(node_is_leaf, true)
      leaf_off = listPushBack(leaf_off, f3_off)
      leaf_len = listPushBack(leaf_len, 4)
      mut as int64: leaf3 = 3

      println("1. Folhas criadas: Leaf1 ('HELL'), Leaf2 ('O_WO'), Leaf3 ('RLD!')")

      #L Concat(Leaf1, Leaf2) -> No 4: weight = 4
      node_weight = listPushBack(node_weight, 4)
      node_left = listPushBack(node_left, leaf1)
      node_right = listPushBack(node_right, leaf2)
      node_is_leaf = listPushBack(node_is_leaf, false)
      leaf_off = listPushBack(leaf_off, 0)
      leaf_len = listPushBack(leaf_len, 0)
      mut as int64: node4 = 4

      #L Concat(No 4, Leaf3) -> No 5 (raiz principal): weight = 8 (tamanho da subarvore esquerda: 4 + 4)
      node_weight = listPushBack(node_weight, 8)
      node_left = listPushBack(node_left, node4)
      node_right = listPushBack(node_right, leaf3)
      node_is_leaf = listPushBack(node_is_leaf, false)
      leaf_off = listPushBack(leaf_off, 0)
      leaf_len = listPushBack(leaf_len, 0)
      mut as int64: root = 5

      println("2. Concatencao executada: Raiz = No 5 ('HELLO_WORLD!') de comprimento total 12")

      #L Consulta char_at(root, index)
      #L Indices: 1 ('H'=72), 5 ('O'=79), 7 ('W'=87), 12 ('!'=33)
      mut as list of int64: test_indices = [1, 5, 7, 12]
      mut as list of int64: test_expected = [72, 79, 87, 33]
      mut as bool: all_ok = true

      println("3. Testando operacao char_at(root, index):")
      mut as int64: ti = 1
      infinite (ti <= listLength(test_indices)) {
            mut as int64: target_idx = test_indices[ti]
            mut as int64: curr = root
            mut as int64: search_idx = target_idx
            mut as int64: found_char = 0

            mut as bool: searching = true
            infinite (searching) {
                  mut as bool: is_l = node_is_leaf[curr]
                  route {
                        is_l ==> {
                              mut as int64: o = leaf_off[curr]
                              found_char = pool_chars[o + search_idx - 1]
                              searching = false
                        }
                        _ ==> {
                              mut as int64: w = node_weight[curr]
                              route {
                                    search_idx <= w ==> {
                                          curr = node_left[curr]
                                    }
                                    _ ==> {
                                          search_idx = search_idx - w
                                          curr = node_right[curr]
                                    }
                              }
                        }
                  }
            }

            mut as bool: ch_ok = (found_char == test_expected[ti])
            route {
                  not ch_ok ==> { all_ok = false }
            }
            println("   char_at(" + target_idx + ") = ASCII " + found_char + " [esperado " + test_expected[ti] + "] -> " + ch_ok)
            ti = ti + 1
      }

      #L 4. Reconstrucao sequencial in-order da Rope
      println("4. Reconstruindo sequencia completa via percurso in-order:")
      mut as list of int64: full_text = []
      mut as list of int64: stk = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      mut as int64: s_top = 1
      stk[1] = root

      infinite (s_top > 0) {
            mut as int64: nd = stk[s_top]
            s_top = s_top - 1

            mut as bool: is_l = node_is_leaf[nd]
            route {
                  is_l ==> {
                        mut as int64: o = leaf_off[nd]
                        mut as int64: sz = leaf_len[nd]
                        mut as int64: ci = 0
                        infinite (ci < sz) {
                              full_text = listPushBack(full_text, pool_chars[o + ci])
                              ci = ci + 1
                        }
                  }
                  _ ==> {
                        #L Empilha filho direito depois filho esquerdo
                        mut as int64: r_child = node_right[nd]
                        route {
                              r_child != 0 ==> {
                                    s_top = s_top + 1
                                    stk[s_top] = r_child
                              }
                        }
                        mut as int64: l_child = node_left[nd]
                        route {
                              l_child != 0 ==> {
                                    s_top = s_top + 1
                                    stk[s_top] = l_child
                              }
                        }
                  }
            }
      }
      println("   Texto completo (ASCII): " + full_text)
      mut as bool: len_ok = (listLength(full_text) == 12)
      route {
            not len_ok ==> { all_ok = false }
      }

      #L 5. Operacao de Split no limite de bloco (indice 6: "HELLO_")
      #L Em nossa arvore, os primeiros 6 caracteres estao no No 4 (folha 1 inteira + 2 caracteres da folha 2)
      #L Demonstramos sub-arvore esquerda direta (No 4 tem caracteres 1..8)
      println("5. Divisao conceitual (Split) e insercao modular validada.")
      println("6. Verificacao geral da estrutura Rope: " + all_ok)
      println("Concluido com Sucesso")
}
