#L ============================================================================
#L Algoritmo: Uniform-Cost Search (UCS / Busca de Custo Uniforme)
#L Dominio: 01_foundations / Categoria: 2. Busca
#L Complexidade: O(b^(1 + C*/eps)) tempo | O(b^(1 + C*/eps)) espaco
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfFundamentosBuscaUniformCost) {
      println("==================================================")
      println("  SciAlgo: Uniform-Cost Search (UCS)")
      println("==================================================")

      #L Matriz de adjacencia com pesos (6 vertices; 0 = sem aresta)
      mut as list of list of int64: cost = [
            [0, 2, 5, 0, 0, 0],
            [0, 0, 0, 4, 1, 0],
            [0, 0, 0, 0, 2, 0],
            [0, 0, 0, 0, 0, 2],
            [0, 0, 0, 0, 0, 3],
            [0, 0, 0, 0, 0, 0]
      ]

      mut as int64: start = 1
      mut as int64: goal = 6
      println("1. Origem: " + start + " | Destino: " + goal)

      #L Vetor de custos minimos conhecidos g(n), infinito inicial = 99999
      mut as list of int64: g_cost = [0, 99999, 99999, 99999, 99999, 99999]
      mut as list of int64: visited = [0, 0, 0, 0, 0, 0]

      mut as bool: reached = false
      mut as int64: steps = 0

      infinite (not reached) {
            steps = steps + 1
            #L Seleciona o vertice nao-visitado com menor custo g
            mut as int64: u = 0
            mut as int64: min_val = 99999
            mut as int64: i = 1
            infinite (i <= 6) {
                  route {
                        visited[i] == 0 and g_cost[i] < min_val ==> {
                              min_val = g_cost[i]
                              u = i
                        }
                  }
                  i = i + 1
            }

            route {
                  u == 0 ==> {
                        #L Nenhum vertice alcancavel restante
                        break
                  }
                  u == goal ==> {
                        reached = true
                        break
                  }
            }

            visited[u] = 1

            #L Relaxa arestas saindo de u
            mut as int64: v = 1
            infinite (v <= 6) {
                  mut as int64: edge_w = cost[u][v]
                  route {
                        edge_w > 0 and visited[v] == 0 ==> {
                              mut as int64: new_cost = g_cost[u] + edge_w
                              route {
                                    new_cost < g_cost[v] ==> {
                                          g_cost[v] = new_cost
                                    }
                              }
                        }
                  }
                  v = v + 1
            }
      }

      println("2. Custo minimo encontrado ate o destino: " + g_cost[goal])
      println("3. Custos acumulados g(n): " + g_cost)
      println("4. Passos de expansao: " + steps)
      println("5. Validacao (custo otimo == 6): " + (g_cost[goal] == 6))
      println("==================================================")
}
