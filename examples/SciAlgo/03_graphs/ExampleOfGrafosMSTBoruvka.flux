#L ============================================================================
#L Algoritmo: Boruvka (Arvore Geradora Minima em Fases Paralelizaveis)
#L Dominio: 03_graphs / Categoria: 8. Arvores geradoras minimas
#L Complexidade: O(E log V) tempo | O(V + E) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosMSTBoruvka) {
      println("==================================================")
      println("  SciAlgo: Boruvka (Arvore Geradora Minima - MST) ")
      println("==================================================")

      mut as int64: num_v = 6
      mut as int64: num_e = 9

      #L Arestas originais (u, v, peso):
      mut as list of int64: edge_u = [1, 1, 2, 2, 3, 3, 4, 4, 5]
      mut as list of int64: edge_v = [2, 3, 3, 4, 4, 5, 5, 6, 6]
      mut as list of int64: edge_w = [4, 2, 1, 5, 8, 10, 2, 6, 3]

      println("1. Grafo com " + num_v + " vertices e " + num_e + " arestas.")

      #L Estrutura DSU
      mut as list of int64: parent = [1, 2, 3, 4, 5, 6]
      mut as list of int64: rank = [0, 0, 0, 0, 0, 0]

      mut as int64: num_components = num_v
      mut as int64: mst_weight = 0
      mut as int64: mst_edges_count = 0
      mut as list of int64: mst_edges_u = []
      mut as list of int64: mst_edges_v = []
      mut as list of int64: mst_weights = []
      mut as int64: phases_count = 0

      println("2. Iniciando Fases do Algoritmo de Boruvka...")

      #L Executa ate que reste apenas 1 componente conexa
      infinite (num_components > 1 and mst_edges_count < (num_v - 1)) {
            phases_count = phases_count + 1

            #L Vetor cheapest_edge[c]: indice da aresta mais barata incidente ao componente c (1..num_v)
            #L 0 indica que nenhuma aresta foi encontrada ainda
            mut as list of int64: cheapest = [0, 0, 0, 0, 0, 0]

            #L Percorre todas as arestas para identificar a menor incidente a cada componente
            mut as int64: ei = 1
            infinite (ei <= num_e) {
                  mut as int64: u = edge_u[ei]
                  mut as int64: v = edge_v[ei]
                  mut as int64: w = edge_w[ei]

                  #L Find(u)
                  mut as int64: ru = u
                  infinite (parent[ru] != ru) {
                        ru = parent[ru]
                  }

                  #L Find(v)
                  mut as int64: rv = v
                  infinite (parent[rv] != rv) {
                        rv = parent[rv]
                  }

                  route {
                        ru != rv ==> {
                              #L Verifica se ei e mais barata para o componente ru
                              mut as int64: cur_ch_u = cheapest[ru]
                              route {
                                    cur_ch_u == 0 ==> {
                                          cheapest[ru] = ei
                                    }
                                    _ ==> {
                                          route {
                                                w < edge_w[cur_ch_u] ==> {
                                                      cheapest[ru] = ei
                                                }
                                                _ ==> {}
                                          }
                                    }
                              }

                              #L Verifica se ei e mais barata para o componente rv
                              mut as int64: cur_ch_v = cheapest[rv]
                              route {
                                    cur_ch_v == 0 ==> {
                                          cheapest[rv] = ei
                                    }
                                    _ ==> {
                                          route {
                                                w < edge_w[cur_ch_v] ==> {
                                                      cheapest[rv] = ei
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

            #L Adiciona as arestas identificadas e une os componentes
            mut as int64: ci = 1
            infinite (ci <= num_v) {
                  mut as int64: ch_edge = cheapest[ci]
                  route {
                        ch_edge > 0 ==> {
                              mut as int64: cu = edge_u[ch_edge]
                              mut as int64: cv = edge_v[ch_edge]
                              mut as int64: cw = edge_w[ch_edge]

                              #L Find(cu)
                              mut as int64: set_u = cu
                              infinite (parent[set_u] != set_u) {
                                    set_u = parent[set_u]
                              }

                              #L Find(cv)
                              mut as int64: set_v = cv
                              infinite (parent[set_v] != set_v) {
                                    set_v = parent[set_v]
                              }

                              route {
                                    set_u != set_v ==> {
                                          #L Union
                                          route {
                                                rank[set_u] < rank[set_v] ==> {
                                                      parent[set_u] = set_v
                                                }
                                                rank[set_u] > rank[set_v] ==> {
                                                      parent[set_v] = set_u
                                                }
                                                _ ==> {
                                                      parent[set_v] = set_u
                                                      rank[set_u] = rank[set_u] + 1
                                                }
                                          }

                                          mst_weight = mst_weight + cw
                                          mst_edges_count = mst_edges_count + 1
                                          mst_edges_u = listPushBack(mst_edges_u, cu)
                                          mst_edges_v = listPushBack(mst_edges_v, cv)
                                          mst_weights = listPushBack(mst_weights, cw)
                                          num_components = num_components - 1
                                    }
                                    _ ==> {}
                              }
                        }
                        _ ==> {}
                  }
                  ci = ci + 1
            }
      }

      println("3. Resultado da MST de Boruvka:")
      println("   Fases executadas: " + phases_count + " (limitado por ceil(log2 V) = 3)")
      println("   Arestas selecionadas U: " + mst_edges_u)
      println("   Arestas selecionadas V: " + mst_edges_v)
      println("   Pesos: " + mst_weights)
      println("   Numero de arestas na MST: " + mst_edges_count + " / " + (num_v - 1))
      println("   Peso Total da MST: " + mst_weight)

      #L Verificacao de corretude
      mut as bool: valid_count = mst_edges_count == (num_v - 1)
      mut as bool: valid_weight = mst_weight == 13
      mut as bool: boruvka_ok = valid_count and valid_weight
      println("4. Verificacao da MST de Boruvka: " + boruvka_ok)

      println("Concluido com Sucesso")
}
