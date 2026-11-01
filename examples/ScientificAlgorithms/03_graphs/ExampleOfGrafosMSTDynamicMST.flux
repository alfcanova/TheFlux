#L ============================================================================
#L Algoritmo: Dynamic MST (Manutencao On-line de Arvore Geradora Minima)
#L Dominio: 03_graphs / Categoria: 8. Arvores geradoras minimas
#L Complexidade: O(V) por insercao de aresta / O(log V) com Link-Cut Trees
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosMSTDynamicMST) {
      println("==================================================")
      println("  SciAlgo: Dynamic MST (Manutencao de Arestas)    ")
      println("==================================================")

      #L Grafo dinâmico com V = 5 vertices.
      #L Estado inicial: MST formada pelas arestas (linha 1-2-3-4-5)
      #L Aresta 1: (1, 2, peso 5)
      #L Aresta 2: (2, 3, peso 7)
      #L Aresta 3: (3, 4, peso 6)
      #L Aresta 4: (4, 5, peso 4)
      mut as int64: num_v = 5
      mut as list of int64: mst_u = [1, 2, 3, 4]
      mut as list of int64: mst_v = [2, 3, 4, 5]
      mut as list of int64: mst_w = [5, 7, 6, 4]

      mut as int64: current_mst_weight = 5 + 7 + 6 + 4
      println("1. MST Inicial:")
      println("   Vertices: " + num_v + ", Arestas: 4")
      println("   Extremos U: " + mst_u)
      println("   Extremos V: " + mst_v)
      println("   Pesos: " + mst_w)
      println("   Peso Total Inicial da MST: " + current_mst_weight)

      #L OPERACAO DINAMICA 1: Inserir aresta candidata e1 = (1, 3, peso 9)
      #L O caminho em T entre 1 e 3 tem as arestas (1-2: 5) e (2-3: 7).
      #L A aresta maxima no caminho e (2-3) de peso 7.
      #L Como w(e1) = 9 > 7, a aresta candidata eh mais cara que todo o ciclo -> Rejeitada!
      println("2. Operacao Dinamica 1: Inserir Aresta (1, 3, peso 9)...")
      mut as int64: cand1_u = 1
      mut as int64: cand1_v = 3
      mut as int64: cand1_w = 9

      #L Busca no caminho da MST entre 1 e 3 via BFS
      mut as list of bool: vis1 = [false, false, false, false, false]
      mut as list of int64: q_node1 = [cand1_u, 0, 0, 0, 0]
      mut as list of int64: q_max1 = [0, 0, 0, 0, 0]
      mut as list of int64: q_edge_idx1 = [0, 0, 0, 0, 0]
      mut as int64: head1 = 1
      mut as int64: tail1 = 1
      vis1[cand1_u] = true
      mut as int64: path_max1 = 0
      mut as int64: path_max_edge1 = 0

      infinite (head1 <= tail1) {
            mut as int64: curr = q_node1[head1]
            mut as int64: c_max = q_max1[head1]
            mut as int64: c_eidx = q_edge_idx1[head1]
            head1 = head1 + 1

            route {
                  curr == cand1_v ==> {
                        path_max1 = c_max
                        path_max_edge1 = c_eidx
                        break
                  }
                  _ ==> {}
            }

            mut as int64: i = 1
            infinite (i <= 4) {
                  mut as int64: nxt = 0
                  route {
                        mst_u[i] == curr ==> {
                              nxt = mst_v[i]
                        }
                        mst_v[i] == curr ==> {
                              nxt = mst_u[i]
                        }
                        _ ==> {}
                  }

                  route {
                        nxt > 0 ==> {
                              route {
                                    not vis1[nxt] ==> {
                                          vis1[nxt] = true
                                          tail1 = tail1 + 1
                                          q_node1[tail1] = nxt
                                          mut as int64: ew = mst_w[i]
                                          route {
                                                ew > c_max ==> {
                                                      q_max1[tail1] = ew
                                                      q_edge_idx1[tail1] = i
                                                }
                                                _ ==> {
                                                      q_max1[tail1] = c_max
                                                      q_edge_idx1[tail1] = c_eidx
                                                }
                                          }
                                    }
                                    _ ==> {}
                              }
                        }
                        _ ==> {}
                  }
                  i = i + 1
            }
      }

      mut as bool: op1_accepted = false
      route {
            cand1_w < path_max1 ==> {
                  op1_accepted = true
            }
            _ ==> {}
      }

      println("   Aresta maxima no caminho: peso " + path_max1)
      println("   Nova aresta aceita na MST? " + op1_accepted)
      println("   Peso da MST apos operacao 1: " + current_mst_weight)

      #L OPERACAO DINAMICA 2: Inserir atalho e2 = (2, 4, peso 3)
      #L O caminho em T entre 2 e 4 tem as arestas (2-3: 7) e (3-4: 6).
      #L A aresta maxima no caminho e (2-3) de peso 7.
      #L Como w(e2) = 3 < 7, ela e estritamente melhor!
      #L Removemos a aresta de peso 7 e inserimos e2.
      println("3. Operacao Dinamica 2: Inserir Atalho (2, 4, peso 3)...")
      mut as int64: cand2_u = 2
      mut as int64: cand2_v = 4
      mut as int64: cand2_w = 3

      mut as list of bool: vis2 = [false, false, false, false, false]
      mut as list of int64: q_node2 = [cand2_u, 0, 0, 0, 0]
      mut as list of int64: q_max2 = [0, 0, 0, 0, 0]
      mut as list of int64: q_edge_idx2 = [0, 0, 0, 0, 0]
      mut as int64: head2 = 1
      mut as int64: tail2 = 1
      vis2[cand2_u] = true
      mut as int64: path_max2 = 0
      mut as int64: path_max_edge2 = 0

      infinite (head2 <= tail2) {
            mut as int64: curr2 = q_node2[head2]
            mut as int64: c_max2 = q_max2[head2]
            mut as int64: c_eidx2 = q_edge_idx2[head2]
            head2 = head2 + 1

            route {
                  curr2 == cand2_v ==> {
                        path_max2 = c_max2
                        path_max_edge2 = c_eidx2
                        break
                  }
                  _ ==> {}
            }

            mut as int64: j = 1
            infinite (j <= 4) {
                  mut as int64: nxt2 = 0
                  route {
                        mst_u[j] == curr2 ==> {
                              nxt2 = mst_v[j]
                        }
                        mst_v[j] == curr2 ==> {
                              nxt2 = mst_u[j]
                        }
                        _ ==> {}
                  }

                  route {
                        nxt2 > 0 ==> {
                              route {
                                    not vis2[nxt2] ==> {
                                          vis2[nxt2] = true
                                          tail2 = tail2 + 1
                                          q_node2[tail2] = nxt2
                                          mut as int64: ew2 = mst_w[j]
                                          route {
                                                ew2 > c_max2 ==> {
                                                      q_max2[tail2] = ew2
                                                      q_edge_idx2[tail2] = j
                                                }
                                                _ ==> {
                                                      q_max2[tail2] = c_max2
                                                      q_edge_idx2[tail2] = c_eidx2
                                                }
                                          }
                                    }
                                    _ ==> {}
                              }
                        }
                        _ ==> {}
                  }
                  j = j + 1
            }
      }

      mut as bool: op2_accepted = false
      route {
            cand2_w < path_max2 ==> {
                  op2_accepted = true
                  #L Substitui a aresta no vetor
                  current_mst_weight = current_mst_weight - path_max2 + cand2_w
                  mst_u[path_max_edge2] = cand2_u
                  mst_v[path_max_edge2] = cand2_v
                  mst_w[path_max_edge2] = cand2_w
            }
            _ ==> {}
      }

      println("   Aresta maxima no caminho substituida: peso " + path_max2)
      println("   Nova aresta aceita na MST? " + op2_accepted)
      println("   Novo Peso Total da MST: " + current_mst_weight)
      println("   Novos Pesos das Arestas da MST: " + mst_w)

      #L Verificacao:
      #L Inicial = 22, Apos op1 = 22 (rejeitada), Apos op2 = 18 (22 - 7 + 3 = 18)
      mut as bool: dynamic_mst_ok = (not op1_accepted) and op2_accepted and (current_mst_weight == 18)
      println("4. Verificacao da Dynamic MST: " + dynamic_mst_ok)

      println("Concluido com Sucesso")
}
