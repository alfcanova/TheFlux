#L ============================================================================
#L Algoritmo: Second-Best MST (Segunda Melhor Arvore Geradora Minima)
#L Dominio: 03_graphs / Categoria: 8. Arvores geradoras minimas
#L Complexidade: O(V^2 + E log E) tempo | O(V + E) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosMSTSecondBestMST) {
      println("==================================================")
      println("  SciAlgo: Second-Best MST (2a Melhor Arvore)     ")
      println("==================================================")

      mut as int64: num_v = 6
      mut as int64: num_e = 9

      #L Arestas originais ordenadas por peso:
      #L 1: (2, 3, peso 1)
      #L 2: (1, 3, peso 2)
      #L 3: (4, 5, peso 2)
      #L 4: (5, 6, peso 3)
      #L 5: (1, 2, peso 4)
      #L 6: (2, 4, peso 5)
      #L 7: (4, 6, peso 6)
      #L 8: (3, 4, peso 8)
      #L 9: (3, 5, peso 10)
      mut as list of int64: edge_u = [2, 1, 4, 5, 1, 2, 4, 3, 3]
      mut as list of int64: edge_v = [3, 3, 5, 6, 2, 4, 6, 4, 5]
      mut as list of int64: edge_w = [1, 2, 2, 3, 4, 5, 6, 8, 10]

      println("1. Grafo com " + num_v + " vertices e " + num_e + " arestas ordenadas por peso.")

      #L ETAPA 1: Encontrar a MST otima via Kruskal
      mut as list of int64: parent = [1, 2, 3, 4, 5, 6]
      mut as list of bool: in_mst = [false, false, false, false, false, false, false, false, false]
      mut as int64: mst_weight = 0
      mut as int64: mst_count = 0

      mut as int64: ei = 1
      infinite (ei <= num_e and mst_count < (num_v - 1)) {
            mut as int64: u = edge_u[ei]
            mut as int64: v = edge_v[ei]
            mut as int64: w = edge_w[ei]

            mut as int64: ru = u
            infinite (parent[ru] != ru) {
                  ru = parent[ru]
            }

            mut as int64: rv = v
            infinite (parent[rv] != rv) {
                  rv = parent[rv]
            }

            route {
                  ru != rv ==> {
                        parent[ru] = rv
                        in_mst[ei] = true
                        mst_weight = mst_weight + w
                        mst_count = mst_count + 1
                  }
                  _ ==> {}
            }

            ei = ei + 1
      }

      println("2. MST Otima identificada:")
      println("   Peso da MST: " + mst_weight)

      #L ETAPA 2: Para cada aresta nao-MST e=(u, v), calcular o custo ao adicionar e
      #L e remover a aresta mais pesada no caminho da MST entre u e v.
      #L Custo(T') = W(MST) + w(e) - max_edge_on_path(u, v)

      mut as int64: second_best_weight = 999999
      mut as int64: best_in_edge = 0
      mut as int64: best_out_edge_weight = 0

      mut as int64: k = 1
      infinite (k <= num_e) {
            route {
                  not in_mst[k] ==> {
                        mut as int64: nu = edge_u[k]
                        mut as int64: nv = edge_v[k]
                        mut as int64: nw = edge_w[k]

                        #L Busca a aresta de peso maximo no caminho unico em T entre nu e nv (via BFS)
                        mut as list of bool: visited = [false, false, false, false, false, false]
                        mut as list of int64: q_node = [nu, 0, 0, 0, 0, 0]
                        mut as list of int64: q_maxw = [0, 0, 0, 0, 0, 0]
                        mut as int64: head = 1
                        mut as int64: tail = 1
                        visited[nu] = true
                        mut as int64: path_max_w = 0

                        infinite (head <= tail) {
                              mut as int64: curr = q_node[head]
                              mut as int64: cur_max = q_maxw[head]
                              head = head + 1

                              route {
                                    curr == nv ==> {
                                          path_max_w = cur_max
                                          break
                                    }
                                    _ ==> {}
                              }

                              #L Explora adjacentes na MST
                              mut as int64: m = 1
                              infinite (m <= num_e) {
                                    route {
                                          in_mst[m] ==> {
                                                mut as int64: nxt = 0
                                                route {
                                                      edge_u[m] == curr ==> {
                                                            nxt = edge_v[m]
                                                      }
                                                      edge_v[m] == curr ==> {
                                                            nxt = edge_u[m]
                                                      }
                                                      _ ==> {}
                                                }

                                                route {
                                                      nxt > 0 ==> {
                                                            route {
                                                                  not visited[nxt] ==> {
                                                                        visited[nxt] = true
                                                                        tail = tail + 1
                                                                        q_node[tail] = nxt

                                                                        mut as int64: ew = edge_w[m]
                                                                        mut as int64: nxt_max = cur_max
                                                                        route {
                                                                              ew > nxt_max ==> {
                                                                                    nxt_max = ew
                                                                              }
                                                                              _ ==> {}
                                                                        }
                                                                        q_maxw[tail] = nxt_max
                                                                  }
                                                                  _ ==> {}
                                                            }
                                                      }
                                                      _ ==> {}
                                                }
                                          }
                                          _ ==> {}
                                    }
                                    m = m + 1
                              }
                        }

                        #L Avalia o custo substituindo a aresta
                        route {
                              path_max_w > 0 ==> {
                                    mut as int64: cand_weight = mst_weight + nw - path_max_w
                                    println("   Testando aresta (" + nu + ", " + nv + ", peso " + nw + "): max_path = " + path_max_w + ", novo custo = " + cand_weight)

                                    route {
                                          cand_weight >= mst_weight and (cand_weight < second_best_weight) ==> {
                                                second_best_weight = cand_weight
                                                best_in_edge = k
                                                best_out_edge_weight = path_max_w
                                          }
                                          _ ==> {}
                                    }
                              }
                              _ ==> {}
                        }
                  }
                  _ ==> {}
            }
            k = k + 1
      }

      println("3. Resultado da Second-Best MST:")
      println("   Peso da MST Otima: " + mst_weight)
      println("   Peso da Segunda Melhor MST: " + second_best_weight)
      println("   Aresta inserida: (" + edge_u[best_in_edge] + ", " + edge_v[best_in_edge] + ", peso " + edge_w[best_in_edge] + ")")
      println("   Aresta removida de peso: " + best_out_edge_weight)

      #L Verificacao:
      #L MST otima = 13.
      #L Ao trocar (1, 3, peso 2) por (1, 2, peso 4), o custo sobe para 13 + 4 - 2 = 15.
      mut as bool: opt_ok = mst_weight == 13
      mut as bool: sec_ok = second_best_weight == 15
      mut as bool: valid_second = opt_ok and sec_ok
      println("4. Verificacao da Second-Best MST: " + valid_second)

      println("Concluido com Sucesso")
}
