#L ============================================================================
#L Algoritmo: Fringe Search (Franja Heuristica)
#L Dominio: 01_foundations / Busca
#L Complexidade: O(b^d) tempo | O(b*d) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosBuscaFringe) {
      println("==================================================")
      println("  SciAlgo: Fringe Search (Busca de Franja)        ")
      println("==================================================")

      #L Grafo com 5 vertices (origem: 1, destino: 5)
      #L Matriz de custos:
      #L 1->2 (1), 1->3 (4)
      #L 2->4 (2), 2->3 (2)
      #L 3->5 (3), 4->5 (1)
      mut as list of list of int64: cost = [
            [0, 1, 4, 0, 0],
            [0, 0, 2, 2, 0],
            [0, 0, 0, 0, 3],
            [0, 0, 0, 0, 1],
            [0, 0, 0, 0, 0]
      ]

      #L Heuristica admissivel h(u) ate o no 5
      mut as list of int64: h = [0, 4, 3, 2, 1, 0]
      mut as list of int64: g = [0, 0, 9999, 9999, 9999, 9999]

      mut as int64: start = 1
      mut as int64: goal = 5

      mut as list of int64: fringe = [start]
      mut as int64: flimit = h[start]
      mut as bool: found = false
      mut as int64: iterations = 0

      println("1. Origem: " + start + " | Destino: " + goal + " | Limite Inicial: " + flimit)

      infinite ((not found) and listLength(fringe) > 0 and iterations < 10) {
            iterations = iterations + 1
            mut as int64: fmin = 9999
            mut as list of int64: next_fringe = []
            mut as int64: idx = 1

            infinite (idx <= listLength(fringe)) {
                  mut as int64: u = fringe[idx]
                  mut as int64: f_val = g[u] + h[u]

                  route {
                        f_val > flimit ==> {
                              route {
                                    f_val < fmin ==> {
                                          fmin = f_val
                                    }
                              }
                              next_fringe = listPushBack(next_fringe, u)
                        }
                        u == goal ==> {
                              found = true
                              break
                        }
                        _ ==> {
                              #L Expande sucessores de u
                              mut as int64: v = 1
                              infinite (v <= 5) {
                                    mut as int64: w = cost[u][v]
                                    route {
                                          w > 0 ==> {
                                                mut as int64: new_g = g[u] + w
                                                route {
                                                      new_g < g[v] ==> {
                                                            g[v] = new_g
                                                            next_fringe = listPushBack(next_fringe, v)
                                                      }
                                                }
                                          }
                                    }
                                    v = v + 1
                              }
                        }
                  }
                  idx = idx + 1
            }

            fringe = next_fringe
            flimit = fmin
      }

      println("2. Custo do Caminho Otimo: " + g[goal])
      println("3. Iteracoes de Franja: " + iterations)
      #L Caminho otimo 1 -> 2 -> 4 -> 5 tem custo 1 + 2 + 1 = 4
      println("4. Validacao (Custo == 4): " + (g[goal] == 4))
      println("==================================================")
}
