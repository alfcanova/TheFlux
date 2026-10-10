#L ============================================================================
#L Algoritmo: Treap (Arvore de Busca Binaria Cartesiana com Prioridade Heap)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados e algoritmos associados
#L Complexidade: Insercao O(log N) | Busca O(log N) | Espaco O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosAvancadasTreap) {
      println("==================================================")
      println("  SciAlgo: Treap (BST + Max-Heap de Prioridade)")
      println("==================================================")

      #L Representacao em vetores paralelos (1-based, 0 = NULL)
      mut as list of int64: key = [0]
      mut as list of int64: priority = [0]
      mut as list of int64: left_ch = [0]
      mut as list of int64: right_ch = [0]
      mut as int64: root = 0

      #L Pares deterministicos (chave, prioridade)
      mut as list of int64: in_keys = [50, 30, 70, 20, 40, 60, 80]
      mut as list of int64: in_prio = [100, 75, 85, 40, 60, 50, 90]
      mut as int64: n = listLength(in_keys)

      println("1. Inserindo " + n + " pares (chave, prioridade) no Treap:")
      mut as int64: ii = 1
      infinite (ii <= n) {
            println("   Chave: " + in_keys[ii] + ", Prioridade: " + in_prio[ii])
            ii = ii + 1
      }

      #L Insercao iterativa no Treap: desce como BST guardando caminho, depois faz rotacoes subindo
      mut as int64: ins_i = 1
      infinite (ins_i <= n) {
            mut as int64: k = in_keys[ins_i]
            mut as int64: p = in_prio[ins_i]

            #L Cria novo no
            key = listPushBack(key, k)
            priority = listPushBack(priority, p)
            left_ch = listPushBack(left_ch, 0)
            right_ch = listPushBack(right_ch, 0)
            mut as int64: new_node = listLength(key) - 1

            route {
                  root == 0 ==> {
                        root = new_node
                  }
                  _ ==> {
                        #L Desce na BST guardando pais na pilha
                        mut as list of int64: path = []
                        mut as list of int64: directions = [] #L 1=left, 2=right
                        mut as int64: curr = root

                        infinite (curr != 0) {
                              path = listPushBack(path, curr)
                              route {
                                    k < key[curr] ==> {
                                          directions = listPushBack(directions, 1)
                                          route {
                                                left_ch[curr] == 0 ==> {
                                                      left_ch[curr] = new_node
                                                      break
                                                }
                                                _ ==> {
                                                      curr = left_ch[curr]
                                                }
                                          }
                                    }
                                    _ ==> {
                                          directions = listPushBack(directions, 2)
                                          route {
                                                right_ch[curr] == 0 ==> {
                                                      right_ch[curr] = new_node
                                                      break
                                                }
                                                _ ==> {
                                                      curr = right_ch[curr]
                                                }
                                          }
                                    }
                              }
                        }

                        #L Sobe restaurando a propriedade de Heap via rotacoes
                        mut as int64: child_node = new_node
                        mut as int64: p_idx = listLength(path)

                        infinite (p_idx >= 1) {
                              mut as int64: parent_node = path[p_idx]
                              route {
                                    priority[child_node] > priority[parent_node] ==> {
                                          #L Verifica se child_node eh filho esquerdo ou direito de parent_node
                                          route {
                                                left_ch[parent_node] == child_node ==> {
                                                      #L Rotacao a Direita em parent_node
                                                      #L parent_node.left = child_node.right
                                                      #L child_node.right = parent_node
                                                      left_ch[parent_node] = right_ch[child_node]
                                                      right_ch[child_node] = parent_node
                                                }
                                                _ ==> {
                                                      #L Rotacao a Esquerda em parent_node
                                                      #L parent_node.right = child_node.left
                                                      #L child_node.left = parent_node
                                                      right_ch[parent_node] = left_ch[child_node]
                                                      left_ch[child_node] = parent_node
                                                }
                                          }

                                          #L Ajusta ponteiro do avo (se existir) para apontar para child_node
                                          route {
                                                p_idx > 1 ==> {
                                                      mut as int64: grand_node = path[p_idx - 1]
                                                      route {
                                                            left_ch[grand_node] == parent_node ==> {
                                                                  left_ch[grand_node] = child_node
                                                            }
                                                            _ ==> {
                                                                  right_ch[grand_node] = child_node
                                                            }
                                                      }
                                                }
                                                _ ==> {
                                                      #L child_node se tornou a nova raiz
                                                      root = child_node
                                                }
                                          }
                                          p_idx = p_idx - 1
                                    }
                                    _ ==> {
                                          #L Propriedade de heap satisfeita
                                          break
                                    }
                              }
                        }
                  }
            }
            ins_i = ins_i + 1
      }

      println("2. Treap construido com sucesso (Raiz no: " + root + ", Chave: " + key[root] + ", Prioridade: " + priority[root] + ")")

      #L Busca no Treap (Search)
      println("3. Testando buscas de chave no Treap:")
      mut as list of int64: chaves_busca = [40, 70, 99]
      mut as list of bool: achados = []
      mut as int64: bi = 1
      infinite (bi <= listLength(chaves_busca)) {
            mut as int64: target_k = chaves_busca[bi]
            mut as int64: curr = root
            mut as bool: found = false
            infinite (curr != 0) {
                  route {
                        target_k == key[curr] ==> {
                              found = true
                              break
                        }
                        target_k < key[curr] ==> {
                              curr = left_ch[curr]
                        }
                        _ ==> {
                              curr = right_ch[curr]
                        }
                  }
            }
            achados = listPushBack(achados, found)
            println("   Busca chave " + target_k + ": " + found)
            bi = bi + 1
      }

      #L Percurso In-Order (deve resultar em chaves ordenadas)
      println("4. Percurso In-Order para validar ordenacao BST:")
      mut as list of int64: inorder_keys = []
      mut as list of int64: stack_in = []
      mut as int64: cur_node = root

      infinite (cur_node != 0 or listLength(stack_in) > 0) {
            infinite (cur_node != 0) {
                  stack_in = listPushBack(stack_in, cur_node)
                  cur_node = left_ch[cur_node]
            }
            mut as int64: s_len = listLength(stack_in)
            cur_node = stack_in[s_len]
            stack_in = listTake(stack_in, s_len - 1)

            inorder_keys = listPushBack(inorder_keys, key[cur_node])
            cur_node = right_ch[cur_node]
      }
      println("   Chaves em ordem: " + inorder_keys)

      #L Validacao de ordenacao ascendente
      mut as bool: ordenado = true
      mut as int64: oi = 1
      mut as int64: n_ord = listLength(inorder_keys)
      infinite (oi < n_ord) {
            route {
                  inorder_keys[oi] > inorder_keys[oi + 1] ==> {
                        ordenado = false
                  }
                  _ ==> {
                  }
            }
            oi = oi + 1
      }
      println("5. Verificacao da propriedade BST (Ordenado): " + ordenado)

      #L Validacao da prioridade de Max-Heap em todos os nos
      mut as bool: heap_valido = true
      mut as int64: hi = 1
      infinite (hi < listLength(key)) {
            mut as int64: l_child = left_ch[hi]
            mut as int64: r_child = right_ch[hi]
            route {
                  l_child != 0 ==> {
                        route {
                              priority[hi] < priority[l_child] ==> {
                                    heap_valido = false
                              }
                              _ ==> {
                              }
                        }
                  }
                  _ ==> {
                  }
            }
            route {
                  r_child != 0 ==> {
                        route {
                              priority[hi] < priority[r_child] ==> {
                                    heap_valido = false
                              }
                              _ ==> {
                              }
                        }
                  }
                  _ ==> {
                  }
            }
            hi = hi + 1
      }
      println("6. Verificacao da propriedade Max-Heap: " + heap_valido)

      mut as bool: ok = ordenado and heap_valido and achados[1] and achados[2] and (not achados[3])
      println("7. Verificacao geral do Treap: " + ok)
      println("Concluido com Sucesso")
}
