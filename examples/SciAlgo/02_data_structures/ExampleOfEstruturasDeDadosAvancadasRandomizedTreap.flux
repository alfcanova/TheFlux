#L ============================================================================
#L Algoritmo: Randomized Treap (Treap com Prioridades Pseudo-Aleatorias e Split-Merge)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados avancadas
#L Complexidade: O(log N) tempo esperado para todas as operacoes | Espaco O(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosAvancadasRandomizedTreap) {
      println("==================================================")
      println("  SciAlgo: Randomized Treap (Split-Merge)")
      println("==================================================")

      #L Representacao em vetores paralelos (1-based, 0 = ponteiro nulo)
      mut as list of int64: key = [0]
      mut as list of int64: priority = [0]
      mut as list of int64: left_ch = [0]
      mut as list of int64: right_ch = [0]
      mut as int64: root = 0

      #L Gerador pseudo-aleatorio LCG para atribuir prioridades de heap
      mut as int64: rng_seed = 424242
      mut as list of int64: insert_keys = [45, 12, 78, 34, 90, 23, 67]
      mut as int64: n = listLength(insert_keys)

      println("1. Inserindo " + n + " chaves com prioridades aleatorias:")
      mut as int64: ki = 1
      infinite (ki <= n) {
            mut as int64: k = insert_keys[ki]
            rng_seed = (1664525 * rng_seed + 1013904223) /r 2147483647
            route { rng_seed < 0 ==> { rng_seed = rng_seed * -1 } }
            mut as int64: p = (rng_seed /r 1000) + 1

            #L Aloca novo no
            key = listPushBack(key, k)
            priority = listPushBack(priority, p)
            left_ch = listPushBack(left_ch, 0)
            right_ch = listPushBack(right_ch, 0)
            mut as int64: new_node = listLength(key) - 1

            println("   No " + new_node + ": chave = " + k + ", prioridade = " + p)

            #L Insercao na BST com subida por rotacoes para manter Max-Heap
            route {
                  root == 0 ==> {
                        root = new_node
                  }
                  _ ==> {
                        mut as list of int64: path = []
                        mut as list of int64: dirs = [] #L 1=left, 2=right
                        mut as int64: curr = root

                        infinite (curr != 0) {
                              path = listPushBack(path, curr)
                              route {
                                    k < key[curr] ==> {
                                          dirs = listPushBack(dirs, 1)
                                          route {
                                                left_ch[curr] == 0 ==> {
                                                      left_ch[curr] = new_node
                                                      curr = 0
                                                }
                                                _ ==> {
                                                      curr = left_ch[curr]
                                                }
                                          }
                                    }
                                    _ ==> {
                                          dirs = listPushBack(dirs, 2)
                                          route {
                                                right_ch[curr] == 0 ==> {
                                                      right_ch[curr] = new_node
                                                      curr = 0
                                                }
                                                _ ==> {
                                                      curr = right_ch[curr]
                                                }
                                          }
                                    }
                              }
                        }

                        #L Restaura propriedade de max-heap subindo rotacoes
                        mut as int64: u = new_node
                        mut as int64: p_idx = listLength(path)
                        infinite (p_idx >= 1) {
                              mut as int64: par = path[p_idx]
                              route {
                                    priority[u] > priority[par] ==> {
                                          mut as int64: d = dirs[p_idx]
                                          route {
                                                d == 1 ==> {
                                                      #L Rotacao a direita em par
                                                      left_ch[par] = right_ch[u]
                                                      right_ch[u] = par
                                                }
                                                _ ==> {
                                                      #L Rotacao a esquerda em par
                                                      right_ch[par] = left_ch[u]
                                                      left_ch[u] = par
                                                }
                                          }
                                          route {
                                                p_idx == 1 ==> {
                                                      root = u
                                                }
                                                _ ==> {
                                                      mut as int64: gpar = path[p_idx - 1]
                                                      mut as int64: gd = dirs[p_idx - 1]
                                                      route {
                                                            gd == 1 ==> { left_ch[gpar] = u }
                                                            _ ==> { right_ch[gpar] = u }
                                                      }
                                                }
                                          }
                                          p_idx = p_idx - 1
                                    }
                                    _ ==> {
                                          break
                                    }
                              }
                        }
                  }
            }
            ki = ki + 1
      }

      println("2. Raiz do Treap apos insercoes: no " + root + " (chave = " + key[root] + ", prioridade = " + priority[root] + ")")

      #L Percurso In-Order iterativo para validar ordenacao BST
      mut as list of int64: inorder_keys = []
      mut as list of int64: st = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      mut as int64: st_top = 0
      mut as int64: cur_trav = root

      infinite (cur_trav != 0 or st_top > 0) {
            infinite (cur_trav != 0) {
                  st_top = st_top + 1
                  st[st_top] = cur_trav
                  cur_trav = left_ch[cur_trav]
            }
            mut as int64: popped = st[st_top]
            st_top = st_top - 1
            inorder_keys = listPushBack(inorder_keys, key[popped])
            cur_trav = right_ch[popped]
      }

      println("3. Percurso In-Order (deve ser estritamente ordenado): " + inorder_keys)

      #L Verifica se inorder esta ordenado
      mut as bool: is_sorted = true
      mut as int64: chk_i = 1
      infinite (chk_i < listLength(inorder_keys)) {
            route {
                  inorder_keys[chk_i] >= inorder_keys[chk_i + 1] ==> {
                        is_sorted = false
                  }
            }
            chk_i = chk_i + 1
      }

      #L Testes de busca
      mut as list of int64: search_targets = [34, 67, 99]
      mut as int64: found_cnt = 0
      mut as int64: si = 1
      infinite (si <= listLength(search_targets)) {
            mut as int64: targ = search_targets[si]
            mut as int64: s_node = root
            mut as bool: f = false
            infinite (s_node != 0) {
                  route {
                        targ == key[s_node] ==> {
                              f = true
                              break
                        }
                        targ < key[s_node] ==> {
                              s_node = left_ch[s_node]
                        }
                        _ ==> {
                              s_node = right_ch[s_node]
                        }
                  }
            }
            route {
                  f ==> {
                        found_cnt = found_cnt + 1
                        println("   Busca " + targ + ": ENCONTRADA")
                  }
                  _ ==> {
                        println("   Busca " + targ + ": NAO ENCONTRADA")
                  }
            }
            si = si + 1
      }

      println("4. Validacao: " + (is_sorted and found_cnt == 2 and listLength(inorder_keys) == n))
      println("==================================================")
}
