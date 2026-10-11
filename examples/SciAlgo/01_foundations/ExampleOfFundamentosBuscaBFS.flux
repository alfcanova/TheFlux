#L ============================================================================
#L Algoritmo: Breadth-First Search (BFS)
#L Dominio: 01_foundations / Categoria: 2. Busca
#L Complexidade: Tempo O(V + E) | Espaco O(V)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosBuscaBFS) {
      println("==================================================")
      println("  SciAlgo: Breadth-First Search (BFS)")
      println("==================================================")

      #L Grafo dirigido com 7 vertices (1..7):
      #L 1 -> 2, 3
      #L 2 -> 4, 5
      #L 3 -> 6, 7
      mut as int64: n = 7
      mut as list of list of int64: adj = [
            [2, 3],       #L Vertice 1
            [4, 5],       #L Vertice 2
            [6, 7],       #L Vertice 3
            [],           #L Vertice 4
            [],           #L Vertice 5
            [],           #L Vertice 6
            []            #L Vertice 7
      ]

      println("1. Estrutura do Grafo (7 vertices):")
      println("   1 -> [2, 3], 2 -> [4, 5], 3 -> [6, 7]")

      #L ======================================================================
      #L Experimento 1: Travessia BFS em largura a partir do vertice 1
      #L ======================================================================
      println("2. Executando travessia BFS por niveis a partir do vertice 1:")
      mut as list of int64: visited = [0, 0, 0, 0, 0, 0, 0]
      mut as list of int64: dist = [-1, -1, -1, -1, -1, -1, -1]
      mut as list of int64: queue = [1]
      mut as int64: head = 1

      visited[1] = 1
      dist[1] = 0

      mut as list of int64: visit_order = []

      infinite (head <= listLength(queue)) {
            #L Desenfileira elemento da frente (FIFO)
            mut as int64: u = queue[head]
            head = head + 1
            visit_order = listPushBack(visit_order, u)
            println("   -> Visitado vertice: " + u + " (distancia: " + dist[u] + ")")

            mut as list of int64: neighbors = adj[u]
            mut as int64: deg = listLength(neighbors)
            mut as int64: ni = 1
            infinite (ni <= deg) {
                  mut as int64: v = neighbors[ni]
                  route {
                        visited[v] == 0 ==> {
                              visited[v] = 1
                              dist[v] = dist[u] + 1
                              queue = listPushBack(queue, v)
                        }
                        _ ==> {}
                  }
                  ni = ni + 1
            }
      }

      println("3. Ordem de visitação BFS por largura:")
      mut as string: order_str = ""
      mut as int64: oi = 1
      infinite (oi <= listLength(visit_order)) {
            route {
                  oi == 1 ==> {
                        order_str = "" + visit_order[oi]
                  }
                  _ ==> {
                        order_str = order_str + " -> " + visit_order[oi]
                  }
            }
            oi = oi + 1
      }
      println("   Ordem: " + order_str)

      #L ======================================================================
      #L Experimento 2: Busca de menor caminho para alvo (Target = 6)
      #L ======================================================================
      mut as int64: target = 6
      println("4. Buscando menor caminho ate o vertice: " + target)

      mut as list of int64: parent = [0, 0, 0, 0, 0, 0, 0]
      mut as list of int64: vis_target = [0, 0, 0, 0, 0, 0, 0]
      mut as list of int64: q_search = [1]
      mut as int64: q_head = 1
      mut as bool: target_found = false

      vis_target[1] = 1

      infinite (q_head <= listLength(q_search) and (not target_found)) {
            mut as int64: curr = q_search[q_head]
            q_head = q_head + 1

            route {
                  curr == target ==> {
                        target_found = true
                  }
                  _ ==> {
                        mut as list of int64: nbrs = adj[curr]
                        mut as int64: n_deg = listLength(nbrs)
                        mut as int64: n_i = 1
                        infinite (n_i <= n_deg and (not target_found)) {
                              mut as int64: nxt = nbrs[n_i]
                              route {
                                    vis_target[nxt] == 0 ==> {
                                          vis_target[nxt] = 1
                                          parent[nxt] = curr
                                          q_search = listPushBack(q_search, nxt)
                                          route {
                                                nxt == target ==> {
                                                      target_found = true
                                                }
                                                _ ==> {}
                                          }
                                    }
                                    _ ==> {}
                              }
                              n_i = n_i + 1
                        }
                  }
            }
      }

      route {
            target_found ==> {
                  println("   [PASS] Alvo " + target + " alcancado com sucesso!")

                  #L Reconstrói menor caminho de 1 até target
                  mut as list of int64: path = []
                  mut as int64: curr_node = target
                  infinite (curr_node > 0) {
                        path = listPushBack(path, curr_node)
                        curr_node = parent[curr_node]
                  }

                  mut as string: path_str = ""
                  mut as int64: pi = listLength(path)
                  infinite (pi >= 1) {
                        route {
                              pi == listLength(path) ==> {
                                    path_str = "" + path[pi]
                              }
                              _ ==> {
                                    path_str = path_str + " -> " + path[pi]
                              }
                        }
                        pi = pi - 1
                  }
                  println("   Menor caminho percorrido: " + path_str)
                  println("   Distancia minima em arestas: " + (listLength(path) - 1))
            }
            _ ==> {
                  println("   [ERRO] Vertice alvo nao alcancado.")
            }
      }

      println("==================================================")
      println("BFS concluido com sucesso!")
}
