#L ============================================================================
#L Algoritmo: Johnson's Algorithm (APSP em Grafos Esparsos com Pesos Negativos)
#L Dominio: 03_graphs / Categoria: Caminhos minimos
#L Complexidade: O(V^2 log V + V * E) tempo | O(V^2) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosCaminhosMinimosJohnson) {
      println("==================================================")
      println("  SciAlgo: Johnson's Algorithm (Sparse APSP)      ")
      println("==================================================")

      mut as int64: num_v = 4
      mut as int64: inf_c = 999999

      #L Matriz de adjacencia com pesos (4x4). inf_c indica ausencia de aresta
      #L 1->2: -5
      #L 2->3: 4
      #L 1->3: 2
      #L 3->4: 1
      #L 4->1: 3
      mut as list of int64: weight = [
            0,     -5,    2,     inf_c,
            inf_c, 0,     4,     inf_c,
            inf_c, inf_c, 0,     1,
            3,     inf_c, inf_c, 0
      ]

      println("1. Grafo Direcionado com Pesos Negativos (4 Vertices):")
      println("   (1->2: -5), (2->3: 4), (1->3: 2), (3->4: 1), (4->1: 3)")

      #L ETAPA 1: Bellman-Ford a partir de super-no virtual para calcular potenciais h(v)
      mut as list of int64: h_pot = [0, 0, 0, 0]

      mut as int64: iter = 1
      mut as int64: u = 1
      mut as int64: v = 1
      mut as int64: w = 0
      mut as int64: i = 1
      mut as int64: j = 1

      infinite (iter < num_v) {
            u = 1
            infinite (u <= num_v) {
                  v = 1
                  infinite (v <= num_v) {
                        w = weight[(u - 1) * num_v + v]
                        route {
                              (w != inf_c) and (u != v) ==> {
                                    route {
                                          h_pot[u] + w < h_pot[v] ==> {
                                                h_pot[v] = h_pot[u] + w
                                          }
                                          _ ==> {}
                                    }
                              }
                              _ ==> {}
                        }
                        v = v + 1
                  }
                  u = u + 1
            }
            iter = iter + 1
      }

      println("2. Potenciais de Johnson h(v): [" + h_pot[1] + ", " + h_pot[2] + ", " + h_pot[3] + ", " + h_pot[4] + "]")

      #L ETAPA 2: Reponderacao das arestas w'(u, v) = w(u, v) + h(u) - h(v) >= 0
      mut as list of int64: reweighted = [
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0
      ]

      u = 1
      infinite (u <= num_v) {
            v = 1
            infinite (v <= num_v) {
                  w = weight[(u - 1) * num_v + v]
                  route {
                        (w != inf_c) and (u != v) ==> {
                              reweighted[(u - 1) * num_v + v] = w + h_pot[u] - h_pot[v]
                        }
                        _ ==> {
                              reweighted[(u - 1) * num_v + v] = inf_c
                        }
                  }
                  v = v + 1
            }
            u = u + 1
      }

      #L ETAPA 3: Executa Dijkstra para cada vertice usando os pesos reponderados
      mut as list of int64: final_dist = [
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0,
            0, 0, 0, 0
      ]

      mut as int64: s_node = 1
      infinite (s_node <= num_v) {
            mut as list of int64: d_prime = [inf_c, inf_c, inf_c, inf_c]
            mut as list of bool: vis = [false, false, false, false]
            d_prime[s_node] = 0

            mut as int64: step = 1
            infinite (step <= num_v) {
                  mut as int64: best_u = 0
                  mut as int64: min_d = inf_c
                  i = 1
                  infinite (i <= num_v) {
                        route {
                              (not vis[i]) and (d_prime[i] < min_d) ==> {
                                    min_d = d_prime[i]
                                    best_u = i
                              }
                              _ ==> {}
                        }
                        i = i + 1
                  }

                  route {
                        (best_u == 0) or (min_d >= inf_c) ==> {
                              step = num_v + 1
                        }
                        _ ==> {
                              vis[best_u] = true
                              v = 1
                              infinite (v <= num_v) {
                                    mut as int64: rw = reweighted[(best_u - 1) * num_v + v]
                                    route {
                                          rw != inf_c ==> {
                                                route {
                                                      d_prime[best_u] + rw < d_prime[v] ==> {
                                                            d_prime[v] = d_prime[best_u] + rw
                                                      }
                                                      _ ==> {}
                                                }
                                          }
                                          _ ==> {}
                                    }
                                    v = v + 1
                              }
                              step = step + 1
                        }
                  }
            }

            #L Restaura distancias originais: dist(s, v) = d'(s, v) - h(s) + h(v)
            v = 1
            infinite (v <= num_v) {
                  route {
                        s_node == v ==> {
                              final_dist[(s_node - 1) * num_v + v] = 0
                        }
                        d_prime[v] < inf_c ==> {
                              final_dist[(s_node - 1) * num_v + v] = d_prime[v] - h_pot[s_node] + h_pot[v]
                        }
                        _ ==> {
                              final_dist[(s_node - 1) * num_v + v] = inf_c
                        }
                  }
                  v = v + 1
            }

            s_node = s_node + 1
      }

      println("3. Matriz de Distancias Finais Calculada por Johnson:")
      i = 1
      infinite (i <= num_v) {
            println("   De " + i + ": [" + final_dist[(i - 1) * num_v + 1] + ", " + final_dist[(i - 1) * num_v + 2] + ", " + final_dist[(i - 1) * num_v + 3] + ", " + final_dist[(i - 1) * num_v + 4] + "]")
            i = i + 1
      }

      println("Johnson's Algorithm concluido com sucesso.")
}
