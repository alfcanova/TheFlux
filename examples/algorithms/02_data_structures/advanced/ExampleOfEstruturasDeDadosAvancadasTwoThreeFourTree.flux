#L ============================================================================
#L Algoritmo: 2-3-4 Tree (Arvore Balanceada de Busca Multi-Caminho com Split Top-Down)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados e algoritmos associados
#L Complexidade: Busca O(log N) | Insercao O(log N) | Altura Garantida <= log2(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosAvancadasTwoThreeFourTree) {
      println("==================================================")
      println("  SciAlgo: 2-3-4 Tree (Split Top-Down Preemptivo)")
      println("==================================================")

      #L Representacao dos nos da 2-3-4 Tree:
      #L Nos podem ter 1, 2 ou 3 chaves e 2, 3 ou 4 filhos (0 se folha)
      mut as list of int64: num_keys = []
      mut as list of int64: k1 = []
      mut as list of int64: k2 = []
      mut as list of int64: k3 = []
      mut as list of int64: ch1 = []
      mut as list of int64: ch2 = []
      mut as list of int64: ch3 = []
      mut as list of int64: ch4 = []
      mut as list of int64: par = []
      mut as list of bool: is_leaf = []
      mut as int64: root = 0

      mut as list of int64: chaves = [10, 20, 30, 40, 50, 60, 70, 25, 15, 35]
      mut as int64: total_keys = listLength(chaves)

      println("1. Inserindo chaves: " + chaves)

      mut as int64: ki = 1
      infinite (ki <= total_keys) {
            mut as int64: val = chaves[ki]

            route {
                  root == 0 ==> {
                        #L Cria raiz como 2-node
                        num_keys = listPushBack(num_keys, 1)
                        k1 = listPushBack(k1, val)
                        k2 = listPushBack(k2, 0)
                        k3 = listPushBack(k3, 0)
                        ch1 = listPushBack(ch1, 0)
                        ch2 = listPushBack(ch2, 0)
                        ch3 = listPushBack(ch3, 0)
                        ch4 = listPushBack(ch4, 0)
                        par = listPushBack(par, 0)
                        is_leaf = listPushBack(is_leaf, true)
                        root = 1
                  }
                  _ ==> {
                        #L Se a raiz for 4-node (3 chaves), divide imediatamente
                        route {
                              num_keys[root] == 3 ==> {
                                    mut as int64: r_mid = k2[root]
                                    mut as int64: r_k1 = k1[root]
                                    mut as int64: r_k3 = k3[root]
                                    mut as int64: r_c1 = ch1[root]
                                    mut as int64: r_c2 = ch2[root]
                                    mut as int64: r_c3 = ch3[root]
                                    mut as int64: r_c4 = ch4[root]
                                    mut as bool: r_lf = is_leaf[root]

                                    #L A raiz antiga vira o filho esquerdo com 1 chave (r_k1)
                                    k1[root] = r_k1
                                    k2[root] = 0
                                    k3[root] = 0
                                    ch1[root] = r_c1
                                    ch2[root] = r_c2
                                    ch3[root] = 0
                                    ch4[root] = 0
                                    num_keys[root] = 1

                                    #L Cria irmao direito com 1 chave (r_k3)
                                    num_keys = listPushBack(num_keys, 1)
                                    k1 = listPushBack(k1, r_k3)
                                    k2 = listPushBack(k2, 0)
                                    k3 = listPushBack(k3, 0)
                                    ch1 = listPushBack(ch1, r_c3)
                                    ch2 = listPushBack(ch2, r_c4)
                                    ch3 = listPushBack(ch3, 0)
                                    ch4 = listPushBack(ch4, 0)
                                    par = listPushBack(par, 0)
                                    is_leaf = listPushBack(is_leaf, r_lf)
                                    mut as int64: right_sibling = listLength(num_keys)

                                    route {
                                          r_c3 != 0 ==> { par[r_c3] = right_sibling }
                                    }
                                    route {
                                          r_c4 != 0 ==> { par[r_c4] = right_sibling }
                                    }

                                    #L Cria nova raiz com r_mid
                                    num_keys = listPushBack(num_keys, 1)
                                    k1 = listPushBack(k1, r_mid)
                                    k2 = listPushBack(k2, 0)
                                    k3 = listPushBack(k3, 0)
                                    ch1 = listPushBack(ch1, root)
                                    ch2 = listPushBack(ch2, right_sibling)
                                    ch3 = listPushBack(ch3, 0)
                                    ch4 = listPushBack(ch4, 0)
                                    par = listPushBack(par, 0)
                                    is_leaf = listPushBack(is_leaf, false)
                                    mut as int64: new_root = listLength(num_keys)

                                    par[root] = new_root
                                    par[right_sibling] = new_root
                                    root = new_root
                              }
                        }

                        #L Desce na arvore dividindo qualquer 4-node encontrado (Split Top-Down)
                        mut as int64: curr = root
                        mut as bool: inserting = true
                        infinite (inserting) {
                              #L Verifica se folha foi alcancada
                              mut as bool: lf = is_leaf[curr]
                              route {
                                    lf ==> {
                                          #L Insere na folha (garantido espaco porque nao e 4-node)
                                          mut as int64: nk = num_keys[curr]
                                          route {
                                                nk == 1 ==> {
                                                      mut as int64: f1 = k1[curr]
                                                      route {
                                                            val < f1 ==> {
                                                                  k1[curr] = val
                                                                  k2[curr] = f1
                                                            }
                                                            _ ==> {
                                                                  k2[curr] = val
                                                            }
                                                      }
                                                      num_keys[curr] = 2
                                                }
                                                nk == 2 ==> {
                                                      mut as int64: f1 = k1[curr]
                                                      mut as int64: f2 = k2[curr]
                                                      route {
                                                            val < f1 ==> {
                                                                  k1[curr] = val
                                                                  k2[curr] = f1
                                                                  k3[curr] = f2
                                                            }
                                                            val < f2 ==> {
                                                                  k2[curr] = val
                                                                  k3[curr] = f2
                                                            }
                                                            _ ==> {
                                                                  k3[curr] = val
                                                            }
                                                      }
                                                      num_keys[curr] = 3
                                                }
                                          }
                                          inserting = false
                                    }
                                    _ ==> {
                                          #L Escolhe proximo filho
                                          mut as int64: next_ch = 0
                                          mut as int64: nk = num_keys[curr]
                                          route {
                                                nk == 1 ==> {
                                                      route {
                                                            val < k1[curr] ==> { next_ch = ch1[curr] }
                                                            _ ==> { next_ch = ch2[curr] }
                                                      }
                                                }
                                                nk == 2 ==> {
                                                      route {
                                                            val < k1[curr] ==> { next_ch = ch1[curr] }
                                                            val < k2[curr] ==> { next_ch = ch2[curr] }
                                                            _ ==> { next_ch = ch3[curr] }
                                                      }
                                                }
                                                _ ==> {
                                                      route {
                                                            val < k1[curr] ==> { next_ch = ch1[curr] }
                                                            val < k2[curr] ==> { next_ch = ch2[curr] }
                                                            val < k3[curr] ==> { next_ch = ch3[curr] }
                                                            _ ==> { next_ch = ch4[curr] }
                                                      }
                                                }
                                          }

                                          #L Se next_ch for 4-node (num_keys == 3), divide-o antes de descer!
                                          route {
                                                num_keys[next_ch] == 3 ==> {
                                                      mut as int64: ch_mid = k2[next_ch]
                                                      mut as int64: ch_k1 = k1[next_ch]
                                                      mut as int64: ch_k3 = k3[next_ch]
                                                      mut as int64: cc1 = ch1[next_ch]
                                                      mut as int64: cc2 = ch2[next_ch]
                                                      mut as int64: cc3 = ch3[next_ch]
                                                      mut as int64: cc4 = ch4[next_ch]
                                                      mut as bool: ch_lf = is_leaf[next_ch]

                                                      #L Reduz next_ch para 1 chave
                                                      k1[next_ch] = ch_k1
                                                      k2[next_ch] = 0
                                                      k3[next_ch] = 0
                                                      ch1[next_ch] = cc1
                                                      ch2[next_ch] = cc2
                                                      ch3[next_ch] = 0
                                                      ch4[next_ch] = 0
                                                      num_keys[next_ch] = 1

                                                      #L Cria irmao direito com 1 chave
                                                      num_keys = listPushBack(num_keys, 1)
                                                      k1 = listPushBack(k1, ch_k3)
                                                      k2 = listPushBack(k2, 0)
                                                      k3 = listPushBack(k3, 0)
                                                      ch1 = listPushBack(ch1, cc3)
                                                      ch2 = listPushBack(ch2, cc4)
                                                      ch3 = listPushBack(ch3, 0)
                                                      ch4 = listPushBack(ch4, 0)
                                                      par = listPushBack(par, curr)
                                                      is_leaf = listPushBack(is_leaf, ch_lf)
                                                      mut as int64: new_sib = listLength(num_keys)

                                                      route {
                                                            cc3 != 0 ==> { par[cc3] = new_sib }
                                                      }
                                                      route {
                                                            cc4 != 0 ==> { par[cc4] = new_sib }
                                                      }

                                                      #L Promove ch_mid para curr (curr tem no maximo 2 chaves)
                                                      mut as int64: p_nk = num_keys[curr]
                                                      route {
                                                            p_nk == 1 ==> {
                                                                  route {
                                                                        ch_mid < k1[curr] ==> {
                                                                              k2[curr] = k1[curr]
                                                                              k1[curr] = ch_mid
                                                                              ch3[curr] = ch2[curr]
                                                                              ch2[curr] = new_sib
                                                                        }
                                                                        _ ==> {
                                                                              k2[curr] = ch_mid
                                                                              ch3[curr] = new_sib
                                                                        }
                                                                  }
                                                                  num_keys[curr] = 2
                                                            }
                                                            _ ==> {
                                                                  #L p_nk == 2
                                                                  route {
                                                                        ch_mid < k1[curr] ==> {
                                                                              k3[curr] = k2[curr]
                                                                              k2[curr] = k1[curr]
                                                                              k1[curr] = ch_mid
                                                                              ch4[curr] = ch3[curr]
                                                                              ch3[curr] = ch2[curr]
                                                                              ch2[curr] = new_sib
                                                                        }
                                                                        ch_mid < k2[curr] ==> {
                                                                              k3[curr] = k2[curr]
                                                                              k2[curr] = ch_mid
                                                                              ch4[curr] = ch3[curr]
                                                                              ch3[curr] = new_sib
                                                                        }
                                                                        _ ==> {
                                                                              k3[curr] = ch_mid
                                                                              ch4[curr] = new_sib
                                                                        }
                                                                  }
                                                                  num_keys[curr] = 3
                                                            }
                                                      }

                                                      #L Decide qual dos dois filhos seguir apos o split
                                                      route {
                                                            val < ch_mid ==> {
                                                                  curr = next_ch
                                                            }
                                                            _ ==> {
                                                                  curr = new_sib
                                                            }
                                                      }
                                                }
                                                _ ==> {
                                                      curr = next_ch
                                                }
                                          }
                                    }
                              }
                        }
                  }
            }

            ki = ki + 1
      }

      println("2. Arvore 2-3-4 construida com sucesso.")

      #L Consultas de busca
      mut as list of int64: busca_testes = [10, 25, 35, 70, 99, 1]
      mut as list of bool: busca_esperada = [true, true, true, true, false, false]
      mut as bool: all_search_ok = true

      println("3. Testando operacao de busca na 2-3-4 Tree:")
      mut as int64: bi = 1
      infinite (bi <= listLength(busca_testes)) {
            mut as int64: qk = busca_testes[bi]
            mut as int64: curr = root
            mut as bool: found = false
            mut as bool: searching = true

            infinite (searching) {
                  route {
                        curr == 0 ==> { searching = false }
                        _ ==> {
                              mut as int64: nk = num_keys[curr]
                              mut as int64: k_a = k1[curr]
                              route {
                                    qk == k_a ==> {
                                          found = true
                                          searching = false
                                    }
                                    qk < k_a ==> { curr = ch1[curr] }
                                    _ ==> {
                                          route {
                                                nk == 1 ==> { curr = ch2[curr] }
                                                _ ==> {
                                                      mut as int64: k_b = k2[curr]
                                                      route {
                                                            qk == k_b ==> {
                                                                  found = true
                                                                  searching = false
                                                            }
                                                            qk < k_b ==> { curr = ch2[curr] }
                                                            _ ==> {
                                                                  route {
                                                                        nk == 2 ==> { curr = ch3[curr] }
                                                                        _ ==> {
                                                                              mut as int64: k_c = k3[curr]
                                                                              route {
                                                                                    qk == k_c ==> {
                                                                                          found = true
                                                                                          searching = false
                                                                                    }
                                                                                    qk < k_c ==> { curr = ch3[curr] }
                                                                                    _ ==> { curr = ch4[curr] }
                                                                              }
                                                                        }
                                                                  }
                                                            }
                                                      }
                                                }
                                          }
                                    }
                              }
                        }
                  }
            }

            mut as bool: match_exp = (found == busca_esperada[bi])
            route {
                  not match_exp ==> { all_search_ok = false }
            }
            println("   Busca por " + qk + ": " + found + " [esperado " + busca_esperada[bi] + "] -> " + match_exp)
            bi = bi + 1
      }

      #L Percurso in-order comprovando ordenacao
      println("4. Percurso in-order comprovando ordenacao estrita:")
      mut as list of int64: in_order = []
      mut as list of int64: stk_node = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      mut as list of int64: stk_state = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      mut as int64: s_top = 1
      stk_node[1] = root
      stk_state[1] = 0

      infinite (s_top > 0) {
            mut as int64: u = stk_node[s_top]
            mut as int64: state = stk_state[s_top]
            s_top = s_top - 1

            route {
                  u != 0 ==> {
                        mut as int64: nk = num_keys[u]
                        mut as bool: lf = is_leaf[u]

                        route {
                              lf ==> {
                                    in_order = listPushBack(in_order, k1[u])
                                    route {
                                          nk >= 2 ==> { in_order = listPushBack(in_order, k2[u]) }
                                    }
                                    route {
                                          nk == 3 ==> { in_order = listPushBack(in_order, k3[u]) }
                                    }
                              }
                              _ ==> {
                                    route {
                                          state == 0 ==> {
                                                s_top = s_top + 1
                                                stk_node[s_top] = u
                                                stk_state[s_top] = 1

                                                s_top = s_top + 1
                                                stk_node[s_top] = ch1[u]
                                                stk_state[s_top] = 0
                                          }
                                          state == 1 ==> {
                                                in_order = listPushBack(in_order, k1[u])

                                                s_top = s_top + 1
                                                stk_node[s_top] = u
                                                stk_state[s_top] = 2

                                                s_top = s_top + 1
                                                stk_node[s_top] = ch2[u]
                                                stk_state[s_top] = 0
                                          }
                                          state == 2 ==> {
                                                route {
                                                      nk >= 2 ==> {
                                                            in_order = listPushBack(in_order, k2[u])

                                                            s_top = s_top + 1
                                                            stk_node[s_top] = u
                                                            stk_state[s_top] = 3

                                                            s_top = s_top + 1
                                                            stk_node[s_top] = ch3[u]
                                                            stk_state[s_top] = 0
                                                      }
                                                }
                                          }
                                          state == 3 ==> {
                                                route {
                                                      nk == 3 ==> {
                                                            in_order = listPushBack(in_order, k3[u])

                                                            s_top = s_top + 1
                                                            stk_node[s_top] = ch4[u]
                                                            stk_state[s_top] = 0
                                                      }
                                                }
                                          }
                                    }
                              }
                        }
                  }
            }
      }

      println("   Chaves ordenadas: " + in_order)
      mut as bool: is_sorted = true
      mut as int64: oi = 2
      infinite (oi <= listLength(in_order)) {
            route {
                  in_order[oi] <= in_order[oi - 1] ==> { is_sorted = false }
            }
            oi = oi + 1
      }
      println("   Ordenacao estrita verificada: " + is_sorted)
      route {
            not is_sorted ==> { all_search_ok = false }
      }

      println("5. Verificacao geral da 2-3-4 Tree: " + all_search_ok)
      println("Concluido com Sucesso")
}
