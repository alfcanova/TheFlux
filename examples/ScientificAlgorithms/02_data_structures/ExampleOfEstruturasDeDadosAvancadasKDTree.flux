#L ============================================================================
#L Algoritmo: K-D Tree (2D K-Dimensional Tree & Nearest Neighbor Search)
#L Dominio: 02_data_structures / Categoria: Estruturas de dados e algoritmos associados
#L Complexidade: Construcao/Insercao O(N log N) | Busca NN O(log N) medio
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfEstruturasDeDadosAvancadasKDTree) {
      println("==================================================")
      println("  SciAlgo: 2D K-D Tree (Spatial Partitioning)")
      println("==================================================")

      #L Representacao dos nos da KD-Tree em listas paralelas (1-based, 0 = NULL)
      mut as list of int64: pt_x = [0]
      mut as list of int64: pt_y = [0]
      mut as list of int64: axis = [0] #L 0 = eixo X, 1 = eixo Y
      mut as list of int64: left = [0]
      mut as list of int64: right = [0]
      mut as int64: root = 0

      #L Pontos a inserir: (3, 6), (17, 15), (13, 15), (6, 12), (9, 1), (2, 7), (10, 19)
      mut as list of int64: in_x = [3, 17, 13, 6, 9, 2, 10]
      mut as list of int64: in_y = [6, 15, 15, 12, 1, 7, 19]
      mut as int64: n_points = listLength(in_x)
      println("1. Inserindo " + n_points + " pontos bidimensionais na KD-Tree...")

      mut as int64: pi = 1
      infinite (pi <= n_points) {
            mut as int64: cur_x = in_x[pi]
            mut as int64: cur_y = in_y[pi]

            #L Aloca novo no
            pt_x = listPushBack(pt_x, cur_x)
            pt_y = listPushBack(pt_y, cur_y)
            axis = listPushBack(axis, 0)
            left = listPushBack(left, 0)
            right = listPushBack(right, 0)
            mut as int64: new_node = listLength(pt_x) - 1

            route {
                  root == 0 ==> {
                        root = new_node
                        axis[new_node] = 0
                  }
                  _ ==> {
                        mut as int64: curr = root
                        infinite (true) {
                              mut as int64: cur_ax = axis[curr]
                              mut as bool: go_left = false

                              route {
                                    cur_ax == 0 ==> {
                                          route {
                                                cur_x < pt_x[curr] ==> { go_left = true }
                                          }
                                    }
                                    _ ==> {
                                          route {
                                                cur_y < pt_y[curr] ==> { go_left = true }
                                          }
                                    }
                              }

                              route {
                                    go_left == true ==> {
                                          route {
                                                left[curr] == 0 ==> {
                                                      left[curr] = new_node
                                                      #L Alterna eixo: se cur_ax == 0 entao 1, senao 0
                                                      axis[new_node] = 1 - cur_ax
                                                      break
                                                }
                                                _ ==> {
                                                      curr = left[curr]
                                                }
                                          }
                                    }
                                    _ ==> {
                                          route {
                                                right[curr] == 0 ==> {
                                                      right[curr] = new_node
                                                      axis[new_node] = 1 - cur_ax
                                                      break
                                                }
                                                _ ==> {
                                                      curr = right[curr]
                                                }
                                          }
                                    }
                              }
                        }
                  }
            }

            println("   Ponto (" + cur_x + ", " + cur_y + ") inserido.")
            pi = pi + 1
      }

      #L 2. Busca do Vizinho Mais Proximo (Nearest Neighbor Search)
      #L Teste 1: Ponto (10, 19) ja existente no conjunto -> distancia minima deve ser 0
      println("2. Busca NN para Q1 = (10, 19)...")
      mut as int64: q1_x = 10
      mut as int64: q1_y = 19
      mut as int64: best_d1 = 999999999
      mut as int64: best_node1 = 0

      #L Percurso com pilha explicita
      mut as list of int64: stack = [root]
      mut as int64: top = 1

      infinite (top > 0) {
            mut as int64: u = stack[top]
            top = top - 1

            mut as int64: dx = pt_x[u] - q1_x
            mut as int64: dy = pt_y[u] - q1_y
            mut as int64: dist = (dx * dx) + (dy * dy)

            route {
                  dist < best_d1 ==> {
                        best_d1 = dist
                        best_node1 = u
                  }
            }

            #L Eixo do no atual
            mut as int64: u_ax = axis[u]
            mut as int64: diff = 0
            route {
                  u_ax == 0 ==> { diff = q1_x - pt_x[u] }
                  _ ==> { diff = q1_y - pt_y[u] }
            }

            #L Explora ramos
            mut as int64: first_child = 0
            mut as int64: second_child = 0
            route {
                  diff < 0 ==> {
                        first_child = left[u]
                        second_child = right[u]
                  }
                  _ ==> {
                        first_child = right[u]
                        second_child = left[u]
                  }
            }

            route {
                  first_child != 0 ==> {
                        top = top + 1
                        route {
                              top > listLength(stack) ==> { stack = listPushBack(stack, first_child) }
                              _ ==> { stack[top] = first_child }
                        }
                  }
            }

            #L Poda: so explora o segundo se a distancia perpendicular for menor que o melhor
            route {
                  (second_child != 0) and ((diff * diff) < best_d1) ==> {
                        top = top + 1
                        route {
                              top > listLength(stack) ==> { stack = listPushBack(stack, second_child) }
                              _ ==> { stack[top] = second_child }
                        }
                  }
            }
      }

      println("   Vizinho mais proximo de (10, 19): (" + pt_x[best_node1] + ", " + pt_y[best_node1] + ") com dist^2 = " + best_d1)

      #L Teste 2: Consulta Q2 = (4, 7) -> mais proximo deve ser (3, 6) com dist^2 = (4-3)^2 + (7-6)^2 = 2
      println("3. Busca NN para Q2 = (4, 7)...")
      mut as int64: q2_x = 4
      mut as int64: q2_y = 7
      mut as int64: best_d2 = 999999999
      mut as int64: best_node2 = 0

      stack[1] = root
      top = 1

      infinite (top > 0) {
            mut as int64: u = stack[top]
            top = top - 1

            mut as int64: dx = pt_x[u] - q2_x
            mut as int64: dy = pt_y[u] - q2_y
            mut as int64: dist = (dx * dx) + (dy * dy)

            route {
                  dist < best_d2 ==> {
                        best_d2 = dist
                        best_node2 = u
                  }
            }

            mut as int64: u_ax = axis[u]
            mut as int64: diff = 0
            route {
                  u_ax == 0 ==> { diff = q2_x - pt_x[u] }
                  _ ==> { diff = q2_y - pt_y[u] }
            }

            mut as int64: first_child = 0
            mut as int64: second_child = 0
            route {
                  diff < 0 ==> {
                        first_child = left[u]
                        second_child = right[u]
                  }
                  _ ==> {
                        first_child = right[u]
                        second_child = left[u]
                  }
            }

            route {
                  first_child != 0 ==> {
                        top = top + 1
                        route {
                              top > listLength(stack) ==> { stack = listPushBack(stack, first_child) }
                              _ ==> { stack[top] = first_child }
                        }
                  }
            }

            route {
                  (second_child != 0) and ((diff * diff) < best_d2) ==> {
                        top = top + 1
                        route {
                              top > listLength(stack) ==> { stack = listPushBack(stack, second_child) }
                              _ ==> { stack[top] = second_child }
                        }
                  }
            }
      }

      println("   Vizinho mais proximo de (4, 7): (" + pt_x[best_node2] + ", " + pt_y[best_node2] + ") com dist^2 = " + best_d2)

      mut as bool: ok = (best_d1 == 0) and (pt_x[best_node1] == 10) and (pt_y[best_node1] == 19) and (best_d2 == 2) and (pt_x[best_node2] == 3) and (pt_y[best_node2] == 6)
      println("4. Verificacao geral da KD-Tree: " + ok)
      println("Concluido com Sucesso")
}
