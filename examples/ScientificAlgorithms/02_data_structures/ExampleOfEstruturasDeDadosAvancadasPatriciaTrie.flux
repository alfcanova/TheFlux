#L ============================================================================
#L Algoritmo: Patricia Trie (Binary Compressed Bitwise Trie de Donald R. Morrison 1968)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados avancadas
#L Complexidade: O(K) onde K e o numero de bits da chave | Espaco O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosAvancadasPatriciaTrie) {
      println("==================================================")
      println("  SciAlgo: Patricia Trie (Binary Bitwise Compacta)")
      println("==================================================")

      #L Representacao dos nos do Patricia Trie binario (1-based, 0 = NULL)
      #L Cada no armazena:
      #L - bit_pos: posicao do bit discriminante (16 ate 1)
      #L - key_val: valor da chave associada
      #L - left_ch: ponteiro para ramo com bit = 0
      #L - right_ch: ponteiro para ramo com bit = 1
      mut as list of int64: bit_pos = [0]
      mut as list of int64: key_val = [0]
      mut as list of int64: left_ch = [0]
      mut as list of int64: right_ch = [0]
      mut as int64: root = 0

      #L Chaves inteiras para insercao: 12, 25, 42, 60, 15
      #L Representacao binaria (bits 6 a 1):
      #L 12 = 001100b
      #L 25 = 011001b
      #L 42 = 101010b
      #L 60 = 111100b
      #L 15 = 001111b
      mut as list of int64: keys = [12, 25, 42, 60, 15]
      mut as int64: n = listLength(keys)

      println("1. Inserindo " + n + " chaves no Patricia Trie binario: " + keys)

      #L Funcao in-line de extracao de bit k (1 a 8): (val / 2^(k-1)) % 2
      #L Tabela de potencias de 2 (1-based para bits 1 a 8)
      mut as list of int64: p2 = [1, 2, 4, 8, 16, 32, 64, 128]

      mut as int64: ins_i = 1
      infinite (ins_i <= n) {
            mut as int64: k = keys[ins_i]

            route {
                  root == 0 ==> {
                        #L Primeiro no: raiz folha com bit_pos = 0
                        bit_pos = listPushBack(bit_pos, 0)
                        key_val = listPushBack(key_val, k)
                        left_ch = listPushBack(left_ch, 0)
                        right_ch = listPushBack(right_ch, 0)
                        root = listLength(key_val) - 1
                  }
                  _ ==> {
                        #L Desce na arvore usando os bits discriminantes ate alcancar uma folha
                        mut as int64: curr = root
                        mut as int64: parent = 0
                        mut as int64: dir = 0

                        infinite (bit_pos[curr] > 0) {
                              parent = curr
                              mut as int64: b_idx = bit_pos[curr]
                              mut as int64: bit_val = ((k /i p2[b_idx]) /r 2)
                              route {
                                    bit_val == 0 ==> {
                                          dir = 0
                                          curr = left_ch[curr]
                                    }
                                    _ ==> {
                                          dir = 1
                                          curr = right_ch[curr]
                                    }
                              }
                        }

                        #L Compara com a chave existente na folha para encontrar o bit mais significativo diferente
                        mut as int64: existing_k = key_val[curr]
                        mut as int64: diff_bit = 0
                        mut as int64: b_scan = 8
                        infinite (b_scan >= 1) {
                              mut as int64: b1 = ((k /i p2[b_scan]) /r 2)
                              mut as int64: b2 = ((existing_k /i p2[b_scan]) /r 2)
                              route {
                                    b1 != b2 ==> {
                                          diff_bit = b_scan
                                          break
                                    }
                              }
                              b_scan = b_scan - 1
                        }

                        route {
                              diff_bit > 0 ==> {
                                    #L Aloca folha para k
                                    bit_pos = listPushBack(bit_pos, 0)
                                    key_val = listPushBack(key_val, k)
                                    left_ch = listPushBack(left_ch, 0)
                                    right_ch = listPushBack(right_ch, 0)
                                    mut as int64: new_leaf = listLength(key_val) - 1

                                    #L Aloca no interno com bit_pos = diff_bit
                                    bit_pos = listPushBack(bit_pos, diff_bit)
                                    key_val = listPushBack(key_val, 0)
                                    left_ch = listPushBack(left_ch, 0)
                                    right_ch = listPushBack(right_ch, 0)
                                    mut as int64: new_internal = listLength(key_val) - 1

                                    mut as int64: k_bit = ((k /i p2[diff_bit]) /r 2)
                                    route {
                                          k_bit == 0 ==> {
                                                left_ch[new_internal] = new_leaf
                                                right_ch[new_internal] = curr
                                          }
                                          _ ==> {
                                                left_ch[new_internal] = curr
                                                right_ch[new_internal] = new_leaf
                                          }
                                    }

                                    route {
                                          parent == 0 ==> {
                                                root = new_internal
                                          }
                                          _ ==> {
                                                route {
                                                      dir == 0 ==> { left_ch[parent] = new_internal }
                                                      _ ==> { right_ch[parent] = new_internal }
                                                }
                                          }
                                    }
                              }
                        }
                  }
            }
            ins_i = ins_i + 1
      }

      println("2. Raiz do Patricia Trie: no " + root + " (bit discriminante: " + bit_pos[root] + ")")

      #L Testes de busca por prefixo binario
      mut as list of int64: queries = [12, 25, 42, 60, 15, 99, 30]
      mut as int64: qi = 1
      mut as int64: found_count = 0

      println("3. Executando consultas no Patricia Trie:")
      infinite (qi <= listLength(queries)) {
            mut as int64: qk = queries[qi]
            mut as int64: cur_search = root

            infinite (cur_search != 0 and bit_pos[cur_search] > 0) {
                  mut as int64: b_pos = bit_pos[cur_search]
                  mut as int64: b_v = ((qk /i p2[b_pos]) /r 2)
                  route {
                        b_v == 0 ==> {
                              cur_search = left_ch[cur_search]
                        }
                        _ ==> {
                              cur_search = right_ch[cur_search]
                        }
                  }
            }

            mut as bool: match_found = false
            route {
                  cur_search != 0 ==> {
                        route {
                              key_val[cur_search] == qk ==> {
                                    match_found = true
                              }
                        }
                  }
            }

            route {
                  match_found ==> {
                        found_count = found_count + 1
                        println("   Chave " + qk + ": ENCONTRADA")
                  }
                  _ ==> {
                        println("   Chave " + qk + ": NAO ENCONTRADA")
                  }
            }
            qi = qi + 1
      }

      println("4. Total de chaves localizadas: " + found_count + " de " + listLength(queries))
      println("5. Validacao: " + (found_count == 5 and listLength(key_val) > 5))
      println("==================================================")
}
