#L ============================================================================
#L Algoritmo: Welsh-Powell (Coloracao Heuristica de Grafos por Grau)
#L Dominio: 03_graphs / Categoria: 2. Grafos (Adicoes Prioritarias)
#L Complexidade: O(V^2 + E) tempo | O(V + E) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosGeralWelshPowell) {
      println("==================================================")
      println("  SciAlgo: Welsh-Powell (Coloracao de Grafos)     ")
      println("==================================================")

      mut as int64: num_v = 6
      mut as int64: num_e = 8

      #L Grafo: dois blocos triangulares conectados
      #L Arestas: (1-2), (1-3), (2-3), (2-4), (3-5), (4-5), (4-6), (5-6)
      mut as list of int64: edge_u = [1, 1, 2, 2, 3, 4, 4, 5]
      mut as list of int64: edge_v = [2, 3, 3, 4, 5, 5, 6, 6]

      println("1. Grafo de Teste com " + num_v + " vertices e " + num_e + " arestas.")

      #L Matriz de adjacencia linearizada (6x6 = 36)
      mut as list of int64: adj = []
      mut as int64: c = 1
      infinite (c <= num_v * num_v) {
            adj = listPushBack(adj, 0)
            c = c + 1
      }

      #L Calcula os graus de cada vertice e preenche adjacencia
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

      println("   Graus dos vertices: " + deg)

      #L ETAPA 1: Ordenar os vertices em ordem DECRESCENTE de grau
      mut as list of int64: order = [1, 2, 3, 4, 5, 6]
      mut as int64: i = 1
      infinite (i <= num_v) {
            mut as int64: j = 1
            infinite (j <= num_v - i) {
                  mut as int64: v1 = order[j]
                  mut as int64: v2 = order[j + 1]
                  route {
                        deg[v1] < deg[v2] ==> {
                              order[j] = v2
                              order[j + 1] = v1
                        }
                        _ ==> {}
                  }
                  j = j + 1
            }
            i = i + 1
      }

      println("2. Ordem de processamento decrescente por grau:")
      println("   Vertices ordenados: " + order)

      #L ETAPA 2: Coloracao de Welsh-Powell
      #L color[v] = 0 (nao colorido) ou cor (1, 2, 3, ...)
      mut as list of int64: color = [0, 0, 0, 0, 0, 0]
      mut as int64: current_color = 1
      mut as int64: colored_count = 0

      infinite (colored_count < num_v) {
            mut as int64: idx = 1
            infinite (idx <= num_v) {
                  mut as int64: cand_v = order[idx]
                  route {
                        color[cand_v] == 0 ==> {
                              #L Verifica se cand_v tem vizinho ja colorido com current_color
                              mut as bool: has_neighbor_with_color = false
                              mut as int64: nbr = 1
                              infinite (nbr <= num_v) {
                                    route {
                                          adj[(cand_v - 1) * num_v + nbr] == 1 ==> {
                                                route {
                                                      color[nbr] == current_color ==> {
                                                            has_neighbor_with_color = true
                                                      }
                                                      _ ==> {}
                                                }
                                          }
                                          _ ==> {}
                                    }
                                    nbr = nbr + 1
                              }

                              route {
                                    not has_neighbor_with_color ==> {
                                          color[cand_v] = current_color
                                          colored_count = colored_count + 1
                                    }
                                    _ ==> {}
                              }
                        }
                        _ ==> {}
                  }
                  idx = idx + 1
            }

            route {
                  colored_count < num_v ==> {
                        current_color = current_color + 1
                  }
                  _ ==> {}
            }
      }

      println("3. Cores Atribuidas aos Vertices:")
      mut as int64: vi = 1
      infinite (vi <= num_v) {
            println("   Vertice " + vi + " -> Cor " + color[vi])
            vi = vi + 1
      }
      println("   Numero total de cores utilizadas: " + current_color)

      #L ETAPA 3: Verificacao de validade da coloracao
      #L Nenhuma aresta pode conectar dois vertices da mesma cor
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

      println("4. Verificacao de Adjacencias (Cores Conflitantes = 0): " + valid_coloring)

      mut as bool: welsh_powell_ok = valid_coloring and (current_color <= 4)
      println("5. Verificacao do Algoritmo Welsh-Powell: " + welsh_powell_ok)

      println("Concluido com Sucesso")
}
