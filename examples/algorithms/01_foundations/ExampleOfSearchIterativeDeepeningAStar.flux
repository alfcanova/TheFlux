#L ============================================================================
#L Algoritmo: Iterative Deepening A* (IDA*)
#L Dominio: 01_foundations / Categoria: 2. Busca
#L Complexidade: O(b^d) tempo | O(d) espaco linear
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSearchIterativeDeepeningAStar) {
      println("==================================================")
      println("  SciAlgo: Iterative Deepening A* (IDA*)")
      println("==================================================")

      #L Grafo ponderado com 6 vertices (0 = sem aresta)
      mut as list of list of int64: cost = [
            [0, 1, 4, 0, 0, 0],
            [0, 0, 0, 2, 5, 0],
            [0, 0, 0, 0, 1, 0],
            [0, 0, 0, 0, 0, 3],
            [0, 0, 0, 0, 0, 1],
            [0, 0, 0, 0, 0, 0]
      ]

      #L Heuristica admissivel h(n) ate o vertice 6
      mut as list of int64: h = [5, 4, 2, 3, 1, 0]

      mut as int64: start = 1
      mut as int64: goal = 6

      println("1. Origem: " + start + " | Destino: " + goal)
      println("2. Heuristica h: " + h)

      mut as int64: threshold = h[start]
      mut as bool: found = false
      mut as int64: optimal_cost = 0
      mut as int64: iteration = 0

      infinite (not found and threshold < 9999) {
            iteration = iteration + 1
            mut as int64: min_exceeded = 99999

            #L Busca em profundidade com limite de f = g + h
            #L Pilhas: [no, custo_g]
            mut as list of int64: st_node = [start]
            mut as list of int64: st_g = [0]

            infinite (listLength(st_node) > 0 and not found) {
                  mut as int64: top = listLength(st_node)
                  mut as int64: u = st_node[top]
                  mut as int64: g = st_g[top]

                  #L Desempilha
                  mut as list of int64: n_st_node = []
                  mut as list of int64: n_st_g = []
                  mut as int64: si = 1
                  infinite (si < top) {
                        n_st_node = listPushBack(n_st_node, st_node[si])
                        n_st_g = listPushBack(n_st_g, st_g[si])
                        si = si + 1
                  }
                  st_node = n_st_node
                  st_g = n_st_g

                  mut as int64: f = g + h[u]

                  route {
                        f > threshold ==> {
                              route {
                                    f < min_exceeded ==> {
                                          min_exceeded = f
                                    }
                              }
                        }
                        u == goal ==> {
                              found = true
                              optimal_cost = g
                              break
                        }
                        _ ==> {
                              #L Expande sucessores
                              mut as int64: v = 6
                              infinite (v >= 1) {
                                    mut as int64: edge_w = cost[u][v]
                                    route {
                                          edge_w > 0 ==> {
                                                st_node = listPushBack(st_node, v)
                                                st_g = listPushBack(st_g, g + edge_w)
                                          }
                                    }
                                    v = v - 1
                              }
                        }
                  }
            }

            println("  Iteracao " + iteration + " | Limiar f: " + threshold)
            route {
                  not found ==> {
                        threshold = min_exceeded
                  }
            }
      }

      println("3. Destino alcancado: " + found)
      println("4. Custo da solucao otima: " + optimal_cost)
      println("5. Iteracoes de limiar necessarias: " + iteration)
      println("6. Validacao: " + (found and optimal_cost == 6))
      println("==================================================")
}
