#L ============================================================================
#L Algoritmo: Graph Coloring (Coloracao Exata de Grafos e Numero Cromatico)
#L Dominio: 03_graphs / Categoria: 2. Grafos (Adicoes Prioritarias)
#L Complexidade: O(k^V) tempo pior caso com poda backtracking | O(V) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosGeralGraphColoring) {
      println("==================================================")
      println("  SciAlgo: Graph Coloring (Coloracao Exata)       ")
      println("==================================================")

      #L Grafo Roda W_5 (Wheel Graph):
      #L Vertice central 1 (hub) conectado a ciclo C_4 {2, 3, 4, 5}
      #L Arestas do hub: (1-2), (1-3), (1-4), (1-5)
      #L Arestas do ciclo: (2-3), (3-4), (4-5), (5-2)
      #L O ciclo C_4 precisa de 2 cores. O hub adjacente a todos exige uma 3a cor.
      #L Logo, o numero cromatico chi(W_5) eh exatamente 3.
      mut as int64: num_v = 5
      mut as int64: num_e = 8

      mut as list of int64: edge_u = [1, 1, 1, 1, 2, 3, 4, 5]
      mut as list of int64: edge_v = [2, 3, 4, 5, 3, 4, 5, 2]

      println("1. Grafo Roda W_5 (Hub 1 + Ciclo C_4 {2,3,4,5}):")
      println("   Vertices: " + num_v + ", Arestas: " + num_e)

      #L Matriz de adjacencia
      mut as list of int64: adj = []
      mut as int64: c = 1
      infinite (c <= num_v * num_v) {
            adj = listPushBack(adj, 0)
            c = c + 1
      }

      mut as int64: ei = 1
      infinite (ei <= num_e) {
            mut as int64: u = edge_u[ei]
            mut as int64: v = edge_v[ei]
            adj[(u - 1) * num_v + v] = 1
            adj[(v - 1) * num_v + u] = 1
            ei = ei + 1
      }

      #L ETAPA 1: Teste de viabilidade para k = 2 cores
      #L Busca iterativa de backtracking para colorir com k=2
      println("2. Testando k = 2 cores com Backtracking...")
      mut as list of int64: color2 = [0, 0, 0, 0, 0]
      mut as bool: sol_k2 = false
      mut as int64: node2 = 1

      infinite (node2 >= 1 and not sol_k2) {
            color2[node2] = color2[node2] + 1
            #L Encontra proxima cor valida <= 2
            mut as bool: valid_col = false
            infinite (color2[node2] <= 2 and not valid_col) {
                  #L Checa conflito com vizinhos
                  mut as bool: conflict = false
                  mut as int64: nbr = 1
                  infinite (nbr <= num_v and not conflict) {
                        route {
                              adj[(node2 - 1) * num_v + nbr] == 1 ==> {
                                    route {
                                          color2[nbr] == color2[node2] ==> {
                                                conflict = true
                                          }
                                          _ ==> {}
                                    }
                              }
                              _ ==> {}
                        }
                        nbr = nbr + 1
                  }

                  route {
                        not conflict ==> {
                              valid_col = true
                        }
                        _ ==> {
                              color2[node2] = color2[node2] + 1
                        }
                  }
            }

            route {
                  valid_col ==> {
                        route {
                              node2 == num_v ==> {
                                    sol_k2 = true
                                    break
                              }
                              _ ==> {
                                    node2 = node2 + 1
                                    color2[node2] = 0
                              }
                        }
                  }
                  _ ==> {
                        #L Backtrack
                        color2[node2] = 0
                        node2 = node2 - 1
                  }
            }
      }

      println("   Solucao encontrada com k = 2? " + sol_k2 + " (Inviavel pois chi > 2)")

      #L ETAPA 2: Teste de viabilidade para k = 3 cores
      println("3. Testando k = 3 cores com Backtracking...")
      mut as list of int64: color3 = [0, 0, 0, 0, 0]
      mut as bool: sol_k3 = false
      mut as int64: node3 = 1

      infinite (node3 >= 1 and not sol_k3) {
            color3[node3] = color3[node3] + 1
            mut as bool: valid_col3 = false
            infinite (color3[node3] <= 3 and not valid_col3) {
                  mut as bool: conflict3 = false
                  mut as int64: nbr3 = 1
                  infinite (nbr3 <= num_v and not conflict3) {
                        route {
                              adj[(node3 - 1) * num_v + nbr3] == 1 ==> {
                                    route {
                                          color3[nbr3] == color3[node3] ==> {
                                                conflict3 = true
                                          }
                                          _ ==> {}
                                    }
                              }
                              _ ==> {}
                        }
                        nbr3 = nbr3 + 1
                  }

                  route {
                        not conflict3 ==> {
                              valid_col3 = true
                        }
                        _ ==> {
                              color3[node3] = color3[node3] + 1
                        }
                  }
            }

            route {
                  valid_col3 ==> {
                        route {
                              node3 == num_v ==> {
                                    sol_k3 = true
                                    break
                              }
                              _ ==> {
                                    node3 = node3 + 1
                                    color3[node3] = 0
                              }
                        }
                  }
                  _ ==> {
                        color3[node3] = 0
                        node3 = node3 - 1
                  }
            }
      }

      println("   Solucao encontrada com k = 3? " + sol_k3)
      println("   Coloracao valida obtida: " + color3)

      #L Verificacao de corretude
      #L chi(G) deve ser 3: falso para k=2 e verdadeiro para k=3
      mut as bool: coloring_ok = (not sol_k2) and sol_k3
      println("4. Determinacao do Numero Cromatico chi(G) = 3: " + coloring_ok)

      println("Concluido com Sucesso")
}
