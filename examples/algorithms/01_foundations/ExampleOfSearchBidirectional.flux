#L ============================================================================
#L Algoritmo: Bidirectional Search (Busca Bidirecional)
#L Dominio: 01_foundations / Categoria: 2. Busca
#L Complexidade: O(b^(d/2)) tempo | O(b^(d/2)) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSearchBidirectional) {
      println("==================================================")
      println("  SciAlgo: Bidirectional Search")
      println("==================================================")

      #L Grafo com 8 vertices (matriz de adjacencia 8x8)
      #L Arestas bidirecionais: 1-2, 1-3, 2-4, 3-5, 4-6, 5-6, 6-7, 7-8
      mut as list of list of int64: adj = [
            [0, 1, 1, 0, 0, 0, 0, 0],
            [1, 0, 0, 1, 0, 0, 0, 0],
            [1, 0, 0, 0, 1, 0, 0, 0],
            [0, 1, 0, 0, 0, 1, 0, 0],
            [0, 0, 1, 0, 0, 1, 0, 0],
            [0, 0, 0, 1, 1, 0, 1, 0],
            [0, 0, 0, 0, 0, 1, 0, 1],
            [0, 0, 0, 0, 0, 0, 1, 0]
      ]

      mut as int64: start = 1
      mut as int64: goal = 8
      println("1. Origem: " + start + " | Destino: " + goal)

      #L Filas para frente (fwd) e para trás (bwd)
      mut as list of int64: q_fwd = [start]
      mut as list of int64: q_bwd = [goal]

      #L Visitados (1 se visitado, 0 caso contrario)
      mut as list of int64: vis_fwd = [1, 0, 0, 0, 0, 0, 0, 0]
      mut as list of int64: vis_bwd = [0, 0, 0, 0, 0, 0, 0, 1]

      mut as int64: meet_node = 0
      mut as int64: head_fwd = 1
      mut as int64: head_bwd = 1

      infinite (head_fwd <= listLength(q_fwd) and head_bwd <= listLength(q_bwd)) {
            #L Expande 1 nivel da busca para frente
            mut as int64: u = q_fwd[head_fwd]
            head_fwd = head_fwd + 1

            mut as int64: v = 1
            infinite (v <= 8) {
                  route {
                        adj[u][v] == 1 ==> {
                              route {
                                    vis_bwd[v] == 1 ==> {
                                          meet_node = v
                                          break
                                    }
                              }
                              route {
                                    vis_fwd[v] == 0 ==> {
                                          vis_fwd[v] = 1
                                          q_fwd = listPushBack(q_fwd, v)
                                    }
                              }
                        }
                  }
                  v = v + 1
            }

            route {
                  meet_node > 0 ==> {
                        break
                  }
            }

            #L Expande 1 nivel da busca para tras
            mut as int64: ub = q_bwd[head_bwd]
            head_bwd = head_bwd + 1

            mut as int64: vb = 1
            infinite (vb <= 8) {
                  route {
                        adj[ub][vb] == 1 ==> {
                              route {
                                    vis_fwd[vb] == 1 ==> {
                                          meet_node = vb
                                          break
                                    }
                              }
                              route {
                                    vis_bwd[vb] == 0 ==> {
                                          vis_bwd[vb] = 1
                                          q_bwd = listPushBack(q_bwd, vb)
                                    }
                              }
                        }
                  }
                  vb = vb + 1
            }

            route {
                  meet_node > 0 ==> {
                        break
                  }
            }
      }

      println("2. Ponto de encontro das fronteiras: " + meet_node)
      println("3. Fila para frente percorrida: " + q_fwd)
      println("4. Fila reversa percorrida: " + q_bwd)
      println("5. Validacao: " + (meet_node > 0 and (meet_node == 6 or meet_node == 7 or meet_node == 4 or meet_node == 5)))
      println("==================================================")
}
