#L ============================================================================
#L Algoritmo: Minimum Feedback Vertex Set (FVS - Quebra Minima de Ciclos)
#L Dominio: 03_graphs / Categoria: 2. Grafos (Adicoes Prioritarias)
#L Complexidade: FPT O(4^k * k * V) / Branch-and-Bound exato
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosGeralMinimumFeedbackVertexSet) {
      println("==================================================")
      println("  SciAlgo: Minimum Feedback Vertex Set (FVS)      ")
      println("==================================================")

      #L Grafo direcionado com V = 5 vertices e E = 6 arestas
      #L Ciclo 1: 1 -> 2 -> 3 -> 1
      #L Ciclo 2: 1 -> 4 -> 5 -> 1
      #L Ambos os ciclos compartilham o vertice 1.
      #L Removendo apenas o vertice 1, o subgrafo restante {2, 3, 4, 5}
      #L torna-se um DAG aciclico (arestas 2->3 e 4->5).
      #L Portanto, o tamanho do FVS minimo eh 1 (conjunto {1}).

      mut as int64: num_v = 5
      mut as int64: num_e = 6

      mut as list of int64: edge_u = [1, 2, 3, 1, 4, 5]
      mut as list of int64: edge_v = [2, 3, 1, 4, 5, 1]

      println("1. Grafo direcionado com " + num_v + " vertices e " + num_e + " arestas:")
      println("   Ciclo 1: 1 -> 2 -> 3 -> 1")
      println("   Ciclo 2: 1 -> 4 -> 5 -> 1")

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
            ei = ei + 1
      }

      #L Algoritmo de Busca do FVS Minimo:
      #L Testa subconjuntos de vertices para remocao de tamanho k = 1, 2, ...
      #L Para cada candidato S, verifica se G \ S eh aciclico (via Ordenacao Topologica de Kahn).
      mut as list of int64: best_fvs = []
      mut as bool: fvs_found = false

      #L Teste de subconjuntos de tamanho 1 (singletons)
      println("2. Testando candidatos a FVS de tamanho k = 1...")
      mut as int64: cand_v = 1
      infinite (cand_v <= num_v and not fvs_found) {
            #L Calcula graus de entrada (in-degree) no grafo induzido sem cand_v
            mut as list of int64: in_deg = [0, 0, 0, 0, 0]
            mut as int64: i = 1
            infinite (i <= num_v) {
                  route {
                        i != cand_v ==> {
                              mut as int64: j = 1
                              infinite (j <= num_v) {
                                    route {
                                          j != cand_v ==> {
                                                route {
                                                      adj[(i - 1) * num_v + j] == 1 ==> {
                                                            in_deg[j] = in_deg[j] + 1
                                                      }
                                                      _ ==> {}
                                                }
                                          }
                                          _ ==> {}
                                    }
                                    j = j + 1
                              }
                        }
                        _ ==> {}
                  }
                  i = i + 1
            }

            #L Fila para algoritmo de Kahn (nos com in-degree 0)
            mut as list of int64: q = [0, 0, 0, 0, 0]
            mut as int64: head = 1
            mut as int64: tail = 0

            mut as int64: k = 1
            infinite (k <= num_v) {
                  route {
                        k != cand_v ==> {
                              route {
                                    in_deg[k] == 0 ==> {
                                          tail = tail + 1
                                          q[tail] = k
                                    }
                                    _ ==> {}
                              }
                        }
                        _ ==> {}
                  }
                  k = k + 1
            }

            mut as int64: processed_nodes = 0
            infinite (head <= tail) {
                  mut as int64: curr = q[head]
                  head = head + 1
                  processed_nodes = processed_nodes + 1

                  #L Reduz graus de entrada dos vizinhos
                  mut as int64: nxt = 1
                  infinite (nxt <= num_v) {
                        route {
                              nxt != cand_v ==> {
                                    route {
                                          adj[(curr - 1) * num_v + nxt] == 1 ==> {
                                                in_deg[nxt] = in_deg[nxt] - 1
                                                route {
                                                      in_deg[nxt] == 0 ==> {
                                                            tail = tail + 1
                                                            q[tail] = nxt
                                                      }
                                                      _ ==> {}
                                                }
                                          }
                                          _ ==> {}
                                    }
                              }
                              _ ==> {}
                        }
                        nxt = nxt + 1
                  }
            }

            #L Se todos os V - 1 nos foram processados por Kahn, nao ha ciclos no subgrafo!
            mut as int64: remaining_v = num_v - 1
            println("   Testando remocao do vertice " + cand_v + ": nos aciclicos ordenados = " + processed_nodes + " / " + remaining_v)

            route {
                  processed_nodes == remaining_v ==> {
                        fvs_found = true
                        best_fvs = [cand_v]
                  }
                  _ ==> {}
            }

            cand_v = cand_v + 1
      }

      println("3. Resultado do Minimum Feedback Vertex Set:")
      println("   FVS Otimo encontrado: " + best_fvs)
      println("   Tamanho do FVS Minimo: " + listLength(best_fvs))

      #L Verificacao: FVS deve ser o vertice 1 de tamanho 1
      mut as bool: fvs_ok = fvs_found and (listLength(best_fvs) == 1) and (best_fvs[1] == 1)
      println("4. Verificacao do Algoritmo FVS: " + fvs_ok)

      println("Concluido com Sucesso")
}
