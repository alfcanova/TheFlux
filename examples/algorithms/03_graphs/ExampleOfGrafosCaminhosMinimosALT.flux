#L ============================================================================
#L Algoritmo: ALT (A*, Landmarks e Desigualdade Triangular)
#L Dominio: 03_graphs / Categoria: Caminhos minimos
#L Complexidade: Preprocessamento O(L * (E + V log V)) | Consulta muito rapida
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosCaminhosMinimosALT) {
      println("==================================================")
      println("  SciAlgo: ALT Algorithm (Landmarks & Heuristics) ")
      println("==================================================")

      mut as int64: num_v = 6
      mut as int64: start_node = 2
      mut as int64: goal_node = 5

      #L Matriz de distancias reais do grafo (6x6)
      #L Arestas bidirecionadas:
      #L (1-2: 3), (2-3: 4), (3-4: 2), (4-5: 3), (5-6: 4)
      #L (2-4: 8), (1-3: 6)
      mut as list of int64: weight = [
            0, 3, 6, 0, 0, 0,
            3, 0, 4, 8, 0, 0,
            6, 4, 0, 2, 0, 0,
            0, 8, 2, 0, 3, 0,
            0, 0, 0, 3, 0, 4,
            0, 0, 0, 0, 4, 0
      ]

      println("1. Grafo com 6 Vertices. Consulta ALT de " + start_node + " ate " + goal_node)

      #L Pre-processamento: Marcos (Landmarks) L1 = 1 e L2 = 6
      #L Distancias exatas pre-computadas de L1 (1) e L2 (6) ate cada vertice:
      #L dist_from_L1: [0, 3, 6, 8, 11, 15]
      #L dist_from_L2: [15, 12, 9, 7, 4, 0]
      mut as list of int64: d_l1 = [0, 3, 6, 8, 11, 15]
      mut as list of int64: d_l2 = [15, 12, 9, 7, 4, 0]

      println("2. Pre-processamento: Distancias pre-computadas aos marcos 1 e 6.")

      #L Heuristica ALT para a consulta ate goal_node (5):
      #L h(u) = max( |d_l1[u] - d_l1[goal]|, |d_l2[u] - d_l2[goal]| )
      mut as list of int64: h_alt = [0, 0, 0, 0, 0, 0]
      mut as int64: i = 1
      infinite (i <= num_v) {
            mut as int64: h1 = d_l1[i] - d_l1[goal_node]
            route {
                  h1 < 0 ==> {
                        h1 = 0 - h1
                  }
                  _ ==> {}
            }
            mut as int64: h2 = d_l2[i] - d_l2[goal_node]
            route {
                  h2 < 0 ==> {
                        h2 = 0 - h2
                  }
                  _ ==> {}
            }
            mut as int64: best_h = h1
            route {
                  h2 > best_h ==> {
                        best_h = h2
                  }
                  _ ==> {}
            }
            h_alt[i] = best_h
            i = i + 1
      }

      println("3. Valores da Heuristica Admissivel ALT: [" + h_alt[1] + ", " + h_alt[2] + ", " + h_alt[3] + ", " + h_alt[4] + ", " + h_alt[5] + ", " + h_alt[6] + "]")

      #L Busca A* orientada por marcos (ALT Query)
      mut as list of int64: g_score = [999999, 999999, 999999, 999999, 999999, 999999]
      mut as list of int64: f_score = [999999, 999999, 999999, 999999, 999999, 999999]
      mut as list of bool: open_set = [false, false, false, false, false, false]
      mut as list of bool: closed = [false, false, false, false, false, false]

      g_score[start_node] = 0
      f_score[start_node] = h_alt[start_node]
      open_set[start_node] = true

      mut as bool: reached = false
      mut as int64: current = 0
      mut as int64: min_f = 0
      mut as int64: v = 1
      mut as int64: w = 0

      infinite (not reached) {
            current = 0
            min_f = 999999
            i = 1
            infinite (i <= num_v) {
                  route {
                        open_set[i] and (f_score[i] < min_f) ==> {
                              min_f = f_score[i]
                              current = i
                        }
                        _ ==> {}
                  }
                  i = i + 1
            }

            route {
                  (current == 0) or (current == goal_node) ==> {
                        reached = true
                  }
                  _ ==> {
                        open_set[current] = false
                        closed[current] = true

                        v = 1
                        infinite (v <= num_v) {
                              w = weight[(current - 1) * num_v + v]
                              route {
                                    (w > 0) and (not closed[v]) ==> {
                                          mut as int64: tentative_g = g_score[current] + w
                                          route {
                                                tentative_g < g_score[v] ==> {
                                                      g_score[v] = tentative_g
                                                      f_score[v] = tentative_g + h_alt[v]
                                                      open_set[v] = true
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
      }

      println("4. Menor Distancia Obtida via ALT: " + g_score[goal_node])
      println("ALT Algorithm concluido com sucesso.")
}
