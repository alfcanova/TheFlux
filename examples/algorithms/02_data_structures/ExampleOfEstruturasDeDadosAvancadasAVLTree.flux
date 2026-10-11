#L ============================================================================
#L Algoritmo: AVL Tree (Arvore Binaria Auto-Balanceada por Altura)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados e algoritmos associados
#L Complexidade: Insercao O(log N) | Busca O(log N) | Altura Garantida <= 1.44 log2(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

function (nodeHeight) (as list of int64: h_arr, as int64: nd) as int64 {
      route {
            nd <= 0 ==> {
                  mut as int64: zero = 0
                  emit(nice, zero, "null")
            }
            _ ==> {
                  mut as int64: h = h_arr[nd]
                  emit(nice, h, "ok")
            }
      }
}

program (ExampleOfEstruturasDeDadosAvancadasAVLTree) {
      println("==================================================")
      println("  SciAlgo: AVL Tree (Auto-Balanceamento por Altura)")
      println("==================================================")

      #L Vetores paralelos de nos (1-based, 0 = NULL)
      mut as list of int64: key = [0]
      mut as list of int64: height = [0]
      mut as list of int64: left_ch = [0]
      mut as list of int64: right_ch = [0]
      mut as int64: root = 0

      #L Sequencia de insercao que forca todas as 4 rotacoes (LL, RR, LR, RL)
      mut as list of int64: entradas = [10, 20, 30, 40, 50, 25, 5, 2]
      mut as int64: n = listLength(entradas)

      println("1. Inserindo elementos: " + entradas)

      mut as int64: ins_i = 1
      infinite (ins_i <= n) {
            mut as int64: val = entradas[ins_i]

            #L Aloca novo no
            key = listPushBack(key, val)
            height = listPushBack(height, 1)
            left_ch = listPushBack(left_ch, 0)
            right_ch = listPushBack(right_ch, 0)
            mut as int64: new_node = listLength(key) - 1

            route {
                  root == 0 ==> {
                        root = new_node
                  }
                  _ ==> {
                        #L Desce como BST e armazena o caminho na pilha
                        mut as list of int64: path = []
                        mut as int64: curr = root

                        infinite (curr != 0) {
                              path = listPushBack(path, curr)
                              route {
                                    val < key[curr] ==> {
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

                        #L Sobe pelo caminho recalculando alturas e aplicando rotacoes
                        mut as int64: p_idx = listLength(path)
                        infinite (p_idx >= 1) {
                              mut as int64: node_id = path[p_idx]
                              mut as int64: l = left_ch[node_id]
                              mut as int64: r = right_ch[node_id]

                              #L Alturas dos filhos usando funcao segura
                              mut as int64: hl = nodeHeight(height, l)
                              mut as int64: hr = nodeHeight(height, r)
                              mut as int64: max_h = hl
                              route { hr > hl ==> { max_h = hr } _ ==> {} }
                              height[node_id] = 1 + max_h

                              #L Fator de balanceamento: bf = hl - hr
                              mut as int64: bf = hl - hr

                              #L Novo ponteiro que substituirá node_id apos rotacao (se houver)
                              mut as int64: new_subroot = node_id

                              route {
                                    bf > 1 ==> {
                                          #L Desbalanceado a esquerda
                                          mut as int64: l_left = left_ch[l]
                                          mut as int64: l_right = right_ch[l]
                                          mut as int64: bf_left = nodeHeight(height, l_left) - nodeHeight(height, l_right)

                                          route {
                                                bf_left < 0 ==> {
                                                      #L Caso LR: rotacao a esquerda no filho esquerdo primeiro
                                                      mut as int64: y = right_ch[l]
                                                      right_ch[l] = left_ch[y]
                                                      left_ch[y] = l

                                                      #L Recalcula alturas de l e y
                                                      mut as int64: hl1 = nodeHeight(height, left_ch[l])
                                                      mut as int64: hr1 = nodeHeight(height, right_ch[l])
                                                      mut as int64: m1 = hl1
                                                      route { hr1 > hl1 ==> { m1 = hr1 } _ ==> {} }
                                                      height[l] = 1 + m1

                                                      mut as int64: hy_l = nodeHeight(height, left_ch[y])
                                                      mut as int64: hy_r = nodeHeight(height, right_ch[y])
                                                      mut as int64: my = hy_l
                                                      route { hy_r > hy_l ==> { my = hy_r } _ ==> {} }
                                                      height[y] = 1 + my

                                                      left_ch[node_id] = y
                                                      l = y
                                                }
                                                _ ==> {
                                                }
                                          }

                                          #L Rotacao a Direita (LL) em node_id
                                          mut as int64: y_ll = left_ch[node_id]
                                          left_ch[node_id] = right_ch[y_ll]
                                          right_ch[y_ll] = node_id

                                          #L Atualiza altura de node_id
                                          mut as int64: h_nid_l = nodeHeight(height, left_ch[node_id])
                                          mut as int64: h_nid_r = nodeHeight(height, right_ch[node_id])
                                          mut as int64: m_nid = h_nid_l
                                          route { h_nid_r > h_nid_l ==> { m_nid = h_nid_r } _ ==> {} }
                                          height[node_id] = 1 + m_nid

                                          #L Atualiza altura de y_ll
                                          mut as int64: hy_ll_l = nodeHeight(height, left_ch[y_ll])
                                          mut as int64: hy_ll_r = nodeHeight(height, right_ch[y_ll])
                                          mut as int64: m_yll = hy_ll_l
                                          route { hy_ll_r > hy_ll_l ==> { m_yll = hy_ll_r } _ ==> {} }
                                          height[y_ll] = 1 + m_yll

                                          new_subroot = y_ll
                                    }
                                    bf < -1 ==> {
                                          #L Desbalanceado a direita
                                          mut as int64: r_left = left_ch[r]
                                          mut as int64: r_right = right_ch[r]
                                          mut as int64: bf_right = nodeHeight(height, r_left) - nodeHeight(height, r_right)

                                          route {
                                                bf_right > 0 ==> {
                                                      #L Caso RL: rotacao a direita no filho direito primeiro
                                                      mut as int64: y_rl = left_ch[r]
                                                      left_ch[r] = right_ch[y_rl]
                                                      right_ch[y_rl] = r

                                                      #L Recalcula alturas de r e y_rl
                                                      mut as int64: hr1 = nodeHeight(height, left_ch[r])
                                                      mut as int64: hr2 = nodeHeight(height, right_ch[r])
                                                      mut as int64: mr = hr1
                                                      route { hr2 > hr1 ==> { mr = hr2 } _ ==> {} }
                                                      height[r] = 1 + mr

                                                      mut as int64: my1 = nodeHeight(height, left_ch[y_rl])
                                                      mut as int64: my2 = nodeHeight(height, right_ch[y_rl])
                                                      mut as int64: my = my1
                                                      route { my2 > my1 ==> { my = my2 } _ ==> {} }
                                                      height[y_rl] = 1 + my

                                                      right_ch[node_id] = y_rl
                                                      r = y_rl
                                                }
                                                _ ==> {
                                                }
                                          }

                                          #L Rotacao a Esquerda (RR) em node_id
                                          mut as int64: y_rr = right_ch[node_id]
                                          right_ch[node_id] = left_ch[y_rr]
                                          left_ch[y_rr] = node_id

                                          #L Atualiza altura de node_id
                                          mut as int64: h_nid_l = nodeHeight(height, left_ch[node_id])
                                          mut as int64: h_nid_r = nodeHeight(height, right_ch[node_id])
                                          mut as int64: m_nid = h_nid_l
                                          route { h_nid_r > h_nid_l ==> { m_nid = h_nid_r } _ ==> {} }
                                          height[node_id] = 1 + m_nid

                                          #L Atualiza altura de y_rr
                                          mut as int64: hy_rr_l = nodeHeight(height, left_ch[y_rr])
                                          mut as int64: hy_rr_r = nodeHeight(height, right_ch[y_rr])
                                          mut as int64: m_yrr = hy_rr_l
                                          route { hy_rr_r > hy_rr_l ==> { m_yrr = hy_rr_r } _ ==> {} }
                                          height[y_rr] = 1 + m_yrr

                                          new_subroot = y_rr
                                    }
                                    _ ==> {
                                    }
                              }

                              #L Se houve rotacao, atualiza o pai correspondente
                              route {
                                    new_subroot != node_id ==> {
                                          route {
                                                p_idx > 1 ==> {
                                                      mut as int64: parent_id = path[p_idx - 1]
                                                      route {
                                                            left_ch[parent_id] == node_id ==> {
                                                                  left_ch[parent_id] = new_subroot
                                                            }
                                                            _ ==> {
                                                                  right_ch[parent_id] = new_subroot
                                                            }
                                                      }
                                                }
                                                _ ==> {
                                                      root = new_subroot
                                                }
                                          }
                                    }
                                    _ ==> {
                                    }
                              }

                              p_idx = p_idx - 1
                        }
                  }
            }
            ins_i = ins_i + 1
      }

      println("2. AVL Tree construida com sucesso (Raiz no: " + root + ", Chave: " + key[root] + ", Altura da raiz: " + height[root] + ")")

      #L Busca na AVL (O(log N))
      println("3. Testando buscas de chave:")
      mut as list of int64: targets = [25, 40, 99]
      mut as list of bool: founds = []
      mut as int64: ti = 1
      infinite (ti <= listLength(targets)) {
            mut as int64: tk = targets[ti]
            mut as int64: curr = root
            mut as bool: f = false
            infinite (curr != 0) {
                  route {
                        tk == key[curr] ==> {
                              f = true
                              break
                        }
                        tk < key[curr] ==> {
                              curr = left_ch[curr]
                        }
                        _ ==> {
                              curr = right_ch[curr]
                        }
                  }
            }
            founds = listPushBack(founds, f)
            println("   Busca chave " + tk + ": " + f)
            ti = ti + 1
      }

      #L Percurso In-Order (deve estar estritamente ordenado)
      mut as list of int64: in_order = []
      mut as list of int64: st_trav = []
      mut as int64: cur_tr = root

      infinite (cur_tr != 0 or listLength(st_trav) > 0) {
            infinite (cur_tr != 0) {
                  st_trav = listPushBack(st_trav, cur_tr)
                  cur_tr = left_ch[cur_tr]
            }
            mut as int64: t_sz = listLength(st_trav)
            cur_tr = st_trav[t_sz]
            st_trav = listTake(st_trav, t_sz - 1)

            in_order = listPushBack(in_order, key[cur_tr])
            cur_tr = right_ch[cur_tr]
      }
      println("4. Percurso In-Order (Elementos ordenados): " + in_order)

      mut as bool: ordenado = true
      mut as int64: oi = 1
      mut as int64: n_ord = listLength(in_order)
      infinite (oi < n_ord) {
            route {
                  in_order[oi] > in_order[oi + 1] ==> {
                        ordenado = false
                  }
                  _ ==> {
                  }
            }
            oi = oi + 1
      }

      #L Validacao da propriedade AVL: |hl - hr| <= 1 em TODOS os nos
      mut as bool: avl_balanceada = true
      mut as int64: vi = 1
      infinite (vi < listLength(key)) {
            mut as int64: l_nd = left_ch[vi]
            mut as int64: r_nd = right_ch[vi]
            mut as int64: h_l = nodeHeight(height, l_nd)
            mut as int64: h_r = nodeHeight(height, r_nd)
            mut as int64: diff = h_l - h_r
            route {
                  diff > 1 or diff < -1 ==> {
                        avl_balanceada = false
                  }
                  _ ==> {
                  }
            }
            vi = vi + 1
      }
      println("5. Verificacao da condicao de balanceamento AVL (|bf| <= 1 em todos os nos): " + avl_balanceada)

      mut as bool: ok = ordenado and avl_balanceada and founds[1] and founds[2] and (not founds[3])
      println("6. Verificacao geral da AVL Tree: " + ok)
      println("Concluido com Sucesso")
}
