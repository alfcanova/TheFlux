#L ============================================================================
#L Algoritmo: Depth-First Search (DFS)
#L Dominio: 01_foundations / Categoria: 2. Busca
#L Complexidade: Tempo O(V + E) | Espaco O(V)
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosBuscaDFS) {
      println("==================================================")
      println("  SciAlgo: Depth-First Search (DFS)")
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
      #L Experimento 1: Travessia DFS completa a partir do vertice 1
      #L ======================================================================
      println("2. Executando travessia DFS a partir do vertice 1:")
      mut as list of int64: visited = [0, 0, 0, 0, 0, 0, 0]
      mut as list of int64: stack = [1]
      mut as list of int64: visit_order = []

      infinite (listLength(stack) > 0) {
            #L Desempilha o topo (LIFO)
            mut as int64: top_idx = listLength(stack)
            mut as int64: u = stack[top_idx]

            #L Remove ultimo elemento da pilha
            mut as list of int64: new_stack = []
            mut as int64: si = 1
            infinite (si < top_idx) {
                  new_stack = listPushBack(new_stack, stack[si])
                  si = si + 1
            }
            stack = new_stack

            #L Processa u se ainda nao visitado
            route {
                  visited[u] == 0 ==> {
                        visited[u] = 1
                        visit_order = listPushBack(visit_order, u)
                        println("   -> Visitado vertice: " + u)

                        #L Empilha vizinhos em ordem reversa para explorar o primeiro vizinho antes
                        mut as list of int64: neighbors = adj[u]
                        mut as int64: deg = listLength(neighbors)
                        mut as int64: ni = deg
                        infinite (ni >= 1) {
                              mut as int64: v = neighbors[ni]
                              route {
                                    visited[v] == 0 ==> {
                                          stack = listPushBack(stack, v)
                                    }
                                    _ ==> {}
                              }
                              ni = ni - 1
                        }
                  }
                  _ ==> {}
            }
      }

      println("3. Ordem de visitação DFS completa:")
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
      #L Experimento 2: Busca por alvo com reconstrução de caminho (Target = 5)
      #L ======================================================================
      mut as int64: target = 5
      println("4. Buscando vertice alvo: " + target)

      mut as list of int64: parent = [0, 0, 0, 0, 0, 0, 0]
      mut as list of int64: visited_target = [0, 0, 0, 0, 0, 0, 0]
      mut as list of int64: search_stack = [1]
      mut as bool: found = false

      infinite (listLength(search_stack) > 0 and (not found)) {
            mut as int64: s_top = listLength(search_stack)
            mut as int64: curr = search_stack[s_top]

            mut as list of int64: next_stack = []
            mut as int64: s_idx = 1
            infinite (s_idx < s_top) {
                  next_stack = listPushBack(next_stack, search_stack[s_idx])
                  s_idx = s_idx + 1
            }
            search_stack = next_stack

            route {
                  visited_target[curr] == 0 ==> {
                        visited_target[curr] = 1
                        route {
                              curr == target ==> {
                                    found = true
                              }
                              _ ==> {
                                    mut as list of int64: nbrs = adj[curr]
                                    mut as int64: n_deg = listLength(nbrs)
                                    mut as int64: n_i = n_deg
                                    infinite (n_i >= 1) {
                                          mut as int64: nxt = nbrs[n_i]
                                          route {
                                                visited_target[nxt] == 0 ==> {
                                                      parent[nxt] = curr
                                                      search_stack = listPushBack(search_stack, nxt)
                                                }
                                                _ ==> {}
                                          }
                                          n_i = n_i - 1
                                    }
                              }
                        }
                  }
                  _ ==> {}
            }
      }

      route {
            found ==> {
                  println("   [PASS] Vertice alvo " + target + " encontrado com sucesso!")

                  #L Reconstrói o caminho de 1 até target
                  mut as list of int64: path = []
                  mut as int64: curr_node = target
                  infinite (curr_node > 0) {
                        path = listPushBack(path, curr_node)
                        curr_node = parent[curr_node]
                  }

                  #L Inverte o caminho
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
                  println("   Caminho percorrido: " + path_str)
            }
            _ ==> {
                  println("   [ERRO] Vertice alvo nao encontrado.")
            }
      }

      println("==================================================")
      println("DFS concluido com sucesso!")
}
