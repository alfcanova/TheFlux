#L ============================================================================
#L Algoritmo: Greedy Best-First Search (Busca Gulosa em Melhor Primeiro)
#L Dominio: 01_foundations / Categoria: 2. Busca
#L Complexidade: O(b^m) pior caso | O(b*m) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSearchBestFirst) {
      println("==================================================")
      println("  SciAlgo: Greedy Best-First Search")
      println("==================================================")

      #L Grafo dirigido com 6 vertices (matriz de adjacencia)
      mut as list of list of int64: adj = [
            [0, 1, 1, 0, 0, 0],
            [0, 0, 0, 1, 0, 0],
            [0, 0, 0, 1, 1, 0],
            [0, 0, 0, 0, 0, 1],
            [0, 0, 0, 0, 0, 1],
            [0, 0, 0, 0, 0, 0]
      ]

      #L Heuristica h(n) estimada ate o objetivo (vertice 6)
      mut as list of int64: h = [10, 8, 5, 7, 3, 0]

      mut as int64: start = 1
      mut as int64: goal = 6
      println("1. Origem: " + start + " | Destino: " + goal)
      println("2. Heuristica h(n): " + h)

      #L Lista aberta e lista fechada (visitados)
      mut as list of int64: open_set = [start]
      mut as list of int64: visited = [0, 0, 0, 0, 0, 0]
      mut as list of int64: path_taken = []

      mut as bool: reached = false

      infinite (listLength(open_set) > 0 and not reached) {
            #L Encontra no no open_set com menor heuristica h
            mut as int64: best_idx = 1
            mut as int64: best_node = open_set[1]
            mut as int64: min_h = h[best_node]

            mut as int64: idx = 2
            infinite (idx <= listLength(open_set)) {
                  mut as int64: cand = open_set[idx]
                  route {
                        h[cand] < min_h ==> {
                              min_h = h[cand]
                              best_node = cand
                              best_idx = idx
                        }
                  }
                  idx = idx + 1
            }

            #L Remove best_idx de open_set
            mut as list of int64: n_open = []
            mut as int64: rem_i = 1
            infinite (rem_i <= listLength(open_set)) {
                  route {
                        rem_i != best_idx ==> {
                              n_open = listPushBack(n_open, open_set[rem_i])
                        }
                  }
                  rem_i = rem_i + 1
            }
            open_set = n_open

            visited[best_node] = 1
            path_taken = listPushBack(path_taken, best_node)

            route {
                  best_node == goal ==> {
                        reached = true
                        break
                  }
            }

            #L Expande vizinhos nao visitados
            mut as int64: v = 1
            infinite (v <= 6) {
                  route {
                        adj[best_node][v] == 1 and visited[v] == 0 ==> {
                              #L Verifica se ja esta no open_set
                              mut as bool: in_open = false
                              mut as int64: oi = 1
                              infinite (oi <= listLength(open_set)) {
                                    route {
                                          open_set[oi] == v ==> {
                                                in_open = true
                                                break
                                          }
                                    }
                                    oi = oi + 1
                              }
                              route {
                                    not in_open ==> {
                                          open_set = listPushBack(open_set, v)
                                    }
                              }
                        }
                  }
                  v = v + 1
            }
      }

      println("3. Caminho percorrido pelo Best-First: " + path_taken)
      println("4. Destino alcancado: " + reached)
      println("5. Validacao: " + (reached and path_taken[listLength(path_taken)] == goal))
      println("==================================================")
}
