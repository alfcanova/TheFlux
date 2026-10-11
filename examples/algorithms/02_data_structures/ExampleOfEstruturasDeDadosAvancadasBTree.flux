#L ============================================================================
#L Algoritmo: B-Tree (Arvore B Multi-Caminho de Ordem M = 4 / Max 3 Chaves)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados e algoritmos associados
#L Complexidade: Busca O(log N) | Insercao O(log N) | Altura Garantida <= log_{M/2}(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosAvancadasBTree) {
      println("==================================================")
      println("  SciAlgo: B-Tree (Arvore B de Ordem M = 4)")
      println("==================================================")

      #L Representacao dos nos da Arvore B de Ordem 4 (Bayer & McCreight, 1972):
      #L Cada no armazena ate 3 chaves e ate 4 ponteiros de filhos
      mut as list of int64: num_k = []
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

      mut as list of int64: chaves = [6, 17, 22, 45, 31, 8, 54, 12, 19, 28, 63]
      mut as int64: total_keys = listLength(chaves)

      println("1. Inserindo elementos na Arvore B: " + chaves)

      mut as int64: ki = 1
      infinite (ki <= total_keys) {
            mut as int64: val = chaves[ki]

            route {
                  root == 0 ==> {
                        num_k = listPushBack(num_k, 1)
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
                        #L 1. Encontra folha
                        mut as int64: curr = root
                        mut as bool: searching = true
                        infinite (searching) {
                              mut as bool: lf = is_leaf[curr]
                              route {
                                    lf ==> { searching = false }
                                    _ ==> {
                                          mut as int64: nk = num_k[curr]
                                          route {
                                                nk == 1 ==> {
                                                      route {
                                                            val < k1[curr] ==> { curr = ch1[curr] }
                                                            _ ==> { curr = ch2[curr] }
                                                      }
                                                }
                                                nk == 2 ==> {
                                                      route {
                                                            val < k1[curr] ==> { curr = ch1[curr] }
                                                            val < k2[curr] ==> { curr = ch2[curr] }
                                                            _ ==> { curr = ch3[curr] }
                                                      }
                                                }
                                                _ ==> {
                                                      route {
                                                            val < k1[curr] ==> { curr = ch1[curr] }
                                                            val < k2[curr] ==> { curr = ch2[curr] }
                                                            val < k3[curr] ==> { curr = ch3[curr] }
                                                            _ ==> { curr = ch4[curr] }
                                                      }
                                                }
                                          }
                                    }
                              }
                        }

                        #L 2. Insere val na folha curr
                        mut as int64: cur_nk = num_k[curr]
                        route {
                              cur_nk == 1 ==> {
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
                                    num_k[curr] = 2
                              }
                              cur_nk == 2 ==> {
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
                                    num_k[curr] = 3
                              }
                              _ ==> {
                                    #L A folha tinha 3 chaves e transbordou para 4 chaves (Split B-Tree)
                                    #L Ordena as 4 chaves temporarias
                                    mut as list of int64: t4 = [k1[curr], k2[curr], k3[curr], val]
                                    #L Insertion sort de 4 elementos
                                    mut as int64: si = 2
                                    infinite (si <= 4) {
                                          mut as int64: item = t4[si]
                                          mut as int64: sj = si - 1
                                          mut as bool: s_cont = true
                                          infinite (s_cont) {
                                                route {
                                                      sj < 1 ==> { s_cont = false }
                                                      _ ==> {
                                                            route {
                                                                  t4[sj] > item ==> {
                                                                        t4[sj + 1] = t4[sj]
                                                                        sj = sj - 1
                                                                  }
                                                                  _ ==> { s_cont = false }
                                                            }
                                                      }
                                                }
                                          }
                                          t4[sj + 1] = item
                                          si = si + 1
                                    }

                                    #L Chave mediana promovida = t4[3], no esquerdo fica com t4[1], t4[2]
                                    #L Novo no direito fica com t4[4]
                                    mut as int64: promo_key = t4[3]

                                    k1[curr] = t4[1]
                                    k2[curr] = t4[2]
                                    k3[curr] = 0
                                    num_k[curr] = 2

                                    num_k = listPushBack(num_k, 1)
                                    k1 = listPushBack(k1, t4[4])
                                    k2 = listPushBack(k2, 0)
                                    k3 = listPushBack(k3, 0)
                                    ch1 = listPushBack(ch1, 0)
                                    ch2 = listPushBack(ch2, 0)
                                    ch3 = listPushBack(ch3, 0)
                                    ch4 = listPushBack(ch4, 0)
                                    par = listPushBack(par, par[curr])
                                    is_leaf = listPushBack(is_leaf, true)
                                    mut as int64: new_sib = listLength(num_k)

                                    #L Propagacao ascendente para o pai
                                    mut as int64: cur_p = par[curr]
                                    mut as int64: p_key = promo_key
                                    mut as int64: p_right = new_sib
                                    mut as bool: prop = true

                                    infinite (prop) {
                                          route {
                                                cur_p == 0 ==> {
                                                      #L Cria nova raiz
                                                      num_k = listPushBack(num_k, 1)
                                                      k1 = listPushBack(k1, p_key)
                                                      k2 = listPushBack(k2, 0)
                                                      k3 = listPushBack(k3, 0)
                                                      ch1 = listPushBack(ch1, curr)
                                                      ch2 = listPushBack(ch2, p_right)
                                                      ch3 = listPushBack(ch3, 0)
                                                      ch4 = listPushBack(ch4, 0)
                                                      par = listPushBack(par, 0)
                                                      is_leaf = listPushBack(is_leaf, false)
                                                      mut as int64: new_r = listLength(num_k)

                                                      par[curr] = new_r
                                                      par[p_right] = new_r
                                                      root = new_r
                                                      prop = false
                                                }
                                                _ ==> {
                                                      mut as int64: p_nk = num_k[cur_p]
                                                      route {
                                                            p_nk == 1 ==> {
                                                                  route {
                                                                        p_key < k1[cur_p] ==> {
                                                                              k2[cur_p] = k1[cur_p]
                                                                              k1[cur_p] = p_key
                                                                              ch3[cur_p] = ch2[cur_p]
                                                                              ch2[cur_p] = p_right
                                                                        }
                                                                        _ ==> {
                                                                              k2[cur_p] = p_key
                                                                              ch3[cur_p] = p_right
                                                                        }
                                                                  }
                                                                  par[p_right] = cur_p
                                                                  num_k[cur_p] = 2
                                                                  prop = false
                                                            }
                                                            p_nk == 2 ==> {
                                                                  route {
                                                                        p_key < k1[cur_p] ==> {
                                                                              k3[cur_p] = k2[cur_p]
                                                                              k2[cur_p] = k1[cur_p]
                                                                              k1[cur_p] = p_key
                                                                              ch4[cur_p] = ch3[cur_p]
                                                                              ch3[cur_p] = ch2[cur_p]
                                                                              ch2[cur_p] = p_right
                                                                        }
                                                                        p_key < k2[cur_p] ==> {
                                                                              k3[cur_p] = k2[cur_p]
                                                                              k2[cur_p] = p_key
                                                                              ch4[cur_p] = ch3[cur_p]
                                                                              ch3[cur_p] = p_right
                                                                        }
                                                                        _ ==> {
                                                                              k3[cur_p] = p_key
                                                                              ch4[cur_p] = p_right
                                                                        }
                                                                  }
                                                                  par[p_right] = cur_p
                                                                  num_k[cur_p] = 3
                                                                  prop = false
                                                            }
                                                      }
                                                }
                                          }
                                    }
                              }
                        }
                  }
            }

            ki = ki + 1
      }

      println("2. Arvore B construida com sucesso.")

      #L Busca por chaves na Arvore B
      mut as list of int64: busca_testes = [6, 22, 54, 63, 100, 3]
      mut as list of bool: busca_esperada = [true, true, true, true, false, false]
      mut as bool: all_search_ok = true

      println("3. Testando operacao de busca na Arvore B:")
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
                              mut as int64: nk = num_k[curr]
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
                        mut as int64: nk = num_k[u]
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

      println("5. Verificacao geral da Arvore B: " + all_search_ok)
      println("Concluido com Sucesso")
}
