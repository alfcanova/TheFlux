#L ============================================================================
#L Algoritmo: Algoritmos Parametrizados (Arvore de Busca Delimitada para k-Vertex Cover)
#L Dominio: 03_graphs / Categoria: Teoria da computacao e complexidade
#L Complexidade: FPT O(2^k * (V + E)) tempo | O(k + V) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosComplexidadeParameterizedAlgorithms) {
      println("==================================================")
      println("  SciAlgo: Algoritmos Parametrizados (FPT k-VC)   ")
      println("==================================================")

      #L Grafo com V = 6 vertices e E = 7 arestas
      #L Vertices 1..6
      mut as int64: num_v = 6
      mut as list of int64: edge_u = [1, 1, 2, 3, 4, 5, 2]
      mut as list of int64: edge_v = [2, 3, 4, 5, 6, 6, 3]
      mut as int64: num_edges = listLength(edge_u)

      println("1. Grafo de Teste:")
      println("   Vertices: " + num_v + ", Arestas: " + num_edges)
      println("   Lista de Arestas: [(1,2), (1,3), (2,4), (3,5), (4,6), (5,6), (2,3)]")

      #L Funcao/Estrutura de busca iterativa usando pilha de estados para simular a arvore FPT:
      #L Cada estado mantem: (vertice_ramo_u, vertice_ramo_v, etapa_ramificacao, k_restante)
      #L Mas podemos implementar a busca recursiva ou pilha de escolhas com backtrack explicito.
      #L Vamos implementar uma busca por arvore de busca delimitada com profundidade maxima k.

      #L Teste 1: Buscar cobertura de tamanho k = 3 (viavel)
      println("2. Executando Arvore de Busca Delimitada para k = 3 (FPT)...")
      mut as int64: k_target1 = 3
      mut as list of int64: in_cover = [0, 0, 0, 0, 0, 0]
      mut as list of int64: best_cover = []
      mut as int64: nodes_explored = 0

      #L Pilha de estados para busca em arvore (DFS limitada em profundidade k):
      #L stack_choice: 1 para ramo U, 2 para ramo V
      #L stack_u, stack_v: vertices da aresta ramificada no nivel
      mut as list of int64: stack_choice = [0, 0, 0, 0, 0]
      mut as list of int64: stack_u = [0, 0, 0, 0, 0]
      mut as list of int64: stack_v = [0, 0, 0, 0, 0]
      mut as list of int64: stack_chosen_vert = [0, 0, 0, 0, 0]

      mut as bool: found_sol = false
      mut as int64: depth = 0

      infinite (depth >= 0 and not found_sol) {
            #L Verifica se todas as arestas estao cobertas
            mut as int64: unc_edge = 0
            mut as int64: ei = 1
            infinite (ei <= num_edges) {
                  mut as int64: u = edge_u[ei]
                  mut as int64: v = edge_v[ei]
                  route {
                        in_cover[u] == 0 and in_cover[v] == 0 ==> {
                              unc_edge = ei
                              break
                        }
                        _ ==> {}
                  }
                  ei = ei + 1
            }

            route {
                  unc_edge == 0 ==> {
                        #L Todas as arestas estao cobertas! Solucao encontrada
                        found_sol = true
                        mut as int64: vi = 1
                        infinite (vi <= num_v) {
                              route {
                                    in_cover[vi] == 1 ==> {
                                          best_cover = listPushBack(best_cover, vi)
                                    }
                                    _ ==> {}
                              }
                              vi = vi + 1
                        }
                        break
                  }
                  depth >= k_target1 ==> {
                        #L Limite do parametro atingido sem cobrir todas as arestas -> Retrocede (backtrack)
                        mut as bool: backtrack_done = false
                        infinite (depth > 0 and not backtrack_done) {
                              #L Desfaz escolha do nivel atual
                              mut as int64: last_vert = stack_chosen_vert[depth]
                              route {
                                    last_vert > 0 ==> {
                                          in_cover[last_vert] = 0
                                          stack_chosen_vert[depth] = 0
                                    }
                                    _ ==> {}
                              }

                              route {
                                    stack_choice[depth] == 1 ==> {
                                          #L Tentou ramo U, agora tenta ramo V no mesmo nivel
                                          stack_choice[depth] = 2
                                          mut as int64: v_cand = stack_v[depth]
                                          in_cover[v_cand] = 1
                                          stack_chosen_vert[depth] = v_cand
                                          nodes_explored = nodes_explored + 1
                                          backtrack_done = true
                                    }
                                    _ ==> {
                                          #L Ja tentou ambos os ramos, sobe mais um nivel
                                          stack_choice[depth] = 0
                                          depth = depth - 1
                                    }
                              }
                        }
                        route {
                              not backtrack_done ==> {
                                    depth = -1 #L Esgotou busca
                              }
                              _ ==> {}
                        }
                  }
                  _ ==> {
                        #L Ha aresta descoberta e profundidade < k_target
                        #L Avanca para profundidade depth + 1 com ramo 1 (escolhe U)
                        depth = depth + 1
                        nodes_explored = nodes_explored + 1
                        mut as int64: cand_u = edge_u[unc_edge]
                        mut as int64: cand_v = edge_v[unc_edge]
                        stack_u[depth] = cand_u
                        stack_v[depth] = cand_v
                        stack_choice[depth] = 1
                        in_cover[cand_u] = 1
                        stack_chosen_vert[depth] = cand_u
                  }
            }
      }

      println("   Solucao para k = 3 encontrada? " + found_sol)
      println("   Nos explorados na arvore de busca FPT: " + nodes_explored)
      println("   Vertices no Vertex Cover encontrado: " + best_cover)

      #L Teste 2: Buscar cobertura de tamanho k = 2 (inviavel para este grafo, que tem triangulos/ciclos)
      println("3. Executando Arvore de Busca Delimitada para k = 2 (deve ser inviavel)...")
      mut as int64: k_target2 = 2
      mut as list of int64: in_cover2 = [0, 0, 0, 0, 0, 0]
      mut as list of int64: stack_choice2 = [0, 0, 0, 0, 0]
      mut as list of int64: stack_u2 = [0, 0, 0, 0, 0]
      mut as list of int64: stack_v2 = [0, 0, 0, 0, 0]
      mut as list of int64: stack_chosen2 = [0, 0, 0, 0, 0]
      mut as bool: found_sol2 = false
      mut as int64: depth2 = 0
      mut as int64: nodes_explored2 = 0

      infinite (depth2 >= 0 and not found_sol2) {
            mut as int64: unc2 = 0
            mut as int64: ej = 1
            infinite (ej <= num_edges) {
                  mut as int64: u = edge_u[ej]
                  mut as int64: v = edge_v[ej]
                  route {
                        in_cover2[u] == 0 and in_cover2[v] == 0 ==> {
                              unc2 = ej
                              break
                        }
                        _ ==> {}
                  }
                  ej = ej + 1
            }

            route {
                  unc2 == 0 ==> {
                        found_sol2 = true
                        break
                  }
                  depth2 >= k_target2 ==> {
                        mut as bool: bt2 = false
                        infinite (depth2 > 0 and not bt2) {
                              mut as int64: lv = stack_chosen2[depth2]
                              route {
                                    lv > 0 ==> {
                                          in_cover2[lv] = 0
                                          stack_chosen2[depth2] = 0
                                    }
                                    _ ==> {}
                              }
                              route {
                                    stack_choice2[depth2] == 1 ==> {
                                          stack_choice2[depth2] = 2
                                          mut as int64: vc = stack_v2[depth2]
                                          in_cover2[vc] = 1
                                          stack_chosen2[depth2] = vc
                                          nodes_explored2 = nodes_explored2 + 1
                                          bt2 = true
                                    }
                                    _ ==> {
                                          stack_choice2[depth2] = 0
                                          depth2 = depth2 - 1
                                    }
                              }
                        }
                        route {
                              not bt2 ==> {
                                    depth2 = -1
                              }
                              _ ==> {}
                        }
                  }
                  _ ==> {
                        depth2 = depth2 + 1
                        nodes_explored2 = nodes_explored2 + 1
                        mut as int64: cu = edge_u[unc2]
                        mut as int64: cv = edge_v[unc2]
                        stack_u2[depth2] = cu
                        stack_v2[depth2] = cv
                        stack_choice2[depth2] = 1
                        in_cover2[cu] = 1
                        stack_chosen2[depth2] = cu
                  }
            }
      }

      println("   Solucao para k = 2 encontrada? " + found_sol2)
      println("   Nos explorados na arvore de busca para k = 2: " + nodes_explored2)

      #L Verificacao de corretude teórica FPT:
      #L O numero de nos explorados e <= 2^(k+1) - 1. Para k=3, 2^4 - 1 = 15.
      mut as bool: fpt_valid = found_sol and (not found_sol2) and (nodes_explored <= 15)
      println("4. Verificacao de Complexidade FPT e Corretude: " + fpt_valid)

      println("Concluido com Sucesso")
}
