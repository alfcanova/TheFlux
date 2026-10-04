#L ============================================================================
#L Algoritmo: Smoothsort (Heaps de Leonardo / Dijkstra 1981)
#L Domínio: 01_foundations / Categoria: 3. Ordenação
#L Complexidade: O(N log N) pior caso | O(N) melhor caso (adaptativo) | In-Place
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSortSmooth) {
      println("==================================================")
      println("  SciAlgo: Smoothsort (Heaps de Leonardo - Dijkstra)")
      println("==================================================")

      mut as list of int64: arr = [42, 17, 88, 55, 9, 23, 71, 3, 64, 30, 12, 95, 6, 50, 2, 80]
      mut as int64: n = listLength(arr)
      println("1. Vetor de entrada (N = 16): " + arr)

      #L Tabela de Números de Leonardo: LP[p + 1] corresponde a L(p)
      mut as list of int64: lp = [1, 1, 3, 5, 9, 15, 25, 41, 67, 109]

      #L Pilha de ordens das árvores da floresta de Leonardo
      mut as list of int64: trees = []
      mut as int64: num_trees = 0

      #L ====================================================================
      #L Fase 1: Construção da floresta de Leonardo
      #L ====================================================================
      mut as int64: i = 1
      infinite (i <= n) {
            mut as bool: can_merge = false
            route {
                  num_trees >= 2 ==> {
                        route {
                              trees[num_trees - 1] == (trees[num_trees] + 1) ==> {
                                    can_merge = true
                              }
                        }
                  }
            }

            mut as bool: has_order_one = false
            route {
                  num_trees >= 1 ==> {
                        route {
                              trees[num_trees] == 1 ==> {
                                    has_order_one = true
                              }
                        }
                  }
            }

            route {
                  can_merge ==> {
                        trees[num_trees - 1] = trees[num_trees - 1] + 1
                        num_trees = num_trees - 1
                  }
                  has_order_one ==> {
                        num_trees = num_trees + 1
                        route {
                              num_trees > listLength(trees) ==> {
                                    trees = listPushBack(trees, 0)
                              }
                              _ ==> {
                                    trees[num_trees] = 0
                              }
                        }
                  }
                  _ ==> {
                        num_trees = num_trees + 1
                        route {
                              num_trees > listLength(trees) ==> {
                                    trees = listPushBack(trees, 1)
                              }
                              _ ==> {
                                    trees[num_trees] = 1
                              }
                        }
                  }
            }

            #L Trinkle na árvore recém-adicionada
            mut as int64: r = i
            mut as int64: p = trees[num_trees]
            mut as int64: t_idx = num_trees

            infinite (t_idx > 1) {
                  mut as int64: step = lp[trees[t_idx] + 1]
                  mut as int64: prev_r = r - step
                  route {
                        arr[prev_r] <= arr[r] ==> {
                              break
                        }
                  }

                  mut as bool: can_swap = true
                  route {
                        p >= 2 ==> {
                              mut as int64: r2 = r - 1
                              mut as int64: r1 = r - 1 - lp[(p - 2) + 1]
                              route {
                                    arr[prev_r] < arr[r1] ==> {
                                          can_swap = false
                                    }
                                    arr[prev_r] < arr[r2] ==> {
                                          can_swap = false
                                    }
                              }
                        }
                  }

                  route {
                        can_swap ==> {
                              mut as int64: sw = arr[r]
                              arr[r] = arr[prev_r]
                              arr[prev_r] = sw
                              r = prev_r
                              t_idx = t_idx - 1
                              p = trees[t_idx]
                        }
                        _ ==> {
                              break
                        }
                  }
            }

            #L Sift-down dentro da subárvore de Leonardo
            infinite (p >= 2) {
                  mut as int64: r2 = r - 1
                  mut as int64: r1 = r - 1 - lp[(p - 2) + 1]
                  route {
                        (arr[r] >= arr[r1]) and (arr[r] >= arr[r2]) ==> {
                              break
                        }
                  }
                  route {
                        arr[r1] >= arr[r2] ==> {
                              mut as int64: sw = arr[r]
                              arr[r] = arr[r1]
                              arr[r1] = sw
                              r = r1
                              p = p - 1
                        }
                        _ ==> {
                              mut as int64: sw = arr[r]
                              arr[r] = arr[r2]
                              arr[r2] = sw
                              r = r2
                              p = p - 2
                        }
                  }
            }

            i = i + 1
      }
      println("2. Floresta de Leonardo construida com sucesso.")

      #L ====================================================================
      #L Fase 2: Desconstrução da floresta (extracao do maximo)
      #L ====================================================================
      mut as int64: cur_end = n
      infinite (cur_end >= 1) {
            mut as int64: cur_p = trees[num_trees]
            num_trees = num_trees - 1

            route {
                  cur_p >= 2 ==> {
                        #L Divide a raiz nos dois ramos filhos
                        #L Filho esquerdo: ordem cur_p - 1
                        num_trees = num_trees + 1
                        route {
                              num_trees > listLength(trees) ==> {
                                    trees = listPushBack(trees, cur_p - 1)
                              }
                              _ ==> {
                                    trees[num_trees] = cur_p - 1
                              }
                        }

                        #L Trinkle no filho esquerdo
                        mut as int64: r_l = cur_end - 1 - lp[(cur_p - 2) + 1]
                        mut as int64: p_l = trees[num_trees]
                        mut as int64: t_l = num_trees

                        infinite (t_l > 1) {
                              mut as int64: step_l = lp[trees[t_l] + 1]
                              mut as int64: prev_rl = r_l - step_l
                              route {
                                    arr[prev_rl] <= arr[r_l] ==> { break }
                              }
                              mut as bool: c_swap = true
                              route {
                                    p_l >= 2 ==> {
                                          mut as int64: r2 = r_l - 1
                                          mut as int64: r1 = r_l - 1 - lp[(p_l - 2) + 1]
                                          route {
                                                arr[prev_rl] < arr[r1] ==> {
                                                      c_swap = false
                                                }
                                                arr[prev_rl] < arr[r2] ==> {
                                                      c_swap = false
                                                }
                                          }
                                    }
                              }
                              route {
                                    c_swap ==> {
                                          mut as int64: sw = arr[r_l]
                                          arr[r_l] = arr[prev_rl]
                                          arr[prev_rl] = sw
                                          r_l = prev_rl
                                          t_l = t_l - 1
                                          p_l = trees[t_l]
                                    }
                                    _ ==> { break }
                              }
                        }
                        infinite (p_l >= 2) {
                              mut as int64: r2 = r_l - 1
                              mut as int64: r1 = r_l - 1 - lp[(p_l - 2) + 1]
                              route {
                                    (arr[r_l] >= arr[r1]) and (arr[r_l] >= arr[r2]) ==> { break }
                              }
                              route {
                                    arr[r1] >= arr[r2] ==> {
                                          mut as int64: sw = arr[r_l]
                                          arr[r_l] = arr[r1]
                                          arr[r1] = sw
                                          r_l = r1
                                          p_l = p_l - 1
                                    }
                                    _ ==> {
                                          mut as int64: sw = arr[r_l]
                                          arr[r_l] = arr[r2]
                                          arr[r2] = sw
                                          r_l = r2
                                          p_l = p_l - 2
                                    }
                              }
                        }

                        #L Filho direito: ordem cur_p - 2
                        num_trees = num_trees + 1
                        route {
                              num_trees > listLength(trees) ==> {
                                    trees = listPushBack(trees, cur_p - 2)
                              }
                              _ ==> {
                                    trees[num_trees] = cur_p - 2
                              }
                        }

                        #L Trinkle no filho direito
                        mut as int64: r_r = cur_end - 1
                        mut as int64: p_r = trees[num_trees]
                        mut as int64: t_r = num_trees

                        infinite (t_r > 1) {
                              mut as int64: step_r = lp[trees[t_r] + 1]
                              mut as int64: prev_rr = r_r - step_r
                              route {
                                    arr[prev_rr] <= arr[r_r] ==> { break }
                              }
                              mut as bool: c_swap_r = true
                              route {
                                    p_r >= 2 ==> {
                                          mut as int64: r2 = r_r - 1
                                          mut as int64: r1 = r_r - 1 - lp[(p_r - 2) + 1]
                                          route {
                                                arr[prev_rr] < arr[r1] ==> {
                                                      c_swap_r = false
                                                }
                                                arr[prev_rr] < arr[r2] ==> {
                                                      c_swap_r = false
                                                }
                                          }
                                    }
                              }
                              route {
                                    c_swap_r ==> {
                                          mut as int64: sw = arr[r_r]
                                          arr[r_r] = arr[prev_rr]
                                          arr[prev_rr] = sw
                                          r_r = prev_rr
                                          t_r = t_r - 1
                                          p_r = trees[t_r]
                                    }
                                    _ ==> { break }
                              }
                        }
                        infinite (p_r >= 2) {
                              mut as int64: r2 = r_r - 1
                              mut as int64: r1 = r_r - 1 - lp[(p_r - 2) + 1]
                              route {
                                    (arr[r_r] >= arr[r1]) and (arr[r_r] >= arr[r2]) ==> { break }
                              }
                              route {
                                    arr[r1] >= arr[r2] ==> {
                                          mut as int64: sw = arr[r_r]
                                          arr[r_r] = arr[r1]
                                          arr[r1] = sw
                                          r_r = r1
                                          p_r = p_r - 1
                                    }
                                    _ ==> {
                                          mut as int64: sw = arr[r_r]
                                          arr[r_r] = arr[r2]
                                          arr[r2] = sw
                                          r_r = r2
                                          p_r = p_r - 2
                                    }
                              }
                        }
                  }
            }

            cur_end = cur_end - 1
      }

      println("3. Vetor ordenado pelo Smoothsort: " + arr)

      #L Validação de corretude
      mut as bool: sorted_ok = true
      mut as int64: vi = 1
      infinite (vi < n) {
            route {
                  arr[vi] > arr[vi + 1] ==> {
                        sorted_ok = false
                        break
                  }
            }
            vi = vi + 1
      }
      println("4. Validacao de ordenacao: " + sorted_ok)
      println("==================================================")
}
