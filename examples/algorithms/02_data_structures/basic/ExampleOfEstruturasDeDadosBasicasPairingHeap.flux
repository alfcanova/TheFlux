#L ============================================================================
#L Algoritmo: Pairing Heap (Heap por Emparelhamento Multi-Vias)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados (Adicoes Prioritarias)
#L Complexidade: Insercao/Meld O(1) | Remocao O(log N) amortizado
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosBasicasPairingHeap) {
      println("==================================================")
      println("  SciAlgo: Pairing Heap (Heap por Emparelhamento)")
      println("==================================================")

      #L Representacao Left-Child / Right-Sibling em vetores paralelos
      #L Indice 0 = NULL / Vazio
      mut as list of int64: node_key = [0]
      mut as list of int64: node_child = [0]
      mut as list of int64: node_sibling = [0]
      mut as int64: root = 0

      mut as list of int64: entradas = [34, 12, 45, 9, 23, 8, 56, 17]
      mut as int64: n_in = listLength(entradas)
      println("1. Inserindo elementos no Pairing Heap: " + entradas)

      #L Insercao O(1) de cada no via operacao Meld
      mut as int64: ins_i = 1
      infinite (ins_i <= n_in) {
            mut as int64: val = entradas[ins_i]
            #L Aloca novo no
            node_key = listPushBack(node_key, val)
            node_child = listPushBack(node_child, 0)
            node_sibling = listPushBack(node_sibling, 0)
            mut as int64: new_node = listLength(node_key) - 1

            #L Meld(root, new_node)
            route {
                  root == 0 ==> {
                        root = new_node
                  }
                  _ ==> {
                        route {
                              node_key[root] <= node_key[new_node] ==> {
                                    node_sibling[new_node] = node_child[root]
                                    node_child[root] = new_node
                              }
                              _ ==> {
                                    node_sibling[root] = node_child[new_node]
                                    node_child[new_node] = root
                                    root = new_node
                              }
                        }
                  }
            }
            ins_i = ins_i + 1
      }

      println("2. Raiz do heap (Menor elemento - Peek): " + node_key[root])

      #L Extracao sucessiva do minimo (Delete-Min) com fusao em dois passos (Two-Pass Pairing)
      mut as list of int64: extraidos = []

      infinite (root != 0) {
            mut as int64: min_val = node_key[root]
            extraidos = listPushBack(extraidos, min_val)

            #L Coleta a lista encadeada de filhos da raiz
            mut as list of int64: children = []
            mut as int64: curr_child = node_child[root]
            infinite (curr_child != 0) {
                  children = listPushBack(children, curr_child)
                  mut as int64: nxt = node_sibling[curr_child]
                  node_sibling[curr_child] = 0
                  curr_child = nxt
            }

            mut as int64: num_ch = listLength(children)
            route {
                  num_ch == 0 ==> {
                        root = 0
                  }
                  num_ch == 1 ==> {
                        root = children[1]
                  }
                  _ ==> {
                        #L Passo 1: Emparelha filhos adjacentes da esquerda para a direita (Pairing Pass)
                        mut as list of int64: pairs = []
                        mut as int64: pi = 1
                        infinite (pi <= num_ch) {
                              route {
                                    (pi + 1) <= num_ch ==> {
                                          mut as int64: u1 = children[pi]
                                          mut as int64: u2 = children[pi + 1]
                                          #L Meld(u1, u2)
                                          mut as int64: melded = 0
                                          route {
                                                node_key[u1] <= node_key[u2] ==> {
                                                      node_sibling[u2] = node_child[u1]
                                                      node_child[u1] = u2
                                                      melded = u1
                                                }
                                                _ ==> {
                                                      node_sibling[u1] = node_child[u2]
                                                      node_child[u2] = u1
                                                      melded = u2
                                                }
                                          }
                                          pairs = listPushBack(pairs, melded)
                                          pi = pi + 2
                                    }
                                    _ ==> {
                                          pairs = listPushBack(pairs, children[pi])
                                          pi = pi + 1
                                    }
                              }
                        }

                        #L Passo 2: Intercala os pares da direita para a esquerda (Accumulation Pass)
                        mut as int64: n_pairs = listLength(pairs)
                        mut as int64: acc = pairs[n_pairs]
                        mut as int64: pj = n_pairs - 1

                        infinite (pj >= 1) {
                              mut as int64: item = pairs[pj]
                              #L Meld(item, acc)
                              route {
                                    node_key[item] <= node_key[acc] ==> {
                                          node_sibling[acc] = node_child[item]
                                          node_child[item] = acc
                                          acc = item
                                    }
                                    _ ==> {
                                          node_sibling[item] = node_child[acc]
                                          node_child[acc] = item
                                    }
                              }
                              pj = pj - 1
                        }
                        root = acc
                  }
            }
      }

      println("3. Elementos extraidos sequencialmente do Pairing Heap: " + extraidos)

      #L Verificacao de integridade
      mut as bool: ordenado = true
      mut as int64: ci = 1
      mut as int64: m = listLength(extraidos)
      infinite (ci < m) {
            route {
                  extraidos[ci] > extraidos[ci + 1] ==> {
                        ordenado = false
                  }
                  _ ==> {
                  }
            }
            ci = ci + 1
      }
      println("4. Verificacao de ordenacao ascendente: " + ordenado)
      println("Concluido com Sucesso")
}

