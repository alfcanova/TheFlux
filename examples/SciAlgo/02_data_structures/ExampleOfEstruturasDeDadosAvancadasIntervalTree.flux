#L ============================================================================
#L Algoritmo: Interval Tree (Arvore de Intervalos com Max-High Augmentation)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados e algoritmos associados
#L Complexidade: Insercao O(log N) | Busca de Sobreposicao O(log N)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosAvancadasIntervalTree) {
      println("==================================================")
      println("  SciAlgo: Interval Tree (Busca de Sobreposicao)")
      println("==================================================")

      #L Representacao dos nos (1-based, 0 = NULL)
      mut as list of int64: int_low = [0]
      mut as list of int64: int_high = [0]
      mut as list of int64: int_max = [0]
      mut as list of int64: node_left = [0]
      mut as list of int64: node_right = [0]
      mut as list of int64: node_parent = [0]
      mut as int64: root = 0

      #L Intervalos a inserir:
      #L [15, 20], [10, 30], [17, 19], [5, 20], [12, 15], [30, 40]
      mut as list of int64: in_lows = [15, 10, 17, 5, 12, 30]
      mut as list of int64: in_highs = [20, 30, 19, 20, 15, 40]
      mut as int64: n_intervals = listLength(in_lows)

      println("1. Inserindo " + n_intervals + " intervalos na Interval Tree...")

      mut as int64: idx = 1
      infinite (idx <= n_intervals) {
            mut as int64: l = in_lows[idx]
            mut as int64: h = in_highs[idx]

            #L Aloca novo no
            int_low = listPushBack(int_low, l)
            int_high = listPushBack(int_high, h)
            int_max = listPushBack(int_max, h)
            node_left = listPushBack(node_left, 0)
            node_right = listPushBack(node_right, 0)
            node_parent = listPushBack(node_parent, 0)
            mut as int64: new_node = listLength(int_low)

            route {
                  root == 0 ==> {
                        root = new_node
                  }
                  _ ==> {
                        mut as int64: curr = root
                        infinite (true) {
                              #L Atualiza max do no corrente durante a descida
                              route {
                                    h > int_max[curr] ==> {
                                          int_max[curr] = h
                                    }
                              }

                              route {
                                    l < int_low[curr] ==> {
                                          route {
                                                node_left[curr] == 0 ==> {
                                                      node_left[curr] = new_node
                                                      node_parent[new_node] = curr
                                                      break
                                                }
                                                _ ==> { curr = node_left[curr] }
                                          }
                                    }
                                    _ ==> {
                                          route {
                                                node_right[curr] == 0 ==> {
                                                      node_right[curr] = new_node
                                                      node_parent[new_node] = curr
                                                      break
                                                }
                                                _ ==> { curr = node_right[curr] }
                                          }
                                    }
                              }
                        }
                  }
            }

            println("   Intervalo [" + l + ", " + h + "] inserido.")
            idx = idx + 1
      }

      #L 2. Consultas de Sobreposicao (Overlap Search)
      #L Dois intervalos [a, b] e [c, d] sobrepoem-se se: a <= d e c <= b
      println("2. Executando buscas de sobreposicao:")

      #L Consulta 1: [6, 7] -> deve sobrepor com [5, 20]
      mut as int64: q1_l = 6
      mut as int64: q1_h = 7
      mut as int64: res1_node = 0

      mut as int64: curr1 = root
      infinite (curr1 != 0) {
            #L Verifica se curr1 sobrepoe [q1_l, q1_h]
            route {
                  (int_low[curr1] <= q1_h) and (q1_l <= int_high[curr1]) ==> {
                        res1_node = curr1
                        break
                  }
            }

            #L Se filho esquerdo existe e seu max >= q1_l, sobreposicao pode estar a esquerda
            mut as int64: left_child = node_left[curr1]
            mut as bool: go_l1 = false
            route {
                  left_child != 0 ==> {
                        route {
                              int_max[left_child] >= q1_l ==> {
                                    go_l1 = true
                              }
                        }
                  }
            }

            route {
                  go_l1 == true ==> {
                        curr1 = left_child
                  }
                  _ ==> {
                        curr1 = node_right[curr1]
                  }
            }
      }
      println("   Query [6, 7] -> sobreposicao encontrada: [" + int_low[res1_node] + ", " + int_high[res1_node] + "]")

      #L Consulta 2: [21, 23] -> deve sobrepor com [10, 30]
      mut as int64: q2_l = 21
      mut as int64: q2_h = 23
      mut as int64: res2_node = 0

      mut as int64: curr2 = root
      infinite (curr2 != 0) {
            route {
                  (int_low[curr2] <= q2_h) and (q2_l <= int_high[curr2]) ==> {
                        res2_node = curr2
                        break
                  }
            }

            mut as int64: left_child2 = node_left[curr2]
            mut as bool: go_l2 = false
            route {
                  left_child2 != 0 ==> {
                        route {
                              int_max[left_child2] >= q2_l ==> {
                                    go_l2 = true
                              }
                        }
                  }
            }

            route {
                  go_l2 == true ==> {
                        curr2 = left_child2
                  }
                  _ ==> {
                        curr2 = node_right[curr2]
                  }
            }
      }
      println("   Query [21, 23] -> sobreposicao encontrada: [" + int_low[res2_node] + ", " + int_high[res2_node] + "]")

      #L Consulta 3: [45, 50] -> nao ha sobreposicao (esperado 0)
      mut as int64: q3_l = 45
      mut as int64: q3_h = 50
      mut as int64: res3_node = 0

      mut as int64: curr3 = root
      infinite (curr3 != 0) {
            route {
                  (int_low[curr3] <= q3_h) and (q3_l <= int_high[curr3]) ==> {
                        res3_node = curr3
                        break
                  }
            }

            mut as int64: left_child3 = node_left[curr3]
            mut as bool: go_l3 = false
            route {
                  left_child3 != 0 ==> {
                        route {
                              int_max[left_child3] >= q3_l ==> {
                                    go_l3 = true
                              }
                        }
                  }
            }

            route {
                  go_l3 == true ==> {
                        curr3 = left_child3
                  }
                  _ ==> {
                        curr3 = node_right[curr3]
                  }
            }
      }
      println("   Query [45, 50] (sem sobreposicao) -> resultado: " + res3_node)

      mut as bool: ok = (res1_node != 0) and (int_low[res1_node] <= 7) and (6 <= int_high[res1_node]) and (res2_node != 0) and (int_low[res2_node] <= 23) and (21 <= int_high[res2_node]) and (res3_node == 0)
      println("3. Verificacao geral da Interval Tree: " + ok)
      println("Concluido com Sucesso")
}
