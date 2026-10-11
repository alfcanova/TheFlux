#L ============================================================================
#L Algoritmo: B+ Tree (Arvore B+ com Dados em Folhas e Encadeamento Sequencial)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados e algoritmos associados
#L Complexidade: Busca O(log N) | Insercao O(log N) | Varredura de Faixa O(K + log N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosAvancadasBPlusTree) {
      println("==================================================")
      println("  SciAlgo: B+ Tree (Folhas Encadeadas e Range Scan)")
      println("==================================================")

      #L Representacao dos nos da Arvore B+ (Ordem M = 4):
      #L Nos internos: armazenam chaves indexadoras e ponteiros de filhos
      #L Nos folhas: armazenam todas as chaves de dados e 'next_leaf' para varredura rapida
      mut as list of bool: is_leaf = []
      mut as list of int64: num_k = []
      mut as list of int64: k1 = []
      mut as list of int64: k2 = []
      mut as list of int64: k3 = []
      mut as list of int64: ch1 = []
      mut as list of int64: ch2 = []
      mut as list of int64: ch3 = []
      mut as list of int64: ch4 = []
      mut as list of int64: next_leaf = []
      mut as list of int64: par = []
      mut as int64: root = 0
      mut as int64: first_leaf = 0

      mut as list of int64: chaves = [5, 15, 25, 35, 45, 55, 20, 30, 40, 50]
      mut as int64: total_keys = listLength(chaves)

      println("1. Inserindo chaves na Arvore B+: " + chaves)

      mut as int64: ki = 1
      infinite (ki <= total_keys) {
            mut as int64: val = chaves[ki]

            route {
                  root == 0 ==> {
                        #L Cria primeiro no folha e raiz
                        is_leaf = listPushBack(is_leaf, true)
                        num_k = listPushBack(num_k, 1)
                        k1 = listPushBack(k1, val)
                        k2 = listPushBack(k2, 0)
                        k3 = listPushBack(k3, 0)
                        ch1 = listPushBack(ch1, 0)
                        ch2 = listPushBack(ch2, 0)
                        ch3 = listPushBack(ch3, 0)
                        ch4 = listPushBack(ch4, 0)
                        next_leaf = listPushBack(next_leaf, 0)
                        par = listPushBack(par, 0)
                        root = 1
                        first_leaf = 1
                  }
                  _ ==> {
                        #L 1. Desce ate a folha correspondente
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
                                    #L Folha cheia com 3 chaves -> divide a folha em duas (Split de Folha em B+)
                                    mut as list of int64: t4 = [k1[curr], k2[curr], k3[curr], val]
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

                                    #L Em B+, as folhas mantem TODAS as chaves!
                                    #L No esquerdo fica com t4[1], t4[2]
                                    #L No direito fica com t4[3], t4[4]
                                    #L A chave de separacao promovida para o pai e t4[3] (copiada, nao movida!)
                                    mut as int64: promo_key = t4[3]

                                    k1[curr] = t4[1]
                                    k2[curr] = t4[2]
                                    k3[curr] = 0
                                    num_k[curr] = 2

                                    #L Cria nova folha irma
                                    is_leaf = listPushBack(is_leaf, true)
                                    num_k = listPushBack(num_k, 2)
                                    k1 = listPushBack(k1, t4[3])
                                    k2 = listPushBack(k2, t4[4])
                                    k3 = listPushBack(k3, 0)
                                    ch1 = listPushBack(ch1, 0)
                                    ch2 = listPushBack(ch2, 0)
                                    ch3 = listPushBack(ch3, 0)
                                    ch4 = listPushBack(ch4, 0)
                                    next_leaf = listPushBack(next_leaf, next_leaf[curr])
                                    par = listPushBack(par, par[curr])
                                    mut as int64: new_leaf_id = listLength(num_k)

                                    #L Encadeia ponteiro next_leaf da folha atual para a nova folha
                                    next_leaf[curr] = new_leaf_id

                                    #L Propagacao ascendente para o pai
                                    mut as int64: cur_p = par[curr]
                                    mut as int64: p_key = promo_key
                                    mut as int64: p_right = new_leaf_id
                                    mut as bool: prop = true

                                    infinite (prop) {
                                          route {
                                                cur_p == 0 ==> {
                                                      #L Cria nova raiz interna
                                                      is_leaf = listPushBack(is_leaf, false)
                                                      num_k = listPushBack(num_k, 1)
                                                      k1 = listPushBack(k1, p_key)
                                                      k2 = listPushBack(k2, 0)
                                                      k3 = listPushBack(k3, 0)
                                                      ch1 = listPushBack(ch1, curr)
                                                      ch2 = listPushBack(ch2, p_right)
                                                      ch3 = listPushBack(ch3, 0)
                                                      ch4 = listPushBack(ch4, 0)
                                                      next_leaf = listPushBack(next_leaf, 0)
                                                      par = listPushBack(par, 0)
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

      println("2. Arvore B+ construida com sucesso.")

      #L Busca pontual na Arvore B+ (sempre desce ate uma folha)
      mut as list of int64: busca_testes = [5, 25, 45, 55, 99, 1]
      mut as list of bool: busca_esperada = [true, true, true, true, false, false]
      mut as bool: all_search_ok = true

      println("3. Testando operacao de busca pontual na Arvore B+:")
      mut as int64: bi = 1
      infinite (bi <= listLength(busca_testes)) {
            mut as int64: qk = busca_testes[bi]
            mut as int64: curr = root
            mut as bool: found = false

            #L Desce ate a folha
            mut as bool: navigating = true
            infinite (navigating) {
                  mut as bool: lf = is_leaf[curr]
                  route {
                        lf ==> { navigating = false }
                        _ ==> {
                              mut as int64: nk = num_k[curr]
                              route {
                                    nk == 1 ==> {
                                          route {
                                                qk < k1[curr] ==> { curr = ch1[curr] }
                                                _ ==> { curr = ch2[curr] }
                                          }
                                    }
                                    nk == 2 ==> {
                                          route {
                                                qk < k1[curr] ==> { curr = ch1[curr] }
                                                qk < k2[curr] ==> { curr = ch2[curr] }
                                                _ ==> { curr = ch3[curr] }
                                          }
                                    }
                                    _ ==> {
                                          route {
                                                qk < k1[curr] ==> { curr = ch1[curr] }
                                                qk < k2[curr] ==> { curr = ch2[curr] }
                                                qk < k3[curr] ==> { curr = ch3[curr] }
                                                _ ==> { curr = ch4[curr] }
                                          }
                                    }
                              }
                        }
                  }
            }

            #L Na folha, varre as chaves
            mut as int64: fnk = num_k[curr]
            route {
                  k1[curr] == qk ==> { found = true }
            }
            route {
                  fnk >= 2 ==> {
                        route {
                              k2[curr] == qk ==> { found = true }
                        }
                  }
            }
            route {
                  fnk == 3 ==> {
                        route {
                              k3[curr] == qk ==> { found = true }
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

      #L 4. Varredura de Faixa (Range Scan) usando a cadeia de folhas 'next_leaf'
      #L Consulta de faixa: [20 .. 45]
      println("4. Testando Consulta de Faixa (Range Scan) [20 .. 45] via cadeia 'next_leaf':")
      #L Localiza folha inicial para 20
      mut as int64: scan_leaf = root
      mut as bool: finding_leaf = true
      infinite (finding_leaf) {
            mut as bool: lf = is_leaf[scan_leaf]
            route {
                  lf ==> { finding_leaf = false }
                  _ ==> {
                        mut as int64: nk = num_k[scan_leaf]
                        route {
                              nk == 1 ==> {
                                    route {
                                          20 < k1[scan_leaf] ==> { scan_leaf = ch1[scan_leaf] }
                                          _ ==> { scan_leaf = ch2[scan_leaf] }
                                    }
                              }
                              nk == 2 ==> {
                                    route {
                                          20 < k1[scan_leaf] ==> { scan_leaf = ch1[scan_leaf] }
                                          20 < k2[scan_leaf] ==> { scan_leaf = ch2[scan_leaf] }
                                          _ ==> { scan_leaf = ch3[scan_leaf] }
                                    }
                              }
                              _ ==> {
                                    route {
                                          20 < k1[scan_leaf] ==> { scan_leaf = ch1[scan_leaf] }
                                          20 < k2[scan_leaf] ==> { scan_leaf = ch2[scan_leaf] }
                                          20 < k3[scan_leaf] ==> { scan_leaf = ch3[scan_leaf] }
                                          _ ==> { scan_leaf = ch4[scan_leaf] }
                                    }
                              }
                        }
                  }
            }
      }

      #L Percorre a cadeia de folhas coletando elementos no intervalo [20 .. 45]
      mut as list of int64: range_results = []
      mut as int64: cur_lf = scan_leaf
      mut as bool: scanning = true
      infinite (scanning) {
            route {
                  cur_lf == 0 ==> { scanning = false }
                  _ ==> {
                        mut as int64: lnk = num_k[cur_lf]
                        mut as int64: lk1 = k1[cur_lf]
                        route {
                              (lk1 >= 20) and (lk1 <= 45) ==> {
                                    range_results = listPushBack(range_results, lk1)
                              }
                        }
                        route {
                              lnk >= 2 ==> {
                                    mut as int64: lk2 = k2[cur_lf]
                                    route {
                                          (lk2 >= 20) and (lk2 <= 45) ==> {
                                                range_results = listPushBack(range_results, lk2)
                                          }
                                    }
                              }
                        }
                        route {
                              lnk == 3 ==> {
                                    mut as int64: lk3 = k3[cur_lf]
                                    route {
                                          (lk3 >= 20) and (lk3 <= 45) ==> {
                                                range_results = listPushBack(range_results, lk3)
                                          }
                                    }
                              }
                        }

                        #L Interrompe se a primeira chave da proxima folha exceder 45
                        mut as int64: nxt = next_leaf[cur_lf]
                        route {
                              nxt == 0 ==> { scanning = false }
                              _ ==> {
                                    route {
                                          k1[nxt] > 45 ==> { scanning = false }
                                          _ ==> { cur_lf = nxt }
                                    }
                              }
                        }
                  }
            }
      }

      println("   Resultado do Range Scan [20 .. 45]: " + range_results)
      mut as list of int64: range_exp = [20, 25, 30, 35, 40, 45]
      mut as bool: range_ok = (range_results == range_exp)
      route {
            not range_ok ==> { all_search_ok = false }
      }
      println("   Range Scan coincide com esperado: " + range_ok)

      #L 5. Percurso sequencial completo a partir de first_leaf
      println("5. Varredura linear completa de todas as folhas (first_leaf):")
      mut as list of int64: all_leaves_keys = []
      cur_lf = first_leaf
      infinite (cur_lf != 0) {
            mut as int64: lnk = num_k[cur_lf]
            all_leaves_keys = listPushBack(all_leaves_keys, k1[cur_lf])
            route {
                  lnk >= 2 ==> { all_leaves_keys = listPushBack(all_leaves_keys, k2[cur_lf]) }
            }
            route {
                  lnk == 3 ==> { all_leaves_keys = listPushBack(all_leaves_keys, k3[cur_lf]) }
            }
            cur_lf = next_leaf[cur_lf]
      }
      println("   Chaves sequenciais: " + all_leaves_keys)
      mut as bool: total_ok = (listLength(all_leaves_keys) == total_keys)
      route {
            not total_ok ==> { all_search_ok = false }
      }

      println("6. Verificacao geral da Arvore B+: " + all_search_ok)
      println("Concluido com Sucesso")
}
