#L ============================================================================
#L Algoritmo: Bidirectional Dijkstra (Dijkstra Bidirecional)
#L Dominio: 03_graphs / Categoria: Caminhos minimos
#L Complexidade: O(V^2) tempo | O(V) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosCaminhosMinimosBidirectionalDijkstra) {
      println("==================================================")
      println("  SciAlgo: Bidirectional Dijkstra                 ")
      println("==================================================")

      mut as int64: num_v = 5
      mut as int64: src = 1
      mut as int64: target = 5

      #L Matriz de pesos 5x5
      #L 1->2 (4), 1->3 (2)
      #L 2->3 (1), 2->4 (5)
      #L 3->4 (8), 3->5 (10)
      #L 4->5 (2)
      mut as list of int64: weight = [
            0, 4, 2, 0, 0,
            0, 0, 1, 5, 0,
            0, 0, 0, 8, 10,
            0, 0, 0, 0, 2,
            0, 0, 0, 0, 0
      ]

      println("1. Busca Bidirecional de " + src + " ate " + target)

      mut as list of int64: dist_f = [999999, 999999, 999999, 999999, 999999]
      mut as list of int64: dist_b = [999999, 999999, 999999, 999999, 999999]
      mut as list of bool: vis_f = [false, false, false, false, false]
      mut as list of bool: vis_b = [false, false, false, false, false]

      dist_f[src] = 0
      dist_b[target] = 0

      mut as int64: mu = 999999 #L menor distancia encontrada entre as fronteiras
      mut as bool: finished = false

      mut as int64: i = 1
      mut as int64: u = 0
      mut as int64: v = 0
      mut as int64: min_d = 0

      infinite (not finished) {
            #L PASSO FRENTE: Encontra vertice com menor dist_f
            u = 0
            min_d = 999999
            i = 1
            infinite (i <= num_v) {
                  route {
                        (not vis_f[i]) and (dist_f[i] < min_d) ==> {
                              min_d = dist_f[i]
                              u = i
                        }
                        _ ==> {}
                  }
                  i = i + 1
            }

            route {
                  (u == 0) or (min_d >= 999999) ==> {
                        finished = true
                  }
                  _ ==> {
                        vis_f[u] = true
                        #L Relaxa arestas para frente
                        v = 1
                        infinite (v <= num_v) {
                              mut as int64: w = weight[(u - 1) * num_v + v]
                              route {
                                    w > 0 ==> {
                                          route {
                                                dist_f[u] + w < dist_f[v] ==> {
                                                      dist_f[v] = dist_f[u] + w
                                                }
                                                _ ==> {}
                                          }
                                          #L Verifica conexao com fronteira reversa
                                          route {
                                                dist_f[u] + w + dist_b[v] < mu ==> {
                                                      mu = dist_f[u] + w + dist_b[v]
                                                }
                                                _ ==> {}
                                          }
                                    }
                                    _ ==> {}
                              }
                              v = v + 1
                        }
                  }
            }

            #L PASSO TRAS: Encontra vertice com menor dist_b
            u = 0
            min_d = 999999
            i = 1
            infinite (i <= num_v) {
                  route {
                        (not vis_b[i]) and (dist_b[i] < min_d) ==> {
                              min_d = dist_b[i]
                              u = i
                        }
                        _ ==> {}
                  }
                  i = i + 1
            }

            route {
                  (u == 0) or (min_d >= 999999) ==> {
                        finished = true
                  }
                  _ ==> {
                        vis_b[u] = true
                        #L Relaxa arestas reversas (arestas v -> u)
                        v = 1
                        infinite (v <= num_v) {
                              mut as int64: w = weight[(v - 1) * num_v + u]
                              route {
                                    w > 0 ==> {
                                          route {
                                                dist_b[u] + w < dist_b[v] ==> {
                                                      dist_b[v] = dist_b[u] + w
                                                }
                                                _ ==> {}
                                          }
                                          #L Verifica conexao com fronteira direta
                                          route {
                                                dist_f[v] + w + dist_b[u] < mu ==> {
                                                      mu = dist_f[v] + w + dist_b[u]
                                                }
                                                _ ==> {}
                                          }
                                    }
                                    _ ==> {}
                              }
                              v = v + 1
                        }
                  }
            }

            #L Criterio de parada: se as fronteiras se encontraram
            route {
                  (vis_f[target]) or (vis_b[src]) ==> {
                        finished = true
                  }
                  _ ==> {}
            }
      }

      println("2. Menor Distancia entre " + src + " e " + target + ": " + mu)
      println("Bidirectional Dijkstra concluido com sucesso.")
}
