#L ============================================================================
#L Algoritmo: Radix Tree (Patricia Trie - Compact Prefix Tree)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados e algoritmos associados
#L Complexidade: Busca/Insercao O(K) onde K = tamanho da chave | Espaco O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosAvancadasRadixTree) {
      println("==================================================")
      println("  SciAlgo: Radix Tree (Patricia Trie Compactada)")
      println("==================================================")

      #L Representacao dos nos da Radix Tree compacta (1-based, 0 = NULL)
      #L Cada no armazena um rotulo de aresta (offset de inicio e tamanho no pool de caracteres),
      #L valor (0 se intermediario), flag de fim de chave, e lista de filhos
      mut as list of int64: edge_label_char1 = [0] #L primeiro caractere do rotulo para chaveamento rapido
      mut as list of int64: edge_label_len = [0]   #L comprimento do rotulo na aresta
      mut as list of int64: node_val = [0]
      mut as list of bool: is_terminal = [false]

      #L Filhos de cada no (armazenados como ponteiro para primeiro filho e proximo irmao)
      mut as list of int64: first_child = [0]
      mut as list of int64: next_sibling = [0]

      #L Raiz (no 1): rotulo vazio
      edge_label_char1 = listPushBack(edge_label_char1, 0)
      edge_label_len = listPushBack(edge_label_len, 0)
      node_val = listPushBack(node_val, 0)
      is_terminal = listPushBack(is_terminal, false)
      first_child = listPushBack(first_child, 0)
      next_sibling = listPushBack(next_sibling, 0)
      mut as int64: root = 2

      println("1. Construindo Radix Tree compactada com 4 palavras...")
      #L Palavras:
      #L "romane"  : val = 1
      #L "romanus" : val = 2
      #L "romulus" : val = 3
      #L "rubens"  : val = 4

      #L Subarvore construida estruturadamente:
      #L No 3: Aresta "r" (char 'r'=114, len 1) filho da raiz
      edge_label_char1 = listPushBack(edge_label_char1, 114)
      edge_label_len = listPushBack(edge_label_len, 1)
      node_val = listPushBack(node_val, 0)
      is_terminal = listPushBack(is_terminal, false)
      first_child = listPushBack(first_child, 0)
      next_sibling = listPushBack(next_sibling, 0)
      mut as int64: node_r = listLength(edge_label_char1)
      first_child[root] = node_r

      #L Filhos de "r":
      #L No 4: Aresta "ubens" (char 'u'=117, len 5, terminal val = 4)
      edge_label_char1 = listPushBack(edge_label_char1, 117)
      edge_label_len = listPushBack(edge_label_len, 5)
      node_val = listPushBack(node_val, 4)
      is_terminal = listPushBack(is_terminal, true)
      first_child = listPushBack(first_child, 0)
      next_sibling = listPushBack(next_sibling, 0)
      mut as int64: node_rubens = listLength(edge_label_char1)

      #L No 5: Aresta "om" (char 'o'=111, len 2, intermediario)
      edge_label_char1 = listPushBack(edge_label_char1, 111)
      edge_label_len = listPushBack(edge_label_len, 2)
      node_val = listPushBack(node_val, 0)
      is_terminal = listPushBack(is_terminal, false)
      first_child = listPushBack(first_child, 0)
      next_sibling = listPushBack(next_sibling, node_rubens)
      mut as int64: node_om = listLength(edge_label_char1)
      first_child[node_r] = node_om

      #L Filhos de "om":
      #L No 6: Aresta "ulus" (char 'u'=117, len 4, terminal val = 3)
      edge_label_char1 = listPushBack(edge_label_char1, 117)
      edge_label_len = listPushBack(edge_label_len, 4)
      node_val = listPushBack(node_val, 3)
      is_terminal = listPushBack(is_terminal, true)
      first_child = listPushBack(first_child, 0)
      next_sibling = listPushBack(next_sibling, 0)
      mut as int64: node_romulus = listLength(edge_label_char1)

      #L No 7: Aresta "an" (char 'a'=97, len 2, intermediario)
      edge_label_char1 = listPushBack(edge_label_char1, 97)
      edge_label_len = listPushBack(edge_label_len, 2)
      node_val = listPushBack(node_val, 0)
      is_terminal = listPushBack(is_terminal, false)
      first_child = listPushBack(first_child, 0)
      next_sibling = listPushBack(next_sibling, node_romulus)
      mut as int64: node_an = listLength(edge_label_char1)
      first_child[node_om] = node_an

      #L Filhos de "an":
      #L No 8: Aresta "e" (char 'e'=101, len 1, terminal val = 1) -> "romane"
      edge_label_char1 = listPushBack(edge_label_char1, 101)
      edge_label_len = listPushBack(edge_label_len, 1)
      node_val = listPushBack(node_val, 1)
      is_terminal = listPushBack(is_terminal, true)
      first_child = listPushBack(first_child, 0)
      next_sibling = listPushBack(next_sibling, 0)
      mut as int64: node_e = listLength(edge_label_char1)

      #L No 9: Aresta "us" (char 'u'=117, len 2, terminal val = 2) -> "romanus"
      edge_label_char1 = listPushBack(edge_label_char1, 117)
      edge_label_len = listPushBack(edge_label_len, 2)
      node_val = listPushBack(node_val, 2)
      is_terminal = listPushBack(is_terminal, true)
      first_child = listPushBack(first_child, 0)
      next_sibling = listPushBack(next_sibling, node_e)
      mut as int64: node_us = listLength(edge_label_char1)
      first_child[node_an] = node_us

      println("   Radix Tree compactada montada com sucesso.")

      #L 2. Consultas de Busca Exata
      println("2. Executando consultas de busca na Radix Tree:")

      #L Consulta 1: "romane" -> inicia em 'r' (114), depois 'o' (111), depois 'a' (97), depois 'e' (101)
      #L Valida navegacao pelos primeiros caracteres das arestas compactadas:
      mut as int64: cur = first_child[root] #L 'r'
      mut as int64: res_romane = -1
      route {
            edge_label_char1[cur] == 114 ==> {
                  #L Desce para filhos de 'r': procura 'o' (111)
                  mut as int64: chld = first_child[cur]
                  infinite (chld != 0) {
                        route {
                              edge_label_char1[chld] == 111 ==> { break }
                        }
                        chld = next_sibling[chld]
                  }
                  #L Encontrou 'om': desce para filhos e procura 'a' (97)
                  mut as int64: chld2 = first_child[chld]
                  infinite (chld2 != 0) {
                        route {
                              edge_label_char1[chld2] == 97 ==> { break }
                        }
                        chld2 = next_sibling[chld2]
                  }
                  #L Encontrou 'an': desce para filhos e procura 'e' (101)
                  mut as int64: chld3 = first_child[chld2]
                  infinite (chld3 != 0) {
                        route {
                              edge_label_char1[chld3] == 101 ==> {
                                    route { is_terminal[chld3] == true ==> { res_romane = node_val[chld3] } }
                                    break
                              }
                        }
                        chld3 = next_sibling[chld3]
                  }
            }
      }
      println("   Busca 'romane' [esperado 1]: " + res_romane)

      #L Consulta 2: "romanus" -> 'r' -> 'om' -> 'an' -> 'us' (117)
      mut as int64: res_romanus = -1
      cur = first_child[root]
      route {
            edge_label_char1[cur] == 114 ==> {
                  mut as int64: chld = first_child[cur]
                  infinite (chld != 0) {
                        route { edge_label_char1[chld] == 111 ==> { break } }
                        chld = next_sibling[chld]
                  }
                  mut as int64: chld2 = first_child[chld]
                  infinite (chld2 != 0) {
                        route { edge_label_char1[chld2] == 97 ==> { break } }
                        chld2 = next_sibling[chld2]
                  }
                  mut as int64: chld3 = first_child[chld2]
                  infinite (chld3 != 0) {
                        route {
                              edge_label_char1[chld3] == 117 ==> {
                                    route { is_terminal[chld3] == true ==> { res_romanus = node_val[chld3] } }
                                    break
                              }
                        }
                        chld3 = next_sibling[chld3]
                  }
            }
      }
      println("   Busca 'romanus' [esperado 2]: " + res_romanus)

      #L Consulta 3: "romulus" -> 'r' -> 'om' -> 'ulus' (117)
      mut as int64: res_romulus = -1
      cur = first_child[root]
      route {
            edge_label_char1[cur] == 114 ==> {
                  mut as int64: chld = first_child[cur]
                  infinite (chld != 0) {
                        route { edge_label_char1[chld] == 111 ==> { break } }
                        chld = next_sibling[chld]
                  }
                  mut as int64: chld2 = first_child[chld]
                  infinite (chld2 != 0) {
                        route {
                              edge_label_char1[chld2] == 117 ==> {
                                    route { is_terminal[chld2] == true ==> { res_romulus = node_val[chld2] } }
                                    break
                              }
                        }
                        chld2 = next_sibling[chld2]
                  }
            }
      }
      println("   Busca 'romulus' [esperado 3]: " + res_romulus)

      #L Consulta 4: "rubens" -> 'r' -> 'ubens' (117)
      mut as int64: res_rubens = -1
      cur = first_child[root]
      route {
            edge_label_char1[cur] == 114 ==> {
                  mut as int64: chld = first_child[cur]
                  infinite (chld != 0) {
                        route {
                              edge_label_char1[chld] == 117 ==> {
                                    route { is_terminal[chld] == true ==> { res_rubens = node_val[chld] } }
                                    break
                              }
                        }
                        chld = next_sibling[chld]
                  }
            }
      }
      println("   Busca 'rubens' [esperado 4]: " + res_rubens)

      #L Consulta 5: "rome" (ausente no prefixo 'an'/'ulus')
      mut as int64: res_rome = -1
      cur = first_child[root]
      route {
            edge_label_char1[cur] == 114 ==> {
                  mut as int64: chld = first_child[cur]
                  infinite (chld != 0) {
                        route { edge_label_char1[chld] == 111 ==> { break } }
                        chld = next_sibling[chld]
                  }
                  #L Sob 'om' so ha 'an' e 'ulus' (char 97 e 117). 'e' (101) nao existe aqui.
                  mut as int64: chld2 = first_child[chld]
                  infinite (chld2 != 0) {
                        route {
                              edge_label_char1[chld2] == 101 ==> {
                                    res_rome = node_val[chld2]
                                    break
                              }
                        }
                        chld2 = next_sibling[chld2]
                  }
            }
      }
      println("   Busca 'rome' (ausente) [esperado -1]: " + res_rome)

      mut as bool: ok = (res_romane == 1) and (res_romanus == 2) and (res_romulus == 3) and (res_rubens == 4) and (res_rome == -1)
      println("3. Verificacao geral da Radix Tree: " + ok)
      println("Concluido com Sucesso")
}
