#L ============================================================================
#L Algoritmo: Ternary Search Tree (TST de Bentley & Sedgewick 1997)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados e algoritmos associados
#L Complexidade: Busca/Insercao O(L + log N) tempo | O(N * L) espaco compacto
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosAvancadasTernarySearchTree) {
      println("==================================================")
      println("  SciAlgo: Ternary Search Tree (TST Bentley-Sedgewick)")
      println("==================================================")

      #L Representacao dos nos da TST (1-based, 0 = NULL)
      mut as list of int64: node_char = [0]
      mut as list of bool: is_end = [false]
      mut as list of int64: node_val = [0]
      mut as list of int64: child_left = [0]
      mut as list of int64: child_eq = [0]
      mut as list of int64: child_right = [0]
      mut as int64: root = 0

      #L Conjunto de strings a inserir (representadas em codigos ASCII):
      #L "cat"  : [99, 97, 116]       -> valor 10
      #L "cats" : [99, 97, 116, 115]  -> valor 20
      #L "car"  : [99, 97, 114]       -> valor 30
      #L "up"   : [117, 112]          -> valor 40
      #L "bug"  : [98, 117, 103]      -> valor 50

      println("1. Inserindo 5 palavras na TST...")

      #L Insercao manual estruturada de cada palavra
      #L 1. "cat" = [99, 97, 116] com val = 10
      mut as list of int64: w_cat = [99, 97, 116]
      mut as int64: len_cat = listLength(w_cat)
      mut as int64: pos = 1
      mut as int64: curr = 0

      #L Cria raiz inicial com primeiro char 'c' (99)
      node_char = listPushBack(node_char, 99)
      is_end = listPushBack(is_end, false)
      node_val = listPushBack(node_val, 0)
      child_left = listPushBack(child_left, 0)
      child_eq = listPushBack(child_eq, 0)
      child_right = listPushBack(child_right, 0)
      root = listLength(node_char)

      #L Insere 'a' (97) em child_eq do root
      node_char = listPushBack(node_char, 97)
      is_end = listPushBack(is_end, false)
      node_val = listPushBack(node_val, 0)
      child_left = listPushBack(child_left, 0)
      child_eq = listPushBack(child_eq, 0)
      child_right = listPushBack(child_right, 0)
      child_eq[root] = listLength(node_char)

      #L Insere 't' (116) em child_eq do 'a' e marca fim com val 10
      mut as int64: node_a = child_eq[root]
      node_char = listPushBack(node_char, 116)
      is_end = listPushBack(is_end, true)
      node_val = listPushBack(node_val, 10)
      child_left = listPushBack(child_left, 0)
      child_eq = listPushBack(child_eq, 0)
      child_right = listPushBack(child_right, 0)
      child_eq[node_a] = listLength(node_char)
      mut as int64: node_t = child_eq[node_a]

      println("   Palavra 'cat' inserida (val = 10).")

      #L 2. "cats" = adiciona 's' (115) no child_eq de 't' com val = 20
      node_char = listPushBack(node_char, 115)
      is_end = listPushBack(is_end, true)
      node_val = listPushBack(node_val, 20)
      child_left = listPushBack(child_left, 0)
      child_eq = listPushBack(child_eq, 0)
      child_right = listPushBack(child_right, 0)
      child_eq[node_t] = listLength(node_char)

      println("   Palavra 'cats' inserida (val = 20).")

      #L 3. "car": 'c', 'a', 'r' (114 < 116 -> vai para child_left de 't') com val = 30
      node_char = listPushBack(node_char, 114)
      is_end = listPushBack(is_end, true)
      node_val = listPushBack(node_val, 30)
      child_left = listPushBack(child_left, 0)
      child_eq = listPushBack(child_eq, 0)
      child_right = listPushBack(child_right, 0)
      child_left[node_t] = listLength(node_char)

      println("   Palavra 'car' inserida (val = 30).")

      #L 4. "up": 'u' (117 > 99 -> child_right da raiz 'c')
      node_char = listPushBack(node_char, 117)
      is_end = listPushBack(is_end, false)
      node_val = listPushBack(node_val, 0)
      child_left = listPushBack(child_left, 0)
      child_eq = listPushBack(child_eq, 0)
      child_right = listPushBack(child_right, 0)
      child_right[root] = listLength(node_char)
      mut as int64: node_u = child_right[root]

      #L 'p' (112) no child_eq de 'u' com val = 40
      node_char = listPushBack(node_char, 112)
      is_end = listPushBack(is_end, true)
      node_val = listPushBack(node_val, 40)
      child_left = listPushBack(child_left, 0)
      child_eq = listPushBack(child_eq, 0)
      child_right = listPushBack(child_right, 0)
      child_eq[node_u] = listLength(node_char)

      println("   Palavra 'up' inserida (val = 40).")

      #L 5. "bug": 'b' (98 < 99 -> child_left da raiz 'c')
      node_char = listPushBack(node_char, 98)
      is_end = listPushBack(is_end, false)
      node_val = listPushBack(node_val, 0)
      child_left = listPushBack(child_left, 0)
      child_eq = listPushBack(child_eq, 0)
      child_right = listPushBack(child_right, 0)
      child_left[root] = listLength(node_char)
      mut as int64: node_b = child_left[root]

      #L 'u' (117) no child_eq de 'b'
      node_char = listPushBack(node_char, 117)
      is_end = listPushBack(is_end, false)
      node_val = listPushBack(node_val, 0)
      child_left = listPushBack(child_left, 0)
      child_eq = listPushBack(child_eq, 0)
      child_right = listPushBack(child_right, 0)
      child_eq[node_b] = listLength(node_char)
      mut as int64: node_bu = child_eq[node_b]

      #L 'g' (103) no child_eq de 'u' com val = 50
      node_char = listPushBack(node_char, 103)
      is_end = listPushBack(is_end, true)
      node_val = listPushBack(node_val, 50)
      child_left = listPushBack(child_left, 0)
      child_eq = listPushBack(child_eq, 0)
      child_right = listPushBack(child_right, 0)
      child_eq[node_bu] = listLength(node_char)

      println("   Palavra 'bug' inserida (val = 50).")

      #L 2. Consultas de Busca na TST
      println("2. Executando consultas de busca exata na TST:")

      #L Busca "cat" [99, 97, 116]
      mut as list of int64: q_cat = [99, 97, 116]
      mut as int64: q_len = 3
      curr = root
      pos = 1
      mut as int64: res_cat = -1
      infinite (curr != 0) {
            mut as int64: ch = q_cat[pos]
            mut as int64: nch = node_char[curr]

            route {
                  ch < nch ==> { curr = child_left[curr] }
                  ch > nch ==> { curr = child_right[curr] }
                  _ ==> {
                        route {
                              pos == q_len ==> {
                                    route {
                                          is_end[curr] == true ==> { res_cat = node_val[curr] }
                                    }
                                    break
                              }
                              _ ==> {
                                    pos = pos + 1
                                    curr = child_eq[curr]
                              }
                        }
                  }
            }
      }
      println("   Busca 'cat' [esperado 10]: " + res_cat)

      #L Busca "cats" [99, 97, 116, 115]
      mut as list of int64: q_cats = [99, 97, 116, 115]
      q_len = 4
      curr = root
      pos = 1
      mut as int64: res_cats = -1
      infinite (curr != 0) {
            mut as int64: ch = q_cats[pos]
            mut as int64: nch = node_char[curr]

            route {
                  ch < nch ==> { curr = child_left[curr] }
                  ch > nch ==> { curr = child_right[curr] }
                  _ ==> {
                        route {
                              pos == q_len ==> {
                                    route {
                                          is_end[curr] == true ==> { res_cats = node_val[curr] }
                                    }
                                    break
                              }
                              _ ==> {
                                    pos = pos + 1
                                    curr = child_eq[curr]
                              }
                        }
                  }
            }
      }
      println("   Busca 'cats' [esperado 20]: " + res_cats)

      #L Busca "car" [99, 97, 114]
      mut as list of int64: q_car = [99, 97, 114]
      q_len = 3
      curr = root
      pos = 1
      mut as int64: res_car = -1
      infinite (curr != 0) {
            mut as int64: ch = q_car[pos]
            mut as int64: nch = node_char[curr]

            route {
                  ch < nch ==> { curr = child_left[curr] }
                  ch > nch ==> { curr = child_right[curr] }
                  _ ==> {
                        route {
                              pos == q_len ==> {
                                    route {
                                          is_end[curr] == true ==> { res_car = node_val[curr] }
                                    }
                                    break
                              }
                              _ ==> {
                                    pos = pos + 1
                                    curr = child_eq[curr]
                              }
                        }
                  }
            }
      }
      println("   Busca 'car' [esperado 30]: " + res_car)

      #L Busca "cut" [99, 117, 116] (ausente -> esperado -1)
      mut as list of int64: q_cut = [99, 117, 116]
      q_len = 3
      curr = root
      pos = 1
      mut as int64: res_cut = -1
      infinite (curr != 0) {
            mut as int64: ch = q_cut[pos]
            mut as int64: nch = node_char[curr]

            route {
                  ch < nch ==> { curr = child_left[curr] }
                  ch > nch ==> { curr = child_right[curr] }
                  _ ==> {
                        route {
                              pos == q_len ==> {
                                    route {
                                          is_end[curr] == true ==> { res_cut = node_val[curr] }
                                    }
                                    break
                              }
                              _ ==> {
                                    pos = pos + 1
                                    curr = child_eq[curr]
                              }
                        }
                  }
            }
      }
      println("   Busca 'cut' (ausente) [esperado -1]: " + res_cut)

      #L Busca "ca" [99, 97] (prefixo mas nao palavra completa -> esperado -1)
      mut as list of int64: q_ca = [99, 97]
      q_len = 2
      curr = root
      pos = 1
      mut as int64: res_ca = -1
      infinite (curr != 0) {
            mut as int64: ch = q_ca[pos]
            mut as int64: nch = node_char[curr]

            route {
                  ch < nch ==> { curr = child_left[curr] }
                  ch > nch ==> { curr = child_right[curr] }
                  _ ==> {
                        route {
                              pos == q_len ==> {
                                    route {
                                          is_end[curr] == true ==> { res_ca = node_val[curr] }
                                    }
                                    break
                              }
                              _ ==> {
                                    pos = pos + 1
                                    curr = child_eq[curr]
                              }
                        }
                  }
            }
      }
      println("   Busca prefixo 'ca' [esperado -1]: " + res_ca)

      mut as bool: ok = (res_cat == 10) and (res_cats == 20) and (res_car == 30) and (res_cut == -1) and (res_ca == -1)
      println("3. Verificacao geral da Ternary Search Tree: " + ok)
      println("Concluido com Sucesso")
}
