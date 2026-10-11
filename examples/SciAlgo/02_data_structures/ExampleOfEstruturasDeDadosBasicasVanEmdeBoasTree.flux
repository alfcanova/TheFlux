#L ============================================================================
#L Algoritmo: Van Emde Boas Tree (Arvore vEB para Universo U = 16)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados (Adicoes Prioritarias)
#L Complexidade: O(log log U) por operacao | Espaco O(U)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosBasicasVanEmdeBoasTree) {
      println("==================================================")
      println("  SciAlgo: Van Emde Boas Tree (Universo U = 16)")
      println("==================================================")

      #L Universo U = 16 (chaves de 0 a 15)
      #L sqrt(U) = 4 clusters de tamanho 4
      #L Representacao estruturada em listas:
      #L vEB Raiz:
      #L   min_val, max_val (-1 = vazio)
      #L   summary: vetor booleano de 4 posicoes (indica se cluster c tem elementos)
      #L   cluster_min: vetor de 4 posicoes (-1 se vazio)
      #L   cluster_max: vetor de 4 posicoes (-1 se vazio)
      #L   cluster_bits: 4 clusters de 4 posicoes cada (16 elementos no total)

      mut as int64: u_size = 16
      mut as int64: root_min = -1
      mut as int64: root_max = -1

      #L Vetor sumario indicando se cluster c (0..3) possui elementos
      mut as list of int64: summary = [0, 0, 0, 0]

      #L Minimo e maximo de cada um dos 4 clusters
      mut as list of int64: c_min = [-1, -1, -1, -1]
      mut as list of int64: c_max = [-1, -1, -1, -1]

      #L Bits internos de presenca para os clusters: 4 x 4 = 16 posicoes (1-based: cluster*4 + low + 1)
      mut as list of int64: c_bits = [
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0
      ]

      mut as list of int64: chaves = [2, 3, 7, 10, 14]
      println("1. Inserindo chaves no universo [0, 15]: " + chaves)

      mut as int64: ki = 1
      mut as int64: n_k = listLength(chaves)

      infinite (ki <= n_k) {
            mut as int64: x = chaves[ki]

            #L Insercao na raiz vEB
            route {
                  root_min == -1 ==> {
                        root_min = x
                        root_max = x
                  }
                  _ ==> {
                        #L Se x < root_min, troca
                        route {
                              x < root_min ==> {
                                    mut as int64: t = root_min
                                    root_min = x
                                    x = t
                              }
                              _ ==> {
                              }
                        }

                        route {
                              x > root_max ==> {
                                    root_max = x
                              }
                              _ ==> {
                              }
                        }

                        #L Decomposicao high e low: h in [0, 3], l in [0, 3]
                        mut as int64: h = x /i 4
                        mut as int64: l = x /r 4
                        mut as int64: h_idx = h + 1
                        mut as int64: bit_idx = (h * 4) + l + 1

                        c_bits[bit_idx] = 1
                        summary[h_idx] = 1

                        route {
                              c_min[h_idx] == -1 ==> {
                                    c_min[h_idx] = l
                                    c_max[h_idx] = l
                              }
                              _ ==> {
                                    route {
                                          l < c_min[h_idx] ==> {
                                                c_min[h_idx] = l
                                          }
                                          _ ==> {
                                          }
                                    }
                                    route {
                                          l > c_max[h_idx] ==> {
                                                c_max[h_idx] = l
                                          }
                                          _ ==> {
                                          }
                                    }
                              }
                        }
                  }
            }
            ki = ki + 1
      }

      println("2. Minimo global (O(1)): " + root_min)
      println("3. Maximo global (O(1)): " + root_max)
      println("4. Vetor sumario de clusters ativos: " + summary)

      #L Consultas de Sucessor e Predecessor em O(log log U)
      #L Teste 1: Successor de 3 (deve ser 7)
      mut as int64: query_succ1 = 3
      mut as int64: res_succ1 = -1
      route {
            query_succ1 < root_min ==> {
                  res_succ1 = root_min
            }
            _ ==> {
                  mut as int64: h1 = query_succ1 /i 4
                  mut as int64: l1 = query_succ1 /r 4
                  mut as int64: h1_idx = h1 + 1

                  #L Verifica se ha sucessor dentro do proprio cluster h1
                  mut as bool: found_local1 = false
                  route {
                        c_max[h1_idx] != -1 ==> {
                              route {
                                    l1 < c_max[h1_idx] ==> {
                                          mut as int64: sl = l1 + 1
                                          infinite (sl <= 3 and not found_local1) {
                                                mut as int64: b_pos = (h1 * 4) + sl + 1
                                                route {
                                                      c_bits[b_pos] == 1 ==> {
                                                            res_succ1 = (h1 * 4) + sl
                                                            found_local1 = true
                                                      }
                                                      _ ==> {
                                                      }
                                                }
                                                sl = sl + 1
                                          }
                                    }
                                    _ ==> {
                                    }
                              }
                        }
                        _ ==> {
                        }
                  }

                  route {
                        not found_local1 ==> {
                              #L Busca proximo cluster no sumario
                              mut as int64: succ_cluster = h1 + 1
                              mut as bool: found_c = false
                              infinite (succ_cluster <= 3 and not found_c) {
                                    mut as int64: sc_idx = succ_cluster + 1
                                    route {
                                          summary[sc_idx] == 1 ==> {
                                                res_succ1 = (succ_cluster * 4) + c_min[sc_idx]
                                                found_c = true
                                          }
                                          _ ==> {
                                          }
                                    }
                                    succ_cluster = succ_cluster + 1
                              }
                        }
                        _ ==> {
                        }
                  }
            }
      }
      println("5. Successor(" + query_succ1 + "): " + res_succ1)

      #L Teste 2: Predecessor de 10 (deve ser 7)
      mut as int64: query_pred1 = 10
      mut as int64: res_pred1 = -1
      route {
            query_pred1 > root_max ==> {
                  res_pred1 = root_max
            }
            _ ==> {
                  mut as int64: hp = query_pred1 /i 4
                  mut as int64: lp = query_pred1 /r 4
                  mut as int64: hp_idx = hp + 1

                  mut as bool: found_local_p = false
                  route {
                        c_min[hp_idx] != -1 ==> {
                              route {
                                    lp > c_min[hp_idx] ==> {
                                          mut as int64: pl = lp - 1
                                          infinite (pl >= 0 and not found_local_p) {
                                                mut as int64: bp_pos = (hp * 4) + pl + 1
                                                route {
                                                      c_bits[bp_pos] == 1 ==> {
                                                            res_pred1 = (hp * 4) + pl
                                                            found_local_p = true
                                                      }
                                                      _ ==> {
                                                      }
                                                }
                                                pl = pl - 1
                                          }
                                    }
                                    _ ==> {
                                    }
                              }
                        }
                        _ ==> {
                        }
                  }

                  route {
                        not found_local_p ==> {
                              #L Busca cluster anterior no sumario
                              mut as int64: pred_cluster = hp - 1
                              mut as bool: found_cp = false
                              infinite (pred_cluster >= 0 and not found_cp) {
                                    mut as int64: pc_idx = pred_cluster + 1
                                    route {
                                          summary[pc_idx] == 1 ==> {
                                                res_pred1 = (pred_cluster * 4) + c_max[pc_idx]
                                                found_cp = true
                                          }
                                          _ ==> {
                                          }
                                    }
                                    pred_cluster = pred_cluster - 1
                              }

                              route {
                                    not found_cp ==> {
                                          route {
                                                root_min != -1 and query_pred1 > root_min ==> {
                                                      res_pred1 = root_min
                                                }
                                                _ ==> {
                                                }
                                          }
                                    }
                                    _ ==> {
                                    }
                              }
                        }
                        _ ==> {
                        }
                  }
            }
      }
      println("6. Predecessor(" + query_pred1 + "): " + res_pred1)
      println("Concluido com Sucesso")
}

