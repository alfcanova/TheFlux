#L ============================================================================
#L Algoritmo: Sollin (Arvore Geradora Minima por Contracao de Super-Vertices)
#L Dominio: 03_graphs / Categoria: 8. Arvores geradoras minimas
#L Complexidade: O(E log V) tempo | O(V + E) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosMSTSollin) {
      println("==================================================")
      println("  SciAlgo: Sollin (MST por Contracao de Vertices) ")
      println("==================================================")

      #L O modelo de Sollin (1965) formaliza as fases de Boruvka sob a otica
      #L de contracao de super-vertices, onde componentes escolhem arestas
      #L incidentes minimas simultaneamente e contraem o grafo.

      mut as int64: num_v = 6
      mut as int64: num_e = 9

      mut as list of int64: edge_u = [1, 1, 2, 2, 3, 3, 4, 4, 5]
      mut as list of int64: edge_v = [2, 3, 3, 4, 4, 5, 5, 6, 6]
      mut as list of int64: edge_w = [4, 2, 1, 5, 8, 10, 2, 6, 3]

      println("1. Grafo com " + num_v + " vertices e " + num_e + " arestas.")

      #L Mapeamento de super-vertices (DSU de contracao)
      mut as list of int64: super_vertex = [1, 2, 3, 4, 5, 6]
      mut as int64: active_components = num_v

      mut as int64: mst_weight = 0
      mut as int64: mst_count = 0
      mut as list of int64: sollin_edges_u = []
      mut as list of int64: sollin_edges_v = []
      mut as list of int64: sollin_weights = []

      mut as int64: iteration = 1

      println("2. Iniciando Rodadas de Contracao de Sollin...")

      infinite (active_components > 1 and mst_count < (num_v - 1)) {
            println("   --- Rodada " + iteration + ": Super-vertices ativos = " + active_components + " ---")

            #L Vetor para a menor aresta incidente a cada super-vertice
            mut as list of int64: best_incident = [0, 0, 0, 0, 0, 0]

            #L Avalia todas as arestas
            mut as int64: ei = 1
            infinite (ei <= num_e) {
                  mut as int64: u = edge_u[ei]
                  mut as int64: v = edge_v[ei]
                  mut as int64: w = edge_w[ei]

                  #L Localiza o super-vertice representativo de u
                  mut as int64: su = u
                  infinite (super_vertex[su] != su) {
                        su = super_vertex[su]
                  }

                  #L Localiza o super-vertice representativo de v
                  mut as int64: sv = v
                  infinite (super_vertex[sv] != sv) {
                        sv = super_vertex[sv]
                  }

                  #L Aresta entre super-vertices distintos (nao eh auto-laco)
                  route {
                        su != sv ==> {
                              #L Atualiza para super-vertice su
                              mut as int64: cur_su = best_incident[su]
                              route {
                                    cur_su == 0 ==> {
                                          best_incident[su] = ei
                                    }
                                    _ ==> {
                                          route {
                                                w < edge_w[cur_su] ==> {
                                                      best_incident[su] = ei
                                                }
                                                _ ==> {}
                                          }
                                    }
                              }

                              #L Atualiza para super-vertice sv
                              mut as int64: cur_sv = best_incident[sv]
                              route {
                                    cur_sv == 0 ==> {
                                          best_incident[sv] = ei
                                    }
                                    _ ==> {
                                          route {
                                                w < edge_w[cur_sv] ==> {
                                                      best_incident[sv] = ei
                                                }
                                                _ ==> {}
                                          }
                                    }
                              }
                        }
                        _ ==> {}
                  }

                  ei = ei + 1
            }

            #L Contracao: unifica os super-vertices atraves das arestas identificadas
            mut as int64: s_idx = 1
            infinite (s_idx <= num_v) {
                  mut as int64: chosen_e = best_incident[s_idx]
                  route {
                        chosen_e > 0 ==> {
                              mut as int64: cu = edge_u[chosen_e]
                              mut as int64: cv = edge_v[chosen_e]
                              mut as int64: cw = edge_w[chosen_e]

                              mut as int64: r_u = cu
                              infinite (super_vertex[r_u] != r_u) {
                                    r_u = super_vertex[r_u]
                              }

                              mut as int64: r_v = cv
                              infinite (super_vertex[r_v] != r_v) {
                                    r_v = super_vertex[r_v]
                              }

                              route {
                                    r_u != r_v ==> {
                                          #L Contrai r_u em r_v
                                          super_vertex[r_u] = r_v
                                          active_components = active_components - 1

                                          mst_weight = mst_weight + cw
                                          mst_count = mst_count + 1
                                          sollin_edges_u = listPushBack(sollin_edges_u, cu)
                                          sollin_edges_v = listPushBack(sollin_edges_v, cv)
                                          sollin_weights = listPushBack(sollin_weights, cw)

                                          println("     Aresta (" + cu + ", " + cv + ", peso " + cw + ") selecionada. Contraindo super-vertices " + r_u + " e " + r_v + ".")
                                    }
                                    _ ==> {}
                              }
                        }
                        _ ==> {}
                  }
                  s_idx = s_idx + 1
            }

            iteration = iteration + 1
      }

      println("3. Resultado da MST de Sollin:")
      println("   Arestas selecionadas U: " + sollin_edges_u)
      println("   Arestas selecionadas V: " + sollin_edges_v)
      println("   Pesos: " + sollin_weights)
      println("   Total de arestas na MST: " + mst_count + " / " + (num_v - 1))
      println("   Peso Total da MST: " + mst_weight)

      #L Verificacao de corretude
      mut as bool: valid_count = mst_count == (num_v - 1)
      mut as bool: valid_weight = mst_weight == 13
      mut as bool: sollin_ok = valid_count and valid_weight
      println("4. Verificacao da MST de Sollin: " + sollin_ok)

      println("Concluido com Sucesso")
}
