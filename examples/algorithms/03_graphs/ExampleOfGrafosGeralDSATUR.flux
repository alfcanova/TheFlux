#L ============================================================================
#L Algoritmo: DSATUR (Degree of Saturation Graph Coloring - Brelaz 1979)
#L Dominio: 03_graphs / Categoria: 2. Grafos (Adicoes Prioritarias)
#L Complexidade: O(V^2) tempo | O(V + E) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosGeralDSATUR) {
      println("==================================================")
      println("  SciAlgo: DSATUR (Coloracao por Saturacao)       ")
      println("==================================================")

      mut as int64: num_v = 6
      mut as int64: num_e = 8

      #L Grafo com 6 vertices e 8 arestas:
      #L (1-2), (1-3), (2-3), (2-4), (3-5), (4-5), (4-6), (5-6)
      mut as list of int64: edge_u = [1, 1, 2, 2, 3, 4, 4, 5]
      mut as list of int64: edge_v = [2, 3, 3, 4, 5, 5, 6, 6]

      println("1. Grafo com " + num_v + " vertices e " + num_e + " arestas.")

      #L Matriz de adjacencia
      mut as list of int64: adj = []
      mut as int64: c = 1
      infinite (c <= num_v * num_v) {
            adj = listPushBack(adj, 0)
            c = c + 1
      }

      mut as list of int64: deg = [0, 0, 0, 0, 0, 0]
      mut as int64: ei = 1
      infinite (ei <= num_e) {
            mut as int64: u = edge_u[ei]
            mut as int64: v = edge_v[ei]
            deg[u] = deg[u] + 1
            deg[v] = deg[v] + 1
            adj[(u - 1) * num_v + v] = 1
            adj[(v - 1) * num_v + u] = 1
            ei = ei + 1
      }

      #L color[v] guarda a cor atribuida a v (0 se nao colorido)
      mut as list of int64: color = [0, 0, 0, 0, 0, 0]
      mut as int64: colored_count = 0
      mut as int64: max_color_used = 0

      println("2. Executando Algoritmo DSATUR...")

      infinite (colored_count < num_v) {
            #L Calcula grau de saturacao para cada vertice nao colorido:
            #L sat[v] = numero de cores distintas presentes em vizinhos ja coloridos
            mut as int64: best_v = 0
            mut as int64: max_sat = -1
            mut as int64: max_deg = -1

            mut as int64: vi = 1
            infinite (vi <= num_v) {
                  route {
                        color[vi] == 0 ==> {
                              #L Conta cores unicas em vizinhos de vi
                              #L Vetor de cores vistas para vi (tamanho num_v + 1)
                              mut as list of bool: seen_color = [false, false, false, false, false, false, false]
                              mut as int64: cur_sat = 0

                              mut as int64: nbr = 1
                              infinite (nbr <= num_v) {
                                    route {
                                          adj[(vi - 1) * num_v + nbr] == 1 ==> {
                                                mut as int64: nbr_c = color[nbr]
                                                route {
                                                      nbr_c > 0 ==> {
                                                            route {
                                                                  not seen_color[nbr_c] ==> {
                                                                        seen_color[nbr_c] = true
                                                                        cur_sat = cur_sat + 1
                                                                  }
                                                                  _ ==> {}
                                                            }
                                                      }
                                                      _ ==> {}
                                                }
                                          }
                                          _ ==> {}
                                    }
                                    nbr = nbr + 1
                              }

                              #L Criterio de selecao DSATUR: maior saturacao, desempate por maior grau
                              mut as bool: take = false
                              route {
                                    cur_sat > max_sat ==> {
                                          take = true
                                    }
                                    cur_sat == max_sat ==> {
                                          route {
                                                deg[vi] > max_deg ==> {
                                                      take = true
                                                }
                                                _ ==> {}
                                          }
                                    }
                                    _ ==> {}
                              }

                              route {
                                    take ==> {
                                          max_sat = cur_sat
                                          max_deg = deg[vi]
                                          best_v = vi
                                    }
                                    _ ==> {}
                              }
                        }
                        _ ==> {}
                  }
                  vi = vi + 1
            }

            #L Atribui ao vertice escolhido a menor cor valida disponivel
            mut as list of bool: neighbor_colors = [false, false, false, false, false, false, false]
            mut as int64: k = 1
            infinite (k <= num_v) {
                  route {
                        adj[(best_v - 1) * num_v + k] == 1 ==> {
                              mut as int64: kc = color[k]
                              route {
                                    kc > 0 ==> {
                                          neighbor_colors[kc] = true
                                    }
                                    _ ==> {}
                              }
                        }
                        _ ==> {}
                  }
                  k = k + 1
            }

            mut as int64: assigned_color = 1
            infinite (assigned_color <= num_v) {
                  route {
                        not neighbor_colors[assigned_color] ==> {
                              break
                        }
                        _ ==> {}
                  }
                  assigned_color = assigned_color + 1
            }

            color[best_v] = assigned_color
            colored_count = colored_count + 1

            route {
                  assigned_color > max_color_used ==> {
                        max_color_used = assigned_color
                  }
                  _ ==> {}
            }

            println("   Passo #" + colored_count + ": Vertice " + best_v + " (sat=" + max_sat + ") colorido com Cor " + assigned_color)
      }

      println("3. Cores Finais Atribuidas pelo DSATUR:")
      mut as int64: v_idx = 1
      infinite (v_idx <= num_v) {
            println("   Vertice " + v_idx + " -> Cor " + color[v_idx])
            v_idx = v_idx + 1
      }
      println("   Total de cores utilizadas: " + max_color_used)

      #L Verificacao de validade da coloracao
      mut as bool: valid_coloring = true
      mut as int64: ej = 1
      infinite (ej <= num_e) {
            mut as int64: cu = edge_u[ej]
            mut as int64: cv = edge_v[ej]
            route {
                  color[cu] == color[cv] ==> {
                        valid_coloring = false
                  }
                  _ ==> {}
            }
            ej = ej + 1
      }

      println("4. Verificacao de Arestas sem Conflito: " + valid_coloring)

      mut as bool: dsatur_ok = valid_coloring and (max_color_used <= 4)
      println("5. Verificacao do Algoritmo DSATUR: " + dsatur_ok)

      println("Concluido com Sucesso")
}
