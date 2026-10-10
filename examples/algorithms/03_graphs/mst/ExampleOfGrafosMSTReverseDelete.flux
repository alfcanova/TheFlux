#L ============================================================================
#L Algoritmo: Reverse-Delete (Arvore Geradora Minima por Remocao de Ciclos)
#L Dominio: 03_graphs / Categoria: 8. Arvores geradoras minimas
#L Complexidade: O(E log E + E * (V + E)) tempo | O(V + E) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosMSTReverseDelete) {
      println("==================================================")
      println("  SciAlgo: Reverse-Delete (MST por Eliminacao)    ")
      println("==================================================")

      mut as int64: num_v = 6
      mut as int64: num_e = 9

      #L Arestas originais (u, v, peso):
      mut as list of int64: edge_u = [1, 1, 2, 2, 3, 3, 4, 4, 5]
      mut as list of int64: edge_v = [2, 3, 3, 4, 4, 5, 5, 6, 6]
      mut as list of int64: edge_w = [4, 2, 1, 5, 8, 10, 2, 6, 3]

      println("1. Grafo inicial com " + num_v + " vertices e " + num_e + " arestas.")

      #L Ordena as arestas em ordem DECRESCENTE de peso
      mut as int64: i = 1
      infinite (i <= num_e) {
            mut as int64: j = 1
            infinite (j <= num_e - i) {
                  route {
                        edge_w[j] < edge_w[j + 1] ==> {
                              mut as int64: tw = edge_w[j]
                              edge_w[j] = edge_w[j + 1]
                              edge_w[j + 1] = tw

                              mut as int64: tu = edge_u[j]
                              edge_u[j] = edge_u[j + 1]
                              edge_u[j + 1] = tu

                              mut as int64: tv = edge_v[j]
                              edge_v[j] = edge_v[j + 1]
                              edge_v[j + 1] = tv
                        }
                        _ ==> {}
                  }
                  j = j + 1
            }
            i = i + 1
      }

      println("2. Arestas ordenadas em ordem decrescente de peso:")
      println("   Pesos: " + edge_w)

      #L edge_in_graph[k] indica se a aresta k ainda esta no grafo
      mut as list of bool: edge_in_graph = [true, true, true, true, true, true, true, true, true]
      mut as int64: edges_remaining = num_e

      println("3. Executando Algoritmo Reverse-Delete...")

      #L Itera sobre as arestas da mais pesada para a mais leve
      mut as int64: ei = 1
      infinite (ei <= num_e and edges_remaining > (num_v - 1)) {
            mut as int64: u = edge_u[ei]
            mut as int64: v = edge_v[ei]
            mut as int64: w = edge_w[ei]

            #L Remove temporariamente a aresta ei
            edge_in_graph[ei] = false

            #L BFS para verificar se u ainda alcanca v sem a aresta ei
            mut as list of bool: visited = [false, false, false, false, false, false]
            mut as list of int64: queue = [u, 0, 0, 0, 0, 0]
            mut as int64: head = 1
            mut as int64: tail = 1
            visited[u] = true
            mut as bool: connected = false

            infinite (head <= tail and not connected) {
                  mut as int64: curr = queue[head]
                  head = head + 1

                  route {
                        curr == v ==> {
                              connected = true
                              break
                        }
                        _ ==> {}
                  }

                  #L Explora vizinhos de curr atraves de arestas ativas
                  mut as int64: k = 1
                  infinite (k <= num_e) {
                        route {
                              edge_in_graph[k] ==> {
                                    mut as int64: nxt = 0
                                    route {
                                          edge_u[k] == curr ==> {
                                                nxt = edge_v[k]
                                          }
                                          edge_v[k] == curr ==> {
                                                nxt = edge_u[k]
                                          }
                                          _ ==> {}
                                    }

                                    route {
                                          nxt > 0 ==> {
                                                route {
                                                      not visited[nxt] ==> {
                                                            visited[nxt] = true
                                                            tail = tail + 1
                                                            queue[tail] = nxt
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
            }

            route {
                  connected ==> {
                        #L O grafo continua conexo sem a aresta -> A aresta pertencia a um ciclo, descarta definitivamente
                        edges_remaining = edges_remaining - 1
                        println("   Aresta (" + u + ", " + v + ", peso " + w + ") removida (pertencia a ciclo).")
                  }
                  _ ==> {
                        #L A aresta eh uma ponte! Deve ser mantida na MST
                        edge_in_graph[ei] = true
                        println("   Aresta (" + u + ", " + v + ", peso " + w + ") mantida (ponte essencial).")
                  }
            }

            ei = ei + 1
      }

      #L Coleta as arestas restantes na MST
      mut as int64: total_mst_weight = 0
      mut as list of int64: final_edges_u = []
      mut as list of int64: final_edges_v = []
      mut as list of int64: final_edges_w = []

      mut as int64: m = 1
      infinite (m <= num_e) {
            route {
                  edge_in_graph[m] ==> {
                        total_mst_weight = total_mst_weight + edge_w[m]
                        final_edges_u = listPushBack(final_edges_u, edge_u[m])
                        final_edges_v = listPushBack(final_edges_v, edge_v[m])
                        final_edges_w = listPushBack(final_edges_w, edge_w[m])
                  }
                  _ ==> {}
            }
            m = m + 1
      }

      println("4. Resultado da MST de Reverse-Delete:")
      println("   Arestas finais U: " + final_edges_u)
      println("   Arestas finais V: " + final_edges_v)
      println("   Pesos finais: " + final_edges_w)
      println("   Numero de arestas na MST: " + listLength(final_edges_u) + " / " + (num_v - 1))
      println("   Peso Total da MST: " + total_mst_weight)

      #L Verificacao de corretude
      mut as bool: valid_count = listLength(final_edges_u) == (num_v - 1)
      mut as bool: valid_weight = total_mst_weight == 13
      mut as bool: reverse_delete_ok = valid_count and valid_weight
      println("5. Verificacao da MST de Reverse-Delete: " + reverse_delete_ok)

      println("Concluido com Sucesso")
}
