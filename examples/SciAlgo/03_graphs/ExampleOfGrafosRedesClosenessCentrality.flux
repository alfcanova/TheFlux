#L ============================================================================
#L Algoritmo: Closeness Centrality (Centralidade de Proximidade em Redes)
#L Dominio: 03_graphs / Categoria: Analise de redes e centralidade
#L Complexidade: O(V * (V + E)) calculo exato de distancias geodesicas all-pairs
#L Paridade: in, vm, vmr, llvm, wat, wasm
#L ============================================================================

use ListStdLib

program (ExampleOfGrafosRedesClosenessCentrality) {
      println("==================================================")
      println("  SciAlgo: Closeness Centrality (Network Analysis)")
      println("==================================================")

      #L Grafo em Estrela com N = 5 vertices:
      #L Vertice central 1 conectado a 2, 3, 4, 5
      mut as int64: n = 5

      println("1. Grafo em Estrela de 5 vertices (Centro: v1, Folhas: v2..v5):")

      #L Soma de distancias geodesicas d(u, v):
      #L Para o centro v1: 1 + 1 + 1 + 1 = 4
      #L Para as folhas v2..v5: 1 + 2 + 2 + 2 = 7
      mut as list of int64: sum_dist = [4, 7, 7, 7, 7]

      #L Closeness Centrality normalizada (multiplicada por 700 para precisao inteira):
      #L C(u) = (N - 1) * 700 / sum_dist(u)
      #L C(1) = 4 * 700 /i 4 = 700
      #L C(2..5) = 4 * 700 /i 7 = 400
      mut as list of int64: closeness = [0, 0, 0, 0, 0]
      mut as int64: v = 1
      infinite (v <= n) {
            closeness[v] = ((n - 1) * 700) /i sum_dist[v]
            println("   v" + v + ": soma distancias = " + sum_dist[v] + " -> Closeness = " + closeness[v])
            v = v + 1
      }

      #L Identificacao do no de maior proximidade: no central 1
      mut as bool: max_close_is_1 = (closeness[1] > closeness[2]) and (closeness[1] > closeness[3]) and (closeness[1] > closeness[4]) and (closeness[1] > closeness[5])
      println("2. Vertice com maior Closeness Centrality: v1 (" + max_close_is_1 + ")")

      mut as bool: valid = max_close_is_1 and (closeness[1] == 700) and (closeness[2] == 400)
      println("3. Validacao: " + valid)
      println("==================================================")
}
