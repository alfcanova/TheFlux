#L ============================================================================
#L Algoritmo: D* (Dynamic A* de Anthony Stentz 1994)
#L Dominio: 01_foundations / Categoria: 2. Busca
#L Complexidade: O(V log V) na inicializacao | O(k log k) no replanejamento local
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfSearchDStar) {
      println("==================================================")
      println("  SciAlgo: D* (Dynamic A* Replanejamento)")
      println("==================================================")

      #L Grafo com 5 vertices
      #L Rota inicial 1: 1 -> 2 (peso 1), 2 -> 4 (peso 2), 4 -> 5 (peso 1) = Custo 4
      #L Rota alternativa 2: 1 -> 3 (peso 2), 3 -> 4 (peso 2), 4 -> 5 (peso 1) = Custo 5
      mut as list of list of int64: cost = [
            [0, 1, 2, 0, 0],
            [0, 0, 0, 2, 0],
            [0, 0, 0, 2, 0],
            [0, 0, 0, 0, 1],
            [0, 0, 0, 0, 0]
      ]

      mut as int64: start = 1
      mut as int64: goal = 5

      #L Custos ate o objetivo conhecidos inicialmente
      #L Distancias ate 5: h[5]=0, h[4]=1, h[2]=3, h[3]=3, h[1]=4
      mut as list of int64: h_cost = [4, 3, 3, 1, 0]
      println("1. Custo inicial da rota 1 -> 2 -> 4 -> 5: " + h_cost[start])

      #L Evento dinâmico: o robo detecta bloqueio na aresta (2 -> 4)
      println("2. Evento dinâmico detectado: Aresta (2, 4) bloqueada!")
      cost[2][4] = 999 #L Aresta bloqueada

      #L D* propaga o estado RAISE atraves do no 2
      h_cost[2] = 999

      #L Replanejamento local: reavalia sucessores a partir de 1
      mut as int64: best_v = 0
      mut as int64: min_new_cost = 9999
      mut as int64: v = 2
      infinite (v <= 3) {
            mut as int64: edge_w = cost[start][v]
            mut as int64: total = edge_w + h_cost[v]
            route {
                  total < min_new_cost ==> {
                        min_new_cost = total
                        best_v = v
                  }
            }
            v = v + 1
      }

      h_cost[start] = min_new_cost
      println("3. Nova rota replanejada pelo D* atraves do no: " + best_v)
      println("4. Novo custo otimo recalculado localmente: " + h_cost[start])
      println("5. Validacao: " + (best_v == 3 and h_cost[start] == 5))
      println("==================================================")
}
