#L ============================================================================
#L Algoritmo: 2-3 Tree (Arvore de Busca Multi-Caminho Balanceada)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados e algoritmos associados
#L Complexidade: Busca O(log N) | Insercao O(log N) | Altura Garantida <= log2(N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosAvancadasTwoThreeTree) {
      println("==================================================")
      println("  SciAlgo: 2-3 Tree (Arvore Balanceada Multi-Caminho)")
      println("==================================================")

      #L Representacao dos nos da 2-3 Tree:
      #L Cada no pode conter 1 ou 2 chaves (e temporariamente 3 durante divisao/split)
      #L Nos folhas tem filhos = 0
      mut as list of int64: num_keys = []
      mut as list of int64: k1 = []
      mut as list of int64: k2 = []
      mut as list of int64: ch1 = []
      mut as list of int64: ch2 = []
      mut as list of int64: ch3 = []
      mut as list of int64: par = []
      mut as list of bool: is_leaf = []
      mut as int64: root = 0

      #L Elementos para insercao
      mut as list of int64: chaves = [10, 20, 30, 40, 50, 25, 5, 15]
      mut as int64: total_keys = listLength(chaves)

      println("1. Inserindo chaves: " + chaves)

      #L Funcao/bloco para alocar novo no folha com 1 chave
      mut as int64: ki = 1
      infinite (ki <= total_keys) {
            mut as int64: val = chaves[ki]

            route {
                  root == 0 ==> {
                        #L Cria raiz
                        num_keys = listPushBack(num_keys, 1)
                        k1 = listPushBack(k1, val)
                        k2 = listPushBack(k2, 0)
                        ch1 = listPushBack(ch1, 0)
                        ch2 = listPushBack(ch2, 0)
                        ch3 = listPushBack(ch3, 0)
                        par = listPushBack(par, 0)
                        is_leaf = listPushBack(is_leaf, true)
                        root = 1
                  }
                  _ ==> {
                        #L 1. Encontra folha apropriada
                        mut as int64: curr = root
                        mut as bool: searching = true
                        infinite (searching) {
                              mut as bool: lf = is_leaf[curr]
                              route {
                                    lf ==> { searching = false }
                                    _ ==> {
                                          mut as int64: nk = num_keys[curr]
                                          route {
                                                nk == 1 ==> {
                                                      route {
                                                            val < k1[curr] ==> { curr = ch1[curr] }
                                                            _ ==> { curr = ch2[curr] }
                                                      }
                                                }
                                                _ ==> {
                                                      route {
                                                            val < k1[curr] ==> { curr = ch1[curr] }
                                                            val < k2[curr] ==> { curr = ch2[curr] }
                                                            _ ==> { curr = ch3[curr] }
                                                      }
                                                }
                                          }
                                    }
                              }
                        }

                        #L 2. Insere na folha 'curr'
                        mut as int64: cur_nk = num_keys[curr]
                        route {
                              cur_nk == 1 ==> {
                                    #L A folha tinha 1 chave, agora tera 2
                                    mut as int64: first_k = k1[curr]
                                    route {
                                          val < first_k ==> {
                                                k1[curr] = val
                                                k2[curr] = first_k
                                          }
                                          _ ==> {
                                                k2[curr] = val
                                          }
                                    }
                                    num_keys[curr] = 2
                              }
                              _ ==> {
                                    #L A folha tinha 2 chaves; ao receber a terceira, ocorre split!
                                    #L Ordena as 3 chaves: s_min, s_mid, s_max
                                    mut as int64: e1 = k1[curr]
                                    mut as int64: e2 = k2[curr]
                                    mut as int64: s_min = e1
                                    mut as int64: s_mid = e2
                                    mut as int64: s_max = val

                                    #L Ordena e1, e2, val
                                    route {
                                          val < e1 ==> {
                                                s_min = val
                                                s_mid = e1
                                                s_max = e2
                                          }
                                          val < e2 ==> {
                                                s_min = e1
                                                s_mid = val
                                                s_max = e2
                                          }
                                    }

                                    #L O no atual vira o filho esquerdo com s_min
                                    k1[curr] = s_min
                                    k2[curr] = 0
                                    num_keys[curr] = 1

                                    #L Cria novo no irmao direito com s_max
                                    num_keys = listPushBack(num_keys, 1)
                                    k1 = listPushBack(k1, s_max)
                                    k2 = listPushBack(k2, 0)
                                    ch1 = listPushBack(ch1, 0)
                                    ch2 = listPushBack(ch2, 0)
                                    ch3 = listPushBack(ch3, 0)
                                    par = listPushBack(par, par[curr])
                                    is_leaf = listPushBack(is_leaf, true)
                                    mut as int64: new_sibling = listLength(num_keys)

                                    #L Propagacao ascendente com loop enquanto houver split
                                    mut as int64: promo_k = s_mid
                                    mut as int64: promo_left = curr
                                    mut as int64: promo_right = new_sibling
                                    mut as int64: cur_p = par[curr]
                                    mut as bool: propagating = true

                                    infinite (propagating) {
                                          route {
                                                cur_p == 0 ==> {
                                                      #L Cria nova raiz
                                                      num_keys = listPushBack(num_keys, 1)
                                                      k1 = listPushBack(k1, promo_k)
                                                      k2 = listPushBack(k2, 0)
                                                      ch1 = listPushBack(ch1, promo_left)
                                                      ch2 = listPushBack(ch2, promo_right)
                                                      ch3 = listPushBack(ch3, 0)
                                                      par = listPushBack(par, 0)
                                                      is_leaf = listPushBack(is_leaf, false)
                                                      mut as int64: new_root = listLength(num_keys)
                                                      par[promo_left] = new_root
                                                      par[promo_right] = new_root
                                                      root = new_root
                                                      propagating = false
                                                }
                                                _ ==> {
                                                      mut as int64: p_nk = num_keys[cur_p]
                                                      route {
                                                            p_nk == 1 ==> {
                                                                  #L Pai tem 1 chave: insere e para
                                                                  mut as int64: pk1 = k1[cur_p]
                                                                  route {
                                                                        promo_k < pk1 ==> {
                                                                              k1[cur_p] = promo_k
                                                                              k2[cur_p] = pk1
                                                                              ch3[cur_p] = ch2[cur_p]
                                                                              ch2[cur_p] = promo_right
                                                                        }
                                                                        _ ==> {
                                                                              k2[cur_p] = promo_k
                                                                              ch3[cur_p] = promo_right
                                                                        }
                                                                  }
                                                                  par[promo_right] = cur_p
                                                                  num_keys[cur_p] = 2
                                                                  propagating = false
                                                            }
                                                            _ ==> {
                                                                  #L Pai tem 2 chaves: divide o pai em dois nos
                                                                  mut as int64: pk1 = k1[cur_p]
                                                                  mut as int64: pk2 = k2[cur_p]
                                                                  mut as int64: pc1 = ch1[cur_p]
                                                                  mut as int64: pc2 = ch2[cur_p]
                                                                  mut as int64: pc3 = ch3[cur_p]

                                                                  mut as int64: next_promo_k = 0
                                                                  mut as int64: right_k = 0
                                                                  mut as int64: r_c1 = 0
                                                                  mut as int64: r_c2 = 0

                                                                  route {
                                                                        promo_k < pk1 ==> {
                                                                              #L Caso A: promo_k < pk1 < pk2
                                                                              next_promo_k = pk1
                                                                              k1[cur_p] = promo_k
                                                                              k2[cur_p] = 0
                                                                              ch1[cur_p] = promo_left
                                                                              ch2[cur_p] = promo_right
                                                                              ch3[cur_p] = 0

                                                                              right_k = pk2
                                                                              r_c1 = pc2
                                                                              r_c2 = pc3
                                                                        }
                                                                        promo_k < pk2 ==> {
                                                                              #L Caso B: pk1 < promo_k < pk2
                                                                              next_promo_k = promo_k
                                                                              k1[cur_p] = pk1
                                                                              k2[cur_p] = 0
                                                                              ch1[cur_p] = pc1
                                                                              ch2[cur_p] = promo_left
                                                                              ch3[cur_p] = 0

                                                                              right_k = pk2
                                                                              r_c1 = promo_right
                                                                              r_c2 = pc3
                                                                        }
                                                                        _ ==> {
                                                                              #L Caso C: pk1 < pk2 < promo_k
                                                                              next_promo_k = pk2
                                                                              k1[cur_p] = pk1
                                                                              k2[cur_p] = 0
                                                                              ch1[cur_p] = pc1
                                                                              ch2[cur_p] = pc2
                                                                              ch3[cur_p] = 0

                                                                              right_k = promo_k
                                                                              r_c1 = promo_right
                                                                              r_c2 = promo_right
                                                                        }
                                                                  }
                                                                  num_keys[cur_p] = 1

                                                                  #L Cria novo no direito para o pai
                                                                  num_keys = listPushBack(num_keys, 1)
                                                                  k1 = listPushBack(k1, right_k)
                                                                  k2 = listPushBack(k2, 0)
                                                                  ch1 = listPushBack(ch1, r_c1)
                                                                  ch2 = listPushBack(ch2, r_c2)
                                                                  ch3 = listPushBack(ch3, 0)
                                                                  par = listPushBack(par, par[cur_p])
                                                                  is_leaf = listPushBack(is_leaf, false)
                                                                  mut as int64: new_p_sibling = listLength(num_keys)

                                                                  route {
                                                                        r_c1 != 0 ==> { par[r_c1] = new_p_sibling }
                                                                  }
                                                                  route {
                                                                        r_c2 != 0 ==> { par[r_c2] = new_p_sibling }
                                                                  }

                                                                  promo_k = next_promo_k
                                                                  promo_left = cur_p
                                                                  promo_right = new_p_sibling
                                                                  cur_p = par[cur_p]
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

      println("2. Arvore 2-3 construida com sucesso.")

      #L Busca por chaves existentes e ausentes
      mut as list of int64: busca_testes = [10, 25, 50, 99, 1]
      mut as list of bool: busca_esperada = [true, true, true, false, false]
      mut as bool: all_search_ok = true

      println("3. Testando operacao de busca na 2-3 Tree:")
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
                              mut as int64: pk1 = k1[curr]
                              route {
                                    qk == pk1 ==> {
                                          found = true
                                          searching = false
                                    }
                                    qk < pk1 ==> {
                                          curr = ch1[curr]
                                    }
                                    _ ==> {
                                          route {
                                                nk == 1 ==> {
                                                      curr = ch2[curr]
                                                }
                                                _ ==> {
                                                      mut as int64: pk2 = k2[curr]
                                                      route {
                                                            qk == pk2 ==> {
                                                                  found = true
                                                                  searching = false
                                                            }
                                                            qk < pk2 ==> {
                                                                  curr = ch2[curr]
                                                            }
                                                            _ ==> {
                                                                  curr = ch3[curr]
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

      #L 4. Validacao de percurso in-order iterativo (chaves ordenadas)
      println("4. Percurso in-order comprovando ordenacao estrita:")
      #L Pilha de nos para percurso:
      mut as list of int64: in_order = []
      mut as list of int64: stk_node = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      mut as list of int64: stk_state = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
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
                                          nk == 2 ==> {
                                                in_order = listPushBack(in_order, k2[u])
                                          }
                                    }
                              }
                              _ ==> {
                                    route {
                                          state == 0 ==> {
                                                #L Estado 0: empilha estado 1, depois filho 1
                                                s_top = s_top + 1
                                                stk_node[s_top] = u
                                                stk_state[s_top] = 1

                                                s_top = s_top + 1
                                                stk_node[s_top] = ch1[u]
                                                stk_state[s_top] = 0
                                          }
                                          state == 1 ==> {
                                                #L Visita k1, empilha estado 2, depois filho 2
                                                in_order = listPushBack(in_order, k1[u])

                                                s_top = s_top + 1
                                                stk_node[s_top] = u
                                                stk_state[s_top] = 2

                                                s_top = s_top + 1
                                                stk_node[s_top] = ch2[u]
                                                stk_state[s_top] = 0
                                          }
                                          state == 2 ==> {
                                                #L Se tiver k2, visita k2 e empilha filho 3
                                                route {
                                                      nk == 2 ==> {
                                                            in_order = listPushBack(in_order, k2[u])
                                                            s_top = s_top + 1
                                                            stk_node[s_top] = ch3[u]
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

      println("5. Verificacao geral da 2-3 Tree: " + all_search_ok)
      println("Concluido com Sucesso")
}
