#L ============================================================================
#L Algoritmo: A* (A-Star Heuristic Search)
#L Dominio: 03_graphs / Categoria: Caminhos minimos
#L Complexidade: O(E) melhor caso, O(V log V) pior caso | O(V) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosCaminhosMinimosAStar) {
      println("==================================================")
      println("  SciAlgo: A* (A-Star Heuristic Shortest Path)    ")
      println("==================================================")

      mut as int64: num_v = 6
      mut as int64: start_node = 1
      mut as int64: goal_node = 6

      #L Coordenadas 2D (x, y) dos 6 vertices
      #L 1: (0, 0), 2: (1, 2), 3: (2, 0), 4: (2, 3), 5: (3, 1), 6: (4, 3)
      mut as list of int64: coord_x = [0, 1, 2, 2, 3, 4]
      mut as list of int64: coord_y = [0, 2, 0, 3, 1, 3]

      #L Matriz de pesos das arestas (6x6). -1 indica sem aresta
      #L (1->2: 3), (1->3: 2)
      #L (2->4: 2), (2->5: 4)
      #L (3->5: 2)
      #L (4->6: 3)
      #L (5->6: 4)
      mut as list of int64: weight = [
            -1,  3,  2, -1, -1, -1,
            -1, -1, -1,  2,  4, -1,
            -1, -1, -1, -1,  2, -1,
            -1, -1, -1, -1, -1,  3,
            -1, -1, -1, -1, -1,  4,
            -1, -1, -1, -1, -1, -1
      ]

      println("1. Grafo com Coordenadas 2D (Inicio: 1, Objetivo: 6)")

      #L Heuristica admissivel h(u) = Manhattan distance ate o objetivo
      mut as list of int64: h_val = [0, 0, 0, 0, 0, 0]
      mut as int64: i = 1
      infinite (i <= num_v) {
            mut as int64: dx = coord_x[goal_node] - coord_x[i]
            route {
                  dx < 0 ==> {
                        dx = 0 - dx
                  }
                  _ ==> {}
            }
            mut as int64: dy = coord_y[goal_node] - coord_y[i]
            route {
                  dy < 0 ==> {
                        dy = 0 - dy
                  }
                  _ ==> {}
            }
            h_val[i] = dx + dy
            i = i + 1
      }

      mut as list of int64: g_score = [999999, 999999, 999999, 999999, 999999, 999999]
      mut as list of int64: f_score = [999999, 999999, 999999, 999999, 999999, 999999]
      mut as list of bool: closed_set = [false, false, false, false, false, false]
      mut as list of bool: open_set = [false, false, false, false, false, false]
      mut as list of int64: parent = [0, 0, 0, 0, 0, 0]

      g_score[start_node] = 0
      f_score[start_node] = h_val[start_node]
      open_set[start_node] = true

      mut as bool: found = false
      mut as int64: current = 0
      mut as int64: min_f = 0
      mut as int64: v = 1
      mut as int64: w = 0

      infinite (not found) {
            #L Encontra no no open_set com menor f_score
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
                        found = true
                  }
                  _ ==> {
                        open_set[current] = false
                        closed_set[current] = true

                        v = 1
                        infinite (v <= num_v) {
                              w = weight[(current - 1) * num_v + v]
                              route {
                                    (w >= 0) and (not closed_set[v]) ==> {
                                          mut as int64: tentative_g = g_score[current] + w
                                          route {
                                                tentative_g < g_score[v] ==> {
                                                      parent[v] = current
                                                      g_score[v] = tentative_g
                                                      f_score[v] = tentative_g + h_val[v]
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

      println("2. Menor Custo ate o Objetivo Calculado pelo A*: " + g_score[goal_node])

      #L Reconstroi o caminho
      mut as list of int64: path = [0, 0, 0, 0, 0, 0]
      mut as int64: path_len = 0
      mut as int64: curr_p = goal_node
      infinite (curr_p != 0) {
            path_len = path_len + 1
            path[path_len] = curr_p
            curr_p = parent[curr_p]
      }

      println("3. Caminho Reconstruido (Destino para Origem):")
      i = 1
      infinite (i <= path_len) {
            println("   Passo " + i + ": No " + path[i])
            i = i + 1
      }

      println("A* concluido com sucesso.")
}
